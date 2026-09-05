/// @file StructureControlFlowTest.cpp
/// @brief Contracts for CFG-to-SCF value routing.

#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/passes/Passes.h"
#include "helix/cast/CAstBuilder.h"
#include "helix/cast/CAstPrinter.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/UB/IR/UBOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Verifier.h"
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

TEST(StructureControlFlowTest, DefersScfBridgeUntilSourceLegalization) {
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
        loc, "deferred_diamond", /*entry_address=*/0x4000,
        /*original_name=*/mlir::StringAttr{});
    auto* entry = builder.createBlock(&func.getBody());
    auto* trueBlock = builder.createBlock(&func.getBody());
    auto* falseBlock = builder.createBlock(&func.getBody());
    auto* mergeBlock = builder.createBlock(&func.getBody());

    builder.setInsertionPointToStart(entry);
    auto condition = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
    builder.create<helix::low::JccOp>(
        loc, "ne", condition.getResult(), mlir::ValueRange{},
        mlir::ValueRange{}, mlir::IntegerAttr{}, trueBlock, falseBlock);
    builder.setInsertionPointToStart(trueBlock);
    builder.create<helix::low::JmpOp>(
        loc, mlir::ValueRange{}, mlir::IntegerAttr{}, mlir::IntegerAttr{},
        mergeBlock);
    builder.setInsertionPointToStart(falseBlock);
    builder.create<helix::low::JmpOp>(
        loc, mlir::ValueRange{}, mlir::IntegerAttr{}, mlir::IntegerAttr{},
        mergeBlock);
    builder.setInsertionPointToStart(mergeBlock);
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager structure(&ctx);
    structure.enableVerifier(true);
    structure.addPass(helix::createStructureControlFlowPass(
        /*preserveCfg=*/false, /*bridgeToHigh=*/false));
    ASSERT_TRUE(mlir::succeeded(structure.run(module)));

    unsigned nativeIfs = 0;
    unsigned highIfs = 0;
    module.walk([&](mlir::scf::IfOp) { ++nativeIfs; });
    module.walk([&](helix::high::IfOp) { ++highIfs; });
    EXPECT_EQ(nativeIfs, 1u);
    EXPECT_EQ(highIfs, 0u);

    mlir::PassManager legalize(&ctx);
    legalize.enableVerifier(true);
    legalize.addPass(helix::createBridgeStructuredControlFlowPass());
    ASSERT_TRUE(mlir::succeeded(legalize.run(module)));

    nativeIfs = 0;
    highIfs = 0;
    module.walk([&](mlir::scf::IfOp) { ++nativeIfs; });
    module.walk([&](helix::high::IfOp) { ++highIfs; });
    EXPECT_EQ(nativeIfs, 0u);
    EXPECT_EQ(highIfs, 1u);
}

TEST(StructureControlFlowTest, ErasesUnreachableCycleWithoutDroppingUses) {
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
        loc, "unreachable_cycle", /*entry_address=*/0x5000,
        /*original_name=*/mlir::StringAttr{});
    auto* entry = builder.createBlock(&func.getBody());
    auto* dead = builder.createBlock(&func.getBody());

    builder.setInsertionPointToStart(entry);
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    builder.setInsertionPointToStart(dead);
    auto one = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 64);
    builder.create<mlir::arith::AddIOp>(
        loc, one.getResult(), one.getResult());
    builder.create<helix::low::JmpOp>(
        loc, mlir::ValueRange{}, mlir::IntegerAttr{}, mlir::IntegerAttr{},
        dead);

    mlir::PassManager manager(&ctx);
    manager.enableVerifier(true);
    manager.addPass(helix::createStructureControlFlowPass(
        /*preserveCfg=*/false, /*bridgeToHigh=*/false));
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));
    EXPECT_EQ(std::distance(func.getBody().begin(), func.getBody().end()), 1);
    EXPECT_TRUE(mlir::succeeded(mlir::verify(module)));
}

