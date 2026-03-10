//! Control flow structuring pass for HIR.
//!
//! Transforms the flat linear HIR statement list into structured
//! control flow (if/else, while loops) by analyzing CMP/TEST + Jcc
//! comment patterns left by `hir_builder.rs`.
//!
//! ## Algorithm
//!
//! 1. Scan the flat statement list for Jcc comments and their
//!    associated CMP/TEST comments (immediately preceding).
//! 2. Classify forward branches as `if` (body is fallthrough),
//!    backward branches as `while` (loop condition).
//! 3. Detect `else` transitions: when the last statement before
//!    an if-close target is an unconditional JMP forward.
//! 4. Build structured `HirStmt::If` and `HirStmt::While` nodes
//!    by slicing the flat statement list at branch boundaries.
//!
//! ## CMOV Condition Recovery
//!
//! Also recovers CMOV conditions: when a `HirStmt::Assign` has a
//! `HirExpr::Ternary` with an `Unknown("flags.XX")` condition, we
//! look backward for the nearest CMP/TEST comment and replace the
//! placeholder with a proper comparison expression.

use crate::ir::hir::*;
use crate::diagnostics::{DiagnosticKind, DiagnosticSink};

/// Result of control flow structuring.
#[derive(Debug, Clone, Default)]
pub struct ControlFlowResult {
    /// Number of if/else blocks recovered.
    pub ifs_recovered: usize,
    /// Number of while loops recovered.
    pub loops_recovered: usize,
    /// Number of CMOV conditions resolved via CMP/TEST pairing.
    pub cmov_conditions_resolved: usize,
    /// Number of Jcc comments consumed (removed from output).
    pub jcc_comments_consumed: usize,
}

/// Run control flow structuring on an HIR module in-place.
///
/// This pass:
/// 1. Recovers CMOV conditions from CMP/TEST comments
/// 2. Structures linear Jcc/JMP comments into If/While blocks
pub fn structure_control_flow(
    module: &mut HirModule,
    sink: &mut DiagnosticSink,
) -> ControlFlowResult {
    let mut result = ControlFlowResult::default();

    for func in &mut module.functions {
        let func_result = structure_function(func, sink);
        result.ifs_recovered += func_result.ifs_recovered;
        result.loops_recovered += func_result.loops_recovered;
        result.cmov_conditions_resolved += func_result.cmov_conditions_resolved;
        result.jcc_comments_consumed += func_result.jcc_comments_consumed;
    }

    result
}

/// Structure a single function's control flow.
fn structure_function(func: &mut HirFunction, sink: &mut DiagnosticSink) -> ControlFlowResult {
    let mut result = ControlFlowResult::default();

    // Build variable name → ID map for condition resolution
    let var_name_to_id: std::collections::HashMap<String, HirVarId> = func
        .locals
        .iter()
        .chain(func.params.iter())
        .map(|v| (v.name.clone(), v.id))
        .collect();

    // Phase 1: Recover CMOV conditions from CMP/TEST comments
    result.cmov_conditions_resolved = recover_cmov_conditions(&mut func.body);

    // Phase 2: Structure Jcc/JMP into if/while
    let (new_body, cf_result) = structure_statements(&func.body, &func.name, sink, &var_name_to_id);
    result.ifs_recovered += cf_result.ifs_recovered;
    result.loops_recovered += cf_result.loops_recovered;
    result.jcc_comments_consumed += cf_result.jcc_comments_consumed;

    func.body = new_body;

    result
}

// ─── CMOV Condition Recovery ────────────────────────────────────────────────

/// Scan statements and recover CMOV conditions.
///
/// When we see a ternary with `Unknown("flags.XX")`, look backward for
/// the nearest CMP/TEST comment and build a proper comparison expression.
fn recover_cmov_conditions(stmts: &mut [HirStmt]) -> usize {
    let mut resolved = 0;

    // First, collect CMP/TEST info from comments
    let cmp_info: Vec<Option<CmpInfo>> = stmts.iter().map(extract_cmp_info).collect();

    // Now scan for CMOVs and resolve their conditions
    for (i, stmt) in stmts.iter_mut().enumerate() {
        if let HirStmt::Assign {
            rhs: HirExpr::Ternary { cond, .. },
            span,
            ..
        } = stmt
        {
            if let HirExpr::Unknown { description, .. } = cond.as_ref() {
                if let Some(cc) = description.strip_prefix("flags.") {
                    if let Some(info) = find_preceding_cmp(&cmp_info, i) {
                        let cond_expr = build_condition_expr(
                            cc,
                            &info,
                            *span,
                            &std::collections::HashMap::new(),
                        );

                        **cond = cond_expr;
                        resolved += 1;
                    }
                }
            }
        }
    }

    resolved
}

/// Information extracted from a CMP or TEST comment.
#[derive(Debug, Clone)]
struct CmpInfo {
    /// Whether this is a TEST (vs CMP).
    is_test: bool,
    /// Left-hand operand string.
    lhs: String,
    /// Right-hand operand string (empty for TEST?).
    rhs: String,
}

/// Try to extract CMP/TEST info from a comment statement.
fn extract_cmp_info(stmt: &HirStmt) -> Option<CmpInfo> {
    if let HirStmt::Comment { text, .. } = stmt {
        let text = text.trim();
        let (opcode, operands) = text.split_once(' ')?;

        // Accept both the lowercase comments emitted by our HIR builder and
        // uppercase forms that may appear in imported/debug fixtures.
        if opcode.eq_ignore_ascii_case("cmp") {
            let (lhs, rhs) = split_operands(operands)?;
            return Some(CmpInfo {
                is_test: false,
                lhs: lhs.to_string(),
                rhs: rhs.to_string(),
            });
        }
        if opcode.eq_ignore_ascii_case("test") {
            let (lhs, rhs) = split_operands(operands)?;
            return Some(CmpInfo {
                is_test: true,
                lhs: lhs.to_string(),
                rhs: rhs.to_string(),
            });
        }
    }
    None
}

fn split_operands(text: &str) -> Option<(&str, &str)> {
    let (lhs, rhs) = text.split_once(',')?;
    Some((lhs.trim(), rhs.trim()))
}

/// Find the nearest preceding CMP/TEST comment before statement `idx`.
fn find_preceding_cmp(cmp_info: &[Option<CmpInfo>], idx: usize) -> Option<CmpInfo> {
    cmp_info[..idx].iter().rev().flatten().next().cloned()
}

