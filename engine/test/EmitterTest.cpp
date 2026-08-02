/// @file EmitterTest.cpp
/// @brief Unit tests for the FlatBuffer serializer verification.

#include "helix/emit/PseudoCEmitter.h"
#include "helix/emit/FlatBufSerializer.h"
#include "helix/cast/CAstOptimizer.h"
#include "helix/cast/CAstPrinter.h"
#include "helix/cast/CDecl.h"
#include <algorithm>
#include <gtest/gtest.h>
#include <vector>
#include <cstdint>
#include <memory>
#include <string>

using namespace helix;

namespace {

using namespace helix::cast;

ExprPtr makeVar(std::string name) {
    return std::make_unique<CVarRefExpr>(
        0, std::move(name), CType::int64());
}

ExprPtr makeInt(int64_t value) {
    return std::make_unique<CIntLitExpr>(value, CType::int64());
}

} // namespace

TEST(FlatBufSerializerTest, VerifyEmpty) {
    EXPECT_FALSE(FlatBufSerializer::verify(nullptr, 0));
}

TEST(FlatBufSerializerTest, VerifyTooSmall) {
    uint8_t data[] = {0, 0, 0}; // 3 bytes, need at least 8
    EXPECT_FALSE(FlatBufSerializer::verify(data, sizeof(data)));
}

TEST(FlatBufSerializerTest, VerifyBadIdentifier) {
    uint8_t data[] = {
        8, 0, 0, 0,  // root offset
        'B', 'A', 'D', '!',  // wrong file identifier
    };
    EXPECT_FALSE(FlatBufSerializer::verify(data, sizeof(data)));
}

TEST(FlatBufSerializerTest, VerifyCorrectIdentifier) {
    uint8_t data[] = {
        8, 0, 0, 0,  // root offset (points to byte 8)
        'H', 'A', 'S', 'T',  // correct file identifier
        // ... minimal valid table data would follow
        0, 0, 0, 0,  // padding
    };
    // This has HAST identifier and root offset within bounds
    EXPECT_TRUE(FlatBufSerializer::verify(data, sizeof(data)));
}

TEST(FlatBufSerializerTest, VerifyRootOffsetOutOfBounds) {
    uint8_t data[] = {
        255, 0, 0, 0,  // root offset (out of bounds)
        'H', 'A', 'S', 'T',
    };
    EXPECT_FALSE(FlatBufSerializer::verify(data, sizeof(data)));
}

TEST(FlatBufSerializerTest, OmitsAbsentExpressionChildren) {
    std::vector<std::unique_ptr<cast::CFuncDecl>> funcs;
    auto func = std::make_unique<cast::CFuncDecl>(
        "incomplete_ast", 0x1000, cast::CType::voidTy());
    func->body.push_back(std::make_unique<cast::CExprStmt>(
        std::make_unique<cast::CBinaryExpr>(
            cast::BinaryOp::Add, makeInt(1), nullptr, cast::CType::int64())));
    funcs.push_back(std::move(func));

    FlatBufSerializer serializer;
    const auto buffer = serializer.serialize(funcs);

    ASSERT_FALSE(buffer.empty());
    EXPECT_TRUE(FlatBufSerializer::verify(buffer.data(), buffer.size()));
}

TEST(PseudoCEmitterHeuristicsTest, InfersWin64StackParameterIndices) {
    EXPECT_EQ(
        PseudoCEmitter::inferWin64StackParamIndexFromAddressString("(rsp + 0x28)"),
        5u);
    EXPECT_EQ(
        PseudoCEmitter::inferWin64StackParamIndexFromAddressString("(rsp + 0x30)"),
        6u);
    EXPECT_EQ(
        PseudoCEmitter::inferWin64StackParamIndexFromAddressString("(rbp + 0x48)"),
        9u);
    EXPECT_EQ(
        PseudoCEmitter::inferWin64StackParamIndexFromAddressString(
            "(rbp + 0x50)", 0x50),
        5u);
}

TEST(PseudoCEmitterHeuristicsTest, RejectsNonParameterStackOffsets) {
    EXPECT_FALSE(
        PseudoCEmitter::inferWin64StackParamIndexFromAddressString("(rsp + 0x20)")
            .has_value());
    EXPECT_FALSE(
        PseudoCEmitter::inferWin64StackParamIndexFromAddressString("(rbp - 0x20)")
            .has_value());
    EXPECT_FALSE(
        PseudoCEmitter::inferWin64StackParamIndexFromAddressString("(rax + 0x30)")
            .has_value());
}

TEST(PseudoCEmitterHeuristicsTest, DetectsStructLikeBaseIdentifiers) {
    EXPECT_TRUE(PseudoCEmitter::looksLikeStructBaseIdentifier("param_1"));
    EXPECT_TRUE(PseudoCEmitter::looksLikeStructBaseIdentifier("this"));
    EXPECT_TRUE(PseudoCEmitter::looksLikeStructBaseIdentifier("rax"));
    EXPECT_FALSE(PseudoCEmitter::looksLikeStructBaseIdentifier("rsp"));
    EXPECT_FALSE(PseudoCEmitter::looksLikeStructBaseIdentifier("very_long_name"));
}

