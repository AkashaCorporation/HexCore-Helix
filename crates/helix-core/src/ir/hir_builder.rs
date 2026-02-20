//! HIR Builder — Converts a [`LiftedModule`] into a [`HirModule`].
//!
//! This is the central lowering step in the Helix pipeline:
//!
//! ```text
//! Remill IR text
//!     │  (parser.rs)
//!     ▼
//! LiftedModule { Vec<RemillInsn> }
//!     │  (hir_builder.rs)  ← this module
//!     ▼
//! HirModule { Vec<HirFunction> }
//!     │  (type_propagation + data_flow)
//!     ▼
//! HirModule (refined types)
//!     │  (hir_emitter.rs)
//!     ▼
//! pseudo-C source text
//! ```
//!
//! ## Design Principles
//!
//! - **Lossless**: Every `RemillInsn` maps to at least one `HirStmt`. Nothing is dropped
//!   silently — unknown semantics become `HirStmt::Comment` with diagnostic text.
//! - **Typed from birth**: Even if we can't determine the exact type, every expression
//!   gets a best-guess `HirType` based on register width and semantic context.
//! - **Address-traced**: Every HIR node carries a [`Span`] linking back to the original PC.
//! - **Stack-aware**: RSP-relative memory accesses are promoted to named local variables.

use std::collections::HashMap;

use crate::ir::hir::*;
use crate::ir::remill::Semantic;
use crate::ir::{LiftedModule, Operand, RemillInsn};

// ─── Builder State ──────────────────────────────────────────────────────────

/// Mutable builder context for a single function being lowered to HIR.
struct FuncBuilder {
    /// Next variable ID to allocate.
    next_var_id: u32,
    /// Mapping from register names to their current HIR variable IDs.
    reg_vars: HashMap<String, HirVarId>,
    /// Mapping from stack offsets to their HIR variable IDs.
    stack_vars: HashMap<i64, HirVarId>,
    /// All declared variables (params + locals + temps).
    vars: Vec<HirVar>,
    /// Accumulated statements.
    body: Vec<HirStmt>,
    /// Function name.
    name: String,
    /// Entry address.
    entry_pc: u64,
}

impl FuncBuilder {
    fn new(name: String, entry_pc: u64) -> Self {
        Self {
            next_var_id: 0,
            reg_vars: HashMap::new(),
            stack_vars: HashMap::new(),
            vars: Vec::new(),
            body: Vec::new(),
            name,
            entry_pc,
        }
    }

    /// Allocate a fresh variable ID.
    fn fresh_id(&mut self) -> HirVarId {
        let id = HirVarId(self.next_var_id);
        self.next_var_id += 1;
        id
    }

    /// Get or create a variable for a CPU register.
    fn reg_var(&mut self, reg: &str, span: Span) -> HirVarId {
        if let Some(&id) = self.reg_vars.get(reg) {
            return id;
        }

        let id = self.fresh_id();
        let ty = type_for_register(reg);
        self.vars.push(HirVar {
            id,
            name: reg.to_lowercase(),
            ty,
            storage: HirStorage::Register,
            span,
        });
        self.reg_vars.insert(reg.to_string(), id);
        id
    }

    /// Get or create a named local for a stack slot.
    fn stack_var(&mut self, offset: i64, size_bits: u32, span: Span) -> HirVarId {
        if let Some(&id) = self.stack_vars.get(&offset) {
            return id;
        }

        let id = self.fresh_id();
        let ty = type_for_width(size_bits);
        self.vars.push(HirVar {
            id,
            name: format!("var_{:x}", offset),
            ty,
            storage: HirStorage::Stack(offset),
            span,
        });
        self.stack_vars.insert(offset, id);
        id
    }

    /// Get or create a temporary variable for an intermediate result.
    #[allow(dead_code)]
    fn temp_var(&mut self, prefix: &str, ty: HirType, span: Span) -> HirVarId {
        let id = self.fresh_id();
        self.vars.push(HirVar {
            id,
            name: format!("{}_{}", prefix, id.0),
            ty,
            storage: HirStorage::Temporary,
            span,
        });
        id
    }

    /// Emit a statement.
    fn emit(&mut self, stmt: HirStmt) {
        self.body.push(stmt);
    }

    /// Partition variables into params and locals.
    fn finalize(self, return_type: HirType) -> HirFunction {
        let params: Vec<HirVar> = self
            .vars
            .iter()
            .filter(|v| matches!(v.storage, HirStorage::Parameter(_)))
            .cloned()
            .collect();
        let locals: Vec<HirVar> = self
            .vars
            .iter()
            .filter(|v| !matches!(v.storage, HirStorage::Parameter(_)))
            .cloned()
            .collect();

        HirFunction {
            name: self.name,
            address: self.entry_pc,
            return_type,
            params,
            locals,
            body: self.body,
            calling_convention: Some("win64".to_string()),
            is_variadic: false,
            span: Span::single(self.entry_pc),
        }
    }
}

// ─── Public API ─────────────────────────────────────────────────────────────

/// Build an [`HirModule`] from a parsed [`LiftedModule`].
///
/// This is a pure transformation — it does not mutate the input, and
/// performs no I/O. All type information is best-effort; the caller
/// should run type propagation afterwards to refine unknowns.
pub fn build_hir(module: &LiftedModule) -> HirModule {
    let functions = split_into_functions(module);

    let hir_functions: Vec<HirFunction> = functions
        .into_iter()
        .map(|func_insns| build_function(func_insns, &module.arch))
        .collect();

    HirModule {
        name: module.source_file.clone(),
        arch: module.arch.clone(),
        functions: hir_functions,
    }
}

// ─── Function Splitting ─────────────────────────────────────────────────────

/// Split a module's instructions into per-function groups using the
/// boundary indices computed by the parser.
fn split_into_functions(module: &LiftedModule) -> Vec<&[RemillInsn]> {
    if module.instructions.is_empty() {
        return Vec::new();
    }

    if module.function_boundaries.len() <= 1 {
        return vec![&module.instructions];
    }

    let mut functions = Vec::new();
    let bounds = &module.function_boundaries;

    for w in bounds.windows(2) {
        if w[0] < module.instructions.len() {
            let end = w[1].min(module.instructions.len());
            functions.push(&module.instructions[w[0]..end]);
        }
    }
    if let Some(&last) = bounds.last() {
        if last < module.instructions.len() {
            functions.push(&module.instructions[last..]);
        }
    }

    functions
}