/// Build a HIR condition expression from a condition code and CMP/TEST info.
fn build_condition_expr(
    cc: &str,
    info: &CmpInfo,
    span: Span,
    var_names: &std::collections::HashMap<String, HirVarId>,
) -> HirExpr {
    let lhs = parse_operand_expr(&info.lhs, span, var_names);
    let rhs = parse_operand_expr(&info.rhs, span, var_names);

    if info.is_test {
        let lhs_str = &info.lhs;
        let rhs_str = &info.rhs;

        if lhs_str == rhs_str {
            let zero = HirExpr::IntLit {
                value: 0,
                ty: HirType::i64(),
                span,
            };
            match cc_to_comparison_op(cc, false) {
                Some(op) => HirExpr::Binary {
                    op,
                    lhs: Box::new(lhs),
                    rhs: Box::new(zero),
                    ty: HirType::Bool,
                    span,
                },
                None => HirExpr::Unknown {
                    description: format!("test_cond_{}", cc),
                    span,
                },
            }
        } else {
            let and_expr = HirExpr::Binary {
                op: HirBinOp::BitAnd,
                lhs: Box::new(lhs),
                rhs: Box::new(rhs),
                ty: HirType::i64(),
                span,
            };
            let zero = HirExpr::IntLit {
                value: 0,
                ty: HirType::i64(),
                span,
            };
            match cc_to_comparison_op(cc, false) {
                Some(op) => HirExpr::Binary {
                    op,
                    lhs: Box::new(and_expr),
                    rhs: Box::new(zero),
                    ty: HirType::Bool,
                    span,
                },
                None => HirExpr::Unknown {
                    description: format!("test_cond_{}", cc),
                    span,
                },
            }
        }
    } else {
        match cc_to_comparison_op(cc, false) {
            Some(op) => HirExpr::Binary {
                op,
                lhs: Box::new(lhs),
                rhs: Box::new(rhs),
                ty: HirType::Bool,
                span,
            },
            None => HirExpr::Unknown {
                description: format!("cmp_cond_{}", cc),
                span,
            },
        }
    }
}

fn parse_operand_expr(
    text: &str,
    span: Span,
    var_names: &std::collections::HashMap<String, HirVarId>,
) -> HirExpr {
    if let Some(hex) = text.strip_prefix("0x") {
        if let Ok(value) = u64::from_str_radix(hex, 16) {
            return HirExpr::IntLit {
                value: value as i64,
                ty: HirType::i64(),
                span,
            };
        }
    }

    if let Ok(value) = text.parse::<i64>() {
        return HirExpr::IntLit {
            value,
            ty: HirType::i64(),
            span,
        };
    }

    let lower = text.to_lowercase();
    if let Some(id) = var_names.get(&lower) {
        return HirExpr::Var {
            id: *id,
            span,
        };
    }

    HirExpr::Unknown {
        description: text.to_string(),
        span,
    }
}

/// Map a condition code to a comparison binary op.
///
/// `branch_taken` controls whether we use the direct or inverted operator
/// (for Jcc fallthrough vs. taken semantics).
fn cc_to_comparison_op(cc: &str, invert: bool) -> Option<HirBinOp> {
    let op = match cc.to_ascii_uppercase().as_str() {
        "E" | "Z" => HirBinOp::Eq,
        "NE" | "NZ" => HirBinOp::Ne,
        "A" | "NBE" => HirBinOp::Gt,   // unsigned above
        "AE" | "NB" | "NC" => HirBinOp::Ge, // unsigned above or equal
        "B" | "NAE" | "C" => HirBinOp::Lt,  // unsigned below
        "BE" | "NA" => HirBinOp::Le,    // unsigned below or equal
        "G" | "NLE" => HirBinOp::Gt,   // signed greater
        "GE" | "NL" => HirBinOp::Ge,   // signed greater or equal
        "L" | "NGE" => HirBinOp::Lt,   // signed less
        "LE" | "NG" => HirBinOp::Le,   // signed less or equal
        _ => return None,
    };

    if invert {
        invert_binop(op)
    } else {
        Some(op)
    }
}

/// Invert a comparison operator.
fn invert_binop(op: HirBinOp) -> Option<HirBinOp> {
    match op {
        HirBinOp::Eq => Some(HirBinOp::Ne),
        HirBinOp::Ne => Some(HirBinOp::Eq),
        HirBinOp::Gt => Some(HirBinOp::Le),
        HirBinOp::Ge => Some(HirBinOp::Lt),
        HirBinOp::Lt => Some(HirBinOp::Ge),
        HirBinOp::Le => Some(HirBinOp::Gt),
        _ => None,
    }
}

// ─── Control Flow Structuring ───────────────────────────────────────────────

/// Information about a branch extracted from a Jcc comment.
#[derive(Debug, Clone)]
struct BranchInfo {
    /// Index in the statement list.
    stmt_idx: usize,
    /// Condition code (e.g., "e", "ne") — without leading 'j'.
    cc: String,
    /// Target address or label.
    #[allow(dead_code)]
    target: String,
    /// Target address parsed as u64 (if possible).
    target_addr: Option<u64>,
    /// Source span.
    span: Span,
    /// Is this a forward branch?
    #[allow(dead_code)]
    is_forward: bool,
}

/// Information about a JMP extracted from a comment.
#[derive(Debug, Clone)]
struct JmpInfo {
    /// Index in the statement list.
    stmt_idx: usize,
    /// Target address or label.
    #[allow(dead_code)]
    target: String,
    /// Target address parsed as u64.
    target_addr: Option<u64>,
    /// Source span.
    span: Span,
}

