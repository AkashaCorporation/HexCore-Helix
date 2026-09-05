/// @file PseudoCEmitter.cpp
/// @brief Pseudo-C emitter: walks HelixHigh/HelixLow/LLVM MLIR and produces
///        C-like source code.
///
/// Format conventions (matching the Rust hir_emitter.rs):
///   - Integer types: int8_t, int16_t, int32_t, int64_t, uint8_t, etc.
///   - Hex literals for values >= 16 or <= -16
///   - Parenthesized binary expressions
///   - Indented block structure with braces
///   - Header comment: "// Decompiled by HexCore Helix"

#include "helix/emit/PseudoCEmitter.h"
#include "helix/analysis/RemillDemangler.h"
#include "helix/analysis/SignatureDb.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixMidOps.h"
#include "helix/dialects/HelixLowOps.h"

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/BuiltinOps.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

#include <format>
#include <functional>
#include <map>
#include <optional>
#include <regex>
#include <set>
#include <string>
#include <string_view>
#include <vector>
#include <cmath>
#include <cctype>
#include <cstring>

using namespace mlir;
using namespace helix;

#define DEBUG_TYPE "pseudoc-emitter"

// ═══════════════════════════════════════════════════════════════════════════════
// C operator precedence levels (higher number = tighter binding).
// Used by formatExpressionWithPrec to decide when parentheses are needed.
// ═══════════════════════════════════════════════════════════════════════════════
static constexpr int kPrecComma      = 1;
static constexpr int kPrecAssign     = 2;
static constexpr int kPrecTernary    = 3;
static constexpr int kPrecLogOr      = 4;
static constexpr int kPrecLogAnd     = 5;
static constexpr int kPrecBitOr      = 6;
static constexpr int kPrecBitXor     = 7;
static constexpr int kPrecBitAnd     = 8;
static constexpr int kPrecEqual      = 9;
static constexpr int kPrecRelational = 10;
static constexpr int kPrecShift      = 11;
static constexpr int kPrecAdd        = 12;
static constexpr int kPrecMul        = 13;
static constexpr int kPrecUnary      = 14;
static constexpr int kPrecAtom       = 15;

namespace {

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

static std::string toLowerCopy(std::string_view value) {
    std::string result(value);
    std::transform(result.begin(), result.end(), result.begin(),
                   [](unsigned char ch) { return static_cast<char>(std::tolower(ch)); });
    return result;
}

static bool isSyntheticTemporaryName(std::string_view name) {
    return name.starts_with("var_") || name.starts_with("spill_");
}

static bool isSyntheticValueName(std::string_view name) {
    if (isSyntheticTemporaryName(name))
        return true;
    if (!name.starts_with('v') || name.size() < 2)
        return false;
    return std::all_of(name.begin() + 1, name.end(), [](unsigned char ch) {
        return std::isdigit(ch);
    });
}

static bool containsSyntheticValueIdentifier(std::string_view text) {
    for (size_t i = 0; i < text.size(); ++i) {
        if (text[i] != 'v')
            continue;
        if (i > 0) {
            unsigned char prev = static_cast<unsigned char>(text[i - 1]);
            if (std::isalnum(prev) || prev == '_')
                continue;
        }

        size_t j = i + 1;
        if (j >= text.size() || !std::isdigit(static_cast<unsigned char>(text[j])))
            continue;
        while (j < text.size() &&
               std::isdigit(static_cast<unsigned char>(text[j]))) {
            ++j;
        }

        if (j < text.size()) {
            unsigned char next = static_cast<unsigned char>(text[j]);
            if (std::isalnum(next) || next == '_')
                continue;
        }
        return true;
    }
    return false;
}

static std::optional<int64_t> parseFormattedIntegerLiteral(std::string_view text) {
    if (text.empty())
        return std::nullopt;

    bool negative = false;
    if (text.front() == '-') {
        negative = true;
        text.remove_prefix(1);
    }

    if (text.empty())
        return std::nullopt;

    int base = 10;
    if (text.starts_with("0x") || text.starts_with("0X")) {
        base = 16;
        text.remove_prefix(2);
    }

    if (text.empty())
        return std::nullopt;

    try {
        auto value = static_cast<int64_t>(std::stoll(std::string(text), nullptr, base));
        return negative ? -value : value;
    } catch (...) {
        return std::nullopt;
    }
}

static std::optional<uint64_t> parseSubroutineAddressName(std::string_view text) {
    constexpr std::string_view prefix = "sub_";
    if (!text.starts_with(prefix) || text.size() == prefix.size())
        return std::nullopt;

    text.remove_prefix(prefix.size());
    try {
        return std::stoull(std::string(text), nullptr, 16);
    } catch (...) {
        return std::nullopt;
    }
}

struct RelativeCallPattern {
    std::string baseVar;
    int64_t smallConstSum = 0;
    int64_t largeConstSum = 0;
    unsigned largeConstCount = 0;
    bool valid = true;
};

static std::optional<int64_t> tryExtractIntegerLiteralFromValue(Value value) {
    if (!value)
        return std::nullopt;

    auto* defOp = value.getDefiningOp();
    if (!defOp)
        return std::nullopt;

    if (auto intLit = dyn_cast<helix::high::IntLitOp>(defOp))
        return intLit.getValue();

    if (auto constOp = dyn_cast<LLVM::ConstantOp>(defOp)) {
        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
            return intAttr.getValue().getSExtValue();
    }

    if (auto constOp = dyn_cast<arith::ConstantOp>(defOp)) {
        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
            return intAttr.getValue().getSExtValue();
    }

    if (auto intAttr = defOp->getAttrOfType<IntegerAttr>("value"))
        return intAttr.getValue().getSExtValue();

    return std::nullopt;
}

// ─── Compound Assignment Helpers ─────────────────────────────────────────────

/// Map a helix::high::BinaryOpKind to its C compound assignment operator string.
/// Returns nullptr for kinds that don't have a compound form (comparisons, logical).
static const char* getHighCompoundOp(helix::high::BinaryOpKind kind) {
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

/// Map a helix::mid::BinExprKind to its C compound assignment operator string.
static const char* getMidCompoundOp(helix::mid::BinExprKind kind) {
    switch (kind) {
    case helix::mid::BinExprKind::Add:    return "+=";
    case helix::mid::BinExprKind::Sub:    return "-=";
    case helix::mid::BinExprKind::Mul:    return "*=";
    case helix::mid::BinExprKind::Div:    return "/=";
    case helix::mid::BinExprKind::UMul:   return "*=";
    case helix::mid::BinExprKind::SMul:   return "*=";
    case helix::mid::BinExprKind::UDiv:   return "/=";
    case helix::mid::BinExprKind::SDiv:   return "/=";
    case helix::mid::BinExprKind::Mod:    return "%=";
    case helix::mid::BinExprKind::Shl:    return "<<=";
    case helix::mid::BinExprKind::Shr:    return ">>=";
    case helix::mid::BinExprKind::Sar:    return ">>=";
    case helix::mid::BinExprKind::BitAnd: return "&=";
    case helix::mid::BinExprKind::BitOr:  return "|=";
    case helix::mid::BinExprKind::BitXor: return "^=";
    default: return nullptr;
    }
}

/// Is this high::BinaryOpKind commutative? (a OP b == b OP a)
/// For commutative ops we can also match `x = rhs OP x` → `x OP= rhs`.
static bool isCommutativeHighOp(helix::high::BinaryOpKind kind) {
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

/// Is this mid::BinExprKind commutative?
static bool isCommutativeMidOp(helix::mid::BinExprKind kind) {
    switch (kind) {
    case helix::mid::BinExprKind::Add:
    case helix::mid::BinExprKind::Mul:
    case helix::mid::BinExprKind::UMul:
    case helix::mid::BinExprKind::SMul:
    case helix::mid::BinExprKind::BitAnd:
    case helix::mid::BinExprKind::BitOr:
    case helix::mid::BinExprKind::BitXor:
        return true;
    default:
        return false;
    }
}

static void collectRelativeCallPattern(Value value, int64_t sign,
                                       RelativeCallPattern& pattern) {
    if (!pattern.valid || !value)
        return;

    if (auto literal = tryExtractIntegerLiteralFromValue(value)) {
        int64_t signedValue = sign * *literal;
        if (std::llabs(signedValue) >= 0x100) {
            pattern.largeConstSum += signedValue;
            ++pattern.largeConstCount;
        } else {
            pattern.smallConstSum += signedValue;
        }
        return;
    }

    if (auto varRef = value.getDefiningOp<helix::high::VarRefOp>()) {
        auto name = varRef.getVarName().str();
        if (sign != 1 || !isSyntheticValueName(name)) {
            pattern.valid = false;
            return;
        }
        if (pattern.baseVar.empty()) {
            pattern.baseVar = name;
            return;
        }
        if (pattern.baseVar != name)
            pattern.valid = false;
        return;
    }

    if (auto add = value.getDefiningOp<LLVM::AddOp>()) {
        collectRelativeCallPattern(add.getLhs(), sign, pattern);
        collectRelativeCallPattern(add.getRhs(), sign, pattern);
        return;
    }

    if (auto sub = value.getDefiningOp<LLVM::SubOp>()) {
        collectRelativeCallPattern(sub.getLhs(), sign, pattern);
        collectRelativeCallPattern(sub.getRhs(), -sign, pattern);
        return;
    }

    if (auto zext = value.getDefiningOp<LLVM::ZExtOp>()) {
        collectRelativeCallPattern(zext.getArg(), sign, pattern);
        return;
    }

    if (auto sext = value.getDefiningOp<LLVM::SExtOp>()) {
        collectRelativeCallPattern(sext.getArg(), sign, pattern);
        return;
    }

    if (auto trunc = value.getDefiningOp<LLVM::TruncOp>()) {
        collectRelativeCallPattern(trunc.getArg(), sign, pattern);
        return;
    }

    if (auto ptrToInt = value.getDefiningOp<LLVM::PtrToIntOp>()) {
        collectRelativeCallPattern(ptrToInt.getArg(), sign, pattern);
        return;
    }

    if (auto intToPtr = value.getDefiningOp<LLVM::IntToPtrOp>()) {
        collectRelativeCallPattern(intToPtr.getArg(), sign, pattern);
        return;
    }

    if (auto castOp = value.getDefiningOp<helix::high::CastOp>()) {
        collectRelativeCallPattern(castOp.getInput(), sign, pattern);
        return;
    }

    pattern.valid = false;
}

static void addRelativeCallConstant(RelativeCallPattern& pattern, int64_t value) {
    if (std::llabs(value) >= 0x100) {
        pattern.largeConstSum += value;
        ++pattern.largeConstCount;
    } else {
        pattern.smallConstSum += value;
    }
}

static std::optional<RelativeCallPattern>
collectRelativeCallPatternFromString(std::string_view expr) {
    RelativeCallPattern pattern;
    bool sawSyntheticBase = false;

    for (size_t i = 0; i < expr.size(); ++i) {
        char ch = expr[i];

        if (ch == 'v') {
            size_t j = i + 1;
            if (j >= expr.size() ||
                !std::isdigit(static_cast<unsigned char>(expr[j]))) {
                continue;
            }
            while (j < expr.size() &&
                   std::isdigit(static_cast<unsigned char>(expr[j]))) {
                ++j;
            }

            if (i > 0) {
                unsigned char prev = static_cast<unsigned char>(expr[i - 1]);
                if (std::isalnum(prev) || prev == '_')
                    continue;
            }
            if (j < expr.size()) {
                unsigned char next = static_cast<unsigned char>(expr[j]);
                if (std::isalnum(next) || next == '_')
                    continue;
            }

            std::string name(expr.substr(i, j - i));
            if (pattern.baseVar.empty()) {
                pattern.baseVar = name;
            } else if (pattern.baseVar != name) {
                pattern.valid = false;
                return std::nullopt;
            }
            sawSyntheticBase = true;
            i = j - 1;
            continue;
        }

        constexpr std::string_view fieldPrefix = "field_0x";
        if (expr.substr(i).starts_with(fieldPrefix)) {
            size_t start = i + fieldPrefix.size();
            size_t j = start;
            while (j < expr.size() &&
                   std::isxdigit(static_cast<unsigned char>(expr[j]))) {
                ++j;
            }
            if (j == start) {
                pattern.valid = false;
                return std::nullopt;
            }

            try {
                auto value = static_cast<int64_t>(
                    std::stoll(std::string(expr.substr(start, j - start)), nullptr, 16));
                addRelativeCallConstant(pattern, value);
            } catch (...) {
                pattern.valid = false;
                return std::nullopt;
            }

            i = j - 1;
            continue;
        }

        if (ch != '+' && ch != '-')
            continue;

        int64_t sign = (ch == '-') ? -1 : 1;
        size_t j = i + 1;
        while (j < expr.size() &&
               std::isspace(static_cast<unsigned char>(expr[j]))) {
            ++j;
        }
        if (j >= expr.size())
            break;

        if (!(std::isdigit(static_cast<unsigned char>(expr[j])) ||
              (expr[j] == '0' && j + 1 < expr.size() &&
               (expr[j + 1] == 'x' || expr[j + 1] == 'X')))) {
            continue;
        }

        size_t start = j;
        int base = 10;
        if (expr[j] == '0' && j + 1 < expr.size() &&
            (expr[j + 1] == 'x' || expr[j + 1] == 'X')) {
            base = 16;
            j += 2;
            while (j < expr.size() &&
                   std::isxdigit(static_cast<unsigned char>(expr[j]))) {
                ++j;
            }
        } else {
            while (j < expr.size() &&
                   std::isdigit(static_cast<unsigned char>(expr[j]))) {
                ++j;
            }
        }

        try {
            auto value = static_cast<int64_t>(
                std::stoll(std::string(expr.substr(start, j - start)), nullptr, base));
            addRelativeCallConstant(pattern, sign * value);
        } catch (...) {
            pattern.valid = false;
            return std::nullopt;
        }

        i = j - 1;
    }

    if (!pattern.valid || !sawSyntheticBase || pattern.largeConstCount != 1)
        return std::nullopt;
    return pattern;
}

static std::string normalizeAddressExpression(std::string_view expr) {
    std::string normalized;
    normalized.reserve(expr.size());
    for (char ch : expr) {
        if (ch != '(' && ch != ')' && ch != ' ' && ch != '\t')
            normalized.push_back(static_cast<char>(std::tolower(
                static_cast<unsigned char>(ch))));
    }
    return normalized;
}

static bool isStackSlotExpression(std::string_view expr) {
    return expr.find("rsp + ") != std::string_view::npos ||
           expr.find("rsp - ") != std::string_view::npos ||
           expr.find("rbp + ") != std::string_view::npos ||
           expr.find("rbp - ") != std::string_view::npos;
}

static bool isBoundaryRelevantOp(Operation& op) {
    return isa<helix::high::AssignOp,
               helix::high::ExprStmtOp,
               helix::high::IfOp,
               helix::high::WhileOp,
               helix::high::DoWhileOp,
               helix::high::ForOp,
               helix::high::LabelOp,
               helix::high::ReturnOp,
               helix::low::MemReadOp,
               helix::low::MemWriteOp,
               helix::low::RegWriteOp,
               helix::low::CallOp,
               helix::low::RetOp,
               helix::low::JmpOp,
               helix::low::JccOp,
               helix::low::PushOp,
               helix::low::PopOp,
               LLVM::LoadOp,
               LLVM::StoreOp>(op);
}

static std::optional<unsigned>
inferDenseObservedStackParamLimit(const std::set<unsigned>& observedStackParams) {
    if (observedStackParams.empty())
        return std::nullopt;

    const bool hasEarlyAnchor =
        observedStackParams.contains(5) || observedStackParams.contains(6);
    if (!hasEarlyAnchor)
        return std::nullopt;

    std::optional<unsigned> bestLimit;
    for (unsigned upperBound : observedStackParams) {
        if (upperBound < 5)
            continue;

        unsigned windowSize = upperBound - 4;
        unsigned observedCount = 0;
        for (unsigned index : observedStackParams) {
            if (index >= 5 && index <= upperBound)
                ++observedCount;
        }

        if (observedCount == 0)
            continue;

        double density =
            static_cast<double>(observedCount) / static_cast<double>(windowSize);
        bool strongEnough =
            (upperBound == 5 && observedStackParams.contains(5)) ||
            observedCount >= 2 ||
            observedStackParams.contains(5);
        if (!strongEnough || density < 0.60)
            continue;

        bestLimit = upperBound;
    }

    return bestLimit;
}

static std::optional<std::string>
extractDereferencedAddressExpression(std::string_view expr) {
    auto derefPos = expr.find("*(");
    if (derefPos == std::string_view::npos)
        return std::nullopt;

    auto openPos = derefPos + 1;
    int depth = 0;
    for (size_t i = openPos; i < expr.size(); ++i) {
        if (expr[i] == '(') {
            ++depth;
        } else if (expr[i] == ')') {
            --depth;
            if (depth == 0)
                return std::string(expr.substr(openPos, i - openPos + 1));
        }
    }

    return std::nullopt;
}

static bool isLikelyReturnTarget(Value value) {
    auto ref = value.getDefiningOp<helix::high::VarRefOp>();
    if (!ref)
        return false;

    auto name = ref.getVarName();
    return name == "result" || name == "rax";
}

static bool blockHasLikelyReturnWrite(Block* block, Block::iterator endIt) {
    if (!block)
        return false;

    for (auto it = endIt; it != block->begin();) {
        --it;

        if (auto assign = dyn_cast<helix::high::AssignOp>(&*it)) {
            if (isLikelyReturnTarget(assign.getTarget()))
                return true;
        }

        if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&*it)) {
            if (regWrite.getRegName() == "RAX" || regWrite.getRegName() == "EAX" ||
                regWrite.getRegName() == "XMM0")
                return true;
        }

        if (isa<helix::low::CallOp>(&*it))
            return false;
    }

    return false;
}

static bool inferLikelyReturnValue(Operation* func) {
    bool hasRet = false;
    bool foundReturnWrite = false;

    func->walk([&](Operation* returnOp) {
        if (foundReturnWrite)
            return;
        if (!isa<helix::low::RetOp, helix::mid::ReturnOp,
                 helix::high::ReturnOp>(returnOp))
            return;
        hasRet = true;

        auto* block = returnOp->getBlock();
        if (!block)
            return;

        if (blockHasLikelyReturnWrite(
                block, Block::iterator(returnOp))) {
            foundReturnWrite = true;
            return;
        }

        std::vector<std::pair<Block*, unsigned>> worklist;
        std::unordered_set<Block*> visited;
        for (Block* pred : block->getPredecessors())
            worklist.push_back({pred, 0u});

        while (!worklist.empty()) {
            auto [candidate, depth] = worklist.back();
            worklist.pop_back();
            if (!candidate || !visited.insert(candidate).second)
                continue;

            if (blockHasLikelyReturnWrite(candidate, candidate->end())) {
                foundReturnWrite = true;
                return;
            }

            if (depth >= 1)
                continue;

            for (Block* pred : candidate->getPredecessors())
                worklist.push_back({pred, depth + 1});
        }
    });

    if (!hasRet)
        return false;

    func->walk([&](helix::high::AssignOp assign) {
        if (!foundReturnWrite && isLikelyReturnTarget(assign.getTarget()))
            foundReturnWrite = true;
    });

    return foundReturnWrite;
}

} // namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Public API
// ═══════════════════════════════════════════════════════════════════════════════

std::string PseudoCEmitter::emit(ModuleOp module) {
    std::string result;
    llvm::raw_string_ostream os(result);
    emit(module, os);
    os.flush();

#ifndef NDEBUG
    validateOutput(result);
#endif

    return result;
}

void PseudoCEmitter::emit(ModuleOp module, llvm::raw_ostream& os) {
    emitHeader(os, module);

    // Walk top-level operations looking for legalized Helix function ops.
    module.walk([&](Operation* op) {
        if (isa<helix::low::FuncOp, helix::high::FuncOp>(op)) {
            emitFunction(op, os);
        }
    });
}

std::optional<unsigned>
PseudoCEmitter::inferWin64StackParamIndexFromAddressString(
    std::string_view expr, int64_t rbpStackParamBaseOffset) {
    auto normalized = normalizeAddressExpression(expr);

    constexpr std::string_view rspPrefix = "rsp+";
    constexpr std::string_view rbpPrefix = "rbp+";
    int64_t stackParamBaseOffset = 0x28;
    std::string_view offsetStr;
    std::string_view normalizedView(normalized);
    if (normalizedView.starts_with(rspPrefix)) {
        offsetStr = normalizedView.substr(rspPrefix.size());
    } else if (normalizedView.starts_with(rbpPrefix)) {
        offsetStr = normalizedView.substr(rbpPrefix.size());
        stackParamBaseOffset = rbpStackParamBaseOffset;
    } else {
        return std::nullopt;
    }

    if (offsetStr.empty())
        return std::nullopt;

    uint64_t offset = 0;
    try {
        if (offsetStr.starts_with("0x"))
            offset = std::stoull(std::string(offsetStr.substr(2)), nullptr, 16);
        else
            offset = std::stoull(std::string(offsetStr), nullptr, 10);
    } catch (...) {
        return std::nullopt;
    }

    // Win64 stack-passed arguments start at [rsp+0x28]. For frame-based
    // functions we use the pass-recovered `rbp` base when available.
    if (offset < static_cast<uint64_t>(stackParamBaseOffset) ||
        ((offset - static_cast<uint64_t>(stackParamBaseOffset)) % 8) != 0)
        return std::nullopt;

    return 5u + static_cast<unsigned>(
        (offset - static_cast<uint64_t>(stackParamBaseOffset)) / 8);
}

bool PseudoCEmitter::looksLikeStructBaseIdentifier(std::string_view name) {
    if (name.empty() || name == "rsp" || name == "rbp")
        return false;
    if (isSyntheticValueName(name))
        return false;
    if (name == "this" || name == "self")
        return true;
    if (name.starts_with("param_") || name.starts_with("arg"))
        return true;

    return name.size() <= 3 &&
           std::all_of(name.begin(), name.end(), [](unsigned char ch) {
               return std::isalnum(ch) || ch == '_';
           });
}

bool PseudoCEmitter::isCalleeSavedRegisterName(std::string_view name) {
    auto lower = toLowerCopy(name);
    return lower == "rbx" || lower == "rbp" || lower == "rdi" ||
           lower == "rsi" || lower == "r12" || lower == "r13" ||
           lower == "r14" || lower == "r15";
}

std::optional<uint64_t>
PseudoCEmitter::tryResolveSyntheticRelativeCallTarget(helix::low::CallOp call) {
    auto addr = call.getAddress();
    if (!addr)
        return std::nullopt;

    RelativeCallPattern pattern;
    collectRelativeCallPattern(call.getTargetAddr(), /*sign=*/1, pattern);
    if (!pattern.valid || pattern.largeConstCount != 1) {
        if (auto fallback =
                collectRelativeCallPatternFromString(
                    formatExpression(call.getTargetAddr()))) {
            pattern = *fallback;
        } else {
            return std::nullopt;
        }
    }

    int64_t base = static_cast<int64_t>(*addr) + 5;
    if (!pattern.baseVar.empty()) {
        auto it = syntheticCallBaseAddrs_.find(pattern.baseVar);
        if (it == syntheticCallBaseAddrs_.end()) {
            base = static_cast<int64_t>(*addr) + 5 - pattern.smallConstSum;
            syntheticCallBaseAddrs_.emplace(pattern.baseVar, base);
        } else {
            base = it->second;
        }
    }

    return static_cast<uint64_t>(base + pattern.smallConstSum +
                                 pattern.largeConstSum);
}

std::optional<uint64_t>
PseudoCEmitter::tryResolveSyntheticRelativeAddress(Value value) {
    RelativeCallPattern pattern;
    collectRelativeCallPattern(value, /*sign=*/1, pattern);
    if (!pattern.valid || pattern.largeConstCount != 1 ||
        pattern.baseVar.empty()) {
        return std::nullopt;
    }

    auto it = syntheticCallBaseAddrs_.find(pattern.baseVar);
    if (it == syntheticCallBaseAddrs_.end())
        return std::nullopt;

    return static_cast<uint64_t>(it->second + pattern.smallConstSum +
                                 pattern.largeConstSum);
}

std::string PseudoCEmitter::applyNameAliases(std::string name) const {
    auto it = nameAliases_.find(name);
    if (it != nameAliases_.end())
        return it->second;
    return name;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Transitive Copy Propagation
// ═══════════════════════════════════════════════════════════════════════════════

std::string PseudoCEmitter::resolveTransitive(const std::string& name) const {
    std::string current = name;
    std::unordered_set<std::string> visited;
    constexpr unsigned kMaxHops = 5;
    unsigned hops = 0;

    while (hops < kMaxHops) {
        if (visited.count(current))
            break; // cycle detected
        visited.insert(current);

        auto it = lastRegValue.find(current);
        if (it == lastRegValue.end())
            break;

        // Don't resolve through self-references
        if (it->second == current)
            break;

        // Don't resolve through expressions that contain the variable
        // (e.g. "rax + 1" should not be followed further)
        if (it->second.find(current) != std::string::npos &&
            it->second != current)
            break;

        // If the mapped value is not itself a synthetic temporary,
        // take it as the final resolved value
        if (!isSyntheticTemporaryName(it->second) &&
            !isSyntheticValueName(it->second)) {
            current = it->second;
            break;
        }

        // Follow the chain
        current = it->second;
        ++hops;
    }

    return current;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Variable Use-Count Pre-scan
// ═══════════════════════════════════════════════════════════════════════════════

void PseudoCEmitter::precomputeVarUseCounts(Operation* funcOp) {
    varUseCount_.clear();

    funcOp->walk([&](helix::high::VarRefOp ref) {
        auto name = applyNameAliases(ref.getVarName().str());
        ++varUseCount_[name];
    });
}

// ═══════════════════════════════════════════════════════════════════════════════
// Struct Field Name Recovery
// ═══════════════════════════════════════════════════════════════════════════════

bool PseudoCEmitter::isGenericFieldName(std::string_view name) {
    // Match patterns like: field_0, field_4, field_0x0, field_0x20, field_1A, etc.
    // These are auto-generated by the struct recovery pass / MidToHigh conversion.
    // Names that do NOT match this pattern are considered user-annotated or
    // already meaningful (e.g. "vtable", "refCount", "size").

    if (!name.starts_with("field_"))
        return false;

    auto suffix = name.substr(6); // after "field_"
    if (suffix.empty())
        return false;

    // Skip optional "0x" prefix
    if (suffix.starts_with("0x") || suffix.starts_with("0X"))
        suffix = suffix.substr(2);

    if (suffix.empty())
        return false;

    // All remaining characters must be hex digits
    for (char c : suffix) {
        if (!std::isxdigit(static_cast<unsigned char>(c)))
            return false;
    }
    return true;
}

std::string PseudoCEmitter::getRecoveredFieldName(
    const std::string& baseExpr, uint64_t offset) const
{
    auto baseIt = recoveredStructFields_.find(baseExpr);
    if (baseIt == recoveredStructFields_.end())
        return {};

    auto fieldIt = baseIt->second.find(offset);
    if (fieldIt == baseIt->second.end())
        return {};

    return fieldIt->second.name;
}

void PseudoCEmitter::prescanStructFieldNames(Operation* funcOp) {
    recoveredStructFields_.clear();

    // ── Phase 1: Collect all field accesses ─────────────────────────────
    // Track which offsets are accessed on each base expression, and how
    // they are used (compared, stored-to, used as call target, etc.).

    enum class FieldUsageHint : uint8_t {
        Unknown       = 0,
        VirtualCall   = 1,   // Offset used as indirect call target
        Comparison    = 2,   // Offset used in a comparison (flags/state)
        SmallStore    = 3,   // Small integer stored (count/size)
        FuncPtr       = 4,   // Used as a function pointer (callback)
        FirstField    = 5,   // Offset 0x0 on a struct
    };

    struct FieldAccessRecord {
        std::string baseExpr;     // Alias-resolved base expression
        uint64_t offset = 0;
        std::string originalName; // Original field_XX name from IR
        unsigned accessCount = 0;
        FieldUsageHint hint = FieldUsageHint::Unknown;
    };

    // Map: baseExpr -> (offset -> record)
    std::unordered_map<std::string,
        std::unordered_map<uint64_t, FieldAccessRecord>> fieldAccesses;

    // Helper: record a field access
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
        // Upgrade hint: more specific hints take priority
        if (hint != FieldUsageHint::Unknown &&
            (record.hint == FieldUsageHint::Unknown ||
             static_cast<uint8_t>(hint) < static_cast<uint8_t>(record.hint))) {
            record.hint = hint;
        }
    };

    // ── Scan high::FieldAccessOp ────────────────────────────────────────
    funcOp->walk([&](helix::high::FieldAccessOp fieldOp) {
        auto baseExpr = applyNameAliases(
            formatExpressionWithPrec(fieldOp.getBase(), kPrecAtom));
        auto offset = fieldOp.getFieldOffset();
        auto name = fieldOp.getFieldName().str();

        // Only consider generic names for recovery
        if (!isGenericFieldName(name))
            return;

        FieldUsageHint hint = FieldUsageHint::Unknown;

        // Check offset 0 → likely vtable or first-field
        if (offset == 0)
            hint = FieldUsageHint::FirstField;

        // Check if the field result is used in a comparison or call
        for (auto* user : fieldOp.getResult().getUsers()) {
            if (isa<arith::CmpIOp>(user) ||
                isa<helix::low::CmpOp>(user)) {
                hint = FieldUsageHint::Comparison;
                break;
            }
            // Check if result is used as an indirect call target
            if (isa<helix::low::CallOp>(user)) {
                hint = FieldUsageHint::VirtualCall;
                break;
            }
        }

        recordAccess(baseExpr, offset, name, hint);
    });

    // ── Scan mid::FieldPtrOp ────────────────────────────────────────────
    funcOp->walk([&](helix::mid::FieldPtrOp fieldPtr) {
        auto baseExpr = applyNameAliases(
            formatExpressionWithPrec(fieldPtr.getBase(), kPrecAtom));
        auto offset = fieldPtr.getFieldOffset();

        std::string name;
        if (auto nameAttr = fieldPtr.getFieldName())
            name = nameAttr->str();
        else
            name = std::format("field_0x{:x}", offset);

        if (!isGenericFieldName(name))
            return;

        FieldUsageHint hint = FieldUsageHint::Unknown;
        if (offset == 0)
            hint = FieldUsageHint::FirstField;

        // Check how the field pointer result is used
        for (auto* user : fieldPtr.getResult().getUsers()) {
            // If loaded and then called → virtual call (vtable slot)
            if (auto load = dyn_cast<helix::mid::LoadOp>(user)) {
                for (auto* loadUser : load.getResult().getUsers()) {
                    if (isa<helix::low::CallOp>(loadUser)) {
                        hint = FieldUsageHint::VirtualCall;
                        break;
                    }
                }
            }
            // If stored with a small constant → count/size
            if (auto store = dyn_cast<helix::mid::StoreOp>(user)) {
                if (auto constOp =
                        store.getValue().getDefiningOp<helix::mid::ConstantOp>()) {
                    int64_t val = constOp.getValue();
                    if (val >= 0 && val <= 1024)
                        hint = FieldUsageHint::SmallStore;
                }
            }
        }

        recordAccess(baseExpr, offset, name, hint);
    });

    // ── Scan low::MemReadOp for field-like patterns in address strings ──
    funcOp->walk([&](helix::low::MemReadOp memRead) {
        auto addrExpr = formatExpression(memRead.getAddr());

        // Look for patterns like "param_1->field_0x18" or "&this->field_0x0"
        auto arrowPos = addrExpr.find("->field_");
        if (arrowPos == std::string::npos)
            return;

        // Extract base: everything before ->
        std::string base = addrExpr.substr(0, arrowPos);
        // Strip leading '&' or '(' wrappers
        while (!base.empty() && (base.front() == '&' || base.front() == '('))
            base = base.substr(1);
        while (!base.empty() && base.back() == ')')
            base.pop_back();
        base = applyNameAliases(base);

        // Extract field name after ->
        std::string fieldPart = addrExpr.substr(arrowPos + 2); // skip "->"
        // Parse offset from field_0xNN or field_NN
        uint64_t offset = 0;
        bool parsed = false;
        if (fieldPart.starts_with("field_0x") || fieldPart.starts_with("field_0X")) {
            auto hexStr = fieldPart.substr(8);
            // Trim trailing non-hex chars
            size_t end = 0;
            while (end < hexStr.size() &&
                   std::isxdigit(static_cast<unsigned char>(hexStr[end])))
                ++end;
            if (end > 0) {
                try {
                    offset = std::stoull(std::string(hexStr.substr(0, end)),
                                         nullptr, 16);
                    parsed = true;
                } catch (...) {}
            }
        } else if (fieldPart.starts_with("field_")) {
            auto hexStr = fieldPart.substr(6);
            size_t end = 0;
            while (end < hexStr.size() &&
                   std::isxdigit(static_cast<unsigned char>(hexStr[end])))
                ++end;
            if (end > 0) {
                try {
                    offset = std::stoull(std::string(hexStr.substr(0, end)),
                                         nullptr, 16);
                    parsed = true;
                } catch (...) {}
            }
        }

        if (!parsed)
            return;

        FieldUsageHint hint = FieldUsageHint::Unknown;
        if (offset == 0)
            hint = FieldUsageHint::FirstField;

        // Check if read result is used in a comparison
        for (auto* user : memRead.getResult().getUsers()) {
            if (isa<helix::low::CmpOp>(user) ||
                isa<arith::CmpIOp>(user)) {
                hint = FieldUsageHint::Comparison;
                break;
            }
            if (isa<helix::low::CallOp>(user)) {
                hint = FieldUsageHint::VirtualCall;
                break;
            }
        }

        recordAccess(base, offset, fieldPart, hint);
    });

    // ── Scan low::MemWriteOp for field-like address patterns ────────────
    funcOp->walk([&](helix::low::MemWriteOp memWrite) {
        auto addrExpr = formatExpression(memWrite.getAddr());

        auto arrowPos = addrExpr.find("->field_");
        if (arrowPos == std::string::npos)
            return;

        std::string base = addrExpr.substr(0, arrowPos);
        while (!base.empty() && (base.front() == '&' || base.front() == '('))
            base = base.substr(1);
        while (!base.empty() && base.back() == ')')
            base.pop_back();
        base = applyNameAliases(base);

        std::string fieldPart = addrExpr.substr(arrowPos + 2);
        uint64_t offset = 0;
        bool parsed = false;
        if (fieldPart.starts_with("field_0x") || fieldPart.starts_with("field_0X")) {
            auto hexStr = fieldPart.substr(8);
            size_t end = 0;
            while (end < hexStr.size() &&
                   std::isxdigit(static_cast<unsigned char>(hexStr[end])))
                ++end;
            if (end > 0) {
                try {
                    offset = std::stoull(std::string(hexStr.substr(0, end)),
                                         nullptr, 16);
                    parsed = true;
                } catch (...) {}
            }
        } else if (fieldPart.starts_with("field_")) {
            auto hexStr = fieldPart.substr(6);
            size_t end = 0;
            while (end < hexStr.size() &&
                   std::isxdigit(static_cast<unsigned char>(hexStr[end])))
                ++end;
            if (end > 0) {
                try {
                    offset = std::stoull(std::string(hexStr.substr(0, end)),
                                         nullptr, 16);
                    parsed = true;
                } catch (...) {}
            }
        }

        if (!parsed)
            return;

        FieldUsageHint hint = FieldUsageHint::SmallStore;
        if (offset == 0)
            hint = FieldUsageHint::FirstField;

        // Check if stored value is a small constant → count/size hint
        auto valExpr = formatExpression(memWrite.getValue());
        // Quick heuristic: if valExpr is a small number, it's likely count/size
        // (the SmallStore hint is already set as default for writes)

        recordAccess(base, offset, fieldPart, hint);
    });

    // ── Phase 2: Infer meaningful names from collected patterns ─────────
    // For each base expression, sort fields by offset and assign names
    // based on usage hints and common patterns.

    for (auto& [base, offsets] : fieldAccesses) {
        // Collect sorted offsets for pattern analysis
        std::vector<uint64_t> sortedOffsets;
        sortedOffsets.reserve(offsets.size());
        for (auto& [off, _] : offsets)
            sortedOffsets.push_back(off);
        std::sort(sortedOffsets.begin(), sortedOffsets.end());

        // Determine if this looks like a vtable-holding object:
        // offset 0 accessed + at least one virtual call hint
        bool hasVtableAtZero = false;
        bool hasAnyVirtualCall = false;
        for (auto& [off, rec] : offsets) {
            if (off == 0 && (rec.hint == FieldUsageHint::FirstField ||
                             rec.hint == FieldUsageHint::VirtualCall))
                hasVtableAtZero = true;
            if (rec.hint == FieldUsageHint::VirtualCall)
                hasAnyVirtualCall = true;
        }

        // Track which offsets we've already named (to avoid collisions)
        std::unordered_set<uint64_t> namedOffsets;
        auto& recoveredMap = recoveredStructFields_[base];

        for (auto& [offset, record] : offsets) {
            // Skip if only accessed once and no strong hint — too uncertain
            if (record.accessCount < 2 &&
                record.hint == FieldUsageHint::Unknown)
                continue;

            std::string recoveredName;

            switch (record.hint) {
            case FieldUsageHint::VirtualCall:
                if (offset == 0) {
                    recoveredName = "vftable";
                } else {
                    // Vtable slot at a non-zero offset — name as vfunc_0xNN
                    // (already handled by the call emission; skip to avoid
                    // double-renaming)
                }
                break;

            case FieldUsageHint::FirstField:
                if (offset == 0) {
                    if (hasAnyVirtualCall || hasVtableAtZero)
                        recoveredName = "vftable";
                    // else: offset 0 without virtual call evidence — could be
                    // anything; stay conservative
                }
                break;

            case FieldUsageHint::Comparison:
                // Field used in comparisons → likely state/flags
                if (offset == 0 && hasVtableAtZero) {
                    recoveredName = "vftable";
                } else if (sortedOffsets.size() >= 3) {
                    // In a struct with several fields, comparison targets
                    // are often flags, state, or type discriminators
                    if (offset <= 0x10)
                        recoveredName = "flags";
                    else
                        recoveredName = "state";
                }
                break;

            case FieldUsageHint::SmallStore: {
                // Small integer stored → count, size, or length
                // Disambiguate: if there's another SmallStore field nearby,
                // use different names
                if (offset == 0 && hasVtableAtZero) {
                    recoveredName = "vftable";
                } else {
                    // Heuristic: lower offsets in a struct with vtable are
                    // often refcount; higher offsets are size/count
                    bool nearVtable = hasVtableAtZero && offset <= 0x10;
                    if (nearVtable && offset == 0x8)
                        recoveredName = "refCount";
                    else if (nearVtable && offset == 0x10)
                        recoveredName = "flags";
                    else
                        recoveredName = "count";
                }
                break;
            }

            case FieldUsageHint::FuncPtr:
                recoveredName = "callback";
                break;

            case FieldUsageHint::Unknown:
                // Only rename if there's strong structural evidence
                if (offset == 0 && hasVtableAtZero)
                    recoveredName = "vftable";
                break;
            }

            // ── Common Windows / game engine patterns ────────────────────
            // Apply additional heuristics for well-known offset patterns
            // when the base looks like a `this` pointer.
            if (recoveredName.empty() &&
                (base == "this" || base == "param_1")) {
                if (offset == 0x0 && hasAnyVirtualCall)
                    recoveredName = "vftable";
                else if (offset == 0x8 && hasVtableAtZero)
                    recoveredName = "refCount";
            }

            if (recoveredName.empty())
                continue;

            // Deduplicate: if the same name was already assigned to a
            // different offset on this base, append the offset to avoid
            // ambiguity.
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

            recoveredMap[offset] = StructFieldInfo{
                std::move(recoveredName), /*typeName=*/""};
            namedOffsets.insert(offset);
        }
    }
}

std::optional<unsigned>
PseudoCEmitter::inferWin64StackParamIndex(Operation* contextOp, Value addr) {
    if (!currentFunctionIsWin64_)
        return std::nullopt;

    auto addrExpr = formatExpression(addr);
    auto paramIndex = inferWin64StackParamIndexFromAddressString(
        addrExpr, currentWin64RbpStackParamBaseOffset_);
    if (!paramIndex)
        return std::nullopt;

    auto normalized = normalizeAddressExpression(addrExpr);
    if (normalized.starts_with("rsp+") && hasStackPointerWriteBefore(contextOp))
        return std::nullopt;

    return paramIndex;
}

bool PseudoCEmitter::hasStackPointerWriteBefore(Operation* op) {
    auto* block = op ? op->getBlock() : nullptr;
    if (!block)
        return true;

    for (Operation& candidate : *block) {
        if (&candidate == op)
            break;

        if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&candidate)) {
            auto regName = toLowerCopy(regWrite.getRegName().str());
            if (regName == "rsp" || regName == "esp")
                return true;
        }

        if (auto assign = dyn_cast<helix::high::AssignOp>(&candidate)) {
            if (formatExpression(assign.getTarget()) == "rsp")
                return true;
        }

        if (auto store = dyn_cast<LLVM::StoreOp>(&candidate)) {
            if (formatExpression(store.getAddr()) == "rsp")
                return true;
        }
    }

    return false;
}

