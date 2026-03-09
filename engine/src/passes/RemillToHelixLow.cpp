/// @file RemillToHelixLow.cpp
/// @brief MLIR conversion pass: LLVM Dialect → HelixLow Dialect.
///
/// Recognizes Remill IR patterns (State struct GEPs with !remill_register
/// metadata, mangled C++ semantic function calls, __remill_* intrinsics)
/// and converts them to explicit HelixLow dialect operations.
///
/// This pass is the bridge between LLVM's generic IR representation and
/// Helix's decompiler-specific IR.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/analysis/RemillDemangler.h"
#include "helix/analysis/SignatureDb.h"
#include "helix/analysis/X86RegisterInfo.h"

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"

#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/ScopeExit.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/SmallVector.h"

#include <array>
#include <format>
#include <string>
#include <string_view>

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// Helper: Register Tracking
// ═══════════════════════════════════════════════════════════════════════════════

namespace {

/// Tracks which MLIR Values correspond to register GEP pointers.
/// Built during the initial scan of the LLVM Dialect module by recognizing
/// getelementptr operations that carry !remill_register metadata.
struct RegisterTracker {
    /// Maps SSA values (GEP results) to their register name.
    llvm::DenseMap<Value, std::string> gep_to_reg;

    /// Maps register names to their bit width (derived from access patterns).
    llvm::StringMap<unsigned> reg_widths;

    /// x86-64 GPR struct index-to-register mapping.
    /// Remill State → X86State → GPR field at struct index 6.
    /// The GPR struct alternates: padding (i64) + Reg.
    /// Field indices: 1=RAX, 3=RBX, 5=RCX, 7=RDX, 9=RSI, 11=RDI,
    ///   13=RSP, 15=RBP, 17=R8, 19=R9, 21=R10, 23=R11,
    ///   25=R12, 27=R13, 29=R14, 31=R15, 33=RIP
    static constexpr std::pair<int, const char*> kGprIndexMap[] = {
        {1, "RAX"}, {3, "RBX"}, {5, "RCX"}, {7, "RDX"},
        {9, "RSI"}, {11, "RDI"}, {13, "RSP"}, {15, "RBP"},
        {17, "R8"}, {19, "R9"}, {21, "R10"}, {23, "R11"},
        {25, "R12"}, {27, "R13"}, {29, "R14"}, {31, "R15"},
        {33, "RIP"},
    };

    /// Strip pointer-preserving wrappers so bookkeeping allocas are still
    /// recognized after import adds bitcasts or no-op GEPs.
    static Value stripPointerAliases(Value val) {
        while (val) {
            if (auto bitcast = val.getDefiningOp<LLVM::BitcastOp>()) {
                val = bitcast.getArg();
                continue;
            }
            if (auto cast = val.getDefiningOp<LLVM::AddrSpaceCastOp>()) {
                val = cast.getArg();
                continue;
            }
            if (auto gep = val.getDefiningOp<LLVM::GEPOp>()) {
                if (auto constIndices = extractConstantGEPIndices(gep)) {
                    bool allZero = llvm::all_of(*constIndices, [](int idx) {
                        return idx == 0;
                    });
                    if (allZero) {
                        val = gep.getBase();
                        continue;
                    }
                }
            }
            break;
        }
        return val;
    }

    /// Scan a function body and build the register map.
    void scan(LLVM::LLVMFuncOp func) {
        func.walk([&](LLVM::GEPOp gep) {
            // Strategy 1: Check for !remill_register metadata as an MLIR attribute.
            if (auto regAttr = gep->getAttrOfType<StringAttr>("remill_register")) {
                std::string name = regAttr.getValue().str();
                gep_to_reg[gep.getResult()] = name;
                reg_widths[name] = inferRegWidth(name);
                return;
            }

            // Strategy 2: Check llvm.metadata dictionary for the register name.
            if (auto metaDict = gep->getAttrOfType<DictionaryAttr>("llvm.metadata")) {
                if (auto regAttr = metaDict.getAs<StringAttr>("remill_register")) {
                    std::string name = regAttr.getValue().str();
                    gep_to_reg[gep.getResult()] = name;
                    reg_widths[name] = inferRegWidth(name);
                    return;
                }
            }

            // Strategy 3: Structural analysis of GEP indices into the State struct.
            // Remill pattern: gep %state, 0, 0, 6, <gpr_field_index>, 0, 0
            // where the indices are: State→X86State→GPR→<field>→Reg→union→i64
            auto indices = gep.getIndices();
            if (indices.size() >= 4) {
                // Check for the GPR struct access pattern:
                // First 3 constant indices should be 0, 0, 6 (State → X86State → GPR)
                if (auto constIndices = extractConstantGEPIndices(gep)) {
                    if (constIndices->size() >= 4 &&
                        (*constIndices)[0] == 0 &&
                        (*constIndices)[1] == 0 &&
                        (*constIndices)[2] == 6) {
                        int gprIdx = (*constIndices)[3];
                        for (auto [idx, name] : kGprIndexMap) {
                            if (idx == gprIdx) {
                                gep_to_reg[gep.getResult()] = name;
                                reg_widths[name] = inferRegWidth(name);
                                return;
                            }
                        }
                    }
                }
            }
        });

        // Also track alloca-based bookkeeping values (NEXT_PC, RETURN_PC,
        // BRANCH_TAKEN) by their fixed operand position in Remill semantics.
        func.walk([&](LLVM::CallOp call) {
            auto callee = call.getCallee();
            if (!callee)
                return;

            auto semInfo = helix::demangleRemillSemantic(*callee);
            if (!semInfo)
                return;

            auto bindBookkeepingPtr = [&](Value ptr, llvm::StringRef name) {
                ptr = stripPointerAliases(ptr);
                if (!ptr.getDefiningOp<LLVM::AllocaOp>())
                    return;
                gep_to_reg.try_emplace(ptr, name.str());
                reg_widths[name] = inferRegWidth(name);
            };

            switch (semInfo->semantic) {
            case RemillSemantic::CALL:
                if (call.getNumOperands() > 3)
                    bindBookkeepingPtr(call.getOperand(3), "NEXT_PC");
                if (call.getNumOperands() > 5)
                    bindBookkeepingPtr(call.getOperand(5), "RETURN_PC");
                break;
            case RemillSemantic::JMP:
                if (call.getNumOperands() > 3)
                    bindBookkeepingPtr(call.getOperand(3), "NEXT_PC");
                break;
            case RemillSemantic::RET:
                if (call.getNumOperands() > 2)
                    bindBookkeepingPtr(call.getOperand(2), "RETURN_PC");
                break;
            default:
                if (!helix::isConditionalJump(semInfo->semantic))
                    return;
                if (call.getNumOperands() > 2)
                    bindBookkeepingPtr(call.getOperand(2), "BRANCH_TAKEN");
                if (call.getNumOperands() > 5)
                    bindBookkeepingPtr(call.getOperand(5), "NEXT_PC");
                break;
            }
        });

        // Recover the plain PC alloca structurally. Unlike NEXT_PC and
        // RETURN_PC, Remill does not pass %PC directly to semantic helpers,
        // so we infer it from the classic pattern:
        //   %pc = load i64, ptr %PC
        //   %next = add i64 %pc, <instr_size>
        //   store i64 %next, ptr %NEXT_PC
        func.walk([&](LLVM::AllocaOp alloca) {
            if (gep_to_reg.count(alloca.getResult()))
                return;

            bool looksLikePc = false;
            for (Operation* user : alloca->getUsers()) {
                auto load = dyn_cast<LLVM::LoadOp>(user);
                if (!load)
                    continue;

                for (Operation* loadUser : load.getResult().getUsers()) {
                    auto add = dyn_cast<LLVM::AddOp>(loadUser);
                    auto sub = dyn_cast<LLVM::SubOp>(loadUser);
                    Value candidate;
                    if (add)
                        candidate = add.getResult();
                    else if (sub)
                        candidate = sub.getResult();
                    else
                        continue;

                    for (Operation* arithUser : candidate.getUsers()) {
                        auto store = dyn_cast<LLVM::StoreOp>(arithUser);
                        if (!store)
                            continue;
                        auto dst = getRegName(store.getAddr());
                        if (dst && *dst == "NEXT_PC") {
                            looksLikePc = true;
                            break;
                        }
                    }

                    if (looksLikePc)
                        break;
                }

                if (looksLikePc)
                    break;
            }

            if (!looksLikePc)
                return;

            gep_to_reg.try_emplace(alloca.getResult(), "PC");
            reg_widths["PC"] = inferRegWidth("PC");
        });
    }

    /// Try to extract constant integer indices from a GEP operation.
    static std::optional<SmallVector<int, 6>>
    extractConstantGEPIndices(LLVM::GEPOp gep) {
        SmallVector<int, 6> result;
        for (auto idx : gep.getIndices()) {
            // In MLIR LLVM dialect, GEP indices can be either constant attributes
            // or SSA values. We only handle constant attributes here.
            if (auto intAttr = dyn_cast<IntegerAttr>(idx)) {
                result.push_back(static_cast<int>(intAttr.getInt()));
            } else if (auto val = dyn_cast<Value>(idx)) {
                // Try to resolve through a constant op
                if (auto constOp = val.getDefiningOp<LLVM::ConstantOp>()) {
                    if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                        result.push_back(static_cast<int>(intAttr.getInt()));
                        continue;
                    }
                }
                return std::nullopt;  // Non-constant index
            }
        }
        return result;
    }

    /// Infer register bit width from its name.
    static unsigned inferRegWidth(llvm::StringRef name) {
        // 64-bit: RAX, RBX, RCX, RDX, RSI, RDI, RSP, RBP, R8-R15, RIP
        if (name.starts_with("R") || name == "RIP")
            return 64;
        // 32-bit: EAX, EBX, etc.
        if (name.starts_with("E"))
            return 32;
        // 16-bit: AX, BX, CX, DX, SI, DI, SP, BP
        if (name.size() == 2 && (name.ends_with("X") || name.ends_with("I") ||
                                  name.ends_with("P")))
            return 16;
        // 8-bit: AL, AH, BL, BH, CL, CH, DL, DH
        if (name.size() == 2 && (name.ends_with("L") || name.ends_with("H")))
            return 8;
        // Special: flags, segments, PC
        if (name == "PC" || name == "NEXT_PC")
            return 64;
        // Default to 64-bit for unknown registers
        return 64;
    }

    /// Check if a value is a known register GEP pointer.
    bool isRegisterPtr(Value val) const {
        return gep_to_reg.count(val) > 0;
    }

    static std::optional<std::string> extractRegisterNameFromValue(Value val) {
        val = stripPointerAliases(val);
        auto gep = val.getDefiningOp<LLVM::GEPOp>();
        if (!gep)
            return std::nullopt;

        if (auto regAttr = gep->getAttrOfType<StringAttr>("remill_register"))
            return regAttr.getValue().str();

        if (auto metaDict = gep->getAttrOfType<DictionaryAttr>("llvm.metadata")) {
            if (auto regAttr = metaDict.getAs<StringAttr>("remill_register"))
                return regAttr.getValue().str();
        }

        if (auto constIndices = extractConstantGEPIndices(gep)) {
            if (constIndices->size() >= 4 &&
                (*constIndices)[0] == 0 &&
                (*constIndices)[1] == 0 &&
                (*constIndices)[2] == 6) {
                int gprIdx = (*constIndices)[3];
                for (auto [idx, name] : kGprIndexMap) {
                    if (idx == gprIdx)
                        return std::string(name);
                }
            }
        }

        return std::nullopt;
    }

    static std::optional<std::string> extractBookkeepingNameFromAlloca(Value val) {
        val = stripPointerAliases(val);
        auto alloca = val.getDefiningOp<LLVM::AllocaOp>();
        if (!alloca)
            return std::nullopt;

        std::optional<std::string> candidate;
        auto observe = [&](llvm::StringRef name) {
            if (!candidate) {
                candidate = name.str();
                return;
            }
            if (*candidate != name)
                candidate = std::nullopt;
        };

        for (Operation* user : alloca->getUsers()) {
            auto call = dyn_cast<LLVM::CallOp>(user);
            if (!call)
                continue;

            auto callee = call.getCallee();
            if (!callee)
                continue;

            auto semInfo = helix::demangleRemillSemantic(*callee);
            if (!semInfo)
                continue;

            auto markIfOperand = [&](unsigned idx, llvm::StringRef name) {
                if (call.getNumOperands() > idx && call.getOperand(idx) == val)
                    observe(name);
            };

            switch (semInfo->semantic) {
            case RemillSemantic::CALL:
                markIfOperand(3, "NEXT_PC");
                markIfOperand(5, "RETURN_PC");
                break;
            case RemillSemantic::JMP:
                markIfOperand(3, "NEXT_PC");
                break;
            case RemillSemantic::RET:
                markIfOperand(2, "RETURN_PC");
                break;
            default:
                if (!helix::isConditionalJump(semInfo->semantic))
                    break;
                markIfOperand(2, "BRANCH_TAKEN");
                markIfOperand(5, "NEXT_PC");
                break;
            }
        }

        return candidate;
    }