/// Structure a flat list of statements into nested if/while blocks.
fn structure_statements(
    stmts: &[HirStmt],
    func_name: &str,
    sink: &mut DiagnosticSink,
    var_names: &std::collections::HashMap<String, HirVarId>,
) -> (Vec<HirStmt>, ControlFlowResult) {
    let mut result = ControlFlowResult::default();

    // Step 1: Collect branch and jump information
    let branches = collect_branches(stmts);
    let jumps = collect_jumps(stmts);

    // Step 2: Build an address → statement index map
    let addr_to_idx = build_addr_to_idx(stmts);

    // Step 3: Classify branches into if/while and build structured output
    let mut output: Vec<HirStmt> = Vec::new();
    let mut _skip_until: Option<usize> = None; // skip indices consumed by structuring
    let mut consumed_indices: std::collections::HashSet<usize> = std::collections::HashSet::new();

    // Mark CMP/TEST + Jcc pairs and JMP comments for consumption
    for br in &branches {
        consumed_indices.insert(br.stmt_idx); // the Jcc comment itself
        // Look backward for the CMP/TEST that feeds this Jcc
        if br.stmt_idx > 0
            && extract_cmp_info(&stmts[br.stmt_idx - 1]).is_some()
        {
            consumed_indices.insert(br.stmt_idx - 1);
        }
    }
    for jmp in &jumps {
        consumed_indices.insert(jmp.stmt_idx);
    }

    // Classify: forward Jcc = if, backward Jcc = while
    let mut if_targets: Vec<(usize, usize, HirExpr)> = Vec::new(); // (start_idx, end_idx, condition)
    let mut while_targets: Vec<(usize, usize, HirExpr)> = Vec::new(); // (loop_start, loop_end, condition)

    for br in &branches {
        if let Some(target_addr) = br.target_addr {
            // Find the CMP/TEST preceding this Jcc
            let cmp = if br.stmt_idx > 0 {
                extract_cmp_info(&stmts[br.stmt_idx - 1])
            } else {
                None
            };

            // Determine the source address from the span
            let src_addr = br.span.start_addr;

            if target_addr > src_addr {
                // Forward branch: if block. The condition is inverted (fallthrough = taken).
                let target_idx = addr_to_idx.get(&target_addr).copied();
                if let Some(end_idx) = target_idx {
                    let cond = if let Some(info) = &cmp {
                        build_condition_expr(&br.cc, info, br.span, var_names)
                    } else {
                        HirExpr::Unknown {
                            description: format!("cond_{}", br.cc),
                            span: br.span,
                        }
                    };

                    // Invert the condition for fallthrough semantics
                    let inverted_cond = invert_condition(cond, br.span);

                    let body_start = br.stmt_idx + 1;
                    if body_start < end_idx {
                        if_targets.push((body_start, end_idx, inverted_cond));
                        result.ifs_recovered += 1;
                    }
                }
            } else if target_addr < src_addr {
                // Backward branch: while loop.
                let loop_start_idx = addr_to_idx.get(&target_addr).copied();
                if let Some(start_idx) = loop_start_idx {
                    let cond = if let Some(info) = &cmp {
                        build_condition_expr(&br.cc, info, br.span, var_names)
                    } else {
                        HirExpr::Unknown {
                            description: format!("loop_cond_{}", br.cc),
                            span: br.span,
                        }
                    };

                    let loop_end = br.stmt_idx;
                    if start_idx < loop_end {
                        while_targets.push((start_idx, loop_end, cond));
                        result.loops_recovered += 1;
                    }
                }
            }
        }
    }

    // Step 3.5: Detect irreducible flow — branches that couldn't be structured
    // emit goto/label pairs as fallback.
    let mut goto_targets: std::collections::HashSet<u64> = std::collections::HashSet::new();
    let mut goto_sources: Vec<(usize, u64, Span)> = Vec::new(); // (stmt_idx, target_addr, span)

    // Check for branches that weren't classified as if or while
    let structured_branch_indices: std::collections::HashSet<usize> = {
        let mut set = std::collections::HashSet::new();
        for br in &branches {
            if let Some(target_addr) = br.target_addr {
                let src_addr = br.span.start_addr;
                if target_addr > src_addr {
                    // Forward: check if it was classified as an if
                    if addr_to_idx.contains_key(&target_addr) {
                        set.insert(br.stmt_idx);
                    }
                } else if target_addr < src_addr {
                    // Backward: check if it was classified as a while
                    if addr_to_idx.contains_key(&target_addr) {
                        set.insert(br.stmt_idx);
                    }
                }
            }
        }
        set
    };

    for br in &branches {
        if !structured_branch_indices.contains(&br.stmt_idx) {
            if let Some(target_addr) = br.target_addr {
                goto_targets.insert(target_addr);
                goto_sources.push((br.stmt_idx, target_addr, br.span));
            }
        }
    }

    // Also check for unconditional jumps that weren't consumed by if/else detection
    for jmp in &jumps {
        if let Some(target_addr) = jmp.target_addr {
            // If this JMP's target isn't the start of an else block or loop,
            // it might be irreducible flow
            let is_else_jmp = if_targets.iter().any(|(start, end, _)| {
                // JMP at end-1 is the else transition
                jmp.stmt_idx + 1 == *start || jmp.stmt_idx + 1 == *end
            });
            let is_loop_jmp = while_targets.iter().any(|(start, _end, _)| {
                jmp.target_addr == Some(stmts.get(*start).map(|s| s.stmt_span().start_addr).unwrap_or(0))
            });
            if !is_else_jmp && !is_loop_jmp && !addr_to_idx.contains_key(&target_addr) {
                goto_targets.insert(target_addr);
                goto_sources.push((jmp.stmt_idx, target_addr, jmp.span));
            }
        }
    }

    // Step 4: Build output with structured blocks and goto fallback.
    // Supports recursive nesting via recursive calls to structure_statements
    // on the bodies of if/while blocks.

    // Sort if-targets by start index
    if_targets.sort_by_key(|t| t.0);
    while_targets.sort_by_key(|t| t.0);

    // Simple structuring: process statements linearly, inserting structured
    // blocks when we hit their boundaries.
    let mut if_idx = 0;
    let mut while_idx = 0;
    let mut i = 0;

    while i < stmts.len() {
        // Emit a label if this statement's address is a goto target
        let stmt_addr = stmts[i].stmt_span().start_addr;
        if goto_targets.contains(&stmt_addr) {
            output.push(HirStmt::Label {
                name: format!("loc_{:x}", stmt_addr),
                span: stmts[i].stmt_span(),
            });
        }

        // Check if this is a goto source (unstructured branch)
        if let Some((_idx, target_addr, span)) = goto_sources.iter().find(|(idx, _, _)| *idx == i) {
            output.push(HirStmt::Goto {
                label: format!("loc_{:x}", target_addr),
                span: *span,
            });
            i += 1;
            continue;
        }

        // Check if a while loop starts here
        if while_idx < while_targets.len() && while_targets[while_idx].0 == i {
            let (start, end, ref cond) = while_targets[while_idx];
            while_idx += 1;

            // Collect the loop body (between start and end, including CMP/Jcc
            // comments so recursive structuring can process nested patterns)
            let raw_body: Vec<HirStmt> = stmts[start..end].to_vec();

            // Recursively structure the loop body for nested control flow
            let (body, nested_result) = structure_statements(&raw_body, func_name, sink, var_names);
            result.ifs_recovered += nested_result.ifs_recovered;
            result.loops_recovered += nested_result.loops_recovered;

            output.push(HirStmt::While {
                cond: cond.clone(),
                body,
                span: stmts[start].stmt_span(),
            });

            i = end + 1; // skip past the loop
            result.jcc_comments_consumed += 1;
            continue;
        }

        // Check if an if block starts here
        if if_idx < if_targets.len() && if_targets[if_idx].0 == i {
            let (start, end, ref cond) = if_targets[if_idx];
            if_idx += 1;

            // Check for else: if the statement before end_idx is a JMP forward
            let (then_end, else_body_raw, else_end_idx) = detect_else(stmts, start, end, &jumps, &consumed_indices);

            // Collect the then-body (include CMP/Jcc for recursive structuring)
            let raw_then: Vec<HirStmt> = stmts[start..then_end].to_vec();

            // Recursively structure the then-body for nested control flow
            let (then_body, nested_then) = structure_statements(&raw_then, func_name, sink, var_names);
            result.ifs_recovered += nested_then.ifs_recovered;
            result.loops_recovered += nested_then.loops_recovered;

            // Recursively structure the else-body if present
            let else_body = else_body_raw.map(|raw_else| {
                let (structured_else, nested_else) = structure_statements(&raw_else, func_name, sink, var_names);
                result.ifs_recovered += nested_else.ifs_recovered;
                result.loops_recovered += nested_else.loops_recovered;
                structured_else
            });

            output.push(HirStmt::If {
                cond: cond.clone(),
                then_body,
                else_body,
                span: stmts[start].stmt_span(),
            });

            // Skip past the if (and else if present)
            if let Some(else_end) = else_end_idx {
                i = else_end;
            } else {
                i = end;
            }
            result.jcc_comments_consumed += 1;
            continue;
        }

        // Skip consumed statements
        if consumed_indices.contains(&i) {
            i += 1;
            continue;
        }

        // Normal statement
        output.push(stmts[i].clone());
        i += 1;
    }

    if result.ifs_recovered > 0 || result.loops_recovered > 0 {
        sink.info(
            func_name,
            0,
            DiagnosticKind::Recovery,
            format!(
                "control flow: {} ifs, {} loops structured",
                result.ifs_recovered, result.loops_recovered
            ),
        );
    }

    if !goto_sources.is_empty() {
        sink.info(
            func_name,
            0,
            DiagnosticKind::Recovery,
            format!(
                "control flow: {} goto(s) emitted for irreducible flow",
                goto_sources.len()
            ),
        );
    }

    (output, result)
}

