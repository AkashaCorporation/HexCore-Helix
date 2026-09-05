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

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/Hashing.h"
#include "llvm/ADT/APInt.h"
#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "helix-mid-simplify"

using namespace mlir;
using namespace helix;

namespace {

static IntegerAttr getSI64Attr(Builder& rewriter, int64_t value) {
    auto type = IntegerType::get(
        rewriter.getContext(), 64, IntegerType::Signed);
    return IntegerAttr::get(type, llvm::APInt(64, value, true));
}

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
            loc, resultType, getSI64Attr(rewriter, 0), IntegerAttr{});
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

    // Helper: check whether a value is a compile-time constant
    auto isConst = [&](Value v) -> bool { return getConst(v).has_value(); };

    // ── RuleTermOrder: canonicalize constants to RHS for commutative ops ──
    // Ghidra's RuleTermOrder: if LHS is constant and RHS is not, swap them
    // so that downstream patterns only need to check RHS for constants.
    {
        using K = mid::BinExprKind;
        if ((kind == K::Add || kind == K::Mul ||
             kind == K::BitAnd || kind == K::BitOr || kind == K::BitXor) &&
            isConst(lhs) && !isConst(rhs)) {
            rewriter.setInsertionPoint(op);
            auto swapped = rewriter.create<mid::BinExprOp>(
                loc, resultType,
                mid::BinExprKindAttr::get(rewriter.getContext(), kind),
                rhs, lhs, /*address=*/IntegerAttr{});
            rewriter.replaceOp(op, swapped.getResult());
            return true;
        }
    }

    auto rhsConst = getConst(rhs);
    auto lhsConst = getConst(lhs);

    // ADD x, 0 → x
    if (kind == mid::BinExprKind::Add && rhsConst && *rhsConst == 0) {
        rewriter.replaceOp(op, lhs);
        return true;
    }

    const bool isMul = kind == mid::BinExprKind::Mul ||
                       kind == mid::BinExprKind::UMul ||
                       kind == mid::BinExprKind::SMul;

    // MUL x, 1 → x
    if (isMul && rhsConst && *rhsConst == 1) {
        rewriter.replaceOp(op, lhs);
        return true;
    }

    // MUL x, 0 → 0
    if (isMul && rhsConst && *rhsConst == 0) {
        rewriter.setInsertionPoint(op);
        auto zero = rewriter.create<mid::ConstantOp>(
            loc, resultType, getSI64Attr(rewriter, 0), IntegerAttr{});
        rewriter.replaceOp(op, zero.getResult());
        return true;
    }

    // Constant fold: both operands constant
    if (lhsConst && rhsConst) {
        int64_t l = *lhsConst, r = *rhsConst;
        unsigned operandWidth =
            cast<IntegerType>(lhs.getType()).getWidth();
        if (operandWidth > 64)
            return false;
        llvm::APInt lhsBits(operandWidth, static_cast<uint64_t>(l));
        llvm::APInt rhsBits(operandWidth, static_cast<uint64_t>(r));
        llvm::APInt resultBits(operandWidth, 0);
        using K = mid::BinExprKind;
        switch (kind) {
        case K::Add:    resultBits = lhsBits + rhsBits; break;
        case K::Sub:    resultBits = lhsBits - rhsBits; break;
        case K::Mul:
        case K::UMul:
        case K::SMul:   resultBits = lhsBits * rhsBits; break;
        case K::Div:
        case K::SDiv: {
            if (rhsBits.isZero()) return false;
            bool overflow = false;
            resultBits = lhsBits.sdiv_ov(rhsBits, overflow);
            if (overflow) return false;
            break;
        }
        case K::UDiv:
            if (rhsBits.isZero()) return false;
            resultBits = lhsBits.udiv(rhsBits);
            break;
        case K::Mod:
            if (rhsBits.isZero()) return false;
            resultBits = lhsBits.srem(rhsBits);
            break;
        case K::Shl:    if (r < 0 || static_cast<uint64_t>(r) >= operandWidth) return false;
                        resultBits = lhsBits.shl(static_cast<unsigned>(r)); break;
        case K::Shr:    if (r < 0 || static_cast<uint64_t>(r) >= operandWidth) return false;
                        resultBits = lhsBits.lshr(static_cast<unsigned>(r)); break;
        case K::Sar:    if (r < 0 || static_cast<uint64_t>(r) >= operandWidth) return false;
                        resultBits = lhsBits.ashr(static_cast<unsigned>(r)); break;
        case K::BitAnd: resultBits = lhsBits & rhsBits; break;
        case K::BitOr:  resultBits = lhsBits | rhsBits; break;
        case K::BitXor: resultBits = lhsBits ^ rhsBits; break;
        case K::Eq:     resultBits = llvm::APInt(operandWidth, lhsBits == rhsBits); break;
        case K::Ne:     resultBits = llvm::APInt(operandWidth, lhsBits != rhsBits); break;
        case K::Lt:     resultBits = llvm::APInt(operandWidth, lhsBits.slt(rhsBits)); break;
        case K::Le:     resultBits = llvm::APInt(operandWidth, lhsBits.sle(rhsBits)); break;
        case K::Gt:     resultBits = llvm::APInt(operandWidth, lhsBits.sgt(rhsBits)); break;
        case K::Ge:     resultBits = llvm::APInt(operandWidth, lhsBits.sge(rhsBits)); break;
        case K::Ult:    resultBits = llvm::APInt(operandWidth, lhsBits.ult(rhsBits)); break;
        case K::Ule:    resultBits = llvm::APInt(operandWidth, lhsBits.ule(rhsBits)); break;
        case K::Ugt:    resultBits = llvm::APInt(operandWidth, lhsBits.ugt(rhsBits)); break;
        case K::Uge:    resultBits = llvm::APInt(operandWidth, lhsBits.uge(rhsBits)); break;
        case K::LogAnd: resultBits = llvm::APInt(operandWidth, l != 0 && r != 0); break;
        case K::LogOr:  resultBits = llvm::APInt(operandWidth, l != 0 || r != 0); break;
        default: return false;
        }
        rewriter.setInsertionPoint(op);
        unsigned resultWidth = cast<IntegerType>(resultType).getWidth();
        resultBits = resultBits.sextOrTrunc(resultWidth);
        auto c = rewriter.create<arith::ConstantOp>(
            loc, rewriter.getIntegerAttr(resultType, resultBits));
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
        case K::Ult: result = 0; break;
        case K::Ule: result = 1; break;
        case K::Ugt: result = 0; break;
        case K::Uge: result = 1; break;
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
                                getSI64Attr(rewriter, sum),
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
            getSI64Attr(rewriter, bitWidth - 1),
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
                loc, resultType, result, IntegerAttr{},
                mid::CastKindAttr{}).getResult();
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
                    loc, resultType, lhs, IntegerAttr{},
                    mid::CastKindAttr{});
                rewriter.replaceOp(op, boolCast.getResult());
            }
            return true;
        }
    }

    // ── RuleShiftBitops: (x & mask) >> n → (x >> n) & (mask >> n) ────────
    // When the LHS of a logical shift-right is a BitAnd with a constant mask
    // and the shift amount is also constant, push the shift through the and.
    // This exposes simpler masks for downstream patterns.
    if ((kind == mid::BinExprKind::Shr || kind == mid::BinExprKind::Sar) &&
        rhsConst) {
        if (auto innerAnd = lhs.getDefiningOp<mid::BinExprOp>()) {
            if (innerAnd.getKind() == mid::BinExprKind::BitAnd) {
                auto maskConst = getConst(innerAnd.getRhs());
                if (maskConst &&
                    isa<IntegerType>(innerAnd.getLhs().getType()) &&
                    isa<IntegerType>(innerAnd.getRhs().getType())) {
                    int64_t n = *rhsConst;
                    if (n >= 0 && n < 64) {
                        int64_t newMask = static_cast<int64_t>(
                            static_cast<uint64_t>(*maskConst) >> n);
                        rewriter.setInsertionPoint(op);
                        // x >> n
                        auto shiftedX = rewriter.create<mid::BinExprOp>(
                            loc, resultType,
                            mid::BinExprKindAttr::get(
                                rewriter.getContext(), kind),
                            innerAnd.getLhs(), rhs,
                            /*address=*/IntegerAttr{});
                        // mask >> n (folded constant)
                        auto newMaskOp = rewriter.create<mid::ConstantOp>(
                            loc, resultType,
                            getSI64Attr(rewriter, newMask),
                            IntegerAttr{});
                        // (x >> n) & (mask >> n)
                        auto newAnd = rewriter.create<mid::BinExprOp>(
                            loc, resultType,
                            mid::BinExprKindAttr::get(
                                rewriter.getContext(),
                                mid::BinExprKind::BitAnd),
                            shiftedX.getResult(), newMaskOp.getResult(),
                            /*address=*/IntegerAttr{});
                        rewriter.replaceOp(op, newAnd.getResult());
                        return true;
                    }
                }
            }
        }
    }

    // ── RuleAddMultCollapse: (a * n) + (b * n) → (a + b) * n ────────────
    // If both operands of an Add are Mul with the same RHS constant, factor
    // the common multiplier out.
    if (kind == mid::BinExprKind::Add) {
        auto lhsMul = lhs.getDefiningOp<mid::BinExprOp>();
        auto rhsMul = rhs.getDefiningOp<mid::BinExprOp>();
        if (lhsMul && rhsMul &&
            lhsMul.getKind() == mid::BinExprKind::Mul &&
            rhsMul.getKind() == mid::BinExprKind::Mul) {
            auto lhsMulConst = getConst(lhsMul.getRhs());
            auto rhsMulConst = getConst(rhsMul.getRhs());
            if (lhsMulConst && rhsMulConst && *lhsMulConst == *rhsMulConst) {
                auto a = lhsMul.getLhs();
                auto b = rhsMul.getLhs();
                if (isa<IntegerType>(a.getType()) &&
                    isa<IntegerType>(b.getType())) {
                    rewriter.setInsertionPoint(op);
                    // a + b
                    auto addOp = rewriter.create<mid::BinExprOp>(
                        loc, resultType,
                        mid::BinExprKindAttr::get(
                            rewriter.getContext(), mid::BinExprKind::Add),
                        a, b, /*address=*/IntegerAttr{});
                    // (a + b) * n
                    auto nOp = rewriter.create<mid::ConstantOp>(
                        loc, resultType,
                        getSI64Attr(rewriter, *lhsMulConst),
                        IntegerAttr{});
                    auto mulOp = rewriter.create<mid::BinExprOp>(
                        loc, resultType,
                        mid::BinExprKindAttr::get(
                            rewriter.getContext(), mid::BinExprKind::Mul),
                        addOp.getResult(), nOp.getResult(),
                        /*address=*/IntegerAttr{});
                    rewriter.replaceOp(op, mulOp.getResult());
                    return true;
                }
            }
        }
    }

    // ── RuleEquality: (x - y) == 0 → x == y ────────────────────────────
    // If the LHS of an equality comparison is a Sub and RHS is 0, rewrite
    // as a direct comparison between the Sub operands.
    if (kind == mid::BinExprKind::Eq && rhsConst && *rhsConst == 0) {
        if (auto innerSub = lhs.getDefiningOp<mid::BinExprOp>()) {
            if (innerSub.getKind() == mid::BinExprKind::Sub) {
                auto subLhs = innerSub.getLhs();
                auto subRhs = innerSub.getRhs();
                if (isa<IntegerType>(subLhs.getType()) &&
                    isa<IntegerType>(subRhs.getType())) {
                    rewriter.setInsertionPoint(op);
                    auto eqOp = rewriter.create<mid::BinExprOp>(
                        loc, resultType,
                        mid::BinExprKindAttr::get(
                            rewriter.getContext(), mid::BinExprKind::Eq),
                        subLhs, subRhs, /*address=*/IntegerAttr{});
                    rewriter.replaceOp(op, eqOp.getResult());
                    return true;
                }
            }
        }
    }

    // ── RuleShiftCompare: (x >> n) & 1 == 0 → !(x & (1 << n)) ─────────
    // Recognizes the bit-test idiom: an Eq with RHS=0 where LHS is a
    // BitAnd of a shifted value and the constant 1, then rewrites as a
    // logical-not of a direct bit-test mask.
    if (kind == mid::BinExprKind::Eq && rhsConst && *rhsConst == 0) {
        if (auto andOp = lhs.getDefiningOp<mid::BinExprOp>()) {
            if (andOp.getKind() == mid::BinExprKind::BitAnd) {
                auto andRhsConst = getConst(andOp.getRhs());
                if (andRhsConst && *andRhsConst == 1) {
                    auto andLhs = andOp.getLhs();
                    if (auto shrOp = andLhs.getDefiningOp<mid::BinExprOp>()) {
                        if ((shrOp.getKind() == mid::BinExprKind::Shr ||
                             shrOp.getKind() == mid::BinExprKind::Sar) &&
                            isa<IntegerType>(shrOp.getLhs().getType())) {
                            auto shiftConst = getConst(shrOp.getRhs());
                            if (shiftConst && *shiftConst >= 0 &&
                                *shiftConst < 64) {
                                int64_t mask = int64_t(1) << *shiftConst;
                                rewriter.setInsertionPoint(op);
                                auto x = shrOp.getLhs();
                                auto maskOp =
                                    rewriter.create<mid::ConstantOp>(
                                        loc, x.getType(),
                                        getSI64Attr(rewriter, mask),
                                        IntegerAttr{});
                                // x & (1 << n)
                                auto bitTest =
                                    rewriter.create<mid::BinExprOp>(
                                        loc, x.getType(),
                                        mid::BinExprKindAttr::get(
                                            rewriter.getContext(),
                                            mid::BinExprKind::BitAnd),
                                        x, maskOp.getResult(),
                                        /*address=*/IntegerAttr{});
                                // !(x & (1 << n))
                                Value bitTestVal = bitTest.getResult();
                                if (bitTestVal.getType() != resultType)
                                    bitTestVal =
                                        rewriter
                                            .create<mid::CastOp>(
                                                loc, resultType,
                                                bitTestVal, IntegerAttr{},
                                                mid::CastKindAttr{})
                                            .getResult();
                                auto logNot =
                                    rewriter.create<mid::UnExprOp>(
                                        loc, resultType,
                                        mid::UnExprKindAttr::get(
                                            rewriter.getContext(),
                                            mid::UnExprKind::LogNot),
                                        bitTestVal,
                                        /*address=*/IntegerAttr{});
                                rewriter.replaceOp(op,
                                                   logNot.getResult());
                                return true;
                            }
                        }
                    }
                }
            }
        }
    }

    // ── RuleMulNegOne: x * -1 → -x (Neg) ───────────────────────────────
    // Replace multiplication by -1 with unary negation, which is cheaper
    // and more readable in decompiled output.
    if (isMul && rhsConst && *rhsConst == -1) {
        if (!isa<IntegerType>(lhs.getType()))
            return false;
        rewriter.setInsertionPoint(op);
        auto neg = rewriter.create<mid::UnExprOp>(
            loc, resultType,
            mid::UnExprKindAttr::get(
                rewriter.getContext(), mid::UnExprKind::Neg),
            lhs, /*address=*/IntegerAttr{});
        rewriter.replaceOp(op, neg.getResult());
        return true;
    }

    // ── RuleShift2Mult: x << n → x * (1 << n)  when n is small ─────────
    // Makes the multiplication explicit for readability in decompiled code.
    // Only applies when n is a small constant (0 < n < 32).
    if (kind == mid::BinExprKind::Shl && rhsConst &&
        *rhsConst > 0 && *rhsConst < 32) {
        if (!isa<IntegerType>(lhs.getType()))
            return false;
        int64_t multiplier = int64_t(1) << *rhsConst;
        rewriter.setInsertionPoint(op);
        auto mulConst = rewriter.create<mid::ConstantOp>(
            loc, resultType,
            getSI64Attr(rewriter, multiplier),
            IntegerAttr{});
        auto mulOp = rewriter.create<mid::BinExprOp>(
            loc, resultType,
            mid::BinExprKindAttr::get(
                rewriter.getContext(), mid::BinExprKind::Mul),
            lhs, mulConst.getResult(),
            /*address=*/IntegerAttr{});
        rewriter.replaceOp(op, mulOp.getResult());
        return true;
    }

    // ── RuleSub2Add: a - (-b) → a + b ──────────────────────────────────
    // If the RHS of a Sub is a unary Neg, rewrite as addition. This
    // simplifies the expression and may enable further folding.
    if (kind == mid::BinExprKind::Sub) {
        if (auto negOp = rhs.getDefiningOp<mid::UnExprOp>()) {
            if (negOp.getKind() == mid::UnExprKind::Neg) {
                auto innerVal = negOp.getOperand();
                if (isa<IntegerType>(innerVal.getType())) {
                    rewriter.setInsertionPoint(op);
                    auto addOp = rewriter.create<mid::BinExprOp>(
                        loc, resultType,
                        mid::BinExprKindAttr::get(
                            rewriter.getContext(), mid::BinExprKind::Add),
                        lhs, innerVal, /*address=*/IntegerAttr{});
                    rewriter.replaceOp(op, addOp.getResult());
                    return true;
                }
            }
        }
    }

    return false;
}

