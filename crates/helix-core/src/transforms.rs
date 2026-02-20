//! High-level transform passes for register elimination, call folding,
//! and control flow recovery.

use std::collections::{HashMap, HashSet};

use crate::ir::remill::Semantic;
use crate::ir::{Operand, RemillInsn};
use crate::signatures::{default_signature_db, SignatureDb};

const WIN64_ARG_REGS: [&str; 4] = ["RCX", "RDX", "R8", "R9"];

// ─── High-Level IR ──────────────────────────────────────────────────────────

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum HLExpr {
    Var(String),
    Int(i64),
    AddrOf(String),
    Raw(String),
}

impl std::fmt::Display for HLExpr {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            HLExpr::Var(n) => write!(f, "{}", n),
            HLExpr::Int(v) if *v >= 16 || *v <= -16 => write!(f, "0x{:x}", v),
            HLExpr::Int(v) => write!(f, "{}", v),
            HLExpr::AddrOf(n) => write!(f, "&{}", n),
            HLExpr::Raw(s) => write!(f, "{}", s),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum HLStmt {
    /// `type name = sub_xxx(args);` or `sub_xxx(args);`
    Call {
        result: Option<(String, String)>,
        target: CallTarget,
        args: Vec<HLExpr>,
    },
    /// `var = expr;`
    Assign { dst: String, value: HLExpr },
    /// `ptr->field = expr;`  or `*ptr = expr;`
    FieldStore { target: String, value: HLExpr },
    /// `if (condition) {`
    IfBegin { condition: String },
    /// `} else {`
    Else,
    /// `}`
    IfEnd,
    /// `while (condition) {`
    WhileBegin { condition: String },
    /// `} // end while`
    WhileEnd,
    /// `switch (expr) {`
    SwitchBegin { expr: String },
    /// `case X:`
    SwitchCase { values: Vec<i64> },
    /// `default:`
    SwitchDefault,
    /// `}`
    SwitchEnd,
    /// `break;`
    Break,
    /// `return;`
    Return,
    /// `// text`
    Comment(String),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum CallTarget {
    Direct {
        address: u64,
        name: String,
        return_type: Option<String>,
    },
    Indirect(String), // via register value
}

impl std::fmt::Display for CallTarget {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            CallTarget::Direct { name, .. } => write!(f, "{}", name),
            CallTarget::Indirect(r) => write!(f, "({})", r),
        }
    }
}

pub struct LocalInfo {
    pub name: String,
    pub offset: i64,
}

// ─── Register State ─────────────────────────────────────────────────────────

#[derive(Debug, Clone)]
enum RegVal {
    Constant(i64),
    CallResult(String),
    AddrOfLocal(String),
    Unknown,
}

// ─── Switch Recovery ────────────────────────────────────────────────────────

#[derive(Debug, Clone)]
struct SwitchPattern {
    selector: String,
    open_at_idx: usize,
    end_pc: u64,
    case_values_by_pc: HashMap<u64, Vec<i64>>,
    default_pc: u64,
    dispatch_indices: HashSet<usize>,
}

// ─── Control Flow Scope ─────────────────────────────────────────────────────

#[derive(Debug, Clone)]
enum Scope {
    Switch { end_pc: u64, sid: usize },
    If { end_pc: u64 },
    IfElse { else_start_pc: u64, end_pc: u64, in_else: bool },
    While { end_pc: u64 },
}

struct IfInfo {
    condition: String,
    target_pc: u64,
    else_end_pc: Option<u64>,
}

struct WhileInfo {
    condition: String,
    backward_jcc_idx: usize,
}

// ─── Main Transform ─────────────────────────────────────────────────────────

pub fn transform(insns: &[RemillInsn], locals: &[LocalInfo]) -> Vec<HLStmt> {
    transform_with_signatures(insns, locals, default_signature_db())
}