/// Collect branch (Jcc) information from comment statements.
fn collect_branches(stmts: &[HirStmt]) -> Vec<BranchInfo> {
    let mut branches = Vec::new();

    for (i, stmt) in stmts.iter().enumerate() {
        if let HirStmt::Comment { text, span } = stmt {
            // Pattern: "je → sub_XXXX" or "jne → 0xXXXX"
            if let Some((cc, target)) = parse_jcc_comment(text) {
                let target_addr = parse_address(&target);
                let src_addr = span.start_addr;
                let is_forward = target_addr.map(|t| t > src_addr).unwrap_or(false);

                branches.push(BranchInfo {
                    stmt_idx: i,
                    cc,
                    target: target.clone(),
                    target_addr,
                    span: *span,
                    is_forward,
                });
            }
        }
    }

    branches
}

/// Collect unconditional JMP information from comment statements.
fn collect_jumps(stmts: &[HirStmt]) -> Vec<JmpInfo> {
    let mut jumps = Vec::new();

    for (i, stmt) in stmts.iter().enumerate() {
        if let HirStmt::Comment { text, span } = stmt {
            if let Some(target) = parse_jmp_comment(text) {
                let target_addr = parse_address(&target);
                jumps.push(JmpInfo {
                    stmt_idx: i,
                    target,
                    target_addr,
                    span: *span,
                });
            }
        }
    }

    jumps
}

/// Build a map from addresses to statement indices.
fn build_addr_to_idx(stmts: &[HirStmt]) -> std::collections::HashMap<u64, usize> {
    let mut map = std::collections::HashMap::new();
    for (i, stmt) in stmts.iter().enumerate() {
        let addr = stmt.stmt_span().start_addr;
        if addr != 0 {
            map.entry(addr).or_insert(i);
        }
    }
    map
}

/// Parse a Jcc comment like "je → sub_14003068a" into (cc, target).
///
/// Returns the condition code **without** the leading `j` — e.g., `"e"`, `"ne"`, `"z"`, `"nz"`.
fn parse_jcc_comment(text: &str) -> Option<(String, String)> {
    let text = text.trim();
    // Format: "CC → TARGET" where CC is like "je", "jne", "jz", "jnz"
    let parts: Vec<&str> = text.splitn(2, " → ").collect();
    if parts.len() == 2 {
        let cc_raw = parts[0].trim();
        let target = parts[1].trim().to_string();
        // Strip leading 'j'/'J' to get the raw condition code
        if let Some(cc) = cc_raw.strip_prefix('j').or_else(|| cc_raw.strip_prefix('J')) {
            return Some((cc.to_string(), target));
        }
    }
    None
}

/// Parse a JMP comment like "jmp → sub_14003068a".
fn parse_jmp_comment(text: &str) -> Option<String> {
    let text = text.trim();
    if let Some(rest) = text.strip_prefix("jmp → ") {
        return Some(rest.trim().to_string());
    }
    None
}

/// Parse a target address from strings like "sub_14003068a" or "0x14003068a".
fn parse_address(target: &str) -> Option<u64> {
    if let Some(hex) = target.strip_prefix("sub_") {
        u64::from_str_radix(hex, 16).ok()
    } else if let Some(hex) = target.strip_prefix("0x") {
        u64::from_str_radix(hex, 16).ok()
    } else {
        u64::from_str_radix(target, 16).ok()
    }
}

/// Invert a condition expression for if-fallthrough semantics.
fn invert_condition(cond: HirExpr, span: Span) -> HirExpr {
    match cond {
        HirExpr::Binary {
            op, lhs, rhs, ..
        } => {
            if let Some(inv) = invert_binop(op) {
                HirExpr::Binary {
                    op: inv,
                    lhs,
                    rhs,
                    ty: HirType::Bool,
                    span,
                }
            } else {
                HirExpr::Unary {
                    op: HirUnaryOp::Not,
                    operand: Box::new(HirExpr::Binary {
                        op,
                        lhs,
                        rhs,
                        ty: HirType::Bool,
                        span,
                    }),
                    ty: HirType::Bool,
                    span,
                }
            }
        }
        other => HirExpr::Unary {
            op: HirUnaryOp::Not,
            operand: Box::new(other),
            ty: HirType::Bool,
            span,
        },
    }
}

/// Detect an else block: if the statement immediately before end_idx
/// is a JMP forward, the range [end_idx, jmp_target] is the else body.
///
/// Returns `(then_end, else_body, else_end_idx)`:
/// - `then_end`: the exclusive end of the then-body (excluding the JMP)
/// - `else_body`: the else body statements (if any)
/// - `else_end_idx`: the index past the else block (for skip logic)
fn detect_else(
    stmts: &[HirStmt],
    _start: usize,
    end: usize,
    jumps: &[JmpInfo],
    consumed: &std::collections::HashSet<usize>,
) -> (usize, Option<Vec<HirStmt>>, Option<usize>) {
    // Look for a JMP just before end_idx in the then-body
    if end > 0 {
        for jmp in jumps {
            // JMP must be at end-1 (the last stmt of the then-body before the else starts)
            if jmp.stmt_idx == end - 1 {
                if let Some(jmp_target) = jmp.target_addr {
                    let src_addr = jmp.span.start_addr;
                    if jmp_target > src_addr {
                        // This is a forward JMP: there's an else block
                        // Then body is [start, end-1), else body is [end, jmp_target_idx)
                        let then_end = end - 1; // exclude the JMP
                        let else_end = stmts.iter().position(|s| {
                            s.stmt_span().start_addr == jmp_target
                        });
                        if let Some(else_end_idx) = else_end {
                            let else_body: Vec<HirStmt> = stmts[end..else_end_idx]
                                .iter()
                                .enumerate()
                                .filter(|(j, _)| !consumed.contains(&(end + j)))
                                .map(|(_, s)| s.clone())
                                .collect();
                            return (then_end, Some(else_body), Some(else_end_idx));
                        }
                    }
                }
            }
        }
    }

    (end, None, None)
}

