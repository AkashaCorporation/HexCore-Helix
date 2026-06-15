//! Error types for the Helix decompilation engine.

use std::fmt;

/// Top-level error type for the Helix engine.
#[derive(Debug, thiserror::Error)]
pub enum HelixError {
    /// Error during binary lifting (Remill/LLVM).
    #[error("Lift error: {message}")]
    Lift {
        message: String,
        /// Address where the error occurred, if known.
        address: Option<u64>,
    },

    /// Error during a transform pass.
    #[error("Transform pass '{pass_name}' failed: {message}")]
    Transform { pass_name: String, message: String },

    /// Error during code emission.
    #[error("Emit error: {message}")]
    Emit { message: String },

    /// Error crossing the FFI boundary (C++ engine).
    #[error("FFI error (status {status_code}): {message}")]
    Ffi { status_code: i32, message: String },

    /// Error in FlatBuffers serialization/deserialization.
    #[error("Transport error: {message}")]
    Transport { message: String },

    /// Invalid architecture specified.
    #[error("Unsupported architecture: {0}")]
    UnsupportedArch(String),

    /// Invalid input data.
    #[error("Invalid input: {0}")]
    InvalidInput(String),

    /// Engine not initialized or already destroyed.
    #[error("Engine state error: {0}")]
    EngineState(String),

    /// Generic internal error.
    #[error("Internal error: {0}")]
    Internal(String),
}

/// Result type alias for Helix operations.
pub type HelixResult<T> = Result<T, HelixError>;

/// FFI-safe status code enum (mirrors C++ `HelixStatus`).
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
#[repr(i32)]
pub enum HelixStatus {
    Ok = 0,
    ErrorInvalidInput = -1,
    ErrorUnsupportedArch = -2,
    ErrorLiftFailed = -3,
    ErrorTransformFailed = -4,
    ErrorEmitFailed = -5,
    ErrorOutOfMemory = -6,
    ErrorEngineNotReady = -7,
    ErrorInternal = -99,
}

impl fmt::Display for HelixStatus {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            HelixStatus::Ok => write!(f, "OK"),
            HelixStatus::ErrorInvalidInput => write!(f, "Invalid input"),
            HelixStatus::ErrorUnsupportedArch => write!(f, "Unsupported architecture"),
            HelixStatus::ErrorLiftFailed => write!(f, "Lift failed"),
            HelixStatus::ErrorTransformFailed => write!(f, "Transform failed"),
            HelixStatus::ErrorEmitFailed => write!(f, "Emit failed"),
            HelixStatus::ErrorOutOfMemory => write!(f, "Out of memory"),
            HelixStatus::ErrorEngineNotReady => write!(f, "Engine not ready"),
            HelixStatus::ErrorInternal => write!(f, "Internal error"),
        }
    }
}

impl From<i32> for HelixStatus {
    fn from(code: i32) -> Self {
        match code {
            0 => HelixStatus::Ok,
            -1 => HelixStatus::ErrorInvalidInput,
            -2 => HelixStatus::ErrorUnsupportedArch,
            -3 => HelixStatus::ErrorLiftFailed,
            -4 => HelixStatus::ErrorTransformFailed,
            -5 => HelixStatus::ErrorEmitFailed,
            -6 => HelixStatus::ErrorOutOfMemory,
            -7 => HelixStatus::ErrorEngineNotReady,
            _ => HelixStatus::ErrorInternal,
        }
    }
}

impl HelixStatus {
    /// Convert a status code into a `HelixError`, if not OK.
    pub fn into_result(self) -> HelixResult<()> {
        if self == HelixStatus::Ok {
            Ok(())
        } else {
            Err(HelixError::Ffi {
                status_code: self as i32,
                message: self.to_string(),
            })
        }
    }
}
