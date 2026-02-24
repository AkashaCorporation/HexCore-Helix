/// @file HelixLowOps.cpp
/// @brief Operation implementations for the Helix Low-Level Dialect.
///
/// Contains verifiers, canonicalization patterns, and any custom logic
/// beyond what TableGen auto-generates.

#include "helix/dialects/HelixLowOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/OpImplementation.h"

using namespace mlir;
using namespace helix::low;

// ─── Enum definitions ────────────────────────────────────────────────────────

#include "helix/dialects/HelixLowEnums.cpp.inc"

// ─── Type definitions ────────────────────────────────────────────────────────

#define GET_TYPEDEF_CLASSES
#include "helix/dialects/HelixLowTypes.cpp.inc"

// ─── Op definitions ──────────────────────────────────────────────────────────

#define GET_OP_CLASSES
#include "helix/dialects/HelixLowOps.cpp.inc"
