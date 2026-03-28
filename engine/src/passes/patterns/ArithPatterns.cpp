/// @file ArithPatterns.cpp
/// @brief Arithmetic identity and simplification patterns for HelixLow and
///        HelixMid dialects.
///
/// These patterns recognize algebraic identities (xor x,x = 0; add x,0 = x;
/// etc.) and simplify them away, reducing noise in the decompiled output.

#include "helix/passes/Patterns.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixMidOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"

#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "helix-arith-patterns"

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════════════════════════

/// Try to extract a constant integer value from an arith::ConstantOp.
static std::optional<int64_t> getArithConstant(Value val) {
    if (auto constOp = val.getDefiningOp<arith::ConstantOp>()) {
        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
            return intAttr.getInt();
    }
    return std::nullopt;
}

/// Try to extract a constant integer value from a mid::ConstantOp.
static std::optional<int64_t> getMidConstant(Value val) {
    if (auto constOp = val.getDefiningOp<mid::ConstantOp>())
        return constOp.getValue();
    return std::nullopt;
}

// ═══════════════════════════════════════════════════════════════════════════════
// HelixLow Arithmetic Patterns
// ═══════════════════════════════════════════════════════════════════════════════

namespace {

/// XOR x, x → 0 with flags ZF=1, SF=0, CF=0, OF=0.
/// This is a common compiler idiom for zeroing a register.
struct XorSelfToZero : public OpRewritePattern<low::BinOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::BinOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != low::BinOpKind::Xor)
            return failure();

        // Check that both operands are the same SSA value.
        if (op.getLhs() != op.getRhs())
            return failure();

        auto loc = op.getLoc();
        auto resultType = op.getResult().getType();

        // Guard: only fold if result type is integer
        if (!isa<IntegerType>(resultType))
            return failure();

        auto i1Type = rewriter.getI1Type();

        // Create a zero constant for the result.
        auto zero = rewriter.create<arith::ConstantOp>(
            loc, resultType, rewriter.getIntegerAttr(resultType, 0));

        // Create flag constants: ZF=1, SF=0, CF=0, OF=0.
        auto trueVal = rewriter.create<arith::ConstantOp>(
            loc, i1Type, rewriter.getBoolAttr(true));
        auto falseVal = rewriter.create<arith::ConstantOp>(
            loc, i1Type, rewriter.getBoolAttr(false));

        // Guard: BinOp must have exactly 5 results (value + 4 flags)
        if (op->getNumResults() != 5)
            return failure();

        rewriter.replaceOp(op, {zero, falseVal, trueVal, falseVal, falseVal});
        return success();
    }
};

/// NEG(NEG(x)) → x.
struct DoubleNeg : public OpRewritePattern<low::UnaryOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::UnaryOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != low::UnaryOpKind::Neg)
            return failure();

        auto innerNeg = op.getOperand().getDefiningOp<low::UnaryOp>();
        if (!innerNeg || innerNeg.getKind() != low::UnaryOpKind::Neg)
            return failure();

        // Only safe to simplify if flag results have no users.
        if (!op.getZeroFlag().use_empty() ||
            !op.getSignFlag().use_empty())
            return failure();

        // NEG(NEG(x)) == x; replace value result with original operand.
        rewriter.replaceAllUsesWith(op.getResult(), innerNeg.getOperand());
        rewriter.eraseOp(op);
        return success();
    }
};

/// ADD x, 0 → x (result only; flags may differ from a real ADD).
struct AddZero : public OpRewritePattern<low::BinOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::BinOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != low::BinOpKind::Add)
            return failure();

        auto rhsConst = getArithConstant(op.getRhs());
        if (!rhsConst || *rhsConst != 0)
            return failure();

        // Only safe to simplify if no flag result has users.
        if (!op.getCarryFlag().use_empty() ||
            !op.getZeroFlag().use_empty() ||
            !op.getSignFlag().use_empty() ||
            !op.getOverflowFlag().use_empty())
            return failure();

        rewriter.replaceAllUsesWith(op.getResult(), op.getLhs());
        rewriter.eraseOp(op);
        return success();
    }
};

/// MUL x, 1 → x.
struct MulOne : public OpRewritePattern<low::BinOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::BinOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != low::BinOpKind::Mul &&
            op.getKind() != low::BinOpKind::IMul)
            return failure();

        auto rhsConst = getArithConstant(op.getRhs());
        if (!rhsConst || *rhsConst != 1)
            return failure();

        if (!op.getCarryFlag().use_empty() ||
            !op.getZeroFlag().use_empty() ||
            !op.getSignFlag().use_empty() ||
            !op.getOverflowFlag().use_empty())
            return failure();

        rewriter.replaceAllUsesWith(op.getResult(), op.getLhs());
        rewriter.eraseOp(op);
        return success();
    }
};

