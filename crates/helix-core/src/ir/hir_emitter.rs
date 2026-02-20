//! HIR Emitter — Renders a [`HirModule`] into pseudo-C source code.
//!
//! This emitter produces the final human-readable output from the typed HIR.
//! It is the HIR-path counterpart to `decompile.rs`, which operates on raw
//! `RemillInsn` streams.
//!
//! ## Features
//!
//! - Proper C-style type names from resolved `HirType`
//! - Stack offset comments on local variable declarations
//! - Address comments on each statement (toggleable)
//! - Indented, well-structured output with function separators
//! - Signature database lookup for call target naming

use crate::ir::hir::*;
use crate::signatures::SignatureDb;

use std::collections::HashMap;

/// Variable name lookup table — maps HIR variable IDs to display names.
type VarNameMap = HashMap<HirVarId, String>;

// ─── Public API ─────────────────────────────────────────────────────────────

/// Options controlling the emitter output.
#[derive(Debug, Clone)]
pub struct EmitOptions {
    /// Include address comments (e.g., `// 0x14003062f`).
    pub include_addresses: bool,
    /// Include stack offset comments on local declarations.
    pub include_stack_offsets: bool,
    /// Indentation string (default: 4 spaces).
    pub indent: String,
}

impl Default for EmitOptions {
    fn default() -> Self {
        Self {
            include_addresses: false,
            include_stack_offsets: true,
            indent: "    ".to_string(),
        }
    }
}

/// Emit a complete [`HirModule`] as pseudo-C source code.
pub fn emit_module(
    module: &HirModule,
    signatures: &SignatureDb,
    options: &EmitOptions,
) -> String {
    let mut out = String::new();

    out.push_str("// Decompiled by HexCore Helix\n");
    out.push_str(&format!("// Source: {}\n", module.name));
    out.push_str(&format!("// Arch:   {}\n", module.arch));
    if let Some(first_fn) = module.functions.first() {
        out.push_str(&format!("// Entry:  0x{:x}\n", first_fn.address));
    }
    out.push('\n');

    for func in &module.functions {
        emit_function(&mut out, func, signatures, options);
    }

    out
}

// ─── Function Emission ──────────────────────────────────────────────────────

fn emit_function(
    out: &mut String,
    func: &HirFunction,
    signatures: &SignatureDb,
    options: &EmitOptions,
) {
    // Build variable name lookup from the function's declared vars
    let var_names = build_var_names(func);

    // Function separator
    out.push_str(&format!(
        "// ─── {} ────────────────────────────────\n",
        func.name
    ));

    // Function signature
    let ret_type = format_type(&func.return_type);
    let params = if func.params.is_empty() {
        "void".to_string()
    } else {
        func.params
            .iter()
            .map(|p| format!("{} {}", format_type(&p.ty), p.name))
            .collect::<Vec<_>>()
            .join(", ")
    };

    out.push_str(&format!("{} {}({}) {{\n", ret_type, func.name, params));

    // Local variable declarations (only stack and temporaries that aren't registers)
    let visible_locals: Vec<&HirVar> = func
        .locals
        .iter()
        .filter(|v| matches!(v.storage, HirStorage::Stack(_)))
        .collect();

    for local in &visible_locals {
        let ty = format_type(&local.ty);
        let comment = match local.storage {
            HirStorage::Stack(off) if options.include_stack_offsets => {
                format!("  // [rsp+0x{:x}]", off)
            }
            _ => String::new(),
        };
        out.push_str(&format!("{}{}  {};{}\n", options.indent, ty, local.name, comment));
    }

    if !visible_locals.is_empty() {
        out.push('\n');
    }

    // Function body
    for stmt in &func.body {
        emit_stmt(out, stmt, 1, signatures, options, &var_names);
    }

    out.push_str("}\n\n");
}

/// Build a mapping from variable IDs to their display names.
fn build_var_names(func: &HirFunction) -> VarNameMap {
    let mut map = VarNameMap::new();
    for var in &func.params {
        map.insert(var.id, var.name.clone());
    }
    for var in &func.locals {
        map.insert(var.id, var.name.clone());
    }
    map
}

/// Resolve a variable ID to a display name.
fn var_name(id: &HirVarId, names: &VarNameMap) -> String {
    names
        .get(id)
        .cloned()
        .unwrap_or_else(|| format!("v{}", id.0))
}

