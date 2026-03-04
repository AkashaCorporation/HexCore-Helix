//! Pseudo-C emitter — concrete implementation of [`Emitter`].
//!
//! Renders AST nodes into human-readable pseudo-C source code
//! with proper indentation, type annotations, and address comments.

use std::collections::HashSet;

use crate::ast::{AstNode, DataType, Expression, Function, Statement, StorageClass, UnaryOp, BinaryOp, Variable};
use crate::error::HelixError;
use crate::pipeline::{EmitFormat, EmitOutput, Emitter};

/// Emitter that produces pseudo-C source code from AST nodes.
pub struct PseudoCEmitter {
    /// Whether to include address comments in the output.
    include_addresses: bool,
    /// Indentation string (default: 4 spaces).
    indent: String,
}

impl PseudoCEmitter {
    pub fn new() -> Self {
        Self {
            include_addresses: true,
            indent: "    ".to_string(),
        }
    }

    pub fn with_addresses(mut self, include: bool) -> Self {
        self.include_addresses = include;
        self
    }

    pub fn with_indent(mut self, indent: impl Into<String>) -> Self {
        self.indent = indent.into();
        self
    }
}

impl Default for PseudoCEmitter {
    fn default() -> Self {
        Self::new()
    }
}

impl Emitter for PseudoCEmitter {
    fn emit(&self, ast: &[AstNode], format: EmitFormat) -> Result<EmitOutput, HelixError> {
        if format != EmitFormat::PseudoC {
            return Err(HelixError::Emit {
                message: format!("PseudoCEmitter does not support {:?} format", format),
            });
        }

        let mut source = String::new();
        let mut line_map: Vec<(u32, u64)> = Vec::new();
        let mut line_number = 1u32;

        source.push_str("// Decompiled by HexCore Helix\n");
        line_number += 1;
        source.push('\n');
        line_number += 1;

        for node in ast {
            match node {
                AstNode::Func(func) => {
                    self.emit_function(&mut source, &mut line_map, &mut line_number, func);
                }
                AstNode::GlobalVar(_) => {
                    // TODO: global variable emission
                    source.push_str("// [global variable — pending]\n");
                    line_number += 1;
                }
                AstNode::TypeDef { .. } => {
                    source.push_str("// [typedef — pending]\n");
                    line_number += 1;
                }
            }
        }

        #[cfg(debug_assertions)]
        {
            let violations = validate_output(&source);
            for v in &violations {
                eprintln!("PseudoCEmitter: {}", v);
            }
        }

        Ok(EmitOutput {
            source,
            format: EmitFormat::PseudoC,
            line_map,
        })
    }
}

impl PseudoCEmitter {
    fn emit_function(
        &self,
        out: &mut String,
        line_map: &mut Vec<(u32, u64)>,
        line_num: &mut u32,
        func: &Function,
    ) {
        // Function separator
        out.push_str(&format!(
            "// ─── {} ────────────────────────────────\n",
            func.name
        ));
        *line_num += 1;

        // Record function entry address
        line_map.push((*line_num, func.address.0));

        // Function signature
        let ret_type = format_data_type(&func.return_type);
        let params = if func.params.is_empty() {
            "void".to_string()
        } else {
            func.params
                .iter()
                .map(|p| format!("{} {}", format_data_type(&p.ty), p.name))
                .collect::<Vec<_>>()
                .join(", ")
        };

        out.push_str(&format!("{} {}({}) {{\n", ret_type, func.name, params));
        *line_num += 1;

        // Local variable declarations — only emit used variables, grouped by storage
        let referenced = collect_referenced_vars(&func.body);

        // Partition locals into groups: Stack → Register → Temporary/other
        let (stack_locals, register_locals, temp_locals): (Vec<_>, Vec<_>, Vec<_>) = {
            let mut stack = Vec::new();
            let mut reg = Vec::new();
            let mut temp = Vec::new();
            for local in &func.locals {
                if !referenced.contains(&local.name) {
                    continue; // skip unused variables
                }
                match local.storage {
                    StorageClass::Stack => stack.push(local),
                    StorageClass::Register => reg.push(local),
                    StorageClass::Parameter => {} // already in signature
                    _ => temp.push(local),        // Global, or any other
                }
            }
            (stack, reg, temp)
        };

        let emit_local_group = |out: &mut String, line_num: &mut u32, locals: &[&Variable], indent: &str| {
            for local in locals {
                let ty = format_data_type(&local.ty);
                let comment = match local.stack_offset {
                    Some(off) => format!("  // [rsp+0x{:x}]", off),
                    None => String::new(),
                };
                out.push_str(&format!(
                    "{}{}  {};{}\n",
                    indent, ty, local.name, comment
                ));
                *line_num += 1;
            }
        };

        emit_local_group(out, line_num, &stack_locals, &self.indent);
        emit_local_group(out, line_num, &register_locals, &self.indent);
        emit_local_group(out, line_num, &temp_locals, &self.indent);

        let has_locals = !stack_locals.is_empty() || !register_locals.is_empty() || !temp_locals.is_empty();

        if has_locals {
            out.push('\n');
            *line_num += 1;
        }

        // Function body
        for stmt in &func.body {
            self.emit_statement(out, line_map, line_num, stmt, 1);
        }

        out.push_str("}\n\n");
        *line_num += 2;
    }

