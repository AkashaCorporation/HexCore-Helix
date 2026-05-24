/// @file HelixLowTypes.td
/// @brief TableGen type definitions for the Helix Low-Level Dialect.

#ifndef HELIX_LOW_TYPES_TD
#define HELIX_LOW_TYPES_TD

include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/EnumAttr.td"
include "dialects/HelixLowDialect.td"

class HelixLow_Type<string name, string typeMnemonic, list<Trait> traits = []>
    : TypeDef<HelixLow_Dialect, name, traits> {
  let mnemonic = typeMnemonic;
}

// ─── Bundle State Enum (Wave 22 — variadic call mini-ISA) ────────────────────
//
// Tracks the recovery state of a variadic argument bundle. The `zeroed` state
// is critical: it records that some upstream pass (Pathfinder / Remill / etc.)
// erased the args BEFORE Helix saw them. Without this distinction, opacity
// markers would silently mask upstream bugs.
//
// Verifier rule (enforced in later steps): `zeroed` MUST NOT be silently
// promoted to `recovered` — recovery requires explicit proof attached via the
// bundle.recover op.
def HelixLow_BundleState : I32EnumAttr<
    "BundleState", "Variadic argument bundle recovery state", [
      I32EnumAttrCase<"Opaque",             0>,  // unknown — generic uncertainty
      I32EnumAttrCase<"PartiallyRecovered", 1>,  // some args recovered, others not
      I32EnumAttrCase<"Recovered",          2>,  // fully recovered with proof
      I32EnumAttrCase<"Zeroed",             3>,  // upstream erased before Helix
    ]> {
  let cppNamespace = "::helix::low";
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

// ─── Variadic Argument Bundle Type (Wave 22) ─────────────────────────────────

def HelixLow_BundleType : HelixLow_Type<"Bundle", "bundle"> {
  let summary = "First-class variadic argument bundle";
  let description = [{
    Represents the raw, opaque variadic argument bundle of a `helix_low.variadic_call`.
    The bundle is produced by `helix_low.bundle.create` and carries evidence —
    not just data — via its `state` attribute on the producer op.

    No generic pass (DCE / CSE / Simplify) may decompose this type into
    individual operands. Recovery requires `helix_low.bundle.recover` with
    explicit proof.
  }];
}

#endif // HELIX_LOW_TYPES_TD
