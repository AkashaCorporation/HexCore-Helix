#include "helix/cast/CType.h"

namespace helix::cast {

std::string CType::format() const {
    switch (kind) {
    case TypeKind::Void:
        return "void";

    case TypeKind::Bool:
        return "bool";

    case TypeKind::Int:
        if (bitWidth == 0)
            return "int";
        if (isSigned) {
            switch (bitWidth) {
            case 8:  return "int8_t";
            case 16: return "int16_t";
            case 32: return "int32_t";
            case 64: return "int64_t";
            default: return "int" + std::to_string(bitWidth) + "_t";
            }
        } else {
            switch (bitWidth) {
            case 8:  return "uint8_t";
            case 16: return "uint16_t";
            case 32: return "uint32_t";
            case 64: return "uint64_t";
            default: return "uint" + std::to_string(bitWidth) + "_t";
            }
        }

    case TypeKind::Float:
        if (bitWidth == 64) return "double";
        return "float";

    case TypeKind::Pointer:
        if (pointeeType)
            return pointeeType->format() + "*";
        return "void*";

    case TypeKind::Array:
        if (pointeeType)
            return pointeeType->format() + "[]";
        return "void[]";

    case TypeKind::Struct:
        if (structName.empty())
            return "struct <anonymous>";
        return "struct " + structName;

    case TypeKind::Union:
        if (structName.empty())
            return "union <anonymous>";
        return "union " + structName;

    case TypeKind::FuncPtr:
        // Simplified representation: returnType (*)(paramTypes...)
        {
            std::string result;
            if (returnType)
                result = returnType->format();
            else
                result = "void";
            result += " (*)(";
            for (size_t i = 0; i < paramTypes.size(); ++i) {
                if (i > 0) result += ", ";
                if (paramTypes[i])
                    result += paramTypes[i]->format();
                else
                    result += "void";
            }
            if (paramTypes.empty())
                result += "void";
            result += ")";
            return result;
        }

    case TypeKind::Unknown:
        return "unknown_t";
    }

    return "unknown_t";
}

bool CType::operator==(const CType& other) const {
    if (kind != other.kind) return false;
    if (isSigned != other.isSigned) return false;
    if (bitWidth != other.bitWidth) return false;
    if (structName != other.structName) return false;

    // Compare pointee types
    if (pointeeType && other.pointeeType) {
        if (*pointeeType != *other.pointeeType) return false;
    } else if (pointeeType || other.pointeeType) {
        return false;
    }

    // Compare return types (for FuncPtr)
    if (returnType && other.returnType) {
        if (*returnType != *other.returnType) return false;
    } else if (returnType || other.returnType) {
        return false;
    }

    // Compare param types (for FuncPtr)
    if (paramTypes.size() != other.paramTypes.size()) return false;
    for (size_t i = 0; i < paramTypes.size(); ++i) {
        if (paramTypes[i] && other.paramTypes[i]) {
            if (*paramTypes[i] != *other.paramTypes[i]) return false;
        } else if (paramTypes[i] || other.paramTypes[i]) {
            return false;
        }
    }

    return true;
}

// ── Static factory methods ──────────────────────────────────────────────────

std::shared_ptr<CType> CType::voidTy() {
    auto t = std::make_shared<CType>(TypeKind::Void);
    return t;
}

std::shared_ptr<CType> CType::boolTy() {
    auto t = std::make_shared<CType>(TypeKind::Bool);
    return t;
}

std::shared_ptr<CType> CType::int8() {
    auto t = std::make_shared<CType>(TypeKind::Int);
    t->isSigned = true;
    t->bitWidth = 8;
    return t;
}

std::shared_ptr<CType> CType::int16() {
    auto t = std::make_shared<CType>(TypeKind::Int);
    t->isSigned = true;
    t->bitWidth = 16;
    return t;
}

std::shared_ptr<CType> CType::int32() {
    auto t = std::make_shared<CType>(TypeKind::Int);
    t->isSigned = true;
    t->bitWidth = 32;
    return t;
}

std::shared_ptr<CType> CType::int64() {
    auto t = std::make_shared<CType>(TypeKind::Int);
    t->isSigned = true;
    t->bitWidth = 64;
    return t;
}

std::shared_ptr<CType> CType::uint8() {
    auto t = std::make_shared<CType>(TypeKind::Int);
    t->isSigned = false;
    t->bitWidth = 8;
    return t;
}

std::shared_ptr<CType> CType::uint16() {
    auto t = std::make_shared<CType>(TypeKind::Int);
    t->isSigned = false;
    t->bitWidth = 16;
    return t;
}

std::shared_ptr<CType> CType::uint32() {
    auto t = std::make_shared<CType>(TypeKind::Int);
    t->isSigned = false;
    t->bitWidth = 32;
    return t;
}

std::shared_ptr<CType> CType::uint64() {
    auto t = std::make_shared<CType>(TypeKind::Int);
    t->isSigned = false;
    t->bitWidth = 64;
    return t;
}

std::shared_ptr<CType> CType::floatTy() {
    auto t = std::make_shared<CType>(TypeKind::Float);
    t->bitWidth = 32;
    return t;
}

std::shared_ptr<CType> CType::doubleTy() {
    auto t = std::make_shared<CType>(TypeKind::Float);
    t->bitWidth = 64;
    return t;
}

std::shared_ptr<CType> CType::voidPtr() {
    auto t = std::make_shared<CType>(TypeKind::Pointer);
    t->pointeeType = voidTy();
    return t;
}

std::shared_ptr<CType> CType::pointerTo(std::shared_ptr<CType> pointee) {
    auto t = std::make_shared<CType>(TypeKind::Pointer);
    t->pointeeType = std::move(pointee);
    return t;
}

std::shared_ptr<CType> CType::arrayOf(std::shared_ptr<CType> element) {
    auto t = std::make_shared<CType>(TypeKind::Array);
    t->pointeeType = std::move(element);
    return t;
}

std::shared_ptr<CType> CType::structTy(const std::string& name) {
    auto t = std::make_shared<CType>(TypeKind::Struct);
    t->structName = name;
    return t;
}

std::shared_ptr<CType> CType::unknownTy() {
    return std::make_shared<CType>(TypeKind::Unknown);
}

} // namespace helix::cast
