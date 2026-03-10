//! Win64 Calling Convention Analysis for the HIR Pipeline.
//!
//! This pass runs over `HirFunction` bodies to:
//!
//! 1. **Recover call arguments**: Scan backward from each `CALL` to find
//!    register writes to RCX, RDX, R8, R9 (the Win64 integer argument
//!    registers). Fold the written values into the call's `args` list.
//!
//! 2. **Eliminate consumed arg-setup statements**: Remove register writes
//!    that were only setting up call arguments (the "consumed" set from
//!    the original pipeline).
//!
//! 3. **Recover call results**: If RAX is read after a call before being
//!    redefined, replace the raw `rax` variable reference with a fresh
//!    named variable (`v0`, `v1`, …) and type it from the signature DB.
//!
//! 4. **Mark unused results**: If RAX is not consumed after a call,
//!    convert the assignment into a bare expression statement (void call).
//!
//! 5. **Hide stack bookkeeping**: Remove `push`/`pop` comments and
//!    register-only assignments that are pure prologue/epilogue noise.

use std::collections::{HashMap, HashSet};

use crate::ir::hir::*;
use crate::signatures::SignatureDb;

/// The four Win64 integer argument registers, in order.
const WIN64_ARG_REGS: [&str; 4] = ["rcx", "rdx", "r8", "r9"];

/// Result of the calling convention pass.
#[derive(Debug, Clone)]
pub struct CallingConventionResult {
    /// Number of calls whose arguments were recovered.
    pub calls_recovered: usize,
    /// Total arguments recovered across all calls.
    pub args_recovered: usize,
    /// Number of arg-setup statements eliminated.
    pub stmts_eliminated: usize,
    /// Number of call results named.
    pub results_named: usize,
}

/// Run the Win64 calling convention analysis on an entire `HirModule`.
pub fn recover_calling_convention(
    module: &mut HirModule,
    signatures: &SignatureDb,
) -> CallingConventionResult {
    let mut result = CallingConventionResult {
        calls_recovered: 0,
        args_recovered: 0,
        stmts_eliminated: 0,
        results_named: 0,
    };

    for func in &mut module.functions {
        let r = recover_function_calls(func, signatures);
        result.calls_recovered += r.calls_recovered;
        result.args_recovered += r.args_recovered;
        result.stmts_eliminated += r.stmts_eliminated;
        result.results_named += r.results_named;
    }

    result
}

