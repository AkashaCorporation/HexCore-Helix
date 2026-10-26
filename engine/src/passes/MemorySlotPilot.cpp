/// @file MemorySlotPilot.cpp
/// @brief Opt-in MLIR mem2reg pilot for explicit HelixMid storage slots.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixMidOps.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Analysis/DataFlow/ConstantPropagationAnalysis.h"
#include "mlir/Analysis/DataFlow/DeadCodeAnalysis.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Transforms/Mem2Reg.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"

using namespace mlir;

namespace {

static unsigned materializeSafeSingleBlockStackSlots(ModuleOp module) {
    SmallVector<helix::mid::VarDeclOp, 32> declarations;
    module.walk([&](helix::mid::VarDeclOp declaration) {
        if (declaration.getSlotKind() == helix::mid::SlotKind::Stack)
            declarations.push_back(declaration);
    });

    unsigned materialized = 0;
    for (helix::mid::VarDeclOp declaration : declarations) {
        auto function = declaration->getParentOfType<helix::low::FuncOp>();
        if (!function || !function.getBody().hasOneBlock())
            continue;
        Block& entry = function.getBody().front();
        if (declaration->getBlock() != &entry)
            continue;

        const uint32_t slotId = declaration.getSlotId();
        unsigned declarationCount = 0;
        bool hasHighAlias = false;
        SmallVector<helix::mid::VarRefOp, 16> references;
        SmallVector<helix::mid::AssignOp, 16> assignments;
        function.walk([&](helix::mid::VarDeclOp other) {
            if (other.getSlotId() == slotId)
                ++declarationCount;
        });
        function.walk([&](helix::mid::VarRefOp reference) {
            if (reference.getSlotId() == slotId)
                references.push_back(reference);
        });
        function.walk([&](helix::mid::AssignOp assignment) {
            if (assignment.getSlotId() == slotId)
                assignments.push_back(assignment);
        });
        function.walk([&](helix::high::VarRefOp reference) {
            if (reference.getVarId() == slotId)
                hasHighAlias = true;
        });
        if (declarationCount != 1 || hasHighAlias ||
            (references.empty() && assignments.empty() &&
             !declaration.getInit())) {
            continue;
        }

        Type valueType;
        auto mergeType = [&](Type candidate) {
            if (!candidate)
                return true;
            if (!valueType) {
                valueType = candidate;
                return true;
            }
            return valueType == candidate;
        };
        bool safe = declaration.getInit()
            ? mergeType(declaration.getInit().getType())
            : true;
        for (helix::mid::VarRefOp reference : references) {
            if (reference->getBlock() != &entry ||
                !mergeType(reference.getResult().getType())) {
                safe = false;
                break;
            }
            for (Operation* user : reference.getResult().getUsers()) {
                if (auto unary = dyn_cast<helix::mid::UnExprOp>(user)) {
                    if (unary.getKind() == helix::mid::UnExprKind::AddrOf) {
                        safe = false;
                        break;
                    }
                }
            }
            if (!safe)
                break;
        }
        for (helix::mid::AssignOp assignment : assignments) {
            if (assignment->getBlock() != &entry ||
                !mergeType(assignment.getValue().getType())) {
                safe = false;
                break;
            }
        }
        if (!safe || !valueType)
            continue;

        OpBuilder allocationBuilder(&entry, entry.begin());
        auto slotType = helix::mid::SlotType::get(
            module.getContext(), valueType);
        auto allocation = allocationBuilder.create<helix::mid::SlotAllocOp>(
            declaration.getLoc(), slotType,
            allocationBuilder.getUnitAttr());
        allocation->setAttr(
            "helix.recovered_slot_id",
            allocationBuilder.getUI32IntegerAttr(slotId));
        if (auto name = declaration->getAttr("helix.recovered_name"))
            allocation->setAttr("helix.recovered_name", name);

        if (Value initial = declaration.getInit()) {
            OpBuilder builder(declaration);
            builder.create<helix::mid::SlotStoreOp>(
                declaration.getLoc(), allocation.getSlot(), initial);
        }
        for (helix::mid::AssignOp assignment : assignments) {
            OpBuilder builder(assignment);
            builder.create<helix::mid::SlotStoreOp>(
                assignment.getLoc(), allocation.getSlot(),
                assignment.getValue());
        }
        for (helix::mid::VarRefOp reference : references) {
            OpBuilder builder(reference);
            auto load = builder.create<helix::mid::SlotLoadOp>(
                reference.getLoc(), valueType, allocation.getSlot());
            reference.getResult().replaceAllUsesWith(load.getResult());
        }

        for (helix::mid::VarRefOp reference : references)
            reference.erase();
        for (helix::mid::AssignOp assignment : assignments)
            assignment.erase();
        declaration.erase();
        ++materialized;
    }
    return materialized;
}

struct MemorySlotPilotPass
    : public PassWrapper<MemorySlotPilotPass, OperationPass<ModuleOp>> {
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(MemorySlotPilotPass)

    StringRef getArgument() const final { return "helix-memory-slot-pilot"; }
    StringRef getDescription() const final {
        return "Promote explicitly safe HelixMid slots with MLIR mem2reg";
    }
    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::mid::HelixMidDialect,
                        helix::low::HelixLowDialect,
                        helix::high::HelixHighDialect,
                        LLVM::LLVMDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();
        const unsigned materialized =
            materializeSafeSingleBlockStackSlots(module);
        unsigned candidates = 0;
        SmallVector<Operation*, 16> candidateOps;
        module.walk([&](helix::mid::SlotAllocOp slot) {
            if (slot.getPromotable()) {
                ++candidates;
                candidateOps.push_back(slot.getOperation());
            }
        });

        if (candidates > 0) {
            RewritePatternSet patterns(&getContext());
            patterns.add<Mem2RegPattern>(&getContext());
            FrozenRewritePatternSet frozen(std::move(patterns));
            GreedyRewriteConfig config;
            config.strictMode = GreedyRewriteStrictness::ExistingAndNewOps;
            config.enableRegionSimplification = false;
            if (failed(applyOpPatternsAndFold(
                    candidateOps, frozen, config))) {
                signalPassFailure();
                return;
            }
        }

        unsigned remaining = 0;
        module.walk([&](helix::mid::SlotAllocOp slot) {
            if (slot.getPromotable())
                ++remaining;
        });
        Builder builder(&getContext());
        module->setAttr(
            "helix.memory_slot_pilot.materialized",
            builder.getI64IntegerAttr(materialized));
        module->setAttr(
            "helix.memory_slot_pilot.candidates",
            builder.getI64IntegerAttr(candidates));
        module->setAttr(
            "helix.memory_slot_pilot.promoted",
            builder.getI64IntegerAttr(candidates - remaining));
        module->setAttr(
            "helix.memory_slot_pilot.remaining",
            builder.getI64IntegerAttr(remaining));

        DataFlowSolver solver;
        solver.load<dataflow::DeadCodeAnalysis>();
        solver.load<dataflow::SparseConstantPropagation>();
        if (failed(solver.initializeAndRun(module))) {
            signalPassFailure();
            return;
        }

        unsigned knownConstants = 0;
        unsigned unknownConstants = 0;
        unsigned uninitialized = 0;
        module.walk([&](Operation* operation) {
            for (Value result : operation->getResults()) {
                auto* lattice = solver.lookupState<
                    dataflow::Lattice<dataflow::ConstantValue>>(result);
                if (!lattice || lattice->getValue().isUninitialized()) {
                    ++uninitialized;
                    continue;
                }
                if (lattice->getValue().getConstantValue())
                    ++knownConstants;
                else
                    ++unknownConstants;
            }
        });
        module->setAttr(
            "helix.dataflow_pilot.known_constants",
            builder.getI64IntegerAttr(knownConstants));
        module->setAttr(
            "helix.dataflow_pilot.unknown_constants",
            builder.getI64IntegerAttr(unknownConstants));
        module->setAttr(
            "helix.dataflow_pilot.uninitialized",
            builder.getI64IntegerAttr(uninitialized));
    }
};

} // namespace

std::unique_ptr<mlir::Pass> helix::createMemorySlotPilotPass() {
    return std::make_unique<MemorySlotPilotPass>();
}
