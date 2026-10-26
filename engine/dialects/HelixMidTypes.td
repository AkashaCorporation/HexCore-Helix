/// @file HelixMidTypes.td
/// @brief TableGen type definitions for the Helix Mid-Level Dialect.
///
/// Types at the Mid level are richer than HelixLow's raw register/flag types
/// but more abstract than HelixHigh's CType (which carries C formatting info).
/// They represent the decompiler's best understanding of data shapes after
/// type propagation but before source-language rendering.

#ifndef HELIX_MID_TYPES_TD
#define HELIX_MID_TYPES_TD

include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/EnumAttr.td"
include "dialects/HelixMidDialect.td"

class HelixMid_Type<string name, string typeMnemonic, list<Trait> traits = []>
    : TypeDef<HelixMid_Dialect, name, traits> {
  let mnemonic = typeMnemonic;
}

// ─── Scalar Type Kind ─────────────────────────────────────────────────────────

def HelixMid_ScalarKind : I32EnumAttr<
    "ScalarKind", "Scalar type classification", [
      I32EnumAttrCase<"Void",       0>,
      I32EnumAttrCase<"Bool",       1>,
      I32EnumAttrCase<"SInt",       2>,  // signed integer
      I32EnumAttrCase<"UInt",       3>,  // unsigned integer
      I32EnumAttrCase<"Float",      4>,
      I32EnumAttrCase<"Unknown",    5>,  // not yet resolved
    ]> {
  let cppNamespace = "::helix::mid";
}

// ─── Decompiled Type ──────────────────────────────────────────────────────────
/// A resolved decompilation type.  Carries enough information for lowering to
/// HelixHigh CType or EmitC opaque types without any ISA-specific encoding.

def HelixMid_DecompType : HelixMid_Type<"Decomp", "dtype"> {
  let summary = "Resolved decompilation type";
  let description = [{
    Represents a concrete or partially-resolved C-level type.
    Carries scalar kind, bit width, and optional pointee/struct info.

    Examples:
    - `!helix_mid.dtype<SInt, 32>`          → int32_t
    - `!helix_mid.dtype<UInt, 64>`          → uint64_t
    - `!helix_mid.dtype<Float, 64>`         → double
    - `!helix_mid.dtype<Void, 0>`           → void
    - `!helix_mid.dtype<Unknown, 64>`       → unresolved 64-bit value
  }];

  let parameters = (ins
    EnumParameter<HelixMid_ScalarKind>:$kind,
    DefaultValuedParameter<"unsigned", "0">:$bitWidth
  );

  let assemblyFormat = "`<` $kind `,` $bitWidth `>`";
}

// ─── Pointer Type ─────────────────────────────────────────────────────────────

def HelixMid_PtrType : HelixMid_Type<"Ptr", "ptr"> {
  let summary = "Typed pointer";
  let description = [{
    A pointer to a value of the given element type.  Pointers at the mid level
    are always address-sized (64-bit on x86_64, 32-bit on x86).

    Example: `!helix_mid.ptr<!helix_mid.dtype<SInt, 32>>` → int32_t*
  }];

  let parameters = (ins
    "mlir::Type":$pointee
  );

  let assemblyFormat = "`<` $pointee `>`";
}

// ─── Array Type ───────────────────────────────────────────────────────────────

def HelixMid_ArrayType : HelixMid_Type<"Array", "array"> {
  let summary = "Fixed-size array type";
  let description = [{
    An array with known element type and count (0 = unknown/flexible).

    Example: `!helix_mid.array<!helix_mid.dtype<UInt, 8>, 256>` → uint8_t[256]
  }];

  let parameters = (ins
    "mlir::Type":$element,
    "int64_t":$count
  );

  let assemblyFormat = "`<` $element `,` $count `>`";
}

// ─── Struct Type ──────────────────────────────────────────────────────────────

def HelixMid_StructType : HelixMid_Type<"Struct", "struct"> {
  let summary = "Named struct type (opaque — fields tracked externally)";
  let description = [{
    References a struct by name.  Field layout is tracked in the struct
    recovery database, not in the type itself (keeps IR compact).

    Example: `!helix_mid.struct<"_OBJECT_ATTRIBUTES">` → struct _OBJECT_ATTRIBUTES
  }];

  let parameters = (ins
    StringRefParameter<"struct name">:$name
  );

  let assemblyFormat = "`<` $name `>`";
}

// ─── Function Pointer Type ───────────────────────────────────────────────────

def HelixMid_FuncPtrType : HelixMid_Type<"FuncPtr", "fptr"> {
  let summary = "Function pointer type";
  let description = [{
    Typed function pointer carrying return type and parameter types.

    Example: `!helix_mid.fptr<!helix_mid.dtype<SInt, 32>, !helix_mid.ptr<...>>`
             → int32_t (*)(void*)
  }];

  let parameters = (ins
    "mlir::Type":$returnType,
    ArrayRefParameter<"mlir::Type">:$paramTypes
  );

  let assemblyFormat = "`<` $returnType `,` `(` $paramTypes `)` `>`";
}

// ─── Variadic Bundle (Wave 22 — variadic call mini-ISA) ──────────────────────
//
// Mirror of HelixLow_BundleState / HelixLow_BundleType lifted into the Mid
// dialect. Lowering Low→Mid converts !helix_low.bundle → !helix_mid.bundle
// preserving the state. See HelixLowTypes.td for the rationale on the
// `Zeroed` state (load-bearing for upstream-erased-args detection).
def HelixMid_BundleState : I32EnumAttr<
    "BundleState", "Variadic argument bundle recovery state (Mid)", [
      I32EnumAttrCase<"Opaque",             0>,
      I32EnumAttrCase<"PartiallyRecovered", 1>,
      I32EnumAttrCase<"Recovered",          2>,
      I32EnumAttrCase<"Zeroed",             3>,
    ]> {
  let cppNamespace = "::helix::mid";
}

def HelixMid_BundleType : HelixMid_Type<"Bundle", "bundle"> {
  let summary = "Mid-dialect variadic argument bundle";
  let description = [{
    Carries a variadic call's raw argument bundle through the Mid dialect.
    No generic Mid pass (DCE / CSE / type propagation / call resolution)
    may decompose this type — recovery requires explicit proof attached
    via `helix_mid.bundle.recover`.
  }];
}

// Opaque handle used only by the MemorySlot promotion pilot. The element type
// is carried structurally so MLIR mem2reg can verify whole-value accesses.
def HelixMid_SlotType : HelixMid_Type<"Slot", "slot"> {
  let summary = "Promotable recovered-variable storage slot";
  let parameters = (ins "mlir::Type":$valueType);
  let assemblyFormat = "`<` $valueType `>`";
}

// ─── Variable Slot Kind ──────────────────────────────────────────────────────

def HelixMid_SlotKind : I32EnumAttr<
    "SlotKind", "Variable storage slot classification", [
      I32EnumAttrCase<"Stack",      0>,  // stack frame slot [RBP+offset]
      I32EnumAttrCase<"Register",   1>,  // register-resident value
      I32EnumAttrCase<"Global",     2>,  // global/static address
      I32EnumAttrCase<"Param",      3>,  // function parameter
      I32EnumAttrCase<"Temp",       4>,  // compiler-generated temporary
    ]> {
  let cppNamespace = "::helix::mid";
}

#endif // HELIX_MID_TYPES_TD
