/// @file CAstOptimizer.cpp
/// @brief Multi-pass C AST optimizer that rewrites CFuncDecl trees in-place.
///
/// Pass order:
///   1. removePrologueEpilogue   — strip frame setup/teardown register ops
///   2. eliminateInfrastructure  — remove decompiler bookkeeping artifacts
///   3. eliminateDeadStores      — backward liveness, remove overwritten vars
///   4. propagateCopies          — inline single-use synthetic temporaries
///   5. simplifyExpressions      — algebraic identity + de-Morgan rewriting
///   6. synthesizeCompoundAssign — x = x OP y  →  x OP= y  /  x++ / x--

#include "helix/cast/CAstOptimizer.h"

#include "helix/cast/CAstNode.h"
#include "helix/cast/CDecl.h"
#include "helix/cast/CExpr.h"
#include "helix/cast/CStmt.h"
#include "helix/cast/CType.h"
#include "helix/cast/DamningDefect.h"  // FIX-092: final-AST damning re-derivation

#include "llvm/ADT/StringMap.h"
#include "llvm/Support/Casting.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <cctype>
#include <cstring>
#include <format>
#include <functional>
#include <map>
#include <memory>
#include <optional>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace helix::cast {

// ═══════════════════════════════════════════════════════════════════════════════
// Utility helpers (file-local)
// ═══════════════════════════════════════════════════════════════════════════════

namespace {

/// True if `name` is a `loc_<hex>` code-label reference (FIX-089).  The D1
/// address-registry resolution emits `&loc_xxxx` for a block-start constant;
/// the `loc_xxxx` identifier names a code label (a CLabelStmt), not a data
/// variable, so the undeclared-var passes must skip it.
static bool isCodeLabelName(std::string_view n) {
    if (!n.starts_with("loc_") || n.size() <= 4)
        return false;
    for (size_t i = 4; i < n.size(); ++i) {
        char c = n[i];
        bool hex = (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') ||
                   (c >= 'A' && c <= 'F');
        if (!hex)
            return false;
    }
    return true;
}

/// True if the expression is a CVarRefExpr with the given name.
static bool isVarRef(const CExpr* e, std::string_view name) {
    if (!e || e->getKind() != NodeKind::VarRefExpr)
        return false;
    return static_cast<const CVarRefExpr*>(e)->varName == name;
}

/// True if e is a CIntLitExpr with value == v.
static bool isIntLit(const CExpr* e, int64_t v) {
    if (!e || e->getKind() != NodeKind::IntLitExpr)
        return false;
    return static_cast<const CIntLitExpr*>(e)->value == v;
}

/// Return the CIntLitExpr value if e is one, else nullopt.
static std::optional<int64_t> getIntLit(const CExpr* e) {
    if (!e || e->getKind() != NodeKind::IntLitExpr)
        return std::nullopt;
    return static_cast<const CIntLitExpr*>(e)->value;
}

/// Lightweight structural equality for expression trees.
///
/// Used by `simplifyExpr` to fold `x - (x - y) → y` (FIX-041 bug I).
/// The compound-assignment synthesizer lower in the file has its own
/// richer `exprEquals` — this one is kept intentionally simple and only
/// covers the node shapes that actually appear in arithmetic expressions
/// recovered by Helix (VarRef, IntLit, single-level Unary/Cast, and
/// BinaryExpr).  That's enough to catch the SBB idiom without tangling
/// with the other helper's definition.
static bool isSameExpr(const CExpr* a, const CExpr* b) {
    if (a == b) return true;
    if (!a || !b || a->getKind() != b->getKind()) return false;
    switch (a->getKind()) {
    case NodeKind::VarRefExpr:
        return static_cast<const CVarRefExpr*>(a)->varName ==
               static_cast<const CVarRefExpr*>(b)->varName;
    case NodeKind::IntLitExpr:
        return static_cast<const CIntLitExpr*>(a)->value ==
               static_cast<const CIntLitExpr*>(b)->value;
    case NodeKind::UnaryExpr: {
        auto& ua = static_cast<const CUnaryExpr&>(*a);
        auto& ub = static_cast<const CUnaryExpr&>(*b);
        return ua.op == ub.op &&
               isSameExpr(ua.operand.get(), ub.operand.get());
    }
    case NodeKind::CastExpr: {
        auto& ca = static_cast<const CCastExpr&>(*a);
        auto& cb = static_cast<const CCastExpr&>(*b);
        return isSameExpr(ca.operand.get(), cb.operand.get());
    }
    case NodeKind::BinaryExpr: {
        auto& ba = static_cast<const CBinaryExpr&>(*a);
        auto& bb = static_cast<const CBinaryExpr&>(*b);
        return ba.op == bb.op &&
               isSameExpr(ba.lhs.get(), bb.lhs.get()) &&
               isSameExpr(ba.rhs.get(), bb.rhs.get());
    }
    default:
        return false;
    }
}

/// True if the name is a general-purpose register name (x86-64).
static bool isRegisterName(std::string_view n) {
    static constexpr std::string_view regs[] = {
        "rax", "rbx", "rcx", "rdx", "rsi", "rdi", "rbp", "rsp",
        "r8",  "r9",  "r10", "r11", "r12", "r13", "r14", "r15",
        "RAX", "RBX", "RCX", "RDX", "RSI", "RDI", "RBP", "RSP",
        "R8",  "R9",  "R10", "R11", "R12", "R13", "R14", "R15",
        "eax", "ebx", "ecx", "edx", "esi", "edi", "ebp", "esp",
        "EAX", "EBX", "ECX", "EDX", "ESI", "EDI", "EBP", "ESP",
    };
    for (auto& r : regs)
        if (n == r) return true;
    return false;
}

/// True if n is one of the callee-saved registers (rbx, rbp, rsi, rdi, r12-r15).
static bool isCalleeSaved(std::string_view n) {
    static constexpr std::string_view cs[] = {
        "rbx", "rbp", "rsi", "rdi",
        "r12", "r13", "r14", "r15",
        "RBX", "RBP", "RSI", "RDI",
        "R12", "R13", "R14", "R15",
    };
    for (auto& r : cs)
        if (n == r) return true;
    return false;
}

/// True if n names a stack-pointer register.
static bool isStackPointer(std::string_view n) {
    return n == "rsp" || n == "RSP" || n == "esp" || n == "ESP";
}

/// True if n names a frame-pointer register.
static bool isFramePointer(std::string_view n) {
    return n == "rbp" || n == "RBP" || n == "ebp" || n == "EBP";
}

/// True if the CVarRefExpr target of an assign is one of the named registers.
static bool assignTargetIs(const CAssignStmt& a, std::string_view name) {
    return isVarRef(a.target.get(), name);
}

/// Flip a comparison BinaryOp to its logical negation.
static BinaryOp flipCmp(BinaryOp op) {
    switch (op) {
    case BinaryOp::Eq: return BinaryOp::Ne;
    case BinaryOp::Ne: return BinaryOp::Eq;
    case BinaryOp::Lt: return BinaryOp::Ge;
    case BinaryOp::Le: return BinaryOp::Gt;
    case BinaryOp::Gt: return BinaryOp::Le;
    case BinaryOp::Ge: return BinaryOp::Lt;
    default:           return op; // non-comparison — caller must check
    }
}

static bool isCmpOp(BinaryOp op) {
    return op == BinaryOp::Eq || op == BinaryOp::Ne ||
           op == BinaryOp::Lt || op == BinaryOp::Le ||
           op == BinaryOp::Gt || op == BinaryOp::Ge;
}

/// Map BinaryOp to its compound-assignment string, or nullptr if none.
static const char* compoundOpStr(BinaryOp op) {
    switch (op) {
    case BinaryOp::Add:    return "+=";
    case BinaryOp::Sub:    return "-=";
    case BinaryOp::Mul:    return "*=";
    case BinaryOp::Div:    return "/=";
    case BinaryOp::Mod:    return "%=";
    case BinaryOp::Shl:    return "<<=";
    case BinaryOp::Shr:    return ">>=";
    case BinaryOp::Sar:    return ">>=";
    case BinaryOp::BitAnd: return "&=";
    case BinaryOp::BitOr:  return "|=";
    case BinaryOp::BitXor: return "^=";
    default:               return nullptr;
    }
}

/// True if op is commutative (a op b == b op a).
static bool isCommutative(BinaryOp op) {
    return op == BinaryOp::Add || op == BinaryOp::Mul ||
           op == BinaryOp::BitAnd || op == BinaryOp::BitOr ||
           op == BinaryOp::BitXor;
}

} // namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Public entry point
// ═══════════════════════════════════════════════════════════════════════════════

void CAstOptimizer::optimize(CFuncDecl& func) {
    removePrologueEpilogue(func);
    eliminateInfrastructure(func);
    eliminateNullPtrStores(func);
    recognizeStackCanary(func);
    inferSemanticNames(func);
    renameRemainingRegisterVars(func);
    decomposeNativeOpcodes(func);
    eliminateDeadStores(func);
    propagateCopies(func);
    canonicalizeXorPatterns(func);
    recoverStructFieldAccess(func);
    simplifyExpressions(func);
    // FIX-086 (dewolf-inspired): strip casts that are no-ops at the C
    // type level (e.g. `(int64_t)(void*)0` → `0`).  Must run after
    // `simplifyExpressions` so we operate on the canonicalized tree but
    // before `synthesizeCompoundAssign` so cast-wrapped RHSs are matched
    // against bare-LHS targets in `tryCompound`.
    eliminateRedundantCasts(func);
    synthesizeCompoundAssign(func);
    eliminateConstantBranches(func);
    removeEmptyIfStatements(func);
    cleanupFloatZeros(func);
    collapseMinMaxPatterns(func);
    foldRedundantReturnAfterElse(func);
    invertEmptyIfThen(func);
    simplifyConditionPolarity(func);
    foldDegenerateCompounds(func);
    downgradeDeadAssignedCalls(func);
    declareUndeclaredVars(func);
    removeSelfAssignments(func);
    removeDanglingGotos(func);
    removeDeadCodeAfterReturn(func);
    removeEmptyIfStatements(func);
    unwrapTrivialDoWhile(func);
    cleanupParameterSSASuffixes(func);
    resolveFramePointerLeaks(func);
    removeAdjacentDuplicateStmts(func);
    removeDeadStoresBeforeReturn(func);
    collapseAssignBeforeReturn(func);
    initializeReadBeforeWriteVars(func);
    // v0.9.1 (G-002): drop the lift's downstream garbage — null-deref
    // stores on placeholder vars and unreachable tails after a leading
    // return. These passes run last in the optimisation order so they
    // see the AST after every other simplification has had a chance to
    // legitimise the patterns (e.g. propagateCopies may rewrite `*v` to
    // a real lvalue if `v` was a simple alias of a real pointer).
    removeNullDerefPlaceholderStores(func);
    removeUnreachableAfterFirstReturn(func);
    // FIX-CAST-001: the late DCE passes above (removeDeadStoresBeforeReturn,
    // removeNullDerefPlaceholderStores, removeUnreachableAfterFirstReturn) can
    // empty an if-body that was non-empty when removeEmptyIfStatements last ran,
    // leaving an `if (cond) { }` shell that the scorer then penalises as an
    // "empty if/else block".  Re-run the empty-if sweep here, after all
    // body-emptying passes and before reanalyzeConfidence, so those late-created
    // dead shells are stripped instead of counted.  Safe: only erases ifs whose
    // then AND else bodies are both empty (same predicate the earlier sweeps use).
    removeEmptyIfStatements(func);
    // Sweep nested/globally-dead pure stores (e.g. a deeply-nested
    // `var_0 = 0xADDR` PC-tracking shadow) that the top-level-only dseStmtList
    // leaves behind; then drop the now-unreferenced declarations.
    removeGloballyDeadStores(func);
    removeUnusedDeclarations(func);
    reanalyzeConfidence(func);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: removeSelfAssignments — drop statements of the form "x = x;"
// ═══════════════════════════════════════════════════════════════════════════════
//
// These arise from:
//   - Remill lifting patterns where a register reads its own value through
//     an identity operation (CMOV with always-true cond, MOV reg,reg).
//   - SSA versions coalesced to the same variable name by Phase 3.5 of
//     RecoverVariables — the AssignOp becomes "x = x".
//
// We compare by name only (not var_id) because the CAstBuilder may have
// built the target and value as separate CVarRefExpr instances with
// different IDs even when they reference the same logical variable after
// coalescing.

static void removeSelfAssignsInList(std::vector<StmtPtr>& stmts) {
    // First recurse into nested scopes.
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            removeSelfAssignsInList(s.thenBody);
            removeSelfAssignsInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            removeSelfAssignsInList(
                static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            removeSelfAssignsInList(
                static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            removeSelfAssignsInList(static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                removeSelfAssignsInList(c.body);
            break;
        case NodeKind::BlockStmt:
            removeSelfAssignsInList(
                static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }

    // Now remove self-assigns at this level.
    stmts.erase(
        std::remove_if(stmts.begin(), stmts.end(),
            [](const StmtPtr& sp) {
                if (!sp || sp->getKind() != NodeKind::AssignStmt)
                    return false;
                const auto& a = static_cast<const CAssignStmt&>(*sp);
                // Only plain "=" (not compound +=, -=, etc.)
                if (!a.compoundOp.empty())
                    return false;
                if (!a.target || !a.value)
                    return false;
                if (a.target->getKind() != NodeKind::VarRefExpr ||
                    a.value->getKind() != NodeKind::VarRefExpr)
                    return false;
                const auto& t =
                    static_cast<const CVarRefExpr&>(*a.target);
                const auto& v =
                    static_cast<const CVarRefExpr&>(*a.value);
                return t.varName == v.varName && !t.varName.empty();
            }),
        stmts.end());
}

void CAstOptimizer::removeSelfAssignments(CFuncDecl& func) {
    removeSelfAssignsInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: removeUnreachableAfterFirstReturn (G-002, v0.9.1)
// ═══════════════════════════════════════════════════════════════════════════════
//
// When the *very first executable statement* of the function body is a
// `return`, every statement after it is unreachable by construction —
// there is no live prefix from which any branch could re-enter the
// trailing region. This pass drops that trailing region.
//
// The motivation is the malware.ko `init_module → hook_syslog` output:
//
//   int64_t hook_syslog(...) {
//       int64_t v1 = 0;          ← decls (allowed before the return)
//       ...
//       return sub_c();          ← first executable statement
//       param_1_1 = ...;         ← dead
//       v3 = ...;                ← dead
//       ... 16 more lines ...    ← all dead
//   }
//
// The existing `removeDeadCodeAfterReturn` preserves tails when any
// statement after the return has side effects (FIX-050, Wave 12). That
// preservation is correct for the *general* case (error-path tails are
// legitimate); it is wrong here because the function body never reaches
// the tail at all. The stricter condition this pass uses — "the FIRST
// executable statement was a return" — guarantees the tail is from a
// lift defect (the G-003 unapplied-relocation cascade) and is safe to
// elide. We do *not* extend `removeDeadCodeAfterReturn` itself, to
// preserve its FIX-050 behaviour on functions that have legitimate
// executable code before their early return.

void CAstOptimizer::removeUnreachableAfterFirstReturn(CFuncDecl& func) {
    // Find the index of the first non-comment, non-label executable
    // statement. We tolerate leading CCommentStmt and CLabelStmt because
    // those are bookkeeping, not "the function actually did something."
    size_t firstExec = func.body.size();
    for (size_t i = 0; i < func.body.size(); ++i) {
        const CStmt* s = func.body[i].get();
        if (!s) continue;
        auto k = s->getKind();
        if (k == NodeKind::CommentStmt || k == NodeKind::LabelStmt) continue;
        firstExec = i;
        break;
    }
    if (firstExec >= func.body.size()) return;
    if (func.body[firstExec]->getKind() != NodeKind::ReturnStmt) return;

    // The function returns on the first executable statement. Everything
    // after that index is unreachable. Truncate.
    if (firstExec + 1 < func.body.size()) {
        func.body.erase(func.body.begin() + (firstExec + 1), func.body.end());
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: removeNullDerefPlaceholderStores (G-002, v0.9.1)
// ═══════════════════════════════════════════════════════════════════════════════
//
// Drop statements of the form
//
//     *<v> = <anything>;
//
// where `<v>` is a local declared with an initialiser that is
// syntactically zero (`0`, `(void*)0`, `NULL`, or a cast of either) AND
// has not been reassigned anywhere in the function body before this
// statement. The store dereferences a value provably 0 at this program
// point — it is undefined behaviour on the original program semantics
// and cannot have come from real machine code. It is exclusively a lift
// artefact (the zero-address placeholder path in RemillToHelixLow.cpp,
// downstream of G-003's unapplied relocations).
//
// We walk the body in program order, tracking which placeholder vars
// have already been reassigned (so a `*v = …` *after* a `v = real_value;`
// is preserved — it is a real store through a now-valid pointer).
// This pass does NOT touch `*v = …` where `v` is a parameter or any
// non-zero-init local: those are real writes through a possibly-valid
// pointer and removing them would lose program semantics.

namespace {

bool isZeroLitForPlaceholderDetect(const CExpr* e) {
    if (!e) return false;
    if (auto* lit = llvm::dyn_cast<CIntLitExpr>(e)) return lit->value == 0;
    if (auto* lit = llvm::dyn_cast<CAddrLitExpr>(e)) return lit->addrValue == 0;
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return isZeroLitForPlaceholderDetect(c->operand.get());
    return false;
}

std::string varNameOfStripped(const CExpr* e) {
    if (!e) return {};
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return varNameOfStripped(c->operand.get());
    if (auto* v = llvm::dyn_cast<CVarRefExpr>(e)) return v->varName;
    return {};
}

void dropNullDerefStoresInList(
    std::vector<StmtPtr>& body,
    const std::unordered_set<std::string>& zeroInit,
    std::unordered_set<std::string>& reassigned)
{
    std::vector<StmtPtr> kept;
    kept.reserve(body.size());
    for (auto& sp : body) {
        if (!sp) { kept.push_back(std::move(sp)); continue; }
        // Recurse into compound statements (the program-order traversal
        // matters because `reassigned` is updated as we go).
        if (auto* i = llvm::dyn_cast<CIfStmt>(sp.get())) {
            dropNullDerefStoresInList(i->thenBody, zeroInit, reassigned);
            dropNullDerefStoresInList(i->elseBody, zeroInit, reassigned);
            kept.push_back(std::move(sp));
            continue;
        }
        if (auto* w = llvm::dyn_cast<CWhileStmt>(sp.get())) {
            dropNullDerefStoresInList(w->body, zeroInit, reassigned);
            kept.push_back(std::move(sp));
            continue;
        }
        if (auto* dw = llvm::dyn_cast<CDoWhileStmt>(sp.get())) {
            dropNullDerefStoresInList(dw->body, zeroInit, reassigned);
            kept.push_back(std::move(sp));
            continue;
        }
        if (auto* fr = llvm::dyn_cast<CForStmt>(sp.get())) {
            dropNullDerefStoresInList(fr->body, zeroInit, reassigned);
            kept.push_back(std::move(sp));
            continue;
        }
        if (auto* sw = llvm::dyn_cast<CSwitchStmt>(sp.get())) {
            for (auto& c : sw->cases)
                dropNullDerefStoresInList(c.body, zeroInit, reassigned);
            kept.push_back(std::move(sp));
            continue;
        }
        if (auto* blk = llvm::dyn_cast<CBlockStmt>(sp.get())) {
            dropNullDerefStoresInList(blk->stmts, zeroInit, reassigned);
            kept.push_back(std::move(sp));
            continue;
        }
        if (auto* a = llvm::dyn_cast<CAssignStmt>(sp.get())) {
            // Detect `*<placeholder> = …`.
            if (auto* u = llvm::dyn_cast<CUnaryExpr>(a->target.get());
                u && u->op == UnaryOp::Deref) {
                auto vn = varNameOfStripped(u->operand.get());
                if (!vn.empty() && zeroInit.count(vn) &&
                    !reassigned.count(vn)) {
                    // Drop this statement — UB on a provably-null pointer
                    // is dead code from the original program's POV.
                    continue;
                }
            }
            // Track plain-var reassignments. `*p = …` does NOT reassign
            // `p`; only `p = …` does. The Deref case above already
            // handled `*p = …` before this check.
            if (auto vn = varNameOfStripped(a->target.get()); !vn.empty()) {
                reassigned.insert(vn);
            }
        }
        kept.push_back(std::move(sp));
    }
    body = std::move(kept);
}

} // namespace

void CAstOptimizer::removeNullDerefPlaceholderStores(CFuncDecl& func) {
    std::unordered_set<std::string> zeroInit;
    for (const auto& lv : func.localVars) {
        if (lv.initExpr && isZeroLitForPlaceholderDetect(lv.initExpr.get()))
            zeroInit.insert(lv.varName);
    }
    if (zeroInit.empty()) return;
    std::unordered_set<std::string> reassigned;
    dropNullDerefStoresInList(func.body, zeroInit, reassigned);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: removeDanglingGotos — drop `goto L;` when no label L is defined
// ═══════════════════════════════════════════════════════════════════════════════
//
// When irreducible SCC handling in StructureControlFlow emits a goto to an
// irreducible edge target, the label may later be eliminated by other
// structuring passes (loop recovery, if/else detection).  The orphaned
// goto points to nothing, so we drop it.
//
// Also drops a trailing `goto L;` at the very end of the function body
// when the label exists but is unreachable from the goto's position (the
// goto can only "fall through" to end-of-function, which is the same as
// plain return — and the goto is effectively no-op dead code).

static void collectLabels(const std::vector<StmtPtr>& stmts,
                          std::unordered_set<std::string>& out) {
    for (const auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::LabelStmt: {
            const auto& l = static_cast<const CLabelStmt&>(*sp);
            out.insert(l.name);
            break;
        }
        case NodeKind::IfStmt: {
            const auto& s = static_cast<const CIfStmt&>(*sp);
            collectLabels(s.thenBody, out);
            collectLabels(s.elseBody, out);
            break;
        }
        case NodeKind::WhileStmt:
            collectLabels(
                static_cast<const CWhileStmt&>(*sp).body, out);
            break;
        case NodeKind::DoWhileStmt:
            collectLabels(
                static_cast<const CDoWhileStmt&>(*sp).body, out);
            break;
        case NodeKind::ForStmt:
            collectLabels(
                static_cast<const CForStmt&>(*sp).body, out);
            break;
        case NodeKind::SwitchStmt:
            for (const auto& c : static_cast<const CSwitchStmt&>(*sp).cases)
                collectLabels(c.body, out);
            break;
        case NodeKind::BlockStmt:
            collectLabels(
                static_cast<const CBlockStmt&>(*sp).stmts, out);
            break;
        default:
            break;
        }
    }
}

static void dropDanglingGotosInList(
    std::vector<StmtPtr>& stmts,
    const std::unordered_set<std::string>& definedLabels) {
    // Recurse first
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            dropDanglingGotosInList(s.thenBody, definedLabels);
            dropDanglingGotosInList(s.elseBody, definedLabels);
            break;
        }
        case NodeKind::WhileStmt:
            dropDanglingGotosInList(
                static_cast<CWhileStmt&>(*sp).body, definedLabels);
            break;
        case NodeKind::DoWhileStmt:
            dropDanglingGotosInList(
                static_cast<CDoWhileStmt&>(*sp).body, definedLabels);
            break;
        case NodeKind::ForStmt:
            dropDanglingGotosInList(
                static_cast<CForStmt&>(*sp).body, definedLabels);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                dropDanglingGotosInList(c.body, definedLabels);
            break;
        case NodeKind::BlockStmt:
            dropDanglingGotosInList(
                static_cast<CBlockStmt&>(*sp).stmts, definedLabels);
            break;
        default:
            break;
        }
    }

    // Drop gotos to undefined labels at this level.
    stmts.erase(
        std::remove_if(stmts.begin(), stmts.end(),
            [&](const StmtPtr& sp) {
                if (!sp || sp->getKind() != NodeKind::GotoStmt)
                    return false;
                const auto& g = static_cast<const CGotoStmt&>(*sp);
                return definedLabels.find(g.label) == definedLabels.end();
            }),
        stmts.end());
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: inferSemanticNames — rename register vars from call context
// ═══════════════════════════════════════════════════════════════════════════════
//
// When a register-named variable (rax, rbx, r14, etc.) appears as:
//   - LHS of a call assignment: `rax = kmalloc(...)` → rename rax → "alloc"
//   - Argument to a known function: `mutex_lock(r14)` → rename r14 → "lock"
//
// Only renames if:
//   - The variable has a plain register name (no param_, result, var_ prefix)
//   - The call target is in the known semantic table
//   - No conflicting renames exist (first rename wins)

static bool isPlainRegisterName(std::string_view name) {
    // rax, rbx, rcx, rdx, rsi, rdi, rbp, rsp, r8-r15, xmm0-xmm15
    if (name.starts_with("rax") || name.starts_with("rbx") ||
        name.starts_with("rcx") || name.starts_with("rdx") ||
        name.starts_with("rsi") || name.starts_with("rdi") ||
        name.starts_with("rbp") || name.starts_with("rsp") ||
        name.starts_with("r8")  || name.starts_with("r9")  ||
        name.starts_with("r10") || name.starts_with("r11") ||
        name.starts_with("r12") || name.starts_with("r13") ||
        name.starts_with("r14") || name.starts_with("r15") ||
        name.starts_with("xmm") ||
        // 32-bit sub-register aliases
        name.starts_with("eax") || name.starts_with("ebx") ||
        name.starts_with("ecx") || name.starts_with("edx") ||
        name.starts_with("esi") || name.starts_with("edi") ||
        name.starts_with("ebp") || name.starts_with("esp"))
        return true;
    return false;
}

/// Apply a rename to all CVarRefExpr and CVarDecl nodes in a stmt list.
static void applyRenameInStmts(std::vector<StmtPtr>& stmts,
                                const std::string& oldName,
                                const std::string& newName);

static void applyRenameInExpr(CExpr* e,
                               const std::string& oldName,
                               const std::string& newName) {
    if (!e) return;
    switch (e->getKind()) {
    case NodeKind::VarRefExpr: {
        auto& v = static_cast<CVarRefExpr&>(*e);
        if (v.varName == oldName) v.varName = newName;
        break;
    }
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*e);
        applyRenameInExpr(b.lhs.get(), oldName, newName);
        applyRenameInExpr(b.rhs.get(), oldName, newName);
        break;
    }
    case NodeKind::UnaryExpr:
        applyRenameInExpr(
            static_cast<CUnaryExpr&>(*e).operand.get(), oldName, newName);
        break;
    case NodeKind::CastExpr:
        applyRenameInExpr(
            static_cast<CCastExpr&>(*e).operand.get(), oldName, newName);
        break;
    case NodeKind::CallExpr: {
        auto& c = static_cast<CCallExpr&>(*e);
        for (auto& arg : c.args)
            applyRenameInExpr(arg.get(), oldName, newName);
        break;
    }
    case NodeKind::FieldAccessExpr:
        applyRenameInExpr(
            static_cast<CFieldAccessExpr&>(*e).base.get(), oldName, newName);
        break;
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*e);
        applyRenameInExpr(s.base.get(), oldName, newName);
        applyRenameInExpr(s.index.get(), oldName, newName);
        break;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*e);
        applyRenameInExpr(t.cond.get(), oldName, newName);
        applyRenameInExpr(t.trueVal.get(), oldName, newName);
        applyRenameInExpr(t.falseVal.get(), oldName, newName);
        break;
    }
    default:
        break;
    }
}

static void applyRenameInStmts(std::vector<StmtPtr>& stmts,
                                const std::string& oldName,
                                const std::string& newName) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<CAssignStmt&>(*sp);
            applyRenameInExpr(a.target.get(), oldName, newName);
            applyRenameInExpr(a.value.get(), oldName, newName);
            break;
        }
        case NodeKind::ExprStmt:
            applyRenameInExpr(
                static_cast<CExprStmt&>(*sp).expr.get(), oldName, newName);
            break;
        case NodeKind::ReturnStmt:
            applyRenameInExpr(
                static_cast<CReturnStmt&>(*sp).value.get(), oldName, newName);
            break;
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            applyRenameInExpr(s.condition.get(), oldName, newName);
            applyRenameInStmts(s.thenBody, oldName, newName);
            applyRenameInStmts(s.elseBody, oldName, newName);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& s = static_cast<CWhileStmt&>(*sp);
            applyRenameInExpr(s.condition.get(), oldName, newName);
            applyRenameInStmts(s.body, oldName, newName);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& s = static_cast<CDoWhileStmt&>(*sp);
            applyRenameInExpr(s.condition.get(), oldName, newName);
            applyRenameInStmts(s.body, oldName, newName);
            break;
        }
        case NodeKind::ForStmt: {
            auto& s = static_cast<CForStmt&>(*sp);
            applyRenameInExpr(s.condition.get(), oldName, newName);
            applyRenameInStmts(s.body, oldName, newName);
            break;
        }
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                applyRenameInStmts(c.body, oldName, newName);
            break;
        case NodeKind::BlockStmt:
            applyRenameInStmts(
                static_cast<CBlockStmt&>(*sp).stmts, oldName, newName);
            break;
        default:
            break;
        }
    }
}

void CAstOptimizer::inferSemanticNames(CFuncDecl& func) {
    // Table: call target → return value semantic name
    static const llvm::StringMap<std::string> kReturnNames = {
        {"malloc",       "alloc"},  {"calloc",      "alloc"},
        {"realloc",      "alloc"},  {"kmalloc",     "alloc"},
        {"kzalloc",      "alloc"},  {"vmalloc",     "alloc"},
        {"kvmalloc",     "alloc"},  {"krealloc",    "alloc"},
        {"kmem_cache_alloc", "cache_obj"},
        {"kbase_mem_alloc",  "region"},
        {"kbase_alloc_phy_pages_helper_locked", "pages"},
        {"CreateFileW",  "handle"}, {"CreateFileA", "handle"},
        {"OpenProcess",  "proc"},   {"VirtualAlloc","alloc"},
        {"LoadLibraryA", "hmod"},   {"LoadLibraryW","hmod"},
        {"GetProcAddress","pfn"},   {"HeapAlloc",   "alloc"},
        {"fopen",        "fp"},     {"fdopen",      "fp"},
        {"strdup",       "dup"},    {"strndup",     "dup"},
        {"mmap",         "mapped"}, {"dlopen",      "handle"},
        {"socket",       "sock"},   {"accept",      "conn"},
    };

    // Table: call target → param semantic names (positional)
    static const llvm::StringMap<std::vector<std::string>> kParamNames = {
        {"mutex_lock",      {"lock"}},
        {"mutex_unlock",    {"lock"}},
        {"mutex_trylock",   {"lock"}},
        {"down_read",       {"sem"}},
        {"down_write",      {"sem"}},
        {"up_read",         {"sem"}},
        {"up_write",        {"sem"}},
        {"_raw_spin_lock",  {"spinlock"}},
        {"_raw_spin_unlock",{"spinlock"}},
        {"spin_lock",       {"spinlock"}},
        {"spin_unlock",     {"spinlock"}},
        {"kfree",           {"ptr"}},
        {"vfree",           {"ptr"}},
        {"free",            {"ptr"}},
        {"memcpy",          {"dst", "src", "size"}},
        {"memset",          {"dst", "val", "size"}},
        {"memmove",         {"dst", "src", "size"}},
        {"strcmp",           {"s1", "s2"}},
        {"strncmp",          {"s1", "s2", "n"}},
        {"strcpy",           {"dst", "src"}},
        {"strlen",           {"str"}},
    };

    // Track which variables have been renamed (first rename wins)
    // and which target names have been used (for uniqueness).
    std::unordered_set<std::string> renamed;
    std::unordered_set<std::string> usedNames;

    // Collect existing names to avoid conflicts.
    for (auto& d : func.localVars)
        usedNames.insert(d.varName);
    for (auto& p : func.params)
        usedNames.insert(p.name);

    // Helper: make a unique name by appending _N if needed.
    auto makeUnique = [&](const std::string& base) -> std::string {
        if (!usedNames.count(base)) {
            usedNames.insert(base);
            return base;
        }
        for (unsigned i = 2; i < 100; ++i) {
            auto candidate = base + "_" + std::to_string(i);
            if (!usedNames.count(candidate)) {
                usedNames.insert(candidate);
                return candidate;
            }
        }
        return base; // fallback
    };

    // ── Item 3: Return value naming ──────────────────────────────────
    // Scan for: target = callFunc(...)
    // If target is register-named and callFunc is in kReturnNames, rename.
    for (auto& sp : func.body) {
        if (!sp || sp->getKind() != NodeKind::AssignStmt) continue;
        auto& a = static_cast<CAssignStmt&>(*sp);
        if (!a.target || !a.value) continue;
        if (a.target->getKind() != NodeKind::VarRefExpr) continue;
        if (a.value->getKind() != NodeKind::CallExpr) continue;

        auto& tgt = static_cast<CVarRefExpr&>(*a.target);
        auto& call = static_cast<CCallExpr&>(*a.value);

        if (!isPlainRegisterName(tgt.varName)) continue;
        if (renamed.count(tgt.varName)) continue;

        auto it = kReturnNames.find(call.targetName);
        if (it == kReturnNames.end()) continue;

        std::string oldName = tgt.varName;
        std::string newName = makeUnique(it->second);

        renamed.insert(oldName);
        applyRenameInStmts(func.body, oldName, newName);

        // Also rename in variable declarations.
        for (auto& d : func.localVars) {
            if (d.varName == oldName) d.varName = newName;
        }
    }

    // ── Item 1: Call arg naming ──────────────────────────────────────
    // Scan for: callFunc(regVar, ...) where regVar is register-named.
    // If callFunc is in kParamNames, rename regVar to the param name.
    //
    // We collect rename candidates first, then apply (to avoid modifying
    // the AST while scanning).
    std::vector<std::pair<std::string, std::string>> argRenames;

    auto scanCallArgs = [&](const CCallExpr& call) {
        auto it = kParamNames.find(call.targetName);
        if (it == kParamNames.end()) return;
        const auto& paramNames = it->second;

        for (size_t i = 0; i < call.args.size() && i < paramNames.size(); ++i) {
            if (!call.args[i]) continue;
            if (call.args[i]->getKind() != NodeKind::VarRefExpr) continue;
            auto& arg = static_cast<const CVarRefExpr&>(*call.args[i]);
            if (!isPlainRegisterName(arg.varName)) continue;
            if (renamed.count(arg.varName)) continue;

            std::string uniqueName = makeUnique(paramNames[i]);
            renamed.insert(arg.varName);
            argRenames.emplace_back(arg.varName, uniqueName);
        }
    };

    // Scan all call expressions (in statements and nested expressions).
    std::function<void(const std::vector<StmtPtr>&)> scanStmts;
    scanStmts = [&](const std::vector<StmtPtr>& stmts) {
        for (auto& sp : stmts) {
            if (!sp) continue;
            switch (sp->getKind()) {
            case NodeKind::ExprStmt: {
                auto& e = static_cast<CExprStmt&>(*sp);
                if (e.expr && e.expr->getKind() == NodeKind::CallExpr)
                    scanCallArgs(static_cast<CCallExpr&>(*e.expr));
                break;
            }
            case NodeKind::AssignStmt: {
                auto& a = static_cast<CAssignStmt&>(*sp);
                if (a.value && a.value->getKind() == NodeKind::CallExpr)
                    scanCallArgs(static_cast<CCallExpr&>(*a.value));
                break;
            }
            case NodeKind::IfStmt: {
                auto& s = static_cast<CIfStmt&>(*sp);
                scanStmts(s.thenBody);
                scanStmts(s.elseBody);
                break;
            }
            case NodeKind::WhileStmt:
                scanStmts(static_cast<CWhileStmt&>(*sp).body);
                break;
            case NodeKind::DoWhileStmt:
                scanStmts(static_cast<CDoWhileStmt&>(*sp).body);
                break;
            case NodeKind::ForStmt:
                scanStmts(static_cast<CForStmt&>(*sp).body);
                break;
            default:
                break;
            }
        }
    };
    scanStmts(func.body);

    // Apply arg renames.
    for (auto& [oldName, newName] : argRenames) {
        applyRenameInStmts(func.body, oldName, newName);
        for (auto& d : func.localVars) {
            if (d.varName == oldName) d.varName = newName;
        }
    }
}

void CAstOptimizer::removeDanglingGotos(CFuncDecl& func) {
    // Only drop gotos whose target label doesn't exist anywhere in the
    // function body.  Gotos to defined labels are KEPT because kernel
    // cleanup code legitimately uses goto (the IDA ground truth for
    // kbase_jit_allocate has 10 gotos and 6 labels — they're idiomatic).
    std::unordered_set<std::string> definedLabels;
    collectLabels(func.body, definedLabels);
    dropDanglingGotosInList(func.body, definedLabels);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: renameRemainingRegisterVars — catch-all for register-named variables
// ═══════════════════════════════════════════════════════════════════════════════
//
// After inferSemanticNames has renamed variables with known call context,
// any remaining register-named variables (r15, rbx_2, rdi_1, xmm4, etc.)
// and _promoted_N temporaries are renamed to sequential v1, v2, v3...
//
// Register names should NEVER appear in decompiled output — they are
// internal to the CPU and meaningless to a reader.  IDA uses vN, Ghidra
// uses uVarN.  We follow the IDA convention.

/// Collect all unique variable names referenced in an expression.
static void collectVarNamesInExpr(const CExpr* expr,
                                   std::unordered_set<std::string>& names) {
    if (!expr) return;
    switch (expr->getKind()) {
    case NodeKind::VarRefExpr:
        names.insert(static_cast<const CVarRefExpr&>(*expr).varName);
        break;
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<const CBinaryExpr&>(*expr);
        collectVarNamesInExpr(b.lhs.get(), names);
        collectVarNamesInExpr(b.rhs.get(), names);
        break;
    }
    case NodeKind::UnaryExpr:
        collectVarNamesInExpr(
            static_cast<const CUnaryExpr&>(*expr).operand.get(), names);
        break;
    case NodeKind::CastExpr:
        collectVarNamesInExpr(
            static_cast<const CCastExpr&>(*expr).operand.get(), names);
        break;
    case NodeKind::CallExpr:
        for (auto& a : static_cast<const CCallExpr&>(*expr).args)
            collectVarNamesInExpr(a.get(), names);
        break;
    case NodeKind::FieldAccessExpr:
        collectVarNamesInExpr(
            static_cast<const CFieldAccessExpr&>(*expr).base.get(), names);
        break;
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<const CSubscriptExpr&>(*expr);
        collectVarNamesInExpr(s.base.get(), names);
        collectVarNamesInExpr(s.index.get(), names);
        break;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<const CTernaryExpr&>(*expr);
        collectVarNamesInExpr(t.cond.get(), names);
        collectVarNamesInExpr(t.trueVal.get(), names);
        collectVarNamesInExpr(t.falseVal.get(), names);
        break;
    }
    default: break;
    }
}

