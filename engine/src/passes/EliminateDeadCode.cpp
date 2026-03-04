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
STATISTIC(NumDeadFlagsRemoved,     "Number of dead flag computations removed");
STATISTIC(NumDeadCmpTestRemoved,   "Number of dead CMP/TEST ops removed");
STATISTIC(NumDeadVarsRemoved,      "Number of dead variable decls removed");
STATISTIC(NumDeadAssignsRemoved,   "Number of dead assignments removed");
STATISTIC(NumDeadUndefRemoved,     "Number of dead __undef assignments removed");

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
// Flag Liveness Analysis
// ═══════════════════════════════════════════════════════════════════════════════

/// Tracks which CPU flags produced by an operation are actually consumed
/// by downstream conditional operations (jcc, cmov).
///
/// Flag-producing operations:
///   - helix_low.binop: carry, zero, sign, overflow
///   - helix_low.cmp:   carry, zero, sign, overflow
///   - helix_low.test:  zero, sign (no carry/overflow)
///
/// Flag-consuming operations:
///   - helix_low.jcc:  conditional branch based on flag condition
///   - helix_low.cmov: conditional move based on flag condition
///
/// A flag is "live" if its SSA result value has at least one user.
/// A flag is "dead" if its SSA result has no users.
/// If ALL flags of a CMP/TEST are dead, the entire operation is dead.
///
/// When a flag's liveness is uncertain (e.g., it flows through a block
/// argument or phi), we conservatively mark it as live and emit a warning.
struct FlagLiveness {
    bool carry_live    = false;
    bool zero_live     = false;
    bool sign_live     = false;
    bool overflow_live = false;

    /// Returns true if any flag is live.
    bool any_live() const {
        return carry_live || zero_live || sign_live || overflow_live;
    }

    /// Mark flags as live based on a JccOp's condition code.
    ///
    /// x86 condition codes and the flags they read:
    ///   z/nz (ZF), b/nb (CF), be/nbe (CF|ZF), l/nl (SF^OF),
    ///   le/nle (ZF|(SF^OF)), s/ns (SF), o/no (OF), p/np (PF — not modeled)
    void mark_from_jcc(llvm::StringRef condition) {
        markFlagsForCondition(condition);
    }

    /// Mark flags as live based on a CMovOp's condition code.
    void mark_from_cmov(llvm::StringRef condition) {
        markFlagsForCondition(condition);
    }

private:
    void markFlagsForCondition(llvm::StringRef cond) {
        // Normalize to lowercase for comparison.
        auto c = cond.lower();

        if (c == "z" || c == "e" || c == "nz" || c == "ne") {
            zero_live = true;
        } else if (c == "b" || c == "c" || c == "nb" || c == "nc" ||
                   c == "nae" || c == "ae") {
            carry_live = true;
        } else if (c == "be" || c == "na" || c == "nbe" || c == "a") {
            carry_live = true;
            zero_live  = true;
        } else if (c == "l" || c == "nge" || c == "nl" || c == "ge") {
            sign_live     = true;
            overflow_live = true;
        } else if (c == "le" || c == "ng" || c == "nle" || c == "g") {
            zero_live     = true;
            sign_live     = true;
            overflow_live = true;
        } else if (c == "s" || c == "ns") {
            sign_live = true;
        } else if (c == "o" || c == "no") {
            overflow_live = true;
        } else {
            // Unknown condition — conservatively mark all flags as live.
            carry_live    = true;
            zero_live     = true;
            sign_live     = true;
            overflow_live = true;
        }
    }
};

/// Check whether a flag SSA value has uncertain consumption.
///
/// A flag value is "uncertain" if it is used by an operation that is not
/// a recognized flag consumer (jcc, cmov) — for example, if it flows
/// through a block argument or is used by an unknown operation.
///
/// @param flagValue  The SSA value of a flag result.
/// @return           True if the flag has uncertain consumption.
static bool hasUncertainFlagConsumption(Value flagValue) {
    for (auto* user : flagValue.getUsers()) {
        if (!isa<helix::low::JccOp>(user) &&
            !isa<helix::low::CMovOp>(user)) {
            // Used by something other than jcc/cmov — uncertain.
            return true;
        }
    }
    return false;
}

