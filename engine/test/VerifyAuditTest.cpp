#include "helix/diagnostics/VerifyAudit.h"
#include "helix/passes/Passes.h"
#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixMidDialect.h"
#include "helix/dialects/HelixMidOps.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/Verifier.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassManager.h"

#include <gtest/gtest.h>

#include <filesystem>

namespace {

class NoOpAuditPass final
    : public mlir::PassWrapper<NoOpAuditPass,
                               mlir::OperationPass<mlir::ModuleOp>> {
public:
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(NoOpAuditPass)
    void runOnOperation() override {}
};

class InvalidateTerminatorPass final
    : public mlir::PassWrapper<InvalidateTerminatorPass,
                               mlir::OperationPass<mlir::ModuleOp>> {
public:
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(InvalidateTerminatorPass)

    void runOnOperation() override {
        auto function = *getOperation().getOps<mlir::func::FuncOp>().begin();
        function.getBody().front().getTerminator()->erase();
    }
};

mlir::OwningOpRef<mlir::ModuleOp> createValidModule(mlir::MLIRContext& context) {
    context.getOrLoadDialect<mlir::func::FuncDialect>();
    mlir::OpBuilder builder(&context);
    auto module = mlir::ModuleOp::create(builder.getUnknownLoc());
    auto function = mlir::func::FuncOp::create(
        builder.getUnknownLoc(), "fixture", builder.getFunctionType({}, {}));
    mlir::Block* entry = function.addEntryBlock();
    builder.setInsertionPointToEnd(entry);
    builder.create<mlir::func::ReturnOp>(builder.getUnknownLoc());
    module.push_back(function);
    return module;
}

std::filesystem::path freshRoot(const char* name) {
    auto root = std::filesystem::temp_directory_path() / name;
    std::error_code error;
    std::filesystem::remove_all(root, error);
    std::filesystem::create_directories(root);
    return root;
}

size_t countMlirFiles(const std::filesystem::path& directory) {
    size_t count = 0;
    for (const auto& entry : std::filesystem::directory_iterator(directory)) {
        if (entry.path().extension() == ".mlir")
            ++count;
    }
    return count;
}

TEST(VerifyAuditTest, ValidPassProducesBeforeAndAfterDumps) {
    mlir::MLIRContext context;
    auto module = createValidModule(context);
    ASSERT_TRUE(mlir::succeeded(mlir::verify(*module)));

    auto state = std::make_shared<helix::VerifyAuditState>();
    state->beginRun(freshRoot("helix-verify-audit-valid"));

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addInstrumentation(helix::createVerifyAuditInstrumentation(state));
    manager.addPass(std::make_unique<NoOpAuditPass>());

    EXPECT_TRUE(mlir::succeeded(manager.run(*module)));
    EXPECT_FALSE(state->firstFailure().has_value());
    EXPECT_EQ(countMlirFiles(state->runDirectory()), 2u);
}

TEST(VerifyAuditTest, NamesAndStopsAtFirstPassThatCreatesInvalidIr) {
    mlir::MLIRContext context;
    auto module = createValidModule(context);
    ASSERT_TRUE(mlir::succeeded(mlir::verify(*module)));

    auto state = std::make_shared<helix::VerifyAuditState>();
    state->beginRun(freshRoot("helix-verify-audit-invalid"));

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addInstrumentation(helix::createVerifyAuditInstrumentation(state));
    manager.addPass(std::make_unique<InvalidateTerminatorPass>());
    manager.addPass(std::make_unique<NoOpAuditPass>());

    EXPECT_TRUE(mlir::failed(manager.run(*module)));
    const auto failure = state->firstFailure();
    ASSERT_TRUE(failure.has_value());
    EXPECT_NE(failure->pass_name.find("InvalidateTerminatorPass"), std::string::npos);
    EXPECT_EQ(failure->reason, "verifier-failure");
    EXPECT_TRUE(std::filesystem::exists(failure->before_path));
    EXPECT_TRUE(std::filesystem::exists(failure->after_path));
    EXPECT_TRUE(std::filesystem::exists(
        state->runDirectory() / "first_failure.txt"));
    EXPECT_EQ(countMlirFiles(state->runDirectory()), 2u)
        << "the pass after the first invalid producer must not execute";
}

TEST(VerifyAuditTest, RemovesIdentityIntegerCastsAfterValueReplacement) {
    mlir::MLIRContext context;
    context.getOrLoadDialect<mlir::LLVM::LLVMDialect>();
    mlir::OpBuilder builder(&context);
    auto module = mlir::ModuleOp::create(builder.getUnknownLoc());
    auto functionType = mlir::LLVM::LLVMFunctionType::get(
        builder.getI64Type(), {}, false);
    builder.setInsertionPointToStart(module.getBody());
    auto function = builder.create<mlir::LLVM::LLVMFuncOp>(
        builder.getUnknownLoc(), "identity_casts", functionType);
    mlir::Block* block = new mlir::Block();
    function.getBody().push_back(block);
    builder.setInsertionPointToEnd(block);
    auto value = builder.create<mlir::LLVM::ConstantOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        builder.getI64IntegerAttr(7));
    auto zext = builder.create<mlir::LLVM::ZExtOp>(
        builder.getUnknownLoc(), builder.getI64Type(), value);
    auto sext = builder.create<mlir::LLVM::SExtOp>(
        builder.getUnknownLoc(), builder.getI64Type(), zext);
    auto trunc = builder.create<mlir::LLVM::TruncOp>(
        builder.getUnknownLoc(), builder.getI64Type(), sext);
    auto returnOp = builder.create<mlir::LLVM::ReturnOp>(
        builder.getUnknownLoc(), mlir::ValueRange{trunc});

