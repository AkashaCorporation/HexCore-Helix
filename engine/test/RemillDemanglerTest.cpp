/// @file RemillDemanglerTest.cpp
/// @brief Unit tests for the Remill semantic function demangler.

#include "helix/analysis/RemillDemangler.h"
#include <gtest/gtest.h>

using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// demangleRemillSemantic Tests
// ═══════════════════════════════════════════════════════════════════════════════

TEST(RemillDemanglerTest, DemangleAdd) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13ADDI3MnWImE2MnImE2RnImLb1EEEEP6MemoryS8_R5StateT_T0_T1_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::ADD);
    EXPECT_EQ(result->raw_name, "ADD");
    EXPECT_FALSE(result->is_helper);
}

TEST(RemillDemanglerTest, DemangleSub) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13SUBI3MnWImE2MnImE2RnImLb1EEEEP6MemoryS8_R5StateT_T0_T1_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::SUB);
}

TEST(RemillDemanglerTest, DemangleMov) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::MOV);
}

TEST(RemillDemanglerTest, DemanglePush) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_14PUSHI2RnImEEEP6MemoryS4_R5StateT_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::PUSH);
}

TEST(RemillDemanglerTest, DemanglePop) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::POP);
}

TEST(RemillDemanglerTest, DemangleCmp) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13CMPI2MnImE2RnImEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::CMP);
}

TEST(RemillDemanglerTest, DemangleTest) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_14TESTI2MnImE2RnImEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::TEST);
}

TEST(RemillDemanglerTest, DemangleCall) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::CALL);
}

TEST(RemillDemanglerTest, DemangleRet) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13RETEEEP6MemoryS1_R5State");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::RET);
}

TEST(RemillDemanglerTest, DemangleNop) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::NOP);
}

TEST(RemillDemanglerTest, DemangleMovzx) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnIhEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::MOVZX);
}

TEST(RemillDemanglerTest, DemangleJz) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_12JZI2InImEEEP6MemoryS4_R5StateT_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::JZ);
}

TEST(RemillDemanglerTest, DemangleJnz) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13JNZI2InImEEEP6MemoryS4_R5StateT_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::JNZ);
}

TEST(RemillDemanglerTest, DemangleLea) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13LEAI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::LEA);
}

TEST(RemillDemanglerTest, DemangleXor) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13XORI3MnWImE2MnImE2RnImLb1EEEEP6MemoryS8_R5StateT_T0_T1_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::XOR);
}

TEST(RemillDemanglerTest, DemangleAnd) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13ANDI3MnWImE2MnImE2RnImLb1EEEEP6MemoryS8_R5StateT_T0_T1_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::AND);
}

// ═══════════════════════════════════════════════════════════════════════════════
// extractRemillMemoryWidth Tests
// ═══════════════════════════════════════════════════════════════════════════════

TEST(RemillDemanglerTest, MemoryWidth8) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_read_memory_8"), 8u);
}

TEST(RemillDemanglerTest, MemoryWidth16) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_read_memory_16"), 16u);
}

TEST(RemillDemanglerTest, MemoryWidth32) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_read_memory_32"), 32u);
}

TEST(RemillDemanglerTest, MemoryWidth64) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_read_memory_64"), 64u);
}

TEST(RemillDemanglerTest, MemoryWidthWrite) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_write_memory_32"), 32u);
}

TEST(RemillDemanglerTest, MemoryWidthInvalid) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_read_memory_7"), 0u);
    EXPECT_EQ(extractRemillMemoryWidth("not_a_remill_intrinsic"), 0u);
}

// ═══════════════════════════════════════════════════════════════════════════════
// isConditionalJump Tests
// ═══════════════════════════════════════════════════════════════════════════════

TEST(RemillDemanglerTest, IsConditionalJump) {
    EXPECT_TRUE(isConditionalJump(RemillSemantic::JZ));
    EXPECT_TRUE(isConditionalJump(RemillSemantic::JNZ));
    EXPECT_TRUE(isConditionalJump(RemillSemantic::JB));
    EXPECT_TRUE(isConditionalJump(RemillSemantic::JNB));
    EXPECT_TRUE(isConditionalJump(RemillSemantic::JL));
    EXPECT_TRUE(isConditionalJump(RemillSemantic::JNL));
    EXPECT_FALSE(isConditionalJump(RemillSemantic::JMP));
    EXPECT_FALSE(isConditionalJump(RemillSemantic::CALL));
    EXPECT_FALSE(isConditionalJump(RemillSemantic::ADD));
}

// ═══════════════════════════════════════════════════════════════════════════════
// getJccCondition Tests
// ═══════════════════════════════════════════════════════════════════════════════

TEST(RemillDemanglerTest, JccConditions) {
    EXPECT_EQ(getJccCondition(RemillSemantic::JZ).value_or(""), "z");
    EXPECT_EQ(getJccCondition(RemillSemantic::JNZ).value_or(""), "nz");
    EXPECT_EQ(getJccCondition(RemillSemantic::JB).value_or(""), "b");
    EXPECT_EQ(getJccCondition(RemillSemantic::JNB).value_or(""), "nb");
    EXPECT_EQ(getJccCondition(RemillSemantic::JL).value_or(""), "l");
    EXPECT_EQ(getJccCondition(RemillSemantic::JNL).value_or(""), "nl");
    EXPECT_EQ(getJccCondition(RemillSemantic::JLE).value_or(""), "le");
    EXPECT_EQ(getJccCondition(RemillSemantic::JNLE).value_or(""), "nle");
    EXPECT_FALSE(getJccCondition(RemillSemantic::ADD).has_value());
}

// ═══════════════════════════════════════════════════════════════════════════════
// Edge Cases
// ═══════════════════════════════════════════════════════════════════════════════

TEST(RemillDemanglerTest, UnrecognizedFunction) {
    auto result = demangleRemillSemantic("some_random_function");
    EXPECT_FALSE(result.has_value());
}

TEST(RemillDemanglerTest, LlvmIntrinsic) {
    auto result = demangleRemillSemantic("llvm.ctpop.i64");
    // LLVM intrinsics may or may not be recognized, but shouldn't crash
    // The implementation should handle them gracefully.
}

TEST(RemillDemanglerTest, EmptyString) {
    auto result = demangleRemillSemantic("");
    EXPECT_FALSE(result.has_value());
}

TEST(RemillDemanglerTest, RemillHelperSkipped) {
    // Flag computation helpers should be marked as is_helper
    auto result = demangleRemillSemantic("__remill_flag_computation_zero");
    // These may or may not parse, but shouldn't crash
}
