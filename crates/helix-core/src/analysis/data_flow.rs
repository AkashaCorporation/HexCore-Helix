//! Data flow analysis for the decompilation pipeline.
//!
//! Provides liveness analysis, reaching definitions, and def-use chains
//! to support register elimination and dead code removal.

use std::collections::HashSet;

use crate::ir::{Operand, RemillInsn};
use crate::ir::remill::Semantic;

// ─── Register Liveness ──────────────────────────────────────────────────────

/// Result of register liveness analysis.
#[derive(Debug, Clone, Default)]
pub struct LivenessInfo {
    /// For each instruction index: set of registers live *after* the instruction.
    pub live_out: Vec<HashSet<String>>,
    /// For each instruction index: set of registers live *before* the instruction.
    pub live_in: Vec<HashSet<String>>,
}

/// Compute register liveness for a sequence of instructions.
///
/// Uses a backward dataflow analysis:
/// - `live_in[i]  = (live_out[i] - def[i]) ∪ use[i]`
/// - `live_out[i] = live_in[i+1]`
pub fn compute_liveness(insns: &[RemillInsn]) -> LivenessInfo {
    let n = insns.len();
    let mut live_out: Vec<HashSet<String>> = vec![HashSet::new(); n];
    let mut live_in: Vec<HashSet<String>> = vec![HashSet::new(); n];

    // Iterate backwards until stable
    let mut changed = true;
    let mut iterations = 0;
    const MAX_ITER: usize = 32;

    while changed && iterations < MAX_ITER {
        changed = false;
        iterations += 1;

        for i in (0..n).rev() {
            // live_out[i] = live_in[i+1] (for linear flow — ignoring branches for now)
            let new_out = if i + 1 < n {
                live_in[i + 1].clone()
            } else {
                HashSet::new()
            };

            // live_in[i] = (live_out[i] - def[i]) ∪ use[i]
            let (defs, uses) = insn_def_use(&insns[i]);
            let mut new_in: HashSet<String> = new_out
                .iter()
                .filter(|r| !defs.contains(r.as_str()))
                .cloned()
                .collect();
            new_in.extend(uses);

            if new_in != live_in[i] || new_out != live_out[i] {
                changed = true;
            }

            live_out[i] = new_out;
            live_in[i] = new_in;
        }
    }

    LivenessInfo { live_out, live_in }
}

/// Extract the set of registers defined and used by an instruction.
fn insn_def_use(insn: &RemillInsn) -> (HashSet<&str>, HashSet<String>) {
    let mut defs: HashSet<&str> = HashSet::new();
    let mut uses: HashSet<String> = HashSet::new();

    // Destination operand → definition
    if let Some(dst) = &insn.dst {
        match dst {
            Operand::Reg(r) => {
                defs.insert(r.as_str());
            }
            Operand::Mem { base, .. } => {
                // Memory destination uses the base register
                uses.insert(base.clone());
            }
            _ => {}
        }
    }

    // Source operands → uses
    for src in &insn.srcs {
        match src {
            Operand::Reg(r) => {
                uses.insert(r.clone());
            }
            Operand::Mem { base, .. } => {
                uses.insert(base.clone());
            }
            _ => {}
        }
    }

    // Special cases
    match &insn.semantic {
        Semantic::Call => {
            // Calls clobber volatile registers (Win64 ABI)
            defs.insert("RAX");
            defs.insert("RCX");
            defs.insert("RDX");
            defs.insert("R8");
            defs.insert("R9");
            defs.insert("R10");
            defs.insert("R11");
        }
        Semantic::Ret => {
            uses.insert("RAX".into()); // return value
        }
        Semantic::RepMovs => {
            // REP MOVSB/Q uses RSI, RDI, RCX and modifies all three
            uses.insert("RSI".into());
            uses.insert("RDI".into());
            uses.insert("RCX".into());
            defs.insert("RSI");
            defs.insert("RDI");
            defs.insert("RCX");
        }
        Semantic::RepStos => {
            // REP STOSB/Q uses RAX, RDI, RCX and modifies RDI, RCX
            uses.insert("RAX".into());
            uses.insert("RDI".into());
            uses.insert("RCX".into());
            defs.insert("RDI");
            defs.insert("RCX");
        }
        Semantic::Div | Semantic::IDiv => {
            // DIV/IDIV use RDX:RAX and produce quotient in RAX, remainder in RDX
            uses.insert("RAX".into());
            uses.insert("RDX".into());
            defs.insert("RAX");
            defs.insert("RDX");
        }
        Semantic::Mul | Semantic::IMul => {
            // MUL/IMUL produce 128-bit result in RDX:RAX
            uses.insert("RAX".into());
            defs.insert("RAX");
            defs.insert("RDX");
        }
        Semantic::Cdqe => {
            // CDQE: RAX = sign-extend(EAX)
            uses.insert("RAX".into());
            defs.insert("RAX");
        }
        _ => {}
    }

    (defs, uses)
}

// ─── Reaching Definitions ───────────────────────────────────────────────────

/// A definition: instruction index and register name.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct Definition {
    pub insn_index: usize,
    pub register: String,
}

/// For each instruction, the set of definitions that reach it.
#[derive(Debug, Clone, Default)]
pub struct ReachingDefs {
    /// For each instruction index: definitions reaching the instruction.
    pub reaching: Vec<HashSet<Definition>>,
}

