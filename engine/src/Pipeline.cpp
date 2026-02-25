/// @file Pipeline.cpp
/// @brief Helix MLIR decompilation pipeline implementation.
///
/// Implements the full decompilation flow:
///   1. Parse LLVM IR text into an llvm::Module
///   2. Translate llvm::Module to MLIR (LLVM Dialect)
///   3. Build and run the MLIR pass pipeline (HelixLow -> HelixHigh)
///   4. Emit output (pseudo-C text and/or FlatBuffer)

#include "helix/Pipeline.h"
#include "helix/passes/Passes.h"
#include "helix/emit/PseudoCEmitter.h"
#include "helix/emit/FlatBufSerializer.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixHighDialect.h"

// MLIR includes
#include "mlir/Target/LLVMIR/Import.h"
#include "mlir/Target/LLVMIR/Dialect/All.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/DLTI/DLTI.h"
#include "mlir/Transforms/Passes.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/IR/Verifier.h"

// LLVM includes
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_ostream.h"

#include <cassert>
#include <format>
#include <utility>

namespace helix {

// ============================================================================
//  Helper: Architecture validation
// ============================================================================

/// Returns the human-readable name for a HelixArch value, or nullopt if
/// the value is outside the known enum range.
static constexpr std::optional<const char*> archName(HelixArch arch) noexcept {
    switch (arch) {
    case HELIX_ARCH_X86:       return "x86";
    case HELIX_ARCH_X86_64:    return "x86_64";
    case HELIX_ARCH_ARM:       return "arm";
    case HELIX_ARCH_AARCH64:   return "aarch64";
    case HELIX_ARCH_MIPS:      return "mips";
    case HELIX_ARCH_MIPS64:    return "mips64";
    case HELIX_ARCH_POWERPC:   return "powerpc";
    case HELIX_ARCH_POWERPC64: return "powerpc64";
    case HELIX_ARCH_SPARC:     return "sparc";
    case HELIX_ARCH_SPARC64:   return "sparc64";
    case HELIX_ARCH_RISCV32:   return "riscv32";
    case HELIX_ARCH_RISCV64:   return "riscv64";
    }
    return std::nullopt;
}

/// Returns true if the architecture is one we currently support with a full
/// pass pipeline.  Unsupported architectures can still parse/translate IR
/// but will produce degraded output.
static constexpr bool isFullySupportedArch(HelixArch arch) noexcept {
    switch (arch) {
    case HELIX_ARCH_X86:
    case HELIX_ARCH_X86_64:
    case HELIX_ARCH_ARM:
    case HELIX_ARCH_AARCH64:
        return true;
    default:
        return false;
    }
}

// ============================================================================
//  Helper: Capture MLIR diagnostics as a string
// ============================================================================

/// RAII guard that installs a diagnostic handler on an MLIRContext and
/// accumulates all diagnostic messages into a string.  When the guard is
/// destroyed the handler is unregistered.
class DiagnosticCapture {
public:
    explicit DiagnosticCapture(mlir::MLIRContext* ctx)
        : ctx_(ctx)
    {
        handler_id_ = ctx_->getDiagEngine().registerHandler(
            [this](mlir::Diagnostic& diag) {
                llvm::raw_string_ostream os(captured_);
                if (!captured_.empty())
                    os << '\n';
                diag.print(os);
                return mlir::success();
            });
    }

    ~DiagnosticCapture() {
        ctx_->getDiagEngine().eraseHandler(handler_id_);
    }

    DiagnosticCapture(const DiagnosticCapture&) = delete;
    DiagnosticCapture& operator=(const DiagnosticCapture&) = delete;

