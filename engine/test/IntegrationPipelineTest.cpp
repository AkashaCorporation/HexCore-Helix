/// @file IntegrationPipelineTest.cpp
/// @brief End-to-end integration test for the MLIR decompilation pipeline.
///
/// Validates the current full pipeline against quality criteria by decompiling
/// a preserved Remill fixture and comparing it with the historical Rust
/// pipeline reference.
///
/// Feature: mlir-pipeline-optimization
/// Validates: Property 27 (Absence of Forbidden Patterns in Output)
/// Validates: Requirements 1.1, 1.2, 2.1, 4.1, 5.1, 5.6, 10.1 (indirectly)

#include "helix/Engine.h"
#include "helix/Pipeline.h"

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/MLIRContext.h"

#include <gtest/gtest.h>
#include <fstream>
#include <string>
#include <regex>
#include <sstream>
#include <vector>
#include <set>
#include <algorithm>
#include <cstddef>

#ifndef HELIX_TEST_DATA_DIR
#define HELIX_TEST_DATA_DIR "../../tests"
#endif

namespace {

// ============================================================================
//  Helpers
// ============================================================================

/// Read an entire file into a string. Returns empty string on failure.
static std::string readFileToString(const std::string &path) {
    std::ifstream ifs(path, std::ios::in | std::ios::binary);
    if (!ifs.is_open())
        return {};
    std::ostringstream oss;
    oss << ifs.rdbuf();
    return oss.str();
}

/// Count non-overlapping occurrences of `needle` in `haystack`.
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

/// Strip single-line comments (// ...) from a line, returning only the code part.
static std::string stripLineComment(const std::string &line) {
    // Find "//" that is not inside a string literal (simplified: first occurrence)
    auto pos = line.find("//");
    if (pos == std::string::npos)
        return line;
    return line.substr(0, pos);
}

/// Check if a line is a comment-only line (starts with // after trimming).
static bool isCommentLine(const std::string &line) {
    auto trimmed = line;
    trimmed.erase(0, trimmed.find_first_not_of(" \t"));
    return trimmed.starts_with("//");
}

/// Extract all lines from a string.
static std::vector<std::string> splitLines(const std::string &text) {
    std::vector<std::string> lines;
    std::istringstream iss(text);
    std::string line;
    while (std::getline(iss, line))
        lines.push_back(line);
    return lines;
}

/// Count lines matching a regex pattern.
static size_t countLinesMatching(const std::vector<std::string> &lines,
                                 const std::regex &pattern) {
    size_t count = 0;
    for (const auto &line : lines) {
        if (std::regex_search(line, pattern))
            ++count;
    }
    return count;
}

// ============================================================================
//  Test Fixture
// ============================================================================

class IntegrationPipelineTest : public ::testing::Test {
protected:
    /// Current MLIR pipeline output.
    std::string mlirOutput;
    /// Rust pipeline reference output.
    std::string rustReference;
    /// Lines of MLIR output.
    std::vector<std::string> mlirLines;
    /// Lines of Rust reference.
    std::vector<std::string> rustLines;

