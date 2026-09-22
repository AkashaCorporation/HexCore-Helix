/// @file TypeLattice.h
/// @brief Formal type lattice for bidirectional type inference.
///
/// Replaces the flat CTypeInfo struct with a lattice that supports meet/join,
/// subtype comparison, and backward propagation. Inspired by Ghidra's
/// type_metatype hierarchy with sub_metatype specificity ordering.
///
/// Lattice structure:
///
///          Top (Unknown)
///         / |  |  |   \
///      Int UInt Float Code Ptr<T>
///      /\   /\            |
///    i8 i16 u8 u16    FuncPtr   Array<T,N>
///     \ |   | /           |         |
///      Bool          Struct{...}  Union{...}
///                         |
///                    Bottom (Conflict)
///
/// @version Helix-Nightly

#pragma once

#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/SmallVector.h"

#include <cstdint>
#include <memory>
#include <optional>
#include <string>
#include <vector>

namespace helix {

/// Metatype categories — coarse classification analogous to Ghidra's
/// type_metatype enum.
enum class MetaType : uint8_t {
    Unknown  = 0,  ///< Top of lattice — no type information yet
    Void     = 1,
    Bool     = 2,
    Int      = 3,  ///< Signed integer
    UInt     = 4,  ///< Unsigned integer
    Float    = 5,
    Pointer  = 6,
    Array    = 7,
    Struct   = 8,
    Union    = 9,
    FuncPtr  = 10,
    Code     = 11, ///< Executable code (function pointer without signature)
    Enum     = 12,
    Conflict = 15, ///< Bottom of lattice — irreconcilable types
};

/// Returns the specificity rank (lower = more specific, higher = more general).
/// Used for ordering in meet/join operations.
unsigned metaTypeSpecificity(MetaType mt);

/// Human-readable name for a MetaType.
const char* metaTypeName(MetaType mt);

/// A field descriptor within a struct or union.
struct FieldInfo {
    std::string name;      ///< Field name (e.g., "field_0", "vtable")
    unsigned offset = 0;   ///< Byte offset from struct base
    unsigned size = 0;     ///< Field size in bytes
    MetaType field_meta = MetaType::Unknown;
    unsigned field_bits = 0;
    bool is_signed = false;

    bool operator==(const FieldInfo& o) const {
        return offset == o.offset && size == o.size;
    }
};

/// HelixTypeInfo — the core type representation with lattice operations.
///
/// Each SSA value and variable gets a HelixTypeInfo that starts as Unknown
/// (top) and is refined downward through propagation. The lattice guarantees
/// monotonic refinement: once a type becomes more specific, it never goes
/// back to a more general type (unless reset by Conflict).
class HelixTypeInfo {
public:
    // ─── Construction ─────────────────────────────────────────────────

    /// Top of lattice — no information.
    HelixTypeInfo() = default;

    /// Create a typed value.
    static HelixTypeInfo makeUnknown();
    static HelixTypeInfo makeVoid();
    static HelixTypeInfo makeBool();
    static HelixTypeInfo makeInt(unsigned bits, bool isSigned);
    static HelixTypeInfo makeFloat(unsigned bits);
    static HelixTypeInfo makePointer();
    static HelixTypeInfo makePointer(HelixTypeInfo pointee);
    static HelixTypeInfo makeArray(HelixTypeInfo element, uint64_t length);
    static HelixTypeInfo makeStruct(std::string name,
                                     std::vector<FieldInfo> fields);
    static HelixTypeInfo makeUnion(std::string name,
                                    std::vector<FieldInfo> variants);
    static HelixTypeInfo makeFuncPtr(HelixTypeInfo ret,
                                      std::vector<HelixTypeInfo> params);
    static HelixTypeInfo makeEnum(std::string name, unsigned bits);
    static HelixTypeInfo makeConflict();

    // ─── Accessors ────────────────────────────────────────────────────

    MetaType meta() const { return meta_; }
    unsigned bitWidth() const { return bit_width_; }
    bool isSigned() const { return is_signed_; }
    bool isResolved() const { return meta_ != MetaType::Unknown; }
    bool isConflict() const { return meta_ == MetaType::Conflict; }
    bool isTop() const { return meta_ == MetaType::Unknown; }
    bool isBottom() const { return meta_ == MetaType::Conflict; }
    bool isInteger() const { return meta_ == MetaType::Int || meta_ == MetaType::UInt; }
    bool isPointer() const { return meta_ == MetaType::Pointer; }
    bool isComposite() const {
        return meta_ == MetaType::Struct || meta_ == MetaType::Union ||
               meta_ == MetaType::Array;
    }

    /// Struct/union name (empty for anonymous).
    const std::string& compositeName() const { return composite_name_; }

    /// Fields for struct/union types.
    const std::vector<FieldInfo>& fields() const { return fields_; }

    /// Pointee type (for pointers). Returns Unknown if not pointer.
    const HelixTypeInfo* pointee() const { return pointee_.get(); }

    /// Element type (for arrays). Returns Unknown if not array.
    const HelixTypeInfo* element() const { return element_.get(); }

