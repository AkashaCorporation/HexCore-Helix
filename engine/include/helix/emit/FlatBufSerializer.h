#pragma once
/// @file FlatBufSerializer.h
/// @brief Serialize HelixHigh MLIR module or C AST to FlatBuffers AST format.

#ifndef HELIX_EMIT_FLATBUF_SERIALIZER_H
#define HELIX_EMIT_FLATBUF_SERIALIZER_H

#include "mlir/IR/BuiltinOps.h"
#include <cstdint>
#include <memory>
#include <vector>
#include <string>

// Forward-declare C AST types to avoid pulling in full headers.
namespace helix::cast {
    class CFuncDecl;
}

namespace helix {

/// Serializes a HelixHigh MLIR module (or C AST tree) to the FlatBuffers
/// AST schema (schemas/ast.fbs, file identifier "HAST").
///
/// Two serialization paths:
///   1. MLIR path: serialize(ModuleOp)  — stub, walks HelixHigh ops
///   2. C AST path: serialize(vector<CFuncDecl>) — full, walks C AST tree
///
/// The C AST path produces a complete HAST with all node types:
///   CFuncDecl → DecompiledFunction
///   CVarDecl  → Variable
///   CExpr     → Expression (with ExprKind)
///   CStmt     → Statement  (with StmtKind)
///   CType     → DataType
class FlatBufSerializer {
public:
    /// Serialize an entire MLIR module to FlatBuffer bytes (stub path).
    std::vector<uint8_t> serialize(mlir::ModuleOp module);

    /// Serialize C AST functions to FlatBuffer bytes (full path).
    ///
    /// This is the primary serialization method used when --use-cast-layer
    /// is active. Produces a complete HAST consumable by HQL.
    ///
    /// @param funcs       C AST function declarations after CAstOptimizer.
    /// @param moduleName  Module name for the AstModule root table.
    /// @return            FlatBuffer bytes with "HAST" file identifier.
    std::vector<uint8_t> serialize(
        const std::vector<std::unique_ptr<cast::CFuncDecl>>& funcs,
        const std::string& moduleName = "decompiled_module");

    /// Verify that a FlatBuffer is well-formed.
    static bool verify(const uint8_t* data, size_t size);
};

} // namespace helix

#endif // HELIX_EMIT_FLATBUF_SERIALIZER_H
