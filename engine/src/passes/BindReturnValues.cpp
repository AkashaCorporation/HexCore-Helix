/// @file BindReturnValues.cpp
/// @brief Materialize recovered return-variable identity at function exits.

#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/analysis/TypeEvidence.h"
#include "helix/passes/Passes.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"

#define DEBUG_TYPE "helix-bind-return-values"

using namespace mlir;

STATISTIC(NumReturnsBound,
          "Number of implicit returns bound to a recovered result variable");
STATISTIC(NumAmbiguousFunctions,
          "Number of return-valued functions skipped due to ambiguous result identities");

namespace {

struct BindReturnValuesPass
    : public PassWrapper<BindReturnValuesPass, OperationPass<ModuleOp>> {
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(BindReturnValuesPass)

    StringRef getArgument() const final { return "helix-bind-return-values"; }
    StringRef getDescription() const final {
        return "Bind implicit machine returns to an unambiguous recovered result";
    }

    void runOnOperation() override {
        getOperation().walk([&](helix::low::FuncOp func) {
            if (!func->hasAttr("has_return_value"))
                return;

            DenseMap<uint32_t, helix::high::VarDeclOp> resultDecls;
            DenseMap<uint32_t, helix::high::VarDeclOp> aapcsX0Decls;
            DenseMap<uint32_t, unsigned> referenceCounts;
            func.walk([&](helix::high::VarDeclOp decl) {
                if (decl.getVarName() == "result")
                    resultDecls.try_emplace(decl.getVarId(), decl);
                if (decl.getVarName() == "param_1")
                    aapcsX0Decls.try_emplace(decl.getVarId(), decl);
            });
            func.walk([&](helix::high::VarRefOp ref) {
                ++referenceCounts[ref.getVarId()];
            });

            helix::high::VarDeclOp resultDecl;
            StringRef bindingKind;
            if (resultDecls.size() == 1) {
                resultDecl = resultDecls.begin()->second;
                bindingKind = "canonical-result-var-id";
            } else if (!resultDecls.empty()) {
                ++NumAmbiguousFunctions;
                return;
            } else {
                auto cc = func->getAttrOfType<StringAttr>("calling_convention");
                if (!cc || cc.getValue() != "aapcs64")
                    return;

                SmallVector<helix::high::VarDeclOp, 2> liveX0Decls;
                for (auto [varId, decl] : aapcsX0Decls) {
                    if (referenceCounts.lookup(varId) != 0)
                        liveX0Decls.push_back(decl);
                }
                if (liveX0Decls.size() != 1) {
                    if (!liveX0Decls.empty())
                        ++NumAmbiguousFunctions;
                    return;
                }
                resultDecl = liveX0Decls.front();
                bindingKind = "aapcs64-live-x0-var-id";
            }

            if (!resultDecl) {
                if (!resultDecls.empty() || !aapcsX0Decls.empty())
                    ++NumAmbiguousFunctions;
                return;
            }

            SmallVector<helix::low::RetOp, 4> returns;
            func.walk([&](helix::low::RetOp ret) { returns.push_back(ret); });

            for (helix::low::RetOp ret : returns) {
                OpBuilder builder(ret);
                auto resultRef = builder.create<helix::high::VarRefOp>(
                    ret.getLoc(), builder.getI64Type(), resultDecl.getVarId(),
                    resultDecl.getVarNameAttr(), ret.getAddressAttr());

                helix::copyTypeEvidence(resultRef, resultDecl);

                auto explicitReturn = builder.create<helix::high::ReturnOp>(
                    ret.getLoc(), resultRef.getResult(), ret.getAddressAttr());
                explicitReturn->setAttr(
                    "helix.return_binding",
                    builder.getStringAttr(bindingKind));
                ret.erase();
                ++NumReturnsBound;
            }
        });
    }
};

} // namespace

std::unique_ptr<mlir::Pass> helix::createBindReturnValuesPass() {
    return std::make_unique<BindReturnValuesPass>();
}
