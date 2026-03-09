/// @file StructureControlFlow.cpp
/// @brief MLIR pass: transforms flat basic blocks with branches into structured
///        control flow (if/else, while, do-while, goto/label).
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
///      `helix_high.while` or `helix_high.do_while` operation.
///   5. Identify forward conditional branches (target does NOT dominate source)
///      and replace them with `helix_high.if` operations.  Relaxed convergence
///      detection walks multiple blocks to find the merge point.
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

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
#include "mlir/IR/Dominance.h"
#include "mlir/IR/Block.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/IRMapping.h"
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

STATISTIC(NumWhileRecovered,    "Number of while loops recovered");
STATISTIC(NumDoWhileRecovered,  "Number of do-while loops recovered");
STATISTIC(NumIfRecovered,       "Number of if/else blocks recovered");
STATISTIC(NumTernaryRecovered,  "Number of CMOV -> ternary conversions");
STATISTIC(NumGotoEmitted,       "Number of goto/label pairs emitted (irreducible)");

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

    /// Whether the then-path comes from the branch's false successor.
    bool invertCondition = false;

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
static EdgeKind classifyEdge(const CFGEdge& edge, const DominanceInfo& dom) {
    if (dom.dominates(edge.target, edge.source))
        return EdgeKind::BackEdge;
    if (dom.dominates(edge.source, edge.target))
        return EdgeKind::ForwardEdge;
    return EdgeKind::CrossEdge;
}

