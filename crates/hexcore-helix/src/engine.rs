//! NAPI-RS wrapper for the Helix decompilation engine.
//!
//! Exposes `HelixEngine` as a JavaScript class with methods for
//! decompilation, CFG retrieval, and AST access.

use napi::bindgen_prelude::*;
use napi_derive::napi;

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
/// const result = engine.decompile(binaryBuffer, 0x400000n, 0x401000n);
/// console.log(result.source);
/// engine.dispose();
/// ```
#[napi]
pub struct HelixEngine {
    arch: helix_core::ArchKind,
    // In Phase 2+, this will hold the actual engine handle:
    // handle: Option<helix_core::ffi::EngineHandle>,
    disposed: bool,
}

#[napi]
impl HelixEngine {
    /// Create a new Helix engine instance for the specified architecture.
    #[napi(constructor)]
    pub fn new(arch: Architecture) -> Result<Self> {
        let core_arch: helix_core::ArchKind = arch.into();
        Ok(Self {
            arch: core_arch,
            disposed: false,
        })
    }

    /// Get the engine version string.
    #[napi]
    pub fn version(&self) -> String {
        format!("helix-js={} native=pending", env!("CARGO_PKG_VERSION"))
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
        &self,
        data: Buffer,
        base_address: BigInt,
        entry_address: BigInt,
    ) -> Result<DecompileResult> {
        if self.disposed {
            return Err(Error::from_reason(
                "HelixEngine has been disposed. Create a new instance.",
            ));
        }

        let _base = base_address.get_u64().1;
        let _entry = entry_address.get_u64().1;
        let _bytes = data.as_ref();

        // Phase 1: Return stub result
        // Phase 2+: This will call helix_core::ffi::EngineHandle::decompile()
        Ok(DecompileResult {
            source: format!(
                "// HexCore Helix v{} — {} stub\n\
                 // Decompilation engine pending MLIR integration (Phase 2)\n\
                 // Input: {} bytes at base 0x{:x}, entry 0x{:x}\n\n\
                 int sub_{:x}(void) {{\n    return 0;\n}}",
                env!("CARGO_PKG_VERSION"),
                self.arch,
                _bytes.len(),
                _base,
                _entry,
                _entry,
            ),
            function_name: format!("sub_{:x}", _entry),
            entry_address: format!("0x{:x}", _entry),
            block_count: 0,
            instruction_count: 0,
            cfg_buffer: None,
            ast_buffer: None,
        })
    }

    /// Decompile Remill LLVM IR text into pseudo-C source code.
    ///
    /// This method takes the raw IR text output from HexCore's Remill lifter
    /// and transforms it into human-readable decompiled code. This is the
    /// **primary integration path** for the HexCore IDE.
    ///
    /// - `ir_text`: The LLVM IR text from `hexcore-remill`
    #[napi]
    pub fn decompile_ir(&self, ir_text: String) -> Result<DecompileResult> {
        if self.disposed {
            return Err(Error::from_reason(
                "HelixEngine has been disposed. Create a new instance.",
            ));
        }

        // Validate input
        if ir_text.is_empty() {
            return Err(Error::from_reason(
                "IR text is empty. Provide Remill LLVM IR output.",
            ));
        }

        // Use the trait-based pipeline
        let lifter = RemillIrLifter::new();
        let input = LiftIrInput { ir_text };

        let pipeline = IrPipeline::new(Box::new(lifter));
        let (output, _metrics) = pipeline
            .execute(&input)
            .map_err(|e| Error::from_reason(format!("Decompilation failed: {}", e)))?;

        // Construir buffers FlatBuffer
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
        })
    }

    /// Decompile Remill LLVM IR and return metrics alongside the result.
    ///
    /// Same as `decompile_ir` but also returns pipeline performance data.
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

        // Construir buffers antes de mover output.source
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
        // Phase 2+: Drop the engine handle here
    }

    /// Check if the engine has been disposed.
    #[napi(getter)]
    pub fn is_disposed(&self) -> bool {
        self.disposed
    }
}
