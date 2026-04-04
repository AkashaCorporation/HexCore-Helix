/// @file EscapeAnalysis.cpp
/// @brief MLIR pass: escape analysis for HelixMid variables.
///
/// EscapeAnalysis marks each helix_mid.var.decl with an attribute
/// "helix.escapes" = true/false based on whether the variable's address
/// is ever taken (AddrOf) or passed to a function call.
///
/// Non-escaping variables are safe for pure SSA treatment with no aliasing
/// concerns, enabling more aggressive dead code elimination.
///
/// ## Algorithm
///
///   1. Walk all `helix_mid.unexpr` ops with kind `AddrOf`
///   2. If the operand is a `var.ref`, mark that variable ID as escaping
///   3. Walk all `helix_mid.call` ops — if any argument comes from an `AddrOf`,
///      the source variable escapes
///   4. Walk all `helix_mid.store` ops — if the stored value comes from an
///      `AddrOf`, the source variable escapes
///   5. Set `helix.escapes` BoolAttr on each `helix_mid.var.decl`
///
/// ## References
///
///   - Choi et al., "Escape Analysis for Java" (OOPSLA 1999)
///   - Cooper & Torczon, "Engineering a Compiler", Ch. 13 (Alias Analysis)

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixMidOps.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#include <cstdint>

#define DEBUG_TYPE "escape-analysis"

using namespace mlir;
using namespace helix;

STATISTIC(NumVarsAnalyzed,    "Number of variables analyzed");
STATISTIC(NumVarsEscaping,    "Number of variables that escape");
STATISTIC(NumVarsNonEscaping, "Number of variables that do not escape");
STATISTIC(NumPtrArithEscapes, "Number of variables escaping via pointer arithmetic");
STATISTIC(NumIndirectCallEscapes, "Number of variables escaping due to indirect calls");

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════════════════════════

/// Trace an SSA value back through an AddrOf unary expression to find the
/// source variable slot ID.  Returns std::nullopt if the value does not
/// originate from an AddrOf(var.ref).
static std::optional<uint32_t> traceAddrOfToVarSlot(Value val) {
    auto unExpr = val.getDefiningOp<mid::UnExprOp>();
    if (!unExpr || unExpr.getKind() != mid::UnExprKind::AddrOf)
        return std::nullopt;

    auto varRef = unExpr.getOperand().getDefiningOp<mid::VarRefOp>();
    if (!varRef)
        return std::nullopt;

    return varRef.getSlotId();
}

