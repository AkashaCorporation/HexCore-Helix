/// @file StructureControlFlowTest.cpp
/// @brief Contracts for CFG-to-SCF value routing.

#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/passes/Passes.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/UB/IR/UBOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/Pass/PassManager.h"

#include <gtest/gtest.h>

namespace {

TEST(StructureControlFlowTest, PreservesForwardedPhiOperands) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();
    ctx.getOrLoadDialect<mlir::ub::UBDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "phi_diamond", /*entry_address=*/0x1000,
        /*original_name=*/mlir::StringAttr{});

    auto* entry = builder.createBlock(&func.getBody());
    auto* trueBlock = builder.createBlock(&func.getBody());
    auto* falseBlock = builder.createBlock(&func.getBody());
    auto* mergeBlock = builder.createBlock(&func.getBody());
    auto mergeValue = mergeBlock->addArgument(builder.getI64Type(), loc);

    builder.setInsertionPointToStart(entry);
    auto condition = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
    builder.create<helix::low::JccOp>(
        loc, "ne", condition.getResult(), mlir::ValueRange{},
        mlir::ValueRange{}, mlir::IntegerAttr{}, trueBlock, falseBlock);

    builder.setInsertionPointToStart(trueBlock);
    auto trueValue = builder.create<mlir::arith::ConstantIntOp>(loc, 11, 64);
    builder.create<helix::low::JmpOp>(
        loc, mlir::ValueRange{trueValue.getResult()}, mlir::IntegerAttr{},
        mlir::IntegerAttr{}, mergeBlock);

    builder.setInsertionPointToStart(falseBlock);
    auto falseValue = builder.create<mlir::arith::ConstantIntOp>(loc, 22, 64);
    builder.create<helix::low::JmpOp>(
        loc, mlir::ValueRange{falseValue.getResult()}, mlir::IntegerAttr{},
        mlir::IntegerAttr{}, mergeBlock);

    builder.setInsertionPointToStart(mergeBlock);
    builder.create<helix::low::RegWriteOp>(
        loc, mergeValue, "RAX", /*bit_width=*/64, mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createStructureControlFlowPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    unsigned poisonCount = 0;
    unsigned ifCount = 0;
    unsigned routedEleven = 0;
    unsigned routedTwentyTwo = 0;
    module.walk([&](mlir::ub::PoisonOp) { ++poisonCount; });
    module.walk([&](helix::high::IfOp) { ++ifCount; });
    module.walk([&](helix::high::AssignOp assign) {
        if (auto constant = assign.getValue().getDefiningOp<
                mlir::arith::ConstantIntOp>()) {
            if (constant.value() == 11)
                ++routedEleven;
            if (constant.value() == 22)
                ++routedTwentyTwo;
        }
    });

    EXPECT_EQ(poisonCount, 0u);
    EXPECT_EQ(ifCount, 1u);
    EXPECT_EQ(routedEleven, 1u);
    EXPECT_EQ(routedTwentyTwo, 1u);
}

TEST(StructureControlFlowTest, AvoidsStorageForInvariantTupleComponents) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();
    ctx.getOrLoadDialect<mlir::ub::UBDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "invariant_tuple", /*entry_address=*/0x2000,
        /*original_name=*/mlir::StringAttr{});

    auto* entry = builder.createBlock(&func.getBody());
    auto* trueBlock = builder.createBlock(&func.getBody());
    auto* falseBlock = builder.createBlock(&func.getBody());
    auto* mergeBlock = builder.createBlock(&func.getBody());
    auto sameValue = mergeBlock->addArgument(builder.getI64Type(), loc);
    auto sameConstant = mergeBlock->addArgument(builder.getI64Type(), loc);
    auto varyingValue = mergeBlock->addArgument(builder.getI64Type(), loc);

    builder.setInsertionPointToStart(entry);
    auto condition = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
    auto common = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    builder.create<helix::low::JccOp>(
        loc, "ne", condition.getResult(), mlir::ValueRange{},
        mlir::ValueRange{}, mlir::IntegerAttr{}, trueBlock, falseBlock);

    builder.setInsertionPointToStart(trueBlock);
    auto trueFive = builder.create<mlir::arith::ConstantIntOp>(loc, 5, 64);
    auto trueValue = builder.create<mlir::arith::ConstantIntOp>(loc, 11, 64);
    builder.create<helix::low::JmpOp>(
        loc,
        mlir::ValueRange{common.getResult(), trueFive.getResult(),
                         trueValue.getResult()},
        mlir::IntegerAttr{}, mlir::IntegerAttr{}, mergeBlock);

    builder.setInsertionPointToStart(falseBlock);
    auto falseFive = builder.create<mlir::arith::ConstantIntOp>(loc, 5, 64);
    auto falseValue = builder.create<mlir::arith::ConstantIntOp>(loc, 22, 64);
    builder.create<helix::low::JmpOp>(
        loc,
        mlir::ValueRange{common.getResult(), falseFive.getResult(),
                         falseValue.getResult()},
        mlir::IntegerAttr{}, mlir::IntegerAttr{}, mergeBlock);

    builder.setInsertionPointToStart(mergeBlock);
    builder.create<helix::low::RegWriteOp>(
        loc, sameValue, "RAX", /*bit_width=*/64, mlir::IntegerAttr{});
    builder.create<helix::low::RegWriteOp>(
        loc, sameConstant, "RBX", /*bit_width=*/64, mlir::IntegerAttr{});
    builder.create<helix::low::RegWriteOp>(
        loc, varyingValue, "RCX", /*bit_width=*/64, mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createStructureControlFlowPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    unsigned scfResultDecls = 0;
    unsigned scfAssignments = 0;
    unsigned routedEleven = 0;
    unsigned routedTwentyTwo = 0;
    module.walk([&](helix::high::VarDeclOp decl) {
        if (decl.getVarName().starts_with("scf_r"))
            ++scfResultDecls;
    });
    module.walk([&](helix::high::AssignOp assign) {
        auto target = assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
        if (!target || !target.getVarName().starts_with("scf_r"))
            return;
        ++scfAssignments;
        if (auto constant = assign.getValue().getDefiningOp<
                mlir::arith::ConstantIntOp>()) {
            if (constant.value() == 11)
                ++routedEleven;
            if (constant.value() == 22)
                ++routedTwentyTwo;
        }
    });

    EXPECT_EQ(scfResultDecls, 1u);
    EXPECT_EQ(scfAssignments, 2u);
    EXPECT_EQ(routedEleven, 1u);
    EXPECT_EQ(routedTwentyTwo, 1u);
}

