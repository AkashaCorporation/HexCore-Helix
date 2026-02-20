//! Structured diagnostics for the decompilation pipeline.
//!
//! Instead of ad-hoc `Vec<String>` diagnostics, this module provides a typed
//! diagnostic system that can be filtered, counted, and displayed.
//!
//! ## Severity Levels
//!
//! - **Error**: Something that prevented correct decompilation.
//! - **Warning**: Degraded output quality (e.g., unknown semantic, unresolved type).
//! - **Info**: Informational (e.g., metrics, recovery stats).
//! - **Hint**: Suggestions for improving decompilation (e.g., add signature).
//!
//! ## Usage
//!
//! ```ignore
//! let mut diag = DiagnosticSink::new();
//! diag.warn("sub_100", 0x100, DiagnosticKind::UnresolvedType, "RAX type unknown");
//! diag.info("sub_100", 0x100, DiagnosticKind::Recovery, "3 args recovered");
//! ```

use std::fmt;

// ─── Diagnostic Severity ────────────────────────────────────────────────────

/// Severity level for a diagnostic message.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub enum Severity {
    /// Hints and suggestions — lowest priority.
    Hint,
    /// Informational messages (metrics, stats).
    Info,
    /// Warnings about quality degradation.
    Warning,
    /// Errors that prevented correct decompilation.
    Error,
}

impl fmt::Display for Severity {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Severity::Hint => write!(f, "hint"),
            Severity::Info => write!(f, "info"),
            Severity::Warning => write!(f, "warning"),
            Severity::Error => write!(f, "error"),
        }
    }
}

// ─── Diagnostic Kind ────────────────────────────────────────────────────────

/// Category of diagnostic — enables filtering and aggregation.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum DiagnosticKind {
    /// Parser couldn't understand the input.
    ParseError,
    /// Unknown instruction semantic.
    UnknownSemantic,
    /// Type could not be resolved.
    UnresolvedType,
    /// Calling convention recovery issue.
    CallingConvention,
    /// Stack frame analysis.
    StackFrame,
    /// Dead code elimination.
    DeadCode,
    /// Recovery statistics (info).
    Recovery,
    /// Performance metrics.
    Performance,
    /// Missing signature for a call target.
    MissingSignature,
    /// HIR validation issue.
    Validation,
    /// General informational.
    General,
}

impl fmt::Display for DiagnosticKind {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            DiagnosticKind::ParseError => write!(f, "parse"),
            DiagnosticKind::UnknownSemantic => write!(f, "semantic"),
            DiagnosticKind::UnresolvedType => write!(f, "type"),
            DiagnosticKind::CallingConvention => write!(f, "calling-convention"),
            DiagnosticKind::StackFrame => write!(f, "stack"),
            DiagnosticKind::DeadCode => write!(f, "dead-code"),
            DiagnosticKind::Recovery => write!(f, "recovery"),
            DiagnosticKind::Performance => write!(f, "perf"),
            DiagnosticKind::MissingSignature => write!(f, "signature"),
            DiagnosticKind::Validation => write!(f, "validation"),
            DiagnosticKind::General => write!(f, "general"),
        }
    }
}

// ─── Diagnostic ─────────────────────────────────────────────────────────────

/// A single diagnostic message with context.
#[derive(Debug, Clone)]
pub struct Diagnostic {
    /// Severity level.
    pub severity: Severity,
    /// Category of the diagnostic.
    pub kind: DiagnosticKind,
    /// Function name where the issue occurred (if applicable).
    pub function: Option<String>,
    /// Address where the issue occurred (if applicable).
    pub address: Option<u64>,
    /// Human-readable message.
    pub message: String,
}

impl fmt::Display for Diagnostic {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "[{}:{}]", self.severity, self.kind)?;
        if let Some(func) = &self.function {
            write!(f, " {}", func)?;
        }
        if let Some(addr) = self.address {
            write!(f, " @0x{:x}", addr)?;
        }
        write!(f, ": {}", self.message)
    }
}

// ─── Diagnostic Sink ────────────────────────────────────────────────────────

/// Collects diagnostics during a decompilation run.
///
/// Thread-safe (but not concurrent — designed for single-threaded pipeline use).
#[derive(Debug, Clone, Default)]
pub struct DiagnosticSink {
    diagnostics: Vec<Diagnostic>,
}

