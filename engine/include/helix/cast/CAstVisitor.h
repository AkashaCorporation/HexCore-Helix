#pragma once

#include "helix/cast/CAstNode.h"
#include "helix/cast/CExpr.h"
#include "helix/cast/CStmt.h"
#include "helix/cast/CDecl.h"

namespace helix::cast {

/// CRTP visitor for the C AST.
///
/// Derived classes override specific visitXxx methods; unoverridden methods
/// return a default-constructed result. The dispatch methods (visitExpr,
/// visitStmt) switch on NodeKind and call the appropriate typed visit method
/// via static_cast<Derived*>(this)->visitXxx(...).
///
/// Usage:
///   class MyVisitor : public CAstVisitor<MyVisitor, std::string, void> {
///   public:
///       std::string visitIntLitExpr(const CIntLitExpr& e) { ... }
///       void visitIfStmt(const CIfStmt& s) { ... }
///   };
template <typename Derived, typename ExprResult = void, typename StmtResult = void>
class CAstVisitor {
public:
    /// Dispatch an expression to the appropriate typed visit method.
    ExprResult visitExpr(const CExpr& expr) {
        switch (expr.getKind()) {
        case NodeKind::IntLitExpr:
            return derived().visitIntLitExpr(static_cast<const CIntLitExpr&>(expr));
        case NodeKind::FloatLitExpr:
            return derived().visitFloatLitExpr(static_cast<const CFloatLitExpr&>(expr));
        case NodeKind::StringLitExpr:
            return derived().visitStringLitExpr(static_cast<const CStringLitExpr&>(expr));
        case NodeKind::AddrLitExpr:
            return derived().visitAddrLitExpr(static_cast<const CAddrLitExpr&>(expr));
        case NodeKind::VarRefExpr:
            return derived().visitVarRefExpr(static_cast<const CVarRefExpr&>(expr));
        case NodeKind::BinaryExpr:
            return derived().visitBinaryExpr(static_cast<const CBinaryExpr&>(expr));
        case NodeKind::UnaryExpr:
            return derived().visitUnaryExpr(static_cast<const CUnaryExpr&>(expr));
        case NodeKind::CastExpr:
            return derived().visitCastExpr(static_cast<const CCastExpr&>(expr));
        case NodeKind::CallExpr:
            return derived().visitCallExpr(static_cast<const CCallExpr&>(expr));
        case NodeKind::TernaryExpr:
            return derived().visitTernaryExpr(static_cast<const CTernaryExpr&>(expr));
        case NodeKind::SubscriptExpr:
            return derived().visitSubscriptExpr(static_cast<const CSubscriptExpr&>(expr));
        case NodeKind::FieldAccessExpr:
            return derived().visitFieldAccessExpr(static_cast<const CFieldAccessExpr&>(expr));
        default:
            return ExprResult();
        }
    }

    /// Dispatch a statement to the appropriate typed visit method.
    StmtResult visitStmt(const CStmt& stmt) {
        switch (stmt.getKind()) {
        case NodeKind::AssignStmt:
            return derived().visitAssignStmt(static_cast<const CAssignStmt&>(stmt));
        case NodeKind::ExprStmt:
            return derived().visitExprStmt(static_cast<const CExprStmt&>(stmt));
        case NodeKind::IfStmt:
            return derived().visitIfStmt(static_cast<const CIfStmt&>(stmt));
        case NodeKind::WhileStmt:
            return derived().visitWhileStmt(static_cast<const CWhileStmt&>(stmt));
        case NodeKind::DoWhileStmt:
            return derived().visitDoWhileStmt(static_cast<const CDoWhileStmt&>(stmt));
        case NodeKind::ForStmt:
            return derived().visitForStmt(static_cast<const CForStmt&>(stmt));
        case NodeKind::SwitchStmt:
            return derived().visitSwitchStmt(static_cast<const CSwitchStmt&>(stmt));
        case NodeKind::ReturnStmt:
            return derived().visitReturnStmt(static_cast<const CReturnStmt&>(stmt));
        case NodeKind::GotoStmt:
            return derived().visitGotoStmt(static_cast<const CGotoStmt&>(stmt));
        case NodeKind::LabelStmt:
            return derived().visitLabelStmt(static_cast<const CLabelStmt&>(stmt));
        case NodeKind::BreakStmt:
            return derived().visitBreakStmt(static_cast<const CBreakStmt&>(stmt));
        case NodeKind::ContinueStmt:
            return derived().visitContinueStmt(static_cast<const CContinueStmt&>(stmt));
        case NodeKind::BlockStmt:
            return derived().visitBlockStmt(static_cast<const CBlockStmt&>(stmt));
        case NodeKind::CommentStmt:
            return derived().visitCommentStmt(static_cast<const CCommentStmt&>(stmt));
        case NodeKind::AsmStmt:
            return derived().visitAsmStmt(static_cast<const CAsmStmt&>(stmt));
        default:
            return StmtResult();
        }
    }

