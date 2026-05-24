/// @file RecoverVariables.cpp
/// @brief MLIR pass: replaces register references with named variables.
///
/// This pass operates after stack layout recovery and control flow structuring.
/// It walks all remaining `helix_low.reg.read` and `helix_low.reg.write`
/// operations in PROGRAM ORDER and replaces them with `helix_high.var.ref` /
/// `helix_high.assign` operations that reference named, typed variables.
///
/// ## SSA Variable Splitting (v0.8.0)
///
/// Each RegWrite creates a NEW variable version (rax, rax_1, rax_2, ...),
/// ensuring unique var_ids per definition.  This prevents the DCE from
/// collapsing all assignments to the same register into a single live
/// variable.  This is the standard approach used by IDA Pro, Ghidra, and
/// Binary Ninja (see SAILR Section 4.1.1, Osprey Section VII, ReSym 3.2.1).
///
/// ## Register Alias Handling
///
/// x86-64 registers overlap:
///
///   - RAX (64-bit) contains EAX (32-bit), AX (16-bit), AL/AH (8-bit).
///   - EAX is the low 32 bits of RAX; AX is the low 16 bits; AL is bits [0:8);
///     AH is bits [8:16).
///
/// When we see a read of EAX, we emit a truncation cast from the 64-bit
/// variable `rax` down to 32 bits.  When we see a write to EAX, we emit
/// a zero-extension + insertion into the full 64-bit variable (matching
/// x86-64 semantics where writing a 32-bit register zero-extends to 64).
///
/// ## Naming Conventions
///
///   - Register variables : `rax`, `rax_1`, `rax_2`, ... (SSA versioned)
///   - Parameters         : `param_1`, `param_2`, ... (calling convention)
///   - Stack variables    : `var_<hex_offset>` (e.g., `var_20` for [RBP-0x20])
///   - Temporaries        : `v<N>` with a monotonically increasing counter
///
/// ## References
///
///   - SAILR Section 4.1.1 — AIL variables unique per definition
///   - Osprey Section VII — one variable per definition point
///   - ReSym Section 3.2.1 — unique variable IDs per definition
///   - Rust implementation: crates/helix-core/src/analysis/data_flow.rs

// Standard library includes FIRST (before LLVM/MLIR to avoid namespace conflicts)
#include <algorithm>
#include <cstdint>
#include "llvm/Support/FormatVariadic.h"
#include <optional>
#include <string>
#include <string_view>
#include <vector>

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/analysis/X86RegisterInfo.h"
#include "helix/utils/CallOpHelpers.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/UB/IR/UBOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/SmallVector.h"

#include <map>
#include <set>
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Debug.h"
#include "mlir/IR/Dominance.h"

#define DEBUG_TYPE "recover-variables"

using namespace mlir;

// ═══════════════════════════════════════════════════════════════════════════════
// Forward declaration — factory defined after anonymous namespace
// ═══════════════════════════════════════════════════════════════════════════════

// (moved to end of file)

// ═══════════════════════════════════════════════════════════════════════════════
// Statistics
// ═══════════════════════════════════════════════════════════════════════════════

STATISTIC(NumRegVarsCreated,   "Number of register-backed variables created");
STATISTIC(NumStackVarsCreated, "Number of stack variables created");
STATISTIC(NumTempsCreated,     "Number of temporary variables created");
STATISTIC(NumReadsReplaced,    "Number of reg.read ops replaced with var.ref");
STATISTIC(NumWritesReplaced,   "Number of reg.write ops replaced with assign");
STATISTIC(NumAliasesResolved,  "Number of sub-register aliases resolved");
STATISTIC(NumParamsNamed,      "Number of argument registers renamed to param_N");
STATISTIC(NumReturnVarsNamed,  "Number of RAX refs renamed to result");
STATISTIC(NumSSAVersions,      "Number of SSA variable versions created");
STATISTIC(NumDeadFlagWrites,   "Number of dead flag/RIP RegWrites eliminated");
STATISTIC(NumUndefReplaced,    "Number of __undef references replaced with defaults");
STATISTIC(NumVarsMerged,       "Number of variables eliminated by cover-based merging");
STATISTIC(NumVersionsCoalesced,"Number of SSA versions coalesced into base register var");
STATISTIC(NumTempsInlined,     "Number of single-use temporaries inlined");

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// Register Alias Tables
// ═══════════════════════════════════════════════════════════════════════════════

using SubRegInfo = helix::analysis::X86SubRegInfo;

static std::optional<SubRegInfo> getSubRegInfo(llvm::StringRef reg) {
    return helix::analysis::getX86SubRegInfo(reg);
}

/// Convert a canonical 64-bit register name to its lowercase variable name.
///
/// RAX -> rax, RBX -> rbx, R8 -> r8, etc.
///
/// @param canonicalReg  The uppercase register name (e.g., "RAX").
/// @return              The lowercase variable name (e.g., "rax").
static std::string regToVarName(llvm::StringRef canonicalReg) {
    std::string name = canonicalReg.lower();
    return name;
}

