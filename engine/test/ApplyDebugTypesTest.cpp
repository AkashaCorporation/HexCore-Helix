/// @file ApplyDebugTypesTest.cpp
/// @brief Direct contracts for nominal debug-type propagation.

#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/passes/Passes.h"
#include "helix/cast/CAstBuilder.h"
#include "helix/cast/CAstPrinter.h"
#include "helix/cast/CAstOptimizer.h"

#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"

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

TEST(ApplyDebugTypesTest, PointerSpellingsPreserveScalarAndNestedPointees) {
    for (auto [spelling, expected] : {
        std::pair{"uint64_t*", "uint64_t*"}, {"int32_t *", "int32_t*"},
        {"const char *", "int8_t*"}, {"double*", "double*"},
        {"uint8_t **", "uint8_t**"}, {"void**", "void**"},
        {"struct context*", "struct context*"},
        {"context*", "struct context*"}, {"context**", "struct context**"}}) {
        SCOPED_TRACE(spelling);
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(loc, "pointer_type", 0x7400, mlir::StringAttr{});
        func->setAttr("inferred_return_type", builder.getStringAttr(spelling));
        builder.setInsertionPointToStart(builder.createBlock(&func.getBody()));
        builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
        helix::cast::CAstBuilder astBuilder;
        auto declaration = astBuilder.buildFunction(func.getOperation());
        ASSERT_TRUE(declaration);
        ASSERT_TRUE(declaration->returnType);
        EXPECT_EQ(declaration->returnType->format(), expected);
        if (std::string_view(spelling).ends_with("**")) {
            ASSERT_TRUE(declaration->returnType->pointeeType);
            EXPECT_EQ(declaration->returnType->pointeeType->kind, helix::cast::TypeKind::Pointer);
        }
    }
}

TEST(ApplyDebugTypesTest, ZeroOffsetFieldRequiresExactKnownWidth) {
    for (unsigned width : {32u, 64u}) {
      for (bool knownSize : {false, true}) {
        SCOPED_TRACE("width=" + std::to_string(width) + " known=" + std::to_string(knownSize));
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        const std::string json = R"({"functions":{"zero_field":{"params":[{"index":0,"name":"ctx","type":"struct context*"}]}},"structs":{"context":{"fields":[{"name":"tag","type":"uint64_t","offset":0,"size":)" +
            std::to_string(knownSize ? 8 : 0) + "}]}}}";
        module->setAttr("helix.debug_type_info_json", builder.getStringAttr(json));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(loc, "zero_field", 0x7500, mlir::StringAttr{});
        builder.setInsertionPointToStart(builder.createBlock(&func.getBody()));
        auto decl = builder.create<helix::high::VarDeclOp>(loc, 1, "param_1",
            helix::high::StorageKind::Parameter, mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
        auto base = builder.create<helix::high::VarRefOp>(loc, builder.getI64Type(),
            decl.getVarId(), decl.getVarName(), mlir::IntegerAttr{});
        auto read = builder.create<helix::high::UnaryOp>(loc, builder.getIntegerType(width),
            helix::high::UnaryOpKind::Deref, base.getResult(), mlir::IntegerAttr{});
        auto ret = builder.create<helix::high::ReturnOp>(loc, read.getResult(), mlir::IntegerAttr{});
        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createApplyDebugTypesPass());
        pm.addPass(helix::createApplyDebugTypesPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));
        auto field = ret->getOperand(0).getDefiningOp<helix::high::FieldAccessOp>();
        EXPECT_EQ(static_cast<bool>(field), knownSize && width == 64);
        if (field) {
            EXPECT_EQ(field.getFieldName(), "tag");
            EXPECT_EQ(field.getFieldOffset(), 0u);
            EXPECT_EQ(field.getBase(), base.getResult());
        }
      }
    }
}

TEST(ApplyDebugTypesTest, IndexedNominalArrayRequiresMatchingScaleAndAccessWidth) {
    for (unsigned mode = 0; mode < 6; ++mode) {
        SCOPED_TRACE(mode);
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        module->setAttr("helix.debug_type_info_json", builder.getStringAttr(R"({
          "functions":{"indexed":{"returnType":"uint64_t","params":[
            {"index":0,"name":"ctx","type":"struct context*"},
            {"index":1,"name":"index","type":"uint64_t"}]}},
          "structs":{"context":{"fields":[
            {"name":"slots","type":"uint64_t[4]","offset":24,"size":32}]}}})"));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(loc, "indexed", 0x7600, mlir::StringAttr{});
        builder.setInsertionPointToStart(builder.createBlock(&func.getBody()));
        auto makeParam = [&](unsigned id, const char* name) -> mlir::Value {
            auto decl = builder.create<helix::high::VarDeclOp>(loc, id, name,
                helix::high::StorageKind::Parameter, mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
            // Legalized functions can retain another declaration ID for the
            // same ABI parameter while body references still use that ID.
            decl = builder.create<helix::high::VarDeclOp>(loc, id + 10, name,
                helix::high::StorageKind::Parameter, mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});
            return builder.create<helix::high::VarRefOp>(loc, builder.getI64Type(),
                decl.getVarId(), decl.getVarName(), mlir::IntegerAttr{});
        };
        auto base = makeParam(1, "param_1");
        auto index = makeParam(2, "param_2");
        auto constant = [&](int64_t n) -> mlir::Value {
            return builder.create<mlir::LLVM::ConstantOp>(loc, builder.getI64Type(), builder.getI64IntegerAttr(n));
        };
        mlir::Value scaled = index;
        if (mode == 0 || mode == 1 || mode == 5)
            scaled = builder.create<mlir::LLVM::ShlOp>(loc, index, constant(mode == 1 ? 2 : 3));
        if (mode == 2 || mode == 3)
            scaled = builder.create<mlir::LLVM::MulOp>(loc, index, constant(mode == 2 ? 8 : 4));
        auto inner = builder.create<mlir::LLVM::AddOp>(loc, base, scaled);
        auto outer = builder.create<mlir::LLVM::AddOp>(loc, inner.getResult(), constant(24));
        auto read = builder.create<helix::high::UnaryOp>(loc, builder.getIntegerType(mode == 5 ? 32 : 64),
            helix::high::UnaryOpKind::Deref, outer.getResult(), mlir::IntegerAttr{});
        builder.create<helix::high::ReturnOp>(loc, read.getResult(), mlir::IntegerAttr{});
        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createApplyDebugTypesPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));
        EXPECT_EQ(outer->hasAttr("helix.debug_indexed_element_stride"), mode == 0 || mode == 2 || mode == 5);
        helix::cast::CAstBuilder astBuilder;
        auto declaration = astBuilder.buildFunction(func.getOperation());
        ASSERT_TRUE(declaration);
        helix::cast::CAstPrinter printer;
        const std::string source = printer.print(*declaration);
        EXPECT_EQ(source.find("slots[index]") != std::string::npos, mode == 0 || mode == 2) << source;
        if (mode != 0 && mode != 2) {
            helix::cast::CAstOptimizer optimizer;
            optimizer.optimize(*declaration);
            const auto fallback = printer.print(*declaration);
            EXPECT_NE(fallback.find("(uint64_t)ctx"), std::string::npos) << fallback;
            EXPECT_NE(fallback.find(mode == 5 ? "*(int32_t*)" : "*(int64_t*)"), std::string::npos) << fallback;
        }
    }
}

