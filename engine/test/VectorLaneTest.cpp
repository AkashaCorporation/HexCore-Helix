/// @file VectorLaneTest.cpp
/// @brief Regression tests for scalarized LLVM vector expressions in C AST.

#include "helix/cast/CAstBuilder.h"
#include "helix/cast/CAstPrinter.h"
#include "helix/cast/CStmt.h"
#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/MLIRContext.h"

#include <gtest/gtest.h>

#include <string>

using namespace helix;

TEST(VectorLaneTest, LaneZeroOfScalarizedVectorIsNotSubscripted) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<high::HelixHighDialect>();
    ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto func = builder.create<high::FuncOp>(
        loc, /*sym_name=*/"lane_zero", /*entry_address=*/0x140001000,
        builder.getFunctionType(
            {mlir::VectorType::get({2}, builder.getF32Type())}, {}),
        /*calling_convention=*/mlir::StringAttr{},
        /*is_variadic=*/mlir::UnitAttr{},
        /*arg_attrs=*/mlir::ArrayAttr{}, /*res_attrs=*/mlir::ArrayAttr{});
    auto* block = builder.createBlock(
        &func.getBody(), {}, {mlir::VectorType::get({2}, builder.getF32Type())},
        {loc});
    builder.setInsertionPointToEnd(block);

    auto zero = builder.create<mlir::LLVM::ConstantOp>(
        loc, builder.getI64Type(), builder.getI64IntegerAttr(0));
    auto lane = builder.create<mlir::LLVM::ExtractElementOp>(
        loc, block->getArgument(0), zero.getResult());
    builder.create<high::ReturnOp>(
        loc, lane.getResult(), mlir::IntegerAttr{});

    cast::CAstBuilder astBuilder;
    auto decl = astBuilder.buildFunction(func.getOperation());
    ASSERT_NE(decl, nullptr);

    cast::CAstPrinter printer;
    std::string code = printer.print(*decl);
    EXPECT_NE(code.find("return "), std::string::npos);
    EXPECT_EQ(code.find("[0]"), std::string::npos) << code;
}

TEST(CAstBuilderTest, KeepsDefinitionConsumedByLoopSelfUpdate) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<high::HelixHighDialect>();
    ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto func = builder.create<high::FuncOp>(
        loc, /*sym_name=*/"loop_copy", /*entry_address=*/0x140002000,
        builder.getFunctionType({}, {}),
        /*calling_convention=*/mlir::StringAttr{},
        /*is_variadic=*/mlir::UnitAttr{},
        /*arg_attrs=*/mlir::ArrayAttr{}, /*res_attrs=*/mlir::ArrayAttr{});
    auto* entry = builder.createBlock(&func.getBody());
    builder.setInsertionPointToEnd(entry);

    auto resultDecl = builder.create<high::VarDeclOp>(
        loc, builder.getUI32IntegerAttr(1), builder.getStringAttr("result"),
        high::StorageKindAttr::get(&ctx, high::StorageKind::Register),
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});

    auto loop = builder.create<high::DoWhileOp>(loc, mlir::IntegerAttr{});
    auto* body = builder.createBlock(&loop.getBodyRegion());
    builder.setInsertionPointToEnd(body);
    auto result = builder.create<high::VarRefOp>(
        loc, builder.getI32Type(), resultDecl.getVarId(),
        resultDecl.getVarName(), mlir::IntegerAttr{});
    auto widened = builder.create<mlir::LLVM::ZExtOp>(
        loc, builder.getI64Type(), result.getResult());
    auto temporary = builder.create<high::VarRefOp>(
        loc, builder.getI64Type(), builder.getUI32IntegerAttr(2),
        builder.getStringAttr("v0"), mlir::IntegerAttr{});
    builder.create<high::AssignOp>(
        loc, temporary.getResult(), widened.getResult(), mlir::IntegerAttr{});
    auto oldTemporary = builder.create<high::VarRefOp>(
        loc, builder.getI64Type(), builder.getUI32IntegerAttr(2),
        builder.getStringAttr("v0"), mlir::IntegerAttr{});
    auto shift = builder.create<mlir::LLVM::ConstantOp>(
        loc, builder.getI64Type(), builder.getI64IntegerAttr(5));
    auto shifted = builder.create<mlir::LLVM::ShlOp>(
        loc, oldTemporary.getResult(), shift.getResult());
    auto updatedTemporary = builder.create<high::VarRefOp>(
        loc, builder.getI64Type(), builder.getUI32IntegerAttr(2),
        builder.getStringAttr("v0"), mlir::IntegerAttr{});
    builder.create<high::AssignOp>(
        loc, updatedTemporary.getResult(), shifted.getResult(),
        mlir::IntegerAttr{});
    builder.create<high::YieldOp>(loc, mlir::Value{});

    auto* condition = builder.createBlock(&loop.getCondRegion());
    builder.setInsertionPointToEnd(condition);
    auto keepGoing = builder.create<mlir::LLVM::ConstantOp>(
        loc, builder.getI1Type(), builder.getBoolAttr(false));
    builder.create<high::YieldOp>(loc, keepGoing.getResult());

    builder.setInsertionPointToEnd(entry);
    builder.create<high::ReturnOp>(loc, mlir::Value{}, mlir::IntegerAttr{});

    cast::CAstBuilder astBuilder;
    auto decl = astBuilder.buildFunction(func.getOperation());
    ASSERT_NE(decl, nullptr);
    ASSERT_EQ(decl->body.size(), 2u);
    const auto* doWhile = llvm::dyn_cast<cast::CDoWhileStmt>(
        decl->body.front().get());
    ASSERT_NE(doWhile, nullptr);
    ASSERT_EQ(doWhile->body.size(), 2u);
    const auto* setup = llvm::dyn_cast<cast::CAssignStmt>(
        doWhile->body.front().get());
    ASSERT_NE(setup, nullptr);
    const auto* target = llvm::dyn_cast<cast::CVarRefExpr>(
        setup->target.get());
    ASSERT_NE(target, nullptr);
    EXPECT_EQ(target->varName, "v0");
    const auto* update = llvm::dyn_cast<cast::CAssignStmt>(
        doWhile->body.back().get());
    ASSERT_NE(update, nullptr);
    const auto* updateTarget = llvm::dyn_cast<cast::CVarRefExpr>(
        update->target.get());
    ASSERT_NE(updateTarget, nullptr);
    EXPECT_EQ(updateTarget->varName, "v0");
}

