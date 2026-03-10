//! Data flow analysis for the decompilation pipeline.
//!
//! Provides liveness analysis, reaching definitions, and def-use chains
//! to support register elimination and dead code removal.

use std::collections::HashSet;

use crate::ir::{Operand, RemillInsn};
use crate::ir::remill::Semantic;
use crate::ir::hir::{HirExpr, HirFunction, HirStmt, HirVarId};

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

// ─── Flag Liveness Analysis ─────────────────────────────────────────────────

/// Tracks which CPU flags produced by an operation are actually consumed
/// by downstream conditional operations (jcc, cmov).
///
/// Equivalent to the C++ `FlagLiveness` struct in `EliminateDeadCode.cpp`.
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct FlagLiveness {
    pub carry_live: bool,
    pub zero_live: bool,
    pub sign_live: bool,
    pub overflow_live: bool,
}

impl FlagLiveness {
    /// Returns true if any flag is live.
    pub fn any_live(&self) -> bool {
        self.carry_live || self.zero_live || self.sign_live || self.overflow_live
    }

    /// Mark flags as live based on a Jcc condition code.
    ///
    /// x86 condition codes and the flags they read:
    ///   z/nz (ZF), b/nb (CF), be/nbe (CF|ZF), l/nl (SF^OF),
    ///   le/nle (ZF|(SF^OF)), s/ns (SF), o/no (OF)
    pub fn mark_from_jcc(&mut self, condition: &str) {
        self.mark_flags_for_condition(condition);
    }

    /// Mark flags as live based on a CMov condition code.
    pub fn mark_from_cmov(&mut self, condition: &str) {
        self.mark_flags_for_condition(condition);
    }

    fn mark_flags_for_condition(&mut self, cond: &str) {
        let c = cond.to_lowercase();
        match c.as_str() {
            "z" | "e" | "nz" | "ne" => {
                self.zero_live = true;
            }
            "b" | "c" | "nb" | "nc" | "nae" | "ae" => {
                self.carry_live = true;
            }
            "be" | "na" | "nbe" | "a" => {
                self.carry_live = true;
                self.zero_live = true;
            }
            "l" | "nge" | "nl" | "ge" => {
                self.sign_live = true;
                self.overflow_live = true;
            }
            "le" | "ng" | "nle" | "g" => {
                self.zero_live = true;
                self.sign_live = true;
                self.overflow_live = true;
            }
            "s" | "ns" => {
                self.sign_live = true;
            }
            "o" | "no" => {
                self.overflow_live = true;
            }
            _ => {
                // Unknown condition — conservatively mark all flags as live.
                self.carry_live = true;
                self.zero_live = true;
                self.sign_live = true;
                self.overflow_live = true;
            }
        }
    }
}

/// Determine which flags are consumed by downstream instructions for a
/// flag-producing instruction at the given index.
///
/// Scans forward from the instruction to find jcc/cmov consumers and
/// builds a FlagLiveness indicating which flags are actually needed.
///
/// If no consumers are found, all flags are dead.
/// If the flag flows to an unknown consumer, conservatively marks all live.
pub fn compute_flag_liveness_for_insn(insns: &[RemillInsn], idx: usize) -> FlagLiveness {
    let insn = &insns[idx];

    // Only flag-producing instructions are relevant.
    let produces_flags = matches!(
        insn.semantic,
        Semantic::Add
            | Semantic::Sub
            | Semantic::Xor
            | Semantic::And
            | Semantic::Or
            | Semantic::Shl
            | Semantic::Shr
            | Semantic::Cmp
            | Semantic::Test
    );

    if !produces_flags {
        return FlagLiveness::default();
    }

    let mut liveness = FlagLiveness::default();

    // Scan forward to find flag consumers.
    for consumer in insns.iter().skip(idx + 1) {
        match &consumer.semantic {
            Semantic::Jcc(cond) => {
                liveness.mark_from_jcc(cond);
                break; // Jcc is a terminator; stop scanning.
            }
            Semantic::CMov(cond) => {
                liveness.mark_from_cmov(cond);
                // CMov is not a terminator; continue scanning in case
                // there are more consumers before the next flag producer.
            }
            // If we hit another flag-producing instruction, stop — it
            // overwrites the flags.
            Semantic::Add
            | Semantic::Sub
            | Semantic::Xor
            | Semantic::And
            | Semantic::Or
            | Semantic::Shl
            | Semantic::Shr
            | Semantic::Cmp
            | Semantic::Test => {
                break;
            }
            _ => {}
        }
    }

    liveness
}

