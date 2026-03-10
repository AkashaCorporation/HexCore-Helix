/// @file PropagateTypes.cpp
/// @brief Type propagation pass: iteratively infer C types from usage patterns.
///
/// Implements a fixed-point iteration (max 16 rounds) that refines Unknown types
/// to concrete C types based on:
///   - Access widths (8-bit → int8_t, 32-bit → int32_t, etc.)
///   - API function signatures (known return types and parameter types)
///   - Binary operation semantics (comparison → bool, shift → same type)
///   - Pointer arithmetic patterns (base + offset → pointer)
///   - Sign extension/zero extension (movsx → signed, movzx → unsigned)

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

        // Propagate types in HelixLow functions.
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