/// Try to simplify a mid::UnExprOp in-place. Returns true if changed.
/// Handles double negation and De Morgan's laws for logical conjunctions.
static bool trySimplifyUnExpr(mid::UnExprOp op, IRRewriter &rewriter) {
    auto resultType = op.getResult().getType();
    if (!isa<IntegerType>(resultType))
        return false;

    // ── RuleNegateIdentity: -(-x) → x ──────────────────────────────────
    // Double negation on Neg cancels out.
    if (op.getKind() == mid::UnExprKind::Neg) {
        if (auto innerNeg = op.getOperand().getDefiningOp<mid::UnExprOp>()) {
            if (innerNeg.getKind() == mid::UnExprKind::Neg) {
                auto innerVal = innerNeg.getOperand();
                if (!isa<IntegerType>(innerVal.getType()))
                    return false;
                // If the inner value has the same type as result, use directly
                if (innerVal.getType() == resultType) {
                    rewriter.replaceOp(op, innerVal);
                } else {
                    rewriter.setInsertionPoint(op);
                    auto cast = rewriter.create<mid::CastOp>(
                        op.getLoc(), resultType, innerVal, IntegerAttr{},
                        mid::CastKindAttr{});
                    rewriter.replaceOp(op, cast.getResult());
                }
                return true;
            }
        }
    }

    // ── NotDistribute (De Morgan): !(a && b) → !a || !b
    //                                !(a || b) → !a && !b ───────────────
    // Never apply this to BitAnd/BitOr: `!(x & 8)` is a bit-mask test and is
    // not equivalent to `!x | !8` for multi-bit integers.
    if (op.getKind() == mid::UnExprKind::LogNot) {
        if (!resultType.isInteger(1))
            return false;
        auto inner = op.getOperand().getDefiningOp<mid::BinExprOp>();
        if (!inner)
            return false;

        auto innerKind = inner.getKind();
        mid::BinExprKind newBinKind;
        if (innerKind == mid::BinExprKind::LogAnd)
            newBinKind = mid::BinExprKind::LogOr;
        else if (innerKind == mid::BinExprKind::LogOr)
            newBinKind = mid::BinExprKind::LogAnd;
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
        const bool explicitBitcasts =
            op.getCastKind() == mid::CastKind::Bitcast &&
            inner.getCastKind() == mid::CastKind::Bitcast;
        if (explicitBitcasts &&
            inner.getOperand().getType() == op.getResult().getType()) {
            rewriter.replaceOp(op, inner.getOperand());
            return true;
        }
    }
    return false;
}

