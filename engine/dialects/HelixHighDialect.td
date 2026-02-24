/// @file HelixHighDialect.td
/// @brief TableGen definition for the Helix High-Level Dialect.
///
/// The HelixHigh dialect represents source-level C constructs using
/// MLIR regions for structured control flow (if/while/for/switch).
/// This is the target dialect for decompilation output.

#ifndef HELIX_HIGH_DIALECT_TD
#define HELIX_HIGH_DIALECT_TD

include "mlir/IR/OpBase.td"

def HelixHigh_Dialect : Dialect {
  let name = "helix_high";
  let cppNamespace = "::helix::high";
  let summary = "Helix High-Level Dialect for source-level decompilation IR";
  let description = [{
    The HelixHigh dialect represents decompiled code at the C source level.
    It uses MLIR regions to directly model structured control flow constructs
    (if/else, while, for, switch) instead of basic blocks and gotos.

    Key features:
    - Region-based if/else, while, do-while, for, and switch operations
    - Explicit variable declarations with type, storage, and naming info
    - C-level expressions (binary, unary, cast, call, subscript, field access)
    - Source address tracking for binary-to-source mapping
    - Direct mapping to FlatBuffers AST schema for zero-copy UI transport
  }];

  let useDefaultTypePrinterParser = 1;
  let useDefaultAttributePrinterParser = 1;
}

#endif // HELIX_HIGH_DIALECT_TD
