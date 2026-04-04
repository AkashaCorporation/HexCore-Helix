/// @file HelixMidOps.td
/// @brief TableGen operation definitions for the Helix Mid-Level Dialect.
///
/// Operations at this level are ISA-agnostic: no register names, no flags,
/// no calling-convention details.  Values are typed, control flow is
/// structured (regions), and variables are identified by abstract slot IDs.

#ifndef HELIX_MID_OPS_TD
#define HELIX_MID_OPS_TD

include "mlir/IR/OpBase.td"
include "mlir/IR/EnumAttr.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "dialects/HelixMidDialect.td"
include "dialects/HelixMidTypes.td"

// ─── Base Class ──────────────────────────────────────────────────────────────

class HelixMid_Op<string mnemonic, list<Trait> traits = []>
    : Op<HelixMid_Dialect, mnemonic, traits>;

// ─── Binary Expression Kind ──────────────────────────────────────────────────

def HelixMid_BinExprKind : I32EnumAttr<
    "BinExprKind", "Typed binary expression kind (no flags)", [
      I32EnumAttrCase<"Add",    0>,
      I32EnumAttrCase<"Sub",    1>,
      I32EnumAttrCase<"Mul",    2>,
      I32EnumAttrCase<"Div",    3>,
      I32EnumAttrCase<"Mod",    4>,
      I32EnumAttrCase<"BitAnd", 5>,
      I32EnumAttrCase<"BitOr",  6>,
      I32EnumAttrCase<"BitXor", 7>,
      I32EnumAttrCase<"Shl",    8>,
      I32EnumAttrCase<"Shr",    9>,
      I32EnumAttrCase<"Sar",   10>,
      I32EnumAttrCase<"Eq",    11>,
      I32EnumAttrCase<"Ne",    12>,
      I32EnumAttrCase<"Lt",    13>,
      I32EnumAttrCase<"Le",    14>,
      I32EnumAttrCase<"Gt",    15>,
      I32EnumAttrCase<"Ge",    16>,
      I32EnumAttrCase<"LogAnd",17>,
      I32EnumAttrCase<"LogOr", 18>,
    ]> {
  let cppNamespace = "::helix::mid";
}

// ─── Unary Expression Kind ──────────────────────────────────────────────────

def HelixMid_UnExprKind : I32EnumAttr<
    "UnExprKind", "Typed unary expression kind", [
      I32EnumAttrCase<"Neg",       0>,
      I32EnumAttrCase<"LogNot",    1>,
      I32EnumAttrCase<"BitNot",    2>,
      I32EnumAttrCase<"Deref",     3>,
      I32EnumAttrCase<"AddrOf",    4>,
    ]> {
  let cppNamespace = "::helix::mid";
}

// ═══════════════════════════════════════════════════════════════════════════════
// Variable Operations
// ═══════════════════════════════════════════════════════════════════════════════

def HelixMid_VarDeclOp : HelixMid_Op<"var.decl", []> {
  let summary = "Declare an abstract variable slot";
  let description = [{
    Declares a variable identified by a numeric slot ID and storage kind.
    At this level the variable does NOT yet have a human-readable name —
    naming happens during HelixMid → HelixHigh lowering.

    The `slot_id` is unique within the function.  The `slot_kind` indicates
    provenance (stack frame, register, parameter, temporary).
  }];

  let arguments = (ins
    UI32Attr:$slot_id,
    HelixMid_SlotKind:$slot_kind,
    OptionalAttr<SI64Attr>:$stack_offset,
    Optional<AnyType>:$init,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $slot_id $slot_kind (`stack_offset` $stack_offset^)?
    (`=` $init^ `:` type($init))? (`at` $address^)? attr-dict
  }];
}

def HelixMid_VarRefOp : HelixMid_Op<"var.ref", [Pure]> {
  let summary = "Reference a previously declared variable slot";

  let arguments = (ins
    UI32Attr:$slot_id,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $slot_id (`at` $address^)? attr-dict `:` type($result)
  }];
}

