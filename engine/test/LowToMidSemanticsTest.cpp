/// @file LowToMidSemanticsTest.cpp
/// @brief Losslessness contracts for operations not yet represented in Mid.

#include "helix/cast/CAstBuilder.h"
#include "helix/cast/CAstOptimizer.h"
#include "helix/cast/CAstPrinter.h"
#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixMidDialect.h"
#include "helix/dialects/HelixMidOps.h"
#include "helix/passes/Passes.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Verifier.h"
#include "mlir/Pass/PassManager.h"

#include <gtest/gtest.h>

#include <array>

namespace {

void loadDialects(mlir::MLIRContext& context) {
    context.getOrLoadDialect<helix::low::HelixLowDialect>();
    context.getOrLoadDialect<helix::mid::HelixMidDialect>();
    context.getOrLoadDialect<helix::high::HelixHighDialect>();
    context.getOrLoadDialect<mlir::arith::ArithDialect>();
    context.getOrLoadDialect<mlir::func::FuncDialect>();
}

std::array<int, 4> lowerCmpFlags(int64_t lhsValue, int64_t rhsValue) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto i1 = builder.getI1Type();
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "cmp_flags", builder.getFunctionType({}, {i1, i1, i1, i1}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto lhs = builder.create<mlir::arith::ConstantIntOp>(loc, lhsValue, 8);
    auto rhs = builder.create<mlir::arith::ConstantIntOp>(loc, rhsValue, 8);
    auto cmp = builder.create<helix::low::CmpOp>(
        loc, i1, i1, i1, i1, lhs, rhs, mlir::IntegerAttr{});
    builder.create<mlir::func::ReturnOp>(
        loc, mlir::ValueRange{cmp.getCarryFlag(), cmp.getZeroFlag(),
                              cmp.getSignFlag(), cmp.getOverflowFlag()});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    manager.addPass(helix::createHelixMidSimplifyPass());
    EXPECT_TRUE(mlir::succeeded(manager.run(module)));

    auto returnOp = llvm::cast<mlir::func::ReturnOp>(block->getTerminator());
    std::array<int, 4> flags{};
    for (unsigned index = 0; index < flags.size(); ++index) {
        auto constant = returnOp.getOperand(index).getDefiningOp<
            mlir::arith::ConstantOp>();
        EXPECT_TRUE(static_cast<bool>(constant));
        if (constant) {
            auto value = llvm::cast<mlir::IntegerAttr>(constant.getValue());
            flags[index] = value.getInt() != 0;
        }
    }
    return flags;
}

std::array<int, 4> lowerBinaryFlags(
        helix::low::BinOpKind kind, int64_t lhsValue, int64_t rhsValue) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto i1 = builder.getI1Type();
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "binary_flags", builder.getFunctionType({}, {i1, i1, i1, i1}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto lhs = builder.create<mlir::arith::ConstantIntOp>(loc, lhsValue, 8);
    auto rhs = builder.create<mlir::arith::ConstantIntOp>(loc, rhsValue, 8);
    auto binary = builder.create<helix::low::BinOp>(
        loc, builder.getI8Type(), i1, i1, i1, i1, kind, lhs, rhs,
        mlir::IntegerAttr{}, mlir::UnitAttr{});
    builder.create<mlir::func::ReturnOp>(
        loc, mlir::ValueRange{binary.getCarryFlag(), binary.getZeroFlag(),
                              binary.getSignFlag(), binary.getOverflowFlag()});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    manager.addPass(helix::createHelixMidSimplifyPass());
    EXPECT_TRUE(mlir::succeeded(manager.run(module)));

    auto returnOp = llvm::cast<mlir::func::ReturnOp>(block->getTerminator());
    std::array<int, 4> flags{};
    for (unsigned index = 0; index < flags.size(); ++index) {
        auto constant = returnOp.getOperand(index).getDefiningOp<
            mlir::arith::ConstantOp>();
        EXPECT_TRUE(static_cast<bool>(constant));
        if (constant) {
            auto value = llvm::cast<mlir::IntegerAttr>(constant.getValue());
            flags[index] = value.getInt() != 0;
        }
    }
    return flags;
}

TEST(LowToMidSemanticsTest, PreservesExactRotateAndBitScanAcrossMid) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "lossless_low_survivors",
        builder.getFunctionType({}, {}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);

