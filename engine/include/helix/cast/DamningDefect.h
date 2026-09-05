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
//       initializer and is not definitely assigned on that structured path.
//   (3) irreducible no-return       -- the body has ZERO return statements and
//       escapes via `goto loc_irr_*` (the structurer could not recover any
//       control-flow exit; the live epilogue was lost).
//   (4) dropped control flow        -- surviving `__helix_unhandled_*` (FIX-110)
//   (5) scalar float subscript      -- non-compilable `float v[0]` (FIX-111)
//   (6) post-return junk (issue #31) -- statements still present after a same-
//       scope `return` once optimizers have run.  Soft penalty alone could leave
//       Medium/High confidence on non-faithful sequential C; hard-cap at 50%.
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
    bool postReturnUnreachable = false; // (6) #31: stmts after same-scope return
    int postReturnCount = 0;            //     how many (for the reason string)
    bool emptyStubBody = false;         // (7) #56: no body or only bare return
    bool explicitUnknown = false;       // (8) localized semantic gap survived

    bool any() const {
        return codeAddrLeak || uninitReturn || irreducibleNoReturn ||
               droppedControlFlow || floatSubscript || postReturnUnreachable ||
               emptyStubBody || explicitUnknown;
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
        if (postReturnUnreachable) {
            char buf[80];
            std::snprintf(buf, sizeof(buf),
                          "%d unreachable statement(s) after return",
                          postReturnCount > 0 ? postReturnCount : 1);
            add(buf);
        }
        if (emptyStubBody)
            add("stub/empty body; no recovered behavior");
        if (explicitUnknown)
            add("explicit unknown machine semantics survived");
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

// ── FIX-123: path-sensitive uninitialized-return honesty ────────────────────
//
// The original category (2) only asked whether a returned local had ANY live
// assignment anywhere.  That misses `if (x) result = ...; return result;`:
// result is uninitialized when x is false, yet the output could report High.
//
// Keep this deliberately narrow.  We only perform definite-assignment flow on
// straight-line code, if/else, lexical blocks, and loop bodies. Loop-body
// assignments are deliberately not propagated to the exit. Switches, gotos,
// labels, break/continue, and inline asm retain the older conservative check.
// A local whose address is taken is also excluded because a call may initialize
// it indirectly.  This makes the new detector additive without pretending to
// solve arbitrary C alias/control-flow analysis.

inline void collectAddressTakenInExpr(
        const CExpr* e, std::unordered_set<std::string>& out) {
    if (!e) return;
    if (auto* u = llvm::dyn_cast<CUnaryExpr>(e)) {
        if (u->op == UnaryOp::AddressOf) {
            if (auto name = plainVarName(u->operand.get()); !name.empty())
                out.insert(name);
        }
        collectAddressTakenInExpr(u->operand.get(), out);
        return;
    }
    if (auto* c = llvm::dyn_cast<CCastExpr>(e)) {
        collectAddressTakenInExpr(c->operand.get(), out);
        return;
    }
    if (auto* b = llvm::dyn_cast<CBinaryExpr>(e)) {
        collectAddressTakenInExpr(b->lhs.get(), out);
        collectAddressTakenInExpr(b->rhs.get(), out);
        return;
    }
    if (auto* t = llvm::dyn_cast<CTernaryExpr>(e)) {
        collectAddressTakenInExpr(t->cond.get(), out);
        collectAddressTakenInExpr(t->trueVal.get(), out);
        collectAddressTakenInExpr(t->falseVal.get(), out);
        return;
    }
    if (auto* s = llvm::dyn_cast<CSubscriptExpr>(e)) {
        collectAddressTakenInExpr(s->base.get(), out);
        collectAddressTakenInExpr(s->index.get(), out);
        return;
    }
    if (auto* f = llvm::dyn_cast<CFieldAccessExpr>(e)) {
        collectAddressTakenInExpr(f->base.get(), out);
        return;
    }
    if (auto* call = llvm::dyn_cast<CCallExpr>(e)) {
        for (auto& arg : call->args)
            collectAddressTakenInExpr(arg.get(), out);
    }
}

inline bool supportsDefiniteAssignmentScan(const std::vector<StmtPtr>& body) {
    for (auto& sp : body) {
        const CStmt* s = sp.get();
        if (!s) continue;
        if (llvm::isa<CAssignStmt, CExprStmt, CReturnStmt, CCommentStmt>(s))
            continue;
        if (auto* ifS = llvm::dyn_cast<CIfStmt>(s)) {
            if (!supportsDefiniteAssignmentScan(ifS->thenBody) ||
                !supportsDefiniteAssignmentScan(ifS->elseBody))
                return false;
            continue;
        }
        if (auto* block = llvm::dyn_cast<CBlockStmt>(s)) {
            if (!supportsDefiniteAssignmentScan(block->stmts))
                return false;
            continue;
        }
        if (auto* loop = llvm::dyn_cast<CWhileStmt>(s)) {
            if (!supportsDefiniteAssignmentScan(loop->body))
                return false;
            continue;
        }
        if (auto* loop = llvm::dyn_cast<CDoWhileStmt>(s)) {
            if (!supportsDefiniteAssignmentScan(loop->body))
                return false;
            continue;
        }
        if (auto* loop = llvm::dyn_cast<CForStmt>(s)) {
            if (!supportsDefiniteAssignmentScan(loop->body))
                return false;
            continue;
        }
        return false;
    }
    return true;
}

inline void collectAddressTakenInStmts(
        const std::vector<StmtPtr>& body,
        std::unordered_set<std::string>& out) {
    for (auto& sp : body) {
        const CStmt* s = sp.get();
        if (!s) continue;
        if (auto* a = llvm::dyn_cast<CAssignStmt>(s)) {
            collectAddressTakenInExpr(a->target.get(), out);
            collectAddressTakenInExpr(a->value.get(), out);
        } else if (auto* e = llvm::dyn_cast<CExprStmt>(s)) {
            collectAddressTakenInExpr(e->expr.get(), out);
        } else if (auto* r = llvm::dyn_cast<CReturnStmt>(s)) {
            collectAddressTakenInExpr(r->value.get(), out);
        } else if (auto* ifS = llvm::dyn_cast<CIfStmt>(s)) {
            collectAddressTakenInExpr(ifS->condition.get(), out);
            collectAddressTakenInStmts(ifS->thenBody, out);
            collectAddressTakenInStmts(ifS->elseBody, out);
        } else if (auto* block = llvm::dyn_cast<CBlockStmt>(s)) {
            collectAddressTakenInStmts(block->stmts, out);
        } else if (auto* whileLoop = llvm::dyn_cast<CWhileStmt>(s)) {
            collectAddressTakenInExpr(whileLoop->condition.get(), out);
            collectAddressTakenInStmts(whileLoop->body, out);
        } else if (auto* doLoop = llvm::dyn_cast<CDoWhileStmt>(s)) {
            collectAddressTakenInExpr(doLoop->condition.get(), out);
            collectAddressTakenInStmts(doLoop->body, out);
        } else if (auto* forLoop = llvm::dyn_cast<CForStmt>(s)) {
            collectAddressTakenInExpr(forLoop->condition.get(), out);
            if (auto* init = llvm::dyn_cast_or_null<CAssignStmt>(
                    forLoop->init.get())) {
                collectAddressTakenInExpr(init->target.get(), out);
                collectAddressTakenInExpr(init->value.get(), out);
            }
            if (auto* step = llvm::dyn_cast_or_null<CAssignStmt>(
                    forLoop->step.get())) {
                collectAddressTakenInExpr(step->target.get(), out);
                collectAddressTakenInExpr(step->value.get(), out);
            }
            collectAddressTakenInStmts(forLoop->body, out);
        }
    }
}

struct DefiniteAssignmentFlow {
    std::unordered_set<std::string> assigned;
    bool fallsThrough = true;
    bool uninitReturn = false;
    std::string uninitVar;
};

inline std::unordered_set<std::string> intersectAssigned(
        const std::unordered_set<std::string>& a,
        const std::unordered_set<std::string>& b) {
    std::unordered_set<std::string> result;
    const auto& smaller = a.size() <= b.size() ? a : b;
    const auto& larger = a.size() <= b.size() ? b : a;
    for (const auto& name : smaller)
        if (larger.count(name))
            result.insert(name);
    return result;
}

inline DefiniteAssignmentFlow analyzeDefiniteAssignments(
        const std::vector<StmtPtr>& body,
        std::unordered_set<std::string> incoming,
        const std::unordered_set<std::string>& candidates,
        const std::unordered_set<std::string>& addressTaken,
        const std::unordered_set<std::string>& zeroLocals) {
    DefiniteAssignmentFlow flow{std::move(incoming)};

    for (auto& sp : body) {
        const CStmt* s = sp.get();
        if (!s || !flow.fallsThrough) continue;

        if (auto* assign = llvm::dyn_cast<CAssignStmt>(s)) {
            // Compound assignment and ++/-- read the old value first, so they
            // cannot establish initialization of a previously undefined local.
            if (assign->compoundOp.empty()) {
                if (auto name = plainVarName(assign->target.get()); !name.empty())
                    flow.assigned.insert(name);
            }
            continue;
        }

        if (auto* ret = llvm::dyn_cast<CReturnStmt>(s)) {
            auto name = plainVarName(ret->value.get());
            if (!name.empty() && candidates.count(name) &&
                !addressTaken.count(name) && !flow.assigned.count(name)) {
                flow.uninitReturn = true;
                flow.uninitVar = name;
            }
            flow.fallsThrough = false;
            continue;
        }

        if (auto* block = llvm::dyn_cast<CBlockStmt>(s)) {
            auto nested = analyzeDefiniteAssignments(
                block->stmts, flow.assigned, candidates, addressTaken,
                zeroLocals);
            if (nested.uninitReturn && !flow.uninitReturn) {
                flow.uninitReturn = true;
                flow.uninitVar = nested.uninitVar;
            }
            flow.assigned = std::move(nested.assigned);
            flow.fallsThrough = nested.fallsThrough;
            continue;
        }

        auto analyzeLoopBody = [&](const std::vector<StmtPtr>& loopBody) {
            auto nested = analyzeDefiniteAssignments(
                loopBody, flow.assigned, candidates, addressTaken, zeroLocals);
            if (nested.uninitReturn && !flow.uninitReturn) {
                flow.uninitReturn = true;
                flow.uninitVar = nested.uninitVar;
            }
            // Do not propagate assignments out of a loop. While/for may execute
            // zero times, and even a do-while may exit through control flow the
            // narrow analysis intentionally does not model.
        };
        if (auto* loop = llvm::dyn_cast<CWhileStmt>(s)) {
            analyzeLoopBody(loop->body);
            continue;
        }
        if (auto* loop = llvm::dyn_cast<CDoWhileStmt>(s)) {
            analyzeLoopBody(loop->body);
            continue;
        }
        if (auto* loop = llvm::dyn_cast<CForStmt>(s)) {
            analyzeLoopBody(loop->body);
            continue;
        }

        if (auto* ifS = llvm::dyn_cast<CIfStmt>(s)) {
            bool onlyElse = isProvablyZero(ifS->condition.get(), zeroLocals);
            bool onlyThen =
                isProvablyNonzero(ifS->condition.get(), zeroLocals);

            DefiniteAssignmentFlow thenFlow{flow.assigned};
            DefiniteAssignmentFlow elseFlow{flow.assigned};
            if (!onlyElse) {
                thenFlow = analyzeDefiniteAssignments(
                    ifS->thenBody, flow.assigned, candidates, addressTaken,
                    zeroLocals);
            }
            if (!onlyThen && !ifS->elseBody.empty()) {
                elseFlow = analyzeDefiniteAssignments(
                    ifS->elseBody, flow.assigned, candidates, addressTaken,
                    zeroLocals);
            }

            auto preserveFirstFailure = [&](const DefiniteAssignmentFlow& f) {
                if (f.uninitReturn && !flow.uninitReturn) {
                    flow.uninitReturn = true;
                    flow.uninitVar = f.uninitVar;
                }
            };
            if (!onlyElse) preserveFirstFailure(thenFlow);
            if (!onlyThen) preserveFirstFailure(elseFlow);

            if (onlyThen) {
                flow.assigned = std::move(thenFlow.assigned);
                flow.fallsThrough = thenFlow.fallsThrough;
            } else if (onlyElse) {
                flow.assigned = std::move(elseFlow.assigned);
                flow.fallsThrough = elseFlow.fallsThrough;
            } else if (thenFlow.fallsThrough && elseFlow.fallsThrough) {
                flow.assigned = intersectAssigned(
                    thenFlow.assigned, elseFlow.assigned);
            } else if (thenFlow.fallsThrough) {
                flow.assigned = std::move(thenFlow.assigned);
            } else if (elseFlow.fallsThrough) {
                flow.assigned = std::move(elseFlow.assigned);
            } else {
                flow.fallsThrough = false;
            }
        }
    }
    return flow;
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

inline bool exprHasExplicitUnknown(const CExpr* e) {
    if (!e) return false;
    if (auto* call = llvm::dyn_cast<CCallExpr>(e)) {
        if (call->targetName == "__helix_unknown") return true;
        for (auto& a : call->args)
            if (exprHasExplicitUnknown(a.get())) return true;
        return false;
    }
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return exprHasExplicitUnknown(c->operand.get());
    if (auto* u = llvm::dyn_cast<CUnaryExpr>(e))
        return exprHasExplicitUnknown(u->operand.get());
    if (auto* b = llvm::dyn_cast<CBinaryExpr>(e))
        return exprHasExplicitUnknown(b->lhs.get()) ||
               exprHasExplicitUnknown(b->rhs.get());
    if (auto* t = llvm::dyn_cast<CTernaryExpr>(e))
        return exprHasExplicitUnknown(t->cond.get()) ||
               exprHasExplicitUnknown(t->trueVal.get()) ||
               exprHasExplicitUnknown(t->falseVal.get());
    if (auto* s = llvm::dyn_cast<CSubscriptExpr>(e))
        return exprHasExplicitUnknown(s->base.get()) ||
               exprHasExplicitUnknown(s->index.get());
    if (auto* f = llvm::dyn_cast<CFieldAccessExpr>(e))
        return exprHasExplicitUnknown(f->base.get());
    return false;
}

inline bool scanForExplicitUnknown(const std::vector<StmtPtr>& body) {
    for (auto& sp : body) {
        const CStmt* s = sp.get();
        if (!s) continue;
        if (auto* e = llvm::dyn_cast<CExprStmt>(s)) {
            if (exprHasExplicitUnknown(e->expr.get())) return true;
        } else if (auto* a = llvm::dyn_cast<CAssignStmt>(s)) {
            if (exprHasExplicitUnknown(a->target.get()) ||
                exprHasExplicitUnknown(a->value.get())) return true;
        } else if (auto* r = llvm::dyn_cast<CReturnStmt>(s)) {
            if (exprHasExplicitUnknown(r->value.get())) return true;
        } else if (auto* i = llvm::dyn_cast<CIfStmt>(s)) {
            if (exprHasExplicitUnknown(i->condition.get()) ||
                scanForExplicitUnknown(i->thenBody) ||
                scanForExplicitUnknown(i->elseBody)) return true;
        } else if (auto* w = llvm::dyn_cast<CWhileStmt>(s)) {
            if (exprHasExplicitUnknown(w->condition.get()) ||
                scanForExplicitUnknown(w->body)) return true;
        } else if (auto* d = llvm::dyn_cast<CDoWhileStmt>(s)) {
            if (exprHasExplicitUnknown(d->condition.get()) ||
                scanForExplicitUnknown(d->body)) return true;
        } else if (auto* f = llvm::dyn_cast<CForStmt>(s)) {
            if (exprHasExplicitUnknown(f->condition.get()) ||
                scanForExplicitUnknown(f->body)) return true;
        } else if (auto* sw = llvm::dyn_cast<CSwitchStmt>(s)) {
            if (exprHasExplicitUnknown(sw->selector.get())) return true;
            for (auto& c : sw->cases)
                if (scanForExplicitUnknown(c.body)) return true;
        } else if (auto* b = llvm::dyn_cast<CBlockStmt>(s)) {
            if (scanForExplicitUnknown(b->stmts)) return true;
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

// ── issue #31 / D3: statements after same-scope return ──────────────────────
// Same linear rule as reanalyzeConfidence's soft penalty: once a return is
// seen in a statement list, every later sibling is unreachable sequential C.
// Nested scopes are counted independently (return inside then-body does not
// poison the else).  Surviving after removeDeadCodeAfterReturn means either
// FIX-050 preserved a call-bearing tail or the pass missed the junk — both
// are honesty defects when the user still sees post-return code.
inline int countUnreachableAfterReturn(const std::vector<StmtPtr>& body) {
    int n = 0;
    bool sawReturn = false;
    for (auto& sp : body) {
        const CStmt* s = sp.get();
        if (!s) continue;
        if (sawReturn) {
            ++n;
            continue;
        }
        if (llvm::isa<CReturnStmt>(s)) {
            sawReturn = true;
            continue;
        }
        if (auto* ifS = llvm::dyn_cast<CIfStmt>(s)) {
            n += countUnreachableAfterReturn(ifS->thenBody);
            n += countUnreachableAfterReturn(ifS->elseBody);
        } else if (auto* wh = llvm::dyn_cast<CWhileStmt>(s)) {
            n += countUnreachableAfterReturn(wh->body);
        } else if (auto* dw = llvm::dyn_cast<CDoWhileStmt>(s)) {
            n += countUnreachableAfterReturn(dw->body);
        } else if (auto* fr = llvm::dyn_cast<CForStmt>(s)) {
            n += countUnreachableAfterReturn(fr->body);
        } else if (auto* sw = llvm::dyn_cast<CSwitchStmt>(s)) {
            for (auto& c : sw->cases)
                n += countUnreachableAfterReturn(c.body);
        } else if (auto* blk = llvm::dyn_cast<CBlockStmt>(s)) {
            n += countUnreachableAfterReturn(blk->stmts);
        }
    }
    return n;
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
    std::unordered_set<std::string> addressTaken;
    detail::collectAddressTakenInStmts(func.body, addressTaken);

    for (const auto& lv : func.localVars) {
        if (lv.initExpr) continue;                        // has an initializer
        if (!returnedVars.count(lv.varName)) continue;    // not returned
        if (addressTaken.count(lv.varName)) continue;     // may be initialized indirectly
        if (liveAssignedVars.count(lv.varName)) continue; // assigned on a live path
        info.uninitReturn = true;
        info.uninitVarName = lv.varName;
        break;
    }

    // FIX-123: "assigned somewhere" is not "assigned on every path".  Apply a
    // small definite-assignment analysis only to structured, alias-safe bodies.
    if (!info.uninitReturn &&
        detail::supportsDefiniteAssignmentScan(func.body)) {
        std::unordered_set<std::string> candidates;
        std::unordered_set<std::string> initiallyAssigned;

        for (const auto& p : func.params)
            initiallyAssigned.insert(p.name);
        for (const auto& lv : func.localVars) {
            if (lv.initExpr)
                initiallyAssigned.insert(lv.varName);
            else
                candidates.insert(lv.varName);
        }

        auto flow = detail::analyzeDefiniteAssignments(
            func.body, std::move(initiallyAssigned), candidates,
            addressTaken, zeroLocals);
        if (flow.uninitReturn) {
            info.uninitReturn = true;
            info.uninitVarName = flow.uninitVar;
        }
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

    // (6) issue #31 — surviving post-return statements (D3 honesty).
    // Soft penalty alone (5 pts each, cap 40) still allows Medium/High when the
    // rest of the body is syntactically clean.  Hard-cap when any remain.
    {
        int n = detail::countUnreachableAfterReturn(func.body);
        if (n > 0) {
            info.postReturnUnreachable = true;
            info.postReturnCount = n;
        }
    }

    // (7) issue #56 — an empty function or a lone bare `return;` contains no
    // recovered behavior. This is distinct from a legitimate tiny wrapper
    // such as `return real_callee(x);`, which needs lift-coverage evidence
    // from the IDE before it can be called under-lifted.
    if (func.body.empty() ||
        (func.body.size() == 1 &&
         llvm::isa<CReturnStmt>(func.body.front().get()) &&
         !llvm::cast<CReturnStmt>(func.body.front().get())->value)) {
        info.emptyStubBody = true;
    }

    // (8) Explicit unknown is honest output, but it also proves that semantic
    // equivalence is incomplete. It must remain visible and cap confidence.
    if (detail::scanForExplicitUnknown(func.body))
        info.explicitUnknown = true;

    return info;
}

} // namespace helix::cast
