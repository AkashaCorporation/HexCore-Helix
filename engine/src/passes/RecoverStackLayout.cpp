/// @file RecoverStackLayout.cpp
/// @brief Stack layout recovery pass: HelixLow memory accesses -> stack variables.
///
/// Scans for RSP/RBP-relative memory accesses (helix_low.mem.read / mem.write
/// with a base register of RSP or RBP) and creates helix_high.var.decl operations
/// for each unique stack offset. Variable types are inferred from access widths.
///
/// Additionally resolves *(&__local) patterns by detecting LLVM LoadOp/StoreOp
/// through AllocaOp+GEP with constant offsets, consolidating multiple references
/// to the same offset into a single named variable.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#include <algorithm>
#include <cstdint>
#include <format>
#include <map>
#include <optional>
#include <set>
#include <string>

#define DEBUG_TYPE "recover-stack-layout"

using namespace mlir;
using namespace helix;

namespace {

enum class StackAccessBase : uint8_t {
    Rsp,
    Rbp,
    Local,
};

using SlotKey = std::pair<StackAccessBase, int64_t>;

/// Information about a discovered stack slot.
struct StackSlot {
    int64_t offset = 0;
    unsigned bit_width = 0;
    StackAccessBase base = StackAccessBase::Local;
    unsigned access_count = 0;
    std::string var_name;
    bool is_parameter = false;
    std::string c_type;
};
/// Infer a C type string from memory access bit width.
static std::string inferCType(unsigned bit_width) {
    switch (bit_width) {
    case 8:  return "int8_t";
    case 16: return "int16_t";
    case 32: return "int32_t";
    case 64: return "int64_t";
    default: return "int64_t";
    }
}

static uint32_t getNextAvailableVarId(helix::low::FuncOp func) {
    uint32_t nextId = 0;
    func.walk([&](helix::high::VarDeclOp decl) {
        nextId = std::max(nextId, decl.getVarId() + 1);
    });
    return nextId;
}

static std::optional<int64_t>
inferWin64RbpStackParamBaseOffset(helix::low::FuncOp func) {
    auto& body = func.getBody();
    if (body.empty())
        return std::nullopt;

    unsigned pushesBeforeFramePointer = 0;
    bool sawFramePointerSetup = false;
    for (Operation& op : body.front()) {
        if (isa<helix::low::PushOp>(op)) {
            ++pushesBeforeFramePointer;
            continue;
        }

        auto regWrite = dyn_cast<helix::low::RegWriteOp>(op);
        if (!regWrite || regWrite.getRegName() != "RBP")
            continue;

        auto regRead = regWrite.getValue().getDefiningOp<helix::low::RegReadOp>();
        if (regRead && regRead.getRegName() == "RSP") {
            sawFramePointerSetup = true;
            break;
        }
    }

    if (!sawFramePointerSetup)
        return std::nullopt;

    return 0x28 + static_cast<int64_t>(pushesBeforeFramePointer) * 8;
}

static unsigned getWin64ParamIndex(int64_t offset, StackAccessBase base,
                                   std::optional<int64_t> rbpStackParamBase) {
    if (offset < 0 || base == StackAccessBase::Local)
        return 0;

    int64_t stackParamBase = 0;
    if (base == StackAccessBase::Rsp) {
        stackParamBase = 0x28;
    } else {
        if (!rbpStackParamBase)
            return 0;
        stackParamBase = *rbpStackParamBase;
    }

    if (offset >= stackParamBase && ((offset - stackParamBase) % 8) == 0) {
        return 5u + static_cast<unsigned>((offset - stackParamBase) / 8);
    }

    return 0;
}

static bool hasStackPointerAdjustmentBefore(Operation* op) {
    auto* block = op ? op->getBlock() : nullptr;
    if (!block)
        return true;

    for (Operation& candidate : *block) {
        if (&candidate == op)
            break;

        if (isa<helix::low::PushOp, helix::low::PopOp>(candidate))
            return true;

        if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&candidate)) {
            auto regName = regWrite.getRegName();
            if (regName == "RSP" || regName == "ESP")
                return true;
        }
    }

    return false;
}

