/// @file RecoverVariables.cpp
/// @brief MLIR pass: replaces register references with named variables.
///
/// This pass operates after stack layout recovery and control flow structuring.
/// It scans all remaining `helix_low.reg.read` and `helix_low.reg.write`
/// operations and replaces them with `helix_high.var.ref` / `helix_high.assign`
/// operations that reference named, typed variables.
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
///   - Register variables : lowercase of the canonical 64-bit name
///                          (rax, rbx, rcx, rdx, rsi, rdi, rsp, rbp, r8..r15)
///   - Stack variables    : `var_<hex_offset>` (e.g., `var_20` for [RBP-0x20])
///   - Temporaries        : `v<N>` with a monotonically increasing counter
///
/// ## References
///
///   - Rust implementation: crates/helix-core/src/analysis/data_flow.rs
///   - Hex-Rays naming conventions (de facto industry standard)

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/UB/IR/UBOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/Support/Debug.h"

#include <algorithm>
#include <cstdint>
#include <format>
#include <optional>
#include <string>
#include <string_view>

#define DEBUG_TYPE "recover-variables"

using namespace mlir;
using namespace helix;

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
STATISTIC(NumMultiDefVars,     "Number of separate vars for multi-write registers");
STATISTIC(NumUndefReplaced,    "Number of __undef references replaced with defaults");

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// Register Alias Tables
// ═══════════════════════════════════════════════════════════════════════════════

/// Describes the relationship between a sub-register and its canonical
/// 64-bit parent register.
struct SubRegInfo {
    /// The canonical 64-bit parent register name (e.g., "RAX").
    llvm::StringRef parent;

    /// Bit width of this sub-register (8, 16, 32, or 64).
    unsigned width;

    /// Bit offset within the parent register.
    /// AL = 0, AH = 8, AX = 0, EAX = 0.
    unsigned bitOffset;
};