// ─── Per-Function Lowering ──────────────────────────────────────────────────

/// Lower a slice of `RemillInsn` into a single `HirFunction`.
fn build_function(insns: &[RemillInsn], _arch: &str) -> HirFunction {
    let entry_pc = insns.first().map(|i| i.pc).unwrap_or(0);
    let mut b = FuncBuilder::new(format!("sub_{:x}", entry_pc), entry_pc);

    // First pass: discover stack frame (collect RSP-relative offsets)
    let frame_size = discover_stack_frame(insns, &mut b);

    // Second pass: lower each instruction to HIR
    for insn in insns {
        lower_insn(&mut b, insn);
    }

    // If we detected a stack frame, note it in a comment
    if frame_size > 0 {
        // Insert frame comment at the top of the body
        b.body.insert(
            0,
            HirStmt::Comment {
                text: format!("frame size: {} bytes", frame_size),
                span: Span::single(entry_pc),
            },
        );
    }

    b.finalize(HirType::Void)
}

/// Discover the stack frame by scanning for `SUB RSP, imm` and RSP-relative
/// memory accesses. Pre-creates stack variable entries in the builder.
fn discover_stack_frame(insns: &[RemillInsn], b: &mut FuncBuilder) -> u64 {
    let mut frame_size: u64 = 0;
    let mut offsets: Vec<i64> = Vec::new();

    let collect_offset = |op: &Operand, offsets: &mut Vec<i64>| {
        if let Operand::Mem {
            base,
            disp,
            size_bits,
        } = op
        {
            if base == "RSP" && !offsets.contains(disp) {
                offsets.push(*disp);
                // Record size_bits for later use, but we handle it below
                let _ = size_bits;
            }
        }
    };

    for insn in insns {
        // Detect SUB RSP, imm → frame setup
        if insn.semantic == Semantic::Sub {
            if let Some(Operand::Reg(r)) = &insn.dst {
                if r == "RSP" {
                    if let Some(Operand::Imm(n)) = insn.srcs.last() {
                        frame_size = *n as u64;
                    }
                }
            }
        }

        // Collect RSP-relative memory accesses
        if let Some(dst) = &insn.dst {
            collect_offset(dst, &mut offsets);
        }
        for src in &insn.srcs {
            collect_offset(src, &mut offsets);
        }
    }

    offsets.sort();

    // Pre-create stack variables
    for offset in &offsets {
        // Determine the size from the operand that references this offset
        let size_bits = find_stack_access_size(insns, *offset);
        let span = find_first_access_span(insns, *offset);
        b.stack_var(*offset, size_bits, span);
    }

    frame_size
}

/// Find the bit-width of the operand that accesses a given stack offset.
fn find_stack_access_size(insns: &[RemillInsn], target_offset: i64) -> u32 {
    for insn in insns {
        for op in insn.dst.iter().chain(insn.srcs.iter()) {
            if let Operand::Mem {
                base,
                disp,
                size_bits,
            } = op
            {
                if base == "RSP" && *disp == target_offset {
                    return *size_bits;
                }
            }
        }
    }
    32 // default to 32-bit
}

/// Find the PC of the first instruction that accesses a given stack offset.
fn find_first_access_span(insns: &[RemillInsn], target_offset: i64) -> Span {
    for insn in insns {
        for op in insn.dst.iter().chain(insn.srcs.iter()) {
            if let Operand::Mem { base, disp, .. } = op {
                if base == "RSP" && *disp == target_offset {
                    return Span::single(insn.pc);
                }
            }
        }
    }
    Span::UNKNOWN
}

// ─── Instruction Lowering ───────────────────────────────────────────────────

