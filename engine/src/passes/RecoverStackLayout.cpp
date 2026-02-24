/// @file RecoverStackLayout.cpp
/// @brief Stack layout recovery pass: HelixLow memory accesses → stack variables.
///
/// Scans for RSP/RBP-relative memory accesses (helix_low.mem.read / mem.write
/// with a base register of RSP or RBP) and creates helix_high.var.decl operations
/// for each unique stack offset. Variable types are inferred from access widths.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"

#include <algorithm>
#include <format>
#include <string>

using namespace mlir;
using namespace helix;

namespace {

/// Information about a discovered stack slot.
struct StackSlot {
    int64_t offset;          // Offset from RSP/RBP
    unsigned bit_width;      // Access width (8, 16, 32, 64)
    bool is_rbp_relative;    // true = RBP-relative, false = RSP-relative
    unsigned access_count;   // Number of accesses (reads + writes)
    std::string var_name;    // Generated variable name
};

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
    void recoverStackLayout(helix::low::FuncOp func) {
        // Phase 1: Scan all memory accesses to discover stack slots.
        llvm::DenseMap<int64_t, StackSlot> slots;

        func.walk([&](Operation* op) {
            // Check for reg.read of RSP/RBP followed by arithmetic to compute
            // a stack address, which is then used in mem.read/mem.write.
            // In the HelixLow IR, stack accesses appear as:
            //   %rsp = helix_low.reg.read "RSP", 64
            //   %addr = helix_low.binop add %rsp, <imm_offset>
            //   helix_low.mem.read %addr, <width>
            //   helix_low.mem.write %addr, %val, <width>
            //
            // We also recognize direct RSP/RBP+constant patterns from LEA ops.

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
        });

        if (slots.empty())
            return;

        // Phase 2: Sort slots by offset and assign names.
        llvm::SmallVector<StackSlot> sortedSlots;
        for (auto& [offset, slot] : slots) {
            sortedSlots.push_back(slot);
        }
        llvm::sort(sortedSlots, [](const StackSlot& a, const StackSlot& b) {
            return a.offset < b.offset;
        });

        // Name variables: var_N for negative offsets (locals), arg_N for positive (args)
        unsigned localIdx = 0;
        unsigned argIdx = 0;
        for (auto& slot : sortedSlots) {
            if (slot.offset < 0) {
                slot.var_name = std::format("var_{:x}",
                    static_cast<uint64_t>(-slot.offset));
                localIdx++;
            } else if (slot.offset == 0) {
                slot.var_name = "saved_rbp";
            } else {
                // Positive offset from RBP = return address or caller's frame
                // Positive offset from RSP = argument spill area (Win64)
                slot.var_name = std::format("arg_{:x}",
                    static_cast<uint64_t>(slot.offset));
                argIdx++;
            }
        }

        // Phase 3: Emit helix_high.var.decl at function entry.
        OpBuilder builder(func->getContext());
        auto& entryBlock = func.getBody().front();
        builder.setInsertionPointToStart(&entryBlock);

        uint32_t varId = 0;
        for (auto& slot : sortedSlots) {
            auto storageKind = (slot.offset >= 8)
                ? helix::high::StorageKind::Parameter
                : helix::high::StorageKind::Stack;

            builder.create<helix::high::VarDeclOp>(
                func.getLoc(),
                builder.getUI32IntegerAttr(varId++),
                builder.getStringAttr(slot.var_name),
                helix::high::StorageKindAttr::get(
                    builder.getContext(), storageKind),
                builder.getSI64IntegerAttr(slot.offset),
                /*init=*/Value{},
                /*address=*/IntegerAttr{});
        }
    }

    /// Result of analyzing a memory address for stack access patterns.
    struct StackAccessInfo {
        int64_t offset;
        bool is_rbp_relative;
    };

    /// Analyze a Value to determine if it's a stack-relative address.
    std::optional<StackAccessInfo> analyzeStackAccess(Value addr) {
        // Pattern 1: Direct reg.read of RSP/RBP (offset = 0)
        if (auto regRead = addr.getDefiningOp<helix::low::RegReadOp>()) {
            auto regName = regRead.getRegName();
            if (regName == "RSP")
                return StackAccessInfo{0, false};
            if (regName == "RBP")
                return StackAccessInfo{0, true};
        }

        // Pattern 2: binop add/sub of RSP/RBP with a constant offset
        if (auto binop = addr.getDefiningOp<helix::low::BinOp>()) {
            auto kind = binop.getKind();
            if (kind != helix::low::BinOpKind::Add &&
                kind != helix::low::BinOpKind::Sub)
                return std::nullopt;

            // Check if LHS is a register read of RSP/RBP
            auto regRead = binop.getLhs().getDefiningOp<helix::low::RegReadOp>();
            if (!regRead)
                return std::nullopt;

            auto regName = regRead.getRegName();
            bool isRbp = (regName == "RBP");
            bool isRsp = (regName == "RSP");
            if (!isRbp && !isRsp)
                return std::nullopt;

            // Check if RHS is a constant (from int.lit or a reg.read of a known const)
            if (auto intLit = binop.getRhs().getDefiningOp<helix::high::IntLitOp>()) {
                int64_t offset = intLit.getValue();
                if (kind == helix::low::BinOpKind::Sub)
                    offset = -offset;
                return StackAccessInfo{offset, isRbp};
            }
        }

        // Pattern 3: LEA with RSP/RBP base
        if (auto lea = addr.getDefiningOp<helix::low::LeaOp>()) {
            auto regRead = lea.getBase().getDefiningOp<helix::low::RegReadOp>();
            if (!regRead)
                return std::nullopt;

            auto regName = regRead.getRegName();
            bool isRbp = (regName == "RBP");
            bool isRsp = (regName == "RSP");
            if (!isRbp && !isRsp)
                return std::nullopt;

            return StackAccessInfo{lea.getDisplacement(), isRbp};
        }

        return std::nullopt;
    }
};

} // anonymous namespace

std::unique_ptr<mlir::Pass> helix::createRecoverStackLayoutPass() {
    return std::make_unique<RecoverStackLayoutPass>();
}
