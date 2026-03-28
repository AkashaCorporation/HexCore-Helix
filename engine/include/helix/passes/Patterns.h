#pragma once
/// @file Patterns.h
/// @brief Pattern registration functions for Helix simplification passes.
///
/// Each pattern group has a populate*Patterns() function that adds rewrite
/// patterns to a RewritePatternSet. The HelixLowSimplify and HelixMidSimplify
/// passes call these to build their pattern sets before invoking the greedy
/// pattern rewriter.

#ifndef HELIX_PASSES_PATTERNS_H
#define HELIX_PASSES_PATTERNS_H

#include "mlir/IR/PatternMatch.h"

namespace helix {

// ─── HelixLow Pattern Groups ─────────────────────────────────────────────────

/// Populate arithmetic identity/simplification patterns for HelixLow ops.
///
/// Includes: XorSelfToZero, DoubleNeg, AddZero, MulOne, AndAllOnes,
/// OrZero, ShiftByZero.
void populateHelixLowArithPatterns(mlir::RewritePatternSet &patterns);

/// Populate dead flag elimination patterns for HelixLow ops.
///
/// Removes unused flag results from binop/unaryop/cmp/test operations.
void populateHelixLowFlagPatterns(mlir::RewritePatternSet &patterns);

/// Populate memory optimization patterns for HelixLow ops.
///
/// Includes: LoadAfterStore forwarding, StoreAfterStore elimination.
void populateHelixLowMemoryPatterns(mlir::RewritePatternSet &patterns);

/// Populate cast simplification patterns for HelixLow ops.
///
/// Includes: RedundantMovzx, RedundantMovsx.
void populateHelixLowCastPatterns(mlir::RewritePatternSet &patterns);

// ─── HelixMid Pattern Groups ─────────────────────────────────────────────────

/// Populate arithmetic identity/simplification patterns for HelixMid ops.
///
/// Includes: SubSelf, MidAddZero, MidMulOne, MidMulZero.
void populateHelixMidArithPatterns(mlir::RewritePatternSet &patterns);

/// Populate cast simplification patterns for HelixMid ops.
///
/// Includes: RedundantCast, DoubleDeref, CastToSameType.
void populateHelixMidCastPatterns(mlir::RewritePatternSet &patterns);

/// Populate constant folding patterns for HelixMid ops (P2.11).
///
/// Folds constant expressions at compile time.
void populateHelixMidConstantFoldPatterns(mlir::RewritePatternSet &patterns);

} // namespace helix

#endif // HELIX_PASSES_PATTERNS_H
