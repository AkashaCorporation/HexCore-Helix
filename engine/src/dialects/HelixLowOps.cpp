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

namespace {

static FailureOr<unsigned> integerWidth(Type type) {
    if (auto integer = dyn_cast<IntegerType>(type))
        return integer.getWidth();
    return failure();
}

static LogicalResult verifyEncodedWidth(
        Operation* operation, Type type, uint32_t encoded,
        StringRef role) {
    auto width = integerWidth(type);
    if (failed(width))
        return operation->emitOpError() << role << " must be an integer";
    if (encoded == 0)
        return operation->emitOpError("bit width must be non-zero");
    if (*width != encoded) {
        return operation->emitOpError()
            << role << " width " << *width
            << " does not match encoded width " << encoded;
    }
    return success();
}

static LogicalResult verifySameIntegerType(
        Operation* operation, Type lhs, Type rhs, StringRef roles) {
    if (!isa<IntegerType>(lhs) || !isa<IntegerType>(rhs))
        return operation->emitOpError() << roles << " must be integers";
    if (lhs != rhs)
        return operation->emitOpError() << roles << " must have equal types";
    return success();
}

} // namespace

LogicalResult RegReadOp::verify() {
    return verifyEncodedWidth(
        getOperation(), getResult().getType(), getBitWidth(), "result");
}

LogicalResult RegWriteOp::verify() {
    auto width = integerWidth(getValue().getType());
    if (failed(width))
        return emitOpError("value must be an integer");
    if (*width == getBitWidth())
        return success();

    auto partial = (*this)->getAttrOfType<IntegerAttr>(
        "helix.partial_write_width");
    StringRef name = getRegName();
    const bool vectorRegister = name.starts_with_insensitive("xmm") ||
                                name.starts_with_insensitive("ymm") ||
                                name.starts_with_insensitive("zmm");
    if (partial && vectorRegister && *width < getBitWidth() &&
        partial.getValue().getZExtValue() == *width)
        return success();

    return emitOpError()
        << "value width " << *width
        << " does not match encoded width " << getBitWidth();
}

LogicalResult MemReadOp::verify() {
    return verifyEncodedWidth(
        getOperation(), getResult().getType(), getBitWidth(), "result");
}

LogicalResult MemWriteOp::verify() {
    return verifyEncodedWidth(
        getOperation(), getValue().getType(), getBitWidth(), "value");
}

LogicalResult BinOp::verify() {
    if (failed(verifySameIntegerType(
            getOperation(), getLhs().getType(), getRhs().getType(),
            "operands")))
        return failure();
    return verifySameIntegerType(
        getOperation(), getLhs().getType(), getResult().getType(),
        "operands and result");
}

LogicalResult UnaryOp::verify() {
    return verifySameIntegerType(
        getOperation(), getOperand().getType(), getResult().getType(),
        "operand and result");
}

LogicalResult CmpOp::verify() {
    return verifySameIntegerType(
        getOperation(), getLhs().getType(), getRhs().getType(),
        "operands");
}

LogicalResult TestOp::verify() {
    return verifySameIntegerType(
        getOperation(), getLhs().getType(), getRhs().getType(),
        "operands");
}

static LogicalResult verifyExtension(
        Operation* operation, Type source, Type result, uint32_t destination) {
    auto sourceWidth = integerWidth(source);
    auto resultWidth = integerWidth(result);
    if (failed(sourceWidth) || failed(resultWidth))
        return operation->emitOpError("extension requires integer types");
    if (*resultWidth != destination) {
        return operation->emitOpError()
            << "result width " << *resultWidth
            << " does not match dst_width " << destination;
    }
    if (*sourceWidth >= *resultWidth)
        return operation->emitOpError(
            "extension requires a narrower source type");
    return success();
}

LogicalResult MovZxOp::verify() {
    return verifyExtension(
        getOperation(), getSrc().getType(), getResult().getType(),
        getDstWidth());
}

LogicalResult MovSxOp::verify() {
    return verifyExtension(
        getOperation(), getSrc().getType(), getResult().getType(),
        getDstWidth());
}

LogicalResult CMovOp::verify() {
    if (failed(verifySameIntegerType(
            getOperation(), getTrueVal().getType(), getFalseVal().getType(),
            "selected values")))
        return failure();
    return verifySameIntegerType(
        getOperation(), getTrueVal().getType(), getResult().getType(),
        "selected values and result");
}

LogicalResult XchgOp::verify() {
    switch (getBitWidth()) {
    case 8:
    case 16:
    case 32:
    case 64:
        return success();
    default:
        return emitOpError("bit width must be one of 8, 16, 32, or 64");
    }
}

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
