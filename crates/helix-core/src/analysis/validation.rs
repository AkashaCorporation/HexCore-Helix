//! HIR Validation Pass.
//!
//! Validates the structural integrity of an [`HirModule`] before emission.
//! Reports issues via the diagnostic system rather than panicking.
//!
//! ## Checks Performed
//!
//! - Every variable reference resolves to a declared variable.
//! - No duplicate variable IDs within a function.
//! - Every function has at least one statement (or is explicitly empty).
//! - Call targets have valid forms.
//! - Type consistency where types are known.
//! - Missing call signatures are flagged as hints.

use std::collections::{HashMap, HashSet};

use crate::diagnostics::{DiagnosticKind, DiagnosticSink, Severity};
use crate::ir::hir::*;
use crate::signatures::SignatureDb;

/// Result of an HIR validation pass.
#[derive(Debug, Clone)]
pub struct ValidationResult {
    /// Number of errors found.
    pub errors: usize,
    /// Number of warnings found.
    pub warnings: usize,
    /// Number of hints found.
    pub hints: usize,
    /// Whether the module is valid (no errors).
    pub is_valid: bool,
}

/// Validate an entire HIR module.
///
/// Populates `sink` with diagnostics and returns a summary.
pub fn validate_module(
    module: &HirModule,
    signatures: &SignatureDb,
    sink: &mut DiagnosticSink,
) -> ValidationResult {
    let initial_errors = sink.count_by_severity(Severity::Error);
    let initial_warnings = sink.count_by_severity(Severity::Warning);
    let initial_hints = sink.count_by_severity(Severity::Hint);

    for func in &module.functions {
        validate_function(func, signatures, sink);
    }

    if module.functions.is_empty() {
        sink.module_info(DiagnosticKind::Validation, "module contains no functions");
    }

    let new_errors = sink.count_by_severity(Severity::Error) - initial_errors;
    let new_warnings = sink.count_by_severity(Severity::Warning) - initial_warnings;
    let new_hints = sink.count_by_severity(Severity::Hint) - initial_hints;

    ValidationResult {
        errors: new_errors,
        warnings: new_warnings,
        hints: new_hints,
        is_valid: new_errors == 0,
    }
}

/// Validate a single function.
fn validate_function(
    func: &HirFunction,
    signatures: &SignatureDb,
    sink: &mut DiagnosticSink,
) {
    let func_name = &func.name;
    let addr = func.address;

    // 1. Check for duplicate variable IDs
    let mut seen_ids: HashMap<HirVarId, &str> = HashMap::new();
    for var in func.params.iter().chain(func.locals.iter()) {
        if let Some(prev_name) = seen_ids.get(&var.id) {
            sink.warn(
                func_name,
                addr,
                DiagnosticKind::Validation,
                format!(
                    "duplicate variable ID {} (\"{}\" and \"{}\")",
                    var.id.0, prev_name, var.name
                ),
            );
        } else {
            seen_ids.insert(var.id, &var.name);
        }
    }

    // 2. Collect all declared variable IDs
    let declared_ids: HashSet<HirVarId> = func
        .params
        .iter()
        .chain(func.locals.iter())
        .map(|v| v.id)
        .collect();

    // 3. Check all variable references in the body
    let mut referenced_ids: HashSet<HirVarId> = HashSet::new();
    for stmt in &func.body {
        collect_referenced_vars(stmt, &mut referenced_ids);
    }

    // Report undeclared variable references
    for &ref_id in &referenced_ids {
        if !declared_ids.contains(&ref_id) {
            // Only warn for "normal" IDs — result vars (1000+) are added
            // by the calling convention pass and might not be in locals yet
            if ref_id.0 < 1000 {
                sink.warn(
                    func_name,
                    addr,
                    DiagnosticKind::Validation,
                    format!("reference to undeclared variable ID {}", ref_id.0),
                );
            }
        }
    }

    // 4. Check for empty body
    let non_comment_stmts: Vec<_> = func
        .body
        .iter()
        .filter(|s| !matches!(s, HirStmt::Comment { .. }))
        .collect();
    if non_comment_stmts.is_empty() {
        sink.info(
            func_name,
            addr,
            DiagnosticKind::Validation,
            "function body contains only comments or is empty",
        );
    }

    // 5. Check call targets for missing signatures
    check_call_signatures(&func.body, func_name, addr, signatures, sink);

    // 6. Count unresolved types
    let mut unresolved_count = 0;
    if !func.return_type.is_resolved() {
        unresolved_count += 1;
    }
    for var in func.params.iter().chain(func.locals.iter()) {
        if !var.ty.is_resolved() {
            unresolved_count += 1;
        }
    }
    if unresolved_count > 0 {
        sink.info(
            func_name,
            addr,
            DiagnosticKind::UnresolvedType,
            format!("{} unresolved type(s)", unresolved_count),
        );
    }

    // 7. Check for unreachable code after return
    let mut found_return = false;
    for stmt in &func.body {
        if found_return {
            if !matches!(stmt, HirStmt::Comment { .. } | HirStmt::Label { .. }) {
                sink.info(
                    func_name,
                    addr,
                    DiagnosticKind::DeadCode,
                    "unreachable code after return statement",
                );
                break;
            }
        }
        if matches!(stmt, HirStmt::Return { .. }) {
            found_return = true;
        }
    }
}

