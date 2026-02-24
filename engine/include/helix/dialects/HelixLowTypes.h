#pragma once
/// @file HelixLowTypes.h
/// @brief C++ type declarations for the Helix Low-Level Dialect.

#ifndef HELIX_LOW_TYPES_H
#define HELIX_LOW_TYPES_H

#include "mlir/IR/Types.h"
#include "mlir/IR/DialectImplementation.h"
#include "helix/dialects/HelixLowDialect.h"

// Include the auto-generated type declarations
#define GET_TYPEDEF_CLASSES
#include "helix/dialects/HelixLowTypes.h.inc"

#endif // HELIX_LOW_TYPES_H
