/// @file ConstantFoldPatterns.cpp
/// @brief Constant folding patterns for HelixMid dialect (Nightly P2.11).
///
/// Folds binary expressions where both operands are compile-time constants.
/// Registered as patterns in the HelixMidSimplify pass.
///
/// Rules:
///   - Add(c1, c2) → c1+c2     Sub(c1, c2) → c1-c2
///   - Mul(c1, c2) → c1*c2     Div(c1, c2) → c1/c2 (c2≠0)
///   - Mod(c1, c2) → c1%c2     Shl(c1, c2) → c1<<c2
///   - Shr(c1, c2) → c1>>c2    BitAnd(c1, c2) → c1&c2
///   - BitOr(c1, c2) → c1|c2   BitXor(c1, c2) → c1^c2
///   - Eq(c1, c2) → c1==c2     Ne(c1, c2) → c1!=c2
///   - Lt(c1, c2) → c1<c2      Le(c1, c2) → c1<=c2
///   - Gt(c1, c2) → c1>c2      Ge(c1, c2) → c1>=c2
///
/// @version Helix-Nightly

#include "helix/passes/Patterns.h"
#include "helix/dialects/HelixMidOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/PatternMatch.h"

#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/APInt.h"

#define DEBUG_TYPE "helix-constant-fold"

STATISTIC(NumArithFolded, "Arithmetic expressions constant-folded");
STATISTIC(NumCompFolded, "Comparison expressions constant-folded");

using namespace mlir;
using namespace helix;

namespace {

/// Try to extract a constant integer value from a HelixMid expression.
/// Returns nullopt if the value is not a compile-time constant.
static std::optional<int64_t> getConstantValue(Value v) {
    auto* defOp = v.getDefiningOp();
    if (!defOp) return std::nullopt;

    // Check for arith.constant with integer value
    if (auto constOp = dyn_cast<arith::ConstantOp>(defOp)) {
        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
            return intAttr.getInt();
    }

    return std::nullopt;
}

/// Fold binary expressions where both operands are constants.
struct BinExprConstantFold
    : public OpRewritePattern<helix::mid::BinExprOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(helix::mid::BinExprOp op,
                                  PatternRewriter& rewriter) const override {
        // Guard: only fold if BOTH operands AND result are integer-typed.
        // Pointer-typed BinExprOps from Remill LEA/address arithmetic must
        // not be constant-folded (crashes the greedy rewriter).
        if (!isa<IntegerType>(op.getLhs().getType()) ||
            !isa<IntegerType>(op.getRhs().getType()) ||
            !isa<IntegerType>(op.getResult().getType()))
            return failure();

        auto lhsConst = getConstantValue(op.getLhs());
        auto rhsConst = getConstantValue(op.getRhs());

        if (!lhsConst || !rhsConst)
            return failure();

        int64_t lhs = *lhsConst;
        int64_t rhs = *rhsConst;
        int64_t result;
        bool isComparison = false;
        unsigned operandWidth =
            cast<IntegerType>(op.getLhs().getType()).getWidth();
        if (operandWidth > 64)
            return failure();
        llvm::APInt lhsBits(operandWidth, static_cast<uint64_t>(lhs));
        llvm::APInt rhsBits(operandWidth, static_cast<uint64_t>(rhs));

        auto kind = op.getKind();
        using K = helix::mid::BinExprKind;

        switch (kind) {
        case K::Add:    result = (lhsBits + rhsBits).getSExtValue(); break;
        case K::Sub:    result = (lhsBits - rhsBits).getSExtValue(); break;
        case K::Mul:
        case K::UMul:
        case K::SMul:
            result = (lhsBits * rhsBits).getSExtValue();
            break;
        case K::Div:
        case K::SDiv: {
            if (rhsBits.isZero()) return failure();
            bool overflow = false;
            auto quotient = lhsBits.sdiv_ov(rhsBits, overflow);
            if (overflow) return failure();
            result = quotient.getSExtValue();
            break;
        }
        case K::UDiv:
            if (rhsBits.isZero()) return failure();
            result = lhsBits.udiv(rhsBits).getSExtValue();
            break;
        case K::Mod:
            if (rhsBits.isZero()) return failure();
            result = lhsBits.srem(rhsBits).getSExtValue();
            break;
        case K::Shl:
        case K::Shr:
        case K::Sar:
            if (rhs < 0 || static_cast<uint64_t>(rhs) >= operandWidth)
                return failure();
            if (kind == K::Shl)
                result = lhsBits.shl(static_cast<unsigned>(rhs)).getSExtValue();
            else if (kind == K::Shr)
                result = lhsBits.lshr(static_cast<unsigned>(rhs)).getSExtValue();
            else
                result = lhsBits.ashr(static_cast<unsigned>(rhs)).getSExtValue();
            break;
        case K::BitAnd: result = (lhsBits & rhsBits).getSExtValue(); break;
        case K::BitOr:  result = (lhsBits | rhsBits).getSExtValue(); break;
        case K::BitXor: result = (lhsBits ^ rhsBits).getSExtValue(); break;

        // Comparison operators → bool (0 or 1)
        case K::Eq:  result = (lhsBits == rhsBits) ? 1 : 0; isComparison = true; break;
        case K::Ne:  result = (lhsBits != rhsBits) ? 1 : 0; isComparison = true; break;
        case K::Lt:  result = lhsBits.slt(rhsBits) ? 1 : 0; isComparison = true; break;
        case K::Le:  result = lhsBits.sle(rhsBits) ? 1 : 0; isComparison = true; break;
        case K::Gt:  result = lhsBits.sgt(rhsBits) ? 1 : 0; isComparison = true; break;
        case K::Ge:  result = lhsBits.sge(rhsBits) ? 1 : 0; isComparison = true; break;
        case K::Ult: result = lhsBits.ult(rhsBits) ? 1 : 0; isComparison = true; break;
        case K::Ule: result = lhsBits.ule(rhsBits) ? 1 : 0; isComparison = true; break;
        case K::Ugt: result = lhsBits.ugt(rhsBits) ? 1 : 0; isComparison = true; break;
        case K::Uge: result = lhsBits.uge(rhsBits) ? 1 : 0; isComparison = true; break;
        case K::LogAnd: result = (lhs != 0 && rhs != 0) ? 1 : 0; break;
        case K::LogOr:  result = (lhs != 0 || rhs != 0) ? 1 : 0; break;

        default:
            return failure();
        }

        // Replace the binexpr with a constant
        auto resultType = op.getResult().getType();

        // Guard: only fold if the result type is a standard integer type.
        // Remill IR can produce BinExprOps with pointer or custom types
        // that don't support getIntegerAttr.
        if (!isa<IntegerType>(resultType))
            return failure();

        auto intAttr = rewriter.getIntegerAttr(resultType, result);
        auto constOp = rewriter.create<arith::ConstantOp>(
            op.getLoc(), intAttr);
        rewriter.replaceOp(op, constOp.getResult());

        if (isComparison)
            ++NumCompFolded;
        else
            ++NumArithFolded;

        return success();
    }
};