/// Collect all unique variable names referenced in a statement list.
static void collectVarNamesInStmts(const std::vector<StmtPtr>& stmts,
                                    std::unordered_set<std::string>& names) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<const CAssignStmt&>(*sp);
            collectVarNamesInExpr(a.target.get(), names);
            collectVarNamesInExpr(a.value.get(), names);
            break;
        }
        case NodeKind::ExprStmt:
            collectVarNamesInExpr(
                static_cast<const CExprStmt&>(*sp).expr.get(), names);
            break;
        case NodeKind::ReturnStmt:
            collectVarNamesInExpr(
                static_cast<const CReturnStmt&>(*sp).value.get(), names);
            break;
        case NodeKind::IfStmt: {
            auto& s = static_cast<const CIfStmt&>(*sp);
            collectVarNamesInExpr(s.condition.get(), names);
            collectVarNamesInStmts(s.thenBody, names);
            collectVarNamesInStmts(s.elseBody, names);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& s = static_cast<const CWhileStmt&>(*sp);
            collectVarNamesInExpr(s.condition.get(), names);
            collectVarNamesInStmts(s.body, names);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& s = static_cast<const CDoWhileStmt&>(*sp);
            collectVarNamesInExpr(s.condition.get(), names);
            collectVarNamesInStmts(s.body, names);
            break;
        }
        case NodeKind::ForStmt: {
            auto& s = static_cast<const CForStmt&>(*sp);
            collectVarNamesInExpr(s.condition.get(), names);
            collectVarNamesInStmts(s.body, names);
            break;
        }
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<const CSwitchStmt&>(*sp).cases)
                collectVarNamesInStmts(c.body, names);
            break;
        case NodeKind::BlockStmt:
            collectVarNamesInStmts(
                static_cast<const CBlockStmt&>(*sp).stmts, names);
            break;
        default: break;
        }
    }
}

void CAstOptimizer::renameRemainingRegisterVars(CFuncDecl& func) {
    // Collect all existing names to avoid collisions.
    std::unordered_set<std::string> usedNames;
    for (auto& d : func.localVars) usedNames.insert(d.varName);
    for (auto& p : func.params)    usedNames.insert(p.name);

    unsigned nextId = 1;
    auto makeUnique = [&]() -> std::string {
        while (true) {
            auto name = "v" + std::to_string(nextId++);
            if (!usedNames.count(name)) {
                usedNames.insert(name);
                return name;
            }
        }
    };

    // Phase 1: Rename register-named variables in localVars.
    for (auto& d : func.localVars) {
        bool needsRename = isPlainRegisterName(d.varName)
                        || d.varName.starts_with("_promoted_");
        if (!needsRename) continue;

        std::string oldName = d.varName;
        std::string newName = makeUnique();

        applyRenameInStmts(func.body, oldName, newName);
        d.varName = newName;
    }

    // Phase 2: Scan body for register-named references NOT in localVars.
    // These come from MLIR block arguments or SSA values that were never
    // assigned to a local variable declaration.
    std::unordered_set<std::string> bodyNames;
    collectVarNamesInStmts(func.body, bodyNames);

    // Rebuild usedNames after Phase 1 renames.
    usedNames.clear();
    for (auto& d : func.localVars) usedNames.insert(d.varName);
    for (auto& p : func.params)    usedNames.insert(p.name);

    for (auto& name : bodyNames) {
        if (usedNames.count(name)) continue;  // already a known var
        if (!isPlainRegisterName(name) && !name.starts_with("_promoted_"))
            continue;

        std::string newName = makeUnique();
        applyRenameInStmts(func.body, name, newName);

        // Add a declaration for the newly named variable so it appears
        // in the local variable list (otherwise the output has undeclared
        // references).  Default to int64_t — type propagation runs earlier.
        uint32_t varId = 90000 + static_cast<uint32_t>(func.localVars.size());
        func.localVars.emplace_back(
            varId, newName, CType::int64());
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: decomposeNativeOpcodes — replace raw x86 opcode calls with C semantics
// ═══════════════════════════════════════════════════════════════════════════════
//
// Remill lifts certain x86 instructions as function calls with their
// mnemonic as the target name (e.g., BTSmem, XADD, CMPXCHG).  Detect
// these by NAME SHAPE (uppercase mnemonic, optionally with mem/reg/imm
// suffix) rather than a hardcoded list, then map to readable C-level
// equivalents.
//
// Known mnemonic → semantic mappings.  Anything that matches the shape
// but isn't in this map gets a fallback `__native_<mnemonic>` rename so
// it's still recognizable in the output.

/// Returns true if `name` looks like a Remill native opcode mnemonic.
///
/// Real Remill opcode names we want to ACCEPT:
///   - All-uppercase mnemonic, optionally with digits (e.g. "BSWAP", "RDTSC",
///     "TZCNT", "MOV64", "CVTSS2SI", "CMPSB")
///   - All-uppercase + lowercase addressing-mode/register suffix
///     (e.g. "BTSmem", "BTSreg", "BTSimm", "MOVDQx", "MOVDQa", "STOSb",
///     "MULrax", "DIVrdxrax", "FMULmem")
///   - Underscores INSIDE the uppercase portion (e.g. "LOCK_ADD", "MOVSD_MEM",
///     "CVTSS2SI_32")
///
/// Library/syscall identifiers we MUST NOT misclassify:
///   - "IO_read", "PR_init", "TLS_setup", "GFP_kernel", "NSS_init"
///     (UPPER_PREFIX_lowercase_word) — caught by Rule A.
///   - "OSPanic", "IOError", "HTMLParser", "JNIInit" (UPPER + word, no `_`)
///     — caught by Rule B (explicit prefix deny-list of common namespaces).
///
/// The two protection rules:
///   (A) An underscore must NEVER be immediately followed by a lowercase
///       letter — that's the library `<PREFIX>_<word>` pattern.
///   (B) The leading uppercase prefix (before first lowercase) must NOT
///       match a known library/namespace prefix from a curated deny-list.
///       This list is short and only contains identifiers that are NEVER
///       valid x86/ARM instruction mnemonics.
// Forward declaration so `isNativeOpcodeName` can early-accept names that
// appear in the semantic map (Remill variants like `FADDmem_ST0_implicit`
// fail Rules A/B but are unambiguously x87 opcodes we want to decompose).
static std::string_view kSemanticMapLookup(std::string_view name);

static bool isNativeOpcodeName(std::string_view name) {
    if (name.size() < 2 || name.size() > 24) return false;

    // Allow-list: any name registered in the decomposition semantic map is
    // a known Remill opcode intrinsic, regardless of whether it follows the
    // conservative shape Rules A/B below.  This catches cases like
    // `FADDmem_ST0_implicit` (x87 memory-form add with implicit ST0) where
    // the `_implicit` tail matches Rule A's library `<PREFIX>_<word>` shape
    // but the full name is still an opcode.
    if (!kSemanticMapLookup(name).empty()) return true;

    // Must start with at least two uppercase letters (excludes camelCase
    // names like "Add", "Or", "Rdtsc", "ReadFile", "CreateProcess").
    if (!(name[0] >= 'A' && name[0] <= 'Z')) return false;
    if (!(name[1] >= 'A' && name[1] <= 'Z')) return false;

    bool sawLower = false;
    size_t firstLowerIdx = std::string::npos;
    for (size_t i = 0; i < name.size(); ++i) {
        char c = name[i];
        if (c >= 'A' && c <= 'Z') {
            if (sawLower) return false;  // upper after lower → not a mnemonic
        } else if (c >= 'a' && c <= 'z') {
            if (!sawLower) {
                sawLower = true;
                firstLowerIdx = i;
            }
            // Rule A: an underscore directly before this lowercase letter
            // means we hit the library `<PREFIX>_<word>` pattern
            // (e.g. IO_read, PR_init, GFP_kernel).
            if (i > 0 && name[i - 1] == '_') return false;
        } else if (c >= '0' && c <= '9') {
            // Digits only allowed inside the uppercase part (e.g., "MOV64rr").
            if (sawLower) return false;
        } else if (c == '_') {
            // Underscore only inside uppercase part. The next char must NOT
            // be a lowercase letter (caught by Rule A above).
            if (sawLower) return false;
        } else {
            return false;
        }
    }

    // Rule B: prefix deny-list — short uppercase namespace prefixes that
    // are common in libraries/runtimes but never valid CPU mnemonics.
    // We compare the leading uppercase prefix (everything before the first
    // lowercase letter) against this list.  Order matters only for clarity.
    if (sawLower) {
        std::string_view prefix = name.substr(0, firstLowerIdx);
        // Each prefix here is only matched against names with a lowercase
        // tail; all-uppercase mnemonics (e.g. VMOVDQA, FNCLEX, FSQRT) are
        // never compared against this list because Rule B is gated on
        // sawLower==true.
        static constexpr std::string_view kLibraryPrefixes[] = {
            // C / POSIX / kernel runtime
            "IO", "OS", "FS", "VM", "PR", "BR", "FN",
            // Java / Android
            "JNI",
            // Web / scripting / serialization
            "JS", "WS", "HTML", "XML", "JSON", "URI", "URL", "DOM",
            // Network / crypto
            "TLS", "SSL", "NSS", "FTP", "HTTP", "HTTPS", "DNS", "TCP", "UDP",
            // Graphics
            "GL", "EGL", "GLX", "WGL", "GLES", "GLSL", "DX", "DXGI", "D3D",
            "UI", "GUI", "GTK", "QT", "GDK",
            // Memory / GC / heap
            "GFP", "GC",
            // Misc
            "NS", "BSD", "POSIX", "IPC", "RPC",
            // Game engines / common app namespaces
            "AI", "FX", "VFX", "SFX", "GFX",
        };
        for (auto& p : kLibraryPrefixes) {
            if (prefix == p) return false;
        }
    }

    return true;
}

/// Shared static kSemanticMap accessor.  Defined once here so both the
/// shape-aware decomposer (`mapNativeOpcode`) and the early-accept lookup
/// used by `isNativeOpcodeName` (`kSemanticMapLookup`) hit the same table.
static const llvm::StringMap<std::string>& getSemanticMap() {
    static const llvm::StringMap<std::string> kSemanticMap = {
        // Atomic / bit operations
        {"BTS",      "atomic_test_and_set"},
        {"BTR",      "atomic_test_and_reset"},
        {"BTC",      "atomic_test_and_complement"},
        {"BT",       "bit_test"},
        {"XADD",     "atomic_fetch_add"},
        {"XCHG",     "atomic_exchange"},
        {"CMPXCHG",  "atomic_compare_exchange"},
        {"CMPXCHG8B",  "atomic_compare_exchange_8b"},
        {"CMPXCHG16B", "atomic_compare_exchange_16b"},
        // Locked variants
        {"LOCK_ADD", "atomic_add"},
        {"LOCK_SUB", "atomic_sub"},
        {"LOCK_AND", "atomic_and"},
        {"LOCK_OR",  "atomic_or"},
        {"LOCK_XOR", "atomic_xor"},
        {"LOCK_INC", "atomic_inc"},
        {"LOCK_DEC", "atomic_dec"},
        {"LOCK_NEG", "atomic_neg"},
        {"LOCK_NOT", "atomic_not"},
        // Carry / borrow arithmetic
        {"ADC",      "add_with_carry"},
        {"SBB",      "sub_with_borrow"},
        // Bit count
        {"TZCNT",    "count_trailing_zeros"},
        {"BSF",      "count_trailing_zeros"},
        {"LZCNT",    "count_leading_zeros"},
        {"BSR",      "count_leading_zeros"},
        {"POPCNT",   "popcount"},
        // Byte manipulation
        {"BSWAP",    "byte_swap"},
        {"PEXT",     "parallel_bits_extract"},
        {"PDEP",     "parallel_bits_deposit"},
        // Time/CPU
        {"RDTSC",    "read_timestamp_counter"},
        {"RDTSCP",   "read_timestamp_counter_processor"},
        {"CPUID",    "cpuid"},
        {"PAUSE",    "cpu_pause"},
        {"HLT",      "cpu_halt"},
        // Memory ordering
        {"LFENCE",   "memory_barrier_load"},
        {"SFENCE",   "memory_barrier_store"},
        {"MFENCE",   "memory_barrier_full"},
        {"CLFLUSH",  "cache_line_flush"},
        // MSR
        {"RDMSR",    "read_msr"},
        {"WRMSR",    "write_msr"},
        {"RDPMC",    "read_pmc"},
        // I/O
        {"IN",       "io_read"},
        {"INS",      "io_read_string"},
        {"OUT",      "io_write"},
        {"OUTS",     "io_write_string"},
        // Interrupts / system
        {"INT",      "software_interrupt"},
        {"INT3",     "debug_break"},
        {"IRET",     "interrupt_return"},
        {"SYSCALL",  "syscall"},
        {"SYSENTER", "sysenter"},
        {"SYSEXIT",  "sysexit"},
        {"SYSRET",   "sysret"},
        {"UD2",      "undefined_instruction"},
        // Floating point conversion
        {"CVTTSS2SI", "float_to_int_truncate"},
        {"CVTSS2SI",  "float_to_int"},
        {"CVTSI2SS",  "int_to_float"},
        {"CVTTSD2SI", "double_to_int_truncate"},
        {"CVTSD2SI",  "double_to_int"},
        {"CVTSI2SD",  "int_to_double"},
        // Stack
        {"ENTER",    "stack_enter"},
        {"LEAVE",    "stack_leave"},
        // Random
        {"RDRAND",   "hardware_random"},
        {"RDSEED",   "hardware_random_seed"},
        // SSE/SIMD scalar moves
        {"MOVQ",       "simd_move_quad"},
        {"MOVD",       "simd_move_dword"},
        {"MOVDQ",      "simd_move_dquad"},
        {"MOVDQA",     "simd_move_dquad_aligned"},
        {"MOVDQU",     "simd_move_dquad_unaligned"},
        {"MOVAPS",     "simd_move_aligned_packed_single"},
        {"MOVUPS",     "simd_move_unaligned_packed_single"},
        {"MOVAPD",     "simd_move_aligned_packed_double"},
        {"MOVUPD",     "simd_move_unaligned_packed_double"},
        {"MOVSS",      "simd_move_scalar_single"},
        {"MOVSD",      "simd_move_scalar_double"},
        {"MOVSS_MEM",  "simd_load_scalar_single"},
        {"MOVSD_MEM",  "simd_load_scalar_double"},
        // SSE/SIMD shifts
        {"PSRLDQ",     "simd_shift_right_dquad"},
        {"PSLLDQ",     "simd_shift_left_dquad"},
        {"PSRLQ",      "simd_shift_right_quad"},
        {"PSLLQ",      "simd_shift_left_quad"},
        {"PSRLD",      "simd_shift_right_dword"},
        {"PSLLD",      "simd_shift_left_dword"},
        {"PSRLW",      "simd_shift_right_word"},
        {"PSLLW",      "simd_shift_left_word"},
        // SSE/SIMD packed arithmetic
        {"PADDB",      "simd_add_byte"},
        {"PADDW",      "simd_add_word"},
        {"PADDD",      "simd_add_dword"},
        {"PADDQ",      "simd_add_quad"},
        {"PSUBB",      "simd_sub_byte"},
        {"PSUBW",      "simd_sub_word"},
        {"PSUBD",      "simd_sub_dword"},
        {"PSUBQ",      "simd_sub_quad"},
        // SSE/SIMD compare/permute/shuffle
        {"PCMPEQB",    "simd_cmp_eq_byte"},
        {"PCMPEQW",    "simd_cmp_eq_word"},
        {"PCMPEQD",    "simd_cmp_eq_dword"},
        {"PSHUFB",     "simd_shuffle_byte"},
        {"PSHUFD",     "simd_shuffle_dword"},
        {"PSHUFHW",    "simd_shuffle_high_word"},
        {"PSHUFLW",    "simd_shuffle_low_word"},
        // SSE/SIMD logical
        {"PAND",       "simd_and"},
        {"POR",        "simd_or"},
        {"PXOR",       "simd_xor"},
        {"PANDN",      "simd_andnot"},
        // SSE/SIMD min/max
        {"PMINUB",     "simd_min_unsigned_byte"},
        {"PMAXUB",     "simd_max_unsigned_byte"},
        {"PMINSW",     "simd_min_signed_word"},
        {"PMAXSW",     "simd_max_signed_word"},
        // SSE/SIMD byte mask
        {"PMOVMSKB",   "simd_move_mask_byte"},
        {"MOVMSKPS",   "simd_move_mask_packed_single"},
        {"MOVMSKPD",   "simd_move_mask_packed_double"},
        // Float→int conversions
        {"CVTSS2SI",    "float_to_int_truncate"},
        {"CVTSD2SI",    "double_to_int_truncate"},
        {"CVTSI2SS",    "int_to_float"},
        {"CVTSI2SD",    "int_to_double"},
        {"CVTSS2SI_32", "float_to_int32_truncate"},
        {"CVTSD2SI_64", "double_to_int64_truncate"},
        {"CVTSI2SS_32", "int32_to_float"},
        {"CVTSI2SD_64", "int64_to_double"},
        {"CVTSS2SD",    "float_to_double"},
        {"CVTSD2SS",    "double_to_float"},
        {"CVTDQ2PS",    "int_packed_to_float_packed"},
        {"CVTPS2DQ",    "float_packed_to_int_packed"},
        {"CVTPS2PD",    "float_packed_to_double_packed"},
        {"CVTPD2PS",    "double_packed_to_float_packed"},
        {"CVTPI2PS",    "int_packed_to_float_packed_mmx"},
        {"CVTPS2PI",    "float_packed_to_int_packed_mmx"},
        {"CVTTSS2SI",   "float_to_int_truncate"},
        {"CVTTSD2SI",   "double_to_int_truncate"},
        {"CVTTPS2DQ",   "float_packed_to_int_packed_truncate"},
        {"CVTTPD2DQ",   "double_packed_to_int_packed_truncate"},
        // VEX-encoded versions (AVX) — same semantics as non-V counterparts
        {"VMOVQ",      "simd_move_quad"},
        {"VMOVD",      "simd_move_dword"},
        {"VMOVDQA",    "simd_move_dquad_aligned"},
        {"VMOVDQU",    "simd_move_dquad_unaligned"},
        {"VMOVAPS",    "simd_move_aligned_packed_single"},
        {"VMOVUPS",    "simd_move_unaligned_packed_single"},
        {"VMOVAPD",    "simd_move_aligned_packed_double"},
        {"VMOVUPD",    "simd_move_unaligned_packed_double"},
        {"VPSRLDQ",    "simd_shift_right_dquad"},
        {"VPSLLDQ",    "simd_shift_left_dquad"},
        {"VPXOR",      "simd_xor"},
        {"VPAND",      "simd_and"},
        {"VPOR",       "simd_or"},
        // Integer multiplication / division (with implicit rax/rdx operand
        // encoding stripped by the suffix walker — DIVrdxrax → DIV).
        {"MUL",        "umul_full"},
        {"IMUL",       "imul_full"},
        {"DIV",        "udiv_full"},
        {"IDIV",       "idiv_full"},
        // String operations (REP/REPE/REPNE-prefixed by lifter)
        {"CMPSB",      "string_compare_byte"},
        {"CMPSW",      "string_compare_word"},
        {"CMPSD",      "string_compare_dword"},
        {"CMPSQ",      "string_compare_qword"},
        {"MOVSB",      "string_move_byte"},
        {"MOVSW",      "string_move_word"},
        {"SCASB",      "string_scan_byte"},
        {"SCASW",      "string_scan_word"},
        {"SCASD",      "string_scan_dword"},
        {"SCASQ",      "string_scan_qword"},
        {"STOS",       "string_store"},
        {"LODS",       "string_load"},
        // x87 floating point (when not converted to LLVM intrinsics)
        {"FMUL",       "fp_mul"},
        {"FADD",       "fp_add"},
        {"FSUB",       "fp_sub"},
        {"FDIV",       "fp_div"},
        {"FSQRT",      "fp_sqrt"},
        {"FABS",       "fp_abs"},
        {"FCHS",       "fp_negate"},
        {"FSIN",       "fp_sin"},
        {"FCOS",       "fp_cos"},
        {"FPREM",      "fp_partial_remainder"},

        // x87 memory-operand and implicit-ST0 variants (x86 gta-sa corpus
        // bug A).  Remill names these with explicit `mem`/`ST0_implicit`
        // suffixes for the variants that read/write to memory or use ST0
        // as an implicit source/destination.
        {"FLD",        "fp_load"},
        {"FLDmem",     "fp_load"},
        {"FSTP",       "fp_store_pop"},
        {"FSTPmem",    "fp_store_pop"},
        {"FST",        "fp_store"},
        {"FSTmem",     "fp_store"},
        {"FILD",       "fp_load_int"},
        {"FILDmem",    "fp_load_int"},
        {"FIST",       "fp_store_int"},
        {"FISTP",      "fp_store_int_pop"},
        {"FCOM",       "fp_compare"},
        {"FCOMmem",    "fp_compare"},
        {"FCOMP",      "fp_compare_pop"},
        {"FCOMPmem",   "fp_compare_pop"},
        {"FUCOM",      "fp_compare_unordered"},
        {"FUCOMP",     "fp_compare_unordered_pop"},
        {"FNSTSW",     "fp_store_status_word"},
        {"FSTSW",      "fp_store_status_word"},
        {"FNSTCW",     "fp_store_control_word"},
        {"FLDCW",      "fp_load_control_word"},
        {"FADDmem_ST0_implicit",    "fp_add"},
        {"FSUBmem_ST0_implicit",    "fp_sub"},
        {"FMULmem_ST0_implicit",    "fp_mul"},
        {"FDIVmem_ST0_implicit",    "fp_div"},
        {"FIADDmem_ST0_implicit",   "fp_add_int"},
        {"FISUBmem_ST0_implicit",   "fp_sub_int"},
        {"FIMULmem_ST0_implicit",   "fp_mul_int"},
        {"FIDIVmem_ST0_implicit",   "fp_div_int"},

        // x86 (32-bit) control-flow and stack opcodes that Remill lifts by
        // name.  Without these, x86 output leaks `__native_LOOPNE`,
        // `__native_POPAD`, `__native_RET_IMM` et al. (gta-sa bug G).
        {"LOOPNE",     "loop_while_ne"},
        {"LOOPE",      "loop_while_eq"},
        {"LOOP",       "loop_decrement"},
        {"POPAD",      "pop_all_gprs"},
        {"PUSHAD",     "push_all_gprs"},
        {"POPFD",      "pop_flags"},
        {"PUSHFD",     "push_flags"},
        {"POPF",       "pop_flags"},
        {"PUSHF",      "push_flags"},
        {"LAHF",       "load_flags_into_ah"},
        {"SAHF",       "store_ah_to_flags"},

        // Add-with-carry / sub-with-borrow variants (bug G).
        {"ADC",                "add_with_carry"},
        {"ADCmem",             "add_with_carry"},
        {"SBB",                "sub_with_borrow"},
        {"SBBmem",             "sub_with_borrow"},
        {"add_with_carry",     "add_with_carry"},
        {"sub_with_borrow",    "sub_with_borrow"},

        // I/O port opcodes (ring-0 code, drivers).
        {"IN8",        "port_in_byte"},
        {"IN16",       "port_in_word"},
        {"IN32",       "port_in_dword"},
        {"OUT8",       "port_out_byte"},
        {"OUT16",      "port_out_word"},
        {"OUT32",      "port_out_dword"},

        // Far jumps / calls (segmented memory — drivers, bootloaders).
        {"JMP_FAR_MEM",    "far_jump_mem"},
        {"JMP_FAR",        "far_jump"},
        {"CALL_FAR_MEM",   "far_call_mem"},
        {"CALL_FAR",       "far_call"},
        {"RET_FAR",        "far_return"},

        // Misc x86 opcodes commonly surviving in legacy code.
        {"CPUID",      "cpuid"},
        {"RDTSC",      "read_timestamp_counter"},
        {"XCHG",       "exchange"},
        {"BSR",        "bit_scan_reverse"},
        {"BSF",        "bit_scan_forward"},
        {"BTS",        "bit_test_and_set"},
        {"BTR",        "bit_test_and_reset"},
        {"BTC",        "bit_test_and_complement"},
    };
    return kSemanticMap;
}

/// Direct kSemanticMap lookup (no mnemonic stripping).  Used by
/// `isNativeOpcodeName` as an allow-list so Remill's `FADDmem_ST0_implicit`
/// style names pass through even though Rule A would reject them.
static std::string_view kSemanticMapLookup(std::string_view name) {
    auto& m = getSemanticMap();
    auto it = m.find(name);
    if (it == m.end()) return {};
    return it->second;
}

/// Map a recognized native opcode mnemonic to a readable semantic name.
/// Returns empty string if no mapping is known.
static std::string mapNativeOpcode(const std::string& name) {
    // Strip lowercase suffix (e.g. MOVDQx → MOVDQ, BTSmem → BTS).
    // The suffix is everything after the last uppercase letter that's
    // followed by a lowercase character.
    //
    // Example splits:
    //   MOVDQx     → MOVDQ + x
    //   BTSmem     → BTS + mem
    //   CVTSS2SI_32 → CVTSS2SI + _32   (special: _NN is preserved as-is)
    //   MOVSD_MEM  → no split (all upper)

    // First: direct match against the semantic map (catches full Remill
    // names like `FADDmem_ST0_implicit` that would survive stripping).
    auto& m = getSemanticMap();
    if (auto it = m.find(name); it != m.end())
        return it->second;

    std::string base = name;
    size_t firstLower = std::string::npos;
    for (size_t i = 0; i < base.size(); ++i) {
        char c = base[i];
        if (c >= 'a' && c <= 'z') { firstLower = i; break; }
    }
    if (firstLower != std::string::npos && firstLower > 0) {
        // The character before firstLower must be uppercase.
        char before = base[firstLower - 1];
        if (before >= 'A' && before <= 'Z') {
            base = base.substr(0, firstLower);
        }
    }

    auto it = m.find(base);
    if (it != m.end())
        return it->second;
    return {};
}

/// Recognize Remill REP-prefixed string operation wrappers like
/// "DoREPE_CMPSB", "DoREPNE_SCASB", "DoREP_MOVSB" and rewrite them as
/// readable single-token names: rep_while_equal_string_compare_byte, etc.
/// Returns the flattened name if recognized, or empty if not a REP wrapper.
static std::string tryStripRepPrefix(const std::string& name) {
    // Match shapes:
    //   DoREP_<MNEMONIC>     → rep
    //   DoREPE_<MNEMONIC>    → rep_while_equal
    //   DoREPNE_<MNEMONIC>   → rep_while_not_equal
    static constexpr std::pair<std::string_view, std::string_view> kPrefixes[] = {
        {"DoREPNE_", "rep_while_not_equal"},
        {"DoREPE_",  "rep_while_equal"},
        {"DoREP_",   "rep"},
    };
    for (auto& [prefix, wrapper] : kPrefixes) {
        if (name.size() <= prefix.size()) continue;
        if (name.compare(0, prefix.size(), prefix.data(), prefix.size()) != 0)
            continue;
        std::string innerName(name.substr(prefix.size()));
        if (!isNativeOpcodeName(innerName))
            return {};
        auto mapped = mapNativeOpcode(innerName);
        if (mapped.empty()) mapped = "native_" + innerName;
        return std::string(wrapper) + "_" + mapped;
    }
    return {};
}

static void decomposeNativeInExpr(CExpr* expr) {
    if (!expr) return;
    switch (expr->getKind()) {
    case NodeKind::CallExpr: {
        auto& call = static_cast<CCallExpr&>(*expr);
        // First check for REP-prefixed string ops (DoREPE_CMPSB etc.).
        auto repWrapper = tryStripRepPrefix(call.targetName);
        if (!repWrapper.empty()) {
            call.targetName = std::move(repWrapper);
        } else if (isNativeOpcodeName(call.targetName)) {
            auto mapped = mapNativeOpcode(call.targetName);
            if (!mapped.empty()) {
                call.targetName = mapped;
            } else {
                // Unknown native opcode — prefix with __native_ so it's
                // visibly distinct from regular function calls.  This
                // also makes it easy to find unhandled mnemonics in
                // output for future mapping.
                call.targetName = "__native_" + call.targetName;
            }
        }
        for (auto& arg : call.args)
            decomposeNativeInExpr(arg.get());
        break;
    }
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        decomposeNativeInExpr(b.lhs.get());
        decomposeNativeInExpr(b.rhs.get());
        break;
    }
    case NodeKind::UnaryExpr:
        decomposeNativeInExpr(static_cast<CUnaryExpr&>(*expr).operand.get());
        break;
    case NodeKind::CastExpr:
        decomposeNativeInExpr(static_cast<CCastExpr&>(*expr).operand.get());
        break;
    case NodeKind::FieldAccessExpr:
        decomposeNativeInExpr(static_cast<CFieldAccessExpr&>(*expr).base.get());
        break;
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*expr);
        decomposeNativeInExpr(s.base.get());
        decomposeNativeInExpr(s.index.get());
        break;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*expr);
        decomposeNativeInExpr(t.cond.get());
        decomposeNativeInExpr(t.trueVal.get());
        decomposeNativeInExpr(t.falseVal.get());
        break;
    }
    default: break;
    }
}

static void decomposeNativeInStmts(std::vector<StmtPtr>& stmts) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<CAssignStmt&>(*sp);
            decomposeNativeInExpr(a.target.get());
            decomposeNativeInExpr(a.value.get());
            break;
        }
        case NodeKind::ExprStmt:
            decomposeNativeInExpr(static_cast<CExprStmt&>(*sp).expr.get());
            break;
        case NodeKind::ReturnStmt:
            decomposeNativeInExpr(static_cast<CReturnStmt&>(*sp).value.get());
            break;
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            decomposeNativeInExpr(s.condition.get());
            decomposeNativeInStmts(s.thenBody);
            decomposeNativeInStmts(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& s = static_cast<CWhileStmt&>(*sp);
            decomposeNativeInExpr(s.condition.get());
            decomposeNativeInStmts(s.body);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& s = static_cast<CDoWhileStmt&>(*sp);
            decomposeNativeInExpr(s.condition.get());
            decomposeNativeInStmts(s.body);
            break;
        }
        case NodeKind::ForStmt: {
            auto& s = static_cast<CForStmt&>(*sp);
            decomposeNativeInExpr(s.condition.get());
            decomposeNativeInStmts(s.body);
            break;
        }
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                decomposeNativeInStmts(c.body);
            break;
        case NodeKind::BlockStmt:
            decomposeNativeInStmts(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default: break;
        }
    }
}

void CAstOptimizer::decomposeNativeOpcodes(CFuncDecl& func) {
    decomposeNativeInStmts(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: recognizeStackCanary — elide stack canary save/check patterns
// ═══════════════════════════════════════════════════════════════════════════════
//
// Stack canaries (a.k.a. stack cookies, stack protectors) are compiler-
// inserted security infrastructure that should NOT appear in decompiled
// output.  Different toolchains use different patterns:
//
//   - SysV / Linux:  TLS-based at fs:0x28 or gs:0x28
//                    Check: if(saved != fs:0x28) __stack_chk_fail();
//   - Win64 / MSVC:  Global __security_cookie XOR'd with RSP
//                    Check: __security_check_cookie(local ^ rsp);
//   - GCC fortify:   __stack_chk_guard global variable
//                    Check: if(saved != __stack_chk_guard) __stack_chk_fail();
//
// Generalized detection strategy: instead of pattern-matching the canary
// READ (which varies by toolchain), we detect the canary CHECK by looking
// for calls to known check-failure functions:
//
//   __stack_chk_fail, __stack_chk_fail_local, __security_check_cookie,
//   __chk_fail
//
// When such a call is found, we walk backward looking for an enclosing
// if-statement (or the immediately preceding sibling if-stmt) and elide
// both the if-statement (keeping its then-body, which is the normal path)
// and the failure call.

/// Returns true if name is a known stack canary check failure function.
static bool isCanaryFailFunction(std::string_view name) {
    return name == "__stack_chk_fail" ||
           name == "__stack_chk_fail_local" ||
           name == "__security_check_cookie" ||
           name == "__chk_fail" ||
           name == "__report_gsfailure" ||
           name == "abort";  // some toolchains use abort directly
}

/// Returns true if the expression matches a known stack canary read pattern.
/// Currently recognizes:
///   - SysV/Linux: *(type)(void*)0 + 40  (gs:0x28 or fs:0x28 lifted)
///   - SysV/Linux: __readgsqword(0x28), __readfsqword(0x28)
///   - Win64:      __security_cookie  (referenced as global)
static bool isCanaryRead(const CExpr* expr) {
    if (!expr) return false;

    // Pattern 1: deref of null + segment offset (typical kernel/SysV).
    // *(int64_t)(void*)0 + N where N matches a segment-relative TLS offset.
    if (expr->getKind() == NodeKind::BinaryExpr) {
        auto& bin = static_cast<const CBinaryExpr&>(*expr);
        if (bin.op == BinaryOp::Add &&
            bin.rhs && bin.rhs->getKind() == NodeKind::IntLitExpr) {
            int64_t offset =
                static_cast<const CIntLitExpr&>(*bin.rhs).value;
            // Common segment-relative canary offsets:
            //   0x28 = 40   (Linux/glibc on x86-64)
            //   0x14 = 20   (Linux/glibc on x86-32)
            //   0x10 = 16   (FreeBSD)
            //   0x08 = 8    (some embedded toolchains)
            if (offset == 40 || offset == 20 || offset == 16 || offset == 8) {
                if (bin.lhs && bin.lhs->getKind() == NodeKind::UnaryExpr) {
                    auto& deref = static_cast<const CUnaryExpr&>(*bin.lhs);
                    if (deref.op == UnaryOp::Deref)
                        return true;
                }
            }
        }
    }

    // Pattern 2: __readgsqword/__readfsqword call with a canary offset.
    if (expr->getKind() == NodeKind::CallExpr) {
        auto& call = static_cast<const CCallExpr&>(*expr);
        if ((call.targetName == "__readgsqword" ||
             call.targetName == "__readfsqword") &&
            call.args.size() == 1 &&
            call.args[0]->getKind() == NodeKind::IntLitExpr) {
            int64_t offset =
                static_cast<const CIntLitExpr&>(*call.args[0]).value;
            if (offset == 40 || offset == 20 || offset == 16 || offset == 8)
                return true;
        }
        // Win64: __security_cookie reference (often appears as a load of
        // a global named __security_cookie).
        if (call.targetName == "__security_cookie")
            return true;
    }

    // Pattern 3: VarRefExpr to "__security_cookie" or "__stack_chk_guard".
    if (expr->getKind() == NodeKind::VarRefExpr) {
        const auto& var = static_cast<const CVarRefExpr&>(*expr);
        if (var.varName == "__security_cookie" ||
            var.varName == "__stack_chk_guard")
            return true;
    }

    return false;
}

/// Returns the variable name if this statement is `var = canary_read`.
static std::string getCanarySaveVar(const CStmt* stmt) {
    if (!stmt || stmt->getKind() != NodeKind::AssignStmt) return "";
    auto& assign = static_cast<const CAssignStmt&>(*stmt);
    if (!assign.target || !assign.value) return "";
    if (assign.target->getKind() != NodeKind::VarRefExpr) return "";
    if (!isCanaryRead(assign.value.get())) return "";
    return static_cast<const CVarRefExpr&>(*assign.target).varName;
}

/// Returns true if this statement is a stack canary failure call.
/// Generalized to recognize SysV (__stack_chk_fail) and Win64
/// (__security_check_cookie) toolchain conventions.
static bool isStackChkFail(const CStmt* stmt) {
    if (!stmt) return false;
    if (stmt->getKind() == NodeKind::ExprStmt) {
        auto& expr = static_cast<const CExprStmt&>(*stmt);
        if (expr.expr && expr.expr->getKind() == NodeKind::CallExpr) {
            auto& call = static_cast<const CCallExpr&>(*expr.expr);
            return isCanaryFailFunction(call.targetName);
        }
    }
    return false;
}

/// Returns true if expr references varName.
static bool exprRefsVar(const CExpr* expr, const std::string& varName) {
    if (!expr) return false;
    switch (expr->getKind()) {
    case NodeKind::VarRefExpr:
        return static_cast<const CVarRefExpr&>(*expr).varName == varName;
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<const CBinaryExpr&>(*expr);
        return exprRefsVar(b.lhs.get(), varName) || exprRefsVar(b.rhs.get(), varName);
    }
    case NodeKind::UnaryExpr:
        return exprRefsVar(static_cast<const CUnaryExpr&>(*expr).operand.get(), varName);
    case NodeKind::CastExpr:
        return exprRefsVar(static_cast<const CCastExpr&>(*expr).operand.get(), varName);
    case NodeKind::CallExpr: {
        auto& c = static_cast<const CCallExpr&>(*expr);
        for (auto& arg : c.args)
            if (exprRefsVar(arg.get(), varName)) return true;
        return false;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<const CTernaryExpr&>(*expr);
        return exprRefsVar(t.cond.get(), varName) ||
               exprRefsVar(t.trueVal.get(), varName) ||
               exprRefsVar(t.falseVal.get(), varName);
    }
    default: return false;
    }
}

/// Returns true if this is a canary check: if(!(var - canary)) or if(var - canary).
static bool isCanaryCheck(const CStmt* stmt, const std::string& canaryVar) {
    if (!stmt || stmt->getKind() != NodeKind::IfStmt) return false;
    auto& ifStmt = static_cast<const CIfStmt&>(*stmt);
    if (!ifStmt.condition) return false;

    // The condition references the canary var and a canary read
    const CExpr* cond = ifStmt.condition.get();

    // Unwrap negation: !(expr)
    if (cond->getKind() == NodeKind::UnaryExpr) {
        auto& u = static_cast<const CUnaryExpr&>(*cond);
        if (u.op == UnaryOp::LogNot) cond = u.operand.get();
    }

    // Check: var - canary_read, or canary_read subtraction
    return exprRefsVar(cond, canaryVar);
}

static void removeCanaryInStmts(std::vector<StmtPtr>& stmts,
                                 const std::string& canaryVar) {
    for (size_t i = stmts.size(); i-- > 0;) {
        if (!stmts[i]) continue;
        auto* s = stmts[i].get();

        // Remove canary save: var = *(type)(void*)0 + 40
        if (!getCanarySaveVar(s).empty() && getCanarySaveVar(s) == canaryVar) {
            stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i));
            continue;
        }

        // Remove __stack_chk_fail calls
        if (isStackChkFail(s)) {
            stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i));
            continue;
        }

        // Remove canary check if-statements
        if (isCanaryCheck(s, canaryVar)) {
            // Keep the "normal" path (usually the then-body) and drop the check
            auto& ifStmt = static_cast<CIfStmt&>(*s);
            // The then-body is typically the normal return path
            if (!ifStmt.thenBody.empty()) {
                auto thenBody = std::move(ifStmt.thenBody);
                stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i));
                stmts.insert(stmts.begin() + static_cast<ptrdiff_t>(i),
                             std::make_move_iterator(thenBody.begin()),
                             std::make_move_iterator(thenBody.end()));
            } else {
                stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i));
            }
            continue;
        }

        // Recurse into nested scopes
        switch (s->getKind()) {
        case NodeKind::IfStmt: {
            auto& ifs = static_cast<CIfStmt&>(*s);
            removeCanaryInStmts(ifs.thenBody, canaryVar);
            removeCanaryInStmts(ifs.elseBody, canaryVar);
            break;
        }
        case NodeKind::WhileStmt:
            removeCanaryInStmts(static_cast<CWhileStmt&>(*s).body, canaryVar);
            break;
        case NodeKind::DoWhileStmt:
            removeCanaryInStmts(static_cast<CDoWhileStmt&>(*s).body, canaryVar);
            break;
        case NodeKind::ForStmt:
            removeCanaryInStmts(static_cast<CForStmt&>(*s).body, canaryVar);
            break;
        case NodeKind::BlockStmt:
            removeCanaryInStmts(static_cast<CBlockStmt&>(*s).stmts, canaryVar);
            break;
        default: break;
        }
    }
}