    // ── Default expression visit methods (override in Derived) ──────────

    ExprResult visitIntLitExpr(const CIntLitExpr&) { return ExprResult(); }
    ExprResult visitFloatLitExpr(const CFloatLitExpr&) { return ExprResult(); }
    ExprResult visitStringLitExpr(const CStringLitExpr&) { return ExprResult(); }
    ExprResult visitAddrLitExpr(const CAddrLitExpr&) { return ExprResult(); }
    ExprResult visitVarRefExpr(const CVarRefExpr&) { return ExprResult(); }
    ExprResult visitBinaryExpr(const CBinaryExpr&) { return ExprResult(); }
    ExprResult visitUnaryExpr(const CUnaryExpr&) { return ExprResult(); }
    ExprResult visitCastExpr(const CCastExpr&) { return ExprResult(); }
    ExprResult visitCallExpr(const CCallExpr&) { return ExprResult(); }
    ExprResult visitTernaryExpr(const CTernaryExpr&) { return ExprResult(); }
    ExprResult visitSubscriptExpr(const CSubscriptExpr&) { return ExprResult(); }
    ExprResult visitFieldAccessExpr(const CFieldAccessExpr&) { return ExprResult(); }

    // ── Default statement visit methods (override in Derived) ───────────

    StmtResult visitAssignStmt(const CAssignStmt&) { return StmtResult(); }
    StmtResult visitExprStmt(const CExprStmt&) { return StmtResult(); }
    StmtResult visitIfStmt(const CIfStmt&) { return StmtResult(); }
    StmtResult visitWhileStmt(const CWhileStmt&) { return StmtResult(); }
    StmtResult visitDoWhileStmt(const CDoWhileStmt&) { return StmtResult(); }
    StmtResult visitForStmt(const CForStmt&) { return StmtResult(); }
    StmtResult visitSwitchStmt(const CSwitchStmt&) { return StmtResult(); }
    StmtResult visitReturnStmt(const CReturnStmt&) { return StmtResult(); }
    StmtResult visitGotoStmt(const CGotoStmt&) { return StmtResult(); }
    StmtResult visitLabelStmt(const CLabelStmt&) { return StmtResult(); }
    StmtResult visitBreakStmt(const CBreakStmt&) { return StmtResult(); }
    StmtResult visitContinueStmt(const CContinueStmt&) { return StmtResult(); }
    StmtResult visitBlockStmt(const CBlockStmt&) { return StmtResult(); }
    StmtResult visitCommentStmt(const CCommentStmt&) { return StmtResult(); }
    StmtResult visitAsmStmt(const CAsmStmt&) { return StmtResult(); }

protected:
    ~CAstVisitor() = default;

private:
    Derived& derived() { return static_cast<Derived&>(*this); }
    const Derived& derived() const { return static_cast<const Derived&>(*this); }
};

} // namespace helix::cast
