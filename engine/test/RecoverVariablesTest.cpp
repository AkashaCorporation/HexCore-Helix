/// @file RecoverVariablesTest.cpp
/// @brief Direct contracts for RecoverVariables SSA version coalescing.

#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/passes/Passes.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Verifier.h"
#include "mlir/Pass/PassManager.h"

#include <gtest/gtest.h>

#include <cstdint>
#include <set>
#include <string>

namespace {

/// Build two non-overlapping RAX SSA versions. The first is address-bearing
/// through llvm.add(base, const) -> mem.read; the second is pure scalar value.
/// Two scalar reads keep Phase 5 from inlining the second version away.
mlir::OwningOpRef<mlir::ModuleOp>
buildAddressAndScalarVersions(mlir::MLIRContext& ctx) {
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);

    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "ssa_usage_guard", /*entry_address=*/0x1000,
        /*original_name=*/mlir::StringAttr{});
    auto* addressBlock = builder.createBlock(&func.getBody());
    auto* scalarBlock = builder.createBlock(&func.getBody());
    auto i64Ty = builder.getI64Type();

    builder.setInsertionPointToStart(addressBlock);
    // NOTE: the ConstantOp is created FIRST, before the RegReadOp, so that
    // declBuilder's insertion point (RecoverVariables.cpp: `entryBlock =
    // funcBody.front()` + `setInsertionPointToStart`) anchors on an op that
    // survives the pass. RegReadOp gets erase()'d as soon as it's converted
    // to a VarRefOp -- if it were the block's first op, declBuilder's
    // insertion-point iterator would dangle after that erase, and the NEXT
    // declBuilder.create<VarDeclOp>() call (for the scalar block's version)
    // would deref freed memory. This crashed with SEH 0xc0000005 before the
    // reorder; real Remill-lifted functions never hit this because earlier
    // pipeline stages (RecoverStackLayout, RecoverCallingConvention, etc.)
    // always insert at least one surviving op before the first reg.read.
    auto offset = builder.create<mlir::LLVM::ConstantOp>(
        loc, i64Ty, builder.getI64IntegerAttr(8));
    auto addressBase = builder.create<helix::low::RegReadOp>(
        loc, i64Ty, "RAX", /*bit_width=*/64, mlir::IntegerAttr{});
    auto address = builder.create<mlir::LLVM::AddOp>(
        loc, addressBase.getResult(), offset.getResult());
    builder.create<helix::low::MemReadOp>(
        loc, i64Ty, address.getResult(), /*bit_width=*/64,
        mlir::IntegerAttr{});
    builder.create<helix::low::JmpOp>(
        loc, mlir::ValueRange{}, mlir::IntegerAttr{}, mlir::IntegerAttr{},
        scalarBlock);

    builder.setInsertionPointToStart(scalarBlock);
    auto one = builder.create<mlir::LLVM::ConstantOp>(
        loc, i64Ty, builder.getI64IntegerAttr(1));
    builder.create<helix::low::RegWriteOp>(
        loc, one.getResult(), "RAX", /*bit_width=*/64, mlir::IntegerAttr{});

    auto scalarA = builder.create<helix::low::RegReadOp>(
        loc, i64Ty, "RAX", /*bit_width=*/64, mlir::IntegerAttr{});
    auto scalarB = builder.create<helix::low::RegReadOp>(
        loc, i64Ty, "RAX", /*bit_width=*/64, mlir::IntegerAttr{});
    builder.create<mlir::arith::AddIOp>(
        loc, scalarA.getResult(), one.getResult());
    builder.create<mlir::arith::AddIOp>(
        loc, scalarB.getResult(), one.getResult());
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    return module;
}

mlir::OwningOpRef<mlir::ModuleOp>
buildMultiWriteIntegerReturn(mlir::MLIRContext& ctx,
                             bool includeCqoHelper = false) {
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);

    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "multi_write_return", /*entry_address=*/0x2000,
        /*original_name=*/mlir::StringAttr{});
    func->setAttr("calling_convention", builder.getStringAttr("win64"));
    func->setAttr("has_return_value", builder.getUnitAttr());

    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto i64Ty = builder.getI64Type();
    auto one = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 64);
    auto lhs = builder.create<helix::low::RegReadOp>(
        loc, i64Ty, "RCX", /*bit_width=*/64, mlir::IntegerAttr{});
    auto rhs = builder.create<helix::low::RegReadOp>(
        loc, i64Ty, "RDX", /*bit_width=*/64, mlir::IntegerAttr{});

    // RAX is scratch first. RCX is then overwritten with an intermediate
    // expression before RAX receives the actual return value.
    builder.create<helix::low::RegWriteOp>(
        loc, lhs.getResult(), "RAX", /*bit_width=*/64,
        mlir::IntegerAttr{});
    auto xored = builder.create<mlir::arith::XOrIOp>(
        loc, lhs.getResult(), rhs.getResult());
    builder.create<helix::low::RegWriteOp>(
        loc, xored.getResult(), "RCX", /*bit_width=*/64,
        mlir::IntegerAttr{});

    auto scratch = builder.create<helix::low::RegReadOp>(
        loc, i64Ty, "RAX", /*bit_width=*/64, mlir::IntegerAttr{});
    auto intermediate = builder.create<helix::low::RegReadOp>(
        loc, i64Ty, "RCX", /*bit_width=*/64, mlir::IntegerAttr{});
    auto sum = builder.create<mlir::arith::AddIOp>(
        loc, scratch.getResult(), intermediate.getResult());
    auto finalValue = builder.create<mlir::arith::AddIOp>(
        loc, sum.getResult(), one.getResult());
    if (includeCqoHelper) {
        auto zero = builder.create<mlir::arith::ConstantIntOp>(loc, 0, 64);
        builder.create<helix::low::CallOp>(
            loc, mlir::TypeRange{i64Ty}, zero.getResult(),
            mlir::ValueRange{}, builder.getStringAttr("CQO_RAX"),
            mlir::IntegerAttr{});
    }
    builder.create<helix::low::RegWriteOp>(
        loc, finalValue.getResult(), "RAX", /*bit_width=*/64,
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    return module;
}

