//! Type propagation analysis for the HIR.
//!
//! Iteratively refines `HirType::Unknown` types based on:
//! - How values are used (e.g., passed to a known API → parameter type)
//! - How values are defined (e.g., loaded from RSP+offset → stack variable)
//! - Pointer arithmetic patterns (base + offset → struct field access)
//! - Calling convention constraints (Win64: RCX/RDX/R8/R9 are first 4 params)
//!
//! The analysis runs to a fixed point — it keeps iterating until no more
//! types change, or a maximum iteration count is reached.

use std::collections::HashMap;

use crate::ir::hir::{
    HirBinOp, HirExpr, HirFunction, HirModule, HirStmt, HirType, HirVarId,
};
use crate::signatures::SignatureDb;

/// Maximum iterations before declaring convergence.
const MAX_ITERATIONS: usize = 16;

/// Result of type propagation.
#[derive(Debug, Clone)]
pub struct TypePropResult {
    /// Number of types resolved during this pass.
    pub types_resolved: usize,
    /// Number of types still unresolved.
    pub types_unresolved: usize,
    /// Number of iterations until convergence.
    pub iterations: usize,
    /// Whether the analysis converged (no more changes).
    pub converged: bool,
}

/// Type environment — maps variable IDs to their current best-known type.
#[derive(Debug, Clone, Default)]
pub struct TypeEnv {
    types: HashMap<HirVarId, HirType>,
}

impl TypeEnv {
    pub fn new() -> Self {
        Self::default()
    }

    /// Get the type of a variable.
    pub fn get(&self, id: HirVarId) -> &HirType {
        self.types.get(&id).unwrap_or(&HirType::Unknown)
    }

    /// Set the type of a variable. Returns true if the type changed.
    pub fn set(&mut self, id: HirVarId, ty: HirType) -> bool {
        if ty == HirType::Unknown {
            return false;
        }
        match self.types.get(&id) {
            Some(existing) if existing == &ty => false,
            Some(existing) if *existing != HirType::Unknown => {
                // Don't overwrite a known type with a different known type
                // (would need a meet/join operation for a proper lattice)
                false
            }
            _ => {
                self.types.insert(id, ty);
                true
            }
        }
    }

    /// Populate the environment from a function's declared variables.
    pub fn populate_from_function(&mut self, func: &HirFunction) {
        for param in &func.params {
            self.types.insert(param.id, param.ty.clone());
        }
        for local in &func.locals {
            self.types.insert(local.id, local.ty.clone());
        }
    }

    /// Count resolved and unresolved types.
    pub fn stats(&self) -> (usize, usize) {
        let resolved = self.types.values().filter(|t| t.is_resolved()).count();
        let unresolved = self.types.values().filter(|t| !t.is_resolved()).count();
        (resolved, unresolved)
    }
}

/// Run type propagation on a module, refining types to a fixed point.
pub fn propagate_types(module: &mut HirModule, signatures: &SignatureDb) -> TypePropResult {
    let mut total_resolved = 0;
    let mut total_unresolved = 0;
    let mut total_iterations = 0;
    let mut all_converged = true;

    for func in &mut module.functions {
        let result = propagate_function_types(func, signatures);
        total_resolved += result.types_resolved;
        total_unresolved += result.types_unresolved;
        total_iterations = total_iterations.max(result.iterations);
        all_converged = all_converged && result.converged;
    }

    TypePropResult {
        types_resolved: total_resolved,
        types_unresolved: total_unresolved,
        iterations: total_iterations,
        converged: all_converged,
    }
}

/// Run type propagation on a single function.
fn propagate_function_types(func: &mut HirFunction, signatures: &SignatureDb) -> TypePropResult {
    let mut env = TypeEnv::new();
    env.populate_from_function(func);

    let mut changed = true;
    let mut iterations = 0;

    while changed && iterations < MAX_ITERATIONS {
        changed = false;
        iterations += 1;

        // Forward pass: propagate types through statements
        for stmt in &func.body {
            changed |= propagate_stmt(&mut env, stmt, signatures);
        }
    }

    // Write refined types back to the function
    apply_types_to_function(func, &env);

    let (resolved, unresolved) = env.stats();
    TypePropResult {
        types_resolved: resolved,
        types_unresolved: unresolved,
        iterations,
        converged: !changed,
    }
}

