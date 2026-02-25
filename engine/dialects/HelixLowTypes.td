/// @file HelixLowTypes.td
/// @brief TableGen type definitions for the Helix Low-Level Dialect.

#ifndef HELIX_LOW_TYPES_TD
#define HELIX_LOW_TYPES_TD

include "mlir/IR/AttrTypeBase.td"
include "dialects/HelixLowDialect.td"

class HelixLow_Type<string name, string typeMnemonic, list<Trait> traits = []>
    : TypeDef<HelixLow_Dialect, name, traits> {
  let mnemonic = typeMnemonic;
}

// ─── Register Type ───────────────────────────────────────────────────────────

def HelixLow_RegisterType : HelixLow_Type<"Register", "reg"> {
  let summary = "CPU register reference type";
  let description = [{
    Represents a CPU register with a name (e.g., "RAX", "RBX") and bit width
    (e.g., 64, 32, 16, 8). Tracks register provenance through the pipeline
    for accurate variable naming in the decompiled output.
  }];

  let parameters = (ins
    StringRefParameter<"name of the register">:$name,
    "unsigned":$bitWidth
  );

  let assemblyFormat = "`<` $name `,` $bitWidth `>`";
}

// ─── Memory Token Type ───────────────────────────────────────────────────────

def HelixLow_MemoryType : HelixLow_Type<"Memory", "mem"> {
  let summary = "Memory state token type";
  let description = [{
    Represents the Remill memory state token. In Remill IR, a `ptr %memory`
    value is threaded through every operation for memory ordering. This type
    captures that concept before it is eliminated during lowering to HelixHigh.
  }];
}

// ─── Flag Type ───────────────────────────────────────────────────────────────

def HelixLow_FlagType : HelixLow_Type<"Flag", "flag"> {
  let summary = "CPU status flag type";
  let description = [{
    Represents an individual CPU status flag (carry, zero, sign, overflow, parity).
    Used as an intermediate representation before flags are lowered to boolean
    conditions in the HelixHigh dialect.
  }];

  let parameters = (ins
    StringRefParameter<"name of the flag">:$name
  );

  let assemblyFormat = "`<` $name `>`";
}

#endif // HELIX_LOW_TYPES_TD