// ─── HIR Variable Liveness ──────────────────────────────────────────────────

/// Result of HIR variable liveness analysis.
///
/// Tracks which `HirVarId`s are live (consumed by an observable operation)
/// and which are dead (never consumed).
#[derive(Debug, Clone, Default)]
pub struct HirVarLiveness {
    /// Set of variable IDs that are live (consumed by branch, call, return,
    /// or memory write — directly or transitively).
    pub live: HashSet<HirVarId>,
    /// Set of variable IDs that are dead (never consumed by any live op).
    pub dead: HashSet<HirVarId>,
}

/// Compute HIR variable liveness for a function.
///
/// A variable is "live" if any of its references appear in:
///   - A `Return` statement (observable output)
///   - A `Call` expression (observable side effect)
///   - An `If`/`While`/`DoWhile`/`For`/`Switch` condition (affects control flow)
///   - An `Assign` where the LHS variable is itself live (transitive liveness)
///
/// A variable is "dead" if none of its references feed into any live operation.
///
/// The analysis iterates to a fixed point because transitive liveness through
/// assignment chains may require multiple passes.
pub fn compute_hir_var_liveness(func: &HirFunction) -> HirVarLiveness {
    // Collect all declared variable IDs.
    let all_var_ids: HashSet<HirVarId> = func
        .params
        .iter()
        .chain(func.locals.iter())
        .map(|v| v.id)
        .collect();

    // Build a map: for each variable, which other variables does it depend on?
    // If `x = expr_using(y)`, then x depends on y.
    // Also track which variables are directly consumed by live operations.
    let mut directly_live: HashSet<HirVarId> = HashSet::new();
    let mut depends_on: std::collections::HashMap<HirVarId, HashSet<HirVarId>> =
        std::collections::HashMap::new();

    // Walk the function body to find live uses and dependencies.
    collect_liveness_from_stmts(&func.body, &mut directly_live, &mut depends_on);

    // Propagate liveness transitively: if x is live and y depends on x
    // (i.e., x = f(y)), then y is also live.
    //
    // We need the reverse: if x is live and there's an assignment `x = f(y)`,
    // then y is live.  Our `depends_on` map stores x → {y}, meaning x's value
    // comes from y.  So if x is live, all vars in depends_on[x] are live.
    let mut live = directly_live.clone();
    let mut changed = true;
    let mut iterations = 0;
    const MAX_ITER: usize = 32;

    while changed && iterations < MAX_ITER {
        changed = false;
        iterations += 1;

        let current_live: Vec<HirVarId> = live.iter().copied().collect();
        for var_id in current_live {
            if let Some(deps) = depends_on.get(&var_id) {
                for dep in deps {
                    if live.insert(*dep) {
                        changed = true;
                    }
                }
            }
        }
    }

    // Dead = all declared vars minus live vars.
    let dead: HashSet<HirVarId> = all_var_ids.difference(&live).copied().collect();

    HirVarLiveness { live, dead }
}

