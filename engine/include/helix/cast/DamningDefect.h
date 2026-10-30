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
//   (5) scalar subscript            -- non-compilable `scalar[0]` (FIX-111)
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
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/StringRef.h"

#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <optional>
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
    bool scalarSubscript = false;    // (5) FIX-111: scalar `v[0]` / float index
    bool postReturnUnreachable = false; // (6) #31: stmts after same-scope return
    int postReturnCount = 0;            //     how many (for the reason string)
    bool emptyStubBody = false;         // (7) #56: no body or only bare return
    bool explicitUnknown = false;       // (8) localized semantic gap survived
    bool uninitRead = false;            // (9) intermediate read has no reaching initialization
    std::string uninitReadVarName;
    bool literalNullAccess = false;     // (10) read/write through literal address zero
    int literalNullAccessCount = 0;
    bool invalidShiftCount = false;     // (11) constant shift outside operand width
    int invalidShiftCountOccurrences = 0;
    bool invalidPointerOperation = false; // (12) pointer used in forbidden scalar arithmetic
    int invalidPointerOperationCount = 0;

    bool any() const {
        return codeAddrLeak || uninitReturn || irreducibleNoReturn ||
               droppedControlFlow || scalarSubscript || postReturnUnreachable ||
               emptyStubBody || explicitUnknown || uninitRead ||
               literalNullAccess || invalidShiftCount ||
               invalidPointerOperation;
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
        if (scalarSubscript)
            add("non-compilable scalar subscript (base is not a pointer or array)");
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
        if (uninitRead)
            add("read without any reaching initialization '" + uninitReadVarName + "'");
        if (literalNullAccess) {
            char buf[96];
            std::snprintf(buf, sizeof(buf),
                          "%d literal null memory access(es) survived",
                          literalNullAccessCount > 0 ? literalNullAccessCount : 1);
            add(buf);
        }
        if (invalidShiftCount) {
            char buf[96];
            std::snprintf(buf, sizeof(buf),
                          "%d undefined constant shift count(s) survived",
                          invalidShiftCountOccurrences > 0
                              ? invalidShiftCountOccurrences : 1);
            add(buf);
        }
        if (invalidPointerOperation) {
            char buf[96];
            std::snprintf(buf, sizeof(buf),
                          "%d invalid pointer/scalar operation(s) survived",
                          invalidPointerOperationCount > 0
                              ? invalidPointerOperationCount : 1);
            add(buf);
        }
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
// constant 0 (initialised to 0 and never reassigned). Integer casts must be
// evaluated before truth conversion: (uint8_t)256 is zero, not true.
struct KnownConditionInteger {
    llvm::APInt bits;
    bool isSigned;
};

inline std::optional<KnownConditionInteger> knownConditionInteger(
        const CExpr* e, const std::unordered_set<std::string>& zeroLocals,
        unsigned depth = 0) {
    if (!e || depth >= 64) return std::nullopt;
    if (auto* literal = llvm::dyn_cast<CIntLitExpr>(e))
        return KnownConditionInteger{llvm::APInt(64, static_cast<uint64_t>(literal->value)),
            !literal->type || literal->type->isSigned};
    if (auto* variable = llvm::dyn_cast<CVarRefExpr>(e)) {
        if (zeroLocals.count(variable->varName))
            return KnownConditionInteger{llvm::APInt(64, 0), true};
        return std::nullopt;
    }
    if (auto* unary = llvm::dyn_cast<CUnaryExpr>(e)) {
        if (unary->op != UnaryOp::LogNot) return std::nullopt;
        auto operand = knownConditionInteger(unary->operand.get(), zeroLocals, depth + 1);
        if (!operand) return std::nullopt;
        return KnownConditionInteger{llvm::APInt(1, operand->bits.isZero()), false};
    }
    if (auto* cast = llvm::dyn_cast<CCastExpr>(e)) {
        if (!cast->targetType) return std::nullopt;
        auto operand = knownConditionInteger(cast->operand.get(), zeroLocals, depth + 1);
        if (!operand) return std::nullopt;
        const auto& target = *cast->targetType;
        if (target.kind == TypeKind::Bool)
            return KnownConditionInteger{llvm::APInt(1, !operand->bits.isZero()), false};
        if (target.kind == TypeKind::Int && target.bitWidth > 0 && target.bitWidth <= 64)
            return KnownConditionInteger{
                operand->isSigned ? operand->bits.sextOrTrunc(target.bitWidth)
                                  : operand->bits.zextOrTrunc(target.bitWidth),
                target.isSigned};
        if ((target.kind == TypeKind::Pointer || target.kind == TypeKind::Float) && operand->bits.isZero())
            return KnownConditionInteger{llvm::APInt(64, 0), false};
    }
    return std::nullopt;
}

inline bool isProvablyZero(const CExpr* e,
                           const std::unordered_set<std::string>& zeroLocals) {
    const auto value = knownConditionInteger(e, zeroLocals);
    return value && value->bits.isZero();
}

inline bool isProvablyNonzero(const CExpr* e,
                              const std::unordered_set<std::string>& zeroLocals) {
    const auto value = knownConditionInteger(e, zeroLocals);
    return value && !value->bits.isZero();
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
// assignments from potentially zero-trip loops are not propagated to the exit. Switches, gotos,
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
            auto simple = [](const CStmt* stmt) {
                return !stmt || llvm::isa<CAssignStmt, CExprStmt>(stmt);
            };
            if (!simple(loop->init.get()) || !simple(loop->step.get())) return false;
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
    std::unordered_set<std::string> mayAssigned;
    bool fallsThrough = true;
    bool uninitReturn = false;
    std::string uninitVar;
    std::string uninitReadVar;
};

inline std::string firstUninitializedRead(
        const CExpr* expr,
        const std::unordered_set<std::string>& assigned,
        const std::unordered_set<std::string>& candidates,
        const std::unordered_set<std::string>& addressTaken,
        const std::unordered_set<std::string>& zeroLocals) {
    if (!expr) return {};
    auto check = [&](const CExpr* child) {
        return firstUninitializedRead(child, assigned, candidates, addressTaken, zeroLocals);
    };
    if (auto* ref = llvm::dyn_cast<CVarRefExpr>(expr))
        return candidates.count(ref->varName) && !assigned.count(ref->varName) &&
            !addressTaken.count(ref->varName) ? ref->varName : std::string{};
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr)) return check(cast->operand.get());
    if (auto* unary = llvm::dyn_cast<CUnaryExpr>(expr)) {
        // Address-taking itself does not read the stored local value. Indirect
        // initialization remains outside this alias-safe detector's scope.
        return unary->op == UnaryOp::AddressOf ? std::string{} : check(unary->operand.get());
    }
    if (auto* binary = llvm::dyn_cast<CBinaryExpr>(expr)) {
        auto left = check(binary->lhs.get());
        if (!left.empty()) return left;
        if (binary->op == BinaryOp::LogAnd && isProvablyZero(binary->lhs.get(), zeroLocals)) return {};
        if (binary->op == BinaryOp::LogOr && isProvablyNonzero(binary->lhs.get(), zeroLocals)) return {};
        return check(binary->rhs.get());
    }
    if (auto* ternary = llvm::dyn_cast<CTernaryExpr>(expr)) {
        auto condition = check(ternary->cond.get());
        if (!condition.empty()) return condition;
        if (!isProvablyZero(ternary->cond.get(), zeroLocals)) {
            auto yes = check(ternary->trueVal.get());
            if (!yes.empty()) return yes;
        }
        return isProvablyNonzero(ternary->cond.get(), zeroLocals) ? std::string{} : check(ternary->falseVal.get());
    }
    if (auto* subscript = llvm::dyn_cast<CSubscriptExpr>(expr)) {
        auto base = check(subscript->base.get());
        return base.empty() ? check(subscript->index.get()) : base;
    }
    if (auto* field = llvm::dyn_cast<CFieldAccessExpr>(expr)) return check(field->base.get());
    if (auto* call = llvm::dyn_cast<CCallExpr>(expr)) {
        for (const auto& arg : call->args) {
            auto found = check(arg.get());
            if (!found.empty()) return found;
        }
    }
    return {};
}

