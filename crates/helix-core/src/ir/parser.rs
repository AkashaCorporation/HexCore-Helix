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
    })
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
}