/// Recover calling convention information for a single function.
///
/// Uses a single forward pass with register-value tracking (like the
/// original transform pipeline) to correctly propagate call results
/// through subsequent argument setups.
fn recover_function_calls(
    func: &mut HirFunction,
    signatures: &SignatureDb,
) -> CallingConventionResult {
    let mut result = CallingConventionResult {
        calls_recovered: 0,
        args_recovered: 0,
        stmts_eliminated: 0,
        results_named: 0,
    };

    // Build a mapping from HirVarId → variable name for register lookup
    let var_names: HashMap<HirVarId, String> = func
        .locals
        .iter()
        .chain(func.params.iter())
        .map(|v| (v.id, v.name.clone()))
        .collect();

    // Pre-compute which statements are consumed (arg setup) for each call
    let call_indices = find_call_indices(&func.body);
    let mut consumed_indices: HashSet<usize> = HashSet::new();
    let mut call_arg_consumed: HashMap<usize, Vec<usize>> = HashMap::new();

    for &call_idx in &call_indices {
        let consumed = mark_consumed_for_call(&func.body, call_idx, &var_names);
        consumed_indices.extend(consumed.iter());
        call_arg_consumed.insert(call_idx, consumed);
    }

    // Pre-compute result usage for each call
    let mut call_result_used: HashMap<usize, bool> = HashMap::new();
    for &call_idx in &call_indices {
        call_result_used.insert(call_idx, is_result_used(&func.body, call_idx, &var_names));
    }

    // ── Forward Pass with Register State Tracking ──
    //
    // We track what each register variable currently holds using a value
    // abstraction similar to the original pipeline's RegVal.
    let mut reg_state: HashMap<HirVarId, RegValue> = HashMap::new();
    let mut fresh_regs: HashSet<HirVarId> = HashSet::new();

    let mut new_body: Vec<HirStmt> = Vec::with_capacity(func.body.len());
    let mut var_counter: u32 = 0;
    let mut new_result_vars: Vec<HirVar> = Vec::new();

    for (i, stmt) in func.body.iter().enumerate() {
        // Skip consumed arg-setup instructions
        if consumed_indices.contains(&i) {
            result.stmts_eliminated += 1;
            // But still track the register state for this instruction
            update_reg_state(stmt, &var_names, &mut reg_state, &mut fresh_regs);
            continue;
        }

        // Skip push/pop comments (prologue/epilogue noise)
        if is_prologue_comment(stmt) {
            result.stmts_eliminated += 1;
            continue;
        }

        // Handle CALL statements
        if call_indices.contains(&i) {
            if let HirStmt::Assign {
                lhs,
                rhs:
                    HirExpr::Call {
                        target,
                        ret_ty,
                        span,
                        ..
                    },
                span: stmt_span,
            } = stmt
            {
                // Collect arguments from register state
                let args = collect_args_from_state(&reg_state, &fresh_regs, &var_names);
                let used = call_result_used.get(&i).copied().unwrap_or(false);

                // Resolve return type from signature
                let sig_ret_ty = resolve_call_return_type(target, signatures);
                let effective_ret = if sig_ret_ty != HirType::Unknown {
                    sig_ret_ty.clone()
                } else if *ret_ty != HirType::Unknown {
                    ret_ty.clone()
                } else {
                    // Default: if result is used, assume void* (common for Win64)
                    if used {
                        HirType::void_ptr()
                    } else {
                        HirType::Void
                    }
                };

                if !args.is_empty() {
                    result.calls_recovered += 1;
                    result.args_recovered += args.len();
                }

                let new_call = HirExpr::Call {
                    target: target.clone(),
                    args,
                    ret_ty: effective_ret.clone(),
                    span: *span,
                };

                if used && effective_ret != HirType::Void {
                    // Create a named result variable with descriptive name
                    let result_name = derive_result_name(target, signatures, var_counter);
                    var_counter += 1;

                    let result_var_id = HirVarId(1000 + result.results_named as u32);
                    result.results_named += 1;

                    new_result_vars.push(HirVar {
                        id: result_var_id,
                        name: result_name.clone(),
                        ty: effective_ret.clone(),
                        storage: HirStorage::Temporary,
                        span: *stmt_span,
                    });

                    // Update register state: RAX now holds this call result
                    if let HirExpr::Var { id: rax_id, .. } = lhs {
                        reg_state.insert(
                            *rax_id,
                            RegValue::NamedResult(result_var_id, result_name.clone()),
                        );
                    }

                    new_body.push(HirStmt::Assign {
                        lhs: HirExpr::Var {
                            id: result_var_id,
                            span: *stmt_span,
                        },
                        rhs: new_call,
                        span: *stmt_span,
                    });
                } else {
                    // Void call or unused result
                    if let HirExpr::Var { id: rax_id, .. } = lhs {
                        reg_state.remove(rax_id);
                    }
                    new_body.push(HirStmt::Expr {
                        expr: new_call,
                        span: *stmt_span,
                    });
                }

                // Clear "fresh" flags after a call
                fresh_regs.clear();
                continue;
            }
        }

        // For non-call statements: resolve register references from state,
        // then update state for this instruction.
        let resolved_stmt = resolve_stmt_from_state(stmt, &reg_state, &var_names);
        update_reg_state(stmt, &var_names, &mut reg_state, &mut fresh_regs);
        new_body.push(resolved_stmt);
    }

    // Phase 2: Remove dead register-only assignments
    let final_body = eliminate_dead_register_stmts(new_body, &var_names, &new_result_vars);

    func.body = final_body;
    func.locals.extend(new_result_vars);

    result
}

// ─── Register Value Tracking ────────────────────────────────────────────────

/// Abstraction for what a register variable currently holds.
#[derive(Debug, Clone)]
enum RegValue {
    /// A known integer constant.
    Constant(i64),
    /// Address of a local variable.
    AddrOfLocal(HirVarId),
    /// The result of a previous call, with a named variable.
    NamedResult(HirVarId, String),
    /// The raw expression assigned to this register.
    Expr(HirExpr),
}

/// Update register state based on a statement.
fn update_reg_state(
    stmt: &HirStmt,
    var_names: &HashMap<HirVarId, String>,
    state: &mut HashMap<HirVarId, RegValue>,
    fresh: &mut HashSet<HirVarId>,
) {
    if let HirStmt::Assign {
        lhs: HirExpr::Var { id, .. },
        rhs,
        ..
    } = stmt
    {
        if let Some(name) = var_names.get(id) {
            // Only track register variables (not stack locals)
            if !name.starts_with("var_") {
                let val = match rhs {
                    HirExpr::IntLit { value, .. } => RegValue::Constant(*value),
                    HirExpr::Unary {
                        op: HirUnaryOp::AddressOf,
                        operand,
                        ..
                    } => {
                        if let HirExpr::Var { id: inner_id, .. } = operand.as_ref() {
                            RegValue::AddrOfLocal(*inner_id)
                        } else {
                            RegValue::Expr(rhs.clone())
                        }
                    }
                    HirExpr::Var { id: src_id, .. } => {
                        // Propagate: if source register holds a named result, propagate it
                        if let Some(existing) = state.get(src_id) {
                            existing.clone()
                        } else {
                            RegValue::Expr(rhs.clone())
                        }
                    }
                    _ => RegValue::Expr(rhs.clone()),
                };
                state.insert(*id, val);
                fresh.insert(*id);
            }
        }
    }
}

