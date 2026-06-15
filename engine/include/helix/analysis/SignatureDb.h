#pragma once
/// @file SignatureDb.h
/// @brief Function signature database for known API functions.
///
/// Used during calling convention recovery and type propagation to resolve
/// parameter types and return types for known library/API function calls.
/// Port of the Rust signatures module from crates/helix-core/src/signatures.rs.

#ifndef HELIX_ANALYSIS_SIGNATURE_DB_H
#define HELIX_ANALYSIS_SIGNATURE_DB_H

#include "llvm/ADT/StringRef.h"
#include "mlir/IR/BuiltinOps.h"
#include <optional>
#include <string>
#include <vector>

namespace helix {

/// Information about a known function signature.
struct FunctionSignature {
    /// Function name.
    std::string name;
    /// Return type description (e.g., "int32", "void", "ptr").
    std::string return_type;
    /// Parameter type descriptions.
    std::vector<std::string> param_types;
    /// Whether the function is variadic.
    bool is_variadic = false;
};

/// Lookup a function signature by name.
///
/// Checks the built-in database of CRT, Win32 API, and common library
/// function signatures. Returns std::nullopt for unknown functions.
///
/// @param name  The function name (e.g., "printf", "malloc", "CreateFileW").
/// @return      The signature if known, std::nullopt otherwise.
std::optional<FunctionSignature> lookupSignature(llvm::StringRef name);

/// Check if a function name is a known CRT function.
bool isCrtFunction(llvm::StringRef name);

/// Check if a function name is a known Win32 API function.
bool isWin32Function(llvm::StringRef name);

/// Resolve CALL target addresses to function names within a module.
///
/// Walks all helix_low.FuncOp operations to build an address→name map,
/// then updates every helix_low.CallOp whose target address matches a
/// known function entry point by setting its target_name attribute.
/// For addresses matching a known CRT/Win32 signature, the canonical
/// signature name is used instead.
///
/// @param module  The top-level MLIR ModuleOp containing HelixLow functions.
void resolveCallTargets(mlir::ModuleOp module);

} // namespace helix

#endif // HELIX_ANALYSIS_SIGNATURE_DB_H
