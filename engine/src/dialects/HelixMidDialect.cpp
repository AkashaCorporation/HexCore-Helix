/// @file HelixMidDialect.cpp
/// @brief Helix Mid-Level Dialect registration implementation.

#include "helix/dialects/HelixMidDialect.h"
#include "helix/dialects/HelixMidOps.h"
#include "helix/dialects/HelixMidTypes.h"

#include "mlir/IR/DialectImplementation.h"
#include "mlir/IR/Builders.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace helix::mid;

// ─── Dialect Implementation ─────────────────────────────────────────────────

#include "helix/dialects/HelixMidDialect.cpp.inc"

void HelixMidDialect::initialize() {
    // Register types
    addTypes<
#define GET_TYPEDEF_LIST
#include "helix/dialects/HelixMidTypes.cpp.inc"
    >();

    // Register operations
    addOperations<
#define GET_OP_LIST
#include "helix/dialects/HelixMidOps.cpp.inc"
    >();
}

// ─── Type Definitions ────────────────────────────────────────────────────────

#define GET_TYPEDEF_CLASSES
#include "helix/dialects/HelixMidTypes.cpp.inc"
