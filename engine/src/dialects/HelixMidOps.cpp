/// @file HelixMidOps.cpp
/// @brief Helix Mid-Level Dialect operation definitions.

#include "helix/dialects/HelixMidOps.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/PatternMatch.h"

#include "mlir/IR/OpImplementation.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace helix::mid;

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

void UnExprOp::getEffects(
        llvm::SmallVectorImpl<MemoryEffects::EffectInstance>& effects) {
    if (getKind() == UnExprKind::Deref) {
        effects.emplace_back(
            MemoryEffects::Read::get(),
            helix::effects::ProgramMemoryResource::get());
    }
}

llvm::SmallVector<MemorySlot> SlotAllocOp::getPromotableSlots() {
    if (!getPromotable() || !getOperation()->getBlock()->isEntryBlock())
        return {};
    auto slotType = getSlot().getType().cast<SlotType>();
    return {MemorySlot{getSlot(), slotType.getValueType()}};
}

Value SlotAllocOp::getDefaultValue(
        const MemorySlot& slot, RewriterBase& rewriter) {
    return rewriter.create<LLVM::UndefOp>(getLoc(), slot.elemType);
}

void SlotAllocOp::handleBlockArgument(
        const MemorySlot&, BlockArgument, RewriterBase&) {}

void SlotAllocOp::handlePromotionComplete(
        const MemorySlot&, Value defaultValue, RewriterBase& rewriter) {
    if (defaultValue && defaultValue.use_empty())
        rewriter.eraseOp(defaultValue.getDefiningOp());
    rewriter.eraseOp(*this);
}

bool SlotLoadOp::loadsFrom(const MemorySlot& slot) {
    return getSlot() == slot.ptr;
}
bool SlotLoadOp::storesTo(const MemorySlot&) { return false; }
Value SlotLoadOp::getStored(const MemorySlot&, RewriterBase&) {
    llvm_unreachable("slot.load never stores");
}
bool SlotLoadOp::canUsesBeRemoved(
        const MemorySlot& slot,
        const llvm::SmallPtrSetImpl<OpOperand*>& blockingUses,
        llvm::SmallVectorImpl<OpOperand*>&) {
    return blockingUses.size() == 1 &&
           (*blockingUses.begin())->get() == slot.ptr &&
           getSlot() == slot.ptr && getResult().getType() == slot.elemType;
}
DeletionKind SlotLoadOp::removeBlockingUses(
        const MemorySlot&, const llvm::SmallPtrSetImpl<OpOperand*>&,
        RewriterBase& rewriter, Value reachingDefinition) {
    rewriter.replaceAllUsesWith(getResult(), reachingDefinition);
    return DeletionKind::Delete;
}

bool SlotStoreOp::loadsFrom(const MemorySlot&) { return false; }
bool SlotStoreOp::storesTo(const MemorySlot& slot) {
    return getSlot() == slot.ptr;
}
Value SlotStoreOp::getStored(const MemorySlot&, RewriterBase&) {
    return getValue();
}
bool SlotStoreOp::canUsesBeRemoved(
        const MemorySlot& slot,
        const llvm::SmallPtrSetImpl<OpOperand*>& blockingUses,
        llvm::SmallVectorImpl<OpOperand*>&) {
    return blockingUses.size() == 1 &&
           (*blockingUses.begin())->get() == slot.ptr &&
           getSlot() == slot.ptr && getValue() != slot.ptr &&
           getValue().getType() == slot.elemType;
}
DeletionKind SlotStoreOp::removeBlockingUses(
        const MemorySlot&, const llvm::SmallPtrSetImpl<OpOperand*>&,
        RewriterBase&, Value) {
    return DeletionKind::Delete;
}

// ─── Enum Definitions ────────────────────────────────────────────────────────

#include "helix/dialects/HelixMidEnums.cpp.inc"

// ─── Op Definitions ──────────────────────────────────────────────────────────

#define GET_OP_CLASSES
#include "helix/dialects/HelixMidOps.cpp.inc"
