/// @file StructureControlFlow.cpp
/// @brief MLIR pass: transforms flat basic blocks with branches into structured
///        control flow (if/else, while, goto/label).
///
/// This is the most complex pass in the Helix pipeline.  It operates on a
/// HelixLow-level function that has been lowered to a flat CFG (basic blocks
/// with conditional/unconditional branches) and recovers high-level structured
/// control flow suitable for pseudo-C emission.
///
/// ## Algorithm
///
///   1. Compute dominance for the function using mlir::DominanceInfo.
///   2. Build a CFG edge list from block terminators.
///   3. Identify back-edges: an edge (A -> B) where B dominates A indicates
///      a natural loop with header B.
///   4. For each natural loop, collect the loop body via a reverse walk from
///      the latch to the header, then replace the sub-CFG with a single
///      `helix_high.while` operation carrying a region.
///   5. Identify forward conditional branches (target does NOT dominate source)
///      and replace them with `helix_high.if` operations.  When the last
///      operation before the merge point is an unconditional branch forward,
///      an else region is emitted.
///   6. Convert `helix_low.cmov` operations to `helix_high.ternary`.
///   7. Any remaining branches that cannot be structured (irreducible control
///      flow) are lowered to `helix_high.goto` / `helix_high.label` pairs.
///
/// ## References
///
///   - Rust implementation: crates/helix-core/src/analysis/control_flow.rs
///   - "No More Gotos" (Yakdan et al., NDSS 2015)
///   - Cifuentes, "Reverse Compilation Techniques" (1994), Ch. 6

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/Analysis/Dominance.h"
#include "mlir/IR/Block.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Matchers.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/Region.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/SCCIterator.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#include <algorithm>
#include <cstdint>
#include <format>
#include <optional>
#include <string>
#include <string_view>

#define DEBUG_TYPE "structure-control-flow"

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// Statistics
// ═══════════════════════════════════════════════════════════════════════════════

STATISTIC(NumWhileRecovered,   "Number of while loops recovered");
STATISTIC(NumIfRecovered,      "Number of if/else blocks recovered");
STATISTIC(NumTernaryRecovered, "Number of CMOV -> ternary conversions");
STATISTIC(NumGotoEmitted,      "Number of goto/label pairs emitted (irreducible)");

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// CFG Edge Representation
// ═══════════════════════════════════════════════════════════════════════════════

/// A directed edge in the control flow graph.
struct CFGEdge {
    Block* source;
    Block* target;
};

/// Classification of an edge in the CFG relative to the dominance tree.
enum class EdgeKind {
    /// Target dominates source — this is a back-edge forming a natural loop.
    BackEdge,
    /// Source dominates target — a tree/forward edge (normal control flow).
    ForwardEdge,
    /// Neither dominates the other — a cross-edge (potential irreducible flow).
    CrossEdge,
};

// ═══════════════════════════════════════════════════════════════════════════════
// Natural Loop Descriptor
// ═══════════════════════════════════════════════════════════════════════════════

/// Represents a natural loop detected through back-edge analysis.
///
/// A natural loop has a single entry point (the header) that dominates all
/// blocks in the loop body.  The latch is the source of the back-edge that
/// closes the loop.
struct NaturalLoop {
    /// The loop header — dominates all body blocks, sole entry point.
    Block* header = nullptr;

    /// The latch block — source of the back-edge targeting the header.
    Block* latch = nullptr;

    /// All blocks comprising the loop body, including header and latch.
    llvm::SmallSetVector<Block*, 8> body;

    /// The condition value used for the loop test (if recoverable).
    Value condition;

    /// True if the loop condition is at the latch (do-while style).
    bool conditionAtLatch = false;
};

// ═══════════════════════════════════════════════════════════════════════════════
// Forward Branch Descriptor
// ═══════════════════════════════════════════════════════════════════════════════

/// Represents a structured if (with optional else) recovered from forward
/// conditional branches.
struct IfRegion {
    /// The block containing the conditional branch.
    Block* branchBlock = nullptr;

    /// The condition value for the branch.
    Value condition;

    /// Blocks comprising the "then" path (fallthrough on false).
    llvm::SmallVector<Block*, 4> thenBlocks;