mlir::OwningOpRef<mlir::ModuleOp>
buildTopLevelAndNestedReturnWrites(mlir::MLIRContext& ctx) {
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);

    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "top_level_and_nested_return_writes",
        /*entry_address=*/0x2800, /*original_name=*/mlir::StringAttr{});
    func->setAttr("calling_convention", builder.getStringAttr("win64"));
    func->setAttr("has_return_value", builder.getUnitAttr());

    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto topValue = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    builder.create<helix::low::RegWriteOp>(
        loc, topValue.getResult(), "RAX", /*bit_width=*/64,
        mlir::IntegerAttr{});

    auto condition = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
    auto ifOp = builder.create<helix::high::IfOp>(
        loc, condition.getResult(), mlir::IntegerAttr{});
    auto* thenBlock = builder.createBlock(&ifOp.getThenRegion());
    builder.setInsertionPointToStart(thenBlock);
    auto nestedValue =
        builder.create<mlir::arith::ConstantIntOp>(loc, 9, 64);
    builder.create<helix::low::RegWriteOp>(
        loc, nestedValue.getResult(), "RAX", /*bit_width=*/64,
        mlir::IntegerAttr{});
    builder.create<helix::high::YieldOp>(loc, mlir::Value{});

    builder.setInsertionPointToEnd(block);
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
    return module;
}

mlir::OwningOpRef<mlir::ModuleOp>
buildTopLevelAndNativeScfReturnWrites(mlir::MLIRContext& ctx) {
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "top_level_and_native_scf_return_writes",
        /*entry_address=*/0x2900, /*original_name=*/mlir::StringAttr{});
    func->setAttr("calling_convention", builder.getStringAttr("win64"));
    func->setAttr("has_return_value", builder.getUnitAttr());

    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto topValue = builder.create<mlir::arith::ConstantIntOp>(loc, 7, 64);
    builder.create<helix::low::RegWriteOp>(
        loc, topValue.getResult(), "RAX", /*bit_width=*/64,
        mlir::IntegerAttr{});

    auto condition = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
    auto ifOp = builder.create<mlir::scf::IfOp>(
        loc, mlir::TypeRange{}, condition.getResult());
    auto* thenBlock = builder.createBlock(&ifOp.getThenRegion());
    builder.setInsertionPointToStart(thenBlock);
    auto nestedValue =
        builder.create<mlir::arith::ConstantIntOp>(loc, 9, 64);
    builder.create<helix::low::RegWriteOp>(
        loc, nestedValue.getResult(), "RAX", /*bit_width=*/64,
        mlir::IntegerAttr{});
    builder.create<mlir::scf::YieldOp>(loc);
    auto* elseBlock = builder.createBlock(&ifOp.getElseRegion());
    builder.setInsertionPointToStart(elseBlock);
    builder.create<mlir::scf::YieldOp>(loc);

    builder.setInsertionPointToEnd(block);
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
    return module;
}

mlir::OwningOpRef<mlir::ModuleOp>
buildDisjointSCFBridgeVariables(mlir::MLIRContext& ctx) {
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);

    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "disjoint_scf_bridge_vars", /*entry_address=*/0x3000,
        /*original_name=*/mlir::StringAttr{});
    auto* stateBlock = builder.createBlock(&func.getBody());
    auto* conditionBlock = builder.createBlock(&func.getBody());
    auto* shadowBlock = builder.createBlock(&func.getBody());

    builder.setInsertionPointToStart(stateBlock);
    builder.create<helix::high::VarDeclOp>(
        loc, /*var_id=*/900000, "scf_w900000",
        helix::high::StorageKind::Temporary, mlir::IntegerAttr{},
        mlir::Value{}, mlir::IntegerAttr{});
    builder.create<helix::high::VarDeclOp>(
        loc, /*var_id=*/900001, "scf_w900001",
        helix::high::StorageKind::Temporary, mlir::IntegerAttr{},
        mlir::Value{}, mlir::IntegerAttr{});
    builder.create<helix::high::VarDeclOp>(
        loc, /*var_id=*/900002, "scf_w900002",
        helix::high::StorageKind::Temporary, mlir::IntegerAttr{},
        mlir::Value{}, mlir::IntegerAttr{});
    auto stateValue = builder.create<mlir::arith::ConstantIntOp>(loc, 5, 32);
    auto stateRef = builder.create<helix::high::VarRefOp>(
        loc, builder.getI32Type(), /*var_id=*/900000, "scf_w900000",
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, stateRef.getResult(), stateValue.getResult(),
        mlir::IntegerAttr{});
    builder.create<helix::low::JmpOp>(
        loc, mlir::ValueRange{}, mlir::IntegerAttr{}, mlir::IntegerAttr{},
        conditionBlock);

    builder.setInsertionPointToStart(conditionBlock);
    auto conditionValue =
        builder.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
    auto conditionRef = builder.create<helix::high::VarRefOp>(
        loc, builder.getI1Type(), /*var_id=*/900001, "scf_w900001",
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, conditionRef.getResult(), conditionValue.getResult(),
        mlir::IntegerAttr{});
    builder.create<helix::low::JmpOp>(
        loc, mlir::ValueRange{}, mlir::IntegerAttr{}, mlir::IntegerAttr{},
        shadowBlock);

    builder.setInsertionPointToStart(shadowBlock);
    auto shadowValue = builder.create<mlir::arith::ConstantIntOp>(loc, 6, 32);
    auto shadowRef = builder.create<helix::high::VarRefOp>(
        loc, builder.getI32Type(), /*var_id=*/900002, "scf_w900002",
        mlir::IntegerAttr{});
    builder.create<helix::high::AssignOp>(
        loc, shadowRef.getResult(), shadowValue.getResult(),
        mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    return module;
}