/// Lower a single `RemillInsn` into one or more `HirStmt`.
fn lower_insn(b: &mut FuncBuilder, insn: &RemillInsn) {
    let span = Span::new(insn.pc, insn.pc + insn.size as u64);

    match &insn.semantic {
        // ── Skip padding ──────────────────────────────────────────────
        Semantic::Nop | Semantic::Int3 => {}

        // ── MOV: dst = src ────────────────────────────────────────────
        Semantic::Mov => {
            if let (Some(lhs), Some(rhs)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_operand_rhs(b, insn.srcs.first(), span),
            ) {
                b.emit(HirStmt::Assign { lhs, rhs, span });
            }
        }

        // ── LEA: dst = &[base + disp] ─────────────────────────────────
        Semantic::Lea => {
            if let (Some(lhs), Some(addr_expr)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_lea_operand(b, insn.srcs.first(), span),
            ) {
                b.emit(HirStmt::Assign {
                    lhs,
                    rhs: addr_expr,
                    span,
                });
            }
        }

        // ── Arithmetic: dst = src1 op src2 ────────────────────────────
        Semantic::Add | Semantic::Sub | Semantic::Xor | Semantic::And | Semantic::Or
        | Semantic::Shl | Semantic::Shr | Semantic::Sar | Semantic::Mul | Semantic::IMul => {
            // Special case: XOR reg, reg → reg = 0 (common zero-idiom)
            if insn.semantic == Semantic::Xor {
                if let (Some(Operand::Reg(r1)), Some(Operand::Reg(r2))) =
                    (&insn.dst, insn.srcs.first())
                {
                    if r1 == r2
                        || (insn.srcs.len() >= 2
                            && matches!(insn.srcs.get(1), Some(Operand::Reg(r3)) if r3 == r1))
                    {
                        if let Some(lhs) = lower_operand_lhs(b, &insn.dst, span) {
                            let ty = type_for_register(r1);
                            b.emit(HirStmt::Assign {
                                lhs,
                                rhs: HirExpr::IntLit { value: 0, ty, span },
                                span,
                            });
                            return;
                        }
                    }
                }
            }

            let hir_op = semantic_to_binop(&insn.semantic);
            if let Some(op) = hir_op {
                if let (Some(lhs), Some(src1), Some(src2)) = (
                    lower_operand_lhs(b, &insn.dst, span),
                    lower_operand_rhs(b, insn.srcs.first(), span),
                    lower_operand_rhs(b, insn.srcs.get(1), span),
                ) {
                    let ty = src1.ty();
                    let rhs = HirExpr::Binary {
                        op,
                        lhs: Box::new(src1),
                        rhs: Box::new(src2),
                        ty,
                        span,
                    };
                    b.emit(HirStmt::Assign { lhs, rhs, span });
                }
            }
        }

        // ── Unary: NEG / NOT ──────────────────────────────────────────
        Semantic::Neg | Semantic::Not => {
            let hir_op = match &insn.semantic {
                Semantic::Neg => HirUnaryOp::Neg,
                Semantic::Not => HirUnaryOp::BitNot,
                _ => unreachable!(),
            };
            if let (Some(lhs), Some(operand)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_operand_rhs(b, insn.srcs.first(), span),
            ) {
                let ty = operand.ty();
                let rhs = HirExpr::Unary {
                    op: hir_op,
                    operand: Box::new(operand),
                    ty,
                    span,
                };
                b.emit(HirStmt::Assign { lhs, rhs, span });
            }
        }

        // ── INC / DEC: dst = src ± 1 ─────────────────────────────────
        Semantic::Inc | Semantic::Dec => {
            let op = if insn.semantic == Semantic::Inc {
                HirBinOp::Add
            } else {
                HirBinOp::Sub
            };
            if let (Some(lhs), Some(src)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_operand_rhs(b, insn.srcs.first(), span),
            ) {
                let ty = src.ty();
                let one = HirExpr::IntLit {
                    value: 1,
                    ty: ty.clone(),
                    span,
                };
                let rhs = HirExpr::Binary {
                    op,
                    lhs: Box::new(src),
                    rhs: Box::new(one),
                    ty,
                    span,
                };
                b.emit(HirStmt::Assign { lhs, rhs, span });
            }
        }

        // ── CALL: v = target(args) ────────────────────────────────────
        Semantic::Call => {
            let target_expr = match insn.srcs.first() {
                Some(Operand::Addr(addr)) => HirExpr::AddrLit {
                    address: *addr,
                    span,
                },
                Some(Operand::Imm(v)) => HirExpr::AddrLit {
                    address: *v as u64,
                    span,
                },
                Some(Operand::Reg(r)) => {
                    let id = b.reg_var(r, span);
                    HirExpr::Var { id, span }
                }
                _ => HirExpr::Unknown {
                    description: "unresolved call target".into(),
                    span,
                },
            };

            // Build the call expression
            let call_expr = HirExpr::Call {
                target: Box::new(target_expr),
                args: Vec::new(), // args resolved later by calling convention analysis
                ret_ty: HirType::Unknown,
                span,
            };

            // Assign result to RAX (Win64 return register)
            let result_var = b.reg_var("RAX", span);
            b.emit(HirStmt::Assign {
                lhs: HirExpr::Var {
                    id: result_var,
                    span,
                },
                rhs: call_expr,
                span,
            });
        }

        // ── RET ───────────────────────────────────────────────────────
        Semantic::Ret => {
            b.emit(HirStmt::Return { value: None, span });
        }

        // ── CMP / TEST: no assignment, but sets condition flags ───────
        Semantic::Cmp | Semantic::Test => {
            // CMP and TEST don't produce visible assignments.
            // The condition they set is consumed by the following Jcc.
            // We emit a comment for traceability; the Jcc handler below
            // will reconstruct the condition expression.
            let op_name = if insn.semantic == Semantic::Cmp {
                "cmp"
            } else {
                "test"
            };
            let desc = format!(
                "{} {}, {}",
                op_name,
                insn.srcs
                    .first()
                    .map(|o| o.to_string())
                    .unwrap_or_default(),
                insn.srcs
                    .get(1)
                    .map(|o| o.to_string())
                    .unwrap_or_default(),
            );
            b.emit(HirStmt::Comment {
                text: desc,
                span,
            });
        }

        // ── Jcc: conditional branch → if ──────────────────────────────
        Semantic::Jcc(cc) => {
            // We lower Jcc into a structured `if` stub. The actual branch
            // target resolution and block structuring happens later when
            // we have the full CFG. For now, emit the condition as a comment.
            let target = insn.srcs.first().map(|o| o.to_string()).unwrap_or_default();
            b.emit(HirStmt::Comment {
                text: format!("{} → {}", cc.to_lowercase(), target),
                span,
            });
        }

        // ── JMP: unconditional branch ─────────────────────────────────
        Semantic::Jmp => {
            let target = insn.srcs.first().map(|o| o.to_string()).unwrap_or_default();
            b.emit(HirStmt::Comment {
                text: format!("jmp → {}", target),
                span,
            });
        }

        // ── PUSH: rsp -= 8; [rsp] = src ──────────────────────────────
        Semantic::Push => {
            if let Some(src) = lower_operand_rhs(b, insn.srcs.first(), span) {
                b.emit(HirStmt::Comment {
                    text: format!("push {}", format_expr_brief(&src)),
                    span,
                });
            }
        }

        // ── POP: dst = [rsp]; rsp += 8 ───────────────────────────────
        Semantic::Pop => {
            if let Some(lhs) = lower_operand_lhs(b, &insn.dst, span) {
                b.emit(HirStmt::Comment {
                    text: format!("pop → {}", format_expr_brief(&lhs)),
                    span,
                });
            }
        }

        // ── DIV / IDIV: complex multi-register output ────────────────
        Semantic::Div | Semantic::IDiv => {
            let op = if insn.semantic == Semantic::Div {
                HirBinOp::Div
            } else {
                HirBinOp::Div // IDIV is signed division; type info handles signedness
            };
            if let (Some(lhs), Some(src1), Some(src2)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_operand_rhs(b, insn.srcs.first(), span),
                lower_operand_rhs(b, insn.srcs.get(1), span),
            ) {
                let ty = src1.ty();
                let rhs = HirExpr::Binary {
                    op,
                    lhs: Box::new(src1),
                    rhs: Box::new(src2),
                    ty,
                    span,
                };
                b.emit(HirStmt::Assign { lhs, rhs, span });
            }
        }

        // ── CMOV: conditional move → dst = cond ? src : dst ──────────
        Semantic::CMov(cc) => {
            if let (Some(lhs), Some(src)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_operand_rhs(b, insn.srcs.first(), span),
            ) {
                // We emit as a ternary: dst = <cc> ? src : dst
                // Since we don't have the actual flag state, emit as a
                // comment + conditional assignment stub for now.
                let ty = src.ty();
                let cond_expr = HirExpr::Unknown {
                    description: format!("flags.{}", cc.to_lowercase()),
                    span,
                };
                let dst_read = lhs.clone();
                let ternary = HirExpr::Ternary {
                    cond: Box::new(cond_expr),
                    then_expr: Box::new(src),
                    else_expr: Box::new(dst_read),
                    ty,
                    span,
                };
                b.emit(HirStmt::Assign {
                    lhs,
                    rhs: ternary,
                    span,
                });
            }
        }

        // ── XCHG: swap two operands ──────────────────────────────────
        Semantic::Xchg => {
            // xchg a, b → tmp = a; a = b; b = tmp
            if let (Some(lhs), Some(rhs)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_operand_rhs(b, insn.srcs.first(), span),
            ) {
                let ty = rhs.ty();
                let tmp_id = b.fresh_id();
                b.vars.push(HirVar {
                    id: tmp_id,
                    name: format!("xchg_tmp_{}", tmp_id.0),
                    ty: ty.clone(),
                    storage: HirStorage::Temporary,
                    span,
                });
                // tmp = dst
                b.emit(HirStmt::Assign {
                    lhs: HirExpr::Var { id: tmp_id, span },
                    rhs: lhs.clone(),
                    span,
                });
                // dst = src
                b.emit(HirStmt::Assign {
                    lhs: lhs.clone(),
                    rhs: rhs.clone(),
                    span,
                });
                // src = tmp (only if src is a valid LHS — i.e., a register)
                let src_as_opt = insn.srcs.first().cloned();
                if let Some(src_lhs) = lower_operand_lhs(b, &src_as_opt, span) {
                    b.emit(HirStmt::Assign {
                        lhs: src_lhs,
                        rhs: HirExpr::Var { id: tmp_id, span },
                        span,
                    });
                }
            }
        }

        // ── MOVZX: zero-extending move → dst = (uint)src ────────────
        Semantic::MovZx => {
            if let (Some(lhs), Some(src)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_operand_rhs(b, insn.srcs.first(), span),
            ) {
                let dst_ty = if let Some(Operand::Reg(r)) = &insn.dst {
                    type_for_register(r)
                } else {
                    HirType::u64()
                };
                let cast = HirExpr::Cast {
                    expr: Box::new(src),
                    to_ty: match dst_ty {
                        HirType::Int { bits, .. } => HirType::Int { signed: false, bits },
                        other => other,
                    },
                    span,
                };
                b.emit(HirStmt::Assign { lhs, rhs: cast, span });
            }
        }

        // ── MOVSX: sign-extending move → dst = (int)src ─────────────
        Semantic::MovSx => {
            if let (Some(lhs), Some(src)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_operand_rhs(b, insn.srcs.first(), span),
            ) {
                let dst_ty = if let Some(Operand::Reg(r)) = &insn.dst {
                    type_for_register(r)
                } else {
                    HirType::i64()
                };
                let cast = HirExpr::Cast {
                    expr: Box::new(src),
                    to_ty: dst_ty,
                    span,
                };
                b.emit(HirStmt::Assign { lhs, rhs: cast, span });
            }
        }

        // ── BSF / BSR: bit scan → intrinsic call ─────────────────────
        Semantic::Bsf | Semantic::Bsr => {
            let intrinsic_name = if insn.semantic == Semantic::Bsf {
                "__builtin_ctz"
            } else {
                "__builtin_clz"
            };
            if let (Some(lhs), Some(src)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_operand_rhs(b, insn.srcs.first(), span),
            ) {
                let ty = src.ty();
                let call = HirExpr::Call {
                    target: Box::new(HirExpr::Unknown {
                        description: intrinsic_name.to_string(),
                        span,
                    }),
                    args: vec![src],
                    ret_ty: ty,
                    span,
                };
                b.emit(HirStmt::Assign { lhs, rhs: call, span });
            }
        }

        // ── BT: bit test → comment (sets CF) ─────────────────────────
        Semantic::Bt => {
            let src1 = insn.srcs.first().map(|o| o.to_string()).unwrap_or_default();
            let src2 = insn.srcs.get(1).map(|o| o.to_string()).unwrap_or_default();
            b.emit(HirStmt::Comment {
                text: format!("bt {}, {}", src1, src2),
                span,
            });
        }

        // ── XADD: exchange and add → tmp = dst; dst += src; src = tmp
        Semantic::XAdd => {
            if let (Some(lhs), Some(src)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_operand_rhs(b, insn.srcs.first(), span),
            ) {
                let ty = src.ty();
                let add = HirExpr::Binary {
                    op: HirBinOp::Add,
                    lhs: Box::new(lhs.clone()),
                    rhs: Box::new(src),
                    ty,
                    span,
                };
                b.emit(HirStmt::Assign { lhs, rhs: add, span });
            }
        }

        // ── BSWAP: byte swap → intrinsic call ───────────────────────
        Semantic::Bswap => {
            if let (Some(lhs), Some(src)) = (
                lower_operand_lhs(b, &insn.dst, span),
                lower_operand_rhs(b, insn.srcs.first(), span),
            ) {
                let ty = src.ty();
                let call = HirExpr::Call {
                    target: Box::new(HirExpr::Unknown {
                        description: "__builtin_bswap".to_string(),
                        span,
                    }),
                    args: vec![src],
                    ret_ty: ty,
                    span,
                };
                b.emit(HirStmt::Assign { lhs, rhs: call, span });
            }
        }

        // ── REP MOVS: memory copy → memcpy intrinsic call ────────
        Semantic::RepMovs => {
            let rdi_id = b.reg_var("RDI", span);
            let rsi_id = b.reg_var("RSI", span);
            let rcx_id = b.reg_var("RCX", span);
            let call = HirExpr::Call {
                target: Box::new(HirExpr::Unknown {
                    description: "memcpy".to_string(),
                    span,
                }),
                args: vec![
                    HirExpr::Var { id: rdi_id, span },
                    HirExpr::Var { id: rsi_id, span },
                    HirExpr::Var { id: rcx_id, span },
                ],
                ret_ty: HirType::void_ptr(),
                span,
            };
            b.emit(HirStmt::Expr { expr: call, span });
        }

        // ── REP STOS: memory set → memset intrinsic call ─────────
        Semantic::RepStos => {
            let rdi_id = b.reg_var("RDI", span);
            let rax_id = b.reg_var("RAX", span);
            let rcx_id = b.reg_var("RCX", span);
            let call = HirExpr::Call {
                target: Box::new(HirExpr::Unknown {
                    description: "memset".to_string(),
                    span,
                }),
                args: vec![
                    HirExpr::Var { id: rdi_id, span },
                    HirExpr::Var { id: rax_id, span },
                    HirExpr::Var { id: rcx_id, span },
                ],
                ret_ty: HirType::void_ptr(),
                span,
            };
            b.emit(HirStmt::Expr { expr: call, span });
        }

        // ── CDQE: sign-extend EAX → RAX ─────────────────────────────
        Semantic::Cdqe => {
            let rax_id = b.reg_var("RAX", span);
            let eax_id = b.reg_var("EAX", span);
            b.emit(HirStmt::Assign {
                lhs: HirExpr::Var { id: rax_id, span },
                rhs: HirExpr::Cast {
                    expr: Box::new(HirExpr::Var { id: eax_id, span }),
                    to_ty: HirType::i64(),
                    span,
                },
                span,
            });
        }

        // ── Unknown semantic → diagnostic comment ─────────────────────
        Semantic::Unknown(name) => {
            b.emit(HirStmt::Comment {
                text: format!("unknown semantic: {}", name),
                span,
            });
        }
    }
}