TEST(ApplyDebugTypesTest, OpaqueCallReadsRespectAbiAndPartialRegisterWrites) {
    for (unsigned mode = 0; mode < 10; ++mode) {
        SCOPED_TRACE(mode);
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        module->setAttr("llvm.target_triple", builder.getStringAttr(mode == 1 ? "x86_64-pc-windows-msvc" : "x86_64-pc-linux-gnu"));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(loc, "opaque_reads", 0x8100, mlir::StringAttr{});
        builder.setInsertionPointToStart(builder.createBlock(&func.getBody()));
        auto target = builder.create<mlir::LLVM::ConstantOp>(loc, builder.getI64Type(), builder.getI64IntegerAttr(0x9000));
        auto call = builder.create<helix::low::CallOp>(loc, mlir::TypeRange{builder.getI64Type()}, target.getResult(),
            mlir::ValueRange{}, builder.getStringAttr("opaque_callback"), mlir::IntegerAttr{});
        if (mode == 9) call->setAttr("helix.machine_intrinsic", builder.getUnitAttr());
        if (mode >= 3 && mode <= 8) {
            unsigned width = mode == 3 ? 64 : mode == 4 ? 32 : 8;
            const char* reg = mode == 3 ? "RDI" : mode == 4 ? "EDI" : mode >= 7 ? "AH" : "DIL";
            auto type = builder.getIntegerType(width);
            auto value = builder.create<mlir::LLVM::ConstantOp>(loc, type, builder.getIntegerAttr(type, 7));
            builder.create<helix::low::RegWriteOp>(loc, value.getResult(), reg, width, mlir::IntegerAttr{});
        }
        const char* reg = mode == 2 ? "RBX" : mode == 6 ? "DIL" : mode == 7 ? "AL" : mode == 8 ? "AH" : "RDI";
        unsigned width = mode >= 6 && mode <= 8 ? 8 : 64;
        auto read = builder.create<helix::low::RegReadOp>(loc, builder.getIntegerType(width), reg, width, mlir::IntegerAttr{});
        auto ret = builder.create<helix::high::ReturnOp>(loc, read.getResult(), mlir::IntegerAttr{});
        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createRecoverCallingConventionPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));
        const bool unknown = mode == 0 || mode == 5 || mode == 7;
        auto opaque = ret.getValue().getDefiningOp<helix::low::CallOp>();
        EXPECT_EQ(static_cast<bool>(opaque), unknown);
        EXPECT_EQ(func->hasAttr("helix.opaque_post_call_read_count"), unknown);
        if (opaque) EXPECT_TRUE(opaque->hasAttr("helix.machine_intrinsic"));
    }
}

TEST(ApplyDebugTypesTest, OpaqueCallStateJoinsPredecessors) {
  for (bool backedge : {false, true}) {
    for (bool overwritten : {false, true}) {
        SCOPED_TRACE(::testing::Message() << "backedge=" << backedge << " overwritten=" << overwritten);
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();
        ctx.getOrLoadDialect<mlir::cf::ControlFlowDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        module->setAttr("llvm.target_triple", builder.getStringAttr("x86_64-pc-linux-gnu"));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(loc, "joined_opaque", 0x8200, mlir::StringAttr{});
        auto* entry = builder.createBlock(&func.getBody());
        auto* left = builder.createBlock(&func.getBody());
        auto* right = builder.createBlock(&func.getBody());
        auto* join = builder.createBlock(&func.getBody());
        builder.setInsertionPointToEnd(entry);
        auto cond = builder.create<helix::low::RegReadOp>(loc, builder.getI1Type(), "ZF", 1, mlir::IntegerAttr{});
        if (backedge) builder.create<mlir::cf::BranchOp>(loc, join);
        else builder.create<mlir::cf::CondBranchOp>(loc, cond.getResult(), left, mlir::ValueRange{}, right, mlir::ValueRange{});
        builder.setInsertionPointToEnd(left);
        auto value = builder.create<mlir::LLVM::ConstantOp>(loc, builder.getI64Type(), builder.getI64IntegerAttr(7));
        builder.create<helix::low::CallOp>(loc, mlir::TypeRange{builder.getI64Type()}, value.getResult(),
            mlir::ValueRange{}, builder.getStringAttr("opaque_callback"), mlir::IntegerAttr{});
        if (overwritten) builder.create<helix::low::RegWriteOp>(loc, value.getResult(), "RDI", 64, mlir::IntegerAttr{});
        builder.create<mlir::cf::BranchOp>(loc, join);
        builder.setInsertionPointToEnd(right);
        if (backedge) builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
        else builder.create<mlir::cf::BranchOp>(loc, join);
        builder.setInsertionPointToEnd(join);
        auto read = builder.create<helix::low::RegReadOp>(loc, builder.getI64Type(), "RDI", 64, mlir::IntegerAttr{});
        mlir::Operation* consumer;
        if (backedge) {
            consumer = builder.create<helix::low::RegWriteOp>(loc, read.getResult(), "RAX", 64, mlir::IntegerAttr{});
            builder.create<mlir::cf::CondBranchOp>(loc, cond.getResult(), left, mlir::ValueRange{}, right, mlir::ValueRange{});
        } else {
            consumer = builder.create<helix::high::ReturnOp>(loc, read.getResult(), mlir::IntegerAttr{});
        }
        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createRecoverCallingConventionPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));
        EXPECT_EQ(static_cast<bool>(consumer->getOperand(0).getDefiningOp<helix::low::CallOp>()), !overwritten);
    }
  }
}

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

