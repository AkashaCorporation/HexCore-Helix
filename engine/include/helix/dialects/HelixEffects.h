#pragma once

#include "mlir/Interfaces/SideEffectInterfaces.h"

namespace helix::effects {

struct RegisterStateResource final
    : mlir::SideEffects::Resource::Base<RegisterStateResource> {
    llvm::StringRef getName() final { return "helix.register_state"; }
};

struct VariableStateResource final
    : mlir::SideEffects::Resource::Base<VariableStateResource> {
    llvm::StringRef getName() final { return "helix.variable_state"; }
};

struct ProgramMemoryResource final
    : mlir::SideEffects::Resource::Base<ProgramMemoryResource> {
    llvm::StringRef getName() final { return "helix.program_memory"; }
};

} // namespace helix::effects