// ─── Operand Lowering ───────────────────────────────────────────────────────

/// Lower a destination operand into an LHS expression.
fn lower_operand_lhs(
    b: &mut FuncBuilder,
    operand: &Option<Operand>,
    span: Span,
) -> Option<HirExpr> {
    let operand = operand.as_ref()?;
    match operand {
        Operand::Reg(r) => {
            let id = b.reg_var(r, span);
            Some(HirExpr::Var { id, span })
        }
        Operand::Mem {
            base,
            disp,
            size_bits,
        } => {
            if base == "RSP" {
                // Stack variable
                let id = b.stack_var(*disp, *size_bits, span);
                Some(HirExpr::Var { id, span })
            } else {
                // Memory dereference: *(base + disp)
                let base_id = b.reg_var(base, span);
                let base_expr = HirExpr::Var { id: base_id, span };
                if *disp != 0 {
                    let offset_expr = HirExpr::IntLit {
                        value: *disp,
                        ty: HirType::i64(),
                        span,
                    };
                    let addr = HirExpr::Binary {
                        op: HirBinOp::Add,
                        lhs: Box::new(base_expr),
                        rhs: Box::new(offset_expr),
                        ty: HirType::void_ptr(),
                        span,
                    };
                    Some(HirExpr::Unary {
                        op: HirUnaryOp::Deref,
                        operand: Box::new(addr),
                        ty: type_for_width(*size_bits),
                        span,
                    })
                } else {
                    Some(HirExpr::Unary {
                        op: HirUnaryOp::Deref,
                        operand: Box::new(base_expr),
                        ty: type_for_width(*size_bits),
                        span,
                    })
                }
            }
        }
        Operand::Imm(_) => None, // immediates can't be destinations
        Operand::Addr(_) => None, // addresses can't be destinations
    }
}