TEST(StructureControlFlowTest, AvoidsLoopStorageForPassThroughComponent) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();
    ctx.getOrLoadDialect<mlir::ub::UBDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "invariant_loop_component", /*entry_address=*/0x3000,
        /*original_name=*/mlir::StringAttr{});
    auto* entry = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(entry);

    auto common = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    auto counter = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    llvm::SmallVector<mlir::Type> carriedTypes{
        builder.getI64Type(), builder.getI64Type()};
    auto whileOp = builder.create<mlir::scf::WhileOp>(
        loc, mlir::TypeRange(carriedTypes),
        mlir::ValueRange{common.getResult(), counter.getResult()});

    auto* before = new mlir::Block();
    whileOp.getBefore().push_back(before);
    before->addArguments(carriedTypes,
                         llvm::SmallVector<mlir::Location>(2, loc));
    builder.setInsertionPointToStart(before);
    auto one = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 64);
    auto nextCounter = builder.create<mlir::arith::AddIOp>(
        loc, before->getArgument(1), one.getResult());
    auto keepGoing = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 1);
    builder.create<mlir::scf::ConditionOp>(
        loc, keepGoing.getResult(),
        mlir::ValueRange{before->getArgument(0), nextCounter.getResult()});

    auto* after = new mlir::Block();
    whileOp.getAfter().push_back(after);
    after->addArguments(carriedTypes,
                        llvm::SmallVector<mlir::Location>(2, loc));
    builder.setInsertionPointToStart(after);
    builder.create<mlir::scf::YieldOp>(loc, after->getArguments());

    builder.setInsertionPointAfter(whileOp);
    builder.create<helix::low::RegWriteOp>(
        loc, whileOp.getResult(0), "RAX", /*bit_width=*/64,
        mlir::IntegerAttr{});
    builder.create<helix::low::RegWriteOp>(
        loc, whileOp.getResult(1), "RBX", /*bit_width=*/64,
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createStructureControlFlowPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    unsigned scfWhileDecls = 0;
    unsigned scfWhileAssignments = 0;
    unsigned commonResultWrites = 0;
    module.walk([&](helix::high::VarDeclOp decl) {
        if (decl.getVarName().starts_with("scf_w"))
            ++scfWhileDecls;
    });
    module.walk([&](helix::high::AssignOp assign) {
        auto target = assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
        if (target && target.getVarName().starts_with("scf_w"))
            ++scfWhileAssignments;
    });
    module.walk([&](helix::low::RegWriteOp write) {
        if (write.getRegName() != "RAX")
            return;
        if (auto constant = write.getValue().getDefiningOp<
                mlir::arith::ConstantIntOp>())
            commonResultWrites += constant.value() == 7;
    });

    // One changing component needs a carried var and a shadow; the third
    // variable stores the loop condition. The invariant component needs none.
    EXPECT_EQ(scfWhileDecls, 3u);
    EXPECT_EQ(scfWhileAssignments, 4u);
    EXPECT_EQ(commonResultWrites, 1u);
}

} // namespace