    /// Get the register name for a GEP result, if known.
    std::optional<std::string> getRegName(Value val) const {
        val = stripPointerAliases(val);
        auto it = gep_to_reg.find(val);
        if (it != gep_to_reg.end())
            return it->second;
        if (auto direct = extractRegisterNameFromValue(val))
            return direct;
        return extractBookkeepingNameFromAlloca(val);
    }
};

/// Tracks PC values during conversion to set address attributes on ops.
struct PCTracker {
    /// Current PC value (if known).
    uint64_t current_pc = 0;
    /// Whether we have a valid PC.
    bool has_pc = false;
    /// Last known concrete values for bookkeeping slots such as PC/NEXT_PC.
    llvm::StringMap<int64_t> trackedValues;

    std::optional<int64_t> tryEvaluate(Value value,
                                       const RegisterTracker& regs) const {
        llvm::SmallPtrSet<Operation*, 16> visiting;
        return tryEvaluate(value, regs, visiting);
    }

    /// Try to extract a PC value from a store to NEXT_PC.
    void trackStore(LLVM::StoreOp store, const RegisterTracker& regs) {
        // Pattern: store i64 %val, ptr %NEXT_PC
        // The stored value is often: add i64 %prev_pc, <instr_size>
        auto destReg = regs.getRegName(store.getAddr());
        if (!destReg)
            return;

        auto evaluated = tryEvaluate(store.getValue(), regs);
        if (evaluated) {
            trackedValues[*destReg] = *evaluated;
        } else {
            trackedValues.erase(*destReg);
        }

        if (!evaluated)
            return;

        if (*destReg == "PC") {
            current_pc = static_cast<uint64_t>(*evaluated);
            has_pc = true;
            return;
        }

        // NEXT_PC is the most useful base for RIP-relative reconstruction.
        // Keep tracking it as the active address so later arithmetic over
        // synthetic temporaries can still collapse to concrete targets.
        if (*destReg == "NEXT_PC") {
            current_pc = static_cast<uint64_t>(*evaluated);
            has_pc = true;
        }
    }

    /// Get an optional address attribute for the current PC.
    std::optional<uint64_t> getAddress() const {
        return has_pc ? std::optional(current_pc) : std::nullopt;
    }

private:
    std::optional<int64_t> tryEvaluate(
        Value value, const RegisterTracker& regs,
        llvm::SmallPtrSetImpl<Operation*>& visiting) const {
        if (!value)
            return std::nullopt;

        auto* defOp = value.getDefiningOp();
        if (!defOp)
            return std::nullopt;

        if (!visiting.insert(defOp).second)
            return std::nullopt;

        auto eraseOnReturn = llvm::make_scope_exit([&] { visiting.erase(defOp); });

        if (auto constOp = dyn_cast<LLVM::ConstantOp>(defOp)) {
            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                return intAttr.getValue().getSExtValue();
        }

        if (auto constOp = dyn_cast<arith::ConstantOp>(defOp)) {
            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                return intAttr.getValue().getSExtValue();
        }

        if (auto intAttr = defOp->getAttrOfType<IntegerAttr>("value"))
            return intAttr.getValue().getSExtValue();

        if (auto load = dyn_cast<LLVM::LoadOp>(defOp)) {
            auto srcReg = regs.getRegName(load.getAddr());
            if (srcReg) {
                if (auto it = trackedValues.find(*srcReg);
                    it != trackedValues.end()) {
                    return it->second;
                }
                if ((*srcReg == "PC" || *srcReg == "NEXT_PC") && has_pc)
                    return static_cast<int64_t>(current_pc);
            }
            return std::nullopt;
        }

        if (auto add = dyn_cast<LLVM::AddOp>(defOp)) {
            auto lhs = tryEvaluate(add.getLhs(), regs, visiting);
            auto rhs = tryEvaluate(add.getRhs(), regs, visiting);
            if (lhs && rhs)
                return *lhs + *rhs;
            return std::nullopt;
        }

        if (auto sub = dyn_cast<LLVM::SubOp>(defOp)) {
            auto lhs = tryEvaluate(sub.getLhs(), regs, visiting);
            auto rhs = tryEvaluate(sub.getRhs(), regs, visiting);
            if (lhs && rhs)
                return *lhs - *rhs;
            return std::nullopt;
        }

        if (auto zext = dyn_cast<LLVM::ZExtOp>(defOp))
            return tryEvaluate(zext.getArg(), regs, visiting);

        if (auto sext = dyn_cast<LLVM::SExtOp>(defOp))
            return tryEvaluate(sext.getArg(), regs, visiting);

        if (auto trunc = dyn_cast<LLVM::TruncOp>(defOp))
            return tryEvaluate(trunc.getArg(), regs, visiting);

        if (auto ptrToInt = dyn_cast<LLVM::PtrToIntOp>(defOp))
            return tryEvaluate(ptrToInt.getArg(), regs, visiting);

        if (auto intToPtr = dyn_cast<LLVM::IntToPtrOp>(defOp))
            return tryEvaluate(intToPtr.getArg(), regs, visiting);

        return std::nullopt;
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// Conversion Pass
// ═══════════════════════════════════════════════════════════════════════════════

/// The Remill-to-HelixLow conversion pass.
///
/// Processes each LLVM function in the module:
/// 1. Scans for register GEPs to build the register map
/// 2. Walks operations in order, converting recognized patterns to HelixLow ops
/// 3. Wraps the converted ops in a helix_low.func operation
/// 4. Removes the original LLVM function
struct RemillToHelixLowPass
    : public PassWrapper<RemillToHelixLowPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RemillToHelixLowPass)

    StringRef getArgument() const final { return "remill-to-helix-low"; }
    StringRef getDescription() const final {
        return "Convert LLVM Dialect (Remill IR) to HelixLow Dialect";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<LLVM::LLVMDialect>();
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<helix::high::HelixHighDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();

        // Process each LLVM function that looks like a Remill lifted function.
        // Remill functions have the signature:
        //   define ptr @lifted_<addr>(ptr %state, i64 %program_counter, ptr %memory)
        SmallVector<LLVM::LLVMFuncOp> funcsToConvert;

        module.walk([&](LLVM::LLVMFuncOp func) {
            auto name = func.getName();
            // Remill lifted functions start with "lifted_" or "sub_"
            if (name.starts_with("lifted_") || name.starts_with("sub_")) {
                funcsToConvert.push_back(func);
            }
        });

        for (auto func : funcsToConvert) {
            if (failed(convertFunction(func))) {
                signalPassFailure();
                return;
            }
        }

        // After all functions are converted, resolve CALL target addresses
        // to function names using the module's own function table and the
        // signature database.
        helix::resolveCallTargets(module);
    }

private:
    /// Convert a single Remill lifted function to HelixLow.
    LogicalResult convertFunction(LLVM::LLVMFuncOp llvmFunc) {
        OpBuilder builder(llvmFunc->getContext());
        builder.setInsertionPointAfter(llvmFunc);

        // Extract entry address from function name.
        uint64_t entryAddr = 0;
        auto name = llvmFunc.getName();
        if (name.starts_with("lifted_")) {
            auto addrStr = name.drop_front(7);
            llvm::StringRef(addrStr).getAsInteger(10, entryAddr);
        } else if (name.starts_with("sub_")) {
            auto addrStr = name.drop_front(4);
            llvm::StringRef(addrStr).getAsInteger(16, entryAddr);
        }

        // Build register tracker.
        RegisterTracker regs;
        regs.scan(llvmFunc);

        // Create the HelixLow function.
        auto funcName = std::format("sub_{:x}", entryAddr);
        auto helixFunc = builder.create<helix::low::FuncOp>(
            llvmFunc.getLoc(),
            builder.getStringAttr(funcName),
            IntegerAttr::get(
                IntegerType::get(builder.getContext(), 64,
                                 IntegerType::Unsigned),
                entryAddr),
            /*original_name=*/StringAttr{});

        // Steal the body from the LLVM function.
        // This preserves the CFG, blocks, and operations exactly as they were.
        helixFunc.getBody().takeBody(llvmFunc.getBody());

        // ─── Handle Entry Block Arguments ───────────────────────────────
        // Remill functions have the signature:
        //   (ptr %state, i64 %pc, ptr %memory)
        // We need to replace usages of these arguments with:
        //   %state  -> Undef (GEPs are tracked by RegisterTracker)
        //   %pc     -> Constant(entryAddr) (CRITICAL for PC-relative addressing)
        //   %memory -> Undef (Memory intrinsics handle this)
        
        Block& entryBlock = helixFunc.getBody().front();
        
        // Ensure we have the expected number of arguments (Remill standard is 3).
        // If optimization passes changed signature, we might need to be careful.
        if (entryBlock.getNumArguments() >= 2) {
            auto loc = llvmFunc.getLoc();
            builder.setInsertionPointToStart(&entryBlock);

            // Arg 0: %state
            // Replace with Undef. RegisterTracker already mapped the GEP results
            // derived from this, so we don't need the base pointer anymore.
            auto stateArg = entryBlock.getArgument(0);
            auto undefState = builder.create<LLVM::UndefOp>(loc, stateArg.getType());
            stateArg.replaceAllUsesWith(undefState);

            // Arg 1: %pc
            // Replace with the constant entry address.
            auto pcArg = entryBlock.getArgument(1);
            auto pcConst = builder.create<LLVM::ConstantOp>(
                loc, pcArg.getType(), 
                builder.getI64IntegerAttr(entryAddr));
            pcArg.replaceAllUsesWith(pcConst);

            // Arg 2: %memory (if present)
            if (entryBlock.getNumArguments() >= 3) {
                auto memArg = entryBlock.getArgument(2);
                auto undefMem = builder.create<LLVM::UndefOp>(loc, memArg.getType());
                memArg.replaceAllUsesWith(undefMem);
            }
        }

        // Remove arguments from the entry block signature (HelixLow funcs are void/void).
        // Note: eraseArguments invalidates argument indices, so we erase all.
        llvm::BitVector argsToErase(entryBlock.getNumArguments());
        argsToErase.set(0, entryBlock.getNumArguments());
        entryBlock.eraseArguments(argsToErase);

        // ─── Convert Operations ─────────────────────────────────────────
        
        // Create a dummy block for unresolved branches (semantics that need a target).
        // We add it to the end.
        auto* dummyBlock = new Block();
        helixFunc.getBody().push_back(dummyBlock);
        builder.setInsertionPointToStart(dummyBlock);
        builder.create<helix::low::RetOp>(llvmFunc.getLoc(), IntegerAttr{});

        PCTracker pcTracker;
        llvm::SmallVector<Operation*, 16> opsToErase;

        // Walk the function and convert operations in-place.
        // We use a pre-order walk to ensure we handle definitions before uses if needed,
        // but since we are mostly replacing ops, order matters less than validity.
        // However, we must be careful not to invalidate the iterator.
        
        // We collect blocks first to avoid iterator issues if we add blocks (unlikely here).
        SmallVector<Block*> blocks;
        for (auto& block : helixFunc.getBody())
            blocks.push_back(&block);

        for (auto* block : blocks) {
            // A structure to hold a deferred terminator creation.
            std::function<void(OpBuilder&, IntegerAttr)> deferredTerminator = nullptr;

            for (auto it = block->begin(), e = block->end(); it != e; ) {
                Operation* op = &*it;
                it++;

                // Track PC updates.
                if (auto store = dyn_cast<LLVM::StoreOp>(op)) {
                    pcTracker.trackStore(store, regs);
                }

                builder.setInsertionPoint(op);
                convertOperation(op, builder, regs, pcTracker, dummyBlock, deferredTerminator, opsToErase);
            }

            // Emit deferred terminator if needed (e.g. replacing LLVM ret with HelixLow ret)
            if (deferredTerminator) {
                auto addrAttr = pcTracker.has_pc
                    ? IntegerAttr::get(
                          IntegerType::get(builder.getContext(), 64,
                                           IntegerType::Unsigned),
                          pcTracker.current_pc)
                    : IntegerAttr{};

                // Get the existing LLVM terminator (e.g., `br i1 true, ...`)
                // which we need to erase after emitting the HelixLow terminator.
                auto* oldTerminator = block->getTerminator();

                // Insert the new terminator BEFORE the old one.
                if (oldTerminator) {
                    builder.setInsertionPoint(oldTerminator);
                } else {
                    builder.setInsertionPointToEnd(block);
                }

                deferredTerminator(builder, addrAttr);

                // Erase the old LLVM terminator so the new JccOp/JmpOp/RetOp
                // becomes the real block terminator with correct successor edges.
                if (oldTerminator) {
                    oldTerminator->erase();
                }
            }
        }

        // ─── Erase collected ops ────────────────────────────────────────
        for (auto* op : opsToErase) {
            op->erase();
        }

        // Remove dummy block if unused
        if (dummyBlock->use_empty()) {
            dummyBlock->erase();
        }

        // We can now safely erase the original LLVM function.
        llvmFunc.erase();

        return success();
    }

