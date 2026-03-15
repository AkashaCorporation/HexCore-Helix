#pragma once
/// @file HelixMidTypes.h
/// @brief C++ type definitions for the Helix Mid-Level Dialect.

#ifndef HELIX_MID_TYPES_H
#define HELIX_MID_TYPES_H

#include "mlir/IR/Types.h"
#include "mlir/IR/DialectImplementation.h"

// TableGen-generated enum declarations (needed by types, e.g. ScalarKind)
#include "helix/dialects/HelixMidEnums.h.inc"

// TableGen-generated type declarations
#define GET_TYPEDEF_CLASSES
#include "helix/dialects/HelixMidTypes.h.inc"

#endif // HELIX_MID_TYPES_H