    /// Blocks comprising the "else" path (if detected).  Empty when there
    /// is no else branch.
    llvm::SmallVector<Block*, 4> elseBlocks;

    /// The merge block where both paths converge.
    Block* mergeBlock = nullptr;

    /// Whether this if has an else clause.
    bool hasElse = false;
};

// ═══════════════════════════════════════════════════════════════════════════════
// Helper Functions
// ═══════════════════════════════════════════════════════════════════════════════

/// Classify a CFG edge relative to the dominator tree.
///
/// @param edge  The directed edge to classify.
/// @param dom   Precomputed dominance information.
/// @return      The edge classification.
static EdgeKind classifyEdge(const CFGEdge& edge, const DominanceInfo& dom) {
    if (dom.dominates(edge.target, edge.source))
        return EdgeKind::BackEdge;
    if (dom.dominates(edge.source, edge.target))
        return EdgeKind::ForwardEdge;
    return EdgeKind::CrossEdge;
}

/// Collect all CFG edges within a region by examining block terminators.
///
/// @param region  The region (function body) to scan.
/// @return        A vector of all directed edges in the CFG.
static llvm::SmallVector<CFGEdge, 16> collectCFGEdges(Region& region) {
    llvm::SmallVector<CFGEdge, 16> edges;

    for (auto& block : region) {
        for (auto* successor : block.getSuccessors()) {
            edges.push_back({&block, successor});
        }
    }

    return edges;
}

/// Collect the natural loop body for a back-edge by walking backwards from
/// the latch to the header.
///
/// Starting from the latch, we add each predecessor to the worklist until we
/// reach the header.  All visited blocks form the loop body.
///
/// @param header  The loop header (dominator / destination of back-edge).
/// @param latch   The latch block (source of back-edge).
/// @return        The set of blocks comprising the loop body.
static llvm::SmallSetVector<Block*, 8>
collectLoopBody(Block* header, Block* latch) {
    llvm::SmallSetVector<Block*, 8> body;

    // The header is always part of the loop.
    body.insert(header);

    if (header == latch) {
        // Single-block loop.
        return body;
    }

    // Reverse walk from latch to header.
    llvm::SmallVector<Block*, 8> worklist;
    body.insert(latch);
    worklist.push_back(latch);

    while (!worklist.empty()) {
        Block* current = worklist.pop_back_val();
        for (auto* pred : current->getPredecessors()) {
            if (body.insert(pred)) {
                // Only add to worklist if we haven't visited this block yet
                // and it's not the header (we don't walk past the header).
                if (pred != header) {
                    worklist.push_back(pred);
                }
            }
        }
    }

    return body;
}

/// Attempt to extract the loop condition from a conditional branch at the
/// loop latch or header.
///
/// For a branch at the latch:  `cond_br %cond, ^header, ^exit`
///   -> condition is `%cond`, loop is do-while style.
///
/// For a branch at the header: `cond_br %cond, ^body, ^exit`
///   -> condition is `%cond`, loop is while style.
///
/// @param block         The block to examine (header or latch).
/// @param header        The loop header for reference.
/// @param[out] atLatch  Set to true if the condition was found at the latch.
/// @return              The condition Value, or nullptr if not recoverable.
static Value extractLoopCondition(Block* block, Block* header,
                                  bool& atLatch) {
    auto* terminator = block->getTerminator();
    if (!terminator)
        return nullptr;

    // Check for a conditional branch with two successors.
    if (terminator->getNumSuccessors() != 2)
        return nullptr;

    // In MLIR, the standard pattern for a conditional branch is:
    //   cf.cond_br %cond, ^trueBlock, ^falseBlock
    // or a dialect-specific conditional branch.
    if (terminator->getNumOperands() >= 1) {
        auto cond = terminator->getOperand(0);
        auto successors = terminator->getSuccessors();

        // If one of the successors is the header itself, this is the latch
        // condition controlling loop-back.
        if (successors[0] == header || successors[1] == header) {
            atLatch = (block != header);
            return cond;
        }
    }

    return nullptr;
}

