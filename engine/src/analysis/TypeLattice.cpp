/// @file TypeLattice.cpp
/// @brief Implementation of the formal type lattice for Helix-Nightly.
///
/// Provides meet/join operations, subtype comparison, and type environment
/// management for the bidirectional type propagation pass.
///
/// @version Helix-Nightly

#include "helix/analysis/TypeLattice.h"

#include "llvm/ADT/StringSwitch.h"

#include <algorithm>
#include <cassert>
#include <format>
#include <sstream>

using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════
// Free functions
// ═══════════════════════════════════════════════════════════════════════════

unsigned helix::metaTypeSpecificity(MetaType mt) {
    // Lower = more specific. Used in meet/join to decide precedence.
    switch (mt) {
    case MetaType::Conflict: return 0;   // Bottom — most specific (no valid type)
    case MetaType::Bool:     return 10;
    case MetaType::Enum:     return 20;
    case MetaType::Int:      return 30;
    case MetaType::UInt:     return 31;
    case MetaType::Float:    return 40;
    case MetaType::Pointer:  return 50;
    case MetaType::FuncPtr:  return 55;
    case MetaType::Array:    return 60;
    case MetaType::Struct:   return 70;
    case MetaType::Union:    return 75;
    case MetaType::Code:     return 80;
    case MetaType::Void:     return 90;
    case MetaType::Unknown:  return 100;  // Top — least specific
    }
    return 100;
}

const char* helix::metaTypeName(MetaType mt) {
    switch (mt) {
    case MetaType::Unknown:  return "unknown";
    case MetaType::Void:     return "void";
    case MetaType::Bool:     return "bool";
    case MetaType::Int:      return "int";
    case MetaType::UInt:     return "uint";
    case MetaType::Float:    return "float";
    case MetaType::Pointer:  return "ptr";
    case MetaType::Array:    return "array";
    case MetaType::Struct:   return "struct";
    case MetaType::Union:    return "union";
    case MetaType::FuncPtr:  return "funcptr";
    case MetaType::Code:     return "code";
    case MetaType::Enum:     return "enum";
    case MetaType::Conflict: return "CONFLICT";
    }
    return "?";
}

// ═══════════════════════════════════════════════════════════════════════════
// HelixTypeInfo — Factory methods
// ═══════════════════════════════════════════════════════════════════════════

HelixTypeInfo HelixTypeInfo::makeUnknown() {
    return HelixTypeInfo{};
}

HelixTypeInfo HelixTypeInfo::makeVoid() {
    HelixTypeInfo t;
    t.meta_ = MetaType::Void;
    t.bit_width_ = 0;
    return t;
}

HelixTypeInfo HelixTypeInfo::makeBool() {
    HelixTypeInfo t;
    t.meta_ = MetaType::Bool;
    t.bit_width_ = 1;
    t.is_signed_ = false;
    return t;
}

HelixTypeInfo HelixTypeInfo::makeInt(unsigned bits, bool isSigned) {
    HelixTypeInfo t;
    t.meta_ = isSigned ? MetaType::Int : MetaType::UInt;
    t.bit_width_ = bits;
    t.is_signed_ = isSigned;
    return t;
}

HelixTypeInfo HelixTypeInfo::makeFloat(unsigned bits) {
    HelixTypeInfo t;
    t.meta_ = MetaType::Float;
    t.bit_width_ = bits;
    return t;
}

HelixTypeInfo HelixTypeInfo::makePointer() {
    return makePointer(HelixTypeInfo{});
}

HelixTypeInfo HelixTypeInfo::makePointer(HelixTypeInfo pointee) {
    HelixTypeInfo t;
    t.meta_ = MetaType::Pointer;
    t.bit_width_ = 64; // x86-64 default
    if (pointee.meta_ != MetaType::Unknown)
        t.pointee_ = std::make_shared<HelixTypeInfo>(std::move(pointee));
    return t;
}