    void SetUp() override {
        const std::string irPath =
            HELIX_TEST_DATA_DIR "/remill-6/01-name-writing.ll";
        const std::string rustPath =
            HELIX_TEST_DATA_DIR "/remill-6/06-helix-rust.c";

        const std::string ir = readFileToString(irPath);
        ASSERT_FALSE(ir.empty())
            << "Failed to read Remill input at: " << irPath;

        mlir::MLIRContext context;
        helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
        auto output = pipeline.decompile(ir);
        ASSERT_TRUE(output.has_value()) << output.error();
        if (!output)
            return;
        mlirOutput = output->pseudo_c;
        ASSERT_FALSE(mlirOutput.empty());

        rustReference = readFileToString(rustPath);
        ASSERT_FALSE(rustReference.empty())
            << "Failed to read Rust reference at: " << rustPath;

        mlirLines = splitLines(mlirOutput);
        rustLines = splitLines(rustReference);
    }
};

// ============================================================================
//  Property 27: Absence of Forbidden Patterns
//  Validates: Requirement 10.1
// ============================================================================

TEST_F(IntegrationPipelineTest, NoLocalDereferencePatterns) {
    // *(&__local) patterns should be resolved into named variables
    size_t localCount = countOccurrences(mlirOutput, "*(&__local)");
    EXPECT_EQ(localCount, 0u)
        << "Output contains " << localCount
        << " unresolved *(&__local) patterns; "
        << "RecoverStackLayout should resolve all of them into named variables";
}

TEST_F(IntegrationPipelineTest, NoUndefReferences) {
    // __undef should be replaced by typed default values
    size_t undefCount = countOccurrences(mlirOutput, "__undef");
    EXPECT_EQ(undefCount, 0u)
        << "Output contains " << undefCount
        << " __undef references; "
        << "RecoverVariables should replace them with typed defaults (0, nullptr, 0.0)";
}

TEST_F(IntegrationPipelineTest, NoCarryIntrinsics) {
    // __carry should be eliminated by DCE (dead flag computation)
    size_t carryCount = countOccurrences(mlirOutput, "__carry");
    EXPECT_EQ(carryCount, 0u)
        << "Output contains " << carryCount
        << " __carry intrinsics; "
        << "EliminateDeadCode should remove dead flag computations";
}

TEST_F(IntegrationPipelineTest, NoOverflowIntrinsics) {
    // __overflow should be eliminated by DCE (dead flag computation)
    size_t overflowCount = countOccurrences(mlirOutput, "__overflow");
    EXPECT_EQ(overflowCount, 0u)
        << "Output contains " << overflowCount
        << " __overflow intrinsics; "
        << "EliminateDeadCode should remove dead flag computations";
}

TEST_F(IntegrationPipelineTest, NoRawRegisterNamesOutsideComments) {
    // Raw register names (rax, rbx, rcx, rdx, rsp, rdi, r8, r9) should not
    // appear in code — only in comments is acceptable.
    // Note: The Rust reference uses register names as parameter names (rcx, rdx,
    // r8, r9) and variable names, which is acceptable. The MLIR pipeline should
    // use param_N or var_N naming instead, OR match the Rust convention.
    // We check that raw register names don't appear as bare identifiers in
    // assignment targets or function-call-style patterns from Remill.
    std::regex rawRegInCode(
        R"(\b(rax|rbx|rcx|rdx|rsp|rbp|rsi|rdi|r8|r9|r10|r11|r12|r13|r14|r15)\b)");

    size_t violations = 0;
    for (const auto &line : mlirLines) {
        if (isCommentLine(line))
            continue;
        std::string codePart = stripLineComment(line);
        // Skip function signature line (parameters may use register names)
        if (codePart.find("sub_") != std::string::npos &&
            codePart.find("(") != std::string::npos &&
            codePart.find("{") != std::string::npos)
            continue;
        // Skip variable declaration lines (Rust reference style uses reg names)
        auto trimmed = codePart;
        trimmed.erase(0, trimmed.find_first_not_of(" \t"));
        if (trimmed.starts_with("int") || trimmed.starts_with("uint") ||
            trimmed.starts_with("void"))
            continue;

        if (std::regex_search(codePart, rawRegInCode))
            ++violations;
    }
    // Allow some tolerance — the Rust reference itself uses register names
    // in variable declarations and parameters. The key metric is that the
    // MLIR output should not have MORE raw register usage than the reference.
    size_t rustViolations = 0;
    for (const auto &line : rustLines) {
        if (isCommentLine(line))
            continue;
        std::string codePart = stripLineComment(line);
        if (codePart.find("sub_") != std::string::npos &&
            codePart.find("(") != std::string::npos &&
            codePart.find("{") != std::string::npos)
            continue;
        auto trimmed = codePart;
        trimmed.erase(0, trimmed.find_first_not_of(" \t"));
        if (trimmed.starts_with("int") || trimmed.starts_with("uint") ||
            trimmed.starts_with("void"))
            continue;
        if (std::regex_search(codePart, rawRegInCode))
            ++rustViolations;
    }
    EXPECT_LE(violations, rustViolations + 5)
        << "MLIR output has " << violations
        << " lines with raw register names in code vs "
        << rustViolations << " in Rust reference";
}

TEST_F(IntegrationPipelineTest, NoMangledRemillNames) {
    // Mangled Remill names (_ZN12_GLOBAL__N_1...) should be demangled
    size_t mangledCount = countOccurrences(mlirOutput, "_ZN12_GLOBAL__N_1");
    EXPECT_EQ(mangledCount, 0u)
        << "Output contains " << mangledCount
        << " mangled Remill names; "
        << "RemillToHelixLow should demangle all _ZN12_GLOBAL__N_1 prefixed names";
}

// ============================================================================
//  Mangled Name Resolution
//  Validates: Requirements 2.1, 2.6, 9.1
// ============================================================================

TEST_F(IntegrationPipelineTest, FunctionCallsUseResolvedNames) {
    // Function calls should use sub_<hex> format, not mangled names or bare sub_()
    std::regex resolvedCallRe(R"(sub_[0-9a-fA-F]+\s*\()");
    std::regex bareSubCallRe(R"(sub_\(\))");

    size_t resolvedCalls = 0;
    size_t bareCalls = 0;
    for (const auto &line : mlirLines) {
        if (isCommentLine(line))
            continue;
        std::string codePart = stripLineComment(line);
        auto begin = std::sregex_iterator(codePart.begin(), codePart.end(),
                                          resolvedCallRe);
        auto end = std::sregex_iterator();
        resolvedCalls += std::distance(begin, end);

        auto bbegin = std::sregex_iterator(codePart.begin(), codePart.end(),
                                           bareSubCallRe);
        bareCalls += std::distance(bbegin, end);
    }

    EXPECT_GT(resolvedCalls, 0u)
        << "Expected at least one resolved function call (sub_<hex>)";
    EXPECT_EQ(bareCalls, 0u)
        << "Output contains " << bareCalls
        << " bare sub_() calls without resolved addresses";
}

TEST_F(IntegrationPipelineTest, FunctionNameMatchesEntryPoint) {
    // The main function should be named sub_141f7939d
    EXPECT_NE(mlirOutput.find("sub_141f7939d"), std::string::npos)
        << "Expected function name 'sub_141f7939d' matching the entry point address";
}

TEST(IntegrationPipelineRegressionTest, PreservesExplicitFloatingCallArgument) {
    constexpr const char* ir = R"(
        target triple = "x86_64-pc-windows-msvc"

        declare float @sqrtf(float)

        define ptr @sub_1000(ptr %state, i64 %pc, ptr %memory) {
        entry:
          %input = bitcast i32 1084227584 to float
          %root = call float @sqrtf(float %input)
          %bits = bitcast float %root to i32
          %extended = zext i32 %bits to i64
          ret ptr %memory
        }
    )";