TEST(PseudoCEmitterHeuristicsTest, DetectsCalleeSavedRegisters) {
    EXPECT_TRUE(PseudoCEmitter::isCalleeSavedRegisterName("rsi"));
    EXPECT_TRUE(PseudoCEmitter::isCalleeSavedRegisterName("R14"));
    EXPECT_TRUE(PseudoCEmitter::isCalleeSavedRegisterName("rbx"));
    EXPECT_FALSE(PseudoCEmitter::isCalleeSavedRegisterName("rax"));
    EXPECT_FALSE(PseudoCEmitter::isCalleeSavedRegisterName("r10"));
}

TEST(CAstPrinterTest, PrintsIncrementCompoundWithoutRhs) {
    using namespace helix::cast;

    CFuncDecl func("inc_test", 0, CType::voidTy());
    auto value = std::make_unique<CBinaryExpr>(
        BinaryOp::Add, makeVar("v1"), makeInt(1), CType::int64());
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("v1"), std::move(value), "++"));

    CAstPrinter printer;
    std::string code = printer.print(func);

    EXPECT_NE(code.find("v1++;"), std::string::npos);
    EXPECT_EQ(code.find("v1 ++"), std::string::npos);
    EXPECT_EQ(code.find("v1 + 1"), std::string::npos);
}

TEST(CAstOptimizerTest, SynthesizesCompoundAssignWithReducedRhs) {
    using namespace helix::cast;

    CFuncDecl func("compound_test", 0, CType::voidTy());
    auto value = std::make_unique<CBinaryExpr>(
        BinaryOp::Add, makeVar("v5"), makeInt(208), CType::int64());
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("v5"), std::move(value)));

    CAstOptimizer optimizer;
    optimizer.synthesizeCompoundAssign(func);

    CAstPrinter printer;
    std::string code = printer.print(func);

    EXPECT_NE(code.find("v5 += 208;"), std::string::npos);
    EXPECT_EQ(code.find("v5 += v5 + 208"), std::string::npos);
}

TEST(CAstOptimizerTest, PreservesSemanticCalleeSavedRegisterCopy) {
    using namespace helix::cast;

    CFuncDecl func("callee_saved_copy_test", 0, CType::voidTy());
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("rbx"), makeVar("param_1")));
    func.body.push_back(std::make_unique<CExprStmt>(makeVar("rbx")));

    CAstOptimizer optimizer;
    optimizer.removePrologueEpilogue(func);

    ASSERT_EQ(func.body.size(), 2u);
    auto* assign = llvm::dyn_cast<CAssignStmt>(func.body.front().get());
    ASSERT_NE(assign, nullptr);
    auto* target = llvm::dyn_cast<CVarRefExpr>(assign->target.get());
    auto* value = llvm::dyn_cast<CVarRefExpr>(assign->value.get());
    ASSERT_NE(target, nullptr);
    ASSERT_NE(value, nullptr);
    EXPECT_EQ(target->varName, "rbx");
    EXPECT_EQ(value->varName, "param_1");
}

TEST(CAstOptimizerTest, RemovesOnlyDemonstrableFrameSetup) {
    using namespace helix::cast;

    CFuncDecl func("frame_setup_test", 0, CType::voidTy());
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("rbp"), makeVar("rsp")));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("rbx"), makeVar("param_1")));
    func.body.push_back(std::make_unique<CExprStmt>(makeVar("rbx")));

    CAstOptimizer optimizer;
    optimizer.removePrologueEpilogue(func);

    ASSERT_EQ(func.body.size(), 2u);
    auto* assign = llvm::dyn_cast<CAssignStmt>(func.body.front().get());
    ASSERT_NE(assign, nullptr);
    auto* target = llvm::dyn_cast<CVarRefExpr>(assign->target.get());
    ASSERT_NE(target, nullptr);
    EXPECT_EQ(target->varName, "rbx");
}

TEST(CAstOptimizerTest, TracksCanarySpillWithoutOwningReusedRegister) {
    using namespace helix::cast;

    CFuncDecl func("canary_register_reuse_test", 0, CType::voidTy());
    func.localVars.emplace_back(
        1, "rbx", CType::int64(), StorageKind::Register);
    func.localVars.emplace_back(
        2, "var_30", CType::int64(), StorageKind::Stack);

    std::vector<ExprPtr> canaryArgs;
    canaryArgs.push_back(makeInt(40));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("rbx"),
        std::make_unique<CCallExpr>(
            "__readgsqword", 0, std::move(canaryArgs), CType::int64())));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("var_30"), makeVar("rbx")));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("rbx"), makeVar("param_1")));

    std::vector<StmtPtr> semanticBody;
    semanticBody.push_back(std::make_unique<CExprStmt>(
        std::make_unique<CFieldAccessExpr>(
            makeVar("rbx"), "field_0x8", 8, true, CType::int64())));
    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("rbx"), std::move(semanticBody)));

    CAstOptimizer optimizer;
    optimizer.recognizeStackCanary(func);

    ASSERT_EQ(func.body.size(), 2u);
    auto* assign = llvm::dyn_cast<CAssignStmt>(func.body.front().get());
    ASSERT_NE(assign, nullptr);
    auto* target = llvm::dyn_cast<CVarRefExpr>(assign->target.get());
    auto* value = llvm::dyn_cast<CVarRefExpr>(assign->value.get());
    ASSERT_NE(target, nullptr);
    ASSERT_NE(value, nullptr);
    EXPECT_EQ(target->varName, "rbx");
    EXPECT_EQ(value->varName, "param_1");
    EXPECT_EQ(func.body.back()->getKind(), NodeKind::IfStmt);
    EXPECT_TRUE(std::any_of(
        func.localVars.begin(), func.localVars.end(),
        [](const CVarDecl& decl) { return decl.varName == "rbx"; }));
    EXPECT_TRUE(std::none_of(
        func.localVars.begin(), func.localVars.end(),
        [](const CVarDecl& decl) { return decl.varName == "var_30"; }));
}