HelixTypeInfo HelixTypeInfo::makeArray(HelixTypeInfo element, uint64_t length) {
    HelixTypeInfo t;
    t.meta_ = MetaType::Array;
    t.element_ = std::make_shared<HelixTypeInfo>(std::move(element));
    t.array_length_ = length;
    t.bit_width_ = 0; // Computed from element * length
    return t;
}

HelixTypeInfo HelixTypeInfo::makeStruct(std::string name,
                                         std::vector<FieldInfo> fields) {
    HelixTypeInfo t;
    t.meta_ = MetaType::Struct;
    t.composite_name_ = std::move(name);
    t.fields_ = std::move(fields);

    // Compute total size from last field offset + size
    if (!t.fields_.empty()) {
        auto& last = t.fields_.back();
        t.bit_width_ = (last.offset + last.size) * 8;
    }
    return t;
}

HelixTypeInfo HelixTypeInfo::makeUnion(std::string name,
                                        std::vector<FieldInfo> variants) {
    HelixTypeInfo t;
    t.meta_ = MetaType::Union;
    t.composite_name_ = std::move(name);
    t.fields_ = std::move(variants);

    // Union size = max of all variant sizes
    unsigned maxSize = 0;
    for (auto& v : t.fields_)
        maxSize = std::max(maxSize, v.size);
    t.bit_width_ = maxSize * 8;
    return t;
}

HelixTypeInfo HelixTypeInfo::makeFuncPtr(HelixTypeInfo ret,
                                          std::vector<HelixTypeInfo> params) {
    HelixTypeInfo t;
    t.meta_ = MetaType::FuncPtr;
    t.bit_width_ = 64; // Pointer size
    t.func_ret_ = std::make_shared<HelixTypeInfo>(std::move(ret));
    t.func_params_ = std::move(params);
    return t;
}

HelixTypeInfo HelixTypeInfo::makeEnum(std::string name, unsigned bits) {
    HelixTypeInfo t;
    t.meta_ = MetaType::Enum;
    t.composite_name_ = std::move(name);
    t.bit_width_ = bits;
    return t;
}

HelixTypeInfo HelixTypeInfo::makeConflict() {
    HelixTypeInfo t;
    t.meta_ = MetaType::Conflict;
    return t;
}

// ═══════════════════════════════════════════════════════════════════════════
// HelixTypeInfo — Lattice operations
// ═══════════════════════════════════════════════════════════════════════════