mlir::OwningOpRef<mlir::ModuleOp>
buildX86Cdecl32WidthContract(mlir::MLIRContext& ctx) {
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();

    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(
        loc, "x86_cdecl32_width_contract", /*entry_address=*/0x3800,
        /*original_name=*/mlir::StringAttr{});
    func->setAttr("calling_convention", builder.getStringAttr("cdecl"));
    func->setAttr("has_return_value", builder.getUnitAttr());

    auto* block = builder.createBlock(&func.getBody());
    builder.setInsertionPointToStart(block);
    auto one32 = builder.create<mlir::arith::ConstantIntOp>(loc, 1, 32);
    auto byte = builder.create<mlir::arith::ConstantIntOp>(loc, 0x5a, 8);
    auto rbp = builder.create<helix::low::RegReadOp>(
        loc, builder.getI32Type(), "RBP", /*bit_width=*/32,
        mlir::IntegerAttr{});
    builder.create<mlir::LLVM::AddOp>(
        loc, rbp.getResult(), one32.getResult());

    // Remill retains the physical RAX identity for an AL/EAX write. The
    // encoded value width is the authoritative sub-register view.
    builder.create<helix::low::RegWriteOp>(
        loc, byte.getResult(), "RAX", /*bit_width=*/8,
        mlir::IntegerAttr{});
    auto eax = builder.create<helix::low::RegReadOp>(
        loc, builder.getI32Type(), "RAX", /*bit_width=*/32,
        mlir::IntegerAttr{});
    builder.create<mlir::arith::AddIOp>(
        loc, eax.getResult(), one32.getResult());
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
    return module;
}

} // namespace

TEST(RecoverVariablesTest, PreservesX86Cdecl32ParentAndSubregisterWidths) {
    mlir::MLIRContext ctx;
    auto module = buildX86Cdecl32WidthContract(ctx);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));
    ASSERT_TRUE(mlir::succeeded(mlir::verify(*module)));

    module->walk([&](helix::high::VarRefOp ref) {
        if (ref.getVarName().starts_with("rbp") ||
            ref.getVarName().starts_with("rax")) {
            auto type = mlir::dyn_cast<mlir::IntegerType>(ref.getType());
            ASSERT_TRUE(type);
            EXPECT_EQ(type.getWidth(), 32u);
        }
    });
}

TEST(RecoverVariablesTest, KeepsAddressBearingAndPureValueVersionsSeparate) {
    mlir::MLIRContext ctx;
    auto module = buildAddressAndScalarVersions(ctx);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    std::set<std::string> raxDecls;
    std::set<uint32_t> raxRefIds;
    module->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getVarName() == "rax" || decl.getVarName() == "rax_1")
            raxDecls.insert(decl.getVarName().str());
    });
    module->walk([&](helix::high::VarRefOp ref) {
        if (ref.getVarName() == "rax" || ref.getVarName() == "rax_1")
            raxRefIds.insert(ref.getVarId());
    });

    // Phase 3.5 must not coalesce rax_1 into address-bearing rax, and
    // Phase 4 must not re-merge the disjoint versions afterwards.
    EXPECT_EQ(raxDecls.size(), 2u);
    EXPECT_EQ(raxDecls.count("rax"), 1u);
    EXPECT_EQ(raxDecls.count("rax_1"), 1u);
    EXPECT_EQ(raxRefIds.size(), 2u);
}

TEST(RecoverVariablesTest, PreservesFinalRaxWriteAsExactResult) {
    mlir::MLIRContext ctx;
    auto module = buildMultiWriteIntegerReturn(ctx);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverVariablesPass());
    pm.addPass(helix::createEliminateDeadCodePass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    unsigned resultDecls = 0;
    unsigned resultAssignments = 0;
    module->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getVarName() == "result")
            ++resultDecls;
    });
    module->walk([&](helix::high::AssignOp assign) {
        auto target =
            assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
        if (target && target.getVarName() == "result")
            ++resultAssignments;
    });

    EXPECT_EQ(resultDecls, 1u);
    EXPECT_EQ(resultAssignments, 1u);

    unsigned survivingXors = 0;
    module->walk([&](mlir::arith::XOrIOp) { ++survivingXors; });
    EXPECT_EQ(survivingXors, 1u);
}

TEST(RecoverVariablesTest, CqoMachineHelperDoesNotSuppressExactResult) {
    mlir::MLIRContext ctx;
    auto module = buildMultiWriteIntegerReturn(ctx, /*includeCqoHelper=*/true);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverVariablesPass());
    pm.addPass(helix::createEliminateDeadCodePass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    unsigned resultAssignments = 0;
    module->walk([&](helix::high::AssignOp assign) {
        auto target =
            assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
        if (target && target.getVarName() == "result")
            ++resultAssignments;
    });
    EXPECT_EQ(resultAssignments, 1u);
}

