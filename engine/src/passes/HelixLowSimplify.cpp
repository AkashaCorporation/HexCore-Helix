/// @file HelixLowSimplify.cpp
/// @brief MLIR pass: greedy pattern-based simplification of HelixLow dialect ops.
///
/// Collects all HelixLow rewrite patterns (arithmetic identities, dead flag
/// elimination, memory forwarding, redundant cast removal) and applies them
/// using MLIR's greedy pattern rewriter until a fixed point is reached.

#include "helix/passes/Passes.h"
#include "helix/passes/Patterns.h"
#include "helix/dialects/HelixLowOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "helix-low-simplify"

using namespace mlir;
using namespace helix;

STATISTIC(NumLowArithSimplified,  "Number of HelixLow arith patterns applied");
STATISTIC(NumLowFlagsEliminated,  "Number of HelixLow dead flags eliminated");
STATISTIC(NumLowMemoryOptimized,  "Number of HelixLow memory patterns applied");
STATISTIC(NumLowCastsSimplified,  "Number of HelixLow cast patterns applied");

namespace {

struct HelixLowSimplifyPass
    : public PassWrapper<HelixLowSimplifyPass, OperationPass<ModuleOp>>
{
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(HelixLowSimplifyPass)

    StringRef getArgument() const final { return "helix-low-simplify"; }
    StringRef getDescription() const final {
        return "Greedy pattern-based simplification of HelixLow dialect ops";
    }

    void getDependentDialects(DialectRegistry &registry) const override {
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<arith::ArithDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();

        RewritePatternSet patterns(&getContext());
        populateHelixLowArithPatterns(patterns);
        populateHelixLowFlagPatterns(patterns);
        populateHelixLowMemoryPatterns(patterns);
        populateHelixLowCastPatterns(patterns);

        // Configure: allow non-convergence without signalling failure,
        // since partial simplification is still beneficial.
        GreedyRewriteConfig config;
        config.maxIterations = 16;

        if (failed(applyPatternsAndFoldGreedily(module, std::move(patterns),
                                                 config))) {
            LLVM_DEBUG(llvm::dbgs()
                       << "HelixLowSimplify: pattern application did not "
                          "converge within iteration limit\n");
            // Non-convergence is not fatal for simplification passes.
        }
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createHelixLowSimplifyPass() {
    return std::make_unique<HelixLowSimplifyPass>();
}
