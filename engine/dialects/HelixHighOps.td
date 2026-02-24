/// @file HelixHighOps.td
/// @brief TableGen operation definitions for the Helix High-Level Dialect.
///
/// Operations represent C-level constructs: variable declarations, assignments,
/// expressions, structured control flow (if/while/for/switch), and function
/// definitions. Control flow uses MLIR regions for nested structure.

#ifndef HELIX_HIGH_OPS_TD
#define HELIX_HIGH_OPS_TD

include "mlir/IR/OpBase.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/IR/RegionKindInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/FunctionInterfaces.td"
include "engine/dialects/HelixHighDialect.td"
include "engine/dialects/HelixHighTypes.td"

// ─── Base Class ──────────────────────────────────────────────────────────────

class HelixHigh_Op<string mnemonic, list<Trait> traits = []>
    : Op<HelixHigh_Dialect, mnemonic, traits>;

// ─── Binary Operator Enum ────────────────────────────────────────────────────

def HelixHigh_BinaryOpKind : I32EnumAttr<
    "BinaryOpKind", "Binary operator kind for C expressions", [
      I32EnumAttrCase<"Add",    0>,
      I32EnumAttrCase<"Sub",    1>,
      I32EnumAttrCase<"Mul",    2>,
      I32EnumAttrCase<"Div",    3>,
      I32EnumAttrCase<"Mod",    4>,
      I32EnumAttrCase<"Shl",    5>,
      I32EnumAttrCase<"Shr",    6>,
      I32EnumAttrCase<"Sar",    7>,
      I32EnumAttrCase<"BitAnd", 8>,
      I32EnumAttrCase<"BitOr",  9>,
      I32EnumAttrCase<"BitXor",10>,
      I32EnumAttrCase<"Eq",    11>,
      I32EnumAttrCase<"Ne",    12>,
      I32EnumAttrCase<"Lt",    13>,
      I32EnumAttrCase<"Le",    14>,
      I32EnumAttrCase<"Gt",    15>,
      I32EnumAttrCase<"Ge",    16>,
      I32EnumAttrCase<"LogAnd",17>,
      I32EnumAttrCase<"LogOr", 18>,
    ]> {
  let cppNamespace = "::helix::high";
}

// ─── Unary Operator Enum ─────────────────────────────────────────────────────

def HelixHigh_UnaryOpKind : I32EnumAttr<
    "UnaryOpKind", "Unary operator kind for C expressions", [
      I32EnumAttrCase<"Neg",       0>,
      I32EnumAttrCase<"LogNot",    1>,
      I32EnumAttrCase<"BitNot",    2>,
      I32EnumAttrCase<"Deref",     3>,
      I32EnumAttrCase<"AddressOf", 4>,
    ]> {
  let cppNamespace = "::helix::high";
}

// ═══════════════════════════════════════════════════════════════════════════════
// Expression Operations
// ═══════════════════════════════════════════════════════════════════════════════

def HelixHigh_IntLitOp : HelixHigh_Op<"int.lit", [Pure]> {
  let summary = "Integer literal";
  let description = [{
    An integer constant value. Values >= 16 or <= -16 are rendered in hex format
    in the pseudo-C output (matching the Rust emitter convention).
  }];

  let arguments = (ins
    SI64Attr:$value,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyInteger:$result);

  let assemblyFormat = [{
    $value (`at` $address^)? attr-dict `:` type($result)
  }];
}

def HelixHigh_FloatLitOp : HelixHigh_Op<"float.lit", [Pure]> {
  let summary = "Floating-point literal";

  let arguments = (ins
    F64Attr:$value,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyFloat:$result);

  let assemblyFormat = [{
    $value (`at` $address^)? attr-dict `:` type($result)
  }];
}

def HelixHigh_StringLitOp : HelixHigh_Op<"string.lit", [Pure]> {
  let summary = "String literal";

  let arguments = (ins
    StrAttr:$value,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $value (`at` $address^)? attr-dict `:` type($result)
  }];
}

