#pragma once
/// @file CAstBuilder.h
/// @brief Converts HelixHigh MLIR to the C AST (Phase 4b).
///
/// Walks HelixHigh MLIR operations and produces a tree of C AST nodes
/// (CFuncDecl with populated body, params, localVars). This replaces the
/// text-based PseudoCEmitter with a structured AST representation that
/// can be optimized and pretty-printed independently.

#ifndef HELIX_CAST_AST_BUILDER_H
#define HELIX_CAST_AST_BUILDER_H

#include "helix/cast/CAstNode.h"
#include "helix/cast/CType.h"
#include "helix/cast/CExpr.h"
#include "helix/cast/CStmt.h"
#include "helix/cast/CDecl.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/Value.h"
#include "mlir/IR/Region.h"

#include <cstdint>
#include <map>
#include <memory>
#include <optional>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

// Forward declarations for HelixHigh ops
namespace helix::high {
class FuncOp;
class ModuleOp;
} // namespace helix::high

namespace helix::cast {

/// Builds C AST trees from HelixHigh MLIR operations.
///
/// The builder walks a HelixHigh MLIR module/function and constructs a tree
/// of C AST nodes. It ports the structural logic from PseudoCEmitter but
/// produces AST nodes instead of text output.
///
/// Usage:
///   CAstBuilder builder;
///   auto funcs = builder.buildModule(moduleOp);
///   // or:
///   auto func = builder.buildFunction(funcOp);
class CAstBuilder {
public:
    /// Build a CFuncDecl from a HelixHigh FuncOp.
    std::unique_ptr<CFuncDecl> buildFunction(mlir::Operation* funcOp);

    /// Build all functions from a HelixHigh module.
    std::vector<std::unique_ptr<CFuncDecl>> buildModule(mlir::ModuleOp moduleOp);

    /// Analyze function quality and compute confidence score + issues.
    void analyzeConfidence(CFuncDecl& func, mlir::Operation* op);

private:
    // ── Pre-scans (ported from PseudoCEmitter) ──────────────────────────

    /// Count how many times each variable is referenced in the function.
    void precomputeVarUseCounts(mlir::Operation* funcOp);

    /// Identify dead store assignments (overwritten before read) in a block.
    std::unordered_set<mlir::Operation*> precomputeDeadStores(mlir::Block& block);

    /// Pre-scan struct field accesses to recover meaningful field names.
    void prescanStructFieldNames(mlir::Operation* funcOp);

    // ── Statement builders ──────────────────────────────────────────────

    /// Build a single statement AST node from an MLIR operation.
    StmtPtr buildStatement(mlir::Operation* op);

    /// Build a list of statements from all blocks in a region.
    std::vector<StmtPtr> buildRegionBody(mlir::Region& region);

    // ── Expression builders ─────────────────────────────────────────────

    /// Build an expression AST node from an MLIR Value.
    ExprPtr buildExpression(mlir::Value val);

    // ── Filtering ───────────────────────────────────────────────────────

    /// Return true if this operation should be skipped during AST building.
    bool shouldSkip(mlir::Operation* op);

    /// Return true if this operation is a prologue/epilogue artifact.
    bool isPrologueArtifact(mlir::Operation* op);

    // ── Type conversion ─────────────────────────────────────────────────

    /// Convert an MLIR type to a CType.
    CTypePtr convertType(mlir::Type type);

    // ── Copy propagation & naming ───────────────────────────────────────

    /// Follow transitive copy chains: if a->b->c, resolving a yields c.
    std::string resolveTransitive(const std::string& name) const;

    /// Apply per-function identifier aliases (e.g. param_1 -> this).
    std::string applyNameAliases(std::string name) const;

    // ── Compound assignment detection ───────────────────────────────────

    /// Detect compound assignment pattern in an AssignOp.
    /// Returns the compound operator string (e.g., "+=") or empty if none.
    std::string detectCompoundOp(mlir::Operation* assignOp,
                                 const std::string& targetName);

    // ── Address extraction ──────────────────────────────────────────────

    /// Extract the address attribute from an MLIR operation, if present.
    uint64_t extractAddress(mlir::Operation* op) const;

    // ── Function-level state (cleared per buildFunction) ────────────────

    void clearFunctionState();

    /// Last written expression for each variable (copy propagation).
    std::unordered_map<std::string, std::string> lastRegValue_;

    /// Per-variable use count for single-use temporary elimination.
    std::unordered_map<std::string, unsigned> varUseCount_;

    /// Set of operations identified as dead stores.
    std::unordered_set<mlir::Operation*> deadStoreOps_;

    /// Per-function identifier aliases (e.g. param_1 -> this).
    std::unordered_map<std::string, std::string> nameAliases_;

    /// Stack offset -> variable name map.
    std::unordered_map<int64_t, std::string> stackOffsetToVarName_;

    /// Global address -> variable name map.
    std::map<uint64_t, std::string> globalAddrToVarName_;

    /// Reverse map: expression string -> best variable name.
    std::unordered_map<std::string, std::string> exprToBestName_;

    /// Learnt base addresses for synthetic call-target temporaries.
    std::unordered_map<std::string, int64_t> syntheticCallBaseAddrs_;

    // ── Struct field recovery ───────────────────────────────────────────

    struct StructFieldInfo {
        std::string name;
        std::string typeName;
    };

    /// Map: (base_expression, field_offset) -> recovered field info.
    std::unordered_map<std::string,
        std::unordered_map<uint64_t, StructFieldInfo>> recoveredStructFields_;

    /// Look up a recovered field name for the given base expression and offset.
    std::string getRecoveredFieldName(const std::string& baseExpr,
                                      uint64_t offset) const;

    /// Check whether a field name is a generic auto-generated name.
    static bool isGenericFieldName(std::string_view name);

    // ── Function context ────────────────────────────────────────────────

    bool currentFunctionIsWin64_ = true;
    int64_t currentWin64RbpStackParamBaseOffset_ = 0x28;
    unsigned currentWin64StackParamLimit_ = 4;
    bool currentFunctionHasReturnValue_ = false;
    std::string currentFunctionName_;
    uint64_t currentFunctionEntryAddr_ = 0;
    std::string currentReturnValueName_;

    /// Global block counter for unique labels across the function.
    unsigned globalBlockCounter_ = 0;

    /// Map of Block* to its assigned unique label string.
    std::unordered_map<mlir::Block*, std::string> blockLabels_;

    /// Blocks that are the target of some explicit control transfer.
    std::unordered_set<mlir::Block*> referencedBlocks_;

    /// Label names referenced by explicit `helix_high.goto`.
    std::unordered_set<std::string> referencedLabelNames_;

    /// Labels that are only followed by other labels and a final `return`.
    std::unordered_set<std::string> returnOnlyLabels_;
};

} // namespace helix::cast

#endif // HELIX_CAST_AST_BUILDER_H