    auto value = builder.create<mlir::arith::ConstantIntOp>(loc, 0x1234, 64);
    auto count = builder.create<mlir::arith::ConstantIntOp>(loc, 8, 64);
    builder.create<helix::low::BinOp>(
        loc, builder.getI64Type(), builder.getI1Type(), builder.getI1Type(),
        builder.getI1Type(), builder.getI1Type(), helix::low::BinOpKind::Rol,
        value, count, mlir::IntegerAttr{}, mlir::UnitAttr{});
    builder.create<helix::low::UnaryOp>(
        loc, builder.getI64Type(), builder.getI1Type(), builder.getI1Type(),
        helix::low::UnaryOpKind::Bsr, value, mlir::IntegerAttr{});
    builder.create<mlir::func::ReturnOp>(loc);

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    unsigned lowRotateCount = 0;
    unsigned lowBitScanCount = 0;
    unsigned midRotateCount = 0;
    unsigned midBitScanCount = 0;
    unsigned approximatedShiftCount = 0;
    unsigned approximatedNegCount = 0;
    module.walk([&](helix::low::BinOp op) {
        if (op.getKind() == helix::low::BinOpKind::Rol)
            ++lowRotateCount;
    });
    module.walk([&](helix::low::UnaryOp op) {
        if (op.getKind() == helix::low::UnaryOpKind::Bsr)
            ++lowBitScanCount;
    });
    module.walk([&](helix::mid::BinExprOp op) {
        if (op.getKind() == helix::mid::BinExprKind::Rol)
            ++midRotateCount;
        if (op.getKind() == helix::mid::BinExprKind::Shl ||
            op.getKind() == helix::mid::BinExprKind::Shr)
            ++approximatedShiftCount;
    });
    module.walk([&](helix::mid::UnExprOp op) {
        if (op.getKind() == helix::mid::UnExprKind::Bsr)
            ++midBitScanCount;
        if (op.getKind() == helix::mid::UnExprKind::Neg)
            ++approximatedNegCount;
    });

    EXPECT_EQ(lowRotateCount, 0u);
    EXPECT_EQ(lowBitScanCount, 0u);
    EXPECT_EQ(midRotateCount, 1u);
    EXPECT_EQ(midBitScanCount, 1u);
    EXPECT_EQ(approximatedShiftCount, 0u);
    EXPECT_EQ(approximatedNegCount, 0u);
    auto residual = module->getAttrOfType<mlir::IntegerAttr>(
        "helix.tier_closure.low_to_mid.residual_low_ops");
    ASSERT_TRUE(residual);
    EXPECT_EQ(residual.getInt(), 0);
}

TEST(LowToMidSemanticsTest, StrictClosureRejectsResidualLowOperation) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "strict_residual", builder.getFunctionType({}, {}));
    auto* block = function.addEntryBlock();
    auto* targetBlock = builder.createBlock(&function.getBody());
    builder.setInsertionPointToStart(block);
    builder.create<helix::low::JmpOp>(
        loc, mlir::ValueRange{}, mlir::IntegerAttr{}, mlir::IntegerAttr{},
        targetBlock);
    builder.setInsertionPointToStart(targetBlock);
    builder.create<mlir::func::ReturnOp>(loc);

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass(/*strictClosure=*/true));
    EXPECT_TRUE(mlir::failed(manager.run(module)));
}

TEST(LowToMidSemanticsTest, StrictClosureCollapsesVariadicBundleBeforeConversion) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "strict_variadic_bundle", builder.getFunctionType({}, {}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto target = builder.create<mlir::arith::ConstantIntOp>(
        loc, 0x401000, 64);
    auto bundle = builder.create<helix::low::BundleCreateOp>(
        loc, helix::low::BundleState::Recovered, mlir::StringAttr{});
    builder.create<helix::low::VariadicCallOp>(
        loc, mlir::TypeRange{}, target, mlir::ValueRange{},
        bundle.getBundle(), builder.getStringAttr("printk"),
        mlir::IntegerAttr{});
    builder.create<mlir::func::ReturnOp>(loc);

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass(/*strictClosure=*/true));
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    unsigned lowBundles = 0, lowCalls = 0, midCalls = 0;
    module.walk([&](helix::low::BundleCreateOp) { ++lowBundles; });
    module.walk([&](helix::low::VariadicCallOp) { ++lowCalls; });
    module.walk([&](helix::mid::CallOp call) {
        ++midCalls;
        auto state = call->getAttrOfType<mlir::StringAttr>(
            "helix.variadic_state");
        ASSERT_TRUE(state);
        EXPECT_EQ(state.getValue(), "recovered");
    });
    EXPECT_EQ(lowBundles, 0u);
    EXPECT_EQ(lowCalls, 0u);
    EXPECT_EQ(midCalls, 1u);
}

TEST(LowToMidSemanticsTest, EmitsExplicitRotateBuiltinAfterTierConversion) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::low::FuncOp>(
        loc, "rotate_builtin", /*entry_address=*/0x1000,
        /*original_name=*/mlir::StringAttr{});
    function->setAttr("has_return_value", builder.getUnitAttr());
    auto* block = builder.createBlock(&function.getBody());
    builder.setInsertionPointToStart(block);
    auto value = builder.create<mlir::arith::ConstantIntOp>(loc, 0x1234, 64);
    auto count = builder.create<mlir::arith::ConstantIntOp>(loc, 8, 64);
    auto rotate = builder.create<helix::low::BinOp>(
        loc, builder.getI64Type(), builder.getI1Type(), builder.getI1Type(),
        builder.getI1Type(), builder.getI1Type(), helix::low::BinOpKind::Ror,
        value, count, mlir::IntegerAttr{}, mlir::UnitAttr{});
    builder.create<helix::high::ReturnOp>(
        loc, rotate.getResult(), mlir::IntegerAttr{});

    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    manager.addPass(helix::createHelixMidToHighPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));
    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 1u);
    helix::cast::CAstPrinter printer;
    const std::string output = printer.print(*functions.front());

    EXPECT_NE(output.find("__builtin_rotateright64"), std::string::npos);
    EXPECT_EQ(output.find(" >> "), std::string::npos);
}