/// Trace an SSA value through pointer arithmetic (BinExpr Add/Sub with a
/// var.ref operand) to find the base variable slot ID.  This detects the
/// common pattern:  var.ref(slot) + constant_offset  (struct field access).
///
/// Reference: Osprey/XTRIDE heuristic — pointer arithmetic on function
/// parameters implies struct manipulation and potential aliasing.
static std::optional<uint32_t> tracePtrArithToVarSlot(Value val) {
    // Direct var.ref
    if (auto varRef = val.getDefiningOp<mid::VarRefOp>())
        return varRef.getSlotId();

    // BinExpr(Add/Sub, var.ref, constant) — pointer + offset → struct access
    if (auto binExpr = val.getDefiningOp<mid::BinExprOp>()) {
        auto kind = binExpr.getKind();
        if (kind == mid::BinExprKind::Add || kind == mid::BinExprKind::Sub) {
            // Check LHS for var.ref
            if (auto lhsRef = binExpr.getLhs().getDefiningOp<mid::VarRefOp>())
                return lhsRef.getSlotId();
            // Check RHS for var.ref (commutative Add)
            if (kind == mid::BinExprKind::Add) {
                if (auto rhsRef = binExpr.getRhs().getDefiningOp<mid::VarRefOp>())
                    return rhsRef.getSlotId();
            }
            // Recursive: (var.ref + K1) + K2 — nested struct offset
            auto lhsSlot = tracePtrArithToVarSlot(binExpr.getLhs());
            if (lhsSlot.has_value())
                return lhsSlot;
            if (kind == mid::BinExprKind::Add) {
                auto rhsSlot = tracePtrArithToVarSlot(binExpr.getRhs());
                if (rhsSlot.has_value())
                    return rhsSlot;
            }
        }
    }

    // CastOp wrapping a var.ref or arithmetic — (type)(var.ref + offset)
    if (auto castOp = val.getDefiningOp<mid::CastOp>())
        return tracePtrArithToVarSlot(castOp.getInput());

    return std::nullopt;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Definition
// ═══════════════════════════════════════════════════════════════════════════════

struct EscapeAnalysisPass
    : public PassWrapper<EscapeAnalysisPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(EscapeAnalysisPass)

    StringRef getArgument() const final { return "escape-analysis"; }
    StringRef getDescription() const final {
        return "Analyze which HelixMid variables have their address taken "
               "(escape) and annotate var.decl with helix.escapes attribute";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<mid::HelixMidDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();

        module.walk([&](mid::FuncOp func) {
            analyzeFunction(func);
        });
    }

private:
    /// Run escape analysis on a single function.
    void analyzeFunction(mid::FuncOp func) {
        auto& body = func.getBody();
        if (body.empty())
            return;

        LLVM_DEBUG(llvm::dbgs() << "EscapeAnalysis: processing '"
                                << func.getSymName() << "'\n");

        // Set of variable slot IDs that escape.
        llvm::DenseSet<uint32_t> escapingSlots;

        // ── Phase 1: Walk all AddrOf unary expressions ───────────────────
        //
        // Any variable whose address is taken via &var is potentially
        // escaping.  We mark it immediately.
        body.walk([&](mid::UnExprOp unExpr) {
            if (unExpr.getKind() != mid::UnExprKind::AddrOf)
                return;

            auto varRef = unExpr.getOperand().getDefiningOp<mid::VarRefOp>();
            if (!varRef)
                return;

            uint32_t slotId = varRef.getSlotId();
            if (escapingSlots.insert(slotId).second) {
                LLVM_DEBUG(llvm::dbgs() << "  Slot " << slotId
                                        << " escapes via AddrOf\n");
            }
        });

        // ── Phase 2: Walk all call ops ───────────────────────────────────
        //
        // If any argument to a call is the result of an AddrOf, the source
        // variable escapes (the callee might store or alias the pointer).
        body.walk([&](mid::CallOp callOp) {
            for (auto arg : callOp.getArgs()) {
                auto slotId = traceAddrOfToVarSlot(arg);
                if (slotId.has_value()) {
                    if (escapingSlots.insert(*slotId).second) {
                        LLVM_DEBUG(llvm::dbgs()
                            << "  Slot " << *slotId
                            << " escapes via call argument\n");
                    }
                }
            }
        });

        // ── Phase 3: Walk all store ops ──────────────────────────────────
        //
        // If the stored value is a pointer derived from AddrOf, the source
        // variable escapes (the pointer is now in memory and may be loaded
        // and aliased anywhere).
        body.walk([&](mid::StoreOp storeOp) {
            auto slotId = traceAddrOfToVarSlot(storeOp.getValue());
            if (slotId.has_value()) {
                if (escapingSlots.insert(*slotId).second) {
                    LLVM_DEBUG(llvm::dbgs()
                        << "  Slot " << *slotId
                        << " escapes via store of address\n");
                }
            }
        });

        // ── Phase 4: Pointer arithmetic escape (Osprey heuristic) ───────
        //
        // If a store or load uses an address derived from pointer arithmetic
        // on a variable (var.ref + offset → struct field access), mark that
        // variable as escaping.  This prevents DCE from eliminating stores
        // to struct fields accessed through function parameters:
        //
        //   store value to (param_2 + 0x68)   ← list_head manipulation
        //   load (param_1 + 0x30)              ← struct field read
        //
        // Without this, DCE treats these as dead stores because it doesn't
        // understand that the pointed-to memory is externally visible.
        //
        // Reference: Osprey/XTRIDE type-based alias analysis.
        body.walk([&](mid::StoreOp storeOp) {
            auto slotId = tracePtrArithToVarSlot(storeOp.getAddr());
            if (slotId.has_value()) {
                if (escapingSlots.insert(*slotId).second) {
                    LLVM_DEBUG(llvm::dbgs()
                        << "  Slot " << *slotId
                        << " escapes via ptr-arith store (struct write)\n");
                    ++NumPtrArithEscapes;
                }
            }
        });
        body.walk([&](mid::LoadOp loadOp) {
            auto slotId = tracePtrArithToVarSlot(loadOp.getAddr());
            if (slotId.has_value()) {
                if (escapingSlots.insert(*slotId).second) {
                    LLVM_DEBUG(llvm::dbgs()
                        << "  Slot " << *slotId
                        << " escapes via ptr-arith load (struct read)\n");
                    ++NumPtrArithEscapes;
                }
            }
        });

        // ── Phase 5: Indirect call protection (Anti-DCE blindagem) ──────
        //
        // If ANY indirect call exists in the function, the callee is unknown
        // at decompile time and could read or write any memory reachable
        // through the function's parameters.  Conservatively mark ALL
        // parameter-derived variables as escaping.
        //
        // Detection: mid::CallOp with "is_indirect" unit attribute.
        //
        // This prevents the enhanced DCE (P2.10) from removing stores that
        // set up arguments for indirect calls or manipulate globally-visible
        // data structures (linked lists, device registers, etc.).
        {
            bool hasIndirectCall = false;
            body.walk([&](mid::CallOp callOp) {
                if (callOp->hasAttr("is_indirect"))
                    hasIndirectCall = true;
            });

            if (hasIndirectCall) {
                LLVM_DEBUG(llvm::dbgs()
                    << "  Function has indirect call(s) — marking all "
                    << "parameter slots as escaping\n");

                // Collect all VarDeclOp slots that represent function
                // parameters (typically the first N slots matching ABI).
                // Heuristic: mark ALL variables as escaping when indirect
                // calls exist, since the callee could access any reachable
                // memory through pointer arguments.
                body.walk([&](mid::VarDeclOp declOp) {
                    uint32_t slotId = declOp.getSlotId();
                    if (escapingSlots.insert(slotId).second) {
                        LLVM_DEBUG(llvm::dbgs()
                            << "  Slot " << slotId
                            << " escapes (indirect call protection)\n");
                        ++NumIndirectCallEscapes;
                    }
                });
            }
        }

        // ── Phase 6: Annotate var.decl ops ───────────────────────────────
        //
        // Set the "helix.escapes" BoolAttr on each var.decl based on
        // whether the slot was found in the escaping set.
        unsigned numAnalyzed = 0;
        unsigned numEscaping = 0;
        unsigned numNonEscaping = 0;

        body.walk([&](mid::VarDeclOp declOp) {
            ++numAnalyzed;

            uint32_t slotId = declOp.getSlotId();
            bool escapes = escapingSlots.contains(slotId);

            declOp->setAttr("helix.escapes",
                            BoolAttr::get(declOp.getContext(), escapes));

            if (escapes) {
                ++numEscaping;
                LLVM_DEBUG(llvm::dbgs()
                    << "  var.decl slot=" << slotId << " → ESCAPES\n");
            } else {
                ++numNonEscaping;
                LLVM_DEBUG(llvm::dbgs()
                    << "  var.decl slot=" << slotId << " → non-escaping\n");
            }
        });

        NumVarsAnalyzed    += numAnalyzed;
        NumVarsEscaping    += numEscaping;
        NumVarsNonEscaping += numNonEscaping;

        LLVM_DEBUG(llvm::dbgs()
            << "  Summary: " << numAnalyzed << " vars analyzed, "
            << numEscaping << " escaping, "
            << numNonEscaping << " non-escaping\n");
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createEscapeAnalysisPass() {
    return std::make_unique<EscapeAnalysisPass>();
}