impl DiagnosticSink {
    pub fn new() -> Self {
        Self::default()
    }

    /// Add a diagnostic.
    pub fn push(&mut self, diagnostic: Diagnostic) {
        self.diagnostics.push(diagnostic);
    }

    /// Convenience: add an error diagnostic.
    pub fn error(
        &mut self,
        function: impl Into<String>,
        address: u64,
        kind: DiagnosticKind,
        message: impl Into<String>,
    ) {
        self.push(Diagnostic {
            severity: Severity::Error,
            kind,
            function: Some(function.into()),
            address: if address != 0 { Some(address) } else { None },
            message: message.into(),
        });
    }

    /// Convenience: add a warning diagnostic.
    pub fn warn(
        &mut self,
        function: impl Into<String>,
        address: u64,
        kind: DiagnosticKind,
        message: impl Into<String>,
    ) {
        self.push(Diagnostic {
            severity: Severity::Warning,
            kind,
            function: Some(function.into()),
            address: if address != 0 { Some(address) } else { None },
            message: message.into(),
        });
    }

    /// Convenience: add an info diagnostic.
    pub fn info(
        &mut self,
        function: impl Into<String>,
        address: u64,
        kind: DiagnosticKind,
        message: impl Into<String>,
    ) {
        self.push(Diagnostic {
            severity: Severity::Info,
            kind,
            function: Some(function.into()),
            address: if address != 0 { Some(address) } else { None },
            message: message.into(),
        });
    }

    /// Convenience: add a module-level info diagnostic (no function context).
    pub fn module_info(
        &mut self,
        kind: DiagnosticKind,
        message: impl Into<String>,
    ) {
        self.push(Diagnostic {
            severity: Severity::Info,
            kind,
            function: None,
            address: None,
            message: message.into(),
        });
    }

    /// Convenience: add a hint diagnostic.
    pub fn hint(
        &mut self,
        function: impl Into<String>,
        address: u64,
        kind: DiagnosticKind,
        message: impl Into<String>,
    ) {
        self.push(Diagnostic {
            severity: Severity::Hint,
            kind,
            function: Some(function.into()),
            address: if address != 0 { Some(address) } else { None },
            message: message.into(),
        });
    }

    /// Get all diagnostics.
    pub fn all(&self) -> &[Diagnostic] {
        &self.diagnostics
    }

    /// Filter diagnostics by severity.
    pub fn by_severity(&self, severity: Severity) -> Vec<&Diagnostic> {
        self.diagnostics
            .iter()
            .filter(|d| d.severity == severity)
            .collect()
    }

    /// Filter diagnostics by kind.
    pub fn by_kind(&self, kind: DiagnosticKind) -> Vec<&Diagnostic> {
        self.diagnostics
            .iter()
            .filter(|d| d.kind == kind)
            .collect()
    }

    /// Filter diagnostics by function name.
    pub fn by_function(&self, function: &str) -> Vec<&Diagnostic> {
        self.diagnostics
            .iter()
            .filter(|d| d.function.as_deref() == Some(function))
            .collect()
    }

    /// Count diagnostics by severity.
    pub fn count_by_severity(&self, severity: Severity) -> usize {
        self.diagnostics
            .iter()
            .filter(|d| d.severity == severity)
            .count()
    }

    /// Total diagnostic count.
    pub fn len(&self) -> usize {
        self.diagnostics.len()
    }

    /// Whether the sink is empty.
    pub fn is_empty(&self) -> bool {
        self.diagnostics.is_empty()
    }

    /// Check if there are any errors.
    pub fn has_errors(&self) -> bool {
        self.diagnostics
            .iter()
            .any(|d| d.severity == Severity::Error)
    }

    /// Check if there are any warnings.
    pub fn has_warnings(&self) -> bool {
        self.diagnostics
            .iter()
            .any(|d| d.severity == Severity::Warning)
    }

    /// Convert all diagnostics to formatted strings (for backward compat).
    pub fn to_strings(&self) -> Vec<String> {
        self.diagnostics.iter().map(|d| d.to_string()).collect()
    }