/// Collect call arguments from the current register state.
fn collect_args_from_state(
    state: &HashMap<HirVarId, RegValue>,
    fresh: &HashSet<HirVarId>,
    var_names: &HashMap<HirVarId, String>,
) -> Vec<HirExpr> {
    // Build reverse map: register name → var_id
    let name_to_id: HashMap<&str, HirVarId> = var_names
        .iter()
        .map(|(id, name)| (name.as_str(), *id))
        .collect();

    let mut args = Vec::new();
    for reg in &WIN64_ARG_REGS {
        if let Some(&var_id) = name_to_id.get(reg) {
            if fresh.contains(&var_id) {
                if let Some(val) = state.get(&var_id) {
                    args.push(reg_value_to_expr(val, var_names));
                } else {
                    break;
                }
            } else {
                break;
            }
        } else {
            break;
        }
    }
    args
}

/// Convert a register value to an HIR expression.
fn reg_value_to_expr(val: &RegValue, _var_names: &HashMap<HirVarId, String>) -> HirExpr {
    match val {
        RegValue::Constant(v) => HirExpr::IntLit {
            value: *v,
            ty: HirType::i64(),
            span: Span::UNKNOWN,
        },
        RegValue::AddrOfLocal(id) => HirExpr::Unary {
            op: HirUnaryOp::AddressOf,
            operand: Box::new(HirExpr::Var {
                id: *id,
                span: Span::UNKNOWN,
            }),
            ty: HirType::void_ptr(),
            span: Span::UNKNOWN,
        },
        RegValue::NamedResult(id, _name) => HirExpr::Var {
            id: *id,
            span: Span::UNKNOWN,
        },
        RegValue::Expr(expr) => expr.clone(),
    }
}

/// Resolve register variable references in a non-call statement using
/// the current register state (substituting named results, constants, etc.).
fn resolve_stmt_from_state(
    stmt: &HirStmt,
    state: &HashMap<HirVarId, RegValue>,
    var_names: &HashMap<HirVarId, String>,
) -> HirStmt {
    match stmt {
        HirStmt::Assign { lhs, rhs, span } => {
            let new_rhs = resolve_expr_from_state(rhs, state, var_names);
            HirStmt::Assign {
                lhs: lhs.clone(),
                rhs: new_rhs,
                span: *span,
            }
        }
        HirStmt::Expr { expr, span } => HirStmt::Expr {
            expr: resolve_expr_from_state(expr, state, var_names),
            span: *span,
        },
        HirStmt::Return {
            value: Some(expr),
            span,
        } => HirStmt::Return {
            value: Some(resolve_expr_from_state(expr, state, var_names)),
            span: *span,
        },
        _ => stmt.clone(),
    }
}

/// Resolve register references in an expression using state tracking.
/// Substitutes named results and known constants from register state
/// to produce cleaner output.
fn resolve_expr_from_state(
    expr: &HirExpr,
    state: &HashMap<HirVarId, RegValue>,
    var_names: &HashMap<HirVarId, String>,
) -> HirExpr {
    match expr {
        HirExpr::Var { id, span } => {
            if let Some(name) = var_names.get(id) {
                if !name.starts_with("var_") {
                    // Check what this register currently holds
                    if let Some(val) = state.get(id) {
                        match val {
                            RegValue::NamedResult(result_id, _) => {
                                return HirExpr::Var {
                                    id: *result_id,
                                    span: *span,
                                };
                            }
                            RegValue::Constant(v) => {
                                return HirExpr::IntLit {
                                    value: *v,
                                    ty: HirType::i64(),
                                    span: *span,
                                };
                            }
                            RegValue::AddrOfLocal(local_id) => {
                                return HirExpr::Unary {
                                    op: HirUnaryOp::AddressOf,
                                    operand: Box::new(HirExpr::Var {
                                        id: *local_id,
                                        span: *span,
                                    }),
                                    ty: HirType::void_ptr(),
                                    span: *span,
                                };
                            }
                            // For raw expressions, only substitute if simple enough
                            RegValue::Expr(e) => {
                                if is_simple_expr(e) {
                                    return e.clone();
                                }
                            }
                        }
                    }
                }
            }
            expr.clone()
        }
        HirExpr::Binary {
            op,
            lhs,
            rhs,
            ty,
            span,
        } => HirExpr::Binary {
            op: *op,
            lhs: Box::new(resolve_expr_from_state(lhs, state, var_names)),
            rhs: Box::new(resolve_expr_from_state(rhs, state, var_names)),
            ty: ty.clone(),
            span: *span,
        },
        HirExpr::Unary {
            op,
            operand,
            ty,
            span,
        } => HirExpr::Unary {
            op: *op,
            operand: Box::new(resolve_expr_from_state(operand, state, var_names)),
            ty: ty.clone(),
            span: *span,
        },
        HirExpr::Cast { expr, to_ty, span } => HirExpr::Cast {
            expr: Box::new(resolve_expr_from_state(expr, state, var_names)),
            to_ty: to_ty.clone(),
            span: *span,
        },
        _ => expr.clone(),
    }
}

// ─── Consumed Statement Marking ─────────────────────────────────────────────

