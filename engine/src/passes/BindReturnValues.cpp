/// @file BindReturnValues.cpp
/// @brief Materialize recovered return-variable identity at function exits.

#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowOps.h"
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
            func.walk([&](helix::high::VarDeclOp decl) {
                if (decl.getVarName() == "result")
                    resultDecls.try_emplace(decl.getVarId(), decl);
            });

            if (resultDecls.size() != 1) {
                if (!resultDecls.empty())
                    ++NumAmbiguousFunctions;
                return;
            }

            helix::high::VarDeclOp resultDecl = resultDecls.begin()->second;
            SmallVector<helix::low::RetOp, 4> returns;
            func.walk([&](helix::low::RetOp ret) { returns.push_back(ret); });

            for (helix::low::RetOp ret : returns) {
                OpBuilder builder(ret);
                auto resultRef = builder.create<helix::high::VarRefOp>(
                    ret.getLoc(), builder.getI64Type(), resultDecl.getVarId(),
                    resultDecl.getVarNameAttr(), ret.getAddressAttr());

                if (Attribute inferredType = resultDecl->getAttr("inferred_type"))
                    resultRef->setAttr("inferred_type", inferredType);

                auto explicitReturn = builder.create<helix::high::ReturnOp>(
                    ret.getLoc(), resultRef.getResult(), ret.getAddressAttr());
                explicitReturn->setAttr(
                    "helix.return_binding",
                    builder.getStringAttr("canonical-result-var-id"));
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
