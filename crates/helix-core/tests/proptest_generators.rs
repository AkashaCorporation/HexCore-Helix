//! Shared proptest generators for helix-core property-based tests.
//!
//! Provides reusable strategies for generating random IR and HIR types
//! used across multiple property tests (Properties 1–22).

#![allow(dead_code)]

use proptest::prelude::*;

use helix_core::ir::hir::{
    HirBinOp, HirCase, HirExpr, HirFunction, HirModule, HirStmt, HirStorage, HirType,
    HirUnaryOp, HirVar, HirVarId, Span,
};
use helix_core::ir::remill::Semantic;
use helix_core::ir::{LiftedModule, Operand, RemillInsn};

// ─── Operand ────────────────────────────────────────────────────────────────

/// Generates a random `Operand`.
pub fn arb_operand() -> impl Strategy<Value = Operand> {
    prop_oneof![
        // Reg: pick from common x86-64 register names
        prop::sample::select(&[
            "RAX", "RBX", "RCX", "RDX", "RSI", "RDI", "RSP", "RBP",
            "R8", "R9", "R10", "R11", "R12", "R13", "R14", "R15",
        ])
        .prop_map(|r| Operand::Reg(r.to_string())),
        // Imm: arbitrary i64
        any::<i64>().prop_map(Operand::Imm),
        // Mem: base register + displacement + size
        (
            prop::sample::select(&["RAX", "RBX", "RCX", "RDX", "RSP", "RBP"]),
            -4096i64..4096i64,
            prop::sample::select(&[8u32, 16, 32, 64]),
        )
            .prop_map(|(base, disp, size_bits)| Operand::Mem {
                base: base.to_string(),
                disp,
                size_bits,
            }),
        // Addr: arbitrary u64 address
        any::<u64>().prop_map(Operand::Addr),
    ]
}

// ─── Semantic ───────────────────────────────────────────────────────────────

/// Generates a random `Semantic` variant.
fn arb_semantic() -> impl Strategy<Value = Semantic> {
    prop_oneof![
        Just(Semantic::Mov),
        Just(Semantic::Add),
        Just(Semantic::Sub),
        Just(Semantic::Xor),
        Just(Semantic::And),
        Just(Semantic::Or),
        Just(Semantic::Shl),
        Just(Semantic::Shr),
        Just(Semantic::Sar),
        Just(Semantic::Lea),
        Just(Semantic::Call),
        Just(Semantic::Ret),
        Just(Semantic::Push),
        Just(Semantic::Pop),
        Just(Semantic::Cmp),
        Just(Semantic::Test),
        Just(Semantic::Nop),
        Just(Semantic::Int3),
        Just(Semantic::Mul),
        Just(Semantic::IMul),
        Just(Semantic::Div),
        Just(Semantic::IDiv),
        Just(Semantic::Neg),
        Just(Semantic::Not),
        Just(Semantic::Inc),
        Just(Semantic::Dec),
        Just(Semantic::Jmp),
        prop::sample::select(&["E", "NE", "B", "A", "L", "G", "LE", "GE"])
            .prop_map(|cc| Semantic::Jcc(cc.to_string())),
        prop::sample::select(&["E", "NE", "B", "A", "L", "G"])
            .prop_map(|cc| Semantic::CMov(cc.to_string())),
        Just(Semantic::Xchg),
        Just(Semantic::MovZx),
        Just(Semantic::MovSx),
        Just(Semantic::Bsf),
        Just(Semantic::Bsr),
        Just(Semantic::Bt),
        Just(Semantic::XAdd),
        Just(Semantic::Bswap),
        Just(Semantic::RepMovs),
        Just(Semantic::RepStos),
        Just(Semantic::Cdqe),
        "[a-zA-Z_]{1,8}".prop_map(Semantic::Unknown),
    ]
}

// ─── RemillInsn ─────────────────────────────────────────────────────────────

/// Generates a random `RemillInsn`.
pub fn arb_remill_insn() -> impl Strategy<Value = RemillInsn> {
    (
        any::<u64>(),                                   // pc
        1u32..16u32,                                    // size
        arb_semantic(),                                 // semantic
        prop::option::of(arb_operand()),                // dst
        prop::collection::vec(arb_operand(), 0..4),     // srcs
        "[a-zA-Z0-9_ ]{0,32}",                         // comment
    )
        .prop_map(|(pc, size, semantic, dst, srcs, comment)| RemillInsn {
            pc,
            size,
            semantic,
            dst,
            srcs,
            comment,
        })
}

// ─── Span ───────────────────────────────────────────────────────────────────

