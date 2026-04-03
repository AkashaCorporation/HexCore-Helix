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

    /// Format an expression with operator-precedence context so that
    /// parentheses are only emitted when the sub-expression's own precedence
    /// is lower than the surrounding context.
    std::string formatExpressionWithPrec(mlir::Value val, int parentPrec);

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

    /// Return true when a cast from srcType to dstType is visually redundant
    /// in the given usage context and can be elided without changing semantics.
    /// The cast value's defining operation and its parent operation are inspected
    /// to decide whether the cast is necessary.
    bool isCastRedundant(mlir::Type srcType, mlir::Type dstType,
                         mlir::Value castResult) const;

    /// Return the integer bit width of a type, or 0 if not an integer type.
    static unsigned getIntBitWidth(mlir::Type type);

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

    /// Resolve transitive copy chains: if a->b->c, resolving a yields c.
    /// Includes cycle detection (max 5 hops) to prevent infinite loops.
    std::string resolveTransitive(const std::string& name) const;

    /// Per-variable use count for the current function, populated by pre-scan.
    /// Used for single-use temporary elimination (inline the expression).
    std::unordered_map<std::string, unsigned> varUseCount_;

    /// Reverse map: expression string -> shortest/most meaningful variable name.
    /// When multiple variables hold the same expression, prefer the better name.
    std::unordered_map<std::string, std::string> exprToBestName_;

    /// Pre-scan a function to count how many times each variable is referenced.
    void precomputeVarUseCounts(mlir::Operation* funcOp);

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

    /// Labels that are only followed by other labels and a final `return`.
    /// Maps label name → true if the goto can be replaced with `return`.
    std::unordered_set<std::string> returnOnlyLabels_;

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

    /// Stack offset → variable name map for resolving `rbp ± offset` in low-level ops.
    /// Populated from VarDeclOps with StorageKind::Stack.
    std::unordered_map<int64_t, std::string> stackOffsetToVarName_;

    /// Global address → variable name map for naming `*0xADDR` accesses.
    std::map<uint64_t, std::string> globalAddrToVarName_;

    /// Learnt base addresses for synthetic call-target temporaries (v0, v1, ...).
    std::unordered_map<std::string, int64_t> syntheticCallBaseAddrs_;

    // ─── Struct Field Name Recovery ─────────────────────────────────────
    // Recovered field names for struct accesses.  Populated by a pre-scan
    // that walks FieldAccessOp / FieldPtrOp / MemReadOp / MemWriteOp and
    // infers meaningful names from usage context (vtable slots, comparison
    // operands, stored constants, function pointers, etc.).
    //
    // Conservative: only renames when confidence is high; keeps the
    // generic `field_0xNN` / `field_NN` as fallback.

    /// Information about a recovered struct field name.
    struct StructFieldInfo {
        std::string name;       ///< Recovered meaningful name
        std::string typeName;   ///< Optional inferred type hint (may be empty)
    };

    /// Map: (base_expression, field_offset) → recovered field info.
    /// base_expression is the formatted (alias-resolved) expression for the
    /// struct pointer (e.g. "this", "param_1", "local_var").
    std::unordered_map<std::string,
        std::unordered_map<uint64_t, StructFieldInfo>> recoveredStructFields_;

    /// Pre-scan a function to collect struct field access patterns and infer
    /// meaningful field names from usage context.
    void prescanStructFieldNames(mlir::Operation* funcOp);

    /// Look up a recovered field name for the given base expression and offset.
    /// Returns the recovered name, or empty string if no recovery was made.
    std::string getRecoveredFieldName(const std::string& baseExpr,
                                      uint64_t offset) const;

    /// Check whether a field name looks like a generic auto-generated name
    /// (field_XX, field_0xNN) that is safe to replace.  Returns false for
    /// names that appear user-annotated or already meaningful.
    static bool isGenericFieldName(std::string_view name);

#ifndef NDEBUG
    /// Validate that the emitted output does not contain forbidden patterns
    /// such as __undef, __carry, __overflow, raw register names outside
    /// comments, or mangled Remill names. Debug-only; no-op in release.
    void validateOutput(const std::string& output);
#endif
};

} // namespace helix

#endif // HELIX_EMIT_PSEUDOC_EMITTER_H
