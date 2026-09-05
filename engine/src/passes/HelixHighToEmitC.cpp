/// @file HelixHighToEmitC.cpp
/// @brief MLIR conversion pass: HelixHigh Dialect → EmitC Dialect.
///
/// Lowers the HelixHigh source-level decompilation IR to the MLIR EmitC
/// dialect, which can then be translated to actual C code using
/// `mlir::emitc::translateToCpp()`.
///
/// This enables the Helix decompiler to leverage MLIR's built-in C code
/// generation infrastructure instead of the custom PseudoCEmitter.
///
/// ## Mapping
///
///   HelixHigh             →  EmitC
///   ─────────────────────────────────────────────
///   int.lit               →  emitc.constant
///   var.decl              →  emitc.variable
///   assign                →  emitc.assign
///   binary Add/Sub/Mul/Div→  emitc.add/sub/mul/div
///   binary (comparison)   →  emitc.cmp
///   unary Deref           →  emitc.apply "*"
///   unary AddressOf       →  emitc.apply "&"
///   call                  →  emitc.call_opaque
///   cast                  →  emitc.cast
///   if                    →  emitc.if
///   for                   →  emitc.for
///   return                →  (function-level return handling)
///
/// Operations without direct EmitC equivalents (while, do_while, switch,
/// goto, label, break, continue) are lowered to emitc.call_opaque with
/// comment-style annotations, or kept as HelixHigh ops for the fallback
/// PseudoCEmitter to handle.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/EmitC/IR/EmitC.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"

#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#include <format>
#include <string>

#define DEBUG_TYPE "helix-high-to-emitc"

using namespace mlir;
using namespace helix;

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// Helper: Create EmitC opaque type from integer type
// ═══════════════════════════════════════════════════════════════════════════════

