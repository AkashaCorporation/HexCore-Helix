#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixMidDialect.h"
#include "helix/dialects/HelixMidOps.h"
#include "helix/dialects/HelixEffects.h"
#include "helix/passes/Passes.h"
#include "helix/analysis/TypeEvidence.h"
#include "helix/cast/CAstBuilder.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Verifier.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"

#include <gtest/gtest.h>

namespace {

llvm::SmallVector<mlir::MemoryEffects::EffectInstance, 4>
getEffects(mlir::Operation* operation) {
    auto interface = llvm::dyn_cast<mlir::MemoryEffectOpInterface>(operation);
    EXPECT_TRUE(static_cast<bool>(interface));
    llvm::SmallVector<mlir::MemoryEffects::EffectInstance, 4> effects;
    if (interface)
        interface.getEffects(effects);
    return effects;
}

template <typename EffectT, typename ResourceT>
bool hasEffectOn(mlir::Operation* operation) {
    auto effects = getEffects(operation);
    return llvm::any_of(effects, [](const auto& effect) {
        return llvm::isa<EffectT>(effect.getEffect()) &&
               effect.getResource() == ResourceT::get();
    });
}

struct TestIr {
    mlir::OwningOpRef<mlir::ModuleOp> module;
    helix::low::FuncOp function;
    mlir::Block* block;
};

TestIr createTestIr(mlir::MLIRContext& context, llvm::StringRef name) {
    context.getOrLoadDialect<helix::low::HelixLowDialect>();
    context.getOrLoadDialect<helix::mid::HelixMidDialect>();
    context.getOrLoadDialect<helix::high::HelixHighDialect>();
    context.getOrLoadDialect<mlir::arith::ArithDialect>();
    context.getOrLoadDialect<mlir::LLVM::LLVMDialect>();

    mlir::OpBuilder builder(&context);
    auto module = mlir::ModuleOp::create(builder.getUnknownLoc());
    builder.setInsertionPointToEnd(module.getBody());
    auto function = builder.create<helix::low::FuncOp>(
        builder.getUnknownLoc(), name, /*entry_address=*/0x1000,
        /*original_name=*/mlir::StringAttr{});
    mlir::Block* block = builder.createBlock(&function.getBody());
    return {std::move(module), function, block};
}

void runCse(mlir::MLIRContext& context, mlir::ModuleOp module) {
    ASSERT_TRUE(mlir::succeeded(mlir::verify(module)));
    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(mlir::createCSEPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(module)));
}

TEST(EffectsContractTest, RegReadDoesNotCrossInterveningRegWrite) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "reg_effect_barrier");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto one = builder.create<mlir::LLVM::ConstantOp>(
        builder.getUnknownLoc(), builder.getI64Type(), builder.getI64IntegerAttr(1));
    auto first = builder.create<helix::low::RegReadOp>(
        builder.getUnknownLoc(), builder.getI64Type(), "RAX", 64,
        mlir::IntegerAttr{});
    builder.create<helix::low::RegWriteOp>(
        builder.getUnknownLoc(), one, "RAX", 64, mlir::IntegerAttr{});
    auto second = builder.create<helix::low::RegReadOp>(
        builder.getUnknownLoc(), builder.getI64Type(), "RAX", 64,
        mlir::IntegerAttr{});
    builder.create<mlir::arith::AddIOp>(builder.getUnknownLoc(), first, second);
    builder.create<helix::low::RetOp>(builder.getUnknownLoc(), mlir::IntegerAttr{});

    runCse(context, *ir.module);
    size_t reads = 0;
    ir.module->walk([&](helix::low::RegReadOp) { ++reads; });
    EXPECT_EQ(reads, 2u);
}

TEST(EffectsContractTest, RegReadsMayCoalesceWithoutAWrite) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "reg_read_cse");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto first = builder.create<helix::low::RegReadOp>(
        builder.getUnknownLoc(), builder.getI64Type(), "RAX", 64,
        mlir::IntegerAttr{});
    auto second = builder.create<helix::low::RegReadOp>(
        builder.getUnknownLoc(), builder.getI64Type(), "RAX", 64,
        mlir::IntegerAttr{});
    builder.create<mlir::arith::AddIOp>(builder.getUnknownLoc(), first, second);
    builder.create<helix::low::RetOp>(builder.getUnknownLoc(), mlir::IntegerAttr{});

    runCse(context, *ir.module);
    size_t reads = 0;
    ir.module->walk([&](helix::low::RegReadOp) { ++reads; });
    EXPECT_EQ(reads, 1u);
}

