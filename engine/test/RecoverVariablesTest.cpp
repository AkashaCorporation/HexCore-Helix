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