def HelixMid_AssignOp : HelixMid_Op<"assign", [MemoryEffects<[MemWrite]>]> {
  let summary = "Assign a value to a variable slot";

  let arguments = (ins
    UI32Attr:$slot_id,
    AnyType:$value,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $slot_id `=` $value (`at` $address^)? attr-dict `:` type($value)
  }];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Memory Operations (typed)
// ═══════════════════════════════════════════════════════════════════════════════

def HelixMid_LoadOp : HelixMid_Op<"load", [MemoryEffects<[MemRead]>]> {
  let summary = "Typed memory load";
  let description = [{
    Loads a typed value from memory at the given address.  Unlike
    `helix_low.mem.read` which carries only a raw bit width, this op
    produces a value whose MLIR type reflects the resolved C type.
  }];

  let arguments = (ins
    AnyType:$addr,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $addr (`at` $address^)? attr-dict `:` type($addr) `->` type($result)
  }];
}

def HelixMid_StoreOp : HelixMid_Op<"store", [MemoryEffects<[MemWrite]>]> {
  let summary = "Typed memory store";

  let arguments = (ins
    AnyType:$addr,
    AnyType:$value,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $value `to` $addr (`at` $address^)? attr-dict `:` type($value) `,` type($addr)
  }];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Expression Operations (pure, no side effects, no flags)
// ═══════════════════════════════════════════════════════════════════════════════

def HelixMid_BinExprOp : HelixMid_Op<"binexpr", [Pure]> {
  let summary = "Typed binary expression (value result only, no flags)";
  let description = [{
    A binary expression that produces a single typed result.  Unlike
    `helix_low.binop` which also produces carry/zero/sign/overflow flags,
    this op is purely value-oriented — flag semantics have been resolved
    into explicit comparisons during HelixLow → HelixMid conversion.
  }];

  let arguments = (ins
    HelixMid_BinExprKind:$kind,
    AnyType:$lhs,
    AnyType:$rhs,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $kind $lhs `,` $rhs (`at` $address^)? attr-dict
    `:` type($lhs) `,` type($rhs) `->` type($result)
  }];
}

def HelixMid_UnExprOp : HelixMid_Op<"unexpr", [Pure]> {
  let summary = "Typed unary expression";

  let arguments = (ins
    HelixMid_UnExprKind:$kind,
    AnyType:$operand,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $kind $operand (`at` $address^)? attr-dict
    `:` type($operand) `->` type($result)
  }];
}

def HelixMid_CastOp : HelixMid_Op<"cast", [Pure]> {
  let summary = "Type conversion (zero-extend, sign-extend, truncate, bitcast)";

  let arguments = (ins
    AnyType:$input,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $input (`at` $address^)? attr-dict `:` type($input) `to` type($result)
  }];
}

def HelixMid_SelectOp : HelixMid_Op<"select", [Pure]> {
  let summary = "Conditional value selection (SSA phi replacement)";
  let description = [{
    Selects between two values based on an i1 condition.  This replaces
    both CMOV patterns and phi nodes from the SSA graph.
  }];

  let arguments = (ins
    I1:$condition,
    AnyType:$true_val,
    AnyType:$false_val,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $condition `,` $true_val `,` $false_val (`at` $address^)? attr-dict
    `:` type($true_val) `,` type($false_val) `->` type($result)
  }];
}

def HelixMid_ConstantOp : HelixMid_Op<"constant", [Pure]> {
  let summary = "Typed constant value";

  let arguments = (ins
    SI64Attr:$value,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $value (`at` $address^)? attr-dict `:` type($result)
  }];
}

def HelixMid_AddrConstOp : HelixMid_Op<"addr.const", [Pure]> {
  let summary = "Address constant (global reference, jump table entry)";

  let arguments = (ins
    UI64Attr:$addr_value,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $addr_value (`at` $address^)? attr-dict `:` type($result)
  }];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pointer Arithmetic Operations
// ═══════════════════════════════════════════════════════════════════════════════

def HelixMid_FieldPtrOp : HelixMid_Op<"field.ptr", [Pure]> {
  let summary = "Compute pointer to struct field: base + offset";

  let arguments = (ins
    AnyType:$base,
    UI64Attr:$field_offset,
    OptionalAttr<StrAttr>:$field_name,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $base `+` $field_offset (`name` $field_name^)?
    (`at` $address^)? attr-dict
    `:` type($base) `->` type($result)
  }];
}