/// Compute reaching definitions for a sequence of instructions.
pub fn compute_reaching_definitions(insns: &[RemillInsn]) -> ReachingDefs {
    let n = insns.len();
    let mut reaching: Vec<HashSet<Definition>> = vec![HashSet::new(); n];

    // Forward pass — for linear flow within a basic block
    for i in 0..n {
        // Start with reaching defs from previous instruction
        let mut current = if i > 0 {
            reaching[i - 1].clone()
        } else {
            HashSet::new()
        };

        // Kill definitions of the same register
        if let Some(Operand::Reg(def_reg)) = &insns[i].dst {
            current.retain(|d| d.register != *def_reg);
            // Add new definition
            current.insert(Definition {
                insn_index: i,
                register: def_reg.clone(),
            });
        }

        reaching[i] = current;
    }

    ReachingDefs { reaching }
}

// ─── Dead Code Detection ────────────────────────────────────────────────────

/// Identify instructions whose results are never used.
///
/// An instruction is considered dead if:
/// 1. It defines a register that is not live after the instruction
/// 2. It has no side effects (not a call, store, branch, or return)
pub fn find_dead_instructions(insns: &[RemillInsn]) -> Vec<bool> {
    let liveness = compute_liveness(insns);
    let mut dead = vec![false; insns.len()];

    for (i, insn) in insns.iter().enumerate() {
        // Instructions with side effects are never dead
        if has_side_effects(insn) {
            continue;
        }

        // Check if the defined register is live after this instruction
        if let Some(Operand::Reg(def_reg)) = &insn.dst {
            if def_reg == "RSP" || def_reg == "RBP" {
                // Stack/frame pointer modifications are not dead
                continue;
            }
            if !liveness.live_out[i].contains(def_reg) {
                dead[i] = true;
            }
        }
    }

    dead
}

/// Check if an instruction has side effects beyond defining a register.
fn has_side_effects(insn: &RemillInsn) -> bool {
    matches!(
        insn.semantic,
        Semantic::Call
            | Semantic::Ret
            | Semantic::Jmp
            | Semantic::Jcc(_)
            | Semantic::Push
            | Semantic::Pop
            | Semantic::Int3
            | Semantic::RepMovs
            | Semantic::RepStos
            | Semantic::XAdd
    ) || matches!(&insn.dst, Some(Operand::Mem { .. }))
        || matches!(&insn.dst, Some(Operand::Addr(_)))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ir::RemillInsn;

    fn mk_insn(
        pc: u64,
        semantic: Semantic,
        dst: Option<Operand>,
        srcs: Vec<Operand>,
    ) -> RemillInsn {
        RemillInsn {
            pc,
            size: 1,
            semantic,
            dst,
            srcs,
            comment: String::new(),
        }
    }

    #[test]
    fn liveness_basic() {
        let insns = vec![
            mk_insn(
                0x100,
                Semantic::Mov,
                Some(Operand::Reg("RAX".into())),
                vec![Operand::Imm(42)],
            ),
            mk_insn(
                0x102,
                Semantic::Mov,
                Some(Operand::Reg("RBX".into())),
                vec![Operand::Reg("RAX".into())],
            ),
            mk_insn(0x104, Semantic::Ret, None, vec![]),
        ];

        let liveness = compute_liveness(&insns);

        // RAX should be live after insn 0 (used by insn 1)
        assert!(liveness.live_out[0].contains("RAX"));
        // RAX should also be live in insn 2 (RET uses RAX)
        assert!(liveness.live_in[2].contains("RAX"));
    }

    #[test]
    fn reaching_defs_basic() {
        let insns = vec![
            mk_insn(
                0x100,
                Semantic::Mov,
                Some(Operand::Reg("RAX".into())),
                vec![Operand::Imm(1)],
            ),
            mk_insn(
                0x102,
                Semantic::Mov,
                Some(Operand::Reg("RBX".into())),
                vec![Operand::Imm(2)],
            ),
            mk_insn(
                0x104,
                Semantic::Add,
                Some(Operand::Reg("RAX".into())),
                vec![Operand::Reg("RAX".into()), Operand::Reg("RBX".into())],
            ),
        ];

        let defs = compute_reaching_definitions(&insns);

        // At insn 2: RAX from insn 0 should be killed, new RAX from insn 2 added
        let reaching_at_2 = &defs.reaching[2];
        assert!(reaching_at_2.contains(&Definition {
            insn_index: 2,
            register: "RAX".into(),
        }));
        assert!(reaching_at_2.contains(&Definition {
            insn_index: 1,
            register: "RBX".into(),
        }));
        // Old RAX def should be killed
        assert!(!reaching_at_2.contains(&Definition {
            insn_index: 0,
            register: "RAX".into(),
        }));
    }

    #[test]
    fn dead_code_detection() {
        let insns = vec![
            mk_insn(
                0x100,
                Semantic::Mov,
                Some(Operand::Reg("RAX".into())),
                vec![Operand::Imm(42)],
            ),
            // RAX is overwritten immediately — first MOV is dead
            mk_insn(
                0x102,
                Semantic::Mov,
                Some(Operand::Reg("RAX".into())),
                vec![Operand::Imm(99)],
            ),
            mk_insn(0x104, Semantic::Ret, None, vec![]),
        ];

        let dead = find_dead_instructions(&insns);
        assert!(dead[0], "First MOV RAX should be dead (overwritten)");
        assert!(!dead[1], "Second MOV RAX should be alive (used by RET)");
    }
}
