#pragma once
/// @file HelixLowOps.h
/// @brief C++ operation declarations for the Helix Low-Level Dialect.

#ifndef HELIX_LOW_OPS_H
#define HELIX_LOW_OPS_H

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/InferTypeOpInterface.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixLowTypes.h"

// Include the auto-generated enum declarations
#include "helix/dialects/HelixLowEnums.h.inc"

// Include the auto-generated op declarations
#define GET_OP_CLASSES
#include "helix/dialects/HelixLowOps.h.inc"

#endif // HELIX_LOW_OPS_H