/// Generates a random `Span`.
pub fn arb_span() -> impl Strategy<Value = Span> {
    (0u64..0xFFFF_FFFF, 0u64..0xFFFF_FFFF).prop_map(|(a, b)| {
        let start = a.min(b);
        let end = a.max(b);
        Span::new(start, end)
    })
}

// ─── HirType ────────────────────────────────────────────────────────────────

/// Generates a random `HirType` (non-recursive leaf types only for simplicity).
fn arb_hir_type_leaf() -> impl Strategy<Value = HirType> {
    prop_oneof![
        Just(HirType::Unknown),
        Just(HirType::Void),
        Just(HirType::Bool),
        (prop::bool::ANY, prop::sample::select(&[8u16, 16, 32, 64]))
            .prop_map(|(signed, bits)| HirType::Int { signed, bits }),
        prop::sample::select(&[32u16, 64]).prop_map(|bits| HirType::Float { bits }),
    ]
}

/// Generates a `HirType` with optional pointer wrapping (max 1 level).
fn arb_hir_type() -> impl Strategy<Value = HirType> {
    arb_hir_type_leaf().prop_flat_map(|inner| {
        prop_oneof![
            Just(inner.clone()),
            Just(HirType::Pointer(Box::new(inner))),
        ]
    })
}

// ─── HirVarId / HirVar ─────────────────────────────────────────────────────

fn arb_var_id() -> impl Strategy<Value = HirVarId> {
    (0u32..1000).prop_map(HirVarId)
}

fn arb_hir_storage() -> impl Strategy<Value = HirStorage> {
    prop_oneof![
        (-256i64..256i64).prop_map(HirStorage::Stack),
        Just(HirStorage::Register),
        any::<u64>().prop_map(HirStorage::Global),
        (0u8..8).prop_map(HirStorage::Parameter),
        Just(HirStorage::Temporary),
    ]
}

fn arb_hir_var() -> impl Strategy<Value = HirVar> {
    (arb_var_id(), "[a-z_]{1,8}", arb_hir_type(), arb_hir_storage(), arb_span()).prop_map(
        |(id, name, ty, storage, span)| HirVar {
            id,
            name,
            ty,
            storage,
            span,
        },
    )
}

// ─── HirBinOp / HirUnaryOp ─────────────────────────────────────────────────

fn arb_bin_op() -> impl Strategy<Value = HirBinOp> {
    prop_oneof![
        Just(HirBinOp::Add),
        Just(HirBinOp::Sub),
        Just(HirBinOp::Mul),
        Just(HirBinOp::Div),
        Just(HirBinOp::Mod),
        Just(HirBinOp::Shl),
        Just(HirBinOp::Shr),
        Just(HirBinOp::Sar),
        Just(HirBinOp::BitAnd),
        Just(HirBinOp::BitOr),
        Just(HirBinOp::BitXor),
        Just(HirBinOp::Eq),
        Just(HirBinOp::Ne),
        Just(HirBinOp::Lt),
        Just(HirBinOp::Le),
        Just(HirBinOp::Gt),
        Just(HirBinOp::Ge),
        Just(HirBinOp::LogAnd),
        Just(HirBinOp::LogOr),
    ]
}

fn arb_unary_op() -> impl Strategy<Value = HirUnaryOp> {
    prop_oneof![
        Just(HirUnaryOp::Neg),
        Just(HirUnaryOp::Not),
        Just(HirUnaryOp::BitNot),
        Just(HirUnaryOp::Deref),
        Just(HirUnaryOp::AddressOf),
    ]
}

// ─── HirExpr (recursive with depth limit) ──────────────────────────────────

/// Generates a leaf `HirExpr` (no recursion).
fn arb_hir_expr_leaf() -> impl Strategy<Value = HirExpr> {
    prop_oneof![
        // IntLit
        (any::<i64>(), arb_hir_type(), arb_span())
            .prop_map(|(value, ty, span)| HirExpr::IntLit { value, ty, span }),
        // FloatLit
        (-1e6f64..1e6f64, arb_hir_type(), arb_span())
            .prop_map(|(value, ty, span)| HirExpr::FloatLit { value, ty, span }),
        // StringLit
        ("[a-zA-Z0-9 ]{0,16}", arb_span())
            .prop_map(|(value, span)| HirExpr::StringLit { value, span }),
        // Var
        (arb_var_id(), arb_span()).prop_map(|(id, span)| HirExpr::Var { id, span }),
        // AddrLit
        (any::<u64>(), arb_span()).prop_map(|(address, span)| HirExpr::AddrLit { address, span }),
        // Unknown
        ("[a-z_]{1,12}", arb_span())
            .prop_map(|(description, span)| HirExpr::Unknown { description, span }),
    ]
}