/// Mark statements consumed as argument setup for a call at `call_idx`.
/// Returns the indices of consumed statements.
fn mark_consumed_for_call(
    body: &[HirStmt],
    call_idx: usize,
    var_names: &HashMap<HirVarId, String>,
) -> Vec<usize> {
    let mut consumed = Vec::new();
    let mut j = call_idx;

    while j > 0 {
        j -= 1;
        let stmt = &body[j];

        if is_boundary(stmt) {
            break;
        }

        if let HirStmt::Assign {
            lhs: HirExpr::Var { id, .. },
            ..
        } = stmt
        {
            if let Some(name) = var_names.get(id) {
                let lower = name.to_lowercase();
                if WIN64_ARG_REGS.contains(&lower.as_str()) {
                    consumed.push(j);
                }
            }
        }

        if is_stack_adjustment(stmt, var_names) {
            break;
        }
    }

    consumed
}

// ─── Call Site Identification ───────────────────────────────────────────────

/// Find indices of statements that contain a Call expression.
fn find_call_indices(body: &[HirStmt]) -> Vec<usize> {
    body.iter()
        .enumerate()
        .filter(|(_, stmt)| {
            matches!(
                stmt,
                HirStmt::Assign {
                    rhs: HirExpr::Call { .. },
                    ..
                } | HirStmt::Expr {
                    expr: HirExpr::Call { .. },
                    ..
                }
            )
        })
        .map(|(i, _)| i)
        .collect()
}

/// Check if a statement is a boundary that stops backward arg scanning.
fn is_boundary(stmt: &HirStmt) -> bool {
    matches!(
        stmt,
        HirStmt::Assign {
            rhs: HirExpr::Call { .. },
            ..
        } | HirStmt::Expr {
            expr: HirExpr::Call { .. },
            ..
        } | HirStmt::Return { .. }
            | HirStmt::If { .. }
            | HirStmt::While { .. }
            | HirStmt::Switch { .. }
            | HirStmt::Break { .. }
            | HirStmt::Continue { .. }
            | HirStmt::Goto { .. }
            | HirStmt::Label { .. }
    )
}

/// Check if a statement is a stack frame adjustment (sub rsp, N).
fn is_stack_adjustment(stmt: &HirStmt, var_names: &HashMap<HirVarId, String>) -> bool {
    if let HirStmt::Assign {
        lhs: HirExpr::Var { id, .. },
        rhs:
            HirExpr::Binary {
                op: HirBinOp::Sub,
                lhs: bin_lhs,
                rhs: bin_rhs,
                ..
            },
        ..
    } = stmt
    {
        if let Some(name) = var_names.get(id) {
            if name.to_lowercase() == "rsp" {
                if let HirExpr::Var { id: lhs_id, .. } = bin_lhs.as_ref() {
                    if lhs_id == id && matches!(bin_rhs.as_ref(), HirExpr::IntLit { .. }) {
                        return true;
                    }
                }
            }
        }
    }
    false
}

// ─── Result Usage Analysis ──────────────────────────────────────────────────

/// Check if RAX is read after the call at `call_idx` before being redefined.
fn is_result_used(
    body: &[HirStmt],
    call_idx: usize,
    var_names: &HashMap<HirVarId, String>,
) -> bool {
    // Get the RAX var_id from the call's LHS
    let rax_id = match &body[call_idx] {
        HirStmt::Assign {
            lhs: HirExpr::Var { id, .. },
            ..
        } => {
            if var_names.get(id).map(|n| n.to_lowercase()) == Some("rax".to_string()) {
                *id
            } else {
                return false;
            }
        }
        _ => return false,
    };

    // Scan forward
    for stmt in body.iter().skip(call_idx + 1) {
        if stmt_reads_var(stmt, rax_id) {
            return true;
        }
        if stmt_defines_var(stmt, rax_id) {
            return false;
        }
        // Stop at next call or return
        if matches!(
            stmt,
            HirStmt::Assign {
                rhs: HirExpr::Call { .. },
                ..
            } | HirStmt::Expr {
                expr: HirExpr::Call { .. },
                ..
            } | HirStmt::Return { .. }
        ) {
            return false;
        }
    }

    false
}

/// Check if a statement reads a particular variable.
fn stmt_reads_var(stmt: &HirStmt, target_id: HirVarId) -> bool {
    match stmt {
        HirStmt::Assign { rhs, .. } => expr_references_var(rhs, target_id),
        HirStmt::Expr { expr, .. } => expr_references_var(expr, target_id),
        HirStmt::Return {
            value: Some(expr), ..
        } => expr_references_var(expr, target_id),
        _ => false,
    }
}

/// Check if a statement defines (writes to) a particular variable.
fn stmt_defines_var(stmt: &HirStmt, target_id: HirVarId) -> bool {
    match stmt {
        HirStmt::Assign {
            lhs: HirExpr::Var { id, .. },
            ..
        } => *id == target_id,
        HirStmt::VarDecl { var_id, .. } => *var_id == target_id,
        _ => false,
    }
}

