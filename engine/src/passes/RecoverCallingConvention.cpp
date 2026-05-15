/// @file RecoverCallingConvention.cpp
/// @brief Calling convention recovery pass.
///
/// Implements Win64 and SysV x86-64 ABI recovery:
///   - Identifies argument registers (RCX, RDX, R8, R9 for Win64;
///     RDI, RSI, RDX, RCX, R8, R9 for SysV)
///   - Folds register writes that set up call arguments into helix_high.call ops
///   - Names return values (RAX for integer, XMM0 for float)
///   - Marks callee-saved register restores as dead
///
/// NOTE: DominanceInfo is intentionally not used for block scanning here.
/// domInfo.getNode() crashes on certain IR patterns (massive single-block
/// functions, nested regions) in MLIR 18.x. The block scan + predecessor
/// search covers all common calling convention patterns without dominator trees.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/analysis/X86RegisterInfo.h"
#include "helix/analysis/SignatureDb.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"

#include <array>
#include <algorithm>
#include <format>
#include <string>
#include <string_view>

using namespace mlir;
using namespace helix;

namespace {

/// Win64 integer argument registers in order.
constexpr std::array<std::string_view, 4> kWin64IntArgs = {
    "RCX", "RDX", "R8", "R9"
};

/// SysV x86-64 integer argument registers in order.
constexpr std::array<std::string_view, 6> kSysVIntArgs = {
    "RDI", "RSI", "RDX", "RCX", "R8", "R9"
};

/// Callee-saved registers (Win64).
constexpr std::array<std::string_view, 7> kWin64CalleeSaved = {
    "RBX", "RBP", "RDI", "RSI", "R12", "R13", "R14"
};

/// Callee-saved registers (SysV).
constexpr std::array<std::string_view, 5> kSysVCalleeSaved = {
    "RBX", "RBP", "R12", "R13", "R14"
};

/// Determines ABI convention from context (default to Win64 on Windows).
/// `Cdecl32` is the x86 (32-bit) Windows default — all integer arguments on
/// the stack, no register arg slots.  Used for legacy PE binaries like
/// GTA San Andreas (`target triple = "i386-unknown-windows-msvc-coff"`).
/// x86 Linux also defaults to cdecl for the same reason (stack-only args).
enum class CallingConv { Win64, SysV, Cdecl32 };

static uint32_t getNextAvailableVarId(helix::low::FuncOp func) {
    uint32_t nextId = 0;
    func.walk([&](helix::high::VarDeclOp decl) {
        nextId = std::max(nextId, decl.getVarId() + 1);
    });
    return nextId;
}

static bool isReturnRegisterWrite(Operation& op) {
    auto regWrite = dyn_cast<helix::low::RegWriteOp>(&op);
    if (!regWrite)
        return false;

    return helix::analysis::isX86GeneralPurposeReturnRegister(
               regWrite.getRegName()) ||
           regWrite.getRegName().upper() == "XMM0";
}

static bool hasReturnRegisterWriteInBlock(
    Block* block, Block::iterator endIt) {
    if (!block)
        return false;

    for (auto it = endIt; it != block->begin();) {
        --it;
        if (isReturnRegisterWrite(*it))
            return true;

        if (isa<helix::low::CallOp>(&*it))
            return false;
    }

    return false;
}

static std::optional<Value> findLatestRegWriteInBlock(
    Block* block, Block::iterator endIt, llvm::StringRef canonicalReg) {
    if (!block)
        return std::nullopt;

    for (auto it = endIt; it != block->begin();) {
        --it;
        auto regWrite = dyn_cast<helix::low::RegWriteOp>(&*it);
        if (!regWrite)
            continue;

        auto lookup =
            helix::analysis::getCanonicalX86Register(regWrite.getRegName());
        if (lookup.empty())
            lookup = regWrite.getRegName();
        if (lookup == canonicalReg)
            return regWrite.getValue();
    }

    return std::nullopt;
}

static std::optional<Value> findLatestRegWriteInPredecessors(
    Block* block, llvm::StringRef canonicalReg, unsigned depth,
    llvm::DenseSet<Block*>& visiting) {
    if (!block || depth == 0 || !visiting.insert(block).second)
        return std::nullopt;

    std::optional<Value> candidate;
    for (Block* pred : block->getPredecessors()) {
        auto value = findLatestRegWriteInBlock(pred, pred->end(), canonicalReg);
        if (!value) {
            value = findLatestRegWriteInPredecessors(
                pred, canonicalReg, depth - 1, visiting);
        }
        if (!value) {
            visiting.erase(block);
            return std::nullopt;
        }
        if (candidate && *candidate != *value) {
            visiting.erase(block);
            return std::nullopt;
        }
        candidate = *value;
    }

    visiting.erase(block);
    return candidate;
}

/// Collect argument values for a call by scanning the block before `beforeOp`
/// and predecessor blocks. Does not use DominanceInfo (which can crash on
/// large/unusual IR in MLIR 18.x); the block scan + predecessor search covers
/// all common ABI call patterns.
static llvm::SmallVector<Value, 6> collectAbiCallArgs(
    Operation* beforeOp, llvm::ArrayRef<std::string_view> argRegs,
    unsigned predecessorDepth = 2) {
    auto* block = beforeOp ? beforeOp->getBlock() : nullptr;
    if (!block)
        return {};

    // Build a map of the most recent register write before beforeOp.
    // IMPORTANT: Reset state at every call barrier (previous call clobbers
    // all ABI arg registers per the SysV/Win64 contract).  Without this,
    // stale RSI/RDX/RCX values from an earlier call bleed into the current
    // call's arg list, producing spurious extra args like
    // `mutex_unlock(var_70, _promoted_0, 0xA0D, rsp)` when only the first
    // arg is real.
    llvm::DenseMap<llvm::StringRef, Value> regState;
    for (auto& op : block->getOperations()) {
        if (&op == beforeOp)
            break;

        // Call barrier: any previous call clobbers caller-saved registers
        // (which includes every ABI arg register on both Win64 and SysV).
        // Drop the recorded state so we only collect args written by the
        // code between the previous call and this one.
        if (isa<helix::low::CallOp>(&op)) {
            regState.clear();
            continue;
        }

        auto regWrite = dyn_cast<helix::low::RegWriteOp>(&op);
        if (!regWrite)
            continue;

        auto lookup =
            helix::analysis::getCanonicalX86Register(regWrite.getRegName());
        if (lookup.empty())
            lookup = regWrite.getRegName();
        regState[lookup] = regWrite.getValue();
    }

    // Collect arg values in positional order.  Stop at the first argReg
    // that wasn't written since the most recent call barrier — positional
    // ABIs can't have holes (you can't pass arg2 without arg1).
    llvm::SmallVector<Value, 6> argValues;
    bool anyFromCurrentBlock = !regState.empty();

    for (auto argReg : argRegs) {
        llvm::StringRef key(argReg);
        auto it = regState.find(key);
        if (it == regState.end()) {
            if (anyFromCurrentBlock) {
                // We saw writes to other arg regs in this block after the
                // last call barrier, but not this one — positional ABI
                // means further args are also absent.  Stop here.
                break;
            }
            // Empty current-block state: fall back to predecessor scan.
            llvm::DenseSet<Block*> visiting;
            auto fromPreds = findLatestRegWriteInPredecessors(
                block, key, predecessorDepth, visiting);
            if (!fromPreds)
                break;
            regState[key] = *fromPreds;
            it = regState.find(key);
        }
        argValues.push_back(it->second);
    }

    return argValues;
}

struct RecoverCallingConventionPass
    : public PassWrapper<RecoverCallingConventionPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RecoverCallingConventionPass)

    StringRef getArgument() const final { return "recover-calling-convention"; }
    StringRef getDescription() const final {
        return "Recover calling convention (Win64/SysV) and fold arguments into calls";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<helix::high::HelixHighDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();

        module.walk([&](helix::low::FuncOp func) {
            recoverCC(func);
        });
    }

