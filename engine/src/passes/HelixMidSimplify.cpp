/// @file HelixMidSimplify.cpp
/// @brief MLIR pass: greedy pattern-based simplification of HelixMid dialect ops.
///
/// Collects all HelixMid rewrite patterns (arithmetic identities, redundant
/// cast removal, constant folding) and applies them using MLIR's greedy
/// pattern rewriter until a fixed point is reached.

#include "helix/passes/Passes.h"
#include "helix/passes/Patterns.h"
#include "helix/dialects/HelixMidOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "helix-mid-simplify"

using namespace mlir;
using namespace helix;

namespace {

// ── Inline pattern implementations for safe manual application ──────────
// These duplicate the logic from ArithPatterns/CastPatterns/ConstantFoldPatterns
// but are called directly via IRRewriter, bypassing applyPatternsAndFoldGreedily
// which crashes on pointer-typed ops due to MLIR's internal fold() calls.

/// Try to simplify a mid::BinExprOp in-place. Returns true if changed.
static bool trySimplifyBinExpr(mid::BinExprOp op, IRRewriter &rewriter) {
    auto resultType = op.getResult().getType();
    if (!isa<IntegerType>(resultType))
        return false;

    auto loc = op.getLoc();
    auto lhs = op.getLhs();
    auto rhs = op.getRhs();
    auto kind = op.getKind();

    // Guard: operands must be integer-typed too
    if (!isa<IntegerType>(lhs.getType()) || !isa<IntegerType>(rhs.getType()))
        return false;

    // SUB x, x → 0
    if (kind == mid::BinExprKind::Sub && lhs == rhs) {
        rewriter.setInsertionPoint(op);
        auto zero = rewriter.create<mid::ConstantOp>(
            loc, resultType, rewriter.getIntegerAttr(resultType, 0), IntegerAttr{});
        rewriter.replaceOp(op, zero.getResult());
        return true;
    }

    // Helper: extract constant from mid::ConstantOp
    auto getConst = [](Value v) -> std::optional<int64_t> {
        if (auto c = v.getDefiningOp<mid::ConstantOp>())
            return c.getValue();
        if (auto c = v.getDefiningOp<arith::ConstantOp>())
            if (auto intAttr = dyn_cast<IntegerAttr>(c.getValue()))
                return intAttr.getInt();
        return std::nullopt;
    };

    auto rhsConst = getConst(rhs);
    auto lhsConst = getConst(lhs);

    // ADD x, 0 → x
    if (kind == mid::BinExprKind::Add && rhsConst && *rhsConst == 0) {
        rewriter.replaceOp(op, lhs);
        return true;
    }

    // MUL x, 1 → x
    if (kind == mid::BinExprKind::Mul && rhsConst && *rhsConst == 1) {
        rewriter.replaceOp(op, lhs);
        return true;
    }

    // MUL x, 0 → 0
    if (kind == mid::BinExprKind::Mul && rhsConst && *rhsConst == 0) {
        rewriter.setInsertionPoint(op);
        auto zero = rewriter.create<mid::ConstantOp>(
            loc, resultType, rewriter.getIntegerAttr(resultType, 0), IntegerAttr{});
        rewriter.replaceOp(op, zero.getResult());
        return true;
    }

    // Constant fold: both operands constant
    if (lhsConst && rhsConst) {
        int64_t l = *lhsConst, r = *rhsConst, result;
        using K = mid::BinExprKind;
        switch (kind) {
        case K::Add:    result = l + r; break;
        case K::Sub:    result = l - r; break;
        case K::Mul:    result = l * r; break;
        case K::Div:    if (r == 0) return false; result = l / r; break;
        case K::Mod:    if (r == 0) return false; result = l % r; break;
        case K::Shl:    if (r < 0 || r >= 64) return false; result = l << r; break;
        case K::Shr:    if (r < 0 || r >= 64) return false;
                        result = static_cast<int64_t>(static_cast<uint64_t>(l) >> r); break;
        case K::Sar:    if (r < 0 || r >= 64) return false; result = l >> r; break;
        case K::BitAnd: result = l & r; break;
        case K::BitOr:  result = l | r; break;
        case K::BitXor: result = l ^ r; break;
        case K::Eq:     result = (l == r) ? 1 : 0; break;
        case K::Ne:     result = (l != r) ? 1 : 0; break;
        case K::Lt:     result = (l < r)  ? 1 : 0; break;
        case K::Le:     result = (l <= r) ? 1 : 0; break;
        case K::Gt:     result = (l > r)  ? 1 : 0; break;
        case K::Ge:     result = (l >= r) ? 1 : 0; break;
        default: return false;
        }
        rewriter.setInsertionPoint(op);
        auto c = rewriter.create<arith::ConstantOp>(
            loc, rewriter.getIntegerAttr(resultType, result));
        rewriter.replaceOp(op, c.getResult());
        return true;
    }

    // Self-comparison fold
    if (lhs == rhs) {
        using K = mid::BinExprKind;
        int64_t result;
        switch (kind) {
        case K::Eq:  result = 1; break;
        case K::Ne:  result = 0; break;
        case K::Lt:  result = 0; break;
        case K::Le:  result = 1; break;
        case K::Gt:  result = 0; break;
        case K::Ge:  result = 1; break;
        default: return false;
        }
        rewriter.setInsertionPoint(op);
        auto c = rewriter.create<arith::ConstantOp>(
            loc, rewriter.getIntegerAttr(resultType, result));
        rewriter.replaceOp(op, c.getResult());
        return true;
    }

    // ── DoubleShift: (x << a) << b → x << (a+b), same for >>/>>> ────────
    // If the current op is a shift and its LHS is the same kind of shift,
    // and both shift amounts are constants whose sum < 64, combine them.
    {
        using K = mid::BinExprKind;
        if ((kind == K::Shl || kind == K::Shr || kind == K::Sar) && rhsConst) {
            if (auto innerShift = lhs.getDefiningOp<mid::BinExprOp>()) {
                if (innerShift.getKind() == kind) {
                    auto innerRhsConst = getConst(innerShift.getRhs());
                    if (innerRhsConst) {
                        int64_t sum = *innerRhsConst + *rhsConst;
                        if (sum >= 0 && sum < 64) {
                            rewriter.setInsertionPoint(op);
                            auto combined = rewriter.create<mid::ConstantOp>(
                                loc, resultType,
                                rewriter.getIntegerAttr(resultType, sum),
                                IntegerAttr{});
                            auto newShift = rewriter.create<mid::BinExprOp>(
                                loc, resultType,
                                mid::BinExprKindAttr::get(
                                    rewriter.getContext(), kind),
                                innerShift.getLhs(), combined.getResult(),
                                /*address=*/IntegerAttr{});
                            rewriter.replaceOp(op, newShift.getResult());
                            return true;
                        }
                    }
                }
            }
        }
    }

    // ── DoubleSub: a - (b - c) → (a + c) - b ───────────────────────────
    // If we have Sub and the RHS is itself a Sub, rewrite to expose
    // additive structure for downstream folding.
    if (kind == mid::BinExprKind::Sub) {
        if (auto innerSub = rhs.getDefiningOp<mid::BinExprOp>()) {
            if (innerSub.getKind() == mid::BinExprKind::Sub) {
                if (!isa<IntegerType>(innerSub.getLhs().getType()) ||
                    !isa<IntegerType>(innerSub.getRhs().getType()))
                    return false;
                rewriter.setInsertionPoint(op);
                // a + c
                auto addOp = rewriter.create<mid::BinExprOp>(
                    loc, resultType,
                    mid::BinExprKindAttr::get(
                        rewriter.getContext(), mid::BinExprKind::Add),
                    lhs, innerSub.getRhs(),
                    /*address=*/IntegerAttr{});
                // (a + c) - b
                auto subOp = rewriter.create<mid::BinExprOp>(
                    loc, resultType,
                    mid::BinExprKindAttr::get(
                        rewriter.getContext(), mid::BinExprKind::Sub),
                    addOp.getResult(), innerSub.getLhs(),
                    /*address=*/IntegerAttr{});
                rewriter.replaceOp(op, subOp.getResult());
                return true;
            }
        }
    }

    // ── AndDistribute: (a & c) | (b & c) → (a | b) & c ─────────────────
    // Factor a common operand out of two BitAnd ops feeding a BitOr.
    if (kind == mid::BinExprKind::BitOr) {
        auto lhsAnd = lhs.getDefiningOp<mid::BinExprOp>();
        auto rhsAnd = rhs.getDefiningOp<mid::BinExprOp>();
        if (lhsAnd && rhsAnd &&
            lhsAnd.getKind() == mid::BinExprKind::BitAnd &&
            rhsAnd.getKind() == mid::BinExprKind::BitAnd) {
            // Check all four pairings for a shared operand
            Value common, a, b;
            if (lhsAnd.getRhs() == rhsAnd.getRhs()) {
                common = lhsAnd.getRhs();
                a = lhsAnd.getLhs(); b = rhsAnd.getLhs();
            } else if (lhsAnd.getLhs() == rhsAnd.getLhs()) {
                common = lhsAnd.getLhs();
                a = lhsAnd.getRhs(); b = rhsAnd.getRhs();
            } else if (lhsAnd.getLhs() == rhsAnd.getRhs()) {
                common = lhsAnd.getLhs();
                a = lhsAnd.getRhs(); b = rhsAnd.getLhs();
            } else if (lhsAnd.getRhs() == rhsAnd.getLhs()) {
                common = lhsAnd.getRhs();
                a = lhsAnd.getLhs(); b = rhsAnd.getRhs();
            }
            if (common && isa<IntegerType>(a.getType()) &&
                isa<IntegerType>(b.getType()) &&
                isa<IntegerType>(common.getType())) {
                rewriter.setInsertionPoint(op);
                // a | b
                auto orOp = rewriter.create<mid::BinExprOp>(
                    loc, resultType,
                    mid::BinExprKindAttr::get(
                        rewriter.getContext(), mid::BinExprKind::BitOr),
                    a, b, /*address=*/IntegerAttr{});
                // (a | b) & c
                auto andOp = rewriter.create<mid::BinExprOp>(
                    loc, resultType,
                    mid::BinExprKindAttr::get(
                        rewriter.getContext(), mid::BinExprKind::BitAnd),
                    orOp.getResult(), common,
                    /*address=*/IntegerAttr{});
                rewriter.replaceOp(op, andOp.getResult());
                return true;
            }
        }
    }

    // ── Less2Zero: x < 0 → sign_bit(x) via x >> (bitwidth-1) ───────────
    if (kind == mid::BinExprKind::Lt && rhsConst && *rhsConst == 0) {
        if (!isa<IntegerType>(lhs.getType()))
            return false;
        unsigned bitWidth =
            cast<IntegerType>(lhs.getType()).getWidth();
        if (bitWidth == 0 || bitWidth > 64)
            return false;
        rewriter.setInsertionPoint(op);
        auto shamt = rewriter.create<mid::ConstantOp>(
            loc, lhs.getType(),
            rewriter.getIntegerAttr(lhs.getType(), bitWidth - 1),
            IntegerAttr{});
        auto shr = rewriter.create<mid::BinExprOp>(
            loc, lhs.getType(),
            mid::BinExprKindAttr::get(
                rewriter.getContext(), mid::BinExprKind::Sar),
            lhs, shamt.getResult(),
            /*address=*/IntegerAttr{});
        // Truncate/extend to result type if needed (result is i1 for cmp)
        Value result = shr.getResult();
        if (result.getType() != resultType)
            result = rewriter.create<mid::CastOp>(
                loc, resultType, result, IntegerAttr{}).getResult();
        rewriter.replaceOp(op, result);
        return true;
    }

    // ── EqualZero: x == 0 → !x  |  x != 0 → (bool)x ──────────────────
    if (rhsConst && *rhsConst == 0) {
        if (kind == mid::BinExprKind::Eq) {
            if (!isa<IntegerType>(lhs.getType()))
                return false;
            rewriter.setInsertionPoint(op);
            // !x
            auto logNot = rewriter.create<mid::UnExprOp>(
                loc, resultType,
                mid::UnExprKindAttr::get(
                    rewriter.getContext(), mid::UnExprKind::LogNot),
                lhs, /*address=*/IntegerAttr{});
            rewriter.replaceOp(op, logNot.getResult());
            return true;
        }
        if (kind == mid::BinExprKind::Ne) {
            if (!isa<IntegerType>(lhs.getType()))
                return false;
            rewriter.setInsertionPoint(op);
            // (bool)x — cast to result type (typically i1)
            if (lhs.getType() == resultType) {
                rewriter.replaceOp(op, lhs);
            } else {
                auto boolCast = rewriter.create<mid::CastOp>(
                    loc, resultType, lhs, IntegerAttr{});
                rewriter.replaceOp(op, boolCast.getResult());
            }
            return true;
        }
    }

    return false;
}

/// Try to simplify a mid::UnExprOp in-place. Returns true if changed.
/// Currently handles De Morgan's laws for LogNot over BitAnd / BitOr.
static bool trySimplifyUnExpr(mid::UnExprOp op, IRRewriter &rewriter) {
    auto resultType = op.getResult().getType();
    if (!isa<IntegerType>(resultType))
        return false;

    // ── NotDistribute (De Morgan): !(a & b) → !a | !b
    //                                !(a | b) → !a & !b ─────────────────
    if (op.getKind() == mid::UnExprKind::LogNot) {
        auto inner = op.getOperand().getDefiningOp<mid::BinExprOp>();
        if (!inner)
            return false;

        auto innerKind = inner.getKind();
        mid::BinExprKind newBinKind;
        if (innerKind == mid::BinExprKind::BitAnd)
            newBinKind = mid::BinExprKind::BitOr;
        else if (innerKind == mid::BinExprKind::BitOr)
            newBinKind = mid::BinExprKind::BitAnd;
        else
            return false;

        auto innerLhs = inner.getLhs();
        auto innerRhs = inner.getRhs();
        if (!isa<IntegerType>(innerLhs.getType()) ||
            !isa<IntegerType>(innerRhs.getType()))
            return false;

        auto loc = op.getLoc();
        rewriter.setInsertionPoint(op);

        // !a
        auto notA = rewriter.create<mid::UnExprOp>(
            loc, resultType,
            mid::UnExprKindAttr::get(
                rewriter.getContext(), mid::UnExprKind::LogNot),
            innerLhs, /*address=*/IntegerAttr{});
        // !b
        auto notB = rewriter.create<mid::UnExprOp>(
            loc, resultType,
            mid::UnExprKindAttr::get(
                rewriter.getContext(), mid::UnExprKind::LogNot),
            innerRhs, /*address=*/IntegerAttr{});
        // !a <op> !b
        auto combined = rewriter.create<mid::BinExprOp>(
            loc, resultType,
            mid::BinExprKindAttr::get(rewriter.getContext(), newBinKind),
            notA.getResult(), notB.getResult(),
            /*address=*/IntegerAttr{});

        rewriter.replaceOp(op, combined.getResult());
        return true;
    }

    return false;
}

/// Try to simplify a mid::CastOp in-place. Returns true if changed.
static bool trySimplifyCast(mid::CastOp op, IRRewriter &rewriter) {
    // Cast to same type → remove
    if (op.getOperand().getType() == op.getResult().getType()) {
        rewriter.replaceOp(op, op.getOperand());
        return true;
    }
    // Double cast: cast(cast(x)) where outer restores original type
    if (auto inner = op.getOperand().getDefiningOp<mid::CastOp>()) {
        if (inner.getOperand().getType() == op.getResult().getType()) {
            rewriter.replaceOp(op, inner.getOperand());
            return true;
        }
    }
    return false;
}

struct HelixMidSimplifyPass
    : public PassWrapper<HelixMidSimplifyPass, OperationPass<ModuleOp>>
{
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(HelixMidSimplifyPass)

    StringRef getArgument() const final { return "helix-mid-simplify"; }
    StringRef getDescription() const final {
        return "Safe pattern-based simplification of HelixMid dialect ops";
    }

    void getDependentDialects(DialectRegistry &registry) const override {
        registry.insert<helix::mid::HelixMidDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();
        IRRewriter rewriter(&getContext());

        bool changed = true;
        unsigned iterations = 0;
        while (changed && iterations++ < 16) {
            changed = false;
            // Collect ops first to avoid iterator invalidation
            SmallVector<Operation*, 64> ops;
            module.walk([&](Operation *op) { ops.push_back(op); });

            for (auto *op : ops) {
                if (auto binExpr = dyn_cast<mid::BinExprOp>(op)) {
                    if (trySimplifyBinExpr(binExpr, rewriter))
                        changed = true;
                } else if (auto unExpr = dyn_cast<mid::UnExprOp>(op)) {
                    if (trySimplifyUnExpr(unExpr, rewriter))
                        changed = true;
                } else if (auto cast = dyn_cast<mid::CastOp>(op)) {
                    if (trySimplifyCast(cast, rewriter))
                        changed = true;
                }
            }
        }
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createHelixMidSimplifyPass() {
    return std::make_unique<HelixMidSimplifyPass>();
}
