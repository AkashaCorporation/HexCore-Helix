//! Remill LLVM IR text parser.
//!
//! Parses the IR text produced by HexCore's Remill lifter into structured
//! [`LiftedModule`] containing decoded [`RemillInsn`] instructions.
//!
//! This is NOT a general LLVM IR parser. It specifically handles the
//! regular patterns in Remill's lifted output.

use std::collections::HashMap;

use super::remill::{self, Semantic};
use super::{LiftedModule, Operand, RemillInsn};

/// Result of preprocessing the new LLVM module format.
struct PreprocessResult {
    /// Map of metadata ID → register name (e.g., 6 → "RAX").
    register_metadata: HashMap<u32, String>,
    /// Instruction lines filtered from the IR (without struct defs, declares, attributes, metadata).
    instruction_lines: Vec<String>,
    /// Architecture extracted from target triple (e.g., "amd64").
    arch: String,
    /// Source file name.
    source_file: String,
    /// Target triple string.
    target_triple: String,
    /// Declared intrinsics.
    declared_intrinsics: Vec<String>,
}

/// Origin of an SSA value — tracks where each `%N` or `%name` came from.
#[derive(Debug, Clone)]
enum ValueOrigin {
    /// Pointer to a state register: `%RSP`, `%RAX`, etc.
    RegPtr(String),
    /// Value loaded from a register: `load i64, ptr %RAX`.
    RegValue(String),
    /// Integer constant.
    Constant(i64),
    /// NEXT_PC + offset (for call target resolution).
    PcRelative(i64),
    /// Register value + constant offset (for LEA/memory ops).
    RegPlusOffset(String, i64),
    /// The `%memory` or `%MEMORY` state.
    Memory,
    /// The `%state` pointer.
    State,
    /// Program counter value.
    ProgramCounter,
    /// Unknown origin.
    Unknown,
}

/// Parse Remill LLVM IR text into a [`LiftedModule`].
pub fn parse_remill_ir(ir: &str) -> Result<LiftedModule, String> {
    if is_new_format(ir) {
        parse_new_format(ir)
    } else {
        parse_old_format(ir)
    }
}