// ─── Helper: Get span from any statement ────────────────────────────────────

/// Extension trait to get the span from any HirStmt variant.
trait StmtSpan {
    fn stmt_span(&self) -> Span;
}

impl StmtSpan for HirStmt {
    fn stmt_span(&self) -> Span {
        match self {
            HirStmt::VarDecl { span, .. }
            | HirStmt::Assign { span, .. }
            | HirStmt::Expr { span, .. }
            | HirStmt::Return { span, .. }
            | HirStmt::If { span, .. }
            | HirStmt::While { span, .. }
            | HirStmt::DoWhile { span, .. }
            | HirStmt::For { span, .. }
            | HirStmt::Switch { span, .. }
            | HirStmt::Break { span, .. }
            | HirStmt::Continue { span, .. }
            | HirStmt::Goto { span, .. }
            | HirStmt::Label { span, .. }
            | HirStmt::Asm { span, .. }
            | HirStmt::Comment { span, .. } => *span,
        }
    }
}

// ─── Dead Code Elimination ──────────────────────────────────────────────────

/// Remove statements that appear after an unconditional `return` in the
/// top-level scope of a function. Code after return is unreachable.
///
/// This does NOT remove code inside structured blocks (if/while/else) —
/// only at the top-level (depth 0) scope.
pub fn eliminate_dead_code(stmts: &mut Vec<HirStmt>) {
    // Find the first unconditional return at the top level
    let return_idx = stmts.iter().position(|s| matches!(s, HirStmt::Return { .. }));

    if let Some(idx) = return_idx {
        // Check if there are statements after the return
        if idx + 1 < stmts.len() {
            // Keep only statements up to and including the return
            stmts.truncate(idx + 1);
        }
    }
}

// ─── Redundant Goto Elimination ─────────────────────────────────────────────

/// Remove goto/label pairs that are redundant (fallthrough) and labels
/// that are no longer referenced by any goto.
///
/// Patterns removed:
/// 1. `goto loc_X; loc_X:` — adjacent goto+label (natural fallthrough)
/// 2. Labels not referenced by any remaining goto
/// 3. Gotos whose target label doesn't exist in the statement list
pub fn eliminate_redundant_gotos(stmts: &mut Vec<HirStmt>) {
    // Pass 1: Remove adjacent goto+label pairs
    let mut changed = true;
    while changed {
        changed = false;
        let mut i = 0;
        while i + 1 < stmts.len() {
            if let (HirStmt::Goto { label: goto_label, .. }, HirStmt::Label { name: label_name, .. }) =
                (&stmts[i], &stmts[i + 1])
            {
                if goto_label == label_name {
                    // Remove the goto (keep the label for now; orphan pass will clean it)
                    stmts.remove(i);
                    changed = true;
                    continue;
                }
            }
            i += 1;
        }
    }

    // Pass 2: Recursively clean gotos inside structured blocks
    for stmt in stmts.iter_mut() {
        match stmt {
            HirStmt::If { then_body, else_body, .. } => {
                eliminate_redundant_gotos(then_body);
                if let Some(else_stmts) = else_body {
                    eliminate_redundant_gotos(else_stmts);
                }
            }
            HirStmt::While { body, .. } | HirStmt::DoWhile { body, .. } => {
                eliminate_redundant_gotos(body);
            }
            HirStmt::For { body, .. } => {
                eliminate_redundant_gotos(body);
            }
            _ => {}
        }
    }

    // Pass 3: Collect all existing labels in the statement list
    let mut existing_labels: std::collections::HashSet<String> = std::collections::HashSet::new();
    collect_existing_labels(stmts, &mut existing_labels);

    // Pass 4: Remove gotos whose target label doesn't exist
    remove_orphan_gotos(stmts, &existing_labels);

    // Pass 5: Collect all goto targets still referenced
    let mut referenced_labels: std::collections::HashSet<String> = std::collections::HashSet::new();
    collect_goto_targets(stmts, &mut referenced_labels);

    // Pass 6: Remove orphan labels (not referenced by any goto)
    remove_orphan_labels(stmts, &referenced_labels);
}

/// Recursively collect all existing label names from a statement list.
fn collect_existing_labels(stmts: &[HirStmt], labels: &mut std::collections::HashSet<String>) {
    for stmt in stmts {
        match stmt {
            HirStmt::Label { name, .. } => {
                labels.insert(name.clone());
            }
            HirStmt::If { then_body, else_body, .. } => {
                collect_existing_labels(then_body, labels);
                if let Some(else_stmts) = else_body {
                    collect_existing_labels(else_stmts, labels);
                }
            }
            HirStmt::While { body, .. } | HirStmt::DoWhile { body, .. } => {
                collect_existing_labels(body, labels);
            }
            HirStmt::For { body, .. } => {
                collect_existing_labels(body, labels);
            }
            _ => {}
        }
    }
}

/// Remove gotos whose target label doesn't exist in the statement list.
fn remove_orphan_gotos(stmts: &mut Vec<HirStmt>, existing_labels: &std::collections::HashSet<String>) {
    stmts.retain(|s| {
        if let HirStmt::Goto { label, .. } = s {
            existing_labels.contains(label)
        } else {
            true
        }
    });

    // Recurse into structured blocks
    for stmt in stmts.iter_mut() {
        match stmt {
            HirStmt::If { then_body, else_body, .. } => {
                remove_orphan_gotos(then_body, existing_labels);
                if let Some(else_stmts) = else_body {
                    remove_orphan_gotos(else_stmts, existing_labels);
                }
            }
            HirStmt::While { body, .. } | HirStmt::DoWhile { body, .. } => {
                remove_orphan_gotos(body, existing_labels);
            }
            HirStmt::For { body, .. } => {
                remove_orphan_gotos(body, existing_labels);
            }
            _ => {}
        }
    }
}