    fn emit_statement(
        &self,
        out: &mut String,
        line_map: &mut Vec<(u32, u64)>,
        line_num: &mut u32,
        stmt: &Statement,
        depth: usize,
    ) {
        let pad = self.indent.repeat(depth);

        match stmt {
            Statement::VarDecl { var, init } => {
                let ty = format_data_type(&var.ty);
                match init {
                    Some(expr) => {
                        out.push_str(&format!(
                            "{}{} {} = {};\n",
                            pad,
                            ty,
                            var.name,
                            format_expr(expr)
                        ));
                    }
                    None => {
                        out.push_str(&format!("{}{} {};\n", pad, ty, var.name));
                    }
                }
                *line_num += 1;
            }

            Statement::Assign { lhs, rhs } => {
                out.push_str(&format!(
                    "{}{} = {};\n",
                    pad,
                    format_expr(lhs),
                    format_expr(rhs)
                ));
                *line_num += 1;
            }

            Statement::Expr(expr) => {
                out.push_str(&format!("{}{};\n", pad, format_expr(expr)));
                *line_num += 1;
            }

            Statement::Return(None) => {
                out.push_str(&format!("{}return;\n", pad));
                *line_num += 1;
            }

            Statement::Return(Some(expr)) => {
                out.push_str(&format!("{}return {};\n", pad, format_expr(expr)));
                *line_num += 1;
            }

            Statement::If {
                cond,
                then_body,
                else_body,
            } => {
                out.push_str(&format!("{}if ({}) {{\n", pad, format_expr(cond)));
                *line_num += 1;
                for s in then_body {
                    self.emit_statement(out, line_map, line_num, s, depth + 1);
                }
                if let Some(else_stmts) = else_body {
                    out.push_str(&format!("{}}} else {{\n", pad));
                    *line_num += 1;
                    for s in else_stmts {
                        self.emit_statement(out, line_map, line_num, s, depth + 1);
                    }
                }
                out.push_str(&format!("{}}}\n", pad));
                *line_num += 1;
            }

            Statement::While { cond, body } => {
                out.push_str(&format!("{}while ({}) {{\n", pad, format_expr(cond)));
                *line_num += 1;
                for s in body {
                    self.emit_statement(out, line_map, line_num, s, depth + 1);
                }
                out.push_str(&format!("{}}}\n", pad));
                *line_num += 1;
            }

            Statement::DoWhile { body, cond } => {
                out.push_str(&format!("{}do {{\n", pad));
                *line_num += 1;
                for s in body {
                    self.emit_statement(out, line_map, line_num, s, depth + 1);
                }
                out.push_str(&format!("{}}} while ({});\n", pad, format_expr(cond)));
                *line_num += 1;
            }

            Statement::For {
                init,
                cond,
                step,
                body,
            } => {
                let init_str = init
                    .as_ref()
                    .map(|s| format_stmt_inline(s))
                    .unwrap_or_default();
                let cond_str = cond.as_ref().map(format_expr).unwrap_or_default();
                let step_str = step
                    .as_ref()
                    .map(|s| format_stmt_inline(s))
                    .unwrap_or_default();
                out.push_str(&format!(
                    "{}for ({}; {}; {}) {{\n",
                    pad, init_str, cond_str, step_str
                ));
                *line_num += 1;
                for s in body {
                    self.emit_statement(out, line_map, line_num, s, depth + 1);
                }
                out.push_str(&format!("{}}}\n", pad));
                *line_num += 1;
            }

            Statement::Switch {
                expr,
                cases,
                default,
            } => {
                out.push_str(&format!("{}switch ({}) {{\n", pad, format_expr(expr)));
                *line_num += 1;
                for case in cases {
                    for v in &case.values {
                        out.push_str(&format!("{}case {}:\n", pad, format_int_literal(*v)));
                        *line_num += 1;
                    }
                    for s in &case.body {
                        self.emit_statement(out, line_map, line_num, s, depth + 1);
                    }
                }
                if let Some(default_body) = default {
                    out.push_str(&format!("{}default:\n", pad));
                    *line_num += 1;
                    for s in default_body {
                        self.emit_statement(out, line_map, line_num, s, depth + 1);
                    }
                }
                out.push_str(&format!("{}}}\n", pad));
                *line_num += 1;
            }

            Statement::Break => {
                out.push_str(&format!("{}break;\n", pad));
                *line_num += 1;
            }

            Statement::Continue => {
                out.push_str(&format!("{}continue;\n", pad));
                *line_num += 1;
            }

            Statement::Goto(label) => {
                out.push_str(&format!("{}goto {};\n", pad, label));
                *line_num += 1;
            }

            Statement::Label(name) => {
                out.push_str(&format!("{}:\n", name));
                *line_num += 1;
            }

            Statement::Asm(text) => {
                out.push_str(&format!("{}__asm {{ {} }}\n", pad, text));
                *line_num += 1;
            }

            Statement::Comment(text) => {
                out.push_str(&format!("{}// {}\n", pad, text));
                *line_num += 1;
            }
        }
    }
}