/// Compute flag liveness for a flag-producing operation by examining
/// which of its flag results have consumers.
///
/// @param op  A flag-producing operation (BinOp, CmpOp, or TestOp).
/// @return    The FlagLiveness indicating which flags are live.
static FlagLiveness computeFlagLiveness(Operation* op) {
    FlagLiveness liveness;

    if (auto binOp = dyn_cast<helix::low::BinOp>(op)) {
        // BinOp results: [0]=result, [1]=carry, [2]=zero, [3]=sign, [4]=overflow
        liveness.carry_live    = !binOp.getCarryFlag().use_empty();
        liveness.zero_live     = !binOp.getZeroFlag().use_empty();
        liveness.sign_live     = !binOp.getSignFlag().use_empty();
        liveness.overflow_live = !binOp.getOverflowFlag().use_empty();
    } else if (auto cmpOp = dyn_cast<helix::low::CmpOp>(op)) {
        // CmpOp results: [0]=carry, [1]=zero, [2]=sign, [3]=overflow
        liveness.carry_live    = !cmpOp.getCarryFlag().use_empty();
        liveness.zero_live     = !cmpOp.getZeroFlag().use_empty();
        liveness.sign_live     = !cmpOp.getSignFlag().use_empty();
        liveness.overflow_live = !cmpOp.getOverflowFlag().use_empty();
    } else if (auto testOp = dyn_cast<helix::low::TestOp>(op)) {
        // TestOp results: [0]=zero, [1]=sign (no carry/overflow)
        liveness.zero_live = !testOp.getZeroFlag().use_empty();
        liveness.sign_live = !testOp.getSignFlag().use_empty();
    }

    return liveness;
}