TEST(ApplyDebugTypesTest, SyntheticNominalTypeFlowsBackOnlyThroughSingleDefParameterCopy) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "synthetic_parameter_copy", 0x2100, mlir::StringAttr{});
    builder.setInsertionPointToStart(builder.createBlock(&func.getBody()));

    auto makeDecl = [&](uint32_t id, llvm::StringRef name,
                        helix::high::StorageKind storage) {
        return builder.create<helix::high::VarDeclOp>(
            loc, id, name, storage, mlir::IntegerAttr{}, mlir::Value{},
            mlir::IntegerAttr{});
    };
    auto parameter = makeDecl(1, "param_1",
                              helix::high::StorageKind::Parameter);
    auto alias = makeDecl(2, "typed_alias",
                          helix::high::StorageKind::Register);
    alias->setAttr("helix.struct_name",
                   builder.getStringAttr("auto_struct_42"));
    alias->setAttr("inferred_type",
                   builder.getStringAttr("auto_struct_42*"));
    auto rejectedParameter = makeDecl(
        3, "param_2", helix::high::StorageKind::Parameter);
    auto reused = makeDecl(4, "reused_alias",
                           helix::high::StorageKind::Register);
    reused->setAttr("helix.struct_name",
                    builder.getStringAttr("auto_struct_43"));
    reused->setAttr("inferred_type",
                    builder.getStringAttr("auto_struct_43*"));
    auto voidParameter = makeDecl(
        5, "param_4", helix::high::StorageKind::Parameter);
    auto voidAlias = makeDecl(6, "void_alias",
                              helix::high::StorageKind::Register);
    voidAlias->setAttr("inferred_type", builder.getStringAttr("void*"));

    auto ref = [&](helix::high::VarDeclOp decl) {
        return builder.create<helix::high::VarRefOp>(
            loc, builder.getI64Type(), decl.getVarId(), decl.getVarName(),
            mlir::IntegerAttr{});
    };
    builder.create<helix::high::AssignOp>(
        loc, ref(alias).getResult(), ref(parameter).getResult(),
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, ref(reused).getResult(), ref(rejectedParameter).getResult(),
        mlir::IntegerAttr{});
    auto zero = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    builder.create<helix::high::AssignOp>(
        loc, ref(reused).getResult(), zero.getResult(), mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, ref(voidAlias).getResult(), ref(voidParameter).getResult(),
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createPropagateTypesHighPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    auto inferred = [](helix::high::VarDeclOp decl) {
        auto type = decl->getAttrOfType<mlir::StringAttr>("inferred_type");
        return type ? type.getValue().str() : std::string{};
    };
    EXPECT_EQ(inferred(parameter), "auto_struct_42*");
    EXPECT_NE(inferred(rejectedParameter), "auto_struct_43*");
    EXPECT_EQ(inferred(voidParameter), "void*");
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

TEST(ApplyDebugTypesTest, ExternalSignatureConstrainsLowCallArguments) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr("llvm.target_triple",
                    builder.getStringAttr("x86_64-pc-windows-msvc"));
    module->setAttr(
        "helix.debug_type_info_json",
        builder.getStringAttr(R"json({
          "functions": {
            "OpenProcess": {
              "returnType": "HANDLE",
              "params": [
                {"index": 0, "name": "dwDesiredAccess", "type": "DWORD"},
                {"index": 1, "name": "bInheritHandle", "type": "BOOL"},
                {"index": 2, "name": "dwProcessId", "type": "DWORD"}
              ]
            }
          },
          "structs": {}
        })json"));

    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "caller", /*entry_address=*/0x1000,
        /*original_name=*/mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto i64 = builder.getI64Type();
    for (auto reg : {"RCX", "RDX", "R8", "R9"}) {
        auto value = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
        builder.create<helix::low::RegWriteOp>(
            loc, value.getResult(), reg, /*bit_width=*/64,
            mlir::IntegerAttr{});
    }
    auto target = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    auto call = builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{i64}, target.getResult(), mlir::ValueRange{},
        builder.getStringAttr("OpenProcess"), mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createApplyDebugTypesPass());
    pm.addPass(helix::createRecoverCallingConventionPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    auto exactCount = call->getAttrOfType<mlir::IntegerAttr>(
        "helix.debug_param_count");
    ASSERT_TRUE(exactCount);
    EXPECT_EQ(exactCount.getInt(), 3);
    EXPECT_EQ(call.getArgs().size(), 3u);
    auto returnType = call->getAttrOfType<mlir::StringAttr>(
        "inferred_return_type");
    ASSERT_TRUE(returnType);
    EXPECT_EQ(returnType.getValue(), "HANDLE");
}

TEST(ApplyDebugTypesTest, ExactArityOverridesSyntheticCalleeName) {
    for (int64_t arity : {0, 3}) {
        SCOPED_TRACE("arity=" + std::to_string(arity));
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        module->setAttr("llvm.target_triple",
                        builder.getStringAttr("x86_64-pc-windows-msvc"));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(
            loc, "known_arity_caller", 0x7000, mlir::StringAttr{});
        auto* block = builder.createBlock(&func.getBody());
        builder.setInsertionPointToStart(block);
        auto value = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
        for (auto reg : {"RCX", "RDX", "R8", "R9"})
            builder.create<helix::low::RegWriteOp>(
                loc, value.getResult(), reg, 64, mlir::IntegerAttr{});
        auto call = builder.create<helix::low::CallOp>(
            loc, mlir::TypeRange{builder.getI64Type()}, value.getResult(),
            mlir::ValueRange{}, builder.getStringAttr("sub_8000"),
            mlir::IntegerAttr{});
        call->setAttr("helix.debug_param_count", builder.getI32IntegerAttr(arity));
        builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createRecoverCallingConventionPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));
        EXPECT_EQ(call.getArgs().size(), static_cast<size_t>(arity));
    }
}