private:
    void recoverCC(helix::low::FuncOp func) {
        // Detect ABI from module's target triple.  Detection priority:
        //   1. 32-bit x86 markers (`i386`/`i686`/`i486`/`i586`) → Cdecl32
        //      (all args on the stack, no register args).  This catches both
        //      x86 Windows PE (`i386-unknown-windows-msvc-coff`, e.g. GTA-SA)
        //      AND x86 Linux/BSD ELF — both use stack-based args by default.
        //   2. Otherwise, 64-bit Unix-family OSes → SysV.
        //   3. Otherwise (default for 64-bit Windows and anything else) → Win64.
        CallingConv cc = CallingConv::Win64; // default fallback
        auto module = func->getParentOfType<ModuleOp>();
        if (module) {
            if (auto triple = module->getAttrOfType<StringAttr>("llvm.target_triple")) {
                auto t = triple.getValue();
                llvm::errs() << "[P0-DEBUG] RecoverCC: triple='" << t << "'\n";
                const bool is32BitX86 =
                    t.contains("i386") || t.contains("i486") ||
                    t.contains("i586") || t.contains("i686");
                if (is32BitX86) {
                    cc = CallingConv::Cdecl32;
                } else if (t.contains("linux") || t.contains("elf") ||
                           t.contains("gnu") || t.contains("freebsd") ||
                           t.contains("openbsd")) {
                    cc = CallingConv::SysV;
                } else if (t.contains("darwin") || t.contains("macho")) {
                    cc = CallingConv::SysV; // macOS also uses SysV on x86_64
                }
            } else {
                llvm::errs() << "[P0-DEBUG] RecoverCC: NO llvm.target_triple on module\n";
            }
        } else {
            llvm::errs() << "[P0-DEBUG] RecoverCC: FuncOp has no parent ModuleOp!\n";
        }
        const char* ccDebugName =
            (cc == CallingConv::Win64)   ? "Win64"   :
            (cc == CallingConv::SysV)    ? "SysV"    :
            /* Cdecl32 */                  "Cdecl32";
        llvm::errs() << "[P0-DEBUG] RecoverCC: using " << ccDebugName << "\n";

        // x86 cdecl has zero argument registers — everything is on the stack.
        // Leaving `argRegs` empty causes Phase 1/Phase 3 register-arg recovery
        // to find nothing, which is the correct behaviour (stack-frame access
        // is recovered by RecoverStackLayout instead).
        static constexpr std::array<std::string_view, 0> kCdecl32IntArgs = {};
        llvm::ArrayRef<std::string_view> argRegs;
        switch (cc) {
        case CallingConv::Win64:   argRegs = kWin64IntArgs;   break;
        case CallingConv::SysV:    argRegs = kSysVIntArgs;    break;
        case CallingConv::Cdecl32: argRegs = kCdecl32IntArgs; break;
        }

        // --- Win64 entry-point detection ---
        // PE entry-point functions (start, hc_entry, Remill's generic
        // "entry_point", etc.) receive their argument registers from the OS
        // loader, not from calls within the binary.  The early reads of
        // RCX/RDX/R8/R9 in their bodies are obfuscation / OS-set values, NOT
        // meaningful named parameters.  Skip Phase 1+2 for these functions to
        // prevent phantom param declarations.
        bool skipParamInference = false;
        if (cc == CallingConv::Win64 && module) {
            const llvm::StringRef funcName = func.getName();

            // 1. Name-based: known zero-arg PE entry-point symbols.
            static constexpr std::array<std::string_view, 8> kNoArgEntryNames = {
                "entry_point", "hc_entry", "start", "_start",
                "mainCRTStartup", "wmainCRTStartup",
                "_mainCRTStartup", "_wmainCRTStartup",
            };
            for (auto name : kNoArgEntryNames) {
                if (funcName == llvm::StringRef(name.data(), name.size())) {
                    skipParamInference = true; break;
                }
            }

            // 2. Caller-count heuristic: in a multi-function module, a Win64
            //    function that is never the target of any internal CallOp is
            //    the root entry / exported symbol — treat as zero-param.
            if (!skipParamInference) {
                unsigned moduleFuncCount = 0;
                module.walk([&](helix::low::FuncOp) { ++moduleFuncCount; });
                if (moduleFuncCount > 1) {
                    bool calledInternally = false;
                    module.walk([&](helix::low::CallOp call) {
                        if (call->getParentOfType<helix::low::FuncOp>() == func)
                            return; // skip self-recursive calls
                        if (auto t = call.getTargetName(); t && *t == funcName)
                            calledInternally = true;
                    });
                    skipParamInference = !calledInternally;
                }
            }

            if (skipParamInference)
                llvm::errs() << "[P0-DEBUG] RecoverCC: '" << funcName
                             << "' is a Win64 entry point — skipping param inference\n";
        }

        // Phase 1: Identify function parameters.
        // Scan from the top for reg.read operations that read argument registers
        // before any write to those registers — these are function parameters.
        llvm::SmallVector<unsigned> paramIndices;

        if (!skipParamInference) {
        llvm::DenseSet<llvm::StringRef> writtenRegs;
        llvm::DenseSet<unsigned> seenParamIndices;

        func.walk([&](Operation* op) {
            if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(op)) {
                auto canonical =
                    helix::analysis::getCanonicalX86Register(regWrite.getRegName());
                if (!canonical.empty())
                    writtenRegs.insert(canonical);
                else
                    writtenRegs.insert(regWrite.getRegName());
            }
            if (auto regRead = dyn_cast<helix::low::RegReadOp>(op)) {
                auto canonical =
                    helix::analysis::getCanonicalX86Register(regRead.getRegName());
                auto lookup = canonical.empty() ? regRead.getRegName() : canonical;
                auto paramIndex =
                    helix::analysis::getX86ArgumentRegisterIndex(lookup, argRegs);
                if (paramIndex && !writtenRegs.contains(lookup) &&
                    seenParamIndices.insert(*paramIndex).second) {
                    paramIndices.push_back(*paramIndex);
                }
            }
        });
        llvm::sort(paramIndices);
        } // end !skipParamInference (Phase 1)

        // Phase 2: Emit parameter declarations at function entry.
        if (!skipParamInference && !paramIndices.empty()) {
            OpBuilder builder(func->getContext());
            auto& entryBlock = func.getBody().front();
            builder.setInsertionPointToStart(&entryBlock);

            uint32_t paramId = getNextAvailableVarId(func);
            llvm::DenseSet<llvm::StringRef> existingParams;
            func.walk([&](helix::high::VarDeclOp decl) {
                if (decl.getStorage() == helix::high::StorageKind::Parameter)
                    existingParams.insert(decl.getVarName());
            });

            for (auto paramIndex : paramIndices) {
                auto paramName = std::format("param_{}", paramIndex);
                if (existingParams.contains(paramName))
                    continue;

                builder.create<helix::high::VarDeclOp>(
                    func.getLoc(),
                    builder.getUI32IntegerAttr(paramId++),
                    builder.getStringAttr(paramName),
                    helix::high::StorageKindAttr::get(
                        builder.getContext(),
                        helix::high::StorageKind::Parameter),
                    /*stack_offset=*/IntegerAttr{},
                    /*init=*/Value{},
                    /*address=*/IntegerAttr{});
            }
        }

        // Phase 3: Materialize ABI argument values directly on helix_low.call.
        llvm::SmallVector<helix::low::CallOp, 16> calls;
        func.walk([&](helix::low::CallOp call) { calls.push_back(call); });

        for (auto call : calls) {
            auto targetName = call.getTargetName();
            const bool isDirectNamedCall =
                targetName.has_value() && targetName->starts_with("sub_");

            // ── Look up signature to clamp arg count for known callees ──
            // For external named calls (e.g., mutex_unlock, down_read), the
            // SignatureDb tells us exactly how many args the function takes.
            // Without this clamp, collectAbiCallArgs bleeds stray register
            // writes into the arg list, producing calls like:
            //   mutex_unlock(var_70, _promoted_0, 0xA0D, rsp)   (wrong!)
            // when the real signature is:
            //   mutex_unlock(var_70)                              (correct)
            std::optional<size_t> maxArgs;
            if (targetName.has_value() && !isDirectNamedCall) {
                if (auto sig = lookupSignature(*targetName))
                    maxArgs = sig->param_types.size();

                // Fallback: inline table of common Linux kernel primitives
                // that SignatureDb doesn't know about.  This prevents
                // stray register bleeding in kernel-module decompilation.
                if (!maxArgs.has_value()) {
                    static const llvm::StringMap<size_t> kKernelArgs = {
                        // sync primitives (1 arg: lock pointer)
                        {"mutex_lock",         1},
                        {"mutex_unlock",       1},
                        {"mutex_lock_nested",  2},
                        {"mutex_trylock",      1},
                        {"down_read",          1},
                        {"down_write",         1},
                        {"up_read",            1},
                        {"up_write",           1},
                        {"down_read_killable", 1},
                        {"down_write_killable",1},
                        {"_raw_spin_lock",         1},
                        {"_raw_spin_unlock",       1},
                        {"_raw_spin_lock_irq",     1},
                        {"_raw_spin_unlock_irq",   1},
                        {"_raw_spin_lock_bh",      1},
                        {"_raw_spin_unlock_bh",    1},
                        {"spin_lock",          1},
                        {"spin_unlock",        1},
                        {"raw_spin_lock",      1},
                        {"raw_spin_unlock",    1},
                        {"read_lock",          1},
                        {"read_unlock",        1},
                        {"write_lock",         1},
                        {"write_unlock",       1},
                        // list ops (1-2 args)
                        {"__list_del_entry_valid_or_report", 1},
                        {"__list_add_valid_or_report",       3},
                        // memory (1 arg)
                        {"kfree",              1},
                        {"vfree",              1},
                        {"kmem_cache_free",    2},
                        // atomics (2-3 args)
                        {"atomic_inc",         1},
                        {"atomic_dec",         1},
                        {"atomic_read",        1},
                        {"atomic_set",         2},
                        // barriers / no-arg
                        {"schedule",           0},
                        {"cond_resched",       0},
                        {"might_sleep",        0},
                    };
                    auto it = kKernelArgs.find(*targetName);
                    if (it != kKernelArgs.end())
                        maxArgs = it->second;
                }
            }

            auto argValues =
                collectAbiCallArgs(call.getOperation(), argRegs);

            // Clamp collected args to the known signature length.
            if (maxArgs.has_value() && argValues.size() > *maxArgs) {
                argValues.resize(*maxArgs);
            }

            auto existingArgs = call.getArgs();

            // External calls with UNKNOWN signatures: do not materialize
            // any args.  Trust the downstream emitter to render the call
            // without args rather than risk stale register state bleeding
            // through as spurious args.  Direct sub_XXX calls still get
            // materialization since those have no signature info at all.
            const bool canMaterializeArgs =
                isDirectNamedCall ||
                (maxArgs.has_value() && existingArgs.empty()) ||
                (existingArgs.empty() && !targetName.has_value());

            bool differs = existingArgs.size() != argValues.size();
            if (!differs) {
                auto existingIt = existingArgs.begin();
                auto recoveredIt = argValues.begin();
                for (; existingIt != existingArgs.end() &&
                       recoveredIt != argValues.end();
                     ++existingIt, ++recoveredIt) {
                    if (*existingIt != *recoveredIt) {
                        differs = true;
                        break;
                    }
                }
            }

            if (canMaterializeArgs && !argValues.empty() &&
                (existingArgs.empty() || argValues.size() > existingArgs.size()) &&
                differs) {
                call.getArgsMutable().assign(argValues);
                existingArgs = call.getArgs();
            }

            // Final safety clamp on whatever ended up on the call.
            if (maxArgs.has_value() && existingArgs.size() > *maxArgs) {
                llvm::SmallVector<Value, 6> clamped(
                    existingArgs.begin(),
                    existingArgs.begin() +
                        static_cast<ptrdiff_t>(*maxArgs));
                call.getArgsMutable().assign(clamped);
                existingArgs = call.getArgs();
            }

            auto i32Ty = IntegerType::get(call->getContext(), 32);
            call->setAttr("arg_count",
                IntegerAttr::get(i32Ty, existingArgs.size()));
        }

        // Phase 4: Identify return value.
        // If the function has a reg.write to RAX/XMM0 before its return, it
        // returns a value.
        bool hasReturnValue = false;
        func.walk([&](helix::low::RetOp ret) {
            // Check if there's a reg.write to RAX before this return
            auto* block = ret->getBlock();
            if (!block) return;

            if (hasReturnRegisterWriteInBlock(block, Block::iterator(ret))) {
                hasReturnValue = true;
                return;
            }

            // Common epilogue pattern: the return register is written in an
            // immediate predecessor block, then control transfers to a shared
            // return block containing only the final RET.
            llvm::SmallVector<std::pair<Block*, unsigned>, 4> worklist;
            llvm::DenseSet<Block*> visited;
            for (Block* pred : block->getPredecessors())
                worklist.push_back({pred, 0u});

            while (!worklist.empty()) {
                auto [candidate, depth] = worklist.pop_back_val();
                if (!candidate || !visited.insert(candidate).second)
                    continue;

                if (hasReturnRegisterWriteInBlock(candidate, candidate->end())) {
                    hasReturnValue = true;
                    return;
                }

                if (depth >= 1)
                    continue;

                for (Block* pred : candidate->getPredecessors())
                    worklist.push_back({pred, depth + 1});
            }
        });

        // Set calling convention attribute on the function.  The string is
        // read by downstream passes (RecoverVariables, CAstBuilder, emitter,
        // RecoverStackLayout) to pick arg-register maps, stack layout, and
        // the `| <cc>` header line in the emitted C output.
        const char* ccStr =
            (cc == CallingConv::Win64)   ? "win64"   :
            (cc == CallingConv::SysV)    ? "sysv"    :
            /* Cdecl32 */                  "cdecl";
        func->setAttr("calling_convention",
            StringAttr::get(func->getContext(), ccStr));
        if (hasReturnValue) {
            func->setAttr("has_return_value",
                UnitAttr::get(func->getContext()));
        }
        // Tell RecoverVariables not to create param_N vars for arg registers
        // on Win64 entry-point functions (OS-set register values, not real params).
        if (skipParamInference) {
            func->setAttr("no_reg_params",
                UnitAttr::get(func->getContext()));
        }
    }
};

} // anonymous namespace

std::unique_ptr<mlir::Pass> helix::createRecoverCallingConventionPass() {
    return std::make_unique<RecoverCallingConventionPass>();
}
