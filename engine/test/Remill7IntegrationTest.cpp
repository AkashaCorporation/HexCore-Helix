/// @file Remill7IntegrationTest.cpp
/// @brief End-to-end regression tests for complex remill-7 samples.

#include "helix/Pipeline.h"

#include "mlir/IR/MLIRContext.h"

#include <gtest/gtest.h>

#include <fstream>
#include <sstream>
#include <string>

#ifndef HELIX_TEST_DATA_DIR
#define HELIX_TEST_DATA_DIR "../../tests"
#endif

namespace {

static std::string readFileToString(const std::string& path) {
    std::ifstream ifs(path, std::ios::in | std::ios::binary);
    if (!ifs.is_open())
        return {};

    std::ostringstream oss;
    oss << ifs.rdbuf();
    return oss.str();
}

static std::string decompileFile(const std::string& relativePath) {
    const std::string fullPath =
        std::string(HELIX_TEST_DATA_DIR) + "/" + relativePath;
    const std::string ir = readFileToString(fullPath);
    EXPECT_FALSE(ir.empty()) << "Failed to read test input: " << fullPath;
    if (ir.empty())
        return {};

    mlir::MLIRContext context;
    helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
    auto output = pipeline.decompile(ir);
    EXPECT_TRUE(output.has_value()) << output.error();
    if (!output)
        return {};

    return output->pseudo_c;
}

} // namespace

TEST(Remill7IntegrationTest, BonePosCalc3RecoversStackParamAndReturnType) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc3.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_NE(pseudoC.find("int64_t sub_14142fe90("), std::string::npos);
    EXPECT_NE(pseudoC.find("param_5"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc3InitializesRaxFromRecoveredArg5) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc3.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_NE(pseudoC.find("field_0x100"), std::string::npos);
    EXPECT_TRUE(
        pseudoC.find("rax = (int64_t)(rsi->field_0x100);") != std::string::npos ||
        pseudoC.find("rax = (int64_t)(param_5->field_0x100);") != std::string::npos);
    EXPECT_EQ(pseudoC.find("rsi = *(rbp + 0x50);"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc3EmitsMemoryIncAndDecForReentrancy) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc3.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_NE(pseudoC.find("field_0x100++"), std::string::npos);
    EXPECT_NE(pseudoC.find("field_0x100--"), std::string::npos);
}

TEST(Remill7IntegrationTest, ProjectileConstructor2RecoversDenseStackArgs) {
    const std::string pseudoC =
        decompileFile("remill-7/projectile_constructor2.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_NE(
        pseudoC.find("sub_1419b3460(void* this, int64_t param_2, int64_t param_3, int64_t param_4, int64_t param_5, int64_t param_6"),
        std::string::npos);
    EXPECT_NE(pseudoC.find("param_14"), std::string::npos);
    EXPECT_EQ(pseudoC.find("*(rsp + 0x30)"), std::string::npos);
    EXPECT_EQ(pseudoC.find("*(rsp + 0x70)"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc7ResolvesConcretePcRelativeCalls) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc7.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_NE(pseudoC.find("rsi = param_5;"), std::string::npos);
    EXPECT_NE(pseudoC.find("sub_140241c"), std::string::npos);
    EXPECT_NE(pseudoC.find("sub_141431"), std::string::npos);
    EXPECT_EQ(pseudoC.find("sub_((((("), std::string::npos);
    EXPECT_EQ(pseudoC.find("v0->field"), std::string::npos);
    EXPECT_EQ(pseudoC.find("goto loc_irr_129"), std::string::npos);
    EXPECT_EQ(pseudoC.find("loc_irr_129:"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9PropagatesCallArgumentsAcrossBlocks) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_NE(pseudoC.find("rsi = param_5;"), std::string::npos);
    EXPECT_NE(pseudoC.find("sub_141431250(r14, (int64_t)(*rsi));"),
              std::string::npos);
    EXPECT_NE(
        pseudoC.find("sub_14142fe90(param_5, r15, (int64_t)(r12), (int64_t)(r13));"),
        std::string::npos);
    EXPECT_EQ(pseudoC.find("sub_14142fe90();"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9MarksRecursiveSelfCall) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_NE(pseudoC.find("RECURSIVE"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9CollapsesResidualPcRelativeGlobals) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_EQ(pseudoC.find("v1"), std::string::npos);
    EXPECT_EQ(pseudoC.find("v7"), std::string::npos);
    EXPECT_EQ(pseudoC.find("0x19d1eca"), std::string::npos);
    EXPECT_EQ(pseudoC.find("0x19d1e36"), std::string::npos);
    EXPECT_NE(pseudoC.find("*0x142e01e5a"), std::string::npos);
    EXPECT_NE(pseudoC.find("param_4 != 0x142e01dfa"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9AvoidsSyntheticBlockLabels) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_EQ(pseudoC.find("block_"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9RecoversStackBackedDirectCallReceiver) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_NE(pseudoC.find("sub_140241c70((rbp - 0x28));"), std::string::npos);
    EXPECT_NE(pseudoC.find("sub_140241c70((rbp - 0x28), r15);"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9AvoidsRedundantNestedEntryLabels) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_EQ(pseudoC.find("loc_irr_102:"), std::string::npos);
    EXPECT_EQ(pseudoC.find("loc_irr_113:"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9StructuresNestedTailNullCheck) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_EQ(pseudoC.find("loc_irr_131:"), std::string::npos);
    EXPECT_EQ(pseudoC.find("goto loc_irr_131;"), std::string::npos);
    EXPECT_NE(
        pseudoC.find("if (param_1 == 0) {\n        param_1 = r15->field_0x20;\n        if (param_1 == 0) {"),
        std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9SuppressesSignedOverflowHelperNoise) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_EQ(pseudoC.find("__overflow("), std::string::npos);
    EXPECT_EQ(
        pseudoC.find("if (((((((int64_t)(rbx) - &r14->field_0x28) < 0) ^"),
        std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9HidesDeadCodeAfterGotoUntilLabel) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_EQ(
        pseudoC.find("goto loc_irr_105;\n    if ((int64_t)(rbx)"),
        std::string::npos);
    EXPECT_EQ(
        pseudoC.find("goto loc_irr_105;\r\n    if ((int64_t)(rbx)"),
        std::string::npos);
    EXPECT_EQ(
        pseudoC.find("goto loc_irr_105;\n    param_1 = rdi;"),
        std::string::npos);
    EXPECT_EQ(
        pseudoC.find("goto loc_irr_105;\r\n    param_1 = rdi;"),
        std::string::npos);
}