TEST(CAstOptimizerTest, RemovesAssignedStackCanaryFailureCall) {
    using namespace helix::cast;

    CFuncDecl func("assigned_canary_failure_test", 0, CType::voidTy());
    func.localVars.emplace_back(
        1, "var_30", CType::int64(), StorageKind::Stack);

    std::vector<ExprPtr> canaryArgs;
    canaryArgs.push_back(makeInt(40));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("var_30"),
        std::make_unique<CCallExpr>(
            "__readgsqword", 0, std::move(canaryArgs), CType::int64())));

    std::vector<StmtPtr> failureBody;
    failureBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("result"),
        std::make_unique<CCallExpr>(
            "__stack_chk_fail", 0, std::vector<ExprPtr>{},
            CType::int64())));
    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("canary_mismatch"), std::move(failureBody)));

    CAstOptimizer optimizer;
    optimizer.recognizeStackCanary(func);

    EXPECT_TRUE(func.body.empty());
}

TEST(CAstOptimizerTest, PreservesNormalElseArmOfStackCanaryCheck) {
    using namespace helix::cast;

    CFuncDecl func("scf_canary_polarity_test", 0, CType::voidTy());
    func.localVars.emplace_back(
        1, "var_30", CType::int64(), StorageKind::Stack);
    func.localVars.emplace_back(
        2, "scf_state", CType::int32(), StorageKind::Temporary);
    func.localVars.emplace_back(
        3, "scf_continue", CType::boolTy(), StorageKind::Temporary);

    std::vector<ExprPtr> canaryArgs;
    canaryArgs.push_back(makeInt(40));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("var_30"),
        std::make_unique<CCallExpr>(
            "__readgsqword", 0, std::move(canaryArgs), CType::int64())));

    std::vector<StmtPtr> failureBody;
    failureBody.push_back(std::make_unique<CExprStmt>(
        std::make_unique<CCallExpr>(
            "__stack_chk_fail", 0, std::vector<ExprPtr>{},
            CType::voidTy())));
    failureBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_state"), makeInt(5)));
    failureBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_continue"), makeInt(1)));

    std::vector<StmtPtr> normalBody;
    normalBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_state"), makeInt(0)));
    normalBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_continue"), makeInt(0)));

    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("var_30"), std::move(failureBody), std::move(normalBody)));

    CAstOptimizer optimizer;
    optimizer.recognizeStackCanary(func);

    ASSERT_EQ(func.body.size(), 2u);
    for (const auto& stmt : func.body)
        ASSERT_NE(llvm::dyn_cast<CAssignStmt>(stmt.get()), nullptr);

    const auto* stateAssign =
        llvm::dyn_cast<CAssignStmt>(func.body[0].get());
    const auto* continueAssign =
        llvm::dyn_cast<CAssignStmt>(func.body[1].get());
    ASSERT_NE(stateAssign, nullptr);
    ASSERT_NE(continueAssign, nullptr);
    const auto* stateValue =
        llvm::dyn_cast<CIntLitExpr>(stateAssign->value.get());
    const auto* continueValue =
        llvm::dyn_cast<CIntLitExpr>(continueAssign->value.get());
    ASSERT_NE(stateValue, nullptr);
    ASSERT_NE(continueValue, nullptr);
    EXPECT_EQ(stateValue->value, 0);
    EXPECT_EQ(continueValue->value, 0);
}

