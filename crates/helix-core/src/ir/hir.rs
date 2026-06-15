//! High-Level Intermediate Representation (HIR).
//!
//! The HIR sits between Remill's decoded instructions (`RemillInsn`) and the
//! final AST output. It provides a **typed, structured** intermediate form
//! that transform passes can reason about without touching raw machine semantics.
//!
//! ## Design
//!
//! - Every value has a [`HirType`] — even if it's `Unknown` initially.
//! - Every node carries a [`Span`] linking back to the original address range.
//! - The HIR is SSA-like: each [`HirVar`] is defined once, used many times.
//! - Transform passes refine types and collapse operations progressively.

use std::fmt;

// ─── Source Span ────────────────────────────────────────────────────────────

/// A source location span tying HIR nodes back to original binary addresses.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct Span {
    /// Start address in the original binary.
    pub start_addr: u64,
    /// End address (exclusive) in the original binary.
    pub end_addr: u64,
}

impl Span {
    pub const UNKNOWN: Span = Span {
        start_addr: 0,
        end_addr: 0,
    };

    pub fn new(start: u64, end: u64) -> Self {
        Span {
            start_addr: start,
            end_addr: end,
        }
    }

    pub fn single(addr: u64) -> Self {
        Span {
            start_addr: addr,
            end_addr: addr,
        }
    }

    pub fn merge(self, other: Span) -> Span {
        if self == Self::UNKNOWN {
            return other;
        }
        if other == Self::UNKNOWN {
            return self;
        }
        Span {
            start_addr: self.start_addr.min(other.start_addr),
            end_addr: self.end_addr.max(other.end_addr),
        }
    }
}

// ─── HIR Types ──────────────────────────────────────────────────────────────

/// Type of an HIR value — progressively refined during analysis.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum HirType {
    /// Not yet determined.
    Unknown,
    /// Void (no value / discarded return).
    Void,
    /// Boolean (1-bit logical value).
    Bool,
    /// Integer type with signedness and width.
    Int { signed: bool, bits: u16 },
    /// Floating-point type with width.
    Float { bits: u16 },
    /// Pointer to another type.
    Pointer(Box<HirType>),
    /// Function pointer with return type and parameter types.
    FuncPtr {
        ret: Box<HirType>,
        params: Vec<HirType>,
    },
    /// Struct with optional name and field types.
    Struct {
        name: Option<String>,
        fields: Vec<HirFieldType>,
    },
    /// Array with element type and optional length.
    Array {
        element: Box<HirType>,
        length: Option<u64>,
    },
}

/// A field in a struct type.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct HirFieldType {
    pub name: String,
    pub ty: HirType,
    pub offset: u64,
}

impl HirType {
    // Common type constructors
    pub fn i8() -> Self {
        HirType::Int {
            signed: true,
            bits: 8,
        }
    }
    pub fn i16() -> Self {
        HirType::Int {
            signed: true,
            bits: 16,
        }
    }
    pub fn i32() -> Self {
        HirType::Int {
            signed: true,
            bits: 32,
        }
    }
    pub fn i64() -> Self {
        HirType::Int {
            signed: true,
            bits: 64,
        }
    }
    pub fn u8() -> Self {
        HirType::Int {
            signed: false,
            bits: 8,
        }
    }
    pub fn u16() -> Self {
        HirType::Int {
            signed: false,
            bits: 16,
        }
    }
    pub fn u32() -> Self {
        HirType::Int {
            signed: false,
            bits: 32,
        }
    }
    pub fn u64() -> Self {
        HirType::Int {
            signed: false,
            bits: 64,
        }
    }
    pub fn ptr(inner: HirType) -> Self {
        HirType::Pointer(Box::new(inner))
    }
    pub fn void_ptr() -> Self {
        HirType::Pointer(Box::new(HirType::Void))
    }

    /// Size in bits, if known.
    pub fn size_bits(&self) -> Option<u16> {
        match self {
            HirType::Bool => Some(1),
            HirType::Int { bits, .. } => Some(*bits),
            HirType::Float { bits } => Some(*bits),
            HirType::Pointer(_) | HirType::FuncPtr { .. } => Some(64), // assume 64-bit target
            _ => None,
        }
    }

    /// Whether this type is fully resolved (no `Unknown` anywhere).
    pub fn is_resolved(&self) -> bool {
        match self {
            HirType::Unknown => false,
            HirType::Pointer(inner) => inner.is_resolved(),
            HirType::FuncPtr { ret, params } => {
                ret.is_resolved() && params.iter().all(|p| p.is_resolved())
            }
            HirType::Struct { fields, .. } => fields.iter().all(|f| f.ty.is_resolved()),
            HirType::Array { element, .. } => element.is_resolved(),
            _ => true,
        }
    }
}