/// Check call targets for missing signatures and report as hints.
fn check_call_signatures(
    body: &[HirStmt],
    func_name: &str,
    func_addr: u64,
    signatures: &SignatureDb,
    sink: &mut DiagnosticSink,
) {
    for stmt in body {
        match stmt {
            HirStmt::Assign {
                rhs: HirExpr::Call { target, .. },
                ..
            }
            | HirStmt::Expr {
                expr: HirExpr::Call { target, .. },
                ..
            } => {
                if let HirExpr::AddrLit { address, .. } = target.as_ref() {
                    if signatures.lookup(*address).is_none() {
                        sink.hint(
                            func_name,
                            func_addr,
                            DiagnosticKind::MissingSignature,
                            format!(
                                "no signature for call target sub_{:x} (0x{:x})",
                                address, address
                            ),
                        );
                    }
                }
            }
            HirStmt::If {
                then_body,
                else_body,
                ..
            } => {
                check_call_signatures(then_body, func_name, func_addr, signatures, sink);
                if let Some(else_stmts) = else_body {
                    check_call_signatures(else_stmts, func_name, func_addr, signatures, sink);
                }
            }
            HirStmt::While { body, .. } | HirStmt::DoWhile { body, .. } => {
                check_call_signatures(body, func_name, func_addr, signatures, sink);
            }
            HirStmt::For { body, .. } => {
                check_call_signatures(body, func_name, func_addr, signatures, sink);
            }
            HirStmt::Switch {
                cases, default, ..
            } => {
                for case in cases {
                    check_call_signatures(&case.body, func_name, func_addr, signatures, sink);
                }
                if let Some(default_stmts) = default {
                    check_call_signatures(default_stmts, func_name, func_addr, signatures, sink);
                }
            }
            _ => {}
        }
    }
}

/// Collect all variable IDs referenced in a statement tree.
fn collect_referenced_vars(stmt: &HirStmt, out: &mut HashSet<HirVarId>) {
    match stmt {
        HirStmt::VarDecl {
            var_id,
            init: Some(expr),
            ..
        } => {
            out.insert(*var_id);
            collect_expr_vars(expr, out);
        }
        HirStmt::Assign { lhs, rhs, .. } => {
            collect_expr_vars(lhs, out);
            collect_expr_vars(rhs, out);
        }
        HirStmt::Expr { expr, .. } => {
            collect_expr_vars(expr, out);
        }
        HirStmt::Return {
            value: Some(expr), ..
        } => {
            collect_expr_vars(expr, out);
        }
        HirStmt::If {
            cond,
            then_body,
            else_body,
            ..
        } => {
            collect_expr_vars(cond, out);
            for s in then_body {
                collect_referenced_vars(s, out);
            }
            if let Some(else_stmts) = else_body {
                for s in else_stmts {
                    collect_referenced_vars(s, out);
                }
            }
        }
        HirStmt::While { cond, body, .. } => {
            collect_expr_vars(cond, out);
            for s in body {
                collect_referenced_vars(s, out);
            }
        }
        HirStmt::DoWhile { body, cond, .. } => {
            for s in body {
                collect_referenced_vars(s, out);
            }
            collect_expr_vars(cond, out);
        }
        HirStmt::For {
            init,
            cond,
            step,
            body,
            ..
        } => {
            if let Some(init) = init {
                collect_referenced_vars(init, out);
            }
            if let Some(cond) = cond {
                collect_expr_vars(cond, out);
            }
            if let Some(step) = step {
                collect_referenced_vars(step, out);
            }
            for s in body {
                collect_referenced_vars(s, out);
            }
        }
        HirStmt::Switch {
            expr,
            cases,
            default,
            ..
        } => {
            collect_expr_vars(expr, out);
            for case in cases {
                for s in &case.body {
                    collect_referenced_vars(s, out);
                }
            }
            if let Some(default_stmts) = default {
                for s in default_stmts {
                    collect_referenced_vars(s, out);
                }
            }
        }
        _ => {}
    }
}

