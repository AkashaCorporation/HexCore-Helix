/// @file HelixLowDialect.cpp
/// @brief Helix Low-Level Dialect registration and initialization.

#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixLowTypes.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace helix::low;

// ─── Dialect Initialization ──────────────────────────────────────────────────

#include "helix/dialects/HelixLowDialect.cpp.inc"

// Include full type definitions (storage structs + method impls) so that
// addTypes<> can check std::is_trivially_destructible on the storage types.
#define GET_TYPEDEF_CLASSES
#include "helix/dialects/HelixLowTypes.cpp.inc"

void HelixLowDialect::initialize() {
    // Register types
    addTypes<
#define GET_TYPEDEF_LIST
#include "helix/dialects/HelixLowTypes.cpp.inc"
    >();

    // Register operations
    addOperations<
#define GET_OP_LIST
#include "helix/dialects/HelixLowOps.cpp.inc"
    >();
}