static emitc::OpaqueType getEmitCType(OpBuilder &builder, Type mlir_type) {
    std::string type_str;
    if (auto int_type = dyn_cast<IntegerType>(mlir_type)) {
        unsigned width = int_type.getWidth();
        switch (width) {
        case 1:  type_str = "bool"; break;
        case 8:  type_str = "int8_t"; break;
        case 16: type_str = "int16_t"; break;
        case 32: type_str = "int32_t"; break;
        case 64: type_str = "int64_t"; break;
        default: type_str = std::format("int{}_t", width); break;
        }
    } else if (auto float_type = dyn_cast<FloatType>(mlir_type)) {
        if (float_type.getWidth() == 32) type_str = "float";
        else if (float_type.getWidth() == 64) type_str = "double";
        else type_str = std::format("float{}", float_type.getWidth());
    } else {
        type_str = "void*";
    }
    return emitc::OpaqueType::get(builder.getContext(), type_str);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Conversion Patterns
// ═══════════════════════════════════════════════════════════════════════════════

/// Convert helix_high.int.lit → emitc.constant
struct IntLitToEmitCConstant : public OpConversionPattern<high::IntLitOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        high::IntLitOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto emitc_type = getEmitCType(rewriter, op.getResult().getType());
        auto attr = emitc::OpaqueAttr::get(
            rewriter.getContext(),
            std::format("{}", op.getValue()));

        auto new_op = rewriter.create<emitc::ConstantOp>(
            op.getLoc(), emitc_type, attr);

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_high.var.decl → emitc.variable
struct VarDeclToEmitCVariable : public OpConversionPattern<high::VarDeclOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        high::VarDeclOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        // Determine the type from init value or default to int64_t
        Type var_type;
        if (auto init = adaptor.getInit())
            var_type = init.getType();
        else
            var_type = rewriter.getI64Type();

        auto emitc_type = getEmitCType(rewriter, var_type);
        auto zero_attr = emitc::OpaqueAttr::get(rewriter.getContext(), "0");

        auto var_op = rewriter.create<emitc::VariableOp>(
            op.getLoc(), emitc_type, zero_attr);

        // If there's an init value, also emit an assignment
        if (auto init = adaptor.getInit()) {
            rewriter.create<emitc::AssignOp>(
                op.getLoc(), var_op.getResult(), init);
        }

        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_high.assign → emitc.assign
struct AssignToEmitCAssign : public OpConversionPattern<high::AssignOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        high::AssignOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.create<emitc::AssignOp>(
            op.getLoc(), adaptor.getTarget(), adaptor.getValue());
        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_high.binary Add → emitc.add (and similar)
struct BinaryAddToEmitC : public OpConversionPattern<high::BinaryOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        high::BinaryOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto result_type = getEmitCType(rewriter, op.getResult().getType());

        switch (op.getOp()) {
        case high::BinaryOpKind::Add: {
            auto new_op = rewriter.create<emitc::AddOp>(
                op.getLoc(), result_type,
                adaptor.getLhs(), adaptor.getRhs());
            rewriter.replaceOp(op, new_op.getResult());
            return success();
        }
        case high::BinaryOpKind::Sub: {
            auto new_op = rewriter.create<emitc::SubOp>(
                op.getLoc(), result_type,
                adaptor.getLhs(), adaptor.getRhs());
            rewriter.replaceOp(op, new_op.getResult());
            return success();
        }
        case high::BinaryOpKind::Mul: {
            auto new_op = rewriter.create<emitc::MulOp>(
                op.getLoc(), result_type,
                adaptor.getLhs(), adaptor.getRhs());
            rewriter.replaceOp(op, new_op.getResult());
            return success();
        }
        case high::BinaryOpKind::Div: {
            auto new_op = rewriter.create<emitc::DivOp>(
                op.getLoc(), result_type,
                adaptor.getLhs(), adaptor.getRhs());
            rewriter.replaceOp(op, new_op.getResult());
            return success();
        }
        case high::BinaryOpKind::Mod: {
            auto new_op = rewriter.create<emitc::RemOp>(
                op.getLoc(), result_type,
                adaptor.getLhs(), adaptor.getRhs());
            rewriter.replaceOp(op, new_op.getResult());
            return success();
        }
        case high::BinaryOpKind::Eq:
        case high::BinaryOpKind::Ne:
        case high::BinaryOpKind::Lt:
        case high::BinaryOpKind::Le:
        case high::BinaryOpKind::Gt:
        case high::BinaryOpKind::Ge: {
            // Map to emitc.cmp
            emitc::CmpPredicate pred;
            switch (op.getOp()) {
            case high::BinaryOpKind::Eq: pred = emitc::CmpPredicate::eq; break;
            case high::BinaryOpKind::Ne: pred = emitc::CmpPredicate::ne; break;
            case high::BinaryOpKind::Lt: pred = emitc::CmpPredicate::lt; break;
            case high::BinaryOpKind::Le: pred = emitc::CmpPredicate::le; break;
            case high::BinaryOpKind::Gt: pred = emitc::CmpPredicate::gt; break;
            case high::BinaryOpKind::Ge: pred = emitc::CmpPredicate::ge; break;
            default: pred = emitc::CmpPredicate::eq; break;
            }
            auto bool_type = getEmitCType(rewriter, rewriter.getI1Type());
            auto new_op = rewriter.create<emitc::CmpOp>(
                op.getLoc(), bool_type, pred,
                adaptor.getLhs(), adaptor.getRhs());
            rewriter.replaceOp(op, new_op.getResult());
            return success();
        }
        default: {
            // For bitwise and logical ops, use emitc.call_opaque
            std::string op_name;
            switch (op.getOp()) {
            case high::BinaryOpKind::BitAnd: op_name = "HELIX_BITAND"; break;
            case high::BinaryOpKind::BitOr:  op_name = "HELIX_BITOR"; break;
            case high::BinaryOpKind::BitXor: op_name = "HELIX_BITXOR"; break;
            case high::BinaryOpKind::Shl:    op_name = "HELIX_SHL"; break;
            case high::BinaryOpKind::Shr:    op_name = "HELIX_SHR"; break;
            case high::BinaryOpKind::Sar:    op_name = "HELIX_SAR"; break;
            case high::BinaryOpKind::LogAnd: op_name = "HELIX_LOGAND"; break;
            case high::BinaryOpKind::LogOr:  op_name = "HELIX_LOGOR"; break;
            case high::BinaryOpKind::Ult:    op_name = "HELIX_ULT"; break;
            case high::BinaryOpKind::Ule:    op_name = "HELIX_ULE"; break;
            case high::BinaryOpKind::Ugt:    op_name = "HELIX_UGT"; break;
            case high::BinaryOpKind::Uge:    op_name = "HELIX_UGE"; break;
            default:                          op_name = "HELIX_BINOP"; break;
            }

            SmallVector<Value> args = {adaptor.getLhs(), adaptor.getRhs()};
            auto new_op = rewriter.create<emitc::CallOpaqueOp>(
                op.getLoc(), result_type, op_name,
                /*args=*/ArrayAttr{}, /*template_args=*/ArrayAttr{},
                args);
            rewriter.replaceOp(op, new_op.getResult(0));
            return success();
        }
        }
    }
};