/// Parse IR in the new LLVM module format (with target triple, struct defs, declares, metadata).
fn parse_new_format(ir: &str) -> Result<LiftedModule, String> {
    let preprocess = preprocess_new_format(ir)?;

    // Use header comments for address/arch/file, falling back to preprocessed values
    let (entry_address, header_arch, header_file) = parse_header(ir);
    let arch = if header_arch.is_empty() {
        preprocess.arch
    } else {
        header_arch
    };
    let source_file = if header_file.is_empty() {
        preprocess.source_file
    } else {
        header_file
    };

    // Rejoin instruction lines and parse them with the existing instruction parser
    let instruction_ir = preprocess.instruction_lines.join("\n");
    let func_name = extract_function_name(&instruction_ir);

    // Build SSA value origin map and extract instructions from filtered lines
    let mut origins: HashMap<String, ValueOrigin> = HashMap::new();
    let mut instructions: Vec<RemillInsn> = Vec::new();
    let mut current_pc = entry_address;
    let mut current_size: u32 = 0;
    let mut pc_updated = false;
    let mut post_pc_update = false;

    // Pre-populate known named origins
    origins.insert("state".into(), ValueOrigin::State);
    origins.insert("memory".into(), ValueOrigin::Memory);
    origins.insert("MEMORY".into(), ValueOrigin::Memory);
    origins.insert("program_counter".into(), ValueOrigin::ProgramCounter);

    for line in instruction_ir.lines() {
        let line = line.trim();

        // Skip comments, blank lines, define/closing brace, metadata
        if line.is_empty()
            || line.starts_with(';')
            || line.starts_with("define ")
            || line == "}"
            || line.starts_with('!')
        {
            continue;
        }

        // ── GEP: register pointer extraction (with metadata support) ──
        if line.contains("getelementptr inbounds %struct.State") {
            if let Some((var_name, reg_name)) =
                resolve_gep_register(line, &preprocess.register_metadata)
            {
                origins.insert(var_name, ValueOrigin::RegPtr(reg_name));
            } else if let Some(dst) = extract_assignment_dst(line) {
                origins.insert(dst.clone(), ValueOrigin::RegPtr(dst));
            }
            continue;
        }

        // ── Alloca ────────────────────────────────────────────────────
        if line.contains("alloca ") {
            if let Some(dst) = extract_assignment_dst(line) {
                let origin = match dst.as_str() {
                    "NEXT_PC" => ValueOrigin::ProgramCounter,
                    "MEMORY" => ValueOrigin::Memory,
                    "STATE" => ValueOrigin::State,
                    _ => ValueOrigin::Unknown,
                };
                origins.insert(dst, origin);
            }
            continue;
        }

        // ── Store ─────────────────────────────────────────────────────
        if line.starts_with("store ") {
            if line.contains("ptr %PC,") {
                pc_updated = true;
                post_pc_update = false;
            }
            continue;
        }

        // ── Load ──────────────────────────────────────────────────────
        if line.contains("= load ") {
            if let Some(dst) = extract_assignment_dst(line) {
                let origin = if let Some(src) = extract_load_source(line) {
                    match origins.get(&src) {
                        Some(ValueOrigin::RegPtr(r)) => ValueOrigin::RegValue(r.clone()),
                        Some(ValueOrigin::ProgramCounter) => {
                            if post_pc_update {
                                ValueOrigin::Constant((current_pc + current_size as u64) as i64)
                            } else {
                                ValueOrigin::Constant(current_pc as i64)
                            }
                        }
                        Some(ValueOrigin::Memory) => ValueOrigin::Memory,
                        Some(ValueOrigin::State) => ValueOrigin::State,
                        _ => ValueOrigin::Unknown,
                    }
                } else {
                    ValueOrigin::Unknown
                };
                origins.insert(dst, origin);
            }
            continue;
        }

        // ── Binary ops ───────────────────────────────────────────────
        if let Some((dst, op, lhs_name, rhs)) = parse_binop(line) {
            let origin = match op {
                "add" => {
                    let lhs_origin = origins.get(&lhs_name).cloned();
                    match lhs_origin {
                        Some(ValueOrigin::Constant(pc_val)) => {
                            if pc_updated && current_size == 0 {
                                current_size = rhs as u32;
                                post_pc_update = true;
                                ValueOrigin::Constant(pc_val + rhs)
                            } else {
                                ValueOrigin::PcRelative(pc_val + rhs)
                            }
                        }
                        Some(ValueOrigin::RegValue(r)) => ValueOrigin::RegPlusOffset(r, rhs),
                        _ => ValueOrigin::Unknown,
                    }
                }
                "sub" => {
                    let lhs_origin = origins.get(&lhs_name).cloned();
                    match lhs_origin {
                        Some(ValueOrigin::Constant(pc_val)) => {
                            ValueOrigin::PcRelative(pc_val - rhs)
                        }
                        Some(ValueOrigin::RegValue(r)) => ValueOrigin::RegPlusOffset(r, -rhs),
                        _ => ValueOrigin::Unknown,
                    }
                }
                _ => ValueOrigin::Unknown,
            };
            origins.insert(dst, origin);

            if pc_updated && current_size > 0 && op == "add" {
                pc_updated = false;
            }
            continue;
        }

        // ── ZExt ──────────────────────────────────────────────────────
        if line.contains("= zext ") {
            if let Some(dst) = extract_assignment_dst(line) {
                if let Some(src_name) = extract_zext_source(line) {
                    let origin = origins
                        .get(&src_name)
                        .cloned()
                        .unwrap_or(ValueOrigin::Unknown);
                    origins.insert(dst, origin);
                }
            }
            continue;
        }

        // ── Call: Remill semantic intrinsic ────────────────────────────
        if line.contains("= call ") && line.contains("@_ZN") {
            let insn = decode_remill_call(line, &origins, current_pc, current_size);
            if let Some(insn) = insn {
                instructions.push(insn);
                current_pc += current_size as u64;
                current_size = 0;
            }
            if let Some(dst) = extract_assignment_dst(line) {
                origins.insert(dst, ValueOrigin::Memory);
            }
            continue;
        }

        // ── Call without assignment (void calls) ──────────────────────
        if line.starts_with("call ") && line.contains("@_ZN") {
            let insn = decode_remill_call(line, &origins, current_pc, current_size);
            if let Some(insn) = insn {
                instructions.push(insn);
                current_pc += current_size as u64;
                current_size = 0;
            }
            continue;
        }
    }

    let function_boundaries = find_function_boundaries(&instructions);

    Ok(LiftedModule {
        name: func_name,
        entry_address,
        arch,
        source_file,
        instructions,
        function_boundaries,
        register_metadata: preprocess.register_metadata,
        target_triple: preprocess.target_triple,
        declared_intrinsics: preprocess.declared_intrinsics,
    })
}