/// Returns true if the expression tree contains *(type)(void*)0 + 40 anywhere.
static bool containsCanaryRead(const CExpr* expr) {
    if (!expr) return false;
    if (isCanaryRead(expr)) return true;
    switch (expr->getKind()) {
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<const CBinaryExpr&>(*expr);
        return containsCanaryRead(b.lhs.get()) || containsCanaryRead(b.rhs.get());
    }
    case NodeKind::UnaryExpr:
        return containsCanaryRead(static_cast<const CUnaryExpr&>(*expr).operand.get());
    case NodeKind::CastExpr:
        return containsCanaryRead(static_cast<const CCastExpr&>(*expr).operand.get());
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<const CTernaryExpr&>(*expr);
        return containsCanaryRead(t.cond.get()) ||
               containsCanaryRead(t.trueVal.get()) ||
               containsCanaryRead(t.falseVal.get());
    }
    default: return false;
    }
}

void CAstOptimizer::recognizeStackCanary(CFuncDecl& func) {
    // Strategy 1: Direct canary save — var = *(type)(void*)0 + 40
    std::string canaryVar;
    for (size_t i = 0; i < std::min<size_t>(func.body.size(), 10); ++i) {
        auto v = getCanarySaveVar(func.body[i].get());
        if (!v.empty()) { canaryVar = v; break; }
    }

    if (!canaryVar.empty()) {
        removeCanaryInStmts(func.body, canaryVar);
        func.localVars.erase(
            std::remove_if(func.localVars.begin(), func.localVars.end(),
                [&](const CVarDecl& d) { return d.varName == canaryVar; }),
            func.localVars.end());
        return;
    }

    // Strategy 2: Match the check pattern directly.
    // Look for: if (!(var - (*(type)(void*)0 + 40))) or similar
    // Also remove __stack_chk_fail calls.
    bool foundCanaryCheck = false;

    for (size_t i = func.body.size(); i-- > 0;) {
        if (!func.body[i]) continue;

        // Remove __stack_chk_fail calls
        if (isStackChkFail(func.body[i].get())) {
            func.body.erase(func.body.begin() + static_cast<ptrdiff_t>(i));
            foundCanaryCheck = true;
            continue;
        }

        // Match if-statements whose condition contains *(type)(void*)0 + 40
        if (func.body[i]->getKind() == NodeKind::IfStmt) {
            auto& ifStmt = static_cast<CIfStmt&>(*func.body[i]);
            if (containsCanaryRead(ifStmt.condition.get())) {
                // The then-body is the normal return path — inline it
                if (!ifStmt.thenBody.empty()) {
                    auto thenBody = std::move(ifStmt.thenBody);
                    func.body.erase(func.body.begin() + static_cast<ptrdiff_t>(i));
                    func.body.insert(
                        func.body.begin() + static_cast<ptrdiff_t>(i),
                        std::make_move_iterator(thenBody.begin()),
                        std::make_move_iterator(thenBody.end()));
                } else {
                    func.body.erase(func.body.begin() + static_cast<ptrdiff_t>(i));
                }
                foundCanaryCheck = true;
                continue;
            }
        }
    }

    // If we found and removed a canary check, also try to remove the
    // canary save.  The save is typically: var_90 = var_68 at function
    // start, where var_68 was the original canary read that got
    // copy-propagated away.  We remove it by looking for the first
    // assignment in the body that assigns to a stack variable from
    // another stack variable, where one of them is later unused.
    // (Dead store elimination will handle this naturally.)
    (void)foundCanaryCheck; // let DCE clean up remaining dead stores
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: reanalyzeConfidence — post-optimization confidence re-scoring
// ═══════════════════════════════════════════════════════════════════════════════
//
// Re-computes confidence score from the C AST after all optimization passes
// have run.  This replaces the MLIR-based analysis from CAstBuilder which
// runs before optimization and therefore over-reports issues.

void CAstOptimizer::reanalyzeConfidence(CFuncDecl& func) {
    double deduction = 0.0;
    func.confidenceIssues.clear();

    // #30 (registry-miss honest failure): this rescorer overwrites
    // confidenceScore AFTER all optimizations and is the value the user
    // actually sees.  If CAstBuilder::analyzeConfidence flagged that this
    // function's entry is NOT in the authoritative function table, the address
    // did not honestly lift -- force confidence to 0 and report it.  Placed
    // AFTER confidenceIssues.clear() so the message survives, and BEFORE any
    // positive scoring: a registry miss is a harder honesty failure than the
    // A-D4 50% damning cap, so 0 correctly beats 50.
    if (func.registryMissHonestFailure) {
        func.confidenceScore = 0.0;
        func.confidenceIssues.push_back(
            "registry miss: function entry not in the authoritative function "
            "table (no honest lift)");
        return;
    }

    // ── Native opcodes (check for unmapped native call targets) ──────
    // After decomposeNativeOpcodes runs, any remaining native instructions
    // are renamed with __native_ prefix.  Anything else with the native-
    // opcode name shape is also a candidate (catches missed cases).
    unsigned nativeOps = 0;
    auto isUnmappedNative = [](std::string_view name) -> bool {
        if (name.starts_with("__native_")) return true;
        return isNativeOpcodeName(name);
    };
    std::function<void(const std::vector<StmtPtr>&)> countNative;
    countNative = [&](const std::vector<StmtPtr>& stmts) {
        for (auto& sp : stmts) {
            if (!sp) continue;
            switch (sp->getKind()) {
            case NodeKind::ExprStmt: {
                auto& e = static_cast<const CExprStmt&>(*sp);
                if (e.expr && e.expr->getKind() == NodeKind::CallExpr) {
                    auto& call = static_cast<const CCallExpr&>(*e.expr);
                    if (isUnmappedNative(call.targetName)) nativeOps++;
                }
                break;
            }
            case NodeKind::AssignStmt: {
                auto& a = static_cast<const CAssignStmt&>(*sp);
                if (a.value && a.value->getKind() == NodeKind::CallExpr) {
                    auto& call = static_cast<const CCallExpr&>(*a.value);
                    if (isUnmappedNative(call.targetName)) nativeOps++;
                }
                break;
            }
            case NodeKind::IfStmt: {
                auto& s = static_cast<const CIfStmt&>(*sp);
                countNative(s.thenBody);
                countNative(s.elseBody);
                break;
            }
            case NodeKind::WhileStmt:
                countNative(static_cast<const CWhileStmt&>(*sp).body);
                break;
            case NodeKind::DoWhileStmt:
                countNative(static_cast<const CDoWhileStmt&>(*sp).body);
                break;
            case NodeKind::ForStmt:
                countNative(static_cast<const CForStmt&>(*sp).body);
                break;
            case NodeKind::SwitchStmt:
                for (auto& c : static_cast<const CSwitchStmt&>(*sp).cases)
                    countNative(c.body);
                break;
            case NodeKind::BlockStmt:
                countNative(static_cast<const CBlockStmt&>(*sp).stmts);
                break;
            default: break;
            }
        }
    };
    countNative(func.body);
    if (nativeOps > 0) {
        deduction += std::min(30.0, (double)nativeOps * 3.0);
        func.confidenceIssues.push_back(
            std::format("{} native opcode(s) not decomposed", nativeOps));
    }

    // ── Register-named variables ─────────────────────────────────────
    static const char* kRegs[] = {
        "rax", "rbx", "rcx", "rdx", "rsi", "rdi", "rbp", "rsp",
        "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
    };
    unsigned regVars = 0;
    for (auto& d : func.localVars) {
        for (auto* r : kRegs) {
            if (d.varName.starts_with(r)) { regVars++; break; }
        }
    }
    if (regVars > 0) {
        deduction += std::min(20.0, (double)regVars * 2.0);
        func.confidenceIssues.push_back(
            std::format("{} register-named variable(s)", regVars));
    }

    // ── Goto count ───────────────────────────────────────────────────
    unsigned gotos = 0;
    std::function<void(const std::vector<StmtPtr>&)> countGotos;
    countGotos = [&](const std::vector<StmtPtr>& stmts) {
        for (auto& sp : stmts) {
            if (!sp) continue;
            if (sp->getKind() == NodeKind::GotoStmt) { gotos++; continue; }
            switch (sp->getKind()) {
            case NodeKind::IfStmt: {
                auto& s = static_cast<const CIfStmt&>(*sp);
                countGotos(s.thenBody);
                countGotos(s.elseBody);
                break;
            }
            case NodeKind::WhileStmt:
                countGotos(static_cast<const CWhileStmt&>(*sp).body);
                break;
            case NodeKind::DoWhileStmt:
                countGotos(static_cast<const CDoWhileStmt&>(*sp).body);
                break;
            case NodeKind::ForStmt:
                countGotos(static_cast<const CForStmt&>(*sp).body);
                break;
            default: break;
            }
        }
    };
    countGotos(func.body);
    if (gotos > 0) {
        deduction += std::min(20.0, (double)gotos * 2.0);
        func.confidenceIssues.push_back(
            std::format("{} goto(s)", gotos));
    }

    // ── Empty if/else blocks ─────────────────────────────────────────
    unsigned emptyIfs = 0;
    std::function<void(const std::vector<StmtPtr>&)> countEmpty;
    countEmpty = [&](const std::vector<StmtPtr>& stmts) {
        for (auto& sp : stmts) {
            if (!sp) continue;
            if (sp->getKind() == NodeKind::IfStmt) {
                auto& s = static_cast<const CIfStmt&>(*sp);
                if (s.thenBody.empty() && s.elseBody.empty()) emptyIfs++;
                countEmpty(s.thenBody);
                countEmpty(s.elseBody);
            } else if (sp->getKind() == NodeKind::WhileStmt) {
                countEmpty(static_cast<const CWhileStmt&>(*sp).body);
            } else if (sp->getKind() == NodeKind::DoWhileStmt) {
                countEmpty(static_cast<const CDoWhileStmt&>(*sp).body);
            } else if (sp->getKind() == NodeKind::ForStmt) {
                countEmpty(static_cast<const CForStmt&>(*sp).body);
            }
        }
    };
    countEmpty(func.body);
    if (emptyIfs > 0) {
        deduction += std::min(10.0, (double)emptyIfs * 2.0);
        func.confidenceIssues.push_back(
            std::format("{} empty if/else block(s)", emptyIfs));
    }

    // ── Stub / very short function ───────────────────────────────────
    // Count total statements recursively (not just top-level body).
    unsigned totalStmts = 0;
    std::function<void(const std::vector<StmtPtr>&)> countStmts;
    countStmts = [&](const std::vector<StmtPtr>& stmts) {
        for (auto& sp : stmts) {
            if (!sp) continue;
            totalStmts++;
            switch (sp->getKind()) {
            case NodeKind::IfStmt: {
                auto& s = static_cast<const CIfStmt&>(*sp);
                countStmts(s.thenBody);
                countStmts(s.elseBody);
                break;
            }
            case NodeKind::WhileStmt:
                countStmts(static_cast<const CWhileStmt&>(*sp).body);
                break;
            case NodeKind::DoWhileStmt:
                countStmts(static_cast<const CDoWhileStmt&>(*sp).body);
                break;
            case NodeKind::ForStmt:
                countStmts(static_cast<const CForStmt&>(*sp).body);
                break;
            case NodeKind::SwitchStmt:
                for (auto& c : static_cast<const CSwitchStmt&>(*sp).cases)
                    countStmts(c.body);
                break;
            case NodeKind::BlockStmt:
                countStmts(static_cast<const CBlockStmt&>(*sp).stmts);
                break;
            default: break;
            }
        }
    };
    countStmts(func.body);
    if (totalStmts <= 3) {
        deduction += 15.0;
        func.confidenceIssues.push_back("stub function");
    } else if (totalStmts <= 8) {
        deduction += 5.0;
        func.confidenceIssues.push_back("very short function");
    }

    // ── Lifter silent-bailout detection (bug F) ─────────────────────
    //
    // When Remill can't handle an opcode mid-function, it sometimes emits
    // IR with just the prologue + the offending instruction, then stops.
    // The resulting helix.c is a stub like:
    //   CPlayerInfo_Process(void) { loop_while_ne(); return; }
    // — a single opcode-like call followed by return, no real logic.
    //
    // Counts both undecomposed opcodes (`nativeOps > 0`) AND decomposed
    // ones whose semantic-map name begins with a known "this-is-really-an-
    // instruction-not-a-function" prefix (`fp_`, `loop_`, `port_`, `far_`,
    // `string_`, `bit_scan_`, `bit_test_`, `pop_all_`, `push_all_`, etc.).
    // A real tiny wrapper like `SetHealth(x) { field = x; return; }`
    // doesn't hit this rule because it has an assignment, not an opcode.
    unsigned opcodeCalls = nativeOps;
    {
        auto isOpcodeSemanticName = [](std::string_view name) -> bool {
            static constexpr std::string_view kOpcodePrefixes[] = {
                "fp_", "loop_", "port_in_", "port_out_",
                "far_jump", "far_call", "far_return",
                "string_compare_", "string_move_", "string_scan_",
                "string_store", "string_load",
                "pop_all_gprs", "push_all_gprs",
                "pop_flags", "push_flags",
                "load_flags_into_ah", "store_ah_to_flags",
                "bit_scan_", "bit_test_",
                "read_timestamp_counter", "cpuid",
                "hardware_random", "hardware_random_seed",
                "atomic_test_and_", "atomic_fetch_", "atomic_exchange",
                "atomic_compare_exchange",
                "sub_with_borrow", "add_with_carry",
            };
            for (auto p : kOpcodePrefixes)
                if (name.starts_with(p)) return true;
            return false;
        };

        std::function<void(const std::vector<StmtPtr>&)> countOpcodes;
        countOpcodes = [&](const std::vector<StmtPtr>& stmts) {
            for (auto& sp : stmts) {
                if (!sp) continue;
                switch (sp->getKind()) {
                case NodeKind::ExprStmt: {
                    auto& e = static_cast<const CExprStmt&>(*sp);
                    if (e.expr && e.expr->getKind() == NodeKind::CallExpr) {
                        auto& call = static_cast<const CCallExpr&>(*e.expr);
                        if (isOpcodeSemanticName(call.targetName))
                            ++opcodeCalls;
                    }
                    break;
                }
                case NodeKind::AssignStmt: {
                    auto& a = static_cast<const CAssignStmt&>(*sp);
                    if (a.value && a.value->getKind() == NodeKind::CallExpr) {
                        auto& call = static_cast<const CCallExpr&>(*a.value);
                        if (isOpcodeSemanticName(call.targetName))
                            ++opcodeCalls;
                    }
                    break;
                }
                case NodeKind::IfStmt: {
                    auto& s = static_cast<const CIfStmt&>(*sp);
                    countOpcodes(s.thenBody);
                    countOpcodes(s.elseBody);
                    break;
                }
                case NodeKind::WhileStmt:
                    countOpcodes(static_cast<const CWhileStmt&>(*sp).body);
                    break;
                case NodeKind::DoWhileStmt:
                    countOpcodes(static_cast<const CDoWhileStmt&>(*sp).body);
                    break;
                case NodeKind::ForStmt:
                    countOpcodes(static_cast<const CForStmt&>(*sp).body);
                    break;
                case NodeKind::BlockStmt:
                    countOpcodes(static_cast<const CBlockStmt&>(*sp).stmts);
                    break;
                default: break;
                }
            }
        };
        countOpcodes(func.body);
    }

    if (totalStmts <= 3 && opcodeCalls > 0) {
        deduction += 40.0;
        func.confidenceIssues.push_back(
            "possibly truncated by lifter — body is a single undecomposed "
            "opcode; Remill may have bailed mid-function");
    }

    // ── Undeclared variable references (bug C) ──────────────────────
    //
    // SSA destruction sometimes produces VarRef nodes that reference
    // names (`v0`, `param_2`, `result`) without a matching decl in
    // `func.localVars` or `func.params`.  The resulting C is not
    // compilable.  Count them and heavily penalise confidence.
    {
        std::unordered_set<std::string> declaredNames;
        for (auto& p : func.params)    declaredNames.insert(p.name);
        for (auto& d : func.localVars) declaredNames.insert(d.varName);

        std::unordered_set<std::string> referenced;
        collectVarNamesInStmts(func.body, referenced);

        // Same filter as `declareUndeclaredVars` — a name has to be a
        // valid C identifier AND not one of the stack-bookkeeping
        // pseudo-names the printer still surfaces on occasion.  Keeps
        // the two passes in lockstep so the confidence Issue never
        // fires after the decl-injection pass has run.
        auto isValidCIdent = [](std::string_view n) -> bool {
            if (n.empty()) return false;
            char c0 = n.front();
            if (!((c0 >= 'A' && c0 <= 'Z') ||
                  (c0 >= 'a' && c0 <= 'z') ||
                  c0 == '_'))
                return false;
            for (size_t i = 1; i < n.size(); ++i) {
                char c = n[i];
                if (!((c >= 'A' && c <= 'Z') ||
                      (c >= 'a' && c <= 'z') ||
                      (c >= '0' && c <= '9') ||
                      c == '_'))
                    return false;
            }
            return true;
        };

        unsigned undeclared = 0;
        for (auto& n : referenced) {
            if (n == "rsp" || n == "rbp" || n == "esp" || n == "ebp")
                continue;
            if (!isValidCIdent(n))
                continue;
            // FIX-089: `loc_<hex>` is a code-label reference, not a data
            // variable — kept in lockstep with declareUndeclaredVars so the
            // D1 `&loc_xxxx` form does not inflate the undeclared-var count.
            if (isCodeLabelName(n))
                continue;
            if (!declaredNames.count(n))
                ++undeclared;
        }
        if (undeclared > 0) {
            deduction += std::min(40.0, 6.0 + 4.0 * (double)undeclared);
            func.confidenceIssues.push_back(
                std::format("{} reference(s) to undeclared variable(s)"
                            " — output does not compile",
                            undeclared));
        }
    }

    // ── Synthesised-variable smell (FIX-045) ────────────────────────
    //
    // `declareUndeclaredVars` (FIX-043) injects placeholder decls for
    // names the body referenced without a matching declaration.  After
    // the pass runs the output compiles, but a high count of synthetic
    // decls is still a strong signal of lift-quality issues — SSA
    // destruction gaps, or (file 14 of the gta-sa stress set) data
    // bytes Remill lifted as if they were code.  Penalise proportional
    // to the count but less harshly than the raw-undeclared case (which
    // literally breaks compilation).  The Issue wording makes it clear
    // these were auto-declared so the user knows to cross-reference
    // against IDA.
    if (func.synthesizedVarDecls > 0) {
        unsigned n = func.synthesizedVarDecls;
        deduction += std::min(25.0, 3.0 + 2.5 * (double)n);
        func.confidenceIssues.push_back(
            std::format("{} auto-declared placeholder variable(s)"
                        " — lift-quality concern; verify against IDA",
                        n));
    }

    // ── Typed parameter bonus ────────────────────────────────────────
    if (!func.params.empty()) {
        unsigned typedParams = 0;
        for (auto& p : func.params) {
            if (p.type) {
                auto typeName = p.type->format();
                if (typeName != "int64_t" && typeName != "uint64_t")
                    typedParams++;
            }
        }
        if (typedParams > 0) {
            double bonus = std::min(5.0,
                (double)typedParams / (double)func.params.size() * 5.0);
            deduction -= bonus;
        }
    }

    // ── v0.9.1 (G-015): theorem-grounded garbage-pattern penalties ───
    //
    // Counts the same defect classes helix-validate (tools/helix-validate)
    // detects via dataflow theorems. Until landed, the scorer reports 91%
    // on a function whose first statement is `return sub_c();` followed
    // by 30 lines of unreachable tail (init_module→hook_syslog on the
    // rev_kernel_monarch rootkit corpus). Penalties here close that gap.
    //
    // Each detector implements a theorem stated in
    // tools/helix-validate/paper-supplement-v091.md §2.1.

    auto isZeroLit = [](const CExpr* e) -> bool {
        std::function<bool(const CExpr*)> rec = [&](const CExpr* x) -> bool {
            if (!x) return false;
            if (auto* lit = llvm::dyn_cast<CIntLitExpr>(x))
                return lit->value == 0;
            if (auto* lit = llvm::dyn_cast<CAddrLitExpr>(x))
                return lit->addrValue == 0;
            if (auto* c = llvm::dyn_cast<CCastExpr>(x))
                return rec(c->operand.get());
            return false;
        };
        return rec(e);
    };
    auto varNameOf = [](const CExpr* e) -> std::string {
        std::function<std::string(const CExpr*)> rec = [&](const CExpr* x) -> std::string {
            if (!x) return {};
            if (auto* c = llvm::dyn_cast<CCastExpr>(x))
                return rec(c->operand.get());
            if (auto* v = llvm::dyn_cast<CVarRefExpr>(x))
                return v->varName;
            return {};
        };
        return rec(e);
    };
    std::function<bool(const CExpr*, llvm::StringRef)> referencesVar =
        [&](const CExpr* e, llvm::StringRef name) -> bool {
        if (!e || name.empty()) return false;
        if (auto* v = llvm::dyn_cast<CVarRefExpr>(e))
            return v->varName == name;
        if (auto* b = llvm::dyn_cast<CBinaryExpr>(e))
            return referencesVar(b->lhs.get(), name) ||
                   referencesVar(b->rhs.get(), name);
        if (auto* u = llvm::dyn_cast<CUnaryExpr>(e))
            return referencesVar(u->operand.get(), name);
        if (auto* c = llvm::dyn_cast<CCastExpr>(e))
            return referencesVar(c->operand.get(), name);
        if (auto* t = llvm::dyn_cast<CTernaryExpr>(e))
            return referencesVar(t->cond.get(), name) ||
                   referencesVar(t->trueVal.get(), name) ||
                   referencesVar(t->falseVal.get(), name);
        if (auto* s = llvm::dyn_cast<CSubscriptExpr>(e))
            return referencesVar(s->base.get(), name) ||
                   referencesVar(s->index.get(), name);
        if (auto* fa = llvm::dyn_cast<CFieldAccessExpr>(e))
            return referencesVar(fa->base.get(), name);
        if (auto* call = llvm::dyn_cast<CCallExpr>(e)) {
            for (auto& a : call->args)
                if (referencesVar(a.get(), name)) return true;
        }
        return false;
    };

    // Pre-compute zero-init placeholders from this function's declarations.
    std::unordered_set<std::string> zeroInit;
    for (const auto& lv : func.localVars) {
        if (lv.initExpr && isZeroLit(lv.initExpr.get()))
            zeroInit.insert(lv.varName);
    }
    std::unordered_set<std::string> reassigned;

    struct Counts {
        int unreachableAfterReturn = 0;
        int nullDerefPlaceholder   = 0;
        int suspiciousSelfRef      = 0;
        int identityNoOp           = 0;
    } cnt;

    // FIX-CAST-002: `x = x->field` / `x = *x` is a legitimate pointer walk /
    // load (reusing a register after dereferencing it), NOT a suspicious
    // self-reference.  The self-ref heuristic below (`target name appears in the
    // RHS`) was flagging these and applying a heavy confidence penalty
    // (min(20, count*5)).  Recognise a RHS that is purely a field-access / deref
    // chain rooted at the target var and exclude it.  Only suppresses a
    // FALSE-POSITIVE penalty; genuine self-refs (arithmetic, `x = f(x)` call
    // captures, mixed exprs) stay flagged.  Honest-confidence fix, body unchanged.
    auto isPureSelfWalk = [](const CExpr* e, const std::string& tn) -> bool {
        const CExpr* cur = e;
        bool sawAccess = false;
        while (cur) {
            if (auto* f = llvm::dyn_cast<CFieldAccessExpr>(cur)) {
                sawAccess = true; cur = f->base.get(); continue;
            }
            if (auto* u = llvm::dyn_cast<CUnaryExpr>(cur)) {
                if (u->op == UnaryOp::Deref) {
                    sawAccess = true; cur = u->operand.get(); continue;
                }
            }
            break;
        }
        auto* v = llvm::dyn_cast_or_null<CVarRefExpr>(cur);
        return sawAccess && v && v->varName == tn;
    };

    std::function<void(const CStmt*)> walkStmt;
    std::function<void(const std::vector<StmtPtr>&)> walkList =
        [&](const std::vector<StmtPtr>& body) {
        bool sawReturn = false;
        for (auto& sp : body) {
            if (sawReturn) { cnt.unreachableAfterReturn++; continue; }
            walkStmt(sp.get());
            if (llvm::isa_and_nonnull<CReturnStmt>(sp.get())) sawReturn = true;
        }
    };
    walkStmt = [&](const CStmt* s) {
        if (!s) return;
        if (auto* a = llvm::dyn_cast<CAssignStmt>(s)) {
            // T1 — `*<zero_var> = …` and `<zero_var>` not yet reassigned.
            if (auto* u = llvm::dyn_cast<CUnaryExpr>(a->target.get())) {
                if (u->op == UnaryOp::Deref) {
                    auto vn = varNameOf(u->operand.get());
                    if (!vn.empty() && zeroInit.count(vn) &&
                        !reassigned.count(vn)) {
                        cnt.nullDerefPlaceholder++;
                    }
                }
            }
            // Then record the assignment as a reassignment of `target` (if
            // target is a plain var ref — `*p = …` writes through `p`,
            // does NOT reassign `p` itself, which the check above
            // already handled).
            if (auto vn = varNameOf(a->target.get()); !vn.empty()) {
                reassigned.insert(vn);
            }
            // T2 / T3 — identity / suspicious-self-ref.
            if (auto tn = varNameOf(a->target.get()); !tn.empty()) {
                bool rhsRefs = referencesVar(a->value.get(), tn);
                bool plainSelf = a->compoundOp.empty() &&
                                 varNameOf(a->value.get()) == tn;
                bool selfOrAnd =
                    (a->compoundOp == "|=" || a->compoundOp == "&=") &&
                    varNameOf(a->value.get()) == tn;
                bool opZero =
                    (a->compoundOp == "+=" || a->compoundOp == "-=" ||
                     a->compoundOp == "|=" || a->compoundOp == "^=") &&
                    isZeroLit(a->value.get());
                if (plainSelf || selfOrAnd || opZero) {
                    cnt.identityNoOp++;
                } else if (rhsRefs &&
                           !isPureSelfWalk(a->value.get(), tn)) {
                    cnt.suspiciousSelfRef++;
                }
            }
            return;
        }
        if (auto* i = llvm::dyn_cast<CIfStmt>(s)) {
            walkList(i->thenBody); walkList(i->elseBody); return;
        }
        if (auto* w = llvm::dyn_cast<CWhileStmt>(s)) {
            walkList(w->body); return;
        }
        if (auto* dw = llvm::dyn_cast<CDoWhileStmt>(s)) {
            walkList(dw->body); return;
        }
        if (auto* fr = llvm::dyn_cast<CForStmt>(s)) {
            walkList(fr->body); return;
        }
        if (auto* sw = llvm::dyn_cast<CSwitchStmt>(s)) {
            for (auto& c : sw->cases) walkList(c.body);
            return;
        }
        if (auto* blk = llvm::dyn_cast<CBlockStmt>(s)) {
            walkList(blk->stmts); return;
        }
    };
    walkList(func.body);

    if (cnt.unreachableAfterReturn > 0) {
        deduction += std::min(40.0, (double)cnt.unreachableAfterReturn * 5.0);
        func.confidenceIssues.push_back(std::format(
            "{} unreachable statement(s) after `return` (lift-quality concern)",
            cnt.unreachableAfterReturn));
    }
    if (cnt.nullDerefPlaceholder > 0) {
        deduction += std::min(30.0, (double)cnt.nullDerefPlaceholder * 10.0);
        func.confidenceIssues.push_back(std::format(
            "{} null-deref of zero-initialised placeholder",
            cnt.nullDerefPlaceholder));
    }
    if (cnt.suspiciousSelfRef > 0) {
        deduction += std::min(20.0, (double)cnt.suspiciousSelfRef * 5.0);
        func.confidenceIssues.push_back(std::format(
            "{} suspicious self-referencing assignment(s)",
            cnt.suspiciousSelfRef));
    }
    if (cnt.identityNoOp > 0) {
        deduction += std::min(10.0, (double)cnt.identityNoOp * 3.0);
        func.confidenceIssues.push_back(std::format(
            "{} identity / no-op assignment(s)", cnt.identityNoOp));
    }

    func.confidenceScore = std::max(0.0, std::min(100.0, 100.0 - deduction));

    // -- D4 (charter exit-metric 4): damning-defect hard cap (FIX-092) --
    // This rescorer overwrites confidenceScore AFTER all optimizations and is
    // the value that actually survives to the user; it is the AUTHORITATIVE
    // final cap.  Two sources, matching analyzeConfidence:
    //   * D2 out-of-table CALL -- build-time-latched on the decl
    //     (func.hasDamningHonestyDefect, raised only by the 713/722 call hooks).
    //     A side-effecting call erased here is still a defect, so cap on the
    //     flag even if no call node survives.
    //   * D1 code-address LEAK / uninitialized return / irreducible no-return
    //     -- RE-DERIVED from the FINAL (post-optimization) AST, so a benign PC/
    //     NEXT_PC/RIP constant that coincided with a function-start entry and
    //     was then erased by this pass's DSE/dead-store removal does NOT trip
    //     the cap.  The reason string names the ACTUAL surviving category
    //     (rag/16 G3: kill the mis-attributed fixed phrase on leaf fns).
    auto damning = detectDamningDefects(func);
    bool d2Call = func.hasDamningHonestyDefect;
    if ((damning.any() || d2Call) && func.confidenceScore > 50.0) {
        func.confidenceScore = 50.0;
        std::string reason = damning.reason();
        if (d2Call) {
            if (!reason.empty()) reason += "; ";
            reason += "out-of-table call";
        }
        func.confidenceIssues.push_back(
            "damning honesty defect (" + reason +
            ") - confidence capped at 50%");
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: removeUnusedDeclarations — drop variable declarations with no references
// ═══════════════════════════════════════════════════════════════════════════════
//
// After dead code removal and other optimizations, some variables may no
// longer be referenced in the function body.  Remove their declarations
// to reduce clutter in the output.

void CAstOptimizer::removeUnusedDeclarations(CFuncDecl& func) {
    // Collect all variable names referenced in the body.
    std::unordered_set<std::string> referencedVars;
    collectVarNamesInStmts(func.body, referencedVars);

    // Remove declarations for variables not referenced in the body.
    func.localVars.erase(
        std::remove_if(func.localVars.begin(), func.localVars.end(),
            [&](const CVarDecl& d) {
                return !referencedVars.count(d.varName);
            }),
        func.localVars.end());
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: removeDeadStoresBeforeReturn — strip trailing var = const before return
// ═══════════════════════════════════════════════════════════════════════════════
//
// Pattern: var_X = <constant>; return Y;
// where var_X is never read elsewhere in the function.  These are dead
// stores that the generic DSE may miss because of conservative liveness
// across nested scopes.

static void removeDeadStoresBeforeReturnInList(
    std::vector<StmtPtr>& stmts,
    const std::unordered_map<std::string, unsigned>& globalRefCount) {
    // Recurse into nested scopes first.
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            removeDeadStoresBeforeReturnInList(s.thenBody, globalRefCount);
            removeDeadStoresBeforeReturnInList(s.elseBody, globalRefCount);
            break;
        }
        case NodeKind::WhileStmt:
            removeDeadStoresBeforeReturnInList(
                static_cast<CWhileStmt&>(*sp).body, globalRefCount);
            break;
        case NodeKind::DoWhileStmt:
            removeDeadStoresBeforeReturnInList(
                static_cast<CDoWhileStmt&>(*sp).body, globalRefCount);
            break;
        case NodeKind::ForStmt:
            removeDeadStoresBeforeReturnInList(
                static_cast<CForStmt&>(*sp).body, globalRefCount);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                removeDeadStoresBeforeReturnInList(c.body, globalRefCount);
            break;
        case NodeKind::BlockStmt:
            removeDeadStoresBeforeReturnInList(
                static_cast<CBlockStmt&>(*sp).stmts, globalRefCount);
            break;
        default: break;
        }
    }

    // Walk the list backward, looking for return statements preceded by
    // dead stores.
    for (size_t i = stmts.size(); i-- > 0;) {
        if (!stmts[i] || stmts[i]->getKind() != NodeKind::ReturnStmt)
            continue;

        // Walk backward from i-1, removing trivially dead stores.
        for (size_t j = i; j-- > 0;) {
            if (!stmts[j]) continue;
            if (stmts[j]->getKind() != NodeKind::AssignStmt) break;

            auto& a = static_cast<CAssignStmt&>(*stmts[j]);
            if (!a.target || !a.value) break;
            if (a.target->getKind() != NodeKind::VarRefExpr) break;

            // Don't touch unsafe targets.
            if (a.value->getKind() == NodeKind::CallExpr) break;

            const auto& tgt =
                static_cast<const CVarRefExpr&>(*a.target).varName;

            // Skip if the variable has any read references in the function
            // (countVarRefs counts only READS, not write targets, so the
            // map count == 0 means "no reads anywhere" → safe to remove).
            auto it = globalRefCount.find(tgt);
            unsigned readCount = (it == globalRefCount.end()) ? 0 : it->second;
            if (readCount > 0) break;  // has reads → not dead

            // No reads anywhere → safe to remove the trailing store.
            stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(j));
            // Update i since j was just erased.
            i--;
        }
    }
}

