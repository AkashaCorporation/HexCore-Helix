//! NAPI-RS wrapper for the Helix decompilation engine.
//!
//! Exposes `HelixEngine` as a JavaScript class with methods for
//! decompilation, CFG retrieval, and AST access.
//!
//! **Pipeline Architecture (v0.7+)**:
//! - `decompile_ir()` routes through the **C++ MLIR engine** exclusively.
//! - The Rust pipeline is deprecated and available behind `--features rust-pipeline`.

use napi::bindgen_prelude::*;
use napi_derive::napi;

use helix_core::ffi::EngineHandle;

#[cfg(feature = "rust-pipeline")]
use helix_core::pipeline::remill_lifter::RemillIrLifter;
#[cfg(feature = "rust-pipeline")]
use helix_core::pipeline::{IrPipeline, LiftIrInput};

// ─── Architecture Enum (JS-visible) ────────────────────────────────────────────

/// Target architecture for the decompiler.
#[napi]
pub enum Architecture {
    X86,
    X86_64,
    Arm,
    Aarch64,
    Mips,
    Mips64,
    PowerPc,
    PowerPc64,
    Sparc,
    Sparc64,
    Riscv32,
    Riscv64,
}

impl From<Architecture> for helix_core::ArchKind {
    fn from(arch: Architecture) -> Self {
        match arch {
            Architecture::X86 => helix_core::ArchKind::X86,
            Architecture::X86_64 => helix_core::ArchKind::X86_64,
            Architecture::Arm => helix_core::ArchKind::Arm,
            Architecture::Aarch64 => helix_core::ArchKind::Aarch64,
            Architecture::Mips => helix_core::ArchKind::Mips,
            Architecture::Mips64 => helix_core::ArchKind::Mips64,
            Architecture::PowerPc => helix_core::ArchKind::PowerPc,
            Architecture::PowerPc64 => helix_core::ArchKind::PowerPc64,
            Architecture::Sparc => helix_core::ArchKind::Sparc,
            Architecture::Sparc64 => helix_core::ArchKind::Sparc64,
            Architecture::Riscv32 => helix_core::ArchKind::Riscv32,
            Architecture::Riscv64 => helix_core::ArchKind::Riscv64,
        }
    }
}

fn read_u16(bytes: &[u8], offset: usize) -> Option<u16> {
    bytes
        .get(offset..offset.checked_add(2)?)?
        .try_into()
        .ok()
        .map(u16::from_le_bytes)
}
fn read_u32(bytes: &[u8], offset: usize) -> Option<u32> {
    bytes
        .get(offset..offset.checked_add(4)?)?
        .try_into()
        .ok()
        .map(u32::from_le_bytes)
}
fn read_i32(bytes: &[u8], offset: usize) -> Option<i32> {
    bytes
        .get(offset..offset.checked_add(4)?)?
        .try_into()
        .ok()
        .map(i32::from_le_bytes)
}
fn read_u64(bytes: &[u8], offset: usize) -> Option<u64> {
    bytes
        .get(offset..offset.checked_add(8)?)?
        .try_into()
        .ok()
        .map(u64::from_le_bytes)
}
fn canonical_table_field(
    bytes: &[u8],
    table: usize,
    slot: usize,
    width: usize,
) -> std::result::Result<Option<usize>, String> {
    let distance = read_i32(bytes, table).ok_or("HAST table is truncated")?;
    if distance <= 0 {
        return Err("HAST vtable distance is invalid".into());
    }
    let vtable = table
        .checked_sub(distance as usize)
        .ok_or("HAST vtable underflow")?;
    let vtable_size = read_u16(bytes, vtable).ok_or("HAST vtable is truncated")? as usize;
    let object_size = read_u16(bytes, vtable + 2).ok_or("HAST object size is truncated")? as usize;
    if vtable_size < 4
        || table
            .checked_add(object_size)
            .filter(|end| *end <= bytes.len())
            .is_none()
    {
        return Err("HAST table bounds are invalid".into());
    }
    if slot + 2 > vtable_size {
        return Ok(None);
    }
    let relative = read_u16(bytes, vtable + slot).ok_or("HAST field offset is truncated")? as usize;
    if relative == 0 {
        return Ok(None);
    }
    if relative
        .checked_add(width)
        .filter(|end| *end <= object_size)
        .is_none()
    {
        return Err("HAST field exceeds its table".into());
    }
    Ok(Some(table + relative))
}
fn canonical_offset(bytes: &[u8], field: usize) -> std::result::Result<usize, String> {
    let relative = read_u32(bytes, field).ok_or("HAST offset is truncated")? as usize;
    if relative == 0 {
        return Err("HAST relative offset is zero".into());
    }
    field
        .checked_add(relative)
        .filter(|offset| *offset < bytes.len())
        .ok_or_else(|| "HAST offset exceeds its buffer".into())
}

