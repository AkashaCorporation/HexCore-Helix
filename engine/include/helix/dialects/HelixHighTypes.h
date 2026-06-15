#pragma once
/// @file HelixHighTypes.h
/// @brief C++ type declarations for the Helix High-Level Dialect.

#ifndef HELIX_HIGH_TYPES_H
#define HELIX_HIGH_TYPES_H

#include "mlir/IR/Types.h"
#include "mlir/IR/DialectImplementation.h"
#include "helix/dialects/HelixHighDialect.h"

// Include enum declarations (TypeKind, StorageKind) before types, since
// HelixHighTypes.h.inc references them in the CTypeType signature.
#ifndef HELIX_HIGH_ENUMS_INCLUDED
#define HELIX_HIGH_ENUMS_INCLUDED
#include "helix/dialects/HelixHighEnums.h.inc"
#endif

// Include the auto-generated type declarations
#define GET_TYPEDEF_CLASSES
#include "helix/dialects/HelixHighTypes.h.inc"

#endif // HELIX_HIGH_TYPES_H
