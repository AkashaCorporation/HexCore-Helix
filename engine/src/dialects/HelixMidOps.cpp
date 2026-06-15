/// @file HelixMidOps.cpp
/// @brief Helix Mid-Level Dialect operation definitions.

#include "helix/dialects/HelixMidOps.h"

#include "mlir/IR/OpImplementation.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace helix::mid;

// ─── Enum Definitions ────────────────────────────────────────────────────────

#include "helix/dialects/HelixMidEnums.cpp.inc"

// ─── Op Definitions ──────────────────────────────────────────────────────────

#define GET_OP_CLASSES
#include "helix/dialects/HelixMidOps.cpp.inc"
