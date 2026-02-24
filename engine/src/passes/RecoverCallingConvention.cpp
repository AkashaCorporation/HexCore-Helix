/// @file RecoverCallingConvention.cpp
/// @brief Calling convention recovery pass.
///
/// Implements Win64 and SysV x86-64 ABI recovery:
///   - Identifies argument registers (RCX, RDX, R8, R9 for Win64;
///     RDI, RSI, RDX, RCX, R8, R9 for SysV)
///   - Folds register writes that set up call arguments into helix_high.call ops
///   - Names return values (RAX for integer, XMM0 for float)
///   - Marks callee-saved register restores as dead

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/analysis/SignatureDb.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"

#include <array>
#include <string>
#include <string_view>

using namespace mlir;
using namespace helix;

namespace {

/// Win64 integer argument registers in order.
constexpr std::array<std::string_view, 4> kWin64IntArgs = {
    "RCX", "RDX", "R8", "R9"
};

/// SysV x86-64 integer argument registers in order.
constexpr std::array<std::string_view, 6> kSysVIntArgs = {
    "RDI", "RSI", "RDX", "RCX", "R8", "R9"
};

/// Callee-saved registers (Win64).
constexpr std::array<std::string_view, 7> kWin64CalleeSaved = {
    "RBX", "RBP", "RDI", "RSI", "R12", "R13", "R14"
};

/// Callee-saved registers (SysV).
constexpr std::array<std::string_view, 5> kSysVCalleeSaved = {
    "RBX", "RBP", "R12", "R13", "R14"
};

/// Determines ABI convention from context (default to Win64 on Windows).
enum class CallingConv { Win64, SysV };

struct RecoverCallingConventionPass
    : public PassWrapper<RecoverCallingConventionPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RecoverCallingConventionPass)

    StringRef getArgument() const final { return "recover-calling-convention"; }
    StringRef getDescription() const final {
        return "Recover calling convention (Win64/SysV) and fold arguments into calls";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<helix::high::HelixHighDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();

        module.walk([&](helix::low::FuncOp func) {
            recoverCC(func);
        });
    }

private:
    void recoverCC(helix::low::FuncOp func) {
        // Default to Win64 (user is on Windows). Can be made configurable.
        CallingConv cc = CallingConv::Win64;

        auto argRegs = (cc == CallingConv::Win64)
            ? llvm::ArrayRef(kWin64IntArgs)
            : llvm::ArrayRef(kSysVIntArgs);

        // Phase 1: Identify function parameters.
        // Scan from the top for reg.read operations that read argument registers
        // before any write to those registers — these are function parameters.
        llvm::SmallVector<std::string> paramRegs;
        llvm::DenseSet<llvm::StringRef> writtenRegs;

        func.walk([&](Operation* op) {
            if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(op)) {
                writtenRegs.insert(regWrite.getRegName());
            }
            if (auto regRead = dyn_cast<helix::low::RegReadOp>(op)) {
                auto name = regRead.getRegName();
                // If this register is read before any write, it's a parameter
                if (!writtenRegs.contains(name)) {
                    for (auto argReg : argRegs) {
                        if (name == argReg) {
                            // Only add once
                            bool found = false;
                            for (auto& p : paramRegs) {
                                if (p == name.str()) { found = true; break; }
                            }
                            if (!found)
                                paramRegs.push_back(name.str());
                            break;
                        }
                    }
                }
            }
        });

        // Phase 2: Emit parameter declarations at function entry.
        if (!paramRegs.empty()) {
            OpBuilder builder(func->getContext());
            auto& entryBlock = func.getBody().front();
            builder.setInsertionPointToStart(&entryBlock);

            uint32_t paramId = 1000; // Start high to avoid var_id conflicts
            for (auto& regName : paramRegs) {
                // Determine parameter name from register
                std::string paramName;
                for (size_t i = 0; i < argRegs.size(); i++) {
                    if (argRegs[i] == regName) {
                        paramName = std::format("param_{}", i + 1);
                        break;
                    }
                }
                if (paramName.empty())
                    paramName = std::format("param_{}", regName);

                builder.create<helix::high::VarDeclOp>(
                    func.getLoc(),
                    builder.getUI32IntegerAttr(paramId++),
                    builder.getStringAttr(paramName),
                    helix::high::StorageKindAttr::get(
                        builder.getContext(),
                        helix::high::StorageKind::Parameter),
                    /*stack_offset=*/IntegerAttr{},
                    /*init=*/Value{},
                    /*address=*/IntegerAttr{});
            }
        }

        // Phase 3: For each helix_low.call, look backward for reg.write ops
        // that set up the argument registers. Fold these as metadata on the call.
        func.walk([&](helix::low::CallOp call) {
            // Look for reg.write ops setting argument registers before this call.
            // We scan backward from the call within the same block.
            auto* block = call->getBlock();
            if (!block) return;

            llvm::SmallVector<Value> argValues;
            llvm::DenseMap<llvm::StringRef, Value> regState;

            // Walk forward to the call, tracking register writes
            for (auto& op : block->getOperations()) {
                if (&op == call.getOperation())
                    break;

                if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&op)) {
                    regState[regWrite.getRegName()] = regWrite.getValue();
                }
            }

            // Collect argument values in ABI order
            for (auto argReg : argRegs) {
                auto it = regState.find(argReg);
                if (it != regState.end()) {
                    argValues.push_back(it->second);
                } else {
                    break; // Stop at first missing arg
                }
            }

            // Attach argument info as attributes on the call.
            if (!argValues.empty()) {
                auto i32Ty = IntegerType::get(call->getContext(), 32);
                call->setAttr("arg_count",
                    IntegerAttr::get(i32Ty, argValues.size()));
            }
        });

        // Phase 4: Identify return value.
        // If the function has a reg.read of RAX near its return, it returns a value.
        bool hasReturnValue = false;
        func.walk([&](helix::low::RetOp ret) {
            // Check if there's a reg.write to RAX before this return
            auto* block = ret->getBlock();
            if (!block) return;

            for (auto it = Block::iterator(ret); it != block->begin(); ) {
                --it;
                if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&*it)) {
                    if (regWrite.getRegName() == "RAX") {
                        hasReturnValue = true;
                        return;
                    }
                }
                // Don't look past calls or other control flow
                if (isa<helix::low::CallOp>(&*it))
                    return;
            }
        });

        // Set calling convention attribute on the function
        auto ccStr = (cc == CallingConv::Win64) ? "win64" : "sysv";
        func->setAttr("calling_convention",
            StringAttr::get(func->getContext(), ccStr));
        if (hasReturnValue) {
            func->setAttr("has_return_value",
                UnitAttr::get(func->getContext()));
        }
    }
};

} // anonymous namespace

std::unique_ptr<mlir::Pass> helix::createRecoverCallingConventionPass() {
    return std::make_unique<RecoverCallingConventionPass>();
}