    /// Return the accumulated diagnostic text (may be empty on success).
    [[nodiscard]] std::string take() { return std::move(captured_); }
    [[nodiscard]] bool empty() const noexcept { return captured_.empty(); }

private:
    mlir::MLIRContext* ctx_;
    mlir::DiagnosticEngine::HandlerID handler_id_;
    std::string captured_;
};

// ============================================================================
//  Construction / destruction / move
// ============================================================================

Pipeline::Pipeline(mlir::MLIRContext* mlir_ctx, HelixArch arch)
    : mlir_ctx_(mlir_ctx)
    , arch_(arch)
    , llvm_ctx_(std::make_unique<llvm::LLVMContext>())
{
    assert(mlir_ctx_ && "MLIRContext must not be null");

    // Validate that the architecture is within the known enum range.
    if (!archName(arch_).has_value()) {
        // Defensive: clamp to an invalid-but-safe sentinel so downstream
        // code never operates on a wild enum value.  Callers should check
        // archName() if they need to validate before constructing.
        arch_ = static_cast<HelixArch>(-1);
    }

    // Ensure the LLVM dialect translation infrastructure is registered so
    // that translateLLVMIRToModule() can map LLVM IR constructs to the
    // mlir::LLVM dialect. In MLIR 18.x the registration takes a DialectRegistry.
    //
    // IMPORTANT: translateLLVMIRToModule() asserts that both LLVMDialect and
    // DLTIDialect are in getAvailableDialects() BEFORE it calls
    // loadAllAvailableDialects().  We must explicitly insert DLTI into the
    // registry since registerAllFromLLVMIRTranslations() may not do so.
    {
        mlir::DialectRegistry registry;
        mlir::registerAllFromLLVMIRTranslations(registry);
        registry.insert<mlir::DLTIDialect>();
        mlir_ctx_->appendDialectRegistry(registry);
    }

    // Pre-load ALL registered dialects.  The LLVM IR importer creates ops
    // from multiple dialects (LLVM, cf, arith, func, etc.) and asserts they
    // are available in the context at import time.
    mlir_ctx_->loadAllAvailableDialects();

    // Load the Helix dialects so the pass pipeline can create their ops.
    mlir_ctx_->getOrLoadDialect<mlir::LLVM::LLVMDialect>();
    mlir_ctx_->getOrLoadDialect<helix::low::HelixLowDialect>();
    mlir_ctx_->getOrLoadDialect<helix::high::HelixHighDialect>();
}

Pipeline::~Pipeline() = default;

Pipeline::Pipeline(Pipeline&&) noexcept = default;
Pipeline& Pipeline::operator=(Pipeline&&) noexcept = default;

// ============================================================================
//  Stage 1: Parse LLVM IR text
// ============================================================================

PipelineResult<std::unique_ptr<llvm::Module>>
Pipeline::parseLLVMIR(llvm::StringRef ir_text) {
    if (ir_text.empty()) {
        return std::unexpected("parseLLVMIR: input IR text is empty");
    }

    // Wrap the text in a MemoryBuffer (no copy; the buffer borrows the
    // StringRef data, which must outlive the parse call).
    auto mem_buf = llvm::MemoryBuffer::getMemBuffer(
        ir_text,
        /*BufferName=*/"<helix-input>",
        /*RequiresNullTerminator=*/false
    );

    llvm::SMDiagnostic diag;
    auto module = llvm::parseIR(
        *mem_buf,
        diag,
        *llvm_ctx_
    );

    if (!module) {
        // Format a detailed error message from the SMDiagnostic.
        std::string msg;
        llvm::raw_string_ostream os(msg);
        diag.print(/*ProgName=*/"helix", os);
        return std::unexpected(
            std::format("parseLLVMIR: failed to parse LLVM IR: {}", msg)
        );
    }

    return module;
}

// ============================================================================
//  Stage 2: LLVM -> MLIR Translation
// ============================================================================

PipelineResult<mlir::OwningOpRef<mlir::ModuleOp>>
Pipeline::translateToMLIR(std::unique_ptr<llvm::Module> llvm_module) {
    if (!llvm_module) {
        return std::unexpected("translateToMLIR: llvm::Module is null");
    }

    // Install a diagnostic capture so we can report MLIR-level errors that
    // occur during translation (e.g., unsupported LLVM IR constructs).
    DiagnosticCapture capture(mlir_ctx_);

    auto mlir_module = mlir::translateLLVMIRToModule(
        std::move(llvm_module),
        mlir_ctx_
    );

    if (!mlir_module) {
        std::string detail = capture.take();
        if (detail.empty())
            detail = "(no diagnostic details available)";
        return std::unexpected(
            std::format("translateToMLIR: LLVM IR to MLIR translation failed: {}",
                        detail)
        );
    }

    // Run the MLIR verifier to catch structural problems early (invalid
    // types, missing terminators, etc.) before they surface as cryptic
    // failures deep inside a pass.
    if (mlir::failed(mlir::verify(*mlir_module))) {
        std::string detail = capture.take();
        return std::unexpected(
            std::format("translateToMLIR: MLIR verification failed after "
                        "translation: {}",
                        detail.empty() ? "(no details)" : detail)
        );
    }

    return mlir_module;
}

// ============================================================================
//  Stage 3: Pass Pipeline Construction & Execution
// ============================================================================

void Pipeline::buildPassPipeline(mlir::PassManager& pm) {
    // ---- Phase 1: Conversion from LLVM Dialect to HelixLow ----
    //
    // This pass recognises Remill-specific patterns in the LLVM dialect
    // (State-struct GEPs, __remill_* intrinsics, mangled semantic calls)
    // and converts them into HelixLow dialect operations.
    pm.addPass(createRemillToHelixLowPass());

    // ---- Phase 2: Analysis & recovery passes (HelixLow) ----
    //
    // These passes operate on the HelixLow dialect, progressively recovering
    // higher-level information from the flat register/memory model.

    // Identify stack frame layout: RSP/RBP+offset accesses -> stack slots.
    pm.addPass(createRecoverStackLayoutPass());

    // Detect calling convention (Win64, SysV, etc.) and fold register
    // arguments into explicit call operands.
    pm.addPass(createRecoverCallingConventionPass());

    // Iterative type propagation until fixed-point (max 16 rounds).
    pm.addPass(createPropagateTypesPass());

    // ---- Phase 3: HelixLow -> HelixHigh structuring ----
    //
    // Convert flat basic-block + branch graph into structured control flow
    // (if/else, while, for). Irreducible regions fall back to goto/label.
    pm.addPass(createStructureControlFlowPass());

    // ---- Phase 4: High-level cleanup passes (HelixHigh) ----

    // Replace remaining register references with named variables.
    pm.addPass(createRecoverVariablesPass());

    // Remove dead operations: NOPs, INT3 markers, push/pop bookkeeping,
    // dead register writes, stack pointer arithmetic.
    pm.addPass(createEliminateDeadCodePass());

    // ---- Phase 5: MLIR built-in optimisation passes ----
    //
    // Apply standard MLIR passes to clean up the module after Helix-specific
    // transformations.  CSE removes redundant sub-expressions; the
    // canonicalizer simplifies operations per dialect-defined rewrite rules.
    pm.addPass(mlir::createCSEPass());
    pm.addPass(mlir::createCanonicalizerPass());
}

void Pipeline::ensurePipelineBuilt() {
    if (pipeline_built_)
        return;

    pass_manager_ = std::make_unique<mlir::PassManager>(mlir_ctx_);

    // Enable IR printing for debug builds.  This is invaluable when a pass
    // produces malformed IR: the dump shows the module state *before* the
    // offending pass.
#ifndef NDEBUG
    pass_manager_->enableIRPrinting(
        /*shouldPrintBeforePass=*/[](mlir::Pass*, mlir::Operation*) { return false; },
        /*shouldPrintAfterPass=*/[](mlir::Pass*, mlir::Operation*) { return false; },
        /*printModuleScope=*/true,
        /*printAfterOnlyOnChange=*/true,
        /*printAfterOnlyOnFailure=*/true
    );
#endif

    // Enable verification after every pass to catch which pass produces
    // invalid IR (e.g., "operation destroyed but still has uses").
    pass_manager_->enableVerifier(/*verifyPasses=*/true);

    buildPassPipeline(*pass_manager_);
    pipeline_built_ = true;
}

PipelineResult<void> Pipeline::runPasses(mlir::ModuleOp module) {
    if (!module) {
        return std::unexpected("runPasses: MLIR module is null");
    }

    ensurePipelineBuilt();

    // Capture diagnostics so that pass failures produce actionable messages.
    DiagnosticCapture capture(mlir_ctx_);

    if (mlir::failed(pass_manager_->run(module))) {
        std::string detail = capture.take();
        if (detail.empty())
            detail = "(no diagnostic details available)";
        return std::unexpected(
            std::format("runPasses: MLIR pass pipeline failed: {}", detail)
        );
    }

    return {};
}

// ============================================================================
//  Stage 4: Emission
// ============================================================================

PipelineResult<std::string> Pipeline::emitPseudoC(mlir::ModuleOp module) {
    if (!module) {
        return std::unexpected("emitPseudoC: MLIR module is null");
    }

    try {
        PseudoCEmitter emitter;
        std::string code = emitter.emit(module);

        if (code.empty()) {
            return std::unexpected(
                "emitPseudoC: emitter produced empty output "
                "(module may contain no decompilable functions)"
            );
        }

        return code;
    } catch (const std::exception& ex) {
        return std::unexpected(
            std::format("emitPseudoC: exception during emission: {}", ex.what())
        );
    }
}

PipelineResult<std::vector<uint8_t>>
Pipeline::emitFlatBuffer(mlir::ModuleOp module) {
    if (!module) {
        return std::unexpected("emitFlatBuffer: MLIR module is null");
    }

    try {
        FlatBufSerializer serializer;
        std::vector<uint8_t> buf = serializer.serialize(module);

        if (buf.empty()) {
            return std::unexpected(
                "emitFlatBuffer: serializer produced empty output"
            );
        }

        // Sanity-check the generated FlatBuffer before returning it.
        if (!FlatBufSerializer::verify(buf.data(), buf.size())) {
            return std::unexpected(
                "emitFlatBuffer: generated FlatBuffer failed verification "
                "(internal serializer bug)"
            );
        }

        return buf;
    } catch (const std::exception& ex) {
        return std::unexpected(
            std::format("emitFlatBuffer: exception during serialization: {}",
                        ex.what())
        );
    }
}

// ============================================================================
//  Full Pipeline Orchestration
// ============================================================================

PipelineResult<DecompileOutput> Pipeline::decompile(llvm::StringRef ir_text) {
    // ---- Step 0: Validate architecture ----
    auto name = archName(arch_);
    if (!name.has_value()) {
        return std::unexpected(
            std::format("decompile: unsupported architecture (enum value {})",
                        static_cast<int>(arch_))
        );
    }

    // ---- Step 1: Parse LLVM IR text ----
    auto llvm_module = parseLLVMIR(ir_text);
    if (!llvm_module.has_value()) {
        return std::unexpected(
            std::format("decompile: stage 1 (parse) failed: {}",
                        llvm_module.error())
        );
    }

    // ---- Step 2: Translate LLVM IR -> MLIR ----
    auto mlir_module = translateToMLIR(std::move(*llvm_module));
    if (!mlir_module.has_value()) {
        return std::unexpected(
            std::format("decompile: stage 2 (translate) failed: {}",
                        mlir_module.error())
        );
    }

    // ---- Step 3: Run pass pipeline ----
    //
    // The pass pipeline transforms the MLIR module in-place, progressing
    // from the LLVM dialect through HelixLow to HelixHigh.
    mlir::ModuleOp mod_op = mlir_module->get();

    auto pass_result = runPasses(mod_op);
    if (!pass_result.has_value()) {
        return std::unexpected(
            std::format("decompile: stage 3 (passes) failed: {}",
                        pass_result.error())
        );
    }

    // ---- Step 4a: Emit pseudo-C ----
    auto pseudo_c = emitPseudoC(mod_op);
    if (!pseudo_c.has_value()) {
        return std::unexpected(
            std::format("decompile: stage 4a (pseudo-C emission) failed: {}",
                        pseudo_c.error())
        );
    }

    // ---- Step 4b: Emit FlatBuffer ----
    auto flatbuf = emitFlatBuffer(mod_op);
    if (!flatbuf.has_value()) {
        return std::unexpected(
            std::format("decompile: stage 4b (FlatBuffer emission) failed: {}",
                        flatbuf.error())
        );
    }

    return DecompileOutput{
        .pseudo_c   = std::move(*pseudo_c),
        .flatbuffer = std::move(*flatbuf),
    };
}

} // namespace helix
