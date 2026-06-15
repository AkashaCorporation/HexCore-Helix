//! Remill semantic decoder.
//!
//! Decodes mangled C++ names from Remill intrinsics into semantic operations.
//! Handles the `_ZN12_GLOBAL__N_1<len><name><template_suffix>` pattern.

/// Decoded Remill semantic operation.
#[derive(Debug, Clone, PartialEq)]
pub enum Semantic {
    Mov,
    Add,
    Sub,
    Xor,
    And,
    Or,
    Shl,
    Shr,
    Sar,
    Lea,
    Call,
    Ret,
    Push,
    Pop,
    Cmp,
    Test,
    Nop,
    Int3,
    Mul,
    IMul,
    Div,
    IDiv,
    Neg,
    Not,
    Inc,
    Dec,
    Jmp,
    /// Conditional jump with condition code.
    Jcc(String),
    /// Conditional move with condition code (e.g., CMOVE, CMOVNE).
    CMov(String),
    /// Exchange register contents.
    Xchg,
    /// Zero-extend move (MOVZX).
    MovZx,
    /// Sign-extend move (MOVSX / MOVSXD).
    MovSx,
    /// Bit scan forward.
    Bsf,
    /// Bit scan reverse.
    Bsr,
    /// Bit test.
    Bt,
    /// Exchange and add.
    XAdd,
    /// Byte swap (BSWAP).
    Bswap,
    /// REP MOVSB / MOVSQ (memory copy).
    RepMovs,
    /// REP STOSB / STOSQ (memory set).
    RepStos,
    /// CDQE / CQO — sign extension (RAX ← sign-extend EAX, etc.).
    Cdqe,
    /// Unrecognized semantic.
    Unknown(String),
}

impl std::fmt::Display for Semantic {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Semantic::Mov => write!(f, "mov"),
            Semantic::Add => write!(f, "add"),
            Semantic::Sub => write!(f, "sub"),
            Semantic::Xor => write!(f, "xor"),
            Semantic::And => write!(f, "and"),
            Semantic::Or => write!(f, "or"),
            Semantic::Shl => write!(f, "shl"),
            Semantic::Shr => write!(f, "shr"),
            Semantic::Sar => write!(f, "sar"),
            Semantic::Lea => write!(f, "lea"),
            Semantic::Call => write!(f, "call"),
            Semantic::Ret => write!(f, "ret"),
            Semantic::Push => write!(f, "push"),
            Semantic::Pop => write!(f, "pop"),
            Semantic::Cmp => write!(f, "cmp"),
            Semantic::Test => write!(f, "test"),
            Semantic::Nop => write!(f, "nop"),
            Semantic::Int3 => write!(f, "int3"),
            Semantic::Mul => write!(f, "mul"),
            Semantic::IMul => write!(f, "imul"),
            Semantic::Div => write!(f, "div"),
            Semantic::IDiv => write!(f, "idiv"),
            Semantic::Neg => write!(f, "neg"),
            Semantic::Not => write!(f, "not"),
            Semantic::Inc => write!(f, "inc"),
            Semantic::Dec => write!(f, "dec"),
            Semantic::Jmp => write!(f, "jmp"),
            Semantic::Jcc(cc) => write!(f, "{}", cc.to_lowercase()),
            Semantic::CMov(cc) => write!(f, "cmov{}", cc.to_lowercase()),
            Semantic::Xchg => write!(f, "xchg"),
            Semantic::MovZx => write!(f, "movzx"),
            Semantic::MovSx => write!(f, "movsx"),
            Semantic::Bsf => write!(f, "bsf"),
            Semantic::Bsr => write!(f, "bsr"),
            Semantic::Bt => write!(f, "bt"),
            Semantic::XAdd => write!(f, "xadd"),
            Semantic::Bswap => write!(f, "bswap"),
            Semantic::RepMovs => write!(f, "rep movs"),
            Semantic::RepStos => write!(f, "rep stos"),
            Semantic::Cdqe => write!(f, "cdqe"),
            Semantic::Unknown(s) => write!(f, "???_{}", s),
        }
    }
}