// ─── Statement Emission ─────────────────────────────────────────────────────

fn emit_stmt(
    out: &mut String,
    stmt: &HirStmt,
    depth: usize,
    signatures: &SignatureDb,
    options: &EmitOptions,
    names: &VarNameMap,
) {
    let pad = options.indent.repeat(depth);

    match stmt {
        HirStmt::VarDecl {
            var_id,
            init: Some(expr),
            span,
        } => {
            let addr_comment = addr_suffix(span, options);
            let vname = var_name(var_id, names);
            out.push_str(&format!(
                "{}auto {} = {};{}\n",
                pad,
                vname,
                format_expr(expr, signatures, names),
                addr_comment
            ));
        }

        HirStmt::VarDecl {
            var_id: _,
            init: None,
            ..
        } => {
            // Skip: declarations without init are already in the local list
        }

        HirStmt::Assign { lhs, rhs, span } => {
            let addr_comment = addr_suffix(span, options);

            // Special case: skip RSP/RBP bookkeeping (sub rsp, add rsp)
            if is_stack_pointer_bookkeeping(lhs, rhs) {
                return;
            }

            // Special case: Var = Call → emit as typed call with result
            if let HirExpr::Call {
                target,
                args,
                ret_ty,
                ..
            } = rhs
            {
                let (call_name, resolved_ret) =
                    resolve_call_target(target, ret_ty, signatures, names);
                let args_str = format_call_args(args, signatures, names);
                let ret_name = format_type(&resolved_ret);
                let lhs_str = format_expr(lhs, signatures, names);

                if resolved_ret == HirType::Void {
                    out.push_str(&format!(
                        "{}{}({});{}\n",
                        pad, call_name, args_str, addr_comment
                    ));
                } else {
                    // Use the target variable name if it's a known local
                    out.push_str(&format!(
                        "{}{} {} = {}({});{}\n",
                        pad, ret_name, lhs_str, call_name, args_str, addr_comment
                    ));
                }
                return;
            }

            let lhs_str = format_expr(lhs, signatures, names);
            let rhs_str = format_expr(rhs, signatures, names);
            out.push_str(&format!(
                "{}{} = {};{}\n",
                pad, lhs_str, rhs_str, addr_comment
            ));
        }

        HirStmt::Expr { expr, span } => {
            let addr_comment = addr_suffix(span, options);
            out.push_str(&format!(
                "{}{};{}\n",
                pad,
                format_expr(expr, signatures, names),
                addr_comment
            ));
        }

        HirStmt::Return { value: None, .. } => {
            out.push_str(&format!("{}return;\n", pad));
        }

        HirStmt::Return {
            value: Some(expr), ..
        } => {
            out.push_str(&format!(
                "{}return {};\n",
                pad,
                format_expr(expr, signatures, names)
            ));
        }

        HirStmt::If {
            cond,
            then_body,
            else_body,
            ..
        } => {
            out.push_str(&format!(
                "{}if ({}) {{\n",
                pad,
                format_expr(cond, signatures, names)
            ));
            for s in then_body {
                emit_stmt(out, s, depth + 1, signatures, options, names);
            }
            if let Some(else_stmts) = else_body {
                out.push_str(&format!("{}}} else {{\n", pad));
                for s in else_stmts {
                    emit_stmt(out, s, depth + 1, signatures, options, names);
                }
            }
            out.push_str(&format!("{}}}\n", pad));
        }

        HirStmt::While { cond, body, .. } => {
            out.push_str(&format!(
                "{}while ({}) {{\n",
                pad,
                format_expr(cond, signatures, names)
            ));
            for s in body {
                emit_stmt(out, s, depth + 1, signatures, options, names);
            }
            out.push_str(&format!("{}}}\n", pad));
        }

        HirStmt::DoWhile { body, cond, .. } => {
            out.push_str(&format!("{}do {{\n", pad));
            for s in body {
                emit_stmt(out, s, depth + 1, signatures, options, names);
            }
            out.push_str(&format!(
                "{}}} while ({});\n",
                pad,
                format_expr(cond, signatures, names)
            ));
        }

        HirStmt::For {
            init,
            cond,
            step,
            body,
            ..
        } => {
            let init_str = init
                .as_ref()
                .map(|s| format_stmt_inline(s, signatures, names))
                .unwrap_or_default();
            let cond_str = cond
                .as_ref()
                .map(|e| format_expr(e, signatures, names))
                .unwrap_or_default();
            let step_str = step
                .as_ref()
                .map(|s| format_stmt_inline(s, signatures, names))
                .unwrap_or_default();
            out.push_str(&format!(
                "{}for ({}; {}; {}) {{\n",
                pad, init_str, cond_str, step_str
            ));
            for s in body {
                emit_stmt(out, s, depth + 1, signatures, options, names);
            }
            out.push_str(&format!("{}}}\n", pad));
        }

        HirStmt::Switch {
            expr,
            cases,
            default,
            ..
        } => {
            out.push_str(&format!(
                "{}switch ({}) {{\n",
                pad,
                format_expr(expr, signatures, names)
            ));
            for case in cases {
                let labels = case
                    .values
                    .iter()
                    .map(|v| {
                        if *v >= 16 || *v <= -16 {
                            format!("case 0x{:x}:", v)
                        } else {
                            format!("case {}:", v)
                        }
                    })
                    .collect::<Vec<_>>()
                    .join(" ");
                out.push_str(&format!("{}{}{}\n", pad, options.indent, labels));
                for s in &case.body {
                    emit_stmt(out, s, depth + 2, signatures, options, names);
                }
            }
            if let Some(default_stmts) = default {
                out.push_str(&format!("{}{}default:\n", pad, options.indent));
                for s in default_stmts {
                    emit_stmt(out, s, depth + 2, signatures, options, names);
                }
            }
            out.push_str(&format!("{}}}\n", pad));
        }

        HirStmt::Break { .. } => {
            out.push_str(&format!("{}break;\n", pad));
        }

        HirStmt::Continue { .. } => {
            out.push_str(&format!("{}continue;\n", pad));
        }

        HirStmt::Goto { label, .. } => {
            out.push_str(&format!("{}goto {};\n", pad, label));
        }

        HirStmt::Label { name, .. } => {
            out.push_str(&format!("{}:\n", name));
        }

        HirStmt::Asm { text, .. } => {
            out.push_str(&format!("{}__asm {{ {} }}\n", pad, text));
        }

        HirStmt::Comment { text, .. } => {
            out.push_str(&format!("{}// {}\n", pad, text));
        }
    }
}