pub fn transform_with_signatures(
    insns: &[RemillInsn],
    locals: &[LocalInfo],
    signature_db: &SignatureDb,
) -> Vec<HLStmt> {
    let consumed = mark_consumed(insns);
    let used = mark_used_results(insns);

    let mut pc_to_idx: HashMap<u64, usize> = HashMap::new();
    for (i, insn) in insns.iter().enumerate() {
        pc_to_idx.entry(insn.pc).or_insert(i);
    }

    // Recover switch/case from compare+jump dispatch chains.
    let switch_patterns = detect_switch_patterns(insns, &pc_to_idx);
    let mut switch_open_at: HashMap<usize, Vec<usize>> = HashMap::new();
    let mut switch_dispatch_indices: HashSet<usize> = HashSet::new();
    for (sid, pattern) in switch_patterns.iter().enumerate() {
        switch_open_at
            .entry(pattern.open_at_idx)
            .or_default()
            .push(sid);
        switch_dispatch_indices.extend(pattern.dispatch_indices.iter().copied());
    }

    // Build control flow maps: forward branches → if, backward → while.
    let mut if_open_at: HashMap<usize, Vec<IfInfo>> = HashMap::new();
    let mut while_open_at: HashMap<u64, Vec<WhileInfo>> = HashMap::new();

    for (i, insn) in insns.iter().enumerate() {
        if switch_dispatch_indices.contains(&i) {
            continue;
        }

        let Some((_, target_pc)) = jcc_info(insn) else {
            continue;
        };

        if target_pc > insn.pc {
            // Forward branch: if body is fallthrough (branch not taken).
            let condition = build_branch_condition(insns, i, false);
            let mut else_end_pc = None;

            if let Some(target_idx) = pc_to_idx.get(&target_pc).copied() {
                if target_idx > i + 1 && target_idx > 0 {
                    let prev_idx = target_idx - 1;
                    if let Some(jmp_end_pc) = jmp_target(&insns[prev_idx]) {
                        if jmp_end_pc > target_pc {
                            else_end_pc = Some(jmp_end_pc);
                        }
                    }
                }
            }

            if i + 1 < insns.len() {
                if_open_at.entry(i + 1).or_default().push(IfInfo {
                    condition,
                    target_pc,
                    else_end_pc,
                });
            }
        } else if target_pc < insn.pc {
            // Backward branch: loop condition is branch-taken condition.
            let condition = build_branch_condition(insns, i, true);
            while_open_at.entry(target_pc).or_default().push(WhileInfo {
                condition,
                backward_jcc_idx: i,
            });
        }
    }

    let mut stmts: Vec<HLStmt> = Vec::new();
    let mut regs: HashMap<String, RegVal> = HashMap::new();
    let mut fresh: HashSet<String> = HashSet::new();
    let mut vc: u32 = 0;
    
    let mut active_scopes: Vec<Scope> = Vec::new();

    for (i, insn) in insns.iter().enumerate() {
        if insn.semantic == Semantic::Int3 || insn.semantic == Semantic::Nop {
            continue;
        }

        // Close scopes that end at current PC
        loop {
            if let Some(scope) = active_scopes.last() {
                match scope {
                    Scope::Switch { end_pc, .. } if *end_pc == insn.pc => {
                        stmts.push(HLStmt::SwitchEnd);
                        active_scopes.pop();
                    }
                    Scope::If { end_pc } if *end_pc == insn.pc => {
                        stmts.push(HLStmt::IfEnd);
                        active_scopes.pop();
                    }
                    Scope::IfElse { else_start_pc, in_else: false, .. } if *else_start_pc == insn.pc => {
                        stmts.push(HLStmt::Else);
                        if let Some(Scope::IfElse { else_start_pc, end_pc, .. }) = active_scopes.pop() {
                            active_scopes.push(Scope::IfElse { else_start_pc, end_pc, in_else: true });
                        }
                        break; // Important: Enter else, do not pop more scopes yet.
                    }
                    Scope::IfElse { end_pc, in_else: true, .. } if *end_pc == insn.pc => {
                        stmts.push(HLStmt::IfEnd);
                        active_scopes.pop();
                    }
                    Scope::While { end_pc } if *end_pc == insn.pc => {
                        stmts.push(HLStmt::WhileEnd);
                        active_scopes.pop();
                    }
                    _ => break,
                }
            } else {
                break;
            }
        }

        // Open while-loops at backward branch target PCs.
        if let Some(whiles) = while_open_at.get_mut(&insn.pc) {
            // Outer loops first: sort descending by backward_jcc_idx
            whiles.sort_by_key(|w| std::cmp::Reverse(w.backward_jcc_idx));
            for winfo in whiles {
                stmts.push(HLStmt::WhileBegin {
                    condition: winfo.condition.clone(),
                });
                let end_pc = if winfo.backward_jcc_idx + 1 < insns.len() {
                    insns[winfo.backward_jcc_idx + 1].pc
                } else {
                    u64::MAX
                };
                active_scopes.push(Scope::While { end_pc });
            }
        }

        // Open if-blocks.
        if let Some(ifs) = if_open_at.get(&i) {
            for info in ifs {
                stmts.push(HLStmt::IfBegin {
                    condition: info.condition.clone(),
                });
                if let Some(else_end) = info.else_end_pc {
                    active_scopes.push(Scope::IfElse {
                        else_start_pc: info.target_pc,
                        end_pc: else_end,
                        in_else: false,
                    });
                } else {
                    active_scopes.push(Scope::If { end_pc: info.target_pc });
                }
            }
        }

        // Open switch blocks.
        if let Some(ids) = switch_open_at.get(&i) {
            for sid in ids {
                let pattern = &switch_patterns[*sid];
                stmts.push(HLStmt::SwitchBegin {
                    expr: pattern.selector.clone(),
                });
                active_scopes.push(Scope::Switch {
                    end_pc: pattern.end_pc,
                    sid: *sid,
                });
            }
        }

        // Emit case/default labels for the currently active switch.
        let active_sid = active_scopes.iter().rev().find_map(|s| {
            if let Scope::Switch { sid, .. } = s { Some(*sid) } else { None }
        });

        if let Some(sid) = active_sid {
            let pattern = &switch_patterns[sid];
            if let Some(values) = pattern.case_values_by_pc.get(&insn.pc) {
                let mut values = values.clone();
                values.sort_unstable();
                stmts.push(HLStmt::SwitchCase { values });
            } else if pattern.default_pc == insn.pc {
                stmts.push(HLStmt::SwitchDefault);
            }
        }

        // Skip switch dispatch instructions (cmp/jcc/jmp table dispatch).
        if switch_dispatch_indices.contains(&i) {
            continue;
        }

        // Convert jumps from case blocks to switch end into `break;`.
        if let Some(sid) = active_sid {
            if let Some(target_pc) = jmp_target(insn) {
                if target_pc == switch_patterns[sid].end_pc {
                    stmts.push(HLStmt::Break);
                    continue;
                }
            }
        }

        // Skip control-flow instructions consumed by structuring.
        if insn.semantic == Semantic::Test
            || insn.semantic == Semantic::Cmp
            || matches!(insn.semantic, Semantic::Jcc(_))
            || insn.semantic == Semantic::Jmp
        {
            continue;
        }

        // ── CALL ─────────────────────────────────────────────────────
        if insn.semantic == Semantic::Call && !consumed[i] {
            let target = resolve_call_target(insn, &regs, signature_db);
            let args = collect_args(&regs, &fresh);

            let result_type = match &target {
                CallTarget::Direct {
                    return_type: Some(ty),
                    ..
                } if ty != "void" => ty.clone(),
                _ => "void*".to_string(),
            };

            let result = if used[i] {
                let name = format!("v{}", vc);
                vc += 1;
                regs.insert("RAX".into(), RegVal::CallResult(name.clone()));
                Some((name, result_type))
            } else {
                regs.remove("RAX");
                None
            };

            fresh.clear();
            stmts.push(HLStmt::Call {
                result,
                target,
                args,
            });
            continue;
        }

        // ── Update register state ────────────────────────────────────
        update_state(insn, &mut regs, &mut fresh, locals);

        if consumed[i] {
            continue;
        }

        // ── Emit non-consumed statements ─────────────────────────────
        match &insn.semantic {
            Semantic::Mov => {
                // Memory store: mov [base+disp], src
                if let (Some(Operand::Mem { base, disp, .. }), Some(src)) =
                    (&insn.dst, insn.srcs.first())
                {
                    let value = to_expr(src, &regs);
                    if base == "RSP" {
                        // Local variable store
                        let dst = local_name(locals, *disp);
                        stmts.push(HLStmt::Assign { dst, value });
                    } else {
                        // Struct field store: base->field_XX = value
                        let base_name = resolve_reg_name(base, &regs);
                        let target = if *disp == 0 {
                            format!("*{}", base_name)
                        } else {
                            format!("{}->field_{:x}", base_name, disp)
                        };
                        stmts.push(HLStmt::FieldStore { target, value });
                    }
                }
                // Memory load to register (non-RSP): reg = base->field_XX
                if let (Some(Operand::Reg(dst)), Some(Operand::Mem { base, disp, .. })) =
                    (&insn.dst, insn.srcs.first())
                {
                    if base != "RSP" && dst != "RSP" && !consumed[i] {
                        let base_name = resolve_reg_name(base, &regs);
                        let expr = if *disp == 0 {
                            format!("*{}", base_name)
                        } else {
                            format!("{}->field_{:x}", base_name, disp)
                        };
                        stmts.push(HLStmt::Comment(format!(
                            "{} = {}",
                            dst.to_lowercase(),
                            expr
                        )));
                    }
                }
            }

            Semantic::Dec => {
                if let Some(Operand::Addr(a)) = &insn.dst {
                    stmts.push(HLStmt::Comment(format!(
                        "(*0x{:x})--  // global ref counter",
                        a
                    )));
                }
            }

            Semantic::Inc => {
                if let Some(Operand::Addr(a)) = &insn.dst {
                    stmts.push(HLStmt::Comment(format!(
                        "(*0x{:x})++  // global ref counter",
                        a
                    )));
                }
            }

            Semantic::Ret => stmts.push(HLStmt::Return),

            Semantic::Sub | Semantic::Add if matches!(&insn.dst, Some(Operand::Reg(r)) if r == "RSP") =>
            {
                // prologue/epilogue — skip
            }

            Semantic::Push | Semantic::Pop => {
                // prologue/epilogue save/restore — skip
            }

            _ => {}
        }
    }

    // Close any remaining unclosed blocks.
    while let Some(scope) = active_scopes.pop() {
        match scope {
            Scope::Switch { .. } => stmts.push(HLStmt::SwitchEnd),
            Scope::While { .. } => stmts.push(HLStmt::WhileEnd),
            Scope::If { .. } | Scope::IfElse { .. } => stmts.push(HLStmt::IfEnd),
        }
    }

    stmts
}