/// Operand class decoded from the mangled template suffix.
#[derive(Debug, Clone, PartialEq)]
pub enum OpClass {
    /// `RnW` — Register write (destination).
    RegWrite,
    /// `Rn` — Register read (source).
    RegRead,
    /// `In` — Immediate value.
    Immediate,
    /// `MnW` — Memory write.
    MemWrite,
    /// `Mn` — Memory read.
    MemRead,
}

/// Decode a mangled Remill intrinsic name into a semantic operation.
///
/// Remill intrinsics follow the C++ mangling scheme:
/// `_ZN12_GLOBAL__N_1<len><NAME><template_args>`
///
/// Where `<len>` is the character count of `<NAME>`, and `<NAME>` is
/// the semantic mnemonic (MOV, CALL, XOR, etc.).
pub fn decode_mangled_name(mangled: &str) -> Semantic {
    // Strip parenthesized function pointer suffix if present
    let name_part = mangled.split('(').next().unwrap_or(mangled);

    const PREFIX: &str = "_ZN12_GLOBAL__N_1";

    let Some(rest) = name_part.strip_prefix(PREFIX) else {
        return Semantic::Unknown(mangled.to_string());
    };

    // Parse length-prefixed name: "4CALL..." → len=4, name="CALL"
    let (len, after_len) = split_numeric_prefix(rest);
    let Ok(name_len) = len.parse::<usize>() else {
        return Semantic::Unknown(mangled.to_string());
    };

    if after_len.len() < name_len {
        return Semantic::Unknown(mangled.to_string());
    }

    let semantic_name = &after_len[..name_len];

    match semantic_name {
        "MOV" | "MOVI" => Semantic::Mov,
        "ADD" | "ADDI" => Semantic::Add,
        "SUB" | "SUBI" => Semantic::Sub,
        "XOR" | "XORI" => Semantic::Xor,
        "AND" | "ANDI" => Semantic::And,
        "OR" | "ORI" => Semantic::Or,
        "SHL" | "SHLI" => Semantic::Shl,
        "SHR" | "SHRI" => Semantic::Shr,
        "SAR" | "SARI" => Semantic::Sar,
        "LEA" | "LEAI" => Semantic::Lea,
        "CALL" | "CALLI" => Semantic::Call,
        "RET" | "RETE" | "RETN" => Semantic::Ret,
        "PUSH" | "PUSHI" => Semantic::Push,
        "POP" | "POPI" => Semantic::Pop,
        "CMP" | "CMPI" => Semantic::Cmp,
        "TEST" | "TESTI" => Semantic::Test,
        "NOP" | "NOPI" | "NOP_IMPL" => Semantic::Nop,
        "DoINT3" => Semantic::Int3,
        "MUL" | "MULI" => Semantic::Mul,
        "IMUL" | "IMULI" => Semantic::IMul,
        "DIV" | "DIVI" => Semantic::Div,
        "IDIV" | "IDIVI" => Semantic::IDiv,
        "NEG" | "NEGI" => Semantic::Neg,
        "NOT" | "NOTI" => Semantic::Not,
        "INC" | "INCI" => Semantic::Inc,
        "DEC" | "DECI" => Semantic::Dec,
        "JMP" | "JMPI" => Semantic::Jmp,
        "XCHG" | "XCHGI" => Semantic::Xchg,
        "MOVZX" | "MOVZXI" => Semantic::MovZx,
        "MOVSX" | "MOVSXI" | "MOVSXD" => Semantic::MovSx,
        "BSF" | "BSFI" => Semantic::Bsf,
        "BSR" | "BSRI" => Semantic::Bsr,
        "BT" | "BTI" => Semantic::Bt,
        "XADD" | "XADDI" => Semantic::XAdd,
        "BSWAP" | "BSWAPI" => Semantic::Bswap,
        "CDQE" | "CQO" | "CDQ" | "CWD" | "CBW" => Semantic::Cdqe,
        _ => {
            // Conditional jumps: Jcc (JE, JNE, JB, JA, etc.)
            if semantic_name.starts_with('J') && semantic_name.len() >= 2 {
                Semantic::Jcc(semantic_name.to_string())
            } else if semantic_name.starts_with("CMOV") && semantic_name.len() > 4 {
                let cc = &semantic_name[4..];
                Semantic::CMov(cc.to_string())
            } else if let Some(suffix) = semantic_name.strip_prefix("REP") {
                // REP prefix for string operations
                if suffix.starts_with("MOVS") {
                    Semantic::RepMovs
                } else if suffix.starts_with("STOS") {
                    Semantic::RepStos
                } else {
                    Semantic::Unknown(semantic_name.to_string())
                }
            } else {
                Semantic::Unknown(semantic_name.to_string())
            }
        }
    }
}

