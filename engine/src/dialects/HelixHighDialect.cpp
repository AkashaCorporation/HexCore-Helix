/// @file HelixHighDialect.cpp
/// @brief Helix High-Level Dialect registration and initialization.

#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixHighTypes.h"

using namespace mlir;
using namespace helix::high;

// ─── Dialect Initialization ──────────────────────────────────────────────────

#include "helix/dialects/HelixHighDialect.cpp.inc"

void HelixHighDialect::initialize() {
    // Register types
    addTypes<
#define GET_TYPEDEF_LIST
#include "helix/dialects/HelixHighTypes.cpp.inc"
    >();

    // Register operations
    addOperations<
#define GET_OP_LIST
#include "helix/dialects/HelixHighOps.cpp.inc"
    >();
}