TEST(LowToMidSemanticsTest, PreservesInt3AcrossBothConversions) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "int3_conversion", builder.getFunctionType({}, {}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    builder.create<helix::low::Int3Op>(
        loc, mlir::IntegerAttr::get(
            mlir::IntegerType::get(
                &context, 64, mlir::IntegerType::Unsigned),
            0x401000));
    builder.create<mlir::func::ReturnOp>(loc);

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    manager.addPass(helix::createHelixMidToHighPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    size_t lowBreaks = 0, midBreaks = 0, highBreaks = 0;
    module.walk([&](helix::low::Int3Op) { ++lowBreaks; });
    module.walk([&](helix::mid::DebugBreakOp) { ++midBreaks; });
    module.walk([&](helix::high::DebugBreakOp op) {
        ++highBreaks;
        EXPECT_EQ(op.getAddress().value_or(0), 0x401000u);
    });
    EXPECT_EQ(lowBreaks, 0u);
    EXPECT_EQ(midBreaks, 0u);
    EXPECT_EQ(highBreaks, 1u);
}

TEST(LowToMidSemanticsTest, EmitsObservableDebugBreak) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::low::FuncOp>(
        loc, "debug_break", /*entry_address=*/0x401000,
        /*original_name=*/mlir::StringAttr{});
    auto* block = builder.createBlock(&function.getBody());
    builder.setInsertionPointToStart(block);
    builder.create<helix::high::DebugBreakOp>(
        loc, mlir::IntegerAttr::get(
            mlir::IntegerType::get(
                &context, 64, mlir::IntegerType::Unsigned),
            0x401000));
    builder.create<helix::high::ReturnOp>(
        loc, mlir::Value{}, mlir::IntegerAttr{});

    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 1u);
    helix::cast::CAstPrinter printer;
    const std::string output = printer.print(*functions.front());
    EXPECT_NE(output.find("__debugbreak();"), std::string::npos);
}

TEST(LowToMidSemanticsTest, KeepsMovzxAndMovsxCastKindsDistinct) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "extension_kinds",
        builder.getFunctionType({}, {builder.getI32Type(),
                                     builder.getI32Type()}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto source = builder.create<mlir::arith::ConstantIntOp>(loc, 0x80, 8);
    auto zext = builder.create<helix::low::MovZxOp>(
        loc, builder.getI32Type(), source,
        builder.getUI32IntegerAttr(32), mlir::IntegerAttr{});
    auto sext = builder.create<helix::low::MovSxOp>(
        loc, builder.getI32Type(), source,
        builder.getUI32IntegerAttr(32), mlir::IntegerAttr{});
    builder.create<mlir::func::ReturnOp>(
        loc, mlir::ValueRange{zext.getResult(), sext.getResult()});

    mlir::PassManager lowToMid(&context);
    lowToMid.enableVerifier(true);
    lowToMid.addPass(helix::createHelixLowToMidPass());
    ASSERT_TRUE(mlir::succeeded(lowToMid.run(module)));

    std::vector<helix::mid::CastKind> midKinds;
    module.walk([&](helix::mid::CastOp cast) {
        ASSERT_TRUE(cast.getCastKind().has_value());
        midKinds.push_back(*cast.getCastKind());
    });
    ASSERT_EQ(midKinds.size(), 2u);
    EXPECT_EQ(midKinds[0], helix::mid::CastKind::ZeroExtend);
    EXPECT_EQ(midKinds[1], helix::mid::CastKind::SignExtend);

    mlir::PassManager midToHigh(&context);
    midToHigh.enableVerifier(true);
    midToHigh.addPass(helix::createHelixMidToHighPass());
    ASSERT_TRUE(mlir::succeeded(midToHigh.run(module)));

    std::vector<helix::high::CastKind> highKinds;
    module.walk([&](helix::high::CastOp cast) {
        ASSERT_TRUE(cast.getCastKind().has_value());
        highKinds.push_back(*cast.getCastKind());
    });
    ASSERT_EQ(highKinds.size(), 2u);
    EXPECT_EQ(highKinds[0], helix::high::CastKind::ZeroExtend);
    EXPECT_EQ(highKinds[1], helix::high::CastKind::SignExtend);
}

