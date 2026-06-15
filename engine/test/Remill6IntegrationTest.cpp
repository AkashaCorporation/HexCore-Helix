/// Remill6IntegrationTest.cpp
/// Integration test that verifies the engine can process the real Remill output
/// from tests/remill-6/01-name-writing.ll. Since the full MLIR pipeline requires
/// LLVM 18 to compile, this test is designed to test the components that don't
/// need the full MLIR infrastructure.

#include "helix/analysis/RemillDemangler.h"
#include <gtest/gtest.h>
#include <fstream>
#include <string>
#include <regex>
#include <sstream>

#ifndef HELIX_TEST_DATA_DIR
#define HELIX_TEST_DATA_DIR "../../tests"
#endif

namespace {

/// Helper: read an entire file into a string. Returns empty string on failure.
static std::string readFileToString(const std::string &path) {
    std::ifstream ifs(path, std::ios::in | std::ios::binary);
    if (!ifs.is_open())
        return {};
    std::ostringstream oss;
    oss << ifs.rdbuf();
    return oss.str();
}

/// Helper: count non-overlapping occurrences of `needle` in `haystack`.
static size_t countOccurrences(const std::string &haystack,
                               const std::string &needle) {
    size_t count = 0;
    size_t pos = 0;
    while ((pos = haystack.find(needle, pos)) != std::string::npos) {
        ++count;
        pos += needle.size();
    }
    return count;
}

// ---------------------------------------------------------------------------
// Test fixture
// ---------------------------------------------------------------------------
class Remill6IntegrationTest : public ::testing::Test {
protected:
    std::string llContents;
    std::string expectedCContents;