TEST(CAstBuilderTest, ReusesMaterializedSsaValueAfterAssignment) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<high::HelixHighDialect>();
    ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto func = builder.create<high::FuncOp>(
        loc, /*sym_name=*/"materialized_sub", /*entry_address=*/0x140003000,
        builder.getFunctionType({}, {}),
        /*calling_convention=*/mlir::StringAttr{},
        /*is_variadic=*/mlir::UnitAttr{},
        /*arg_attrs=*/mlir::ArrayAttr{}, /*res_attrs=*/mlir::ArrayAttr{});
    auto* entry = builder.createBlock(&func.getBody());
    builder.setInsertionPointToEnd(entry);

    auto resultDecl = builder.create<high::VarDeclOp>(
        loc, builder.getUI32IntegerAttr(1), builder.getStringAttr("result"),
        high::StorageKindAttr::get(&ctx, high::StorageKind::Register),
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    auto oldResult = builder.create<high::VarRefOp>(
        loc, builder.getI64Type(), resultDecl.getVarId(),
        resultDecl.getVarName(), mlir::IntegerAttr{});
    auto one = builder.create<mlir::LLVM::ConstantOp>(
        loc, builder.getI64Type(), builder.getI64IntegerAttr(1));
    auto decremented = builder.create<high::BinaryOp>(
        loc, builder.getI64Type(), high::BinaryOpKind::Sub,
        oldResult.getResult(), one.getResult(), mlir::IntegerAttr{});
    decremented->setAttr("helix.fixed_width_unsigned", builder.getUnitAttr());
    auto target = builder.create<high::VarRefOp>(
        loc, builder.getI64Type(), resultDecl.getVarId(),
        resultDecl.getVarName(), mlir::IntegerAttr{});
    builder.create<high::AssignOp>(
        loc, target.getResult(), decremented.getResult(), mlir::IntegerAttr{});
    auto isZero = builder.create<high::UnaryOp>(
        loc, builder.getI1Type(), high::UnaryOpKind::LogNot,
        decremented.getResult(), mlir::IntegerAttr{});
    auto ifOp = builder.create<high::IfOp>(
        loc, isZero.getResult(), mlir::IntegerAttr{});
    auto* thenBlock = builder.createBlock(&ifOp.getThenRegion());
    builder.setInsertionPointToEnd(thenBlock);
    builder.create<high::YieldOp>(loc, mlir::Value{});
    builder.setInsertionPointToEnd(entry);
    builder.create<high::ReturnOp>(loc, mlir::Value{}, mlir::IntegerAttr{});

    cast::CAstBuilder astBuilder;
    auto decl = astBuilder.buildFunction(func.getOperation());
    ASSERT_NE(decl, nullptr);
    cast::CAstPrinter printer;
    const std::string code = printer.print(*decl);

    EXPECT_NE(code.find("result--;"), std::string::npos) << code;
    EXPECT_NE(code.find("if (!result)"), std::string::npos) << code;
    EXPECT_EQ(code.find("if (!(result - 1))"), std::string::npos) << code;
}
