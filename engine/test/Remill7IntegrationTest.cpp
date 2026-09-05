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

static size_t countOccurrences(
    const std::string& text,
    const std::string& needle) {
    size_t count = 0;
    for (size_t pos = 0;
         (pos = text.find(needle, pos)) != std::string::npos;
         pos += needle.size()) {
        ++count;
    }
    return count;
}

static std::string findSimpleAssignmentTarget(
    const std::string& text,
    const std::string& rhs) {
    const std::string suffix = " = " + rhs + ";";
    const size_t suffixPos = text.find(suffix);
    if (suffixPos == std::string::npos)
        return {};

    const size_t lineStart = text.rfind('\n', suffixPos);
    size_t targetStart = lineStart == std::string::npos ? 0 : lineStart + 1;
    while (targetStart < suffixPos && text[targetStart] == ' ')
        ++targetStart;
    return text.substr(targetStart, suffixPos - targetStart);
}

static size_t countCallsWithArgumentFragment(
    const std::string& text,
    const std::string& callee,
    const std::string& fragment) {
    size_t count = 0;
    const std::string prefix = callee + "(";
    for (size_t pos = 0;
         (pos = text.find(prefix, pos)) != std::string::npos;
         pos += prefix.size()) {
        const size_t end = text.find(");", pos + prefix.size());
        if (end == std::string::npos)
            break;
        if (text.find(fragment, pos + prefix.size()) < end)
            ++count;
    }
    return count;
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

    const std::string arg5Alias =
        findSimpleAssignmentTarget(pseudoC, "param_5");
    EXPECT_NE(pseudoC.find("field_0x100"), std::string::npos);
    ASSERT_FALSE(arg5Alias.empty());
    EXPECT_NE(pseudoC.find(arg5Alias + "->field_0x100"), std::string::npos);
    EXPECT_EQ(pseudoC.find("rsi = *(rbp + 0x50);"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc3EmitsMemoryIncAndDecForReentrancy) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc3.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_NE(pseudoC.find("field_0x100)++"), std::string::npos);
    EXPECT_NE(pseudoC.find("field_0x100)--"), std::string::npos);
    EXPECT_EQ(pseudoC.find("field_0x100++"), std::string::npos);
    EXPECT_EQ(pseudoC.find("field_0x100--"), std::string::npos);
}

TEST(Remill7IntegrationTest, ProjectileConstructor2RecoversDenseStackArgs) {
    const std::string pseudoC =
        decompileFile("remill-7/projectile_constructor2.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_NE(pseudoC.find("sub_1419b3460("), std::string::npos);
    EXPECT_NE(pseudoC.find("this"), std::string::npos);
    EXPECT_NE(pseudoC.find("param_2"), std::string::npos);
    EXPECT_NE(pseudoC.find("param_14"), std::string::npos);
    EXPECT_EQ(pseudoC.find("*(rsp + 0x30)"), std::string::npos);
    EXPECT_EQ(pseudoC.find("*(rsp + 0x70)"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc7ResolvesConcretePcRelativeCalls) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc7.ll");
    ASSERT_FALSE(pseudoC.empty());

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

    EXPECT_FALSE(findSimpleAssignmentTarget(pseudoC, "param_5").empty());
    EXPECT_NE(pseudoC.find("sub_141431250("), std::string::npos);
    EXPECT_NE(pseudoC.find("sub_14142fe90(param_5,"),
              std::string::npos);
    EXPECT_EQ(pseudoC.find("sub_14142fe90();"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9MarksRecursiveSelfCall) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_GE(countOccurrences(pseudoC, "sub_14142fe90("), 2u);
}

TEST(Remill7IntegrationTest, BonePosCalc9CollapsesResidualPcRelativeGlobals) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_EQ(pseudoC.find("0x19d1eca"), std::string::npos);
    EXPECT_EQ(pseudoC.find("0x19d1e36"), std::string::npos);
    EXPECT_EQ(pseudoC.find("sub_((((("), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9AvoidsSyntheticBlockLabels) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_EQ(pseudoC.find("block_"), std::string::npos);
}

TEST(Remill7IntegrationTest, BonePosCalc9RecoversStackBackedDirectCallReceiver) {
    const std::string pseudoC = decompileFile("remill-7/bone_pos_calc9.ll");
    ASSERT_FALSE(pseudoC.empty());

    EXPECT_GE(
        countCallsWithArgumentFragment(
            pseudoC, "sub_140241c70", " - 40"),
        2u);
    EXPECT_EQ(pseudoC.find("*(rbp - 0x28)"), std::string::npos);
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
    EXPECT_NE(pseudoC.find("if ("), std::string::npos);
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
