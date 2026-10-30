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

enum class CTypeEvidenceSource : uint8_t {
    Unknown = 0,
    Legacy = 1,
    DataFlow = 2,
    Structural = 3,
    Interprocedural = 4,
    SignatureDatabase = 5,
    DebugInfo = 6,
    User = 7,
};

enum class CTypeEvidenceState : uint8_t {
    Unreported = 0,
    Selected = 1,
    SelectedWithConflict = 2,
    Unresolved = 3,
};

enum class CTypeEvidenceAuthority : uint8_t {
    Unknown = 0,
    Heuristic = 1,
    Derived = 2,
    Authoritative = 3,
};

struct CTypeEvidenceOrigin {
    std::string producer;
    std::optional<uint64_t> generation;
    std::string targetIdentity;
    std::string snapshotHash;

    bool operator==(const CTypeEvidenceOrigin&) const = default;
};

/// Evidence for one declaration-to-type association. This metadata is kept
/// outside CType because the same structural type can have different origins.
struct CTypeEvidence {
    CTypeEvidenceSource source = CTypeEvidenceSource::Unknown;
    CTypeEvidenceState state = CTypeEvidenceState::Unreported;
    CTypeEvidenceAuthority authority = CTypeEvidenceAuthority::Unknown;
    uint16_t strength = 0;
    std::string rejectedSpelling;
    std::optional<CTypeEvidenceOrigin> origin;
};

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
    std::optional<CTypeEvidence> typeEvidence;

    CVarDecl(uint32_t varId, std::string varName, CTypePtr type,
             StorageKind storage = StorageKind::Stack,
             std::optional<int64_t> stackOffset = std::nullopt,
              ExprPtr initExpr = nullptr, uint64_t address = 0,
              std::optional<CTypeEvidence> evidence = std::nullopt)
        : CDecl(NodeKind::VarDecl, address),
          varId(varId), varName(std::move(varName)), type(std::move(type)),
          storage(storage), stackOffset(stackOffset),
          initExpr(std::move(initExpr)), typeEvidence(std::move(evidence)) {}

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
    /// Stable Helix variable identity. Kept optional because parameters
    /// inferred only from a legacy ABI name do not necessarily have a source
    /// VarDecl/argument identity. A present value of zero remains meaningful.
    std::optional<uint32_t> varId;
    std::optional<CTypeEvidence> typeEvidence;

    CParamDecl(std::string name, CTypePtr type, unsigned index,
               uint64_t address = 0,
               std::optional<uint32_t> varId = std::nullopt,
               std::optional<CTypeEvidence> evidence = std::nullopt)
        : CDecl(NodeKind::ParamDecl, address),
          name(std::move(name)), type(std::move(type)), index(index),
          varId(varId), typeEvidence(std::move(evidence)) {}

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
    std::optional<CTypeEvidence> returnTypeEvidence;
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
    std::vector<std::string> synthesizedVarNames;
    std::vector<std::string> protectedDefinitionNames;

    /// Exact supported ABI signatures with arguments missing after recovery.
    /// Retained across AST optimization so erased syntax cannot erase the gap.
    unsigned incompleteAbiCalls = 0;
    unsigned opaquePostCallReads = 0;
    unsigned unqualifiedInstrumentationCalls = 0;
    bool nativeQualityEvaluated = false;
    unsigned suspiciousSelfReferences = 0;

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

    /// A goto whose target label did not survive C-AST construction was
    /// removed to keep the emitted C compilable. The removal is still a CFG
    /// integrity loss and must remain visible after final rescoring.
    bool droppedDanglingGoto = false;

    /// FIX-112 (L1): count of out-of-table indirect calls (the honest
    /// `(*(code*)0xADDR)()` form).  This is FAITHFUL output, so it no longer
    /// trips the 50% damning cap (it used to, pinning cleanly-structured
    /// functions whose only "defect" was an unresolved sibling call); instead
    /// it drives a small graded readability penalty in the confidence scorers.
    int outOfTableCalls = 0;

    /// #30 (registry-miss honest failure): set by CAstBuilder::analyzeConfidence
    /// when an AUTHORITATIVE function table exists and this stub-shaped
    /// function's (non-zero) entry address is NOT an authoritative function
    /// start -- i.e. the address was decompiled as a FuncOp but the Pathfinder
    /// table says it is not a real function start, so it did not honestly lift.
    /// Carried on the decl because the post-optimization rescorer
    /// (CAstOptimizer::reanalyzeConfidence) overwrites confidenceScore and is
    /// the value the user actually sees.  When true, confidence is forced to 0
    /// (a registry miss is a harder honesty failure than the 50% damning cap).
    bool registryMissHonestFailure = false;

    CFuncDecl(std::string name, uint64_t entryAddr, CTypePtr returnType,
              std::vector<CParamDecl> params = {},
              bool isVariadic = false,
              std::vector<StmtPtr> body = {},
              std::vector<CVarDecl> localVars = {},
              std::string callingConvention = "",
              uint64_t address = 0,
              std::optional<CTypeEvidence> returnEvidence = std::nullopt)
        : CDecl(NodeKind::FuncDecl, address),
          name(std::move(name)), entryAddr(entryAddr),
          returnType(std::move(returnType)),
          returnTypeEvidence(std::move(returnEvidence)),
          params(std::move(params)),
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
