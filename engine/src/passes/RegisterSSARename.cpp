/// @file RegisterSSARename.cpp
/// @brief Per-function SSA versioning pass for HelixLow `reg.read`/`reg.write` ops.
///
/// Tags every `helix_low.reg.read` and `helix_low.reg.write` with a discardable
/// integer attribute `ssa_version` that disambiguates distinct logical defs of
/// the same physical register inside a function.  Downstream `HelixLowToMid`
/// then packs `(name_hash << 16) | version` into the slot_id, so reads and
/// writes of the SAME register at DIFFERENT program points get DIFFERENT slot
/// ids — eliminating the FIX-087 collision class where every RAX usage in a
/// function collapsed onto a single `v0`, producing bugs like
/// `v0 = *v0->field_18;`.
///
/// Design (approved 2026-05-20):
///   - No phi insertion.  At join points where predecessors disagree we stamp
///     the marker `kMergeVersion = 0xFFFFFFFE`.  Loop-iteration values that
///     legitimately share a register across iterations end up sharing the same
///     mid-tier slot — acceptable.
///   - kLiveInVersion = 0 marks the function entry value of a register (the
///     incoming ABI value).  All reads in the entry block, and any read whose
///     register hasn't been written yet on the path from entry, get version 0.
///   - Blocks are visited in BFS pre-order from entry.  No DominanceInfo (it
///     asserts on irreducible/unreachable CFGs — see StructureControlFlow's
///     `hasIrreducibleSCCs` guard).  Back-edges contribute kLiveInVersion to
///     the join (treated as "not yet visited"); this is correct for the join
///     semantics we need — the read at the loop header either sees the
///     incoming value or the previous-iteration value, and we conservatively
///     stamp `kMergeVersion` for that case.
///   - Optional: discardable attribute.  Pipelines that skip this pass keep
///     working — `HelixLowToMid` defaults the version to 0 and emits a debug
///     trace.
///
/// FIX-087 — 2026-05-20.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "helix-register-ssa-rename"

using namespace mlir;
using namespace helix;

namespace {

/// Reserved versions.
///   0           — live-in / function-entry value of the register.
///   0xFFFFFFFE  — "merge" / join-point disagreement (no phi inserted).
///   1..         — explicit defs allocated in textual order.
constexpr uint32_t kLiveInVersion = 0;
constexpr uint32_t kMergeVersion  = 0xFFFFFFFE;

struct PerFunctionState {
    /// Next free version number per register name.
    /// Starts at 1 because 0 is reserved for kLiveInVersion.
    llvm::StringMap<uint32_t> nextVersion;

    /// At any point during the walk, the "current" SSA version of each
    /// register on the path from entry.  Reset at every block entry by
    /// reconciliation against the predecessors' exit-versions.
    llvm::StringMap<uint32_t> currentVersion;

    void reset() {
        nextVersion.clear();
        currentVersion.clear();
    }
};

struct RegisterSSARenamePass
    : public PassWrapper<RegisterSSARenamePass, OperationPass<ModuleOp>>
{
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RegisterSSARenamePass)

    StringRef getArgument() const final { return "helix-register-ssa-rename"; }
    StringRef getDescription() const final {
        return "Stamp ssa_version on helix_low.reg.read/reg.write so the "
               "slot_id key in HelixLowToMid becomes injective for distinct "
               "logical defs of the same physical register.";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::low::HelixLowDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();
        module.walk([&](helix::low::FuncOp func) {
            renameFunction(func);
        });
    }

private:
    /// Stamp `ssa_version` on every reg.read/reg.write in `func`.
    void renameFunction(helix::low::FuncOp func) {
        auto& body = func.getBody();
        if (body.empty()) return;
        Block* entry = &body.front();
        if (!entry) return;

        // Step 1: BFS pre-order over reachable blocks from the entry.
        llvm::SmallVector<Block*, 32> rpo;
        llvm::SmallPtrSet<Block*, 32> visited;
        {
            llvm::SmallVector<Block*, 32> worklist;
            worklist.push_back(entry);
            while (!worklist.empty()) {
                Block* b = worklist.pop_back_val();
                if (!visited.insert(b).second) continue;
                rpo.push_back(b);
                // Push successors so the worklist gets popped in textual
                // order (BFS-ish).  Successor order itself is fine — the
                // visited set ensures each block is processed once.
                for (Block* succ : b->getSuccessors())
                    worklist.push_back(succ);
            }
        }

        // Step 2: walk blocks in `rpo` order; maintain per-block exit maps.
        PerFunctionState state;
        llvm::DenseMap<Block*, llvm::StringMap<uint32_t>> exitVersions;
        llvm::SmallPtrSet<Block*, 32> done;

        unsigned tagged = 0;
        for (Block* block : rpo) {
            reconcileEntryVersions(block, exitVersions, done, state);
            renameBlock(block, state, tagged);
            exitVersions[block] = state.currentVersion;  // snapshot
            done.insert(block);
        }

        LLVM_DEBUG(llvm::dbgs() << "[register-ssa] " << func.getSymName()
                                << ": tagged " << tagged << " reg ops across "
                                << rpo.size() << " reachable blocks ("
                                << state.nextVersion.size() << " distinct regs)\n");
    }