// ─── Expression Formatting ─────────────────────────────────────────────────

fn format_expr(expr: &HirExpr, signatures: &SignatureDb, names: &VarNameMap) -> String {
    match expr {
        HirExpr::IntLit { value, .. } => {
            if *value >= 16 || *value <= -16 {
                format!("0x{:x}", value)
            } else {
                format!("{}", value)
            }
        }

        HirExpr::FloatLit { value, .. } => format!("{}", value),

        HirExpr::StringLit { value, .. } => format!("\"{}\"", value),

        HirExpr::Var { id, .. } => var_name(id, names),

        HirExpr::Binary { op, lhs, rhs, .. } => {
            let lhs_str = format_expr(lhs, signatures, names);
            let rhs_str = format_expr(rhs, signatures, names);
            format!("({} {} {})", lhs_str, op, rhs_str)
        }

        HirExpr::Unary { op, operand, .. } => {
            let inner = format_expr(operand, signatures, names);
            match op {
                HirUnaryOp::Deref => format!("*{}", inner),
                HirUnaryOp::AddressOf => format!("&{}", inner),
                _ => format!("{}{}", op, inner),
            }
        }

        HirExpr::Cast { expr, to_ty, .. } => {
            format!(
                "({}){}",
                format_type(to_ty),
                format_expr(expr, signatures, names)
            )
        }

        HirExpr::Call { target, args, .. } => {
            let (name, _) = resolve_call_target(target, &HirType::Unknown, signatures, names);
            let args_str = format_call_args(args, signatures, names);
            format!("{}({})", name, args_str)
        }

        HirExpr::Subscript { base, index, .. } => {
            format!(
                "{}[{}]",
                format_expr(base, signatures, names),
                format_expr(index, signatures, names)
            )
        }

        HirExpr::FieldAccess { expr, field, .. } => {
            format!("{}.{}", format_expr(expr, signatures, names), field)
        }

        HirExpr::DerefFieldAccess { expr, field, .. } => {
            format!("{}->{}", format_expr(expr, signatures, names), field)
        }

        HirExpr::Ternary {
            cond,
            then_expr,
            else_expr,
            ..
        } => {
            format!(
                "({} ? {} : {})",
                format_expr(cond, signatures, names),
                format_expr(then_expr, signatures, names),
                format_expr(else_expr, signatures, names)
            )
        }

        HirExpr::AddrLit { address, .. } => {
            if let Some(sig) = signatures.lookup(*address) {
                sig.name.clone()
            } else {
                format!("sub_{:x}", address)
            }
        }

        HirExpr::Unknown { description, .. } => {
            format!("/* {} */", description)
        }
    }
}

