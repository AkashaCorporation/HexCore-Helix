#pragma once

#include "helix/cast/CAstNode.h"
#include "helix/cast/CExpr.h"

#include <cstdint>
#include <memory>
#include <string>
#include <vector>

namespace helix::cast {

// ── Base statement node ─────────────────────────────────────────────────────

/// Base class for all C statement nodes.
class CStmt : public CAstNode {
public:
    explicit CStmt(NodeKind kind, uint64_t address = 0)
        : CAstNode(kind, address) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() >= NodeKind::AssignStmt &&
               n->getKind() <= NodeKind::AsmStmt;
    }
};

// ── Concrete statement nodes ────────────────────────────────────────────────

/// Assignment: target = value, target += value, or target++/target--
class CAssignStmt : public CStmt {
public:
    ExprPtr target;
    ExprPtr value;
    std::string compoundOp; // empty for plain "=", "+=", "++", "--", etc.

    CAssignStmt(ExprPtr target, ExprPtr value, std::string compoundOp = "",
                uint64_t address = 0)
        : CStmt(NodeKind::AssignStmt, address),
          target(std::move(target)), value(std::move(value)),
          compoundOp(std::move(compoundOp)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::AssignStmt;
    }
};

/// Expression statement: expr;
class CExprStmt : public CStmt {
public:
    ExprPtr expr;

    explicit CExprStmt(ExprPtr expr, uint64_t address = 0)
        : CStmt(NodeKind::ExprStmt, address), expr(std::move(expr)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::ExprStmt;
    }
};

/// If statement: if (cond) { then } else { else }
class CIfStmt : public CStmt {
public:
    ExprPtr condition;
    std::vector<StmtPtr> thenBody;
    std::vector<StmtPtr> elseBody;

    CIfStmt(ExprPtr condition, std::vector<StmtPtr> thenBody,
            std::vector<StmtPtr> elseBody = {}, uint64_t address = 0)
        : CStmt(NodeKind::IfStmt, address),
          condition(std::move(condition)), thenBody(std::move(thenBody)),
          elseBody(std::move(elseBody)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::IfStmt;
    }
};

/// While loop: while (cond) { body }
class CWhileStmt : public CStmt {
public:
    ExprPtr condition;
    std::vector<StmtPtr> body;

    CWhileStmt(ExprPtr condition, std::vector<StmtPtr> body,
               uint64_t address = 0)
        : CStmt(NodeKind::WhileStmt, address),
          condition(std::move(condition)), body(std::move(body)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::WhileStmt;
    }
};

/// Do-while loop: do { body } while (cond);
class CDoWhileStmt : public CStmt {
public:
    std::vector<StmtPtr> body;
    ExprPtr condition;

    CDoWhileStmt(std::vector<StmtPtr> body, ExprPtr condition,
                 uint64_t address = 0)
        : CStmt(NodeKind::DoWhileStmt, address),
          body(std::move(body)), condition(std::move(condition)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::DoWhileStmt;
    }
};

/// For loop: for (init; cond; step) { body }
class CForStmt : public CStmt {
public:
    StmtPtr init;
    ExprPtr condition;
    StmtPtr step;
    std::vector<StmtPtr> body;

    CForStmt(StmtPtr init, ExprPtr condition, StmtPtr step,
             std::vector<StmtPtr> body, uint64_t address = 0)
        : CStmt(NodeKind::ForStmt, address),
          init(std::move(init)), condition(std::move(condition)),
          step(std::move(step)), body(std::move(body)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::ForStmt;
    }
};

/// Switch statement: switch (selector) { cases }
class CSwitchStmt : public CStmt {
public:
    struct SwitchCase {
        int64_t value = 0;
        std::vector<StmtPtr> body;
        bool isDefault = false;
    };

    ExprPtr selector;
    std::vector<SwitchCase> cases;

    CSwitchStmt(ExprPtr selector, std::vector<SwitchCase> cases,
                uint64_t address = 0)
        : CStmt(NodeKind::SwitchStmt, address),
          selector(std::move(selector)), cases(std::move(cases)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::SwitchStmt;
    }
};

/// Return statement: return value;  or  return;
class CReturnStmt : public CStmt {
public:
    ExprPtr value; // nullptr for bare "return;"

    explicit CReturnStmt(ExprPtr value = nullptr, uint64_t address = 0)
        : CStmt(NodeKind::ReturnStmt, address), value(std::move(value)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::ReturnStmt;
    }
};

/// Goto statement: goto label;
class CGotoStmt : public CStmt {
public:
    std::string label;

    explicit CGotoStmt(std::string label, uint64_t address = 0)
        : CStmt(NodeKind::GotoStmt, address), label(std::move(label)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::GotoStmt;
    }
};

/// Label statement: label:
class CLabelStmt : public CStmt {
public:
    std::string name;

    explicit CLabelStmt(std::string name, uint64_t address = 0)
        : CStmt(NodeKind::LabelStmt, address), name(std::move(name)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::LabelStmt;
    }
};

/// Break statement: break;
class CBreakStmt : public CStmt {
public:
    explicit CBreakStmt(uint64_t address = 0)
        : CStmt(NodeKind::BreakStmt, address) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::BreakStmt;
    }
};

/// Continue statement: continue;
class CContinueStmt : public CStmt {
public:
    explicit CContinueStmt(uint64_t address = 0)
        : CStmt(NodeKind::ContinueStmt, address) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::ContinueStmt;
    }
};

/// Block statement: { stmts }
class CBlockStmt : public CStmt {
public:
    std::vector<StmtPtr> stmts;

    explicit CBlockStmt(std::vector<StmtPtr> stmts = {}, uint64_t address = 0)
        : CStmt(NodeKind::BlockStmt, address), stmts(std::move(stmts)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::BlockStmt;
    }
};

/// Comment: /* text */
class CCommentStmt : public CStmt {
public:
    std::string text;

    explicit CCommentStmt(std::string text, uint64_t address = 0)
        : CStmt(NodeKind::CommentStmt, address), text(std::move(text)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::CommentStmt;
    }
};

/// Inline assembly: __asm { text }
class CAsmStmt : public CStmt {
public:
    std::string text;

    explicit CAsmStmt(std::string text, uint64_t address = 0)
        : CStmt(NodeKind::AsmStmt, address), text(std::move(text)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::AsmStmt;
    }
};

} // namespace helix::cast