TEST(CAstOptimizerTest, PreservesNestedSCFCanaryTerminationTuple) {
    using namespace helix::cast;

    CFuncDecl func("nested_scf_canary_test", 0, CType::voidTy());
    func.localVars.emplace_back(
        1, "scf_state", CType::int32(), StorageKind::Temporary);
    func.localVars.emplace_back(
        2, "scf_continue", CType::boolTy(), StorageKind::Temporary);

    std::vector<StmtPtr> failureBody;
    failureBody.push_back(std::make_unique<CExprStmt>(
        std::make_unique<CCallExpr>(
            "__stack_chk_fail", 0, std::vector<ExprPtr>{},
            CType::voidTy())));
    failureBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_state"), makeInt(5)));
    failureBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_continue"), makeInt(1)));

    std::vector<StmtPtr> normalBody;
    normalBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_state"), makeInt(0)));
    normalBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_continue"), makeInt(0)));

    std::vector<StmtPtr> loopBody;
    loopBody.push_back(std::make_unique<CIfStmt>(
        std::make_unique<CBinaryExpr>(
            BinaryOp::BitXor, makeInt(0), makeInt(-1), CType::int64()),
        std::move(failureBody), std::move(normalBody)));
    func.body.push_back(std::make_unique<CDoWhileStmt>(
        std::move(loopBody), makeVar("scf_continue")));

    CAstOptimizer optimizer;
    optimizer.recognizeStackCanary(func);

    ASSERT_EQ(func.body.size(), 1u);
    const auto* loop = llvm::dyn_cast<CDoWhileStmt>(func.body[0].get());
    ASSERT_NE(loop, nullptr);
    ASSERT_EQ(loop->body.size(), 2u);
    const auto* stateAssign =
        llvm::dyn_cast<CAssignStmt>(loop->body[0].get());
    const auto* continueAssign =
        llvm::dyn_cast<CAssignStmt>(loop->body[1].get());
    ASSERT_NE(stateAssign, nullptr);
    ASSERT_NE(continueAssign, nullptr);
    const auto* stateValue =
        llvm::dyn_cast<CIntLitExpr>(stateAssign->value.get());
    const auto* continueValue =
        llvm::dyn_cast<CIntLitExpr>(continueAssign->value.get());
    ASSERT_NE(stateValue, nullptr);
    ASSERT_NE(continueValue, nullptr);
    EXPECT_EQ(stateValue->value, 0);
    EXPECT_EQ(continueValue->value, 0);
}

TEST(CAstOptimizerTest, KeepsDefinitionReadOnlyInDeepStructuredScope) {
    using namespace helix::cast;

    CFuncDecl func("deep_liveness_test", 0, CType::voidTy());
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("rbx"), makeVar("param_1")));

    std::vector<StmtPtr> innerBody;
    innerBody.push_back(std::make_unique<CExprStmt>(
        std::make_unique<CFieldAccessExpr>(
            makeVar("rbx"), "field_0x8", 8, true, CType::int64())));
    std::vector<StmtPtr> outerBody;
    outerBody.push_back(std::make_unique<CIfStmt>(
        makeVar("inner_condition"), std::move(innerBody)));
    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("outer_condition"), std::move(outerBody)));

    CAstOptimizer optimizer;
    optimizer.eliminateDeadStores(func);

    ASSERT_EQ(func.body.size(), 2u);
    auto* assign = llvm::dyn_cast<CAssignStmt>(func.body.front().get());
    ASSERT_NE(assign, nullptr);
    auto* target = llvm::dyn_cast<CVarRefExpr>(assign->target.get());
    ASSERT_NE(target, nullptr);
    EXPECT_EQ(target->varName, "rbx");
}

TEST(CAstOptimizerTest, DropsDefinitionKilledOnEveryStructuredPath) {
    using namespace helix::cast;

    CFuncDecl func("structured_kill_test", 0, CType::voidTy());
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("value"), makeVar("stale")));

    std::vector<StmtPtr> thenBody;
    thenBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("value"), makeVar("then_value")));
    thenBody.push_back(
        std::make_unique<CExprStmt>(makeVar("value")));

    std::vector<StmtPtr> elseBody;
    elseBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("value"), makeVar("else_value")));
    elseBody.push_back(
        std::make_unique<CExprStmt>(makeVar("value")));

    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("condition"), std::move(thenBody), std::move(elseBody)));

    CAstOptimizer optimizer;
    optimizer.eliminateDeadStores(func);

    ASSERT_EQ(func.body.size(), 1u);
    EXPECT_NE(llvm::dyn_cast<CIfStmt>(func.body.front().get()), nullptr);
}

TEST(CAstOptimizerTest, DoesNotPropagateAddressableStackLocal) {
    using namespace helix::cast;

    CFuncDecl func("stack_alias_test", 0, CType::voidTy());
    func.localVars.emplace_back(
        1, "var_40", CType::int64(), StorageKind::Stack);
    func.localVars.back().stackOffset = -64;
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("var_40"), makeInt(0)));

    std::vector<ExprPtr> args;
    args.push_back(makeVar("var_40"));
    func.body.push_back(std::make_unique<CExprStmt>(
        std::make_unique<CCallExpr>(
            "kfree", 0, std::move(args), CType::voidTy())));

    CAstOptimizer optimizer;
    optimizer.propagateCopies(func);

    CAstPrinter printer;
    const std::string code = printer.print(func);
    EXPECT_NE(code.find("var_40 = 0;"), std::string::npos);
    EXPECT_NE(code.find("kfree(var_40);"), std::string::npos);
    EXPECT_EQ(code.find("kfree(0);"), std::string::npos);
}

TEST(CAstOptimizerTest, DecomposesRemillDoOpcodeWrapper) {
    using namespace helix::cast;

    CFuncDecl func("native_wrapper_test", 0, CType::voidTy());
    std::vector<ExprPtr> args;
    args.push_back(makeInt(3));
    func.body.push_back(std::make_unique<CExprStmt>(
        std::make_unique<CCallExpr>(
            "DoINT_IMMb", 0, std::move(args), CType::int64())));

    CAstOptimizer optimizer;
    optimizer.decomposeNativeOpcodes(func);

    CAstPrinter printer;
    std::string code = printer.print(func);
    EXPECT_NE(code.find("software_interrupt(3);"), std::string::npos);
    EXPECT_EQ(code.find("DoINT_IMMb"), std::string::npos);
}