// ─── Call Target Resolution ─────────────────────────────────────────────────

fn resolve_call_target(
    insn: &RemillInsn,
    regs: &HashMap<String, RegVal>,
    signature_db: &SignatureDb,
) -> CallTarget {
    match insn.srcs.first() {
        Some(Operand::Addr(a)) => direct_call_target(*a, signature_db),
        Some(Operand::Imm(v)) if *v >= 0 => direct_call_target(*v as u64, signature_db),
        Some(Operand::Reg(r)) => match regs.get(r) {
            Some(RegVal::Constant(v)) if *v >= 0 => direct_call_target(*v as u64, signature_db),
            Some(RegVal::CallResult(name)) => CallTarget::Indirect(name.clone()),
            _ => CallTarget::Indirect(r.to_lowercase()),
        },
        _ => direct_call_target(0, signature_db),
    }
}

fn direct_call_target(address: u64, signature_db: &SignatureDb) -> CallTarget {
    if let Some(sig) = signature_db.lookup(address) {
        CallTarget::Direct {
            address,
            name: sig.name.clone(),
            return_type: Some(sig.return_type.clone()),
        }
    } else {
        CallTarget::Direct {
            address,
            name: format!("sub_{:x}", address),
            return_type: None,
        }
    }
}

// ─── Switch Analysis ────────────────────────────────────────────────────────

