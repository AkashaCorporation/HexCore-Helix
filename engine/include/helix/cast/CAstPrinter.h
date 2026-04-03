#pragma once

#include "helix/cast/CAstNode.h"
#include "helix/cast/CType.h"

#include <cstdint>
#include <string>

namespace llvm {
class raw_ostream;
} // namespace llvm

namespace helix::cast {

class CExpr;
class CStmt;
class CDecl;
class CFuncDecl;
class CStructDecl;
class CVarDecl;

/// Prints a C AST to text.
///
/// Uses direct dispatch via switch on NodeKind (does NOT use the CRTP visitor).
/// This keeps the printer self-contained and straightforward.
class CAstPrinter {
public:
    /// Print a function declaration to a string.
    std::string print(const CFuncDecl& func);

    /// Print a function declaration to a raw_ostream.
    void print(const CFuncDecl& func, llvm::raw_ostream& os);

private:
    void printExpr(const CExpr& expr, int parentPrec = 0);
    void printStmt(const CStmt& stmt, unsigned depth);
    void printType(const CType& type);
    void printVarDecl(const CVarDecl& decl, unsigned depth);
    void printStructDecl(const CStructDecl& decl);
    void indent(unsigned depth);
    std::string formatIntLiteral(int64_t value);

    /// Returns the C operator precedence for a binary op (higher = tighter binding).
    int binaryOpPrecedence(int op);

    llvm::raw_ostream* os_ = nullptr;
};

} // namespace helix::cast