TEST(RecoverVariablesTest, ReusesTopLevelResultInsideStructuredRegions) {
    mlir::MLIRContext ctx;
    auto module = buildTopLevelAndNestedReturnWrites(ctx);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    unsigned resultDecls = 0;
    std::set<uint32_t> resultRefIds;
    unsigned resultAssignments = 0;
    module->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getVarName() == "result")
            ++resultDecls;
    });
    module->walk([&](helix::high::VarRefOp ref) {
        if (ref.getVarName() == "result")
            resultRefIds.insert(ref.getVarId());
    });
    module->walk([&](helix::high::AssignOp assign) {
        auto target =
            assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
        if (target && target.getVarName() == "result")
            ++resultAssignments;
    });

    EXPECT_EQ(resultDecls, 1u);
    EXPECT_EQ(resultRefIds.size(), 1u);
    EXPECT_EQ(resultAssignments, 2u);
}

TEST(RecoverVariablesTest, ReusesResultInsideNativeScfRegions) {
    mlir::MLIRContext ctx;
    auto module = buildTopLevelAndNativeScfReturnWrites(ctx);

    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    unsigned resultDecls = 0;
    std::set<uint32_t> resultRefIds;
    unsigned resultAssignments = 0;
    module->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getVarName() == "result")
            ++resultDecls;
    });
    module->walk([&](helix::high::VarRefOp ref) {
        if (ref.getVarName() == "result")
            resultRefIds.insert(ref.getVarId());
    });
    module->walk([&](helix::high::AssignOp assign) {
        auto target =
            assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
        if (target && target.getVarName() == "result")
            ++resultAssignments;
    });

    EXPECT_EQ(resultDecls, 1u);
    EXPECT_EQ(resultRefIds.size(), 1u);
    EXPECT_EQ(resultAssignments, 2u);
}

TEST(RecoverVariablesTest, VoidCallCannotTypeLaterRegisterValueAsVoid) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();
    ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    builder.setInsertionPointToEnd(module.getBody());
    auto func = builder.create<helix::low::FuncOp>(loc, "saved_over_void", 0x1000, mlir::StringAttr{});
    func->setAttr("has_return_value", builder.getUnitAttr());
    func->setAttr("calling_convention", builder.getStringAttr("sysv"));
    func->setAttr("inferred_return_type", builder.getStringAttr("uint64_t"));
    builder.setInsertionPointToStart(builder.createBlock(&func.getBody()));
    auto input = builder.create<helix::low::RegReadOp>(loc, builder.getI64Type(), "RDI", 64, mlir::IntegerAttr{});
    builder.create<helix::low::RegWriteOp>(loc, input.getResult(), "RBX", 64, mlir::IntegerAttr{});
    auto target = builder.create<mlir::LLVM::ConstantOp>(loc, builder.getI64Type(), builder.getI64IntegerAttr(0x2000));
    auto call = builder.create<helix::low::CallOp>(loc, mlir::TypeRange{builder.getI64Type()}, target.getResult(),
        mlir::ValueRange{}, builder.getStringAttr("opaque_callback"), mlir::IntegerAttr{});
    call->setAttr("inferred_type", builder.getStringAttr("void"));
    call->setAttr("inferred_return_type", builder.getStringAttr("void"));
    builder.create<helix::low::RegWriteOp>(loc, call.getResult(), "RAX", 64, mlir::IntegerAttr{});
    auto saved = builder.create<helix::low::RegReadOp>(loc, builder.getI64Type(), "RBX", 64, mlir::IntegerAttr{});
    saved->setAttr("inferred_type", builder.getStringAttr("int64_t"));
    builder.create<helix::low::RegWriteOp>(loc, saved.getResult(), "RAX", 64, mlir::IntegerAttr{});
    builder.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});
    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));
    mlir::PassManager returns(&ctx);
    returns.addPass(helix::createBindReturnValuesPass());
    ASSERT_TRUE(mlir::succeeded(returns.run(module)));
    unsigned declarations = 0;
    func.walk([&](helix::high::VarDeclOp decl) {
        ++declarations;
        if (auto type = decl->getAttrOfType<mlir::StringAttr>("inferred_type"))
            EXPECT_NE(type.getValue(), "void");
    });
    EXPECT_GT(declarations, 0u);
    bool voidCall = false;
    func.walk([&](mlir::Operation* op) {
        if (!mlir::isa<helix::low::CallOp, helix::high::CallOp>(op)) return;
        auto type = op->getAttrOfType<mlir::StringAttr>("inferred_return_type");
        voidCall |= type && type.getValue() == "void";
    });
    EXPECT_TRUE(voidCall);
    unsigned explicitReturns = 0;
    func.walk([&](helix::high::ReturnOp ret) {
        auto ref = ret.getValue().getDefiningOp<helix::high::VarRefOp>();
        ASSERT_TRUE(ref);
        EXPECT_FALSE(ref.getVarName().empty());
        ++explicitReturns;
    });
    EXPECT_EQ(explicitReturns, 1u);
    EXPECT_TRUE(mlir::succeeded(mlir::verify(module)));
}

TEST(RecoverVariablesTest, PreservesDistinctSCFBridgeStorageIdentities) {
    mlir::MLIRContext ctx;
    auto module = buildDisjointSCFBridgeVariables(ctx);

    mlir::PassManager pm(&ctx);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));

    std::set<std::string> scfDecls;
    std::set<uint32_t> scfRefIds;
    module->walk([&](helix::high::VarDeclOp decl) {
        if (decl.getVarName().starts_with("scf_"))
            scfDecls.insert(decl.getVarName().str());
    });
    module->walk([&](helix::high::VarRefOp ref) {
        if (ref.getVarName().starts_with("scf_"))
            scfRefIds.insert(ref.getVarId());
    });

    EXPECT_EQ(scfDecls.size(), 3u);
    EXPECT_EQ(scfDecls.count("scf_w900000"), 1u);
    EXPECT_EQ(scfDecls.count("scf_w900001"), 1u);
    EXPECT_EQ(scfDecls.count("scf_w900002"), 1u);
    EXPECT_EQ(scfRefIds.size(), 3u);
}