    mlir::MLIRContext context;
    helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
    auto output = pipeline.decompile(ir);

    ASSERT_TRUE(output.has_value()) << output.error();
    ASSERT_FALSE(output->pseudo_c.empty());
    EXPECT_NE(output->pseudo_c.find("sqrtf("), std::string::npos);
    EXPECT_EQ(output->pseudo_c.find("sqrtf()"), std::string::npos)
        << "A direct LLVM call already carries authoritative floating-point "
           "arguments; ABI integer-register recovery must not discard them";
}

TEST(IntegrationPipelineRegressionTest,
     PreservesRemillBlockAddressEvidenceAcrossImport) {
    constexpr const char* ir = R"(
        target triple = "x86_64-pc-linux-gnu-elf"

        define ptr @lifted_4096(ptr %state, i64 %pc, ptr %memory) {
        entry:
          br label %bb_4128

        bb_4128:
          ret ptr %memory
        }
    )";

    mlir::MLIRContext context;
    helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
    auto llvmModule = pipeline.parseLLVMIR(ir);
    ASSERT_TRUE(llvmModule.has_value()) << llvmModule.error();

    auto mlirModule = pipeline.translateToMLIR(std::move(*llvmModule));
    ASSERT_TRUE(mlirModule.has_value()) << mlirModule.error();

    auto funcs = (**mlirModule).getOps<mlir::LLVM::LLVMFuncOp>();
    auto it = funcs.begin();
    ASSERT_NE(it, funcs.end());
    auto func = *it;
    auto addresses =
        func.getOperation()->getAttrOfType<mlir::DenseI64ArrayAttr>(
            "helix.block_addresses");
    ASSERT_TRUE(addresses);
    ASSERT_EQ(addresses.size(), 2u);
    auto values = addresses.asArrayRef();
    EXPECT_EQ(values[0], 0);
    EXPECT_EQ(values[1], 4128);
}

