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
#include "helix/cast/CAstBuilder.h"
#include "helix/cast/CAstOptimizer.h"
#include "helix/cast/CAstPrinter.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixMidDialect.h"
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
#include "mlir/Pass/PassInstrumentation.h"

// Helix dialect ops for P0 debug counting
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixMidOps.h"
#include "helix/dialects/HelixHighOps.h"

// LLVM includes
#include "llvm/AsmParser/LLParser.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"

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

Pipeline::Pipeline(mlir::MLIRContext* mlir_ctx, HelixArch arch,
                   bool skip_optimization)
    : mlir_ctx_(mlir_ctx)
    , arch_(arch)
    , llvm_ctx_(std::make_unique<llvm::LLVMContext>())
    , skip_optimization_(skip_optimization)
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
    mlir_ctx_->getOrLoadDialect<helix::mid::HelixMidDialect>();   // v1.0
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

    // We use LLParser directly with UpgradeDebugInfo=false rather than the
    // llvm::parseIR() convenience wrapper.
    //
    // Root cause: parseIR() -> parseAssembly() -> LLParser::Run(UpgradeDebugInfo=true)
    // -> llvm::UpgradeDebugInfo() -> llvm::verifyModule() with FatalErrors=true.
    // For Remill-lifted IR that contains backward branches to the first block
    // (a common pattern for loops at function entry), the verifier fires
    // "Entry block to function must not have predecessors!" and calls abort().
    // Our entry-block fix (below) runs AFTER parsing, so it cannot help here.
    // Passing UpgradeDebugInfo=false skips that internal verification pass;
    // we sanitise the entry blocks ourselves immediately after parsing.
    auto module = std::make_unique<llvm::Module>("<helix-input>", *llvm_ctx_);

    llvm::SourceMgr src_mgr;
    auto mem_buf = llvm::MemoryBuffer::getMemBuffer(
        ir_text, "<helix-input>", /*RequiresNullTerminator=*/false);
    src_mgr.AddNewSourceBuffer(std::move(mem_buf), llvm::SMLoc());

    llvm::SMDiagnostic diag;
    llvm::LLParser parser(
        ir_text, src_mgr, diag, module.get(),
        /*Index=*/nullptr, *llvm_ctx_);

    if (parser.Run(/*UpgradeDebugInfo=*/false)) {
        // Format a detailed error message from the SMDiagnostic.
        std::string msg;
        llvm::raw_string_ostream os(msg);
        diag.print(/*ProgName=*/"helix", os);
        return std::unexpected(
            std::format("parseLLVMIR: failed to parse LLVM IR: {}", msg)
        );
    }

    // Sanitize: LLVM requires that entry blocks have no predecessors.
    // Remill can produce functions where a backward branch (e.g. a loop)
    // targets the very first block, which violates this invariant and causes
    // LLVM to call abort() with "Broken module found".  Fix by inserting a
    // new empty entry block that unconditionally branches to the original one.
    for (auto& func : *module) {
        if (func.isDeclaration() || func.empty())
            continue;
        auto& entry = func.getEntryBlock();
        if (!entry.hasNPredecessors(0)) {
            auto* newEntry = llvm::BasicBlock::Create(
                func.getContext(), "", &func, &entry);
            llvm::BranchInst::Create(&entry, newEntry);
        }
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

    // Capture the target triple before the LLVM module is moved.
    std::string targetTriple = llvm_module->getTargetTriple();

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

    // Preserve the target triple as an attribute on the MLIR ModuleOp.
    // The MLIR LLVM IR importer does NOT carry this over automatically,
    // and downstream passes (RecoverCallingConvention, collectCallArgs)
    // need it to choose the correct ABI (Win64 vs SysV).
    if (!targetTriple.empty()) {
        (*mlir_module)->setAttr(
            "llvm.target_triple",
            mlir::StringAttr::get(mlir_ctx_, targetTriple));
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

void Pipeline::enablePass(std::string_view name) {
    selective_mode_ = true;
    if (name == "HelixLowSimplify")   enable_helix_low_simplify_ = true;
    else if (name == "SwitchRecovery")     enable_switch_recovery_ = true;
    else if (name == "HelixMidSimplify")   enable_helix_mid_simplify_ = true;
    else if (name == "ConstantFolding")    enable_constant_folding_ = true;
    else if (name == "EscapeAnalysis")     enable_escape_analysis_ = true;
    else if (name == "StructRecovery")     enable_struct_recovery_ = true;
}

// ═══════════════════════════════════════════════════════════════════════════════
// [P0-DEBUG] Pass instrumentation that counts CallOps before/after every pass
// ═══════════════════════════════════════════════════════════════════════════════
struct CallOpCountInstrumentation : public mlir::PassInstrumentation {
    void runBeforePass(mlir::Pass* pass, mlir::Operation* op) override {
        auto module = mlir::dyn_cast<mlir::ModuleOp>(op);
        if (!module) return;
        unsigned lowCalls = 0, midCalls = 0, highCalls = 0;
        unsigned binOps = 0, regWrites = 0, regReads = 0, memReads = 0;
        unsigned midBinExpr = 0, midAssign = 0, highAssign = 0, totalOps = 0;
        module.walk([&](mlir::Operation* inner) {
            ++totalOps;
            if (mlir::isa<helix::low::CallOp>(inner)) ++lowCalls;
            else if (mlir::isa<helix::mid::CallOp>(inner)) ++midCalls;
            else if (mlir::isa<helix::high::CallOp>(inner)) ++highCalls;
            else if (mlir::isa<helix::low::BinOp>(inner)) ++binOps;
            else if (mlir::isa<helix::low::RegWriteOp>(inner)) ++regWrites;
            else if (mlir::isa<helix::low::RegReadOp>(inner)) ++regReads;
            else if (mlir::isa<helix::low::MemReadOp>(inner)) ++memReads;
            if (mlir::isa<helix::mid::BinExprOp>(inner)) ++midBinExpr;
            if (mlir::isa<helix::mid::AssignOp>(inner)) ++midAssign;
            if (mlir::isa<helix::high::AssignOp>(inner)) ++highAssign;
        });
        llvm::errs() << "[P0-TRACE] BEFORE " << pass->getName()
                     << ": low.call=" << lowCalls
                     << " mid.call=" << midCalls
                     << " high.call=" << highCalls
                     << " binop=" << binOps
                     << " rw=" << regWrites
                     << " rr=" << regReads
                     << " mr=" << memReads
                     << " m.bin=" << midBinExpr
                     << " m.asgn=" << midAssign
                     << " h.asgn=" << highAssign
                     << " total=" << totalOps << "\n";
    }

    void runAfterPass(mlir::Pass* pass, mlir::Operation* op) override {
        auto module = mlir::dyn_cast<mlir::ModuleOp>(op);
        if (!module) return;
        unsigned lowCalls = 0, midCalls = 0, highCalls = 0;
        unsigned binOps = 0, regWrites = 0, regReads = 0, memReads = 0;
        unsigned midBinExpr = 0, midAssign = 0, highAssign = 0, totalOps = 0;
        module.walk([&](mlir::Operation* inner) {
            ++totalOps;
            if (mlir::isa<helix::low::CallOp>(inner)) ++lowCalls;
            else if (mlir::isa<helix::mid::CallOp>(inner)) ++midCalls;
            else if (mlir::isa<helix::high::CallOp>(inner)) ++highCalls;
            else if (mlir::isa<helix::low::BinOp>(inner)) ++binOps;
            else if (mlir::isa<helix::low::RegWriteOp>(inner)) ++regWrites;
            else if (mlir::isa<helix::low::RegReadOp>(inner)) ++regReads;
            else if (mlir::isa<helix::low::MemReadOp>(inner)) ++memReads;
            if (mlir::isa<helix::mid::BinExprOp>(inner)) ++midBinExpr;
            if (mlir::isa<helix::mid::AssignOp>(inner)) ++midAssign;
            if (mlir::isa<helix::high::AssignOp>(inner)) ++highAssign;
        });
        llvm::errs() << "[P0-TRACE] AFTER  " << pass->getName()
                     << ": low.call=" << lowCalls
                     << " mid.call=" << midCalls
                     << " high.call=" << highCalls
                     << " binop=" << binOps
                     << " rw=" << regWrites
                     << " rr=" << regReads
                     << " mr=" << memReads
                     << " m.bin=" << midBinExpr
                     << " m.asgn=" << midAssign
                     << " h.asgn=" << highAssign
                     << " total=" << totalOps << "\n";
    }

    void runAfterPassFailed(mlir::Pass* pass, mlir::Operation* op) override {
        auto module = mlir::dyn_cast<mlir::ModuleOp>(op);
        if (!module) return;
        unsigned lowCalls = 0, midCalls = 0, highCalls = 0;
        module.walk([&](mlir::Operation* inner) {
            if (mlir::isa<helix::low::CallOp>(inner)) ++lowCalls;
            else if (mlir::isa<helix::mid::CallOp>(inner)) ++midCalls;
            else if (mlir::isa<helix::high::CallOp>(inner)) ++highCalls;
        });
        llvm::errs() << "[P0-TRACE] FAILED " << pass->getName()
                     << ": low.call=" << lowCalls
                     << " mid.call=" << midCalls
                     << " high.call=" << highCalls << "\n";
    }
};

void Pipeline::buildPassPipeline(mlir::PassManager& pm) {
    // ═══════════════════════════════════════════════════════════════════════
    // v1.0 Three-Tier Pipeline: Low → Mid → High (→ EmitC optional)
    // ═══════════════════════════════════════════════════════════════════════

    // ── Tier 1: LLVM Dialect → HelixLow ─────────────────────────────────
    //    Remill pattern recognition: converts LLVM IR patterns to
    //    machine-level HelixLow operations (registers, flags, raw memory).
    pm.addPass(createRemillToHelixLowPass(preserve_cfg_));

    // ── Tier 1 Analysis: HelixLow-level passes ──────────────────────────
    //    These passes operate on machine-level IR to recover high-level
    //    information while register/flag semantics are still explicit.
    pm.addPass(createRecoverStackLayoutPass());
    pm.addPass(createRecoverCallingConventionPass());   // [Nightly: uses CC Database]

    // ── Tier 1.5: HelixLow Simplification (Nightly P0.1) ────────────────
    //    Greedy pattern-based simplification: arithmetic identities,
    //    dead flag elimination, store-to-load forwarding, redundant casts.
    //    MLIR analog of Ghidra's Rule/ActionPool architecture.
    // Helper: should a nightly pass run?
    //   - skip_optimization_ = true → skip ALL nightly passes
    //   - selective_mode_ = true → only run passes explicitly enabled
    //   - otherwise → run all nightly passes
    auto shouldRun = [&](bool flag) -> bool {
        if (skip_optimization_) return false;
        if (selective_mode_) return flag;
        return true; // default: all run
    };

    if (shouldRun(enable_helix_low_simplify_)) {
        pm.addPass(createHelixLowSimplifyPass());
    }

    // ── Tier 1 Analysis (continued) ──────────────────────────────────────
    pm.addPass(createPropagateTypesPass());             // [Nightly: TypeLattice + backward prop]
    pm.addPass(createInterProceduralTypePropagationPass());

    // NOTE: Canonicalizer removed — segfaults on multi-block HelixLow
    // functions with LLVM dialect br/condBr terminators crossing regions.
    // NOTE: CSEPass also removed — same crash on complex functions with
    // many basic blocks. Both are unsafe on HelixLow multi-block IR.

    // ── Tier 1.6: Switch/Jump Table Recovery (Nightly P0.2) ──────────────
    if (shouldRun(enable_switch_recovery_)) {
        pm.addPass(createRecoverSwitchTablesPass());
    }

    // ── Tier 1.7: Control Flow Structuring ───────────────────────────────
    //    [Nightly: enhanced with else detection (P0.3), break/continue
    //    recovery (P0.4), and switch op consumption from P0.2]
    pm.addPass(createStructureControlFlowPass());

    pm.addPass(createRecoverVariablesPass());
    pm.addPass(createEliminateDeadCodePass());          // [Nightly: +liveness-driven DCE]

    // ── FIX-087 (2026-05-20): per-function SSA renaming of register reads/
    //    writes.  Stamps `ssa_version` discardable attrs that the next pass
    //    (HelixLowToMid) packs into the slot_id key, so distinct logical
    //    defs of the same register no longer collide on the same `v0`.
    pm.addPass(createRegisterSSARenamePass());

    // ── Tier 2: HelixLow → HelixMid (v1.0) ──────────────────────────────
    //    Converts remaining machine-level ops to ISA-agnostic typed SSA:
    //    registers → abstract variables, flags → comparisons,
    //    raw memory → typed loads/stores, CMOV → select.
    pm.addPass(createHelixLowToMidPass());

    // ── Tier 2.5: HelixMid Analysis & Optimization ──────────────────────
    if (shouldRun(enable_helix_mid_simplify_)) {
        pm.addPass(createHelixMidSimplifyPass());
    }
    if (shouldRun(enable_constant_folding_)) {
        pm.addPass(createConstantFoldingPass());
    }
    if (shouldRun(enable_escape_analysis_)) {
        pm.addPass(createEscapeAnalysisPass());
    }
    if (shouldRun(enable_struct_recovery_)) {
        pm.addPass(createRecoverStructTypesPass());
    }
    // v0.7.1 optimization passes (always run unless skip_optimization_)
    if (!skip_optimization_) {
        pm.addPass(createRecoverMagicDivisionPass());
        pm.addPass(createDevirtualizeIndirectCallsPass());
    }

    // ── Tier 3: HelixMid → HelixHigh (v1.0) ───────────────────────────
    //    Applies variable naming, finalizes type annotations, converts
    //    abstract slots to named C variables.
    pm.addPass(createHelixMidToHighPass());

}

void Pipeline::ensurePipelineBuilt() {
    if (pipeline_built_)
        return;

    pass_manager_ = std::make_unique<mlir::PassManager>(mlir_ctx_);

    // Disable inter-pass verification to allow the pipeline to complete
    // even when intermediate IR has minor issues (e.g., unreachable blocks
    // without terminators).  The final output is validated by the emitter.
    pass_manager_->enableVerifier(/*verifyPasses=*/false);

    // Disable multithreading for deterministic pass execution.
    mlir_ctx_->disableMultithreading();

    // [P0-DEBUG] Register CallOp counting instrumentation
    pass_manager_->addInstrumentation(
        std::make_unique<CallOpCountInstrumentation>());

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

    // ── Pre-pipeline IR dump: LLVM dialect before any passes ─────────────
    {
        std::error_code ec;
        llvm::raw_fd_ostream pre_os("helix_dump_0_before_passes.mlir", ec);
        if (!ec) {
            pre_os << "// === HELIX PIPELINE DUMP: Before any passes ===\n";
            module->print(pre_os);
        }
    }

    if (mlir::failed(pass_manager_->run(module))) {
        std::string detail = capture.take();
        if (detail.empty())
            detail = "(no diagnostic details available)";
        return std::unexpected(
            std::format("runPasses: MLIR pass pipeline failed: {}", detail)
        );
    }
    // ── Post-pipeline IR dump: HelixHigh after all passes ────────────────
    {
        std::error_code ec;
        llvm::raw_fd_ostream post_os("helix_dump_1_after_passes.mlir", ec);
        if (!ec) {
            post_os << "// === HELIX PIPELINE DUMP: After all passes ===\n";
            module->print(post_os);
        }
    }
    // Legacy dump
    {
        std::error_code ec;
        llvm::raw_fd_ostream debug_os("mlir_debug_dump.txt", ec);
        if (!ec) {
            module->print(debug_os);
        }
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
        std::string code;

        if (use_cast_layer_) {
            // NEW PATH: C AST layer (Phase 4d)
            // CAstBuilder → CAstOptimizer → CAstPrinter
            cast::CAstBuilder builder;
            auto funcs = builder.buildModule(module);

            cast::CAstOptimizer optimizer;
            cast::CAstPrinter printer;

            for (auto& func : funcs) {
                optimizer.optimize(*func);
                // Apply user-defined variable renames (P3: hydrateHAST).
                if (!variable_renames_.empty()) {
                    optimizer.applyVariableRenames(*func, variable_renames_);
                }
                code += printer.print(*func);
                code += "\n";
            }
        } else {
            // EXISTING PATH: PseudoCEmitter (default)
            PseudoCEmitter emitter;
            code = emitter.emit(module);
        }

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
        std::vector<uint8_t> buf;

        if (use_cast_layer_) {
            // C AST path: build the C AST tree and serialize it directly.
            // This produces a complete HAST with all node types.
            cast::CAstBuilder builder;
            auto funcs = builder.buildModule(module);

            cast::CAstOptimizer optimizer;
            for (auto& func : funcs) {
                optimizer.optimize(*func);
                // Apply user-defined variable renames (P3: hydrateHAST).
                if (!variable_renames_.empty()) {
                    optimizer.applyVariableRenames(*func, variable_renames_);
                }
            }

            buf = serializer.serialize(funcs);
        } else {
            // MLIR path: stub serializer (walks HelixHigh ops)
            buf = serializer.serialize(module);
        }

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