/// Check if an expression references a particular variable anywhere in its tree.
fn expr_references_var(expr: &HirExpr, target_id: HirVarId) -> bool {
    match expr {
        HirExpr::Var { id, .. } => *id == target_id,
        HirExpr::Binary { lhs, rhs, .. } => {
            expr_references_var(lhs, target_id) || expr_references_var(rhs, target_id)
        }
        HirExpr::Unary { operand, .. } => expr_references_var(operand, target_id),
        HirExpr::Cast { expr, .. } => expr_references_var(expr, target_id),
        HirExpr::Call { target, args, .. } => {
            expr_references_var(target, target_id)
                || args.iter().any(|a| expr_references_var(a, target_id))
        }
        HirExpr::Subscript { base, index, .. } => {
            expr_references_var(base, target_id) || expr_references_var(index, target_id)
        }
        HirExpr::FieldAccess { expr, .. } => expr_references_var(expr, target_id),
        HirExpr::DerefFieldAccess { expr, .. } => expr_references_var(expr, target_id),
        HirExpr::Ternary {
            cond,
            then_expr,
            else_expr,
            ..
        } => {
            expr_references_var(cond, target_id)
                || expr_references_var(then_expr, target_id)
                || expr_references_var(else_expr, target_id)
        }
        _ => false,
    }
}

// ─── Call Return Type Resolution ────────────────────────────────────────────

/// Resolve the return type of a call target using the signature database.
fn resolve_call_return_type(target: &HirExpr, signatures: &SignatureDb) -> HirType {
    if let HirExpr::AddrLit { address, .. } = target {
        if let Some(sig) = signatures.lookup(*address) {
            return crate::analysis::type_propagation::parse_c_type_name(&sig.return_type);
        }
    }
    HirType::Unknown
}

// ─── RAX Substitution ───────────────────────────────────────────────────────

// NOTE: RAX substitution is now handled inline by the forward-pass
// state tracking in `recover_function_calls`. The old `substitute_rax_refs`
// and `substitute_expr` functions have been removed.

// ─── Dead Register Elimination ──────────────────────────────────────────────

/// Remove statements that only assign to register variables which are never
/// read in any visible output (stack stores, calls, returns).
fn eliminate_dead_register_stmts(
    body: Vec<HirStmt>,
    var_names: &HashMap<HirVarId, String>,
    result_vars: &[HirVar],
) -> Vec<HirStmt> {
    // Build combined name map including new result vars
    let mut all_names = var_names.clone();
    for v in result_vars {
        all_names.insert(v.id, v.name.clone());
    }

    // Collect the set of var IDs that are actually read in the body
    let mut read_ids: HashSet<HirVarId> = HashSet::new();

    for stmt in &body {
        collect_read_vars(stmt, &mut read_ids);
    }

    // Keep statements that either:
    // - Write to a non-register variable (stack, param, temp, result)
    // - Write to a register that is actually read
    // - Have side effects (calls)
    // - Read from memory (POP pattern: reg = *rsp)
    // - Are not pure register assignments
    body.into_iter()
        .filter(|stmt| {
            if let HirStmt::Assign {
                lhs: HirExpr::Var { id, .. },
                rhs,
                ..
            } = stmt
            {
                if let Some(name) = all_names.get(id) {
                    let lower = name.to_lowercase();
                    // Always keep stack variables and named result variables
                    if lower.starts_with("var_") || lower.starts_with("v") {
                        return true;
                    }
                    // Keep if the register is read somewhere
                    if read_ids.contains(id) {
                        return true;
                    }
                    // Keep if the RHS has side effects (calls)
                    if has_side_effects(rhs) {
                        return true;
                    }
                    // Keep if the RHS reads from memory (e.g., POP: reg = *rsp).
                    // These represent meaningful data flow from the stack and
                    // should be visible in decompiled output.
                    if rhs_reads_memory(rhs) {
                        return true;
                    }
                    // Pure register-to-register bookkeeping — remove
                    return false;
                }
            }
            true
        })
        .collect()
}

/// Collect all variable IDs that are read (used as operands) in a statement.
fn collect_read_vars(stmt: &HirStmt, out: &mut HashSet<HirVarId>) {
    match stmt {
        HirStmt::Assign { lhs, rhs, .. } => {
            // LHS dereference reads the base
            collect_read_vars_from_lhs(lhs, out);
            collect_read_vars_from_expr(rhs, out);
        }
        HirStmt::Expr { expr, .. } => {
            collect_read_vars_from_expr(expr, out);
        }
        HirStmt::Return {
            value: Some(expr), ..
        } => {
            collect_read_vars_from_expr(expr, out);
        }
        HirStmt::If {
            cond,
            then_body,
            else_body,
            ..
        } => {
            collect_read_vars_from_expr(cond, out);
            for s in then_body {
                collect_read_vars(s, out);
            }
            if let Some(else_stmts) = else_body {
                for s in else_stmts {
                    collect_read_vars(s, out);
                }
            }
        }
        HirStmt::While { cond, body, .. } => {
            collect_read_vars_from_expr(cond, out);
            for s in body {
                collect_read_vars(s, out);
            }
        }
        _ => {}
    }
}