inline bool exprReferencesVariable(const CExpr* e, llvm::StringRef name) {
    if (!e || name.empty()) return false;
    if (auto* v = llvm::dyn_cast<CVarRefExpr>(e)) return v->varName == name;
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return exprReferencesVariable(c->operand.get(), name);
    if (auto* u = llvm::dyn_cast<CUnaryExpr>(e))
        return exprReferencesVariable(u->operand.get(), name);
    if (auto* b = llvm::dyn_cast<CBinaryExpr>(e))
        return exprReferencesVariable(b->lhs.get(), name) ||
               exprReferencesVariable(b->rhs.get(), name);
    if (auto* t = llvm::dyn_cast<CTernaryExpr>(e))
        return exprReferencesVariable(t->cond.get(), name) ||
               exprReferencesVariable(t->trueVal.get(), name) ||
               exprReferencesVariable(t->falseVal.get(), name);
    if (auto* s = llvm::dyn_cast<CSubscriptExpr>(e))
        return exprReferencesVariable(s->base.get(), name) ||
               exprReferencesVariable(s->index.get(), name);
    if (auto* f = llvm::dyn_cast<CFieldAccessExpr>(e))
        return exprReferencesVariable(f->base.get(), name);
    if (auto* call = llvm::dyn_cast<CCallExpr>(e)) {
        for (const auto& arg : call->args)
            if (exprReferencesVariable(arg.get(), name)) return true;
    }
    return false;
}

