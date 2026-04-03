#pragma once
/// @file Engine.h
/// @brief The Helix decompilation engine — C++ core with C API export.

#include "helix/Types.h"
#include "helix/Pipeline.h"
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
/// Manages the MLIR context, dialect registry, and pass pipeline.
/// Provides both binary decompilation (Phase 1 API) and IR decompilation
/// (Phase 2 MLIR pipeline).
class Engine {
public:
    explicit Engine(HelixArch arch);
    ~Engine();

    // No copy, move only
    Engine(const Engine&) = delete;
    Engine& operator=(const Engine&) = delete;
    Engine(Engine&&) noexcept;
    Engine& operator=(Engine&&) noexcept;

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

    /// Decompile LLVM IR text through the full MLIR pipeline.
    ///
    /// This is the Phase 2 entry point. Takes LLVM IR text (e.g., from Remill)
    /// and produces a FlatBuffer-serialized AST.
    ///
    /// @param ir_text  LLVM IR assembly text (.ll file content)
    /// @param ir_len   Length of IR text in bytes
    /// @param out_buf  Output buffer for FlatBuffer result
    /// @param out_len  In: capacity. Out: bytes written.
    /// @return Status code
    HelixStatus decompileIR(
        const char* ir_text,
        size_t ir_len,
        uint8_t* out_buf,
        size_t* out_len
    );

    /// Decompile LLVM IR text and return pseudo-C source code directly.
    ///
    /// Same pipeline as decompileIR(), but returns the pseudo-C text output
    /// instead of FlatBuffer. This is what the CLI tool and direct callers use.
    ///
    /// @param ir_text  LLVM IR assembly text (.ll file content)
    /// @param ir_len   Length of IR text in bytes
    /// @param out_buf  Output buffer for pseudo-C text (null-terminated)
    /// @param out_len  In: capacity. Out: bytes written (including null).
    /// @return Status code
    HelixStatus decompileIRText(
        const char* ir_text,
        size_t ir_len,
        char* out_buf,
        size_t* out_len
    );

    /// Set whether to skip optimization passes in the pipeline.
    /// Must be called BEFORE the first decompile call (pipeline is lazily built).
    /// Controls Tier 2.5 passes (magic division, devirtualization).
    void setSkipOptimization(bool skip);

    /// Enable a specific nightly pass by name (for debugging/testing).
    /// Call before first decompile. Enables selective mode.
    void enablePass(const char* name);

    /// Enable the C AST layer for emission (--use-cast-layer).
    /// When true, uses CAstBuilder → CAstOptimizer → CAstPrinter
    /// instead of PseudoCEmitter.
    void setUseCastLayer(bool use);

    /// Add a variable rename mapping (old_name → new_name).
    /// When the C AST layer is active, all CVarRefExpr nodes matching
    /// old_name will be renamed to new_name in the output.
    /// Call before decompile. Multiple renames can be added.
    void addVariableRename(const char* old_name, const char* new_name);

    /// Clear all variable renames.
    void clearVariableRenames();

    /// Get the last error message. Returns nullptr if no error.
    [[nodiscard]] const char* lastError() const noexcept;

private:
    HelixArch arch_;
    std::string last_error_;

    // Phase 2: MLIR context and pipeline
    std::unique_ptr<mlir::MLIRContext> mlir_context_;
    std::unique_ptr<Pipeline> pipeline_;
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

/// Decompile LLVM IR text through the MLIR pipeline.
///
/// @param engine   Engine handle
/// @param ir_text  LLVM IR assembly text
/// @param ir_len   Length of IR text
/// @param out_buf  Output buffer for FlatBuffer result
/// @param out_len  In: capacity. Out: bytes written.
/// @return Status code (0 = success)
int helix_engine_decompile_ir(
    HelixEngineHandle* engine,
    const char* ir_text,
    size_t ir_len,
    uint8_t* out_buf,
    size_t* out_len
);

/// Decompile LLVM IR text and return pseudo-C source code directly.
///
/// @param engine   Engine handle
/// @param ir_text  LLVM IR assembly text
/// @param ir_len   Length of IR text
/// @param out_buf  Output buffer for null-terminated pseudo-C text
/// @param out_len  In: capacity. Out: bytes written (including null).
/// @return Status code (0 = success)
int helix_engine_decompile_ir_text(
    HelixEngineHandle* engine,
    const char* ir_text,
    size_t ir_len,
    char* out_buf,
    size_t* out_len
);

/// Set whether to skip optimization passes. Call before first decompile.
void helix_engine_set_skip_optimization(HelixEngineHandle* engine, int skip);

/// Enable a specific nightly pass by name. Call before first decompile.
/// Valid names: HelixLowSimplify, SwitchRecovery, HelixMidSimplify,
///              ConstantFolding, EscapeAnalysis, StructRecovery
void helix_engine_enable_pass(HelixEngineHandle* engine, const char* name);

/// Get the last error message. Returns nullptr if no error.
const char* helix_engine_last_error(HelixEngineHandle* engine);

/// Enable the C AST layer for emission. Call before first decompile.
/// When enabled, uses CAstBuilder + CAstOptimizer + CAstPrinter
/// instead of PseudoCEmitter.
void helix_engine_set_use_cast_layer(HelixEngineHandle* engine, int use);

/// Add a variable rename mapping. Call before decompile.
/// When the C AST layer is active, all variable references matching
/// old_name will be replaced with new_name in the decompiled output.
/// Multiple renames can be added; they accumulate until cleared.
void helix_engine_add_variable_rename(
    HelixEngineHandle* engine,
    const char* old_name,
    const char* new_name
);

/// Clear all variable renames. Call between decompile invocations
/// if the rename set changes.
void helix_engine_clear_variable_renames(HelixEngineHandle* engine);

// ─── Helix-Nightly: Data Section Access ──────────────────────────────────────

/// Callback type for reading raw bytes from the binary image.
/// Returns the number of bytes actually read (may be less than len).
typedef size_t (*helix_data_reader_fn)(uint64_t addr, uint8_t* buf, size_t len, void* user_data);

/// Set a callback for reading raw bytes from the binary image.
/// This enables jump table recovery (switch statements) and other
/// data-dependent analysis passes.
///
/// @param engine    Engine handle
/// @param reader    Callback function
/// @param user_data Opaque pointer passed to every callback invocation
void helix_engine_set_data_reader(
    HelixEngineHandle* engine,
    helix_data_reader_fn reader,
    void* user_data
);

#ifdef __cplusplus
}
#endif
