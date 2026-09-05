/// @file ConstantFoldingPass.cpp
/// @brief MLIR pass: constant folding at the HelixMid level (Nightly P2.11).
///
/// Uses a safe manual walk instead of applyPatternsAndFoldGreedily to avoid
/// MLIR's internal fold() crashing on pointer-typed ops from Remill IR.
/// The constant folding logic is now inlined in HelixMidSimplify — this pass
/// is a lightweight second round for any remaining opportunities.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixMidOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/APInt.h"

using namespace mlir;
using namespace helix;

namespace {

struct ConstantFoldingPass
    : public PassWrapper<ConstantFoldingPass, OperationPass<ModuleOp>>
{
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(ConstantFoldingPass)

    StringRef getArgument() const final { return "helix-constant-folding"; }
    StringRef getDescription() const final {
        return "Constant folding at the HelixMid level (safe walk)";
    }

    void getDependentDialects(DialectRegistry &registry) const override {
        registry.insert<helix::mid::HelixMidDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();
        IRRewriter rewriter(&getContext());

        auto getConst = [](Value v) -> std::optional<int64_t> {
            if (auto c = v.getDefiningOp<mid::ConstantOp>())
                return c.getValue();
            if (auto c = v.getDefiningOp<arith::ConstantOp>())
                if (auto intAttr = dyn_cast<IntegerAttr>(c.getValue()))
                    return intAttr.getInt();
            return std::nullopt;
        };

        bool changed = true;
        unsigned iterations = 0;
        while (changed && iterations++ < 16) {
            changed = false;
            SmallVector<mid::BinExprOp, 32> ops;
            module.walk([&](mid::BinExprOp op) { ops.push_back(op); });

            for (auto op : ops) {
                auto resultType = op.getResult().getType();
                if (!isa<IntegerType>(resultType))
                    continue;
                if (!isa<IntegerType>(op.getLhs().getType()) ||
                    !isa<IntegerType>(op.getRhs().getType()))
                    continue;

                auto lhsConst = getConst(op.getLhs());
                auto rhsConst = getConst(op.getRhs());
                if (!lhsConst || !rhsConst)
                    continue;

                int64_t l = *lhsConst, r = *rhsConst;
                unsigned operandWidth =
                    cast<IntegerType>(op.getLhs().getType()).getWidth();
                llvm::APInt lhsBits(operandWidth, static_cast<uint64_t>(l));
                llvm::APInt rhsBits(operandWidth, static_cast<uint64_t>(r));
                llvm::APInt resultBits(operandWidth, 0);
                using K = mid::BinExprKind;
                switch (op.getKind()) {
                case K::Add: resultBits = lhsBits + rhsBits; break;
                case K::Sub: resultBits = lhsBits - rhsBits; break;
                case K::Mul:
                case K::UMul:
                case K::SMul:
                    resultBits = lhsBits * rhsBits;
                    break;
                case K::Div:
                case K::SDiv: {
                    if (rhsBits.isZero()) continue;
                    bool overflow = false;
                    resultBits = lhsBits.sdiv_ov(rhsBits, overflow);
                    if (overflow) continue;
                    break;
                }
                case K::UDiv:
                    if (rhsBits.isZero()) continue;
                    resultBits = lhsBits.udiv(rhsBits);
                    break;
                case K::Mod:
                    if (rhsBits.isZero()) continue;
                    resultBits = lhsBits.srem(rhsBits);
                    break;
                case K::Shl: if (r < 0 || static_cast<uint64_t>(r) >= operandWidth) continue;
                    resultBits = lhsBits.shl(static_cast<unsigned>(r)); break;
                case K::Shr: if (r < 0 || static_cast<uint64_t>(r) >= operandWidth) continue;
                    resultBits = lhsBits.lshr(static_cast<unsigned>(r)); break;
                case K::Sar: if (r < 0 || static_cast<uint64_t>(r) >= operandWidth) continue;
                    resultBits = lhsBits.ashr(static_cast<unsigned>(r)); break;
                case K::BitAnd: resultBits = lhsBits & rhsBits; break;
                case K::BitOr:  resultBits = lhsBits | rhsBits; break;
                case K::BitXor: resultBits = lhsBits ^ rhsBits; break;
                case K::Eq:  resultBits = llvm::APInt(operandWidth, lhsBits == rhsBits); break;
                case K::Ne:  resultBits = llvm::APInt(operandWidth, lhsBits != rhsBits); break;
                case K::Lt:  resultBits = llvm::APInt(operandWidth, lhsBits.slt(rhsBits)); break;
                case K::Le:  resultBits = llvm::APInt(operandWidth, lhsBits.sle(rhsBits)); break;
                case K::Gt:  resultBits = llvm::APInt(operandWidth, lhsBits.sgt(rhsBits)); break;
                case K::Ge:  resultBits = llvm::APInt(operandWidth, lhsBits.sge(rhsBits)); break;
                case K::Ult: resultBits = llvm::APInt(operandWidth, lhsBits.ult(rhsBits)); break;
                case K::Ule: resultBits = llvm::APInt(operandWidth, lhsBits.ule(rhsBits)); break;
                case K::Ugt: resultBits = llvm::APInt(operandWidth, lhsBits.ugt(rhsBits)); break;
                case K::Uge: resultBits = llvm::APInt(operandWidth, lhsBits.uge(rhsBits)); break;
                case K::LogAnd: resultBits = llvm::APInt(operandWidth, l != 0 && r != 0); break;
                case K::LogOr:  resultBits = llvm::APInt(operandWidth, l != 0 || r != 0); break;
                default: continue;
                }

                rewriter.setInsertionPoint(op);
                unsigned resultWidth = cast<IntegerType>(resultType).getWidth();
                resultBits = resultBits.sextOrTrunc(resultWidth);
                auto c = rewriter.create<arith::ConstantOp>(
                    op.getLoc(), rewriter.getIntegerAttr(resultType, resultBits));
                rewriter.replaceOp(op, c.getResult());
                changed = true;
            }
        }
    }
};

} // anonymous namespace

std::unique_ptr<mlir::Pass> helix::createConstantFoldingPass() {
    return std::make_unique<ConstantFoldingPass>();
}