/// Extract operand classes from the mangled template suffix.
///
/// After the semantic name, the mangled suffix encodes operand types:
/// - `RnW` = register write (destination)
/// - `Rn` = register read
/// - `In` = immediate
/// - `MnW` = memory write
/// - `Mn` = memory read
pub fn decode_operand_classes(mangled: &str) -> Vec<OpClass> {
    let name_part = mangled.split('(').next().unwrap_or(mangled);
    let mut classes = Vec::new();

    // Look for operand class markers in the template suffix
    let search = name_part;
    let mut i = 0;
    let bytes = search.as_bytes();

    while i < bytes.len() {
        if i + 3 <= bytes.len() && &search[i..i + 3] == "RnW" {
            classes.push(OpClass::RegWrite);
            i += 3;
        } else if i + 3 <= bytes.len() && &search[i..i + 3] == "MnW" {
            classes.push(OpClass::MemWrite);
            i += 3;
        } else if i + 2 <= bytes.len() && &search[i..i + 2] == "Rn" {
            classes.push(OpClass::RegRead);
            i += 2;
        } else if i + 2 <= bytes.len() && &search[i..i + 2] == "Mn" {
            classes.push(OpClass::MemRead);
            i += 2;
        } else if i + 2 <= bytes.len() && &search[i..i + 2] == "In" {
            classes.push(OpClass::Immediate);
            i += 2;
        } else {
            i += 1;
        }
    }

    classes
}

/// HelixLow dialect operation that a Remill semantic maps to.
///
/// Mirrors the C++ `convertSemantic` logic in `RemillToHelixLow.cpp`.
/// Each variant corresponds to a `helix_low.*` MLIR operation.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum HelixLowOp {
    /// `helix_low.binop` — binary arithmetic/logic with flags.
    BinOp(BinOpKind),
    /// `helix_low.cmp` — comparison (sets flags, no result).
    Cmp,
    /// `helix_low.test` — logical test (AND without result, sets flags).
    Test,
    /// `helix_low.reg.write` — register write (MOV semantic).
    RegWrite,
    /// `helix_low.movzx` — zero-extend move.
    MovZx,
    /// `helix_low.movsx` — sign-extend move.
    MovSx,
    /// `helix_low.lea` — load effective address (pure computation).
    Lea,
    /// `helix_low.push` — push onto stack.
    Push,
    /// `helix_low.pop` — pop from stack.
    Pop,
    /// `helix_low.call` — function call.
    Call,
    /// `helix_low.ret` — function return.
    Ret,
    /// `helix_low.jmp` — unconditional jump.
    Jmp,
    /// `helix_low.jcc` — conditional jump with condition code.
    Jcc(String),
    /// `helix_low.cmov` — conditional move.
    CMov(String),
    /// `helix_low.nop` — no operation (removed by DCE).
    Nop,
    /// `helix_low.int3` — breakpoint marker.
    Int3,
    /// `helix_low.unaryop` — unary operation (NEG, NOT, INC, DEC, etc.).
    UnaryOp(UnaryOpKind),
    /// `helix_low.xchg` — exchange registers.
    Xchg,
    /// `helix_low.rep.movs` — REP MOVS string copy.
    RepMovs,
    /// `helix_low.rep.stos` — REP STOS string fill.
    RepStos,
}

/// Binary operation kind, mirrors `helix_low::BinOpKind` in C++.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum BinOpKind {
    Add,
    Sub,
    Mul,
    IMul,
    Div,
    IDiv,
    And,
    Or,
    Xor,
    Shl,
    Shr,
    Sar,
    Rol,
    Ror,
}

