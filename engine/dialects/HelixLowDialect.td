/// @file HelixLowDialect.td
/// @brief TableGen definition for the Helix Low-Level Dialect.
///
/// The HelixLow dialect represents machine-level operations after Remill
/// pattern recognition. It captures register accesses, memory operations,
/// arithmetic with flags, and control flow at the instruction level.

#ifndef HELIX_LOW_DIALECT_TD
#define HELIX_LOW_DIALECT_TD

include "mlir/IR/OpBase.td"

def HelixLow_Dialect : Dialect {
  let name = "helix_low";
  let cppNamespace = "::helix::low";
  let summary = "Helix Low-Level Dialect for machine-level decompilation IR";
  let description = [{
    The HelixLow dialect sits directly above the MLIR LLVM Dialect and represents
    machine-level operations after recognizing Remill lifting patterns. It replaces
    Remill's mangled C++ semantic function calls, State struct GEPs, and memory
    intrinsics with explicit, typed, decompiler-specific operations.

    Key features:
    - Explicit register read/write operations with name and width tracking
    - Memory operations with address and width attributes
    - Arithmetic operations that produce flag results (carry, zero, sign, overflow)
    - Control flow operations (conditional/unconditional jumps, calls, returns)
    - All operations carry an optional `address` attribute for source mapping
  }];

  let useDefaultTypePrinterParser = 1;
  let useDefaultAttributePrinterParser = 1;
}

#endif // HELIX_LOW_DIALECT_TD