TEST(EffectsContractTest, MidVarRefDoesNotCrossAssign) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "mid_var_effect_barrier");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto value = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 7, 64);
    auto first = builder.create<helix::mid::VarRefOp>(
        builder.getUnknownLoc(), builder.getI64Type(), 1, mlir::IntegerAttr{});
    builder.create<helix::mid::AssignOp>(
        builder.getUnknownLoc(), 1, value, mlir::IntegerAttr{});
    auto second = builder.create<helix::mid::VarRefOp>(
        builder.getUnknownLoc(), builder.getI64Type(), 1, mlir::IntegerAttr{});
    builder.create<mlir::arith::AddIOp>(builder.getUnknownLoc(), first, second);
    builder.create<helix::low::RetOp>(builder.getUnknownLoc(), mlir::IntegerAttr{});

    runCse(context, *ir.module);
    size_t references = 0;
    ir.module->walk([&](helix::mid::VarRefOp) { ++references; });
    EXPECT_EQ(references, 2u);
}

TEST(EffectsContractTest, HighVarRefDoesNotCrossAssign) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "high_var_effect_barrier");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto value = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 9, 64);
    auto first = builder.create<helix::high::VarRefOp>(
        builder.getUnknownLoc(), builder.getI64Type(), 1, "value",
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        builder.getUnknownLoc(), first, value, mlir::IntegerAttr{});
    auto second = builder.create<helix::high::VarRefOp>(
        builder.getUnknownLoc(), builder.getI64Type(), 1, "value",
        mlir::IntegerAttr{});
    builder.create<mlir::arith::AddIOp>(builder.getUnknownLoc(), first, second);
    builder.create<helix::low::RetOp>(builder.getUnknownLoc(), mlir::IntegerAttr{});

    runCse(context, *ir.module);
    size_t references = 0;
    ir.module->walk([&](helix::high::VarRefOp) { ++references; });
    EXPECT_EQ(references, 2u);
}

TEST(EffectsContractTest, StateCategoriesUseDistinctResources) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "resource_categories");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto address = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 0x1000, 64);
    auto regRead = builder.create<helix::low::RegReadOp>(
        builder.getUnknownLoc(), builder.getI64Type(), "RAX", 64,
        mlir::IntegerAttr{});
    auto memoryRead = builder.create<helix::low::MemReadOp>(
        builder.getUnknownLoc(), builder.getI64Type(), address, 64,
        mlir::IntegerAttr{});
    auto variableRead = builder.create<helix::mid::VarRefOp>(
        builder.getUnknownLoc(), builder.getI64Type(), 7,
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(
        builder.getUnknownLoc(), mlir::IntegerAttr{});

    EXPECT_TRUE((hasEffectOn<mlir::MemoryEffects::Read,
        helix::effects::RegisterStateResource>(regRead)));
    EXPECT_FALSE((hasEffectOn<mlir::MemoryEffects::Read,
        helix::effects::ProgramMemoryResource>(regRead)));
    EXPECT_TRUE((hasEffectOn<mlir::MemoryEffects::Read,
        helix::effects::ProgramMemoryResource>(memoryRead)));
    EXPECT_TRUE((hasEffectOn<mlir::MemoryEffects::Read,
        helix::effects::VariableStateResource>(variableRead)));
}

TEST(EffectsContractTest, HighAddressAndUnaryEffectsArePrecise) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "high_expression_effects");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto base = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 0x2000, 64);
    auto index = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 3, 64);
    auto neg = builder.create<helix::high::UnaryOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        helix::high::UnaryOpKind::Neg, base, mlir::IntegerAttr{});
    auto addressOf = builder.create<helix::high::UnaryOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        helix::high::UnaryOpKind::AddressOf, base, mlir::IntegerAttr{});
    auto deref = builder.create<helix::high::UnaryOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        helix::high::UnaryOpKind::Deref, base, mlir::IntegerAttr{});
    auto unsignedI64 = mlir::IntegerType::get(
        &context, 64, mlir::IntegerType::Unsigned);
    auto field = builder.create<helix::high::FieldAccessOp>(
        builder.getUnknownLoc(), builder.getI64Type(), base,
        builder.getStringAttr("field_0x10"),
        mlir::IntegerAttr::get(unsignedI64, 0x10),
        builder.getUnitAttr(), mlir::IntegerAttr{});
    auto subscript = builder.create<helix::high::SubscriptOp>(
        builder.getUnknownLoc(), builder.getI64Type(), base, index,
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(
        builder.getUnknownLoc(), mlir::IntegerAttr{});

    EXPECT_TRUE(getEffects(neg).empty());
    EXPECT_TRUE(getEffects(addressOf).empty());
    EXPECT_TRUE((hasEffectOn<mlir::MemoryEffects::Read,
        helix::effects::ProgramMemoryResource>(deref)));
    EXPECT_TRUE(getEffects(field).empty());
    EXPECT_TRUE(getEffects(subscript).empty());
}