TEST(ApplyDebugTypesTest, SysVOutgoingPushArgumentsPreserveOrderAndRejectWrites) {
    for (unsigned arity = 7; arity <= 10; ++arity) {
      for (bool barrier : {false, true}) {
        SCOPED_TRACE("arity=" + std::to_string(arity) + " barrier=" + std::to_string(barrier));
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        module->setAttr("llvm.target_triple", builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(loc, "push_caller", 0x7100, mlir::StringAttr{});
        auto* block = builder.createBlock(&func.getBody());
        builder.setInsertionPointToStart(block);
        llvm::SmallVector<mlir::Value, 10> values;
        for (unsigned i = 1; i <= arity; ++i)
            values.push_back(builder.create<mlir::arith::ConstantIntOp>(loc, i, 64));
        for (unsigned i = arity; i > 6; --i)
            builder.create<helix::low::PushOp>(loc, values[i-1], mlir::IntegerAttr{});
        if (barrier)
            builder.create<helix::low::MemWriteOp>(loc, values[0], values[1], 64, mlir::IntegerAttr{});
        auto call = builder.create<helix::low::CallOp>(
            loc, mlir::TypeRange{builder.getI64Type()}, values[0],
            mlir::ValueRange(values).take_front(6), builder.getStringAttr("sub_8000"), mlir::IntegerAttr{});
        call->setAttr("helix.debug_param_count", builder.getI32IntegerAttr(arity));
        call->setAttr("helix.debug_integer_abi", builder.getUnitAttr());
        builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createRecoverCallingConventionPass());
        pm.addPass(helix::createRecoverVariablesPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));
        ASSERT_EQ(call.getArgs().size(), barrier ? 6u : arity);
        unsigned captured = 0;
        for (unsigned i = 6; !barrier && i < arity; ++i) {
            auto ref = call.getArgs()[i].getDefiningOp<helix::high::VarRefOp>();
            ASSERT_TRUE(ref);
            bool matched = false;
            func.walk([&](helix::high::AssignOp assignment) {
                auto target = assignment.getTarget().getDefiningOp<helix::high::VarRefOp>();
                if (target && target.getVarId() == ref.getVarId())
                    matched |= assignment.getValue() == values[i];
            });
            EXPECT_TRUE(matched);
        }
        func.walk([&](helix::low::PushOp push) {
            captured += push->hasAttr("helix.recovered_stack_argument");
        });
        EXPECT_EQ(captured, barrier ? 0u : arity - 6);
        unsigned snapshots = 0;
        func.walk([&](helix::high::VarDeclOp decl) {
            snapshots += decl->hasAttr("helix.value_snapshot");
        });
        EXPECT_EQ(snapshots, barrier ? 0u : arity - 6);
      }
    }
}

TEST(ApplyDebugTypesTest, FirstSysVCallPreservesForwardedLiveInPrefix) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr("llvm.target_triple",
                    builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "forwarding_wrapper", /*entry_address=*/0x3000,
        /*original_name=*/mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto zero = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    builder.create<helix::low::RegWriteOp>(
        loc, zero.getResult(), "RDX", /*bit_width=*/64,
        mlir::IntegerAttr{});
    auto target = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    auto call = builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, target.getResult(),
        mlir::ValueRange{}, builder.getStringAttr("forwarded_callee"),
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverCallingConventionPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    ASSERT_EQ(call.getArgs().size(), 3u);
    auto first = call.getArgs()[0].getDefiningOp<helix::low::RegReadOp>();
    auto second = call.getArgs()[1].getDefiningOp<helix::low::RegReadOp>();
    ASSERT_TRUE(first);
    ASSERT_TRUE(second);
    EXPECT_EQ(first.getRegName(), "RDI");
    EXPECT_EQ(second.getRegName(), "RSI");
    EXPECT_EQ(call.getArgs()[2], zero.getResult());
    auto forwarded = call->getAttrOfType<mlir::IntegerAttr>(
        "helix.forwarded_livein_arg_count");
    ASSERT_TRUE(forwarded);
    EXPECT_EQ(forwarded.getValue().getZExtValue(), 2u);

    auto certified =
        func->getAttrOfType<mlir::DenseI32ArrayAttr>("reg_param_indices");
    ASSERT_TRUE(certified);
    ASSERT_EQ(certified.size(), 2u);
    EXPECT_EQ(certified.asArrayRef()[0], 1);
    EXPECT_EQ(certified.asArrayRef()[1], 2);
}

TEST(ApplyDebugTypesTest, ForwardedPrefixDoesNotCrossCallBarrier) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr("llvm.target_triple",
                    builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "post_call_register_noise", /*entry_address=*/0x4000,
        /*original_name=*/mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto target = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, target.getResult(),
        mlir::ValueRange{}, builder.getStringAttr("first_callee"),
        mlir::IntegerAttr{});
    auto zero = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    builder.create<helix::low::RegWriteOp>(
        loc, zero.getResult(), "RDX", /*bit_width=*/64,
        mlir::IntegerAttr{});
    auto secondCall = builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, target.getResult(),
        mlir::ValueRange{}, builder.getStringAttr("second_callee"),
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverCallingConventionPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    EXPECT_TRUE(secondCall.getArgs().empty());
    EXPECT_FALSE(secondCall->hasAttr("helix.forwarded_livein_arg_count"));
}

TEST(ApplyDebugTypesTest, FentryPreservesSourceArgumentsButRemainsUnqualified) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr("llvm.target_triple",
                    builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "instrumented_source", 0x4100, mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto target = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    auto fentry = builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, target.getResult(),
        mlir::ValueRange{}, builder.getStringAttr("__fentry__"),
        mlir::IntegerAttr{});
    auto input = builder.create<helix::low::RegReadOp>(
        loc, builder.getI64Type(), "RDI", 64, mlir::IntegerAttr{});
    auto ret = builder.create<helix::high::ReturnOp>(
        loc, input.getResult(), mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverCallingConventionPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    EXPECT_TRUE(fentry->hasAttr("helix.unqualified_instrumentation"));
    auto count = func->getAttrOfType<mlir::IntegerAttr>(
        "helix.unqualified_instrumentation_call_count");
    ASSERT_TRUE(count);
    EXPECT_EQ(count.getInt(), 1);
    EXPECT_EQ(ret.getValue().getDefiningOp<helix::low::RegReadOp>(), input);
    EXPECT_FALSE(func->hasAttr("helix.opaque_post_call_read_count"));
}

