/// @file RecoverVariablesFactory.cpp
/// @brief Factory for RecoverVariablesPass — separated to avoid MSVC C2888.

#include "helix/passes/Passes.h"
#include "mlir/Pass/Pass.h"
#include <memory>

extern void* helix_createRecoverVariablesPass_impl();

std::unique_ptr<mlir::Pass> helix::createRecoverVariablesPass() {
    return std::unique_ptr<mlir::Pass>(
        static_cast<mlir::Pass*>(helix_createRecoverVariablesPass_impl()));
}