TEST(EffectsContractTest, HighAssignClassifiesStorageTarget) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "assign_target_resource");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto value = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 9, 64);
    auto address = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 0x3000, 64);
    auto variable = builder.create<helix::high::VarRefOp>(
        builder.getUnknownLoc(), builder.getI64Type(), 1, "value",
        mlir::IntegerAttr{});
    auto variableAssign = builder.create<helix::high::AssignOp>(
        builder.getUnknownLoc(), variable, value, mlir::IntegerAttr{});
    auto memoryTarget = builder.create<helix::high::UnaryOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        helix::high::UnaryOpKind::Deref, address, mlir::IntegerAttr{});
    auto memoryAssign = builder.create<helix::high::AssignOp>(
        builder.getUnknownLoc(), memoryTarget, value, mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(
        builder.getUnknownLoc(), mlir::IntegerAttr{});

    EXPECT_TRUE((hasEffectOn<mlir::MemoryEffects::Write,
        helix::effects::VariableStateResource>(variableAssign)));
    EXPECT_FALSE((hasEffectOn<mlir::MemoryEffects::Write,
        helix::effects::ProgramMemoryResource>(variableAssign)));
    EXPECT_TRUE((hasEffectOn<mlir::MemoryEffects::Write,
        helix::effects::ProgramMemoryResource>(memoryAssign)));
}

TEST(EffectsContractTest, DceKeepsHighVariableFeedingMidStore) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "cross_tier_dce_store");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto loc = builder.getUnknownLoc();
    auto i64Ty = builder.getI64Type();

    builder.create<helix::high::VarDeclOp>(
        loc, /*var_id=*/13, "param_31", helix::high::StorageKind::Parameter,
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    builder.create<helix::high::VarDeclOp>(
        loc, /*var_id=*/24, "rax", helix::high::StorageKind::Register,
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    auto param = builder.create<helix::high::VarRefOp>(
        loc, i64Ty, /*var_id=*/13, "param_31", mlir::IntegerAttr{});
    auto target = builder.create<helix::high::VarRefOp>(
        loc, i64Ty, /*var_id=*/24, "rax", mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, target.getResult(), param.getResult(), mlir::IntegerAttr{});

    auto raxUse = builder.create<helix::high::VarRefOp>(
        loc, i64Ty, /*var_id=*/24, "rax", mlir::IntegerAttr{});
    auto field = builder.create<helix::mid::FieldPtrOp>(
        loc, i64Ty, raxUse.getResult(), /*field_offset=*/8,
        mlir::StringAttr{}, mlir::IntegerAttr{});
    auto value = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 32);
    builder.create<helix::mid::StoreOp>(
        loc, field.getResult(), value.getResult(), mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createEliminateDeadCodePass());
    ASSERT_TRUE(mlir::succeeded(manager.run(*ir.module)));

    unsigned assignments = 0;
    unsigned parameterDecls = 0;
    ir.module->walk([&](helix::high::AssignOp assign) {
        auto ref = assign.getTarget()
                       .getDefiningOp<helix::high::VarRefOp>();
        if (ref && ref.getVarId() == 24)
            ++assignments;
    });
    ir.module->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getVarId() == 13)
            ++parameterDecls;
    });
    EXPECT_EQ(assignments, 1u);
    EXPECT_EQ(parameterDecls, 1u);
}

TEST(EffectsContractTest, FinalContainerLegalizationPreservesFunctionBody) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "container_closure");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    builder.create<helix::low::RetOp>(
        builder.getUnknownLoc(), mlir::IntegerAttr{});
    ir.function->setAttr("calling_convention",
                         builder.getStringAttr("win64"));
    ir.function->setAttr("has_return_value", builder.getUnitAttr());

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createLegalizeFunctionContainersPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(*ir.module)));

    unsigned lowFunctions = 0;
    unsigned highFunctions = 0;
    unsigned returns = 0;
    ir.module->walk([&](helix::low::FuncOp) { ++lowFunctions; });
    ir.module->walk([&](helix::high::FuncOp function) {
        ++highFunctions;
        EXPECT_EQ(function.getSymName(), "container_closure");
        EXPECT_EQ(function.getCallingConvention().value_or(""), "win64");
        EXPECT_TRUE(function->hasAttr("has_return_value"));
    });
    ir.module->walk([&](helix::low::RetOp) { ++returns; });
    EXPECT_EQ(lowFunctions, 0u);
    EXPECT_EQ(highFunctions, 1u);
    EXPECT_EQ(returns, 1u);
}

