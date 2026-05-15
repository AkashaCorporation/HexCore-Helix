/// @file RecoverSwitchTables.cpp
/// @brief MLIR pass: recovers switch statements from indirect jumps through
///        jump tables by analysing backward data-flow slices and reading
///        table entries from the binary image.
///
/// ## Algorithm
///
///   1. Walk all `helix_low.jmp` operations in the module.
///   2. For each jmp whose target is computed (no fixed target_addr attribute),
///      run the JumpTableAnalyzer to detect a jump table pattern.
///   3. If analysis succeeds, replace the indirect jmp with a chain of
///      `cf::CondBranchOp` operations annotated with `"helix.switch"` metadata,
///      or (when available) a `helix_high.switch` operation.
///   4. Update predecessor/successor relationships.
///
/// ## DataSectionProvider Access
///
/// MLIR passes cannot easily accept constructor arguments.  The Pipeline
/// sets a thread-local DataSectionProvider pointer before running the pass
/// pipeline; this pass reads it via `getActiveDataSectionProvider()`.
///
/// ## Note on Switch Representation
///
/// The ideal representation would be a dedicated `helix_low.switch` TableGen
/// op carrying the selector, case values (DenseI64ArrayAttr), case block
/// successors, and a default block successor.  Since we cannot add new ops to
/// TableGen without rebuilding the generated headers, this pass uses an
/// interim representation:
///
///   **Strategy**: Emit a cascade of `helix_low.jcc` ops (one per case),
///   each annotated with a `"helix.switch_case"` DictionaryAttr containing
///   the case value.  The final fallthrough targets the default block.
///   The StructureControlFlow pass (P0.3) recognises this annotated cascade
///   and folds it into a single `helix_high.switch` op.
///
///   **Proper implementation** (once TableGen is rebuilt):
///   Define `HelixLow_SwitchOp` with:
///     - `$selector : AnyInteger`
///     - `$case_values : DenseI64ArrayAttr`
///     - `$caseDestinations : VariadicSuccessor<AnySuccessor>`
///     - `$defaultDestination : AnySuccessor`
///   Then this pass creates that op directly.
///
/// ## References
///
///   - Cifuentes, "Reverse Compilation Techniques" (1994), Ch. 6.4
///   - "Recovering Switch Statements from Optimized Code" (Enders et al.)

#include "helix/passes/Passes.h"
#include "helix/analysis/JumpTableAnalysis.h"
#include "helix/analysis/DataSectionProvider.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
#include "mlir/IR/Block.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#include <cstdint>
#include <format>

#define DEBUG_TYPE "recover-switch-tables"

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// Statistics
// ═══════════════════════════════════════════════════════════════════════════════

STATISTIC(NumIndirectJmpsAnalysed, "Number of indirect jmps analysed");
STATISTIC(NumSwitchesRecovered,    "Number of switch tables recovered");
STATISTIC(NumCasesRecovered,       "Number of individual switch cases recovered");

// ═══════════════════════════════════════════════════════════════════════════════
// Thread-Local DataSectionProvider Access
// ═══════════════════════════════════════════════════════════════════════════════

/// Thread-local pointer to the active DataSectionProvider.
///
/// The Pipeline sets this before running the pass pipeline and clears it
/// after.  This avoids the need to pass the provider through MLIR's pass
/// infrastructure, which does not support constructor arguments for passes
/// created via factory functions.
static thread_local const DataSectionProvider* g_activeDataProvider = nullptr;

namespace helix {

void setActiveDataSectionProvider(const DataSectionProvider* provider) {
    g_activeDataProvider = provider;
}

const DataSectionProvider* getActiveDataSectionProvider() {
    return g_activeDataProvider;
}

} // namespace helix

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// Address → Block Map
// ═══════════════════════════════════════════════════════════════════════════════