/// For LHS expressions, collect variables that are *read* (e.g., pointer dereference).
fn collect_read_vars_from_lhs(expr: &HirExpr, out: &mut HashSet<HirVarId>) {
    match expr {
        HirExpr::Unary { operand, .. } => {
            // *ptr reads ptr; &var reads var
            collect_read_vars_from_expr(operand, out);
        }
        HirExpr::Binary { lhs, rhs, .. } => {
            collect_read_vars_from_expr(lhs, out);
            collect_read_vars_from_expr(rhs, out);
        }
        // Simple Var on LHS = definition, don't add to reads
        HirExpr::Var { .. } => {}
        _ => {}
    }
}

/// Collect all variable IDs referenced in an expression.
fn collect_read_vars_from_expr(expr: &HirExpr, out: &mut HashSet<HirVarId>) {
    match expr {
        HirExpr::Var { id, .. } => {
            out.insert(*id);
        }
        HirExpr::Binary { lhs, rhs, .. } => {
            collect_read_vars_from_expr(lhs, out);
            collect_read_vars_from_expr(rhs, out);
        }
        HirExpr::Unary { operand, .. } => {
            collect_read_vars_from_expr(operand, out);
        }
        HirExpr::Cast { expr, .. } => {
            collect_read_vars_from_expr(expr, out);
        }
        HirExpr::Call { target, args, .. } => {
            collect_read_vars_from_expr(target, out);
            for a in args {
                collect_read_vars_from_expr(a, out);
            }
        }
        HirExpr::Subscript { base, index, .. } => {
            collect_read_vars_from_expr(base, out);
            collect_read_vars_from_expr(index, out);
        }
        HirExpr::FieldAccess { expr, .. } => {
            collect_read_vars_from_expr(expr, out);
        }
        HirExpr::DerefFieldAccess { expr, .. } => {
            collect_read_vars_from_expr(expr, out);
        }
        HirExpr::Ternary {
            cond,
            then_expr,
            else_expr,
            ..
        } => {
            collect_read_vars_from_expr(cond, out);
            collect_read_vars_from_expr(then_expr, out);
            collect_read_vars_from_expr(else_expr, out);
        }
        _ => {}
    }
}

/// Check if an expression has side effects (e.g., function call).
fn has_side_effects(expr: &HirExpr) -> bool {
    match expr {
        HirExpr::Call { .. } => true,
        HirExpr::Binary { lhs, rhs, .. } => has_side_effects(lhs) || has_side_effects(rhs),
        HirExpr::Unary { operand, .. } => has_side_effects(operand),
        HirExpr::Cast { expr, .. } => has_side_effects(expr),
        _ => false,
    }
}

/// Check if an expression reads from memory (e.g., `*rsp` from a POP).
/// These assignments should be preserved even if the destination register
/// is never read again, because they represent meaningful data flow.
fn rhs_reads_memory(expr: &HirExpr) -> bool {
    match expr {
        HirExpr::Unary {
            op: HirUnaryOp::Deref,
            ..
        } => true,
        HirExpr::Subscript { .. } => true,
        HirExpr::Binary { lhs, rhs, .. } => rhs_reads_memory(lhs) || rhs_reads_memory(rhs),
        HirExpr::Cast { expr, .. } => rhs_reads_memory(expr),
        _ => false,
    }
}

// ─── Helpers ────────────────────────────────────────────────────────────────

/// Check if a statement is a prologue/epilogue comment (push/pop).
fn is_prologue_comment(stmt: &HirStmt) -> bool {
    if let HirStmt::Comment { text, .. } = stmt {
        let lower = text.to_lowercase();
        lower.starts_with("push ") || lower.starts_with("pop ")
    } else {
        false
    }
}

/// Derive a descriptive name for a call result variable based on the call target.
///
/// - Known signature → abbreviated name (e.g., `result_CreateFile`)
/// - Unknown target → `result_` + last 4 hex digits of address (e.g., `result_bf18`)
/// - Fallback → `v{counter}`
fn derive_result_name(target: &HirExpr, signatures: &SignatureDb, counter: u32) -> String {
    if let HirExpr::AddrLit { address, .. } = target {
        if let Some(sig) = signatures.lookup(*address) {
            // Use abbreviated function name
            let name = &sig.name;
            // Truncate long names
            let short = if name.len() > 16 { &name[..16] } else { name };
            return format!("result_{}", short);
        }
        // Use last 4 hex digits of address
        let suffix = format!("{:x}", address);
        let short_suffix = if suffix.len() > 4 {
            &suffix[suffix.len() - 4..]
        } else {
            &suffix
        };
        return format!("result_{}", short_suffix);
    }
    // Fallback
    format!("v{}", counter)
}

/// Check if an expression is simple enough to inline when substituting.
fn is_simple_expr(expr: &HirExpr) -> bool {
    matches!(
        expr,
        HirExpr::IntLit { .. } | HirExpr::AddrLit { .. } | HirExpr::Var { .. }
    )
}

