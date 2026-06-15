/// @file HelixMidDialect.td
/// @brief TableGen definition for the Helix Mid-Level Dialect.
///
/// The HelixMid dialect is the intermediate representation between HelixLow
/// (machine-level) and HelixHigh (C source-level).  It captures typed SSA
/// form with abstract variables, resolved memory accesses, expression trees,
/// and structured control flow — but BEFORE final variable naming and
/// C-specific formatting.
///
/// Design rationale:
///   HelixLow carries raw register/flag semantics that couple decompilation
///   analysis to x86 specifics.  HelixHigh is tightly bound to C syntax
///   (e.g., `var.decl` already carries a human-readable name).  HelixMid
///   decouples analysis from both: type propagation, alias analysis, and
///   control-flow structuring operate on HelixMid without caring about
///   source-language formatting or target-ISA encoding.

#ifndef HELIX_MID_DIALECT_TD
#define HELIX_MID_DIALECT_TD

include "mlir/IR/OpBase.td"

def HelixMid_Dialect : Dialect {
  let name = "helix_mid";
  let cppNamespace = "::helix::mid";
  let summary = "Helix Mid-Level Dialect — typed SSA decompilation IR";
  let description = [{
    The HelixMid dialect sits between HelixLow and HelixHigh.  It operates on
    abstract typed variables instead of raw registers, uses typed memory
    accesses instead of raw loads/stores, and represents expressions as value
    trees rather than flag-producing arithmetic.

    Key design goals:
    - **ISA-agnostic**: no register names, no flag semantics, no calling
      convention details — those are resolved during HelixLow → HelixMid
      conversion.
    - **Type-rich**: every value carries a resolved C type (int32_t, void*,
      struct Foo, etc.) or an explicit Unknown marker.
    - **SSA-clean**: values flow through def-use chains; phi nodes are
      explicit `helix_mid.select` ops.
    - **Region-based control flow**: loops and conditionals use MLIR regions,
      ready for 1:1 lowering to HelixHigh or EmitC.
    - **Address-tracked**: every op carries an optional source binary address
      for binary↔source mapping.
  }];

  let useDefaultTypePrinterParser = 1;
  let useDefaultAttributePrinterParser = 0;
}

#endif // HELIX_MID_DIALECT_TD