/// Unary operation kind, mirrors `helix_low::UnaryOpKind` in C++.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum UnaryOpKind {
    Neg,
    Not,
    Inc,
    Dec,
    Bswap,
    Bsf,
    Bsr,
}

/// Map a decoded `Semantic` to the corresponding `HelixLowOp`.
///
/// This is the Rust equivalent of the C++ `RemillToHelixLowPass::convertSemantic`
/// method. Returns `None` for semantics that don't have a direct HelixLow mapping
/// (e.g., `Unknown`, FPU, SSE/AVX).
pub fn semantic_to_helix_low(semantic: &Semantic) -> Option<HelixLowOp> {
    match semantic {
        // Arithmetic/logic → helix_low.binop
        Semantic::Add => Some(HelixLowOp::BinOp(BinOpKind::Add)),
        Semantic::Sub => Some(HelixLowOp::BinOp(BinOpKind::Sub)),
        Semantic::Mul => Some(HelixLowOp::BinOp(BinOpKind::Mul)),
        Semantic::IMul => Some(HelixLowOp::BinOp(BinOpKind::IMul)),
        Semantic::Div => Some(HelixLowOp::BinOp(BinOpKind::Div)),
        Semantic::IDiv => Some(HelixLowOp::BinOp(BinOpKind::IDiv)),
        Semantic::And => Some(HelixLowOp::BinOp(BinOpKind::And)),
        Semantic::Or => Some(HelixLowOp::BinOp(BinOpKind::Or)),
        Semantic::Xor => Some(HelixLowOp::BinOp(BinOpKind::Xor)),
        Semantic::Shl => Some(HelixLowOp::BinOp(BinOpKind::Shl)),
        Semantic::Shr => Some(HelixLowOp::BinOp(BinOpKind::Shr)),
        Semantic::Sar => Some(HelixLowOp::BinOp(BinOpKind::Sar)),

        // Comparison → helix_low.cmp / helix_low.test
        Semantic::Cmp => Some(HelixLowOp::Cmp),
        Semantic::Test => Some(HelixLowOp::Test),

        // Data movement → helix_low.reg.write / movzx / movsx / lea
        Semantic::Mov => Some(HelixLowOp::RegWrite),
        Semantic::MovZx => Some(HelixLowOp::MovZx),
        Semantic::MovSx | Semantic::Cdqe => Some(HelixLowOp::MovSx),
        Semantic::Lea => Some(HelixLowOp::Lea),

        // Stack → helix_low.push / pop
        Semantic::Push => Some(HelixLowOp::Push),
        Semantic::Pop => Some(HelixLowOp::Pop),

        // Control flow → helix_low.call / ret / jmp / jcc
        Semantic::Call => Some(HelixLowOp::Call),
        Semantic::Ret => Some(HelixLowOp::Ret),
        Semantic::Jmp => Some(HelixLowOp::Jmp),
        Semantic::Jcc(cc) => Some(HelixLowOp::Jcc(cc.clone())),
        Semantic::CMov(cc) => Some(HelixLowOp::CMov(cc.clone())),

        // Unary → helix_low.unaryop
        Semantic::Neg => Some(HelixLowOp::UnaryOp(UnaryOpKind::Neg)),
        Semantic::Not => Some(HelixLowOp::UnaryOp(UnaryOpKind::Not)),
        Semantic::Inc => Some(HelixLowOp::UnaryOp(UnaryOpKind::Inc)),
        Semantic::Dec => Some(HelixLowOp::UnaryOp(UnaryOpKind::Dec)),
        Semantic::Bswap => Some(HelixLowOp::UnaryOp(UnaryOpKind::Bswap)),
        Semantic::Bsf => Some(HelixLowOp::UnaryOp(UnaryOpKind::Bsf)),
        Semantic::Bsr => Some(HelixLowOp::UnaryOp(UnaryOpKind::Bsr)),

        // Exchange → helix_low.xchg
        Semantic::Xchg => Some(HelixLowOp::Xchg),

        // Special → helix_low.nop / int3
        Semantic::Nop => Some(HelixLowOp::Nop),
        Semantic::Int3 => Some(HelixLowOp::Int3),

        // String ops → helix_low.rep.*
        Semantic::RepMovs => Some(HelixLowOp::RepMovs),
        Semantic::RepStos => Some(HelixLowOp::RepStos),

        // No direct HelixLow mapping (BT, XAdd, FPU, SSE, Unknown, etc.)
        _ => None,
    }
}