/// Infer bit width from an MLIR type.
static unsigned inferBitWidthFromType(Type ty) {
    if (auto intTy = dyn_cast<IntegerType>(ty))
        return intTy.getWidth();
    if (isa<LLVM::LLVMPointerType>(ty))
        return 64;
    if (auto floatTy = dyn_cast<FloatType>(ty))
        return floatTy.getWidth();
    return 64;
}

/// The stack layout recovery pass.
struct RecoverStackLayoutPass
    : public PassWrapper<RecoverStackLayoutPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RecoverStackLayoutPass)

    StringRef getArgument() const final { return "recover-stack-layout"; }
    StringRef getDescription() const final {
        return "Recover stack variable layout from RSP/RBP-relative memory accesses";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<helix::high::HelixHighDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();
        module.walk([&](helix::low::FuncOp func) {
            recoverStackLayout(func);
        });
    }

private:
    struct StackAccessInfo {
        int64_t offset;
        StackAccessBase base;

        SlotKey key() const {
            return {base, offset};
        }
    };

    static Value unwrapPointerLikeValue(Value value) {
        while (true) {
            if (auto ptrToInt = value.getDefiningOp<LLVM::PtrToIntOp>()) {
                value = ptrToInt.getArg();
                continue;
            }
            return value;
        }
    }

    static std::optional<StackAccessBase> getStackBase(Value value) {
        value = unwrapPointerLikeValue(value);

        if (auto regRead = value.getDefiningOp<helix::low::RegReadOp>()) {
            auto regName = regRead.getRegName();
            if (regName == "RSP")
                return StackAccessBase::Rsp;
            if (regName == "RBP")
                return StackAccessBase::Rbp;
        }

        if (auto varRef = value.getDefiningOp<helix::high::VarRefOp>()) {
            auto regName = varRef.getVarName().str();
            if (regName == "rsp" || regName == "RSP")
                return StackAccessBase::Rsp;
            if (regName == "rbp" || regName == "RBP")
                return StackAccessBase::Rbp;
        }

        return std::nullopt;
    }

    static std::optional<int64_t> getIntegerOffset(Value value) {
        value = unwrapPointerLikeValue(value);

        if (auto intLit = value.getDefiningOp<helix::high::IntLitOp>())
            return intLit.getValue();

        if (auto constant = value.getDefiningOp<LLVM::ConstantOp>()) {
            if (auto intAttr = dyn_cast<IntegerAttr>(constant.getValue()))
                return intAttr.getValue().getSExtValue();
        }

        if (auto constant = value.getDefiningOp<arith::ConstantOp>()) {
            if (auto intAttr = dyn_cast<IntegerAttr>(constant.getValue()))
                return intAttr.getValue().getSExtValue();
        }

        return std::nullopt;
    }

    static void recordSlot(std::map<SlotKey, StackSlot>& slots,
                           const StackAccessInfo& info,
                           unsigned bitWidth) {
        auto& slot = slots[info.key()];
        slot.offset = info.offset;
        slot.base = info.base;
        slot.bit_width = std::max(slot.bit_width, bitWidth);
        slot.access_count++;
    }

    void recoverStackLayout(helix::low::FuncOp func) {
        std::map<SlotKey, StackSlot> slots;
        llvm::SmallVector<std::pair<Operation*, SlotKey>> resolvedAccessOps;
        llvm::SmallVector<Operation*> unresolvedOps;
        std::set<SlotKey> nonParameterSlots;
        bool isWin64 = true;
        if (auto ccAttr = func->getAttrOfType<StringAttr>("calling_convention"))
            isWin64 = (ccAttr.getValue() == "win64");

        auto win64RbpStackParamBase = isWin64
            ? inferWin64RbpStackParamBaseOffset(func)
            : std::nullopt;

        if (win64RbpStackParamBase) {
            Builder attrBuilder(func.getContext());
            func->setAttr("win64_rbp_param_base_offset",
                attrBuilder.getI64IntegerAttr(*win64RbpStackParamBase));
        } else {
            func->removeAttr("win64_rbp_param_base_offset");
        }

        func.walk([&](Operation* op) {
            if (auto memRead = dyn_cast<helix::low::MemReadOp>(op)) {
                auto info = analyzeStackAccess(memRead.getAddr());
                if (info) {
                    recordSlot(slots, *info,
                        static_cast<unsigned>(memRead.getBitWidth()));
                    if (isWin64 && info->base == StackAccessBase::Rsp &&
                        info->offset > 0 &&
                        hasStackPointerAdjustmentBefore(op)) {
                        nonParameterSlots.insert(info->key());
                    }
                    resolvedAccessOps.push_back({op, info->key()});
                } else if (auto localInfo = analyzeLocalPattern(memRead.getAddr())) {
                    recordSlot(slots, *localInfo,
                        static_cast<unsigned>(memRead.getBitWidth()));
                    resolvedAccessOps.push_back({op, localInfo->key()});
                } else if (isLocalPattern(memRead.getAddr())) {
                    unresolvedOps.push_back(op);
                }
            }
            if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
                auto info = analyzeStackAccess(memWrite.getAddr());
                if (info) {
                    recordSlot(slots, *info,
                        static_cast<unsigned>(memWrite.getBitWidth()));
                    if (isWin64 && info->base == StackAccessBase::Rsp &&
                        info->offset > 0 &&
                        hasStackPointerAdjustmentBefore(op)) {
                        nonParameterSlots.insert(info->key());
                    }
                    resolvedAccessOps.push_back({op, info->key()});
                } else if (auto localInfo = analyzeLocalPattern(memWrite.getAddr())) {
                    recordSlot(slots, *localInfo,
                        static_cast<unsigned>(memWrite.getBitWidth()));
                    resolvedAccessOps.push_back({op, localInfo->key()});
                } else if (isLocalPattern(memWrite.getAddr())) {
                    unresolvedOps.push_back(op);
                }
            }
            // Resolve *(&__local) patterns: LLVM LoadOp/StoreOp through
            // AllocaOp+GEP with constant offsets.
            if (auto load = dyn_cast<LLVM::LoadOp>(op)) {
                auto info = analyzeStackAccess(load.getAddr());
                if (!info)
                    info = analyzeLocalPattern(load.getAddr());
                if (info) {
                    recordSlot(slots, *info,
                        inferBitWidthFromType(load.getResult().getType()));
                    if (isWin64 && info->base == StackAccessBase::Rsp &&
                        info->offset > 0 &&
                        hasStackPointerAdjustmentBefore(op)) {
                        nonParameterSlots.insert(info->key());
                    }
                    resolvedAccessOps.push_back({op, info->key()});
                } else if (isLocalPattern(load.getAddr())) {
                    unresolvedOps.push_back(op);
                }
            }
            if (auto store = dyn_cast<LLVM::StoreOp>(op)) {
                auto info = analyzeStackAccess(store.getAddr());
                if (!info)
                    info = analyzeLocalPattern(store.getAddr());
                if (info) {
                    recordSlot(slots, *info,
                        inferBitWidthFromType(store.getValue().getType()));
                    if (isWin64 && info->base == StackAccessBase::Rsp &&
                        info->offset > 0 &&
                        hasStackPointerAdjustmentBefore(op)) {
                        nonParameterSlots.insert(info->key());
                    }
                    resolvedAccessOps.push_back({op, info->key()});
                } else if (isLocalPattern(store.getAddr())) {
                    unresolvedOps.push_back(op);
                }
            }
        });

        for (auto* op : unresolvedOps)
            op->emitWarning("unresolved stack offset");

        if (slots.empty())
            return;
        // Phase 2: Sort slots by offset and assign names + types.
        llvm::SmallVector<std::pair<SlotKey, StackSlot>> sortedSlots;
        for (auto& [key, slot] : slots)
            sortedSlots.push_back({key, slot});
        llvm::sort(sortedSlots,
                   [](const std::pair<SlotKey, StackSlot>& a,
                      const std::pair<SlotKey, StackSlot>& b) {
            if (a.second.offset != b.second.offset)
                return a.second.offset < b.second.offset;
            return static_cast<unsigned>(a.second.base) <
                   static_cast<unsigned>(b.second.base);
        });

        for (auto& [key, slot] : sortedSlots) {
            slot.c_type = inferCType(slot.bit_width);
            if (slot.base == StackAccessBase::Local || slot.offset < 0) {
                uint64_t absOffset = static_cast<uint64_t>(
                    slot.offset < 0 ? -slot.offset : slot.offset);
                slot.var_name = std::format("var_{:x}",
                    absOffset);
            } else if (slot.offset == 0) {
                slot.var_name = (slot.base == StackAccessBase::Rbp)
                    ? "saved_rbp"
                    : "var_0";
            } else {
                unsigned paramIdx = isWin64
                    ? getWin64ParamIndex(slot.offset, slot.base,
                                         win64RbpStackParamBase)
                    : 0;
                if (slot.base == StackAccessBase::Rsp &&
                    nonParameterSlots.contains(key)) {
                    paramIdx = 0;
                }
                if (paramIdx > 0) {
                    slot.var_name = std::format("param_{}", paramIdx);
                    slot.is_parameter = true;
                } else {
                    slot.var_name = std::format("var_{:x}",
                        static_cast<uint64_t>(slot.offset));
                }
            }
        }

        // Phase 3: Emit helix_high.var.decl at function entry.
        OpBuilder builder(func->getContext());
        auto& entryBlock = func.getBody().front();
        builder.setInsertionPointToStart(&entryBlock);

        std::map<SlotKey, std::pair<uint32_t, std::string>> offsetToVar;
        uint32_t varId = getNextAvailableVarId(func);

        for (auto& [key, slot] : sortedSlots) {
            auto storageKind = slot.is_parameter
                ? helix::high::StorageKind::Parameter
                : helix::high::StorageKind::Stack;

            auto declOp = builder.create<helix::high::VarDeclOp>(
                func.getLoc(),
                builder.getUI32IntegerAttr(varId),
                builder.getStringAttr(slot.var_name),
                helix::high::StorageKindAttr::get(
                    builder.getContext(), storageKind),
                builder.getI64IntegerAttr(slot.offset),
                /*init=*/Value{},
                /*address=*/IntegerAttr{});

            offsetToVar[key] = {varId, declOp.getVarName().str()};
            varId++;
        }
        // Phase 4: Replace resolved stack/local references with high vars.
        for (auto& [op, key] : resolvedAccessOps) {
            auto it = offsetToVar.find(key);
            if (it == offsetToVar.end())
                continue;

            auto [vid, vname] = it->second;
            builder.setInsertionPoint(op);

            if (auto load = dyn_cast<LLVM::LoadOp>(op)) {
                auto varRef = builder.create<helix::high::VarRefOp>(
                    load.getLoc(),
                    load.getResult().getType(),
                    builder.getUI32IntegerAttr(vid),
                    builder.getStringAttr(vname),
                    /*address=*/IntegerAttr{});
                load.getResult().replaceAllUsesWith(varRef.getResult());
                load.erase();
            } else if (auto memRead = dyn_cast<helix::low::MemReadOp>(op)) {
                auto varRef = builder.create<helix::high::VarRefOp>(
                    memRead.getLoc(),
                    memRead.getResult().getType(),
                    builder.getUI32IntegerAttr(vid),
                    builder.getStringAttr(vname),
                    /*address=*/IntegerAttr{});
                memRead.getResult().replaceAllUsesWith(varRef.getResult());
                memRead.erase();
            } else if (auto store = dyn_cast<LLVM::StoreOp>(op)) {
                auto varRef = builder.create<helix::high::VarRefOp>(
                    store.getLoc(),
                    store.getValue().getType(),
                    builder.getUI32IntegerAttr(vid),
                    builder.getStringAttr(vname),
                    /*address=*/IntegerAttr{});
                builder.create<helix::high::AssignOp>(
                    store.getLoc(),
                    varRef.getResult(),
                    store.getValue(),
                    /*address=*/IntegerAttr{});
                store.erase();
            } else if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
                auto varRef = builder.create<helix::high::VarRefOp>(
                    memWrite.getLoc(),
                    memWrite.getValue().getType(),
                    builder.getUI32IntegerAttr(vid),
                    builder.getStringAttr(vname),
                    /*address=*/IntegerAttr{});
                builder.create<helix::high::AssignOp>(
                    memWrite.getLoc(),
                    varRef.getResult(),
                    memWrite.getValue(),
                    /*address=*/IntegerAttr{});
                memWrite.erase();
            }
        }
    }
    std::optional<StackAccessInfo> analyzeStackAccess(Value addr) {
        addr = unwrapPointerLikeValue(addr);

        if (auto base = getStackBase(addr))
            return StackAccessInfo{0, *base};

        if (auto add = addr.getDefiningOp<LLVM::AddOp>()) {
            if (auto base = getStackBase(add.getLhs())) {
                if (auto offset = getIntegerOffset(add.getRhs()))
                    return StackAccessInfo{*offset, *base};
            }
            if (auto base = getStackBase(add.getRhs())) {
                if (auto offset = getIntegerOffset(add.getLhs()))
                    return StackAccessInfo{*offset, *base};
            }
        }

        if (auto sub = addr.getDefiningOp<LLVM::SubOp>()) {
            if (auto base = getStackBase(sub.getLhs())) {
                if (auto offset = getIntegerOffset(sub.getRhs()))
                    return StackAccessInfo{-*offset, *base};
            }
        }

        if (auto binop = addr.getDefiningOp<helix::low::BinOp>()) {
            auto kind = binop.getKind();
            if (kind != helix::low::BinOpKind::Add &&
                kind != helix::low::BinOpKind::Sub)
                return std::nullopt;
            auto base = getStackBase(binop.getLhs());
            auto offset = getIntegerOffset(binop.getRhs());
            if (!base || !offset)
                return std::nullopt;

            int64_t signedOffset = *offset;
            if (kind == helix::low::BinOpKind::Sub)
                signedOffset = -signedOffset;
            return StackAccessInfo{signedOffset, *base};
        }
        if (auto lea = addr.getDefiningOp<helix::low::LeaOp>()) {
            if (auto base = getStackBase(lea.getBase()))
                return StackAccessInfo{lea.getDisplacement(), *base};
        }
        return std::nullopt;
    }

    std::optional<StackAccessInfo> analyzeLocalPattern(Value addr) {
        addr = unwrapPointerLikeValue(addr);
        if (auto gep = addr.getDefiningOp<LLVM::GEPOp>()) {
            if (isa_and_nonnull<LLVM::AllocaOp>(gep.getBase().getDefiningOp())) {
                auto offset = getGepConstantOffset(gep);
                if (offset) return StackAccessInfo{*offset, StackAccessBase::Local};
            }
        }
        if (isa_and_nonnull<LLVM::AllocaOp>(addr.getDefiningOp()))
            return StackAccessInfo{0, StackAccessBase::Local};
        return std::nullopt;
    }

    bool isLocalPattern(Value addr) {
        addr = unwrapPointerLikeValue(addr);
        if (auto gep = addr.getDefiningOp<LLVM::GEPOp>())
            if (isa_and_nonnull<LLVM::AllocaOp>(gep.getBase().getDefiningOp()))
                return true;
        if (isa_and_nonnull<LLVM::AllocaOp>(addr.getDefiningOp()))
            return true;
        return false;
    }

    std::optional<int64_t> getGepConstantOffset(LLVM::GEPOp gep) {
        auto dynIndices = gep.getDynamicIndices();
        auto rawConstIndices = gep.getRawConstantIndices();
        int64_t totalOffset = 0;
        for (auto idx : rawConstIndices) {
            if (idx == LLVM::GEPOp::kDynamicIndex) {
                if (dynIndices.empty()) return std::nullopt;
                auto dynVal = dynIndices.front();
                dynIndices = dynIndices.drop_front();
                if (auto intLit = dynVal.getDefiningOp<helix::high::IntLitOp>()) {
                    totalOffset += intLit.getValue();
                } else if (auto constOp = dynVal.getDefiningOp<LLVM::ConstantOp>()) {
                    if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                        totalOffset += intAttr.getInt();
                    else
                        return std::nullopt;
                } else {
                    return std::nullopt;
                }
            } else {
                totalOffset += idx;
            }
        }
        return totalOffset;
    }
};

} // anonymous namespace

std::unique_ptr<mlir::Pass> helix::createRecoverStackLayoutPass() {
    return std::make_unique<RecoverStackLayoutPass>();
}