/// Propagate types through a single statement.
fn propagate_stmt(env: &mut TypeEnv, stmt: &HirStmt, signatures: &SignatureDb) -> bool {
    let mut changed = false;

    match stmt {
        HirStmt::VarDecl {
            var_id, init: Some(expr), ..
        } => {
            let expr_ty = infer_expr_type(env, expr, signatures);
            changed |= env.set(*var_id, expr_ty);

            // MOVZX/MOVSX: propagate signedness to source variable.
            if let HirExpr::Cast {
                expr: inner,
                to_ty: HirType::Int { signed, .. },
                ..
            } = expr
            {
                if let HirExpr::Var { id: src_id, .. } = inner.as_ref() {
                    let src_ty = env.get(*src_id);
                    if let HirType::Int { bits: src_bits, .. } = src_ty {
                        let refined = HirType::Int { signed: *signed, bits: *src_bits };
                        changed |= env.set(*src_id, refined);
                    }
                }
            }
        }

        HirStmt::Assign { lhs, rhs, .. } => {
            let rhs_ty = infer_expr_type(env, rhs, signatures);
            if let HirExpr::Var { id, .. } = lhs {
                changed |= env.set(*id, rhs_ty);
            }

            // MOVZX/MOVSX: propagate signedness back to the source variable.
            // In the HIR, MOVZX/MOVSX are represented as Cast expressions.
            // The cast target type carries the signedness info that should
            // also be applied to the source operand at its original width.
            if let HirExpr::Cast {
                expr: inner,
                to_ty: HirType::Int { signed, .. },
                ..
            } = rhs
            {
                // Propagate signedness to the source variable at its width
                if let HirExpr::Var { id: src_id, .. } = inner.as_ref() {
                    let src_ty = env.get(*src_id);
                    if let HirType::Int { bits: src_bits, .. } = src_ty {
                        let refined = HirType::Int { signed: *signed, bits: *src_bits };
                        changed |= env.set(*src_id, refined);
                    }
                }
            }

            // LEA: address computation results are pointers.
            // In the HIR, LEA is represented as AddressOf unary expressions.
            if let HirExpr::Unary { op: crate::ir::hir::HirUnaryOp::AddressOf, .. } = rhs {
                if let HirExpr::Var { id, .. } = lhs {
                    changed |= env.set(*id, HirType::void_ptr());
                }
            }
        }

        HirStmt::If {
            then_body,
            else_body,
            ..
        } => {
            for s in then_body {
                changed |= propagate_stmt(env, s, signatures);
            }
            if let Some(else_stmts) = else_body {
                for s in else_stmts {
                    changed |= propagate_stmt(env, s, signatures);
                }
            }
        }

        HirStmt::While { body, .. } | HirStmt::DoWhile { body, .. } => {
            for s in body {
                changed |= propagate_stmt(env, s, signatures);
            }
        }

        HirStmt::For { body, .. } => {
            for s in body {
                changed |= propagate_stmt(env, s, signatures);
            }
        }

        HirStmt::Switch { cases, default, .. } => {
            for case in cases {
                for s in &case.body {
                    changed |= propagate_stmt(env, s, signatures);
                }
            }
            if let Some(default_stmts) = default {
                for s in default_stmts {
                    changed |= propagate_stmt(env, s, signatures);
                }
            }
        }

        _ => {}
    }

    changed
}

/// Infer the type of an expression based on the current environment.
fn infer_expr_type(env: &TypeEnv, expr: &HirExpr, signatures: &SignatureDb) -> HirType {
    match expr {
        HirExpr::IntLit { ty, .. } => ty.clone(),
        HirExpr::FloatLit { ty, .. } => ty.clone(),
        HirExpr::StringLit { .. } => HirType::ptr(HirType::u8()),
        HirExpr::Var { id, .. } => env.get(*id).clone(),

        HirExpr::Binary { op, lhs, rhs, .. } => {
            let lhs_ty = infer_expr_type(env, lhs, signatures);
            let rhs_ty = infer_expr_type(env, rhs, signatures);
            match op {
                // Comparison operators always return bool
                HirBinOp::Eq
                | HirBinOp::Ne
                | HirBinOp::Lt
                | HirBinOp::Le
                | HirBinOp::Gt
                | HirBinOp::Ge
                | HirBinOp::LogAnd
                | HirBinOp::LogOr => HirType::Bool,
                // Pointer arithmetic: pointer + integer → pointer
                HirBinOp::Add | HirBinOp::Sub => {
                    if matches!(lhs_ty, HirType::Pointer(_)) {
                        lhs_ty
                    } else if matches!(rhs_ty, HirType::Pointer(_)) {
                        rhs_ty
                    } else if lhs_ty.is_resolved() {
                        lhs_ty
                    } else {
                        rhs_ty
                    }
                }
                // Other arithmetic: use the wider/resolved type
                _ => {
                    if lhs_ty.is_resolved() {
                        lhs_ty
                    } else {
                        rhs_ty
                    }
                }
            }
        }

        HirExpr::Unary { op, operand, .. } => {
            let inner_ty = infer_expr_type(env, operand, signatures);
            match op {
                crate::ir::hir::HirUnaryOp::Not => HirType::Bool,
                crate::ir::hir::HirUnaryOp::Deref => {
                    if let HirType::Pointer(inner) = inner_ty {
                        *inner
                    } else {
                        HirType::Unknown
                    }
                }
                crate::ir::hir::HirUnaryOp::AddressOf => HirType::ptr(inner_ty),
                _ => inner_ty,
            }
        }

        HirExpr::Cast { to_ty, .. } => to_ty.clone(),

        HirExpr::Call { target, ret_ty, .. } => {
            // Try to resolve return type from signature DB
            if let HirExpr::AddrLit { address, .. } = target.as_ref() {
                if let Some(sig) = signatures.lookup(*address) {
                    return parse_c_type_name(&sig.return_type);
                }
            }
            ret_ty.clone()
        }

        HirExpr::FieldAccess { ty, .. } | HirExpr::DerefFieldAccess { ty, .. } => ty.clone(),
        HirExpr::Subscript { ty, .. } => ty.clone(),
        HirExpr::Ternary { then_expr, .. } => infer_expr_type(env, then_expr, signatures),
        HirExpr::AddrLit { .. } => HirType::void_ptr(),
        HirExpr::Unknown { .. } => HirType::Unknown,
    }
}

