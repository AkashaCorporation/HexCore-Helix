/// @file Passes.cpp
/// @brief Registration of all Helix passes with the MLIR pass registry.

#include "helix/passes/Passes.h"
#include "mlir/Pass/PassRegistry.h"

namespace helix {

void registerHelixPasses() {
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createRemillToHelixLowPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createRecoverStackLayoutPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createRecoverCallingConventionPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createPropagateTypesPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createPropagateTypesHighPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createApplyDebugTypesPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createStructureControlFlowPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createBridgeStructuredControlFlowPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createRecoverVariablesPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createBindReturnValuesPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createEliminateDeadCodePass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createMemorySlotPilotPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createRegisterSSARenamePass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createHelixLowSimplifyPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createHelixMidSimplifyPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createConstantFoldingPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createEscapeAnalysisPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createRecoverStructTypesPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createRecoverSwitchTablesPass();
    });

    // v3.8.0 optimization passes
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createRecoverMagicDivisionPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createDevirtualizeIndirectCallsPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createInterProceduralTypePropagationPass();
    });

    // v1.0 dialect conversion passes
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createHelixLowToMidPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createHelixMidToHighPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createLegalizeFunctionContainersPass();
    });
}

} // namespace helix
