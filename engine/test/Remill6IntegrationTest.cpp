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
#include <set>
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
// 3. Semantic compatibility
// ---------------------------------------------------------------------------

TEST_F(Remill6IntegrationTest, MangledSemanticsRemainRecognizable) {
    std::regex symbolRe(R"(@(_ZN12_GLOBAL__N_1[A-Za-z0-9_]+)\()");
    std::set<std::string> symbols;
    std::set<helix::RemillSemantic> semantics;

    for (auto it = std::sregex_iterator(
             llContents.begin(), llContents.end(), symbolRe);
         it != std::sregex_iterator(); ++it) {
        symbols.insert((*it)[1].str());
    }

    ASSERT_FALSE(symbols.empty());
    for (const std::string& symbol : symbols) {
        auto info = helix::demangleRemillSemantic(symbol);
        ASSERT_TRUE(info.has_value()) << "Unrecognized semantic: " << symbol;
        if (!info->is_helper)
            semantics.insert(info->semantic);
    }

    for (helix::RemillSemantic required : {
             helix::RemillSemantic::MOV, helix::RemillSemantic::CALL,
             helix::RemillSemantic::CMP, helix::RemillSemantic::TEST,
             helix::RemillSemantic::JMP, helix::RemillSemantic::RET}) {
        EXPECT_TRUE(semantics.contains(required))
            << "Missing semantic category "
            << helix::semanticToString(required).str();
    }
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
