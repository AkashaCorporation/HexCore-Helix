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

                int64_t l = *lhsConst, r = *rhsConst, result;
                using K = mid::BinExprKind;
                switch (op.getKind()) {
                case K::Add: result = l + r; break;
                case K::Sub: result = l - r; break;
                case K::Mul: result = l * r; break;
                case K::Div: if (r == 0) continue; result = l / r; break;
                case K::Mod: if (r == 0) continue; result = l % r; break;
                case K::Shl: if (r < 0 || r >= 64) continue; result = l << r; break;
                case K::Shr: if (r < 0 || r >= 64) continue;
                    result = static_cast<int64_t>(static_cast<uint64_t>(l) >> r); break;
                case K::Sar: if (r < 0 || r >= 64) continue; result = l >> r; break;
                case K::BitAnd: result = l & r; break;
                case K::BitOr:  result = l | r; break;
                case K::BitXor: result = l ^ r; break;
                case K::Eq:  result = (l == r) ? 1 : 0; break;
                case K::Ne:  result = (l != r) ? 1 : 0; break;
                case K::Lt:  result = (l < r)  ? 1 : 0; break;
                case K::Le:  result = (l <= r) ? 1 : 0; break;
                case K::Gt:  result = (l > r)  ? 1 : 0; break;
                case K::Ge:  result = (l >= r) ? 1 : 0; break;
                default: continue;
                }

                rewriter.setInsertionPoint(op);
                auto c = rewriter.create<arith::ConstantOp>(
                    op.getLoc(), rewriter.getIntegerAttr(resultType, result));
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