TEST(CAstOptimizerTest, DoesNotInventFieldOnIndexedAddress) {
    using namespace helix::cast;

    CFuncDecl func("indexed_global_test", 0, CType::voidTy());
    auto scaledIndex = std::make_unique<CBinaryExpr>(
        BinaryOp::Shl, makeVar("index"), makeInt(3), CType::int64());
    auto indexedBase = std::make_unique<CBinaryExpr>(
        BinaryOp::Add, makeVar("image_base"), std::move(scaledIndex),
        CType::int64());
    auto address = std::make_unique<CBinaryExpr>(
        BinaryOp::Add, std::move(indexedBase), makeInt(0x18b30),
        CType::int64());
    func.body.push_back(std::make_unique<CExprStmt>(
        std::make_unique<CUnaryExpr>(
            UnaryOp::Deref, std::move(address), CType::int64())));

    CAstOptimizer optimizer;
    optimizer.recoverStructFieldAccess(func);

    auto* stmt = llvm::cast<CExprStmt>(func.body.front().get());
    auto* deref = llvm::cast<CUnaryExpr>(stmt->expr.get());
    auto* add = llvm::cast<CBinaryExpr>(deref->operand.get());
    auto* offset = llvm::cast<CIntLitExpr>(add->rhs.get());
    EXPECT_EQ(offset->value, 0x18b30);

    CAstPrinter printer;
    std::string code = printer.print(func);
    EXPECT_EQ(code.find("field_0x18b30"), std::string::npos);
}

TEST(CAstOptimizerTest, RecoversFieldOnDirectPointerBase) {
    using namespace helix::cast;

    CFuncDecl func("direct_field_test", 0, CType::voidTy());
    auto pointer = std::make_unique<CVarRefExpr>(
        1, "ptr", CType::voidPtr());
    auto address = std::make_unique<CBinaryExpr>(
        BinaryOp::Add, std::move(pointer), makeInt(0x70), CType::int64());
    func.body.push_back(std::make_unique<CExprStmt>(
        std::make_unique<CUnaryExpr>(
            UnaryOp::Deref, std::move(address), CType::int64())));

    CAstOptimizer optimizer;
    optimizer.recoverStructFieldAccess(func);

    CAstPrinter printer;
    std::string code = printer.print(func);
    EXPECT_NE(code.find("ptr->field_0x70"), std::string::npos);
}

TEST(CAstOptimizerTest, DoesNotInventFieldForNegativeDisplacement) {
    using namespace helix::cast;

    CFuncDecl func("negative_displacement_test", 0, CType::voidTy());
    auto pointer = std::make_unique<CVarRefExpr>(
        1, "ptr", CType::voidPtr());
    auto address = std::make_unique<CBinaryExpr>(
        BinaryOp::Add, std::move(pointer), makeInt(-80), CType::int64());
    func.body.push_back(std::make_unique<CExprStmt>(
        std::make_unique<CUnaryExpr>(
            UnaryOp::Deref, std::move(address), CType::int64())));

    CAstOptimizer optimizer;
    optimizer.recoverStructFieldAccess(func);

    auto* stmt = llvm::cast<CExprStmt>(func.body.front().get());
    auto* deref = llvm::cast<CUnaryExpr>(stmt->expr.get());
    auto* add = llvm::cast<CBinaryExpr>(deref->operand.get());
    auto* offset = llvm::cast<CIntLitExpr>(add->rhs.get());
    EXPECT_EQ(offset->value, -80);

    CAstPrinter printer;
    std::string code = printer.print(func);
    EXPECT_EQ(code.find("field_0x"), std::string::npos);
}

TEST(CAstOptimizerTest, CapsConditionallyAssignedReturnValue) {
    using namespace helix::cast;

    CFuncDecl func("conditional_return_test", 0x1000, CType::int64());
    func.localVars.emplace_back(
        1, "result", CType::int64(), StorageKind::Temporary);

    std::vector<StmtPtr> thenBody;
    thenBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("result"), makeInt(7)));
    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("condition"), std::move(thenBody)));
    func.body.push_back(std::make_unique<CReturnStmt>(makeVar("result")));

    CAstOptimizer optimizer;
    optimizer.reanalyzeConfidence(func);

    EXPECT_LE(func.confidenceScore, 50.0);
    EXPECT_TRUE(std::any_of(
        func.confidenceIssues.begin(), func.confidenceIssues.end(),
        [](const std::string& issue) {
            return issue.find("uninitialized return value 'result'") !=
                   std::string::npos;
        }));
}