TEST(EffectsContractTest, FinalFunctionCallAndReturnExposeStructuralInterfaces) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "interface_contract");
    EXPECT_TRUE(static_cast<bool>(
        llvm::dyn_cast<helix::HelixDecompilableOp>(
            ir.function.getOperation())));
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto loc = builder.getUnknownLoc();

    builder.create<helix::high::VarDeclOp>(
        loc, /*var_id=*/7, "param_1", helix::high::StorageKind::Parameter,
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    auto parameter = builder.create<helix::high::VarRefOp>(
        loc, builder.getI32Type(), /*var_id=*/7, "param_1",
        mlir::IntegerAttr{});
    auto call = builder.create<helix::high::CallOp>(
        loc, mlir::TypeRange{}, /*target_addr=*/0x2000,
        "callee", mlir::ValueRange{parameter.getResult()},
        mlir::IntegerAttr{});
    auto returnOp = builder.create<helix::high::ReturnOp>(
        loc, mlir::Value{}, mlir::IntegerAttr{});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createLegalizeFunctionContainersPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(*ir.module)));

    auto function = *ir.module->getOps<helix::high::FuncOp>().begin();
    auto functionInterface = llvm::dyn_cast<mlir::FunctionOpInterface>(
        function.getOperation());
    ASSERT_TRUE(static_cast<bool>(functionInterface));
    ASSERT_EQ(functionInterface.getNumArguments(), 1u);
    ASSERT_EQ(function.getBody().front().getNumArguments(), 1u);
    EXPECT_EQ(function.getBody().front().getArgument(0).getType(),
              builder.getI32Type());
    ASSERT_EQ(call.getArgs().size(), 1u);
    EXPECT_EQ(call.getArgs().front(),
              function.getBody().front().getArgument(0));
    auto argumentAttrs = function->getAttrOfType<mlir::ArrayAttr>(
        "arg_attrs");
    ASSERT_TRUE(argumentAttrs);
    ASSERT_EQ(argumentAttrs.size(), 1u);
    auto argumentMetadata = llvm::cast<mlir::DictionaryAttr>(
        argumentAttrs[0]);
    EXPECT_EQ(argumentMetadata.getAs<mlir::StringAttr>("helix.name")
                  .getValue(),
              "param_1");

    helix::cast::CAstBuilder astBuilder;
    auto declaration = astBuilder.buildFunction(function.getOperation());
    ASSERT_NE(declaration, nullptr);
    ASSERT_EQ(declaration->params.size(), 1u);
    EXPECT_EQ(declaration->params.front().index, 1u);
    ASSERT_TRUE(declaration->params.front().varId.has_value());
    EXPECT_EQ(*declaration->params.front().varId, 7u);

    auto callable = llvm::dyn_cast<mlir::CallableOpInterface>(
        function.getOperation());
    ASSERT_TRUE(static_cast<bool>(callable));
    ASSERT_EQ(callable.getArgumentTypes().size(), 1u);
    EXPECT_TRUE(callable.getArgumentTypes().front().isInteger(32));
    EXPECT_TRUE(callable.getResultTypes().empty());
    EXPECT_TRUE(function->getAttrOfType<mlir::BoolAttr>(
                             "helix.signature_complete")
                    .getValue());

    auto callInterface = llvm::dyn_cast<mlir::CallOpInterface>(
        call.getOperation());
    ASSERT_TRUE(static_cast<bool>(callInterface));
    EXPECT_EQ(callInterface.getArgOperands().size(), 1u);
    auto callee = callInterface.getCallableForCallee()
                      .get<mlir::SymbolRefAttr>();
    EXPECT_EQ(callee.getRootReference(), "callee");
    EXPECT_TRUE(returnOp->hasTrait<mlir::OpTrait::ReturnLike>());

    auto metadata = llvm::dyn_cast<helix::HelixDecompilableOp>(
        function.getOperation());
    ASSERT_TRUE(static_cast<bool>(metadata));
    EXPECT_EQ(metadata.getEntryAddress(), 0x1000u);
}

