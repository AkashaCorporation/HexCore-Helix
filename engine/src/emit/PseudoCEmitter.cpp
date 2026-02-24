/// @file PseudoCEmitter.cpp
/// @brief Pseudo-C emitter: walks HelixHigh MLIR and produces C-like source code.
///
/// Format conventions (matching the Rust hir_emitter.rs):
///   - Integer types: int8_t, int16_t, int32_t, int64_t, uint8_t, etc.
///   - Hex literals for values >= 16 or <= -16
///   - Parenthesized binary expressions
///   - Indented block structure with braces
///   - Header comment: "// Decompiled by HexCore Helix"

#include "helix/emit/PseudoCEmitter.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/IR/BuiltinOps.h"

#include "llvm/Support/raw_ostream.h"

#include <format>
#include <string>

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// Public API
// ═══════════════════════════════════════════════════════════════════════════════

std::string PseudoCEmitter::emit(ModuleOp module) {
    std::string result;
    llvm::raw_string_ostream os(result);
    emit(module, os);
    return result;
}

void PseudoCEmitter::emit(ModuleOp module, llvm::raw_ostream& os) {
    emitHeader(os, module);

    // Walk top-level operations looking for helix_high.func ops
    module.walk([&](Operation* op) {
        if (isa<helix::high::FuncOp>(op)) {
            emitFunction(op, os);
        }
    });
}

// ═══════════════════════════════════════════════════════════════════════════════
// Private Implementation
// ═══════════════════════════════════════════════════════════════════════════════

void PseudoCEmitter::emitHeader(llvm::raw_ostream& os, ModuleOp /*module*/) {
    os << "// Decompiled by HexCore Helix\n";
    os << "// Engine version: 0.2.0-mlir\n";
    os << "\n";
}

void PseudoCEmitter::emitFunction(Operation* op, llvm::raw_ostream& os) {
    auto func = cast<helix::high::FuncOp>(op);
    auto funcName = func.getSymName();
    auto entryAddr = func.getEntryAddress();

    // Return type (default to int64_t for now, refined by type propagation)
    bool hasReturnValue = func->hasAttr("has_return_value");
    std::string returnType = hasReturnValue ? "int64_t" : "void";

    // Collect parameters from var.decl ops with Parameter storage
    llvm::SmallVector<std::string> params;
    func.walk([&](helix::high::VarDeclOp decl) {
        if (decl.getStorage() == helix::high::StorageKind::Parameter) {
            auto paramType = "int64_t"; // Default, refined by type propagation
            if (auto inferredType = decl->getAttrOfType<StringAttr>("inferred_type"))
                paramType = inferredType.getValue().str().c_str();
            params.push_back(std::format("{} {}", paramType,
                decl.getVarName().str()));
        }
    });

    // Function signature
    os << std::format("{} {}(", returnType, funcName.str());
    if (params.empty()) {
        os << "void";
    } else {
        for (size_t i = 0; i < params.size(); i++) {
            if (i > 0) os << ", ";
            os << params[i];
        }
    }
    os << ") {\n";

    // Local variable declarations
    func.walk([&](helix::high::VarDeclOp decl) {
        if (decl.getStorage() != helix::high::StorageKind::Parameter) {
            indent(os, 1);
            auto typeStr = "int64_t";
            if (auto inferredType = decl->getAttrOfType<StringAttr>("inferred_type"))
                typeStr = inferredType.getValue().str().c_str();
            os << std::format("{}  {};\n", typeStr, decl.getVarName().str());
        }
    });

    // Body statements
    if (!func.getBody().empty()) {
        emitRegionBody(func.getBody(), os, 1);
    }

    os << "}\n\n";
}

