/// @file HelixHighOps.cpp
/// @brief Operation implementations for the Helix High-Level Dialect.
///
/// Contains verifiers, canonicalization patterns, and region builders
/// for structured control flow operations.

#include "helix/dialects/HelixHighOps.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/OpImplementation.h"

using namespace mlir;
using namespace helix::high;

LogicalResult CastOp::verify() {
    auto kind = getCastKind();
    if (!kind || *kind == CastKind::Unknown)
        return success();

    Type source = getInput().getType();
    Type target = getResult().getType();
    auto sourceInt = dyn_cast<IntegerType>(source);
    auto targetInt = dyn_cast<IntegerType>(target);
    const bool sourcePointer = isa<LLVM::LLVMPointerType>(source);
    const bool targetPointer = isa<LLVM::LLVMPointerType>(target);

    switch (*kind) {
    case CastKind::ZeroExtend:
    case CastKind::SignExtend:
        if (!sourceInt || !targetInt ||
            sourceInt.getWidth() >= targetInt.getWidth())
            return emitOpError("extension requires narrower integer input");
        break;
    case CastKind::Truncate:
        if (!sourceInt || !targetInt ||
            sourceInt.getWidth() <= targetInt.getWidth())
            return emitOpError("truncation requires wider integer input");
        break;
    case CastKind::PtrToInt:
        if (!sourcePointer || !targetInt)
            return emitOpError("ptr_to_int requires pointer to integer");
        break;
    case CastKind::IntToPtr:
        if (!sourceInt || !targetPointer)
            return emitOpError("int_to_ptr requires integer to pointer");
        break;
    case CastKind::FpExtend:
        if (!isa<FloatType>(source) || !isa<FloatType>(target) ||
            cast<FloatType>(source).getWidth() >=
                cast<FloatType>(target).getWidth())
            return emitOpError("fp extension requires narrower float input");
        break;
    case CastKind::FpTruncate:
        if (!isa<FloatType>(source) || !isa<FloatType>(target) ||
            cast<FloatType>(source).getWidth() <=
                cast<FloatType>(target).getWidth())
            return emitOpError("fp truncation requires wider float input");
        break;
    case CastKind::FpToSI:
    case CastKind::FpToUI:
        if (!isa<FloatType>(source) || !targetInt)
            return emitOpError("fp_to_int requires float to integer");
        break;
    case CastKind::SIToFp:
    case CastKind::UIToFp:
        if (!sourceInt || !isa<FloatType>(target))
            return emitOpError("int_to_fp requires integer to float");
        break;
    case CastKind::Bitcast:
    case CastKind::Unknown:
        break;
    }
    return success();
}

LogicalResult ReturnOp::verify() {
    auto function = (*this)->getParentOfType<FuncOp>();
    if (!function) {
        for (Operation* parent = (*this)->getParentOp(); parent;
             parent = parent->getParentOp()) {
            if (parent->getName().getStringRef() == "helix_low.func")
                return success();
        }
        return emitOpError("must be nested in helix_high.func");
    }
    auto complete = function->getAttrOfType<BoolAttr>(
        "helix.signature_complete");
    if (!complete || !complete.getValue())
        return success();

    auto functionType = cast<FunctionType>(function.getFunctionType());
    const unsigned operandCount = getValue() ? 1u : 0u;
    if (functionType.getNumResults() != operandCount) {
        return emitOpError()
            << "returns " << operandCount << " value(s), but function type has "
            << functionType.getNumResults() << " result(s)";
    }
    if (operandCount == 1 &&
        getValue().getType() != functionType.getResult(0)) {
        return emitOpError("return value type does not match function result");
    }
    return success();
}

void UnaryOp::getEffects(
        llvm::SmallVectorImpl<MemoryEffects::EffectInstance>& effects) {
    if (getOp() == UnaryOpKind::Deref) {
        effects.emplace_back(
            MemoryEffects::Read::get(),
            helix::effects::ProgramMemoryResource::get());
    }
}

void AssignOp::getEffects(
        llvm::SmallVectorImpl<MemoryEffects::EffectInstance>& effects) {
    Operation* targetDef = getTarget().getDefiningOp();
    const bool writesProgramMemory =
        (isa_and_nonnull<UnaryOp>(targetDef) &&
         cast<UnaryOp>(targetDef).getOp() == UnaryOpKind::Deref) ||
        isa_and_nonnull<FieldAccessOp, SubscriptOp>(targetDef);
    effects.emplace_back(
        MemoryEffects::Write::get(),
        writesProgramMemory
            ? static_cast<SideEffects::Resource*>(
                  helix::effects::ProgramMemoryResource::get())
            : static_cast<SideEffects::Resource*>(
                  helix::effects::VariableStateResource::get()));
}

// ─── Enum definitions ────────────────────────────────────────────────────────

#include "helix/dialects/HelixHighEnums.cpp.inc"

// ─── Op definitions ──────────────────────────────────────────────────────────

#define GET_OP_CLASSES
#include "helix/dialects/HelixHighOps.cpp.inc"