TEST(LowToMidSemanticsTest, CastVerifiersRejectWrongWidthDirection) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();

    auto midModule = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(midModule.getBody());
    auto midFunction = builder.create<mlir::func::FuncOp>(
        loc, "bad_mid_extension", builder.getFunctionType({}, {}));
    auto* midBlock = midFunction.addEntryBlock();
    builder.setInsertionPointToStart(midBlock);
    auto wide = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 32);
    builder.create<helix::mid::CastOp>(
        loc, builder.getI8Type(), wide.getResult(), mlir::IntegerAttr{},
        helix::mid::CastKindAttr::get(
            &context, helix::mid::CastKind::ZeroExtend));
    builder.create<mlir::func::ReturnOp>(loc);
    EXPECT_TRUE(mlir::failed(mlir::verify(midModule)));

    auto highModule = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(highModule.getBody());
    auto highFunction = builder.create<mlir::func::FuncOp>(
        loc, "bad_high_extension", builder.getFunctionType({}, {}));
    auto* highBlock = highFunction.addEntryBlock();
    builder.setInsertionPointToStart(highBlock);
    auto wider = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 64);
    builder.create<helix::high::CastOp>(
        loc, builder.getI32Type(), wider.getResult(), mlir::IntegerAttr{},
        helix::high::CastKindAttr::get(
            &context, helix::high::CastKind::SignExtend));
    builder.create<mlir::func::ReturnOp>(loc);
    EXPECT_TRUE(mlir::failed(mlir::verify(highModule)));
}

TEST(LowToMidSemanticsTest, RemovesOnlyAnnotatedCalleeSaveStackOps) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "callee_save_cleanup", builder.getFunctionType({}, {}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto value = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    auto push = builder.create<helix::low::PushOp>(
        loc, value.getResult(), mlir::IntegerAttr{});
    push->setAttr("is_callee_save_push", builder.getUnitAttr());
    auto pop = builder.create<helix::low::PopOp>(
        loc, builder.getI64Type(), mlir::IntegerAttr{});
    pop->setAttr("is_callee_save_pop", builder.getUnitAttr());
    builder.create<mlir::func::ReturnOp>(loc);

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    size_t pushes = 0, pops = 0;
    module.walk([&](helix::low::PushOp) { ++pushes; });
    module.walk([&](helix::low::PopOp) { ++pops; });
    EXPECT_EQ(pushes, 0u);
    EXPECT_EQ(pops, 0u);
}

TEST(LowToMidSemanticsTest, KeepsMachineMulAndDivSignednessDistinct) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "machine_arithmetic_kinds",
        builder.getFunctionType({}, {builder.getI8Type(), builder.getI8Type(),
                                     builder.getI8Type(), builder.getI8Type()}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto lhs = builder.create<mlir::arith::ConstantIntOp>(loc, -2, 8);
    auto rhs = builder.create<mlir::arith::ConstantIntOp>(loc, 2, 8);
    auto makeBinary = [&](helix::low::BinOpKind kind) {
        return builder.create<helix::low::BinOp>(
            loc, builder.getI8Type(), builder.getI1Type(),
            builder.getI1Type(), builder.getI1Type(), builder.getI1Type(),
            kind, lhs, rhs, mlir::IntegerAttr{}, mlir::UnitAttr{});
    };
    auto umul = makeBinary(helix::low::BinOpKind::Mul);
    auto smul = makeBinary(helix::low::BinOpKind::IMul);
    auto udiv = makeBinary(helix::low::BinOpKind::Div);
    auto sdiv = makeBinary(helix::low::BinOpKind::IDiv);
    builder.create<mlir::func::ReturnOp>(
        loc, mlir::ValueRange{umul.getResult(), smul.getResult(),
                              udiv.getResult(), sdiv.getResult()});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    std::vector<helix::mid::BinExprKind> kinds;
    module.walk([&](helix::mid::BinExprOp op) {
        if (op.getKind() == helix::mid::BinExprKind::UMul ||
            op.getKind() == helix::mid::BinExprKind::SMul ||
            op.getKind() == helix::mid::BinExprKind::UDiv ||
            op.getKind() == helix::mid::BinExprKind::SDiv)
            kinds.push_back(op.getKind());
    });
    ASSERT_EQ(kinds.size(), 4u);
    EXPECT_EQ(kinds[0], helix::mid::BinExprKind::UMul);
    EXPECT_EQ(kinds[1], helix::mid::BinExprKind::SMul);
    EXPECT_EQ(kinds[2], helix::mid::BinExprKind::UDiv);
    EXPECT_EQ(kinds[3], helix::mid::BinExprKind::SDiv);
}

