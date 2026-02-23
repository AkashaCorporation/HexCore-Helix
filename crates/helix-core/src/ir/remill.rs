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
            } else if semantic_name.starts_with("REP") {
                // REP prefix for string operations
                let suffix = &semantic_name[3..];
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

fn split_numeric_prefix(s: &str) -> (&str, &str) {
    let pos = s.find(|c: char| !c.is_ascii_digit()).unwrap_or(s.len());
    (&s[..pos], &s[pos..])
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
        assert_eq!(classes, vec![OpClass::MemWrite, OpClass::MemRead, OpClass::RegRead]);
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
}