/// `x = cond ? replacement : x` (or the swapped-arm form) preserves the old
/// value on one edge and replaces it on the other. This is a canonical select/
/// cmov update, not a circular definition. Keep the recognition narrow: the
/// preserved arm must be a direct x, and the replacement must not depend on x.
inline bool isConditionalPreserveUpdate(const CExpr* e,
                                        llvm::StringRef target) {
    auto* ternary = llvm::dyn_cast_or_null<CTernaryExpr>(e);
    if (!ternary || target.empty()) return false;
    auto isExactTarget = [&](const CExpr* arm) {
        auto* ref = llvm::dyn_cast_or_null<CVarRefExpr>(arm);
        return ref && ref->varName == target;
    };
    const bool truePreserves = isExactTarget(ternary->trueVal.get());
    const bool falsePreserves = isExactTarget(ternary->falseVal.get());
    if (truePreserves == falsePreserves) return false;
    const CExpr* replacement = truePreserves ? ternary->falseVal.get()
                                             : ternary->trueVal.get();
    return !exprReferencesVariable(replacement, target);
}

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
        std::unordered_set<std::string> incomingMay,
        const std::unordered_set<std::string>& candidates,
        const std::unordered_set<std::string>& readCandidates,
        const std::unordered_set<std::string>& addressTaken,
        const std::unordered_set<std::string>& zeroLocals) {
    DefiniteAssignmentFlow flow{std::move(incoming), std::move(incomingMay)};
    auto checkRead = [&](const CExpr* expr) {
        if (flow.uninitReadVar.empty())
            flow.uninitReadVar = firstUninitializedRead(
                expr, flow.mayAssigned, readCandidates, addressTaken, zeroLocals);
    };
    auto preserveFailure = [&](const DefiniteAssignmentFlow& nested) {
        if (nested.uninitReturn && !flow.uninitReturn) {
            flow.uninitReturn = true;
            flow.uninitVar = nested.uninitVar;
        }
        if (flow.uninitReadVar.empty()) flow.uninitReadVar = nested.uninitReadVar;
    };
    auto applySimpleStatement = [&](const CStmt* statement) {
        if (auto* assign = llvm::dyn_cast_or_null<CAssignStmt>(statement)) {
            checkRead(assign->value.get());
            if (!assign->compoundOp.empty() || !llvm::isa_and_nonnull<CVarRefExpr>(assign->target.get()))
                checkRead(assign->target.get());
            if (assign->compoundOp.empty())
                if (auto name = plainVarName(assign->target.get()); !name.empty()) {
                    flow.assigned.insert(name);
                    flow.mayAssigned.insert(name);
                }
        } else if (auto* expr = llvm::dyn_cast_or_null<CExprStmt>(statement)) {
            checkRead(expr->expr.get());
        }
    };

    for (auto& sp : body) {
        const CStmt* s = sp.get();
        if (!s || !flow.fallsThrough) continue;

        if (auto* assign = llvm::dyn_cast<CAssignStmt>(s)) {
            // Compound assignment and ++/-- read the old value first, so they
            // cannot establish initialization of a previously undefined local.
            applySimpleStatement(assign);
            continue;
        }
        if (auto* expr = llvm::dyn_cast<CExprStmt>(s)) {
            applySimpleStatement(expr);
            continue;
        }

        if (auto* ret = llvm::dyn_cast<CReturnStmt>(s)) {
            checkRead(ret->value.get());
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
                block->stmts, flow.assigned, flow.mayAssigned,
                candidates, readCandidates, addressTaken,
                zeroLocals);
            preserveFailure(nested);
            flow.assigned = std::move(nested.assigned);
            flow.mayAssigned = std::move(nested.mayAssigned);
            flow.fallsThrough = nested.fallsThrough;
            continue;
        }

        auto analyzeLoopBody = [&](const std::vector<StmtPtr>& loopBody) {
            auto nested = analyzeDefiniteAssignments(
                loopBody, flow.assigned, flow.mayAssigned,
                candidates, readCandidates, addressTaken, zeroLocals);
            preserveFailure(nested);
            // The caller decides whether the loop can execute zero times.
            return nested;
        };
        if (auto* loop = llvm::dyn_cast<CWhileStmt>(s)) {
            checkRead(loop->condition.get());
            if (!isProvablyZero(loop->condition.get(), zeroLocals)) {
                auto nested = analyzeLoopBody(loop->body);
                flow.mayAssigned.insert(nested.mayAssigned.begin(),
                                        nested.mayAssigned.end());
            }
            continue;
        }
        if (auto* loop = llvm::dyn_cast<CDoWhileStmt>(s)) {
            auto nested = analyzeLoopBody(loop->body);
            // The supported subset excludes break, continue, labels and goto.
            // A falling-through do-body therefore executes at least once.
            flow.assigned = std::move(nested.assigned);
            flow.mayAssigned = std::move(nested.mayAssigned);
            flow.fallsThrough = nested.fallsThrough;
            if (flow.fallsThrough) checkRead(loop->condition.get());
            continue;
        }
        if (auto* loop = llvm::dyn_cast<CForStmt>(s)) {
            applySimpleStatement(loop->init.get());
            checkRead(loop->condition.get());
            if (!isProvablyZero(loop->condition.get(), zeroLocals)) {
                auto nested = analyzeLoopBody(loop->body);
                if (nested.fallsThrough) {
                    auto beforeLoop = flow.assigned;
                    auto possibleAfterLoop = flow.mayAssigned;
                    possibleAfterLoop.insert(nested.mayAssigned.begin(),
                                             nested.mayAssigned.end());
                    flow.assigned = std::move(nested.assigned);
                    flow.mayAssigned = nested.mayAssigned;
                    applySimpleStatement(loop->step.get());
                    flow.assigned = std::move(beforeLoop);
                    possibleAfterLoop.insert(flow.mayAssigned.begin(),
                                             flow.mayAssigned.end());
                    flow.mayAssigned = std::move(possibleAfterLoop);
                }
            }
            continue;
        }

        if (auto* ifS = llvm::dyn_cast<CIfStmt>(s)) {
            checkRead(ifS->condition.get());
            bool onlyElse = isProvablyZero(ifS->condition.get(), zeroLocals);
            bool onlyThen =
                isProvablyNonzero(ifS->condition.get(), zeroLocals);

            DefiniteAssignmentFlow thenFlow{flow.assigned, flow.mayAssigned};
            DefiniteAssignmentFlow elseFlow{flow.assigned, flow.mayAssigned};
            if (!onlyElse) {
                thenFlow = analyzeDefiniteAssignments(
                    ifS->thenBody, flow.assigned, flow.mayAssigned,
                    candidates, readCandidates, addressTaken,
                    zeroLocals);
            }
            if (!onlyThen && !ifS->elseBody.empty()) {
                elseFlow = analyzeDefiniteAssignments(
                    ifS->elseBody, flow.assigned, flow.mayAssigned,
                    candidates, readCandidates, addressTaken,
                    zeroLocals);
            }

            if (!onlyElse) preserveFailure(thenFlow);
            if (!onlyThen) preserveFailure(elseFlow);

            if (onlyThen) {
                flow.assigned = std::move(thenFlow.assigned);
                flow.mayAssigned = std::move(thenFlow.mayAssigned);
                flow.fallsThrough = thenFlow.fallsThrough;
            } else if (onlyElse) {
                flow.assigned = std::move(elseFlow.assigned);
                flow.mayAssigned = std::move(elseFlow.mayAssigned);
                flow.fallsThrough = elseFlow.fallsThrough;
            } else if (thenFlow.fallsThrough && elseFlow.fallsThrough) {
                flow.assigned = intersectAssigned(
                    thenFlow.assigned, elseFlow.assigned);
                flow.mayAssigned = std::move(thenFlow.mayAssigned);
                flow.mayAssigned.insert(elseFlow.mayAssigned.begin(),
                                        elseFlow.mayAssigned.end());
            } else if (thenFlow.fallsThrough) {
                flow.assigned = std::move(thenFlow.assigned);
                flow.mayAssigned = std::move(thenFlow.mayAssigned);
            } else if (elseFlow.fallsThrough) {
                flow.assigned = std::move(elseFlow.assigned);
                flow.mayAssigned = std::move(elseFlow.mayAssigned);
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

// ── FIX-111: non-compilable scalar subscript ────────────────────────────────
// A subscript requires a pointer or array base. Lowering defects previously
// emitted both `float_value[0]` and `int_value[1]`; the float-only detector let
// the latter report High confidence. Declaration types are authoritative here
// because use-site VarRef types can drift during SSA destruction.
inline bool isKnownNonSubscriptableBase(
        const CExpr* e,
        const std::unordered_set<std::string>& scalarVars) {
    if (!e) return false;
    if (auto* c = llvm::dyn_cast<CCastExpr>(e)) {
        if (c->targetType) {
            if (c->targetType->kind == TypeKind::Pointer ||
                c->targetType->kind == TypeKind::Array)
                return false;
            if (c->targetType->kind != TypeKind::Unknown)
                return true;
        }
        return isKnownNonSubscriptableBase(c->operand.get(), scalarVars);
    }
    if (auto* v = llvm::dyn_cast<CVarRefExpr>(e))
        if (scalarVars.count(v->varName)) return true;
    if (!e->type || e->type->kind == TypeKind::Unknown)
        return false;
    return e->type->kind != TypeKind::Pointer &&
           e->type->kind != TypeKind::Array;
}

inline bool exprHasScalarSubscript(
        const CExpr* e, const std::unordered_set<std::string>& scalarVars) {
    if (!e) return false;
    if (auto* s = llvm::dyn_cast<CSubscriptExpr>(e)) {
        if (isKnownNonSubscriptableBase(s->base.get(), scalarVars))
            return true;
        if (s->index && llvm::isa<CFloatLitExpr>(s->index.get()))
            return true;
        return exprHasScalarSubscript(s->base.get(), scalarVars) ||
               exprHasScalarSubscript(s->index.get(), scalarVars);
    }
    if (auto* c = llvm::dyn_cast<CCastExpr>(e))
        return exprHasScalarSubscript(c->operand.get(), scalarVars);
    if (auto* u = llvm::dyn_cast<CUnaryExpr>(e))
        return exprHasScalarSubscript(u->operand.get(), scalarVars);
    if (auto* b = llvm::dyn_cast<CBinaryExpr>(e))
        return exprHasScalarSubscript(b->lhs.get(), scalarVars) ||
               exprHasScalarSubscript(b->rhs.get(), scalarVars);
    if (auto* t = llvm::dyn_cast<CTernaryExpr>(e))
        return exprHasScalarSubscript(t->cond.get(), scalarVars) ||
               exprHasScalarSubscript(t->trueVal.get(), scalarVars) ||
               exprHasScalarSubscript(t->falseVal.get(), scalarVars);
    if (auto* fa = llvm::dyn_cast<CFieldAccessExpr>(e))
        return exprHasScalarSubscript(fa->base.get(), scalarVars);
    if (auto* call = llvm::dyn_cast<CCallExpr>(e)) {
        for (auto& a : call->args)
            if (exprHasScalarSubscript(a.get(), scalarVars)) return true;
        return false;
    }
    return false;
}

inline bool scanForScalarSubscript(
        const std::vector<StmtPtr>& body,
        const std::unordered_set<std::string>& scalarVars) {
    for (auto& sp : body) {
        const CStmt* s = sp.get();
        if (!s) continue;
        if (auto* es = llvm::dyn_cast<CExprStmt>(s)) {
            if (exprHasScalarSubscript(es->expr.get(), scalarVars)) return true;
        } else if (auto* as = llvm::dyn_cast<CAssignStmt>(s)) {
            if (exprHasScalarSubscript(as->value.get(), scalarVars)) return true;
            if (exprHasScalarSubscript(as->target.get(), scalarVars)) return true;
        } else if (auto* rs = llvm::dyn_cast<CReturnStmt>(s)) {
            if (rs->value && exprHasScalarSubscript(rs->value.get(), scalarVars)) return true;
        } else if (auto* ifS = llvm::dyn_cast<CIfStmt>(s)) {
            if (exprHasScalarSubscript(ifS->condition.get(), scalarVars)) return true;
            if (scanForScalarSubscript(ifS->thenBody, scalarVars)) return true;
            if (scanForScalarSubscript(ifS->elseBody, scalarVars)) return true;
        } else if (auto* wh = llvm::dyn_cast<CWhileStmt>(s)) {
            if (exprHasScalarSubscript(wh->condition.get(), scalarVars)) return true;
            if (scanForScalarSubscript(wh->body, scalarVars)) return true;
        } else if (auto* dw = llvm::dyn_cast<CDoWhileStmt>(s)) {
            if (exprHasScalarSubscript(dw->condition.get(), scalarVars)) return true;
            if (scanForScalarSubscript(dw->body, scalarVars)) return true;
        } else if (auto* fr = llvm::dyn_cast<CForStmt>(s)) {
            if (scanForScalarSubscript(fr->body, scalarVars)) return true;
        } else if (auto* sw = llvm::dyn_cast<CSwitchStmt>(s)) {
            if (exprHasScalarSubscript(sw->selector.get(), scalarVars)) return true;
            for (auto& c : sw->cases)
                if (scanForScalarSubscript(c.body, scalarVars)) return true;
        } else if (auto* blk = llvm::dyn_cast<CBlockStmt>(s)) {
            if (scanForScalarSubscript(blk->stmts, scalarVars)) return true;
        }
    }
    return false;
}

// A constant C shift is undefined when its count is negative or is not less
// than the promoted left operand width. Unknown types stay unclassified: this
// is an honesty cap, so it only fires when the final AST proves the defect.
inline std::optional<int64_t> integerLiteralValue(const CExpr* expr) {
    if (!expr) return std::nullopt;
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr))
        return integerLiteralValue(cast->operand.get());
    if (auto* integer = llvm::dyn_cast<CIntLitExpr>(expr))
        return integer->value;
    return std::nullopt;
}

inline bool isNullConstantExpr(const CExpr* expr) {
    if (!expr) return false;
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr))
        return isNullConstantExpr(cast->operand.get());
    if (auto* address = llvm::dyn_cast<CAddrLitExpr>(expr))
        return address->addrValue == 0;
    const auto integer = integerLiteralValue(expr);
    return integer && *integer == 0;
}

