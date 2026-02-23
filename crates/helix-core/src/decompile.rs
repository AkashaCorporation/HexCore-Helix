//! Decompilation pipeline: Remill IR → pseudo-C.
//!
//! Takes parsed [`LiftedModule`] and produces human-readable pseudo-C output
//! with register elimination, calling convention folding, and variable recovery.
//!
//! Two decompilation paths are available:
//! - [`decompile_ir`] — The original transform-based path (production, battle-tested).
//! - [`decompile_ir_via_hir`] — The new HIR-based path with type propagation.

use crate::ir::parser;
use crate::ir::remill::Semantic;
use crate::ir::{LiftedModule, Operand, RemillInsn};
use crate::transforms::{self, CallTarget, HLStmt, LocalInfo};

/// Result of decompiling a Remill IR module.
#[derive(Debug, Clone)]
pub struct DecompileOutput {
    /// Pseudo-C source code.
    pub source: String,
    /// Number of sub-functions recovered.
    pub function_count: usize,
    /// Total decoded instructions (excluding dead code).
    pub instruction_count: usize,
    /// Warnings/notes generated during decompilation.
    pub diagnostics: Vec<String>,
}

/// Decompile Remill IR text using the **HIR pipeline**.
///
/// This path goes through:
/// 1. Parse IR → `LiftedModule`
/// 2. Build HIR → `HirModule`
/// 3. Calling convention recovery (Win64 arg folding, result naming)
/// 4. Type propagation (refine `Unknown` types)
/// 5. Control flow structuring (CMOV recovery, if/while from Jcc)
/// 6. Validation pass (structural integrity check)
/// 7. Emit pseudo-C from the typed HIR
///
/// This produces higher-quality output with proper type annotations
/// and is the path that will be extended with MLIR passes in Phase 2.
pub fn decompile_ir_via_hir(ir_text: &str) -> Result<DecompileOutput, String> {
    use crate::analysis::calling_convention;
    use crate::analysis::control_flow;
    use crate::analysis::type_propagation;
    use crate::analysis::validation;
    use crate::diagnostics::{DiagnosticKind, DiagnosticSink};
    use crate::ir::hir_builder;
    use crate::ir::hir_emitter::{self, EmitOptions};
    use crate::signatures::SignatureDb;

    let mut sink = DiagnosticSink::new();

    // Stage 1: Parse IR text → LiftedModule
    let module = parser::parse_remill_ir(ir_text)?;

    // Stage 2: Build HIR from parsed instructions
    let mut hir_module = hir_builder::build_hir(&module);

    // Stage 3: Run calling convention recovery (Win64 arg folding)
    let signatures = SignatureDb::load_default();
    let cc_result = calling_convention::recover_calling_convention(&mut hir_module, &signatures);

    sink.module_info(
        DiagnosticKind::CallingConvention,
        format!(
            "calls={}, args={}, eliminated={}, results={}",
            cc_result.calls_recovered,
            cc_result.args_recovered,
            cc_result.stmts_eliminated,
            cc_result.results_named,
        ),
    );

    // Stage 4: Run type propagation to refine Unknown types
    let type_result = type_propagation::propagate_types(&mut hir_module, &signatures);

    sink.module_info(
        DiagnosticKind::UnresolvedType,
        format!(
            "resolved={}, unresolved={}, iterations={}, converged={}",
            type_result.types_resolved,
            type_result.types_unresolved,
            type_result.iterations,
            type_result.converged,
        ),
    );

    // Stage 5: Control flow structuring (CMP/TEST pairing, if/while recovery)
    let cf_result = control_flow::structure_control_flow(&mut hir_module, &mut sink);

    sink.module_info(
        DiagnosticKind::Recovery,
        format!(
            "control_flow: ifs={}, loops={}, cmov_resolved={}, jcc_consumed={}",
            cf_result.ifs_recovered,
            cf_result.loops_recovered,
            cf_result.cmov_conditions_resolved,
            cf_result.jcc_comments_consumed,
        ),
    );

    // Stage 5.5: Boilerplate elimination (Remill internal variables + signature rewriting)
    for func in &mut hir_module.functions {
        hir_builder::eliminate_boilerplate(func);
        hir_builder::rewrite_function_signature(func);
    }

    // Stage 5.6: Dead code elimination (remove unreachable code after return)
    for func in &mut hir_module.functions {
        control_flow::eliminate_dead_code(&mut func.body);
    }

    // Stage 5.7: Redundant goto elimination (cleanup fallthrough gotos and orphan labels)
    for func in &mut hir_module.functions {
        control_flow::eliminate_redundant_gotos(&mut func.body);
    }

    // Stage 6: Validation pass
    let _validation_result = validation::validate_module(&hir_module, &signatures, &mut sink);

    // Per-function diagnostics
    for func in &hir_module.functions {
        let stack_locals = func
            .locals
            .iter()
            .filter(|v| matches!(v.storage, crate::ir::hir::HirStorage::Stack(_)))
            .count();
        sink.info(
            &func.name,
            func.address,
            DiagnosticKind::StackFrame,
            format!("locals={}, stmts={}", stack_locals, func.body.len()),
        );
    }

    // Stage 7: Emit pseudo-C from the typed HIR
    let options = EmitOptions {
        include_addresses: true,
        ..EmitOptions::default()
    };
    let source = hir_emitter::emit_module(&hir_module, &signatures, &options);

    // Count total instructions (non-padding)
    let instruction_count: usize = module
        .instructions
        .iter()
        .filter(|i| i.semantic != Semantic::Int3 && i.semantic != Semantic::Nop)
        .count();

    // Convert structured diagnostics to string list for backward compat
    let diagnostics = sink.to_strings();

    Ok(DecompileOutput {
        source,
        function_count: hir_module.functions.len(),
        instruction_count,
        diagnostics,
    })
}

