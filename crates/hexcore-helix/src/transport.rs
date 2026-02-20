//! FlatBuffers transport layer for zero-copy data transfer between
//! the Helix engine and Node.js.
//!
//! This module handles serialization of `helix-core` types into FlatBuffer
//! byte vectors that can be passed as Node.js `Buffer` objects without copying.

use napi::bindgen_prelude::*;
use napi_derive::napi;

/// Serialize a control flow graph into a FlatBuffer for the Graph View.
///
/// In Phase 1, this is a no-op returning an empty buffer.
/// In Phase 3+, this will use the `schemas/cfg.fbs` generated code.
#[napi]
pub fn serialize_cfg(_cfg_json: String) -> Result<Buffer> {
    // Phase 3: Replace with actual FlatBuffer serialization
    // let builder = flatbuffers::FlatBufferBuilder::new();
    // ... build CFG FlatBuffer ...
    // Ok(Buffer::from(builder.finished_data()))

    Ok(Buffer::from(Vec::<u8>::new()))
}

/// Serialize a decompiled AST into a FlatBuffer for the AST View.
///
/// In Phase 1, this is a no-op returning an empty buffer.
/// In Phase 3+, this will use the `schemas/ast.fbs` generated code.
#[napi]
pub fn serialize_ast(_ast_json: String) -> Result<Buffer> {
    // Phase 3: Replace with actual FlatBuffer serialization
    Ok(Buffer::from(Vec::<u8>::new()))
}

/// Read the function name from a CFG FlatBuffer without full deserialization.
///
/// Demonstrates zero-copy access — reads directly from the buffer.
#[napi]
pub fn read_cfg_function_name(buffer: Buffer) -> Result<Option<String>> {
    let data = buffer.as_ref();
    if data.is_empty() {
        return Ok(None);
    }

    // Phase 3: Use flatbuffers::root::<CfgModule>(data)
    // to access the function name without copying
    Ok(None)
}