/// Generates a random `HirExpr` with bounded recursion depth (max 3 levels).
pub fn arb_hir_expr() -> impl Strategy<Value = HirExpr> {
    arb_hir_expr_leaf().prop_recursive(
        3,   // max depth
        64,  // max nodes
        10,  // items per collection
        |inner| {
            prop_oneof![
                // Binary
                (arb_bin_op(), inner.clone(), inner.clone(), arb_hir_type(), arb_span())
                    .prop_map(|(op, lhs, rhs, ty, span)| HirExpr::Binary {
                        op,
                        lhs: Box::new(lhs),
                        rhs: Box::new(rhs),
                        ty,
                        span,
                    }),
                // Unary
                (arb_unary_op(), inner.clone(), arb_hir_type(), arb_span())
                    .prop_map(|(op, operand, ty, span)| HirExpr::Unary {
                        op,
                        operand: Box::new(operand),
                        ty,
                        span,
                    }),
                // Cast
                (inner.clone(), arb_hir_type(), arb_span())
                    .prop_map(|(expr, to_ty, span)| HirExpr::Cast {
                        expr: Box::new(expr),
                        to_ty,
                        span,
                    }),
                // Call (0..3 args)
                (inner.clone(), prop::collection::vec(inner.clone(), 0..3), arb_hir_type(), arb_span())
                    .prop_map(|(target, args, ret_ty, span)| HirExpr::Call {
                        target: Box::new(target),
                        args,
                        ret_ty,
                        span,
                    }),
                // Subscript
                (inner.clone(), inner.clone(), arb_hir_type(), arb_span())
                    .prop_map(|(base, index, ty, span)| HirExpr::Subscript {
                        base: Box::new(base),
                        index: Box::new(index),
                        ty,
                        span,
                    }),
                // FieldAccess
                (inner.clone(), "[a-z]{1,8}", 0u64..256, arb_hir_type(), arb_span())
                    .prop_map(|(expr, field, field_offset, ty, span)| HirExpr::FieldAccess {
                        expr: Box::new(expr),
                        field,
                        field_offset,
                        ty,
                        span,
                    }),
                // DerefFieldAccess
                (inner.clone(), "[a-z]{1,8}", 0u64..256, arb_hir_type(), arb_span())
                    .prop_map(|(expr, field, field_offset, ty, span)| HirExpr::DerefFieldAccess {
                        expr: Box::new(expr),
                        field,
                        field_offset,
                        ty,
                        span,
                    }),
                // Ternary
                (inner.clone(), inner.clone(), inner.clone(), arb_hir_type(), arb_span())
                    .prop_map(|(cond, then_expr, else_expr, ty, span)| HirExpr::Ternary {
                        cond: Box::new(cond),
                        then_expr: Box::new(then_expr),
                        else_expr: Box::new(else_expr),
                        ty,
                        span,
                    }),
            ]
        },
    )
}


// ─── HirStmt ────────────────────────────────────────────────────────────────

/// Generates a random `HirStmt` (non-recursive variants only for leaf level).
fn arb_hir_stmt_leaf() -> impl Strategy<Value = HirStmt> {
    prop_oneof![
        // VarDecl
        (arb_var_id(), prop::option::of(arb_hir_expr_leaf()), arb_span())
            .prop_map(|(var_id, init, span)| HirStmt::VarDecl { var_id, init, span }),
        // Assign
        (arb_hir_expr_leaf(), arb_hir_expr_leaf(), arb_span())
            .prop_map(|(lhs, rhs, span)| HirStmt::Assign { lhs, rhs, span }),
        // Expr
        (arb_hir_expr_leaf(), arb_span())
            .prop_map(|(expr, span)| HirStmt::Expr { expr, span }),
        // Return
        (prop::option::of(arb_hir_expr_leaf()), arb_span())
            .prop_map(|(value, span)| HirStmt::Return { value, span }),
        // Break
        arb_span().prop_map(|span| HirStmt::Break { span }),
        // Continue
        arb_span().prop_map(|span| HirStmt::Continue { span }),
        // Goto
        ("[a-z_]{1,8}", arb_span())
            .prop_map(|(label, span)| HirStmt::Goto { label, span }),
        // Label
        ("[a-z_]{1,8}", arb_span())
            .prop_map(|(name, span)| HirStmt::Label { name, span }),
        // Asm
        ("[a-z0-9 ]{1,16}", arb_span())
            .prop_map(|(text, span)| HirStmt::Asm { text, span }),
        // Comment
        ("[a-zA-Z0-9 ]{1,32}", arb_span())
            .prop_map(|(text, span)| HirStmt::Comment { text, span }),
    ]
}