/// Lower a source operand into an RHS expression.
fn lower_operand_rhs(
    b: &mut FuncBuilder,
    operand: Option<&Operand>,
    span: Span,
) -> Option<HirExpr> {
    let operand = operand?;
    match operand {
        Operand::Reg(r) => {
            let id = b.reg_var(r, span);
            Some(HirExpr::Var { id, span })
        }
        Operand::Imm(v) => Some(HirExpr::IntLit {
            value: *v,
            ty: HirType::i64(),
            span,
        }),
        Operand::Mem {
            base,
            disp,
            size_bits,
        } => {
            if base == "RSP" {
                // Stack variable read
                let id = b.stack_var(*disp, *size_bits, span);
                Some(HirExpr::Var { id, span })
            } else {
                // Memory read: *(base + disp)
                let base_id = b.reg_var(base, span);
                let base_expr = HirExpr::Var { id: base_id, span };
                if *disp != 0 {
                    let offset_expr = HirExpr::IntLit {
                        value: *disp,
                        ty: HirType::i64(),
                        span,
                    };
                    let addr = HirExpr::Binary {
                        op: HirBinOp::Add,
                        lhs: Box::new(base_expr),
                        rhs: Box::new(offset_expr),
                        ty: HirType::void_ptr(),
                        span,
                    };
                    Some(HirExpr::Unary {
                        op: HirUnaryOp::Deref,
                        operand: Box::new(addr),
                        ty: type_for_width(*size_bits),
                        span,
                    })
                } else {
                    Some(HirExpr::Unary {
                        op: HirUnaryOp::Deref,
                        operand: Box::new(base_expr),
                        ty: type_for_width(*size_bits),
                        span,
                    })
                }
            }
        }
        Operand::Addr(a) => Some(HirExpr::AddrLit {
            address: *a,
            span,
        }),
    }
}