TEST(CAstOptimizerTest, KeepsReturnAssignedInBothBranchesUncapped) {
    using namespace helix::cast;

    CFuncDecl func("complete_return_test", 0x1000, CType::int64());
    func.localVars.emplace_back(
        1, "result", CType::int64(), StorageKind::Temporary);

    std::vector<StmtPtr> thenBody;
    thenBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("result"), makeInt(7)));
    std::vector<StmtPtr> elseBody;
    elseBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("result"), makeInt(9)));
    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("condition"), std::move(thenBody), std::move(elseBody)));
    func.body.push_back(std::make_unique<CReturnStmt>(makeVar("result")));

    CAstOptimizer optimizer;
    optimizer.reanalyzeConfidence(func);

    EXPECT_GT(func.confidenceScore, 50.0);
    EXPECT_TRUE(std::none_of(
        func.confidenceIssues.begin(), func.confidenceIssues.end(),
        [](const std::string& issue) {
            return issue.find("uninitialized return value") !=
                   std::string::npos;
        }));
}

TEST(CAstOptimizerTest, KeepsAddressInitializedReturnUncapped) {
    using namespace helix::cast;

    CFuncDecl func("address_initialized_return_test", 0x1000, CType::int64());
    func.localVars.emplace_back(
        1, "result", CType::int64(), StorageKind::Temporary);

    std::vector<ExprPtr> args;
    args.push_back(std::make_unique<CUnaryExpr>(
        UnaryOp::AddressOf, makeVar("result"),
        CType::pointerTo(CType::int64())));
    func.body.push_back(std::make_unique<CExprStmt>(
        std::make_unique<CCallExpr>(
            "fill_result", 0, std::move(args), CType::voidTy())));
    func.body.push_back(std::make_unique<CReturnStmt>(makeVar("result")));

    CAstOptimizer optimizer;
    optimizer.reanalyzeConfidence(func);

    EXPECT_GT(func.confidenceScore, 50.0);
    EXPECT_TRUE(std::none_of(
        func.confidenceIssues.begin(), func.confidenceIssues.end(),
        [](const std::string& issue) {
            return issue.find("uninitialized return value") !=
                   std::string::npos;
        }));
}

TEST(CAstOptimizerTest, RemovesBranchesEmptiedByGlobalDeadStoreSweep) {
    using namespace helix::cast;

    CFuncDecl func("late_empty_branch_test", 0, CType::voidTy());
    func.localVars.emplace_back(
        1, "dead_value", CType::int64(), StorageKind::Temporary);

    std::vector<StmtPtr> innerBody;
    innerBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("dead_value"), makeInt(1)));
    std::vector<StmtPtr> outerBody;
    outerBody.push_back(std::make_unique<CIfStmt>(
        makeVar("inner_condition"), std::move(innerBody)));
    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("outer_condition"), std::move(outerBody)));

    CAstOptimizer optimizer;
    optimizer.optimize(func);

    CAstPrinter printer;
    const std::string code = printer.print(func);
    EXPECT_EQ(code.find("if ("), std::string::npos);
    EXPECT_EQ(code.find("dead_value"), std::string::npos);
}

TEST(CAstOptimizerTest, FoldsIdenticalNestedSCFTupleArms) {
    using namespace helix::cast;

    CFuncDecl func("identical_scf_tuple_test", 0, CType::voidTy());

    auto makeTuple = [] {
        std::vector<StmtPtr> body;
        body.push_back(std::make_unique<CAssignStmt>(
            makeVar("scf_r900001"), makeInt(2)));
        body.push_back(std::make_unique<CAssignStmt>(
            makeVar("scf_r900002"), makeInt(0)));
        return body;
    };

    std::vector<StmtPtr> finalElse;
    finalElse.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(0)));
    finalElse.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900002"), makeInt(1)));

    std::vector<StmtPtr> outerElse;
    outerElse.push_back(std::make_unique<CIfStmt>(
        makeVar("second_condition"), makeTuple(), std::move(finalElse)));
    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("first_condition"), makeTuple(), std::move(outerElse)));

    CAstOptimizer optimizer;
    optimizer.foldIdenticalNestedSCFArms(func);

    ASSERT_EQ(func.body.size(), 1u);
    const auto* folded = llvm::dyn_cast<CIfStmt>(func.body.front().get());
    ASSERT_NE(folded, nullptr);
    ASSERT_EQ(folded->thenBody.size(), 2u);
    ASSERT_EQ(folded->elseBody.size(), 2u);
    const auto* condition =
        llvm::dyn_cast<CBinaryExpr>(folded->condition.get());
    ASSERT_NE(condition, nullptr);
    EXPECT_EQ(condition->op, BinaryOp::LogOr);
    const auto* lhs = llvm::dyn_cast<CVarRefExpr>(condition->lhs.get());
    const auto* rhs = llvm::dyn_cast<CVarRefExpr>(condition->rhs.get());
    ASSERT_NE(lhs, nullptr);
    ASSERT_NE(rhs, nullptr);
    EXPECT_EQ(lhs->varName, "first_condition");
    EXPECT_EQ(rhs->varName, "second_condition");
}

