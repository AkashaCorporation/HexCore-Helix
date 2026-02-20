//! Pseudo-C emitter — concrete implementation of [`Emitter`].
//!
//! Renders AST nodes into human-readable pseudo-C source code
//! with proper indentation, type annotations, and address comments.

use crate::ast::{AstNode, DataType, Expression, Function, Statement, UnaryOp, BinaryOp};
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

        // Local variable declarations
        for local in &func.locals {
            let ty = format_data_type(&local.ty);
            let comment = match local.stack_offset {
                Some(off) => format!("  // [rsp+0x{:x}]", off),
                None => String::new(),
            };
            out.push_str(&format!(
                "{}{}  {};{}\n",
                &self.indent, ty, local.name, comment
            ));
            *line_num += 1;
        }

        if !func.locals.is_empty() {
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
            format!("{}({})", format_expr(target), args_str)
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
            body: vec![Statement::Return(Some(Expression::IntLit(0)))],
            calling_convention: None,
            is_variadic: false,
        })];

        let result = emitter.emit(&ast, EmitFormat::PseudoC).unwrap();
        assert!(result.source.contains("int32_t  var_8;"));
        assert!(result.source.contains("return 0;"));
    }

    #[test]
    fn rejects_wrong_format() {
        let emitter = PseudoCEmitter::new();
        let result = emitter.emit(&[], EmitFormat::LlvmIr);
        assert!(result.is_err());
    }
}
