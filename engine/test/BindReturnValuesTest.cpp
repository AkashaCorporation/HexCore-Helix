/// @file BindReturnValuesTest.cpp
/// @brief Direct contracts for evidence-gated explicit return recovery.

#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/passes/Passes.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/Pass/PassManager.h"

#include <gtest/gtest.h>

namespace {

struct ReturnFixture {
    mlir::OwningOpRef<mlir::ModuleOp> module;
    helix::low::FuncOp func;
};

ReturnFixture buildReturnFixture(mlir::MLIRContext& ctx, bool hasReturnValue,
                                 unsigned resultCount, bool nestedReturn) {
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "return_fixture", /*entry_address=*/0x1000,
        /*original_name=*/mlir::StringAttr{});
    if (hasReturnValue)
        func->setAttr("has_return_value", builder.getUnitAttr());

    auto* body = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(body);
    for (unsigned i = 0; i < resultCount; ++i) {
        auto decl = builder.create<helix::high::VarDeclOp>(
            loc, /*var_id=*/100 + i, "result",
            helix::high::StorageKind::Register, mlir::IntegerAttr{},
            mlir::Value{}, mlir::IntegerAttr{});
        if (i == 0)
            decl->setAttr("inferred_type", builder.getStringAttr("widget *"));
    }

    if (nestedReturn) {
        auto condition = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
        auto ifOp = builder.create<helix::high::IfOp>(
            loc, condition.getResult(), mlir::IntegerAttr{});
        auto* thenBlock = builder.createBlock(&ifOp.getThenRegion());
        builder.setInsertionPointToStart(thenBlock);
        builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
        builder.setInsertionPointToEnd(body);
    }

    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
    return {std::move(module), func};
}

void runPass(mlir::MLIRContext& ctx, mlir::ModuleOp module) {
    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createBindReturnValuesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));
}

TEST(BindReturnValuesTest, BindsUniqueResultAtEveryStructuredExit) {
    mlir::MLIRContext ctx;
    auto fixture = buildReturnFixture(
        ctx, /*hasReturnValue=*/true, /*resultCount=*/1,
        /*nestedReturn=*/true);

    runPass(ctx, *fixture.module);

    unsigned lowReturns = 0;
    unsigned highReturns = 0;
    fixture.func.walk([&](helix::low::RetOp) { ++lowReturns; });
    fixture.func.walk([&](helix::high::ReturnOp ret) {
        ++highReturns;
        ASSERT_TRUE(ret.getValue());
        auto ref = ret.getValue().getDefiningOp<helix::high::VarRefOp>();
        ASSERT_TRUE(ref);
        EXPECT_EQ(ref.getVarId(), 100u);
        EXPECT_EQ(ref.getVarName(), "result");
        EXPECT_EQ(ref->getAttrOfType<mlir::StringAttr>("inferred_type").getValue(),
                  "widget *");
        EXPECT_EQ(ret->getAttrOfType<mlir::StringAttr>("helix.return_binding")
                      .getValue(),
                  "canonical-result-var-id");
    });
    EXPECT_EQ(lowReturns, 0u);
    EXPECT_EQ(highReturns, 2u);
}

TEST(BindReturnValuesTest, LeavesAmbiguousResultIdentitiesImplicit) {
    mlir::MLIRContext ctx;
    auto fixture = buildReturnFixture(
        ctx, /*hasReturnValue=*/true, /*resultCount=*/2,
        /*nestedReturn=*/false);

    runPass(ctx, *fixture.module);

    unsigned lowReturns = 0;
    unsigned highReturns = 0;
    fixture.func.walk([&](helix::low::RetOp) { ++lowReturns; });
    fixture.func.walk([&](helix::high::ReturnOp) { ++highReturns; });
    EXPECT_EQ(lowReturns, 1u);
    EXPECT_EQ(highReturns, 0u);
}

TEST(BindReturnValuesTest, LeavesVoidFunctionImplicit) {
    mlir::MLIRContext ctx;
    auto fixture = buildReturnFixture(
        ctx, /*hasReturnValue=*/false, /*resultCount=*/1,
        /*nestedReturn=*/false);

    runPass(ctx, *fixture.module);

    unsigned lowReturns = 0;
    unsigned highReturns = 0;
    fixture.func.walk([&](helix::low::RetOp) { ++lowReturns; });
    fixture.func.walk([&](helix::high::ReturnOp) { ++highReturns; });
    EXPECT_EQ(lowReturns, 1u);
    EXPECT_EQ(highReturns, 0u);
}

