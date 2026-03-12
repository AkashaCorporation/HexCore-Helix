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

static bool inferLikelyReturnValue(helix::low::FuncOp func) {
    bool hasRet = false;
    bool foundReturnWrite = false;

    func.walk([&](helix::low::RetOp ret) {
        if (foundReturnWrite)
            return;
        hasRet = true;

        auto* block = ret->getBlock();
        if (!block)
            return;

        if (blockHasLikelyReturnWrite(block, Block::iterator(ret))) {
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

    func.walk([&](helix::high::AssignOp assign) {
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

    // Walk top-level operations looking for helix_low.func ops
    module.walk([&](Operation* op) {
        if (isa<helix::low::FuncOp>(op)) {
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
    os << "// Engine version: 0.2.0-mlir\n";
    os << "\n";
}

PseudoCEmitter::FunctionStats PseudoCEmitter::analyzeFunction(Operation* op) {
    FunctionStats stats;
    auto func = cast<helix::low::FuncOp>(op);
    syntheticCallBaseAddrs_.clear();

    func.walk([&](Operation* inst) {
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
    
    // Deduct for complexity if very large
    if (stats.instructionCount > 1000) {
        deduction += (stats.instructionCount - 1000) * 0.01;
    }

    stats.score = std::max(0.0, 100.0 - deduction);

    return stats;
}

void PseudoCEmitter::emitFunction(Operation* op, llvm::raw_ostream& os) {
    auto func = cast<helix::low::FuncOp>(op);
    auto funcName = func.getSymName();
    auto entryAddr = func.getEntryAddress();

    lastRegValue.clear(); // Reset copy propagation state for new function
    nameAliases_.clear();
    syntheticCallBaseAddrs_.clear();
    referencedBlocks_.clear();
    referencedLabelNames_.clear();
    currentFunctionName_ = funcName.str();
    currentFunctionEntryAddr_ = entryAddr;
    currentReturnValueName_.clear();
    currentFunctionHasReturnValue_ = func->hasAttr("has_return_value");
    currentFunctionIsWin64_ = true;
    if (auto ccAttr = func->getAttrOfType<StringAttr>("calling_convention"))
        currentFunctionIsWin64_ = (ccAttr.getValue() == "win64");
    // Initialize block labels for the entire function
    globalBlockCounter_ = 1;
    blockLabels_.clear();
    func.walk([&](mlir::Block* block) {
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
    for (Region& region : func->getRegions())
        collectEmittedLabelReferences(collectEmittedLabelReferences, region);

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
        func->hasAttr("has_return_value") || inferLikelyReturnValue(func);
    currentFunctionHasReturnValue_ = hasReturnValue;
    currentReturnValueName_.clear();
    currentFunctionIsWin64_ = true;
    currentWin64RbpStackParamBaseOffset_ = 0x28;
    currentWin64StackParamLimit_ = 4;
    if (auto ccAttr = func->getAttrOfType<StringAttr>("calling_convention"))
        currentFunctionIsWin64_ = (ccAttr.getValue() == "win64");
    if (auto rbpBaseAttr =
            func->getAttrOfType<IntegerAttr>("win64_rbp_param_base_offset")) {
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

    func.walk([&](helix::high::VarDeclOp decl) {
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

    func.walk([&](helix::high::VarRefOp ref) {
        if (auto index = parseParamIndex(ref.getVarName().str())) {
            recordParam(*index, "int64_t", ref.getVarName().str());
        }
    });

    std::set<unsigned> observedStackParams;
    func.walk([&](helix::low::MemReadOp memRead) {
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
    func.walk([&](LLVM::LoadOp load) {
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
    func.walk([&](helix::high::AssignOp assign) {
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
        func.walk([&](helix::low::RegReadOp regRead) {
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

        func.walk([&](helix::low::MemReadOp memRead) {
            bumpIfThisLike(formatExpression(memRead.getAddr()));
        });
        func.walk([&](helix::low::MemWriteOp memWrite) {
            bumpIfThisLike(formatExpression(memWrite.getAddr()));
        });
        func.walk([&](helix::low::CallOp call) {
            bumpIfThisLike(formatExpression(call.getTargetAddr()));
            for (auto arg : call.getArgs())
                bumpIfThisLike(formatExpression(arg));
        });
        func.walk([&](helix::high::FieldAccessOp field) {
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

    // Collect referenced var_ids to filter unused declarations
    llvm::DenseSet<uint32_t> referencedVarIds;
    func.walk([&](helix::high::VarRefOp ref) {
        referencedVarIds.insert(ref.getVarId());
    });

    // Collect non-parameter declarations grouped by storage kind:
    //   Stack (locals) → Register → Temporary
    struct VarDeclInfo {
        std::string typeStr;
        std::string name;
        helix::high::StorageKind storage;
    };
    llvm::SmallVector<VarDeclInfo> stackDecls, registerDecls, tempDecls;
    std::set<std::string> declaredLocalNames;

    func.walk([&](helix::high::VarDeclOp decl) {
        if (decl.getStorage() == helix::high::StorageKind::Parameter)
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

    func.walk([&](helix::high::VarRefOp ref) {
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
        func.walk([&](helix::high::VarDeclOp decl) {
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

    emitDeclGroup(stackDecls);
    emitDeclGroup(registerDecls);
    emitDeclGroup(tempDecls);

    // Body statements
    if (!func.getBody().empty()) {
        emitRegionBody(func.getBody(), os, 1);
    }

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
        isa<helix::high::AddrLitOp>(op))
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

        // Invalidate any cached expressions that depend on the newly written target.
        // Also invalidate the target itself before assigning the new value.
        for (auto it = lastRegValue.begin(); it != lastRegValue.end(); ) {
            if (it->first == targetStr || it->second.find(targetStr) != std::string::npos) {
                it = lastRegValue.erase(it);
            } else {
                ++it;
            }
        }
        
        lastRegValue[targetStr] = exprStr;

        if (suppressEmission)
            return;

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

    // ─── If/else ────────────────────────────────────────────────────────
    if (auto ifOp = dyn_cast<helix::high::IfOp>(op)) {
        lastRegValue.clear(); // Control flow branch invalidates sequence
        std::function<void(helix::high::IfOp, bool)> emitIfBody;
        emitIfBody =
            [&](helix::high::IfOp nestedIf, bool withIndent) {
                if (withIndent)
                    indent(os, depth);
                auto condCode =
                    extractConditionCode(nestedIf.getCondition(), this);
                std::string condStr =
                    condCode ? *condCode : formatExpression(nestedIf.getCondition());
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
        indent(os, depth);
        if (ret.getValue()) {
            os << "return " << formatExpression(ret.getValue()) << ";\n";
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
        indent(os, depth);
        os << "goto " << gotoOp.getLabel().str() << ";\n";
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
        auto addrStr = formatExpression(memWrite.getAddr());
        std::string locationExpr;
        if (addrStr.starts_with("&") && addrStr.find("->") != std::string::npos) {
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

        // Clean up *( &param_X->field_Y ) into param_X->field_Y
        if (addrStr.starts_with("&") && addrStr.find("->") != std::string::npos) {
            os << addrStr.substr(1) << " = " << formatExpression(memWrite.getValue());
        } else if (addrStr.starts_with("(&") && addrStr.back() == ')' && addrStr.find("->") != std::string::npos) {
            os << addrStr.substr(2, addrStr.size() - 3) << " = " << formatExpression(memWrite.getValue());
        } else {
            os << "*(" << addrStr << ") = " << formatExpression(memWrite.getValue());
        }
        
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
            os << name->str();
            isRecursive = matchesCurrentFunction(name->str());
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
                // Now that pointer arithmetic creates strings like "&rax->field_0x18",
                // we can just parse the string to emit clean virtual call syntax:
                //   sub_&rax->field_0x18()  →  rax->vfunc_0x18()
                bool vtableResolved = false;
                if (addrExpr.starts_with("&") && addrExpr.find("->field_") != std::string::npos) {
                    auto arrowPos = addrExpr.find("->");
                    if (arrowPos != std::string::npos) {
                        std::string obj = addrExpr.substr(1, arrowPos - 1);
                        std::string field = addrExpr.substr(arrowPos + 8); // length of "->field_"
                        os << obj << "->vfunc_" << field;
                        vtableResolved = true;
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

    // ─── HelixLow: Xchg ─────────────────────────────────────────────────
    if (auto xchg = dyn_cast<helix::low::XchgOp>(op)) {
        indent(os, depth);
        std::string regA = xchg.getRegA().str();
        std::string regB = xchg.getRegB().str();
        for (auto& c : regA) c = std::tolower(c);
        for (auto& c : regB) c = std::tolower(c);
        os << "xchg(" << regA << ", " << regB << ")";
        if (auto addr = xchg.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
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

    bool firstBlock = true;
    bool suppressAcrossBlocksUntilLabel = false;
    for (auto& block : region) {
        if (suppressAcrossBlocksUntilLabel && !blockStartsWithVisibleLabel(&block))
            continue;

        if (blockStartsWithVisibleLabel(&block))
            suppressAcrossBlocksUntilLabel = false;

        lastRegValue.clear();
        bool suppressUntilVisibleLabel = false;

        // Emit block label for non-entry blocks in multi-block regions.
        if (multiBlock && !firstBlock && shouldEmitSyntheticBlockLabel(&block)) {
            if (depth > 0)
                indent(os, depth - 1);
            os << blockLabels_[&block] << ":\n";
        }
        firstBlock = false;

        // Pre-compute dead stores for this block
        deadStoreOps = precomputeDeadStores(block);

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
        if (isSyntheticTemporaryName(name)) {
            auto it = lastRegValue.find(name);
            if (it != lastRegValue.end() && it->second != name &&
                it->second.find(name) == std::string::npos) {
                return it->second;
            }
        }
        return name;
    }

    // ─── Binary expression ──────────────────────────────────────────────
    if (auto binary = dyn_cast<helix::high::BinaryOp>(defOp)) {
        std::string opStr;
        switch (binary.getOp()) {
        case helix::high::BinaryOpKind::Add:    opStr = "+"; break;
        case helix::high::BinaryOpKind::Sub:    opStr = "-"; break;
        case helix::high::BinaryOpKind::Mul:    opStr = "*"; break;
        case helix::high::BinaryOpKind::Div:    opStr = "/"; break;
        case helix::high::BinaryOpKind::Mod:    opStr = "%"; break;
        case helix::high::BinaryOpKind::Shl:    opStr = "<<"; break;
        case helix::high::BinaryOpKind::Shr:    opStr = ">>"; break;
        case helix::high::BinaryOpKind::Sar:    opStr = ">>"; break;
        case helix::high::BinaryOpKind::BitAnd: opStr = "&"; break;
        case helix::high::BinaryOpKind::BitOr:  opStr = "|"; break;
        case helix::high::BinaryOpKind::BitXor: opStr = "^"; break;
        case helix::high::BinaryOpKind::Eq:     opStr = "=="; break;
        case helix::high::BinaryOpKind::Ne:     opStr = "!="; break;
        case helix::high::BinaryOpKind::Lt:     opStr = "<"; break;
        case helix::high::BinaryOpKind::Le:     opStr = "<="; break;
        case helix::high::BinaryOpKind::Gt:     opStr = ">"; break;
        case helix::high::BinaryOpKind::Ge:     opStr = ">="; break;
        case helix::high::BinaryOpKind::LogAnd: opStr = "&&"; break;
        case helix::high::BinaryOpKind::LogOr:  opStr = "||"; break;
        }
        auto lhsStr = formatExpression(binary.getLhs());
        auto rhsStr = formatExpression(binary.getRhs());

        if (binary.getOp() == helix::high::BinaryOpKind::Add || binary.getOp() == helix::high::BinaryOpKind::Sub) {
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

        return std::format("({} {} {})", lhsStr, opStr, rhsStr);
    }

    // ─── Unary expression ───────────────────────────────────────────────
    if (auto unary = dyn_cast<helix::high::UnaryOp>(defOp)) {
        std::string opStr;
        switch (unary.getOp()) {
        case helix::high::UnaryOpKind::Neg:       opStr = "-"; break;
        case helix::high::UnaryOpKind::LogNot:    opStr = "!"; break;
        case helix::high::UnaryOpKind::BitNot:    opStr = "~"; break;
        case helix::high::UnaryOpKind::Deref:     opStr = "*"; break;
        case helix::high::UnaryOpKind::AddressOf: opStr = "&"; break;
        }
        return std::format("({}{})", opStr, formatExpression(unary.getOperand()));
    }

    // ─── Cast expression ────────────────────────────────────────────────
    if (auto castOp = dyn_cast<helix::high::CastOp>(defOp)) {
        return std::format("({})({})",
            formatType(castOp.getResult().getType()),
            formatExpression(castOp.getInput()));
    }

    // ─── Function call expression ───────────────────────────────────────
    if (auto call = dyn_cast<helix::high::CallOp>(defOp)) {
        std::string result = call.getTargetName().str() + "(";
        auto args = call.getArgs();
        for (size_t i = 0; i < args.size(); i++) {
            if (i > 0) result += ", ";
            result += formatExpression(args[i]);
        }
        result += ")";
        return result;
    }

    // ─── Ternary expression ─────────────────────────────────────────────
    if (auto ternary = dyn_cast<helix::high::TernaryOp>(defOp)) {
        return std::format("({} ? {} : {})",
            formatExpression(ternary.getCond()),
            formatExpression(ternary.getTrueVal()),
            formatExpression(ternary.getFalseVal()));
    }

    // ─── Subscript expression ───────────────────────────────────────────
    if (auto sub = dyn_cast<helix::high::SubscriptOp>(defOp)) {
        return std::format("{}[{}]",
            formatExpression(sub.getBase()),
            formatExpression(sub.getIndex()));
    }

    // ─── Field access expression ────────────────────────────────────────
    if (auto field = dyn_cast<helix::high::FieldAccessOp>(defOp)) {
        auto op_str = field.getIsPointer() ? "->" : ".";
        return std::format("{}{}{}",
            formatExpression(field.getBase()),
            op_str,
            field.getFieldName().str());
    }

    // ─── Address literal ────────────────────────────────────────────────
    if (auto addrLit = dyn_cast<helix::high::AddrLitOp>(defOp)) {
        return std::format("0x{:x}", addrLit.getAddrValue());
    }

    // ═════════════════════════════════════════════════════════════════════
    // HelixLow Dialect fallback expressions
    // ═════════════════════════════════════════════════════════════════════

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

        auto addrStr = formatExpression(memRead.getAddr());
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
            auto lhsStr = formatExpression(binop.getLhs());
            auto rhsStr = formatExpression(binop.getRhs());
            if (lhsStr == rhsStr)
                return std::string("0");
        }
        // ─── SUB(A, A) → 0 peephole ────────────────────────────────
        if (binop.getKind() == helix::low::BinOpKind::Sub) {
            auto lhsStr = formatExpression(binop.getLhs());
            auto rhsStr = formatExpression(binop.getRhs());
            if (lhsStr == rhsStr)
                return std::string("0");
        }

        // Check if we're referencing a flag result (not the main result)
        if (auto opResult = dyn_cast<OpResult>(val)) {
            unsigned resNum = opResult.getResultNumber();
            if (resNum > 0) {
                auto lhs = formatExpression(binop.getLhs());
                auto rhs = formatExpression(binop.getRhs());
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
        switch (binop.getKind()) {
        case helix::low::BinOpKind::Add:  opStr = "+"; break;
        case helix::low::BinOpKind::Sub:  opStr = "-"; break;
        case helix::low::BinOpKind::Mul:  opStr = "*"; break;
        case helix::low::BinOpKind::IMul: opStr = "*"; break;
        case helix::low::BinOpKind::Div:  opStr = "/"; break;
        case helix::low::BinOpKind::IDiv: opStr = "/"; break;
        case helix::low::BinOpKind::And:  opStr = "&"; break;
        case helix::low::BinOpKind::Or:   opStr = "|"; break;
        case helix::low::BinOpKind::Xor:  opStr = "^"; break;
        case helix::low::BinOpKind::Shl:  opStr = "<<"; break;
        case helix::low::BinOpKind::Shr:  opStr = ">>"; break;
        case helix::low::BinOpKind::Sar:  opStr = ">>"; break;
        case helix::low::BinOpKind::Rol:  opStr = "<<<"; break;
        case helix::low::BinOpKind::Ror:  opStr = ">>>"; break;
        }
        auto lhsStr = formatExpression(binop.getLhs());
        auto rhsStr = formatExpression(binop.getRhs());

        if (binop.getKind() == helix::low::BinOpKind::Add || binop.getKind() == helix::low::BinOpKind::Sub) {
            
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

        return std::format("({} {} {})", lhsStr, opStr, rhsStr);
    }

    // ─── HelixLow: Unary operation ──────────────────────────────────────
    if (auto unary = dyn_cast<helix::low::UnaryOp>(defOp)) {
        // Check if we're referencing a flag result
        if (auto opResult = dyn_cast<OpResult>(val)) {
            unsigned resNum = opResult.getResultNumber();
            if (resNum > 0) {
                auto operand = formatExpression(unary.getOperand());
                switch (resNum) {
                case 1: return std::format("(({}) == 0)", operand); // zero flag
                case 2: return std::format("(({}) < 0)", operand);  // sign flag
                default: return "/* flag */";
                }
            }
        }

        auto operand = formatExpression(unary.getOperand());
        switch (unary.getKind()) {
        case helix::low::UnaryOpKind::Neg:   return std::format("(-{})", operand);
        case helix::low::UnaryOpKind::Not:   return std::format("(~{})", operand);
        case helix::low::UnaryOpKind::Inc:   return std::format("({} + 1)", operand);
        case helix::low::UnaryOpKind::Dec:   return std::format("({} - 1)", operand);
        case helix::low::UnaryOpKind::Bswap: return std::format("__builtin_bswap64({})", operand);
        case helix::low::UnaryOpKind::Bsf:   return std::format("__builtin_ctzll({})", operand);
        case helix::low::UnaryOpKind::Bsr:   return std::format("(63 - __builtin_clzll({}))", operand);
        }
        return std::format("/* unary: {} */", operand);
    }

    // ─── HelixLow: Cmp (flag results) ───────────────────────────────────
    if (auto cmp = dyn_cast<helix::low::CmpOp>(defOp)) {
        auto lhs = formatExpression(cmp.getLhs());
        auto rhs = formatExpression(cmp.getRhs());
        if (auto opResult = dyn_cast<OpResult>(val)) {
            switch (opResult.getResultNumber()) {
            case 0: return std::format("({} < {})", lhs, rhs);   // carry (borrow)
            case 1: return std::format("({} == {})", lhs, rhs);  // zero
            case 2: return std::format("(({} - {}) < 0)", lhs, rhs); // sign
            case 3: return std::format("__overflow({}, {})", lhs, rhs);
            }
        }
        return std::format("cmp({}, {})", lhs, rhs);
    }

    // ─── HelixLow: Test (flag results) ──────────────────────────────────
    if (auto test = dyn_cast<helix::low::TestOp>(defOp)) {
        auto lhs = formatExpression(test.getLhs());
        auto rhs = formatExpression(test.getRhs());
        if (auto opResult = dyn_cast<OpResult>(val)) {
            switch (opResult.getResultNumber()) {
            case 0: return std::format("(({} & {}) == 0)", lhs, rhs); // zero
            case 1: return std::format("(({} & {}) < 0)", lhs, rhs);  // sign
            }
        }
        return std::format("({} & {})", lhs, rhs);
    }

    // ─── HelixLow: CMov (conditional select) ────────────────────────────
    if (auto cmov = dyn_cast<helix::low::CMovOp>(defOp)) {
        return std::format("({} ? {} : {})",
            formatExpression(cmov.getFlagValue()),
            formatExpression(cmov.getTrueVal()),
            formatExpression(cmov.getFalseVal()));
    }

    // ─── HelixLow: MovZx/MovSx (zero/sign extend) ──────────────────────
    if (auto movzx = dyn_cast<helix::low::MovZxOp>(defOp)) {
        auto dstWidth = movzx.getDstWidth();
        std::string typeStr;
        switch (dstWidth) {
        case 8:  typeStr = "uint8_t"; break;
        case 16: typeStr = "uint16_t"; break;
        case 32: typeStr = "uint32_t"; break;
        case 64: typeStr = "uint64_t"; break;
        default: typeStr = std::format("uint{}_t", dstWidth); break;
        }
        return std::format("({}){}", typeStr, formatExpression(movzx.getSrc()));
    }

    if (auto movsx = dyn_cast<helix::low::MovSxOp>(defOp)) {
        auto dstWidth = movsx.getDstWidth();
        std::string typeStr;
        switch (dstWidth) {
        case 8:  typeStr = "int8_t"; break;
        case 16: typeStr = "int16_t"; break;
        case 32: typeStr = "int32_t"; break;
        case 64: typeStr = "int64_t"; break;
        default: typeStr = std::format("int{}_t", dstWidth); break;
        }
        return std::format("({}){}", typeStr, formatExpression(movsx.getSrc()));
    }

    // ─── HelixLow: Pop (value from stack) ───────────────────────────────
    if (isa<helix::low::PopOp>(defOp)) {
        return "pop()";
    }

    if (auto lea = dyn_cast<helix::low::LeaOp>(defOp)) {
        auto disp = lea.getDisplacement();
        if (disp != 0) {
            return std::format("({} + {})",
                formatExpression(lea.getBase()),
                formatIntLiteral(disp));
        }
        return formatExpression(lea.getBase());
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
        auto lhsStr = formatExpression(op.getLhs());
        auto rhsStr = formatExpression(op.getRhs());

        if (auto lhs = parseFormattedIntegerLiteral(lhsStr)) {
            if (auto rhs = parseFormattedIntegerLiteral(rhsStr))
                return formatIntLiteral(*lhs + *rhs);
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
        return std::format("({} + {})", lhsStr, rhsStr);
    }

    if (auto op = dyn_cast<LLVM::SubOp>(defOp)) {
        auto lhsStr = formatExpression(op.getLhs());
        auto rhsStr = formatExpression(op.getRhs());
        if (auto lhs = parseFormattedIntegerLiteral(lhsStr)) {
            if (auto rhs = parseFormattedIntegerLiteral(rhsStr))
                return formatIntLiteral(*lhs - *rhs);
        }
        return std::format("({} - {})", lhsStr, rhsStr);
    }

    if (auto op = dyn_cast<LLVM::MulOp>(defOp)) {
        auto lhsStr = formatExpression(op.getLhs());
        auto rhsStr = formatExpression(op.getRhs());
        
        // ─── Hash Function Inlining ─────────────────────────────────────
        if (rhsStr == "0x8001" || rhsStr == "32769") {
            std::string x = lhsStr;
            if (x.starts_with("(int64_t)(")) x = x.substr(10, x.size() - 11);
            else if (x.starts_with("(uint64_t)(")) x = x.substr(11, x.size() - 12);
            return std::format("HASH({})", x);
        }
        
        return std::format("({} * {})", lhsStr, rhsStr);
    }

    if (auto op = dyn_cast<LLVM::UDivOp>(defOp))
        return std::format("((uint64_t){} / (uint64_t){})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<LLVM::SDivOp>(defOp))
        return std::format("({} / {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<LLVM::URemOp>(defOp))
        return std::format("((uint64_t){} % (uint64_t){})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<LLVM::SRemOp>(defOp))
        return std::format("({} % {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    // ─── Bitwise operations ─────────────────────────────────────────────
    if (auto op = dyn_cast<LLVM::AndOp>(defOp))
        return std::format("({} & {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<LLVM::OrOp>(defOp))
        return std::format("({} | {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<LLVM::XOrOp>(defOp))
        return std::format("({} ^ {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    // ─── Shifts ─────────────────────────────────────────────────────────
    if (auto op = dyn_cast<LLVM::ShlOp>(defOp))
        return std::format("({} << {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<LLVM::LShrOp>(defOp))
        return std::format("({} >> {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<LLVM::AShrOp>(defOp))
        return std::format("((int64_t){} >> {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    // ─── Comparison ─────────────────────────────────────────────────────
    if (auto icmp = dyn_cast<LLVM::ICmpOp>(defOp)) {
        std::string cmpStr;
        switch (icmp.getPredicate()) {
        case LLVM::ICmpPredicate::eq:  cmpStr = "=="; break;
        case LLVM::ICmpPredicate::ne:  cmpStr = "!="; break;
        case LLVM::ICmpPredicate::slt: cmpStr = "<"; break;
        case LLVM::ICmpPredicate::sle: cmpStr = "<="; break;
        case LLVM::ICmpPredicate::sgt: cmpStr = ">"; break;
        case LLVM::ICmpPredicate::sge: cmpStr = ">="; break;
        case LLVM::ICmpPredicate::ult: cmpStr = "<"; break;
        case LLVM::ICmpPredicate::ule: cmpStr = "<="; break;
        case LLVM::ICmpPredicate::ugt: cmpStr = ">"; break;
        case LLVM::ICmpPredicate::uge: cmpStr = ">="; break;
        }
        return std::format("({} {} {})",
            formatExpression(icmp.getLhs()), cmpStr,
            formatExpression(icmp.getRhs()));
    }

    // ─── Select (ternary) ───────────────────────────────────────────────
    if (auto sel = dyn_cast<LLVM::SelectOp>(defOp))
        return std::format("({} ? {} : {})",
            formatExpression(sel.getCondition()),
            formatExpression(sel.getTrueValue()),
            formatExpression(sel.getFalseValue()));

    // ─── Integer casts ──────────────────────────────────────────────────
    if (auto op = dyn_cast<LLVM::ZExtOp>(defOp))
        return std::format("({})({})",
            formatType(op.getResult().getType()),
            formatExpression(op.getArg()));

    if (auto op = dyn_cast<LLVM::SExtOp>(defOp))
        return std::format("({})({})",
            formatType(op.getResult().getType()),
            formatExpression(op.getArg()));

    if (auto op = dyn_cast<LLVM::TruncOp>(defOp))
        return std::format("({})({})",
            formatType(op.getResult().getType()),
            formatExpression(op.getArg()));

    // ─── Pointer casts ──────────────────────────────────────────────────
    if (auto op = dyn_cast<LLVM::PtrToIntOp>(defOp))
        return std::format("(int64_t)({})", formatExpression(op.getArg()));

    if (auto op = dyn_cast<LLVM::IntToPtrOp>(defOp)) {
        auto expr = formatExpression(op.getArg());
        if (expr == "0") return "NULL";
        return std::format("(void*)({})", expr);
    }

    // ─── Memory load ────────────────────────────────────────────────────
    if (auto load = dyn_cast<LLVM::LoadOp>(defOp)) {
        if (auto paramIndex = inferWin64StackParamIndex(load.getOperation(),
                                                        load.getAddr());
            paramIndex && *paramIndex <= currentWin64StackParamLimit_)
            return applyNameAliases(std::format("param_{}", *paramIndex));
        return std::format("*({})", formatExpression(load.getAddr()));
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
            result += formatExpression(call.getOperand(i));
        }
        result += ")";
        return result;
    }

    // ─── GEP (pointer arithmetic) ───────────────────────────────────────
    if (auto gep = dyn_cast<LLVM::GEPOp>(defOp)) {
        auto base = formatExpression(gep.getBase());
        auto dynIndices = gep.getDynamicIndices();
        if (dynIndices.empty())
            return base;
            
        // ─── Segment Register Awareness ─────────────────────────────────
        if (dynIndices.size() == 1 && (base == "*(int64_t)(NULL)" || base == "*(NULL)")) {
            std::string hexOffset = formatExpression(dynIndices[0]);
            if (!hexOffset.starts_with("0x")) {
                try { hexOffset = std::format("0x{:x}", std::stoull(hexOffset)); } catch(...) {}
            }
            return std::format("__readgsqword({})", hexOffset);
        }

        // TLS folding
        if (base.find("__readgsqword") != std::string::npos) {
            llvm::errs() << "[DEBUG] GEPOp string matcher saw: '" << base << "'\n";
        }
        
        auto hasTlsBase = [](const std::string& s) {
            return s.find("__readgsqword(0x58)") != std::string::npos || s.find("&__local") != std::string::npos;
        };
        if (hasTlsBase(base) && dynIndices.size() == 1) {
            auto rhsStr = formatExpression(dynIndices[0]);
            try {
                uint64_t offset = 0;
                if (rhsStr.starts_with("0x") || rhsStr.starts_with("0X")) offset = std::stoull(rhsStr.substr(2), nullptr, 16);
                else offset = std::stoull(rhsStr, nullptr, 10);
                uint64_t addr = 0x140000000ULL + offset;
                return std::format("0x{:x}", addr);
            } catch(...) {}
        }

        std::string result = "(" + base;
        for (auto idx : dynIndices)
            result += " + " + formatExpression(idx);
        result += ")";
        
        // ─── Automatic Struct Field Recovery ────────────────────────────
        if (dynIndices.size() == 1) {
            auto rhsStr = formatExpression(dynIndices[0]);
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
        
        return result;
    }

    // ─── ExtractValue (aggregate member access) ─────────────────────────
    if (auto ev = dyn_cast<LLVM::ExtractValueOp>(defOp)) {
        auto pos = ev.getPosition();
        std::string result = formatExpression(ev.getContainer());
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
        auto lhsStr = formatExpression(op.getLhs());
        auto rhsStr = formatExpression(op.getRhs());
        
        // ─── Segment Register Awareness ─────────────────────────────────
        if (lhsStr == "*(int64_t)(NULL)" || lhsStr == "*(NULL)") {
            std::string hexOffset = rhsStr;
            if (!hexOffset.starts_with("0x")) {
                try { hexOffset = std::format("0x{:x}", std::stoull(hexOffset)); } catch(...) {}
            }
            return std::format("__readgsqword({})", hexOffset);
        }
        
        if (lhsStr.find("__readgsqword") != std::string::npos) {
            llvm::errs() << "[DEBUG] AddIOp string matcher saw: '" << lhsStr << "'\n";
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

        return std::format("({} + {})", lhsStr, rhsStr);
    }

    if (auto op = dyn_cast<arith::SubIOp>(defOp)) {
        auto lhsStr = formatExpression(op.getLhs());
        auto rhsStr = formatExpression(op.getRhs());
        
        if (lhsStr.find("__readgsqword") != std::string::npos) {
            llvm::errs() << "[DEBUG] SubIOp string matcher saw: '" << lhsStr << "'\n";
        }
        
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
        return std::format("({} - {})", lhsStr, rhsStr);
    }

    if (auto op = dyn_cast<arith::MulIOp>(defOp)) {
        auto lhsStr = formatExpression(op.getLhs());
        auto rhsStr = formatExpression(op.getRhs());
        
        // ─── Hash Function Inlining ─────────────────────────────────────
        if (rhsStr == "0x8001" || rhsStr == "32769") {
            std::string x = lhsStr;
            if (x.starts_with("(int64_t)(")) x = x.substr(10, x.size() - 11);
            else if (x.starts_with("(uint64_t)(")) x = x.substr(11, x.size() - 12);
            return std::format("HASH({})", x);
        }
        
        return std::format("({} * {})", lhsStr, rhsStr);
    }

    if (auto op = dyn_cast<arith::DivSIOp>(defOp))
        return std::format("({} / {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<arith::DivUIOp>(defOp))
        return std::format("((uint64_t){} / (uint64_t){})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<arith::RemSIOp>(defOp))
        return std::format("({} % {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<arith::RemUIOp>(defOp))
        return std::format("((uint64_t){} % (uint64_t){})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<arith::AndIOp>(defOp))
        return std::format("({} & {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<arith::OrIOp>(defOp))
        return std::format("({} | {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

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

        if (isLogicalNegationConstant(op.getLhs()))
            return std::format("!({})", formatExpression(op.getRhs()));
        if (isLogicalNegationConstant(op.getRhs()))
            return std::format("!({})", formatExpression(op.getLhs()));

        return std::format("({} ^ {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));
    }

    if (auto op = dyn_cast<arith::ShLIOp>(defOp))
        return std::format("({} << {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<arith::ShRUIOp>(defOp))
        return std::format("({} >> {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto op = dyn_cast<arith::ShRSIOp>(defOp))
        return std::format("((int64_t){} >> {})",
            formatExpression(op.getLhs()), formatExpression(op.getRhs()));

    if (auto icmp = dyn_cast<arith::CmpIOp>(defOp)) {
        std::string cmpStr;
        switch (icmp.getPredicate()) {
        case arith::CmpIPredicate::eq:  cmpStr = "=="; break;
        case arith::CmpIPredicate::ne:  cmpStr = "!="; break;
        case arith::CmpIPredicate::slt: cmpStr = "<"; break;
        case arith::CmpIPredicate::sle: cmpStr = "<="; break;
        case arith::CmpIPredicate::sgt: cmpStr = ">"; break;
        case arith::CmpIPredicate::sge: cmpStr = ">="; break;
        case arith::CmpIPredicate::ult: cmpStr = "<"; break;
        case arith::CmpIPredicate::ule: cmpStr = "<="; break;
        case arith::CmpIPredicate::ugt: cmpStr = ">"; break;
        case arith::CmpIPredicate::uge: cmpStr = ">="; break;
        }
        return std::format("({} {} {})",
            formatExpression(icmp.getLhs()), cmpStr,
            formatExpression(icmp.getRhs()));
    }

    if (auto op = dyn_cast<arith::ExtUIOp>(defOp))
        return std::format("({})({})",
            formatType(op.getResult().getType()),
            formatExpression(op.getIn()));

    if (auto op = dyn_cast<arith::ExtSIOp>(defOp))
        return std::format("({})({})",
            formatType(op.getResult().getType()),
            formatExpression(op.getIn()));

    if (auto op = dyn_cast<arith::TruncIOp>(defOp))
        return std::format("({})({})",
            formatType(op.getResult().getType()),
            formatExpression(op.getIn()));

    if (auto sel = dyn_cast<arith::SelectOp>(defOp))
        return std::format("({} ? {} : {})",
            formatExpression(sel.getCondition()),
            formatExpression(sel.getTrueValue()),
            formatExpression(sel.getFalseValue()));

    // ═════════════════════════════════════════════════════════════════════
    // Fallback: show the MLIR op name and its operand expressions
    // ═════════════════════════════════════════════════════════════════════

    std::string fallback = "/* " + defOp->getName().getStringRef().str();
    for (unsigned i = 0; i < defOp->getNumOperands() && i < 4; i++) {
        fallback += (i == 0 ? " " : ", ");
        fallback += formatExpression(defOp->getOperand(i));
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
                                     exprStr.find("call") != std::string::npos;

                if (!hasSideEffects) {
                    if (writtenNotRead.count(targetStr)) {
                        // This write is dead — the target is overwritten later
                        // without being read in between
                        deadOps.insert(op);
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

            // The RHS of the assignment may READ other variables — mark them live
            auto exprStr2 = formatExpression(assign.getValue());
            // Simple heuristic: any variable name appearing in the expression is a read
            for (auto& entry : writtenNotRead) {
                // Don't mark target as read by its own assignment
                if (entry != targetStr && exprStr2.find(entry) != std::string::npos) {
                    // This variable is read — can't be dead
                }
            }
            // Actually we need to remove from writtenNotRead any var that appears in the RHS
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

        if (isa<helix::low::CallOp>(op) || isa<helix::high::ExprStmtOp>(op) ||
            isa<helix::low::MemWriteOp>(op)) {
            // Conservative: any call/return might read any register → clear all
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