/// Map a register name to its canonical 64-bit parent and sub-register info.
///
/// This covers the full x86-64 general-purpose register file:
///   RAX/EAX/AX/AL/AH, RBX/EBX/BX/BL/BH, RCX/ECX/CX/CL/CH,
///   RDX/EDX/DX/DL/DH, RSI/ESI/SI/SIL, RDI/EDI/DI/DIL,
///   RSP/ESP/SP/SPL, RBP/EBP/BP/BPL, R8-R15 and their sub-variants.
///
/// @param reg  The register name (case-insensitive matching uses uppercase).
/// @return     SubRegInfo describing the parent relationship, or std::nullopt
///             for unknown registers.
static std::optional<SubRegInfo> getSubRegInfo(llvm::StringRef reg) {
    // Normalize: the op attributes from RemillToHelixLow store names in
    // uppercase (RAX, EAX, etc.), so we match directly.
    //
    // Note: using StringSwitch for compile-time optimization of the lookup.
    // clang-format off
    auto result = llvm::StringSwitch<std::optional<SubRegInfo>>(reg)
        // ── RAX family ────────────────────────────────────────────────────
        .Case("RAX", SubRegInfo{"RAX", 64, 0})
        .Case("EAX", SubRegInfo{"RAX", 32, 0})
        .Case("AX",  SubRegInfo{"RAX", 16, 0})
        .Case("AL",  SubRegInfo{"RAX", 8,  0})
        .Case("AH",  SubRegInfo{"RAX", 8,  8})
        // ── RBX family ────────────────────────────────────────────────────
        .Case("RBX", SubRegInfo{"RBX", 64, 0})
        .Case("EBX", SubRegInfo{"RBX", 32, 0})
        .Case("BX",  SubRegInfo{"RBX", 16, 0})
        .Case("BL",  SubRegInfo{"RBX", 8,  0})
        .Case("BH",  SubRegInfo{"RBX", 8,  8})
        // ── RCX family ────────────────────────────────────────────────────
        .Case("RCX", SubRegInfo{"RCX", 64, 0})
        .Case("ECX", SubRegInfo{"RCX", 32, 0})
        .Case("CX",  SubRegInfo{"RCX", 16, 0})
        .Case("CL",  SubRegInfo{"RCX", 8,  0})
        .Case("CH",  SubRegInfo{"RCX", 8,  8})
        // ── RDX family ────────────────────────────────────────────────────
        .Case("RDX", SubRegInfo{"RDX", 64, 0})
        .Case("EDX", SubRegInfo{"RDX", 32, 0})
        .Case("DX",  SubRegInfo{"RDX", 16, 0})
        .Case("DL",  SubRegInfo{"RDX", 8,  0})
        .Case("DH",  SubRegInfo{"RDX", 8,  8})
        // ── RSI family ────────────────────────────────────────────────────
        .Case("RSI", SubRegInfo{"RSI", 64, 0})
        .Case("ESI", SubRegInfo{"RSI", 32, 0})
        .Case("SI",  SubRegInfo{"RSI", 16, 0})
        .Case("SIL", SubRegInfo{"RSI", 8,  0})
        // ── RDI family ────────────────────────────────────────────────────
        .Case("RDI", SubRegInfo{"RDI", 64, 0})
        .Case("EDI", SubRegInfo{"RDI", 32, 0})
        .Case("DI",  SubRegInfo{"RDI", 16, 0})
        .Case("DIL", SubRegInfo{"RDI", 8,  0})
        // ── RSP family ────────────────────────────────────────────────────
        .Case("RSP", SubRegInfo{"RSP", 64, 0})
        .Case("ESP", SubRegInfo{"RSP", 32, 0})
        .Case("SP",  SubRegInfo{"RSP", 16, 0})
        .Case("SPL", SubRegInfo{"RSP", 8,  0})
        // ── RBP family ────────────────────────────────────────────────────
        .Case("RBP", SubRegInfo{"RBP", 64, 0})
        .Case("EBP", SubRegInfo{"RBP", 32, 0})
        .Case("BP",  SubRegInfo{"RBP", 16, 0})
        .Case("BPL", SubRegInfo{"RBP", 8,  0})
        // ── R8-R15 families ───────────────────────────────────────────────
        .Case("R8",   SubRegInfo{"R8",  64, 0})
        .Case("R8D",  SubRegInfo{"R8",  32, 0})
        .Case("R8W",  SubRegInfo{"R8",  16, 0})
        .Case("R8B",  SubRegInfo{"R8",  8,  0})
        .Case("R9",   SubRegInfo{"R9",  64, 0})
        .Case("R9D",  SubRegInfo{"R9",  32, 0})
        .Case("R9W",  SubRegInfo{"R9",  16, 0})
        .Case("R9B",  SubRegInfo{"R9",  8,  0})
        .Case("R10",  SubRegInfo{"R10", 64, 0})
        .Case("R10D", SubRegInfo{"R10", 32, 0})
        .Case("R10W", SubRegInfo{"R10", 16, 0})
        .Case("R10B", SubRegInfo{"R10", 8,  0})
        .Case("R11",  SubRegInfo{"R11", 64, 0})
        .Case("R11D", SubRegInfo{"R11", 32, 0})
        .Case("R11W", SubRegInfo{"R11", 16, 0})
        .Case("R11B", SubRegInfo{"R11", 8,  0})
        .Case("R12",  SubRegInfo{"R12", 64, 0})
        .Case("R12D", SubRegInfo{"R12", 32, 0})
        .Case("R12W", SubRegInfo{"R12", 16, 0})
        .Case("R12B", SubRegInfo{"R12", 8,  0})
        .Case("R13",  SubRegInfo{"R13", 64, 0})
        .Case("R13D", SubRegInfo{"R13", 32, 0})
        .Case("R13W", SubRegInfo{"R13", 16, 0})
        .Case("R13B", SubRegInfo{"R13", 8,  0})
        .Case("R14",  SubRegInfo{"R14", 64, 0})
        .Case("R14D", SubRegInfo{"R14", 32, 0})
        .Case("R14W", SubRegInfo{"R14", 16, 0})
        .Case("R14B", SubRegInfo{"R14", 8,  0})
        .Case("R15",  SubRegInfo{"R15", 64, 0})
        .Case("R15D", SubRegInfo{"R15", 32, 0})
        .Case("R15W", SubRegInfo{"R15", 16, 0})
        .Case("R15B", SubRegInfo{"R15", 8,  0})
        // ── XMM registers (128-bit SIMD) ─────────────────────────────────
        // Modeled as 64-bit to match our i64 RegWriteOp value type.
        .Case("XMM0",  SubRegInfo{"XMM0",  64, 0})
        .Case("XMM1",  SubRegInfo{"XMM1",  64, 0})
        .Case("XMM2",  SubRegInfo{"XMM2",  64, 0})
        .Case("XMM3",  SubRegInfo{"XMM3",  64, 0})
        .Case("XMM4",  SubRegInfo{"XMM4",  64, 0})
        .Case("XMM5",  SubRegInfo{"XMM5",  64, 0})
        .Case("XMM6",  SubRegInfo{"XMM6",  64, 0})
        .Case("XMM7",  SubRegInfo{"XMM7",  64, 0})
        .Case("XMM8",  SubRegInfo{"XMM8",  64, 0})
        .Case("XMM9",  SubRegInfo{"XMM9",  64, 0})
        .Case("XMM10", SubRegInfo{"XMM10", 64, 0})
        .Case("XMM11", SubRegInfo{"XMM11", 64, 0})
        .Case("XMM12", SubRegInfo{"XMM12", 64, 0})
        .Case("XMM13", SubRegInfo{"XMM13", 64, 0})
        .Case("XMM14", SubRegInfo{"XMM14", 64, 0})
        .Case("XMM15", SubRegInfo{"XMM15", 64, 0})
        .Default(std::nullopt);
    // clang-format on

    return result;
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

    /// Tracks how many times each canonical register has been written to
    /// across distinct execution paths (basic blocks). Used to create
    /// separate variables for multiple definitions of the same register.
    llvm::StringMap<unsigned> regWriteCount;

    /// Maps (canonical register, block pointer) to the var.decl for that
    /// specific definition. Enables separate variables per write site.
    llvm::DenseMap<std::pair<llvm::StringRef, Block*>, Operation*> regBlockDecl;

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
            if (isa<helix::low::CallOp, helix::low::JmpOp,
                    helix::low::JccOp>(&*it))
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
            std::string name = std::format("param_{}", argIt->second);
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
        std::string varName = std::format("var_{:x}", absOffset);

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
        std::string varName = std::format("v{}", tempCounter++);

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

        // ── Initialize calling convention info ───────────────────────────
        // The RecoverCallingConventionPass sets "calling_convention" and
        // "has_return_value" attributes on the function.
        bool isWin64 = true;
        if (auto ccAttr = func->getAttrOfType<StringAttr>("calling_convention")) {
            isWin64 = (ccAttr.getValue() == "win64");
        }
        tracker.initArgRegPositions(isWin64);
        tracker.hasReturnValue =
            func->hasAttr("has_return_value");

        // Position the builder at the entry block's start for variable
        // declarations.  All var.decl ops go at the top of the function
        // (like local variable declarations in C).
        Block& entryBlock = funcBody.front();
        OpBuilder declBuilder(func->getContext());
        declBuilder.setInsertionPointToStart(&entryBlock);

        auto funcLoc = func.getLoc();

        LLVM_DEBUG(llvm::dbgs() << "RecoverVariables: processing '"
                                << func.getSymName() << "' (cc="
                                << (isWin64 ? "win64" : "sysv")
                                << ", hasReturn="
                                << tracker.hasReturnValue << ")\n");

        // ── Pre-scan: count writes per register per block ────────────────
        // This enables creating separate variables when the same register
        // is written in multiple distinct execution paths (basic blocks).
        llvm::StringMap<llvm::SmallDenseSet<Block*, 4>> regWriteBlocks;
        funcBody.walk([&](helix::low::RegWriteOp writeOp) {
            auto regName = writeOp.getRegName();
            auto subRegOpt = getSubRegInfo(regName);
            if (subRegOpt) {
                regWriteBlocks[subRegOpt->parent].insert(
                    writeOp->getBlock());
            }
        });

        // ── Phase 1: Replace RegRead operations ──────────────────────────

        // Collect all RegRead ops first (walk + erase pattern).
        llvm::SmallVector<helix::low::RegReadOp, 16> regReads;
        funcBody.walk([&](helix::low::RegReadOp readOp) {
            regReads.push_back(readOp);
        });

        for (auto readOp : regReads) {
            auto regName = readOp.getRegName();

            // Resolve sub-register alias.
            auto subRegOpt = getSubRegInfo(regName);
            if (!subRegOpt) {
                // Unknown register — emit as a temporary variable.
                LLVM_DEBUG(llvm::dbgs() << "  Unknown register: "
                                        << regName << " -> temp\n");
                builder.setInsertionPoint(readOp);
                auto* tempDecl = tracker.declareTemp(
                    readOp.getResult().getType(), declBuilder, funcLoc);
                auto tempTyped = llvm::cast<helix::high::VarDeclOp>(tempDecl);
                auto varRef = builder.create<helix::high::VarRefOp>(
                    readOp.getLoc(),
                    readOp.getResult().getType(),
                    tempTyped.getVarId(),
                    tempTyped.getVarName(),
                    mlir::IntegerAttr{});
                readOp.getResult().replaceAllUsesWith(varRef.getResult());
                readOp.erase();
                ++NumReadsReplaced;
                continue;
            }

            auto& subReg = *subRegOpt;

            // Ensure the canonical variable is declared.
            // Pass the readOp as context for return-context detection.
            auto* varDecl = tracker.getOrDeclareRegVar(
                subReg.parent, declBuilder, funcLoc, readOp);

            builder.setInsertionPoint(readOp);

            // Read the full-width variable.
            auto i64Ty = builder.getIntegerType(64);
            auto varDeclTyped = llvm::cast<helix::high::VarDeclOp>(varDecl);

            // Track param naming statistics.
            if (tracker.argRegPositions.count(subReg.parent))
                ++NumParamsNamed;
            if (subReg.parent == "RAX" && tracker.hasReturnValue &&
                VariableTracker::isReturnContext(readOp, subReg.parent))
                ++NumReturnVarsNamed;
            auto varRef = builder.create<helix::high::VarRefOp>(
                readOp.getLoc(),
                i64Ty,
                varDeclTyped.getVarId(),
                varDeclTyped.getVarName(),
                mlir::IntegerAttr{});

            Value result;
            if (subReg.width == 64 && subReg.bitOffset == 0) {
                // Full-width read — no cast needed.
                result = varRef.getResult();
            } else if (subReg.bitOffset == 0) {
                // Low sub-register read — simple truncation.
                result = emitTruncation(varRef.getResult(), subReg.width,
                                        builder, readOp.getLoc());
                ++NumAliasesResolved;
            } else {
                // High-byte read (AH, BH, CH, DH) — shift + truncate.
                result = emitHighByteExtract(varRef.getResult(),
                                             subReg.bitOffset, subReg.width,
                                             builder, readOp.getLoc());
                ++NumAliasesResolved;
            }

            readOp.getResult().replaceAllUsesWith(result);
            readOp.erase();
            ++NumReadsReplaced;
        }

        // ── Phase 2: Replace RegWrite operations ─────────────────────────

        llvm::SmallVector<helix::low::RegWriteOp, 16> regWrites;
        funcBody.walk([&](helix::low::RegWriteOp writeOp) {
            regWrites.push_back(writeOp);
        });

        for (auto writeOp : regWrites) {
            auto regName = writeOp.getRegName();

            // Resolve sub-register alias.
            auto subRegOpt = getSubRegInfo(regName);
            if (!subRegOpt) {
                // Unknown register — emit as temporary assignment.
                LLVM_DEBUG(llvm::dbgs() << "  Unknown register write: "
                                        << regName << " -> temp assign\n");
                builder.setInsertionPoint(writeOp);
                auto* tempDecl = tracker.declareTemp(
                    writeOp.getValue().getType(), declBuilder, funcLoc);
                auto tempTyped2 = llvm::cast<helix::high::VarDeclOp>(tempDecl);
                auto tempRef = builder.create<helix::high::VarRefOp>(
                    writeOp.getLoc(),
                    writeOp.getValue().getType(),
                    tempTyped2.getVarId(),
                    tempTyped2.getVarName(),
                    mlir::IntegerAttr{});
                builder.create<helix::high::AssignOp>(
                    writeOp.getLoc(),
                    tempRef.getResult(),
                    writeOp.getValue(),
                    mlir::IntegerAttr{});
                writeOp.erase();
                ++NumWritesReplaced;
                continue;
            }

            auto& subReg = *subRegOpt;

            // ── Multiple-write detection ─────────────────────────────────
            // If this register is written in multiple distinct blocks, create
            // a separate variable for each write site (Requirement 8.3).
            auto writeBlocksIt = regWriteBlocks.find(subReg.parent);
            bool hasMultipleWriteBlocks =
                writeBlocksIt != regWriteBlocks.end() &&
                writeBlocksIt->second.size() > 1;

            Operation* varDecl;
            if (hasMultipleWriteBlocks &&
                !tracker.argRegPositions.count(subReg.parent)) {
                // Check if we already have a declaration for this
                // register+block combination.
                auto blockKey = std::make_pair(
                    llvm::StringRef(subReg.parent), writeOp->getBlock());
                auto blockIt = tracker.regBlockDecl.find(blockKey);
                if (blockIt != tracker.regBlockDecl.end()) {
                    varDecl = blockIt->second;
                } else {
                    // Create a new variable with a unique suffix.
                    unsigned writeIdx = tracker.regWriteCount[subReg.parent]++;
                    std::string baseName = regToVarName(subReg.parent);
                    std::string varName;
                    if (writeIdx == 0) {
                        varName = baseName;
                    } else {
                        // Append a letter suffix: _a, _b, _c, ...
                        char suffix = 'a' + static_cast<char>(
                            writeIdx < 26 ? writeIdx : 25);
                        varName = std::format("{}_{}", baseName, suffix);
                    }

                    auto declOp = declBuilder.create<helix::high::VarDeclOp>(
                        funcLoc,
                        /*var_id=*/tracker.varIdCounter++,
                        /*var_name=*/varName,
                        /*storage=*/helix::high::StorageKind::Register,
                        /*stack_offset=*/IntegerAttr{},
                        /*init=*/Value{},
                        /*address=*/IntegerAttr{});

                    varDecl = declOp;
                    tracker.regBlockDecl[blockKey] = declOp;
                    // Also register in regToDecl if first write.
                    if (writeIdx == 0)
                        tracker.regToDecl[subReg.parent] = declOp;
                    ++NumRegVarsCreated;
                    ++NumMultiDefVars;

                    LLVM_DEBUG(llvm::dbgs()
                        << "  Multi-def variable: " << varName
                        << " (from " << subReg.parent
                        << ", block " << writeOp->getBlock() << ")\n");
                }
            } else {
                // Single write path or argument register — use standard naming.
                varDecl = tracker.getOrDeclareRegVar(
                    subReg.parent, declBuilder, funcLoc, writeOp);
            }

            builder.setInsertionPoint(writeOp);

            Value valueToStore;
            if (subReg.width == 64 && subReg.bitOffset == 0) {
                // Full-width write — direct assignment.
                valueToStore = writeOp.getValue();
            } else {
                // Sub-register write — read-modify-write pattern.
                auto i64Ty = builder.getIntegerType(64);
                auto varDeclTyped2 = llvm::cast<helix::high::VarDeclOp>(varDecl);
                auto currentVar = builder.create<helix::high::VarRefOp>(
                    writeOp.getLoc(),
                    i64Ty,
                    varDeclTyped2.getVarId(),
                    varDeclTyped2.getVarName(),
                    mlir::IntegerAttr{});

                valueToStore = emitSubRegInsert(
                    currentVar.getResult(), writeOp.getValue(),
                    subReg, builder, writeOp.getLoc());
                ++NumAliasesResolved;
            }

            // Emit the assignment to the canonical variable.
            auto varDeclTyped3 = llvm::cast<helix::high::VarDeclOp>(varDecl);
            auto targetRef = builder.create<helix::high::VarRefOp>(
                writeOp.getLoc(),
                valueToStore.getType(),
                varDeclTyped3.getVarId(),
                varDeclTyped3.getVarName(),
                mlir::IntegerAttr{});
            builder.create<helix::high::AssignOp>(
                writeOp.getLoc(),
                targetRef.getResult(),
                valueToStore,
                mlir::IntegerAttr{});

            writeOp.erase();
            ++NumWritesReplaced;
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
                if (isa<helix::low::CallOp>(user)) {
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
                         << tracker.regToDecl.size() << " register vars, "
                         << tracker.stackOffsetToDecl.size() << " stack vars, "
                         << tracker.tempCounter << " temps\n";
        });

        return success();
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Factory
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createRecoverVariablesPass() {
    return std::make_unique<RecoverVariablesPass>();
}
