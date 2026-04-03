/// @file FlatBufSerializer.cpp
/// @brief FlatBuffer serializer: C AST / HelixHigh MLIR → ast.fbs binary.
///
/// Two paths:
///   1. serialize(ModuleOp)           — stub/legacy MLIR walker
///   2. serialize(vector<CFuncDecl>)  — full C AST → HAST  [NEW]
///
/// The C AST path requires HELIX_HAS_FLATBUFFERS (flatbuffers::FlatBufferBuilder).
/// When the library is absent, a minimal stub HAST is produced instead.

#include "helix/emit/FlatBufSerializer.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowOps.h"

// C AST headers
#include "helix/cast/CAstNode.h"
#include "helix/cast/CType.h"
#include "helix/cast/CExpr.h"
#include "helix/cast/CStmt.h"
#include "helix/cast/CDecl.h"

#include "mlir/IR/BuiltinOps.h"

#ifdef HELIX_HAS_FLATBUFFERS
#include <flatbuffers/flatbuffers.h>
#endif

#include <cstring>
#include <format>
#include <string>
#include <vector>

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// MiniFlatBufBuilder — manual builder for the stub MLIR path
// ═══════════════════════════════════════════════════════════════════════════════

namespace {

class MiniFlatBufBuilder {
public:
    void writeU8(uint8_t val) { buf_.push_back(val); }

    void writeU16(uint16_t val) {
        buf_.push_back(val & 0xFF);
        buf_.push_back((val >> 8) & 0xFF);
    }

    void writeU32(uint32_t val) {
        buf_.push_back(val & 0xFF);
        buf_.push_back((val >> 8) & 0xFF);
        buf_.push_back((val >> 16) & 0xFF);
        buf_.push_back((val >> 24) & 0xFF);
    }

    void writeI32(int32_t val) { writeU32(static_cast<uint32_t>(val)); }

    void writeU64(uint64_t val) {
        writeU32(static_cast<uint32_t>(val));
        writeU32(static_cast<uint32_t>(val >> 32));
    }

    uint32_t writeString(const std::string& str) {
        align(4);
        uint32_t offset = static_cast<uint32_t>(buf_.size());
        writeU32(static_cast<uint32_t>(str.size()));
        for (char c : str)
            buf_.push_back(static_cast<uint8_t>(c));
        buf_.push_back(0);
        while (buf_.size() % 4 != 0)
            buf_.push_back(0);
        return offset;
    }

    void align(size_t alignment) {
        while (buf_.size() % alignment != 0)
            buf_.push_back(0);
    }