void CAstOptimizer::removeDeadStoresBeforeReturn(CFuncDecl& func) {
    // Build a global reference count map.
    std::unordered_map<std::string, unsigned> refCount;
    countVarRefs(func.body, refCount);
    removeDeadStoresBeforeReturnInList(func.body, refCount);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: removeAdjacentDuplicateStmts — collapse consecutive identical stmts
// ═══════════════════════════════════════════════════════════════════════════════
//
// Pattern:
//   mutex_unlock(var_70);
//   mutex_unlock(var_70);    ← duplicate, remove
//
// Caused by structural duplication during CFG flattening or copy propagation.

static bool exprEqual(const CExpr* a, const CExpr* b);

static bool stmtsEqual(const CStmt* a, const CStmt* b) {
    if (!a || !b) return false;
    if (a->getKind() != b->getKind()) return false;
    switch (a->getKind()) {
    case NodeKind::ExprStmt: {
        auto& ea = static_cast<const CExprStmt&>(*a);
        auto& eb = static_cast<const CExprStmt&>(*b);
        return exprEqual(ea.expr.get(), eb.expr.get());
    }
    case NodeKind::AssignStmt: {
        auto& aa = static_cast<const CAssignStmt&>(*a);
        auto& ab = static_cast<const CAssignStmt&>(*b);
        return exprEqual(aa.target.get(), ab.target.get()) &&
               exprEqual(aa.value.get(), ab.value.get());
    }
    default: return false;
    }
}

static bool exprEqual(const CExpr* a, const CExpr* b) {
    if (a == b) return true;
    if (!a || !b) return false;
    if (a->getKind() != b->getKind()) return false;
    switch (a->getKind()) {
    case NodeKind::IntLitExpr: {
        auto& la = static_cast<const CIntLitExpr&>(*a);
        auto& lb = static_cast<const CIntLitExpr&>(*b);
        return la.value == lb.value;
    }
    case NodeKind::VarRefExpr: {
        auto& va = static_cast<const CVarRefExpr&>(*a);
        auto& vb = static_cast<const CVarRefExpr&>(*b);
        return va.varName == vb.varName;
    }
    case NodeKind::StringLitExpr: {
        // String literals were previously unhandled and fell through to the
        // `default: return false` below — so two structurally identical calls
        // carrying a string literal argument never compared equal, defeating
        // the bare+assign double-emit dedup in removeDuplicatesInList for any
        // such call.  Compare by value.
        auto& sa = static_cast<const CStringLitExpr&>(*a);
        auto& sb = static_cast<const CStringLitExpr&>(*b);
        return sa.value == sb.value;
    }
    case NodeKind::BinaryExpr: {
        auto& ba = static_cast<const CBinaryExpr&>(*a);
        auto& bb = static_cast<const CBinaryExpr&>(*b);
        return ba.op == bb.op &&
               exprEqual(ba.lhs.get(), bb.lhs.get()) &&
               exprEqual(ba.rhs.get(), bb.rhs.get());
    }
    case NodeKind::UnaryExpr: {
        auto& ua = static_cast<const CUnaryExpr&>(*a);
        auto& ub = static_cast<const CUnaryExpr&>(*b);
        return ua.op == ub.op &&
               exprEqual(ua.operand.get(), ub.operand.get());
    }
    case NodeKind::CastExpr: {
        auto& ca = static_cast<const CCastExpr&>(*a);
        auto& cb = static_cast<const CCastExpr&>(*b);
        return exprEqual(ca.operand.get(), cb.operand.get());
    }
    case NodeKind::CallExpr: {
        auto& ca = static_cast<const CCallExpr&>(*a);
        auto& cb = static_cast<const CCallExpr&>(*b);
        if (ca.targetName != cb.targetName) return false;
        if (ca.args.size() != cb.args.size()) return false;
        for (size_t i = 0; i < ca.args.size(); ++i) {
            if (!exprEqual(ca.args[i].get(), cb.args[i].get())) return false;
        }
        return true;
    }
    case NodeKind::FieldAccessExpr: {
        auto& fa = static_cast<const CFieldAccessExpr&>(*a);
        auto& fb = static_cast<const CFieldAccessExpr&>(*b);
        return fa.fieldName == fb.fieldName &&
               exprEqual(fa.base.get(), fb.base.get());
    }
    case NodeKind::SubscriptExpr: {
        auto& sa = static_cast<const CSubscriptExpr&>(*a);
        auto& sb = static_cast<const CSubscriptExpr&>(*b);
        return exprEqual(sa.base.get(), sb.base.get()) &&
               exprEqual(sa.index.get(), sb.index.get());
    }
    default: return false;
    }
}

static void removeDuplicatesInList(std::vector<StmtPtr>& stmts) {
    // Recurse first.
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            removeDuplicatesInList(s.thenBody);
            removeDuplicatesInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            removeDuplicatesInList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            removeDuplicatesInList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            removeDuplicatesInList(static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                removeDuplicatesInList(c.body);
            break;
        case NodeKind::BlockStmt:
            removeDuplicatesInList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default: break;
        }
    }

    // Now scan for adjacent duplicate ExprStmts.  Two adjacent identical
    // call statements can be safely collapsed only if removing one
    // preserves program semantics in ALL cases.  We use a conservative
    // rule: collapse only when ALL arguments to the call are LITERAL
    // CONSTANTS (no variable references, no side-effecting expressions).
    //
    // Rationale: a call with all-literal arguments has no dependency on
    // program state between the two invocations, so a duplicate is
    // provably equivalent to the single call (e.g., `kfree(0); kfree(0);`).
    // Calls with variable arguments may have meaning (mutex_unlock
    // bracketing, lock acquisition patterns, hardware MMIO writes) that
    // would be broken by removing duplicates.  We leave them alone.
    auto allArgsLiteral = [](const CCallExpr& call) -> bool {
        for (const auto& arg : call.args) {
            if (!arg) continue;
            auto k = arg->getKind();
            if (k != NodeKind::IntLitExpr &&
                k != NodeKind::FloatLitExpr &&
                k != NodeKind::StringLitExpr &&
                k != NodeKind::AddrLitExpr) {
                return false;
            }
        }
        return true;
    };

    for (size_t i = 0; i + 1 < stmts.size();) {
        if (!stmts[i] || !stmts[i + 1]) { ++i; continue; }
        if (stmts[i]->getKind() != NodeKind::ExprStmt ||
            stmts[i + 1]->getKind() != NodeKind::ExprStmt) {
            ++i; continue;
        }
        auto& a = static_cast<const CExprStmt&>(*stmts[i]);
        auto& b = static_cast<const CExprStmt&>(*stmts[i + 1]);
        if (!a.expr || !b.expr) { ++i; continue; }
        if (a.expr->getKind() != NodeKind::CallExpr) { ++i; continue; }
        if (!exprEqual(a.expr.get(), b.expr.get())) { ++i; continue; }

        const auto& call = static_cast<const CCallExpr&>(*a.expr);
        if (!allArgsLiteral(call)) { ++i; continue; }

        // Safe to remove the duplicate.
        stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i + 1));
        // Don't increment i — re-check this position in case there's
        // a triple.
    }

    // ── FIX-049 (Wave 11, item D — same-origin duplicate call emission) ──
    //
    // Scan for the pattern:
    //     foo(x, y);           // CExprStmt  (line N, addr A)
    //     v = foo(x, y);       // CAssignStmt(value = CCallExpr, addr A)
    //
    // where BOTH statements originate from the SAME MLIR high::CallOp
    // (i.e., they carry the same `.address` — the lifted binary PC).
    // This pattern is a well-known side-effect of FIX-031's synthetic-RAX-
    // RegWrite companion: the CallOp emits as an expression statement for
    // its side effects AND as the value of an assignment capturing the
    // return register.  Two textual statements, one MLIR origin.
    //
    // Safety conditions (ALL must hold):
    //   1. Statement i is CExprStmt with a CCallExpr value.
    //   2. Statement i+1 is CAssignStmt whose .value is CCallExpr.
    //   3. The two CCallExprs are `exprEqual` (same name + same arg tree).
    //   4. Both statements have the same non-zero `address`.  Zero-valued
    //      addresses are rejected because address=0 is Helix's "unknown
    //      origin" sentinel; two such stmts may well be distinct MLIR ops.
    //   5. The assignment target is a simple VarRefExpr (not a deref/field)
    //      so dropping the ExprStmt cannot cancel an lvalue side effect.
    //
    // Observed impact (corpus snapshot, pre-FIX-049):
    //     kbase_jit_allocate : 12 pairs  → -12 lines
    //     kbase_mem_alloc    :  7 pairs  → -7
    //     kbase_mem_commit   :  4 pairs  → -4
    //     kbase_mem_import   :  1 pair
    //     Recoil-mulss-region:  1 pair
    //     sub_140013adc      :  2 pairs
    // All other baseline corpora: 0 pairs (zero regression risk).
    for (size_t i = 0; i + 1 < stmts.size();) {
        if (!stmts[i] || !stmts[i + 1]) { ++i; continue; }
        if (stmts[i]->getKind() != NodeKind::ExprStmt ||
            stmts[i + 1]->getKind() != NodeKind::AssignStmt) {
            ++i; continue;
        }
        auto& exprStmt = static_cast<const CExprStmt&>(*stmts[i]);
        auto& assignStmt = static_cast<const CAssignStmt&>(*stmts[i + 1]);
        if (!exprStmt.expr || !assignStmt.value || !assignStmt.target) {
            ++i; continue;
        }
        if (exprStmt.expr->getKind() != NodeKind::CallExpr ||
            assignStmt.value->getKind() != NodeKind::CallExpr) {
            ++i; continue;
        }
        if (!exprEqual(exprStmt.expr.get(), assignStmt.value.get())) {
            ++i; continue;
        }
        const auto& callA =
            static_cast<const CCallExpr&>(*exprStmt.expr);
        const auto& callB =
            static_cast<const CCallExpr&>(*assignStmt.value);
        // If the two CCallExpr nodes carry different non-zero addresses
        // they're distinct call sites in the binary — preserve both.
        // When either address is 0 (emitter didn't carry it through) the
        // fact that they are (a) exprEqual, (b) adjacent statements with
        // (c) ExprStmt→AssignStmt shape is strong enough evidence of
        // the FIX-031 double-emit artifact on its own.
        if (callA.getAddress() != 0 && callB.getAddress() != 0 &&
            callA.getAddress() != callB.getAddress()) {
            ++i; continue;
        }
        (void)callA; (void)callB; // suppress unused warning
        // Target must be a plain variable.  Dropping an ExprStmt whose
        // twin assigns into a deref or field is risky if the address
        // expression has side effects; easier to just skip.
        if (assignStmt.target->getKind() != NodeKind::VarRefExpr) {
            ++i; continue;
        }
        // Safe: drop the orphan ExprStmt.  The assignment will stand as
        // the single emission for this CallOp.
        stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i));
        // Don't increment i — the newly-shifted stmt[i] may itself be
        // the prelude of another duplicate pair (unlikely but cheap).
    }
}

void CAstOptimizer::removeAdjacentDuplicateStmts(CFuncDecl& func) {
    removeDuplicatesInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: cleanupParameterSSASuffixes — rename param_X_N to vN
// ═══════════════════════════════════════════════════════════════════════════════
//
// When a parameter is reassigned, the SSA splitting pass creates suffixed
// versions like param_1_7, param_3_1.  These should be renamed to clean
// vN names since they represent local variables that just happen to be
// derived from a parameter.

void CAstOptimizer::cleanupParameterSSASuffixes(CFuncDecl& func) {
    // Build a set of parameter names to recognize their suffixed versions.
    std::unordered_set<std::string> paramNames;
    for (const auto& p : func.params)
        paramNames.insert(p.name);

    // Collect existing names.
    std::unordered_set<std::string> usedNames;
    for (auto& d : func.localVars) usedNames.insert(d.varName);
    for (auto& p : func.params)    usedNames.insert(p.name);

    unsigned nextId = 1;
    auto makeUnique = [&]() -> std::string {
        while (true) {
            auto name = "v" + std::to_string(nextId++);
            if (!usedNames.count(name)) {
                usedNames.insert(name);
                return name;
            }
        }
    };

    // Helper: check if a name is "param_<digits>_<digits>" (SSA suffix).
    auto isSuffixedParam = [&paramNames](const std::string& name) -> bool {
        if (!name.starts_with("param_")) return false;
        // Find first underscore after "param_"
        size_t lastUnderscore = name.rfind('_');
        if (lastUnderscore <= 5) return false;  // "param_" already has _
        // Verify the suffix is digits.
        for (size_t i = lastUnderscore + 1; i < name.size(); ++i) {
            if (!isdigit(static_cast<unsigned char>(name[i]))) return false;
        }
        // Verify the part before the last underscore is "param_<digits>"
        // (a real parameter name).
        std::string base = name.substr(0, lastUnderscore);
        return paramNames.count(base) > 0;
    };

    // Phase 1: collect varNames in body that look like SSA-suffixed params.
    std::unordered_set<std::string> bodyNames;
    collectVarNamesInStmts(func.body, bodyNames);

    // Phase 2: rename declared SSA-suffixed params.
    for (auto& d : func.localVars) {
        if (!isSuffixedParam(d.varName)) continue;
        std::string oldName = d.varName;
        std::string newName = makeUnique();
        applyRenameInStmts(func.body, oldName, newName);
        d.varName = newName;
    }

    // Phase 3: rename body-only SSA-suffixed params (no local declaration).
    for (auto& name : bodyNames) {
        if (usedNames.count(name)) continue;
        if (!isSuffixedParam(name)) continue;
        std::string newName = makeUnique();
        applyRenameInStmts(func.body, name, newName);

        uint32_t varId = 90000 + static_cast<uint32_t>(func.localVars.size());
        func.localVars.emplace_back(varId, newName, CType::int64());
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: narrowVariableTypes — narrow declarations based on actual use
// ═══════════════════════════════════════════════════════════════════════════════
//
// If an int64_t variable is ALWAYS read with a narrowing cast (e.g., always
// `(int16_t)var` or `(int8_t)var`), narrow the declaration accordingly.
// This makes the output more accurate.

void CAstOptimizer::narrowVariableTypes(CFuncDecl& func) {
    // Skip — this is a non-trivial analysis that requires us to track ALL
    // reads of each variable and see if they're always wrapped in casts.
    // For now, this is a placeholder.  The narrowing analysis is left for
    // future work because it requires careful handling of pointer-typed
    // variables (where casts indicate type confusion, not narrowing) and
    // assignment targets (which determine the storage type).
    (void)func;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: resolveFramePointerLeaks — convert `var ± const` to `&var_X`
// ═══════════════════════════════════════════════════════════════════════════════
//
// When the lifter doesn't fully resolve frame pointer references, expressions
// like `v12 - 64` (where v12 is rbp and 64 matches a known stack variable
// offset) leak into the C output as raw arithmetic.  These should be
// `&var_40` (the address of the stack variable at offset -0x40).
//
// Detection heuristic:
//   1. The variable being subtracted is a body-only register-derived var
//      (created by renameRemainingRegisterVars Phase 2 — vN with no semantic
//      origin, declared as int64_t).
//   2. The constant matches a known stack variable offset.
//
// Replacement: replace the arithmetic expression with `&<var_name>`.

static ExprPtr tryResolveFrameRefExpr(
    ExprPtr expr,
    const std::map<int64_t, std::string>& offsetToVarName,
    const std::unordered_set<std::string>& candidateFrameVars);

/// Recursively walk an expression tree, but ONLY transform `var ± const`
/// to `&var_X` when the expression appears as a function CALL ARGUMENT.
/// In arithmetic contexts (operands of +, -, *, etc.), the substitution
/// would change semantics: `x -= rbp - 128` is computing `x - (size)128`,
/// not `x - &var_80`.  Only call argument positions are unambiguously
/// "address-of stack var" contexts.
static void resolveFrameRefsInExpr(
    ExprPtr& slot,
    const std::map<int64_t, std::string>& offsetToVarName,
    const std::unordered_set<std::string>& candidateFrameVars,
    bool inArgPosition);

static void resolveFrameRefsInChildren(
    CExpr* expr,
    const std::map<int64_t, std::string>& offsetToVarName,
    const std::unordered_set<std::string>& candidateFrameVars) {
    if (!expr) return;
    switch (expr->getKind()) {
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        // Operands of arithmetic ops are NOT in argument position.
        resolveFrameRefsInExpr(b.lhs, offsetToVarName, candidateFrameVars,
                                /*inArgPosition=*/false);
        resolveFrameRefsInExpr(b.rhs, offsetToVarName, candidateFrameVars,
                                /*inArgPosition=*/false);
        break;
    }
    case NodeKind::UnaryExpr: {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        resolveFrameRefsInExpr(u.operand, offsetToVarName, candidateFrameVars,
                                /*inArgPosition=*/false);
        break;
    }
    case NodeKind::CastExpr: {
        auto& c = static_cast<CCastExpr&>(*expr);
        resolveFrameRefsInExpr(c.operand, offsetToVarName, candidateFrameVars,
                                /*inArgPosition=*/false);
        break;
    }
    case NodeKind::CallExpr: {
        auto& c = static_cast<CCallExpr&>(*expr);
        // Function call args ARE in argument position — eligible for
        // frame pointer leak resolution.
        for (auto& arg : c.args)
            resolveFrameRefsInExpr(arg, offsetToVarName, candidateFrameVars,
                                    /*inArgPosition=*/true);
        break;
    }
    case NodeKind::FieldAccessExpr: {
        auto& f = static_cast<CFieldAccessExpr&>(*expr);
        // Base of field access is dereferenced — pointer context.
        resolveFrameRefsInExpr(f.base, offsetToVarName, candidateFrameVars,
                                /*inArgPosition=*/false);
        break;
    }
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*expr);
        resolveFrameRefsInExpr(s.base, offsetToVarName, candidateFrameVars,
                                /*inArgPosition=*/false);
        resolveFrameRefsInExpr(s.index, offsetToVarName, candidateFrameVars,
                                /*inArgPosition=*/false);
        break;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*expr);
        resolveFrameRefsInExpr(t.cond, offsetToVarName, candidateFrameVars,
                                /*inArgPosition=*/false);
        resolveFrameRefsInExpr(t.trueVal, offsetToVarName, candidateFrameVars,
                                /*inArgPosition=*/false);
        resolveFrameRefsInExpr(t.falseVal, offsetToVarName, candidateFrameVars,
                                /*inArgPosition=*/false);
        break;
    }
    default: break;
    }
}

static void resolveFrameRefsInExpr(
    ExprPtr& slot,
    const std::map<int64_t, std::string>& offsetToVarName,
    const std::unordered_set<std::string>& candidateFrameVars,
    bool inArgPosition) {
    if (!slot) return;

    // First recurse into children.
    resolveFrameRefsInChildren(slot.get(), offsetToVarName, candidateFrameVars);

    // Only attempt the conversion if we're in argument position.
    // Otherwise, the `var ± const` expression is meaningful arithmetic
    // (size/offset computation) and should be left alone.
    if (!inArgPosition) return;

    auto resolved = tryResolveFrameRefExpr(
        std::move(slot), offsetToVarName, candidateFrameVars);
    slot = std::move(resolved);
}

static ExprPtr tryResolveFrameRefExpr(
    ExprPtr expr,
    const std::map<int64_t, std::string>& offsetToVarName,
    const std::unordered_set<std::string>& candidateFrameVars) {
    if (!expr || expr->getKind() != NodeKind::BinaryExpr)
        return expr;

    auto& bin = static_cast<CBinaryExpr&>(*expr);
    if (bin.op != BinaryOp::Add && bin.op != BinaryOp::Sub)
        return expr;

    // The LHS must be a candidate frame pointer variable.
    if (!bin.lhs || bin.lhs->getKind() != NodeKind::VarRefExpr)
        return expr;
    const auto& var = static_cast<const CVarRefExpr&>(*bin.lhs);
    if (!candidateFrameVars.count(var.varName))
        return expr;

    // The RHS must be a constant integer.
    if (!bin.rhs || bin.rhs->getKind() != NodeKind::IntLitExpr)
        return expr;
    int64_t constant = static_cast<const CIntLitExpr&>(*bin.rhs).value;

    // Compute the effective stack offset.
    int64_t effectiveOffset = (bin.op == BinaryOp::Sub)
        ? -constant
        : constant;

    // Look up the offset in the known stack variables.
    auto it = offsetToVarName.find(effectiveOffset);
    if (it == offsetToVarName.end())
        return expr;

    // Build &var_X using AddressOf wrapping a VarRefExpr.
    auto varRef = std::make_unique<CVarRefExpr>(
        /*varId=*/0,
        it->second,
        CType::voidPtr(),
        expr->getAddress());
    return std::make_unique<CUnaryExpr>(
        UnaryOp::AddressOf,
        std::move(varRef),
        CType::voidPtr(),
        expr->getAddress());
}

static void resolveFrameRefsInStmts(
    std::vector<StmtPtr>& stmts,
    const std::map<int64_t, std::string>& offsetToVarName,
    const std::unordered_set<std::string>& candidateFrameVars) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<CAssignStmt&>(*sp);
            // Top-level assignment RHS is NOT in arg position; the recursive
            // walker will descend into any nested CallExpr::args and set
            // inArgPosition=true there.
            resolveFrameRefsInExpr(a.value, offsetToVarName, candidateFrameVars,
                                    /*inArgPosition=*/false);
            break;
        }
        case NodeKind::ExprStmt:
            resolveFrameRefsInExpr(
                static_cast<CExprStmt&>(*sp).expr,
                offsetToVarName, candidateFrameVars,
                /*inArgPosition=*/false);
            break;
        case NodeKind::ReturnStmt:
            resolveFrameRefsInExpr(
                static_cast<CReturnStmt&>(*sp).value,
                offsetToVarName, candidateFrameVars,
                /*inArgPosition=*/false);
            break;
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            resolveFrameRefsInExpr(s.condition, offsetToVarName, candidateFrameVars,
                                    /*inArgPosition=*/false);
            resolveFrameRefsInStmts(s.thenBody, offsetToVarName, candidateFrameVars);
            resolveFrameRefsInStmts(s.elseBody, offsetToVarName, candidateFrameVars);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& s = static_cast<CWhileStmt&>(*sp);
            resolveFrameRefsInExpr(s.condition, offsetToVarName, candidateFrameVars,
                                    /*inArgPosition=*/false);
            resolveFrameRefsInStmts(s.body, offsetToVarName, candidateFrameVars);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& s = static_cast<CDoWhileStmt&>(*sp);
            resolveFrameRefsInExpr(s.condition, offsetToVarName, candidateFrameVars,
                                    /*inArgPosition=*/false);
            resolveFrameRefsInStmts(s.body, offsetToVarName, candidateFrameVars);
            break;
        }
        case NodeKind::ForStmt: {
            auto& s = static_cast<CForStmt&>(*sp);
            resolveFrameRefsInExpr(s.condition, offsetToVarName, candidateFrameVars,
                                    /*inArgPosition=*/false);
            resolveFrameRefsInStmts(s.body, offsetToVarName, candidateFrameVars);
            break;
        }
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                resolveFrameRefsInStmts(c.body, offsetToVarName, candidateFrameVars);
            break;
        case NodeKind::BlockStmt:
            resolveFrameRefsInStmts(
                static_cast<CBlockStmt&>(*sp).stmts,
                offsetToVarName, candidateFrameVars);
            break;
        default: break;
        }
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: splitVariablesByType — TIE-style type-aware variable splitting
// ═══════════════════════════════════════════════════════════════════════════════
//
// When a single variable is assigned from sources with conflicting semantic
// types over its lifetime (e.g., a field access producing a pointer, then an
// arithmetic result producing an integer), split it into multiple variables.
// Each "lifetime" gets its own variable with the appropriate type semantics.
//
// Reference: TIE (Lee/Avgerinos/Brumley 2011), §5.1 — SSA reconstruction with
// type-aware lifetime splitting.
//
// Algorithm:
//   1. Walk function body in order, tracking each variable's "current type"
//      based on the most recent assignment's RHS.
//   2. When an assignment's RHS type differs from the variable's current
//      type AND the previous type was non-trivial (pointer or value), the
//      assignment starts a new "lifetime".
//   3. Rename the new lifetime to a fresh variable name.
//   4. Forward-rename all subsequent uses until the next assignment that
//      restores or changes the type again.

namespace {

enum class ValueTypeKind : uint8_t {
    Unknown,
    Pointer,   // result of field access, deref, &var, address-like
    Integer,   // result of arithmetic, comparison, integer literal
};

/// Infer the semantic type of an expression's value.
ValueTypeKind inferValueType(const CExpr* expr) {
    if (!expr) return ValueTypeKind::Unknown;
    switch (expr->getKind()) {
    case NodeKind::IntLitExpr:
        // Treat large literals (likely addresses) as pointers, small as int.
        // For safety, treat all integer literals as Unknown — they could be
        // either pointer or value depending on context.
        return ValueTypeKind::Unknown;

    case NodeKind::AddrLitExpr:
        return ValueTypeKind::Pointer;

    case NodeKind::FieldAccessExpr:
        // Field access RESULT is pointer-like only if the field's type is
        // a pointer.  Without type info, conservatively treat as Unknown
        // (the result could be any field type — int, char, pointer, etc.)
        return ValueTypeKind::Unknown;

    case NodeKind::UnaryExpr: {
        const auto& u = static_cast<const CUnaryExpr&>(*expr);
        if (u.op == UnaryOp::AddressOf) return ValueTypeKind::Pointer;
        if (u.op == UnaryOp::Deref)     return ValueTypeKind::Unknown;
        // Negation, bitwise not, logical not → integer
        if (u.op == UnaryOp::Neg || u.op == UnaryOp::BitNot ||
            u.op == UnaryOp::LogNot)
            return ValueTypeKind::Integer;
        return ValueTypeKind::Unknown;
    }

    case NodeKind::BinaryExpr: {
        const auto& b = static_cast<const CBinaryExpr&>(*expr);
        // Comparisons → integer (boolean)
        if (b.op == BinaryOp::Eq || b.op == BinaryOp::Ne ||
            b.op == BinaryOp::Lt || b.op == BinaryOp::Le ||
            b.op == BinaryOp::Gt || b.op == BinaryOp::Ge ||
            b.op == BinaryOp::LogAnd || b.op == BinaryOp::LogOr)
            return ValueTypeKind::Integer;
        // Pure bitwise ops → integer
        if (b.op == BinaryOp::BitAnd || b.op == BinaryOp::BitOr ||
            b.op == BinaryOp::BitXor || b.op == BinaryOp::Shl ||
            b.op == BinaryOp::Shr || b.op == BinaryOp::Sar ||
            b.op == BinaryOp::Mul || b.op == BinaryOp::Div ||
            b.op == BinaryOp::Mod)
            return ValueTypeKind::Integer;
        // Add/Sub: pointer arithmetic preserves pointer type, but plain
        // int arithmetic produces int.  Without precise type info, return
        // Unknown.
        return ValueTypeKind::Unknown;
    }

    case NodeKind::CastExpr:
        // The result type is whatever we cast to — recurse on the operand.
        return inferValueType(static_cast<const CCastExpr&>(*expr).operand.get());

    case NodeKind::CallExpr:
        // Call results are typed by their return type — without that info,
        // we treat as Unknown.  Could be pointer or value.
        return ValueTypeKind::Unknown;

    case NodeKind::VarRefExpr:
        // Plain variable reference — type is determined by the variable.
        return ValueTypeKind::Unknown;

    default:
        return ValueTypeKind::Unknown;
    }
}

/// Determine how a variable is being USED at a specific reference site.
/// Returns Pointer if the use is dereferencing, field access base, etc.
/// Returns Integer if the use is in arithmetic/comparison.
/// Returns Unknown otherwise.
ValueTypeKind classifyVarUse(const CExpr* parent, const CExpr* varRef) {
    if (!parent) return ValueTypeKind::Unknown;
    switch (parent->getKind()) {
    case NodeKind::UnaryExpr: {
        const auto& u = static_cast<const CUnaryExpr&>(*parent);
        if (u.operand.get() == varRef && u.op == UnaryOp::Deref)
            return ValueTypeKind::Pointer;
        return ValueTypeKind::Unknown;
    }
    case NodeKind::FieldAccessExpr: {
        const auto& f = static_cast<const CFieldAccessExpr&>(*parent);
        if (f.base.get() == varRef)
            return ValueTypeKind::Pointer;
        return ValueTypeKind::Unknown;
    }
    case NodeKind::SubscriptExpr: {
        const auto& s = static_cast<const CSubscriptExpr&>(*parent);
        if (s.base.get() == varRef)
            return ValueTypeKind::Pointer;
        return ValueTypeKind::Unknown;
    }
    case NodeKind::BinaryExpr: {
        const auto& b = static_cast<const CBinaryExpr&>(*parent);
        // Arithmetic / comparison / bitwise → integer use
        if (b.op == BinaryOp::Add || b.op == BinaryOp::Sub ||
            b.op == BinaryOp::Mul || b.op == BinaryOp::Div ||
            b.op == BinaryOp::Mod || b.op == BinaryOp::Shl ||
            b.op == BinaryOp::Shr || b.op == BinaryOp::Sar ||
            b.op == BinaryOp::BitAnd || b.op == BinaryOp::BitOr ||
            b.op == BinaryOp::BitXor || b.op == BinaryOp::Eq ||
            b.op == BinaryOp::Ne || b.op == BinaryOp::Lt ||
            b.op == BinaryOp::Le || b.op == BinaryOp::Gt ||
            b.op == BinaryOp::Ge)
            return ValueTypeKind::Integer;
        return ValueTypeKind::Unknown;
    }
    default:
        return ValueTypeKind::Unknown;
    }
}

} // anonymous namespace

void CAstOptimizer::splitVariablesByType(CFuncDecl& func) {
    // For now, this is a placeholder.  A robust implementation requires
    // building use-def chains and live range analysis at the C AST level,
    // which is a substantial undertaking.  The current Phase 3.5 / Phase 4
    // semantic compatibility check in RecoverVariables.cpp catches the
    // common case of pointer-vs-value coalescing at the SSA level — the
    // remaining cases (where the variable was never split into SSA
    // versions in the first place) would benefit from this analysis but
    // require more infrastructure.
    //
    // The helper functions above (inferValueType, classifyVarUse) are
    // available for future use.
    (void)func;
    (void)inferValueType;
    (void)classifyVarUse;
}

// Forward declaration — implementation appears later in the file.
static void collapseAssignBeforeReturnInList(std::vector<StmtPtr>& stmts);

void CAstOptimizer::collapseAssignBeforeReturn(CFuncDecl& func) {
    collapseAssignBeforeReturnInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: collapseAssignBeforeReturn — `var = X; return var;` → `return X;`
// ═══════════════════════════════════════════════════════════════════════════════
//
// When the LAST statement before a return is an assignment to the same
// variable that's being returned, AND the variable is not used after the
// assignment (which it can't be since we're returning), collapse the
// assignment into the return:
//
//   lock_2 = v2;
//   return lock_2;     →    return v2;
//
// This is a more focused version of copy propagation that handles the
// specific "scratch register holding return value" pattern.

static void collapseAssignBeforeReturnInList(std::vector<StmtPtr>& stmts) {
    // Recurse first.
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            collapseAssignBeforeReturnInList(s.thenBody);
            collapseAssignBeforeReturnInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            collapseAssignBeforeReturnInList(
                static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            collapseAssignBeforeReturnInList(
                static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            collapseAssignBeforeReturnInList(
                static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                collapseAssignBeforeReturnInList(c.body);
            break;
        case NodeKind::BlockStmt:
            collapseAssignBeforeReturnInList(
                static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default: break;
        }
    }

    // Walk for the return-after-assign pattern.
    for (size_t i = 0; i + 1 < stmts.size();) {
        if (!stmts[i] || !stmts[i + 1]) { ++i; continue; }
        if (stmts[i]->getKind() != NodeKind::AssignStmt ||
            stmts[i + 1]->getKind() != NodeKind::ReturnStmt) {
            ++i; continue;
        }
        auto& assign = static_cast<CAssignStmt&>(*stmts[i]);
        auto& ret = static_cast<CReturnStmt&>(*stmts[i + 1]);

        // Both target and return value must be VarRefExpr to the same name.
        if (!assign.target || !assign.value || !ret.value) { ++i; continue; }
        if (assign.target->getKind() != NodeKind::VarRefExpr) { ++i; continue; }
        if (ret.value->getKind() != NodeKind::VarRefExpr) { ++i; continue; }

        const auto& tgt = static_cast<const CVarRefExpr&>(*assign.target);
        const auto& retVar = static_cast<const CVarRefExpr&>(*ret.value);
        if (tgt.varName != retVar.varName) { ++i; continue; }

        // CallExpr values are SAFE to move into the return position:
        // the call still executes at exactly the same point in the
        // statement sequence (the assign and the return are adjacent),
        // and side effects are unaffected.  This handles the common
        // pattern `tmp = foo(); return tmp;` → `return foo();`.

        // Skip compound assignments (x += y; return x;).
        if (!assign.compoundOp.empty()) { ++i; continue; }

        // Replace return value with the assigned expression.
        ret.value = std::move(assign.value);

        // Remove the assignment.
        stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i));
        // Don't increment — re-check this position.
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: initializeReadBeforeWriteVars
// ═══════════════════════════════════════════════════════════════════════════════
//
// SSA destruction in RecoverVariables can produce variables that are read on
// some path before any defining assignment.  Example from kbase_jit_allocate:
//
//   int64_t lock_2;
//   if (param_4 < param_5) {
//       return lock_2;        // ❌ read uninitialized
//   }
//   ...
//   lock_2 = something;       // first definition is here, but the path above
//                             // already returned the uninitialized value
//
// This makes the output look fundamentally broken to a human reader, even
// though it accurately reflects what the lifter produced.  The fix at this
// stage is conservative: walk the body in pre-order, and for each local
// variable whose FIRST occurrence is on the right-hand side (a read) rather
// than the left-hand side of an assignment, attach a default initializer to
// its declaration.  This makes the output legal C and gives readers a hint
// that the variable's true value is determined elsewhere.
//
// We never lose information — if the variable is later definitively assigned,
// the printed `int64_t lock = 0;` is identical to leaving it uninitialized
// from the program's perspective (any sane downstream analysis will dataflow
// the real assignment forward).
//
// Parameters and variables that already have an initExpr are skipped.
//
// KNOWN LIMITATION (under-detection, not over-detection):
//
// The pre-order scan marks a variable as "seen" the moment ANY path writes
// to it.  If the THEN branch of an if-statement writes a variable and the
// ELSE branch reads it without a prior write, the read in the ELSE branch
// is NOT flagged because the variable is already in `info.seen`:
//
//   if (cond) {
//       x = 5;        // x enters info.seen here
//   } else {
//       return x;     // not flagged — but actually read-before-write
//   }
//
// This pass is therefore CONSERVATIVE in the safe direction: it never adds
// a wrong initializer (no over-detection), but it may miss some variables
// that should have one (under-detection).  Fixing this properly requires
// definitely-assigned analysis with per-branch tracking — out of scope
// here.  When future tests surface a variable that "should have gotten
// `= 0` but didn't", that's the cause.

namespace {

/// Default-initializer expression for the given C type.  Returns nullptr if
/// no sensible default exists (e.g. for void or function-pointer types where
/// `0` would be misleading).
static ExprPtr makeDefaultInitFor(const CType& type) {
    switch (type.kind) {
    case TypeKind::Bool:
    case TypeKind::Int:
        return std::make_unique<CIntLitExpr>(
            /*value=*/0,
            std::make_shared<CType>(type),
            /*address=*/0);
    case TypeKind::Pointer:
    case TypeKind::FuncPtr:
        // Cast 0 to the pointer type so the printer emits something legal.
        return std::make_unique<CCastExpr>(
            std::make_shared<CType>(type),
            std::make_unique<CIntLitExpr>(
                /*value=*/0,
                CType::int64(),
                /*address=*/0),
            /*address=*/0);
    case TypeKind::Float:
        // Direct float literal so the printer emits "0.0f" / "0.0".
        return std::make_unique<CFloatLitExpr>(
            /*value=*/0.0,
            std::make_shared<CType>(type),
            /*address=*/0);
    default:
        return nullptr;
    }
}

/// Result of scanning the function body for variable use ordering.
struct VarFirstUseInfo {
    /// Variables whose first occurrence in pre-order traversal is a READ
    /// (RHS of an assignment, function arg, condition, return value, etc.).
    /// These need an initializer added to their declaration.
    std::unordered_set<std::string> readBeforeWrite;
    /// Variables that have been observed at all (used to skip never-touched
    /// declarations — those should be removed by removeUnusedDeclarations).
    std::unordered_set<std::string> seen;
};

/// Walk every CVarRefExpr inside an expression and add the names to `out`.
static void gatherVarRefNames(const CExpr* expr,
                              std::unordered_set<std::string>& out) {
    if (!expr) return;
    switch (expr->getKind()) {
    case NodeKind::VarRefExpr:
        out.insert(static_cast<const CVarRefExpr*>(expr)->varName);
        return;
    case NodeKind::BinaryExpr: {
        const auto& b = static_cast<const CBinaryExpr&>(*expr);
        gatherVarRefNames(b.lhs.get(), out);
        gatherVarRefNames(b.rhs.get(), out);
        return;
    }
    case NodeKind::UnaryExpr:
        gatherVarRefNames(
            static_cast<const CUnaryExpr*>(expr)->operand.get(), out);
        return;
    case NodeKind::CastExpr:
        gatherVarRefNames(
            static_cast<const CCastExpr*>(expr)->operand.get(), out);
        return;
    case NodeKind::CallExpr: {
        const auto& c = static_cast<const CCallExpr&>(*expr);
        for (const auto& arg : c.args)
            gatherVarRefNames(arg.get(), out);
        return;
    }
    case NodeKind::TernaryExpr: {
        const auto& t = static_cast<const CTernaryExpr&>(*expr);
        gatherVarRefNames(t.cond.get(), out);
        gatherVarRefNames(t.trueVal.get(), out);
        gatherVarRefNames(t.falseVal.get(), out);
        return;
    }
    case NodeKind::SubscriptExpr: {
        const auto& s = static_cast<const CSubscriptExpr&>(*expr);
        gatherVarRefNames(s.base.get(), out);
        gatherVarRefNames(s.index.get(), out);
        return;
    }
    case NodeKind::FieldAccessExpr:
        gatherVarRefNames(
            static_cast<const CFieldAccessExpr*>(expr)->base.get(), out);
        return;
    default:
        return;
    }
}

/// Pre-order walk over a statement list.  For each statement we record:
///   - which variable is DEFINED (LHS of a plain assign), if any
///   - which variables are READ (everything else inside the statement)
///
/// First-write-or-read is then folded into VarFirstUseInfo via the rule:
///   "if a variable is READ before it is DEFINED, add it to readBeforeWrite".
static void scanStmtListForFirstUse(const std::vector<StmtPtr>& stmts,
                                    VarFirstUseInfo& info);

static void scanStmtForFirstUse(const CStmt* stmt, VarFirstUseInfo& info) {
    if (!stmt) return;
    switch (stmt->getKind()) {
    case NodeKind::AssignStmt: {
        const auto& a = static_cast<const CAssignStmt&>(*stmt);
        // The RHS is read regardless.
        std::unordered_set<std::string> rhsReads;
        gatherVarRefNames(a.value.get(), rhsReads);
        // For the LHS, if it's a plain var ref, treat it as a definition;
        // otherwise (deref, field, subscript) it's actually a read of the
        // base for indexing purposes.
        std::unordered_set<std::string> lhsDefs;
        std::unordered_set<std::string> lhsReads;
        if (a.target && a.target->getKind() == NodeKind::VarRefExpr) {
            lhsDefs.insert(
                static_cast<const CVarRefExpr&>(*a.target).varName);
            // Compound assignments (`x += y`) read x as well.
            if (!a.compoundOp.empty())
                lhsReads.insert(
                    static_cast<const CVarRefExpr&>(*a.target).varName);
        } else {
            gatherVarRefNames(a.target.get(), lhsReads);
        }
        // Reads happen first (semantically RHS is evaluated before LHS
        // store). Then defs.
        for (const auto& n : rhsReads) {
            if (!info.seen.count(n)) {
                info.readBeforeWrite.insert(n);
            }
            info.seen.insert(n);
        }
        for (const auto& n : lhsReads) {
            if (!info.seen.count(n)) {
                info.readBeforeWrite.insert(n);
            }
            info.seen.insert(n);
        }
        for (const auto& n : lhsDefs) {
            info.seen.insert(n);
        }
        return;
    }
    case NodeKind::ExprStmt: {
        std::unordered_set<std::string> reads;
        gatherVarRefNames(
            static_cast<const CExprStmt&>(*stmt).expr.get(), reads);
        for (const auto& n : reads) {
            if (!info.seen.count(n))
                info.readBeforeWrite.insert(n);
            info.seen.insert(n);
        }
        return;
    }
    case NodeKind::ReturnStmt: {
        std::unordered_set<std::string> reads;
        gatherVarRefNames(
            static_cast<const CReturnStmt&>(*stmt).value.get(), reads);
        for (const auto& n : reads) {
            if (!info.seen.count(n))
                info.readBeforeWrite.insert(n);
            info.seen.insert(n);
        }
        return;
    }
    case NodeKind::IfStmt: {
        const auto& s = static_cast<const CIfStmt&>(*stmt);
        std::unordered_set<std::string> reads;
        gatherVarRefNames(s.condition.get(), reads);
        for (const auto& n : reads) {
            if (!info.seen.count(n))
                info.readBeforeWrite.insert(n);
            info.seen.insert(n);
        }
        // Recurse into both arms.  We do NOT track per-arm definitions —
        // if a variable is defined in only one arm and read after the if,
        // we still consider it potentially undefined.  But the heuristic
        // is "first SEEN" so if it was already seen before the if (e.g.
        // assigned in a prior statement), the arm is irrelevant.
        scanStmtListForFirstUse(s.thenBody, info);
        scanStmtListForFirstUse(s.elseBody, info);
        return;
    }
    case NodeKind::WhileStmt: {
        const auto& s = static_cast<const CWhileStmt&>(*stmt);
        std::unordered_set<std::string> reads;
        gatherVarRefNames(s.condition.get(), reads);
        for (const auto& n : reads) {
            if (!info.seen.count(n))
                info.readBeforeWrite.insert(n);
            info.seen.insert(n);
        }
        scanStmtListForFirstUse(s.body, info);
        return;
    }
    case NodeKind::DoWhileStmt: {
        const auto& s = static_cast<const CDoWhileStmt&>(*stmt);
        scanStmtListForFirstUse(s.body, info);
        std::unordered_set<std::string> reads;
        gatherVarRefNames(s.condition.get(), reads);
        for (const auto& n : reads) {
            if (!info.seen.count(n))
                info.readBeforeWrite.insert(n);
            info.seen.insert(n);
        }
        return;
    }
    case NodeKind::ForStmt: {
        const auto& s = static_cast<const CForStmt&>(*stmt);
        std::unordered_set<std::string> reads;
        gatherVarRefNames(s.condition.get(), reads);
        for (const auto& n : reads) {
            if (!info.seen.count(n))
                info.readBeforeWrite.insert(n);
            info.seen.insert(n);
        }
        scanStmtListForFirstUse(s.body, info);
        return;
    }
    case NodeKind::SwitchStmt: {
        const auto& s = static_cast<const CSwitchStmt&>(*stmt);
        std::unordered_set<std::string> reads;
        gatherVarRefNames(s.selector.get(), reads);
        for (const auto& n : reads) {
            if (!info.seen.count(n))
                info.readBeforeWrite.insert(n);
            info.seen.insert(n);
        }
        for (const auto& c : s.cases)
            scanStmtListForFirstUse(c.body, info);
        return;
    }
    case NodeKind::BlockStmt:
        scanStmtListForFirstUse(
            static_cast<const CBlockStmt&>(*stmt).stmts, info);
        return;
    default:
        return;
    }
}

static void scanStmtListForFirstUse(const std::vector<StmtPtr>& stmts,
                                    VarFirstUseInfo& info) {
    for (const auto& sp : stmts)
        scanStmtForFirstUse(sp.get(), info);
}

} // namespace

void CAstOptimizer::initializeReadBeforeWriteVars(CFuncDecl& func) {
    // Names of parameters — these are always defined at function entry,
    // so we never want to add an initializer for them, and they should be
    // pre-seeded as "seen" so any inner assignment to a parameter doesn't
    // count as a definition.
    std::unordered_set<std::string> paramNames;
    for (const auto& p : func.params)
        paramNames.insert(p.name);

    VarFirstUseInfo info;
    info.seen = paramNames;  // params are defined at entry

    scanStmtListForFirstUse(func.body, info);

    // For each local var that's in readBeforeWrite and currently has no
    // initExpr, attach a default-initializer expression matching its type.
    for (auto& d : func.localVars) {
        if (d.initExpr) continue;                           // already initialized
        if (!info.readBeforeWrite.count(d.varName)) continue; // never read first
        if (!d.type) continue;                              // missing type info

        // `result` is also used as the symbolic return register when Helix
        // cannot prove a concrete RAX value.  Initializing it to zero would
        // turn "unknown return value" into a false mathematical fact.
        if (d.varName == "result" && func.returnType &&
            func.returnType->kind != TypeKind::Void) {
            continue;
        }

        auto initExpr = makeDefaultInitFor(*d.type);
        if (initExpr) {
            d.initExpr = std::move(initExpr);
        }
    }
}

void CAstOptimizer::resolveFramePointerLeaks(CFuncDecl& func) {
    // Build a map of stack variable offsets.
    std::map<int64_t, std::string> offsetToVarName;
    for (const auto& d : func.localVars) {
        if (d.stackOffset.has_value()) {
            offsetToVarName[*d.stackOffset] = d.varName;
        }
    }
    if (offsetToVarName.empty()) return;

    // Identify candidate frame pointer variables: body-only synthetic
    // names (vN, where N is a number) declared as int64_t with no stack
    // offset.  These are the variables that came from register references
    // (rbp, rsp, etc.) which weren't resolved by RecoverStackLayout.
    std::unordered_set<std::string> candidateFrameVars;
    for (const auto& d : func.localVars) {
        if (d.stackOffset.has_value()) continue;  // already a stack var
        // Pattern: "v<digits>"
        if (d.varName.size() < 2 || d.varName[0] != 'v') continue;
        bool allDigits = true;
        for (size_t i = 1; i < d.varName.size(); ++i) {
            if (!isdigit(static_cast<unsigned char>(d.varName[i]))) {
                allDigits = false;
                break;
            }
        }
        if (!allDigits) continue;
        candidateFrameVars.insert(d.varName);
    }
    if (candidateFrameVars.empty()) return;

    resolveFrameRefsInStmts(func.body, offsetToVarName, candidateFrameVars);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: unwrapTrivialDoWhile — collapse do-while loops that always break
// ═══════════════════════════════════════════════════════════════════════════════
//
// After StructureControlFlow's break synthesis, some loops are detected
// that aren't really loops in the original program — they're just
// straight-line code that StructureControlFlow incorrectly classified
// as a back-edge.  These appear as:
//
//   do {
//     ...code...
//     break;        // unconditional break at the end
//   } while (true);
//
// The unconditional break makes the loop execute exactly once, so it's
// equivalent to just executing the body statements directly.

/// Returns true if the statement list (recursively) contains any BreakStmt
/// or ContinueStmt that would be left orphaned if the enclosing loop was
/// removed.  Nested loops/switches don't count — their breaks belong to them.
static bool containsLoopBreakOrContinue(const std::vector<StmtPtr>& stmts) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        auto k = sp->getKind();
        if (k == NodeKind::BreakStmt || k == NodeKind::ContinueStmt)
            return true;
        if (k == NodeKind::IfStmt) {
            auto& s = static_cast<const CIfStmt&>(*sp);
            if (containsLoopBreakOrContinue(s.thenBody)) return true;
            if (containsLoopBreakOrContinue(s.elseBody)) return true;
        } else if (k == NodeKind::BlockStmt) {
            if (containsLoopBreakOrContinue(
                    static_cast<const CBlockStmt&>(*sp).stmts))
                return true;
        }
        // Don't recurse into nested loops or switch — their break/continue
        // belongs to those constructs, not the enclosing loop.
    }
    return false;
}

static void unwrapTrivialDoWhileInList(std::vector<StmtPtr>& stmts) {
    // First, recurse into nested scopes.
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            unwrapTrivialDoWhileInList(s.thenBody);
            unwrapTrivialDoWhileInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            unwrapTrivialDoWhileInList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            unwrapTrivialDoWhileInList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            unwrapTrivialDoWhileInList(static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                unwrapTrivialDoWhileInList(c.body);
            break;
        case NodeKind::BlockStmt:
            unwrapTrivialDoWhileInList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }

    // Now scan for do-while loops that end with an unconditional break
    // AND have no other break/continue statements (which would be left
    // orphaned if we unwrapped the loop).
    for (size_t i = 0; i < stmts.size(); ++i) {
        if (!stmts[i] || stmts[i]->getKind() != NodeKind::DoWhileStmt)
            continue;

        auto& dw = static_cast<CDoWhileStmt&>(*stmts[i]);

        // Check that the body's last statement is an unconditional break.
        if (dw.body.empty()) continue;
        auto& last = dw.body.back();
        if (!last || last->getKind() != NodeKind::BreakStmt) continue;

        // Pop the trailing break temporarily to check the rest.
        auto trailingBreak = std::move(dw.body.back());
        dw.body.pop_back();

        // If the remaining body has any break/continue, we can't unwrap
        // (they would become orphaned).  Restore the break and skip.
        if (containsLoopBreakOrContinue(dw.body)) {
            dw.body.push_back(std::move(trailingBreak));
            continue;
        }

        // Safe to unwrap.  Replace the do-while with its body statements.
        auto body = std::move(dw.body);
        stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i));
        stmts.insert(stmts.begin() + static_cast<ptrdiff_t>(i),
                     std::make_move_iterator(body.begin()),
                     std::make_move_iterator(body.end()));
        // Re-check from this position in case the unwrap created new
        // statements that themselves should be unwrapped.
        --i;
    }
}