/// Decompile a Remill IR text string into pseudo-C.
pub fn decompile_ir(ir_text: &str) -> Result<DecompileOutput, String> {
    let module = parser::parse_remill_ir(ir_text)?;
    let functions = split_functions(&module);

    let mut source = String::new();
    let mut diagnostics = Vec::new();
    let mut total_insns = 0;

    source.push_str(&format!(
        "// Decompiled by HexCore Helix\n// Source: {}\n// Arch:   {}\n// Entry:  0x{:x}\n\n",
        module.source_file, module.arch, module.entry_address
    ));

    for func in &functions {
        let entry = func.first().map(|i| i.pc).unwrap_or(0);
        let live: Vec<&RemillInsn> = func
            .iter()
            .filter(|i| i.semantic != Semantic::Int3 && i.semantic != Semantic::Nop)
            .collect();

        total_insns += live.len();

        // Detect stack frame
        let (frame_size, locals) = detect_stack_frame(&live);

        diagnostics.push(format!(
            "sub_{:x}: frame={}B, locals={}",
            entry,
            frame_size,
            locals.len()
        ));

        // Run high-level transform pass
        let stmts = transforms::transform(func, &locals);

        // Emit function
        source.push_str(&format!(
            "// ─── sub_{:x} ────────────────────────────────\n",
            entry
        ));
        source.push_str(&format!("void sub_{:x}(", entry));
        source.push_str("void) {\n");

        // Local variable declarations
        for local in &locals {
            source.push_str(&format!(
                "    int32_t {};  // [rsp+0x{:x}]\n",
                local.name, local.offset
            ));
        }
        if !locals.is_empty() {
            source.push('\n');
        }

        // Statements — track indent level for control flow blocks
        let mut indent = 1u32;
        for stmt in &stmts {
            // Adjust indent BEFORE emitting for closing braces
            if matches!(
                stmt,
                HLStmt::IfEnd | HLStmt::WhileEnd | HLStmt::Else | HLStmt::SwitchEnd
            ) {
                indent = indent.saturating_sub(1);
            }

            let line = emit_stmt(stmt, indent);
            if !line.is_empty() {
                source.push_str(&format!("{}\n", line));
            }

            // Increase indent AFTER emitting for opening braces
            if matches!(
                stmt,
                HLStmt::IfBegin { .. }
                    | HLStmt::WhileBegin { .. }
                    | HLStmt::Else
                    | HLStmt::SwitchBegin { .. }
            ) {
                indent += 1;
            }
        }

        source.push_str("}\n\n");
    }

    Ok(DecompileOutput {
        source,
        function_count: functions.len(),
        instruction_count: total_insns,
        diagnostics,
    })
}

