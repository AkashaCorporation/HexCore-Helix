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

    // ── Address registry (FIX-089 — the shared P0 honesty primitive) ────
    //
    // ONE authoritative function/block-address registry, reachable from the
    // whole C-AST layer.  It answers two questions that the P0 honesty quad
    // (D1/D2 this increment; D3/D4/#30 next) all need:
    //
    //   • isKnownFunctionStart(addr) — is `addr` a real lifted function entry?
    //   • isKnownBlockStart(addr)    — is `addr` a basic-block leader of the
    //                                  function currently being built?
    //
    // The function half is module-scoped (populated once per module); the
    // block half is function-scoped (rebuilt per `buildFunction`, sharing the
    // exact same walk that fills `blockLabels_`).  Ghidra's analogue is
    // `Database::queryFunction` (printc.cc pushPtrCodeConstant) for the
    // function half and the address-space label map for the block half.
    //
    // FUTURE HOOKS (next increment):
    //   • D3 (unreachable removal) queries isKnownBlockStart to decide which
    //     orphan labels are real CFG leaders vs. structuring debris.
    //   • D4 (confidence score-gate) reads `hasDamningHonestyDefect_` (set
    //     when D1/D2 emit a located honest marker) to cap the score at 50%.
    //   • #30 (on-demand lift) queries isKnownFunctionStart on an omitted-but-
    //     valid address to decide between a real lift attempt and an honest
    //     failure object.

    /// True iff `addr` is a registered function entry (real lifted function).
    bool isKnownFunctionStart(uint64_t addr) const;

    /// True iff `addr` is a basic-block leader of the current function.
    bool isKnownBlockStart(uint64_t addr) const;

    /// Block label string (`loc_xxxx`) for a known block-start address, or
    /// empty if `addr` is not a block start of the current function.
    std::string blockLabelForAddr(uint64_t addr) const;

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

    // ── Address registry population (FIX-089) ───────────────────────────

    /// Populate the module-scoped function-start table.  Sourced from every
    /// FuncOp entry address in the module PLUS the optional module attribute
    /// `helix.function_starts` (an i64 array stamped by the lifter / NAPI
    /// from Pathfinder `analyzeAll`).  Sets `functionTableIsAuthoritative_`.
    void buildFunctionRegistry(mlir::ModuleOp moduleOp);

    /// Populate the function-scoped block-start table from the same per-block
    /// `address` attribute walk that fills `blockLabels_`.
    void buildBlockRegistry(mlir::Operation* funcOp);

    // ── D1 — code-typed constant resolution (FIX-089) ───────────────────

    /// Build a C expression for an integer constant, resolving code-typed
    /// values through the address registry (Ghidra `pushPtrCodeConstant`):
    ///   • value == known block start    → `&loc_xxxx`  (address-of label)
    ///   • value == known function start → the function symbol
    ///   • otherwise                     → a plain integer literal
    /// `code` addresses never leak as bare `= 0x<addr>;` data.
    ExprPtr buildIntegerConstant(int64_t value, CTypePtr type, uint64_t addr);

    // ── FIX-091 (issue #15 C1) — folded in-function code-address recovery ──
    //
    // A win64 image-based in-function code address that the cast layer folds
    // (`add(base_const, off_const)`) and the printer truncates to its low 32
    // bits surfaces as a bare data leak (`var_0 = 0x409B9F77;`).  This helper
    // recovers it: it rebuilds the full 64-bit candidate from the CURRENT
    // function's high 32 bits OR the value's low 32 bits (base/ASLR-agnostic),
    // then returns the honest code form (`&loc_<hex>` / `(void *)0xADDR`) ONLY
    // when the candidate is a genuine in-function code address (inside
    // [start, end) AND a recorded instruction/block address of this function).
    // Returns nullopt for ordinary immediate/data constants, which are left
    // exactly as today.  Shared by `buildIntegerConstant` and the `llvm.add` /
    // `llvm.sub` constant-fold short-circuit in `buildExpression`.
    std::optional<ExprPtr> resolveFoldedCodeLabel(uint64_t rawValue,
                                                  uint64_t addr = 0);

    // ── D2 — honest callee gating (FIX-089/FIX-090) ─────────────────────

    /// Resolve a (calleeName, targetAddr) pair against the address registry
    /// and write the honest call form into `outName`.  Returns true if the
    /// callee should be emitted as a NAMED call (`outName(...)`); returns
    /// false and rewrites `outName` to the honest indirect form
    /// `(*(code *)0xADDR)` when the target is provably not a function start.
    /// Mirrors Ghidra's `queryFunction`-gated call-name emission.
    bool gateCalleeName(const std::string& calleeName, uint64_t targetAddr,
                        std::string& outName);

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

    // ── Address registry state (FIX-089 — shared P0 honesty primitive) ──

    /// Module-scoped set of known function-start addresses (real lifted
    /// function entries + any `helix.function_starts` table entries).
    std::unordered_set<uint64_t> knownFunctionStarts_;

    /// True iff a real function table was supplied (more than just the
    /// current function's own entry).  The D2 cross-function rewrite only
    /// fires when this is true, so isolated single-function lifts — where
    /// the table holds only the self-entry and cannot list siblings — never
    /// regress legitimate cross-function `sub_xxxx` calls into indirect form.
    bool functionTableIsAuthoritative_ = false;

    /// Function-scoped map of basic-block leader address -> `loc_xxxx` label.
    /// The block half of the registry; built next to `blockLabels_`.
    std::unordered_map<uint64_t, std::string> blockStartToLabel_;

    // ── FIX-091 (issue #15 C1) — in-function code-address registry ─────────
    //
    // Every instruction `address` attribute harvested from the current
    // function, plus the function's address span.  Used by
    // `resolveFoldedCodeLabel` to decide whether a reconstructed candidate is
    // a real in-function code address (a leaked block/branch target) or an
    // ordinary data constant.  Function-scoped; rebuilt per `buildFunction`.
    std::unordered_set<uint64_t> inFunctionCodeAddrs_;
    uint64_t currentFunctionMinAddr_ = 0;
    uint64_t currentFunctionEndAddr_ = 0; // one past the highest instr address

    /// Set when D1/D2 emit a located honest marker (resolved code constant or
    /// honest indirect call).  Reserved for the D4 score-gate hook (next
    /// increment): a function carrying a damning honesty defect caps at 50%.
    bool hasDamningHonestyDefect_ = false;
};

} // namespace helix::cast

#endif // HELIX_CAST_AST_BUILDER_H
