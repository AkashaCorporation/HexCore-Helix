/// @file PropagateTypes.cpp
/// @brief Type propagation pass: iteratively infer C types from usage patterns.
///
/// Implements a multi-phase fixed-point iteration that refines Unknown types
/// to concrete C types. Different address spaces are processed in separate
/// phases so that types discovered in earlier phases seed later phases:
///
///   Phase 1 — Register types (forward, max 16 rounds)
///   Phase 2 — Backward propagation (use→def, max 16 rounds)
///   Phase 3 — Stack variable refinement (rbp-offset / rsp+offset grouping)
///   Phase 4 — Global/memory type consolidation (address-based grouping)
///   Phase 5 — Re-propagation (forward + backward, 8 rounds each)
///
/// Phase 1 — Forward (def→use): propagates types from definitions to uses:
///   - Access widths (8-bit → int8_t, 32-bit → int32_t, etc.)
///   - API function signatures (known return types and parameter types)
///   - Binary operation semantics (comparison → bool, shift → same type)
///   - Pointer arithmetic patterns (base + offset → pointer)
///   - Sign extension/zero extension (movsx → signed, movzx → unsigned)
///   - JccOp condition codes: signed (l/le/g/ge) or unsigned (b/be/a/ae)
///     propagate signedness back to CmpOp operands
///   - CALL return type: set result type from SignatureDb return type
///   - MUL widening: i32 * i32 → i64 if result is wider
///   - DIV/IDIV: result type matches dividend; signedness from IDiv vs Div
///   - SHL: left shift preserves the type of the shifted value
///   - REP MOVS: memcpy — source/dest are pointers, count is unsigned
///   - REP STOS: memset — dest is pointer, value is integer, count is unsigned
///
/// Phase 1b — Forward (HelixHigh):
///   - FieldAccess: base must be pointer; infer field type from usage context
///   - Subscript (array index): base is pointer, index is integer
///   - Ternary (select): result type from true/false values
///   - AssignOp type alignment: both sides of assignment have compatible types
///
/// Phase 2 — Backward (use→def): infers types from how values are USED back
/// to their definitions:
///   - CMP/TEST backward: if one comparison operand is typed, the other matches
///   - MOVSX backward: sign-extended source must be signed int at source width
///   - MOVZX backward: zero-extended source must be unsigned int at source width
///   - JccOp backward: signed/unsigned condition codes mark CmpOp operands
///   - Store backward: stored value type matches the store target type
///   - Call argument backward: argument types match known parameter types
///   - Call result backward: if call result type is known, propagate to uses
///   - Return backward: returned value type matches function return type
///   - Shift amount backward: RHS of shift is always unsigned integer
///   - Bitwise operand backward: AND/OR/XOR operands should match width
///   - Array base backward: value used as array base must be a pointer
///   - HelixHigh Sar/Shr: SAR implies signed operand, SHR implies unsigned

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/analysis/SignatureDb.h"
#include "helix/utils/CallOpHelpers.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/Debug.h"

#include <format>
#include <map>
#include <optional>
#include <string>

#define DEBUG_TYPE "propagate-types"

using namespace mlir;
using namespace helix;

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// Signedness tracking
// ═══════════════════════════════════════════════════════════════════════════════

/// Signedness state for type propagation.
/// Tracks whether a value is known to be signed, unsigned, or conflicting.
enum class Signedness : uint8_t {
    Unknown  = 0,  ///< No signedness information yet
    Signed   = 1,  ///< Known signed (from MOVSX, signed comparisons, SAR, etc.)
    Unsigned = 2,  ///< Known unsigned (from MOVZX, unsigned comparisons, SHR, etc.)
    Conflict = 3,  ///< Conflicting evidence — treat as Unknown (default to signed)
};

/// Merge two signedness values. Same values unify; different resolved values
/// produce Conflict. Unknown yields to anything.
static Signedness mergeSignedness(Signedness a, Signedness b) {
    if (a == b) return a;
    if (a == Signedness::Unknown) return b;
    if (b == Signedness::Unknown) return a;
    // Both are resolved but different → conflict
    return Signedness::Conflict;
}