/// Parse IR in the old format (without target triple, struct defs, declares, etc.).
/// This is the original parse_remill_ir logic, kept 100% unchanged.
fn parse_old_format(ir: &str) -> Result<LiftedModule, String> {
    let (entry_address, arch, source_file) = parse_header(ir);
    let func_name = extract_function_name(ir);

    // Build SSA value origin map and extract instructions
    let mut origins: HashMap<String, ValueOrigin> = HashMap::new();
    let mut instructions: Vec<RemillInsn> = Vec::new();
    let mut current_pc = entry_address;
    let mut current_size: u32 = 0;
    let mut pc_updated = false;
    let mut post_pc_update = false;

    // Pre-populate known named origins
    origins.insert("state".into(), ValueOrigin::State);
    origins.insert("memory".into(), ValueOrigin::Memory);
    origins.insert("MEMORY".into(), ValueOrigin::Memory);
    origins.insert("program_counter".into(), ValueOrigin::ProgramCounter);

    for line in ir.lines() {
        let line = line.trim();

        // Skip comments, blank lines, define/closing brace, metadata
        if line.is_empty()
            || line.starts_with(';')
            || line.starts_with("define ")
            || line == "}"
            || line.starts_with('!')
        {
            continue;
        }

        // ── GEP: register pointer extraction ──────────────────────────
        // %RSP = getelementptr inbounds %struct.State, ...
        if line.contains("getelementptr inbounds %struct.State") {
            if let Some(dst) = extract_assignment_dst(line) {
                origins.insert(dst.clone(), ValueOrigin::RegPtr(dst));
            }
            continue;
        }

        // ── Alloca ────────────────────────────────────────────────────
        if line.contains("alloca ") {
            if let Some(dst) = extract_assignment_dst(line) {
                // Named allocas like NEXT_PC, RETURN_PC, MONITOR, etc.
                let origin = match dst.as_str() {
                    "NEXT_PC" => ValueOrigin::ProgramCounter,
                    "MEMORY" => ValueOrigin::Memory,
                    "STATE" => ValueOrigin::State,
                    _ => ValueOrigin::Unknown,
                };
                origins.insert(dst, origin);
            }
            continue;
        }

        // ── Store ─────────────────────────────────────────────────────
        // store i64 %1, ptr %PC, align 8
        if line.starts_with("store ") {
            // Detect PC update: store %N, ptr %PC → marks instruction boundary
            if line.contains("ptr %PC,") {
                pc_updated = true;
                post_pc_update = false;
            }
            continue;
        }

        // ── Load ──────────────────────────────────────────────────────
        // %1 = load i64, ptr %NEXT_PC, align 8
        if line.contains("= load ") {
            if let Some(dst) = extract_assignment_dst(line) {
                let origin = if let Some(src) = extract_load_source(line) {
                    match origins.get(&src) {
                        Some(ValueOrigin::RegPtr(r)) => ValueOrigin::RegValue(r.clone()),
                        Some(ValueOrigin::ProgramCounter) => {
                            if post_pc_update {
                                ValueOrigin::Constant((current_pc + current_size as u64) as i64)
                            } else {
                                ValueOrigin::Constant(current_pc as i64)
                            }
                        }
                        Some(ValueOrigin::Memory) => ValueOrigin::Memory,
                        Some(ValueOrigin::State) => ValueOrigin::State,
                        _ => ValueOrigin::Unknown,
                    }
                } else {
                    ValueOrigin::Unknown
                };
                origins.insert(dst, origin);
            }
            continue;
        }

        // ── Binary ops: add, sub, xor, and, or, etc. ─────────────────
        // %2 = add i64 %1, 5
        if let Some((dst, op, lhs_name, rhs)) = parse_binop(line) {
            let origin = match op {
                "add" => {
                    let lhs_origin = origins.get(&lhs_name).cloned();
                    match lhs_origin {
                        Some(ValueOrigin::Constant(pc_val)) => {
                            if pc_updated && current_size == 0 {
                                current_size = rhs as u32;
                                post_pc_update = true;
                                ValueOrigin::Constant(pc_val + rhs)
                            } else {
                                ValueOrigin::PcRelative(pc_val + rhs)
                            }
                        }
                        Some(ValueOrigin::RegValue(r)) => ValueOrigin::RegPlusOffset(r, rhs),
                        _ => ValueOrigin::Unknown,
                    }
                }
                "sub" => {
                    let lhs_origin = origins.get(&lhs_name).cloned();
                    match lhs_origin {
                        Some(ValueOrigin::Constant(pc_val)) => {
                            ValueOrigin::PcRelative(pc_val - rhs)
                        }
                        Some(ValueOrigin::RegValue(r)) => ValueOrigin::RegPlusOffset(r, -rhs),
                        _ => ValueOrigin::Unknown,
                    }
                }
                _ => ValueOrigin::Unknown,
            };
            origins.insert(dst, origin);

            // After the PC size add, mark the instruction boundary
            if pc_updated && current_size > 0 && op == "add" {
                pc_updated = false;
            }
            continue;
        }

        // ── ZExt ──────────────────────────────────────────────────────
        // %3 = zext i32 %27 to i64
        if line.contains("= zext ") {
            if let Some(dst) = extract_assignment_dst(line) {
                if let Some(src_name) = extract_zext_source(line) {
                    let origin = origins
                        .get(&src_name)
                        .cloned()
                        .unwrap_or(ValueOrigin::Unknown);
                    origins.insert(dst, origin);
                }
            }
            continue;
        }

        // ── Call: Remill semantic intrinsic ────────────────────────────
        // %7 = call ptr @_ZN12_GLOBAL__N_1...(args)
        if line.contains("= call ") && line.contains("@_ZN") {
            let insn = decode_remill_call(line, &origins, current_pc, current_size);
            if let Some(insn) = insn {
                // Advance PC for next instruction
                if insn.semantic != Semantic::Int3 && insn.semantic != Semantic::Ret {
                    // Keep current_pc for grouping; we advance after emitting
                } else if insn.semantic == Semantic::Ret {
                    // After RET, the next instructions are padding or a new function
                }
                instructions.push(insn);

                // Advance PC
                current_pc += current_size as u64;
                current_size = 0;
            }

            // Update MEMORY origin from call result
            if let Some(dst) = extract_assignment_dst(line) {
                origins.insert(dst, ValueOrigin::Memory);
            }
            continue;
        }

        // ── Call without assignment (void calls) ──────────────────────
        if line.starts_with("call ") && line.contains("@_ZN") {
            let insn = decode_remill_call(line, &origins, current_pc, current_size);
            if let Some(insn) = insn {
                instructions.push(insn);
                current_pc += current_size as u64;
                current_size = 0;
            }
            continue;
        }
    }

    // Find function boundaries (RET followed by INT3 sequence)
    let function_boundaries = find_function_boundaries(&instructions);

    Ok(LiftedModule {
        name: func_name,
        entry_address,
        arch,
        source_file,
        instructions,
        function_boundaries,
        register_metadata: HashMap::new(),
        target_triple: String::new(),
        declared_intrinsics: Vec::new(),
    })
}

// ─── New Format Detection & Preprocessing ───────────────────────────────────

/// Detect whether the IR uses the new LLVM module format (with source_filename,
/// target datalayout, target triple, struct definitions, declares, etc.).
fn is_new_format(ir: &str) -> bool {
    for line in ir.lines().take(20) {
        let line = line.trim();
        if line.starts_with("source_filename")
            || line.starts_with("target datalayout")
            || line.starts_with("target triple")
        {
            return true;
        }
    }
    false
}