HelixTypeInfo HelixTypeInfo::meet(const HelixTypeInfo& a,
                                   const HelixTypeInfo& b) {
    // Identity: meet(Unknown, X) = X, meet(X, Unknown) = X
    if (a.isTop()) return b;
    if (b.isTop()) return a;

    // Absorbing: meet(Conflict, X) = Conflict
    if (a.isConflict()) return a;
    if (b.isConflict()) return b;

    // Same metatype
    if (a.meta_ == b.meta_) {
        // Same metatype + same width → keep a (they're equal enough)
        if (a.bit_width_ == b.bit_width_) {
            // For int vs uint of same width, prefer signed (more specific info)
            if (a.meta_ == MetaType::Int || a.meta_ == MetaType::UInt) {
                if (a.is_signed_ != b.is_signed_) {
                    // Prefer signed — it carries more semantic info
                    return a.is_signed_ ? a : b;
                }
            }
            return a;
        }

        // Same metatype + different width → keep more specific (narrower)
        if (a.isInteger() && b.isInteger()) {
            // Both integers: the one with known width is more specific
            if (a.bit_width_ != 0 && b.bit_width_ != 0) {
                // Both have widths — conflict if different
                return makeConflict();
            }
            // One has width, other doesn't → keep the one with width
            return a.bit_width_ != 0 ? a : b;
        }

        // Struct/union with same name → keep a
        if ((a.meta_ == MetaType::Struct || a.meta_ == MetaType::Union) &&
            a.composite_name_ == b.composite_name_) {
            // Merge fields: take the union of known fields
            HelixTypeInfo result = a;
            for (auto& bf : b.fields_) {
                bool found = false;
                for (auto& rf : result.fields_) {
                    if (rf.offset == bf.offset) {
                        found = true;
                        // Merge field info: prefer more specific
                        if (rf.field_meta == MetaType::Unknown &&
                            bf.field_meta != MetaType::Unknown) {
                            rf = bf;
                        }
                        break;
                    }
                }
                if (!found)
                    result.fields_.push_back(bf);
            }
            // Sort fields by offset
            std::sort(result.fields_.begin(), result.fields_.end(),
                      [](const FieldInfo& x, const FieldInfo& y) {
                          return x.offset < y.offset;
                      });
            return result;
        }

        // Pointer types: meet pointees
        if (a.meta_ == MetaType::Pointer) {
            if (a.pointee_ && b.pointee_) {
                auto pointeeMeet = meet(*a.pointee_, *b.pointee_);
                return makePointer(pointeeMeet);
            }
            // One has pointee info, other doesn't → keep the one with info
            if (a.pointee_) return a;
            if (b.pointee_) return b;
            return a; // Both are void*
        }

        return a; // Same metatype, same width
    }

    // Different metatypes — check compatibility

    // Int/UInt are compatible (signedness difference only)
    if ((a.meta_ == MetaType::Int && b.meta_ == MetaType::UInt) ||
        (a.meta_ == MetaType::UInt && b.meta_ == MetaType::Int)) {
        if (a.bit_width_ == b.bit_width_ || a.bit_width_ == 0 || b.bit_width_ == 0) {
            // Prefer signed
            unsigned width = a.bit_width_ ? a.bit_width_ : b.bit_width_;
            return makeInt(width, /*signed=*/true);
        }
        return makeConflict(); // Different widths
    }

    // Bool is subtype of any integer
    if (a.meta_ == MetaType::Bool && b.isInteger()) return a;
    if (b.meta_ == MetaType::Bool && a.isInteger()) return b;

    // Enum is compatible with integer of same width
    if (a.meta_ == MetaType::Enum && b.isInteger()) {
        if (a.bit_width_ == b.bit_width_ || b.bit_width_ == 0)
            return a; // Enum is more specific
    }
    if (b.meta_ == MetaType::Enum && a.isInteger()) {
        if (b.bit_width_ == a.bit_width_ || a.bit_width_ == 0)
            return b;
    }

    // FuncPtr is subtype of Pointer
    if (a.meta_ == MetaType::FuncPtr && b.meta_ == MetaType::Pointer) return a;
    if (b.meta_ == MetaType::FuncPtr && a.meta_ == MetaType::Pointer) return b;

    // Everything else is a conflict
    return makeConflict();
}

HelixTypeInfo HelixTypeInfo::join(const HelixTypeInfo& a,
                                   const HelixTypeInfo& b) {
    // Identity: join(Unknown, X) = Unknown
    if (a.isTop() || b.isTop()) return makeUnknown();

    // Absorbing: join(Conflict, X) = X
    if (a.isConflict()) return b;
    if (b.isConflict()) return a;

    // Same metatype → keep metatype, widen width if different
    if (a.meta_ == b.meta_) {
        if (a.bit_width_ == b.bit_width_) return a;
        // Different widths of same metatype → drop width info
        HelixTypeInfo result;
        result.meta_ = a.meta_;
        result.bit_width_ = 0; // Unknown width
        result.is_signed_ = a.is_signed_ || b.is_signed_;
        return result;
    }

    // Int/UInt → integer (drop signedness certainty)
    if ((a.meta_ == MetaType::Int && b.meta_ == MetaType::UInt) ||
        (a.meta_ == MetaType::UInt && b.meta_ == MetaType::Int)) {
        HelixTypeInfo result;
        result.meta_ = MetaType::Int; // Default to signed
        result.bit_width_ = (a.bit_width_ == b.bit_width_) ? a.bit_width_ : 0;
        return result;
    }

    // Bool + integer → integer
    if (a.meta_ == MetaType::Bool && b.isInteger()) return b;
    if (b.meta_ == MetaType::Bool && a.isInteger()) return a;

    // FuncPtr + Pointer → Pointer
    if (a.meta_ == MetaType::FuncPtr && b.meta_ == MetaType::Pointer) return b;
    if (b.meta_ == MetaType::FuncPtr && a.meta_ == MetaType::Pointer) return a;

    // Everything else → Unknown (we lose type information)
    return makeUnknown();
}

