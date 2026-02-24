/// @file EmitterTest.cpp
/// @brief Unit tests for the FlatBuffer serializer verification.

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
