/// @file Engine.cpp
/// @brief Helix engine implementation — Phase 1 stub.

#include "helix/Engine.h"
#include <cstring>
#include <format>

#include "mlir/IR/MLIRContext.h"
#include "mlir/Pass/PassManager.h"

namespace helix {

// ─── Construction ──────────────────────────────────────────────────────────────

Engine::Engine(HelixArch arch)
    : arch_(arch)
{
    // Phase 2: Initialize MLIR context
    mlir_context_ = std::make_unique<mlir::MLIRContext>();
    
    // Phase 2+: Initialize LLVM IR → MLIR translation
    // mlir::registerLLVMDialectTranslation(*mlir_context_);
}

Engine::~Engine() = default;

// ─── API ───────────────────────────────────────────────────────────────────────

const char* Engine::version() noexcept {
    return "0.1.0-foundation";
}

HelixStatus Engine::decompile(
    const uint8_t* data,
    size_t data_len,
    uint64_t base_addr,
    uint64_t entry_addr,
    uint8_t* out_buf,
    size_t* out_len)
{
    // Input validation
    if (!data || data_len == 0) {
        last_error_ = "Input data is null or empty";
        return HELIX_ERROR_INVALID_INPUT;
    }

    if (!out_buf || !out_len || *out_len == 0) {
        last_error_ = "Output buffer is null or has zero capacity";
        return HELIX_ERROR_INVALID_INPUT;
    }

    if (entry_addr < base_addr) {
        last_error_ = std::format(
            "Entry address 0x{:x} is outside the data range [0x{:x}, 0x{:x})",
            entry_addr, base_addr, base_addr + data_len
        );
        return HELIX_ERROR_INVALID_INPUT;
    }

    const uint64_t entry_offset = entry_addr - base_addr;
    if (entry_offset >= data_len) {
        last_error_ = std::format(
            "Entry address 0x{:x} is outside the data range [0x{:x}, 0x{:x})",
            entry_addr, base_addr, base_addr + data_len
        );
        return HELIX_ERROR_INVALID_INPUT;
    }

    // Phase 1: Return stub — no actual decompilation yet.
    // Phase 2+: This will be the full pipeline:
    //   1. Feed data to Remill lifter → LLVM IR
    //   2. Translate LLVM IR → MLIR (Helix Low-Level dialect)
    //   3. Run transform passes → Helix High-Level dialect
    //   4. Emit pseudo-C AST
    //   5. Serialize result as FlatBuffer into out_buf

    // For now, write a minimal marker into the output buffer
    const char* marker = "HELIX_STUB";
    size_t marker_len = std::strlen(marker);

    if (*out_len < marker_len) {
        last_error_ = "Output buffer too small";
        *out_len = marker_len;
        return HELIX_ERROR_OUT_OF_MEMORY;
    }

    std::memcpy(out_buf, marker, marker_len);
    *out_len = marker_len;
    last_error_.clear();

    return HELIX_OK;
}

const char* Engine::lastError() const noexcept {
    return last_error_.empty() ? nullptr : last_error_.c_str();
}

} // namespace helix
