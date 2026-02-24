/// @file HelixHighOps.cpp
/// @brief Operation implementations for the Helix High-Level Dialect.
///
/// Contains verifiers, canonicalization patterns, and region builders
/// for structured control flow operations.

#include "helix/dialects/HelixHighOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/OpImplementation.h"

using namespace mlir;
using namespace helix::high;

// ─── Enum definitions ────────────────────────────────────────────────────────

#include "helix/dialects/HelixHighEnums.cpp.inc"

// ─── Type definitions ────────────────────────────────────────────────────────

#define GET_TYPEDEF_CLASSES
#include "helix/dialects/HelixHighTypes.cpp.inc"

// ─── Op definitions ──────────────────────────────────────────────────────────

#define GET_OP_CLASSES
#include "helix/dialects/HelixHighOps.cpp.inc"