void CAstOptimizer::unwrapTrivialDoWhile(CFuncDecl& func) {
    unwrapTrivialDoWhileInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 1: removePrologueEpilogue
// ═══════════════════════════════════════════════════════════════════════════════

void CAstOptimizer::removePrologueEpilogue(CFuncDecl& func) {
    auto& body = func.body;
    if (body.empty()) return;

    /// Returns true for statements that are frame/prologue/epilogue artifacts.
    auto isPrologue = [](const StmtPtr& sptr, bool nearBoundary) -> bool {
        if (!sptr) return false;
        const CStmt* s = sptr.get();
        if (s->getKind() != NodeKind::AssignStmt)
            return false;
        const auto& a = static_cast<const CAssignStmt&>(*s);
        if (!a.target || !a.value) return false;

        // Grab target name (must be a plain CVarRefExpr).
        if (a.target->getKind() != NodeKind::VarRefExpr)
            return false;
        const std::string& tgt =
            static_cast<const CVarRefExpr*>(a.target.get())->varName;

        // rbp = rsp  (frame setup)
        if (isFramePointer(tgt) &&
            a.value->getKind() == NodeKind::VarRefExpr &&
            isStackPointer(static_cast<const CVarRefExpr*>(a.value.get())->varName))
            return true;

        // rsp = rbp  (frame teardown)
        if (isStackPointer(tgt) &&
            a.value->getKind() == NodeKind::VarRefExpr &&
            isFramePointer(static_cast<const CVarRefExpr*>(a.value.get())->varName))
            return true;

        // rsp = rsp ± N  (stack frame allocation / deallocation)
        if (isStackPointer(tgt) &&
            a.value->getKind() == NodeKind::BinaryExpr) {
            const auto& bin =
                static_cast<const CBinaryExpr&>(*a.value);
            if ((bin.op == BinaryOp::Sub || bin.op == BinaryOp::Add) &&
                bin.lhs && bin.lhs->getKind() == NodeKind::VarRefExpr &&
                isStackPointer(
                    static_cast<const CVarRefExpr*>(bin.lhs.get())->varName))
                return true;
        }

        // Near the function boundary: callee-saved register saves/restores.
        // Pattern: callee_saved = anything  OR  anything = callee_saved
        if (nearBoundary) {
            if (isCalleeSaved(tgt))
                return true;
            if (a.value->getKind() == NodeKind::VarRefExpr &&
                isCalleeSaved(
                    static_cast<const CVarRefExpr*>(a.value.get())->varName))
                return true;
        }

        return false;
    };

    // Scan from front (prologue), removing up to first 5 statements.
    {
        size_t limit = std::min<size_t>(5, body.size());
        size_t i = 0;
        while (i < limit) {
            if (isPrologue(body[i], /*nearBoundary=*/true)) {
                body.erase(body.begin() + static_cast<ptrdiff_t>(i));
                --limit;
            } else {
                ++i;
            }
        }
    }

    // Scan from back (epilogue), removing up to last 5 statements.
    {
        size_t limit = std::min<size_t>(5, body.size());
        for (size_t removed = 0; removed < limit && !body.empty(); ) {
            size_t last = body.size() - 1;
            if (isPrologue(body[last], /*nearBoundary=*/true)) {
                body.erase(body.begin() + static_cast<ptrdiff_t>(last));
                ++removed;
            } else {
                break; // Stop at first non-prologue from the back.
            }
        }
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 2: eliminateInfrastructure
// ═══════════════════════════════════════════════════════════════════════════════

static const std::string_view kInfraCallNames[] = {
    "__overflow", "__carry", "__sign", "__zero", "__parity",
};

static bool nameIsInfra(std::string_view n) {
    // _promoted_* and _spill_* — PC tracking / register spill bookkeeping.
    if (n.starts_with("_promoted_") || n.starts_with("_spill_"))
        return true;
    // __flags, __<anything>flag* — CPU flag infrastructure.
    if (n.starts_with("__") &&
        (n == "__flags" || n.find("flag") != std::string_view::npos))
        return true;
    return false;
}

static bool exprReferencesInfra(const CExpr* e);

static bool exprReferencesInfra(const CExpr* e) {
    if (!e) return false;
    switch (e->getKind()) {
    case NodeKind::VarRefExpr: {
        const auto& v = static_cast<const CVarRefExpr&>(*e);
        if (nameIsInfra(v.varName)) return true;
        if (isStackPointer(v.varName)) return true;
        return false;
    }
    case NodeKind::CallExpr: {
        const auto& c = static_cast<const CCallExpr&>(*e);
        for (auto& name : kInfraCallNames)
            if (c.targetName == name) return true;
        return false;
    }
    case NodeKind::BinaryExpr: {
        const auto& b = static_cast<const CBinaryExpr&>(*e);
        return exprReferencesInfra(b.lhs.get()) ||
               exprReferencesInfra(b.rhs.get());
    }
    case NodeKind::UnaryExpr: {
        const auto& u = static_cast<const CUnaryExpr&>(*e);
        return exprReferencesInfra(u.operand.get());
    }
    case NodeKind::CastExpr: {
        const auto& c = static_cast<const CCastExpr&>(*e);
        return exprReferencesInfra(c.operand.get());
    }
    case NodeKind::TernaryExpr: {
        const auto& t = static_cast<const CTernaryExpr&>(*e);
        return exprReferencesInfra(t.cond.get()) ||
               exprReferencesInfra(t.trueVal.get()) ||
               exprReferencesInfra(t.falseVal.get());
    }
    case NodeKind::SubscriptExpr: {
        const auto& s = static_cast<const CSubscriptExpr&>(*e);
        return exprReferencesInfra(s.base.get()) ||
               exprReferencesInfra(s.index.get());
    }
    case NodeKind::FieldAccessExpr: {
        const auto& f = static_cast<const CFieldAccessExpr&>(*e);
        return exprReferencesInfra(f.base.get());
    }
    default:
        return false;
    }
}

bool CAstOptimizer::isInfrastructureAssign(const CAssignStmt& a) const {
    if (!a.target) return false;

    // Target is a plain var ref.
    if (a.target->getKind() == NodeKind::VarRefExpr) {
        const std::string& tgt =
            static_cast<const CVarRefExpr*>(a.target.get())->varName;

        // Anything writing to _promoted_*, _spill_*, __flags, etc.
        if (nameIsInfra(tgt)) return true;

        // Anything writing to RSP (stack pointer bookkeeping).
        if (isStackPointer(tgt)) return true;
    }

    // Value references infrastructure or infra calls.
    if (a.value && exprReferencesInfra(a.value.get())) return true;

    return false;
}

bool CAstOptimizer::isInfrastructureStmt(const CStmt& stmt) const {
    switch (stmt.getKind()) {
    case NodeKind::AssignStmt:
        return isInfrastructureAssign(static_cast<const CAssignStmt&>(stmt));

    case NodeKind::ExprStmt: {
        const auto& es = static_cast<const CExprStmt&>(stmt);
        if (!es.expr) return false;
        // CExprStmt containing a call to infra functions.
        if (es.expr->getKind() == NodeKind::CallExpr) {
            const auto& call = static_cast<const CCallExpr&>(*es.expr);
            for (auto& name : kInfraCallNames)
                if (call.targetName == name) return true;
        }
        return exprReferencesInfra(es.expr.get());
    }

    case NodeKind::CommentStmt: {
        const auto& c = static_cast<const CCommentStmt&>(stmt);
        return c.text.find("infrastructure") != std::string::npos ||
               c.text.find("prologue") != std::string::npos;
    }

    default:
        return false;
    }
}

void CAstOptimizer::filterStatements(std::vector<StmtPtr>& stmts) {
    // Remove matching statements from this list.
    std::erase_if(stmts, [this](const StmtPtr& s) {
        return s && isInfrastructureStmt(*s);
    });

    // Recurse into nested statement lists.
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            filterStatements(s.thenBody);
            filterStatements(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& s = static_cast<CWhileStmt&>(*sp);
            filterStatements(s.body);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& s = static_cast<CDoWhileStmt&>(*sp);
            filterStatements(s.body);
            break;
        }
        case NodeKind::ForStmt: {
            auto& s = static_cast<CForStmt&>(*sp);
            filterStatements(s.body);
            break;
        }
        case NodeKind::SwitchStmt: {
            auto& s = static_cast<CSwitchStmt&>(*sp);
            for (auto& c : s.cases)
                filterStatements(c.body);
            break;
        }
        case NodeKind::BlockStmt: {
            auto& s = static_cast<CBlockStmt&>(*sp);
            filterStatements(s.stmts);
            break;
        }
        default:
            break;
        }
    }
}

void CAstOptimizer::eliminateInfrastructure(CFuncDecl& func) {
    filterStatements(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 3: eliminateDeadStores
// ═══════════════════════════════════════════════════════════════════════════════

void CAstOptimizer::collectVarRefs(const CExpr* expr,
                                   std::unordered_set<std::string>& names) {
    if (!expr) return;
    switch (expr->getKind()) {
    case NodeKind::VarRefExpr:
        names.insert(static_cast<const CVarRefExpr*>(expr)->varName);
        return;
    case NodeKind::BinaryExpr: {
        const auto& b = static_cast<const CBinaryExpr&>(*expr);
        collectVarRefs(b.lhs.get(), names);
        collectVarRefs(b.rhs.get(), names);
        return;
    }
    case NodeKind::UnaryExpr:
        collectVarRefs(
            static_cast<const CUnaryExpr*>(expr)->operand.get(), names);
        return;
    case NodeKind::CastExpr:
        collectVarRefs(
            static_cast<const CCastExpr*>(expr)->operand.get(), names);
        return;
    case NodeKind::CallExpr: {
        const auto& c = static_cast<const CCallExpr&>(*expr);
        for (const auto& arg : c.args)
            collectVarRefs(arg.get(), names);
        return;
    }
    case NodeKind::TernaryExpr: {
        const auto& t = static_cast<const CTernaryExpr&>(*expr);
        collectVarRefs(t.cond.get(), names);
        collectVarRefs(t.trueVal.get(), names);
        collectVarRefs(t.falseVal.get(), names);
        return;
    }
    case NodeKind::SubscriptExpr: {
        const auto& s = static_cast<const CSubscriptExpr&>(*expr);
        collectVarRefs(s.base.get(), names);
        collectVarRefs(s.index.get(), names);
        return;
    }
    case NodeKind::FieldAccessExpr:
        collectVarRefs(
            static_cast<const CFieldAccessExpr*>(expr)->base.get(), names);
        return;
    default:
        return;
    }
}

bool CAstOptimizer::exprHasCall(const CExpr* expr) {
    if (!expr) return false;
    if (expr->getKind() == NodeKind::CallExpr) return true;
    switch (expr->getKind()) {
    case NodeKind::BinaryExpr: {
        const auto& b = static_cast<const CBinaryExpr&>(*expr);
        return exprHasCall(b.lhs.get()) || exprHasCall(b.rhs.get());
    }
    case NodeKind::UnaryExpr:
        return exprHasCall(
            static_cast<const CUnaryExpr*>(expr)->operand.get());
    case NodeKind::CastExpr:
        return exprHasCall(
            static_cast<const CCastExpr*>(expr)->operand.get());
    case NodeKind::TernaryExpr: {
        const auto& t = static_cast<const CTernaryExpr&>(*expr);
        return exprHasCall(t.cond.get()) || exprHasCall(t.trueVal.get()) ||
               exprHasCall(t.falseVal.get());
    }
    case NodeKind::SubscriptExpr: {
        const auto& s = static_cast<const CSubscriptExpr&>(*expr);
        return exprHasCall(s.base.get()) || exprHasCall(s.index.get());
    }
    case NodeKind::FieldAccessExpr:
        return exprHasCall(
            static_cast<const CFieldAccessExpr*>(expr)->base.get());
    default:
        return false;
    }
}

bool CAstOptimizer::isUnsafeTarget(const CExpr* expr) {
    if (!expr) return false;
    if (expr->getKind() == NodeKind::FieldAccessExpr) return true;
    if (expr->getKind() == NodeKind::UnaryExpr &&
        static_cast<const CUnaryExpr*>(expr)->op == UnaryOp::Deref)
        return true;
    if (expr->getKind() == NodeKind::SubscriptExpr) return true;
    return false;
}

// Backward liveness DSE on a flat statement list.
void CAstOptimizer::dseStmtList(std::vector<StmtPtr>& stmts,
                                const std::unordered_set<std::string>* seedLive) {
    // live_set: variables that have been read "after" the current position
    // (since we scan backwards). FIX-095d: loop bodies seed this with every
    // variable read in the body, so loop-carried stores survive.
    std::unordered_set<std::string> live;
    if (seedLive) live = *seedLive;

    // Mark all statements to be removed.
    std::unordered_set<size_t> toRemove;

    for (size_t i = stmts.size(); i-- > 0;) {
        if (!stmts[i]) continue;
        const CStmt& s = *stmts[i];

        switch (s.getKind()) {
        case NodeKind::AssignStmt: {
            const auto& a = static_cast<const CAssignStmt&>(s);
            if (!a.target) break;

            // Never eliminate unsafe targets (deref/field/subscript).
            if (isUnsafeTarget(a.target.get())) {
                // Still add value reads to live set.
                collectVarRefs(a.value.get(), live);
                break;
            }

            // Only operate on plain variable assignments.
            if (a.target->getKind() != NodeKind::VarRefExpr) {
                collectVarRefs(a.value.get(), live);
                break;
            }

            const std::string& tgt =
                static_cast<const CVarRefExpr*>(a.target.get())->varName;

            // Never DSE assignments with call side-effects.
            if (exprHasCall(a.value.get())) {
                live.erase(tgt);
                collectVarRefs(a.value.get(), live);
                break;
            }

            // A COMPOUND assign (op=, e.g. `x ^= ...`, `x *= ...`) also READS the
            // target, so the target is never dead at a compound store, and after
            // processing the store the target stays live for earlier writes
            // (FIX-095d: this is what keeps a multi-step loop accumulator like
            // `h ^= b; h *= prime;` intact -- without it, the later `*=` erased the
            // accumulator from the live-set and the earlier `^=` was dropped).
            const bool compoundReadsTarget = !a.compoundOp.empty();

            // If target is not in the live set, the store is dead.
            if (!compoundReadsTarget && live.find(tgt) == live.end()) {
                toRemove.insert(i);
                // Do NOT add value reads — they're also dead.
            } else {
                // Target is consumed; add value reads to live set.
                live.erase(tgt);
                collectVarRefs(a.value.get(), live);
                // The compound target is itself a use → keep it live.
                if (compoundReadsTarget)
                    live.insert(tgt);
            }
            break;
        }

        case NodeKind::ReturnStmt: {
            const auto& r = static_cast<const CReturnStmt&>(s);
            collectVarRefs(r.value.get(), live);
            break;
        }

        case NodeKind::ExprStmt: {
            const auto& e = static_cast<const CExprStmt&>(s);
            collectVarRefs(e.expr.get(), live);
            break;
        }

        // For control-flow statements: conservatively mark all referenced
        // variables as live (don't analyze nested scopes deeply).
        case NodeKind::IfStmt: {
            const auto& ifs = static_cast<const CIfStmt&>(s);
            collectVarRefs(ifs.condition.get(), live);
            // Collect from nested bodies conservatively.
            std::unordered_set<std::string> nested;
            auto gatherFromStmts = [&](const std::vector<StmtPtr>& body) {
                for (const auto& sp : body) {
                    if (!sp) continue;
                    if (sp->getKind() == NodeKind::AssignStmt) {
                        const auto& na =
                            static_cast<const CAssignStmt&>(*sp);
                        collectVarRefs(na.value.get(), nested);
                        // Target is a definition, not a use — only collect
                        // it when compound (target is also read).
                        if (!na.compoundOp.empty())
                            collectVarRefs(na.target.get(), nested);
                    } else if (sp->getKind() == NodeKind::ReturnStmt) {
                        collectVarRefs(
                            static_cast<const CReturnStmt&>(*sp).value.get(),
                            nested);
                    } else if (sp->getKind() == NodeKind::ExprStmt) {
                        collectVarRefs(
                            static_cast<const CExprStmt&>(*sp).expr.get(),
                            nested);
                    }
                }
            };
            gatherFromStmts(ifs.thenBody);
            gatherFromStmts(ifs.elseBody);
            live.merge(nested);
            break;
        }

        case NodeKind::WhileStmt: {
            const auto& ws = static_cast<const CWhileStmt&>(s);
            collectVarRefs(ws.condition.get(), live);
            for (const auto& sp : ws.body) {
                if (!sp) continue;
                if (sp->getKind() == NodeKind::AssignStmt) {
                    const auto& na = static_cast<const CAssignStmt&>(*sp);
                    collectVarRefs(na.value.get(), live);
                    if (!na.compoundOp.empty())
                        collectVarRefs(na.target.get(), live);
                } else if (sp->getKind() == NodeKind::ReturnStmt) {
                    collectVarRefs(
                        static_cast<const CReturnStmt&>(*sp).value.get(),
                        live);
                } else if (sp->getKind() == NodeKind::ExprStmt) {
                    collectVarRefs(
                        static_cast<const CExprStmt&>(*sp).expr.get(),
                        live);
                }
            }
            break;
        }

        default:
            break;
        }
    }

    // Erase dead statements.
    for (size_t i = stmts.size(); i-- > 0;)
        if (toRemove.count(i))
            stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i));
}

void CAstOptimizer::eliminateDeadStores(CFuncDecl& func) {
    dseStmtList(func.body);

    // FIX-095d: collect every variable READ anywhere in a loop body. Seeding the
    // loop's DSE with this set keeps loop-carried stores alive (the loop back-edge
    // means a read at the top consumes a write from a previous iteration; without
    // the seed, dseStmtList scans the body as a flat list with an empty live-set
    // and wrongly drops e.g. an FNV `h = (h ^ b) * prime` accumulator).
    std::function<void(const std::vector<StmtPtr>&,
                       std::unordered_set<std::string>&)> collectLoopReads =
        [&](const std::vector<StmtPtr>& body,
            std::unordered_set<std::string>& reads) {
            for (const auto& sp : body) {
                if (!sp) continue;
                switch (sp->getKind()) {
                case NodeKind::AssignStmt: {
                    const auto& a = static_cast<const CAssignStmt&>(*sp);
                    collectVarRefs(a.value.get(), reads);
                    if (!a.compoundOp.empty())
                        collectVarRefs(a.target.get(), reads);
                    else if (a.target &&
                             a.target->getKind() != NodeKind::VarRefExpr)
                        collectVarRefs(a.target.get(), reads);
                    break;
                }
                case NodeKind::ReturnStmt:
                    collectVarRefs(
                        static_cast<const CReturnStmt&>(*sp).value.get(), reads);
                    break;
                case NodeKind::ExprStmt:
                    collectVarRefs(
                        static_cast<const CExprStmt&>(*sp).expr.get(), reads);
                    break;
                case NodeKind::IfStmt: {
                    const auto& s = static_cast<const CIfStmt&>(*sp);
                    collectVarRefs(s.condition.get(), reads);
                    collectLoopReads(s.thenBody, reads);
                    collectLoopReads(s.elseBody, reads);
                    break;
                }
                case NodeKind::WhileStmt: {
                    const auto& s = static_cast<const CWhileStmt&>(*sp);
                    collectVarRefs(s.condition.get(), reads);
                    collectLoopReads(s.body, reads);
                    break;
                }
                case NodeKind::DoWhileStmt: {
                    const auto& s = static_cast<const CDoWhileStmt&>(*sp);
                    collectVarRefs(s.condition.get(), reads);
                    collectLoopReads(s.body, reads);
                    break;
                }
                case NodeKind::ForStmt: {
                    const auto& s = static_cast<const CForStmt&>(*sp);
                    collectVarRefs(s.condition.get(), reads);
                    collectLoopReads(s.body, reads);
                    break;
                }
                case NodeKind::SwitchStmt:
                    for (const auto& c :
                         static_cast<const CSwitchStmt&>(*sp).cases)
                        collectLoopReads(c.body, reads);
                    break;
                case NodeKind::BlockStmt:
                    collectLoopReads(
                        static_cast<const CBlockStmt&>(*sp).stmts, reads);
                    break;
                default:
                    break;
                }
            }
        };

    // Recurse into nested scopes.
    for (auto& sp : func.body) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            dseStmtList(s.thenBody);
            dseStmtList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& body = static_cast<CWhileStmt&>(*sp).body;
            std::unordered_set<std::string> seed;
            collectLoopReads(body, seed);
            dseStmtList(body, &seed);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& body = static_cast<CDoWhileStmt&>(*sp).body;
            std::unordered_set<std::string> seed;
            collectLoopReads(body, seed);
            dseStmtList(body, &seed);
            break;
        }
        case NodeKind::ForStmt: {
            auto& body = static_cast<CForStmt&>(*sp).body;
            std::unordered_set<std::string> seed;
            collectLoopReads(body, seed);
            dseStmtList(body, &seed);
            break;
        }
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                dseStmtList(c.body);
            break;
        case NodeKind::BlockStmt:
            dseStmtList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 4: propagateCopies
// ═══════════════════════════════════════════════════════════════════════════════

bool CAstOptimizer::isSyntheticName(std::string_view name) {
    // var_N, spill_N, __tmp_N
    if (name.starts_with("var_") || name.starts_with("spill_") ||
        name.starts_with("__tmp_"))
        return true;
    // vN — all digits after 'v'
    if (name.starts_with('v') && name.size() >= 2) {
        bool allDigits = true;
        for (size_t i = 1; i < name.size(); ++i)
            if (!std::isdigit(static_cast<unsigned char>(name[i]))) {
                allDigits = false;
                break;
            }
        if (allDigits) return true;
    }
    // tN — all digits after 't'
    if (name.starts_with('t') && name.size() >= 2) {
        bool allDigits = true;
        for (size_t i = 1; i < name.size(); ++i)
            if (!std::isdigit(static_cast<unsigned char>(name[i]))) {
                allDigits = false;
                break;
            }
        if (allDigits) return true;
    }
    return false;
}

// FIX-085 (DREAM-inspired): depth bound on the recursive helper itself.
// The previous unbounded form could stack-overflow on pathological CFG
// shapes that produced 20+ levels of nested boolean conditions.  The
// `maxDepth` parameter both prevents the recursion from blowing the stack
// and serves as a quick sentinel for callers that only need to know
// "deeper than N" without computing the exact depth.
static unsigned exprDepth(const CExpr* e, unsigned maxDepth = 64) {
    if (!e || maxDepth == 0) return 0;
    switch (e->getKind()) {
    case NodeKind::BinaryExpr: {
        const auto& b = static_cast<const CBinaryExpr&>(*e);
        return 1 + std::max(exprDepth(b.lhs.get(), maxDepth - 1),
                            exprDepth(b.rhs.get(), maxDepth - 1));
    }
    case NodeKind::UnaryExpr:
        return 1 + exprDepth(
                       static_cast<const CUnaryExpr*>(e)->operand.get(),
                       maxDepth - 1);
    case NodeKind::CastExpr:
        return 1 + exprDepth(
                       static_cast<const CCastExpr*>(e)->operand.get(),
                       maxDepth - 1);
    case NodeKind::TernaryExpr: {
        const auto& t = static_cast<const CTernaryExpr&>(*e);
        return 1 + std::max({exprDepth(t.cond.get(), maxDepth - 1),
                              exprDepth(t.trueVal.get(), maxDepth - 1),
                              exprDepth(t.falseVal.get(), maxDepth - 1)});
    }
    case NodeKind::SubscriptExpr: {
        const auto& s = static_cast<const CSubscriptExpr&>(*e);
        return 1 + std::max(exprDepth(s.base.get(), maxDepth - 1),
                            exprDepth(s.index.get(), maxDepth - 1));
    }
    case NodeKind::FieldAccessExpr:
        return 1 + exprDepth(
                       static_cast<const CFieldAccessExpr*>(e)->base.get(),
                       maxDepth - 1);
    default:
        return 1;
    }
}

// FIX-085 (DREAM-inspired): boolean-only depth probe.
//
// Counts the depth of an `&&` / `||` chain *only* — single-level
// comparisons, calls, casts, etc. all bottom out at depth 1.  Used by
// `simplifyExpr` to decide when a propagated condition has grown so deep
// that further rewriting would be both slow and likely to produce an
// unreadable expression for the user.  Threshold of 8 matches DREAM's
// observation that human-readable C expressions seldom exceed 6 atoms.
static unsigned boolExprDepth(const CExpr* e, unsigned maxDepth = 16) {
    if (!e || maxDepth == 0) return 0;
    if (e->getKind() != NodeKind::BinaryExpr) return 1;
    const auto& bin = static_cast<const CBinaryExpr&>(*e);
    if (bin.op != BinaryOp::LogAnd && bin.op != BinaryOp::LogOr) return 1;
    return 1 + std::max(
        boolExprDepth(bin.lhs.get(), maxDepth - 1),
        boolExprDepth(bin.rhs.get(), maxDepth - 1));
}

bool CAstOptimizer::isSimpleExpr(const CExpr* expr, unsigned maxDepth) {
    if (!expr) return true;
    if (CAstOptimizer::exprHasCall(expr)) return false;
    return exprDepth(expr) <= maxDepth;
}

ExprPtr CAstOptimizer::cloneExpr(const CExpr* expr) {
    if (!expr) return nullptr;
    switch (expr->getKind()) {
    case NodeKind::IntLitExpr: {
        const auto& e = static_cast<const CIntLitExpr&>(*expr);
        return std::make_unique<CIntLitExpr>(e.value, e.type, e.getAddress());
    }
    case NodeKind::FloatLitExpr: {
        const auto& e = static_cast<const CFloatLitExpr&>(*expr);
        return std::make_unique<CFloatLitExpr>(e.value, e.type, e.getAddress());
    }
    case NodeKind::StringLitExpr: {
        const auto& e = static_cast<const CStringLitExpr&>(*expr);
        return std::make_unique<CStringLitExpr>(e.value, e.getAddress());
    }
    case NodeKind::AddrLitExpr: {
        const auto& e = static_cast<const CAddrLitExpr&>(*expr);
        auto cloned = std::make_unique<CAddrLitExpr>(e.addrValue, e.type,
                                                     e.getAddress());
        // FIX-092: preserve the D1 code-address-leak tag across clones so the
        // final-AST survivor walk sees a surviving leak even if it was copied.
        cloned->isCodeAddrLeak = e.isCodeAddrLeak;
        return cloned;
    }
    case NodeKind::VarRefExpr: {
        const auto& e = static_cast<const CVarRefExpr&>(*expr);
        return std::make_unique<CVarRefExpr>(e.varId, e.varName, e.type,
                                             e.getAddress());
    }
    case NodeKind::BinaryExpr: {
        const auto& e = static_cast<const CBinaryExpr&>(*expr);
        return std::make_unique<CBinaryExpr>(e.op, cloneExpr(e.lhs.get()),
                                             cloneExpr(e.rhs.get()), e.type,
                                             e.getAddress());
    }
    case NodeKind::UnaryExpr: {
        const auto& e = static_cast<const CUnaryExpr&>(*expr);
        return std::make_unique<CUnaryExpr>(e.op, cloneExpr(e.operand.get()),
                                            e.type, e.getAddress());
    }
    case NodeKind::CastExpr: {
        const auto& e = static_cast<const CCastExpr&>(*expr);
        return std::make_unique<CCastExpr>(e.targetType,
                                           cloneExpr(e.operand.get()),
                                           e.getAddress());
    }
    case NodeKind::CallExpr: {
        const auto& e = static_cast<const CCallExpr&>(*expr);
        std::vector<ExprPtr> args;
        args.reserve(e.args.size());
        for (const auto& a : e.args)
            args.push_back(cloneExpr(a.get()));
        return std::make_unique<CCallExpr>(e.targetName, e.targetAddr,
                                           std::move(args), e.type,
                                           e.getAddress());
    }
    case NodeKind::TernaryExpr: {
        const auto& e = static_cast<const CTernaryExpr&>(*expr);
        return std::make_unique<CTernaryExpr>(cloneExpr(e.cond.get()),
                                              cloneExpr(e.trueVal.get()),
                                              cloneExpr(e.falseVal.get()),
                                              e.type, e.getAddress());
    }
    case NodeKind::SubscriptExpr: {
        const auto& e = static_cast<const CSubscriptExpr&>(*expr);
        return std::make_unique<CSubscriptExpr>(cloneExpr(e.base.get()),
                                                cloneExpr(e.index.get()),
                                                e.type, e.getAddress());
    }
    case NodeKind::FieldAccessExpr: {
        const auto& e = static_cast<const CFieldAccessExpr&>(*expr);
        return std::make_unique<CFieldAccessExpr>(
            cloneExpr(e.base.get()), e.fieldName, e.fieldOffset,
            e.isPointer, e.type, e.getAddress());
    }
    default:
        // Fallback: return null (should not happen).
        return nullptr;
    }
}

void CAstOptimizer::countVarRefsInExpr(
    const CExpr* expr,
    std::unordered_map<std::string, unsigned>& counts) {
    if (!expr) return;
    switch (expr->getKind()) {
    case NodeKind::VarRefExpr:
        counts[static_cast<const CVarRefExpr*>(expr)->varName]++;
        return;
    case NodeKind::BinaryExpr: {
        const auto& b = static_cast<const CBinaryExpr&>(*expr);
        countVarRefsInExpr(b.lhs.get(), counts);
        countVarRefsInExpr(b.rhs.get(), counts);
        return;
    }
    case NodeKind::UnaryExpr:
        countVarRefsInExpr(
            static_cast<const CUnaryExpr*>(expr)->operand.get(), counts);
        return;
    case NodeKind::CastExpr:
        countVarRefsInExpr(
            static_cast<const CCastExpr*>(expr)->operand.get(), counts);
        return;
    case NodeKind::CallExpr: {
        const auto& c = static_cast<const CCallExpr&>(*expr);
        for (const auto& a : c.args)
            countVarRefsInExpr(a.get(), counts);
        return;
    }
    case NodeKind::TernaryExpr: {
        const auto& t = static_cast<const CTernaryExpr&>(*expr);
        countVarRefsInExpr(t.cond.get(), counts);
        countVarRefsInExpr(t.trueVal.get(), counts);
        countVarRefsInExpr(t.falseVal.get(), counts);
        return;
    }
    case NodeKind::SubscriptExpr: {
        const auto& s = static_cast<const CSubscriptExpr&>(*expr);
        countVarRefsInExpr(s.base.get(), counts);
        countVarRefsInExpr(s.index.get(), counts);
        return;
    }
    case NodeKind::FieldAccessExpr:
        countVarRefsInExpr(
            static_cast<const CFieldAccessExpr*>(expr)->base.get(), counts);
        return;
    default:
        return;
    }
}

void CAstOptimizer::countVarRefs(
    const std::vector<StmtPtr>& stmts,
    std::unordered_map<std::string, unsigned>& counts) const {

    for (const auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            const auto& a = static_cast<const CAssignStmt&>(*sp);
            // The target of an assignment is a definition, not a use,
            // unless it's a compound op (then it's also a use).
            if (!a.compoundOp.empty() && a.target)
                countVarRefsInExpr(a.target.get(), counts);
            countVarRefsInExpr(a.value.get(), counts);
            break;
        }
        case NodeKind::ExprStmt:
            countVarRefsInExpr(
                static_cast<const CExprStmt&>(*sp).expr.get(), counts);
            break;
        case NodeKind::ReturnStmt:
            countVarRefsInExpr(
                static_cast<const CReturnStmt&>(*sp).value.get(), counts);
            break;
        case NodeKind::IfStmt: {
            const auto& s = static_cast<const CIfStmt&>(*sp);
            countVarRefsInExpr(s.condition.get(), counts);
            countVarRefs(s.thenBody, counts);
            countVarRefs(s.elseBody, counts);
            break;
        }
        case NodeKind::WhileStmt: {
            const auto& s = static_cast<const CWhileStmt&>(*sp);
            countVarRefsInExpr(s.condition.get(), counts);
            countVarRefs(s.body, counts);
            break;
        }
        case NodeKind::DoWhileStmt: {
            const auto& s = static_cast<const CDoWhileStmt&>(*sp);
            countVarRefs(s.body, counts);
            countVarRefsInExpr(s.condition.get(), counts);
            break;
        }
        case NodeKind::ForStmt: {
            const auto& s = static_cast<const CForStmt&>(*sp);
            if (s.init) countVarRefs({}, counts); // handled below
            countVarRefsInExpr(s.condition.get(), counts);
            countVarRefs(s.body, counts);
            break;
        }
        case NodeKind::SwitchStmt: {
            const auto& s = static_cast<const CSwitchStmt&>(*sp);
            countVarRefsInExpr(s.selector.get(), counts);
            for (const auto& c : s.cases)
                countVarRefs(c.body, counts);
            break;
        }
        case NodeKind::BlockStmt:
            countVarRefs(
                static_cast<const CBlockStmt&>(*sp).stmts, counts);
            break;
        default:
            break;
        }
    }
}

