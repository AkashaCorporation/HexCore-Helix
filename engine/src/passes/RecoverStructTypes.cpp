/// @file RecoverStructTypes.cpp
/// @brief MLIR pass: recover struct types from memory access patterns.
///
/// Walks HelixMid load and store operations, identifies accesses through a
/// base pointer at constant offsets, feeds them to the StructRecoveryAnalyzer,
/// and annotates var.decl operations with recovered struct layout information.
///
/// ## Pattern Recognized
///
///   helix_mid.load (helix_mid.binexpr Add (helix_mid.var.ref base),
///                                         (helix_mid.constant offset))
///
///   helix_mid.store value to (helix_mid.binexpr Add ...)
///
/// ## References
///
///   - Mycroft, "Type-Based Decompilation" (ESOP 1999)
///   - van Emmerik, "Using a Decompiler for Real-World Source Recovery" (2004)

#include "helix/passes/Passes.h"
#include "helix/analysis/TypeEvidence.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixMidOps.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/analysis/StructRecovery.h"
#include "helix/analysis/TypeLattice.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#include <cstdint>
#include <cstdlib>
#include <format>
#include <optional>
#include <string>

#define DEBUG_TYPE "recover-struct-types"

using namespace mlir;
using namespace helix;

STATISTIC(NumStructsRecovered,   "Number of struct types recovered");
STATISTIC(NumFieldsRecovered,    "Number of struct fields recovered");
STATISTIC(NumUnionCandidates,    "Number of union candidates detected");
STATISTIC(NumDynamicArrays,      "Number of dynamic array accesses detected");

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════════════════════════

/// Extract integer constant from a mid::ConstantOp.
static std::optional<int64_t> extractConstant(Value val) {
    if (auto constOp = val.getDefiningOp<mid::ConstantOp>())
        return constOp.getValue();
    return std::nullopt;
}

/// Decompose an address value into (base_var_slot_id, constant_offset).
///
/// Recognizes:
///   binexpr Add (var.ref slot), (constant offset)
///   binexpr Add (constant offset), (var.ref slot)
///
/// Returns std::nullopt if the address is not in the expected form.
struct BaseOffset {
    uint32_t base_slot;
    int64_t offset;
};

static std::optional<BaseOffset> decomposeAddress(Value addr) {
    // FIX (Maya R. review, type-recovery trace): FIX-082 (HelixLowToMid) lifts
    // `llvm.add(base, const)` into a dedicated `mid::FieldPtrOp(base, offset)`
    // BEFORE the Load/StoreOp is constructed, so on real post-FIX-082 IR the
    // addr operand here is almost always a FieldPtrOp result, never the raw
    // BinExprOp this function originally matched -- that staleness is why
    // struct recovery never fired on the NUCLEO corpus (0/879 `auto_struct`
    // occurrences) despite the analyzer/serialization being otherwise sound.
    // FieldPtrOp carries (base, field_offset) directly, no decomposition needed.
    if (auto fieldPtr = addr.getDefiningOp<mid::FieldPtrOp>()) {
        // Variable recovery (RecoverVariablesPass) runs BEFORE HelixLowToMid and
        // represents named variables/parameters as helix::high::VarRefOp
        // regardless of which pipeline tier the surrounding ops belong to -- so
        // a mid::FieldPtrOp's base is a HIGH-dialect VarRefOp, not a mid one.
        if (auto varRef = fieldPtr.getBase().getDefiningOp<helix::high::VarRefOp>()) {
            return BaseOffset{varRef.getVarId(),
                              static_cast<int64_t>(fieldPtr.getFieldOffset())};
        }
        if (auto varRef =
                fieldPtr.getBase().getDefiningOp<helix::mid::VarRefOp>()) {
            return BaseOffset{varRef.getSlotId(),
                              static_cast<int64_t>(fieldPtr.getFieldOffset())};
        }
        // A nested field.ptr base (chained field access, e.g. `p->pos.x`) is
        // not yet handled -- fall through to std::nullopt rather than mis-key it.
        return std::nullopt;
    }

    auto binExpr = addr.getDefiningOp<mid::BinExprOp>();
    if (!binExpr || binExpr.getKind() != mid::BinExprKind::Add)
        return std::nullopt;

    // Try: Add(var.ref, constant)
    if (auto varRef = binExpr.getLhs().getDefiningOp<mid::VarRefOp>()) {
        if (auto offset = extractConstant(binExpr.getRhs())) {
            return BaseOffset{varRef.getSlotId(), *offset};
        }
    }

    // Try: Add(constant, var.ref)
    if (auto varRef = binExpr.getRhs().getDefiningOp<mid::VarRefOp>()) {
        if (auto offset = extractConstant(binExpr.getLhs())) {
            return BaseOffset{varRef.getSlotId(), *offset};
        }
    }

    return std::nullopt;
}

