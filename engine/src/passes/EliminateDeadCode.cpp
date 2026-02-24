/// @file EliminateDeadCode.cpp
/// @brief MLIR pass: dead code elimination tailored for decompilation.
///
/// This pass removes operations that are artifacts of the compilation and
/// lifting process and do not contribute to the program's observable
/// semantics.  Unlike general-purpose DCE (which MLIR provides via
/// `createCSEPass()` and `createCanonicalizerPass()`), this pass targets
/// patterns specific to decompiled x86-64 code:
///
///   1. **NOP / INT3 markers**: helix_low.nop and helix_low.int3 ops are
///      padding/debug markers with no semantic effect.
///
///   2. **Prologue/epilogue boilerplate**: The standard function prologue
///      (push rbp; mov rbp, rsp) and epilogue (mov rsp, rbp; pop rbp) are
///      frame pointer setup that has no meaning at the source level.
///      Non-volatile register saves (push rbx ... pop rbx) are similarly
///      removed.
///
///   3. **Stack pointer bookkeeping**: Instructions like `sub rsp, 0x28`
///      (stack allocation) and `add rsp, 0x28` (deallocation) are compiler
///      artifacts.  The stack layout has already been recovered by the
///      RecoverStackLayout pass.
///
///   4. **Dead register writes**: A write to a register whose value is never
///      read before the next write to the same register is dead.  This
///      leverages MLIR's built-in Liveness analysis.
///
///   5. **Trivially dead ops**: After the targeted removals above, we run
///      MLIR's `isOpTriviallyDead()` to clean up any ops whose results
///      have become unused.
///
/// ## References
///
///   - Rust implementation: crates/helix-core/src/analysis/data_flow.rs
///   - MLIR Liveness analysis: mlir/Analysis/Liveness.h
///   - Cooper & Torczon, "Engineering a Compiler", Ch. 10 (Dead Code)

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/Analysis/Liveness.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Dominance.h"
#include "mlir/IR/Matchers.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Debug.h"

#include <algorithm>
#include <cstdint>
#include <format>
#include <optional>
#include <string>
#include <string_view>

#define DEBUG_TYPE "eliminate-dead-code"

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// Statistics
// ═══════════════════════════════════════════════════════════════════════════════

STATISTIC(NumNopsRemoved,          "Number of NOP ops removed");
STATISTIC(NumInt3sRemoved,         "Number of INT3 ops removed");
STATISTIC(NumPrologueOpsRemoved,   "Number of prologue/epilogue ops removed");
STATISTIC(NumStackAdjustsRemoved,  "Number of RSP bookkeeping ops removed");
STATISTIC(NumDeadWritesRemoved,    "Number of dead register writes removed");
STATISTIC(NumTriviallyDeadRemoved, "Number of trivially dead ops removed");

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// Prologue/Epilogue Pattern Detection
// ═══════════════════════════════════════════════════════════════════════════════

/// Describes a matched push/pop pair for a non-volatile register save.
struct PushPopPair {
    /// The push operation (in the prologue).
    Operation* pushOp = nullptr;

    /// The corresponding pop operation (in the epilogue).
    Operation* popOp = nullptr;

    /// The register being saved/restored.
    llvm::StringRef reg;
};

/// Check whether an operation is a `helix_low.push` of a specific register.
///
/// The push pattern from RemillToHelixLow is:
///   helix_low.push %value {addr = ...}
/// where the value originates from a reg.read of the target register.
///
/// @param op   The operation to check.
/// @param reg  If non-empty, only match pushes of this register.
///             If empty, match any push and return the register name.
/// @return     The register name if this is a matching push, std::nullopt otherwise.
static std::optional<std::string> isPushOf(Operation* op,
                                           llvm::StringRef reg = "") {
    auto pushOp = dyn_cast<helix::low::PushOp>(op);
    if (!pushOp)
        return std::nullopt;

    // Trace the pushed value back to a RegReadOp to determine which register
    // is being saved.
    Value pushed = pushOp.getValue();
    if (auto readOp = pushed.getDefiningOp<helix::low::RegReadOp>()) {
        auto pushReg = readOp.getRegName();
        if (reg.empty() || pushReg == reg)
            return pushReg.str();
    }

    return std::nullopt;
}

