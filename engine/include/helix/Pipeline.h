#pragma once
/// @file Pipeline.h
/// @brief Helix MLIR decompilation pipeline orchestration.
///
/// The Pipeline class manages the full decompilation flow:
///   1. Parse LLVM IR text → llvm::Module
///   2. Translate llvm::Module → MLIR (LLVM Dialect)
///   3. Run MLIR pass pipeline (HelixLow → HelixHigh)
///   4. Emit output (pseudo-C text or FlatBuffer)

#ifndef HELIX_PIPELINE_H
#define HELIX_PIPELINE_H

#include "helix/Types.h"

#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/OwningOpRef.h"
#include "mlir/Pass/PassManager.h"

#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/ADT/StringRef.h"

#include <expected>
#include <memory>
#include <string>
#include <vector>

namespace helix {

/// Result type for pipeline operations.
template <typename T>
using PipelineResult = std::expected<T, std::string>;

/// Decompiled output in both text and binary forms.
struct DecompileOutput {
    /// Pseudo-C source code.
    std::string pseudo_c;
    /// FlatBuffer-serialized AST (file identifier "HAST").
    std::vector<uint8_t> flatbuffer;
};

/// The MLIR decompilation pipeline.
///
/// Manages LLVM and MLIR contexts, dialect registration, pass pipeline
/// construction, and the full decompilation flow from LLVM IR text to
/// structured pseudo-C output.
class Pipeline {
public:
    /// Construct a pipeline for the given target architecture.
    /// @param skip_optimization  If true, skip Tier 2/3 optimization passes
    ///                           (HelixLow→Mid→High conversions are still run,
    ///                           but semantic optimizations are skipped).
    explicit Pipeline(mlir::MLIRContext* mlir_ctx, HelixArch arch,
                      bool skip_optimization = false);
    ~Pipeline();

    // No copy, move only.
    Pipeline(const Pipeline&) = delete;
    Pipeline& operator=(const Pipeline&) = delete;
    Pipeline(Pipeline&&) noexcept;
    Pipeline& operator=(Pipeline&&) noexcept;

    /// Enable a specific nightly pass by name (for debugging).
    /// When any pass is selectively enabled, ONLY those passes run.
    void enablePass(std::string_view name);

    /// Enable the C AST layer for emission (Phase 4d).
    /// When true, uses CAstBuilder → CAstOptimizer → CAstPrinter
    /// instead of PseudoCEmitter.
    void setUseCastLayer(bool use) { use_cast_layer_ = use; }

    /// Enable CFG-topology-preserving lowering (callfuscation-deflatten path).
    /// When true, RemillToHelixLow honours intra-function `br` edges for
    /// constant-target direct jumps instead of reclassifying them as external
    /// tail-calls.  Forces a pipeline rebuild so the flag reaches the pass.
    void setPreserveCfg(bool v) { preserve_cfg_ = v; pipeline_built_ = false; }

    /// Add a variable rename mapping (old_name → new_name).
    /// Applied during the C AST phase to all CVarRefExpr nodes.
    /// Call before decompile(). Multiple renames can be added.
    void addVariableRename(std::string_view old_name, std::string_view new_name) {
        variable_renames_[std::string(old_name)] = std::string(new_name);
    }

    /// Clear all variable renames (call between decompile invocations).
    void clearVariableRenames() { variable_renames_.clear(); }

    /// Get the current rename map (const access for CAstOptimizer).
    [[nodiscard]] const std::unordered_map<std::string, std::string>&
    variableRenames() const { return variable_renames_; }

    /// Provide the authoritative function-start table (entry addresses).
    /// Seeded into the `helix.function_starts` module attribute by
    /// translateToMLIR BEFORE the C-AST address registry is built, so an
    /// isolated single-function lift becomes authoritative (D2 / #30 honesty).
    /// Call before decompile().  Replaces the full set on each call.
    void setFunctionStarts(const int64_t* starts, size_t len) {
        function_starts_.assign(
            reinterpret_cast<const uint64_t*>(starts),
            reinterpret_cast<const uint64_t*>(starts) + len);
    }

    /// Get the externally-supplied function-start table (const access for
    /// translateToMLIR's attribute stamping).
    [[nodiscard]] const std::vector<uint64_t>&
    functionStarts() const { return function_starts_; }

    /// Provide function signatures and nominal struct layouts extracted from
    /// DWARF/BTF/PDB. The JSON is stamped on the ModuleOp and consumed by the
    /// late debug-type seed pass. Empty clears the side channel.
    void setDebugTypeInfoJson(std::string json) {
        debug_type_info_json_ = std::move(json);
    }

    // ─── Stage 1: LLVM IR Parsing ────────────────────────────────────────

    /// Parse LLVM IR text into an llvm::Module.
    ///
    /// @param ir_text  The LLVM IR assembly text (content of a .ll file).
    /// @return         The parsed LLVM module or an error message.
    PipelineResult<std::unique_ptr<llvm::Module>>
    parseLLVMIR(llvm::StringRef ir_text);