TEST(EffectsContractTest, AllHelixTiersExposeUniformSourceAddressInterface) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "addressable_contract");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto loc = builder.getUnknownLoc();
    auto signedI64 = mlir::IntegerType::get(
        &context, 64, mlir::IntegerType::Signed);
    auto midValue = builder.create<helix::mid::ConstantOp>(
        loc, builder.getI64Type(), mlir::IntegerAttr::get(signedI64, 7),
        mlir::IntegerAttr{});
    auto highValue = builder.create<helix::high::IntLitOp>(
        loc, builder.getI64Type(), mlir::IntegerAttr::get(signedI64, 9),
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    auto lowAddressable = llvm::dyn_cast<helix::HelixAddressableOp>(
        ir.function.getOperation());
    auto midAddressable = llvm::dyn_cast<helix::HelixAddressableOp>(
        midValue.getOperation());
    auto highAddressable = llvm::dyn_cast<helix::HelixAddressableOp>(
        highValue.getOperation());
    ASSERT_TRUE(lowAddressable);
    ASSERT_TRUE(midAddressable);
    ASSERT_TRUE(highAddressable);

    EXPECT_FALSE(lowAddressable.hasSourceAddress());
    lowAddressable.setSourceAddress(0x401000);
    midAddressable.setSourceAddress(0x401004);
    highAddressable.setSourceAddress(0x401008);
    EXPECT_EQ(lowAddressable.getSourceAddress(), 0x401000u);
    EXPECT_EQ(midAddressable.getSourceAddress(), 0x401004u);
    EXPECT_EQ(highAddressable.getSourceAddress(), 0x401008u);
    midAddressable.removeSourceAddress();
    EXPECT_FALSE(midAddressable.hasSourceAddress());
    EXPECT_TRUE(mlir::succeeded(mlir::verify(*ir.module)));
}

TEST(EffectsContractTest, LowCallsExposeDirectAndIndirectCallables) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "low_call_interface");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto loc = builder.getUnknownLoc();
    auto target = builder.create<mlir::arith::ConstantIntOp>(
        loc, 0x401000, 64);
    auto argument = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    auto direct = builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{}, target,
        mlir::ValueRange{argument.getResult()},
        builder.getStringAttr("callee"), mlir::IntegerAttr{});
    auto indirect = builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{}, target, mlir::ValueRange{},
        mlir::StringAttr{}, mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    auto directInterface = llvm::dyn_cast<mlir::CallOpInterface>(
        direct.getOperation());
    auto indirectInterface = llvm::dyn_cast<mlir::CallOpInterface>(
        indirect.getOperation());
    ASSERT_TRUE(directInterface);
    ASSERT_TRUE(indirectInterface);
    EXPECT_EQ(directInterface.getArgOperands().size(), 1u);
    EXPECT_EQ(directInterface.getCallableForCallee()
                  .get<mlir::SymbolRefAttr>()
                  .getRootReference(),
              "callee");
    EXPECT_EQ(indirectInterface.getCallableForCallee().get<mlir::Value>(),
              target.getResult());
    EXPECT_TRUE(mlir::succeeded(mlir::verify(*ir.module)));
}

TEST(EffectsContractTest, MidCallsExposeResolvedCallableAndArguments) {
    mlir::MLIRContext context;
    context.getOrLoadDialect<helix::mid::HelixMidDialect>();
    context.getOrLoadDialect<mlir::arith::ArithDialect>();
    mlir::OpBuilder builder(&context);
    auto module = mlir::ModuleOp::create(builder.getUnknownLoc());
    builder.setInsertionPointToStart(module.getBody());
    auto loc = builder.getUnknownLoc();
    auto argument = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    auto addressType = mlir::IntegerType::get(
        &context, 64, mlir::IntegerType::Unsigned);
    auto address = mlir::IntegerAttr::get(
        addressType, llvm::APInt(64, 0x401000));
    auto named = builder.create<helix::mid::CallOp>(
        loc, mlir::TypeRange{}, address,
        builder.getStringAttr("callee"),
        mlir::ValueRange{argument.getResult()}, mlir::IntegerAttr{});
    auto unresolved = builder.create<helix::mid::CallOp>(
        loc, mlir::TypeRange{}, address, mlir::StringAttr{},
        mlir::ValueRange{}, mlir::IntegerAttr{});

    auto namedInterface = llvm::dyn_cast<mlir::CallOpInterface>(
        named.getOperation());
    auto unresolvedInterface = llvm::dyn_cast<mlir::CallOpInterface>(
        unresolved.getOperation());
    ASSERT_TRUE(namedInterface);
    ASSERT_TRUE(unresolvedInterface);
    EXPECT_EQ(namedInterface.getArgOperands().size(), 1u);
    EXPECT_EQ(namedInterface.getCallableForCallee()
                  .get<mlir::SymbolRefAttr>()
                  .getRootReference(),
              "callee");
    EXPECT_FALSE(static_cast<bool>(
        unresolvedInterface.getCallableForCallee()));
    unresolvedInterface.setCalleeFromCallable(
        mlir::SymbolRefAttr::get(&context, "resolved_late"));
    EXPECT_EQ(unresolved.getCalleeName().value_or(""), "resolved_late");
    EXPECT_TRUE(mlir::succeeded(mlir::verify(module.getOperation())));
}