bool PseudoCEmitter::isNearBlockBoundary(Operation* op, unsigned budget) {
    auto* block = op ? op->getBlock() : nullptr;
    if (!block)
        return false;

    unsigned fromStart = 0;
    for (auto it = block->begin(); it != block->end(); ++it) {
        if (&*it == op)
            break;
        if (!isBoundaryRelevantOp(*it))
            continue;
        ++fromStart;
        if (fromStart >= budget)
            break;
    }
    if (fromStart < budget)
        return true;

    unsigned fromEnd = 0;
    for (auto it = block->rbegin(); it != block->rend(); ++it) {
        if (&*it == op)
            break;
        if (!isBoundaryRelevantOp(*it))
            continue;
        ++fromEnd;
        if (fromEnd >= budget)
            break;
    }
    return fromEnd < budget;
}

bool PseudoCEmitter::isNearBlockStart(Operation* op, unsigned budget) {
    auto* block = op ? op->getBlock() : nullptr;
    if (!block)
        return false;

    unsigned fromStart = 0;
    for (auto it = block->begin(); it != block->end(); ++it) {
        if (&*it == op)
            return fromStart < budget;
        if (!isBoundaryRelevantOp(*it))
            continue;
        ++fromStart;
        if (fromStart >= budget)
            return false;
    }
    return false;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Private Implementation
// ═══════════════════════════════════════════════════════════════════════════════

void PseudoCEmitter::emitHeader(llvm::raw_ostream& os, ModuleOp /*module*/) {
    os << "// Decompiled by HexCore Helix\n";
    os << "// Engine version: " << HELIX_ENGINE_VERSION << "\n";
    os << "\n";
}

/// FEAT-HELIX-005: Map known native x64 opcode names to C expressions.
/// Returns the C expression string, or nullopt if the opcode is unknown.
static std::optional<std::string>
decomposeNativeOpcode(std::string_view opcode,
                      const llvm::SmallVector<std::string, 4>& args) {
    auto arg = [&](size_t i) -> std::string_view {
        return i < args.size() ? std::string_view(args[i]) : "?";
    };

    // SSE/SIMD float conversions
    if (opcode == "CVTPS2PD" && args.size() >= 1)
        return std::format("(double)({})", arg(0));
    if (opcode == "CVTPD2PS" && args.size() >= 1)
        return std::format("(float)({})", arg(0));
    if (opcode == "CVTSI2SS" && args.size() >= 1)
        return std::format("(float)({})", arg(0));
    if (opcode == "CVTSI2SD" && args.size() >= 1)
        return std::format("(double)({})", arg(0));
    if (opcode == "CVTSS2SD" && args.size() >= 1)
        return std::format("(double)({})", arg(0));
    if (opcode == "CVTSD2SS" && args.size() >= 1)
        return std::format("(float)({})", arg(0));
    if ((opcode == "CVTTSS2SI" || opcode == "CVTTSD2SI") && args.size() >= 1)
        return std::format("(int64_t)({})", arg(0));

    // SSE memory moves
    if (opcode == "MOVSD_MEM" && args.size() >= 2)
        return std::format("simd_move_scalar_double_memory({}, {})", arg(0), arg(1));
    if (opcode == "MOVSS_MEM" && args.size() >= 2)
        return std::format("simd_move_scalar_single_memory({}, {})", arg(0), arg(1));

    // SSE min/max
    // SSE min/max — handle 0-arg case (implicit xmm operands)
    if (opcode == "MINSS")
        return args.size() >= 2 ? std::format("fminf({}, {})", arg(0), arg(1))
                                : std::string("fminf(xmm0, xmm1)");
    if (opcode == "MAXSS")
        return args.size() >= 2 ? std::format("fmaxf({}, {})", arg(0), arg(1))
                                : std::string("fmaxf(xmm0, xmm1)");
    if (opcode == "MINSD")
        return args.size() >= 2 ? std::format("fmin({}, {})", arg(0), arg(1))
                                : std::string("fmin(xmm0, xmm1)");
    if (opcode == "MAXSD")
        return args.size() >= 2 ? std::format("fmax({}, {})", arg(0), arg(1))
                                : std::string("fmax(xmm0, xmm1)");
    if (opcode == "MINPS")
        return args.size() >= 2 ? std::format("_mm_min_ps({}, {})", arg(0), arg(1))
                                : std::string("_mm_min_ps(xmm0, xmm1)");
    if (opcode == "MAXPS")
        return args.size() >= 2 ? std::format("_mm_max_ps({}, {})", arg(0), arg(1))
                                : std::string("_mm_max_ps(xmm0, xmm1)");

    // Sign extension
    if (opcode == "CWDE_AX" || opcode == "CWDE")
        return args.size() >= 1 ? std::format("(int32_t)(int16_t)({})", arg(0)) : std::string("(int32_t)(int16_t)ax");
    if (opcode == "CDQE" || opcode == "CDQE_EAX")
        return args.size() >= 1 ? std::format("(int64_t)(int32_t)({})", arg(0)) : std::string("(int64_t)(int32_t)eax");
    if (opcode == "CBW")
        return args.size() >= 1 ? std::format("(int16_t)(int8_t)({})", arg(0)) : std::string("(int16_t)(int8_t)al");

    // SSE arithmetic
    // SSE arithmetic — with 0-arg fallback for implicit xmm operands
    if (opcode == "MULSS")
        return args.size() >= 2 ? std::format("{} * {}", arg(0), arg(1))
                                : std::string("xmm0 * xmm1");
    if (opcode == "MULSD")
        return args.size() >= 2 ? std::format("{} * {}", arg(0), arg(1))
                                : std::string("xmm0 * xmm1");
    if (opcode == "ADDSS")
        return args.size() >= 2 ? std::format("{} + {}", arg(0), arg(1))
                                : std::string("xmm0 + xmm1");
    if (opcode == "ADDSD")
        return args.size() >= 2 ? std::format("{} + {}", arg(0), arg(1))
                                : std::string("xmm0 + xmm1");
    if (opcode == "SUBSS")
        return args.size() >= 2 ? std::format("{} - {}", arg(0), arg(1))
                                : std::string("xmm0 - xmm1");
    if (opcode == "SUBSD")
        return args.size() >= 2 ? std::format("{} - {}", arg(0), arg(1))
                                : std::string("xmm0 - xmm1");
    if (opcode == "DIVSS")
        return args.size() >= 2 ? std::format("{} / {}", arg(0), arg(1))
                                : std::string("xmm0 / xmm1");
    if (opcode == "DIVSD")
        return args.size() >= 2 ? std::format("{} / {}", arg(0), arg(1))
                                : std::string("xmm0 / xmm1");
    if (opcode == "SQRTSS")
        return args.size() >= 1 ? std::format("sqrtf({})", arg(0))
                                : std::string("sqrtf(xmm0)");
    if (opcode == "SQRTSD")
        return args.size() >= 1 ? std::format("sqrt({})", arg(0))
                                : std::string("sqrt(xmm0)");

    // SIMD zero/move patterns
    if (opcode == "XORPS" || opcode == "PXOR" || opcode == "VXORPS")
        return std::string("0.0f");  // xorps xmm0,xmm0 → zero
    if (opcode == "XORPD" || opcode == "VPXOR" || opcode == "VXORPD")
        return std::string("0.0");   // xorpd → double zero

    // Integer division — x86 DIV/IDIV uses RDX:RAX as dividend
    if (opcode == "DIV" || opcode == "DIVrdxrax") {
        if (args.size() >= 2) return std::format("{} / {}", arg(0), arg(1));
        if (args.size() == 1) return std::format("rax / {}", arg(0));
        return std::string("rax / rdx");  // 0-arg: implicit RDX:RAX
    }
    if (opcode == "IDIV" || opcode == "IDIVrdxrax") {
        if (args.size() >= 2) return std::format("(int64_t)({}) / (int64_t)({})", arg(0), arg(1));
        if (args.size() == 1) return std::format("(int64_t)(rax) / (int64_t)({})", arg(0));
        return std::string("(int64_t)(rax) / (int64_t)(rdx)");
    }

    // Integer multiply — x86 MUL/IMUL widens to RDX:RAX
    if (opcode == "MUL" || opcode == "MULrax") {
        if (args.size() >= 2) return std::format("{} * {}", arg(0), arg(1));
        if (args.size() == 1) return std::format("rax * {}", arg(0));
        return std::string("rax * rdx");
    }
    if (opcode == "IMUL" || opcode == "IMULrax") {
        if (args.size() >= 2) return std::format("(int64_t)({}) * (int64_t)({})", arg(0), arg(1));
        if (args.size() == 1) return std::format("(int64_t)(rax) * (int64_t)({})", arg(0));
        return std::string("(int64_t)(rax) * (int64_t)(rdx)");
    }

    // Integer with carry
    if (opcode == "ADC" && args.size() >= 2)
        return std::format("{} + {} + CF", arg(0), arg(1));

    // Stack frame — ENTER should be absorbed by prologue detection.
    // If it survives, emit as comment rather than opaque call.
    if (opcode == "ENTER")
        return args.size() >= 1
            ? std::format("/* stack frame: {} bytes */", arg(0))
            : std::string("/* stack frame setup */");

    // Loop
    if (opcode == "LOOPNE" && args.size() >= 1)
        return std::format("/* LOOPNE {} — decrement ECX, jump if ECX!=0 && ZF==0 */", arg(0));

    return std::nullopt;
}

PseudoCEmitter::FunctionStats PseudoCEmitter::analyzeFunction(Operation* op) {
    FunctionStats stats;
    syntheticCallBaseAddrs_.clear();

    op->walk([&](Operation* inst) {
        stats.instructionCount++;

        // Check for bad patterns
        if (auto call = dyn_cast<helix::low::CallOp>(inst)) {
            if (!call.getTargetName() &&
                !tryResolveSyntheticRelativeCallTarget(call)) {
                // Indirect call or unresolved target
                stats.badPatterns++;
                stats.issues.push_back("Unresolved call target");
            }
        }

        if (isa<helix::high::AsmOp>(inst)) {
            stats.badPatterns++;
            stats.issues.push_back("Inline assembly");
        }

        if (auto memRead = dyn_cast<helix::low::MemReadOp>(inst)) {
            // Check for null dereference
            auto addr = formatExpression(memRead.getAddr());
            if (addr == "0" || addr == "(void*)(0)" || addr == "NULL") {
                stats.badPatterns += 5;
                stats.issues.push_back("Null pointer dereference");
            }
        }
        
        if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(inst)) {
             // Check for null write
            auto addr = formatExpression(memWrite.getAddr());
            if (addr == "0" || addr == "(void*)(0)" || addr == "NULL") {
                stats.badPatterns += 5;
                stats.issues.push_back("Null pointer write");
            }
        }

        // Check for goto usage (unstructured control flow)
        if (isa<helix::low::JmpOp>(inst)) {
             // Basic block ending with unconditional jump isn't necessarily bad, 
             // but excessive use indicates failure to structure control flow.
             // We can't distinguish loop back-edges easily here without CFG analysis,
             // but raw JmpOps usually mean unstructured code.
             // However, helix::low::JmpOp is used for 'goto' in emitRegionBody.
        }
    });

    // Calculate score
    // Base score 100
    // Deduct for bad patterns
    double deduction = (double)stats.badPatterns * 2.0;

    // Penalize stub functions with very few statements (FEAT-HELIX-004)
    if (stats.instructionCount < 5) {
        deduction += 40.0;  // Stubs with < 5 ops are very low quality
        stats.issues.push_back("Stub function (< 5 statements)");
    } else if (stats.instructionCount < 10) {
        deduction += 15.0;
        stats.issues.push_back("Very short function (< 10 statements)");
    }

    // Count native opcode calls that weren't decomposed (FEAT-HELIX-005)
    // These appear as CallOps with names like CVTPS2PD, MOVSD_MEM, etc.
    int nativeOpcodeCalls = 0;
    op->walk([&](Operation* inst) {
        if (auto call = dyn_cast<helix::low::CallOp>(inst)) {
            if (auto name = call.getTargetName()) {
                auto nameStr = name->str();
                // Native opcodes are ALL_CAPS with underscores
                bool allUpper = !nameStr.empty();
                for (char c : nameStr) {
                    if (!std::isupper(c) && c != '_' && !std::isdigit(c)) {
                        allUpper = false;
                        break;
                    }
                }
                if (allUpper && nameStr.size() >= 3) {
                    nativeOpcodeCalls++;
                }
            }
        }
    });
    if (nativeOpcodeCalls > 0) {
        // Each undecomposed opcode call reduces quality
        double opcodePenalty = std::min(30.0, (double)nativeOpcodeCalls * 3.0);
        deduction += opcodePenalty;
        stats.issues.push_back(
            std::format("{} native opcode call(s) not decomposed", nativeOpcodeCalls));
    }

    // ── Register names used as local variables ─────────────────────────
    // When register names (rax, rdi, r15, xmm0, etc.) appear as local
    // variable names, it means variable recovery failed to give them
    // meaningful names.  This is a major quality indicator.
    {
        static const char* kRegPatterns[] = {
            "rax", "rbx", "rcx", "rdx", "rsi", "rdi", "rbp", "rsp",
            "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
            "xmm0", "xmm1", "xmm2", "xmm3", "xmm4", "xmm5",
        };
        int regVarCount = 0;
        op->walk([&](helix::high::VarDeclOp decl) {
            if (decl.getStorage() == helix::high::StorageKind::Parameter)
                return;
            auto name = decl.getVarName();
            for (auto* reg : kRegPatterns) {
                if (name == reg) { regVarCount++; break; }
            }
        });
        if (regVarCount > 0) {
            double regPenalty = std::min(20.0, (double)regVarCount * 2.0);
            deduction += regPenalty;
            stats.issues.push_back(
                std::format("{} register name(s) as local variables", regVarCount));
        }
    }

    // ── Dead store chains ──────────────────────────────────────────────
    // Multiple consecutive assignments to the same target without reads
    // indicate failed optimization or degenerate output.
    {
        int deadStoreCount = 0;
        for (auto& block : op->getRegion(0)) {
            std::string lastTarget;
            int consecutive = 0;
            for (auto& inst : block) {
                if (auto assign = dyn_cast<helix::high::AssignOp>(&inst)) {
                    auto target = formatExpression(assign.getTarget());
                    if (target == lastTarget) {
                        consecutive++;
                        if (consecutive >= 2) deadStoreCount++;
                    } else {
                        consecutive = 0;
                        lastTarget = target;
                    }
                } else {
                    lastTarget.clear();
                    consecutive = 0;
                }
            }
        }
        if (deadStoreCount > 0) {
            double dsPenalty = std::min(20.0, (double)deadStoreCount * 2.0);
            deduction += dsPenalty;
            stats.issues.push_back(
                std::format("{} dead store chain(s) detected", deadStoreCount));
        }
    }

    // ── Goto count ─────────────────────────────────────────────────────
    // Excessive gotos indicate failed control flow structuring.
    {
        int gotoCount = 0;
        op->walk([&](helix::high::GotoOp) { gotoCount++; });
        if (gotoCount > 3) {
            double gotoPenalty = std::min(15.0, (double)(gotoCount - 3) * 3.0);
            deduction += gotoPenalty;
            stats.issues.push_back(
                std::format("{} goto statement(s) (unstructured control flow)", gotoCount));
        }
    }

    // ── Empty structured blocks ────────────────────────────────────────
    // Empty if/else bodies indicate degenerate structuring.
    {
        int emptyBodies = 0;
        op->walk([&](helix::high::IfOp ifOp) {
            if (ifOp.getThenRegion().empty() ||
                (ifOp.getThenRegion().front().getOperations().size() <= 1))
                emptyBodies++;
            if (!ifOp.getElseRegion().empty() &&
                ifOp.getElseRegion().front().getOperations().size() <= 1)
                emptyBodies++;
        });
        if (emptyBodies > 0) {
            deduction += (double)emptyBodies * 3.0;
            stats.issues.push_back(
                std::format("{} empty if/else block(s)", emptyBodies));
        }
    }

    // ── Functions with only return statements ───────────────────────────
    // A function that has many IR ops but produces only `return;` in output
    // is likely a stub or a mislifted function.  Penalize if the function
    // has no calls, no stores, no assignments beyond the return.
    {
        int meaningfulOps = 0;
        op->walk([&](Operation* inst) {
            if (isa<helix::high::AssignOp>(inst) ||
                isa<helix::low::CallOp>(inst) ||
                isa<helix::high::CallOp>(inst) ||
                isa<helix::low::MemWriteOp>(inst))
                meaningfulOps++;
        });
        if (meaningfulOps == 0 && stats.instructionCount >= 5) {
            deduction += 30.0;
            stats.issues.push_back("No meaningful operations (empty body)");
        }
    }

    // Deduct for complexity if very large
    if (stats.instructionCount > 1000) {
        deduction += (stats.instructionCount - 1000) * 0.01;
    }

    stats.score = std::max(0.0, 100.0 - deduction);

    return stats;
}