/// Preprocess IR in the new LLVM module format, extracting metadata and filtering
/// instruction lines for the existing parser.
fn preprocess_new_format(ir: &str) -> Result<PreprocessResult, String> {
    let mut arch = String::new();
    let mut source_file = String::new();
    let mut target_triple = String::new();
    let mut declared_intrinsics: Vec<String> = Vec::new();
    let mut instruction_lines: Vec<String> = Vec::new();
    let mut in_attributes_block = false;

    let register_metadata = parse_register_metadata(ir);

    for line in ir.lines() {
        let trimmed = line.trim();

        // Extract source_filename
        if trimmed.starts_with("source_filename") {
            if let Some(val) = trimmed.split('"').nth(1) {
                source_file = val.to_string();
            }
            continue;
        }

        // Extract target triple and determine architecture
        if trimmed.starts_with("target triple") {
            if let Some(val) = trimmed.split('"').nth(1) {
                target_triple = val.to_string();
                // Extract architecture from triple (first component before '-')
                let triple_arch = val.split('-').next().unwrap_or("unknown");
                arch = match triple_arch {
                    "x86_64" => "amd64".to_string(),
                    "aarch64" => "aarch64".to_string(),
                    other => other.to_string(),
                };
            }
            continue;
        }

        // Skip target datalayout
        if trimmed.starts_with("target datalayout") {
            continue;
        }

        // Skip struct type definitions (%struct.* = type { ... })
        if trimmed.starts_with("%struct.") || trimmed.starts_with("%union.") {
            continue;
        }

        // Record declare intrinsics
        if trimmed.starts_with("declare ") {
            // Extract the function name from declare line
            if let Some(at_pos) = trimmed.find('@') {
                let after_at = &trimmed[at_pos + 1..];
                let end = after_at.find('(').unwrap_or(after_at.len());
                let name = after_at[..end].to_string();
                declared_intrinsics.push(name);
            }
            continue;
        }

        // Skip attributes blocks
        if trimmed.starts_with("attributes #") {
            in_attributes_block = true;
            // Single-line attributes block
            if trimmed.contains('{') && trimmed.contains('}') {
                in_attributes_block = false;
            }
            continue;
        }
        if in_attributes_block {
            if trimmed.contains('}') {
                in_attributes_block = false;
            }
            continue;
        }

        // Skip module-level metadata (!llvm.ident, !llvm.module.flags)
        if trimmed.starts_with("!llvm.ident") || trimmed.starts_with("!llvm.module.flags") {
            continue;
        }

        // Skip numbered metadata lines (!N = !{...}) — these are handled by parse_register_metadata
        if trimmed.starts_with('!') && trimmed.contains(" = !{") {
            continue;
        }

        // Everything else is an instruction line (comments, define, GEPs, loads, stores, calls, etc.)
        instruction_lines.push(line.to_string());
    }

    Ok(PreprocessResult {
        register_metadata,
        instruction_lines,
        arch,
        source_file,
        target_triple,
        declared_intrinsics,
    })
}

/// Parse register metadata from lines like `!6 = !{[4 x i8] c"RAX\00"}`.
/// Returns a map of metadata ID → register name.
fn parse_register_metadata(ir: &str) -> HashMap<u32, String> {
    let mut metadata = HashMap::new();

    for line in ir.lines() {
        let trimmed = line.trim();

        // Match pattern: !N = !{[M x i8] c"REG\00"}
        if !trimmed.starts_with('!') {
            continue;
        }

        // Extract the numeric ID
        let rest = &trimmed[1..];
        let id_end = rest.find(|c: char| !c.is_ascii_digit()).unwrap_or(0);
        if id_end == 0 {
            continue;
        }
        let id: u32 = match rest[..id_end].parse() {
            Ok(v) => v,
            Err(_) => continue,
        };

        // Check for the pattern: = !{[N x i8] c"..."}
        if !rest[id_end..].contains("x i8] c\"") {
            continue;
        }

        // Extract the register name between c" and \00"
        if let Some(c_pos) = trimmed.find("c\"") {
            let after_c = &trimmed[c_pos + 2..];
            // Find the end — either \00" or just "
            let name_end = after_c
                .find("\\00\"")
                .or_else(|| after_c.find('"'))
                .unwrap_or(after_c.len());
            let name = after_c[..name_end].to_string();
            if !name.is_empty() {
                metadata.insert(id, name);
            }
        }
    }

    metadata
}

/// Resolve register name from a GEP instruction with `!remill_register !N` annotation.
/// Returns `Some((var_name, register_name))` if resolved, `None` otherwise.
fn resolve_gep_register(line: &str, metadata: &HashMap<u32, String>) -> Option<(String, String)> {
    // Must be a GEP on %struct.State
    if !line.contains("getelementptr inbounds %struct.State") {
        return None;
    }

    // Extract the assignment destination (%NAME = ...)
    let var_name = extract_assignment_dst(line)?;

    // Check for !remill_register !N annotation
    if let Some(meta_pos) = line.find("!remill_register !") {
        let after = &line[meta_pos + "!remill_register !".len()..];
        let id_end = after
            .find(|c: char| !c.is_ascii_digit())
            .unwrap_or(after.len());
        if id_end > 0 {
            if let Ok(id) = after[..id_end].parse::<u32>() {
                if let Some(reg_name) = metadata.get(&id) {
                    return Some((var_name, reg_name.clone()));
                }
            }
        }
    }

    // Fallback: use the assignment destination name as the register name
    Some((var_name.clone(), var_name))
}

