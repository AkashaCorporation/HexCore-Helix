#pragma once
/// @file FlatBufSerializer.h
/// @brief Serialize HelixHigh MLIR module to FlatBuffers AST format.

#ifndef HELIX_EMIT_FLATBUF_SERIALIZER_H
#define HELIX_EMIT_FLATBUF_SERIALIZER_H

#include "mlir/IR/BuiltinOps.h"
#include <cstdint>
#include <vector>
#include <string>

namespace helix {

/// Serializes a HelixHigh MLIR module to the FlatBuffers AST schema.
///
/// Produces binary output conforming to schemas/ast.fbs with file
/// identifier "HAST". The output can be read zero-copy by the HexCore
/// IDE (TypeScript/VS Code) via the FlatBuffers runtime.
///
/// Mapping:
///   helix_high.func      → DecompiledFunction
///   helix_high.var.decl   → Variable
///   helix_high.assign/if/while/... → Statement (with StmtKind)
///   helix_high.binary/var.ref/int.lit/... → Expression (with ExprKind)
///   CType                → DataType
class FlatBufSerializer {
public:
    /// Serialize an entire MLIR module to FlatBuffer bytes.
    ///
    /// @param module  The HelixHigh MLIR module after full pass pipeline.
    /// @return        FlatBuffer bytes with "HAST" file identifier.
    std::vector<uint8_t> serialize(mlir::ModuleOp module);

    /// Verify that a FlatBuffer is well-formed.
    ///
    /// @param data  The buffer to verify.
    /// @param size  Size in bytes.
    /// @return      true if valid, false otherwise.
    static bool verify(const uint8_t* data, size_t size);
};

} // namespace helix

#endif // HELIX_EMIT_FLATBUF_SERIALIZER_H
