/// @file EmitterTest.cpp
/// @brief Unit tests for the FlatBuffer serializer verification.

#include "helix/emit/PseudoCEmitter.h"
#include "helix/emit/FlatBufSerializer.h"
#include <gtest/gtest.h>
#include <vector>
#include <cstdint>

using namespace helix;

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