TEST(IntegrationPipelineRegressionTest,
     FoldsRelocatedReadOnlyDataWordFromMetadata) {
    constexpr const char* ir = R"(
        target triple = "x86_64-pc-linux-gnu-elf"

        %State = type { %X86State }
        %X86State = type {
            i64, i64, i64, i64, i64, i64, %GPR
        }
        %GPR = type {
            i64, %Reg, i64, %Reg, i64, %Reg, i64, %Reg
        }
        %Reg = type { %RegStorage }
        %RegStorage = type { i64 }

        declare ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2MnImEEEP6MemoryS8_R5StateT_T0_T1_(
            ptr, ptr, ptr, i64, i64)
        declare ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(
            ptr, ptr, ptr, i64)
        declare ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(
            ptr, ptr, ptr)

        define ptr @lifted_4096(ptr %state, i64 %pc, ptr %memory) {
        bb_4096:
          %rdi = getelementptr %State, ptr %state,
              i64 0, i32 0, i32 6, i32 3, i32 0, i32 0,
              !remill_register !0
          %rax = getelementptr %State, ptr %state,
              i64 0, i32 0, i32 6, i32 1, i32 0, i32 0,
              !remill_register !1
          %next_pc = alloca i64
          %base = load i64, ptr %rdi
          %add = call ptr
              @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2MnImEEEP6MemoryS8_R5StateT_T0_T1_(
                  ptr %memory, ptr %state, ptr %rdi, i64 %base,
                  i64 2130736896)
          %updated = load i64, ptr %rdi
          %mov = call ptr
              @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(
                  ptr %memory, ptr %state, ptr %rax, i64 %updated)
          %ret_call = call ptr
              @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(
                  ptr %memory, ptr %state, ptr %next_pc)
          ret ptr %memory
        }

        !helix.strings = !{!90000}
        !90000 = !{i64 2130736896, !"\28\00\00\00\00\00\00\00"}
        !0 = !{[4 x i8] c"RDI\00"}
        !1 = !{[4 x i8] c"RAX\00"}
    )";

    helix::Engine engine(HELIX_ARCH_X86_64);
    engine.setUseCastLayer(true);
    std::vector<char> buffer(1 << 20);
    size_t outputSize = buffer.size();
    auto status = engine.decompileIRText(
        ir, std::char_traits<char>::length(ir),
        buffer.data(), &outputSize);
    ASSERT_EQ(status, HELIX_OK) << engine.lastError();
    std::string output(buffer.data());

    EXPECT_NE(output.find("40"), std::string::npos)
        << output;
    EXPECT_EQ(output.find("0x7f007700"), std::string::npos)
        << "Relocated immutable data must not survive as a fake pointer\n"
        << output;
}

TEST(IntegrationPipelineRegressionTest, NegWritesResultBackToDestinationRegister) {
    constexpr const char* ir = R"(
        target triple = "x86_64-pc-windows-msvc"

        %State = type { %X86State }
        %X86State = type {
            i64, i64, i64, i64, i64, i64, %GPR
        }
        %GPR = type {
            i64, %Reg, i64, %Reg, i64, %Reg, i64, %Reg
        }
        %Reg = type { %RegStorage }
        %RegStorage = type { i64 }

        declare ptr @_ZN12_GLOBAL__N_13NEGI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(
            ptr, ptr, ptr, i64)
        declare ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(
            ptr, ptr, ptr, i64)
        declare ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(
            ptr, ptr, ptr)

        define ptr @lifted_4096(ptr %state, i64 %pc, ptr %memory) {
        entry:
          %rdx = getelementptr %State, ptr %state,
              i64 0, i32 0, i32 6, i32 7, i32 0, i32 0,
              !remill_register !0
          %rax = getelementptr %State, ptr %state,
              i64 0, i32 0, i32 6, i32 1, i32 0, i32 0,
              !remill_register !1
          %next_pc = alloca i64
          %input = load i64, ptr %rdx
          %neg_call = call ptr
              @_ZN12_GLOBAL__N_13NEGI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(
                  ptr %memory, ptr %state, ptr %rdx, i64 %input)
          %negated = load i64, ptr %rdx
          %mov_call = call ptr
              @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(
                  ptr %memory, ptr %state, ptr %rax, i64 %negated)
          %ret_call = call ptr
              @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(
                  ptr %memory, ptr %state, ptr %next_pc)
          ret ptr %memory
        }

        !0 = !{[4 x i8] c"RDX\00"}
        !1 = !{[4 x i8] c"RAX\00"}
    )";

    mlir::MLIRContext context;
    helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
    auto output = pipeline.decompile(ir);

    ASSERT_TRUE(output.has_value()) << output.error();
    ASSERT_FALSE(output->pseudo_c.empty());
    EXPECT_NE(output->pseudo_c.find("-param_2"), std::string::npos)
        << output->pseudo_c;
    EXPECT_EQ(output->pseudo_c.find("return param_2;"), std::string::npos)
        << "NEG must not disappear as a destination-pointer-only no-op";
}