def HelixHigh_VarRefOp : HelixHigh_Op<"var.ref", [Pure]> {
  let summary = "Reference to a local variable or parameter";
  let description = [{
    References a previously declared variable by its unique ID within the
    function. The var_name is used for pseudo-C emission.
  }];

  let arguments = (ins
    UI32Attr:$var_id,
    StrAttr:$var_name,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $var_id $var_name (`at` $address^)? attr-dict `:` type($result)
  }];
}

def HelixHigh_AddrLitOp : HelixHigh_Op<"addr.lit", [Pure]> {
  let summary = "Address literal (global reference or jump table entry)";

  let arguments = (ins
    UI64Attr:$addr_value,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $addr_value (`at` $address^)? attr-dict `:` type($result)
  }];
}

def HelixHigh_BinaryOp : HelixHigh_Op<"binary", [Pure]> {
  let summary = "Binary operation expression";
  let description = [{
    A C-level binary expression. The operator is an enum matching the Rust
    HirBinOp enum. Both operands must be type-compatible (ensured by the
    type propagation pass).
  }];

  let arguments = (ins
    HelixHigh_BinaryOpKind:$op,
    AnyType:$lhs,
    AnyType:$rhs,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $op $lhs `,` $rhs (`at` $address^)? attr-dict
    `:` type($lhs) `,` type($rhs) `->` type($result)
  }];
}

def HelixHigh_UnaryOp : HelixHigh_Op<"unary", [Pure]> {
  let summary = "Unary operation expression";

  let arguments = (ins
    HelixHigh_UnaryOpKind:$op,
    AnyType:$operand,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $op $operand (`at` $address^)? attr-dict
    `:` type($operand) `->` type($result)
  }];
}

def HelixHigh_CastOp : HelixHigh_Op<"cast", [Pure]> {
  let summary = "Type cast expression";

  let arguments = (ins
    AnyType:$input,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $input (`at` $address^)? attr-dict `:` type($input) `to` type($result)
  }];
}

def HelixHigh_CallOp : HelixHigh_Op<"call", []> {
  let summary = "Function call with recovered arguments";
  let description = [{
    A function call with explicitly recovered arguments (folded from register
    writes by the calling convention recovery pass). The return_type determines
    whether the call produces a usable result.
  }];

  let arguments = (ins
    UI64Attr:$target_addr,
    StrAttr:$target_name,
    Variadic<AnyType>:$args,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs Optional<AnyType>:$result);

  let assemblyFormat = [{
    $target_name `(` $args `)` `target` $target_addr
    (`at` $address^)? attr-dict
    `:` functional-type($args, results)
  }];
}

def HelixHigh_SubscriptOp : HelixHigh_Op<"subscript", [Pure]> {
  let summary = "Array or pointer subscript: base[index]";

  let arguments = (ins
    AnyType:$base,
    AnyType:$index,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $base `[` $index `]` (`at` $address^)? attr-dict
    `:` type($base) `,` type($index) `->` type($result)
  }];
}

def HelixHigh_FieldAccessOp : HelixHigh_Op<"field", [Pure]> {
  let summary = "Struct field access: expr.field or expr->field";

  let arguments = (ins
    AnyType:$base,
    StrAttr:$field_name,
    UI64Attr:$field_offset,
    BoolAttr:$is_pointer,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $base $field_name `offset` $field_offset
    (`ptr` $is_pointer^)? (`at` $address^)? attr-dict
    `:` type($base) `->` type($result)
  }];
}

def HelixHigh_TernaryOp : HelixHigh_Op<"ternary", [Pure]> {
  let summary = "Ternary expression: cond ? then : else";
  let description = [{
    Generated from CMOV operations. Represents a C ternary expression.
  }];

  let arguments = (ins
    I1:$cond,
    AnyType:$true_val,
    AnyType:$false_val,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $cond `?` $true_val `:` $false_val (`at` $address^)? attr-dict
    `:` type($true_val)
  }];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Statement Operations
// ═══════════════════════════════════════════════════════════════════════════════