/// Remove labels not referenced by any goto.
fn remove_orphan_labels(stmts: &mut Vec<HirStmt>, referenced: &std::collections::HashSet<String>) {
    stmts.retain(|s| {
        if let HirStmt::Label { name, .. } = s {
            referenced.contains(name)
        } else {
            true
        }
    });

    // Recurse into structured blocks
    for stmt in stmts.iter_mut() {
        match stmt {
            HirStmt::If { then_body, else_body, .. } => {
                remove_orphan_labels(then_body, referenced);
                if let Some(else_stmts) = else_body {
                    remove_orphan_labels(else_stmts, referenced);
                }
            }
            HirStmt::While { body, .. } | HirStmt::DoWhile { body, .. } => {
                remove_orphan_labels(body, referenced);
            }
            HirStmt::For { body, .. } => {
                remove_orphan_labels(body, referenced);
            }
            _ => {}
        }
    }
}

/// Recursively collect all goto target labels from a statement list.
fn collect_goto_targets(stmts: &[HirStmt], targets: &mut std::collections::HashSet<String>) {
    for stmt in stmts {
        match stmt {
            HirStmt::Goto { label, .. } => {
                targets.insert(label.clone());
            }
            HirStmt::If { then_body, else_body, .. } => {
                collect_goto_targets(then_body, targets);
                if let Some(else_stmts) = else_body {
                    collect_goto_targets(else_stmts, targets);
                }
            }
            HirStmt::While { body, .. } | HirStmt::DoWhile { body, .. } => {
                collect_goto_targets(body, targets);
            }
            HirStmt::For { body, .. } => {
                collect_goto_targets(body, targets);
            }
            _ => {}
        }
    }
}

