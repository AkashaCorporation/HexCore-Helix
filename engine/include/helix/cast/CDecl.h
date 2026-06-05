#pragma once

#include "helix/cast/CAstNode.h"
#include "helix/cast/CType.h"
#include "helix/cast/CExpr.h"
#include "helix/cast/CStmt.h"

#include <cstdint>
#include <memory>
#include <optional>
#include <string>
#include <vector>

namespace helix::cast {

// ── Base declaration node ───────────────────────────────────────────────────

/// Base class for all C declaration nodes.
class CDecl : public CAstNode {
public:
    explicit CDecl(NodeKind kind, uint64_t address = 0)
        : CAstNode(kind, address) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() >= NodeKind::VarDecl &&
               n->getKind() <= NodeKind::StructDecl;
    }
};

// ── Concrete declaration nodes ──────────────────────────────────────────────

/// Variable declaration: int32_t var_42 = 0;
class CVarDecl : public CDecl {
public:
    uint32_t varId;
    std::string varName;
    CTypePtr type;
    StorageKind storage;
    std::optional<int64_t> stackOffset;
    ExprPtr initExpr; // nullable

    CVarDecl(uint32_t varId, std::string varName, CTypePtr type,
             StorageKind storage = StorageKind::Stack,
             std::optional<int64_t> stackOffset = std::nullopt,
             ExprPtr initExpr = nullptr, uint64_t address = 0)
        : CDecl(NodeKind::VarDecl, address),
          varId(varId), varName(std::move(varName)), type(std::move(type)),
          storage(storage), stackOffset(stackOffset),
          initExpr(std::move(initExpr)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::VarDecl;
    }
};

/// Parameter declaration: int32_t param0
class CParamDecl : public CDecl {
public:
    std::string name;
    CTypePtr type;
    unsigned index;

    CParamDecl(std::string name, CTypePtr type, unsigned index,
               uint64_t address = 0)
        : CDecl(NodeKind::ParamDecl, address),
          name(std::move(name)), type(std::move(type)), index(index) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::ParamDecl;
    }
};

/// Function declaration: returnType name(params) { body }
class CFuncDecl : public CDecl {
public:
    std::string name;
    uint64_t entryAddr;
    CTypePtr returnType;
    std::vector<CParamDecl> params;
    bool isVariadic;
    std::vector<StmtPtr> body;
    std::vector<CVarDecl> localVars;
    std::string callingConvention;

    /// Confidence analysis (computed by CAstBuilder::analyzeConfidence).
    double confidenceScore = 0.0;
    std::vector<std::string> confidenceIssues;

    /// Number of `CVarDecl` entries in `localVars` that were injected by
    /// `CAstOptimizer::declareUndeclaredVars` (FIX-043) because the body
    /// referenced a name without a matching declaration.  Kept as a
    /// separate counter so the confidence analyzer can still penalise
    /// the smell even after the declarations exist — a function that
    /// needed synthesised placeholders usually indicates SSA-destruction
    /// gaps (bug C) or data-as-code lift artefacts (bug J).
    unsigned synthesizedVarDecls = 0;

    /// D4 (charter exit-metric 4): set by CAstBuilder::analyzeConfidence from
    /// the builder's per-function hasDamningHonestyDefect_ member, raised on
    /// the D1 (code-address-as-data leak) and D2 (out-of-table / own-block
    /// tail-jump indirect) emission paths.  Carried on the decl so the
    /// post-optimization rescorer (CAstOptimizer::reanalyzeConfidence, which
    /// overwrites confidenceScore and cannot see the builder member) can honor
    /// the same hard cap.  When true, confidence is capped at 50%: a function
    /// that demonstrably leaked a code address or called an out-of-table
    /// target is not allowed to self-report as plausible.
    bool hasDamningHonestyDefect = false;

    CFuncDecl(std::string name, uint64_t entryAddr, CTypePtr returnType,
              std::vector<CParamDecl> params = {},
              bool isVariadic = false,
              std::vector<StmtPtr> body = {},
              std::vector<CVarDecl> localVars = {},
              std::string callingConvention = "",
              uint64_t address = 0)
        : CDecl(NodeKind::FuncDecl, address),
          name(std::move(name)), entryAddr(entryAddr),
          returnType(std::move(returnType)), params(std::move(params)),
          isVariadic(isVariadic), body(std::move(body)),
          localVars(std::move(localVars)),
          callingConvention(std::move(callingConvention)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::FuncDecl;
    }
};

/// Struct declaration: struct Name { fields };
class CStructDecl : public CDecl {
public:
    struct StructField {
        std::string name;
        CTypePtr type;
        uint64_t offset;
    };

    std::string name;
    std::vector<StructField> fields;

    CStructDecl(std::string name, std::vector<StructField> fields = {},
                uint64_t address = 0)
        : CDecl(NodeKind::StructDecl, address),
          name(std::move(name)), fields(std::move(fields)) {}

    static bool classof(const CAstNode* n) {
        return n->getKind() == NodeKind::StructDecl;
    }
};

} // namespace helix::cast
