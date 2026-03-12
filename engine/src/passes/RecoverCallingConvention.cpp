/// @file RecoverCallingConvention.cpp
/// @brief Calling convention recovery pass.
///
/// Implements Win64 and SysV x86-64 ABI recovery:
///   - Identifies argument registers (RCX, RDX, R8, R9 for Win64;
///     RDI, RSI, RDX, RCX, R8, R9 for SysV)
///   - Folds register writes that set up call arguments into helix_high.call ops
///   - Names return values (RAX for integer, XMM0 for float)
///   - Marks callee-saved register restores as dead
///
/// NOTE: DominanceInfo is intentionally not used for block scanning here.
/// domInfo.getNode() crashes on certain IR patterns (massive single-block
/// functions, nested regions) in MLIR 18.x. The block scan + predecessor
/// search covers all common calling convention patterns without dominator trees.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/analysis/X86RegisterInfo.h"
#include "helix/analysis/SignatureDb.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"

#include <array>
#include <algorithm>
#include <format>
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

static uint32_t getNextAvailableVarId(helix::low::FuncOp func) {
    uint32_t nextId = 0;
    func.walk([&](helix::high::VarDeclOp decl) {
        nextId = std::max(nextId, decl.getVarId() + 1);
    });
    return nextId;
}

static bool isReturnRegisterWrite(Operation& op) {
    auto regWrite = dyn_cast<helix::low::RegWriteOp>(&op);
    if (!regWrite)
        return false;

    return helix::analysis::isX86GeneralPurposeReturnRegister(
               regWrite.getRegName()) ||
           regWrite.getRegName().upper() == "XMM0";
}

static bool hasReturnRegisterWriteInBlock(
    Block* block, Block::iterator endIt) {
    if (!block)
        return false;

    for (auto it = endIt; it != block->begin();) {
        --it;
        if (isReturnRegisterWrite(*it))
            return true;

        if (isa<helix::low::CallOp>(&*it))
            return false;
    }

    return false;
}

static std::optional<Value> findLatestRegWriteInBlock(
    Block* block, Block::iterator endIt, llvm::StringRef canonicalReg) {
    if (!block)
        return std::nullopt;

    for (auto it = endIt; it != block->begin();) {
        --it;
        auto regWrite = dyn_cast<helix::low::RegWriteOp>(&*it);
        if (!regWrite)
            continue;

        auto lookup =
            helix::analysis::getCanonicalX86Register(regWrite.getRegName());
        if (lookup.empty())
            lookup = regWrite.getRegName();
        if (lookup == canonicalReg)
            return regWrite.getValue();
    }

    return std::nullopt;
}

static std::optional<Value> findLatestRegWriteInPredecessors(
    Block* block, llvm::StringRef canonicalReg, unsigned depth,
    llvm::DenseSet<Block*>& visiting) {
    if (!block || depth == 0 || !visiting.insert(block).second)
        return std::nullopt;

    std::optional<Value> candidate;
    for (Block* pred : block->getPredecessors()) {
        auto value = findLatestRegWriteInBlock(pred, pred->end(), canonicalReg);
        if (!value) {
            value = findLatestRegWriteInPredecessors(
                pred, canonicalReg, depth - 1, visiting);
        }
        if (!value) {
            visiting.erase(block);
            return std::nullopt;
        }
        if (candidate && *candidate != *value) {
            visiting.erase(block);
            return std::nullopt;
        }
        candidate = *value;
    }

    visiting.erase(block);
    return candidate;
}

