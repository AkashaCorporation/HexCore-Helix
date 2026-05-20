/// @file CAstBuilder.cpp
/// @brief Converts HelixHigh MLIR to the C AST (Phase 4b).
///
/// Walks HelixHigh MLIR operations and produces a tree of C AST nodes.
/// Ports the structural logic from PseudoCEmitter but constructs AST
/// nodes instead of emitting text.

#include "helix/cast/CAstBuilder.h"
#include "helix/cast/CDecl.h"
#include "helix/cast/CStmt.h"
#include "helix/cast/CExpr.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixHighTypes.h"
#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixMidOps.h"

#include <unordered_set>

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/BuiltinTypes.h"

#include "llvm/Support/Debug.h"

#include <algorithm>
#include <cctype>
#include <cstring>
#include <format>
#include <string>
#include <string_view>

using namespace mlir;
using namespace helix::cast;

#define DEBUG_TYPE "cast-builder"

// ═══════════════════════════════════════════════════════════════════════════════
// Local helpers
// ═══════════════════════════════════════════════════════════════════════════════

namespace {

/// Parse "param_N" → N, or nullopt.
static std::optional<unsigned> parseParamIndex(std::string_view name) {
    constexpr std::string_view prefix = "param_";
    if (!name.starts_with(prefix) || name.size() == prefix.size())
        return std::nullopt;

    unsigned value = 0;
    for (char ch : name.substr(prefix.size())) {
        if (ch < '0' || ch > '9')
            return std::nullopt;
        value = (value * 10) + static_cast<unsigned>(ch - '0');
    }
    if (value == 0)
        return std::nullopt;
    return value;
}

/// True for synthetic variable names (var_N, spill_N).
static bool isSyntheticTemporaryName(std::string_view name) {
    return name.starts_with("var_") || name.starts_with("spill_");
}

/// True for synthetic value names (vN, var_N, spill_N).
static bool isSyntheticValueName(std::string_view name) {
    if (isSyntheticTemporaryName(name))
        return true;
    if (!name.starts_with('v') || name.size() < 2)
        return false;
    return std::all_of(name.begin() + 1, name.end(), [](unsigned char ch) {
        return std::isdigit(ch);
    });
}

/// Map helix::high::BinaryOpKind to cast::BinaryOp enum.
static BinaryOp mapBinaryOp(helix::high::BinaryOpKind kind) {
    switch (kind) {
    case helix::high::BinaryOpKind::Add:    return BinaryOp::Add;
    case helix::high::BinaryOpKind::Sub:    return BinaryOp::Sub;
    case helix::high::BinaryOpKind::Mul:    return BinaryOp::Mul;
    case helix::high::BinaryOpKind::Div:    return BinaryOp::Div;
    case helix::high::BinaryOpKind::Mod:    return BinaryOp::Mod;
    case helix::high::BinaryOpKind::Shl:    return BinaryOp::Shl;
    case helix::high::BinaryOpKind::Shr:    return BinaryOp::Shr;
    case helix::high::BinaryOpKind::Sar:    return BinaryOp::Sar;
    case helix::high::BinaryOpKind::BitAnd: return BinaryOp::BitAnd;
    case helix::high::BinaryOpKind::BitOr:  return BinaryOp::BitOr;
    case helix::high::BinaryOpKind::BitXor: return BinaryOp::BitXor;
    case helix::high::BinaryOpKind::Eq:     return BinaryOp::Eq;
    case helix::high::BinaryOpKind::Ne:     return BinaryOp::Ne;
    case helix::high::BinaryOpKind::Lt:     return BinaryOp::Lt;
    case helix::high::BinaryOpKind::Le:     return BinaryOp::Le;
    case helix::high::BinaryOpKind::Gt:     return BinaryOp::Gt;
    case helix::high::BinaryOpKind::Ge:     return BinaryOp::Ge;
    case helix::high::BinaryOpKind::LogAnd: return BinaryOp::LogAnd;
    case helix::high::BinaryOpKind::LogOr:  return BinaryOp::LogOr;
    }
    return BinaryOp::Add; // unreachable
}

/// Map helix::high::UnaryOpKind to cast::UnaryOp enum.
static UnaryOp mapUnaryOp(helix::high::UnaryOpKind kind) {
    switch (kind) {
    case helix::high::UnaryOpKind::Neg:       return UnaryOp::Neg;
    case helix::high::UnaryOpKind::LogNot:    return UnaryOp::LogNot;
    case helix::high::UnaryOpKind::BitNot:    return UnaryOp::BitNot;
    case helix::high::UnaryOpKind::Deref:     return UnaryOp::Deref;
    case helix::high::UnaryOpKind::AddressOf: return UnaryOp::AddressOf;
    }
    return UnaryOp::Neg; // unreachable
}

/// Map helix::mid::BinExprKind to cast::BinaryOp enum.
static BinaryOp mapMidBinaryOp(helix::mid::BinExprKind kind) {
    switch (kind) {
    case helix::mid::BinExprKind::Add:    return BinaryOp::Add;
    case helix::mid::BinExprKind::Sub:    return BinaryOp::Sub;
    case helix::mid::BinExprKind::Mul:    return BinaryOp::Mul;
    case helix::mid::BinExprKind::Div:    return BinaryOp::Div;
    case helix::mid::BinExprKind::Mod:    return BinaryOp::Mod;
    case helix::mid::BinExprKind::Shl:    return BinaryOp::Shl;
    case helix::mid::BinExprKind::Shr:    return BinaryOp::Shr;
    case helix::mid::BinExprKind::Sar:    return BinaryOp::Sar;
    case helix::mid::BinExprKind::BitAnd: return BinaryOp::BitAnd;
    case helix::mid::BinExprKind::BitOr:  return BinaryOp::BitOr;
    case helix::mid::BinExprKind::BitXor: return BinaryOp::BitXor;
    case helix::mid::BinExprKind::Eq:     return BinaryOp::Eq;
    case helix::mid::BinExprKind::Ne:     return BinaryOp::Ne;
    case helix::mid::BinExprKind::Lt:     return BinaryOp::Lt;
    case helix::mid::BinExprKind::Le:     return BinaryOp::Le;
    case helix::mid::BinExprKind::Gt:     return BinaryOp::Gt;
    case helix::mid::BinExprKind::Ge:     return BinaryOp::Ge;
    case helix::mid::BinExprKind::LogAnd: return BinaryOp::LogAnd;
    case helix::mid::BinExprKind::LogOr:  return BinaryOp::LogOr;
    }
    return BinaryOp::Add; // unreachable
}

/// Map helix::mid::UnExprKind to cast::UnaryOp enum.
static UnaryOp mapMidUnaryOp(helix::mid::UnExprKind kind) {
    switch (kind) {
    case helix::mid::UnExprKind::Neg:    return UnaryOp::Neg;
    case helix::mid::UnExprKind::LogNot: return UnaryOp::LogNot;
    case helix::mid::UnExprKind::BitNot: return UnaryOp::BitNot;
    case helix::mid::UnExprKind::Deref:  return UnaryOp::Deref;
    case helix::mid::UnExprKind::AddrOf: return UnaryOp::AddressOf;
    }
    return UnaryOp::Neg; // unreachable
}

/// Map helix::low::BinOpKind to cast::BinaryOp enum.
static BinaryOp mapLowBinaryOp(helix::low::BinOpKind kind) {
    switch (kind) {
    case helix::low::BinOpKind::Add:  return BinaryOp::Add;
    case helix::low::BinOpKind::Sub:  return BinaryOp::Sub;
    case helix::low::BinOpKind::Mul:  return BinaryOp::Mul;
    case helix::low::BinOpKind::IMul: return BinaryOp::Mul;
    case helix::low::BinOpKind::Div:  return BinaryOp::Div;
    case helix::low::BinOpKind::IDiv: return BinaryOp::Div;
    case helix::low::BinOpKind::And:  return BinaryOp::BitAnd;
    case helix::low::BinOpKind::Or:   return BinaryOp::BitOr;
    case helix::low::BinOpKind::Xor:  return BinaryOp::BitXor;
    case helix::low::BinOpKind::Shl:  return BinaryOp::Shl;
    case helix::low::BinOpKind::Shr:  return BinaryOp::Shr;
    case helix::low::BinOpKind::Sar:  return BinaryOp::Sar;
    case helix::low::BinOpKind::Rol:  return BinaryOp::Shl; // approximate
    case helix::low::BinOpKind::Ror:  return BinaryOp::Shr; // approximate
    }
    return BinaryOp::Add; // unreachable
}

/// Map LLVM::ICmpPredicate to cast::BinaryOp.
static BinaryOp mapLLVMICmpPred(LLVM::ICmpPredicate pred) {
    switch (pred) {
    case LLVM::ICmpPredicate::eq:  return BinaryOp::Eq;
    case LLVM::ICmpPredicate::ne:  return BinaryOp::Ne;
    case LLVM::ICmpPredicate::slt: return BinaryOp::Lt;
    case LLVM::ICmpPredicate::sle: return BinaryOp::Le;
    case LLVM::ICmpPredicate::sgt: return BinaryOp::Gt;
    case LLVM::ICmpPredicate::sge: return BinaryOp::Ge;
    case LLVM::ICmpPredicate::ult: return BinaryOp::Lt;
    case LLVM::ICmpPredicate::ule: return BinaryOp::Le;
    case LLVM::ICmpPredicate::ugt: return BinaryOp::Gt;
    case LLVM::ICmpPredicate::uge: return BinaryOp::Ge;
    }
    return BinaryOp::Eq; // unreachable
}

/// Map arith::CmpIPredicate to cast::BinaryOp.
static BinaryOp mapArithCmpIPred(arith::CmpIPredicate pred) {
    switch (pred) {
    case arith::CmpIPredicate::eq:  return BinaryOp::Eq;
    case arith::CmpIPredicate::ne:  return BinaryOp::Ne;
    case arith::CmpIPredicate::slt: return BinaryOp::Lt;
    case arith::CmpIPredicate::sle: return BinaryOp::Le;
    case arith::CmpIPredicate::sgt: return BinaryOp::Gt;
    case arith::CmpIPredicate::sge: return BinaryOp::Ge;
    case arith::CmpIPredicate::ult: return BinaryOp::Lt;
    case arith::CmpIPredicate::ule: return BinaryOp::Le;
    case arith::CmpIPredicate::ugt: return BinaryOp::Gt;
    case arith::CmpIPredicate::uge: return BinaryOp::Ge;
    }
    return BinaryOp::Eq; // unreachable
}

/// Map helix::high::StorageKind to cast::StorageKind.
static StorageKind mapStorageKind(helix::high::StorageKind kind) {
    switch (kind) {
    case helix::high::StorageKind::Stack:     return StorageKind::Stack;
    case helix::high::StorageKind::Register:  return StorageKind::Register;
    case helix::high::StorageKind::Global:    return StorageKind::Global;
    case helix::high::StorageKind::Parameter: return StorageKind::Parameter;
    case helix::high::StorageKind::Temporary: return StorageKind::Temporary;
    }
    return StorageKind::Temporary; // unreachable
}

/// Map helix::high::BinaryOpKind to its C compound assignment operator string.
/// Returns nullptr for kinds that don't have a compound form.
static const char* getCompoundOp(helix::high::BinaryOpKind kind) {
    switch (kind) {
    case helix::high::BinaryOpKind::Add:    return "+=";
    case helix::high::BinaryOpKind::Sub:    return "-=";
    case helix::high::BinaryOpKind::Mul:    return "*=";
    case helix::high::BinaryOpKind::Div:    return "/=";
    case helix::high::BinaryOpKind::Mod:    return "%=";
    case helix::high::BinaryOpKind::Shl:    return "<<=";
    case helix::high::BinaryOpKind::Shr:    return ">>=";
    case helix::high::BinaryOpKind::Sar:    return ">>=";
    case helix::high::BinaryOpKind::BitAnd: return "&=";
    case helix::high::BinaryOpKind::BitOr:  return "|=";
    case helix::high::BinaryOpKind::BitXor: return "^=";
    default: return nullptr;
    }
}

/// Is this high::BinaryOpKind commutative?
static bool isCommutativeOp(helix::high::BinaryOpKind kind) {
    switch (kind) {
    case helix::high::BinaryOpKind::Add:
    case helix::high::BinaryOpKind::Mul:
    case helix::high::BinaryOpKind::BitAnd:
    case helix::high::BinaryOpKind::BitOr:
    case helix::high::BinaryOpKind::BitXor:
        return true;
    default:
        return false;
    }
}

/// Try to extract an integer literal value from an MLIR Value.
static std::optional<int64_t> tryExtractIntLiteral(Value value) {
    if (!value)
        return std::nullopt;
    auto* defOp = value.getDefiningOp();
    if (!defOp)
        return std::nullopt;
    if (auto intLit = dyn_cast<helix::high::IntLitOp>(defOp))
        return intLit.getValue();
    if (auto intAttr = defOp->getAttrOfType<IntegerAttr>("value"))
        return intAttr.getValue().getSExtValue();
    return std::nullopt;
}

/// Heuristic: true when an identifier likely names a struct/object base.
static bool looksLikeStructBase(std::string_view name) {
    if (name.empty() || name == "rsp" || name == "rbp")
        return false;
    if (isSyntheticValueName(name))
        return false;
    if (name == "this" || name == "self")
        return true;
    if (name.starts_with("param_") || name.starts_with("arg"))
        return true;
    return false;
}

/// Format an expression node to a simple string for copy-propagation tracking.
/// This is a lightweight formatter used only for the builder's internal
/// name resolution logic - NOT for final output.
static std::string exprToString(const CExpr* expr) {
    if (!expr)
        return "/* null */";
    switch (expr->getKind()) {
    case NodeKind::VarRefExpr:
        return static_cast<const CVarRefExpr*>(expr)->varName;
    case NodeKind::IntLitExpr: {
        auto val = static_cast<const CIntLitExpr*>(expr)->value;
        if (val >= 16 || val <= -16) {
            if (val < 0)
                return std::format("-0x{:x}", static_cast<uint64_t>(-val));
            return std::format("0x{:x}", static_cast<uint64_t>(val));
        }
        return std::format("{}", val);
    }
    case NodeKind::AddrLitExpr:
        return std::format("0x{:x}",
            static_cast<const CAddrLitExpr*>(expr)->addrValue);
    default:
        return "__expr";
    }
}

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Public API
// ═══════════════════════════════════════════════════════════════════════════════

std::vector<std::unique_ptr<CFuncDecl>>
CAstBuilder::buildModule(ModuleOp moduleOp) {
    std::vector<std::unique_ptr<CFuncDecl>> result;

    // Walk helix_low.func ops — the pipeline keeps functions as low::FuncOp
    // even after internal ops are raised to HelixHigh.
    // This matches PseudoCEmitter's behavior.
    moduleOp.walk([&](Operation* op) {
        if (isa<helix::low::FuncOp>(op)) {
            if (auto func = buildFunction(op))
                result.push_back(std::move(func));
        }
    });

    return result;
}

std::unique_ptr<CFuncDecl> CAstBuilder::buildFunction(Operation* op) {
    // Accept both helix_low.func and helix_high.func — the pipeline keeps
    // functions as low::FuncOp even after internal ops are raised to HelixHigh.
    std::string funcName;
    uint64_t entryAddr = 0;
    Region* bodyRegion = nullptr;

    if (auto lowFunc = dyn_cast<helix::low::FuncOp>(op)) {
        funcName = lowFunc.getSymName().str();
        entryAddr = lowFunc.getEntryAddress();
        bodyRegion = &lowFunc.getBody();
    } else if (auto highFunc = dyn_cast<helix::high::FuncOp>(op)) {
        funcName = highFunc.getSymName().str();
        entryAddr = highFunc.getEntryAddress();
        bodyRegion = &highFunc.getBody();
    } else {
        return nullptr;
    }

    clearFunctionState();

    // ── Extract function metadata ───────────────────────────────────────
    currentFunctionName_ = funcName;
    currentFunctionEntryAddr_ = entryAddr;

    // Calling convention
    std::string callingConv;
    currentFunctionIsWin64_ = true;
    if (auto ccAttr = op->getAttrOfType<StringAttr>("calling_convention")) {
        callingConv = ccAttr.getValue().str();
        currentFunctionIsWin64_ = (ccAttr.getValue() == "win64");
    }
    if (auto rbpBaseAttr =
            op->getAttrOfType<IntegerAttr>("win64_rbp_param_base_offset")) {
        currentWin64RbpStackParamBaseOffset_ =
            rbpBaseAttr.getValue().getSExtValue();
    }

    bool isVariadic = op->hasAttr("is_variadic");

    // Return value detection
    currentFunctionHasReturnValue_ = op->hasAttr("has_return_value");
    currentReturnValueName_.clear();

    // ── Initialize block labels ─────────────────────────────────────────
    globalBlockCounter_ = 1;
    blockLabels_.clear();
    op->walk([&](Block* block) {
        uint64_t addr = 0;
        if (!block->empty()) {
            if (auto addrAttr =
                    block->front().getAttrOfType<IntegerAttr>("address"))
                addr = addrAttr.getUInt();
        }
        if (addr != 0)
            blockLabels_[block] = std::format("loc_{:x}", addr);
        else
            blockLabels_[block] = std::format("block_{}", globalBlockCounter_++);
    });

    // ── Collect goto label references ───────────────────────────────────
    op->walk([&](helix::high::GotoOp gotoOp) {
        referencedLabelNames_.insert(gotoOp.getLabel().str());
    });

    // FIX-053 (Wave 12 REVERT of FIX-051): populating `referencedBlocks_`
    // from JmpOp/JccOp successors caused label emission for EVERY block
    // reached by a low-level jump — even those already absorbed by
    // `helix_high.if` structuring.  Result on live IDE output was
    // goto-soup: `kbase_context_mmap` gained 73 `block_N:` labels with
    // raw gotos, regressing the structured form that Helix 0.7.1 had
    // already produced.  Revert to the pre-FIX-051 state (container
    // stays declared but empty) until SAILR-style ISD/ISC consolidation
    // lands in a follow-up wave.  See docs/AgentsNoGit/RESEARCH_HELIX_VS_IDA_GAP.md
    // §8 for the post-mortem.

    // ── Detect return-only labels ───────────────────────────────────────
    op->walk([&](helix::high::LabelOp labelOp) {
        auto* block = labelOp->getBlock();
        if (!block)
            return;

        bool foundReturn = false;
        bool foundOther = false;
        auto it = std::next(labelOp->getIterator());
        for (; it != block->end(); ++it) {
            if (isa<helix::high::LabelOp>(&*it))
                continue;
            if (isa<helix::high::ReturnOp>(&*it)) {
                foundReturn = true;
                break;
            }
            foundOther = true;
            break;
        }

        if (foundReturn && !foundOther)
            returnOnlyLabels_.insert(labelOp.getName().str());
    });

    for (const auto& name : returnOnlyLabels_)
        referencedLabelNames_.erase(name);

    // ── Pre-scans ───────────────────────────────────────────────────────
    precomputeVarUseCounts(op);
    prescanStructFieldNames(op);

    // ── Collect VarDeclOp -> build CVarDecl list ────────────────────────
    // Also collect referenced var IDs for filtering.
    llvm::DenseSet<uint32_t> referencedVarIds;
    op->walk([&](helix::high::VarRefOp ref) {
        if (ref->hasAttr("helix.infrastructure"))
            return;
        bool onlyInfraUsers = true;
        for (auto* user : ref->getResult(0).getUsers()) {
            if (!user->hasAttr("helix.infrastructure")) {
                onlyInfraUsers = false;
                break;
            }
        }
        if (!ref->getResult(0).use_empty() && onlyInfraUsers)
            return;
        referencedVarIds.insert(ref.getVarId());
    });

    // Build stack offset map
    stackOffsetToVarName_.clear();
    op->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getStorage() != helix::high::StorageKind::Stack)
            return;
        if (auto offset = decl.getStackOffset())
            stackOffsetToVarName_[*offset] = decl.getVarName().str();
    });

    // Collect local variable declarations (non-parameter)
    std::vector<CVarDecl> localVars;
    op->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getStorage() == helix::high::StorageKind::Parameter)
            return;
        if (decl->hasAttr("helix.infrastructure"))
            return;
        if (!referencedVarIds.contains(decl.getVarId()))
            return;

        CTypePtr varType = CType::int64(); // default
        if (auto inferredType = decl->getAttrOfType<StringAttr>("inferred_type")) {
            auto typeStr = inferredType.getValue().str();
            if (typeStr == "void*")
                varType = CType::voidPtr();
            else if (typeStr == "int32_t")
                varType = CType::int32();
            else if (typeStr == "uint32_t")
                varType = CType::uint32();
            else if (typeStr == "int16_t")
                varType = CType::int16();
            else if (typeStr == "uint16_t")
                varType = CType::uint16();
            else if (typeStr == "int8_t")
                varType = CType::int8();
            else if (typeStr == "uint8_t")
                varType = CType::uint8();
            else if (typeStr == "uint64_t")
                varType = CType::uint64();
            else if (typeStr == "float")
                varType = CType::floatTy();
            else if (typeStr == "double")
                varType = CType::doubleTy();
            else if (typeStr == "bool")
                varType = CType::boolTy();
            else if (typeStr.ends_with("*")) {
                // Pointer-to-struct (e.g., "auto_struct_0*")
                auto pointeeName = typeStr.substr(0, typeStr.size() - 1);
                if (!pointeeName.empty() && pointeeName != "void") {
                    varType = CType::pointerTo(CType::structTy(pointeeName));
                } else {
                    varType = CType::voidPtr();
                }
            }
        }

        // XMM/YMM registers are floating-point
        auto varName = decl.getVarName().str();
        if (varName.starts_with("xmm") || varName.starts_with("XMM") ||
            varName.starts_with("ymm") || varName.starts_with("YMM"))
            varType = CType::floatTy();

        auto storage = mapStorageKind(decl.getStorage());
        std::optional<int64_t> stackOffset;
        if (decl.getStackOffset())
            stackOffset = *decl.getStackOffset();

        localVars.emplace_back(
            decl.getVarId(),
            decl.getVarName().str(),
            varType,
            storage,
            stackOffset,
            /*initExpr=*/nullptr,
            extractAddress(decl));
    });

    // ── Infer parameters (Win64 ABI) ────────────────────────────────────
    struct ParamInfo {
        std::string typeStr;
        std::string rawName;
    };
    std::map<unsigned, ParamInfo> paramInfoByIndex;

    auto recordParam = [&](unsigned index, const std::string& typeStr,
                           const std::string& rawName) {
        auto [it, inserted] =
            paramInfoByIndex.try_emplace(index, ParamInfo{typeStr, rawName});
        if (!inserted) {
            if (it->second.typeStr == "int64_t" && typeStr != "int64_t")
                it->second.typeStr = typeStr;
            if (it->second.rawName.empty())
                it->second.rawName = rawName;
        }
    };

    // Collect from VarDeclOp with Parameter storage
    op->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getStorage() != helix::high::StorageKind::Parameter)
            return;

        std::string paramType = "int64_t";
        if (auto inferredType = decl->getAttrOfType<StringAttr>("inferred_type"))
            paramType = inferredType.getValue().str();

        std::string rawName = decl.getVarName().str();
        if (auto index = parseParamIndex(rawName))
            recordParam(*index, paramType, rawName);
    });

    // Also from VarRefOps that look like param_N
    op->walk([&](helix::high::VarRefOp ref) {
        if (auto index = parseParamIndex(ref.getVarName().str()))
            recordParam(*index, "int64_t", ref.getVarName().str());
    });

    // param_1 -> this heuristic: if param_1 used >= 3 times as struct base
    if (paramInfoByIndex.count(1)) {
        unsigned objectUseScore = 0;
        op->walk([&](helix::high::FieldAccessOp field) {
            auto* baseOp = field.getBase().getDefiningOp();
            if (!baseOp)
                return;
            if (auto varRef = dyn_cast<helix::high::VarRefOp>(baseOp)) {
                if (varRef.getVarName() == "param_1")
                    objectUseScore += 2;
            }
        });

        if (objectUseScore >= 3) {
            nameAliases_["param_1"] = "this";
            auto& selfParam = paramInfoByIndex[1];
            selfParam.rawName = "this";
            if (selfParam.typeStr == "int64_t")
                selfParam.typeStr = "void*";
        }
    }

    // Build CParamDecl list
    std::vector<CParamDecl> params;
    for (const auto& [index, info] : paramInfoByIndex) {
        std::string paramName = info.rawName.empty()
            ? std::format("param_{}", index)
            : info.rawName;
        paramName = applyNameAliases(paramName);

        CTypePtr paramType = CType::int64(); // default
        if (info.typeStr == "void*")
            paramType = CType::voidPtr();
        else if (info.typeStr == "int32_t")
            paramType = CType::int32();
        else if (info.typeStr == "uint32_t")
            paramType = CType::uint32();
        else if (info.typeStr == "int16_t")
            paramType = CType::int16();
        else if (info.typeStr == "uint16_t")
            paramType = CType::uint16();
        else if (info.typeStr == "int8_t")
            paramType = CType::int8();
        else if (info.typeStr == "uint8_t")
            paramType = CType::uint8();
        else if (info.typeStr == "uint64_t")
            paramType = CType::uint64();
        else if (info.typeStr == "float")
            paramType = CType::floatTy();
        else if (info.typeStr == "double")
            paramType = CType::doubleTy();
        else if (info.typeStr == "bool")
            paramType = CType::boolTy();
        else if (info.typeStr.ends_with("*")) {
            auto pointeeName =
                info.typeStr.substr(0, info.typeStr.size() - 1);
            if (!pointeeName.empty() && pointeeName != "void")
                paramType = CType::pointerTo(CType::structTy(pointeeName));
            else
                paramType = CType::voidPtr();
        }

        params.emplace_back(paramName, paramType, index);
    }

    // ── Detect return value name ────────────────────────────────────────
    if (currentFunctionHasReturnValue_) {
        op->walk([&](helix::high::VarDeclOp decl) {
            if (!referencedVarIds.contains(decl.getVarId()))
                return;
            auto name = decl.getVarName().str();
            if (name == "result") {
                currentReturnValueName_ = "result";
                return;
            }
            if (currentReturnValueName_.empty() && name == "rax")
                currentReturnValueName_ = "rax";
        });
    }

    // ── Return type ─────────────────────────────────────────────────────
    CTypePtr returnType =
        currentFunctionHasReturnValue_ ? CType::int64() : CType::voidTy();

    // ── Build body ──────────────────────────────────────────────────────
    std::vector<StmtPtr> body;
    if (!bodyRegion->empty())
        body = buildRegionBody(*bodyRegion);

    // ── Assemble CFuncDecl ──────────────────────────────────────────────
    auto funcDecl = std::make_unique<CFuncDecl>(
        funcName,
        entryAddr,
        returnType,
        std::move(params),
        isVariadic,
        std::move(body),
        std::move(localVars),
        callingConv,
        entryAddr);

    // ── Confidence analysis ───────────────────────────────────────────
    analyzeConfidence(*funcDecl, op);

    return funcDecl;
}

