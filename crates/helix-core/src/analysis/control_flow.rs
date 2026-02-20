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

    // Phase 1: Recover CMOV conditions from CMP/TEST comments
    result.cmov_conditions_resolved = recover_cmov_conditions(&mut func.body);

    // Phase 2: Structure Jcc/JMP into if/while
    let (new_body, cf_result) = structure_statements(&func.body, &func.name, sink);
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
fn recover_cmov_conditions(stmts: &mut Vec<HirStmt>) -> usize {
    let mut resolved = 0;

    // First, collect CMP/TEST info from comments
    let cmp_info: Vec<Option<CmpInfo>> = stmts
        .iter()
        .map(|s| extract_cmp_info(s))
        .collect();

    // Now scan for CMOVs and resolve their conditions
    for i in 0..stmts.len() {
        if let HirStmt::Assign { rhs, span, .. } = &stmts[i] {
            if let HirExpr::Ternary { cond, .. } = rhs {
                if let HirExpr::Unknown { description, .. } = cond.as_ref() {
                    if description.starts_with("flags.") {
                        let cc = &description[6..]; // e.g., "e", "ne", "b", etc.

                        // Look backward for nearest CMP/TEST
                        if let Some(info) = find_preceding_cmp(&cmp_info, i) {
                            let cond_expr = build_condition_expr(
                                cc,
                                &info,
                                *span,
                            );

                            // Replace the ternary's condition
                            if let HirStmt::Assign { rhs, .. } = &mut stmts[i] {
                                if let HirExpr::Ternary { cond, .. } = rhs {
                                    *cond = Box::new(cond_expr);
                                    resolved += 1;
                                }
                            }
                        }
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
    /// Right-hand operand string (empty for TEST with single arg = "lhs, lhs").
    rhs: String,
    /// Span of the original CMP/TEST.
    #[allow(dead_code)]
    span: Span,
}

/// Try to extract CMP/TEST information from a comment statement.
fn extract_cmp_info(stmt: &HirStmt) -> Option<CmpInfo> {
    if let HirStmt::Comment { text, span } = stmt {
        let text = text.trim();
        if let Some(rest) = text.strip_prefix("cmp ") {
            let parts: Vec<&str> = rest.splitn(2, ", ").collect();
            if parts.len() == 2 {
                return Some(CmpInfo {
                    is_test: false,
                    lhs: parts[0].trim().to_string(),
                    rhs: parts[1].trim().to_string(),
                    span: *span,
                });
            }
        } else if let Some(rest) = text.strip_prefix("test ") {
            let parts: Vec<&str> = rest.splitn(2, ", ").collect();
            if parts.len() == 2 {
                return Some(CmpInfo {
                    is_test: true,
                    lhs: parts[0].trim().to_string(),
                    rhs: parts[1].trim().to_string(),
                    span: *span,
                });
            }
        }
    }
    None
}

/// Find the nearest preceding CMP/TEST info before index `before`.
fn find_preceding_cmp(cmp_info: &[Option<CmpInfo>], before: usize) -> Option<CmpInfo> {
    let mut j = before;
    while j > 0 {
        j -= 1;
        if let Some(info) = &cmp_info[j] {
            return Some(info.clone());
        }
        // Don't look too far back — CMP/TEST should be close to CMOV
        if before - j > 10 {
            break;
        }
    }
    None
}

/// Build a condition expression from a condition code and CMP/TEST info.
fn build_condition_expr(cc: &str, info: &CmpInfo, span: Span) -> HirExpr {
    let lhs = parse_operand_expr(&info.lhs, span);

    if info.is_test {
        // TEST sets ZF based on (lhs & rhs). Common pattern: TEST reg, reg → checks if zero.
        let lhs_str = &info.lhs;
        let rhs_str = &info.rhs;

        if lhs_str == rhs_str {
            // TEST reg, reg → simplify to "reg op 0" (common idiom)
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
            // TEST with different operands → (lhs & rhs) op 0
            let rhs_expr = parse_operand_expr(rhs_str, span);
            let and_expr = HirExpr::Binary {
                op: HirBinOp::BitAnd,
                lhs: Box::new(lhs),
                rhs: Box::new(rhs_expr),
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
        // CMP: direct comparison
        let rhs = parse_operand_expr(&info.rhs, span);
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

/// Parse a textual operand (from a comment) into an HirExpr.
fn parse_operand_expr(text: &str, span: Span) -> HirExpr {
    let text = text.trim();

    // Try to parse as hex immediate
    if let Some(hex) = text.strip_prefix("0x") {
        if let Ok(v) = i64::from_str_radix(hex, 16) {
            return HirExpr::IntLit {
                value: v,
                ty: HirType::i64(),
                span,
            };
        }
    }

    // Try to parse as decimal immediate
    if let Ok(v) = text.parse::<i64>() {
        return HirExpr::IntLit {
            value: v,
            ty: HirType::i64(),
            span,
        };
    }

    // Memory operand: [reg + 0xNN]
    if text.starts_with('[') && text.ends_with(']') {
        return HirExpr::Unknown {
            description: text.to_string(),
            span,
        };
    }

    // Register — treat as an unknown variable reference with descriptive name
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
        if br.stmt_idx > 0 {
            if extract_cmp_info(&stmts[br.stmt_idx - 1]).is_some() {
                consumed_indices.insert(br.stmt_idx - 1);
            }
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
                        build_condition_expr(&br.cc, info, br.span)
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
                        build_condition_expr(&br.cc, info, br.span)
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

    // Step 4: Build output with simple single-level structuring.
    // For a robust multi-level approach we'd need a proper interval tree,
    // but this handles the common single-level if/while patterns well.

    // Sort if-targets by start index
    if_targets.sort_by_key(|t| t.0);
    while_targets.sort_by_key(|t| t.0);

    // Simple structuring: process statements linearly, inserting structured
    // blocks when we hit their boundaries.
    let mut if_idx = 0;
    let mut while_idx = 0;
    let mut i = 0;

    while i < stmts.len() {
        // Check if a while loop starts here
        if while_idx < while_targets.len() && while_targets[while_idx].0 == i {
            let (start, end, ref cond) = while_targets[while_idx];
            while_idx += 1;

            // Collect the loop body (between start and end, excluding consumed)
            let body: Vec<HirStmt> = stmts[start..end]
                .iter()
                .enumerate()
                .filter(|(j, _)| !consumed_indices.contains(&(start + j)))
                .map(|(_, s)| s.clone())
                .collect();

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
            let (then_end, else_body) = detect_else(stmts, start, end, &jumps, &consumed_indices);

            // Collect the then-body
            let then_body: Vec<HirStmt> = stmts[start..then_end]
                .iter()
                .enumerate()
                .filter(|(j, _)| !consumed_indices.contains(&(start + j)))
                .map(|(_, s)| s.clone())
                .collect();

            output.push(HirStmt::If {
                cond: cond.clone(),
                then_body,
                else_body,
                span: stmts[start].stmt_span(),
            });

            // Skip past the if (and else if present)
            if let Some(else_end) = detect_else_end(&jumps, end) {
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
fn detect_else(
    stmts: &[HirStmt],
    _start: usize,
    end: usize,
    jumps: &[JmpInfo],
    consumed: &std::collections::HashSet<usize>,
) -> (usize, Option<Vec<HirStmt>>) {
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
                            return (then_end, Some(else_body));
                        }
                    }
                }
            }
        }
    }

    (end, None)
}

/// Find the end index of an else block if one exists.
fn detect_else_end(jumps: &[JmpInfo], if_end: usize) -> Option<usize> {
    for jmp in jumps {
        if jmp.stmt_idx == if_end - 1 {
            if let Some(target) = jmp.target_addr {
                if target > jmp.span.start_addr {
                    // The else block ends at the JMP target
                    // We don't know the exact index without rescanning, but
                    // the caller should handle this
                    return None; // TODO: proper else-end resolution
                }
            }
        }
    }
    None
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
        let (structured, result) = structure_statements(&stmts, "test_func", &mut sink);

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
}
