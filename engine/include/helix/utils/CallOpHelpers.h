#pragma once
/// @file CallOpHelpers.h
/// @brief Centralised recognition of HelixLow call-like operations.
///
/// HelixLow has two call ops: the standard `helix_low.call` (CallOp) and the
/// Wave-22 `helix_low.variadic_call` (VariadicCallOp). Passes that recognise
/// calls by exact type (`isa<helix::low::CallOp>`) silently miss the variadic
/// variant, treating it as "not a call" — which breaks calling-convention
/// inference, type propagation, and variable scoping once the variadic ISA is
/// emitted.
///
/// These helpers query both ops uniformly so a new call-like op only needs to
/// be added here, not at every recognition site. They intentionally cover only
/// the Low dialect — the level where the lift→mid passes operate.

#ifndef HELIX_UTILS_CALL_OP_HELPERS_H
#define HELIX_UTILS_CALL_OP_HELPERS_H

#include "mlir/IR/Operation.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include "helix/dialects/HelixLowOps.h"

#include <optional>

namespace helix {

/// True for any HelixLow call op — standard `CallOp` or `VariadicCallOp`.
inline bool isAnyCallOp(mlir::Operation* op) {
    return mlir::isa<helix::low::CallOp, helix::low::VariadicCallOp>(op);
}

/// The resolved target-name attribute shared by both call ops (nullopt when
/// absent — indirect calls, or name not yet recovered).
inline std::optional<llvm::StringRef> getCallTargetName(mlir::Operation* op) {
    if (auto c = mlir::dyn_cast<helix::low::CallOp>(op))
        return c.getTargetName();
    if (auto v = mlir::dyn_cast<helix::low::VariadicCallOp>(op))
        return v.getTargetName();
    return std::nullopt;
}

/// The argument operands of either call op. For `VariadicCallOp` this is the
/// fixed-arg prefix (the variadic tail lives in the bundle operand, not here),
/// which matches how `CallOp::getArgs()` is consumed by type/signature logic.
inline mlir::Operation::operand_range getCallArgs(mlir::Operation* op) {
    if (auto c = mlir::dyn_cast<helix::low::CallOp>(op))
        return c.getArgs();
    if (auto v = mlir::dyn_cast<helix::low::VariadicCallOp>(op))
        return v.getFixedArgs();
    // Empty range rooted at `op` so callers can iterate safely.
    return mlir::Operation::operand_range(op->operand_end(), op->operand_end());
}

}  // namespace helix

#endif  // HELIX_UTILS_CALL_OP_HELPERS_H
