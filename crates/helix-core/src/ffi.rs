//! FFI boundary between the Rust layer and the C++23 MLIR engine.
//!
//! This module defines:
//! - Opaque handle types for the C++ engine
//! - `extern "C"` function declarations matching `engine/src/CApi.cpp`
//! - Safe Rust wrappers around the unsafe FFI calls
//!
//! # Safety Contract
//!
//! The C API uses opaque pointers (`*mut HelixEngineHandle`) that are
//! created by `helix_engine_create` and destroyed by `helix_engine_destroy`.
//! The Rust side owns the lifecycle and guarantees single-ownership.

use crate::error::{HelixError, HelixResult, HelixStatus};
use crate::types::ArchKind;
use std::ffi::CStr;
use std::os::raw::{c_char, c_int};
use std::ptr;

const INITIAL_OUTPUT_CAPACITY: usize = 256 * 1024;
const MAX_OUTPUT_CAPACITY: usize = 64 * 1024 * 1024;
const MAX_REALLOC_ATTEMPTS: usize = 8;

// ─── Opaque Handle ─────────────────────────────────────────────────────────────

/// Opaque handle to the C++ Helix engine instance.
/// This is a pointer to `helix::Engine` allocated on the C++ side.
#[repr(C)]
pub struct HelixEngineHandle {
    _opaque: [u8; 0],
}

// ─── C API Declarations ────────────────────────────────────────────────────────

extern "C" {
    /// Create a new Helix engine instance.
    /// Returns null on failure. Caller must call `helix_engine_destroy` when done.
    pub fn helix_engine_create(arch: c_int) -> *mut HelixEngineHandle;

    /// Destroy a Helix engine instance. Pointer becomes invalid after this call.
    pub fn helix_engine_destroy(engine: *mut HelixEngineHandle);

    /// Get the engine version string. Returns a static string (do not free).
    pub fn helix_engine_version() -> *const c_char;

    /// Decompile a function at the given address from the provided binary data.
    pub fn helix_engine_decompile(
        engine: *mut HelixEngineHandle,
        data: *const u8,
        data_len: usize,
        base_addr: u64,
        entry_addr: u64,
        out_buf: *mut u8,
        out_len: *mut usize,
    ) -> c_int;

    /// Decompile LLVM IR text through the MLIR pipeline, returning FlatBuffer output.
    pub fn helix_engine_decompile_ir(
        engine: *mut HelixEngineHandle,
        ir_text: *const c_char,
        ir_len: usize,
        out_buf: *mut u8,
        out_len: *mut usize,
    ) -> c_int;

    /// Decompile LLVM IR text and return pseudo-C source code directly.
    pub fn helix_engine_decompile_ir_text(
        engine: *mut HelixEngineHandle,
        ir_text: *const c_char,
        ir_len: usize,
        out_buf: *mut c_char,
        out_len: *mut usize,
    ) -> c_int;

    /// Get the last error message from the engine. Returns null if no error.
    /// The returned string is valid until the next engine call.
    pub fn helix_engine_last_error(engine: *mut HelixEngineHandle) -> *const c_char;
}

// ─── Safe Rust Wrapper ─────────────────────────────────────────────────────────

/// Safe wrapper around the C++ Helix engine.
///
/// Owns the opaque handle and ensures proper cleanup via `Drop`.
pub struct EngineHandle {
    handle: *mut HelixEngineHandle,
}

// Safety: The C++ engine is designed to be used from a single thread per instance.
// Each EngineHandle owns its instance exclusively.
unsafe impl Send for EngineHandle {}

impl EngineHandle {
    /// Create a new engine instance for the given architecture.
    pub fn new(arch: ArchKind) -> HelixResult<Self> {
        let handle = unsafe { helix_engine_create(arch as c_int) };
        if handle.is_null() {
            return Err(HelixError::EngineState(
                "Failed to create Helix engine — helix_engine_create returned null".into(),
            ));
        }
        Ok(Self { handle })
    }

    /// Get the engine version string.
    pub fn version() -> String {
        unsafe {
            let ptr = helix_engine_version();
            if ptr.is_null() {
                return "unknown".into();
            }
            CStr::from_ptr(ptr).to_string_lossy().into_owned()
        }
    }

    /// Decompile binary data, returning the result as a FlatBuffer byte vector.
    pub fn decompile(
        &mut self,
        data: &[u8],
        base_addr: u64,
        entry_addr: u64,
    ) -> HelixResult<Vec<u8>> {
        let mut out_buf: Vec<u8> = vec![0u8; INITIAL_OUTPUT_CAPACITY];

        for _ in 0..MAX_REALLOC_ATTEMPTS {
            let mut out_len = out_buf.len();

            let status = unsafe {
                helix_engine_decompile(
                    self.handle,
                    data.as_ptr(),
                    data.len(),
                    base_addr,
                    entry_addr,
                    out_buf.as_mut_ptr(),
                    &mut out_len,
                )
            };

            let status = HelixStatus::from(status);
            if status == HelixStatus::Ok {
                if out_len > out_buf.len() {
                    return Err(HelixError::Ffi {
                        status_code: HelixStatus::ErrorInternal as i32,
                        message: format!(
                            "Engine returned an invalid output length ({}) for capacity {}",
                            out_len,
                            out_buf.len()
                        ),
                    });
                }

                out_buf.truncate(out_len);
                return Ok(out_buf);
            }

            if status == HelixStatus::ErrorOutOfMemory {
                let requested = if out_len > out_buf.len() {
                    out_len
                } else {
                    out_buf.len().saturating_mul(2)
                };

                if requested > out_buf.len() && requested <= MAX_OUTPUT_CAPACITY {
                    out_buf.resize(requested, 0);
                    continue;
                }
            }

            let msg = self.last_error().unwrap_or_else(|| status.to_string());
            return Err(HelixError::Ffi {
                status_code: status as i32,
                message: msg,
            });
        }

        Err(HelixError::Ffi {
            status_code: HelixStatus::ErrorOutOfMemory as i32,
            message: format!(
                "Engine output exceeded configured buffer growth policy (max {} bytes)",
                MAX_OUTPUT_CAPACITY
            ),
        })
    }

