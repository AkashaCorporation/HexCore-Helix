/// @file HelixLowDialect.cpp
/// @brief Helix Low-Level Dialect registration and initialization.

#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixLowTypes.h"

using namespace mlir;
using namespace helix::low;

// ─── Dialect Initialization ──────────────────────────────────────────────────

#include "helix/dialects/HelixLowDialect.cpp.inc"

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
