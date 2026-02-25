/// @file HelixLowOps.td
/// @brief TableGen operation definitions for the Helix Low-Level Dialect.
///
/// Operations represent machine-level semantics after Remill pattern
/// recognition. Each operation carries an optional `address` attribute
/// linking it back to the original binary address (PC value).

#ifndef HELIX_LOW_OPS_TD
#define HELIX_LOW_OPS_TD

include "mlir/IR/OpBase.td"
include "mlir/IR/EnumAttr.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "dialects/HelixLowDialect.td"
include "dialects/HelixLowTypes.td"

// ─── Base Class ──────────────────────────────────────────────────────────────

class HelixLow_Op<string mnemonic, list<Trait> traits = []>
    : Op<HelixLow_Dialect, mnemonic, traits>;

// ─── Enums ───────────────────────────────────────────────────────────────────

def HelixLow_BinOpKind : I32EnumAttr<
    "BinOpKind", "Binary operation kind", [
      I32EnumAttrCase<"Add",    0>,
      I32EnumAttrCase<"Sub",    1>,
      I32EnumAttrCase<"Mul",    2>,
      I32EnumAttrCase<"IMul",   3>,
      I32EnumAttrCase<"Div",    4>,
      I32EnumAttrCase<"IDiv",   5>,
      I32EnumAttrCase<"And",    6>,
      I32EnumAttrCase<"Or",     7>,
      I32EnumAttrCase<"Xor",    8>,
      I32EnumAttrCase<"Shl",    9>,
      I32EnumAttrCase<"Shr",   10>,
      I32EnumAttrCase<"Sar",   11>,
      I32EnumAttrCase<"Rol",   12>,
      I32EnumAttrCase<"Ror",   13>,
    ]> {
  let cppNamespace = "::helix::low";
}

def HelixLow_UnaryOpKind : I32EnumAttr<
    "UnaryOpKind", "Unary operation kind", [
      I32EnumAttrCase<"Neg",    0>,
      I32EnumAttrCase<"Not",    1>,
      I32EnumAttrCase<"Inc",    2>,
      I32EnumAttrCase<"Dec",    3>,
      I32EnumAttrCase<"Bswap",  4>,
      I32EnumAttrCase<"Bsf",    5>,
      I32EnumAttrCase<"Bsr",    6>,
    ]> {
  let cppNamespace = "::helix::low";
}

// ─── Register Operations ─────────────────────────────────────────────────────

def HelixLow_RegReadOp : HelixLow_Op<"reg.read", [Pure]> {
  let summary = "Read a value from a CPU register";
  let description = [{
    Reads the current value of a CPU register. The register is identified by
    name (e.g., "RAX", "RBX", "AL") and bit width. This operation is generated
    from Remill's `getelementptr + load` pattern on the State struct with
    `!remill_register` metadata.
  }];

  let arguments = (ins
    StrAttr:$reg_name,
    UI32Attr:$bit_width,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyInteger:$result);

  let assemblyFormat = [{
    $reg_name `,` $bit_width (`at` $address^)? attr-dict `:` type($result)
  }];
}

def HelixLow_RegWriteOp : HelixLow_Op<"reg.write", []> {
  let summary = "Write a value to a CPU register";
  let description = [{
    Writes a value to a CPU register. Generated from Remill's `store` to a
    State struct GEP with `!remill_register` metadata, or from MOV semantic
    function calls.
  }];

  let arguments = (ins
    AnyInteger:$value,
    StrAttr:$reg_name,
    UI32Attr:$bit_width,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $value `,` $reg_name `,` $bit_width (`at` $address^)? attr-dict `:` type($value)
  }];
}

// ─── Memory Operations ───────────────────────────────────────────────────────

def HelixLow_MemReadOp : HelixLow_Op<"mem.read", []> {
  let summary = "Read from memory at an address";
  let description = [{
    Reads a value from memory at the given virtual address. Generated from
    Remill `__remill_read_memory_N` intrinsic calls. The `bit_width` matches
    the N suffix (8, 16, 32, 64).
  }];

  let arguments = (ins
    AnyInteger:$addr,
    UI32Attr:$bit_width,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyInteger:$result);

  let assemblyFormat = [{
    $addr `,` $bit_width (`at` $address^)? attr-dict `:` type($addr) `->` type($result)
  }];
}

