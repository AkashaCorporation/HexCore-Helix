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
        return createStructureControlFlowPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createRecoverVariablesPass();
    });
    mlir::registerPass([]() -> std::unique_ptr<mlir::Pass> {
        return createEliminateDeadCodePass();
    });
}

} // namespace helix