TEST(BindReturnValuesTest, LeavesMissingResultEvidenceImplicit) {
    mlir::MLIRContext ctx;
    auto fixture = buildReturnFixture(
        ctx, /*hasReturnValue=*/true, /*resultCount=*/0,
        /*nestedReturn=*/false);

    runPass(ctx, *fixture.module);

    unsigned lowReturns = 0;
    fixture.func.walk([&](helix::low::RetOp) { ++lowReturns; });
    EXPECT_EQ(lowReturns, 1u);
}

TEST(BindReturnValuesTest, BindsUniqueLiveAapcsX0Fallback) {
    mlir::MLIRContext ctx;
    auto fixture = buildReturnFixture(
        ctx, /*hasReturnValue=*/true, /*resultCount=*/0,
        /*nestedReturn=*/false);
    mlir::OpBuilder builder(&ctx);
    fixture.func->setAttr(
        "calling_convention", builder.getStringAttr("aapcs64"));
    auto& block = fixture.func.getBody().front();
    builder.setInsertionPointToStart(&block);
    builder.create<helix::high::VarDeclOp>(
        builder.getUnknownLoc(), /*var_id=*/1, "param_1",
        helix::high::StorageKind::Parameter, mlir::IntegerAttr{},
        mlir::Value{}, mlir::IntegerAttr{});
    builder.create<helix::high::VarDeclOp>(
        builder.getUnknownLoc(), /*var_id=*/9, "param_1",
        helix::high::StorageKind::Parameter, mlir::IntegerAttr{},
        mlir::Value{}, mlir::IntegerAttr{});
    auto liveX0 = builder.create<helix::high::VarRefOp>(
        builder.getUnknownLoc(), builder.getI64Type(), /*var_id=*/9,
        "param_1", mlir::IntegerAttr{});
    auto one = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 1, 64);
    builder.create<helix::high::AssignOp>(
        builder.getUnknownLoc(), liveX0, one, mlir::IntegerAttr{});

    runPass(ctx, *fixture.module);

    unsigned lowReturns = 0;
    unsigned highReturns = 0;
    fixture.func.walk([&](helix::low::RetOp) { ++lowReturns; });
    fixture.func.walk([&](helix::high::ReturnOp ret) {
        ++highReturns;
        auto ref = ret.getValue().getDefiningOp<helix::high::VarRefOp>();
        ASSERT_TRUE(ref);
        EXPECT_EQ(ref.getVarId(), 9u);
        EXPECT_EQ(ref.getVarName(), "param_1");
        EXPECT_EQ(ret->getAttrOfType<mlir::StringAttr>("helix.return_binding")
                      .getValue(),
                  "aapcs64-live-x0-var-id");
    });
    EXPECT_EQ(lowReturns, 0u);
    EXPECT_EQ(highReturns, 1u);
}

TEST(BindReturnValuesTest, LeavesAmbiguousLiveAapcsX0FallbackImplicit) {
    mlir::MLIRContext ctx;
    auto fixture = buildReturnFixture(
        ctx, /*hasReturnValue=*/true, /*resultCount=*/0,
        /*nestedReturn=*/false);
    mlir::OpBuilder builder(&ctx);
    fixture.func->setAttr(
        "calling_convention", builder.getStringAttr("aapcs64"));
    auto& block = fixture.func.getBody().front();
    builder.setInsertionPointToStart(&block);

    for (uint32_t varId : {9u, 10u}) {
        builder.create<helix::high::VarDeclOp>(
            builder.getUnknownLoc(), varId, "param_1",
            helix::high::StorageKind::Parameter, mlir::IntegerAttr{},
            mlir::Value{}, mlir::IntegerAttr{});
        builder.create<helix::high::VarRefOp>(
            builder.getUnknownLoc(), builder.getI64Type(), varId,
            "param_1", mlir::IntegerAttr{});
    }

    runPass(ctx, *fixture.module);

    unsigned lowReturns = 0;
    unsigned highReturns = 0;
    fixture.func.walk([&](helix::low::RetOp) { ++lowReturns; });
    fixture.func.walk([&](helix::high::ReturnOp) { ++highReturns; });
    EXPECT_EQ(lowReturns, 1u);
    EXPECT_EQ(highReturns, 0u);
}

} // namespace