/// Get the Jcc condition string for a conditional jump semantic.
///
/// Mirrors the C++ `getJccCondition()` in `RemillDemangler.cpp`.
pub fn jcc_condition(semantic: &Semantic) -> Option<&'static str> {
    match semantic {
        Semantic::Jcc(cc) => match cc.as_str() {
            "JZ" | "JE" => Some("z"),
            "JNZ" | "JNE" => Some("nz"),
            "JB" | "JC" | "JNAE" => Some("b"),
            "JNB" | "JNC" | "JAE" => Some("nb"),
            "JBE" | "JNA" => Some("be"),
            "JNBE" | "JA" => Some("nbe"),
            "JL" | "JNGE" => Some("l"),
            "JNL" | "JGE" => Some("nl"),
            "JLE" | "JNG" => Some("le"),
            "JNLE" | "JG" => Some("nle"),
            "JS" => Some("s"),
            "JNS" => Some("ns"),
            "JO" => Some("o"),
            "JNO" => Some("no"),
            "JP" | "JPE" => Some("p"),
            "JNP" | "JPO" => Some("np"),
            _ => None,
        },
        _ => None,
    }
}

fn split_numeric_prefix(s: &str) -> (&str, &str) {
    let pos = s.find(|c: char| !c.is_ascii_digit()).unwrap_or(s.len());
    (&s[..pos], &s[pos..])
}

// ─── Idiom Pattern Detection ────────────────────────────────────────────────

/// Result of idiom pattern analysis on a HelixLow operation.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum IdiomPattern {
    /// `XOR reg, reg` — both operands are the same register.
    /// Should be converted to `int.lit 0` (zero assignment).
    SelfXor,
    /// `TEST reg, reg` — both operands are the same register.
    /// Should be converted to `helix_low.cmp reg, 0`.
    TestSelfToCompareZero,
    /// `MOV reg, reg` — source and destination are the same register.
    /// Should be eliminated entirely (no-op).
    MovSelfEliminated,
}

/// Detect idiom patterns for a binary operation with two register operands.
///
/// Given a semantic and two register names (source operands), returns the
/// applicable idiom pattern if both operands reference the same register.
///
/// This is the Rust equivalent of the C++ `isSameRegisterOperand` check
/// in `RemillToHelixLow.cpp`.
pub fn detect_self_operand_idiom(
    semantic: &Semantic,
    reg_a: &str,
    reg_b: &str,
) -> Option<IdiomPattern> {
    if reg_a != reg_b {
        return None;
    }

    match semantic {
        Semantic::Xor => Some(IdiomPattern::SelfXor),
        Semantic::Test => Some(IdiomPattern::TestSelfToCompareZero),
        Semantic::Mov => Some(IdiomPattern::MovSelfEliminated),
        _ => None,
    }
}