    /// Compute state.currentVersion at the entry of `block` by merging the
    /// exit-versions of all predecessors that have already been processed.
    /// Back-edge preds (not yet processed) contribute kLiveInVersion.
    void reconcileEntryVersions(
        Block* block,
        const llvm::DenseMap<Block*, llvm::StringMap<uint32_t>>& exitVersions,
        const llvm::SmallPtrSet<Block*, 32>& done,
        PerFunctionState& state)
    {
        state.currentVersion.clear();

        // Entry block: every register is live-in.  Leave map empty; reads
        // will get kLiveInVersion via the default-not-found branch.
        auto preds = block->getPredecessors();
        bool hasPred = preds.begin() != preds.end();
        if (!hasPred)
            return;

        // Collect contributions from each pred.  If a pred isn't done yet
        // (back-edge), treat it as kLiveInVersion for all regs.
        // Per-register aggregation: every observed value must agree, else
        // we stamp kMergeVersion.
        llvm::StringMap<uint32_t> merged;
        llvm::StringMap<bool> seen;  // true once a reg has at least one entry
        llvm::StringMap<bool> disagreed;

        // Union of register names mentioned by any pred's exit map (and
        // implicitly: any reg not mentioned == kLiveInVersion).
        llvm::StringMap<bool> regUniverse;
        for (Block* pred : preds) {
            auto it = exitVersions.find(pred);
            if (it == exitVersions.end()) continue;
            for (const auto& kv : it->second)
                regUniverse[kv.first()] = true;
        }

        for (auto& kv : regUniverse) {
            llvm::StringRef regName = kv.first();
            uint32_t agreed = 0;
            bool firstSet = false;
            bool conflict = false;

            for (Block* pred : preds) {
                uint32_t contribution;
                if (!done.contains(pred)) {
                    // Back-edge: assume live-in.
                    contribution = kLiveInVersion;
                } else {
                    auto eit = exitVersions.find(pred);
                    if (eit == exitVersions.end()) {
                        contribution = kLiveInVersion;
                    } else {
                        auto rit = eit->second.find(regName);
                        contribution = (rit == eit->second.end())
                            ? kLiveInVersion
                            : rit->getValue();
                    }
                }

                if (!firstSet) {
                    agreed = contribution;
                    firstSet = true;
                } else if (agreed != contribution) {
                    conflict = true;
                    break;
                }
            }

            if (firstSet) {
                merged[regName] = conflict ? kMergeVersion : agreed;
            }
        }

        state.currentVersion = std::move(merged);
    }

    /// Walk operations in `block`; tag every reg.read and reg.write with the
    /// `ssa_version` discardable attribute and update state.currentVersion.
    void renameBlock(Block* block, PerFunctionState& state, unsigned& tagged) {
        auto* ctx = &getContext();
        auto u32 = IntegerType::get(ctx, 32, IntegerType::Unsigned);

        for (Operation& op : *block) {
            if (auto rw = dyn_cast<helix::low::RegWriteOp>(&op)) {
                llvm::StringRef regName = rw.getRegName();
                // Allocate a fresh version (>= 1).
                auto it = state.nextVersion.find(regName);
                uint32_t next = (it == state.nextVersion.end()) ? 1u : it->second;
                rw->setAttr("ssa_version", IntegerAttr::get(u32, next));
                state.nextVersion[regName] = next + 1;
                state.currentVersion[regName] = next;
                ++tagged;
                continue;
            }
            if (auto rr = dyn_cast<helix::low::RegReadOp>(&op)) {
                llvm::StringRef regName = rr.getRegName();
                auto it = state.currentVersion.find(regName);
                uint32_t v = (it == state.currentVersion.end())
                    ? kLiveInVersion
                    : it->getValue();
                rr->setAttr("ssa_version", IntegerAttr::get(u32, v));
                ++tagged;
                continue;
            }
            // Other ops (call, cmp, binop, mem.read/write) may carry
            // implicit register semantics in their flag/result outputs, but
            // those are converted later by HelixLowToMid into fresh SSA
            // values that don't need versioning here.  We only stamp the
            // explicit reg.read / reg.write ops.
        }
    }
};

} // anonymous namespace

namespace helix {
std::unique_ptr<mlir::Pass> createRegisterSSARenamePass() {
    return std::make_unique<RegisterSSARenamePass>();
}
} // namespace helix