void PseudoCEmitter::emitFunction(Operation* op, llvm::raw_ostream& os) {
    auto funcNameAttr = op->getAttrOfType<StringAttr>("sym_name");
    auto entryAddrAttr = op->getAttrOfType<IntegerAttr>("entry_address");
    if (!funcNameAttr || !entryAddrAttr)
        return;
    auto funcName = funcNameAttr.getValue();
    uint64_t entryAddr = entryAddrAttr.getValue().getZExtValue();

    lastRegValue.clear(); // Reset copy propagation state for new function
    varUseCount_.clear();
    exprToBestName_.clear();
    nameAliases_.clear();
    syntheticCallBaseAddrs_.clear();
    recoveredStructFields_.clear();
    referencedBlocks_.clear();
    referencedLabelNames_.clear();
    currentFunctionName_ = funcName.str();
    currentFunctionEntryAddr_ = entryAddr;
    currentReturnValueName_.clear();
    currentFunctionHasReturnValue_ = op->hasAttr("has_return_value");
    currentFunctionIsWin64_ = true;
    if (auto ccAttr = op->getAttrOfType<StringAttr>("calling_convention"))
        currentFunctionIsWin64_ = (ccAttr.getValue() == "win64");
    // Initialize block labels for the entire function
    globalBlockCounter_ = 1;
    blockLabels_.clear();
    op->walk([&](mlir::Block* block) {
        // Try to get an address from the first op for a meaningful label.
        uint64_t addr = 0;
        if (!block->empty()) {
            if (auto addrAttr = block->front().getAttrOfType<IntegerAttr>("address"))
                addr = addrAttr.getUInt();
        }
        if (addr != 0)
            blockLabels_[block] = std::format("loc_{:x}", addr);
        else
            blockLabels_[block] = std::format("block_{}", globalBlockCounter_++);
    });

    auto collectEmittedLabelReferences =
        [&](auto&& self, Region& region) -> void {
            auto nextBlockInRegion = [&](Block* block) -> Block* {
                if (!block)
                    return nullptr;
                auto it = block->getIterator();
                ++it;
                if (it == region.end())
                    return nullptr;
                return &*it;
            };

            auto getNonLabelOps = [&](Block* block) {
                llvm::SmallVector<Operation*, 4> ops;
                if (!block)
                    return ops;
                for (auto& nested : *block) {
                    if (isa<helix::high::LabelOp>(&nested))
                        continue;
                    ops.push_back(&nested);
                }
                return ops;
            };

            auto resolveJumpOnlyBlock = [&](Block* block) -> Block* {
                llvm::SmallPtrSet<Block*, 8> visited;
                Block* current = block;
                unsigned depthBudget = 6;
                while (current && depthBudget-- > 0 &&
                       visited.insert(current).second) {
                    auto ops = getNonLabelOps(current);
                    if (ops.size() != 1)
                        break;
                    if (auto jmp = dyn_cast<helix::low::JmpOp>(ops.front())) {
                        current = jmp.getDest();
                        continue;
                    }
                    break;
                }
                return current;
            };

            auto getTrivialReturnOp = [&](Block* block) -> Operation* {
                Block* resolved = resolveJumpOnlyBlock(block);
                auto ops = getNonLabelOps(resolved);
                if (ops.size() != 1)
                    return nullptr;
                if (isa<helix::low::RetOp>(ops.front()) ||
                    isa<helix::high::ReturnOp>(ops.front())) {
                    return ops.front();
                }
                return nullptr;
            };

            for (auto& block : region) {
                for (auto& nestedOp : block.getOperations()) {
                    if (auto gotoOp = dyn_cast<helix::high::GotoOp>(&nestedOp)) {
                        referencedLabelNames_.insert(gotoOp.getLabel().str());
                    } else if (auto jmp = dyn_cast<helix::low::JmpOp>(&nestedOp)) {
                        Block* dest = resolveJumpOnlyBlock(jmp.getDest());
                        if (dest != nextBlockInRegion(&block) &&
                            !getTrivialReturnOp(dest)) {
                            referencedBlocks_.insert(dest);
                        }
                    } else if (auto jcc = dyn_cast<helix::low::JccOp>(&nestedOp)) {
                        Block* trueDest = resolveJumpOnlyBlock(jcc.getTrueDest());
                        Block* falseDest = resolveJumpOnlyBlock(jcc.getFalseDest());
                        Block* nextBlock = nextBlockInRegion(&block);

                        if (getTrivialReturnOp(trueDest) &&
                            getTrivialReturnOp(falseDest)) {
                            continue;
                        }
                        if (trueDest == nextBlock &&
                            getTrivialReturnOp(falseDest)) {
                            continue;
                        }
                        if (falseDest == nextBlock &&
                            getTrivialReturnOp(trueDest)) {
                            continue;
                        }
                        if (trueDest)
                            referencedBlocks_.insert(trueDest);
                    }

                    for (Region& nestedRegion : nestedOp.getRegions())
                        self(self, nestedRegion);
                }
            }
        };
    for (Region& region : op->getRegions())
        collectEmittedLabelReferences(collectEmittedLabelReferences, region);

    // ── Detect return-only labels ────────────────────────────────────────
    // If a label is followed only by more labels and a single `return`,
    // gotos targeting it can be replaced with `return` directly.
    returnOnlyLabels_.clear();
    op->walk([&](helix::high::LabelOp labelOp) {
        // Walk forward from this label: skip other LabelOps, check if the
        // only non-label op is a ReturnOp or low::RetOp.
        auto* block = labelOp->getBlock();
        if (!block) return;

        bool foundReturn = false;
        bool foundOther = false;
        auto it = std::next(labelOp->getIterator());
        for (; it != block->end(); ++it) {
            if (isa<helix::high::LabelOp>(&*it))
                continue;
            if (isa<helix::high::ReturnOp>(&*it) ||
                isa<helix::low::RetOp>(&*it)) {
                foundReturn = true;
                break;
            }
            foundOther = true;
            break;
        }

        if (foundReturn && !foundOther) {
            returnOnlyLabels_.insert(labelOp.getName().str());
        }
    });

    // Remove return-only labels from the referenced set so they don't emit.
    for (const auto& name : returnOnlyLabels_) {
        referencedLabelNames_.erase(name);
    }

    // Analyze function quality
    FunctionStats stats = analyzeFunction(op);

    // Emit function header with stats
    os << "// -----------------------------------------------------------------------------\n";
    os << "// " << funcName.str() << " (0x" << std::format("{:x}", entryAddr) << ")\n";
    os << "// Confidence: " << std::format("{:.1f}%", stats.score);
    
    if (stats.score > 80.0) os << " (High)\n";
    else if (stats.score > 50.0) os << " (Medium)\n";
    else os << " (Low)\n";

    if (!stats.issues.empty()) {
        os << "// Issues:\n";
        // Deduplicate issues
        std::sort(stats.issues.begin(), stats.issues.end());
        stats.issues.erase(std::unique(stats.issues.begin(), stats.issues.end()), stats.issues.end());
        
        for (const auto& issue : stats.issues) {
            os << "//  - " << issue << "\n";
        }
    }
    os << "// -----------------------------------------------------------------------------\n";

    // Return type (default to int64_t for now, refined by type propagation)
    bool hasReturnValue =
        op->hasAttr("has_return_value") || inferLikelyReturnValue(op);
    currentFunctionHasReturnValue_ = hasReturnValue;
    currentReturnValueName_.clear();
    currentFunctionIsWin64_ = true;
    currentWin64RbpStackParamBaseOffset_ = 0x28;
    currentWin64StackParamLimit_ = 4;
    if (auto ccAttr = op->getAttrOfType<StringAttr>("calling_convention"))
        currentFunctionIsWin64_ = (ccAttr.getValue() == "win64");
    if (auto rbpBaseAttr =
            op->getAttrOfType<IntegerAttr>("win64_rbp_param_base_offset")) {
        currentWin64RbpStackParamBaseOffset_ =
            rbpBaseAttr.getValue().getSExtValue();
    }
    nameAliases_.clear();

    std::string returnType = hasReturnValue ? "int64_t" : "void";

    struct ParamInfo {
        std::string typeStr;
        std::string rawName;
    };

    std::map<unsigned, ParamInfo> paramInfoByIndex;
    llvm::SmallVector<std::string> syntheticLocalNames;
    llvm::SmallVector<std::string> extraNamedParams;
    auto recordParam = [&](unsigned index, const std::string& typeStr,
                           const std::string& rawName) {
        auto [it, inserted] = paramInfoByIndex.try_emplace(index, ParamInfo{typeStr, rawName});
        if (!inserted) {
            if (it->second.typeStr == "int64_t" && typeStr != "int64_t")
                it->second.typeStr = typeStr;
            if (it->second.rawName.empty())
                it->second.rawName = rawName;
        }
    };

    op->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getStorage() != helix::high::StorageKind::Parameter)
            return;

        std::string paramType = "int64_t";
        if (auto inferredType = decl->getAttrOfType<StringAttr>("inferred_type"))
            paramType = inferredType.getValue().str();

        std::string rawName = decl.getVarName().str();
        if (auto index = parseParamIndex(rawName))
            recordParam(*index, paramType, rawName);
        else
            extraNamedParams.push_back(std::format("{} {}", paramType, rawName));
    });

    op->walk([&](helix::high::VarRefOp ref) {
        if (auto index = parseParamIndex(ref.getVarName().str())) {
            recordParam(*index, "int64_t", ref.getVarName().str());
        }
    });

    std::set<unsigned> observedStackParams;
    op->walk([&](helix::low::MemReadOp memRead) {
        auto addrExpr = formatExpression(memRead.getAddr());
        auto normalized = normalizeAddressExpression(addrExpr);
        if (auto index = inferWin64StackParamIndex(memRead.getOperation(),
                                                   memRead.getAddr())) {
            if (normalized.starts_with("rbp+") ||
                isNearBlockStart(memRead.getOperation(), 48)) {
                observedStackParams.insert(*index);
            }
        }
    });
    op->walk([&](LLVM::LoadOp load) {
        auto addrExpr = formatExpression(load.getAddr());
        auto normalized = normalizeAddressExpression(addrExpr);
        if (auto index = inferWin64StackParamIndex(load.getOperation(),
                                                   load.getAddr())) {
            if (normalized.starts_with("rbp+") ||
                isNearBlockStart(load.getOperation(), 48)) {
                observedStackParams.insert(*index);
            }
        }
    });
    op->walk([&](helix::high::AssignOp assign) {
        auto valueExpr = formatExpression(assign.getValue());
        auto addrExpr = extractDereferencedAddressExpression(valueExpr);
        if (!addrExpr) {
            return;
        }

        if (auto index = inferWin64StackParamIndexFromAddressString(
                *addrExpr, currentWin64RbpStackParamBaseOffset_)) {
            observedStackParams.insert(*index);
        }
    });
    for (const auto& [index, _] : paramInfoByIndex) {
        if (index > 4)
            observedStackParams.insert(index);
    }
    std::set<unsigned> recoveredStackParamIndices;
    for (const auto& [index, _] : paramInfoByIndex) {
        if (index > 4)
            recoveredStackParamIndices.insert(index);
    }

    auto inferredStackParamLimit =
        inferDenseObservedStackParamLimit(observedStackParams);
    currentWin64StackParamLimit_ = inferredStackParamLimit.value_or(4);
    if (currentWin64StackParamLimit_ == 4 &&
        recoveredStackParamIndices.contains(5)) {
        currentWin64StackParamLimit_ = 5;
    }
    if (currentWin64StackParamLimit_ == 4) {
        unsigned denseRunEnd = 0;
        for (unsigned index = 6; recoveredStackParamIndices.contains(index); ++index)
            denseRunEnd = index;
        if (denseRunEnd >= 7)
            currentWin64StackParamLimit_ = denseRunEnd;
    }
    if (currentWin64StackParamLimit_ >= 5) {
        for (unsigned index = 5; index <= currentWin64StackParamLimit_; ++index)
            recordParam(index, "int64_t", std::format("param_{}", index));
    }

    for (auto it = paramInfoByIndex.begin(); it != paramInfoByIndex.end();) {
        if (it->first > 4 && it->first > currentWin64StackParamLimit_) {
            std::string originalName = it->second.rawName.empty()
                ? std::format("param_{}", it->first)
                : it->second.rawName;
            std::string syntheticName = std::format("spill_{}", it->first);
            nameAliases_[originalName] = syntheticName;
            syntheticLocalNames.push_back(syntheticName);
            it = paramInfoByIndex.erase(it);
            continue;
        }
        ++it;
    }

    // Fall back to ABI register parameters when recovery did not materialize
    // explicit parameter declarations.
    if (paramInfoByIndex.empty() && extraNamedParams.empty()) {
        llvm::StringMap<bool> usedArgRegs;
        static const std::pair<const char*, unsigned> kWin64Args[] = {
            {"RCX", 1}, {"RDX", 2}, {"R8", 3}, {"R9", 4}
        };
        op->walk([&](helix::low::RegReadOp regRead) {
            auto name = regRead.getRegName();
            for (auto [reg, index] : kWin64Args) {
                if (name == reg || name == llvm::StringRef(reg).lower())
                    usedArgRegs[reg] = true;
            }
            if (name == "ECX") usedArgRegs["RCX"] = true;
            if (name == "EDX") usedArgRegs["RDX"] = true;
            if (name == "R8D") usedArgRegs["R8"] = true;
            if (name == "R9D") usedArgRegs["R9"] = true;
        });

        int maxArgIdx = -1;
        for (int i = 0; i < 4; ++i) {
            if (usedArgRegs.count(kWin64Args[i].first))
                maxArgIdx = i;
        }
        for (int i = 0; i <= maxArgIdx; ++i) {
            unsigned index = kWin64Args[i].second;
            recordParam(index, "int64_t", std::format("param_{}", index));
        }
    }

    // Heuristic: if param_1 is repeatedly used as the base of field accesses,
    // emit it as `this` to make methods/constructors read naturally.
    if (paramInfoByIndex.count(1)) {
        unsigned objectUseScore = 0;
        auto bumpIfThisLike = [&](const std::string& expr) {
            if (expr.find("param_1->field_") != std::string::npos ||
                expr.find("&param_1->field_") != std::string::npos) {
                ++objectUseScore;
            }
        };

        op->walk([&](helix::low::MemReadOp memRead) {
            bumpIfThisLike(formatExpression(memRead.getAddr()));
        });
        op->walk([&](helix::low::MemWriteOp memWrite) {
            bumpIfThisLike(formatExpression(memWrite.getAddr()));
        });
        op->walk([&](helix::low::CallOp call) {
            bumpIfThisLike(formatExpression(call.getTargetAddr()));
            for (auto arg : call.getArgs())
                bumpIfThisLike(formatExpression(arg));
        });
        op->walk([&](helix::high::FieldAccessOp field) {
            if (formatExpression(field.getBase()) == "param_1")
                objectUseScore += 2;
        });

        if (objectUseScore >= 3) {
            nameAliases_["param_1"] = "this";
            auto& selfParam = paramInfoByIndex[1];
            selfParam.rawName = "this";
            if (selfParam.typeStr == "int64_t")
                selfParam.typeStr = "void*";
        }
    }

    llvm::SmallVector<std::string> params;
    if (!paramInfoByIndex.empty()) {
        for (const auto& [index, info] : paramInfoByIndex) {
            std::string paramType = info.typeStr;
            std::string paramName = info.rawName.empty()
                ? std::format("param_{}", index)
                : info.rawName;
            paramName = applyNameAliases(paramName);
            params.push_back(std::format("{} {}", paramType, paramName));
        }
    }
    for (const auto& extra : extraNamedParams)
        params.push_back(extra);

    // Function signature
    os << std::format("{} {}(", returnType, funcName.str());
    if (params.empty()) {
        os << "void";
    } else {
        for (size_t i = 0; i < params.size(); i++) {
            if (i > 0) os << ", ";
            os << params[i];
        }
    }
    os << ") {\n";

    // Collect referenced var_ids to filter unused declarations.
    // Exclude references that only appear in infrastructure-marked ops —
    // these are PC tracking, flag bookkeeping, etc. that won't be emitted.
    llvm::DenseSet<uint32_t> referencedVarIds;
    op->walk([&](helix::high::VarRefOp ref) {
        // Skip VarRefs that are only used as targets of infra assignments
        // or are themselves infrastructure-marked.
        if (ref->hasAttr("helix.infrastructure"))
            return;
        // Also skip if the sole user is an infra-marked assignment
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

    // Build stack offset → variable name map for resolving rbp±offset
    stackOffsetToVarName_.clear();
    op->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getStorage() != helix::high::StorageKind::Stack)
            return;
        if (auto offset = decl.getStackOffset()) {
            stackOffsetToVarName_[*offset] = decl.getVarName().str();
        }
    });

    globalAddrToVarName_.clear();

    // Collect non-parameter declarations grouped by storage kind:
    //   Stack (locals) → Register → Temporary
    struct VarDeclInfo {
        std::string typeStr;
        std::string name;
        helix::high::StorageKind storage;
    };
    llvm::SmallVector<VarDeclInfo> stackDecls, registerDecls, tempDecls;
    std::set<std::string> declaredLocalNames;

    op->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getStorage() == helix::high::StorageKind::Parameter)
            return;

        // Skip infrastructure-marked variable declarations
        if (decl->hasAttr("helix.infrastructure"))
            return;

        // Skip variables not referenced in the function body
        if (!referencedVarIds.contains(decl.getVarId()))
            return;

        std::string typeStr = "int64_t";
        if (auto inferredType = decl->getAttrOfType<StringAttr>("inferred_type"))
            typeStr = inferredType.getValue().str();

        VarDeclInfo info{typeStr, decl.getVarName().str(), decl.getStorage()};
        declaredLocalNames.insert(info.name);

        switch (decl.getStorage()) {
        case helix::high::StorageKind::Stack:
            stackDecls.push_back(std::move(info));
            break;
        case helix::high::StorageKind::Register:
            registerDecls.push_back(std::move(info));
            break;
        case helix::high::StorageKind::Temporary:
            tempDecls.push_back(std::move(info));
            break;
        default:
            // Global or other — emit with temporaries
            tempDecls.push_back(std::move(info));
            break;
        }
    });

    for (const auto& syntheticName : syntheticLocalNames) {
        declaredLocalNames.insert(syntheticName);
        tempDecls.push_back(
            VarDeclInfo{"int64_t", syntheticName, helix::high::StorageKind::Temporary});
    }

    op->walk([&](helix::high::VarRefOp ref) {
        std::string name = applyNameAliases(ref.getVarName().str());
        if (declaredLocalNames.contains(name))
            return;
        if (parseParamIndex(name))
            return;
        if (name == "this")
            return;
        if (!name.starts_with("var_") && !name.starts_with("spill_"))
            return;

        declaredLocalNames.insert(name);
        tempDecls.push_back(
            VarDeclInfo{"int64_t", name, helix::high::StorageKind::Temporary});
    });

    if (hasReturnValue) {
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

    // Emit grouped declarations: locals → registers → temporaries
    auto emitDeclGroup = [&](const llvm::SmallVector<VarDeclInfo>& decls) {
        for (const auto& d : decls) {
            indent(os, 1);
            os << std::format("{}  {};\n", d.typeStr, d.name);
        }
    };

    // Pre-scan variable use counts for single-use temporary elimination
    precomputeVarUseCounts(op);

    // Pre-scan struct field accesses to recover meaningful field names
    prescanStructFieldNames(op);

    // ── Two-pass emission: emit body first, then filter declarations ──
    //
    // Body statements are emitted to a temporary buffer.  This allows us
    // to determine which variable names actually appear in the emitted
    // output — filtering out _promoted_N, spill_N, and other variables
    // whose assignments were suppressed by infrastructure/heuristic filters.
    std::string bodyBuffer;
    llvm::raw_string_ostream bodyOs(bodyBuffer);
    if (!op->getRegion(0).empty()) {
        emitRegionBody(op->getRegion(0), bodyOs, 1);
    }

    // Filter declarations: only emit variables that appear in the body.
    auto emitFilteredDeclGroup = [&](const llvm::SmallVector<VarDeclInfo>& decls) {
        for (const auto& d : decls) {
            // Always emit stack locals and parameters — they're structural.
            // Only filter temporaries and register vars with synthetic names.
            bool shouldFilter =
                (d.name.starts_with("_promoted_") ||
                 d.name.starts_with("spill_") ||
                 d.name.starts_with("_spill_"));
            if (shouldFilter && bodyBuffer.find(d.name) == std::string::npos)
                continue;  // Variable not used in emitted body — skip
            indent(os, 1);
            os << std::format("{}  {};\n", d.typeStr, d.name);
        }
    };

    emitFilteredDeclGroup(stackDecls);
    emitFilteredDeclGroup(registerDecls);
    emitFilteredDeclGroup(tempDecls);

    // ── Post-process: eliminate consecutive dead stores in emitted text ──
    //
    // After all emission is done, scan the body buffer for consecutive lines
    // that assign to the same target: "    rax = X;\n    rax = Y;\n" → keep
    // only "    rax = Y;\n".  This catches cross-block dead stores that the
    // IR-level DSE misses (Remill lifts each instruction to a separate block).
    {
        std::string cleaned;
        cleaned.reserve(bodyBuffer.size());

        std::istringstream stream(bodyBuffer);
        std::string currentLine, nextLine;

        auto extractTarget = [](const std::string& line) -> std::string {
            // Find "target = " pattern in an indented assignment line.
            // Lines look like: "    rax = *0x1418e0a84;\n"
            auto eqPos = line.find(" = ");
            if (eqPos == std::string::npos)
                return "";
            // Extract the target (trimmed of leading whitespace)
            auto trimmed = line.substr(0, eqPos);
            auto firstNonSpace = trimmed.find_first_not_of(" \t");
            if (firstNonSpace == std::string::npos)
                return "";
            auto target = trimmed.substr(firstNonSpace);
            // Only simple identifiers (no ->, *, [, //, /*)
            if (target.find("->") != std::string::npos ||
                target.find("*(") != std::string::npos ||
                target.find("[") != std::string::npos ||
                target.find("//") != std::string::npos ||
                target.find("/*") != std::string::npos ||
                target.find("if ") != std::string::npos ||
                target.find("goto ") != std::string::npos ||
                target.find("return") != std::string::npos)
                return "";
            // Skip side-effecting RHS
            auto rhs = line.substr(eqPos + 3);
            if (rhs.find("sub_") != std::string::npos ||
                rhs.find("call") != std::string::npos ||
                rhs.find("vfunc_") != std::string::npos)
                return "";
            return target;
        };

        if (std::getline(stream, currentLine)) {
            while (std::getline(stream, nextLine)) {
                auto curTarget = extractTarget(currentLine);
                auto nextTarget = extractTarget(nextLine);
                // If both assign to the same simple target, skip current line
                if (!curTarget.empty() && curTarget == nextTarget) {
                    // Dead store — drop currentLine, advance
                } else {
                    cleaned += currentLine + "\n";
                }
                currentLine = std::move(nextLine);
            }
            cleaned += currentLine + "\n";
        }
        bodyBuffer = std::move(cleaned);
    }

    // ── Post-process: eliminate empty if blocks ─────────────────────────
    //
    // Patterns:
    //   "if (cond) {\n    } else {\n" → "if (!(cond)) {\n"
    //   "if (cond) {\n    }\n" (no else, no body) → remove entirely
    {
        std::string cleaned;
        cleaned.reserve(bodyBuffer.size());
        std::istringstream stream(bodyBuffer);
        std::vector<std::string> lines;
        std::string line;
        while (std::getline(stream, line))
            lines.push_back(line);

        for (size_t i = 0; i < lines.size(); i++) {
            auto trimmed = lines[i];
            auto firstNonSpace = trimmed.find_first_not_of(" \t");
            auto content = (firstNonSpace != std::string::npos)
                ? trimmed.substr(firstNonSpace) : "";

            // Pattern: "if (...) {" followed by "} else {"
            // → empty then-block, invert condition
            if (content.starts_with("if (") && content.ends_with(") {") &&
                i + 1 < lines.size()) {
                auto nextContent = lines[i + 1];
                auto nextFirst = nextContent.find_first_not_of(" \t");
                auto nextTrim = (nextFirst != std::string::npos)
                    ? nextContent.substr(nextFirst) : "";
                if (nextTrim == "} else {") {
                    // Extract condition
                    auto condStart = content.find("(");
                    auto condEnd = content.rfind(")");
                    if (condStart != std::string::npos && condEnd != std::string::npos &&
                        condEnd > condStart) {
                        auto cond = content.substr(condStart + 1, condEnd - condStart - 1);
                        auto indent = (firstNonSpace != std::string::npos)
                            ? trimmed.substr(0, firstNonSpace) : "";
                        cleaned += indent + "if (!(" + cond + ")) {\n";
                        i++; // skip the "} else {" line
                        continue;
                    }
                }
                // Pattern: "if (...) {" followed by "}" (empty body, no else)
                if (nextTrim == "}") {
                    i++; // skip the "}" line
                    continue; // drop the empty if entirely
                }
            }

            cleaned += lines[i] + "\n";
        }
        bodyBuffer = std::move(cleaned);
    }

    // ── Post-process: eliminate unreachable labels ──────────────────────
    //
    // If a label (e.g., "loc_14046de39:") is never referenced by a "goto"
    // in the body, it's unreachable dead code.  Remove the label and all
    // code until the next label, closing brace, or end of function.
    {
        // Collect all goto targets
        std::set<std::string> gotoTargets;
        {
            std::istringstream scan(bodyBuffer);
            std::string line;
            while (std::getline(scan, line)) {
                auto gotoPos = line.find("goto ");
                if (gotoPos != std::string::npos) {
                    auto target = line.substr(gotoPos + 5);
                    // Strip trailing ; and whitespace
                    while (!target.empty() && (target.back() == ';' || target.back() == ' '))
                        target.pop_back();
                    gotoTargets.insert(target);
                }
            }
        }

        std::string cleaned;
        cleaned.reserve(bodyBuffer.size());
        std::istringstream stream(bodyBuffer);
        std::string line;
        bool suppressing = false;

        while (std::getline(stream, line)) {
            auto trimmed = line;
            auto firstNonSpace = trimmed.find_first_not_of(" \t");
            auto content = (firstNonSpace != std::string::npos)
                ? trimmed.substr(firstNonSpace) : "";

            // Check if this is a label line (ends with ":")
            if (!content.empty() && content.back() == ':' &&
                !content.starts_with("//") && !content.starts_with("/*") &&
                content.find(" ") == std::string::npos) {
                auto labelName = content.substr(0, content.size() - 1);
                if (gotoTargets.count(labelName)) {
                    suppressing = false;  // Referenced label — stop suppressing
                } else {
                    suppressing = true;   // Unreferenced label — start suppressing
                    continue;
                }
            }

            // Stop suppressing at closing braces or other labels
            if (suppressing) {
                if (content == "}" || content == "} else {" ||
                    (!content.empty() && content.back() == ':' &&
                     content.find(" ") == std::string::npos)) {
                    suppressing = false;
                } else {
                    continue;  // Suppress this line
                }
            }

            cleaned += line + "\n";
        }
        bodyBuffer = std::move(cleaned);
    }

    // ── Post-process: expression simplification ────────────────────────
    //
    // Simple text-level rewrites for common patterns:
    //   x * -1  → -x     (negate via multiply)
    //   x + 0   → x      (identity add)
    //   x & 0   → 0      (zero mask — but might have side effects, skip)
    //   x | 0   → x      (identity or)
    {
        // Replace " * -1" with negate
        std::string::size_type pos = 0;
        while ((pos = bodyBuffer.find(" * -1", pos)) != std::string::npos) {
            // Check that it ends the expression (followed by ; or ) or space)
            auto after = pos + 5;
            if (after < bodyBuffer.size() &&
                bodyBuffer[after] != ';' && bodyBuffer[after] != ')' &&
                bodyBuffer[after] != ' ' && bodyBuffer[after] != '\n') {
                pos++;
                continue;
            }
            // Find the start of the expression (the operand before " * -1")
            // Look backwards for " = " to find the RHS start
            auto eqPos = bodyBuffer.rfind(" = ", pos);
            if (eqPos != std::string::npos && eqPos < pos) {
                auto operand = bodyBuffer.substr(eqPos + 3, pos - eqPos - 3);
                // Replace "operand * -1" with "-(operand)"
                bodyBuffer.replace(eqPos + 3, pos - eqPos - 3 + 5,
                    "-(" + operand + ")");
                pos = eqPos + 3;
            } else {
                pos++;
            }
        }

        // Replace " + 0;" with ";" and " += 0;" with removal
        pos = 0;
        while ((pos = bodyBuffer.find(" += 0;\n", pos)) != std::string::npos) {
            // Find the start of this line
            auto lineStart = bodyBuffer.rfind('\n', pos);
            lineStart = (lineStart == std::string::npos) ? 0 : lineStart + 1;
            bodyBuffer.erase(lineStart, pos + 7 - lineStart);
            pos = lineStart;
        }
        pos = 0;
        while ((pos = bodyBuffer.find(" + 0;", pos)) != std::string::npos) {
            bodyBuffer.erase(pos, 4); // remove " + 0"
        }
        pos = 0;
        while ((pos = bodyBuffer.find(" | 0;", pos)) != std::string::npos) {
            bodyBuffer.erase(pos, 4); // remove " | 0"
        }
    }

    // Append the post-processed body.
    os << bodyBuffer;

    os << "}\n\n";
}

// Forward declaration — defined after emitRegionBody.
static std::optional<std::string> extractConditionCode(Value condValue,
                                                        PseudoCEmitter* emitter);