// ─── Variable Reference Collection ──────────────────────────────────────────

/// Collect all variable names referenced in a list of statements.
fn collect_referenced_vars(stmts: &[Statement]) -> HashSet<String> {
    let mut refs = HashSet::new();
    for stmt in stmts {
        collect_vars_in_stmt(stmt, &mut refs);
    }
    refs
}

fn collect_vars_in_stmt(stmt: &Statement, refs: &mut HashSet<String>) {
    match stmt {
        Statement::VarDecl { init, .. } => {
            if let Some(expr) = init {
                collect_vars_in_expr(expr, refs);
            }
        }
        Statement::Assign { lhs, rhs } => {
            collect_vars_in_expr(lhs, refs);
            collect_vars_in_expr(rhs, refs);
        }
        Statement::Expr(expr) => collect_vars_in_expr(expr, refs),
        Statement::Return(Some(expr)) => collect_vars_in_expr(expr, refs),
        Statement::Return(None) | Statement::Break | Statement::Continue
        | Statement::Goto(_) | Statement::Label(_) | Statement::Asm(_)
        | Statement::Comment(_) => {}
        Statement::If { cond, then_body, else_body } => {
            collect_vars_in_expr(cond, refs);
            for s in then_body { collect_vars_in_stmt(s, refs); }
            if let Some(else_stmts) = else_body {
                for s in else_stmts { collect_vars_in_stmt(s, refs); }
            }
        }
        Statement::While { cond, body } => {
            collect_vars_in_expr(cond, refs);
            for s in body { collect_vars_in_stmt(s, refs); }
        }
        Statement::DoWhile { body, cond } => {
            for s in body { collect_vars_in_stmt(s, refs); }
            collect_vars_in_expr(cond, refs);
        }
        Statement::For { init, cond, step, body } => {
            if let Some(s) = init { collect_vars_in_stmt(s, refs); }
            if let Some(e) = cond { collect_vars_in_expr(e, refs); }
            if let Some(s) = step { collect_vars_in_stmt(s, refs); }
            for s in body { collect_vars_in_stmt(s, refs); }
        }
        Statement::Switch { expr, cases, default } => {
            collect_vars_in_expr(expr, refs);
            for case in cases {
                for s in &case.body { collect_vars_in_stmt(s, refs); }
            }
            if let Some(default_body) = default {
                for s in default_body { collect_vars_in_stmt(s, refs); }
            }
        }
    }
}