// ─── Function Splitting ─────────────────────────────────────────────────────

fn split_functions(module: &LiftedModule) -> Vec<Vec<RemillInsn>> {
    if module.function_boundaries.len() <= 1 {
        return vec![module.instructions.clone()];
    }

    let mut functions = Vec::new();
    let boundaries = &module.function_boundaries;

    for w in boundaries.windows(2) {
        functions.push(module.instructions[w[0]..w[1]].to_vec());
    }
    if let Some(&last) = boundaries.last() {
        if last < module.instructions.len() {
            functions.push(module.instructions[last..].to_vec());
        }
    }

    functions
}

// ─── Stack Frame Analysis ───────────────────────────────────────────────────

fn detect_stack_frame(instructions: &[&RemillInsn]) -> (u64, Vec<LocalInfo>) {
    let mut frame_size = 0u64;
    let mut offsets: Vec<i64> = Vec::new();

    for insn in instructions {
        if insn.semantic == Semantic::Sub {
            if let Some(Operand::Reg(r)) = &insn.dst {
                if r == "RSP" {
                    if let Some(Operand::Imm(n)) = insn.srcs.last() {
                        frame_size = *n as u64;
                    }
                }
            }
        }

        // Collect unique RSP-relative offsets
        let collect = |op: &Operand, offsets: &mut Vec<i64>| {
            if let Operand::Mem { base, disp, .. } = op {
                if base == "RSP" && !offsets.contains(disp) {
                    offsets.push(*disp);
                }
            }
        };

        if let Some(dst) = &insn.dst {
            collect(dst, &mut offsets);
        }
        for src in &insn.srcs {
            collect(src, &mut offsets);
        }
    }

    offsets.sort();

    let locals: Vec<LocalInfo> = offsets
        .iter()
        .map(|offset| LocalInfo {
            name: format!("var_{:x}", offset),
            offset: *offset,
        })
        .collect();

    (frame_size, locals)
}

// ─── Statement Emission ─────────────────────────────────────────────────────

fn emit_stmt(stmt: &HLStmt, indent: u32) -> String {
    let pad = "    ".repeat(indent as usize);

    match stmt {
        HLStmt::Call {
            result,
            target,
            args,
        } => {
            let args_str = args
                .iter()
                .map(|a| a.to_string())
                .collect::<Vec<_>>()
                .join(", ");

            let call_str = match target {
                CallTarget::Direct { name, .. } => format!("{}({})", name, args_str),
                CallTarget::Indirect(name) => format!("{}({})", name, args_str),
            };

            match result {
                Some((name, type_name)) => {
                    format!("{}{} {} = {};", pad, type_name, name, call_str)
                }
                None => {
                    format!("{}{};", pad, call_str)
                }
            }
        }

        HLStmt::Assign { dst, value } => {
            format!("{}{} = {};", pad, dst, value)
        }

        HLStmt::FieldStore { target, value } => {
            format!("{}{} = {};", pad, target, value)
        }

        HLStmt::IfBegin { condition } => {
            format!("{}if ({}) {{", pad, condition)
        }

        HLStmt::IfEnd => {
            format!("{}}}", pad)
        }

        HLStmt::Else => {
            format!("{}}} else {{", pad)
        }

        HLStmt::WhileBegin { condition } => {
            format!("{}while ({}) {{", pad, condition)
        }

        HLStmt::WhileEnd => {
            format!("{}}}", pad)
        }

        HLStmt::SwitchBegin { expr } => {
            format!("{}switch ({}) {{", pad, expr)
        }

        HLStmt::SwitchCase { values } => {
            let labels = values
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
            format!("{}{}", pad, labels)
        }

        HLStmt::SwitchDefault => {
            format!("{}default:", pad)
        }

        HLStmt::SwitchEnd => {
            format!("{}}}", pad)
        }

        HLStmt::Break => format!("{}break;", pad),

        HLStmt::Return => format!("{}return;", pad),

        HLStmt::Comment(text) => {
            format!("{}// {}", pad, text)
        }
    }
}