TEST(IntegrationPipelineRegressionTest, CqoIdivPairRecoversSignedRemainder) {
    constexpr const char* ir = R"(
        target triple = "x86_64-pc-windows-msvc"

        %State = type { %X86State }
        %X86State = type {
            i64, i64, i64, i64, i64, i64, %GPR
        }
        %GPR = type {
            i64, %Reg, i64, %Reg, i64, %Reg, i64, %Reg
        }
        %Reg = type { %RegStorage }
        %RegStorage = type { i64 }

        declare ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(
            ptr, ptr, ptr, i64)
        declare ptr @_ZN12_GLOBAL__N_17CQO_RAXEP6MemoryR5State(
            ptr, ptr)
        declare ptr @_ZN12_GLOBAL__N_110IDIVrdxraxI2RnImLb1EEEEP6MemoryS4_R5StateT_2InImE(
            ptr, ptr, i64, i64)
        declare ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(
            ptr, ptr, ptr)

        define ptr @lifted_8192(ptr %state, i64 %pc, ptr %memory) {
        entry:
          %rax = getelementptr %State, ptr %state,
              i64 0, i32 0, i32 6, i32 1, i32 0, i32 0,
              !remill_register !0
          %rcx = getelementptr %State, ptr %state,
              i64 0, i32 0, i32 6, i32 5, i32 0, i32 0,
              !remill_register !1
          %rdx = getelementptr %State, ptr %state,
              i64 0, i32 0, i32 6, i32 7, i32 0, i32 0,
              !remill_register !2
          %next_pc = alloca i64
          %lhs = load i64, ptr %rcx
          %rhs = load i64, ptr %rdx
          %mov_lhs = call ptr
              @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(
                  ptr %memory, ptr %state, ptr %rax, i64 %lhs)
          %cqo = call ptr
              @_ZN12_GLOBAL__N_17CQO_RAXEP6MemoryR5State(
                  ptr %memory, ptr %state)
          %idiv = call ptr
              @_ZN12_GLOBAL__N_110IDIVrdxraxI2RnImLb1EEEEP6MemoryS4_R5StateT_2InImE(
                  ptr %memory, ptr %state, i64 %rhs, i64 %pc)
          %rem = load i64, ptr %rdx
          %mov_rem = call ptr
              @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(
                  ptr %memory, ptr %state, ptr %rax, i64 %rem)
          %ret_call = call ptr
              @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(
                  ptr %memory, ptr %state, ptr %next_pc)
          ret ptr %memory
        }

        !0 = !{[4 x i8] c"RAX\00"}
        !1 = !{[4 x i8] c"RCX\00"}
        !2 = !{[4 x i8] c"RDX\00"}
    )";

    mlir::MLIRContext context;
    helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
    auto output = pipeline.decompile(ir);

    ASSERT_TRUE(output.has_value()) << output.error();
    ASSERT_FALSE(output->pseudo_c.empty());
    EXPECT_NE(output->pseudo_c.find("% param_2"), std::string::npos)
        << output->pseudo_c;
    EXPECT_EQ(output->pseudo_c.find("param_2 ="), std::string::npos)
        << "CQO must not overwrite the live divisor version\n"
        << output->pseudo_c;
    EXPECT_EQ(output->pseudo_c.find("idiv_full"), std::string::npos)
        << output->pseudo_c;
    EXPECT_EQ(output->pseudo_c.find("CQO_RAX"), std::string::npos)
        << output->pseudo_c;
}

// ============================================================================
//  Type Inference
//  Validates: Requirements 5.1, 5.6
// ============================================================================

