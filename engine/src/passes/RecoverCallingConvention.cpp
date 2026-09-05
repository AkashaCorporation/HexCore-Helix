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
#include "helix/utils/CallOpHelpers.h"
#include "helix/utils/Debug.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"

#include <array>
#include <algorithm>
#include <cstdint>
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

/// AAPCS64 (AArch64) integer argument registers in order: X0..X7.
/// Uppercase to match the register names Remill emits (the lowercase
/// "x0" spec lives in CallingConventionDb; this pass uses uppercase
/// throughout because RegisterTracker resolves GEPs to "X0".. names).
constexpr std::array<std::string_view, 8> kAapcs64IntArgs = {
    "X0", "X1", "X2", "X3", "X4", "X5", "X6", "X7"
};

/// Callee-saved registers (AAPCS64): X19..X28, plus FP (X29) and LR (X30).
constexpr std::array<std::string_view, 12> kAapcs64CalleeSaved = {
    "X19", "X20", "X21", "X22", "X23", "X24",
    "X25", "X26", "X27", "X28", "X29", "X30"
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
enum class CallingConv { Win64, SysV, Cdecl32, Aapcs64 };

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

    auto name = regWrite.getRegName().upper();
    // AArch64 AAPCS64: integer return in X0, FP/SIMD return in V0.
    if (name == "X0" || name == "V0")
        return true;

    return helix::analysis::isX86GeneralPurposeReturnRegister(
               regWrite.getRegName()) ||
           name == "XMM0";
}

