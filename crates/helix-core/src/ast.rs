//! Abstract Syntax Tree nodes for decompiled code.
//!
//! The AST represents the **output** of the Helix decompilation pipeline —
//! structured, human-readable pseudo-C code reconstructed from the CFG
//! through MLIR progressive lowering.

use crate::types::Address;

// ─── Data Types ────────────────────────────────────────────────────────────────

/// Recovered or inferred data type.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum DataType {
    Void,
    Bool,
    Int {
        signed: bool,
        bits: u16,
    },
    Float {
        bits: u16,
    },
    Pointer(Box<DataType>),
    Array {
        element: Box<DataType>,
        length: Option<u64>,
    },
    Struct {
        name: Option<String>,
        fields: Vec<StructField>,
    },
    Union {
        name: Option<String>,
        variants: Vec<StructField>,
    },
    FuncPtr {
        ret: Box<DataType>,
        params: Vec<DataType>,
    },
    /// Type not yet recovered — placeholder during progressive decompilation.
    Unknown,
}

impl DataType {
    /// Convenience constructors for common types.
    pub fn i8() -> Self {
        DataType::Int {
            signed: true,
            bits: 8,
        }
    }
    pub fn i16() -> Self {
        DataType::Int {
            signed: true,
            bits: 16,
        }
    }
    pub fn i32() -> Self {
        DataType::Int {
            signed: true,
            bits: 32,
        }
    }
    pub fn i64() -> Self {
        DataType::Int {
            signed: true,
            bits: 64,
        }
    }
    pub fn u8() -> Self {
        DataType::Int {
            signed: false,
            bits: 8,
        }
    }
    pub fn u16() -> Self {
        DataType::Int {
            signed: false,
            bits: 16,
        }
    }
    pub fn u32() -> Self {
        DataType::Int {
            signed: false,
            bits: 32,
        }
    }
    pub fn u64() -> Self {
        DataType::Int {
            signed: false,
            bits: 64,
        }
    }
    pub fn f32() -> Self {
        DataType::Float { bits: 32 }
    }
    pub fn f64() -> Self {
        DataType::Float { bits: 64 }
    }
    pub fn ptr(inner: DataType) -> Self {
        DataType::Pointer(Box::new(inner))
    }
}

/// A field within a struct or union.
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct StructField {
    pub name: String,
    pub ty: DataType,
    pub offset: u64,
}

// ─── Variable ──────────────────────────────────────────────────────────────────

/// Storage class for a variable.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum StorageClass {
    /// Local stack variable.
    Stack,
    /// CPU register.
    Register,
    /// Global/static variable.
    Global,
    /// Function parameter.
    Parameter,
}

/// A recovered variable in the decompiled output.
#[derive(Debug, Clone)]
pub struct Variable {
    /// Variable name (recovered from debug info, or synthesized like "var_8").
    pub name: String,
    /// Inferred data type.
    pub ty: DataType,
    /// Storage class.
    pub storage: StorageClass,
    /// Stack offset (if stack variable).
    pub stack_offset: Option<i64>,
}

// ─── Expressions ───────────────────────────────────────────────────────────────

/// Unary operators.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum UnaryOp {
    Neg,
    Not,
    BitNot,
    Deref,
    AddressOf,
    Cast,
}

/// Binary operators.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum BinaryOp {
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

/// An expression in the decompiled AST.
#[derive(Debug, Clone)]
pub enum Expression {
    /// Integer literal.
    IntLit(i64),
    /// Floating-point literal.
    FloatLit(f64),
    /// String literal (recovered from .rodata or equivalent).
    StringLit(String),
    /// Variable reference.
    Var(Variable),
    /// Unary operation.
    Unary {
        op: UnaryOp,
        operand: Box<Expression>,
    },
    /// Binary operation.
    Binary {
        op: BinaryOp,
        lhs: Box<Expression>,
        rhs: Box<Expression>,
    },
    /// Type cast.
    Cast { ty: DataType, expr: Box<Expression> },
    /// Function call.
    Call {
        target: Box<Expression>,
        args: Vec<Expression>,
    },
    /// Array/pointer subscript: base[index].
    Subscript {
        base: Box<Expression>,
        index: Box<Expression>,
    },
    /// Struct member access: expr.field.
    Member {
        expr: Box<Expression>,
        field: String,
    },
    /// Struct pointer member access: expr->field.
    DerefMember {
        expr: Box<Expression>,
        field: String,
    },
    /// Ternary conditional: cond ? then : else.
    Ternary {
        cond: Box<Expression>,
        then_expr: Box<Expression>,
        else_expr: Box<Expression>,
    },
    /// Address literal (e.g., for jump tables).
    AddressLit(Address),
    /// Unrecovered / opaque expression — placeholder during progressive decompilation.
    Unknown(String),
}

// ─── Statements ────────────────────────────────────────────────────────────────

/// A statement in the decompiled AST.
#[derive(Debug, Clone)]
pub enum Statement {
    /// Variable declaration with optional initializer.
    VarDecl {
        var: Variable,
        init: Option<Expression>,
    },
    /// Assignment: lhs = rhs.
    Assign { lhs: Expression, rhs: Expression },
    /// Expression statement (e.g., function call with discarded result).
    Expr(Expression),
    /// Return statement with optional value.
    Return(Option<Expression>),
    /// If-else statement.
    If {
        cond: Expression,
        then_body: Vec<Statement>,
        else_body: Option<Vec<Statement>>,
    },
    /// While loop.
    While {
        cond: Expression,
        body: Vec<Statement>,
    },
    /// Do-while loop.
    DoWhile {
        body: Vec<Statement>,
        cond: Expression,
    },
    /// For loop.
    For {
        init: Option<Box<Statement>>,
        cond: Option<Expression>,
        step: Option<Box<Statement>>,
        body: Vec<Statement>,
    },
    /// Switch statement.
    Switch {
        expr: Expression,
        cases: Vec<SwitchCase>,
        default: Option<Vec<Statement>>,
    },
    /// Break statement.
    Break,
    /// Continue statement.
    Continue,
    /// Goto (when structured control flow recovery fails).
    Goto(String),
    /// Label target for goto.
    Label(String),
    /// Inline assembly (unreconstructable code).
    Asm(String),
    /// Comment injected by the decompiler (e.g., "// xref from 0x401234").
    Comment(String),
}

/// A case in a switch statement.
#[derive(Debug, Clone)]
pub struct SwitchCase {
    pub values: Vec<i64>,
    pub body: Vec<Statement>,
}

// ─── AST Node ──────────────────────────────────────────────────────────────────

/// Top-level AST node — represents a single decompiled entity.
#[derive(Debug, Clone)]
pub enum AstNode {
    /// A decompiled function.
    Func(Function),
    /// A global variable declaration.
    GlobalVar(Variable),
    /// A type definition (struct, union, typedef).
    TypeDef { name: String, ty: DataType },
}

/// A fully decompiled function.
#[derive(Debug, Clone)]
pub struct Function {
    /// Function name.
    pub name: String,
    /// Entry point address.
    pub address: Address,
    /// Return type.
    pub return_type: DataType,
    /// Parameters.
    pub params: Vec<Variable>,
    /// Local variables (excluding parameters).
    pub locals: Vec<Variable>,
    /// Function body as a list of statements.
    pub body: Vec<Statement>,
    /// Calling convention (e.g., "cdecl", "stdcall", "fastcall").
    pub calling_convention: Option<String>,
    /// Whether this function is variadic.
    pub is_variadic: bool,
}