TEST(RecoverVariablesTest, NestedReadKeepsEntryValueBeforeLaterReturnWrite) {
    mlir::MLIRContext ctx;
    auto module = buildTopLevelAndNativeScfReturnWrites(ctx);
    mlir::scf::IfOp branch;
    module->walk([&](mlir::scf::IfOp op) { branch = op; });
    ASSERT_TRUE(branch);
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();
    builder.setInsertionPointToStart(&branch.getThenRegion().front());
    auto read = builder.create<helix::low::RegReadOp>(
        loc, builder.getI64Type(), "RAX", 64, mlir::IntegerAttr{});
    auto address = builder.create<mlir::arith::ConstantIntOp>(loc, 0x2000, 64);
    auto store = builder.create<helix::low::MemWriteOp>(
        loc, address.getResult(), read.getResult(), 64, mlir::IntegerAttr{});
    builder.setInsertionPointAfter(branch);
    auto finalValue = builder.create<mlir::arith::ConstantIntOp>(loc, 17, 64);
    builder.create<helix::low::RegWriteOp>(
        loc, finalValue.getResult(), "RAX", 64, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(*module)));
    bool entrySeven = false;
    bool finalSeventeen = false;
    bool frozenNestedRead = false;
    auto stored = store.getValue().getDefiningOp<helix::high::VarRefOp>();
    ASSERT_TRUE(stored);
    module->walk([&](helix::high::AssignOp assign) {
        auto target = assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
        if (!target) return;
        if (target.getVarName() == "result" && assign->getBlock() == branch->getBlock()) {
            auto constant = assign.getValue().getDefiningOp<mlir::arith::ConstantIntOp>();
            if (!constant) return;
            entrySeven |= constant.value() == 7 && assign->isBeforeInBlock(branch);
            finalSeventeen |= constant.value() == 17 && branch->isBeforeInBlock(assign);
        }
        if (target.getVarId() == stored.getVarId() && assign->getBlock() == store->getBlock()) {
            auto source = assign.getValue().getDefiningOp<helix::high::VarRefOp>();
            frozenNestedRead |= source && source.getVarName() == "result" && assign->isBeforeInBlock(store);
        }
    });
    EXPECT_TRUE(entrySeven);
    EXPECT_TRUE(finalSeventeen);
    EXPECT_TRUE(frozenNestedRead);
}

TEST(RecoverVariablesTest, StructuredNonReturnRegisterKeepsComputedReachingValue) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();
    mlir::OpBuilder b(&ctx);
    auto loc = b.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    b.setInsertionPointToEnd(module.getBody());
    auto func = b.create<helix::low::FuncOp>(loc, "structured_rdx", 0x3100,
                                             mlir::StringAttr{});
    func->setAttr("calling_convention", b.getStringAttr("sysv"));
    func->setAttr("has_return_value", b.getUnitAttr());
    func->setAttr("reg_param_indices", b.getDenseI32ArrayAttr({5}));
    auto* block = b.createBlock(&func.getBody());
    b.setInsertionPointToStart(block);
    auto input = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "R8", 64, mlir::IntegerAttr{});
    auto five = b.create<mlir::arith::ConstantIntOp>(loc, 5, 64);
    auto computed = b.create<mlir::arith::AddIOp>(
        loc, input.getResult(), five.getResult());
    b.create<helix::low::RegWriteOp>(
        loc, computed.getResult(), "RDX", 64, mlir::IntegerAttr{});
    auto condition = b.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
    auto branch = b.create<mlir::scf::IfOp>(
        loc, mlir::TypeRange{}, condition.getResult());
    auto* thenBlock = b.createBlock(&branch.getThenRegion());
    b.setInsertionPointToStart(thenBlock);
    auto nestedRead = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "RDX", 64, mlir::IntegerAttr{});
    auto address = b.create<mlir::arith::ConstantIntOp>(loc, 0x2000, 64);
    auto store = b.create<helix::low::MemWriteOp>(
        loc, address.getResult(), nestedRead.getResult(), 64,
        mlir::IntegerAttr{});
    auto nine = b.create<mlir::arith::ConstantIntOp>(loc, 9, 64);
    b.create<helix::low::RegWriteOp>(
        loc, nine.getResult(), "RDX", 64, mlir::IntegerAttr{});
    b.create<mlir::scf::YieldOp>(loc);
    auto* elseBlock = b.createBlock(&branch.getElseRegion());
    b.setInsertionPointToStart(elseBlock);
    b.create<mlir::scf::YieldOp>(loc);
    b.setInsertionPointToEnd(block);
    auto seventeen = b.create<mlir::arith::ConstantIntOp>(loc, 17, 64);
    b.create<helix::low::RegWriteOp>(
        loc, seventeen.getResult(), "RDX", 64, mlir::IntegerAttr{});
    auto twentyThree = b.create<mlir::arith::ConstantIntOp>(loc, 23, 64);
    b.create<helix::low::RegWriteOp>(
        loc, twentyThree.getResult(), "RAX", 64, mlir::IntegerAttr{});
    b.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));
    unsigned paramFive = 0, rdxSlots = 0;
    func.walk([&](helix::high::VarDeclOp decl) {
        paramFive += decl.getVarName() == "param_5";
        if (auto slot = decl->getAttrOfType<mlir::StringAttr>(
                "helix.region_register_slot"))
            rdxSlots += slot.getValue() == "RDX";
    });
    EXPECT_EQ(paramFive, 1u);
    EXPECT_EQ(rdxSlots, 0u);
    auto stored = store.getValue().getDefiningOp<helix::high::VarRefOp>();
    ASSERT_TRUE(stored);
    EXPECT_NE(stored.getVarName(), "param_5");
    bool assignedComputedValue = false;
    func.walk([&](helix::high::AssignOp assign) {
        auto target = assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
        assignedComputedValue |= target &&
            target.getVarId() == stored.getVarId() &&
            assign.getValue() == computed.getResult();
    });
    EXPECT_TRUE(assignedComputedValue);
}

