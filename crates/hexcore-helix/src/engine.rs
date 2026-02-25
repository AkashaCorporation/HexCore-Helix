//! NAPI-RS wrapper for the Helix decompilation engine.
//!
//! Exposes `HelixEngine` as a JavaScript class with methods for
//! decompilation, CFG retrieval, and AST access.
//!
//! **Dual Pipeline Architecture**:
//! - `decompile_ir()` routes through the **C++ MLIR engine** for maximum quality
//! - `decompile_ir_rust()` uses the **pure Rust pipeline** as fallback

use napi::bindgen_prelude::*;
use napi_derive::napi;

use helix_core::ffi::EngineHandle;
use helix_core::pipeline::remill_lifter::RemillIrLifter;
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

    /// Get the engine version string.
    #[napi]
    pub fn version(&self) -> String {
        let native_ver = EngineHandle::version();
        format!("helix-js={} native={}", env!("CARGO_PKG_VERSION"), native_ver)
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
                        source: format!("// MLIR decompilation via FlatBuffer ({} bytes)", flatbuf.len()),
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
    /// Falls back to the Rust pipeline if the MLIR engine is unavailable.
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

        // ── Try MLIR C++ pipeline first ──
        if let Some(ref mut handle) = self.mlir_handle {
            match handle.decompile_ir_text(&ir_text) {
                Ok(source) => {
                    return Ok(DecompileResult {
                        source,
                        function_name: "mlir_decompiled".to_string(),
                        entry_address: String::new(),
                        block_count: 0,
                        instruction_count: 0,
                        cfg_buffer: None,
                        ast_buffer: None,
                        pipeline: "mlir".to_string(),
                    });
                }
                Err(e) => {
                    // Log the MLIR error and fall back to Rust pipeline
                    eprintln!("MLIR pipeline failed (falling back to Rust): {}", e);
                }
            }
        }

        // ── Fallback: Rust pipeline ──
        self.decompile_ir_rust(ir_text)
    }

    /// Decompile using the **pure Rust pipeline** (no C++ engine required).
    ///
    /// This is the fallback path and can be called directly for comparison.
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

        // Build FlatBuffer data
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
            let ast_data = crate::transport::build_ast_data(
                "module",
                &output.source,
                output.function_count,
            );
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
    /// Same as `decompile_ir` but also returns pipeline performance data.
    /// Note: Metrics are currently from the Rust pipeline only.
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
            let ast_data = crate::transport::build_ast_data(
                "module",
                &output.source,
                output.function_count,
            );
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