// ─── Header Parsing ─────────────────────────────────────────────────────────

fn parse_header(ir: &str) -> (u64, String, String) {
    let mut address = 0u64;
    let mut arch = String::new();
    let mut file = String::new();

    for line in ir.lines() {
        let line = line.trim();
        if !line.starts_with(';') {
            if line.starts_with("define ") {
                break;
            }
            continue;
        }

        if let Some(rest) = line.strip_prefix("; Address: ") {
            let hex = rest.trim().trim_start_matches("0x");
            address = u64::from_str_radix(hex, 16).unwrap_or(0);
        }
        if let Some(rest) = line.strip_prefix("; Architecture: ") {
            arch = rest.trim().to_string();
        }
        if let Some(rest) = line.strip_prefix("; File: ") {
            file = rest.trim().to_string();
        }
    }

    (address, arch, file)
}

fn extract_function_name(ir: &str) -> String {
    for line in ir.lines() {
        let line = line.trim();
        if line.starts_with("define ") {
            // define ptr @lifted_5368907311(...)
            if let Some(start) = line.find('@') {
                if let Some(end) = line[start..].find('(') {
                    return line[start + 1..start + end].to_string();
                }
            }
        }
    }
    "unknown".to_string()
}

// ─── IR Line Parsing Helpers ────────────────────────────────────────────────

fn extract_assignment_dst(line: &str) -> Option<String> {
    // %NAME = ... or %123 = ...
    let line = line.trim();
    if !line.starts_with('%') {
        return None;
    }
    let eq_pos = line.find(" = ")?;
    Some(line[1..eq_pos].to_string())
}

fn extract_load_source(line: &str) -> Option<String> {
    // load TYPE, ptr %SRC, align N
    let ptr_pos = line.find("ptr %")?;
    let after = &line[ptr_pos + 4..];
    let end = after.find(|c: char| c == ',' || c == ')' || c.is_whitespace())?;
    Some(after[1..end].to_string())
}

fn extract_zext_source(line: &str) -> Option<String> {
    // Pattern: zext i32 %27 to i64
    let zext_pos = line.find("zext ")?;
    let after_zext = &line[zext_pos..];
    let pct_pos = after_zext.find('%')?;
    let after_pct = &after_zext[pct_pos + 1..];
    let end = after_pct.find(|c: char| !c.is_alphanumeric() && c != '_')?;
    Some(after_pct[..end].to_string())
}

fn parse_binop(line: &str) -> Option<(String, &'static str, String, i64)> {
    let line = line.trim();
    if !line.starts_with('%') {
        return None;
    }

    let ops: &[(&str, &str)] = &[
        (" = add ", "add"),
        (" = sub ", "sub"),
        (" = xor ", "xor"),
        (" = and ", "and"),
        (" = or ", "or"),
        (" = mul ", "mul"),
        (" = shl ", "shl"),
        (" = lshr ", "lshr"),
        (" = ashr ", "ashr"),
    ];

    for &(pattern, op_name) in ops {
        if let Some(eq_pos) = line.find(pattern) {
            let dst = line[1..eq_pos].to_string();
            let after_op = &line[eq_pos + pattern.len()..];

            // Parse: i64 %LHS, RHS
            let after_type = skip_type(after_op)?;

            // Parse LHS operand
            let (lhs, rest) = parse_value(after_type)?;
            let rest = rest.trim_start().strip_prefix(',')?.trim_start();

            // Parse RHS operand (constant)
            let rhs_val = if rest.starts_with('%') {
                // Variable RHS — we don't resolve this for now
                0
            } else {
                parse_integer(rest).unwrap_or(0)
            };

            let lhs_name = match lhs.strip_prefix('%') {
                Some(n) => n.to_string(),
                None => lhs,
            };

            return Some((dst, op_name, lhs_name, rhs_val));
        }
    }
    None
}

fn skip_type(s: &str) -> Option<&str> {
    // Skip "i64 ", "i32 ", "ptr ", "i8 ", etc.
    let s = s.trim_start();
    if let Some(rest) = s.strip_prefix("i1 ").or_else(|| s.strip_prefix("i8 ")) {
        return Some(rest);
    }

    if let Some(rest) = s
        .strip_prefix("i16 ")
        .or_else(|| s.strip_prefix("i32 "))
        .or_else(|| s.strip_prefix("i64 "))
        .or_else(|| s.strip_prefix("ptr "))
    {
        return Some(rest);
    }

    if let Some(rest) = s
        .strip_prefix("float ")
        .or_else(|| s.strip_prefix("double "))
    {
        return Some(rest);
    }

    Some(s)
}

fn parse_value(s: &str) -> Option<(String, &str)> {
    let s = s.trim_start();
    if let Some(rest) = s.strip_prefix('%') {
        let end = rest
            .find(|c: char| !c.is_alphanumeric() && c != '_')
            .unwrap_or(rest.len());
        Some((format!("%{}", &rest[..end]), &rest[end..]))
    } else if s.starts_with('-') || s.starts_with(|c: char| c.is_ascii_digit()) {
        let end = s
            .find(|c: char| !c.is_ascii_digit() && c != '-')
            .unwrap_or(s.len());
        Some((s[..end].to_string(), &s[end..]))
    } else if let Some(rest) = s.strip_prefix("null") {
        Some(("null".to_string(), rest))
    } else if let Some(rest) = s.strip_prefix("undef") {
        Some(("undef".to_string(), rest))
    } else {
        None
    }
}

