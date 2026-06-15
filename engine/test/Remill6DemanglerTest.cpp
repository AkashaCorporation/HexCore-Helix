/// @file Remill6DemanglerTest.cpp
/// @brief Comprehensive tests for RemillDemangler against ALL mangled symbols
///        found in the real Remill output file tests/remill-6/01-name-writing.ll.
///
/// Every `declare` statement from the .ll file is tested here to ensure the
/// demangler correctly handles every instruction variant and intrinsic that
/// Remill 6 actually emits.

#include "helix/analysis/RemillDemangler.h"
#include <gtest/gtest.h>

using namespace helix;

// =============================================================================
// Semantic function tests -- mangled names from declare statements
// =============================================================================

// ---------------------------------------------------------------------------
// 1. ADD (reg-reg-imm variant)
//    _ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, ADD_RegRegImm) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::ADD);
    EXPECT_EQ(result->raw_name, "ADD");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 2. SUB (reg-reg-imm variant)
//    _ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, SUB_RegRegImm) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::SUB);
    EXPECT_EQ(result->raw_name, "SUB");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 3. CMP (byte operands: Mn<h>, In<h>)
//    _ZN12_GLOBAL__N_13CMPI2MnIhE2InIhEEEP6MemoryS6_R5StateT_T0_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, CMP_Byte) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13CMPI2MnIhE2InIhEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::CMP);
    EXPECT_EQ(result->raw_name, "CMP");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 4. CMP (qword operands: Mn<m>, In<m>)
//    _ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, CMP_Qword) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::CMP);
    EXPECT_EQ(result->raw_name, "CMP");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 5. CALL (immediate operand)
//    _ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, CALL_Imm) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::CALL);
    EXPECT_EQ(result->raw_name, "CALL");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 6. CALL (memory operand)
//    _ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, CALL_Mem) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::CALL);
    EXPECT_EQ(result->raw_name, "CALL");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 7. RET (no template args, ends with E)
//    _ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, RET) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::RET);
    EXPECT_EQ(result->raw_name, "RET");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 8. JNZ (conditional jump, no template I-prefix, ends with E)
//    _ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, JNZ) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::JNZ);
    EXPECT_EQ(result->raw_name, "JNZ");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 9. JZ (conditional jump)
//    _ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, JZ) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::JZ);
    EXPECT_EQ(result->raw_name, "JZ");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 10. MOV (imm32 -> reg64: RnW<m>, In<j>)
//     _ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, MOV_Imm32ToReg64) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::MOV);
    EXPECT_EQ(result->raw_name, "MOV");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 11. MOV (imm8 -> reg8: RnW<h>, In<h>)
//     _ZN12_GLOBAL__N_13MOVI3RnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, MOV_Imm8ToReg8) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13MOVI3RnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::MOV);
    EXPECT_EQ(result->raw_name, "MOV");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 12. MOV (reg32 -> reg64: RnW<m>, Rn<j, true>)
//     _ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, MOV_Reg32ToReg64) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::MOV);
    EXPECT_EQ(result->raw_name, "MOV");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 13. MOV (reg64 -> reg64: RnW<m>, Rn<m, true>)
//     _ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, MOV_Reg64ToReg64) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::MOV);
    EXPECT_EQ(result->raw_name, "MOV");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 14. MOV (mem -> reg64: RnW<m>, Mn<m>)
//     _ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, MOV_MemToReg64) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::MOV);
    EXPECT_EQ(result->raw_name, "MOV");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 15. MOVZX (reg16 -> reg64: RnW<m>, Rn<t, true>)
//     _ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, MOVZX) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::MOVZX);
    EXPECT_EQ(result->raw_name, "MOVZX");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 16. INT3 (DoINT3 -- special non-templated name)
//     _ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, INT3_DoINT3) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::INT3);
    EXPECT_EQ(result->raw_name, "DoINT3");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 17. XOR (reg-reg-reg variant: RnW<m>, Rn<j, true>, same)
//     _ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, XOR_RegRegReg) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::XOR);
    EXPECT_EQ(result->raw_name, "XOR");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 18. TEST (reg-reg byte variant: Rn<h, true>, same)
//     _ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, TEST_RegReg) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::TEST);
    EXPECT_EQ(result->raw_name, "TEST");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 19. LEA (RnW<m>, Mn<h>, m -- address computation)
