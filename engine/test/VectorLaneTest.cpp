/// @file VectorLaneTest.cpp
/// @brief Regression tests for scalarized LLVM vector expressions in C AST.

#include "helix/cast/CAstBuilder.h"
#include "helix/cast/CAstPrinter.h"
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
        /*calling_convention=*/mlir::StringAttr{},
        /*is_variadic=*/mlir::UnitAttr{});
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