TEST(LowToMidSemanticsTest, ConstantFoldingDistinguishesUdivAndSdiv) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "fold_division_kinds",
        builder.getFunctionType({}, {builder.getI8Type(), builder.getI8Type()}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto lhs = builder.create<mlir::arith::ConstantIntOp>(loc, -2, 8);
    auto rhs = builder.create<mlir::arith::ConstantIntOp>(loc, 2, 8);
    auto udiv = builder.create<helix::mid::BinExprOp>(
        loc, builder.getI8Type(), helix::mid::BinExprKind::UDiv,
        lhs, rhs, mlir::IntegerAttr{});
    auto sdiv = builder.create<helix::mid::BinExprOp>(
        loc, builder.getI8Type(), helix::mid::BinExprKind::SDiv,
        lhs, rhs, mlir::IntegerAttr{});
    builder.create<mlir::func::ReturnOp>(
        loc, mlir::ValueRange{udiv.getResult(), sdiv.getResult()});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createConstantFoldingPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    auto ret = llvm::cast<mlir::func::ReturnOp>(block->getTerminator());
    auto unsignedResult =
        ret.getOperand(0).getDefiningOp<mlir::arith::ConstantOp>();
    auto signedResult =
        ret.getOperand(1).getDefiningOp<mlir::arith::ConstantOp>();
    ASSERT_TRUE(unsignedResult);
    ASSERT_TRUE(signedResult);
    auto unsignedAttr =
        llvm::cast<mlir::IntegerAttr>(unsignedResult.getValue());
    auto signedAttr = llvm::cast<mlir::IntegerAttr>(signedResult.getValue());
    EXPECT_EQ(unsignedAttr.getValue().getZExtValue(), 127u);
    EXPECT_EQ(signedAttr.getValue().getSExtValue(), -1);
}

TEST(LowToMidSemanticsTest, DoesNotFoldSignedDivisionOverflow) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "signed_division_overflow",
        builder.getFunctionType({}, {builder.getI8Type()}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto minimum = builder.create<mlir::arith::ConstantIntOp>(loc, -128, 8);
    auto minusOne = builder.create<mlir::arith::ConstantIntOp>(loc, -1, 8);
    auto division = builder.create<helix::mid::BinExprOp>(
        loc, builder.getI8Type(), helix::mid::BinExprKind::SDiv,
        minimum, minusOne, mlir::IntegerAttr{});
    builder.create<mlir::func::ReturnOp>(
        loc, mlir::ValueRange{division.getResult()});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createConstantFoldingPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    auto ret = llvm::cast<mlir::func::ReturnOp>(block->getTerminator());
    EXPECT_TRUE(ret.getOperand(0).getDefiningOp<helix::mid::BinExprOp>());
}

TEST(LowToMidSemanticsTest, PreservesExplicitUnknownAcrossTiersAndCast) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::low::FuncOp>(
        loc, "unknown_value", /*entry_address=*/0x402000,
        /*original_name=*/mlir::StringAttr{});
    function->setAttr("has_return_value", builder.getUnitAttr());
    auto* block = builder.createBlock(&function.getBody());
    builder.setInsertionPointToStart(block);
    auto unknown = builder.create<helix::low::UnknownValueOp>(
        loc, builder.getI64Type(),
        builder.getStringAttr("test semantic gap"), mlir::IntegerAttr{});
    builder.create<helix::high::ReturnOp>(
        loc, unknown.getResult(), mlir::IntegerAttr{});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    manager.addPass(helix::createHelixMidToHighPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    size_t highUnknowns = 0;
    module.walk([&](helix::high::UnknownValueOp op) {
        ++highUnknowns;
        EXPECT_EQ(op.getReason(), "test semantic gap");
    });
    EXPECT_EQ(highUnknowns, 1u);

    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 1u);
    helix::cast::CAstOptimizer optimizer;
    optimizer.optimize(*functions.front());
    helix::cast::CAstPrinter printer;
    const std::string output = printer.print(*functions.front());
    EXPECT_NE(output.find("__helix_unknown(\"test semantic gap\")"),
              std::string::npos);
    EXPECT_LE(functions.front()->confidenceScore, 50.0);
    EXPECT_TRUE(std::any_of(
        functions.front()->confidenceIssues.begin(),
        functions.front()->confidenceIssues.end(),
        [](const std::string& issue) {
            return issue.find("explicit unknown machine semantics") !=
                   std::string::npos;
        }));
}

TEST(LowToMidSemanticsTest, UndefinedDivisionFlagsDoNotBecomeFalse) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "undefined_division_flags",
        builder.getFunctionType(
            {}, {builder.getI1Type(), builder.getI1Type(),
                 builder.getI1Type(), builder.getI1Type()}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto lhs = builder.create<mlir::arith::ConstantIntOp>(loc, 9, 64);
    auto rhs = builder.create<mlir::arith::ConstantIntOp>(loc, 2, 64);
    auto division = builder.create<helix::low::BinOp>(
        loc, builder.getI64Type(), builder.getI1Type(),
        builder.getI1Type(), builder.getI1Type(), builder.getI1Type(),
        helix::low::BinOpKind::IDiv, lhs, rhs,
        mlir::IntegerAttr{}, mlir::UnitAttr{});
    builder.create<mlir::func::ReturnOp>(
        loc, mlir::ValueRange{
            division.getCarryFlag(), division.getZeroFlag(),
            division.getSignFlag(), division.getOverflowFlag()});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    auto ret = llvm::cast<mlir::func::ReturnOp>(block->getTerminator());
    for (mlir::Value flag : ret.getOperands())
        EXPECT_TRUE(flag.getDefiningOp<helix::mid::UnknownValueOp>());
}