    /// Array length (0 = unknown length).
    uint64_t arrayLength() const { return array_length_; }

    /// Function pointer return type.
    const HelixTypeInfo* funcReturnType() const { return func_ret_.get(); }

    /// Function pointer parameter types.
    const std::vector<HelixTypeInfo>& funcParams() const { return func_params_; }

    // ─── Lattice Operations ───────────────────────────────────────────

    /// Meet: greatest lower bound (most specific common type).
    /// meet(Unknown, X) = X
    /// meet(X, X) = X
    /// meet(Int32, UInt32) = Int32 (signed wins)
    /// meet(Int32, Float32) = Conflict
    static HelixTypeInfo meet(const HelixTypeInfo& a, const HelixTypeInfo& b);

    /// Join: least upper bound (most general common type).
    /// join(Unknown, X) = Unknown
    /// join(X, X) = X
    /// join(Int32, Int64) = Int (unknown width)
    static HelixTypeInfo join(const HelixTypeInfo& a, const HelixTypeInfo& b);

    /// Is 'a' a subtype of 'b'? (a is more specific than b)
    /// Every type is a subtype of Unknown. Conflict is subtype of everything.
    /// Int32 is subtype of Int (no width). Bool is subtype of Int8.
    static bool isSubtype(const HelixTypeInfo& a, const HelixTypeInfo& b);

    /// Merge: attempt to refine this type with information from 'other'.
    /// Returns true if the type changed.
    /// This is the primary operation used in type propagation passes.
    /// Semantics: *this = meet(*this, other)
    bool mergeFrom(const HelixTypeInfo& other);

    // ─── Comparison ───────────────────────────────────────────────────

    bool operator==(const HelixTypeInfo& other) const;
    bool operator!=(const HelixTypeInfo& other) const { return !(*this == other); }

    /// Specificity ordering: lower = more specific. Used to choose
    /// which type to prefer when both are valid.
    unsigned specificity() const;

    // ─── Pointer Arithmetic Semantics ─────────────────────────────────

    /// Compute the result type of pointer + integer arithmetic.
    /// ptr + int → ptr (same pointee), int + ptr → ptr (same pointee).
    /// Returns Unknown if neither operand is a pointer.
    static HelixTypeInfo pointerArithResult(const HelixTypeInfo& lhs,
                                             const HelixTypeInfo& rhs);

    /// Compute the result type of pointer - pointer subtraction.
    /// ptr - ptr → signed int64 (ptrdiff_t).
    /// Returns Unknown if both operands are not pointers.
    static HelixTypeInfo pointerDiffResult(const HelixTypeInfo& lhs,
                                            const HelixTypeInfo& rhs);

    /// Compute the result type of loading through a pointer.
    /// If the pointer has a known pointee type, returns the pointee.
    /// Otherwise returns Unknown.
    static HelixTypeInfo loadThroughPointer(const HelixTypeInfo& ptrType);

    /// Create a pointer to a given type, inferring the pointee from a
    /// store value type. Used for backward inference: if we store T
    /// through an address, that address must be T*.
    static HelixTypeInfo pointerToType(const HelixTypeInfo& valueType);

    // ─── Formatting ───────────────────────────────────────────────────

    /// Format as a C-style type string (e.g., "int32_t", "void*", "bool").
    std::string toCTypeString() const;

    /// Parse a C-style type string into a HelixTypeInfo.
    static HelixTypeInfo fromCTypeString(llvm::StringRef str);

    /// Debug representation.
    std::string dump() const;

private:
    MetaType meta_ = MetaType::Unknown;
    unsigned bit_width_ = 0;
    bool is_signed_ = false;

    // Composite type data (struct/union)
    std::string composite_name_;
    std::vector<FieldInfo> fields_;

    // Pointer pointee
    std::shared_ptr<HelixTypeInfo> pointee_;

    // Array element
    std::shared_ptr<HelixTypeInfo> element_;
    uint64_t array_length_ = 0;

    // Function pointer
    std::shared_ptr<HelixTypeInfo> func_ret_;
    std::vector<HelixTypeInfo> func_params_;
};

/// A type environment that maps variable IDs to their inferred types.
/// Tracks whether any type changed during an iteration (for fixed-point).
class TypeEnvironment {
public:
    /// Get the type for a variable. Returns Unknown if not set.
    const HelixTypeInfo& get(uint32_t varId) const;

    /// Set the type for a variable. Returns true if changed.
    bool set(uint32_t varId, const HelixTypeInfo& type);

    /// Merge a type into a variable's existing type. Returns true if changed.
    bool merge(uint32_t varId, const HelixTypeInfo& type);

    /// Check if a variable has a resolved (non-Unknown) type.
    bool isResolved(uint32_t varId) const;

    /// Get statistics: resolved count, unresolved count.
    std::pair<unsigned, unsigned> stats() const;

    /// Clear all entries.
    void clear();

private:
    std::unordered_map<uint32_t, HelixTypeInfo> types_;
    static const HelixTypeInfo kUnknown;
};

} // namespace helix