TEST(ApplyDebugTypesTest, SegmentReadMachineIntrinsicDoesNotClobberArguments) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr("llvm.target_triple",
                    builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "segment_intrinsic_source", 0x4200, mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto target = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    auto offset = builder.create<mlir::arith::ConstantIntOp>(loc, 40, 64);
    auto readgs = builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, target.getResult(),
        mlir::ValueRange{offset.getResult()},
        builder.getStringAttr("__readgsqword"), mlir::IntegerAttr{});
    readgs->setAttr("helix.machine_intrinsic", builder.getUnitAttr());
    auto input = builder.create<helix::low::RegReadOp>(
        loc, builder.getI64Type(), "RDI", 64, mlir::IntegerAttr{});
    auto ret = builder.create<helix::high::ReturnOp>(
        loc, input.getResult(), mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverCallingConventionPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));
    EXPECT_EQ(ret.getValue().getDefiningOp<helix::low::RegReadOp>(), input);
    EXPECT_FALSE(func->hasAttr("helix.opaque_post_call_read_count"));
}

TEST(ApplyDebugTypesTest, MemoryDerivedCallArgumentUsesSavedRegisterValue) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr("llvm.target_triple",
                    builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "saved_memory_argument", /*entry_address=*/0x5000,
        /*original_name=*/mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto address = builder.create<mlir::arith::ConstantIntOp>(
        loc, 0x7000, 64);
    auto loaded = builder.create<helix::low::MemReadOp>(
        loc, builder.getI64Type(), address.getResult(), /*bit_width=*/64,
        mlir::IntegerAttr{});
    builder.create<helix::low::RegWriteOp>(
        loc, loaded.getResult(), "RDI", /*bit_width=*/64,
        mlir::IntegerAttr{});
    auto zero = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    builder.create<helix::low::MemWriteOp>(
        loc, address.getResult(), zero.getResult(), /*bit_width=*/64,
        mlir::IntegerAttr{});
    auto target = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    auto call = builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, target.getResult(),
        mlir::ValueRange{loaded.getResult()},
        builder.getStringAttr("consume_saved_value"), mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverCallingConventionPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    ASSERT_EQ(call.getArgs().size(), 1u);
    auto read = call.getArgs().front().getDefiningOp<helix::low::RegReadOp>();
    ASSERT_TRUE(read);
    EXPECT_EQ(read.getRegName(), "RDI");
    EXPECT_TRUE(call->hasAttr("helix.materialized_arg_single_evaluation"));
}

TEST(ApplyDebugTypesTest, SavedCallArgumentDoesNotReadClobberedRegister) {
    for (bool crossBlock : {false, true}) {
    SCOPED_TRACE(crossBlock ? "predecessor barrier" : "same-block barrier");
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr("llvm.target_triple",
                    builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "saved_across_call", 0x5100, mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto address = builder.create<mlir::arith::ConstantIntOp>(loc, 0x7000, 64);
    auto saved = builder.create<helix::low::MemReadOp>(
        loc, builder.getI64Type(), address.getResult(), 64, mlir::IntegerAttr{});
    builder.create<helix::low::RegWriteOp>(
        loc, saved.getResult(), "RDI", 64, mlir::IntegerAttr{});
    auto target = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, target.getResult(),
        mlir::ValueRange{}, builder.getStringAttr("clobber_registers"),
        mlir::IntegerAttr{});
    if (crossBlock) {
        auto* consumerBlock = builder.createBlock(&func.getBody());
        builder.setInsertionPointToEnd(block);
        builder.create<helix::low::JmpOp>(
            loc, mlir::ValueRange{}, mlir::IntegerAttr{}, mlir::IntegerAttr{},
            consumerBlock);
        builder.setInsertionPointToStart(consumerBlock);
    }
    auto consumer = builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, target.getResult(),
        mlir::ValueRange{saved.getResult()}, builder.getStringAttr("consume_saved"),
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverCallingConventionPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));
    ASSERT_EQ(consumer.getArgs().size(), 1u);
    EXPECT_EQ(consumer.getArgs().front(), saved.getResult());
    EXPECT_FALSE(consumer->hasAttr("helix.materialized_arg_single_evaluation"));
    }
}

TEST(ApplyDebugTypesTest, ComputedCallArgumentUsesMaterializedRegisterValue) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr("llvm.target_triple",
                    builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "computed_argument", /*entry_address=*/0x6000,
        /*original_name=*/mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto base = builder.create<helix::low::RegReadOp>(
        loc, builder.getI64Type(), "RAX", /*bit_width=*/64,
        mlir::IntegerAttr{});
    auto offset = builder.create<mlir::LLVM::ConstantOp>(
        loc, builder.getI64Type(), builder.getI64IntegerAttr(0x80));
    auto address = builder.create<mlir::LLVM::AddOp>(
        loc, base.getResult(), offset.getResult());
    builder.create<helix::low::RegWriteOp>(
        loc, address.getResult(), "RDI", /*bit_width=*/64,
        mlir::IntegerAttr{});
    auto target = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    auto call = builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{builder.getI64Type()}, target.getResult(),
        mlir::ValueRange{address.getResult()},
        builder.getStringAttr("consume_address"), mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverCallingConventionPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    ASSERT_EQ(call.getArgs().size(), 1u);
    auto read = call.getArgs().front().getDefiningOp<helix::low::RegReadOp>();
    ASSERT_TRUE(read);
    EXPECT_EQ(read.getRegName(), "RDI");
    EXPECT_TRUE(call->hasAttr("helix.materialized_arg_single_evaluation"));
}