impl fmt::Display for HirType {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            HirType::Unknown => write!(f, "???"),
            HirType::Void => write!(f, "void"),
            HirType::Bool => write!(f, "bool"),
            HirType::Int { signed, bits } => {
                let prefix = if *signed { "int" } else { "uint" };
                write!(f, "{}{}_t", prefix, bits)
            }
            HirType::Float { bits: 32 } => write!(f, "float"),
            HirType::Float { bits: 64 } => write!(f, "double"),
            HirType::Float { bits } => write!(f, "float{}", bits),
            HirType::Pointer(inner) => write!(f, "{}*", inner),
            HirType::FuncPtr { ret, params } => {
                write!(f, "{}(*)(", ret)?;
                for (i, p) in params.iter().enumerate() {
                    if i > 0 {
                        write!(f, ", ")?;
                    }
                    write!(f, "{}", p)?;
                }
                write!(f, ")")
            }
            HirType::Struct { name: Some(n), .. } => write!(f, "struct {}", n),
            HirType::Struct { name: None, .. } => write!(f, "struct <anon>"),
            HirType::Array {
                element,
                length: Some(n),
            } => write!(f, "{}[{}]", element, n),
            HirType::Array {
                element,
                length: None,
            } => write!(f, "{}[]", element),
        }
    }
}

// ─── HIR Variable ───────────────────────────────────────────────────────────

/// Unique variable ID within a function's HIR.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct HirVarId(pub u32);

/// Where a variable lives.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum HirStorage {
    /// Stack-allocated local (with RSP/RBP offset).
    Stack(i64),
    /// Lives in a register.
    Register,
    /// Global/static memory address.
    Global(u64),
    /// Function parameter (argument index).
    Parameter(u8),
    /// Temporary introduced by the decompiler.
    Temporary,
}

/// A variable in the HIR.
#[derive(Debug, Clone)]
pub struct HirVar {
    pub id: HirVarId,
    pub name: String,
    pub ty: HirType,
    pub storage: HirStorage,
    pub span: Span,
}

// ─── HIR Expressions ────────────────────────────────────────────────────────

/// Binary operators.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum HirBinOp {
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    Shl,
    Shr,
    Sar,
    BitAnd,
    BitOr,
    BitXor,
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
    LogAnd,
    LogOr,
}

impl fmt::Display for HirBinOp {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let s = match self {
            HirBinOp::Add => "+",
            HirBinOp::Sub => "-",
            HirBinOp::Mul => "*",
            HirBinOp::Div => "/",
            HirBinOp::Mod => "%",
            HirBinOp::Shl => "<<",
            HirBinOp::Shr => ">>",
            HirBinOp::Sar => ">>",
            HirBinOp::BitAnd => "&",
            HirBinOp::BitOr => "|",
            HirBinOp::BitXor => "^",
            HirBinOp::Eq => "==",
            HirBinOp::Ne => "!=",
            HirBinOp::Lt => "<",
            HirBinOp::Le => "<=",
            HirBinOp::Gt => ">",
            HirBinOp::Ge => ">=",
            HirBinOp::LogAnd => "&&",
            HirBinOp::LogOr => "||",
        };
        write!(f, "{}", s)
    }
}

/// Unary operators.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum HirUnaryOp {
    Neg,
    Not,
    BitNot,
    Deref,
    AddressOf,
}

impl fmt::Display for HirUnaryOp {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let s = match self {
            HirUnaryOp::Neg => "-",
            HirUnaryOp::Not => "!",
            HirUnaryOp::BitNot => "~",
            HirUnaryOp::Deref => "*",
            HirUnaryOp::AddressOf => "&",
        };
        write!(f, "{}", s)
    }
}

