/// @file Engine.cpp
/// @brief Helix engine implementation — Phase 2 MLIR pipeline.

#include "helix/Engine.h"
#include "helix/Pipeline.h"
#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixHighDialect.h"

#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Dialect.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/DLTI/DLTI.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/UB/IR/UBOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Pass/PassManager.h"

#include <cstring>
#include <format>

namespace helix {

// ─── Construction ──────────────────────────────────────────────────────────────

Engine::Engine(HelixArch arch)
    : arch_(arch)
{
    // Initialize MLIR context with all required dialects.
    mlir_context_ = std::make_unique<mlir::MLIRContext>();

    // Register required dialects.
    // LLVMDialect + DLTIDialect: required by translateLLVMIRToModule()
    // HelixLow + HelixHigh: Helix pass pipeline dialects
    // cf, arith, ub, func, scf: used by passes and translation infrastructure
    mlir_context_->getOrLoadDialect<mlir::LLVM::LLVMDialect>();
    mlir_context_->getOrLoadDialect<mlir::DLTIDialect>();
    mlir_context_->getOrLoadDialect<mlir::cf::ControlFlowDialect>();
    mlir_context_->getOrLoadDialect<mlir::arith::ArithDialect>();
    mlir_context_->getOrLoadDialect<mlir::ub::UBDialect>();
    mlir_context_->getOrLoadDialect<mlir::func::FuncDialect>();
    mlir_context_->getOrLoadDialect<mlir::scf::SCFDialect>();
    mlir_context_->getOrLoadDialect<helix::low::HelixLowDialect>();
    mlir_context_->getOrLoadDialect<helix::high::HelixHighDialect>();

    // Register all Helix passes.
    registerHelixPasses();

    // Create the decompilation pipeline.
    pipeline_ = std::make_unique<Pipeline>(mlir_context_.get(), arch);
}

Engine::~Engine() = default;
Engine::Engine(Engine&&) noexcept = default;
Engine& Engine::operator=(Engine&&) noexcept = default;

// ─── API ───────────────────────────────────────────────────────────────────────

const char* Engine::version() noexcept {
    return "0.2.0-mlir";
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

    // Phase 2 stub for binary input: needs Remill lifter integration.
    last_error_ = "Binary decompilation requires Remill lifter. Use decompileIR() with LLVM IR text.";
    return HELIX_ERROR_INTERNAL;
}

HelixStatus Engine::decompileIR(
    const char* ir_text,
    size_t ir_len,
    uint8_t* out_buf,
    size_t* out_len)
{
    // Input validation
    if (!ir_text || ir_len == 0) {
        last_error_ = "IR text is null or empty";
        return HELIX_ERROR_INVALID_INPUT;
    }

    if (!out_buf || !out_len || *out_len == 0) {
        last_error_ = "Output buffer is null or has zero capacity";
        return HELIX_ERROR_INVALID_INPUT;
    }

    // Run the full MLIR decompilation pipeline.
    //
    // NOTE: MLIR can recurse deeply on large IR inputs (400+ SSA values
    // in a single basic block).  Callers MUST ensure adequate stack space:
    //   - helix_tool.exe: /STACK:16777216 set in CMakeLists.txt
    //   - Rust FFI: caller spawns a thread with 16 MB stack via
    //     std::thread::Builder::stack_size()
    llvm::StringRef irStr(ir_text, ir_len);
    auto result = pipeline_->decompile(irStr);

    if (!result) {
        last_error_ = result.error();
        return HELIX_ERROR_INTERNAL;
    }

    // Copy FlatBuffer output to the caller's buffer.
    auto& output = result.value();
    auto& flatbuf = output.flatbuffer;

    if (*out_len < flatbuf.size()) {
        last_error_ = std::format(
            "Output buffer too small: need {} bytes, have {}",
            flatbuf.size(), *out_len);
        *out_len = flatbuf.size();
        return HELIX_ERROR_OUT_OF_MEMORY;
    }

    std::memcpy(out_buf, flatbuf.data(), flatbuf.size());
    *out_len = flatbuf.size();
    last_error_.clear();

    return HELIX_OK;
}

HelixStatus Engine::decompileIRText(
    const char* ir_text,
    size_t ir_len,
    char* out_buf,
    size_t* out_len)
{
    // Input validation
    if (!ir_text || ir_len == 0) {
        last_error_ = "IR text is null or empty";
        return HELIX_ERROR_INVALID_INPUT;
    }

    if (!out_buf || !out_len || *out_len == 0) {
        last_error_ = "Output buffer is null or has zero capacity";
        return HELIX_ERROR_INVALID_INPUT;
    }

    // Run the full MLIR decompilation pipeline.
    // Stack requirements documented in decompileIR().
    llvm::StringRef irStr(ir_text, ir_len);
    auto result = pipeline_->decompile(irStr);

    if (!result) {
        last_error_ = result.error();
        return HELIX_ERROR_INTERNAL;
    }

    // Copy pseudo-C text to the caller's buffer.
    auto& output = result.value();
    auto& pseudo_c = output.pseudo_c;
    size_t needed = pseudo_c.size() + 1;  // +1 for null terminator

    if (*out_len < needed) {
        last_error_ = std::format(
            "Output buffer too small: need {} bytes, have {}",
            needed, *out_len);
        *out_len = needed;
        return HELIX_ERROR_OUT_OF_MEMORY;
    }

    std::memcpy(out_buf, pseudo_c.data(), pseudo_c.size());
    out_buf[pseudo_c.size()] = '\0';
    *out_len = needed;
    last_error_.clear();

    return HELIX_OK;
}

const char* Engine::lastError() const noexcept {
    return last_error_.empty() ? nullptr : last_error_.c_str();
}

} // namespace helix
