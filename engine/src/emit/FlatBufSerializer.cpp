/// @file FlatBufSerializer.cpp
/// @brief Canonical C AST to HAST FlatBuffer serializer.
///
/// Successful serialization always produces the append-only HAST 1.x
/// contract. There is deliberately no partial MLIR or name-only fallback.

#include "helix/emit/FlatBufSerializer.h"
#include "helix/Engine.h"

// C AST headers
#include "helix/cast/CAstNode.h"
#include "helix/cast/CType.h"
#include "helix/cast/CExpr.h"
#include "helix/cast/CStmt.h"
#include "helix/cast/CDecl.h"

#ifdef HELIX_HAS_FLATBUFFERS
#include <flatbuffers/flatbuffers.h>
#endif

#include <array>
#include <cstring>
#include <format>
#include <limits>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

using namespace helix;

#ifdef HELIX_HAS_FLATBUFFERS

namespace {

// ── Schema vtable offsets (4 + field_index * 2) ────────────────────────────
// These MUST match the field ordering in schemas/ast.fbs.

// DataType: kind, is_signed, bits, element_type, array_length, name,
//           fields, return_type, param_types
enum : uint16_t {
    DT_KIND = 4, DT_IS_SIGNED = 6, DT_BITS = 8,
    DT_ELEMENT_TYPE = 10, DT_ARRAY_LENGTH = 12, DT_NAME = 14,
    DT_FIELDS = 16, DT_RETURN_TYPE = 18, DT_PARAM_TYPES = 20,
};

// Variable: legacy prefix followed by HAST 1.x append-only fields.
enum : uint16_t {
    V_NAME = 4, V_TYPE = 6, V_STORAGE = 8, V_STACK_OFFSET = 10,
    V_IDENTITY_ID = 12, V_PARAMETER_INDEX = 14,
};

// Expression: legacy prefix followed by HAST 1.x append-only fields.
enum : uint16_t {
    E_KIND = 4, E_INT_VALUE = 6, E_FLOAT_VALUE = 8,
    E_STRING_VALUE = 10, E_OPERATOR = 12, E_CAST_TYPE = 14,
    E_CHILDREN = 16, E_VARIABLE = 18, E_ADDRESS = 20,
    E_RESULT_TYPE = 22, E_NODE_ID = 24, E_SOURCE_ADDRESS = 26,
    E_CALL_TARGET = 28, E_FIELD_OFFSET = 30,
};

// Statement: legacy prefix followed by HAST 1.x append-only fields.
enum : uint16_t {
    S_KIND = 4, S_VARIABLE = 6, S_EXPRESSIONS = 8,
    S_CHILDREN = 10, S_CASES = 12, S_TEXT = 14,
    S_NODE_ID = 16, S_SOURCE_ADDRESS = 18, S_CHILD_ROLES = 20,
};

// SwitchCase: values, body
enum : uint16_t { SC_VALUES = 4, SC_BODY = 6 };

// DecompiledFunction: name, address, return_type, params, locals, body,
//                     calling_convention, is_variadic
enum : uint16_t {
    F_NAME = 4, F_ADDRESS = 6, F_RETURN_TYPE = 8,
    F_PARAMS = 10, F_LOCALS = 12, F_BODY = 14,
    F_CALLING_CONVENTION = 16, F_IS_VARIADIC = 18,
};

// AstModule: legacy prefix followed by HAST 1.x negotiation fields.
enum : uint16_t {
    M_NAME = 4, M_FUNCTIONS = 6, M_GLOBAL_VARS = 8, M_TYPE_DEFS = 10,
    M_SCHEMA_MAJOR = 12, M_SCHEMA_MINOR = 14, M_CAPABILITIES = 16,
    M_PRODUCER = 18, M_VERSION = 20, M_ARCH = 22, M_POINTER_BITS = 24,
};

enum class ChildRole : uint8_t {
    Unknown = 0,
    Then = 1,
    Else = 2,
    Body = 3,
    Init = 4,
    Step = 5,
    BlockItem = 6,
};

constexpr uint16_t kHastSchemaMajor = 1;
constexpr uint16_t kHastSchemaMinor = 0;
constexpr std::array<uint8_t, 7> kHastCapabilities = {0, 1, 2, 3, 4, 5, 6};

// ── Alias for readability ──────────────────────────────────────────────────

using FBB = flatbuffers::FlatBufferBuilder;
using TableOff = flatbuffers::Offset<flatbuffers::Table>;
using StringOff = flatbuffers::Offset<flatbuffers::String>;

static bool appendIfPresent(std::vector<TableOff>& offsets, TableOff offset) {
    if (!offset.IsNull()) {
        offsets.push_back(offset);
        return true;
    }
    return false;
}

/// Assign IDs in logical preorder even though FlatBuffers writes children
/// before parents. Object identity guards against accidental re-serialization.
class NodeIdState {
public:
    uint64_t get(const cast::CAstNode* node) {
        auto [it, inserted] = ids_.try_emplace(node, 0);
        if (inserted)
            it->second = next_++;
        return it->second;
    }

private:
    uint64_t next_ = 1; // zero is reserved by the HAST contract
    std::unordered_map<const cast::CAstNode*, uint64_t> ids_;
};

static uint8_t archToFB(HelixArch arch) {
    switch (arch) {
    case HELIX_ARCH_X86:       return 0;
    case HELIX_ARCH_X86_64:    return 1;
    case HELIX_ARCH_ARM:       return 2;
    case HELIX_ARCH_AARCH64:   return 3;
    case HELIX_ARCH_MIPS:      return 4;
    case HELIX_ARCH_MIPS64:    return 5;
    case HELIX_ARCH_POWERPC:   return 6;
    case HELIX_ARCH_POWERPC64: return 7;
    case HELIX_ARCH_SPARC:     return 8;
    case HELIX_ARCH_SPARC64:   return 9;
    case HELIX_ARCH_RISCV32:   return 10;
    case HELIX_ARCH_RISCV64:   return 11;
    }
    return 255;
}

static uint16_t pointerBitsForArch(HelixArch arch) {
    switch (arch) {
    case HELIX_ARCH_X86:
    case HELIX_ARCH_ARM:
    case HELIX_ARCH_MIPS:
    case HELIX_ARCH_RISCV32:
        return 32;
    case HELIX_ARCH_X86_64:
    case HELIX_ARCH_AARCH64:
    case HELIX_ARCH_MIPS64:
    case HELIX_ARCH_POWERPC64:
    case HELIX_ARCH_SPARC64:
    case HELIX_ARCH_RISCV64:
        return 64;
    case HELIX_ARCH_POWERPC:
    case HELIX_ARCH_SPARC:
        return 32;
    }
    return 0;
}

// ── Enum mappings ──────────────────────────────────────────────────────────

static uint8_t typeKindToFB(cast::TypeKind k) {
    switch (k) {
    case cast::TypeKind::Void:    return 0;
    case cast::TypeKind::Bool:    return 1;
    case cast::TypeKind::Int:     return 2;
    case cast::TypeKind::Float:   return 3;
    case cast::TypeKind::Pointer: return 4;
    case cast::TypeKind::Array:   return 5;
    case cast::TypeKind::Struct:  return 6;
    case cast::TypeKind::Union:   return 7;
    case cast::TypeKind::FuncPtr: return 8;
    case cast::TypeKind::Unknown: return 255;
    }
    return 255;
}

static uint8_t storageKindToFB(cast::StorageKind k) {
    switch (k) {
    case cast::StorageKind::Stack:     return 0;
    case cast::StorageKind::Register:  return 1;
    case cast::StorageKind::Global:    return 2;
    case cast::StorageKind::Parameter: return 3;
    case cast::StorageKind::Temporary: return 4;
    }
    return 0;
}

static const char* binaryOpStr(cast::BinaryOp op) {
    switch (op) {
    case cast::BinaryOp::Add:    return "+";
    case cast::BinaryOp::Sub:    return "-";
    case cast::BinaryOp::Mul:    return "*";
    case cast::BinaryOp::Div:    return "/";
    case cast::BinaryOp::Mod:    return "%";
    case cast::BinaryOp::Shl:    return "<<";
    case cast::BinaryOp::Shr:    return ">>";
    case cast::BinaryOp::Sar:    return ">>";
    case cast::BinaryOp::BitAnd: return "&";
    case cast::BinaryOp::BitOr:  return "|";
    case cast::BinaryOp::BitXor: return "^";
    case cast::BinaryOp::Eq:     return "==";
    case cast::BinaryOp::Ne:     return "!=";
    case cast::BinaryOp::Lt:     return "<";
    case cast::BinaryOp::Le:     return "<=";
    case cast::BinaryOp::Gt:     return ">";
    case cast::BinaryOp::Ge:     return ">=";
    case cast::BinaryOp::LogAnd: return "&&";
    case cast::BinaryOp::LogOr:  return "||";
    }
    return "?";
}

static const char* unaryOpStr(cast::UnaryOp op) {
    switch (op) {
    case cast::UnaryOp::Neg:       return "-";
    case cast::UnaryOp::LogNot:    return "!";
    case cast::UnaryOp::BitNot:    return "~";
    case cast::UnaryOp::Deref:     return "*";
    case cast::UnaryOp::AddressOf: return "&";
    }
    return "?";
}

static uint8_t exprKindFromNode(cast::NodeKind k) {
    switch (k) {
    case cast::NodeKind::IntLitExpr:      return 0;   // IntLit
    case cast::NodeKind::FloatLitExpr:    return 1;   // FloatLit
    case cast::NodeKind::StringLitExpr:   return 2;   // StringLit
    case cast::NodeKind::VarRefExpr:      return 3;   // VarRef
    case cast::NodeKind::UnaryExpr:       return 4;   // Unary
    case cast::NodeKind::BinaryExpr:      return 5;   // Binary
    case cast::NodeKind::CastExpr:        return 6;   // Cast
    case cast::NodeKind::CallExpr:        return 7;   // Call
    case cast::NodeKind::SubscriptExpr:   return 8;   // Subscript
    case cast::NodeKind::FieldAccessExpr: return 9;   // Member (patched for arrow below)
    case cast::NodeKind::TernaryExpr:     return 11;  // Ternary
    case cast::NodeKind::AddrLitExpr:     return 12;  // AddressLit
    default:                              return 255;  // Unknown
    }
}

static uint8_t stmtKindFromNode(cast::NodeKind k) {
    switch (k) {
    case cast::NodeKind::VarDecl:      return 0;
    case cast::NodeKind::AssignStmt:   return 1;
    case cast::NodeKind::ExprStmt:     return 2;
    case cast::NodeKind::ReturnStmt:   return 3;
    case cast::NodeKind::IfStmt:       return 4;
    case cast::NodeKind::WhileStmt:    return 5;
    case cast::NodeKind::DoWhileStmt:  return 6;
    case cast::NodeKind::ForStmt:      return 7;
    case cast::NodeKind::SwitchStmt:   return 8;
    case cast::NodeKind::BreakStmt:    return 9;
    case cast::NodeKind::ContinueStmt: return 10;
    case cast::NodeKind::GotoStmt:     return 11;
    case cast::NodeKind::LabelStmt:    return 12;
    case cast::NodeKind::AsmStmt:      return 13;
    case cast::NodeKind::CommentStmt:  return 14;
    case cast::NodeKind::BlockStmt:    return 15;
    default:                           return 255;
    }
}

// ── Forward declarations ───────────────────────────────────────────────────

static TableOff emitDataType(FBB& fbb, const cast::CType* type);
static TableOff emitExpression(FBB& fbb, const cast::CExpr* expr,
                               NodeIdState& nodeIds);
static TableOff emitStatement(FBB& fbb, const cast::CStmt* stmt,
                              NodeIdState& nodeIds);
static std::vector<TableOff> emitStmtList(
    FBB& fbb, const std::vector<cast::StmtPtr>& stmts,
    NodeIdState& nodeIds);

// ── DataType ───────────────────────────────────────────────────────────────

static TableOff emitDataType(FBB& fbb, const cast::CType* type) {
    if (!type) {
        auto s = fbb.StartTable();
        fbb.AddElement<uint8_t>(DT_KIND, 0 /*Void*/, 0);
        return TableOff(fbb.EndTable(s));
    }

    // Pre-create child objects (must happen BEFORE StartTable)
    TableOff elementType{0};
    if ((type->kind == cast::TypeKind::Pointer || type->kind == cast::TypeKind::Array)
        && type->pointeeType) {
        elementType = emitDataType(fbb, type->pointeeType.get());
    }

    StringOff name{0};
    if ((type->kind == cast::TypeKind::Struct || type->kind == cast::TypeKind::Union)
        && !type->structName.empty()) {
        name = fbb.CreateString(type->structName);
    }

    TableOff returnType{0};
    flatbuffers::Offset<flatbuffers::Vector<TableOff>> paramTypesVec{0};
    if (type->kind == cast::TypeKind::FuncPtr) {
        if (type->returnType)
            returnType = emitDataType(fbb, type->returnType.get());
        if (!type->paramTypes.empty()) {
            std::vector<TableOff> pts;
            for (auto& pt : type->paramTypes)
                pts.push_back(emitDataType(fbb, pt.get()));
            paramTypesVec = fbb.CreateVector(pts);
        }
    }

    auto s = fbb.StartTable();
    fbb.AddElement<uint8_t>(DT_KIND, typeKindToFB(type->kind), 0);
    fbb.AddElement<uint8_t>(DT_IS_SIGNED, type->isSigned ? uint8_t(1) : uint8_t(0), uint8_t(0));
    fbb.AddElement<uint16_t>(DT_BITS, static_cast<uint16_t>(type->bitWidth), uint16_t(0));
    if (!elementType.IsNull())  fbb.AddOffset(DT_ELEMENT_TYPE, elementType);
    if (!name.IsNull())         fbb.AddOffset(DT_NAME, name);
    if (!returnType.IsNull())   fbb.AddOffset(DT_RETURN_TYPE, returnType);
    if (!paramTypesVec.IsNull()) fbb.AddOffset(DT_PARAM_TYPES, paramTypesVec);
    return TableOff(fbb.EndTable(s));
}

// ── Variable ───────────────────────────────────────────────────────────────

static TableOff emitVariable(FBB& fbb, const std::string& name,
                               const cast::CType* type,
                               cast::StorageKind storage,
                               int64_t stackOffset,
                               std::optional<uint64_t> identityId,
                               std::optional<uint32_t> parameterIndex) {
    auto typeOff = emitDataType(fbb, type);
    auto nameOff = fbb.CreateString(name);

    auto s = fbb.StartTable();
    fbb.AddOffset(V_NAME, nameOff);
    if (!typeOff.IsNull()) fbb.AddOffset(V_TYPE, typeOff);
    fbb.AddElement<uint8_t>(V_STORAGE, storageKindToFB(storage), uint8_t(0));
    fbb.AddElement<int64_t>(V_STACK_OFFSET, stackOffset, int64_t(0));
    // Optional scalars use vtable presence. A deliberately impossible builder
    // default forces present zero values onto the wire without ForceDefaults.
    if (identityId) {
        fbb.AddElement<uint64_t>(V_IDENTITY_ID, *identityId,
                                 std::numeric_limits<uint64_t>::max());
    }
    if (parameterIndex) {
        fbb.AddElement<uint32_t>(V_PARAMETER_INDEX, *parameterIndex,
                                 std::numeric_limits<uint32_t>::max());
    }
    return TableOff(fbb.EndTable(s));
}

static TableOff emitVarDecl(FBB& fbb, const cast::CVarDecl& v) {
    return emitVariable(fbb, v.varName, v.type.get(), v.storage,
                        v.stackOffset.value_or(0), uint64_t(v.varId),
                        std::nullopt);
}

static TableOff emitParamAsVar(FBB& fbb, const cast::CParamDecl& p) {
    std::optional<uint64_t> identityId;
    if (p.varId)
        identityId = uint64_t(*p.varId);
    return emitVariable(fbb, p.name, p.type.get(),
                        cast::StorageKind::Parameter, 0, identityId,
                        uint32_t(p.index));
}

// ── Expression ─────────────────────────────────────────────────────────────

static TableOff emitExpression(FBB& fbb, const cast::CExpr* expr,
                               NodeIdState& nodeIds) {
    if (!expr) return TableOff{0};

    // Allocate before descending so IDs describe the logical AST preorder,
    // independent of FlatBuffers' bottom-up object construction.
    const uint64_t nodeId = nodeIds.get(expr);

    // Determine ExprKind
    uint8_t kind = exprKindFromNode(expr->getKind());

    // Pre-create children/strings/sub-tables BEFORE StartTable
    StringOff strVal{0};
    StringOff opStr{0};
    TableOff castType{0};
    TableOff varRef{0};
    TableOff resultType = emitDataType(fbb, expr->type.get());
    flatbuffers::Offset<flatbuffers::Vector<TableOff>> childrenVec{0};

    // Values for scalars
    int64_t intVal = 0;
    double floatVal = 0.0;
    std::optional<uint64_t> addrVal;
    std::optional<uint64_t> callTarget;
    std::optional<uint64_t> fieldOffset;

    switch (expr->getKind()) {
    case cast::NodeKind::IntLitExpr: {
        auto* lit = static_cast<const cast::CIntLitExpr*>(expr);
        intVal = lit->value;
        break;
    }
    case cast::NodeKind::FloatLitExpr: {
        auto* lit = static_cast<const cast::CFloatLitExpr*>(expr);
        floatVal = lit->value;
        break;
    }
    case cast::NodeKind::StringLitExpr: {
        auto* lit = static_cast<const cast::CStringLitExpr*>(expr);
        strVal = fbb.CreateString(lit->value);
        break;
    }
    case cast::NodeKind::AddrLitExpr: {
        auto* lit = static_cast<const cast::CAddrLitExpr*>(expr);
        addrVal = lit->addrValue;
        break;
    }
    case cast::NodeKind::VarRefExpr: {
        auto* ref = static_cast<const cast::CVarRefExpr*>(expr);
        strVal = fbb.CreateString(ref->varName);
        varRef = emitVariable(fbb, ref->varName, ref->type.get(),
                              cast::StorageKind::Stack, 0,
                              uint64_t(ref->varId), std::nullopt);
        break;
    }
    case cast::NodeKind::BinaryExpr: {
        auto* bin = static_cast<const cast::CBinaryExpr*>(expr);
        // Children first (recursion happens before StartTable)
        std::vector<TableOff> ch;
        appendIfPresent(ch, emitExpression(fbb, bin->lhs.get(), nodeIds));
        appendIfPresent(ch, emitExpression(fbb, bin->rhs.get(), nodeIds));
        if (!ch.empty()) childrenVec = fbb.CreateVector(ch);
        opStr = fbb.CreateString(binaryOpStr(bin->op));
        break;
    }
    case cast::NodeKind::UnaryExpr: {
        auto* un = static_cast<const cast::CUnaryExpr*>(expr);
        std::vector<TableOff> ch;
        appendIfPresent(ch, emitExpression(fbb, un->operand.get(), nodeIds));
        if (!ch.empty()) childrenVec = fbb.CreateVector(ch);
        opStr = fbb.CreateString(unaryOpStr(un->op));
        break;
    }
    case cast::NodeKind::CastExpr: {
        auto* ce = static_cast<const cast::CCastExpr*>(expr);
        std::vector<TableOff> ch;
        appendIfPresent(ch, emitExpression(fbb, ce->operand.get(), nodeIds));
        if (!ch.empty()) childrenVec = fbb.CreateVector(ch);
        castType = emitDataType(fbb, ce->targetType.get());
        break;
    }
    case cast::NodeKind::CallExpr: {
        auto* call = static_cast<const cast::CCallExpr*>(expr);
        std::vector<TableOff> ch;
        for (auto& arg : call->args)
            appendIfPresent(ch, emitExpression(fbb, arg.get(), nodeIds));
        if (!ch.empty()) childrenVec = fbb.CreateVector(ch);
        strVal = fbb.CreateString(call->targetName);
        if (call->targetAddr != 0)
            callTarget = call->targetAddr;
        break;
    }
    case cast::NodeKind::TernaryExpr: {
        auto* te = static_cast<const cast::CTernaryExpr*>(expr);
        std::vector<TableOff> ch;
        appendIfPresent(ch, emitExpression(fbb, te->cond.get(), nodeIds));
        appendIfPresent(ch, emitExpression(fbb, te->trueVal.get(), nodeIds));
        appendIfPresent(ch, emitExpression(fbb, te->falseVal.get(), nodeIds));
        if (!ch.empty()) childrenVec = fbb.CreateVector(ch);
        break;
    }
    case cast::NodeKind::SubscriptExpr: {
        auto* sub = static_cast<const cast::CSubscriptExpr*>(expr);
        std::vector<TableOff> ch;
        appendIfPresent(ch, emitExpression(fbb, sub->base.get(), nodeIds));
        appendIfPresent(ch, emitExpression(fbb, sub->index.get(), nodeIds));
        if (!ch.empty()) childrenVec = fbb.CreateVector(ch);
        break;
    }
    case cast::NodeKind::FieldAccessExpr: {
        auto* fa = static_cast<const cast::CFieldAccessExpr*>(expr);
        std::vector<TableOff> ch;
        appendIfPresent(ch, emitExpression(fbb, fa->base.get(), nodeIds));
        if (!ch.empty()) childrenVec = fbb.CreateVector(ch);
        strVal = fbb.CreateString(fa->fieldName);
        fieldOffset = fa->fieldOffset;
        // Override kind: Member (9) or DerefMember (10)
        kind = fa->isPointer ? uint8_t(10) : uint8_t(9);
        break;
    }
    default:
        break;
    }

    // Build the Expression table
    auto s = fbb.StartTable();
    fbb.AddElement<uint8_t>(E_KIND, kind, uint8_t(0));
    if (intVal != 0)                fbb.AddElement<int64_t>(E_INT_VALUE, intVal, int64_t(0));
    if (floatVal != 0.0)            fbb.AddElement<double>(E_FLOAT_VALUE, floatVal, 0.0);
    if (!strVal.IsNull())           fbb.AddOffset(E_STRING_VALUE, strVal);
    if (!opStr.IsNull())            fbb.AddOffset(E_OPERATOR, opStr);
    if (!castType.IsNull())         fbb.AddOffset(E_CAST_TYPE, castType);
    if (!childrenVec.IsNull())      fbb.AddOffset(E_CHILDREN, childrenVec);
    if (!varRef.IsNull())           fbb.AddOffset(E_VARIABLE, varRef);
    // Address fields use the inline Address struct, binary-identical to u64.
    if (addrVal) {
        fbb.AddElement<uint64_t>(E_ADDRESS, *addrVal,
                                 std::numeric_limits<uint64_t>::max());
    }
    if (!resultType.IsNull())       fbb.AddOffset(E_RESULT_TYPE, resultType);
    fbb.AddElement<uint64_t>(E_NODE_ID, nodeId, uint64_t(0));
    if (expr->getAddress() != 0) {
        fbb.AddElement<uint64_t>(E_SOURCE_ADDRESS, expr->getAddress(),
                                 uint64_t(0));
    }
    if (callTarget) {
        fbb.AddElement<uint64_t>(E_CALL_TARGET, *callTarget, uint64_t(0));
    }
    if (fieldOffset) {
        fbb.AddElement<uint64_t>(E_FIELD_OFFSET, *fieldOffset,
                                 std::numeric_limits<uint64_t>::max());
    }
    return TableOff(fbb.EndTable(s));
}

// ── Statement ──────────────────────────────────────────────────────────────

/// Flatten BlockStmt children into a single list of Statement offsets.
static std::vector<TableOff> emitStmtList(
    FBB& fbb, const std::vector<cast::StmtPtr>& stmts,
    NodeIdState& nodeIds) {
    std::vector<TableOff> result;
    for (auto& stmt : stmts) {
        if (!stmt) continue;
        if (auto* block = dynamic_cast<cast::CBlockStmt*>(stmt.get())) {
            // Flatten: inline the block's children
            auto inner = emitStmtList(fbb, block->stmts, nodeIds);
            result.insert(result.end(), inner.begin(), inner.end());
        } else {
            auto off = emitStatement(fbb, stmt.get(), nodeIds);
            if (!off.IsNull()) result.push_back(off);
        }
    }
    return result;
}

static TableOff emitStatement(FBB& fbb, const cast::CStmt* stmt,
                              NodeIdState& nodeIds) {
    if (!stmt) return TableOff{0};

    const uint64_t nodeId = nodeIds.get(stmt);
    uint8_t kind = stmtKindFromNode(stmt->getKind());

    // Pre-create everything before StartTable
    TableOff variable{0};
    StringOff text{0};
    flatbuffers::Offset<flatbuffers::Vector<TableOff>> exprsVec{0};
    flatbuffers::Offset<flatbuffers::Vector<TableOff>> childrenVec{0};
    flatbuffers::Offset<flatbuffers::Vector<TableOff>> casesVec{0};
    flatbuffers::Offset<flatbuffers::Vector<uint8_t>> childRolesVec{0};
    std::vector<uint8_t> childRoles;

    switch (stmt->getKind()) {

    // ── VarDecl (serialized as statement) ──
    case cast::NodeKind::VarDecl: {
        auto* v = static_cast<const cast::CVarDecl*>(
            reinterpret_cast<const cast::CAstNode*>(stmt));
        // This is a CVarDecl appearing in the body as a local decl statement.
        // We need to cast carefully — CVarDecl extends CDecl, not CStmt.
        // But in the C AST, local var decls appear in the body vector.
        // The caller handles casting; here we just read the fields.
        break; // handled below in the generic path
    }

    case cast::NodeKind::AssignStmt: {
        auto* a = static_cast<const cast::CAssignStmt*>(stmt);
        std::vector<TableOff> exprs;
        appendIfPresent(exprs,
                        emitExpression(fbb, a->target.get(), nodeIds));
        appendIfPresent(exprs,
                        emitExpression(fbb, a->value.get(), nodeIds));
        if (!exprs.empty()) exprsVec = fbb.CreateVector(exprs);
        if (!a->compoundOp.empty())
            text = fbb.CreateString(a->compoundOp);
        break;
    }

    case cast::NodeKind::ExprStmt: {
        auto* e = static_cast<const cast::CExprStmt*>(stmt);
        std::vector<TableOff> exprs;
        appendIfPresent(exprs,
                        emitExpression(fbb, e->expr.get(), nodeIds));
        if (!exprs.empty()) exprsVec = fbb.CreateVector(exprs);
        break;
    }

    case cast::NodeKind::ReturnStmt: {
        auto* r = static_cast<const cast::CReturnStmt*>(stmt);
        if (r->value) {
            std::vector<TableOff> exprs;
            appendIfPresent(exprs,
                            emitExpression(fbb, r->value.get(), nodeIds));
            exprsVec = fbb.CreateVector(exprs);
        }
        break;
    }

    case cast::NodeKind::IfStmt: {
        auto* ifs = static_cast<const cast::CIfStmt*>(stmt);
        // expressions[0] = condition
        std::vector<TableOff> exprs;
        appendIfPresent(exprs,
                        emitExpression(fbb, ifs->condition.get(), nodeIds));
        if (!exprs.empty()) exprsVec = fbb.CreateVector(exprs);
        // children = then_body ++ else_body
        auto thenOffs = emitStmtList(fbb, ifs->thenBody, nodeIds);
        auto elseOffs = emitStmtList(fbb, ifs->elseBody, nodeIds);
        std::vector<TableOff> allChildren;
        allChildren.insert(allChildren.end(), thenOffs.begin(), thenOffs.end());
        allChildren.insert(allChildren.end(), elseOffs.begin(), elseOffs.end());
        childRoles.insert(childRoles.end(), thenOffs.size(),
                          uint8_t(ChildRole::Then));
        childRoles.insert(childRoles.end(), elseOffs.size(),
                          uint8_t(ChildRole::Else));
        if (!allChildren.empty()) childrenVec = fbb.CreateVector(allChildren);
        // text = number of then-body statements (for adapter to split)
        text = fbb.CreateString(std::to_string(thenOffs.size()));
        break;
    }

    case cast::NodeKind::WhileStmt: {
        auto* w = static_cast<const cast::CWhileStmt*>(stmt);
        std::vector<TableOff> exprs;
        appendIfPresent(exprs,
                        emitExpression(fbb, w->condition.get(), nodeIds));
        if (!exprs.empty()) exprsVec = fbb.CreateVector(exprs);
        auto bodyOffs = emitStmtList(fbb, w->body, nodeIds);
        if (!bodyOffs.empty()) childrenVec = fbb.CreateVector(bodyOffs);
        childRoles.insert(childRoles.end(), bodyOffs.size(),
                          uint8_t(ChildRole::Body));
        break;
    }

    case cast::NodeKind::DoWhileStmt: {
        auto* dw = static_cast<const cast::CDoWhileStmt*>(stmt);
        std::vector<TableOff> exprs;
        appendIfPresent(exprs,
                        emitExpression(fbb, dw->condition.get(), nodeIds));
        if (!exprs.empty()) exprsVec = fbb.CreateVector(exprs);
        auto bodyOffs = emitStmtList(fbb, dw->body, nodeIds);
        if (!bodyOffs.empty()) childrenVec = fbb.CreateVector(bodyOffs);
        childRoles.insert(childRoles.end(), bodyOffs.size(),
                          uint8_t(ChildRole::Body));
        break;
    }

    case cast::NodeKind::ForStmt: {
        auto* f = static_cast<const cast::CForStmt*>(stmt);
        // expressions = [condition] (may be empty if no condition)
        if (f->condition) {
            std::vector<TableOff> exprs;
            appendIfPresent(exprs,
                            emitExpression(fbb, f->condition.get(), nodeIds));
            exprsVec = fbb.CreateVector(exprs);
        }
        // children = [init?, step?, ...body]
        std::vector<TableOff> ch;
        bool hasInit = f->init != nullptr;
        bool hasStep = f->step != nullptr;
        if (hasInit && appendIfPresent(
                ch, emitStatement(fbb, f->init.get(), nodeIds))) {
            childRoles.push_back(uint8_t(ChildRole::Init));
        }
        if (hasStep && appendIfPresent(
                ch, emitStatement(fbb, f->step.get(), nodeIds))) {
            childRoles.push_back(uint8_t(ChildRole::Step));
        }
        auto bodyOffs = emitStmtList(fbb, f->body, nodeIds);
        ch.insert(ch.end(), bodyOffs.begin(), bodyOffs.end());
        childRoles.insert(childRoles.end(), bodyOffs.size(),
                          uint8_t(ChildRole::Body));
        if (!ch.empty()) childrenVec = fbb.CreateVector(ch);
        // text = "has_init,has_step" so the adapter knows the layout
        text = fbb.CreateString(std::format("{},{}", hasInit ? 1 : 0,
                                                      hasStep ? 1 : 0));
        break;
    }

    case cast::NodeKind::SwitchStmt: {
        auto* sw = static_cast<const cast::CSwitchStmt*>(stmt);
        // expressions = [selector]
        std::vector<TableOff> exprs;
        appendIfPresent(exprs,
                        emitExpression(fbb, sw->selector.get(), nodeIds));
        if (!exprs.empty()) exprsVec = fbb.CreateVector(exprs);
        // cases = [SwitchCase, ...]
        std::vector<TableOff> caseOffs;
        for (auto& sc : sw->cases) {
            // Build SwitchCase table
            // Pre-create children
            std::vector<int64_t> vals;
            if (!sc.isDefault)
                vals.push_back(sc.value);
            auto valsVec = fbb.CreateVector(vals);
            auto bodyOffs = emitStmtList(fbb, sc.body, nodeIds);
            auto bodyVec = bodyOffs.empty()
                ? flatbuffers::Offset<flatbuffers::Vector<TableOff>>{0}
                : fbb.CreateVector(bodyOffs);

            auto cs = fbb.StartTable();
            if (!valsVec.IsNull()) fbb.AddOffset(SC_VALUES, valsVec);
            if (!bodyVec.IsNull()) fbb.AddOffset(SC_BODY, bodyVec);
            caseOffs.push_back(TableOff(fbb.EndTable(cs)));
        }
        if (!caseOffs.empty()) casesVec = fbb.CreateVector(caseOffs);
        break;
    }

    case cast::NodeKind::GotoStmt: {
        auto* g = static_cast<const cast::CGotoStmt*>(stmt);
        text = fbb.CreateString(g->label);
        break;
    }

    case cast::NodeKind::LabelStmt: {
        auto* l = static_cast<const cast::CLabelStmt*>(stmt);
        text = fbb.CreateString(l->name);
        break;
    }

    case cast::NodeKind::CommentStmt: {
        auto* c = static_cast<const cast::CCommentStmt*>(stmt);
        text = fbb.CreateString(c->text);
        break;
    }

    case cast::NodeKind::AsmStmt: {
        auto* a = static_cast<const cast::CAsmStmt*>(stmt);
        text = fbb.CreateString(a->text);
        break;
    }

    case cast::NodeKind::BreakStmt:
    case cast::NodeKind::ContinueStmt:
        // Leaf statements — no extra data
        break;

    case cast::NodeKind::BlockStmt: {
        // Shouldn't reach here (emitStmtList flattens BlockStmt),
        // but handle it defensively.
        auto* b = static_cast<const cast::CBlockStmt*>(stmt);
        auto inner = emitStmtList(fbb, b->stmts, nodeIds);
        if (!inner.empty()) childrenVec = fbb.CreateVector(inner);
        childRoles.insert(childRoles.end(), inner.size(),
                          uint8_t(ChildRole::BlockItem));
        kind = 15;
        break;
    }

    default:
        break;
    }

    if (!childRoles.empty())
        childRolesVec = fbb.CreateVector(childRoles);

    // Build the Statement table
    auto s = fbb.StartTable();
    fbb.AddElement<uint8_t>(S_KIND, kind, uint8_t(0));
    if (!variable.IsNull())     fbb.AddOffset(S_VARIABLE, variable);
    if (!exprsVec.IsNull())     fbb.AddOffset(S_EXPRESSIONS, exprsVec);
    if (!childrenVec.IsNull())  fbb.AddOffset(S_CHILDREN, childrenVec);
    if (!casesVec.IsNull())     fbb.AddOffset(S_CASES, casesVec);
    if (!text.IsNull())         fbb.AddOffset(S_TEXT, text);
    fbb.AddElement<uint64_t>(S_NODE_ID, nodeId, uint64_t(0));
    if (stmt->getAddress() != 0) {
        fbb.AddElement<uint64_t>(S_SOURCE_ADDRESS, stmt->getAddress(),
                                 uint64_t(0));
    }
    if (!childRolesVec.IsNull())
        fbb.AddOffset(S_CHILD_ROLES, childRolesVec);
    return TableOff(fbb.EndTable(s));
}

// ── DecompiledFunction ─────────────────────────────────────────────────────

static TableOff emitFunction(FBB& fbb, const cast::CFuncDecl& func,
                             NodeIdState& nodeIds) {
    // 1. Recursively create all child objects
    auto retTypeOff = emitDataType(fbb, func.returnType.get());

    std::vector<TableOff> paramOffs;
    for (auto& p : func.params)
        paramOffs.push_back(emitParamAsVar(fbb, p));

    std::vector<TableOff> localOffs;
    for (auto& lv : func.localVars)
        localOffs.push_back(emitVarDecl(fbb, lv));

    auto bodyOffs = emitStmtList(fbb, func.body, nodeIds);

    // 2. Create strings
    auto nameOff = fbb.CreateString(func.name);
    StringOff ccOff{0};
    if (!func.callingConvention.empty())
        ccOff = fbb.CreateString(func.callingConvention);

    // 3. Create vectors
    auto paramsVec = paramOffs.empty()
        ? flatbuffers::Offset<flatbuffers::Vector<TableOff>>{0}
        : fbb.CreateVector(paramOffs);
    auto localsVec = localOffs.empty()
        ? flatbuffers::Offset<flatbuffers::Vector<TableOff>>{0}
        : fbb.CreateVector(localOffs);
    auto bodyVec = bodyOffs.empty()
        ? flatbuffers::Offset<flatbuffers::Vector<TableOff>>{0}
        : fbb.CreateVector(bodyOffs);

    // 4. Build table
    auto s = fbb.StartTable();
    fbb.AddOffset(F_NAME, nameOff);
    // Address struct { value: uint64 } — binary-identical to a uint64 scalar
    fbb.AddElement<uint64_t>(F_ADDRESS, func.entryAddr,
                             std::numeric_limits<uint64_t>::max());
    if (!retTypeOff.IsNull())  fbb.AddOffset(F_RETURN_TYPE, retTypeOff);
    if (!paramsVec.IsNull())   fbb.AddOffset(F_PARAMS, paramsVec);
    if (!localsVec.IsNull())   fbb.AddOffset(F_LOCALS, localsVec);
    if (!bodyVec.IsNull())     fbb.AddOffset(F_BODY, bodyVec);
    if (!ccOff.IsNull())       fbb.AddOffset(F_CALLING_CONVENTION, ccOff);
    fbb.AddElement<uint8_t>(F_IS_VARIADIC, func.isVariadic ? uint8_t(1) : uint8_t(0), uint8_t(0));
    return TableOff(fbb.EndTable(s));
}

} // anonymous namespace

