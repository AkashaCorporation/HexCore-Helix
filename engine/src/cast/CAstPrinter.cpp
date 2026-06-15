#include "helix/cast/CAstPrinter.h"
#include "helix/cast/CExpr.h"
#include "helix/cast/CStmt.h"
#include "helix/cast/CDecl.h"

#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Format.h"

#include <cassert>
#include <sstream>

namespace helix::cast {

// ── Public API ──────────────────────────────────────────────────────────────

std::string CAstPrinter::print(const CFuncDecl& func) {
    std::string buf;
    llvm::raw_string_ostream stream(buf);
    print(func, stream);
    stream.flush();
    return buf;
}

void CAstPrinter::print(const CFuncDecl& func, llvm::raw_ostream& os) {
    os_ = &os;

    // ── Function header ──────────────────────────────────────────────
    os << "// ─────────────────────────────────────────────────────────────\n";
    os << "// " << func.name;
    if (func.entryAddr != 0) {
        os << " (0x";
        os.write_hex(func.entryAddr);
        os << ")";
    }
    os << "\n";

    // Confidence score
    const char* rating =
        func.confidenceScore > 80.0 ? "High" :
        func.confidenceScore > 50.0 ? "Medium" : "Low";
    os << "// Confidence: "
       << llvm::format("%.1f", func.confidenceScore) << "% ("
       << rating << ")";
    if (!func.callingConvention.empty())
        os << "  |  " << func.callingConvention;
    os << "\n";

    // Issues
    if (!func.confidenceIssues.empty()) {
        os << "// Issues:";
        for (size_t i = 0; i < func.confidenceIssues.size(); ++i) {
            os << (i == 0 ? " " : ", ") << func.confidenceIssues[i];
        }
        os << "\n";
    }
    os << "// ─────────────────────────────────────────────────────────────\n";

    // Return type
    if (func.returnType)
        printType(*func.returnType);
    else
        os << "void";

    os << " " << func.name << "(";

    // Parameters
    for (size_t i = 0; i < func.params.size(); ++i) {
        if (i > 0) os << ", ";
        printType(*func.params[i].type);
        os << " " << func.params[i].name;
    }
    if (func.isVariadic) {
        if (!func.params.empty()) os << ", ";
        os << "...";
    }
    if (func.params.empty() && !func.isVariadic) {
        os << "void";
    }

    os << ")\n{\n";

    // Local variable declarations
    for (const auto& var : func.localVars) {
        printVarDecl(var, 1);
    }
    if (!func.localVars.empty() && !func.body.empty()) {
        indent(0);
        os << "\n";
    }

    // Body statements
    for (const auto& stmt : func.body) {
        printStmt(*stmt, 1);
    }

    os << "}\n";
    os_ = nullptr;
}

// ── Expression printing ─────────────────────────────────────────────────────

// FIX-085 (DREAM-inspired): hard depth guard on the recursive expression
// printer.  Even if the optimizer has been told to refuse propagating
// deeply nested boolean trees (see CAstOptimizer.cpp), a stray malformed
// node from an experimental dialect lowering or a corrupted AST could
// still push the printer's recursion past the OS stack limit and crash
// the entire decompile run.  A counter-bound here means the worst case is
// truncated output, not a process abort.  Threshold of 128 is well above
// any depth that has occurred organically on the stress corpora while
// still being orders of magnitude below the default 1 MiB Windows stack.
namespace {
constexpr unsigned kMaxPrintExprDepth = 128;
thread_local unsigned tlsPrintExprDepth = 0;
struct PrintExprDepthGuard {
    PrintExprDepthGuard() { ++tlsPrintExprDepth; }
    ~PrintExprDepthGuard() { --tlsPrintExprDepth; }
};
} // namespace

void CAstPrinter::printExpr(const CExpr& expr, int parentPrec) {
    assert(os_ && "printExpr called without active ostream");
    auto& os = *os_;

    PrintExprDepthGuard depthGuard;
    if (tlsPrintExprDepth > kMaxPrintExprDepth) {
        os << "/* expr too deep */";
        return;
    }

    switch (expr.getKind()) {
    case NodeKind::IntLitExpr: {
        const auto& e = static_cast<const CIntLitExpr&>(expr);
        os << formatIntLiteral(e.value);
        break;
    }
    case NodeKind::FloatLitExpr: {
        const auto& e = static_cast<const CFloatLitExpr&>(expr);
        // Use snprintf with %g for compactness, but ensure the result
        // contains a decimal point or exponent marker so the literal is
        // unambiguously a floating-point token (not an int).  Append a
        // single-precision suffix when the type is `float`.
        char buf[64];
        std::snprintf(buf, sizeof(buf), "%g", e.value);
        std::string lit(buf);
        if (lit.find('.') == std::string::npos &&
            lit.find('e') == std::string::npos &&
            lit.find('E') == std::string::npos &&
            lit.find('n') == std::string::npos /* nan */ &&
            lit.find('i') == std::string::npos /* inf */) {
            lit += ".0";
        }
        os << lit;
        if (e.type && e.type->kind == TypeKind::Float &&
            e.type->bitWidth == 32) {
            os << "f";
        }
        break;
    }
    case NodeKind::StringLitExpr: {
        const auto& e = static_cast<const CStringLitExpr&>(expr);
        os << "\"" << e.value << "\"";
        break;
    }
    case NodeKind::AddrLitExpr: {
        const auto& e = static_cast<const CAddrLitExpr&>(expr);
        os << "(void*)0x";
        os.write_hex(e.addrValue);
        break;
    }
    case NodeKind::VarRefExpr: {
        const auto& e = static_cast<const CVarRefExpr&>(expr);
        os << e.varName;
        break;
    }
    case NodeKind::BinaryExpr: {
        const auto& e = static_cast<const CBinaryExpr&>(expr);
        int myPrec = binaryOpPrecedence(static_cast<int>(e.op));
        bool needParens = myPrec < parentPrec;
        if (needParens) os << "(";
        printExpr(*e.lhs, myPrec);

        // Operator string
        const char* opStr = " ?? ";
        switch (e.op) {
        case BinaryOp::Add:    opStr = " + "; break;
        case BinaryOp::Sub:    opStr = " - "; break;
        case BinaryOp::Mul:    opStr = " * "; break;
        case BinaryOp::Div:    opStr = " / "; break;
        case BinaryOp::Mod:    opStr = " % "; break;
        case BinaryOp::Shl:    opStr = " << "; break;
        case BinaryOp::Shr:    opStr = " >> "; break;
        case BinaryOp::Sar:    opStr = " >> "; break; // C doesn't distinguish; signed context
        case BinaryOp::BitAnd: opStr = " & "; break;
        case BinaryOp::BitOr:  opStr = " | "; break;
        case BinaryOp::BitXor: opStr = " ^ "; break;
        case BinaryOp::Eq:     opStr = " == "; break;
        case BinaryOp::Ne:     opStr = " != "; break;
        case BinaryOp::Lt:     opStr = " < "; break;
        case BinaryOp::Le:     opStr = " <= "; break;
        case BinaryOp::Gt:     opStr = " > "; break;
        case BinaryOp::Ge:     opStr = " >= "; break;
        case BinaryOp::LogAnd: opStr = " && "; break;
        case BinaryOp::LogOr:  opStr = " || "; break;
        }
        os << opStr;

        // Right operand: use myPrec+1 to enforce left-associativity
        printExpr(*e.rhs, myPrec + 1);
        if (needParens) os << ")";
        break;
    }
    case NodeKind::UnaryExpr: {
        const auto& e = static_cast<const CUnaryExpr&>(expr);
        switch (e.op) {
        case UnaryOp::Neg:       os << "-"; break;
        case UnaryOp::LogNot:    os << "!"; break;
        case UnaryOp::BitNot:    os << "~"; break;
        case UnaryOp::Deref:     os << "*"; break;
        case UnaryOp::AddressOf: os << "&"; break;
        }
        // Unary operators have very high precedence (14)
        printExpr(*e.operand, 14);
        break;
    }
    case NodeKind::CastExpr: {
        const auto& e = static_cast<const CCastExpr&>(expr);
        os << "(";
        printType(*e.targetType);
        os << ")";
        printExpr(*e.operand, 14);
        break;
    }
    case NodeKind::CallExpr: {
        const auto& e = static_cast<const CCallExpr&>(expr);
        os << e.targetName << "(";
        for (size_t i = 0; i < e.args.size(); ++i) {
            if (i > 0) os << ", ";
            printExpr(*e.args[i], 0);
        }
        os << ")";
        break;
    }
    case NodeKind::TernaryExpr: {
        const auto& e = static_cast<const CTernaryExpr&>(expr);
        bool needParens = 2 < parentPrec; // ternary has prec 2
        if (needParens) os << "(";
        printExpr(*e.cond, 3);
        os << " ? ";
        printExpr(*e.trueVal, 0);
        os << " : ";
        printExpr(*e.falseVal, 2);
        if (needParens) os << ")";
        break;
    }
    case NodeKind::SubscriptExpr: {
        const auto& e = static_cast<const CSubscriptExpr&>(expr);
        printExpr(*e.base, 15);
        os << "[";
        printExpr(*e.index, 0);
        os << "]";
        break;
    }
    case NodeKind::FieldAccessExpr: {
        const auto& e = static_cast<const CFieldAccessExpr&>(expr);
        printExpr(*e.base, 15);
        os << (e.isPointer ? "->" : ".");
        os << e.fieldName;
        break;
    }
    default:
        os << "/* unknown expr */";
        break;
    }
}

// ── Statement printing ──────────────────────────────────────────────────────

void CAstPrinter::printStmt(const CStmt& stmt, unsigned depth) {
    assert(os_ && "printStmt called without active ostream");
    auto& os = *os_;

    switch (stmt.getKind()) {
    case NodeKind::AssignStmt: {
        const auto& s = static_cast<const CAssignStmt&>(stmt);
        indent(depth);
        printExpr(*s.target, 0);
        if (s.compoundOp == "++" || s.compoundOp == "--") {
            os << s.compoundOp << ";\n";
            break;
        }
        if (s.compoundOp.empty())
            os << " = ";
        else
            os << " " << s.compoundOp << " ";
        if (s.value)
            printExpr(*s.value, 0);
        else
            os << "/* missing rhs */";
        os << ";\n";
        break;
    }
    case NodeKind::ExprStmt: {
        const auto& s = static_cast<const CExprStmt&>(stmt);
        indent(depth);
        printExpr(*s.expr, 0);
        os << ";\n";
        break;
    }
    case NodeKind::IfStmt: {
        const auto& s = static_cast<const CIfStmt&>(stmt);
        indent(depth);
        os << "if (";
        printExpr(*s.condition, 0);
        os << ") {\n";
        for (const auto& st : s.thenBody)
            printStmt(*st, depth + 1);
        if (!s.elseBody.empty()) {
            indent(depth);
            os << "} else {\n";
            for (const auto& st : s.elseBody)
                printStmt(*st, depth + 1);
        }
        indent(depth);
        os << "}\n";
        break;
    }
    case NodeKind::WhileStmt: {
        const auto& s = static_cast<const CWhileStmt&>(stmt);
        indent(depth);
        os << "while (";
        // Normalize constant non-zero loop condition to "true" for
        // readability: the lift produces "while (-1)" for infinite loops
        // (unconditional jmp), which is legal C but ugly.
        if (s.condition &&
            s.condition->getKind() == NodeKind::IntLitExpr &&
            static_cast<const CIntLitExpr&>(*s.condition).value != 0) {
            os << "true";
        } else {
            printExpr(*s.condition, 0);
        }
        os << ") {\n";
        for (const auto& st : s.body)
            printStmt(*st, depth + 1);
        indent(depth);
        os << "}\n";
        break;
    }
    case NodeKind::DoWhileStmt: {
        const auto& s = static_cast<const CDoWhileStmt&>(stmt);
        indent(depth);
        os << "do {\n";
        for (const auto& st : s.body)
            printStmt(*st, depth + 1);
        indent(depth);
        os << "} while (";
        if (s.condition &&
            s.condition->getKind() == NodeKind::IntLitExpr &&
            static_cast<const CIntLitExpr&>(*s.condition).value != 0) {
            os << "true";
        } else {
            printExpr(*s.condition, 0);
        }
        os << ");\n";
        break;
    }
    case NodeKind::ForStmt: {
        const auto& s = static_cast<const CForStmt&>(stmt);
        indent(depth);
        os << "for (";

        // FIX-083b: s.init and s.step may be CAssignStmt, not CExprStmt.
        // The prior static_cast<CExprStmt&> was UB when the node was an
        // assignment (sibling subclass). Print inline based on actual kind.
        auto printLoopPart = [&](const CStmt& part) {
            if (part.getKind() == NodeKind::AssignStmt) {
                const auto& a = static_cast<const CAssignStmt&>(part);
                if (a.target) printExpr(*a.target, 0);
                if (a.compoundOp == "++" || a.compoundOp == "--") {
                    os << a.compoundOp;
                } else {
                    os << (a.compoundOp.empty() ? " = " : " " + a.compoundOp + " ");
                    if (a.value) printExpr(*a.value, 0);
                }
            } else if (part.getKind() == NodeKind::ExprStmt) {
                printExpr(*static_cast<const CExprStmt&>(part).expr, 0);
            }
        };

        if (s.init) {
            printLoopPart(*s.init);
        }
        os << "; ";
        if (s.condition) {
            if (s.condition->getKind() == NodeKind::IntLitExpr &&
                static_cast<const CIntLitExpr&>(*s.condition).value != 0) {
                os << "true";
            } else {
                printExpr(*s.condition, 0);
            }
        }
        os << "; ";
        if (s.step) {
            printLoopPart(*s.step);
        }
        os << ") {\n";
        for (const auto& st : s.body)
            printStmt(*st, depth + 1);
        indent(depth);
        os << "}\n";
        break;
    }
    case NodeKind::SwitchStmt: {
        const auto& s = static_cast<const CSwitchStmt&>(stmt);
        indent(depth);
        os << "switch (";
        printExpr(*s.selector, 0);
        os << ") {\n";
        for (const auto& c : s.cases) {
            indent(depth);
            if (c.isDefault)
                os << "default:\n";
            else
                os << "case " << c.value << ":\n";
            for (const auto& st : c.body)
                printStmt(*st, depth + 1);
        }
        indent(depth);
        os << "}\n";
        break;
    }
    case NodeKind::ReturnStmt: {
        const auto& s = static_cast<const CReturnStmt&>(stmt);
        indent(depth);
        if (s.value) {
            os << "return ";
            printExpr(*s.value, 0);
            os << ";\n";
        } else {
            os << "return;\n";
        }
        break;
    }
    case NodeKind::GotoStmt: {
        const auto& s = static_cast<const CGotoStmt&>(stmt);
        indent(depth);
        os << "goto " << s.label << ";\n";
        break;
    }
    case NodeKind::LabelStmt: {
        const auto& s = static_cast<const CLabelStmt&>(stmt);
        // Labels are printed at depth-1 (or 0) to stand out
        if (depth > 0)
            indent(depth - 1);
        os << s.name << ":\n";
        break;
    }
    case NodeKind::BreakStmt:
        indent(depth);
        os << "break;\n";
        break;
    case NodeKind::ContinueStmt:
        indent(depth);
        os << "continue;\n";
        break;
    case NodeKind::BlockStmt: {
        const auto& s = static_cast<const CBlockStmt&>(stmt);
        indent(depth);
        os << "{\n";
        for (const auto& st : s.stmts)
            printStmt(*st, depth + 1);
        indent(depth);
        os << "}\n";
        break;
    }
    case NodeKind::CommentStmt: {
        const auto& s = static_cast<const CCommentStmt&>(stmt);
        indent(depth);
        os << "/* " << s.text << " */\n";
        break;
    }
    case NodeKind::AsmStmt: {
        const auto& s = static_cast<const CAsmStmt&>(stmt);
        indent(depth);
        os << "__asm { " << s.text << " }\n";
        break;
    }
    default:
        indent(depth);
        os << "/* unknown stmt */\n";
        break;
    }
}

// ── Type printing ───────────────────────────────────────────────────────────

void CAstPrinter::printType(const CType& type) {
    assert(os_ && "printType called without active ostream");
    *os_ << type.format();
}

void CAstPrinter::printVarDecl(const CVarDecl& decl, unsigned depth) {
    assert(os_ && "printVarDecl called without active ostream");
    auto& os = *os_;

    indent(depth);
    printType(*decl.type);
    os << " " << decl.varName;
    if (decl.initExpr) {
        os << " = ";
        printExpr(*decl.initExpr, 0);
    }
    os << ";";

    // Stack offset annotation
    if (decl.stackOffset.has_value()) {
        os << " /* stack[" << decl.stackOffset.value() << "] */";
    }
    os << "\n";
}

void CAstPrinter::printStructDecl(const CStructDecl& decl) {
    assert(os_ && "printStructDecl called without active ostream");
    auto& os = *os_;

    os << "struct " << decl.name << " {\n";
    for (const auto& field : decl.fields) {
        indent(1);
        printType(*field.type);
        os << " " << field.name << ";";
        if (field.offset != 0) {
            os << " /* offset 0x";
            os.write_hex(field.offset);
            os << " */";
        }
        os << "\n";
    }
    os << "};\n";
}

// ── Utilities ───────────────────────────────────────────────────────────────

void CAstPrinter::indent(unsigned depth) {
    assert(os_ && "indent called without active ostream");
    for (unsigned i = 0; i < depth; ++i)
        *os_ << "    ";
}

std::string CAstPrinter::formatIntLiteral(int64_t value) {
    // Small values: print as decimal
    if (value >= -256 && value <= 256)
        return std::to_string(value);

    // Large values or hex-friendly: print as hex
    if (value >= 0) {
        char buf[32];
        std::snprintf(buf, sizeof(buf), "0x%lX", static_cast<unsigned long>(value));
        return buf;
    }

    // Negative large values: print as decimal
    return std::to_string(value);
}

int CAstPrinter::binaryOpPrecedence(int op) {
    // C operator precedence (higher number = tighter binding)
    switch (static_cast<BinaryOp>(op)) {
    case BinaryOp::LogOr:   return 3;
    case BinaryOp::LogAnd:  return 4;
    case BinaryOp::BitOr:   return 5;
    case BinaryOp::BitXor:  return 6;
    case BinaryOp::BitAnd:  return 7;
    case BinaryOp::Eq:
    case BinaryOp::Ne:      return 8;
    case BinaryOp::Lt:
    case BinaryOp::Le:
    case BinaryOp::Gt:
    case BinaryOp::Ge:      return 9;
    case BinaryOp::Shl:
    case BinaryOp::Shr:
    case BinaryOp::Sar:     return 10;
    case BinaryOp::Add:
    case BinaryOp::Sub:     return 11;
    case BinaryOp::Mul:
    case BinaryOp::Div:
    case BinaryOp::Mod:     return 12;
    }
    return 0;
}

} // namespace helix::cast