/// Classify an x86 JccOp condition code as signed, unsigned, or neutral.
///
/// Signed conditions:   l (SF!=OF), le (ZF=1 or SF!=OF), g, ge
/// Unsigned conditions: b (CF=1), be (CF=1 or ZF=1), a, ae/nb, nae
/// Neutral (no signedness info): z/nz/e/ne (equality), s/ns (sign flag only),
///                                o/no (overflow flag only)
static Signedness signednessFromJccCondition(llvm::StringRef cond) {
    auto c = cond.lower();

    // Signed comparisons: l, nge, nl, ge, le, ng, nle, g
    if (c == "l" || c == "nge" || c == "nl" || c == "ge" ||
        c == "le" || c == "ng" || c == "nle" || c == "g")
        return Signedness::Signed;

    // Unsigned comparisons: b, c, nae, nb, nc, ae, be, na, nbe, a
    if (c == "b" || c == "c" || c == "nae" || c == "nb" || c == "nc" ||
        c == "ae" || c == "be" || c == "na" || c == "nbe" || c == "a")
        return Signedness::Unsigned;

    // Neutral: z/nz/e/ne (equality), s/ns (sign flag), o/no (overflow), p/np
    return Signedness::Unknown;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CTypeInfo
// ═══════════════════════════════════════════════════════════════════════════════

/// Represents a resolved C type for a value.
struct CTypeInfo {
    enum Kind {
        Unknown, Void, Bool, Int, UInt, Float, Pointer, Array, Struct
    };

    Kind kind = Unknown;
    unsigned bit_width = 0;
    bool is_signed = false;
    Signedness signedness = Signedness::Unknown;
    std::string struct_name;

    /// Pointee type for pointers (e.g., int32_t* has pointee = Int/32).
    /// nullptr means void* (untyped pointer).
    std::shared_ptr<CTypeInfo> pointee;

    bool isResolved() const { return kind != Unknown; }
    bool isInteger() const { return kind == Int || kind == UInt; }
    bool isPointer() const { return kind == Pointer; }

    /// Merge another type into this one. Returns true if the type changed.
    bool mergeFrom(const CTypeInfo& other) {
        if (other.kind == Unknown && other.signedness == Signedness::Unknown)
            return false;

        bool changed = false;

        // Merge signedness information even if the kind is already resolved.
        // This allows signedness to refine over multiple iterations.
        Signedness newSign = mergeSignedness(signedness, other.signedness);
        if (newSign != signedness) {
            signedness = newSign;
            changed = true;
        }

        if (other.kind == Unknown) {
            // Only signedness was contributed — update kind to match if needed.
            if (changed)
                syncKindFromSignedness();
            return changed;
        }

        if (kind == Unknown) {
            Signedness savedSign = signedness;
            *this = other;
            // Re-merge signedness since we overwrote *this
            signedness = mergeSignedness(other.signedness, savedSign);
            syncKindFromSignedness();
            return true;
        }

        // Both resolved: if same base integer type, reconcile signedness.
        if ((kind == Int || kind == UInt) &&
            (other.kind == Int || other.kind == UInt) &&
            bit_width == other.bit_width) {
            syncKindFromSignedness();
            return changed;
        }

        // Integer → Pointer promotion: if value is used as a memory address
        // (Pointer) but was previously typed as Int/UInt, Pointer wins.
        // This follows TIE's type lattice: ptr(α) ⊂ num_t.
        if ((kind == Int || kind == UInt) && other.kind == Pointer) {
            *this = other;
            return true;
        }

        // Pointer refinement: if both are pointers, refine void* → typed*
        if (kind == Pointer && other.kind == Pointer) {
            if (!pointee && other.pointee) {
                pointee = other.pointee;
                return true;
            }
            // If both have pointees, merge: unresolved → resolved
            if (pointee && other.pointee && !pointee->isResolved() &&
                other.pointee->isResolved()) {
                pointee = other.pointee;
                return true;
            }
            // Debug-derived nominal structs are stronger evidence than the
            // synthetic auto_struct_N names created by structural recovery.
            // Never replace one nominal type with another: that ambiguity
            // must remain conservative.
            if (pointee && other.pointee &&
                pointee->kind == Struct && other.pointee->kind == Struct) {
                bool currentSynthetic = llvm::StringRef(pointee->struct_name)
                    .starts_with("auto_struct_");
                bool otherSynthetic = llvm::StringRef(other.pointee->struct_name)
                    .starts_with("auto_struct_");
                if (currentSynthetic && !otherSynthetic) {
                    pointee = other.pointee;
                    return true;
                }
            }
        }

        return changed;
    }

    /// Apply signedness to a value without changing the base type.
    /// Returns true if signedness changed.
    bool applySignedness(Signedness s) {
        Signedness newSign = mergeSignedness(signedness, s);
        if (newSign == signedness)
            return false;
        signedness = newSign;
        syncKindFromSignedness();
        return true;
    }

    static CTypeInfo makeInt(unsigned bits, bool isSigned = false) {
        CTypeInfo t;
        t.kind = isSigned ? Int : UInt;
        t.bit_width = bits;
        t.is_signed = isSigned;
        t.signedness = isSigned ? Signedness::Signed : Signedness::Unsigned;
        return t;
    }

    /// Create an integer type with unknown signedness (will default to signed
    /// in the final output phase).
    static CTypeInfo makeIntUnknownSign(unsigned bits) {
        CTypeInfo t;
        t.kind = Int;  // default presentation
        t.bit_width = bits;
        t.is_signed = false;
        t.signedness = Signedness::Unknown;
        return t;
    }

    static CTypeInfo makeBool() {
        CTypeInfo t;
        t.kind = Bool;
        t.bit_width = 1;
        return t;
    }

    static CTypeInfo makePointer(CTypeInfo pointeeType = {}) {
        CTypeInfo t;
        t.kind = Pointer;
        t.bit_width = 64;
        if (pointeeType.isResolved())
            t.pointee = std::make_shared<CTypeInfo>(std::move(pointeeType));
        return t;
    }

    static CTypeInfo makeStruct(llvm::StringRef name) {
        CTypeInfo t;
        t.kind = Struct;
        t.struct_name = name.str();
        return t;
    }

    static CTypeInfo makeVoid() {
        CTypeInfo t;
        t.kind = Void;
        t.bit_width = 0;
        return t;
    }

    /// Create a CTypeInfo that carries only signedness (no type/width).
    /// Used to inject signedness constraints from comparison patterns.
    static CTypeInfo makeSignednessOnly(Signedness s) {
        CTypeInfo t;
        t.kind = Unknown;
        t.signedness = s;
        return t;
    }

    // ─── Pointer arithmetic helpers ────────────────────────────────

    /// ptr + int → ptr (preserves pointee), int + ptr → ptr (commutative).
    static CTypeInfo pointerAddResult(const CTypeInfo& lhs,
                                       const CTypeInfo& rhs) {
        if (lhs.isPointer() && (rhs.isInteger() || !rhs.isResolved()))
            return lhs;
        if (rhs.isPointer() && (lhs.isInteger() || !lhs.isResolved()))
            return rhs;
        return CTypeInfo{};
    }

    /// ptr - ptr → ptrdiff_t (int64), ptr - int → ptr (preserves pointee).
    static CTypeInfo pointerSubResult(const CTypeInfo& lhs,
                                       const CTypeInfo& rhs) {
        if (lhs.isPointer() && rhs.isPointer())
            return makeInt(64, /*isSigned=*/true); // ptrdiff_t
        if (lhs.isPointer() && (rhs.isInteger() || !rhs.isResolved()))
            return lhs;
        return CTypeInfo{};
    }

    /// Dereference: given a pointer type, return the pointee type.
    static CTypeInfo loadThroughPointer(const CTypeInfo& ptrType) {
        if (!ptrType.isPointer())
            return CTypeInfo{};
        if (ptrType.pointee)
            return *ptrType.pointee;
        return CTypeInfo{}; // void* — unknown pointee
    }

    /// Backward: if we store/load T through an address, the address is T*.
    static CTypeInfo pointerTo(const CTypeInfo& valueType) {
        if (!valueType.isResolved())
            return makePointer();
        return makePointer(valueType);
    }

    /// Format as a C type string for the inferred_type attribute.
    /// Signedness resolution: Signed→int, Unsigned→uint, Conflict/Unknown→int
    /// (default to signed for C semantics compatibility).
    std::string toCTypeString() const {
        switch (kind) {
        case Bool:    return "bool";
        case Int:     return std::format("int{}_t", bit_width);
        case UInt:    return std::format("uint{}_t", bit_width);
        case Float:   return std::format("float{}", bit_width);
        case Pointer:
            if (pointee && pointee->isResolved())
                return pointee->toCTypeString() + "*";
            return "void*";
        case Struct:
            return struct_name.empty() ? "struct" : struct_name;
        case Void:    return "void";
        default:      return "";
        }
    }

private:
    /// Synchronize kind and is_signed fields from the signedness enum.
    void syncKindFromSignedness() {
        if (kind != Int && kind != UInt)
            return;
        switch (signedness) {
        case Signedness::Signed:
            kind = Int;
            is_signed = true;
            break;
        case Signedness::Unsigned:
            kind = UInt;
            is_signed = false;
            break;
        case Signedness::Conflict:
            // Conflict defaults to signed (conservative for C semantics)
            kind = Int;
            is_signed = true;
            break;
        case Signedness::Unknown:
            // Keep current kind as-is
            break;
        }
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// Helper: trace a flag value back to the CmpOp that produced it.
// ═══════════════════════════════════════════════════════════════════════════════

/// Given a flag SSA value (i1) consumed by a JccOp or CMovOp, walk the
/// def-chain to find the CmpOp that originally produced the flag.  Returns
/// nullptr if the chain is too complex or does not originate from a CmpOp.
static helix::low::CmpOp traceFlagToCmp(Value flagValue) {
    // Direct case: the flag is a result of CmpOp.
    if (auto* defOp = flagValue.getDefiningOp()) {
        if (auto cmp = dyn_cast<helix::low::CmpOp>(defOp))
            return cmp;
        // Flags may pass through arith.xori (NOT) for negated conditions.
        // Walk one level: xori operand → CmpOp
        if (defOp->getNumOperands() >= 1) {
            if (auto* inner = defOp->getOperand(0).getDefiningOp()) {
                if (auto cmp = dyn_cast<helix::low::CmpOp>(inner))
                    return cmp;
            }
        }
    }
    return nullptr;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Helpers: constant extraction and stack/global address pattern matching
// ═══════════════════════════════════════════════════════════════════════════════

/// Try to extract a constant integer from a Value.
/// Handles arith::ConstantOp and LLVM::ConstantOp.
static std::optional<int64_t> tryExtractConstantInt(Value v) {
    if (auto arithConst = v.getDefiningOp<arith::ConstantOp>()) {
        if (auto intAttr = dyn_cast<IntegerAttr>(arithConst.getValue()))
            return intAttr.getInt();
    }
    if (auto llvmConst = v.getDefiningOp<LLVM::ConstantOp>()) {
        if (auto intAttr = dyn_cast<IntegerAttr>(llvmConst.getValue()))
            return intAttr.getInt();
    }
    return std::nullopt;
}

/// Check if a register name is an infrastructure/bookkeeping register.
/// These are Remill architectural state values that should not appear in
/// decompiled output: program counter tracking, branch targets, return
/// addresses, and the x86/x87/AMD64 EFLAGS bits.  Stores to PC/NEXT_PC
/// are already skipped by RemillToHelixLow, but *reads* survive and
/// propagate through the pipeline as noise.
///
/// FIX-047, part 1): x86 EFLAGS bits added so that infrastructure
/// attribute propagation (Pass 1/2/3 in the `runOnOperation` pre-scan)
/// seeds flag reads uniformly.  Previously, flag RegReadOps were typed
/// as regular i1 values and only got filtered post-hoc in 4 downstream
/// passes (RecoverVariables, CAstBuilder, EliminateDeadCode,
/// PseudoCEmitter), each with its own partial flag list.  Seeding here
/// lets Pass 2's transitive closure also mark `BinOp(RegRead("CF"), ...)`
/// style computations as infrastructure, giving EliminateDeadCode a
/// uniform handle to remove them bottom-up.  Observable output on the
/// malwarebytes/SOTR/gta-sa corpora is unchanged (downstream filters
/// were already catching the tail cases); the win is architectural
/// consistency — one list instead of four overlapping lists, and fewer
/// opportunities for a future corpus to smuggle a flag leak past the
/// last filter.
static bool isInfrastructureRegister(llvm::StringRef name) {
    // Program counter / control-flow bookkeeping.
    if (name == "PC" || name == "NEXT_PC" || name == "RETURN_PC" ||
        name == "BRANCH_TAKEN" || name == "BRANCH_NOT_TAKEN" ||
        name == "RIP" || name == "rip" ||
        name == "EIP" || name == "eip")
        return true;

    // x86 EFLAGS bits.  Remill models these as individual single-bit
    // registers (see RemillToHelixLow.cpp:85-86, 504-505, 2256-2258).
    // They exist in IR only for arithmetic-flag bookkeeping; the real
    // control flow comes from JccOp/CMovOp, and the flag VALUE as an
    // SSA variable is infrastructure.
    if (name == "CF" || name == "PF" || name == "AF" || name == "ZF" ||
        name == "SF" || name == "DF" || name == "OF" || name == "TF" ||
        name == "IF" || name == "NT" || name == "RF" || name == "VM" ||
        name == "AC" || name == "VIF" || name == "VIP" || name == "ID")
        return true;

    return false;
}

/// Check if a Value is a RegReadOp of a frame pointer register (RBP or RSP).
/// Returns true and sets `isRbp` accordingly.
static bool isFramePointerReg(Value v, bool& isRbp) {
    if (auto regRead = v.getDefiningOp<helix::low::RegReadOp>()) {
        auto name = regRead.getRegName();
        if (name == "RBP" || name == "rbp" || name == "EBP" || name == "ebp") {
            isRbp = true;
            return true;
        }
        if (name == "RSP" || name == "rsp" || name == "ESP" || name == "esp") {
            isRbp = false;
            return true;
        }
    }
    return false;
}

/// Try to decode a stack access pattern from an address value.
/// Recognizes: BinOp(RegRead(RBP/RSP), ConstantOp) with Sub or Add.
/// Returns the canonical stack offset (negative for RBP-based locals,
/// positive for RSP-based locals) or nullopt if not a stack access.
static std::optional<int64_t> tryDecodeStackOffset(Value addrValue) {
    auto* addrDef = addrValue.getDefiningOp();
    if (!addrDef)
        return std::nullopt;

    auto binOp = dyn_cast<helix::low::BinOp>(addrDef);
    if (!binOp)
        return std::nullopt;

    auto kind = binOp.getKind();
    if (kind != helix::low::BinOpKind::Sub && kind != helix::low::BinOpKind::Add)
        return std::nullopt;

    bool isRbp = false;
    if (!isFramePointerReg(binOp.getLhs(), isRbp))
        return std::nullopt;

    auto constVal = tryExtractConstantInt(binOp.getRhs());
    if (!constVal)
        return std::nullopt;

    int64_t offset = *constVal;
    if (kind == helix::low::BinOpKind::Sub)
        offset = -offset;

    return offset;
}

/// Describes a single access to a stack slot or global address.
struct MemAccessInfo {
    Operation* op;          ///< The MemReadOp or MemWriteOp
    unsigned bitWidth;      ///< Access width in bits
    bool isStore;           ///< true = MemWriteOp, false = MemReadOp
    Value accessedValue;    ///< For stores: the stored value; for loads: the result
};

/// Given a set of memory accesses to the same stack slot, infer a CTypeInfo
/// by examining access widths, stored value types, and how loaded values are
/// used. The typeEnv is consulted for existing type information on the
/// accessed values.
static CTypeInfo inferSlotType(
        const llvm::SmallVectorImpl<MemAccessInfo>& accesses,
        const llvm::DenseMap<Value, CTypeInfo>& typeEnv) {
    CTypeInfo result;

    // Pass 1: Determine consistent bit width across all accesses.
    unsigned maxWidth = 0;
    for (auto& acc : accesses) {
        if (acc.bitWidth > maxWidth)
            maxWidth = acc.bitWidth;
    }

    // Pass 2: Merge type information from accessed values.
    for (auto& acc : accesses) {
        auto it = typeEnv.find(acc.accessedValue);
        if (it != typeEnv.end() && it->second.isResolved()) {
            result.mergeFrom(it->second);
        }
    }

    // Pass 3: If no type was inferred from values, use width-based default.
    if (!result.isResolved() && maxWidth > 0) {
        result = CTypeInfo::makeIntUnknownSign(maxWidth);
    }

    // Pass 4: Check if any load result is used in a pointer context
    // (passed to getAddr, used as base in another MemRead/MemWrite).
    for (auto& acc : accesses) {
        if (acc.isStore)
            continue;
        for (auto* user : acc.accessedValue.getUsers()) {
            if (isa<helix::low::MemReadOp>(user) ||
                isa<helix::low::MemWriteOp>(user)) {
                // Value is used as an address operand → it's a pointer.
                // Check if it's actually the address operand (operand 0).
                if (user->getNumOperands() > 0 &&
                    user->getOperand(0) == acc.accessedValue) {
                    result = CTypeInfo::makePointer();
                    return result;
                }
            }
            if (isa<helix::low::LeaOp>(user)) {
                result = CTypeInfo::makePointer();
                return result;
            }
        }
    }

    // Pass 5: Check if any stored value comes from a function call with a
    // known return type — that refines what the slot holds.
    for (auto& acc : accesses) {
        if (!acc.isStore)
            continue;
        if (auto* defOp = acc.accessedValue.getDefiningOp()) {
            if (helix::isAnyCallOp(defOp)) {
                if (auto targetName = helix::getCallTargetName(defOp)) {
                    auto sig = helix::lookupSignature(*targetName);
                    if (sig && !sig->return_type.empty()) {
                        // We can't call typeFromSignatureStr here (it's a
                        // member function), so just check for pointer hint.
                        if (sig->return_type == "ptr" ||
                            sig->return_type == "void*") {
                            result = CTypeInfo::makePointer();
                            return result;
                        }
                    }
                }
            }
        }
    }

    return result;
}

// ═══════════════════════════════════════════════════════════════════════════════
// PropagateTypesPass
// ═══════════════════════════════════════════════════════════════════════════════

struct PropagateTypesPass
    : public PassWrapper<PropagateTypesPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(PropagateTypesPass)

    StringRef getArgument() const final { return "propagate-types"; }
    StringRef getDescription() const final {
        return "Iteratively propagate and infer C types from usage patterns";
    }

    bool highOnly_ = false;

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<helix::high::HelixHighDialect>();
    }

    /// Convert a SignatureDb return type string to a CTypeInfo.
    static CTypeInfo typeFromSignatureStr(llvm::StringRef typeStr) {
        typeStr = typeStr.trim();
        for (llvm::StringRef qualifier : {"const ", "volatile ", "restrict "})
            typeStr.consume_front(qualifier);
        typeStr = typeStr.trim();

        if (typeStr.ends_with("*")) {
            llvm::StringRef pointee = typeStr.drop_back().rtrim();
            for (llvm::StringRef qualifier : {"const ", "volatile ", "restrict "})
                pointee.consume_front(qualifier);
            pointee = pointee.trim();
            if (pointee.consume_front("struct "))
                return CTypeInfo::makePointer(CTypeInfo::makeStruct(pointee));
            if (pointee == "void")
                return CTypeInfo::makePointer();
            CTypeInfo scalar = typeFromSignatureStr(pointee);
            return scalar.isResolved()
                ? CTypeInfo::makePointer(scalar)
                : CTypeInfo::makePointer();
        }
        if (typeStr.consume_front("struct "))
            return CTypeInfo::makeStruct(typeStr);
        if (typeStr == "void")
            return CTypeInfo::makeVoid();
        if (typeStr == "ptr" || typeStr == "void*")
            return CTypeInfo::makePointer();
        if (typeStr == "int8" || typeStr == "int8_t" || typeStr == "char" ||
            typeStr == "signed char")
            return CTypeInfo::makeInt(8, /*signed=*/true);
        if (typeStr == "uint8" || typeStr == "uint8_t" ||
            typeStr == "unsigned char" || typeStr == "u8")
            return CTypeInfo::makeInt(8, /*signed=*/false);
        if (typeStr == "int16" || typeStr == "int16_t" || typeStr == "short")
            return CTypeInfo::makeInt(16, /*signed=*/true);
        if (typeStr == "uint16" || typeStr == "uint16_t" ||
            typeStr == "unsigned short" || typeStr == "u16")
            return CTypeInfo::makeInt(16, /*signed=*/false);
        if (typeStr == "int32" || typeStr == "int32_t" || typeStr == "int")
            return CTypeInfo::makeInt(32, /*signed=*/true);
        if (typeStr == "uint32" || typeStr == "uint32_t" ||
            typeStr == "unsigned int" || typeStr == "u32")
            return CTypeInfo::makeInt(32, /*signed=*/false);
        if (typeStr == "int64" || typeStr == "int64_t" || typeStr == "long" ||
            typeStr == "long int")
            return CTypeInfo::makeInt(64, /*signed=*/true);
        if (typeStr == "uint64" || typeStr == "uint64_t" || typeStr == "u64" ||
            typeStr == "unsigned long" || typeStr == "long unsigned int")
            return CTypeInfo::makeInt(64, /*signed=*/false);
        if (typeStr == "bool")
            return CTypeInfo::makeBool();
        // Default: unknown
        return CTypeInfo{};
    }

    /// Returns true if the given Value has a user-supplied type hint that
    /// should survive propagation.  O(1) — just a set lookup.
    static bool isTypeLocked(Value v,
                             const llvm::DenseSet<Value>& lockedValues) {
        return lockedValues.count(v) != 0;
    }

    void runOnOperation() override {
        auto module = getOperation();
        if (!highOnly_) {
            module.walk([&](helix::low::FuncOp func) {
                propagateTypesLow(func);
            });
            return;
        }

        // The pipeline retains low::FuncOp as its function container after
        // MidToHigh. Walk High operations through that container explicitly.
        module.walk([&](helix::low::FuncOp func) {
            propagateTypesHigh(func);
        });

        // Also support standalone High IR supplied directly by API clients.
        module.walk([&](helix::high::FuncOp func) {
            propagateTypesHigh(func);
        });
    }

private:
    static constexpr unsigned kMaxIterations = 16;
    static constexpr unsigned kRePropIterations = 8;

    /// Map from var_id to its inferred type (shared across iterations).
    using VarTypeMap = llvm::DenseMap<uint32_t, CTypeInfo>;

    void propagateTypesLow(helix::low::FuncOp func) {
        // TypeEnv: maps SSA Values to their inferred C type.
        llvm::DenseMap<Value, CTypeInfo> typeEnv;

        // ─── Type-lock pre-scan ──────────────────────────────────────────────
        //
        // Any SSA value whose defining op carries a "helix.type_hint" attribute
        // is seeded with the user-supplied type and shielded from all further
        // propagation updates.  The set provides O(1) lock checks.
        llvm::DenseSet<Value> lockedValues;

        func.walk([&](Operation* op) {
            auto hint = op->getAttrOfType<StringAttr>("helix.type_hint");
            if (!hint)
                return;
            CTypeInfo hintType = typeFromSignatureStr(hint.getValue());
            if (!hintType.isResolved())
                return;
            for (Value result : op->getResults()) {
                typeEnv[result] = hintType;
                lockedValues.insert(result);
            }
        });

        // ─── Infrastructure pre-scan ────────────────────────────────────────
        //
        // Identify bookkeeping SSA values that should not receive C types or
        // produce decompiled output.  These originate from Remill's
        // architectural state tracking (PC, NEXT_PC, RETURN_PC, BRANCH_TAKEN)
        // and flag computations that serve only control flow.
        //
        // Strategy:
        //   Pass 1 — Seed: RegReadOp for infrastructure registers
        //   Pass 2 — Transitive: values computed solely from infra + constants
        //   Pass 3 — Flag-only: flag results used exclusively by JccOp/CMovOp
        //   Then lock all at Unknown type and mark with helix.infrastructure.
        llvm::DenseSet<Value> infraValues;

        // Pass 1: Direct infrastructure register reads.
        // Stores to PC/NEXT_PC are already skipped in RemillToHelixLow, but
        // loads (RegReadOp) survive and seed computation chains.
        func.walk([&](helix::low::RegReadOp regRead) {
            if (isInfrastructureRegister(regRead.getRegName()))
                infraValues.insert(regRead.getResult());
        });

        // Pass 2: Transitive closure — values computed solely from
        // infrastructure values and/or constants are also infrastructure.
        // Example: BinOp(RegRead("PC"), const(5)) → PC+5 is still infra.
        {
            bool infraChanged = true;
            unsigned maxIters = 16;
            while (infraChanged && maxIters-- > 0) {
                infraChanged = false;
                func.walk([&](Operation* op) {
                    if (op->getNumResults() == 0 || op->getNumOperands() == 0)
                        return;
                    Value result = op->getResult(0);
                    if (infraValues.count(result))
                        return;

                    bool hasInfra = false;
                    bool allInfraOrConst = true;
                    for (Value operand : op->getOperands()) {
                        if (infraValues.count(operand)) {
                            hasInfra = true;
                        } else if (!tryExtractConstantInt(operand).has_value()) {
                            allInfraOrConst = false;
                            break;
                        }
                    }

                    if (hasInfra && allInfraOrConst) {
                        infraValues.insert(result);
                        infraChanged = true;
                    }
                });
            }
        }

        // Pass 3: Flag-only computations — CmpOp/TestOp flag results
        // that exclusively feed control flow (JccOp/CMovOp) and never
        // escape to variables or memory.
        func.walk([&](Operation* op) {
            if (!isa<helix::low::CmpOp>(op) && !isa<helix::low::TestOp>(op))
                return;
            for (Value result : op->getResults()) {
                if (result.use_empty())
                    continue;
                bool allControlFlow = true;
                for (auto* user : result.getUsers()) {
                    if (!isa<helix::low::JccOp>(user) &&
                        !isa<helix::low::CMovOp>(user)) {
                        allControlFlow = false;
                        break;
                    }
                }
                if (allControlFlow)
                    infraValues.insert(result);
            }
        });

        // Lock infrastructure values at Unknown type — prevents any
        // propagation rule from assigning them real C types.  They remain
        // unresolved, making downstream elimination easier.
        for (Value v : infraValues)
            lockedValues.insert(v);

        // Mark infrastructure ops with attribute for downstream passes
        // (RecoverVariables, EliminateDeadCode, PseudoCEmitter).
        for (Value v : infraValues) {
            if (auto* defOp = v.getDefiningOp())
                defOp->setAttr("helix.infrastructure",
                    UnitAttr::get(defOp->getContext()));
        }

        // Iterate until fixed point.
        for (unsigned iter = 0; iter < kMaxIterations; iter++) {
            bool changed = false;

            func.walk([&](Operation* op) {
                // Rule 1: Register reads — infer type from bit width.
                if (auto regRead = dyn_cast<helix::low::RegReadOp>(op)) {
                    auto result = regRead.getResult();
                    if (!isTypeLocked(result, lockedValues)) {
                        CTypeInfo inferred =
                            CTypeInfo::makeIntUnknownSign(regRead.getBitWidth());
                        if (typeEnv[result].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Rule 2: Memory reads — infer type from bit width.
                // Also: the address operand is always a pointer.
                if (auto memRead = dyn_cast<helix::low::MemReadOp>(op)) {
                    auto result = memRead.getResult();
                    if (!isTypeLocked(result, lockedValues)) {
                        CTypeInfo inferred =
                            CTypeInfo::makeIntUnknownSign(memRead.getBitWidth());
                        if (typeEnv[result].mergeFrom(inferred))
                            changed = true;
                    }
                    // Rule 2b: MemRead address operand → pointer.
                    if (!isTypeLocked(memRead.getAddr(), lockedValues)) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (typeEnv[memRead.getAddr()].mergeFrom(ptrType))
                            changed = true;
                    }
                    return;
                }

                // Rule 3: Binary ops — result type from operand types.
                // Pointer arithmetic: pointer + integer → pointer.
                // Also includes operation-specific sub-rules (14-16).
                if (auto binop = dyn_cast<helix::low::BinOp>(op)) {
                    auto result = binop.getResult();
                    auto kind = binop.getKind();
                    auto lhsType = typeEnv[binop.getLhs()];
                    auto rhsType = typeEnv[binop.getRhs()];

                    CTypeInfo inferred;
                    // Pointer propagation: if either operand is a pointer,
                    // the result of ADD/SUB is also a pointer.
                    if (lhsType.kind == CTypeInfo::Pointer ||
                        rhsType.kind == CTypeInfo::Pointer) {
                        inferred = CTypeInfo::makePointer();
                    } else if (lhsType.isResolved()) {
                        inferred = lhsType;
                    } else if (rhsType.isResolved()) {
                        inferred = rhsType;
                    }

                    if (inferred.isResolved() &&
                        !isTypeLocked(result, lockedValues)) {
                        if (typeEnv[result].mergeFrom(inferred))
                            changed = true;
                    }

                    // Rule 14: MUL widening — if both operands are narrower
                    // than the result, this is a widening multiply.
                    // IMul → signed, Mul → unsigned.
                    if (kind == helix::low::BinOpKind::Mul ||
                        kind == helix::low::BinOpKind::IMul) {
                        unsigned resultWidth = 0;
                        if (auto intTy = dyn_cast<IntegerType>(
                                result.getType()))
                            resultWidth = intTy.getWidth();
                        unsigned lhsWidth = lhsType.isResolved()
                                                ? lhsType.bit_width : 0;
                        unsigned rhsWidth = rhsType.isResolved()
                                                ? rhsType.bit_width : 0;

                        bool isSigned =
                            (kind == helix::low::BinOpKind::IMul);

                        // Widening multiply: operands narrower than result.
                        if (resultWidth > 0 &&
                            ((lhsWidth > 0 && lhsWidth < resultWidth) ||
                             (rhsWidth > 0 && rhsWidth < resultWidth))) {
                            if (!isTypeLocked(result, lockedValues)) {
                                CTypeInfo wideType =
                                    CTypeInfo::makeInt(resultWidth, isSigned);
                                if (typeEnv[result].mergeFrom(wideType))
                                    changed = true;
                            }
                        }

                        // IMul → both operands signed; Mul → unsigned.
                        Signedness mulSign = isSigned ? Signedness::Signed
                                                     : Signedness::Unsigned;
                        if (!isTypeLocked(binop.getLhs(), lockedValues))
                            if (typeEnv[binop.getLhs()].applySignedness(
                                    mulSign))
                                changed = true;
                        if (!isTypeLocked(binop.getRhs(), lockedValues))
                            if (typeEnv[binop.getRhs()].applySignedness(
                                    mulSign))
                                changed = true;
                        if (!isTypeLocked(result, lockedValues))
                            if (typeEnv[result].applySignedness(mulSign))
                                changed = true;
                    }

                    // Rule 15: DIV/IDIV — result type matches the dividend
                    // (LHS). IDiv → signed, Div → unsigned.
                    if (kind == helix::low::BinOpKind::Div ||
                        kind == helix::low::BinOpKind::IDiv) {
                        bool isSigned =
                            (kind == helix::low::BinOpKind::IDiv);
                        Signedness divSign = isSigned ? Signedness::Signed
                                                     : Signedness::Unsigned;

                        // Result inherits dividend (LHS) type.
                        if (lhsType.isResolved() &&
                            !isTypeLocked(result, lockedValues)) {
                            if (typeEnv[result].mergeFrom(lhsType))
                                changed = true;
                        }

                        // Apply signedness to all participants.
                        if (!isTypeLocked(binop.getLhs(), lockedValues))
                            if (typeEnv[binop.getLhs()].applySignedness(
                                    divSign))
                                changed = true;
                        if (!isTypeLocked(binop.getRhs(), lockedValues))
                            if (typeEnv[binop.getRhs()].applySignedness(
                                    divSign))
                                changed = true;
                        if (!isTypeLocked(result, lockedValues))
                            if (typeEnv[result].applySignedness(divSign))
                                changed = true;
                    }

                    // Rule 16: SHL — left shift preserves the type of the
                    // shifted value (LHS). Shift amount (RHS) is unsigned.
                    if (kind == helix::low::BinOpKind::Shl) {
                        if (lhsType.isResolved() &&
                            !isTypeLocked(result, lockedValues)) {
                            if (typeEnv[result].mergeFrom(lhsType))
                                changed = true;
                        }
                        if (!isTypeLocked(binop.getRhs(), lockedValues)) {
                            unsigned rhsWidth = 0;
                            if (auto intTy = dyn_cast<IntegerType>(
                                    binop.getRhs().getType()))
                                rhsWidth = intTy.getWidth();
                            if (rhsWidth > 0) {
                                CTypeInfo shiftAmt =
                                    CTypeInfo::makeInt(rhsWidth,
                                                       /*signed=*/false);
                                if (typeEnv[binop.getRhs()].mergeFrom(
                                        shiftAmt))
                                    changed = true;
                            }
                        }
                    }

                    // SHR/SAR: shift amount is always unsigned.
                    if (kind == helix::low::BinOpKind::Shr ||
                        kind == helix::low::BinOpKind::Sar) {
                        if (!isTypeLocked(binop.getRhs(), lockedValues)) {
                            unsigned rhsWidth = 0;
                            if (auto intTy = dyn_cast<IntegerType>(
                                    binop.getRhs().getType()))
                                rhsWidth = intTy.getWidth();
                            if (rhsWidth > 0) {
                                CTypeInfo shiftAmt =
                                    CTypeInfo::makeInt(rhsWidth,
                                                       /*signed=*/false);
                                if (typeEnv[binop.getRhs()].mergeFrom(
                                        shiftAmt))
                                    changed = true;
                            }
                        }
                    }

                    // Flags are always bool — lock checks applied per-flag.
                    CTypeInfo boolType = CTypeInfo::makeBool();
                    if (!isTypeLocked(binop.getCarryFlag(), lockedValues))
                        if (typeEnv[binop.getCarryFlag()].mergeFrom(boolType))
                            changed = true;
                    if (!isTypeLocked(binop.getZeroFlag(), lockedValues))
                        if (typeEnv[binop.getZeroFlag()].mergeFrom(boolType))
                            changed = true;
                    if (!isTypeLocked(binop.getSignFlag(), lockedValues))
                        if (typeEnv[binop.getSignFlag()].mergeFrom(boolType))
                            changed = true;
                    if (!isTypeLocked(binop.getOverflowFlag(), lockedValues))
                        if (typeEnv[binop.getOverflowFlag()].mergeFrom(boolType))
                            changed = true;
                    return;
                }

                // Rule 3b: arith/LLVM ADD/SUB — pointer arithmetic.
                // Ghidra TypeOpIntAdd::propagateType: if either input of
                // ADD is a pointer, the output is a pointer (but not both).
                // Handles both arith::AddIOp and LLVM::AddOp.
                {
                    Value addLhs, addRhs;
                    Value addResult;
                    if (auto addOp = dyn_cast<arith::AddIOp>(op)) {
                        addLhs = addOp.getLhs();
                        addRhs = addOp.getRhs();
                        addResult = addOp.getResult();
                    } else if (auto llvmAdd = dyn_cast<LLVM::AddOp>(op)) {
                        addLhs = llvmAdd.getLhs();
                        addRhs = llvmAdd.getRhs();
                        addResult = llvmAdd.getRes();
                    }
                    if (addResult) {
                        auto lhsType = typeEnv[addLhs];
                        auto rhsType = typeEnv[addRhs];
                        bool lhsIsPtr = lhsType.kind == CTypeInfo::Pointer;
                        bool rhsIsPtr = rhsType.kind == CTypeInfo::Pointer;
                        if ((lhsIsPtr || rhsIsPtr) &&
                            !(lhsIsPtr && rhsIsPtr)) {
                            if (!isTypeLocked(addResult, lockedValues)) {
                                CTypeInfo ptrType =
                                    CTypeInfo::makePointer();
                                if (typeEnv[addResult].mergeFrom(ptrType))
                                    changed = true;
                            }
                        }
                        return;
                    }
                }
                if (auto subOp = dyn_cast<arith::SubIOp>(op)) {
                    auto lhsType = typeEnv[subOp.getLhs()];
                    if (lhsType.kind == CTypeInfo::Pointer) {
                        if (!isTypeLocked(subOp.getResult(), lockedValues)) {
                            CTypeInfo ptrType = CTypeInfo::makePointer();
                            if (typeEnv[subOp.getResult()].mergeFrom(ptrType))
                                changed = true;
                        }
                    }
                    return;
                }

                // Rule 4: CMP/TEST — output flags are bool.
                if (auto cmp = dyn_cast<helix::low::CmpOp>(op)) {
                    CTypeInfo boolType = CTypeInfo::makeBool();
                    if (!isTypeLocked(cmp.getCarryFlag(), lockedValues))
                        if (typeEnv[cmp.getCarryFlag()].mergeFrom(boolType))
                            changed = true;
                    if (!isTypeLocked(cmp.getZeroFlag(), lockedValues))
                        if (typeEnv[cmp.getZeroFlag()].mergeFrom(boolType))
                            changed = true;
                    if (!isTypeLocked(cmp.getSignFlag(), lockedValues))
                        if (typeEnv[cmp.getSignFlag()].mergeFrom(boolType))
                            changed = true;
                    if (!isTypeLocked(cmp.getOverflowFlag(), lockedValues))
                        if (typeEnv[cmp.getOverflowFlag()].mergeFrom(boolType))
                            changed = true;
                    return;
                }

                if (auto test = dyn_cast<helix::low::TestOp>(op)) {
                    CTypeInfo boolType = CTypeInfo::makeBool();
                    if (!isTypeLocked(test.getZeroFlag(), lockedValues))
                        if (typeEnv[test.getZeroFlag()].mergeFrom(boolType))
                            changed = true;
                    if (!isTypeLocked(test.getSignFlag(), lockedValues))
                        if (typeEnv[test.getSignFlag()].mergeFrom(boolType))
                            changed = true;
                    return;
                }

                // Rule 5: MOVZX → destination unsigned, source unsigned.
                if (auto movzx = dyn_cast<helix::low::MovZxOp>(op)) {
                    unsigned dstWidth = movzx.getDstWidth();
                    unsigned srcWidth =
                        movzx.getSrc().getType().getIntOrFloatBitWidth();
                    if (!isTypeLocked(movzx.getResult(), lockedValues)) {
                        CTypeInfo dstInferred =
                            CTypeInfo::makeInt(dstWidth, /*signed=*/false);
                        if (typeEnv[movzx.getResult()].mergeFrom(dstInferred))
                            changed = true;
                    }
                    if (!isTypeLocked(movzx.getSrc(), lockedValues)) {
                        CTypeInfo srcInferred =
                            CTypeInfo::makeInt(srcWidth, /*signed=*/false);
                        if (typeEnv[movzx.getSrc()].mergeFrom(srcInferred))
                            changed = true;
                    }
                    return;
                }

                // Rule 6: MOVSX → destination signed, source signed.
                if (auto movsx = dyn_cast<helix::low::MovSxOp>(op)) {
                    unsigned dstWidth = movsx.getDstWidth();
                    unsigned srcWidth =
                        movsx.getSrc().getType().getIntOrFloatBitWidth();
                    if (!isTypeLocked(movsx.getResult(), lockedValues)) {
                        CTypeInfo dstInferred =
                            CTypeInfo::makeInt(dstWidth, /*signed=*/true);
                        if (typeEnv[movsx.getResult()].mergeFrom(dstInferred))
                            changed = true;
                    }
                    if (!isTypeLocked(movsx.getSrc(), lockedValues)) {
                        CTypeInfo srcInferred =
                            CTypeInfo::makeInt(srcWidth, /*signed=*/true);
                        if (typeEnv[movsx.getSrc()].mergeFrom(srcInferred))
                            changed = true;
                    }
                    return;
                }

                // Rule 7: LEA → pointer (address computation).
                if (auto lea = dyn_cast<helix::low::LeaOp>(op)) {
                    if (!isTypeLocked(lea.getResult(), lockedValues)) {
                        CTypeInfo inferred = CTypeInfo::makePointer();
                        if (typeEnv[lea.getResult()].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Rule 8: POP → int64 (stack width).
                if (auto pop = dyn_cast<helix::low::PopOp>(op)) {
                    if (!isTypeLocked(pop.getResult(), lockedValues)) {
                        CTypeInfo inferred = CTypeInfo::makeIntUnknownSign(64);
                        if (typeEnv[pop.getResult()].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Rule 9: Unary ops — result type same as operand.
                if (auto unary = dyn_cast<helix::low::UnaryOp>(op)) {
                    if (!isTypeLocked(unary.getResult(), lockedValues)) {
                        auto operandType = typeEnv[unary.getOperand()];
                        if (operandType.isResolved()) {
                            if (typeEnv[unary.getResult()].mergeFrom(
                                    operandType))
                                changed = true;
                        }
                    }
                    CTypeInfo boolType = CTypeInfo::makeBool();
                    if (!isTypeLocked(unary.getZeroFlag(), lockedValues))
                        if (typeEnv[unary.getZeroFlag()].mergeFrom(boolType))
                            changed = true;
                    if (!isTypeLocked(unary.getSignFlag(), lockedValues))
                        if (typeEnv[unary.getSignFlag()].mergeFrom(boolType))
                            changed = true;
                    return;
                }

                // Rule 10: CMOV — result type from true/false values.
                // Also propagate signedness from the condition code.
                if (auto cmov = dyn_cast<helix::low::CMovOp>(op)) {
                    if (!isTypeLocked(cmov.getResult(), lockedValues)) {
                        auto trueType = typeEnv[cmov.getTrueVal()];
                        auto falseType = typeEnv[cmov.getFalseVal()];
                        CTypeInfo inferred;
                        if (trueType.isResolved())
                            inferred = trueType;
                        else if (falseType.isResolved())
                            inferred = falseType;
                        if (inferred.isResolved()) {
                            if (typeEnv[cmov.getResult()].mergeFrom(inferred))
                                changed = true;
                        }
                    }

                    // CMovOp has a condition attribute — propagate signedness
                    // from the condition to the selected values.
                    if (auto condAttr =
                            cmov->getAttrOfType<StringAttr>("condition")) {
                        Signedness condSign =
                            signednessFromJccCondition(condAttr.getValue());
                        if (condSign != Signedness::Unknown) {
                            if (!isTypeLocked(cmov.getTrueVal(), lockedValues))
                                if (typeEnv[cmov.getTrueVal()].applySignedness(
                                        condSign))
                                    changed = true;
                            if (!isTypeLocked(cmov.getFalseVal(), lockedValues))
                                if (typeEnv[cmov.getFalseVal()].applySignedness(
                                        condSign))
                                    changed = true;
                        }
                    }
                    return;
                }

                // (Rule 11 merged into Rule 13 below — CALL is handled after
                //  JccOp to keep the rule numbering consistent with the new
                //  Ghidra TypeOp-inspired block.)

                // Rule 12: JccOp — propagate signedness from condition code
                // back to the CmpOp operands that produced the flag.
                if (auto jcc = dyn_cast<helix::low::JccOp>(op)) {
                    Signedness condSign = signednessFromJccCondition(jcc.getCondition());
                    if (condSign == Signedness::Unknown)
                        return;

                    // Trace the flag value back to the originating CmpOp.
                    auto cmpOp = traceFlagToCmp(jcc.getFlagValue());
                    if (!cmpOp)
                        return;

                    // Apply signedness to both CmpOp operands.
                    if (typeEnv[cmpOp.getLhs()].applySignedness(condSign))
                        changed = true;
                    if (typeEnv[cmpOp.getRhs()].applySignedness(condSign))
                        changed = true;
                    return;
                }

                // ─── New forward rules (Ghidra TypeOp-inspired) ──────────

                // Rule 13: CALL return type — if calling a known function,
                // propagate the return type from SignatureDb to the call
                // result SSA values (supplements the existing Rule 11 which
                // only set an attribute, not the typeEnv).
                if (helix::isAnyCallOp(op)) {
                    if (auto targetName = helix::getCallTargetName(op)) {
                        auto sig = helix::lookupSignature(*targetName);
                        if (sig) {
                            CTypeInfo retType =
                                typeFromSignatureStr(sig->return_type);
                            if (retType.isResolved()) {
                                // CallOp at HelixLow level has no SSA result,
                                // but set inferred_return_type for later phases.
                                op->setAttr("inferred_return_type",
                                    StringAttr::get(op->getContext(),
                                        sig->return_type));
                            }
                            // Propagate parameter types forward to argument
                            // SSA values (if the call carries explicit args).
                            auto args = helix::getCallArgs(op);
                            for (unsigned i = 0;
                                 i < args.size() &&
                                 i < sig->param_types.size();
                                 i++) {
                                if (isTypeLocked(args[i], lockedValues))
                                    continue;
                                CTypeInfo paramType =
                                    typeFromSignatureStr(sig->param_types[i]);
                                if (paramType.isResolved()) {
                                    if (typeEnv[args[i]].mergeFrom(paramType))
                                        changed = true;
                                }
                            }
                        }
                    }
                    return;
                }

                // Rule 17: REP MOVS — memcpy semantics. Source and dest are
                // pointers, count is an unsigned integer (size_t).
                if (auto repMovs = dyn_cast<helix::low::RepMovsOp>(op)) {
                    if (!isTypeLocked(repMovs.getDst(), lockedValues)) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (typeEnv[repMovs.getDst()].mergeFrom(ptrType))
                            changed = true;
                    }
                    if (!isTypeLocked(repMovs.getSrc(), lockedValues)) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (typeEnv[repMovs.getSrc()].mergeFrom(ptrType))
                            changed = true;
                    }
                    if (!isTypeLocked(repMovs.getCount(), lockedValues)) {
                        CTypeInfo countType =
                            CTypeInfo::makeInt(64, /*signed=*/false); // size_t
                        if (typeEnv[repMovs.getCount()].mergeFrom(countType))
                            changed = true;
                    }
                    return;
                }

                // Rule 18: REP STOS — memset semantics. Dest is a pointer,
                // value is an integer (element width), count is unsigned.
                if (auto repStos = dyn_cast<helix::low::RepStosOp>(op)) {
                    if (!isTypeLocked(repStos.getDst(), lockedValues)) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (typeEnv[repStos.getDst()].mergeFrom(ptrType))
                            changed = true;
                    }
                    if (!isTypeLocked(repStos.getValue(), lockedValues)) {
                        unsigned elemWidth = repStos.getElementWidth();
                        CTypeInfo valueType =
                            CTypeInfo::makeIntUnknownSign(elemWidth);
                        if (typeEnv[repStos.getValue()].mergeFrom(valueType))
                            changed = true;
                    }
                    if (!isTypeLocked(repStos.getCount(), lockedValues)) {
                        CTypeInfo countType =
                            CTypeInfo::makeInt(64, /*signed=*/false); // size_t
                        if (typeEnv[repStos.getCount()].mergeFrom(countType))
                            changed = true;
                    }
                    return;
                }
            });

            // Fixed point reached — no more changes.
            if (!changed)
                break;
        }

        // ─── Phase 2: Backward propagation (use→def) ────────────────────────
        //
        // Walk each operation's results and examine their USES to propagate
        // type constraints backward from consumers to producers.
        for (unsigned backIter = 0; backIter < kMaxIterations; backIter++) {
            bool changed = false;

            func.walk([&](Operation* op) {
                // Backward Rule B1: CMP — both operands should have the same
                // type. If one operand's type is known, propagate to the other.
                if (auto cmp = dyn_cast<helix::low::CmpOp>(op)) {
                    auto lhsType = typeEnv[cmp.getLhs()];
                    auto rhsType = typeEnv[cmp.getRhs()];
                    if (lhsType.isResolved() && !rhsType.isResolved() &&
                        !isTypeLocked(cmp.getRhs(), lockedValues)) {
                        if (typeEnv[cmp.getRhs()].mergeFrom(lhsType))
                            changed = true;
                    } else if (rhsType.isResolved() && !lhsType.isResolved() &&
                               !isTypeLocked(cmp.getLhs(), lockedValues)) {
                        if (typeEnv[cmp.getLhs()].mergeFrom(rhsType))
                            changed = true;
                    }

                    // B1b: Propagate signedness from JccOp consumers back to
                    // the CmpOp operands. Walk all users of each flag result
                    // and check for JccOp condition codes.
                    for (Value flagResult : cmp->getResults()) {
                        for (auto* user : flagResult.getUsers()) {
                            if (auto jcc = dyn_cast<helix::low::JccOp>(user)) {
                                Signedness condSign =
                                    signednessFromJccCondition(
                                        jcc.getCondition());
                                if (condSign != Signedness::Unknown) {
                                    if (!isTypeLocked(cmp.getLhs(),
                                                     lockedValues))
                                        if (typeEnv[cmp.getLhs()].applySignedness(condSign))
                                            changed = true;
                                    if (!isTypeLocked(cmp.getRhs(),
                                                     lockedValues))
                                        if (typeEnv[cmp.getRhs()].applySignedness(condSign))
                                            changed = true;
                                }
                            }
                            // CMovOp also consumes flags with a condition code.
                            if (auto cmov =
                                    dyn_cast<helix::low::CMovOp>(user)) {
                                if (auto condAttr =
                                        cmov->getAttrOfType<StringAttr>(
                                            "condition")) {
                                    Signedness condSign =
                                        signednessFromJccCondition(
                                            condAttr.getValue());
                                    if (condSign != Signedness::Unknown) {
                                        if (!isTypeLocked(cmp.getLhs(),
                                                         lockedValues))
                                            if (typeEnv[cmp.getLhs()].applySignedness(condSign))
                                                changed = true;
                                        if (!isTypeLocked(cmp.getRhs(),
                                                         lockedValues))
                                            if (typeEnv[cmp.getRhs()].applySignedness(condSign))
                                                changed = true;
                                    }
                                }
                            }
                        }
                    }
                    return;
                }

                // Backward Rule B2: TEST — both operands should have the same
                // type (bitwise AND for flag setting).
                if (auto test = dyn_cast<helix::low::TestOp>(op)) {
                    auto lhsType = typeEnv[test.getLhs()];
                    auto rhsType = typeEnv[test.getRhs()];
                    if (lhsType.isResolved() && !rhsType.isResolved() &&
                        !isTypeLocked(test.getRhs(), lockedValues)) {
                        if (typeEnv[test.getRhs()].mergeFrom(lhsType))
                            changed = true;
                    } else if (rhsType.isResolved() && !lhsType.isResolved() &&
                               !isTypeLocked(test.getLhs(), lockedValues)) {
                        if (typeEnv[test.getLhs()].mergeFrom(rhsType))
                            changed = true;
                    }
                    return;
                }

                // Backward Rule B3: MOVSX — if the result of a sign extension
                // is used, the source must be a signed integer at the source
                // bit width (reinforces forward rule, catches cases where the
                // source was previously Unknown).
                if (auto movsx = dyn_cast<helix::low::MovSxOp>(op)) {
                    if (!isTypeLocked(movsx.getSrc(), lockedValues)) {
                        unsigned srcWidth =
                            movsx.getSrc().getType().getIntOrFloatBitWidth();
                        CTypeInfo srcInferred =
                            CTypeInfo::makeInt(srcWidth, /*signed=*/true);
                        if (typeEnv[movsx.getSrc()].mergeFrom(srcInferred))
                            changed = true;

                        // Also: if the destination type is known and signed,
                        // the source must be signed too.
                        auto dstType = typeEnv[movsx.getResult()];
                        if (dstType.isResolved() && dstType.is_signed) {
                            if (typeEnv[movsx.getSrc()].mergeFrom(
                                    CTypeInfo::makeInt(srcWidth,
                                                       /*signed=*/true)))
                                changed = true;
                        }
                    }
                    return;
                }

                // Backward Rule B4: MOVZX — the source must be an unsigned
                // integer at the source bit width.
                if (auto movzx = dyn_cast<helix::low::MovZxOp>(op)) {
                    if (!isTypeLocked(movzx.getSrc(), lockedValues)) {
                        unsigned srcWidth =
                            movzx.getSrc().getType().getIntOrFloatBitWidth();
                        CTypeInfo srcInferred =
                            CTypeInfo::makeInt(srcWidth, /*signed=*/false);
                        if (typeEnv[movzx.getSrc()].mergeFrom(srcInferred))
                            changed = true;

                        // If the destination type is known and unsigned,
                        // reinforce unsigned on the source.
                        auto dstType = typeEnv[movzx.getResult()];
                        if (dstType.isResolved() && !dstType.is_signed &&
                            (dstType.kind == CTypeInfo::UInt ||
                             dstType.kind == CTypeInfo::Int)) {
                            if (typeEnv[movzx.getSrc()].mergeFrom(
                                    CTypeInfo::makeInt(srcWidth,
                                                       /*signed=*/false)))
                                changed = true;
                        }
                    }
                    return;
                }

                // Backward Rule B5: MemWrite (store) — if the value being
                // stored has a known type, propagate it to the address as a
                // pointer. If the stored value's bit width is known from the
                // store's bit_width attribute, infer the value's integer type.
                if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
                    unsigned storeWidth = memWrite.getBitWidth();
                    Value storedValue = memWrite.getValue();
                    auto valueType = typeEnv[storedValue];

                    // The address operand is always a pointer.
                    if (!isTypeLocked(memWrite.getAddr(), lockedValues)) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (typeEnv[memWrite.getAddr()].mergeFrom(ptrType))
                            changed = true;
                    }

                    // If the stored value has no type, infer from store width.
                    if (!valueType.isResolved() &&
                        !isTypeLocked(storedValue, lockedValues)) {
                        CTypeInfo inferred =
                            CTypeInfo::makeIntUnknownSign(storeWidth);
                        if (typeEnv[storedValue].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Backward Rule B6: Call argument — if a value is passed as an
                // argument to a known function, its type should match the
                // parameter type from SignatureDb.
                if (helix::isAnyCallOp(op)) {
                    if (auto targetName = helix::getCallTargetName(op)) {
                        auto sig = helix::lookupSignature(*targetName);
                        if (sig) {
                            auto args = helix::getCallArgs(op);
                            for (unsigned i = 0;
                                 i < args.size() &&
                                 i < sig->param_types.size();
                                 i++) {
                                if (isTypeLocked(args[i], lockedValues))
                                    continue;
                                CTypeInfo paramType =
                                    typeFromSignatureStr(sig->param_types[i]);
                                if (paramType.isResolved()) {
                                    if (typeEnv[args[i]].mergeFrom(paramType))
                                        changed = true;
                                }
                            }
                        }
                    }
                    return;
                }

                // Backward Rule B7: BinOp — if the result type is known,
                // propagate it back to the operands (for non-pointer cases).
                // Also includes B8-B10 sub-rules for shift amounts, bitwise
                // width matching, and address-as-pointer inference.
                if (auto binop = dyn_cast<helix::low::BinOp>(op)) {
                    auto resultType = typeEnv[binop.getResult()];
                    auto kind = binop.getKind();

                    if (resultType.isResolved() &&
                        resultType.kind != CTypeInfo::Pointer) {
                        if (!isTypeLocked(binop.getLhs(), lockedValues))
                            if (typeEnv[binop.getLhs()].mergeFrom(resultType))
                                changed = true;
                        // For non-shift ops, propagate to RHS too.
                        if (kind != helix::low::BinOpKind::Shl &&
                            kind != helix::low::BinOpKind::Shr &&
                            kind != helix::low::BinOpKind::Sar) {
                            if (!isTypeLocked(binop.getRhs(), lockedValues))
                                if (typeEnv[binop.getRhs()].mergeFrom(
                                        resultType))
                                    changed = true;
                        }
                    }

                    // Backward Rule B8: Shift amount — the RHS of any shift
                    // operation is always an unsigned integer.
                    if (kind == helix::low::BinOpKind::Shl ||
                        kind == helix::low::BinOpKind::Shr ||
                        kind == helix::low::BinOpKind::Sar) {
                        if (!isTypeLocked(binop.getRhs(), lockedValues)) {
                            unsigned rhsWidth = 0;
                            if (auto intTy = dyn_cast<IntegerType>(
                                    binop.getRhs().getType()))
                                rhsWidth = intTy.getWidth();
                            if (rhsWidth > 0) {
                                CTypeInfo shiftAmt =
                                    CTypeInfo::makeInt(rhsWidth,
                                                       /*signed=*/false);
                                if (typeEnv[binop.getRhs()].mergeFrom(
                                        shiftAmt))
                                    changed = true;
                            }
                        }
                    }

                    // Backward Rule B9: Bitwise AND/OR/XOR — both operands
                    // should have the same width. If one operand has a known
                    // width, propagate that width to the other.
                    if (kind == helix::low::BinOpKind::And ||
                        kind == helix::low::BinOpKind::Or ||
                        kind == helix::low::BinOpKind::Xor) {
                        auto lhsType = typeEnv[binop.getLhs()];
                        auto rhsType = typeEnv[binop.getRhs()];
                        if (lhsType.isResolved() && !rhsType.isResolved() &&
                            !isTypeLocked(binop.getRhs(), lockedValues)) {
                            CTypeInfo widthOnly =
                                CTypeInfo::makeIntUnknownSign(
                                    lhsType.bit_width);
                            if (typeEnv[binop.getRhs()].mergeFrom(widthOnly))
                                changed = true;
                        } else if (rhsType.isResolved() &&
                                   !lhsType.isResolved() &&
                                   !isTypeLocked(binop.getLhs(),
                                                 lockedValues)) {
                            CTypeInfo widthOnly =
                                CTypeInfo::makeIntUnknownSign(
                                    rhsType.bit_width);
                            if (typeEnv[binop.getLhs()].mergeFrom(widthOnly))
                                changed = true;
                        }
                    }

                    // Backward Rule B10: If a BinOp result is used as a
                    // memory address (fed into MemReadOp/MemWriteOp), it
                    // should be typed as a pointer.
                    for (auto* user : binop.getResult().getUsers()) {
                        if (isa<helix::low::MemReadOp>(user) ||
                            isa<helix::low::MemWriteOp>(user)) {
                            if (!isTypeLocked(binop.getResult(),
                                              lockedValues)) {
                                CTypeInfo ptrType = CTypeInfo::makePointer();
                                if (typeEnv[binop.getResult()].mergeFrom(
                                        ptrType))
                                    changed = true;
                            }
                            break;
                        }
                    }

                    // Backward Rule B10b: Pointer arithmetic back-propagation.
                    // If a BinOp(Add/Sub) result is a pointer, the LHS
                    // operand is a pointer and the RHS is an integer offset.
                    // This is the TIE Figure 7 rule: ptr + int → ptr.
                    if (typeEnv[binop.getResult()].kind == CTypeInfo::Pointer &&
                        (kind == helix::low::BinOpKind::Add ||
                         kind == helix::low::BinOpKind::Sub)) {
                        if (!isTypeLocked(binop.getLhs(), lockedValues)) {
                            CTypeInfo ptrType = CTypeInfo::makePointer();
                            if (typeEnv[binop.getLhs()].mergeFrom(ptrType))
                                changed = true;
                        }
                    }

                    return;
                }

                // Backward Rule B10c: ADD pointer back-propagation.
                // Ghidra propagateAddIn2Out + propagateAddPointer:
                // If ADD result is used as MemRead/MemWrite address,
                // the result is a pointer and the non-constant operand is
                // the base pointer.
                // Handles both arith::AddIOp and LLVM::AddOp.
                {
                    Value addLhs, addRhs, addResult;
                    if (auto arithAdd = dyn_cast<arith::AddIOp>(op)) {
                        addLhs = arithAdd.getLhs();
                        addRhs = arithAdd.getRhs();
                        addResult = arithAdd.getResult();
                    } else if (auto llvmAdd = dyn_cast<LLVM::AddOp>(op)) {
                        addLhs = llvmAdd.getLhs();
                        addRhs = llvmAdd.getRhs();
                        addResult = llvmAdd.getRes();
                    }
                    if (addResult) {
                        // B10 equiv: if result used as memory address → ptr
                        bool usedAsMem = false;
                        for (auto* user : addResult.getUsers()) {
                            if (isa<helix::low::MemReadOp>(user) ||
                                isa<helix::low::MemWriteOp>(user)) {
                                usedAsMem = true;
                                if (!isTypeLocked(addResult, lockedValues)) {
                                    CTypeInfo ptrType =
                                        CTypeInfo::makePointer();
                                    if (typeEnv[addResult].mergeFrom(ptrType))
                                        changed = true;
                                }
                                break;
                            }
                        }
                        // B10b equiv: if result is pointer, back-propagate
                        // to the non-constant operand (base pointer).
                        if (typeEnv[addResult].kind == CTypeInfo::Pointer) {
                            bool rhsIsConst =
                                tryExtractConstantInt(addRhs).has_value();
                            bool lhsIsConst =
                                tryExtractConstantInt(addLhs).has_value();
                            Value target;
                            if (rhsIsConst && !lhsIsConst)
                                target = addLhs;
                            else if (lhsIsConst && !rhsIsConst)
                                target = addRhs;
                            else if (!rhsIsConst && !lhsIsConst)
                                target = addLhs; // convention: LHS is base
                            if (target &&
                                !isTypeLocked(target, lockedValues)) {
                                CTypeInfo ptrType =
                                    CTypeInfo::makePointer();
                                if (typeEnv[target].mergeFrom(ptrType))
                                    changed = true;
                            }
                        }
                        return;
                    }
                }

                // Backward Rule B11: MemReadOp — if the loaded value is
                // used as a pointer (e.g., passed to another MemReadOp as
                // an address), propagate pointer type backward to the load.
                if (auto memRead = dyn_cast<helix::low::MemReadOp>(op)) {
                    Value loadResult = memRead.getResult();
                    if (!isTypeLocked(loadResult, lockedValues)) {
                        for (auto* user : loadResult.getUsers()) {
                            if (auto innerRead =
                                    dyn_cast<helix::low::MemReadOp>(user)) {
                                if (innerRead.getAddr() == loadResult) {
                                    CTypeInfo ptrType =
                                        CTypeInfo::makePointer();
                                    if (typeEnv[loadResult].mergeFrom(ptrType))
                                        changed = true;
                                    break;
                                }
                            }
                            if (auto innerWrite =
                                    dyn_cast<helix::low::MemWriteOp>(user)) {
                                if (innerWrite.getAddr() == loadResult) {
                                    CTypeInfo ptrType =
                                        CTypeInfo::makePointer();
                                    if (typeEnv[loadResult].mergeFrom(ptrType))
                                        changed = true;
                                    break;
                                }
                            }
                        }
                    }
                    return;
                }
            });

            // Fixed point reached — no more backward changes.
            if (!changed)
                break;
        }

        // ─── Phase 3: Stack variable refinement ──────────────────────────────
        //
        // After the initial forward + backward passes have established a basic
        // type skeleton, scan for stack access patterns (rbp - offset,
        // rsp + offset). Group by offset to identify distinct stack variables,
        // then infer each slot's type from the collective access patterns.
        // This is monotonic: types are only added/refined, never removed.
        {
            // Collect stack accesses: (offset -> list of accesses)
            std::map<int64_t, llvm::SmallVector<MemAccessInfo, 4>> stackAccesses;

            func.walk([&](Operation* op) {
                // MemReadOp: load from stack
                if (auto memRead = dyn_cast<helix::low::MemReadOp>(op)) {
                    auto offset = tryDecodeStackOffset(memRead.getAddr());
                    if (!offset)
                        return;
                    MemAccessInfo info;
                    info.op = op;
                    info.bitWidth = memRead.getBitWidth();
                    info.isStore = false;
                    info.accessedValue = memRead.getResult();
                    stackAccesses[*offset].push_back(info);
                    return;
                }

                // MemWriteOp: store to stack
                if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
                    auto offset = tryDecodeStackOffset(memWrite.getAddr());
                    if (!offset)
                        return;
                    MemAccessInfo info;
                    info.op = op;
                    info.bitWidth = memWrite.getBitWidth();
                    info.isStore = true;
                    info.accessedValue = memWrite.getValue();
                    stackAccesses[*offset].push_back(info);
                    return;
                }
            });

            // For each stack slot, infer type from access patterns and apply
            // to all values touching that slot.
            for (auto& [offset, accesses] : stackAccesses) {
                CTypeInfo inferredType = inferSlotType(accesses, typeEnv);
                if (!inferredType.isResolved())
                    continue;

                for (auto& acc : accesses) {
                    if (isTypeLocked(acc.accessedValue, lockedValues))
                        continue;
                    typeEnv[acc.accessedValue].mergeFrom(inferredType);
                }
            }
        }

        // ─── Phase 4: Global/memory type consolidation ───────────────────────
        //
        // Process memory loads/stores at known constant addresses (globals).
        // If the same address is accessed multiple times with a consistent type,
        // lock it and propagate to all load/store sites referencing that address.
        {
            // Collect global accesses: (address -> list of accesses)
            std::map<uint64_t, llvm::SmallVector<MemAccessInfo, 4>> globalAccesses;

            func.walk([&](Operation* op) {
                // MemReadOp at a constant address (not stack-relative)
                if (auto memRead = dyn_cast<helix::low::MemReadOp>(op)) {
                    Value addr = memRead.getAddr();
                    // Skip stack accesses — already handled in Phase 3
                    if (tryDecodeStackOffset(addr))
                        return;
                    // Check for direct constant address
                    auto constAddr = tryExtractConstantInt(addr);
                    if (!constAddr)
                        return;
                    MemAccessInfo info;
                    info.op = op;
                    info.bitWidth = memRead.getBitWidth();
                    info.isStore = false;
                    info.accessedValue = memRead.getResult();
                    globalAccesses[static_cast<uint64_t>(*constAddr)]
                        .push_back(info);
                    return;
                }

                // MemWriteOp at a constant address
                if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
                    Value addr = memWrite.getAddr();
                    if (tryDecodeStackOffset(addr))
                        return;
                    auto constAddr = tryExtractConstantInt(addr);
                    if (!constAddr)
                        return;
                    MemAccessInfo info;
                    info.op = op;
                    info.bitWidth = memWrite.getBitWidth();
                    info.isStore = true;
                    info.accessedValue = memWrite.getValue();
                    globalAccesses[static_cast<uint64_t>(*constAddr)]
                        .push_back(info);
                    return;
                }
            });

            // For each global address, infer type from access patterns.
            // Only apply when all accesses agree on the type (consistent width).
            for (auto& [addr, accesses] : globalAccesses) {
                // Verify consistent access width — if widths differ, skip
                // (could be a union or type-punned access).
                unsigned commonWidth = accesses[0].bitWidth;
                bool consistent = true;
                for (size_t i = 1; i < accesses.size(); ++i) {
                    if (accesses[i].bitWidth != commonWidth) {
                        consistent = false;
                        break;
                    }
                }
                if (!consistent)
                    continue;

                CTypeInfo inferredType = inferSlotType(accesses, typeEnv);
                if (!inferredType.isResolved())
                    continue;

                for (auto& acc : accesses) {
                    if (isTypeLocked(acc.accessedValue, lockedValues))
                        continue;
                    typeEnv[acc.accessedValue].mergeFrom(inferredType);
                }
            }
        }

        // ─── Phase 5: Re-propagation with refined types ──────────────────────
        //
        // Run forward + backward loops again with reduced iterations to catch
        // cascading inference: stack var type → expression type → another var.
        // The typeEnv already contains refined types from Phases 3-4, so this
        // pass propagates them through the existing rules.

        // Re-propagation: forward pass (reduced iterations)
        for (unsigned iter = 0; iter < kRePropIterations; iter++) {
            bool changed = false;

            func.walk([&](Operation* op) {
                // Re-propagate register reads
                if (auto regRead = dyn_cast<helix::low::RegReadOp>(op)) {
                    auto result = regRead.getResult();
                    if (!isTypeLocked(result, lockedValues)) {
                        CTypeInfo inferred =
                            CTypeInfo::makeIntUnknownSign(regRead.getBitWidth());
                        if (typeEnv[result].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Re-propagate memory reads
                if (auto memRead = dyn_cast<helix::low::MemReadOp>(op)) {
                    auto result = memRead.getResult();
                    if (!isTypeLocked(result, lockedValues)) {
                        CTypeInfo inferred =
                            CTypeInfo::makeIntUnknownSign(memRead.getBitWidth());
                        if (typeEnv[result].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Re-propagate binary ops with refined operand types
                if (auto binop = dyn_cast<helix::low::BinOp>(op)) {
                    auto result = binop.getResult();
                    auto lhsType = typeEnv[binop.getLhs()];
                    auto rhsType = typeEnv[binop.getRhs()];

                    CTypeInfo inferred;
                    if (lhsType.kind == CTypeInfo::Pointer ||
                        rhsType.kind == CTypeInfo::Pointer) {
                        inferred = CTypeInfo::makePointer();
                    } else if (lhsType.isResolved()) {
                        inferred = lhsType;
                    } else if (rhsType.isResolved()) {
                        inferred = rhsType;
                    }

                    if (inferred.isResolved() &&
                        !isTypeLocked(result, lockedValues)) {
                        if (typeEnv[result].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Re-propagate MOVZX/MOVSX with refined source types
                if (auto movzx = dyn_cast<helix::low::MovZxOp>(op)) {
                    if (!isTypeLocked(movzx.getResult(), lockedValues)) {
                        CTypeInfo dstInferred =
                            CTypeInfo::makeInt(movzx.getDstWidth(), false);
                        if (typeEnv[movzx.getResult()].mergeFrom(dstInferred))
                            changed = true;
                    }
                    return;
                }
                if (auto movsx = dyn_cast<helix::low::MovSxOp>(op)) {
                    if (!isTypeLocked(movsx.getResult(), lockedValues)) {
                        CTypeInfo dstInferred =
                            CTypeInfo::makeInt(movsx.getDstWidth(), true);
                        if (typeEnv[movsx.getResult()].mergeFrom(dstInferred))
                            changed = true;
                    }
                    return;
                }
            });

            if (!changed)
                break;
        }

        // Re-propagation: backward pass (reduced iterations)
        for (unsigned backIter = 0; backIter < kRePropIterations; backIter++) {
            bool changed = false;

            func.walk([&](Operation* op) {
                // CMP backward with refined types
                if (auto cmp = dyn_cast<helix::low::CmpOp>(op)) {
                    auto lhsType = typeEnv[cmp.getLhs()];
                    auto rhsType = typeEnv[cmp.getRhs()];
                    if (lhsType.isResolved() && !rhsType.isResolved() &&
                        !isTypeLocked(cmp.getRhs(), lockedValues)) {
                        if (typeEnv[cmp.getRhs()].mergeFrom(lhsType))
                            changed = true;
                    } else if (rhsType.isResolved() && !lhsType.isResolved() &&
                               !isTypeLocked(cmp.getLhs(), lockedValues)) {
                        if (typeEnv[cmp.getLhs()].mergeFrom(rhsType))
                            changed = true;
                    }
                    return;
                }

                // BinOp backward with refined types
                if (auto binop = dyn_cast<helix::low::BinOp>(op)) {
                    auto resultType = typeEnv[binop.getResult()];
                    if (resultType.isResolved() &&
                        resultType.kind != CTypeInfo::Pointer) {
                        if (!isTypeLocked(binop.getLhs(), lockedValues))
                            if (typeEnv[binop.getLhs()].mergeFrom(resultType))
                                changed = true;
                        if (!isTypeLocked(binop.getRhs(), lockedValues))
                            if (typeEnv[binop.getRhs()].mergeFrom(resultType))
                                changed = true;
                    }
                    return;
                }

                // MemWrite backward with refined types
                if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
                    Value storedValue = memWrite.getValue();
                    auto valueType = typeEnv[storedValue];

                    if (!isTypeLocked(memWrite.getAddr(), lockedValues)) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (typeEnv[memWrite.getAddr()].mergeFrom(ptrType))
                            changed = true;
                    }

                    if (!valueType.isResolved() &&
                        !isTypeLocked(storedValue, lockedValues)) {
                        CTypeInfo inferred =
                            CTypeInfo::makeIntUnknownSign(
                                memWrite.getBitWidth());
                        if (typeEnv[storedValue].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // MOVSX/MOVZX backward with refined types
                if (auto movsx = dyn_cast<helix::low::MovSxOp>(op)) {
                    if (!isTypeLocked(movsx.getSrc(), lockedValues)) {
                        unsigned srcWidth =
                            movsx.getSrc().getType().getIntOrFloatBitWidth();
                        CTypeInfo srcInferred =
                            CTypeInfo::makeInt(srcWidth, true);
                        if (typeEnv[movsx.getSrc()].mergeFrom(srcInferred))
                            changed = true;
                    }
                    return;
                }
                if (auto movzx = dyn_cast<helix::low::MovZxOp>(op)) {
                    if (!isTypeLocked(movzx.getSrc(), lockedValues)) {
                        unsigned srcWidth =
                            movzx.getSrc().getType().getIntOrFloatBitWidth();
                        CTypeInfo srcInferred =
                            CTypeInfo::makeInt(srcWidth, false);
                        if (typeEnv[movzx.getSrc()].mergeFrom(srcInferred))
                            changed = true;
                    }
                    return;
                }
            });

            if (!changed)
                break;
        }

        // Store the resolved types as attributes on the operations.
        // FIX (non-determinism): typeEnv is a DenseMap<Value,...>, iterated in
        // POINTER-ADDRESS order, which varies per decompile (each call allocates
        // ops at fresh addresses). Multiple results of one op (a helix.low.BinOp's
        // value + its carry/zero/sign flags) share ONE defining op, so writing
        // inferred_type per Value made the last-write "winner" non-deterministic
        // (the observed inferred_type=bool vs int64 flip). Choose a deterministic
        // winner per op -- the resolved result with the LOWEST result number (the
        // op's primary value) -- and write once per op. Inter-op write order is
        // irrelevant since each entry targets a distinct op.
        unsigned numTypesSet = 0;
        unsigned numBlockArgs = 0;
        unsigned numPtrTypes = 0;
        llvm::DenseMap<Operation*, std::pair<unsigned, CTypeInfo>> chosenType;
        for (auto& [val, typeInfo] : typeEnv) {
            if (!typeInfo.isResolved())
                continue;

            auto* defOp = val.getDefiningOp();
            if (!defOp) {
                ++numBlockArgs;
                continue;
            }

            unsigned rn = 0;
            if (auto res = mlir::dyn_cast<mlir::OpResult>(val))
                rn = res.getResultNumber();
            auto it = chosenType.find(defOp);
            if (it == chosenType.end())
                chosenType.insert({defOp, {rn, typeInfo}});
            else if (rn < it->second.first)
                it->second = {rn, typeInfo};
        }
        for (auto& [defOp, rt] : chosenType) {
            std::string typeStr = rt.second.toCTypeString();
            if (typeStr.empty())
                continue;
            defOp->setAttr("inferred_type",
                StringAttr::get(defOp->getContext(), typeStr));
            ++numTypesSet;
            if (rt.second.kind == CTypeInfo::Pointer)
                ++numPtrTypes;
        }
        LLVM_DEBUG(llvm::dbgs()
            << "  PropagateTypes: " << numTypesSet << " types ("
            << numPtrTypes << " ptrs)\n");
    }

    /// Propagate types through HelixHigh operations (var.decl, assign, call).
    /// This handles the higher-level IR after stack recovery and variable
    /// recovery have introduced typed variable declarations and assignments.
    template <typename FuncOpT>
    void propagateTypesHigh(FuncOpT func) {
        // VarTypes: maps variable IDs to their inferred C type.
        VarTypeMap varTypes;
        // TypeEnv: maps SSA Values to their inferred C type.
        llvm::DenseMap<Value, CTypeInfo> typeEnv;

        // A recovered variable can still represent several machine-register
        // definitions. Authoritative nominal types (DWARF/BTF/PDB struct
        // pointers) may cross a direct copy only when the destination is a
        // single-definition local. Otherwise one debug-typed parameter can
        // contaminate every later value held in the same physical register.
        llvm::DenseMap<uint32_t, unsigned> assignmentCounts;
        llvm::DenseMap<uint32_t, helix::high::StorageKind> storageKinds;
        func.walk([&](helix::high::VarDeclOp decl) {
            storageKinds[decl.getVarId()] = decl.getStorage();
        });
        func.walk([&](helix::high::AssignOp assign) {
            auto target = assign.getTarget()
                .template getDefiningOp<helix::high::VarRefOp>();
            if (target)
                ++assignmentCounts[target.getVarId()];
        });
        auto isAuthoritativeNominalPointer = [](const CTypeInfo& type) {
            return type.kind == CTypeInfo::Pointer && type.pointee &&
                   type.pointee->kind == CTypeInfo::Struct &&
                   !llvm::StringRef(type.pointee->struct_name)
                        .starts_with("auto_struct_");
        };
        auto canCarryAssignedType = [&](uint32_t varId,
                                        const CTypeInfo& type) {
            if (!isAuthoritativeNominalPointer(type))
                return true;
            auto storage = storageKinds.find(varId);
            if (storage == storageKinds.end() ||
                storage->second == helix::high::StorageKind::Parameter)
                return false;
            return assignmentCounts.lookup(varId) == 1;
        };

        // ─── Type-lock pre-scan (HelixHigh) ─────────────────────────────────
        //
        // Two sources of locked types:
        //   1. Any op with "helix.type_hint" → lock its SSA results and,
        //      for VarDeclOp, also lock the varId in varTypes.
        //   2. SignatureDb parameters — if the function's name is known,
        //      pre-seed and lock VarDeclOps with StorageKind::Parameter in
        //      declaration order against the signature's param_types.
        llvm::DenseSet<Value>    lockedValues;
        llvm::DenseSet<uint32_t> lockedVarIds;

        // Pass 1: helix.type_hint on any op.
        func.walk([&](Operation* op) {
            auto hint = op->getAttrOfType<StringAttr>("helix.type_hint");
            if (!hint)
                return;
            CTypeInfo hintType = typeFromSignatureStr(hint.getValue());
            if (!hintType.isResolved())
                return;
            for (Value result : op->getResults()) {
                typeEnv[result] = hintType;
                lockedValues.insert(result);
            }
            if (auto decl = dyn_cast<helix::high::VarDeclOp>(op)) {
                uint32_t varId = decl.getVarId();
                varTypes[varId] = hintType;
                lockedVarIds.insert(varId);
            }
        });

        // Pass 2: SignatureDb parameter locking.
        {
            auto funcName = func.getSymName();
            auto sig = helix::lookupSignature(funcName);
            if (sig && !sig->param_types.empty()) {
                llvm::SmallVector<helix::high::VarDeclOp, 8> paramDecls;
                func.walk([&](helix::high::VarDeclOp decl) {
                    if (decl.getStorage() ==
                            helix::high::StorageKind::Parameter)
                        paramDecls.push_back(decl);
                });
                for (unsigned i = 0;
                     i < paramDecls.size() && i < sig->param_types.size();
                     ++i) {
                    uint32_t varId = paramDecls[i].getVarId();
                    if (lockedVarIds.count(varId))
                        continue; // user annotation takes priority
                    CTypeInfo paramType =
                        typeFromSignatureStr(sig->param_types[i]);
                    if (paramType.isResolved()) {
                        varTypes[varId] = paramType;
                        lockedVarIds.insert(varId);
                    }
                }
            }
        }

        // Seed var types from existing inferred_type attributes on var.decl ops.
        // Skipped for locked varIds.
        func.walk([&](helix::high::VarDeclOp decl) {
            uint32_t varId = decl.getVarId();
            if (lockedVarIds.count(varId))
                return;
            if (auto existingType = decl->getAttrOfType<StringAttr>("inferred_type")) {
                CTypeInfo t = typeFromSignatureStr(existingType.getValue());
                if (t.isResolved())
                    varTypes[varId].mergeFrom(t);
            }

            // Seed pointer-to-struct type from struct recovery attributes.
            // RecoverStructTypes annotates var.decl ops with helix.struct_name
            // when the variable is a base pointer to a recovered struct layout.
            // This bridges struct recovery → type propagation so that field
            // accesses through this variable inherit the struct type context.
            if (auto structName = decl->getAttrOfType<StringAttr>("helix.struct_name")) {
                CTypeInfo structType;
                structType.kind = CTypeInfo::Struct;
                structType.struct_name = structName.getValue().str();
                // The variable is a pointer to this struct.
                CTypeInfo ptrToStruct = CTypeInfo::makePointer(structType);
                varTypes[varId].mergeFrom(ptrToStruct);
            }

            // If the decl has an initializer, seed from its type.
            if (decl.getInit()) {
                Value initVal = decl.getInit();
                unsigned bitWidth = 0;
                if (auto intTy = dyn_cast<IntegerType>(initVal.getType()))
                    bitWidth = intTy.getWidth();
                if (bitWidth > 0) {
                    CTypeInfo inferred = CTypeInfo::makeIntUnknownSign(bitWidth);
                    varTypes[varId].mergeFrom(inferred);
                }
            }
        });

        // Iterate until fixed point.
        for (unsigned iter = 0; iter < kMaxIterations; iter++) {
            bool changed = false;

            func.walk([&](Operation* op) {
                // Rule H1: var.decl — propagate type from initializer to variable.
                if (auto decl = dyn_cast<helix::high::VarDeclOp>(op)) {
                    uint32_t varId = decl.getVarId();
                    if (!lockedVarIds.count(varId) && decl.getInit()) {
                        Value initVal = decl.getInit();
                        auto initType = typeEnv[initVal];
                        if (initType.isResolved()) {
                            if (varTypes[varId].mergeFrom(initType))
                                changed = true;
                        }
                    }
                    return;
                }

                // Rule H2: assign — bidirectional type propagation.
                // If the value has a known type, the target variable inherits it.
                // If the target variable has a known type, the value inherits it.
                if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
                    Value target = assign.getTarget();
                    Value value = assign.getValue();

                    auto valueType = typeEnv[value];
                    auto targetType = typeEnv[target];
                    auto targetRef =
                        target.getDefiningOp<helix::high::VarRefOp>();
                    const bool targetAcceptsValue =
                        !targetRef ||
                        canCarryAssignedType(targetRef.getVarId(), valueType);

                    // Forward: value type → target
                    if (valueType.isResolved() && !targetType.isResolved() &&
                            targetAcceptsValue &&
                            !isTypeLocked(target, lockedValues)) {
                        if (typeEnv[target].mergeFrom(valueType))
                            changed = true;
                    }
                    // Backward: target type → value
                    if (targetType.isResolved() && !valueType.isResolved() &&
                            (!targetRef ||
                             canCarryAssignedType(targetRef.getVarId(),
                                                  targetType)) &&
                            !isTypeLocked(value, lockedValues)) {
                        if (typeEnv[value].mergeFrom(targetType))
                            changed = true;
                    }

                    // Also propagate to/from the variable type map via var.ref
                    if (auto varRef = targetRef) {
                        uint32_t varId = varRef.getVarId();
                        if (valueType.isResolved() &&
                                canCarryAssignedType(varId, valueType) &&
                                !lockedVarIds.count(varId)) {
                            if (varTypes[varId].mergeFrom(valueType))
                                changed = true;
                        }
                        // Backward: variable type → value
                        auto varType = varTypes[varId];
                        if (varType.isResolved() &&
                                canCarryAssignedType(varId, varType) &&
                                !isTypeLocked(value, lockedValues)) {
                            if (typeEnv[value].mergeFrom(varType))
                                changed = true;
                        }
                    }
                    return;
                }

                // Rule H3: var.ref — propagate variable type to the ref result.
                if (auto varRef = dyn_cast<helix::high::VarRefOp>(op)) {
                    uint32_t varId = varRef.getVarId();
                    auto varType = varTypes[varId];
                    if (varType.isResolved() &&
                            !isTypeLocked(varRef.getResult(), lockedValues)) {
                        if (typeEnv[varRef.getResult()].mergeFrom(varType))
                            changed = true;
                    }
                    return;
                }

                // Rule H4: call — propagate return type from SignatureDb.
                if (auto call = dyn_cast<helix::high::CallOp>(op)) {
                    auto targetName = call.getTargetName();
                    auto sig = helix::lookupSignature(targetName);
                    if (sig) {
                        CTypeInfo retType = typeFromSignatureStr(sig->return_type);
                        if (retType.isResolved() && call.getResult() &&
                                !isTypeLocked(call.getResult(), lockedValues)) {
                            if (typeEnv[call.getResult()].mergeFrom(retType))
                                changed = true;
                        }
                        // Propagate parameter types to call arguments.
                        for (unsigned i = 0; i < call.getArgs().size() &&
                                            i < sig->param_types.size(); i++) {
                            CTypeInfo paramType = typeFromSignatureStr(
                                sig->param_types[i]);
                            if (paramType.isResolved() &&
                                    !isTypeLocked(call.getArgs()[i],
                                                  lockedValues)) {
                                if (typeEnv[call.getArgs()[i]].mergeFrom(
                                        paramType))
                                    changed = true;
                            }
                        }
                    }
                    return;
                }

                // Rule H5: binary — propagate types through binary expressions.
                // Also propagate signedness from Sar (signed) and Shr (unsigned).
                if (auto binop = dyn_cast<helix::high::BinaryOp>(op)) {
                    auto opKind = binop.getOp();
                    auto lhsType = typeEnv[binop.getLhs()];
                    auto rhsType = typeEnv[binop.getRhs()];

                    CTypeInfo inferred;
                    // Pointer arithmetic propagation
                    if (lhsType.kind == CTypeInfo::Pointer ||
                        rhsType.kind == CTypeInfo::Pointer) {
                        inferred = CTypeInfo::makePointer();
                    } else if (lhsType.isResolved()) {
                        inferred = lhsType;
                    } else if (rhsType.isResolved()) {
                        inferred = rhsType;
                    }

                    if (inferred.isResolved() &&
                            !isTypeLocked(binop.getResult(), lockedValues)) {
                        if (typeEnv[binop.getResult()].mergeFrom(inferred))
                            changed = true;
                    }

                    // Sar (arithmetic shift right) implies the LHS is signed.
                    if (opKind == helix::high::BinaryOpKind::Sar) {
                        if (!isTypeLocked(binop.getLhs(), lockedValues) &&
                                typeEnv[binop.getLhs()].applySignedness(
                                    Signedness::Signed))
                            changed = true;
                        if (!isTypeLocked(binop.getResult(), lockedValues) &&
                                typeEnv[binop.getResult()].applySignedness(
                                    Signedness::Signed))
                            changed = true;
                    }

                    // Shr (logical shift right) implies the LHS is unsigned.
                    if (opKind == helix::high::BinaryOpKind::Shr) {
                        if (!isTypeLocked(binop.getLhs(), lockedValues) &&
                                typeEnv[binop.getLhs()].applySignedness(
                                    Signedness::Unsigned))
                            changed = true;
                        if (!isTypeLocked(binop.getResult(), lockedValues) &&
                                typeEnv[binop.getResult()].applySignedness(
                                    Signedness::Unsigned))
                            changed = true;
                    }

                    return;
                }

                // Rule H6: cast — propagate type through cast ops.
                if (auto cast = dyn_cast<helix::high::CastOp>(op)) {
                    unsigned resultWidth = 0;
                    if (auto intTy = dyn_cast<IntegerType>(cast.getResult().getType()))
                        resultWidth = intTy.getWidth();
                    if (resultWidth > 0 &&
                            !isTypeLocked(cast.getResult(), lockedValues)) {
                        // Preserve signedness from input if known
                        auto inputType = typeEnv[cast.getInput()];
                        bool isSigned = inputType.isResolved()
                                            ? inputType.is_signed
                                            : false;
                        CTypeInfo inferred = CTypeInfo::makeInt(resultWidth,
                                                                isSigned);
                        if (typeEnv[cast.getResult()].mergeFrom(inferred))
                            changed = true;
                    }
                    return;
                }

                // Rule H7: Parameter usage inference — if a variable is used
                // as an operand in a pointer operation (deref, address-of),
                // infer it as void*.
                if (auto unary = dyn_cast<helix::high::UnaryOp>(op)) {
                    auto opKind = unary.getOp();
                    if (opKind == helix::high::UnaryOpKind::Deref ||
                        opKind == helix::high::UnaryOpKind::AddressOf) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (opKind == helix::high::UnaryOpKind::Deref) {
                            // The operand being dereferenced must be a pointer
                            if (!isTypeLocked(unary.getOperand(), lockedValues) &&
                                    typeEnv[unary.getOperand()].mergeFrom(ptrType))
                                changed = true;
                        } else {
                            // AddressOf produces a pointer
                            if (!isTypeLocked(unary.getResult(), lockedValues) &&
                                    typeEnv[unary.getResult()].mergeFrom(ptrType))
                                changed = true;
                        }
                    }
                    return;
                }

                // ─── New HelixHigh forward rules (Ghidra TypeOp-inspired) ──

                // Rule H8: FieldAccessOp — base must be a pointer (it's
                // a struct access via ptr->field). Infer field type from
                // how the result is used: if stored to, from the stored
                // value; if loaded, from the load width.
                if (auto field = dyn_cast<helix::high::FieldAccessOp>(op)) {
                    // The base of a field access is always a pointer.
                    if (!isTypeLocked(field.getBase(), lockedValues)) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (typeEnv[field.getBase()].mergeFrom(ptrType))
                            changed = true;
                    }
                    // Propagate base variable as pointer in varTypes.
                    if (auto varRef = field.getBase()
                                          .getDefiningOp<
                                              helix::high::VarRefOp>()) {
                        uint32_t varId = varRef.getVarId();
                        if (!lockedVarIds.count(varId)) {
                            CTypeInfo ptrType = CTypeInfo::makePointer();
                            if (varTypes[varId].mergeFrom(ptrType))
                                changed = true;
                        }
                    }
                    // If the field result has a known integer width from
                    // its SSA type, use that for the field type.
                    if (!isTypeLocked(field.getResult(), lockedValues)) {
                        unsigned fieldWidth = 0;
                        if (auto intTy = dyn_cast<IntegerType>(
                                field.getResult().getType()))
                            fieldWidth = intTy.getWidth();
                        if (fieldWidth > 0) {
                            CTypeInfo fieldType =
                                CTypeInfo::makeIntUnknownSign(fieldWidth);
                            if (typeEnv[field.getResult()].mergeFrom(
                                    fieldType))
                                changed = true;
                        }
                    }
                    return;
                }

                // Rule H9: SubscriptOp (array index) — base should be a
                // pointer, index should be an integer. The result type
                // is the element type (pointee of base).
                if (auto subscript =
                        dyn_cast<helix::high::SubscriptOp>(op)) {
                    // Base is a pointer.
                    if (!isTypeLocked(subscript.getBase(), lockedValues)) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (typeEnv[subscript.getBase()].mergeFrom(ptrType))
                            changed = true;
                    }
                    // Propagate base as pointer to variable type map.
                    if (auto varRef = subscript.getBase()
                                          .getDefiningOp<
                                              helix::high::VarRefOp>()) {
                        uint32_t varId = varRef.getVarId();
                        if (!lockedVarIds.count(varId)) {
                            CTypeInfo ptrType = CTypeInfo::makePointer();
                            if (varTypes[varId].mergeFrom(ptrType))
                                changed = true;
                        }
                    }
                    // Index is an unsigned integer (array subscript).
                    if (!isTypeLocked(subscript.getIndex(), lockedValues)) {
                        unsigned idxWidth = 0;
                        if (auto intTy = dyn_cast<IntegerType>(
                                subscript.getIndex().getType()))
                            idxWidth = intTy.getWidth();
                        if (idxWidth > 0) {
                            CTypeInfo idxType =
                                CTypeInfo::makeInt(idxWidth,
                                                   /*signed=*/false);
                            if (typeEnv[subscript.getIndex()].mergeFrom(
                                    idxType))
                                changed = true;
                        }
                    }
                    // Result type from SSA width.
                    if (!isTypeLocked(subscript.getResult(), lockedValues)) {
                        unsigned elemWidth = 0;
                        if (auto intTy = dyn_cast<IntegerType>(
                                subscript.getResult().getType()))
                            elemWidth = intTy.getWidth();
                        if (elemWidth > 0) {
                            CTypeInfo elemType =
                                CTypeInfo::makeIntUnknownSign(elemWidth);
                            if (typeEnv[subscript.getResult()].mergeFrom(
                                    elemType))
                                changed = true;
                        }
                    }
                    return;
                }

                // Rule H10: TernaryOp (conditional select) — result type
                // should be the common type of true/false values.
                if (auto ternary = dyn_cast<helix::high::TernaryOp>(op)) {
                    auto trueType = typeEnv[ternary.getTrueVal()];
                    auto falseType = typeEnv[ternary.getFalseVal()];

                    CTypeInfo inferred;
                    if (trueType.isResolved())
                        inferred = trueType;
                    else if (falseType.isResolved())
                        inferred = falseType;

                    if (inferred.isResolved() &&
                        !isTypeLocked(ternary.getResult(), lockedValues)) {
                        if (typeEnv[ternary.getResult()].mergeFrom(inferred))
                            changed = true;
                    }

                    // Also propagate backward: if result is typed, push
                    // to both arms.
                    auto resultType = typeEnv[ternary.getResult()];
                    if (resultType.isResolved()) {
                        if (!isTypeLocked(ternary.getTrueVal(),
                                          lockedValues) &&
                            typeEnv[ternary.getTrueVal()].mergeFrom(
                                resultType))
                            changed = true;
                        if (!isTypeLocked(ternary.getFalseVal(),
                                          lockedValues) &&
                            typeEnv[ternary.getFalseVal()].mergeFrom(
                                resultType))
                            changed = true;
                    }
                    return;
                }

                // Rule H11: IntLitOp — integer literals carry their width
                // from the SSA type. Large values (> 0x7FFFFFFF for 32-bit)
                // are likely unsigned.
                if (auto intLit = dyn_cast<helix::high::IntLitOp>(op)) {
                    if (!isTypeLocked(intLit.getResult(), lockedValues)) {
                        unsigned litWidth = 0;
                        if (auto intTy = dyn_cast<IntegerType>(
                                intLit.getResult().getType()))
                            litWidth = intTy.getWidth();
                        if (litWidth > 0) {
                            int64_t val = intLit.getValue();
                            // Values that don't fit in the signed range for
                            // their width are likely unsigned.
                            bool likelyUnsigned = (val < 0);
                            if (litWidth == 32 && val > 0x7FFFFFFF)
                                likelyUnsigned = true;
                            if (litWidth == 16 && val > 0x7FFF)
                                likelyUnsigned = true;
                            if (litWidth == 8 && val > 0x7F)
                                likelyUnsigned = true;

                            CTypeInfo litType =
                                likelyUnsigned
                                    ? CTypeInfo::makeInt(litWidth,
                                                         /*signed=*/false)
                                    : CTypeInfo::makeIntUnknownSign(litWidth);
                            if (typeEnv[intLit.getResult()].mergeFrom(
                                    litType))
                                changed = true;
                        }
                    }
                    return;
                }

                // Rule H12: AddrLitOp — address literals are pointers.
                if (auto addrLit = dyn_cast<helix::high::AddrLitOp>(op)) {
                    if (!isTypeLocked(addrLit.getResult(), lockedValues)) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (typeEnv[addrLit.getResult()].mergeFrom(ptrType))
                            changed = true;
                    }
                    return;
                }
            });

            // Fixed point reached — no more changes.
            if (!changed)
                break;
        }

        // ─── Phase 2: Backward propagation (use→def) for HelixHigh ──────────
        //
        // Walk operations and propagate type constraints from uses back to
        // definitions. This catches cases the forward pass missed because the
        // type information only becomes available from the consumer side.
        for (unsigned backIter = 0; backIter < kMaxIterations; backIter++) {
            bool changed = false;

            func.walk([&](Operation* op) {
                // Backward Rule HB1: BinaryOp comparison — for comparison
                // operators (Eq, Ne, Lt, Le, Gt, Ge), both operands should have
                // the same type. If one is known, propagate to the other.
                // Additionally, Lt/Le/Gt/Ge imply signed comparisons in
                // HelixHigh (the unsigned variants are expressed differently),
                // so propagate Signed to both operands.
                if (auto binop = dyn_cast<helix::high::BinaryOp>(op)) {
                    auto opKind = binop.getOp();
                    if (opKind == helix::high::BinaryOpKind::Eq ||
                        opKind == helix::high::BinaryOpKind::Ne ||
                        opKind == helix::high::BinaryOpKind::Lt ||
                        opKind == helix::high::BinaryOpKind::Le ||
                        opKind == helix::high::BinaryOpKind::Gt ||
                        opKind == helix::high::BinaryOpKind::Ge) {
                        auto lhsType = typeEnv[binop.getLhs()];
                        auto rhsType = typeEnv[binop.getRhs()];
                        if (lhsType.isResolved() && !rhsType.isResolved() &&
                                !isTypeLocked(binop.getRhs(), lockedValues)) {
                            if (typeEnv[binop.getRhs()].mergeFrom(lhsType))
                                changed = true;
                        } else if (rhsType.isResolved() &&
                                   !lhsType.isResolved() &&
                                   !isTypeLocked(binop.getLhs(),
                                                 lockedValues)) {
                            if (typeEnv[binop.getLhs()].mergeFrom(rhsType))
                                changed = true;
                        }

                        // Lt/Le/Gt/Ge are signed comparisons in HelixHigh.
                        // (HelixHigh doesn't have separate ULt/ULe/UGt/UGe
                        // enums — these originate from signed JccOp conditions.)
                        if (opKind == helix::high::BinaryOpKind::Lt ||
                            opKind == helix::high::BinaryOpKind::Le ||
                            opKind == helix::high::BinaryOpKind::Gt ||
                            opKind == helix::high::BinaryOpKind::Ge) {
                            if (!isTypeLocked(binop.getLhs(), lockedValues) &&
                                    typeEnv[binop.getLhs()].applySignedness(
                                        Signedness::Signed))
                                changed = true;
                            if (!isTypeLocked(binop.getRhs(), lockedValues) &&
                                    typeEnv[binop.getRhs()].applySignedness(
                                        Signedness::Signed))
                                changed = true;
                        }
                    }

                    // For arithmetic ops: if the result type is known,
                    // propagate back to operands.
                    if (opKind == helix::high::BinaryOpKind::Add ||
                        opKind == helix::high::BinaryOpKind::Sub ||
                        opKind == helix::high::BinaryOpKind::Mul ||
                        opKind == helix::high::BinaryOpKind::BitAnd ||
                        opKind == helix::high::BinaryOpKind::BitOr ||
                        opKind == helix::high::BinaryOpKind::BitXor) {
                        auto resultType = typeEnv[binop.getResult()];
                        if (resultType.isResolved() &&
                            resultType.kind != CTypeInfo::Pointer) {
                            if (!isTypeLocked(binop.getLhs(), lockedValues) &&
                                    typeEnv[binop.getLhs()].mergeFrom(
                                        resultType))
                                changed = true;
                            if (!isTypeLocked(binop.getRhs(), lockedValues) &&
                                    typeEnv[binop.getRhs()].mergeFrom(
                                        resultType))
                                changed = true;
                        }
                    }

                    // Sar/Shr backward: signedness flows back to operands.
                    if (opKind == helix::high::BinaryOpKind::Sar) {
                        if (!isTypeLocked(binop.getLhs(), lockedValues) &&
                                typeEnv[binop.getLhs()].applySignedness(
                                    Signedness::Signed))
                            changed = true;
                        if (!isTypeLocked(binop.getResult(), lockedValues) &&
                                typeEnv[binop.getResult()].applySignedness(
                                    Signedness::Signed))
                            changed = true;
                    }
                    if (opKind == helix::high::BinaryOpKind::Shr) {
                        if (!isTypeLocked(binop.getLhs(), lockedValues) &&
                                typeEnv[binop.getLhs()].applySignedness(
                                    Signedness::Unsigned))
                            changed = true;
                        if (!isTypeLocked(binop.getResult(), lockedValues) &&
                                typeEnv[binop.getResult()].applySignedness(
                                    Signedness::Unsigned))
                            changed = true;
                    }

                    // Backward Rule HB8 (integrated): Shift amount — RHS
                    // of Shl/Shr/Sar is always an unsigned integer.
                    if (opKind == helix::high::BinaryOpKind::Shl ||
                        opKind == helix::high::BinaryOpKind::Shr ||
                        opKind == helix::high::BinaryOpKind::Sar) {
                        if (!isTypeLocked(binop.getRhs(), lockedValues)) {
                            unsigned rhsWidth = 0;
                            if (auto intTy = dyn_cast<IntegerType>(
                                    binop.getRhs().getType()))
                                rhsWidth = intTy.getWidth();
                            if (rhsWidth > 0) {
                                CTypeInfo shiftAmt =
                                    CTypeInfo::makeInt(rhsWidth,
                                                       /*signed=*/false);
                                if (typeEnv[binop.getRhs()].mergeFrom(
                                        shiftAmt))
                                    changed = true;
                            }
                        }
                        // Also propagate to variable type map.
                        if (auto varRef = binop.getRhs()
                                              .getDefiningOp<
                                                  helix::high::VarRefOp>()) {
                            uint32_t varId = varRef.getVarId();
                            if (!lockedVarIds.count(varId)) {
                                unsigned rhsWidth = 0;
                                if (auto intTy = dyn_cast<IntegerType>(
                                        binop.getRhs().getType()))
                                    rhsWidth = intTy.getWidth();
                                if (rhsWidth > 0) {
                                    CTypeInfo shiftAmt =
                                        CTypeInfo::makeInt(
                                            rhsWidth, /*signed=*/false);
                                    if (varTypes[varId].mergeFrom(shiftAmt))
                                        changed = true;
                                }
                            }
                        }
                    }

                    // Backward Rule HB9 (integrated): BitAnd/BitOr/BitXor
                    // — both operands should have the same width.
                    if (opKind == helix::high::BinaryOpKind::BitAnd ||
                        opKind == helix::high::BinaryOpKind::BitOr ||
                        opKind == helix::high::BinaryOpKind::BitXor) {
                        auto lhsType = typeEnv[binop.getLhs()];
                        auto rhsType = typeEnv[binop.getRhs()];
                        if (lhsType.isResolved() &&
                            !rhsType.isResolved() &&
                            !isTypeLocked(binop.getRhs(), lockedValues)) {
                            CTypeInfo widthOnly =
                                CTypeInfo::makeIntUnknownSign(
                                    lhsType.bit_width);
                            if (typeEnv[binop.getRhs()].mergeFrom(widthOnly))
                                changed = true;
                        } else if (rhsType.isResolved() &&
                                   !lhsType.isResolved() &&
                                   !isTypeLocked(binop.getLhs(),
                                                 lockedValues)) {
                            CTypeInfo widthOnly =
                                CTypeInfo::makeIntUnknownSign(
                                    rhsType.bit_width);
                            if (typeEnv[binop.getLhs()].mergeFrom(widthOnly))
                                changed = true;
                        }
                    }

                    // Backward Rule HB10 (integrated): Div/Mod type — Div
                    // result has same type as dividend (LHS), Mod result
                    // has same type as divisor (RHS).
                    if (opKind == helix::high::BinaryOpKind::Div) {
                        auto lhsType = typeEnv[binop.getLhs()];
                        if (lhsType.isResolved() &&
                            !isTypeLocked(binop.getResult(), lockedValues)) {
                            if (typeEnv[binop.getResult()].mergeFrom(
                                    lhsType))
                                changed = true;
                        }
                        auto resultType = typeEnv[binop.getResult()];
                        if (resultType.isResolved() &&
                            !isTypeLocked(binop.getLhs(), lockedValues)) {
                            if (typeEnv[binop.getLhs()].mergeFrom(resultType))
                                changed = true;
                        }
                    }
                    if (opKind == helix::high::BinaryOpKind::Mod) {
                        auto rhsType = typeEnv[binop.getRhs()];
                        if (rhsType.isResolved() &&
                            !isTypeLocked(binop.getResult(), lockedValues)) {
                            if (typeEnv[binop.getResult()].mergeFrom(
                                    rhsType))
                                changed = true;
                        }
                        auto resultType = typeEnv[binop.getResult()];
                        if (resultType.isResolved() &&
                            !isTypeLocked(binop.getRhs(), lockedValues)) {
                            if (typeEnv[binop.getRhs()].mergeFrom(resultType))
                                changed = true;
                        }
                    }

                    return;
                }

                // Backward Rule HB2: Call argument — propagate known parameter
                // types back to the argument-producing definitions, and
                // propagate function return type to values that USE the call
                // result.
                if (auto call = dyn_cast<helix::high::CallOp>(op)) {
                    auto targetName = call.getTargetName();
                    auto sig = helix::lookupSignature(targetName);
                    if (sig) {
                        // Backward: parameter types → argument definitions
                        for (unsigned i = 0;
                             i < call.getArgs().size() &&
                             i < sig->param_types.size();
                             i++) {
                            CTypeInfo paramType =
                                typeFromSignatureStr(sig->param_types[i]);
                            if (paramType.isResolved()) {
                                if (!isTypeLocked(call.getArgs()[i],
                                                  lockedValues) &&
                                        typeEnv[call.getArgs()[i]].mergeFrom(
                                            paramType))
                                    changed = true;

                                // Also propagate to variable type map if the
                                // argument comes from a var.ref.
                                if (auto varRef =
                                        call.getArgs()[i]
                                            .getDefiningOp<
                                                helix::high::VarRefOp>()) {
                                    uint32_t varId = varRef.getVarId();
                                    if (!lockedVarIds.count(varId) &&
                                            varTypes[varId].mergeFrom(
                                                paramType))
                                        changed = true;
                                }
                            }
                        }

                        // Backward: if the return type is known and the call
                        // has a result, propagate to the result.
                        CTypeInfo retType =
                            typeFromSignatureStr(sig->return_type);
                        if (retType.isResolved() && call.getResult() &&
                                !isTypeLocked(call.getResult(), lockedValues)) {
                            if (typeEnv[call.getResult()].mergeFrom(retType))
                                changed = true;
                        }
                    }
                    return;
                }

                // Backward Rule HB3: Return — if the function has a known
                // return type (from SignatureDb or from an attribute), propagate
                // it to the returned value.
                if (auto ret = dyn_cast<helix::high::ReturnOp>(op)) {
                    if (ret.getValue()) {
                        Value retVal = ret.getValue();
                        // Check if the enclosing function has a known signature
                        auto funcName = func.getSymName();
                        auto sig = helix::lookupSignature(funcName);
                        if (sig) {
                            CTypeInfo retType =
                                typeFromSignatureStr(sig->return_type);
                            if (retType.isResolved() &&
                                    !isTypeLocked(retVal, lockedValues)) {
                                if (typeEnv[retVal].mergeFrom(retType))
                                    changed = true;

                                // Propagate to variable type map if returning
                                // a var.ref.
                                if (auto varRef =
                                        retVal.getDefiningOp<
                                            helix::high::VarRefOp>()) {
                                    uint32_t varId = varRef.getVarId();
                                    if (!lockedVarIds.count(varId) &&
                                            varTypes[varId].mergeFrom(retType))
                                        changed = true;
                                }
                            }
                        }

                        // Also check if the function has an "inferred_return_type"
                        // attribute set by an earlier pass.
                        if (!isTypeLocked(retVal, lockedValues)) {
                            if (auto retTypeAttr =
                                    func->getAttrOfType<StringAttr>(
                                        "inferred_return_type")) {
                                CTypeInfo retType =
                                    typeFromSignatureStr(retTypeAttr.getValue());
                                if (retType.isResolved()) {
                                    if (typeEnv[retVal].mergeFrom(retType))
                                        changed = true;
                                }
                            }
                        }
                    }
                    return;
                }

                // Backward Rule HB4: Assign — if the target variable has a
                // type (from earlier forward or backward rules), propagate it
                // back to the source value's definition.
                if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
                    Value target = assign.getTarget();
                    Value value = assign.getValue();

                    // If target is a var.ref, use the variable type map.
                    if (auto varRef =
                            target.getDefiningOp<helix::high::VarRefOp>()) {
                        uint32_t varId = varRef.getVarId();
                        auto varType = varTypes[varId];
                        if (varType.isResolved() &&
                                canCarryAssignedType(varId, varType) &&
                                !isTypeLocked(value, lockedValues)) {
                            if (typeEnv[value].mergeFrom(varType))
                                changed = true;
                        }
                    }

                    // If the assigned value type is known, propagate to target.
                    auto valueType = typeEnv[value];
                    auto targetType = typeEnv[target];
                    auto targetRef =
                        target.getDefiningOp<helix::high::VarRefOp>();
                    const bool targetAcceptsValue =
                        !targetRef ||
                        canCarryAssignedType(targetRef.getVarId(), valueType);
                    if (valueType.isResolved() && !targetType.isResolved() &&
                            targetAcceptsValue &&
                            !isTypeLocked(target, lockedValues)) {
                        if (typeEnv[target].mergeFrom(valueType))
                            changed = true;
                    }
                    if (targetType.isResolved() && !valueType.isResolved() &&
                            (!targetRef ||
                             canCarryAssignedType(targetRef.getVarId(),
                                                  targetType)) &&
                            !isTypeLocked(value, lockedValues)) {
                        if (typeEnv[value].mergeFrom(targetType))
                            changed = true;
                    }
                    return;
                }

                // Backward Rule HB5: CastOp — if the result type is known,
                // and the cast is a sign/zero extension, propagate signedness
                // back to the input.
                if (auto cast = dyn_cast<helix::high::CastOp>(op)) {
                    auto resultType = typeEnv[cast.getResult()];
                    auto inputType = typeEnv[cast.getInput()];
                    if (resultType.isResolved() && !inputType.isResolved() &&
                            !isTypeLocked(cast.getInput(), lockedValues)) {
                        unsigned inputWidth = 0;
                        if (auto intTy =
                                dyn_cast<IntegerType>(
                                    cast.getInput().getType()))
                            inputWidth = intTy.getWidth();
                        if (inputWidth > 0) {
                            CTypeInfo inferred = CTypeInfo::makeInt(
                                inputWidth, resultType.is_signed);
                            if (typeEnv[cast.getInput()].mergeFrom(inferred))
                                changed = true;
                        }
                    }
                    // Also propagate signedness from result back to input
                    // even when both are resolved.
                    if (resultType.signedness != Signedness::Unknown &&
                            !isTypeLocked(cast.getInput(), lockedValues)) {
                        if (typeEnv[cast.getInput()].applySignedness(
                                resultType.signedness))
                            changed = true;
                    }
                    return;
                }

                // ─── New HelixHigh backward rules ────────────────────────

                // Backward Rule HB6: SubscriptOp — if a value is used as
                // the base of an array subscript, it must be a pointer.
                // If used as the index, it must be an integer.
                if (auto subscript =
                        dyn_cast<helix::high::SubscriptOp>(op)) {
                    // Base → pointer
                    if (!isTypeLocked(subscript.getBase(), lockedValues)) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (typeEnv[subscript.getBase()].mergeFrom(ptrType))
                            changed = true;
                    }
                    // Propagate base as pointer into varTypes.
                    if (auto varRef = subscript.getBase()
                                          .getDefiningOp<
                                              helix::high::VarRefOp>()) {
                        uint32_t varId = varRef.getVarId();
                        if (!lockedVarIds.count(varId)) {
                            CTypeInfo ptrType = CTypeInfo::makePointer();
                            if (varTypes[varId].mergeFrom(ptrType))
                                changed = true;
                        }
                    }
                    // Index → unsigned integer
                    if (!isTypeLocked(subscript.getIndex(), lockedValues)) {
                        unsigned idxWidth = 0;
                        if (auto intTy = dyn_cast<IntegerType>(
                                subscript.getIndex().getType()))
                            idxWidth = intTy.getWidth();
                        if (idxWidth > 0) {
                            CTypeInfo idxType =
                                CTypeInfo::makeInt(idxWidth,
                                                   /*signed=*/false);
                            if (typeEnv[subscript.getIndex()].mergeFrom(
                                    idxType))
                                changed = true;
                        }
                    }
                    // If the subscript result has a known type, try to
                    // refine the base pointer's pointee type.
                    auto elemType = typeEnv[subscript.getResult()];
                    if (elemType.isResolved() &&
                        !isTypeLocked(subscript.getBase(), lockedValues)) {
                        CTypeInfo typedPtr =
                            CTypeInfo::makePointer(elemType);
                        if (typeEnv[subscript.getBase()].mergeFrom(typedPtr))
                            changed = true;
                    }
                    return;
                }

                // Backward Rule HB7: FieldAccessOp — base must be a
                // pointer. If the field result type is known, propagate
                // that to the base pointer as struct information.
                if (auto field =
                        dyn_cast<helix::high::FieldAccessOp>(op)) {
                    if (!isTypeLocked(field.getBase(), lockedValues)) {
                        CTypeInfo ptrType = CTypeInfo::makePointer();
                        if (typeEnv[field.getBase()].mergeFrom(ptrType))
                            changed = true;
                    }
                    if (auto varRef = field.getBase()
                                          .getDefiningOp<
                                              helix::high::VarRefOp>()) {
                        uint32_t varId = varRef.getVarId();
                        if (!lockedVarIds.count(varId)) {
                            CTypeInfo ptrType = CTypeInfo::makePointer();
                            if (varTypes[varId].mergeFrom(ptrType))
                                changed = true;
                        }
                    }
                    return;
                }

                // (HB8-HB10 are integrated into the HB1 BinaryOp block
                //  above to avoid unreachable code.)

                // Backward Rule HB11: TernaryOp — if the result type is
                // known, propagate it back to both the true and false arms.
                if (auto ternary =
                        dyn_cast<helix::high::TernaryOp>(op)) {
                    auto resultType = typeEnv[ternary.getResult()];
                    if (resultType.isResolved()) {
                        if (!isTypeLocked(ternary.getTrueVal(),
                                          lockedValues) &&
                            typeEnv[ternary.getTrueVal()].mergeFrom(
                                resultType))
                            changed = true;
                        if (!isTypeLocked(ternary.getFalseVal(),
                                          lockedValues) &&
                            typeEnv[ternary.getFalseVal()].mergeFrom(
                                resultType))
                            changed = true;
                    }
                    // If one arm is typed and the other isn't, propagate.
                    auto trueType = typeEnv[ternary.getTrueVal()];
                    auto falseType = typeEnv[ternary.getFalseVal()];
                    if (trueType.isResolved() && !falseType.isResolved() &&
                        !isTypeLocked(ternary.getFalseVal(), lockedValues)) {
                        if (typeEnv[ternary.getFalseVal()].mergeFrom(
                                trueType))
                            changed = true;
                    } else if (falseType.isResolved() &&
                               !trueType.isResolved() &&
                               !isTypeLocked(ternary.getTrueVal(),
                                             lockedValues)) {
                        if (typeEnv[ternary.getTrueVal()].mergeFrom(
                                falseType))
                            changed = true;
                    }
                    return;
                }
            });

            // Fixed point reached — no more backward changes.
            if (!changed)
                break;
        }

        // Store resolved types as attributes on var.decl operations.
        for (auto& [varId, typeInfo] : varTypes) {
            if (!typeInfo.isResolved())
                continue;

            std::string typeStr = typeInfo.toCTypeString();
            if (typeStr.empty())
                continue;

            // Find the var.decl with this ID and set the attribute.
            func.walk([&](helix::high::VarDeclOp decl) {
                if (decl.getVarId() == varId) {
                    decl->setAttr("inferred_type",
                        StringAttr::get(decl->getContext(), typeStr));
                }
            });
        }

        // Store resolved types on SSA value defining ops.
        // FIX (non-determinism): same DenseMap<Value,...> pointer-order hazard as
        // the low path -- a deterministic winner (lowest result number) per
        // defining op, written once.
        llvm::DenseMap<Operation*, std::pair<unsigned, std::string>> chosenHigh;
        for (auto& [val, typeInfo] : typeEnv) {
            if (!typeInfo.isResolved())
                continue;

            auto* defOp = val.getDefiningOp();
            if (!defOp)
                continue;

            std::string typeStr = typeInfo.toCTypeString();
            if (typeStr.empty())
                continue;

            unsigned rn = 0;
            if (auto res = mlir::dyn_cast<mlir::OpResult>(val))
                rn = res.getResultNumber();
            auto it = chosenHigh.find(defOp);
            if (it == chosenHigh.end())
                chosenHigh.insert({defOp, {rn, typeStr}});
            else if (rn < it->second.first)
                it->second = {rn, typeStr};
        }
        for (auto& [defOp, rt] : chosenHigh)
            defOp->setAttr("inferred_type",
                StringAttr::get(defOp->getContext(), rt.second));
    }
};

} // anonymous namespace

std::unique_ptr<mlir::Pass> helix::createPropagateTypesPass() {
    return std::make_unique<PropagateTypesPass>();
}

std::unique_ptr<mlir::Pass> helix::createPropagateTypesHighPass() {
    auto pass = std::make_unique<PropagateTypesPass>();
    pass->highOnly_ = true;
    return pass;
}