def HelixHigh_VarDeclOp : HelixHigh_Op<"var.decl", []> {
  let summary = "Variable declaration with optional initializer";
  let description = [{
    Declares a local variable with type, storage class, and optional
    initializer. Maps to `HirStmt::VarDecl` in the Rust HIR.
  }];

  let arguments = (ins
    UI32Attr:$var_id,
    StrAttr:$var_name,
    HelixHigh_StorageKind:$storage,
    OptionalAttr<SI64Attr>:$stack_offset,
    Optional<AnyType>:$init,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $var_id $var_name $storage (`stack_offset` $stack_offset^)?
    (`=` $init^ `:` type($init))? (`at` $address^)? attr-dict
  }];
}

def HelixHigh_AssignOp : HelixHigh_Op<"assign", []> {
  let summary = "Assignment statement: target = value";

  let arguments = (ins
    AnyType:$target,
    AnyType:$value,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $target `=` $value (`at` $address^)? attr-dict
    `:` type($target) `,` type($value)
  }];
}

def HelixHigh_ExprStmtOp : HelixHigh_Op<"expr.stmt", []> {
  let summary = "Expression statement (discarded value, e.g., void call)";

  let arguments = (ins
    AnyType:$expr,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $expr (`at` $address^)? attr-dict `:` type($expr)
  }];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Control Flow Operations (region-based)
// ═══════════════════════════════════════════════════════════════════════════════

def HelixHigh_IfOp : HelixHigh_Op<"if", [RecursiveSideEffects, NoRegionArguments]> {
  let summary = "If-else statement with region-based bodies";
  let description = [{
    Structured if-else statement. The `thenRegion` is always present.
    The `elseRegion` may be empty (no else clause). Uses MLIR regions
    for nested structure, avoiding the flat index-based approach of the Rust HIR.
  }];

  let arguments = (ins
    I1:$condition,
    OptionalAttr<UI64Attr>:$address
  );
  let regions = (region
    SizedRegion<1>:$thenRegion,
    AnyRegion:$elseRegion
  );

  let assemblyFormat = [{
    $condition (`at` $address^)? attr-dict $thenRegion
    (`else` $elseRegion^)?
  }];
}

def HelixHigh_WhileOp : HelixHigh_Op<"while", [RecursiveSideEffects]> {
  let summary = "While loop with condition region and body region";
  let description = [{
    Structured while loop. The `condRegion` computes the loop condition
    (yields an i1 value). The `bodyRegion` contains the loop body.
  }];

  let arguments = (ins
    OptionalAttr<UI64Attr>:$address
  );
  let regions = (region
    SizedRegion<1>:$condRegion,
    SizedRegion<1>:$bodyRegion
  );

  let assemblyFormat = [{
    (`at` $address^)? attr-dict `cond` $condRegion `body` $bodyRegion
  }];
}

def HelixHigh_DoWhileOp : HelixHigh_Op<"do_while", [RecursiveSideEffects]> {
  let summary = "Do-while loop (body executes at least once)";

  let arguments = (ins
    OptionalAttr<UI64Attr>:$address
  );
  let regions = (region
    SizedRegion<1>:$bodyRegion,
    SizedRegion<1>:$condRegion
  );

  let assemblyFormat = [{
    (`at` $address^)? attr-dict `body` $bodyRegion `cond` $condRegion
  }];
}

def HelixHigh_ForOp : HelixHigh_Op<"for", [RecursiveSideEffects]> {
  let summary = "For loop with init, condition, step, and body regions";

  let arguments = (ins
    OptionalAttr<UI64Attr>:$address
  );
  let regions = (region
    SizedRegion<1>:$initRegion,
    SizedRegion<1>:$condRegion,
    SizedRegion<1>:$stepRegion,
    SizedRegion<1>:$bodyRegion
  );

  let assemblyFormat = [{
    (`at` $address^)? attr-dict
    `init` $initRegion `cond` $condRegion `step` $stepRegion `body` $bodyRegion
  }];
}