TEST(EffectsContractTest, StrongerTypeEvidenceWinsWithProvenance) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "type_evidence_precedence");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto value = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 0, 64);

    EXPECT_TRUE(helix::applyTypeEvidence(
        value, "int64_t", helix::TypeEvidenceSource::DataFlow));
    EXPECT_TRUE(helix::applyTypeEvidence(
        value, "struct record*", helix::TypeEvidenceSource::DebugInfo));
    EXPECT_FALSE(helix::applyTypeEvidence(
        value, "bool", helix::TypeEvidenceSource::DataFlow));

    auto evidence = helix::readTypeEvidence(value);
    ASSERT_TRUE(evidence.has_value());
    EXPECT_EQ(evidence->spelling, "struct record*");
    EXPECT_EQ(evidence->source, helix::TypeEvidenceSource::DebugInfo);
    EXPECT_EQ(evidence->strength, 100u);
    EXPECT_FALSE(evidence->conflict);
    EXPECT_EQ(value->getAttrOfType<mlir::StringAttr>("inferred_type")
                  .getValue(),
              "struct record*");
    EXPECT_EQ(value->getAttrOfType<mlir::StringAttr>("helix.type.rejected")
                  .getValue(),
              "bool");
}

TEST(EffectsContractTest, EqualTypeEvidenceConflictIsExplicitAndStable) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "type_evidence_conflict");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto value = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 0, 64);

    EXPECT_TRUE(helix::applyTypeEvidence(
        value, "struct left*", helix::TypeEvidenceSource::Structural));
    EXPECT_FALSE(helix::applyTypeEvidence(
        value, "struct right*", helix::TypeEvidenceSource::Structural));

    auto evidence = helix::readTypeEvidence(value);
    ASSERT_TRUE(evidence.has_value());
    EXPECT_EQ(evidence->spelling, "struct left*");
    EXPECT_TRUE(evidence->conflict);
}

TEST(EffectsContractTest, EqualDataflowPointerRefinesScalar) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "type_evidence_pointer_refinement");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto value = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 0, 64);

    EXPECT_TRUE(helix::applyTypeEvidence(
        value, "int32_t", helix::TypeEvidenceSource::DataFlow));
    EXPECT_TRUE(helix::applyTypeEvidence(
        value, "struct node*", helix::TypeEvidenceSource::DataFlow));

    auto evidence = helix::readTypeEvidence(value);
    ASSERT_TRUE(evidence.has_value());
    EXPECT_EQ(evidence->spelling, "struct node*");
    EXPECT_FALSE(evidence->conflict);
}

TEST(EffectsContractTest, MemorySlotPilotPromotesMarkedWholeValueSlot) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "memory_slot_positive");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto loc = builder.getUnknownLoc();
    auto i64Type = builder.getI64Type();
    auto slotType = helix::mid::SlotType::get(&context, i64Type);
    auto slot = builder.create<helix::mid::SlotAllocOp>(
        loc, slotType, builder.getUnitAttr());
    auto stored = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    builder.create<helix::mid::SlotStoreOp>(
        loc, slot.getSlot(), stored.getResult());
    auto loaded = builder.create<helix::mid::SlotLoadOp>(
        loc, i64Type, slot.getSlot());
    builder.create<helix::high::ReturnOp>(
        loc, loaded.getResult(), mlir::IntegerAttr{});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createMemorySlotPilotPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(*ir.module)));

    unsigned allocations = 0;
    unsigned loads = 0;
    unsigned stores = 0;
    ir.module->walk([&](helix::mid::SlotAllocOp) { ++allocations; });
    ir.module->walk([&](helix::mid::SlotLoadOp) { ++loads; });
    ir.module->walk([&](helix::mid::SlotStoreOp) { ++stores; });
    EXPECT_EQ(allocations, 0u);
    EXPECT_EQ(loads, 0u);
    EXPECT_EQ(stores, 0u);
    auto knownConstants = (*ir.module)->getAttrOfType<mlir::IntegerAttr>(
        "helix.dataflow_pilot.known_constants");
    ASSERT_TRUE(static_cast<bool>(knownConstants));
    EXPECT_GT(knownConstants.getValue().getZExtValue(), 0u);

    mlir::Value returnValue;
    ir.module->walk([&](helix::high::ReturnOp returnOp) {
        returnValue = returnOp.getValue();
    });
    EXPECT_EQ(returnValue, stored.getResult());
}