// ═══════════════════════════════════════════════════════════════════════════════
// State management
// ═══════════════════════════════════════════════════════════════════════════════

void CAstBuilder::clearFunctionState() {
    lastRegValue_.clear();
    varUseCount_.clear();
    deadStoreOps_.clear();
    nameAliases_.clear();
    stackOffsetToVarName_.clear();
    globalAddrToVarName_.clear();
    exprToBestName_.clear();
    syntheticCallBaseAddrs_.clear();
    recoveredStructFields_.clear();
    currentFunctionIsWin64_ = true;
    currentWin64RbpStackParamBaseOffset_ = 0x28;
    currentWin64StackParamLimit_ = 4;
    currentFunctionHasReturnValue_ = false;
    currentFunctionName_.clear();
    currentFunctionEntryAddr_ = 0;
    currentReturnValueName_.clear();
    globalBlockCounter_ = 0;
    blockLabels_.clear();
    referencedBlocks_.clear();
    referencedLabelNames_.clear();
    returnOnlyLabels_.clear();
}

// ═══════════════════════════════════════════════════════════════════════════════
// Region body builder
// ═══════════════════════════════════════════════════════════════════════════════

std::vector<StmtPtr> CAstBuilder::buildRegionBody(Region& region) {
    std::vector<StmtPtr> stmts;
    bool multiBlock = (std::distance(region.begin(), region.end()) > 1);

    // ── Cross-block dead store pre-scan ─────────────────────────────────
    {
        llvm::SmallVector<helix::high::AssignOp, 64> allAssigns;
        for (auto& block : region) {
            for (auto& inst : block) {
                if (auto assign = dyn_cast<helix::high::AssignOp>(&inst))
                    allAssigns.push_back(assign);
            }
        }

        std::unordered_set<std::string> writtenNotRead;
        for (auto it = allAssigns.rbegin(); it != allAssigns.rend(); ++it) {
            auto assignOp = *it;
            auto* targetDef = assignOp.getTarget().getDefiningOp();
            if (!targetDef)
                continue;

            std::string targetStr;
            if (auto varRef = dyn_cast<helix::high::VarRefOp>(targetDef))
                targetStr = applyNameAliases(varRef.getVarName().str());
            else
                continue;

            // Skip complex targets
            if (targetStr.find("->") != std::string::npos ||
                targetStr.find("*(") != std::string::npos)
                continue;

            // Check RHS for side effects
            auto* valueDef = assignOp.getValue().getDefiningOp();
            bool hasSideEffects =
                valueDef && isa<helix::high::CallOp>(valueDef);

            if (!hasSideEffects) {
                if (writtenNotRead.count(targetStr)) {
                    deadStoreOps_.insert(assignOp.getOperation());
                    continue;
                }
                writtenNotRead.insert(targetStr);
            } else {
                writtenNotRead.erase(targetStr);
            }

            // Check if RHS reads tracked variables
            assignOp.getValue().getDefiningOp();
            // Walk RHS operands
            if (valueDef) {
                for (auto operand : valueDef->getOperands()) {
                    if (auto ref =
                            operand.getDefiningOp<helix::high::VarRefOp>()) {
                        auto refName =
                            applyNameAliases(ref.getVarName().str());
                        writtenNotRead.erase(refName);
                    }
                }
            }
        }
    }

    bool firstBlock = true;
    for (auto& block : region) {
        // Reset copy propagation state at block boundaries
        lastRegValue_.clear();
        exprToBestName_.clear();

        // Emit block label for non-entry blocks
        if (multiBlock && !firstBlock) {
            bool hasExplicitLabel = false;
            for (auto& blockOp : block) {
                if (isa<helix::high::LabelOp>(&blockOp)) {
                    hasExplicitLabel = true;
                    break;
                }
            }
            if (!hasExplicitLabel && referencedBlocks_.contains(&block)) {
                auto labelIt = blockLabels_.find(&block);
                if (labelIt != blockLabels_.end()) {
                    stmts.push_back(
                        std::make_unique<CLabelStmt>(labelIt->second));
                }
            }
        }
        firstBlock = false;

        // Per-block dead store pre-scan
        auto blockDead = precomputeDeadStores(block);
        deadStoreOps_.insert(blockDead.begin(), blockDead.end());

        for (auto& blockOp : block.getOperations()) {
            if (shouldSkip(&blockOp))
                continue;

            auto stmt = buildStatement(&blockOp);
            if (stmt)
                stmts.push_back(std::move(stmt));
        }
    }

    return stmts;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Statement builder
// ═══════════════════════════════════════════════════════════════════════════════

StmtPtr CAstBuilder::buildStatement(Operation* op) {
    uint64_t addr = extractAddress(op);

    // ─── Assignment ─────────────────────────────────────────────────────
    if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
        // ── Heuristic filters for infrastructure that escaped attribute
        // propagation (ported from PseudoCEmitter) ──────────────────────
        {
            auto* targetDef = assign.getTarget().getDefiningOp();
            auto* valueDef = assign.getValue().getDefiningOp();
            if (targetDef && valueDef) {
                // Get target/value names for pattern matching
                std::string tgtName, valName;
                if (auto tRef = dyn_cast<helix::high::VarRefOp>(targetDef))
                    tgtName = applyNameAliases(tRef.getVarName().str());
                if (auto vRef = dyn_cast<helix::high::VarRefOp>(valueDef))
                    valName = vRef.getVarName().str();

                // 1. _promoted_ = anything → PC/flag infrastructure
                if (tgtName.find("_promoted_") != std::string::npos)
                    return nullptr;

                // 2. _spill_ = anything → spill infrastructure
                if (tgtName.find("_spill_") != std::string::npos)
                    return nullptr;

                // 3. rsp = anything → stack pointer bookkeeping
                if (tgtName == "rsp" || tgtName == "RSP")
                    return nullptr;

                // 4. anything = rsp → stack pointer shuffle
                if (valName == "rsp" || valName == "RSP")
                    return nullptr;
            }
        }

        auto targetExpr = buildExpression(assign.getTarget());
        auto valueExpr = buildExpression(assign.getValue());

        if (!targetExpr || !valueExpr)
            return nullptr;

        // FIX-047, part 2): guard against malformed lvalue targets.
        //
        // `buildExpression` is context-unaware: when it encounters a
        // `__remill_undefined_{8,16,32,64}` intrinsic (see line ~2429) it
        // returns a `CIntLitExpr(0)` because 0 is the best static stand-in
        // for "undefined" in an rvalue position.  When that same intrinsic
        // drives an assignment TARGET the emitted C is the malformed
        // `0 = <rhs>;`, observed in SOTR's `HealthData-read.c` line 41
        // before this fix.
        //
        // Skipping an integer-literal target is unambiguously correct:
        // there is no legal C program in which `42 = x;` parses, so any
        // IR that produced one is semantically equivalent to "discard this
        // store" from a decompiled-output standpoint.  The RHS is still
        // built (above) so any side-effecting call in the value expression
        // is preserved as a bare ExprStmt.
        if (targetExpr->getKind() == NodeKind::IntLitExpr) {
            // If the RHS has observable side effects (a function call,
            // potentially with useful arguments), keep it as a statement.
            // Otherwise drop the whole thing.
            const bool rhsHasSideEffects =
                valueExpr &&
                (valueExpr->getKind() == NodeKind::CallExpr);
            if (rhsHasSideEffects) {
                return std::make_unique<CExprStmt>(std::move(valueExpr), addr);
            }
            return nullptr;
        }

        // Track copy propagation
        std::string targetStr = exprToString(targetExpr.get());
        std::string valueStr = exprToString(valueExpr.get());

        // exprToString uses "__expr" as a placeholder for any expression it
        // can't represent (BinaryExpr, CallExpr, FieldAccess, etc.).  That
        // sentinel must NEVER end up in lastRegValue_/exprToBestName_,
        // because those caches feed back into name resolution
        // (resolveTransitive at line 1428) and would emit the literal
        // string "__expr" in the output.
        const bool valueIsOpaque = (valueStr == "__expr");
        const bool targetIsOpaque = (targetStr == "__expr");

        // Skip redundant identical assignments
        if (!targetIsOpaque && !valueIsOpaque &&
            lastRegValue_.count(targetStr) &&
            lastRegValue_[targetStr] == valueStr)
            return nullptr;

        // Invalidate cached entries that depend on the target
        if (!targetIsOpaque) {
            for (auto it = lastRegValue_.begin(); it != lastRegValue_.end();) {
                if (it->first == targetStr ||
                    it->second.find(targetStr) != std::string::npos)
                    it = lastRegValue_.erase(it);
                else
                    ++it;
            }
            // Only cache when the value is also representable; storing
            // "<targetStr> -> __expr" causes downstream substitutions to
            // emit the placeholder.
            if (!valueIsOpaque)
                lastRegValue_[targetStr] = valueStr;
        }

        // Track value equivalence (skip when either side is opaque)
        if (!targetIsOpaque && !valueIsOpaque) {
            auto existingIt = exprToBestName_.find(valueStr);
            bool shouldUpdate = (existingIt == exprToBestName_.end());
            if (!shouldUpdate) {
                bool targetIsSynth = isSyntheticTemporaryName(targetStr) ||
                                     isSyntheticValueName(targetStr);
                bool existIsSynth =
                    isSyntheticTemporaryName(existingIt->second) ||
                    isSyntheticValueName(existingIt->second);
                if (existIsSynth && !targetIsSynth)
                    shouldUpdate = true;
                else if (existIsSynth == targetIsSynth &&
                         targetStr.size() < existingIt->second.size())
                    shouldUpdate = true;
            }
            if (shouldUpdate)
                exprToBestName_[valueStr] = targetStr;
        }

        // Compound assignment detection
        std::string compoundOp =
            detectCompoundOp(op, targetStr);

        return std::make_unique<CAssignStmt>(
            std::move(targetExpr), std::move(valueExpr), compoundOp, addr);
    }

    // ─── Expression statement ───────────────────────────────────────────
    if (auto exprStmt = dyn_cast<helix::high::ExprStmtOp>(op)) {
        auto expr = buildExpression(exprStmt.getExpr());
        if (!expr)
            return nullptr;
        return std::make_unique<CExprStmt>(std::move(expr), addr);
    }

    // ─── Call as statement ──────────────────────────────────────────────
    if (auto call = dyn_cast<helix::high::CallOp>(op)) {
        // Suppress standalone emission only when a user's statement will
        // emit this call as an expression (an AssignOp that prints
        // `var = call(...)` or a ReturnOp that prints `return call(...)`).
        // Additional guard: the AssignOp must be in the same block —
        // otherwise the walker may never reach it in this region's scope
        // and the call would silently disappear.
        if (call->getNumResults() > 0) {
            bool hasReachableEmittingUser = false;
            Block* callBlock = call->getBlock();
            for (Operation* user : call->getResult(0).getUsers()) {
                bool isEmitter = isa<helix::high::AssignOp,
                                     helix::high::ReturnOp,
                                     helix::low::RetOp>(user);
                if (!isEmitter)
                    continue;
                if (user->getBlock() == callBlock) {
                    hasReachableEmittingUser = true;
                    break;
                }
            }
            if (hasReachableEmittingUser)
                return nullptr;
        }

        auto calleeName = call.getTargetName().str();
        auto targetAddr = call.getTargetAddr();

        std::vector<ExprPtr> callArgs;
        for (auto arg : call.getArgs()) {
            auto argExpr = buildExpression(arg);
            if (argExpr)
                callArgs.push_back(std::move(argExpr));
        }

        // Vtable pattern: __vtable_0xNN → base->vfunc_0xNN(rest...)
        if (calleeName.starts_with("__vtable_0x") && !callArgs.empty()) {
            auto offsetStr = calleeName.substr(9); // "__vtable_" is 9 chars
            std::vector<ExprPtr> restArgs;
            for (size_t i = 1; i < callArgs.size(); ++i)
                restArgs.push_back(std::move(callArgs[i]));
            std::string vtableName = std::format("vfunc_{}", offsetStr);
            auto callExpr = std::make_unique<CCallExpr>(
                vtableName, targetAddr, std::move(restArgs),
                CType::voidTy(), addr);
            return std::make_unique<CExprStmt>(std::move(callExpr), addr);
        }

        auto callExpr = std::make_unique<CCallExpr>(
            calleeName, targetAddr, std::move(callArgs),
            CType::voidTy(), addr);

        return std::make_unique<CExprStmt>(std::move(callExpr), addr);
    }

    // ─── If/else ────────────────────────────────────────────────────────
    if (auto ifOp = dyn_cast<helix::high::IfOp>(op)) {
        lastRegValue_.clear();
        exprToBestName_.clear();

        auto cond = buildExpression(ifOp.getCondition());
        if (!cond)
            cond = std::make_unique<CVarRefExpr>(0, "__cond", CType::boolTy());

        auto thenBody = buildRegionBody(ifOp.getThenRegion());

        std::vector<StmtPtr> elseBody;
        if (!ifOp.getElseRegion().empty())
            elseBody = buildRegionBody(ifOp.getElseRegion());

        return std::make_unique<CIfStmt>(
            std::move(cond), std::move(thenBody), std::move(elseBody), addr);
    }

    // ─── While loop ─────────────────────────────────────────────────────
    if (auto whileOp = dyn_cast<helix::high::WhileOp>(op)) {
        auto cond = buildExpression(whileOp.getCondition());
        if (!cond)
            cond = std::make_unique<CVarRefExpr>(0, "__cond", CType::boolTy());

        auto body = buildRegionBody(whileOp.getBodyRegion());

        return std::make_unique<CWhileStmt>(
            std::move(cond), std::move(body), addr);
    }

    // ─── Do-while loop ──────────────────────────────────────────────────
    if (auto doWhile = dyn_cast<helix::high::DoWhileOp>(op)) {
        auto body = buildRegionBody(doWhile.getBodyRegion());

        // Extract condition from condition region's yield operand
        ExprPtr cond;
        if (!doWhile.getCondRegion().empty()) {
            Block& condBlock = doWhile.getCondRegion().front();
            for (auto& condOp : condBlock) {
                if (auto yieldOp = dyn_cast<helix::high::YieldOp>(&condOp)) {
                    if (yieldOp.getValue())
                        cond = buildExpression(yieldOp.getValue());
                    break;
                }
            }
        }
        if (!cond)
            cond = std::make_unique<CIntLitExpr>(1, CType::boolTy());

        return std::make_unique<CDoWhileStmt>(
            std::move(body), std::move(cond), addr);
    }

    // ─── For loop ───────────────────────────────────────────────────────
    if (auto forOp = dyn_cast<helix::high::ForOp>(op)) {
        // Build init, cond, step, body from the 4 regions
        StmtPtr init;
        if (!forOp.getInitRegion().empty()) {
            auto initStmts = buildRegionBody(forOp.getInitRegion());
            if (!initStmts.empty())
                init = std::move(initStmts.front());
        }

        ExprPtr cond;
        if (!forOp.getCondRegion().empty()) {
            Block& condBlock = forOp.getCondRegion().front();
            for (auto& condOp : condBlock) {
                if (auto yieldOp = dyn_cast<helix::high::YieldOp>(&condOp)) {
                    if (yieldOp.getValue())
                        cond = buildExpression(yieldOp.getValue());
                    break;
                }
            }
        }

        StmtPtr step;
        if (!forOp.getStepRegion().empty()) {
            auto stepStmts = buildRegionBody(forOp.getStepRegion());
            if (!stepStmts.empty())
                step = std::move(stepStmts.front());
        }

        auto body = buildRegionBody(forOp.getBodyRegion());

        return std::make_unique<CForStmt>(
            std::move(init), std::move(cond), std::move(step),
            std::move(body), addr);
    }

    // ─── Switch ─────────────────────────────────────────────────────────
    if (auto switchOp = dyn_cast<helix::high::SwitchOp>(op)) {
        auto selector = buildExpression(switchOp.getSelector());
        if (!selector)
            selector =
                std::make_unique<CVarRefExpr>(0, "__selector", CType::int64());

        auto caseValues = switchOp.getCaseValues();
        auto caseRegions = switchOp.getCaseRegions();

        std::vector<CSwitchStmt::SwitchCase> cases;
        for (size_t i = 0; i < caseRegions.size(); ++i) {
            CSwitchStmt::SwitchCase sc;
            if (i < static_cast<size_t>(caseValues.size()))
                sc.value = caseValues[i];
            else
                sc.isDefault = true;
            sc.body = buildRegionBody(caseRegions[i]);
            cases.push_back(std::move(sc));
        }

        return std::make_unique<CSwitchStmt>(
            std::move(selector), std::move(cases), addr);
    }

    // ─── Return ─────────────────────────────────────────────────────────
    if (auto ret = dyn_cast<helix::high::ReturnOp>(op)) {
        lastRegValue_.clear();
        exprToBestName_.clear();

        ExprPtr value;
        if (ret.getValue()) {
            value = buildExpression(ret.getValue());
        } else if (currentFunctionHasReturnValue_ &&
                   !currentReturnValueName_.empty()) {
            value = std::make_unique<CVarRefExpr>(
                0, applyNameAliases(currentReturnValueName_), CType::int64());
        } else if (currentFunctionHasReturnValue_) {
            value = std::make_unique<CVarRefExpr>(
                0, "result", CType::int64(), addr);
        }
        return std::make_unique<CReturnStmt>(std::move(value), addr);
    }

    // ─── Break ──────────────────────────────────────────────────────────
    if (isa<helix::high::BreakOp>(op))
        return std::make_unique<CBreakStmt>(addr);

    // ─── Continue ───────────────────────────────────────────────────────
    if (isa<helix::high::ContinueOp>(op))
        return std::make_unique<CContinueStmt>(addr);

    // ─── Goto ───────────────────────────────────────────────────────────
    if (auto gotoOp = dyn_cast<helix::high::GotoOp>(op)) {
        auto labelName = gotoOp.getLabel().str();

        // Replace goto to a return-only label with inline return
        if (returnOnlyLabels_.contains(labelName)) {
            ExprPtr value;
            if (currentFunctionHasReturnValue_ &&
                !currentReturnValueName_.empty()) {
                value = std::make_unique<CVarRefExpr>(
                    0, applyNameAliases(currentReturnValueName_),
                    CType::int64());
            } else if (currentFunctionHasReturnValue_) {
                value = std::make_unique<CVarRefExpr>(
                    0, "result", CType::int64(), addr);
            }
            return std::make_unique<CReturnStmt>(std::move(value), addr);
        }

        return std::make_unique<CGotoStmt>(labelName, addr);
    }

    // ─── Label ──────────────────────────────────────────────────────────
    if (auto label = dyn_cast<helix::high::LabelOp>(op)) {
        auto* block = label->getBlock();
        const bool referenced =
            referencedLabelNames_.contains(label.getName().str()) ||
            referencedBlocks_.contains(block);
        if (!referenced)
            return nullptr;
        return std::make_unique<CLabelStmt>(label.getName().str(), addr);
    }

    // ─── Comment ────────────────────────────────────────────────────────
    if (auto comment = dyn_cast<helix::high::CommentOp>(op))
        return std::make_unique<CCommentStmt>(comment.getText().str());

    // ─── Inline assembly ────────────────────────────────────────────────
    if (auto asmOp = dyn_cast<helix::high::AsmOp>(op))
        return std::make_unique<CAsmStmt>(asmOp.getText().str(), addr);

    // ═════════════════════════════════════════════════════════════════════
    // HelixLow Dialect statement ops
    // ═════════════════════════════════════════════════════════════════════

    // ─── helix_low.call (as statement) ─────────────────────────────────
    if (auto call = dyn_cast<helix::low::CallOp>(op)) {
        // Same rule as high::CallOp above: only suppress when a same-block
        // emitting consumer will re-emit the call as an expression.
        if (call->getNumResults() > 0) {
            bool hasReachableEmittingUser = false;
            Block* callBlock = call->getBlock();
            for (Operation* user : call->getResult(0).getUsers()) {
                bool isEmitter = isa<helix::low::RegWriteOp,
                                     helix::high::AssignOp,
                                     helix::high::ReturnOp,
                                     helix::low::RetOp>(user);
                if (!isEmitter)
                    continue;
                if (user->getBlock() == callBlock) {
                    hasReachableEmittingUser = true;
                    break;
                }
            }
            if (hasReachableEmittingUser)
                return nullptr;
        }

        std::string calleeName;
        uint64_t targetAddrVal = 0;
        if (auto name = call.getTargetName()) {
            calleeName = name->str();
        } else {
            // Try to format the target address as a name
            calleeName = std::format("sub_{}", "indirect");
        }

        std::vector<ExprPtr> callArgs;
        for (auto operand : call.getArgs()) {
            auto argExpr = buildExpression(operand);
            if (argExpr)
                callArgs.push_back(std::move(argExpr));
        }

        // Invalidate copy propagation on call
        lastRegValue_.clear();
        exprToBestName_.clear();

        auto callExpr = std::make_unique<CCallExpr>(
            calleeName, targetAddrVal, std::move(callArgs),
            CType::voidTy(), addr);
        return std::make_unique<CExprStmt>(std::move(callExpr), addr);
    }

    // ─── helix_low.ret ─────────────────────────────────────────────────
    if (auto ret = dyn_cast<helix::low::RetOp>(op)) {
        lastRegValue_.clear();
        exprToBestName_.clear();

        ExprPtr value;
        if (currentFunctionHasReturnValue_ &&
            !currentReturnValueName_.empty()) {
            value = std::make_unique<CVarRefExpr>(
                0, applyNameAliases(currentReturnValueName_), CType::int64());
        } else if (currentFunctionHasReturnValue_) {
            value = std::make_unique<CVarRefExpr>(
                0, "result", CType::int64(), addr);
        }
        return std::make_unique<CReturnStmt>(std::move(value), addr);
    }

    // ─── helix_low.reg_write ───────────────────────────────────────────
    if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(op)) {
        // Skip dead writes from Memory* chain breaking
        {
            Value val = regWrite.getValue();
            if (isa<LLVM::LLVMPointerType>(val.getType()))
                return nullptr;
            Operation* valDef = val.getDefiningOp();
            if (valDef && isa<LLVM::UndefOp>(valDef))
                return nullptr;
        }

        // Skip flag register writes (CF, ZF, SF, OF, PF, AF)
        {
            auto regName = regWrite.getRegName();
            if (regName == "CF" || regName == "ZF" || regName == "SF" ||
                regName == "OF" || regName == "PF" || regName == "AF")
                return nullptr;
        }

        // Skip RSP writes (stack pointer bookkeeping)
        {
            auto regName = regWrite.getRegName();
            if (regName == "RSP" || regName == "rsp" ||
                regName == "RBP" || regName == "rbp")
                return nullptr;
        }

        std::string regName = regWrite.getRegName().str();
        for (auto& c : regName) c = std::tolower(c);

        // XMM/YMM registers are floating-point
        auto regType = (regName.starts_with("xmm") || regName.starts_with("ymm"))
            ? CType::floatTy() : CType::int64();
        auto target = std::make_unique<CVarRefExpr>(
            0, regName, regType, addr);
        auto value = buildExpression(regWrite.getValue());
        if (!value)
            return nullptr;

        return std::make_unique<CAssignStmt>(
            std::move(target), std::move(value), "", addr);
    }

    // ─── helix_low.mem_write ───────────────────────────────────────────
    if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
        auto addrExpr = buildExpression(memWrite.getAddr());
        if (!addrExpr)
            return nullptr;

        // FIX-047, part 2): if the address resolves to a bare
        // integer literal (typically 0 from a `__remill_undefined_*`
        // intrinsic collapse), wrapping it in a Deref and then printing
        // yields `*0 = rhs` which the CAstOptimizer's `*(T)NULL → 0`
        // rule later folds to `0 = rhs` — malformed C.  Since the
        // address is a synthesized "don't know" value, there is no
        // store to preserve; drop the entire statement, keeping any
        // side-effecting RHS call as a bare expression statement.
        if (addrExpr->getKind() == NodeKind::IntLitExpr) {
            auto value = buildExpression(memWrite.getValue());
            if (value && value->getKind() == NodeKind::CallExpr)
                return std::make_unique<CExprStmt>(std::move(value), addr);
            return nullptr;
        }

        auto target = std::make_unique<CUnaryExpr>(
            UnaryOp::Deref, std::move(addrExpr),
            CType::int64(), addr);
        auto value = buildExpression(memWrite.getValue());
        if (!value)
            return nullptr;

        return std::make_unique<CAssignStmt>(
            std::move(target), std::move(value), "", addr);
    }

    // ─── helix_low.push (prologue artifact) ────────────────────────────
    if (isa<helix::low::PushOp>(op))
        return nullptr;

    // ─── helix_low.pop (expression, not statement) ─────────────────────
    if (isa<helix::low::PopOp>(op))
        return nullptr;

    // ─── helix_low.cmp/test (flag-setting, no visible statement) ───────
    if (isa<helix::low::CmpOp>(op) || isa<helix::low::TestOp>(op))
        return nullptr;

    // ─── helix_low.nop ─────────────────────────────────────────────────
    if (isa<helix::low::NopOp>(op))
        return nullptr;

    // ─── helix_low.xchg ────────────────────────────────────────────────
    if (auto xchg = dyn_cast<helix::low::XchgOp>(op)) {
        std::string regA = xchg.getRegA().str();
        std::string regB = xchg.getRegB().str();
        for (auto& c : regA) c = std::tolower(c);
        for (auto& c : regB) c = std::tolower(c);
        return std::make_unique<CCommentStmt>(
            std::format("xchg {}, {}", regA, regB), addr);
    }

    // ─── helix_low.int3 ────────────────────────────────────────────────
    if (isa<helix::low::Int3Op>(op)) {
        // Emit as __debugbreak() call
        std::vector<ExprPtr> noArgs;
        auto callExpr = std::make_unique<CCallExpr>(
            "__debugbreak", 0, std::move(noArgs), CType::voidTy(), addr);
        return std::make_unique<CExprStmt>(std::move(callExpr), addr);
    }

    // ─── helix_low.rep_movs ────────────────────────────────────────────
    if (auto repMovs = dyn_cast<helix::low::RepMovsOp>(op)) {
        std::vector<ExprPtr> args;
        args.push_back(buildExpression(repMovs.getDst()));
        args.push_back(buildExpression(repMovs.getSrc()));
        args.push_back(buildExpression(repMovs.getCount()));
        auto callExpr = std::make_unique<CCallExpr>(
            "memcpy", 0, std::move(args), CType::voidTy(), addr);
        return std::make_unique<CExprStmt>(std::move(callExpr), addr);
    }

    // ─── helix_low.rep_stos ────────────────────────────────────────────
    if (auto repStos = dyn_cast<helix::low::RepStosOp>(op)) {
        std::vector<ExprPtr> args;
        args.push_back(buildExpression(repStos.getDst()));
        args.push_back(buildExpression(repStos.getValue()));
        args.push_back(buildExpression(repStos.getCount()));
        auto callExpr = std::make_unique<CCallExpr>(
            "memset", 0, std::move(args), CType::voidTy(), addr);
        return std::make_unique<CExprStmt>(std::move(callExpr), addr);
    }

    // ─── helix_low.jmp ─────────────────────────────────────────────────
    //
    // FIX-053 (Wave 12 REVERT of FIX-051): emitting CGotoStmt for
    // non-fall-through JmpOp regressed live IDE output to goto-soup
    // (73 `block_N:` labels on `kbase_context_mmap` where 0.7.1 had
    // structured control flow).  Restore the pre-FIX-051 behaviour of
    // dropping JmpOp at the C-AST level; StructureControlFlow is
    // expected to have absorbed every schema-matchable jump.  When
    // SAILR-style ISD/ISC consolidation lands in a follow-up wave we
    // can re-introduce a goto fallback that only fires after the
    // structurer has had its say, rather than in parallel with it.
    if (isa<helix::low::JmpOp>(op))
        return nullptr;

    // ─── helix_low.jcc ─────────────────────────────────────────────────
    //
    // FIX-053: same revert rationale as JmpOp above.  The conditional
    // form of FIX-051 emitted `if (cond) goto T; goto F;` for every
    // unstructured conditional branch, which also contributed to the
    // goto-soup regression.  Skip at C-AST level until SAILR
    // consolidation exists.
    if (isa<helix::low::JccOp>(op))
        return nullptr;

    // ─── helix_low value-producing ops (skip at statement level) ───────
    if (isa<helix::low::BinOp>(op) || isa<helix::low::UnaryOp>(op) ||
        isa<helix::low::CMovOp>(op) || isa<helix::low::MovZxOp>(op) ||
        isa<helix::low::MovSxOp>(op) || isa<helix::low::LeaOp>(op) ||
        isa<helix::low::RegReadOp>(op) || isa<helix::low::MemReadOp>(op))
        return nullptr;

    // ═════════════════════════════════════════════════════════════════════
    // LLVM Dialect statement ops
    // ═════════════════════════════════════════════════════════════════════

    // ─── llvm.call (as statement — void or unused return) ──────────────
    if (auto call = dyn_cast<LLVM::CallOp>(op)) {
        std::string calleeName;
        if (auto callee = call.getCallee())
            calleeName = callee->str();
        else
            calleeName = "/* indirect */";

        // Skip Remill internal intrinsics that are infrastructure
        if (calleeName.starts_with("__remill_write_memory_") ||
            calleeName.starts_with("__remill_read_memory_") ||
            calleeName.starts_with("__remill_flag_computation") ||
            calleeName.starts_with("__remill_compare") ||
            calleeName.starts_with("__remill_undefined") ||
            calleeName.starts_with("__remill_barrier") ||
            calleeName.starts_with("__remill_atomic") ||
            calleeName == "__remill_missing_block" ||
            calleeName == "__remill_function_return" ||
            calleeName == "__remill_jump" ||
            calleeName == "__remill_error")
            return nullptr;

        // Build arguments — skip first arg if it's a state pointer (Remill convention)
        std::vector<ExprPtr> callArgs;
        unsigned startIdx = 0;
        if (call.getNumOperands() > 0) {
            auto firstArgType = call.getOperand(0).getType();
            if (isa<LLVM::LLVMPointerType>(firstArgType)) {
                // Check if this looks like a Remill state pointer (first arg to lifted fn)
                auto* firstDef = call.getOperand(0).getDefiningOp();
                if (firstDef && isa<LLVM::UndefOp>(firstDef))
                    startIdx = 1;  // Skip the undef state pointer
            }
        }
        for (unsigned i = startIdx; i < call.getNumOperands(); i++) {
            // Skip trailing state/memory pointer args
            if (isa<LLVM::LLVMPointerType>(call.getOperand(i).getType()))
                continue;
            auto argExpr = buildExpression(call.getOperand(i));
            if (argExpr)
                callArgs.push_back(std::move(argExpr));
        }

        lastRegValue_.clear();
        exprToBestName_.clear();

        auto callExpr = std::make_unique<CCallExpr>(
            calleeName, 0, std::move(callArgs),
            CType::voidTy(), addr);
        return std::make_unique<CExprStmt>(std::move(callExpr), addr);
    }

    // ─── llvm.store → assignment ───────────────────────────────────────
    if (auto store = dyn_cast<LLVM::StoreOp>(op)) {
        auto addrExpr = buildExpression(store.getAddr());
        if (!addrExpr)
            return nullptr;

        // FIX-047, part 2): same lvalue-sanity guard as
        // helix_low.mem_write.  If the store address is a bare integer
        // literal (commonly 0, originating from `__remill_undefined_*`
        // collapse to `CIntLitExpr(0)` via buildExpression), refuse to
        // build the malformed `*0 = rhs` / `0 = rhs` assignment.
        // Preserve any call-valued RHS as an ExprStmt so side effects
        // are retained; otherwise drop.
        if (addrExpr->getKind() == NodeKind::IntLitExpr) {
            auto value = buildExpression(store.getValue());
            if (value && value->getKind() == NodeKind::CallExpr)
                return std::make_unique<CExprStmt>(std::move(value), addr);
            return nullptr;
        }

        auto target = std::make_unique<CUnaryExpr>(
            UnaryOp::Deref, std::move(addrExpr),
            CType::int64(), addr);
        auto value = buildExpression(store.getValue());
        if (!value)
            return nullptr;
        return std::make_unique<CAssignStmt>(
            std::move(target), std::move(value), "", addr);
    }

    // ─── Skip all remaining LLVM dialect ops (block terminators,
    //     pure expression ops consumed via buildExpression) ──────────────
    if (op->getDialect() && op->getDialect()->getNamespace() == "llvm")
        return nullptr;

    // ─── Skip all arith dialect ops (pure value-producing) ─────────────
    if (op->getDialect() && op->getDialect()->getNamespace() == "arith")
        return nullptr;

    // ─── Skip all HelixMid dialect ops that survived partial conversion ─
    if (op->getDialect() && op->getDialect()->getNamespace() == "helix_mid")
        return nullptr;

    // ─── Fallback: unhandled op → __helix_unhandled_<opname>(args) ──────
    //
    // FIX-084 (RetDec-inspired): emit an opaque pseudo-call instead of a
    // bare comment so operand liveness is preserved and downstream passes
    // see a valid statement node.  This prevents the previously-undefined
    // behaviour where an unrecognized op silently produced output the AST
    // walker could not classify.  Argument expressions that fail to build
    // are skipped (rather than poisoning the call) so a single missing
    // operand does not lose the rest of the call.
    {
        auto callName =
            "__helix_unhandled_" + op->getName().getStringRef().str();
        // Normalize dots in dialect-qualified op names (e.g.
        // "helix_high.foo" → "helix_high_foo") so the result is a valid
        // C identifier.
        for (auto& c : callName)
            if (c == '.') c = '_';

        std::vector<ExprPtr> args;
        for (Value operand : op->getOperands()) {
            if (auto expr = buildExpression(operand))
                args.push_back(std::move(expr));
        }
        auto callExpr = std::make_unique<CCallExpr>(
            std::move(callName), /*targetAddr=*/0, std::move(args),
            CType::int64(), addr);
        return std::make_unique<CExprStmt>(std::move(callExpr), addr);
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Expression builder
// ═══════════════════════════════════════════════════════════════════════════════

ExprPtr CAstBuilder::buildExpression(Value val) {
    if (!val)
        return std::make_unique<CVarRefExpr>(0, "/* null */", CType::unknownTy());

    auto* defOp = val.getDefiningOp();
    if (!defOp) {
        // Block argument — number by position in the block's argument list
        unsigned argIndex = 0;
        if (auto blockArg = dyn_cast<BlockArgument>(val))
            argIndex = blockArg.getArgNumber();
        return std::make_unique<CVarRefExpr>(
            0, std::format("block_arg{}", argIndex),
            convertType(val.getType()));
    }

    uint64_t addr = extractAddress(defOp);

    // ─── Integer literal ────────────────────────────────────────────────
    if (auto intLit = dyn_cast<helix::high::IntLitOp>(defOp)) {
        return std::make_unique<CIntLitExpr>(
            intLit.getValue(), convertType(val.getType()), addr);
    }

    // ─── Float literal ──────────────────────────────────────────────────
    if (auto floatLit = dyn_cast<helix::high::FloatLitOp>(defOp)) {
        double fval = floatLit.getValue().convertToDouble();
        return std::make_unique<CFloatLitExpr>(
            fval, convertType(val.getType()), addr);
    }

    // ─── String literal ─────────────────────────────────────────────────
    if (auto strLit = dyn_cast<helix::high::StringLitOp>(defOp)) {
        return std::make_unique<CStringLitExpr>(
            strLit.getValue().str(), addr);
    }

    // ─── Address literal ────────────────────────────────────────────────
    if (auto addrLit = dyn_cast<helix::high::AddrLitOp>(defOp)) {
        return std::make_unique<CAddrLitExpr>(
            addrLit.getAddrValue(), convertType(val.getType()), addr);
    }

    // ─── Variable reference ─────────────────────────────────────────────
    if (auto varRef = dyn_cast<helix::high::VarRefOp>(defOp)) {
        auto name = applyNameAliases(varRef.getVarName().str());
        auto varId = varRef.getVarId();
        auto type = convertType(val.getType());

        // Copy propagation: resolve synthetic temporaries
        if (isSyntheticTemporaryName(name) || isSyntheticValueName(name)) {
            auto resolved = resolveTransitive(name);
            if (resolved != name && resolved.find(name) == std::string::npos)
                name = resolved;
        }

        return std::make_unique<CVarRefExpr>(varId, name, type, addr);
    }

    // ─── Binary expression ──────────────────────────────────────────────
    if (auto binary = dyn_cast<helix::high::BinaryOp>(defOp)) {
        auto lhs = buildExpression(binary.getLhs());
        auto rhs = buildExpression(binary.getRhs());
        auto op = mapBinaryOp(binary.getOp());
        auto type = convertType(val.getType());

        return std::make_unique<CBinaryExpr>(
            op, std::move(lhs), std::move(rhs), type, addr);
    }

    // ─── Unary expression ───────────────────────────────────────────────
    if (auto unary = dyn_cast<helix::high::UnaryOp>(defOp)) {
        auto operand = buildExpression(unary.getOperand());
        auto op = mapUnaryOp(unary.getOp());
        auto type = convertType(val.getType());

        return std::make_unique<CUnaryExpr>(
            op, std::move(operand), type, addr);
    }

    // ─── Cast expression ────────────────────────────────────────────────
    if (auto castOp = dyn_cast<helix::high::CastOp>(defOp)) {
        // Elide identity casts (same type in -> out)
        if (castOp.getInput().getType() == castOp.getResult().getType())
            return buildExpression(castOp.getInput());

        // Elide redundant casts based on context:
        // - Widening integer casts (e.g. i32 -> i64) when the result is used
        //   in a comparison or binary op that would implicitly promote anyway.
        // - Casts where the source and dest are both integer types of the same
        //   signedness and the dest is wider.
        auto srcType = castOp.getInput().getType();
        auto dstType = castOp.getResult().getType();
        bool elide = false;

        auto srcInt = dyn_cast<IntegerType>(srcType);
        auto dstInt = dyn_cast<IntegerType>(dstType);
        if (srcInt && dstInt &&
            dstInt.getWidth() >= srcInt.getWidth()) {
            // Check if the cast result feeds into a comparison or assignment
            // where implicit promotion is safe.
            for (auto* user : castOp.getResult().getUsers()) {
                if (isa<helix::high::BinaryOp>(user) ||
                    isa<helix::high::AssignOp>(user)) {
                    elide = true;
                    break;
                }
            }
        }

        if (elide)
            return buildExpression(castOp.getInput());

        auto operand = buildExpression(castOp.getInput());
        auto targetType = convertType(castOp.getResult().getType());

        return std::make_unique<CCastExpr>(
            targetType, std::move(operand), addr);
    }

    // ─── Call expression ────────────────────────────────────────────────
    if (auto call = dyn_cast<helix::high::CallOp>(defOp)) {
        auto calleeName = call.getTargetName().str();
        auto targetAddr = call.getTargetAddr();
        auto returnType = convertType(val.getType());

        std::vector<ExprPtr> callArgs;
        for (auto arg : call.getArgs()) {
            auto argExpr = buildExpression(arg);
            if (argExpr)
                callArgs.push_back(std::move(argExpr));
        }

        // ── RTTI Tier 1: check for class::method resolved name ──────────
        // DevirtualizeIndirectCalls Phase 4 annotates vtable calls with
        // "helix.resolved_name" = "ClassName::methodName".  If present,
        // prefer it over the raw __vtable_0xNN mangling.
        if (auto resolvedAttr = call->getAttrOfType<mlir::StringAttr>(
                "helix.resolved_name")) {
            StringRef resolved = resolvedAttr.getValue();
            if (!resolved.empty() && resolved.contains("::")) {
                return std::make_unique<CCallExpr>(
                    resolved.str(), targetAddr, std::move(callArgs),
                    returnType, addr);
            }
        }

        // Vtable pattern: __vtable_0xNN → vfunc_0xNN(rest...)
        // The first argument is the object base; the vtable offset encodes
        // the virtual function slot. CAstOptimizer can further refine this
        // to base->vfunc_0xNN(rest...) using field-access nodes.
        if (calleeName.starts_with("__vtable_0x") && !callArgs.empty()) {
            auto offsetStr = calleeName.substr(9); // "__vtable_" is 9 chars
            std::string vtableName = std::format("vfunc_{}", offsetStr);
            // Keep all args (base + rest) — printer/optimizer handles display
            return std::make_unique<CCallExpr>(
                vtableName, targetAddr, std::move(callArgs),
                returnType, addr);
        }

        return std::make_unique<CCallExpr>(
            calleeName, targetAddr, std::move(callArgs), returnType, addr);
    }

    // ─── Ternary expression ─────────────────────────────────────────────
    if (auto ternary = dyn_cast<helix::high::TernaryOp>(defOp)) {
        auto cond = buildExpression(ternary.getCond());
        auto trueVal = buildExpression(ternary.getTrueVal());
        auto falseVal = buildExpression(ternary.getFalseVal());
        auto type = convertType(val.getType());

        return std::make_unique<CTernaryExpr>(
            std::move(cond), std::move(trueVal), std::move(falseVal),
            type, addr);
    }

    // ─── Subscript expression ───────────────────────────────────────────
    if (auto sub = dyn_cast<helix::high::SubscriptOp>(defOp)) {
        auto base = buildExpression(sub.getBase());
        auto index = buildExpression(sub.getIndex());
        auto type = convertType(val.getType());

        return std::make_unique<CSubscriptExpr>(
            std::move(base), std::move(index), type, addr);
    }

    // ─── Field access expression ────────────────────────────────────────
    if (auto field = dyn_cast<helix::high::FieldAccessOp>(defOp)) {
        auto base = buildExpression(field.getBase());
        auto originalName = field.getFieldName().str();
        auto offset = field.getFieldOffset();
        bool isPointer = field.getIsPointer();
        auto type = convertType(val.getType());

        // Try to recover a meaningful field name
        std::string fieldName = originalName;
        if (isGenericFieldName(originalName)) {
            std::string baseStr = exprToString(base.get());
            auto recovered = getRecoveredFieldName(
                applyNameAliases(baseStr), offset);
            if (!recovered.empty())
                fieldName = recovered;
        }

        return std::make_unique<CFieldAccessExpr>(
            std::move(base), fieldName, offset, isPointer, type, addr);
    }

    // ═════════════════════════════════════════════════════════════════════
    // HelixMid Dialect expressions
    // ═════════════════════════════════════════════════════════════════════

    // ─── mid.constant ──────────────────────────────────────────────────
    if (auto midConst = dyn_cast<helix::mid::ConstantOp>(defOp)) {
        return std::make_unique<CIntLitExpr>(
            midConst.getValue(), convertType(val.getType()), addr);
    }

    // ─── mid.var_ref ───────────────────────────────────────────────────
    if (auto midVarRef = dyn_cast<helix::mid::VarRefOp>(defOp)) {
        uint32_t slot = midVarRef.getSlotId();
        auto name = std::format("slot_{}", slot);
        return std::make_unique<CVarRefExpr>(slot, name,
            convertType(val.getType()), addr);
    }

    // ─── mid.binexpr ───────────────────────────────────────────────────
    if (auto midBin = dyn_cast<helix::mid::BinExprOp>(defOp)) {
        auto lhs = buildExpression(midBin.getLhs());
        auto rhs = buildExpression(midBin.getRhs());
        auto op = mapMidBinaryOp(midBin.getKind());
        return std::make_unique<CBinaryExpr>(
            op, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── mid.unexpr ────────────────────────────────────────────────────
    if (auto midUn = dyn_cast<helix::mid::UnExprOp>(defOp)) {
        auto operand = buildExpression(midUn.getOperand());
        auto op = mapMidUnaryOp(midUn.getKind());
        return std::make_unique<CUnaryExpr>(
            op, std::move(operand), convertType(val.getType()), addr);
    }

    // ─── mid.cast ──────────────────────────────────────────────────────
    if (auto midCast = dyn_cast<helix::mid::CastOp>(defOp)) {
        if (midCast.getInput().getType() == midCast.getResult().getType())
            return buildExpression(midCast.getInput());
        auto operand = buildExpression(midCast.getInput());
        return std::make_unique<CCastExpr>(
            convertType(midCast.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── mid.load ──────────────────────────────────────────────────────
    if (auto midLoad = dyn_cast<helix::mid::LoadOp>(defOp)) {
        auto addrExpr = buildExpression(midLoad.getAddr());
        return std::make_unique<CUnaryExpr>(
            UnaryOp::Deref, std::move(addrExpr),
            convertType(val.getType()), addr);
    }

    // ─── mid.select ────────────────────────────────────────────────────
    if (auto midSelect = dyn_cast<helix::mid::SelectOp>(defOp)) {
        auto cond = buildExpression(midSelect.getCondition());
        auto trueVal = buildExpression(midSelect.getTrueVal());
        auto falseVal = buildExpression(midSelect.getFalseVal());
        return std::make_unique<CTernaryExpr>(
            std::move(cond), std::move(trueVal), std::move(falseVal),
            convertType(val.getType()), addr);
    }

    // ─── mid.field_ptr ─────────────────────────────────────────────────
    if (auto midFieldPtr = dyn_cast<helix::mid::FieldPtrOp>(defOp)) {
        auto base = buildExpression(midFieldPtr.getBase());
        auto offset = midFieldPtr.getFieldOffset();
        std::string fieldName;
        if (auto name = midFieldPtr.getFieldName())
            fieldName = name->str();
        else
            fieldName = std::format("field_0x{:x}", offset);
        // FieldPtr yields &base->field, so use AddressOf(FieldAccess)
        auto fieldAccess = std::make_unique<CFieldAccessExpr>(
            std::move(base), fieldName, offset, /*isPointer=*/true,
            convertType(val.getType()), addr);
        return std::make_unique<CUnaryExpr>(
            UnaryOp::AddressOf, std::move(fieldAccess),
            convertType(val.getType()), addr);
    }

    // ─── mid.index_ptr ─────────────────────────────────────────────────
    if (auto midIdxPtr = dyn_cast<helix::mid::IndexPtrOp>(defOp)) {
        auto base = buildExpression(midIdxPtr.getBase());
        auto index = buildExpression(midIdxPtr.getIndex());
        auto subscript = std::make_unique<CSubscriptExpr>(
            std::move(base), std::move(index),
            convertType(val.getType()), addr);
        return std::make_unique<CUnaryExpr>(
            UnaryOp::AddressOf, std::move(subscript),
            convertType(val.getType()), addr);
    }

    // ─── mid.addr_const ────────────────────────────────────────────────
    if (auto midAddr = dyn_cast<helix::mid::AddrConstOp>(defOp)) {
        return std::make_unique<CAddrLitExpr>(
            midAddr.getAddrValue(), convertType(val.getType()), addr);
    }

    // ─── mid.call ──────────────────────────────────────────────────────
    if (auto midCall = dyn_cast<helix::mid::CallOp>(defOp)) {
        std::string calleeName;
        if (auto name = midCall.getCalleeName())
            calleeName = name->str();
        else
            calleeName = std::format("sub_{:x}", midCall.getCalleeAddr());
        std::vector<ExprPtr> callArgs;
        for (auto arg : midCall.getArgs()) {
            auto argExpr = buildExpression(arg);
            if (argExpr)
                callArgs.push_back(std::move(argExpr));
        }
        return std::make_unique<CCallExpr>(
            calleeName, midCall.getCalleeAddr(), std::move(callArgs),
            convertType(val.getType()), addr);
    }

    // ═════════════════════════════════════════════════════════════════════
    // HelixLow Dialect fallback expressions
    // ═════════════════════════════════════════════════════════════════════

    // ─── helix_low.reg_read ────────────────────────────────────────────
    if (auto regRead = dyn_cast<helix::low::RegReadOp>(defOp)) {
        std::string name = regRead.getRegName().str();
        // Win64 calling convention: map arg registers to param_N
        static const std::pair<const char*, unsigned> kArgMap[] = {
            {"RCX", 1}, {"ECX", 1},
            {"RDX", 2}, {"EDX", 2},
            {"R8",  3}, {"R8D", 3},
            {"R9",  4}, {"R9D", 4},
        };
        for (auto [reg, argIndex] : kArgMap) {
            if (name == reg) {
                auto aliased = applyNameAliases(std::format("param_{}", argIndex));
                return std::make_unique<CVarRefExpr>(
                    0, aliased, convertType(val.getType()), addr);
            }
        }
        // Win64: XMM0-XMM3 carry floating-point parameters
        static const std::pair<const char*, unsigned> kXmmArgMap[] = {
            {"XMM0", 1}, {"XMM1", 2}, {"XMM2", 3}, {"XMM3", 4},
        };
        for (auto [reg, argIndex] : kXmmArgMap) {
            if (name == reg) {
                auto aliased = applyNameAliases(std::format("param_{}", argIndex));
                return std::make_unique<CVarRefExpr>(
                    0, aliased, CType::floatTy(), addr);
            }
        }
        // Lowercase the register name
        for (auto& c : name) c = std::tolower(c);
        // XMM/YMM registers are floating-point
        auto regType = (name.starts_with("xmm") || name.starts_with("ymm"))
            ? CType::floatTy() : convertType(val.getType());
        return std::make_unique<CVarRefExpr>(
            0, name, regType, addr);
    }

    // ─── helix_low.mem_read ────────────────────────────────────────────
    if (auto memRead = dyn_cast<helix::low::MemReadOp>(defOp)) {
        auto addrExpr = buildExpression(memRead.getAddr());
        return std::make_unique<CUnaryExpr>(
            UnaryOp::Deref, std::move(addrExpr),
            convertType(val.getType()), addr);
    }

    // ─── helix_low.bin_op ──────────────────────────────────────────────
    if (auto binop = dyn_cast<helix::low::BinOp>(defOp)) {
        auto lhs = buildExpression(binop.getLhs());
        auto rhs = buildExpression(binop.getRhs());
        auto op = mapLowBinaryOp(binop.getKind());
        return std::make_unique<CBinaryExpr>(
            op, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── helix_low.unary_op ────────────────────────────────────────────
    if (auto unary = dyn_cast<helix::low::UnaryOp>(defOp)) {
        auto operand = buildExpression(unary.getOperand());
        UnaryOp op;
        switch (unary.getKind()) {
        case helix::low::UnaryOpKind::Neg:   op = UnaryOp::Neg; break;
        case helix::low::UnaryOpKind::Not:   op = UnaryOp::BitNot; break;
        case helix::low::UnaryOpKind::Inc: {
            // inc(x) -> x + 1
            auto one = std::make_unique<CIntLitExpr>(1, convertType(val.getType()));
            return std::make_unique<CBinaryExpr>(
                BinaryOp::Add, std::move(operand), std::move(one),
                convertType(val.getType()), addr);
        }
        case helix::low::UnaryOpKind::Dec: {
            // dec(x) -> x - 1
            auto one = std::make_unique<CIntLitExpr>(1, convertType(val.getType()));
            return std::make_unique<CBinaryExpr>(
                BinaryOp::Sub, std::move(operand), std::move(one),
                convertType(val.getType()), addr);
        }
        case helix::low::UnaryOpKind::Bswap:
        case helix::low::UnaryOpKind::Bsf:
        case helix::low::UnaryOpKind::Bsr: {
            // Emit as a builtin call
            std::string builtinName;
            switch (unary.getKind()) {
            case helix::low::UnaryOpKind::Bswap: builtinName = "__builtin_bswap64"; break;
            case helix::low::UnaryOpKind::Bsf:   builtinName = "__builtin_ctzll"; break;
            case helix::low::UnaryOpKind::Bsr:   builtinName = "__builtin_clzll"; break;
            default: builtinName = "__builtin_unknown"; break;
            }
            std::vector<ExprPtr> args;
            args.push_back(std::move(operand));
            return std::make_unique<CCallExpr>(
                builtinName, 0, std::move(args),
                convertType(val.getType()), addr);
        }
        default:
            op = UnaryOp::Neg; break;
        }
        return std::make_unique<CUnaryExpr>(
            op, std::move(operand), convertType(val.getType()), addr);
    }

    // ─── helix_low.cmp (flag results) ──────────────────────────────────
    if (auto cmp = dyn_cast<helix::low::CmpOp>(defOp)) {
        auto lhs = buildExpression(cmp.getLhs());
        auto rhs = buildExpression(cmp.getRhs());
        // Determine which flag result is referenced
        BinaryOp cmpOp = BinaryOp::Lt; // default: carry flag
        if (auto opResult = dyn_cast<OpResult>(val)) {
            switch (opResult.getResultNumber()) {
            case 0: cmpOp = BinaryOp::Lt; break;  // carry/below
            case 1: cmpOp = BinaryOp::Eq; break;  // zero/equal
            case 2: cmpOp = BinaryOp::Lt; break;  // sign
            case 3: cmpOp = BinaryOp::Lt; break;  // overflow
            }
        }
        return std::make_unique<CBinaryExpr>(
            cmpOp, std::move(lhs), std::move(rhs),
            CType::boolTy(), addr);
    }

    // ─── helix_low.test (flag results) ─────────────────────────────────
    if (auto test = dyn_cast<helix::low::TestOp>(defOp)) {
        auto lhs = buildExpression(test.getLhs());
        auto rhs = buildExpression(test.getRhs());
        // test produces (val & val) == 0 or (val & val) < 0
        auto bitAnd = std::make_unique<CBinaryExpr>(
            BinaryOp::BitAnd, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
        auto zero = std::make_unique<CIntLitExpr>(0, convertType(val.getType()));
        BinaryOp testOp = BinaryOp::Eq; // default: zero flag
        if (auto opResult = dyn_cast<OpResult>(val)) {
            switch (opResult.getResultNumber()) {
            case 0: testOp = BinaryOp::Eq; break;  // zero flag
            case 1: testOp = BinaryOp::Lt; break;   // sign flag
            }
        }
        return std::make_unique<CBinaryExpr>(
            testOp, std::move(bitAnd), std::move(zero),
            CType::boolTy(), addr);
    }

    // ─── helix_low.cmov (conditional select) ───────────────────────────
    if (auto cmov = dyn_cast<helix::low::CMovOp>(defOp)) {
        auto cond = buildExpression(cmov.getFlagValue());
        auto trueVal = buildExpression(cmov.getTrueVal());
        auto falseVal = buildExpression(cmov.getFalseVal());
        return std::make_unique<CTernaryExpr>(
            std::move(cond), std::move(trueVal), std::move(falseVal),
            convertType(val.getType()), addr);
    }

    // ─── helix_low.movzx (zero extend) ─────────────────────────────────
    if (auto movzx = dyn_cast<helix::low::MovZxOp>(defOp)) {
        if (movzx.getSrc().getType() == movzx.getResult().getType())
            return buildExpression(movzx.getSrc());
        auto operand = buildExpression(movzx.getSrc());
        return std::make_unique<CCastExpr>(
            convertType(movzx.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── helix_low.movsx (sign extend) ─────────────────────────────────
    if (auto movsx = dyn_cast<helix::low::MovSxOp>(defOp)) {
        if (movsx.getSrc().getType() == movsx.getResult().getType())
            return buildExpression(movsx.getSrc());
        auto operand = buildExpression(movsx.getSrc());
        return std::make_unique<CCastExpr>(
            convertType(movsx.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── helix_low.lea ─────────────────────────────────────────────────
    if (auto lea = dyn_cast<helix::low::LeaOp>(defOp)) {
        auto base = buildExpression(lea.getBase());
        auto disp = lea.getDisplacement();
        if (disp != 0) {
            auto offset = std::make_unique<CIntLitExpr>(
                disp, convertType(val.getType()));
            return std::make_unique<CBinaryExpr>(
                BinaryOp::Add, std::move(base), std::move(offset),
                convertType(val.getType()), addr);
        }
        return base;
    }

    // ─── helix_low.pop (value from stack) ──────────────────────────────
    if (isa<helix::low::PopOp>(defOp)) {
        // Represent as pop() call expression
        std::vector<ExprPtr> noArgs;
        return std::make_unique<CCallExpr>(
            "pop", 0, std::move(noArgs),
            convertType(val.getType()), addr);
    }

    // ═════════════════════════════════════════════════════════════════════
    // LLVM Dialect expressions
    // ═════════════════════════════════════════════════════════════════════

    // ─── llvm.mlir.constant ────────────────────────────────────────────
    if (auto constOp = dyn_cast<LLVM::ConstantOp>(defOp)) {
        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
            return std::make_unique<CIntLitExpr>(
                intAttr.getValue().getSExtValue(),
                convertType(constOp.getType()), addr);
        }
        if (auto floatAttr = dyn_cast<FloatAttr>(constOp.getValue())) {
            return std::make_unique<CFloatLitExpr>(
                floatAttr.getValueAsDouble(),
                convertType(constOp.getType()), addr);
        }
        return std::make_unique<CIntLitExpr>(
            0, convertType(constOp.getType()), addr);
    }

    // ─── llvm.mlir.undef ───────────────────────────────────────────────
    if (isa<LLVM::UndefOp>(defOp)) {
        return std::make_unique<CVarRefExpr>(
            0, "__undef", convertType(val.getType()), addr);
    }

    // ─── llvm.add ──────────────────────────────────────────────────────
    if (auto addOp = dyn_cast<LLVM::AddOp>(defOp)) {
        auto lhs = buildExpression(addOp.getLhs());
        auto rhs = buildExpression(addOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Add, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.sub ──────────────────────────────────────────────────────
    if (auto subOp = dyn_cast<LLVM::SubOp>(defOp)) {
        auto lhs = buildExpression(subOp.getLhs());
        auto rhs = buildExpression(subOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Sub, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.mul ──────────────────────────────────────────────────────
    if (auto mulOp = dyn_cast<LLVM::MulOp>(defOp)) {
        auto lhs = buildExpression(mulOp.getLhs());
        auto rhs = buildExpression(mulOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Mul, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.udiv ──────────────────────────────────────────────────────
    if (auto udivOp = dyn_cast<LLVM::UDivOp>(defOp)) {
        auto lhs = buildExpression(udivOp.getLhs());
        auto rhs = buildExpression(udivOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Div, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.sdiv ─────────────────────────────────────────────────────
    if (auto sdivOp = dyn_cast<LLVM::SDivOp>(defOp)) {
        auto lhs = buildExpression(sdivOp.getLhs());
        auto rhs = buildExpression(sdivOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Div, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.urem ─────────────────────────────────────────────────────
    if (auto uremOp = dyn_cast<LLVM::URemOp>(defOp)) {
        auto lhs = buildExpression(uremOp.getLhs());
        auto rhs = buildExpression(uremOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Mod, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.srem ─────────────────────────────────────────────────────
    if (auto sremOp = dyn_cast<LLVM::SRemOp>(defOp)) {
        auto lhs = buildExpression(sremOp.getLhs());
        auto rhs = buildExpression(sremOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Mod, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.and ───────────────────────────────────────────────────────
    if (auto andOp = dyn_cast<LLVM::AndOp>(defOp)) {
        auto lhs = buildExpression(andOp.getLhs());
        auto rhs = buildExpression(andOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::BitAnd, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.or ───────────────────────────────────────────────────────
    if (auto orOp = dyn_cast<LLVM::OrOp>(defOp)) {
        auto lhs = buildExpression(orOp.getLhs());
        auto rhs = buildExpression(orOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::BitOr, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.xor ──────────────────────────────────────────────────────
    if (auto xorOp = dyn_cast<LLVM::XOrOp>(defOp)) {
        auto lhs = buildExpression(xorOp.getLhs());
        auto rhs = buildExpression(xorOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::BitXor, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.shl ──────────────────────────────────────────────────────
    if (auto shlOp = dyn_cast<LLVM::ShlOp>(defOp)) {
        auto lhs = buildExpression(shlOp.getLhs());
        auto rhs = buildExpression(shlOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Shl, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.lshr ─────────────────────────────────────────────────────
    if (auto lshrOp = dyn_cast<LLVM::LShrOp>(defOp)) {
        auto lhs = buildExpression(lshrOp.getLhs());
        auto rhs = buildExpression(lshrOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Shr, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.ashr ─────────────────────────────────────────────────────
    if (auto ashrOp = dyn_cast<LLVM::AShrOp>(defOp)) {
        auto lhs = buildExpression(ashrOp.getLhs());
        auto rhs = buildExpression(ashrOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Sar, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.icmp ─────────────────────────────────────────────────────
    if (auto icmp = dyn_cast<LLVM::ICmpOp>(defOp)) {
        auto lhs = buildExpression(icmp.getLhs());
        auto rhs = buildExpression(icmp.getRhs());
        auto cmpOp = mapLLVMICmpPred(icmp.getPredicate());
        return std::make_unique<CBinaryExpr>(
            cmpOp, std::move(lhs), std::move(rhs),
            CType::boolTy(), addr);
    }

    // ─── llvm.select ───────────────────────────────────────────────────
    if (auto sel = dyn_cast<LLVM::SelectOp>(defOp)) {
        auto cond = buildExpression(sel.getCondition());
        auto trueVal = buildExpression(sel.getTrueValue());
        auto falseVal = buildExpression(sel.getFalseValue());
        return std::make_unique<CTernaryExpr>(
            std::move(cond), std::move(trueVal), std::move(falseVal),
            convertType(val.getType()), addr);
    }

    // ─── llvm.zext ─────────────────────────────────────────────────────
    if (auto zextOp = dyn_cast<LLVM::ZExtOp>(defOp)) {
        if (zextOp.getArg().getType() == zextOp.getResult().getType())
            return buildExpression(zextOp.getArg());
        auto operand = buildExpression(zextOp.getArg());
        return std::make_unique<CCastExpr>(
            convertType(zextOp.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── llvm.sext ─────────────────────────────────────────────────────
    if (auto sextOp = dyn_cast<LLVM::SExtOp>(defOp)) {
        if (sextOp.getArg().getType() == sextOp.getResult().getType())
            return buildExpression(sextOp.getArg());
        auto operand = buildExpression(sextOp.getArg());
        return std::make_unique<CCastExpr>(
            convertType(sextOp.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── llvm.trunc ────────────────────────────────────────────────────
    if (auto truncOp = dyn_cast<LLVM::TruncOp>(defOp)) {
        if (truncOp.getArg().getType() == truncOp.getResult().getType())
            return buildExpression(truncOp.getArg());
        auto operand = buildExpression(truncOp.getArg());
        return std::make_unique<CCastExpr>(
            convertType(truncOp.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── llvm.inttoptr ─────────────────────────────────────────────────
    if (auto i2p = dyn_cast<LLVM::IntToPtrOp>(defOp)) {
        auto operand = buildExpression(i2p.getArg());
        return std::make_unique<CCastExpr>(
            CType::voidPtr(), std::move(operand), addr);
    }

    // ─── llvm.ptrtoint ─────────────────────────────────────────────────
    if (auto p2i = dyn_cast<LLVM::PtrToIntOp>(defOp)) {
        auto operand = buildExpression(p2i.getArg());
        return std::make_unique<CCastExpr>(
            convertType(p2i.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── llvm.fadd ─────────────────────────────────────────────────────
    if (auto faddOp = dyn_cast<LLVM::FAddOp>(defOp)) {
        auto lhs = buildExpression(faddOp.getLhs());
        auto rhs = buildExpression(faddOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Add, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.fsub ─────────────────────────────────────────────────────
    if (auto fsubOp = dyn_cast<LLVM::FSubOp>(defOp)) {
        auto lhs = buildExpression(fsubOp.getLhs());
        auto rhs = buildExpression(fsubOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Sub, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.fmul ─────────────────────────────────────────────────────
    if (auto fmulOp = dyn_cast<LLVM::FMulOp>(defOp)) {
        auto lhs = buildExpression(fmulOp.getLhs());
        auto rhs = buildExpression(fmulOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Mul, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.fdiv ─────────────────────────────────────────────────────
    if (auto fdivOp = dyn_cast<LLVM::FDivOp>(defOp)) {
        auto lhs = buildExpression(fdivOp.getLhs());
        auto rhs = buildExpression(fdivOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Div, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.frem ─────────────────────────────────────────────────────
    if (auto fremOp = dyn_cast<LLVM::FRemOp>(defOp)) {
        auto lhs = buildExpression(fremOp.getLhs());
        auto rhs = buildExpression(fremOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Mod, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── llvm.fneg ─────────────────────────────────────────────────────
    if (auto fnegOp = dyn_cast<LLVM::FNegOp>(defOp)) {
        auto operand = buildExpression(fnegOp.getOperand());
        return std::make_unique<CUnaryExpr>(
            UnaryOp::Neg, std::move(operand),
            convertType(val.getType()), addr);
    }

    // ─── llvm.fcmp ─────────────────────────────────────────────────────
    if (auto fcmp = dyn_cast<LLVM::FCmpOp>(defOp)) {
        auto lhs = buildExpression(fcmp.getLhs());
        auto rhs = buildExpression(fcmp.getRhs());
        BinaryOp cmpOp = BinaryOp::Eq;
        switch (fcmp.getPredicate()) {
        case LLVM::FCmpPredicate::oeq:
        case LLVM::FCmpPredicate::ueq: cmpOp = BinaryOp::Eq; break;
        case LLVM::FCmpPredicate::one:
        case LLVM::FCmpPredicate::une: cmpOp = BinaryOp::Ne; break;
        case LLVM::FCmpPredicate::olt:
        case LLVM::FCmpPredicate::ult: cmpOp = BinaryOp::Lt; break;
        case LLVM::FCmpPredicate::ole:
        case LLVM::FCmpPredicate::ule: cmpOp = BinaryOp::Le; break;
        case LLVM::FCmpPredicate::ogt:
        case LLVM::FCmpPredicate::ugt: cmpOp = BinaryOp::Gt; break;
        case LLVM::FCmpPredicate::oge:
        case LLVM::FCmpPredicate::uge: cmpOp = BinaryOp::Ge; break;
        default: cmpOp = BinaryOp::Ne; break;
        }
        return std::make_unique<CBinaryExpr>(
            cmpOp, std::move(lhs), std::move(rhs),
            CType::boolTy(), addr);
    }

    // ─── llvm.fpext ────────────────────────────────────────────────────
    if (auto fpextOp = dyn_cast<LLVM::FPExtOp>(defOp)) {
        auto operand = buildExpression(fpextOp.getArg());
        return std::make_unique<CCastExpr>(
            convertType(fpextOp.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── llvm.fptrunc ──────────────────────────────────────────────────
    if (auto fptruncOp = dyn_cast<LLVM::FPTruncOp>(defOp)) {
        auto operand = buildExpression(fptruncOp.getArg());
        return std::make_unique<CCastExpr>(
            convertType(fptruncOp.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── llvm.sitofp ───────────────────────────────────────────────────
    if (auto sitofp = dyn_cast<LLVM::SIToFPOp>(defOp)) {
        auto operand = buildExpression(sitofp.getArg());
        return std::make_unique<CCastExpr>(
            convertType(sitofp.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── llvm.uitofp ───────────────────────────────────────────────────
    if (auto uitofp = dyn_cast<LLVM::UIToFPOp>(defOp)) {
        auto operand = buildExpression(uitofp.getArg());
        return std::make_unique<CCastExpr>(
            convertType(uitofp.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── llvm.fptosi ───────────────────────────────────────────────────
    if (auto fptosi = dyn_cast<LLVM::FPToSIOp>(defOp)) {
        auto operand = buildExpression(fptosi.getArg());
        return std::make_unique<CCastExpr>(
            convertType(fptosi.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── llvm.fptoui ───────────────────────────────────────────────────
    if (auto fptoui = dyn_cast<LLVM::FPToUIOp>(defOp)) {
        auto operand = buildExpression(fptoui.getArg());
        return std::make_unique<CCastExpr>(
            convertType(fptoui.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── llvm.extractelement ───────────────────────────────────────────
    if (auto extract = dyn_cast<LLVM::ExtractElementOp>(defOp)) {
        auto vec = buildExpression(extract.getVector());
        auto idx = buildExpression(extract.getPosition());
        return std::make_unique<CSubscriptExpr>(
            std::move(vec), std::move(idx),
            convertType(val.getType()), addr);
    }

    // ─── llvm.insertelement ────────────────────────────────────────────
    if (auto insert = dyn_cast<LLVM::InsertElementOp>(defOp)) {
        // Simplified: treat as the inserted value (best effort for decompilation)
        return buildExpression(insert.getValue());
    }

    // ─── llvm.shufflevector ────────────────────────────────────────────
    if (auto shuffle = dyn_cast<LLVM::ShuffleVectorOp>(defOp)) {
        // Simplified: return the first vector operand (common case: broadcast/splat)
        return buildExpression(shuffle.getV1());
    }

    // ─── llvm.bitcast ──────────────────────────────────────────────────
    if (auto bitcast = dyn_cast<LLVM::BitcastOp>(defOp)) {
        auto operand = buildExpression(bitcast.getArg());
        return std::make_unique<CCastExpr>(
            convertType(bitcast.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── llvm.freeze ───────────────────────────────────────────────────
    if (auto freeze = dyn_cast<LLVM::FreezeOp>(defOp)) {
        // Freeze is a no-op for decompilation purposes
        return buildExpression(freeze.getVal());
    }

    // ─── llvm.load ─────────────────────────────────────────────────────
    if (auto load = dyn_cast<LLVM::LoadOp>(defOp)) {
        auto addrExpr = buildExpression(load.getAddr());
        return std::make_unique<CUnaryExpr>(
            UnaryOp::Deref, std::move(addrExpr),
            convertType(val.getType()), addr);
    }

    // ─── llvm.gep ──────────────────────────────────────────────────────
    if (auto gep = dyn_cast<LLVM::GEPOp>(defOp)) {
        auto base = buildExpression(gep.getBase());
        auto dynIndices = gep.getDynamicIndices();
        if (dynIndices.empty())
            return base;
        // Simplified: base + sum of indices
        ExprPtr result = std::move(base);
        for (auto idx : dynIndices) {
            auto indexExpr = buildExpression(idx);
            result = std::make_unique<CBinaryExpr>(
                BinaryOp::Add, std::move(result), std::move(indexExpr),
                convertType(val.getType()), addr);
        }
        return result;
    }

    // ─── llvm.extractvalue ─────────────────────────────────────────────
    if (auto ev = dyn_cast<LLVM::ExtractValueOp>(defOp)) {
        auto container = buildExpression(ev.getContainer());
        auto pos = ev.getPosition();
        ExprPtr result = std::move(container);
        for (auto idx : pos) {
            result = std::make_unique<CFieldAccessExpr>(
                std::move(result), std::format("field{}", idx), idx,
                /*isPointer=*/false, convertType(val.getType()), addr);
        }
        return result;
    }

    // ─── llvm.alloca ───────────────────────────────────────────────────
    if (isa<LLVM::AllocaOp>(defOp)) {
        return std::make_unique<CVarRefExpr>(
            0, "__stack_alloca", convertType(val.getType()), addr);
    }

    // ─── llvm.call (expression context) ─────────────────────────────────
    if (auto call = dyn_cast<LLVM::CallOp>(defOp)) {
        std::string calleeName;
        if (auto callee = call.getCallee())
            calleeName = callee->str();
        else
            calleeName = "/* indirect */";

        // Remill memory read intrinsics → *(type*)addr
        // __remill_read_memory_f32(state, addr) → *(float*)addr
        // __remill_read_memory_f64(state, addr) → *(double*)addr
        // __remill_read_memory_32(state, addr) → *(int32_t*)addr
        // __remill_read_memory_64(state, addr) → *(int64_t*)addr
        if (calleeName.starts_with("__remill_read_memory_")) {
            CTypePtr ptrType;
            if (calleeName.find("f32") != std::string::npos)
                ptrType = CType::floatTy();
            else if (calleeName.find("f64") != std::string::npos)
                ptrType = CType::doubleTy();
            else if (calleeName.find("_8") != std::string::npos)
                ptrType = CType::int8();
            else if (calleeName.find("_16") != std::string::npos)
                ptrType = CType::int16();
            else if (calleeName.find("_32") != std::string::npos)
                ptrType = CType::int32();
            else
                ptrType = CType::int64();

            // Second operand is the address (first is the state pointer)
            if (call.getNumOperands() >= 2) {
                auto addrExpr = buildExpression(call.getOperand(1));
                auto castAddr = std::make_unique<CCastExpr>(
                    CType::pointerTo(ptrType), std::move(addrExpr), addr);
                return std::make_unique<CUnaryExpr>(
                    UnaryOp::Deref, std::move(castAddr), ptrType, addr);
            }
        }

        // Remill memory write intrinsics → *(type*)addr = val (return state)
        // These appear as expressions sometimes (chained writes return state)
        // __remill_write_memory_f32(state, addr, val) → state after *(float*)addr = val
        // In expression context, just pass through as the state pointer
        if (calleeName.starts_with("__remill_write_memory_")) {
            // In expression context, the return is the state — pass first arg through
            if (call.getNumOperands() >= 1)
                return buildExpression(call.getOperand(0));
        }

        // __remill_flag_computation_* intrinsics → skip/simplify
        if (calleeName.starts_with("__remill_flag_computation") ||
            calleeName.starts_with("__remill_compare") ||
            calleeName == "__remill_undefined_8" ||
            calleeName == "__remill_undefined_16" ||
            calleeName == "__remill_undefined_32" ||
            calleeName == "__remill_undefined_64") {
            return std::make_unique<CIntLitExpr>(0, convertType(val.getType()), addr);
        }

        std::vector<ExprPtr> callArgs;
        for (unsigned i = 0; i < call.getNumOperands(); i++) {
            auto argExpr = buildExpression(call.getOperand(i));
            if (argExpr)
                callArgs.push_back(std::move(argExpr));
        }
        return std::make_unique<CCallExpr>(
            calleeName, 0, std::move(callArgs),
            convertType(val.getType()), addr);
    }

    // ═════════════════════════════════════════════════════════════════════
    // Arith Dialect expressions
    // ═════════════════════════════════════════════════════════════════════

    // ─── arith.constant ────────────────────────────────────────────────
    if (auto arithConst = dyn_cast<arith::ConstantOp>(defOp)) {
        if (auto intAttr = dyn_cast<IntegerAttr>(arithConst.getValue())) {
            return std::make_unique<CIntLitExpr>(
                intAttr.getValue().getSExtValue(),
                convertType(arithConst.getType()), addr);
        }
        if (auto floatAttr = dyn_cast<FloatAttr>(arithConst.getValue())) {
            return std::make_unique<CFloatLitExpr>(
                floatAttr.getValueAsDouble(),
                convertType(arithConst.getType()), addr);
        }
        return std::make_unique<CIntLitExpr>(
            0, convertType(arithConst.getType()), addr);
    }

    // ─── arith.addi ────────────────────────────────────────────────────
    if (auto addOp = dyn_cast<arith::AddIOp>(defOp)) {
        auto lhs = buildExpression(addOp.getLhs());
        auto rhs = buildExpression(addOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Add, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.subi ────────────────────────────────────────────────────
    if (auto subOp = dyn_cast<arith::SubIOp>(defOp)) {
        auto lhs = buildExpression(subOp.getLhs());
        auto rhs = buildExpression(subOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Sub, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.muli ────────────────────────────────────────────────────
    if (auto mulOp = dyn_cast<arith::MulIOp>(defOp)) {
        auto lhs = buildExpression(mulOp.getLhs());
        auto rhs = buildExpression(mulOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Mul, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.divsi ───────────────────────────────────────────────────
    if (auto divOp = dyn_cast<arith::DivSIOp>(defOp)) {
        auto lhs = buildExpression(divOp.getLhs());
        auto rhs = buildExpression(divOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Div, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.divui ───────────────────────────────────────────────────
    if (auto divOp = dyn_cast<arith::DivUIOp>(defOp)) {
        auto lhs = buildExpression(divOp.getLhs());
        auto rhs = buildExpression(divOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Div, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.remsi ───────────────────────────────────────────────────
    if (auto remOp = dyn_cast<arith::RemSIOp>(defOp)) {
        auto lhs = buildExpression(remOp.getLhs());
        auto rhs = buildExpression(remOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Mod, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.remui ───────────────────────────────────────────────────
    if (auto remOp = dyn_cast<arith::RemUIOp>(defOp)) {
        auto lhs = buildExpression(remOp.getLhs());
        auto rhs = buildExpression(remOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Mod, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.andi ────────────────────────────────────────────────────
    if (auto andOp = dyn_cast<arith::AndIOp>(defOp)) {
        auto lhs = buildExpression(andOp.getLhs());
        auto rhs = buildExpression(andOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::BitAnd, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.ori ─────────────────────────────────────────────────────
    if (auto orOp = dyn_cast<arith::OrIOp>(defOp)) {
        auto lhs = buildExpression(orOp.getLhs());
        auto rhs = buildExpression(orOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::BitOr, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.xori ────────────────────────────────────────────────────
    if (auto xorOp = dyn_cast<arith::XOrIOp>(defOp)) {
        auto lhs = buildExpression(xorOp.getLhs());
        auto rhs = buildExpression(xorOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::BitXor, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.shli ────────────────────────────────────────────────────
    if (auto shlOp = dyn_cast<arith::ShLIOp>(defOp)) {
        auto lhs = buildExpression(shlOp.getLhs());
        auto rhs = buildExpression(shlOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Shl, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.shrui ───────────────────────────────────────────────────
    if (auto shrOp = dyn_cast<arith::ShRUIOp>(defOp)) {
        auto lhs = buildExpression(shrOp.getLhs());
        auto rhs = buildExpression(shrOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Shr, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.shrsi ───────────────────────────────────────────────────
    if (auto shrOp = dyn_cast<arith::ShRSIOp>(defOp)) {
        auto lhs = buildExpression(shrOp.getLhs());
        auto rhs = buildExpression(shrOp.getRhs());
        return std::make_unique<CBinaryExpr>(
            BinaryOp::Sar, std::move(lhs), std::move(rhs),
            convertType(val.getType()), addr);
    }

    // ─── arith.cmpi ────────────────────────────────────────────────────
    if (auto cmpOp = dyn_cast<arith::CmpIOp>(defOp)) {
        auto lhs = buildExpression(cmpOp.getLhs());
        auto rhs = buildExpression(cmpOp.getRhs());
        auto op = mapArithCmpIPred(cmpOp.getPredicate());
        return std::make_unique<CBinaryExpr>(
            op, std::move(lhs), std::move(rhs),
            CType::boolTy(), addr);
    }

    // ─── arith.extui ───────────────────────────────────────────────────
    if (auto extOp = dyn_cast<arith::ExtUIOp>(defOp)) {
        if (extOp.getIn().getType() == extOp.getResult().getType())
            return buildExpression(extOp.getIn());
        auto operand = buildExpression(extOp.getIn());
        return std::make_unique<CCastExpr>(
            convertType(extOp.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── arith.extsi ───────────────────────────────────────────────────
    if (auto extOp = dyn_cast<arith::ExtSIOp>(defOp)) {
        if (extOp.getIn().getType() == extOp.getResult().getType())
            return buildExpression(extOp.getIn());
        auto operand = buildExpression(extOp.getIn());
        return std::make_unique<CCastExpr>(
            convertType(extOp.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── arith.trunci ──────────────────────────────────────────────────
    if (auto truncOp = dyn_cast<arith::TruncIOp>(defOp)) {
        if (truncOp.getIn().getType() == truncOp.getResult().getType())
            return buildExpression(truncOp.getIn());
        auto operand = buildExpression(truncOp.getIn());
        return std::make_unique<CCastExpr>(
            convertType(truncOp.getResult().getType()),
            std::move(operand), addr);
    }

    // ─── arith.select ──────────────────────────────────────────────────
    if (auto sel = dyn_cast<arith::SelectOp>(defOp)) {
        auto cond = buildExpression(sel.getCondition());
        auto trueVal = buildExpression(sel.getTrueValue());
        auto falseVal = buildExpression(sel.getFalseValue());
        return std::make_unique<CTernaryExpr>(
            std::move(cond), std::move(trueVal), std::move(falseVal),
            convertType(val.getType()), addr);
    }

    // ─── llvm.intr.* (LLVM intrinsics) ─────────────────────────────────
    //
    // Generic dispatch for LLVM intrinsics by op name.  Maps the
    // intrinsic name to a readable C function name and renders as a
    // CCallExpr with the operands as arguments.
    {
        auto opName = defOp->getName().getStringRef();
        if (opName.starts_with("llvm.intr.")) {
            auto intrName = opName.drop_front(10).str();  // strip "llvm.intr."
            // Map common intrinsics to standard C library functions.
            static const llvm::StringMap<std::string> kIntrMap = {
                {"fabs",     "fabs"},
                {"sqrt",     "sqrt"},
                {"sin",      "sin"},
                {"cos",      "cos"},
                {"tan",      "tan"},
                {"exp",      "exp"},
                {"exp2",     "exp2"},
                {"log",      "log"},
                {"log2",     "log2"},
                {"log10",    "log10"},
                {"pow",      "pow"},
                {"powi",     "pow"},
                {"trunc",    "trunc"},
                {"floor",    "floor"},
                {"ceil",     "ceil"},
                {"round",    "round"},
                {"rint",     "rint"},
                {"nearbyint", "nearbyint"},
                {"copysign", "copysign"},
                {"fma",      "fma"},
                {"fmuladd",  "fma"},
                {"minnum",   "fmin"},
                {"maxnum",   "fmax"},
                {"minimum",  "fmin"},
                {"maximum",  "fmax"},
                {"abs",      "abs"},
                {"smax",     "max"},
                {"smin",     "min"},
                {"umax",     "max"},
                {"umin",     "min"},
                {"bswap",    "__builtin_bswap"},
                {"ctpop",    "popcount"},
                {"cttz",     "count_trailing_zeros"},
                {"ctlz",     "count_leading_zeros"},
                {"bitreverse", "bit_reverse"},
                {"memcpy",   "memcpy"},
                {"memmove",  "memmove"},
                {"memset",   "memset"},
                {"prefetch", "__builtin_prefetch"},
                {"expect",   "__builtin_expect"},
                {"assume",   "__builtin_assume"},
                {"trap",     "__builtin_trap"},
                {"debugtrap","__builtin_debugtrap"},
                {"ssub.with.overflow", "__builtin_ssub_overflow"},
                {"sadd.with.overflow", "__builtin_sadd_overflow"},
                {"smul.with.overflow", "__builtin_smul_overflow"},
                {"usub.with.overflow", "__builtin_usub_overflow"},
                {"uadd.with.overflow", "__builtin_uadd_overflow"},
                {"umul.with.overflow", "__builtin_umul_overflow"},
            };
            std::string callName;
            auto it = kIntrMap.find(intrName);
            if (it != kIntrMap.end()) {
                callName = it->second;
            } else {
                // Unknown intrinsic — keep the name with __builtin_ prefix
                // so it's still recognizable.
                callName = "__builtin_" + intrName;
                // Replace dots with underscores for valid C identifier.
                for (auto& c : callName)
                    if (c == '.') c = '_';
            }

            // Build call args from the op's operands.
            std::vector<ExprPtr> args;
            for (auto operand : defOp->getOperands())
                args.push_back(buildExpression(operand));

            return std::make_unique<CCallExpr>(
                std::move(callName),
                /*targetAddr=*/0,
                std::move(args),
                convertType(val.getType()),
                addr);
        }
    }

    // ─── Unknown → __helix_unhandled_<opname>(operands...) ──────────────
    //
    // FIX-084 (RetDec-inspired, expression-side):  Previously emitted a
    // bare CVarRefExpr like `__unknown_helix_high_foo` which silently
    // dropped every operand and made it impossible to tell which values
    // were consumed by the unknown op.  Emitting a CCallExpr preserves
    // operand liveness so subsequent DSE / copy-prop passes correctly
    // keep their defining stores live.
    {
        auto callName =
            "__helix_unhandled_" + defOp->getName().getStringRef().str();
        for (auto& c : callName)
            if (c == '.') c = '_';

        std::vector<ExprPtr> args;
        for (Value operand : defOp->getOperands()) {
            if (auto expr = buildExpression(operand))
                args.push_back(std::move(expr));
        }
        return std::make_unique<CCallExpr>(
            std::move(callName), /*targetAddr=*/0, std::move(args),
            convertType(val.getType()), addr);
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Type conversion
// ═══════════════════════════════════════════════════════════════════════════════

CTypePtr CAstBuilder::convertType(Type type) {
    // HelixHigh CTypeType
    if (auto ctype = dyn_cast<helix::high::CTypeType>(type)) {
        auto kind = ctype.getKind();
        bool isSigned = ctype.getIsSigned();
        unsigned bitWidth = ctype.getBitWidth();

        switch (kind) {
        case helix::high::TypeKind::Void:
            return CType::voidTy();
        case helix::high::TypeKind::Bool:
            return CType::boolTy();
        case helix::high::TypeKind::Int:
            if (isSigned) {
                switch (bitWidth) {
                case 8:  return CType::int8();
                case 16: return CType::int16();
                case 32: return CType::int32();
                case 64: return CType::int64();
                default: return CType::int64();
                }
            } else {
                switch (bitWidth) {
                case 8:  return CType::uint8();
                case 16: return CType::uint16();
                case 32: return CType::uint32();
                case 64: return CType::uint64();
                default: return CType::uint64();
                }
            }
        case helix::high::TypeKind::Float:
            return (bitWidth == 32) ? CType::floatTy() : CType::doubleTy();
        case helix::high::TypeKind::Pointer:
            return CType::voidPtr();
        case helix::high::TypeKind::Array:
            return CType::arrayOf(CType::unknownTy());
        case helix::high::TypeKind::Struct: {
            std::string structName;
            if (auto nameAttr = ctype.getStructName())
                structName = nameAttr.str();
            return CType::structTy(structName);
        }
        case helix::high::TypeKind::Union:
            return CType::unknownTy();
        case helix::high::TypeKind::FuncPtr:
            return CType::voidPtr();
        case helix::high::TypeKind::Unknown:
            return CType::unknownTy();
        }
    }

    // MLIR IntegerType
    if (auto intTy = dyn_cast<IntegerType>(type)) {
        unsigned width = intTy.getWidth();
        switch (width) {
        case 1:  return CType::boolTy();
        case 8:  return CType::int8();
        case 16: return CType::int16();
        case 32: return CType::int32();
        case 64: return CType::int64();
        default: return CType::int64();
        }
    }

    // MLIR Float types
    if (isa<Float32Type>(type))
        return CType::floatTy();
    if (isa<Float64Type>(type))
        return CType::doubleTy();

    // MLIR Float16 type
    if (isa<Float16Type>(type))
        return CType::floatTy();

    // LLVM Pointer type
    if (isa<LLVM::LLVMPointerType>(type))
        return CType::voidPtr();

    // LLVM FixedVectorType — flatten to element type for decompilation
    if (auto vecTy = dyn_cast<LLVM::LLVMFixedVectorType>(type)) {
        return convertType(vecTy.getElementType());
    }

    // MLIR VectorType — flatten to element type
    if (auto vecTy = dyn_cast<VectorType>(type)) {
        return convertType(vecTy.getElementType());
    }

    // MLIR IndexType
    if (isa<IndexType>(type))
        return CType::int64();

    // MLIR NoneType
    if (isa<NoneType>(type))
        return CType::voidTy();

    return CType::unknownTy();
}

// ═══════════════════════════════════════════════════════════════════════════════
// Filtering
// ═══════════════════════════════════════════════════════════════════════════════

bool CAstBuilder::shouldSkip(Operation* op) {
    if (!op)
        return true;

    // Infrastructure attribute
    if (op->hasAttr("helix.infrastructure"))
        return true;

    // Dead stores
    if (deadStoreOps_.contains(op))
        return true;

    // Prologue/epilogue artifacts
    if (isPrologueArtifact(op))
        return true;

    // VarDeclOp (already collected at function level)
    if (isa<helix::high::VarDeclOp>(op))
        return true;

    // YieldOp (region terminator, not a statement)
    if (isa<helix::high::YieldOp>(op))
        return true;

    // Pure expression-producing HelixHigh ops (consumed via buildExpression)
    if (isa<helix::high::VarRefOp>(op) ||
        isa<helix::high::IntLitOp>(op) ||
        isa<helix::high::FloatLitOp>(op) ||
        isa<helix::high::StringLitOp>(op) ||
        isa<helix::high::AddrLitOp>(op) ||
        isa<helix::high::BinaryOp>(op) ||
        isa<helix::high::UnaryOp>(op) ||
        isa<helix::high::CastOp>(op) ||
        isa<helix::high::TernaryOp>(op) ||
        isa<helix::high::SubscriptOp>(op) ||
        isa<helix::high::FieldAccessOp>(op))
        return true;

    // Pure expression-producing HelixMid ops
    if (isa<helix::mid::ConstantOp>(op) ||
        isa<helix::mid::VarRefOp>(op) ||
        isa<helix::mid::BinExprOp>(op) ||
        isa<helix::mid::UnExprOp>(op) ||
        isa<helix::mid::CastOp>(op) ||
        isa<helix::mid::LoadOp>(op) ||
        isa<helix::mid::SelectOp>(op) ||
        isa<helix::mid::FieldPtrOp>(op) ||
        isa<helix::mid::IndexPtrOp>(op) ||
        isa<helix::mid::AddrConstOp>(op))
        return true;

    // HelixMid VarDeclOp (already handled at function level)
    if (isa<helix::mid::VarDeclOp>(op))
        return true;

    // HelixMid YieldOp (region terminator)
    if (isa<helix::mid::YieldOp>(op))
        return true;

    // Pure expression-producing HelixLow ops
    if (isa<helix::low::RegReadOp>(op) ||
        isa<helix::low::MemReadOp>(op) ||
        isa<helix::low::BinOp>(op) ||
        isa<helix::low::UnaryOp>(op) ||
        isa<helix::low::CMovOp>(op) ||
        isa<helix::low::MovZxOp>(op) ||
        isa<helix::low::MovSxOp>(op) ||
        isa<helix::low::LeaOp>(op))
        return true;

    // Pure expression-producing LLVM dialect ops
    if (isa<LLVM::ConstantOp>(op) || isa<LLVM::UndefOp>(op) ||
        isa<LLVM::AddOp>(op) || isa<LLVM::SubOp>(op) ||
        isa<LLVM::MulOp>(op) || isa<LLVM::UDivOp>(op) ||
        isa<LLVM::SDivOp>(op) || isa<LLVM::URemOp>(op) ||
        isa<LLVM::SRemOp>(op) ||
        isa<LLVM::AndOp>(op) || isa<LLVM::OrOp>(op) ||
        isa<LLVM::XOrOp>(op) ||
        isa<LLVM::ShlOp>(op) || isa<LLVM::LShrOp>(op) ||
        isa<LLVM::AShrOp>(op) ||
        isa<LLVM::ICmpOp>(op) || isa<LLVM::SelectOp>(op) ||
        isa<LLVM::ZExtOp>(op) || isa<LLVM::SExtOp>(op) ||
        isa<LLVM::TruncOp>(op) ||
        isa<LLVM::IntToPtrOp>(op) || isa<LLVM::PtrToIntOp>(op) ||
        isa<LLVM::LoadOp>(op) || isa<LLVM::GEPOp>(op) ||
        isa<LLVM::ExtractValueOp>(op) || isa<LLVM::AllocaOp>(op) ||
        // Floating-point ops
        isa<LLVM::FAddOp>(op) || isa<LLVM::FSubOp>(op) ||
        isa<LLVM::FMulOp>(op) || isa<LLVM::FDivOp>(op) ||
        isa<LLVM::FRemOp>(op) || isa<LLVM::FNegOp>(op) ||
        isa<LLVM::FCmpOp>(op) ||
        // FP conversions
        isa<LLVM::FPExtOp>(op) || isa<LLVM::FPTruncOp>(op) ||
        isa<LLVM::SIToFPOp>(op) || isa<LLVM::UIToFPOp>(op) ||
        isa<LLVM::FPToSIOp>(op) || isa<LLVM::FPToUIOp>(op) ||
        // Vector ops
        isa<LLVM::ExtractElementOp>(op) || isa<LLVM::InsertElementOp>(op) ||
        isa<LLVM::ShuffleVectorOp>(op) ||
        // Misc
        isa<LLVM::BitcastOp>(op) || isa<LLVM::FreezeOp>(op))
        return true;

    // Pure expression-producing arith dialect ops
    if (isa<arith::ConstantOp>(op) ||
        isa<arith::AddIOp>(op) || isa<arith::SubIOp>(op) ||
        isa<arith::MulIOp>(op) ||
        isa<arith::DivSIOp>(op) || isa<arith::DivUIOp>(op) ||
        isa<arith::RemSIOp>(op) || isa<arith::RemUIOp>(op) ||
        isa<arith::AndIOp>(op) || isa<arith::OrIOp>(op) ||
        isa<arith::XOrIOp>(op) ||
        isa<arith::ShLIOp>(op) || isa<arith::ShRUIOp>(op) ||
        isa<arith::ShRSIOp>(op) ||
        isa<arith::CmpIOp>(op) ||
        isa<arith::ExtUIOp>(op) || isa<arith::ExtSIOp>(op) ||
        isa<arith::TruncIOp>(op) ||
        isa<arith::SelectOp>(op))
        return true;

    // HelixLow flag-setting ops (no visible statement)
    if (isa<helix::low::CmpOp>(op) || isa<helix::low::TestOp>(op))
        return true;

    // HelixLow prologue/epilogue artifacts
    if (isa<helix::low::PushOp>(op) || isa<helix::low::PopOp>(op))
        return true;

    // HelixLow nop
    if (isa<helix::low::NopOp>(op))
        return true;

    // HelixLow block terminators (handled by region walking).
    // FIX-053 (Wave 12 REVERT of FIX-051): restored the pre-FIX-051
    // blanket skip.  Forwarding JmpOp/JccOp through buildStatement
    // emitted gotos in parallel with StructureControlFlow rather than
    // as a true fallback, regressing live IDE output to goto-soup on
    // every function with non-trivial CFG.  Reintroduction is gated
    // on SAILR ISD/ISC consolidation (tracked as Wave 14 plan in
    // docs/AgentsNoGit/RESEARCH_HELIX_VS_IDA_GAP.md §8).
    if (isa<helix::low::JmpOp>(op) || isa<helix::low::JccOp>(op))
        return true;

    return false;
}

bool CAstBuilder::isPrologueArtifact(Operation* op) {
    // HelixLow push/pop → always prologue/epilogue
    if (isa<helix::low::PushOp>(op) || isa<helix::low::PopOp>(op))
        return true;

    // HelixHigh AssignOp: rbp = rsp or rsp = rbp
    if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
        auto* targetDef = assign.getTarget().getDefiningOp();
        auto* valueDef = assign.getValue().getDefiningOp();
        if (!targetDef || !valueDef)
            return false;

        auto targetRef = dyn_cast<helix::high::VarRefOp>(targetDef);
        auto valueRef = dyn_cast<helix::high::VarRefOp>(valueDef);
        if (!targetRef || !valueRef)
            return false;

        auto target = targetRef.getVarName();
        auto value = valueRef.getVarName();

        // Frame pointer setup/teardown
        if ((target == "rbp" && value == "rsp") ||
            (target == "rsp" && value == "rbp"))
            return true;
    }

    return false;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Copy propagation & naming
// ═══════════════════════════════════════════════════════════════════════════════

std::string CAstBuilder::resolveTransitive(const std::string& name) const {
    std::string current = name;
    std::unordered_set<std::string> visited;
    constexpr unsigned kMaxHops = 5;
    unsigned hops = 0;

    while (hops < kMaxHops) {
        if (visited.count(current))
            break;
        visited.insert(current);

        auto it = lastRegValue_.find(current);
        if (it == lastRegValue_.end())
            break;

        if (it->second == current)
            break;

        // Defensive: never resolve to the "__expr" placeholder.  exprToString
        // emits this when an expression can't be represented as a flat
        // identifier (binop, call, field access, etc.).  Returning it would
        // print the literal string "__expr" in the output.
        if (it->second == "__expr")
            break;

        if (it->second.find(current) != std::string::npos &&
            it->second != current)
            break;

        if (!isSyntheticTemporaryName(it->second) &&
            !isSyntheticValueName(it->second)) {
            current = it->second;
            break;
        }

        current = it->second;
        ++hops;
    }

    return current;
}

std::string CAstBuilder::applyNameAliases(std::string name) const {
    auto it = nameAliases_.find(name);
    if (it != nameAliases_.end())
        return it->second;
    return name;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Compound assignment detection
// ═══════════════════════════════════════════════════════════════════════════════

std::string CAstBuilder::detectCompoundOp(Operation* assignOp,
                                           const std::string& targetName) {
    auto assign = dyn_cast<helix::high::AssignOp>(assignOp);
    if (!assign)
        return "";

    auto highBin =
        assign.getValue().getDefiningOp<helix::high::BinaryOp>();
    if (!highBin)
        return "";

    auto kind = highBin.getOp();
    const char* compoundOp = getCompoundOp(kind);
    if (!compoundOp)
        return "";

    // Check if LHS of binary matches the assign target
    std::string lhsName;
    if (auto lhsRef =
            highBin.getLhs().getDefiningOp<helix::high::VarRefOp>())
        lhsName = applyNameAliases(lhsRef.getVarName().str());

    std::string rhsName;
    if (auto rhsRef =
            highBin.getRhs().getDefiningOp<helix::high::VarRefOp>())
        rhsName = applyNameAliases(rhsRef.getVarName().str());

    bool lhsMatch = (lhsName == targetName);
    bool rhsMatch =
        !lhsMatch && isCommutativeOp(kind) && (rhsName == targetName);

    if (!lhsMatch && !rhsMatch)
        return "";

    // Special-case: x = x + 1 → "++" and x = x - 1 → "--"
    if (lhsMatch &&
        (kind == helix::high::BinaryOpKind::Add ||
         kind == helix::high::BinaryOpKind::Sub)) {
        Value otherVal = highBin.getRhs();
        auto rhsLit = tryExtractIntLiteral(otherVal);
        if (rhsLit && *rhsLit == 1) {
            return (kind == helix::high::BinaryOpKind::Add) ? "++" : "--";
        }
    }

    return compoundOp;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Address extraction
// ═══════════════════════════════════════════════════════════════════════════════

uint64_t CAstBuilder::extractAddress(Operation* op) const {
    if (!op)
        return 0;
    if (auto addrAttr = op->getAttrOfType<IntegerAttr>("address"))
        return addrAttr.getUInt();
    return 0;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pre-scans
// ═══════════════════════════════════════════════════════════════════════════════

void CAstBuilder::precomputeVarUseCounts(Operation* funcOp) {
    varUseCount_.clear();

    funcOp->walk([&](helix::high::VarRefOp ref) {
        auto name = applyNameAliases(ref.getVarName().str());
        ++varUseCount_[name];
    });
}

std::unordered_set<Operation*>
CAstBuilder::precomputeDeadStores(Block& block) {
    std::unordered_set<Operation*> deadOps;
    std::unordered_set<std::string> writtenNotRead;

    // Collect operation pointers for reverse iteration
    llvm::SmallVector<Operation*, 64> ops;
    for (auto& op : block.getOperations())
        ops.push_back(&op);

    for (auto it = ops.rbegin(); it != ops.rend(); ++it) {
        Operation* op = *it;

        if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
            auto* targetDef = assign.getTarget().getDefiningOp();
            if (!targetDef)
                continue;

            std::string targetStr;
            if (auto varRef = dyn_cast<helix::high::VarRefOp>(targetDef))
                targetStr = applyNameAliases(varRef.getVarName().str());
            else
                continue;

            // Only DSE simple register variables
            if (targetStr.find("->") != std::string::npos ||
                targetStr.find("*(") != std::string::npos ||
                targetStr.find("[") != std::string::npos)
                continue;

            // Never DSE SIMD registers
            if (targetStr.starts_with("xmm") || targetStr.starts_with("ymm") ||
                targetStr.starts_with("zmm"))
                continue;

            // Check for side effects in value
            auto* valueDef = assign.getValue().getDefiningOp();
            bool hasSideEffects =
                valueDef && isa<helix::high::CallOp>(valueDef);

            // Check RHS for reads of tracked variables FIRST —
            // even if this assignment will be marked dead, its RHS reads
            // keep earlier definitions alive.  This prevents the cascade:
            //   rax = rax + rbx;  ← killed (rax overwritten)
            //   rax = rax & 0xff; ← killed (rax overwritten)
            //   rax = rax | rcx;  ← survives (final write)
            // Fix: rax reads in RHS of ② keep ① alive, reads in ③ keep ② alive.
            bool rhsReadsSelf = false;
            if (valueDef) {
                std::vector<std::string> toRemove;
                valueDef->walk([&](helix::high::VarRefOp ref) {
                    auto refName = applyNameAliases(ref.getVarName().str());
                    if (refName == targetStr) {
                        rhsReadsSelf = true;
                    }
                    if (writtenNotRead.count(refName))
                        toRemove.push_back(refName);
                });
                for (auto& r : toRemove)
                    writtenNotRead.erase(r);
            }

            if (!hasSideEffects) {
                if (writtenNotRead.count(targetStr) && !rhsReadsSelf) {
                    // True dead store: target overwritten AND RHS doesn't
                    // read the target (e.g., rax = 0; rax = rbx;)
                    deadOps.insert(op);
                    continue;
                }
                writtenNotRead.insert(targetStr);
            } else {
                writtenNotRead.erase(targetStr);
            }
            continue;
        }

        // ReturnOp: mark return value as read
        if (auto ret = dyn_cast<helix::high::ReturnOp>(op)) {
            if (ret.getValue()) {
                if (auto ref = ret.getValue().getDefiningOp<
                        helix::high::VarRefOp>()) {
                    writtenNotRead.erase(
                        applyNameAliases(ref.getVarName().str()));
                }
            }
            auto returnName = applyNameAliases(currentReturnValueName_);
            if (!returnName.empty())
                writtenNotRead.erase(returnName);
            continue;
        }

        // Conservative: calls and control flow clear all tracked writes
        if (isa<helix::high::CallOp>(op) ||
            isa<helix::high::ExprStmtOp>(op) ||
            isa<helix::high::IfOp>(op) ||
            isa<helix::high::WhileOp>(op) ||
            isa<helix::high::DoWhileOp>(op)) {
            writtenNotRead.clear();
        }
    }

    return deadOps;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Struct field name recovery
// ═══════════════════════════════════════════════════════════════════════════════

bool CAstBuilder::isGenericFieldName(std::string_view name) {
    if (!name.starts_with("field_"))
        return false;

    auto suffix = name.substr(6);
    if (suffix.empty())
        return false;

    if (suffix.starts_with("0x") || suffix.starts_with("0X"))
        suffix = suffix.substr(2);

    if (suffix.empty())
        return false;

    for (char c : suffix) {
        if (!std::isxdigit(static_cast<unsigned char>(c)))
            return false;
    }
    return true;
}

std::string CAstBuilder::getRecoveredFieldName(const std::string& baseExpr,
                                                uint64_t offset) const {
    auto baseIt = recoveredStructFields_.find(baseExpr);
    if (baseIt == recoveredStructFields_.end())
        return {};

    auto fieldIt = baseIt->second.find(offset);
    if (fieldIt == baseIt->second.end())
        return {};

    return fieldIt->second.name;
}

void CAstBuilder::prescanStructFieldNames(Operation* funcOp) {
    recoveredStructFields_.clear();

    // Usage hints for field name inference
    enum class FieldUsageHint : uint8_t {
        Unknown     = 0,
        VirtualCall = 1,
        Comparison  = 2,
        SmallStore  = 3,
        FuncPtr     = 4,
        FirstField  = 5,
    };

    struct FieldAccessRecord {
        std::string baseExpr;
        uint64_t offset = 0;
        std::string originalName;
        unsigned accessCount = 0;
        FieldUsageHint hint = FieldUsageHint::Unknown;
    };

    std::unordered_map<std::string,
        std::unordered_map<uint64_t, FieldAccessRecord>> fieldAccesses;

    auto recordAccess = [&](const std::string& base, uint64_t offset,
                            const std::string& fieldName,
                            FieldUsageHint hint = FieldUsageHint::Unknown) {
        auto& record = fieldAccesses[base][offset];
        if (record.baseExpr.empty()) {
            record.baseExpr = base;
            record.offset = offset;
            record.originalName = fieldName;
        }
        record.accessCount++;
        if (hint != FieldUsageHint::Unknown &&
            (record.hint == FieldUsageHint::Unknown ||
             static_cast<uint8_t>(hint) < static_cast<uint8_t>(record.hint)))
            record.hint = hint;
    };

    // Scan FieldAccessOp
    funcOp->walk([&](helix::high::FieldAccessOp fieldOp) {
        auto* baseDef = fieldOp.getBase().getDefiningOp();
        if (!baseDef)
            return;

        std::string baseExpr;
        if (auto varRef = dyn_cast<helix::high::VarRefOp>(baseDef))
            baseExpr = applyNameAliases(varRef.getVarName().str());
        else
            return;

        auto offset = fieldOp.getFieldOffset();
        auto name = fieldOp.getFieldName().str();

        if (!isGenericFieldName(name))
            return;

        FieldUsageHint hint = FieldUsageHint::Unknown;
        if (offset == 0)
            hint = FieldUsageHint::FirstField;

        // Check if field result is used in a call (virtual call)
        for (auto* user : fieldOp.getResult().getUsers()) {
            if (isa<helix::high::CallOp>(user)) {
                hint = FieldUsageHint::VirtualCall;
                break;
            }
        }

        recordAccess(baseExpr, offset, name, hint);
    });

    // Phase 2: Infer meaningful names from collected patterns
    for (auto& [base, offsets] : fieldAccesses) {
        bool hasVtableAtZero = false;
        bool hasAnyVirtualCall = false;
        for (auto& [off, rec] : offsets) {
            if (off == 0 && (rec.hint == FieldUsageHint::FirstField ||
                             rec.hint == FieldUsageHint::VirtualCall))
                hasVtableAtZero = true;
            if (rec.hint == FieldUsageHint::VirtualCall)
                hasAnyVirtualCall = true;
        }

        auto& recoveredMap = recoveredStructFields_[base];

        for (auto& [offset, record] : offsets) {
            if (record.accessCount < 2 &&
                record.hint == FieldUsageHint::Unknown)
                continue;

            std::string recoveredName;

            switch (record.hint) {
            case FieldUsageHint::VirtualCall:
                if (offset == 0)
                    recoveredName = "vftable";
                break;
            case FieldUsageHint::FirstField:
                if (offset == 0 && (hasAnyVirtualCall || hasVtableAtZero))
                    recoveredName = "vftable";
                break;
            case FieldUsageHint::Comparison:
                if (offset == 0 && hasVtableAtZero)
                    recoveredName = "vftable";
                break;
            case FieldUsageHint::SmallStore:
                if (offset == 0 && hasVtableAtZero)
                    recoveredName = "vftable";
                else if (hasVtableAtZero && offset == 0x8)
                    recoveredName = "refCount";
                break;
            case FieldUsageHint::FuncPtr:
                recoveredName = "callback";
                break;
            case FieldUsageHint::Unknown:
                if (offset == 0 && hasVtableAtZero)
                    recoveredName = "vftable";
                break;
            }

            // Windows / game engine patterns
            if (recoveredName.empty() &&
                (base == "this" || base == "param_1")) {
                if (offset == 0x0 && hasAnyVirtualCall)
                    recoveredName = "vftable";
                else if (offset == 0x8 && hasVtableAtZero)
                    recoveredName = "refCount";
            }

            if (recoveredName.empty())
                continue;

            // Deduplicate
            bool nameCollision = false;
            for (auto& [existingOff, existingInfo] : recoveredMap) {
                if (existingInfo.name == recoveredName &&
                    existingOff != offset) {
                    nameCollision = true;
                    break;
                }
            }
            if (nameCollision)
                recoveredName += std::format("_{:x}", offset);

            recoveredMap[offset] =
                StructFieldInfo{std::move(recoveredName), /*typeName=*/""};
        }
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Confidence Analysis
// ═══════════════════════════════════════════════════════════════════════════════

// ─── Garbage-pattern detection for the confidence score ──────────────────────
//
// The historical confidence calculator misses entire classes of output that
// `helix-validate` (`tools/helix-validate/`) detects via dataflow theorems:
// outputs where the first executable statement is a `return` shadowing live
// code, derefs of placeholder vars whose only definition is `0`, identity
// no-ops, and self-referencing assignments of the form `x op= ... x ...`.
//
// These patterns are not stylistic preferences — each one is a *theorem*
// that the emitted output is degenerate (see paper-supplement-v091.md §2.1
// for the formal statements). When the existing scorer reports 91% on a
// function whose first statement is `return sub_c();` followed by 30 lines
// of unreachable tail (the `init_module → hook_syslog` case observed on
// the `rev_kernel_monarch` rootkit corpus), the scorer is the problem,
// not the output.
//
// The detectors below walk the CAst AFTER it is fully built, count the
// occurrences of each pattern, and contribute deductions to the same
// `deduction` running total the original analyzer uses. They never
// suppress an issue — only add to it.

namespace {

/// True iff `e` is the literal `0`, `(void*)0`, `NULL`, or a cast of any.
bool isZeroLiteralExpr(const CExpr* e) {
    if (!e) return false;
    if (auto* lit = llvm::dyn_cast<CIntLitExpr>(e)) {
        return lit->value == 0;
    }
    if (auto* lit = llvm::dyn_cast<CAddrLitExpr>(e)) {
        return lit->addrValue == 0;
    }
    if (auto* castE = llvm::dyn_cast<CCastExpr>(e)) {
        return isZeroLiteralExpr(castE->operand.get());
    }
    return false;
}

/// Return the var-name iff `e` is a plain `CVarRefExpr`. Stripped of casts.
std::string varNameOf(const CExpr* e) {
    if (!e) return {};
    if (auto* castE = llvm::dyn_cast<CCastExpr>(e)) {
        return varNameOf(castE->operand.get());
    }
    if (auto* v = llvm::dyn_cast<CVarRefExpr>(e)) {
        return v->varName;
    }
    return {};
}

/// True iff `e` contains a `CVarRefExpr` referencing `name` anywhere in its
/// expression tree (so we can detect `x = x + 1`, `x += y * x`, etc.).
bool exprReferencesVar(const CExpr* e, llvm::StringRef name) {
    if (!e || name.empty()) return false;
    if (auto* v = llvm::dyn_cast<CVarRefExpr>(e)) {
        return v->varName == name;
    }
    if (auto* b = llvm::dyn_cast<CBinaryExpr>(e)) {
        return exprReferencesVar(b->lhs.get(), name) ||
               exprReferencesVar(b->rhs.get(), name);
    }
    if (auto* u = llvm::dyn_cast<CUnaryExpr>(e)) {
        return exprReferencesVar(u->operand.get(), name);
    }
    if (auto* c = llvm::dyn_cast<CCastExpr>(e)) {
        return exprReferencesVar(c->operand.get(), name);
    }
    if (auto* t = llvm::dyn_cast<CTernaryExpr>(e)) {
        return exprReferencesVar(t->cond.get(), name) ||
               exprReferencesVar(t->trueVal.get(), name) ||
               exprReferencesVar(t->falseVal.get(), name);
    }
    if (auto* s = llvm::dyn_cast<CSubscriptExpr>(e)) {
        return exprReferencesVar(s->base.get(), name) ||
               exprReferencesVar(s->index.get(), name);
    }
    if (auto* fa = llvm::dyn_cast<CFieldAccessExpr>(e)) {
        return exprReferencesVar(fa->base.get(), name);
    }
    if (auto* call = llvm::dyn_cast<CCallExpr>(e)) {
        // CCallExpr holds the target as a string/address, not as an expr.
        for (auto& a : call->args) {
            if (exprReferencesVar(a.get(), name)) return true;
        }
        return false;
    }
    return false;
}

struct GarbageCounts {
    int unreachableAfterReturn = 0;  // theorem T5
    int nullDerefPlaceholder   = 0;  // theorem T1
    int suspiciousSelfRef      = 0;  // theorem T3
    int identityNoOp           = 0;  // theorem T2
};

void analyzeStmtList(const std::vector<StmtPtr>& body,
                     const std::unordered_set<std::string>& zeroInitVars,
                     std::unordered_set<std::string>& reassigned,
                     GarbageCounts& g);

void analyzeStmt(const CStmt* s,
                 const std::unordered_set<std::string>& zeroInitVars,
                 std::unordered_set<std::string>& reassigned,
                 GarbageCounts& g) {
    if (!s) return;

    // (T1) Null deref of placeholder: `*<zero_var> = …`.
    if (auto* assign = llvm::dyn_cast<CAssignStmt>(s)) {
        if (auto* u = llvm::dyn_cast<CUnaryExpr>(assign->target.get())) {
            if (u->op == UnaryOp::Deref) {
                auto vn = varNameOf(u->operand.get());
                if (!vn.empty() && zeroInitVars.count(vn) &&
                    !reassigned.count(vn)) {
                    g.nullDerefPlaceholder++;
                }
            }
        }
        // Record reassignment to `target` (whole-var only — `*p =` does NOT
        // reassign `p`, it writes through it; we already detected that case
        // above before processing).
        if (auto vn = varNameOf(assign->target.get()); !vn.empty()) {
            reassigned.insert(vn);
        }

        // (T2 / T3) Self-referencing or identity assignment.
        if (auto targetName = varNameOf(assign->target.get());
            !targetName.empty()) {
            bool rhsRefs = exprReferencesVar(
                assign->value.get(), targetName);
            // x = x  (plain) or  x op= x  is identity for op in {|, &}.
            bool plainSelfAssign =
                assign->compoundOp.empty() &&
                varNameOf(assign->value.get()) == targetName;
            bool selfOrAnd =
                (assign->compoundOp == "|=" || assign->compoundOp == "&=") &&
                varNameOf(assign->value.get()) == targetName;
            // x op= 0  is identity for op in {+, -, |, ^}.
            bool opZero =
                (assign->compoundOp == "+=" || assign->compoundOp == "-=" ||
                 assign->compoundOp == "|=" || assign->compoundOp == "^=") &&
                isZeroLiteralExpr(assign->value.get());

            if (plainSelfAssign || selfOrAnd || opZero) {
                g.identityNoOp++;
            } else if (rhsRefs) {
                // Not exact identity, but the RHS still references the same
                // variable we're writing to — non-canonical self-reference
                // (e.g. `x += x - 16` = `2x - 16`, the AmmoUsage case).
                g.suspiciousSelfRef++;
            }
        }
        return;
    }

    if (auto* ifS = llvm::dyn_cast<CIfStmt>(s)) {
        analyzeStmtList(ifS->thenBody, zeroInitVars, reassigned, g);
        analyzeStmtList(ifS->elseBody, zeroInitVars, reassigned, g);
        return;
    }
    if (auto* wh = llvm::dyn_cast<CWhileStmt>(s)) {
        analyzeStmtList(wh->body, zeroInitVars, reassigned, g);
        return;
    }
    if (auto* dw = llvm::dyn_cast<CDoWhileStmt>(s)) {
        analyzeStmtList(dw->body, zeroInitVars, reassigned, g);
        return;
    }
    if (auto* fr = llvm::dyn_cast<CForStmt>(s)) {
        analyzeStmtList(fr->body, zeroInitVars, reassigned, g);
        return;
    }
    if (auto* sw = llvm::dyn_cast<CSwitchStmt>(s)) {
        for (auto& c : sw->cases) {
            analyzeStmtList(c.body, zeroInitVars, reassigned, g);
        }
        return;
    }
    if (auto* blk = llvm::dyn_cast<CBlockStmt>(s)) {
        analyzeStmtList(blk->stmts, zeroInitVars, reassigned, g);
        return;
    }
}

void analyzeStmtList(const std::vector<StmtPtr>& body,
                     const std::unordered_set<std::string>& zeroInitVars,
                     std::unordered_set<std::string>& reassigned,
                     GarbageCounts& g) {
    // (T5) Unreachable-after-return: anything following the first top-level
    // `return` in this list is dead. We count *statements*, not lines, so a
    // 30-line tail of one CAssignStmt + one CExprStmt + … counts as N.
    bool sawReturn = false;
    for (auto& sp : body) {
        if (sawReturn) {
            g.unreachableAfterReturn++;
            // Don't analyse the unreachable subtree further — its findings
            // are already shadowed by the dead-code finding.
            continue;
        }
        analyzeStmt(sp.get(), zeroInitVars, reassigned, g);
        if (llvm::isa<CReturnStmt>(sp.get())) {
            sawReturn = true;
        }
    }
}

GarbageCounts collectGarbagePatterns(const CFuncDecl& func) {
    // Build the zero-init placeholder set from the function's local decls.
    // A var counts as a placeholder iff its declared initializer is
    // syntactically zero (literal 0, (void*)0, NULL via address literal,
    // or a cast of any of those).
    std::unordered_set<std::string> zeroInit;
    for (const auto& lv : func.localVars) {
        if (lv.initExpr && isZeroLiteralExpr(lv.initExpr.get())) {
            zeroInit.insert(lv.varName);
        }
    }
    std::unordered_set<std::string> reassigned;
    GarbageCounts g;
    analyzeStmtList(func.body, zeroInit, reassigned, g);
    return g;
}

} // namespace

void CAstBuilder::analyzeConfidence(CFuncDecl& func, mlir::Operation* op) {
    double deduction = 0.0;
    auto& issues = func.confidenceIssues;

    // FIX-083: op may be low::FuncOp when the pipeline retains functions
    // in the low dialect. mlir::cast would abort; use dyn_cast + fallback.
    auto highFunc = mlir::dyn_cast<helix::high::FuncOp>(op);
    if (!highFunc) {
        func.confidenceScore = 50.0;
        issues.push_back("non-high function — confidence approximate");
        return;
    }

    // Count total ops for stub detection
    unsigned opCount = 0;
    highFunc.walk([&](mlir::Operation*) { opCount++; });

    // ── Stub / very short functions ──────────────────────────────────
    if (func.body.size() <= 1 && opCount < 5) {
        deduction += 40.0;
        issues.push_back("stub function (< 5 ops)");
    } else if (func.body.size() <= 3 && opCount < 10) {
        deduction += 15.0;
        issues.push_back("very short function");
    }

    // ── Native opcode calls not decomposed ───────────────────────────
    unsigned nativeOps = 0;
    highFunc.walk([&](helix::high::CallOp call) {
        auto name = call.getTargetName().str();
        bool allUpper = !name.empty();
        for (char c : name) {
            if (!std::isupper(c) && c != '_' && !std::isdigit(c)) {
                allUpper = false;
                break;
            }
        }
        if (allUpper && name.size() >= 3)
            nativeOps++;
    });
    if (nativeOps > 0) {
        deduction += std::min(30.0, (double)nativeOps * 3.0);
        issues.push_back(
            std::format("{} native opcode(s) not decomposed", nativeOps));
    }

    // ── Register names as local variables ────────────────────────────
    static const char* kRegs[] = {
        "rax", "rbx", "rcx", "rdx", "rsi", "rdi", "rbp", "rsp",
        "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
    };
    unsigned regVars = 0;
    for (auto& lv : func.localVars) {
        for (auto* reg : kRegs) {
            if (lv.varName == reg) { regVars++; break; }
        }
    }
    if (regVars > 0) {
        deduction += std::min(20.0, (double)regVars * 2.0);
        issues.push_back(
            std::format("{} register-named variable(s)", regVars));
    }

    // ── Goto count ───────────────────────────────────────────────────
    unsigned gotos = 0;
    highFunc.walk([&](helix::high::GotoOp) { gotos++; });
    if (gotos > 3) {
        deduction += std::min(15.0, (double)(gotos - 3) * 3.0);
        issues.push_back(
            std::format("{} goto(s)", gotos));
    }

    // ── Empty if/else bodies ─────────────────────────────────────────
    unsigned emptyBodies = 0;
    highFunc.walk([&](helix::high::IfOp ifOp) {
        if (ifOp.getThenRegion().empty() ||
            ifOp.getThenRegion().front().getOperations().size() <= 1)
            emptyBodies++;
        if (!ifOp.getElseRegion().empty() &&
            ifOp.getElseRegion().front().getOperations().size() <= 1)
            emptyBodies++;
    });
    if (emptyBodies > 0) {
        deduction += (double)emptyBodies * 3.0;
        issues.push_back(
            std::format("{} empty if/else block(s)", emptyBodies));
    }

    // ── Typed parameters (bonus for pointer recovery) ────────────────
    unsigned typedParams = 0;
    for (auto& p : func.params) {
        if (p.type && p.type->format() != "int64_t")
            typedParams++;
    }
    if (typedParams > 0 && !func.params.empty()) {
        // Bonus: up to +5 for having typed params
        double bonus = std::min(5.0,
            (double)typedParams / (double)func.params.size() * 5.0);
        deduction -= bonus;
    }

    // ── v0.9.1: garbage-pattern penalties (closes G-015) ────────────────
    // Walk the CAst and count theorem-grounded defects. These are the same
    // patterns helix-validate detects; landing them in the engine's own
    // scorer means the self-reported confidence stops disagreeing with the
    // external validator. See comment block on `collectGarbagePatterns`.
    auto g = collectGarbagePatterns(func);
    if (g.unreachableAfterReturn > 0) {
        // The single most damning pattern — `return X; <more code>` at the
        // top level means the function body that should have run is gone.
        // 5 points per unreachable stmt, capped at 40 so a small tail
        // doesn't dominate the score by itself.
        deduction += std::min(40.0,
            (double)g.unreachableAfterReturn * 5.0);
        issues.push_back(std::format(
            "{} unreachable statement(s) after `return` (lift-quality concern)",
            g.unreachableAfterReturn));
    }
    if (g.nullDerefPlaceholder > 0) {
        // `*v = …` where v was declared = 0 and never reassigned — UB on
        // the original semantics. 10 points each, capped at 30.
        deduction += std::min(30.0,
            (double)g.nullDerefPlaceholder * 10.0);
        issues.push_back(std::format(
            "{} null-deref of zero-initialised placeholder",
            g.nullDerefPlaceholder));
    }
    if (g.suspiciousSelfRef > 0) {
        // `x op= … x …` — non-canonical self-reference (the
        // `param_2 += param_2 - 16` AmmoUsage case). 5 points each,
        // capped at 20 — milder than null-deref because it can occasionally
        // be legitimate (e.g. `x = x + 1` in a real algorithm).
        deduction += std::min(20.0,
            (double)g.suspiciousSelfRef * 5.0);
        issues.push_back(std::format(
            "{} suspicious self-referencing assignment(s)",
            g.suspiciousSelfRef));
    }
    if (g.identityNoOp > 0) {
        // `x = x`, `x ^= 0`, `x |= x`, etc. — pure identities the lifter
        // shouldn't have emitted. Mild penalty.
        deduction += std::min(10.0,
            (double)g.identityNoOp * 3.0);
        issues.push_back(std::format(
            "{} identity / no-op assignment(s)", g.identityNoOp));
    }

    func.confidenceScore = std::max(0.0, std::min(100.0, 100.0 - deduction));
}