/// Read only the stable v1 module/function identity fields from canonical HAST.
fn canonical_hast_single_identity(
    bytes: &[u8],
) -> std::result::Result<Option<(String, u64)>, String> {
    if bytes.len() < 8 || &bytes[4..8] != b"HAST" {
        return Err("canonical HAST identifier is missing".into());
    }
    let root = read_u32(bytes, 0).ok_or("HAST root is truncated")? as usize;
    if root < 8 || root >= bytes.len() {
        return Err("HAST root offset is invalid".into());
    }
    let vector_field = match canonical_table_field(bytes, root, 6, 4)? {
        Some(value) => value,
        None => return Ok(None),
    };
    let vector = canonical_offset(bytes, vector_field)?;
    let count = read_u32(bytes, vector).ok_or("HAST function vector is truncated")? as usize;
    if count != 1 {
        return Ok(None);
    }
    let element = vector.checked_add(4).ok_or("HAST vector overflow")?;
    let function = canonical_offset(bytes, element)?;
    let name_field =
        canonical_table_field(bytes, function, 4, 4)?.ok_or("HAST function name is missing")?;
    let name_at = canonical_offset(bytes, name_field)?;
    let length = read_u32(bytes, name_at).ok_or("HAST name length is truncated")? as usize;
    if length > 4096 {
        return Err("HAST function name exceeds its limit".into());
    }
    let name_start = name_at.checked_add(4).ok_or("HAST name overflow")?;
    let name_bytes = bytes
        .get(name_start..name_start.checked_add(length).ok_or("HAST name overflow")?)
        .ok_or("HAST name is truncated")?;
    let name = std::str::from_utf8(name_bytes)
        .map_err(|_| "HAST function name is not UTF-8")?
        .to_owned();
    if name.is_empty() {
        return Err("HAST function name is empty".into());
    }
    let address = canonical_table_field(bytes, function, 6, 8)?
        .and_then(|field| read_u64(bytes, field))
        .unwrap_or(0);
    Ok(Some((name, address)))
}

// ─── Decompile Result (JS-visible) ─────────────────────────────────────────────

/// Result of a decompilation operation.
#[napi(object)]
pub struct DecompileResult {
    /// Decompiled pseudo-C source code.
    pub source: String,
    /// Function name.
    pub function_name: String,
    /// Entry address as hex string.
    pub entry_address: String,
    /// Number of basic blocks in the CFG.
    pub block_count: u32,
    /// Number of instructions analyzed.
    pub instruction_count: u32,
    /// Raw FlatBuffer data for the CFG (for Graph View zero-copy rendering).
    pub cfg_buffer: Option<Buffer>,
    /// Raw FlatBuffer data for the AST (for AST View zero-copy rendering).
    pub ast_buffer: Option<Buffer>,
    /// Which pipeline was used: "mlir" or "rust"
    pub pipeline: String,
}

/// Pipeline metrics exposed to JavaScript.
#[cfg(feature = "rust-pipeline")]
#[napi(object)]
pub struct PipelineMetricsResult {
    /// Total pipeline duration in milliseconds.
    pub total_ms: f64,
    /// Instructions decoded.
    pub instructions_decoded: u32,
    /// Functions recovered.
    pub functions_recovered: u32,
    /// Throughput in instructions per millisecond.
    pub throughput: f64,
    /// Number of warnings.
    pub warning_count: u32,
}