TEST(EffectsContractTest, MemorySlotPilotRejectsUnmarkedSlot) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "memory_slot_negative");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto loc = builder.getUnknownLoc();
    auto i64Type = builder.getI64Type();
    auto slotType = helix::mid::SlotType::get(&context, i64Type);
    auto slot = builder.create<helix::mid::SlotAllocOp>(
        loc, slotType, mlir::UnitAttr{});
    auto stored = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    builder.create<helix::mid::SlotStoreOp>(
        loc, slot.getSlot(), stored.getResult());
    auto loaded = builder.create<helix::mid::SlotLoadOp>(
        loc, i64Type, slot.getSlot());
    builder.create<helix::high::ReturnOp>(
        loc, loaded.getResult(), mlir::IntegerAttr{});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createMemorySlotPilotPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(*ir.module)));

    unsigned allocations = 0;
    ir.module->walk([&](helix::mid::SlotAllocOp) { ++allocations; });
    EXPECT_EQ(allocations, 1u);
}

TEST(EffectsContractTest, MemorySlotPilotMaterializesSafeStackLocal) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "memory_slot_real_family");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto loc = builder.getUnknownLoc();
    auto signedI64 = mlir::IntegerType::get(
        &context, 64, mlir::IntegerType::Signed);
    auto declaration = builder.create<helix::mid::VarDeclOp>(
        loc, /*slot_id=*/7, helix::mid::SlotKind::Stack,
        mlir::IntegerAttr::get(signedI64, -8), mlir::Value{},
        mlir::IntegerAttr{});
    declaration->setAttr(
        "helix.recovered_name", builder.getStringAttr("var_8"));
    auto stored = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    builder.create<helix::mid::AssignOp>(
        loc, /*slot_id=*/7, stored.getResult(), mlir::IntegerAttr{});
    auto reference = builder.create<helix::mid::VarRefOp>(
        loc, builder.getI64Type(), /*slot_id=*/7, mlir::IntegerAttr{});
    builder.create<helix::high::ReturnOp>(
        loc, reference.getResult(), mlir::IntegerAttr{});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createMemorySlotPilotPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(*ir.module)));

    auto materialized = (*ir.module)->getAttrOfType<mlir::IntegerAttr>(
        "helix.memory_slot_pilot.materialized");
    auto promoted = (*ir.module)->getAttrOfType<mlir::IntegerAttr>(
        "helix.memory_slot_pilot.promoted");
    ASSERT_TRUE(materialized);
    ASSERT_TRUE(promoted);
    EXPECT_EQ(materialized.getInt(), 1);
    EXPECT_EQ(promoted.getInt(), 1);
    unsigned variableOps = 0, slotOps = 0;
    ir.module->walk([&](helix::mid::VarDeclOp) { ++variableOps; });
    ir.module->walk([&](helix::mid::VarRefOp) { ++variableOps; });
    ir.module->walk([&](helix::mid::AssignOp) { ++variableOps; });
    ir.module->walk([&](helix::mid::SlotAllocOp) { ++slotOps; });
    ir.module->walk([&](helix::mid::SlotLoadOp) { ++slotOps; });
    ir.module->walk([&](helix::mid::SlotStoreOp) { ++slotOps; });
    EXPECT_EQ(variableOps, 0u);
    EXPECT_EQ(slotOps, 0u);
}