    /// Convert a single LLVM Dialect operation to HelixLow.
    void convertOperation(Operation* op, OpBuilder& builder,
                          const RegisterTracker& regs,
                          PCTracker& pcTracker,
                          Block* dummyBlock,
                          std::function<void(OpBuilder&, IntegerAttr)>& deferredTerminator,
                          llvm::SmallVector<Operation*, 16>& opsToErase) {
        auto loc = op->getLoc();
        // Build address attribute as UI64 (unsigned 64-bit int) to satisfy
        // OptionalAttr<UI64Attr> constraints in HelixLowOps.td.
        auto addrAttr = pcTracker.has_pc
            ? IntegerAttr::get(
                  IntegerType::get(builder.getContext(), 64,
                                   IntegerType::Unsigned),
                  pcTracker.current_pc)
            : IntegerAttr{};

        // ─── Pattern: Load from register pointer ─────────────────────────
        if (auto load = dyn_cast<LLVM::LoadOp>(op)) {
            if (auto regName = regs.getRegName(load.getAddr())) {
                // Fold tracked bookkeeping slots directly to constants so
                // they don't become orphan temporaries like v0/v1/v7.
                if (auto it = pcTracker.trackedValues.find(*regName);
                    it != pcTracker.trackedValues.end() &&
                    load.getResult().getType().isSignlessInteger()) {
                    auto intTy = cast<IntegerType>(load.getResult().getType());
                    auto constant = builder.create<LLVM::ConstantOp>(
                        loc,
                        intTy,
                        IntegerAttr::get(intTy, it->second));
                    load.getResult().replaceAllUsesWith(constant.getResult());
                    opsToErase.push_back(op);
                    return;
                }

                if ((*regName == "PC" || *regName == "NEXT_PC" ||
                     *regName == "RETURN_PC") &&
                    load.getResult().getType().isSignlessInteger()) {
                    llvm::DenseSet<Block*> visitingBlocks;
                    if (auto resolved = resolvePointerValueBefore(
                            load->getBlock(), Block::iterator(load),
                            load.getAddr(), /*depth=*/6, visitingBlocks)) {
                        auto intTy = cast<IntegerType>(load.getResult().getType());
                        auto constant = builder.create<LLVM::ConstantOp>(
                            loc,
                            intTy,
                            IntegerAttr::get(intTy, *resolved));
                        load.getResult().replaceAllUsesWith(constant.getResult());
                        opsToErase.push_back(op);
                        return;
                    }
                }

                unsigned width = RegisterTracker::inferRegWidth(*regName);
                auto intTy = builder.getIntegerType(width);

                auto regRead = builder.create<helix::low::RegReadOp>(
                    loc,
                    intTy,
                    builder.getStringAttr(*regName),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
                load.getResult().replaceAllUsesWith(regRead.getResult());
                opsToErase.push_back(op);
                return;
            }
            // Non-register load — stack/memory access.
            // Emit as helix_low.mem.read so downstream passes can resolve
            // stack variables or memory accesses.
            {
                auto addrVal = load.getAddr();
                auto resultTy = load.getResult().getType();
                unsigned width = 64;
                if (auto intTy = dyn_cast<IntegerType>(resultTy))
                    width = intTy.getWidth();

                auto memRead = builder.create<helix::low::MemReadOp>(
                    loc,
                    builder.getIntegerType(width),
                    ensureInt64(addrVal, builder, loc, &regs, &pcTracker),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
                load.getResult().replaceAllUsesWith(memRead.getResult());
                opsToErase.push_back(op);
            }
            return;
        }

        // ─── Pattern: Store to register pointer ──────────────────────────
        if (auto store = dyn_cast<LLVM::StoreOp>(op)) {
            // ─── Skip dead stores from Memory* chain breaking ────────────
            // After eraseRemillCall(), the Memory* token is replaced with
            // UndefOp. The stored value may go through ExtractValueOp,
            // IntToPtrOp, or PtrToIntOp before reaching the store.
            {
                Value val = store.getValue();
                Operation* defOp = val.getDefiningOp();
                // Trace through wrapper ops to find the root UndefOp.
                while (defOp) {
                    if (isa<LLVM::UndefOp>(defOp))
                        return;
                    if (auto ev = dyn_cast<LLVM::ExtractValueOp>(defOp)) {
                        defOp = ev.getContainer().getDefiningOp();
                    } else if (auto itop = dyn_cast<LLVM::IntToPtrOp>(defOp)) {
                        defOp = itop.getArg().getDefiningOp();
                    } else if (auto ptoi = dyn_cast<LLVM::PtrToIntOp>(defOp)) {
                        defOp = ptoi.getArg().getDefiningOp();
                    } else if (auto bitcast = dyn_cast<LLVM::BitcastOp>(defOp)) {
                        defOp = bitcast.getArg().getDefiningOp();
                    } else {
                        break;
                    }
                }
            }

            // ─── Skip stores to MEMORY alloca ────────────────────────────
            // Remill keeps a `ptr %MEMORY` alloca and stores the Memory*
            // token back after every semantic call. These produce the
            // `*((int64_t)(&__local)) = ...` noise in the C output.
            if (store.getAddr().getDefiningOp<LLVM::AllocaOp>())
                return;

            if (auto regName = regs.getRegName(store.getAddr())) {
                // Skip PC/NEXT_PC updates — these are bookkeeping
                if (*regName == "PC" || *regName == "NEXT_PC")
                    return;
                // Skip MEMORY, STATE, segment bases — Remill internals
                if (*regName == "MEMORY" || *regName == "STATE" ||
                    regName->ends_with("BASE"))
                    return;

                unsigned width = RegisterTracker::inferRegWidth(*regName);

                builder.create<helix::low::RegWriteOp>(
                    loc,
                    store.getValue(),
                    builder.getStringAttr(*regName),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
                opsToErase.push_back(op);
                return;
            }
            // Non-register store — stack/memory access.
            // Emit as helix_low.mem.write so downstream passes can resolve
            // stack variables or memory accesses.
            {
                auto addrVal = store.getAddr();
                auto valTy = store.getValue().getType();
                unsigned width = 64;
                if (auto intTy = dyn_cast<IntegerType>(valTy))
                    width = intTy.getWidth();

                builder.create<helix::low::MemWriteOp>(
                    loc,
                    ensureInt64(addrVal, builder, loc, &regs, &pcTracker),
                    ensureInt64(store.getValue(), builder, loc, &regs, &pcTracker),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
                opsToErase.push_back(op);
            }
            return;
        }

        // ─── Pattern: Call to Remill semantic or intrinsic ───────────────
        if (auto call = dyn_cast<LLVM::CallOp>(op)) {
            auto callee = call.getCallee();
            if (!callee)
                return;

            auto calleeName = callee->str();

            // Helper: break the Memory* use-def chain for any Remill call
            // and mark it for erasure. This MUST be called on every code path
            // that handles a Remill LLVM::CallOp, otherwise the PseudoCEmitter
            // will render it as MOV(...), CMP(...), etc.
            auto eraseRemillCall = [&]() {
                if (call.getNumResults() > 0) {
                    auto result = op->getResult(0);
                    if (!result.use_empty()) {
                        auto undef = builder.create<LLVM::UndefOp>(loc, result.getType());
                        result.replaceAllUsesWith(undef);
                    }
                }
                opsToErase.push_back(op);
            };

            // Check for Remill memory intrinsics.
            if (calleeName.starts_with("__remill_read_memory_")) {
                unsigned width = extractRemillMemoryWidth(calleeName);
                if (width == 0) return;

                auto intTy = builder.getIntegerType(width);
                // __remill_read_memory_N(ptr %memory, i64 %addr) -> iN
                // Operand 1 is the address (operand 0 is the memory token).
                if (call.getNumOperands() >= 2) {
                    builder.create<helix::low::MemReadOp>(
                        loc,
                        intTy,
                        call.getOperand(1),  // address
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                }
                eraseRemillCall();
                return;
            }

            if (calleeName.starts_with("__remill_write_memory_")) {
                unsigned width = extractRemillMemoryWidth(calleeName);
                if (width == 0) return;

                // __remill_write_memory_N(ptr %memory, i64 %addr, iN %value) -> ptr
                if (call.getNumOperands() >= 3) {
                    builder.create<helix::low::MemWriteOp>(
                        loc,
                        call.getOperand(1),  // address
                        call.getOperand(2),  // value
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                }
                eraseRemillCall();
                return;
            }

            // Skip other Remill helpers (flag computations, etc.)
            if (calleeName.starts_with("__remill_") ||
                calleeName.starts_with("llvm.")) {
                eraseRemillCall();
                return;
            }

            // Try to demangle as a Remill semantic function.
            auto semInfo = demangleRemillSemantic(calleeName);
            if (!semInfo) {
                // Unrecognized mangled name — preserve the call and emit warning.
                // This ensures we don't silently drop calls that might be
                // important for the decompiled output.
                if (calleeName.starts_with("_Z")) {
                    op->emitWarning("unrecognized mangled name: ") << calleeName;
                }
                // Emit as a generic call with the original name preserved.
                // Use a zero constant as placeholder target address.
                auto zero = builder.create<LLVM::ConstantOp>(
                    loc, builder.getI64Type(), builder.getI64IntegerAttr(0));
                builder.create<helix::low::CallOp>(
                    loc,
                    zero,
                    mlir::ValueRange{},
                    builder.getStringAttr(calleeName),
                    addrAttr);
                
                // Break the use-def chain and mark for erasure to ensure
                // Memory* tokens don't leak into variable recovery.
                eraseRemillCall();
                return;
            }

            if (semInfo->is_helper) {
                eraseRemillCall();
                return;
            }

            convertSemantic(call, builder, regs, *semInfo, addrAttr, loc, dummyBlock, deferredTerminator, pcTracker);

            // Break the use-def chain and mark for erasure.
            eraseRemillCall();

            return;
        }

        // ─── Pattern: GEP (register access setup) — skip ────────────────
        if (isa<LLVM::GEPOp>(op))
            return;

        // ─── Pattern: Alloca (Remill internals) — skip ──────────────────
        if (isa<LLVM::AllocaOp>(op))
            return;

        // ─── Pattern: Return — emit HelixLow ret ────────────────────────
        if (isa<LLVM::ReturnOp>(op)) {
            deferredTerminator = [loc](OpBuilder& b, IntegerAttr addr) {
                b.create<helix::low::RetOp>(loc, addr);
            };
            return;
        }

        // ─── Pattern: Add (PC increment) — check if bookkeeping ─────────
        // Remill emits: %next = add i64 %pc, <size> for PC tracking.
        // We skip these as they're handled by PCTracker.
        if (isa<LLVM::AddOp>(op))
            return;

        // Other LLVM ops are currently ignored (will be handled as passes mature).
    }

    /// Helper to cast pointers to i64 for arithmetic/logic operations
    Value ensureInt64(Value val, OpBuilder& builder, Location loc,
                      const RegisterTracker* regs = nullptr,
                      const PCTracker* pcTracker = nullptr) {
        if (regs && pcTracker) {
            if (auto evaluated = pcTracker->tryEvaluate(val, *regs)) {
                return builder.create<LLVM::ConstantOp>(
                    loc,
                    builder.getI64Type(),
                    builder.getI64IntegerAttr(*evaluated));
            }
        }
        if (isa<LLVM::LLVMPointerType>(val.getType())) {
            return builder.create<LLVM::PtrToIntOp>(
                loc, builder.getI64Type(), val);
        }
        return val;
    }

    unsigned inferValueWidth(Value val) {
        if (auto intTy = dyn_cast<IntegerType>(val.getType()))
            return intTy.getWidth();
        if (isa<LLVM::LLVMPointerType>(val.getType()))
            return 64;
        return 64;
    }

    unsigned inferStoreValueWidth(Value val, const RegisterTracker& regs) {
        if (auto intTy = dyn_cast<IntegerType>(val.getType())) {
            if (intTy.getWidth() < 64)
                return intTy.getWidth();
        }

        if (auto zext = val.getDefiningOp<LLVM::ZExtOp>()) {
            if (auto intTy = dyn_cast<IntegerType>(zext.getArg().getType()))
                return intTy.getWidth();
        }

        if (auto sext = val.getDefiningOp<LLVM::SExtOp>()) {
            if (auto intTy = dyn_cast<IntegerType>(sext.getArg().getType()))
                return intTy.getWidth();
        }

        if (auto trunc = val.getDefiningOp<LLVM::TruncOp>()) {
            if (auto intTy = dyn_cast<IntegerType>(trunc.getResult().getType()))
                return intTy.getWidth();
        }

        if (auto load = val.getDefiningOp<LLVM::LoadOp>()) {
            if (auto regName = regs.getRegName(load.getAddr()))
                return RegisterTracker::inferRegWidth(*regName);
        }

        return inferValueWidth(val);
    }

    void emitRegisterOrMemoryWrite(OpBuilder& builder, Location loc,
                                   Value destination, Value originalValue,
                                   Value widenedResult,
                                   const RegisterTracker& regs,
                                   IntegerAttr addrAttr) {
        auto regName = regs.getRegName(destination);
        unsigned width = regName
            ? RegisterTracker::inferRegWidth(*regName)
            : inferValueWidth(originalValue);

        Value resultVal = widenedResult;
        if (width < 64) {
            resultVal = builder.create<LLVM::TruncOp>(
                loc, builder.getIntegerType(width), resultVal);
        }

        if (regName) {
            builder.create<helix::low::RegWriteOp>(
                loc,
                resultVal,
                builder.getStringAttr(*regName),
                builder.getUI32IntegerAttr(width),
                addrAttr);
            return;
        }

        builder.create<helix::low::MemWriteOp>(
            loc,
            ensureInt64(destination, builder, loc),
            resultVal,
            builder.getUI32IntegerAttr(width),
            addrAttr);
    }

    /// Helper to strip casts for register equality checking
    Value stripCasts(Value val) {
        while (val && val.getDefiningOp()) {
            Operation* op = val.getDefiningOp();
            if (auto ptr2int = dyn_cast<LLVM::PtrToIntOp>(op)) { val = ptr2int.getArg(); continue; }
            if (auto int2ptr = dyn_cast<LLVM::IntToPtrOp>(op)) { val = int2ptr.getArg(); continue; }
            if (auto zext = dyn_cast<LLVM::ZExtOp>(op)) { val = zext.getArg(); continue; }
            if (auto sext = dyn_cast<LLVM::SExtOp>(op)) { val = sext.getArg(); continue; }
            if (auto trunc = dyn_cast<LLVM::TruncOp>(op)) { val = trunc.getArg(); continue; }
            if (auto bcast = dyn_cast<LLVM::BitcastOp>(op)) { val = bcast.getArg(); continue; }
            break;
        }
        return val;
    }

    static std::string normalizeRegName(llvm::StringRef name) {
        if (name == "EAX" || name == "AX" || name == "AL" || name == "AH") return "RAX";
        if (name == "EBX" || name == "BX" || name == "BL" || name == "BH") return "RBX";
        if (name == "ECX" || name == "CX" || name == "CL" || name == "CH") return "RCX";
        if (name == "EDX" || name == "DX" || name == "DL" || name == "DH") return "RDX";
        if (name == "ESI" || name == "SI" || name == "SIL") return "RSI";
        if (name == "EDI" || name == "DI" || name == "DIL") return "RDI";
        if (name == "EBP" || name == "BP" || name == "BPL") return "RBP";
        if (name == "ESP" || name == "SP" || name == "SPL") return "RSP";
        if (name == "R8D" || name == "R8W" || name == "R8B") return "R8";
        if (name == "R9D" || name == "R9W" || name == "R9B") return "R9";
        if (name == "R10D" || name == "R10W" || name == "R10B") return "R10";
        if (name == "R11D" || name == "R11W" || name == "R11B") return "R11";
        if (name == "R12D" || name == "R12W" || name == "R12B") return "R12";
        if (name == "R13D" || name == "R13W" || name == "R13B") return "R13";
        if (name == "R14D" || name == "R14W" || name == "R14B") return "R14";
        if (name == "R15D" || name == "R15W" || name == "R15B") return "R15";
        return name.str();
    }

    /// Check if two SSA values originate from the same register.
    /// This detects idioms like XOR reg, reg / MOV reg, reg / TEST reg, reg.
    bool isSameRegisterOperand(Value a, Value b, const RegisterTracker& regs) {
        a = stripCasts(a);
        b = stripCasts(b);
        // Same SSA value → definitely same register.
        if (a == b)
            return true;

        // Both must resolve to known registers with the same name.
        auto regA = regs.getRegName(a);
        auto regB = regs.getRegName(b);
        if (regA && regB && normalizeRegName(*regA) == normalizeRegName(*regB))
            return true;

        // Check if both values have already been converted to RegReadOp
        auto rrA = a.getDefiningOp<helix::low::RegReadOp>();
        auto rrB = b.getDefiningOp<helix::low::RegReadOp>();
        if (rrA && rrB) {
            if (normalizeRegName(rrA.getRegName()) == normalizeRegName(rrB.getRegName()))
                return true;
        }

        auto loadA = a.getDefiningOp<LLVM::LoadOp>();
        auto loadB = b.getDefiningOp<LLVM::LoadOp>();
        if (loadA && loadB) {
            auto rA = regs.getRegName(loadA.getAddr());
            auto rB = regs.getRegName(loadB.getAddr());
            if (rA && rB && normalizeRegName(*rA) == normalizeRegName(*rB))
                return true;
        }

        return false;
    }

    /// Safely extract an operand from a call, returning a zero constant if
    /// the index is out of bounds. This handles Remill semantics with variable
    /// argument layouts (e.g., 8-bit vs 64-bit variants may have different
    /// numbers of operands) without crashing on unexpected layouts.
    Value safeGetOperand(LLVM::CallOp call, unsigned idx,
                         OpBuilder& builder, Location loc) {
        if (idx < call.getNumOperands())
            return call.getOperand(idx);
        // Out of bounds — return a zero constant as fallback.
        return builder.create<LLVM::ConstantOp>(
            loc, builder.getI64Type(), builder.getI64IntegerAttr(0));
    }

    std::optional<Value> findLatestRegWriteInBlock(
        Block* block, Block::iterator endIt, llvm::StringRef canonicalReg) {
        if (!block)
            return std::nullopt;

        for (auto it = endIt; it != block->begin();) {
            --it;
            if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&*it)) {
                llvm::StringRef lookup =
                    helix::analysis::getCanonicalX86Register(regWrite.getRegName());
                if (lookup.empty())
                    lookup = regWrite.getRegName();
                if (lookup == canonicalReg)
                    return regWrite.getValue();
            }
        }

        return std::nullopt;
    }

    std::optional<Value> findLatestRegWriteInPredecessors(
        Block* block, llvm::StringRef canonicalReg, unsigned depth,
        llvm::DenseSet<Block*>& visiting) {
        if (!block || depth == 0 || !visiting.insert(block).second)
            return std::nullopt;

        std::optional<Value> candidate;
        for (Block* pred : block->getPredecessors()) {
            auto value = findLatestRegWriteInBlock(pred, pred->end(), canonicalReg);
            if (!value)
                value = findLatestRegWriteInPredecessors(
                    pred, canonicalReg, depth - 1, visiting);
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

    llvm::SmallVector<Value, 4> collectWin64CallArgs(
        Operation* beforeOp, unsigned predecessorDepth = 2) {
        static constexpr std::array<std::string_view, 4> kWin64ArgRegs = {
            "RCX", "RDX", "R8", "R9"
        };

        auto* block = beforeOp ? beforeOp->getBlock() : nullptr;
        if (!block)
            return {};

        llvm::DenseMap<llvm::StringRef, Value> regState;
        for (auto& op : block->getOperations()) {
            if (&op == beforeOp)
                break;
            if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&op)) {
                llvm::StringRef lookup =
                    helix::analysis::getCanonicalX86Register(regWrite.getRegName());
                if (lookup.empty())
                    lookup = regWrite.getRegName();
                regState[lookup] = regWrite.getValue();
            }
        }

        llvm::SmallVector<Value, 4> args;
        for (auto argReg : kWin64ArgRegs) {
            llvm::StringRef key(argReg.data(), argReg.size());
            auto it = regState.find(key);
            if (it == regState.end()) {
                llvm::DenseSet<Block*> visiting;
                auto fromPreds = findLatestRegWriteInPredecessors(
                    block, key, predecessorDepth, visiting);
                if (!fromPreds)
                    break;
                regState[key] = *fromPreds;
                it = regState.find(key);
            }
            args.push_back(it->second);
        }

        return args;
    }

    std::optional<LLVM::StoreOp> findLatestStoreToPointerInBlock(
        Block* block, Block::iterator endIt, Value ptr) {
        if (!block)
            return std::nullopt;

        ptr = RegisterTracker::stripPointerAliases(ptr);
        for (auto it = endIt; it != block->begin();) {
            --it;
            auto store = dyn_cast<LLVM::StoreOp>(&*it);
            if (!store)
                continue;
            if (RegisterTracker::stripPointerAliases(store.getAddr()) == ptr)
                return store;
        }

        return std::nullopt;
    }

    std::optional<int64_t> tryEvaluateBookkeepingValue(
        Value value,
        llvm::function_ref<std::optional<int64_t>(Value)> resolvePointer,
        llvm::SmallPtrSetImpl<Operation*>& visiting) {
        if (!value)
            return std::nullopt;

        auto* defOp = value.getDefiningOp();
        if (!defOp)
            return std::nullopt;
        if (!visiting.insert(defOp).second)
            return std::nullopt;

        auto eraseOnReturn = llvm::make_scope_exit([&] {
            visiting.erase(defOp);
        });

        if (auto constOp = dyn_cast<LLVM::ConstantOp>(defOp)) {
            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                return intAttr.getValue().getSExtValue();
        }

        if (auto constOp = dyn_cast<arith::ConstantOp>(defOp)) {
            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                return intAttr.getValue().getSExtValue();
        }

        if (auto intAttr = defOp->getAttrOfType<IntegerAttr>("value"))
            return intAttr.getValue().getSExtValue();

        if (auto load = dyn_cast<LLVM::LoadOp>(defOp))
            return resolvePointer(RegisterTracker::stripPointerAliases(load.getAddr()));

        if (auto add = dyn_cast<LLVM::AddOp>(defOp)) {
            auto lhs = tryEvaluateBookkeepingValue(
                add.getLhs(), resolvePointer, visiting);
            auto rhs = tryEvaluateBookkeepingValue(
                add.getRhs(), resolvePointer, visiting);
            if (lhs && rhs)
                return *lhs + *rhs;
            return std::nullopt;
        }

        if (auto sub = dyn_cast<LLVM::SubOp>(defOp)) {
            auto lhs = tryEvaluateBookkeepingValue(
                sub.getLhs(), resolvePointer, visiting);
            auto rhs = tryEvaluateBookkeepingValue(
                sub.getRhs(), resolvePointer, visiting);
            if (lhs && rhs)
                return *lhs - *rhs;
            return std::nullopt;
        }

        if (auto zext = dyn_cast<LLVM::ZExtOp>(defOp))
            return tryEvaluateBookkeepingValue(
                zext.getArg(), resolvePointer, visiting);
        if (auto sext = dyn_cast<LLVM::SExtOp>(defOp))
            return tryEvaluateBookkeepingValue(
                sext.getArg(), resolvePointer, visiting);
        if (auto trunc = dyn_cast<LLVM::TruncOp>(defOp))
            return tryEvaluateBookkeepingValue(
                trunc.getArg(), resolvePointer, visiting);
        if (auto ptrToInt = dyn_cast<LLVM::PtrToIntOp>(defOp))
            return tryEvaluateBookkeepingValue(
                ptrToInt.getArg(), resolvePointer, visiting);
        if (auto intToPtr = dyn_cast<LLVM::IntToPtrOp>(defOp))
            return tryEvaluateBookkeepingValue(
                intToPtr.getArg(), resolvePointer, visiting);

        return std::nullopt;
    }

    std::optional<int64_t> resolvePointerValueBefore(
        Block* block, Block::iterator endIt, Value ptr, unsigned depth,
        llvm::DenseSet<Block*>& visitingBlocks) {
        if (!block || depth == 0)
            return std::nullopt;

        ptr = RegisterTracker::stripPointerAliases(ptr);

        if (auto store = findLatestStoreToPointerInBlock(block, endIt, ptr)) {
            llvm::SmallPtrSet<Operation*, 16> visitingValues;
            auto resolveNestedPointer =
                [&](Value nestedPtr) -> std::optional<int64_t> {
                return resolvePointerValueBefore(
                    block, Block::iterator(store->getOperation()),
                    nestedPtr, depth - 1, visitingBlocks);
            };
            return tryEvaluateBookkeepingValue(
                store->getValue(), resolveNestedPointer, visitingValues);
        }

        if (!visitingBlocks.insert(block).second)
            return std::nullopt;

        std::optional<int64_t> candidate;
        for (Block* pred : block->getPredecessors()) {
            auto value = resolvePointerValueBefore(
                pred, pred->end(), ptr, depth - 1, visitingBlocks);
            if (!value) {
                visitingBlocks.erase(block);
                return std::nullopt;
            }
            if (candidate && *candidate != *value) {
                visitingBlocks.erase(block);
                return std::nullopt;
            }
            candidate = *value;
        }

        visitingBlocks.erase(block);
        return candidate;
    }

    /// Convert a recognized Remill semantic function call to HelixLow ops.
    void convertSemantic(LLVM::CallOp call, OpBuilder& builder,
                         const RegisterTracker& regs,
                         const RemillSemanticInfo& semInfo,
                         IntegerAttr addrAttr, Location loc,
                         Block* dummyBlock,
                         std::function<void(OpBuilder&, IntegerAttr)>& deferredTerminator,
                         const PCTracker& pcTracker = {}) {
        auto semantic = semInfo.semantic;

        // Determine the working integer type (default 64-bit for x86_64).
        auto i64Ty = builder.getIntegerType(64);
        auto i1Ty = builder.getIntegerType(1);

        switch (semantic) {
        // ─── Arithmetic/Logic Binary Ops ─────────────────────────────────
        case RemillSemantic::ADD:
        case RemillSemantic::SUB:
        case RemillSemantic::MUL:
        case RemillSemantic::IMUL:
        case RemillSemantic::DIV:
        case RemillSemantic::IDIV:
        case RemillSemantic::AND:
        case RemillSemantic::OR:
        case RemillSemantic::XOR:
        case RemillSemantic::SHL:
        case RemillSemantic::SHR:
        case RemillSemantic::SAR:
        case RemillSemantic::ROL:
        case RemillSemantic::ROR: {
            auto kind = semanticToBinOpKind(semantic);
            if (!kind) break;

            // Remill binary op layout: (mem, state, dest_reg_ptr, lhs, rhs)
            // Use safeGetOperand for variable argument layouts.
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = safeGetOperand(call, 2, builder, loc);
                auto lhs = safeGetOperand(call, 3, builder, loc);
                auto rhs = safeGetOperand(call, 4, builder, loc);

                // ─── Idiom: XOR reg, reg → zero (emit int_lit 0) ────────
                // When both operands reference the same register, XOR reg,reg
                // is an idiom for zeroing. Emit helix_high.int_lit 0 directly
                // so downstream passes (DCE) see a constant zero instead of
                // a binop XOR that would need special-case handling.
                bool selfXor = (semantic == RemillSemantic::XOR) &&
                               isSameRegisterOperand(lhs, rhs, regs);

                auto regName = regs.getRegName(destRegPtr);
                unsigned width = 64;
                if (regName) {
                    width = RegisterTracker::inferRegWidth(*regName);
                }

                if (selfXor) {
                    auto intTy = builder.getIntegerType(width);
                    auto signedI64Ty = IntegerType::get(builder.getContext(), 64,
                                                        IntegerType::Signed);
                    auto zeroLit = builder.create<helix::high::IntLitOp>(
                        loc, intTy,
                        IntegerAttr::get(signedI64Ty, 0),
                        addrAttr);

                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        zeroLit.getResult(),
                        builder.getStringAttr(regName ? *regName : "unknown"),
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                    break;
                }

                auto binOp = builder.create<helix::low::BinOp>(
                    loc,
                    /*result=*/i64Ty,
                    /*carry_flag=*/i1Ty,
                    /*zero_flag=*/i1Ty,
                    /*sign_flag=*/i1Ty,
                    /*overflow_flag=*/i1Ty,
                    *kind,
                    ensureInt64(lhs, builder, loc, &regs, &pcTracker),   // lhs
                    ensureInt64(rhs, builder, loc, &regs, &pcTracker),   // rhs
                    addrAttr,
                    UnitAttr{});

                // ─── Mark SUB RSP,N / ADD RSP,N for DCE ─────────────────
                // When the destination is RSP and the operation is SUB or ADD,
                // this is stack frame allocation/deallocation. Mark the BinOp
                // with attributes so the DCE pass can pair and remove them.
                if (regName && *regName == "RSP") {
                    if (semantic == RemillSemantic::SUB) {
                        binOp->setAttr("is_stack_alloc",
                                       builder.getUnitAttr());
                        // Try to extract the immediate value from the rhs operand.
                        if (auto constOp = rhs.getDefiningOp<LLVM::ConstantOp>()) {
                            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                                binOp->setAttr("stack_adjust_imm", intAttr);
                            }
                        }
                    } else if (semantic == RemillSemantic::ADD) {
                        binOp->setAttr("is_stack_dealloc",
                                       builder.getUnitAttr());
                        // Try to extract the immediate value from the rhs operand.
                        if (auto constOp = rhs.getDefiningOp<LLVM::ConstantOp>()) {
                            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                                binOp->setAttr("stack_adjust_imm", intAttr);
                            }
                        }
                    }
                }

                Value resultVal = binOp.getResult();
                if (width < 64) {
                    resultVal = builder.create<LLVM::TruncOp>(loc, builder.getIntegerType(width), resultVal);
                }

                if (regName) {
                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        resultVal,
                        builder.getStringAttr(*regName),
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                } else if (!isa<LLVM::LLVMPointerType>(destRegPtr.getType())) {
                    builder.create<helix::low::MemWriteOp>(
                        loc,
                        ensureInt64(destRegPtr, builder, loc, &regs, &pcTracker),
                        binOp.getResult(),
                        builder.getUI32IntegerAttr(64),
                        addrAttr);
                } else {
                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        binOp.getResult(),
                        builder.getStringAttr("unknown"),
                        builder.getUI32IntegerAttr(64),
                        addrAttr);
                }

                builder.create<helix::low::RegWriteOp>(loc, binOp.getCarryFlag(), builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, binOp.getZeroFlag(), builder.getStringAttr("ZF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, binOp.getSignFlag(), builder.getStringAttr("SF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, binOp.getOverflowFlag(), builder.getStringAttr("OF"), builder.getUI32IntegerAttr(1), addrAttr);
            }
            break;
        }

        // ─── Comparison ──────────────────────────────────────────────────
        case RemillSemantic::CMP: {
            // Remill CMP layout: (mem, state, lhs, rhs) — variable positions
            if (call.getNumOperands() >= 3) {
                auto cmpOp = builder.create<helix::low::CmpOp>(
                    loc,
                    /*carry_flag=*/i1Ty,
                    /*zero_flag=*/i1Ty,
                    /*sign_flag=*/i1Ty,
                    /*overflow_flag=*/i1Ty,
                    ensureInt64(safeGetOperand(call, 2, builder, loc), builder, loc,
                                &regs, &pcTracker),
                    ensureInt64(safeGetOperand(call, 3, builder, loc), builder, loc,
                                &regs, &pcTracker),
                    addrAttr);
                
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getCarryFlag(), builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getZeroFlag(), builder.getStringAttr("ZF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getSignFlag(), builder.getStringAttr("SF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getOverflowFlag(), builder.getStringAttr("OF"), builder.getUI32IntegerAttr(1), addrAttr);
            }
            break;
        }

        case RemillSemantic::TEST: {
            // Remill TEST layout: (mem, state, lhs, rhs) — variable positions
            if (call.getNumOperands() >= 3) {
                auto lhs = safeGetOperand(call, 2, builder, loc);
                auto rhs = safeGetOperand(call, 3, builder, loc);

                // ─── Idiom: TEST reg, reg → CMP reg, 0 ─────────────────
                // When both operands are the same register, TEST reg, reg
                // is equivalent to comparing reg against zero. Convert to
                // helix_low.cmp reg, 0 so downstream passes can emit
                // `if (var == 0)` / `if (var != 0)` directly.
                if (isSameRegisterOperand(lhs, rhs, regs)) {
                    auto zero = builder.create<LLVM::ConstantOp>(
                        loc, i64Ty, builder.getI64IntegerAttr(0));
                    auto cmpOp = builder.create<helix::low::CmpOp>(
                        loc,
                        /*carry_flag=*/i1Ty,
                        /*zero_flag=*/i1Ty,
                        /*sign_flag=*/i1Ty,
                        /*overflow_flag=*/i1Ty,
                        ensureInt64(lhs, builder, loc, &regs, &pcTracker),
                        zero,
                        addrAttr);

                    builder.create<helix::low::RegWriteOp>(loc, cmpOp.getCarryFlag(), builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                    builder.create<helix::low::RegWriteOp>(loc, cmpOp.getZeroFlag(), builder.getStringAttr("ZF"), builder.getUI32IntegerAttr(1), addrAttr);
                    builder.create<helix::low::RegWriteOp>(loc, cmpOp.getSignFlag(), builder.getStringAttr("SF"), builder.getUI32IntegerAttr(1), addrAttr);
                    builder.create<helix::low::RegWriteOp>(loc, cmpOp.getOverflowFlag(), builder.getStringAttr("OF"), builder.getUI32IntegerAttr(1), addrAttr);
                } else {
                    auto testOp = builder.create<helix::low::TestOp>(
                        loc,
                        /*zero_flag=*/i1Ty,
                        /*sign_flag=*/i1Ty,
                        ensureInt64(lhs, builder, loc, &regs, &pcTracker),
                        ensureInt64(rhs, builder, loc, &regs, &pcTracker),
                        addrAttr);

                    builder.create<helix::low::RegWriteOp>(loc, testOp.getZeroFlag(), builder.getStringAttr("ZF"), builder.getUI32IntegerAttr(1), addrAttr);
                    builder.create<helix::low::RegWriteOp>(loc, testOp.getSignFlag(), builder.getStringAttr("SF"), builder.getUI32IntegerAttr(1), addrAttr);
                }
            }
            break;
        }

        // ─── Data Movement ───────────────────────────────────────────────
        case RemillSemantic::MOV: {
            // Remill MOV semantic: call @MOV(mem, state, dst_reg_ptr, src_value)
            // Operand layout: [0]=memory, [1]=state, [2]=dest_reg_ptr, [3]=value
            // Use safeGetOperand for variable argument layouts.
            if (call.getNumOperands() >= 3) {
                auto destRegPtr = safeGetOperand(call, 2, builder, loc);
                auto srcValue = safeGetOperand(call, 3, builder, loc);

                // ─── Idiom: MOV reg, reg → eliminated (no-op) ───────────
                // When source and destination are the same register, the MOV
                // has no effect. Skip emitting any operation.
                auto destRegName = regs.getRegName(destRegPtr);
                if (destRegName) {
                    // Check if srcValue comes from a load of the same register.
                    if (auto srcLoad = srcValue.getDefiningOp<LLVM::LoadOp>()) {
                        auto srcRegName = regs.getRegName(srcLoad.getAddr());
                        if (srcRegName && *srcRegName == *destRegName) {
                            // MOV reg, reg — eliminate as no-op.
                            break;
                        }
                    }
                    // Also check if srcValue is a GEP to the same register
                    // (pointer-level identity).
                    if (isSameRegisterOperand(destRegPtr, srcValue, regs)) {
                        break;
                    }
                }

                // Try to resolve the destination register name from the GEP pointer.
                if (destRegName) {
                    unsigned width = RegisterTracker::inferRegWidth(*destRegName);
                    auto intTy = builder.getIntegerType(width);
                    Value finalVal = srcValue;

                    // ─── Memory source: MOV reg, [mem] ──────────────────
                    // When the source is a memory operand (Mn), srcValue is
                    // an ADDRESS.  Emit MemReadOp to load the actual value.
                    if (semInfo.has_memory_src) {
                        unsigned readWidth = semInfo.src_width;
                        auto readTy = builder.getIntegerType(readWidth);
                        auto memRead = builder.create<helix::low::MemReadOp>(
                            loc,
                            readTy,
                            ensureInt64(srcValue, builder, loc, &regs, &pcTracker),
                            builder.getUI32IntegerAttr(readWidth),
                            addrAttr);
                        finalVal = memRead.getResult();
                        // Extend to register width if needed (e.g., 32→64 for MOV EAX, [mem]).
                        if (readWidth < width) {
                            finalVal = builder.create<LLVM::ZExtOp>(loc, intTy, finalVal);
                        } else if (readWidth > width) {
                            finalVal = builder.create<LLVM::TruncOp>(loc, intTy, finalVal);
                        }
                    } else if (isa<LLVM::LLVMPointerType>(finalVal.getType())) {
                        finalVal = builder.create<LLVM::PtrToIntOp>(loc, intTy, finalVal);
                    }

                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        finalVal,
                        builder.getStringAttr(*destRegName),
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                } else {
                    // Destination is a memory address (e.g., MOV [rcx+0x14], eax).
                    // Emit as MemWriteOp — this is a side-effecting store that
                    // must be preserved (not a dead register write).
                    Value finalVal = srcValue;
                    unsigned writeWidth = inferStoreValueWidth(srcValue, regs);
                    if (semInfo.has_memory_dst && semInfo.src_width != 0)
                        writeWidth = std::min(writeWidth, semInfo.src_width);
                    auto writeTy = builder.getIntegerType(writeWidth);

                    if (isa<LLVM::LLVMPointerType>(finalVal.getType())) {
                        finalVal = builder.create<LLVM::PtrToIntOp>(
                            loc, writeTy, finalVal);
                    } else if (auto intTy = dyn_cast<IntegerType>(finalVal.getType())) {
                        if (intTy.getWidth() > writeWidth) {
                            finalVal = builder.create<LLVM::TruncOp>(
                                loc, writeTy, finalVal);
                        } else if (intTy.getWidth() < writeWidth) {
                            finalVal = builder.create<LLVM::ZExtOp>(
                                loc, writeTy, finalVal);
                        }
                    }

                    builder.create<helix::low::MemWriteOp>(
                        loc,
                        ensureInt64(destRegPtr, builder, loc, &regs, &pcTracker),
                        finalVal,
                        builder.getUI32IntegerAttr(writeWidth),
                        addrAttr);
                }
            }
            break;
        }

        case RemillSemantic::MOVZX: {
            if (call.getNumOperands() >= 3) {
                Value operand = call.getOperand(2);
                if (isa<LLVM::LLVMPointerType>(operand.getType())) {
                    operand = builder.create<LLVM::PtrToIntOp>(
                        loc, builder.getI64Type(), operand);
                }
                builder.create<helix::low::MovZxOp>(
                    loc,
                    i64Ty,
                    operand,
                    builder.getUI32IntegerAttr(64),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::MOVSX:
        case RemillSemantic::CDQE:
        case RemillSemantic::CDQ: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::MovSxOp>(
                    loc,
                    i64Ty,
                    ensureInt64(call.getOperand(2), builder, loc, &regs, &pcTracker),
                    builder.getUI32IntegerAttr(64),
                    addrAttr);
            }
            break;
        }

        // ─── Stack Operations ────────────────────────────────────────────
        case RemillSemantic::PUSH: {
            if (call.getNumOperands() >= 3) {
                auto pushOp = builder.create<helix::low::PushOp>(
                    loc,
                    call.getOperand(2),  // value to push
                    addrAttr);

                // ─── Mark callee-saved register pushes ──────────────────
                // Trace the pushed value back to a RegReadOp to determine
                // which register is being saved. If it's a Win64 callee-saved
                // register, mark the operation for later removal by DCE.
                Value pushed = call.getOperand(2);
                if (auto readOp = pushed.getDefiningOp<helix::low::RegReadOp>()) {
                    auto regName = readOp.getRegName();
                    if (isCalleeSavedRegister(regName)) {
                        pushOp->setAttr("is_callee_save_push",
                                        builder.getUnitAttr());
                        pushOp->setAttr("callee_save_reg",
                                        builder.getStringAttr(regName));
                    }
                } else {
                    // Also check if the operand is a GEP-tracked register
                    auto regName = regs.getRegName(pushed);
                    if (regName && isCalleeSavedRegister(*regName)) {
                        pushOp->setAttr("is_callee_save_push",
                                        builder.getUnitAttr());
                        pushOp->setAttr("callee_save_reg",
                                        builder.getStringAttr(*regName));
                    }
                }
            }
            break;
        }

        case RemillSemantic::POP: {
            auto popOp = builder.create<helix::low::PopOp>(
                loc,
                i64Ty,
                addrAttr);

            // ─── Mark callee-saved register pops ────────────────────────
            // The POP result is typically consumed by a RegWriteOp that
            // restores a callee-saved register. We check the destination
            // register from the Remill call operands (dest_reg_ptr at index 2).
            if (call.getNumOperands() >= 3) {
                auto destRegPtr = call.getOperand(2);
                auto regName = regs.getRegName(destRegPtr);
                if (regName && isCalleeSavedRegister(*regName)) {
                    popOp->setAttr("is_callee_save_pop",
                                   builder.getUnitAttr());
                    popOp->setAttr("callee_save_reg",
                                   builder.getStringAttr(*regName));
                }
            }
            break;
        }

        // ─── Control Flow ────────────────────────────────────────────────
        case RemillSemantic::CALL: {
            if (call.getNumOperands() >= 3) {
                auto targetVal = call.getOperand(2);
                StringAttr targetName;

                // Try to extract a constant target address from the operand.
                uint64_t targetAddr = 0;
                bool addrResolved = false;

                if (auto evaluated = pcTracker.tryEvaluate(targetVal, regs)) {
                    targetAddr = static_cast<uint64_t>(*evaluated);
                    addrResolved = true;
                }

                // Remill direct calls also carry NEXT_PC as operand 4:
                //   CALLI(..., target_addr, NEXT_PC_ptr, next_pc, RETURN_PC_ptr)
                // If the full target expression did not fold cleanly, recover
                // the common rel32 shape from `next_pc +/- imm32`.
                auto tryResolveRelativeTargetFromNextPc =
                    [&](Value nextPcVal) -> std::optional<uint64_t> {
                    auto nextPc = pcTracker.tryEvaluate(nextPcVal, regs);
                    if (!nextPc)
                        return std::nullopt;

                    if (auto add = targetVal.getDefiningOp<LLVM::AddOp>()) {
                        if (add.getLhs() == nextPcVal) {
                            if (auto disp =
                                    pcTracker.tryEvaluate(add.getRhs(), regs)) {
                                return static_cast<uint64_t>(*nextPc + *disp);
                            }
                        }
                        if (add.getRhs() == nextPcVal) {
                            if (auto disp =
                                    pcTracker.tryEvaluate(add.getLhs(), regs)) {
                                return static_cast<uint64_t>(*nextPc + *disp);
                            }
                        }
                    }

                    if (auto sub = targetVal.getDefiningOp<LLVM::SubOp>()) {
                        if (sub.getLhs() == nextPcVal) {
                            if (auto disp =
                                    pcTracker.tryEvaluate(sub.getRhs(), regs)) {
                                return static_cast<uint64_t>(*nextPc - *disp);
                            }
                        }
                    }

                    return std::nullopt;
                };

                if (!addrResolved && call.getNumOperands() >= 5) {
                    if (auto relTarget =
                            tryResolveRelativeTargetFromNextPc(call.getOperand(4))) {
                        targetAddr = *relTarget;
                        addrResolved = true;
                    }
                }

                // Final fallback for direct rel32 calls: use the current call
                // site address plus the 5-byte CALL length when the target is
                // still shaped as `next_pc +/- displacement`.
                if (!addrResolved && addrAttr) {
                    auto inferDisp = [&](Value value) -> std::optional<int64_t> {
                        if (auto add = value.getDefiningOp<LLVM::AddOp>()) {
                            if (auto rhs = pcTracker.tryEvaluate(add.getRhs(), regs))
                                return rhs;
                            if (auto lhs = pcTracker.tryEvaluate(add.getLhs(), regs))
                                return lhs;
                        }
                        if (auto sub = value.getDefiningOp<LLVM::SubOp>()) {
                            if (auto rhs = pcTracker.tryEvaluate(sub.getRhs(), regs))
                                return -*rhs;
                        }
                        return std::nullopt;
                    };

                    if (auto disp = inferDisp(targetVal)) {
                        auto nextPcGuess =
                            static_cast<int64_t>(addrAttr.getValue().getZExtValue()) + 5;
                        // Bias toward true rel32 displacements, not tiny
                        // arithmetic noise that belongs to indirect calls.
                        if (std::llabs(*disp) >= 0x100) {
                            targetAddr = static_cast<uint64_t>(nextPcGuess + *disp);
                            addrResolved = true;
                        }
                    }
                }

                // If we resolved an address, format as sub_<hex>.
                if (addrResolved) {
                    auto name = std::format("sub_{:x}", targetAddr);
                    targetName = builder.getStringAttr(name);
                } else {
                    // Unresolvable address — emit info diagnostic.
                    call->emitRemark("unresolved call target address");
                }

                // Recover Win64 register arguments across the current block
                // boundary when the call setup is split by short branches.
                auto callArgs = collectWin64CallArgs(call.getOperation());

                builder.create<helix::low::CallOp>(
                    loc,
                    targetVal,
                    callArgs,
                    targetName,
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::RET: {
            deferredTerminator = [loc](OpBuilder& b, IntegerAttr addr) {
                b.create<helix::low::RetOp>(loc, addr);
            };
            break;
        }

        case RemillSemantic::JMP: {
            // Remill JMP semantic:
            //   call @JMP(mem, state, target_addr, NEXT_PC_ptr)
            // Operands: [0]=mem, [1]=state, [2]=target, [3]=next_pc_ptr
            if (call.getNumOperands() >= 3) {
                deferredTerminator = [loc, dummyBlock](OpBuilder& b, IntegerAttr addr) {
                    b.create<helix::low::JmpOp>(
                        loc,
                        /*target_addr=*/IntegerAttr{},
                        /*address=*/addr,
                        /*dest=*/dummyBlock);
                };
            }
            break;
        }

        // ─── Conditional Jumps ───────────────────────────────────────────
        case RemillSemantic::JZ:
        case RemillSemantic::JNZ:
        case RemillSemantic::JB:
        case RemillSemantic::JNB:
        case RemillSemantic::JBE:
        case RemillSemantic::JNBE:
        case RemillSemantic::JL:
        case RemillSemantic::JNL:
        case RemillSemantic::JLE:
        case RemillSemantic::JNLE:
        case RemillSemantic::JS:
        case RemillSemantic::JNS:
        case RemillSemantic::JO:
        case RemillSemantic::JNO:
        case RemillSemantic::JP:
        case RemillSemantic::JNP: {
            auto condStr = getJccCondition(semantic);
            if (!condStr || call.getNumOperands() < 5)
                break;

            // ── Synthesize real condition from preceding CMP/TEST flags ──
            //
            // Scan backwards in the current block to find the most recent
            // RegWriteOp to the flag register(s) needed by this Jcc.
            // These writes were emitted by the CMP/TEST handler above.
            //
            // Flag requirements:
            //   JZ/JNZ    → ZF
            //   JB/JNB    → CF
            //   JS/JNS    → SF
            //   JO/JNO    → OF
            //   JL/JNL    → SF, OF (SF != OF)
            //   JLE/JNLE  → ZF, SF, OF (ZF || SF != OF)
            //   JBE/JNBE  → CF, ZF (CF || ZF)
            //   JP/JNP    → PF (not tracked, use fallback)

            auto findFlagValue = [&](llvm::StringRef flagName) -> Value {
                // Walk backwards from current insertion point
                Block* block = builder.getInsertionBlock();
                if (!block) return nullptr;
                
                // Search backwards from the current position
                for (auto it = Block::reverse_iterator(builder.getInsertionPoint());
                     it != block->rend(); ++it) {
                    if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(*it)) {
                        if (regWrite.getRegName() == flagName) {
                            return regWrite.getValue();
                        }
                    }
                }
                return nullptr;
            };

            Value condValue = nullptr;

            switch (semantic) {
            case RemillSemantic::JZ: {
                condValue = findFlagValue("ZF");
                break;
            }
            case RemillSemantic::JNZ: {
                Value zf = findFlagValue("ZF");
                if (zf) {
                    // JNZ = !ZF → XOR ZF, 1
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    condValue = builder.create<arith::XOrIOp>(
                        loc, zf, one).getResult();
                }
                break;
            }
            case RemillSemantic::JB: {
                condValue = findFlagValue("CF");
                break;
            }
            case RemillSemantic::JNB: {
                Value cf = findFlagValue("CF");
                if (cf) {
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    condValue = builder.create<arith::XOrIOp>(
                        loc, cf, one).getResult();
                }
                break;
            }
            case RemillSemantic::JS: {
                condValue = findFlagValue("SF");
                break;
            }
            case RemillSemantic::JNS: {
                Value sf = findFlagValue("SF");
                if (sf) {
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    condValue = builder.create<arith::XOrIOp>(
                        loc, sf, one).getResult();
                }
                break;
            }
            case RemillSemantic::JO: {
                condValue = findFlagValue("OF");
                break;
            }
            case RemillSemantic::JNO: {
                Value of = findFlagValue("OF");
                if (of) {
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    condValue = builder.create<arith::XOrIOp>(
                        loc, of, one).getResult();
                }
                break;
            }
            case RemillSemantic::JL: {
                // JL: SF != OF
                Value sf = findFlagValue("SF");
                Value of = findFlagValue("OF");
                if (sf && of) {
                    condValue = builder.create<arith::XOrIOp>(
                        loc, sf, of).getResult();
                }
                break;
            }
            case RemillSemantic::JNL: {
                // JNL (JGE): SF == OF → !(SF XOR OF)
                Value sf = findFlagValue("SF");
                Value of = findFlagValue("OF");
                if (sf && of) {
                    auto xorVal = builder.create<arith::XOrIOp>(loc, sf, of);
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    condValue = builder.create<arith::XOrIOp>(
                        loc, xorVal, one).getResult();
                }
                break;
            }
            case RemillSemantic::JLE: {
                // JLE: ZF || (SF != OF)
                Value zf = findFlagValue("ZF");
                Value sf = findFlagValue("SF");
                Value of = findFlagValue("OF");
                if (zf && sf && of) {
                    auto sfNeOf = builder.create<arith::XOrIOp>(loc, sf, of);
                    condValue = builder.create<arith::OrIOp>(
                        loc, zf, sfNeOf).getResult();
                }
                break;
            }
            case RemillSemantic::JNLE: {
                // JNLE (JG): !ZF && (SF == OF)
                Value zf = findFlagValue("ZF");
                Value sf = findFlagValue("SF");
                Value of = findFlagValue("OF");
                if (zf && sf && of) {
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    auto notZf = builder.create<arith::XOrIOp>(loc, zf, one);
                    auto sfEqOf = builder.create<arith::XOrIOp>(loc, sf, of);
                    auto notSfNeOf = builder.create<arith::XOrIOp>(loc, sfEqOf, one);
                    condValue = builder.create<arith::AndIOp>(
                        loc, notZf, notSfNeOf).getResult();
                }
                break;
            }
            case RemillSemantic::JBE: {
                // JBE: CF || ZF
                Value cf = findFlagValue("CF");
                Value zf = findFlagValue("ZF");
                if (cf && zf) {
                    condValue = builder.create<arith::OrIOp>(
                        loc, cf, zf).getResult();
                }
                break;
            }
            case RemillSemantic::JNBE: {
                // JNBE (JA): !CF && !ZF
                Value cf = findFlagValue("CF");
                Value zf = findFlagValue("ZF");
                if (cf && zf) {
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    auto notCf = builder.create<arith::XOrIOp>(loc, cf, one);
                    auto notZf = builder.create<arith::XOrIOp>(loc, zf, one);
                    condValue = builder.create<arith::AndIOp>(
                        loc, notCf, notZf).getResult();
                }
                break;
            }
            default:
                break;
            }

            // Fallback: use constant true if flag not found
            if (!condValue) {
                llvm::errs() << "[Helix] WARNING: Flag synthesis failed for "
                             << *condStr << " — no flag values found in block. "
                             << "Block has " << std::distance(builder.getInsertionBlock()->begin(),
                                                               builder.getInsertionBlock()->end())
                             << " ops\n";
                condValue = builder.create<LLVM::ConstantOp>(
                    loc, i1Ty, builder.getBoolAttr(true)).getResult();
            } else {
                llvm::errs() << "[Helix] OK: Synthesized condition for " << *condStr << "\n";
            }

            // Resolve branch destinations from the LLVM br terminator.
            // The block's terminator is `br i1 true, label %taken, label %fallthrough`
            // which has the correct successor blocks even though the condition is wrong.
            Block* trueBlock = dummyBlock;
            Block* falseBlock = dummyBlock;
            Block* currentBlock = call->getBlock();
            if (currentBlock) {
                auto* term = currentBlock->getTerminator();
                if (term && term->getNumSuccessors() >= 2) {
                    trueBlock = term->getSuccessor(0);
                    falseBlock = term->getSuccessor(1);
                } else if (term && term->getNumSuccessors() == 1) {
                    // If canonicalized to a single-successor branch,
                    // the false block (fallthrough) is the NEXT block in layout order.
                    trueBlock = term->getSuccessor(0);
                    auto* parent = currentBlock->getParent();
                    if (parent) {
                        auto it = currentBlock->getIterator();
                        ++it;
                        if (it != parent->end()) {
                            falseBlock = &*it;
                        }
                    }
                }
            }

            deferredTerminator = [loc, condStr, condValue, trueBlock, falseBlock](
                                     OpBuilder& b, IntegerAttr addr) {
                b.create<helix::low::JccOp>(
                    loc,
                    *condStr,             // condition code string
                    condValue,            // real flag condition (i1)
                    addr,                 // address
                    trueBlock,            // taken destination
                    falseBlock);          // fallthrough destination
            };
            break;
        }

        // ─── Conditional Move ────────────────────────────────────────────
        case RemillSemantic::CMOV: {
            if (call.getNumOperands() >= 4) {
                // CMOV reads a flag and selects between two values.
                // We need the condition from the semantic name (e.g., "E", "NE").
                auto condStr = semInfo.raw_name.substr(4); // strip "CMOV"
                auto i1Val = builder.create<LLVM::ConstantOp>(
                    loc, i1Ty, builder.getBoolAttr(true));

                builder.create<helix::low::CMovOp>(
                    loc,
                    i64Ty,
                    builder.getStringAttr(condStr),
                    i1Val,
                    call.getOperand(2),
                    call.getOperand(3),
                    addrAttr);
            }
            break;
        }

        // ─── Exchange ────────────────────────────────────────────────────
        case RemillSemantic::XCHG: {
            builder.create<helix::low::XchgOp>(
                loc,
                builder.getStringAttr("reg_a"),
                builder.getStringAttr("reg_b"),
                builder.getUI32IntegerAttr(64),
                addrAttr);
            break;
        }

        // ─── Bit Manipulation ────────────────────────────────────────────
        case RemillSemantic::BSF: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Bsf,
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::BSR: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Bsr,
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::BSWAP: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Bswap,
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::NEG: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Neg,
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::NOT: {
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = call.getOperand(2);
                auto val = call.getOperand(3);
                auto unOp = builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Not,
                    ensureInt64(val, builder, loc, &regs, &pcTracker),
                    addrAttr);

                emitRegisterOrMemoryWrite(builder, loc, destRegPtr, val,
                                          unOp.getResult(), regs, addrAttr);
            }
            break;
        }

        case RemillSemantic::INC: {
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = call.getOperand(2);
                auto val = call.getOperand(3);
                auto unOp = builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Inc,
                    ensureInt64(val, builder, loc, &regs, &pcTracker),
                    addrAttr);

                emitRegisterOrMemoryWrite(builder, loc, destRegPtr, val,
                                          unOp.getResult(), regs, addrAttr);
                builder.create<helix::low::RegWriteOp>(
                    loc, unOp.getZeroFlag(), builder.getStringAttr("ZF"),
                    builder.getUI32IntegerAttr(1), addrAttr);
            }
            break;
        }

        case RemillSemantic::DEC: {
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = call.getOperand(2);
                auto val = call.getOperand(3);
                auto unOp = builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Dec,
                    ensureInt64(val, builder, loc, &regs, &pcTracker),
                    addrAttr);

                emitRegisterOrMemoryWrite(builder, loc, destRegPtr, val,
                                          unOp.getResult(), regs, addrAttr);
                builder.create<helix::low::RegWriteOp>(
                    loc, unOp.getZeroFlag(), builder.getStringAttr("ZF"),
                    builder.getUI32IntegerAttr(1), addrAttr);
            }
            break;
        }

        // ─── REP String Operations ───────────────────────────────────────
        case RemillSemantic::REP_MOVS: {
            if (call.getNumOperands() >= 5) {
                builder.create<helix::low::RepMovsOp>(
                    loc,
                    call.getOperand(2),  // dst (RDI)
                    call.getOperand(3),  // src (RSI)
                    call.getOperand(4),  // count (RCX)
                    builder.getUI32IntegerAttr(8),  // byte width
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::REP_STOS: {
            if (call.getNumOperands() >= 5) {
                builder.create<helix::low::RepStosOp>(
                    loc,
                    call.getOperand(2),  // dst (RDI)
                    call.getOperand(3),  // value (AL/AX/EAX)
                    call.getOperand(4),  // count (RCX)
                    builder.getUI32IntegerAttr(8),
                    addrAttr);
            }
            break;
        }

        // ─── LEA (pure address computation) ──────────────────────────────
        case RemillSemantic::LEA: {
            // LEA is a pure address computation, not a memory access.
            // In Remill IR it computes base + index*scale + disp.
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = safeGetOperand(call, 2, builder, loc);
                auto effectiveAddr =
                    ensureInt64(call.getOperand(3), builder, loc, &regs, &pcTracker);
                auto zero = builder.create<LLVM::ConstantOp>(
                    loc, i64Ty, builder.getI64IntegerAttr(0));
                auto signedI64Ty = IntegerType::get(builder.getContext(), 64, IntegerType::Signed);
                builder.create<helix::low::LeaOp>(
                    loc, i64Ty,
                    ensureInt64(call.getOperand(2), builder, loc, &regs, &pcTracker),   // base
                    ensureInt64(call.getOperand(3), builder, loc, &regs, &pcTracker),   // index
                    builder.getUI32IntegerAttr(1),  // scale
                    IntegerAttr::get(signedI64Ty, 0), // displacement
                    addrAttr);

                if (auto destRegName = regs.getRegName(destRegPtr)) {
                    llvm::StringRef canonical =
                        helix::analysis::getCanonicalX86Register(*destRegName);
                    if (canonical.empty())
                        canonical = *destRegName;

                    if (canonical == "RCX") {
                        builder.create<helix::low::RegWriteOp>(
                            loc,
                            effectiveAddr,
                            builder.getStringAttr(canonical),
                            builder.getUI32IntegerAttr(64),
                            addrAttr);
                    }
                }
            }
            break;
        }

        // ─── NOP / INT3 ─────────────────────────────────────────────────
        case RemillSemantic::NOP: {
            builder.create<helix::low::NopOp>(loc, addrAttr);
            break;
        }

        case RemillSemantic::INT3: {
            builder.create<helix::low::Int3Op>(loc, addrAttr);
            break;
        }

        // ─── Bit Test ────────────────────────────────────────────────────
        case RemillSemantic::BT: {
            // BT base, offset — test bit at position `offset` in `base`.
            // Sets CF = bit value. No modification to the base.
            // Remill layout: call @BT(mem, state, base_reg_ptr, base_val, bit_offset)
            if (call.getNumOperands() >= 5) {
                auto baseVal = call.getOperand(3);
                auto bitOffset = call.getOperand(4);
                // Emit as CMP-like: the downstream passes treat CF as the
                // result of the bit test. We use a CMP of the extracted bit
                // against zero to set flags appropriately.
                auto cmpOp = builder.create<helix::low::CmpOp>(
                    loc,
                    /*carry_flag=*/i1Ty,
                    /*zero_flag=*/i1Ty,
                    /*sign_flag=*/i1Ty,
                    /*overflow_flag=*/i1Ty,
                    ensureInt64(baseVal, builder, loc, &regs, &pcTracker),
                    ensureInt64(bitOffset, builder, loc, &regs, &pcTracker),
                    addrAttr);
                // BT only sets CF; write all flags for consistency.
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getCarryFlag(), builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getZeroFlag(), builder.getStringAttr("ZF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getSignFlag(), builder.getStringAttr("SF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getOverflowFlag(), builder.getStringAttr("OF"), builder.getUI32IntegerAttr(1), addrAttr);
            }
            break;
        }

        case RemillSemantic::BTS: {
            // BTS base, offset — test bit and SET it.
            // Remill layout: call @BTS(mem, state, dest_reg_ptr, base_val, bit_offset)
            if (call.getNumOperands() >= 5) {
                auto destRegPtr = call.getOperand(2);
                auto baseVal = call.getOperand(3);
                auto bitOffset = call.getOperand(4);
                // Emit bit test (CF) via CMP
                auto cmpOp = builder.create<helix::low::CmpOp>(
                    loc, i1Ty, i1Ty, i1Ty, i1Ty,
                    ensureInt64(baseVal, builder, loc),
                    ensureInt64(bitOffset, builder, loc),
                    addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getCarryFlag(), builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                // Emit OR to set the bit: result = base | (1 << offset)
                auto binOp = builder.create<helix::low::BinOp>(
                    loc, i64Ty, i1Ty, i1Ty, i1Ty, i1Ty,
                    helix::low::BinOpKind::Or,
                    ensureInt64(baseVal, builder, loc),
                    ensureInt64(bitOffset, builder, loc),
                    addrAttr, UnitAttr{});
                auto regName = regs.getRegName(destRegPtr);
                unsigned width = regName ? RegisterTracker::inferRegWidth(*regName) : 64;
                builder.create<helix::low::RegWriteOp>(
                    loc, binOp.getResult(),
                    builder.getStringAttr(regName ? *regName : "unknown"),
                    builder.getUI32IntegerAttr(width), addrAttr);
            }
            break;
        }

        case RemillSemantic::BTR: {
            // BTR base, offset — test bit and RESET (clear) it.
            // Remill layout: call @BTR(mem, state, dest_reg_ptr, base_val, bit_offset)
            if (call.getNumOperands() >= 5) {
                auto destRegPtr = call.getOperand(2);
                auto baseVal = call.getOperand(3);
                auto bitOffset = call.getOperand(4);
                auto cmpOp = builder.create<helix::low::CmpOp>(
                    loc, i1Ty, i1Ty, i1Ty, i1Ty,
                    ensureInt64(baseVal, builder, loc),
                    ensureInt64(bitOffset, builder, loc),
                    addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getCarryFlag(), builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                // Emit AND to clear the bit: result = base & ~(1 << offset)
                auto binOp = builder.create<helix::low::BinOp>(
                    loc, i64Ty, i1Ty, i1Ty, i1Ty, i1Ty,
                    helix::low::BinOpKind::And,
                    ensureInt64(baseVal, builder, loc),
                    ensureInt64(bitOffset, builder, loc),
                    addrAttr, UnitAttr{});
                auto regName = regs.getRegName(destRegPtr);
                unsigned width = regName ? RegisterTracker::inferRegWidth(*regName) : 64;
                builder.create<helix::low::RegWriteOp>(
                    loc, binOp.getResult(),
                    builder.getStringAttr(regName ? *regName : "unknown"),
                    builder.getUI32IntegerAttr(width), addrAttr);
            }
            break;
        }

        case RemillSemantic::BTC: {
            // BTC base, offset — test bit and COMPLEMENT (toggle) it.
            // Remill layout: call @BTC(mem, state, dest_reg_ptr, base_val, bit_offset)
            if (call.getNumOperands() >= 5) {
                auto destRegPtr = call.getOperand(2);
                auto baseVal = call.getOperand(3);
                auto bitOffset = call.getOperand(4);
                auto cmpOp = builder.create<helix::low::CmpOp>(
                    loc, i1Ty, i1Ty, i1Ty, i1Ty,
                    ensureInt64(baseVal, builder, loc),
                    ensureInt64(bitOffset, builder, loc),
                    addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getCarryFlag(), builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                // Emit XOR to toggle the bit: result = base ^ (1 << offset)
                auto binOp = builder.create<helix::low::BinOp>(
                    loc, i64Ty, i1Ty, i1Ty, i1Ty, i1Ty,
                    helix::low::BinOpKind::Xor,
                    ensureInt64(baseVal, builder, loc),
                    ensureInt64(bitOffset, builder, loc),
                    addrAttr, UnitAttr{});
                auto regName = regs.getRegName(destRegPtr);
                unsigned width = regName ? RegisterTracker::inferRegWidth(*regName) : 64;
                builder.create<helix::low::RegWriteOp>(
                    loc, binOp.getResult(),
                    builder.getStringAttr(regName ? *regName : "unknown"),
                    builder.getUI32IntegerAttr(width), addrAttr);
            }
            break;
        }

        // ─── SSE/AVX packed operations ───────────────────────────────────
        // These operate on XMM registers (128-bit vectors). We emit them as
        // inline asm comments so the user can see what was there, then erase.
        case RemillSemantic::MOVxPS:
        case RemillSemantic::MOVSS_MEM:
        case RemillSemantic::MOVSS:
        case RemillSemantic::MOVSD:
        case RemillSemantic::MOVAPS:
        case RemillSemantic::MOVUPS:
        case RemillSemantic::SHUFPS:
        case RemillSemantic::SUBPS:
        case RemillSemantic::ADDPS:
        case RemillSemantic::MULPS:
        case RemillSemantic::ADDSS:
        case RemillSemantic::ADDSD:
        case RemillSemantic::MULSS:
        case RemillSemantic::MULSD:
        case RemillSemantic::SUBSS:
        case RemillSemantic::SUBSD:
        case RemillSemantic::DIVSS:
        case RemillSemantic::DIVSD:
        case RemillSemantic::XORPS:
        case RemillSemantic::XORPD:
        case RemillSemantic::PXOR:
        case RemillSemantic::COMISS:
        case RemillSemantic::UNPCKHPS: {
            // Emitting RegWriteOp for the operands keeps them alive for DCE
            // and allows the user to see the memory offsets in the AST.
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = call.getOperand(2);
                auto regName = regs.getRegName(destRegPtr);
                unsigned width = regName ? RegisterTracker::inferRegWidth(*regName) : 128;
                if (!regName) regName = "XMM0"; 
                
                // Prioritize finding an integer operand (usually the memory offset).
                // If not found, fall back to the first source operand.
                Value val = call.getOperand(3);
                for (unsigned idx = 3; idx < call.getNumOperands(); ++idx) {
                    if (call.getOperand(idx).getType().isInteger(64)) {
                        val = call.getOperand(idx);
                        break;
                    }
                }
                
                builder.create<helix::low::RegWriteOp>(
                    loc,
                    ensureInt64(val, builder, loc),
                    builder.getStringAttr(*regName),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
            }
            break;
        }

        // ─── PREFETCH ──────────────────────────────────────────────────────
        // Hint instruction with no semantic effect — just erase.
        case RemillSemantic::PREFETCH: {
            builder.create<helix::low::NopOp>(loc, addrAttr);
            break;
        }

        // ─── HandleUnsupported ─────────────────────────────────────────────
        // Remill catch-all for unlifted instructions — erase.
        case RemillSemantic::HANDLE_UNSUPPORTED: {
            builder.create<helix::low::NopOp>(loc, addrAttr);
            break;
        }

        // ─── CMPXCHG ──────────────────────────────────────────────────────
        case RemillSemantic::CMPXCHG: {
            if (call.getNumOperands() >= 3) {
                auto zero = builder.create<LLVM::ConstantOp>(
                    loc, i64Ty, builder.getI64IntegerAttr(0));
                builder.create<helix::low::CallOp>(
                    loc, zero,
                    mlir::ValueRange{},
                    builder.getStringAttr("cmpxchg"),
                    addrAttr);
            }
            break;
        }

        // ─── SETcc ────────────────────────────────────────────────────────
        case RemillSemantic::SETcc: {
            // SETcc sets a byte register based on flags.
            // Emit as a generic call with the conditional name.
            if (call.getNumOperands() >= 3) {
                auto destRegPtr = call.getOperand(2);
                auto regName = regs.getRegName(destRegPtr);
                unsigned width = regName ? RegisterTracker::inferRegWidth(*regName) : 8;
                auto zero = builder.create<LLVM::ConstantOp>(
                    loc, i64Ty, builder.getI64IntegerAttr(0));
                builder.create<helix::low::RegWriteOp>(
                    loc, zero,
                    builder.getStringAttr(regName ? *regName : "unknown"),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
            }
            break;
        }

        // ─── CDQ_EAX / CDQE_EAX ──────────────────────────────────────────
        case RemillSemantic::CDQ_EAX:
        case RemillSemantic::CDQE_EAX: {
            // Sign-extension instructions. Treat like CDQ/CDQE.
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::MovSxOp>(
                    loc,
                    i64Ty,
                    ensureInt64(call.getOperand(2), builder, loc),
                    builder.getUI32IntegerAttr(64),
                    addrAttr);
            }
            break;
        }

        // ─── Unhandled / Future ──────────────────────────────────────────
        default:
            // Emit a warning for unhandled semantics so the user knows
            // something was skipped. Preserve the call as a generic call op.
            call->emitWarning("unhandled Remill semantic: ")
                << semInfo.raw_name;
            {
                auto zero = builder.create<LLVM::ConstantOp>(
                    loc, i64Ty, builder.getI64IntegerAttr(0));
                builder.create<helix::low::CallOp>(
                    loc,
                    zero,
                    mlir::ValueRange{},
                    builder.getStringAttr(semInfo.raw_name),
                    addrAttr);
            }
            break;
        }
    }

    /// Check if a register name is a Win64 callee-saved (non-volatile) register.
    /// Win64 ABI: RBX, RBP, RDI, RSI, R12, R13, R14, R15
    static bool isCalleeSavedRegister(llvm::StringRef regName) {
        static constexpr std::string_view kCalleeSaved[] = {
            "RBX", "RBP", "RDI", "RSI", "R12", "R13", "R14", "R15"
        };
        for (auto cs : kCalleeSaved) {
            if (regName == llvm::StringRef(cs.data(), cs.size()))
                return true;
        }
        return false;
    }

    /// Map a RemillSemantic to HelixLow BinOpKind.
    static std::optional<helix::low::BinOpKind>
    semanticToBinOpKind(RemillSemantic sem) {
        switch (sem) {
        case RemillSemantic::ADD:  return helix::low::BinOpKind::Add;
        case RemillSemantic::SUB:  return helix::low::BinOpKind::Sub;
        case RemillSemantic::MUL:  return helix::low::BinOpKind::Mul;
        case RemillSemantic::IMUL: return helix::low::BinOpKind::IMul;
        case RemillSemantic::DIV:  return helix::low::BinOpKind::Div;
        case RemillSemantic::IDIV: return helix::low::BinOpKind::IDiv;
        case RemillSemantic::AND:  return helix::low::BinOpKind::And;
        case RemillSemantic::OR:   return helix::low::BinOpKind::Or;
        case RemillSemantic::XOR:  return helix::low::BinOpKind::Xor;
        case RemillSemantic::SHL:  return helix::low::BinOpKind::Shl;
        case RemillSemantic::SHR:  return helix::low::BinOpKind::Shr;
        case RemillSemantic::SAR:  return helix::low::BinOpKind::Sar;
        case RemillSemantic::ROL:  return helix::low::BinOpKind::Rol;
        case RemillSemantic::ROR:  return helix::low::BinOpKind::Ror;
        default: return std::nullopt;
        }
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Factory
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createRemillToHelixLowPass() {
    return std::make_unique<RemillToHelixLowPass>();
}
