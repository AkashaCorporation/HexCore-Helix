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

#include <algorithm>
#include <cassert>
#include <cctype>
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
    eliminateNullPtrStores(func);         // BUG 3 mitigation: *(type)(void*)0 = ... → remove
    eliminateDeadStores(func);
    propagateCopies(func);
    canonicalizeXorPatterns(func);        // x ^ -1 → !x, x == (y ^ -1) → x != y
    recoverStructFieldAccess(func);       // *(ptr + N) → ptr->field_0xN
    simplifyExpressions(func);
    synthesizeCompoundAssign(func);
    eliminateConstantBranches(func);      // BUG 2: if(0){...}else{B} → B
    removeEmptyIfStatements(func);        // MINSS/MAXSS: remove dead empty if-stmts
    cleanupFloatZeros(func);              // (int64_t)(void*)0 → 0.0f for float vars
    collapseMinMaxPatterns(func);         // consecutive if(a cmp b){x=sel} → x = min/max
    foldRedundantReturnAfterElse(func);    // else{return X}; return X → remove dup
    invertEmptyIfThen(func);               // if(c){} else{B} → if(!c){B}
    removeDeadCodeAfterReturn(func);      // strip unreachable stmts after return
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
void CAstOptimizer::dseStmtList(std::vector<StmtPtr>& stmts) {
    // live_set: variables that have been read "after" the current position
    // (since we scan backwards).
    std::unordered_set<std::string> live;

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

            // If target is not in the live set, the store is dead.
            if (live.find(tgt) == live.end()) {
                toRemove.insert(i);
                // Do NOT add value reads — they're also dead.
            } else {
                // Target is consumed; add value reads to live set.
                live.erase(tgt);
                collectVarRefs(a.value.get(), live);
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
                        collectVarRefs(na.target.get(), nested);
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
        case NodeKind::WhileStmt:
            dseStmtList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            dseStmtList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            dseStmtList(static_cast<CForStmt&>(*sp).body);
            break;
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

static unsigned exprDepth(const CExpr* e) {
    if (!e) return 0;
    switch (e->getKind()) {
    case NodeKind::BinaryExpr: {
        const auto& b = static_cast<const CBinaryExpr&>(*e);
        return 1 + std::max(exprDepth(b.lhs.get()), exprDepth(b.rhs.get()));
    }
    case NodeKind::UnaryExpr:
        return 1 + exprDepth(
                       static_cast<const CUnaryExpr*>(e)->operand.get());
    case NodeKind::CastExpr:
        return 1 + exprDepth(
                       static_cast<const CCastExpr*>(e)->operand.get());
    case NodeKind::TernaryExpr: {
        const auto& t = static_cast<const CTernaryExpr&>(*e);
        return 1 + std::max({exprDepth(t.cond.get()),
                              exprDepth(t.trueVal.get()),
                              exprDepth(t.falseVal.get())});
    }
    case NodeKind::SubscriptExpr: {
        const auto& s = static_cast<const CSubscriptExpr&>(*e);
        return 1 + std::max(exprDepth(s.base.get()),
                            exprDepth(s.index.get()));
    }
    case NodeKind::FieldAccessExpr:
        return 1 + exprDepth(
                       static_cast<const CFieldAccessExpr*>(e)->base.get());
    default:
        return 1;
    }
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
        return std::make_unique<CAddrLitExpr>(e.addrValue, e.type,
                                              e.getAddress());
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
    std::unordered_set<std::string>& inlined) {

    if (!expr) return nullptr;

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
                inlined.insert(v.varName);
                return cloneExpr(dit->second);
            }
        }
        return expr;
    }

    // Recurse into sub-expressions.
    switch (expr->getKind()) {
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        b.lhs = substituteVarRefs(std::move(b.lhs), defs, refCounts, inlined);
        b.rhs = substituteVarRefs(std::move(b.rhs), defs, refCounts, inlined);
        return expr;
    }
    case NodeKind::UnaryExpr: {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        u.operand =
            substituteVarRefs(std::move(u.operand), defs, refCounts, inlined);
        return expr;
    }
    case NodeKind::CastExpr: {
        auto& c = static_cast<CCastExpr&>(*expr);
        c.operand =
            substituteVarRefs(std::move(c.operand), defs, refCounts, inlined);
        return expr;
    }
    case NodeKind::CallExpr: {
        auto& c = static_cast<CCallExpr&>(*expr);
        for (auto& a : c.args)
            a = substituteVarRefs(std::move(a), defs, refCounts, inlined);
        return expr;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*expr);
        t.cond =
            substituteVarRefs(std::move(t.cond), defs, refCounts, inlined);
        t.trueVal =
            substituteVarRefs(std::move(t.trueVal), defs, refCounts, inlined);
        t.falseVal = substituteVarRefs(std::move(t.falseVal), defs, refCounts,
                                       inlined);
        return expr;
    }
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*expr);
        s.base =
            substituteVarRefs(std::move(s.base), defs, refCounts, inlined);
        s.index =
            substituteVarRefs(std::move(s.index), defs, refCounts, inlined);
        return expr;
    }
    case NodeKind::FieldAccessExpr: {
        auto& f = static_cast<CFieldAccessExpr&>(*expr);
        f.base =
            substituteVarRefs(std::move(f.base), defs, refCounts, inlined);
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

ExprPtr CAstOptimizer::simplifyExpr(ExprPtr expr) {
    if (!expr) return nullptr;

    // Bottom-up: simplify children first.
    switch (expr->getKind()) {
    case NodeKind::BinaryExpr: {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        b.lhs = simplifyExpr(std::move(b.lhs));
        b.rhs = simplifyExpr(std::move(b.rhs));
        break;
    }
    case NodeKind::UnaryExpr: {
        auto& u = static_cast<CUnaryExpr&>(*expr);
        u.operand = simplifyExpr(std::move(u.operand));
        break;
    }
    case NodeKind::CastExpr: {
        auto& c = static_cast<CCastExpr&>(*expr);
        c.operand = simplifyExpr(std::move(c.operand));
        break;
    }
    case NodeKind::CallExpr: {
        auto& c = static_cast<CCallExpr&>(*expr);
        for (auto& a : c.args)
            a = simplifyExpr(std::move(a));
        break;
    }
    case NodeKind::TernaryExpr: {
        auto& t = static_cast<CTernaryExpr&>(*expr);
        t.cond     = simplifyExpr(std::move(t.cond));
        t.trueVal  = simplifyExpr(std::move(t.trueVal));
        t.falseVal = simplifyExpr(std::move(t.falseVal));
        break;
    }
    case NodeKind::SubscriptExpr: {
        auto& s = static_cast<CSubscriptExpr&>(*expr);
        s.base  = simplifyExpr(std::move(s.base));
        s.index = simplifyExpr(std::move(s.index));
        break;
    }
    case NodeKind::FieldAccessExpr: {
        auto& f = static_cast<CFieldAccessExpr&>(*expr);
        f.base = simplifyExpr(std::move(f.base));
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

    // ── Binary patterns ───────────────────────────────────────────────────────
    if (expr->getKind() == NodeKind::BinaryExpr) {
        auto& b = static_cast<CBinaryExpr&>(*expr);
        if (!b.lhs || !b.rhs) return expr;

        auto lhsType = b.lhs->type ? b.lhs->type : CType::int32();

        // x + 0 → x
        if (b.op == BinaryOp::Add && isIntLit(b.rhs.get(), 0))
            return std::move(b.lhs);

        // x - 0 → x
        if (b.op == BinaryOp::Sub && isIntLit(b.rhs.get(), 0))
            return std::move(b.lhs);

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

void CAstOptimizer::simplifyExprInStmt(ExprPtr& slot) {
    if (slot)
        slot = simplifyExpr(std::move(slot));
}

void CAstOptimizer::simplifyStmtList(std::vector<StmtPtr>& stmts) {
    for (auto& sp : stmts) {
        if (!sp) continue;
        switch (sp->getKind()) {
        case NodeKind::AssignStmt: {
            auto& a = static_cast<CAssignStmt&>(*sp);
            simplifyExprInStmt(a.target);
            simplifyExprInStmt(a.value);
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

    // Now truncate after first unconditional terminator at this scope level.
    for (size_t i = 0; i < stmts.size(); ++i) {
        if (!stmts[i]) continue;
        auto kind = stmts[i]->getKind();
        if (kind == NodeKind::ReturnStmt ||
            kind == NodeKind::BreakStmt ||
            kind == NodeKind::ContinueStmt ||
            kind == NodeKind::GotoStmt) {
            // Everything after this is unreachable — erase.
            if (i + 1 < stmts.size()) {
                stmts.erase(stmts.begin() + static_cast<ptrdiff_t>(i + 1),
                            stmts.end());
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
                    // Build field name: field_0xN
                    char fieldName[32];
                    std::snprintf(fieldName, sizeof(fieldName),
                                  "field_0x%X",
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
                                  "field_0x%X",
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
        case NodeKind::WhileStmt:
            eliminateConstBranchesInList(static_cast<CWhileStmt&>(*sp).body);
            break;
        case NodeKind::DoWhileStmt:
            eliminateConstBranchesInList(static_cast<CDoWhileStmt&>(*sp).body);
            break;
        case NodeKind::ForStmt:
            eliminateConstBranchesInList(static_cast<CForStmt&>(*sp).body);
            break;
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