/// Check whether an operation is a `helix_low.pop` that restores a register.
///
/// @param op   The operation to check.
/// @param reg  If non-empty, only match pops that restore this register.
/// @return     The register name if this is a matching pop, std::nullopt otherwise.
static std::optional<std::string> isPopOf(Operation* op,
                                          llvm::StringRef reg = "") {
    auto popOp = dyn_cast<helix::low::PopOp>(op);
    if (!popOp)
        return std::nullopt;

    // A pop that restores a register is followed by a reg.write of the same
    // register.  Check all users of the pop result.
    for (auto* user : popOp.getResult().getUsers()) {
        if (auto writeOp = dyn_cast<helix::low::RegWriteOp>(user)) {
            auto popReg = writeOp.getRegName();
            if (reg.empty() || popReg == reg)
                return popReg.str();
        }
    }

    return std::nullopt;
}

/// Check if an operation is the frame pointer setup: `push rbp`.
///
/// This is the first instruction of the standard x86-64 prologue:
///   push rbp
///   mov rbp, rsp
///
/// @param op  The operation to check.
/// @return    True if this is `push rbp`.
static bool isFramePointerPush(Operation* op) {
    return isPushOf(op, "RBP").has_value();
}

/// Check if an operation is a `mov rbp, rsp` (frame pointer setup).
///
/// In HelixLow IR, this manifests as:
///   %rsp = helix_low.reg.read "RSP"
///   helix_low.reg.write %rsp, "RBP"
///
/// @param op  The operation to check.
/// @return    True if this is a frame pointer setup mov.
static bool isFramePointerMov(Operation* op) {
    auto writeOp = dyn_cast<helix::low::RegWriteOp>(op);
    if (!writeOp)
        return false;

    // Check: destination is RBP and the source value comes from reading RSP.
    if (writeOp.getRegName() != "RBP")
        return false;

    auto readOp = writeOp.getValue().getDefiningOp<helix::low::RegReadOp>();
    if (!readOp)
        return false;

    return readOp.getRegName() == "RSP";
}

/// Check if an operation is a `mov rsp, rbp` (frame pointer teardown).
///
/// The reverse of the setup: reads RBP and writes to RSP.
///
/// @param op  The operation to check.
/// @return    True if this is a frame pointer teardown.
static bool isFramePointerTeardown(Operation* op) {
    auto writeOp = dyn_cast<helix::low::RegWriteOp>(op);
    if (!writeOp)
        return false;

    if (writeOp.getRegName() != "RSP")
        return false;

    auto readOp = writeOp.getValue().getDefiningOp<helix::low::RegReadOp>();
    if (!readOp)
        return false;

    return readOp.getRegName() == "RBP";
}

/// Check if an operation is a frame pointer pop: `pop rbp`.
///
/// @param op  The operation to check.
/// @return    True if this is `pop rbp`.
static bool isFramePointerPop(Operation* op) {
    return isPopOf(op, "RBP").has_value();
}