// ─── Engine Class (JS-visible) ─────────────────────────────────────────────────

/// The Helix decompilation engine.
///
/// Usage from TypeScript:
/// ```typescript
/// import { HelixEngine, Architecture } from '@hexcore/helix';
///
/// const engine = new HelixEngine(Architecture.X86_64);
/// const result = engine.decompileIr(irText);
/// console.log(result.source);  // pseudo-C from MLIR pipeline
/// engine.dispose();
/// ```
#[napi]
pub struct HelixEngine {
    arch: helix_core::ArchKind,
    /// The C++ MLIR engine handle (Phase 2+).
    mlir_handle: Option<EngineHandle>,
    disposed: bool,
}

#[napi]
impl HelixEngine {
    /// Create a new Helix engine instance for the specified architecture.
    #[napi(constructor)]
    pub fn new(arch: Architecture) -> Result<Self> {
        let core_arch: helix_core::ArchKind = arch.into();

        // Create the C++ MLIR engine handle
        let mlir_handle = EngineHandle::new(core_arch)
            .map_err(|e| Error::from_reason(format!("Failed to create MLIR engine: {}", e)))?;

        Ok(Self {
            arch: core_arch,
            mlir_handle: Some(mlir_handle),
            disposed: false,
        })
    }

    /// Set whether to skip optimization passes in the MLIR pipeline.
    /// When true, Tier 2.5 passes (magic division, devirtualization) are skipped.
    /// Must be called before the first decompile call.
    #[napi]
    pub fn set_skip_optimization(&mut self, skip: bool) -> Result<()> {
        let handle = self
            .mlir_handle
            .as_mut()
            .ok_or_else(|| Error::from_reason("Engine is disposed"))?;
        handle.set_skip_optimization(skip);
        Ok(())
    }

    /// Enable the C AST layer for emission (--use-cast-layer).
    /// When enabled, uses CAstBuilder → CAstOptimizer → CAstPrinter
    /// and produces a full HAST FlatBuffer (ast_buffer) instead of the stub.
    /// Must be called before the first decompile call.
    #[napi]
    pub fn set_use_cast_layer(&mut self, use_cast: bool) -> Result<()> {
        let handle = self
            .mlir_handle
            .as_mut()
            .ok_or_else(|| Error::from_reason("Engine is disposed"))?;
        handle.set_use_cast_layer(use_cast);
        Ok(())
    }

    /// Add a variable rename mapping (old_name → new_name).
    /// When the C AST layer is active, all variable references matching
    /// old_name will be replaced with new_name in the decompiled output.
    /// Call before decompileIr(). Multiple renames accumulate.
    #[napi]
    pub fn add_variable_rename(&mut self, old_name: String, new_name: String) -> Result<()> {
        let handle = self
            .mlir_handle
            .as_mut()
            .ok_or_else(|| Error::from_reason("Engine is disposed"))?;
        handle.add_variable_rename(&old_name, &new_name);
        Ok(())
    }

    /// Clear all variable renames. Call between decompile invocations
    /// if the rename set changes.
    #[napi]
    pub fn clear_variable_renames(&mut self) -> Result<()> {
        let handle = self
            .mlir_handle
            .as_mut()
            .ok_or_else(|| Error::from_reason("Engine is disposed"))?;
        handle.clear_variable_renames();
        Ok(())
    }

    /// Provide the authoritative function-start table (entry addresses from
    /// the Pathfinder `analyzeAll` function list) to the engine BEFORE
    /// decompileIr().  Stamped as the `helix.function_starts` module attribute
    /// in `Pipeline::translateToMLIR`, this is what makes
    /// `functionTableIsAuthoritative_` true for an isolated/IDE single-function
    /// lift, so the D2 callee-gate and the #30 registry-miss honesty path fire
    /// instead of degrading to the regression-safe non-gating fallback.
    /// Additive: callers that never call it keep today's behaviour (table
    /// derived from FuncOp entries only, non-authoritative for a lone lift).
    /// Replaces the full set on each call; pass the complete table.
    #[napi]
    pub fn set_function_starts(&mut self, starts: Vec<i64>) -> Result<()> {
        let handle = self
            .mlir_handle
            .as_mut()
            .ok_or_else(|| Error::from_reason("Engine is disposed"))?;
        handle.set_function_starts(&starts);
        Ok(())
    }

