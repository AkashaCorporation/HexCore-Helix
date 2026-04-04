#pragma once

#include "helix/cast/CDecl.h"
#include "helix/cast/CExpr.h"

#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace helix::cast {

/// Optimizes C AST trees with 6 transformation passes.
///
/// Each pass operates on a CFuncDecl in-place, rewriting the AST tree.
/// Passes run in a fixed order designed to maximize effectiveness:
///   1. Prologue/epilogue removal
///   2. Infrastructure elimination
///   3. Dead store elimination
///   4. Copy propagation
///   5. Expression simplification
///   6. Compound assignment synthesis
class CAstOptimizer {
public:
    /// Run all passes on a function declaration.
    void optimize(CFuncDecl& func);

    /// Individual passes (can be called selectively for testing).
    void removePrologueEpilogue(CFuncDecl& func);
    void eliminateInfrastructure(CFuncDecl& func);
    void eliminateDeadStores(CFuncDecl& func);
    void propagateCopies(CFuncDecl& func);
    void simplifyExpressions(CFuncDecl& func);
    void synthesizeCompoundAssign(CFuncDecl& func);
    void removeDeadCodeAfterReturn(CFuncDecl& func);
    void recoverStructFieldAccess(CFuncDecl& func);
    void canonicalizeXorPatterns(CFuncDecl& func);
    void eliminateConstantBranches(CFuncDecl& func);
    void removeEmptyIfStatements(CFuncDecl& func);
    void eliminateNullPtrStores(CFuncDecl& func);
    void cleanupFloatZeros(CFuncDecl& func);
    void collapseMinMaxPatterns(CFuncDecl& func);
    void foldRedundantReturnAfterElse(CFuncDecl& func);
    void invertEmptyIfThen(CFuncDecl& func);

    /// Apply user-defined variable renames to the entire AST.
    /// Walks all CVarRefExpr nodes and VarDecl names, replacing
    /// occurrences of old_name with new_name from the rename map.
    /// Also updates the function signature (param names, return var).
    void applyVariableRenames(
        CFuncDecl& func,
        const std::unordered_map<std::string, std::string>& renames);

private:
    // ── Variable rename helpers ──────────────────────────────────────────────

    /// Recursively walk an expression tree and rename all CVarRefExpr matches.
    static void renameInExpr(
        CExpr* expr,
        const std::unordered_map<std::string, std::string>& renames);

    /// Walk a statement list and rename variable references in all expressions.
    static void renameInStmtList(
        std::vector<StmtPtr>& stmts,
        const std::unordered_map<std::string, std::string>& renames);

    // ── Infrastructure filtering helpers ────────────────────────────────────

    /// Returns true if the statement should be removed as infrastructure noise.
    bool isInfrastructureStmt(const CStmt& stmt) const;

    /// Returns true if the assign target/value references infrastructure names.
    bool isInfrastructureAssign(const CAssignStmt& assign) const;

    /// Remove all matching statements from a statement list (recursive).
    void filterStatements(std::vector<StmtPtr>& stmts);

    // ── Dead store helpers ───────────────────────────────────────────────────

    /// Collect all CVarRefExpr names from an expression into the given set.
    static void collectVarRefs(const CExpr* expr,
                               std::unordered_set<std::string>& names);

    /// Returns true if the expression contains a CCallExpr (has side effects).
    static bool exprHasCall(const CExpr* expr);

    /// Returns true if the assign target should never be eliminated
    /// (pointer dereference, field access).
    static bool isUnsafeTarget(const CExpr* expr);

    // ── Copy propagation helpers ─────────────────────────────────────────────

    /// Count all CVarRefExpr occurrences in the given statement list (all scopes).
    void countVarRefs(const std::vector<StmtPtr>& stmts,
                      std::unordered_map<std::string, unsigned>& counts) const;

    /// Same, but for a single expression.
    static void countVarRefsInExpr(const CExpr* expr,
                                   std::unordered_map<std::string, unsigned>& counts);