fn parse_integer(s: &str) -> Option<i64> {
    let s = s.trim();
    let end = s
        .find(|c: char| !c.is_ascii_digit() && c != '-')
        .unwrap_or(s.len());
    s[..end].parse::<i64>().ok()
}

// ─── Remill Call Decoding ───────────────────────────────────────────────────

fn decode_remill_call(
    line: &str,
    origins: &HashMap<String, ValueOrigin>,
    current_pc: u64,
    current_size: u32,
) -> Option<RemillInsn> {
    // Extract the mangled function name
    let at_pos = line.find('@')?;
    let after_at = &line[at_pos + 1..];
    let paren_pos = after_at.find('(')?;
    let func_name = &after_at[..paren_pos];

    // Decode semantic from mangled name
    let semantic = remill::decode_mangled_name(func_name);

    // Parse call arguments
    let args_start = at_pos + 1 + paren_pos + 1;
    let args_end = line.rfind(')')?;
    let args_str = &line[args_start..args_end];
    let args = parse_call_args(args_str);

    // Resolve operands based on semantic type and argument origins
    let (dst, srcs, comment) = resolve_operands(&semantic, &args, origins);

    Some(RemillInsn {
        pc: current_pc,
        size: current_size,
        semantic,
        dst,
        srcs,
        comment,
    })
}

fn parse_call_args(args_str: &str) -> Vec<(String, String)> {
    // Returns Vec<(type, value)> for each argument
    let mut result = Vec::new();

    for arg in args_str.split(',') {
        let arg = arg.trim();
        if arg.is_empty() {
            continue;
        }
        // "ptr %6", "i64 %4", "i64 96", "ptr %state", "ptr undef"
        let parts: Vec<&str> = arg.splitn(2, ' ').collect();
        if parts.len() == 2 {
            result.push((parts[0].to_string(), parts[1].to_string()));
        }
    }

    result
}

fn resolve_operands(
    semantic: &Semantic,
    args: &[(String, String)],
    origins: &HashMap<String, ValueOrigin>,
) -> (Option<Operand>, Vec<Operand>, String) {
    let mut comment = String::new();

    // Skip first 2 args (Memory, State) — they're always present
    let operand_args: Vec<&(String, String)> = args.iter().skip(2).collect();

    let resolve_arg = |value: &str| -> Option<Operand> {
        if let Some(name) = value.strip_prefix('%') {
            match origins.get(name) {
                Some(ValueOrigin::RegPtr(r)) => Some(Operand::Reg(r.clone())),
                Some(ValueOrigin::RegValue(r)) => Some(Operand::Reg(r.clone())),
                Some(ValueOrigin::Constant(v)) => Some(Operand::Imm(*v)),
                Some(ValueOrigin::PcRelative(target)) => Some(Operand::Addr(*target as u64)),
                Some(ValueOrigin::RegPlusOffset(base, disp)) => Some(Operand::Mem {
                    base: base.clone(),
                    disp: *disp,
                    size_bits: 64,
                }),
                _ => Some(Operand::Reg(name.to_string())),
            }
        } else if let Ok(v) = value.parse::<i64>() {
            Some(Operand::Imm(v))
        } else {
            None
        }
    };

    match semantic {
        Semantic::Mov | Semantic::Lea => {
            // Arg 0: destination, Arg 1: source
            let dst = operand_args.first().and_then(|(_, v)| resolve_arg(v));
            let src = operand_args.get(1).and_then(|(_, v)| resolve_arg(v));
            let srcs = src.into_iter().collect();
            (dst, srcs, comment)
        }

        Semantic::Add | Semantic::Sub | Semantic::Xor | Semantic::And | Semantic::Or => {
            // Arg 0: destination, Arg 1: src1, Arg 2: src2
            let dst = operand_args.first().and_then(|(_, v)| resolve_arg(v));
            let src1 = operand_args.get(1).and_then(|(_, v)| resolve_arg(v));
            let src2 = operand_args.get(2).and_then(|(_, v)| resolve_arg(v));
            let srcs: Vec<Operand> = [src1, src2].into_iter().flatten().collect();
            (dst, srcs, comment)
        }

        Semantic::Call => {
            let target = operand_args.first().and_then(|(_, v)| resolve_arg(v));
            match &target {
                Some(Operand::Addr(addr)) => comment = format!("call sub_{:x}", addr),
                Some(Operand::Imm(v)) => comment = format!("call sub_{:x}", v),
                Some(Operand::Reg(r)) => comment = format!("call [{}]", r.to_lowercase()),
                _ => {}
            }
            let dst = Some(Operand::Reg("RAX".into()));
            let srcs = target.into_iter().collect();
            (dst, srcs, comment)
        }

        Semantic::Test | Semantic::Cmp => {
            // TEST/CMP: no destination, two source operands
            let src1 = operand_args.first().and_then(|(_, v)| resolve_arg(v));
            let src2 = operand_args.get(1).and_then(|(_, v)| resolve_arg(v));
            let srcs: Vec<Operand> = [src1, src2].into_iter().flatten().collect();
            (None, srcs, comment)
        }

        Semantic::Jcc(_) => {
            // JZ/JNZ: args = [BRANCH_TAKEN, target_addr, fallthrough_addr, NEXT_PC_ptr]
            let target = operand_args.get(1).and_then(|(_, v)| resolve_arg(v));
            let fallthrough = operand_args.get(2).and_then(|(_, v)| resolve_arg(v));
            if let Some(Operand::Addr(t)) = &target {
                comment = format!("target 0x{:x}", t);
            } else if let Some(Operand::Imm(t)) = &target {
                comment = format!("target 0x{:x}", t);
            }
            let srcs: Vec<Operand> = [target, fallthrough].into_iter().flatten().collect();
            (None, srcs, comment)
        }

        Semantic::Jmp => {
            // JMP: args = [target_addr]
            let target = operand_args.get(1).and_then(|(_, v)| resolve_arg(v));
            if let Some(Operand::Addr(t)) = &target {
                comment = format!("jmp 0x{:x}", t);
            } else if let Some(Operand::Imm(t)) = &target {
                comment = format!("jmp 0x{:x}", t);
            }
            let srcs: Vec<Operand> = target.into_iter().collect();
            (None, srcs, comment)
        }

        Semantic::Ret => (None, vec![], "return".to_string()),

        Semantic::Int3 => (None, vec![], "padding".to_string()),

        Semantic::Push => {
            let src = operand_args.first().and_then(|(_, v)| resolve_arg(v));
            (None, src.into_iter().collect(), comment)
        }

        Semantic::Pop => {
            let dst = operand_args.first().and_then(|(_, v)| resolve_arg(v));
            (dst, vec![], comment)
        }

        Semantic::Inc | Semantic::Dec => {
            // INC/DEC [mem]: args = [dst_addr, src_addr]
            let dst = operand_args.first().and_then(|(_, v)| resolve_arg(v));
            let src = operand_args.get(1).and_then(|(_, v)| resolve_arg(v));
            (dst, src.into_iter().collect(), comment)
        }

        _ => {
            let dst = operand_args.first().and_then(|(_, v)| resolve_arg(v));
            let srcs: Vec<Operand> = operand_args
                .iter()
                .skip(1)
                .filter_map(|(_, v)| resolve_arg(v))
                .collect();
            (dst, srcs, comment)
        }
    }
}