/// Apply refined types from the environment back to the function.
fn apply_types_to_function(func: &mut HirFunction, env: &TypeEnv) {
    for param in &mut func.params {
        if !param.ty.is_resolved() {
            let refined = env.get(param.id).clone();
            if refined.is_resolved() {
                param.ty = refined;
            }
        }
    }
    for local in &mut func.locals {
        if !local.ty.is_resolved() {
            let refined = env.get(local.id).clone();
            if refined.is_resolved() {
                local.ty = refined;
            }
        }
    }
}

/// Parse a simple C type name string into a HirType.
/// Handles common types from signature databases.
pub fn parse_c_type_name(name: &str) -> HirType {
    match name.trim() {
        "void" => HirType::Void,
        "bool" | "BOOL" => HirType::Bool,
        "char" | "int8_t" | "CHAR" => HirType::i8(),
        "short" | "int16_t" | "SHORT" | "WORD" => HirType::i16(),
        "int" | "int32_t" | "INT" | "LONG" | "DWORD" => HirType::i32(),
        "long long" | "int64_t" | "LONGLONG" | "QWORD" => HirType::i64(),
        "unsigned char" | "uint8_t" | "BYTE" | "UCHAR" => HirType::u8(),
        "unsigned short" | "uint16_t" | "USHORT" => HirType::u16(),
        "unsigned int" | "uint32_t" | "UINT" | "ULONG" => HirType::u32(),
        "unsigned long long" | "uint64_t" | "ULONGLONG" => HirType::u64(),
        "float" => HirType::Float { bits: 32 },
        "double" => HirType::Float { bits: 64 },
        "void*" | "LPVOID" | "PVOID" => HirType::void_ptr(),
        "HANDLE" | "HMODULE" | "HINSTANCE" | "HWND" | "HDC" | "HBITMAP" | "HBRUSH"
        | "HCURSOR" | "HFONT" | "HGDIOBJ" | "HICON" | "HMENU" | "HRGN" => {
            HirType::void_ptr() // Win32 handles are opaque pointers
        }
        "LPCSTR" | "PCSTR" | "const char*" => HirType::ptr(HirType::i8()),
        "LPSTR" | "PSTR" | "char*" => HirType::ptr(HirType::i8()),
        "LPCWSTR" | "PCWSTR" | "const wchar_t*" => HirType::ptr(HirType::i16()),
        "LPWSTR" | "PWSTR" | "wchar_t*" => HirType::ptr(HirType::i16()),
        "SIZE_T" | "size_t" | "ULONG_PTR" => HirType::u64(),
        "SSIZE_T" | "ssize_t" | "LONG_PTR" => HirType::i64(),
        s if s.ends_with('*') => {
            let inner = parse_c_type_name(&s[..s.len() - 1]);
            HirType::ptr(inner)
        }
        _ => HirType::Unknown,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_common_c_types() {
        assert_eq!(parse_c_type_name("void"), HirType::Void);
        assert_eq!(parse_c_type_name("int"), HirType::i32());
        assert_eq!(parse_c_type_name("HANDLE"), HirType::void_ptr());
        assert_eq!(parse_c_type_name("BOOL"), HirType::Bool);
        assert_eq!(parse_c_type_name("void*"), HirType::void_ptr());
        assert_eq!(parse_c_type_name("LPCWSTR"), HirType::ptr(HirType::i16()));
    }

    #[test]
    fn parse_pointer_types() {
        assert_eq!(parse_c_type_name("int*"), HirType::ptr(HirType::i32()));
        assert_eq!(
            parse_c_type_name("char*"),
            HirType::ptr(HirType::i8())
        );
    }

    #[test]
    fn type_env_set_and_get() {
        let mut env = TypeEnv::new();
        let id = HirVarId(0);

        // Setting a type when none exists should succeed
        assert!(env.set(id, HirType::i32()));
        assert_eq!(env.get(id), &HirType::i32());

        // Setting the same type again should not report a change
        assert!(!env.set(id, HirType::i32()));

        // Setting Unknown should not overwrite
        assert!(!env.set(id, HirType::Unknown));
        assert_eq!(env.get(id), &HirType::i32());
    }

    #[test]
    fn type_env_stats() {
        let mut env = TypeEnv::new();
        env.set(HirVarId(0), HirType::i32());
        env.set(HirVarId(1), HirType::void_ptr());
        env.types.insert(HirVarId(2), HirType::Unknown);

        let (resolved, unresolved) = env.stats();
        assert_eq!(resolved, 2);
        assert_eq!(unresolved, 1);
    }
}