TEST(RecoverVariablesTest, NestedParameterReadBeforeWriteKeepsEntryIdentity) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();
    mlir::OpBuilder b(&ctx);
    auto loc = b.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    b.setInsertionPointToEnd(module.getBody());
    auto func = b.create<helix::low::FuncOp>(
        loc, "nested_parameter_lifetime", 0x3150, mlir::StringAttr{});
    func->setAttr("calling_convention", b.getStringAttr("sysv"));
    func->setAttr("reg_param_indices", b.getDenseI32ArrayAttr({3}));
    auto* block = b.createBlock(&func.getBody());
    b.setInsertionPointToStart(block);
    auto condition = b.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
    auto branch = b.create<mlir::scf::IfOp>(
        loc, mlir::TypeRange{}, condition.getResult());
    auto* thenBlock = b.createBlock(&branch.getThenRegion());
    b.setInsertionPointToStart(thenBlock);
    auto entryRead = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "RDX", 64, mlir::IntegerAttr{});
    auto entryLoad = b.create<helix::low::MemReadOp>(
        loc, b.getI64Type(), entryRead.getResult(), 64,
        mlir::IntegerAttr{});
    auto replacement = b.create<mlir::arith::ConstantIntOp>(
        loc, 0x8000, 64);
    b.create<helix::low::RegWriteOp>(
        loc, replacement.getResult(), "RDX", 64, mlir::IntegerAttr{});
    auto lateReadA = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "RDX", 64, mlir::IntegerAttr{});
    auto lateReadB = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "RDX", 64, mlir::IntegerAttr{});
    auto sink = b.create<mlir::arith::ConstantIntOp>(loc, 0x9000, 64);
    auto lateStoreA = b.create<helix::low::MemWriteOp>(
        loc, sink.getResult(), lateReadA.getResult(), 64,
        mlir::IntegerAttr{});
    auto lateStoreB = b.create<helix::low::MemWriteOp>(
        loc, sink.getResult(), lateReadB.getResult(), 64,
        mlir::IntegerAttr{});
    b.create<mlir::scf::YieldOp>(loc);
    auto* elseBlock = b.createBlock(&branch.getElseRegion());
    b.setInsertionPointToStart(elseBlock);
    b.create<mlir::scf::YieldOp>(loc);
    b.setInsertionPointToEnd(block);
    b.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    auto entryRef = entryLoad.getAddr()
        .getDefiningOp<helix::high::VarRefOp>();
    auto lateRefA = lateStoreA.getValue()
        .getDefiningOp<helix::high::VarRefOp>();
    auto lateRefB = lateStoreB.getValue()
        .getDefiningOp<helix::high::VarRefOp>();
    ASSERT_TRUE(entryRef);
    ASSERT_TRUE(lateRefA);
    ASSERT_TRUE(lateRefB);
    EXPECT_EQ(entryRef.getVarName(), "param_3");
    EXPECT_NE(lateRefA.getVarId(), entryRef.getVarId());
    EXPECT_EQ(lateRefA.getVarId(), lateRefB.getVarId());
    EXPECT_NE(lateRefA.getVarName(), "param_3");
}

TEST(RecoverVariablesTest, LoopEntryReadUsesLoopCarriedParameterShadow) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::scf::SCFDialect>();
    mlir::OpBuilder b(&ctx);
    auto loc = b.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    b.setInsertionPointToEnd(module.getBody());
    auto func = b.create<helix::low::FuncOp>(
        loc, "loop_parameter_shadow", 0x3180, mlir::StringAttr{});
    func->setAttr("calling_convention", b.getStringAttr("sysv"));
    func->setAttr("reg_param_indices", b.getDenseI32ArrayAttr({3}));
    auto* block = b.createBlock(&func.getBody());
    b.setInsertionPointToStart(block);
    auto loop = b.create<mlir::scf::WhileOp>(
        loc, mlir::TypeRange{}, mlir::ValueRange{});
    auto* before = b.createBlock(&loop.getBefore());
    b.setInsertionPointToStart(before);
    auto condition = b.create<mlir::arith::ConstantIntOp>(loc, 1, 1);
    b.create<mlir::scf::ConditionOp>(
        loc, condition.getResult(), mlir::ValueRange{});
    auto* body = b.createBlock(&loop.getAfter());
    b.setInsertionPointToStart(body);
    auto entryRead = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "RDX", 64, mlir::IntegerAttr{});
    auto sink = b.create<mlir::arith::ConstantIntOp>(loc, 0x9000, 64);
    auto store = b.create<helix::low::MemWriteOp>(
        loc, sink.getResult(), entryRead.getResult(), 64,
        mlir::IntegerAttr{});
    auto replacement = b.create<mlir::arith::ConstantIntOp>(loc, 9, 64);
    b.create<helix::low::RegWriteOp>(
        loc, replacement.getResult(), "RDX", 64, mlir::IntegerAttr{});
    b.create<mlir::scf::YieldOp>(loc);
    b.setInsertionPointToEnd(block);
    b.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    auto stored = store.getValue()
        .getDefiningOp<helix::high::VarRefOp>();
    ASSERT_TRUE(stored);
    EXPECT_NE(stored.getVarName(), "param_3");
    bool initializedFromParameter = false;
    func.walk([&](helix::high::AssignOp assign) {
        auto target = assign.getTarget()
            .getDefiningOp<helix::high::VarRefOp>();
        auto source = assign.getValue()
            .getDefiningOp<helix::high::VarRefOp>();
        initializedFromParameter |= target && source &&
            target.getVarId() == stored.getVarId() &&
            source.getVarName() == "param_3";
    });
    EXPECT_TRUE(initializedFromParameter);
}