/// AND x, -1 (all ones) → x.
struct AndAllOnes : public OpRewritePattern<low::BinOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::BinOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != low::BinOpKind::And)
            return failure();

        auto rhsConst = getArithConstant(op.getRhs());
        if (!rhsConst || *rhsConst != -1)
            return failure();

        if (!op.getCarryFlag().use_empty() ||
            !op.getZeroFlag().use_empty() ||
            !op.getSignFlag().use_empty() ||
            !op.getOverflowFlag().use_empty())
            return failure();

        rewriter.replaceAllUsesWith(op.getResult(), op.getLhs());
        rewriter.eraseOp(op);
        return success();
    }
};

/// OR x, 0 → x.
struct OrZero : public OpRewritePattern<low::BinOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::BinOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != low::BinOpKind::Or)
            return failure();

        auto rhsConst = getArithConstant(op.getRhs());
        if (!rhsConst || *rhsConst != 0)
            return failure();

        if (!op.getCarryFlag().use_empty() ||
            !op.getZeroFlag().use_empty() ||
            !op.getSignFlag().use_empty() ||
            !op.getOverflowFlag().use_empty())
            return failure();

        rewriter.replaceAllUsesWith(op.getResult(), op.getLhs());
        rewriter.eraseOp(op);
        return success();
    }
};

/// SHL/SHR/SAR x, 0 → x.
struct ShiftByZero : public OpRewritePattern<low::BinOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::BinOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != low::BinOpKind::Shl &&
            op.getKind() != low::BinOpKind::Shr &&
            op.getKind() != low::BinOpKind::Sar)
            return failure();

        auto rhsConst = getArithConstant(op.getRhs());
        if (!rhsConst || *rhsConst != 0)
            return failure();

        if (!op.getCarryFlag().use_empty() ||
            !op.getZeroFlag().use_empty() ||
            !op.getSignFlag().use_empty() ||
            !op.getOverflowFlag().use_empty())
            return failure();

        rewriter.replaceAllUsesWith(op.getResult(), op.getLhs());
        rewriter.eraseOp(op);
        return success();
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// HelixMid Arithmetic Patterns
// ═══════════════════════════════════════════════════════════════════════════════

/// SUB x, x → constant 0.
struct SubSelf : public OpRewritePattern<mid::BinExprOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(mid::BinExprOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != mid::BinExprKind::Sub)
            return failure();

        if (op.getLhs() != op.getRhs())
            return failure();

        auto loc = op.getLoc();
        auto resultType = op.getResult().getType();

        // Guard: only fold integer-typed results (pointer-typed BinExprOps
        // come from LEA/address arithmetic in Remill IR)
        if (!isa<IntegerType>(resultType))
            return failure();

        auto zero = rewriter.create<mid::ConstantOp>(
            loc, resultType,
            rewriter.getIntegerAttr(resultType, 0),
            /*address=*/IntegerAttr{});

        rewriter.replaceOp(op, zero.getResult());
        return success();
    }
};

/// ADD x, 0 → x (HelixMid level).
struct MidAddZero : public OpRewritePattern<mid::BinExprOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(mid::BinExprOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != mid::BinExprKind::Add)
            return failure();

        if (!isa<IntegerType>(op.getResult().getType()))
            return failure();

        auto rhsConst = getMidConstant(op.getRhs());
        if (!rhsConst || *rhsConst != 0)
            return failure();

        rewriter.replaceOp(op, op.getLhs());
        return success();
    }
};

/// MUL x, 1 → x (HelixMid level).
struct MidMulOne : public OpRewritePattern<mid::BinExprOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(mid::BinExprOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != mid::BinExprKind::Mul)
            return failure();

        if (!isa<IntegerType>(op.getResult().getType()))
            return failure();

        auto rhsConst = getMidConstant(op.getRhs());
        if (!rhsConst || *rhsConst != 1)
            return failure();

        rewriter.replaceOp(op, op.getLhs());
        return success();
    }
};

/// MUL x, 0 → constant 0 (HelixMid level).
struct MidMulZero : public OpRewritePattern<mid::BinExprOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(mid::BinExprOp op,
                                  PatternRewriter &rewriter) const override {
        if (op.getKind() != mid::BinExprKind::Mul)
            return failure();

        auto resultType = op.getResult().getType();
        if (!isa<IntegerType>(resultType))
            return failure();

        auto rhsConst = getMidConstant(op.getRhs());
        if (!rhsConst || *rhsConst != 0)
            return failure();

        auto loc = op.getLoc();

        auto zero = rewriter.create<mid::ConstantOp>(
            loc, resultType,
            rewriter.getIntegerAttr(resultType, 0),
            /*address=*/IntegerAttr{});

        rewriter.replaceOp(op, zero.getResult());
        return success();
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pattern Registration
// ═══════════════════════════════════════════════════════════════════════════════

void helix::populateHelixLowArithPatterns(RewritePatternSet &patterns) {
    patterns.add<
        XorSelfToZero,
        DoubleNeg,
        AddZero,
        MulOne,
        AndAllOnes,
        OrZero,
        ShiftByZero
    >(patterns.getContext());
}

void helix::populateHelixMidArithPatterns(RewritePatternSet &patterns) {
    patterns.add<
        SubSelf,
        MidAddZero,
        MidMulOne,
        MidMulZero
    >(patterns.getContext());
}