TEST(LowToMidSemanticsTest, EmitsRegisterExchangeAsObservableHelper) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::low::FuncOp>(
        loc, "register_exchange", /*entry_address=*/0x403000,
        /*original_name=*/mlir::StringAttr{});
    auto* block = builder.createBlock(&function.getBody());
    builder.setInsertionPointToStart(block);
    builder.create<helix::low::XchgOp>(
        loc, builder.getStringAttr("R10D"), builder.getStringAttr("EBX"),
        builder.getUI32IntegerAttr(32), mlir::IntegerAttr{});
    builder.create<helix::high::ReturnOp>(
        loc, mlir::Value{}, mlir::IntegerAttr{});

    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    manager.addPass(helix::createHelixMidToHighPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));
    unsigned lowCount = 0, midCount = 0, highCount = 0;
    module.walk([&](helix::low::XchgOp) { ++lowCount; });
    module.walk([&](helix::mid::XchgOp) { ++midCount; });
    module.walk([&](helix::high::XchgOp) { ++highCount; });
    EXPECT_EQ(lowCount, 0u);
    EXPECT_EQ(midCount, 0u);
    EXPECT_EQ(highCount, 1u);
    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 1u);
    helix::cast::CAstPrinter printer;
    const std::string output = printer.print(*functions.front());
    EXPECT_NE(output.find("__helix_xchg_reg32(&r10d, &ebx)"),
              std::string::npos);
    EXPECT_EQ(output.find("reg_a"), std::string::npos);
    EXPECT_EQ(output.find("reg_b"), std::string::npos);
}

TEST(LowToMidSemanticsTest, EmitsCastConsumedCallExactlyOnce) {
    mlir::MLIRContext context;
    loadDialects(context);
    context.getOrLoadDialect<mlir::LLVM::LLVMDialect>();
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::low::FuncOp>(
        loc, "cast_call_once", /*entry_address=*/0x404000,
        /*original_name=*/mlir::StringAttr{});
    function->setAttr("has_return_value", builder.getUnitAttr());
    auto* block = builder.createBlock(&function.getBody());
    builder.setInsertionPointToStart(block);
    auto address = builder.create<mlir::arith::ConstantIntOp>(
        loc, 0x140001000, 64);
    auto value = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 32);
    auto call = builder.create<helix::high::CallOp>(
        loc, builder.getI32Type(), /*target_addr=*/0,
        "__helix_atomic_exchange_32",
        mlir::ValueRange{address.getResult(), value.getResult()},
        mlir::IntegerAttr{});
    auto extended = builder.create<mlir::LLVM::ZExtOp>(
        loc, builder.getI64Type(), call.getResult());
    builder.create<helix::high::VarDeclOp>(
        loc, /*var_id=*/1, "result", helix::high::StorageKind::Register,
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    auto target = builder.create<helix::high::VarRefOp>(
        loc, builder.getI64Type(), /*var_id=*/1, "result",
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, target.getResult(), extended.getResult(), mlir::IntegerAttr{});
    auto returned = builder.create<helix::high::VarRefOp>(
        loc, builder.getI64Type(), /*var_id=*/1, "result",
        mlir::IntegerAttr{});
    builder.create<helix::high::ReturnOp>(
        loc, returned.getResult(), mlir::IntegerAttr{});

    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 1u);
    helix::cast::CAstPrinter printer;
    const std::string output = printer.print(*functions.front());
    const std::string needle = "__helix_atomic_exchange_32(";
    size_t count = 0;
    for (size_t pos = 0;
         (pos = output.find(needle, pos)) != std::string::npos;
         pos += needle.size())
        ++count;
    EXPECT_EQ(count, 1u) << output;
}

TEST(LowToMidSemanticsTest, MaterializesZeroAndSignFlagsFromBinaryResult) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "binary_result_flags", builder.getFunctionType({}, {}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto value = builder.create<mlir::arith::ConstantIntOp>(loc, 0x1234, 64);
    auto mask = builder.create<mlir::arith::ConstantIntOp>(loc, 0xff, 64);
    auto binary = builder.create<helix::low::BinOp>(
        loc, builder.getI64Type(), builder.getI1Type(), builder.getI1Type(),
        builder.getI1Type(), builder.getI1Type(), helix::low::BinOpKind::And,
        value, mask, mlir::IntegerAttr{}, mlir::UnitAttr{});
    builder.create<mlir::arith::XOrIOp>(
        loc, binary.getZeroFlag(), binary.getSignFlag());
    builder.create<mlir::func::ReturnOp>(loc);

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    unsigned bitAndCount = 0;
    unsigned zeroFlagCount = 0;
    unsigned signFlagCount = 0;
    module.walk([&](helix::mid::BinExprOp op) {
        if (op.getKind() == helix::mid::BinExprKind::BitAnd)
            ++bitAndCount;
        if (op.getKind() == helix::mid::BinExprKind::Eq)
            ++zeroFlagCount;
        if (op.getKind() == helix::mid::BinExprKind::Lt)
            ++signFlagCount;
    });

    EXPECT_EQ(bitAndCount, 1u);
    EXPECT_EQ(zeroFlagCount, 1u);
    EXPECT_EQ(signFlagCount, 1u);
}