    EXPECT_TRUE(mlir::failed(mlir::verify(module.getOperation())));
    EXPECT_EQ(helix::removeIdentityLLVMIntegerCasts(module), 3u);
    EXPECT_TRUE(mlir::succeeded(mlir::verify(module.getOperation())));
    EXPECT_EQ(returnOp.getArg(), value.getResult());
}

TEST(VerifyAuditTest, VarDeclStackOffsetUsesSignedI64Contract) {
    mlir::MLIRContext context;
    context.getOrLoadDialect<helix::high::HelixHighDialect>();
    mlir::OpBuilder builder(&context);
    auto module = mlir::ModuleOp::create(builder.getUnknownLoc());
    builder.setInsertionPointToStart(module.getBody());
    auto signedI64 = mlir::IntegerType::get(
        &context, 64, mlir::IntegerType::Signed);
    auto declaration = builder.create<helix::high::VarDeclOp>(
        builder.getUnknownLoc(),
        builder.getUI32IntegerAttr(0),
        builder.getStringAttr("stack_local"),
        helix::high::StorageKindAttr::get(
            &context, helix::high::StorageKind::Stack),
        mlir::IntegerAttr::get(signedI64, -8),
        mlir::Value{},
        mlir::IntegerAttr{});

    ASSERT_TRUE(declaration.getStackOffsetAttr());
    EXPECT_TRUE(declaration.getStackOffsetAttr().getType().isSignedInteger(64));
    EXPECT_TRUE(mlir::succeeded(mlir::verify(module.getOperation())));
}

TEST(VerifyAuditTest, MidCallCalleeAddressUsesUnsignedI64Contract) {
    mlir::MLIRContext context;
    context.getOrLoadDialect<helix::mid::HelixMidDialect>();
    mlir::OpBuilder builder(&context);
    auto module = mlir::ModuleOp::create(builder.getUnknownLoc());
    builder.setInsertionPointToStart(module.getBody());
    auto unsignedI64 = mlir::IntegerType::get(
        &context, 64, mlir::IntegerType::Unsigned);
    auto call = builder.create<helix::mid::CallOp>(
        builder.getUnknownLoc(),
        mlir::TypeRange{},
        mlir::IntegerAttr::get(unsignedI64, llvm::APInt(64, 0x140001000)),
        mlir::StringAttr{},
        mlir::ValueRange{},
        mlir::IntegerAttr{});

    EXPECT_TRUE(call.getCalleeAddrAttr().getType().isUnsignedInteger(64));
    EXPECT_TRUE(mlir::succeeded(mlir::verify(module.getOperation())));
}

TEST(VerifyAuditTest, MidConstantValueUsesSignedI64Contract) {
    mlir::MLIRContext context;
    context.getOrLoadDialect<helix::mid::HelixMidDialect>();
    mlir::OpBuilder builder(&context);
    auto module = mlir::ModuleOp::create(builder.getUnknownLoc());
    builder.setInsertionPointToStart(module.getBody());
    auto signedI64 = mlir::IntegerType::get(
        &context, 64, mlir::IntegerType::Signed);
    auto constant = builder.create<helix::mid::ConstantOp>(
        builder.getUnknownLoc(),
        builder.getI64Type(),
        mlir::IntegerAttr::get(signedI64, -1),
        mlir::IntegerAttr{});

    EXPECT_TRUE(constant.getValueAttr().getType().isSignedInteger(64));
    EXPECT_TRUE(mlir::succeeded(mlir::verify(module.getOperation())));
}