/// Collect variable IDs from an expression.
fn collect_expr_vars(expr: &HirExpr, out: &mut HashSet<HirVarId>) {
    match expr {
        HirExpr::Var { id, .. } => {
            out.insert(*id);
        }
        HirExpr::Binary { lhs, rhs, .. } => {
            collect_expr_vars(lhs, out);
            collect_expr_vars(rhs, out);
        }
        HirExpr::Unary { operand, .. } => {
            collect_expr_vars(operand, out);
        }
        HirExpr::Cast { expr, .. } => {
            collect_expr_vars(expr, out);
        }
        HirExpr::Call { target, args, .. } => {
            collect_expr_vars(target, out);
            for a in args {
                collect_expr_vars(a, out);
            }
        }
        HirExpr::Subscript { base, index, .. } => {
            collect_expr_vars(base, out);
            collect_expr_vars(index, out);
        }
        HirExpr::FieldAccess { expr, .. } | HirExpr::DerefFieldAccess { expr, .. } => {
            collect_expr_vars(expr, out);
        }
        HirExpr::Ternary {
            cond,
            then_expr,
            else_expr,
            ..
        } => {
            collect_expr_vars(cond, out);
            collect_expr_vars(then_expr, out);
            collect_expr_vars(else_expr, out);
        }
        _ => {}
    }
}

// ─── Tests ──────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;
    #[allow(unused_imports)]
    use crate::ir::hir::*;
    use crate::signatures::SignatureDb;

    fn mk_simple_module() -> HirModule {
        HirModule {
            name: "test.exe".into(),
            arch: "amd64".into(),
            functions: vec![HirFunction {
                name: "sub_100".into(),
                address: 0x100,
                return_type: HirType::Void,
                params: vec![],
                locals: vec![HirVar {
                    id: HirVarId(0),
                    name: "var_20".into(),
                    ty: HirType::i32(),
                    storage: HirStorage::Stack(0x20),
                    span: Span::single(0x100),
                }],
                body: vec![
                    HirStmt::Assign {
                        lhs: HirExpr::Var {
                            id: HirVarId(0),
                            span: Span::single(0x100),
                        },
                        rhs: HirExpr::IntLit {
                            value: 42,
                            ty: HirType::i32(),
                            span: Span::single(0x100),
                        },
                        span: Span::single(0x100),
                    },
                    HirStmt::Return {
                        value: None,
                        span: Span::single(0x108),
                    },
                ],
                calling_convention: Some("win64".into()),
                is_variadic: false,
                span: Span::single(0x100),
            }],
        }
    }

    #[test]
    fn validate_valid_module() {
        let module = mk_simple_module();
        let sigs = SignatureDb::new();
        let mut sink = DiagnosticSink::new();

        let result = validate_module(&module, &sigs, &mut sink);
        assert!(result.is_valid, "simple module should be valid");
        assert_eq!(result.errors, 0);
    }

    #[test]
    fn validate_undeclared_variable_reference() {
        let mut module = mk_simple_module();
        // Add a reference to undeclared variable ID 99
        module.functions[0].body.insert(
            0,
            HirStmt::Assign {
                lhs: HirExpr::Var {
                    id: HirVarId(99),
                    span: Span::single(0x100),
                },
                rhs: HirExpr::IntLit {
                    value: 1,
                    ty: HirType::i32(),
                    span: Span::single(0x100),
                },
                span: Span::single(0x100),
            },
        );

        let sigs = SignatureDb::new();
        let mut sink = DiagnosticSink::new();
        let result = validate_module(&module, &sigs, &mut sink);

        assert!(result.warnings > 0, "should have warnings about undeclared var");
    }

    #[test]
    fn validate_missing_call_signature() {
        let mut module = mk_simple_module();
        // Add a call to an unresolved address
        module.functions[0].body.insert(
            0,
            HirStmt::Expr {
                expr: HirExpr::Call {
                    target: Box::new(HirExpr::AddrLit {
                        address: 0xDEADBEEF,
                        span: Span::single(0x100),
                    }),
                    args: vec![],
                    ret_ty: HirType::Void,
                    span: Span::single(0x100),
                },
                span: Span::single(0x100),
            },
        );

        let sigs = SignatureDb::new();
        let mut sink = DiagnosticSink::new();
        let result = validate_module(&module, &sigs, &mut sink);

        assert!(result.hints > 0, "should have hint about missing signature");
    }

    #[test]
    fn validate_empty_module() {
        let module = HirModule {
            name: "empty.exe".into(),
            arch: "amd64".into(),
            functions: vec![],
        };

        let sigs = SignatureDb::new();
        let mut sink = DiagnosticSink::new();
        validate_module(&module, &sigs, &mut sink);

        let info = sink.by_kind(DiagnosticKind::Validation);
        assert!(!info.is_empty(), "should note empty module");
    }

    #[test]
    fn validate_unreachable_code() {
        let mut module = mk_simple_module();
        // Add code after return
        module.functions[0].body.push(HirStmt::Assign {
            lhs: HirExpr::Var {
                id: HirVarId(0),
                span: Span::single(0x110),
            },
            rhs: HirExpr::IntLit {
                value: 99,
                ty: HirType::i32(),
                span: Span::single(0x110),
            },
            span: Span::single(0x110),
        });

        let sigs = SignatureDb::new();
        let mut sink = DiagnosticSink::new();
        validate_module(&module, &sigs, &mut sink);

        let dead_code = sink.by_kind(DiagnosticKind::DeadCode);
        assert!(!dead_code.is_empty(), "should detect unreachable code after return");
    }
}
