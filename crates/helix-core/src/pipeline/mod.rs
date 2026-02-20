//! Decompilation pipeline traits and orchestration.
//!
//! The pipeline defines the contract between the three major stages:
//!
//! 1. **Lifter** — Converts raw binary/IR into a [`ControlFlowGraph`]
//! 2. **TransformPass** — Iteratively transforms the CFG/AST (MLIR passes)
//! 3. **Emitter** — Renders the final AST into source code text
//!
//! The [`Pipeline`] orchestrates execution of these stages.
//!
//! ## Concrete Implementations
//!
//! - [`remill_lifter::RemillLifter`] — Lifts Remill LLVM IR text
//! - [`pseudoc_emitter::PseudoCEmitter`] — Emits pseudo-C source code
//! - [`passes`] — Built-in transform passes

pub mod passes;
pub mod pseudoc_emitter;
pub mod remill_lifter;

use crate::ast::AstNode;
use crate::error::HelixError;
use crate::metrics::{PipelineMetrics, ScopedTimer};
use crate::types::{ArchKind, ControlFlowGraph};

use std::time::Instant;

// ─── Lifter ────────────────────────────────────────────────────────────────────

/// Input data for the lifter — raw binary bytes with metadata.
#[derive(Debug, Clone)]
pub struct LiftInput {
    /// Raw machine code bytes.
    pub bytes: Vec<u8>,
    /// Base address where the bytes are loaded.
    pub base_address: u64,
    /// Target architecture.
    pub arch: ArchKind,
    /// Entry point offset relative to `base_address`.
    pub entry_offset: u64,
}

/// Converts raw binary code into a control flow graph.
///
/// In the HexCore stack, this is backed by Remill (LLVM 18).
pub trait Lifter: Send + Sync {
    /// Lift the input binary into a control flow graph.
    fn lift(&self, input: &LiftInput) -> Result<ControlFlowGraph, HelixError>;

    /// Returns the name of this lifter implementation.
    fn name(&self) -> &str;
}

/// Input for the IR-based lifter — pre-lifted Remill IR text.
#[derive(Debug, Clone)]
pub struct LiftIrInput {
    /// Remill LLVM IR text.
    pub ir_text: String,
}

/// Lifter that operates on pre-lifted Remill IR text instead of raw binary.
///
/// This is the primary path for the HexCore IDE, where `hexcore-remill`
/// produces the IR and Helix consumes it.
pub trait IrLifter: Send + Sync {
    /// Lift Remill IR text into a structured form suitable for decompilation.
    fn lift_ir(&self, input: &LiftIrInput) -> Result<IrLiftOutput, HelixError>;

    /// Returns the name of this lifter implementation.
    fn name(&self) -> &str;
}

/// Output from the IR lifter — contains both the pseudo-C source and metadata.
#[derive(Debug, Clone)]
pub struct IrLiftOutput {
    /// Decompiled pseudo-C source code.
    pub source: String,
    /// Number of functions recovered.
    pub function_count: usize,
    /// Total instructions processed.
    pub instruction_count: usize,
    /// Diagnostics/warnings from the pipeline.
    pub diagnostics: Vec<String>,
}

// ─── Transform Pass ────────────────────────────────────────────────────────────

/// Metadata about a transform pass.
#[derive(Debug, Clone)]
pub struct PassInfo {
    /// Unique pass identifier (e.g., "helix.recover-loops").
    pub id: String,
    /// Human-readable description.
    pub description: String,
    /// Whether this pass can run in parallel with others.
    pub is_parallelizable: bool,
}

/// A single transformation pass in the decompilation pipeline.
///
/// Passes progressively lower the representation:
/// - Early passes operate on the CFG (structure recovery, dead code elimination)
/// - Late passes operate on the AST (variable naming, type propagation)
///
/// In the HexCore stack, these are backed by MLIR dialect conversions.
pub trait TransformPass: Send + Sync {
    /// Returns metadata about this pass.
    fn info(&self) -> PassInfo;

    /// Apply this pass to a control flow graph, producing a (possibly modified) CFG.
    fn transform_cfg(&self, cfg: ControlFlowGraph) -> Result<ControlFlowGraph, HelixError> {
        // Default: pass-through (not all passes modify the CFG)
        Ok(cfg)
    }

    /// Apply this pass to an AST node, producing a (possibly modified) AST.
    fn transform_ast(&self, ast: AstNode) -> Result<AstNode, HelixError> {
        // Default: pass-through (not all passes modify the AST)
        Ok(ast)
    }
}

// ─── Emitter ───────────────────────────────────────────────────────────────────

/// Output format for the emitter.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum EmitFormat {
    /// Pseudo-C output.
    PseudoC,
    /// LLVM IR (for debugging).
    LlvmIr,
    /// MLIR (for debugging).
    Mlir,
}

/// Emitted output from the decompiler.
#[derive(Debug, Clone)]
pub struct EmitOutput {
    /// The rendered source code text.
    pub source: String,
    /// The format used.
    pub format: EmitFormat,
    /// Mapping from source line numbers to addresses (for navigation in the IDE).
    pub line_map: Vec<(u32, u64)>,
}

/// Renders AST nodes into human-readable source code.
pub trait Emitter: Send + Sync {
    /// Emit source code from the given AST.
    fn emit(&self, ast: &[AstNode], format: EmitFormat) -> Result<EmitOutput, HelixError>;
}