TEST(CAstOptimizerTest, KeepsDifferentNestedSCFTupleArmsSeparate) {
    using namespace helix::cast;

    CFuncDecl func("different_scf_tuple_test", 0, CType::voidTy());

    std::vector<StmtPtr> outerThen;
    outerThen.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(2)));
    std::vector<StmtPtr> nestedThen;
    nestedThen.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(3)));
    std::vector<StmtPtr> nestedElse;
    nestedElse.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(0)));

    std::vector<StmtPtr> outerElse;
    outerElse.push_back(std::make_unique<CIfStmt>(
        makeVar("second_condition"), std::move(nestedThen),
        std::move(nestedElse)));
    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("first_condition"), std::move(outerThen),
        std::move(outerElse)));

    CAstOptimizer optimizer;
    optimizer.foldIdenticalNestedSCFArms(func);

    const auto* outer = llvm::dyn_cast<CIfStmt>(func.body.front().get());
    ASSERT_NE(outer, nullptr);
    EXPECT_EQ(outer->condition->getKind(), NodeKind::VarRefExpr);
    ASSERT_EQ(outer->elseBody.size(), 1u);
    EXPECT_NE(llvm::dyn_cast<CIfStmt>(outer->elseBody.front().get()), nullptr);
}

TEST(CAstOptimizerTest, FoldsSCFTupleArmsExposedByLateDeadStoreSweep) {
    using namespace helix::cast;

    CFuncDecl func("late_identical_scf_tuple_test", 0, CType::voidTy());
    func.localVars.emplace_back(
        1, "dead_value", CType::int64(), StorageKind::Temporary);
    func.localVars.emplace_back(
        2, "scf_r900001", CType::int64(), StorageKind::Temporary);

    std::vector<StmtPtr> outerThen;
    outerThen.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(2)));

    std::vector<StmtPtr> nestedThen;
    nestedThen.push_back(std::make_unique<CAssignStmt>(
        makeVar("dead_value"), makeInt(99)));
    nestedThen.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(2)));

    std::vector<StmtPtr> nestedElse;
    nestedElse.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(0)));

    std::vector<StmtPtr> outerElse;
    outerElse.push_back(std::make_unique<CIfStmt>(
        makeVar("second_condition"), std::move(nestedThen),
        std::move(nestedElse)));
    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("first_condition"), std::move(outerThen),
        std::move(outerElse)));
    func.body.push_back(
        std::make_unique<CExprStmt>(makeVar("scf_r900001")));

    CAstOptimizer optimizer;
    optimizer.optimize(func);

    const auto* folded = llvm::dyn_cast<CIfStmt>(func.body.front().get());
    ASSERT_NE(folded, nullptr);
    const auto* condition =
        llvm::dyn_cast<CBinaryExpr>(folded->condition.get());
    ASSERT_NE(condition, nullptr);
    EXPECT_EQ(condition->op, BinaryOp::LogOr);
    EXPECT_TRUE(std::none_of(
        func.localVars.begin(), func.localVars.end(),
        [](const CVarDecl& decl) { return decl.varName == "dead_value"; }));
}

TEST(CAstOptimizerTest, KeepsIndependentlyReadSCFSourceOutOfCopyClass) {
    using namespace helix::cast;

    CFuncDecl func("live_scf_copy_source", 0, CType::int64());
    func.localVars.emplace_back(
        1, "scf_r900001", CType::int64(), StorageKind::Temporary);
    func.localVars.emplace_back(
        2, "scf_r900002", CType::int64(), StorageKind::Temporary);
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(10)));

    std::vector<StmtPtr> thenBody;
    thenBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900002"), makeVar("scf_r900001")));
    std::vector<StmtPtr> elseBody;
    elseBody.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900002"), makeInt(20)));
    func.body.push_back(std::make_unique<CIfStmt>(
        makeVar("condition"), std::move(thenBody), std::move(elseBody)));
    func.body.push_back(std::make_unique<CReturnStmt>(
        std::make_unique<CBinaryExpr>(
            BinaryOp::Add, makeVar("scf_r900001"),
            makeVar("scf_r900002"), CType::int64())));

    CAstOptimizer optimizer;
    optimizer.coalesceSelectorChains(func);

    ASSERT_EQ(func.localVars.size(), 2u);
    const auto* ret = llvm::dyn_cast<CReturnStmt>(func.body.back().get());
    ASSERT_NE(ret, nullptr);
    const auto* sum = llvm::dyn_cast<CBinaryExpr>(ret->value.get());
    ASSERT_NE(sum, nullptr);
    const auto* lhs = llvm::dyn_cast<CVarRefExpr>(sum->lhs.get());
    const auto* rhs = llvm::dyn_cast<CVarRefExpr>(sum->rhs.get());
    ASSERT_NE(lhs, nullptr);
    ASSERT_NE(rhs, nullptr);
    EXPECT_EQ(lhs->varName, "scf_r900001");
    EXPECT_EQ(rhs->varName, "scf_r900002");
}