fn detect_switch_patterns(
    insns: &[RemillInsn],
    pc_to_idx: &HashMap<u64, usize>,
) -> Vec<SwitchPattern> {
    let mut patterns = Vec::new();
    let mut i = 0usize;

    while i + 3 < insns.len() {
        let Some((selector, _)) = cmp_selector_imm(&insns[i]) else {
            i += 1;
            continue;
        };

        let mut j = i;
        let mut cases: Vec<(i64, u64)> = Vec::new();
        let mut dispatch_indices: HashSet<usize> = HashSet::new();

        while j + 1 < insns.len() {
            let Some((cmp_selector, case_value)) = cmp_selector_imm(&insns[j]) else {
                break;
            };
            if cmp_selector != selector {
                break;
            }

            let Some((cc, target_pc)) = jcc_info(&insns[j + 1]) else {
                break;
            };
            if !is_equal_branch(cc) || target_pc <= insns[j + 1].pc {
                break;
            }

            cases.push((case_value, target_pc));
            dispatch_indices.insert(j);
            dispatch_indices.insert(j + 1);
            j += 2;
        }

        if cases.len() < 2 {
            i += 1;
            continue;
        }

        let (dispatch_end_idx, default_pc) = if j < insns.len() {
            if let Some(jmp_default) = jmp_target(&insns[j]) {
                if jmp_default <= insns[j].pc {
                    i += 1;
                    continue;
                }
                dispatch_indices.insert(j);
                (j, jmp_default)
            } else {
                // Fallback: default path falls through directly after dispatch.
                (j - 1, insns[j].pc)
            }
        } else {
            i += 1;
            continue;
        };

        let open_at_idx = dispatch_end_idx + 1;
        if open_at_idx >= insns.len() {
            i = dispatch_end_idx + 1;
            continue;
        }

        let mut case_values_by_pc: HashMap<u64, Vec<i64>> = HashMap::new();
        for (value, target_pc) in cases {
            case_values_by_pc.entry(target_pc).or_default().push(value);
        }

        let Some(end_pc) = infer_switch_end(insns, pc_to_idx, &case_values_by_pc, default_pc)
        else {
            i += 1;
            continue;
        };

        patterns.push(SwitchPattern {
            selector: selector.to_lowercase(),
            open_at_idx,
            end_pc,
            case_values_by_pc,
            default_pc,
            dispatch_indices,
        });

        i = dispatch_end_idx + 1;
    }

    patterns
}