//     _ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, LEA) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::LEA);
    EXPECT_EQ(result->raw_name, "LEA");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 20. NOP (NOP_IMPL -- 8-char name with variadic template)
//     _ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, NOP_IMPL) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::NOP);
    EXPECT_EQ(result->raw_name, "NOP_IMPL");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 21. POP (RnW<m>)
//     _ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, POP) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::POP);
    EXPECT_EQ(result->raw_name, "POP");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 22. PUSH (In<m>)
//     _ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, PUSH) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::PUSH);
    EXPECT_EQ(result->raw_name, "PUSH");
    EXPECT_FALSE(result->is_helper);
}

// ---------------------------------------------------------------------------
// 23. JMP (In<m>)
//     _ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, JMP) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE");
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->semantic, RemillSemantic::JMP);
    EXPECT_EQ(result->raw_name, "JMP");
    EXPECT_FALSE(result->is_helper);
}

// =============================================================================
// Remill intrinsic / helper tests -- from the same .ll file
// =============================================================================

// ---------------------------------------------------------------------------
// __remill_read_memory_8
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, Intrinsic_ReadMemory8) {
    auto result = demangleRemillSemantic("__remill_read_memory_8");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(result->is_helper);
    EXPECT_EQ(result->raw_name, "__remill_read_memory_8");
    EXPECT_EQ(result->semantic, RemillSemantic::Unknown);
}

// ---------------------------------------------------------------------------
// __remill_read_memory_64
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, Intrinsic_ReadMemory64) {
    auto result = demangleRemillSemantic("__remill_read_memory_64");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(result->is_helper);
    EXPECT_EQ(result->raw_name, "__remill_read_memory_64");
    EXPECT_EQ(result->semantic, RemillSemantic::Unknown);
}

// ---------------------------------------------------------------------------
// __remill_write_memory_64
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, Intrinsic_WriteMemory64) {
    auto result = demangleRemillSemantic("__remill_write_memory_64");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(result->is_helper);
    EXPECT_EQ(result->raw_name, "__remill_write_memory_64");
    EXPECT_EQ(result->semantic, RemillSemantic::Unknown);
}

// ---------------------------------------------------------------------------
// __remill_flag_computation_carry
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, Intrinsic_FlagCarry) {
    auto result = demangleRemillSemantic("__remill_flag_computation_carry");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(result->is_helper);
    EXPECT_EQ(result->raw_name, "__remill_flag_computation_carry");
    EXPECT_EQ(result->semantic, RemillSemantic::Unknown);
}

// ---------------------------------------------------------------------------
// __remill_flag_computation_zero
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, Intrinsic_FlagZero) {
    auto result = demangleRemillSemantic("__remill_flag_computation_zero");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(result->is_helper);
    EXPECT_EQ(result->raw_name, "__remill_flag_computation_zero");
    EXPECT_EQ(result->semantic, RemillSemantic::Unknown);
}

// ---------------------------------------------------------------------------
// __remill_flag_computation_sign
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, Intrinsic_FlagSign) {
    auto result = demangleRemillSemantic("__remill_flag_computation_sign");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(result->is_helper);
    EXPECT_EQ(result->raw_name, "__remill_flag_computation_sign");
    EXPECT_EQ(result->semantic, RemillSemantic::Unknown);
}

// ---------------------------------------------------------------------------
// __remill_flag_computation_overflow
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, Intrinsic_FlagOverflow) {
    auto result = demangleRemillSemantic("__remill_flag_computation_overflow");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(result->is_helper);
    EXPECT_EQ(result->raw_name, "__remill_flag_computation_overflow");
    EXPECT_EQ(result->semantic, RemillSemantic::Unknown);
}

// ---------------------------------------------------------------------------
// __remill_undefined_8
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, Intrinsic_Undefined8) {
    auto result = demangleRemillSemantic("__remill_undefined_8");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(result->is_helper);
    EXPECT_EQ(result->raw_name, "__remill_undefined_8");
    EXPECT_EQ(result->semantic, RemillSemantic::Unknown);
}