/// Lower a LEA source operand into an address expression (no dereference).
fn lower_lea_operand(
    b: &mut FuncBuilder,
    operand: Option<&Operand>,
    span: Span,
) -> Option<HirExpr> {
    let operand = operand?;
    match operand {
        Operand::Mem {
            base,
            disp,
            ..
        } => {
            if base == "RSP" {
                // LEA from stack: address of a local variable
                let id = b.stack_var(*disp, 64, span);
                Some(HirExpr::Unary {
                    op: HirUnaryOp::AddressOf,
                    operand: Box::new(HirExpr::Var { id, span }),
                    ty: HirType::void_ptr(),
                    span,
                })
            } else {
                let base_id = b.reg_var(base, span);
                let base_expr = HirExpr::Var { id: base_id, span };
                if *disp != 0 {
                    let offset_expr = HirExpr::IntLit {
                        value: *disp,
                        ty: HirType::i64(),
                        span,
                    };
                    Some(HirExpr::Binary {
                        op: HirBinOp::Add,
                        lhs: Box::new(base_expr),
                        rhs: Box::new(offset_expr),
                        ty: HirType::void_ptr(),
                        span,
                    })
                } else {
                    Some(base_expr)
                }
            }
        }
        Operand::Addr(a) => Some(HirExpr::AddrLit {
            address: *a,
            span,
        }),
        Operand::Imm(v) => Some(HirExpr::IntLit {
            value: *v,
            ty: HirType::void_ptr(),
            span,
        }),
        Operand::Reg(r) => {
            let id = b.reg_var(r, span);
            Some(HirExpr::Var { id, span })
        }
    }
}

// ─── Helpers ────────────────────────────────────────────────────────────────

/// Map a Remill semantic to the corresponding HIR binary operator.
fn semantic_to_binop(sem: &Semantic) -> Option<HirBinOp> {
    match sem {
        Semantic::Add => Some(HirBinOp::Add),
        Semantic::Sub => Some(HirBinOp::Sub),
        Semantic::Xor => Some(HirBinOp::BitXor),
        Semantic::And => Some(HirBinOp::BitAnd),
        Semantic::Or => Some(HirBinOp::BitOr),
        Semantic::Shl => Some(HirBinOp::Shl),
        Semantic::Shr => Some(HirBinOp::Shr),
        Semantic::Sar => Some(HirBinOp::Sar),
        Semantic::Mul | Semantic::IMul => Some(HirBinOp::Mul),
        _ => None,
    }
}

/// Infer a HirType for a named x86-64 register.
fn type_for_register(reg: &str) -> HirType {
    match reg {
        // 64-bit GP registers
        "RAX" | "RBX" | "RCX" | "RDX" | "RSI" | "RDI" | "RSP" | "RBP" | "R8" | "R9"
        | "R10" | "R11" | "R12" | "R13" | "R14" | "R15" => HirType::i64(),
        // 32-bit sub-registers
        "EAX" | "EBX" | "ECX" | "EDX" | "ESI" | "EDI" | "ESP" | "EBP" | "R8D" | "R9D"
        | "R10D" | "R11D" | "R12D" | "R13D" | "R14D" | "R15D" => HirType::i32(),
        // 16-bit sub-registers
        "AX" | "BX" | "CX" | "DX" | "SI" | "DI" | "SP" | "BP" | "R8W" | "R9W" | "R10W"
        | "R11W" | "R12W" | "R13W" | "R14W" | "R15W" => HirType::i16(),
        // 8-bit sub-registers
        "AL" | "AH" | "BL" | "BH" | "CL" | "CH" | "DL" | "DH" | "SIL" | "DIL" | "SPL"
        | "BPL" | "R8B" | "R9B" | "R10B" | "R11B" | "R12B" | "R13B" | "R14B" | "R15B" => {
            HirType::i8()
        }
        // XMM registers (128-bit, treated as float for now)
        _ if reg.starts_with("XMM") => HirType::Float { bits: 128 },
        // YMM registers (256-bit)
        _ if reg.starts_with("YMM") => HirType::Float { bits: 256 },
        // Unknown register
        _ => HirType::Unknown,
    }
}

/// Map a bit-width to the corresponding integer HirType.
fn type_for_width(bits: u32) -> HirType {
    match bits {
        1 => HirType::Bool,
        8 => HirType::i8(),
        16 => HirType::i16(),
        32 => HirType::i32(),
        64 => HirType::i64(),
        _ => HirType::Int {
            signed: true,
            bits: bits as u16,
        },
    }
}

/// Format an HIR expression for diagnostic output (brief, one-line).
fn format_expr_brief(expr: &HirExpr) -> String {
    match expr {
        HirExpr::Var { id, .. } => format!("v{}", id.0),
        HirExpr::IntLit { value, .. } => {
            if *value >= 16 || *value <= -16 {
                format!("0x{:x}", value)
            } else {
                format!("{}", value)
            }
        }
        HirExpr::AddrLit { address, .. } => format!("sub_{:x}", address),
        _ => "...".to_string(),
    }
}