TEST(EffectsContractTest, EscapeAnalysisVisitsMidBodyInsideLowFunction) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "escape_container_selection");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto loc = builder.getUnknownLoc();
    auto escaping = builder.create<helix::mid::VarDeclOp>(
        loc, /*slot_id=*/1, helix::mid::SlotKind::Temp,
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    auto local = builder.create<helix::mid::VarDeclOp>(
        loc, /*slot_id=*/2, helix::mid::SlotKind::Temp,
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    auto reference = builder.create<helix::mid::VarRefOp>(
        loc, builder.getI64Type(), /*slot_id=*/1, mlir::IntegerAttr{});
    builder.create<helix::mid::UnExprOp>(
        loc, builder.getI64Type(), helix::mid::UnExprKind::AddrOf,
        reference.getResult(), mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager manager(&context);
    manager.enableVerifier(true);
    manager.addPass(helix::createEscapeAnalysisPass());
    ASSERT_TRUE(mlir::succeeded(manager.run(*ir.module)));

    auto escapingAttr = escaping->getAttrOfType<mlir::BoolAttr>(
        "helix.escapes");
    auto localAttr = local->getAttrOfType<mlir::BoolAttr>("helix.escapes");
    ASSERT_TRUE(static_cast<bool>(escapingAttr));
    ASSERT_TRUE(static_cast<bool>(localAttr));
    EXPECT_TRUE(escapingAttr.getValue());
    EXPECT_FALSE(localAttr.getValue());
}

TEST(EffectsContractTest, PureUnaryMayCseAcrossVariableWrite) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "pure_unary_cse");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto value = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 7, 64);
    auto target = builder.create<helix::high::VarRefOp>(
        builder.getUnknownLoc(), builder.getI64Type(), 1, "value",
        mlir::IntegerAttr{});
    auto first = builder.create<helix::high::UnaryOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        helix::high::UnaryOpKind::Neg, value, mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        builder.getUnknownLoc(), target, value, mlir::IntegerAttr{});
    auto second = builder.create<helix::high::UnaryOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        helix::high::UnaryOpKind::Neg, value, mlir::IntegerAttr{});
    builder.create<mlir::arith::AddIOp>(
        builder.getUnknownLoc(), first, second);
    builder.create<helix::low::RetOp>(
        builder.getUnknownLoc(), mlir::IntegerAttr{});

    runCse(context, *ir.module);
    size_t negations = 0;
    ir.module->walk([&](helix::high::UnaryOp op) {
        if (op.getOp() == helix::high::UnaryOpKind::Neg)
            ++negations;
    });
    EXPECT_EQ(negations, 1u);
}

TEST(EffectsContractTest, MemoryReadDoesNotCseAcrossMemoryAssign) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "memory_read_barrier");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto address = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 0x4000, 64);
    auto value = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 3, 64);
    auto first = builder.create<helix::high::UnaryOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        helix::high::UnaryOpKind::Deref, address, mlir::IntegerAttr{});
    auto target = builder.create<helix::high::UnaryOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        helix::high::UnaryOpKind::Deref, address, mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        builder.getUnknownLoc(), target, value, mlir::IntegerAttr{});
    auto second = builder.create<helix::high::UnaryOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        helix::high::UnaryOpKind::Deref, address, mlir::IntegerAttr{});
    builder.create<mlir::arith::AddIOp>(
        builder.getUnknownLoc(), first, second);
    builder.create<helix::low::RetOp>(
        builder.getUnknownLoc(), mlir::IntegerAttr{});

    runCse(context, *ir.module);
    size_t dereferences = 0;
    ir.module->walk([&](helix::high::UnaryOp op) {
        if (op.getOp() == helix::high::UnaryOpKind::Deref)
            ++dereferences;
    });
    EXPECT_EQ(dereferences, 2u);
}

TEST(EffectsContractTest, MidDerefDoesNotCseAcrossStore) {
    mlir::MLIRContext context;
    auto ir = createTestIr(context, "mid_memory_read_barrier");
    mlir::OpBuilder builder(&context);
    builder.setInsertionPointToStart(ir.block);
    auto address = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 0x5000, 64);
    auto value = builder.create<mlir::arith::ConstantIntOp>(
        builder.getUnknownLoc(), 7, 64);
    auto first = builder.create<helix::mid::UnExprOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        helix::mid::UnExprKind::Deref, address, mlir::IntegerAttr{});
    builder.create<helix::mid::StoreOp>(
        builder.getUnknownLoc(), address, value, mlir::IntegerAttr{});
    auto second = builder.create<helix::mid::UnExprOp>(
        builder.getUnknownLoc(), builder.getI64Type(),
        helix::mid::UnExprKind::Deref, address, mlir::IntegerAttr{});
    builder.create<mlir::arith::AddIOp>(
        builder.getUnknownLoc(), first, second);
    builder.create<helix::low::RetOp>(
        builder.getUnknownLoc(), mlir::IntegerAttr{});

    runCse(context, *ir.module);
    size_t dereferences = 0;
    ir.module->walk([&](helix::mid::UnExprOp op) {
        if (op.getKind() == helix::mid::UnExprKind::Deref)
            ++dereferences;
    });
    EXPECT_EQ(dereferences, 2u);
}

} // namespace