def HelixLow_MemWriteOp : HelixLow_Op<"mem.write", []> {
  let summary = "Write to memory at an address";
  let description = [{
    Writes a value to memory at the given virtual address. Generated from
    Remill `__remill_write_memory_N` intrinsic calls.
  }];

  let arguments = (ins
    AnyInteger:$addr,
    AnyInteger:$value,
    UI32Attr:$bit_width,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $addr `,` $value `,` $bit_width (`at` $address^)? attr-dict `:` type($addr) `,` type($value)
  }];
}

// ─── Arithmetic/Logic Operations ─────────────────────────────────────────────

def HelixLow_BinOp : HelixLow_Op<"binop", [Pure]> {
  let summary = "Binary arithmetic/logic operation with flag output";
  let description = [{
    Performs a binary arithmetic or logic operation. Produces both the result
    value and CPU status flags (carry, zero, sign, overflow). Generated from
    Remill semantic function calls (ADD, SUB, MUL, AND, OR, XOR, SHL, SHR, SAR).
  }];

  let arguments = (ins
    HelixLow_BinOpKind:$kind,
    AnyInteger:$lhs,
    AnyInteger:$rhs,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs
    AnyInteger:$result,
    I1:$carry_flag,
    I1:$zero_flag,
    I1:$sign_flag,
    I1:$overflow_flag
  );

  let assemblyFormat = [{
    $kind $lhs `,` $rhs (`at` $address^)? attr-dict
    `:` type($lhs) `,` type($rhs) `->` type($result)
  }];
}

def HelixLow_UnaryOp : HelixLow_Op<"unaryop", [Pure]> {
  let summary = "Unary operation with flag output";
  let description = [{
    Performs a unary operation (NEG, NOT, INC, DEC, BSWAP, BSF, BSR).
    Produces the result and relevant flags.
  }];

  let arguments = (ins
    HelixLow_UnaryOpKind:$kind,
    AnyInteger:$operand,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs
    AnyInteger:$result,
    I1:$zero_flag,
    I1:$sign_flag
  );

  let assemblyFormat = [{
    $kind $operand (`at` $address^)? attr-dict
    `:` type($operand) `->` type($result)
  }];
}

// ─── Comparison/Test Operations ──────────────────────────────────────────────

def HelixLow_CmpOp : HelixLow_Op<"cmp", []> {
  let summary = "Compare operation (sets flags, no result value)";
  let description = [{
    Compares two values and produces status flags. Equivalent to x86 CMP
    (subtract without storing result). Generated from Remill CMP semantic.
  }];

  let arguments = (ins
    AnyInteger:$lhs,
    AnyInteger:$rhs,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs
    I1:$carry_flag,
    I1:$zero_flag,
    I1:$sign_flag,
    I1:$overflow_flag
  );

  let assemblyFormat = [{
    $lhs `,` $rhs (`at` $address^)? attr-dict `:` type($lhs) `,` type($rhs)
  }];
}

def HelixLow_TestOp : HelixLow_Op<"test", []> {
  let summary = "Logical test (AND without storing result, sets flags)";
  let description = [{
    Performs bitwise AND of two values without storing the result, only setting
    flags. Equivalent to x86 TEST. Generated from Remill TEST semantic.
    TEST reg, reg pattern simplifies to "reg != 0" / "reg == 0".
  }];

  let arguments = (ins
    AnyInteger:$lhs,
    AnyInteger:$rhs,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs
    I1:$zero_flag,
    I1:$sign_flag
  );

  let assemblyFormat = [{
    $lhs `,` $rhs (`at` $address^)? attr-dict `:` type($lhs) `,` type($rhs)
  }];
}

// ─── Control Flow Operations ─────────────────────────────────────────────────

def HelixLow_CallOp : HelixLow_Op<"call", []> {
  let summary = "Function call (direct or indirect)";
  let description = [{
    Calls a function at the given target address. The target_name is set if
    the function name is known (from signature database or symbol table).
    At this level, arguments are implicit (in registers per calling convention).
    The calling convention pass in HelixHigh will fold explicit arguments.
  }];

  let arguments = (ins
    AnyInteger:$target_addr,
    OptionalAttr<StrAttr>:$target_name,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $target_addr (`name` $target_name^)? (`at` $address^)? attr-dict `:` type($target_addr)
  }];
}

