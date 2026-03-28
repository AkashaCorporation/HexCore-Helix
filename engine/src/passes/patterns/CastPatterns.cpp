/// @file CastPatterns.cpp
/// @brief Cast simplification patterns for HelixLow and HelixMid dialects.
///
/// Removes redundant zero-extend/sign-extend operations at the HelixLow level
/// and redundant cast/deref/addr-of chains at the HelixMid level.

#include "helix/passes/Patterns.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixMidOps.h"

#include "mlir/IR/PatternMatch.h"

#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "helix-cast-patterns"

using namespace mlir;
using namespace helix;

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// HelixLow Cast Patterns
// ═══════════════════════════════════════════════════════════════════════════════

/// RedundantMovzx: `movzx val, width` where val already has the target width.
/// This occurs when the lifter emits a zero-extend from N bits to N bits.
struct RedundantMovzx : public OpRewritePattern<low::MovZxOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::MovZxOp op,
                                  PatternRewriter &rewriter) const override {
        auto srcType = dyn_cast<IntegerType>(op.getSrc().getType());
        if (!srcType)
            return failure();

        // If the source width already matches the destination width,
        // the movzx is a no-op.
        if (srcType.getWidth() == op.getDstWidth()) {
            rewriter.replaceOp(op, op.getSrc());
            return success();
        }

        return failure();
    }
};

/// RedundantMovsx: `movsx val, width` where val already has the target width.
struct RedundantMovsx : public OpRewritePattern<low::MovSxOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::MovSxOp op,
                                  PatternRewriter &rewriter) const override {
        auto srcType = dyn_cast<IntegerType>(op.getSrc().getType());
        if (!srcType)
            return failure();

        if (srcType.getWidth() == op.getDstWidth()) {
            rewriter.replaceOp(op, op.getSrc());
            return success();
        }

        return failure();
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// HelixMid Cast Patterns
// ═══════════════════════════════════════════════════════════════════════════════

/// RedundantCast: cast(cast(x, T1), T2) → cast(x, T2).
/// Eliminates an intermediate cast by going directly from the original type
/// to the final type.
struct RedundantCast : public OpRewritePattern<mid::CastOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(mid::CastOp op,
                                  PatternRewriter &rewriter) const override {
        auto innerCast = op.getInput().getDefiningOp<mid::CastOp>();
        if (!innerCast)
            return failure();

        // Replace cast(cast(x, T1), T2) with cast(x, T2).
        auto newCast = rewriter.create<mid::CastOp>(
            op.getLoc(),
            op.getResult().getType(),
            innerCast.getInput(),
            op.getAddressAttr());

        rewriter.replaceOp(op, newCast.getResult());
        return success();
    }
};

/// DoubleDeref: Deref(AddrOf(x)) → x.
/// Taking the address of something and immediately dereferencing it is a no-op.
struct DoubleDeref : public OpRewritePattern<mid::UnExprOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(mid::UnExprOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != mid::UnExprKind::Deref)
            return failure();

        auto innerOp = op.getOperand().getDefiningOp<mid::UnExprOp>();
        if (!innerOp || innerOp.getKind() != mid::UnExprKind::AddrOf)
            return failure();

        // Deref(AddrOf(x)) == x, provided the types match.
        if (innerOp.getOperand().getType() != op.getResult().getType())
            return failure();

        rewriter.replaceOp(op, innerOp.getOperand());
        return success();
    }
};

/// CastToSameType: cast x to T where x already has type T → x.
struct CastToSameType : public OpRewritePattern<mid::CastOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(mid::CastOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getInput().getType() != op.getResult().getType())
            return failure();

        rewriter.replaceOp(op, op.getInput());
        return success();
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pattern Registration
// ═══════════════════════════════════════════════════════════════════════════════

void helix::populateHelixLowCastPatterns(RewritePatternSet &patterns) {
    patterns.add<
        RedundantMovzx,
        RedundantMovsx
    >(patterns.getContext());
}

void helix::populateHelixMidCastPatterns(RewritePatternSet &patterns) {
    patterns.add<
        RedundantCast,
        DoubleDeref,
        CastToSameType
    >(patterns.getContext());
}

// NOTE: populateHelixMidConstantFoldPatterns is defined in
// ConstantFoldPatterns.cpp (P2.11). The stub that was here has been
// removed to avoid duplicate symbol / linker ordering issues.