    // ─── Stage 2: LLVM → MLIR Translation ───────────────────────────────

    /// Translate an llvm::Module to an MLIR module using the LLVM Dialect.
    ///
    /// Uses mlir::translateModuleFromLLVMIR() to produce an MLIR module
    /// containing llvm.func, llvm.call, llvm.getelementptr, etc.
    ///
    /// @param llvm_module  The LLVM module (consumed via move).
    /// @return             The MLIR module or an error message.
    PipelineResult<mlir::OwningOpRef<mlir::ModuleOp>>
    translateToMLIR(std::unique_ptr<llvm::Module> llvm_module);

    // ─── Stage 3: Pass Pipeline ──────────────────────────────────────────

    /// Build the MLIR pass pipeline for decompilation.
    ///
    /// Registers passes in order:
    ///   1. RemillToHelixLow (LLVM Dialect → HelixLow)
    ///   2. RecoverStackLayout
    ///   3. RecoverCallingConvention
    ///   4. PropagateTypes
    ///   5. StructureControlFlow (HelixLow → HelixHigh)
    ///   6. RecoverVariables
    ///   7. EliminateDeadCode
    ///   8. MLIR built-in (CSE, Canonicalize)
    void buildPassPipeline(mlir::PassManager& pm);

    /// Run the full pass pipeline on an MLIR module.
    ///
    /// @param module  The MLIR module (modified in place).
    /// @return        Success or an error message.
    PipelineResult<void> runPasses(mlir::ModuleOp module);

    // ─── Stage 4: Emission ───────────────────────────────────────────────

    /// Emit pseudo-C text from a HelixHigh MLIR module.
    ///
    /// @param module  The MLIR module after the full pass pipeline.
    /// @return        Pseudo-C source code or an error message.
    PipelineResult<std::string> emitPseudoC(mlir::ModuleOp module);

    /// Serialize a HelixHigh MLIR module to FlatBuffer format.
    ///
    /// @param module  The MLIR module after the full pass pipeline.
    /// @return        FlatBuffer bytes (AstModule, file ID "HAST") or error.
    PipelineResult<std::vector<uint8_t>> emitFlatBuffer(mlir::ModuleOp module);

    // ─── Full Pipeline ───────────────────────────────────────────────────

    /// Run the complete decompilation pipeline from IR text to output.
    ///
    /// Equivalent to: parseLLVMIR → translateToMLIR → runPasses → emit.
    ///
    /// @param ir_text  LLVM IR assembly text.
    /// @return         Decompiled output (pseudo-C + FlatBuffer) or error.
    PipelineResult<DecompileOutput> decompile(llvm::StringRef ir_text);

    /// Get the target architecture.
    [[nodiscard]] HelixArch arch() const noexcept { return arch_; }

private:
    mlir::MLIRContext* mlir_ctx_;
    HelixArch arch_;

    /// LLVM context for IR parsing (each Pipeline owns one).
    std::unique_ptr<llvm::LLVMContext> llvm_ctx_;

    /// MLIR pass manager (lazily built on first use).
    std::unique_ptr<mlir::PassManager> pass_manager_;
    bool pipeline_built_ = false;

    /// When true, skip optimization passes (Tier 2.5 optimizations).
    bool skip_optimization_ = false;

    /// When true, RemillToHelixLow preserves intra-function jmp edges
    /// (callfuscation-deflatten path).  Default false → normal lifts unchanged.
    bool preserve_cfg_ = false;

    /// Per-pass enable flags for nightly debugging.
    /// When all are false + skip_optimization=false, ALL nightly passes run.
    /// When any is true, ONLY the enabled passes run (selective mode).
    bool selective_mode_ = false;
    bool enable_helix_low_simplify_ = false;
    bool enable_switch_recovery_ = false;
    bool enable_helix_mid_simplify_ = false;
    bool enable_constant_folding_ = false;
    bool enable_escape_analysis_ = false;
    bool enable_struct_recovery_ = false;

    /// When true, emit via C AST layer (default since v0.8.0).
    /// When false, emit via legacy PseudoCEmitter (--legacy-emitter).
    bool use_cast_layer_ = true;

    /// Variable rename map: original name → user-chosen name.
    /// Populated by setVariableRename(), consumed by CAstOptimizer.
    std::unordered_map<std::string, std::string> variable_renames_;

    /// Externally-supplied authoritative function-start table (entry
    /// addresses).  Populated by setFunctionStarts() from the NAPI/IDE
    /// `analyzeAll` function list; seeded into the local `functionStarts`
    /// vector in translateToMLIR before the `helix.function_starts` attribute
    /// is stamped.  Empty by default -> behaviour identical to today.
    std::vector<uint64_t> function_starts_;

    /// Versioned StructInfoJson side channel from the IDE. Kept as JSON at
    /// this boundary so Rust/NAPI do not duplicate the C++ type schema.
    std::string debug_type_info_json_;

    /// Build the pass manager if not already built.
    void ensurePipelineBuilt();
};

} // namespace helix

#endif // HELIX_PIPELINE_H