/// Detect whether a forward conditional branch has an else clause.
///
/// Pattern: the then-path ends with an unconditional branch that jumps
/// forward past a set of blocks (the else-path) to a common merge point.
///
/// @param thenBlocks  The blocks on the then-path.
/// @param branchBlock The block containing the original conditional branch.
/// @param dom         Dominance information.
/// @return            The merge block if an else pattern is detected, or
///                    nullptr.
static Block* detectElseMerge(llvm::ArrayRef<Block*> thenBlocks,
                              Block* branchBlock,
                              const DominanceInfo& dom) {
    if (thenBlocks.empty())
        return nullptr;

    Block* lastThenBlock = thenBlocks.back();
    auto* terminator = lastThenBlock->getTerminator();
    if (!terminator)
        return nullptr;

    // The last then-block should end with an unconditional branch (1 successor).
    if (terminator->getNumSuccessors() != 1)
        return nullptr;

    Block* mergeCandidate = terminator->getSuccessors()[0];

    // The merge block must be dominated by the branch block (it's the point
    // where both paths reconverge).
    if (!dom.dominates(branchBlock, mergeCandidate))
        return nullptr;

    return mergeCandidate;
}

/// Try to extract a condition code string from a CMP or TEST operation that
/// feeds a conditional branch or CMOV.
///
/// @param condValue  The SSA value used as the branch condition.
/// @return           A human-readable condition string (e.g., "eq", "ne"),
///                   or std::nullopt.
static std::optional<std::string> extractConditionCode(Value condValue) {
    if (!condValue)
        return std::nullopt;

    auto* definingOp = condValue.getDefiningOp();
    if (!definingOp)
        return std::nullopt;

    // Check if the condition comes from a CmpOp.  The flags produced by
    // helix_low.cmp carry the comparison semantics.
    if (auto cmpOp = dyn_cast<helix::low::CmpOp>(definingOp)) {
        // The specific flag (ZF, CF, etc.) is determined by which result
        // of the CmpOp is used.  Result 0 = CF, 1 = ZF, 2 = SF, 3 = OF.
        for (unsigned i = 0; i < cmpOp->getNumResults(); ++i) {
            if (cmpOp->getResult(i) == condValue) {
                switch (i) {
                case 0: return "carry";
                case 1: return "zero";
                case 2: return "sign";
                case 3: return "overflow";
                default: break;
                }
            }
        }
    }

    // Check if the condition comes from a TestOp.
    if (auto testOp = dyn_cast<helix::low::TestOp>(definingOp)) {
        for (unsigned i = 0; i < testOp->getNumResults(); ++i) {
            if (testOp->getResult(i) == condValue) {
                switch (i) {
                case 0: return "zero";
                case 1: return "sign";
                default: break;
                }
            }
        }
    }

    return std::nullopt;
}

