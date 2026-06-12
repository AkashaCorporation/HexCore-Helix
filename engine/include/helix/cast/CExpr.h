#pragma once

#include "helix/cast/CAstNode.h"
#include "helix/cast/CType.h"

#include <cstdint>
#include <memory>
#include <string>
#include <vector>

namespace helix::cast {

// ── Binary and unary operator enums ─────────────────────────────────────────

enum class BinaryOp : uint8_t {
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    Shl,
    Shr,
    Sar,
    BitAnd,
    BitOr,
    BitXor,
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
    LogAnd,
    LogOr,
};

enum class UnaryOp : uint8_t {
    Neg,
    LogNot,
    BitNot,
    Deref,
    AddressOf,
};

// ── Base expression node ────────────────────────────────────────────────────

/// Base class for all C expression nodes.
class CExpr : public CAstNode {
public:
    CTypePtr type;

    CExpr(NodeKind kind, CTypePtr type, uint64_t address = 0)
        : CAstNode(kind, address), type(std::move(type)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() >= NodeKind::IntLitExpr &&
               n->getKind() <= NodeKind::FieldAccessExpr;
    }
};

// ── Concrete expression nodes ───────────────────────────────────────────────

/// Integer literal: 42, 0xFF, -1
class CIntLitExpr : public CExpr {
public:
    int64_t value;

    explicit CIntLitExpr(int64_t value, CTypePtr type = CType::int32(),
                         uint64_t address = 0)
        : CExpr(NodeKind::IntLitExpr, std::move(type), address), value(value) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::IntLitExpr;
    }
};

/// Floating-point literal: 3.14, 1.0f
class CFloatLitExpr : public CExpr {
public:
    double value;

    explicit CFloatLitExpr(double value, CTypePtr type = CType::doubleTy(),
                           uint64_t address = 0)
        : CExpr(NodeKind::FloatLitExpr, std::move(type), address), value(value) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::FloatLitExpr;
    }
};

/// String literal: "hello"
class CStringLitExpr : public CExpr {
public:
    std::string value;

    explicit CStringLitExpr(std::string value, uint64_t address = 0)
        : CExpr(NodeKind::StringLitExpr, CType::pointerTo(CType::int8()), address),
          value(std::move(value)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::StringLitExpr;
    }
};

/// Address literal: (void*)0x401000
class CAddrLitExpr : public CExpr {
public:
    uint64_t addrValue;

    // FIX-092 (D4 emit-time survival): true ONLY for the D1 code-address-leak
    // nodes the registry-resolution path (buildIntegerConstant (a)/(b),
    // resolveFoldedCodeLabel) produces -- a bare integer that equalled a known
    // code (block/function) start, surfaced as the honest `(void*)0xADDR`
    // code-pointer cast.  Generic dialect-sourced address literals
    // (high.addr_lit / mid.addr_const) leave this false: they are data/known
    // addresses, not a leaked code pointer, and must not trip the D4 cap.
    // The D4 damning cap re-derives the D1 category at confidence time by
    // checking whether any such tagged node SURVIVED into the final AST
    // (DSE/dead-store removal may have erased it).
    bool isCodeAddrLeak = false;

    explicit CAddrLitExpr(uint64_t addrValue, CTypePtr type = CType::voidPtr(),
                          uint64_t address = 0)
        : CExpr(NodeKind::AddrLitExpr, std::move(type), address),
          addrValue(addrValue) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::AddrLitExpr;
    }
};

/// Variable reference: x, var_42
class CVarRefExpr : public CExpr {
public:
    uint32_t varId;
    std::string varName;

    CVarRefExpr(uint32_t varId, std::string varName, CTypePtr type,
                uint64_t address = 0)
        : CExpr(NodeKind::VarRefExpr, std::move(type), address),
          varId(varId), varName(std::move(varName)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::VarRefExpr;
    }
};

/// Binary expression: lhs op rhs
class CBinaryExpr : public CExpr {
public:
    BinaryOp op;
    ExprPtr lhs;
    ExprPtr rhs;

    CBinaryExpr(BinaryOp op, ExprPtr lhs, ExprPtr rhs, CTypePtr type,
                uint64_t address = 0)
        : CExpr(NodeKind::BinaryExpr, std::move(type), address),
          op(op), lhs(std::move(lhs)), rhs(std::move(rhs)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::BinaryExpr;
    }
};

/// Unary expression: op operand
class CUnaryExpr : public CExpr {
public:
    UnaryOp op;
    ExprPtr operand;

    CUnaryExpr(UnaryOp op, ExprPtr operand, CTypePtr type,
               uint64_t address = 0)
        : CExpr(NodeKind::UnaryExpr, std::move(type), address),
          op(op), operand(std::move(operand)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::UnaryExpr;
    }
};

/// Cast expression: (type)operand
class CCastExpr : public CExpr {
public:
    CTypePtr targetType;
    ExprPtr operand;

    CCastExpr(CTypePtr targetType, ExprPtr operand, uint64_t address = 0)
        : CExpr(NodeKind::CastExpr, targetType, address),
          targetType(std::move(targetType)), operand(std::move(operand)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::CastExpr;
    }
};

/// Function call: target(args...)
class CCallExpr : public CExpr {
public:
    std::string targetName;
    uint64_t targetAddr;
    std::vector<ExprPtr> args;

    CCallExpr(std::string targetName, uint64_t targetAddr,
              std::vector<ExprPtr> args, CTypePtr returnType,
              uint64_t address = 0)
        : CExpr(NodeKind::CallExpr, std::move(returnType), address),
          targetName(std::move(targetName)), targetAddr(targetAddr),
          args(std::move(args)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::CallExpr;
    }
};

/// Ternary expression: cond ? trueVal : falseVal
class CTernaryExpr : public CExpr {
public:
    ExprPtr cond;
    ExprPtr trueVal;
    ExprPtr falseVal;

    CTernaryExpr(ExprPtr cond, ExprPtr trueVal, ExprPtr falseVal,
                 CTypePtr type, uint64_t address = 0)
        : CExpr(NodeKind::TernaryExpr, std::move(type), address),
          cond(std::move(cond)), trueVal(std::move(trueVal)),
          falseVal(std::move(falseVal)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::TernaryExpr;
    }
};

/// Array subscript: base[index]
class CSubscriptExpr : public CExpr {
public:
    ExprPtr base;
    ExprPtr index;

    CSubscriptExpr(ExprPtr base, ExprPtr index, CTypePtr type,
                   uint64_t address = 0)
        : CExpr(NodeKind::SubscriptExpr, std::move(type), address),
          base(std::move(base)), index(std::move(index)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::SubscriptExpr;
    }
};

/// Field access: base.field or base->field
class CFieldAccessExpr : public CExpr {
public:
    ExprPtr base;
    std::string fieldName;
    uint64_t fieldOffset;
    bool isPointer; // true for ->, false for .

    CFieldAccessExpr(ExprPtr base, std::string fieldName, uint64_t fieldOffset,
                     bool isPointer, CTypePtr type, uint64_t address = 0)
        : CExpr(NodeKind::FieldAccessExpr, std::move(type), address),
          base(std::move(base)), fieldName(std::move(fieldName)),
          fieldOffset(fieldOffset), isPointer(isPointer) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::FieldAccessExpr;
    }
};

} // namespace helix::cast