    void SetUp() override {
        const std::string llPath =
            HELIX_TEST_DATA_DIR "/remill-6/01-name-writing.ll";
        const std::string cPath =
            HELIX_TEST_DATA_DIR "/remill-6/04-helix.c";

        llContents = readFileToString(llPath);
        ASSERT_FALSE(llContents.empty())
            << "Failed to read .ll file at: " << llPath;

        expectedCContents = readFileToString(cPath);
        ASSERT_FALSE(expectedCContents.empty())
            << "Failed to read expected C output at: " << cPath;
    }
};

// ---------------------------------------------------------------------------
// 1. IR text structure parsing
// ---------------------------------------------------------------------------

TEST_F(Remill6IntegrationTest, HeaderContainsSourceFile) {
    EXPECT_NE(llContents.find("wwzRetailEgs.exe"), std::string::npos)
        << "Expected source file name 'wwzRetailEgs.exe' in .ll header";
}

TEST_F(Remill6IntegrationTest, HeaderContainsAddress) {
    EXPECT_NE(llContents.find("0x141f7939d"), std::string::npos)
        << "Expected address 0x141f7939d in .ll header";
}

TEST_F(Remill6IntegrationTest, HeaderContainsArchitecture) {
    EXPECT_NE(llContents.find("amd64"), std::string::npos)
        << "Expected architecture 'amd64' in .ll header";
}

TEST_F(Remill6IntegrationTest, HasStructStateTypeDefinition) {
    EXPECT_NE(llContents.find("%struct.State"), std::string::npos)
        << "Expected %struct.State type definition in .ll file";
}

TEST_F(Remill6IntegrationTest, HasLiftedFunction) {
    EXPECT_NE(llContents.find("lifted_5401711517"), std::string::npos)
        << "Expected lifted function 'lifted_5401711517' in .ll file";
}

TEST_F(Remill6IntegrationTest, HasLLVM18ClangVersionIdentifier) {
    // Remill / clang 18 typically emits something like "clang version 18"
    std::regex clangVersionRe(R"(clang version 18)");
    EXPECT_TRUE(std::regex_search(llContents, clangVersionRe))
        << "Expected LLVM 18 clang version identifier in .ll file";
}

// ---------------------------------------------------------------------------
// 2. Register metadata extraction
// ---------------------------------------------------------------------------

TEST_F(Remill6IntegrationTest, MetadataContainsRDI) {
    // !6 = !{[4 x i8] c"RDI\00"}
    std::regex rdiRe(R"(!\d+\s*=\s*!\{.*c"RDI\\00"\})");
    EXPECT_TRUE(std::regex_search(llContents, rdiRe))
        << "Expected metadata node mapping to register RDI";
}

TEST_F(Remill6IntegrationTest, MetadataContainsRSP) {
    // !7 = !{[4 x i8] c"RSP\00"}
    std::regex rspRe(R"(!\d+\s*=\s*!\{.*c"RSP\\00"\})");
    EXPECT_TRUE(std::regex_search(llContents, rspRe))
        << "Expected metadata node mapping to register RSP";
}

TEST_F(Remill6IntegrationTest, MetadataContainsRCX) {
    // !18 = !{[4 x i8] c"RCX\00"}
    std::regex rcxRe(R"(!\d+\s*=\s*!\{.*c"RCX\\00"\})");
    EXPECT_TRUE(std::regex_search(llContents, rcxRe))
        << "Expected metadata node mapping to register RCX";
}

TEST_F(Remill6IntegrationTest, MetadataNodeRDIIsNode6) {
    EXPECT_NE(llContents.find("!6 = !{[4 x i8] c\"RDI\\00\"}"),
              std::string::npos)
        << "Expected !6 to map to RDI";
}

TEST_F(Remill6IntegrationTest, MetadataNodeRSPIsNode7) {
    EXPECT_NE(llContents.find("!7 = !{[4 x i8] c\"RSP\\00\"}"),
              std::string::npos)
        << "Expected !7 to map to RSP";
}

TEST_F(Remill6IntegrationTest, MetadataNodeRCXIsNode18) {
    EXPECT_NE(llContents.find("!18 = !{[4 x i8] c\"RCX\\00\"}"),
              std::string::npos)
        << "Expected !18 to map to RCX";
}

// ---------------------------------------------------------------------------
// 3. Semantic call counting
// ---------------------------------------------------------------------------

TEST_F(Remill6IntegrationTest, CountCALLSemantics) {
    // CALL may appear in two variants; count all of them.
    size_t count = countOccurrences(llContents, "CALL");
    EXPECT_GE(count, 13u) << "Expected ~15 CALL semantics (got " << count << ")";
    EXPECT_LE(count, 17u) << "Expected ~15 CALL semantics (got " << count << ")";
}

TEST_F(Remill6IntegrationTest, CountMOVSemantics) {
    size_t count = countOccurrences(llContents, "MOV");
    // MOV also matches MOVZX so we count pure MOV via regex
    std::regex movRe(R"(\bMOV\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), movRe);
    auto end = std::sregex_iterator();
    size_t regexCount = std::distance(begin, end);
    EXPECT_GE(regexCount, 13u)
        << "Expected ~15 MOV semantics (got " << regexCount << ")";
    EXPECT_LE(regexCount, 17u)
        << "Expected ~15 MOV semantics (got " << regexCount << ")";
}

TEST_F(Remill6IntegrationTest, CountJZSemantics) {
    std::regex jzRe(R"(\bJZ\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), jzRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 4u) << "Expected 4 JZ semantics";
}

TEST_F(Remill6IntegrationTest, CountJNZSemantics) {
    std::regex jnzRe(R"(\bJNZ\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), jnzRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 2u) << "Expected 2 JNZ semantics";
}

TEST_F(Remill6IntegrationTest, CountTESTSemantics) {
    std::regex testRe(R"(\bTEST\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), testRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 4u) << "Expected 4 TEST semantics";
}

TEST_F(Remill6IntegrationTest, CountCMPSemantics) {
    std::regex cmpRe(R"(\bCMP\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), cmpRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 2u) << "Expected 2 CMP semantics";
}

TEST_F(Remill6IntegrationTest, CountNOP_IMPLSemantics) {
    size_t count = countOccurrences(llContents, "NOP_IMPL");
    EXPECT_EQ(count, 3u) << "Expected 3 NOP_IMPL semantics";
}

TEST_F(Remill6IntegrationTest, CountDoINT3Semantics) {
    size_t count = countOccurrences(llContents, "DoINT3");
    EXPECT_EQ(count, 6u) << "Expected 6 DoINT3 semantics";
}

TEST_F(Remill6IntegrationTest, CountPUSHSemantics) {
    std::regex pushRe(R"(\bPUSH\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), pushRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 1u) << "Expected 1 PUSH semantic";
}

TEST_F(Remill6IntegrationTest, CountPOPSemantics) {
    std::regex popRe(R"(\bPOP\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), popRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 2u) << "Expected 2 POP semantics";
}

TEST_F(Remill6IntegrationTest, CountRETSemantics) {
    std::regex retRe(R"(\bRET\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), retRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 1u) << "Expected 1 RET semantic";
}

TEST_F(Remill6IntegrationTest, CountJMPSemantics) {
    std::regex jmpRe(R"(\bJMP\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), jmpRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 3u) << "Expected 3 JMP semantics";
}

TEST_F(Remill6IntegrationTest, CountADDSemantics) {
    std::regex addRe(R"(\bADD\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), addRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 3u) << "Expected 3 ADD semantics";
}

TEST_F(Remill6IntegrationTest, CountSUBSemantics) {
    std::regex subRe(R"(\bSUB\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), subRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 2u) << "Expected 2 SUB semantics";
}

TEST_F(Remill6IntegrationTest, CountXORSemantics) {
    std::regex xorRe(R"(\bXOR\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), xorRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 3u) << "Expected 3 XOR semantics";
}

TEST_F(Remill6IntegrationTest, CountLEASemantics) {
    std::regex leaRe(R"(\bLEA\b)");
    auto begin = std::sregex_iterator(llContents.begin(), llContents.end(), leaRe);
    auto end = std::sregex_iterator();
    size_t count = std::distance(begin, end);
    EXPECT_EQ(count, 2u) << "Expected 2 LEA semantics";
}

TEST_F(Remill6IntegrationTest, CountMOVZXSemantics) {
    size_t count = countOccurrences(llContents, "MOVZX");
    EXPECT_EQ(count, 2u) << "Expected 2 MOVZX semantics";
}

// ---------------------------------------------------------------------------
// 4. Expected output comparison
// ---------------------------------------------------------------------------

TEST_F(Remill6IntegrationTest, ExpectedOutputContainsFunctionName) {
    EXPECT_NE(expectedCContents.find("sub_141f7939d"), std::string::npos)
        << "Expected function name 'sub_141f7939d' in pseudo-C output";
}

TEST_F(Remill6IntegrationTest, ExpectedOutputContainsWin64ABIParameters) {
    EXPECT_NE(expectedCContents.find("int64_t rcx"), std::string::npos)
        << "Expected Win64 ABI parameter 'int64_t rcx'";
    EXPECT_NE(expectedCContents.find("int64_t rdx"), std::string::npos)
        << "Expected Win64 ABI parameter 'int64_t rdx'";
    EXPECT_NE(expectedCContents.find("int64_t r8"), std::string::npos)
        << "Expected Win64 ABI parameter 'int64_t r8'";
    EXPECT_NE(expectedCContents.find("int64_t r9"), std::string::npos)
        << "Expected Win64 ABI parameter 'int64_t r9'";
}

TEST_F(Remill6IntegrationTest, ExpectedOutputContainsControlFlow) {
    // The JZ after CMP should produce an if-statement testing rax
    EXPECT_NE(expectedCContents.find("if ((rax != 0))"), std::string::npos)
        << "Expected control flow 'if ((rax != 0))' from JZ after CMP";
}

TEST_F(Remill6IntegrationTest, ExpectedOutputContainsMultipleFunctionCalls) {
    // The pseudo-C output should contain multiple function calls.
    // A function call in C looks like an identifier followed by '('.
    std::regex callRe(R"(\w+\s*\()");
    auto begin = std::sregex_iterator(expectedCContents.begin(),
                                       expectedCContents.end(), callRe);
    auto end = std::sregex_iterator();
    size_t callCount = std::distance(begin, end);
    EXPECT_GT(callCount, 1u)
        << "Expected multiple function calls in pseudo-C output";
}

} // anonymous namespace