/// Convert helix_high.unary → emitc.apply (for Deref/AddressOf)
struct UnaryToEmitCApply : public OpConversionPattern<high::UnaryOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        high::UnaryOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto result_type = getEmitCType(rewriter, op.getResult().getType());

        if (op.getOp() == high::UnaryOpKind::Deref) {
            auto new_op = rewriter.create<emitc::ApplyOp>(
                op.getLoc(), result_type,
                rewriter.getStringAttr("*"),
                adaptor.getOperand());
            rewriter.replaceOp(op, new_op.getResult());
            return success();
        }
        if (op.getOp() == high::UnaryOpKind::AddressOf) {
            auto new_op = rewriter.create<emitc::ApplyOp>(
                op.getLoc(), result_type,
                rewriter.getStringAttr("&"),
                adaptor.getOperand());
            rewriter.replaceOp(op, new_op.getResult());
            return success();
        }

        // Neg, LogNot, BitNot → call_opaque
        std::string op_name;
        switch (op.getOp()) {
        case high::UnaryOpKind::Neg:    op_name = "HELIX_NEG"; break;
        case high::UnaryOpKind::LogNot: op_name = "HELIX_LOGNOT"; break;
        case high::UnaryOpKind::BitNot: op_name = "HELIX_BITNOT"; break;
        default:                         op_name = "HELIX_UNOP"; break;
        }

        SmallVector<Value> args = {adaptor.getOperand()};
        auto new_op = rewriter.create<emitc::CallOpaqueOp>(
            op.getLoc(), result_type, op_name,
            /*args=*/ArrayAttr{}, /*template_args=*/ArrayAttr{},
            args);
        rewriter.replaceOp(op, new_op.getResult(0));
        return success();
    }
};

/// Convert helix_high.call → emitc.call_opaque
struct CallToEmitCCallOpaque : public OpConversionPattern<high::CallOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        high::CallOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        std::string callee = op.getTargetName().str();

        if (op.getNumResults() > 0) {
            auto result_type = getEmitCType(rewriter, op.getResult().getType());
            auto new_op = rewriter.create<emitc::CallOpaqueOp>(
                op.getLoc(), result_type, callee,
                /*args=*/ArrayAttr{}, /*template_args=*/ArrayAttr{},
                adaptor.getArgs());
            rewriter.replaceOp(op, new_op.getResult(0));
        } else {
            auto void_type = emitc::OpaqueType::get(
                rewriter.getContext(), "void");
            rewriter.create<emitc::CallOpaqueOp>(
                op.getLoc(), void_type, callee,
                /*args=*/ArrayAttr{}, /*template_args=*/ArrayAttr{},
                adaptor.getArgs());
            rewriter.eraseOp(op);
        }
        return success();
    }
};

/// Convert helix_high.cast → emitc.cast
struct CastToEmitCCast : public OpConversionPattern<high::CastOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        high::CastOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto result_type = getEmitCType(rewriter, op.getResult().getType());
        auto new_op = rewriter.create<emitc::CastOp>(
            op.getLoc(), result_type, adaptor.getInput());
        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_high.if → emitc.if
struct IfToEmitCIf : public OpConversionPattern<high::IfOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        high::IfOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        bool has_else = !op.getElseRegion().empty();

        auto new_op = rewriter.create<emitc::IfOp>(
            op.getLoc(), adaptor.getCondition(),
            has_else);

        // Move then region
        rewriter.inlineRegionBefore(
            op.getThenRegion(), new_op.getThenRegion(),
            new_op.getThenRegion().end());

        // Move else region (if present)
        if (has_else) {
            rewriter.inlineRegionBefore(
                op.getElseRegion(), new_op.getElseRegion(),
                new_op.getElseRegion().end());
        }

        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_high.var.ref → emitc.literal (variable name reference)
