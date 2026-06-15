#pragma once

// ── FIX-092: emit-time (final-AST) damning-defect detection ──────────────────
//
// The D4 charter exit-metric caps a function's self-reported confidence at 50%
// when the FINAL emitted body carries a "damning" honesty defect -- a pattern
// that makes the output provably non-faithful regardless of how clean the rest
// of the syntax looks.  Historically D4 was BUILD-TIME-LATCHED (a sticky bool
// raised the instant a code-typed constant or out-of-table call was built),
// which over-fired: a benign PC-base / NEXT_PC / RIP constant that merely
// COINCIDED with a packed function-start table entry latched the flag, then a
// later DSE/dead-store pass ERASED the constant before emission -- leaving a
// clean body wrongly capped at 50% with a NON-LOCATED reason naming a defect
// that is not present (rag/16 G3: "reason mis-attributed on leaf fns").
//
// This header re-derives the damning categories from the FINAL CFuncDecl AST so
// the cap fires IF AND ONLY IF a genuine, LOCATED defect survives emission:
//
//   (1) surviving code-address LEAK -- a CAddrLitExpr tagged isCodeAddrLeak
//       (the D1 `(void*)0xADDR` cast) that DSE did NOT erase.  An erased PC
//       constant leaks nothing and does not trip the cap.
//   (2) uninitialized return        -- `return <local>;` where the local has no
//       initializer and is never an assignment target anywhere in the body.
//   (3) irreducible no-return       -- the body has ZERO return statements and
//       escapes via `goto loc_irr_*` (the structurer could not recover any
//       control-flow exit; the live epilogue was lost).
//
// The OUT-OF-TABLE CALL category (D2) remains build-time-latched on the decl
// (CFuncDecl::hasDamningHonestyDefect) -- a side-effecting call erased by DSE is
// itself a defect, so it must cap even when no call node survives.  This header
// is purely additive to that flag; reanalyzeConfidence / analyzeConfidence OR
// the two together.
//
// Pure, stateless, header-inline (ODR-safe) so both CAstBuilder.cpp (build-time
// scorer) and CAstOptimizer.cpp (post-optimization rescorer, the value the user
// actually sees) can call it without a new translation unit.

#include "helix/cast/CDecl.h"
#include "helix/cast/CExpr.h"
#include "helix/cast/CStmt.h"

#include "llvm/Support/Casting.h"

#include <cstdint>
#include <cstdio>
#include <string>
#include <unordered_set>
#include <vector>

namespace helix::cast {

/// Located result of the final-AST damning scan.  `any()` is the cap trigger;
/// `reason` is a single-line ASCII string naming the surviving category (and an
/// address where cheap) for the Issues list.
struct DamningDefectInfo {
    bool codeAddrLeak = false;       // (1) surviving (void*)0xADDR code leak
    uint64_t leakAddr = 0;           //     first such address (for the reason)
    bool uninitReturn = false;       // (2) return of a never-assigned local
    std::string uninitVarName;       //     that local's name (for the reason)
    bool irreducibleNoReturn = false; // (3) goto loc_irr_* with no return path

    bool any() const {
        return codeAddrLeak || uninitReturn || irreducibleNoReturn;
    }

