#pragma once
/// @file PseudoCEmitter.h
/// @brief Emit pseudo-C source code from a HelixHigh MLIR module.

#ifndef HELIX_EMIT_PSEUDOC_EMITTER_H
#define HELIX_EMIT_PSEUDOC_EMITTER_H

#include "mlir/IR/BuiltinOps.h"
#include "llvm/Support/raw_ostream.h"
#include <cstdint>
#include <optional>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace helix {

namespace high {
class FuncOp;
class ModuleOp;
} // namespace high

namespace low {
class CallOp;
} // namespace low

/// Emits human-readable pseudo-C code from a HelixHigh MLIR module.
///
/// The emitter walks the MLIR module and renders each HelixHigh operation
/// to C-like source code. Format conventions match the existing Rust
/// HIR emitter (hir_emitter.rs) for consistency:
///   - Integer types: int32_t, uint64_t, etc.
///   - Hex literals for values >= 16 or <= -16
///   - Parenthesized binary expressions
///   - Indented block structure with braces
class PseudoCEmitter {
public:
    /// Emit an entire MLIR module as pseudo-C source code.
    ///
    /// @param module  The HelixHigh MLIR module to emit.
    /// @return        The pseudo-C source code string.
    std::string emit(mlir::ModuleOp module);

    /// Emit to an output stream.
    void emit(mlir::ModuleOp module, llvm::raw_ostream& os);

    /// Infer a Win64 stack-parameter index from an address expression string.
    /// Examples: "(rsp + 0x28)" -> 5, "(rsp + 0x30)" -> 6.
    static std::optional<unsigned>
    inferWin64StackParamIndexFromAddressString(
        std::string_view expr,
        int64_t rbpStackParamBaseOffset = 0x28);

    /// Heuristic: true when an identifier likely names a struct/object base.
    static bool looksLikeStructBaseIdentifier(std::string_view name);

    /// True for Win64 non-volatile general-purpose registers.
    static bool isCalleeSavedRegisterName(std::string_view name);

private:
    /// Emit a file header comment.
    void emitHeader(llvm::raw_ostream& os, mlir::ModuleOp module);

    struct FunctionStats {
        double score = 100.0;
        int instructionCount = 0;
        int badPatterns = 0;
        std::vector<std::string> issues;
    };

    /// Analyze a function to compute confidence score and identify issues.
    FunctionStats analyzeFunction(mlir::Operation* funcOp);

    /// Emit a single decompiled function.
    void emitFunction(mlir::Operation* funcOp, llvm::raw_ostream& os);

    /// Emit a statement (dispatches by op type).
    void emitStatement(mlir::Operation* op, llvm::raw_ostream& os, unsigned depth);

    /// Emit a block of statements within a region.
    void emitRegionBody(mlir::Region& region, llvm::raw_ostream& os, unsigned depth);

    /// Format an expression value as a C expression string.
public:
    std::string formatExpression(mlir::Value val);
private:

    /// Apply current per-function identifier aliases (e.g. param_1 -> this).
    std::string applyNameAliases(std::string name) const;

    /// Best-effort resolution for broken PC-relative call expressions that
    /// survived lowering as arithmetic over synthetic temporaries.
    std::optional<uint64_t> tryResolveSyntheticRelativeCallTarget(
        helix::low::CallOp call);

    /// Resolve generic PC-relative arithmetic over a previously learnt
    /// synthetic base temporary (v0, v1, ...).
    std::optional<uint64_t> tryResolveSyntheticRelativeAddress(
        mlir::Value value);

    /// Format a C type name (e.g., "int32_t", "void*", "bool").
    std::string formatType(mlir::Type type);

    /// Format an integer literal (hex for >= 16).
    std::string formatIntLiteral(int64_t value);

    /// Emit indentation.
    void indent(llvm::raw_ostream& os, unsigned depth);

    /// Check if a statement is a prologue/epilogue artifact that should be hidden.
    bool isPrologueArtifact(mlir::Operation* op);

    /// Infer a Win64 stack-parameter index from an MLIR address value.
    std::optional<unsigned> inferWin64StackParamIndex(mlir::Operation* contextOp,
                                                      mlir::Value addr);

    /// True if an earlier operation in the same block mutates the current RSP.
    bool hasStackPointerWriteBefore(mlir::Operation* op);

    /// True if an operation is near the start or end of its block.
    bool isNearBlockBoundary(mlir::Operation* op, unsigned budget = 8);

    /// True if an operation is within the first few instructions of its block.
    bool isNearBlockStart(mlir::Operation* op, unsigned budget = 12);

    /// Pre-scan a block to find dead store assignments (overwritten before read).
    std::unordered_set<mlir::Operation*> precomputeDeadStores(mlir::Block& block);

    /// Tracks the last written expression for each register to eliminate redundant identical assignments.
    std::unordered_map<std::string, std::string> lastRegValue;

    /// Set of operations identified as dead stores by the pre-scan.
    std::unordered_set<mlir::Operation*> deadStoreOps;

    /// Global block counter for unique labels across the function.
    unsigned globalBlockCounter_ = 0;

    /// Map of Block* to its assigned unique label string.
    std::unordered_map<mlir::Block*, std::string> blockLabels_;

    /// Blocks that are the target of some explicit control transfer.
    std::unordered_set<mlir::Block*> referencedBlocks_;

    /// Label names referenced by explicit `helix_high.goto`.
    std::unordered_set<std::string> referencedLabelNames_;

    /// Active calling convention for the function currently being emitted.
    bool currentFunctionIsWin64_ = true;

    /// Win64 frame-based stack parameter base for `rbp + off` -> `param_N`.
    int64_t currentWin64RbpStackParamBaseOffset_ = 0x28;

    /// Highest contiguous inferred Win64 stack parameter index kept for output.
    unsigned currentWin64StackParamLimit_ = 4;

    /// Whether the current function is emitted as non-void.
    bool currentFunctionHasReturnValue_ = false;

    /// Symbol name of the function currently being emitted.
    std::string currentFunctionName_;

    /// Entry address of the function currently being emitted.
    uint64_t currentFunctionEntryAddr_ = 0;

    /// Best-effort return variable name for low-level `ret` emission.
    std::string currentReturnValueName_;

    /// Per-function identifier aliases (e.g. param_1 -> this).
    std::unordered_map<std::string, std::string> nameAliases_;

    /// Learnt base addresses for synthetic call-target temporaries (v0, v1, ...).
    std::unordered_map<std::string, int64_t> syntheticCallBaseAddrs_;

#ifndef NDEBUG
    /// Validate that the emitted output does not contain forbidden patterns
    /// such as __undef, __carry, __overflow, raw register names outside
    /// comments, or mangled Remill names. Debug-only; no-op in release.
    void validateOutput(const std::string& output);
#endif
};

} // namespace helix

#endif // HELIX_EMIT_PSEUDOC_EMITTER_H
