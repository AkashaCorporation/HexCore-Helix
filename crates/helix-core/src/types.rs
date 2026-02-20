//! Fundamental types for binary analysis and decompilation.
//!
//! These types are architecture-agnostic representations used throughout
//! the Helix pipeline — from lifting through transformation to emission.

use bitflags::bitflags;
use std::fmt;

// ─── Address ───────────────────────────────────────────────────────────────────

/// A virtual or physical memory address.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct Address(pub u64);

impl Address {
    pub const ZERO: Address = Address(0);

    #[inline]
    pub fn offset(self, delta: i64) -> Self {
        Address((self.0 as i64 + delta) as u64)
    }
}

impl fmt::Display for Address {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "0x{:016x}", self.0)
    }
}

impl From<u64> for Address {
    fn from(v: u64) -> Self {
        Address(v)
    }
}

// ─── Architecture ──────────────────────────────────────────────────────────────

/// Target CPU architecture.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
#[repr(u8)]
pub enum ArchKind {
    X86 = 0,
    X86_64 = 1,
    Arm = 2,
    Aarch64 = 3,
    Mips = 4,
    Mips64 = 5,
    PowerPc = 6,
    PowerPc64 = 7,
    Sparc = 8,
    Sparc64 = 9,
    Riscv32 = 10,
    Riscv64 = 11,
}

impl fmt::Display for ArchKind {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let name = match self {
            ArchKind::X86 => "x86",
            ArchKind::X86_64 => "x86_64",
            ArchKind::Arm => "ARM",
            ArchKind::Aarch64 => "AArch64",
            ArchKind::Mips => "MIPS",
            ArchKind::Mips64 => "MIPS64",
            ArchKind::PowerPc => "PowerPC",
            ArchKind::PowerPc64 => "PowerPC64",
            ArchKind::Sparc => "SPARC",
            ArchKind::Sparc64 => "SPARC64",
            ArchKind::Riscv32 => "RISC-V 32",
            ArchKind::Riscv64 => "RISC-V 64",
        };
        write!(f, "{name}")
    }
}

// ─── Register ──────────────────────────────────────────────────────────────────

/// An architecture register. The `id` is architecture-specific.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct Register {
    /// Architecture-specific register ID (e.g., Capstone register enum value).
    pub id: u16,
    /// Human-readable register name (e.g., "rax", "x0").
    pub name: String,
    /// Register size in bits (e.g., 64, 32, 8).
    pub size_bits: u16,
}

// ─── Operand ───────────────────────────────────────────────────────────────────

/// An instruction operand.
#[derive(Debug, Clone, PartialEq)]
pub enum Operand {
    /// Register operand.
    Reg(Register),
    /// Immediate integer value.
    Imm(i64),
    /// Memory reference: base + index * scale + displacement.
    Mem {
        base: Option<Register>,
        index: Option<Register>,
        scale: u8,
        disp: i64,
        size_bits: u16,
    },
    /// Floating-point immediate.
    Fp(f64),
}

// ─── Instruction ───────────────────────────────────────────────────────────────

bitflags! {
    /// Instruction semantic flags.
    #[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
    pub struct InsnFlags: u32 {
        const CALL      = 0b0000_0001;
        const RET       = 0b0000_0010;
        const BRANCH    = 0b0000_0100;
        const COND      = 0b0000_1000;
        const INDIRECT  = 0b0001_0000;
        const SYSCALL   = 0b0010_0000;
        const NOP       = 0b0100_0000;
        const INTERRUPT = 0b1000_0000;
    }
}

/// A single disassembled instruction.
#[derive(Debug, Clone)]
pub struct Instruction {
    /// Address of this instruction.
    pub address: Address,
    /// Raw bytes of the instruction.
    pub bytes: Vec<u8>,
    /// Mnemonic (e.g., "mov", "add").
    pub mnemonic: String,
    /// Operand string as displayed by the disassembler.
    pub op_str: String,
    /// Parsed operands.
    pub operands: Vec<Operand>,
    /// Semantic flags.
    pub flags: InsnFlags,
}

// ─── Basic Block ───────────────────────────────────────────────────────────────

/// An edge in the control flow graph.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum CfgEdgeKind {
    /// Unconditional fall-through or jump.
    Unconditional,
    /// Conditional true branch.
    ConditionalTrue,
    /// Conditional false/fall-through branch.
    ConditionalFalse,
    /// Call edge (to a function entry).
    Call,
    /// Exception/interrupt edge.
    Exception,
}

/// A directed edge between basic blocks.
#[derive(Debug, Clone)]
pub struct CfgEdge {
    pub source: Address,
    pub target: Address,
    pub kind: CfgEdgeKind,
}

/// A basic block — a maximal sequence of straight-line instructions.
#[derive(Debug, Clone)]
pub struct BasicBlock {
    /// Start address of the block.
    pub start: Address,
    /// End address (exclusive — address of the byte after the last instruction).
    pub end: Address,
    /// Instructions in this block, in order.
    pub instructions: Vec<Instruction>,
    /// Outgoing edges from this block.
    pub successors: Vec<CfgEdge>,
}

// ─── Control Flow Graph ────────────────────────────────────────────────────────

/// A function's control flow graph.
#[derive(Debug, Clone)]
pub struct ControlFlowGraph {
    /// Function name (recovered or synthesized, e.g., "sub_401000").
    pub name: String,
    /// Function entry point address.
    pub entry: Address,
    /// Architecture of the code.
    pub arch: ArchKind,
    /// Ordered list of basic blocks (entry block first).
    pub blocks: Vec<BasicBlock>,
}

impl ControlFlowGraph {
    /// Returns the entry basic block, if present.
    pub fn entry_block(&self) -> Option<&BasicBlock> {
        self.blocks.first()
    }

    /// Returns the total number of instructions across all blocks.
    pub fn instruction_count(&self) -> usize {
        self.blocks.iter().map(|b| b.instructions.len()).sum()
    }
}