    uint32_t pos() const { return static_cast<uint32_t>(buf_.size()); }
    std::vector<uint8_t>& buffer() { return buf_; }

private:
    std::vector<uint8_t> buf_;
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// MLIR Path (stub) — serialize(ModuleOp)
// ═══════════════════════════════════════════════════════════════════════════════

std::vector<uint8_t> FlatBufSerializer::serialize(ModuleOp module) {
    MiniFlatBufBuilder builder;

    struct FuncInfo {
        std::string name;
        uint64_t address;
        std::vector<std::string> params;
        std::vector<std::string> locals;
    };
    std::vector<FuncInfo> functions;

    module.walk([&](Operation* op) {
        if (auto func = dyn_cast<helix::high::FuncOp>(op)) {
            FuncInfo info;
            info.name = func.getSymName().str();
            info.address = func.getEntryAddress();
            func.walk([&](helix::high::VarDeclOp decl) {
                auto name = decl.getVarName().str();
                if (decl.getStorage() == helix::high::StorageKind::Parameter)
                    info.params.push_back(name);
                else
                    info.locals.push_back(name);
            });
            functions.push_back(std::move(info));
        }
    });

    builder.writeU32(0); // root offset placeholder
    builder.writeU8('H');
    builder.writeU8('A');
    builder.writeU8('S');
    builder.writeU8('T');
    builder.align(4);

    std::string moduleName = "decompiled_module";
    uint32_t moduleNameOff = builder.writeString(moduleName);

    std::vector<uint32_t> funcNameOffsets;
    for (auto& func : functions)
        funcNameOffsets.push_back(builder.writeString(func.name));

    builder.align(4);
    uint32_t vtablePos = builder.pos();
    builder.writeU16(10);
    builder.writeU16(12);
    builder.writeU16(4);
    builder.writeU16(8);
    builder.writeU16(0);

    builder.align(4);
    uint32_t rootTablePos = builder.pos();
    builder.writeI32(static_cast<int32_t>(rootTablePos - vtablePos));
    builder.writeU32(moduleNameOff > rootTablePos + 4
        ? moduleNameOff - (rootTablePos + 4)
        : (rootTablePos + 4) - moduleNameOff);
    builder.writeU32(0);

    auto& buf = builder.buffer();
    uint32_t rootOff = rootTablePos;
    buf[0] = rootOff & 0xFF;
    buf[1] = (rootOff >> 8) & 0xFF;
    buf[2] = (rootOff >> 16) & 0xFF;
    buf[3] = (rootOff >> 24) & 0xFF;

    return buf;
}

// ═══════════════════════════════════════════════════════════════════════════════
// C AST Path — serialize(vector<CFuncDecl>)
// ═══════════════════════════════════════════════════════════════════════════════
//
// Full serialization of the C AST tree into the HAST FlatBuffer schema.
// Requires the FlatBuffers library (HELIX_HAS_FLATBUFFERS).

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

// Variable: name, type, storage, stack_offset
enum : uint16_t {
    V_NAME = 4, V_TYPE = 6, V_STORAGE = 8, V_STACK_OFFSET = 10,
};

// Expression: kind, int_value, float_value, string_value, operator_,
//             cast_type, children, variable, address
enum : uint16_t {
    E_KIND = 4, E_INT_VALUE = 6, E_FLOAT_VALUE = 8,
    E_STRING_VALUE = 10, E_OPERATOR = 12, E_CAST_TYPE = 14,
    E_CHILDREN = 16, E_VARIABLE = 18, E_ADDRESS = 20,
};

// Statement: kind, variable, expressions, children, cases, text
enum : uint16_t {
    S_KIND = 4, S_VARIABLE = 6, S_EXPRESSIONS = 8,
    S_CHILDREN = 10, S_CASES = 12, S_TEXT = 14,
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

// AstModule: name, functions, global_vars, type_defs
enum : uint16_t {
    M_NAME = 4, M_FUNCTIONS = 6, M_GLOBAL_VARS = 8, M_TYPE_DEFS = 10,
};

// ── Alias for readability ──────────────────────────────────────────────────

using FBB = flatbuffers::FlatBufferBuilder;
using TableOff = flatbuffers::Offset<flatbuffers::Table>;
using StringOff = flatbuffers::Offset<flatbuffers::String>;

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
    case cast::StorageKind::Temporary: return 0; // no Temporary in schema
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
    default:                           return 255;
    }
}

// ── Forward declarations ───────────────────────────────────────────────────

static TableOff emitDataType(FBB& fbb, const cast::CType* type);
static TableOff emitExpression(FBB& fbb, const cast::CExpr* expr);
static TableOff emitStatement(FBB& fbb, const cast::CStmt* stmt);
static std::vector<TableOff> emitStmtList(FBB& fbb, const std::vector<cast::StmtPtr>& stmts);

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
                              int64_t stackOffset) {
    auto typeOff = emitDataType(fbb, type);
    auto nameOff = fbb.CreateString(name);

    auto s = fbb.StartTable();
    fbb.AddOffset(V_NAME, nameOff);
    if (!typeOff.IsNull()) fbb.AddOffset(V_TYPE, typeOff);
    fbb.AddElement<uint8_t>(V_STORAGE, storageKindToFB(storage), uint8_t(0));
    fbb.AddElement<int64_t>(V_STACK_OFFSET, stackOffset, int64_t(0));
    return TableOff(fbb.EndTable(s));
}

static TableOff emitVarDecl(FBB& fbb, const cast::CVarDecl& v) {
    return emitVariable(fbb, v.varName, v.type.get(), v.storage,
                        v.stackOffset.value_or(0));
}

static TableOff emitParamAsVar(FBB& fbb, const cast::CParamDecl& p) {
    return emitVariable(fbb, p.name, p.type.get(),
                        cast::StorageKind::Parameter, 0);
}

// ── Expression ─────────────────────────────────────────────────────────────