inline unsigned promotedIntegerWidth(const CExpr* expr) {
    if (!expr || !expr->type) return 0;
    const auto& type = expr->type;
    if (type->kind == TypeKind::Bool)
        return 32;
    if (type->kind != TypeKind::Int || type->bitWidth == 0)
        return 0;
    return std::max(32u, type->bitWidth);
}

inline int countInvalidShiftCountsInExpr(const CExpr* expr) {
    if (!expr) return 0;
    int count = 0;
    if (auto* binary = llvm::dyn_cast<CBinaryExpr>(expr)) {
        if (binary->op == BinaryOp::Shl || binary->op == BinaryOp::Shr ||
            binary->op == BinaryOp::Sar) {
            const auto shift = integerLiteralValue(binary->rhs.get());
            const unsigned width = promotedIntegerWidth(binary->lhs.get());
            if (shift && width > 0 &&
                (*shift < 0 || static_cast<uint64_t>(*shift) >= width))
                ++count;
        }
        return count + countInvalidShiftCountsInExpr(binary->lhs.get()) +
               countInvalidShiftCountsInExpr(binary->rhs.get());
    }
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr))
        return countInvalidShiftCountsInExpr(cast->operand.get());
    if (auto* unary = llvm::dyn_cast<CUnaryExpr>(expr))
        return countInvalidShiftCountsInExpr(unary->operand.get());
    if (auto* ternary = llvm::dyn_cast<CTernaryExpr>(expr))
        return countInvalidShiftCountsInExpr(ternary->cond.get()) +
               countInvalidShiftCountsInExpr(ternary->trueVal.get()) +
               countInvalidShiftCountsInExpr(ternary->falseVal.get());
    if (auto* subscript = llvm::dyn_cast<CSubscriptExpr>(expr))
        return countInvalidShiftCountsInExpr(subscript->base.get()) +
               countInvalidShiftCountsInExpr(subscript->index.get());
    if (auto* field = llvm::dyn_cast<CFieldAccessExpr>(expr))
        return countInvalidShiftCountsInExpr(field->base.get());
    if (auto* call = llvm::dyn_cast<CCallExpr>(expr)) {
        for (const auto& argument : call->args)
            count += countInvalidShiftCountsInExpr(argument.get());
    }
    return count;
}