    /// One-line, ASCII, located reason naming the ACTUAL surviving defect(s).
    std::string reason() const {
        std::string r;
        auto add = [&](const std::string& s) {
            if (!r.empty()) r += "; ";
            r += s;
        };
        if (codeAddrLeak) {
            char buf[64];
            std::snprintf(buf, sizeof(buf),
                          "surviving code-address leak (void*)0x%llx",
                          (unsigned long long)leakAddr);
            add(buf);
        }
        if (uninitReturn)
            add("uninitialized return value '" + uninitVarName + "'");
        if (irreducibleNoReturn)
            add("irreducible CFG; no return path recovered");
        return r;
    }
};

namespace detail {

// ── helpers (all read-only over the final AST) ──────────────────────────────

/// True iff `e` is a surviving D1 code-address-leak node, recording its addr.
inline bool exprHasCodeAddrLeak(const CExpr* e, uint64_t& outAddr) {
    if (!e) return false;
    if (auto* a = llvm::dyn_cast<CAddrLitExpr>(e)) {
        if (a->isCodeAddrLeak) { outAddr = a->addrValue; return true; }
        return false;
    }
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return exprHasCodeAddrLeak(c->operand.get(), outAddr);
    if (auto* u = llvm::dyn_cast<CUnaryExpr>(e))
        return exprHasCodeAddrLeak(u->operand.get(), outAddr);
    if (auto* b = llvm::dyn_cast<CBinaryExpr>(e))
        return exprHasCodeAddrLeak(b->lhs.get(), outAddr) ||
               exprHasCodeAddrLeak(b->rhs.get(), outAddr);
    if (auto* t = llvm::dyn_cast<CTernaryExpr>(e))
        return exprHasCodeAddrLeak(t->cond.get(), outAddr) ||
               exprHasCodeAddrLeak(t->trueVal.get(), outAddr) ||
               exprHasCodeAddrLeak(t->falseVal.get(), outAddr);
    if (auto* s = llvm::dyn_cast<CSubscriptExpr>(e))
        return exprHasCodeAddrLeak(s->base.get(), outAddr) ||
               exprHasCodeAddrLeak(s->index.get(), outAddr);
    if (auto* fa = llvm::dyn_cast<CFieldAccessExpr>(e))
        return exprHasCodeAddrLeak(fa->base.get(), outAddr);
    if (auto* call = llvm::dyn_cast<CCallExpr>(e)) {
        for (auto& arg : call->args)
            if (exprHasCodeAddrLeak(arg.get(), outAddr)) return true;
        return false;
    }
    return false;
}

/// Plain var-name of `e` if it is a (possibly cast-wrapped) CVarRefExpr.
inline std::string plainVarName(const CExpr* e) {
    if (!e) return {};
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return plainVarName(c->operand.get());
    if (auto* v = llvm::dyn_cast<CVarRefExpr>(e))
        return v->varName;
    return {};
}

// Forward decl for mutual recursion through control-flow stmts.
inline void scanStmtList(const std::vector<StmtPtr>& body,
                         std::unordered_set<std::string>& assignedVars,
                         std::unordered_set<std::string>& returnedVars,
                         bool& sawReturn, bool& sawIrrGoto,
                         uint64_t& leakAddr, bool& sawLeak);

/// Walk one statement: record assignment targets, returned vars, surviving
/// code-leaks (anywhere in any expression), return presence, and loc_irr gotos.
inline void scanStmt(const CStmt* s,
                     std::unordered_set<std::string>& assignedVars,
                     std::unordered_set<std::string>& returnedVars,
                     bool& sawReturn, bool& sawIrrGoto,
                     uint64_t& leakAddr, bool& sawLeak) {
    if (!s) return;

    auto checkLeak = [&](const CExpr* e) {
        uint64_t a = 0;
        if (!sawLeak && exprHasCodeAddrLeak(e, a)) { sawLeak = true; leakAddr = a; }
        else { uint64_t tmp = 0; (void)exprHasCodeAddrLeak(e, tmp); }
    };

    if (auto* as = llvm::dyn_cast<CAssignStmt>(s)) {
        // Whole-variable assignment target (plain or compound op) counts the
        // var as "assigned"; a write THROUGH a var (`*p = ...`, `p->f = ...`)
        // does NOT initialize `p` itself, so plainVarName returns "" there.
        if (auto vn = plainVarName(as->target.get()); !vn.empty())
            assignedVars.insert(vn);
        checkLeak(as->target.get());
        checkLeak(as->value.get());
        return;
    }
    if (auto* es = llvm::dyn_cast<CExprStmt>(s)) {
        checkLeak(es->expr.get());
        return;
    }
    if (auto* rs = llvm::dyn_cast<CReturnStmt>(s)) {
        sawReturn = true;
        if (rs->value) {
            checkLeak(rs->value.get());
            if (auto vn = plainVarName(rs->value.get()); !vn.empty())
                returnedVars.insert(vn);
        }
        return;
    }
    if (auto* g = llvm::dyn_cast<CGotoStmt>(s)) {
        if (g->label.rfind("loc_irr", 0) == 0) sawIrrGoto = true;
        return;
    }
    if (auto* ifS = llvm::dyn_cast<CIfStmt>(s)) {
        checkLeak(ifS->condition.get());
        scanStmtList(ifS->thenBody, assignedVars, returnedVars,
                     sawReturn, sawIrrGoto, leakAddr, sawLeak);
        scanStmtList(ifS->elseBody, assignedVars, returnedVars,
                     sawReturn, sawIrrGoto, leakAddr, sawLeak);
        return;
    }
    if (auto* wh = llvm::dyn_cast<CWhileStmt>(s)) {
        checkLeak(wh->condition.get());
        scanStmtList(wh->body, assignedVars, returnedVars,
                     sawReturn, sawIrrGoto, leakAddr, sawLeak);
        return;
    }
    if (auto* dw = llvm::dyn_cast<CDoWhileStmt>(s)) {
        checkLeak(dw->condition.get());
        scanStmtList(dw->body, assignedVars, returnedVars,
                     sawReturn, sawIrrGoto, leakAddr, sawLeak);
        return;
    }
    if (auto* fr = llvm::dyn_cast<CForStmt>(s)) {
        scanStmtList(fr->body, assignedVars, returnedVars,
                     sawReturn, sawIrrGoto, leakAddr, sawLeak);
        return;
    }
    if (auto* sw = llvm::dyn_cast<CSwitchStmt>(s)) {
        checkLeak(sw->selector.get());
        for (auto& c : sw->cases)
            scanStmtList(c.body, assignedVars, returnedVars,
                         sawReturn, sawIrrGoto, leakAddr, sawLeak);
        return;
    }
    if (auto* blk = llvm::dyn_cast<CBlockStmt>(s)) {
        scanStmtList(blk->stmts, assignedVars, returnedVars,
                     sawReturn, sawIrrGoto, leakAddr, sawLeak);
        return;
    }
}

inline void scanStmtList(const std::vector<StmtPtr>& body,
                         std::unordered_set<std::string>& assignedVars,
                         std::unordered_set<std::string>& returnedVars,
                         bool& sawReturn, bool& sawIrrGoto,
                         uint64_t& leakAddr, bool& sawLeak) {
    for (auto& sp : body)
        scanStmt(sp.get(), assignedVars, returnedVars,
                 sawReturn, sawIrrGoto, leakAddr, sawLeak);
}

} // namespace detail

/// Scan the FINAL function AST for surviving damning defects (located).
inline DamningDefectInfo detectDamningDefects(const CFuncDecl& func) {
    DamningDefectInfo info;

    std::unordered_set<std::string> assignedVars;
    std::unordered_set<std::string> returnedVars;
    bool sawReturn = false, sawIrrGoto = false, sawLeak = false;
    uint64_t leakAddr = 0;

    // Local var initializers can themselves carry a surviving code-leak.
    for (const auto& lv : func.localVars) {
        if (lv.initExpr) {
            uint64_t a = 0;
            if (!sawLeak && detail::exprHasCodeAddrLeak(lv.initExpr.get(), a)) {
                sawLeak = true; leakAddr = a;
            }
        }
    }

    detail::scanStmtList(func.body, assignedVars, returnedVars,
                         sawReturn, sawIrrGoto, leakAddr, sawLeak);

    // (1) Surviving code-address leak.
    if (sawLeak) { info.codeAddrLeak = true; info.leakAddr = leakAddr; }

    // (2) Uninitialized return: a returned LOCAL with no initializer that is
    //     never an assignment target anywhere in the body.  Params are never
    //     "uninitialized" (they carry an incoming value), so only locals count.
    for (const auto& lv : func.localVars) {
        if (lv.initExpr) continue;                        // has an initializer
        if (!returnedVars.count(lv.varName)) continue;    // not returned
        if (assignedVars.count(lv.varName)) continue;     // assigned somewhere
        info.uninitReturn = true;
        info.uninitVarName = lv.varName;
        break;
    }

    // (3) Irreducible no-return escape: no return statement anywhere AND the
    //     body escapes via a loc_irr_* goto (structurer lost the live exit).
    if (!sawReturn && sawIrrGoto)
        info.irreducibleNoReturn = true;

    return info;
}

} // namespace helix::cast