void PseudoCEmitter::emitStatement(Operation* op, llvm::raw_ostream& os,
                                    unsigned depth) {
    // Skip var.decl ops (already emitted at top of function)
    if (isa<helix::high::VarDeclOp>(op))
        return;

    // ─── Assignment ─────────────────────────────────────────────────────
    if (auto assign = dyn_cast<helix::high::AssignOp>(op)) {
        indent(os, depth);
        os << formatExpression(assign.getTarget())
           << " = "
           << formatExpression(assign.getValue());
        // Address comment
        if (auto addr = assign.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
        return;
    }

    // ─── Expression statement (void call, etc.) ─────────────────────────
    if (auto exprStmt = dyn_cast<helix::high::ExprStmtOp>(op)) {
        indent(os, depth);
        os << formatExpression(exprStmt.getExpr()) << ";\n";
        return;
    }

    // ─── If/else ────────────────────────────────────────────────────────
    if (auto ifOp = dyn_cast<helix::high::IfOp>(op)) {
        indent(os, depth);
        os << "if (" << formatExpression(ifOp.getCondition()) << ") {\n";
        emitRegionBody(ifOp.getThenRegion(), os, depth + 1);
        indent(os, depth);
        os << "}";

        if (!ifOp.getElseRegion().empty()) {
            os << " else {\n";
            emitRegionBody(ifOp.getElseRegion(), os, depth + 1);
            indent(os, depth);
            os << "}";
        }
        os << "\n";
        return;
    }

    // ─── While loop ─────────────────────────────────────────────────────
    if (auto whileOp = dyn_cast<helix::high::WhileOp>(op)) {
        indent(os, depth);
        // The condition region yields a value; for now emit a simplified form
        os << "while (/* condition */) {\n";
        emitRegionBody(whileOp.getBodyRegion(), os, depth + 1);
        indent(os, depth);
        os << "}\n";
        return;
    }

    // ─── Do-while loop ──────────────────────────────────────────────────
    if (auto doWhile = dyn_cast<helix::high::DoWhileOp>(op)) {
        indent(os, depth);
        os << "do {\n";
        emitRegionBody(doWhile.getBodyRegion(), os, depth + 1);
        indent(os, depth);
        os << "} while (/* condition */);\n";
        return;
    }

    // ─── For loop ───────────────────────────────────────────────────────
    if (auto forOp = dyn_cast<helix::high::ForOp>(op)) {
        indent(os, depth);
        os << "for (/* init */; /* cond */; /* step */) {\n";
        emitRegionBody(forOp.getBodyRegion(), os, depth + 1);
        indent(os, depth);
        os << "}\n";
        return;
    }

    // ─── Return ─────────────────────────────────────────────────────────
    if (auto ret = dyn_cast<helix::high::ReturnOp>(op)) {
        indent(os, depth);
        if (ret.getValue()) {
            os << "return " << formatExpression(ret.getValue()) << ";\n";
        } else {
            os << "return;\n";
        }
        return;
    }

    // ─── Break / Continue ───────────────────────────────────────────────
    if (isa<helix::high::BreakOp>(op)) {
        indent(os, depth);
        os << "break;\n";
        return;
    }

    if (isa<helix::high::ContinueOp>(op)) {
        indent(os, depth);
        os << "continue;\n";
        return;
    }

    // ─── Goto / Label ───────────────────────────────────────────────────
    if (auto gotoOp = dyn_cast<helix::high::GotoOp>(op)) {
        indent(os, depth);
        os << "goto " << gotoOp.getLabel().str() << ";\n";
        return;
    }

    if (auto label = dyn_cast<helix::high::LabelOp>(op)) {
        // Labels are unindented by one level
        if (depth > 0)
            indent(os, depth - 1);
        os << label.getName().str() << ":\n";
        return;
    }

    // ─── Comment ────────────────────────────────────────────────────────
    if (auto comment = dyn_cast<helix::high::CommentOp>(op)) {
        indent(os, depth);
        os << "// " << comment.getText().str() << "\n";
        return;
    }

    // ─── Inline assembly ────────────────────────────────────────────────
    if (auto asmOp = dyn_cast<helix::high::AsmOp>(op)) {
        indent(os, depth);
        os << "__asm { " << asmOp.getText().str() << " };\n";
        return;
    }

    // ─── HelixLow ops that survived (not yet lowered) ───────────────────
    // Emit register read/write as pseudo-C for any HelixLow ops still present
    if (auto regRead = dyn_cast<helix::low::RegReadOp>(op)) {
        // Don't emit standalone reg.read — they're used as expressions
        return;
    }

    if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(op)) {
        indent(os, depth);
        std::string regName = regWrite.getRegName().str();
        // Lowercase the register name for C-style output
        for (auto& c : regName) c = std::tolower(c);
        os << regName << " = " << formatExpression(regWrite.getValue());
        if (auto addr = regWrite.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
        return;
    }

    if (auto memRead = dyn_cast<helix::low::MemReadOp>(op)) {
        // Memory reads used as expression — skip standalone emission
        return;
    }

    if (auto memWrite = dyn_cast<helix::low::MemWriteOp>(op)) {
        indent(os, depth);
        os << "*(" << formatExpression(memWrite.getAddr()) << ") = "
           << formatExpression(memWrite.getValue());
        if (auto addr = memWrite.getAddress())
            os << std::format(";  // 0x{:x}", *addr);
        else
            os << ";";
        os << "\n";
        return;
    }

    if (auto call = dyn_cast<helix::low::CallOp>(op)) {
        indent(os, depth);
        if (auto name = call.getTargetName()) {
            os << name->str();
        } else {
            os << std::format("sub_{:x}",
                call.getTargetAddr().getType().isInteger(64)
                ? 0ULL : 0ULL);
        }
        os << "();\n";
        return;
    }

    if (auto nop = dyn_cast<helix::low::NopOp>(op)) {
        indent(os, depth);
        os << "// nop";
        if (auto addr = nop.getAddress())
            os << std::format("  // 0x{:x}", *addr);
        os << "\n";
        return;
    }

    // ─── Yield — skip (internal to regions) ─────────────────────────────
    if (isa<helix::high::YieldOp>(op))
        return;

    // Other ops: emit as comment
    // (This handles any ops we haven't specialized for yet)
}

void PseudoCEmitter::emitRegionBody(Region& region, llvm::raw_ostream& os,
                                     unsigned depth) {
    for (auto& block : region) {
        for (auto& op : block.getOperations()) {
            emitStatement(&op, os, depth);
        }
    }
}

std::string PseudoCEmitter::formatExpression(Value val) {
    if (!val)
        return "/* null */";

    auto* defOp = val.getDefiningOp();
    if (!defOp)
        return "/* arg */";

    // ─── Integer literal ────────────────────────────────────────────────
    if (auto intLit = dyn_cast<helix::high::IntLitOp>(defOp)) {
        return formatIntLiteral(intLit.getValue());
    }

    // ─── Variable reference ─────────────────────────────────────────────
    if (auto varRef = dyn_cast<helix::high::VarRefOp>(defOp)) {
        return varRef.getVarName().str();
    }

    // ─── Binary expression ──────────────────────────────────────────────
    if (auto binary = dyn_cast<helix::high::BinaryOp>(defOp)) {
        std::string opStr;
        switch (binary.getOp()) {
        case helix::high::BinaryOpKind::Add:    opStr = "+"; break;
        case helix::high::BinaryOpKind::Sub:    opStr = "-"; break;
        case helix::high::BinaryOpKind::Mul:    opStr = "*"; break;
        case helix::high::BinaryOpKind::Div:    opStr = "/"; break;
        case helix::high::BinaryOpKind::Mod:    opStr = "%"; break;
        case helix::high::BinaryOpKind::Shl:    opStr = "<<"; break;
        case helix::high::BinaryOpKind::Shr:    opStr = ">>"; break;
        case helix::high::BinaryOpKind::Sar:    opStr = ">>"; break;
        case helix::high::BinaryOpKind::BitAnd: opStr = "&"; break;
        case helix::high::BinaryOpKind::BitOr:  opStr = "|"; break;
        case helix::high::BinaryOpKind::BitXor: opStr = "^"; break;
        case helix::high::BinaryOpKind::Eq:     opStr = "=="; break;
        case helix::high::BinaryOpKind::Ne:     opStr = "!="; break;
        case helix::high::BinaryOpKind::Lt:     opStr = "<"; break;
        case helix::high::BinaryOpKind::Le:     opStr = "<="; break;
        case helix::high::BinaryOpKind::Gt:     opStr = ">"; break;
        case helix::high::BinaryOpKind::Ge:     opStr = ">="; break;
        case helix::high::BinaryOpKind::LogAnd: opStr = "&&"; break;
        case helix::high::BinaryOpKind::LogOr:  opStr = "||"; break;
        }
        return std::format("({} {} {})",
            formatExpression(binary.getLhs()),
            opStr,
            formatExpression(binary.getRhs()));
    }

    // ─── Unary expression ───────────────────────────────────────────────
    if (auto unary = dyn_cast<helix::high::UnaryOp>(defOp)) {
        std::string opStr;
        switch (unary.getOp()) {
        case helix::high::UnaryOpKind::Neg:       opStr = "-"; break;
        case helix::high::UnaryOpKind::LogNot:    opStr = "!"; break;
        case helix::high::UnaryOpKind::BitNot:    opStr = "~"; break;
        case helix::high::UnaryOpKind::Deref:     opStr = "*"; break;
        case helix::high::UnaryOpKind::AddressOf: opStr = "&"; break;
        }
        return std::format("({}{})", opStr, formatExpression(unary.getOperand()));
    }

    // ─── Cast expression ────────────────────────────────────────────────
    if (auto cast = dyn_cast<helix::high::CastOp>(defOp)) {
        return std::format("({})({})",
            formatType(cast.getResult().getType()),
            formatExpression(cast.getInput()));
    }

    // ─── Function call expression ───────────────────────────────────────
    if (auto call = dyn_cast<helix::high::CallOp>(defOp)) {
        std::string result = call.getTargetName().str() + "(";
        auto args = call.getArgs();
        for (size_t i = 0; i < args.size(); i++) {
            if (i > 0) result += ", ";
            result += formatExpression(args[i]);
        }
        result += ")";
        return result;
    }

    // ─── Ternary expression ─────────────────────────────────────────────
    if (auto ternary = dyn_cast<helix::high::TernaryOp>(defOp)) {
        return std::format("({} ? {} : {})",
            formatExpression(ternary.getCond()),
            formatExpression(ternary.getTrueVal()),
            formatExpression(ternary.getFalseVal()));
    }

    // ─── Subscript expression ───────────────────────────────────────────
    if (auto sub = dyn_cast<helix::high::SubscriptOp>(defOp)) {
        return std::format("{}[{}]",
            formatExpression(sub.getBase()),
            formatExpression(sub.getIndex()));
    }

    // ─── Field access expression ────────────────────────────────────────
    if (auto field = dyn_cast<helix::high::FieldAccessOp>(defOp)) {
        auto op_str = field.getIsPointer() ? "->" : ".";
        return std::format("{}{}{}",
            formatExpression(field.getBase()),
            op_str,
            field.getFieldName().str());
    }

    // ─── Address literal ────────────────────────────────────────────────
    if (auto addrLit = dyn_cast<helix::high::AddrLitOp>(defOp)) {
        return std::format("0x{:x}", addrLit.getAddrValue());
    }

    // ─── HelixLow fallback expressions ──────────────────────────────────
    if (auto regRead = dyn_cast<helix::low::RegReadOp>(defOp)) {
        std::string name = regRead.getRegName().str();
        for (auto& c : name) c = std::tolower(c);
        return name;
    }

    if (auto memRead = dyn_cast<helix::low::MemReadOp>(defOp)) {
        return std::format("*{}", formatExpression(memRead.getAddr()));
    }

    if (auto binop = dyn_cast<helix::low::BinOp>(defOp)) {
        std::string opStr;
        switch (binop.getKind()) {
        case helix::low::BinOpKind::Add:  opStr = "+"; break;
        case helix::low::BinOpKind::Sub:  opStr = "-"; break;
        case helix::low::BinOpKind::Mul:  opStr = "*"; break;
        case helix::low::BinOpKind::IMul: opStr = "*"; break;
        case helix::low::BinOpKind::Div:  opStr = "/"; break;
        case helix::low::BinOpKind::IDiv: opStr = "/"; break;
        case helix::low::BinOpKind::And:  opStr = "&"; break;
        case helix::low::BinOpKind::Or:   opStr = "|"; break;
        case helix::low::BinOpKind::Xor:  opStr = "^"; break;
        case helix::low::BinOpKind::Shl:  opStr = "<<"; break;
        case helix::low::BinOpKind::Shr:  opStr = ">>"; break;
        case helix::low::BinOpKind::Sar:  opStr = ">>"; break;
        case helix::low::BinOpKind::Rol:  opStr = "<<<"; break;
        case helix::low::BinOpKind::Ror:  opStr = ">>>"; break;
        }
        return std::format("({} {} {})",
            formatExpression(binop.getLhs()),
            opStr,
            formatExpression(binop.getRhs()));
    }

    if (auto lea = dyn_cast<helix::low::LeaOp>(defOp)) {
        auto disp = lea.getDisplacement();
        if (disp != 0) {
            return std::format("({} + {})",
                formatExpression(lea.getBase()),
                formatIntLiteral(disp));
        }
        return formatExpression(lea.getBase());
    }

    // Fallback: use MLIR's built-in printing
    return "/* expr */";
}

std::string PseudoCEmitter::formatType(Type type) {
    if (auto intTy = dyn_cast<IntegerType>(type)) {
        unsigned width = intTy.getWidth();
        switch (width) {
        case 1:  return "bool";
        case 8:  return "int8_t";
        case 16: return "int16_t";
        case 32: return "int32_t";
        case 64: return "int64_t";
        default: return std::format("int{}_t", width);
        }
    }
    if (auto floatTy = dyn_cast<Float32Type>(type))
        return "float";
    if (auto floatTy = dyn_cast<Float64Type>(type))
        return "double";
    return "void";
}

std::string PseudoCEmitter::formatIntLiteral(int64_t value) {
    if (value >= 16 || value <= -16) {
        if (value < 0)
            return std::format("-0x{:x}", static_cast<uint64_t>(-value));
        return std::format("0x{:x}", static_cast<uint64_t>(value));
    }
    return std::format("{}", value);
}

void PseudoCEmitter::indent(llvm::raw_ostream& os, unsigned depth) {
    for (unsigned i = 0; i < depth; i++)
        os << "    ";
}
