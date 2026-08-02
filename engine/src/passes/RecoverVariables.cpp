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

/// Stable storage for AArch64 X-register names ("X0".."X30") so SubRegInfo
/// can hold a StringRef parent that outlives the call (mirrors how the x86
/// table uses string literals).
static llvm::StringRef aarch64XRegName(unsigned n) {
    static const std::array<std::string, 31> kNames = [] {
        std::array<std::string, 31> a;
        for (unsigned i = 0; i < 31; ++i)
            a[i] = "X" + std::to_string(i);
        return a;
    }();
    return kNames[n];
}

/// AArch64 GPR sub-register info: Xn is the 64-bit register, Wn its low
/// 32-bit view (parent Xn).  Returns nullopt for names that are not AArch64
/// GPRs so x86 resolution is reached unchanged.
///
/// Deliberately does NOT match "SP": (1) AArch64 SP is intentionally left on
/// the non-register path (see aarch64GprName in RemillToHelixLow), and (2)
/// "SP" is ALSO a valid x86 register name (16-bit stack pointer), so matching
/// it here would corrupt x86 sub-register resolution.
static std::optional<SubRegInfo> getAArch64SubRegInfo(llvm::StringRef reg) {
    auto upper = reg.upper();
    if (upper.size() >= 2 && (upper[0] == 'X' || upper[0] == 'W')) {
        unsigned n;
        if (!llvm::StringRef(upper).drop_front().getAsInteger(10, n) && n <= 30) {
            unsigned width = (upper[0] == 'W') ? 32 : 64;
            return SubRegInfo{aarch64XRegName(n), width, 0};
        }
    }
    return std::nullopt;
}