fn infer_switch_end(
    insns: &[RemillInsn],
    pc_to_idx: &HashMap<u64, usize>,
    case_values_by_pc: &HashMap<u64, Vec<i64>>,
    default_pc: u64,
) -> Option<u64> {
    let mut block_starts: Vec<(usize, u64)> = case_values_by_pc
        .keys()
        .copied()
        .chain(std::iter::once(default_pc))
        .filter_map(|pc| pc_to_idx.get(&pc).copied().map(|idx| (idx, pc)))
        .collect();

    if block_starts.is_empty() {
        return None;
    }

    block_starts.sort_unstable_by_key(|(idx, _)| *idx);
    block_starts.dedup_by_key(|(idx, _)| *idx);

    let mut exit_target_counts: HashMap<u64, u32> = HashMap::new();
    for (pos, (start_idx, _)) in block_starts.iter().enumerate() {
        let end_idx = block_starts
            .get(pos + 1)
            .map(|(idx, _)| *idx)
            .unwrap_or(insns.len());
        for insn in &insns[*start_idx..end_idx] {
            if let Some(target_pc) = jmp_target(insn) {
                if target_pc > insn.pc {
                    *exit_target_counts.entry(target_pc).or_insert(0) += 1;
                    break;
                }
            }
        }
    }

    if exit_target_counts.is_empty() {
        return None;
    }

    let max_block_start_pc = block_starts
        .iter()
        .map(|(_, pc)| *pc)
        .max()
        .unwrap_or(default_pc);

    exit_target_counts
        .into_iter()
        .filter(|(target, _)| *target > max_block_start_pc)
        .max_by_key(|(_, count)| *count)
        .map(|(target, _)| target)
}

fn cmp_selector_imm(insn: &RemillInsn) -> Option<(String, i64)> {
    if insn.semantic != Semantic::Cmp {
        return None;
    }
    match (insn.srcs.first(), insn.srcs.get(1)) {
        (Some(Operand::Reg(reg)), Some(Operand::Imm(value))) => Some((reg.clone(), *value)),
        (Some(Operand::Imm(value)), Some(Operand::Reg(reg))) => Some((reg.clone(), *value)),
        _ => None,
    }
}

fn is_equal_branch(cc: &str) -> bool {
    matches!(cc, "JZ" | "JE")
}

// ─── Branch Helpers ─────────────────────────────────────────────────────────

fn jcc_info(insn: &RemillInsn) -> Option<(&str, u64)> {
    let Semantic::Jcc(cc) = &insn.semantic else {
        return None;
    };
    let target = match insn.srcs.first() {
        Some(Operand::Addr(a)) => *a,
        Some(Operand::Imm(v)) if *v >= 0 => *v as u64,
        _ => return None,
    };
    Some((cc.as_str(), target))
}

fn jmp_target(insn: &RemillInsn) -> Option<u64> {
    if insn.semantic != Semantic::Jmp {
        return None;
    }
    match insn.srcs.first() {
        Some(Operand::Addr(a)) => Some(*a),
        Some(Operand::Imm(v)) if *v >= 0 => Some(*v as u64),
        _ => None,
    }
}

/// Build a human-readable condition from the TEST/CMP before a Jcc.
///
/// - `branch_taken=true`  → condition under which the branch is taken
/// - `branch_taken=false` → condition under which flow falls through
fn build_branch_condition(insns: &[RemillInsn], jcc_idx: usize, branch_taken: bool) -> String {
    let Some((cc, _)) = jcc_info(&insns[jcc_idx]) else {
        return "???".to_string();
    };

    let Some((lhs, rhs)) = comparison_operands_before(insns, jcc_idx) else {
        return "???".to_string();
    };

    let Some(op) = comparison_operator(cc, branch_taken) else {
        return "???".to_string();
    };

    format!("{} {} {}", lhs, op, rhs)
}