TEST(RecoverVariablesTest, AbiParameterEntryValueDoesNotAbsorbLaterRegisterLifetime) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    mlir::OpBuilder b(&ctx);
    auto loc = b.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    b.setInsertionPointToEnd(module.getBody());
    auto func = b.create<helix::low::FuncOp>(
        loc, "abi_parameter_lifetime", 0x3200, mlir::StringAttr{});
    func->setAttr("calling_convention", b.getStringAttr("sysv"));
    func->setAttr("reg_param_indices", b.getDenseI32ArrayAttr({3}));
    b.setInsertionPointToStart(b.createBlock(&func.getBody()));

    auto input = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "RDX", 64, mlir::IntegerAttr{});
    auto one = b.create<mlir::arith::ConstantIntOp>(loc, 1, 64);
    auto scalarUse = b.create<mlir::arith::AddIOp>(
        loc, input.getResult(), one.getResult());
    auto sink = b.create<mlir::arith::ConstantIntOp>(loc, 0x5000, 64);
    b.create<helix::low::MemWriteOp>(
        loc, sink.getResult(), scalarUse.getResult(), 64,
        mlir::IntegerAttr{});

    auto callee =
        b.create<mlir::arith::ConstantIntOp>(loc, 0x7000, 64);
    auto pointerValue = b.create<helix::low::CallOp>(
        loc, mlir::TypeRange{b.getI64Type()}, callee.getResult(),
        mlir::ValueRange{}, b.getStringAttr("sub_7000"),
        mlir::IntegerAttr{});
    b.create<helix::low::RegWriteOp>(
        loc, pointerValue.getResult(), "RDX", 64, mlir::IntegerAttr{});
    auto later = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "RDX", 64, mlir::IntegerAttr{});
    auto load = b.create<helix::low::MemReadOp>(
        loc, b.getI64Type(), later.getResult(), 64, mlir::IntegerAttr{});
    b.create<helix::low::MemReadOp>(
        loc, b.getI64Type(), later.getResult(), 64, mlir::IntegerAttr{});
    b.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    auto parameterRef = scalarUse.getLhs()
        .getDefiningOp<helix::high::VarRefOp>();
    auto laterRef = load.getAddr()
        .getDefiningOp<helix::high::VarRefOp>();
    ASSERT_TRUE(parameterRef);
    ASSERT_TRUE(laterRef);
    EXPECT_EQ(parameterRef.getVarName(), "param_3");
    EXPECT_NE(laterRef.getVarId(), parameterRef.getVarId());
    EXPECT_NE(laterRef.getVarName(), "param_3");

    helix::high::StorageKind laterStorage =
        helix::high::StorageKind::Parameter;
    func.walk([&](helix::high::VarDeclOp decl) {
        if (decl.getVarId() == laterRef.getVarId())
            laterStorage = decl.getStorage();
    });
    EXPECT_EQ(laterStorage, helix::high::StorageKind::Register);
}