bool HelixTypeInfo::isSubtype(const HelixTypeInfo& a, const HelixTypeInfo& b) {
    // Everything is subtype of Unknown (top)
    if (b.isTop()) return true;
    // Conflict (bottom) is subtype of everything
    if (a.isConflict()) return true;
    // Unknown is not subtype of anything except Unknown
    if (a.isTop()) return b.isTop();

    // Same metatype
    if (a.meta_ == b.meta_) {
        // With width is subtype of without width
        if (a.bit_width_ != 0 && b.bit_width_ == 0) return true;
        // Same width is subtype
        if (a.bit_width_ == b.bit_width_) return true;
        return false;
    }

    // Bool is subtype of any integer
    if (a.meta_ == MetaType::Bool &&
        (b.meta_ == MetaType::Int || b.meta_ == MetaType::UInt))
        return true;

    // Int is subtype of UInt (signed is more specific)
    if (a.meta_ == MetaType::Int && b.meta_ == MetaType::UInt &&
        a.bit_width_ == b.bit_width_)
        return true;

    // FuncPtr is subtype of Pointer
    if (a.meta_ == MetaType::FuncPtr && b.meta_ == MetaType::Pointer)
        return true;

    // Enum is subtype of integer with same width
    if (a.meta_ == MetaType::Enum && b.isInteger() &&
        (a.bit_width_ == b.bit_width_ || b.bit_width_ == 0))
        return true;

    return false;
}

bool HelixTypeInfo::mergeFrom(const HelixTypeInfo& other) {
    auto merged = meet(*this, other);
    if (merged != *this) {
        *this = merged;
        return true;
    }
    return false;
}

// ═══════════════════════════════════════════════════════════════════════════
// HelixTypeInfo — Pointer arithmetic semantics
// ═══════════════════════════════════════════════════════════════════════════

HelixTypeInfo HelixTypeInfo::pointerArithResult(const HelixTypeInfo& lhs,
                                                 const HelixTypeInfo& rhs) {
    // ptr + int → ptr (preserve pointee type from the pointer operand)
    if (lhs.isPointer() && (rhs.isInteger() || rhs.isTop())) {
        return lhs; // Preserve full pointer type including pointee
    }
    // int + ptr → ptr (commutative)
    if (rhs.isPointer() && (lhs.isInteger() || lhs.isTop())) {
        return rhs;
    }
    // ptr + ptr is not valid arithmetic — return Unknown (don't conflict)
    return makeUnknown();
}

HelixTypeInfo HelixTypeInfo::pointerDiffResult(const HelixTypeInfo& lhs,
                                                const HelixTypeInfo& rhs) {
    // ptr - ptr → ptrdiff_t (signed 64-bit integer)
    if (lhs.isPointer() && rhs.isPointer()) {
        return makeInt(64, /*isSigned=*/true); // ptrdiff_t
    }
    // ptr - int → ptr (still valid: pointer offset backward)
    if (lhs.isPointer() && (rhs.isInteger() || rhs.isTop())) {
        return lhs; // Preserve pointer type
    }
    return makeUnknown();
}