// ── Public API: C AST → HAST ───────────────────────────────────────────────

std::vector<uint8_t> FlatBufSerializer::serialize(
    const std::vector<std::unique_ptr<cast::CFuncDecl>>& funcs,
    const std::string& moduleName,
    HelixArch arch)
{
    flatbuffers::FlatBufferBuilder fbb(8192);
    NodeIdState nodeIds;

    // Serialize all functions
    std::vector<TableOff> funcOffs;
    for (auto& func : funcs)
        funcOffs.push_back(emitFunction(fbb, *func, nodeIds));

    // Pre-create every root child before starting the AstModule table.
    auto modNameOff = fbb.CreateString(moduleName);
    auto producerOff = fbb.CreateString("hexcore-helix");
    auto versionOff = fbb.CreateString(Engine::version());
    auto capabilitiesVec = fbb.CreateVector(
        kHastCapabilities.data(), kHastCapabilities.size());
    auto funcsVec = funcOffs.empty()
        ? flatbuffers::Offset<flatbuffers::Vector<TableOff>>{0}
        : fbb.CreateVector(funcOffs);

    auto root = fbb.StartTable();
    fbb.AddOffset(M_NAME, modNameOff);
    if (!funcsVec.IsNull()) fbb.AddOffset(M_FUNCTIONS, funcsVec);
    fbb.AddElement<uint16_t>(M_SCHEMA_MAJOR, kHastSchemaMajor, uint16_t(0));
    // Minor zero must still be present: absence means legacy/non-canonical.
    fbb.AddElement<uint16_t>(M_SCHEMA_MINOR, kHastSchemaMinor,
                             std::numeric_limits<uint16_t>::max());
    fbb.AddOffset(M_CAPABILITIES, capabilitiesVec);
    fbb.AddOffset(M_PRODUCER, producerOff);
    fbb.AddOffset(M_VERSION, versionOff);
    fbb.AddElement<uint8_t>(M_ARCH, archToFB(arch), uint8_t(255));
    fbb.AddElement<uint16_t>(M_POINTER_BITS, pointerBitsForArch(arch),
                             uint16_t(0));
    auto rootOff = fbb.EndTable(root);

    fbb.Finish(flatbuffers::Offset<flatbuffers::Table>(rootOff), "HAST");

    auto* ptr = fbb.GetBufferPointer();
    auto size = fbb.GetSize();
    return std::vector<uint8_t>(ptr, ptr + size);
}

