/// @file ApplyDebugTypesTest.cpp
/// @brief Direct contracts for nominal debug-type propagation.

#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/passes/Passes.h"
#include "helix/cast/CAstBuilder.h"
#include "helix/cast/CAstPrinter.h"

#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"

#include <gtest/gtest.h>

namespace {

mlir::OwningOpRef<mlir::ModuleOp>
buildNominalAliasFixture(mlir::MLIRContext& ctx) {
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr(
        "helix.debug_type_info_json",
        builder.getStringAttr(R"json({
          "functions": {
            "nominal_alias": {
              "returnType": "void",
              "params": [
                {"index": 0, "name": "kctx",
                 "type": "struct kbase_context *"}
              ]
            },
            "kfree": {
              "returnType": "void",
              "params": [
                {"index": 0, "name": "ptr", "type": "void *"}
              ]
            }
          },
          "structs": {
            "kbase_context": {
              "fields": [
                {"name": "slots", "offset": "0x8", "size": 0,
                 "type": "u8[256]"}
              ]
            }
          }
        })json"));

    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "nominal_alias", /*entry_address=*/0x1000,
        /*original_name=*/mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);

    auto parameter = builder.create<helix::high::VarDeclOp>(
        loc, builder.getUI32IntegerAttr(1),
        builder.getStringAttr("param_1"),
        helix::high::StorageKindAttr::get(
            &ctx, helix::high::StorageKind::Parameter),
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    parameter->setAttr("inferred_type",
                       builder.getStringAttr("auto_struct_0*"));

    auto alias = builder.create<helix::high::VarDeclOp>(
        loc, builder.getUI32IntegerAttr(2), builder.getStringAttr("rbx"),
        helix::high::StorageKindAttr::get(
            &ctx, helix::high::StorageKind::Register),
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    alias->setAttr("inferred_type",
                   builder.getStringAttr("auto_struct_6*"));

    auto scalar = builder.create<helix::high::VarDeclOp>(
        loc, builder.getUI32IntegerAttr(3),
        builder.getStringAttr("counter"),
        helix::high::StorageKindAttr::get(
            &ctx, helix::high::StorageKind::Temporary),
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    scalar->setAttr("inferred_type", builder.getStringAttr("int64_t"));

    auto reused = builder.create<helix::high::VarDeclOp>(
        loc, builder.getUI32IntegerAttr(4),
        builder.getStringAttr("reused_register"),
        helix::high::StorageKindAttr::get(
            &ctx, helix::high::StorageKind::Register),
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    reused->setAttr("inferred_type",
                    builder.getStringAttr("auto_struct_7*"));

    auto extraParameter = builder.create<helix::high::VarDeclOp>(
        loc, builder.getUI32IntegerAttr(5),
        builder.getStringAttr("param_3"),
        helix::high::StorageKindAttr::get(
            &ctx, helix::high::StorageKind::Parameter),
        mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
    extraParameter->setAttr("inferred_type",
                            builder.getStringAttr("auto_struct_8*"));

    auto i64 = builder.getI64Type();
    auto parameterRef = builder.create<helix::high::VarRefOp>(
        loc, i64, parameter.getVarId(), parameter.getVarName(),
        mlir::IntegerAttr{});
    auto aliasTarget = builder.create<helix::high::VarRefOp>(
        loc, i64, alias.getVarId(), alias.getVarName(),
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, aliasTarget.getResult(), parameterRef.getResult(),
        mlir::IntegerAttr{});

    auto scalarTarget = builder.create<helix::high::VarRefOp>(
        loc, i64, scalar.getVarId(), scalar.getVarName(),
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, scalarTarget.getResult(), parameterRef.getResult(),
        mlir::IntegerAttr{});

    auto reusedTarget = builder.create<helix::high::VarRefOp>(
        loc, i64, reused.getVarId(), reused.getVarName(),
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, reusedTarget.getResult(), parameterRef.getResult(),
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, reusedTarget.getResult(), scalarTarget.getResult(),
        mlir::IntegerAttr{});

    auto extraParameterTarget = builder.create<helix::high::VarRefOp>(
        loc, i64, extraParameter.getVarId(), extraParameter.getVarName(),
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, extraParameterTarget.getResult(), parameterRef.getResult(),
        mlir::IntegerAttr{});

    auto aliasBase = builder.create<helix::high::VarRefOp>(
        loc, i64, alias.getVarId(), alias.getVarName(),
        mlir::IntegerAttr{});
    auto index = builder.create<helix::high::VarRefOp>(
        loc, i64, scalar.getVarId(), scalar.getVarName(),
        mlir::IntegerAttr{});
    auto indexed = builder.create<mlir::LLVM::AddOp>(
        loc, aliasBase.getResult(), index.getResult());
    auto offset = builder.create<mlir::LLVM::ConstantOp>(
        loc, i64, builder.getI64IntegerAttr(8));
    builder.create<mlir::LLVM::AddOp>(
        loc, indexed.getResult(), offset.getResult());

    auto call = builder.create<helix::high::CallOp>(
        loc, i64, /*target_addr=*/0, /*target_name=*/"kfree",
        mlir::ValueRange{aliasBase.getResult()}, mlir::IntegerAttr{});
    auto resultTarget = builder.create<helix::high::VarRefOp>(
        loc, i64, scalar.getVarId(), scalar.getVarName(),
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, resultTarget.getResult(), call.getResult(),
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    return module;
}

mlir::OwningOpRef<mlir::ModuleOp>
buildAapcsSignatureFixture(mlir::MLIRContext& ctx, bool variadic,
                           bool includeScratchWrites = true) {
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr("llvm.target_triple",
                    builder.getStringAttr("aarch64-linux-gnu"));
    module->setAttr(
        "helix.debug_type_info_json",
        builder.getStringAttr(variadic ? R"json({
          "functions": {
            "aapcs_signature": {
              "returnType": "void",
              "variadic": true,
              "params": [
                {"index": 0, "name": "queue", "type": "void *"}
              ]
            }
          },
          "structs": {}
        })json"
                                    : R"json({
          "functions": {
            "aapcs_signature": {
              "returnType": "void",
              "variadic": false,
              "params": [
                {"index": 0, "name": "queue", "type": "void *"},
                {"index": 1, "name": "drain_queue", "type": "int64_t"}
              ]
            }
          },
          "structs": {}
        })json"));

    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "aapcs_signature", /*entry_address=*/0x3000,
        /*original_name=*/mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto i64 = builder.getI64Type();
    builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    builder.create<helix::low::RegReadOp>(
        loc, i64, "X0", /*bit_width=*/64, mlir::IntegerAttr{});
    if (!variadic) {
        builder.create<helix::low::RegReadOp>(
            loc, i64, "X1", /*bit_width=*/64, mlir::IntegerAttr{});
    }

    if (!variadic && includeScratchWrites) {
        auto scratch0 = builder.create<mlir::arith::ConstantIntOp>(loc, 42, 64);
        builder.create<helix::low::RegWriteOp>(
            loc, scratch0.getResult(), "X0", /*bit_width=*/64,
            mlir::IntegerAttr{});
        builder.create<helix::low::RegReadOp>(
            loc, i64, "X0", /*bit_width=*/64, mlir::IntegerAttr{});
        builder.create<helix::low::RegReadOp>(
            loc, i64, "X0", /*bit_width=*/64, mlir::IntegerAttr{});

        auto scratch1 = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
        builder.create<helix::low::RegWriteOp>(
            loc, scratch1.getResult(), "X1", /*bit_width=*/64,
            mlir::IntegerAttr{});
        builder.create<helix::low::RegReadOp>(
            loc, i64, "X1", /*bit_width=*/64, mlir::IntegerAttr{});
        builder.create<helix::low::RegReadOp>(
            loc, i64, "X1", /*bit_width=*/64, mlir::IntegerAttr{});
    }
    builder.create<helix::low::RegReadOp>(
        loc, i64, "X3", /*bit_width=*/64, mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
    return module;
}

mlir::OwningOpRef<mlir::ModuleOp>
buildNestedAapcsParameterWriteFixture(mlir::MLIRContext& ctx) {
    auto module = buildAapcsSignatureFixture(
        ctx, /*variadic=*/false, /*includeScratchWrites=*/false);

    helix::low::FuncOp func;
    module->walk([&](helix::low::FuncOp candidate) { func = candidate; });
    auto& entry = func.getBody().front();
    auto terminator = mlir::dyn_cast<helix::low::RetOp>(entry.back());

    mlir::OpBuilder builder(&ctx);
    builder.setInsertionPoint(terminator);
    auto loc = builder.getUnknownLoc();
    auto condition =
        builder.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
    auto ifOp = builder.create<helix::high::IfOp>(
        loc, condition.getResult(), mlir::IntegerAttr{});

    auto* thenBlock = builder.createBlock(&ifOp.getThenRegion());
    builder.setInsertionPointToStart(thenBlock);
    auto scratch = builder.create<mlir::arith::ConstantIntOp>(loc, 99, 64);
    builder.create<helix::low::RegWriteOp>(
        loc, scratch.getResult(), "X0", /*bit_width=*/64,
        mlir::IntegerAttr{});
    builder.create<helix::low::RegReadOp>(
        loc, builder.getI64Type(), "X0", /*bit_width=*/64,
        mlir::IntegerAttr{});
    builder.create<helix::high::YieldOp>(loc, mlir::Value{});

    return module;
}

} // namespace

TEST(ApplyDebugTypesTest, NominalPointerReplacesOnlySyntheticCopyAlias) {
    mlir::MLIRContext ctx;
    auto module = buildNominalAliasFixture(ctx);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createApplyDebugTypesPass());
    pm.addPass(helix::createApplyDebugTypesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    std::string parameterType;
    std::string aliasType;
    std::string scalarType;
    std::string reusedType;
    std::string extraParameterType;
    module->walk([&](helix::high::VarDeclOp decl) {
        auto type = decl->getAttrOfType<mlir::StringAttr>("inferred_type");
        if (!type)
            return;
        if (decl.getVarName() == "param_1")
            parameterType = type.getValue().str();
        else if (decl.getVarName() == "rbx")
            aliasType = type.getValue().str();
        else if (decl.getVarName() == "counter")
            scalarType = type.getValue().str();
        else if (decl.getVarName() == "reused_register")
            reusedType = type.getValue().str();
        else if (decl.getVarName() == "param_3")
            extraParameterType = type.getValue().str();
    });

    EXPECT_EQ(parameterType, "struct kbase_context *");
    EXPECT_EQ(aliasType, "struct kbase_context *");
    EXPECT_EQ(scalarType, "int64_t");
    EXPECT_EQ(reusedType, "auto_struct_7*");
    EXPECT_EQ(extraParameterType, "auto_struct_8*");

    unsigned indexedFields = 0;
    module->walk([&](mlir::LLVM::AddOp add) {
        auto name = add->getAttrOfType<mlir::StringAttr>(
            "helix.debug_indexed_field_name");
        if (name && name.getValue() == "slots")
            ++indexedFields;
    });
    EXPECT_EQ(indexedFields, 1u);

    helix::low::FuncOp function;
    module->walk([&](helix::low::FuncOp candidate) {
        function = candidate;
    });
    ASSERT_TRUE(function);
    helix::cast::CAstBuilder astBuilder;
    auto declaration = astBuilder.buildFunction(function.getOperation());
    ASSERT_NE(declaration, nullptr);
    helix::cast::CAstPrinter printer;
    const std::string code = printer.print(*declaration);
    EXPECT_NE(code.find("kfree("), std::string::npos) << code;
    EXPECT_EQ(code.find("= kfree("), std::string::npos) << code;
}

TEST(ApplyDebugTypesTest, PropagateTypesVisitsHighOpsInLowFunctionContainer) {
    mlir::MLIRContext ctx;
    auto module = buildNominalAliasFixture(ctx);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createPropagateTypesHighPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    std::string parameterRefType;
    module->walk([&](helix::high::VarRefOp ref) {
        if (ref.getVarName() != "param_1")
            return;
        if (auto type =
                ref->getAttrOfType<mlir::StringAttr>("inferred_type"))
            parameterRefType = type.getValue().str();
    });

    EXPECT_FALSE(parameterRefType.empty());
}

TEST(ApplyDebugTypesTest, NominalTypesDoNotContaminateReusedOrParameterSlots) {
    mlir::MLIRContext ctx;
    auto module = buildNominalAliasFixture(ctx);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createApplyDebugTypesPass());
    pm.addPass(helix::createPropagateTypesHighPass());
    pm.addPass(helix::createApplyDebugTypesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    std::string aliasType;
    std::string reusedType;
    std::string extraParameterType;
    module->walk([&](helix::high::VarDeclOp decl) {
        auto type = decl->getAttrOfType<mlir::StringAttr>("inferred_type");
        if (!type)
            return;
        if (decl.getVarName() == "rbx")
            aliasType = type.getValue().str();
        else if (decl.getVarName() == "reused_register")
            reusedType = type.getValue().str();
        else if (decl.getVarName() == "param_3")
            extraParameterType = type.getValue().str();
    });

    EXPECT_TRUE(aliasType == "struct kbase_context *" ||
                aliasType == "kbase_context*");
    EXPECT_NE(reusedType, "kbase_context*");
    EXPECT_NE(reusedType, "struct kbase_context *");
    EXPECT_NE(extraParameterType, "kbase_context*");
    EXPECT_NE(extraParameterType, "struct kbase_context *");
}

TEST(ApplyDebugTypesTest, DebugVoidReturnOverridesRaxWriteHeuristic) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr(
        "helix.debug_type_info_json",
        builder.getStringAttr(R"json({
          "functions": {
            "debug_void_scratch_rax": {
              "returnType": "void",
              "params": []
            }
          },
          "structs": {}
        })json"));

    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "debug_void_scratch_rax", /*entry_address=*/0x2000,
        /*original_name=*/mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto scratch = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    builder.create<helix::low::RegWriteOp>(
        loc, scratch.getResult(), "RAX", /*bit_width=*/64,
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createApplyDebugTypesPass());
    pm.addPass(helix::createRecoverCallingConventionPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    auto returnType =
        func->getAttrOfType<mlir::StringAttr>("inferred_return_type");
    ASSERT_TRUE(returnType);
    EXPECT_EQ(returnType.getValue(), "void");
    EXPECT_FALSE(func->hasAttr("has_return_value"));
    EXPECT_FALSE(module->hasAttr("helix.debug_types_seeded"))
        << "The early signature-only run must not consume the late type seed";
}

TEST(ApplyDebugTypesTest, ExactDebugSignatureConstrainsAapcsParameters) {
    mlir::MLIRContext ctx;
    auto module = buildAapcsSignatureFixture(ctx, /*variadic=*/false);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createApplyDebugTypesPass());
    pm.addPass(helix::createRecoverCallingConventionPass());
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    helix::low::FuncOp func;
    module->walk([&](helix::low::FuncOp candidate) { func = candidate; });
    ASSERT_TRUE(func);
    auto count =
        func->getAttrOfType<mlir::IntegerAttr>("helix.debug_param_count");
    ASSERT_TRUE(count);
    EXPECT_EQ(count.getInt(), 2);

    auto certified =
        func->getAttrOfType<mlir::DenseI32ArrayAttr>("reg_param_indices");
    ASSERT_TRUE(certified);
    ASSERT_EQ(certified.size(), 2u);
    EXPECT_EQ(certified.asArrayRef()[0], 1);
    EXPECT_EQ(certified.asArrayRef()[1], 2);

    bool sawParam1 = false;
    bool sawParam2 = false;
    bool sawParam4 = false;
    bool sawLocalX3 = false;
    bool sawLocalX0 = false;
    bool sawLocalX1 = false;
    std::set<uint32_t> x0LifetimeIds;
    std::set<uint32_t> x1LifetimeIds;
    func.walk([&](helix::high::VarDeclOp decl) {
        sawParam1 |= decl.getVarName() == "param_1";
        sawParam2 |= decl.getVarName() == "param_2";
        sawParam4 |= decl.getVarName() == "param_4";
        sawLocalX3 |= decl.getVarName() == "x3" &&
                      decl.getStorage() ==
                          helix::high::StorageKind::Register;
        sawLocalX0 |= decl.getVarName() == "x0_1" &&
                      decl.getStorage() ==
                          helix::high::StorageKind::Register;
        sawLocalX1 |= decl.getVarName() == "x1_1" &&
                      decl.getStorage() ==
                          helix::high::StorageKind::Register;
    });
    func.walk([&](helix::high::VarRefOp ref) {
        if (ref.getVarName() == "param_1" || ref.getVarName() == "x0_1")
            x0LifetimeIds.insert(ref.getVarId());
        if (ref.getVarName() == "param_2" || ref.getVarName() == "x1_1")
            x1LifetimeIds.insert(ref.getVarId());
    });
    EXPECT_TRUE(sawParam1);
    EXPECT_TRUE(sawParam2);
    EXPECT_FALSE(sawParam4);
    EXPECT_TRUE(sawLocalX3);
    EXPECT_TRUE(sawLocalX0);
    EXPECT_TRUE(sawLocalX1);
    EXPECT_EQ(x0LifetimeIds.size(), 2u);
    EXPECT_EQ(x1LifetimeIds.size(), 2u);
}

TEST(ApplyDebugTypesTest, VariadicDebugSignatureKeepsLiveAapcsRegisters) {
    mlir::MLIRContext ctx;
    auto module = buildAapcsSignatureFixture(ctx, /*variadic=*/true);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createApplyDebugTypesPass());
    pm.addPass(helix::createRecoverCallingConventionPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    helix::low::FuncOp func;
    module->walk([&](helix::low::FuncOp candidate) { func = candidate; });
    ASSERT_TRUE(func);
    EXPECT_TRUE(func->hasAttr("is_variadic"));
    EXPECT_FALSE(func->hasAttr("helix.debug_param_count"));
    EXPECT_FALSE(func->hasAttr("reg_param_indices"));

    bool sawParam1 = false;
    bool sawParam4 = false;
    func.walk([&](helix::high::VarDeclOp decl) {
        sawParam1 |= decl.getVarName() == "param_1";
        sawParam4 |= decl.getVarName() == "param_4";
    });
    EXPECT_TRUE(sawParam1);
    EXPECT_TRUE(sawParam4);
}

TEST(ApplyDebugTypesTest, NestedRegisterWriteDoesNotMutateDebugParameter) {
    mlir::MLIRContext ctx;
    auto module = buildNestedAapcsParameterWriteFixture(ctx);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createApplyDebugTypesPass());
    pm.addPass(helix::createRecoverCallingConventionPass());
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    uint32_t paramId = 0;
    uint32_t shadowId = 0;
    bool sawParam = false;
    bool sawShadow = false;
    module->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getVarName() == "param_1") {
            paramId = decl.getVarId();
            sawParam = true;
        }
        if (decl.getVarName().starts_with("x0_region_") &&
            decl.getStorage() == helix::high::StorageKind::Register) {
            shadowId = decl.getVarId();
            sawShadow = true;
        }
    });
    ASSERT_TRUE(sawParam);
    ASSERT_TRUE(sawShadow);

    unsigned paramAssignments = 0;
    unsigned shadowAssignments = 0;
    module->walk([&](helix::high::AssignOp assign) {
        auto target =
            assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
        if (!target)
            return;
        paramAssignments += target.getVarId() == paramId;
        shadowAssignments += target.getVarId() == shadowId;
    });

    EXPECT_EQ(paramAssignments, 0u);
    EXPECT_GE(shadowAssignments, 2u)
        << "shadow must be initialized from the parameter and receive the "
           "nested register write";
}