static TableOff emitExpression(FBB& fbb, const cast::CExpr* expr) {
    if (!expr) return TableOff{0};

    // Determine ExprKind
    uint8_t kind = exprKindFromNode(expr->getKind());

    // Pre-create children/strings/sub-tables BEFORE StartTable
    StringOff strVal{0};
    StringOff opStr{0};
    TableOff castType{0};
    TableOff varRef{0};
    flatbuffers::Offset<flatbuffers::Vector<TableOff>> childrenVec{0};

    // Values for scalars
    int64_t intVal = 0;
    double floatVal = 0.0;
    uint64_t addrVal = 0;

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
                              cast::StorageKind::Stack, 0);
        break;
    }
    case cast::NodeKind::BinaryExpr: {
        auto* bin = static_cast<const cast::CBinaryExpr*>(expr);
        // Children first (recursion happens before StartTable)
        std::vector<TableOff> ch;
        ch.push_back(emitExpression(fbb, bin->lhs.get()));
        ch.push_back(emitExpression(fbb, bin->rhs.get()));
        childrenVec = fbb.CreateVector(ch);
        opStr = fbb.CreateString(binaryOpStr(bin->op));
        break;
    }
    case cast::NodeKind::UnaryExpr: {
        auto* un = static_cast<const cast::CUnaryExpr*>(expr);
        std::vector<TableOff> ch;
        ch.push_back(emitExpression(fbb, un->operand.get()));
        childrenVec = fbb.CreateVector(ch);
        opStr = fbb.CreateString(unaryOpStr(un->op));
        break;
    }
    case cast::NodeKind::CastExpr: {
        auto* ce = static_cast<const cast::CCastExpr*>(expr);
        std::vector<TableOff> ch;
        ch.push_back(emitExpression(fbb, ce->operand.get()));
        childrenVec = fbb.CreateVector(ch);
        castType = emitDataType(fbb, ce->targetType.get());
        break;
    }
    case cast::NodeKind::CallExpr: {
        auto* call = static_cast<const cast::CCallExpr*>(expr);
        std::vector<TableOff> ch;
        for (auto& arg : call->args)
            ch.push_back(emitExpression(fbb, arg.get()));
        if (!ch.empty()) childrenVec = fbb.CreateVector(ch);
        strVal = fbb.CreateString(call->targetName);
        break;
    }
    case cast::NodeKind::TernaryExpr: {
        auto* te = static_cast<const cast::CTernaryExpr*>(expr);
        std::vector<TableOff> ch;
        ch.push_back(emitExpression(fbb, te->cond.get()));
        ch.push_back(emitExpression(fbb, te->trueVal.get()));
        ch.push_back(emitExpression(fbb, te->falseVal.get()));
        childrenVec = fbb.CreateVector(ch);
        break;
    }
    case cast::NodeKind::SubscriptExpr: {
        auto* sub = static_cast<const cast::CSubscriptExpr*>(expr);
        std::vector<TableOff> ch;
        ch.push_back(emitExpression(fbb, sub->base.get()));
        ch.push_back(emitExpression(fbb, sub->index.get()));
        childrenVec = fbb.CreateVector(ch);
        break;
    }
    case cast::NodeKind::FieldAccessExpr: {
        auto* fa = static_cast<const cast::CFieldAccessExpr*>(expr);
        std::vector<TableOff> ch;
        ch.push_back(emitExpression(fbb, fa->base.get()));
        childrenVec = fbb.CreateVector(ch);
        strVal = fbb.CreateString(fa->fieldName);
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
    // Address field: struct Address { value: uint64 } — binary-identical to uint64 scalar
    if (addrVal != 0)               fbb.AddElement<uint64_t>(E_ADDRESS, addrVal, uint64_t(0));
    return TableOff(fbb.EndTable(s));
}

// ── Statement ──────────────────────────────────────────────────────────────

/// Flatten BlockStmt children into a single list of Statement offsets.
static std::vector<TableOff> emitStmtList(FBB& fbb,
                                           const std::vector<cast::StmtPtr>& stmts) {
    std::vector<TableOff> result;
    for (auto& stmt : stmts) {
        if (!stmt) continue;
        if (auto* block = dynamic_cast<cast::CBlockStmt*>(stmt.get())) {
            // Flatten: inline the block's children
            auto inner = emitStmtList(fbb, block->stmts);
            result.insert(result.end(), inner.begin(), inner.end());
        } else {
            auto off = emitStatement(fbb, stmt.get());
            if (!off.IsNull()) result.push_back(off);
        }
    }
    return result;
}