inline int countInvalidShiftCounts(const std::vector<StmtPtr>& body) {
    int count = 0;
    for (const auto& statementPtr : body) {
        const CStmt* statement = statementPtr.get();
        if (!statement) continue;
        if (auto* assign = llvm::dyn_cast<CAssignStmt>(statement)) {
            count += countInvalidShiftCountsInExpr(assign->target.get());
            count += countInvalidShiftCountsInExpr(assign->value.get());
        } else if (auto* expression = llvm::dyn_cast<CExprStmt>(statement)) {
            count += countInvalidShiftCountsInExpr(expression->expr.get());
        } else if (auto* result = llvm::dyn_cast<CReturnStmt>(statement)) {
            count += countInvalidShiftCountsInExpr(result->value.get());
        } else if (auto* branch = llvm::dyn_cast<CIfStmt>(statement)) {
            count += countInvalidShiftCountsInExpr(branch->condition.get());
            count += countInvalidShiftCounts(branch->thenBody);
            count += countInvalidShiftCounts(branch->elseBody);
        } else if (auto* loop = llvm::dyn_cast<CWhileStmt>(statement)) {
            count += countInvalidShiftCountsInExpr(loop->condition.get());
            count += countInvalidShiftCounts(loop->body);
        } else if (auto* loop = llvm::dyn_cast<CDoWhileStmt>(statement)) {
            count += countInvalidShiftCountsInExpr(loop->condition.get());
            count += countInvalidShiftCounts(loop->body);
        } else if (auto* loop = llvm::dyn_cast<CForStmt>(statement)) {
            if (loop->init) {
                if (auto* initAssign = llvm::dyn_cast<CAssignStmt>(loop->init.get())) {
                    count += countInvalidShiftCountsInExpr(initAssign->target.get());
                    count += countInvalidShiftCountsInExpr(initAssign->value.get());
                } else if (auto* initExpr = llvm::dyn_cast<CExprStmt>(loop->init.get())) {
                    count += countInvalidShiftCountsInExpr(initExpr->expr.get());
                }
            }
            count += countInvalidShiftCountsInExpr(loop->condition.get());
            if (auto* stepAssign = llvm::dyn_cast_or_null<CAssignStmt>(loop->step.get())) {
                count += countInvalidShiftCountsInExpr(stepAssign->target.get());
                count += countInvalidShiftCountsInExpr(stepAssign->value.get());
            } else if (auto* stepExpr = llvm::dyn_cast_or_null<CExprStmt>(loop->step.get())) {
                count += countInvalidShiftCountsInExpr(stepExpr->expr.get());
            }
            count += countInvalidShiftCounts(loop->body);
        } else if (auto* selection = llvm::dyn_cast<CSwitchStmt>(statement)) {
            count += countInvalidShiftCountsInExpr(selection->selector.get());
            for (const auto& arm : selection->cases)
                count += countInvalidShiftCounts(arm.body);
        } else if (auto* block = llvm::dyn_cast<CBlockStmt>(statement)) {
            count += countInvalidShiftCounts(block->stmts);
        }
    }
    return count;
}

inline bool isKnownPointerExpr(
        const CExpr* expr,
        const std::unordered_set<std::string>& pointerVars) {
    if (!expr) return false;
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr))
        return cast->targetType &&
               (cast->targetType->kind == TypeKind::Pointer ||
                cast->targetType->kind == TypeKind::Array ||
                cast->targetType->kind == TypeKind::FuncPtr);
    if (auto* variable = llvm::dyn_cast<CVarRefExpr>(expr))
        if (pointerVars.count(variable->varName)) return true;
    return expr->type &&
           (expr->type->kind == TypeKind::Pointer ||
            expr->type->kind == TypeKind::Array ||
            expr->type->kind == TypeKind::FuncPtr);
}

inline bool isKnownScalarExpr(
        const CExpr* expr,
        const std::unordered_set<std::string>& scalarVars) {
    if (!expr) return false;
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr))
        return cast->targetType &&
               (cast->targetType->kind == TypeKind::Bool ||
                cast->targetType->kind == TypeKind::Int ||
                cast->targetType->kind == TypeKind::Float);
    if (auto* variable = llvm::dyn_cast<CVarRefExpr>(expr))
        if (scalarVars.count(variable->varName)) return true;
    return expr->type &&
           (expr->type->kind == TypeKind::Bool ||
            expr->type->kind == TypeKind::Int ||
            expr->type->kind == TypeKind::Float);
}