/// Try to simplify a mid::SelectOp in-place. Returns true if changed.
/// Handles three-way compare patterns from Ghidra's RuleThreeWayCompare.
static bool trySimplifySelect(mid::SelectOp op, IRRewriter &rewriter) {
    auto resultType = op.getResult().getType();
    if (!isa<IntegerType>(resultType))
        return false;

    // ── RuleThreeWayCompare ─────────────────────────────────────────────
    // Recognize: x < 0 ? a : (x == 0 ? b : c)
    //   → three-way branch on sign / zero / positive.
    //
    // When the false_val of an outer SelectOp is itself a SelectOp whose
    // condition tests the same variable for equality with zero, and the
    // outer condition tests that variable for less-than zero, we tag the
    // outer select with a "helix.three_way_cmp" unit attribute so later
    // passes (HelixMidToHigh, PseudoCEmitter) can emit cleaner output.
    auto outerCond = op.getCondition();
    auto outerCondBin = outerCond.getDefiningOp<mid::BinExprOp>();
    if (!outerCondBin)
        return false;

    // Outer condition must be "x < 0"
    if (outerCondBin.getKind() != mid::BinExprKind::Lt)
        return false;

    // Helper: extract constant from mid::ConstantOp or arith::ConstantOp
    auto getConst = [](Value v) -> std::optional<int64_t> {
        if (auto c = v.getDefiningOp<mid::ConstantOp>())
            return c.getValue();
        if (auto c = v.getDefiningOp<arith::ConstantOp>())
            if (auto intAttr = dyn_cast<IntegerAttr>(c.getValue()))
                return intAttr.getInt();
        return std::nullopt;
    };

    auto outerRhsConst = getConst(outerCondBin.getRhs());
    if (!outerRhsConst || *outerRhsConst != 0)
        return false;

    auto testedVar = outerCondBin.getLhs();
    if (!isa<IntegerType>(testedVar.getType()))
        return false;

    // false_val must be another SelectOp
    auto innerSelect = op.getFalseVal().getDefiningOp<mid::SelectOp>();
    if (!innerSelect)
        return false;

    auto innerCond = innerSelect.getCondition();
    auto innerCondBin = innerCond.getDefiningOp<mid::BinExprOp>();
    if (!innerCondBin)
        return false;

    // Inner condition must be "x == 0" on the same variable
    if (innerCondBin.getKind() != mid::BinExprKind::Eq)
        return false;
    auto innerRhsConst = getConst(innerCondBin.getRhs());
    if (!innerRhsConst || *innerRhsConst != 0)
        return false;
    if (innerCondBin.getLhs() != testedVar)
        return false;

    // Don't apply if we already tagged this op (avoid infinite loop)
    if (op->hasAttr("helix.three_way_cmp"))
        return false;

    // Tag the outer select so later passes can recognize the pattern.
    // We also flatten into a single select chain for cleaner IR:
    //   x < 0 ? a : (x == 0 ? b : c)
    // remains structurally the same but gets the annotation.
    op->setAttr("helix.three_way_cmp", rewriter.getUnitAttr());

    LLVM_DEBUG(llvm::dbgs() << "HelixMidSimplify: tagged three-way compare on "
                            << testedVar << "\n");
    return true;
}