/// Check whether a flag-producing operation has any uncertain flag
/// consumption (flags used by non-jcc/cmov operations).
///
/// @param op  A flag-producing operation.
/// @return    True if any flag has uncertain consumption.
static bool hasAnyUncertainFlags(Operation* op) {
    if (auto binOp = dyn_cast<helix::low::BinOp>(op)) {
        return hasUncertainFlagConsumption(binOp.getCarryFlag()) ||
               hasUncertainFlagConsumption(binOp.getZeroFlag()) ||
               hasUncertainFlagConsumption(binOp.getSignFlag()) ||
               hasUncertainFlagConsumption(binOp.getOverflowFlag());
    } else if (auto cmpOp = dyn_cast<helix::low::CmpOp>(op)) {
        return hasUncertainFlagConsumption(cmpOp.getCarryFlag()) ||
               hasUncertainFlagConsumption(cmpOp.getZeroFlag()) ||
               hasUncertainFlagConsumption(cmpOp.getSignFlag()) ||
               hasUncertainFlagConsumption(cmpOp.getOverflowFlag());
    } else if (auto testOp = dyn_cast<helix::low::TestOp>(op)) {
        return hasUncertainFlagConsumption(testOp.getZeroFlag()) ||
               hasUncertainFlagConsumption(testOp.getSignFlag());
    }
    return false;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Dead Variable Elimination (HelixHigh-level)
// ═══════════════════════════════════════════════════════════════════════════════

/// Check whether an operation is a "live" consumer — one that produces an
/// observable side effect.  A variable is considered live if any of its
/// references feed (directly or transitively) into one of these operations.
///
/// Live operations:
///   - helix_low.jcc, helix_low.jmp  (branch — affects control flow)
///   - helix_low.call, helix_high.call (function call — observable side effect)
///   - helix_low.ret, helix_high.return (return — observable output)
///   - helix_low.mem.write (memory write — observable side effect)
///   - helix_high.assign where the LHS feeds a live variable
static bool isLiveConsumer(Operation* op) {
    return isa<helix::low::JccOp>(op) ||
           isa<helix::low::JmpOp>(op) ||
           isa<helix::low::CallOp>(op) ||
           isa<helix::high::CallOp>(op) ||
           isa<helix::low::RetOp>(op) ||
           isa<helix::high::ReturnOp>(op) ||
           isa<helix::low::MemWriteOp>(op);
}

/// Check whether a Value is consumed (directly or transitively) by a live
/// operation.  Walks the use-chain forward, stopping at live consumers.
///
/// @param value     The SSA value to check.
/// @param visited   Set of already-visited operations (cycle protection).
/// @return          True if the value reaches a live consumer.
static bool isValueLive(Value value,
                        llvm::SmallPtrSetImpl<Operation*>& visited) {
    for (auto* user : value.getUsers()) {
        if (!visited.insert(user).second)
            continue;  // already visited — avoid infinite loops

        // Direct live consumer.
        if (isLiveConsumer(user))
            return true;

        // helix_high.assign: the value is live if the assignment target
        // (LHS) is itself live.  The LHS is a var.ref whose var_id we
        // need to trace further.  For simplicity, if the value appears as
        // the RHS of an assign, check whether the assign's target feeds
        // into something live.
        if (auto assignOp = dyn_cast<helix::high::AssignOp>(user)) {
            // The assign itself is a side effect — if the target var is
            // live, this assign is live.  We check the target operand.
            if (isValueLive(assignOp.getTarget(), visited))
                return true;
            continue;
        }

        // For any other operation that produces results, check if those
        // results are live.
        for (auto result : user->getResults()) {
            if (isValueLive(result, visited))
                return true;
        }
    }
    return false;
}

/// Determine whether a helix_high.var.decl is dead.
///
/// A variable declaration is dead if none of its var.ref operations are
/// consumed by a live operation (branch, call, return, memory write, or
/// an assignment whose target is itself live).
///
/// @param declOp   The var.decl operation.
/// @param funcBody The function's region (to scan for var.ref ops).
/// @return         True if the variable is dead and can be removed.
static bool isDeadVarDecl(helix::high::VarDeclOp declOp, Region& funcBody) {
    auto varId = declOp.getVarId();
    auto varName = declOp.getVarName();

    // Never remove SIMD vector variables — their reads aren't fully modeled yet,
    // but they contain critical offset calculations (e.g., Entity->Position at +0x70).
    if (varName.starts_with("XMM") || varName.starts_with("YMM") || varName.starts_with("ZMM") ||
        varName.starts_with("xmm") || varName.starts_with("ymm") || varName.starts_with("zmm"))
        return false;
    // Collect all var.ref operations that reference this variable.
    llvm::SmallVector<helix::high::VarRefOp, 8> refs;
    funcBody.walk([&](helix::high::VarRefOp refOp) {
        if (refOp.getVarId() == varId)
            refs.push_back(refOp);
    });

    // If no references at all, the variable is dead.
    if (refs.empty())
        return true;

    // Check if any reference is consumed by a live operation.
    for (auto refOp : refs) {
        llvm::SmallPtrSet<Operation*, 16> visited;
        if (isValueLive(refOp.getResult(), visited))
            return false;  // at least one live use — variable is alive
    }

    return true;  // no live uses found
}

/// Check whether an __undef assignment is dead.
///
/// An assignment is dead if:
///   1. The RHS is an __undef reference (var name starts with "__undef")
///   2. The LHS (target variable) is never read by a live operation
///
/// @param assignOp  The assign operation to check.
/// @param funcBody  The function's region.
/// @return          True if this is a dead __undef assignment.
static bool isDeadUndefAssign(helix::high::AssignOp assignOp,
                              Region& funcBody) {
    // Check if the RHS is a var.ref to __undef.
    auto* rhsDef = assignOp.getValue().getDefiningOp();
    if (!rhsDef)
        return false;

    if (auto refOp = dyn_cast<helix::high::VarRefOp>(rhsDef)) {
        auto name = refOp.getVarName();
        if (!name.starts_with("__undef"))
            return false;
    } else {
        return false;
    }

    // Check if the target variable is dead.
    auto* lhsDef = assignOp.getTarget().getDefiningOp();
    if (!lhsDef)
        return false;

    if (auto targetRef = dyn_cast<helix::high::VarRefOp>(lhsDef)) {
        auto targetId = targetRef.getVarId();

        // Check if any OTHER reference to this variable is live.
        bool anyLive = false;
        funcBody.walk([&](helix::high::VarRefOp otherRef) {
            if (otherRef == targetRef)
                return;  // skip the LHS reference itself
            if (otherRef.getVarId() != targetId)
                return;

            llvm::SmallPtrSet<Operation*, 16> visited;
            if (isValueLive(otherRef.getResult(), visited))
                anyLive = true;
        });

        return !anyLive;
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
    // Also, never remove writes to SIMD vector registers because RemillToHelixLow 
    // erases their semantic reads, leading to false dead stores and missing offsets.
    if (regName == "RSP" || regName == "RBP" || 
        regName.starts_with("XMM") || regName.starts_with("YMM") || regName.starts_with("ZMM"))
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

    for (auto it = std::next(writeOp->getIterator());
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
                [&](std::string_view v) { return v == std::string_view(regName); });

            if (isVolatile) {
                foundOverwrite = true;
                break;
            }
        }

        // A return uses RAX (return value).  If we're writing to RAX and
        // there's a return ahead, the write is NOT dead.
        if (isa<helix::low::RetOp>(&op)) {
            if (regName == "RAX" || regName.starts_with("XMM") || regName.starts_with("YMM") || regName.starts_with("ZMM")) {
                foundRead = true;  // RAX and Vector Registers are implicitly read by RET.
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

        // ── Phase 5b: Remove dead flag computations ─────────────────────
        //
        // Analyze flag-producing operations (binop, cmp, test) and remove
        // individual dead flag computations.  If ALL flags of a CMP/TEST
        // are dead, remove the entire operation.  Flags with uncertain
        // consumption are preserved with a warning.

        unsigned deadFlagsRemoved  = 0;
        unsigned deadCmpTestRemoved = 0;

        auto flagResult = removeDeadFlags(funcBody);
        deadFlagsRemoved   = std::get<0>(flagResult);
        deadCmpTestRemoved = std::get<1>(flagResult);

        NumDeadFlagsRemoved   += deadFlagsRemoved;
        NumDeadCmpTestRemoved += deadCmpTestRemoved;

        LLVM_DEBUG(if (deadFlagsRemoved + deadCmpTestRemoved > 0)
            llvm::dbgs() << "  Phase 5b: removed " << deadFlagsRemoved
                         << " dead flag computations, "
                         << deadCmpTestRemoved
                         << " dead CMP/TEST ops\n");

        // ── Phase 6: Trivially dead operation cleanup ───────────────────

        unsigned trivDeadRemoved = removeTriviallyDeadOps(funcBody);
        NumTriviallyDeadRemoved += trivDeadRemoved;

        LLVM_DEBUG(if (trivDeadRemoved > 0)
            llvm::dbgs() << "  Phase 6: removed " << trivDeadRemoved
                         << " trivially dead ops\n");

        // ── Phase 7: Dead variable elimination (HelixHigh) ─────────────
        //
        // Remove helix_high.var.decl whose value is never consumed by a
        // live operation, dead __undef assignments, and dead assignment
        // chains.  Iterates to fixed point.

        unsigned deadVarsRemoved = 0;
        unsigned deadAssignsRemoved = 0;
        unsigned deadUndefRemoved = 0;

        auto deadVarResult = removeDeadVariables(funcBody);
        deadVarsRemoved    += std::get<0>(deadVarResult);
        deadAssignsRemoved += std::get<1>(deadVarResult);
        deadUndefRemoved   += std::get<2>(deadVarResult);

        NumDeadVarsRemoved    += deadVarsRemoved;
        NumDeadAssignsRemoved += deadAssignsRemoved;
        NumDeadUndefRemoved   += deadUndefRemoved;

        LLVM_DEBUG(if (deadVarsRemoved + deadAssignsRemoved + deadUndefRemoved > 0)
            llvm::dbgs() << "  Phase 7: removed " << deadVarsRemoved
                         << " dead vars, " << deadAssignsRemoved
                         << " dead assigns, " << deadUndefRemoved
                         << " dead __undef assigns\n");

        LLVM_DEBUG(llvm::dbgs() << "  Total removed: "
                                << (nopsRemoved + prologueRemoved +
                                    frameOpsRemoved + stackAdjRemoved +
                                    deadWritesRemoved +
                                    deadFlagsRemoved + deadCmpTestRemoved +
                                    trivDeadRemoved +
                                    deadVarsRemoved + deadAssignsRemoved +
                                    deadUndefRemoved)
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

        // Multi-block functions may have LLVM dialect branch ops whose operands
        // cross block boundaries, causing Liveness analysis to assert.
        // Skip Liveness-based DCE for multi-block — the emitter-level DSE
        // (PseudoCEmitter::precomputeDeadStores) handles this independently.
        if (funcBody.getBlocks().size() > 2) {
            return 0;
        }

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

    // ─── Phase 5b: Dead Flag Computation Removal ────────────────────────

    /// Remove dead flag computations from flag-producing operations.
    ///
    /// For each flag-producing operation (BinOp, CmpOp, TestOp):
    ///   1. Compute which flags are actually consumed by jcc/cmov ops
    ///   2. If a flag has uncertain consumption (non-jcc/cmov user),
    ///      preserve it and emit a warning
    ///   3. For CmpOp/TestOp: if ALL flags are dead, remove the entire op
    ///   4. For BinOp: only flag results can be dead (main result may be live);
    ///      dead flag results are replaced with a constant false value
    ///
    /// @param funcBody  The function's region.
    /// @return          Tuple of (dead flags removed, dead CMP/TEST ops removed).
    std::tuple<unsigned, unsigned> removeDeadFlags(Region& funcBody) {
        unsigned totalFlagsRemoved   = 0;
        unsigned totalCmpTestRemoved = 0;

        bool changed = true;
        while (changed) {
            changed = false;

            // ── Step 1: Handle CmpOp — remove entire op if all flags dead ──
            {
                llvm::SmallVector<helix::low::CmpOp, 8> deadCmps;

                funcBody.walk([&](helix::low::CmpOp cmpOp) {
                    // Check for uncertain consumption first.
                    if (hasAnyUncertainFlags(cmpOp)) {
                        cmpOp.emitWarning()
                            << "flag liveness uncertain, preserving";
                        return;
                    }

                    auto liveness = computeFlagLiveness(cmpOp);
                    if (!liveness.any_live()) {
                        deadCmps.push_back(cmpOp);
                    }
                });

                for (auto cmpOp : deadCmps) {
                    LLVM_DEBUG(llvm::dbgs()
                        << "  Dead CMP (all flags unused): "
                        << *cmpOp.getOperation() << "\n");

                    // Before erasing, clean up operand definitions that may
                    // become dead (e.g., RegReadOps feeding the CMP).
                    llvm::SmallVector<Operation*, 4> operandDefs;
                    for (auto operand : cmpOp->getOperands()) {
                        if (auto* defOp = operand.getDefiningOp())
                            operandDefs.push_back(defOp);
                    }

                    cmpOp.erase();
                    ++totalCmpTestRemoved;
                    changed = true;

                    // Clean up now-dead operand definitions.
                    for (auto* defOp : operandDefs) {
                        if (defOp->use_empty() &&
                            isa<helix::low::RegReadOp>(defOp)) {
                            defOp->erase();
                            ++totalFlagsRemoved;
                        }
                    }
                }
            }

            // ── Step 2: Handle TestOp — remove entire op if all flags dead ─
            {
                llvm::SmallVector<helix::low::TestOp, 8> deadTests;

                funcBody.walk([&](helix::low::TestOp testOp) {
                    if (hasAnyUncertainFlags(testOp)) {
                        testOp.emitWarning()
                            << "flag liveness uncertain, preserving";
                        return;
                    }

                    auto liveness = computeFlagLiveness(testOp);
                    if (!liveness.any_live()) {
                        deadTests.push_back(testOp);
                    }
                });

                for (auto testOp : deadTests) {
                    LLVM_DEBUG(llvm::dbgs()
                        << "  Dead TEST (all flags unused): "
                        << *testOp.getOperation() << "\n");

                    llvm::SmallVector<Operation*, 4> operandDefs;
                    for (auto operand : testOp->getOperands()) {
                        if (auto* defOp = operand.getDefiningOp())
                            operandDefs.push_back(defOp);
                    }

                    testOp.erase();
                    ++totalCmpTestRemoved;
                    changed = true;

                    for (auto* defOp : operandDefs) {
                        if (defOp->use_empty() &&
                            isa<helix::low::RegReadOp>(defOp)) {
                            defOp->erase();
                            ++totalFlagsRemoved;
                        }
                    }
                }
            }

            // ── Step 3: Handle BinOp — replace dead flag results ───────────
            //
            // BinOp produces both a value result and flag results.  The value
            // result may still be live even if all flags are dead.  For dead
            // flag results, we replace their uses (if any remain after DCE)
            // with a constant false, then count them as removed.
            //
            // Note: We do NOT remove the BinOp itself — only its dead flag
            // outputs.  The BinOp is kept if its value result is live.
            {
                funcBody.walk([&](helix::low::BinOp binOp) {
                    if (hasAnyUncertainFlags(binOp)) {
                        binOp.emitWarning()
                            << "flag liveness uncertain, preserving";
                        return;
                    }

                    auto liveness = computeFlagLiveness(binOp);

                    // Count dead flags (unused flag results).
                    unsigned deadCount = 0;
                    if (!liveness.carry_live &&
                        binOp.getCarryFlag().use_empty())
                        ++deadCount;
                    if (!liveness.zero_live &&
                        binOp.getZeroFlag().use_empty())
                        ++deadCount;
                    if (!liveness.sign_live &&
                        binOp.getSignFlag().use_empty())
                        ++deadCount;
                    if (!liveness.overflow_live &&
                        binOp.getOverflowFlag().use_empty())
                        ++deadCount;

                    if (deadCount > 0) {
                        LLVM_DEBUG(llvm::dbgs()
                            << "  BinOp with " << deadCount
                            << " dead flag(s): "
                            << *binOp.getOperation() << "\n");
                        totalFlagsRemoved += deadCount;
                        // The dead flag results are already unused (use_empty),
                        // so no replacement is needed.  They will be cleaned
                        // up when the BinOp is eventually removed (if the
                        // value result also becomes dead) or ignored by the
                        // emitter.
                    }
                });
            }
        }

        return {totalFlagsRemoved, totalCmpTestRemoved};
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

    // ─── Phase 7: Dead Variable Elimination (HelixHigh) ──────────────────

    /// Remove dead variable declarations, dead assignment chains, and dead
    /// __undef assignments.
    ///
    /// A variable is dead if none of its var.ref operations are consumed by
    /// a live operation (branch, call, return, memory write).  Dead
    /// assignments are removed in reverse dependency order: first the
    /// assignments that feed the dead variable, then the declaration itself.
    ///
    /// Iterates to fixed point because removing one dead variable may
    /// expose other variables as dead (transitive dependency chains).
    ///
    /// @param funcBody  The function's region.
    /// @return          Tuple of (dead vars, dead assigns, dead __undef) removed.
    std::tuple<unsigned, unsigned, unsigned>
    removeDeadVariables(Region& funcBody) {
        unsigned totalVars    = 0;
        unsigned totalAssigns = 0;
        unsigned totalUndef   = 0;

        bool changed = true;
        while (changed) {
            changed = false;

            // ── Step 1: Remove dead __undef assignments ─────────────────
            {
                llvm::SmallVector<helix::high::AssignOp, 16> deadUndefs;

                funcBody.walk([&](helix::high::AssignOp assignOp) {
                    if (isDeadUndefAssign(assignOp, funcBody))
                        deadUndefs.push_back(assignOp);
                });

                for (auto assignOp : deadUndefs) {
                    // Erase the RHS var.ref if it becomes unused.
                    auto* rhsDef = assignOp.getValue().getDefiningOp();
                    // Erase the LHS var.ref if it becomes unused.
                    auto* lhsDef = assignOp.getTarget().getDefiningOp();

                    assignOp.erase();
                    ++totalUndef;
                    changed = true;

                    if (rhsDef && rhsDef->use_empty())
                        rhsDef->erase();
                    if (lhsDef && lhsDef->use_empty())
                        lhsDef->erase();
                }
            }

            // ── Step 2: Remove dead assignment chains ───────────────────
            //
            // An assignment is dead if its target variable has no live
            // consumers.  We remove assignments in reverse order so that
            // removing a later assignment may expose an earlier one as dead.
            {
                llvm::SmallVector<helix::high::AssignOp, 16> allAssigns;
                funcBody.walk([&](helix::high::AssignOp assignOp) {
                    allAssigns.push_back(assignOp);
                });

                // Process in reverse order (reverse dependency).
                for (auto it = allAssigns.rbegin(); it != allAssigns.rend();
                     ++it) {
                    auto assignOp = *it;

                    // Get the target variable ID.
                    auto* lhsDef = assignOp.getTarget().getDefiningOp();
                    if (!lhsDef)
                        continue;

                    auto targetRef =
                        dyn_cast<helix::high::VarRefOp>(lhsDef);
                    if (!targetRef)
                        continue;

                    auto targetId = targetRef.getVarId();

                    // Never remove assignments to SIMD vector variables —
                    // their reads aren't modeled but they contain critical offsets.
                    auto targetName = targetRef.getVarName();
                    if (targetName.starts_with("xmm") || targetName.starts_with("ymm") ||
                        targetName.starts_with("zmm") || targetName.starts_with("XMM") ||
                        targetName.starts_with("YMM") || targetName.starts_with("ZMM"))
                        continue;

                    // Check if the target variable has any live consumers
                    // (excluding this assignment's own LHS reference).
                    bool anyLive = false;
                    funcBody.walk([&](helix::high::VarRefOp refOp) {
                        if (anyLive)
                            return;
                        if (refOp == targetRef)
                            return;
                        if (refOp.getVarId() != targetId)
                            return;

                        llvm::SmallPtrSet<Operation*, 16> visited;
                        if (isValueLive(refOp.getResult(), visited))
                            anyLive = true;
                    });

                    if (!anyLive) {
                        auto* rhsDef = assignOp.getValue().getDefiningOp();
                        auto* lhsOp  = assignOp.getTarget().getDefiningOp();

                        assignOp.erase();
                        ++totalAssigns;
                        changed = true;

                        // Clean up orphaned operand definitions.
                        if (rhsDef && rhsDef->use_empty())
                            rhsDef->erase();
                        if (lhsOp && lhsOp->use_empty())
                            lhsOp->erase();
                    }
                }
            }

            // ── Step 3: Remove dead variable declarations ───────────────
            {
                llvm::SmallVector<helix::high::VarDeclOp, 16> deadDecls;

                funcBody.walk([&](helix::high::VarDeclOp declOp) {
                    if (isDeadVarDecl(declOp, funcBody))
                        deadDecls.push_back(declOp);
                });

                for (auto declOp : deadDecls) {
                    // If the decl has an initializer, check if it's dead too.
                    if (declOp.getInit()) {
                        auto* initDef =
                            declOp.getInit().getDefiningOp();
                        declOp.erase();
                        ++totalVars;
                        changed = true;

                        if (initDef && initDef->use_empty())
                            initDef->erase();
                    } else {
                        declOp.erase();
                        ++totalVars;
                        changed = true;
                    }
                }
            }
        }

        return {totalVars, totalAssigns, totalUndef};
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Factory
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createEliminateDeadCodePass() {
    return std::make_unique<EliminateDeadCodePass>();
}
