//! Módulo de serialização FlatBuffer para transporte zero-copy.
//!
//! Implementa serialização/deserialização manual dos schemas
//! `cfg.fbs`, `ast.fbs` e `common.fbs` usando a crate `flatbuffers`.
//! Gerado manualmente pois `flatc` não está disponível no ambiente de build.

pub mod ast;
pub mod cfg;

/// File identifier para CFG FlatBuffers
pub const CFG_FILE_IDENTIFIER: &str = "HCFG";

/// File identifier para AST FlatBuffers
/// Legacy Rust pseudo-AST transport. This layout is not schemas/ast.fbs and
/// must never share the canonical HAST identifier.
pub const AST_FILE_IDENTIFIER: &str = "HRST";