/// An expression in the HIR.
#[derive(Debug, Clone)]
pub enum HirExpr {
    /// Integer literal.
    IntLit { value: i64, ty: HirType, span: Span },
    /// Float literal.
    FloatLit { value: f64, ty: HirType, span: Span },
    /// String literal.
    StringLit { value: String, span: Span },
    /// Variable reference.
    Var { id: HirVarId, span: Span },
    /// Binary operation.
    Binary {
        op: HirBinOp,
        lhs: Box<HirExpr>,
        rhs: Box<HirExpr>,
        ty: HirType,
        span: Span,
    },
    /// Unary operation.
    Unary {
        op: HirUnaryOp,
        operand: Box<HirExpr>,
        ty: HirType,
        span: Span,
    },
    /// Type cast.
    Cast {
        expr: Box<HirExpr>,
        to_ty: HirType,
        span: Span,
    },
    /// Function call.
    Call {
        target: Box<HirExpr>,
        args: Vec<HirExpr>,
        ret_ty: HirType,
        span: Span,
    },
    /// Array/pointer subscript: base[index].
    Subscript {
        base: Box<HirExpr>,
        index: Box<HirExpr>,
        ty: HirType,
        span: Span,
    },
    /// Struct field access: expr.field
    FieldAccess {
        expr: Box<HirExpr>,
        field: String,
        field_offset: u64,
        ty: HirType,
        span: Span,
    },
    /// Pointer field access: expr->field
    DerefFieldAccess {
        expr: Box<HirExpr>,
        field: String,
        field_offset: u64,
        ty: HirType,
        span: Span,
    },
    /// Ternary: cond ? then : else
    Ternary {
        cond: Box<HirExpr>,
        then_expr: Box<HirExpr>,
        else_expr: Box<HirExpr>,
        ty: HirType,
        span: Span,
    },
    /// Address literal (jump table, global reference).
    AddrLit { address: u64, span: Span },
    /// Unresolved/opaque expression — placeholder during progressive lowering.
    Unknown { description: String, span: Span },
}

impl HirExpr {
    /// Get the inferred type of this expression.
    ///
    /// Returns an owned `HirType` because some variants (e.g., `StringLit`)
    /// compute their type on the fly. For references to stored types, use
    /// pattern matching directly.
    pub fn ty(&self) -> HirType {
        match self {
            HirExpr::IntLit { ty, .. } => ty.clone(),
            HirExpr::FloatLit { ty, .. } => ty.clone(),
            HirExpr::StringLit { .. } => HirType::ptr(HirType::u8()),
            HirExpr::Var { .. } => HirType::Unknown, // resolved via var table
            HirExpr::Binary { ty, .. } => ty.clone(),
            HirExpr::Unary { ty, .. } => ty.clone(),
            HirExpr::Cast { to_ty, .. } => to_ty.clone(),
            HirExpr::Call { ret_ty, .. } => ret_ty.clone(),
            HirExpr::Subscript { ty, .. } => ty.clone(),
            HirExpr::FieldAccess { ty, .. } => ty.clone(),
            HirExpr::DerefFieldAccess { ty, .. } => ty.clone(),
            HirExpr::Ternary { ty, .. } => ty.clone(),
            HirExpr::AddrLit { .. } => HirType::Unknown,
            HirExpr::Unknown { .. } => HirType::Unknown,
        }
    }

    /// Get the source span.
    pub fn span(&self) -> Span {
        match self {
            HirExpr::IntLit { span, .. }
            | HirExpr::FloatLit { span, .. }
            | HirExpr::StringLit { span, .. }
            | HirExpr::Var { span, .. }
            | HirExpr::Binary { span, .. }
            | HirExpr::Unary { span, .. }
            | HirExpr::Cast { span, .. }
            | HirExpr::Call { span, .. }
            | HirExpr::Subscript { span, .. }
            | HirExpr::FieldAccess { span, .. }
            | HirExpr::DerefFieldAccess { span, .. }
            | HirExpr::Ternary { span, .. }
            | HirExpr::AddrLit { span, .. }
            | HirExpr::Unknown { span, .. } => *span,
        }
    }
}

// ─── HIR Statements ─────────────────────────────────────────────────────────

/// A statement in the HIR.
#[derive(Debug, Clone)]
pub enum HirStmt {
    /// Variable declaration with optional initializer.
    VarDecl {
        var_id: HirVarId,
        init: Option<HirExpr>,
        span: Span,
    },
    /// Assignment: lhs = rhs.
    Assign {
        lhs: HirExpr,
        rhs: HirExpr,
        span: Span,
    },
    /// Expression statement (e.g., discarded call result).
    Expr { expr: HirExpr, span: Span },
    /// Return with optional value.
    Return { value: Option<HirExpr>, span: Span },
    /// If-else.
    If {
        cond: HirExpr,
        then_body: Vec<HirStmt>,
        else_body: Option<Vec<HirStmt>>,
        span: Span,
    },
    /// While loop.
    While {
        cond: HirExpr,
        body: Vec<HirStmt>,
        span: Span,
    },
    /// Do-while loop.
    DoWhile {
        body: Vec<HirStmt>,
        cond: HirExpr,
        span: Span,
    },
    /// For loop.
    For {
        init: Option<Box<HirStmt>>,
        cond: Option<HirExpr>,
        step: Option<Box<HirStmt>>,
        body: Vec<HirStmt>,
        span: Span,
    },
    /// Switch statement.
    Switch {
        expr: HirExpr,
        cases: Vec<HirCase>,
        default: Option<Vec<HirStmt>>,
        span: Span,
    },
    /// Break.
    Break { span: Span },
    /// Continue.
    Continue { span: Span },
    /// Goto (fallback when structured recovery fails).
    Goto { label: String, span: Span },
    /// Label target.
    Label { name: String, span: Span },
    /// Inline assembly (unreconstructable code).
    Asm { text: String, span: Span },
    /// Comment.
    Comment { text: String, span: Span },
}