/// Decompose an address into a dynamic array access pattern.
///
/// Recognizes:
///   Add(var.ref base, Mul(var.ref index, constant stride))
///   Add(var.ref base, Mul(constant stride, var.ref index))
///   Add(Mul(...), var.ref base)
///   Add(var.ref base, Shl(var.ref index, constant shift))
///   Add(Add(var.ref base, constant offset), Mul(var.ref index, constant stride))
///
/// Returns std::nullopt if not an array access pattern.
struct ArrayAccess {
    uint32_t base_slot;
    uint32_t index_slot;   ///< Variable used as array index
    int64_t stride;        ///< Element size in bytes
    int64_t base_offset;   ///< Constant offset from base (for struct+array: s->arr[i])
};

static std::optional<ArrayAccess> decomposeArrayAccess(Value addr) {
    auto outerAdd = addr.getDefiningOp<mid::BinExprOp>();
    if (!outerAdd || outerAdd.getKind() != mid::BinExprKind::Add)
        return std::nullopt;

    // Try each side as the stride-computation (Mul or Shl) and the other as base.
    for (int side = 0; side < 2; ++side) {
        Value strideSide = (side == 0) ? outerAdd.getRhs() : outerAdd.getLhs();
        Value baseSide   = (side == 0) ? outerAdd.getLhs() : outerAdd.getRhs();

        auto mulOp = strideSide.getDefiningOp<mid::BinExprOp>();
        if (!mulOp)
            continue;

        // ── Extract (index_var, stride) from Mul or Shl ──────────────
        uint32_t indexSlot = 0;
        int64_t stride = 0;
        bool found = false;

        if (mulOp.getKind() == mid::BinExprKind::Mul) {
            // Mul(var.ref, constant) or Mul(constant, var.ref)
            if (auto idxRef = mulOp.getLhs().getDefiningOp<mid::VarRefOp>()) {
                if (auto s = extractConstant(mulOp.getRhs())) {
                    indexSlot = idxRef.getSlotId();
                    stride = *s;
                    found = true;
                }
            }
            if (!found) {
                if (auto idxRef = mulOp.getRhs().getDefiningOp<mid::VarRefOp>()) {
                    if (auto s = extractConstant(mulOp.getLhs())) {
                        indexSlot = idxRef.getSlotId();
                        stride = *s;
                        found = true;
                    }
                }
            }
        } else if (mulOp.getKind() == mid::BinExprKind::Shl) {
            // Shl(var.ref, constant) → stride = 1 << constant
            if (auto idxRef = mulOp.getLhs().getDefiningOp<mid::VarRefOp>()) {
                if (auto shift = extractConstant(mulOp.getRhs())) {
                    if (*shift >= 0 && *shift <= 6) {  // max stride = 64
                        indexSlot = idxRef.getSlotId();
                        stride = int64_t(1) << *shift;
                        found = true;
                    }
                }
            }
        }

        if (!found || stride <= 0)
            continue;

        // ── Extract base: direct var.ref or Add(var.ref, constant) ───
        if (auto baseRef = baseSide.getDefiningOp<mid::VarRefOp>()) {
            return ArrayAccess{baseRef.getSlotId(), indexSlot, stride, 0};
        }

        // Nested: Add(var.ref base, constant offset) + Mul(index, stride)
        // This is the struct+array pattern: s->arr[i]
        if (auto innerAdd = baseSide.getDefiningOp<mid::BinExprOp>()) {
            if (innerAdd.getKind() == mid::BinExprKind::Add) {
                if (auto baseRef = innerAdd.getLhs().getDefiningOp<mid::VarRefOp>()) {
                    if (auto off = extractConstant(innerAdd.getRhs())) {
                        return ArrayAccess{baseRef.getSlotId(), indexSlot,
                                           stride, *off};
                    }
                }
                if (auto baseRef = innerAdd.getRhs().getDefiningOp<mid::VarRefOp>()) {
                    if (auto off = extractConstant(innerAdd.getLhs())) {
                        return ArrayAccess{baseRef.getSlotId(), indexSlot,
                                           stride, *off};
                    }
                }
            }
        }
    }

    return std::nullopt;
}

