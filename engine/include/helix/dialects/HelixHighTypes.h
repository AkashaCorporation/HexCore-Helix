#pragma once
/// @file HelixHighTypes.h
/// @brief C++ type declarations for the Helix High-Level Dialect.

#ifndef HELIX_HIGH_TYPES_H
#define HELIX_HIGH_TYPES_H

#include "mlir/IR/Types.h"
#include "mlir/IR/DialectImplementation.h"
#include "helix/dialects/HelixHighDialect.h"

// Include the auto-generated type declarations
#define GET_TYPEDEF_CLASSES
#include "helix/dialects/HelixHighTypes.h.inc"

#endif // HELIX_HIGH_TYPES_H