TEST(ApplyDebugTypesTest, VariadicLowCallIsNotClampedToFixedParameters) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    module->setAttr("llvm.target_triple",
                    builder.getStringAttr("x86_64-pc-windows-msvc"));
    module->setAttr(
        "helix.debug_type_info_json",
        builder.getStringAttr(R"json({
          "functions": {
            "printf": {
              "returnType": "int32_t",
              "variadic": true,
              "params": [
                {"index": 0, "name": "format", "type": "const char *"}
              ]
            }
          },
          "structs": {}
        })json"));

    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "caller", /*entry_address=*/0x2000,
        /*original_name=*/mlir::StringAttr{});
    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto i64 = builder.getI64Type();
    llvm::SmallVector<mlir::Value, 3> args;
    for (int64_t value : {1, 2, 3})
        args.push_back(builder.create<mlir::arith::ConstantIntOp>(
            loc, value, 64).getResult());
    auto target = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
    auto call = builder.create<helix::low::CallOp>(
        loc, mlir::TypeRange{i64}, target.getResult(), args,
        builder.getStringAttr("printf"), mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createApplyDebugTypesPass());
    pm.addPass(helix::createRecoverCallingConventionPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    EXPECT_TRUE(call->hasAttr("is_variadic"));
    EXPECT_FALSE(call->hasAttr("helix.debug_param_count"));
    EXPECT_EQ(call.getArgs().size(), 3u);
}

TEST(ApplyDebugTypesTest, MachineIntrinsicOperandsAreNotAbiArguments) {
    for (bool explicitOperands : {false, true}) {
        SCOPED_TRACE(explicitOperands ? "explicit operands" : "no operands");
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        module->setAttr("llvm.target_triple",
                        builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(
            loc, "intrinsic_operand_contract", 0x6100, mlir::StringAttr{});
        auto* block = builder.createBlock(&func.getBody());
        builder.setInsertionPointToStart(block);
        auto address = builder.create<mlir::arith::ConstantIntOp>(loc, 0x7000, 64);
        auto saved = builder.create<helix::low::MemReadOp>(
            loc, builder.getI64Type(), address.getResult(), 64,
            mlir::IntegerAttr{});
        builder.create<helix::low::RegWriteOp>(
            loc, saved.getResult(), "RDI", 64, mlir::IntegerAttr{});
        builder.create<helix::low::RegWriteOp>(
            loc, address.getResult(), "RSI", 64, mlir::IntegerAttr{});
        llvm::SmallVector<mlir::Value, 1> operands;
        if (explicitOperands) operands.push_back(saved.getResult());
        auto intrinsic = builder.create<helix::low::CallOp>(
            loc, mlir::TypeRange{builder.getI64Type()}, address.getResult(),
            operands, builder.getStringAttr("sub_7000"), mlir::IntegerAttr{});
        intrinsic->setAttr("helix.machine_intrinsic", builder.getUnitAttr());
        builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createRecoverCallingConventionPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));
        ASSERT_EQ(intrinsic.getArgs().size(), operands.size());
        if (explicitOperands)
            EXPECT_EQ(intrinsic.getArgs().front(), saved.getResult());
        EXPECT_FALSE(intrinsic->hasAttr("helix.forwarded_livein_arg_count"));
        EXPECT_FALSE(intrinsic->hasAttr("helix.materialized_arg_single_evaluation"));
    }
}

TEST(ApplyDebugTypesTest, Win64OutgoingSlotRequiresStableRsp) {
    for (bool adjusted : {false, true}) {
        SCOPED_TRACE(adjusted ? "RSP changed after store" : "stable outgoing slot");
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        module->setAttr("llvm.target_triple", builder.getStringAttr("x86_64-pc-windows-msvc"));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(loc, "outgoing_slot", 0x7200, mlir::StringAttr{});
        auto* block = builder.createBlock(&func.getBody());
        builder.setInsertionPointToStart(block);
        auto stack = builder.create<helix::low::RegReadOp>(loc, builder.getI64Type(), "RSP", 64, mlir::IntegerAttr{});
        auto offset = builder.create<mlir::LLVM::ConstantOp>(loc, builder.getI64Type(), builder.getI64IntegerAttr(32));
        auto address = builder.create<mlir::LLVM::AddOp>(loc, stack.getResult(), offset.getResult());
        auto five = builder.create<mlir::LLVM::ConstantOp>(loc, builder.getI64Type(), builder.getI64IntegerAttr(5));
        builder.create<helix::low::MemWriteOp>(loc, address.getResult(), five.getResult(), 64, mlir::IntegerAttr{});
        if (adjusted)
            builder.create<helix::low::RegWriteOp>(loc, address.getResult(), "RSP", 64, mlir::IntegerAttr{});
        // Fresh Remill may re-read RSP between outgoing stores and the call.
        builder.create<helix::low::RegReadOp>(loc, builder.getI64Type(), "RSP", 64, mlir::IntegerAttr{});
        llvm::SmallVector<mlir::Value, 4> regs(4, five.getResult());
        auto call = builder.create<helix::low::CallOp>(loc, mlir::TypeRange{builder.getI64Type()}, five.getResult(), regs,
            builder.getStringAttr("sub_8000"), mlir::IntegerAttr{});
        call->setAttr("helix.debug_param_count", builder.getI32IntegerAttr(5));
        call->setAttr("helix.debug_integer_abi", builder.getUnitAttr());
        builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createRecoverStackLayoutPass());
        pm.addPass(helix::createRecoverCallingConventionPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));
        ASSERT_EQ(call.getArgs().size(), adjusted ? 4u : 5u);
        if (!adjusted) {
            auto captured = call.getArgs()[4].getDefiningOp<helix::high::VarRefOp>();
            ASSERT_TRUE(captured);
            bool found = false;
            func.walk([&](helix::high::AssignOp assign) {
                auto target = assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
                found |= target && target.getVarId() == captured.getVarId() && assign.getValue() == five.getResult();
            });
            EXPECT_TRUE(found);
        }
    }
}

