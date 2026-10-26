#pragma once
/// @file HelixMidOps.h
/// @brief C++ operation declarations for the Helix Mid-Level Dialect.

#ifndef HELIX_MID_OPS_H
#define HELIX_MID_OPS_H

#include "helix/dialects/HelixMidDialect.h"
#include "helix/dialects/HelixMidTypes.h"
#include "helix/dialects/HelixEffects.h"
#include "helix/Interfaces.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/MemorySlotInterfaces.h"
#include "mlir/Interfaces/InferTypeOpInterface.h"

// Enums already included via HelixMidTypes.h

// TableGen-generated op declarations
#define GET_OP_CLASSES
#include "helix/dialects/HelixMidOps.h.inc"

#endif // HELIX_MID_OPS_H