def HelixHigh_SwitchOp : HelixHigh_Op<"switch", [RecursiveSideEffects]> {
  let summary = "Switch statement with case regions";

  let arguments = (ins
    AnyType:$selector,
    DenseI64ArrayAttr:$case_values,
    OptionalAttr<UI64Attr>:$address
  );
  let regions = (region
    VariadicRegion<AnyRegion>:$caseRegions
  );

  let assemblyFormat = [{
    $selector `cases` $case_values (`at` $address^)? attr-dict
    `:` type($selector) $caseRegions
  }];
}

// ─── Loop/Switch Control ─────────────────────────────────────────────────────

def HelixHigh_ReturnOp : HelixHigh_Op<"return", [Terminator]> {
  let summary = "Return from function with optional value";

  let arguments = (ins
    Optional<AnyType>:$value,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    ($value^ `:` type($value))? (`at` $address^)? attr-dict
  }];
}

def HelixHigh_BreakOp : HelixHigh_Op<"break", [Terminator]> {
  let summary = "Break out of innermost loop or switch";

  let arguments = (ins
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    (`at` $address^)? attr-dict
  }];
}

def HelixHigh_ContinueOp : HelixHigh_Op<"continue", [Terminator]> {
  let summary = "Continue to next iteration of innermost loop";

  let arguments = (ins
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    (`at` $address^)? attr-dict
  }];
}

def HelixHigh_GotoOp : HelixHigh_Op<"goto", [Terminator]> {
  let summary = "Goto (fallback for irreducible control flow)";

  let arguments = (ins
    StrAttr:$label,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $label (`at` $address^)? attr-dict
  }];
}

def HelixHigh_LabelOp : HelixHigh_Op<"label", []> {
  let summary = "Label target for goto statements";

  let arguments = (ins
    StrAttr:$name,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $name (`at` $address^)? attr-dict
  }];
}

def HelixHigh_YieldOp : HelixHigh_Op<"yield", [Terminator]> {
  let summary = "Yield a value from a region (e.g., condition region yields i1)";

  let arguments = (ins
    Optional<AnyType>:$value
  );

  let assemblyFormat = [{
    ($value^ `:` type($value))? attr-dict
  }];
}

// ─── Misc ────────────────────────────────────────────────────────────────────

def HelixHigh_CommentOp : HelixHigh_Op<"comment", []> {
  let summary = "Inline comment in the decompiled output";

  let arguments = (ins
    StrAttr:$text
  );

  let assemblyFormat = [{
    $text attr-dict
  }];
}

def HelixHigh_AsmOp : HelixHigh_Op<"asm", []> {
  let summary = "Inline assembly (unreconstructable code)";

  let arguments = (ins
    StrAttr:$text,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $text (`at` $address^)? attr-dict
  }];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Function Operation
// ═══════════════════════════════════════════════════════════════════════════════

def HelixHigh_FuncOp : HelixHigh_Op<"func", [
    IsolatedFromAbove, Symbol
  ]> {
  let summary = "A decompiled C function";
  let description = [{
    Represents a fully decompiled function with recovered signature, parameters,
    local variables, and structured body. This is the top-level output unit.

    Maps to `HirFunction` in the Rust HIR and `DecompiledFunction` in the
    FlatBuffers AST schema.
  }];

  let arguments = (ins
    SymbolNameAttr:$sym_name,
    UI64Attr:$entry_address,
    OptionalAttr<StrAttr>:$calling_convention,
    OptionalAttr<UnitAttr>:$is_variadic
  );
  let regions = (region SizedRegion<1>:$body);

  let assemblyFormat = [{
    $sym_name `entry` $entry_address
    (`cc` $calling_convention^)?
    (`variadic` $is_variadic^)?
    attr-dict-with-keyword $body
  }];
}

// ─── Module Operation ────────────────────────────────────────────────────────

def HelixHigh_ModuleOp : HelixHigh_Op<"module", [
    IsolatedFromAbove, SymbolTable, NoTerminator
  ]> {
  let summary = "A decompiled binary module containing functions";

  let arguments = (ins
    StrAttr:$module_name,
    StrAttr:$arch
  );
  let regions = (region SizedRegion<1>:$body);

  let assemblyFormat = [{
    $module_name `arch` $arch attr-dict-with-keyword $body
  }];
}

#endif // HELIX_HIGH_OPS_TD