/// Collect directly-live variable references and assignment dependencies
/// from a list of statements.
fn collect_liveness_from_stmts(
    stmts: &[HirStmt],
    directly_live: &mut HashSet<HirVarId>,
    depends_on: &mut std::collections::HashMap<HirVarId, HashSet<HirVarId>>,
) {
    for stmt in stmts {
        match stmt {
            HirStmt::Return { value, .. } => {
                // Return value is directly live.
                if let Some(expr) = value {
                    collect_var_refs(expr, directly_live);
                }
            }
            HirStmt::Expr { expr, .. } => {
                // Expression statements (e.g., void calls) — the expression
                // is live if it's a call.
                if matches!(expr, HirExpr::Call { .. }) {
                    collect_var_refs(expr, directly_live);
                }
            }
            HirStmt::Assign { lhs, rhs, .. } => {
                // Record dependency: LHS var depends on RHS vars.
                if let HirExpr::Var { id: lhs_id, .. } = lhs {
                    let rhs_vars = extract_var_refs(rhs);
                    depends_on
                        .entry(*lhs_id)
                        .or_default()
                        .extend(rhs_vars);
                }
                // If the RHS is a call, the LHS is directly live (side effect).
                if matches!(rhs, HirExpr::Call { .. }) {
                    collect_var_refs(rhs, directly_live);
                    if let HirExpr::Var { id, .. } = lhs {
                        directly_live.insert(*id);
                    }
                }
            }
            HirStmt::If {
                cond,
                then_body,
                else_body,
                ..
            } => {
                // Condition is directly live (affects control flow).
                collect_var_refs(cond, directly_live);
                collect_liveness_from_stmts(then_body, directly_live, depends_on);
                if let Some(else_stmts) = else_body {
                    collect_liveness_from_stmts(else_stmts, directly_live, depends_on);
                }
            }
            HirStmt::While { cond, body, .. } => {
                collect_var_refs(cond, directly_live);
                collect_liveness_from_stmts(body, directly_live, depends_on);
            }
            HirStmt::DoWhile { body, cond, .. } => {
                collect_var_refs(cond, directly_live);
                collect_liveness_from_stmts(body, directly_live, depends_on);
            }
            HirStmt::For {
                init,
                cond,
                step,
                body,
                ..
            } => {
                if let Some(init_stmt) = init {
                    collect_liveness_from_stmts(
                        &[*init_stmt.clone()],
                        directly_live,
                        depends_on,
                    );
                }
                if let Some(cond_expr) = cond {
                    collect_var_refs(cond_expr, directly_live);
                }
                if let Some(step_stmt) = step {
                    collect_liveness_from_stmts(
                        &[*step_stmt.clone()],
                        directly_live,
                        depends_on,
                    );
                }
                collect_liveness_from_stmts(body, directly_live, depends_on);
            }
            HirStmt::Switch {
                expr,
                cases,
                default,
                ..
            } => {
                collect_var_refs(expr, directly_live);
                for case in cases {
                    collect_liveness_from_stmts(
                        &case.body,
                        directly_live,
                        depends_on,
                    );
                }
                if let Some(default_stmts) = default {
                    collect_liveness_from_stmts(
                        default_stmts,
                        directly_live,
                        depends_on,
                    );
                }
            }
            HirStmt::VarDecl { .. }
            | HirStmt::Break { .. }
            | HirStmt::Continue { .. }
            | HirStmt::Goto { .. }
            | HirStmt::Label { .. }
            | HirStmt::Asm { .. }
            | HirStmt::Comment { .. } => {}
        }
    }
}

/// Collect all HirVarId references from an expression into the live set.
fn collect_var_refs(expr: &HirExpr, live: &mut HashSet<HirVarId>) {
    match expr {
        HirExpr::Var { id, .. } => {
            live.insert(*id);
        }
        HirExpr::Binary { lhs, rhs, .. } => {
            collect_var_refs(lhs, live);
            collect_var_refs(rhs, live);
        }
        HirExpr::Unary { operand, .. } => {
            collect_var_refs(operand, live);
        }
        HirExpr::Cast { expr, .. } => {
            collect_var_refs(expr, live);
        }
        HirExpr::Call { target, args, .. } => {
            collect_var_refs(target, live);
            for arg in args {
                collect_var_refs(arg, live);
            }
        }
        HirExpr::Subscript { base, index, .. } => {
            collect_var_refs(base, live);
            collect_var_refs(index, live);
        }
        HirExpr::FieldAccess { expr, .. } | HirExpr::DerefFieldAccess { expr, .. } => {
            collect_var_refs(expr, live);
        }
        HirExpr::Ternary {
            cond,
            then_expr,
            else_expr,
            ..
        } => {
            collect_var_refs(cond, live);
            collect_var_refs(then_expr, live);
            collect_var_refs(else_expr, live);
        }
        HirExpr::IntLit { .. }
        | HirExpr::FloatLit { .. }
        | HirExpr::StringLit { .. }
        | HirExpr::AddrLit { .. }
        | HirExpr::Unknown { .. } => {}
    }
}