fn collect_vars_in_expr(expr: &Expression, refs: &mut HashSet<String>) {
    match expr {
        Expression::Var(var) => { refs.insert(var.name.clone()); }
        Expression::Unary { operand, .. } => collect_vars_in_expr(operand, refs),
        Expression::Binary { lhs, rhs, .. } => {
            collect_vars_in_expr(lhs, refs);
            collect_vars_in_expr(rhs, refs);
        }
        Expression::Cast { expr: inner, .. } => collect_vars_in_expr(inner, refs),
        Expression::Call { target, args } => {
            collect_vars_in_expr(target, refs);
            for a in args { collect_vars_in_expr(a, refs); }
        }
        Expression::Subscript { base, index } => {
            collect_vars_in_expr(base, refs);
            collect_vars_in_expr(index, refs);
        }
        Expression::Member { expr: inner, .. }
        | Expression::DerefMember { expr: inner, .. } => {
            collect_vars_in_expr(inner, refs);
        }
        Expression::Ternary { cond, then_expr, else_expr } => {
            collect_vars_in_expr(cond, refs);
            collect_vars_in_expr(then_expr, refs);
            collect_vars_in_expr(else_expr, refs);
        }
        Expression::IntLit(_) | Expression::FloatLit(_) | Expression::StringLit(_)
        | Expression::AddressLit(_) | Expression::Unknown(_) => {}
    }
}

// ─── Formatting Helpers ─────────────────────────────────────────────────────

fn format_data_type(ty: &DataType) -> String {
    match ty {
        DataType::Void => "void".to_string(),
        DataType::Bool => "bool".to_string(),
        DataType::Int { signed, bits } => {
            let prefix = if *signed { "int" } else { "uint" };
            format!("{}{}_t", prefix, bits)
        }
        DataType::Float { bits: 32 } => "float".to_string(),
        DataType::Float { bits: 64 } => "double".to_string(),
        DataType::Float { bits } => format!("float{}", bits),
        DataType::Pointer(inner) => format!("{}*", format_data_type(inner)),
        DataType::Array { element, length } => match length {
            Some(n) => format!("{}[{}]", format_data_type(element), n),
            None => format!("{}[]", format_data_type(element)),
        },
        DataType::Struct { name, .. } => match name {
            Some(n) => format!("struct {}", n),
            None => "struct <anon>".to_string(),
        },
        DataType::Union { name, .. } => match name {
            Some(n) => format!("union {}", n),
            None => "union <anon>".to_string(),
        },
        DataType::FuncPtr { ret, params } => {
            let params_str = params
                .iter()
                .map(format_data_type)
                .collect::<Vec<_>>()
                .join(", ");
            format!("{}(*)({})", format_data_type(ret), params_str)
        }
        DataType::Unknown => "void*".to_string(),
    }
}

