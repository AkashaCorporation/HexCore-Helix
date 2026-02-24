#pragma once
/// @file HelixHighOps.h
/// @brief C++ operation declarations for the Helix High-Level Dialect.

#ifndef HELIX_HIGH_OPS_H
#define HELIX_HIGH_OPS_H

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/IR/RegionKindInterface.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighTypes.h"

// Include the auto-generated enum declarations
#include "helix/dialects/HelixHighEnums.h.inc"

// Include the auto-generated op declarations
#define GET_OP_CLASSES
#include "helix/dialects/HelixHighOps.h.inc"

#endif // HELIX_HIGH_OPS_H
