#pragma once
/// @file RemillDemangler.h
/// @brief Utilities for demangling Remill semantic function names.
///
/// Remill encodes instruction semantics as C++ functions with mangled names
/// in the pattern `_ZN12_GLOBAL__N_1<len><NAME>I...`. This module extracts
/// the semantic operation name (ADD, SUB, MOV, CMP, TEST, CALL, etc.) from
/// these mangled names.
///
/// Port of the Rust decode_mangled_name logic from
/// crates/helix-core/src/ir/remill.rs.

#ifndef HELIX_ANALYSIS_REMILL_DEMANGLER_H
#define HELIX_ANALYSIS_REMILL_DEMANGLER_H

#include "llvm/ADT/StringRef.h"
#include <optional>
#include <string>

namespace helix {

/// Known Remill semantic operation categories.
enum class RemillSemantic {
    // Data movement
    MOV, MOVZX, MOVSX, CMOV, XCHG, LEA, CDQ, CDQE,
    // Arithmetic
    ADD, SUB, MUL, IMUL, DIV, IDIV, INC, DEC, NEG,
    // Logic
    AND, OR, XOR, NOT, SHL, SHR, SAR, ROL, ROR,
    // Comparison
    CMP, TEST,
    // Stack
    PUSH, POP,
    // Control flow
    CALL, RET, JMP, JZ, JNZ, JB, JNB, JBE, JNBE, JL, JNL, JLE, JNLE,
    JS, JNS, JO, JNO, JP, JNP,
    // Bit manipulation
    BSF, BSR, BSWAP, BT, BTS, BTR, BTC,
    // String operations
    REP_MOVS, REP_STOS, REP_CMPS, REP_SCAS,
    // Special
    NOP, INT3, SYSCALL, CPUID,
    // x87 FPU (future)
    FLD, FST, FSTP, FADD, FSUB, FMUL, FDIV,
    // SSE/AVX scalar
    MOVSS, MOVSD, MOVAPS, MOVUPS, ADDSS, ADDSD,
    MULSS, MULSD, SUBSS, SUBSD, DIVSS, DIVSD,
    XORPS, XORPD, PXOR,
    // SSE/AVX packed & misc
    MOVxPS, MOVSS_MEM, SHUFPS, SUBPS, ADDPS, MULPS,
    COMISS, UNPCKHPS,
    // SETcc (conditional byte set)
    SETcc,
    // CMPXCHG
    CMPXCHG,
    // PREFETCH (hint, no semantic effect)
    PREFETCH,
    // CDQ/CDQE variants with explicit register suffix
    CDQ_EAX, CDQE_EAX,
    // HandleUnsupported (Remill catch-all for unlifted instructions)
    HANDLE_UNSUPPORTED,
    // Unrecognized
    Unknown,
};

/// Result of demangling a Remill function name.
struct RemillSemanticInfo {
    /// The recognized semantic operation.
    RemillSemantic semantic;
    /// The raw extracted name string (e.g., "ADD", "MOVZX", "NOP_IMPL").
    std::string raw_name;
    /// Whether this is a helper/intrinsic rather than a semantic.
    bool is_helper = false;
};

/// Attempt to demangle a Remill semantic function name.
///
/// Recognizes patterns:
///   `_ZN12_GLOBAL__N_1<len><NAME>I...`  → semantic function
///   `__remill_read_memory_<N>`          → memory read intrinsic
///   `__remill_write_memory_<N>`         → memory write intrinsic
///   `__remill_flag_computation_<name>`  → flag computation
///   `llvm.ctpop.*`                      → LLVM intrinsic
///
/// @param mangled_name  The mangled function name from LLVM IR.
/// @return              Semantic info if recognized, std::nullopt otherwise.
std::optional<RemillSemanticInfo> demangleRemillSemantic(llvm::StringRef mangled_name);

/// Extract the bit width from a Remill memory intrinsic name.
///
/// `__remill_read_memory_8`  → 8
/// `__remill_read_memory_64` → 64
///
/// @param intrinsic_name  The __remill_*_memory_N name.
/// @return                Bit width, or 0 if not recognized.
unsigned extractRemillMemoryWidth(llvm::StringRef intrinsic_name);

/// Convert a RemillSemantic enum to a human-readable string.
llvm::StringRef semanticToString(RemillSemantic semantic);

/// Check if a semantic represents a conditional jump (Jcc).
bool isConditionalJump(RemillSemantic semantic);

/// Get the condition name for a Jcc semantic (e.g., JZ → "z", JNZ → "nz").
std::optional<std::string> getJccCondition(RemillSemantic semantic);

} // namespace helix

#endif // HELIX_ANALYSIS_REMILL_DEMANGLER_H