#else // !HELIX_HAS_FLATBUFFERS

std::vector<uint8_t> FlatBufSerializer::serialize(
    const std::vector<std::unique_ptr<cast::CFuncDecl>>&,
    const std::string&,
    HelixArch)
{
    // A name-only buffer is syntactically HAST-shaped but semantically false.
    // Fail closed; Pipeline turns this into an explicit emit error.
    return {};
}

#endif // HELIX_HAS_FLATBUFFERS

// ═══════════════════════════════════════════════════════════════════════════════
// Verification
// ═══════════════════════════════════════════════════════════════════════════════

bool FlatBufSerializer::verify(const uint8_t* data, size_t size) {
    if (!data || size < 8)
        return false;
    if (data[4] != 'H' || data[5] != 'A' ||
        data[6] != 'S' || data[7] != 'T') {
        return false;
    }

    auto readU16 = [&](size_t pos, uint16_t& value) {
        if (pos > size || size - pos < sizeof(value))
            return false;
        std::memcpy(&value, data + pos, sizeof(value));
        return true;
    };
    auto readU32 = [&](size_t pos, uint32_t& value) {
        if (pos > size || size - pos < sizeof(value))
            return false;
        std::memcpy(&value, data + pos, sizeof(value));
        return true;
    };
    auto readI32 = [&](size_t pos, int32_t& value) {
        if (pos > size || size - pos < sizeof(value))
            return false;
        std::memcpy(&value, data + pos, sizeof(value));
        return true;
    };

    uint32_t rootOffset = 0;
    if (!readU32(0, rootOffset) || rootOffset > size ||
        size - rootOffset < sizeof(uint32_t)) {
        return false;
    }

    int32_t vtableDistance = 0;
    if (!readI32(rootOffset, vtableDistance)) {
        return false;
    }
    const int64_t vtableSigned =
        int64_t(rootOffset) - int64_t(vtableDistance);
    if (vtableSigned < 0 || uint64_t(vtableSigned) >= size)
        return false;
    const size_t vtable = size_t(vtableSigned);

    uint16_t vtableSize = 0;
    uint16_t objectSize = 0;
    if (!readU16(vtable, vtableSize) ||
        !readU16(vtable + sizeof(uint16_t), objectSize) ||
        vtableSize < 4 || vtable > size || size - vtable < vtableSize ||
        objectSize < sizeof(uint32_t) || objectSize > size - rootOffset) {
        return false;
    }

    auto fieldLocation = [&](uint16_t slot, size_t width)
            -> std::optional<size_t> {
        if (slot > vtableSize || vtableSize - slot < sizeof(uint16_t))
            return std::nullopt;
        uint16_t objectOffset = 0;
        if (!readU16(vtable + slot, objectOffset) || objectOffset == 0 ||
            objectOffset > objectSize || objectSize - objectOffset < width ||
            rootOffset > size || size - rootOffset < objectOffset + width) {
            return std::nullopt;
        }
        return rootOffset + objectOffset;
    };

    auto offsetTarget = [&](uint16_t slot) -> std::optional<size_t> {
        auto location = fieldLocation(slot, sizeof(uint32_t));
        if (!location)
            return std::nullopt;
        uint32_t relative = 0;
        if (!readU32(*location, relative) || relative == 0 ||
            relative > size - *location) {
            return std::nullopt;
        }
        return *location + relative;
    };

    uint16_t schemaMajor = 0;
    uint16_t schemaMinor = 0;
    uint16_t pointerBits = 0;
    auto majorLoc = fieldLocation(12, sizeof(uint16_t));
    auto minorLoc = fieldLocation(14, sizeof(uint16_t));
    auto archLoc = fieldLocation(22, sizeof(uint8_t));
    auto pointerLoc = fieldLocation(24, sizeof(uint16_t));
    if (!majorLoc || !minorLoc || !archLoc || !pointerLoc ||
        !readU16(*majorLoc, schemaMajor) ||
        !readU16(*minorLoc, schemaMinor) ||
        !readU16(*pointerLoc, pointerBits) ||
        schemaMajor != 1 || schemaMinor != 0 ||
        data[*archLoc] > 11 || (pointerBits != 32 && pointerBits != 64)) {
        return false;
    }

    // Canonical negotiation also requires a non-empty capability vector and
    // non-empty producer/version strings. Merely carrying the HAST identifier
    // is no longer sufficient to pass verification.
    auto capabilities = offsetTarget(16);
    auto producer = offsetTarget(18);
    auto version = offsetTarget(20);
    uint32_t capabilityCount = 0;
    uint32_t producerLength = 0;
    uint32_t versionLength = 0;
    if (!capabilities || !producer || !version ||
        !readU32(*capabilities, capabilityCount) || capabilityCount == 0 ||
        capabilityCount > size - *capabilities - sizeof(uint32_t) ||
        !readU32(*producer, producerLength) || producerLength == 0 ||
        producerLength > size - *producer - sizeof(uint32_t) ||
        !readU32(*version, versionLength) || versionLength == 0 ||
        versionLength > size - *version - sizeof(uint32_t)) {
        return false;
    }

    return true;
}