HelixTypeInfo HelixTypeInfo::loadThroughPointer(const HelixTypeInfo& ptrType) {
    if (!ptrType.isPointer())
        return makeUnknown();
    // If we have a known pointee type, loading gives us that type
    if (ptrType.pointee())
        return *ptrType.pointee();
    // Loading through void* gives us Unknown — we can't determine the type
    return makeUnknown();
}

HelixTypeInfo HelixTypeInfo::pointerToType(const HelixTypeInfo& valueType) {
    if (valueType.isTop() || valueType.isConflict())
        return makePointer(); // void* — no pointee info
    return makePointer(valueType);
}

// ═══════════════════════════════════════════════════════════════════════════
// HelixTypeInfo — Comparison & formatting
// ═══════════════════════════════════════════════════════════════════════════

bool HelixTypeInfo::operator==(const HelixTypeInfo& other) const {
    if (meta_ != other.meta_) return false;
    if (bit_width_ != other.bit_width_) return false;
    if (is_signed_ != other.is_signed_) return false;
    if (composite_name_ != other.composite_name_) return false;
    if (fields_.size() != other.fields_.size()) return false;
    for (size_t i = 0; i < fields_.size(); i++) {
        if (!(fields_[i] == other.fields_[i])) return false;
    }
    // Deep pointer/element comparison
    if ((pointee_ == nullptr) != (other.pointee_ == nullptr)) return false;
    if (pointee_ && *pointee_ != *other.pointee_) return false;
    if ((element_ == nullptr) != (other.element_ == nullptr)) return false;
    if (element_ && *element_ != *other.element_) return false;
    return true;
}

unsigned HelixTypeInfo::specificity() const {
    unsigned base = metaTypeSpecificity(meta_);
    // Having a known bit width is more specific
    if (bit_width_ > 0 && meta_ != MetaType::Unknown)
        base = base > 5 ? base - 5 : 0;
    return base;
}

std::string HelixTypeInfo::toCTypeString() const {
    switch (meta_) {
    case MetaType::Unknown:  return "unknown";
    case MetaType::Void:     return "void";
    case MetaType::Bool:     return "bool";
    case MetaType::Conflict: return "/* conflict */";

    case MetaType::Int:
        if (bit_width_ == 0) return "int";
        return std::format("int{}_t", bit_width_);

    case MetaType::UInt:
        if (bit_width_ == 0) return "unsigned int";
        return std::format("uint{}_t", bit_width_);

    case MetaType::Float:
        if (bit_width_ == 32) return "float";
        if (bit_width_ == 64) return "double";
        if (bit_width_ == 80) return "long double";
        return std::format("float{}", bit_width_);

    case MetaType::Pointer:
        if (pointee_)
            return pointee_->toCTypeString() + "*";
        return "void*";

    case MetaType::Array:
        if (element_) {
            if (array_length_ > 0)
                return std::format("{}[{}]", element_->toCTypeString(), array_length_);
            return element_->toCTypeString() + "[]";
        }
        return "void[]";

    case MetaType::Struct:
        if (!composite_name_.empty())
            return std::format("struct {}", composite_name_);
        return "struct <anonymous>";

    case MetaType::Union:
        if (!composite_name_.empty())
            return std::format("union {}", composite_name_);
        return "union <anonymous>";

    case MetaType::FuncPtr: {
        std::string result = "(";
        if (func_ret_)
            result += func_ret_->toCTypeString();
        else
            result += "void";
        result += "(*)(";
        for (size_t i = 0; i < func_params_.size(); i++) {
            if (i > 0) result += ", ";
            result += func_params_[i].toCTypeString();
        }
        result += "))";
        return result;
    }

    case MetaType::Enum:
        if (!composite_name_.empty())
            return std::format("enum {}", composite_name_);
        return "enum <anonymous>";

    case MetaType::Code:
        return "code";
    }
    return "?";
}

