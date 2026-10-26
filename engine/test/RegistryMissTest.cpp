/// @file RegistryMissTest.cpp
/// @brief Unit tests for the #30 registry-miss honest-failure object
///        (C-30registry). Verifies that under an AUTHORITATIVE function table
///        a stub-shaped function whose entry is NOT in the table is forced to
///        confidence 0 (registry miss), while an in-table stub keeps its
///        normal score, and that the mandatory entryAddr==0 guard holds.

#include "helix/cast/CAstBuilder.h"
#include "helix/cast/CAstOptimizer.h"
#include "helix/cast/CDecl.h"
#include "helix/cast/CType.h"
#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixHighOps.h"

#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"

#include <gtest/gtest.h>

#include <cstdint>
#include <vector>

using namespace helix::cast;

namespace {

// Self-entry of the stub function under test (an image-based win64 address).
constexpr uint64_t kSelfEntry = 0x140001000ull;
// A sibling/real function start that IS in the authoritative table.
constexpr uint64_t kOtherEntry = 0x140002000ull;

/// Builds a builtin ModuleOp containing a single stub-shaped high::FuncOp at
/// `entryAddr` (empty body -> stub: body.size()==0, opCount==0), and stamps
/// `helix.function_starts` from `tableEntries`. The caller owns the module via
/// the returned OwningOpRef. `outFunc` receives the high::FuncOp so it can be
/// fed to analyzeConfidence.
mlir::OwningOpRef<mlir::ModuleOp>
buildStubModule(mlir::MLIRContext& ctx, uint64_t entryAddr,
                const std::vector<int64_t>& tableEntries,
                mlir::Operation*& outFunc) {
    ctx.getOrLoadDialect<helix::high::HelixHighDialect>();
    mlir::OpBuilder builder(&ctx);
    auto loc = builder.getUnknownLoc();

    mlir::OwningOpRef<mlir::ModuleOp> module = mlir::ModuleOp::create(loc);
    if (!tableEntries.empty()) {
        module->getOperation()->setAttr(
            "helix.function_starts", builder.getI64ArrayAttr(tableEntries));
    }

    builder.setInsertionPointToEnd(module->getBody());
    auto func = builder.create<helix::high::FuncOp>(
        loc, /*sym_name=*/"sub_140001000", /*entry_address=*/entryAddr,
        builder.getFunctionType({}, {}),
        /*calling_convention=*/mlir::StringAttr{},
        /*is_variadic=*/mlir::UnitAttr{},
        /*arg_attrs=*/mlir::ArrayAttr{}, /*res_attrs=*/mlir::ArrayAttr{});
    // A single empty entry block -> stub-shaped (no statements, no ops).
    builder.createBlock(&func.getBody());
    outFunc = func.getOperation();
    return module;
}

/// Builds a stub-shaped CFuncDecl with the given entry address and empty body.
std::unique_ptr<CFuncDecl> makeStubDecl(uint64_t entryAddr) {
    return std::make_unique<CFuncDecl>(
        /*name=*/"sub_140001000", entryAddr, /*returnType=*/CType::int64());
}

} // namespace

// (a) AUTHORITATIVE table OMITTING the self-entry + stub FuncOp for the omitted
// address -> registryMissHonestFailure==true AND final confidenceScore==0.
TEST(RegistryMissTest, OmittedSelfEntryUnderAuthoritativeTableForcesZero) {
    mlir::MLIRContext ctx;
    mlir::Operation* funcOp = nullptr;
    // Table is authoritative (non-empty) but does NOT list kSelfEntry.
    auto module = buildStubModule(ctx, kSelfEntry,
                                  /*tableEntries=*/{(int64_t)kOtherEntry},
                                  funcOp);
    ASSERT_NE(funcOp, nullptr);

    CAstBuilder cab;
    // buildModule runs buildFunctionRegistry -> populates the authoritative set
    // (= {kOtherEntry}); it walks only low::FuncOp so returns no decls here.
    (void)cab.buildModule(*module);

    auto decl = makeStubDecl(kSelfEntry);
    cab.analyzeConfidence(*decl, funcOp);

    // analyzeConfidence raises the sticky flag (edit 7) but does not zero here.
    EXPECT_TRUE(decl->registryMissHonestFailure);

    CAstOptimizer opt;
    opt.reanalyzeConfidence(*decl);

    // reanalyzeConfidence (edit 8) is the surviving user-visible score.
    EXPECT_DOUBLE_EQ(decl->confidenceScore, 0.0);
    bool sawRegistryMiss = false;
    for (const auto& issue : decl->confidenceIssues) {
        if (issue.find("registry miss") != std::string::npos)
            sawRegistryMiss = true;
    }
    EXPECT_TRUE(sawRegistryMiss);
}

// (b) AUTHORITATIVE table INCLUDING the self-entry -> flag stays false AND the
// stub is capped at 50 by #56, but is NOT forced to registry-miss 0.
TEST(RegistryMissTest, InTableSelfEntryKeepsNormalStubScore) {
    mlir::MLIRContext ctx;
    mlir::Operation* funcOp = nullptr;
    auto module = buildStubModule(
        ctx, kSelfEntry,
        /*tableEntries=*/{(int64_t)kSelfEntry, (int64_t)kOtherEntry}, funcOp);
    ASSERT_NE(funcOp, nullptr);

    CAstBuilder cab;
    (void)cab.buildModule(*module);

    auto decl = makeStubDecl(kSelfEntry);
    cab.analyzeConfidence(*decl, funcOp);

    EXPECT_FALSE(decl->registryMissHonestFailure);
    // #56 applies the same final-AST empty-stub cap in the initial scorer.
    EXPECT_DOUBLE_EQ(decl->confidenceScore, 50.0);

    CAstOptimizer opt;
    opt.reanalyzeConfidence(*decl);

    // #56: an empty body contains no recovered behavior and cannot report
    // Medium/High even when its address is a valid registry entry.
    EXPECT_DOUBLE_EQ(decl->confidenceScore, 50.0);
    bool sawStubCap = false;
    for (const auto& issue : decl->confidenceIssues) {
        if (issue.find("stub/empty body") != std::string::npos)
            sawStubCap = true;
    }
    EXPECT_TRUE(sawStubCap);
}

// Mandatory guard (rag/13 3.3 revision 1): a FuncOp whose entry address is 0
// is structurally excluded from authoritativeFunctionStarts_, so the entryAddr
// != 0 guard must keep it from being flagged a registry miss even when the
// table is authoritative (funcOpCount>1 via the two table entries).
TEST(RegistryMissTest, EntryAddrZeroIsNeverForcedToZero) {
    mlir::MLIRContext ctx;
    mlir::Operation* funcOp = nullptr;
    auto module = buildStubModule(
        ctx, /*entryAddr=*/0,
        /*tableEntries=*/{(int64_t)kSelfEntry, (int64_t)kOtherEntry}, funcOp);
    ASSERT_NE(funcOp, nullptr);

    CAstBuilder cab;
    (void)cab.buildModule(*module);

    auto decl = makeStubDecl(/*entryAddr=*/0);
    cab.analyzeConfidence(*decl, funcOp);

    // entryAddr == 0 -> guard blocks the #30 branch; no registry miss.
    EXPECT_FALSE(decl->registryMissHonestFailure);

    CAstOptimizer opt;
    opt.reanalyzeConfidence(*decl);
    EXPECT_GT(decl->confidenceScore, 0.0);
}