TEST(CAstOptimizerTest, CoalescesSingleConsumerSCFRoutingCopy) {
    using namespace helix::cast;

    CFuncDecl func("single_consumer_scf_copy", 0, CType::int64());
    func.localVars.emplace_back(
        1, "scf_r900001", CType::int64(), StorageKind::Temporary);
    func.localVars.emplace_back(
        2, "scf_r900002", CType::int64(), StorageKind::Temporary);
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(10)));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900002"), makeVar("scf_r900001")));
    func.body.push_back(std::make_unique<CReturnStmt>(
        makeVar("scf_r900002")));

    CAstOptimizer optimizer;
    optimizer.coalesceSelectorChains(func);

    ASSERT_EQ(func.localVars.size(), 1u);
    const auto* ret = llvm::dyn_cast<CReturnStmt>(func.body.back().get());
    ASSERT_NE(ret, nullptr);
    const auto* value = llvm::dyn_cast<CVarRefExpr>(ret->value.get());
    ASSERT_NE(value, nullptr);
    EXPECT_EQ(value->varName, "scf_r900001");
}

TEST(CAstOptimizerTest, KeepsCopySourceThatIsRedefinedWhileDestinationLives) {
    using namespace helix::cast;

    CFuncDecl func("redefined_scf_copy_source", 0, CType::int64());
    func.localVars.emplace_back(
        1, "scf_r900001", CType::int64(), StorageKind::Temporary);
    func.localVars.emplace_back(
        2, "scf_r900002", CType::int64(), StorageKind::Temporary);
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(10)));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900002"), makeVar("scf_r900001")));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(20)));
    func.body.push_back(std::make_unique<CReturnStmt>(
        makeVar("scf_r900002")));

    CAstOptimizer optimizer;
    optimizer.coalesceSelectorChains(func);

    EXPECT_EQ(func.localVars.size(), 2u);
    const auto* ret = llvm::dyn_cast<CReturnStmt>(func.body.back().get());
    ASSERT_NE(ret, nullptr);
    const auto* value = llvm::dyn_cast<CVarRefExpr>(ret->value.get());
    ASSERT_NE(value, nullptr);
    EXPECT_EQ(value->varName, "scf_r900002");
}

TEST(CAstOptimizerTest, KeepsDestinationThatIsLiveBeforeRoutingCopy) {
    using namespace helix::cast;

    CFuncDecl func("live_scf_copy_destination", 0, CType::int64());
    func.localVars.emplace_back(
        1, "scf_r900001", CType::int64(), StorageKind::Temporary);
    func.localVars.emplace_back(
        2, "scf_r900002", CType::int64(), StorageKind::Temporary);
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(10)));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900002"), makeInt(20)));
    func.body.push_back(std::make_unique<CExprStmt>(
        makeVar("scf_r900002")));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900002"), makeVar("scf_r900001")));
    func.body.push_back(std::make_unique<CReturnStmt>(
        makeVar("scf_r900002")));

    CAstOptimizer optimizer;
    optimizer.coalesceSelectorChains(func);

    EXPECT_EQ(func.localVars.size(), 2u);
    const auto* beforeCopy = llvm::dyn_cast<CExprStmt>(func.body[2].get());
    ASSERT_NE(beforeCopy, nullptr);
    const auto* value = llvm::dyn_cast<CVarRefExpr>(beforeCopy->expr.get());
    ASSERT_NE(value, nullptr);
    EXPECT_EQ(value->varName, "scf_r900002");
}

TEST(CAstOptimizerTest, RejectsTransitivelyInterferingSCFCopyClass) {
    using namespace helix::cast;

    CFuncDecl func("transitive_scf_copy_interference", 0, CType::int64());
    func.localVars.emplace_back(
        1, "scf_r900001", CType::int64(), StorageKind::Temporary);
    func.localVars.emplace_back(
        2, "scf_r900002", CType::int64(), StorageKind::Temporary);
    func.localVars.emplace_back(
        3, "scf_r900003", CType::int64(), StorageKind::Temporary);
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(10)));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900002"), makeVar("scf_r900001")));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900003"), makeVar("scf_r900002")));
    func.body.push_back(std::make_unique<CReturnStmt>(
        std::make_unique<CBinaryExpr>(
            BinaryOp::Add, makeVar("scf_r900001"),
            makeVar("scf_r900003"), CType::int64())));

    CAstOptimizer optimizer;
    optimizer.coalesceSelectorChains(func);

    ASSERT_EQ(func.localVars.size(), 2u);
    const auto* ret = llvm::dyn_cast<CReturnStmt>(func.body.back().get());
    ASSERT_NE(ret, nullptr);
    const auto* sum = llvm::dyn_cast<CBinaryExpr>(ret->value.get());
    ASSERT_NE(sum, nullptr);
    const auto* lhs = llvm::dyn_cast<CVarRefExpr>(sum->lhs.get());
    const auto* rhs = llvm::dyn_cast<CVarRefExpr>(sum->rhs.get());
    ASSERT_NE(lhs, nullptr);
    ASSERT_NE(rhs, nullptr);
    EXPECT_NE(lhs->varName, rhs->varName);
}

TEST(CAstOptimizerTest, RemovesTransitivelyDeadCopyChainToFixedPoint) {
    using namespace helix::cast;

    CFuncDecl func("dead_copy_fixed_point", 0, CType::voidTy());
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900001"), makeInt(10)));
    func.body.push_back(std::make_unique<CAssignStmt>(
        makeVar("scf_r900002"), makeVar("scf_r900001")));

    CAstOptimizer optimizer;
    optimizer.removeGloballyDeadStores(func);

    EXPECT_TRUE(func.body.empty());
}