/// Determine the access width in bytes from an MLIR type.
static unsigned getAccessWidth(Type type) {
    if (auto intTy = dyn_cast<IntegerType>(type))
        return intTy.getWidth() / 8;
    if (auto floatTy = dyn_cast<FloatType>(type))
        return floatTy.getWidth() / 8;
    // Default: assume pointer-width (8 bytes on x86-64).
    return 8;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Definition
// ═══════════════════════════════════════════════════════════════════════════════

struct RecoverStructTypesPass
    : public PassWrapper<RecoverStructTypesPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RecoverStructTypesPass)

    StringRef getArgument() const final { return "recover-struct-types"; }
    StringRef getDescription() const final {
        return "Recover struct types from base+offset memory access patterns";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<mid::HelixMidDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();

        // FIX (Maya R. review, type-recovery trace): this pass walked for
        // `mid::FuncOp`, but HelixLowToMid marks `low::FuncOp` as a LEGAL
        // (unconverted) op -- the function CONTAINER never becomes mid::FuncOp,
        // only the ops inside its body get rewritten to the Mid dialect.
        // `mid::FuncOp` is defined in the dialect but never instantiated by
        // this pipeline, so the old walk matched zero functions, unconditionally,
        // on every input -- the root cause (one layer deeper than the stale
        // decomposeAddress pattern above) of struct recovery never firing.
        module.walk([&](helix::low::FuncOp func) {
            recoverStructsInFunction(func);
        });
    }