static TableOff emitStatement(FBB& fbb, const cast::CStmt* stmt) {
    if (!stmt) return TableOff{0};

    uint8_t kind = stmtKindFromNode(stmt->getKind());

    // Pre-create everything before StartTable
    TableOff variable{0};
    StringOff text{0};
    flatbuffers::Offset<flatbuffers::Vector<TableOff>> exprsVec{0};
    flatbuffers::Offset<flatbuffers::Vector<TableOff>> childrenVec{0};
    flatbuffers::Offset<flatbuffers::Vector<TableOff>> casesVec{0};

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
        exprs.push_back(emitExpression(fbb, a->target.get()));
        exprs.push_back(emitExpression(fbb, a->value.get()));
        exprsVec = fbb.CreateVector(exprs);
        if (!a->compoundOp.empty())
            text = fbb.CreateString(a->compoundOp);
        break;
    }

    case cast::NodeKind::ExprStmt: {
        auto* e = static_cast<const cast::CExprStmt*>(stmt);
        std::vector<TableOff> exprs;
        exprs.push_back(emitExpression(fbb, e->expr.get()));
        exprsVec = fbb.CreateVector(exprs);
        break;
    }

    case cast::NodeKind::ReturnStmt: {
        auto* r = static_cast<const cast::CReturnStmt*>(stmt);
        if (r->value) {
            std::vector<TableOff> exprs;
            exprs.push_back(emitExpression(fbb, r->value.get()));
            exprsVec = fbb.CreateVector(exprs);
        }
        break;
    }

    case cast::NodeKind::IfStmt: {
        auto* ifs = static_cast<const cast::CIfStmt*>(stmt);
        // expressions[0] = condition
        std::vector<TableOff> exprs;
        exprs.push_back(emitExpression(fbb, ifs->condition.get()));
        exprsVec = fbb.CreateVector(exprs);
        // children = then_body ++ else_body
        auto thenOffs = emitStmtList(fbb, ifs->thenBody);
        auto elseOffs = emitStmtList(fbb, ifs->elseBody);
        std::vector<TableOff> allChildren;
        allChildren.insert(allChildren.end(), thenOffs.begin(), thenOffs.end());
        allChildren.insert(allChildren.end(), elseOffs.begin(), elseOffs.end());
        if (!allChildren.empty()) childrenVec = fbb.CreateVector(allChildren);
        // text = number of then-body statements (for adapter to split)
        text = fbb.CreateString(std::to_string(thenOffs.size()));
        break;
    }

    case cast::NodeKind::WhileStmt: {
        auto* w = static_cast<const cast::CWhileStmt*>(stmt);
        std::vector<TableOff> exprs;
        exprs.push_back(emitExpression(fbb, w->condition.get()));
        exprsVec = fbb.CreateVector(exprs);
        auto bodyOffs = emitStmtList(fbb, w->body);
        if (!bodyOffs.empty()) childrenVec = fbb.CreateVector(bodyOffs);
        break;
    }

    case cast::NodeKind::DoWhileStmt: {
        auto* dw = static_cast<const cast::CDoWhileStmt*>(stmt);
        std::vector<TableOff> exprs;
        exprs.push_back(emitExpression(fbb, dw->condition.get()));
        exprsVec = fbb.CreateVector(exprs);
        auto bodyOffs = emitStmtList(fbb, dw->body);
        if (!bodyOffs.empty()) childrenVec = fbb.CreateVector(bodyOffs);
        break;
    }

    case cast::NodeKind::ForStmt: {
        auto* f = static_cast<const cast::CForStmt*>(stmt);
        // expressions = [condition] (may be empty if no condition)
        if (f->condition) {
            std::vector<TableOff> exprs;
            exprs.push_back(emitExpression(fbb, f->condition.get()));
            exprsVec = fbb.CreateVector(exprs);
        }
        // children = [init?, step?, ...body]
        std::vector<TableOff> ch;
        bool hasInit = f->init != nullptr;
        bool hasStep = f->step != nullptr;
        if (hasInit) ch.push_back(emitStatement(fbb, f->init.get()));
        if (hasStep) ch.push_back(emitStatement(fbb, f->step.get()));
        auto bodyOffs = emitStmtList(fbb, f->body);
        ch.insert(ch.end(), bodyOffs.begin(), bodyOffs.end());
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
        exprs.push_back(emitExpression(fbb, sw->selector.get()));
        exprsVec = fbb.CreateVector(exprs);
        // cases = [SwitchCase, ...]
        std::vector<TableOff> caseOffs;
        for (auto& sc : sw->cases) {
            // Build SwitchCase table
            // Pre-create children
            std::vector<int64_t> vals;
            if (!sc.isDefault)
                vals.push_back(sc.value);
            auto valsVec = fbb.CreateVector(vals);
            auto bodyOffs = emitStmtList(fbb, sc.body);
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
        auto inner = emitStmtList(fbb, b->stmts);
        if (!inner.empty()) childrenVec = fbb.CreateVector(inner);
        kind = 255; // no BlockStmt kind in schema; fallback
        break;
    }

    default:
        break;
    }

    // Build the Statement table
    auto s = fbb.StartTable();
    fbb.AddElement<uint8_t>(S_KIND, kind, uint8_t(0));
    if (!variable.IsNull())     fbb.AddOffset(S_VARIABLE, variable);
    if (!exprsVec.IsNull())     fbb.AddOffset(S_EXPRESSIONS, exprsVec);
    if (!childrenVec.IsNull())  fbb.AddOffset(S_CHILDREN, childrenVec);
    if (!casesVec.IsNull())     fbb.AddOffset(S_CASES, casesVec);
    if (!text.IsNull())         fbb.AddOffset(S_TEXT, text);
    return TableOff(fbb.EndTable(s));
}