// ── Local Common Subexpression Elimination (CSE) ────────────────────────────
// Per-block CSE: detects identical pure expressions within the same basic block
// and replaces duplicates with references to the first occurrence.
// Only CSEs operations with integer-typed results that have no side effects.

/// Compute a hash key for an operation suitable for CSE lookup.
/// Returns std::nullopt for operations that should not be CSE'd (side effects,
/// unsupported op type, non-integer result).
struct CSEKey {
    size_t hash;  // numeric hash for DenseMap keying (from llvm::hash_code)
    // Store enough info to do an equality check beyond hash collision
    StringRef opName;
    SmallVector<int64_t, 4> signature; // encoded operand identity + kind
};

static std::optional<CSEKey> computeCSEKey(Operation *op) {
    // Only CSE ops that produce exactly one result with integer type
    if (op->getNumResults() != 1)
        return std::nullopt;
    auto resultType = op->getResult(0).getType();
    if (!isa<IntegerType>(resultType))
        return std::nullopt;

    CSEKey key;
    key.opName = op->getName().getStringRef();

    if (auto binExpr = dyn_cast<mid::BinExprOp>(op)) {
        auto kind = static_cast<int64_t>(binExpr.getKind());
        int64_t semanticMode = 0;
        if (binExpr->hasAttr("helix.fixed_width_unsigned"))
            semanticMode |= 1;
        if (binExpr->hasAttr("helix.fixed_width_compare"))
            semanticMode |= 2;
        // Use the SSA Value's opaque pointer as identity for operands.
        // Two Values that are the same SSA def will have the same pointer.
        auto lhsId = static_cast<int64_t>(
            reinterpret_cast<uintptr_t>(binExpr.getLhs().getAsOpaquePointer()));
        auto rhsId = static_cast<int64_t>(
            reinterpret_cast<uintptr_t>(binExpr.getRhs().getAsOpaquePointer()));
        key.signature = {kind, lhsId, rhsId, semanticMode};
        key.hash = size_t(llvm::hash_combine(
            key.opName, kind, lhsId, rhsId, semanticMode));
        return key;
    }

    if (auto unExpr = dyn_cast<mid::UnExprOp>(op)) {
        auto kind = static_cast<int64_t>(unExpr.getKind());
        auto operandId = static_cast<int64_t>(
            reinterpret_cast<uintptr_t>(unExpr.getOperand().getAsOpaquePointer()));
        key.signature = {kind, operandId};
        key.hash = size_t(llvm::hash_combine(key.opName, kind, operandId));
        return key;
    }

    if (auto constOp = dyn_cast<mid::ConstantOp>(op)) {
        auto val = constOp.getValue();
        auto typeId = static_cast<int64_t>(
            reinterpret_cast<uintptr_t>(resultType.getAsOpaquePointer()));
        key.signature = {val, typeId};
        key.hash = size_t(llvm::hash_combine(key.opName, val, typeId));
        return key;
    }

    if (auto loadOp = dyn_cast<mid::LoadOp>(op)) {
        auto addrId = static_cast<int64_t>(
            reinterpret_cast<uintptr_t>(loadOp.getAddr().getAsOpaquePointer()));
        auto typeId = static_cast<int64_t>(
            reinterpret_cast<uintptr_t>(resultType.getAsOpaquePointer()));
        key.signature = {addrId, typeId};
        key.hash = size_t(llvm::hash_combine(key.opName, addrId, typeId));
        return key;
    }

    // Don't CSE: stores, calls, control flow, or anything else with side effects
    return std::nullopt;
}