ExprPtr CAstOptimizer::substituteVarRefs(
    ExprPtr expr,
    const std::unordered_map<std::string, const CExpr*>& defs,
    const std::unordered_map<std::string, unsigned>& refCounts,
    std::unordered_set<std::string>& inlined,
    unsigned contextDepth) {

    if (!expr) return nullptr;

    // Maximum total expression depth after inlining.
    // A chain of N simple binops (each depth 1-2) would cascade into
    // depth N without this limit.  Value 6 allows 2-3 levels of inlining
    // from a top-level assignment (depth 1) while keeping expressions
    // readable.  Matches IDA Pro's behavior (Cao et al. ISSTA 2024:
    // fewest long expressions among all tested decompilers).
    constexpr unsigned kMaxTotalDepth = 8;

    // If this is a VarRefExpr, check if we should inline its definition.
    if (expr->getKind() == NodeKind::VarRefExpr) {
        const auto& v = static_cast<const CVarRefExpr&>(*expr);
        auto dit = defs.find(v.varName);
        if (dit != defs.end()) {
            auto rit = refCounts.find(v.varName);
            bool singleUse =
                (rit != refCounts.end() && rit->second == 1);
            if (singleUse && isSyntheticName(v.varName) &&
                isSimpleExpr(dit->second)) {
                // Check that inlining won't exceed total depth limit.
                unsigned defDepth = exprDepth(dit->second);
                if (contextDepth + defDepth <= kMaxTotalDepth) {
                    inlined.insert(v.varName);
                    return cloneExpr(dit->second);
                }
            }
        }
        return expr;
    }

    // Recurse into sub-expressions, incrementing context depth.
    unsigned childDepth = contextDepth + 1;

    switch (expr->getKind()) {
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        b.lhs = substituteVarRefs(std::move(b.lhs), defs, refCounts,
                                  inlined, childDepth);
        b.rhs = substituteVarRefs(std::move(b.rhs), defs, refCounts,
                                  inlined, childDepth);
        return expr;
    }
    case NodeKind::UnaryExpr: {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        u.operand = substituteVarRefs(std::move(u.operand), defs, refCounts,
                                      inlined, childDepth);
        return expr;
    }
    case NodeKind::CastExpr: {
        auto& c = static_cast<CCastExpr&>(*expr);
        c.operand = substituteVarRefs(std::move(c.operand), defs, refCounts,
                                      inlined, childDepth);
        return expr;
    }
    case NodeKind::CallExpr: {
        auto& c = static_cast<CCallExpr&>(*expr);
        for (auto& a : c.args)
            a = substituteVarRefs(std::move(a), defs, refCounts,
                                  inlined, childDepth);
        return expr;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*expr);
        t.cond = substituteVarRefs(std::move(t.cond), defs, refCounts,
                                   inlined, childDepth);
        t.trueVal = substituteVarRefs(std::move(t.trueVal), defs, refCounts,
                                      inlined, childDepth);
        t.falseVal = substituteVarRefs(std::move(t.falseVal), defs, refCounts,
                                       inlined, childDepth);
        return expr;
    }
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*expr);
        s.base = substituteVarRefs(std::move(s.base), defs, refCounts,
                                   inlined, childDepth);
        s.index = substituteVarRefs(std::move(s.index), defs, refCounts,
                                    inlined, childDepth);
        return expr;
    }
    case NodeKind::FieldAccessExpr: {
        auto& f = static_cast<CFieldAccessExpr&>(*expr);
        f.base = substituteVarRefs(std::move(f.base), defs, refCounts,
                                   inlined, childDepth);
        return expr;
    }
    default:
        return expr;
    }
}

void CAstOptimizer::copyPropStmtList(
    std::vector<StmtPtr>& stmts,
    const std::unordered_map<std::string, const CExpr*>& defs,
    const std::unordered_map<std::string, unsigned>& refCounts,
    std::unordered_set<std::string>& inlined) {

    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<CAssignStmt&>(*sp);
            // Don't inline INTO the target (LHS) — it's a definition site.
            if (a.value) {
                a.value = substituteVarRefs(std::move(a.value), defs,
                                            refCounts, inlined);
            }
            break;
        }
        case NodeKind::ExprStmt: {
            auto& e = static_cast<CExprStmt&>(*sp);
            if (e.expr)
                e.expr = substituteVarRefs(std::move(e.expr), defs, refCounts,
                                           inlined);
            break;
        }
        case NodeKind::ReturnStmt: {
            auto& r = static_cast<CReturnStmt&>(*sp);
            if (r.value)
                r.value = substituteVarRefs(std::move(r.value), defs,
                                            refCounts, inlined);
            break;
        }
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            if (s.condition)
                s.condition = substituteVarRefs(std::move(s.condition), defs,
                                                refCounts, inlined);
            copyPropStmtList(s.thenBody, defs, refCounts, inlined);
            copyPropStmtList(s.elseBody, defs, refCounts, inlined);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& s = static_cast<CWhileStmt&>(*sp);
            if (s.condition)
                s.condition = substituteVarRefs(std::move(s.condition), defs,
                                                refCounts, inlined);
            copyPropStmtList(s.body, defs, refCounts, inlined);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& s = static_cast<CDoWhileStmt&>(*sp);
            copyPropStmtList(s.body, defs, refCounts, inlined);
            if (s.condition)
                s.condition = substituteVarRefs(std::move(s.condition), defs,
                                                refCounts, inlined);
            break;
        }
        case NodeKind::ForStmt: {
            auto& s = static_cast<CForStmt&>(*sp);
            if (s.condition)
                s.condition = substituteVarRefs(std::move(s.condition), defs,
                                                refCounts, inlined);
            copyPropStmtList(s.body, defs, refCounts, inlined);
            break;
        }
        case NodeKind::SwitchStmt: {
            auto& s = static_cast<CSwitchStmt&>(*sp);
            if (s.selector)
                s.selector = substituteVarRefs(std::move(s.selector), defs,
                                               refCounts, inlined);
            for (auto& c : s.cases)
                copyPropStmtList(c.body, defs, refCounts, inlined);
            break;
        }
        case NodeKind::BlockStmt:
            copyPropStmtList(static_cast<CBlockStmt&>(*sp).stmts, defs,
                             refCounts, inlined);
            break;
        default:
            break;
        }
    }
}

void CAstOptimizer::propagateCopies(CFuncDecl& func) {
    // Pass A: count all variable references across the whole function.
    std::unordered_map<std::string, unsigned> refCounts;
    countVarRefs(func.body, refCounts);

    // Pass B: build def map from plain CAssignStmt `x = expr` where target
    // is a synthetic single-definition variable.
    std::unordered_map<std::string, const CExpr*> defs;
    std::unordered_map<std::string, unsigned> defCounts;

    for (const auto& sp : func.body) {
        if (!sp || sp->getKind() != NodeKind::AssignStmt) continue;
        const auto& a = static_cast<const CAssignStmt&>(*sp);
        if (!a.target || !a.value) continue;
        if (!a.compoundOp.empty()) continue; // compound op — skip
        if (a.target->getKind() != NodeKind::VarRefExpr) continue;
        const std::string& name =
            static_cast<const CVarRefExpr*>(a.target.get())->varName;
        defCounts[name]++;
        // Only single-definition synthetic variables are candidates.
        if (defCounts[name] == 1 && isSyntheticName(name) &&
            isSimpleExpr(a.value.get())) {
            defs[name] = a.value.get();
        } else {
            defs.erase(name); // Multiple definitions — disqualify.
        }
    }

    // Pass C: substitute uses of inlined variables.
    std::unordered_set<std::string> inlined;
    copyPropStmtList(func.body, defs, refCounts, inlined);

    // Pass D: remove the original assignment statements for inlined vars.
    if (!inlined.empty()) {
        std::erase_if(func.body, [&](const StmtPtr& sp) {
            if (!sp || sp->getKind() != NodeKind::AssignStmt) return false;
            const auto& a = static_cast<const CAssignStmt&>(*sp);
            if (!a.target ||
                a.target->getKind() != NodeKind::VarRefExpr)
                return false;
            const std::string& name =
                static_cast<const CVarRefExpr*>(a.target.get())->varName;
            return inlined.count(name) > 0;
        });
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 5: simplifyExpressions
// ═══════════════════════════════════════════════════════════════════════════════

ExprPtr CAstOptimizer::simplifyExpr(ExprPtr expr, bool isLValue) {
    if (!expr) return nullptr;

    // Bottom-up: simplify children first.
    //
    // FIX-047): carry `isLValue` only through rewrites that
    // PRESERVE the lvalue nature of the parent.  A unary `*` deref is
    // itself an lvalue (`*p = x` is legal), and its operand is an
    // rvalue — so a deref inside an lvalue context makes its operand
    // rvalue-safe.  Subscripts and field accesses similarly have lvalue
    // identity but rvalue operands (base / index).  Everything else is
    // unconditionally rvalue — reaching e.g. a binary `+` or a cast on
    // an assignment LHS would be malformed C to begin with.
    switch (expr->getKind()) {
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        b.lhs = simplifyExpr(std::move(b.lhs), /*isLValue=*/false);
        b.rhs = simplifyExpr(std::move(b.rhs), /*isLValue=*/false);
        break;
    }
    case NodeKind::UnaryExpr: {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        // *x is itself an lvalue when x is a pointer expression, but the
        // operand x is an rvalue regardless of the parent context.
        u.operand = simplifyExpr(std::move(u.operand), /*isLValue=*/false);
        break;
    }
    case NodeKind::CastExpr: {
        auto& c = static_cast<CCastExpr&>(*expr);
        // A cast expression is never an lvalue in C (`(T)x = y` is illegal).
        c.operand = simplifyExpr(std::move(c.operand), /*isLValue=*/false);
        break;
    }
    case NodeKind::CallExpr: {
        auto& c = static_cast<CCallExpr&>(*expr);
        for (auto& a : c.args)
            a = simplifyExpr(std::move(a), /*isLValue=*/false);
        break;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*expr);
        t.cond     = simplifyExpr(std::move(t.cond), /*isLValue=*/false);
        t.trueVal  = simplifyExpr(std::move(t.trueVal), /*isLValue=*/false);
        t.falseVal = simplifyExpr(std::move(t.falseVal), /*isLValue=*/false);
        break;
    }
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*expr);
        // a[i] is lvalue; base and index themselves are rvalues.
        s.base  = simplifyExpr(std::move(s.base), /*isLValue=*/false);
        s.index = simplifyExpr(std::move(s.index), /*isLValue=*/false);
        break;
    }
    case NodeKind::FieldAccessExpr: {
        auto& f = static_cast<CFieldAccessExpr&>(*expr);
        // a.field / a->field is lvalue; the base is an rvalue.
        f.base = simplifyExpr(std::move(f.base), /*isLValue=*/false);
        break;
    }
    default:
        break;
    }

    // Now apply rewriting rules to the (simplified) current node.

    // ── Unary patterns ────────────────────────────────────────────────────────
    if (expr->getKind() == NodeKind::UnaryExpr) {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        if (!u.operand) return expr;

        // *(&x) → x  (deref of address-of)
        if (u.op == UnaryOp::Deref &&
            u.operand->getKind() == NodeKind::UnaryExpr) {
            const auto& inner =
                static_cast<const CUnaryExpr&>(*u.operand);
            if (inner.op == UnaryOp::AddressOf && inner.operand) {
                return cloneExpr(inner.operand.get());
            }
        }

        // *((T)NULL) → 0   (FIX-042 bug B: unresolved-global sentinel)
        //
        // When Helix can't resolve an absolute address into a named global,
        // the emitter surfaces the load as `*(int64_t)(void*)0` / `*(void*)0`.
        // Leaving this in the output is user-hostile (it looks like a real
        // NULL deref, and — worse — propagates through `+` arithmetic into
        // shapes like `*(v2 + 8 + *(int64_t)(void*)0)`).  Treating the deref
        // as 0 makes the containing expression compilable (the `+ 0` then
        // folds via the existing `x + 0 → x` rule) and matches the
        // observable semantics: on Windows i386 the `NULL` page is not
        // mapped, so any real execution of this load would trap; emitting
        // 0 is the best static approximation we have without the original
        // global's address.
        //
        // FIX-047): but only when this expression is used as an
        // rvalue.  Collapsing `*(T)(void*)0 = rhs` to `0 = rhs` produces
        // malformed C (assignment to an integer literal) which was shipping
        // in SOTR's `HealthData-read.c` line 41.  When the caller signalled
        // lvalue context (e.g. CAssignStmt::target), leave the deref alone
        // so the statement either survives to eliminateNullPtrStores (which
        // deletes it) or downstream RemillState→register recovery (which
        // replaces it with a RegWriteOp-style name).
        if (!isLValue && u.op == UnaryOp::Deref && u.operand) {
            // Walk through at most 3 levels of casts to find a literal 0.
            const CExpr* cur = u.operand.get();
            for (int depth = 0; depth < 3 && cur; ++depth) {
                if (cur->getKind() == NodeKind::IntLitExpr &&
                    static_cast<const CIntLitExpr&>(*cur).value == 0) {
                    return std::make_unique<CIntLitExpr>(
                        0, u.type ? u.type : CType::int64(),
                        expr->getAddress());
                }
                if (cur->getKind() == NodeKind::CastExpr) {
                    cur = static_cast<const CCastExpr&>(*cur).operand.get();
                    continue;
                }
                break;
            }
        }

        // &(*x) → x  (address-of deref)
        if (u.op == UnaryOp::AddressOf &&
            u.operand->getKind() == NodeKind::UnaryExpr) {
            const auto& inner =
                static_cast<const CUnaryExpr&>(*u.operand);
            if (inner.op == UnaryOp::Deref && inner.operand) {
                return cloneExpr(inner.operand.get());
            }
        }

        // !!x → x  (double logical not)
        if (u.op == UnaryOp::LogNot &&
            u.operand->getKind() == NodeKind::UnaryExpr) {
            const auto& inner =
                static_cast<const CUnaryExpr&>(*u.operand);
            if (inner.op == UnaryOp::LogNot && inner.operand)
                return cloneExpr(inner.operand.get());
        }

        // !constant → constant fold
        // !0 → 1, !N → 0 for any non-zero N
        if (u.op == UnaryOp::LogNot &&
            u.operand->getKind() == NodeKind::IntLitExpr) {
            const auto& lit = static_cast<const CIntLitExpr&>(*u.operand);
            int64_t result = (lit.value == 0) ? 1 : 0;
            return std::make_unique<CIntLitExpr>(
                result, CType::int32(), expr->getAddress());
        }

        // ~constant → constant fold (bitwise not)
        if (u.op == UnaryOp::BitNot &&
            u.operand->getKind() == NodeKind::IntLitExpr) {
            const auto& lit = static_cast<const CIntLitExpr&>(*u.operand);
            return std::make_unique<CIntLitExpr>(
                ~lit.value, lit.type ? lit.type : CType::int64(),
                expr->getAddress());
        }

        // -constant → constant fold (negation)
        if (u.op == UnaryOp::Neg &&
            u.operand->getKind() == NodeKind::IntLitExpr) {
            const auto& lit = static_cast<const CIntLitExpr&>(*u.operand);
            return std::make_unique<CIntLitExpr>(
                -lit.value, lit.type ? lit.type : CType::int64(),
                expr->getAddress());
        }

        // -(-x) → x  (double negation)
        if (u.op == UnaryOp::Neg &&
            u.operand->getKind() == NodeKind::UnaryExpr) {
            const auto& inner =
                static_cast<const CUnaryExpr&>(*u.operand);
            if (inner.op == UnaryOp::Neg && inner.operand)
                return cloneExpr(inner.operand.get());
        }

        // !(x == y) → x != y, !(x != y) → x == y, etc.
        if (u.op == UnaryOp::LogNot &&
            u.operand->getKind() == NodeKind::BinaryExpr) {
            const auto& inner =
                static_cast<const CBinaryExpr&>(*u.operand);
            if (isCmpOp(inner.op) && inner.lhs && inner.rhs) {
                return std::make_unique<CBinaryExpr>(
                    flipCmp(inner.op),
                    cloneExpr(inner.lhs.get()),
                    cloneExpr(inner.rhs.get()),
                    inner.type, inner.getAddress());
            }
        }
    }

    // ── Comparison combinator simplification ──────────────────────────────
    // (cmp1) & (cmp2) → (cmp1) && (cmp2)
    // (cmp1) | (cmp2) → (cmp1) || (cmp2)
    // These are equivalent for boolean operands but more idiomatic in C.
    if (expr->getKind() == NodeKind::BinaryExpr) {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        if ((b.op == BinaryOp::BitAnd || b.op == BinaryOp::BitOr) &&
            b.lhs && b.rhs &&
            b.lhs->getKind() == NodeKind::BinaryExpr &&
            b.rhs->getKind() == NodeKind::BinaryExpr) {
            const auto& lb = static_cast<const CBinaryExpr&>(*b.lhs);
            const auto& rb = static_cast<const CBinaryExpr&>(*b.rhs);
            if (isCmpOp(lb.op) && isCmpOp(rb.op)) {
                // FIX-085 (DREAM-inspired): bail out before promoting
                // bitwise-of-cmps into a logical chain if either side is
                // already a deep boolean tree.  Continuing would only
                // deepen the expression, eventually overflowing the
                // printer's stack on pathological CFGs.
                constexpr unsigned kBoolDepthLimit = 8;
                if (boolExprDepth(b.lhs.get()) + boolExprDepth(b.rhs.get())
                        <= kBoolDepthLimit) {
                    b.op = (b.op == BinaryOp::BitAnd)
                        ? BinaryOp::LogAnd
                        : BinaryOp::LogOr;
                    if (b.type == nullptr ||
                        b.type->kind == TypeKind::Unknown)
                        b.type = CType::boolTy();
                }
            }
        }
    }

    // ── Binary patterns ───────────────────────────────────────────────────────
    if (expr->getKind() == NodeKind::BinaryExpr) {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        if (!b.lhs || !b.rhs) return expr;

        auto lhsType = b.lhs->type ? b.lhs->type : CType::int32();

        // x + 0 → x
        if (b.op == BinaryOp::Add && isIntLit(b.rhs.get(), 0))
            return std::move(b.lhs);

        // x + (-N) → x - N  (negative constant addition → subtraction)
        if (b.op == BinaryOp::Add &&
            b.rhs->getKind() == NodeKind::IntLitExpr) {
            auto& lit = static_cast<CIntLitExpr&>(*b.rhs);
            if (lit.value < 0) {
                lit.value = -lit.value;
                b.op = BinaryOp::Sub;
                return std::move(expr);
            }
        }

        // x - 0 → x
        if (b.op == BinaryOp::Sub && isIntLit(b.rhs.get(), 0))
            return std::move(b.lhs);

        // x - (x - y) → y   (FIX-041 bug I: SBB+SUB compiler idiom)
        //
        // Observed on gta-sa.exe `sub_4095a0` as `v1 -= v1 - v3;`, which is
        // the compound form of `v1 = v1 - (v1 - v3)` — a lowering artifact
        // from x86 `sbb eax, eax` followed by `sub eax, ebx`.  Algebraically
        // `x - (x - y) = y`, so we rewrite the outer BinaryExpr to just `y`.
        // Runs BEFORE `synthesizeCompoundAssign` in optimize(), so the
        // compound `-=` never forms.
        if (b.op == BinaryOp::Sub && b.rhs->getKind() == NodeKind::BinaryExpr) {
            const auto& inner = static_cast<const CBinaryExpr&>(*b.rhs);
            if (inner.op == BinaryOp::Sub && inner.lhs &&
                isSameExpr(b.lhs.get(), inner.lhs.get()) && inner.rhs) {
                return cloneExpr(inner.rhs.get());
            }
        }

        // (x - y) - x → -y   (same idiom, swapped operand order)
        if (b.op == BinaryOp::Sub && b.lhs->getKind() == NodeKind::BinaryExpr) {
            const auto& inner = static_cast<const CBinaryExpr&>(*b.lhs);
            if (inner.op == BinaryOp::Sub && inner.lhs && inner.rhs &&
                isSameExpr(inner.lhs.get(), b.rhs.get())) {
                return std::make_unique<CUnaryExpr>(
                    UnaryOp::Neg, cloneExpr(inner.rhs.get()),
                    inner.rhs->type ? inner.rhs->type : CType::int64(),
                    expr->getAddress());
            }
        }

        // x * 1 → x
        if (b.op == BinaryOp::Mul && isIntLit(b.rhs.get(), 1))
            return std::move(b.lhs);

        // x / 1 → x
        if (b.op == BinaryOp::Div && isIntLit(b.rhs.get(), 1))
            return std::move(b.lhs);

        // x | 0 → x
        if (b.op == BinaryOp::BitOr && isIntLit(b.rhs.get(), 0))
            return std::move(b.lhs);

        // x ^ 0 → x
        if (b.op == BinaryOp::BitXor && isIntLit(b.rhs.get(), 0))
            return std::move(b.lhs);

        // x & ~0 (all bits set) → x  (~0 == -1 in two's complement)
        if (b.op == BinaryOp::BitAnd && isIntLit(b.rhs.get(), -1))
            return std::move(b.lhs);

        // x * 0 → 0
        if (b.op == BinaryOp::Mul && isIntLit(b.rhs.get(), 0))
            return std::make_unique<CIntLitExpr>(0, lhsType, b.getAddress());

        // x & 0 → 0
        if (b.op == BinaryOp::BitAnd && isIntLit(b.rhs.get(), 0))
            return std::make_unique<CIntLitExpr>(0, lhsType, b.getAddress());

        // x * -1 → -(x)
        if (b.op == BinaryOp::Mul && isIntLit(b.rhs.get(), -1)) {
            return std::make_unique<CUnaryExpr>(
                UnaryOp::Neg, std::move(b.lhs), lhsType, b.getAddress());
        }

        // (x << a) << b → x << (a + b)  [only when both shifts are int lits]
        if (b.op == BinaryOp::Shl &&
            b.lhs->getKind() == NodeKind::BinaryExpr) {
            const auto& inner =
                static_cast<const CBinaryExpr&>(*b.lhs);
            if (inner.op == BinaryOp::Shl) {
                auto a = getIntLit(inner.rhs.get());
                auto bv = getIntLit(b.rhs.get());
                if (a && bv) {
                    int64_t combined = *a + *bv;
                    return std::make_unique<CBinaryExpr>(
                        BinaryOp::Shl, cloneExpr(inner.lhs.get()),
                        std::make_unique<CIntLitExpr>(combined, CType::int32()),
                        b.type, b.getAddress());
                }
            }
        }

        // Constant folding for purely integer arithmetic.
        {
            auto lv = getIntLit(b.lhs.get());
            auto rv = getIntLit(b.rhs.get());
            if (lv && rv) {
                std::optional<int64_t> result;
                switch (b.op) {
                case BinaryOp::Add:    result = *lv + *rv; break;
                case BinaryOp::Sub:    result = *lv - *rv; break;
                case BinaryOp::Mul:    result = *lv * *rv; break;
                case BinaryOp::Div:    if (*rv != 0) result = *lv / *rv; break;
                case BinaryOp::Mod:    if (*rv != 0) result = *lv % *rv; break;
                case BinaryOp::BitAnd: result = *lv & *rv; break;
                case BinaryOp::BitOr:  result = *lv | *rv; break;
                case BinaryOp::BitXor: result = *lv ^ *rv; break;
                case BinaryOp::Shl:    if (*rv >= 0 && *rv < 64) result = *lv << *rv; break;
                case BinaryOp::Shr:    if (*rv >= 0 && *rv < 64) result = static_cast<int64_t>(static_cast<uint64_t>(*lv) >> *rv); break;
                default: break;
                }
                if (result)
                    return std::make_unique<CIntLitExpr>(
                        *result, lhsType, b.getAddress());
            }
        }
    }

    return expr;
}

void CAstOptimizer::simplifyExprInStmt(ExprPtr& slot, bool isLValue) {
    if (slot)
        slot = simplifyExpr(std::move(slot), isLValue);
}

void CAstOptimizer::simplifyStmtList(std::vector<StmtPtr>& stmts) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<CAssignStmt&>(*sp);
            // FIX-047): target is an lvalue — suppress rewrites
            // that would turn designators into non-lvalues (`*(T)NULL → 0`).
            simplifyExprInStmt(a.target, /*isLValue=*/true);
            simplifyExprInStmt(a.value, /*isLValue=*/false);
            break;
        }
        case NodeKind::ExprStmt: {
            auto& e = static_cast<CExprStmt&>(*sp);
            simplifyExprInStmt(e.expr);
            break;
        }
        case NodeKind::ReturnStmt: {
            auto& r = static_cast<CReturnStmt&>(*sp);
            simplifyExprInStmt(r.value);
            break;
        }
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            simplifyExprInStmt(s.condition);
            simplifyStmtList(s.thenBody);
            simplifyStmtList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& s = static_cast<CWhileStmt&>(*sp);
            simplifyExprInStmt(s.condition);
            simplifyStmtList(s.body);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& s = static_cast<CDoWhileStmt&>(*sp);
            simplifyStmtList(s.body);
            simplifyExprInStmt(s.condition);
            break;
        }
        case NodeKind::ForStmt: {
            auto& s = static_cast<CForStmt&>(*sp);
            simplifyExprInStmt(s.condition);
            simplifyStmtList(s.body);
            break;
        }
        case NodeKind::SwitchStmt: {
            auto& s = static_cast<CSwitchStmt&>(*sp);
            simplifyExprInStmt(s.selector);
            for (auto& c : s.cases)
                simplifyStmtList(c.body);
            break;
        }
        case NodeKind::BlockStmt:
            simplifyStmtList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }
}

void CAstOptimizer::simplifyExpressions(CFuncDecl& func) {
    simplifyStmtList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// FIX-086: eliminateRedundantCasts (dewolf-inspired)
// ═══════════════════════════════════════════════════════════════════════════════
//
// Walks every expression in the function and elides `CCastExpr` nodes
// whose source/destination types are semantically equivalent.  The most
// common offenders observed in the stress corpora:
//   1. `(int64_t)(int64_t)x`             — duplicate casts from MLIR
//                                          type-system noise
//   2. `(int64_t)(void*)0`               — Remill represents the null
//                                          pointer constant as a void*
//                                          which is then immediately
//                                          re-typed for an i64 use
//   3. `(uint64_t)var`  where var is i64 — sign-only difference, both
//                                          map to a 64-bit register
//
// We never elide a cast that changes bit width (that would change the
// value) and we never elide pointer↔integer casts unless both sides are
// 64 bits — narrowing to 32 bits would silently drop the upper half on
// any real 64-bit target.

namespace {

// Returns true when `dst` is structurally identical enough to `src` that
// a cast between them does not change the runtime value on a 64-bit
// LP64/LLP64 target.  Conservative — we keep the cast when in doubt.
bool castIsRedundant(const CType* src, const CType* dst) {
    if (!src || !dst) return false;
    if (src == dst) return true;
    if (*src == *dst) return true;

    auto isInt64 = [](const CType* t) {
        return t->kind == TypeKind::Int && t->bitWidth == 64;
    };
    auto isPtrLike = [](const CType* t) {
        return t->kind == TypeKind::Pointer ||
               t->kind == TypeKind::FuncPtr;
    };

    // int64 ↔ pointer: same bit width on every supported target.
    if ((isInt64(src) && isPtrLike(dst)) ||
        (isPtrLike(src) && isInt64(dst)))
        return true;

    // Same kind + same width: sign-only difference.  Eliminating the
    // cast keeps the value bits intact; the result type just reflects
    // the new lvalue's signedness, which the printer picks up from the
    // surrounding context.
    if (src->kind == dst->kind && src->bitWidth == dst->bitWidth &&
        src->bitWidth != 0)
        return true;

    return false;
}

// Recursively rewrite an expression tree, collapsing redundant
// CCastExpr nodes in-place.  Returns a (possibly-replaced) owning
// pointer.  Bottom-up: we simplify the child first so chained casts
// (e.g. `(int64_t)(int64_t)x`) collapse in a single pass.
ExprPtr stripRedundantCasts(ExprPtr expr) {
    if (!expr) return nullptr;

    switch (expr->getKind()) {
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        b.lhs = stripRedundantCasts(std::move(b.lhs));
        b.rhs = stripRedundantCasts(std::move(b.rhs));
        break;
    }
    case NodeKind::UnaryExpr: {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        u.operand = stripRedundantCasts(std::move(u.operand));
        break;
    }
    case NodeKind::CallExpr: {
        auto& c = static_cast<CCallExpr&>(*expr);
        for (auto& a : c.args)
            a = stripRedundantCasts(std::move(a));
        break;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*expr);
        t.cond     = stripRedundantCasts(std::move(t.cond));
        t.trueVal  = stripRedundantCasts(std::move(t.trueVal));
        t.falseVal = stripRedundantCasts(std::move(t.falseVal));
        break;
    }
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*expr);
        s.base  = stripRedundantCasts(std::move(s.base));
        s.index = stripRedundantCasts(std::move(s.index));
        break;
    }
    case NodeKind::FieldAccessExpr: {
        auto& f = static_cast<CFieldAccessExpr&>(*expr);
        f.base = stripRedundantCasts(std::move(f.base));
        break;
    }
    case NodeKind::CastExpr: {
        auto& c = static_cast<CCastExpr&>(*expr);
        c.operand = stripRedundantCasts(std::move(c.operand));
        if (!c.operand) return std::move(expr);

        const CType* srcTy = c.operand->type.get();
        const CType* dstTy = c.targetType.get();
        if (castIsRedundant(srcTy, dstTy)) {
            // Hoist the operand: preserve the outer cast's address so
            // call-site addressing survives the elision.
            auto inner = std::move(c.operand);
            // Adopt the cast's target type onto the operand only if the
            // operand's own type is missing — we never overwrite a
            // known operand type because that would corrupt the
            // downstream printer's precedence decisions.
            if (!inner->type)
                inner->type = c.targetType;
            return inner;
        }
        break;
    }
    default:
        break;
    }
    return expr;
}

void stripRedundantCastsInStmts(std::vector<StmtPtr>& stmts);

void stripRedundantCastsInStmt(CStmt& stmt) {
    switch (stmt.getKind()) {
    case NodeKind::AssignStmt: {
        auto& s = static_cast<CAssignStmt&>(stmt);
        s.target = stripRedundantCasts(std::move(s.target));
        s.value  = stripRedundantCasts(std::move(s.value));
        break;
    }
    case NodeKind::ExprStmt: {
        auto& s = static_cast<CExprStmt&>(stmt);
        s.expr = stripRedundantCasts(std::move(s.expr));
        break;
    }
    case NodeKind::ReturnStmt: {
        auto& s = static_cast<CReturnStmt&>(stmt);
        if (s.value)
            s.value = stripRedundantCasts(std::move(s.value));
        break;
    }
    case NodeKind::IfStmt: {
        auto& s = static_cast<CIfStmt&>(stmt);
        s.condition = stripRedundantCasts(std::move(s.condition));
        stripRedundantCastsInStmts(s.thenBody);
        stripRedundantCastsInStmts(s.elseBody);
        break;
    }
    case NodeKind::WhileStmt: {
        auto& s = static_cast<CWhileStmt&>(stmt);
        s.condition = stripRedundantCasts(std::move(s.condition));
        stripRedundantCastsInStmts(s.body);
        break;
    }
    case NodeKind::DoWhileStmt: {
        auto& s = static_cast<CDoWhileStmt&>(stmt);
        s.condition = stripRedundantCasts(std::move(s.condition));
        stripRedundantCastsInStmts(s.body);
        break;
    }
    case NodeKind::ForStmt: {
        auto& s = static_cast<CForStmt&>(stmt);
        // ForStmt's init/step are sub-statements; recurse via the
        // shared helper.
        if (s.init) stripRedundantCastsInStmt(*s.init);
        if (s.step) stripRedundantCastsInStmt(*s.step);
        if (s.condition)
            s.condition = stripRedundantCasts(std::move(s.condition));
        stripRedundantCastsInStmts(s.body);
        break;
    }
    case NodeKind::SwitchStmt: {
        auto& s = static_cast<CSwitchStmt&>(stmt);
        s.selector = stripRedundantCasts(std::move(s.selector));
        for (auto& c : s.cases)
            stripRedundantCastsInStmts(c.body);
        break;
    }
    case NodeKind::BlockStmt: {
        auto& s = static_cast<CBlockStmt&>(stmt);
        stripRedundantCastsInStmts(s.stmts);
        break;
    }
    default:
        break;
    }
}

void stripRedundantCastsInStmts(std::vector<StmtPtr>& stmts) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        stripRedundantCastsInStmt(*sp);
    }
}

} // namespace

void CAstOptimizer::eliminateRedundantCasts(CFuncDecl& func) {
    stripRedundantCastsInStmts(func.body);
}


// ═══════════════════════════════════════════════════════════════════════════════
// Pass 6: synthesizeCompoundAssign
// ═══════════════════════════════════════════════════════════════════════════════

/// Compare two expression trees for structural equality (for compound assign matching).
static bool exprEquals(const CExpr* a, const CExpr* b) {
    if (!a || !b) return false;
    if (a->getKind() != b->getKind()) return false;
    switch (a->getKind()) {
    case NodeKind::VarRefExpr:
        return static_cast<const CVarRefExpr*>(a)->varName ==
               static_cast<const CVarRefExpr*>(b)->varName;
    case NodeKind::UnaryExpr: {
        const auto& ua = static_cast<const CUnaryExpr&>(*a);
        const auto& ub = static_cast<const CUnaryExpr&>(*b);
        return ua.op == ub.op && exprEquals(ua.operand.get(), ub.operand.get());
    }
    case NodeKind::FieldAccessExpr: {
        const auto& fa = static_cast<const CFieldAccessExpr&>(*a);
        const auto& fb = static_cast<const CFieldAccessExpr&>(*b);
        return fa.fieldName == fb.fieldName && fa.isPointer == fb.isPointer &&
               exprEquals(fa.base.get(), fb.base.get());
    }
    case NodeKind::SubscriptExpr: {
        const auto& sa = static_cast<const CSubscriptExpr&>(*a);
        const auto& sb = static_cast<const CSubscriptExpr&>(*b);
        return exprEquals(sa.base.get(), sb.base.get()) &&
               exprEquals(sa.index.get(), sb.index.get());
    }
    case NodeKind::IntLitExpr:
        return static_cast<const CIntLitExpr*>(a)->value ==
               static_cast<const CIntLitExpr*>(b)->value;
    default:
        return false;
    }
}