TEST(StructureControlFlowTest, BridgesCanonicalAsymmetricWhileResult) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "asymmetric_while", /*entry_address=*/0x6000,
        /*original_name=*/mlir::StringAttr{});
    auto* entry = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(entry);

    auto whileOp = builder.create<mlir::scf::WhileOp>(
        loc, mlir::TypeRange{builder.getI32Type()}, mlir::ValueRange{});
    auto* before = new mlir::Block();
    whileOp.getBefore().push_back(before);
    builder.setInsertionPointToStart(before);
    auto stop = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 1);
    auto exitValue = builder.create<mlir::arith::ConstantIntOp>(loc, 42, 32);
    builder.create<mlir::scf::ConditionOp>(
        loc, stop.getResult(), mlir::ValueRange{exitValue.getResult()});

    auto* after = new mlir::Block();
    whileOp.getAfter().push_back(after);
    after->addArgument(builder.getI32Type(), loc);
    builder.setInsertionPointToStart(after);
    builder.create<mlir::scf::YieldOp>(loc);

    builder.setInsertionPointAfter(whileOp);
    builder.create<helix::low::RegWriteOp>(
        loc, whileOp.getResult(0), "EAX", /*bit_width=*/32,
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    mlir::PassManager manager(&ctx);
    manager.enableVerifier(true);
    manager.addPass(helix::createBridgeStructuredControlFlowPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    unsigned nativeLoops = 0, highLoops = 0, routedResults = 0;
    module.walk([&](mlir::scf::WhileOp) { ++nativeLoops; });
    module.walk([&](helix::high::DoWhileOp) { ++highLoops; });
    module.walk([&](helix::low::RegWriteOp write) {
        if (write.getValue().getDefiningOp<helix::high::VarRefOp>())
            ++routedResults;
    });
    EXPECT_EQ(nativeLoops, 0u);
    EXPECT_EQ(highLoops, 1u);
    EXPECT_EQ(routedResults, 1u);
    EXPECT_TRUE(mlir::succeeded(mlir::verify(module)));
}

TEST(StructureControlFlowTest, CastLegalizesNativeScfIfResultsDirectly) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::high::FuncOp>(
        loc, "direct_scf_if", /*entry_address=*/0x7000,
        builder.getFunctionType({}, {builder.getI64Type()}),
        mlir::StringAttr{}, mlir::UnitAttr{},
        mlir::ArrayAttr{}, mlir::ArrayAttr{});
    function->setAttr("has_return_value", builder.getUnitAttr());
    function->setAttr("helix.signature_complete", builder.getBoolAttr(true));
    auto* entry = builder.createBlock(&function.getBody());
    builder.setInsertionPointToStart(entry);
    auto condition = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
    auto ifOp = builder.create<mlir::scf::IfOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, condition,
        /*withElseRegion=*/true);
    builder.setInsertionPointToStart(&ifOp.getThenRegion().front());
    auto eleven = builder.create<mlir::arith::ConstantIntOp>(loc, 11, 64);
    builder.create<mlir::scf::YieldOp>(loc, eleven.getResult());
    builder.setInsertionPointToStart(&ifOp.getElseRegion().front());
    auto twentyTwo = builder.create<mlir::arith::ConstantIntOp>(loc, 22, 64);
    builder.create<mlir::scf::YieldOp>(loc, twentyTwo.getResult());
    builder.setInsertionPointAfter(ifOp);
    builder.create<helix::high::ReturnOp>(
        loc, ifOp.getResult(0), mlir::IntegerAttr{});

    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 1u);
    helix::cast::CAstPrinter printer;
    std::string output = printer.print(*functions.front());
    EXPECT_NE(output.find("int64_t scf_r950000"), std::string::npos);
    EXPECT_NE(output.find("if ("), std::string::npos) << output;
    EXPECT_NE(output.find("scf_r950000 = 11"), std::string::npos);
    EXPECT_NE(output.find("scf_r950000 = 22"), std::string::npos);
    EXPECT_NE(output.find("return scf_r950000"), std::string::npos);
    EXPECT_EQ(output.find("__helix_unhandled_scf"), std::string::npos);
}