def HelixMid_IndexPtrOp : HelixMid_Op<"index.ptr", [Pure]> {
  let summary = "Compute pointer to array element: base + index * stride";

  let arguments = (ins
    AnyType:$base,
    AnyType:$index,
    UI32Attr:$stride,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyType:$result);

  let assemblyFormat = [{
    $base `[` $index `*` $stride `]`
    (`at` $address^)? attr-dict
    `:` type($base) `,` type($index) `->` type($result)
  }];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Call Operation
// ═══════════════════════════════════════════════════════════════════════════════

def HelixMid_CallOp : HelixMid_Op<"call", [MemoryEffects<[MemRead, MemWrite]>]> {
  let summary = "Typed function call with resolved arguments";
  let description = [{
    A function call where arguments have been resolved from register writes
    by the calling convention pass and typed by the type propagation pass.
    The callee is identified by address and optional resolved name.
  }];

  let arguments = (ins
    UI64Attr:$callee_addr,
    OptionalAttr<StrAttr>:$callee_name,
    Variadic<AnyType>:$args,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs Optional<AnyType>:$result);

  let assemblyFormat = [{
    ($callee_name^)? `target` $callee_addr `(` $args `)`
    (`at` $address^)? attr-dict
    `:` functional-type($args, results)
  }];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Control Flow Operations (region-based, structured)
// ═══════════════════════════════════════════════════════════════════════════════

def HelixMid_IfOp : HelixMid_Op<"if", [RecursiveMemoryEffects, NoRegionArguments]> {
  let summary = "Structured if-else with regions";
  let description = [{
    Structured conditional.  The `thenRegion` always exists.  The `elseRegion`
    may be empty.  Identical semantics to `helix_high.if` but at the mid level
    (before variable naming and C formatting).
  }];

  let arguments = (ins
    I1:$condition,
    OptionalAttr<UI64Attr>:$address
  );
  let regions = (region
    AnyRegion:$thenRegion,
    AnyRegion:$elseRegion
  );

  let assemblyFormat = [{
    $condition (`at` $address^)? attr-dict-with-keyword $thenRegion
    (`else` $elseRegion^)?
  }];
}

def HelixMid_WhileOp : HelixMid_Op<"while", [RecursiveMemoryEffects]> {
  let summary = "While loop with condition region and body region";
  let description = [{
    A while loop where the condition is evaluated in a separate region (yields
    i1) and the body is executed if the condition is true.  The condition
    region is re-evaluated after each iteration.
  }];

  let arguments = (ins
    OptionalAttr<UI64Attr>:$address
  );
  let regions = (region
    SizedRegion<1>:$condRegion,
    AnyRegion:$bodyRegion
  );

  let assemblyFormat = [{
    (`at` $address^)? attr-dict-with-keyword `cond` $condRegion `body` $bodyRegion
  }];
}

def HelixMid_DoWhileOp : HelixMid_Op<"do_while", [RecursiveMemoryEffects]> {
  let summary = "Do-while loop (body executes at least once)";

  let arguments = (ins
    OptionalAttr<UI64Attr>:$address
  );
  let regions = (region
    SizedRegion<1>:$bodyRegion,
    SizedRegion<1>:$condRegion
  );

  let assemblyFormat = [{
    (`at` $address^)? attr-dict-with-keyword `body` $bodyRegion `cond` $condRegion
  }];
}

def HelixMid_ForOp : HelixMid_Op<"for", [RecursiveMemoryEffects]> {
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
    (`at` $address^)? attr-dict-with-keyword
    `init` $initRegion `cond` $condRegion `step` $stepRegion `body` $bodyRegion
  }];
}

def HelixMid_SwitchOp : HelixMid_Op<"switch", [RecursiveMemoryEffects]> {
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
    $selector `cases` $case_values (`at` $address^)? attr-dict-with-keyword
    `:` type($selector) $caseRegions
  }];
}

// ─── Terminators / Loop Control ──────────────────────────────────────────────

def HelixMid_ReturnOp : HelixMid_Op<"return", [Terminator]> {
  let summary = "Function return with optional value";

  let arguments = (ins
    Optional<AnyType>:$value,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    ($value^ `:` type($value))? (`at` $address^)? attr-dict
  }];
}