/// A case in a switch statement.
#[derive(Debug, Clone)]
pub struct HirCase {
    pub values: Vec<i64>,
    pub body: Vec<HirStmt>,
    pub span: Span,
}

// ─── HIR Function ───────────────────────────────────────────────────────────

/// A function in the HIR — the top-level unit of decompiled code.
#[derive(Debug, Clone)]
pub struct HirFunction {
    /// Function name (recovered or synthesized).
    pub name: String,
    /// Entry point address.
    pub address: u64,
    /// Return type.
    pub return_type: HirType,
    /// Parameters.
    pub params: Vec<HirVar>,
    /// Local variables.
    pub locals: Vec<HirVar>,
    /// Function body.
    pub body: Vec<HirStmt>,
    /// Calling convention name (e.g., "win64", "sysv64").
    pub calling_convention: Option<String>,
    /// Whether the function is variadic.
    pub is_variadic: bool,
    /// Source span covering the entire function.
    pub span: Span,
}

// ─── HIR Module ─────────────────────────────────────────────────────────────

/// A module of HIR functions — the output of the lifting + transform pipeline.
#[derive(Debug, Clone)]
pub struct HirModule {
    /// Module/binary name.
    pub name: String,
    /// Architecture string.
    pub arch: String,
    /// All functions in this module.
    pub functions: Vec<HirFunction>,
}

impl HirModule {
    /// Total instruction count across all functions.
    pub fn function_count(&self) -> usize {
        self.functions.len()
    }

    /// Collect all unresolved types in the module (for diagnostic reporting).
    pub fn unresolved_type_count(&self) -> usize {
        let mut count = 0;
        for func in &self.functions {
            if !func.return_type.is_resolved() {
                count += 1;
            }
            for p in &func.params {
                if !p.ty.is_resolved() {
                    count += 1;
                }
            }
            for l in &func.locals {
                if !l.ty.is_resolved() {
                    count += 1;
                }
            }
        }
        count
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn hir_type_display() {
        assert_eq!(HirType::i32().to_string(), "int32_t");
        assert_eq!(HirType::u64().to_string(), "uint64_t");
        assert_eq!(HirType::void_ptr().to_string(), "void*");
        assert_eq!(HirType::ptr(HirType::i8()).to_string(), "int8_t*");
        assert_eq!(HirType::Void.to_string(), "void");
        assert_eq!(HirType::Unknown.to_string(), "???");
    }

    #[test]
    fn hir_type_resolution() {
        assert!(HirType::i32().is_resolved());
        assert!(HirType::void_ptr().is_resolved());
        assert!(!HirType::Unknown.is_resolved());
        assert!(!HirType::ptr(HirType::Unknown).is_resolved());
    }

    #[test]
    fn span_merge() {
        let a = Span::new(0x100, 0x110);
        let b = Span::new(0x108, 0x120);
        let merged = a.merge(b);
        assert_eq!(merged.start_addr, 0x100);
        assert_eq!(merged.end_addr, 0x120);
    }

    #[test]
    fn span_merge_with_unknown() {
        let a = Span::UNKNOWN;
        let b = Span::new(0x100, 0x110);
        assert_eq!(a.merge(b), b);
        assert_eq!(b.merge(a), b);
    }

    #[test]
    fn hir_type_size_bits() {
        assert_eq!(HirType::Bool.size_bits(), Some(1));
        assert_eq!(HirType::i32().size_bits(), Some(32));
        assert_eq!(HirType::i64().size_bits(), Some(64));
        assert_eq!(HirType::void_ptr().size_bits(), Some(64));
        assert_eq!(HirType::Unknown.size_bits(), None);
    }
}