inline int countInvalidPointerOpsInExpr(
        const CExpr* expr,
        const std::unordered_set<std::string>& pointerVars,
        const std::unordered_set<std::string>& scalarVars) {
    if (!expr) return 0;
    int count = 0;
    if (auto* binary = llvm::dyn_cast<CBinaryExpr>(expr)) {
        const bool lhsPointer = isKnownPointerExpr(binary->lhs.get(), pointerVars);
        const bool rhsPointer = isKnownPointerExpr(binary->rhs.get(), pointerVars);
        switch (binary->op) {
        case BinaryOp::Mul:
        case BinaryOp::Div:
        case BinaryOp::Mod:
        case BinaryOp::Shl:
        case BinaryOp::Shr:
        case BinaryOp::Sar:
        case BinaryOp::BitAnd:
        case BinaryOp::BitOr:
        case BinaryOp::BitXor:
            if (lhsPointer || rhsPointer) ++count;
            break;
        case BinaryOp::Add:
            if (lhsPointer && rhsPointer) ++count;
            break;
        case BinaryOp::Eq:
        case BinaryOp::Ne:
            if ((lhsPointer && isKnownScalarExpr(binary->rhs.get(), scalarVars) &&
                 !isNullConstantExpr(binary->rhs.get())) ||
                (rhsPointer && isKnownScalarExpr(binary->lhs.get(), scalarVars) &&
                 !isNullConstantExpr(binary->lhs.get())))
                ++count;
            break;
        case BinaryOp::Lt:
        case BinaryOp::Le:
        case BinaryOp::Gt:
        case BinaryOp::Ge:
            if (lhsPointer != rhsPointer) ++count;
            break;
        default:
            break;
        }
        return count + countInvalidPointerOpsInExpr(
                           binary->lhs.get(), pointerVars, scalarVars) +
                       countInvalidPointerOpsInExpr(
                           binary->rhs.get(), pointerVars, scalarVars);
    }
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr))
        return countInvalidPointerOpsInExpr(
            cast->operand.get(), pointerVars, scalarVars);
    if (auto* unary = llvm::dyn_cast<CUnaryExpr>(expr))
        return countInvalidPointerOpsInExpr(
            unary->operand.get(), pointerVars, scalarVars);
    if (auto* ternary = llvm::dyn_cast<CTernaryExpr>(expr))
        return countInvalidPointerOpsInExpr(ternary->cond.get(), pointerVars, scalarVars) +
               countInvalidPointerOpsInExpr(ternary->trueVal.get(), pointerVars, scalarVars) +
               countInvalidPointerOpsInExpr(ternary->falseVal.get(), pointerVars, scalarVars);
    if (auto* subscript = llvm::dyn_cast<CSubscriptExpr>(expr))
        return countInvalidPointerOpsInExpr(subscript->base.get(), pointerVars, scalarVars) +
               countInvalidPointerOpsInExpr(subscript->index.get(), pointerVars, scalarVars);
    if (auto* field = llvm::dyn_cast<CFieldAccessExpr>(expr))
        return countInvalidPointerOpsInExpr(field->base.get(), pointerVars, scalarVars);
    if (auto* call = llvm::dyn_cast<CCallExpr>(expr))
        for (const auto& argument : call->args)
            count += countInvalidPointerOpsInExpr(
                argument.get(), pointerVars, scalarVars);
    return count;
}

inline int countInvalidPointerOperations(
        const std::vector<StmtPtr>& body,
        const std::unordered_set<std::string>& pointerVars,
        const std::unordered_set<std::string>& scalarVars) {
    int count = 0;
    for (const auto& statementPtr : body) {
        const CStmt* statement = statementPtr.get();
        if (!statement) continue;
        if (auto* assign = llvm::dyn_cast<CAssignStmt>(statement)) {
            count += countInvalidPointerOpsInExpr(
                assign->target.get(), pointerVars, scalarVars);
            count += countInvalidPointerOpsInExpr(
                assign->value.get(), pointerVars, scalarVars);
            const bool pointerTarget =
                isKnownPointerExpr(assign->target.get(), pointerVars);
            if (pointerTarget && assign->compoundOp.empty() &&
                isKnownScalarExpr(assign->value.get(), scalarVars) &&
                !isNullConstantExpr(assign->value.get()))
                ++count;
            if (pointerTarget && !assign->compoundOp.empty() &&
                assign->compoundOp != "+=" && assign->compoundOp != "-=" &&
                assign->compoundOp != "++" && assign->compoundOp != "--")
                ++count;
        } else if (auto* expression = llvm::dyn_cast<CExprStmt>(statement)) {
            count += countInvalidPointerOpsInExpr(
                expression->expr.get(), pointerVars, scalarVars);
        } else if (auto* result = llvm::dyn_cast<CReturnStmt>(statement)) {
            count += countInvalidPointerOpsInExpr(
                result->value.get(), pointerVars, scalarVars);
        } else if (auto* branch = llvm::dyn_cast<CIfStmt>(statement)) {
            count += countInvalidPointerOpsInExpr(
                branch->condition.get(), pointerVars, scalarVars);
            count += countInvalidPointerOperations(
                branch->thenBody, pointerVars, scalarVars);
            count += countInvalidPointerOperations(
                branch->elseBody, pointerVars, scalarVars);
        } else if (auto* loop = llvm::dyn_cast<CWhileStmt>(statement)) {
            count += countInvalidPointerOpsInExpr(
                loop->condition.get(), pointerVars, scalarVars);
            count += countInvalidPointerOperations(
                loop->body, pointerVars, scalarVars);
        } else if (auto* loop = llvm::dyn_cast<CDoWhileStmt>(statement)) {
            count += countInvalidPointerOpsInExpr(
                loop->condition.get(), pointerVars, scalarVars);
            count += countInvalidPointerOperations(
                loop->body, pointerVars, scalarVars);
        } else if (auto* loop = llvm::dyn_cast<CForStmt>(statement)) {
            if (loop->init) {
                if (auto* assign = llvm::dyn_cast<CAssignStmt>(loop->init.get())) {
                    count += countInvalidPointerOpsInExpr(
                        assign->target.get(), pointerVars, scalarVars);
                    count += countInvalidPointerOpsInExpr(
                        assign->value.get(), pointerVars, scalarVars);
                }
            }
            count += countInvalidPointerOpsInExpr(
                loop->condition.get(), pointerVars, scalarVars);
            if (auto* assign = llvm::dyn_cast_or_null<CAssignStmt>(loop->step.get())) {
                count += countInvalidPointerOpsInExpr(
                    assign->target.get(), pointerVars, scalarVars);
                count += countInvalidPointerOpsInExpr(
                    assign->value.get(), pointerVars, scalarVars);
            }
            count += countInvalidPointerOperations(
                loop->body, pointerVars, scalarVars);
        } else if (auto* selection = llvm::dyn_cast<CSwitchStmt>(statement)) {
            count += countInvalidPointerOpsInExpr(
                selection->selector.get(), pointerVars, scalarVars);
            for (const auto& arm : selection->cases)
                count += countInvalidPointerOperations(
                    arm.body, pointerVars, scalarVars);
        } else if (auto* block = llvm::dyn_cast<CBlockStmt>(statement)) {
            count += countInvalidPointerOperations(
                block->stmts, pointerVars, scalarVars);
        }
    }
    return count;
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

inline bool isLiteralNullPointer(const CExpr* expr) {
    if (!expr) return false;
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr))
        return isLiteralNullPointer(cast->operand.get());
    if (auto* address = llvm::dyn_cast<CAddrLitExpr>(expr))
        return address->addrValue == 0;
    if (auto* integer = llvm::dyn_cast<CIntLitExpr>(expr))
        return integer->value == 0;
    return false;
}

inline bool isLiteralIntegerOffset(const CExpr* expr) {
    if (!expr) return false;
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr))
        return isLiteralIntegerOffset(cast->operand.get());
    return llvm::isa<CIntLitExpr>(expr) || llvm::isa<CAddrLitExpr>(expr);
}