/// Fold comparison of a value with itself.
/// Eq(x, x) → true, Ne(x, x) → false, Lt(x, x) → false, Le(x, x) → true
struct SelfComparisonFold
    : public OpRewritePattern<helix::mid::BinExprOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(helix::mid::BinExprOp op,
                                  PatternRewriter& rewriter) const override {
        if (op.getLhs() != op.getRhs())
            return failure();

        // Guard: only fold integer-typed operands and results
        if (!isa<IntegerType>(op.getLhs().getType()) ||
            !isa<IntegerType>(op.getResult().getType()))
            return failure();

        int64_t result;
        using K = helix::mid::BinExprKind;

        switch (op.getKind()) {
        case K::Eq:  result = 1; break; // x == x → true
        case K::Ne:  result = 0; break; // x != x → false
        case K::Lt:  result = 0; break; // x < x → false
        case K::Le:  result = 1; break; // x <= x → true
        case K::Gt:  result = 0; break; // x > x → false
        case K::Ge:  result = 1; break; // x >= x → true
        case K::Ult: result = 0; break;
        case K::Ule: result = 1; break;
        case K::Ugt: result = 0; break;
        case K::Uge: result = 1; break;
        default: return failure();
        }

        auto resultType = op.getResult().getType();
        if (!isa<IntegerType>(resultType))
            return failure();
        auto intAttr = rewriter.getIntegerAttr(resultType, result);
        auto constOp = rewriter.create<arith::ConstantOp>(
            op.getLoc(), intAttr);
        rewriter.replaceOp(op, constOp.getResult());
        ++NumCompFolded;
        return success();
    }
};

} // anonymous namespace

void helix::populateHelixMidConstantFoldPatterns(
    mlir::RewritePatternSet& patterns) {
    patterns.add<BinExprConstantFold, SelfComparisonFold>(
        patterns.getContext());
}