    /// Summary line for reporting.
    pub fn summary(&self) -> String {
        format!(
            "diagnostics: {} error(s), {} warning(s), {} info(s), {} hint(s)",
            self.count_by_severity(Severity::Error),
            self.count_by_severity(Severity::Warning),
            self.count_by_severity(Severity::Info),
            self.count_by_severity(Severity::Hint),
        )
    }

    /// Merge another sink into this one.
    pub fn merge(&mut self, other: DiagnosticSink) {
        self.diagnostics.extend(other.diagnostics);
    }
}

// ─── Tests ──────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sink_collects_diagnostics() {
        let mut sink = DiagnosticSink::new();
        sink.error("sub_100", 0x100, DiagnosticKind::ParseError, "bad IR");
        sink.warn("sub_100", 0x110, DiagnosticKind::UnresolvedType, "unknown type for RAX");
        sink.info("sub_100", 0x100, DiagnosticKind::Recovery, "3 args recovered");
        sink.hint("sub_200", 0x200, DiagnosticKind::MissingSignature, "add signature for sub_200");

        assert_eq!(sink.len(), 4);
        assert!(sink.has_errors());
        assert!(sink.has_warnings());
    }

    #[test]
    fn filter_by_severity() {
        let mut sink = DiagnosticSink::new();
        sink.error("f1", 0, DiagnosticKind::ParseError, "a");
        sink.warn("f1", 0, DiagnosticKind::UnresolvedType, "b");
        sink.info("f1", 0, DiagnosticKind::Recovery, "c");

        assert_eq!(sink.by_severity(Severity::Error).len(), 1);
        assert_eq!(sink.by_severity(Severity::Warning).len(), 1);
        assert_eq!(sink.by_severity(Severity::Info).len(), 1);
    }

    #[test]
    fn filter_by_kind() {
        let mut sink = DiagnosticSink::new();
        sink.warn("f1", 0, DiagnosticKind::UnresolvedType, "a");
        sink.warn("f1", 0, DiagnosticKind::UnresolvedType, "b");
        sink.warn("f1", 0, DiagnosticKind::CallingConvention, "c");

        assert_eq!(sink.by_kind(DiagnosticKind::UnresolvedType).len(), 2);
        assert_eq!(sink.by_kind(DiagnosticKind::CallingConvention).len(), 1);
    }

    #[test]
    fn filter_by_function() {
        let mut sink = DiagnosticSink::new();
        sink.info("sub_100", 0, DiagnosticKind::General, "a");
        sink.info("sub_200", 0, DiagnosticKind::General, "b");
        sink.info("sub_100", 0, DiagnosticKind::General, "c");

        assert_eq!(sink.by_function("sub_100").len(), 2);
        assert_eq!(sink.by_function("sub_200").len(), 1);
    }

    #[test]
    fn summary_formatting() {
        let mut sink = DiagnosticSink::new();
        sink.error("f", 0, DiagnosticKind::ParseError, "x");
        sink.warn("f", 0, DiagnosticKind::General, "y");

        let summary = sink.summary();
        assert!(summary.contains("1 error(s)"));
        assert!(summary.contains("1 warning(s)"));
    }

    #[test]
    fn diagnostic_display() {
        let d = Diagnostic {
            severity: Severity::Warning,
            kind: DiagnosticKind::UnresolvedType,
            function: Some("sub_100".into()),
            address: Some(0x140001000),
            message: "RAX type unknown".into(),
        };
        let s = d.to_string();
        assert!(s.contains("warning"));
        assert!(s.contains("type"));
        assert!(s.contains("sub_100"));
        assert!(s.contains("0x140001000"));
        assert!(s.contains("RAX type unknown"));
    }

    #[test]
    fn merge_sinks() {
        let mut a = DiagnosticSink::new();
        a.info("f1", 0, DiagnosticKind::General, "a");

        let mut b = DiagnosticSink::new();
        b.warn("f2", 0, DiagnosticKind::General, "b");

        a.merge(b);
        assert_eq!(a.len(), 2);
    }

    #[test]
    fn empty_sink() {
        let sink = DiagnosticSink::new();
        assert!(sink.is_empty());
        assert!(!sink.has_errors());
        assert!(!sink.has_warnings());
    }
}
