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
    explicit Pipeline(mlir::MLIRContext* mlir_ctx, HelixArch arch);
    ~Pipeline();

    // No copy, move only.
    Pipeline(const Pipeline&) = delete;
    Pipeline& operator=(const Pipeline&) = delete;
    Pipeline(Pipeline&&) noexcept;
    Pipeline& operator=(Pipeline&&) noexcept;

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

    /// Build the pass manager if not already built.
    void ensurePipelineBuilt();
};

} // namespace helix

#endif // HELIX_PIPELINE_H