/// Collect all CFG edges within a region by examining block terminators.
static llvm::SmallVector<CFGEdge, 16> collectCFGEdges(Region& region) {
    llvm::SmallVector<CFGEdge, 16> edges;

    for (auto& block : region) {
        for (auto* successor : block.getSuccessors()) {
            edges.push_back({&block, successor});
        }
    }

    return edges;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCC-Based Loop Detection (Tarjan's Algorithm)
// ═══════════════════════════════════════════════════════════════════════════════

/// Result of SCC loop detection — a set of blocks forming a loop.
struct SCCLoop {
    Block* header = nullptr;
    llvm::SmallSetVector<Block*, 8> body;
    Value exitCondition;
    Block* exitBlock = nullptr;
};

/// Run Tarjan's SCC on the function CFG to detect all loops (including
/// irreducible ones that dominance-only detection misses).
///
/// For each SCC with ≥2 blocks, we have a loop. The header is chosen as
/// the block with the most predecessors from outside the SCC.
static llvm::SmallVector<SCCLoop, 4>
findSCCLoops(Region& funcBody,
             const llvm::SmallPtrSet<Block*, 16>& alreadyStructured) {
    llvm::SmallVector<SCCLoop, 4> loops;

    // Collect all blocks in the region.
    llvm::SmallVector<Block*, 32> allBlocks;
    llvm::DenseMap<Block*, unsigned> blockIndex;
    for (auto& block : funcBody) {
        blockIndex[&block] = allBlocks.size();
        allBlocks.push_back(&block);
    }

    if (allBlocks.empty()) return loops;

    // Tarjan's SCC state.
    unsigned indexCounter = 0;
    llvm::DenseMap<Block*, unsigned> disc;      // discovery index
    llvm::DenseMap<Block*, unsigned> low;       // low-link value
    llvm::DenseMap<Block*, bool> onStack;
    llvm::SmallVector<Block*, 32> stack;
    llvm::SmallVector<llvm::SmallVector<Block*, 8>, 8> sccs;

    // Iterative Tarjan's to avoid deep recursion on large CFGs.
    struct TarjanFrame {
        Block* block;
        unsigned succIdx;
    };

    auto strongConnect = [&](Block* startBlock) {
        llvm::SmallVector<TarjanFrame, 32> frames;
        disc[startBlock] = low[startBlock] = indexCounter++;
        stack.push_back(startBlock);
        onStack[startBlock] = true;
        frames.push_back({startBlock, 0});

        while (!frames.empty()) {
            auto& frame = frames.back();
            Block* v = frame.block;
            auto successors = v->getSuccessors();

            if (frame.succIdx < successors.size()) {
                Block* w = successors[frame.succIdx];
                frame.succIdx++;

                // Only consider blocks within this region.
                if (!blockIndex.count(w))
                    continue;

                if (!disc.count(w)) {
                    // Tree edge — recurse.
                    disc[w] = low[w] = indexCounter++;
                    stack.push_back(w);
                    onStack[w] = true;
                    frames.push_back({w, 0});
                } else if (onStack.lookup(w)) {
                    // Back edge.
                    low[v] = std::min(low[v], disc[w]);
                }
            } else {
                // Done with all successors of v.
                if (low[v] == disc[v]) {
                    // v is the root of an SCC.
                    llvm::SmallVector<Block*, 8> scc;
                    Block* w;
                    do {
                        w = stack.pop_back_val();
                        onStack[w] = false;
                        scc.push_back(w);
                    } while (w != v);

                    if (scc.size() >= 2) {
                        sccs.push_back(std::move(scc));
                    }
                }

                frames.pop_back();
                if (!frames.empty()) {
                    Block* parent = frames.back().block;
                    low[parent] = std::min(low[parent], low[v]);
                }
            }
        }
    };

    // Run Tarjan's from every unvisited block.
    for (Block* block : allBlocks) {
        if (!disc.count(block))
            strongConnect(block);
    }

    // Convert each SCC into an SCCLoop descriptor.
    for (auto& scc : sccs) {
        // Skip if any block is already structured.
        bool anyStructured = false;
        for (Block* b : scc) {
            if (alreadyStructured.count(b)) {
                anyStructured = true;
                break;
            }
        }
        if (anyStructured) continue;

        SCCLoop loop;
        llvm::SmallPtrSet<Block*, 8> sccSet(scc.begin(), scc.end());

        // Pick header: block with the most predecessors from *outside* the SCC.
        unsigned maxExternalPreds = 0;
        Block* bestHeader = scc[0];
        for (Block* b : scc) {
            unsigned externalPreds = 0;
            for (Block* pred : b->getPredecessors()) {
                if (!sccSet.count(pred))
                    externalPreds++;
            }
            if (externalPreds > maxExternalPreds) {
                maxExternalPreds = externalPreds;
                bestHeader = b;
            }
        }
        loop.header = bestHeader;

        // Add all SCC blocks to the body, header first.
        loop.body.insert(loop.header);
        for (Block* b : scc) {
            if (b != loop.header)
                loop.body.insert(b);
        }

        // Find exit edges (SCC block → non-SCC block) and extract condition.
        for (Block* b : scc) {
            auto* term = b->getTerminator();
            if (!term) continue;

            for (Block* succ : term->getSuccessors()) {
                if (!sccSet.count(succ)) {
                    // This is an exit edge.
                    loop.exitBlock = succ;

                    // If the terminator is a conditional branch,
                    // extract the exit condition.
                    if (term->getNumSuccessors() == 2 &&
                        term->getNumOperands() >= 1) {
                        loop.exitCondition = term->getOperand(0);
                    }
                    break;
                }
            }
            if (loop.exitBlock) break;
        }

        loops.push_back(std::move(loop));
    }

    return loops;
}

/// Collect the natural loop body for a back-edge by walking backwards from
/// the latch to the header.
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
static Value extractLoopCondition(Block* block, Block* header,
                                  bool& atLatch) {
    auto* terminator = block->getTerminator();
    if (!terminator)
        return nullptr;

    // Check for a conditional branch with two successors.
    if (terminator->getNumSuccessors() != 2)
        return nullptr;

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

/// Find the merge block for an if/else by walking forward from both targets
/// up to a bounded depth.  This relaxes the direct convergence requirement:
/// instead of requiring the then-path to end with a direct branch to the
/// merge block, we walk up to `maxDepth` blocks forward looking for a common
/// successor reachable from both paths.
///
/// @param trueTarget   The true branch target.
/// @param falseTarget  The false branch target.
/// @param branchBlock  The block containing the conditional branch.
/// @param dom          Dominance information.
/// @param maxDepth     Maximum number of blocks to walk forward (default 32).
/// @return             The merge block, or nullptr if not found.
static Block* findMergeBlock(Block* trueTarget, Block* falseTarget,
                             Block* branchBlock, const DominanceInfo& dom,
                             const PostDominanceInfo& postDom,
                             unsigned maxDepth = 32) {
    if (Block* postDomMerge =
            postDom.findNearestCommonDominator(trueTarget, falseTarget)) {
        if (postDomMerge != branchBlock &&
            postDomMerge != trueTarget &&
            postDomMerge != falseTarget &&
            dom.dominates(branchBlock, postDomMerge)) {
            return postDomMerge;
        }
    }

    // Collect blocks reachable from the true path (bounded walk).
    llvm::SmallDenseSet<Block*, 16> trueReachable;
    {
        llvm::SmallVector<Block*, 8> worklist;
        worklist.push_back(trueTarget);
        trueReachable.insert(trueTarget);
        unsigned depth = 0;
        while (!worklist.empty() && depth < maxDepth) {
            Block* current = worklist.pop_back_val();
            auto* term = current->getTerminator();
            if (!term) continue;
            for (auto* succ : term->getSuccessors()) {
                if (trueReachable.insert(succ).second) {
                    worklist.push_back(succ);
                }
            }
            ++depth;
        }
    }

    // Walk forward from the false path looking for a block also reachable
    // from the true path — that's the merge point.
    {
        llvm::SmallVector<Block*, 8> worklist;
        llvm::SmallDenseSet<Block*, 16> visited;
        worklist.push_back(falseTarget);
        visited.insert(falseTarget);
        unsigned depth = 0;
        while (!worklist.empty() && depth < maxDepth) {
            Block* current = worklist.pop_back_val();

            // Check if this block is reachable from the true path.
            if (trueReachable.count(current) &&
                current != trueTarget && current != falseTarget) {
                // Verify the merge block is dominated by the branch block.
                if (dom.dominates(branchBlock, current))
                    return current;
            }

            auto* term = current->getTerminator();
            if (!term) continue;
            for (auto* succ : term->getSuccessors()) {
                if (visited.insert(succ).second) {
                    worklist.push_back(succ);
                }
            }
            ++depth;
        }
    }

    // Fallback: check if the false target is the immediate post-dominator
    // (simple if-without-else pattern).
    if (dom.dominates(branchBlock, falseTarget))
        return falseTarget;

    return nullptr;
}

/// Return the sole non-label operation in a block, or nullptr if the block
/// contains multiple non-label operations.
static Operation* getSingleNonLabelOp(Block* block) {
    if (!block)
        return nullptr;

    Operation* nonLabelOp = nullptr;
    for (auto& op : *block) {
        if (isa<helix::high::LabelOp>(op))
            continue;
        if (nonLabelOp)
            return nullptr;
        nonLabelOp = &op;
    }
    return nonLabelOp;
}

/// Follow chains of label-only blocks with a single unconditional successor and
/// return the final trivial `ret` block if one is reached.
static helix::low::RetOp findTrivialReturnOp(Block* start,
                                             unsigned maxDepth = 16) {
    if (!start)
        return {};

    llvm::SmallPtrSet<Block*, 8> visited;
    Block* current = start;
    unsigned depth = 0;

    while (current && depth < maxDepth && visited.insert(current).second) {
        Operation* onlyOp = getSingleNonLabelOp(current);
        if (!onlyOp)
            return {};

        if (auto ret = dyn_cast<helix::low::RetOp>(onlyOp))
            return ret;

        if (onlyOp == current->getTerminator() &&
            onlyOp->getNumSuccessors() == 1) {
            current = onlyOp->getSuccessor(0);
            ++depth;
            continue;
        }

        return {};
    }

    return {};
}

/// Inside a structured if-region, unconditional branches to the parent merge
/// block are redundant: control returns to the parent block after the region.
/// Rewrite them to `yield`, or to `ret` when that merge is just a shared
/// return block.
static void rewriteStructuredRegionExits(Region& region,
                                         Block* mergeBlock,
                                         OpBuilder& builder) {
    helix::low::RetOp mergeRet = findTrivialReturnOp(mergeBlock);

    for (auto& block : region) {
        auto* terminator = block.getTerminator();
        if (!terminator ||
            isa<helix::high::YieldOp>(terminator) ||
            isa<helix::low::RetOp>(terminator))
            continue;

        if (terminator->getNumSuccessors() != 1)
            continue;

        Block* successor = terminator->getSuccessor(0);
        const bool exitsToMerge = mergeBlock && successor == mergeBlock;
        helix::low::RetOp successorRet;
        if (!exitsToMerge)
            successorRet = findTrivialReturnOp(successor);

        if (!exitsToMerge && !successorRet)
            continue;

        builder.setInsertionPoint(terminator);
        if (exitsToMerge && !mergeRet) {
            builder.create<helix::high::YieldOp>(
                terminator->getLoc(), mlir::Value{});
        } else {
            auto retAddr = exitsToMerge
                ? mergeRet->getAttrOfType<IntegerAttr>("address")
                : successorRet->getAttrOfType<IntegerAttr>("address");
            builder.create<helix::low::RetOp>(terminator->getLoc(), retAddr);
        }
        terminator->erase();
    }
}

/// Collect all blocks on a path from `start` to `end` (exclusive of `end`).
///
/// Fast path: accept a simple single-successor chain.
/// Fallback: accept a small single-entry / single-exit subgraph that is fully
/// contained between `start` and `end`. This lets us absorb short diamonds and
/// nested local conditionals into one structured if-region instead of leaving
/// them behind as goto spaghetti.
static llvm::SmallVector<Block*, 4>
collectPathBlocks(Block* start, Block* end, Block* entryBlock = nullptr,
                  unsigned maxDepth = 32) {
    llvm::SmallVector<Block*, 4> path;
    Block* current = start;
    unsigned depth = 0;

    while (current != end && depth < maxDepth) {
        path.push_back(current);
        auto* term = current->getTerminator();
        if (!term || term->getNumSuccessors() != 1)
            break;
        current = term->getSuccessors()[0];
        ++depth;
    }

    // Only return the path if we actually reached the end block.
    if (current == end)
        return path;

    // Fallback: collect a bounded closed region between `start` and `end`.
    llvm::SmallSetVector<Block*, 8> regionBlocks;
    llvm::SmallVector<Block*, 8> worklist;
    regionBlocks.insert(start);
    worklist.push_back(start);

    unsigned visited = 0;
    while (!worklist.empty() && visited < maxDepth) {
        Block* block = worklist.pop_back_val();
        ++visited;

        auto* term = block->getTerminator();
        if (!term)
            return {start};

        for (Block* succ : term->getSuccessors()) {
            if (succ == end)
                continue;
            if (succ == entryBlock)
                return {start};
            if (regionBlocks.insert(succ))
                worklist.push_back(succ);
        }
    }

    // Region too large or cyclic in a way we don't understand: stay
    // conservative and structure only the first block.
    if (!worklist.empty())
        return {start};

    for (Block* block : regionBlocks) {
        // Enforce single entry: blocks inside the candidate region may only
        // be reached from within the region, except for `start`, which may be
        // entered from the original branch block.
        for (Block* pred : block->getPredecessors()) {
            if (regionBlocks.count(pred))
                continue;
            if (block == start && pred == entryBlock)
                continue;
            return {start};
        }

        // Enforce single exit: successors must stay inside the region or jump
        // to the known merge block.
        auto* term = block->getTerminator();
        if (!term)
            return {start};
        for (Block* succ : term->getSuccessors()) {
            if (succ == end || regionBlocks.count(succ))
                continue;
            return {start};
        }
    }

    llvm::SmallVector<Block*, 4> regionPath;
    regionPath.reserve(regionBlocks.size());
    for (Block* block : regionBlocks)
        regionPath.push_back(block);
    if (!regionPath.empty())
        return regionPath;

    // If we didn't reach end in a shape we can safely absorb, return just the
    // start block (conservative: at least structure the first block).
    return {start};
}

/// Detect whether a forward conditional branch has an else clause.
///
/// Pattern: the then-path ends with an unconditional branch that jumps
/// forward past a set of blocks (the else-path) to a common merge point.
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

    // The merge block must be dominated by the branch block.
    if (!dom.dominates(branchBlock, mergeCandidate))
        return nullptr;

    return mergeCandidate;
}

/// Try to extract a human-readable condition string from a condition value.
///
/// Handles direct CmpOp/TestOp flag results, arith negation (XOrIOp for JNZ),
/// arith compound conditions (OrIOp for JLE, AndIOp for JNBE), and VarRefOp.
///
/// @param condValue  The SSA value used as the branch condition.
/// @return           A human-readable condition string, or std::nullopt.
static std::optional<std::string> extractConditionCode(Value condValue) {
    if (!condValue)
        return std::nullopt;

    auto* definingOp = condValue.getDefiningOp();
    if (!definingOp)
        return std::nullopt;

    // ── Helper: extract names from CMP/TEST operands ─────────────────
    auto extractName = [](Value v) -> std::string {
        if (!v) return "";
        auto* op = v.getDefiningOp();
        if (!op) return "";
        if (auto varRef = dyn_cast<helix::high::VarRefOp>(op))
            return varRef.getVarName().str();
        if (auto regRead = dyn_cast<helix::low::RegReadOp>(op))
            return regRead.getRegName().str();
        return "";
    };

    // ── Helper: find the CmpOp/TestOp behind a flag value ────────────
    // Traces through RegWriteOp to find the CmpOp/TestOp that produced
    // the flag, and determines which flag index it is.
    struct FlagSource {
        Operation* cmpOrTest = nullptr;
        unsigned flagIndex = 0; // 0=CF/ZF(test), 1=ZF/SF(test), 2=SF, 3=OF
        bool isCmp = false;
        bool isTest = false;
    };
    auto findFlagSource = [](Value flagVal) -> FlagSource {
        FlagSource src;
        if (!flagVal) return src;
        auto* op = flagVal.getDefiningOp();
        if (!op) return src;

        // Direct CmpOp result
        if (auto cmpOp = dyn_cast<helix::low::CmpOp>(op)) {
            src.cmpOrTest = op;
            src.isCmp = true;
            for (unsigned i = 0; i < cmpOp->getNumResults(); ++i) {
                if (cmpOp->getResult(i) == flagVal) {
                    src.flagIndex = i;
                    break;
                }
            }
            return src;
        }

        // Direct TestOp result
        if (auto testOp = dyn_cast<helix::low::TestOp>(op)) {
            src.cmpOrTest = op;
            src.isTest = true;
            for (unsigned i = 0; i < testOp->getNumResults(); ++i) {
                if (testOp->getResult(i) == flagVal) {
                    src.flagIndex = i;
                    break;
                }
            }
            return src;
        }

        return src;
    };

    // ── Helper: format CmpOp comparison with given operator ──────────
    auto formatCmpComparison = [&](helix::low::CmpOp cmpOp,
                                    const char* op) -> std::optional<std::string> {
        std::string lhs, rhs;
        if (cmpOp->getNumOperands() >= 2) {
            lhs = extractName(cmpOp->getOperand(0));
            rhs = extractName(cmpOp->getOperand(1));
        }
        if (!lhs.empty() && !rhs.empty())
            return std::format("{} {} {}", lhs, op, rhs);
        if (!lhs.empty()) {
            // Check if RHS is a zero constant
            if (auto constOp = cmpOp->getOperand(1).getDefiningOp<arith::ConstantOp>()) {
                if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                    int64_t val = intAttr.getValue().getSExtValue();
                    return std::format("{} {} {}", lhs, op, val);
                }
            }
            return std::format("{} {} 0", lhs, op);
        }
        return std::nullopt;
    };

    // ── Case 1: Direct CmpOp flag result ─────────────────────────────
    if (auto cmpOp = dyn_cast<helix::low::CmpOp>(definingOp)) {
        for (unsigned i = 0; i < cmpOp->getNumResults(); ++i) {
            if (cmpOp->getResult(i) == condValue) {
                switch (i) {
                case 1: // ZF — equality (JZ: a == b)
                    return formatCmpComparison(cmpOp, "==");
                case 0: // CF — unsigned less-than
                    return formatCmpComparison(cmpOp, "<");
                case 2: // SF — sign
                    return formatCmpComparison(cmpOp, "< 0")
                        .or_else([&]() -> std::optional<std::string> {
                            auto n = extractName(cmpOp->getOperand(0));
                            return n.empty() ? std::optional<std::string>("sign")
                                             : std::format("{} < 0", n);
                        });
                case 3: // OF — overflow
                    return std::string("overflow");
                default: break;
                }
            }
        }
    }

    // ── Case 2: Direct TestOp flag result ────────────────────────────
    if (auto testOp = dyn_cast<helix::low::TestOp>(definingOp)) {
        std::string operandName;
        if (testOp->getNumOperands() >= 1) {
            operandName = extractName(testOp->getOperand(0));
        }
        for (unsigned i = 0; i < testOp->getNumResults(); ++i) {
            if (testOp->getResult(i) == condValue) {
                switch (i) {
                case 0: // ZF
                    if (!operandName.empty())
                        return std::format("{} == 0", operandName);
                    return std::string("zero");
                case 1: // SF
                    if (!operandName.empty())
                        return std::format("{} < 0", operandName);
                    return std::string("sign");
                default: break;
                }
            }
        }
    }

    // ── Case 3: arith.xori — negation (JNZ, JNB, JNS, JNL, etc.) ───
    if (auto xorOp = dyn_cast<arith::XOrIOp>(definingOp)) {
        // Check if one operand is a constant true (i1 = 1) — this is negation
        Value flagOp = nullptr;
        bool isNegation = false;
        for (unsigned i = 0; i < 2; ++i) {
            auto constOp = xorOp->getOperand(i).getDefiningOp<arith::ConstantOp>();
            if (constOp) {
                if (auto boolAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                    if (boolAttr.getValue().getBoolValue()) {
                        flagOp = xorOp->getOperand(1 - i);
                        isNegation = true;
                    }
                }
            }
        }

        if (isNegation && flagOp) {
            auto src = findFlagSource(flagOp);

            if (src.isCmp) {
                auto cmpOp = cast<helix::low::CmpOp>(src.cmpOrTest);
                switch (src.flagIndex) {
                case 1: // ZF inverted → a != b (JNZ)
                    return formatCmpComparison(cmpOp, "!=");
                case 0: // CF inverted → a >= b (JNB/JAE)
                    return formatCmpComparison(cmpOp, ">=");
                case 2: // SF inverted → a >= 0 (JNS)
                    return formatCmpComparison(cmpOp, ">= 0")
                        .or_else([&]() -> std::optional<std::string> {
                            auto n = extractName(cmpOp->getOperand(0));
                            return n.empty() ? std::optional<std::string>("!sign")
                                             : std::format("{} >= 0", n);
                        });
                case 3: // OF inverted → no overflow (JNO)
                    return std::string("!overflow");
                default: break;
                }
            }
            if (src.isTest) {
                auto testOp = cast<helix::low::TestOp>(src.cmpOrTest);
                std::string operandName;
                if (testOp->getNumOperands() >= 1)
                    operandName = extractName(testOp->getOperand(0));
                switch (src.flagIndex) {
                case 0: // ZF inverted → a != 0 (JNZ after TEST)
                    if (!operandName.empty())
                        return std::format("{} != 0", operandName);
                    return std::string("!zero");
                case 1: // SF inverted → a >= 0 (JNS after TEST)
                    if (!operandName.empty())
                        return std::format("{} >= 0", operandName);
                    return std::string("!sign");
                default: break;
                }
            }

            // Negation of another arith expression — recursive unwrap
            // XOR(XOR(SF, OF), true) = !(SF != OF) = SF == OF → JNL/JGE
            if (auto innerXor = dyn_cast<arith::XOrIOp>(flagOp.getDefiningOp())) {
                // !(SF XOR OF) → JNL/JGE: a >= b (signed)
                auto sf = findFlagSource(innerXor->getOperand(0));
                auto of = findFlagSource(innerXor->getOperand(1));
                if (sf.isCmp && sf.flagIndex == 2 && of.isCmp && of.flagIndex == 3) {
                    auto cmpOp = cast<helix::low::CmpOp>(sf.cmpOrTest);
                    return formatCmpComparison(cmpOp, ">=");
                }
            }
        }

        // Non-negation XOR: SF XOR OF → JL: a < b (signed)
        if (!isNegation) {
            auto sf = findFlagSource(xorOp->getOperand(0));
            auto of = findFlagSource(xorOp->getOperand(1));
            if (sf.isCmp && sf.flagIndex == 2 && of.isCmp && of.flagIndex == 3) {
                auto cmpOp = cast<helix::low::CmpOp>(sf.cmpOrTest);
                return formatCmpComparison(cmpOp, "<");
            }
        }
    }

    // ── Case 4: arith.ori — compound (JLE: ZF || SF!=OF, JBE: CF||ZF)
    if (auto orOp = dyn_cast<arith::OrIOp>(definingOp)) {
        auto lhsSrc = findFlagSource(orOp->getOperand(0));
        // JBE: CF || ZF
        if (lhsSrc.isCmp && lhsSrc.flagIndex == 0) {
            auto rhsSrc = findFlagSource(orOp->getOperand(1));
            if (rhsSrc.isCmp && rhsSrc.flagIndex == 1) {
                auto cmpOp = cast<helix::low::CmpOp>(lhsSrc.cmpOrTest);
                return formatCmpComparison(cmpOp, "<=");
            }
        }
        // JLE: ZF || (SF XOR OF)
        if (lhsSrc.isCmp && lhsSrc.flagIndex == 1) {
            if (auto sfNeOf = dyn_cast<arith::XOrIOp>(
                    orOp->getOperand(1).getDefiningOp())) {
                auto sf = findFlagSource(sfNeOf->getOperand(0));
                auto of = findFlagSource(sfNeOf->getOperand(1));
                if (sf.isCmp && sf.flagIndex == 2 && of.isCmp && of.flagIndex == 3) {
                    auto cmpOp = cast<helix::low::CmpOp>(lhsSrc.cmpOrTest);
                    return formatCmpComparison(cmpOp, "<=");
                }
            }
        }
    }

    // ── Case 5: arith.andi — compound (JNBE: !CF && !ZF, JNLE: !ZF && !(SF XOR OF))
    if (auto andOp = dyn_cast<arith::AndIOp>(definingOp)) {
        // Check for JNBE: !CF && !ZF → a > b (unsigned)
        // Check for JNLE: !ZF && !(SF XOR OF) → a > b (signed)
        // Both operands should be XOrIOp (negation)
        auto lhsXor = dyn_cast_or_null<arith::XOrIOp>(
            andOp->getOperand(0).getDefiningOp());
        auto rhsXor = dyn_cast_or_null<arith::XOrIOp>(
            andOp->getOperand(1).getDefiningOp());
        if (lhsXor && rhsXor) {
            // Extract the flag being negated in each
            Value lhsFlag = nullptr, rhsFlag = nullptr;
            for (unsigned i = 0; i < 2; ++i) {
                auto c = lhsXor->getOperand(i).getDefiningOp<arith::ConstantOp>();
                if (c) { lhsFlag = lhsXor->getOperand(1-i); break; }
            }
            for (unsigned i = 0; i < 2; ++i) {
                auto c = rhsXor->getOperand(i).getDefiningOp<arith::ConstantOp>();
                if (c) { rhsFlag = rhsXor->getOperand(1-i); break; }
            }
            if (lhsFlag && rhsFlag) {
                auto lSrc = findFlagSource(lhsFlag);
                auto rSrc = findFlagSource(rhsFlag);
                // JNBE: !CF && !ZF
                if (lSrc.isCmp && lSrc.flagIndex == 0 &&
                    rSrc.isCmp && rSrc.flagIndex == 1) {
                    auto cmpOp = cast<helix::low::CmpOp>(lSrc.cmpOrTest);
                    return formatCmpComparison(cmpOp, ">");
                }
                // JNLE: !ZF && !(SF XOR OF)
                if (lSrc.isCmp && lSrc.flagIndex == 1) {
                    // rhsFlag should be SF XOR OF
                    if (auto innerXor = dyn_cast<arith::XOrIOp>(
                            rhsFlag.getDefiningOp())) {
                        auto sf = findFlagSource(innerXor->getOperand(0));
                        auto of = findFlagSource(innerXor->getOperand(1));
                        if (sf.isCmp && sf.flagIndex == 2 &&
                            of.isCmp && of.flagIndex == 3) {
                            auto cmpOp = cast<helix::low::CmpOp>(lSrc.cmpOrTest);
                            return formatCmpComparison(cmpOp, ">");
                        }
                    }
                }
            }
        }
    }

    // ── Case 6: VarRefOp directly (boolean variable) ────────────────
    if (auto varRef = dyn_cast<helix::high::VarRefOp>(definingOp))
        return varRef.getVarName().str();

    return std::nullopt;
}

/// Get an optional address attribute from an operation.
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
/// expression: `result = cond ? trueVal : falseVal`.
static unsigned convertCmovsToTernary(Region& region, OpBuilder& builder) {
    unsigned converted = 0;

    // Collect CMOVs first to avoid iterator invalidation during erasure.
    llvm::SmallVector<helix::low::CMovOp, 4> cmovOps;
    region.walk([&](helix::low::CMovOp cmov) {
        cmovOps.push_back(cmov);
    });

    for (auto cmov : cmovOps) {
        builder.setInsertionPoint(cmov);

        auto ternary = builder.create<helix::high::TernaryOp>(
            cmov.getLoc(),
            cmov.getResult().getType(),
            cmov.getFlagValue(),       // i1 condition
            cmov.getTrueVal(),         // value when condition is true
            cmov.getFalseVal(),        // value when condition is false
            IntegerAttr{});            // address (none)

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
               "(if/else, while, do-while, goto/label)";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<helix::high::HelixHighDialect>();
        registry.insert<mlir::arith::ArithDialect>();
        registry.insert<mlir::cf::ControlFlowDialect>();
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
    /// Performs structuring in phases:
    ///   1. CMOV → ternary (always safe, in-place replacement)
    ///   2. Loop detection and structuring (back-edges → while/do-while)
    ///   3. If/else recovery (forward conditional branches)
    ///   4. Goto/label emission for remaining irreducible edges
    LogicalResult structureFunction(helix::low::FuncOp func) {
        auto& funcBody = func.getBody();

        if (funcBody.empty())
            return success();

        OpBuilder builder(func->getContext());

        // Phase 1: Convert CMOV operations to ternary expressions.
        // This is always safe — it replaces ops in-place without moving blocks.
        unsigned ternaries = convertCmovsToTernary(funcBody, builder);
        NumTernaryRecovered += ternaries;

        // For single-block functions, no CFG structuring is needed.
        if (std::distance(funcBody.begin(), funcBody.end()) <= 1)
            return success();

        // Compute dominance information for the function.
        DominanceInfo domInfo(func);

        // Collect all CFG edges.
        auto edges = collectCFGEdges(funcBody);

        // Track which blocks have been structured (to avoid double-processing).
        llvm::SmallPtrSet<Block*, 16> structuredBlocks;

        // Phase 2: Detect and structure loops using ADDRESS-BASED back-edges.
        //
        // Remill linearizes execution traces into a DAG — each instruction
        // gets a unique MLIR block, so no CFG cycles exist.  Loops in the
        // original binary manifest as jumps to lower addresses.  We detect
        // these by comparing `getOpAddress()` of source and target blocks.
        for (const auto& edge : edges) {
            // Skip if already structured.
            if (structuredBlocks.count(edge.source) ||
                structuredBlocks.count(edge.target))
                continue;

            // Get addresses of source and target blocks.
            uint64_t srcAddr = edge.source->empty()
                ? 0 : getOpAddress(&edge.source->back());
            uint64_t tgtAddr = edge.target->empty()
                ? 0 : getOpAddress(&edge.target->front());

            // Skip edges with unknown addresses.
            if (srcAddr == 0 || tgtAddr == 0)
                continue;

            // An address-based back-edge: target address <= source address
            // means a jump backward in the binary — this is a loop.
            if (tgtAddr > srcAddr)
                continue;

            // Also check dominance-based back-edges (for truly cyclic graphs).
            // But primarily rely on address comparison for Remill DAGs.

            Block* header = edge.target;
            Block* latch  = edge.source;

            NaturalLoop loop;
            loop.header = header;
            loop.latch  = latch;

            // For DAG-structured Remill output, we can't walk predecessors
            // to find the loop body (no cycles).  Instead, collect all blocks
            // between header and latch in the region's block order.
            bool inRange = false;
            for (auto& block : funcBody) {
                if (&block == header)
                    inRange = true;
                if (inRange)
                    loop.body.insert(&block);
                if (&block == latch)
                    break;
            }

            // If the body is empty or header wasn't found before latch, skip.
            if (loop.body.empty() || !loop.body.count(header))
                continue;

            // Extract the loop condition from the latch (do-while style).
            bool atLatch = false;
            loop.condition = extractLoopCondition(latch, header, atLatch);
            if (loop.condition) {
                loop.conditionAtLatch = true;  // Address-based loops → do-while
            } else {
                // Try the header.
                loop.condition = extractLoopCondition(header, header, atLatch);
                loop.conditionAtLatch = false;
            }

            // Structure the loop.
            if (failed(structureLoop(loop, func, builder, domInfo)))
                return failure();

            // Mark all loop body blocks as structured.
            for (Block* b : loop.body)
                structuredBlocks.insert(b);

            LLVM_DEBUG({
                llvm::dbgs() << "  [Addr] Structured loop: 0x"
                             << llvm::Twine::utohexstr(tgtAddr)
                             << " -> 0x" << llvm::Twine::utohexstr(srcAddr)
                             << ", " << loop.body.size() << " blocks\n";
            });
        }

        // Phase 3: Detect and structure if/else patterns in the top-level
        // function body, then recurse into nested regions created by the
        // recovered If/While/DoWhile ops.
        if (failed(structureIfRegions(funcBody, func, builder, structuredBlocks)))
            return failure();
        if (failed(structureNestedControlRegions(funcBody, func, builder)))
            return failure();

        // Phase 4: Emit goto/label for remaining irreducible edges.
        // Re-collect edges since the CFG may have changed.
        DominanceInfo finalDomInfo(func);
        auto remainingEdges = collectCFGEdges(funcBody);
        for (const auto& edge : remainingEdges) {
            // Skip edges where the SOURCE was already structured (its branch
            // has been consumed into a while/if body).  But do NOT skip edges
            // where only the TARGET was structured — those still need labels
            // because unstructured JccOp branches may reference them.
            if (structuredBlocks.count(edge.source))
                continue;

            // Only emit goto for cross-edges and unstructured JMP terminators.
            auto* terminator = edge.source->getTerminator();
            if (!terminator)
                continue;

            bool isJmpOp = isa<helix::low::JmpOp>(terminator);
            bool isJccOp = isa<helix::low::JccOp>(terminator);
            bool isCrossEdge = false;

            // Recompute edge kind (domInfo may be stale but still usable for
            // cross-edge detection on unmodified blocks).
            if (!finalDomInfo.dominates(edge.target, edge.source) &&
                !finalDomInfo.dominates(edge.source, edge.target)) {
                isCrossEdge = true;
            }

            // Also emit goto/label for JccOp branches that target blocks
            // which were consumed into structured regions (IfOp bodies).
            // Without this, PseudoCEmitter generates dangling `goto block_N`
            // that have no corresponding label in the output.
            bool targetsStructuredBlock =
                isJccOp && structuredBlocks.count(edge.target);

            if (isJmpOp || isCrossEdge || targetsStructuredBlock) {
                emitGotoLabel(edge, func, builder);
                ++NumGotoEmitted;
            }
        }

        // Phase 4.5: Ensure ALL JccOp/JmpOp targets anywhere in the function
        // have corresponding LabelOp labels.  Phase 4 only processes edges
        // from the parent function body, but IfOp/WhileOp bodies may contain
        // JccOp ops whose successor blocks are in the parent region or in
        // other nested regions.  Without labels, PseudoCEmitter emits
        // dangling "goto block_N" with no matching label.
        llvm::DenseSet<Block*> labeledBlocks;
        // Collect blocks that already have a LabelOp.
        func.walk([&](helix::high::LabelOp labelOp) {
            labeledBlocks.insert(labelOp->getBlock());
        });

        // Walk all JccOp/JmpOp ops and label their targets.
        func.walk([&](Operation* op) {
            for (unsigned i = 0; i < op->getNumSuccessors(); ++i) {
                Block* succ = op->getSuccessor(i);
                if (labeledBlocks.count(succ))
                    continue;  // Already has a label.
                // Emit a LabelOp at the start of the target block.
                std::string labelName;
                if (!succ->empty()) {
                    uint64_t addr = getOpAddress(&succ->front());
                    if (addr != 0)
                        labelName = std::format("loc_{:x}", addr);
                }
                if (labelName.empty()) {
                    static unsigned globalLabelCounter = 100;
                    labelName = std::format("loc_irr_{}", globalLabelCounter++);
                }
                builder.setInsertionPointToStart(succ);
                auto labelLoc = succ->empty()
                    ? builder.getUnknownLoc()
                    : succ->front().getLoc();
                builder.create<helix::high::LabelOp>(
                    labelLoc,
                    builder.getStringAttr(labelName),
                    IntegerAttr{});
                labeledBlocks.insert(succ);
            }
        });

        return success();
    }

    // ─── Loop Structuring ─────────────────────────────────────────────────

    /// Replace a natural loop with a `helix_high.while` or `helix_high.do_while`
    /// operation depending on where the condition is located.
    ///
    /// - Condition at header → `helix_high.while` (pre-tested loop)
    /// - Condition at latch  → `helix_high.do_while` (post-tested loop)
    LogicalResult structureLoop(NaturalLoop& loop,
                                helix::low::FuncOp func,
                                OpBuilder& builder,
                                const DominanceInfo& domInfo) {
        if (!loop.header) {
            LLVM_DEBUG(llvm::dbgs() << "  Skipping loop with null header\n");
            return success();
        }

        builder.setInsertionPointToStart(loop.header);
        auto loc = loop.header->front().getLoc();

        // Build the condition.  If we recovered a condition value, we use it
        // directly.  Otherwise we emit a `true` constant (infinite loop).
        Value condValue = loop.condition;

        if (loop.conditionAtLatch && condValue) {
            // ── Do-while: condition is at the latch ──────────────────────
            auto doWhileOp = builder.create<helix::high::DoWhileOp>(
                loc, IntegerAttr{});

            // Move loop body blocks into the do-while's body region.
            Region& bodyRegion = doWhileOp.getBodyRegion();
            if (bodyRegion.empty()) {
                auto* bodyBlock = new Block();
                bodyRegion.push_back(bodyBlock);
            }

            // Clone non-terminator operations from body blocks into the region.
            Block& bodyBlock = bodyRegion.front();
            OpBuilder bodyBuilder(builder.getContext());
            bodyBuilder.setInsertionPointToEnd(&bodyBlock);

            for (Block* block : loop.body) {
                if (block == loop.header) {
                    // Move header's non-terminator ops into body.
                    for (auto& op : llvm::make_early_inc_range(block->without_terminator())) {
                        // Skip the do-while op we just created.
                        if (&op == doWhileOp.getOperation())
                            continue;
                        op.moveBefore(&bodyBlock, bodyBlock.end());
                    }
                    continue;
                }
                for (auto& op : llvm::make_early_inc_range(block->without_terminator())) {
                    op.moveBefore(&bodyBlock, bodyBlock.end());
                }
            }

            // Add a yield terminator to the body.
            bodyBuilder.setInsertionPointToEnd(&bodyBlock);
            if (bodyBlock.empty() ||
                !bodyBlock.back().hasTrait<OpTrait::IsTerminator>()) {
                bodyBuilder.create<helix::high::YieldOp>(loc, mlir::Value{});
            }

            // Build the condition region.
            Region& condRegion = doWhileOp.getCondRegion();
            if (condRegion.empty()) {
                auto* condBlock = new Block();
                condRegion.push_back(condBlock);
            }
            Block& condBlock = condRegion.front();
            OpBuilder condBuilder(builder.getContext());
            condBuilder.setInsertionPointToEnd(&condBlock);

            // The condition value may not be valid in the new region context.
            // Create a yield with a true constant as fallback.
            auto i1Ty = condBuilder.getI1Type();
            auto trueConst = condBuilder.create<arith::ConstantOp>(
                loc, i1Ty, condBuilder.getBoolAttr(true));
            condBuilder.create<helix::high::YieldOp>(loc, trueConst.getResult());

            ++NumDoWhileRecovered;

            LLVM_DEBUG({
                llvm::dbgs() << "  Structured do-while loop at header block, "
                             << loop.body.size() << " block(s)\n";
            });

            return success();
        }

        // ── While loop: condition at header (or unknown) ─────────────────
        if (!condValue) {
            auto i1Ty = builder.getI1Type();
            condValue = builder.create<arith::ConstantOp>(
                loc, i1Ty, builder.getBoolAttr(true));
        }

        auto whileOp = builder.create<helix::high::WhileOp>(
            loc, condValue, IntegerAttr{});

        // Move loop body blocks into the while's body region.
        Region& bodyRegion = whileOp.getBodyRegion();
        for (Block* block : loop.body) {
            if (block == loop.header)
                continue;  // Header stays outside; its condition feeds the while
            bodyRegion.getBlocks().splice(bodyRegion.end(),
                block->getParent()->getBlocks(), block->getIterator());
        }

        // If the body region is empty (single-block loop), move the header's
        // non-terminator operations into the body.
        if (bodyRegion.empty()) {
            auto* bodyBlock = new Block();
            bodyRegion.push_back(bodyBlock);

            for (auto& op : llvm::make_early_inc_range(loop.header->without_terminator())) {
                // Skip the while op we just created.
                if (&op == whileOp.getOperation())
                    continue;
                op.moveBefore(bodyBlock, bodyBlock->end());
            }
        }

        // Replace the latch's back-edge terminator with a continue.
        if (!bodyRegion.empty()) {
            Block& latchBlock = bodyRegion.back();
            if (auto* term = latchBlock.getTerminator()) {
                builder.setInsertionPoint(term);
                builder.create<helix::high::ContinueOp>(term->getLoc(), IntegerAttr{});
                term->erase();
            } else {
                builder.setInsertionPointToEnd(&latchBlock);
                builder.create<helix::high::ContinueOp>(loc, IntegerAttr{});
            }
        }

        ++NumWhileRecovered;

        LLVM_DEBUG({
            llvm::dbgs() << "  Structured while loop at header block, "
                         << loop.body.size() << " block(s)\n";
        });

        return success();
    }

    LogicalResult structureIfRegions(
        Region& region,
        helix::low::FuncOp func,
        OpBuilder& builder,
        llvm::SmallPtrSet<Block*, 16>& structuredBlocks) {
        if (region.empty())
            return success();

        while (true) {
            DominanceInfo domInfo(func);
            PostDominanceInfo postDomInfo(func);
            llvm::SmallVector<IfRegion, 8> ifRegions;
            if (failed(recoverIfElse(region, domInfo, postDomInfo,
                                     structuredBlocks, ifRegions)))
                return failure();

            bool changed = false;
            for (auto& ifRegion : ifRegions) {
                if (structuredBlocks.count(ifRegion.branchBlock))
                    continue;

                if (failed(structureIf(ifRegion, func, builder)))
                    return failure();

                structuredBlocks.insert(ifRegion.branchBlock);
                for (Block* b : ifRegion.thenBlocks)
                    structuredBlocks.insert(b);
                for (Block* b : ifRegion.elseBlocks)
                    structuredBlocks.insert(b);
                changed = true;
            }

            if (!changed)
                break;
        }

        return success();
    }

    LogicalResult structureNestedControlRegions(Region& region,
                                                helix::low::FuncOp func,
                                                OpBuilder& builder) {
        llvm::SmallVector<Region*, 8> nestedRegions;
        for (auto& block : region) {
            for (auto& op : block) {
                for (Region& nestedRegion : op.getRegions()) {
                    if (!nestedRegion.empty())
                        nestedRegions.push_back(&nestedRegion);
                }
            }
        }

        for (Region* nestedRegion : nestedRegions) {
            llvm::SmallPtrSet<Block*, 16> nestedStructuredBlocks;
            if (failed(structureIfRegions(*nestedRegion, func, builder,
                                          nestedStructuredBlocks)))
                return failure();
            if (failed(structureNestedControlRegions(*nestedRegion, func, builder)))
                return failure();
        }

        return success();
    }

    // ─── If/Else Recovery ─────────────────────────────────────────────────

    /// Scan the function body for forward conditional branches and build
    /// IfRegion descriptors for each.
    ///
    /// Improved: relaxed convergence detection walks multiple blocks forward
    /// to find the merge point, instead of requiring direct convergence.
    LogicalResult recoverIfElse(Region& funcBody,
                                const DominanceInfo& domInfo,
                                const PostDominanceInfo& postDomInfo,
                                const llvm::SmallPtrSet<Block*, 16>& structuredBlocks,
                                llvm::SmallVectorImpl<IfRegion>& result) {
        llvm::SmallPtrSet<Block*, 16> regionBlocks;
        for (auto& block : funcBody)
            regionBlocks.insert(&block);

        for (auto& block : funcBody) {
            // Skip blocks already structured (e.g., as part of a loop).
            if (structuredBlocks.count(&block))
                continue;

            auto* terminator = block.getTerminator();
            if (!terminator)
                continue;

            // Only consider conditional branches (2 successors).
            if (terminator->getNumSuccessors() != 2)
                continue;

            Block* trueTarget  = terminator->getSuccessors()[0];
            Block* falseTarget = terminator->getSuccessors()[1];

            // Skip back-edges (loops are handled separately).
            if (domInfo.dominates(trueTarget, &block) ||
                domInfo.dominates(falseTarget, &block))
                continue;

            // For a structured if, the branch block must dominate at least
            // one of the targets.
            bool dominatesTrue  = domInfo.dominates(&block, trueTarget);
            bool dominatesFalse = domInfo.dominates(&block, falseTarget);

            if (!dominatesTrue && !dominatesFalse)
                continue;  // Irreducible — handled by goto/label

            // Extract the condition operand.
            Value condition;
            if (terminator->getNumOperands() >= 1)
                condition = terminator->getOperand(0);

            IfRegion ifRegion;
            ifRegion.branchBlock = &block;
            ifRegion.condition   = condition;

            const bool trueInRegion = regionBlocks.count(trueTarget);
            const bool falseInRegion = regionBlocks.count(falseTarget);

            if (trueInRegion != falseInRegion) {
                Block* localTarget = trueInRegion ? trueTarget : falseTarget;
                Block* mergeBlock = trueInRegion ? falseTarget : trueTarget;
                ifRegion.invertCondition = !trueInRegion;
                ifRegion.thenBlocks =
                    collectPathBlocks(localTarget, mergeBlock, &block);
                if (ifRegion.thenBlocks.empty())
                    ifRegion.thenBlocks.push_back(localTarget);
                ifRegion.mergeBlock = mergeBlock;
                ifRegion.hasElse = false;
                result.push_back(std::move(ifRegion));
                continue;
            }

            if (dominatesTrue && dominatesFalse) {
                // Both targets dominated → if/else with a merge point.
                // Use relaxed merge detection: walk forward from both targets
                // to find a common successor.
                Block* mergeBlock = findMergeBlock(
                    trueTarget, falseTarget, &block, domInfo, postDomInfo, 32);

                if (mergeBlock && mergeBlock != trueTarget &&
                    mergeBlock != falseTarget) {
                    // Collect blocks on the then-path and else-path up to merge.
                    ifRegion.thenBlocks = collectPathBlocks(trueTarget, mergeBlock, &block);
                    ifRegion.elseBlocks = collectPathBlocks(falseTarget, mergeBlock, &block);
                    ifRegion.mergeBlock = mergeBlock;
                    ifRegion.hasElse = true;
                } else {
                    // No merge found — prefer a multi-block if-without-else
                    // over immediately falling back to goto spaghetti.
                    ifRegion.thenBlocks =
                        collectPathBlocks(trueTarget, falseTarget, &block);
                    if (ifRegion.thenBlocks.empty())
                        ifRegion.thenBlocks.push_back(trueTarget);
                    ifRegion.mergeBlock = falseTarget;
                    ifRegion.hasElse = false;
                }
            } else if (dominatesTrue) {
                // Only true target dominated → if-without-else.
                ifRegion.thenBlocks =
                    collectPathBlocks(trueTarget, falseTarget, &block);
                if (ifRegion.thenBlocks.empty())
                    ifRegion.thenBlocks.push_back(trueTarget);
                ifRegion.mergeBlock = falseTarget;
                ifRegion.hasElse = false;
            } else {
                // Only false target dominated → inverted if (negate condition).
                ifRegion.invertCondition = true;
                ifRegion.thenBlocks =
                    collectPathBlocks(falseTarget, trueTarget, &block);
                if (ifRegion.thenBlocks.empty())
                    ifRegion.thenBlocks.push_back(falseTarget);
                ifRegion.mergeBlock = trueTarget;
                ifRegion.hasElse = false;
            }

            result.push_back(std::move(ifRegion));
        }

        return success();
    }

    /// Replace a detected if/else pattern with a `helix_high.if` operation.
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

        Value ifCondition = ifRegion.condition;
        if (ifRegion.invertCondition && ifCondition &&
            ifCondition.getType().isInteger(1)) {
            auto trueConst = builder.create<arith::ConstantOp>(
                loc, builder.getI1Type(), builder.getBoolAttr(true));
            ifCondition = builder.create<arith::XOrIOp>(
                loc, ifCondition, trueConst);
        }

        // Create the helix_high.if operation.
        auto ifOp = builder.create<helix::high::IfOp>(
            loc, ifCondition, IntegerAttr{});

        // Move then-blocks into the IfOp's then-region.
        Region& thenRegion = ifOp.getThenRegion();
        for (Block* block : ifRegion.thenBlocks) {
            thenRegion.getBlocks().splice(thenRegion.end(),
                block->getParent()->getBlocks(), block->getIterator());
        }
        rewriteStructuredRegionExits(thenRegion, ifRegion.mergeBlock, builder);

        // Ensure the then-region has a yield/terminator.
        if (!thenRegion.empty()) {
            Block& lastThen = thenRegion.back();
            if (lastThen.empty() ||
                !lastThen.back().hasTrait<OpTrait::IsTerminator>()) {
                builder.setInsertionPointToEnd(&lastThen);
                builder.create<helix::high::YieldOp>(loc, mlir::Value{});
            }
        }

        // Move else-blocks into the IfOp's else-region (if present).
        if (ifRegion.hasElse) {
            Region& elseRegion = ifOp.getElseRegion();
            for (Block* block : ifRegion.elseBlocks) {
                elseRegion.getBlocks().splice(elseRegion.end(),
                    block->getParent()->getBlocks(), block->getIterator());
            }
            rewriteStructuredRegionExits(elseRegion, ifRegion.mergeBlock, builder);

            // Ensure the else-region has a yield/terminator.
            if (!elseRegion.empty()) {
                Block& lastElse = elseRegion.back();
                if (lastElse.empty() ||
                    !lastElse.back().hasTrait<OpTrait::IsTerminator>()) {
                    builder.setInsertionPointToEnd(&lastElse);
                    builder.create<helix::high::YieldOp>(loc, mlir::Value{});
                }
            }
        }

        // Replace the original conditional branch with a fallthrough to the
        // merge block (if it exists).
        builder.setInsertionPoint(terminator);
        if (auto mergeRet = findTrivialReturnOp(ifRegion.mergeBlock)) {
            auto retAddr = mergeRet->getAttrOfType<IntegerAttr>("address");
            builder.create<helix::low::RetOp>(loc, retAddr);
        } else if (ifRegion.mergeBlock) {
            builder.create<helix::low::JmpOp>(loc, IntegerAttr{}, IntegerAttr{}, ifRegion.mergeBlock);
        } else {
            // If there's no merge block, both paths diverge (e.g. return).
            builder.create<helix::low::RetOp>(loc, IntegerAttr{});
        }
        terminator->erase();

        ++NumIfRecovered;

        LLVM_DEBUG({
            llvm::dbgs() << "  Structured if"
                         << (ifRegion.hasElse ? "/else" : "")
                         << " at block\n";
        });

        return success();
    }

    // ─── Irreducible Fallback: goto/label ─────────────────────────────────

    /// Emit a `helix_high.goto` / `helix_high.label` pair for an edge
    /// that could not be structured into if/while.
    ///
    /// This is the fallback for irreducible control flow.  The resulting
    /// pseudo-C will contain explicit gotos, which is unfortunate but correct.
    void emitGotoLabel(const CFGEdge& edge,
                       helix::low::FuncOp func,
                       OpBuilder& builder) {
        // Generate a label name from the target block's address.
        std::string labelName;
        if (!edge.target->empty()) {
            uint64_t addr = getOpAddress(&edge.target->front());
            if (addr != 0) {
                labelName = std::format("loc_{:x}", addr);
            }
        }
        if (labelName.empty()) {
            static unsigned gotoCounter = 0;
            labelName = std::format("loc_irr_{}", gotoCounter++);
        }

        // Check if the target block already has a label with this name
        // (avoid duplicate labels for multiple gotos to the same target).
        bool hasLabel = false;
        for (auto& op : *edge.target) {
            if (auto existingLabel = dyn_cast<helix::high::LabelOp>(&op)) {
                if (existingLabel.getName() == labelName) {
                    hasLabel = true;
                    break;
                }
            }
        }

        // Insert the label at the beginning of the target block.
        if (!hasLabel) {
            builder.setInsertionPointToStart(edge.target);
            auto labelLoc = edge.target->empty()
                ? builder.getUnknownLoc()
                : edge.target->front().getLoc();
            builder.create<helix::high::LabelOp>(
                labelLoc,
                builder.getStringAttr(labelName),
                IntegerAttr{});
        }

        // Replace the source block's branch to the target with a goto.
        auto* terminator = edge.source->getTerminator();
        if (terminator) {
            builder.setInsertionPoint(terminator);
            builder.create<helix::high::GotoOp>(
                terminator->getLoc(),
                builder.getStringAttr(labelName),
                IntegerAttr{});

            // If the terminator is an unconditional JMP with only this one
            // successor, we can safely erase it since the goto replaces it.
            if (isa<helix::low::JmpOp>(terminator)) {
                terminator->erase();
            }
            // For conditional branches (JccOp), we do NOT erase the terminator
            // because it may have another successor that was already structured.
            // The goto is emitted before the terminator as a marker for the
            // PseudoCEmitter.
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
