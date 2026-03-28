/// @file PropagateTypes.cpp
/// @brief Type propagation pass: iteratively infer C types from usage patterns.
///
/// Implements a two-phase fixed-point iteration (max 16 rounds each) that
/// refines Unknown types to concrete C types.
///
/// Phase 1 — Forward (def→use): propagates types from definitions to uses:
///   - Access widths (8-bit → int8_t, 32-bit → int32_t, etc.)
///   - API function signatures (known return types and parameter types)
///   - Binary operation semantics (comparison → bool, shift → same type)
///   - Pointer arithmetic patterns (base + offset → pointer)
///   - Sign extension/zero extension (movsx → signed, movzx → unsigned)
///
/// Phase 2 — Backward (use→def): infers types from how values are USED back
/// to their definitions:
///   - CMP/TEST backward: if one comparison operand is typed, the other matches
///   - MOVSX backward: sign-extended source must be signed int at source width
///   - MOVZX backward: zero-extended source must be unsigned int at source width
///   - Store backward: stored value type matches the store target type
///   - Call argument backward: argument types match known parameter types
///   - Return backward: returned value type matches function return type

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/analysis/SignatureDb.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringMap.h"

#include <format>
#include <string>

using namespace mlir;
using namespace helix;

namespace {

/// Represents a resolved C type for a value.
struct CTypeInfo {
    enum Kind {
        Unknown, Void, Bool, Int, UInt, Float, Pointer, Array, Struct
    };

    Kind kind = Unknown;
    unsigned bit_width = 0;
    bool is_signed = false;
    std::string struct_name;

    bool isResolved() const { return kind != Unknown; }

    /// Merge another type into this one. Returns true if the type changed.
    bool mergeFrom(const CTypeInfo& other) {
        if (other.kind == Unknown)
            return false;
        if (kind == Unknown) {
            *this = other;
            return true;
        }
        // If both are resolved, prefer the more specific one
        if (kind == Int && other.kind == UInt && bit_width == other.bit_width) {
            // Keep signed as more specific
            return false;
        }
        if (kind == UInt && other.kind == Int && bit_width == other.bit_width) {
            kind = Int;
            is_signed = true;
            return true;
        }
        return false;
    }

    static CTypeInfo makeInt(unsigned bits, bool isSigned = false) {
        CTypeInfo t;
        t.kind = isSigned ? Int : UInt;
        t.bit_width = bits;
        t.is_signed = isSigned;
        return t;
    }

    static CTypeInfo makeBool() {
        CTypeInfo t;
        t.kind = Bool;
        t.bit_width = 1;
        return t;
    }

    static CTypeInfo makePointer() {
        CTypeInfo t;
        t.kind = Pointer;
        t.bit_width = 64;
        return t;
    }

    static CTypeInfo makeVoid() {
        CTypeInfo t;
        t.kind = Void;
        t.bit_width = 0;
        return t;
    }
};

struct PropagateTypesPass
    : public PassWrapper<PropagateTypesPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(PropagateTypesPass)

    StringRef getArgument() const final { return "propagate-types"; }
    StringRef getDescription() const final {
        return "Iteratively propagate and infer C types from usage patterns";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<helix::high::HelixHighDialect>();
    }

    /// Convert a SignatureDb return type string to a CTypeInfo.
    static CTypeInfo typeFromSignatureStr(llvm::StringRef typeStr) {
        if (typeStr == "void")
            return CTypeInfo::makeVoid();
        if (typeStr == "ptr" || typeStr == "void*")
            return CTypeInfo::makePointer();
        if (typeStr == "int8")
            return CTypeInfo::makeInt(8, /*signed=*/true);
        if (typeStr == "uint8")
            return CTypeInfo::makeInt(8, /*signed=*/false);
        if (typeStr == "int16")
            return CTypeInfo::makeInt(16, /*signed=*/true);
        if (typeStr == "uint16")
            return CTypeInfo::makeInt(16, /*signed=*/false);
        if (typeStr == "int32")
            return CTypeInfo::makeInt(32, /*signed=*/true);
        if (typeStr == "uint32")
            return CTypeInfo::makeInt(32, /*signed=*/false);
        if (typeStr == "int64")
            return CTypeInfo::makeInt(64, /*signed=*/true);
        if (typeStr == "uint64")
            return CTypeInfo::makeInt(64, /*signed=*/false);
        if (typeStr == "bool")
            return CTypeInfo::makeBool();
        // Default: unknown
        return CTypeInfo{};
    }

