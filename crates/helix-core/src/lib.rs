//! # Helix Core
//!
//! Core types, traits, and FFI boundary for the HexCore Helix decompilation engine.
//!
//! This crate is **Node.js-independent** — it defines the fundamental data structures
//! and pipeline abstractions used by the Helix engine. The NAPI-RS bridge
//! (`hexcore-helix`) wraps this crate for VS Code integration.
//!
//! ## Architecture
//!
//! ```text
//! ┌──────────────┐     C API (extern "C")     ┌──────────────┐
//! │  C++23/MLIR  │ ◄──────────────────────────► │  helix-core  │
//! │   Engine     │    opaque pointers + enums   │  (this crate)│
//! └──────────────┘                              └──────┬───────┘
//!                                                      │ Rust types
//!                                               ┌──────▼───────┐
//!                                               │ hexcore-helix│
//!                                               │  (NAPI-RS)   │
//!                                               └──────────────┘
//! ```

pub mod analysis;
pub mod ast;
pub mod decompile;
pub mod diagnostics;
pub mod error;
pub mod ffi;
pub mod ir;
pub mod metrics;
pub mod pipeline;
pub mod signatures;
pub mod transforms;
pub mod types;

// Re-export core types at crate root for ergonomic access
pub use ast::{AstNode, DataType, Expression, Function, Statement, Variable};
pub use decompile::{decompile_ir, decompile_ir_via_hir};
pub use diagnostics::{Diagnostic, DiagnosticKind, DiagnosticSink, Severity};
pub use error::HelixError;
pub use metrics::PipelineMetrics;
pub use pipeline::{
    Emitter, EmitFormat, EmitOutput, IrLifter, IrPipeline, Lifter, LiftInput, LiftIrInput,
    Pipeline, TransformPass,
};
pub use types::{Address, ArchKind, BasicBlock, ControlFlowGraph, Instruction, Register};
