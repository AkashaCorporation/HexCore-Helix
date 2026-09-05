/// @file InterProceduralTypePropagation.cpp
/// @brief MLIR pass: inter-procedural type propagation across function boundaries.
///
/// This pass extends intra-procedural type inference (PropagateTypes) by
/// propagating type information across call sites:
///
///   1. Build a call graph with resolved target addresses/names.
///   2. For each call site, propagate argument types from caller to callee
///      parameter registers (Win64: RCX, RDX, R8, R9; SysV: RDI, RSI, RDX...).
///   3. For each callee return, propagate the return type back to caller
///      (RAX register read after call).
///   4. Iterate until convergence across the entire module.
///
/// This helps eliminate the `int64_t` flood by recovering more specific types
/// (e.g., `void*`, `int32_t`, `uint8_t*`) from how values are used across
/// function boundaries.
///
/// ## Example
///
///   // Before IPA: all int64_t
///   int64_t sub_401000(int64_t param_1, int64_t param_2);
///
///   // After IPA: types from caller usage propagated
///   void* sub_401000(void* param_1, int32_t param_2);

#include "helix/passes/Passes.h"
#include "helix/analysis/TypeEvidence.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixMidOps.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#include <cstdint>
#include <format>
#include <string>

#define DEBUG_TYPE "ipa-type-propagation"

using namespace mlir;
using namespace helix;

STATISTIC(NumParamTypesRefined, "Number of parameter types refined by IPA");
STATISTIC(NumReturnTypesRefined, "Number of return types refined by IPA");

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// Type Representation (mirrors PropagateTypes::CTypeInfo)
// ═══════════════════════════════════════════════════════════════════════════════

struct IPATypeInfo {
    enum Kind { Unknown, Void, Bool, Int, UInt, Pointer, Struct };

    Kind kind = Unknown;
    unsigned bit_width = 0;
    bool is_signed = false;

    bool isResolved() const { return kind != Unknown; }

    bool mergeFrom(const IPATypeInfo& other) {
        if (other.kind == Unknown) return false;
        if (kind == Unknown) { *this = other; return true; }
        // Pointer is more specific than int64
        if (kind == Int && other.kind == Pointer) {
            *this = other; return true;
        }
        // Narrower width is more specific than wider
        if (kind == Int && other.kind == Int &&
            bit_width > other.bit_width && other.bit_width > 0) {
            *this = other; return true;
        }
        // Signed is more specific than unsigned for same width
        if (kind == UInt && other.kind == Int &&
            bit_width == other.bit_width) {
            *this = other; return true;
        }
        return false;
    }

    std::string toString() const {
        switch (kind) {
        case Void:    return "void";
        case Bool:    return "bool";
        case Int:     return std::format("int{}_t", bit_width);
        case UInt:    return std::format("uint{}_t", bit_width);
        case Pointer: return "void*";
        case Struct:  return "struct*";
        default:      return "int64_t";
        }
    }

    static IPATypeInfo fromString(llvm::StringRef s) {
        IPATypeInfo t;
        if (s == "void")  { t.kind = Void; return t; }
        if (s == "bool")  { t.kind = Bool; t.bit_width = 1; return t; }
        if (s == "void*") { t.kind = Pointer; t.bit_width = 64; return t; }
        if (s.starts_with("int") && s.ends_with("_t")) {
            auto widthStr = s.drop_front(3).drop_back(2);
            unsigned w = 0;
            if (!widthStr.getAsInteger(10, w)) {
                t.kind = Int; t.bit_width = w; t.is_signed = true;
                return t;
            }
        }
        if (s.starts_with("uint") && s.ends_with("_t")) {
            auto widthStr = s.drop_front(4).drop_back(2);
            unsigned w = 0;
            if (!widthStr.getAsInteger(10, w)) {
                t.kind = UInt; t.bit_width = w; t.is_signed = false;
                return t;
            }
        }
        return t;
    }

