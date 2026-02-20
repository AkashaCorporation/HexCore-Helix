#pragma once
/// @file Types.h
/// @brief FFI-safe types shared between the C++ engine and Rust.
///
/// These types mirror the Rust definitions in `helix_core::error::HelixStatus`
/// and `helix_core::types::ArchKind`. They form the ABI contract.

#include <cstdint>
#include <cstddef>

#ifdef __cplusplus
extern "C" {
#endif

// ─── Status Codes ──────────────────────────────────────────────────────────────

/// Result status codes. Must match Rust `HelixStatus` repr(i32).
typedef enum HelixStatus {
    HELIX_OK                    =   0,
    HELIX_ERROR_INVALID_INPUT   =  -1,
    HELIX_ERROR_UNSUPPORTED_ARCH=  -2,
    HELIX_ERROR_LIFT_FAILED     =  -3,
    HELIX_ERROR_TRANSFORM_FAILED=  -4,
    HELIX_ERROR_EMIT_FAILED     =  -5,
    HELIX_ERROR_OUT_OF_MEMORY   =  -6,
    HELIX_ERROR_ENGINE_NOT_READY=  -7,
    HELIX_ERROR_INTERNAL        = -99,
} HelixStatus;

// ─── Architecture ──────────────────────────────────────────────────────────────

/// Target architecture enum. Must match Rust `ArchKind` repr(u8).
typedef enum HelixArch {
    HELIX_ARCH_X86       = 0,
    HELIX_ARCH_X86_64    = 1,
    HELIX_ARCH_ARM       = 2,
    HELIX_ARCH_AARCH64   = 3,
    HELIX_ARCH_MIPS      = 4,
    HELIX_ARCH_MIPS64    = 5,
    HELIX_ARCH_POWERPC   = 6,
    HELIX_ARCH_POWERPC64 = 7,
    HELIX_ARCH_SPARC     = 8,
    HELIX_ARCH_SPARC64   = 9,
    HELIX_ARCH_RISCV32   = 10,
    HELIX_ARCH_RISCV64   = 11,
} HelixArch;

// ─── Opaque Handle ─────────────────────────────────────────────────────────────

/// Opaque handle to the Helix engine instance.
/// The actual struct is defined in C++ (Engine.h).
typedef struct HelixEngineHandle HelixEngineHandle;

#ifdef __cplusplus
}
#endif