// A GEP rooted at a missing State/base expression is emitted as
// `(void*)0 + constant`. It is not a nullable pointer value: dereferencing it
// still accesses an unproven low address and must retain the same honesty cap
// as a direct null dereference.
inline bool isNullDerivedPointer(
        const CExpr* expr,
        const std::unordered_set<std::string>& zeroLocals = {}) {
    if (isLiteralNullPointer(expr)) return true;
    if (!expr) return false;
    if (auto* variable = llvm::dyn_cast<CVarRefExpr>(expr))
        return zeroLocals.count(variable->varName) != 0;
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr))
        return isNullDerivedPointer(cast->operand.get(), zeroLocals);
    auto* binary = llvm::dyn_cast<CBinaryExpr>(expr);
    if (!binary || (binary->op != BinaryOp::Add &&
                    binary->op != BinaryOp::Sub))
        return false;
    if (isNullDerivedPointer(binary->lhs.get(), zeroLocals) &&
        isLiteralIntegerOffset(binary->rhs.get()))
        return true;
    return binary->op == BinaryOp::Add &&
           isLiteralIntegerOffset(binary->lhs.get()) &&
           isNullDerivedPointer(binary->rhs.get(), zeroLocals);
}

inline int countLiteralNullAccessesInExpr(
        const CExpr* expr,
        const std::unordered_set<std::string>& zeroLocals = {}) {
    if (!expr) return 0;
    if (auto* unary = llvm::dyn_cast<CUnaryExpr>(expr)) {
        int count = unary->op == UnaryOp::Deref &&
                    isNullDerivedPointer(unary->operand.get(), zeroLocals) ? 1 : 0;
        return count + countLiteralNullAccessesInExpr(
            unary->operand.get(), zeroLocals);
    }
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr))
        return countLiteralNullAccessesInExpr(cast->operand.get(), zeroLocals);
    if (auto* binary = llvm::dyn_cast<CBinaryExpr>(expr))
        return countLiteralNullAccessesInExpr(binary->lhs.get(), zeroLocals) +
               countLiteralNullAccessesInExpr(binary->rhs.get(), zeroLocals);
    if (auto* ternary = llvm::dyn_cast<CTernaryExpr>(expr))
        return countLiteralNullAccessesInExpr(ternary->cond.get(), zeroLocals) +
               countLiteralNullAccessesInExpr(ternary->trueVal.get(), zeroLocals) +
               countLiteralNullAccessesInExpr(ternary->falseVal.get(), zeroLocals);
    if (auto* subscript = llvm::dyn_cast<CSubscriptExpr>(expr)) {
        int count = isNullDerivedPointer(
            subscript->base.get(), zeroLocals) ? 1 : 0;
        return count + countLiteralNullAccessesInExpr(
                           subscript->base.get(), zeroLocals) +
                       countLiteralNullAccessesInExpr(
                           subscript->index.get(), zeroLocals);
    }
    if (auto* field = llvm::dyn_cast<CFieldAccessExpr>(expr)) {
        int count = isNullDerivedPointer(field->base.get(), zeroLocals) ? 1 : 0;
        return count + countLiteralNullAccessesInExpr(
                           field->base.get(), zeroLocals);
    }
    if (auto* call = llvm::dyn_cast<CCallExpr>(expr)) {
        int count = 0;
        for (const auto& argument : call->args)
            count += countLiteralNullAccessesInExpr(argument.get(), zeroLocals);
        return count;
    }
    return 0;
}

inline std::unordered_set<std::string> intersectZeroStates(
        const std::unordered_set<std::string>& lhs,
        const std::unordered_set<std::string>& rhs) {
    std::unordered_set<std::string> result;
    for (const auto& name : lhs)
        if (rhs.count(name)) result.insert(name);
    return result;
}

inline bool isDefinitelyZeroValue(
        const CExpr* expr,
        const std::unordered_set<std::string>& zeroLocals) {
    if (!expr) return false;
    if (isLiteralNullPointer(expr)) return true;
    if (auto* cast = llvm::dyn_cast<CCastExpr>(expr))
        return isDefinitelyZeroValue(cast->operand.get(), zeroLocals);
    if (auto* variable = llvm::dyn_cast<CVarRefExpr>(expr))
        return zeroLocals.count(variable->varName) != 0;
    return false;
}

inline int countOrderedNullAccessesInStmt(
        const CStmt* statement,
        std::unordered_set<std::string>& zeroLocals);

inline int countOrderedNullAccesses(
        const std::vector<StmtPtr>& body,
        std::unordered_set<std::string>& zeroLocals) {
    int count = 0;
    for (const auto& statementPtr : body) {
        count += countOrderedNullAccessesInStmt(statementPtr.get(), zeroLocals);
    }
    return count;
}