static std::optional<SubRegInfo> getSubRegInfo(llvm::StringRef reg) {
    if (auto a64 = getAArch64SubRegInfo(reg))
        return a64;
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

/// FIX (Maya R. review, Phase 3.5/4 usage-classifier gap): returns true if
/// `addOp` is the address-forming `llvm.add(base, const)` shape that
/// HelixLowToMid's `tryDecomposeAddrAsField` (HelixLowToMid.cpp ~L202) will
/// later lift into a `mid.field.ptr`. Mirrors that function's own
/// const/zero-offset checks so the two stay in lockstep, then additionally
/// confirms the add's RESULT actually feeds a MemRead/MemWrite address
/// operand -- narrowing to the specific shape that becomes an address, not
/// every add with one constant operand.
///
/// RecoverVariables' Phase 3.5/4 usage classifier runs BEFORE HelixLowToMid
/// (Pipeline.cpp: RecoverVariables ~L512, HelixLowToMid ~L525), so at
/// classification time the address is still this raw LLVM::AddOp -- neither
/// `mid::FieldPtrOp` nor `high::FieldAccessOp` exist yet in the IR. A
/// classifier branch checking for either op (as originally proposed) is
/// dead code at this pipeline stage; this helper checks the actual shape
/// present here instead.
static bool isAddressFormingAdd(LLVM::AddOp addOp) {
    if (!addOp) return false;
    auto lhs = addOp.getLhs();
    auto rhs = addOp.getRhs();
    if (!lhs || !rhs) return false;

    auto extractConst = [](Value v) -> std::optional<uint64_t> {
        auto cst = v.getDefiningOp<LLVM::ConstantOp>();
        if (!cst) return std::nullopt;
        auto intAttr = dyn_cast<IntegerAttr>(cst.getValue());
        if (!intAttr) return std::nullopt;
        return intAttr.getValue().getZExtValue();
    };

    auto lhsConst = extractConst(lhs);
    auto rhsConst = extractConst(rhs);
    if (lhsConst && rhsConst) return false;   // fully-foldable, no provenance
    if (!lhsConst && !rhsConst) return false; // neither side is a constant offset
    if (rhsConst && *rhsConst == 0) return false;
    if (lhsConst && *lhsConst == 0) return false;

    for (auto& use : addOp.getResult().getUses()) {
        Operation* user = use.getOwner();
        unsigned idx = use.getOperandNumber();
        if (isa<helix::low::MemReadOp>(user) && idx == 0) return true;
        if (isa<helix::low::MemWriteOp>(user) && idx == 0) return true;
    }
    return false;
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

    /// Whether the current function uses the AArch64 AAPCS64 ABI.  Gates
    /// AArch64-specific X0 argument/return-register handling.
    bool isAapcs64 = false;

    /// A fixed debug signature gives the source parameters stable identities.
    /// Later writes to their physical ABI registers are scratch/local values,
    /// not mutations of the source parameter.
    bool preserveExactParameterIdentity = false;

    /// Keep the implicit return-register definition as an exact, separate
    /// `result` variable. On x86 this is restricted to call-free functions:
    /// unknown calls conservatively materialize RAX and complex call-heavy
    /// functions rely on the established coalescing policy. AAPCS64 keeps
    /// the pre-existing exact-X0 behavior.
    bool preserveExactReturnIdentity = false;

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

    /// AArch64 AAPCS64 integer argument registers: X0..X7 -> positions 1..8.
    void initArgRegPositionsAapcs64() {
        argRegPositions.clear();
        for (unsigned i = 0; i < 8; ++i)
            argRegPositions["X" + std::to_string(i)] = i + 1;
    }

    /// x86-32 register-argument positions (FIX-CC-THISCALL).  cdecl/stdcall pass
    /// all integer args on the stack, but __thiscall passes `this` in ECX(=RCX)
    /// and __fastcall passes the first two args in ECX,EDX(=RCX,RDX).  We map
    /// both; SSA versioning gates naturally — a pure-cdecl function that WRITES
    /// ECX before reading it (scratch / `push ecx` local slot) leaves param_1
    /// (version 0) unused, so it is DCE'd and never reaches the signature.  Only
    /// a genuine read-before-write of ECX/EDX (the thiscall/fastcall live-in)
    /// keeps the param — matching RecoverCallingConvention's Phase-1 liveness.
    void initArgRegPositionsCdecl32() {
        argRegPositions.clear();
        argRegPositions["RCX"] = 1;   // __thiscall `this` only; EDX/fastcall over-binds (deferred)
    }

    /// Same-block forward scan used by isReturnContext, factored out so it
    /// can be re-entered on the target block of an unconditional jmp chain
    /// (see isReturnContext's comment for why that's needed).
    ///
    /// @param visited  Blocks already scanned in this query -- guards
    ///                 against infinite recursion on a jmp cycle (which
    ///                 shouldn't occur in practice for a jmp chain that's
    ///                 actually converging on a return, but a malformed or
    ///                 adversarial CFG must not hang the pass).
    static bool isReturnContextScan(Block* block, Block::iterator it,
                                    llvm::StringRef regName,
                                    llvm::SmallPtrSetImpl<Block*>& visited) {
        if (!visited.insert(block).second)
            return false;

        for (auto end = block->end(); it != end; ++it) {
            // If we hit a return, this is a return context.
            if (isa<helix::low::RetOp>(&*it))
                return true;

            // If another write to the same register intervenes, stop.
            if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&*it)) {
                if (regWrite.getRegName() == regName)
                    return false;
            }

            if (helix::isAnyCallOp(&*it))
                return false;

            // FIX (return-context-through-jmp-chain): an unconditional jmp
            // to another block does NOT by itself disqualify return
            // context -- follow it and keep scanning there. This is the
            // common shape for an early-return guard clause: the compiler
            // merges multiple `return` sites into one shared exit block,
            // so the register write that logically IS `return 1` sits in
            // a predecessor block that reaches the real helix_low.ret only
            // via an intervening jmp. Before this fix, hitting that jmp
            // unconditionally returned false, so none of the predecessor
            // writes were ever recognized as return context -- the write
            // got named as a plain register variable, EliminateDeadCode
            // then correctly-per-its-own-logic removed it as unread (since
            // the operand-less helix_low.ret doesn't reference it either),
            // and CAstBuilder's return-statement construction fell back to
            // an unbound placeholder ("int64_t result;" declared but never
            // assigned). A conditional branch (JccOp) is intentionally NOT
            // followed here -- that's a genuine fork where the write may
            // or may not reach a return depending on which edge is taken,
            // a materially different and harder question this narrow fix
            // doesn't attempt to answer.
            if (auto jmp = dyn_cast<helix::low::JmpOp>(&*it)) {
                Block* dest = jmp.getDest();
                if (!dest)
                    return false;
                return isReturnContextScan(dest, dest->begin(), regName,
                                           visited);
            }

            if (isa<helix::low::JccOp>(&*it))
                return false;
        }

        return false;
    }

    /// Check if an operation is in a return context — i.e., the register
    /// value flows into a helix_low.ret or helix_high.return operation.
    ///
    /// Scans forward from the given operation, following unconditional
    /// jmp chains into their target blocks, to find if a RetOp follows
    /// without an intervening write to the same register or a conditional
    /// branch (see isReturnContextScan for why Jcc stops the scan but Jmp
    /// doesn't).
    ///
    /// @param op       The operation to check (typically a reg.write to RAX).
    /// @param regName  The register being written (checked for intervening writes).
    /// @return         true if this write feeds a return.
    static bool isReturnContext(Operation* op, llvm::StringRef regName) {
        auto* block = op->getBlock();
        if (!block)
            return false;
        auto it = Block::iterator(op);
        ++it; // skip the current op
        llvm::SmallPtrSet<Block*, 8> visited;
        return isReturnContextScan(block, it, regName, visited);
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
    /// True if `reg` is the integer return register for the active ABI:
    /// RAX on x86, X0 on AArch64 AAPCS64.
    static bool isIntegerReturnRegister(llvm::StringRef reg) {
        return reg == "RAX" || reg == "X0";
    }

    std::pair<std::string, helix::high::StorageKind>
    getSemanticName(llvm::StringRef canonicalReg, Operation* contextOp) {
        // Return context takes priority over the argument-register name.
        // This matters on AArch64 AAPCS64, where X0 is BOTH the first
        // argument register AND the integer return register: a write to X0
        // in return context is the return value ("result"), not param_1.
        // (On x86 RAX is never an argument register, so order is moot there.)
        if (isIntegerReturnRegister(canonicalReg) && hasReturnValue && contextOp &&
            isReturnContext(contextOp, canonicalReg)) {
            return {"result", helix::high::StorageKind::Register};
        }

        // Check if this is an argument register.
        auto argIt = argRegPositions.find(canonicalReg);
        if (argIt != argRegPositions.end()) {
            std::string name = llvm::formatv("param_{0}", argIt->second);
            return {name, helix::high::StorageKind::Parameter};
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
        // For the integer return register (RAX / X0), check return context to
        // decide between "result" and the plain register name.  We use a
        // separate key for the return-context variant.
        bool isRetCtx = (isIntegerReturnRegister(canonicalReg) && hasReturnValue &&
                         contextOp && isReturnContext(contextOp, canonicalReg));
        llvm::StringRef lookupKey = isRetCtx ? "__ret_result" : canonicalReg;

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

        if (ver > 0 &&
            storage == helix::high::StorageKind::Parameter &&
            tracker.preserveExactParameterIdentity) {
            baseName = regToVarName(canonReg);
            storage = helix::high::StorageKind::Register;
        }

        std::string varName;
        // Selected return-context writes must be named exactly "result"
        // (without an SSA suffix). DCE and CAstBuilder model the implicit
        // consumer of the return register through this semantic name; the
        // tracker flag keeps the x86 policy narrow for call-heavy functions.
        if (ver == 0 ||
            (tracker.preserveExactReturnIdentity &&
             baseName == "result")) {
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
        bool isAapcs64 = false;
        if (auto ccAttr = func->getAttrOfType<StringAttr>("calling_convention")) {
            auto ccVal = ccAttr.getValue();
            isWin64   = (ccVal == "win64");
            isCdecl32 = (ccVal == "cdecl");
            isAapcs64 = (ccVal == "aapcs64");
        }
        tracker.isAapcs64 = isAapcs64;
        if (isCdecl32) {
            // FIX-CC-THISCALL round 2: only bind ECX as `this` (param_1) when
            // RecoverCallingConvention's flows-to-deref gate approved it and set
            // the "x86_thiscall_this" marker.  A pure-cdecl function whose ECX is
            // merely scratch leaves argRegPositions EMPTY, so it gets NO phantom
            // param_1 — stack args are recovered by RecoverStackLayout instead.
            // (This kills the 0x83d050-class regression where a live-in-but-
            // scratch ECX was mis-named param_1 and collapsed a real compare.)
            if (func->hasAttr("x86_thiscall_this"))
                tracker.initArgRegPositionsCdecl32();
        } else if (isAapcs64) {
            tracker.initArgRegPositionsAapcs64();
        } else {
            tracker.initArgRegPositions(isWin64);
        }
        // FIX-CC-SRET / FIX-139: intersect the ABI register map with the
        // positions RecoverCallingConvention certified. On x86-64 this drops
        // hidden/scratch register copies; on AAPCS64 the attribute is emitted
        // only for an exact debug signature, so legacy/no-debug behavior stays
        // byte-identical while extra live-in scratch registers become locals.
        if (!isCdecl32) {
            if (auto idxAttr = func->getAttrOfType<DenseI32ArrayAttr>(
                    "reg_param_indices")) {
                auto certified = idxAttr.asArrayRef();
                llvm::SmallVector<std::string, 8> toDrop;
                for (auto& kv : tracker.argRegPositions) {
                    bool keep = false;
                    for (int32_t idx : certified)
                        if (static_cast<unsigned>(idx) == kv.second) {
                            keep = true;
                            break;
                        }
                    if (!keep)
                        toDrop.push_back(kv.first().str());
                }
                for (auto& reg : toDrop)
                    tracker.argRegPositions.erase(reg);
            }
        }
        // Win64 entry points: incoming RCX/RDX/R8/R9 are OS-set values, not
        // named parameters.  RecoverCallingConvention sets "no_reg_params" to
        // suppress param_N naming for these functions.
        if (func->hasAttr("no_reg_params")) {
            tracker.argRegPositions.clear();
        }
        tracker.hasReturnValue =
            func->hasAttr("has_return_value");
        tracker.preserveExactParameterIdentity =
            func->hasAttr("helix.debug_param_count");
        bool hasProgramCalls = false;
        funcBody.walk([&](Operation* op) {
            if (!helix::isAnyCallOp(op))
                return;

            // CQO_RAX is a Remill machine helper for the x86 CQO
            // instruction, not a source-level call. Treating it as a call
            // disabled exact return recovery in arithmetic leaf functions
            // such as signed division and opaque-predicate helpers.
            auto targetName = helix::getCallTargetName(op);
            if (targetName && *targetName == "CQO_RAX")
                return;

            hasProgramCalls = true;
        });
        tracker.preserveExactReturnIdentity =
            tracker.isAapcs64 || !hasProgramCalls;

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
                // FIX-095b: RPO over funcBody's OWN region only. A top-level block's
                // terminator can carry a successor edge that crosses INTO a nested
                // structured region (do_while/while) after StructureControlFlow; if
                // the DFS follows it, a foreign-region block lands in blockOrder and
                // the per-block loop both null-derefs domInfoPtr->getNode (foreign
                // region has no dom tree) AND steals in-region ops that Phase-2.5 is
                // meant to bind. Stay in-region; the Phase-2.5 sweep handles nested
                // ops. No-op for region-free CFGs (byte-identical).
                std::function<void(Block*)> postOrderDFS =
                    [&](Block* blk) {
                        if (!visited.insert(blk).second) return;
                        for (Block* succ : blk->getSuccessors())
                            if (succ->getParent() == &funcBody)
                                postOrderDFS(succ);
                        postOrder.push_back(blk);
                    };
                postOrderDFS(&funcBody.front());
                // Reverse post-order = reverse of post-order
                for (auto it = postOrder.rbegin(); it != postOrder.rend();
                     ++it)
                    blockOrder.push_back(*it);
                // Safety net: append any funcBody top-level block the same-region
                // DFS did not reach, so its top-level reg ops are still processed.
                for (auto& blk : funcBody)
                    if (!visited.count(&blk))
                        blockOrder.push_back(&blk);

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
            if (useRPO && &block != &funcBody.front()
                && block.getParent() == &funcBody) {
                // Restore from immediate dominator's exit state.
                // FIX-095b guard: domInfoPtr = DominanceInfo(func) only has a tree
                // for funcBody's own region; never call getNode on a block from a
                // nested structured region (would null-deref).
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

            // ── Snapshot block exit state ──────────────────────────
            // In RPO this seeds the idom restore (above). FIX-113 (mini-engine
            // #1): ALSO populate it in the region-order fallback. The v2 SCF
            // structurer (transformCFGToSCF, default) collapses funcBody to a
            // SINGLE top-level block (the real code nests in scf regions), so
            // useRPO's `>1 block` gate fails and this used to stay empty -- which
            // disabled the Phase-2.5 sweep below (its `!blockExitState.empty()`
            // guard), so every reg.read nested in an scf region fell through to a
            // hash-slot `vN = 0` and was deref'd as null. Snapshotting the single
            // top-level block's exit (where the pre-region pointer-setup writes
            // are already versioned) lets Phase-2.5 bind those nested reads to the
            // real reaching version. Harmless in RPO mode (same value); only adds
            // entries in the fallback the sweep then consumes.
            blockExitState[blockPtr] = ssaTracker.snapshot();
        }

        // ── Phase 2.5: Sweep reg ops surviving inside structured regions ──
        //
        // The per-block loop above only iterates top-level block ops; it
        // never enters the regions of helix_high.if / do_while / while /
        // for / switch that StructureControlFlow (pass 8, runs before this
        // pass 9) wrapped around loop bodies and conditional branches. Any
        // helix_low.reg.read / reg.write that ended up inside those regions
        // therefore survives this pass entirely and gets picked up by the
        // HelixLowToMid `RegReadToVarRef` fallback, which produces hash-
        // based slot_ids the HelixMidToHigh naming map can't resolve. The
        // C output then shows `v0 = 0; ...; v2 = *v0;` where the deref
        // should have been `*param_3_1` (or whatever the parent register
        // was bound to at the region's entry).
        //
        // Strategy B (post-loop sweep): walk the full function region —
        // including nested helix_high regions — and bind each surviving
        // reg.read/reg.write to the SSA version visible at the exit of the
        // containing top-level block. The walk is keyed structurally
        // (op → ancestor in funcBody) and the snapshot lookup is keyed by
        // Block* address, but the resulting name choice is fully
        // determined by `findTopLevelAncestor` (a fixed-shape walk) and
        // `blockExitState[topBlock]` (a single keyed lookup), so the
        // assignment is deterministic regardless of `funcBody.walk`
        // iteration order.
        //
        // Loop-carried versioning is deliberately approximated: every
        // in-region access of a given register binds to the same version
        // (the one visible at the containing top-level block's exit).
        // That loses per-iteration disambiguation but is a strict
        // improvement over `v0 = 0` placeholders and matches what a
        // reverse-engineer expects to see when reading the C output.
        // Strategy A (proper region-aware SSA tracking with snapshot/
        // restore at every region boundary) would recover per-iteration
        // versions but is left as a follow-up.
        if (std::getenv("HELIX_DEFREC_TRACE"))
            llvm::errs() << "[STRATB] blockExitState.size()="
                         << blockExitState.size() << "\n";
        if (!blockExitState.empty()) {
            const bool stratBTrace =
                std::getenv("HELIX_DEFREC_TRACE") != nullptr; // M0b
            auto findTopLevelAncestor = [&](Operation* op) -> Operation* {
                Operation* current = op;
                while (current) {
                    Block* block = current->getBlock();
                    if (!block)
                        return nullptr;
                    if (block->getParent() == &funcBody)
                        return current;
                    current = block->getParentOp();
                }
                return nullptr;
            };

            auto snapshotForOp = [&](Operation* op)
                -> const SSAVersionTracker::Snapshot* {
                Operation* topOp = findTopLevelAncestor(op);
                if (!topOp)
                    return nullptr;
                Block* topBlock = topOp->getBlock();
                auto it = blockExitState.find(topBlock);
                if (it == blockExitState.end())
                    return nullptr;
                return &it->second;
            };

            // Gather survivors first; mutating during a walk would
            // invalidate iterators.
            llvm::SmallVector<helix::low::RegReadOp, 16> survivingReads;
            funcBody.walk([&](helix::low::RegReadOp r) {
                // The main per-block loop only touches ops directly in
                // funcBody's blocks. Anything whose immediate parent
                // region is funcBody was already processed (and erased)
                // by the main loop, so we'd never see those here — but
                // guard anyway to keep this sweep strictly additive.
                if (r->getBlock() && r->getBlock()->getParent() == &funcBody)
                    return;
                survivingReads.push_back(r);
            });
            llvm::SmallVector<helix::low::RegWriteOp, 16> survivingWrites;
            funcBody.walk([&](helix::low::RegWriteOp w) {
                if (w->getBlock() && w->getBlock()->getParent() == &funcBody)
                    return;
                survivingWrites.push_back(w);
            });

            // Strategy B models nested regions with mutable register slots.
            // A fixed debug parameter must not be that slot: compiled code
            // freely reuses ABI registers after consuming their entry value.
            // Create one initialized shadow per top-level block/register when
            // a nested full-width write would otherwise target a parameter.
            using RegionRegKey = std::pair<Block*, std::string>;
            std::set<RegionRegKey> nestedWrittenRegs;
            for (auto writeOp : survivingWrites) {
                auto subReg = getSubRegInfo(writeOp.getRegName());
                Operation* topOp = findTopLevelAncestor(writeOp);
                if (!subReg || !topOp ||
                    subReg->width != 64 || subReg->bitOffset != 0)
                    continue;
                nestedWrittenRegs.emplace(topOp->getBlock(),
                                          subReg->parent);
            }

            std::map<RegionRegKey, SSAVersionTracker::Version>
                nestedParameterShadows;
            auto versionForNestedOp =
                [&](Operation* op, llvm::StringRef canonicalReg)
                    -> const SSAVersionTracker::Version* {
                const SSAVersionTracker::Snapshot* snap = snapshotForOp(op);
                if (!snap)
                    return nullptr;
                auto vit = snap->find(canonicalReg);
                if (vit == snap->end())
                    return nullptr;

                const auto& reaching = vit->second;
                if (!tracker.preserveExactParameterIdentity)
                    return &reaching;

                auto reachingDecl =
                    dyn_cast_or_null<helix::high::VarDeclOp>(reaching.decl);
                Operation* topOp = findTopLevelAncestor(op);
                if (!reachingDecl || !topOp ||
                    reachingDecl.getStorage() !=
                        helix::high::StorageKind::Parameter)
                    return &reaching;

                RegionRegKey key{topOp->getBlock(),
                                 canonicalReg.str()};
                if (!nestedWrittenRegs.contains(key))
                    return &reaching;

                auto existing = nestedParameterShadows.find(key);
                if (existing != nestedParameterShadows.end())
                    return &existing->second;

                std::string shadowName =
                    llvm::formatv("{0}_region_{1}",
                                  regToVarName(canonicalReg),
                                  tracker.varIdCounter).str();
                auto shadowDecl =
                    declBuilder.create<helix::high::VarDeclOp>(
                        funcLoc,
                        /*var_id=*/tracker.varIdCounter++,
                        /*var_name=*/shadowName,
                        /*storage=*/helix::high::StorageKind::Register,
                        /*stack_offset=*/IntegerAttr{},
                        /*init=*/Value{},
                        /*address=*/IntegerAttr{});

                OpBuilder initBuilder(topOp);
                auto i64Ty = initBuilder.getIntegerType(64);
                auto sourceRef =
                    initBuilder.create<helix::high::VarRefOp>(
                        topOp->getLoc(), i64Ty, reaching.varId,
                        initBuilder.getStringAttr(reaching.varName),
                        mlir::IntegerAttr{});
                auto shadowRef =
                    initBuilder.create<helix::high::VarRefOp>(
                        topOp->getLoc(), i64Ty, shadowDecl.getVarId(),
                        shadowDecl.getVarName(), mlir::IntegerAttr{});
                initBuilder.create<helix::high::AssignOp>(
                    topOp->getLoc(), shadowRef.getResult(),
                    sourceRef.getResult(), mlir::IntegerAttr{});

                auto [inserted, _] = nestedParameterShadows.emplace(
                    std::move(key),
                    SSAVersionTracker::Version{
                        shadowDecl, shadowDecl.getVarId(),
                        shadowDecl.getVarName().str()});
                ++NumRegVarsCreated;
                ++NumSSAVersions;
                return &inserted->second;
            };

            // ── Return-context fallback for in-region RAX writes ──────────
            //
            // For hash-loop style functions (FNV, CRC, etc.) the final RAX
            // value is computed INSIDE a loop region and there is no
            // top-level RegWrite to RAX after the loop — control just
            // jumps to the return block.  The main per-block loop never
            // sees those in-region writes, so `isReturnContext` never fires
            // for them, no "result" VarDecl gets created, and the snapshot
            // version at the loop's containing top-level block is the last
            // pre-loop name (e.g. "rax_2").  The sweep below would then
            // bind every in-region RAX write to "rax_2", and EliminateDeadCode
            // — seeing nothing downstream that reads "rax_2" — drops the
            // entire accumulator chain.  The C output then declares an
            // unassigned `int64_t result;` and the loop body is empty
            // except for the byte-load.
            //
            // Fix: when a surviving in-region RAX (full-width) write exists,
            // reuse the exact `result` SSA identity already created by the
            // top-level walk. Only synthesize that identity when the nested
            // region is the first place that writes the return register.
            // Looking this up by var_id matters: the old string-map probe used
            // the non-existent key "RAX__result", so it created a second
            // VarDecl named `result` even when one already existed. The C AST
            // then contained two declarations with the same identifier.
            // FIX (return-context, if-region extension): originally gated
            // to LOOP regions only (do_while/while/for) -- hash-loop
            // functions (FNV, CRC, ...) match that shape. If-only RAX
            // writes (an early-return guard clause: `if (cond) { ...;
            // return 1; } else { ...; return 0; }`, both writes converging
            // on one shared exit block via jmp) were deliberately excluded
            // per a prior note that doing so "exposes raw-VA derefs that
            // score worse without adding semantic content." Empirically
            // (isolated repro: a bare `if(argc<4){printf;return 1;}
            // return 0;` guard clause) if-only writes are NOT already
            // handled elsewhere -- they hit exactly the failure mode this
            // whole fallback exists to fix (uninitialized `result`,
            // DCE'd write, damning-honesty confidence cap), so the
            // original premise doesn't hold for this shape. Extending to
            // `IfOp` is still additive-only: it only widens which
            // orphaned in-region RAX writes get a real backing variable
            // instead of being silently DCE'd; it never touches a write
            // that was already being handled by another path. Validate
            // corpus-wide before trusting this over the prior guard's
            // warning -- that warning came from a real (if unspecified)
            // regression case, not a guess.
            auto isInsideLoopOrIfRegion = [](Operation* op) {
                for (Operation* cur = op->getParentOp(); cur;
                     cur = cur->getParentOp()) {
                    if (isa<helix::high::DoWhileOp,
                            helix::high::WhileOp,
                            helix::high::ForOp,
                            helix::high::IfOp>(cur))
                        return true;
                }
                return false;
            };

            SSAVersionTracker::Version resultOverride;
            bool useResultOverrideForRAX = false;
            if (tracker.hasReturnValue) {
                bool hasInRegionFullRaxWrite = false;
                for (auto w : survivingWrites) {
                    auto sr = getSubRegInfo(w.getRegName());
                    if (sr && sr->parent == "RAX"
                        && sr->width == 64 && sr->bitOffset == 0
                        && isInsideLoopOrIfRegion(w)) {
                        hasInRegionFullRaxWrite = true;
                        break;
                    }
                }
                if (hasInRegionFullRaxWrite) {
                    auto versionsIt = ssaTracker.allVersions.find("RAX");
                    if (versionsIt != ssaTracker.allVersions.end()) {
                        for (auto it = versionsIt->second.rbegin();
                             it != versionsIt->second.rend(); ++it) {
                            if (it->varName == "result") {
                                resultOverride = *it;
                                useResultOverrideForRAX = true;
                                break;
                            }
                        }
                    }

                    if (!useResultOverrideForRAX) {
                        auto declOp =
                            declBuilder.create<helix::high::VarDeclOp>(
                                funcLoc,
                                /*var_id=*/tracker.varIdCounter++,
                                /*var_name=*/"result",
                                /*storage=*/helix::high::StorageKind::Register,
                                /*stack_offset=*/IntegerAttr{},
                                /*init=*/Value{},
                                /*address=*/IntegerAttr{});
                        tracker.regToDecl["__ret_result"] = declOp;
                        resultOverride.decl = declOp;
                        resultOverride.varId = declOp.getVarId();
                        resultOverride.varName = "result";
                        ++NumRegVarsCreated;
                        ++NumSSAVersions;
                        ++NumReturnVarsNamed;
                        useResultOverrideForRAX = true;
                    }
                }
            }

            // Reads first: a register's snapshot version is its NAMING
            // identity. Writes don't bump the version here (Strategy B).
            for (auto readOp : survivingReads) {
                auto regName = readOp.getRegName();
                auto subRegOpt = getSubRegInfo(regName);
                if (!subRegOpt)
                    continue;
                auto& subReg = *subRegOpt;

                const SSAVersionTracker::Version* verPtr = nullptr;
                if (useResultOverrideForRAX && subReg.parent == "RAX"
                    && isInsideLoopOrIfRegion(readOp)) {
                    // Hash-loop-style return-context fallback: every
                    // in-loop RAX access shares the "result" identity
                    // (sub-register narrowing still applies below).
                    verPtr = &resultOverride;
                } else {
                    verPtr = versionForNestedOp(readOp, subReg.parent);
                    if (!verPtr) {
                        if (stratBTrace)
                            llvm::errs() << "[STRATB] read reg=" << subReg.parent
                                         << " -> NOSNAP (fallthrough->hash-slot)\n";
                        continue;
                    }
                }
                const SSAVersionTracker::Version& ver = *verPtr;
                if (stratBTrace)
                    llvm::errs() << "[STRATB] read reg=" << subReg.parent
                                 << " -> bound:" << ver.varName << "\n";

                OpBuilder b(readOp);
                auto i64Ty = b.getIntegerType(64);
                auto varRef = b.create<helix::high::VarRefOp>(
                    readOp.getLoc(), i64Ty,
                    ver.varId,
                    b.getStringAttr(ver.varName),
                    mlir::IntegerAttr{});

                Value result;
                if (subReg.width == 64 && subReg.bitOffset == 0) {
                    result = varRef.getResult();
                } else if (subReg.bitOffset == 0) {
                    result = emitTruncation(varRef.getResult(),
                                            subReg.width, b,
                                            readOp.getLoc());
                    ++NumAliasesResolved;
                } else {
                    result = emitHighByteExtract(
                        varRef.getResult(), subReg.bitOffset,
                        subReg.width, b, readOp.getLoc());
                    ++NumAliasesResolved;
                }

                if (readOp->hasAttr("helix.infrastructure"))
                    varRef->setAttr("helix.infrastructure",
                                    b.getUnitAttr());

                readOp.getResult().replaceAllUsesWith(result);
                readOp.erase();
                ++NumReadsReplaced;
            }

            // Writes: full-width only (sub-register writes need a read-
            // modify-write of the current version, which Strategy B
            // intentionally doesn't model inside regions). Sub-register
            // writes that survive here continue to fall through to the
            // HelixLowToMid path, matching prior behaviour.
            for (auto writeOp : survivingWrites) {
                auto regName = writeOp.getRegName();
                auto subRegOpt = getSubRegInfo(regName);
                if (!subRegOpt)
                    continue;
                auto& subReg = *subRegOpt;
                if (!(subReg.width == 64 && subReg.bitOffset == 0))
                    continue;

                const SSAVersionTracker::Version* verPtr = nullptr;
                if (useResultOverrideForRAX && subReg.parent == "RAX"
                    && isInsideLoopOrIfRegion(writeOp)) {
                    verPtr = &resultOverride;
                } else {
                    verPtr = versionForNestedOp(writeOp, subReg.parent);
                    if (!verPtr)
                        continue;
                }
                const SSAVersionTracker::Version& ver = *verPtr;

                OpBuilder b(writeOp);
                auto targetRef = b.create<helix::high::VarRefOp>(
                    writeOp.getLoc(),
                    writeOp.getValue().getType(),
                    ver.varId,
                    b.getStringAttr(ver.varName),
                    mlir::IntegerAttr{});
                auto assignOp = b.create<helix::high::AssignOp>(
                    writeOp.getLoc(),
                    targetRef.getResult(),
                    writeOp.getValue(),
                    mlir::IntegerAttr{});

                if (writeOp->hasAttr("helix.infrastructure"))
                    assignOp->setAttr("helix.infrastructure",
                                      b.getUnitAttr());

                writeOp.erase();
                ++NumWritesReplaced;
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

        // M0 (def-recovery scoping): env-gated trace of every lost-def
        // replacement, classified ptr/float/int, to measure the zero-init-ptr
        // source distribution on the pointer-heavy corpus before any redesign.
        const bool defRecTrace = std::getenv("HELIX_DEFREC_TRACE") != nullptr;
        auto defTypeClass = [&](Value v) -> const char* {
            if (auto* dop = v.getDefiningOp())
                if (auto a = dop->getAttrOfType<StringAttr>("inferred_type")) {
                    StringRef s = a.getValue();
                    if (isPointerTypeStr(s)) return "ptr";
                    if (isFloatTypeStr(s)) return "float";
                }
            Type t = v.getType();
            if (isa<LLVM::LLVMPointerType>(t)) return "ptr";
            if (isa<Float32Type>(t) || isa<Float64Type>(t)) return "float";
            return "int";
        };
        auto usedInDeref = [&](Value v) -> bool {
            for (auto& use : v.getUses()) {
                StringRef n = use.getOwner()->getName().getStringRef();
                if (n.contains("load") || n.contains("Load") ||
                    n.contains("field") || n.contains("Field") ||
                    n.contains("gep") || n.contains("Gep"))
                    return true;
            }
            return false;
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

            if (defRecTrace)
                llvm::errs() << "[DEFREC] src=undef type="
                             << defTypeClass(undefVal)
                             << " deref=" << (usedInDeref(undefVal) ? 1 : 0)
                             << "\n";
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

            if (defRecTrace)
                llvm::errs() << "[DEFREC] src=poison type="
                             << defTypeClass(poisonVal)
                             << " deref=" << (usedInDeref(poisonVal) ? 1 : 0)
                             << "\n";
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
                } else if (auto addOp = dyn_cast<LLVM::AddOp>(user)) {
                    // FIX (Maya R. review): the address-forming
                    // `llvm.add(base, const)` shape RecoverVariables
                    // actually sees pre-HelixLowToMid (mid::FieldPtrOp
                    // doesn't exist yet at this pipeline stage -- see
                    // isAddressFormingAdd's comment). Any operand of this
                    // add is address-forming, so it counts regardless of
                    // which side (lhs/rhs) `ref` is on.
                    if (isAddressFormingAdd(addOp))
                        flags |= 0x1;  // addr-forming operand
                    else
                        flags |= 0x2;  // plain integer add
                } else if (isa<helix::low::LeaOp>(user)) {
                    // LEA is pure address computation by definition
                    // (base + index*scale + disp) -- both base (operand 0)
                    // and index (operand 1) are address-forming.
                    flags |= 0x1;
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

        // A mixed version is not split here: it may legitimately use one
        // pointer value in both address and scalar contexts. It must not,
        // however, absorb a separate version that has only scalar uses.
        // Keep this flag-level rule shared with Phase 4 below.
        auto isAddressBearing = [](uint8_t flags) {
            return (flags & 0x1) != 0;
        };
        auto isPureValue = [](uint8_t flags) {
            return (flags & 0x2) != 0 && (flags & 0x1) == 0;
        };
        auto areUsageFlagsCompatible = [&](uint8_t lhs, uint8_t rhs) {
            return !(isAddressBearing(lhs) && isPureValue(rhs)) &&
                   !(isAddressBearing(rhs) && isPureValue(lhs));
        };
        auto areSemanticsCompatible = [&](uint32_t idA, uint32_t idB) {
            return areUsageFlagsCompatible(usageMap.lookup(idA),
                                           usageMap.lookup(idB));
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

                // A fixed debug signature certifies version 0 as a source
                // parameter. Reusing X0/X1 later does not mutate that source
                // variable, so never fold subsequent register lifetimes back
                // into it. Phase 4 may still merge the resulting locals.
                if (tracker.preserveExactParameterIdentity) {
                    auto baseDecl =
                        dyn_cast<helix::high::VarDeclOp>(base.decl);
                    if (baseDecl &&
                        baseDecl.getStorage() ==
                            helix::high::StorageKind::Parameter)
                        continue;
                }

                // Type of the base version (for compatibility check).
                auto baseTypeAttr =
                    base.decl->getAttrOfType<StringAttr>("inferred_type");
                bool basePtr = static_cast<bool>(baseTypeAttr) &&
                               isPtrTypeStr(baseTypeAttr.getValue());

                for (size_t vi = 1; vi < versions.size(); ++vi) {
                    auto& ver = versions[vi];
                    if (!ver.decl)
                        continue;

                    // ── Preserve the "result" return-value identity ───────
                    // The return-register version is an implicit output, even
                    // though helix_low.ret has no SSA operand. Coalescing it
                    // into an earlier scratch/parameter version erases the
                    // exact "result" identity used by DCE and CAstBuilder.
                    if (tracker.preserveExactReturnIdentity &&
                        ver.varName == "result" &&
                        base.varName != "result")
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
                    // Refuse coalescing when one version is address-bearing
                    // (Address or Mixed) and the other is pure scalar value.
                    // This catches a pointer-bearing register version trying
                    // to absorb an unrelated counter without splitting the
                    // Mixed version's own uses.
                    if (!areSemanticsCompatible(base.varId, ver.varId))
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
            // Helix v2 experiment: the variable is assigned directly from a
            // call result. Phase 4 must not merge such a variable away, or
            // renameRemainingRegisterVars later collapses the distinct
            // call-return SSA versions into one vN (the v3 = printk(0, v3)
            // x4 defect documented under FIX-081).
            bool definedByCall = false;
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

            // 4. (Helix v2 experiment) Mark variables whose value is assigned
            //    directly from a call result. An AssignOp's target is operand
            //    0 (a VarRefOp result) and its value is getValue(); this
            //    mirrors the Phase-5 single-use guard's call detection.
            body.walk([&](helix::high::AssignOp assign) {
                Value assignedVal = assign.getValue();
                Operation* valDef = assignedVal.getDefiningOp();
                if (!valDef)
                    return;
                if (!isa<helix::high::CallOp>(valDef) &&
                    !helix::isAnyCallOp(valDef))
                    return;
                if (assign->getNumOperands() == 0)
                    return;
                auto targetRef = assign->getOperand(0)
                                     .getDefiningOp<helix::high::VarRefOp>();
                if (!targetRef)
                    return;
                auto it = infoMap.find(targetRef.getVarId());
                if (it != infoMap.end())
                    it->second.definedByCall = true;
            });

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
                } else if (auto addOp = dyn_cast<LLVM::AddOp>(user)) {
                    // Keep this duplicate Phase 4 classifier in sync with
                    // Phase 3.5: this pass still sees raw llvm.add before
                    // HelixLowToMid has materialized field-pointer ops.
                    if (isAddressFormingAdd(addOp))
                        flags |= 0x1;
                    else
                        flags |= 0x2;
                } else if (isa<helix::low::LeaOp>(user)) {
                    flags |= 0x1;
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

        // Phase 4 reuses the Phase 3.5 rule above after rebuilding usageMap
        // for the varIds rewritten by same-register coalescing.

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

        // ---------- Helper: register family of a variable name ----------
        // "rax" / "rax_2" -> "rax". Used to keep the call-result guard
        // CROSS-register only (same-register coalescing is Phase 3.5's job
        // and is correct); we only protect call-result identity when Phase 4
        // would fold it into a DIFFERENT register's variable.
        auto registerBase = [](llvm::StringRef n) -> llvm::StringRef {
            size_t us = n.find('_');
            return (us == llvm::StringRef::npos) ? n : n.take_front(us);
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

                    // Phase 3.5 preserves the implicit return-register
                    // identity for same-register versions. Phase 4 must not
                    // subsequently merge that `result` into an unrelated
                    // register variable merely because their explicit live
                    // ranges do not overlap.
                    bool aIsResult =
                        infoA.decl.getVarName() == "result";
                    bool bIsResult =
                        infoB.decl.getVarName() == "result";
                    if (tracker.preserveExactReturnIdentity &&
                        aIsResult != bIsResult)
                        continue;

                    // FIX-132: scf_r*/scf_w* are explicit storage identities
                    // introduced by StructureControlFlow for region results,
                    // loop-carried state, the loop condition, and parallel-copy
                    // shadows. Their lexical live ranges may appear disjoint,
                    // but tuple components and values carried across a loop
                    // backedge are simultaneously live by construction.
                    // Generic cover-based reuse can merge next_state, auxiliary
                    // results, and continue into one slot, making the last
                    // sequential assignment overwrite the others and turning a
                    // finite cleanup chain into an infinite do-while. Keep every
                    // bridge identity distinct here; the C-AST dispatcher pass
                    // separately coalesces proven scf_r copy chains without
                    // touching scf_w loop storage.
                    const bool aIsSCFBridge =
                        infoA.decl.getVarName().starts_with("scf_");
                    const bool bIsSCFBridge =
                        infoB.decl.getVarName().starts_with("scf_");
                    if (aIsSCFBridge || bIsSCFBridge)
                        continue;

                    // Don't merge if either touches a call block — the
                    // function call may clobber registers, making it unsafe
                    // to assume non-interference.
                    if (infoA.touchesCallBlock && infoB.touchesCallBlock)
                        continue;

                    // Types must be compatible.
                    if (!areTypesCompatible(infoA.decl, infoB.decl))
                        continue;

                    // Semantic usage must be compatible (refuse an
                    // address-bearing variable with a pure-value variable).
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

                    // Phase-4-aware guard (Helix v2 experiment - FIX-081
                    // follow-up option 1). Refuse to merge away a variable
                    // whose value comes from a call result: keeping the
                    // call-result victim distinct preserves call-return
                    // identity that renameRemainingRegisterVars would
                    // otherwise flatten to a single vN. Risk being measured:
                    // extra vN placeholders on legitimate disjoint-liveness
                    // merges across the corpus.
                    // Phase-4-aware guard (FIX-081 follow-up option 1). Refuse
                    // to merge away a call-result variable into a DIFFERENT
                    // register's variable: preserves the call-return identity
                    // that Phase 4's cover-based merge would otherwise fold into
                    // one canonical register (later flattened to a single vN).
                    // Scoped cross-register only so legitimate same-register
                    // coalescing (Phase 3.5's domain) is untouched.
                    //
                    // VALIDATED v0.1.6 on the real Mali kbase corpus: 6 skeptical
                    // adversarial judges scored 5 BETTER / 1 NEUTRAL / 0 WORSE.
                    // It removes factually-wrong void-return captures
                    // (v13 = _dev_err(...)), splits overloaded call-result vars
                    // into distinct named results, de-stubs placeholder branches
                    // into real named kbase_* calls (incl. audit-relevant grow /
                    // -EINVAL paths), and adds no net garbage; net +5pp
                    // confidence, 0 regressions.
                    if (victimInfo.definedByCall &&
                        registerBase(victimInfo.decl.getVarName()) !=
                            registerBase(canonInfo.decl.getVarName())) {
                        continue;
                    }

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
