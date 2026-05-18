/// @file EmitterTest.cpp
/// @brief Unit tests for the FlatBuffer serializer verification.

#include "helix/emit/PseudoCEmitter.h"
#include "helix/emit/FlatBufSerializer.h"
#include "helix/cast/CAstOptimizer.h"
#include "helix/cast/CAstPrinter.h"
#include "helix/cast/CDecl.h"
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