TEST(RecoverVariablesTest, DirectParameterCopySurvivesCoverBasedMerging) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    ctx.getOrLoadDialect<mlir::LLVM::LLVMDialect>();
    mlir::OpBuilder b(&ctx);
    auto loc = b.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    b.setInsertionPointToEnd(module.getBody());
    auto func = b.create<helix::low::FuncOp>(
        loc, "parameter_copy_cover", 0x3300, mlir::StringAttr{});
    func->setAttr("calling_convention", b.getStringAttr("sysv"));
    func->setAttr("reg_param_indices", b.getDenseI32ArrayAttr({2}));
    auto* parameterBlock = b.createBlock(&func.getBody());
    auto* unrelatedBlock = b.createBlock(&func.getBody());

    b.setInsertionPointToStart(parameterBlock);
    auto offsetA = b.create<mlir::LLVM::ConstantOp>(
        loc, b.getI64Type(), b.getI64IntegerAttr(8));
    auto parameter = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "RSI", 64, mlir::IntegerAttr{});
    b.create<helix::low::RegWriteOp>(
        loc, parameter.getResult(), "R15", 64, mlir::IntegerAttr{});
    auto alias = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "R15", 64, mlir::IntegerAttr{});
    auto addressA = b.create<mlir::LLVM::AddOp>(
        loc, alias.getResult(), offsetA.getResult());
    auto loadA = b.create<helix::low::MemReadOp>(
        loc, b.getI64Type(), addressA.getResult(), 64,
        mlir::IntegerAttr{});
    b.create<helix::low::JmpOp>(
        loc, mlir::ValueRange{}, mlir::IntegerAttr{}, mlir::IntegerAttr{},
        unrelatedBlock);

    b.setInsertionPointToStart(unrelatedBlock);
    auto calleeB = b.create<mlir::LLVM::ConstantOp>(
        loc, b.getI64Type(), b.getI64IntegerAttr(0x9000));
    auto baseB = b.create<helix::low::CallOp>(
        loc, mlir::TypeRange{b.getI64Type()}, calleeB.getResult(),
        mlir::ValueRange{}, b.getStringAttr("sub_9000"),
        mlir::IntegerAttr{});
    auto offsetB = b.create<mlir::LLVM::ConstantOp>(
        loc, b.getI64Type(), b.getI64IntegerAttr(16));
    b.create<helix::low::RegWriteOp>(
        loc, baseB.getResult(), "R14", 64, mlir::IntegerAttr{});
    auto unrelated = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "R14", 64, mlir::IntegerAttr{});
    auto addressB = b.create<mlir::LLVM::AddOp>(
        loc, unrelated.getResult(), offsetB.getResult());
    auto loadB = b.create<helix::low::MemReadOp>(
        loc, b.getI64Type(), addressB.getResult(), 64,
        mlir::IntegerAttr{});
    b.create<helix::low::MemReadOp>(
        loc, b.getI64Type(), unrelated.getResult(), 64,
        mlir::IntegerAttr{});
    b.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createRecoverVariablesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    auto findAddressVar = [](mlir::Value address) {
        auto add = address.getDefiningOp<mlir::LLVM::AddOp>();
        if (!add)
            return helix::high::VarRefOp{};
        for (mlir::Value operand : add->getOperands()) {
            if (auto ref = operand.getDefiningOp<helix::high::VarRefOp>())
                return ref;
        }
        return helix::high::VarRefOp{};
    };
    auto aliasRef = findAddressVar(loadA.getAddr());
    auto unrelatedRef = findAddressVar(loadB.getAddr());
    ASSERT_TRUE(aliasRef);
    ASSERT_TRUE(unrelatedRef);
    EXPECT_NE(aliasRef.getVarId(), unrelatedRef.getVarId());

    bool aliasInitializedFromParameter = false;
    func.walk([&](helix::high::AssignOp assign) {
        auto target = assign.getTarget()
            .getDefiningOp<helix::high::VarRefOp>();
        auto source = assign.getValue()
            .getDefiningOp<helix::high::VarRefOp>();
        aliasInitializedFromParameter |= target && source &&
            target.getVarId() == aliasRef.getVarId() &&
            source.getVarName() == "param_2";
    });
    EXPECT_TRUE(aliasInitializedFromParameter ||
                aliasRef.getVarName() == "param_2");
}

TEST(RecoverVariablesTest, ReturnRegisterParameterCaptureDoesNotHideCallResult) {
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    ctx.getOrLoadDialect<helix::low::HelixLowDialect>();
    ctx.getOrLoadDialect<mlir::arith::ArithDialect>();
    mlir::OpBuilder b(&ctx);
    auto loc = b.getUnknownLoc();
    auto module = mlir::ModuleOp::create(loc);
    b.setInsertionPointToEnd(module.getBody());
    auto func = b.create<helix::low::FuncOp>(
        loc, "return_after_parameter_capture", 0x3400,
        mlir::StringAttr{});
    func->setAttr("calling_convention", b.getStringAttr("sysv"));
    func->setAttr("has_return_value", b.getUnitAttr());
    func->setAttr("reg_param_indices", b.getDenseI32ArrayAttr({2}));
    b.setInsertionPointToStart(b.createBlock(&func.getBody()));

    auto input = b.create<helix::low::RegReadOp>(
        loc, b.getI64Type(), "RSI", 64, mlir::IntegerAttr{});
    b.create<helix::low::RegWriteOp>(
        loc, input.getResult(), "RAX", 64, mlir::IntegerAttr{});
    auto scratch = b.create<mlir::arith::ConstantIntOp>(loc, 99, 64);
    b.create<helix::low::RegWriteOp>(
        loc, scratch.getResult(), "RAX", 64, mlir::IntegerAttr{});
    auto target = b.create<mlir::arith::ConstantIntOp>(loc, 0x2000, 64);
    auto call = b.create<helix::low::CallOp>(
        loc, mlir::TypeRange{b.getI64Type()}, target.getResult(),
        mlir::ValueRange{}, b.getStringAttr("sub_2000"),
        mlir::IntegerAttr{});
    b.create<helix::low::RegWriteOp>(
        loc, call.getResult(), "RAX", 64, mlir::IntegerAttr{});
    b.create<helix::low::RetOp>(loc, mlir::IntegerAttr{});

    mlir::PassManager pm(&ctx);
    pm.enableVerifier(true);
    pm.addPass(helix::createRecoverVariablesPass());
    pm.addPass(helix::createBindReturnValuesPass());
    ASSERT_TRUE(mlir::succeeded(pm.run(module)));

    unsigned explicitReturns = 0;
    bool returnedCallResult = false;
    func.walk([&](helix::high::ReturnOp ret) {
        ++explicitReturns;
        auto ref = ret.getValue()
            .getDefiningOp<helix::high::VarRefOp>();
        ASSERT_TRUE(ref);
        func.walk([&](helix::high::AssignOp assign) {
            auto targetRef = assign.getTarget()
                .getDefiningOp<helix::high::VarRefOp>();
            returnedCallResult |= targetRef &&
                targetRef.getVarId() == ref.getVarId() &&
                assign.getValue() == call.getResult();
        });
    });
    EXPECT_EQ(explicitReturns, 1u);
    EXPECT_TRUE(returnedCallResult);
}