/// Check if two CSEKeys represent the same expression.
static bool cseKeysEqual(const CSEKey &a, const CSEKey &b) {
    return a.hash == b.hash && a.opName == b.opName &&
           a.signature == b.signature;
}

/// Run local (per-block) CSE on a flat list of operations within one block.
/// Returns true if any operation was eliminated.
static bool tryEliminateCSE(Block &block, IRRewriter &rewriter) {
    bool changed = false;

    // Map from hash → vector of (key, first-occurrence op)
    // We use a vector per hash bucket to handle hash collisions correctly.
    llvm::DenseMap<size_t, SmallVector<std::pair<CSEKey, Operation*>, 2>>
        expressionMap;

    // Track whether any store has been seen so far in this block.
    // When a store is encountered, we invalidate all LoadOp entries
    // because the store may alias any load address.
    // This is conservative but safe — a more precise analysis would
    // track per-address invalidation, which is v3.8.0 material.
    bool storeSeenSinceLastReset = false;

    // Collect ops in forward order first, since we'll mutate the block
    SmallVector<Operation*, 64> opsInBlock;
    for (auto &op : block)
        opsInBlock.push_back(&op);

    for (auto *op : opsInBlock) {
        // If this is a store or call, invalidate load entries and skip CSE
        if (isa<mid::StoreOp>(op) || isa<mid::CallOp>(op) ||
            isa<mid::MemcpyOp>(op) || isa<mid::MemsetOp>(op)) {
            storeSeenSinceLastReset = true;
            continue;
        }

        auto keyOpt = computeCSEKey(op);
        if (!keyOpt)
            continue;

        CSEKey key = *keyOpt;

        // For LoadOps, don't CSE if any store/call has been seen since the
        // original load (conservative memory safety)
        bool isLoad = isa<mid::LoadOp>(op);

        // Look up in the expression map
        auto &bucket = expressionMap[key.hash];
        Operation *original = nullptr;
        for (auto &[existingKey, existingOp] : bucket) {
            if (cseKeysEqual(existingKey, key)) {
                // Found a match — but for loads, check store invalidation
                if (isLoad && storeSeenSinceLastReset) {
                    // A store happened between the original load and this one;
                    // replace the map entry with the current op (it's "fresher")
                    existingOp = op;
                    original = nullptr; // don't eliminate
                    break;
                }
                original = existingOp;
                break;
            }
        }

        if (original && original != op) {
            // Replace all uses of this op's result with the original's result
            LLVM_DEBUG(llvm::dbgs()
                       << "HelixMidSimplify CSE: eliminating duplicate "
                       << op->getName() << " in favor of earlier occurrence\n");
            rewriter.replaceOp(op, original->getResult(0));
            changed = true;
        } else if (!original) {
            // First occurrence — record it
            // For loads, also reset the "storeSeenSinceLastReset" tracking:
            // we track it per-load-entry by recording the load AFTER stores,
            // so a future identical load that appears before the next store
            // can still be CSE'd against this one.
            bucket.push_back({key, op});
        }
    }

    return changed;
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
                } else if (auto select = dyn_cast<mid::SelectOp>(op)) {
                    if (trySimplifySelect(select, rewriter))
                        changed = true;
                } else if (auto cast = dyn_cast<mid::CastOp>(op)) {
                    if (trySimplifyCast(cast, rewriter))
                        changed = true;
                }
            }

            // ── Local CSE: run AFTER all simplification patterns ────────
            // Walk every block in the module and eliminate duplicate pure
            // expressions within the same block.  This runs inside the
            // fixed-point loop so that expressions exposed or simplified by
            // the patterns above can be caught, and any new duplicates
            // introduced by CSE-triggered rewrites are cleaned up on the
            // next iteration.
            module.walk([&](Block *block) {
                if (tryEliminateCSE(*block, rewriter))
                    changed = true;
            });
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