fn format_expr(expr: &Expression) -> String {
    match expr {
        Expression::IntLit(v) => format_int_literal(*v),
        Expression::FloatLit(v) => format!("{}", v),
        Expression::StringLit(s) => format!("\"{}\"", s.replace('\\', "\\\\").replace('"', "\\\"")),
        Expression::Var(var) => var.name.clone(),
        Expression::Unary { op, operand } => {
            let op_str = match op {
                UnaryOp::Neg => "-",
                UnaryOp::Not => "!",
                UnaryOp::BitNot => "~",
                UnaryOp::Deref => "*",
                UnaryOp::AddressOf => "&",
                UnaryOp::Cast => "",
            };
            format!("{}({})", op_str, format_expr(operand))
        }
        Expression::Binary { op, lhs, rhs } => {
            let op_str = match op {
                BinaryOp::Add => "+",
                BinaryOp::Sub => "-",
                BinaryOp::Mul => "*",
                BinaryOp::Div => "/",
                BinaryOp::Mod => "%",
                BinaryOp::Shl => "<<",
                BinaryOp::Shr => ">>",
                BinaryOp::Sar => ">>",
                BinaryOp::BitAnd => "&",
                BinaryOp::BitOr => "|",
                BinaryOp::BitXor => "^",
                BinaryOp::Eq => "==",
                BinaryOp::Ne => "!=",
                BinaryOp::Lt => "<",
                BinaryOp::Le => "<=",
                BinaryOp::Gt => ">",
                BinaryOp::Ge => ">=",
                BinaryOp::LogAnd => "&&",
                BinaryOp::LogOr => "||",
            };
            format!("({} {} {})", format_expr(lhs), op_str, format_expr(rhs))
        }
        Expression::Cast { ty, expr: inner } => {
            format!("({})({})", format_data_type(ty), format_expr(inner))
        }
        Expression::Call { target, args } => {
            let args_str = args.iter().map(format_expr).collect::<Vec<_>>().join(", ");
            // When the call target is an address literal, format as sub_<hex>
            let target_str = match target.as_ref() {
                Expression::AddressLit(addr) => format!("sub_{:x}", addr.0),
                _ => format_expr(target),
            };
            format!("{}({})", target_str, args_str)
        }
        Expression::Subscript { base, index } => {
            format!("{}[{}]", format_expr(base), format_expr(index))
        }
        Expression::Member { expr: inner, field } => {
            format!("{}.{}", format_expr(inner), field)
        }
        Expression::DerefMember { expr: inner, field } => {
            format!("{}->{}", format_expr(inner), field)
        }
        Expression::Ternary {
            cond,
            then_expr,
            else_expr,
        } => {
            format!(
                "({} ? {} : {})",
                format_expr(cond),
                format_expr(then_expr),
                format_expr(else_expr)
            )
        }
        Expression::AddressLit(addr) => format!("0x{:x}", addr.0),
        Expression::Unknown(desc) => format!("/* {} */", desc),
    }
}

fn format_int_literal(v: i64) -> String {
    if v >= 16 || v <= -16 {
        format!("0x{:x}", v)
    } else {
        format!("{}", v)
    }
}

fn format_stmt_inline(stmt: &Statement) -> String {
    match stmt {
        Statement::Assign { lhs, rhs } => {
            format!("{} = {}", format_expr(lhs), format_expr(rhs))
        }
        Statement::Expr(expr) => format_expr(expr),
        _ => String::new(),
    }
}

// ─── Debug-Only Output Validation ───────────────────────────────────────────

/// Check whether a position in the source is inside a line comment (after //).
fn is_inside_line_comment(source: &str, pos: usize) -> bool {
    let line_start = source[..pos].rfind('\n').map(|p| p + 1).unwrap_or(0);
    let line_prefix = &source[line_start..pos];
    line_prefix.contains("//")
}

/// Check if a character is a word boundary (not alphanumeric or underscore).
fn is_word_boundary(source: &str, pos: usize, len: usize) -> bool {
    let before_ok = pos == 0
        || !source.as_bytes()[pos - 1].is_ascii_alphanumeric()
            && source.as_bytes()[pos - 1] != b'_';
    let after_pos = pos + len;
    let after_ok = after_pos >= source.len()
        || !source.as_bytes()[after_pos].is_ascii_alphanumeric()
            && source.as_bytes()[after_pos] != b'_';
    before_ok && after_ok
}

