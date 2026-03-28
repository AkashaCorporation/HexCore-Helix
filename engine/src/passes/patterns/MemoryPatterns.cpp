/// @file MemoryPatterns.cpp
/// @brief Memory optimization patterns for HelixLow dialect ops.
///
/// These patterns optimize redundant memory operations:
///   - LoadAfterStore: forward stored value to a subsequent load at the same
///     address, eliminating the load.
///   - StoreAfterStore: eliminate a store that is immediately overwritten by
///     another store to the same address.

#include "helix/passes/Patterns.h"
#include "helix/dialects/HelixLowOps.h"

#include "mlir/IR/PatternMatch.h"

#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "helix-memory-patterns"

using namespace mlir;
using namespace helix;

namespace {

/// If a mem.write addr, val, width is immediately followed by a mem.read
/// addr, width with the same address and width, replace the load result
/// with val (store-to-load forwarding).
struct LoadAfterStore : public OpRewritePattern<low::MemReadOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::MemReadOp loadOp,
                                  PatternRewriter &rewriter) const override {
        // Walk backwards from the load to find the immediately preceding
        // store in the same block.
        Block *block = loadOp->getBlock();
        if (!block)
            return failure();

        Operation *prevOp = loadOp->getPrevNode();
        if (!prevOp)
            return failure();

        auto storeOp = dyn_cast<low::MemWriteOp>(prevOp);
        if (!storeOp)
            return failure();

        // Check same address (same SSA value) and same bit width.
        if (storeOp.getAddr() != loadOp.getAddr())
            return failure();

        if (storeOp.getBitWidth() != loadOp.getBitWidth())
            return failure();

        // The stored value type must match the load result type.
        if (storeOp.getValue().getType() != loadOp.getResult().getType())
            return failure();

        // Forward the stored value to the load's users.
        rewriter.replaceOp(loadOp, storeOp.getValue());
        return success();
    }
};

/// If two consecutive mem.write ops go to the same address with the same
/// width, the first store is dead (overwritten by the second).
struct StoreAfterStore : public OpRewritePattern<low::MemWriteOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(low::MemWriteOp storeOp,
                                  PatternRewriter &rewriter) const override {
        // Look at the next operation in the same block.
        Operation *nextOp = storeOp->getNextNode();
        if (!nextOp)
            return failure();

        auto nextStore = dyn_cast<low::MemWriteOp>(nextOp);
        if (!nextStore)
            return failure();

        // Check same address and width.
        if (nextStore.getAddr() != storeOp.getAddr())
            return failure();

        if (nextStore.getBitWidth() != storeOp.getBitWidth())
            return failure();

        // Guard: ensure the store has no remaining uses before erasing.
        // The greedy rewriter may have other patterns referencing this op.
        if (!storeOp.getValue().getUses().empty())
            return failure();

        // The first store is dead — erase it.
        rewriter.eraseOp(storeOp);
        return success();
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pattern Registration
// ═══════════════════════════════════════════════════════════════════════════════

void helix::populateHelixLowMemoryPatterns(RewritePatternSet &patterns) {
    patterns.add<
        LoadAfterStore,
        StoreAfterStore
    >(patterns.getContext());
}
