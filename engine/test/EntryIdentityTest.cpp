/// @file EntryIdentityTest.cpp
/// @brief Entry identities survive LLVM import and naming before PC lowering.
#include "helix/Pipeline.h"
#include "helix/Engine.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/passes/Passes.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Pass/PassManager.h"
#include <gtest/gtest.h>
#include <cstdlib>
#include <fstream>
#include <iterator>

namespace {
std::string fixture(std::string name, std::string attributes = "",
                    std::string block = "entry") {
    return "target triple = \"x86_64-unknown-linux-gnu\"\n"
        "define ptr @" + name + "(ptr %state, i64 %pc, ptr %memory) " + attributes +
        " {\n" + block + ":\n  ret ptr %memory\n}\n";
}

TEST(EntryIdentity, NamedExplicitAddressesIncludeZeroAndHighBits) {
    for (const auto [text, expected] : {
        std::pair{"0x1000", uint64_t{0x1000}},
        std::pair{"0", uint64_t{0}},
        std::pair{"0xfedcba9876543210", uint64_t{0xfedcba9876543210}}}) {
        mlir::MLIRContext context;
        helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
        auto parsed = pipeline.parseLLVMIR(fixture("named_fixture",
            std::string("\"hexcore.entry_address\"=\"") + text + "\""));
        ASSERT_TRUE(parsed.has_value());
        auto module = pipeline.translateToMLIR(std::move(*parsed));
        ASSERT_TRUE(module.has_value()) << module.error();
        auto func = *(*module)->getOps<mlir::LLVM::LLVMFuncOp>().begin();
        auto address = func->getAttrOfType<mlir::IntegerAttr>("helix.entry_address");
        ASSERT_TRUE(address); EXPECT_EQ(address.getValue().getZExtValue(), expected);
        mlir::PassManager manager(&context);
        manager.addPass(helix::createRemillToHelixLowPass());
        ASSERT_TRUE(mlir::succeeded(manager.run(**module)));
        auto low = *(*module)->getOps<helix::low::FuncOp>().begin();
        EXPECT_EQ(low.getEntryAddress(), expected);
    }
}

TEST(EntryIdentity, PreservesLegacyNames) {
    for (const auto& ir : {fixture("lifted_4096"), fixture("sub_1000")}) {
        mlir::MLIRContext context;
        helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
        auto parsed = pipeline.parseLLVMIR(ir); ASSERT_TRUE(parsed.has_value());
        auto module = pipeline.translateToMLIR(std::move(*parsed));
        ASSERT_TRUE(module.has_value()) << module.error();
        auto func = *(*module)->getOps<mlir::LLVM::LLVMFuncOp>().begin();
        EXPECT_EQ(func->getAttrOfType<mlir::IntegerAttr>("helix.entry_address").getValue().getZExtValue(), 4096);
    }
}

TEST(EntryIdentity, RejectsMalformedAndConflictingExplicitAddresses) {
    for (const auto& ir : {
        fixture("named", "\"hexcore.entry_address\"=\"-1\""),
        fixture("named", "\"hexcore.entry_address\"=\"18446744073709551616\""),
        fixture("lifted_4096", "\"hexcore.entry_address\"=\"0x2000\""),
        fixture("named", "\"hexcore.entry_address\"=\"\"")}) {
        mlir::MLIRContext context;
        helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
        auto parsed = pipeline.parseLLVMIR(ir); ASSERT_TRUE(parsed.has_value());
        EXPECT_FALSE(pipeline.translateToMLIR(std::move(*parsed)).has_value());
    }
}

TEST(EntryIdentity, BlockLabelsDoNotInventFunctionIdentity) {
    mlir::MLIRContext context;
    helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
    auto parsed = pipeline.parseLLVMIR(R"(
        define ptr @named_fixture(ptr %state, i64 %pc, ptr %memory) {
        entry:
          br label %bb_4096
        bb_4096:
          ret ptr %memory
        }
    )");
    ASSERT_TRUE(parsed.has_value());
    auto module = pipeline.translateToMLIR(std::move(*parsed)); ASSERT_TRUE(module.has_value());
    mlir::PassManager manager(&context);
    manager.addPass(helix::createRemillToHelixLowPass());
    EXPECT_TRUE(mlir::failed(manager.run(**module)));
}

TEST(EntryIdentity, ExplicitEntryIsIndependentOfFirstDecodedBlock) {
    mlir::MLIRContext context;
    helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
    auto parsed = pipeline.parseLLVMIR(fixture("named", "\"hexcore.entry_address\"=\"0x1000\"", "bb_4128"));
    ASSERT_TRUE(parsed.has_value());
    auto module = pipeline.translateToMLIR(std::move(*parsed)); ASSERT_TRUE(module.has_value());
    auto func = *(*module)->getOps<mlir::LLVM::LLVMFuncOp>().begin();
    EXPECT_EQ(func->getAttrOfType<mlir::IntegerAttr>("helix.entry_address").getValue().getZExtValue(), 4096);
    EXPECT_EQ(func->getAttrOfType<mlir::DenseI64ArrayAttr>("helix.block_addresses").asArrayRef()[0], 4128);
}

TEST(EntryIdentity, UnknownNamedEntryIsNotSilentlyZero) {
    mlir::MLIRContext context;
    helix::Pipeline pipeline(&context, HELIX_ARCH_X86_64);
    auto parsed = pipeline.parseLLVMIR(fixture("unknown_entry")); ASSERT_TRUE(parsed.has_value());
    auto module = pipeline.translateToMLIR(std::move(*parsed)); ASSERT_TRUE(module.has_value());
    mlir::PassManager manager(&context);
    manager.addPass(helix::createRemillToHelixLowPass());
    EXPECT_TRUE(mlir::failed(manager.run(**module)));
}

TEST(EntryIdentity, FreshNamedFixtureExportsHastThroughCAbi) {
    const char* input = std::getenv("HELIX_ENTRY_TEST_IR");
    const char* destination = std::getenv("HELIX_ENTRY_TEST_HAST");
    if (!input || !destination) GTEST_SKIP() << "optional fresh producer fixture";
    std::ifstream stream(input, std::ios::binary);
    ASSERT_TRUE(stream.good());
    std::string ir{std::istreambuf_iterator<char>(stream), std::istreambuf_iterator<char>()};
    std::unique_ptr<HelixEngineHandle, decltype(&helix_engine_destroy)> engine(
        helix_engine_create(HELIX_ARCH_X86_64), helix_engine_destroy);
    ASSERT_TRUE(engine);
    helix_engine_set_use_cast_layer(engine.get(), 1);
    HelixCombinedDecompileOutput output{};
    ASSERT_EQ(helix_engine_decompile_ir_combined(engine.get(), ir.data(), ir.size(), &output), HELIX_OK);
    EXPECT_EQ(output.function_count, 1u);
    EXPECT_GT(output.flatbuffer_len, 8u);
    std::ofstream written(destination, std::ios::binary);
    written.write(reinterpret_cast<const char*>(output.flatbuffer), output.flatbuffer_len);
    EXPECT_TRUE(written.good());
    helix_engine_free_decompile_output(&output);
}
} // namespace