/// Collect argument values for a call by scanning the block before `beforeOp`
/// and predecessor blocks. Does not use DominanceInfo (which can crash on
/// large/unusual IR in MLIR 18.x); the block scan + predecessor search covers
/// all common ABI call patterns.
static llvm::SmallVector<Value, 6> collectAbiCallArgs(
    Operation* beforeOp, llvm::ArrayRef<std::string_view> argRegs,
    unsigned predecessorDepth = 2) {
    auto* block = beforeOp ? beforeOp->getBlock() : nullptr;
    if (!block)
        return {};

    // Build a map of the most recent register write before beforeOp.
    llvm::DenseMap<llvm::StringRef, Value> regState;
    for (auto& op : block->getOperations()) {
        if (&op == beforeOp)
            break;

        auto regWrite = dyn_cast<helix::low::RegWriteOp>(&op);
        if (!regWrite)
            continue;

        auto lookup =
            helix::analysis::getCanonicalX86Register(regWrite.getRegName());
        if (lookup.empty())
            lookup = regWrite.getRegName();
        regState[lookup] = regWrite.getValue();
    }

    llvm::SmallVector<Value, 6> argValues;
    for (auto argReg : argRegs) {
        llvm::StringRef key(argReg);
        auto it = regState.find(key);
        if (it == regState.end()) {
            // Not in the current block — check predecessor blocks.
            llvm::DenseSet<Block*> visiting;
            auto fromPreds = findLatestRegWriteInPredecessors(
                block, key, predecessorDepth, visiting);
            if (!fromPreds)
                break;
            regState[key] = *fromPreds;
            it = regState.find(key);
        }
        argValues.push_back(it->second);
    }

    return argValues;
}

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
        llvm::SmallVector<unsigned> paramIndices;
        llvm::DenseSet<llvm::StringRef> writtenRegs;
        llvm::DenseSet<unsigned> seenParamIndices;

        func.walk([&](Operation* op) {
            if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(op)) {
                auto canonical =
                    helix::analysis::getCanonicalX86Register(regWrite.getRegName());
                if (!canonical.empty())
                    writtenRegs.insert(canonical);
                else
                    writtenRegs.insert(regWrite.getRegName());
            }
            if (auto regRead = dyn_cast<helix::low::RegReadOp>(op)) {
                auto canonical =
                    helix::analysis::getCanonicalX86Register(regRead.getRegName());
                auto lookup = canonical.empty() ? regRead.getRegName() : canonical;
                auto paramIndex =
                    helix::analysis::getX86ArgumentRegisterIndex(lookup, argRegs);
                if (paramIndex && !writtenRegs.contains(lookup) &&
                    seenParamIndices.insert(*paramIndex).second) {
                    paramIndices.push_back(*paramIndex);
                }
            }
        });
        llvm::sort(paramIndices);

        // Phase 2: Emit parameter declarations at function entry.
        if (!paramIndices.empty()) {
            OpBuilder builder(func->getContext());
            auto& entryBlock = func.getBody().front();
            builder.setInsertionPointToStart(&entryBlock);

            uint32_t paramId = getNextAvailableVarId(func);
            llvm::DenseSet<llvm::StringRef> existingParams;
            func.walk([&](helix::high::VarDeclOp decl) {
                if (decl.getStorage() == helix::high::StorageKind::Parameter)
                    existingParams.insert(decl.getVarName());
            });

            for (auto paramIndex : paramIndices) {
                auto paramName = std::format("param_{}", paramIndex);
                if (existingParams.contains(paramName))
                    continue;

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

        // Phase 3: Materialize ABI argument values directly on helix_low.call.
        llvm::SmallVector<helix::low::CallOp, 16> calls;
        func.walk([&](helix::low::CallOp call) { calls.push_back(call); });

        for (auto call : calls) {
            auto targetName = call.getTargetName();
            const bool isDirectNamedCall =
                targetName.has_value() && targetName->starts_with("sub_");
            auto argValues =
                collectAbiCallArgs(call.getOperation(), argRegs);
            auto existingArgs = call.getArgs();
            const bool canMaterializeArgs =
                isDirectNamedCall || existingArgs.empty();

            bool differs = existingArgs.size() != argValues.size();
            if (!differs) {
                auto existingIt = existingArgs.begin();
                auto recoveredIt = argValues.begin();
                for (; existingIt != existingArgs.end() &&
                       recoveredIt != argValues.end();
                     ++existingIt, ++recoveredIt) {
                    if (*existingIt != *recoveredIt) {
                        differs = true;
                        break;
                    }
                }
            }

            if (canMaterializeArgs && !argValues.empty() &&
                (existingArgs.empty() || argValues.size() > existingArgs.size()) &&
                differs) {
                call.getArgsMutable().assign(argValues);
                existingArgs = call.getArgs();
            }

            auto i32Ty = IntegerType::get(call->getContext(), 32);
            call->setAttr("arg_count",
                IntegerAttr::get(i32Ty, existingArgs.size()));
        }

        // Phase 4: Identify return value.
        // If the function has a reg.write to RAX/XMM0 before its return, it
        // returns a value.
        bool hasReturnValue = false;
        func.walk([&](helix::low::RetOp ret) {
            // Check if there's a reg.write to RAX before this return
            auto* block = ret->getBlock();
            if (!block) return;

            if (hasReturnRegisterWriteInBlock(block, Block::iterator(ret))) {
                hasReturnValue = true;
                return;
            }

            // Common epilogue pattern: the return register is written in an
            // immediate predecessor block, then control transfers to a shared
            // return block containing only the final RET.
            llvm::SmallVector<std::pair<Block*, unsigned>, 4> worklist;
            llvm::DenseSet<Block*> visited;
            for (Block* pred : block->getPredecessors())
                worklist.push_back({pred, 0u});

            while (!worklist.empty()) {
                auto [candidate, depth] = worklist.pop_back_val();
                if (!candidate || !visited.insert(candidate).second)
                    continue;

                if (hasReturnRegisterWriteInBlock(candidate, candidate->end())) {
                    hasReturnValue = true;
                    return;
                }

                if (depth >= 1)
                    continue;

                for (Block* pred : candidate->getPredecessors())
                    worklist.push_back({pred, depth + 1});
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