TEST(StructureControlFlowTest, CastLegalizesNativeScfIndexSwitchDirectly) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::high::FuncOp>(
        loc, "direct_scf_switch", /*entry_address=*/0x7100,
        builder.getFunctionType({}, {builder.getI64Type()}),
        mlir::StringAttr{}, mlir::UnitAttr{},
        mlir::ArrayAttr{}, mlir::ArrayAttr{});
    function->setAttr("has_return_value", builder.getUnitAttr());
    function->setAttr("helix.signature_complete", builder.getBoolAttr(true));
    auto* entry = builder.createBlock(&function.getBody());
    builder.setInsertionPointToStart(entry);
    auto selector = builder.create<mlir::arith::ConstantIndexOp>(loc, 5);
    auto switchOp = builder.create<mlir::scf::IndexSwitchOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, selector,
        llvm::ArrayRef<int64_t>{2, 5}, /*caseRegionsCount=*/2);

    auto addYieldingBlock = [&](mlir::Region& region, int64_t value) {
        auto* block = builder.createBlock(&region);
        builder.setInsertionPointToStart(block);
        auto constant = builder.create<mlir::arith::ConstantIntOp>(
            loc, value, 64);
        builder.create<mlir::scf::YieldOp>(loc, constant.getResult());
    };
    addYieldingBlock(switchOp.getCaseRegions()[0], 20);
    addYieldingBlock(switchOp.getCaseRegions()[1], 50);
    addYieldingBlock(switchOp.getDefaultRegion(), 99);
    builder.setInsertionPointAfter(switchOp);
    builder.create<helix::high::ReturnOp>(
        loc, switchOp.getResult(0), mlir::IntegerAttr{});

    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 1u);
    helix::cast::CAstPrinter printer;
    std::string output = printer.print(*functions.front());
    EXPECT_NE(output.find("int64_t scf_r950000"), std::string::npos);
    EXPECT_NE(output.find("switch (5)"), std::string::npos) << output;
    EXPECT_NE(output.find("case 2:"), std::string::npos);
    EXPECT_NE(output.find("scf_r950000 = 20"), std::string::npos);
    EXPECT_NE(output.find("case 5:"), std::string::npos);
    EXPECT_NE(output.find("scf_r950000 = 50"), std::string::npos);
    EXPECT_NE(output.find("default:"), std::string::npos);
    EXPECT_NE(output.find("scf_r950000 = 99"), std::string::npos);
    EXPECT_NE(output.find("return scf_r950000"), std::string::npos);
    EXPECT_EQ(output.find("__helix_unhandled_scf"), std::string::npos);
}