def HelixLow_RetOp : HelixLow_Op<"ret", [Terminator]> {
  let summary = "Function return";
  let description = [{
    Returns from the current function. At this level, the return value is
    implicit (in RAX per calling convention). Generated from Remill RET semantic.
  }];

  let arguments = (ins
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    (`at` $address^)? attr-dict
  }];
}

def HelixLow_JmpOp : HelixLow_Op<"jmp", [Terminator]> {
  let summary = "Unconditional jump";
  let description = [{
    Unconditionally transfers control to the target block. Generated from
    Remill JMP semantic or fall-through edges.
  }];

  let arguments = (ins
    OptionalAttr<UI64Attr>:$target_addr,
    OptionalAttr<UI64Attr>:$address
  );
  let successors = (successor AnySuccessor:$dest);

  let assemblyFormat = [{
    $dest (`target` $target_addr^)? (`at` $address^)? attr-dict
  }];
}

def HelixLow_JccOp : HelixLow_Op<"jcc", [Terminator]> {
  let summary = "Conditional jump based on flags";
  let description = [{
    Conditionally transfers control based on a flag condition. The `condition`
    attribute stores the x86 condition code name (e.g., "z", "nz", "b", "a",
    "l", "ge", "le", "g"). Generated from Remill Jcc semantics (JZ, JNZ, etc.).
  }];

  let arguments = (ins
    StrAttr:$condition,
    I1:$flag_value,
    OptionalAttr<UI64Attr>:$address
  );
  let successors = (successor
    AnySuccessor:$trueDest,
    AnySuccessor:$falseDest
  );

  let assemblyFormat = [{
    $condition $flag_value `,` $trueDest `,` $falseDest
    (`at` $address^)? attr-dict
  }];
}

// ─── Stack Operations ────────────────────────────────────────────────────────

def HelixLow_PushOp : HelixLow_Op<"push", []> {
  let summary = "Push value onto the stack";
  let description = [{
    Pushes a value onto the stack (decrements RSP and stores). Generated from
    Remill PUSH semantic.
  }];

  let arguments = (ins
    AnyInteger:$value,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $value (`at` $address^)? attr-dict `:` type($value)
  }];
}

def HelixLow_PopOp : HelixLow_Op<"pop", []> {
  let summary = "Pop value from the stack";
  let description = [{
    Pops a value from the stack (loads from RSP and increments). Generated from
    Remill POP semantic.
  }];

  let arguments = (ins
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyInteger:$result);

  let assemblyFormat = [{
    (`at` $address^)? attr-dict `:` type($result)
  }];
}

// ─── Extension Operations ────────────────────────────────────────────────────

def HelixLow_MovZxOp : HelixLow_Op<"movzx", [Pure]> {
  let summary = "Zero-extend a value to a wider type";
  let description = [{
    Zero-extends the source value to the destination bit width. Generated from
    Remill MOVZX semantic.
  }];

  let arguments = (ins
    AnyInteger:$src,
    UI32Attr:$dst_width,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyInteger:$result);

  let assemblyFormat = [{
    $src `,` $dst_width (`at` $address^)? attr-dict `:` type($src) `->` type($result)
  }];
}

def HelixLow_MovSxOp : HelixLow_Op<"movsx", [Pure]> {
  let summary = "Sign-extend a value to a wider type";
  let description = [{
    Sign-extends the source value to the destination bit width. Generated from
    Remill MOVSX or CDQE semantics.
  }];

  let arguments = (ins
    AnyInteger:$src,
    UI32Attr:$dst_width,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyInteger:$result);

  let assemblyFormat = [{
    $src `,` $dst_width (`at` $address^)? attr-dict `:` type($src) `->` type($result)
  }];
}

// ─── Conditional Move ────────────────────────────────────────────────────────

def HelixLow_CMovOp : HelixLow_Op<"cmov", [Pure]> {
  let summary = "Conditional move based on flags";
  let description = [{
    Selects between two values based on a flag condition. Generated from
    Remill CMOVcc semantics. Lowered to a ternary expression in HelixHigh.
  }];

  let arguments = (ins
    StrAttr:$condition,
    I1:$flag_value,
    AnyInteger:$true_val,
    AnyInteger:$false_val,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyInteger:$result);

  let assemblyFormat = [{
    $condition $flag_value `,` $true_val `,` $false_val
    (`at` $address^)? attr-dict
    `:` type($true_val) `,` type($false_val) `->` type($result)
  }];
}

