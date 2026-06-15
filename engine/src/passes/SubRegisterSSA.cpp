/// @file SubRegisterSSA.cpp
/// @brief Sub-register SSA refinement patterns for Helix-Nightly (P2.9).
///
/// Handles x86-64 sub-register aliasing formally by inserting explicit
/// trunc/zext ops when sub-register reads follow full-register writes.
///
/// These patterns are registered in the HelixLowSimplify pass and run
/// as part of the greedy pattern rewrite driver.
///
/// Key x86-64 semantics:
///   - Writing EAX (32-bit) zero-extends to RAX (64-bit)
///   - Writing AX (16-bit) does NOT zero-extend (keeps upper bits)
///   - Writing AL (8-bit) does NOT zero-extend (keeps upper bits)
///   - Reading EAX after writing RAX → trunc(RAX, i32)
///
/// @version Helix-Nightly

#include "helix/passes/Passes.h"
#include "helix/analysis/SubRegisterMap.h"
#include "helix/dialects/HelixLowOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

#include "llvm/ADT/Statistic.h"

#define DEBUG_TYPE "helix-subreg-ssa"

STATISTIC(NumSubRegReadsResolved, "Sub-register reads resolved via trunc");
STATISTIC(NumSubRegWritesResolved, "Sub-register writes resolved via zext");

using namespace mlir;
using namespace helix;

namespace {

/// Pattern: reg.read of a sub-register (e.g., "eax") when we know
/// the parent register (e.g., "rax") was recently written.
///
/// This doesn't actually do def-use analysis across blocks (that would
/// require full SSA heritage). Instead, it handles the common case where
/// the parent write is in the same block, visible via a simple backward scan.
///
/// Matches: reg.read "eax"  (where eax is a sub-register of rax)
/// Rewrites: search backward in the same block for reg.write "rax", val
///           then replace the reg.read result with trunc(val, i32)
struct SubRegReadToTrunc : public OpRewritePattern<helix::low::RegReadOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(helix::low::RegReadOp readOp,
                                  PatternRewriter& rewriter) const override {
        auto regName = readOp.getRegName().str();
        auto subInfo = SubRegisterMap::lookup(regName);

        // Only match sub-register reads (not full 64-bit reads)
        if (!subInfo || subInfo->width_bits == 64)
            return failure();

        // Search backward in the same block for a write to the parent register
        auto* block = readOp->getBlock();
        if (!block) return failure();

        Operation* parentWrite = nullptr;
        for (auto it = Block::reverse_iterator(readOp->getIterator());
             it != block->rbegin(); ++it) {
            if (auto writeOp = dyn_cast<helix::low::RegWriteOp>(&*it)) {
                if (writeOp.getRegName() == subInfo->parent) {
                    parentWrite = writeOp;
                    break;
                }
                // If we see a write to the same sub-register, stop
                if (writeOp.getRegName() == regName)
                    return failure();
            }
        }

        if (!parentWrite)
            return failure();

        auto writeOp = cast<helix::low::RegWriteOp>(parentWrite);
        Value parentValue = writeOp.getValue();

        // Create trunc from parent width to sub-register width
        auto truncType = rewriter.getIntegerType(subInfo->width_bits);

        if (subInfo->offset_bits == 0) {
            // Low sub-register: simple truncation
            auto truncOp = rewriter.create<arith::TruncIOp>(
                readOp.getLoc(), truncType, parentValue);
            rewriter.replaceOp(readOp, {truncOp.getResult()});
        } else {
            // High sub-register (e.g., AH): shift right then truncate
            auto shiftAmt = rewriter.create<arith::ConstantOp>(
                readOp.getLoc(),
                rewriter.getIntegerAttr(parentValue.getType(),
                                        subInfo->offset_bits));
            auto shifted = rewriter.create<arith::ShRUIOp>(
                readOp.getLoc(), parentValue, shiftAmt);
            auto truncOp = rewriter.create<arith::TruncIOp>(
                readOp.getLoc(), truncType, shifted);
            rewriter.replaceOp(readOp, {truncOp.getResult()});
        }

        ++NumSubRegReadsResolved;
        return success();
    }
};

/// Pattern: reg.write to a 32-bit sub-register (e.g., "eax") should
/// be understood as zero-extending to 64 bits (x86-64 semantics).
///
/// This pattern annotates the write with the zero-extension semantic
/// by converting:
///   reg.write val, "eax", 32
/// to:
///   %zext = arith.extui val : i32 to i64
///   reg.write %zext, "rax", 64
///
/// Only applies to 32-bit writes (which zero-extend in x86-64).
/// 8-bit and 16-bit writes do NOT zero-extend and are left as-is.
struct SubRegWrite32ToZext : public OpRewritePattern<helix::low::RegWriteOp> {
    using OpRewritePattern::OpRewritePattern;

    LogicalResult matchAndRewrite(helix::low::RegWriteOp writeOp,
                                  PatternRewriter& rewriter) const override {
        auto regName = writeOp.getRegName().str();
        auto subInfo = SubRegisterMap::lookup(regName);

        // Only match 32-bit sub-register writes that zero-extend
        if (!subInfo || !subInfo->zero_extends || subInfo->width_bits != 32)
            return failure();

        Value value = writeOp.getValue();
        auto i64Type = rewriter.getIntegerType(64);

        // Zero-extend the value to 64 bits
        auto zextOp = rewriter.create<arith::ExtUIOp>(
            writeOp.getLoc(), i64Type, value);

        // Replace the sub-register write with a full-register write
        rewriter.replaceOpWithNewOp<helix::low::RegWriteOp>(
            writeOp, zextOp.getResult(),
            rewriter.getStringAttr(subInfo->parent),
            rewriter.getI32IntegerAttr(64),
            /*address=*/IntegerAttr{});

        ++NumSubRegWritesResolved;
        return success();
    }
};

} // anonymous namespace

// Registration function called from HelixLowSimplify's pattern population
namespace helix {

void populateSubRegisterSSAPatterns(mlir::RewritePatternSet& patterns) {
    patterns.add<SubRegReadToTrunc, SubRegWrite32ToZext>(
        patterns.getContext());
}

} // namespace helix
