#pragma once
/// @file PseudoCEmitter.h
/// @brief Emit pseudo-C source code from a HelixHigh MLIR module.

#ifndef HELIX_EMIT_PSEUDOC_EMITTER_H
#define HELIX_EMIT_PSEUDOC_EMITTER_H

#include "mlir/IR/BuiltinOps.h"
#include "llvm/Support/raw_ostream.h"
#include <string>

namespace helix {

namespace high {
class FuncOp;
class ModuleOp;
} // namespace high

/// Emits human-readable pseudo-C code from a HelixHigh MLIR module.
///
/// The emitter walks the MLIR module and renders each HelixHigh operation
/// to C-like source code. Format conventions match the existing Rust
/// HIR emitter (hir_emitter.rs) for consistency:
///   - Integer types: int32_t, uint64_t, etc.
///   - Hex literals for values >= 16 or <= -16
///   - Parenthesized binary expressions
///   - Indented block structure with braces
class PseudoCEmitter {
public:
    /// Emit an entire MLIR module as pseudo-C source code.
    ///
    /// @param module  The HelixHigh MLIR module to emit.
    /// @return        The pseudo-C source code string.
    std::string emit(mlir::ModuleOp module);

    /// Emit to an output stream.
    void emit(mlir::ModuleOp module, llvm::raw_ostream& os);

private:
    /// Emit a file header comment.
    void emitHeader(llvm::raw_ostream& os, mlir::ModuleOp module);

    /// Emit a single decompiled function.
    void emitFunction(mlir::Operation* funcOp, llvm::raw_ostream& os);

    /// Emit a statement (dispatches by op type).
    void emitStatement(mlir::Operation* op, llvm::raw_ostream& os, unsigned depth);

    /// Emit a block of statements within a region.
    void emitRegionBody(mlir::Region& region, llvm::raw_ostream& os, unsigned depth);

    /// Format an expression value as a C expression string.
    std::string formatExpression(mlir::Value val);

    /// Format a C type name (e.g., "int32_t", "void*", "bool").
    std::string formatType(mlir::Type type);

    /// Format an integer literal (hex for >= 16).
    std::string formatIntLiteral(int64_t value);

    /// Emit indentation.
    void indent(llvm::raw_ostream& os, unsigned depth);
};

} // namespace helix

#endif // HELIX_EMIT_PSEUDOC_EMITTER_H
