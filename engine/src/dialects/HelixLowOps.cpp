/// @file HelixLowOps.cpp
/// @brief Operation implementations for the Helix Low-Level Dialect.
///
/// Contains verifiers, canonicalization patterns, and any custom logic
/// beyond what TableGen auto-generates.

#include "helix/dialects/HelixLowOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/OpImplementation.h"

using namespace mlir;
using namespace helix::low;

// ─── Enum definitions ────────────────────────────────────────────────────────

#include "helix/dialects/HelixLowEnums.cpp.inc"

// ─── Op definitions ──────────────────────────────────────────────────────────

#define GET_OP_CLASSES
#include "helix/dialects/HelixLowOps.cpp.inc"

SuccessorOperands JmpOp::getSuccessorOperands(unsigned index) {
    assert(index == 0 && "invalid successor index");
    return SuccessorOperands(getDestOperandsMutable());
}

Block* JmpOp::getSuccessorForOperands(ArrayRef<Attribute>) {
    return getDest();
}

SuccessorOperands JccOp::getSuccessorOperands(unsigned index) {
    assert(index < getNumSuccessors() && "invalid successor index");
    return SuccessorOperands(
        index == 0 ? getTrueDestOperandsMutable()
                   : getFalseDestOperandsMutable());
}

Block* JccOp::getSuccessorForOperands(ArrayRef<Attribute> operands) {
    if (auto condition = dyn_cast_or_null<IntegerAttr>(operands.front()))
        return condition.getValue().isOne() ? getTrueDest() : getFalseDest();
    return nullptr;
}