static uint32_t getNextAvailableVarId(helix::low::FuncOp func) {
    uint32_t nextId = 0;
    func.walk([&](helix::high::VarDeclOp decl) {
        nextId = std::max(nextId, decl.getVarId() + 1);
    });
    return nextId;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Variable Tracker
// ═══════════════════════════════════════════════════════════════════════════════

/// Manages variable declarations and name assignments during the pass.
///
/// Tracks which variables have been declared, their types, and ensures
/// names are unique within the function scope.
struct VariableTracker {
    /// Maps canonical register names (uppercase) to the helix_high.var.decl
    /// operation that declares the corresponding variable.
    llvm::StringMap<Operation*> regToDecl;

    /// Maps stack offsets to their variable declarations.
    llvm::DenseMap<int64_t, Operation*> stackOffsetToDecl;

    /// Counter for generating unique temporary variable names.
    unsigned tempCounter = 0;

    /// Counter for generating unique variable IDs within the function.
    uint32_t varIdCounter = 0;

    /// Maps argument register names (uppercase) to their 1-based parameter
    /// position in the active calling convention.
    /// Win64: RCX→1, RDX→2, R8→3, R9→4
    /// SysV:  RDI→1, RSI→2, RDX→3, RCX→4, R8→5, R9→6
    llvm::StringMap<unsigned> argRegPositions;

    /// Whether the function has a return value (set by RecoverCallingConvention).
    bool hasReturnValue = false;

    /// Initialize the argument register position map based on calling convention.
    ///
    /// @param isWin64  true for Win64 ABI, false for SysV AMD64 ABI.
    void initArgRegPositions(bool isWin64) {
        argRegPositions.clear();
        if (isWin64) {
            argRegPositions["RCX"] = 1;
            argRegPositions["RDX"] = 2;
            argRegPositions["R8"]  = 3;
            argRegPositions["R9"]  = 4;
        } else {
            argRegPositions["RDI"] = 1;
            argRegPositions["RSI"] = 2;
            argRegPositions["RDX"] = 3;
            argRegPositions["RCX"] = 4;
            argRegPositions["R8"]  = 5;
            argRegPositions["R9"]  = 6;
        }
    }

    /// Check if an operation is in a return context — i.e., the register
    /// value flows into a helix_low.ret or helix_high.return operation.
    ///
    /// Scans forward from the given operation within the same block to find
    /// if a RetOp follows without an intervening write to the same register.
    ///
    /// @param op       The operation to check (typically a reg.write to RAX).
    /// @param regName  The register being written (checked for intervening writes).
    /// @return         true if this write feeds a return.
    static bool isReturnContext(Operation* op, llvm::StringRef regName) {
        auto* block = op->getBlock();
        if (!block)
            return false;

        // Scan forward from op to the end of the block.
        auto it = Block::iterator(op);
        ++it; // skip the current op
        for (auto end = block->end(); it != end; ++it) {
            // If we hit a return, this is a return context.
            if (isa<helix::low::RetOp>(&*it))
                return true;

            // If another write to the same register intervenes, stop.
            if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&*it)) {
                if (regWrite.getRegName() == regName)
                    return false;
            }

            // If we hit a call or branch, stop scanning.
            if (helix::isAnyCallOp(&*it) ||
                isa<helix::low::JmpOp, helix::low::JccOp>(&*it))
                return false;
        }

        return false;
    }

    /// Determine the semantic variable name for a canonical register.
    ///
    /// - Argument registers → param_N (per calling convention)
    /// - RAX in return context → result
    /// - Other registers → lowercase register name (rax, rbx, etc.)
    ///
    /// @param canonicalReg  The canonical 64-bit register name (e.g., "RAX").
    /// @param contextOp     The operation context (for return detection).
    /// @return              The semantic variable name and storage kind.
    std::pair<std::string, helix::high::StorageKind>
    getSemanticName(llvm::StringRef canonicalReg, Operation* contextOp) {
        // Check if this is an argument register.
        auto argIt = argRegPositions.find(canonicalReg);
        if (argIt != argRegPositions.end()) {
            std::string name = llvm::formatv("param_{0}", argIt->second);
            return {name, helix::high::StorageKind::Parameter};
        }

        // Check if RAX in return context.
        if (canonicalReg == "RAX" && hasReturnValue && contextOp &&
            isReturnContext(contextOp, canonicalReg)) {
            return {"result", helix::high::StorageKind::Register};
        }

        // Default: lowercase register name.
        return {regToVarName(canonicalReg),
                helix::high::StorageKind::Register};
    }

    /// Declare a register-backed variable if it hasn't been declared yet.
    /// Uses semantic naming: argument registers become param_N, RAX in
    /// return context becomes result, others use lowercase register name.
    ///
    /// @param canonicalReg  The canonical 64-bit register name (e.g., "RAX").
    /// @param builder       OpBuilder positioned at the function entry.
    /// @param loc           Source location for the declaration.
    /// @param contextOp     The operation requesting this variable (for
    ///                      return context detection). May be nullptr.
    /// @return              The var.decl operation (existing or newly created).
    Operation* getOrDeclareRegVar(llvm::StringRef canonicalReg,
                                  OpBuilder& builder, Location loc,
                                  Operation* contextOp = nullptr) {
        // For RAX, check return context to decide between "result" and "rax".
        // We use a separate key for the return-context variant.
        bool isRetCtx = (canonicalReg == "RAX" && hasReturnValue &&
                         contextOp && isReturnContext(contextOp, canonicalReg));
        llvm::StringRef lookupKey = isRetCtx ? "RAX__result" : canonicalReg;

        auto it = regToDecl.find(lookupKey);
        if (it != regToDecl.end())
            return it->second;

        auto [varName, storage] = getSemanticName(canonicalReg, contextOp);

        // If this is the return-context RAX but we already have a plain RAX
        // variable, create a separate declaration for "result".
        // Conversely, if we have "result" but need plain "rax", create that too.

        auto declOp = builder.create<helix::high::VarDeclOp>(
            loc,
            /*var_id=*/varIdCounter++,
            /*var_name=*/varName,
            /*storage=*/storage,
            /*stack_offset=*/IntegerAttr{},
            /*init=*/Value{},
            /*address=*/IntegerAttr{});

        regToDecl[lookupKey] = declOp;
        ++NumRegVarsCreated;

        LLVM_DEBUG(llvm::dbgs() << "  Declared register variable: "
                                << varName << " (from " << canonicalReg
                                << ", key=" << lookupKey << ")\n");

        return declOp;
    }

    /// Declare a stack variable if it hasn't been declared yet.
    ///
    /// @param offset   The stack offset (e.g., -0x20 for [RBP-0x20]).
    /// @param width    The access width in bits (determines the type).
    /// @param builder  OpBuilder positioned at the function entry.
    /// @param loc      Source location for the declaration.
    /// @return         The var.decl operation.
    Operation* getOrDeclareStackVar(int64_t offset, unsigned width,
                                    OpBuilder& builder, Location loc) {
        auto it = stackOffsetToDecl.find(offset);
        if (it != stackOffsetToDecl.end())
            return it->second;

        // Generate the variable name: var_<positive_hex_offset>
        // We use the absolute value for readability: var_20 instead of var_-20.
        uint64_t absOffset = static_cast<uint64_t>(
            offset < 0 ? -offset : offset);
        std::string varName = llvm::formatv("var_{0:x}", absOffset);

        auto declOp = builder.create<helix::high::VarDeclOp>(
            loc,
            /*var_id=*/varIdCounter++,
            /*var_name=*/varName,
            /*storage=*/helix::high::StorageKind::Stack,
            /*stack_offset=*/builder.getI64IntegerAttr(offset),
            /*init=*/Value{},
            /*address=*/IntegerAttr{});

        stackOffsetToDecl[offset] = declOp;
        ++NumStackVarsCreated;

        LLVM_DEBUG(llvm::dbgs() << "  Declared stack variable: "
                                << varName << " (offset " << offset
                                << ", width " << width << ")\n");

        return declOp;
    }

    /// Create a new temporary variable with a unique name.
    ///
    /// @param type     The type of the temporary.
    /// @param builder  OpBuilder at the desired insertion point.
    /// @param loc      Source location.
    /// @return         The var.decl operation.
    Operation* declareTemp(Type type, OpBuilder& builder, Location loc) {
        (void)type;  // type is implicit from init/usage in the new API
        std::string varName = llvm::formatv("v{0}", tempCounter++);

        auto declOp = builder.create<helix::high::VarDeclOp>(
            loc,
            /*var_id=*/varIdCounter++,
            /*var_name=*/varName,
            /*storage=*/helix::high::StorageKind::Temporary,
            /*stack_offset=*/IntegerAttr{},
            /*init=*/Value{},
            /*address=*/IntegerAttr{});

        ++NumTempsCreated;

        LLVM_DEBUG(llvm::dbgs() << "  Declared temporary: " << varName
                                << "\n");

        return declOp;
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// SSA Version Tracker
// ═══════════════════════════════════════════════════════════════════════════════

/// Tracks per-register SSA versions during the program-order walk.
///
/// Each RegWrite creates a new variable version (rax, rax_1, rax_2, ...),
/// giving every definition a unique var_id.  RegReads reference the MOST
/// RECENT version of the target register.  This prevents the DCE from
/// treating all writes to the same register as stores to a single variable.
///
/// Industry reference: SAILR, Osprey, ReSym, LLM4Decompile all create
/// one variable per definition point.
struct SSAVersionTracker {
    /// Information about a single SSA version of a register.
    struct Version {
        Operation* decl;      ///< The VarDeclOp for this version.
        uint32_t varId;       ///< Unique var_id.
        std::string varName;  ///< e.g., "rax", "rax_1", "rax_2"
    };

    /// Current (most recent) version for each canonical register.
    llvm::StringMap<Version> current;

    /// All versions ever created, grouped by canonical register.
    /// Used by Phase 3.5 (same-register coalescing) to identify
    /// versions of the same logical variable.
    llvm::StringMap<llvm::SmallVector<Version, 4>> allVersions;

    /// Counter for creating unique names per register (rax→0, rax→1, ...).
    llvm::StringMap<unsigned> versionCounters;

    /// Reference to the shared var_id counter (owned by VariableTracker).
    uint32_t& varIdCounter;

    explicit SSAVersionTracker(uint32_t& idCounter) : varIdCounter(idCounter) {}

    /// Create a new version for a register write.
    ///
    /// Version 0 uses the semantic name from the VariableTracker (param_1,
    /// rax, result, etc.).  Subsequent versions append _N suffix.
    ///
    /// @param canonReg    The canonical 64-bit register (e.g., "RAX").
    /// @param declBuilder OpBuilder positioned at function entry.
    /// @param loc         Source location.
    /// @param tracker     The VariableTracker (for semantic names).
    /// @param contextOp   Operation context (for return detection).
    /// @return            The new VarDeclOp.
    Operation* createNewVersion(llvm::StringRef canonReg,
                                OpBuilder& declBuilder,
                                Location loc,
                                VariableTracker& tracker,
                                Operation* contextOp = nullptr) {
        unsigned ver = versionCounters[canonReg]++;
        auto [baseName, storage] = tracker.getSemanticName(canonReg, contextOp);

        std::string varName;
        if (ver == 0) {
            varName = baseName;
        } else {
            varName = llvm::formatv("{0}_{1}", baseName, ver).str();
        }

        auto declOp = declBuilder.create<helix::high::VarDeclOp>(
            loc,
            /*var_id=*/varIdCounter++,
            /*var_name=*/varName,
            /*storage=*/storage,
            /*stack_offset=*/IntegerAttr{},
            /*init=*/Value{},
            /*address=*/IntegerAttr{});

        uint32_t newId = declOp.getVarId();
        current[canonReg] = {declOp, newId, varName};
        allVersions[canonReg].push_back({declOp, newId, varName});

        ++NumRegVarsCreated;
        ++NumSSAVersions;

        LLVM_DEBUG(llvm::dbgs() << "  SSA version: " << varName
                                << " (var_id=" << newId
                                << ", ver=" << ver
                                << " for " << canonReg << ")\n");

        return declOp;
    }

    /// Get the current version for a register read.
    /// @return  Pointer to the current version, or nullptr if none yet.
    const Version* getCurrentVersion(llvm::StringRef canonReg) const {
        auto it = current.find(canonReg);
        return (it != current.end()) ? &it->second : nullptr;
    }

    /// Snapshot type: a copy of the current register→version map.
    /// Used for multi-block SSA: snapshot at block exit, restore at
    /// block entry from the immediate dominator's exit state.
    using Snapshot = llvm::StringMap<Version>;

    /// Take a snapshot of the current SSA state.
    Snapshot snapshot() const { return current; }

    /// Restore SSA state from a snapshot (typically from idom exit).
    void restore(const Snapshot& snap) { current = snap; }
};

// ═══════════════════════════════════════════════════════════════════════════════
// Cast Emission Helpers
// ═══════════════════════════════════════════════════════════════════════════════

/// Emit a truncation cast from a wider type to a narrower type.
///
/// Used when reading a sub-register (e.g., reading EAX as a truncation
/// of the 64-bit RAX variable to 32 bits).
///
/// @param fullValue  The full-width SSA value (e.g., 64-bit RAX).
/// @param targetWidth The desired width in bits (e.g., 32 for EAX).
/// @param builder    OpBuilder at the desired insertion point.
/// @param loc        Source location.
/// @return           The truncated SSA value.
static Value emitTruncation(Value fullValue, unsigned targetWidth,
                            OpBuilder& builder, Location loc) {
    auto targetTy = builder.getIntegerType(targetWidth);

    // If the value is already the right width, no cast needed.
    if (fullValue.getType() == targetTy)
        return fullValue;

    return builder.create<helix::high::CastOp>(
        loc, targetTy, fullValue);
}

/// Emit a right-shift + truncation for high-byte registers (AH, BH, CH, DH).
///
/// The pattern is: `(rax >> 8) & 0xFF` — shift right by the bit offset,
/// then truncate to 8 bits.
///
/// @param fullValue  The full-width SSA value (64-bit parent register var).
/// @param bitOffset  The bit offset within the parent (8 for AH).
/// @param targetWidth The desired width (8 for AH).
/// @param builder    OpBuilder at the desired insertion point.
/// @param loc        Source location.
/// @return           The extracted sub-register value.
static Value emitHighByteExtract(Value fullValue, unsigned bitOffset,
                                 unsigned targetWidth,
                                 OpBuilder& builder, Location loc) {
    auto i64Ty = builder.getIntegerType(64);

    // Shift right by the bit offset.
    auto shiftAmount = builder.create<arith::ConstantOp>(
        loc, i64Ty, builder.getI64IntegerAttr(bitOffset));
    auto shifted = builder.create<arith::ShRUIOp>(
        loc, fullValue, shiftAmount);

    // Truncate to the target width.
    return emitTruncation(shifted, targetWidth, builder, loc);
}

/// Emit the write-back of a sub-register value into the full-width parent.
///
/// For 32-bit writes (EAX): x86-64 zero-extends to 64 bits.
/// For 16-bit writes (AX): only the low 16 bits are modified.
/// For 8-bit low writes (AL): only the low 8 bits are modified.
/// For 8-bit high writes (AH): bits [8:16) are modified.
///
/// @param parentVar  The full-width variable SSA value (64-bit).
/// @param newValue   The sub-register value being written.
/// @param info       Sub-register info (width, offset).
/// @param builder    OpBuilder at the desired insertion point.
/// @param loc        Source location.
/// @return           The new full-width value to store back.
static Value emitSubRegInsert(Value parentVar, Value newValue,
                              const SubRegInfo& info,
                              OpBuilder& builder, Location loc) {
    auto i64Ty = builder.getIntegerType(64);

    if (info.width == 64) {
        // Full-width write — no insertion needed.
        return newValue;
    }

    if (info.width == 32 && info.bitOffset == 0) {
        // x86-64: writing a 32-bit register zero-extends to 64 bits.
        // This is a simple zero-extension cast.
        return builder.create<helix::high::CastOp>(loc, i64Ty, newValue);
    }

    // For 16-bit and 8-bit writes, we need a read-modify-write pattern:
    //   new_full = (old_full & ~mask) | ((new_value & value_mask) << offset)

    // Build the mask to clear the target bits.
    uint64_t valueMask = (1ULL << info.width) - 1;
    uint64_t clearMask = ~(valueMask << info.bitOffset);

    auto clearMaskConst = builder.create<arith::ConstantOp>(
        loc, i64Ty, builder.getI64IntegerAttr(static_cast<int64_t>(clearMask)));
    auto clearedParent = builder.create<arith::AndIOp>(
        loc, parentVar, clearMaskConst);

    // Zero-extend the new value to 64 bits.
    Value extendedNew;
    if (newValue.getType() != i64Ty) {
        extendedNew = builder.create<helix::high::CastOp>(loc, i64Ty, newValue);
    } else {
        extendedNew = newValue;
    }

    // Shift the new value to the correct bit position.
    if (info.bitOffset > 0) {
        auto shiftAmount = builder.create<arith::ConstantOp>(
            loc, i64Ty, builder.getI64IntegerAttr(info.bitOffset));
        extendedNew = builder.create<arith::ShLIOp>(
            loc, extendedNew, shiftAmount);
    }

    // Mask the new value to prevent overflow into adjacent bits.
    auto valueMaskConst = builder.create<arith::ConstantOp>(
        loc, i64Ty,
        builder.getI64IntegerAttr(
            static_cast<int64_t>(valueMask << info.bitOffset)));
    auto maskedNew = builder.create<arith::AndIOp>(
        loc, extendedNew, valueMaskConst);

    // OR the cleared parent with the masked new value.
    return builder.create<arith::OrIOp>(loc, clearedParent, maskedNew);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Implementation
// ═══════════════════════════════════════════════════════════════════════════════

/// The variable recovery pass.
///
/// Iterates over all HelixLow register read/write operations within each
/// function and replaces them with HelixHigh variable references and
/// assignments.
struct RecoverVariablesPass
    : public PassWrapper<RecoverVariablesPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RecoverVariablesPass)

    StringRef getArgument() const final { return "recover-variables"; }
    StringRef getDescription() const final {
        return "Replace register references with named variables, handling "
               "sub-register aliases (EAX/AX/AL -> RAX truncations)";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<helix::high::HelixHighDialect>();
        registry.insert<mlir::arith::ArithDialect>();
        registry.insert<mlir::ub::UBDialect>();
        registry.insert<mlir::LLVM::LLVMDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();

        // Process each HelixLow function.
        auto result = module.walk([&](helix::low::FuncOp func) -> WalkResult {
            if (failed(recoverVariables(func)))
                return WalkResult::interrupt();
            return WalkResult::advance();
        });

        if (result.wasInterrupted()) {
            signalPassFailure();
            return;
        }
    }

private:
    /// Recover variables for a single function.
    ///
    /// Pipeline:
    ///   1. Create a VariableTracker for this function
    ///   2. Scan all RegRead/RegWrite ops
    ///   3. For each, resolve the sub-register alias to its canonical parent
    ///   4. Ensure a variable declaration exists for the parent
    ///   5. Replace the RegRead with a VarRef (+ cast if sub-register)
    ///   6. Replace the RegWrite with an Assign (+ insert if sub-register)
    ///
    /// @param func  The HelixLow function to process.
    /// @return      success() or failure().
    LogicalResult recoverVariables(helix::low::FuncOp func) {
        auto& funcBody = func.getBody();
        if (funcBody.empty())
            return success();

        OpBuilder builder(func->getContext());
        VariableTracker tracker;
        tracker.varIdCounter = getNextAvailableVarId(func);

        // ── Initialize calling convention info ───────────────────────────
        // The RecoverCallingConventionPass sets "calling_convention" and
        // "has_return_value" attributes on the function.  Three values are
        // possible today: "win64", "sysv", "cdecl" (32-bit x86 — all args on
        // the stack).  For cdecl we leave argRegPositions empty so the
        // parameter-register detection path finds nothing; stack-frame args
        // are recovered by RecoverStackLayout instead.
        bool isWin64 = true;
        bool isCdecl32 = false;
        if (auto ccAttr = func->getAttrOfType<StringAttr>("calling_convention")) {
            auto ccVal = ccAttr.getValue();
            isWin64   = (ccVal == "win64");
            isCdecl32 = (ccVal == "cdecl");
        }
        if (isCdecl32) {
            tracker.argRegPositions.clear();
        } else {
            tracker.initArgRegPositions(isWin64);
        }
        // Win64 entry points: incoming RCX/RDX/R8/R9 are OS-set values, not
        // named parameters.  RecoverCallingConvention sets "no_reg_params" to
        // suppress param_N naming for these functions.
        if (func->hasAttr("no_reg_params")) {
            tracker.argRegPositions.clear();
        }
        tracker.hasReturnValue =
            func->hasAttr("has_return_value");

        // Position the builder at the entry block's start for variable
        // declarations.  All var.decl ops go at the top of the function
        // (like local variable declarations in C).
        Block& entryBlock = funcBody.front();
        OpBuilder declBuilder(func->getContext());
        declBuilder.setInsertionPointToStart(&entryBlock);

        auto funcLoc = func.getLoc();

        LLVM_DEBUG({
            const char* ccDbg = isCdecl32 ? "cdecl"
                              : (isWin64  ? "win64" : "sysv");
            llvm::dbgs() << "RecoverVariables: processing '"
                         << func.getSymName() << "' (cc=" << ccDbg
                         << ", hasReturn=" << tracker.hasReturnValue << ")\n";
        });

        // ── Phase 0: Eliminate dead flag/RIP RegWrites ──────────────────
        //
        // Flag registers (CF, ZF, SF, OF, PF, AF, DF) and RIP are consumed
        // as direct SSA operands by JccOp/CMovOp during flag synthesis in
        // RemillToHelixLow.  By the time RecoverVariables runs, the RegWrite
        // ops to these registers are dead side-effects.  Erasing them
        // prevents creation of hundreds of useless temp variables.
        //
        // All production decompilers (IDA, Ghidra, RetDec, SAILR/angr)
        // eliminate flag writes before variable recovery.

        {
            auto isDeadFlagOrRIP = [](llvm::StringRef regName) -> bool {
                return regName == "CF" || regName == "ZF" ||
                       regName == "SF" || regName == "OF" ||
                       regName == "PF" || regName == "AF" ||
                       regName == "DF" || regName == "RIP";
            };

            // Three-pass collect-then-erase (LLVM Programmer's Manual
            // pattern — never mutate during walk, even with
            // make_early_inc_range, because cascade erases can
            // invalidate future ops in the same block).

            // Pass 1: Collect dead flag/RIP writes.
            llvm::SmallVector<helix::low::RegWriteOp, 32> deadFlagOps;
            funcBody.walk([&](helix::low::RegWriteOp writeOp) {
                if (isDeadFlagOrRIP(writeOp.getRegName()))
                    deadFlagOps.push_back(writeOp);
            });

            // Pass 2: Erase the collected writes.  Orphaned value
            // definitions are left for EliminateDeadCode to clean up
            // (erasing them here risks invalidating ops that the SSA
            // walk will visit later in this same pass).
            for (auto writeOp : deadFlagOps) {
                writeOp.erase();
                ++NumDeadFlagWrites;
            }
        }

        // ── Phase 1+2 (unified): Program-order SSA walk ────────────────
        //
        // Walks blocks in Reverse Post-Order (RPO) so that dominators
        // are always visited before the blocks they dominate.  At each
        // block entry, the SSA state is seeded from the immediate
        // dominator's exit state.  Join points with conflicting
        // register versions create fresh merge versions (conservative,
        // no phi nodes needed — CAstOptimizer inlines single-use vars).
        //
        // Each RegWrite creates a NEW variable version (rax, rax_1, ...)
        // and each RegRead references the MOST RECENT version.
        //
        // Industry standard: SAILR, Osprey, ReSym, Ghidra, IDA Pro all
        // create one variable per definition point.
        // RPO ordering: Braun et al., Section 2.2 (SSA construction).

        SSAVersionTracker ssaTracker(tracker.varIdCounter);

        // Initialize parameter registers with version 0 so that reads
        // before any write see the parameter variable.
        for (auto& [regName, paramIdx] : tracker.argRegPositions) {
            ssaTracker.createNewVersion(regName, declBuilder, funcLoc,
                                        tracker, /*contextOp=*/nullptr);
            LLVM_DEBUG(llvm::dbgs() << "  Initialized param register: "
                                    << regName << " as param_" << paramIdx
                                    << "\n");
        }

        // ── Compute block ordering ─────────────────────────────────────
        //
        // Try RPO (requires DominanceInfo).  If the CFG is irreducible,
        // the DominanceInfo constructor may assert — detect this with
        // the same BFS + forward-edge heuristic used in
        // StructureControlFlow, and fall back to region-order walk.

        llvm::SmallVector<Block*, 32> blockOrder;
        bool useRPO = false;
        DominanceInfo* domInfoPtr = nullptr;
        std::unique_ptr<DominanceInfo> domInfoOwner;

        // Check for irreducible CFG using Tarjan's SCC.
        // An SCC is irreducible if it has >1 entry block from outside.
        // The old heuristic (>= 3 predecessors) was removed because it
        // caused false positives on reducible switch-merge patterns.
        {
            bool likelyIrreducible = false;
            if (std::distance(funcBody.begin(), funcBody.end()) > 1) {
                // Lightweight SCC scan: collect all SCCs, check entries
                llvm::SmallVector<Block*, 32> allBlocks;
                for (auto& blk : funcBody)
                    allBlocks.push_back(&blk);

                // Simple Tarjan's inline (matches StructureControlFlow)
                llvm::DenseMap<Block*, unsigned> disc, low;
                llvm::DenseMap<Block*, bool> onStk;
                llvm::SmallVector<Block*, 32> stk;
                unsigned idx = 0;

                std::function<void(Block*)> tarjan = [&](Block* v) {
                    disc[v] = low[v] = idx++;
                    stk.push_back(v);
                    onStk[v] = true;
                    for (Block* w : v->getSuccessors()) {
                        if (!disc.count(w)) {
                            tarjan(w);
                            low[v] = std::min(low[v], low[w]);
                        } else if (onStk.lookup(w)) {
                            low[v] = std::min(low[v], disc[w]);
                        }
                    }
                    if (low[v] == disc[v]) {
                        llvm::SmallVector<Block*, 8> scc;
                        Block* w;
                        do {
                            w = stk.pop_back_val();
                            onStk[w] = false;
                            scc.push_back(w);
                        } while (w != v);
                        if (scc.size() >= 2) {
                            llvm::SmallPtrSet<Block*, 8> sccSet(
                                scc.begin(), scc.end());
                            unsigned entries = 0;
                            for (Block* b : scc) {
                                for (Block* pred : b->getPredecessors()) {
                                    if (!sccSet.contains(pred)) {
                                        ++entries;
                                        break;
                                    }
                                }
                            }
                            if (entries > 1)
                                likelyIrreducible = true;
                            // Guard: complex internal back-edges
                            if (!likelyIrreducible) {
                                for (Block* b : scc) {
                                    unsigned ip = 0;
                                    for (Block* p : b->getPredecessors())
                                        if (sccSet.contains(p)) ++ip;
                                    if (ip >= 3) {
                                        likelyIrreducible = true;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                };
                for (Block* b : allBlocks) {
                    if (!disc.count(b))
                        tarjan(b);
                }
            }

            // Also check for unreachable blocks (DomTree assert guard)
            if (!likelyIrreducible) {
                llvm::SmallPtrSet<Block*, 32> reachable;
                llvm::SmallVector<Block*, 32> wl;
                wl.push_back(&funcBody.front());
                while (!wl.empty()) {
                    Block* b = wl.pop_back_val();
                    if (!reachable.insert(b).second) continue;
                    for (Block* s : b->getSuccessors())
                        wl.push_back(s);
                }
                unsigned total =
                    std::distance(funcBody.begin(), funcBody.end());
                if (reachable.size() < total)
                    likelyIrreducible = true;
            }

            if (!likelyIrreducible &&
                std::distance(funcBody.begin(), funcBody.end()) > 1) {
                // Safe to construct DominanceInfo
                domInfoOwner = std::make_unique<DominanceInfo>(func);
                domInfoPtr = domInfoOwner.get();
                useRPO = true;

                // Compute RPO via post-order DFS + reverse
                llvm::SmallVector<Block*, 32> postOrder;
                llvm::SmallPtrSet<Block*, 32> visited;
                std::function<void(Block*)> postOrderDFS =
                    [&](Block* blk) {
                        if (!visited.insert(blk).second) return;
                        for (Block* succ : blk->getSuccessors())
                            postOrderDFS(succ);
                        postOrder.push_back(blk);
                    };
                postOrderDFS(&funcBody.front());
                // Reverse post-order = reverse of post-order
                for (auto it = postOrder.rbegin(); it != postOrder.rend();
                     ++it)
                    blockOrder.push_back(*it);

                LLVM_DEBUG(llvm::dbgs() << "  Using RPO ordering ("
                                        << blockOrder.size()
                                        << " blocks)\n");
            }
        }

        // If not using RPO, fall back to region order
        if (!useRPO) {
            for (auto& blk : funcBody)
                blockOrder.push_back(&blk);
            LLVM_DEBUG(llvm::dbgs() << "  Using region-order fallback ("
                                    << blockOrder.size()
                                    << " blocks)\n");
        }

        // Per-block SSA exit state snapshots (for idom seeding)
        llvm::DenseMap<Block*, SSAVersionTracker::Snapshot> blockExitState;

        // Walk blocks in computed order (RPO or region-order fallback).
        for (Block* blockPtr : blockOrder) {
            Block& block = *blockPtr;

            // ── Seed SSA state at block entry ──────────────────────────
            if (useRPO && &block != &funcBody.front()) {
                // Restore from immediate dominator's exit state
                auto* domNode = domInfoPtr->getNode(&block);
                if (domNode && domNode->getIDom()) {
                    Block* idom = domNode->getIDom()->getBlock();
                    auto it = blockExitState.find(idom);
                    if (it != blockExitState.end()) {
                        ssaTracker.restore(it->second);
                    }
                }

                // Handle join points: if multiple predecessors have
                // different versions of the same register, create a
                // fresh merge version (conservative — no phi nodes).
                unsigned numPreds = std::distance(block.pred_begin(),
                                                  block.pred_end());
                if (numPreds > 1) {
                    llvm::SmallVector<std::string, 4> conflicting;
                    for (auto& entry : ssaTracker.current) {
                        llvm::StringRef reg = entry.getKey();
                        const auto& curVer = entry.getValue();
                        bool hasConflict = false;
                        for (Block* pred : block.getPredecessors()) {
                            auto predIt = blockExitState.find(pred);
                            if (predIt == blockExitState.end()) continue;
                            auto predRegIt = predIt->second.find(reg);
                            if (predRegIt == predIt->second.end()) continue;
                            if (predRegIt->second.varId != curVer.varId) {
                                hasConflict = true;
                                break;
                            }
                        }
                        if (hasConflict)
                            conflicting.push_back(reg.str());
                    }
                    for (auto& reg : conflicting) {
                        ssaTracker.createNewVersion(
                            reg, declBuilder, funcLoc, tracker);
                    }
                }
            }

            // ── Process ops in program order within the block ───────
            for (auto& op : llvm::make_early_inc_range(block)) {

                // ── Handle RegRead ──────────────────────────────────────
                if (auto readOp = dyn_cast<helix::low::RegReadOp>(&op)) {
                    auto regName = readOp.getRegName();

                    // Resolve sub-register alias.
                    auto subRegOpt = getSubRegInfo(regName);
                    if (!subRegOpt) {
                        // Unknown register — emit as a temporary variable.
                        LLVM_DEBUG(llvm::dbgs() << "  Unknown register: "
                                                << regName << " -> temp\n");
                        builder.setInsertionPoint(readOp);
                        auto* tempDecl = tracker.declareTemp(
                            readOp.getResult().getType(), declBuilder,
                            funcLoc);
                        auto tempTyped =
                            llvm::cast<helix::high::VarDeclOp>(tempDecl);
                        auto varRef =
                            builder.create<helix::high::VarRefOp>(
                                readOp.getLoc(),
                                readOp.getResult().getType(),
                                tempTyped.getVarId(),
                                tempTyped.getVarName(),
                                mlir::IntegerAttr{});
                        if (readOp->hasAttr("helix.infrastructure")) {
                            varRef->setAttr("helix.infrastructure",
                                builder.getUnitAttr());
                            tempTyped->setAttr("helix.infrastructure",
                                builder.getUnitAttr());
                        }
                        readOp.getResult().replaceAllUsesWith(
                            varRef.getResult());
                        readOp.erase();
                        ++NumReadsReplaced;
                        continue;
                    }

                    auto& subReg = *subRegOpt;

                    // Get the current SSA version for this register.
                    // If no version exists yet (read before any write),
                    // create an initial version.
                    auto* ver = ssaTracker.getCurrentVersion(subReg.parent);
                    if (!ver) {
                        ssaTracker.createNewVersion(
                            subReg.parent, declBuilder, funcLoc,
                            tracker, readOp);
                        ver = ssaTracker.getCurrentVersion(subReg.parent);
                    }

                    builder.setInsertionPoint(readOp);

                    // Propagate inferred_type to the VarDeclOp.
                    // Pointer types override int types (TIE lattice:
                    // ptr is more specific than num).
                    auto varDeclOp =
                        llvm::cast<helix::high::VarDeclOp>(ver->decl);
                    if (auto inferredType =
                            readOp->getAttrOfType<StringAttr>(
                                "inferred_type")) {
                        bool shouldSet = !varDeclOp->hasAttr("inferred_type");
                        if (!shouldSet) {
                            // Pointer overrides int (more specific type)
                            auto curType = varDeclOp->getAttrOfType<
                                StringAttr>("inferred_type");
                            if (curType &&
                                !curType.getValue().ends_with("*") &&
                                inferredType.getValue().ends_with("*"))
                                shouldSet = true;
                        }
                        if (shouldSet)
                            varDeclOp->setAttr("inferred_type",
                                               inferredType);
                    }

                    // Track param naming statistics.
                    if (tracker.argRegPositions.count(subReg.parent))
                        ++NumParamsNamed;
                    if (subReg.parent == "RAX" && tracker.hasReturnValue &&
                        VariableTracker::isReturnContext(readOp,
                                                        subReg.parent))
                        ++NumReturnVarsNamed;

                    // Create VarRef with THIS version's var_id.
                    auto i64Ty = builder.getIntegerType(64);
                    auto varRef = builder.create<helix::high::VarRefOp>(
                        readOp.getLoc(), i64Ty,
                        ver->varId,
                        builder.getStringAttr(ver->varName),
                        mlir::IntegerAttr{});

                    // Handle sub-register truncation.
                    Value result;
                    if (subReg.width == 64 && subReg.bitOffset == 0) {
                        result = varRef.getResult();
                    } else if (subReg.bitOffset == 0) {
                        result = emitTruncation(varRef.getResult(),
                                                subReg.width, builder,
                                                readOp.getLoc());
                        ++NumAliasesResolved;
                    } else {
                        result = emitHighByteExtract(
                            varRef.getResult(), subReg.bitOffset,
                            subReg.width, builder, readOp.getLoc());
                        ++NumAliasesResolved;
                    }

                    if (readOp->hasAttr("helix.infrastructure"))
                        varRef->setAttr("helix.infrastructure",
                            builder.getUnitAttr());

                    readOp.getResult().replaceAllUsesWith(result);
                    readOp.erase();
                    ++NumReadsReplaced;
                    continue;
                }

                // ── Handle RegWrite ─────────────────────────────────────
                if (auto writeOp = dyn_cast<helix::low::RegWriteOp>(&op)) {
                    auto regName = writeOp.getRegName();

                    // Resolve sub-register alias.
                    auto subRegOpt = getSubRegInfo(regName);
                    if (!subRegOpt) {
                        // Unknown register — emit as temporary assignment.
                        LLVM_DEBUG(llvm::dbgs()
                            << "  Unknown register write: "
                            << regName << " -> temp assign\n");
                        builder.setInsertionPoint(writeOp);
                        auto* tempDecl = tracker.declareTemp(
                            writeOp.getValue().getType(), declBuilder,
                            funcLoc);
                        auto tempTyped2 =
                            llvm::cast<helix::high::VarDeclOp>(tempDecl);
                        auto tempRef =
                            builder.create<helix::high::VarRefOp>(
                                writeOp.getLoc(),
                                writeOp.getValue().getType(),
                                tempTyped2.getVarId(),
                                tempTyped2.getVarName(),
                                mlir::IntegerAttr{});
                        auto assignOp =
                            builder.create<helix::high::AssignOp>(
                                writeOp.getLoc(),
                                tempRef.getResult(),
                                writeOp.getValue(),
                                mlir::IntegerAttr{});
                        if (writeOp->hasAttr("helix.infrastructure")) {
                            assignOp->setAttr("helix.infrastructure",
                                builder.getUnitAttr());
                            tempTyped2->setAttr("helix.infrastructure",
                                builder.getUnitAttr());
                        }
                        writeOp.erase();
                        ++NumWritesReplaced;
                        continue;
                    }

                    auto& subReg = *subRegOpt;

                    builder.setInsertionPoint(writeOp);

                    Value valueToStore;
                    if (subReg.width == 64 && subReg.bitOffset == 0) {
                        // Full-width write — direct assignment.
                        valueToStore = writeOp.getValue();
                    } else {
                        // Sub-register write — read-modify-write.
                        // Read the CURRENT version of the parent register.
                        auto* prevVer =
                            ssaTracker.getCurrentVersion(subReg.parent);
                        if (!prevVer) {
                            // No previous version — create initial one.
                            ssaTracker.createNewVersion(
                                subReg.parent, declBuilder, funcLoc,
                                tracker, writeOp);
                            prevVer = ssaTracker.getCurrentVersion(
                                subReg.parent);
                        }

                        auto i64Ty = builder.getIntegerType(64);
                        auto currentVar =
                            builder.create<helix::high::VarRefOp>(
                                writeOp.getLoc(), i64Ty,
                                prevVer->varId,
                                builder.getStringAttr(prevVer->varName),
                                mlir::IntegerAttr{});

                        valueToStore = emitSubRegInsert(
                            currentVar.getResult(), writeOp.getValue(),
                            subReg, builder, writeOp.getLoc());
                        ++NumAliasesResolved;
                    }

                    // CREATE NEW VERSION for this write — the core of SSA
                    // splitting.  Every RegWrite gets a unique var_id.
                    auto* newDecl = ssaTracker.createNewVersion(
                        subReg.parent, declBuilder, funcLoc,
                        tracker, writeOp);
                    auto newDeclTyped =
                        llvm::cast<helix::high::VarDeclOp>(newDecl);

                    // Propagate inferred_type from the written value.
                    if (!newDeclTyped->hasAttr("inferred_type")) {
                        if (auto* valDef =
                                writeOp.getValue().getDefiningOp()) {
                            if (auto inferredType =
                                    valDef->getAttrOfType<StringAttr>(
                                        "inferred_type"))
                                newDeclTyped->setAttr("inferred_type",
                                                      inferredType);
                        }
                        if (!newDeclTyped->hasAttr("inferred_type")) {
                            if (auto inferredType =
                                    writeOp->getAttrOfType<StringAttr>(
                                        "inferred_type"))
                                newDeclTyped->setAttr("inferred_type",
                                                      inferredType);
                        }
                    }

                    // Emit the assignment to the NEW version.
                    auto targetRef =
                        builder.create<helix::high::VarRefOp>(
                            writeOp.getLoc(),
                            valueToStore.getType(),
                            newDeclTyped.getVarId(),
                            newDeclTyped.getVarName(),
                            mlir::IntegerAttr{});
                    auto assignOp2 =
                        builder.create<helix::high::AssignOp>(
                            writeOp.getLoc(),
                            targetRef.getResult(),
                            valueToStore,
                            mlir::IntegerAttr{});

                    // Propagate infrastructure marker.
                    if (writeOp->hasAttr("helix.infrastructure") ||
                        (writeOp.getValue().getDefiningOp() &&
                         writeOp.getValue().getDefiningOp()->hasAttr(
                             "helix.infrastructure"))) {
                        assignOp2->setAttr("helix.infrastructure",
                            builder.getUnitAttr());
                    }

                    writeOp.erase();
                    ++NumWritesReplaced;
                    continue;
                }
            }

            // ── Snapshot block exit state for idom seeding ──────────
            if (useRPO) {
                blockExitState[blockPtr] = ssaTracker.snapshot();
            }
        }

        // ── Phase 3: Replace __undef references ─────────────────────────
        //
        // Walk all operations looking for operands defined by LLVM::UndefOp
        // (which the PseudoCEmitter would render as "__undef"). Replace each
        // with a typed default value:
        //   - Integer types  → arith.constant 0
        //   - Pointer types  → arith.constant 0 + inttoptr (nullptr)
        //   - Float types    → arith.constant 0.0
        //
        // When the undef is used as a call argument, also emit a
        // helix_high.comment "valor não rastreado" before the call.
        //
        // The inferred_type attribute (set by PropagateTypes) is checked
        // first; if absent, we fall back to the MLIR type of the value.

        // Collect all UndefOp instances in this function.
        llvm::SmallVector<LLVM::UndefOp, 8> undefOps;
        funcBody.walk([&](LLVM::UndefOp undefOp) {
            undefOps.push_back(undefOp);
        });

        // Also collect ub.poison ops (alternative undef representation).
        llvm::SmallVector<mlir::ub::PoisonOp, 8> poisonOps;
        funcBody.walk([&](mlir::ub::PoisonOp poisonOp) {
            poisonOps.push_back(poisonOp);
        });

        // Track which call ops need a "valor não rastreado" comment.
        // We use a set to avoid emitting duplicate comments for the same call.
        llvm::SmallPtrSet<Operation*, 4> callsNeedingComment;

        // Helper lambda: determine if a type string (from inferred_type attr)
        // indicates a pointer type.
        auto isPointerTypeStr = [](llvm::StringRef typeStr) -> bool {
            return typeStr.contains('*');
        };

        // Helper lambda: determine if a type string indicates a float type.
        auto isFloatTypeStr = [](llvm::StringRef typeStr) -> bool {
            return typeStr.starts_with("float") || typeStr.starts_with("double");
        };

        // Helper lambda: create a typed default value for a given MLIR type
        // and optional inferred_type string.
        auto createDefaultValue = [&](Type mlirType, Operation* defOp,
                                      Location loc) -> Value {
            builder.setInsertionPointAfter(defOp);

            // Check the inferred_type attribute first.
            StringRef inferredType;
            if (auto attr = defOp->getAttrOfType<StringAttr>("inferred_type"))
                inferredType = attr.getValue();

            // Pointer type → constant 0 cast to pointer (nullptr).
            if (!inferredType.empty() && isPointerTypeStr(inferredType)) {
                auto i64Ty = builder.getIntegerType(64);
                auto zero = builder.create<arith::ConstantOp>(
                    loc, i64Ty, builder.getI64IntegerAttr(0));
                return builder.create<LLVM::IntToPtrOp>(
                    loc, LLVM::LLVMPointerType::get(builder.getContext()),
                    zero);
            }

            // Float type → constant 0.0.
            if (!inferredType.empty() && isFloatTypeStr(inferredType)) {
                if (isa<Float32Type>(mlirType)) {
                    return builder.create<arith::ConstantOp>(
                        loc, mlirType,
                        builder.getF32FloatAttr(0.0f));
                }
                if (isa<Float64Type>(mlirType)) {
                    return builder.create<arith::ConstantOp>(
                        loc, mlirType,
                        builder.getF64FloatAttr(0.0));
                }
                // Fallback for other float widths: use f64.
                auto f64Ty = builder.getF64Type();
                return builder.create<arith::ConstantOp>(
                    loc, f64Ty, builder.getF64FloatAttr(0.0));
            }

            // Check MLIR type directly if no inferred_type attribute.
            if (isa<LLVM::LLVMPointerType>(mlirType)) {
                auto i64Ty = builder.getIntegerType(64);
                auto zero = builder.create<arith::ConstantOp>(
                    loc, i64Ty, builder.getI64IntegerAttr(0));
                return builder.create<LLVM::IntToPtrOp>(
                    loc, mlirType, zero);
            }

            if (isa<Float32Type>(mlirType)) {
                return builder.create<arith::ConstantOp>(
                    loc, mlirType, builder.getF32FloatAttr(0.0f));
            }

            if (isa<Float64Type>(mlirType)) {
                return builder.create<arith::ConstantOp>(
                    loc, mlirType, builder.getF64FloatAttr(0.0));
            }

            // Integer type (default) → constant 0 of the same width.
            if (auto intTy = dyn_cast<IntegerType>(mlirType)) {
                return builder.create<arith::ConstantOp>(
                    loc, intTy,
                    builder.getIntegerAttr(intTy, 0));
            }

            // Fallback: i64 zero (for unknown types).
            auto i64Ty = builder.getIntegerType(64);
            return builder.create<arith::ConstantOp>(
                loc, i64Ty, builder.getI64IntegerAttr(0));
        };

        // Helper lambda: check if a user operation is a call and the value
        // is one of its arguments. If so, mark the call for a comment.
        auto checkCallArgument = [&](Value undefVal) {
            for (auto& use : undefVal.getUses()) {
                Operation* user = use.getOwner();
                // Check helix_high.call
                if (auto highCall = dyn_cast<helix::high::CallOp>(user)) {
                    // The value is an argument if it's in the args() range.
                    for (auto arg : highCall.getArgs()) {
                        if (arg == undefVal) {
                            callsNeedingComment.insert(user);
                            break;
                        }
                    }
                }
                // Check helix_low.call — at this stage, undef values used
                // as the target_addr operand of a low-level call are not
                // "arguments" in the calling-convention sense, but we still
                // flag them for the comment.
                if (helix::isAnyCallOp(user)) {
                    callsNeedingComment.insert(user);
                }
            }
        };

        // Process LLVM::UndefOp instances.
        for (auto undefOp : undefOps) {
            Value undefVal = undefOp.getResult();
            if (undefVal.use_empty()) {
                // No users — just erase.
                undefOp.erase();
                continue;
            }

            checkCallArgument(undefVal);

            Value replacement = createDefaultValue(
                undefVal.getType(), undefOp, undefOp.getLoc());
            undefVal.replaceAllUsesWith(replacement);
            undefOp.erase();
            ++NumUndefReplaced;
        }

        // Process ub.poison instances (alternative undef representation).
        for (auto poisonOp : poisonOps) {
            Value poisonVal = poisonOp.getResult();
            if (poisonVal.use_empty()) {
                poisonOp.erase();
                continue;
            }

            checkCallArgument(poisonVal);

            Value replacement = createDefaultValue(
                poisonVal.getType(), poisonOp, poisonOp.getLoc());
            poisonVal.replaceAllUsesWith(replacement);
            poisonOp.erase();
            ++NumUndefReplaced;
        }

        // Emit "valor não rastreado" comments before calls that had undef args.
        for (Operation* callOp : callsNeedingComment) {
            builder.setInsertionPoint(callOp);
            builder.create<helix::high::CommentOp>(
                callOp->getLoc(),
                "valor não rastreado");
        }

        LLVM_DEBUG(llvm::dbgs() << "  Phase 3: replaced "
                                << NumUndefReplaced
                                << " __undef references\n");

        LLVM_DEBUG({
            llvm::dbgs() << "  Summary: "
                         << ssaTracker.versionCounters.size()
                         << " registers with "
                         << NumSSAVersions << " SSA versions, "
                         << tracker.stackOffsetToDecl.size() << " stack vars, "
                         << tracker.tempCounter << " temps\n";
        });

        // ── Phase 3.5: Same-register SSA version coalescing ──────────────
        //
        // For each canonical register (RAX, RBX, etc.), check if multiple
        // SSA versions can be collapsed into a single variable.  This
        // converts  "rax, rax_1, rax_2"  →  "rax"  with reassignments.
        //
        // Algorithm:
        //   1. Group VarDeclOps by source register (from allVersions)
        //   2. For each version V_i (i>0) of register R:
        //      a. Collect blocks where V_0 and V_i are referenced
        //      b. If no block contains uses of BOTH after V_i's def → coalesce
        //      c. For same-block versions: use program-order position check
        //   3. Rewrite V_i's VarRefOps → V_0, erase V_i's VarDeclOp
        //
        // This runs BEFORE Phase 4 (generic cover-based merge) because it
        // has register-awareness: it knows rax_0 and rax_1 are the same
        // logical variable and can safely be merged even when Phase 4's
        // block-level overlap check would reject them.

        LLVM_DEBUG(llvm::dbgs()
            << "  Phase 3.5: same-register SSA version coalescing\n");

        // Pre-compute usage classification for every variable referenced in
        // the function.  Each variable is classified as:
        //   - Address: used as a pointer (mem.read addr, field access base)
        //   - Value:   used in arithmetic, comparison, etc.
        //   - Mixed:   both address and value uses
        //   - None:    no classifying uses
        //
        // Used for semantic compatibility in coalescing — we refuse to merge
        // an Address-only variable with a Value-only variable, even if the
        // explicit type attributes don't conflict.
        enum class UsageKind : uint8_t { None, Address, Value, Mixed };
        llvm::DenseMap<unsigned, uint8_t> usageMap;
        funcBody.walk([&](helix::high::VarRefOp ref) {
            unsigned varId = ref.getVarId();
            uint8_t flags = usageMap.lookup(varId);
            // bit 0 = addr use, bit 1 = value use
            for (auto& use : ref.getResult().getUses()) {
                Operation* user = use.getOwner();
                unsigned idx = use.getOperandNumber();

                if (isa<helix::low::MemReadOp>(user)) {
                    if (idx == 0) flags |= 0x1;  // addr operand
                } else if (isa<helix::low::MemWriteOp>(user)) {
                    if (idx == 0) flags |= 0x1;  // addr operand
                    else flags |= 0x2;            // value operand
                } else if (isa<helix::high::FieldAccessOp>(user)) {
                    if (idx == 0) flags |= 0x1;  // base operand
                } else if (isa<arith::AddIOp>(user) ||
                           isa<arith::SubIOp>(user) ||
                           isa<arith::MulIOp>(user) ||
                           isa<arith::DivSIOp>(user) ||
                           isa<arith::DivUIOp>(user) ||
                           isa<arith::CmpIOp>(user) ||
                           isa<arith::ShLIOp>(user) ||
                           isa<arith::ShRSIOp>(user) ||
                           isa<arith::ShRUIOp>(user) ||
                           isa<arith::AndIOp>(user) ||
                           isa<arith::OrIOp>(user) ||
                           isa<arith::XOrIOp>(user)) {
                    flags |= 0x2;
                } else if (isa<helix::low::BinOp>(user)) {
                    flags |= 0x2;
                }
            }
            usageMap[varId] = flags;
        });

        auto getUsageKind = [&](unsigned varId) -> UsageKind {
            uint8_t flags = usageMap.lookup(varId);
            bool addr = (flags & 0x1) != 0;
            bool val  = (flags & 0x2) != 0;
            if (addr && val) return UsageKind::Mixed;
            if (addr) return UsageKind::Address;
            if (val) return UsageKind::Value;
            return UsageKind::None;
        };

        // Helper: returns true if a type string represents a pointer.
        auto isPtrTypeStr = [](StringRef s) {
            return !s.empty() && s.ends_with("*");
        };

        {
            unsigned coalesced = 0;

            for (auto& entry : ssaTracker.allVersions) {
                auto& versions = entry.getValue();
                if (versions.size() <= 1)
                    continue;

                // Base version (version 0) — the one we keep.
                auto& base = versions[0];
                if (!base.decl)
                    continue;

                // Type of the base version (for compatibility check).
                auto baseTypeAttr =
                    base.decl->getAttrOfType<StringAttr>("inferred_type");
                bool basePtr = static_cast<bool>(baseTypeAttr) &&
                               isPtrTypeStr(baseTypeAttr.getValue());
                auto baseKind = getUsageKind(base.varId);

                for (size_t vi = 1; vi < versions.size(); ++vi) {
                    auto& ver = versions[vi];
                    if (!ver.decl)
                        continue;

                    // ── Type compatibility check ──────────────────────────
                    auto verTypeAttr =
                        ver.decl->getAttrOfType<StringAttr>("inferred_type");
                    if (baseTypeAttr && verTypeAttr &&
                        baseTypeAttr.getValue() != verTypeAttr.getValue())
                        continue;

                    // ── Pointer/non-pointer type mismatch ─────────────────
                    // Refuse coalescing if exactly one version is explicitly
                    // typed as a pointer.  This catches the case where one
                    // version had its pointer type inferred but the other
                    // version was untyped (or typed as integer).
                    bool verPtr = static_cast<bool>(verTypeAttr) &&
                                  isPtrTypeStr(verTypeAttr.getValue());
                    if (basePtr != verPtr) {
                        if (baseTypeAttr || verTypeAttr) continue;
                    }

                    // ── Semantic usage compatibility ──────────────────────
                    // Refuse coalescing if one version is used exclusively
                    // as an address (pointer) and the other exclusively as
                    // a value (arithmetic operand).  This catches the case
                    // where the Remill lift assigned the same register to
                    // semantically distinct values that share no type info.
                    auto verKind = getUsageKind(ver.varId);
                    if ((baseKind == UsageKind::Address &&
                         verKind == UsageKind::Value) ||
                        (baseKind == UsageKind::Value &&
                         verKind == UsageKind::Address))
                        continue;

                    // ── Liveness interference check ───────────────────────
                    //
                    // Collect blocks where base and ver are referenced.
                    // If they share no block → safe (same as Phase 4 check).
                    // If they share a block → fine-grained position check.

                    llvm::SmallPtrSet<Block*, 4> baseBlocks;
                    llvm::SmallPtrSet<Block*, 4> verBlocks;

                    funcBody.walk([&](helix::high::VarRefOp ref) {
                        if (ref.getVarId() == base.varId)
                            baseBlocks.insert(ref->getBlock());
                        else if (ref.getVarId() == ver.varId)
                            verBlocks.insert(ref->getBlock());
                    });

                    // ── FIX-080 (Wave 19): dependency-aware interference ───
                    //
                    // The Phase 3.5 baseline check only looks for uses of
                    // `base` AFTER `ver`'s assign in program order.  That
                    // misses one common operand-binding defect: when
                    // `ver`'s assigned VALUE itself transitively reads
                    // `base` through the SSA def chain.  Example:
                    //
                    //   v5 = ftrace_set_filter_ip(v2, v4, ...)
                    //                                ^ ver = call result
                    //                                       (RAX_new)
                    //                                v4 = base = pre-call RAX
                    //
                    // Without this check, the post-def scan finds no use
                    // of base after the assign and coalesces them → both
                    // names become `v4`, producing `v4 = ftrace_set_filter_ip(v2, v4, ...)`
                    // — the suspicious self-reference the validator flags.
                    //
                    // Helper: walks the SSA def chain of `start` looking
                    // for any VarRefOp whose varId matches `targetVarId`.
                    // Only traces through value-producing ops (operands of
                    // the call result chain).  This catches direct
                    // self-references in the assign's RHS expression tree.
                    auto valueDependsOnBase = [&](Value start,
                                                  unsigned targetVarId) {
                        llvm::SmallPtrSet<Operation*, 32> visited;
                        std::function<bool(Value)> rec = [&](Value v) -> bool {
                            if (!v) return false;
                            auto* defOp = v.getDefiningOp();
                            if (!defOp) return false;
                            if (!visited.insert(defOp).second) return false;
                            if (auto ref =
                                    dyn_cast<helix::high::VarRefOp>(defOp)) {
                                return ref.getVarId() == targetVarId;
                            }
                            for (Value operand : defOp->getOperands()) {
                                if (rec(operand)) return true;
                            }
                            return false;
                        };
                        return rec(start);
                    };

                    // Check for shared blocks.
                    bool interferes = false;
                    for (auto* blk : baseBlocks) {
                        if (!verBlocks.contains(blk))
                            continue;

                        // Both present in this block.  Fine-grained check:
                        // scan ops in program order.  Find the FIRST def of
                        // ver (its AssignOp target).  If base has any use
                        // AFTER that def → interference.
                        Operation* verDefPoint = nullptr;
                        helix::high::AssignOp verDefAssign;
                        for (auto& op : *blk) {
                            if (auto assign =
                                    dyn_cast<helix::high::AssignOp>(&op)) {
                                auto target =
                                    assign.getTarget()
                                        .getDefiningOp<helix::high::VarRefOp>();
                                if (target &&
                                    target.getVarId() == ver.varId) {
                                    verDefPoint = &op;
                                    verDefAssign = assign;
                                    break;
                                }
                            }
                        }

                        if (!verDefPoint) {
                            // ver is read but never defined in this block —
                            // it was defined in a dominator.  If base is also
                            // used here, they interfere (both "live-in").
                            interferes = true;
                            break;
                        }

                        // FIX-080: the assign VALUE may transitively read
                        // `base`.  If so, coalescing would collapse two
                        // semantically distinct register versions onto one
                        // name and produce a self-referential statement.
                        if (verDefAssign && verDefAssign.getValue() &&
                            valueDependsOnBase(verDefAssign.getValue(),
                                               base.varId)) {
                            interferes = true;
                            break;
                        }

                        // Scan from verDefPoint to end of block: any use of
                        // base after this point means interference.
                        bool pastDef = false;
                        for (auto& op : *blk) {
                            if (&op == verDefPoint) {
                                pastDef = true;
                                continue;
                            }
                            if (!pastDef)
                                continue;
                            if (auto ref =
                                    dyn_cast<helix::high::VarRefOp>(&op)) {
                                if (ref.getVarId() == base.varId) {
                                    // Check if this is a VALUE read (not an
                                    // assign target).
                                    bool isTarget = false;
                                    for (auto& use :
                                         ref.getResult().getUses()) {
                                        if (auto a =
                                                dyn_cast<helix::high::AssignOp>(
                                                    use.getOwner())) {
                                            if (use.getOperandNumber() == 0)
                                                isTarget = true;
                                        }
                                    }
                                    if (!isTarget) {
                                        interferes = true;
                                        break;
                                    }
                                }
                            }
                        }

                        if (interferes)
                            break;
                    }

                    if (interferes)
                        continue;

                    // ── Coalesce: rewrite all VarRefOps of ver → base ─────
                    LLVM_DEBUG(llvm::dbgs()
                        << "    Coalescing '" << ver.varName
                        << "' (id=" << ver.varId
                        << ") into '" << base.varName
                        << "' (id=" << base.varId << ")\n");

                    funcBody.walk([&](helix::high::VarRefOp ref) {
                        if (ref.getVarId() == ver.varId) {
                            ref.setVarId(base.varId);
                            ref.setVarName(base.varName);
                        }
                    });

                    // Propagate type from ver → base if base lacks one.
                    if (!baseTypeAttr && verTypeAttr)
                        base.decl->setAttr("inferred_type", verTypeAttr);

                    // Erase ver's VarDeclOp.
                    ver.decl->erase();
                    ver.decl = nullptr;

                    ++coalesced;
                    ++NumVersionsCoalesced;
                }
            }

            LLVM_DEBUG(llvm::dbgs()
                << "    Coalesced " << coalesced
                << " SSA versions\n");
        }

        // ── Phase 4: Cover-based variable merging ─────────────────────────
        //
        // Reduce variable count by merging variables whose live ranges do
        // not overlap.  A "live range" is approximated as the set of basic
        // blocks in which the variable is referenced (via VarRefOp).
        //
        // Invariants:
        //   - Parameters are never merged with locals.
        //   - Variables with an inferred_type attribute are only merged if
        //     the attribute values match (conservative type safety).
        //   - We do not merge across function-call boundaries within a
        //     single block — if two variables are both live in a block
        //     that contains a CallOp, they are considered overlapping.
        //   - Maximum 3 merge iterations to guarantee termination.
        //
        // After merging, single-use temporaries (assigned once, read once,
        // both in the same block) are inlined away.

        LLVM_DEBUG(llvm::dbgs() << "  Phase 4: cover-based variable merging\n");

        // ---------- Helper: collect variable info for merging ----------

        /// Per-variable bookkeeping for the merge pass.
        struct VarInfo {
            helix::high::VarDeclOp decl;
            std::vector<helix::high::VarRefOp> refs;
            std::set<Block*> liveBlocks;
            bool touchesCallBlock = false;
        };

        auto buildVarInfoMap = [&](Region& body)
            -> std::map<uint32_t, VarInfo>
        {
            std::map<uint32_t, VarInfo> infoMap;

            // 1. Collect declarations.
            body.walk([&](helix::high::VarDeclOp decl) {
                auto id = decl.getVarId();
                infoMap[id].decl = decl;
            });

            // 2. Collect references and live blocks.
            body.walk([&](helix::high::VarRefOp ref) {
                auto id = ref.getVarId();
                auto it = infoMap.find(id);
                if (it == infoMap.end())
                    return;  // orphan ref — skip
                it->second.refs.push_back(ref);
                if (auto* blk = ref->getBlock())
                    it->second.liveBlocks.insert(blk);
            });

            // 3. Mark variables that appear in blocks containing calls.
            std::set<Block*> callBlocks;
            body.walk([&](Operation* op) {
                if (isa<helix::high::CallOp>(op) ||
                    helix::isAnyCallOp(op)) {
                    if (auto* blk = op->getBlock())
                        callBlocks.insert(blk);
                }
            });

            for (auto& [id, info] : infoMap) {
                for (auto* blk : info.liveBlocks) {
                    if (callBlocks.contains(blk)) {
                        info.touchesCallBlock = true;
                        break;
                    }
                }
            }

            return infoMap;
        };

        // ---------- Helper: check type compatibility ----------

        auto areTypesCompatible = [&](helix::high::VarDeclOp a,
                                      helix::high::VarDeclOp b) -> bool {
            // Check inferred_type attributes — if present, they must match.
            auto aType = a->getAttrOfType<StringAttr>("inferred_type");
            auto bType = b->getAttrOfType<StringAttr>("inferred_type");
            if (aType && bType && aType.getValue() != bType.getValue())
                return false;
            // If one has an inferred type and the other doesn't, be
            // conservative and refuse.
            if ((aType && !bType) || (!aType && bType))
                return false;
            return true;
        };

        // Rebuild the usage map for Phase 4 — Phase 3.5 may have changed
        // varIds via coalescing rewrites.
        usageMap.clear();
        funcBody.walk([&](helix::high::VarRefOp ref) {
            unsigned varId = ref.getVarId();
            uint8_t flags = usageMap.lookup(varId);
            for (auto& use : ref.getResult().getUses()) {
                Operation* user = use.getOwner();
                unsigned idx = use.getOperandNumber();

                if (isa<helix::low::MemReadOp>(user)) {
                    if (idx == 0) flags |= 0x1;
                } else if (isa<helix::low::MemWriteOp>(user)) {
                    if (idx == 0) flags |= 0x1;
                    else flags |= 0x2;
                } else if (isa<helix::high::FieldAccessOp>(user)) {
                    if (idx == 0) flags |= 0x1;
                } else if (isa<arith::AddIOp>(user) ||
                           isa<arith::SubIOp>(user) ||
                           isa<arith::MulIOp>(user) ||
                           isa<arith::DivSIOp>(user) ||
                           isa<arith::DivUIOp>(user) ||
                           isa<arith::CmpIOp>(user) ||
                           isa<arith::ShLIOp>(user) ||
                           isa<arith::ShRSIOp>(user) ||
                           isa<arith::ShRUIOp>(user) ||
                           isa<arith::AndIOp>(user) ||
                           isa<arith::OrIOp>(user) ||
                           isa<arith::XOrIOp>(user)) {
                    flags |= 0x2;
                } else if (isa<helix::low::BinOp>(user)) {
                    flags |= 0x2;
                }
            }
            usageMap[varId] = flags;
        });

        // Phase 4 semantic compatibility: refuse merging an Address-only
        // variable with a Value-only variable.
        auto areSemanticsCompatible = [&](uint32_t idA, uint32_t idB) -> bool {
            uint8_t a = usageMap.lookup(idA);
            uint8_t b = usageMap.lookup(idB);
            bool aAddr = (a & 0x1) != 0;
            bool aVal  = (a & 0x2) != 0;
            bool bAddr = (b & 0x1) != 0;
            bool bVal  = (b & 0x2) != 0;
            // Address-only and Value-only conflict
            if (aAddr && !aVal && bVal && !bAddr) return false;
            if (bAddr && !bVal && aVal && !aAddr) return false;
            return true;
        };

        // ---------- Helper: check if live ranges overlap ----------

        auto rangesOverlap = [](const VarInfo& a,
                                const VarInfo& b) -> bool {
            for (auto* blk : a.liveBlocks) {
                if (b.liveBlocks.contains(blk))
                    return true;
            }
            return false;
        };

        // ---------- Helper: prefer non-synthetic names ----------

        auto isSyntheticName = [](llvm::StringRef name) -> bool {
            // _promoted_N, spill_N, vN patterns
            if (name.starts_with("_promoted_"))  return true;
            if (name.starts_with("spill_"))      return true;
            // "vN" where N is all digits
            if (name.size() >= 2 && name[0] == 'v') {
                bool allDigits = true;
                for (size_t i = 1; i < name.size(); ++i) {
                    if (!isdigit(static_cast<unsigned char>(name[i]))) {
                        allDigits = false;
                        break;
                    }
                }
                if (allDigits) return true;
            }
            return false;
        };

        // ---------- Run merge iterations ----------

        constexpr unsigned kMaxMergeIterations = 3;
        unsigned totalMerged = 0;

        for (unsigned iter = 0; iter < kMaxMergeIterations; ++iter) {
            auto infoMap = buildVarInfoMap(funcBody);

            // Build a list of candidate variable IDs (non-parameters, with refs).
            std::vector<uint32_t> candidates;
            for (auto& [id, info] : infoMap) {
                if (!info.decl)
                    continue;
                // Skip parameters.
                if (info.decl.getStorage() ==
                    helix::high::StorageKind::Parameter)
                    continue;
                // Skip variables with no references (dead — separate cleanup).
                if (info.refs.empty())
                    continue;
                candidates.push_back(id);
            }

            // Sort for deterministic iteration.
            std::sort(candidates.begin(), candidates.end());

            unsigned mergedThisIter = 0;
            std::vector<Operation*> erased;
            auto isErased = [&](Operation* op) {
                return std::find(erased.begin(), erased.end(), op) != erased.end();
            };

            for (size_t i = 0; i < candidates.size(); ++i) {
                auto idA = candidates[i];
                auto& infoA = infoMap[idA];
                if (!infoA.decl || isErased(infoA.decl.getOperation()))
                    continue;

                for (size_t j = i + 1; j < candidates.size(); ++j) {
                    auto idB = candidates[j];
                    auto& infoB = infoMap[idB];
                    if (!infoB.decl || isErased(infoB.decl.getOperation()))
                        continue;

                    // Don't merge if either touches a call block — the
                    // function call may clobber registers, making it unsafe
                    // to assume non-interference.
                    if (infoA.touchesCallBlock && infoB.touchesCallBlock)
                        continue;

                    // Types must be compatible.
                    if (!areTypesCompatible(infoA.decl, infoB.decl))
                        continue;

                    // Semantic usage must be compatible (refuse merging
                    // address-only with value-only).
                    if (!areSemanticsCompatible(idA, idB))
                        continue;

                    // Live ranges must not overlap.
                    if (rangesOverlap(infoA, infoB))
                        continue;

                    // Pick the canonical variable — prefer non-synthetic
                    // names. If both are synthetic or both are semantic,
                    // keep the one with the smaller ID (declared first).
                    bool aSynthetic = isSyntheticName(
                        infoA.decl.getVarName());
                    bool bSynthetic = isSyntheticName(
                        infoB.decl.getVarName());

                    // canonical = the one we keep; victim = the one we erase
                    uint32_t canonId, victimId;
                    if (aSynthetic && !bSynthetic) {
                        canonId = idB;
                        victimId = idA;
                    } else if (!aSynthetic && bSynthetic) {
                        canonId = idA;
                        victimId = idB;
                    } else {
                        // Both same kind — keep smaller ID.
                        canonId = idA;
                        victimId = idB;
                    }

                    auto& canonInfo = infoMap[canonId];
                    auto& victimInfo = infoMap[victimId];

                    LLVM_DEBUG(llvm::dbgs()
                        << "    Merging var '"
                        << victimInfo.decl.getVarName()
                        << "' (id=" << victimId
                        << ") into '"
                        << canonInfo.decl.getVarName()
                        << "' (id=" << canonId << ")\n");

                    // Rewrite all VarRefOps of the victim to point to canon.
                    auto canonName = canonInfo.decl.getVarName();
                    for (auto ref : victimInfo.refs) {
                        ref.setVarId(canonId);
                        ref.setVarName(canonName);
                    }

                    // Absorb victim's live blocks into canon.
                    for (auto* blk : victimInfo.liveBlocks)
                        canonInfo.liveBlocks.insert(blk);

                    // Move victim's refs to canon's list.
                    for (auto ref : victimInfo.refs)
                        canonInfo.refs.push_back(ref);

                    // Erase the victim declaration.
                    erased.push_back(victimInfo.decl.getOperation());
                    victimInfo.decl.erase();
                    victimInfo.decl = nullptr;

                    ++mergedThisIter;
                    ++NumVarsMerged;

                    // If A was the victim, stop trying to merge A.
                    if (victimId == idA)
                        break;
                }
            }

            totalMerged += mergedThisIter;
            LLVM_DEBUG(llvm::dbgs()
                << "    Iteration " << iter
                << ": merged " << mergedThisIter << " variables\n");

            // If no merges happened, further iterations are pointless.
            if (mergedThisIter == 0)
                break;
        }

        // ── Phase 5: Single-use temporary elimination ─────────────────────
        //
        // If a variable is:
        //   - Assigned exactly once
        //   - Referenced exactly once (beyond the assignment's target ref)
        //   - Both assignment and use are in the same block
        //   - The assigned value is not "too complex" (no nested calls)
        //
        // Then we inline the assigned value directly into the use site,
        // removing the variable, its declaration, the assignment, and the
        // target VarRefOp.

        LLVM_DEBUG(llvm::dbgs() << "  Phase 5: single-use temporary inlining\n");

        {
            // Rebuild info after merging.
            auto infoMap = buildVarInfoMap(funcBody);

            // For each variable, find its AssignOps (where it's the target).
            // An AssignOp has two operands: target (VarRefOp result) and value.
            // We identify assigns by looking at uses of VarRefOp results.

            struct TempCandidate {
                helix::high::VarDeclOp decl;
                helix::high::AssignOp assign;
                helix::high::VarRefOp assignTargetRef;
                helix::high::VarRefOp useRef;
            };

            llvm::SmallVector<TempCandidate, 8> tempCandidates;

            for (auto& [id, info] : infoMap) {
                if (!info.decl)
                    continue;
                // Only consider temporaries and registers (not params/stack).
                auto storage = info.decl.getStorage();
                if (storage == helix::high::StorageKind::Parameter)
                    continue;

                // Separate refs into "assign targets" and "value reads".
                llvm::SmallVector<helix::high::VarRefOp, 4> assignTargets;
                llvm::SmallVector<helix::high::VarRefOp, 4> valueReads;

                for (auto ref : info.refs) {
                    Value refResult = ref.getResult();
                    bool isAssignTarget = false;
                    for (auto& use : refResult.getUses()) {
                        if (auto assignOp = dyn_cast<helix::high::AssignOp>(
                                use.getOwner())) {
                            // Check if this ref is the target (operand 0).
                            if (use.getOperandNumber() == 0) {
                                isAssignTarget = true;
                                break;
                            }
                        }
                    }
                    if (isAssignTarget)
                        assignTargets.push_back(ref);
                    else
                        valueReads.push_back(ref);
                }

                // Must have exactly 1 assignment and exactly 1 read.
                if (assignTargets.size() != 1 || valueReads.size() != 1)
                    continue;

                auto targetRef = assignTargets[0];
                auto useRef = valueReads[0];

                // Both must be in the same block.
                if (targetRef->getBlock() != useRef->getBlock())
                    continue;

                // Find the AssignOp.
                helix::high::AssignOp theAssign;
                for (auto& use : targetRef.getResult().getUses()) {
                    if (auto aOp = dyn_cast<helix::high::AssignOp>(
                            use.getOwner())) {
                        if (use.getOperandNumber() == 0) {
                            theAssign = aOp;
                            break;
                        }
                    }
                }
                if (!theAssign)
                    continue;

                // The assigned value must not be defined by a call (too
                // complex to inline — may have side effects).
                Value assignedVal = theAssign.getValue();
                if (auto* defOp = assignedVal.getDefiningOp()) {
                    if (isa<helix::high::CallOp>(defOp) ||
                        helix::isAnyCallOp(defOp))
                        continue;
                }

                // The assignment must come before the use in block order.
                bool assignBeforeUse = false;
                for (auto it2 = Block::iterator(theAssign),
                     end = targetRef->getBlock()->end();
                     it2 != end; ++it2) {
                    if (&*it2 == useRef.getOperation()) {
                        assignBeforeUse = true;
                        break;
                    }
                }
                if (!assignBeforeUse)
                    continue;

                tempCandidates.push_back(
                    {info.decl, theAssign, targetRef, useRef});
            }

            // Apply inlining.
            for (auto& cand : tempCandidates) {
                Value assignedVal = cand.assign.getValue();

                LLVM_DEBUG(llvm::dbgs()
                    << "    Inlining single-use temp: '"
                    << cand.decl.getVarName() << "'\n");

                // Replace the use-site VarRefOp result with the assigned value.
                cand.useRef.getResult().replaceAllUsesWith(assignedVal);

                // Erase: use ref, assign op, target ref, declaration.
                cand.useRef.erase();
                cand.assign.erase();
                cand.assignTargetRef.erase();
                cand.decl.erase();

                ++NumTempsInlined;
            }
        }

        LLVM_DEBUG(llvm::dbgs()
            << "  Phase 3.5-5 summary: coalesced " << NumVersionsCoalesced
            << " SSA versions, merged " << totalMerged
            << " variables, inlined " << NumTempsInlined
            << " temporaries\n");

        return success();
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Factory (exposed via C-linkage helper to avoid MSVC C2888)
// ═══════════════════════════════════════════════════════════════════════════════

void* helix_createRecoverVariablesPass_impl() {
    return new RecoverVariablesPass();
}