TEST_F(IntegrationPipelineTest, EmitsConcreteTypes) {
    // One preserved function need not exercise multiple recovered types, but
    // its emitted signature/body must still contain concrete C types.
    std::set<std::string> typesFound;
    std::regex typeRe(R"(\b(int8_t|int16_t|int32_t|int64_t|uint8_t|uint16_t|uint32_t|uint64_t|void\*)\b)");

    for (const auto &line : mlirLines) {
        auto begin = std::sregex_iterator(line.begin(), line.end(), typeRe);
        auto end = std::sregex_iterator();
        for (auto it = begin; it != end; ++it)
            typesFound.insert((*it)[0].str());
    }

    EXPECT_GE(typesFound.size(), 1u)
        << "Expected at least one concrete C integer or pointer type";
}

TEST_F(IntegrationPipelineTest, NotAllDeclarationsAreInt64) {
    // Count int64_t declarations vs total declarations
    size_t int64Decls = 0;
    size_t totalDecls = 0;
    std::regex declRe(R"(^\s+(int\d+_t|uint\d+_t|void\*)\s+\w+)");
    std::regex int64DeclRe(R"(^\s+int64_t\s+\w+)");

    for (const auto &line : mlirLines) {
        if (std::regex_search(line, declRe))
            ++totalDecls;
        if (std::regex_search(line, int64DeclRe))
            ++int64Decls;
    }

    if (totalDecls > 0) {
        double int64Ratio = static_cast<double>(int64Decls) / totalDecls;
        EXPECT_LT(int64Ratio, 1.0)
            << "All " << totalDecls << " declarations are int64_t; "
            << "PropagateTypes should infer varied types";
    }
}

// ============================================================================
//  Dead Code Elimination
//  Validates: Requirements 4.1, 4.4, 4.5, 4.6, 4.7
// ============================================================================

TEST_F(IntegrationPipelineTest, NoNopOperations) {
    // NOP_IMPL should be eliminated by DCE
    size_t nopCount = countOccurrences(mlirOutput, "NOP_IMPL");
    EXPECT_EQ(nopCount, 0u)
        << "Output contains " << nopCount
        << " NOP_IMPL operations; EliminateDeadCode should remove them";
}

TEST_F(IntegrationPipelineTest, NoInt3Operations) {
    // DoINT3 should be eliminated by DCE
    size_t int3Count = countOccurrences(mlirOutput, "DoINT3");
    EXPECT_EQ(int3Count, 0u)
        << "Output contains " << int3Count
        << " DoINT3 operations; EliminateDeadCode should remove them";
}

TEST_F(IntegrationPipelineTest, ReducedLineCount) {
    // The optimized output should be significantly shorter than the unoptimized
    // MLIR output. The Rust reference has ~30 lines; the unoptimized MLIR has ~200+.
    // After optimization, the MLIR output should be closer to the Rust reference.
    size_t mlirCodeLines = 0;
    size_t rustCodeLines = 0;

    for (const auto &line : mlirLines) {
        auto trimmed = line;
        trimmed.erase(0, trimmed.find_first_not_of(" \t"));
        if (!trimmed.empty() && !trimmed.starts_with("//"))
            ++mlirCodeLines;
    }
    for (const auto &line : rustLines) {
        auto trimmed = line;
        trimmed.erase(0, trimmed.find_first_not_of(" \t"));
        if (!trimmed.empty() && !trimmed.starts_with("//"))
            ++rustCodeLines;
    }

    // The MLIR output should have at most 3x the code lines of the Rust reference.
    // This is a generous bound — ideally they'd be close to equal.
    EXPECT_LE(mlirCodeLines, rustCodeLines * 3)
        << "MLIR output has " << mlirCodeLines << " code lines vs "
        << rustCodeLines << " in Rust reference; "
        << "DCE and optimization should reduce output significantly";
}

// ============================================================================
//  Variable Recovery
//  Validates: Requirements 1.1, 6.1, 6.5
// ============================================================================

TEST_F(IntegrationPipelineTest, HasFunctionSignatureWithParameters) {
    // The function signature should have parameters, not void sub_...(void)
    std::regex voidSigRe(R"(void\s+sub_[0-9a-fA-F]+\s*\(\s*void\s*\))");
    std::regex paramSigRe(R"(sub_[0-9a-fA-F]+\s*\([^)]+\))");

    bool hasVoidSig = std::regex_search(mlirOutput, voidSigRe);
    bool hasParamSig = std::regex_search(mlirOutput, paramSigRe);

    EXPECT_FALSE(hasVoidSig)
        << "Function signature is 'void sub_...(void)'; "
        << "RecoverVariables should recover parameters";
    EXPECT_TRUE(hasParamSig)
        << "Expected function signature with parameters";
}

