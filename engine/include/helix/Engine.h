#pragma once
/// @file Engine.h
/// @brief The Helix decompilation engine — C++ core with C API export.

#include "helix/Types.h"
#include <string>
#include <memory>
#include <vector>
#include <expected>

namespace mlir {
    class MLIRContext;
    class PassManager;
}

namespace helix {

/// The core decompilation engine.
///
/// In Phase 1, this is a stub that validates inputs and returns status codes.
/// In Phase 2+, this will hold the MLIR context, dialect registry, and pass pipeline.
class Engine {
public:
    explicit Engine(HelixArch arch);
    ~Engine();

    // No copy, move only
    Engine(const Engine&) = delete;
    Engine& operator=(const Engine&) = delete;
    Engine(Engine&&) noexcept = default;
    Engine& operator=(Engine&&) noexcept = default;

    /// Get the engine version string.
    static const char* version() noexcept;

    /// Get the target architecture.
    [[nodiscard]] HelixArch arch() const noexcept { return arch_; }

    /// Decompile binary data at the given address range.
    ///
    /// @param data     Pointer to raw binary data
    /// @param data_len Length of data in bytes
    /// @param base_addr Base virtual address
    /// @param entry_addr Function entry point address
    /// @param out_buf  Output buffer for FlatBuffer result
    /// @param out_len  In: capacity. Out: bytes written.
    /// @return Status code
    HelixStatus decompile(
        const uint8_t* data,
        size_t data_len,
        uint64_t base_addr,
        uint64_t entry_addr,
        uint8_t* out_buf,
        size_t* out_len
    );

    /// Get the last error message. Returns nullptr if no error.
    [[nodiscard]] const char* lastError() const noexcept;

private:
    HelixArch arch_;
    std::string last_error_;

    // Phase 2: MLIR context and pipeline
    std::unique_ptr<mlir::MLIRContext> mlir_context_;
    std::unique_ptr<mlir::PassManager> pass_manager_;
};

} // namespace helix

// ─── C API (exported for Rust FFI) ──────────────────────────────────────────────

#ifdef __cplusplus
extern "C" {
#endif

/// Create a new engine instance. Returns nullptr on failure.
HelixEngineHandle* helix_engine_create(int arch);

/// Destroy an engine instance.
void helix_engine_destroy(HelixEngineHandle* engine);

/// Get the engine version string. Returns a static string.
const char* helix_engine_version();

/// Decompile binary data.
int helix_engine_decompile(
    HelixEngineHandle* engine,
    const uint8_t* data,
    size_t data_len,
    uint64_t base_addr,
    uint64_t entry_addr,
    uint8_t* out_buf,
    size_t* out_len
);

/// Get the last error message. Returns nullptr if no error.
const char* helix_engine_last_error(HelixEngineHandle* engine);

#ifdef __cplusplus
}
#endif