/// Generates a random `HirStmt` including compound statements (if, while, etc.)
/// with bounded depth.
pub fn arb_hir_stmt() -> impl Strategy<Value = HirStmt> {
    arb_hir_stmt_leaf().prop_recursive(
        2,   // max depth
        32,  // max nodes
        8,   // items per collection
        |inner| {
            prop_oneof![
                // If (with optional else)
                (
                    arb_hir_expr_leaf(),
                    prop::collection::vec(inner.clone(), 0..4),
                    prop::option::of(prop::collection::vec(inner.clone(), 0..4)),
                    arb_span(),
                )
                    .prop_map(|(cond, then_body, else_body, span)| HirStmt::If {
                        cond,
                        then_body,
                        else_body,
                        span,
                    }),
                // While
                (
                    arb_hir_expr_leaf(),
                    prop::collection::vec(inner.clone(), 0..4),
                    arb_span(),
                )
                    .prop_map(|(cond, body, span)| HirStmt::While { cond, body, span }),
                // DoWhile
                (
                    prop::collection::vec(inner.clone(), 0..4),
                    arb_hir_expr_leaf(),
                    arb_span(),
                )
                    .prop_map(|(body, cond, span)| HirStmt::DoWhile { body, cond, span }),
                // Switch (1..3 cases)
                (
                    arb_hir_expr_leaf(),
                    prop::collection::vec(
                        (
                            prop::collection::vec(any::<i64>(), 1..3),
                            prop::collection::vec(inner.clone(), 0..3),
                            arb_span(),
                        )
                            .prop_map(|(values, body, span)| HirCase { values, body, span }),
                        1..3,
                    ),
                    prop::option::of(prop::collection::vec(inner.clone(), 0..3)),
                    arb_span(),
                )
                    .prop_map(|(expr, cases, default, span)| HirStmt::Switch {
                        expr,
                        cases,
                        default,
                        span,
                    }),
                // Leaf statements (pass-through)
                inner,
            ]
        },
    )
}

// ─── HirFunction ────────────────────────────────────────────────────────────

/// Generates a random `HirFunction`.
pub fn arb_hir_function() -> impl Strategy<Value = HirFunction> {
    (
        "func_[a-z0-9]{1,8}",                              // name
        any::<u64>(),                                       // address
        arb_hir_type(),                                     // return_type
        prop::collection::vec(arb_hir_var(), 0..4),         // params
        prop::collection::vec(arb_hir_var(), 0..8),         // locals
        prop::collection::vec(arb_hir_stmt_leaf(), 0..8),   // body (leaf stmts for speed)
        prop::option::of(prop::sample::select(&["win64", "sysv64"])),
        prop::bool::ANY,                                    // is_variadic
        arb_span(),                                         // span
    )
        .prop_map(
            |(name, address, return_type, params, locals, body, cc, is_variadic, span)| {
                HirFunction {
                    name,
                    address,
                    return_type,
                    params,
                    locals,
                    body,
                    calling_convention: cc.map(|s| s.to_string()),
                    is_variadic,
                    span,
                }
            },
        )
}

// ─── HirModule ──────────────────────────────────────────────────────────────

/// Generates a random `HirModule`.
pub fn arb_hir_module() -> impl Strategy<Value = HirModule> {
    (
        "[a-z_]{1,12}",                                     // name
        prop::sample::select(&["x86_64", "aarch64", "amd64"]),  // arch
        prop::collection::vec(arb_hir_function(), 1..4),    // functions
    )
        .prop_map(|(name, arch, functions)| HirModule {
            name,
            arch: arch.to_string(),
            functions,
        })
}

// ─── LiftedModule ───────────────────────────────────────────────────────────

/// Generates a random `LiftedModule`.
pub fn arb_lifted_module() -> impl Strategy<Value = LiftedModule> {
    (
        "[a-z_]{1,12}",                                         // name
        any::<u64>(),                                           // entry_address
        prop::sample::select(&["x86_64", "aarch64", "amd64"]), // arch
        "[a-z_]{1,12}\\.exe",                                   // source_file
        prop::collection::vec(arb_remill_insn(), 1..16),        // instructions
    )
        .prop_map(|(name, entry_address, arch, source_file, instructions)| {
            LiftedModule {
                name,
                entry_address,
                arch: arch.to_string(),
                source_file,
                instructions,
                function_boundaries: vec![],
                register_metadata: std::collections::HashMap::new(),
                target_triple: String::new(),
                declared_intrinsics: Vec::new(),
            }
        })
}