    /// Provide versioned function signatures and nominal struct layouts from
    /// DWARF/BTF/PDB. Pass an empty string to clear metadata between files.
    #[napi]
    pub fn set_debug_type_info_json(&mut self, json: String) -> Result<()> {
        let handle = self
            .mlir_handle
            .as_mut()
            .ok_or_else(|| Error::from_reason("Engine is disposed"))?;
        handle.set_debug_type_info_json(&json);
        Ok(())
    }

    /// Register a virtual-address range with the engine's data-section
    /// store.  REQUIRED for switch-table recovery — without at least one
    /// section, `RecoverSwitchTables` skips itself and every `switch (...)`
    /// in the source binary collapses to `goto default` in the decompiled
    /// output.  Call before decompileIr().  Multiple calls accumulate; each
    /// call copies the buffer (caller can free immediately).
    ///
    /// Typical usage from the extension: read the PE/ELF binary's data
    /// sections (`.rdata` for MSVC PE, `.rodata` for ELF) and pass the
    /// section's virtual address + bytes here once per file.
    #[napi]
    pub fn add_data_section(&mut self, va_start: BigInt, bytes: Buffer) -> Result<()> {
        let handle = self
            .mlir_handle
            .as_mut()
            .ok_or_else(|| Error::from_reason("Engine is disposed"))?;
        let (_signed, va, _lossless) = va_start.get_u64();
        handle.add_data_section(va, &bytes);
        Ok(())
    }

    /// Drop every registered data section.  Call between binaries.
    #[napi]
    pub fn clear_data_sections(&mut self) -> Result<()> {
        let handle = self
            .mlir_handle
            .as_mut()
            .ok_or_else(|| Error::from_reason("Engine is disposed"))?;
        handle.clear_data_sections();
        Ok(())
    }

    /// Get the engine version string.
    #[napi]
    pub fn version(&self) -> String {
        let native_ver = EngineHandle::version();
        format!(
            "helix-js={} native={}",
            env!("CARGO_PKG_VERSION"),
            native_ver
        )
    }

    /// Get the target architecture name.
    #[napi]
    pub fn architecture(&self) -> String {
        self.arch.to_string()
    }

    /// Decompile a binary buffer starting at the given entry address.
    ///
    /// - `data`: Raw binary data (Buffer)
    /// - `base_address`: Base virtual address where the data is loaded (BigInt)
    /// - `entry_address`: Entry point address to start decompilation (BigInt)
    #[napi]
    pub fn decompile(
        &mut self,
        data: Buffer,
        base_address: BigInt,
        entry_address: BigInt,
    ) -> Result<DecompileResult> {
        if self.disposed {
            return Err(Error::from_reason(
                "HelixEngine has been disposed. Create a new instance.",
            ));
        }

        let base = base_address.get_u64().1;
        let entry = entry_address.get_u64().1;
        let bytes = data.as_ref();

        // Try the C++ MLIR engine first
        if let Some(ref mut handle) = self.mlir_handle {
            match handle.decompile(bytes, base, entry) {
                Ok(flatbuf) => {
                    return Ok(DecompileResult {
                        source: format!(
                            "// MLIR decompilation via FlatBuffer ({} bytes)",
                            flatbuf.len()
                        ),
                        function_name: format!("sub_{:x}", entry),
                        entry_address: format!("0x{:x}", entry),
                        block_count: 0,
                        instruction_count: 0,
                        cfg_buffer: Some(Buffer::from(flatbuf)),
                        ast_buffer: None,
                        pipeline: "mlir".to_string(),
                    });
                }
                Err(e) => {
                    // Binary decompilation requires Remill lifter; fall through to stub
                    eprintln!("MLIR binary decompile not available: {}", e);
                }
            }
        }

        // Fallback stub for binary input
        Ok(DecompileResult {
            source: format!(
                "// HexCore Helix v{} — {}\n\
                 // Binary decompilation requires Remill lifter integration\n\
                 // Use decompileIr() with LLVM IR text instead\n\
                 // Input: {} bytes at base 0x{:x}, entry 0x{:x}\n\n\
                 int sub_{:x}(void) {{\n    return 0;\n}}",
                env!("CARGO_PKG_VERSION"),
                self.arch,
                bytes.len(),
                base,
                entry,
                entry,
            ),
            function_name: format!("sub_{:x}", entry),
            entry_address: format!("0x{:x}", entry),
            block_count: 0,
            instruction_count: 0,
            cfg_buffer: None,
            ast_buffer: None,
            pipeline: "stub".to_string(),
        })
    }