    void runOnOperation() override {
        auto module = getOperation();
        module.walk([&](helix::low::FuncOp func) {
            propagateTypesLow(func);
        });

        // Propagate types in HelixHigh functions.
        module.walk([&](helix::high::FuncOp func) {
            propagateTypesHigh(func);
        });
    }

private:
    static constexpr unsigned kMaxIterations = 16;

    /// Map from var_id to its inferred type (shared across iterations).
    using VarTypeMap = llvm::DenseMap<uint32_t, CTypeInfo>;

    void propagateTypesLow(helix::low::FuncOp func) {
        // TypeEnv: maps SSA Values to their inferred C type.
        llvm::DenseMap<Value, CTypeInfo> typeEnv;

        // Iterate until fixed point.
        for (unsigned iter = 0; iter < kMaxIterations; iter++) {
            bool changed = false;

            func.walk([&](Operation* op) {
                // Rule 1: Register reads — infer type from bit width.
                if (auto regRead = dyn_cast<helix::low::RegReadOp>(op)) {
                    unsigned width = regRead.getBitWidth();
                    auto result = regRead.getResult();
                    CTypeInfo inferred = CTypeInfo::makeInt(width);
                    if (typeEnv[result].mergeFrom(inferred))
                        changed = true;
                    return;
                }

                // Rule 2: Memory reads — infer type from bit width.
                if (auto memRead = dyn_cast<helix::low::MemReadOp>(op)) {
                    unsigned width = memRead.getBitWidth();
                    auto result = memRead.getResult();
                    CTypeInfo inferred = CTypeInfo::makeInt(width);
                    if (typeEnv[result].mergeFrom(inferred))
                        changed = true;
                    return;
                }

                // Rule 3: Binary ops — result type from operand types.
                // Pointer arithmetic: pointer + integer → pointer.
                if (auto binop = dyn_cast<helix::low::BinOp>(op)) {
                    auto result = binop.getResult();
                    auto lhsType = typeEnv[binop.getLhs()];
                    auto rhsType = typeEnv[binop.getRhs()];

                    CTypeInfo inferred;
                    // Pointer propagation: if either operand is a pointer,
                    // the result of ADD/SUB is also a pointer.
                    if (lhsType.kind == CTypeInfo::Pointer ||
                        rhsType.kind == CTypeInfo::Pointer) {
                        inferred = CTypeInfo::makePointer();
                    } else if (lhsType.isResolved()) {
                        inferred = lhsType;
                    } else if (rhsType.isResolved()) {
                        inferred = rhsType;
                    }

                    if (inferred.isResolved()) {
                        if (typeEnv[result].mergeFrom(inferred))
                            changed = true;
                    }

                    // Flags are always bool
                    CTypeInfo boolType = CTypeInfo::makeBool();
                    if (typeEnv[binop.getCarryFlag()].mergeFrom(boolType))
                        changed = true;
                    if (typeEnv[binop.getZeroFlag()].mergeFrom(boolType))
                        changed = true;
                    if (typeEnv[binop.getSignFlag()].mergeFrom(boolType))
                        changed = true;
                    if (typeEnv[binop.getOverflowFlag()].mergeFrom(boolType))
                        changed = true;
                    return;
                }

                // Rule 4: CMP/TEST — output flags are bool.
                if (auto cmp = dyn_cast<helix::low::CmpOp>(op)) {
                    CTypeInfo boolType = CTypeInfo::makeBool();
                    if (typeEnv[cmp.getCarryFlag()].mergeFrom(boolType))
                        changed = true;
                    if (typeEnv[cmp.getZeroFlag()].mergeFrom(boolType))
                        changed = true;
                    if (typeEnv[cmp.getSignFlag()].mergeFrom(boolType))
                        changed = true;
                    if (typeEnv[cmp.getOverflowFlag()].mergeFrom(boolType))
                        changed = true;
                    return;
                }

                if (auto test = dyn_cast<helix::low::TestOp>(op)) {
                    CTypeInfo boolType = CTypeInfo::makeBool();
                    if (typeEnv[test.getZeroFlag()].mergeFrom(boolType))
                        changed = true;
                    if (typeEnv[test.getSignFlag()].mergeFrom(boolType))
                        changed = true;
                    return;
                }

                // Rule 5: MOVZX → destination unsigned, source unsigned.
                if (auto movzx = dyn_cast<helix::low::MovZxOp>(op)) {
                    unsigned dstWidth = movzx.getDstWidth();
                    unsigned srcWidth = movzx.getSrc().getType().getIntOrFloatBitWidth();
                    // Destination is unsigned at destination width
                    CTypeInfo dstInferred = CTypeInfo::makeInt(dstWidth, /*signed=*/false);
                    if (typeEnv[movzx.getResult()].mergeFrom(dstInferred))
                        changed = true;
                    // Source operand is unsigned at source width
                    CTypeInfo srcInferred = CTypeInfo::makeInt(srcWidth, /*signed=*/false);
                    if (typeEnv[movzx.getSrc()].mergeFrom(srcInferred))
                        changed = true;
                    return;
                }

                // Rule 6: MOVSX → destination signed, source signed.
                if (auto movsx = dyn_cast<helix::low::MovSxOp>(op)) {
                    unsigned dstWidth = movsx.getDstWidth();
                    unsigned srcWidth = movsx.getSrc().getType().getIntOrFloatBitWidth();
                    // Destination is signed at destination width
                    CTypeInfo dstInferred = CTypeInfo::makeInt(dstWidth, /*signed=*/true);
                    if (typeEnv[movsx.getResult()].mergeFrom(dstInferred))
                        changed = true;
                    // Source operand is signed at source width
                    CTypeInfo srcInferred = CTypeInfo::makeInt(srcWidth, /*signed=*/true);
                    if (typeEnv[movsx.getSrc()].mergeFrom(srcInferred))
                        changed = true;
                    return;
                }

                // Rule 7: LEA → pointer (address computation).
                if (auto lea = dyn_cast<helix::low::LeaOp>(op)) {
                    CTypeInfo inferred = CTypeInfo::makePointer();
                    if (typeEnv[lea.getResult()].mergeFrom(inferred))
                        changed = true;
                    return;
                }

                // Rule 8: POP → int64 (stack width).
                if (auto pop = dyn_cast<helix::low::PopOp>(op)) {
                    CTypeInfo inferred = CTypeInfo::makeInt(64);
                    if (typeEnv[pop.getResult()].mergeFrom(inferred))
                        changed = true;
                    return;
                }

                // Rule 9: Unary ops — result type same as operand.
                if (auto unary = dyn_cast<helix::low::UnaryOp>(op)) {
                    auto operandType = typeEnv[unary.getOperand()];
                    if (operandType.isResolved()) {
                        if (typeEnv[unary.getResult()].mergeFrom(operandType))
                            changed = true;
                    }
                    CTypeInfo boolType = CTypeInfo::makeBool();
                    if (typeEnv[unary.getZeroFlag()].mergeFrom(boolType))
                        changed = true;
                    if (typeEnv[unary.getSignFlag()].mergeFrom(boolType))
                        changed = true;
                    return;
                }

                // Rule 10: CMOV — result type from true/false values.
                if (auto cmov = dyn_cast<helix::low::CMovOp>(op)) {
                    auto trueType = typeEnv[cmov.getTrueVal()];
                    auto falseType = typeEnv[cmov.getFalseVal()];
                    CTypeInfo inferred;
                    if (trueType.isResolved())
                        inferred = trueType;
                    else if (falseType.isResolved())
                        inferred = falseType;
                    if (inferred.isResolved()) {
                        if (typeEnv[cmov.getResult()].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Rule 11: CALL — propagate return type from SignatureDb.
                if (auto call = dyn_cast<helix::low::CallOp>(op)) {
                    if (auto targetName = call.getTargetName()) {
                        auto sig = helix::lookupSignature(*targetName);
                        if (sig) {
                            CTypeInfo retType = typeFromSignatureStr(sig->return_type);
                            if (retType.isResolved()) {
                                // Set the inferred return type on the call op
                                call->setAttr("inferred_return_type",
                                    StringAttr::get(call->getContext(),
                                        sig->return_type));
                            }
                        }
                    }
                    return;
                }
            });

            // Fixed point reached — no more changes.
            if (!changed)
                break;
        }

        // ─── Phase 2: Backward propagation (use→def) ────────────────────────
        //
        // Walk each operation's results and examine their USES to propagate
        // type constraints backward from consumers to producers.
        for (unsigned backIter = 0; backIter < kMaxIterations; backIter++) {
            bool changed = false;

            func.walk([&](Operation* op) {
                // Backward Rule B1: CMP — both operands should have the same
                // type. If one operand's type is known, propagate to the other.
                if (auto cmp = dyn_cast<helix::low::CmpOp>(op)) {
                    auto lhsType = typeEnv[cmp.getLhs()];
                    auto rhsType = typeEnv[cmp.getRhs()];
                    if (lhsType.isResolved() && !rhsType.isResolved()) {
                        if (typeEnv[cmp.getRhs()].mergeFrom(lhsType))
                            changed = true;
                    } else if (rhsType.isResolved() && !lhsType.isResolved()) {
                        if (typeEnv[cmp.getLhs()].mergeFrom(rhsType))
                            changed = true;
                    }
                    return;
                }

                // Backward Rule B2: TEST — both operands should have the same
                // type (bitwise AND for flag setting).
                if (auto test = dyn_cast<helix::low::TestOp>(op)) {
                    auto lhsType = typeEnv[test.getLhs()];
                    auto rhsType = typeEnv[test.getRhs()];
                    if (lhsType.isResolved() && !rhsType.isResolved()) {
                        if (typeEnv[test.getRhs()].mergeFrom(lhsType))
                            changed = true;
                    } else if (rhsType.isResolved() && !lhsType.isResolved()) {
                        if (typeEnv[test.getLhs()].mergeFrom(rhsType))
                            changed = true;
                    }
                    return;
                }

                // Backward Rule B3: MOVSX — if the result of a sign extension
                // is used, the source must be a signed integer at the source
                // bit width (reinforces forward rule, catches cases where the
                // source was previously Unknown).
                if (auto movsx = dyn_cast<helix::low::MovSxOp>(op)) {
                    unsigned srcWidth =
                        movsx.getSrc().getType().getIntOrFloatBitWidth();
                    CTypeInfo srcInferred =
                        CTypeInfo::makeInt(srcWidth, /*signed=*/true);
                    if (typeEnv[movsx.getSrc()].mergeFrom(srcInferred))
                        changed = true;

                    // Also: if the destination type is known and signed, the
                    // source must be signed too.
                    auto dstType = typeEnv[movsx.getResult()];
                    if (dstType.isResolved() && dstType.is_signed) {
                        if (typeEnv[movsx.getSrc()].mergeFrom(
                                CTypeInfo::makeInt(srcWidth, /*signed=*/true)))
                            changed = true;
                    }
                    return;
                }

                // Backward Rule B4: MOVZX — the source must be an unsigned
                // integer at the source bit width.
                if (auto movzx = dyn_cast<helix::low::MovZxOp>(op)) {
                    unsigned srcWidth =
                        movzx.getSrc().getType().getIntOrFloatBitWidth();
                    CTypeInfo srcInferred =
                        CTypeInfo::makeInt(srcWidth, /*signed=*/false);
                    if (typeEnv[movzx.getSrc()].mergeFrom(srcInferred))
                        changed = true;

                    // If the destination type is known and unsigned, reinforce
                    // unsigned on the source.
                    auto dstType = typeEnv[movzx.getResult()];
                    if (dstType.isResolved() && !dstType.is_signed &&
                        (dstType.kind == CTypeInfo::UInt ||
                         dstType.kind == CTypeInfo::Int)) {
                        if (typeEnv[movzx.getSrc()].mergeFrom(
                                CTypeInfo::makeInt(srcWidth, /*signed=*/false)))
                            changed = true;
                    }
                    return;
                }

                // Backward Rule B5: MemWrite (store) — if the value being
                // stored has a known type, propagate it to the address as a
                // pointer. If the stored value's bit width is known from the
                // store's bit_width attribute, infer the value's integer type.
                if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
                    unsigned storeWidth = memWrite.getBitWidth();
                    Value storedValue = memWrite.getValue();
                    auto valueType = typeEnv[storedValue];

                    // The address operand is always a pointer.
                    CTypeInfo ptrType = CTypeInfo::makePointer();
                    if (typeEnv[memWrite.getAddr()].mergeFrom(ptrType))
                        changed = true;

                    // If the stored value has no type, infer from store width.
                    if (!valueType.isResolved()) {
                        CTypeInfo inferred = CTypeInfo::makeInt(storeWidth);
                        if (typeEnv[storedValue].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Backward Rule B6: Call argument — if a value is passed as an
                // argument to a known function, its type should match the
                // parameter type from SignatureDb.
                if (auto call = dyn_cast<helix::low::CallOp>(op)) {
                    if (auto targetName = call.getTargetName()) {
                        auto sig = helix::lookupSignature(*targetName);
                        if (sig) {
                            auto args = call.getArgs();
                            for (unsigned i = 0;
                                 i < args.size() && i < sig->param_types.size();
                                 i++) {
                                CTypeInfo paramType =
                                    typeFromSignatureStr(sig->param_types[i]);
                                if (paramType.isResolved()) {
                                    if (typeEnv[args[i]].mergeFrom(paramType))
                                        changed = true;
                                }
                            }
                        }
                    }
                    return;
                }

                // Backward Rule B7: BinOp — if the result type is known,
                // propagate it back to the operands (for non-pointer cases).
                if (auto binop = dyn_cast<helix::low::BinOp>(op)) {
                    auto resultType = typeEnv[binop.getResult()];
                    if (resultType.isResolved() &&
                        resultType.kind != CTypeInfo::Pointer) {
                        if (typeEnv[binop.getLhs()].mergeFrom(resultType))
                            changed = true;
                        if (typeEnv[binop.getRhs()].mergeFrom(resultType))
                            changed = true;
                    }
                    return;
                }
            });

            // Fixed point reached — no more backward changes.
            if (!changed)
                break;
        }

        // Store the resolved types as attributes on the operations.
        for (auto& [val, typeInfo] : typeEnv) {
            if (!typeInfo.isResolved())
                continue;

            auto* defOp = val.getDefiningOp();
            if (!defOp)
                continue;

            // Encode the type as a string attribute
            std::string typeStr;
            switch (typeInfo.kind) {
            case CTypeInfo::Bool:    typeStr = "bool"; break;
            case CTypeInfo::Int:     typeStr = std::format("int{}_t", typeInfo.bit_width); break;
            case CTypeInfo::UInt:    typeStr = std::format("uint{}_t", typeInfo.bit_width); break;
            case CTypeInfo::Float:   typeStr = std::format("float{}", typeInfo.bit_width); break;
            case CTypeInfo::Pointer: typeStr = "void*"; break;
            case CTypeInfo::Void:    typeStr = "void"; break;
            default: continue;
            }

            defOp->setAttr("inferred_type",
                StringAttr::get(defOp->getContext(), typeStr));
        }
    }

    /// Propagate types through HelixHigh operations (var.decl, assign, call).
    /// This handles the higher-level IR after stack recovery and variable
    /// recovery have introduced typed variable declarations and assignments.
    void propagateTypesHigh(helix::high::FuncOp func) {
        // VarTypes: maps variable IDs to their inferred C type.
        VarTypeMap varTypes;
        // TypeEnv: maps SSA Values to their inferred C type.
        llvm::DenseMap<Value, CTypeInfo> typeEnv;

        // Seed var types from existing inferred_type attributes on var.decl ops.
        func.walk([&](helix::high::VarDeclOp decl) {
            uint32_t varId = decl.getVarId();
            if (auto existingType = decl->getAttrOfType<StringAttr>("inferred_type")) {
                CTypeInfo t = typeFromSignatureStr(existingType.getValue());
                if (t.isResolved())
                    varTypes[varId].mergeFrom(t);
            }
            // If the decl has an initializer, seed from its type.
            if (decl.getInit()) {
                Value initVal = decl.getInit();
                unsigned bitWidth = 0;
                if (auto intTy = dyn_cast<IntegerType>(initVal.getType()))
                    bitWidth = intTy.getWidth();
                if (bitWidth > 0) {
                    CTypeInfo inferred = CTypeInfo::makeInt(bitWidth);
                    varTypes[varId].mergeFrom(inferred);
                }
            }
        });

        // Iterate until fixed point.
        for (unsigned iter = 0; iter < kMaxIterations; iter++) {
            bool changed = false;

            func.walk([&](Operation* op) {
                // Rule H1: var.decl — propagate type from initializer to variable.
                if (auto decl = dyn_cast<helix::high::VarDeclOp>(op)) {
                    uint32_t varId = decl.getVarId();
                    if (decl.getInit()) {
                        Value initVal = decl.getInit();
                        auto initType = typeEnv[initVal];
                        if (initType.isResolved()) {
                            if (varTypes[varId].mergeFrom(initType))
                                changed = true;
                        }
                    }
                    return;
                }

                // Rule H2: assign — bidirectional type propagation.
                // If the value has a known type, the target variable inherits it.
                // If the target variable has a known type, the value inherits it.
                if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
                    Value target = assign.getTarget();
                    Value value = assign.getValue();

                    auto valueType = typeEnv[value];
                    auto targetType = typeEnv[target];

                    // Forward: value type → target
                    if (valueType.isResolved() && !targetType.isResolved()) {
                        if (typeEnv[target].mergeFrom(valueType))
                            changed = true;
                    }
                    // Backward: target type → value
                    if (targetType.isResolved() && !valueType.isResolved()) {
                        if (typeEnv[value].mergeFrom(targetType))
                            changed = true;
                    }

                    // Also propagate to/from the variable type map via var.ref
                    if (auto varRef = target.getDefiningOp<helix::high::VarRefOp>()) {
                        uint32_t varId = varRef.getVarId();
                        if (valueType.isResolved()) {
                            if (varTypes[varId].mergeFrom(valueType))
                                changed = true;
                        }
                        // Backward: variable type → value
                        auto varType = varTypes[varId];
                        if (varType.isResolved()) {
                            if (typeEnv[value].mergeFrom(varType))
                                changed = true;
                        }
                    }
                    return;
                }

                // Rule H3: var.ref — propagate variable type to the ref result.
                if (auto varRef = dyn_cast<helix::high::VarRefOp>(op)) {
                    uint32_t varId = varRef.getVarId();
                    auto varType = varTypes[varId];
                    if (varType.isResolved()) {
                        if (typeEnv[varRef.getResult()].mergeFrom(varType))
                            changed = true;
                    }
                    return;
                }

                // Rule H4: call — propagate return type from SignatureDb.
                if (auto call = dyn_cast<helix::high::CallOp>(op)) {
                    auto targetName = call.getTargetName();
                    auto sig = helix::lookupSignature(targetName);
                    if (sig) {
                        CTypeInfo retType = typeFromSignatureStr(sig->return_type);
                        if (retType.isResolved() && call.getResult()) {
                            if (typeEnv[call.getResult()].mergeFrom(retType))
                                changed = true;
                        }
                        // Propagate parameter types to call arguments.
                        for (unsigned i = 0; i < call.getArgs().size() &&
                                            i < sig->param_types.size(); i++) {
                            CTypeInfo paramType = typeFromSignatureStr(
                                sig->param_types[i]);
                            if (paramType.isResolved()) {
                                if (typeEnv[call.getArgs()[i]].mergeFrom(paramType))
                                    changed = true;
                            }
                        }
                    }
                    return;
                }

                // Rule H5: binary — propagate types through binary expressions.
                if (auto binop = dyn_cast<helix::high::BinaryOp>(op)) {
                    auto lhsType = typeEnv[binop.getLhs()];
                    auto rhsType = typeEnv[binop.getRhs()];

                    CTypeInfo inferred;
                    // Pointer arithmetic propagation
                    if (lhsType.kind == CTypeInfo::Pointer ||
                        rhsType.kind == CTypeInfo::Pointer) {
                        inferred = CTypeInfo::makePointer();
                    } else if (lhsType.isResolved()) {
                        inferred = lhsType;
                    } else if (rhsType.isResolved()) {
                        inferred = rhsType;
                    }

                    if (inferred.isResolved()) {
                        if (typeEnv[binop.getResult()].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Rule H6: cast — propagate type through cast ops.
                if (auto cast = dyn_cast<helix::high::CastOp>(op)) {
                    unsigned resultWidth = 0;
                    if (auto intTy = dyn_cast<IntegerType>(cast.getResult().getType()))
                        resultWidth = intTy.getWidth();
                    if (resultWidth > 0) {
                        // Preserve signedness from input if known
                        auto inputType = typeEnv[cast.getInput()];
                        bool isSigned = inputType.isResolved() ? inputType.is_signed : false;
                        CTypeInfo inferred = CTypeInfo::makeInt(resultWidth, isSigned);
                        if (typeEnv[cast.getResult()].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Rule H7: Parameter usage inference — if a variable is used
                // as an operand in a pointer operation (deref, address-of),
                // infer it as void*.
                if (auto unary = dyn_cast<helix::high::UnaryOp>(op)) {
                    auto opKind = unary.getOp();
                    if (opKind == helix::high::UnaryOpKind::Deref ||
                        opKind == helix::high::UnaryOpKind::AddressOf) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (opKind == helix::high::UnaryOpKind::Deref) {
                            // The operand being dereferenced must be a pointer
                            if (typeEnv[unary.getOperand()].mergeFrom(ptrType))
                                changed = true;
                        } else {
                            // AddressOf produces a pointer
                            if (typeEnv[unary.getResult()].mergeFrom(ptrType))
                                changed = true;
                        }
                    }
                    return;
                }
            });

            // Fixed point reached — no more changes.
            if (!changed)
                break;
        }

        // ─── Phase 2: Backward propagation (use→def) for HelixHigh ──────────
        //
        // Walk operations and propagate type constraints from uses back to
        // definitions. This catches cases the forward pass missed because the
        // type information only becomes available from the consumer side.
        for (unsigned backIter = 0; backIter < kMaxIterations; backIter++) {
            bool changed = false;

            func.walk([&](Operation* op) {
                // Backward Rule HB1: BinaryOp comparison — for comparison
                // operators (Eq, Ne, Lt, Le, Gt, Ge), both operands should have
                // the same type. If one is known, propagate to the other.
                if (auto binop = dyn_cast<helix::high::BinaryOp>(op)) {
                    auto opKind = binop.getOp();
                    if (opKind == helix::high::BinaryOpKind::Eq ||
                        opKind == helix::high::BinaryOpKind::Ne ||
                        opKind == helix::high::BinaryOpKind::Lt ||
                        opKind == helix::high::BinaryOpKind::Le ||
                        opKind == helix::high::BinaryOpKind::Gt ||
                        opKind == helix::high::BinaryOpKind::Ge) {
                        auto lhsType = typeEnv[binop.getLhs()];
                        auto rhsType = typeEnv[binop.getRhs()];
                        if (lhsType.isResolved() && !rhsType.isResolved()) {
                            if (typeEnv[binop.getRhs()].mergeFrom(lhsType))
                                changed = true;
                        } else if (rhsType.isResolved() &&
                                   !lhsType.isResolved()) {
                            if (typeEnv[binop.getLhs()].mergeFrom(rhsType))
                                changed = true;
                        }
                    }

                    // For arithmetic ops: if the result type is known,
                    // propagate back to operands.
                    if (opKind == helix::high::BinaryOpKind::Add ||
                        opKind == helix::high::BinaryOpKind::Sub ||
                        opKind == helix::high::BinaryOpKind::Mul ||
                        opKind == helix::high::BinaryOpKind::BitAnd ||
                        opKind == helix::high::BinaryOpKind::BitOr ||
                        opKind == helix::high::BinaryOpKind::BitXor) {
                        auto resultType = typeEnv[binop.getResult()];
                        if (resultType.isResolved() &&
                            resultType.kind != CTypeInfo::Pointer) {
                            if (typeEnv[binop.getLhs()].mergeFrom(resultType))
                                changed = true;
                            if (typeEnv[binop.getRhs()].mergeFrom(resultType))
                                changed = true;
                        }
                    }
                    return;
                }

                // Backward Rule HB2: Call argument — propagate known parameter
                // types back to the argument-producing definitions, and
                // propagate function return type to values that USE the call
                // result.
                if (auto call = dyn_cast<helix::high::CallOp>(op)) {
                    auto targetName = call.getTargetName();
                    auto sig = helix::lookupSignature(targetName);
                    if (sig) {
                        // Backward: parameter types → argument definitions
                        for (unsigned i = 0;
                             i < call.getArgs().size() &&
                             i < sig->param_types.size();
                             i++) {
                            CTypeInfo paramType =
                                typeFromSignatureStr(sig->param_types[i]);
                            if (paramType.isResolved()) {
                                if (typeEnv[call.getArgs()[i]].mergeFrom(
                                        paramType))
                                    changed = true;

                                // Also propagate to variable type map if the
                                // argument comes from a var.ref.
                                if (auto varRef =
                                        call.getArgs()[i]
                                            .getDefiningOp<
                                                helix::high::VarRefOp>()) {
                                    uint32_t varId = varRef.getVarId();
                                    if (varTypes[varId].mergeFrom(paramType))
                                        changed = true;
                                }
                            }
                        }

                        // Backward: if the return type is known and the call
                        // has a result, propagate to the result.
                        CTypeInfo retType =
                            typeFromSignatureStr(sig->return_type);
                        if (retType.isResolved() && call.getResult()) {
                            if (typeEnv[call.getResult()].mergeFrom(retType))
                                changed = true;
                        }
                    }
                    return;
                }

                // Backward Rule HB3: Return — if the function has a known
                // return type (from SignatureDb or from an attribute), propagate
                // it to the returned value.
                if (auto ret = dyn_cast<helix::high::ReturnOp>(op)) {
                    if (ret.getValue()) {
                        Value retVal = ret.getValue();
                        // Check if the enclosing function has a known signature
                        auto funcName = func.getSymName();
                        auto sig = helix::lookupSignature(funcName);
                        if (sig) {
                            CTypeInfo retType =
                                typeFromSignatureStr(sig->return_type);
                            if (retType.isResolved()) {
                                if (typeEnv[retVal].mergeFrom(retType))
                                    changed = true;

                                // Propagate to variable type map if returning
                                // a var.ref.
                                if (auto varRef =
                                        retVal.getDefiningOp<
                                            helix::high::VarRefOp>()) {
                                    uint32_t varId = varRef.getVarId();
                                    if (varTypes[varId].mergeFrom(retType))
                                        changed = true;
                                }
                            }
                        }

                        // Also check if the function has an "inferred_return_type"
                        // attribute set by an earlier pass.
                        if (auto retTypeAttr =
                                func->getAttrOfType<StringAttr>(
                                    "inferred_return_type")) {
                            CTypeInfo retType =
                                typeFromSignatureStr(retTypeAttr.getValue());
                            if (retType.isResolved()) {
                                if (typeEnv[retVal].mergeFrom(retType))
                                    changed = true;
                            }
                        }
                    }
                    return;
                }

                // Backward Rule HB4: Assign — if the target variable has a
                // type (from earlier forward or backward rules), propagate it
                // back to the source value's definition.
                if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
                    Value target = assign.getTarget();
                    Value value = assign.getValue();

                    // If target is a var.ref, use the variable type map.
                    if (auto varRef =
                            target.getDefiningOp<helix::high::VarRefOp>()) {
                        uint32_t varId = varRef.getVarId();
                        auto varType = varTypes[varId];
                        if (varType.isResolved()) {
                            if (typeEnv[value].mergeFrom(varType))
                                changed = true;
                        }
                    }

                    // If the assigned value type is known, propagate to target.
                    auto valueType = typeEnv[value];
                    auto targetType = typeEnv[target];
                    if (valueType.isResolved() && !targetType.isResolved()) {
                        if (typeEnv[target].mergeFrom(valueType))
                            changed = true;
                    }
                    if (targetType.isResolved() && !valueType.isResolved()) {
                        if (typeEnv[value].mergeFrom(targetType))
                            changed = true;
                    }
                    return;
                }

                // Backward Rule HB5: CastOp — if the result type is known,
                // and the cast is a sign/zero extension, propagate signedness
                // back to the input.
                if (auto cast = dyn_cast<helix::high::CastOp>(op)) {
                    auto resultType = typeEnv[cast.getResult()];
                    auto inputType = typeEnv[cast.getInput()];
                    if (resultType.isResolved() && !inputType.isResolved()) {
                        unsigned inputWidth = 0;
                        if (auto intTy =
                                dyn_cast<IntegerType>(
                                    cast.getInput().getType()))
                            inputWidth = intTy.getWidth();
                        if (inputWidth > 0) {
                            CTypeInfo inferred = CTypeInfo::makeInt(
                                inputWidth, resultType.is_signed);
                            if (typeEnv[cast.getInput()].mergeFrom(inferred))
                                changed = true;
                        }
                    }
                    return;
                }
            });

            // Fixed point reached — no more backward changes.
            if (!changed)
                break;
        }

        // Store resolved types as attributes on var.decl operations.
        for (auto& [varId, typeInfo] : varTypes) {
            if (!typeInfo.isResolved())
                continue;

            std::string typeStr;
            switch (typeInfo.kind) {
            case CTypeInfo::Bool:    typeStr = "bool"; break;
            case CTypeInfo::Int:     typeStr = std::format("int{}_t", typeInfo.bit_width); break;
            case CTypeInfo::UInt:    typeStr = std::format("uint{}_t", typeInfo.bit_width); break;
            case CTypeInfo::Float:   typeStr = std::format("float{}", typeInfo.bit_width); break;
            case CTypeInfo::Pointer: typeStr = "void*"; break;
            case CTypeInfo::Void:    typeStr = "void"; break;
            default: continue;
            }

            // Find the var.decl with this ID and set the attribute.
            func.walk([&](helix::high::VarDeclOp decl) {
                if (decl.getVarId() == varId) {
                    decl->setAttr("inferred_type",
                        StringAttr::get(decl->getContext(), typeStr));
                }
            });
        }

        // Store resolved types on SSA value defining ops.
        for (auto& [val, typeInfo] : typeEnv) {
            if (!typeInfo.isResolved())
                continue;

            auto* defOp = val.getDefiningOp();
            if (!defOp)
                continue;

            std::string typeStr;
            switch (typeInfo.kind) {
            case CTypeInfo::Bool:    typeStr = "bool"; break;
            case CTypeInfo::Int:     typeStr = std::format("int{}_t", typeInfo.bit_width); break;
            case CTypeInfo::UInt:    typeStr = std::format("uint{}_t", typeInfo.bit_width); break;
            case CTypeInfo::Float:   typeStr = std::format("float{}", typeInfo.bit_width); break;
            case CTypeInfo::Pointer: typeStr = "void*"; break;
            case CTypeInfo::Void:    typeStr = "void"; break;
            default: continue;
            }

            defOp->setAttr("inferred_type",
                StringAttr::get(defOp->getContext(), typeStr));
        }
    }
};

} // anonymous namespace

std::unique_ptr<mlir::Pass> helix::createPropagateTypesPass() {
    return std::make_unique<PropagateTypesPass>();
}