static bool hasReturnRegisterWriteInBlock(
    Block* block, Block::iterator endIt) {
    if (!block)
        return false;

    for (auto it = endIt; it != block->begin();) {
        --it;
        if (isReturnRegisterWrite(*it))
            return true;

        if (helix::isAnyCallOp(&*it))
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
        if (helix::isAnyCallOp(&op)) {
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

/// Bounded forward use-def walk: does `root` (a live-in reg.read result) flow
/// into a memory DEREFERENCE as the address operand?  A real x86-32 __thiscall
/// `this` is dereferenced (`*(this + const)` field access, `*this`, vtable
/// `*(*this)`); a scratch ECX that is only compared / spilled (`push`) / used
/// as a scalar is NOT.  This is the x86-32 tighter gate ("flows-to-deref") that
/// kills the 0x83d050-class false positive — where ECX is live-in but the real
/// parameter lives on the stack and the deref base is a global load, not ECX.
///
/// Walk rules (SSA-only + one-hop register copy within a block, step-capped):
///   TERMINAL (return true): v is the `addr` operand of mem.read / mem.write,
///     or the dst/src pointer of rep.movs / rep.stos.
///   FOLLOW result of: binop with a CONSTANT other operand (this + field off),
///     lea from its base operand (not index), movzx/movsx passthrough.
///   ONE-HOP COPY: v written to reg2 → continue from later reads of reg2 in the
///     same block, up to the next write of reg2 (covers `mov reg2,ecx; [reg2+n]`).
///   Everything else (cmp/test/push/unaryop/cmov/xchg/call/ret) is NOT a deref
///     and is not followed — this is what rejects the scratch-ECX cases.
static bool valueFlowsToDeref(Value root) {
    llvm::SmallVector<Value, 32> worklist;
    llvm::DenseSet<Value> visited;
    worklist.push_back(root);
    unsigned steps = 0;
    constexpr unsigned kMaxSteps = 2048;

    while (!worklist.empty()) {
        if (++steps > kMaxSteps)
            return false;               // give up conservatively — do NOT bind
        Value v = worklist.pop_back_val();
        if (!v || !visited.insert(v).second)
            continue;

        for (OpOperand& use : v.getUses()) {
            Operation* user = use.getOwner();

            // ── Terminal: genuine dereference with v as the ADDRESS ──
            if (auto ld = dyn_cast<helix::low::MemReadOp>(user)) {
                if (use.get() == ld.getAddr()) return true;
                continue;
            }
            if (auto st = dyn_cast<helix::low::MemWriteOp>(user)) {
                if (use.get() == st.getAddr()) return true;   // addr, not value
                continue;
            }
            if (auto rm = dyn_cast<helix::low::RepMovsOp>(user)) {
                if (use.get() == rm.getDst() || use.get() == rm.getSrc())
                    return true;
                continue;
            }
            if (auto rs = dyn_cast<helix::low::RepStosOp>(user)) {
                if (use.get() == rs.getDst()) return true;
                continue;
            }
            // LLVM-dialect memory ops: at this pass stage the address math and
            // some loads/stores are still in the LLVM dialect (mixed with the
            // helix_low ops).  llvm.load ptr = operand 0; llvm.store value,ptr
            // → ptr = operand 1.
            {
                llvm::StringRef opName = user->getName().getStringRef();
                if (opName == "llvm.load") {
                    if (use.getOperandNumber() == 0) return true;
                    continue;
                }
                if (opName == "llvm.store") {
                    if (use.getOperandNumber() == 1) return true;   // ptr, not val
                    continue;
                }
            }

            // ── One-hop register copy: `mov reg2, ecx ; … *(reg2 + off)` ──
            // The live-in ECX is frequently spilled to another register first
            // (Remill: reg.read ECX → reg.write RSI, then the deref reads RSI).
            if (auto rw = dyn_cast<helix::low::RegWriteOp>(user)) {
                if (use.get() != rw.getValue()) continue;
                auto c = helix::analysis::getCanonicalX86Register(rw.getRegName());
                llvm::StringRef dest = c.empty() ? rw.getRegName() : c;
                Block* blk = rw->getBlock();
                if (!blk) continue;
                auto it = rw->getIterator();
                for (++it; it != blk->end(); ++it) {
                    if (auto w2 = dyn_cast<helix::low::RegWriteOp>(&*it)) {
                        auto c2 =
                            helix::analysis::getCanonicalX86Register(w2.getRegName());
                        if ((c2.empty() ? w2.getRegName() : c2) == dest)
                            break;                       // dest overwritten — copy dead
                    }
                    if (auto r2 = dyn_cast<helix::low::RegReadOp>(&*it)) {
                        auto c2 =
                            helix::analysis::getCanonicalX86Register(r2.getRegName());
                        if ((c2.empty() ? r2.getRegName() : c2) == dest)
                            worklist.push_back(r2.getResult());
                    }
                }
                continue;
            }

            // ── Address arithmetic / casts / extends: follow the result ──
            // Any memory-effect-free op (helix_low.binop/lea/movzx/movsx AND
            // llvm.add/sub/mul/or/and/shl, llvm.getelementptr, llvm.ptrtoint,
            // llvm.inttoptr, llvm.zext/sext/trunc, …) is pointer math — follow
            // all its results toward a possible dereference.  This spans both
            // dialects, which the IR is a mix of at this stage.
            if (mlir::isMemoryEffectFree(user)) {
                for (Value r : user->getResults())
                    worklist.push_back(r);
                continue;
            }
            // Any other user (cmp/test/push/ret/jcc/call/scratch reg.write) is
            // NOT a dereference and is not followed — rejects scratch ECX.
        }
    }
    return false;
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
                if (helix::pipelineDebugEnabled())
                    llvm::errs() << "[P0-DEBUG] RecoverCC: triple='" << t << "'\n";
                const bool is32BitX86 =
                    t.contains("i386") || t.contains("i486") ||
                    t.contains("i586") || t.contains("i686");
                const bool isAArch64 =
                    t.contains("aarch64") || t.contains("arm64");
                // AArch64 must be checked BEFORE the linux/elf/gnu branch:
                // an "aarch64-pc-linux-gnu-elf" triple also matches those
                // substrings, but AArch64 uses AAPCS64 (X0..X7), not x86 SysV.
                if (isAArch64) {
                    cc = CallingConv::Aapcs64;
                } else if (is32BitX86) {
                    cc = CallingConv::Cdecl32;
                } else if (t.contains("linux") || t.contains("elf") ||
                           t.contains("gnu") || t.contains("freebsd") ||
                           t.contains("openbsd")) {
                    cc = CallingConv::SysV;
                } else if (t.contains("darwin") || t.contains("macho")) {
                    cc = CallingConv::SysV; // macOS also uses SysV on x86_64
                }
            } else {
                if (helix::pipelineDebugEnabled())
                    llvm::errs() << "[P0-DEBUG] RecoverCC: NO llvm.target_triple on module\n";
            }
        } else {
            if (helix::pipelineDebugEnabled())
                llvm::errs() << "[P0-DEBUG] RecoverCC: FuncOp has no parent ModuleOp!\n";
        }
        const char* ccDebugName =
            (cc == CallingConv::Win64)   ? "Win64"   :
            (cc == CallingConv::SysV)    ? "SysV"    :
            (cc == CallingConv::Aapcs64) ? "Aapcs64" :
            /* Cdecl32 */                  "Cdecl32";
        if (helix::pipelineDebugEnabled())
            llvm::errs() << "[P0-DEBUG] RecoverCC: using " << ccDebugName << "\n";

        // x86-32: cdecl/stdcall pass all integer args on the stack, BUT
        // __thiscall passes `this` in ECX (= canonical RCX).  Offer ECX as a
        // CANDIDATE arg register; Phase 1's read-before-write liveness filter
        // binds it ONLY when the function actually reads it live-in (i.e. is
        // genuinely a __thiscall method), so a pure-cdecl function that merely
        // scratches ECX still gets ZERO register params.  This recovers the
        // lost `this` (the NULL-base `*(v2+off)` cascade) for C++ methods, which
        // dominate MSVC game code.  __fastcall's EDX(=RDX) 2nd arg is
        // DELIBERATELY excluded: read-before-write liveness alone over-binds EDX
        // (~13/30 GTA corpus false-positives where EDX carries a non-arg value),
        // so fastcall needs its own gate — a follow-up.  Pure-stack cdecl params
        // remain RecoverStackLayout's job (FIX-CC-THISCALL, ECX-only first cut).
        static constexpr std::array<std::string_view, 1> kCdecl32IntArgs = {
            "RCX"
        };
        llvm::ArrayRef<std::string_view> argRegs;
        switch (cc) {
        case CallingConv::Win64:   argRegs = kWin64IntArgs;   break;
        case CallingConv::SysV:    argRegs = kSysVIntArgs;    break;
        case CallingConv::Cdecl32: argRegs = kCdecl32IntArgs; break;
        case CallingConv::Aapcs64: argRegs = kAapcs64IntArgs; break;
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

            if (skipParamInference && helix::pipelineDebugEnabled())
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
                std::optional<unsigned> paramIndex;
                for (size_t i = 0; i < argRegs.size(); ++i) {
                    llvm::StringRef abiReg(argRegs[i].data(),
                                          argRegs[i].size());
                    if (lookup.equals_insensitive(abiReg)) {
                        paramIndex = static_cast<unsigned>(i + 1);
                        break;
                    }
                }
                if (paramIndex && !writtenRegs.contains(lookup)) {
                    // x86-32 tighter gate (FIX-CC-THISCALL round 2): a live-in
                    // arg register is a real __thiscall `this` only if its value
                    // FLOWS INTO A MEMORY DEREFERENCE as a base address.  Scratch
                    // ECX that is merely compared / spilled / forwarded is
                    // rejected — this kills the 0x83d050-class false positive
                    // (ECX live-in but never a base; real param on the stack).
                    // Applied ONLY to Cdecl32/ECX; Win64/SysV/AAPCS64 keep their
                    // existing (well-validated) read-before-write behavior byte
                    // for byte (passesGate is unconditionally true there).
                    const bool passesGate =
                        (cc != CallingConv::Cdecl32) ||
                        valueFlowsToDeref(regRead.getResult());
                    if (passesGate &&
                        seenParamIndices.insert(*paramIndex).second) {
                        paramIndices.push_back(*paramIndex);
                    }
                }
            }
        });
        llvm::sort(paramIndices);
        // FIX-139: a non-variadic DWARF/BTF/PDB signature is authoritative
        // about the source-level parameter count. ABI registers beyond that
        // count can still be live-in scratch values, especially on AAPCS64;
        // keep their dataflow but do not expose them as phantom parameters.
        if (auto debugParamCount = func->getAttrOfType<IntegerAttr>(
                "helix.debug_param_count")) {
            const uint64_t count = debugParamCount.getValue().getZExtValue();
            llvm::erase_if(paramIndices, [count](unsigned index) {
                return index == 0 || index > count;
            });
        }
        if (cc == CallingConv::Cdecl32 && !paramIndices.empty() &&
            helix::pipelineDebugEnabled())
            llvm::errs() << "[CC-FIX] '" << func.getName() << "' bound "
                         << paramIndices.size()
                         << " x86-32 register param(s) (thiscall/fastcall)\n";
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
        // NOTE: x86-32 offers ECX only as a __thiscall `this` CANDIDATE for the
        // current function's OWN parameter recovery (Phase 1/2, flows-to-deref
        // gated).  Call-argument materialization must NOT use ECX for cdecl: a
        // callee's convention is unknown here, and materializing a phantom RCX
        // first-arg on every cdecl call diverges from the (correct) baseline and
        // pollutes call sites (this was the 0x821ae0 side-effect).  Use empty
        // arg-regs for cdecl in Phase 3 — identical to pre-FIX-CC-THISCALL.
        static constexpr std::array<std::string_view, 0> kNoArgRegs = {};
        llvm::ArrayRef<std::string_view> phase3ArgRegs =
            (cc == CallingConv::Cdecl32) ? llvm::ArrayRef<std::string_view>(kNoArgRegs)
                                         : argRegs;
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
                if (auto exactCount = call->getAttrOfType<IntegerAttr>(
                        "helix.debug_param_count")) {
                    maxArgs = static_cast<size_t>(exactCount.getInt());
                } else if (auto sig = lookupSignature(*targetName);
                           sig && !sig->is_variadic) {
                    maxArgs = sig->param_types.size();
                }

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
                collectAbiCallArgs(call.getOperation(), phase3ArgRegs);

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

        // FIX-138: DWARF/BTF/PDB is authoritative when it supplies a source
        // signature. A void function may still write RAX immediately before
        // RET because RAX is ordinary scratch storage; the machine-level
        // heuristic above cannot distinguish that from a returned value.
        // ApplyDebugTypes seeds this attribute before this pass.
        if (auto debugReturn = func->getAttrOfType<StringAttr>(
                "inferred_return_type")) {
            llvm::StringRef type = debugReturn.getValue().trim();
            if (!type.empty())
                hasReturnValue = type != "void";
        }

        // Set calling convention attribute on the function.  The string is
        // read by downstream passes (RecoverVariables, CAstBuilder, emitter,
        // RecoverStackLayout) to pick arg-register maps, stack layout, and
        // the `| <cc>` header line in the emitted C output.
        const char* ccStr =
            (cc == CallingConv::Win64)   ? "win64"   :
            (cc == CallingConv::SysV)    ? "sysv"    :
            (cc == CallingConv::Aapcs64) ? "aapcs64" :
            /* Cdecl32 */                  "cdecl";
        func->setAttr("calling_convention",
            StringAttr::get(func->getContext(), ccStr));
        // FIX-CC-SRET round 3 (the Win64/SysV cousin of x86_thiscall_this below):
        // publish the exact argument-register parameter positions that Phase 1
        // certified as genuine read-before-write live-ins.  A struct-return-by-
        // value function parks its hidden sret pointer in a scratch arg register
        // (Win64 `mov r8, rcx`); Phase 1 correctly EXCLUDES that written-before-
        // read register from paramIndices, but RecoverVariables re-seeds all four
        // ABI arg registers by identity and re-invents the phantom (R8 -> param_3
        // with a NULL base).  Emitting the certified set lets RecoverVariables
        // intersect its argRegPositions with Phase 1's verdict -- the single-
        // source-of-truth mechanism of x86_thiscall_this, generalized to the
        // multi-register x86-64 ABIs.  Additive: when every arg register is a
        // genuine param the set is full and nothing changes.
        const bool publishCertifiedParams =
            cc == CallingConv::Win64 || cc == CallingConv::SysV ||
            (cc == CallingConv::Aapcs64 &&
             func->hasAttr("helix.debug_param_count"));
        if (publishCertifiedParams) {
            llvm::SmallVector<int32_t, 6> certifiedIdx(paramIndices.begin(),
                                                       paramIndices.end());
            func->setAttr("reg_param_indices",
                DenseI32ArrayAttr::get(func->getContext(), certifiedIdx));
        }
        // FIX-CC-THISCALL round 2: mark that the flows-to-deref gate actually
        // bound ECX as `this` (param_1) for this x86-32 function.
        // RecoverVariables keys its cdecl argRegPositions on this attribute, so
        // a pure-cdecl function whose ECX is merely scratch gets NO phantom
        // param_1 (this is what kills the 0x83d050-class regression — the gate
        // in Phase 1 alone is not enough because RecoverVariables names RCX
        // reads param_1 independently via argRegPositions).
        if (cc == CallingConv::Cdecl32) {
            bool boundEcx = false;
            for (auto idx : paramIndices)
                if (idx == 1u) { boundEcx = true; break; }
            if (boundEcx)
                func->setAttr("x86_thiscall_this",
                    UnitAttr::get(func->getContext()));
        }
        if (hasReturnValue) {
            func->setAttr("has_return_value",
                UnitAttr::get(func->getContext()));
        } else {
            func->removeAttr("has_return_value");
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