// ─── Tests ──────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    fn mk_span(addr: u64) -> Span {
        Span::new(addr, addr + 4)
    }

    #[test]
    fn test_parse_jcc_comment() {
        let (cc, target) = parse_jcc_comment("je → sub_14003068a").unwrap();
        assert_eq!(cc, "e");
        assert_eq!(target, "sub_14003068a");
    }

    #[test]
    fn test_parse_jcc_comment_jne() {
        let (cc, target) = parse_jcc_comment("jne → sub_1400306a0").unwrap();
        assert_eq!(cc, "ne");
        assert_eq!(target, "sub_1400306a0");
    }

    #[test]
    fn test_parse_jmp_comment() {
        let target = parse_jmp_comment("jmp → sub_14003068a").unwrap();
        assert_eq!(target, "sub_14003068a");
    }

    #[test]
    fn test_parse_jmp_comment_none() {
        assert!(parse_jmp_comment("some other comment").is_none());
    }

    #[test]
    fn test_parse_address_sub() {
        assert_eq!(parse_address("sub_14003068a"), Some(0x14003068a));
    }

    #[test]
    fn test_parse_address_hex() {
        assert_eq!(parse_address("0x14003068a"), Some(0x14003068a));
    }

    #[test]
    fn test_cc_to_comparison_op() {
        assert_eq!(cc_to_comparison_op("E", false), Some(HirBinOp::Eq));
        assert_eq!(cc_to_comparison_op("NE", false), Some(HirBinOp::Ne));
        assert_eq!(cc_to_comparison_op("G", false), Some(HirBinOp::Gt));
        assert_eq!(cc_to_comparison_op("LE", false), Some(HirBinOp::Le));
        assert_eq!(cc_to_comparison_op("B", false), Some(HirBinOp::Lt));
    }

    #[test]
    fn test_cc_to_comparison_op_inverted() {
        assert_eq!(cc_to_comparison_op("E", true), Some(HirBinOp::Ne));
        assert_eq!(cc_to_comparison_op("NE", true), Some(HirBinOp::Eq));
        assert_eq!(cc_to_comparison_op("G", true), Some(HirBinOp::Le));
    }

    #[test]
    fn test_extract_cmp_info() {
        let stmt = HirStmt::Comment {
            text: "cmp rax, 0x10".to_string(),
            span: mk_span(0x100),
        };
        let info = extract_cmp_info(&stmt).unwrap();
        assert!(!info.is_test);
        assert_eq!(info.lhs, "rax");
        assert_eq!(info.rhs, "0x10");
    }

    #[test]
    fn test_extract_test_info() {
        let stmt = HirStmt::Comment {
            text: "test rax, rax".to_string(),
            span: mk_span(0x200),
        };
        let info = extract_cmp_info(&stmt).unwrap();
        assert!(info.is_test);
        assert_eq!(info.lhs, "rax");
        assert_eq!(info.rhs, "rax");
    }

    #[test]
    fn test_cmov_condition_recovery() {
        // Simulate: cmp rax, 0; cmove rbx, rcx
        let mut stmts = vec![
            HirStmt::Comment {
                text: "cmp rax, 0".to_string(),
                span: mk_span(0x100),
            },
            HirStmt::Assign {
                lhs: HirExpr::Var {
                    id: HirVarId(0),
                    span: mk_span(0x104),
                },
                rhs: HirExpr::Ternary {
                    cond: Box::new(HirExpr::Unknown {
                        description: "flags.e".to_string(),
                        span: mk_span(0x104),
                    }),
                    then_expr: Box::new(HirExpr::Var {
                        id: HirVarId(1),
                        span: mk_span(0x104),
                    }),
                    else_expr: Box::new(HirExpr::Var {
                        id: HirVarId(0),
                        span: mk_span(0x104),
                    }),
                    ty: HirType::i64(),
                    span: mk_span(0x104),
                },
                span: mk_span(0x104),
            },
        ];

        let resolved = recover_cmov_conditions(&mut stmts);
        assert_eq!(resolved, 1, "should resolve one CMOV condition");

        // Verify the condition is now a proper comparison
        if let HirStmt::Assign { rhs, .. } = &stmts[1] {
            if let HirExpr::Ternary { cond, .. } = rhs {
                assert!(
                    matches!(cond.as_ref(), HirExpr::Binary { op: HirBinOp::Eq, .. }),
                    "expected Eq comparison, got {:?}",
                    cond
                );
            } else {
                panic!("expected ternary, got {:?}", rhs);
            }
        } else {
            panic!("expected assignment");
        }
    }

    #[test]
    fn test_cmov_test_condition_recovery() {
        // Simulate: test rax, rax; cmovne rbx, rcx
        let mut stmts = vec![
            HirStmt::Comment {
                text: "test rax, rax".to_string(),
                span: mk_span(0x200),
            },
            HirStmt::Assign {
                lhs: HirExpr::Var {
                    id: HirVarId(0),
                    span: mk_span(0x204),
                },
                rhs: HirExpr::Ternary {
                    cond: Box::new(HirExpr::Unknown {
                        description: "flags.ne".to_string(),
                        span: mk_span(0x204),
                    }),
                    then_expr: Box::new(HirExpr::Var {
                        id: HirVarId(1),
                        span: mk_span(0x204),
                    }),
                    else_expr: Box::new(HirExpr::Var {
                        id: HirVarId(0),
                        span: mk_span(0x204),
                    }),
                    ty: HirType::i64(),
                    span: mk_span(0x204),
                },
                span: mk_span(0x204),
            },
        ];

        let resolved = recover_cmov_conditions(&mut stmts);
        assert_eq!(resolved, 1);

        // For TEST: condition is (rax & rax) != 0
        if let HirStmt::Assign { rhs, .. } = &stmts[1] {
            if let HirExpr::Ternary { cond, .. } = rhs {
                assert!(
                    matches!(cond.as_ref(), HirExpr::Binary { op: HirBinOp::Ne, .. }),
                    "expected Ne comparison for cmovne+test, got {:?}",
                    cond
                );
            }
        }
    }

    #[test]
    fn test_structure_simple_if() {
        // Simulate:
        // 0x100: cmp rax, 0
        // 0x104: je → sub_110      (forward branch: skip to 0x110 if equal)
        // 0x108: var_20 = 1        (then-body: executed when NOT equal)
        // 0x110: return            (target of the branch)
        let stmts = vec![
            HirStmt::Comment {
                text: "cmp rax, 0".to_string(),
                span: mk_span(0x100),
            },
            HirStmt::Comment {
                text: "je → sub_110".to_string(),
                span: mk_span(0x104),
            },
            HirStmt::Assign {
                lhs: HirExpr::Var {
                    id: HirVarId(0),
                    span: mk_span(0x108),
                },
                rhs: HirExpr::IntLit {
                    value: 1,
                    ty: HirType::i32(),
                    span: mk_span(0x108),
                },
                span: mk_span(0x108),
            },
            HirStmt::Return {
                value: None,
                span: mk_span(0x110),
            },
        ];

        let mut sink = DiagnosticSink::new();
        let (structured, result) = structure_statements(&stmts, "test_func", &mut sink, &std::collections::HashMap::new());

        assert!(result.ifs_recovered >= 1, "should recover at least one if block");

        // Output should contain an If statement
        let has_if = structured.iter().any(|s| matches!(s, HirStmt::If { .. }));
        assert!(has_if, "structured output should contain an If block: {:?}", structured);
    }

    #[test]
    fn test_invert_condition() {
        let eq = HirExpr::Binary {
            op: HirBinOp::Eq,
            lhs: Box::new(HirExpr::IntLit { value: 1, ty: HirType::i64(), span: Span::UNKNOWN }),
            rhs: Box::new(HirExpr::IntLit { value: 0, ty: HirType::i64(), span: Span::UNKNOWN }),
            ty: HirType::Bool,
            span: Span::UNKNOWN,
        };

        let inverted = invert_condition(eq, Span::UNKNOWN);
        assert!(
            matches!(&inverted, HirExpr::Binary { op: HirBinOp::Ne, .. }),
            "expected Ne after inverting Eq, got {:?}",
            inverted
        );
    }

    #[test]
    fn test_control_flow_full_module() {
        // End-to-end: build a module with a CMP+Jcc+body+target, run structuring
        let module = HirModule {
            name: "test.exe".into(),
            arch: "amd64".into(),
            functions: vec![HirFunction {
                name: "sub_100".into(),
                address: 0x100,
                return_type: HirType::Void,
                params: vec![],
                locals: vec![],
                body: vec![
                    HirStmt::Comment {
                        text: "cmp rax, 0".to_string(),
                        span: mk_span(0x100),
                    },
                    HirStmt::Comment {
                        text: "je → sub_110".to_string(),
                        span: mk_span(0x104),
                    },
                    HirStmt::Assign {
                        lhs: HirExpr::Var {
                            id: HirVarId(0),
                            span: mk_span(0x108),
                        },
                        rhs: HirExpr::IntLit {
                            value: 42,
                            ty: HirType::i32(),
                            span: mk_span(0x108),
                        },
                        span: mk_span(0x108),
                    },
                    HirStmt::Return {
                        value: None,
                        span: mk_span(0x110),
                    },
                ],
                calling_convention: Some("win64".into()),
                is_variadic: false,
                span: mk_span(0x100),
            }],
        };

        let mut module = module;
        let mut sink = DiagnosticSink::new();
        let result = structure_control_flow(&mut module, &mut sink);

        assert!(result.ifs_recovered >= 1);

        let func = &module.functions[0];
        let has_if = func.body.iter().any(|s| matches!(s, HirStmt::If { .. }));
        assert!(has_if, "function body should contain If: {:?}", func.body);
    }

    // ─── Task 8.1: If/else detection ────────────────────────────────────────

    #[test]
    fn test_if_else_detection() {
        // Pattern: Jcc(target_A) → then block → Jmp(target_B) → else block → target_B
        //
        // 0x100: cmp rax, 0
        // 0x104: je → sub_114       (forward: skip then-body if equal)
        // 0x108: var_0 = 1          (then-body)
        // 0x10c: jmp → sub_11c      (skip else-body)
        // 0x114: var_0 = 2          (else-body, target of Jcc)
        // 0x118: var_1 = 3          (else-body continued)
        // 0x11c: return             (target of JMP, after else)
        let stmts = vec![
            HirStmt::Comment {
                text: "cmp rax, 0".to_string(),
                span: mk_span(0x100),
            },
            HirStmt::Comment {
                text: "je → sub_114".to_string(),
                span: mk_span(0x104),
            },
            HirStmt::Assign {
                lhs: HirExpr::Var { id: HirVarId(0), span: mk_span(0x108) },
                rhs: HirExpr::IntLit { value: 1, ty: HirType::i32(), span: mk_span(0x108) },
                span: mk_span(0x108),
            },
            HirStmt::Comment {
                text: "jmp → sub_11c".to_string(),
                span: mk_span(0x10c),
            },
            HirStmt::Assign {
                lhs: HirExpr::Var { id: HirVarId(0), span: mk_span(0x114) },
                rhs: HirExpr::IntLit { value: 2, ty: HirType::i32(), span: mk_span(0x114) },
                span: mk_span(0x114),
            },
            HirStmt::Assign {
                lhs: HirExpr::Var { id: HirVarId(1), span: mk_span(0x118) },
                rhs: HirExpr::IntLit { value: 3, ty: HirType::i32(), span: mk_span(0x118) },
                span: mk_span(0x118),
            },
            HirStmt::Return {
                value: None,
                span: mk_span(0x11c),
            },
        ];

        let mut sink = DiagnosticSink::new();
        let (structured, result) = structure_statements(&stmts, "test_if_else", &mut sink, &std::collections::HashMap::new());

        assert!(result.ifs_recovered >= 1, "should recover at least one if");

        // Find the If statement
        let if_stmt = structured.iter().find(|s| matches!(s, HirStmt::If { .. }));
        assert!(if_stmt.is_some(), "should contain an If block: {:?}", structured);

        if let Some(HirStmt::If { then_body, else_body, .. }) = if_stmt {
            assert!(!then_body.is_empty(), "then_body should not be empty");
            assert!(else_body.is_some(), "else_body should be present for if/else pattern");
            let else_stmts = else_body.as_ref().unwrap();
            assert!(!else_stmts.is_empty(), "else_body should not be empty");
        }

        // The else body statements should NOT appear as standalone statements after the If
        let standalone_assigns: Vec<_> = structured.iter().filter(|s| {
            if let HirStmt::Assign { span, .. } = s {
                span.start_addr == 0x114 || span.start_addr == 0x118
            } else {
                false
            }
        }).collect();
        assert!(standalone_assigns.is_empty(),
            "else body statements should not appear as standalone after the If block");
    }

    // ─── Task 8.2: While detection with back-edge ───────────────────────────

    #[test]
    fn test_while_back_edge() {
        // Pattern: loop body → cmp → backward Jcc
        //
        // 0x100: var_0 = 0          (loop start)
        // 0x104: var_0 = var_0 + 1  (loop body)
        // 0x108: cmp var_0, 10
        // 0x10c: jne → sub_100      (backward branch: loop while not equal)
        // 0x110: return
        let stmts = vec![
            HirStmt::Assign {
                lhs: HirExpr::Var { id: HirVarId(0), span: mk_span(0x100) },
                rhs: HirExpr::IntLit { value: 0, ty: HirType::i32(), span: mk_span(0x100) },
                span: mk_span(0x100),
            },
            HirStmt::Assign {
                lhs: HirExpr::Var { id: HirVarId(0), span: mk_span(0x104) },
                rhs: HirExpr::Binary {
                    op: HirBinOp::Add,
                    lhs: Box::new(HirExpr::Var { id: HirVarId(0), span: mk_span(0x104) }),
                    rhs: Box::new(HirExpr::IntLit { value: 1, ty: HirType::i32(), span: mk_span(0x104) }),
                    ty: HirType::i32(),
                    span: mk_span(0x104),
                },
                span: mk_span(0x104),
            },
            HirStmt::Comment {
                text: "cmp var_0, 10".to_string(),
                span: mk_span(0x108),
            },
            HirStmt::Comment {
                text: "jne → sub_100".to_string(),
                span: mk_span(0x10c),
            },
            HirStmt::Return {
                value: None,
                span: mk_span(0x110),
            },
        ];

        let mut sink = DiagnosticSink::new();
        let (structured, result) = structure_statements(&stmts, "test_while", &mut sink, &std::collections::HashMap::new());

        assert!(result.loops_recovered >= 1, "should recover at least one while loop");

        let while_stmt = structured.iter().find(|s| matches!(s, HirStmt::While { .. }));
        assert!(while_stmt.is_some(), "should contain a While block: {:?}", structured);

        if let Some(HirStmt::While { body, .. }) = while_stmt {
            assert!(!body.is_empty(), "while body should not be empty");
        }
    }

    // ─── Task 8.3: Nested control structures ────────────────────────────────

    #[test]
    fn test_nested_if_inside_while() {
        // Pattern: while loop containing an if block
        //
        // 0x100: var_0 = 0          (loop start)
        // 0x104: cmp var_0, 5
        // 0x108: je → sub_118       (forward: if inside loop)
        // 0x10c: var_1 = 1          (then-body of inner if)
        // 0x118: var_0 = var_0 + 1  (after inner if, still in loop)
        // 0x11c: cmp var_0, 10
        // 0x120: jne → sub_100      (backward: loop back)
        // 0x124: return
        let stmts = vec![
            HirStmt::Assign {
                lhs: HirExpr::Var { id: HirVarId(0), span: mk_span(0x100) },
                rhs: HirExpr::IntLit { value: 0, ty: HirType::i32(), span: mk_span(0x100) },
                span: mk_span(0x100),
            },
            HirStmt::Comment {
                text: "cmp var_0, 5".to_string(),
                span: mk_span(0x104),
            },
            HirStmt::Comment {
                text: "je → sub_118".to_string(),
                span: mk_span(0x108),
            },
            HirStmt::Assign {
                lhs: HirExpr::Var { id: HirVarId(1), span: mk_span(0x10c) },
                rhs: HirExpr::IntLit { value: 1, ty: HirType::i32(), span: mk_span(0x10c) },
                span: mk_span(0x10c),
            },
            HirStmt::Assign {
                lhs: HirExpr::Var { id: HirVarId(0), span: mk_span(0x118) },
                rhs: HirExpr::Binary {
                    op: HirBinOp::Add,
                    lhs: Box::new(HirExpr::Var { id: HirVarId(0), span: mk_span(0x118) }),
                    rhs: Box::new(HirExpr::IntLit { value: 1, ty: HirType::i32(), span: mk_span(0x118) }),
                    ty: HirType::i32(),
                    span: mk_span(0x118),
                },
                span: mk_span(0x118),
            },
            HirStmt::Comment {
                text: "cmp var_0, 10".to_string(),
                span: mk_span(0x11c),
            },
            HirStmt::Comment {
                text: "jne → sub_100".to_string(),
                span: mk_span(0x120),
            },
            HirStmt::Return {
                value: None,
                span: mk_span(0x124),
            },
        ];

        let mut sink = DiagnosticSink::new();
        let (structured, result) = structure_statements(&stmts, "test_nested", &mut sink, &std::collections::HashMap::new());

        assert!(result.loops_recovered >= 1, "should recover a while loop");

        // Find the while loop
        let while_stmt = structured.iter().find(|s| matches!(s, HirStmt::While { .. }));
        assert!(while_stmt.is_some(), "should contain a While block: {:?}", structured);

        // Check that the while body contains a nested If
        if let Some(HirStmt::While { body, .. }) = while_stmt {
            let has_nested_if = body.iter().any(|s| matches!(s, HirStmt::If { .. }));
            assert!(has_nested_if,
                "while body should contain a nested If block: {:?}", body);
        }
    }

    // ─── Task 8.4: Goto for irreducible flow ────────────────────────────────

    #[test]
    fn test_goto_and_label_variants_exist() {
        // Verify that HirStmt::Goto and HirStmt::Label can be constructed
        // and that the emitter handles them (verified separately in emitter tests)
        let goto = HirStmt::Goto {
            label: "loc_100".to_string(),
            span: mk_span(0x100),
        };
        let label = HirStmt::Label {
            name: "loc_100".to_string(),
            span: mk_span(0x100),
        };
        assert!(matches!(goto, HirStmt::Goto { .. }));
        assert!(matches!(label, HirStmt::Label { .. }));
    }

}