    /// Decompile LLVM IR text through the MLIR pipeline, returning pseudo-C source code.
    ///
    /// This is the **primary integration path** for the HexCore IDE.
    /// Takes Remill-lifted LLVM IR and produces decompiled C-like source.
    pub fn decompile_ir_text(&mut self, ir_text: &str) -> HelixResult<String> {
        let mut out_buf: Vec<u8> = vec![0u8; INITIAL_OUTPUT_CAPACITY];

        for _ in 0..MAX_REALLOC_ATTEMPTS {
            let mut out_len = out_buf.len();

            let status = unsafe {
                helix_engine_decompile_ir_text(
                    self.handle,
                    ir_text.as_ptr() as *const c_char,
                    ir_text.len(),
                    out_buf.as_mut_ptr() as *mut c_char,
                    &mut out_len,
                )
            };

            let status = HelixStatus::from(status);
            if status == HelixStatus::Ok {
                // out_len includes the null terminator; strip it
                let text_len = if out_len > 0 { out_len - 1 } else { 0 };
                out_buf.truncate(text_len);
                return String::from_utf8(out_buf).map_err(|e| HelixError::Ffi {
                    status_code: HelixStatus::ErrorInternal as i32,
                    message: format!("Engine returned invalid UTF-8: {}", e),
                });
            }

            if status == HelixStatus::ErrorOutOfMemory {
                let requested = if out_len > out_buf.len() {
                    out_len
                } else {
                    out_buf.len().saturating_mul(2)
                };

                if requested > out_buf.len() && requested <= MAX_OUTPUT_CAPACITY {
                    out_buf.resize(requested, 0);
                    continue;
                }
            }

            let msg = self.last_error().unwrap_or_else(|| status.to_string());
            return Err(HelixError::Ffi {
                status_code: status as i32,
                message: msg,
            });
        }

        Err(HelixError::Ffi {
            status_code: HelixStatus::ErrorOutOfMemory as i32,
            message: format!(
                "Engine output exceeded configured buffer growth policy (max {} bytes)",
                MAX_OUTPUT_CAPACITY
            ),
        })
    }

    /// Decompile LLVM IR text through the MLIR pipeline, returning FlatBuffer bytes.
    pub fn decompile_ir(&mut self, ir_text: &str) -> HelixResult<Vec<u8>> {
        let mut out_buf: Vec<u8> = vec![0u8; INITIAL_OUTPUT_CAPACITY];

        for _ in 0..MAX_REALLOC_ATTEMPTS {
            let mut out_len = out_buf.len();

            let status = unsafe {
                helix_engine_decompile_ir(
                    self.handle,
                    ir_text.as_ptr() as *const c_char,
                    ir_text.len(),
                    out_buf.as_mut_ptr(),
                    &mut out_len,
                )
            };

            let status = HelixStatus::from(status);
            if status == HelixStatus::Ok {
                if out_len > out_buf.len() {
                    return Err(HelixError::Ffi {
                        status_code: HelixStatus::ErrorInternal as i32,
                        message: format!(
                            "Engine returned an invalid output length ({}) for capacity {}",
                            out_len,
                            out_buf.len()
                        ),
                    });
                }
                out_buf.truncate(out_len);
                return Ok(out_buf);
            }

            if status == HelixStatus::ErrorOutOfMemory {
                let requested = if out_len > out_buf.len() {
                    out_len
                } else {
                    out_buf.len().saturating_mul(2)
                };

                if requested > out_buf.len() && requested <= MAX_OUTPUT_CAPACITY {
                    out_buf.resize(requested, 0);
                    continue;
                }
            }

            let msg = self.last_error().unwrap_or_else(|| status.to_string());
            return Err(HelixError::Ffi {
                status_code: status as i32,
                message: msg,
            });
        }

        Err(HelixError::Ffi {
            status_code: HelixStatus::ErrorOutOfMemory as i32,
            message: format!(
                "Engine output exceeded configured buffer growth policy (max {} bytes)",
                MAX_OUTPUT_CAPACITY
            ),
        })
    }

    /// Get the last error message from the engine.
    fn last_error(&self) -> Option<String> {
        unsafe {
            let ptr = helix_engine_last_error(self.handle);
            if ptr.is_null() {
                return None;
            }
            Some(CStr::from_ptr(ptr).to_string_lossy().into_owned())
        }
    }
}

impl Drop for EngineHandle {
    fn drop(&mut self) {
        if !self.handle.is_null() {
            unsafe { helix_engine_destroy(self.handle) };
            self.handle = ptr::null_mut();
        }
    }
}