TEST(ApplyDebugTypesTest, Win64OutgoingStoresRespectLatestValueAndBarriers) {
    for (const std::string mode : {"overwrite", "narrow", "overlap", "call",
                                   "unknown-store", "missing-slot", "no-signature",
                                   "narrow-then-full"}) {
        SCOPED_TRACE(mode);
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        module->setAttr("llvm.target_triple", builder.getStringAttr("x86_64-pc-windows-msvc"));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(loc, "outgoing_barriers", 0x7300, mlir::StringAttr{});
        builder.setInsertionPointToStart(builder.createBlock(&func.getBody()));
        auto constant = [&](int64_t value, unsigned width = 64) -> mlir::Value {
            auto type = builder.getIntegerType(width);
            return builder.create<mlir::LLVM::ConstantOp>(loc, type, builder.getIntegerAttr(type, value));
        };
        auto stack = builder.create<helix::low::RegReadOp>(loc, builder.getI64Type(), "RSP", 64, mlir::IntegerAttr{});
        auto store = [&](int64_t offset, mlir::Value value, unsigned width) {
            auto address = builder.create<mlir::LLVM::AddOp>(loc, stack.getResult(), constant(offset));
            builder.create<helix::low::MemWriteOp>(loc, address.getResult(), value, width, mlir::IntegerAttr{});
        };
        auto five = constant(5);
        auto nine = constant(9);
        store(32, five, 64);
        if (mode == "narrow" || mode == "narrow-then-full") store(32, constant(7, 32), 32);
        if (mode == "overlap") store(36, constant(7, 32), 32);
        if (mode == "overwrite" || mode == "narrow-then-full") store(32, nine, 64);
        if (mode == "call") {
            auto barrier = builder.create<helix::low::CallOp>(loc, mlir::TypeRange{builder.getI64Type()},
                constant(0x9000), mlir::ValueRange{}, builder.getStringAttr("sub_9000"), mlir::IntegerAttr{});
            barrier->setAttr("helix.debug_param_count", builder.getI32IntegerAttr(0));
        }
        if (mode == "unknown-store") {
            auto pointer = builder.create<helix::low::RegReadOp>(loc, builder.getI64Type(), "RAX", 64, mlir::IntegerAttr{});
            builder.create<helix::low::MemWriteOp>(loc, pointer.getResult(), nine, 64, mlir::IntegerAttr{});
        }
        llvm::SmallVector<mlir::Value, 4> regs(4, five);
        auto call = builder.create<helix::low::CallOp>(loc, mlir::TypeRange{builder.getI64Type()},
            constant(0x8000), regs, builder.getStringAttr("sub_8000"), mlir::IntegerAttr{});
        if (mode != "no-signature") {
            call->setAttr("helix.debug_param_count", builder.getI32IntegerAttr(mode == "missing-slot" ? 6 : 5));
            call->setAttr("helix.debug_integer_abi", builder.getUnitAttr());
        }
        builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createRecoverStackLayoutPass());
        pm.addPass(helix::createRecoverCallingConventionPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));
        bool accepted = mode == "overwrite" || mode == "narrow-then-full";
        ASSERT_EQ(call.getArgs().size(), accepted ? 5u : 4u);
        const bool knownIncomplete = !accepted && mode != "no-signature";
        EXPECT_EQ(call->hasAttr("helix.abi.missing_argument_count"), knownIncomplete);
        EXPECT_EQ(func->hasAttr("helix.abi.incomplete_call_count"), knownIncomplete);
        if (knownIncomplete) {
            helix::cast::CAstBuilder astBuilder;
            auto declaration = astBuilder.buildFunction(func.getOperation());
            ASSERT_TRUE(declaration);
            EXPECT_EQ(declaration->incompleteAbiCalls, 1u);
            helix::cast::CAstOptimizer optimizer;
            optimizer.optimize(*declaration);
            EXPECT_LE(declaration->confidenceScore, 50.0);
            helix::cast::CAstPrinter printer;
            EXPECT_NE(printer.print(*declaration).find("incomplete ABI arguments"), std::string::npos);
        }
        if (accepted) {
            auto captured = call.getArgs()[4].getDefiningOp<helix::high::VarRefOp>();
            ASSERT_TRUE(captured);
            unsigned captures = 0;
            bool protectedSnapshot = false;
            func.walk([&](helix::high::AssignOp assign) {
                auto target = assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
                if (target && target.getVarId() == captured.getVarId()) {
                    ++captures;
                    EXPECT_EQ(assign.getValue(), nine);
                }
            });
            func.walk([&](helix::high::VarDeclOp decl) {
                if (decl.getVarId() == captured.getVarId())
                    protectedSnapshot = decl->hasAttr("helix.value_snapshot");
            });
            EXPECT_EQ(captures, 1u);
            EXPECT_TRUE(protectedSnapshot);
        }
    }
}

TEST(ApplyDebugTypesTest, SysVStackArgumentsRequireUnadjustedEntryStack) {
    for (bool adjusted : {false, true}) {
        SCOPED_TRACE(adjusted ? "adjusted stack" : "entry stack");
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        module->setAttr("llvm.target_triple",
                        builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(
            loc, "sysv_stack", 0x6200, mlir::StringAttr{});
        auto* block = builder.createBlock(&func.getBody());
        builder.setInsertionPointToStart(block);
        auto stack = builder.create<helix::low::RegReadOp>(
            loc, builder.getI64Type(), "RSP", 64, mlir::IntegerAttr{});
        auto offset = builder.create<mlir::LLVM::ConstantOp>(
            loc, builder.getI64Type(), builder.getI64IntegerAttr(8));
        if (adjusted) {
            auto changed = builder.create<mlir::LLVM::SubOp>(
                loc, stack.getResult(), offset.getResult());
            builder.create<helix::low::RegWriteOp>(
                loc, changed.getResult(), "RSP", 64, mlir::IntegerAttr{});
        }
        auto currentStack = builder.create<helix::low::RegReadOp>(
            loc, builder.getI64Type(), "RSP", 64, mlir::IntegerAttr{});
        auto address = builder.create<mlir::LLVM::AddOp>(
            loc, currentStack.getResult(), offset.getResult());
        builder.create<helix::low::MemReadOp>(
            loc, builder.getI64Type(), address.getResult(), 64,
            mlir::IntegerAttr{});
        builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createRecoverStackLayoutPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));
        bool seventh = false;
        func.walk([&](helix::high::VarDeclOp decl) {
            seventh |= decl.getStorage() == helix::high::StorageKind::Parameter &&
                       decl.getVarName() == "param_7";
        });
        EXPECT_EQ(seventh, !adjusted);
    }
}