TEST(StructureControlFlowTest, CastLegalizesNativeScfWhileStateDirectly) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::high::FuncOp>(
        loc, "direct_scf_while", /*entry_address=*/0x7200,
        builder.getFunctionType({}, {builder.getI64Type()}),
        mlir::StringAttr{}, mlir::UnitAttr{},
        mlir::ArrayAttr{}, mlir::ArrayAttr{});
    function->setAttr("has_return_value", builder.getUnitAttr());
    function->setAttr("helix.signature_complete", builder.getBoolAttr(true));
    auto* entry = builder.createBlock(&function.getBody());
    builder.setInsertionPointToStart(entry);
    auto zero = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    auto whileOp = builder.create<mlir::scf::WhileOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, zero.getResult());

    auto* before = builder.createBlock(&whileOp.getBefore());
    auto counter = before->addArgument(builder.getI64Type(), loc);
    builder.setInsertionPointToStart(before);
    auto one = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 64);
    auto next = builder.create<mlir::arith::AddIOp>(
        loc, counter, one.getResult());
    auto three = builder.create<mlir::arith::ConstantIntOp>(loc, 3, 64);
    auto keepGoing = builder.create<mlir::arith::CmpIOp>(
        loc, mlir::arith::CmpIPredicate::slt, next, three);
    builder.create<mlir::scf::ConditionOp>(
        loc, keepGoing, mlir::ValueRange{next});

    auto* after = builder.createBlock(&whileOp.getAfter());
    after->addArgument(builder.getI64Type(), loc);
    builder.setInsertionPointToStart(after);
    builder.create<mlir::scf::YieldOp>(loc, after->getArguments());
    builder.setInsertionPointAfter(whileOp);
    builder.create<helix::high::ReturnOp>(
        loc, whileOp.getResult(0), mlir::IntegerAttr{});

    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 1u);
    helix::cast::CAstPrinter printer;
    std::string output = printer.print(*functions.front());
    EXPECT_NE(output.find("do {"), std::string::npos) << output;
    EXPECT_NE(output.find("scf_w950000 = 0"), std::string::npos);
    EXPECT_NE(output.find("scf_r950001 = scf_w950000 + 1"),
              std::string::npos) << output;
    EXPECT_NE(output.find("scf_w950000 = scf_r950001"),
              std::string::npos);
    EXPECT_NE(output.find("while (scf_w950002)"), std::string::npos);
    EXPECT_NE(output.find("return scf_r950001"), std::string::npos);
    EXPECT_EQ(output.find("block_arg"), std::string::npos);
    EXPECT_EQ(output.find("__helix_unhandled_scf"), std::string::npos);
}

TEST(StructureControlFlowTest, CastLegalizesAsymmetricNativeScfWhileDirectly) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::high::FuncOp>(
        loc, "direct_asymmetric_while", /*entry_address=*/0x7300,
        builder.getFunctionType({}, {builder.getI32Type()}),
        mlir::StringAttr{}, mlir::UnitAttr{},
        mlir::ArrayAttr{}, mlir::ArrayAttr{});
    function->setAttr("has_return_value", builder.getUnitAttr());
    function->setAttr("helix.signature_complete", builder.getBoolAttr(true));
    auto* entry = builder.createBlock(&function.getBody());
    builder.setInsertionPointToStart(entry);
    auto whileOp = builder.create<mlir::scf::WhileOp>(
        loc, mlir::TypeRange{builder.getI32Type()}, mlir::ValueRange{});
    auto* before = builder.createBlock(&whileOp.getBefore());
    builder.setInsertionPointToStart(before);
    auto stop = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 1);
    auto exitValue = builder.create<mlir::arith::ConstantIntOp>(loc, 42, 32);
    builder.create<mlir::scf::ConditionOp>(
        loc, stop, mlir::ValueRange{exitValue});
    auto* after = builder.createBlock(&whileOp.getAfter());
    after->addArgument(builder.getI32Type(), loc);
    builder.setInsertionPointToStart(after);
    builder.create<mlir::scf::YieldOp>(loc);
    builder.setInsertionPointAfter(whileOp);
    builder.create<helix::high::ReturnOp>(
        loc, whileOp.getResult(0), mlir::IntegerAttr{});

    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 1u);
    helix::cast::CAstPrinter printer;
    std::string output = printer.print(*functions.front());
    EXPECT_NE(output.find("int32_t scf_r950000"), std::string::npos);
    EXPECT_NE(output.find("scf_r950000 = 42"), std::string::npos);
    EXPECT_NE(output.find("while (scf_w950001)"), std::string::npos);
    EXPECT_NE(output.find("return scf_r950000"), std::string::npos);
    EXPECT_EQ(output.find("block_arg"), std::string::npos);
    EXPECT_EQ(output.find("__helix_unhandled_scf"), std::string::npos);
}