// ─── Exchange ────────────────────────────────────────────────────────────────

def HelixLow_XchgOp : HelixLow_Op<"xchg", []> {
  let summary = "Exchange two register values";
  let description = [{
    Atomically swaps two register values. Generated from Remill XCHG semantic.
  }];

  let arguments = (ins
    StrAttr:$reg_a,
    StrAttr:$reg_b,
    UI32Attr:$bit_width,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $reg_a `,` $reg_b `,` $bit_width (`at` $address^)? attr-dict
  }];
}

// ─── LEA (Address Computation) ───────────────────────────────────────────────

def HelixLow_LeaOp : HelixLow_Op<"lea", [Pure]> {
  let summary = "Load effective address (pure address computation)";
  let description = [{
    Computes an effective address without accessing memory. Equivalent to x86
    LEA instruction. This is a pure computation: base + index * scale + disp.
  }];

  let arguments = (ins
    AnyInteger:$base,
    AnyInteger:$index,
    UI32Attr:$scale,
    SI64Attr:$displacement,
    OptionalAttr<UI64Attr>:$address
  );
  let results = (outs AnyInteger:$result);

  let assemblyFormat = [{
    $base `,` $index `,` $scale `,` $displacement
    (`at` $address^)? attr-dict
    `:` type($base) `,` type($index) `->` type($result)
  }];
}

// ─── REP String Operations ───────────────────────────────────────────────────

def HelixLow_RepMovsOp : HelixLow_Op<"rep.movs", []> {
  let summary = "REP MOVS — block memory copy (promoted to memcpy)";
  let description = [{
    Repeating string move operation. Copies RCX bytes from RSI to RDI.
    Promoted to a memcpy intrinsic call in the HelixHigh dialect.
  }];

  let arguments = (ins
    AnyInteger:$dst,
    AnyInteger:$src,
    AnyInteger:$count,
    UI32Attr:$element_width,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $dst `,` $src `,` $count `,` $element_width
    (`at` $address^)? attr-dict
    `:` type($dst) `,` type($src) `,` type($count)
  }];
}

def HelixLow_RepStosOp : HelixLow_Op<"rep.stos", []> {
  let summary = "REP STOS — block memory fill (promoted to memset)";
  let description = [{
    Repeating string store operation. Fills RCX elements at RDI with AL/AX/EAX.
    Promoted to a memset intrinsic call in the HelixHigh dialect.
  }];

  let arguments = (ins
    AnyInteger:$dst,
    AnyInteger:$value,
    AnyInteger:$count,
    UI32Attr:$element_width,
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    $dst `,` $value `,` $count `,` $element_width
    (`at` $address^)? attr-dict
    `:` type($dst) `,` type($value) `,` type($count)
  }];
}

// ─── No-Op / Marker Operations ───────────────────────────────────────────────

def HelixLow_NopOp : HelixLow_Op<"nop", []> {
  let summary = "No operation (placeholder, removed during DCE)";

  let arguments = (ins
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    (`at` $address^)? attr-dict
  }];
}

def HelixLow_Int3Op : HelixLow_Op<"int3", []> {
  let summary = "INT3 breakpoint marker";

  let arguments = (ins
    OptionalAttr<UI64Attr>:$address
  );

  let assemblyFormat = [{
    (`at` $address^)? attr-dict
  }];
}

// ─── Function Operation ──────────────────────────────────────────────────────

def HelixLow_FuncOp : HelixLow_Op<"func", [
    IsolatedFromAbove, Symbol
  ]> {
  let summary = "A lifted function in the HelixLow dialect";
  let description = [{
    Represents a single function lifted from binary code. Contains basic blocks
    with HelixLow operations. The function takes no explicit parameters at this
    level — register reads/writes are explicit operations inside the body.
  }];

  let arguments = (ins
    SymbolNameAttr:$sym_name,
    UI64Attr:$entry_address,
    OptionalAttr<StrAttr>:$original_name
  );
  let regions = (region AnyRegion:$body);

  let assemblyFormat = [{
    $sym_name `entry` $entry_address (`original_name` $original_name^)?
    attr-dict-with-keyword $body
  }];
}

#endif // HELIX_LOW_OPS_TD