fn comparison_operands_before(insns: &[RemillInsn], jcc_idx: usize) -> Option<(String, String)> {
    let mut j = jcc_idx;
    while j > 0 {
        j -= 1;
        match &insns[j].semantic {
            Semantic::Test => {
                let lhs = insns[j]
                    .srcs
                    .first()
                    .map(format_condition_operand)
                    .unwrap_or_else(|| "???".to_string());
                return Some((lhs, "0".to_string()));
            }
            Semantic::Cmp => {
                let lhs = insns[j]
                    .srcs
                    .first()
                    .map(format_condition_operand)
                    .unwrap_or_else(|| "???".to_string());
                let rhs = insns[j]
                    .srcs
                    .get(1)
                    .map(format_condition_operand)
                    .unwrap_or_else(|| "???".to_string());
                return Some((lhs, rhs));
            }
            Semantic::Call | Semantic::Ret => break,
            _ => {}
        }
    }
    None
}

fn format_condition_operand(op: &Operand) -> String {
    match op {
        Operand::Reg(r) => r.to_lowercase(),
        Operand::Imm(v) => format_immediate(*v),
        Operand::Addr(a) => format!("0x{:x}", a),
        Operand::Mem { base, disp, .. } => format!("[{} + 0x{:x}]", base.to_lowercase(), disp),
    }
}

fn comparison_operator(cc: &str, branch_taken: bool) -> Option<&'static str> {
    let taken_op = match cc.to_ascii_uppercase().as_str() {
        "JZ" | "JE" => "==",
        "JNZ" | "JNE" => "!=",
        "JA" | "JNBE" => ">",
        "JAE" | "JNB" | "JNC" => ">=",
        "JB" | "JNAE" | "JC" => "<",
        "JBE" | "JNA" => "<=",
        "JG" | "JNLE" => ">",
        "JGE" | "JNL" => ">=",
        "JL" | "JNGE" => "<",
        "JLE" | "JNG" => "<=",
        _ => return None,
    };

    if branch_taken {
        Some(taken_op)
    } else {
        invert_comparison(taken_op)
    }
}

fn invert_comparison(op: &str) -> Option<&'static str> {
    match op {
        "==" => Some("!="),
        "!=" => Some("=="),
        ">" => Some("<="),
        ">=" => Some("<"),
        "<" => Some(">="),
        "<=" => Some(">"),
        _ => None,
    }
}

// ─── Call Analysis ──────────────────────────────────────────────────────────

fn mark_consumed(insns: &[RemillInsn]) -> Vec<bool> {
    let mut consumed = vec![false; insns.len()];
    for (i, insn) in insns.iter().enumerate() {
        if insn.semantic != Semantic::Call {
            continue;
        }
        let mut j = i;
        while j > 0 {
            j -= 1;
            let prev = &insns[j];
            if prev.semantic == Semantic::Call
                || prev.semantic == Semantic::Ret
                || matches!(prev.semantic, Semantic::Jcc(_))
            {
                break;
            }
            if prev.semantic == Semantic::Sub
                && matches!(&prev.dst, Some(Operand::Reg(r)) if r == "RSP")
            {
                break;
            }
            if let Some(Operand::Reg(dst)) = &prev.dst {
                if WIN64_ARG_REGS.contains(&dst.as_str()) {
                    consumed[j] = true;
                }
            }
        }
    }
    consumed
}

fn mark_used_results(insns: &[RemillInsn]) -> Vec<bool> {
    let mut used = vec![false; insns.len()];
    for (i, insn) in insns.iter().enumerate() {
        if insn.semantic != Semantic::Call {
            continue;
        }
        for next in insns.iter().skip(i + 1) {
            let reads_rax = next
                .srcs
                .iter()
                .any(|s| matches!(s, Operand::Reg(r) if r == "RAX"));
            if reads_rax {
                used[i] = true;
                break;
            }
            if matches!(&next.dst, Some(Operand::Reg(r)) if r == "RAX") {
                break;
            }
            if next.semantic == Semantic::Call || next.semantic == Semantic::Ret {
                break;
            }
        }
    }
    used
}

fn collect_args(regs: &HashMap<String, RegVal>, fresh: &HashSet<String>) -> Vec<HLExpr> {
    let mut args = Vec::new();
    for reg in &WIN64_ARG_REGS {
        if fresh.contains(*reg) {
            if let Some(val) = regs.get(*reg) {
                args.push(val_to_expr(val));
            }
        } else {
            break;
        }
    }
    args
}

// ─── State Tracking ─────────────────────────────────────────────────────────