// ─── Tests ──────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    fn mk_reg_var(id: u32, name: &str) -> HirVar {
        HirVar {
            id: HirVarId(id),
            name: name.to_string(),
            ty: HirType::i64(),
            storage: HirStorage::Register,
            span: Span::single(0x100),
        }
    }

    fn mk_stack_var(id: u32, name: &str, offset: i64) -> HirVar {
        HirVar {
            id: HirVarId(id),
            name: name.to_string(),
            ty: HirType::i32(),
            storage: HirStorage::Stack(offset),
            span: Span::single(0x100),
        }
    }

    fn mk_assign_reg(var_id: u32, value: i64) -> HirStmt {
        HirStmt::Assign {
            lhs: HirExpr::Var {
                id: HirVarId(var_id),
                span: Span::single(0x100),
            },
            rhs: HirExpr::IntLit {
                value,
                ty: HirType::i64(),
                span: Span::single(0x100),
            },
            span: Span::single(0x100),
        }
    }

    fn mk_call_stmt(target_addr: u64, result_var_id: u32) -> HirStmt {
        HirStmt::Assign {
            lhs: HirExpr::Var {
                id: HirVarId(result_var_id),
                span: Span::single(0x200),
            },
            rhs: HirExpr::Call {
                target: Box::new(HirExpr::AddrLit {
                    address: target_addr,
                    span: Span::single(0x200),
                }),
                args: vec![],
                ret_ty: HirType::Unknown,
                span: Span::single(0x200),
            },
            span: Span::single(0x200),
        }
    }

    #[test]
    fn recovers_win64_args() {
        // rcx=0, rdx=1, r8=2, rax=3
        let mut func = HirFunction {
            name: "sub_100".into(),
            address: 0x100,
            return_type: HirType::Void,
            params: vec![],
            locals: vec![
                mk_reg_var(0, "rcx"),
                mk_reg_var(1, "rdx"),
                mk_reg_var(2, "r8"),
                mk_reg_var(3, "rax"),
            ],
            body: vec![
                // rcx = 10
                mk_assign_reg(0, 10),
                // rdx = 20
                mk_assign_reg(1, 20),
                // r8 = 30
                mk_assign_reg(2, 30),
                // rax = call sub_1000()
                mk_call_stmt(0x1000, 3),
                // return
                HirStmt::Return {
                    value: None,
                    span: Span::single(0x300),
                },
            ],
            calling_convention: Some("win64".into()),
            is_variadic: false,
            span: Span::single(0x100),
        };

        let sigs = SignatureDb::new();
        let result = recover_function_calls(&mut func, &sigs);

        assert_eq!(result.calls_recovered, 1, "should recover 1 call");
        assert_eq!(
            result.args_recovered, 3,
            "should recover 3 args (rcx, rdx, r8)"
        );
        assert!(
            result.stmts_eliminated >= 3,
            "should eliminate arg-setup stmts"
        );

        // The call should now have args
        let has_call_with_args = func.body.iter().any(|s| {
            if let HirStmt::Expr {
                expr: HirExpr::Call { args, .. },
                ..
            } = s
            {
                args.len() == 3
            } else if let HirStmt::Assign {
                rhs: HirExpr::Call { args, .. },
                ..
            } = s
            {
                args.len() == 3
            } else {
                false
            }
        });
        assert!(has_call_with_args, "call should have 3 args in the output");
    }

    #[test]
    fn result_used_creates_named_var() {
        // rax=0, rcx=1
        let mut func = HirFunction {
            name: "sub_200".into(),
            address: 0x200,
            return_type: HirType::Void,
            params: vec![],
            locals: vec![
                mk_reg_var(0, "rax"),
                mk_reg_var(1, "rcx"),
                mk_stack_var(2, "var_20", 0x20),
            ],
            body: vec![
                // rax = call sub_1000()
                mk_call_stmt(0x1000, 0),
                // var_20 = rax (reads RAX → result is used)
                HirStmt::Assign {
                    lhs: HirExpr::Var {
                        id: HirVarId(2),
                        span: Span::single(0x210),
                    },
                    rhs: HirExpr::Var {
                        id: HirVarId(0),
                        span: Span::single(0x210),
                    },
                    span: Span::single(0x210),
                },
                HirStmt::Return {
                    value: None,
                    span: Span::single(0x300),
                },
            ],
            calling_convention: Some("win64".into()),
            is_variadic: false,
            span: Span::single(0x200),
        };

        let sigs = SignatureDb::new();
        let result = recover_function_calls(&mut func, &sigs);

        assert_eq!(result.results_named, 1, "should create 1 named result");

        // Should have a new local variable with descriptive name
        let has_result = func.locals.iter().any(|v| v.name.starts_with("result_"));
        assert!(
            has_result,
            "should have result_ var in locals: {:?}",
            func.locals.iter().map(|v| &v.name).collect::<Vec<_>>()
        );
    }

    #[test]
    fn void_call_becomes_expr_stmt() {
        // rax=0
        let mut func = HirFunction {
            name: "sub_300".into(),
            address: 0x300,
            return_type: HirType::Void,
            params: vec![],
            locals: vec![mk_reg_var(0, "rax")],
            body: vec![
                mk_call_stmt(0x1000, 0),
                // RAX not read → result unused
                HirStmt::Return {
                    value: None,
                    span: Span::single(0x400),
                },
            ],
            calling_convention: Some("win64".into()),
            is_variadic: false,
            span: Span::single(0x300),
        };

        let sigs = SignatureDb::new();
        let _result = recover_function_calls(&mut func, &sigs);

        // Should be an Expr statement, not an Assign
        let has_expr_call = func.body.iter().any(|s| {
            matches!(
                s,
                HirStmt::Expr {
                    expr: HirExpr::Call { .. },
                    ..
                }
            )
        });
        assert!(
            has_expr_call,
            "unused result should become Expr stmt: {:?}",
            func.body
        );
    }

    #[test]
    fn prologue_comments_hidden() {
        let mut func = HirFunction {
            name: "sub_400".into(),
            address: 0x400,
            return_type: HirType::Void,
            params: vec![],
            locals: vec![],
            body: vec![
                HirStmt::Comment {
                    text: "push rbx".into(),
                    span: Span::single(0x400),
                },
                HirStmt::Comment {
                    text: "pop rbx".into(),
                    span: Span::single(0x410),
                },
                HirStmt::Return {
                    value: None,
                    span: Span::single(0x420),
                },
            ],
            calling_convention: Some("win64".into()),
            is_variadic: false,
            span: Span::single(0x400),
        };

        let sigs = SignatureDb::new();
        let result = recover_function_calls(&mut func, &sigs);

        assert_eq!(result.stmts_eliminated, 2, "push/pop should be eliminated");
        assert_eq!(func.body.len(), 1, "only return should remain");
    }

    #[test]
    fn call_result_forwarded_to_next_call() {
        // rax=0, rcx=1
        // rax = call sub_1000()     → v0 = sub_1000()
        // rcx = rax                 → consumed (arg setup)
        // call sub_2000(rcx)        → sub_2000(v0)
        let mut func = HirFunction {
            name: "sub_500".into(),
            address: 0x500,
            return_type: HirType::Void,
            params: vec![],
            locals: vec![mk_reg_var(0, "rax"), mk_reg_var(1, "rcx")],
            body: vec![
                // rax = call sub_1000()
                mk_call_stmt(0x1000, 0),
                // rcx = rax (forward call result)
                HirStmt::Assign {
                    lhs: HirExpr::Var {
                        id: HirVarId(1),
                        span: Span::single(0x510),
                    },
                    rhs: HirExpr::Var {
                        id: HirVarId(0),
                        span: Span::single(0x510),
                    },
                    span: Span::single(0x510),
                },
                // rax = call sub_2000(rcx)
                mk_call_stmt(0x2000, 0),
                HirStmt::Return {
                    value: None,
                    span: Span::single(0x600),
                },
            ],
            calling_convention: Some("win64".into()),
            is_variadic: false,
            span: Span::single(0x500),
        };

        let sigs = SignatureDb::new();
        let result = recover_function_calls(&mut func, &sigs);

        // Should recover args: sub_2000(v0)
        assert!(result.args_recovered >= 1, "should recover at least 1 arg");

        // The second call should have the first call's result as its argument
        let call_with_result_arg = func.body.iter().any(|s| match s {
            HirStmt::Expr {
                expr: HirExpr::Call { args, .. },
                ..
            } => args
                .iter()
                .any(|a| matches!(a, HirExpr::Var { id, .. } if id.0 >= 1000)),
            HirStmt::Assign {
                rhs: HirExpr::Call { args, .. },
                ..
            } => args
                .iter()
                .any(|a| matches!(a, HirExpr::Var { id, .. } if id.0 >= 1000)),
            _ => false,
        });
        assert!(call_with_result_arg, "second call should have v0 as arg");
    }

    #[test]
    fn module_level_recovery() {
        let mut module = HirModule {
            name: "test.exe".into(),
            arch: "amd64".into(),
            functions: vec![HirFunction {
                name: "sub_100".into(),
                address: 0x100,
                return_type: HirType::Void,
                params: vec![],
                locals: vec![mk_reg_var(0, "rcx"), mk_reg_var(1, "rax")],
                body: vec![
                    mk_assign_reg(0, 42),
                    mk_call_stmt(0x1000, 1),
                    HirStmt::Return {
                        value: None,
                        span: Span::single(0x200),
                    },
                ],
                calling_convention: Some("win64".into()),
                is_variadic: false,
                span: Span::single(0x100),
            }],
        };

        let sigs = SignatureDb::new();
        let result = recover_calling_convention(&mut module, &sigs);

        assert!(result.calls_recovered >= 1);
        assert!(result.args_recovered >= 1);
    }
}