struct VarRefToEmitCLiteral : public OpConversionPattern<high::VarRefOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        high::VarRefOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto emitc_type = getEmitCType(rewriter, op.getResult().getType());
        auto new_op = rewriter.create<emitc::LiteralOp>(
            op.getLoc(), emitc_type,
            rewriter.getStringAttr(op.getVarName()));

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_high.addr.lit → emitc.constant
struct AddrLitToEmitCConstant : public OpConversionPattern<high::AddrLitOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        high::AddrLitOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto emitc_type = getEmitCType(rewriter, op.getResult().getType());
        auto attr = emitc::OpaqueAttr::get(
            rewriter.getContext(),
            std::format("0x{:X}", op.getAddrValue()));

        auto new_op = rewriter.create<emitc::ConstantOp>(
            op.getLoc(), emitc_type, attr);
        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_high.ternary → emitc.expression with conditional
struct TernaryToEmitCExpression : public OpConversionPattern<high::TernaryOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        high::TernaryOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        // EmitC doesn't have a direct ternary op.
        // Use call_opaque as a workaround: HELIX_TERNARY(cond, a, b)
        auto result_type = getEmitCType(rewriter, op.getResult().getType());
        SmallVector<Value> args = {
            adaptor.getCond(), adaptor.getTrueVal(), adaptor.getFalseVal()
        };
        auto new_op = rewriter.create<emitc::CallOpaqueOp>(
            op.getLoc(), result_type, "HELIX_TERNARY",
            /*args=*/ArrayAttr{}, /*template_args=*/ArrayAttr{},
            args);
        rewriter.replaceOp(op, new_op.getResult(0));
        return success();
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Definition
// ═══════════════════════════════════════════════════════════════════════════════

struct HelixHighToEmitCPass
    : public PassWrapper<HelixHighToEmitCPass, OperationPass<ModuleOp>>
{
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(HelixHighToEmitCPass)

    StringRef getArgument() const final { return "helix-high-to-emitc"; }
    StringRef getDescription() const final {
        return "Convert HelixHigh dialect to MLIR EmitC dialect";
    }

    void getDependentDialects(DialectRegistry &registry) const override {
        registry.insert<emitc::EmitCDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();
        auto *ctx = &getContext();

        ConversionTarget target(*ctx);
        target.addLegalDialect<emitc::EmitCDialect>();
        target.addLegalDialect<mlir::arith::ArithDialect>();

        // HelixHigh ops that we can convert are illegal
        target.addIllegalOp<
            high::IntLitOp,
            high::VarDeclOp,
            high::AssignOp,
            high::BinaryOp,
            high::UnaryOp,
            high::CallOp,
            high::CastOp,
            high::IfOp,
            high::VarRefOp,
            high::AddrLitOp,
            high::TernaryOp
        >();

        // Keep ops that don't have direct EmitC equivalents as legal
        // (they'll be handled by the PseudoCEmitter fallback)
        target.addLegalOp<
            high::WhileOp,
            high::DoWhileOp,
            high::ForOp,
            high::SwitchOp,
            high::ReturnOp,
            high::BreakOp,
            high::ContinueOp,
            high::GotoOp,
            high::LabelOp,
            high::YieldOp,
            high::CommentOp,
            high::AsmOp,
            high::FuncOp,
            high::ModuleOp,
            high::ExprStmtOp,
            high::SubscriptOp,
            high::FieldAccessOp,
            high::FloatLitOp,
            high::StringLitOp
        >();

        RewritePatternSet patterns(ctx);
        patterns.add<
            IntLitToEmitCConstant,
            VarDeclToEmitCVariable,
            AssignToEmitCAssign,
            BinaryAddToEmitC,
            UnaryToEmitCApply,
            CallToEmitCCallOpaque,
            CastToEmitCCast,
            IfToEmitCIf,
            VarRefToEmitCLiteral,
            AddrLitToEmitCConstant,
            TernaryToEmitCExpression
        >(ctx);

        if (failed(applyPartialConversion(module, target, std::move(patterns)))) {
            LLVM_DEBUG(llvm::dbgs() << "HelixHighToEmitC: partial conversion "
                                    << "completed with unconverted ops\n");
        }
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createHelixHighToEmitCPass() {
    return std::make_unique<HelixHighToEmitCPass>();
}
