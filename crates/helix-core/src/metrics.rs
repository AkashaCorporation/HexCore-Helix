//! Pipeline metrics and telemetry for the decompilation engine.
//!
//! Tracks timing, pass statistics, and quality metrics throughout the
//! decompilation pipeline. This data is exposed to the IDE for
//! progressive rendering feedback and performance monitoring.

use std::fmt;
use std::time::{Duration, Instant};

// ─── Pass Timing ────────────────────────────────────────────────────────────

/// Timing data for a single pipeline pass.
#[derive(Debug, Clone)]
pub struct PassTiming {
    /// Pass identifier (e.g., "remill-lift", "recover-loops", "emit-pseudoc").
    pub pass_id: String,
    /// Duration of this pass.
    pub duration: Duration,
    /// Number of items processed (instructions, blocks, etc.).
    pub items_processed: usize,
}

impl PassTiming {
    /// Throughput in items per millisecond.
    pub fn throughput(&self) -> f64 {
        let ms = self.duration.as_secs_f64() * 1000.0;
        if ms > 0.0 {
            self.items_processed as f64 / ms
        } else {
            0.0
        }
    }
}

// ─── Pipeline Metrics ───────────────────────────────────────────────────────

/// Aggregate metrics for a complete pipeline execution.
#[derive(Debug, Clone, Default)]
pub struct PipelineMetrics {
    /// Timing data for each pass in execution order.
    pub pass_timings: Vec<PassTiming>,
    /// Total wall-clock time for the full pipeline.
    pub total_duration: Duration,
    /// Input size in bytes.
    pub input_bytes: usize,
    /// Number of instructions decoded.
    pub instructions_decoded: usize,
    /// Number of functions recovered.
    pub functions_recovered: usize,
    /// Number of basic blocks in the CFG.
    pub basic_blocks: usize,
    /// Number of variables recovered.
    pub variables_recovered: usize,
    /// Number of types fully resolved.
    pub types_resolved: usize,
    /// Number of types still unknown.
    pub types_unresolved: usize,
    /// Warnings emitted during the pipeline.
    pub warnings: Vec<PipelineWarning>,
}

impl PipelineMetrics {
    pub fn new() -> Self {
        Self::default()
    }

    /// Record a pass timing.
    pub fn record_pass(&mut self, pass_id: impl Into<String>, duration: Duration, items: usize) {
        self.pass_timings.push(PassTiming {
            pass_id: pass_id.into(),
            duration,
            items_processed: items,
        });
    }

    /// Add a warning.
    pub fn warn(&mut self, kind: WarningKind, message: impl Into<String>, address: Option<u64>) {
        self.warnings.push(PipelineWarning {
            kind,
            message: message.into(),
            address,
        });
    }

    /// Total time spent in transform passes (excluding lift and emit).
    pub fn transform_duration(&self) -> Duration {
        self.pass_timings
            .iter()
            .filter(|t| !t.pass_id.starts_with("lift") && !t.pass_id.starts_with("emit"))
            .map(|t| t.duration)
            .sum()
    }

    /// Overall throughput in instructions per millisecond.
    pub fn overall_throughput(&self) -> f64 {
        let ms = self.total_duration.as_secs_f64() * 1000.0;
        if ms > 0.0 {
            self.instructions_decoded as f64 / ms
        } else {
            0.0
        }
    }
}

impl fmt::Display for PipelineMetrics {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        writeln!(f, "Pipeline Metrics:")?;
        writeln!(
            f,
            "  Total: {:.3}ms ({} instr, {} funcs, {} blocks)",
            self.total_duration.as_secs_f64() * 1000.0,
            self.instructions_decoded,
            self.functions_recovered,
            self.basic_blocks,
        )?;
        writeln!(
            f,
            "  Throughput: {:.1} instr/ms",
            self.overall_throughput()
        )?;
        writeln!(
            f,
            "  Types: {} resolved, {} unresolved",
            self.types_resolved, self.types_unresolved
        )?;
        for pass in &self.pass_timings {
            writeln!(
                f,
                "  Pass '{}': {:.3}ms ({} items, {:.1} items/ms)",
                pass.pass_id,
                pass.duration.as_secs_f64() * 1000.0,
                pass.items_processed,
                pass.throughput(),
            )?;
        }
        if !self.warnings.is_empty() {
            writeln!(f, "  Warnings: {}", self.warnings.len())?;
            for w in &self.warnings {
                writeln!(f, "    [{:?}] {}", w.kind, w.message)?;
            }
        }
        Ok(())
    }
}

// ─── Warnings ───────────────────────────────────────────────────────────────

/// Categories of pipeline warnings.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum WarningKind {
    /// Unrecognized instruction semantic.
    UnknownSemantic,
    /// Failed to recover structured control flow.
    UnstructuredFlow,
    /// Type inference could not determine a type.
    TypeInference,
    /// Call target could not be resolved.
    UnresolvedCall,
    /// Stack frame analysis was incomplete.
    IncompleteFrame,
    /// Potential data loss from truncation or narrowing.
    Truncation,
    /// Instruction was skipped as dead code.
    DeadCode,
    /// General informational message.
    Info,
}

/// A warning produced during the pipeline.
#[derive(Debug, Clone)]
pub struct PipelineWarning {
    pub kind: WarningKind,
    pub message: String,
    pub address: Option<u64>,
}

// ─── Scoped Timer ───────────────────────────────────────────────────────────

/// RAII timer for measuring pass durations.
///
/// # Usage
/// ```ignore
/// let timer = ScopedTimer::start("my-pass");
/// // ... do work ...
/// let timing = timer.finish(item_count);
/// metrics.pass_timings.push(timing);
/// ```
pub struct ScopedTimer {
    pass_id: String,
    start: Instant,
}

impl ScopedTimer {
    pub fn start(pass_id: impl Into<String>) -> Self {
        ScopedTimer {
            pass_id: pass_id.into(),
            start: Instant::now(),
        }
    }

    pub fn finish(self, items_processed: usize) -> PassTiming {
        PassTiming {
            pass_id: self.pass_id,
            duration: self.start.elapsed(),
            items_processed,
        }
    }

    pub fn elapsed(&self) -> Duration {
        self.start.elapsed()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn metrics_record_pass() {
        let mut m = PipelineMetrics::new();
        m.record_pass("test-pass", Duration::from_millis(5), 100);
        assert_eq!(m.pass_timings.len(), 1);
        assert_eq!(m.pass_timings[0].pass_id, "test-pass");
        assert_eq!(m.pass_timings[0].items_processed, 100);
    }

    #[test]
    fn metrics_throughput() {
        let mut m = PipelineMetrics::new();
        m.total_duration = Duration::from_millis(10);
        m.instructions_decoded = 50;
        assert!((m.overall_throughput() - 5.0).abs() < 0.01);
    }

    #[test]
    fn scoped_timer_records_duration() {
        let timer = ScopedTimer::start("bench");
        std::thread::sleep(Duration::from_millis(1));
        let timing = timer.finish(42);
        assert_eq!(timing.pass_id, "bench");
        assert!(timing.duration >= Duration::from_millis(1));
        assert_eq!(timing.items_processed, 42);
    }

    #[test]
    fn warning_kinds() {
        let mut m = PipelineMetrics::new();
        m.warn(WarningKind::UnknownSemantic, "unknown opcode", Some(0x1000));
        assert_eq!(m.warnings.len(), 1);
        assert_eq!(m.warnings[0].kind, WarningKind::UnknownSemantic);
    }
}