    /// Decompile Remill LLVM IR text using the **C++ MLIR pipeline**.
    ///
    /// This is the **primary integration path** for the HexCore IDE.
    /// Routes through: LLVM IR → MLIR translation → HelixLow → HelixHigh → Pseudo-C
    ///
    /// Decompile Remill LLVM IR using the C++ MLIR pipeline.
    ///
    /// Since v0.7, the Rust HIR pipeline is no longer used as a fallback.
    /// If the MLIR engine fails, the error is returned directly.
    #[napi]
    pub fn decompile_ir(&mut self, ir_text: String) -> Result<DecompileResult> {
        if self.disposed {
            return Err(Error::from_reason(
                "HelixEngine has been disposed. Create a new instance.",
            ));
        }

        if ir_text.is_empty() {
            return Err(Error::from_reason(
                "IR text is empty. Provide Remill LLVM IR output.",
            ));
        }

        // ── MLIR C++ pipeline (sole pipeline since v0.7) ──
        let handle = self.mlir_handle.as_mut().ok_or_else(|| {
            Error::from_reason("MLIR engine not initialized. Cannot decompile without C++ engine.")
        })?;

        let output = handle
            .decompile_ir_combined(&ir_text)
            .map_err(|e| Error::from_reason(format!("MLIR pipeline failed: {}", e)))?;

        let identity = canonical_hast_single_identity(&output.flatbuffer)
            .map_err(|e| Error::from_reason(format!("Canonical HAST identity failed: {}", e)))?;

        let (function_name, entry_address) = match identity {
            Some((name, address)) => (name, format!("0x{:x}", address)),
            None => (String::new(), String::new()),
        };

        Ok(DecompileResult {
            source: output.pseudo_c,
            function_name,
            entry_address,
            block_count: output.block_count,
            instruction_count: output.instruction_count,
            cfg_buffer: None,
            ast_buffer: Some(Buffer::from(output.flatbuffer)),
            pipeline: "mlir".to_string(),
        })
    }

    /// Release engine resources. The engine cannot be used after this call.
    #[napi]
    pub fn dispose(&mut self) {
        self.disposed = true;
        // Drop the MLIR engine handle
        self.mlir_handle = None;
    }

    /// Check if the engine has been disposed.
    #[napi(getter)]
    pub fn is_disposed(&self) -> bool {
        self.disposed
    }
}

#[cfg(test)]
mod canonical_hast_identity_tests {
    use super::canonical_hast_single_identity;

    #[test]
    fn rejects_legacy_and_truncated_buffers() {
        for bytes in [
            &b""[..],
            &b"\x08\0\0\0HRST"[..],
            &b"\xff\xff\xff\x7fHAST"[..],
        ] {
            assert!(canonical_hast_single_identity(bytes).is_err());
        }
    }
}

// ─── Deprecated Rust Pipeline Methods (feature-gated) ──────────────────────
//
// These methods are only available when built with `--features rust-pipeline`.
// Since v0.7, the C++ MLIR pipeline is the sole production path.