// ─── Function Boundary Detection ────────────────────────────────────────────

fn find_function_boundaries(instructions: &[RemillInsn]) -> Vec<usize> {
    let mut boundaries = vec![0]; // First function starts at index 0

    let mut i = 0;
    while i < instructions.len() {
        // Look for pattern: RET, INT3+, then SUB RSP (new function prologue)
        if instructions[i].semantic == Semantic::Ret {
            // Skip INT3 padding
            let mut j = i + 1;
            while j < instructions.len() && instructions[j].semantic == Semantic::Int3 {
                j += 1;
            }
            // If there are more instructions after INT3 padding, it's a new function
            if j < instructions.len() && j > i + 1 {
                boundaries.push(j);
            }
            i = j;
        } else {
            i += 1;
        }
    }

    boundaries
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_header() {
        let ir = r#"; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: ROTTR.exe
; Address: 0x14003062f
; Architecture: amd64
; ============================================================
define ptr @lifted_5368907311(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
}"#;

        let (addr, arch, file) = parse_header(ir);
        assert_eq!(addr, 0x14003062f);
        assert_eq!(arch, "amd64");
        assert_eq!(file, "ROTTR.exe");
    }

    #[test]
    fn test_extract_function_name() {
        let ir =
            "define ptr @lifted_5368907311(ptr noalias %state, i64 %pc, ptr noalias %mem) {\n}";
        assert_eq!(extract_function_name(ir), "lifted_5368907311");
    }

    #[test]
    fn test_extract_assignment_dst() {
        assert_eq!(
            extract_assignment_dst("  %RSP = getelementptr ..."),
            Some("RSP".to_string())
        );
        assert_eq!(
            extract_assignment_dst("  %42 = load i64, ptr %RAX"),
            Some("42".to_string())
        );
    }

    #[test]
    fn test_is_new_format_old_ir() {
        // Old format IR (like log1.txt) — no source_filename, target datalayout, target triple
        let old_ir = r#"; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: ROTTR.exe
; Address: 0x14003062f
; Architecture: amd64
; ============================================================
define ptr @lifted_5368907311(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
  %RSP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 13, i32 0, i32 0, !remill_register !7
}"#;
        assert!(!is_new_format(old_ir));
    }

    #[test]
    fn test_is_new_format_new_ir() {
        // New format IR (with source_filename, target triple)
        let new_ir = r#"; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: wwzRetailEgs.exe
; Address: 0x140000000
; Architecture: amd64
; ============================================================
; ModuleID = 'test'
source_filename = "llvm-link"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-windows-msvc-coff"

%struct.State = type { %struct.X86State }
"#;
        assert!(is_new_format(new_ir));
    }

    #[test]
    fn test_parse_register_metadata() {
        let ir = r#"
!0 = !{!"clang version 18.1.8"}
!5 = !{!"base.helper.semantics"}
!6 = !{[4 x i8] c"RAX\00"}
!7 = !{[3 x i8] c"AL\00"}
!8 = !{[4 x i8] c"RBX\00"}
!9 = !{[4 x i8] c"R10\00"}
!10 = !{[3 x i8] c"PC\00"}
"#;
        let metadata = parse_register_metadata(ir);
        assert_eq!(metadata.get(&6), Some(&"RAX".to_string()));
        assert_eq!(metadata.get(&7), Some(&"AL".to_string()));
        assert_eq!(metadata.get(&8), Some(&"RBX".to_string()));
        assert_eq!(metadata.get(&9), Some(&"R10".to_string()));
        assert_eq!(metadata.get(&10), Some(&"PC".to_string()));
        // !0 and !5 are not register metadata — they don't match the pattern
        assert!(metadata.get(&0).is_none());
        assert!(metadata.get(&5).is_none());
    }

    #[test]
    fn test_resolve_gep_register_with_metadata() {
        let mut metadata = HashMap::new();
        metadata.insert(6, "RAX".to_string());

        let line = "  %RAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !6";
        let result = resolve_gep_register(line, &metadata);
        assert_eq!(result, Some(("RAX".to_string(), "RAX".to_string())));
    }

    #[test]
    fn test_resolve_gep_register_without_metadata() {
        let metadata = HashMap::new(); // empty — no metadata available

        // GEP line without !remill_register annotation
        let line = "  %RSP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 13, i32 0, i32 0";
        let result = resolve_gep_register(line, &metadata);
        // Should fallback to assignment name
        assert_eq!(result, Some(("RSP".to_string(), "RSP".to_string())));
    }

    #[test]
    fn test_preprocess_new_format() {
        let ir = r#"source_filename = "llvm-link"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-windows-msvc-coff"

%struct.State = type { %struct.X86State }
%struct.X86State = type { i64 }

declare dso_local zeroext i8 @__remill_read_memory_8(ptr noundef, i64 noundef) #0
declare dso_local ptr @__remill_write_memory_8(ptr noundef, i64 noundef, i8 noundef zeroext) #0

define ptr @lifted_5368709120(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
  %RAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !6
}

attributes #0 = { noduplicate noinline nounwind optnone }

!llvm.ident = !{!0}
!llvm.module.flags = !{!1}

!0 = !{!"clang version 18.1.8"}
!1 = !{i32 1, !"wchar_size", i32 4}
!6 = !{[4 x i8] c"RAX\00"}
"#;
        let result = preprocess_new_format(ir).unwrap();
        assert_eq!(result.arch, "amd64");
        assert_eq!(result.source_file, "llvm-link");
        assert_eq!(result.target_triple, "x86_64-unknown-windows-msvc-coff");
        assert_eq!(result.declared_intrinsics.len(), 2);
        assert!(result
            .declared_intrinsics
            .contains(&"__remill_read_memory_8".to_string()));
        assert!(result
            .declared_intrinsics
            .contains(&"__remill_write_memory_8".to_string()));
        // Struct defs, declares, attributes, metadata should be filtered out
        // Only the define and GEP instruction lines should remain
        assert!(result
            .instruction_lines
            .iter()
            .any(|l| l.contains("define ptr @lifted_5368709120")));
        assert!(result
            .instruction_lines
            .iter()
            .any(|l| l.contains("getelementptr")));
        // Struct defs should NOT be in instruction lines
        assert!(!result
            .instruction_lines
            .iter()
            .any(|l| l.contains("%struct.State = type")));
        // Register metadata should be extracted
        assert_eq!(result.register_metadata.get(&6), Some(&"RAX".to_string()));
    }

    #[test]
    fn test_parse_remill_ir_old_format_unchanged() {
        // Minimal old-format IR snippet — should parse without error using old path
        let old_ir = r#"; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: ROTTR.exe
; Address: 0x14003062f
; Architecture: amd64
; ============================================================
define ptr @lifted_5368907311(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
  %RSP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 13, i32 0, i32 0, !remill_register !7
  %BRANCH_TAKEN = alloca i8, align 1
  %RETURN_PC = alloca i64, align 8
  %MONITOR = alloca i64, align 8
  store i64 0, ptr %MONITOR, align 8
  %MEMORY = alloca ptr, align 8
  store ptr %memory, ptr %MEMORY, align 8
  %NEXT_PC = alloca i64, align 8
  store i64 %program_counter, ptr %NEXT_PC, align 8
  %PC = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 33, i32 0, i32 0, !remill_register !14
}"#;
        let module = parse_remill_ir(old_ir).unwrap();
        assert_eq!(module.name, "lifted_5368907311");
        assert_eq!(module.entry_address, 0x14003062f);
        assert_eq!(module.arch, "amd64");
        assert_eq!(module.source_file, "ROTTR.exe");
        // Old format should have empty new-format fields
        assert!(module.register_metadata.is_empty());
        assert!(module.target_triple.is_empty());
        assert!(module.declared_intrinsics.is_empty());
    }

    #[test]
    fn test_parse_remill_ir_new_format() {
        // Load the actual Remill-1 test file (path relative to workspace root)
        let workspace_root = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
            .parent()
            .unwrap()
            .parent()
            .unwrap();
        let path = workspace_root.join("tests/Remill-1/01-camera-init.ll");
        let ir = match std::fs::read_to_string(&path) {
            Ok(ir) => ir,
            Err(_) => {
                eprintln!("SKIP: test data not found at {:?}", path);
                return;
            }
        };
        let module = parse_remill_ir(&ir).unwrap();
        // Should parse successfully with new format
        assert!(!module.name.is_empty());
        assert!(
            !module.instructions.is_empty(),
            "should produce instructions from new format IR"
        );
        assert_eq!(module.arch, "amd64");
        assert_eq!(module.target_triple, "x86_64-unknown-windows-msvc-coff");
        // Should have register metadata
        assert!(!module.register_metadata.is_empty());
        // Should have declared intrinsics
        assert!(!module.declared_intrinsics.is_empty());
    }
}