// ── DecompiledFunction ─────────────────────────────────────────────────────

static TableOff emitFunction(FBB& fbb, const cast::CFuncDecl& func) {
    // 1. Recursively create all child objects
    auto retTypeOff = emitDataType(fbb, func.returnType.get());

    std::vector<TableOff> paramOffs;
    for (auto& p : func.params)
        paramOffs.push_back(emitParamAsVar(fbb, p));

    std::vector<TableOff> localOffs;
    for (auto& lv : func.localVars)
        localOffs.push_back(emitVarDecl(fbb, lv));

    auto bodyOffs = emitStmtList(fbb, func.body);

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
    fbb.AddElement<uint64_t>(F_ADDRESS, func.entryAddr, uint64_t(0));
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
    const std::string& moduleName)
{
    flatbuffers::FlatBufferBuilder fbb(8192);

    // Serialize all functions
    std::vector<TableOff> funcOffs;
    for (auto& func : funcs)
        funcOffs.push_back(emitFunction(fbb, *func));

    // Create AstModule
    auto modNameOff = fbb.CreateString(moduleName);
    auto funcsVec = funcOffs.empty()
        ? flatbuffers::Offset<flatbuffers::Vector<TableOff>>{0}
        : fbb.CreateVector(funcOffs);

    auto root = fbb.StartTable();
    fbb.AddOffset(M_NAME, modNameOff);
    if (!funcsVec.IsNull()) fbb.AddOffset(M_FUNCTIONS, funcsVec);
    auto rootOff = fbb.EndTable(root);

    fbb.Finish(flatbuffers::Offset<flatbuffers::Table>(rootOff), "HAST");

    auto* ptr = fbb.GetBufferPointer();
    auto size = fbb.GetSize();
    return std::vector<uint8_t>(ptr, ptr + size);
}

#else // !HELIX_HAS_FLATBUFFERS

std::vector<uint8_t> FlatBufSerializer::serialize(
    const std::vector<std::unique_ptr<cast::CFuncDecl>>& funcs,
    const std::string& moduleName)
{
    // FlatBuffers library not linked — produce a minimal stub HAST
    // containing only the module name. Full serialization requires
    // building with -DHELIX_HAS_FLATBUFFERS.
    MiniFlatBufBuilder builder;
    builder.writeU32(0);
    builder.writeU8('H'); builder.writeU8('A');
    builder.writeU8('S'); builder.writeU8('T');
    builder.align(4);

    uint32_t nameOff = builder.writeString(moduleName);

    builder.align(4);
    uint32_t vtPos = builder.pos();
    builder.writeU16(8);  // vtable size
    builder.writeU16(12); // table size
    builder.writeU16(4);  // name offset
    builder.writeU16(0);  // functions (absent)

    builder.align(4);
    uint32_t rootPos = builder.pos();
    builder.writeI32(static_cast<int32_t>(rootPos - vtPos));
    builder.writeU32(nameOff > rootPos + 4
        ? nameOff - (rootPos + 4) : (rootPos + 4) - nameOff);
    builder.writeU32(0);

    auto& buf = builder.buffer();
    buf[0] = rootPos & 0xFF;
    buf[1] = (rootPos >> 8) & 0xFF;
    buf[2] = (rootPos >> 16) & 0xFF;
    buf[3] = (rootPos >> 24) & 0xFF;
    return buf;
}

#endif // HELIX_HAS_FLATBUFFERS

// ═══════════════════════════════════════════════════════════════════════════════
// Verification
// ═══════════════════════════════════════════════════════════════════════════════

bool FlatBufSerializer::verify(const uint8_t* data, size_t size) {
    if (size < 8)
        return false;
    if (data[4] != 'H' || data[5] != 'A' || data[6] != 'S' || data[7] != 'T')
        return false;
    uint32_t rootOffset = data[0] | (data[1] << 8) | (data[2] << 16) | (data[3] << 24);
    if (rootOffset >= size)
        return false;
    return true;
}