fn update_state(
    insn: &RemillInsn,
    regs: &mut HashMap<String, RegVal>,
    fresh: &mut HashSet<String>,
    locals: &[LocalInfo],
) {
    match &insn.semantic {
        Semantic::Mov => {
            if let (Some(Operand::Reg(dst)), Some(src)) = (&insn.dst, insn.srcs.first()) {
                let val = src_to_val(src, regs);
                regs.insert(dst.clone(), val);
                fresh.insert(dst.clone());
            }
        }
        Semantic::Lea => {
            if let (Some(Operand::Reg(dst)), Some(Operand::Mem { base, disp, .. })) =
                (&insn.dst, insn.srcs.first())
            {
                if base == "RSP" {
                    regs.insert(dst.clone(), RegVal::AddrOfLocal(local_name(locals, *disp)));
                } else {
                    regs.insert(dst.clone(), RegVal::Unknown);
                }
                fresh.insert(dst.clone());
            }
        }
        Semantic::Xor => {
            if let Some(Operand::Reg(dst)) = &insn.dst {
                regs.insert(dst.clone(), RegVal::Constant(0));
                fresh.insert(dst.clone());
            }
        }
        _ => {
            if let Some(Operand::Reg(dst)) = &insn.dst {
                let val = insn
                    .srcs
                    .first()
                    .map(|s| src_to_val(s, regs))
                    .unwrap_or(RegVal::Unknown);
                regs.insert(dst.clone(), val);
                fresh.insert(dst.clone());
            }
        }
    }
}

fn src_to_val(op: &Operand, regs: &HashMap<String, RegVal>) -> RegVal {
    match op {
        Operand::Imm(v) => RegVal::Constant(*v),
        Operand::Reg(r) => regs.get(r).cloned().unwrap_or(RegVal::Unknown),
        Operand::Addr(a) => RegVal::Constant(*a as i64),
        Operand::Mem { .. } => RegVal::Unknown,
    }
}

fn to_expr(op: &Operand, regs: &HashMap<String, RegVal>) -> HLExpr {
    match op {
        Operand::Imm(v) => HLExpr::Int(*v),
        Operand::Reg(r) => match regs.get(r) {
            Some(RegVal::CallResult(n)) => HLExpr::Var(n.clone()),
            Some(RegVal::Constant(v)) => HLExpr::Int(*v),
            Some(RegVal::AddrOfLocal(n)) => HLExpr::AddrOf(n.clone()),
            _ => HLExpr::Raw(r.to_lowercase()),
        },
        Operand::Addr(a) => HLExpr::Int(*a as i64),
        Operand::Mem { base, disp, .. } => {
            HLExpr::Raw(format!("[{} + 0x{:x}]", base.to_lowercase(), disp))
        }
    }
}

fn val_to_expr(val: &RegVal) -> HLExpr {
    match val {
        RegVal::Constant(v) => HLExpr::Int(*v),
        RegVal::CallResult(n) => HLExpr::Var(n.clone()),
        RegVal::AddrOfLocal(n) => HLExpr::AddrOf(n.clone()),
        RegVal::Unknown => HLExpr::Raw("???".into()),
    }
}

fn local_name(locals: &[LocalInfo], offset: i64) -> String {
    locals
        .iter()
        .find(|l| l.offset == offset)
        .map(|l| l.name.clone())
        .unwrap_or_else(|| format!("var_{:x}", offset))
}

fn resolve_reg_name(reg: &str, regs: &HashMap<String, RegVal>) -> String {
    match regs.get(reg) {
        Some(RegVal::CallResult(n)) => n.clone(),
        Some(RegVal::AddrOfLocal(n)) => n.clone(),
        Some(RegVal::Constant(v)) => format!("0x{:x}", v),
        _ => reg.to_lowercase(),
    }
}