/// Build a mapping from binary addresses to MLIR blocks.
///
/// Each block in a `helix_low.func` starts with operations that carry an
/// `address` attribute corresponding to the first instruction's address.
/// We use this to resolve jump table target addresses to blocks.
static llvm::DenseMap<uint64_t, Block*>
buildAddressToBlockMap(low::FuncOp funcOp) {
    llvm::DenseMap<uint64_t, Block*> map;

    for (Block& block : funcOp.getBody()) {
        // Use the address of the first op that has an address attribute.
        for (Operation& op : block) {
            if (auto addrAttr = op.getAttrOfType<IntegerAttr>("address")) {
                uint64_t addr = addrAttr.getUInt();
                if (addr != 0) {
                    map.try_emplace(addr, &block);
                    break;
                }
            }
        }
    }

    return map;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Switch Emission (Annotated Cascade)
// ═══════════════════════════════════════════════════════════════════════════════

/// Emit the recovered switch as an annotated cascade of conditional branches.
///
/// This is the interim representation until a proper HelixLow_SwitchOp is
/// available.  Each case becomes:
///
///   %cmp_flags = helix_low.cmp %selector, case_value_i
///   helix_low.jcc "z" %cmp_flags:zero, ^case_block_i, ^next_check
///     { "helix.switch_case" = { value = case_value_i } }
///
/// The final next_check block jumps to the default target.
///
/// The StructureControlFlow pass detects this pattern (a chain of jcc ops
/// with "helix.switch_case" annotations sharing the same selector) and
/// folds them into a single `helix_high.switch` op.
static bool emitSwitchCascade(
        low::JmpOp jmpOp,
        const JumpTableInfo& info,
        const llvm::DenseMap<uint64_t, Block*>& addrMap,
        OpBuilder& builder) {

    Block* jmpBlock = jmpOp->getBlock();
    if (!jmpBlock)
        return false;

    Region* parentRegion = jmpBlock->getParent();
    if (!parentRegion)
        return false;

    Location loc = jmpOp.getLoc();

    // We require the analyzer to have given us a usable default target.
    // Without one we used to fabricate a `RetOp` block — which silently
    // claimed "this function ends here on the default branch" and made
    // downstream structuring lose every case body.  Refuse instead, leaving
    // the original indirect jmp untouched so a later pass / human can see
    // that switch recovery didn't complete.
    Block* defaultBlock = info.default_target;
    if (!defaultBlock) {
        LLVM_DEBUG(llvm::dbgs()
            << "RST: refusing to lower switch without a known default target\n");
        return false;
    }

    // Find the address of the default target so we can dedupe cases that
    // map to it (typical in TwoLevel: every selector outside the active set
    // is encoded as pointing to the default handler).
    std::optional<uint64_t> defaultAddr;
    for (auto& [addr, blk] : addrMap) {
        if (blk == defaultBlock) { defaultAddr = addr; break; }
    }

    // Sanity-check that the analyzer gave us parallel targets[] / case_values[].
    if (info.case_values.size() != info.targets.size()) {
        LLVM_DEBUG(llvm::dbgs()
            << "RST: case_values/targets size mismatch ("
            << info.case_values.size() << " vs "
            << info.targets.size() << "), refusing to lower\n");
        return false;
    }

    // Resolve target addresses to blocks, skipping entries that fall through
    // to the default (no-op cases) and unresolved addresses.
    llvm::SmallVector<Block*, 64> caseBlocks;
    llvm::SmallVector<int64_t, 64> caseValues;
    for (size_t i = 0; i < info.targets.size(); ++i) {
        uint64_t targetAddr = info.targets[i];
        if (defaultAddr && targetAddr == *defaultAddr)
            continue;  // default-bound entry — would be a redundant cmp
        auto it = addrMap.find(targetAddr);
        if (it == addrMap.end()) {
            LLVM_DEBUG(llvm::dbgs()
                << "RST: cannot resolve target address 0x"
                << llvm::Twine::utohexstr(targetAddr)
                << " for case value " << info.case_values[i] << "\n");
            continue;
        }
        caseBlocks.push_back(it->second);
        caseValues.push_back(info.case_values[i]);
    }

    if (caseBlocks.empty())
        return false;

    // ── Build the comparison cascade ─────────────────────────────────────
    //
    // We replace the original jmp with a chain of blocks:
    //
    //   jmpBlock (original, rewritten):
    //     %cmp0 = cmp selector, 0
    //     jcc "z" %cmp0:zf → case_0, ^check_1
    //       { "helix.switch_case" = { value = 0 } }
    //
    //   ^check_1:
    //     %cmp1 = cmp selector, 1
    //     jcc "z" %cmp1:zf → case_1, ^check_2
    //       { "helix.switch_case" = { value = 1 } }
    //
    //   ...
    //
    //   ^check_N:
    //     jmp ^default
    //       { "helix.switch_default" }

    // Set insertion point just before the old jmp.
    builder.setInsertionPoint(jmpOp);

    // If we don't have the selector as an SSA value, we need to find it.
    // The selector should be an integer value used in the CMP that guards
    // the switch.  Fall back to creating one from the guard if needed.
    Value selector = info.selector_value;
    if (!selector) {
        LLVM_DEBUG(llvm::dbgs()
            << "RST: no selector value, cannot emit switch\n");
        return false;
    }

    // Ensure the selector has the right integer type for CMP.
    // It should already be an integer type from the HelixLow representation.

    Block* currentBlock = jmpBlock;

    for (unsigned i = 0; i < caseBlocks.size(); ++i) {
        // Create a new block for the next check (unless this is the last case).
        Block* nextCheckBlock = nullptr;
        if (i + 1 < caseBlocks.size()) {
            nextCheckBlock = new Block();
            parentRegion->getBlocks().insertAfter(
                Region::iterator(currentBlock), nextCheckBlock);
        }

        Block* falseTarget = nextCheckBlock ? nextCheckBlock : defaultBlock;

        // Create the comparison: cmp selector, case_value_i
        auto caseConst = builder.create<arith::ConstantIntOp>(
            loc, caseValues[i], selector.getType());

        auto cmpOp = builder.create<low::CmpOp>(
            loc,
            builder.getI1Type(),  // carry_flag
            builder.getI1Type(),  // zero_flag
            builder.getI1Type(),  // sign_flag
            builder.getI1Type(),  // overflow_flag
            selector,
            caseConst.getResult(),
            /*address=*/IntegerAttr{});

        // Create the conditional branch: jcc "z" (zero flag == equal)
        auto jccOp = builder.create<low::JccOp>(
            loc,
            builder.getStringAttr("z"),
            cmpOp.getZeroFlag(),
            /*address=*/IntegerAttr{},
            caseBlocks[i],
            falseTarget);

        // Annotate with switch metadata so StructureControlFlow can
        // recognise this as part of a switch cascade.
        jccOp->setAttr("helix.switch_case",
            builder.getDictionaryAttr({
                builder.getNamedAttr("value",
                    builder.getI64IntegerAttr(caseValues[i])),
                builder.getNamedAttr("selector",
                    builder.getStringAttr("switch")),
            }));

        // If there's a next check block, move the insertion point there.
        if (nextCheckBlock) {
            builder.setInsertionPointToEnd(nextCheckBlock);
            currentBlock = nextCheckBlock;
        }
    }

    // After the last case check, emit a jump to the default block
    // (if we didn't already set it as the false target of the last jcc).
    if (caseBlocks.size() > 0) {
        // The last jcc already targets defaultBlock as its false successor,
        // so no additional jump is needed.
    }

    // Annotate the first jcc in the cascade with the full switch metadata.
    // This allows StructureControlFlow to reconstruct the complete switch.
    if (auto firstJcc = dyn_cast<low::JccOp>(jmpBlock->getTerminator())) {
        firstJcc->setAttr("helix.switch_head",
            builder.getDictionaryAttr({
                builder.getNamedAttr("num_cases",
                    builder.getI64IntegerAttr(caseBlocks.size())),
                builder.getNamedAttr("pattern",
                    builder.getStringAttr(
                        info.pattern == JumpTablePattern::Direct ? "direct" :
                        info.pattern == JumpTablePattern::PICRelative ? "pic_relative" :
                        "two_level")),
            }));
    }

    // Remove the original indirect jmp.
    jmpOp->erase();

    ++NumSwitchesRecovered;
    NumCasesRecovered += caseBlocks.size();

    LLVM_DEBUG(llvm::dbgs()
        << "RST: recovered switch with " << caseBlocks.size()
        << " cases from table at 0x"
        << llvm::Twine::utohexstr(info.base_addr) << "\n");

    return true;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Definition
// ═══════════════════════════════════════════════════════════════════════════════

struct RecoverSwitchTablesPass
    : public PassWrapper<RecoverSwitchTablesPass, OperationPass<ModuleOp>>
{
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RecoverSwitchTablesPass)

    StringRef getArgument() const final { return "recover-switch-tables"; }
    StringRef getDescription() const final {
        return "Recover switch/jump tables from indirect branches (P0.2)";
    }

    void runOnOperation() override {
        auto module = getOperation();

        // Check if a DataSectionProvider is available.
        const DataSectionProvider* provider = g_activeDataProvider;
        if (!provider || !provider->isAvailable()) {
            LLVM_DEBUG(llvm::dbgs()
                << "RST: DataSectionProvider not available, skipping pass\n");
            // Mark the module so downstream passes know switch recovery
            // was skipped (not failed).
            module->setAttr("helix.switch_recovery_skipped",
                UnitAttr::get(&getContext()));
            return;
        }

        JumpTableAnalyzer analyzer(*provider);

        // Process each function.
        module.walk([&](low::FuncOp funcOp) {
            processFunction(funcOp, analyzer);
        });
    }

private:
    void processFunction(low::FuncOp funcOp, JumpTableAnalyzer& analyzer) {
        // Build the address → block map for this function.
        auto addrMap = buildAddressToBlockMap(funcOp);
        if (addrMap.empty())
            return;

        // Collect indirect jmps first (iterating while modifying is unsafe).
        llvm::SmallVector<low::JmpOp, 8> indirectJmps;
        funcOp.walk([&](low::JmpOp jmpOp) {
            // A jmp without a target_addr, or with target_addr == 0, is
            // potentially indirect.
            if (!jmpOp.getTargetAddr().has_value() ||
                jmpOp.getTargetAddr().value() == 0) {
                indirectJmps.push_back(jmpOp);
            }
        });

        if (indirectJmps.empty())
            return;

        OpBuilder builder(funcOp->getContext());

        for (low::JmpOp jmpOp : indirectJmps) {
            ++NumIndirectJmpsAnalysed;

            auto info = analyzer.analyze(jmpOp);
            if (!info) {
                LLVM_DEBUG(llvm::dbgs()
                    << "RST: analysis failed for jmp at "
                    << jmpOp.getLoc() << "\n");
                continue;
            }

            emitSwitchCascade(jmpOp, *info, addrMap, builder);
        }
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Factory
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createRecoverSwitchTablesPass() {
    return std::make_unique<RecoverSwitchTablesPass>();
}