/// Validate that emitted pseudo-C output does not contain forbidden patterns.
///
/// Returns a list of violation descriptions. In debug builds this is called
/// automatically after emission; in release builds it is a no-op.
///
/// Forbidden patterns:
/// - `__undef` — should have been replaced by RecoverVariables
/// - `__carry` — should have been eliminated by DCE
/// - `__overflow` — should have been eliminated by DCE
/// - Raw register names (rax, rbx, rcx, rdx, rsp, rbp, rsi, rdi, r8–r15)
///   outside of `//` comments
/// - Mangled Remill names (`_ZN12_GLOBAL__N_1`)
pub fn validate_output(source: &str) -> Vec<String> {
    let mut violations = Vec::new();

    // 1. Forbidden internal tokens
    let forbidden_tokens = ["__undef", "__carry", "__overflow"];
    for token in &forbidden_tokens {
        let mut start = 0;
        while let Some(pos) = source[start..].find(token) {
            let abs_pos = start + pos;
            if !is_inside_line_comment(source, abs_pos) {
                violations.push(format!(
                    "forbidden pattern '{}' found at offset {}",
                    token, abs_pos
                ));
            }
            start = abs_pos + token.len();
        }
    }

    // 2. Mangled Remill names
    let mangled_prefix = "_ZN12_GLOBAL__N_1";
    {
        let mut start = 0;
        while let Some(pos) = source[start..].find(mangled_prefix) {
            let abs_pos = start + pos;
            if !is_inside_line_comment(source, abs_pos) {
                violations.push(format!(
                    "mangled Remill name found at offset {}",
                    abs_pos
                ));
            }
            start = abs_pos + mangled_prefix.len();
        }
    }

    // 3. Raw register names outside comments (case-insensitive, word-boundary)
    let registers = [
        "rax", "rbx", "rcx", "rdx", "rsp", "rbp", "rsi", "rdi",
        "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
    ];
    let lower_source = source.to_ascii_lowercase();
    for reg in &registers {
        let mut start = 0;
        while let Some(pos) = lower_source[start..].find(reg) {
            let abs_pos = start + pos;
            if is_word_boundary(&lower_source, abs_pos, reg.len())
                && !is_inside_line_comment(source, abs_pos)
            {
                let original = &source[abs_pos..abs_pos + reg.len()];
                violations.push(format!(
                    "raw register name '{}' found outside comment at offset {}",
                    original, abs_pos
                ));
            }
            start = abs_pos + reg.len();
        }
    }

    violations
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ast::*;
    use crate::types::Address;

    #[test]
    fn emit_simple_function() {
        let emitter = PseudoCEmitter::new();
        let ast = vec![AstNode::Func(Function {
            name: "sub_401000".to_string(),
            address: Address(0x401000),
            return_type: DataType::Void,
            params: Vec::new(),
            locals: Vec::new(),
            body: vec![Statement::Return(None)],
            calling_convention: None,
            is_variadic: false,
        })];

        let result = emitter.emit(&ast, EmitFormat::PseudoC).unwrap();
        assert!(result.source.contains("void sub_401000(void)"));
        assert!(result.source.contains("return;"));
    }

    #[test]
    fn emit_with_locals() {
        let emitter = PseudoCEmitter::new();
        let ast = vec![AstNode::Func(Function {
            name: "main".to_string(),
            address: Address(0x401000),
            return_type: DataType::Int {
                signed: true,
                bits: 32,
            },
            params: Vec::new(),
            locals: vec![Variable {
                name: "var_8".to_string(),
                ty: DataType::Int {
                    signed: true,
                    bits: 32,
                },
                storage: StorageClass::Stack,
                stack_offset: Some(8),
            }],
            body: vec![Statement::Return(Some(Expression::Var(Variable {
                name: "var_8".to_string(),
                ty: DataType::Int { signed: true, bits: 32 },
                storage: StorageClass::Stack,
                stack_offset: Some(8),
            })))],
            calling_convention: None,
            is_variadic: false,
        })];

        let result = emitter.emit(&ast, EmitFormat::PseudoC).unwrap();
        assert!(result.source.contains("int32_t  var_8;"));
        assert!(result.source.contains("return var_8;"));
    }

    #[test]
    fn rejects_wrong_format() {
        let emitter = PseudoCEmitter::new();
        let result = emitter.emit(&[], EmitFormat::LlvmIr);
        assert!(result.is_err());
    }

    #[test]
    fn call_address_lit_formats_as_sub_hex() {
        // When a Call target is an AddressLit, it should emit sub_<hex> not 0x<hex>
        let call_expr = Expression::Call {
            target: Box::new(Expression::AddressLit(Address(0x141f7939d))),
            args: vec![],
        };
        let result = format_expr(&call_expr);
        assert_eq!(result, "sub_141f7939d()");
    }

    #[test]
    fn call_named_target_unchanged() {
        // When a Call target is a Var (named function), it should stay as-is
        let call_expr = Expression::Call {
            target: Box::new(Expression::Var(Variable {
                name: "printf".to_string(),
                ty: DataType::Unknown,
                storage: StorageClass::Global,
                stack_offset: None,
            })),
            args: vec![Expression::IntLit(42)],
        };
        let result = format_expr(&call_expr);
        assert_eq!(result, "printf(0x2a)");
    }

    #[test]
    fn arithmetic_uses_c_operators() {
        let expr = Expression::Binary {
            op: BinaryOp::Add,
            lhs: Box::new(Expression::Var(Variable {
                name: "a".to_string(),
                ty: DataType::Int { signed: true, bits: 32 },
                storage: StorageClass::Register,
                stack_offset: None,
            })),
            rhs: Box::new(Expression::IntLit(1)),
        };
        let result = format_expr(&expr);
        assert_eq!(result, "(a + 1)");
    }

    // ─── validate_output tests ──────────────────────────────────────────

    #[test]
    fn validate_clean_output() {
        let source = "// Decompiled by HexCore Helix\nvoid main(void) {\n    int32_t var_8;\n    return 0;\n}\n";
        let violations = validate_output(source);
        assert!(violations.is_empty(), "expected no violations, got: {:?}", violations);
    }

    #[test]
    fn validate_detects_undef() {
        let source = "int64_t x = __undef;\n";
        let violations = validate_output(source);
        assert!(violations.iter().any(|v| v.contains("__undef")));
    }

    #[test]
    fn validate_detects_carry() {
        let source = "int64_t c = __carry(a, b);\n";
        let violations = validate_output(source);
        assert!(violations.iter().any(|v| v.contains("__carry")));
    }

    #[test]
    fn validate_detects_overflow() {
        let source = "int64_t o = __overflow(a, b);\n";
        let violations = validate_output(source);
        assert!(violations.iter().any(|v| v.contains("__overflow")));
    }

    #[test]
    fn validate_detects_raw_register() {
        let source = "rax = 0;\n";
        let violations = validate_output(source);
        assert!(violations.iter().any(|v| v.contains("rax")));
    }

    #[test]
    fn validate_ignores_register_in_comment() {
        let source = "    result = 0;  // was rax\n";
        let violations = validate_output(source);
        // rax is inside a comment — should not be flagged
        assert!(
            !violations.iter().any(|v| v.contains("rax")),
            "register in comment should not be flagged: {:?}", violations
        );
    }

    #[test]
    fn validate_detects_mangled_name() {
        let source = "_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_();\n";
        let violations = validate_output(source);
        assert!(violations.iter().any(|v| v.contains("mangled")));
    }

    #[test]
    fn validate_ignores_mangled_in_comment() {
        let source = "// original: _ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_\n";
        let violations = validate_output(source);
        assert!(
            !violations.iter().any(|v| v.contains("mangled")),
            "mangled name in comment should not be flagged: {:?}", violations
        );
    }

    #[test]
    fn validate_register_word_boundary() {
        // "r8" inside "var_r8x" should NOT be flagged (not a word boundary)
        let source = "int64_t var_r8x = 0;\n";
        let violations = validate_output(source);
        assert!(
            !violations.iter().any(|v| v.contains("r8")),
            "r8 inside identifier should not be flagged: {:?}", violations
        );
    }

}