inline int countOrderedNullAccessesInStmt(
        const CStmt* statement,
        std::unordered_set<std::string>& zeroLocals) {
    if (!statement) return 0;
    int count = 0;
    if (auto* assign = llvm::dyn_cast<CAssignStmt>(statement)) {
        count += countLiteralNullAccessesInExpr(assign->target.get(), zeroLocals);
        count += countLiteralNullAccessesInExpr(assign->value.get(), zeroLocals);
        if (const auto name = plainVarName(assign->target.get()); !name.empty()) {
            if (assign->compoundOp.empty() &&
                isDefinitelyZeroValue(assign->value.get(), zeroLocals))
                zeroLocals.insert(name);
            else
                zeroLocals.erase(name);
        }
        return count;
    }
    if (auto* expression = llvm::dyn_cast<CExprStmt>(statement))
        return countLiteralNullAccessesInExpr(expression->expr.get(), zeroLocals);
    if (auto* result = llvm::dyn_cast<CReturnStmt>(statement))
        return countLiteralNullAccessesInExpr(result->value.get(), zeroLocals);
    if (auto* branch = llvm::dyn_cast<CIfStmt>(statement)) {
        count += countLiteralNullAccessesInExpr(branch->condition.get(), zeroLocals);
        auto thenState = zeroLocals;
        auto elseState = zeroLocals;
        count += countOrderedNullAccesses(branch->thenBody, thenState);
        count += countOrderedNullAccesses(branch->elseBody, elseState);
        zeroLocals = intersectZeroStates(thenState, elseState);
        return count;
    }
    if (auto* loop = llvm::dyn_cast<CWhileStmt>(statement)) {
        count += countLiteralNullAccessesInExpr(loop->condition.get(), zeroLocals);
        auto bodyState = zeroLocals;
        count += countOrderedNullAccesses(loop->body, bodyState);
        zeroLocals = intersectZeroStates(zeroLocals, bodyState);
        return count;
    }
    if (auto* loop = llvm::dyn_cast<CDoWhileStmt>(statement)) {
        auto bodyState = zeroLocals;
        count += countOrderedNullAccesses(loop->body, bodyState);
        count += countLiteralNullAccessesInExpr(loop->condition.get(), bodyState);
        zeroLocals = intersectZeroStates(zeroLocals, bodyState);
        return count;
    }
    if (auto* loop = llvm::dyn_cast<CForStmt>(statement)) {
        if (loop->init)
            count += countOrderedNullAccessesInStmt(loop->init.get(), zeroLocals);
        count += countLiteralNullAccessesInExpr(loop->condition.get(), zeroLocals);
        auto bodyState = zeroLocals;
        count += countOrderedNullAccesses(loop->body, bodyState);
        if (loop->step)
            count += countOrderedNullAccessesInStmt(loop->step.get(), bodyState);
        zeroLocals = intersectZeroStates(zeroLocals, bodyState);
        return count;
    }
    if (auto* selection = llvm::dyn_cast<CSwitchStmt>(statement)) {
        count += countLiteralNullAccessesInExpr(selection->selector.get(), zeroLocals);
        auto joinedState = zeroLocals;
        for (const auto& arm : selection->cases) {
            auto armState = zeroLocals;
            count += countOrderedNullAccesses(arm.body, armState);
            joinedState = intersectZeroStates(joinedState, armState);
        }
        zeroLocals = std::move(joinedState);
        return count;
    }
    if (auto* block = llvm::dyn_cast<CBlockStmt>(statement))
        return countOrderedNullAccesses(block->stmts, zeroLocals);
    return count;
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
        std::unordered_set<std::string> readCandidates;
        std::unordered_set<std::string> initiallyAssigned;

        for (const auto& p : func.params)
            initiallyAssigned.insert(p.name);
        for (const auto& lv : func.localVars) {
            if (lv.initExpr)
                initiallyAssigned.insert(lv.varName);
            else {
                candidates.insert(lv.varName);
                if (lv.type && (lv.type->kind == TypeKind::Int ||
                     lv.type->kind == TypeKind::Bool || lv.type->kind == TypeKind::Float ||
                     lv.type->kind == TypeKind::Pointer || lv.type->kind == TypeKind::FuncPtr) &&
                     lv.storage != StorageKind::Global && lv.storage != StorageKind::Parameter)
                    readCandidates.insert(lv.varName);
            }
        }

        auto flow = detail::analyzeDefiniteAssignments(
            func.body, initiallyAssigned, std::move(initiallyAssigned),
            candidates, readCandidates,
            addressTaken, zeroLocals);
        if (flow.uninitReturn) {
            info.uninitReturn = true;
            info.uninitVarName = flow.uninitVar;
        }
        if (!flow.uninitReadVar.empty()) {
            info.uninitRead = true;
            info.uninitReadVarName = flow.uninitReadVar;
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

    // (5) FIX-111: a subscript whose declared base is not a pointer or array.
    //     The declared type is authoritative because use-site VarRef types can
    //     drift during SSA destruction.
    {
        std::unordered_set<std::string> scalarVars;
        auto recordScalar = [&](const std::string& name, const CTypePtr& type) {
            if (!type || type->kind == TypeKind::Unknown ||
                type->kind == TypeKind::Pointer || type->kind == TypeKind::Array)
                return;
            scalarVars.insert(name);
        };
        for (const auto& lv : func.localVars)
            recordScalar(lv.varName, lv.type);
        for (const auto& p : func.params)
            recordScalar(p.name, p.type);
        if (detail::scanForScalarSubscript(func.body, scalarVars))
            info.scalarSubscript = true;
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

    // (10) A provably-zero dereference is not the same as a nullable pointer
    // value. This includes a local that is initialized to zero and never
    // reassigned before it is used as an address base.
    std::unordered_set<std::string> orderedZeroLocals;
    const bool canTrackOrderedZeroLocals =
        detail::supportsDefiniteAssignmentScan(func.body);
    for (const auto& local : func.localVars) {
        info.literalNullAccessCount +=
            detail::countLiteralNullAccessesInExpr(
                local.initExpr.get(), orderedZeroLocals);
        if (canTrackOrderedZeroLocals && local.initExpr &&
            !addressTaken.count(local.varName) &&
            detail::isDefinitelyZeroValue(
                local.initExpr.get(), orderedZeroLocals))
            orderedZeroLocals.insert(local.varName);
    }
    info.literalNullAccessCount += detail::countOrderedNullAccesses(
        func.body, orderedZeroLocals);
    info.literalNullAccess = info.literalNullAccessCount > 0;

    // (11) The final C contains an undefined constant shift such as `x >> 64`
    // for a 64-bit operand. Keep the code visible, but never call it High.
    info.invalidShiftCountOccurrences =
        detail::countInvalidShiftCounts(func.body);
    for (const auto& local : func.localVars)
        info.invalidShiftCountOccurrences +=
            detail::countInvalidShiftCountsInExpr(local.initExpr.get());
    info.invalidShiftCount = info.invalidShiftCountOccurrences > 0;

    // (12) Pointer values participating in multiplication/bitwise/shift
    // arithmetic, or receiving a proven non-zero scalar without a cast, make
    // the emitted C ill-typed. Pointer addition/subtraction and null assignment
    // remain valid and are explicit negative controls.
    {
        std::unordered_set<std::string> pointerVars;
        std::unordered_set<std::string> scalarVars;
        auto recordType = [&](const std::string& name, const CTypePtr& type) {
            if (!type) return;
            if (type->kind == TypeKind::Pointer ||
                type->kind == TypeKind::Array ||
                type->kind == TypeKind::FuncPtr)
                pointerVars.insert(name);
            else if (type->kind == TypeKind::Bool ||
                     type->kind == TypeKind::Int ||
                     type->kind == TypeKind::Float)
                scalarVars.insert(name);
        };
        for (const auto& local : func.localVars)
            recordType(local.varName, local.type);
        for (const auto& param : func.params)
            recordType(param.name, param.type);
        info.invalidPointerOperationCount =
            detail::countInvalidPointerOperations(
                func.body, pointerVars, scalarVars);
        info.invalidPointerOperation =
            info.invalidPointerOperationCount > 0;
    }

    return info;
}

} // namespace helix::cast
