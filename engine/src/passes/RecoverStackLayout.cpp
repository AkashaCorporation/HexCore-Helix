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

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#include <algorithm>
#include <format>
#include <string>

#define DEBUG_TYPE "recover-stack-layout"

using namespace mlir;
using namespace helix;

namespace {

/// Win64 parameter offsets from RBP/RSP (positive offsets in the caller's frame).
struct Win64ParamSlot {
    int64_t offset;
    unsigned param_index;
};

static constexpr Win64ParamSlot kWin64Params[] = {
    {0x8,  1},
    {0x10, 2},
    {0x18, 3},
    {0x20, 4},
};

/// Information about a discovered stack slot.
struct StackSlot {
    int64_t offset;
    unsigned bit_width;
    bool is_rbp_relative;
    unsigned access_count;
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

/// Check if a positive offset corresponds to a Win64 parameter position.
static unsigned getWin64ParamIndex(int64_t offset) {
    for (const auto& param : kWin64Params) {
        if (param.offset == offset)
            return param.param_index;
    }
    return 0;
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
        bool is_rbp_relative;
    };
    void recoverStackLayout(helix::low::FuncOp func) {
        llvm::DenseMap<int64_t, StackSlot> slots;
        llvm::SmallVector<std::pair<Operation*, int64_t>> localPatternOps;
        llvm::SmallVector<Operation*> unresolvedOps;

        func.walk([&](Operation* op) {
            if (auto memRead = dyn_cast<helix::low::MemReadOp>(op)) {
                auto info = analyzeStackAccess(memRead.getAddr());
                if (info) {
                    auto& slot = slots[info->offset];
                    slot.offset = info->offset;
                    slot.bit_width = std::max(slot.bit_width,
                        static_cast<unsigned>(memRead.getBitWidth()));
                    slot.is_rbp_relative = info->is_rbp_relative;
                    slot.access_count++;
                }
            }
            if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
                auto info = analyzeStackAccess(memWrite.getAddr());
                if (info) {
                    auto& slot = slots[info->offset];
                    slot.offset = info->offset;
                    slot.bit_width = std::max(slot.bit_width,
                        static_cast<unsigned>(memWrite.getBitWidth()));
                    slot.is_rbp_relative = info->is_rbp_relative;
                    slot.access_count++;
                }
            }
            // Resolve *(&__local) patterns: LLVM LoadOp/StoreOp through
            // AllocaOp+GEP with constant offsets.
            if (auto load = dyn_cast<LLVM::LoadOp>(op)) {
                auto info = analyzeLocalPattern(load.getAddr());
                if (info) {
                    auto& slot = slots[info->offset];
                    slot.offset = info->offset;
                    slot.bit_width = std::max(slot.bit_width,
                        inferBitWidthFromType(load.getResult().getType()));
                    slot.is_rbp_relative = info->is_rbp_relative;
                    slot.access_count++;
                    localPatternOps.push_back({op, info->offset});
                } else if (isLocalPattern(load.getAddr())) {
                    unresolvedOps.push_back(op);
                }
            }
            if (auto store = dyn_cast<LLVM::StoreOp>(op)) {
                auto info = analyzeLocalPattern(store.getAddr());
                if (info) {
                    auto& slot = slots[info->offset];
                    slot.offset = info->offset;
                    slot.bit_width = std::max(slot.bit_width,
                        inferBitWidthFromType(store.getValue().getType()));
                    slot.is_rbp_relative = info->is_rbp_relative;
                    slot.access_count++;
                    localPatternOps.push_back({op, info->offset});
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
        llvm::SmallVector<StackSlot> sortedSlots;
        for (auto& [offset, slot] : slots)
            sortedSlots.push_back(slot);
        llvm::sort(sortedSlots, [](const StackSlot& a, const StackSlot& b) {
            return a.offset < b.offset;
        });

        for (auto& slot : sortedSlots) {
            slot.c_type = inferCType(slot.bit_width);
            if (slot.offset < 0) {
                slot.var_name = std::format("var_{:x}",
                    static_cast<uint64_t>(-slot.offset));
            } else if (slot.offset == 0) {
                slot.var_name = "saved_rbp";
            } else {
                unsigned paramIdx = getWin64ParamIndex(slot.offset);
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

        llvm::DenseMap<int64_t, std::pair<uint32_t, StringRef>> offsetToVar;
        uint32_t varId = 0;

        for (auto& slot : sortedSlots) {
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

            offsetToVar[slot.offset] = {varId, declOp.getVarName()};
            varId++;
        }
        // Phase 4: Replace *(&__local) references with helix_high.var.ref.
        for (auto& [op, offset] : localPatternOps) {
            auto it = offsetToVar.find(offset);
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
            }
        }
    }
    std::optional<StackAccessInfo> analyzeStackAccess(Value addr) {
        if (auto regRead = addr.getDefiningOp<helix::low::RegReadOp>()) {
            auto regName = regRead.getRegName();
            if (regName == "RSP") return StackAccessInfo{0, false};
            if (regName == "RBP") return StackAccessInfo{0, true};
        }
        if (auto binop = addr.getDefiningOp<helix::low::BinOp>()) {
            auto kind = binop.getKind();
            if (kind != helix::low::BinOpKind::Add &&
                kind != helix::low::BinOpKind::Sub)
                return std::nullopt;
            auto regRead = binop.getLhs().getDefiningOp<helix::low::RegReadOp>();
            if (!regRead) return std::nullopt;
            auto regName = regRead.getRegName();
            bool isRbp = (regName == "RBP");
            bool isRsp = (regName == "RSP");
            if (!isRbp && !isRsp) return std::nullopt;
            if (auto intLit = binop.getRhs().getDefiningOp<helix::high::IntLitOp>()) {
                int64_t offset = intLit.getValue();
                if (kind == helix::low::BinOpKind::Sub) offset = -offset;
                return StackAccessInfo{offset, isRbp};
            }
        }
        if (auto lea = addr.getDefiningOp<helix::low::LeaOp>()) {
            auto regRead = lea.getBase().getDefiningOp<helix::low::RegReadOp>();
            if (!regRead) return std::nullopt;
            auto regName = regRead.getRegName();
            bool isRbp = (regName == "RBP");
            bool isRsp = (regName == "RSP");
            if (!isRbp && !isRsp) return std::nullopt;
            return StackAccessInfo{lea.getDisplacement(), isRbp};
        }
        return std::nullopt;
    }

    std::optional<StackAccessInfo> analyzeLocalPattern(Value addr) {
        if (auto gep = addr.getDefiningOp<LLVM::GEPOp>()) {
            if (isa_and_nonnull<LLVM::AllocaOp>(gep.getBase().getDefiningOp())) {
                auto offset = getGepConstantOffset(gep);
                if (offset) return StackAccessInfo{*offset, false};
            }
        }
        if (isa_and_nonnull<LLVM::AllocaOp>(addr.getDefiningOp()))
            return StackAccessInfo{0, false};
        return std::nullopt;
    }

    bool isLocalPattern(Value addr) {
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