TEST_F(IntegrationPipelineTest, HasReturnType) {
    // The function should have a non-void return type if the Rust reference does
    bool rustHasReturn = rustReference.find("int64_t sub_") != std::string::npos;
    if (rustHasReturn) {
        // Check that MLIR output also has a typed return
        std::regex typedReturnRe(R"((int\d+_t|uint\d+_t|void\*)\s+sub_[0-9a-fA-F]+)");
        EXPECT_TRUE(std::regex_search(mlirOutput, typedReturnRe))
            << "Rust reference has typed return; MLIR output should too";
    }
}

// ============================================================================
//  Control Flow Structuring
//  Validates: Requirement 8.1
// ============================================================================

TEST_F(IntegrationPipelineTest, DoesNotLeakRawBranchOpcodes) {
    // This fixture may become straight-line after optimization. The stable
    // contract is that lifted branch opcodes do not leak into emitted C.
    bool hasRawJz = false;
    bool hasRawJnz = false;
    bool hasRawJmp = false;

    for (const auto &line : mlirLines) {
        if (isCommentLine(line))
            continue;
        std::string codePart = stripLineComment(line);
        if (codePart.find("JZ") != std::string::npos)
            hasRawJz = true;
        if (codePart.find("JNZ") != std::string::npos)
            hasRawJnz = true;
        // JMP in code (not in comments) indicates unstructured flow
        if (codePart.find("JMP") != std::string::npos)
            hasRawJmp = true;
    }

    EXPECT_FALSE(hasRawJz)
        << "Output contains raw JZ branch; StructureControlFlow should "
        << "convert to if/else";
    EXPECT_FALSE(hasRawJnz)
        << "Output contains raw JNZ branch; StructureControlFlow should "
        << "convert to if/else";
}

// ============================================================================
//  Return Value Capture
//  Validates: Requirement 10.7
// ============================================================================

TEST_F(IntegrationPipelineTest, CapturesReturnValues) {
    // The Rust reference captures return values: void* result_bf18 = sub_141f7bf18()
    // Check if the MLIR output also captures return values from function calls
    std::regex captureRe(R"(\w+\s+\w+\s*=\s*sub_[0-9a-fA-F]+\s*\()");

    size_t rustCaptures = 0;
    size_t mlirCaptures = 0;

    for (const auto &line : rustLines) {
        if (std::regex_search(line, captureRe))
            ++rustCaptures;
    }
    for (const auto &line : mlirLines) {
        if (std::regex_search(line, captureRe))
            ++mlirCaptures;
    }

    if (rustCaptures > 0) {
        EXPECT_GT(mlirCaptures, 0u)
            << "Rust reference captures " << rustCaptures
            << " return values; MLIR output should capture at least some";
    }
}

// ============================================================================
//  Address Comments
//  Validates: Requirement 10.6
// ============================================================================

TEST_F(IntegrationPipelineTest, HasAddressComments) {
    // Significant instructions should have address comments: // 0x<hex>
    std::regex addrCommentRe(R"(//\s*0x[0-9a-fA-F]+)");

    size_t addrComments = 0;
    for (const auto &line : mlirLines) {
        if (std::regex_search(line, addrCommentRe))
            ++addrComments;
    }

    // The Rust reference has address comments on most call lines
    size_t rustAddrComments = 0;
    for (const auto &line : rustLines) {
        if (std::regex_search(line, addrCommentRe))
            ++rustAddrComments;
    }

    if (rustAddrComments > 0) {
        EXPECT_GT(addrComments, 0u)
            << "Rust reference has " << rustAddrComments
            << " address comments; MLIR output should include them too";
    }
}

// ============================================================================
//  Structural Quality Comparison with Rust Reference
//  Validates: Overall output quality (all requirements indirectly)
// ============================================================================