fn format_immediate(v: i64) -> String {
    if v >= 16 || v <= -16 {
        format!("0x{:x}", v)
    } else {
        format!("{}", v)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn insn(pc: u64, semantic: Semantic, dst: Option<Operand>, srcs: Vec<Operand>) -> RemillInsn {
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
    fn detects_if_else_shape() {
        let insns = vec![
            insn(
                0x100,
                Semantic::Test,
                None,
                vec![Operand::Reg("RAX".into()), Operand::Reg("RAX".into())],
            ),
            insn(
                0x102,
                Semantic::Jcc("JZ".into()),
                None,
                vec![Operand::Addr(0x120)],
            ),
            insn(
                0x104,
                Semantic::Mov,
                Some(Operand::Mem {
                    base: "RSP".into(),
                    disp: 8,
                    size_bits: 64,
                }),
                vec![Operand::Imm(1)],
            ),
            insn(0x106, Semantic::Jmp, None, vec![Operand::Addr(0x130)]),
            insn(
                0x120,
                Semantic::Mov,
                Some(Operand::Mem {
                    base: "RSP".into(),
                    disp: 8,
                    size_bits: 64,
                }),
                vec![Operand::Imm(2)],
            ),
            insn(0x130, Semantic::Ret, None, vec![]),
        ];
        let locals = vec![LocalInfo {
            name: "var_8".into(),
            offset: 8,
        }];

        let stmts = transform_with_signatures(&insns, &locals, &SignatureDb::new());

        assert!(matches!(
            stmts.first(),
            Some(HLStmt::IfBegin { condition }) if condition == "rax != 0"
        ));
        assert!(stmts.iter().any(|s| matches!(s, HLStmt::Else)));
        assert!(stmts.iter().any(|s| matches!(
            s,
            HLStmt::Assign { dst, value: HLExpr::Int(2) } if dst == "var_8"
        )));
    }

    #[test]
    fn detects_switch_from_compare_chain() {
        let insns = vec![
            insn(
                0x100,
                Semantic::Cmp,
                None,
                vec![Operand::Reg("EAX".into()), Operand::Imm(0)],
            ),
            insn(
                0x102,
                Semantic::Jcc("JZ".into()),
                None,
                vec![Operand::Addr(0x120)],
            ),
            insn(
                0x104,
                Semantic::Cmp,
                None,
                vec![Operand::Reg("EAX".into()), Operand::Imm(1)],
            ),
            insn(
                0x106,
                Semantic::Jcc("JZ".into()),
                None,
                vec![Operand::Addr(0x130)],
            ),
            insn(0x108, Semantic::Jmp, None, vec![Operand::Addr(0x140)]),
            insn(
                0x120,
                Semantic::Mov,
                Some(Operand::Mem {
                    base: "RSP".into(),
                    disp: 8,
                    size_bits: 64,
                }),
                vec![Operand::Imm(10)],
            ),
            insn(0x124, Semantic::Jmp, None, vec![Operand::Addr(0x150)]),
            insn(
                0x130,
                Semantic::Mov,
                Some(Operand::Mem {
                    base: "RSP".into(),
                    disp: 8,
                    size_bits: 64,
                }),
                vec![Operand::Imm(20)],
            ),
            insn(0x134, Semantic::Jmp, None, vec![Operand::Addr(0x150)]),
            insn(
                0x140,
                Semantic::Mov,
                Some(Operand::Mem {
                    base: "RSP".into(),
                    disp: 8,
                    size_bits: 64,
                }),
                vec![Operand::Imm(30)],
            ),
            insn(0x150, Semantic::Ret, None, vec![]),
        ];
        let locals = vec![LocalInfo {
            name: "var_8".into(),
            offset: 8,
        }];

        let stmts = transform_with_signatures(&insns, &locals, &SignatureDb::new());

        assert!(matches!(
            stmts.first(),
            Some(HLStmt::SwitchBegin { expr }) if expr == "eax"
        ));
        assert!(stmts.iter().any(|s| matches!(
            s,
            HLStmt::SwitchCase { values } if values.as_slice() == [0]
        )));
        assert!(stmts.iter().any(|s| matches!(
            s,
            HLStmt::SwitchCase { values } if values.as_slice() == [1]
        )));
        assert!(stmts.iter().any(|s| matches!(s, HLStmt::SwitchDefault)));
        assert!(stmts.iter().any(|s| matches!(s, HLStmt::SwitchEnd)));
        assert_eq!(
            stmts.iter().filter(|s| matches!(s, HLStmt::Break)).count(),
            2
        );
    }

    #[test]
    fn applies_signature_db_to_call_targets() {
        let insns = vec![
            insn(
                0x100,
                Semantic::Mov,
                Some(Operand::Reg("RCX".into())),
                vec![Operand::Imm(1)],
            ),
            insn(
                0x102,
                Semantic::Call,
                Some(Operand::Reg("RAX".into())),
                vec![Operand::Addr(0x140001000)],
            ),
            insn(
                0x104,
                Semantic::Mov,
                Some(Operand::Reg("RBX".into())),
                vec![Operand::Reg("RAX".into())],
            ),
            insn(0x106, Semantic::Ret, None, vec![]),
        ];

        let mut db = SignatureDb::new();
        db.insert(0x140001000, "CreateFileW", "HANDLE");

        let stmts = transform_with_signatures(&insns, &[], &db);
        let call_stmt = stmts.iter().find_map(|stmt| {
            if let HLStmt::Call { result, target, .. } = stmt {
                Some((result, target))
            } else {
                None
            }
        });

        let Some((result, target)) = call_stmt else {
            panic!("expected call statement");
        };

        assert!(matches!(
            target,
            CallTarget::Direct { name, .. } if name == "CreateFileW"
        ));
        assert!(matches!(result, Some((_, ty)) if ty == "HANDLE"));
    }
}