TEST(LowToMidSemanticsTest, CmpFlagsRespectEightBitBoundaries) {
    EXPECT_EQ(lowerCmpFlags(0, -1), (std::array<int, 4>{1, 0, 0, 0}));
    EXPECT_EQ(lowerCmpFlags(-128, 1), (std::array<int, 4>{0, 0, 0, 1}));
    EXPECT_EQ(lowerCmpFlags(127, -1), (std::array<int, 4>{1, 0, 1, 1}));
    EXPECT_EQ(lowerCmpFlags(-1, -1), (std::array<int, 4>{0, 1, 0, 0}));
}

TEST(LowToMidSemanticsTest, AddSubFlagsRespectEightBitBoundaries) {
    EXPECT_EQ(lowerBinaryFlags(helix::low::BinOpKind::Add, 127, 1),
              (std::array<int, 4>{0, 0, 1, 1}));
    EXPECT_EQ(lowerBinaryFlags(helix::low::BinOpKind::Add, -1, 1),
              (std::array<int, 4>{1, 1, 0, 0}));
    EXPECT_EQ(lowerBinaryFlags(helix::low::BinOpKind::Sub, -128, 1),
              (std::array<int, 4>{0, 0, 0, 1}));
    EXPECT_EQ(lowerBinaryFlags(helix::low::BinOpKind::Sub, 0, -1),
              (std::array<int, 4>{1, 0, 0, 0}));
}

TEST(LowToMidSemanticsTest, ResultAndFlagsShareOneAddSubDefinition) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto i8 = builder.getI8Type();
    auto i1 = builder.getI1Type();
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "shared_sub_result", builder.getFunctionType({i8}, {i8, i1}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto one = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 8);
    auto sub = builder.create<helix::low::BinOp>(
        loc, i8, i1, i1, i1, i1, helix::low::BinOpKind::Sub,
        block->getArgument(0), one, mlir::IntegerAttr{}, mlir::UnitAttr{});
    builder.create<mlir::func::ReturnOp>(
        loc, mlir::ValueRange{sub.getResult(), sub.getZeroFlag()});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    llvm::SmallVector<helix::mid::BinExprOp, 2> subOps;
    module.walk([&](helix::mid::BinExprOp op) {
        if (op.getKind() == helix::mid::BinExprKind::Sub)
            subOps.push_back(op);
    });
    ASSERT_EQ(subOps.size(), 1u);

    auto returnOp = llvm::cast<mlir::func::ReturnOp>(block->getTerminator());
    EXPECT_EQ(returnOp.getOperand(0), subOps.front().getResult());
    auto zeroFlag = returnOp.getOperand(1).getDefiningOp<helix::mid::BinExprOp>();
    ASSERT_TRUE(zeroFlag);
    EXPECT_EQ(zeroFlag.getKind(), helix::mid::BinExprKind::Eq);
    EXPECT_EQ(zeroFlag.getLhs(), subOps.front().getResult());
}

TEST(LowToMidSemanticsTest, CAstPrintsExplicitOrderedComparisonSignedness) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());

    auto buildFunction = [&](llvm::StringRef name,
                             helix::high::BinaryOpKind kind) {
        auto function = builder.create<helix::low::FuncOp>(
            loc, name, /*entry_address=*/0x2000,
            /*original_name=*/mlir::StringAttr{});
        function->setAttr("has_return_value", builder.getUnitAttr());
        auto* block = builder.createBlock(&function.getBody());
        builder.setInsertionPointToStart(block);
        auto lhs = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
        auto rhs = builder.create<mlir::arith::ConstantIntOp>(loc, -1, 64);
        auto compare = builder.create<helix::high::BinaryOp>(
            loc, builder.getI1Type(), kind, lhs, rhs, mlir::IntegerAttr{});
        builder.create<helix::high::ReturnOp>(
            loc, compare.getResult(), mlir::IntegerAttr{});
        builder.setInsertionPointToEnd(module.getBody());
    };

    buildFunction("unsigned_compare", helix::high::BinaryOpKind::Ult);
    buildFunction("signed_compare", helix::high::BinaryOpKind::Lt);
    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));

    helix::cast::CAstBuilder astBuilder;
    auto functions = astBuilder.buildModule(module);
    ASSERT_EQ(functions.size(), 2u);
    helix::cast::CAstPrinter printer;
    const std::string unsignedOutput = printer.print(*functions[0]);
    const std::string signedOutput = printer.print(*functions[1]);
    EXPECT_NE(unsignedOutput.find("(uint64_t)"), std::string::npos);
    EXPECT_NE(signedOutput.find("(int64_t)"), std::string::npos);
}