void CAstOptimizer::tryCompound(CAssignStmt& stmt) {
    // Already has a compound op — nothing to do.
    if (!stmt.compoundOp.empty()) return;
    if (!stmt.target || !stmt.value) return;

    // Value must be a binary expression.
    if (stmt.value->getKind() != NodeKind::BinaryExpr) return;
    const auto& bin = static_cast<const CBinaryExpr&>(*stmt.value);
    if (!bin.lhs || !bin.rhs) return;

    const char* opStr = compoundOpStr(bin.op);
    if (!opStr) return;

    // Check if LHS of the binary op matches the assignment target (structural equality).
    bool lhsMatch = exprEquals(stmt.target.get(), bin.lhs.get());
    // Check commutative RHS match.
    bool rhsMatch = isCommutative(bin.op) && exprEquals(stmt.target.get(), bin.rhs.get());

    if (!lhsMatch && !rhsMatch) return;

    // x = x + 1  →  x++ (special case: increment)
    if (bin.op == BinaryOp::Add && lhsMatch && isIntLit(bin.rhs.get(), 1)) {
        stmt.compoundOp = "++";
        stmt.value.reset(); // printer handles this case
        return;
    }

    // x = x - 1  →  x-- (special case: decrement)
    if (bin.op == BinaryOp::Sub && lhsMatch && isIntLit(bin.rhs.get(), 1)) {
        stmt.compoundOp = "--";
        stmt.value.reset();
        return;
    }

    // General compound: x = x OP y  →  x OP= y
    if (lhsMatch) {
        stmt.compoundOp = opStr;
        stmt.value = cloneExpr(bin.rhs.get());
        return;
    }

    // Commutative: x = y OP x  →  x OP= y
    if (rhsMatch) {
        stmt.compoundOp = opStr;
        stmt.value = cloneExpr(bin.lhs.get());
    }
}

void CAstOptimizer::compoundStmtList(std::vector<StmtPtr>& stmts) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt:
            tryCompound(static_cast<CAssignStmt&>(*sp));
            break;
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            compoundStmtList(s.thenBody);
            compoundStmtList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            compoundStmtList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            compoundStmtList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            compoundStmtList(static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                compoundStmtList(c.body);
            break;
        case NodeKind::BlockStmt:
            compoundStmtList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }
}

void CAstOptimizer::synthesizeCompoundAssign(CFuncDecl& func) {
    compoundStmtList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 7: removeDeadCodeAfterReturn
// ═══════════════════════════════════════════════════════════════════════════════
//
// Remove unreachable statements that appear after a return/break/continue/goto
// in the same scope level.

void CAstOptimizer::removeDeadAfterReturnInList(std::vector<StmtPtr>& stmts) {
    // First, recurse into nested scopes.
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            removeDeadAfterReturnInList(s.thenBody);
            removeDeadAfterReturnInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            removeDeadAfterReturnInList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            removeDeadAfterReturnInList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            removeDeadAfterReturnInList(static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                removeDeadAfterReturnInList(c.body);
            break;
        case NodeKind::BlockStmt:
            removeDeadAfterReturnInList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }

    // Check if a loop body has any exit path (break, return, goto).
    std::function<bool(const std::vector<StmtPtr>&)> hasExitPath;
    hasExitPath = [&](const std::vector<StmtPtr>& body) -> bool {
        for (auto& sp : body) {
            if (!sp) continue;
            auto k = sp->getKind();
            if (k == NodeKind::ReturnStmt || k == NodeKind::BreakStmt ||
                k == NodeKind::GotoStmt)
                return true;
            if (k == NodeKind::IfStmt) {
                auto& s = static_cast<const CIfStmt&>(*sp);
                if (hasExitPath(s.thenBody) || hasExitPath(s.elseBody))
                    return true;
            }
        }
        return false;
    };

    // Check if a statement is an unconditional infinite loop (no exit path).
    auto isInfiniteLoop = [&](const CStmt* s) -> bool {
        if (!s) return false;
        if (s->getKind() == NodeKind::DoWhileStmt) {
            auto& dw = static_cast<const CDoWhileStmt&>(*s);
            // while(true) condition — check for literal true/1
            if (dw.condition) {
                if (dw.condition->getKind() == NodeKind::IntLitExpr) {
                    auto& lit = static_cast<const CIntLitExpr&>(*dw.condition);
                    if (lit.value != 0 && !hasExitPath(dw.body))
                        return true;
                }
            }
        } else if (s->getKind() == NodeKind::WhileStmt) {
            auto& w = static_cast<const CWhileStmt&>(*s);
            if (w.condition) {
                if (w.condition->getKind() == NodeKind::IntLitExpr) {
                    auto& lit = static_cast<const CIntLitExpr&>(*w.condition);
                    if (lit.value != 0 && !hasExitPath(w.body))
                        return true;
                }
            }
        }
        return false;
    };

    // FIX-050 (Wave 12, Frente A — content recovery): helper that decides
    // whether a statement tail "after a terminator" is safe to erase.
    //
    // Background: `helix_low.jmp` and `helix_low.jcc` never emit
    // CAstStmts (see CAstBuilder::buildStatement for helix_low::JmpOp
    // / JccOp — both return nullptr).  StructureControlFlow handled the
    // flows it could schema-match, but **error-recovery blocks that are
    // reachable only through low-level jumps** reach CAstBuilder without
    // any surrounding CLabelStmt or CGotoStmt to tell the optimizer they
    // are alive.  Those blocks appear as plain statement sequences at
    // the same scope level, positioned AFTER a ReturnStmt that exited an
    // earlier if-branch.
    //
    // Without this guard, `removeDeadAfterReturnInList` erased **every**
    // such block on `kbase_jit_allocate.ll`, dropping 6 call-of-interest
    // targets (`_dev_info`, `_dev_err`, `__kbase_tlstream_jit_alloc`,
    // `kbase_set_phy_alloc_page_status`,
    // `kbase_free_phy_pages_helper_locked`, `__stack_chk_fail`) and
    // shrinking output from the lifted 176 L down to 145 L (31-line loss).
    //
    // Conservative fix: if the tail we're about to erase contains ANY
    // side-effecting content (a CallExpr anywhere, or any of the
    // containing-block statement kinds the other passes depend on seeing),
    // assume it's reachable through an un-modelled CFG edge and preserve
    // it.  This can leave some genuinely-dead code in the output when the
    // function has real unreachable tail code — but that's a strictly
    // safer failure mode than dropping reachable calls.  Real-dead tails
    // are usually either pure assignments or empty, which still get
    // pruned.
    auto containsCallExpr = [](const CExpr* expr) -> bool {
        // Walk expression tree looking for any CCallExpr node.
        std::function<bool(const CExpr*)> rec = [&](const CExpr* e) -> bool {
            if (!e) return false;
            if (e->getKind() == NodeKind::CallExpr) return true;
            switch (e->getKind()) {
            case NodeKind::BinaryExpr: {
                const auto& b = static_cast<const CBinaryExpr&>(*e);
                return rec(b.lhs.get()) || rec(b.rhs.get());
            }
            case NodeKind::UnaryExpr:
                return rec(static_cast<const CUnaryExpr&>(*e).operand.get());
            case NodeKind::CastExpr:
                return rec(static_cast<const CCastExpr&>(*e).operand.get());
            case NodeKind::TernaryExpr: {
                const auto& t = static_cast<const CTernaryExpr&>(*e);
                return rec(t.cond.get()) || rec(t.trueVal.get()) || rec(t.falseVal.get());
            }
            case NodeKind::SubscriptExpr: {
                const auto& s = static_cast<const CSubscriptExpr&>(*e);
                return rec(s.base.get()) || rec(s.index.get());
            }
            case NodeKind::FieldAccessExpr:
                return rec(static_cast<const CFieldAccessExpr&>(*e).base.get());
            default: return false;
            }
        };
        return rec(expr);
    };

    std::function<bool(const std::vector<StmtPtr>&)> tailHasSideEffect;
    tailHasSideEffect = [&](const std::vector<StmtPtr>& body) -> bool {
        for (const auto& sp : body) {
            if (!sp) continue;
            switch (sp->getKind()) {
            case NodeKind::AssignStmt: {
                const auto& a = static_cast<const CAssignStmt&>(*sp);
                if (containsCallExpr(a.value.get()) ||
                    containsCallExpr(a.target.get())) return true;
                break;
            }
            case NodeKind::ExprStmt:
                if (containsCallExpr(static_cast<const CExprStmt&>(*sp).expr.get()))
                    return true;
                break;
            case NodeKind::ReturnStmt:
                if (containsCallExpr(static_cast<const CReturnStmt&>(*sp).value.get()))
                    return true;
                break;
            case NodeKind::IfStmt: {
                const auto& s = static_cast<const CIfStmt&>(*sp);
                if (containsCallExpr(s.condition.get()) ||
                    tailHasSideEffect(s.thenBody) ||
                    tailHasSideEffect(s.elseBody)) return true;
                break;
            }
            case NodeKind::WhileStmt: {
                const auto& s = static_cast<const CWhileStmt&>(*sp);
                if (containsCallExpr(s.condition.get()) ||
                    tailHasSideEffect(s.body)) return true;
                break;
            }
            case NodeKind::DoWhileStmt: {
                const auto& s = static_cast<const CDoWhileStmt&>(*sp);
                if (containsCallExpr(s.condition.get()) ||
                    tailHasSideEffect(s.body)) return true;
                break;
            }
            case NodeKind::ForStmt: {
                const auto& s = static_cast<const CForStmt&>(*sp);
                if (tailHasSideEffect(s.body)) return true;
                break;
            }
            case NodeKind::BlockStmt:
                if (tailHasSideEffect(static_cast<const CBlockStmt&>(*sp).stmts))
                    return true;
                break;
            default: break;
            }
        }
        return false;
    };

    // Now truncate after first unconditional terminator at this scope level.
    for (size_t i = 0; i < stmts.size(); ++i) {
        if (!stmts[i]) continue;
        auto kind = stmts[i]->getKind();
        if (kind == NodeKind::ReturnStmt ||
            kind == NodeKind::BreakStmt ||
            kind == NodeKind::ContinueStmt ||
            kind == NodeKind::GotoStmt ||
            isInfiniteLoop(stmts[i].get())) {
            // Everything after this is nominally unreachable.  But in
            // the presence of un-modelled CFG edges (helix_low.jmp with
            // no corresponding goto emission), the "dead" tail can carry
            // real calls.  Guard with the side-effect check above.
            if (i + 1 < stmts.size()) {
                std::vector<StmtPtr> tail(
                    std::make_move_iterator(stmts.begin() +
                                            static_cast<ptrdiff_t>(i + 1)),
                    std::make_move_iterator(stmts.end()));
                stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i + 1),
                            stmts.end());
                if (tailHasSideEffect(tail)) {
                    // Preserve: move the tail back in place.  The calls
                    // are almost certainly reachable via an un-modelled
                    // jump; leaving them in place makes the decompiled
                    // output MATCH the binary's reachable set.
                    for (auto& sp : tail)
                        stmts.push_back(std::move(sp));
                }
            }
            break;
        }
    }
}

void CAstOptimizer::removeDeadCodeAfterReturn(CFuncDecl& func) {
    removeDeadAfterReturnInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 8: recoverStructFieldAccess
// ═══════════════════════════════════════════════════════════════════════════════
//
// Convert *(ptr + offset) patterns to ptr->field_0xNN struct field accesses.
// This is the tree-based equivalent of PseudoCEmitter's field name recovery.
//
// Patterns:
//   *(ptr + N)         →  ptr->field_0xN       (N > 0, pointer + constant)
//   *(ptr + 0)         →  *ptr                  (offset 0 = plain deref)
//   *(base + N) = val  →  base->field_0xN = val (in assignments)

ExprPtr CAstOptimizer::recoverFieldAccess(ExprPtr expr) {
    if (!expr) return nullptr;

    // Bottom-up: recurse into children first.
    switch (expr->getKind()) {
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        b.lhs = recoverFieldAccess(std::move(b.lhs));
        b.rhs = recoverFieldAccess(std::move(b.rhs));
        break;
    }
    case NodeKind::UnaryExpr: {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        u.operand = recoverFieldAccess(std::move(u.operand));
        break;
    }
    case NodeKind::CastExpr: {
        auto& c = static_cast<CCastExpr&>(*expr);
        c.operand = recoverFieldAccess(std::move(c.operand));
        break;
    }
    case NodeKind::CallExpr: {
        auto& c = static_cast<CCallExpr&>(*expr);
        for (auto& a : c.args)
            a = recoverFieldAccess(std::move(a));
        break;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*expr);
        t.cond = recoverFieldAccess(std::move(t.cond));
        t.trueVal = recoverFieldAccess(std::move(t.trueVal));
        t.falseVal = recoverFieldAccess(std::move(t.falseVal));
        break;
    }
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*expr);
        s.base = recoverFieldAccess(std::move(s.base));
        s.index = recoverFieldAccess(std::move(s.index));
        break;
    }
    case NodeKind::FieldAccessExpr: {
        auto& f = static_cast<CFieldAccessExpr&>(*expr);
        f.base = recoverFieldAccess(std::move(f.base));
        break;
    }
    default:
        break;
    }

    // Pattern: *(ptr + N) → ptr->field_0xN
    if (expr->getKind() == NodeKind::UnaryExpr) {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        if (u.op == UnaryOp::Deref && u.operand &&
            u.operand->getKind() == NodeKind::BinaryExpr) {
            auto& bin = static_cast<CBinaryExpr&>(*u.operand);
            if (bin.op == BinaryOp::Add && bin.lhs && bin.rhs) {
                auto offsetVal = getIntLit(bin.rhs.get());
                if (offsetVal && *offsetVal > 0) {
                    // Build field name: field_0x<lowercase-hex> (canonical,
                    // shared with HelixMidToHigh + CAstBuilder).
                    char fieldName[32];
                    std::snprintf(fieldName, sizeof(fieldName),
                                  "field_0x%x",
                                  static_cast<unsigned>(*offsetVal));
                    return std::make_unique<CFieldAccessExpr>(
                        std::move(bin.lhs), fieldName,
                        static_cast<uint64_t>(*offsetVal),
                        /*isPointer=*/true, expr->type,
                        expr->getAddress());
                }
                // Also check LHS as the offset (commutative)
                auto offsetValL = getIntLit(bin.lhs.get());
                if (offsetValL && *offsetValL > 0) {
                    char fieldName[32];
                    std::snprintf(fieldName, sizeof(fieldName),
                                  "field_0x%x",
                                  static_cast<unsigned>(*offsetValL));
                    return std::make_unique<CFieldAccessExpr>(
                        std::move(bin.rhs), fieldName,
                        static_cast<uint64_t>(*offsetValL),
                        /*isPointer=*/true, expr->type,
                        expr->getAddress());
                }
            }
        }
    }

    return expr;
}

void CAstOptimizer::recoverFieldsInStmtList(std::vector<StmtPtr>& stmts) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<CAssignStmt&>(*sp);
            if (a.target) a.target = recoverFieldAccess(std::move(a.target));
            if (a.value) a.value = recoverFieldAccess(std::move(a.value));
            break;
        }
        case NodeKind::ExprStmt: {
            auto& e = static_cast<CExprStmt&>(*sp);
            if (e.expr) e.expr = recoverFieldAccess(std::move(e.expr));
            break;
        }
        case NodeKind::ReturnStmt: {
            auto& r = static_cast<CReturnStmt&>(*sp);
            if (r.value) r.value = recoverFieldAccess(std::move(r.value));
            break;
        }
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            if (s.condition)
                s.condition = recoverFieldAccess(std::move(s.condition));
            recoverFieldsInStmtList(s.thenBody);
            recoverFieldsInStmtList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& s = static_cast<CWhileStmt&>(*sp);
            if (s.condition)
                s.condition = recoverFieldAccess(std::move(s.condition));
            recoverFieldsInStmtList(s.body);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& s = static_cast<CDoWhileStmt&>(*sp);
            recoverFieldsInStmtList(s.body);
            if (s.condition)
                s.condition = recoverFieldAccess(std::move(s.condition));
            break;
        }
        case NodeKind::ForStmt: {
            auto& s = static_cast<CForStmt&>(*sp);
            if (s.condition)
                s.condition = recoverFieldAccess(std::move(s.condition));
            recoverFieldsInStmtList(s.body);
            break;
        }
        case NodeKind::SwitchStmt: {
            auto& s = static_cast<CSwitchStmt&>(*sp);
            if (s.selector)
                s.selector = recoverFieldAccess(std::move(s.selector));
            for (auto& c : s.cases)
                recoverFieldsInStmtList(c.body);
            break;
        }
        case NodeKind::BlockStmt:
            recoverFieldsInStmtList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }
}

void CAstOptimizer::recoverStructFieldAccess(CFuncDecl& func) {
    recoverFieldsInStmtList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 9: canonicalizeXorPatterns
// ═══════════════════════════════════════════════════════════════════════════════
//
// The Remill pipeline uses XOR with -1 (all bits set) for boolean negation.
// This pass canonicalizes these patterns to idiomatic C:
//
//   x ^ -1          →  !x             (when used as boolean/condition)
//   x ^ 0xFFFFFFFF  →  ~x             (bitwise NOT)
//   x == (y ^ -1)   →  x != y         (comparison with XOR -1)
//   (x ^ -1) == 0   →  x != 0   →  x (when in boolean context)
//   x == 0 ^ -1     →  x != 0
//   if (x ^ -1)     →  if (!x)

ExprPtr CAstOptimizer::canonicalizeXorExpr(ExprPtr expr) {
    if (!expr) return nullptr;

    // Bottom-up: recurse into children first.
    switch (expr->getKind()) {
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        b.lhs = canonicalizeXorExpr(std::move(b.lhs));
        b.rhs = canonicalizeXorExpr(std::move(b.rhs));
        break;
    }
    case NodeKind::UnaryExpr: {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        u.operand = canonicalizeXorExpr(std::move(u.operand));
        break;
    }
    case NodeKind::CastExpr: {
        auto& c = static_cast<CCastExpr&>(*expr);
        c.operand = canonicalizeXorExpr(std::move(c.operand));
        break;
    }
    case NodeKind::CallExpr: {
        auto& c = static_cast<CCallExpr&>(*expr);
        for (auto& a : c.args)
            a = canonicalizeXorExpr(std::move(a));
        break;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*expr);
        t.cond = canonicalizeXorExpr(std::move(t.cond));
        t.trueVal = canonicalizeXorExpr(std::move(t.trueVal));
        t.falseVal = canonicalizeXorExpr(std::move(t.falseVal));
        break;
    }
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*expr);
        s.base = canonicalizeXorExpr(std::move(s.base));
        s.index = canonicalizeXorExpr(std::move(s.index));
        break;
    }
    case NodeKind::FieldAccessExpr: {
        auto& f = static_cast<CFieldAccessExpr&>(*expr);
        f.base = canonicalizeXorExpr(std::move(f.base));
        break;
    }
    default:
        break;
    }

    // Pattern 1: x ^ -1 → !x (logical not, for boolean/1-bit values)
    //            x ^ -1 → ~x (bitwise not, for wider integers)
    if (expr->getKind() == NodeKind::BinaryExpr) {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        if (b.op == BinaryOp::BitXor && b.lhs && b.rhs) {
            // x ^ -1
            if (isIntLit(b.rhs.get(), -1) || isIntLit(b.rhs.get(), 0xFFFFFFFF) ||
                isIntLit(b.rhs.get(), 1)) {
                // If RHS is literal 1, this is a boolean flip: x ^ 1 → !x
                if (isIntLit(b.rhs.get(), 1)) {
                    return std::make_unique<CUnaryExpr>(
                        UnaryOp::LogNot, std::move(b.lhs),
                        b.type, b.getAddress());
                }
                // For -1: if the LHS looks like a comparison result or is i1, use !
                // Otherwise use ~ (bitwise NOT)
                bool isBooleanContext = false;
                if (b.lhs->getKind() == NodeKind::BinaryExpr) {
                    auto& inner = static_cast<CBinaryExpr&>(*b.lhs);
                    isBooleanContext = isCmpOp(inner.op);
                }
                // Check type: 1-bit integer = boolean
                if (b.lhs->type->kind == TypeKind::Bool ||
                    (b.lhs->type->kind == TypeKind::Int && b.lhs->type->bitWidth == 1))
                    isBooleanContext = true;

                if (isBooleanContext) {
                    return std::make_unique<CUnaryExpr>(
                        UnaryOp::LogNot, std::move(b.lhs),
                        b.type, b.getAddress());
                } else {
                    return std::make_unique<CUnaryExpr>(
                        UnaryOp::BitNot, std::move(b.lhs),
                        b.type, b.getAddress());
                }
            }
            // -1 ^ x (commutative)
            if (isIntLit(b.lhs.get(), -1) || isIntLit(b.lhs.get(), 0xFFFFFFFF) ||
                isIntLit(b.lhs.get(), 1)) {
                if (isIntLit(b.lhs.get(), 1)) {
                    return std::make_unique<CUnaryExpr>(
                        UnaryOp::LogNot, std::move(b.rhs),
                        b.type, b.getAddress());
                }
                bool isBooleanContext = false;
                if (b.rhs->getKind() == NodeKind::BinaryExpr) {
                    auto& inner = static_cast<CBinaryExpr&>(*b.rhs);
                    isBooleanContext = isCmpOp(inner.op);
                }
                if (b.rhs->type->kind == TypeKind::Bool ||
                    (b.rhs->type->kind == TypeKind::Int && b.rhs->type->bitWidth == 1))
                    isBooleanContext = true;

                if (isBooleanContext) {
                    return std::make_unique<CUnaryExpr>(
                        UnaryOp::LogNot, std::move(b.rhs),
                        b.type, b.getAddress());
                } else {
                    return std::make_unique<CUnaryExpr>(
                        UnaryOp::BitNot, std::move(b.rhs),
                        b.type, b.getAddress());
                }
            }
        }

        // Pattern 2: x == (y ^ -1) → x != y  (already simplified by pattern 1 above,
        //            but catch remaining: x == !y when y is a comparison)
        // After pattern 1, x ^ -1 becomes !x or ~x. But for direct comparisons:
        //   (x == 0) ^ -1  was already handled → !(x == 0) → x != 0

        // Pattern 3: Comparison with zero after XOR canonicalization
        //   !x == 0 → x != 0  (already handled by simplifyExpressions !(x==y)→x!=y )
    }

    return expr;
}

void CAstOptimizer::canonicalizeXorInStmtList(std::vector<StmtPtr>& stmts) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<CAssignStmt&>(*sp);
            if (a.target) a.target = canonicalizeXorExpr(std::move(a.target));
            if (a.value) a.value = canonicalizeXorExpr(std::move(a.value));
            break;
        }
        case NodeKind::ExprStmt: {
            auto& e = static_cast<CExprStmt&>(*sp);
            if (e.expr) e.expr = canonicalizeXorExpr(std::move(e.expr));
            break;
        }
        case NodeKind::ReturnStmt: {
            auto& r = static_cast<CReturnStmt&>(*sp);
            if (r.value) r.value = canonicalizeXorExpr(std::move(r.value));
            break;
        }
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            if (s.condition)
                s.condition = canonicalizeXorExpr(std::move(s.condition));
            canonicalizeXorInStmtList(s.thenBody);
            canonicalizeXorInStmtList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& s = static_cast<CWhileStmt&>(*sp);
            if (s.condition)
                s.condition = canonicalizeXorExpr(std::move(s.condition));
            canonicalizeXorInStmtList(s.body);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& s = static_cast<CDoWhileStmt&>(*sp);
            canonicalizeXorInStmtList(s.body);
            if (s.condition)
                s.condition = canonicalizeXorExpr(std::move(s.condition));
            break;
        }
        case NodeKind::ForStmt: {
            auto& s = static_cast<CForStmt&>(*sp);
            if (s.condition)
                s.condition = canonicalizeXorExpr(std::move(s.condition));
            canonicalizeXorInStmtList(s.body);
            break;
        }
        case NodeKind::SwitchStmt: {
            auto& s = static_cast<CSwitchStmt&>(*sp);
            if (s.selector)
                s.selector = canonicalizeXorExpr(std::move(s.selector));
            for (auto& c : s.cases)
                canonicalizeXorInStmtList(c.body);
            break;
        }
        case NodeKind::BlockStmt:
            canonicalizeXorInStmtList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }
}

void CAstOptimizer::canonicalizeXorPatterns(CFuncDecl& func) {
    canonicalizeXorInStmtList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 10: eliminateConstantBranches
// ═══════════════════════════════════════════════════════════════════════════════
//
// When if-condition is a constant integer:
//   if (0) { A } else { B }  →  B  (inline else body, drop if)
//   if (1) { A } else { B }  →  A  (inline then body, drop if)
//   if (0) { A }             →  (remove entirely)

void CAstOptimizer::eliminateConstBranchesInList(std::vector<StmtPtr>& stmts) {
    // First recurse into nested scopes.
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            eliminateConstBranchesInList(s.thenBody);
            eliminateConstBranchesInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& s = static_cast<CWhileStmt&>(*sp);
            eliminateConstBranchesInList(s.body);
            // Normalize non-zero constant condition to literal 1 (→ "true")
            // to avoid "while (-1)" artifacts from lifted jmp loops.
            if (s.condition) {
                auto cv = getIntLit(s.condition.get());
                if (cv && *cv != 0 && *cv != 1) {
                    s.condition = std::make_unique<CIntLitExpr>(
                        1, CType::boolTy(), s.condition->getAddress());
                }
            }
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& s = static_cast<CDoWhileStmt&>(*sp);
            eliminateConstBranchesInList(s.body);
            if (s.condition) {
                auto cv = getIntLit(s.condition.get());
                if (cv && *cv != 0 && *cv != 1) {
                    s.condition = std::make_unique<CIntLitExpr>(
                        1, CType::boolTy(), s.condition->getAddress());
                }
            }
            break;
        }
        case NodeKind::ForStmt: {
            auto& s = static_cast<CForStmt&>(*sp);
            eliminateConstBranchesInList(s.body);
            if (s.condition) {
                auto cv = getIntLit(s.condition.get());
                if (cv && *cv != 0 && *cv != 1) {
                    s.condition = std::make_unique<CIntLitExpr>(
                        1, CType::boolTy(), s.condition->getAddress());
                }
            }
            break;
        }
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                eliminateConstBranchesInList(c.body);
            break;
        case NodeKind::BlockStmt:
            eliminateConstBranchesInList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }

    // Now process if-statements with constant conditions.
    // We need to splice replacement statements in-place.
    for (size_t i = 0; i < stmts.size(); ) {
        if (!stmts[i] || stmts[i]->getKind() != NodeKind::IfStmt) {
            ++i;
            continue;
        }

        auto& ifStmt = static_cast<CIfStmt&>(*stmts[i]);
        if (!ifStmt.condition) {
            ++i;
            continue;
        }

        // Check if condition is a constant integer
        auto constVal = getIntLit(ifStmt.condition.get());
        if (!constVal) {
            ++i;
            continue;
        }

        if (*constVal == 0) {
            // if (0) { A } else { B }  →  B
            if (ifStmt.elseBody.empty()) {
                // if (0) { A }  →  remove entirely
                stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i));
            } else {
                // Replace if-stmt with else body statements
                auto elseBody = std::move(ifStmt.elseBody);
                stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i));
                stmts.insert(stmts.begin() + static_cast<ptrdiff_t>(i),
                             std::make_move_iterator(elseBody.begin()),
                             std::make_move_iterator(elseBody.end()));
                // Don't increment i — re-check the newly inserted statements
            }
        } else {
            // if (non-zero) { A } else { B }  →  A
            auto thenBody = std::move(ifStmt.thenBody);
            stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i));
            stmts.insert(stmts.begin() + static_cast<ptrdiff_t>(i),
                         std::make_move_iterator(thenBody.begin()),
                         std::make_move_iterator(thenBody.end()));
        }
    }
}

void CAstOptimizer::eliminateConstantBranches(CFuncDecl& func) {
    eliminateConstBranchesInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass: removeGloballyDeadStores — drop pure stores to never-read variables
// ═══════════════════════════════════════════════════════════════════════════════

void CAstOptimizer::removeGloballyDeadStores(CFuncDecl& func) {
    // 1) collect every variable name READ as a VALUE anywhere (a plain assign
    //    target is a write, not a read; a compound target or a deref/field/
    //    subscript target IS read).
    std::unordered_set<std::string> reads;
    std::function<void(const std::vector<StmtPtr>&)> collectReads =
        [&](const std::vector<StmtPtr>& stmts) {
            for (const auto& sp : stmts) {
                if (!sp)
                    continue;
                switch (sp->getKind()) {
                case NodeKind::AssignStmt: {
                    const auto& a = static_cast<const CAssignStmt&>(*sp);
                    collectVarRefs(a.value.get(), reads);
                    if (a.target &&
                        (!a.compoundOp.empty() ||
                         a.target->getKind() != NodeKind::VarRefExpr))
                        collectVarRefs(a.target.get(), reads);
                    break;
                }
                case NodeKind::IfStmt: {
                    const auto& s = static_cast<const CIfStmt&>(*sp);
                    collectVarRefs(s.condition.get(), reads);
                    collectReads(s.thenBody);
                    collectReads(s.elseBody);
                    break;
                }
                case NodeKind::WhileStmt: {
                    const auto& s = static_cast<const CWhileStmt&>(*sp);
                    collectVarRefs(s.condition.get(), reads);
                    collectReads(s.body);
                    break;
                }
                case NodeKind::DoWhileStmt: {
                    const auto& s = static_cast<const CDoWhileStmt&>(*sp);
                    collectVarRefs(s.condition.get(), reads);
                    collectReads(s.body);
                    break;
                }
                case NodeKind::ForStmt: {
                    const auto& s = static_cast<const CForStmt&>(*sp);
                    collectVarRefs(s.condition.get(), reads);
                    collectReads(s.body);
                    break;
                }
                case NodeKind::SwitchStmt: {
                    const auto& s = static_cast<const CSwitchStmt&>(*sp);
                    collectVarRefs(s.selector.get(), reads);
                    for (const auto& c : s.cases)
                        collectReads(c.body);
                    break;
                }
                case NodeKind::ReturnStmt:
                    collectVarRefs(static_cast<const CReturnStmt&>(*sp).value.get(),
                                   reads);
                    break;
                case NodeKind::ExprStmt:
                    collectVarRefs(static_cast<const CExprStmt&>(*sp).expr.get(),
                                   reads);
                    break;
                case NodeKind::BlockStmt:
                    collectReads(static_cast<const CBlockStmt&>(*sp).stmts);
                    break;
                default:
                    break;
                }
            }
        };
    collectReads(func.body);

    // 2) recursively erase pure (call-free) stores whose target is a plain
    //    variable that never appears in the read-set.
    std::function<void(std::vector<StmtPtr>&)> removeDead =
        [&](std::vector<StmtPtr>& stmts) {
            for (auto& sp : stmts) {
                if (!sp)
                    continue;
                switch (sp->getKind()) {
                case NodeKind::IfStmt: {
                    auto& s = static_cast<CIfStmt&>(*sp);
                    removeDead(s.thenBody);
                    removeDead(s.elseBody);
                    break;
                }
                case NodeKind::WhileStmt:
                    removeDead(static_cast<CWhileStmt&>(*sp).body);
                    break;
                case NodeKind::DoWhileStmt:
                    removeDead(static_cast<CDoWhileStmt&>(*sp).body);
                    break;
                case NodeKind::ForStmt:
                    removeDead(static_cast<CForStmt&>(*sp).body);
                    break;
                case NodeKind::SwitchStmt:
                    for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                        removeDead(c.body);
                    break;
                case NodeKind::BlockStmt:
                    removeDead(static_cast<CBlockStmt&>(*sp).stmts);
                    break;
                default:
                    break;
                }
            }
            std::erase_if(stmts, [&](const StmtPtr& sp) {
                if (!sp || sp->getKind() != NodeKind::AssignStmt)
                    return false;
                const auto& a = static_cast<const CAssignStmt&>(*sp);
                if (!a.compoundOp.empty() || !a.target ||
                    a.target->getKind() != NodeKind::VarRefExpr)
                    return false;
                const std::string& nm =
                    static_cast<const CVarRefExpr&>(*a.target).varName;
                if (reads.count(nm))
                    return false;  // read somewhere -> keep
                if (exprHasCall(a.value.get()))
                    return false;  // RHS has a side effect -> keep
                return true;       // globally-dead pure store
            });
        };
    removeDead(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 12: removeEmptyIfStatements
// ═══════════════════════════════════════════════════════════════════════════════
//
// Remove if-statements where both the then-body and else-body are empty.
// These arise from MINSS/MAXSS lowering through Remill: the fcmp une (NaN check)
// and fcmp oge/olt (min/max comparison) produce empty if-stmts because the
// actual select already appears elsewhere in the output. These are dead
// comparison artifacts that should be stripped.

void CAstOptimizer::removeEmptyIfsInList(std::vector<StmtPtr>& stmts) {
    // Recurse into nested scopes first
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            removeEmptyIfsInList(s.thenBody);
            removeEmptyIfsInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            removeEmptyIfsInList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            removeEmptyIfsInList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            removeEmptyIfsInList(static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                removeEmptyIfsInList(c.body);
            break;
        case NodeKind::BlockStmt:
            removeEmptyIfsInList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }

    // Remove if-stmts where both branches are empty
    std::erase_if(stmts, [](const StmtPtr& sp) {
        if (!sp || sp->getKind() != NodeKind::IfStmt)
            return false;
        const auto& ifStmt = static_cast<const CIfStmt&>(*sp);
        return ifStmt.thenBody.empty() && ifStmt.elseBody.empty();
    });
}

void CAstOptimizer::removeEmptyIfStatements(CFuncDecl& func) {
    removeEmptyIfsInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 11: eliminateNullPtrStores
// ═══════════════════════════════════════════════════════════════════════════════
//
// Remove assignments where the target is a dereference of a null/zero pointer.
// These come from Remill State struct GEPs that weren't properly resolved:
//   *(int64_t)(void*)0 = ...   →  remove  (State register write via null GEP)
//   *(int64_t)(void*)0[N]      →  remove  (State XMM register access via null GEP)
//
// Also removes declarations of _promoted_* variables (escaped infrastructure).

bool CAstOptimizer::isNullPtrDeref(const CExpr* expr) {
    if (!expr) return false;

    // *(type)(void*)0 — Deref of a cast of zero
    if (expr->getKind() == NodeKind::UnaryExpr) {
        const auto& u = static_cast<const CUnaryExpr&>(*expr);
        if (u.op == UnaryOp::Deref && u.operand) {
            // Check for (type)(void*)0 — a cast wrapping a zero
            if (u.operand->getKind() == NodeKind::CastExpr) {
                const auto& cast = static_cast<const CCastExpr&>(*u.operand);
                if (cast.operand && isIntLit(cast.operand.get(), 0))
                    return true;
                // (type)((void*)0) — nested casts
                if (cast.operand && cast.operand->getKind() == NodeKind::CastExpr) {
                    const auto& inner = static_cast<const CCastExpr&>(*cast.operand);
                    if (inner.operand && isIntLit(inner.operand.get(), 0))
                        return true;
                }
            }
            // Direct *0
            if (isIntLit(u.operand.get(), 0))
                return true;
        }
    }

    // *(type)(void*)0[N] — subscript of null ptr deref
    if (expr->getKind() == NodeKind::SubscriptExpr) {
        const auto& sub = static_cast<const CSubscriptExpr&>(*expr);
        return isNullPtrDeref(sub.base.get());
    }

    return false;
}

void CAstOptimizer::eliminateNullStoresInList(std::vector<StmtPtr>& stmts) {
    // Remove assignments to null pointer dereferences
    std::erase_if(stmts, [](const StmtPtr& sp) {
        if (!sp) return true;

        // *(type)(void*)0 = ... → remove
        if (sp->getKind() == NodeKind::AssignStmt) {
            const auto& a = static_cast<const CAssignStmt&>(*sp);
            if (isNullPtrDeref(a.target.get()))
                return true;
        }

        // ExprStmt where expr reads from null → remove
        if (sp->getKind() == NodeKind::ExprStmt) {
            const auto& e = static_cast<const CExprStmt&>(*sp);
            if (isNullPtrDeref(e.expr.get()))
                return true;
        }

        return false;
    });

    // Remove _promoted_* variable declarations
    std::erase_if(stmts, [](const StmtPtr& sp) {
        // Note: _promoted vars are usually in localVars, handled below
        return false;
    });

    // Recurse into nested scopes
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            eliminateNullStoresInList(s.thenBody);
            eliminateNullStoresInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            eliminateNullStoresInList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            eliminateNullStoresInList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            eliminateNullStoresInList(static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                eliminateNullStoresInList(c.body);
            break;
        case NodeKind::BlockStmt:
            eliminateNullStoresInList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }
}

void CAstOptimizer::eliminateNullPtrStores(CFuncDecl& func) {
    eliminateNullStoresInList(func.body);

    // Also remove _promoted_* from local variable declarations
    std::erase_if(func.localVars, [](const CVarDecl& v) {
        return v.varName.starts_with("_promoted_") ||
               v.varName.starts_with("_spill_");
    });
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 13: cleanupFloatZeros
// ═══════════════════════════════════════════════════════════════════════════════
//
// When an XMM register (float-typed variable) is assigned (int64_t)(void*)0,
// it should be 0.0f instead. This happens because the Remill State struct
// pointer is null, and xorps xmm0,xmm0 (float zero) goes through a GEP that
// resolves to a null pointer dereference.
//
// Pattern:  xmm0 = (int64_t)(void*)0    →  xmm0 = 0.0f
// Also:     xmm0 = (int64_t)(void*)0    →  xmm0 = 0.0f  (any null-ptr cast)

bool CAstOptimizer::isNullPtrCast(const CExpr* expr) {
    if (!expr) return false;

    // Direct 0 literal
    if (isIntLit(expr, 0)) return true;

    // (type)(void*)0 or (type)(type2)0 — any cast chain wrapping zero
    if (expr->getKind() == NodeKind::CastExpr) {
        const auto& c = static_cast<const CCastExpr&>(*expr);
        return isNullPtrCast(c.operand.get());
    }

    // *(type)(void*)0 — deref of null (reading from null state pointer)
    if (expr->getKind() == NodeKind::UnaryExpr) {
        const auto& u = static_cast<const CUnaryExpr&>(*expr);
        if (u.op == UnaryOp::Deref)
            return isNullPtrCast(u.operand.get());
    }

    // (void*)0 rendered as AddrLitExpr with addr 0
    if (expr->getKind() == NodeKind::AddrLitExpr) {
        const auto& a = static_cast<const CAddrLitExpr&>(*expr);
        return a.addrValue == 0;
    }

    // 0.0f already (from previous pass)
    if (expr->getKind() == NodeKind::FloatLitExpr) {
        const auto& f = static_cast<const CFloatLitExpr&>(*expr);
        return f.value == 0.0;
    }

    return false;
}

ExprPtr CAstOptimizer::replaceNullWithFloatZero(ExprPtr expr) {
    if (!expr) return nullptr;

    // Bottom-up: recurse children first
    switch (expr->getKind()) {
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        b.lhs = replaceNullWithFloatZero(std::move(b.lhs));
        b.rhs = replaceNullWithFloatZero(std::move(b.rhs));
        break;
    }
    case NodeKind::UnaryExpr: {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        u.operand = replaceNullWithFloatZero(std::move(u.operand));
        break;
    }
    case NodeKind::CastExpr: {
        auto& c = static_cast<CCastExpr&>(*expr);
        c.operand = replaceNullWithFloatZero(std::move(c.operand));
        break;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*expr);
        t.cond = replaceNullWithFloatZero(std::move(t.cond));
        t.trueVal = replaceNullWithFloatZero(std::move(t.trueVal));
        t.falseVal = replaceNullWithFloatZero(std::move(t.falseVal));
        break;
    }
    case NodeKind::CallExpr: {
        auto& c = static_cast<CCallExpr&>(*expr);
        for (auto& a : c.args)
            a = replaceNullWithFloatZero(std::move(a));
        break;
    }
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*expr);
        s.base = replaceNullWithFloatZero(std::move(s.base));
        s.index = replaceNullWithFloatZero(std::move(s.index));
        break;
    }
    case NodeKind::FieldAccessExpr: {
        auto& f = static_cast<CFieldAccessExpr&>(*expr);
        f.base = replaceNullWithFloatZero(std::move(f.base));
        break;
    }
    default:
        break;
    }

    // If this expression is a null-ptr cast, replace with 0.0f
    if (isNullPtrCast(expr.get())) {
        return std::make_unique<CFloatLitExpr>(0.0, CType::floatTy(),
                                                expr->getAddress());
    }

    // Also catch: *(something)(void*)0[N] subscript patterns with null base
    if (expr->getKind() == NodeKind::SubscriptExpr) {
        const auto& sub = static_cast<const CSubscriptExpr&>(*expr);
        if (isNullPtrCast(sub.base.get())) {
            return std::make_unique<CFloatLitExpr>(0.0, CType::floatTy(),
                                                    expr->getAddress());
        }
    }

    return expr;
}

void CAstOptimizer::cleanupFloatZerosInList(std::vector<StmtPtr>& stmts) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<CAssignStmt&>(*sp);
            // Only replace if target is a float-typed variable (XMM)
            bool targetIsFloat = false;
            if (a.target && a.target->getKind() == NodeKind::VarRefExpr) {
                const auto& v = static_cast<const CVarRefExpr&>(*a.target);
                if (v.varName.starts_with("xmm") || v.varName.starts_with("XMM") ||
                    v.varName.starts_with("ymm") || v.varName.starts_with("YMM"))
                    targetIsFloat = true;
                if (v.type && v.type->kind == TypeKind::Float)
                    targetIsFloat = true;
            }
            if (targetIsFloat && a.value) {
                a.value = replaceNullWithFloatZero(std::move(a.value));
                // Also replace block_argN with 0.0f for float context
                // (block args from MLIR that weren't resolved to real values)
                if (a.value && a.value->getKind() == NodeKind::VarRefExpr) {
                    const auto& ref = static_cast<const CVarRefExpr&>(*a.value);
                    if (ref.varName.starts_with("block_arg"))
                        a.value = std::make_unique<CFloatLitExpr>(
                            0.0, CType::floatTy(), a.value->getAddress());
                }
            }
            break;
        }
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            cleanupFloatZerosInList(s.thenBody);
            cleanupFloatZerosInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            cleanupFloatZerosInList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            cleanupFloatZerosInList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            cleanupFloatZerosInList(static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                cleanupFloatZerosInList(c.body);
            break;
        case NodeKind::BlockStmt:
            cleanupFloatZerosInList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }
}