private:
    void recoverStructsInFunction(helix::low::FuncOp func) {
        auto& body = func.getBody();
        if (body.empty())
            return;

        LLVM_DEBUG(llvm::dbgs() << "RecoverStructTypes: processing '"
                                << func.getSymName() << "'\n");

        StructRecoveryAnalyzer analyzer;

        // ── Phase 1: Collect access patterns from load ops ───────────────
        body.walk([&](mid::LoadOp loadOp) {
            // Try constant-offset first (struct field access).
            if (auto decomposed = decomposeAddress(loadOp.getAddr())) {
                AccessPattern pattern;
                pattern.base_var_id = decomposed->base_slot;
                pattern.offset = decomposed->offset;
                pattern.access_width = getAccessWidth(loadOp.getResult().getType());
                pattern.is_write = false;
                analyzer.addAccess(pattern);
                return;
            }

            // Try dynamic array pattern: *(base + index * stride).
            if (auto arr = decomposeArrayAccess(loadOp.getAddr())) {
                AccessPattern pattern;
                pattern.base_var_id = arr->base_slot;
                pattern.offset = arr->base_offset;
                pattern.access_width = getAccessWidth(loadOp.getResult().getType());
                pattern.is_write = false;
                pattern.is_dynamic_array = true;
                pattern.stride = arr->stride;
                pattern.index_var_id = arr->index_slot;
                analyzer.addAccess(pattern);
                ++NumDynamicArrays;
            }
        });

        // ── Phase 2: Collect access patterns from store ops ──────────────
        body.walk([&](mid::StoreOp storeOp) {
            // Try constant-offset first (struct field access).
            if (auto decomposed = decomposeAddress(storeOp.getAddr())) {
                AccessPattern pattern;
                pattern.base_var_id = decomposed->base_slot;
                pattern.offset = decomposed->offset;
                pattern.access_width = getAccessWidth(storeOp.getValue().getType());
                pattern.is_write = true;
                analyzer.addAccess(pattern);
                return;
            }

            // Try dynamic array pattern: *(base + index * stride).
            if (auto arr = decomposeArrayAccess(storeOp.getAddr())) {
                AccessPattern pattern;
                pattern.base_var_id = arr->base_slot;
                pattern.offset = arr->base_offset;
                pattern.access_width = getAccessWidth(storeOp.getValue().getType());
                pattern.is_write = true;
                pattern.is_dynamic_array = true;
                pattern.stride = arr->stride;
                pattern.index_var_id = arr->index_slot;
                analyzer.addAccess(pattern);
                ++NumDynamicArrays;
            }
        });

        // ── Phase 3: Analyze and recover struct layouts ──────────────────
        auto structs = analyzer.analyze();

        if (structs.empty())
            return;

        // ── Phase 4: Annotate var.decl ops ───────────────────────────────
        //
        // FIX (Maya R. review, type-recovery trace): this used to be a
        // heuristic re-derivation (re-walk loads/stores, count accesses per
        // slot, POSITIONALLY match the Nth struct to the Nth most-accessed
        // slot) because the analyzer didn't expose which base_var_id each
        // RecoveredStruct came from -- the code's own comments admitted this
        // ("heuristic match", "cannot trivially match"), and it silently
        // mismatched whenever a function had >1 struct or any non-struct
        // (single-offset) pointer accesses mixed in. `RecoveredStruct` now
        // carries `base_var_id` directly (set in StructRecoveryAnalyzer::
        // buildStruct), so the mapping is a direct, exact O(n) build.
        llvm::DenseMap<uint32_t, const RecoveredStruct*> varToStruct;
        for (const auto& s : structs)
            varToStruct[s.base_var_id] = &s;

        auto annotateDecl = [&](Operation* declOp, uint32_t identity) {
            auto it = varToStruct.find(identity);
            if (it == varToStruct.end())
                return;

            const auto* recovered = it->second;
            declOp->setAttr("helix.struct_name",
                            StringAttr::get(declOp->getContext(),
                                            recovered->name));
            helix::applyTypeEvidence(
                declOp, recovered->name + "*",
                helix::TypeEvidenceSource::Structural);
            declOp->setAttr("helix.struct_size",
                            IntegerAttr::get(
                                IntegerType::get(declOp->getContext(), 32),
                                recovered->total_size));
            declOp->setAttr("helix.struct_align",
                            IntegerAttr::get(
                                IntegerType::get(declOp->getContext(), 32),
                                recovered->alignment));
            declOp->setAttr("helix.struct_field_count",
                            IntegerAttr::get(
                                IntegerType::get(declOp->getContext(), 32),
                                recovered->fields.size()));
            if (!recovered->fields.empty()) {
                std::string encoded;
                for (const auto& f : recovered->fields) {
                    if (!encoded.empty())
                        encoded += ',';
                    encoded += std::to_string(f.offset) + ':' +
                               std::to_string(f.size) + ':' +
                               f.type.toCTypeString();
                }
                declOp->setAttr("helix.struct_fields",
                                StringAttr::get(declOp->getContext(), encoded));
            }
            if (recovered->has_overlaps) {
                declOp->setAttr("helix.is_union_candidate",
                                BoolAttr::get(declOp->getContext(), true));
            }
        };

        // Compatibility lane contains High declarations; the normalized lane
        // carries the same storage identities as Mid slots.
        body.walk([&](helix::high::VarDeclOp declOp) {
            annotateDecl(declOp, declOp.getVarId());
        });
        body.walk([&](helix::mid::VarDeclOp declOp) {
            annotateDecl(declOp, declOp.getSlotId());
        });

        // ── Phase 5: Emit diagnostics ────────────────────────────────────
        for (const auto& s : structs) {
            LLVM_DEBUG({
                llvm::dbgs() << "  Recovered: " << s.name
                             << " (" << s.total_size << " bytes, "
                             << s.alignment << "-byte aligned, "
                             << s.fields.size() << " fields";
                if (s.has_overlaps)
                    llvm::dbgs() << ", UNION CANDIDATE";
                llvm::dbgs() << ")\n";

                for (const auto& f : s.fields) {
                    llvm::dbgs() << "    +" << f.offset << ": "
                                 << f.name << " ("
                                 << f.size << " bytes, "
                                 << f.access_count << " accesses)\n";
                }
            });

            ++NumStructsRecovered;
            NumFieldsRecovered += static_cast<unsigned>(s.fields.size());
            if (s.has_overlaps)
                ++NumUnionCandidates;
        }
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createRecoverStructTypesPass() {
    return std::make_unique<RecoverStructTypesPass>();
}