// ---------------------------------------------------------------------------
// __remill_compare_neq
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, Intrinsic_CompareNeq) {
    auto result = demangleRemillSemantic("__remill_compare_neq");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(result->is_helper);
    EXPECT_EQ(result->raw_name, "__remill_compare_neq");
    EXPECT_EQ(result->semantic, RemillSemantic::Unknown);
}

// ---------------------------------------------------------------------------
// __remill_compare_eq
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, Intrinsic_CompareEq) {
    auto result = demangleRemillSemantic("__remill_compare_eq");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(result->is_helper);
    EXPECT_EQ(result->raw_name, "__remill_compare_eq");
    EXPECT_EQ(result->semantic, RemillSemantic::Unknown);
}

// ---------------------------------------------------------------------------
// llvm.ctpop.i8 (LLVM intrinsic -- population count)
// ---------------------------------------------------------------------------
TEST(Remill6DemanglerTest, Intrinsic_LlvmCtpopI8) {
    auto result = demangleRemillSemantic("llvm.ctpop.i8");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(result->is_helper);
    EXPECT_EQ(result->raw_name, "llvm.ctpop.i8");
    EXPECT_EQ(result->semantic, RemillSemantic::Unknown);
}

// =============================================================================
// extractRemillMemoryWidth tests -- for memory intrinsics from the .ll file
// =============================================================================

TEST(Remill6DemanglerTest, MemoryWidth_ReadMemory8) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_read_memory_8"), 8u);
}

TEST(Remill6DemanglerTest, MemoryWidth_ReadMemory64) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_read_memory_64"), 64u);
}

TEST(Remill6DemanglerTest, MemoryWidth_WriteMemory64) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_write_memory_64"), 64u);
}

// Non-memory intrinsics should return 0.
TEST(Remill6DemanglerTest, MemoryWidth_FlagComputationReturnsZero) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_flag_computation_carry"), 0u);
}

TEST(Remill6DemanglerTest, MemoryWidth_CompareReturnsZero) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_compare_eq"), 0u);
}

TEST(Remill6DemanglerTest, MemoryWidth_UndefinedReturnsZero) {
    EXPECT_EQ(extractRemillMemoryWidth("__remill_undefined_8"), 0u);
}

TEST(Remill6DemanglerTest, MemoryWidth_LlvmIntrinsicReturnsZero) {
    EXPECT_EQ(extractRemillMemoryWidth("llvm.ctpop.i8"), 0u);
}

// Mangled semantic names are not memory intrinsics.
TEST(Remill6DemanglerTest, MemoryWidth_MangledNameReturnsZero) {
    EXPECT_EQ(extractRemillMemoryWidth(
        "_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_"), 0u);
}

// =============================================================================
// Conditional-jump classification for JNZ and JZ from the .ll file
// =============================================================================

TEST(Remill6DemanglerTest, JNZ_IsConditionalJump) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(isConditionalJump(result->semantic));
}

TEST(Remill6DemanglerTest, JZ_IsConditionalJump) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE");
    ASSERT_TRUE(result.has_value());
    EXPECT_TRUE(isConditionalJump(result->semantic));
}

TEST(Remill6DemanglerTest, JMP_IsNotConditionalJump) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE");
    ASSERT_TRUE(result.has_value());
    EXPECT_FALSE(isConditionalJump(result->semantic));
}

TEST(Remill6DemanglerTest, RET_IsNotConditionalJump) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE");
    ASSERT_TRUE(result.has_value());
    EXPECT_FALSE(isConditionalJump(result->semantic));
}

// =============================================================================
// getJccCondition for the branch instructions in the .ll file
// =============================================================================

TEST(Remill6DemanglerTest, JNZ_Condition) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE");
    ASSERT_TRUE(result.has_value());
    auto cond = getJccCondition(result->semantic);
    ASSERT_TRUE(cond.has_value());
    EXPECT_EQ(*cond, "nz");
}

TEST(Remill6DemanglerTest, JZ_Condition) {
    auto result = demangleRemillSemantic(
        "_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE");
    ASSERT_TRUE(result.has_value());
    auto cond = getJccCondition(result->semantic);
    ASSERT_TRUE(cond.has_value());
    EXPECT_EQ(*cond, "z");
}

// =============================================================================
// Negative / edge-case tests with names NOT in the .ll file
// =============================================================================