// ─── Pipeline ──────────────────────────────────────────────────────────────────

/// The decompilation pipeline — orchestrates Lifter → TransformPasses → Emitter.
pub struct Pipeline {
    lifter: Box<dyn Lifter>,
    passes: Vec<Box<dyn TransformPass>>,
    emitter: Box<dyn Emitter>,
}

impl Pipeline {
    /// Create a new pipeline with the given components.
    pub fn new(
        lifter: Box<dyn Lifter>,
        passes: Vec<Box<dyn TransformPass>>,
        emitter: Box<dyn Emitter>,
    ) -> Self {
        Self {
            lifter,
            passes,
            emitter,
        }
    }

    /// Execute the full decompilation pipeline with metrics collection.
    pub fn execute(&self, input: &LiftInput) -> Result<(EmitOutput, PipelineMetrics), HelixError> {
        let pipeline_start = Instant::now();
        let mut metrics = PipelineMetrics::new();
        metrics.input_bytes = input.bytes.len();

        // Stage 1: Lift binary → CFG
        let timer = ScopedTimer::start("lift");
        let mut cfg = self.lifter.lift(input)?;
        let lift_insns = cfg.instruction_count();
        metrics.pass_timings.push(timer.finish(lift_insns));
        metrics.instructions_decoded = lift_insns;
        metrics.basic_blocks = cfg.blocks.len();

        // Stage 2: Apply CFG transform passes
        for pass in &self.passes {
            let info = pass.info();
            let timer = ScopedTimer::start(format!("cfg:{}", info.id));
            cfg = pass.transform_cfg(cfg)?;
            metrics.pass_timings.push(timer.finish(cfg.blocks.len()));
        }

        // Stage 3: Convert CFG → AST (stub — will be replaced by MLIR)
        let mut ast = vec![cfg_to_stub_ast(&cfg)];
        metrics.functions_recovered = 1;

        // Stage 4: Apply AST transform passes
        for pass in &self.passes {
            let info = pass.info();
            let timer = ScopedTimer::start(format!("ast:{}", info.id));
            ast = ast
                .into_iter()
                .map(|node| pass.transform_ast(node))
                .collect::<Result<Vec<_>, _>>()?;
            metrics.pass_timings.push(timer.finish(ast.len()));
        }

        // Stage 5: Emit source code
        let timer = ScopedTimer::start("emit");
        let output = self.emitter.emit(&ast, EmitFormat::PseudoC)?;
        metrics
            .pass_timings
            .push(timer.finish(output.source.lines().count()));

        metrics.total_duration = pipeline_start.elapsed();

        Ok((output, metrics))
    }

    /// Execute the pipeline without metrics (backward-compatible).
    pub fn execute_simple(&self, input: &LiftInput) -> Result<EmitOutput, HelixError> {
        let (output, _) = self.execute(input)?;
        Ok(output)
    }

    /// Returns info about all registered passes.
    pub fn pass_info(&self) -> Vec<PassInfo> {
        self.passes.iter().map(|p| p.info()).collect()
    }
}

// ─── IR Pipeline ───────────────────────────────────────────────────────────────

/// Pipeline that operates on pre-lifted Remill IR text.
///
/// This is the primary integration path for the HexCore IDE:
/// `hexcore-remill` lifts binary → IR text → Helix `IrPipeline` → pseudo-C.
pub struct IrPipeline {
    lifter: Box<dyn IrLifter>,
}

impl IrPipeline {
    pub fn new(lifter: Box<dyn IrLifter>) -> Self {
        Self { lifter }
    }

    /// Execute the IR pipeline with metrics.
    pub fn execute(
        &self,
        input: &LiftIrInput,
    ) -> Result<(IrLiftOutput, PipelineMetrics), HelixError> {
        let pipeline_start = Instant::now();
        let mut metrics = PipelineMetrics::new();
        metrics.input_bytes = input.ir_text.len();

        let timer = ScopedTimer::start("ir-decompile");
        let output = self.lifter.lift_ir(input)?;
        metrics.instructions_decoded = output.instruction_count;
        metrics.functions_recovered = output.function_count;
        metrics
            .pass_timings
            .push(timer.finish(output.instruction_count));

        metrics.total_duration = pipeline_start.elapsed();

        Ok((output, metrics))
    }

    /// Execute without metrics.
    pub fn execute_simple(&self, input: &LiftIrInput) -> Result<IrLiftOutput, HelixError> {
        let (output, _) = self.execute(input)?;
        Ok(output)
    }
}

/// Stub CFG-to-AST conversion — produces a skeleton function from the CFG.
/// This will be replaced by the MLIR engine in Phase 2.
fn cfg_to_stub_ast(cfg: &ControlFlowGraph) -> AstNode {
    use crate::ast::*;

    AstNode::Func(Function {
        name: cfg.name.clone(),
        address: cfg.entry,
        return_type: DataType::Unknown,
        params: Vec::new(),
        locals: Vec::new(),
        body: vec![Statement::Comment(format!(
            "Stub: {} blocks, {} instructions — pending MLIR reconstruction",
            cfg.blocks.len(),
            cfg.instruction_count()
        ))],
        calling_convention: None,
        is_variadic: false,
    })
}