TEST(LowToMidSemanticsTest, CanonicalizesCompositeCmpFlags) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto i1 = builder.getI1Type();
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "composite_cmp_flags", builder.getFunctionType({}, {i1, i1, i1}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto lhs = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    auto rhs = builder.create<mlir::arith::ConstantIntOp>(loc, 9, 64);
    auto cmp = builder.create<helix::low::CmpOp>(
        loc, i1, i1, i1, i1, lhs, rhs, mlir::IntegerAttr{});
    auto signedLess = builder.create<mlir::arith::XOrIOp>(
        loc, cmp.getSignFlag(), cmp.getOverflowFlag());
    auto signedLessEqual = builder.create<mlir::arith::OrIOp>(
        loc, cmp.getZeroFlag(), signedLess);
    auto unsignedLessEqual = builder.create<mlir::arith::OrIOp>(
        loc, cmp.getCarryFlag(), cmp.getZeroFlag());
    builder.create<mlir::func::ReturnOp>(
        loc, mlir::ValueRange{signedLess, signedLessEqual, unsignedLessEqual});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    auto returnOp = llvm::cast<mlir::func::ReturnOp>(block->getTerminator());
    auto signedLessResult = returnOp.getOperand(0).getDefiningOp<
        helix::mid::BinExprOp>();
    auto signedLessEqualResult = returnOp.getOperand(1).getDefiningOp<
        helix::mid::BinExprOp>();
    auto unsignedLessEqualResult = returnOp.getOperand(2).getDefiningOp<
        helix::mid::BinExprOp>();
    ASSERT_TRUE(signedLessResult);
    ASSERT_TRUE(signedLessEqualResult);
    ASSERT_TRUE(unsignedLessEqualResult);
    EXPECT_EQ(signedLessResult.getKind(), helix::mid::BinExprKind::Lt);
    EXPECT_EQ(signedLessEqualResult.getKind(), helix::mid::BinExprKind::Le);
    EXPECT_EQ(unsignedLessEqualResult.getKind(), helix::mid::BinExprKind::Ule);
}

TEST(LowToMidSemanticsTest, CsePreservesFixedWidthFlagArithmetic) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto i64 = builder.getI64Type();
    auto i1 = builder.getI1Type();
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "fixed_width_cse",
        builder.getFunctionType({i64, i64}, {i1}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto add = builder.create<helix::low::BinOp>(
        loc, i64, i1, i1, i1, i1, helix::low::BinOpKind::Add,
        block->getArgument(0), block->getArgument(1),
        mlir::IntegerAttr{}, mlir::UnitAttr{});
    builder.create<mlir::func::ReturnOp>(
        loc, mlir::ValueRange{add.getCarryFlag()});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixLowToMidPass());
    manager.addPass(helix::createHelixMidSimplifyPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    auto returnOp = llvm::cast<mlir::func::ReturnOp>(block->getTerminator());
    auto carry = returnOp.getOperand(0).getDefiningOp<helix::mid::BinExprOp>();
    ASSERT_TRUE(carry);
    ASSERT_EQ(carry.getKind(), helix::mid::BinExprKind::Ult);
    auto wrappedAdd = carry.getLhs().getDefiningOp<helix::mid::BinExprOp>();
    ASSERT_TRUE(wrappedAdd);
    EXPECT_TRUE(wrappedAdd->hasAttr("helix.fixed_width_unsigned"));
}

TEST(LowToMidSemanticsTest, DoesNotApplyDeMorganToIntegerBitMask) {
    mlir::MLIRContext context;
    loadDialects(context);
    mlir::OpBuilder builder(&context);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        loc, "bitmask_not",
        builder.getFunctionType({builder.getI8Type()}, {builder.getI1Type()}));
    auto* block = function.addEntryBlock();
    builder.setInsertionPointToStart(block);
    auto mask = builder.create<mlir::arith::ConstantIntOp>(loc, 8, 8);
    auto masked = builder.create<helix::mid::BinExprOp>(
        loc, builder.getI8Type(), helix::mid::BinExprKind::BitAnd,
        block->getArgument(0), mask, mlir::IntegerAttr{});
    auto negated = builder.create<helix::mid::UnExprOp>(
        loc, builder.getI1Type(), helix::mid::UnExprKind::LogNot,
        masked, mlir::IntegerAttr{});
    builder.create<mlir::func::ReturnOp>(loc, negated.getResult());

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createHelixMidSimplifyPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));

    auto returnOp = llvm::cast<mlir::func::ReturnOp>(block->getTerminator());
    auto survivingNot = returnOp.getOperand(0).getDefiningOp<
        helix::mid::UnExprOp>();
    ASSERT_TRUE(survivingNot);
    EXPECT_EQ(survivingNot.getKind(), helix::mid::UnExprKind::LogNot);
    auto survivingMask = survivingNot.getOperand().getDefiningOp<
        helix::mid::BinExprOp>();
    ASSERT_TRUE(survivingMask);
    EXPECT_EQ(survivingMask.getKind(), helix::mid::BinExprKind::BitAnd);
}

} // namespace
