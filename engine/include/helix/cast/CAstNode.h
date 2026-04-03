#pragma once

#include <cstdint>
#include <memory>
#include <string>

namespace helix::cast {

// Forward declarations
class CExpr;
class CStmt;
class CDecl;

/// All concrete node types in the C AST.
enum class NodeKind : uint8_t {
    // Expressions (12)
    IntLitExpr,
    FloatLitExpr,
    StringLitExpr,
    AddrLitExpr,
    VarRefExpr,
    BinaryExpr,
    UnaryExpr,
    CastExpr,
    CallExpr,
    TernaryExpr,
    SubscriptExpr,
    FieldAccessExpr,

    // Statements (15)
    AssignStmt,
    ExprStmt,
    IfStmt,
    WhileStmt,
    DoWhileStmt,
    ForStmt,
    SwitchStmt,
    ReturnStmt,
    GotoStmt,
    LabelStmt,
    BreakStmt,
    ContinueStmt,
    BlockStmt,
    CommentStmt,
    AsmStmt,

    // Declarations (4)
    VarDecl,
    ParamDecl,
    FuncDecl,
    StructDecl,
};

/// Base class for all C AST nodes.
class CAstNode {
public:
    explicit CAstNode(NodeKind kind, uint64_t address = 0)
        : kind_(kind), address_(address) {}

    virtual ~CAstNode() = default;

    CAstNode(const CAstNode&) = delete;
    CAstNode& operator=(const CAstNode&) = delete;
    CAstNode(CAstNode&&) = default;
    CAstNode& operator=(CAstNode&&) = default;

    NodeKind getKind() const { return kind_; }
    uint64_t getAddress() const { return address_; }
    void setAddress(uint64_t addr) { address_ = addr; }

private:
    NodeKind kind_;
    uint64_t address_;
};

// Smart pointer typedefs
using NodePtr = std::unique_ptr<CAstNode>;
using ExprPtr = std::unique_ptr<CExpr>;
using StmtPtr = std::unique_ptr<CStmt>;
using DeclPtr = std::unique_ptr<CDecl>;

} // namespace helix::cast