// ─── Type Formatting ────────────────────────────────────────────────────────

fn format_type(ty: &HirType) -> String {
    match ty {
        HirType::Unknown => "auto".to_string(),
        HirType::Void => "void".to_string(),
        HirType::Bool => "bool".to_string(),
        HirType::Int { signed, bits } => {
            let prefix = if *signed { "int" } else { "uint" };
            format!("{}{}_t", prefix, bits)
        }
        HirType::Float { bits: 32 } => "float".to_string(),
        HirType::Float { bits: 64 } => "double".to_string(),
        HirType::Float { bits } => format!("float{}", bits),
        HirType::Pointer(inner) => format!("{}*", format_type(inner)),
        HirType::FuncPtr { ret, params } => {
            let params_str = params
                .iter()
                .map(|p| format_type(p))
                .collect::<Vec<_>>()
                .join(", ");
            format!("{}(*)({})", format_type(ret), params_str)
        }
        HirType::Struct {
            name: Some(n), ..
        } => format!("struct {}", n),
        HirType::Struct { name: None, .. } => "struct <anon>".to_string(),
        HirType::Array {
            element,
            length: Some(n),
        } => format!("{}[{}]", format_type(element), n),
        HirType::Array {
            element,
            length: None,
        } => format!("{}[]", format_type(element)),
    }
}

// ─── Call Resolution Helpers ────────────────────────────────────────────────

fn resolve_call_target(
    target: &HirExpr,
    fallback_ret: &HirType,
    signatures: &SignatureDb,
    names: &VarNameMap,
) -> (String, HirType) {
    match target {
        HirExpr::AddrLit { address, .. } => {
            if let Some(sig) = signatures.lookup(*address) {
                let ret_ty =
                    crate::analysis::type_propagation::parse_c_type_name(&sig.return_type);
                (sig.name.clone(), ret_ty)
            } else {
                (format!("sub_{:x}", address), fallback_ret.clone())
            }
        }
        HirExpr::Var { id, .. } => (var_name(id, names), fallback_ret.clone()),
        _ => (format_expr(target, signatures, names), fallback_ret.clone()),
    }
}

fn format_call_args(args: &[HirExpr], signatures: &SignatureDb, names: &VarNameMap) -> String {
    args.iter()
        .map(|a| format_expr(a, signatures, names))
        .collect::<Vec<_>>()
        .join(", ")
}

// ─── Misc Helpers ───────────────────────────────────────────────────────────

fn is_stack_pointer_bookkeeping(lhs: &HirExpr, rhs: &HirExpr) -> bool {
    if let HirExpr::Var { id: lhs_id, .. } = lhs {
        if let HirExpr::Binary {
            lhs: bin_lhs,
            rhs: bin_rhs,
            op,
            ..
        } = rhs
        {
            if matches!(op, HirBinOp::Add | HirBinOp::Sub) {
                if let HirExpr::Var { id: rhs_id, .. } = bin_lhs.as_ref() {
                    if lhs_id == rhs_id {
                        if let HirExpr::IntLit { .. } = bin_rhs.as_ref() {
                            return true;
                        }
                    }
                }
            }
        }
    }
    false
}

fn addr_suffix(span: &Span, options: &EmitOptions) -> String {
    if options.include_addresses && *span != Span::UNKNOWN && span.start_addr != 0 {
        format!("  // 0x{:x}", span.start_addr)
    } else {
        String::new()
    }
}

fn format_stmt_inline(stmt: &HirStmt, signatures: &SignatureDb, names: &VarNameMap) -> String {
    match stmt {
        HirStmt::Assign { lhs, rhs, .. } => {
            format!(
                "{} = {}",
                format_expr(lhs, signatures, names),
                format_expr(rhs, signatures, names)
            )
        }
        HirStmt::Expr { expr, .. } => format_expr(expr, signatures, names),
        _ => String::new(),
    }
}