// ─── Tests ──────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ir::{LiftedModule, Operand, RemillInsn};
    use crate::ir::remill::Semantic;

    fn mk_insn(
        pc: u64,
        size: u32,
        semantic: Semantic,
        dst: Option<Operand>,
        srcs: Vec<Operand>,
    ) -> RemillInsn {
        RemillInsn {
            pc,
            size,
            semantic,
            dst,
            srcs,
            comment: String::new(),
        }
    }

    fn mk_module(insns: Vec<RemillInsn>) -> LiftedModule {
        LiftedModule {
            name: "test".into(),
            entry_address: insns.first().map(|i| i.pc).unwrap_or(0),
            arch: "amd64".into(),
            source_file: "test.exe".into(),
            function_boundaries: vec![0],
            instructions: insns,
        }
    }

    #[test]
    fn build_hir_from_empty_module() {
        let module = mk_module(vec![]);
        let hir = build_hir(&module);
        assert_eq!(hir.functions.len(), 0);
        assert_eq!(hir.name, "test.exe");
        assert_eq!(hir.arch, "amd64");
    }

    #[test]
    fn build_hir_simple_mov() {
        let module = mk_module(vec![mk_insn(
            0x100,
            3,
            Semantic::Mov,
            Some(Operand::Reg("RAX".into())),
            vec![Operand::Imm(42)],
        )]);

        let hir = build_hir(&module);
        assert_eq!(hir.functions.len(), 1);

        let func = &hir.functions[0];
        assert_eq!(func.name, "sub_100");
        assert_eq!(func.address, 0x100);

        // Should have at least one assignment: rax = 42
        let assigns: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Assign { .. }))
            .collect();
        assert_eq!(assigns.len(), 1, "expected one assignment for MOV");
    }

    #[test]
    fn build_hir_arithmetic() {
        let module = mk_module(vec![mk_insn(
            0x200,
            4,
            Semantic::Add,
            Some(Operand::Reg("RAX".into())),
            vec![Operand::Reg("RAX".into()), Operand::Imm(8)],
        )]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        let assigns: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Assign { .. }))
            .collect();
        assert_eq!(assigns.len(), 1);

        // Verify it's a Binary Add
        if let HirStmt::Assign { rhs, .. } = &assigns[0] {
            assert!(
                matches!(rhs, HirExpr::Binary { op: HirBinOp::Add, .. }),
                "expected rhs to be Binary Add, got {:?}",
                rhs
            );
        }
    }

    #[test]
    fn build_hir_call_with_address() {
        let module = mk_module(vec![mk_insn(
            0x300,
            5,
            Semantic::Call,
            Some(Operand::Reg("RAX".into())),
            vec![Operand::Addr(0x140001000)],
        )]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        let assigns: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Assign { .. }))
            .collect();
        assert_eq!(assigns.len(), 1);

        if let HirStmt::Assign { rhs, .. } = &assigns[0] {
            assert!(
                matches!(rhs, HirExpr::Call { .. }),
                "expected Call expr, got {:?}",
                rhs
            );
            if let HirExpr::Call { target, .. } = rhs {
                assert!(
                    matches!(target.as_ref(), HirExpr::AddrLit { address: 0x140001000, .. }),
                    "expected call target 0x140001000"
                );
            }
        }
    }

    #[test]
    fn build_hir_stack_variables() {
        let module = mk_module(vec![
            mk_insn(
                0x400,
                4,
                Semantic::Sub,
                Some(Operand::Reg("RSP".into())),
                vec![Operand::Reg("RSP".into()), Operand::Imm(0x38)],
            ),
            mk_insn(
                0x404,
                5,
                Semantic::Mov,
                Some(Operand::Mem {
                    base: "RSP".into(),
                    disp: 0x20,
                    size_bits: 32,
                }),
                vec![Operand::Imm(1)],
            ),
            mk_insn(
                0x409,
                5,
                Semantic::Mov,
                Some(Operand::Reg("RAX".into())),
                vec![Operand::Mem {
                    base: "RSP".into(),
                    disp: 0x20,
                    size_bits: 32,
                }],
            ),
        ]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        // Should have stack variables
        let stack_locals: Vec<_> = func
            .locals
            .iter()
            .filter(|v| matches!(v.storage, HirStorage::Stack(_)))
            .collect();
        assert!(
            !stack_locals.is_empty(),
            "expected at least one stack local"
        );

        // Check that the stack local is named var_20
        assert!(
            stack_locals.iter().any(|v| v.name == "var_20"),
            "expected var_20 among locals: {:?}",
            stack_locals.iter().map(|v| &v.name).collect::<Vec<_>>()
        );

        // Check frame comment
        let has_frame_comment = func.body.iter().any(|s| {
            matches!(s, HirStmt::Comment { text, .. } if text.contains("frame size"))
        });
        assert!(has_frame_comment, "expected frame size comment");
    }

    #[test]
    fn build_hir_ret() {
        let module = mk_module(vec![mk_insn(0x500, 1, Semantic::Ret, None, vec![])]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        let rets: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Return { .. }))
            .collect();
        assert_eq!(rets.len(), 1, "expected one return statement");
    }

    #[test]
    fn build_hir_multiple_functions() {
        let module = LiftedModule {
            name: "multi".into(),
            entry_address: 0x100,
            arch: "amd64".into(),
            source_file: "test.exe".into(),
            function_boundaries: vec![0, 3],
            instructions: vec![
                mk_insn(
                    0x100,
                    3,
                    Semantic::Mov,
                    Some(Operand::Reg("RAX".into())),
                    vec![Operand::Imm(1)],
                ),
                mk_insn(0x103, 1, Semantic::Ret, None, vec![]),
                mk_insn(0x104, 1, Semantic::Int3, None, vec![]),
                // Second function
                mk_insn(
                    0x200,
                    3,
                    Semantic::Mov,
                    Some(Operand::Reg("RCX".into())),
                    vec![Operand::Imm(99)],
                ),
                mk_insn(0x203, 1, Semantic::Ret, None, vec![]),
            ],
        };

        let hir = build_hir(&module);
        assert_eq!(hir.functions.len(), 2, "expected 2 functions");
        assert_eq!(hir.functions[0].name, "sub_100");
        assert_eq!(hir.functions[1].name, "sub_200");
    }

    #[test]
    fn build_hir_lea_stack() {
        let module = mk_module(vec![mk_insn(
            0x600,
            4,
            Semantic::Lea,
            Some(Operand::Reg("RCX".into())),
            vec![Operand::Mem {
                base: "RSP".into(),
                disp: 0x30,
                size_bits: 64,
            }],
        )]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        // LEA from stack should produce an AddressOf expression
        let assigns: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Assign { .. }))
            .collect();
        assert_eq!(assigns.len(), 1);

        if let HirStmt::Assign { rhs, .. } = &assigns[0] {
            assert!(
                matches!(rhs, HirExpr::Unary { op: HirUnaryOp::AddressOf, .. }),
                "expected AddressOf for LEA from stack, got {:?}",
                rhs
            );
        }
    }

    #[test]
    fn build_hir_unknown_semantic() {
        let module = mk_module(vec![mk_insn(
            0x700,
            3,
            Semantic::Unknown("CPUID".into()),
            None,
            vec![],
        )]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        let comments: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Comment { text, .. } if text.contains("CPUID")))
            .collect();
        assert_eq!(comments.len(), 1, "expected comment for unknown semantic");
    }

    #[test]
    fn register_typing_correctness() {
        assert_eq!(type_for_register("RAX"), HirType::i64());
        assert_eq!(type_for_register("EAX"), HirType::i32());
        assert_eq!(type_for_register("AX"), HirType::i16());
        assert_eq!(type_for_register("AL"), HirType::i8());
        assert_eq!(type_for_register("R15"), HirType::i64());
        assert_eq!(type_for_register("R15D"), HirType::i32());
    }

    #[test]
    fn type_for_width_correctness() {
        assert_eq!(type_for_width(1), HirType::Bool);
        assert_eq!(type_for_width(8), HirType::i8());
        assert_eq!(type_for_width(16), HirType::i16());
        assert_eq!(type_for_width(32), HirType::i32());
        assert_eq!(type_for_width(64), HirType::i64());
    }

    #[test]
    fn build_hir_cmov() {
        let module = mk_module(vec![mk_insn(
            0x800,
            4,
            Semantic::CMov("E".into()),
            Some(Operand::Reg("RAX".into())),
            vec![Operand::Reg("RBX".into())],
        )]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        let assigns: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Assign { .. }))
            .collect();
        assert_eq!(assigns.len(), 1, "CMOV should produce one assignment");

        if let HirStmt::Assign { rhs, .. } = &assigns[0] {
            assert!(
                matches!(rhs, HirExpr::Ternary { .. }),
                "CMOV should produce a ternary expression, got {:?}",
                rhs
            );
        }
    }

    #[test]
    fn build_hir_movzx() {
        let module = mk_module(vec![mk_insn(
            0x900,
            3,
            Semantic::MovZx,
            Some(Operand::Reg("RAX".into())),
            vec![Operand::Reg("CL".into())],
        )]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        let assigns: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Assign { .. }))
            .collect();
        assert_eq!(assigns.len(), 1, "MOVZX should produce one assignment");

        if let HirStmt::Assign { rhs, .. } = &assigns[0] {
            assert!(
                matches!(rhs, HirExpr::Cast { .. }),
                "MOVZX should produce a Cast expression, got {:?}",
                rhs
            );
            if let HirExpr::Cast { to_ty, .. } = rhs {
                // Should be unsigned (zero-extend)
                assert!(
                    matches!(to_ty, HirType::Int { signed: false, .. }),
                    "MOVZX cast should be unsigned, got {:?}",
                    to_ty
                );
            }
        }
    }

    #[test]
    fn build_hir_movsx() {
        let module = mk_module(vec![mk_insn(
            0xA00,
            3,
            Semantic::MovSx,
            Some(Operand::Reg("RAX".into())),
            vec![Operand::Reg("EAX".into())],
        )]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        let assigns: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Assign { .. }))
            .collect();
        assert_eq!(assigns.len(), 1, "MOVSX should produce one assignment");

        if let HirStmt::Assign { rhs, .. } = &assigns[0] {
            assert!(
                matches!(rhs, HirExpr::Cast { .. }),
                "MOVSX should produce a Cast expression, got {:?}",
                rhs
            );
            if let HirExpr::Cast { to_ty, .. } = rhs {
                // Should be signed (sign-extend)
                assert!(
                    matches!(to_ty, HirType::Int { signed: true, bits: 64 }),
                    "MOVSX cast should be signed int64, got {:?}",
                    to_ty
                );
            }
        }
    }

    #[test]
    fn build_hir_bsf() {
        let module = mk_module(vec![mk_insn(
            0xB00,
            4,
            Semantic::Bsf,
            Some(Operand::Reg("RAX".into())),
            vec![Operand::Reg("RBX".into())],
        )]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        let assigns: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Assign { .. }))
            .collect();
        assert_eq!(assigns.len(), 1, "BSF should produce one assignment");

        if let HirStmt::Assign { rhs, .. } = &assigns[0] {
            assert!(
                matches!(rhs, HirExpr::Call { .. }),
                "BSF should produce a Call expression (intrinsic), got {:?}",
                rhs
            );
        }
    }

    #[test]
    fn build_hir_xchg() {
        let module = mk_module(vec![mk_insn(
            0xC00,
            3,
            Semantic::Xchg,
            Some(Operand::Reg("RAX".into())),
            vec![Operand::Reg("RBX".into())],
        )]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        // XCHG should produce 3 assignments: tmp=a, a=b, b=tmp
        let assigns: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Assign { .. }))
            .collect();
        assert_eq!(assigns.len(), 3, "XCHG should produce 3 assignments");
    }

    #[test]
    fn build_hir_rep_movs() {
        let module = mk_module(vec![mk_insn(
            0xD00,
            2,
            Semantic::RepMovs,
            None,
            vec![],
        )]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        // REP MOVS should produce a memcpy call expression statement
        let exprs: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Expr { .. }))
            .collect();
        assert_eq!(exprs.len(), 1, "REP MOVS should produce memcpy call expr");

        if let HirStmt::Expr { expr, .. } = &exprs[0] {
            assert!(
                matches!(expr, HirExpr::Call { .. }),
                "REP MOVS should produce a Call expression, got {:?}",
                expr
            );
            if let HirExpr::Call { args, .. } = expr {
                assert_eq!(args.len(), 3, "memcpy should have 3 args (rdi, rsi, rcx)");
            }
        }
    }

    #[test]
    fn build_hir_bswap() {
        let module = mk_module(vec![mk_insn(
            0xE00,
            3,
            Semantic::Bswap,
            Some(Operand::Reg("RAX".into())),
            vec![Operand::Reg("RAX".into())],
        )]);

        let hir = build_hir(&module);
        let func = &hir.functions[0];

        let assigns: Vec<_> = func
            .body
            .iter()
            .filter(|s| matches!(s, HirStmt::Assign { .. }))
            .collect();
        assert_eq!(assigns.len(), 1, "BSWAP should produce one assignment");

        if let HirStmt::Assign { rhs, .. } = &assigns[0] {
            assert!(
                matches!(rhs, HirExpr::Call { .. }),
                "BSWAP should produce a Call expression (intrinsic), got {:?}",
                rhs
            );
        }
    }
}