TEST(ApplyDebugTypesTest, CuratedKernelSignatureRecoversOnlyQualifiedStackArgument) {
    for (const std::string mode : {"qualified", "bookkeeping", "barrier",
                                   "unknown-callee", "used-cleanup"}) {
        SCOPED_TRACE(mode);
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        module->setAttr("llvm.target_triple",
                        builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(
            loc, "curated_kernel_stack_arg", 0x6300, mlir::StringAttr{});
        builder.setInsertionPointToStart(builder.createBlock(&func.getBody()));
        auto bookkeeping = builder.create<helix::high::VarDeclOp>(
            loc, 99, "next_pc", helix::high::StorageKind::Temporary,
            mlir::IntegerAttr{}, mlir::Value{}, mlir::IntegerAttr{});

        llvm::SmallVector<mlir::Value, 7> values;
        for (unsigned i = 1; i <= 7; ++i)
            values.push_back(
                builder.create<mlir::arith::ConstantIntOp>(loc, i, 64));
        auto push = builder.create<helix::low::PushOp>(
            loc, values[6], mlir::IntegerAttr{});
        if (mode == "bookkeeping") {
            auto target = builder.create<helix::high::VarRefOp>(
                loc, builder.getI64Type(), bookkeeping.getVarId(),
                bookkeeping.getVarName(), mlir::IntegerAttr{});
            builder.create<helix::high::AssignOp>(
                loc, target.getResult(), values[0], mlir::IntegerAttr{});
            builder.create<helix::low::RegReadOp>(
                loc, builder.getI64Type(), "RBP", 64, mlir::IntegerAttr{});
        }
        if (mode == "barrier") {
            builder.create<helix::low::MemWriteOp>(
                loc, values[0], values[1], 64, mlir::IntegerAttr{});
        }
        auto call = builder.create<helix::low::CallOp>(
            loc, mlir::TypeRange{builder.getI64Type()}, values[0],
            mlir::ValueRange(values).take_front(6),
            builder.getStringAttr(mode == "unknown-callee"
                                      ? "unknown_kernel_helper"
                                      : "kbase_mem_alloc"),
            mlir::IntegerAttr{});
        auto pop = builder.create<helix::low::PopOp>(
            loc, builder.getI64Type(), mlir::IntegerAttr{});
        if (mode == "used-cleanup") {
            builder.create<helix::low::RegWriteOp>(
                loc, pop.getResult(), "RAX", 64, mlir::IntegerAttr{});
        }
        builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createRecoverCallingConventionPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));

        const bool recovered = mode == "qualified" || mode == "bookkeeping" ||
                               mode == "used-cleanup";
        ASSERT_EQ(call.getArgs().size(), recovered ? 7u : 6u);
        EXPECT_EQ(push->hasAttr("helix.recovered_stack_argument"), recovered);
        EXPECT_EQ(call->hasAttr("helix.abi.missing_argument_count"),
                  mode == "barrier");
        EXPECT_EQ(func->hasAttr("helix.abi.incomplete_call_count"),
                  mode == "barrier");
        EXPECT_EQ(pop->hasAttr("helix.recovered_stack_argument_cleanup"),
                  recovered && mode != "used-cleanup");
        if (recovered) {
            auto captured =
                call.getArgs()[6].getDefiningOp<helix::high::VarRefOp>();
            ASSERT_TRUE(captured);
            bool matched = false;
            func.walk([&](helix::high::AssignOp assignment) {
                auto target = assignment.getTarget()
                                  .getDefiningOp<helix::high::VarRefOp>();
                if (target && target.getVarId() == captured.getVarId())
                    matched |= assignment.getValue() == values[6];
            });
            EXPECT_TRUE(matched);
        }
    }
}

TEST(ApplyDebugTypesTest, SysVFrameBaseTracksConstantAndRejectsDynamicAdjustment) {
    for (unsigned mode : {0u, 1u, 2u}) {
      for (int64_t accessOffset : {8, 16}) {
        SCOPED_TRACE("mode=" + std::to_string(mode) + " offset=" + std::to_string(accessOffset));
        mlir::MLIRContext ctx;
        ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
        ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
        ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();
        mlir::OpBuilder builder(&ctx);
        auto loc = builder.getUnknownLoc();
        auto module = mlir::ModuleOp::create(loc);
        module->setAttr("llvm.target_triple",
                        builder.getStringAttr("x86_64-pc-linux-gnu-elf"));
        builder.setInsertionPointToEnd(module.getBody());
        auto func = builder.create<helix::low::FuncOp>(
            loc, "frame_base", 0x6300, mlir::StringAttr{});
        auto* block = builder.createBlock(&func.getBody());
        builder.setInsertionPointToStart(block);
        auto offset = builder.create<mlir::LLVM::ConstantOp>(
            loc, builder.getI64Type(), builder.getI64IntegerAttr(8));
        if (mode != 0) {
            auto oldStack = builder.create<helix::low::RegReadOp>(
                loc, builder.getI64Type(), "RSP", 64, mlir::IntegerAttr{});
            mlir::Value adjustment = offset.getResult();
            if (mode == 2)
                adjustment = builder.create<helix::low::RegReadOp>(
                    loc, builder.getI64Type(), "RAX", 64, mlir::IntegerAttr{});
            auto changed = builder.create<mlir::LLVM::SubOp>(
                loc, oldStack.getResult(), adjustment);
            builder.create<helix::low::RegWriteOp>(
                loc, changed.getResult(), "RSP", 64, mlir::IntegerAttr{});
        }
        auto stack = builder.create<helix::low::RegReadOp>(
            loc, builder.getI64Type(), "RSP", 64, mlir::IntegerAttr{});
        builder.create<helix::low::RegWriteOp>(
            loc, stack.getResult(), "RBP", 64, mlir::IntegerAttr{});
        auto frame = builder.create<helix::low::RegReadOp>(
            loc, builder.getI64Type(), "RBP", 64, mlir::IntegerAttr{});
        auto access = builder.create<mlir::LLVM::ConstantOp>(
            loc, builder.getI64Type(), builder.getI64IntegerAttr(accessOffset));
        auto address = builder.create<mlir::LLVM::AddOp>(
            loc, frame.getResult(), access.getResult());
        builder.create<helix::low::MemReadOp>(
            loc, builder.getI64Type(), address.getResult(), 64, mlir::IntegerAttr{});
        builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
        mlir::PassManager pm(&ctx);
        pm.addPass(helix::createRecoverStackLayoutPass());
        ASSERT_TRUE(mlir::succeeded(pm.run(module)));
        bool seventh = false;
        func.walk([&](helix::high::VarDeclOp decl) {
            seventh |= decl.getStorage() == helix::high::StorageKind::Parameter &&
                       decl.getVarName() == "param_7";
        });
        EXPECT_EQ(seventh, (mode == 0 && accessOffset == 8) ||
                           (mode == 1 && accessOffset == 16));
      }
    }
}