/// Apply idiom transformation to a HelixLow operation.
///
/// Returns the transformed operation, or `None` if the operation should be
/// eliminated (e.g., MOV reg, reg).
pub fn apply_idiom(op: &HelixLowOp, idiom: &IdiomPattern) -> Option<HelixLowOp> {
    match idiom {
        IdiomPattern::SelfXor => {
            // XOR reg, reg → still emitted as BinOp(Xor) but with is_self_xor
            // flag. The DCE pass will later convert this to `int.lit 0`.
            // We keep the original op; the flag is tracked externally.
            Some(op.clone())
        }
        IdiomPattern::TestSelfToCompareZero => {
            // TEST reg, reg → CMP reg, 0
            Some(HelixLowOp::Cmp)
        }
        IdiomPattern::MovSelfEliminated => {
            // MOV reg, reg → eliminated (no operation generated)
            None
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_decode_call() {
        let name = "_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_";
        assert_eq!(decode_mangled_name(name), Semantic::Call);
    }

    #[test]
    fn test_decode_mov() {
        let name = "_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_";
        assert_eq!(decode_mangled_name(name), Semantic::Mov);
    }

    #[test]
    fn test_decode_xor() {
        let name = "_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_";
        assert_eq!(decode_mangled_name(name), Semantic::Xor);
    }

    #[test]
    fn test_decode_lea() {
        let name = "_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_";
        assert_eq!(decode_mangled_name(name), Semantic::Lea);
    }

    #[test]
    fn test_decode_ret() {
        let name = "_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE";
        assert_eq!(decode_mangled_name(name), Semantic::Ret);
    }

    #[test]
    fn test_decode_int3() {
        let name = "_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE";
        assert_eq!(decode_mangled_name(name), Semantic::Int3);
    }

    #[test]
    fn test_decode_add() {
        let name = "_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_";
        assert_eq!(decode_mangled_name(name), Semantic::Add);
    }

    #[test]
    fn test_decode_sub() {
        let name = "_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_";
        assert_eq!(decode_mangled_name(name), Semantic::Sub);
    }

    #[test]
    fn test_operand_classes_mov_reg_reg() {
        let name = "_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_";
        let classes = decode_operand_classes(name);
        assert!(classes.contains(&OpClass::RegWrite));
        assert!(classes.contains(&OpClass::RegRead));
    }

    #[test]
    fn test_operand_classes_mov_mem_imm() {
        let name = "_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_";
        let classes = decode_operand_classes(name);
        assert!(classes.contains(&OpClass::MemWrite));
        assert!(classes.contains(&OpClass::Immediate));
    }

    #[test]
    fn test_decode_xchg() {
        let name = "_ZN12_GLOBAL__N_14XCHGI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_";
        assert_eq!(decode_mangled_name(name), Semantic::Xchg);
    }

    #[test]
    fn test_decode_movzx() {
        let name = "_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_";
        assert_eq!(decode_mangled_name(name), Semantic::MovZx);
    }

    #[test]
    fn test_decode_movsx() {
        let name = "_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_";
        assert_eq!(decode_mangled_name(name), Semantic::MovSx);
    }

    #[test]
    fn test_decode_bswap() {
        let name = "_ZN12_GLOBAL__N_15BSWAPI3RnWImEEEP6MemoryS4_R5StateT_";
        assert_eq!(decode_mangled_name(name), Semantic::Bswap);
    }

    #[test]
    fn test_decode_cmov() {
        // CMOVE (conditional move if equal) — name length prefix = 5
        let name = "_ZN12_GLOBAL__N_15CMOVEI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_";
        assert_eq!(decode_mangled_name(name), Semantic::CMov("E".into()));
    }

    #[test]
    fn test_decode_cmovne() {
        let name = "_ZN12_GLOBAL__N_16CMOVNEI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_";
        assert_eq!(decode_mangled_name(name), Semantic::CMov("NE".into()));
    }

    #[test]
    fn test_decode_cdqe() {
        let name = "_ZN12_GLOBAL__N_14CDQEEP6MemoryR5State3RnWImE";
        assert_eq!(decode_mangled_name(name), Semantic::Cdqe);
    }

    #[test]
    fn test_decode_nop_impl() {
        let name = "_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_";
        assert_eq!(decode_mangled_name(name), Semantic::Nop);
    }

    #[test]
    fn test_decode_add_memory_operands() {
        let name = "_ZN12_GLOBAL__N_13ADDI3MnWIhE2MnIhE2RnIhLb1EEEEP6MemoryS8_R5StateT_T0_T1_";
        assert_eq!(decode_mangled_name(name), Semantic::Add);
        let classes = decode_operand_classes(name);
        assert_eq!(
            classes,
            vec![OpClass::MemWrite, OpClass::MemRead, OpClass::RegRead]
        );
    }

    // ── semantic_to_helix_low tests ──────────────────────────────────────

    #[test]
    fn test_arithmetic_semantics_map_to_binop() {
        assert_eq!(
            semantic_to_helix_low(&Semantic::Add),
            Some(HelixLowOp::BinOp(BinOpKind::Add))
        );
        assert_eq!(
            semantic_to_helix_low(&Semantic::Sub),
            Some(HelixLowOp::BinOp(BinOpKind::Sub))
        );
        assert_eq!(
            semantic_to_helix_low(&Semantic::Xor),
            Some(HelixLowOp::BinOp(BinOpKind::Xor))
        );
        assert_eq!(
            semantic_to_helix_low(&Semantic::And),
            Some(HelixLowOp::BinOp(BinOpKind::And))
        );
        assert_eq!(
            semantic_to_helix_low(&Semantic::Or),
            Some(HelixLowOp::BinOp(BinOpKind::Or))
        );
        assert_eq!(
            semantic_to_helix_low(&Semantic::Shl),
            Some(HelixLowOp::BinOp(BinOpKind::Shl))
        );
        assert_eq!(
            semantic_to_helix_low(&Semantic::Shr),
            Some(HelixLowOp::BinOp(BinOpKind::Shr))
        );
        assert_eq!(
            semantic_to_helix_low(&Semantic::Sar),
            Some(HelixLowOp::BinOp(BinOpKind::Sar))
        );
    }

    #[test]
    fn test_cmp_test_map_correctly() {
        assert_eq!(semantic_to_helix_low(&Semantic::Cmp), Some(HelixLowOp::Cmp));
        assert_eq!(
            semantic_to_helix_low(&Semantic::Test),
            Some(HelixLowOp::Test)
        );
    }

    #[test]
    fn test_control_flow_maps() {
        assert_eq!(
            semantic_to_helix_low(&Semantic::Call),
            Some(HelixLowOp::Call)
        );
        assert_eq!(semantic_to_helix_low(&Semantic::Ret), Some(HelixLowOp::Ret));
        assert_eq!(semantic_to_helix_low(&Semantic::Jmp), Some(HelixLowOp::Jmp));
        assert_eq!(
            semantic_to_helix_low(&Semantic::Jcc("JZ".into())),
            Some(HelixLowOp::Jcc("JZ".into()))
        );
        assert_eq!(
            semantic_to_helix_low(&Semantic::Jcc("JNZ".into())),
            Some(HelixLowOp::Jcc("JNZ".into()))
        );
    }

    #[test]
    fn test_nop_int3_maps() {
        assert_eq!(semantic_to_helix_low(&Semantic::Nop), Some(HelixLowOp::Nop));
        assert_eq!(
            semantic_to_helix_low(&Semantic::Int3),
            Some(HelixLowOp::Int3)
        );
    }

    #[test]
    fn test_data_movement_maps() {
        assert_eq!(
            semantic_to_helix_low(&Semantic::Mov),
            Some(HelixLowOp::RegWrite)
        );
        assert_eq!(
            semantic_to_helix_low(&Semantic::MovZx),
            Some(HelixLowOp::MovZx)
        );
        assert_eq!(
            semantic_to_helix_low(&Semantic::MovSx),
            Some(HelixLowOp::MovSx)
        );
        assert_eq!(semantic_to_helix_low(&Semantic::Lea), Some(HelixLowOp::Lea));
        assert_eq!(
            semantic_to_helix_low(&Semantic::Push),
            Some(HelixLowOp::Push)
        );
        assert_eq!(semantic_to_helix_low(&Semantic::Pop), Some(HelixLowOp::Pop));
    }

    #[test]
    fn test_unknown_returns_none() {
        assert_eq!(
            semantic_to_helix_low(&Semantic::Unknown("FOO".into())),
            None
        );
    }

    #[test]
    fn test_jcc_condition_mapping() {
        assert_eq!(jcc_condition(&Semantic::Jcc("JZ".into())), Some("z"));
        assert_eq!(jcc_condition(&Semantic::Jcc("JE".into())), Some("z"));
        assert_eq!(jcc_condition(&Semantic::Jcc("JNZ".into())), Some("nz"));
        assert_eq!(jcc_condition(&Semantic::Jcc("JNE".into())), Some("nz"));
        assert_eq!(jcc_condition(&Semantic::Jcc("JB".into())), Some("b"));
        assert_eq!(jcc_condition(&Semantic::Jcc("JL".into())), Some("l"));
        assert_eq!(jcc_condition(&Semantic::Jcc("JNLE".into())), Some("nle"));
        assert_eq!(jcc_condition(&Semantic::Add), None);
    }

    #[test]
    fn test_all_remill_test_files_no_unknown_semantics() {
        let test_files = [
            "tests/Remill-1/01-camera-init.ll",
            "tests/Remill-2/01-aim-assist-init.ll",
            "tests/Remill-3/01-swarm-serialization.ll",
            "tests/Remill-4/01-swarm-write.ll",
            "tests/Remill-5/01-name-writing.ll",
        ];

        const MARKER: &str = "@_ZN12_GLOBAL__N_1";

        let mut files_found = 0;
        for file_path in &test_files {
            let full_path = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
                .parent()
                .unwrap()
                .parent()
                .unwrap()
                .join(file_path);
            let content = match std::fs::read_to_string(&full_path) {
                Ok(c) => c,
                Err(_) => {
                    eprintln!("SKIP: test data not found at {:?}", full_path);
                    continue;
                }
            };
            files_found += 1;

            let mut seen = std::collections::HashSet::new();
            for line in content.lines() {
                let mut rest = line;
                while let Some(pos) = rest.find(MARKER) {
                    let start = pos + 1; // skip the '@'
                    let name_start = &rest[start..];
                    let end = name_start
                        .find(|c: char| c == '(' || c == ',' || c == ' ' || c == ';')
                        .unwrap_or(name_start.len());
                    let mangled = &name_start[..end];
                    if seen.insert(mangled.to_string()) {
                        let sem = decode_mangled_name(mangled);
                        assert!(
                            !matches!(sem, Semantic::Unknown(_)),
                            "Unknown semantic for mangled name '{}' in {}",
                            mangled,
                            file_path,
                        );
                    }
                    rest = &rest[pos + MARKER.len()..];
                }
            }
            if !seen.is_empty() {
                // Only assert if we found mangled names
            }
        }
        if files_found == 0 {
            eprintln!("SKIP: no Remill test files found (test data absent)");
        }
    }

    // ── Idiom pattern detection tests ────────────────────────────────────

    #[test]
    fn test_xor_self_detected() {
        let result = detect_self_operand_idiom(&Semantic::Xor, "RAX", "RAX");
        assert_eq!(result, Some(IdiomPattern::SelfXor));
    }

    #[test]
    fn test_xor_different_regs_no_idiom() {
        let result = detect_self_operand_idiom(&Semantic::Xor, "RAX", "RBX");
        assert_eq!(result, None);
    }

    #[test]
    fn test_test_self_detected() {
        let result = detect_self_operand_idiom(&Semantic::Test, "RCX", "RCX");
        assert_eq!(result, Some(IdiomPattern::TestSelfToCompareZero));
    }

    #[test]
    fn test_test_different_regs_no_idiom() {
        let result = detect_self_operand_idiom(&Semantic::Test, "RCX", "RDX");
        assert_eq!(result, None);
    }

    #[test]
    fn test_mov_self_detected() {
        let result = detect_self_operand_idiom(&Semantic::Mov, "RBP", "RBP");
        assert_eq!(result, Some(IdiomPattern::MovSelfEliminated));
    }

    #[test]
    fn test_mov_different_regs_no_idiom() {
        let result = detect_self_operand_idiom(&Semantic::Mov, "RSP", "RBP");
        assert_eq!(result, None);
    }

    #[test]
    fn test_add_self_no_idiom() {
        // ADD reg, reg is NOT an idiom — it doubles the value.
        let result = detect_self_operand_idiom(&Semantic::Add, "RAX", "RAX");
        assert_eq!(result, None);
    }

    #[test]
    fn test_apply_idiom_self_xor_keeps_op() {
        let op = HelixLowOp::BinOp(BinOpKind::Xor);
        let result = apply_idiom(&op, &IdiomPattern::SelfXor);
        assert!(result.is_some());
    }

    #[test]
    fn test_apply_idiom_test_self_converts_to_cmp() {
        let op = HelixLowOp::Test;
        let result = apply_idiom(&op, &IdiomPattern::TestSelfToCompareZero);
        assert_eq!(result, Some(HelixLowOp::Cmp));
    }

    #[test]
    fn test_apply_idiom_mov_self_eliminated() {
        let op = HelixLowOp::RegWrite;
        let result = apply_idiom(&op, &IdiomPattern::MovSelfEliminated);
        assert_eq!(result, None);
    }
}