TEST(Remill6DemanglerTest, UnrecognizedFunctionReturnsNullopt) {
    auto result = demangleRemillSemantic("some_random_function");
    EXPECT_FALSE(result.has_value());
}

TEST(Remill6DemanglerTest, EmptyStringReturnsNullopt) {
    auto result = demangleRemillSemantic("");
    EXPECT_FALSE(result.has_value());
}

TEST(Remill6DemanglerTest, PartialPrefixReturnsNullopt) {
    auto result = demangleRemillSemantic("_ZN12_GLOBAL__N_1");
    EXPECT_FALSE(result.has_value());
}

TEST(Remill6DemanglerTest, PrefixWithNoDigitsReturnsNullopt) {
    auto result = demangleRemillSemantic("_ZN12_GLOBAL__N_1NOLENGTH");
    EXPECT_FALSE(result.has_value());
}

TEST(Remill6DemanglerTest, PrefixWithZeroLengthReturnsNullopt) {
    auto result = demangleRemillSemantic("_ZN12_GLOBAL__N_10REST");
    EXPECT_FALSE(result.has_value());
}

// =============================================================================
// semanticToString round-trip for every semantic found in the .ll file
// =============================================================================

TEST(Remill6DemanglerTest, SemanticToString_ADD) {
    EXPECT_EQ(semanticToString(RemillSemantic::ADD).str(), "ADD");
}

TEST(Remill6DemanglerTest, SemanticToString_SUB) {
    EXPECT_EQ(semanticToString(RemillSemantic::SUB).str(), "SUB");
}

TEST(Remill6DemanglerTest, SemanticToString_CMP) {
    EXPECT_EQ(semanticToString(RemillSemantic::CMP).str(), "CMP");
}

TEST(Remill6DemanglerTest, SemanticToString_CALL) {
    EXPECT_EQ(semanticToString(RemillSemantic::CALL).str(), "CALL");
}

TEST(Remill6DemanglerTest, SemanticToString_RET) {
    EXPECT_EQ(semanticToString(RemillSemantic::RET).str(), "RET");
}

TEST(Remill6DemanglerTest, SemanticToString_JNZ) {
    EXPECT_EQ(semanticToString(RemillSemantic::JNZ).str(), "JNZ");
}

TEST(Remill6DemanglerTest, SemanticToString_JZ) {
    EXPECT_EQ(semanticToString(RemillSemantic::JZ).str(), "JZ");
}

TEST(Remill6DemanglerTest, SemanticToString_MOV) {
    EXPECT_EQ(semanticToString(RemillSemantic::MOV).str(), "MOV");
}

TEST(Remill6DemanglerTest, SemanticToString_MOVZX) {
    EXPECT_EQ(semanticToString(RemillSemantic::MOVZX).str(), "MOVZX");
}

TEST(Remill6DemanglerTest, SemanticToString_INT3) {
    EXPECT_EQ(semanticToString(RemillSemantic::INT3).str(), "INT3");
}

TEST(Remill6DemanglerTest, SemanticToString_XOR) {
    EXPECT_EQ(semanticToString(RemillSemantic::XOR).str(), "XOR");
}

TEST(Remill6DemanglerTest, SemanticToString_TEST) {
    EXPECT_EQ(semanticToString(RemillSemantic::TEST).str(), "TEST");
}

TEST(Remill6DemanglerTest, SemanticToString_LEA) {
    EXPECT_EQ(semanticToString(RemillSemantic::LEA).str(), "LEA");
}

TEST(Remill6DemanglerTest, SemanticToString_NOP) {
    EXPECT_EQ(semanticToString(RemillSemantic::NOP).str(), "NOP");
}

TEST(Remill6DemanglerTest, SemanticToString_POP) {
    EXPECT_EQ(semanticToString(RemillSemantic::POP).str(), "POP");
}

TEST(Remill6DemanglerTest, SemanticToString_PUSH) {
    EXPECT_EQ(semanticToString(RemillSemantic::PUSH).str(), "PUSH");
}

TEST(Remill6DemanglerTest, SemanticToString_JMP) {
    EXPECT_EQ(semanticToString(RemillSemantic::JMP).str(), "JMP");
}
