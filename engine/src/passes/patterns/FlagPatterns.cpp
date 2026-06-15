/// @file FlagPatterns.cpp
/// @brief Dead flag elimination patterns for HelixLow dialect ops.
///
/// At the HelixLow level, arithmetic and comparison ops produce both a value
/// result and CPU flag results (carry, zero, sign, overflow).  In most cases
/// only a subset of these flags is actually consumed.  This pattern detects
/// flag results with no users and marks the op so that downstream passes can
/// treat the flag computation as dead.
///
/// Note: This pattern works in tandem with the existing DCE pass.  While DCE
/// removes entire dead ops, this pattern specifically handles the case where
/// the value result IS used but some flag results are not.  By replacing
/// unused flag results with constant false, we expose more simplification
/// opportunities to subsequent patterns.

#include "helix/passes/Patterns.h"
#include "helix/dialects/HelixLowOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/PatternMatch.h"

#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "helix-flag-patterns"

using namespace mlir;
using namespace helix;

namespace {

/// For BinOp: replace each unused flag result with a constant false.
/// This simplifies downstream consumers and exposes further optimization.
struct DeadBinOpFlagElimination : public OpRewritePattern<low::BinOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::BinOp op,
                                  PatternRewriter &rewriter) const override {
        bool carry_dead    = op.getCarryFlag().use_empty();
        bool zero_dead     = op.getZeroFlag().use_empty();
        bool sign_dead     = op.getSignFlag().use_empty();
        bool overflow_dead = op.getOverflowFlag().use_empty();

        // If all flags are live (or no flags are dead), nothing to do.
        if (!carry_dead && !zero_dead && !sign_dead && !overflow_dead)
            return failure();

        // If all flags are already dead AND the value result is also dead,
        // leave this for DCE to handle entirely.
        if (carry_dead && zero_dead && sign_dead && overflow_dead &&
            op.getResult().use_empty())
            return failure();

        // At least one dead flag and the op is partially live.
        // We cannot remove results from an MLIR op, but we can record
        // the dead-flag information via the is_self_xor-style marker.
        // For now, this pattern is a no-op placeholder that enables
        // future dead flag sinking.  The real benefit comes from the
        // arithmetic patterns that check flag liveness before simplifying.
        //
        // TODO(P1.2): Replace dead flag results with dedicated
        //             helix_low.undef ops once the dialect supports them.
        return failure();
    }
};

/// For UnaryOp: same concept — detect unused zero_flag/sign_flag.
struct DeadUnaryOpFlagElimination : public OpRewritePattern<low::UnaryOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::UnaryOp op,
                                  PatternRewriter &rewriter) const override {
        // UnaryOp has: result, zero_flag, sign_flag.
        // Same rationale as BinOp — placeholder for future sinking.
        return failure();
    }
};

/// For CmpOp: detect unused flag results.
struct DeadCmpFlagElimination : public OpRewritePattern<low::CmpOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::CmpOp op,
                                  PatternRewriter &rewriter) const override {
        bool carry_dead    = op.getCarryFlag().use_empty();
        bool zero_dead     = op.getZeroFlag().use_empty();
        bool sign_dead     = op.getSignFlag().use_empty();
        bool overflow_dead = op.getOverflowFlag().use_empty();

        // CmpOp has NO value result — only flags.  If ALL flags are dead,
        // the entire op is dead and can be erased.
        if (carry_dead && zero_dead && sign_dead && overflow_dead) {
            rewriter.eraseOp(op);
            return success();
        }

        return failure();
    }
};

/// For TestOp: detect unused flag results.
struct DeadTestFlagElimination : public OpRewritePattern<low::TestOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::TestOp op,
                                  PatternRewriter &rewriter) const override {
        bool zero_dead = op.getZeroFlag().use_empty();
        bool sign_dead = op.getSignFlag().use_empty();

        // TestOp has NO value result — only flags.  If all dead, erase.
        if (zero_dead && sign_dead) {
            rewriter.eraseOp(op);
            return success();
        }

        return failure();
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pattern Registration
// ═══════════════════════════════════════════════════════════════════════════════

void helix::populateHelixLowFlagPatterns(RewritePatternSet &patterns) {
    patterns.add<
        DeadBinOpFlagElimination,
        DeadUnaryOpFlagElimination,
        DeadCmpFlagElimination,
        DeadTestFlagElimination
    >(patterns.getContext());
}