TEST(VerifyAuditTest, HighCallTargetAddressUsesUnsignedI64Contract) {
    mlir::MLIRContext context;
    context.getOrLoadDialect<helix::high::HelixHighDialect>();
    mlir::OpBuilder builder(&context);
    auto module = mlir::ModuleOp::create(builder.getUnknownLoc());
    builder.setInsertionPointToStart(module.getBody());
    auto unsignedI64 = mlir::IntegerType::get(
        &context, 64, mlir::IntegerType::Unsigned);
    auto call = builder.create<helix::high::CallOp>(
        builder.getUnknownLoc(),
        mlir::TypeRange{},
        mlir::IntegerAttr::get(unsignedI64, llvm::APInt(64, 0x140001000)),
        builder.getStringAttr("sub_140001000"),
        mlir::ValueRange{},
        mlir::IntegerAttr{});

    EXPECT_TRUE(call.getTargetAddrAttr().getType().isUnsignedInteger(64));
    EXPECT_TRUE(mlir::succeeded(mlir::verify(module.getOperation())));
}

TEST(VerifyAuditTest, HighFieldOffsetUsesUnsignedI64Contract) {
    mlir::MLIRContext context;
    context.getOrLoadDialect<helix::high::HelixHighDialect>();
    context.getOrLoadDialect<mlir::func::FuncDialect>();
    mlir::OpBuilder builder(&context);
    auto module = mlir::ModuleOp::create(builder.getUnknownLoc());
    builder.setInsertionPointToStart(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        builder.getUnknownLoc(), "field_contract",
        builder.getFunctionType({builder.getI64Type()}, {}));
    mlir::Block* entry = function.addEntryBlock();
    builder.setInsertionPointToEnd(entry);
    auto unsignedI64 = mlir::IntegerType::get(
        &context, 64, mlir::IntegerType::Unsigned);
    auto field = builder.create<helix::high::FieldAccessOp>(
        builder.getUnknownLoc(),
        builder.getI64Type(),
        entry->getArgument(0),
        builder.getStringAttr("field_0x10"),
        mlir::IntegerAttr::get(unsignedI64, llvm::APInt(64, 0x10)),
        builder.getUnitAttr(),
        mlir::IntegerAttr{});
    builder.create<mlir::func::ReturnOp>(builder.getUnknownLoc());

    EXPECT_TRUE(field.getFieldOffsetAttr().getType().isUnsignedInteger(64));
    EXPECT_TRUE(mlir::succeeded(mlir::verify(module.getOperation())));
}

TEST(VerifyAuditTest, LowRegisterWidthVerifierRejectsMismatch) {
    mlir::MLIRContext context;
    context.getOrLoadDialect<helix::low::HelixLowDialect>();
    mlir::OpBuilder builder(&context);
    auto module = mlir::ModuleOp::create(builder.getUnknownLoc());
    builder.setInsertionPointToStart(module.getBody());
    builder.create<helix::low::RegReadOp>(
        builder.getUnknownLoc(), builder.getI32Type(), "RAX",
        /*bit_width=*/64, mlir::IntegerAttr{});

    EXPECT_TRUE(mlir::failed(mlir::verify(module.getOperation())));
}

TEST(VerifyAuditTest, LowBinaryVerifierRejectsMixedOperandWidths) {
    mlir::MLIRContext context;
    context.getOrLoadDialect<helix::low::HelixLowDialect>();
    context.getOrLoadDialect<mlir::func::FuncDialect>();
    context.getOrLoadDialect<mlir::arith::ArithDialect>();
    mlir::OpBuilder builder(&context);
    auto module = mlir::ModuleOp::create(builder.getUnknownLoc());
    builder.setInsertionPointToStart(module.getBody());
    auto function = builder.create<mlir::func::FuncOp>(
        builder.getUnknownLoc(), "mixed_width_binary",
        builder.getFunctionType({}, {}));
    auto* entry = function.addEntryBlock();
    builder.setInsertionPointToStart(entry);
    auto lhs = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 1, 32);
    auto rhs = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 1, 64);
    builder.create<helix::low::BinOp>(
        builder.getUnknownLoc(), builder.getI32Type(), builder.getI1Type(),
        builder.getI1Type(), builder.getI1Type(), builder.getI1Type(),
        helix::low::BinOpKind::Add, lhs, rhs, mlir::IntegerAttr{},
        mlir::UnitAttr{});
    builder.create<mlir::func::ReturnOp>(builder.getUnknownLoc());

    EXPECT_TRUE(mlir::failed(mlir::verify(module.getOperation())));
}

} // namespace