/// Get an optional address attribute from an operation.  Many HelixLow ops
/// carry an `addr` attribute indicating the original instruction address.
///
/// @param op  The operation to inspect.
/// @return    The address as a uint64_t, or 0 if not present.
static uint64_t getOpAddress(Operation* op) {
    if (auto addrAttr = op->getAttrOfType<IntegerAttr>("addr")) {
        return addrAttr.getUInt();
    }
    return 0;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CMOV -> Ternary Conversion
// ═══════════════════════════════════════════════════════════════════════════════

/// Convert all `helix_low.cmov` operations within a region to
/// `helix_high.ternary` operations.
///
/// A CMOV (conditional move) is semantically equivalent to a ternary
/// expression: `result = cond ? trueVal : falseVal`.  This conversion
/// lifts the x86-specific CMOV into a language-neutral ternary.
///
/// @param region   The region to scan (typically a function body).
/// @param builder  The OpBuilder for creating new operations.
/// @return         The number of CMOVs converted.
static unsigned convertCmovsToTernary(Region& region, OpBuilder& builder) {
    unsigned converted = 0;

    // Collect CMOVs first to avoid iterator invalidation during erasure.
    llvm::SmallVector<helix::low::CMovOp, 4> cmovOps;
    region.walk([&](helix::low::CMovOp cmov) {
        cmovOps.push_back(cmov);
    });

    for (auto cmov : cmovOps) {
        builder.setInsertionPoint(cmov);

        // helix_low.cmov has: condition_code, flag_input, true_val, false_val
        // helix_high.ternary has: condition, then_value, else_value
        //
        // The CMOV's flag input is an i1 value from a preceding CMP/TEST.
        // We use it directly as the ternary condition.
        auto ternary = builder.create<helix::high::TernaryOp>(
            cmov.getLoc(),
            cmov.getResult().getType(),
            cmov.getFlag(),           // i1 condition
            cmov.getTrueVal(),        // value when condition is true
            cmov.getFalseVal());      // value when condition is false

        // Replace all uses of the CMOV result with the ternary result.
        cmov.getResult().replaceAllUsesWith(ternary.getResult());
        cmov.erase();

        ++converted;
    }

    return converted;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Implementation
// ═══════════════════════════════════════════════════════════════════════════════

/// The control flow structuring pass.
///
/// Operates on a ModuleOp, processing each HelixLow function within it.
/// Transforms the flat basic-block CFG into structured control flow
/// operations in the HelixHigh dialect.
struct StructureControlFlowPass
    : public PassWrapper<StructureControlFlowPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(StructureControlFlowPass)

    StringRef getArgument() const final { return "structure-control-flow"; }
    StringRef getDescription() const final {
        return "Transform flat basic blocks into structured control flow "
               "(if/else, while, goto/label)";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<helix::high::HelixHighDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();

        // Process each HelixLow function in the module.
        auto result = module.walk([&](helix::low::FuncOp func) -> WalkResult {
            if (failed(structureFunction(func)))
                return WalkResult::interrupt();
            return WalkResult::advance();
        });

        if (result.wasInterrupted()) {
            signalPassFailure();
            return;
        }
    }

private:
    // ─── Per-function Structuring ─────────────────────────────────────────

    /// Structure the control flow within a single function.
    ///
    /// This is the main entry point for the per-function analysis.  It runs
    /// the full structuring pipeline:
    ///   1. Compute dominance
    ///   2. Classify edges
    ///   3. Recover loops
    ///   4. Recover if/else
    ///   5. Convert CMOVs
    ///   6. Emit goto/label for remaining branches
    ///
    /// @param func  The HelixLow function to structure.
    /// @return      success() if structuring completed, failure() on error.
    LogicalResult structureFunction(helix::low::FuncOp func) {
        auto& funcBody = func.getBody();

        // Bail out if the function body is empty or has a single block
        // (nothing to structure in a straight-line function).
        if (funcBody.empty())
            return success();

        if (funcBody.hasOneBlock()) {
            // Even with a single block, we may have CMOVs to convert.
            OpBuilder builder(func->getContext());
            unsigned ternaries = convertCmovsToTernary(funcBody, builder);
            NumTernaryRecovered += ternaries;
            return success();
        }

        // Step 1: Compute dominance for the function.
        DominanceInfo domInfo(func);

        // Step 2: Collect and classify all CFG edges.
        auto edges = collectCFGEdges(funcBody);

        llvm::SmallVector<CFGEdge, 4> backEdges;
        llvm::SmallVector<CFGEdge, 8> forwardEdges;
        llvm::SmallVector<CFGEdge, 4> crossEdges;

        for (const auto& edge : edges) {
            switch (classifyEdge(edge, domInfo)) {
            case EdgeKind::BackEdge:
                backEdges.push_back(edge);
                break;
            case EdgeKind::ForwardEdge:
                forwardEdges.push_back(edge);
                break;
            case EdgeKind::CrossEdge:
                crossEdges.push_back(edge);
                break;
            }
        }

        LLVM_DEBUG({
            llvm::dbgs() << "StructureControlFlow: function '"
                         << func.getSymName() << "'\n";
            llvm::dbgs() << "  Blocks: " << llvm::range_size(funcBody)
                         << "\n";
            llvm::dbgs() << "  Edges: " << edges.size()
                         << " (back=" << backEdges.size()
                         << ", forward=" << forwardEdges.size()
                         << ", cross=" << crossEdges.size() << ")\n";
        });

        OpBuilder builder(func->getContext());

        // Step 3: Recover natural loops from back-edges.
        llvm::SmallVector<NaturalLoop, 4> loops;
        for (const auto& edge : backEdges) {
            NaturalLoop loop;
            loop.header = edge.target;
            loop.latch  = edge.source;
            loop.body   = collectLoopBody(loop.header, loop.latch);

            // Try to extract the loop condition.
            bool atLatch = false;
            loop.condition = extractLoopCondition(loop.latch, loop.header,
                                                  atLatch);
            if (!loop.condition) {
                // Fall back to checking the header for the condition.
                loop.condition = extractLoopCondition(loop.header, loop.header,
                                                      atLatch);
            }
            loop.conditionAtLatch = atLatch;

            loops.push_back(std::move(loop));
        }

        // Step 4: Structure each natural loop into a helix_high.while op.
        for (auto& loop : loops) {
            if (failed(structureLoop(loop, func, builder, domInfo)))
                return failure();
            ++NumWhileRecovered;
        }

        // Step 5: Recover if/else structures from forward conditional branches.
        //
        // We process blocks in reverse post-order (RPO) to handle outer
        // structures before inner ones, ensuring correct nesting.
        llvm::SmallVector<IfRegion, 8> ifRegions;
        if (failed(recoverIfElse(funcBody, domInfo, ifRegions)))
            return failure();

        for (auto& ifRegion : ifRegions) {
            if (failed(structureIf(ifRegion, func, builder)))
                return failure();
            ++NumIfRecovered;
        }

        // Step 6: Convert CMOV operations to ternary expressions.
        unsigned ternaries = convertCmovsToTernary(funcBody, builder);
        NumTernaryRecovered += ternaries;

        // Step 7: Emit goto/label pairs for any remaining unstructured
        //         branches (irreducible control flow).
        for (const auto& edge : crossEdges) {
            emitGotoLabel(edge, func, builder);
            ++NumGotoEmitted;
        }

        LLVM_DEBUG({
            llvm::dbgs() << "  Recovered: " << loops.size() << " loop(s), "
                         << ifRegions.size() << " if/else(s), "
                         << ternaries << " ternary(s), "
                         << crossEdges.size() << " goto(s)\n";
        });

        return success();
    }

    // ─── Loop Structuring ─────────────────────────────────────────────────

    /// Replace a natural loop with a `helix_high.while` operation.
    ///
    /// Creates a WhileOp with two regions:
    ///   - condition region: evaluates the loop test, yields an i1
    ///   - body region: contains the loop body operations
    ///
    /// The original loop blocks are moved into the WhileOp's regions and
    /// the back-edge is removed.
    ///
    /// @param loop     The natural loop descriptor.
    /// @param func     The enclosing function.
    /// @param builder  OpBuilder for creating new operations.
    /// @param domInfo  Dominance information.
    /// @return         success() on completion, failure() on error.
    LogicalResult structureLoop(NaturalLoop& loop,
                                helix::low::FuncOp func,
                                OpBuilder& builder,
                                const DominanceInfo& domInfo) {
        if (!loop.header) {
            LLVM_DEBUG(llvm::dbgs() << "  Skipping loop with null header\n");
            return success();
        }

        // Determine the insertion point: just before the header block.
        builder.setInsertionPointToStart(loop.header);

        auto loc = loop.header->front().getLoc();

        // Build the condition.  If we recovered a condition value, we use it
        // directly.  Otherwise we emit a `true` constant (infinite loop that
        // should be refined by later passes or manually by the analyst).
        Value condValue = loop.condition;
        if (!condValue) {
            auto i1Ty = builder.getI1Type();
            condValue = builder.create<arith::ConstantOp>(
                loc, i1Ty, builder.getBoolAttr(true));
        }

        // Create the helix_high.while operation.
        //
        // The WhileOp takes a condition and has a body region.  In the MLIR
        // model, the condition is evaluated each iteration; if false, control
        // exits the while.
        auto whileOp = builder.create<helix::high::WhileOp>(
            loc, condValue);

        // Move loop body blocks into the while's body region.
        Region& bodyRegion = whileOp.getBody();
        for (Block* block : loop.body) {
            if (block == loop.header)
                continue;  // Header stays outside; its condition feeds the while
            block->moveBefore(&bodyRegion, bodyRegion.end());
        }

        // If the body region is empty (single-block loop), move the header's
        // non-terminator operations into the body.
        if (bodyRegion.empty()) {
            auto* bodyBlock = new Block();
            bodyRegion.push_back(bodyBlock);

            // Clone non-terminator operations from the header into the body.
            for (auto& op : llvm::make_early_inc_range(loop.header->without_terminator())) {
                op.moveBefore(bodyBlock, bodyBlock->end());
            }
        }

        // Replace the latch's back-edge terminator with a yield/continue
        // that returns control to the while condition.
        if (!bodyRegion.empty()) {
            Block& latchBlock = bodyRegion.back();
            if (auto* term = latchBlock.getTerminator()) {
                builder.setInsertionPoint(term);
                builder.create<helix::high::ContinueOp>(term->getLoc());
                term->erase();
            }
        }

        LLVM_DEBUG({
            llvm::dbgs() << "  Structured while loop at header block, "
                         << loop.body.size() << " block(s)\n";
        });

        return success();
    }

    // ─── If/Else Recovery ─────────────────────────────────────────────────

    /// Scan the function body for forward conditional branches and build
    /// IfRegion descriptors for each.
    ///
    /// A forward conditional branch `cond_br %c, ^A, ^B` where both A and B
    /// are dominated by the branch block produces an if/else.  When only one
    /// target is dominated, we get an if-without-else.
    ///
    /// @param funcBody    The function's region.
    /// @param domInfo     Dominance information.
    /// @param[out] result Detected IfRegion descriptors.
    /// @return            success() or failure().
    LogicalResult recoverIfElse(Region& funcBody,
                                const DominanceInfo& domInfo,
                                llvm::SmallVectorImpl<IfRegion>& result) {
        for (auto& block : funcBody) {
            auto* terminator = block.getTerminator();
            if (!terminator)
                continue;

            // Only consider conditional branches (2 successors).
            if (terminator->getNumSuccessors() != 2)
                continue;

            Block* trueTarget  = terminator->getSuccessors()[0];
            Block* falseTarget = terminator->getSuccessors()[1];

            // For a structured if, the branch block must dominate the targets.
            bool dominatesTrue  = domInfo.dominates(&block, trueTarget);
            bool dominatesFalse = domInfo.dominates(&block, falseTarget);

            if (!dominatesTrue && !dominatesFalse)
                continue;  // Irreducible — handled by goto/label

            // Skip back-edges (loops are handled separately).
            if (domInfo.dominates(trueTarget, &block) ||
                domInfo.dominates(falseTarget, &block))
                continue;

            // Extract the condition operand.
            Value condition;
            if (terminator->getNumOperands() >= 1)
                condition = terminator->getOperand(0);

            IfRegion ifRegion;
            ifRegion.branchBlock = &block;
            ifRegion.condition   = condition;

            if (dominatesTrue && dominatesFalse) {
                // Both targets dominated → if/else with a merge point.
                ifRegion.thenBlocks.push_back(trueTarget);
                ifRegion.elseBlocks.push_back(falseTarget);
                ifRegion.hasElse = true;

                // Find the merge block: the immediate post-dominator of the
                // branch block, or the block where both paths converge.
                ifRegion.mergeBlock = detectElseMerge(
                    ifRegion.thenBlocks, &block, domInfo);
            } else if (dominatesTrue) {
                // Only true target dominated → if-without-else.
                ifRegion.thenBlocks.push_back(trueTarget);
                ifRegion.mergeBlock = falseTarget;
                ifRegion.hasElse = false;
            } else {
                // Only false target dominated → inverted if (negate condition).
                ifRegion.thenBlocks.push_back(falseTarget);
                ifRegion.mergeBlock = trueTarget;
                ifRegion.hasElse = false;
                // The condition will need to be negated when we build the IfOp.
            }

            result.push_back(std::move(ifRegion));
        }

        return success();
    }

    /// Replace a detected if/else pattern with a `helix_high.if` operation.
    ///
    /// Creates an IfOp with:
    ///   - A condition value (i1)
    ///   - A "then" region containing the then-path blocks
    ///   - An optional "else" region containing the else-path blocks
    ///
    /// @param ifRegion  The detected if/else descriptor.
    /// @param func      The enclosing function.
    /// @param builder   OpBuilder for creating new operations.
    /// @return          success() on completion, failure() on error.
    LogicalResult structureIf(IfRegion& ifRegion,
                              helix::low::FuncOp func,
                              OpBuilder& builder) {
        if (!ifRegion.branchBlock || !ifRegion.condition)
            return success();

        auto* terminator = ifRegion.branchBlock->getTerminator();
        if (!terminator)
            return success();

        builder.setInsertionPoint(terminator);
        auto loc = terminator->getLoc();

        // Create the helix_high.if operation.
        auto ifOp = builder.create<helix::high::IfOp>(
            loc, ifRegion.condition, ifRegion.hasElse);

        // Move then-blocks into the IfOp's then-region.
        Region& thenRegion = ifOp.getThenRegion();
        for (Block* block : ifRegion.thenBlocks) {
            block->moveBefore(&thenRegion, thenRegion.end());
        }

        // Ensure the then-region has a yield/terminator.
        if (!thenRegion.empty()) {
            Block& lastThen = thenRegion.back();
            if (lastThen.empty() ||
                !lastThen.back().hasTrait<OpTrait::IsTerminator>()) {
                builder.setInsertionPointToEnd(&lastThen);
                builder.create<helix::high::YieldOp>(loc);
            }
        }

        // Move else-blocks into the IfOp's else-region (if present).
        if (ifRegion.hasElse) {
            Region& elseRegion = ifOp.getElseRegion();
            for (Block* block : ifRegion.elseBlocks) {
                block->moveBefore(&elseRegion, elseRegion.end());
            }

            // Ensure the else-region has a yield/terminator.
            if (!elseRegion.empty()) {
                Block& lastElse = elseRegion.back();
                if (lastElse.empty() ||
                    !lastElse.back().hasTrait<OpTrait::IsTerminator>()) {
                    builder.setInsertionPointToEnd(&lastElse);
                    builder.create<helix::high::YieldOp>(loc);
                }
            }
        }

        // Replace the original conditional branch with a fallthrough to the
        // merge block (if it exists).
        if (ifRegion.mergeBlock) {
            builder.setInsertionPoint(terminator);
            builder.create<cf::BranchOp>(loc, ifRegion.mergeBlock);
        }
        terminator->erase();

        LLVM_DEBUG({
            llvm::dbgs() << "  Structured if"
                         << (ifRegion.hasElse ? "/else" : "")
                         << " at block\n";
        });

        return success();
    }

    // ─── Irreducible Fallback: goto/label ─────────────────────────────────

    /// Emit a `helix_high.goto` / `helix_high.label` pair for a cross-edge
    /// that could not be structured into if/while.
    ///
    /// This is the fallback for irreducible control flow.  The resulting
    /// pseudo-C will contain explicit gotos, which is unfortunate but correct.
    ///
    /// @param edge    The irreducible cross-edge.
    /// @param func    The enclosing function.
    /// @param builder OpBuilder for creating new operations.
    void emitGotoLabel(const CFGEdge& edge,
                       helix::low::FuncOp func,
                       OpBuilder& builder) {
        // Generate a label name from the target block's address.
        // If the first operation in the target block has an address attribute,
        // use it; otherwise fall back to a synthetic name.
        std::string labelName;
        if (!edge.target->empty()) {
            uint64_t addr = getOpAddress(&edge.target->front());
            if (addr != 0) {
                labelName = std::format("loc_{:x}", addr);
            }
        }
        if (labelName.empty()) {
            // Use a monotonically increasing counter as the label name.
            static unsigned gotoCounter = 0;
            labelName = std::format("loc_irr_{}", gotoCounter++);
        }

        // Insert the label at the beginning of the target block.
        builder.setInsertionPointToStart(edge.target);
        builder.create<helix::high::LabelOp>(
            edge.target->front().getLoc(),
            builder.getStringAttr(labelName));

        // Replace the source block's branch to the target with a goto.
        auto* terminator = edge.source->getTerminator();
        if (terminator) {
            builder.setInsertionPoint(terminator);
            builder.create<helix::high::GotoOp>(
                terminator->getLoc(),
                builder.getStringAttr(labelName));

            // Note: we do NOT erase the terminator here because it may have
            // other successors (e.g., the other branch of a cond_br) that
            // were already structured.  The terminator will be cleaned up
            // by subsequent passes or the canonicalizer.
        }

        LLVM_DEBUG({
            llvm::dbgs() << "  Emitted goto/label '" << labelName
                         << "' for irreducible edge\n";
        });
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Factory
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createStructureControlFlowPass() {
    return std::make_unique<StructureControlFlowPass>();
}