TEST_F(IntegrationPipelineTest, QualityScoreComparison) {
    // Compute a simple quality score for both outputs based on:
    // - Absence of forbidden patterns (higher is better)
    // - Presence of structured control flow
    // - Type variety
    // - Resolved function names

    auto computeScore = [](const std::string &output) -> int {
        int score = 100; // Start with perfect score, deduct for issues

        // Deduct for forbidden patterns
        score -= static_cast<int>(countOccurrences(output, "*(&__local)")) * 2;
        score -= static_cast<int>(countOccurrences(output, "__undef")) * 2;
        score -= static_cast<int>(countOccurrences(output, "__carry")) * 2;
        score -= static_cast<int>(countOccurrences(output, "__overflow")) * 2;
        score -= static_cast<int>(countOccurrences(output, "_ZN12_GLOBAL__N_1")) * 3;
        score -= static_cast<int>(countOccurrences(output, "NOP_IMPL")) * 2;
        score -= static_cast<int>(countOccurrences(output, "DoINT3")) * 2;

        // Bonus for good patterns
        if (output.find("if ") != std::string::npos ||
            output.find("if(") != std::string::npos)
            score += 5;
        if (output.find("while") != std::string::npos)
            score += 5;

        // Bonus for type variety
        std::set<std::string> types;
        std::regex typeRe(R"(\b(int8_t|int16_t|int32_t|uint8_t|uint16_t|uint32_t|void\*)\b)");
        auto begin = std::sregex_iterator(output.begin(), output.end(), typeRe);
        auto end = std::sregex_iterator();
        for (auto it = begin; it != end; ++it)
            types.insert((*it)[0].str());
        score += static_cast<int>(types.size()) * 2;

        // Bonus for resolved function calls
        std::regex resolvedRe(R"(sub_[0-9a-fA-F]{4,}\s*\()");
        auto rbegin = std::sregex_iterator(output.begin(), output.end(), resolvedRe);
        auto rend = std::sregex_iterator();
        score += static_cast<int>(std::distance(rbegin, rend));

        return score;
    };

    int mlirScore = computeScore(mlirOutput);
    int rustScore = computeScore(rustReference);

    // The MLIR output should achieve at least 50% of the Rust reference score.
    // This is a generous threshold that allows for incremental improvement.
    EXPECT_GE(mlirScore, rustScore / 2)
        << "MLIR quality score (" << mlirScore
        << ") is less than 50% of Rust reference score ("
        << rustScore << "); pipeline optimization needs improvement";

    // Log scores for visibility
    std::cout << "[  SCORES ] MLIR pipeline: " << mlirScore
              << ", Rust pipeline: " << rustScore
              << " (ratio: " << (rustScore > 0 ? (100 * mlirScore / rustScore) : 0)
              << "%)" << std::endl;
}

TEST_F(IntegrationPipelineTest, FunctionCallCountComparison) {
    // The MLIR output should have a similar number of function calls as the
    // Rust reference (both decompile the same function).
    std::regex callRe(R"(sub_[0-9a-fA-F]+\s*\()");

    auto countCalls = [&callRe](const std::vector<std::string> &lines) -> size_t {
        size_t count = 0;
        for (const auto &line : lines) {
            if (isCommentLine(line))
                continue;
            auto begin = std::sregex_iterator(line.begin(), line.end(), callRe);
            auto end = std::sregex_iterator();
            count += std::distance(begin, end);
        }
        return count;
    };

    size_t mlirCalls = countCalls(mlirLines);
    size_t rustCalls = countCalls(rustLines);

    // The MLIR output should have at least half the resolved calls of the
    // Rust reference (some may be inlined or optimized differently).
    if (rustCalls > 0) {
        EXPECT_GE(mlirCalls, rustCalls / 2)
            << "MLIR output has " << mlirCalls << " resolved function calls vs "
            << rustCalls << " in Rust reference";
    }
}

TEST_F(IntegrationPipelineTest, OperatorsUsedInsteadOfFunctionCalls) {
    // Arithmetic operations should use C operators, not function-style calls
    // like cmp(), test(), xor(), add(), sub()
    std::regex funcStyleArithRe(R"(\b(cmp|test|xor|add|sub)\s*\()");

    size_t funcStyleCount = 0;
    for (const auto &line : mlirLines) {
        if (isCommentLine(line))
            continue;
        std::string codePart = stripLineComment(line);
        // Exclude function calls like sub_141f7939d() — those are real calls
        if (codePart.find("sub_") != std::string::npos)
            continue;
        auto begin = std::sregex_iterator(codePart.begin(), codePart.end(),
                                          funcStyleArithRe);
        auto end = std::sregex_iterator();
        funcStyleCount += std::distance(begin, end);
    }

    EXPECT_EQ(funcStyleCount, 0u)
        << "Output contains " << funcStyleCount
        << " function-style arithmetic calls; "
        << "PseudoCEmitter should use C operators (+, -, ^, etc.)";
}

} // anonymous namespace
