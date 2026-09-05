#pragma once
/// @file FlatBufSerializer.h
/// @brief Serialize the canonical C AST to the HAST FlatBuffer contract.

#ifndef HELIX_EMIT_FLATBUF_SERIALIZER_H
#define HELIX_EMIT_FLATBUF_SERIALIZER_H

#include "helix/Types.h"
#include <cstdint>
#include <memory>
#include <vector>
#include <string>

// Forward-declare C AST types to avoid pulling in full headers.
namespace helix::cast {
    class CFuncDecl;
}

namespace helix {

/// Serializes a canonical C AST tree to the FlatBuffers AST schema
/// (schemas/ast.fbs, file identifier "HAST"). The former partial MLIR/stub
/// representation is intentionally not part of this API: every successful
/// serialization carries the HAST 1.x negotiation fields and full C-AST data.
///
/// The C AST path produces a complete HAST with all node types:
///   CFuncDecl → DecompiledFunction
///   CVarDecl  → Variable
///   CExpr     → Expression (with ExprKind)
///   CStmt     → Statement  (with StmtKind)
///   CType     → DataType
class FlatBufSerializer {
public:
    /// Serialize C AST functions to canonical HAST bytes.
    ///
    /// This is the only serialization method and produces a complete HAST
    /// consumable by HQL and other semantic clients.
    ///
    /// @param funcs       C AST function declarations after CAstOptimizer.
    /// @param moduleName  Module name for the AstModule root table.
    /// @param arch        Target architecture recorded in module metadata.
    /// @return            FlatBuffer bytes with "HAST" file identifier.
    std::vector<uint8_t> serialize(
        const std::vector<std::unique_ptr<cast::CFuncDecl>>& funcs,
        const std::string& moduleName = "decompiled_module",
        HelixArch arch = HELIX_ARCH_X86_64);

    /// Verify the HAST identifier, root bounds, and canonical 1.0 negotiation
    /// fields. Legacy identifier-only/name-only buffers are rejected.
    static bool verify(const uint8_t* data, size_t size);
};

} // namespace helix

#endif // HELIX_EMIT_FLATBUF_SERIALIZER_H