void PseudoCEmitter::emitStatement(Operation* op, llvm::raw_ostream& os,
                                    unsigned depth) {
    // Skip prologue/epilogue artifacts (push/pop, rbp=rsp, etc.)
    if (isPrologueArtifact(op))
        return;

    // Skip dead stores identified by pre-scan
    if (deadStoreOps.count(op))
        return;

    // ─── Skip infrastructure artifacts ─────────────────────────────────────
    //
    // Primary filter: the "helix.infrastructure" attribute set by
    // PropagateTypes and propagated through RecoverVariables.  This covers
    // PC/NEXT_PC tracking, transitive infra chains, and flag-only
    // computations without relying on string pattern heuristics.
    if (op->hasAttr("helix.infrastructure"))
        return;

    // ─── Fallback heuristic filters (for infra that escaped attribute
    // propagation — e.g., flag values that leaked into real registers,
    // RSP bookkeeping assignments).  These will be removed as the
    // attribute-based detection improves.
    if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
        auto targetStr = formatExpression(assign.getTarget());
        auto valueStr = formatExpression(assign.getValue());

        // 1. PC tracking: _promoted_N = 0x14XXXXXXX (instruction addresses)
        //    These are NEXT_PC/PC values that survived the pipeline.
        if (targetStr.find("_promoted_") != std::string::npos ||
            targetStr.find("_spill_") != std::string::npos) {
            // Check if RHS is a bare hex constant (PC address) or PC arithmetic
            if (valueStr.starts_with("0x") && valueStr.size() >= 8 &&
                valueStr.find_first_of("+-*/&|^") == std::string::npos)
                return; // Skip: _promoted_N = 0x14142fe90
            // Check if RHS is simple flag computation (comparison result)
            if (valueStr.find("__overflow") != std::string::npos)
                return; // Skip: _promoted_N = __overflow(...)
            // Check if RHS is PC-relative arithmetic (addr + N + N + ...)
            if (valueStr.find("_promoted_") != std::string::npos &&
                valueStr.find(" + ") != std::string::npos) {
                // Count additions — if many small constants, it's PC increment chain
                size_t plusCount = 0;
                for (size_t p = 0; (p = valueStr.find(" + ", p)) != std::string::npos; p += 3)
                    plusCount++;
                if (plusCount >= 3)
                    return; // Skip: _promoted_N = _promoted_M + 4 + 5 + 3 + ...
            }
        }

        // 2. RSP bookkeeping: rsp = 0x..., rsp = rdi, rsp = 0
        if (targetStr == "rsp" || targetStr == "RSP") {
            // Skip RSP = constant (PC address or zero)
            if (valueStr.starts_with("0x") || valueStr == "0" || valueStr == "rdi" ||
                valueStr.find("_promoted_") != std::string::npos)
                return;
        }

        // 3. Flag comparisons stored to promoted vars
        if (targetStr.find("_promoted_") != std::string::npos) {
            // x < 0, x == 0, x < y patterns used for flag computation
            if (valueStr.find(" < ") != std::string::npos ||
                valueStr.find(" == ") != std::string::npos ||
                valueStr.find(" != ") != std::string::npos) {
                // Check if the result is only used for control flow (not emitted elsewhere)
                // Conservative: suppress if target is _promoted_ and value is a comparison
                if (valueStr.find("__overflow") == std::string::npos &&
                    !valueStr.starts_with("*") && !valueStr.starts_with("("))
                    return;
            }
        }

        // 4. Bare PC addresses in any variable (0x14XXXXXXX pattern)
        if (valueStr.starts_with("0x14") && valueStr.size() >= 10 &&
            valueStr.find_first_of("+-*/&|^") == std::string::npos &&
            targetStr.find("->") == std::string::npos &&
            targetStr.find("*") == std::string::npos &&
            targetStr.find("[") == std::string::npos)
            return;

        // 5. __overflow() calls assigned to ANY variable (flag infrastructure)
        if (valueStr.find("__overflow") != std::string::npos)
            return;

        // 6. Flag computations in registers: rsi = (x == 0), rdi = ((x - 0) < 0)
        //    These are flag values that leaked into register variables.
        {
            static const char* flagRegNames[] = {
                "rsi", "rdi", "rbp", "rsp", "r13", "result"
            };
            bool isReg = false;
            for (auto* rn : flagRegNames) {
                if (targetStr == rn) { isReg = true; break; }
            }
            if (isReg) {
                // Suppress comparisons/overflow stored to registers
                if (valueStr.find(" == ") != std::string::npos ||
                    valueStr.find(" < ") != std::string::npos ||
                    valueStr.find(" > ") != std::string::npos ||
                    valueStr.find("__overflow") != std::string::npos)
                    return;
                // Suppress ((x - 0) < 0) pattern
                if (valueStr.find("- 0)") != std::string::npos &&
                    valueStr.find("< 0") != std::string::npos)
                    return;
            }
        }

        // 7. RSP assigned from any variable (stack pointer shuffle)
        if (targetStr == "rsp" || targetStr == "RSP")
            return;

        // 8. _promoted_ assigned from anything involving _promoted_ or arithmetic chains
        if (targetStr.find("_promoted_") != std::string::npos) {
            // _promoted_N = _promoted_M (or + constants)
            if (valueStr.find("_promoted_") != std::string::npos)
                return;
            // _promoted_N = rsp + N + N + ... (PC increment via stack)
            if (valueStr.find("rsp") != std::string::npos &&
                valueStr.find(" + ") != std::string::npos)
                return;
            // _promoted_N = *x < y  or  *x == y (flag from memory comparison)
            if ((valueStr.find(" < ") != std::string::npos ||
                 valueStr.find(" == ") != std::string::npos) &&
                valueStr.find("*") != std::string::npos)
                return;
            // _promoted_N = ((x - y) < 0) — signed overflow check
            if (valueStr.find("- 0)") != std::string::npos ||
                valueStr.find("((") != std::string::npos)
                return;
            // _promoted_N = 0 (dead init)
            if (valueStr == "0")
                return;
        }

        // 9. result = comparison or result = rdi (flag/zero leaked)
        if (targetStr == "result") {
            if (valueStr.find(" < ") != std::string::npos ||
                valueStr.find(" == ") != std::string::npos ||
                valueStr.find(" != ") != std::string::npos ||
                valueStr.find(" > ") != std::string::npos ||
                valueStr == "rdi" || valueStr == "rsp" ||
                valueStr == "0")
                return;
        }

        // 10. rdi = _promoted_N + ... (PC chain in register)
        if (valueStr.find("_promoted_") != std::string::npos &&
            valueStr.find(" + ") != std::string::npos &&
            targetStr.find("->") == std::string::npos &&
            targetStr.find("*") == std::string::npos)
            return;

        // 11. param_4 = rsp (stack pointer shuffled into parameter)
        if (valueStr == "rsp" || valueStr == "RSP")
            return;
    }

    // Skip var.decl ops (already emitted at top of function)
    if (isa<helix::high::VarDeclOp>(op))
        return;

    // Skip var.ref ops (value-producing expression, not a statement)
    if (isa<helix::high::VarRefOp>(op))
        return;

    // Skip literal ops (value-producing expressions, not statements)
    if (isa<helix::high::IntLitOp>(op) ||
        isa<helix::high::FloatLitOp>(op) ||
        isa<helix::high::StringLitOp>(op) ||
        isa<helix::high::AddrLitOp>(op) ||
        isa<helix::high::UnknownValueOp>(op))
        return;

    // Skip pure value-producing HelixHigh expression ops — they are
    // consumed via formatExpression() when their result is used.
    if (isa<helix::high::BinaryOp>(op) ||
        isa<helix::high::UnaryOp>(op) ||
        isa<helix::high::CastOp>(op) ||
        isa<helix::high::TernaryOp>(op) ||
        isa<helix::high::SubscriptOp>(op) ||
        isa<helix::high::FieldAccessOp>(op))
        return;

    // ─── Assignment ─────────────────────────────────────────────────────
    if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
        auto exprStr = formatExpression(assign.getValue());
        std::string targetStr = formatExpression(assign.getTarget());

        // ─── Skip dead assignments from Memory* chain breaking ────────────
        if (exprStr == "(void*)(0)" ||
            exprStr == "(int64_t)((void*)(0))")
            return;

        // Suppress synthetic null pointer aliases that only exist to thread
        // Remill bookkeeping pointers through the IR.
        if (exprStr == "NULL" && isSyntheticTemporaryName(targetStr) &&
            isa<LLVM::LLVMPointerType>(assign.getValue().getType())) {
            return;
        }

        // ─── Skip PC-increment bookkeeping ────────────────────────────────
        // Remill emits `NEXT_PC = PC + instr_size` for every instruction.
        // After variable recovery, these appear as assignments like
        // `saved_rbp = (saved_rbp + 3)`. Filter by string pattern.
        bool suppressEmission = false;
        if (exprStr.size() > 4 && exprStr.front() == '(' && exprStr.back() == ')') {
            auto plusPos = exprStr.rfind("+ ");
            if (plusPos != std::string::npos) {
                auto numStr = exprStr.substr(plusPos + 2);
                if (!numStr.empty() && numStr.back() == ')')
                    numStr.pop_back();
                try {
                    int val = std::stoi(numStr);
                    if (val >= 1 && val <= 15)
                        suppressEmission = true;
                } catch (...) {}
            }
        }

        // ─── Forward Copy Propagation Peephole ─────────────────────────────
        if (lastRegValue.count(targetStr) && lastRegValue[targetStr] == exprStr) {
            return; // Skip identical redundant assignment
        }

        // ─── Forward Dead Store Elimination ─────────────────────────────────
        // Scan forward for the next AssignOp to the same target.  If found
        // without an intervening read of the target (call, branch, etc.),
        // this assignment is dead.  Skip over pure value-producing ops
        // (VarRefOp, IntLitOp, MemReadOp, etc.) that only define SSA values.
        {
            bool rhsHasSideEffects =
                exprStr.find("sub_") != std::string::npos ||
                exprStr.find("call") != std::string::npos ||
                exprStr.find("__helix_unknown") != std::string::npos ||
                exprStr.find("vfunc_") != std::string::npos ||
                exprStr.find("__vtable_") != std::string::npos;

            if (!rhsHasSideEffects) {
                auto* scanOp = op->getNextNode();
                bool foundOverwrite = false;
                bool targetRead = false;
                // Scan up to 40 ops forward (NPCOnHitReact has 22 assigns interleaved)
                for (int i = 0; scanOp && i < 40 && !targetRead; scanOp = scanOp->getNextNode(), i++) {
                    // Skip infrastructure
                    if (scanOp->hasAttr("helix.infrastructure"))
                        continue;
                    // Skip pure value-producing ops (no side effects, no statements)
                    if (isa<helix::high::VarRefOp>(scanOp) ||
                        isa<helix::high::IntLitOp>(scanOp) ||
                        isa<helix::high::VarDeclOp>(scanOp) ||
                        isa<helix::low::MemReadOp>(scanOp) ||
                        isa<helix::high::BinaryOp>(scanOp) ||
                        isa<helix::high::UnaryOp>(scanOp) ||
                        isa<helix::high::CastOp>(scanOp) ||
                        isa<arith::ConstantOp>(scanOp) ||
                        isa<LLVM::ConstantOp>(scanOp))
                        continue;
                    // Found another AssignOp — check target
                    if (auto nextAssign = dyn_cast<helix::high::AssignOp>(scanOp)) {
                        auto nextTarget = formatExpression(nextAssign.getTarget());
                        if (nextTarget == targetStr) {
                            foundOverwrite = true;
                            break;
                        }
                        // Different target — check if its RHS reads our target
                        auto nextValue = formatExpression(nextAssign.getValue());
                        if (nextValue.find(targetStr) != std::string::npos) {
                            targetRead = true;  // Our target is read — can't eliminate
                        }
                        continue;  // Keep scanning past assigns to other targets
                    }
                    // Any other op (call, branch, store, etc.) → stop scanning
                    break;
                }
                if (foundOverwrite && !targetRead)
                    return;  // Dead store — later op overwrites same target
            }
        }

        // ─── Transitive Resolution ──────────────────────────────────────────
        // If exprStr is a synthetic temporary that maps to something else,
        // resolve the chain transitively: a = b; b = c; → store a = c.
        if (isSyntheticTemporaryName(exprStr) || isSyntheticValueName(exprStr)) {
            auto resolved = resolveTransitive(exprStr);
            if (resolved != exprStr && resolved.find(exprStr) == std::string::npos) {
                exprStr = resolved;
            }
        }

        // ─── Value Equivalence: prefer shorter/more meaningful names ────────
        // If exprStr is a bare identifier that has a better alias, use it.
        {
            auto equivIt = exprToBestName_.find(exprStr);
            if (equivIt != exprToBestName_.end() &&
                equivIt->second != targetStr &&
                equivIt->second != exprStr) {
                exprStr = equivIt->second;
            }
        }

        // Invalidate any cached expressions that depend on the newly written target.
        // Also invalidate the target itself before assigning the new value.
        for (auto it = lastRegValue.begin(); it != lastRegValue.end(); ) {
            if (it->first == targetStr || it->second.find(targetStr) != std::string::npos) {
                it = lastRegValue.erase(it);
            } else {
                ++it;
            }
        }
        // Also invalidate any exprToBestName_ entries that reference the target.
        for (auto it = exprToBestName_.begin(); it != exprToBestName_.end(); ) {
            if (it->first == targetStr || it->second == targetStr ||
                it->first.find(targetStr) != std::string::npos) {
                it = exprToBestName_.erase(it);
            } else {
                ++it;
            }
        }

        lastRegValue[targetStr] = exprStr;

        // ─── Value Equivalence Tracking ─────────────────────────────────────
        // Track which expression maps to the "best" (shortest, most meaningful) name.
        // Prefer non-synthetic names (param_1, result) over synthetic ones (var_0).
        // Among equally synthetic names, prefer the shorter one.
        {
            auto existingIt = exprToBestName_.find(exprStr);
            bool shouldUpdate = (existingIt == exprToBestName_.end());
            if (!shouldUpdate) {
                const auto& existingName = existingIt->second;
                bool targetIsSynthetic = isSyntheticTemporaryName(targetStr) ||
                                         isSyntheticValueName(targetStr);
                bool existingIsSynthetic = isSyntheticTemporaryName(existingName) ||
                                           isSyntheticValueName(existingName);
                // Prefer non-synthetic over synthetic
                if (existingIsSynthetic && !targetIsSynthetic)
                    shouldUpdate = true;
                // Among same category, prefer shorter name
                else if (existingIsSynthetic == targetIsSynthetic &&
                         targetStr.size() < existingName.size())
                    shouldUpdate = true;
            }
            if (shouldUpdate)
                exprToBestName_[exprStr] = targetStr;
        }

        // ─── Single-Use Temporary Elimination ───────────────────────────────
        // If the target is a synthetic temporary used only once in the function,
        // don't emit the assignment — it will be inlined at the use site via
        // copy propagation. Skip if:
        //   - The expression is too long (>80 chars) — keeps output readable
        //   - The expression contains a function call (side effect) — must emit
        {
            // Detect function-call patterns: identifier immediately followed by '('
            // e.g. "sub_140001000(param_1)" or "strlen(buf)"
            // Skip casts like "(int64_t)(x)" where '(' follows ')' or a type keyword.
            bool looksLikeCall = false;
            for (size_t i = 1; i < exprStr.size(); ++i) {
                if (exprStr[i] == '(') {
                    char prev = exprStr[i - 1];
                    if (std::isalnum(static_cast<unsigned char>(prev)) ||
                        prev == '_') {
                        looksLikeCall = true;
                        break;
                    }
                }
            }

            if (isSyntheticTemporaryName(targetStr) &&
                varUseCount_.count(targetStr) && varUseCount_[targetStr] <= 1 &&
                exprStr.size() <= 80 && !suppressEmission && !looksLikeCall) {
                // The value is already stored in lastRegValue — it will be
                // substituted when the single use site is formatted.
                return;
            }
        }

        if (suppressEmission)
            return;

        // ─── Compound Assignment Synthesis: x = x OP y → x OP= y ─────────
        // Also handles x = x + 1 → x++ and x = x - 1 → x--.
        // For commutative ops, also matches x = y OP x → x OP= y.
        if (auto highBin = assign.getValue().getDefiningOp<helix::high::BinaryOp>()) {
            auto kind = highBin.getOp();
            const char* compoundOp = getHighCompoundOp(kind);
            if (compoundOp) {
                auto lhsStr = formatExpression(highBin.getLhs());
                auto rhsStr = formatExpression(highBin.getRhs());
                bool lhsMatch = (lhsStr == targetStr);
                bool rhsMatch = !lhsMatch && isCommutativeHighOp(kind) && (rhsStr == targetStr);

                if (lhsMatch || rhsMatch) {
                    // The "other" operand is the one that isn't the target
                    const std::string& otherStr = lhsMatch ? rhsStr : lhsStr;
                    Value otherVal = lhsMatch ? highBin.getRhs() : highBin.getLhs();

                    // Special-case: x = x +/- 1 → x++ / x--
                    if (lhsMatch &&
                        (kind == helix::high::BinaryOpKind::Add ||
                         kind == helix::high::BinaryOpKind::Sub)) {
                        auto rhsLit = tryExtractIntegerLiteralFromValue(otherVal);
                        if (rhsLit && *rhsLit == 1) {
                            indent(os, depth);
                            os << targetStr
                               << (kind == helix::high::BinaryOpKind::Add ? "++" : "--");
                            if (auto addr = assign.getAddress())
                                os << std::format(";  // 0x{:x}", *addr);
                            else
                                os << ";";
                            os << "\n";
                            return;
                        }
                    }

                    // General compound: x OP= other
                    indent(os, depth);
                    os << targetStr << " " << compoundOp << " " << otherStr;
                    if (auto addr = assign.getAddress())
                        os << std::format(";  // 0x{:x}", *addr);
                    else
                        os << ";";
                    os << "\n";
                    return;
                }
            }
        }

        indent(os, depth);
        os << targetStr
           << " = "
           << exprStr;
        // Address comment
        if (auto addr = assign.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
        return;
    }

    // ─── Expression statement (void call, etc.) ─────────────────────────
    if (auto exprStmt = dyn_cast<helix::high::ExprStmtOp>(op)) {
        indent(os, depth);
        os << formatExpression(exprStmt.getExpr()) << ";\n";
        return;
    }

    // ─── HelixHigh call as statement (side-effecting) ────────────────────
    if (auto call = dyn_cast<helix::high::CallOp>(op)) {
        indent(os, depth);
        auto calleeName = call.getTargetName().str();
        auto args = call.getArgs();

        // Decompose known native opcodes (DIV, MUL, SSE, etc.) into
        // C expressions — same as the HelixLow CallOp handler.
        {
            llvm::SmallVector<std::string, 4> inferredArgs;
            for (auto operand : args)
                inferredArgs.push_back(formatExpression(operand));
            if (auto decomposed = decomposeNativeOpcode(calleeName, inferredArgs)) {
                os << *decomposed << ";\n";
                return;
            }
        }

        // Detect vtable pattern: __vtable_0xNN → base->vfunc_0xNN(rest...)
        if (calleeName.starts_with("__vtable_0x") && !args.empty()) {
            // "__vtable_0x18" → offset "0x18"
            auto offsetStr = calleeName.substr(9); // "__vtable_" is 9 chars → "0x18"
            auto baseExpr = formatExpression(args[0]);
            os << baseExpr << "->vfunc_" << offsetStr << "(";
            for (size_t i = 1; i < args.size(); i++) {
                if (i > 1) os << ", ";
                os << formatExpression(args[i]);
            }
            os << ")";
        } else {
            os << calleeName << "(";
            for (size_t i = 0; i < args.size(); i++) {
                if (i > 0) os << ", ";
                os << formatExpression(args[i]);
            }
            os << ")";
        }
        if (auto addr = call.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
        return;
    }

    // ─── HelixMid Store (from Low→Mid conversion) ─────────────────────
    if (auto midStore = dyn_cast<helix::mid::StoreOp>(op)) {
        auto addrStr = formatExpression(midStore.getAddr());
        auto valStr = formatExpression(midStore.getValue());

        // Detect compound assignment: store(addr, load(addr) OP rhs) → (*addr) OP= rhs
        // Also handles increment/decrement: store(addr, load(addr) + 1) → (*addr)++
        // For commutative ops, also matches store(addr, rhs OP load(addr)).
        if (auto midBin = midStore.getValue().getDefiningOp<helix::mid::BinExprOp>()) {
            auto kind = midBin.getKind();
            const char* compoundOp = getMidCompoundOp(kind);
            if (compoundOp) {
                // Check LHS: load(addr) OP rhs
                bool lhsMatch = false;
                if (auto midLoad = midBin.getLhs().getDefiningOp<helix::mid::LoadOp>()) {
                    lhsMatch = (formatExpression(midLoad.getAddr()) == addrStr);
                }
                // Check RHS for commutative ops: rhs OP load(addr)
                bool rhsMatch = false;
                if (!lhsMatch && isCommutativeMidOp(kind)) {
                    if (auto midLoad = midBin.getRhs().getDefiningOp<helix::mid::LoadOp>()) {
                        rhsMatch = (formatExpression(midLoad.getAddr()) == addrStr);
                    }
                }

                if (lhsMatch || rhsMatch) {
                    Value otherVal = lhsMatch ? midBin.getRhs() : midBin.getLhs();

                    std::string locExpr;
                    if (addrStr.starts_with("&") && addrStr.find("->") != std::string::npos)
                        locExpr = addrStr.substr(1);
                    else
                        locExpr = std::format("(*({}))", addrStr);

                    // Special-case: ++/-- for literal 1
                    if (lhsMatch &&
                        (kind == helix::mid::BinExprKind::Add ||
                         kind == helix::mid::BinExprKind::Sub)) {
                        auto rhsLit = tryExtractIntegerLiteralFromValue(otherVal);
                        if (rhsLit && *rhsLit == 1) {
                            indent(os, depth);
                            os << locExpr
                               << (kind == helix::mid::BinExprKind::Add ? "++" : "--");
                            if (auto addr = midStore.getAddressAttr())
                                os << std::format(";  // 0x{:x}", addr.getUInt());
                            else
                                os << ";";
                            os << "\n";
                            return;
                        }
                    }

                    // General compound: locExpr OP= other
                    auto otherStr = formatExpression(otherVal);
                    indent(os, depth);
                    os << locExpr << " " << compoundOp << " " << otherStr;
                    if (auto addr = midStore.getAddressAttr())
                        os << std::format(";  // 0x{:x}", addr.getUInt());
                    else
                        os << ";";
                    os << "\n";
                    return;
                }
            }
        }

        std::string locExpr;
        if (addrStr.starts_with("&") && addrStr.find("->") != std::string::npos)
            locExpr = addrStr.substr(1);
        else
            locExpr = std::format("(*({}))", addrStr);
        indent(os, depth);
        os << locExpr << " = " << valStr;
        if (auto addr = midStore.getAddressAttr())
            os << std::format(";  // 0x{:x}", addr.getUInt());
        else
            os << ";";
        os << "\n";
        return;
    }

    // ─── HelixMid Assign ─────────────────────────────────────────────────
    if (auto midAssign = dyn_cast<helix::mid::AssignOp>(op)) {
        auto valStr = formatExpression(midAssign.getValue());
        auto slotName = std::format("slot_{}", midAssign.getSlotId());
        uint32_t targetSlot = midAssign.getSlotId();

        // Compound assignment synthesis: slot_N = slot_N OP rhs → slot_N OP= rhs
        if (auto midBin = midAssign.getValue().getDefiningOp<helix::mid::BinExprOp>()) {
            auto kind = midBin.getKind();
            const char* compoundOp = getMidCompoundOp(kind);
            if (compoundOp) {
                // Check LHS: VarRefOp with same slot
                bool lhsMatch = false;
                if (auto lhsRef = midBin.getLhs().getDefiningOp<helix::mid::VarRefOp>())
                    lhsMatch = (lhsRef.getSlotId() == targetSlot);
                // Check RHS for commutative ops
                bool rhsMatch = false;
                if (!lhsMatch && isCommutativeMidOp(kind)) {
                    if (auto rhsRef = midBin.getRhs().getDefiningOp<helix::mid::VarRefOp>())
                        rhsMatch = (rhsRef.getSlotId() == targetSlot);
                }

                if (lhsMatch || rhsMatch) {
                    Value otherVal = lhsMatch ? midBin.getRhs() : midBin.getLhs();

                    // Special-case: slot_N++ / slot_N--
                    if (lhsMatch &&
                        (kind == helix::mid::BinExprKind::Add ||
                         kind == helix::mid::BinExprKind::Sub)) {
                        auto lit = tryExtractIntegerLiteralFromValue(otherVal);
                        if (lit && *lit == 1) {
                            indent(os, depth);
                            os << slotName
                               << (kind == helix::mid::BinExprKind::Add ? "++" : "--");
                            if (auto addr = midAssign.getAddressAttr())
                                os << std::format(";  // 0x{:x}", addr.getUInt());
                            else
                                os << ";";
                            os << "\n";
                            return;
                        }
                    }

                    // General compound: slot_N OP= other
                    auto otherStr = formatExpression(otherVal);
                    indent(os, depth);
                    os << slotName << " " << compoundOp << " " << otherStr;
                    if (auto addr = midAssign.getAddressAttr())
                        os << std::format(";  // 0x{:x}", addr.getUInt());
                    else
                        os << ";";
                    os << "\n";
                    return;
                }
            }
        }

        indent(os, depth);
        os << slotName << " = " << valStr;
        if (auto addr = midAssign.getAddressAttr())
            os << std::format(";  // 0x{:x}", addr.getUInt());
        else
            os << ";";
        os << "\n";
        return;
    }

    // ─── HelixMid Call (as statement, no result) ─────────────────────────
    if (auto midCall = dyn_cast<helix::mid::CallOp>(op)) {
        indent(os, depth);
        if (auto name = midCall.getCalleeName())
            os << name->str();
        else
            os << std::format("sub_{:x}", midCall.getCalleeAddr());
        os << "(";
        auto args = midCall.getArgs();
        for (size_t i = 0; i < args.size(); i++) {
            if (i > 0) os << ", ";
            os << formatExpression(args[i]);
        }
        os << ")";
        if (auto addr = midCall.getAddressAttr())
            os << std::format(";  // 0x{:x}", addr.getUInt());
        else
            os << ";";
        os << "\n";
        return;
    }

    // ─── HelixMid VarDecl (skip, already handled at top) ─────────────────
    if (isa<helix::mid::VarDeclOp>(op))
        return;

    // ─── If/else ────────────────────────────────────────────────────────
    if (auto ifOp = dyn_cast<helix::high::IfOp>(op)) {
        lastRegValue.clear(); // Control flow branch invalidates sequence
        exprToBestName_.clear();
        std::function<void(helix::high::IfOp, bool)> emitIfBody;
        emitIfBody =
            [&](helix::high::IfOp nestedIf, bool withIndent) {
                if (withIndent)
                    indent(os, depth);
                auto condCode =
                    extractConditionCode(nestedIf.getCondition(), this);
                std::string condStr =
                    condCode ? *condCode : formatExpression(nestedIf.getCondition());
                // Strip outer parens to avoid if ((x == 0)) → if (x == 0)
                if (condStr.size() >= 2 && condStr.front() == '(' && condStr.back() == ')') {
                    int depth_count = 0;
                    bool balanced = true;
                    for (size_t i = 0; i < condStr.size() - 1; ++i) {
                        if (condStr[i] == '(') depth_count++;
                        else if (condStr[i] == ')') depth_count--;
                        if (depth_count == 0) { balanced = false; break; }
                    }
                    if (balanced) condStr = condStr.substr(1, condStr.size() - 2);
                }
                os << "if (" << condStr << ") {\n";
                emitRegionBody(nestedIf.getThenRegion(), os, depth + 1);
                indent(os, depth);
                os << "}";

                auto singleNestedElseIf =
                    [&](Region& region) -> helix::high::IfOp {
                        if (region.empty())
                            return {};
                        helix::high::IfOp nested;
                        for (auto& elseBlock : region) {
                            for (auto& nestedOp : elseBlock) {
                                if (isa<helix::high::LabelOp, helix::high::YieldOp>(
                                        &nestedOp)) {
                                    continue;
                                }
                                if (nested)
                                    return {};
                                nested = dyn_cast<helix::high::IfOp>(&nestedOp);
                                if (!nested)
                                    return {};
                            }
                        }
                        return nested;
                    };

                if (!nestedIf.getElseRegion().empty()) {
                    if (auto nestedElseIf =
                            singleNestedElseIf(nestedIf.getElseRegion())) {
                        os << " else ";
                        emitIfBody(nestedElseIf, /*withIndent=*/false);
                    } else {
                        os << " else {\n";
                        emitRegionBody(nestedIf.getElseRegion(), os, depth + 1);
                        indent(os, depth);
                        os << "}";
                    }
                }
            };

        emitIfBody(ifOp, /*withIndent=*/true);
        os << "\n";
        return;
    }

    // ─── While loop ─────────────────────────────────────────────────────
    if (auto whileOp = dyn_cast<helix::high::WhileOp>(op)) {
        indent(os, depth);
        {
            auto condCode = extractConditionCode(whileOp.getCondition(), this);
            std::string condStr = condCode ? *condCode : formatExpression(whileOp.getCondition());
            os << "while (" << condStr << ") {\n";
        }
        emitRegionBody(whileOp.getBodyRegion(), os, depth + 1);
        indent(os, depth);
        os << "}\n";
        return;
    }

    // ─── Do-while loop ──────────────────────────────────────────────────
    if (auto doWhile = dyn_cast<helix::high::DoWhileOp>(op)) {
        indent(os, depth);
        os << "do {\n";
        emitRegionBody(doWhile.getBodyRegion(), os, depth + 1);
        indent(os, depth);

        // Extract condition from the condition region's yield operand.
        std::string condStr = "/* condition */";
        if (!doWhile.getCondRegion().empty()) {
            Block& condBlock = doWhile.getCondRegion().front();
            for (auto& condOp : condBlock) {
                if (auto yieldOp = dyn_cast<helix::high::YieldOp>(&condOp)) {
                    if (yieldOp.getValue()) {
                        auto condCode = extractConditionCode(yieldOp.getValue(), this);
                        condStr = condCode ? *condCode : formatExpression(yieldOp.getValue());
                    }
                    break;
                }
            }
        }
        os << "} while (" << condStr << ");\n";
        return;
    }

    // ─── For loop ───────────────────────────────────────────────────────
    if (auto forOp = dyn_cast<helix::high::ForOp>(op)) {
        indent(os, depth);
        os << "for (/* init */; /* cond */; /* step */) {\n";
        emitRegionBody(forOp.getBodyRegion(), os, depth + 1);
        indent(os, depth);
        os << "}\n";
        return;
    }

    // ─── Return ─────────────────────────────────────────────────────────
    if (auto ret = dyn_cast<helix::high::ReturnOp>(op)) {
        lastRegValue.clear();
        exprToBestName_.clear();
        indent(os, depth);
        if (ret.getValue()) {
            os << "return " << formatExpression(ret.getValue()) << ";\n";
        } else if (currentFunctionHasReturnValue_ && !currentReturnValueName_.empty()) {
            // Non-void function with no explicit return value — use tracked name
            os << "return " << applyNameAliases(currentReturnValueName_) << ";\n";
        } else {
            os << "return;\n";
        }
        return;
    }

    // ─── Break / Continue ───────────────────────────────────────────────
    if (isa<helix::high::BreakOp>(op)) {
        indent(os, depth);
        os << "break;\n";
        return;
    }

    if (isa<helix::high::ContinueOp>(op)) {
        indent(os, depth);
        os << "continue;\n";
        return;
    }

    // ─── Goto / Label ───────────────────────────────────────────────────
    if (auto gotoOp = dyn_cast<helix::high::GotoOp>(op)) {
        auto labelName = gotoOp.getLabel().str();
        if (returnOnlyLabels_.contains(labelName)) {
            // Replace goto to a return-only label with inline return.
            indent(os, depth);
            if (currentFunctionHasReturnValue_ &&
                !currentReturnValueName_.empty())
                os << "return " << currentReturnValueName_ << ";\n";
            else if (currentFunctionHasReturnValue_)
                os << "return result;\n";
            else
                os << "return;\n";
            return;
        }
        indent(os, depth);
        os << "goto " << labelName << ";\n";
        return;
    }

    if (auto label = dyn_cast<helix::high::LabelOp>(op)) {
        auto* block = label->getBlock();
        const bool referenced =
            referencedLabelNames_.contains(label.getName().str()) ||
            referencedBlocks_.contains(block);
        if (!referenced)
            return;
        // Labels are unindented by one level
        if (depth > 0)
            indent(os, depth - 1);
        os << label.getName().str() << ":\n";
        return;
    }

    // ─── Comment ────────────────────────────────────────────────────────
    if (auto comment = dyn_cast<helix::high::CommentOp>(op)) {
        indent(os, depth);
        os << "// " << comment.getText().str() << "\n";
        return;
    }

    if (auto debugBreak = dyn_cast<helix::high::DebugBreakOp>(op)) {
        indent(os, depth);
        os << "__debugbreak();";
        if (auto addr = debugBreak.getAddress())
            os << std::format("  // 0x{:x}", *addr);
        os << "\n";
        return;
    }

    // ─── Inline assembly ────────────────────────────────────────────────
    if (auto asmOp = dyn_cast<helix::high::AsmOp>(op)) {
        indent(os, depth);
        os << "__asm { " << asmOp.getText().str() << " };\n";
        return;
    }

    // ─── HelixLow ops that survived (not yet lowered) ───────────────────
    // Emit register read/write as pseudo-C for any HelixLow ops still present
    if (auto regRead = dyn_cast<helix::low::RegReadOp>(op)) {
        // Don't emit standalone reg.read — they're used as expressions
        return;
    }

    if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(op)) {
        // ─── Skip dead writes from Memory* chain breaking ────────────
        // When Remill calls are erased, their Memory* results are replaced
        // with UndefOp. The resulting writes produce expressions like
        // `(void*)(0)`, `(int64_t)((void*)(0))`, or `0`. These are dead
        // writes that should not appear in the output.
        {
            Value val = regWrite.getValue();

            // Check 1: Direct pointer type → Memory* token
            if (isa<LLVM::LLVMPointerType>(val.getType()))
                return;

            // Check 2: UndefOp or load from AllocaOp
            Operation* defOp = val.getDefiningOp();
            if (defOp && isa<LLVM::UndefOp>(defOp))
                return;

            // Check 3: Format the expression and skip if it's a null/undef pattern
            auto exprStr = formatExpression(val);
            if (exprStr == "(void*)(0)" ||
                exprStr == "(int64_t)((void*)(0))")
                return;
        }

        // ─── Skip flag register writes (CF, ZF, SF, OF) ─────────────
        // These are internal flags that clutter the output. They're set
        // by CmpOp/TestOp/BinOp and consumed by JccOp — no need to print.
        {
            auto regName = regWrite.getRegName();
            if (regName == "CF" || regName == "ZF" || regName == "SF" ||
                regName == "OF" || regName == "PF" || regName == "AF")
                return;
        }

        // ─── Skip PC-increment bookkeeping ──────────────────────────
        // Remill emits `NEXT_PC = PC + instr_size` for every instruction.
        // After lowering and variable recovery, these appear as
        // `saved_rbp = (saved_rbp + 3)` in the output.
        // Filter by string-matching the formatted expression: (VAR + N)
        // where N is a small integer (instruction sizes are 1-15 bytes).
        {
            auto exprStr = formatExpression(regWrite.getValue());
            // Quick check: "(<name> + <N>)" pattern
            if (exprStr.size() > 4 && exprStr.front() == '(' && exprStr.back() == ')') {
                auto plusPos = exprStr.rfind("+ ");
                if (plusPos != std::string::npos) {
                    auto numStr = exprStr.substr(plusPos + 2);
                    // Remove trailing ')'
                    if (!numStr.empty() && numStr.back() == ')')
                        numStr.pop_back();
                    // Check if it's a small number (instruction size)
                    try {
                        int val = std::stoi(numStr);
                        if (val >= 1 && val <= 15)
                            return;
                    } catch (...) {}
                }
            }
        }

        indent(os, depth);
        std::string regName = regWrite.getRegName().str();
        // Lowercase the register name for C-style output
        for (auto& c : regName) c = std::tolower(c);
        os << regName << " = " << formatExpression(regWrite.getValue());
        if (auto addr = regWrite.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
        return;
    }

    if (auto memRead = dyn_cast<helix::low::MemReadOp>(op)) {
        // Memory reads used as expression — skip standalone emission
        return;
    }

    if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
        indent(os, depth);

        // Resolve stack variable: rbp ± offset → var_name
        std::string resolvedVarName;
        if (!stackOffsetToVarName_.empty()) {
            if (auto* addrDef = memWrite.getAddr().getDefiningOp()) {
                if (auto binop = dyn_cast<helix::low::BinOp>(addrDef)) {
                    auto lhsStr = formatExpression(binop.getLhs());
                    if (lhsStr == "rbp" || lhsStr == "RBP") {
                        if (auto rhsConst = binop.getRhs().getDefiningOp<arith::ConstantOp>()) {
                            if (auto intAttr = dyn_cast<IntegerAttr>(rhsConst.getValue())) {
                                int64_t off = intAttr.getInt();
                                if (binop.getKind() == helix::low::BinOpKind::Sub) off = -off;
                                auto it = stackOffsetToVarName_.find(off);
                                if (it != stackOffsetToVarName_.end())
                                    resolvedVarName = it->second;
                            }
                        }
                        if (resolvedVarName.empty()) {
                            if (auto rhsConst = binop.getRhs().getDefiningOp<LLVM::ConstantOp>()) {
                                if (auto intAttr = dyn_cast<IntegerAttr>(rhsConst.getValue())) {
                                    int64_t off = intAttr.getInt();
                                    if (binop.getKind() == helix::low::BinOpKind::Sub) off = -off;
                                    auto it = stackOffsetToVarName_.find(off);
                                    if (it != stackOffsetToVarName_.end())
                                        resolvedVarName = it->second;
                                }
                            }
                        }
                    }
                }
            }
        }
        auto addrStr = formatExpression(memWrite.getAddr());
        std::string locationExpr;
        if (!resolvedVarName.empty()) {
            locationExpr = resolvedVarName;
        } else if (addrStr.starts_with("&") && addrStr.find("->") != std::string::npos) {
            locationExpr = addrStr.substr(1);
        } else if (addrStr.starts_with("(&") && addrStr.back() == ')' &&
                   addrStr.find("->") != std::string::npos) {
            locationExpr = addrStr.substr(2, addrStr.size() - 3);
        } else {
            locationExpr = std::format("(*({}))", addrStr);
        }

        if (auto unary = memWrite.getValue().getDefiningOp<helix::low::UnaryOp>()) {
            auto kind = unary.getKind();
            if (kind == helix::low::UnaryOpKind::Inc ||
                kind == helix::low::UnaryOpKind::Dec) {
                auto sameAddr = [&]() {
                    auto operandExpr = formatExpression(unary.getOperand());
                    if (normalizeAddressExpression(operandExpr) ==
                        normalizeAddressExpression(addrStr)) {
                        return true;
                    }

                    if (auto priorRead =
                            unary.getOperand().getDefiningOp<helix::low::MemReadOp>()) {
                        return normalizeAddressExpression(
                                   formatExpression(priorRead.getAddr())) ==
                               normalizeAddressExpression(addrStr);
                    }
                    return false;
                };

                if (sameAddr()) {
                    os << locationExpr
                       << (kind == helix::low::UnaryOpKind::Inc ? "++" : "--");
                    if (auto addr = memWrite.getAddress())
                        os << std::format(";  // 0x{:x}", *addr);
                    else
                        os << ";";
                    os << "\n";
                    return;
                }
            }
        }

        os << locationExpr << " = " << formatExpression(memWrite.getValue());
        
        if (addrStr == "NULL" || addrStr == "(void*)(0)" || addrStr == "0") {
            os << ";  // [WARNING] Null pointer dereference!";
        } else if (auto addr = memWrite.getAddress()) {
            os << std::format(";  // 0x{:x}", *addr);
        } else {
            os << ";";
        }
        os << "\n";
        return;
    }

    if (auto call = dyn_cast<helix::low::CallOp>(op)) {
        // ─── Call Argument Inference (Windows x64 ABI) ──────────────────
        // Operands are populated directly from register dependencies in RemillToHelixLow.
        llvm::SmallVector<std::string, 4> inferredArgs;
        for (auto operand : call.getArgs()) {
            inferredArgs.push_back(formatExpression(operand));
        }

        lastRegValue.clear(); // Call clobbers registers and globals
        exprToBestName_.clear();

        indent(os, depth);
        bool isIndirect = false;
        bool isRecursive = false;
        auto matchesCurrentFunction =
            [&](std::string_view targetName,
                std::optional<uint64_t> targetAddr = std::nullopt) {
                if (targetAddr && *targetAddr == currentFunctionEntryAddr_)
                    return true;
                if (auto parsed = parseSubroutineAddressName(targetName))
                    return *parsed == currentFunctionEntryAddr_;
                return targetName == currentFunctionName_;
            };
        if (auto name = call.getTargetName()) {
            // FEAT-HELIX-005: Decompose known x64 opcodes into C expressions
            auto nameStr = name->str();
            if (auto decomposed = decomposeNativeOpcode(nameStr, inferredArgs)) {
                os << *decomposed;
                os << ";\n";
                return;
            }
            os << nameStr;
            isRecursive = matchesCurrentFunction(nameStr);
        } else if (auto recoveredTarget =
                       tryResolveSyntheticRelativeCallTarget(call)) {
            auto addrExpr = std::format("0x{:x}", *recoveredTarget);
            if (auto sig = helix::lookupSignature(addrExpr)) {
                os << sig->name;
                isRecursive = matchesCurrentFunction(sig->name, *recoveredTarget);
            } else {
                auto recoveredName = std::format("sub_{:x}", *recoveredTarget);
                os << recoveredName;
                isRecursive = matchesCurrentFunction(recoveredName, *recoveredTarget);
            }
        } else {
            // Try to resolve the target address via SignatureDb
            auto addrExpr = formatExpression(call.getTargetAddr());
            
            // ─── TLS Symbol Resolution / Static Constant Folding ────────────
            auto hasTlsBase = [](const std::string& s) {
                return s.find("__readgsqword(0x58)") != std::string::npos || 
                       s.find("&__local") != std::string::npos;
            };
            if (hasTlsBase(addrExpr)) {
                size_t plus = addrExpr.find('+');
                size_t minus = addrExpr.find('-');
                size_t symPos = (plus != std::string::npos) ? plus : ((minus != std::string::npos) ? minus : std::string::npos);
                if (symPos != std::string::npos) {
                    std::string offsetStr = addrExpr.substr(symPos + 1);
                    // Remove trailing brackets or parentheses
                    while (!offsetStr.empty() && (offsetStr.back() == ')' || offsetStr.back() == ']' || offsetStr.back() == ' ')) {
                        offsetStr.pop_back();
                    }
                    size_t firstNonSpace = offsetStr.find_first_not_of(" \t");
                    if (firstNonSpace != std::string::npos) offsetStr = offsetStr.substr(firstNonSpace);
                    
                    try {
                        uint64_t offset = 0;
                        if (offsetStr.starts_with("0x") || offsetStr.starts_with("0X")) offset = std::stoull(offsetStr.substr(2), nullptr, 16);
                        else offset = std::stoull(offsetStr, nullptr, 10);
                        
                        uint64_t addr = (plus != std::string::npos) ? (0x140000000ULL + offset) : (0x140000000ULL - offset);
                        addrExpr = std::format("0x{:x}", addr);
                    } catch(...) {}
                }
            }

            // Check if the address expression is a known function name
            auto sig = helix::lookupSignature(addrExpr);
            if (sig) {
                os << sig->name;
                if (auto parsed = parseFormattedIntegerLiteral(addrExpr))
                    isRecursive = matchesCurrentFunction(sig->name,
                                                         static_cast<uint64_t>(*parsed));
                else
                    isRecursive = matchesCurrentFunction(sig->name);
            } else {
                // ─── Vtable / Struct Method Pattern Detection ───────────
                // Pointer arithmetic creates strings like "&rax->field_0x18"
                // or (with field recovery) "&rax->vftable".  Emit clean
                // virtual call syntax:
                //   sub_&rax->field_0x18()  →  rax->vfunc_0x18()
                //   sub_&rax->vftable()     →  rax->vfunc_0x0()
                bool vtableResolved = false;
                if (addrExpr.starts_with("&") && addrExpr.find("->") != std::string::npos) {
                    auto arrowPos = addrExpr.find("->");
                    if (arrowPos != std::string::npos) {
                        std::string obj = addrExpr.substr(1, arrowPos - 1);
                        std::string fieldPart = addrExpr.substr(arrowPos + 2); // after "->"

                        if (fieldPart.starts_with("field_")) {
                            // Generic field name: field_0x18 → vfunc_0x18
                            os << obj << "->vfunc_" << fieldPart.substr(6);
                            vtableResolved = true;
                        } else if (fieldPart == "vftable") {
                            // Recovered vtable name → vfunc_0x0
                            os << obj << "->vfunc_0x0";
                            vtableResolved = true;
                        } else if (fieldPart.starts_with("vftable_")) {
                            // Recovered vtable with offset suffix
                            os << obj << "->vfunc_" << fieldPart.substr(8);
                            vtableResolved = true;
                        } else {
                            // Other recovered names used as call targets
                            os << obj << "->" << fieldPart;
                            vtableResolved = true;
                        }
                    }
                }

                if (!vtableResolved) {
                    // Standard decompiler convention: sub_<hex_address>
                    os << "sub_" << addrExpr;
                    if (auto parsed = parseFormattedIntegerLiteral(addrExpr))
                        isRecursive = matchesCurrentFunction(
                            std::format("sub_{}", addrExpr),
                            static_cast<uint64_t>(*parsed));
                }
                isIndirect = true;
            }
        }

        // Emit call with inferred arguments
        os << "(";
        for (size_t i = 0; i < inferredArgs.size(); i++) {
            if (i > 0) os << ", ";
            os << inferredArgs[i];
        }
        os << ")";

        std::string trailingComment;
        auto appendComment = [&](std::string_view text) {
            if (text.empty())
                return;
            if (!trailingComment.empty())
                trailingComment += " | ";
            trailingComment += text;
        };

        if (auto addr = call.getAddress())
            appendComment(std::format("0x{:x}", *addr));
        if (isRecursive)
            appendComment("RECURSIVE");
        if (isIndirect)
            appendComment("[WARNING] Indirect call");

        os << ";";
        if (!trailingComment.empty()) {
            os << "  // " << trailingComment;
        }
        os << "\n";
        return;
    }

    if (auto ret = dyn_cast<helix::low::RetOp>(op)) {
        indent(os, depth);
        os << "return";
        if (currentFunctionHasReturnValue_ && !currentReturnValueName_.empty())
            os << " " << applyNameAliases(currentReturnValueName_);
        if (auto addr = ret.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
        return;
    }

    if (auto nop = dyn_cast<helix::low::NopOp>(op)) {
        indent(os, depth);
        os << "// nop";
        if (auto addr = nop.getAddress())
            os << std::format("  // 0x{:x}", *addr);
        os << "\n";
        return;
    }

    // ─── HelixLow: Push/Pop ─────────────────────────────────────────────
    if (auto push = dyn_cast<helix::low::PushOp>(op)) {
        indent(os, depth);
        os << "push(" << formatExpression(push.getValue()) << ")";
        if (auto addr = push.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
        return;
    }

    if (isa<helix::low::PopOp>(op)) {
        // Pop is a value-producing op — skip standalone emission
        return;
    }

    // ─── HelixLow: Cmp/Test (set flags, no result value emitted) ────────
    if (isa<helix::low::CmpOp>(op)) {
        return;
    }

    if (isa<helix::low::TestOp>(op)) {
        return;
    }

    // ─── Exact Xchg carried across Low/Mid/High ─────────────────────────
    auto emitXchg = [&](llvm::StringRef regAValue, llvm::StringRef regBValue,
                        uint32_t bitWidth, std::optional<uint64_t> address) {
        indent(os, depth);
        std::string regA = regAValue.str();
        std::string regB = regBValue.str();
        for (auto& c : regA) c = std::tolower(c);
        for (auto& c : regB) c = std::tolower(c);
        os << "__helix_xchg_reg" << bitWidth
           << "(&" << regA << ", &" << regB << ")";
        if (address)
            os << std::format(";  // 0x{:x}", *address);
        else
            os << ";";
        os << "\n";
    };
    if (auto xchg = dyn_cast<helix::high::XchgOp>(op)) {
        emitXchg(xchg.getRegA(), xchg.getRegB(), xchg.getBitWidth(),
                 xchg.getAddress());
        return;
    }
    if (auto xchg = dyn_cast<helix::mid::XchgOp>(op)) {
        emitXchg(xchg.getRegA(), xchg.getRegB(), xchg.getBitWidth(),
                 xchg.getAddress());
        return;
    }
    if (auto xchg = dyn_cast<helix::low::XchgOp>(op)) {
        emitXchg(xchg.getRegA(), xchg.getRegB(), xchg.getBitWidth(),
                 xchg.getAddress());
        return;
    }

    // ─── HelixLow: Int3 ─────────────────────────────────────────────────
    if (auto int3 = dyn_cast<helix::low::Int3Op>(op)) {
        indent(os, depth);
        os << "__debugbreak()";
        if (auto addr = int3.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
        return;
    }

    // ─── HelixLow: REP string operations ────────────────────────────────
    if (auto repMovs = dyn_cast<helix::low::RepMovsOp>(op)) {
        indent(os, depth);
        os << "memcpy(" << formatExpression(repMovs.getDst())
           << ", " << formatExpression(repMovs.getSrc())
           << ", " << formatExpression(repMovs.getCount()) << ")";
        if (auto addr = repMovs.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
        return;
    }

    if (auto repStos = dyn_cast<helix::low::RepStosOp>(op)) {
        indent(os, depth);
        os << "memset(" << formatExpression(repStos.getDst())
           << ", " << formatExpression(repStos.getValue())
           << ", " << formatExpression(repStos.getCount()) << ")";
        if (auto addr = repStos.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
        return;
    }

    // ─── HelixLow: Skip value-producing ops ─────────────────────────────
    if (isa<helix::low::BinOp>(op) || isa<helix::low::UnaryOp>(op) ||
        isa<helix::low::CMovOp>(op) || isa<helix::low::MovZxOp>(op) ||
        isa<helix::low::MovSxOp>(op) || isa<helix::low::LeaOp>(op))
        return;

    // ─── Yield — skip (internal to regions) ─────────────────────────────
    if (isa<helix::high::YieldOp>(op))
        return;

    // ═════════════════════════════════════════════════════════════════════
    // LLVM Dialect ops that survived the pipeline
    // ═════════════════════════════════════════════════════════════════════
    // After RemillToHelixLow conversion, any remaining LLVM dialect ops
    // should have been cleaned up. Skip them as a safety net.
    if (op->getDialect() && op->getDialect()->getNamespace() == "llvm")
        return;

    // Skip arith ops (all value-producing, handled in formatExpression)
    if (op->getDialect() && op->getDialect()->getNamespace() == "arith")
        return;

    // Skip HelixMid ops that survived partial conversion (value-producing)
    if (op->getDialect() && op->getDialect()->getNamespace() == "helix_mid")
        return;

    // ═════════════════════════════════════════════════════════════════════
    // General fallback: emit unrecognized op as a diagnostic comment
    // ═════════════════════════════════════════════════════════════════════
    indent(os, depth);
    os << "/* unhandled: " << op->getName().getStringRef().str();
    for (unsigned i = 0; i < op->getNumOperands() && i < 4; i++) {
        os << (i == 0 ? " " : ", ") << formatExpression(op->getOperand(i));
    }
    if (op->getNumOperands() > 4)
        os << ", ...";
    os << " */;\n";
}

// ─── extractConditionCode ────────────────────────────────────────────────────
// Given a JccOp's flag_value (i1 from CmpOp/TestOp through arith ops),
// produce a human-readable condition string like "param_1 != 0".

static std::string extractName(Value v, PseudoCEmitter* emitter = nullptr) {
    if (!v) return "";
    auto* op = v.getDefiningOp();
    if (!op) {
        // Block argument — try formatExpression
        if (emitter) return emitter->formatExpression(v);
        return "";
    }
    if (auto varRef = dyn_cast<helix::high::VarRefOp>(op))
        return emitter ? emitter->formatExpression(v) : varRef.getVarName().str();
    if (auto regRead = dyn_cast<helix::low::RegReadOp>(op))
        return emitter ? emitter->formatExpression(v) : regRead.getRegName().str();
    // Fallback: use the full expression formatter
    if (emitter) {
        auto expr = emitter->formatExpression(v);
        // Avoid returning placeholder expressions
        if (!expr.empty() && expr.find("/* ") == std::string::npos)
            return expr;
    }
    return "";
}

struct FlagSource {
    Operation* cmpOrTest = nullptr;
    unsigned flagIndex = 0;
    bool isCmp = false;
    bool isTest = false;
    bool isBinOp = false;
};

static FlagSource findFlagSource(Value flagVal) {
    FlagSource src;
    if (!flagVal) return src;
    auto* op = flagVal.getDefiningOp();
    if (!op) return src;
    if (auto cmpOp = dyn_cast<helix::low::CmpOp>(op)) {
        src.cmpOrTest = op; src.isCmp = true;
        for (unsigned i = 0; i < cmpOp->getNumResults(); ++i)
            if (cmpOp->getResult(i) == flagVal) { src.flagIndex = i; break; }
        return src;
    }
    if (auto testOp = dyn_cast<helix::low::TestOp>(op)) {
        src.cmpOrTest = op; src.isTest = true;
        for (unsigned i = 0; i < testOp->getNumResults(); ++i)
            if (testOp->getResult(i) == flagVal) { src.flagIndex = i; break; }
        return src;
    }
    if (auto binOp = dyn_cast<helix::low::BinOp>(op)) {
        src.cmpOrTest = op; src.isBinOp = true;
        for (unsigned i = 0; i < binOp->getNumResults(); ++i)
            if (binOp->getResult(i) == flagVal) { src.flagIndex = i; break; }
        return src;
    }
    return src;
}

static std::optional<std::string> formatCmpStr(helix::low::CmpOp cmpOp,
                                                const char* op,
                                                PseudoCEmitter* emitter = nullptr) {
    std::string lhs, rhs;
    if (cmpOp->getNumOperands() >= 2) {
        lhs = extractName(cmpOp->getOperand(0), emitter);
        rhs = extractName(cmpOp->getOperand(1), emitter);
    }
    if (!lhs.empty() && !rhs.empty())
        return std::format("{} {} {}", lhs, op, rhs);
    if (!lhs.empty()) {
        if (auto constOp = cmpOp->getOperand(1).getDefiningOp<LLVM::ConstantOp>()) {
            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                int64_t val = intAttr.getValue().getSExtValue();
                return std::format("{} {} {}", lhs, op, val);
            }
        }
        return std::format("{} {} 0", lhs, op);
    }
    return std::nullopt;
}

static std::optional<std::string> formatBinOpCmpStr(helix::low::BinOp binOp,
                                                    const char* op,
                                                    PseudoCEmitter* emitter = nullptr) {
    std::string lhs, rhs;
    if (binOp->getNumOperands() >= 2) {
        lhs = extractName(binOp->getOperand(0), emitter);
        rhs = extractName(binOp->getOperand(1), emitter);
    }
    if (!lhs.empty() && !rhs.empty())
        return std::format("{} {} {}", lhs, op, rhs);
    return std::nullopt;
}

static std::optional<std::string> formatSignedCompareFromFlagSource(
    const FlagSource& src, const char* op, PseudoCEmitter* emitter = nullptr) {
    if (src.isCmp)
        return formatCmpStr(cast<helix::low::CmpOp>(src.cmpOrTest), op, emitter);

    if (src.isBinOp) {
        auto binOp = cast<helix::low::BinOp>(src.cmpOrTest);
        if (binOp.getKind() == helix::low::BinOpKind::Sub)
            return formatBinOpCmpStr(binOp, op, emitter);
    }

    return std::nullopt;
}

static bool isLogicalNegationConstant(Value value) {
    if (!value)
        return false;

    if (auto constOp = value.getDefiningOp<arith::ConstantOp>()) {
        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
            auto intValue = intAttr.getValue();
            return intValue.isOne() || intValue.isAllOnes();
        }
    }

    if (auto constOp = value.getDefiningOp<LLVM::ConstantOp>()) {
        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
            auto intValue = intAttr.getValue();
            return intValue.isOne() || intValue.isAllOnes();
        }
    }

    return false;
}

static std::optional<std::string> invertConditionText(std::string_view condition) {
    static constexpr std::pair<std::string_view, std::string_view> kPairs[] = {
        {" == ", " != "},
        {" != ", " == "},
        {" >= ", " < "},
        {" <= ", " > "},
        {" < ", " >= "},
        {" > ", " <= "},
    };

    for (const auto& [from, to] : kPairs) {
        auto pos = condition.find(from);
        if (pos == std::string_view::npos)
            continue;
        std::string result(condition);
        result.replace(pos, from.size(), to);
        return result;
    }

    if (condition == "overflow")
        return std::string("!overflow");
    if (condition == "!overflow")
        return std::string("overflow");
    return std::nullopt;
}

static std::optional<std::string> extractConditionCode(Value condValue,
                                                        PseudoCEmitter* emitter = nullptr) {
    if (!condValue) return std::nullopt;
    auto* defOp = condValue.getDefiningOp();
    if (!defOp) return std::nullopt;

    // Direct CmpOp flag
    if (auto cmpOp = dyn_cast<helix::low::CmpOp>(defOp)) {
        for (unsigned i = 0; i < cmpOp->getNumResults(); ++i) {
            if (cmpOp->getResult(i) == condValue) {
                switch (i) {
                case 1: return formatCmpStr(cmpOp, "==", emitter);
                case 0: return formatCmpStr(cmpOp, "<", emitter);
                case 2: { auto n = extractName(cmpOp->getOperand(0), emitter);
                           return n.empty() ? std::optional<std::string>("sign")
                                            : std::format("{} < 0", n); }
                case 3: return std::string("overflow");
                default: break;
                }
            }
        }
    }

    // Direct TestOp flag
    if (auto testOp = dyn_cast<helix::low::TestOp>(defOp)) {
        std::string name;
        if (testOp->getNumOperands() >= 1)
            name = extractName(testOp->getOperand(0), emitter);
        for (unsigned i = 0; i < testOp->getNumResults(); ++i) {
            if (testOp->getResult(i) == condValue) {
                if (i == 0) return name.empty() ? std::string("zero")
                                                 : std::format("{} == 0", name);
                if (i == 1) return name.empty() ? std::string("sign")
                                                 : std::format("{} < 0", name);
            }
        }
    }

    // arith.xori — negation (JNZ, JNB, JNS, JNL)
    if (auto xorOp = dyn_cast<arith::XOrIOp>(defOp)) {
        Value flagOp = nullptr;
        bool isNeg = false;
        for (unsigned i = 0; i < 2; ++i) {
            if (!isLogicalNegationConstant(xorOp->getOperand(i)))
                continue;
            flagOp = xorOp->getOperand(1 - i);
            isNeg = true;
            break;
        }
        if (isNeg && flagOp) {
            if (auto nested = extractConditionCode(flagOp, emitter)) {
                if (auto inverted = invertConditionText(*nested))
                    return inverted;
                return std::format("!({})", *nested);
            }

            auto src = findFlagSource(flagOp);
            if (src.isCmp) {
                auto cmpOp = cast<helix::low::CmpOp>(src.cmpOrTest);
                switch (src.flagIndex) {
                case 1: return formatCmpStr(cmpOp, "!=", emitter);
                case 0: return formatCmpStr(cmpOp, ">=", emitter);
                case 2: { auto n = extractName(cmpOp->getOperand(0), emitter);
                           return n.empty() ? std::optional<std::string>("!sign")
                                            : std::format("{} >= 0", n); }
                case 3: return std::string("!overflow");
                default: break;
                }
            }
            if (src.isTest) {
                auto testOp = cast<helix::low::TestOp>(src.cmpOrTest);
                std::string name;
                if (testOp->getNumOperands() >= 1)
                    name = extractName(testOp->getOperand(0), emitter);
                if (src.flagIndex == 0)
                    return name.empty() ? std::string("!zero")
                                        : std::format("{} != 0", name);
                if (src.flagIndex == 1)
                    return name.empty() ? std::string("!sign")
                                        : std::format("{} >= 0", name);
            }
            if (src.isBinOp) {
                auto binOp = cast<helix::low::BinOp>(src.cmpOrTest);
                if (binOp.getKind() == helix::low::BinOpKind::Sub) {
                    switch (src.flagIndex) {
                    case 2: {
                        auto cmp = formatBinOpCmpStr(binOp, "==", emitter);
                        if (cmp) return *cmp;
                        break;
                    }
                    case 3: {
                        auto lhs = extractName(binOp->getOperand(0), emitter);
                        auto rhs = extractName(binOp->getOperand(1), emitter);
                        if (!lhs.empty() && !rhs.empty())
                            return std::format("(({} - {}) < 0)", lhs, rhs);
                        break;
                    }
                    case 4:
                        return std::string("!overflow");
                    default:
                        break;
                    }
                }
            }
            // !(SF XOR OF) → JNL/JGE
            if (auto innerXor = dyn_cast_or_null<arith::XOrIOp>(
                    flagOp.getDefiningOp())) {
                auto sf = findFlagSource(innerXor->getOperand(0));
                auto of = findFlagSource(innerXor->getOperand(1));
                if (sf.flagIndex == 2 && of.flagIndex == 3 &&
                    sf.cmpOrTest == of.cmpOrTest) {
                    if (auto cmp = formatSignedCompareFromFlagSource(
                            sf, ">=", emitter)) {
                        return cmp;
                    }
                }
            }
        }
        // SF XOR OF → JL
        if (!isNeg) {
            auto sf = findFlagSource(xorOp->getOperand(0));
            auto of = findFlagSource(xorOp->getOperand(1));
            if (sf.flagIndex == 2 && of.flagIndex == 3 &&
                sf.cmpOrTest == of.cmpOrTest) {
                if (auto cmp = formatSignedCompareFromFlagSource(
                        sf, "<", emitter)) {
                    return cmp;
                }
            }
        }
    }

    // arith.ori — JLE/JBE
    if (auto orOp = dyn_cast<arith::OrIOp>(defOp)) {
        auto lhsSrc = findFlagSource(orOp->getOperand(0));
        if (lhsSrc.isCmp && lhsSrc.flagIndex == 0) {
            auto rhsSrc = findFlagSource(orOp->getOperand(1));
            if (rhsSrc.isCmp && rhsSrc.flagIndex == 1)
                return formatCmpStr(cast<helix::low::CmpOp>(lhsSrc.cmpOrTest), "<=", emitter);
        }
        if (lhsSrc.isCmp && lhsSrc.flagIndex == 1) {
            if (auto x = dyn_cast_or_null<arith::XOrIOp>(
                    orOp->getOperand(1).getDefiningOp())) {
                auto sf = findFlagSource(x->getOperand(0));
                auto of = findFlagSource(x->getOperand(1));
                if (sf.isCmp && sf.flagIndex == 2 && of.isCmp && of.flagIndex == 3)
                    return formatCmpStr(cast<helix::low::CmpOp>(lhsSrc.cmpOrTest), "<=", emitter);
            }
        }
    }

    // arith.andi — JNBE/JNLE
    if (auto andOp = dyn_cast<arith::AndIOp>(defOp)) {
        auto lX = dyn_cast_or_null<arith::XOrIOp>(andOp->getOperand(0).getDefiningOp());
        auto rX = dyn_cast_or_null<arith::XOrIOp>(andOp->getOperand(1).getDefiningOp());
        if (lX && rX) {
            Value lF = nullptr, rF = nullptr;
            for (unsigned i = 0; i < 2; ++i)
                if (lX->getOperand(i).getDefiningOp<arith::ConstantOp>())
                    { lF = lX->getOperand(1-i); break; }
            for (unsigned i = 0; i < 2; ++i)
                if (rX->getOperand(i).getDefiningOp<arith::ConstantOp>())
                    { rF = rX->getOperand(1-i); break; }
            if (lF && rF) {
                auto lS = findFlagSource(lF);
                auto rS = findFlagSource(rF);
                if (lS.isCmp && lS.flagIndex == 0 && rS.isCmp && rS.flagIndex == 1)
                    return formatCmpStr(cast<helix::low::CmpOp>(lS.cmpOrTest), ">", emitter);
                if (lS.isCmp && lS.flagIndex == 1) {
                    if (auto ix = dyn_cast_or_null<arith::XOrIOp>(rF.getDefiningOp())) {
                        auto sf = findFlagSource(ix->getOperand(0));
                        auto of = findFlagSource(ix->getOperand(1));
                        if (sf.isCmp && sf.flagIndex == 2 && of.isCmp && of.flagIndex == 3)
                            return formatCmpStr(cast<helix::low::CmpOp>(lS.cmpOrTest), ">", emitter);
                    }
                }
            }
        }
    }

    // ─── HelixHigh comparison ops (from Low→Mid→High conversion) ────────
    // After the 3-tier pass, conditions may be high::BinaryOp comparisons
    // directly, instead of CmpOp flag results.
    if (auto binary = dyn_cast<helix::high::BinaryOp>(defOp)) {
        auto kind = binary.getOp();
        const char* opStr = nullptr;
        switch (kind) {
        case helix::high::BinaryOpKind::Eq: opStr = "=="; break;
        case helix::high::BinaryOpKind::Ne: opStr = "!="; break;
        case helix::high::BinaryOpKind::Lt: opStr = "<"; break;
        case helix::high::BinaryOpKind::Le: opStr = "<="; break;
        case helix::high::BinaryOpKind::Gt: opStr = ">"; break;
        case helix::high::BinaryOpKind::Ge: opStr = ">="; break;
        case helix::high::BinaryOpKind::Ult: opStr = "<"; break;
        case helix::high::BinaryOpKind::Ule: opStr = "<="; break;
        case helix::high::BinaryOpKind::Ugt: opStr = ">"; break;
        case helix::high::BinaryOpKind::Uge: opStr = ">="; break;
        default: break;
        }
        if (opStr && emitter) {
            auto lhs = emitter->formatExpression(binary.getLhs());
            auto rhs = emitter->formatExpression(binary.getRhs());
            if (kind == helix::high::BinaryOpKind::Ult ||
                kind == helix::high::BinaryOpKind::Ule ||
                kind == helix::high::BinaryOpKind::Ugt ||
                kind == helix::high::BinaryOpKind::Uge) {
                lhs = std::format("(uint64_t)({})", lhs);
                rhs = std::format("(uint64_t)({})", rhs);
            }
            return std::format("{} {} {}", lhs, opStr, rhs);
        }
    }

    // VarRefOp directly
    if (auto varRef = dyn_cast<helix::high::VarRefOp>(defOp))
        return varRef.getVarName().str();

    return std::nullopt;
}

void PseudoCEmitter::emitRegionBody(Region& region, llvm::raw_ostream& os,
                                     unsigned depth) {
    bool multiBlock = (std::distance(region.begin(), region.end()) > 1);

    // Helper: resolve a block to a label name, even if it's outside this region.
    auto resolveBlockLabel = [&](Block* dest) -> std::string {
        if (!dest) return "";
        // Prefer LabelOp name if the block has one (emitted by StructureControlFlow).
        for (auto& op : *dest) {
            if (auto labelOp = dyn_cast<helix::high::LabelOp>(&op))
                return labelOp.getName().str();
        }
        if (blockLabels_.count(dest))
            return blockLabels_[dest];
        return "";
    };

    auto blockHasExplicitLabel = [&](Block* block) {
        if (!block)
            return false;
        for (auto& op : *block) {
            if (isa<helix::high::LabelOp>(&op))
                return true;
        }
        return false;
    };

    auto shouldEmitSyntheticBlockLabel = [&](Block* block) {
        if (!block)
            return false;
        if (blockHasExplicitLabel(block))
            return false;
        return referencedBlocks_.contains(block);
    };

    auto nextBlockInRegion = [&](Block* block) -> Block* {
        if (!block)
            return nullptr;
        auto it = block->getIterator();
        ++it;
        if (it == region.end())
            return nullptr;
        return &*it;
    };

    auto getNonLabelOps = [&](Block* block) {
        llvm::SmallVector<Operation*, 4> ops;
        if (!block)
            return ops;
        for (auto& op : *block) {
            if (isa<helix::high::LabelOp>(&op))
                continue;
            ops.push_back(&op);
        }
        return ops;
    };

    auto resolveJumpOnlyBlock = [&](Block* block) -> Block* {
        llvm::SmallPtrSet<Block*, 8> visited;
        Block* current = block;
        unsigned depthBudget = 6;
        while (current && depthBudget-- > 0 && visited.insert(current).second) {
            auto ops = getNonLabelOps(current);
            if (ops.size() != 1)
                break;
            if (auto jmp = dyn_cast<helix::low::JmpOp>(ops.front())) {
                current = jmp.getDest();
                continue;
            }
            break;
        }
        return current;
    };

    auto getTrivialReturnOp = [&](Block* block) -> Operation* {
        Block* resolved = resolveJumpOnlyBlock(block);
        auto ops = getNonLabelOps(resolved);
        if (ops.size() != 1)
            return nullptr;
        if (isa<helix::low::RetOp>(ops.front()) ||
            isa<helix::high::ReturnOp>(ops.front())) {
            return ops.front();
        }
        return nullptr;
    };

    auto blockStartsWithVisibleLabel = [&](Block* block) {
        if (!block)
            return false;
        for (auto& op : *block) {
            auto label = dyn_cast<helix::high::LabelOp>(&op);
            if (!label)
                return false;
            const bool referenced =
                referencedLabelNames_.contains(label.getName().str()) ||
                referencedBlocks_.contains(label->getBlock());
            if (referenced)
                return true;
        }
        return false;
    };

    // ── Cross-block dead store pre-scan ────────────────────────────────
    //
    // Remill lifts each x86 instruction to a separate basic block, so dead
    // store chains (like 11 consecutive `rax = *addr`) span many blocks.
    // Per-block DSE misses these.  This pre-scan walks all AssignOps across
    // all blocks in reverse order and marks dead stores that are overwritten
    // before being read.
    {
        // Collect all AssignOps in emission order across all blocks.
        llvm::SmallVector<helix::high::AssignOp, 64> allAssigns;
        for (auto& block : region) {
            for (auto& inst : block) {
                if (auto assign = dyn_cast<helix::high::AssignOp>(&inst))
                    allAssigns.push_back(assign);
            }
        }
        // Backward walk across all assigns — same logic as per-block DSE.
        std::unordered_set<std::string> writtenNotRead;
        for (auto it = allAssigns.rbegin(); it != allAssigns.rend(); ++it) {
            auto assignOp = *it;
            auto targetStr = formatExpression(assignOp.getTarget());

            bool isSimpleReg = !targetStr.empty() &&
                               targetStr.find("->") == std::string::npos &&
                               targetStr.find("*(") == std::string::npos &&
                               targetStr.find("[") == std::string::npos;

            if (targetStr.starts_with("xmm") || targetStr.starts_with("ymm") ||
                targetStr.starts_with("zmm"))
                isSimpleReg = false;

            if (!isSimpleReg)
                continue;

            auto exprStr = formatExpression(assignOp.getValue());
            bool hasSideEffects =
                exprStr.find("sub_") != std::string::npos ||
                exprStr.find("call") != std::string::npos ||
                exprStr.find("vfunc_") != std::string::npos ||
                exprStr.find("__vtable_") != std::string::npos;

            if (!hasSideEffects) {
                if (writtenNotRead.count(targetStr)) {
                    deadStoreOps.insert(assignOp.getOperation());
                    continue;  // Dead — skip RHS read processing
                }
                writtenNotRead.insert(targetStr);
            } else {
                writtenNotRead.erase(targetStr);
            }

            // Check RHS for reads of tracked variables
            std::vector<std::string> toRemove;
            for (auto& entry : writtenNotRead) {
                if (entry != targetStr && exprStr.find(entry) != std::string::npos)
                    toRemove.push_back(entry);
            }
            for (auto& r : toRemove)
                writtenNotRead.erase(r);
        }
    }

    bool firstBlock = true;
    bool suppressAcrossBlocksUntilLabel = false;
    for (auto& block : region) {
        if (suppressAcrossBlocksUntilLabel && !blockStartsWithVisibleLabel(&block))
            continue;

        if (blockStartsWithVisibleLabel(&block))
            suppressAcrossBlocksUntilLabel = false;

        lastRegValue.clear();
        exprToBestName_.clear();
        bool suppressUntilVisibleLabel = false;

        // Emit block label for non-entry blocks in multi-block regions.
        if (multiBlock && !firstBlock && shouldEmitSyntheticBlockLabel(&block)) {
            if (depth > 0)
                indent(os, depth - 1);
            os << blockLabels_[&block] << ":\n";
        }
        firstBlock = false;

        // Pre-compute dead stores for this block (merge with cross-block results)
        auto blockDead = precomputeDeadStores(block);
        deadStoreOps.insert(blockDead.begin(), blockDead.end());

        for (auto& op : block.getOperations()) {
            if (suppressUntilVisibleLabel) {
                auto label = dyn_cast<helix::high::LabelOp>(&op);
                if (!label)
                    continue;

                const bool referenced =
                    referencedLabelNames_.contains(label.getName().str()) ||
                    referencedBlocks_.contains(label->getBlock());
                if (!referenced)
                    continue;

                suppressUntilVisibleLabel = false;
            }

            // Handle JmpOp (unconditional jump) — emit as goto.
            if (auto jmp = dyn_cast<helix::low::JmpOp>(&op)) {
                Block* dest = resolveJumpOnlyBlock(jmp.getDest());
                if (dest == nextBlockInRegion(&block))
                    continue;
                if (Operation* retOp = getTrivialReturnOp(dest)) {
                    emitStatement(retOp, os, depth);
                    suppressUntilVisibleLabel = true;
                    suppressAcrossBlocksUntilLabel = true;
                    continue;
                }
                indent(os, depth);
                auto label = resolveBlockLabel(dest);
                if (!label.empty())
                    os << "goto " << label << ";\n";
                else
                    os << "goto /* unresolved */;\n";
                suppressUntilVisibleLabel = true;
                suppressAcrossBlocksUntilLabel = true;
                continue;
            }

            // Handle JccOp (conditional jump) — emit as if/goto.
            if (auto jcc = dyn_cast<helix::low::JccOp>(&op)) {
                Block* trueDest = resolveJumpOnlyBlock(jcc.getTrueDest());
                Block* falseDest = resolveJumpOnlyBlock(jcc.getFalseDest());
                Block* nextBlock = nextBlockInRegion(&block);
                indent(os, depth);

                // Use extractConditionCode for a human-readable condition,
                // falling back to the raw condition string attribute.
                std::string condStr;
                auto condCode = extractConditionCode(jcc.getFlagValue(), this);
                if (condCode)
                    condStr = *condCode;
                else {
                    condStr = formatExpression(jcc.getFlagValue());
                    if (condStr.empty() || condStr == "/* null */" ||
                        condStr == "/* arg */") {
                        condStr = jcc.getCondition().str();
                    }
                }

                if (Operation* trueRet = getTrivialReturnOp(trueDest)) {
                    if (Operation* falseRet = getTrivialReturnOp(falseDest)) {
                        os << "if (" << condStr << ") {\n";
                        emitStatement(trueRet, os, depth + 1);
                        indent(os, depth);
                        os << "} else {\n";
                        emitStatement(falseRet, os, depth + 1);
                        indent(os, depth);
                        os << "}\n";
                        continue;
                    }
                }

                if (trueDest == nextBlock) {
                    if (Operation* retOp = getTrivialReturnOp(falseDest)) {
                        os << "if (!(" << condStr << ")) {\n";
                        emitStatement(retOp, os, depth + 1);
                        indent(os, depth);
                        os << "}\n";
                        continue;
                    }
                }

                if (falseDest == nextBlock) {
                    if (Operation* retOp = getTrivialReturnOp(trueDest)) {
                        os << "if (" << condStr << ") {\n";
                        emitStatement(retOp, os, depth + 1);
                        indent(os, depth);
                        os << "}\n";
                        continue;
                    }
                }

                os << "if (" << condStr << ") ";

                auto trueLabel = resolveBlockLabel(trueDest);
                if (!trueLabel.empty())
                    os << "goto " << trueLabel << ";\n";
                else
                    os << "goto /* unresolved */;\n";
                continue;
            }

            emitStatement(&op, os, depth);
            if (isa<helix::high::GotoOp,
                    helix::low::RetOp,
                    helix::high::ReturnOp>(&op)) {
                suppressUntilVisibleLabel = true;
                suppressAcrossBlocksUntilLabel = true;
            }
        }
    }
}

std::string PseudoCEmitter::formatExpression(Value val) {
    return formatExpressionWithPrec(val, 0);
}

std::string PseudoCEmitter::formatExpressionWithPrec(Value val, int parentPrec) {
    if (!val)
        return "/* null */";

    auto* defOp = val.getDefiningOp();
    if (!defOp)
        return "/* arg */";

    if (auto resolvedAddr = tryResolveSyntheticRelativeAddress(val))
        return std::format("0x{:x}", *resolvedAddr);

    // ═════════════════════════════════════════════════════════════════════
    // HelixHigh Dialect expressions
    // ═════════════════════════════════════════════════════════════════════

    // ─── Integer literal ────────────────────────────────────────────────
    if (auto intLit = dyn_cast<helix::high::IntLitOp>(defOp)) {
        return formatIntLiteral(intLit.getValue());
    }

    // ─── Variable reference ─────────────────────────────────────────────
    if (auto varRef = dyn_cast<helix::high::VarRefOp>(defOp)) {
        auto name = applyNameAliases(varRef.getVarName().str());
        if (isSyntheticTemporaryName(name) || isSyntheticValueName(name)) {
            // Transitive copy propagation: resolve through chains
            auto resolved = resolveTransitive(name);
            if (resolved != name && resolved.find(name) == std::string::npos) {
                return resolved;
            }
            // Fall back to single-level lookup
            auto it = lastRegValue.find(name);
            if (it != lastRegValue.end() && it->second != name &&
                it->second.find(name) == std::string::npos) {
                return it->second;
            }
        } else {
            // For register variables: propagate constant values.
            // E.g., r12 = 0; rax = r12; → rax = 0;
            // Only inline constants (not variable-to-variable copies) to
            // avoid confusing chains.
            //
            // IMPORTANT: Do NOT resolve if this VarRef is the TARGET (LHS)
            // of an assignment.  Resolving `xmm0` to `0` when it's being
            // written to produces nonsense like `0 = rsp + 0x50;`.
            bool isAssignTarget = false;
            for (auto* user : varRef->getResult(0).getUsers()) {
                if (auto assign = dyn_cast<helix::high::AssignOp>(user)) {
                    if (assign.getTarget() == varRef->getResult(0)) {
                        isAssignTarget = true;
                        break;
                    }
                }
            }
            if (!isAssignTarget) {
                auto it = lastRegValue.find(name);
                if (it != lastRegValue.end() && it->second != name) {
                    auto& val = it->second;
                    bool isConstant = !val.empty() &&
                        (val == "0" || val == "1" ||
                         val.starts_with("0x") ||
                         (val[0] >= '1' && val[0] <= '9') ||
                         (val[0] == '-' && val.size() > 1 && val[1] >= '0' && val[1] <= '9'));
                    if (isConstant)
                        return val;
                }
            }
        }

        // ─── Value Equivalence: prefer shorter/more meaningful names ────
        // If this variable name is a bare identifier that maps to an expression
        // which has a better (shorter, non-synthetic) alias, use that alias.
        {
            auto equivIt = exprToBestName_.find(name);
            if (equivIt != exprToBestName_.end() &&
                equivIt->second != name &&
                !isSyntheticTemporaryName(equivIt->second) &&
                equivIt->second.size() <= name.size()) {
                return equivIt->second;
            }
        }

        return name;
    }

    // ─── Binary expression ──────────────────────────────────────────────
    if (auto binary = dyn_cast<helix::high::BinaryOp>(defOp)) {
        std::string opStr;
        int prec = kPrecAdd; // default
        switch (binary.getOp()) {
        case helix::high::BinaryOpKind::Add:    opStr = "+"; prec = kPrecAdd; break;
        case helix::high::BinaryOpKind::Sub:    opStr = "-"; prec = kPrecAdd; break;
        case helix::high::BinaryOpKind::Mul:    opStr = "*"; prec = kPrecMul; break;
        case helix::high::BinaryOpKind::Div:    opStr = "/"; prec = kPrecMul; break;
        case helix::high::BinaryOpKind::Mod:    opStr = "%"; prec = kPrecMul; break;
        case helix::high::BinaryOpKind::Shl:    opStr = "<<"; prec = kPrecShift; break;
        case helix::high::BinaryOpKind::Shr:    opStr = ">>"; prec = kPrecShift; break;
        case helix::high::BinaryOpKind::Sar:    opStr = ">>"; prec = kPrecShift; break;
        case helix::high::BinaryOpKind::BitAnd: opStr = "&"; prec = kPrecBitAnd; break;
        case helix::high::BinaryOpKind::BitOr:  opStr = "|"; prec = kPrecBitOr; break;
        case helix::high::BinaryOpKind::BitXor: opStr = "^"; prec = kPrecBitXor; break;
        case helix::high::BinaryOpKind::Eq:     opStr = "=="; prec = kPrecEqual; break;
        case helix::high::BinaryOpKind::Ne:     opStr = "!="; prec = kPrecEqual; break;
        case helix::high::BinaryOpKind::Lt:     opStr = "<"; prec = kPrecRelational; break;
        case helix::high::BinaryOpKind::Le:     opStr = "<="; prec = kPrecRelational; break;
        case helix::high::BinaryOpKind::Gt:     opStr = ">"; prec = kPrecRelational; break;
        case helix::high::BinaryOpKind::Ge:     opStr = ">="; prec = kPrecRelational; break;
        case helix::high::BinaryOpKind::Ult:    opStr = "<"; prec = kPrecRelational; break;
        case helix::high::BinaryOpKind::Ule:    opStr = "<="; prec = kPrecRelational; break;
        case helix::high::BinaryOpKind::Ugt:    opStr = ">"; prec = kPrecRelational; break;
        case helix::high::BinaryOpKind::Uge:    opStr = ">="; prec = kPrecRelational; break;
        case helix::high::BinaryOpKind::LogAnd: opStr = "&&"; prec = kPrecLogAnd; break;
        case helix::high::BinaryOpKind::LogOr:  opStr = "||"; prec = kPrecLogOr; break;
        }
        auto lhsStr = formatExpressionWithPrec(binary.getLhs(), prec);
        auto rhsStr = formatExpressionWithPrec(binary.getRhs(), prec + 1);
        if (binary.getOp() == helix::high::BinaryOpKind::Ult ||
            binary.getOp() == helix::high::BinaryOpKind::Ule ||
            binary.getOp() == helix::high::BinaryOpKind::Ugt ||
            binary.getOp() == helix::high::BinaryOpKind::Uge) {
            lhsStr = std::format("(uint64_t)({})", lhsStr);
            rhsStr = std::format("(uint64_t)({})", rhsStr);
        }
        if (auto signedness = binary->getAttrOfType<StringAttr>(
                "helix.arithmetic_signedness")) {
            unsigned width = getIntBitWidth(binary.getResult().getType());
            const char* prefix =
                signedness.getValue() == "signed" ? "int" : "uint";
            lhsStr = std::format("({}{}_t)({})", prefix, width, lhsStr);
            rhsStr = std::format("({}{}_t)({})", prefix, width, rhsStr);
        }

        if (binary.getOp() == helix::high::BinaryOpKind::Add || binary.getOp() == helix::high::BinaryOpKind::Sub) {
            // Simplify x86 flat-model segment base: (x + *(type)((NULL + 0))) → x
            // and (*(type)((NULL + 0)) + x) → x
            auto isSegBase = [](const std::string& s) {
                return s.find("NULL + 0") != std::string::npos ||
                       s.find("NULL") == 0 && s.size() == 4 ||
                       s == "*(int64_t)(0)" || s == "*(int32_t)(0)" ||
                       s == "(*(int64_t)((NULL + 0)))" ||
                       s.find("*(int64_t)((NULL") != std::string::npos;
            };
            if (binary.getOp() == helix::high::BinaryOpKind::Add) {
                if (isSegBase(rhsStr)) return lhsStr;
                if (isSegBase(lhsStr)) return rhsStr;
            }

            if (auto lhs = parseFormattedIntegerLiteral(lhsStr)) {
                if (auto rhs = parseFormattedIntegerLiteral(rhsStr)) {
                    auto value = binary.getOp() == helix::high::BinaryOpKind::Add
                        ? (*lhs + *rhs)
                        : (*lhs - *rhs);
                    return formatIntLiteral(value);
                }
            }

            auto hasTlsBase = [](const std::string& s) {
                return s.find("__readgsqword(0x58)") != std::string::npos || s.find("&__local") != std::string::npos;
            };
            if (hasTlsBase(lhsStr)) {
                try {
                    uint64_t offset = 0;
                    if (rhsStr.starts_with("0x") || rhsStr.starts_with("0X")) offset = std::stoull(rhsStr.substr(2), nullptr, 16);
                    else offset = std::stoull(rhsStr, nullptr, 10);
                    uint64_t addr = (binary.getOp() == helix::high::BinaryOpKind::Add) ? (0x140000000ULL + offset) : (0x140000000ULL - offset);
                    return std::format("0x{:x}", addr);
                } catch(...) {}
            }

            // ─── Automatic Struct Field Recovery ────────────────────────────
            if (binary.getOp() == helix::high::BinaryOpKind::Add &&
                lhsStr.find(' ') == std::string::npos &&
                lhsStr.find('(') == std::string::npos &&
                !containsSyntheticValueIdentifier(lhsStr) &&
                looksLikeStructBaseIdentifier(lhsStr)) {
                if (rhsStr.starts_with("0x") || (rhsStr.find_first_not_of("0123456789") == std::string::npos)) {
                    if (lhsStr != "rsp" && lhsStr != "rbp") { // Don't turn stack pointers into structs
                        std::string hexOffset = rhsStr;
                        if (!hexOffset.starts_with("0x")) {
                            try { hexOffset = std::format("0x{:x}", std::stoull(hexOffset)); } catch(...) {}
                        }
                        return std::format("&{}->field_{}", lhsStr, hexOffset);
                    }
                }
            }
        }

        auto result = std::format("{} {} {}", lhsStr, opStr, rhsStr);
        if (prec < parentPrec) result = "(" + result + ")";
        return result;
    }

    // ─── Unary expression ───────────────────────────────────────────────
    if (auto unary = dyn_cast<helix::high::UnaryOp>(defOp)) {
        // Simplify !(x == y) → (x != y), !(x != y) → (x == y), etc.
        if (unary.getOp() == helix::high::UnaryOpKind::LogNot) {
            if (auto innerBin = unary.getOperand().getDefiningOp<helix::high::BinaryOp>()) {
                auto kind = innerBin.getOp();
                helix::high::BinaryOpKind negated =
                    helix::high::BinaryOpKind::Eq;
                bool canNegate = true;
                switch (kind) {
                case helix::high::BinaryOpKind::Eq: negated = helix::high::BinaryOpKind::Ne; break;
                case helix::high::BinaryOpKind::Ne: negated = helix::high::BinaryOpKind::Eq; break;
                case helix::high::BinaryOpKind::Lt: negated = helix::high::BinaryOpKind::Ge; break;
                case helix::high::BinaryOpKind::Le: negated = helix::high::BinaryOpKind::Gt; break;
                case helix::high::BinaryOpKind::Gt: negated = helix::high::BinaryOpKind::Le; break;
                case helix::high::BinaryOpKind::Ge: negated = helix::high::BinaryOpKind::Lt; break;
                case helix::high::BinaryOpKind::Ult: negated = helix::high::BinaryOpKind::Uge; break;
                case helix::high::BinaryOpKind::Ule: negated = helix::high::BinaryOpKind::Ugt; break;
                case helix::high::BinaryOpKind::Ugt: negated = helix::high::BinaryOpKind::Ule; break;
                case helix::high::BinaryOpKind::Uge: negated = helix::high::BinaryOpKind::Ult; break;
                default: canNegate = false; break;
                }
                if (canNegate) {
                    std::string opStr;
                    int negPrec = kPrecEqual;
                    switch (negated) {
                    case helix::high::BinaryOpKind::Eq: opStr = "=="; negPrec = kPrecEqual; break;
                    case helix::high::BinaryOpKind::Ne: opStr = "!="; negPrec = kPrecEqual; break;
                    case helix::high::BinaryOpKind::Lt: opStr = "<"; negPrec = kPrecRelational; break;
                    case helix::high::BinaryOpKind::Le: opStr = "<="; negPrec = kPrecRelational; break;
                    case helix::high::BinaryOpKind::Gt: opStr = ">"; negPrec = kPrecRelational; break;
                    case helix::high::BinaryOpKind::Ge: opStr = ">="; negPrec = kPrecRelational; break;
                    case helix::high::BinaryOpKind::Ult: opStr = "<"; negPrec = kPrecRelational; break;
                    case helix::high::BinaryOpKind::Ule: opStr = "<="; negPrec = kPrecRelational; break;
                    case helix::high::BinaryOpKind::Ugt: opStr = ">"; negPrec = kPrecRelational; break;
                    case helix::high::BinaryOpKind::Uge: opStr = ">="; negPrec = kPrecRelational; break;
                    default: opStr = "??"; break;
                    }
                    auto negLhs = formatExpressionWithPrec(innerBin.getLhs(), negPrec);
                    auto negRhs = formatExpressionWithPrec(innerBin.getRhs(), negPrec + 1);
                    if (negated == helix::high::BinaryOpKind::Ult ||
                        negated == helix::high::BinaryOpKind::Ule ||
                        negated == helix::high::BinaryOpKind::Ugt ||
                        negated == helix::high::BinaryOpKind::Uge) {
                        negLhs = std::format("(uint64_t)({})", negLhs);
                        negRhs = std::format("(uint64_t)({})", negRhs);
                    }
                    auto negResult = std::format("{} {} {}", negLhs, opStr, negRhs);
                    if (negPrec < parentPrec) negResult = "(" + negResult + ")";
                    return negResult;
                }
            }
        }

        // Simplify *&x → x  and  &*x → x  (cancel inverse operations)
        auto innerExpr = formatExpressionWithPrec(unary.getOperand(), kPrecUnary);
        if (unary.getOp() == helix::high::UnaryOpKind::Deref &&
            innerExpr.starts_with("&")) {
            auto inner = innerExpr.substr(1);
            if (inner.starts_with("(") && inner.back() == ')')
                inner = inner.substr(1, inner.size() - 2);
            return inner;
        }
        if (unary.getOp() == helix::high::UnaryOpKind::AddressOf &&
            innerExpr.starts_with("*")) {
            auto inner = innerExpr.substr(1);
            if (inner.starts_with("(") && inner.back() == ')')
                inner = inner.substr(1, inner.size() - 2);
            return inner;
        }
        std::string opStr;
        switch (unary.getOp()) {
        case helix::high::UnaryOpKind::Neg:       opStr = "-"; break;
        case helix::high::UnaryOpKind::LogNot:    opStr = "!"; break;
        case helix::high::UnaryOpKind::BitNot:    opStr = "~"; break;
        case helix::high::UnaryOpKind::Deref:     opStr = "*"; break;
        case helix::high::UnaryOpKind::AddressOf: opStr = "&"; break;
        }
        auto unaryResult = std::format("{}{}", opStr, innerExpr);
        if (kPrecUnary < parentPrec) unaryResult = "(" + unaryResult + ")";
        return unaryResult;
    }

    // ─── Cast expression ────────────────────────────────────────────────
    if (auto castOp = dyn_cast<helix::high::CastOp>(defOp)) {
        // Elide identity casts (same type in -> out)
        if (castOp.getInput().getType() == castOp.getResult().getType())
            return formatExpressionWithPrec(castOp.getInput(), parentPrec);
        auto castKind = castOp->getAttrOfType<
            helix::high::CastKindAttr>("cast_kind");
        const bool exactExtension = castKind &&
            (castKind.getValue() == helix::high::CastKind::ZeroExtend ||
             castKind.getValue() == helix::high::CastKind::SignExtend);
        // Elide redundant casts based on context analysis
        if (!exactExtension &&
            isCastRedundant(castOp.getInput().getType(),
                            castOp.getResult().getType(),
                            castOp.getResult()))
            return formatExpressionWithPrec(castOp.getInput(), parentPrec);
        std::string castType = formatType(castOp.getResult().getType());
        if (castKind) {
            unsigned width = getIntBitWidth(castOp.getResult().getType());
            if (castKind.getValue() == helix::high::CastKind::ZeroExtend)
                castType = std::format("uint{}_t", width);
            else if (castKind.getValue() ==
                     helix::high::CastKind::SignExtend)
                castType = std::format("int{}_t", width);
        }
        auto castResult = std::format("({})({})",
            castType,
            formatExpressionWithPrec(castOp.getInput(), 0));
        if (kPrecUnary < parentPrec) castResult = "(" + castResult + ")";
        return castResult;
    }

    // ─── Function call expression ───────────────────────────────────────
    if (auto call = dyn_cast<helix::high::CallOp>(defOp)) {
        auto calleeName = call.getTargetName().str();
        auto args = call.getArgs();

        // Detect vtable pattern: __vtable_0xNN → base->vfunc_0xNN(rest...)
        if (calleeName.starts_with("__vtable_0x") && !args.empty()) {
            auto offsetStr = calleeName.substr(9); // "__vtable_" is 9 chars → "0x18"
            std::string result = formatExpressionWithPrec(args[0], 0) + "->vfunc_" + offsetStr + "(";
            for (size_t i = 1; i < args.size(); i++) {
                if (i > 1) result += ", ";
                result += formatExpressionWithPrec(args[i], 0);
            }
            result += ")";
            return result;
        }

        std::string result = calleeName + "(";
        for (size_t i = 0; i < args.size(); i++) {
            if (i > 0) result += ", ";
            result += formatExpressionWithPrec(args[i], 0);
        }
        result += ")";
        return result;
    }

    // ─── Ternary expression ─────────────────────────────────────────────
    if (auto ternary = dyn_cast<helix::high::TernaryOp>(defOp)) {
        auto ternResult = std::format("{} ? {} : {}",
            formatExpressionWithPrec(ternary.getCond(), kPrecTernary + 1),
            formatExpressionWithPrec(ternary.getTrueVal(), 0),
            formatExpressionWithPrec(ternary.getFalseVal(), kPrecTernary));
        if (kPrecTernary < parentPrec) ternResult = "(" + ternResult + ")";
        return ternResult;
    }

    // ─── Subscript expression ───────────────────────────────────────────
    if (auto sub = dyn_cast<helix::high::SubscriptOp>(defOp)) {
        return std::format("{}[{}]",
            formatExpressionWithPrec(sub.getBase(), kPrecAtom),
            formatExpressionWithPrec(sub.getIndex(), 0));
    }

    // ─── Field access expression ────────────────────────────────────────
    if (auto field = dyn_cast<helix::high::FieldAccessOp>(defOp)) {
        auto op_str = field.getIsPointer() ? "->" : ".";
        auto baseStr = formatExpressionWithPrec(field.getBase(), kPrecAtom);
        auto originalName = field.getFieldName().str();
        auto offset = field.getFieldOffset();

        // Try to recover a meaningful field name for generic field_XX names
        std::string fieldName = originalName;
        if (isGenericFieldName(originalName)) {
            auto recovered = getRecoveredFieldName(
                applyNameAliases(baseStr), offset);
            if (!recovered.empty())
                fieldName = recovered;
        }

        return std::format("{}{}{}", baseStr, op_str, fieldName);
    }

    // ─── Address literal ────────────────────────────────────────────────
    if (auto addrLit = dyn_cast<helix::high::AddrLitOp>(defOp)) {
        return std::format("0x{:x}", addrLit.getAddrValue());
    }

    if (auto unknown = dyn_cast<helix::high::UnknownValueOp>(defOp)) {
        return std::format(
            "__helix_unknown(\"{}\")", unknown.getReason().str());
    }

    // ═════════════════════════════════════════════════════════════════════
    // HelixMid Dialect expressions (from Low→Mid partial conversion)
    // ═════════════════════════════════════════════════════════════════════

    if (auto midConst = dyn_cast<helix::mid::ConstantOp>(defOp)) {
        return formatIntLiteral(midConst.getValue());
    }

    if (auto midVarRef = dyn_cast<helix::mid::VarRefOp>(defOp)) {
        uint32_t slot = midVarRef.getSlotId();
        return std::format("slot_{}", slot);
    }

    if (auto midBinExpr = dyn_cast<helix::mid::BinExprOp>(defOp)) {
        if (midBinExpr.getKind() == helix::mid::BinExprKind::Rol ||
            midBinExpr.getKind() == helix::mid::BinExprKind::Ror) {
            unsigned width = getIntBitWidth(midBinExpr.getResult().getType());
            const char* direction =
                midBinExpr.getKind() == helix::mid::BinExprKind::Rol
                    ? "rotateleft"
                    : "rotateright";
            return std::format(
                "__builtin_{}{}({}, {})", direction, width,
                formatExpressionWithPrec(midBinExpr.getLhs(), 0),
                formatExpressionWithPrec(midBinExpr.getRhs(), 0));
        }
        std::string opStr;
        int prec = kPrecAdd;
        switch (midBinExpr.getKind()) {
        case helix::mid::BinExprKind::Add:    opStr = "+"; prec = kPrecAdd; break;
        case helix::mid::BinExprKind::Sub:    opStr = "-"; prec = kPrecAdd; break;
        case helix::mid::BinExprKind::Mul:    opStr = "*"; prec = kPrecMul; break;
        case helix::mid::BinExprKind::Div:    opStr = "/"; prec = kPrecMul; break;
        case helix::mid::BinExprKind::UMul:   opStr = "*"; prec = kPrecMul; break;
        case helix::mid::BinExprKind::SMul:   opStr = "*"; prec = kPrecMul; break;
        case helix::mid::BinExprKind::UDiv:   opStr = "/"; prec = kPrecMul; break;
        case helix::mid::BinExprKind::SDiv:   opStr = "/"; prec = kPrecMul; break;
        case helix::mid::BinExprKind::Mod:    opStr = "%"; prec = kPrecMul; break;
        case helix::mid::BinExprKind::Shl:    opStr = "<<"; prec = kPrecShift; break;
        case helix::mid::BinExprKind::Shr:    opStr = ">>"; prec = kPrecShift; break;
        case helix::mid::BinExprKind::Sar:    opStr = ">>"; prec = kPrecShift; break;
        case helix::mid::BinExprKind::BitAnd: opStr = "&"; prec = kPrecBitAnd; break;
        case helix::mid::BinExprKind::BitOr:  opStr = "|"; prec = kPrecBitOr; break;
        case helix::mid::BinExprKind::BitXor: opStr = "^"; prec = kPrecBitXor; break;
        case helix::mid::BinExprKind::Eq:     opStr = "=="; prec = kPrecEqual; break;
        case helix::mid::BinExprKind::Ne:     opStr = "!="; prec = kPrecEqual; break;
        case helix::mid::BinExprKind::Lt:     opStr = "<"; prec = kPrecRelational; break;
        case helix::mid::BinExprKind::Le:     opStr = "<="; prec = kPrecRelational; break;
        case helix::mid::BinExprKind::Gt:     opStr = ">"; prec = kPrecRelational; break;
        case helix::mid::BinExprKind::Ge:     opStr = ">="; prec = kPrecRelational; break;
        case helix::mid::BinExprKind::Ult:    opStr = "<"; prec = kPrecRelational; break;
        case helix::mid::BinExprKind::Ule:    opStr = "<="; prec = kPrecRelational; break;
        case helix::mid::BinExprKind::Ugt:    opStr = ">"; prec = kPrecRelational; break;
        case helix::mid::BinExprKind::Uge:    opStr = ">="; prec = kPrecRelational; break;
        case helix::mid::BinExprKind::LogAnd: opStr = "&&"; prec = kPrecLogAnd; break;
        case helix::mid::BinExprKind::LogOr:  opStr = "||"; prec = kPrecLogOr; break;
        }
        auto lhsStr = formatExpressionWithPrec(midBinExpr.getLhs(), prec);
        auto rhsStr = formatExpressionWithPrec(midBinExpr.getRhs(), prec + 1);
        if (midBinExpr.getKind() == helix::mid::BinExprKind::UMul ||
            midBinExpr.getKind() == helix::mid::BinExprKind::UDiv ||
            midBinExpr.getKind() == helix::mid::BinExprKind::SMul ||
            midBinExpr.getKind() == helix::mid::BinExprKind::SDiv) {
            unsigned width = getIntBitWidth(midBinExpr.getResult().getType());
            const bool isSigned =
                midBinExpr.getKind() == helix::mid::BinExprKind::SMul ||
                midBinExpr.getKind() == helix::mid::BinExprKind::SDiv;
            const char* prefix = isSigned ? "int" : "uint";
            lhsStr = std::format("({}{}_t)({})", prefix, width, lhsStr);
            rhsStr = std::format("({}{}_t)({})", prefix, width, rhsStr);
        }
        if (midBinExpr.getKind() == helix::mid::BinExprKind::Ult ||
            midBinExpr.getKind() == helix::mid::BinExprKind::Ule ||
            midBinExpr.getKind() == helix::mid::BinExprKind::Ugt ||
            midBinExpr.getKind() == helix::mid::BinExprKind::Uge) {
            lhsStr = std::format("(uint64_t)({})", lhsStr);
            rhsStr = std::format("(uint64_t)({})", rhsStr);
        }
        auto result = std::format("{} {} {}", lhsStr, opStr, rhsStr);
        if (prec < parentPrec) result = "(" + result + ")";
        return result;
    }

    if (auto midUnExpr = dyn_cast<helix::mid::UnExprOp>(defOp)) {
        auto inner = formatExpressionWithPrec(midUnExpr.getOperand(), kPrecUnary);
        unsigned width = getIntBitWidth(midUnExpr.getResult().getType());
        switch (midUnExpr.getKind()) {
        case helix::mid::UnExprKind::Bswap:
            return std::format("__builtin_bswap{}({})", width, inner);
        case helix::mid::UnExprKind::Bsf:
            return std::format("__helix_bsf{}({})", width, inner);
        case helix::mid::UnExprKind::Bsr:
            return std::format("__helix_bsr{}({})", width, inner);
        default:
            break;
        }
        std::string opStr;
        switch (midUnExpr.getKind()) {
        case helix::mid::UnExprKind::Neg:    opStr = "-"; break;
        case helix::mid::UnExprKind::LogNot: opStr = "!"; break;
        case helix::mid::UnExprKind::BitNot: opStr = "~"; break;
        case helix::mid::UnExprKind::Deref:  opStr = "*"; break;
        case helix::mid::UnExprKind::AddrOf: opStr = "&"; break;
        case helix::mid::UnExprKind::Bswap:
        case helix::mid::UnExprKind::Bsf:
        case helix::mid::UnExprKind::Bsr:
            llvm_unreachable("handled machine unary above");
        }
        auto unResult = std::format("{}{}", opStr, inner);
        if (kPrecUnary < parentPrec) unResult = "(" + unResult + ")";
        return unResult;
    }

    if (auto midCast = dyn_cast<helix::mid::CastOp>(defOp)) {
        // Elide identity casts
        if (midCast.getInput().getType() == midCast.getResult().getType())
            return formatExpressionWithPrec(midCast.getInput(), parentPrec);
        auto castKind = midCast->getAttrOfType<
            helix::mid::CastKindAttr>("cast_kind");
        const bool exactExtension = castKind &&
            (castKind.getValue() == helix::mid::CastKind::ZeroExtend ||
             castKind.getValue() == helix::mid::CastKind::SignExtend);
        // Elide redundant casts based on context analysis
        if (!exactExtension &&
            isCastRedundant(midCast.getInput().getType(),
                            midCast.getResult().getType(),
                            midCast.getResult()))
            return formatExpressionWithPrec(midCast.getInput(), parentPrec);
        std::string castType = formatType(midCast.getResult().getType());
        if (castKind) {
            unsigned width = getIntBitWidth(midCast.getResult().getType());
            if (castKind.getValue() == helix::mid::CastKind::ZeroExtend)
                castType = std::format("uint{}_t", width);
            else if (castKind.getValue() ==
                     helix::mid::CastKind::SignExtend)
                castType = std::format("int{}_t", width);
        }
        auto castResult = std::format("({})({})",
            castType,
            formatExpressionWithPrec(midCast.getInput(), 0));
        if (kPrecUnary < parentPrec) castResult = "(" + castResult + ")";
        return castResult;
    }

    if (auto midLoad = dyn_cast<helix::mid::LoadOp>(defOp)) {
        auto addrStr = formatExpressionWithPrec(midLoad.getAddr(), 0);
        if (addrStr.starts_with("&") && addrStr.find("->") != std::string::npos)
            return addrStr.substr(1);
        return std::format("*({})", addrStr);
    }

    if (auto midSelect = dyn_cast<helix::mid::SelectOp>(defOp)) {
        auto selResult = std::format("{} ? {} : {}",
            formatExpressionWithPrec(midSelect.getCondition(), kPrecTernary + 1),
            formatExpressionWithPrec(midSelect.getTrueVal(), 0),
            formatExpressionWithPrec(midSelect.getFalseVal(), kPrecTernary));
        if (kPrecTernary < parentPrec) selResult = "(" + selResult + ")";
        return selResult;
    }

    if (auto midFieldPtr = dyn_cast<helix::mid::FieldPtrOp>(defOp)) {
        auto baseStr = formatExpressionWithPrec(midFieldPtr.getBase(), kPrecAtom);
        auto offset = midFieldPtr.getFieldOffset();

        // Check for an explicit name from the IR first
        if (auto name = midFieldPtr.getFieldName()) {
            auto nameStr = name->str();
            // If it's a generic name, try recovery
            if (isGenericFieldName(nameStr)) {
                auto recovered = getRecoveredFieldName(
                    applyNameAliases(baseStr), offset);
                if (!recovered.empty())
                    return std::format("&{}->{}", baseStr, recovered);
            }
            return std::format("&{}->{}", baseStr, nameStr);
        }

        // No name in IR — try recovery, then fall back to field_0xNN
        auto recovered = getRecoveredFieldName(
            applyNameAliases(baseStr), offset);
        if (!recovered.empty())
            return std::format("&{}->{}", baseStr, recovered);
        return std::format("&{}->field_0x{:x}", baseStr, offset);
    }

    if (auto midIdxPtr = dyn_cast<helix::mid::IndexPtrOp>(defOp)) {
        return std::format("&{}[{}]",
            formatExpressionWithPrec(midIdxPtr.getBase(), kPrecAtom),
            formatExpressionWithPrec(midIdxPtr.getIndex(), 0));
    }

    if (auto midAddr = dyn_cast<helix::mid::AddrConstOp>(defOp)) {
        return std::format("0x{:x}", midAddr.getAddrValue());
    }

    if (auto unknown = dyn_cast<helix::mid::UnknownValueOp>(defOp)) {
        return std::format(
            "__helix_unknown(\"{}\")", unknown.getReason().str());
    }

    if (auto midCall = dyn_cast<helix::mid::CallOp>(defOp)) {
        std::string result;
        if (auto name = midCall.getCalleeName())
            result = name->str();
        else
            result = std::format("sub_{:x}", midCall.getCalleeAddr());
        result += "(";
        auto args = midCall.getArgs();
        for (size_t i = 0; i < args.size(); i++) {
            if (i > 0) result += ", ";
            result += formatExpressionWithPrec(args[i], 0);
        }
        result += ")";
        return result;
    }

    // ═════════════════════════════════════════════════════════════════════
    // HelixLow Dialect fallback expressions
    // ═════════════════════════════════════════════════════════════════════

    if (auto unknown = dyn_cast<helix::low::UnknownValueOp>(defOp)) {
        return std::format(
            "__helix_unknown(\"{}\")", unknown.getReason().str());
    }

    if (auto regRead = dyn_cast<helix::low::RegReadOp>(defOp)) {
        std::string name = regRead.getRegName().str();
        // ─── Win64 calling convention: map arg registers to argN ─────
        // Initial reads of RCX/RDX/R8/R9 (or their 32-bit aliases) are
        // function arguments in the Windows x64 ABI.
        static const std::pair<const char*, unsigned> kArgMap[] = {
            {"RCX", 1}, {"ECX", 1},
            {"RDX", 2}, {"EDX", 2},
            {"R8",  3}, {"R8D", 3},
            {"R9",  4}, {"R9D", 4},
        };
        for (auto [reg, argIndex] : kArgMap) {
            if (name == reg)
                return applyNameAliases(std::format("param_{}", argIndex));
        }
        for (auto& c : name) c = std::tolower(c);
        return name;
    }

    if (auto memRead = dyn_cast<helix::low::MemReadOp>(defOp)) {
        if (auto paramIndex = inferWin64StackParamIndex(memRead.getOperation(),
                                                        memRead.getAddr());
            paramIndex && *paramIndex <= currentWin64StackParamLimit_)
            return applyNameAliases(std::format("param_{}", *paramIndex));

        // Resolve stack variable: rbp ± offset → var_name
        if (!stackOffsetToVarName_.empty()) {
            if (auto* addrDef = memRead.getAddr().getDefiningOp()) {
                // Check for low::BinOp (rbp - offset) or high::BinaryOp
                if (auto binop = dyn_cast<helix::low::BinOp>(addrDef)) {
                    auto lhsStr = formatExpressionWithPrec(binop.getLhs(), 0);
                    if (lhsStr == "rbp" || lhsStr == "RBP") {
                        if (auto rhsConst = binop.getRhs().getDefiningOp<arith::ConstantOp>()) {
                            if (auto intAttr = dyn_cast<IntegerAttr>(rhsConst.getValue())) {
                                int64_t off = intAttr.getInt();
                                if (binop.getKind() == helix::low::BinOpKind::Sub) off = -off;
                                auto it = stackOffsetToVarName_.find(off);
                                if (it != stackOffsetToVarName_.end())
                                    return it->second;
                            }
                        }
                        // Try LLVM::ConstantOp as well
                        if (auto rhsConst = binop.getRhs().getDefiningOp<LLVM::ConstantOp>()) {
                            if (auto intAttr = dyn_cast<IntegerAttr>(rhsConst.getValue())) {
                                int64_t off = intAttr.getInt();
                                if (binop.getKind() == helix::low::BinOpKind::Sub) off = -off;
                                auto it = stackOffsetToVarName_.find(off);
                                if (it != stackOffsetToVarName_.end())
                                    return it->second;
                            }
                        }
                    }
                }
            }
        }

        auto addrStr = formatExpressionWithPrec(memRead.getAddr(), 0);
        // x86-32 flat model: *(NULL) is segment base = 0
        if (addrStr == "NULL" || addrStr == "(void*)(0)")
            return "0";
        // Clean up *( &param_X->field_Y ) into param_X->field_Y
        if (addrStr.starts_with("&") && addrStr.find("->") != std::string::npos) {
            return addrStr.substr(1);
        }
        if (addrStr.starts_with("(&") && addrStr.back() == ')' && addrStr.find("->") != std::string::npos) {
            return addrStr.substr(2, addrStr.size() - 3);
        }

        return std::format("*{}", addrStr);
    }

    if (auto binop = dyn_cast<helix::low::BinOp>(defOp)) {
        // ─── XOR(A, A) → 0 peephole ────────────────────────────────
        // The classic `xor reg, reg` idiom for zeroing a register.
        if (binop.getKind() == helix::low::BinOpKind::Xor) {
            auto lhsStr = formatExpressionWithPrec(binop.getLhs(), 0);
            auto rhsStr = formatExpressionWithPrec(binop.getRhs(), 0);
            if (lhsStr == rhsStr)
                return std::string("0");
        }
        // ─── SUB(A, A) → 0 peephole ────────────────────────────────
        if (binop.getKind() == helix::low::BinOpKind::Sub) {
            auto lhsStr = formatExpressionWithPrec(binop.getLhs(), 0);
            auto rhsStr = formatExpressionWithPrec(binop.getRhs(), 0);
            if (lhsStr == rhsStr)
                return std::string("0");
        }

        // Check if we're referencing a flag result (not the main result)
        if (auto opResult = dyn_cast<OpResult>(val)) {
            unsigned resNum = opResult.getResultNumber();
            if (resNum > 0) {
                auto lhs = formatExpressionWithPrec(binop.getLhs(), 0);
                auto rhs = formatExpressionWithPrec(binop.getRhs(), 0);
                switch (resNum) {
                case 1: return std::format("__carry({}, {})", lhs, rhs);
                case 2: return std::format("(({}) == 0)", lhs);  // zero flag
                case 3: return std::format("(({}) < 0)", lhs);   // sign flag
                case 4: return std::format("__overflow({}, {})", lhs, rhs);
                default: return "/* flag */";
                }
            }
        }

        std::string opStr;
        int prec = kPrecAdd;
        switch (binop.getKind()) {
        case helix::low::BinOpKind::Add:  opStr = "+"; prec = kPrecAdd; break;
        case helix::low::BinOpKind::Sub:  opStr = "-"; prec = kPrecAdd; break;
        case helix::low::BinOpKind::Mul:  opStr = "*"; prec = kPrecMul; break;
        case helix::low::BinOpKind::IMul: opStr = "*"; prec = kPrecMul; break;
        case helix::low::BinOpKind::Div:  opStr = "/"; prec = kPrecMul; break;
        case helix::low::BinOpKind::IDiv: opStr = "/"; prec = kPrecMul; break;
        case helix::low::BinOpKind::And:  opStr = "&"; prec = kPrecBitAnd; break;
        case helix::low::BinOpKind::Or:   opStr = "|"; prec = kPrecBitOr; break;
        case helix::low::BinOpKind::Xor:  opStr = "^"; prec = kPrecBitXor; break;
        case helix::low::BinOpKind::Shl:  opStr = "<<"; prec = kPrecShift; break;
        case helix::low::BinOpKind::Shr:  opStr = ">>"; prec = kPrecShift; break;
        case helix::low::BinOpKind::Sar:  opStr = ">>"; prec = kPrecShift; break;
        case helix::low::BinOpKind::Rol:  opStr = "<<<"; prec = kPrecShift; break;
        case helix::low::BinOpKind::Ror:  opStr = ">>>"; prec = kPrecShift; break;
        }
        auto lhsStr = formatExpressionWithPrec(binop.getLhs(), prec);
        auto rhsStr = formatExpressionWithPrec(binop.getRhs(), prec + 1);

        if (binop.getKind() == helix::low::BinOpKind::Add || binop.getKind() == helix::low::BinOpKind::Sub) {

            // ─── x86 Segment Base Simplification (flat model) ─────────────
            // In 32-bit x86 flat memory model, all memory accesses go through
            // GS_BASE which is 0. This produces `addr + *(int64_t)((NULL + 0))`
            // patterns that should simplify to just `addr`.
            auto isSegBase = [](const std::string& s) {
                return s.find("NULL + 0") != std::string::npos ||
                       (s.find("NULL") == 0 && s.size() == 4) ||
                       s == "*(int64_t)(0)" || s == "*(int32_t)(0)" ||
                       s == "(*(int64_t)(0))" || s == "(*(int32_t)(0))" ||
                       s == "(*(int64_t)((NULL + 0)))" ||
                       s.find("*(int64_t)((NULL") != std::string::npos ||
                       s == "0" || s == "*(int64_t)(NULL)" || s == "*(NULL)";
            };
            if (binop.getKind() == helix::low::BinOpKind::Add) {
                if (isSegBase(rhsStr)) return lhsStr;
                if (isSegBase(lhsStr)) return rhsStr;
            }

            // ─── Segment Register Awareness ─────────────────────────────────
            if (binop.getKind() == helix::low::BinOpKind::Add && (lhsStr == "*(int64_t)(NULL)" || lhsStr == "*(NULL)")) {
                std::string hexOffset = rhsStr;
                if (!hexOffset.starts_with("0x")) {
                    try { hexOffset = std::format("0x{:x}", std::stoull(hexOffset)); } catch(...) {}
                }
                return std::format("__readgsqword({})", hexOffset);
            }

            auto hasTlsBase = [](const std::string& s) {
                return s.find("__readgsqword(0x58)") != std::string::npos || s.find("&__local") != std::string::npos;
            };
            if (hasTlsBase(lhsStr)) {
                try {
                    uint64_t offset = 0;
                    if (rhsStr.starts_with("0x") || rhsStr.starts_with("0X")) offset = std::stoull(rhsStr.substr(2), nullptr, 16);
                    else offset = std::stoull(rhsStr, nullptr, 10);
                    uint64_t addr = (binop.getKind() == helix::low::BinOpKind::Add) ? (0x140000000ULL + offset) : (0x140000000ULL - offset);
                    return std::format("0x{:x}", addr);
                } catch(...) {}
            }

            // ─── Automatic Struct Field Recovery ────────────────────────────
            if (binop.getKind() == helix::low::BinOpKind::Add &&
                lhsStr.find(' ') == std::string::npos &&
                lhsStr.find('(') == std::string::npos &&
                !containsSyntheticValueIdentifier(lhsStr) &&
                looksLikeStructBaseIdentifier(lhsStr)) {
                if (rhsStr.starts_with("0x") || (rhsStr.find_first_not_of("0123456789") == std::string::npos)) {
                    if (lhsStr != "rsp" && lhsStr != "rbp") { // Don't turn stack pointers into structs
                        std::string hexOffset = rhsStr;
                        if (!hexOffset.starts_with("0x")) {
                            try { hexOffset = std::format("0x{:x}", std::stoull(hexOffset)); } catch(...) {}
                        }
                        return std::format("&{}->field_{}", lhsStr, hexOffset);
                    }
                }
            }
        }

        // ─── Hash Function Inlining ─────────────────────────────────────
        if ((binop.getKind() == helix::low::BinOpKind::Mul || binop.getKind() == helix::low::BinOpKind::IMul) &&
            (rhsStr == "0x8001" || rhsStr == "32769")) {
            std::string x = lhsStr;
            if (x.starts_with("(int64_t)(")) x = x.substr(10, x.size() - 11);
            else if (x.starts_with("(uint64_t)(")) x = x.substr(11, x.size() - 12);
            return std::format("HASH({})", x);
        }

        auto result = std::format("{} {} {}", lhsStr, opStr, rhsStr);
        if (prec < parentPrec) result = "(" + result + ")";
        return result;
    }

    // ─── HelixLow: Unary operation ──────────────────────────────────────
    if (auto unary = dyn_cast<helix::low::UnaryOp>(defOp)) {
        // Check if we're referencing a flag result
        if (auto opResult = dyn_cast<OpResult>(val)) {
            unsigned resNum = opResult.getResultNumber();
            if (resNum > 0) {
                auto operand = formatExpressionWithPrec(unary.getOperand(), 0);
                switch (resNum) {
                case 1: return std::format("(({}) == 0)", operand); // zero flag
                case 2: return std::format("(({}) < 0)", operand);  // sign flag
                default: return "/* flag */";
                }
            }
        }

        auto operand = formatExpressionWithPrec(unary.getOperand(), kPrecUnary);
        switch (unary.getKind()) {
        case helix::low::UnaryOpKind::Neg: {
            auto r = std::format("-{}", operand);
            if (kPrecUnary < parentPrec) r = "(" + r + ")";
            return r;
        }
        case helix::low::UnaryOpKind::Not: {
            auto r = std::format("~{}", operand);
            if (kPrecUnary < parentPrec) r = "(" + r + ")";
            return r;
        }
        case helix::low::UnaryOpKind::Inc: {
            auto r = std::format("{} + 1", formatExpressionWithPrec(unary.getOperand(), kPrecAdd));
            if (kPrecAdd < parentPrec) r = "(" + r + ")";
            return r;
        }
        case helix::low::UnaryOpKind::Dec: {
            auto r = std::format("{} - 1", formatExpressionWithPrec(unary.getOperand(), kPrecAdd));
            if (kPrecAdd < parentPrec) r = "(" + r + ")";
            return r;
        }
        case helix::low::UnaryOpKind::Bswap: return std::format("__builtin_bswap64({})", formatExpressionWithPrec(unary.getOperand(), 0));
        case helix::low::UnaryOpKind::Bsf:   return std::format("__builtin_ctzll({})", formatExpressionWithPrec(unary.getOperand(), 0));
        case helix::low::UnaryOpKind::Bsr:   return std::format("(63 - __builtin_clzll({}))", formatExpressionWithPrec(unary.getOperand(), 0));
        }
        return std::format("/* unary: {} */", operand);
    }

    // ─── HelixLow: Cmp (flag results) ───────────────────────────────────
    if (auto cmp = dyn_cast<helix::low::CmpOp>(defOp)) {
        auto lhs = formatExpressionWithPrec(cmp.getLhs(), 0);
        auto rhs = formatExpressionWithPrec(cmp.getRhs(), 0);
        if (auto opResult = dyn_cast<OpResult>(val)) {
            switch (opResult.getResultNumber()) {
            case 0: {
                auto r = std::format("{} < {}", formatExpressionWithPrec(cmp.getLhs(), kPrecRelational), formatExpressionWithPrec(cmp.getRhs(), kPrecRelational + 1));
                if (kPrecRelational < parentPrec) r = "(" + r + ")";
                return r;
            }
            case 1: {
                auto r = std::format("{} == {}", formatExpressionWithPrec(cmp.getLhs(), kPrecEqual), formatExpressionWithPrec(cmp.getRhs(), kPrecEqual + 1));
                if (kPrecEqual < parentPrec) r = "(" + r + ")";
                return r;
            }
            case 2: return std::format("(({} - {}) < 0)", lhs, rhs); // sign
            case 3: return std::format("__overflow({}, {})", lhs, rhs);
            }
        }
        return std::format("cmp({}, {})", lhs, rhs);
    }

    // ─── HelixLow: Test (flag results) ──────────────────────────────────
    if (auto test = dyn_cast<helix::low::TestOp>(defOp)) {
        auto lhs = formatExpressionWithPrec(test.getLhs(), 0);
        auto rhs = formatExpressionWithPrec(test.getRhs(), 0);
        if (auto opResult = dyn_cast<OpResult>(val)) {
            switch (opResult.getResultNumber()) {
            case 0: return std::format("(({} & {}) == 0)", lhs, rhs); // zero
            case 1: return std::format("(({} & {}) < 0)", lhs, rhs);  // sign
            }
        }
        {
            auto r = std::format("{} & {}", formatExpressionWithPrec(test.getLhs(), kPrecBitAnd), formatExpressionWithPrec(test.getRhs(), kPrecBitAnd + 1));
            if (kPrecBitAnd < parentPrec) r = "(" + r + ")";
            return r;
        }
    }

    // ─── HelixLow: CMov (conditional select) ────────────────────────────
    if (auto cmov = dyn_cast<helix::low::CMovOp>(defOp)) {
        auto cmovResult = std::format("{} ? {} : {}",
            formatExpressionWithPrec(cmov.getFlagValue(), kPrecTernary + 1),
            formatExpressionWithPrec(cmov.getTrueVal(), 0),
            formatExpressionWithPrec(cmov.getFalseVal(), kPrecTernary));
        if (kPrecTernary < parentPrec) cmovResult = "(" + cmovResult + ")";
        return cmovResult;
    }

    // ─── HelixLow: MovZx/MovSx (zero/sign extend) ──────────────────────
    if (auto movzx = dyn_cast<helix::low::MovZxOp>(defOp)) {
        unsigned dstWidth = movzx.getDstWidth();
        unsigned srcWidth = getIntBitWidth(movzx.getSrc().getType());
        // Elide identity zero-extend (source already the target width)
        if (srcWidth == dstWidth)
            return formatExpressionWithPrec(movzx.getSrc(), parentPrec);
        // Elide zero-extend consumed only by matching-width stores/assigns
        if (isCastRedundant(movzx.getSrc().getType(),
                            movzx.getResult().getType(),
                            movzx.getResult()))
            return formatExpressionWithPrec(movzx.getSrc(), parentPrec);
        std::string typeStr;
        switch (dstWidth) {
        case 8:  typeStr = "uint8_t"; break;
        case 16: typeStr = "uint16_t"; break;
        case 32: typeStr = "uint32_t"; break;
        case 64: typeStr = "uint64_t"; break;
        default: typeStr = std::format("uint{}_t", dstWidth); break;
        }
        auto castR = std::format("({}){}", typeStr, formatExpressionWithPrec(movzx.getSrc(), kPrecUnary));
        if (kPrecUnary < parentPrec) castR = "(" + castR + ")";
        return castR;
    }

    if (auto movsx = dyn_cast<helix::low::MovSxOp>(defOp)) {
        unsigned dstWidth = movsx.getDstWidth();
        unsigned srcWidth = getIntBitWidth(movsx.getSrc().getType());
        // Elide identity sign-extend (source already the target width)
        if (srcWidth == dstWidth)
            return formatExpressionWithPrec(movsx.getSrc(), parentPrec);
        // Elide sign-extend consumed only by matching-width stores/assigns
        if (isCastRedundant(movsx.getSrc().getType(),
                            movsx.getResult().getType(),
                            movsx.getResult()))
            return formatExpressionWithPrec(movsx.getSrc(), parentPrec);
        std::string typeStr;
        switch (dstWidth) {
        case 8:  typeStr = "int8_t"; break;
        case 16: typeStr = "int16_t"; break;
        case 32: typeStr = "int32_t"; break;
        case 64: typeStr = "int64_t"; break;
        default: typeStr = std::format("int{}_t", dstWidth); break;
        }
        auto castR = std::format("({}){}", typeStr, formatExpressionWithPrec(movsx.getSrc(), kPrecUnary));
        if (kPrecUnary < parentPrec) castR = "(" + castR + ")";
        return castR;
    }

    // ─── HelixLow: Pop (value from stack) ───────────────────────────────
    if (isa<helix::low::PopOp>(defOp)) {
        return "pop()";
    }

    if (auto lea = dyn_cast<helix::low::LeaOp>(defOp)) {
        auto disp = lea.getDisplacement();
        if (disp != 0) {
            auto r = std::format("{} + {}",
                formatExpressionWithPrec(lea.getBase(), kPrecAdd),
                formatIntLiteral(disp));
            if (kPrecAdd < parentPrec) r = "(" + r + ")";
            return r;
        }
        return formatExpressionWithPrec(lea.getBase(), parentPrec);
    }

    // ═════════════════════════════════════════════════════════════════════
    // LLVM Dialect expressions (ops that survived RemillToHelixLow)
    // ═════════════════════════════════════════════════════════════════════

    // ─── Constants ──────────────────────────────────────────────────────
    if (auto constOp = dyn_cast<LLVM::ConstantOp>(defOp)) {
        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
            return formatIntLiteral(intAttr.getInt());
        if (auto floatAttr = dyn_cast<FloatAttr>(constOp.getValue()))
            return std::format("{:.6g}", floatAttr.getValueAsDouble());
        return "/* const */";
    }

    if (isa<LLVM::UndefOp>(defOp))
        return "__undef";

    // ─── Binary arithmetic ──────────────────────────────────────────────
    if (auto op = dyn_cast<LLVM::AddOp>(defOp)) {
        auto lhsStr = formatExpressionWithPrec(op.getLhs(), kPrecAdd);
        auto rhsStr = formatExpressionWithPrec(op.getRhs(), kPrecAdd + 1);

        if (auto lhs = parseFormattedIntegerLiteral(lhsStr)) {
            if (auto rhs = parseFormattedIntegerLiteral(rhsStr))
                return formatIntLiteral(*lhs + *rhs);
        }

        // ─── x86 Segment Base Simplification (flat model) ─────────────
        {
            auto isSegBase = [](const std::string& s) {
                return s.find("NULL + 0") != std::string::npos ||
                       (s.find("NULL") == 0 && s.size() == 4) ||
                       s == "*(int64_t)(0)" || s == "*(int32_t)(0)" ||
                       s == "(*(int64_t)(0))" || s == "(*(int32_t)(0))" ||
                       s == "(*(int64_t)((NULL + 0)))" ||
                       s.find("*(int64_t)((NULL") != std::string::npos ||
                       s == "0" || s == "*(int64_t)(NULL)" || s == "*(NULL)";
            };
            if (isSegBase(rhsStr)) return lhsStr;
            if (isSegBase(lhsStr)) return rhsStr;
        }

        // ─── Segment Register Awareness ─────────────────────────────────
        if (lhsStr == "*(int64_t)(NULL)" || lhsStr == "*(NULL)") {
            std::string hexOffset = rhsStr;
            if (!hexOffset.starts_with("0x")) {
                try { hexOffset = std::format("0x{:x}", std::stoull(hexOffset)); } catch(...) {}
            }
            return std::format("__readgsqword({})", hexOffset);
        }

        // ─── Automatic Struct Field Recovery ────────────────────────────
        if (lhsStr.find(' ') == std::string::npos &&
            lhsStr.find('(') == std::string::npos &&
            !containsSyntheticValueIdentifier(lhsStr) &&
            looksLikeStructBaseIdentifier(lhsStr)) {
            if (rhsStr.starts_with("0x") || (rhsStr.find_first_not_of("0123456789") == std::string::npos)) {
                if (lhsStr != "rsp" && lhsStr != "rbp") { // Don't turn stack pointers into structs
                    std::string hexOffset = rhsStr;
                    if (!hexOffset.starts_with("0x")) {
                        try { hexOffset = std::format("0x{:x}", std::stoull(hexOffset)); } catch(...) {}
                    }
                    return std::format("&{}->field_{}", lhsStr, hexOffset);
                }
            }
        }
        {
            auto r = std::format("{} + {}", lhsStr, rhsStr);
            if (kPrecAdd < parentPrec) r = "(" + r + ")";
            return r;
        }
    }

    if (auto op = dyn_cast<LLVM::SubOp>(defOp)) {
        auto lhsStr = formatExpressionWithPrec(op.getLhs(), kPrecAdd);
        auto rhsStr = formatExpressionWithPrec(op.getRhs(), kPrecAdd + 1);
        if (auto lhs = parseFormattedIntegerLiteral(lhsStr)) {
            if (auto rhs = parseFormattedIntegerLiteral(rhsStr))
                return formatIntLiteral(*lhs - *rhs);
        }
        auto r = std::format("{} - {}", lhsStr, rhsStr);
        if (kPrecAdd < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<LLVM::MulOp>(defOp)) {
        auto lhsStr = formatExpressionWithPrec(op.getLhs(), kPrecMul);
        auto rhsStr = formatExpressionWithPrec(op.getRhs(), kPrecMul + 1);

        // ─── Hash Function Inlining ─────────────────────────────────────
        if (rhsStr == "0x8001" || rhsStr == "32769") {
            std::string x = lhsStr;
            if (x.starts_with("(int64_t)(")) x = x.substr(10, x.size() - 11);
            else if (x.starts_with("(uint64_t)(")) x = x.substr(11, x.size() - 12);
            return std::format("HASH({})", x);
        }

        auto r = std::format("{} * {}", lhsStr, rhsStr);
        if (kPrecMul < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<LLVM::UDivOp>(defOp)) {
        auto r = std::format("(uint64_t){} / (uint64_t){}",
            formatExpressionWithPrec(op.getLhs(), kPrecUnary), formatExpressionWithPrec(op.getRhs(), kPrecUnary));
        if (kPrecMul < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<LLVM::SDivOp>(defOp)) {
        auto r = std::format("{} / {}",
            formatExpressionWithPrec(op.getLhs(), kPrecMul), formatExpressionWithPrec(op.getRhs(), kPrecMul + 1));
        if (kPrecMul < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<LLVM::URemOp>(defOp)) {
        auto r = std::format("(uint64_t){} % (uint64_t){}",
            formatExpressionWithPrec(op.getLhs(), kPrecUnary), formatExpressionWithPrec(op.getRhs(), kPrecUnary));
        if (kPrecMul < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<LLVM::SRemOp>(defOp)) {
        auto r = std::format("{} % {}",
            formatExpressionWithPrec(op.getLhs(), kPrecMul), formatExpressionWithPrec(op.getRhs(), kPrecMul + 1));
        if (kPrecMul < parentPrec) r = "(" + r + ")";
        return r;
    }

    // ─── Bitwise operations ─────────────────────────────────────────────
    if (auto op = dyn_cast<LLVM::AndOp>(defOp)) {
        auto r = std::format("{} & {}",
            formatExpressionWithPrec(op.getLhs(), kPrecBitAnd), formatExpressionWithPrec(op.getRhs(), kPrecBitAnd + 1));
        if (kPrecBitAnd < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<LLVM::OrOp>(defOp)) {
        auto r = std::format("{} | {}",
            formatExpressionWithPrec(op.getLhs(), kPrecBitOr), formatExpressionWithPrec(op.getRhs(), kPrecBitOr + 1));
        if (kPrecBitOr < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<LLVM::XOrOp>(defOp)) {
        auto r = std::format("{} ^ {}",
            formatExpressionWithPrec(op.getLhs(), kPrecBitXor), formatExpressionWithPrec(op.getRhs(), kPrecBitXor + 1));
        if (kPrecBitXor < parentPrec) r = "(" + r + ")";
        return r;
    }

    // ─── Shifts ─────────────────────────────────────────────────────────
    if (auto op = dyn_cast<LLVM::ShlOp>(defOp)) {
        auto r = std::format("{} << {}",
            formatExpressionWithPrec(op.getLhs(), kPrecShift), formatExpressionWithPrec(op.getRhs(), kPrecShift + 1));
        if (kPrecShift < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<LLVM::LShrOp>(defOp)) {
        auto r = std::format("{} >> {}",
            formatExpressionWithPrec(op.getLhs(), kPrecShift), formatExpressionWithPrec(op.getRhs(), kPrecShift + 1));
        if (kPrecShift < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<LLVM::AShrOp>(defOp)) {
        auto r = std::format("(int64_t){} >> {}",
            formatExpressionWithPrec(op.getLhs(), kPrecUnary), formatExpressionWithPrec(op.getRhs(), kPrecShift + 1));
        if (kPrecShift < parentPrec) r = "(" + r + ")";
        return r;
    }

    // ─── Comparison ─────────────────────────────────────────────────────
    if (auto icmp = dyn_cast<LLVM::ICmpOp>(defOp)) {
        std::string cmpStr;
        int cmpPrec = kPrecRelational;
        switch (icmp.getPredicate()) {
        case LLVM::ICmpPredicate::eq:  cmpStr = "=="; cmpPrec = kPrecEqual; break;
        case LLVM::ICmpPredicate::ne:  cmpStr = "!="; cmpPrec = kPrecEqual; break;
        case LLVM::ICmpPredicate::slt: cmpStr = "<"; break;
        case LLVM::ICmpPredicate::sle: cmpStr = "<="; break;
        case LLVM::ICmpPredicate::sgt: cmpStr = ">"; break;
        case LLVM::ICmpPredicate::sge: cmpStr = ">="; break;
        case LLVM::ICmpPredicate::ult: cmpStr = "<"; break;
        case LLVM::ICmpPredicate::ule: cmpStr = "<="; break;
        case LLVM::ICmpPredicate::ugt: cmpStr = ">"; break;
        case LLVM::ICmpPredicate::uge: cmpStr = ">="; break;
        }
        auto r = std::format("{} {} {}",
            formatExpressionWithPrec(icmp.getLhs(), cmpPrec),
            cmpStr,
            formatExpressionWithPrec(icmp.getRhs(), cmpPrec + 1));
        if (cmpPrec < parentPrec) r = "(" + r + ")";
        return r;
    }

    // ─── Select (ternary) ───────────────────────────────────────────────
    if (auto sel = dyn_cast<LLVM::SelectOp>(defOp)) {
        auto r = std::format("{} ? {} : {}",
            formatExpressionWithPrec(sel.getCondition(), kPrecTernary + 1),
            formatExpressionWithPrec(sel.getTrueValue(), 0),
            formatExpressionWithPrec(sel.getFalseValue(), kPrecTernary));
        if (kPrecTernary < parentPrec) r = "(" + r + ")";
        return r;
    }

    // ─── Integer casts ──────────────────────────────────────────────────
    // Eliminate redundant casts: (int64_t)(expr) when expr is already 64-bit,
    // and (int64_t)((int32_t)(x)) → just (int32_t)(x) if widening back.
    if (auto op = dyn_cast<LLVM::ZExtOp>(defOp)) {
        if (op.getArg().getType() == op.getResult().getType())
            return formatExpressionWithPrec(op.getArg(), parentPrec);
        if (isCastRedundant(op.getArg().getType(), op.getResult().getType(), op.getResult()))
            return formatExpressionWithPrec(op.getArg(), parentPrec);
        auto inner = formatExpressionWithPrec(op.getArg(), 0);
        auto targetType = formatType(op.getResult().getType());
        // Skip (int64_t) wrapping of memory reads / dereferences — already 64-bit semantically
        if (targetType == "int64_t" &&
            (inner.starts_with("(*") || inner.starts_with("*") ||
             inner.starts_with("g_") || inner.find("->") != std::string::npos))
            return inner;
        auto castR = std::format("({})({})", targetType, inner);
        if (kPrecUnary < parentPrec) castR = "(" + castR + ")";
        return castR;
    }

    if (auto op = dyn_cast<LLVM::SExtOp>(defOp)) {
        if (op.getArg().getType() == op.getResult().getType())
            return formatExpressionWithPrec(op.getArg(), parentPrec);
        if (isCastRedundant(op.getArg().getType(), op.getResult().getType(), op.getResult()))
            return formatExpressionWithPrec(op.getArg(), parentPrec);
        auto inner = formatExpressionWithPrec(op.getArg(), 0);
        auto targetType = formatType(op.getResult().getType());
        if (targetType == "int64_t" &&
            (inner.starts_with("(*") || inner.starts_with("*") ||
             inner.starts_with("g_") || inner.find("->") != std::string::npos))
            return inner;
        auto castR = std::format("({})({})", targetType, inner);
        if (kPrecUnary < parentPrec) castR = "(" + castR + ")";
        return castR;
    }

    if (auto op = dyn_cast<LLVM::TruncOp>(defOp)) {
        if (op.getArg().getType() == op.getResult().getType())
            return formatExpressionWithPrec(op.getArg(), parentPrec);
        if (isCastRedundant(op.getArg().getType(), op.getResult().getType(), op.getResult()))
            return formatExpressionWithPrec(op.getArg(), parentPrec);
        auto castR = std::format("({})({})",
            formatType(op.getResult().getType()),
            formatExpressionWithPrec(op.getArg(), 0));
        if (kPrecUnary < parentPrec) castR = "(" + castR + ")";
        return castR;
    }

    // ─── Pointer casts ──────────────────────────────────────────────────
    if (auto op = dyn_cast<LLVM::PtrToIntOp>(defOp)) {
        auto castR = std::format("(int64_t)({})", formatExpressionWithPrec(op.getArg(), 0));
        if (kPrecUnary < parentPrec) castR = "(" + castR + ")";
        return castR;
    }

    if (auto op = dyn_cast<LLVM::IntToPtrOp>(defOp)) {
        auto expr = formatExpressionWithPrec(op.getArg(), 0);
        if (expr == "0") return "NULL";
        auto castR = std::format("(void*)({})", expr);
        if (kPrecUnary < parentPrec) castR = "(" + castR + ")";
        return castR;
    }

    // ─── Memory load ────────────────────────────────────────────────────
    if (auto load = dyn_cast<LLVM::LoadOp>(defOp)) {
        if (auto paramIndex = inferWin64StackParamIndex(load.getOperation(),
                                                        load.getAddr());
            paramIndex && *paramIndex <= currentWin64StackParamLimit_)
            return applyNameAliases(std::format("param_{}", *paramIndex));
        auto addrStr = formatExpressionWithPrec(load.getAddr(), 0);
        // x86-32 flat model: *(NULL) is segment base = 0
        if (addrStr == "NULL" || addrStr == "(void*)(0)")
            return "0";
        return std::format("*({})", addrStr);
    }

    // ─── Function call (expression context — has return value) ──────────
    if (auto call = dyn_cast<LLVM::CallOp>(defOp)) {
        // LLVM::CallOp results that survived the pipeline are typically
        // Remill semantic calls whose results are referenced by other
        // moved LLVM ops. Try to demangle and emit a clean name.
        std::string result;
        if (auto callee = call.getCallee()) {
            auto name = callee->str();
            // Try to demangle Remill semantic names for cleaner output.
            auto semInfo = helix::demangleRemillSemantic(name);
            if (semInfo && !semInfo->raw_name.empty()) {
                // Use the demangled semantic name (e.g., "CALL", "MOV")
                result = semInfo->raw_name;
            } else if (name.starts_with("_Z")) {
                // Unrecognized mangled name — use a placeholder
                result = "/* mangled */";
            } else {
                result = name;
            }
        } else {
            result = "/* indirect */";
        }
        result += "(";
        for (unsigned i = 0; i < call.getNumOperands(); i++) {
            if (i > 0) result += ", ";
            result += formatExpressionWithPrec(call.getOperand(i), 0);
        }
        result += ")";
        return result;
    }

    // ─── GEP (pointer arithmetic) ───────────────────────────────────────
    if (auto gep = dyn_cast<LLVM::GEPOp>(defOp)) {
        auto base = formatExpressionWithPrec(gep.getBase(), 0);
        auto dynIndices = gep.getDynamicIndices();
        if (dynIndices.empty())
            return base;

        // ─── x86 Segment Base Simplification (flat model) ─────────────
        if (dynIndices.size() == 1) {
            auto isSegBase = [](const std::string& s) {
                return s.find("NULL + 0") != std::string::npos ||
                       (s.find("NULL") == 0 && s.size() == 4) ||
                       s == "*(int64_t)(0)" || s == "*(int32_t)(0)" ||
                       s == "(*(int64_t)(0))" || s == "(*(int32_t)(0))" ||
                       s == "(*(int64_t)((NULL + 0)))" ||
                       s.find("*(int64_t)((NULL") != std::string::npos ||
                       s == "0" || s == "*(int64_t)(NULL)" || s == "*(NULL)";
            };
            auto idxStr = formatExpressionWithPrec(dynIndices[0], 0);
            if (isSegBase(base)) return idxStr;
            if (isSegBase(idxStr)) return base;
        }

        // ─── Segment Register Awareness ─────────────────────────────────
        if (dynIndices.size() == 1 && (base == "*(int64_t)(NULL)" || base == "*(NULL)")) {
            std::string hexOffset = formatExpressionWithPrec(dynIndices[0], 0);
            if (!hexOffset.starts_with("0x")) {
                try { hexOffset = std::format("0x{:x}", std::stoull(hexOffset)); } catch(...) {}
            }
            return std::format("__readgsqword({})", hexOffset);
        }

        // TLS folding
        auto hasTlsBase = [](const std::string& s) {
            return s.find("__readgsqword(0x58)") != std::string::npos || s.find("&__local") != std::string::npos;
        };
        if (hasTlsBase(base) && dynIndices.size() == 1) {
            auto rhsStr = formatExpressionWithPrec(dynIndices[0], 0);
            try {
                uint64_t offset = 0;
                if (rhsStr.starts_with("0x") || rhsStr.starts_with("0X")) offset = std::stoull(rhsStr.substr(2), nullptr, 16);
                else offset = std::stoull(rhsStr, nullptr, 10);
                uint64_t addr = 0x140000000ULL + offset;
                return std::format("0x{:x}", addr);
            } catch(...) {}
        }

        // ─── Automatic Struct Field Recovery ────────────────────────────
        if (dynIndices.size() == 1) {
            auto rhsStr = formatExpressionWithPrec(dynIndices[0], 0);
            if (base.find(' ') == std::string::npos &&
                base.find('(') == std::string::npos &&
                !containsSyntheticValueIdentifier(base) &&
                looksLikeStructBaseIdentifier(base)) {
                if (rhsStr.starts_with("0x") || (rhsStr.find_first_not_of("0123456789") == std::string::npos)) {
                    if (base != "rsp" && base != "rbp") { // Don't turn stack pointers into structs
                        std::string hexOffset = rhsStr;
                        if (!hexOffset.starts_with("0x")) {
                            try { hexOffset = std::format("0x{:x}", std::stoull(hexOffset)); } catch(...) {}
                        }
                        return std::format("&{}->field_{}", base, hexOffset);
                    }
                }
            }
        }

        // General case: base + indices
        {
            auto r = formatExpressionWithPrec(gep.getBase(), kPrecAdd);
            for (auto idx : dynIndices)
                r += " + " + formatExpressionWithPrec(idx, kPrecAdd + 1);
            if (kPrecAdd < parentPrec) r = "(" + r + ")";
            return r;
        }
    }

    // ─── ExtractValue (aggregate member access) ─────────────────────────
    if (auto ev = dyn_cast<LLVM::ExtractValueOp>(defOp)) {
        auto pos = ev.getPosition();
        std::string result = formatExpressionWithPrec(ev.getContainer(), kPrecAtom);
        for (auto idx : pos)
            result += std::format(".field{}", idx);
        return result;
    }

    // ─── Alloca (stack variable pointer) ────────────────────────────────
    if (isa<LLVM::AllocaOp>(defOp))
        return "__readgsqword(0x58)";

    // ═════════════════════════════════════════════════════════════════════
    // Arith Dialect expressions (from RecoverVariables, StructureControlFlow)
    // ═════════════════════════════════════════════════════════════════════

    if (auto constOp = dyn_cast<arith::ConstantOp>(defOp)) {
        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
            return formatIntLiteral(intAttr.getInt());
        if (auto floatAttr = dyn_cast<FloatAttr>(constOp.getValue()))
            return std::format("{:.6g}", floatAttr.getValueAsDouble());
        return "/* const */";
    }

    if (auto op = dyn_cast<arith::AddIOp>(defOp)) {
        auto lhsStr = formatExpressionWithPrec(op.getLhs(), kPrecAdd);
        auto rhsStr = formatExpressionWithPrec(op.getRhs(), kPrecAdd + 1);

        // ─── x86 Segment Base Simplification (flat model) ─────────────
        {
            auto isSegBase = [](const std::string& s) {
                return s.find("NULL + 0") != std::string::npos ||
                       (s.find("NULL") == 0 && s.size() == 4) ||
                       s == "*(int64_t)(0)" || s == "*(int32_t)(0)" ||
                       s == "(*(int64_t)(0))" || s == "(*(int32_t)(0))" ||
                       s == "(*(int64_t)((NULL + 0)))" ||
                       s.find("*(int64_t)((NULL") != std::string::npos ||
                       s == "0" || s == "*(int64_t)(NULL)" || s == "*(NULL)";
            };
            if (isSegBase(rhsStr)) return lhsStr;
            if (isSegBase(lhsStr)) return rhsStr;
        }

        // ─── Segment Register Awareness ─────────────────────────────────
        if (lhsStr == "*(int64_t)(NULL)" || lhsStr == "*(NULL)") {
            std::string hexOffset = rhsStr;
            if (!hexOffset.starts_with("0x")) {
                try { hexOffset = std::format("0x{:x}", std::stoull(hexOffset)); } catch(...) {}
            }
            return std::format("__readgsqword({})", hexOffset);
        }

        auto hasTlsBase = [](const std::string& s) {
            return s.find("__readgsqword(0x58)") != std::string::npos || s.find("&__local") != std::string::npos;
        };
        if (hasTlsBase(lhsStr)) {
            try {
                uint64_t offset = 0;
                if (rhsStr.starts_with("0x") || rhsStr.starts_with("0X")) offset = std::stoull(rhsStr.substr(2), nullptr, 16);
                else offset = std::stoull(rhsStr, nullptr, 10);
                uint64_t addr = 0x140000000ULL + offset;
                return std::format("0x{:x}", addr);
            } catch(...) {}
        }

        // ─── Automatic Struct Field Recovery ────────────────────────────
        if (lhsStr.find(' ') == std::string::npos &&
            lhsStr.find('(') == std::string::npos &&
            !containsSyntheticValueIdentifier(lhsStr) &&
            looksLikeStructBaseIdentifier(lhsStr)) {
            if (rhsStr.starts_with("0x") || (rhsStr.find_first_not_of("0123456789") == std::string::npos)) {
                if (lhsStr != "rsp" && lhsStr != "rbp") { // Don't turn stack pointers into structs
                    std::string hexOffset = rhsStr;
                    if (!hexOffset.starts_with("0x")) {
                        try { hexOffset = std::format("0x{:x}", std::stoull(hexOffset)); } catch(...) {}
                    }
                    return std::format("&{}->field_{}", lhsStr, hexOffset);
                }
            }
        }

        {
            auto r = std::format("{} + {}", lhsStr, rhsStr);
            if (kPrecAdd < parentPrec) r = "(" + r + ")";
            return r;
        }
    }

    if (auto op = dyn_cast<arith::SubIOp>(defOp)) {
        auto lhsStr = formatExpressionWithPrec(op.getLhs(), kPrecAdd);
        auto rhsStr = formatExpressionWithPrec(op.getRhs(), kPrecAdd + 1);

        auto hasTlsBase = [](const std::string& s) {
            return s.find("__readgsqword(0x58)") != std::string::npos || s.find("&__local") != std::string::npos;
        };
        if (hasTlsBase(lhsStr)) {
            try {
                uint64_t offset = 0;
                if (rhsStr.starts_with("0x") || rhsStr.starts_with("0X")) offset = std::stoull(rhsStr.substr(2), nullptr, 16);
                else offset = std::stoull(rhsStr, nullptr, 10);
                uint64_t addr = 0x140000000ULL - offset;
                return std::format("0x{:x}", addr);
            } catch(...) {}
        }
        auto r = std::format("{} - {}", lhsStr, rhsStr);
        if (kPrecAdd < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::MulIOp>(defOp)) {
        auto lhsStr = formatExpressionWithPrec(op.getLhs(), kPrecMul);
        auto rhsStr = formatExpressionWithPrec(op.getRhs(), kPrecMul + 1);

        // ─── Hash Function Inlining ─────────────────────────────────────
        if (rhsStr == "0x8001" || rhsStr == "32769") {
            std::string x = lhsStr;
            if (x.starts_with("(int64_t)(")) x = x.substr(10, x.size() - 11);
            else if (x.starts_with("(uint64_t)(")) x = x.substr(11, x.size() - 12);
            return std::format("HASH({})", x);
        }

        auto r = std::format("{} * {}", lhsStr, rhsStr);
        if (kPrecMul < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::DivSIOp>(defOp)) {
        auto r = std::format("{} / {}",
            formatExpressionWithPrec(op.getLhs(), kPrecMul), formatExpressionWithPrec(op.getRhs(), kPrecMul + 1));
        if (kPrecMul < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::DivUIOp>(defOp)) {
        auto r = std::format("(uint64_t){} / (uint64_t){}",
            formatExpressionWithPrec(op.getLhs(), kPrecUnary), formatExpressionWithPrec(op.getRhs(), kPrecUnary));
        if (kPrecMul < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::RemSIOp>(defOp)) {
        auto r = std::format("{} % {}",
            formatExpressionWithPrec(op.getLhs(), kPrecMul), formatExpressionWithPrec(op.getRhs(), kPrecMul + 1));
        if (kPrecMul < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::RemUIOp>(defOp)) {
        auto r = std::format("(uint64_t){} % (uint64_t){}",
            formatExpressionWithPrec(op.getLhs(), kPrecUnary), formatExpressionWithPrec(op.getRhs(), kPrecUnary));
        if (kPrecMul < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::AndIOp>(defOp)) {
        auto r = std::format("{} & {}",
            formatExpressionWithPrec(op.getLhs(), kPrecBitAnd), formatExpressionWithPrec(op.getRhs(), kPrecBitAnd + 1));
        if (kPrecBitAnd < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::OrIOp>(defOp)) {
        auto r = std::format("{} | {}",
            formatExpressionWithPrec(op.getLhs(), kPrecBitOr), formatExpressionWithPrec(op.getRhs(), kPrecBitOr + 1));
        if (kPrecBitOr < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::XOrIOp>(defOp)) {
        auto lhsSrc = findFlagSource(op.getLhs());
        auto rhsSrc = findFlagSource(op.getRhs());
        if (lhsSrc.flagIndex == 2 && rhsSrc.flagIndex == 3 &&
            lhsSrc.cmpOrTest == rhsSrc.cmpOrTest) {
            if (auto cmpStr = formatSignedCompareFromFlagSource(
                    lhsSrc, "<", this)) {
                return *cmpStr;
            }
        }
        if (rhsSrc.flagIndex == 2 && lhsSrc.flagIndex == 3 &&
            lhsSrc.cmpOrTest == rhsSrc.cmpOrTest) {
            if (auto cmpStr = formatSignedCompareFromFlagSource(
                    rhsSrc, "<", this)) {
                return *cmpStr;
            }
        }

        if (isLogicalNegationConstant(op.getLhs())) {
            auto r = std::format("!{}", formatExpressionWithPrec(op.getRhs(), kPrecUnary));
            if (kPrecUnary < parentPrec) r = "(" + r + ")";
            return r;
        }
        if (isLogicalNegationConstant(op.getRhs())) {
            auto r = std::format("!{}", formatExpressionWithPrec(op.getLhs(), kPrecUnary));
            if (kPrecUnary < parentPrec) r = "(" + r + ")";
            return r;
        }

        auto r = std::format("{} ^ {}",
            formatExpressionWithPrec(op.getLhs(), kPrecBitXor), formatExpressionWithPrec(op.getRhs(), kPrecBitXor + 1));
        if (kPrecBitXor < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::ShLIOp>(defOp)) {
        auto r = std::format("{} << {}",
            formatExpressionWithPrec(op.getLhs(), kPrecShift), formatExpressionWithPrec(op.getRhs(), kPrecShift + 1));
        if (kPrecShift < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::ShRUIOp>(defOp)) {
        auto r = std::format("{} >> {}",
            formatExpressionWithPrec(op.getLhs(), kPrecShift), formatExpressionWithPrec(op.getRhs(), kPrecShift + 1));
        if (kPrecShift < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::ShRSIOp>(defOp)) {
        auto r = std::format("(int64_t){} >> {}",
            formatExpressionWithPrec(op.getLhs(), kPrecUnary), formatExpressionWithPrec(op.getRhs(), kPrecShift + 1));
        if (kPrecShift < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto icmp = dyn_cast<arith::CmpIOp>(defOp)) {
        std::string cmpStr;
        int cmpPrec = kPrecRelational;
        switch (icmp.getPredicate()) {
        case arith::CmpIPredicate::eq:  cmpStr = "=="; cmpPrec = kPrecEqual; break;
        case arith::CmpIPredicate::ne:  cmpStr = "!="; cmpPrec = kPrecEqual; break;
        case arith::CmpIPredicate::slt: cmpStr = "<"; break;
        case arith::CmpIPredicate::sle: cmpStr = "<="; break;
        case arith::CmpIPredicate::sgt: cmpStr = ">"; break;
        case arith::CmpIPredicate::sge: cmpStr = ">="; break;
        case arith::CmpIPredicate::ult: cmpStr = "<"; break;
        case arith::CmpIPredicate::ule: cmpStr = "<="; break;
        case arith::CmpIPredicate::ugt: cmpStr = ">"; break;
        case arith::CmpIPredicate::uge: cmpStr = ">="; break;
        }
        auto r = std::format("{} {} {}",
            formatExpressionWithPrec(icmp.getLhs(), cmpPrec),
            cmpStr,
            formatExpressionWithPrec(icmp.getRhs(), cmpPrec + 1));
        if (cmpPrec < parentPrec) r = "(" + r + ")";
        return r;
    }

    if (auto op = dyn_cast<arith::ExtUIOp>(defOp)) {
        if (isCastRedundant(op.getIn().getType(), op.getResult().getType(), op.getResult()))
            return formatExpressionWithPrec(op.getIn(), parentPrec);
        auto castR = std::format("({})({})",
            formatType(op.getResult().getType()),
            formatExpressionWithPrec(op.getIn(), 0));
        if (kPrecUnary < parentPrec) castR = "(" + castR + ")";
        return castR;
    }

    if (auto op = dyn_cast<arith::ExtSIOp>(defOp)) {
        if (isCastRedundant(op.getIn().getType(), op.getResult().getType(), op.getResult()))
            return formatExpressionWithPrec(op.getIn(), parentPrec);
        auto castR = std::format("({})({})",
            formatType(op.getResult().getType()),
            formatExpressionWithPrec(op.getIn(), 0));
        if (kPrecUnary < parentPrec) castR = "(" + castR + ")";
        return castR;
    }

    if (auto op = dyn_cast<arith::TruncIOp>(defOp)) {
        if (isCastRedundant(op.getIn().getType(), op.getResult().getType(), op.getResult()))
            return formatExpressionWithPrec(op.getIn(), parentPrec);
        auto castR = std::format("({})({})",
            formatType(op.getResult().getType()),
            formatExpressionWithPrec(op.getIn(), 0));
        if (kPrecUnary < parentPrec) castR = "(" + castR + ")";
        return castR;
    }

    if (auto sel = dyn_cast<arith::SelectOp>(defOp)) {
        auto r = std::format("{} ? {} : {}",
            formatExpressionWithPrec(sel.getCondition(), kPrecTernary + 1),
            formatExpressionWithPrec(sel.getTrueValue(), 0),
            formatExpressionWithPrec(sel.getFalseValue(), kPrecTernary));
        if (kPrecTernary < parentPrec) r = "(" + r + ")";
        return r;
    }

    // ═════════════════════════════════════════════════════════════════════
    // Fallback: show the MLIR op name and its operand expressions
    // ═════════════════════════════════════════════════════════════════════

    std::string fallback = "/* " + defOp->getName().getStringRef().str();
    for (unsigned i = 0; i < defOp->getNumOperands() && i < 4; i++) {
        fallback += (i == 0 ? " " : ", ");
        fallback += formatExpressionWithPrec(defOp->getOperand(i), 0);
    }
    if (defOp->getNumOperands() > 4)
        fallback += ", ...";
    fallback += " */";
    return fallback;
}

std::string PseudoCEmitter::formatType(Type type) {
    if (auto intTy = dyn_cast<IntegerType>(type)) {
        unsigned width = intTy.getWidth();
        switch (width) {
        case 1:  return "bool";
        case 8:  return "int8_t";
        case 16: return "int16_t";
        case 32: return "int32_t";
        case 64: return "int64_t";
        default: return std::format("int{}_t", width);
        }
    }
    if (isa<Float32Type>(type))
        return "float";
    if (isa<Float64Type>(type))
        return "double";
    if (isa<LLVM::LLVMPointerType>(type))
        return "void*";
    return "void";
}

// ═══════════════════════════════════════════════════════════════════════════════
// Cast Elimination Helpers
// ═══════════════════════════════════════════════════════════════════════════════

unsigned PseudoCEmitter::getIntBitWidth(Type type) {
    if (auto intTy = dyn_cast<IntegerType>(type))
        return intTy.getWidth();
    return 0;
}

bool PseudoCEmitter::isCastRedundant(Type srcType, Type dstType,
                                      Value castResult) const {
    if (isa<LLVM::LLVMPointerType>(srcType) || isa<LLVM::LLVMPointerType>(dstType))
        return false;
    if (isa<FloatType>(srcType) != isa<FloatType>(dstType))
        return false;
    if (srcType == dstType)
        return true;
    unsigned srcWidth = getIntBitWidth(srcType);
    unsigned dstWidth = getIntBitWidth(dstType);
    if (srcWidth == 0 || dstWidth == 0)
        return false;

    // Same-width signedness cast: elide unless used in ordered comparison.
    if (srcWidth == dstWidth) {
        for (auto* user : castResult.getUsers()) {
            if (auto binOp = dyn_cast<helix::high::BinaryOp>(user)) {
                auto kind = binOp.getOp();
                if (kind == helix::high::BinaryOpKind::Lt || kind == helix::high::BinaryOpKind::Le ||
                    kind == helix::high::BinaryOpKind::Gt || kind == helix::high::BinaryOpKind::Ge)
                    return false;
            }
            if (auto midBin = dyn_cast<helix::mid::BinExprOp>(user)) {
                auto kind = midBin.getKind();
                if (kind == helix::mid::BinExprKind::Lt || kind == helix::mid::BinExprKind::Le ||
                    kind == helix::mid::BinExprKind::Gt || kind == helix::mid::BinExprKind::Ge)
                    return false;
            }
            if (isa<helix::low::CmpOp>(user))
                return false;
        }
        return true;
    }

    // Widening cast consumed only by matching-width stores/assigns.
    if (dstWidth > srcWidth) {
        bool allMatch = true, hasUsers = false;
        for (auto* user : castResult.getUsers()) {
            hasUsers = true;
            if (auto a = dyn_cast<helix::high::AssignOp>(user))
                { if (getIntBitWidth(a.getTarget().getType()) != dstWidth) { allMatch = false; break; } continue; }
            if (auto a = dyn_cast<helix::mid::AssignOp>(user))
                { if (getIntBitWidth(a.getValue().getType()) != dstWidth) { allMatch = false; break; } continue; }
            if (auto s = dyn_cast<helix::mid::StoreOp>(user))
                { if (getIntBitWidth(s.getValue().getType()) != dstWidth) { allMatch = false; break; } continue; }
            if (isa<helix::low::RegWriteOp>(user)) continue;
            allMatch = false; break;
        }
        if (hasUsers && allMatch) return true;
    }

    // Narrowing cast consumed only by matching-width stores/assigns.
    if (dstWidth < srcWidth) {
        bool allMatch = true, hasUsers = false;
        for (auto* user : castResult.getUsers()) {
            hasUsers = true;
            if (auto a = dyn_cast<helix::high::AssignOp>(user))
                { if (getIntBitWidth(a.getTarget().getType()) != dstWidth) { allMatch = false; break; } continue; }
            if (auto s = dyn_cast<helix::mid::StoreOp>(user))
                { if (getIntBitWidth(s.getValue().getType()) != dstWidth) { allMatch = false; break; } continue; }
            if (auto a = dyn_cast<helix::mid::AssignOp>(user))
                { if (getIntBitWidth(a.getValue().getType()) != dstWidth) { allMatch = false; break; } continue; }
            allMatch = false; break;
        }
        if (hasUsers && allMatch) return true;
    }

    return false;
}

std::string PseudoCEmitter::formatIntLiteral(int64_t value) {
    // ─── Float Inference Heuristic ──────────────────────────────────────────
    uint64_t uval = static_cast<uint64_t>(value);
    if ((uval >> 32) == 0 || (uval >> 32) == 0xFFFFFFFF) {
        uint32_t bits = static_cast<uint32_t>(uval);
        float f;
        std::memcpy(&f, &bits, sizeof(float));
        
        int exp = (bits >> 23) & 0xFF;
        // Check for reasonable game float ranges (~ 2^-27 to 2^23)
        if (exp >= 100 && exp <= 150 && !std::isnan(f) && !std::isinf(f) && f != 0.0f) {
            bool isClean = false;
            // Case 1: Simple fractions/numbers often have 16 trailing zero bits in the mantissa 
            // (e.g., 1.0f = 0x3f800000, 1.5f = 0x3fc00000, 100.0f = 0x42c80000)
            if ((bits & 0xFFFF) == 0) isClean = true;
            // Case 2: Exact integer values
            else if (f == std::floor(f) && f >= -100000.0f && f <= 100000.0f) isClean = true;
            
            if (isClean) {
                // If it naturally prints as an integer, force a .0 so it looks like a float
                std::string fStr = std::format("{}", f);
                if (fStr.find('.') == std::string::npos) fStr += ".0";
                return fStr + "f /* " + std::format("0x{:x}", bits) + " */";
            }
        }
    }

    // ─── Regular Integer Formatting ─────────────────────────────────────────
    if (value >= 16 || value <= -16) {
        if (value < 0)
            return std::format("-0x{:x}", static_cast<uint64_t>(-value));
        return std::format("0x{:x}", static_cast<uint64_t>(value));
    }
    return std::format("{}", value);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Dead Store Elimination Pre-Scan
// ═══════════════════════════════════════════════════════════════════════════════

/// Check if an operation is a prologue/epilogue artifact that should be hidden
/// from the decompiled output.
///
/// Patterns:
///   - push(rbp), push(rdi), push(r12), etc.
///   - pop(rbp), pop(rdi), etc.
///   - rbp = rsp (frame pointer setup)
///   - rsp = rbp (frame pointer teardown)
bool PseudoCEmitter::isPrologueArtifact(Operation* op) {
    // HelixLow push/pop → always prologue/epilogue
    if (isa<helix::low::PushOp>(op) || isa<helix::low::PopOp>(op))
        return true;

    // HelixHigh ExprStmtOp wrapping push/pop
    if (auto exprStmt = dyn_cast<helix::high::ExprStmtOp>(op)) {
        auto exprStr = formatExpression(exprStmt.getExpr());
        if (exprStr.starts_with("push(") || exprStr.starts_with("pop("))
            return true;
    }

    // HelixHigh AssignOp: rbp = rsp or rsp = rbp
    if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
        auto target = formatExpression(assign.getTarget());
        auto value = formatExpression(assign.getValue());
        // Frame pointer setup: rbp = rsp
        if (target == "rbp" && value == "rsp")
            return true;
        // Frame pointer teardown: rsp = rbp
        if (target == "rsp" && value == "rbp")
            return true;

        if (isNearBlockBoundary(op)) {
            if (isStackSlotExpression(target) && isCalleeSavedRegisterName(value))
                return true;
            if (isCalleeSavedRegisterName(target) && isStackSlotExpression(value))
                return true;
        }
    }

    // HelixLow RegWriteOp: check for RBP = RSP or RSP = RBP
    if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(op)) {
        auto regName = regWrite.getRegName();
        if (regName == "RBP" || regName == "RSP") {
            auto exprStr = formatExpression(regWrite.getValue());
            if (exprStr == "rsp" || exprStr == "rbp")
                return true;
        }

        if (isNearBlockBoundary(op) &&
            isCalleeSavedRegisterName(regName.str()) &&
            isStackSlotExpression(formatExpression(regWrite.getValue()))) {
            return true;
        }
    }

    if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
        if (isNearBlockBoundary(op)) {
            auto addrStr = formatExpression(memWrite.getAddr());
            auto valueStr = formatExpression(memWrite.getValue());
            if (isStackSlotExpression(addrStr) &&
                isCalleeSavedRegisterName(valueStr)) {
                return true;
            }
            auto normalized = normalizeAddressExpression(addrStr);
            if ((normalized == "rsp+0x10" || normalized == "rsp+0x18" ||
                 normalized == "rsp+0x20") &&
                (isCalleeSavedRegisterName(valueStr) ||
                 valueStr.starts_with("param_"))) {
                return true;
            }
        }
    }

    return false;
}

/// Pre-scan a block to identify dead store assignments.
///
/// An assignment `X = expr` is a dead store if:
///   1. X is written again before any operation reads X
///   2. The expression has no side effects (no function calls)
///
/// Walk backwards through the block: maintain a set of "written-but-not-read"
/// registers. When we see a write to X:
///   - If X is already in the written set → the CURRENT write is dead
///     (it will be overwritten by the later write we already saw)
///   - Otherwise, add X to the written set
/// When we see a read of X:
///   - Remove X from the written set (it's live)
///
/// @return  Set of Operation* that are dead stores.
std::unordered_set<Operation*>
PseudoCEmitter::precomputeDeadStores(Block& block) {
    std::unordered_set<Operation*> deadOps;
    std::unordered_set<std::string> writtenNotRead;
    std::unordered_map<std::string, Operation*> pendingTailWrites;

    // Collect operation pointers for reverse iteration
    llvm::SmallVector<Operation*, 64> ops;
    for (auto& op : block.getOperations())
        ops.push_back(&op);

    // Walk backwards through ops
    for (auto it = ops.rbegin(); it != ops.rend(); ++it) {
        Operation* op = *it;

        // Skip non-assign ops for DSE (but check for reads)
        if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
            auto targetStr = formatExpression(assign.getTarget());

            // Only do DSE on simple register variables (rax, rbx, etc.)
            // Skip struct field writes, memory writes, parameters
            bool isSimpleReg = !targetStr.empty() &&
                               targetStr.find("->") == std::string::npos &&
                               targetStr.find("*(") == std::string::npos &&
                               targetStr.find("[") == std::string::npos;

            // Never DSE SIMD vector registers — consecutive writes carry offset info
            if (targetStr.starts_with("xmm") || targetStr.starts_with("ymm") ||
                targetStr.starts_with("zmm") || targetStr.starts_with("XMM") ||
                targetStr.starts_with("YMM") || targetStr.starts_with("ZMM"))
                isSimpleReg = false;

            if (isSimpleReg) {
                // Check if the RHS has side effects (function calls)
                auto exprStr = formatExpression(assign.getValue());
                bool hasSideEffects = exprStr.find("sub_") != std::string::npos ||
                                     exprStr.find("call") != std::string::npos ||
                                     exprStr.find("vfunc_") != std::string::npos ||
                                     exprStr.find("__vtable_") != std::string::npos;

                if (!hasSideEffects) {
                    if (writtenNotRead.count(targetStr)) {
                        // This write is dead — the target is overwritten later
                        // without being read in between.
                        deadOps.insert(op);

                        // IMPORTANT: since this assignment is dead, its RHS
                        // reads are also dead.  Do NOT mark RHS variables as
                        // read — that would prevent earlier dead stores to
                        // those variables from being eliminated.
                        // Example: a=x; a&=0x20; a=*p; → both first and second
                        // writes are dead. If we process &=0x20's RHS as a read,
                        // we'd keep a=x alive incorrectly.
                        continue;
                    } else {
                        // First (from the bottom) write to this target
                        writtenNotRead.insert(targetStr);
                        pendingTailWrites[targetStr] = op;
                    }
                } else {
                    // Side-effecting expression — clear target and keep alive
                    writtenNotRead.erase(targetStr);
                    pendingTailWrites.erase(targetStr);
                }
            }

            // The RHS of the assignment may READ other variables — mark them live.
            // Remove from writtenNotRead any var that appears in the RHS.
            auto exprStr2 = formatExpression(assign.getValue());
            std::vector<std::string> toRemove;
            for (auto& entry : writtenNotRead) {
                if (entry != targetStr && exprStr2.find(entry) != std::string::npos) {
                    toRemove.push_back(entry);
                }
            }
            for (auto& r : toRemove)
                writtenNotRead.erase(r);
            for (auto& r : toRemove)
                pendingTailWrites.erase(r);

            continue;
        }

        // For all other ops, check if they reference any of our tracked variables
        // (calls, memory writes, etc. → they read their operands)
        if (isa<helix::low::RetOp>(op)) {
            auto returnName = applyNameAliases(currentReturnValueName_);
            if (!returnName.empty()) {
                writtenNotRead.erase(returnName);
                pendingTailWrites.erase(returnName);
            } else {
                writtenNotRead.erase("rax");
                pendingTailWrites.erase("rax");
            }
            continue;
        }

        if (auto ret = dyn_cast<helix::high::ReturnOp>(op)) {
            auto valueStr = formatExpression(ret.getValue());
            std::vector<std::string> toRemove;
            for (auto& entry : writtenNotRead) {
                if (valueStr.find(entry) != std::string::npos)
                    toRemove.push_back(entry);
            }
            for (auto& entry : toRemove)
                writtenNotRead.erase(entry);
            for (auto& entry : toRemove)
                pendingTailWrites.erase(entry);
            continue;
        }

        if (isa<helix::low::CallOp>(op) || isa<helix::high::CallOp>(op) ||
            isa<helix::high::ExprStmtOp>(op) ||
            isa<helix::low::MemWriteOp>(op) ||
            isa<helix::high::IfOp>(op) || isa<helix::high::WhileOp>(op) ||
            isa<helix::high::DoWhileOp>(op)) {
            // Conservative: calls, memory writes, and structured control flow
            // ops might read any register → clear all tracked writes.
            writtenNotRead.clear();
            pendingTailWrites.clear();
        }
    }

    auto* terminator = block.empty() ? nullptr : block.getTerminator();
    bool blockReturns = terminator &&
        (isa<helix::low::RetOp>(terminator) || isa<helix::high::ReturnOp>(terminator));

    if (blockReturns) {
        auto returnName = applyNameAliases(currentReturnValueName_);
        for (auto& [target, writeOp] : pendingTailWrites) {
            if (!writeOp)
                continue;
            if ((!returnName.empty() && target == returnName) || target == "rax")
                continue;
            deadOps.insert(writeOp);
        }
    }

    return deadOps;
}

void PseudoCEmitter::indent(llvm::raw_ostream& os, unsigned depth) {
    for (unsigned i = 0; i < depth; i++)
        os << "    ";
}

// ═══════════════════════════════════════════════════════════════════════════════
// Debug-only output validation
// ═══════════════════════════════════════════════════════════════════════════════

#ifndef NDEBUG

/// Check whether a position in the source is inside a line comment (after //).
static bool isInsideLineComment(const std::string& source, size_t pos) {
    // Scan backwards from pos to the start of the line
    size_t lineStart = source.rfind('\n', pos);
    lineStart = (lineStart == std::string::npos) ? 0 : lineStart + 1;
    auto commentPos = source.find("//", lineStart);
    return commentPos != std::string::npos && commentPos < pos;
}

void PseudoCEmitter::validateOutput(const std::string& output) {
    // 1. Check for forbidden internal tokens
    static const char* forbiddenTokens[] = {
        "__undef", "__carry", "__overflow"
    };
    for (const char* token : forbiddenTokens) {
        size_t pos = 0;
        while ((pos = output.find(token, pos)) != std::string::npos) {
            if (!isInsideLineComment(output, pos)) {
                LLVM_DEBUG(llvm::dbgs()
                    << "PseudoCEmitter: forbidden pattern '" << token
                    << "' found in output at offset " << pos << "\n");
            }
            pos += std::strlen(token);
        }
    }

    // 2. Check for mangled Remill names
    {
        static const char* mangledPrefix = "_ZN12_GLOBAL__N_1";
        size_t pos = 0;
        while ((pos = output.find(mangledPrefix, pos)) != std::string::npos) {
            if (!isInsideLineComment(output, pos)) {
                LLVM_DEBUG(llvm::dbgs()
                    << "PseudoCEmitter: mangled Remill name found at offset "
                    << pos << "\n");
            }
            pos += std::strlen(mangledPrefix);
        }
    }

    // 3. Check for raw register names outside comments
    // Match word-boundary register names (case-insensitive)
    static const std::regex regPattern(
        "\\b(rax|rbx|rcx|rdx|rsp|rbp|rsi|rdi"
        "|r8|r9|r10|r11|r12|r13|r14|r15)\\b",
        std::regex_constants::icase);

    auto begin = std::sregex_iterator(output.begin(), output.end(), regPattern);
    auto end = std::sregex_iterator();
    for (auto it = begin; it != end; ++it) {
        size_t matchPos = static_cast<size_t>(it->position());
        if (!isInsideLineComment(output, matchPos)) {
            LLVM_DEBUG(llvm::dbgs()
                << "PseudoCEmitter: raw register name '" << it->str()
                << "' found outside comment at offset " << matchPos << "\n");
        }
    }
}

#endif // NDEBUG
