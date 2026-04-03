#pragma once

#include <cstdint>
#include <memory>
#include <string>
#include <vector>

namespace helix::cast {

/// Kind of C type.
enum class TypeKind : uint8_t {
    Void,
    Bool,
    Int,
    Float,
    Pointer,
    Array,
    Struct,
    Union,
    FuncPtr,
    Unknown,
};

/// Storage location classification for variables.
enum class StorageKind : uint8_t {
    Stack,
    Register,
    Global,
    Parameter,
    Temporary,
};

/// Mutable C type representation, independent of MLIR.
///
/// Mirrors HelixHigh's CType attribute but as a standalone mutable C++ object.
/// Types are shared via shared_ptr so multiple AST nodes can reference the same type.
class CType {
public:
    TypeKind kind = TypeKind::Unknown;
    bool isSigned = true;
    unsigned bitWidth = 0;
    std::string structName;
    std::shared_ptr<CType> pointeeType;      // For Pointer, Array
    std::shared_ptr<CType> returnType;        // For FuncPtr
    std::vector<std::shared_ptr<CType>> paramTypes; // For FuncPtr

    CType() = default;
    explicit CType(TypeKind kind) : kind(kind) {}

    /// Format this type as a C type string (e.g. "int32_t", "void*", "struct Foo").
    std::string format() const;

    bool operator==(const CType& other) const;
    bool operator!=(const CType& other) const { return !(*this == other); }

    // ── Static factory methods ──────────────────────────────────────────

    static std::shared_ptr<CType> voidTy();
    static std::shared_ptr<CType> boolTy();

    static std::shared_ptr<CType> int8();
    static std::shared_ptr<CType> int16();
    static std::shared_ptr<CType> int32();
    static std::shared_ptr<CType> int64();

    static std::shared_ptr<CType> uint8();
    static std::shared_ptr<CType> uint16();
    static std::shared_ptr<CType> uint32();
    static std::shared_ptr<CType> uint64();

    static std::shared_ptr<CType> floatTy();
    static std::shared_ptr<CType> doubleTy();

    static std::shared_ptr<CType> voidPtr();

    /// Create a pointer to the given pointee type.
    static std::shared_ptr<CType> pointerTo(std::shared_ptr<CType> pointee);

    /// Create an array of the given element type.
    static std::shared_ptr<CType> arrayOf(std::shared_ptr<CType> element);

    /// Create a named struct type.
    static std::shared_ptr<CType> structTy(const std::string& name);

    /// Create an unknown type.
    static std::shared_ptr<CType> unknownTy();
};

using CTypePtr = std::shared_ptr<CType>;

} // namespace helix::cast
