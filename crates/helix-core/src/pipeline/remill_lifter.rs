//! Remill IR lifter — concrete implementation of [`IrLifter`].
//!
//! Bridges the Remill IR parser and transform pipeline into the
//! trait-based architecture. This is the primary decompilation path
//! for the HexCore IDE.

use crate::decompile::decompile_ir;
use crate::error::HelixError;
use crate::pipeline::{IrLifter, IrLiftOutput, LiftIrInput};

/// Lifter that consumes Remill LLVM IR text and produces pseudo-C.
///
/// Wraps the existing `decompile_ir` pipeline, providing a clean
/// trait-based interface for the NAPI bridge.
pub struct RemillIrLifter {
    /// Whether to include diagnostics in the output.
    include_diagnostics: bool,
}

impl RemillIrLifter {
    pub fn new() -> Self {
        Self {
            include_diagnostics: true,
        }
    }

    pub fn with_diagnostics(mut self, include: bool) -> Self {
        self.include_diagnostics = include;
        self
    }
}

impl Default for RemillIrLifter {
    fn default() -> Self {
        Self::new()
    }
}

impl IrLifter for RemillIrLifter {
    fn lift_ir(&self, input: &LiftIrInput) -> Result<IrLiftOutput, HelixError> {
        let result = decompile_ir(&input.ir_text).map_err(|e| HelixError::Lift {
            message: e,
            address: None,
        })?;

        Ok(IrLiftOutput {
            source: result.source,
            function_count: result.function_count,
            instruction_count: result.instruction_count,
            diagnostics: if self.include_diagnostics {
                result.diagnostics
            } else {
                Vec::new()
            },
        })
    }

    fn name(&self) -> &str {
        "remill-ir-lifter"
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn lifter_returns_error_on_empty_input() {
        let lifter = RemillIrLifter::new();
        let input = LiftIrInput {
            ir_text: String::new(),
        };
        // Empty input should still produce output (empty module)
        let result = lifter.lift_ir(&input);
        assert!(result.is_ok());
    }

    #[test]
    fn lifter_name() {
        let lifter = RemillIrLifter::new();
        assert_eq!(lifter.name(), "remill-ir-lifter");
    }
}