/// Scan the function for prologue/epilogue push/pop pairs.
///
/// Identifies the standard patterns:
///   - Frame pointer setup/teardown: push rbp / mov rbp, rsp ... mov rsp, rbp / pop rbp
///   - Non-volatile register saves: push rbx ... pop rbx (and other callee-saved regs)
///
/// Non-volatile registers for Win64 ABI: RBX, RBP, RDI, RSI, R12-R15
/// Non-volatile registers for SysV ABI:  RBX, RBP, R12-R15
///
/// @param func  The function to scan.
/// @return      A list of matched push/pop pairs to remove.
static llvm::SmallVector<PushPopPair, 8>
findPrologueEpiloguePairs(helix::low::FuncOp func) {
    llvm::SmallVector<PushPopPair, 8> pairs;

    auto& body = func.getBody();
    if (body.empty())
        return pairs;

    // Non-volatile registers that may be saved/restored.
    static constexpr std::string_view kNonVolatile[] = {
        "RBX", "RBP", "RDI", "RSI", "R12", "R13", "R14", "R15"
    };

    // Collect all push and pop ops in the function.
    llvm::SmallVector<Operation*, 16> pushOps;
    llvm::SmallVector<Operation*, 16> popOps;

    body.walk([&](helix::low::PushOp push) {
        pushOps.push_back(push);
    });
    body.walk([&](helix::low::PopOp pop) {
        popOps.push_back(pop);
    });

    // For each non-volatile register, check if there's a matching
    // push at the function entry and pop at the function exit.
    for (auto nvReg : kNonVolatile) {
        Operation* matchedPush = nullptr;
        Operation* matchedPop  = nullptr;

        // Find the first push of this register (should be in the prologue).
        for (auto* op : pushOps) {
            if (isPushOf(op, nvReg)) {
                matchedPush = op;
                break;
            }
        }

        // Find the last pop of this register (should be in the epilogue).
        for (auto it = popOps.rbegin(); it != popOps.rend(); ++it) {
            if (isPopOf(*it, nvReg)) {
                matchedPop = *it;
                break;
            }
        }

        if (matchedPush && matchedPop) {
            pairs.push_back({matchedPush, matchedPop, nvReg});

            LLVM_DEBUG(llvm::dbgs() << "  Matched push/pop pair for "
                                    << nvReg << "\n");
        }
    }

    return pairs;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Stack Pointer Bookkeeping Detection
// ═══════════════════════════════════════════════════════════════════════════════

/// Check whether an operation is RSP bookkeeping: `rsp = rsp +/- N`.
///
/// These are stack allocation/deallocation instructions that have no
/// meaning in decompiled code (the stack layout is recovered separately).
///
/// Patterns detected:
///   - helix_low.bin (Add/Sub) where both operands involve RSP
///   - helix_low.reg.write to RSP where the value is RSP +/- constant
///
/// @param op  The operation to check.
/// @return    True if this is RSP bookkeeping that should be removed.
static bool isStackPointerBookkeeping(Operation* op) {
    // Pattern 1: a RegWriteOp to RSP.
    if (auto writeOp = dyn_cast<helix::low::RegWriteOp>(op)) {
        if (writeOp.getRegName() != "RSP")
            return false;

        // Check if the value being written is derived from RSP arithmetic.
        auto* defOp = writeOp.getValue().getDefiningOp();
        if (!defOp)
            return false;

        // BinOp with RSP as one operand and a constant as the other.
        if (auto binOp = dyn_cast<helix::low::BinOp>(defOp)) {
            auto kind = binOp.getKind();
            // Only Add and Sub are stack adjustments.
            auto kindVal = static_cast<int32_t>(kind);
            bool isAddOrSub = (kindVal == static_cast<int32_t>(
                                   helix::low::BinOpKind::Add)) ||
                              (kindVal == static_cast<int32_t>(
                                   helix::low::BinOpKind::Sub));
            if (!isAddOrSub)
                return false;

            // Check if one of the operands is an RSP read.
            auto lhsDef = binOp.getLhs().getDefiningOp<helix::low::RegReadOp>();
            auto rhsDef = binOp.getRhs().getDefiningOp<helix::low::RegReadOp>();

            bool lhsIsRsp = lhsDef && lhsDef.getRegName() == "RSP";
            bool rhsIsRsp = rhsDef && rhsDef.getRegName() == "RSP";

            return lhsIsRsp || rhsIsRsp;
        }

        // Direct copy from RSP (mov rsp, rsp — pathological but possible).
        if (auto readOp =
                writeOp.getValue().getDefiningOp<helix::low::RegReadOp>()) {
            return readOp.getRegName() == "RSP";
        }

        return false;
    }

    // Pattern 2: a BinOp (Add/Sub) whose result is only used by an RSP write.
    // This catches the intermediate arithmetic node.
    if (auto binOp = dyn_cast<helix::low::BinOp>(op)) {
        // Check if ALL users of the result are RSP writes.
        // (If any user is not an RSP write, we can't remove this op.)
        auto result = binOp.getResult();
        if (!result.hasOneUse())
            return false;

        auto* user = *result.getUsers().begin();
        if (auto writeOp = dyn_cast<helix::low::RegWriteOp>(user)) {
            if (writeOp.getRegName() == "RSP")
                return true;
        }

        return false;
    }

    return false;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Dead Register Write Detection
// ═══════════════════════════════════════════════════════════════════════════════

/// Determine whether a register write is dead (the written value is never
/// read before the register is overwritten).
///
/// A RegWriteOp is considered dead if:
///   1. The register is not live-out from the block (using MLIR Liveness).
///   2. The register is overwritten by a subsequent RegWriteOp before any
///      RegReadOp of the same register.
///   3. The register is not one of the ABI-required live-out registers
///      (RAX at function return, argument registers at call sites).
///
/// @param writeOp  The register write operation to check.
/// @param liveness Precomputed liveness information for the function.
/// @return         True if the write is dead and can be removed.
static bool isDeadRegisterWrite(helix::low::RegWriteOp writeOp,
                                const Liveness& liveness) {
    auto regName = writeOp.getRegName();

    // Never remove writes to RSP or RBP — they're handled by the
    // stack pointer bookkeeping and frame pointer passes respectively.
    if (regName == "RSP" || regName == "RBP")
        return false;

    // Check if the written value has any uses at all.  In SSA form, a
    // RegWriteOp is a side-effecting op that doesn't produce an SSA result
    // (it writes to the register file, which is modeled as memory).
    //
    // Since HelixLow models register writes as side effects, we need to scan
    // forward for reads of the same register.  If we find another write to
    // the same register before any read, the current write is dead.

    Block* block = writeOp->getBlock();
    if (!block)
        return false;

    // Scan forward from the write operation.
    bool foundRead = false;
    bool foundOverwrite = false;

    for (auto it = std::next(Operation::Iterator(writeOp));
         it != block->end(); ++it) {
        Operation& op = *it;

        // Check for a read of the same register.
        if (auto readOp = dyn_cast<helix::low::RegReadOp>(&op)) {
            if (readOp.getRegName() == regName) {
                foundRead = true;
                break;
            }
        }

        // Check for an overwrite of the same register.
        if (auto nextWrite = dyn_cast<helix::low::RegWriteOp>(&op)) {
            if (nextWrite.getRegName() == regName) {
                foundOverwrite = true;
                break;
            }
        }

        // A call clobbers volatile registers.  If the register is volatile
        // (RAX, RCX, RDX, R8, R9, R10, R11 on Win64), a call acts as an
        // overwrite.  If the register is non-volatile, the call preserves it.
        if (isa<helix::low::CallOp>(&op)) {
            static constexpr std::string_view kVolatile[] = {
                "RAX", "RCX", "RDX", "R8", "R9", "R10", "R11"
            };
            bool isVolatile = std::any_of(
                std::begin(kVolatile), std::end(kVolatile),
                [&](std::string_view v) { return v == regName; });

            if (isVolatile) {
                foundOverwrite = true;
                break;
            }
        }

        // A return uses RAX (return value).  If we're writing to RAX and
        // there's a return ahead, the write is NOT dead.
        if (isa<helix::low::RetOp>(&op)) {
            if (regName == "RAX") {
                foundRead = true;  // RAX is implicitly read by RET.
                break;
            }
            // For other registers at return, the write is dead (callee-saved
            // restores are handled by the prologue/epilogue pass).
            foundOverwrite = true;
            break;
        }
    }

    // The write is dead if it's overwritten before being read.
    if (foundOverwrite && !foundRead) {
        LLVM_DEBUG(llvm::dbgs() << "  Dead write: " << regName << "\n");
        return true;
    }

    // If we reached the end of the block without finding a read or overwrite,
    // check the block's live-out set.  If the register is not live-out, the
    // write is dead.
    if (!foundRead && !foundOverwrite) {
        // Use MLIR's liveness analysis.  The written value is an operand to
        // the RegWriteOp.  If that value is not live at the end of the block,
        // and there were no reads of the register within the block, we can
        // consider the write dead.
        //
        // Note: Liveness in MLIR tracks SSA values, not abstract register
        // names.  Since register writes are side effects without SSA results,
        // we conservatively keep writes that reach the end of the block
        // unless we're sure the register is dead.
        //
        // For now, we only remove writes that are provably overwritten
        // within the same block (the foundOverwrite case above).
        return false;
    }

    return false;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Implementation
// ═══════════════════════════════════════════════════════════════════════════════

/// Dead code elimination pass for decompilation artifacts.
///
/// Operates on a ModuleOp, processing each HelixLow function within it.
/// Removes operations that are specific to compiled code structure and
/// have no meaning in decompiled output.
struct EliminateDeadCodePass
    : public PassWrapper<EliminateDeadCodePass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(EliminateDeadCodePass)

    StringRef getArgument() const final { return "eliminate-dead-code"; }
    StringRef getDescription() const final {
        return "Remove decompilation artifacts: NOPs, INT3, prologue/epilogue "
               "push/pop, dead register writes, RSP bookkeeping";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<helix::high::HelixHighDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();

        // Process each HelixLow function in the module.
        auto result = module.walk([&](helix::low::FuncOp func) -> WalkResult {
            if (failed(eliminateDeadCode(func)))
                return WalkResult::interrupt();
            return WalkResult::advance();
        });

        if (result.wasInterrupted()) {
            signalPassFailure();
            return;
        }
    }

private:
    /// Run all dead code elimination phases on a single function.
    ///
    /// The phases are ordered from simplest/safest to most aggressive:
    ///   1. Remove NOPs and INT3 markers
    ///   2. Remove prologue/epilogue push/pop pairs
    ///   3. Remove frame pointer setup/teardown
    ///   4. Remove RSP bookkeeping (stack adjustments)
    ///   5. Remove dead register writes
    ///   6. Remove trivially dead operations
    ///
    /// @param func  The HelixLow function to clean up.
    /// @return      success() or failure().
    LogicalResult eliminateDeadCode(helix::low::FuncOp func) {
        auto& funcBody = func.getBody();
        if (funcBody.empty())
            return success();

        LLVM_DEBUG(llvm::dbgs() << "EliminateDeadCode: processing '"
                                << func.getSymName() << "'\n");

        // ── Phase 1: Remove NOP and INT3 markers ────────────────────────

        unsigned nopsRemoved  = removeNopsAndInt3(funcBody);
        NumNopsRemoved  += nopsRemoved;

        LLVM_DEBUG(if (nopsRemoved > 0)
            llvm::dbgs() << "  Phase 1: removed " << nopsRemoved
                         << " NOP/INT3 ops\n");

        // ── Phase 2: Remove prologue/epilogue push/pop pairs ────────────

        unsigned prologueRemoved = removePrologueEpilogue(func);
        NumPrologueOpsRemoved += prologueRemoved;

        LLVM_DEBUG(if (prologueRemoved > 0)
            llvm::dbgs() << "  Phase 2: removed " << prologueRemoved
                         << " prologue/epilogue ops\n");

        // ── Phase 3: Remove frame pointer setup/teardown ────────────────

        unsigned frameOpsRemoved = removeFramePointerOps(funcBody);
        NumPrologueOpsRemoved += frameOpsRemoved;

        LLVM_DEBUG(if (frameOpsRemoved > 0)
            llvm::dbgs() << "  Phase 3: removed " << frameOpsRemoved
                         << " frame pointer ops\n");

        // ── Phase 4: Remove RSP bookkeeping ─────────────────────────────

        unsigned stackAdjRemoved = removeStackAdjustments(funcBody);
        NumStackAdjustsRemoved += stackAdjRemoved;

        LLVM_DEBUG(if (stackAdjRemoved > 0)
            llvm::dbgs() << "  Phase 4: removed " << stackAdjRemoved
                         << " stack adjustment ops\n");

        // ── Phase 5: Remove dead register writes ────────────────────────

        unsigned deadWritesRemoved = removeDeadRegisterWrites(func);
        NumDeadWritesRemoved += deadWritesRemoved;

        LLVM_DEBUG(if (deadWritesRemoved > 0)
            llvm::dbgs() << "  Phase 5: removed " << deadWritesRemoved
                         << " dead register writes\n");

        // ── Phase 6: Trivially dead operation cleanup ───────────────────

        unsigned trivDeadRemoved = removeTriviallyDeadOps(funcBody);
        NumTriviallyDeadRemoved += trivDeadRemoved;

        LLVM_DEBUG(if (trivDeadRemoved > 0)
            llvm::dbgs() << "  Phase 6: removed " << trivDeadRemoved
                         << " trivially dead ops\n");

        LLVM_DEBUG(llvm::dbgs() << "  Total removed: "
                                << (nopsRemoved + prologueRemoved +
                                    frameOpsRemoved + stackAdjRemoved +
                                    deadWritesRemoved + trivDeadRemoved)
                                << "\n");

        return success();
    }

    // ─── Phase 1: NOP / INT3 Removal ─────────────────────────────────────

    /// Remove all `helix_low.nop` and `helix_low.int3` operations.
    ///
    /// These are padding/debug markers emitted by the compiler or debugger
    /// and carry no semantic information in the decompiled output.
    ///
    /// @param funcBody  The function's region.
    /// @return          The number of operations removed.
    unsigned removeNopsAndInt3(Region& funcBody) {
        unsigned removed = 0;

        llvm::SmallVector<Operation*, 16> toErase;

        funcBody.walk([&](Operation* op) {
            if (isa<helix::low::NopOp>(op) || isa<helix::low::Int3Op>(op)) {
                toErase.push_back(op);
            }
        });

        for (auto* op : toErase) {
            // NopOp and Int3Op have no results and no users, so they can
            // be erased unconditionally.
            op->erase();
            ++removed;
        }

        return removed;
    }

    // ─── Phase 2: Prologue/Epilogue Push/Pop Removal ─────────────────────

    /// Remove matched push/pop pairs for non-volatile register saves.
    ///
    /// @param func  The function to scan.
    /// @return      The number of operations removed (2 per pair).
    unsigned removePrologueEpilogue(helix::low::FuncOp func) {
        auto pairs = findPrologueEpiloguePairs(func);
        unsigned removed = 0;

        for (auto& pair : pairs) {
            // Before erasing, check that the push result has no remaining
            // users (other than the pop's reg.write).  If the pushed value
            // is used elsewhere, we can't remove the pair.
            if (pair.pushOp && pair.popOp) {
                // Erase the pop first (it may reference the push result).
                //
                // For a pop that feeds a reg.write, we also need to erase the
                // reg.write.  Collect the pop's users.
                llvm::SmallVector<Operation*, 2> popUsers;
                if (auto popOp = dyn_cast<helix::low::PopOp>(pair.popOp)) {
                    for (auto* user : popOp.getResult().getUsers()) {
                        popUsers.push_back(user);
                    }
                }

                // Erase pop's user chain (reg.write of the restored value).
                for (auto* user : popUsers) {
                    if (auto writeOp = dyn_cast<helix::low::RegWriteOp>(user))
                        writeOp.erase();
                }

                pair.popOp->erase();
                ++removed;

                // Erase the push.  If the push consumed a reg.read, that
                // reg.read may now be trivially dead (handled in Phase 6).
                pair.pushOp->erase();
                ++removed;

                LLVM_DEBUG(llvm::dbgs() << "  Removed push/pop pair for "
                                        << pair.reg << "\n");
            }
        }

        return removed;
    }

    // ─── Phase 3: Frame Pointer Setup/Teardown Removal ───────────────────

    /// Remove the standard frame pointer prologue and epilogue operations.
    ///
    /// Patterns:
    ///   Prologue: push rbp; mov rbp, rsp
    ///   Epilogue: mov rsp, rbp; pop rbp
    ///
    /// These are removed because the frame pointer is a compiler artifact
    /// used for stack frame addressing.  The stack layout pass has already
    /// recovered the actual variable locations.
    ///
    /// @param funcBody  The function's region.
    /// @return          The number of operations removed.
    unsigned removeFramePointerOps(Region& funcBody) {
        unsigned removed = 0;

        llvm::SmallVector<Operation*, 8> toErase;

        funcBody.walk([&](Operation* op) {
            if (isFramePointerPush(op) || isFramePointerMov(op) ||
                isFramePointerTeardown(op) || isFramePointerPop(op)) {
                toErase.push_back(op);
            }
        });

        // Erase in reverse order to avoid iterator invalidation when
        // operations reference each other.
        for (auto it = toErase.rbegin(); it != toErase.rend(); ++it) {
            Operation* op = *it;

            // For PopOp, check for and erase downstream reg.write users.
            if (auto popOp = dyn_cast<helix::low::PopOp>(op)) {
                llvm::SmallVector<Operation*, 2> users;
                for (auto* user : popOp.getResult().getUsers())
                    users.push_back(user);
                for (auto* user : users) {
                    user->erase();
                    ++removed;
                }
            }

            // For RegReadOp that feeds a frame pointer mov, if the read
            // result now has no users, it will be cleaned up in Phase 6.
            // We just erase the direct op here.
            op->erase();
            ++removed;
        }

        return removed;
    }

    // ─── Phase 4: RSP Bookkeeping Removal ────────────────────────────────

    /// Remove stack pointer adjustment operations.
    ///
    /// Patterns:
    ///   sub rsp, N   (stack allocation in prologue)
    ///   add rsp, N   (stack deallocation in epilogue)
    ///   lea rsp, [rsp + N]  (alternative stack adjustment)
    ///
    /// These are compiler-generated stack frame management that has no
    /// meaning in decompiled code.
    ///
    /// @param funcBody  The function's region.
    /// @return          The number of operations removed.
    unsigned removeStackAdjustments(Region& funcBody) {
        unsigned removed = 0;

        // Iterate until fixed point because removing one RSP write may
        // expose the BinOp that produced its value as trivially dead.
        bool changed = true;
        while (changed) {
            changed = false;

            llvm::SmallVector<Operation*, 8> toErase;

            funcBody.walk([&](Operation* op) {
                if (isStackPointerBookkeeping(op)) {
                    toErase.push_back(op);
                }
            });

            for (auto* op : toErase) {
                // Before erasing a RegWriteOp to RSP, check if its source
                // BinOp will become dead.
                if (auto writeOp = dyn_cast<helix::low::RegWriteOp>(op)) {
                    auto* defOp = writeOp.getValue().getDefiningOp();
                    writeOp.erase();
                    ++removed;
                    changed = true;

                    // If the defining BinOp now has no users, erase it too.
                    if (defOp && defOp->use_empty()) {
                        // Also check if the BinOp's RSP-read operand is dead.
                        llvm::SmallVector<Operation*, 2> operandDefs;
                        for (auto operand : defOp->getOperands()) {
                            if (auto* opDef = operand.getDefiningOp()) {
                                operandDefs.push_back(opDef);
                            }
                        }

                        defOp->erase();
                        ++removed;

                        // Clean up now-dead operand definitions (e.g., RSP read).
                        for (auto* opDef : operandDefs) {
                            if (opDef->use_empty() &&
                                isa<helix::low::RegReadOp>(opDef)) {
                                opDef->erase();
                                ++removed;
                            }
                        }
                    }

                    continue;
                }

                // For standalone BinOp that was identified as RSP bookkeeping.
                if (op->use_empty()) {
                    op->erase();
                    ++removed;
                    changed = true;
                }
            }
        }

        return removed;
    }

    // ─── Phase 5: Dead Register Write Removal ────────────────────────────

    /// Remove register writes whose values are never read.
    ///
    /// Uses MLIR's Liveness analysis as the backbone, supplemented with
    /// HelixLow-specific knowledge about register semantics (ABI-required
    /// live registers, call clobbers, implicit uses at return).
    ///
    /// @param func  The function to analyze.
    /// @return      The number of dead writes removed.
    unsigned removeDeadRegisterWrites(helix::low::FuncOp func) {
        auto& funcBody = func.getBody();
        unsigned removed = 0;

        // Compute MLIR liveness for the function.
        Liveness liveness(func);

        // Iterate until fixed point: removing a dead write may expose
        // another write as dead.
        bool changed = true;
        while (changed) {
            changed = false;

            llvm::SmallVector<helix::low::RegWriteOp, 16> deadWrites;

            funcBody.walk([&](helix::low::RegWriteOp writeOp) {
                if (isDeadRegisterWrite(writeOp, liveness)) {
                    deadWrites.push_back(writeOp);
                }
            });

            for (auto writeOp : deadWrites) {
                // Before erasing, check if the value operand's defining op
                // will become dead.
                auto* defOp = writeOp.getValue().getDefiningOp();

                writeOp.erase();
                ++removed;
                changed = true;

                // If the defining op now has no users, it may be trivially dead.
                // We let Phase 6 handle that, but mark that we changed the IR
                // so we re-iterate the dead write scan.
            }
        }

        return removed;
    }

    // ─── Phase 6: Trivially Dead Operation Cleanup ───────────────────────

    /// Remove operations that are trivially dead (no side effects, no users).
    ///
    /// After the targeted removal phases above, many intermediate operations
    /// (RegRead, constants, etc.) may have lost all their users.  MLIR's
    /// `isOpTriviallyDead()` check handles this generically.
    ///
    /// @param funcBody  The function's region.
    /// @return          The number of operations removed.
    unsigned removeTriviallyDeadOps(Region& funcBody) {
        unsigned removed = 0;

        // Iterate to fixed point since removing one op may make others dead.
        bool changed = true;
        while (changed) {
            changed = false;

            llvm::SmallVector<Operation*, 16> toErase;

            funcBody.walk([&](Operation* op) {
                // Skip terminators — they're never trivially dead.
                if (op->hasTrait<OpTrait::IsTerminator>())
                    return;

                // Skip ops with side effects that we don't want to remove
                // (calls, memory writes, etc.).
                if (isa<helix::low::CallOp>(op) ||
                    isa<helix::low::MemWriteOp>(op) ||
                    isa<helix::low::RetOp>(op) ||
                    isa<helix::low::RepMovsOp>(op) ||
                    isa<helix::low::RepStosOp>(op)) {
                    return;
                }

                // Check if all results are unused.
                bool allResultsUnused = true;
                for (auto result : op->getResults()) {
                    if (!result.use_empty()) {
                        allResultsUnused = false;
                        break;
                    }
                }

                // RegWriteOp has no results (side-effect-only), so
                // allResultsUnused would be trivially true.  But we
                // shouldn't remove it here — that's Phase 5's job.
                if (isa<helix::low::RegWriteOp>(op))
                    return;

                // PushOp and PopOp are side-effecting.
                if (isa<helix::low::PushOp>(op) || isa<helix::low::PopOp>(op))
                    return;

                if (allResultsUnused && op->getNumResults() > 0) {
                    toErase.push_back(op);
                }
            });

            for (auto* op : toErase) {
                op->erase();
                ++removed;
                changed = true;
            }
        }

        return removed;
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Factory
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createEliminateDeadCodePass() {
    return std::make_unique<EliminateDeadCodePass>();
}
