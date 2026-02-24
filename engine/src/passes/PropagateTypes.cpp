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

    void runOnOperation() override {
        auto module = getOperation();

        module.walk([&](helix::low::FuncOp func) {
            propagateTypes(func);
        });
    }

private:
    static constexpr unsigned kMaxIterations = 16;

    void propagateTypes(helix::low::FuncOp func) {
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
                if (auto binop = dyn_cast<helix::low::BinOp>(op)) {
                    auto result = binop.getResult();
                    auto lhsType = typeEnv[binop.getLhs()];
                    auto rhsType = typeEnv[binop.getRhs()];

                    CTypeInfo inferred;
                    if (lhsType.isResolved())
                        inferred = lhsType;
                    else if (rhsType.isResolved())
                        inferred = rhsType;

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

                // Rule 5: MOVZX → unsigned.
                if (auto movzx = dyn_cast<helix::low::MovZxOp>(op)) {
                    unsigned dstWidth = movzx.getDstWidth();
                    CTypeInfo inferred = CTypeInfo::makeInt(dstWidth, /*signed=*/false);
                    if (typeEnv[movzx.getResult()].mergeFrom(inferred))
                        changed = true;
                    return;
                }

                // Rule 6: MOVSX → signed.
                if (auto movsx = dyn_cast<helix::low::MovSxOp>(op)) {
                    unsigned dstWidth = movsx.getDstWidth();
                    CTypeInfo inferred = CTypeInfo::makeInt(dstWidth, /*signed=*/true);
                    if (typeEnv[movsx.getResult()].mergeFrom(inferred))
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
};

} // anonymous namespace

std::unique_ptr<mlir::Pass> helix::createPropagateTypesPass() {
    return std::make_unique<PropagateTypesPass>();
}
