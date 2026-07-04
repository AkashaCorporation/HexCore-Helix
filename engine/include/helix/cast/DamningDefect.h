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
    bool droppedControlFlow = false; // (4) FIX-110: __helix_unhandled_cf_* survived
    std::string droppedOp;           //     the un-lowered op name (for the reason)
    bool floatSubscript = false;     // (5) FIX-111: scalar `float v[0]` / `[0.0f]`

    bool any() const {
        return codeAddrLeak || uninitReturn || irreducibleNoReturn ||
               droppedControlFlow || floatSubscript;
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
        if (droppedControlFlow)
            add("unrecovered control flow (" + droppedOp + ")");
        if (floatSubscript)
            add("non-compilable scalar-float subscript (v[0] on a float)");
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

// ── FIX-108: reachability awareness for the uninitialized-return check ───────
// A returned local is genuinely uninitialized if its ONLY assignments sit on
// provably-dead branches (e.g. `if (!!v1) { v2 = ...; }` where v1 is a const-0
// local).  We fold a condition against the set of locals that are provably the
// constant 0 (initialised to 0 and never reassigned), peeling casts and `!`.
inline bool isProvablyNonzero(const CExpr* e,
                              const std::unordered_set<std::string>& zeroLocals);

inline bool isProvablyZero(const CExpr* e,
                           const std::unordered_set<std::string>& zeroLocals) {
    if (!e) return false;
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return isProvablyZero(c->operand.get(), zeroLocals);
    if (auto* lit = llvm::dyn_cast<CIntLitExpr>(e))
        return lit->value == 0;
    if (auto* v = llvm::dyn_cast<CVarRefExpr>(e))
        return zeroLocals.count(v->varName) != 0;
    if (auto* u = llvm::dyn_cast<CUnaryExpr>(e))
        if (u->op == UnaryOp::LogNot)            // !x is zero iff x is nonzero
            return isProvablyNonzero(u->operand.get(), zeroLocals);
    return false;
}

inline bool isProvablyNonzero(const CExpr* e,
                              const std::unordered_set<std::string>& zeroLocals) {
    if (!e) return false;
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return isProvablyNonzero(c->operand.get(), zeroLocals);
    if (auto* lit = llvm::dyn_cast<CIntLitExpr>(e))
        return lit->value != 0;
    if (auto* u = llvm::dyn_cast<CUnaryExpr>(e))
        if (u->op == UnaryOp::LogNot)            // !x is nonzero iff x is zero
            return isProvablyZero(u->operand.get(), zeroLocals);
    return false;
}

/// Collect whole-variable assignment targets that sit on a REACHABLE path.
/// The then-body of an `if` whose condition is provably FALSE is dead; the
/// else-body of a provably-TRUE condition is dead; once dead, stays dead.
inline void collectLiveAssigned(
        const std::vector<StmtPtr>& body, bool inDead,
        const std::unordered_set<std::string>& zeroLocals,
        std::unordered_set<std::string>& liveAssigned) {
    for (auto& sp : body) {
        const CStmt* s = sp.get();
        if (!s) continue;
        if (auto* as = llvm::dyn_cast<CAssignStmt>(s)) {
            if (!inDead)
                if (auto vn = plainVarName(as->target.get()); !vn.empty())
                    liveAssigned.insert(vn);
        } else if (auto* ifS = llvm::dyn_cast<CIfStmt>(s)) {
            bool thenDead = inDead || isProvablyZero(ifS->condition.get(), zeroLocals);
            bool elseDead = inDead || isProvablyNonzero(ifS->condition.get(), zeroLocals);
            collectLiveAssigned(ifS->thenBody, thenDead, zeroLocals, liveAssigned);
            collectLiveAssigned(ifS->elseBody, elseDead, zeroLocals, liveAssigned);
        } else if (auto* wh = llvm::dyn_cast<CWhileStmt>(s)) {
            collectLiveAssigned(wh->body, inDead, zeroLocals, liveAssigned);
        } else if (auto* dw = llvm::dyn_cast<CDoWhileStmt>(s)) {
            collectLiveAssigned(dw->body, inDead, zeroLocals, liveAssigned);
        } else if (auto* fr = llvm::dyn_cast<CForStmt>(s)) {
            collectLiveAssigned(fr->body, inDead, zeroLocals, liveAssigned);
        } else if (auto* sw = llvm::dyn_cast<CSwitchStmt>(s)) {
            for (auto& c : sw->cases)
                collectLiveAssigned(c.body, inDead, zeroLocals, liveAssigned);
        } else if (auto* blk = llvm::dyn_cast<CBlockStmt>(s)) {
            collectLiveAssigned(blk->stmts, inDead, zeroLocals, liveAssigned);
        }
    }
}

// ── FIX-110: surviving un-lowered control-flow op (__helix_unhandled_cf_*) ───
// The structurer renders a switch / conditional branch it could not recover as
// a `__helix_unhandled_cf_switch(...)` / `__helix_unhandled_cf_cond_br(...)`
// call.  Such a call means real control flow is MISSING from the body, so a
// function carrying it is non-faithful and must not read High.
inline bool exprHasUnhandledCall(const CExpr* e, std::string& outOp) {
    if (!e) return false;
    if (auto* call = llvm::dyn_cast<CCallExpr>(e)) {
        if (call->targetName.rfind("__helix_unhandled_", 0) == 0) {
            outOp = call->targetName;
            return true;
        }
        for (auto& a : call->args)
            if (exprHasUnhandledCall(a.get(), outOp)) return true;
        return false;
    }
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return exprHasUnhandledCall(c->operand.get(), outOp);
    if (auto* u = llvm::dyn_cast<CUnaryExpr>(e))
        return exprHasUnhandledCall(u->operand.get(), outOp);
    if (auto* b = llvm::dyn_cast<CBinaryExpr>(e))
        return exprHasUnhandledCall(b->lhs.get(), outOp) ||
               exprHasUnhandledCall(b->rhs.get(), outOp);
    return false;
}

inline bool scanForUnhandledCF(const std::vector<StmtPtr>& body,
                               std::string& outOp) {
    for (auto& sp : body) {
        const CStmt* s = sp.get();
        if (!s) continue;
        if (auto* es = llvm::dyn_cast<CExprStmt>(s)) {
            if (exprHasUnhandledCall(es->expr.get(), outOp)) return true;
        } else if (auto* as = llvm::dyn_cast<CAssignStmt>(s)) {
            if (exprHasUnhandledCall(as->value.get(), outOp)) return true;
            if (exprHasUnhandledCall(as->target.get(), outOp)) return true;
        } else if (auto* rs = llvm::dyn_cast<CReturnStmt>(s)) {
            if (rs->value && exprHasUnhandledCall(rs->value.get(), outOp))
                return true;
        } else if (auto* ifS = llvm::dyn_cast<CIfStmt>(s)) {
            if (exprHasUnhandledCall(ifS->condition.get(), outOp)) return true;
            if (scanForUnhandledCF(ifS->thenBody, outOp)) return true;
            if (scanForUnhandledCF(ifS->elseBody, outOp)) return true;
        } else if (auto* wh = llvm::dyn_cast<CWhileStmt>(s)) {
            if (scanForUnhandledCF(wh->body, outOp)) return true;
        } else if (auto* dw = llvm::dyn_cast<CDoWhileStmt>(s)) {
            if (scanForUnhandledCF(dw->body, outOp)) return true;
        } else if (auto* fr = llvm::dyn_cast<CForStmt>(s)) {
            if (scanForUnhandledCF(fr->body, outOp)) return true;
        } else if (auto* sw = llvm::dyn_cast<CSwitchStmt>(s)) {
            for (auto& c : sw->cases)
                if (scanForUnhandledCF(c.body, outOp)) return true;
        } else if (auto* blk = llvm::dyn_cast<CBlockStmt>(s)) {
            if (scanForUnhandledCF(blk->stmts, outOp)) return true;
        }
    }
    return false;
}

// ── FIX-111: non-compilable scalar-float subscript ──────────────────────────
// The SSE scalar-compare lowering models an xmm lane-0 extract as a subscript
// `v[0]`, but emits it on a value declared as a SCALAR `float` (or with a
// float-literal index `[0.0f]`).  You cannot subscript a scalar float in C, so
// the body does not compile -- a faithfulness defect that must not read High.
// (A genuine pointer/array base has kind Pointer/Array, never Float, so this is
// precise: it fires only on the broken scalar-subscript, not on `ptr[i]`.)
inline bool isScalarFloatBase(const CExpr* e,
                              const std::unordered_set<std::string>& floatVars) {
    if (!e) return false;
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return isScalarFloatBase(c->operand.get(), floatVars);
    if (auto* v = llvm::dyn_cast<CVarRefExpr>(e))
        if (floatVars.count(v->varName)) return true;   // declared `float` (decl is authoritative; the use-site var-ref type can drift)
    return e->type && e->type->kind == TypeKind::Float;  // or the ref is itself typed float
}

inline bool exprHasFloatSubscript(
        const CExpr* e, const std::unordered_set<std::string>& floatVars) {
    if (!e) return false;
    if (auto* s = llvm::dyn_cast<CSubscriptExpr>(e)) {
        if (isScalarFloatBase(s->base.get(), floatVars)) return true;   // float v[0]
        if (s->index && llvm::isa<CFloatLitExpr>(s->index.get()))       // v[0.0f]
            return true;
        return exprHasFloatSubscript(s->base.get(), floatVars) ||
               exprHasFloatSubscript(s->index.get(), floatVars);
    }
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return exprHasFloatSubscript(c->operand.get(), floatVars);
    if (auto* u = llvm::dyn_cast<CUnaryExpr>(e))
        return exprHasFloatSubscript(u->operand.get(), floatVars);
    if (auto* b = llvm::dyn_cast<CBinaryExpr>(e))
        return exprHasFloatSubscript(b->lhs.get(), floatVars) ||
               exprHasFloatSubscript(b->rhs.get(), floatVars);
    if (auto* t = llvm::dyn_cast<CTernaryExpr>(e))
        return exprHasFloatSubscript(t->cond.get(), floatVars) ||
               exprHasFloatSubscript(t->trueVal.get(), floatVars) ||
               exprHasFloatSubscript(t->falseVal.get(), floatVars);
    if (auto* fa = llvm::dyn_cast<CFieldAccessExpr>(e))
        return exprHasFloatSubscript(fa->base.get(), floatVars);
    if (auto* call = llvm::dyn_cast<CCallExpr>(e)) {
        for (auto& a : call->args)
            if (exprHasFloatSubscript(a.get(), floatVars)) return true;
        return false;
    }
    return false;
}

inline bool scanForFloatSubscript(
        const std::vector<StmtPtr>& body,
        const std::unordered_set<std::string>& floatVars) {
    for (auto& sp : body) {
        const CStmt* s = sp.get();
        if (!s) continue;
        if (auto* es = llvm::dyn_cast<CExprStmt>(s)) {
            if (exprHasFloatSubscript(es->expr.get(), floatVars)) return true;
        } else if (auto* as = llvm::dyn_cast<CAssignStmt>(s)) {
            if (exprHasFloatSubscript(as->value.get(), floatVars)) return true;
            if (exprHasFloatSubscript(as->target.get(), floatVars)) return true;
        } else if (auto* rs = llvm::dyn_cast<CReturnStmt>(s)) {
            if (rs->value && exprHasFloatSubscript(rs->value.get(), floatVars)) return true;
        } else if (auto* ifS = llvm::dyn_cast<CIfStmt>(s)) {
            if (exprHasFloatSubscript(ifS->condition.get(), floatVars)) return true;
            if (scanForFloatSubscript(ifS->thenBody, floatVars)) return true;
            if (scanForFloatSubscript(ifS->elseBody, floatVars)) return true;
        } else if (auto* wh = llvm::dyn_cast<CWhileStmt>(s)) {
            if (exprHasFloatSubscript(wh->condition.get(), floatVars)) return true;
            if (scanForFloatSubscript(wh->body, floatVars)) return true;
        } else if (auto* dw = llvm::dyn_cast<CDoWhileStmt>(s)) {
            if (exprHasFloatSubscript(dw->condition.get(), floatVars)) return true;
            if (scanForFloatSubscript(dw->body, floatVars)) return true;
        } else if (auto* fr = llvm::dyn_cast<CForStmt>(s)) {
            if (scanForFloatSubscript(fr->body, floatVars)) return true;
        } else if (auto* sw = llvm::dyn_cast<CSwitchStmt>(s)) {
            if (exprHasFloatSubscript(sw->selector.get(), floatVars)) return true;
            for (auto& c : sw->cases)
                if (scanForFloatSubscript(c.body, floatVars)) return true;
        } else if (auto* blk = llvm::dyn_cast<CBlockStmt>(s)) {
            if (scanForFloatSubscript(blk->stmts, floatVars)) return true;
        }
    }
    return false;
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

    // (2) Uninitialized return: a returned LOCAL with no initializer whose only
    //     assignments sit on provably-dead branches.  Params are never
    //     "uninitialized" (they carry an incoming value), so only locals count.
    //
    //     FIX-108: the plain `assignedVars` set counts an assignment even when
    //     it is inside a provably-dead branch (`if (!!v1) { v2 = ...; }` with v1
    //     a const-0 local), which let `return v2;` read High at 87% on SOTTR
    //     sub_140001000.  Re-derive the set of assignments that sit on a
    //     REACHABLE path (folding `if` conditions against the const-0 locals)
    //     and test against THAT.  `zeroLocals` = locals initialised to 0 and
    //     never reassigned anywhere (a conservative const-0 set: a var that IS
    //     reassigned is excluded, so a branch is only ever marked dead when its
    //     guard is genuinely always-false -- no false-positive uninit).
    std::unordered_set<std::string> zeroLocals;
    for (const auto& lv : func.localVars)
        if (lv.initExpr && !assignedVars.count(lv.varName) &&
            detail::isProvablyZero(lv.initExpr.get(), {}))
            zeroLocals.insert(lv.varName);
    std::unordered_set<std::string> liveAssignedVars;
    detail::collectLiveAssigned(func.body, /*inDead=*/false, zeroLocals,
                                liveAssignedVars);

    for (const auto& lv : func.localVars) {
        if (lv.initExpr) continue;                        // has an initializer
        if (!returnedVars.count(lv.varName)) continue;    // not returned
        if (liveAssignedVars.count(lv.varName)) continue; // assigned on a live path
        info.uninitReturn = true;
        info.uninitVarName = lv.varName;
        break;
    }

    // (3) Irreducible no-return escape: no return statement anywhere AND the
    //     body escapes via a loc_irr_* goto (structurer lost the live exit).
    if (!sawReturn && sawIrrGoto)
        info.irreducibleNoReturn = true;

    // (4) FIX-110: a surviving __helix_unhandled_cf_* call -- the structurer
    //     could not recover a switch / conditional branch, so real control flow
    //     is missing.  A function that reads 100% with its whole dispatch
    //     dropped to `__helix_unhandled_cf_switch(...)` is provably non-faithful.
    {
        std::string droppedOp;
        if (detail::scanForUnhandledCF(func.body, droppedOp)) {
            info.droppedControlFlow = true;
            info.droppedOp = droppedOp;
        }
    }

    // (5) FIX-111: a non-compilable scalar-float subscript (`float v; ... v[0]`
    //     or a `[0.0f]` index) -- the SSE scalar-compare lowering emitted an xmm
    //     lane extract on a scalar.  The body does not compile, so it must not
    //     read High.  The DECLARED type is authoritative (the use-site var-ref
    //     type can drift away from `float`), so feed the declared-float names.
    {
        std::unordered_set<std::string> floatVars;
        for (const auto& lv : func.localVars)
            if (lv.type && lv.type->kind == TypeKind::Float)
                floatVars.insert(lv.varName);
        for (const auto& p : func.params)
            if (p.type && p.type->kind == TypeKind::Float)
                floatVars.insert(p.name);
        if (detail::scanForFloatSubscript(func.body, floatVars))
            info.floatSubscript = true;
    }

    return info;
}

} // namespace helix::cast