/// Extract all HirVarId references from an expression (returns a set).
fn extract_var_refs(expr: &HirExpr) -> HashSet<HirVarId> {
    let mut refs = HashSet::new();
    collect_var_refs(expr, &mut refs);
    refs
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

    // ─── HIR Variable Liveness Tests ────────────────────────────────────

    use crate::ir::hir::{
        HirExpr, HirFunction, HirStmt, HirStorage, HirType, HirVar, HirVarId, Span,
    };

    fn mk_func(
        params: Vec<HirVar>,
        locals: Vec<HirVar>,
        body: Vec<HirStmt>,
    ) -> HirFunction {
        HirFunction {
            name: "test_func".into(),
            address: 0x1000,
            return_type: HirType::i64(),
            params,
            locals,
            body,
            calling_convention: None,
            is_variadic: false,
            span: Span::single(0x1000),
        }
    }

    fn mk_var(id: u32, name: &str) -> HirVar {
        HirVar {
            id: HirVarId(id),
            name: name.into(),
            ty: HirType::i64(),
            storage: HirStorage::Register,
            span: Span::single(0),
        }
    }

    #[test]
    fn hir_var_liveness_dead_variable() {
        // Variable 0 is assigned but never used in return/call/branch.
        let func = mk_func(
            vec![],
            vec![mk_var(0, "dead_var"), mk_var(1, "live_var")],
            vec![
                HirStmt::Assign {
                    lhs: HirExpr::Var {
                        id: HirVarId(0),
                        span: Span::single(0x100),
                    },
                    rhs: HirExpr::IntLit {
                        value: 42,
                        ty: HirType::i64(),
                        span: Span::single(0x100),
                    },
                    span: Span::single(0x100),
                },
                HirStmt::Return {
                    value: Some(HirExpr::Var {
                        id: HirVarId(1),
                        span: Span::single(0x104),
                    }),
                    span: Span::single(0x104),
                },
            ],
        );

        let liveness = compute_hir_var_liveness(&func);
        assert!(liveness.dead.contains(&HirVarId(0)), "dead_var should be dead");
        assert!(liveness.live.contains(&HirVarId(1)), "live_var should be live");
    }

    #[test]
    fn hir_var_liveness_transitive_chain() {
        // x = 42; y = x; return y;
        // Both x and y should be live (y is directly live via return,
        // x is transitively live because y depends on x).
        let func = mk_func(
            vec![],
            vec![mk_var(0, "x"), mk_var(1, "y")],
            vec![
                HirStmt::Assign {
                    lhs: HirExpr::Var {
                        id: HirVarId(0),
                        span: Span::single(0x100),
                    },
                    rhs: HirExpr::IntLit {
                        value: 42,
                        ty: HirType::i64(),
                        span: Span::single(0x100),
                    },
                    span: Span::single(0x100),
                },
                HirStmt::Assign {
                    lhs: HirExpr::Var {
                        id: HirVarId(1),
                        span: Span::single(0x104),
                    },
                    rhs: HirExpr::Var {
                        id: HirVarId(0),
                        span: Span::single(0x104),
                    },
                    span: Span::single(0x104),
                },
                HirStmt::Return {
                    value: Some(HirExpr::Var {
                        id: HirVarId(1),
                        span: Span::single(0x108),
                    }),
                    span: Span::single(0x108),
                },
            ],
        );

        let liveness = compute_hir_var_liveness(&func);
        assert!(liveness.live.contains(&HirVarId(0)), "x should be live (transitive)");
        assert!(liveness.live.contains(&HirVarId(1)), "y should be live (returned)");
    }

    #[test]
    fn hir_var_liveness_dead_chain() {
        // x = 42; y = x; (neither returned nor used in branch/call)
        // Both should be dead.
        let func = mk_func(
            vec![],
            vec![mk_var(0, "x"), mk_var(1, "y")],
            vec![
                HirStmt::Assign {
                    lhs: HirExpr::Var {
                        id: HirVarId(0),
                        span: Span::single(0x100),
                    },
                    rhs: HirExpr::IntLit {
                        value: 42,
                        ty: HirType::i64(),
                        span: Span::single(0x100),
                    },
                    span: Span::single(0x100),
                },
                HirStmt::Assign {
                    lhs: HirExpr::Var {
                        id: HirVarId(1),
                        span: Span::single(0x104),
                    },
                    rhs: HirExpr::Var {
                        id: HirVarId(0),
                        span: Span::single(0x104),
                    },
                    span: Span::single(0x104),
                },
                HirStmt::Return {
                    value: None,
                    span: Span::single(0x108),
                },
            ],
        );

        let liveness = compute_hir_var_liveness(&func);
        assert!(liveness.dead.contains(&HirVarId(0)), "x should be dead");
        assert!(liveness.dead.contains(&HirVarId(1)), "y should be dead");
    }

    #[test]
    fn hir_var_liveness_branch_condition() {
        // x = 42; if (x != 0) { ... }
        // x should be live because it's used in a branch condition.
        let func = mk_func(
            vec![],
            vec![mk_var(0, "x")],
            vec![
                HirStmt::Assign {
                    lhs: HirExpr::Var {
                        id: HirVarId(0),
                        span: Span::single(0x100),
                    },
                    rhs: HirExpr::IntLit {
                        value: 42,
                        ty: HirType::i64(),
                        span: Span::single(0x100),
                    },
                    span: Span::single(0x100),
                },
                HirStmt::If {
                    cond: HirExpr::Binary {
                        op: crate::ir::hir::HirBinOp::Ne,
                        lhs: Box::new(HirExpr::Var {
                            id: HirVarId(0),
                            span: Span::single(0x104),
                        }),
                        rhs: Box::new(HirExpr::IntLit {
                            value: 0,
                            ty: HirType::i64(),
                            span: Span::single(0x104),
                        }),
                        ty: HirType::Unknown,
                        span: Span::single(0x104),
                    },
                    then_body: vec![],
                    else_body: None,
                    span: Span::single(0x104),
                },
            ],
        );

        let liveness = compute_hir_var_liveness(&func);
        assert!(
            liveness.live.contains(&HirVarId(0)),
            "x should be live (used in branch condition)"
        );
    }

    #[test]
    fn hir_var_liveness_call_arg() {
        // x = 42; foo(x);
        // x should be live because it's used as a call argument.
        let func = mk_func(
            vec![],
            vec![mk_var(0, "x")],
            vec![
                HirStmt::Assign {
                    lhs: HirExpr::Var {
                        id: HirVarId(0),
                        span: Span::single(0x100),
                    },
                    rhs: HirExpr::IntLit {
                        value: 42,
                        ty: HirType::i64(),
                        span: Span::single(0x100),
                    },
                    span: Span::single(0x100),
                },
                HirStmt::Expr {
                    expr: HirExpr::Call {
                        target: Box::new(HirExpr::AddrLit {
                            address: 0x2000,
                            span: Span::single(0x104),
                        }),
                        args: vec![HirExpr::Var {
                            id: HirVarId(0),
                            span: Span::single(0x104),
                        }],
                        ret_ty: HirType::Void,
                        span: Span::single(0x104),
                    },
                    span: Span::single(0x104),
                },
            ],
        );

        let liveness = compute_hir_var_liveness(&func);
        assert!(
            liveness.live.contains(&HirVarId(0)),
            "x should be live (used as call argument)"
        );
    }

    #[test]
    fn hir_var_liveness_no_vars() {
        // Empty function — no variables.
        let func = mk_func(vec![], vec![], vec![]);
        let liveness = compute_hir_var_liveness(&func);
        assert!(liveness.live.is_empty());
        assert!(liveness.dead.is_empty());
    }
}