def HelixMid_BreakOp : HelixMid_Op<"break", [Terminator]> {
  let summary = "Break out of innermost loop or switch";

  let arguments = (ins OptionalAttr<UI64Attr>:$address);
  let assemblyFormat = [{ (`at` $address^)? attr-dict }];
}

def HelixMid_ContinueOp : HelixMid_Op<"continue", [Terminator]> {
  let summary = "Continue to next iteration of innermost loop";

  let arguments = (ins OptionalAttr<UI64Attr>:$address);
  let assemblyFormat = [{ (`at` $address^)? attr-dict }];
}

def HelixMid_GotoOp : HelixMid_Op<"goto", [Terminator]> {
  let summary = "Goto (fallback for irreducible control flow)";

  let arguments = (ins
    StrAttr:$label,
    OptionalAttr<UI64Attr>:$address
  );
  let assemblyFormat = [{ $label (`at` $address^)? attr-dict }];
}

def HelixMid_LabelOp : HelixMid_Op<"label", []> {
  let summary = "Label target for goto statements";

  let arguments = (ins
    StrAttr:$name,
    OptionalAttr<UI64Attr>:$address
  );
  let assemblyFormat = [{ $name (`at` $address^)? attr-dict }];
}

def HelixMid_YieldOp : HelixMid_Op<"yield", [Terminator]> {
  let summary = "Yield a value from a region";

  let arguments = (ins Optional<AnyType>:$value);
  let assemblyFormat = [{ ($value^ `:` type($value))? attr-dict }];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Function & Module
// ═══════════════════════════════════════════════════════════════════════════════

def HelixMid_FuncOp : HelixMid_Op<"func", [
    IsolatedFromAbove, Symbol
  ]> {
  let summary = "Typed function with abstract parameter slots";
  let description = [{
    A function with a resolved prototype (return type, parameter types) but
    abstract variable naming.  Parameters are slot IDs, not human names.
    The body contains HelixMid operations in structured form.
  }];

  let arguments = (ins
    SymbolNameAttr:$sym_name,
    UI64Attr:$entry_address,
    OptionalAttr<StrAttr>:$original_name,
    OptionalAttr<StrAttr>:$calling_convention
  );
  let regions = (region AnyRegion:$body);

  let assemblyFormat = [{
    $sym_name `entry` $entry_address
    (`original_name` $original_name^)?
    (`cc` $calling_convention^)?
    attr-dict-with-keyword $body
  }];
}

def HelixMid_ModuleOp : HelixMid_Op<"module", [
    IsolatedFromAbove, SymbolTable, NoTerminator
  ]> {
  let summary = "Container for mid-level functions";

  let arguments = (ins
    StrAttr:$module_name,
    StrAttr:$arch
  );
  let regions = (region SizedRegion<1>:$body);

  let assemblyFormat = [{
    $module_name `arch` $arch attr-dict-with-keyword $body
  }];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Intrinsic Operations
// ═══════════════════════════════════════════════════════════════════════════════

def HelixMid_MemcpyOp : HelixMid_Op<"memcpy", []> {
  let summary = "memcpy intrinsic (from REP MOVS)";

  let arguments = (ins
    AnyType:$dst,
    AnyType:$src,
    AnyType:$count,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $dst `,` $src `,` $count (`at` $address^)? attr-dict
    `:` type($dst) `,` type($src) `,` type($count)
  }];
}

def HelixMid_MemsetOp : HelixMid_Op<"memset", []> {
  let summary = "memset intrinsic (from REP STOS)";

  let arguments = (ins
    AnyType:$dst,
    AnyType:$value,
    AnyType:$count,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $dst `,` $value `,` $count (`at` $address^)? attr-dict
    `:` type($dst) `,` type($value) `,` type($count)
  }];
}

def HelixMid_CommentOp : HelixMid_Op<"comment", []> {
  let summary = "Annotation comment (preserved through lowering)";

  let arguments = (ins StrAttr:$text);
  let assemblyFormat = [{ $text attr-dict }];
}

#endif // HELIX_MID_OPS_TD