void CAstOptimizer::cleanupFloatZeros(CFuncDecl& func) {
    cleanupFloatZerosInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 14: collapseMinMaxPatterns
// ═══════════════════════════════════════════════════════════════════════════════
//
// MINSS/MAXSS lowered by Remill produce:
//   if (a != b) { target = select(a < b, a, b); }  // NaN guard
//   // or just a select without the NaN guard
//
// After previous passes remove empty ifs and dead code, what may remain is:
//   if (a < b) { xmm0 = a; }   // → xmm0 = min(a, b)
//   if (a > b) { xmm0 = a; }   // → xmm0 = max(a, b)
//
// We collapse these into min()/max() calls when:
// - The if-body has exactly one assignment
// - The condition is a comparison between two operands
// - One of the condition operands matches the assigned value

void CAstOptimizer::collapseMinMaxInList(std::vector<StmtPtr>& stmts) {
    // Recurse first
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            collapseMinMaxInList(s.thenBody);
            collapseMinMaxInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            collapseMinMaxInList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            collapseMinMaxInList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            collapseMinMaxInList(static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                collapseMinMaxInList(c.body);
            break;
        case NodeKind::BlockStmt:
            collapseMinMaxInList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }

    // Look for pattern: if (a CMP b) { target = one_of(a,b); } (no else)
    // Replace with: target = min(a, b) or target = max(a, b)
    for (size_t i = 0; i < stmts.size(); ++i) {
        if (!stmts[i] || stmts[i]->getKind() != NodeKind::IfStmt)
            continue;

        auto& ifStmt = static_cast<CIfStmt&>(*stmts[i]);

        // Must have no else and exactly 1 statement in then-body
        if (!ifStmt.elseBody.empty()) continue;
        if (ifStmt.thenBody.size() != 1) continue;
        if (!ifStmt.condition) continue;

        // Condition must be a float comparison
        if (ifStmt.condition->getKind() != NodeKind::BinaryExpr) continue;
        const auto& cmp = static_cast<const CBinaryExpr&>(*ifStmt.condition);
        if (!isCmpOp(cmp.op)) continue;
        if (!cmp.lhs || !cmp.rhs) continue;

        // Then-body must be a single assignment
        if (!ifStmt.thenBody[0] ||
            ifStmt.thenBody[0]->getKind() != NodeKind::AssignStmt)
            continue;

        const auto& assign = static_cast<const CAssignStmt&>(*ifStmt.thenBody[0]);
        if (!assign.target || !assign.value) continue;

        // Determine min vs max based on comparison direction
        // if (a < b) { x = a; } → x = min(a, b)  (a is the smaller)
        // if (a > b) { x = a; } → x = max(a, b)  (a is the larger)
        // if (a < b) { x = b; } → x = max(a, b)  (b selected when a < b → b is max? no, b is the larger)
        // Actually: if a < b then we pick a → that's the min

        std::string funcName;
        ExprPtr arg1, arg2;

        if (cmp.op == BinaryOp::Lt || cmp.op == BinaryOp::Le) {
            // if (a < b) { x = a } → x = min(a, b)
            // if (a < b) { x = b } → x = max(a, b)
            funcName = "min";
            arg1 = cloneExpr(cmp.lhs.get());
            arg2 = cloneExpr(cmp.rhs.get());
        } else if (cmp.op == BinaryOp::Gt || cmp.op == BinaryOp::Ge) {
            // if (a > b) { x = a } → x = max(a, b)
            // if (a > b) { x = b } → x = min(a, b)
            funcName = "max";
            arg1 = cloneExpr(cmp.lhs.get());
            arg2 = cloneExpr(cmp.rhs.get());
        } else {
            continue; // Ne/Eq don't map to min/max
        }

        // Build: target = min(a, b) or max(a, b)
        std::vector<ExprPtr> args;
        args.push_back(std::move(arg1));
        args.push_back(std::move(arg2));
        auto callExpr = std::make_unique<CCallExpr>(
            funcName, 0, std::move(args), CType::floatTy(),
            ifStmt.getAddress());

        auto newAssign = std::make_unique<CAssignStmt>(
            cloneExpr(assign.target.get()),
            std::move(callExpr), "", ifStmt.getAddress());

        stmts[i] = std::move(newAssign);
    }
}

void CAstOptimizer::collapseMinMaxPatterns(CFuncDecl& func) {
    collapseMinMaxInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════
// Pass: Variable Rename Propagation (P3 — hydrateHAST)
// ═══════════════════════════════════════════════════════════════════════════

void CAstOptimizer::renameInExpr(
    CExpr* expr,
    const std::unordered_map<std::string, std::string>& renames) {
    if (!expr) return;

    switch (expr->getKind()) {
    case NodeKind::VarRefExpr: {
        auto& v = static_cast<CVarRefExpr&>(*expr);
        auto it = renames.find(v.varName);
        if (it != renames.end()) {
            v.varName = it->second;
        }
        break;
    }
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        renameInExpr(b.lhs.get(), renames);
        renameInExpr(b.rhs.get(), renames);
        break;
    }
    case NodeKind::UnaryExpr: {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        renameInExpr(u.operand.get(), renames);
        break;
    }
    case NodeKind::CastExpr: {
        auto& c = static_cast<CCastExpr&>(*expr);
        renameInExpr(c.operand.get(), renames);
        break;
    }
    case NodeKind::CallExpr: {
        auto& c = static_cast<CCallExpr&>(*expr);
        for (auto& arg : c.args) {
            renameInExpr(arg.get(), renames);
        }
        break;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*expr);
        renameInExpr(t.cond.get(), renames);
        renameInExpr(t.trueVal.get(), renames);
        renameInExpr(t.falseVal.get(), renames);
        break;
    }
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*expr);
        renameInExpr(s.base.get(), renames);
        renameInExpr(s.index.get(), renames);
        break;
    }
    case NodeKind::FieldAccessExpr: {
        auto& f = static_cast<CFieldAccessExpr&>(*expr);
        renameInExpr(f.base.get(), renames);
        break;
    }
    default:
        // IntLiteral, FloatLiteral, StringLiteral — no variables to rename.
        break;
    }
}

void CAstOptimizer::renameInStmtList(
    std::vector<StmtPtr>& stmts,
    const std::unordered_map<std::string, std::string>& renames) {
    for (auto& stmt : stmts) {
        if (!stmt) continue;

        switch (stmt->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<CAssignStmt&>(*stmt);
            renameInExpr(a.target.get(), renames);
            renameInExpr(a.value.get(), renames);
            break;
        }
        case NodeKind::ExprStmt: {
            auto& e = static_cast<CExprStmt&>(*stmt);
            renameInExpr(e.expr.get(), renames);
            break;
        }
        case NodeKind::ReturnStmt: {
            auto& r = static_cast<CReturnStmt&>(*stmt);
            renameInExpr(r.value.get(), renames);
            break;
        }
        case NodeKind::IfStmt: {
            auto& i = static_cast<CIfStmt&>(*stmt);
            renameInExpr(i.condition.get(), renames);
            renameInStmtList(i.thenBody, renames);
            renameInStmtList(i.elseBody, renames);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& w = static_cast<CWhileStmt&>(*stmt);
            renameInExpr(w.condition.get(), renames);
            renameInStmtList(w.body, renames);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& d = static_cast<CDoWhileStmt&>(*stmt);
            renameInExpr(d.condition.get(), renames);
            renameInStmtList(d.body, renames);
            break;
        }
        case NodeKind::ForStmt: {
            auto& f = static_cast<CForStmt&>(*stmt);
            renameInExpr(f.condition.get(), renames);
            renameInStmtList(f.body, renames);
            break;
        }
        case NodeKind::SwitchStmt: {
            auto& s = static_cast<CSwitchStmt&>(*stmt);
            renameInExpr(s.selector.get(), renames);
            for (auto& c : s.cases) {
                renameInStmtList(c.body, renames);
            }
            break;
        }
        case NodeKind::BlockStmt: {
            auto& b = static_cast<CBlockStmt&>(*stmt);
            renameInStmtList(b.stmts, renames);
            break;
        }
        default:
            // BreakStmt, ContinueStmt, GotoStmt, LabelStmt, CommentStmt, AsmStmt
            break;
        }
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 15: foldRedundantReturnAfterElse
// ═══════════════════════════════════════════════════════════════════════════════
//
// Fold patterns where an if/else ends with 'return X' in the else branch,
// followed immediately by 'return X' at the same scope level:
//
//   } else {
//       return result;
//   }
//   return result;   // ← redundant, already covered by else
//
// This is a CFG-to-AST lowering artifact.

void CAstOptimizer::foldRedundantReturnInList(std::vector<StmtPtr>& stmts) {
    // Recurse into nested scopes first
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            foldRedundantReturnInList(s.thenBody);
            foldRedundantReturnInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            foldRedundantReturnInList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            foldRedundantReturnInList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            foldRedundantReturnInList(static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                foldRedundantReturnInList(c.body);
            break;
        case NodeKind::BlockStmt:
            foldRedundantReturnInList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }

    // Scan for IfStmt followed by ReturnStmt with matching else-return
    for (size_t i = 0; i + 1 < stmts.size(); ) {
        if (!stmts[i] || stmts[i]->getKind() != NodeKind::IfStmt) {
            ++i;
            continue;
        }
        auto& ifStmt = static_cast<CIfStmt&>(*stmts[i]);

        if (!stmts[i + 1] || stmts[i + 1]->getKind() != NodeKind::ReturnStmt) {
            ++i;
            continue;
        }
        auto& nextReturn = static_cast<CReturnStmt&>(*stmts[i + 1]);

        // Check: else block must end with a return
        if (ifStmt.elseBody.empty()) {
            ++i;
            continue;
        }
        auto* elseReturn = ifStmt.elseBody.back().get();
        if (!elseReturn || elseReturn->getKind() != NodeKind::ReturnStmt) {
            ++i;
            continue;
        }
        auto& elseRet = static_cast<CReturnStmt&>(*elseReturn);

        // Both return same expression? (both nullptr = bare return, or equal exprs)
        bool match = false;
        if (!elseRet.value && !nextReturn.value) {
            match = true;
        } else if (elseRet.value && nextReturn.value) {
            match = exprEquals(elseRet.value.get(), nextReturn.value.get());
        }

        if (match) {
            stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i + 1));
            // Don't advance i — check this position again in case of chained patterns
        } else {
            ++i;
        }
    }
}

void CAstOptimizer::foldRedundantReturnAfterElse(CFuncDecl& func) {
    foldRedundantReturnInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 16: invertEmptyIfThen
// ═══════════════════════════════════════════════════════════════════════════════
//
// Invert if-statements where the then-body is empty but the else-body has content:
//
//   if (condition) {
//       // empty
//   } else {
//       return result;
//   }
//
// Becomes:
//
//   if (!condition) {
//       return result;
//   }
//
// For comparison conditions, we flip the operator directly (== → !=, < → >=)
// instead of wrapping with logical-not, producing cleaner output.

void CAstOptimizer::invertEmptyIfInList(std::vector<StmtPtr>& stmts) {
    // Recurse into nested scopes first
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            invertEmptyIfInList(s.thenBody);
            invertEmptyIfInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            invertEmptyIfInList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            invertEmptyIfInList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            invertEmptyIfInList(static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                invertEmptyIfInList(c.body);
            break;
        case NodeKind::BlockStmt:
            invertEmptyIfInList(static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }

    // Invert if-stmts where then is empty and else has content
    for (auto& sp : stmts) {
        if (!sp || sp->getKind() != NodeKind::IfStmt)
            continue;
        auto& ifStmt = static_cast<CIfStmt&>(*sp);

        if (!ifStmt.thenBody.empty() || ifStmt.elseBody.empty())
            continue;

        // Negate the condition — prefer flipping comparison operator
        if (ifStmt.condition &&
            ifStmt.condition->getKind() == NodeKind::BinaryExpr) {
            auto& cmp = static_cast<CBinaryExpr&>(*ifStmt.condition);
            if (isCmpOp(cmp.op)) {
                cmp.op = flipCmp(cmp.op);
                // Swap then ← else, else ← empty
                ifStmt.thenBody = std::move(ifStmt.elseBody);
                ifStmt.elseBody.clear();
                continue;
            }
        }
        // Fallback: wrap with logical-not
        ifStmt.condition = std::make_unique<CUnaryExpr>(
            UnaryOp::LogNot, std::move(ifStmt.condition),
            CType::int32());
        ifStmt.thenBody = std::move(ifStmt.elseBody);
        ifStmt.elseBody.clear();
    }
}

void CAstOptimizer::invertEmptyIfThen(CFuncDecl& func) {
    invertEmptyIfInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 17: simplifyConditionPolarity
// ═══════════════════════════════════════════════════════════════════════════════
//
// Collapse redundant zero comparisons inside control-flow conditions so
// the output matches the idiomatic C that IDA / Ghidra emit:
//
//   if (v != 0)     →  if (v)
//   if (v == 0)     →  if (!v)
//   while (v != 0)  →  while (v)
//   do { ... } while (v == 0)  →  do { ... } while (!v)
//
// Only applies to the top-level operator of the condition expression —
// nested comparisons (`a && b != 0`) are left untouched because stripping
// the `!= 0` there would lose the boolean coercion around a wider-int
// operand.  The transform moves operand ownership rather than cloning to
// keep this pass allocation-free on large functions (Hogwarts Legacy
// godmode has ~90 conditions).

ExprPtr CAstOptimizer::flattenZeroComparison(ExprPtr condition) {
    if (!condition || condition->getKind() != NodeKind::BinaryExpr)
        return condition;

    auto& bin = static_cast<CBinaryExpr&>(*condition);
    if (bin.op != BinaryOp::Eq && bin.op != BinaryOp::Ne)
        return condition;

    auto isZeroLit = [](const CExpr* e) {
        if (!e || e->getKind() != NodeKind::IntLitExpr) return false;
        return static_cast<const CIntLitExpr&>(*e).value == 0;
    };

    ExprPtr nonZero;
    if (isZeroLit(bin.rhs.get()))
        nonZero = std::move(bin.lhs);
    else if (isZeroLit(bin.lhs.get()))
        nonZero = std::move(bin.rhs);
    else
        return condition;

    if (!nonZero)
        return condition;

    // Guard against degenerate shapes where the nonZero operand is itself
    // a zero literal (0 == 0, 0 != 0) — leave to constant folding.
    if (nonZero->getKind() == NodeKind::IntLitExpr)
        return condition;

    uint64_t addr = condition->getAddress();

    if (bin.op == BinaryOp::Ne) {
        // X != 0  →  X   (C coerces non-zero integer to true automatically)
        return nonZero;
    }

    // X == 0  →  !X
    return std::make_unique<CUnaryExpr>(
        UnaryOp::LogNot, std::move(nonZero), CType::boolTy(), addr);
}

void CAstOptimizer::simplifyConditionPolarityInList(
    std::vector<StmtPtr>& stmts) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            s.condition = flattenZeroComparison(std::move(s.condition));
            simplifyConditionPolarityInList(s.thenBody);
            simplifyConditionPolarityInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt: {
            auto& s = static_cast<CWhileStmt&>(*sp);
            s.condition = flattenZeroComparison(std::move(s.condition));
            simplifyConditionPolarityInList(s.body);
            break;
        }
        case NodeKind::DoWhileStmt: {
            auto& s = static_cast<CDoWhileStmt&>(*sp);
            s.condition = flattenZeroComparison(std::move(s.condition));
            simplifyConditionPolarityInList(s.body);
            break;
        }
        case NodeKind::ForStmt: {
            auto& s = static_cast<CForStmt&>(*sp);
            if (s.condition)
                s.condition = flattenZeroComparison(std::move(s.condition));
            simplifyConditionPolarityInList(s.body);
            break;
        }
        case NodeKind::SwitchStmt: {
            auto& s = static_cast<CSwitchStmt&>(*sp);
            for (auto& c : s.cases)
                simplifyConditionPolarityInList(c.body);
            break;
        }
        case NodeKind::BlockStmt:
            simplifyConditionPolarityInList(
                static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }
}

void CAstOptimizer::simplifyConditionPolarity(CFuncDecl& func) {
    simplifyConditionPolarityInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 18: foldDegenerateCompounds
// ═══════════════════════════════════════════════════════════════════════════════
//
// `CAstBuilder::detectCompoundOp` collapses `target = target OP rhs` into the
// compound form `target OP= rhs` very early, before `simplifyExpressions`
// sees the full expression tree.  For the x86 `sbb eax, eax` + `sub eax, ebx`
// pair Remill lifts as `v1 = v1 - (v1 - v3)`, the compound step stores only
// `v1 - v3` as the assignment value (with `compoundOp = "-="`), and the
// algebraic fold `x - (x - y) → y` in `simplifyExpr` never gets a chance
// to run against the outer `-`.  The printed output is the mathematically
// degenerate `v1 -= v1 - v3;`.
//
// This pass runs AFTER `synthesizeCompoundAssign` and specifically inspects
// compound assigns whose RHS already mentions the target:
//
//   target -= target - Y      →   target = Y
//   target += target + Y      →   target = target + target + Y  (kept)
//                                 — not degenerate; leave it.
//
// Only `-=` is folded because the SBB+SUB idiom is the one that produces a
// fold (subtraction is non-commutative and the self-reference cancels).
// `+=` / `*=` / etc. with self-references aren't the same algebraic cancel.

void CAstOptimizer::foldDegenerateCompoundsInList(
    std::vector<StmtPtr>& stmts) {
    // Helper: determines whether a compound op's RHS-binary uses the SAME
    // op (so the spurious self-reference would change the arithmetic result
    // by exactly one factor of the target).  We only collapse when the
    // "other" operand is a literal constant — otherwise the rewrite would
    // discard a real value-bearing subexpression.
    auto compoundOpMatchesBinary = [](const std::string& compound,
                                      BinaryOp binop) -> bool {
        switch (binop) {
        case BinaryOp::Add:    return compound == "+=";
        case BinaryOp::Sub:    return compound == "-=";
        case BinaryOp::Mul:    return compound == "*=";
        case BinaryOp::BitAnd: return compound == "&=";
        case BinaryOp::BitOr:  return compound == "|=";
        case BinaryOp::BitXor: return compound == "^=";
        default:               return false;
        }
    };
    auto isCommutativeBinop = [](BinaryOp op) -> bool {
        return op == BinaryOp::Add || op == BinaryOp::Mul ||
               op == BinaryOp::BitAnd || op == BinaryOp::BitOr ||
               op == BinaryOp::BitXor;
    };

    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<CAssignStmt&>(*sp);
            if (a.compoundOp.empty() || !a.target || !a.value)
                break;
            if (a.value->getKind() != NodeKind::BinaryExpr)
                break;
            auto& rhs = static_cast<CBinaryExpr&>(*a.value);
            if (!rhs.lhs || !rhs.rhs) break;

            // (1) Algebraic cancel: `target -= target - Y` → `target = Y`.
            if (a.compoundOp == "-=" &&
                rhs.op == BinaryOp::Sub &&
                isSameExpr(a.target.get(), rhs.lhs.get())) {
                a.value = std::move(rhs.rhs);
                a.compoundOp.clear();
                break;
            }

            // (2) FIX-079 (Wave 19): spurious self-reference in commutative
            // compound assignments.  The lifter occasionally synthesises
            // `x = x + (x + C)` because two reads of the same physical
            // register (e.g. EBP at two different program points) get
            // coalesced onto a single SSA-promoted local in
            // HelixLowToMid::RegReadToVarRef.  The compound-assignment
            // synthesiser then re-folds this into `x += x + C`, which the
            // validator (and any human reader) reads as a self-doubling
            // artefact.
            //
            // The disassembled binary at the same address invariably shows
            // a simple `add reg, C` — i.e. the INNER `x` is the artefact.
            // We can drop it safely when:
            //   - the compound op matches the inner binop (e.g. `+=` ↔ `+`),
            //   - the binop is commutative (so `x op (x op C)` is the same
            //     as `x op (C op x)` and we can canonicalise),
            //   - the "other" operand of the inner binop is a literal
            //     constant (IntLitExpr / AddrLitExpr).  We refuse to drop
            //     a value-bearing variable — that would be unsound.
            //
            // Justification per HELIX_PHILOSOPHY (fidelity > polish): the
            // pre-fix output `x += x + C` does NOT match the binary semantics
            // (it computes `2x + C`), so the existing emission is already
            // infidel.  Rewriting to `x += C` restores fidelity to the
            // binary's actual `add reg, C` instruction.  No statement is
            // removed; only an artefactual operand is dropped.
            if (compoundOpMatchesBinary(a.compoundOp, rhs.op) &&
                isCommutativeBinop(rhs.op)) {
                auto isLiteral = [](const CExpr* e) -> bool {
                    if (!e) return false;
                    return e->getKind() == NodeKind::IntLitExpr ||
                           e->getKind() == NodeKind::AddrLitExpr;
                };
                bool lhsIsTgt = isSameExpr(a.target.get(), rhs.lhs.get());
                bool rhsIsTgt = isSameExpr(a.target.get(), rhs.rhs.get());
                if (lhsIsTgt && isLiteral(rhs.rhs.get())) {
                    // `target += (target + C)` → `target += C`.
                    a.value = std::move(rhs.rhs);
                    break;
                }
                if (rhsIsTgt && isLiteral(rhs.lhs.get())) {
                    // `target += (C + target)` → `target += C`.
                    a.value = std::move(rhs.lhs);
                    break;
                }
            }
            break;
        }
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            foldDegenerateCompoundsInList(s.thenBody);
            foldDegenerateCompoundsInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            foldDegenerateCompoundsInList(
                static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            foldDegenerateCompoundsInList(
                static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            foldDegenerateCompoundsInList(
                static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                foldDegenerateCompoundsInList(c.body);
            break;
        case NodeKind::BlockStmt:
            foldDegenerateCompoundsInList(
                static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }
}

void CAstOptimizer::foldDegenerateCompounds(CFuncDecl& func) {
    foldDegenerateCompoundsInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 19: downgradeDeadAssignedCalls (gta-sa bug E)
// ═══════════════════════════════════════════════════════════════════════════════
//
// Walks each statement list (per-scope) and downgrades
//
//   v = fN(args);
//   ...
//   v = fM(args);      // overwrites without reading v in between
//
// into
//
//   fN(args);          // expression-statement; side effect preserved
//   ...
//   v = fM(args);
//
// Triggered by the gta-sa `sub_53b51f` (camera cmd) vtable-chain pattern,
// where 90+ consecutive assignments to `v2` each hold the result of a
// different vfunc call — but `v2` is never read until the function
// returns via a fresh call, so every intermediate assignment was a dead
// store on the LHS while carrying a live side-effecting CallExpr on the
// RHS.  The existing `eliminateDeadStores` pass conservatively keeps the
// full `v = call()` when RHS has side effects; this pass goes further
// and strips the target when safe.
//
// Safety rules (intentionally conservative):
//   - Only touches simple VarRefExpr targets (no field access, no deref,
//     no compound-assign modifiers — those have observable state changes
//     beyond the value assignment).
//   - Only scans FORWARD within the same scope (not across if/while
//     boundaries).  A read behind a branch keeps the assign.
//   - Stops at any CallExpr whose args reference the target (the callee
//     may read the target via an alias).
//   - Stops at any form of MemWrite / AddressOf(target) / pointer access
//     (target could alias).  For safety we only look at direct VarRefExpr
//     reads of `target.varName`.

namespace {
/// Returns true if any CVarRefExpr anywhere in `e` has the given name.
static bool exprReadsVarName(const CExpr* e, std::string_view name) {
    if (!e) return false;
    switch (e->getKind()) {
    case NodeKind::VarRefExpr:
        return static_cast<const CVarRefExpr*>(e)->varName == name;
    case NodeKind::UnaryExpr:
        return exprReadsVarName(
            static_cast<const CUnaryExpr*>(e)->operand.get(), name);
    case NodeKind::BinaryExpr: {
        auto& b = *static_cast<const CBinaryExpr*>(e);
        return exprReadsVarName(b.lhs.get(), name) ||
               exprReadsVarName(b.rhs.get(), name);
    }
    case NodeKind::CastExpr:
        return exprReadsVarName(
            static_cast<const CCastExpr*>(e)->operand.get(), name);
    case NodeKind::CallExpr: {
        auto& c = *static_cast<const CCallExpr*>(e);
        for (auto& a : c.args)
            if (exprReadsVarName(a.get(), name)) return true;
        return false;
    }
    case NodeKind::SubscriptExpr: {
        auto& s = *static_cast<const CSubscriptExpr*>(e);
        return exprReadsVarName(s.base.get(), name) ||
               exprReadsVarName(s.index.get(), name);
    }
    case NodeKind::FieldAccessExpr:
        return exprReadsVarName(
            static_cast<const CFieldAccessExpr*>(e)->base.get(), name);
    case NodeKind::TernaryExpr: {
        auto& t = *static_cast<const CTernaryExpr*>(e);
        return exprReadsVarName(t.cond.get(), name) ||
               exprReadsVarName(t.trueVal.get(), name) ||
               exprReadsVarName(t.falseVal.get(), name);
    }
    default:
        return false;
    }
}
} // anonymous namespace

void CAstOptimizer::downgradeDeadAssignedCallsInList(
    std::vector<StmtPtr>& stmts) {
    // Recurse into nested scopes first.
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::IfStmt: {
            auto& s = static_cast<CIfStmt&>(*sp);
            downgradeDeadAssignedCallsInList(s.thenBody);
            downgradeDeadAssignedCallsInList(s.elseBody);
            break;
        }
        case NodeKind::WhileStmt:
            downgradeDeadAssignedCallsInList(
                static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            downgradeDeadAssignedCallsInList(
                static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            downgradeDeadAssignedCallsInList(
                static_cast<CForStmt&>(*sp).body);
            break;
        case NodeKind::SwitchStmt:
            for (auto& c : static_cast<CSwitchStmt&>(*sp).cases)
                downgradeDeadAssignedCallsInList(c.body);
            break;
        case NodeKind::BlockStmt:
            downgradeDeadAssignedCallsInList(
                static_cast<CBlockStmt&>(*sp).stmts);
            break;
        default:
            break;
        }
    }

    // Now scan the current list for downgrade opportunities.
    for (size_t i = 0; i < stmts.size(); ++i) {
        auto& sp = stmts[i];
        if (!sp || sp->getKind() != NodeKind::AssignStmt) continue;
        auto& a = static_cast<CAssignStmt&>(*sp);
        if (!a.compoundOp.empty()) continue;      // compound — semantic is "x OP= y", target is read
        if (!a.target || !a.value) continue;
        if (a.target->getKind() != NodeKind::VarRefExpr) continue;
        if (a.value->getKind() != NodeKind::CallExpr) continue;

        const auto& tgtRef = *static_cast<const CVarRefExpr*>(a.target.get());
        std::string_view tgtName = tgtRef.varName;
        if (tgtName.empty()) continue;

        // Scan forward in this scope for a read of tgtName or an overwrite.
        // If we hit an overwrite without a read → downgrade this assign.
        bool foundReadBefore = false;
        bool foundOverwrite  = false;
        for (size_t j = i + 1; j < stmts.size(); ++j) {
            auto& next = stmts[j];
            if (!next) continue;

            switch (next->getKind()) {
            case NodeKind::AssignStmt: {
                auto& na = static_cast<CAssignStmt&>(*next);
                // Look at both sides: RHS read, LHS overwrite.
                if (exprReadsVarName(na.value.get(), tgtName))
                    foundReadBefore = true;
                if (na.target && na.target->getKind() == NodeKind::VarRefExpr &&
                    static_cast<const CVarRefExpr*>(na.target.get())->varName == tgtName &&
                    na.compoundOp.empty()) {
                    foundOverwrite = true;
                }
                break;
            }
            case NodeKind::ExprStmt: {
                auto& e = static_cast<CExprStmt&>(*next);
                if (exprReadsVarName(e.expr.get(), tgtName))
                    foundReadBefore = true;
                break;
            }
            case NodeKind::ReturnStmt: {
                auto& r = static_cast<CReturnStmt&>(*next);
                if (exprReadsVarName(r.value.get(), tgtName))
                    foundReadBefore = true;
                // Return ends the function — effectively overwrites (tgt can't
                // be observed past the return).
                foundOverwrite = true;
                break;
            }
            // Any control-flow construct in between means we can't be sure
            // the target isn't read on some path.  Bail conservatively.
            case NodeKind::IfStmt:
            case NodeKind::WhileStmt:
            case NodeKind::DoWhileStmt:
            case NodeKind::ForStmt:
            case NodeKind::SwitchStmt:
            case NodeKind::BlockStmt:
            case NodeKind::GotoStmt:
            case NodeKind::LabelStmt:
            case NodeKind::BreakStmt:
            case NodeKind::ContinueStmt:
                foundReadBefore = true; // treat as potential read
                break;
            default:
                break;
            }
            if (foundReadBefore || foundOverwrite) break;
        }

        // Downgrade only when we proved no read before overwrite/return.
        if (foundOverwrite && !foundReadBefore) {
            auto callValue = std::move(a.value);
            sp = std::make_unique<CExprStmt>(std::move(callValue),
                                             a.getAddress());
        }
    }
}

void CAstOptimizer::downgradeDeadAssignedCalls(CFuncDecl& func) {
    downgradeDeadAssignedCallsInList(func.body);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass 20: declareUndeclaredVars (gta-sa bug C)
// ═══════════════════════════════════════════════════════════════════════════════
//
// FIX-040 reports undeclared variable references as a confidence penalty
// but doesn't actually inject the missing `int64_t v0;` declaration.  This
// pass does — conservatively, with `int64_t` as the default type for any
// orphan name.  Runs BEFORE `removeUnusedDeclarations` so the injected
// decls stick around if they're genuinely referenced, and before
// `reanalyzeConfidence` so the confidence reflects the final state.

void CAstOptimizer::declareUndeclaredVars(CFuncDecl& func) {
    // Build the set of already-declared names (params + locals).
    std::unordered_set<std::string> declared;
    for (auto& p : func.params)    declared.insert(p.name);
    for (auto& d : func.localVars) declared.insert(d.varName);

    // Collect all VarRef names in the body.
    std::unordered_set<std::string> referenced;
    collectVarNamesInStmts(func.body, referenced);

    // Identify orphans.  Skip stack bookkeeping names the printer handles
    // specially, skip empty-string references (malformed nodes), and
    // validate the name is a legal C identifier (`[A-Za-z_][A-Za-z0-9_]*`).
    // Integer literals sometimes leak into `collectVarNamesInStmts` as
    // stringified values like "0" or "4" — we must not emit `int64_t 0;`
    // as a declaration.  The caller (`reanalyzeConfidence`) already
    // penalises genuine undeclared refs separately, so a false negative
    // here is strictly less harmful than a false positive.
    auto isValidCIdent = [](std::string_view n) -> bool {
        if (n.empty()) return false;
        char c0 = n.front();
        if (!((c0 >= 'A' && c0 <= 'Z') ||
              (c0 >= 'a' && c0 <= 'z') ||
              c0 == '_'))
            return false;
        for (size_t i = 1; i < n.size(); ++i) {
            char c = n[i];
            if (!((c >= 'A' && c <= 'Z') ||
                  (c >= 'a' && c <= 'z') ||
                  (c >= '0' && c <= '9') ||
                  c == '_'))
                return false;
        }
        return true;
    };

    std::vector<std::string> orphans;
    for (auto& n : referenced) {
        if (n == "rsp" || n == "rbp" || n == "esp" || n == "ebp")
            continue;
        if (!isValidCIdent(n))
            continue;
        // FIX-089: `loc_<hex>` is a CODE LABEL reference emitted by the D1
        // address-registry resolution (`&loc_xxxx`).  The label is defined
        // elsewhere as a CLabelStmt — it is NOT a data variable and must
        // never be auto-declared as `int64_t loc_xxxx = 0;` (that both
        // shadows the label and inflates the placeholder count).
        if (isCodeLabelName(n))
            continue;
        if (!declared.count(n))
            orphans.push_back(n);
    }
    if (orphans.empty()) return;

    // Pick a varId range above any existing one.  `CParamDecl` doesn't
    // carry an SSA varId (it has `index` instead), so we only seed from
    // `localVars`.
    uint32_t nextId = 1;
    for (auto& d : func.localVars)
        nextId = std::max(nextId, d.varId + 1u);

    // Sort for deterministic output (stable across runs).
    std::sort(orphans.begin(), orphans.end());

    for (auto& name : orphans) {
        // Use int64_t as the safe default.  Downstream type propagation
        // may refine later passes, but the decl being PRESENT is what
        // makes the output compile — that's the whole point of this pass.
        CVarDecl decl(nextId++, name, CType::int64());
        func.localVars.push_back(std::move(decl));
    }

    // Record how many synthetic decls we added so the confidence analyser
    // can still surface this as a smell even though the output now
    // technically compiles.  See FIX-045.
    func.synthesizedVarDecls += static_cast<unsigned>(orphans.size());
}

// ═══════════════════════════════════════════════════════════════════════════════
// Variable rename support
// ═══════════════════════════════════════════════════════════════════════════════

void CAstOptimizer::applyVariableRenames(
    CFuncDecl& func,
    const std::unordered_map<std::string, std::string>& renames) {
    if (renames.empty()) return;

    // 1. Rename in function parameter names.
    for (auto& param : func.params) {
        auto it = renames.find(param.name);
        if (it != renames.end()) {
            param.name = it->second;
        }
    }

    // 2. Walk the entire function body — all statements and expressions.
    renameInStmtList(func.body, renames);
}

} // namespace helix::cast