// ─── Tests ──────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

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
    fn emit_simple_function() {
        let module = mk_simple_module();
        let sigs = SignatureDb::new();
        let options = EmitOptions::default();

        let source = emit_module(&module, &sigs, &options);

        assert!(source.contains("Decompiled by HexCore Helix"));
        assert!(source.contains("sub_100"));
        assert!(source.contains("var_20"));
        assert!(source.contains("int32_t"));
        assert!(source.contains("return;"));
    }

    #[test]
    fn emit_with_address_comments() {
        let module = mk_simple_module();
        let sigs = SignatureDb::new();
        let options = EmitOptions {
            include_addresses: true,
            ..EmitOptions::default()
        };

        let source = emit_module(&module, &sigs, &options);
        assert!(source.contains("// 0x100"));
    }

    #[test]
    fn emit_call_with_signature() {
        let mut sigs = SignatureDb::new();
        sigs.insert(0x140001000, "CreateFileW", "HANDLE");

        let module = HirModule {
            name: "test.exe".into(),
            arch: "amd64".into(),
            functions: vec![HirFunction {
                name: "sub_200".into(),
                address: 0x200,
                return_type: HirType::Void,
                params: vec![],
                locals: vec![],
                body: vec![HirStmt::Assign {
                    lhs: HirExpr::Var {
                        id: HirVarId(0),
                        span: Span::single(0x200),
                    },
                    rhs: HirExpr::Call {
                        target: Box::new(HirExpr::AddrLit {
                            address: 0x140001000,
                            span: Span::single(0x200),
                        }),
                        args: vec![],
                        ret_ty: HirType::Unknown,
                        span: Span::single(0x200),
                    },
                    span: Span::single(0x200),
                }],
                calling_convention: Some("win64".into()),
                is_variadic: false,
                span: Span::single(0x200),
            }],
        };

        let options = EmitOptions::default();
        let source = emit_module(&module, &sigs, &options);

        assert!(
            source.contains("CreateFileW"),
            "expected resolved call name in: {}",
            source
        );
        assert!(
            source.contains("void*"),
            "HANDLE should resolve to void*, got: {}",
            source
        );
    }

    #[test]
    fn emit_stack_pointer_bookkeeping_hidden() {
        let module = HirModule {
            name: "test.exe".into(),
            arch: "amd64".into(),
            functions: vec![HirFunction {
                name: "sub_300".into(),
                address: 0x300,
                return_type: HirType::Void,
                params: vec![],
                locals: vec![],
                body: vec![
                    // sub rsp, 0x38 → rsp = rsp - 0x38
                    HirStmt::Assign {
                        lhs: HirExpr::Var {
                            id: HirVarId(0),
                            span: Span::single(0x300),
                        },
                        rhs: HirExpr::Binary {
                            op: HirBinOp::Sub,
                            lhs: Box::new(HirExpr::Var {
                                id: HirVarId(0),
                                span: Span::single(0x300),
                            }),
                            rhs: Box::new(HirExpr::IntLit {
                                value: 0x38,
                                ty: HirType::i64(),
                                span: Span::single(0x300),
                            }),
                            ty: HirType::i64(),
                            span: Span::single(0x300),
                        },
                        span: Span::single(0x300),
                    },
                    HirStmt::Return {
                        value: None,
                        span: Span::single(0x308),
                    },
                ],
                calling_convention: Some("win64".into()),
                is_variadic: false,
                span: Span::single(0x300),
            }],
        };

        let sigs = SignatureDb::new();
        let options = EmitOptions::default();
        let source = emit_module(&module, &sigs, &options);

        // The "sub rsp" assignment should be filtered out
        assert!(
            !source.contains("0x38"),
            "stack bookkeeping should be hidden: {}",
            source
        );
    }

    #[test]
    fn format_type_correctness() {
        assert_eq!(format_type(&HirType::Void), "void");
        assert_eq!(format_type(&HirType::i32()), "int32_t");
        assert_eq!(format_type(&HirType::u64()), "uint64_t");
        assert_eq!(format_type(&HirType::void_ptr()), "void*");
        assert_eq!(format_type(&HirType::Unknown), "auto");
        assert_eq!(format_type(&HirType::Bool), "bool");
    }
}