HelixTypeInfo HelixTypeInfo::fromCTypeString(llvm::StringRef str) {
    return llvm::StringSwitch<HelixTypeInfo>(str)
        .Case("void",       makeVoid())
        .Case("bool",       makeBool())
        .Case("int8_t",     makeInt(8, true))
        .Case("uint8_t",    makeInt(8, false))
        .Case("int16_t",    makeInt(16, true))
        .Case("uint16_t",   makeInt(16, false))
        .Case("int32_t",    makeInt(32, true))
        .Case("uint32_t",   makeInt(32, false))
        .Case("int64_t",    makeInt(64, true))
        .Case("uint64_t",   makeInt(64, false))
        .Case("int",        makeInt(32, true))
        .Case("unsigned",   makeInt(32, false))
        .Case("long",       makeInt(64, true))
        .Case("long long",  makeInt(64, true))
        .Case("char",       makeInt(8, true))
        .Case("unsigned char", makeInt(8, false))
        .Case("short",      makeInt(16, true))
        .Case("unsigned short", makeInt(16, false))
        .Case("float",      makeFloat(32))
        .Case("double",     makeFloat(64))
        .Case("void*",      makePointer())
        .Case("ptr",        makePointer())
        .Case("HANDLE",     makePointer())
        .Case("LPVOID",     makePointer())
        .Case("LPCSTR",     makePointer(makeInt(8, true)))
        .Case("LPWSTR",     makePointer(makeInt(16, false)))
        .Case("BOOL",       makeInt(32, true))
        .Case("DWORD",      makeInt(32, false))
        .Case("WORD",       makeInt(16, false))
        .Case("BYTE",       makeInt(8, false))
        .Case("HRESULT",    makeInt(32, true))
        .Case("SIZE_T",     makeInt(64, false))
        .Case("ULONG_PTR",  makeInt(64, false))
        .Case("LONG_PTR",   makeInt(64, true))
        .Case("size_t",     makeInt(64, false))
        .Case("ssize_t",    makeInt(64, true))
        .Case("ptrdiff_t",  makeInt(64, true))
        .Case("intptr_t",   makeInt(64, true))
        .Case("uintptr_t",  makeInt(64, false))
        .Default(makeUnknown());
}

std::string HelixTypeInfo::dump() const {
    std::string result = std::format("[{}", metaTypeName(meta_));
    if (bit_width_ > 0)
        result += std::format(" {}b", bit_width_);
    if (is_signed_)
        result += " signed";
    if (!composite_name_.empty())
        result += std::format(" '{}'", composite_name_);
    if (!fields_.empty())
        result += std::format(" {}fields", fields_.size());
    if (pointee_)
        result += std::format(" ->{}",  pointee_->dump());
    result += "]";
    return result;
}

// ═══════════════════════════════════════════════════════════════════════════
// TypeEnvironment
// ═══════════════════════════════════════════════════════════════════════════

const HelixTypeInfo TypeEnvironment::kUnknown = HelixTypeInfo::makeUnknown();

const HelixTypeInfo& TypeEnvironment::get(uint32_t varId) const {
    auto it = types_.find(varId);
    if (it != types_.end())
        return it->second;
    return kUnknown;
}

bool TypeEnvironment::set(uint32_t varId, const HelixTypeInfo& type) {
    auto& existing = types_[varId];
    if (existing != type) {
        existing = type;
        return true;
    }
    return false;
}

bool TypeEnvironment::merge(uint32_t varId, const HelixTypeInfo& type) {
    return types_[varId].mergeFrom(type);
}

bool TypeEnvironment::isResolved(uint32_t varId) const {
    auto it = types_.find(varId);
    return it != types_.end() && it->second.isResolved();
}

std::pair<unsigned, unsigned> TypeEnvironment::stats() const {
    unsigned resolved = 0, unresolved = 0;
    for (auto& [_, t] : types_) {
        if (t.isResolved())
            resolved++;
        else
            unresolved++;
    }
    return {resolved, unresolved};
}

void TypeEnvironment::clear() {
    types_.clear();
}
