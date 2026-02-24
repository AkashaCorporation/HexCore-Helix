/// @file HelixHighTypes.td
/// @brief TableGen type definitions for the Helix High-Level Dialect.

#ifndef HELIX_HIGH_TYPES_TD
#define HELIX_HIGH_TYPES_TD

include "mlir/IR/AttrTypeBase.td"
include "engine/dialects/HelixHighDialect.td"

class HelixHigh_Type<string name, string typeMnemonic, list<Trait> traits = []>
    : TypeDef<HelixHigh_Dialect, name, traits> {
  let mnemonic = typeMnemonic;
}

// ─── TypeKind Enum ───────────────────────────────────────────────────────────

def HelixHigh_TypeKind : I32EnumAttr<
    "TypeKind", "C-level type kind", [
      I32EnumAttrCase<"Void",     0>,
      I32EnumAttrCase<"Bool",     1>,
      I32EnumAttrCase<"Int",      2>,
      I32EnumAttrCase<"Float",    3>,
      I32EnumAttrCase<"Pointer",  4>,
      I32EnumAttrCase<"Array",    5>,
      I32EnumAttrCase<"Struct",   6>,
      I32EnumAttrCase<"Union",    7>,
      I32EnumAttrCase<"FuncPtr",  8>,
      I32EnumAttrCase<"Unknown",  9>,
    ]> {
  let cppNamespace = "::helix::high";
}

// ─── C Type ──────────────────────────────────────────────────────────────────

def HelixHigh_CType : HelixHigh_Type<"CType", "ctype"> {
  let summary = "C-level data type for decompiled variables and expressions";
  let description = [{
    Represents a C data type with kind (void, bool, int, float, pointer, array,
    struct, union, funcptr, unknown), signedness, bit width, and optional
    pointee/element type info. Maps directly to the FlatBuffers DataType table
    in ast.fbs and the Rust HirType enum.

    Examples:
    - `!helix_high.ctype<Int, true, 32>`      → int32_t
    - `!helix_high.ctype<Int, false, 64>`     → uint64_t
    - `!helix_high.ctype<Pointer, Void>`      → void*
    - `!helix_high.ctype<Bool>`               → bool
    - `!helix_high.ctype<Float, 64>`          → double
    - `!helix_high.ctype<Struct, "MyStruct">` → struct MyStruct
  }];

  let parameters = (ins
    HelixHigh_TypeKind:$kind,
    DefaultValuedParameter<"bool", "true">:$is_signed,
    DefaultValuedParameter<"unsigned", "0">:$bit_width,
    OptionalParameter<"mlir::StringAttr">:$struct_name
  );

  let assemblyFormat = [{
    `<` $kind (`,` $is_signed^)? (`,` $bit_width^)? (`,` $struct_name^)? `>`
  }];
}

// ─── Storage Kind ────────────────────────────────────────────────────────────

def HelixHigh_StorageKind : I32EnumAttr<
    "StorageKind", "Variable storage location kind", [
      I32EnumAttrCase<"Stack",      0>,
      I32EnumAttrCase<"Register",   1>,
      I32EnumAttrCase<"Global",     2>,
      I32EnumAttrCase<"Parameter",  3>,
      I32EnumAttrCase<"Temporary",  4>,
    ]> {
  let cppNamespace = "::helix::high";
}

#endif // HELIX_HIGH_TYPES_TD