TEST(StructureControlFlowTest, CastPreservesResidualCfSwitchInHighFunction) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::cf::ControlFlowDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::high::FuncOp>(
        loc, "residual_cf_switch", /*entry_address=*/0x7400,
        builder.getFunctionType({}, {builder.getI64Type()}),
        mlir::StringAttr{}, mlir::UnitAttr{},
        mlir::ArrayAttr{}, mlir::ArrayAttr{});
    function->setAttr("has_return_value", builder.getUnitAttr());
    function->setAttr("helix.signature_complete", builder.getBoolAttr(true));
    auto* entry = builder.createBlock(&function.getBody());
    auto* zeroCase = builder.createBlock(&function.getBody());
    auto* defaultCase = builder.createBlock(&function.getBody());
    builder.setInsertionPointToStart(entry);
    auto selector = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 32);
    builder.create<mlir::cf::SwitchOp>(
        loc, selector, defaultCase, mlir::ValueRange{},
        llvm::ArrayRef<int32_t>{0}, mlir::BlockRange{zeroCase},
        llvm::ArrayRef<mlir::ValueRange>{mlir::ValueRange{}});
    builder.setInsertionPointToStart(zeroCase);
    auto eleven = builder.create<mlir::arith::ConstantIntOp>(loc, 11, 64);
    builder.create<helix::high::ReturnOp>(
        loc, eleven, mlir::IntegerAttr{});
    builder.setInsertionPointToStart(defaultCase);
    auto twentyTwo = builder.create<mlir::arith::ConstantIntOp>(loc, 22, 64);
    builder.create<helix::high::ReturnOp>(
        loc, twentyTwo, mlir::IntegerAttr{});

    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    EXPECT_EQ(function.getBody().getBlocks().size(), 3u);
    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 1u);
    helix::cast::CAstPrinter printer;
    std::string output = printer.print(*functions.front());
    EXPECT_NE(output.find("switch (0)"), std::string::npos) << output;
    EXPECT_NE(output.find("case 0:"), std::string::npos);
    EXPECT_NE(output.find("goto block_2"), std::string::npos);
    EXPECT_NE(output.find("goto block_3"), std::string::npos);
    EXPECT_NE(output.find("block_2:"), std::string::npos);
    EXPECT_NE(output.find("block_3:"), std::string::npos);
    EXPECT_EQ(output.find("__helix_unhandled_cf"), std::string::npos);
}

TEST(StructureControlFlowTest, CastSnapshotsResidualCfBlockArguments) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::cf::ControlFlowDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::high::FuncOp>(
        loc, "residual_cf_phi", /*entry_address=*/0x7500,
        builder.getFunctionType({}, {builder.getI64Type()}),
        mlir::StringAttr{}, mlir::UnitAttr{},
        mlir::ArrayAttr{}, mlir::ArrayAttr{});
    function->setAttr("has_return_value", builder.getUnitAttr());
    function->setAttr("helix.signature_complete", builder.getBoolAttr(true));
    auto* entry = builder.createBlock(&function.getBody());
    auto* merge = builder.createBlock(&function.getBody());
    auto merged = merge->addArgument(builder.getI64Type(), loc);
    builder.setInsertionPointToStart(entry);
    auto value = builder.create<mlir::arith::ConstantIntOp>(loc, 77, 64);
    builder.create<mlir::cf::BranchOp>(loc, merge, value.getResult());
    builder.setInsertionPointToStart(merge);
    builder.create<helix::high::ReturnOp>(
        loc, merged, mlir::IntegerAttr{});

    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 1u);
    helix::cast::CAstPrinter printer;
    std::string output = printer.print(*functions.front());
    EXPECT_NE(output.find("int64_t cfg_phi950000"), std::string::npos);
    EXPECT_NE(output.find("int64_t cfg_edge950001"), std::string::npos);
    EXPECT_NE(output.find("cfg_edge950001 = 77"), std::string::npos);
    EXPECT_NE(output.find("cfg_phi950000 = cfg_edge950001"),
              std::string::npos);
    EXPECT_NE(output.find("goto block_2"), std::string::npos);
    EXPECT_NE(output.find("return cfg_phi950000"), std::string::npos);
    EXPECT_EQ(output.find("block_arg"), std::string::npos);
    EXPECT_EQ(output.find("__helix_unhandled_cf"), std::string::npos);
}

} // namespace