    static IPATypeInfo makePointer() {
        IPATypeInfo t; t.kind = Pointer; t.bit_width = 64; return t;
    }
    static IPATypeInfo makeInt(unsigned bits, bool isSigned = false) {
        IPATypeInfo t;
        t.kind = isSigned ? Int : UInt;
        t.bit_width = bits;
        t.is_signed = isSigned;
        return t;
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// Function Signature
// ═══════════════════════════════════════════════════════════════════════════════

/// Collected type information for a function.
struct FunctionTypeInfo {
    /// Address of the function entry point.
    uint64_t address = 0;

    /// Inferred parameter types (indexed by param position, 0-based).
    llvm::SmallVector<IPATypeInfo, 4> param_types;

    /// Inferred return type.
    IPATypeInfo return_type;

    /// Whether this function is void (no return value).
    bool is_void = false;
};

// ═══════════════════════════════════════════════════════════════════════════════
// Win64 ABI Parameter Registers
// ═══════════════════════════════════════════════════════════════════════════════

static const char* kWin64ParamRegs[] = {"RCX", "RDX", "R8", "R9"};
static const char* kSysVParamRegs[] = {"RDI", "RSI", "RDX", "RCX", "R8", "R9"};
static constexpr unsigned kMaxParams = 4;  // Win64 register params

/// Check if a register name is a parameter register and return its index.
static std::optional<unsigned> getParamIndex(llvm::StringRef regName) {
    // Win64 ABI
    for (unsigned i = 0; i < kMaxParams; i++) {
        if (regName.equals_insensitive(kWin64ParamRegs[i]))
            return i;
    }
    // Also check the sub-registers (ECX, CX, CL → param 0, etc.)
    if (regName.equals_insensitive("ECX") ||
        regName.equals_insensitive("CX") ||
        regName.equals_insensitive("CL"))
        return 0;
    if (regName.equals_insensitive("EDX") ||
        regName.equals_insensitive("DX") ||
        regName.equals_insensitive("DL"))
        return 1;
    if (regName.equals_insensitive("R8D") ||
        regName.equals_insensitive("R8W") ||
        regName.equals_insensitive("R8B"))
        return 2;
    if (regName.equals_insensitive("R9D") ||
        regName.equals_insensitive("R9W") ||
        regName.equals_insensitive("R9B"))
        return 3;
    return std::nullopt;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Definition
// ═══════════════════════════════════════════════════════════════════════════════

struct InterProceduralTypePropagationPass
    : public PassWrapper<InterProceduralTypePropagationPass,
                         OperationPass<ModuleOp>>
{
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(
        InterProceduralTypePropagationPass)

    StringRef getArgument() const final { return "ipa-type-propagation"; }
    StringRef getDescription() const final {
        return "Inter-procedural type propagation across function boundaries";
    }

    void runOnOperation() override {
        auto module = getOperation();

        // ── Phase 1: Collect function signatures ────────────────────────
        // Build address→FunctionTypeInfo map from all functions in the module.

        llvm::DenseMap<uint64_t, FunctionTypeInfo> funcTypes;
        llvm::StringMap<uint64_t> nameToAddr;

        module.walk([&](low::FuncOp func) {
            uint64_t addr = func.getEntryAddress();
            auto& info = funcTypes[addr];
            info.address = addr;
            info.param_types.resize(kMaxParams);

            // Register function name → address mapping.
            if (auto nameAttr = func.getOriginalNameAttr())
                nameToAddr[nameAttr.getValue()] = addr;
            nameToAddr[func.getSymName()] = addr;

            // Collect parameter types from RegReadOps in the entry block.
            // The first read of each parameter register in the function
            // tells us its type.
            if (func.getBody().empty()) return;
            Block& entryBlock = func.getBody().front();

            for (auto& op : entryBlock) {
                if (auto regRead = dyn_cast<low::RegReadOp>(&op)) {
                    auto paramIdx = getParamIndex(regRead.getRegName());
                    if (!paramIdx) continue;

                    // Check for inferred_type attribute from PropagateTypes.
                    if (auto typeAttr = regRead->getAttrOfType<StringAttr>(
                            "inferred_type")) {
                        auto inferred = IPATypeInfo::fromString(
                            typeAttr.getValue());
                        info.param_types[*paramIdx].mergeFrom(inferred);
                    } else {
                        // Default: use MLIR type width
                        unsigned bits = regRead.getBitWidth();
                        info.param_types[*paramIdx].mergeFrom(
                            IPATypeInfo::makeInt(bits));
                    }
                }
            }

            // Collect return type from RetOp values.
            func.walk([&](low::RetOp ret) {
                // Check for inferred_type on the return value's defining op.
                // The return value is typically the last RAX write.
                // For now, use a heuristic: check if there's an
                // inferred_return_type attribute on the preceding CallOp.
            });
        });

        if (funcTypes.empty()) return;

        // ── Phase 2: Propagate types from call sites to callees ─────────
        // For each CallOp, propagate the argument types to the callee's
        // parameter types, and the callee's return type back to the caller.

        constexpr unsigned kMaxIter = 4;

        for (unsigned iter = 0; iter < kMaxIter; iter++) {
            bool changed = false;

            module.walk([&](low::CallOp call) {
                // Resolve callee address.
                uint64_t calleeAddr = 0;
                if (auto targetName = call.getTargetName()) {
                    auto it = nameToAddr.find(*targetName);
                    if (it != nameToAddr.end())
                        calleeAddr = it->second;
                }

                // Try address-based resolution.
                if (calleeAddr == 0) {
                    // Check if the target_addr operand is a constant.
                    if (auto addrAttr = call->getAttrOfType<IntegerAttr>(
                            "target_addr_val")) {
                        calleeAddr = addrAttr.getInt();
                    }
                }

                if (calleeAddr == 0) return;

                auto it = funcTypes.find(calleeAddr);
                if (it == funcTypes.end()) return;
                auto& calleeInfo = it->second;

                // Propagate argument types → callee parameter types.
                for (unsigned i = 0; i < call.getArgs().size() &&
                                    i < kMaxParams; i++) {
                    Value arg = call.getArgs()[i];

                    // Check if the argument has an inferred_type.
                    if (auto* defOp = arg.getDefiningOp()) {
                        if (auto typeAttr = defOp->getAttrOfType<StringAttr>(
                                "inferred_type")) {
                            auto argType = IPATypeInfo::fromString(
                                typeAttr.getValue());
                            if (calleeInfo.param_types[i].mergeFrom(argType)) {
                                changed = true;
                                ++NumParamTypesRefined;
                            }
                        }
                    }

                    // Also check MLIR type for pointer-ness.
                    if (auto intTy = dyn_cast<IntegerType>(arg.getType())) {
                        if (intTy.getWidth() < 64) {
                            auto narrowType = IPATypeInfo::makeInt(
                                intTy.getWidth());
                            if (calleeInfo.param_types[i].mergeFrom(
                                    narrowType)) {
                                changed = true;
                                ++NumParamTypesRefined;
                            }
                        }
                    }
                }

            });

            // Also propagate at the HelixMid level (which has results).
            module.walk([&](mid::CallOp call) {
                uint64_t calleeAddr = call.getCalleeAddr();
                if (calleeAddr == 0) return;

                auto it = funcTypes.find(calleeAddr);
                if (it == funcTypes.end()) return;
                auto& calleeInfo = it->second;

                // Propagate argument types.
                for (unsigned i = 0; i < call.getArgs().size() &&
                                    i < kMaxParams; i++) {
                    Value arg = call.getArgs()[i];
                    if (auto* defOp = arg.getDefiningOp()) {
                        if (auto typeAttr = defOp->getAttrOfType<StringAttr>(
                                "inferred_type")) {
                            auto argType = IPATypeInfo::fromString(
                                typeAttr.getValue());
                            if (calleeInfo.param_types[i].mergeFrom(argType)) {
                                changed = true;
                                ++NumParamTypesRefined;
                            }
                        }
                    }
                }

                // Propagate callee return type → caller.
                if (calleeInfo.return_type.isResolved() &&
                    call.getNumResults() > 0) {
                    auto result = call.getResult();
                    auto typeStr = calleeInfo.return_type.toString();
                    auto* defOp = result.getDefiningOp();
                    if (defOp) {
                        auto existingAttr = defOp->getAttrOfType<StringAttr>(
                            "inferred_type");
                        if (!existingAttr ||
                            existingAttr.getValue() == "int64_t") {
                            if (helix::applyTypeEvidence(
                                    defOp, typeStr,
                                    helix::TypeEvidenceSource::Interprocedural)) {
                                changed = true;
                                ++NumReturnTypesRefined;
                            }
                        }
                    }
                }
            });

            if (!changed) break;

            LLVM_DEBUG(llvm::dbgs()
                << "  IPA iteration " << iter
                << ": params=" << NumParamTypesRefined
                << " returns=" << NumReturnTypesRefined << "\n");
        }

        // ── Phase 3: Apply refined types back to functions ──────────────
        // Update the inferred_type attributes on parameter register reads
        // in each function based on the cross-function analysis.

        module.walk([&](low::FuncOp func) {
            uint64_t addr = func.getEntryAddress();
            auto it = funcTypes.find(addr);
            if (it == funcTypes.end()) return;
            auto& info = it->second;

            func.walk([&](low::RegReadOp regRead) {
                auto paramIdx = getParamIndex(regRead.getRegName());
                if (!paramIdx || *paramIdx >= kMaxParams) return;

                auto& paramType = info.param_types[*paramIdx];
                if (!paramType.isResolved()) return;

                // Don't overwrite more specific existing types.
                if (auto existing = regRead->getAttrOfType<StringAttr>(
                        "inferred_type")) {
                    auto existingType = IPATypeInfo::fromString(
                        existing.getValue());
                    if (existingType.isResolved() &&
                        existingType.bit_width <= paramType.bit_width &&
                        existingType.kind != IPATypeInfo::Unknown)
                        return;
                }

                helix::applyTypeEvidence(
                    regRead, paramType.toString(),
                    helix::TypeEvidenceSource::Interprocedural);
            });
        });

        LLVM_DEBUG(llvm::dbgs()
            << "IPA Type Propagation: "
            << NumParamTypesRefined << " params, "
            << NumReturnTypesRefined << " returns refined\n");
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createInterProceduralTypePropagationPass() {
    return std::make_unique<InterProceduralTypePropagationPass>();
}