#[cfg(feature = "rust-pipeline")]
#[napi]
impl HelixEngine {
    /// Decompile using the **pure Rust pipeline** (no C++ engine required).
    ///
    /// Deprecated since v0.7: Use `decompile_ir()` instead (MLIR pipeline).
    #[napi]
    pub fn decompile_ir_rust(&self, ir_text: String) -> Result<DecompileResult> {
        if self.disposed {
            return Err(Error::from_reason(
                "HelixEngine has been disposed. Create a new instance.",
            ));
        }

        if ir_text.is_empty() {
            return Err(Error::from_reason(
                "IR text is empty. Provide Remill LLVM IR output.",
            ));
        }

        let lifter = RemillIrLifter::new();
        let input = LiftIrInput { ir_text };

        let pipeline = IrPipeline::new(Box::new(lifter));
        let (output, _metrics) = pipeline
            .execute(&input)
            .map_err(|e| Error::from_reason(format!("Decompilation failed: {}", e)))?;

        let cfg_buffer = {
            let cfg_data = crate::transport::build_cfg_data(
                "module",
                output.function_count,
                output.instruction_count,
            );
            helix_core::flatbuf::cfg::serialize_cfg(&cfg_data)
                .ok()
                .map(Buffer::from)
        };

        let ast_buffer = {
            let ast_data =
                crate::transport::build_ast_data("module", &output.source, output.function_count);
            helix_core::flatbuf::ast::serialize_ast(&ast_data)
                .ok()
                .map(Buffer::from)
        };

        Ok(DecompileResult {
            source: output.source,
            function_name: format!("module_{}", output.function_count),
            entry_address: String::new(),
            block_count: output.function_count as u32,
            instruction_count: output.instruction_count as u32,
            cfg_buffer,
            ast_buffer,
            pipeline: "rust".to_string(),
        })
    }

    /// Decompile Remill LLVM IR and return metrics alongside the result.
    ///
    /// Deprecated since v0.7: Metrics are from the Rust pipeline only.
    #[napi]
    pub fn decompile_ir_with_metrics(
        &self,
        ir_text: String,
    ) -> Result<(DecompileResult, PipelineMetricsResult)> {
        if self.disposed {
            return Err(Error::from_reason(
                "HelixEngine has been disposed. Create a new instance.",
            ));
        }

        if ir_text.is_empty() {
            return Err(Error::from_reason(
                "IR text is empty. Provide Remill LLVM IR output.",
            ));
        }

        let lifter = RemillIrLifter::new();
        let input = LiftIrInput { ir_text };
        let pipeline = IrPipeline::new(Box::new(lifter));

        let (output, metrics) = pipeline
            .execute(&input)
            .map_err(|e| Error::from_reason(format!("Decompilation failed: {}", e)))?;

        let cfg_buffer = {
            let cfg_data = crate::transport::build_cfg_data(
                "module",
                output.function_count,
                output.instruction_count,
            );
            helix_core::flatbuf::cfg::serialize_cfg(&cfg_data)
                .ok()
                .map(Buffer::from)
        };

        let ast_buffer = {
            let ast_data =
                crate::transport::build_ast_data("module", &output.source, output.function_count);
            helix_core::flatbuf::ast::serialize_ast(&ast_data)
                .ok()
                .map(Buffer::from)
        };

        let result = DecompileResult {
            source: output.source,
            function_name: format!("module_{}", output.function_count),
            entry_address: String::new(),
            block_count: output.function_count as u32,
            instruction_count: output.instruction_count as u32,
            cfg_buffer,
            ast_buffer,
            pipeline: "rust".to_string(),
        };

        let metrics_result = PipelineMetricsResult {
            total_ms: metrics.total_duration.as_secs_f64() * 1000.0,
            instructions_decoded: metrics.instructions_decoded as u32,
            functions_recovered: metrics.functions_recovered as u32,
            throughput: metrics.overall_throughput(),
            warning_count: metrics.warnings.len() as u32,
        };

        Ok((result, metrics_result))
    }
}