    /// Returns true if the expression is "simple" enough to inline
    /// (no call, tree depth <= 3).
    static bool isSimpleExpr(const CExpr* expr, unsigned maxDepth = 3);

    /// Deep-clone an expression tree (required because unique_ptr ownership
    /// prevents sharing).
    static ExprPtr cloneExpr(const CExpr* expr);

    /// Returns true if the variable name looks like a synthetic temporary
    /// (var_N, spill_N, vN, tN, __tmp_N).
    static bool isSyntheticName(std::string_view name);

    // ── Expression simplification helpers ───────────────────────────────────

    /// Recursively simplify an expression tree; returns the (possibly new)
    /// expression that replaces the input.
    static ExprPtr simplifyExpr(ExprPtr expr);

    // ── Compound assignment helpers ──────────────────────────────────────────

    /// Try to synthesize a compound assignment for a single CAssignStmt.
    static void tryCompound(CAssignStmt& stmt);

    // ── Generic statement-tree walkers ───────────────────────────────────────

    /// Apply simplifyExpr to every expression contained in a statement list.
    static void simplifyStmtList(std::vector<StmtPtr>& stmts);

    /// Apply tryCompound to every CAssignStmt in a statement list (recursive).
    static void compoundStmtList(std::vector<StmtPtr>& stmts);

    /// Apply dead-store elimination to a statement list (flat, one scope).
    static void dseStmtList(std::vector<StmtPtr>& stmts);

    /// Apply copy propagation substitution to a statement list.
    static void copyPropStmtList(
        std::vector<StmtPtr>& stmts,
        const std::unordered_map<std::string, const CExpr*>& defs,
        const std::unordered_map<std::string, unsigned>& refCounts,
        std::unordered_set<std::string>& inlined);

    /// Substitute uses of inlined variables in an expression.
    static ExprPtr substituteVarRefs(
        ExprPtr expr,
        const std::unordered_map<std::string, const CExpr*>& defs,
        const std::unordered_map<std::string, unsigned>& refCounts,
        std::unordered_set<std::string>& inlined,
        unsigned contextDepth = 0);

    /// Simplify an expression inside a statement (helper that owns the expr slot).
    static void simplifyExprInStmt(ExprPtr& slot);

    // ── Dead code after return helpers ──────────────────────────────────────
    static void removeDeadAfterReturnInList(std::vector<StmtPtr>& stmts);

    // ── Struct field access recovery helpers ────────────────────────────────
    static ExprPtr recoverFieldAccess(ExprPtr expr);
    static void recoverFieldsInStmtList(std::vector<StmtPtr>& stmts);

    // ── XOR pattern canonicalization helpers ────────────────────────────────
    static ExprPtr canonicalizeXorExpr(ExprPtr expr);
    static void canonicalizeXorInStmtList(std::vector<StmtPtr>& stmts);

    // ── Constant branch elimination helpers ──────────────────────────────
    static void eliminateConstBranchesInList(std::vector<StmtPtr>& stmts);

    // ── Empty if-statement removal helpers ────────────────────────────
    static void removeEmptyIfsInList(std::vector<StmtPtr>& stmts);

    // ── Null pointer store elimination helpers ───────────────────────────
    static bool isNullPtrDeref(const CExpr* expr);
    static void eliminateNullStoresInList(std::vector<StmtPtr>& stmts);

    // ── Float zero cleanup helpers ──────────────────────────────────────
    static bool isNullPtrCast(const CExpr* expr);
    static ExprPtr replaceNullWithFloatZero(ExprPtr expr);
    static void cleanupFloatZerosInList(std::vector<StmtPtr>& stmts);

    // ── Min/Max collapse helpers ────────────────────────────────────────
    static void collapseMinMaxInList(std::vector<StmtPtr>& stmts);

    // ── Redundant return-after-else folding helpers ─────────────────────
    static void foldRedundantReturnInList(std::vector<StmtPtr>& stmts);

    // ── Empty if-then inversion helpers ─────────────────────────────────
    static void invertEmptyIfInList(std::vector<StmtPtr>& stmts);
};

} // namespace helix::cast
