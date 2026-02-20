//! Remill IR parsing, semantic extraction, and High-Level IR.
//!
//! Consumes LLVM IR text from Remill's lifting pass and transforms it
//! into high-level decoded instructions ready for decompilation.

pub mod hir;
pub mod hir_builder;
pub mod hir_emitter;
pub mod parser;
pub mod remill;

/// A decoded semantic instruction from Remill IR.
#[derive(Debug, Clone)]
pub struct RemillInsn {
    /// Absolute address of the original machine instruction.
    pub pc: u64,
    /// Size in bytes of the original instruction.
    pub size: u32,
    /// Decoded semantic operation.
    pub semantic: remill::Semantic,
    /// Destination operand.
    pub dst: Option<Operand>,
    /// Source operands.
    pub srcs: Vec<Operand>,
    /// Comment (e.g., resolved call target name).
    pub comment: String,
}

/// An operand in a decoded instruction.
#[derive(Debug, Clone)]
pub enum Operand {
    /// Named register: "RAX", "RSP", "R9", etc.
    Reg(String),
    /// Immediate constant.
    Imm(i64),
    /// Memory reference: [base + disp].
    Mem {
        base: String,
        disp: i64,
        size_bits: u32,
    },
    /// Absolute address (resolved call/jump target).
    Addr(u64),
}

impl std::fmt::Display for Operand {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Operand::Reg(r) => write!(f, "{}", r.to_lowercase()),
            Operand::Imm(v) => {
                if *v >= 16 || *v <= -16 {
                    write!(f, "0x{:x}", v)
                } else {
                    write!(f, "{}", v)
                }
            }
            Operand::Mem { base, disp, .. } => {
                if *disp != 0 {
                    write!(f, "[{} + 0x{:x}]", base.to_lowercase(), disp)
                } else {
                    write!(f, "[{}]", base.to_lowercase())
                }
            }
            Operand::Addr(a) => write!(f, "sub_{:x}", a),
        }
    }
}

/// A parsed Remill-lifted IR containing decoded instructions.
#[derive(Debug)]
pub struct LiftedModule {
    /// Remill function name (e.g., "lifted_5368907311").
    pub name: String,
    /// Entry point address.
    pub entry_address: u64,
    /// Architecture string.
    pub arch: String,
    /// Source binary name.
    pub source_file: String,
    /// All decoded instructions.
    pub instructions: Vec<RemillInsn>,
    /// Indices where sub-functions begin (split at RET+INT3 boundaries).
    pub function_boundaries: Vec<usize>,
}
