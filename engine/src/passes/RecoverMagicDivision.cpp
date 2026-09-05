/// @file RecoverMagicDivision.cpp
/// @brief MLIR pass: recovers division-by-constant from compiler-generated
///        magic number multiply+shift patterns.
///
/// Compilers replace `x / d` with `(x * magic) >> (N + s)` where N is the
/// operand width and s is an additional shift.  This optimization avoids the
/// expensive DIV instruction.  This pass reverses the transformation, detecting
/// the multiply+shift chain and replacing it with a clean division.
///
/// ## Patterns Detected
///
///   1. Direct chain:  `Shr(Mul(x, magic), shift)`
///   2. Two-step:      `Shr(Shr(Mul(x, magic), 32), s)`  (extract hi-half + shift)
///   3. Through slots: variable-assignment-bridged versions of the above
///
/// ## References
///
///   - Warren, "Hacker's Delight" (2012), Ch. 10 — Integer Division by Constants
///   - Granlund & Montgomery, "Division by Invariant Integers using Multiplication"
///     (PLDI 1994)

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixMidOps.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"

#include <cmath>
#include <cstdint>
#include <format>
#include <optional>

#define DEBUG_TYPE "recover-magic-division"

using namespace mlir;
using namespace helix;

STATISTIC(NumMagicDivRecovered, "Number of magic divisions recovered");
STATISTIC(NumMagicModRecovered, "Number of magic modulos recovered");

namespace {

static bool isMultiplyKind(mid::BinExprKind kind) {
    return kind == mid::BinExprKind::Mul ||
           kind == mid::BinExprKind::UMul ||
           kind == mid::BinExprKind::SMul;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Magic Number Reversal Algorithm
// ═══════════════════════════════════════════════════════════════════════════════

/// Information about a recovered magic division pattern.
struct MagicDivInfo {
    uint64_t magic;         ///< The magic multiplier constant
    unsigned total_shift;   ///< Total right-shift amount (including hi-half extraction)
    unsigned operand_bits;  ///< Width of the original operand (32 or 64)
    uint64_t divisor;       ///< The recovered divisor
    bool is_signed;         ///< Whether this was a signed division
};

/// Try to reverse a magic number multiplication to find the original divisor.
///
/// For unsigned division:  x / d = (x * m) >> (N + s)
///   where m = ceil(2^(N+s) / d), N = operand width, s = extra shift
///
/// Reversal: d = round(2^total_shift / magic)
///   then verify: magic == ceil(2^total_shift / d)
/// Compute (2^shift / divisor) using double-precision as an approximation
/// for cases where 128-bit integers are unavailable (MSVC).
static uint64_t approxPow2Div(unsigned shift, uint64_t divisor) {
    if (shift < 64)
        return (1ULL << shift) / divisor;
    // For shift >= 64, use floating-point approximation.
    double result = std::ldexp(1.0, shift) / (double)divisor;
    return (uint64_t)result;
}

/// Compute ceil(2^shift / divisor) approximately.
static uint64_t approxCeilPow2Div(unsigned shift, uint64_t divisor) {
    if (shift < 64) {
        uint64_t num = 1ULL << shift;
        return (num + divisor - 1) / divisor;
    }
    double result = std::ldexp(1.0, shift) / (double)divisor;
    return (uint64_t)std::ceil(result);
}

static std::optional<uint64_t>
reverseMagicNumber(uint64_t magic, unsigned total_shift,
                   unsigned operand_bits) {
    if (magic == 0 || total_shift == 0)
        return std::nullopt;

    // Compute candidate = round(2^total_shift / magic).
    // Use floating-point for shifts >= 64 (MSVC has no __uint128_t).
    uint64_t candidate;
    if (total_shift < 64) {
        candidate = (1ULL << total_shift) / magic;
    } else {
        double approx = std::ldexp(1.0, total_shift) / (double)magic;
        candidate = (uint64_t)(approx + 0.5);
    }

    if (candidate < 2 || candidate > (1ULL << operand_bits))
        return std::nullopt;

    // Verify: expected_magic = ceil(2^total_shift / candidate)
    uint64_t expected_magic = approxCeilPow2Div(total_shift, candidate);

    // Allow ±1 tolerance for rounding differences.
    if (expected_magic >= magic - 1 && expected_magic <= magic + 1)
        return candidate;

    // Also try candidate ± 1 (rounding ambiguity).
    for (uint64_t d : {candidate + 1, candidate - 1}) {
        if (d < 2) continue;
        uint64_t em = approxCeilPow2Div(total_shift, d);
        if (em >= magic - 1 && em <= magic + 1)
            return d;
    }

    return std::nullopt;
}

/// Known magic number → divisor table for common cases.
/// This provides an instant lookup for the most frequently seen patterns.
static std::optional<uint64_t>
lookupKnownMagic32(uint64_t magic, unsigned extra_shift) {
    // 32-bit unsigned division magic numbers (total_shift = 32 + extra_shift)
    struct KnownEntry {
        uint64_t magic;
        unsigned extra_shift;
        uint64_t divisor;
    };

    static const KnownEntry table[] = {
        // x / 3  : magic = 0xAAAAAAAB, shr 1
        {0xAAAAAAABULL, 1, 3},
        // x / 5  : magic = 0xCCCCCCCD, shr 2
        {0xCCCCCCCDULL, 2, 5},
        // x / 6  : magic = 0xAAAAAAAB, shr 2
        {0xAAAAAAABULL, 2, 6},
        // x / 7  : magic = 0x24924925, shr 0 (with fixup, complex pattern)
        {0x24924925ULL, 0, 7},
        // x / 9  : magic = 0x38E38E39, shr 1
        {0x38E38E39ULL, 1, 9},
        // x / 10 : magic = 0xCCCCCCCD, shr 3
        {0xCCCCCCCDULL, 3, 10},
        // x / 11 : magic = 0xBA2E8BA3, shr 3
        {0xBA2E8BA3ULL, 3, 11},
        // x / 12 : magic = 0xAAAAAAAB, shr 3
        {0xAAAAAAABULL, 3, 12},
        // x / 25 : magic = 0x51EB851F, shr 3
        {0x51EB851FULL, 3, 25},
        // x / 100: magic = 0x51EB851F, shr 5
        {0x51EB851FULL, 5, 100},
        // x / 1000: magic = 0x10624DD3, shr 6
        {0x10624DD3ULL, 6, 1000},
        // x / 255: magic = 0x80808081, shr 7
        {0x80808081ULL, 7, 255},
        // x / 256: just shift, no magic needed
    };

    for (const auto& entry : table) {
        if (entry.magic == magic && entry.extra_shift == extra_shift)
            return entry.divisor;
    }
    return std::nullopt;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Helper: Extract integer constant from a mid::ConstantOp
// ═══════════════════════════════════════════════════════════════════════════════

static std::optional<int64_t> extractConstant(Value val) {
    if (auto constOp = val.getDefiningOp<mid::ConstantOp>())
        return constOp.getValue();
    return std::nullopt;
}

/// Try to trace a value through a VarRef → Assign chain to find the
/// defining expression.  Returns the assigned value, or nullptr.
static Value traceVarRefToAssign(Value val) {
    auto varRef = val.getDefiningOp<mid::VarRefOp>();
    if (!varRef)
        return nullptr;

    uint32_t slot_id = varRef.getSlotId();

    // Walk backwards to find the most recent Assign to this slot.
    // We look in the same block and preceding blocks.
    Operation* refOp = varRef.getOperation();
    Block* block = refOp->getBlock();
    if (!block)
        return nullptr;

    // Search backwards in the current block.
    for (auto it = Block::reverse_iterator(refOp->getIterator());
         it != block->rend(); ++it) {
        if (auto assign = dyn_cast<mid::AssignOp>(&*it)) {
            if (assign.getSlotId() == slot_id)
                return assign.getValue();
        }
    }

    return nullptr;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Definition
// ═══════════════════════════════════════════════════════════════════════════════

struct RecoverMagicDivisionPass
    : public PassWrapper<RecoverMagicDivisionPass, OperationPass<ModuleOp>>
{
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RecoverMagicDivisionPass)

    StringRef getArgument() const final { return "recover-magic-division"; }
    StringRef getDescription() const final {
        return "Recover division-by-constant from magic number multiply+shift";
    }

    void runOnOperation() override {
        auto module = getOperation();

        module.walk([&](mid::BinExprOp outerShr) {
            // Match: BinExpr(Shr, inner, shift_const)
            if (outerShr.getKind() != mid::BinExprKind::Shr &&
                outerShr.getKind() != mid::BinExprKind::Sar)
                return;

            auto shiftConst = extractConstant(outerShr.getRhs());
            if (!shiftConst || *shiftConst <= 0)
                return;

            Value mulLhs;    // The original dividend
            Value mulResult; // The Mul op result
            uint64_t magic = 0;
            unsigned total_shift = 0;
            bool is_signed = (outerShr.getKind() == mid::BinExprKind::Sar);

            // ── Pattern 1: Direct chain Shr(Mul(x, magic), shift) ───────
            if (auto mulOp = outerShr.getLhs().getDefiningOp<mid::BinExprOp>()) {
                if (isMultiplyKind(mulOp.getKind())) {
                    auto magicConst = extractConstant(mulOp.getRhs());
                    if (magicConst && *magicConst > 1) {
                        mulLhs = mulOp.getLhs();
                        mulResult = mulOp.getResult();
                        magic = (uint64_t)*magicConst;
                        total_shift = (unsigned)*shiftConst;
                    }
                }

                // ── Pattern 2: Two-step Shr(Shr(Mul(x, magic), 32), s) ─
                if (!mulLhs &&
                    (mulOp.getKind() == mid::BinExprKind::Shr ||
                     mulOp.getKind() == mid::BinExprKind::Sar)) {
                    auto innerShift = extractConstant(mulOp.getRhs());
                    if (innerShift && (*innerShift == 32 || *innerShift == 64)) {
                        if (auto innerMul = mulOp.getLhs().getDefiningOp<mid::BinExprOp>()) {
                            if (isMultiplyKind(innerMul.getKind())) {
                                auto magicConst = extractConstant(innerMul.getRhs());
                                if (magicConst && *magicConst > 1) {
                                    mulLhs = innerMul.getLhs();
                                    mulResult = innerMul.getResult();
                                    magic = (uint64_t)*magicConst;
                                    total_shift = (unsigned)(*innerShift + *shiftConst);
                                }
                            }
                        }
                    }
                }
            }

            // ── Pattern 3: Through variable slot ────────────────────────
            // Shr(VarRef(slot_X), shift) where slot_X was assigned from
            // Shr(Mul(x, magic), 32)
            if (!mulLhs) {
                Value traced = traceVarRefToAssign(outerShr.getLhs());
                if (traced) {
                    if (auto innerShr = traced.getDefiningOp<mid::BinExprOp>()) {
                        if (innerShr.getKind() == mid::BinExprKind::Shr ||
                            innerShr.getKind() == mid::BinExprKind::Sar) {
                            auto innerShift = extractConstant(innerShr.getRhs());
                            if (innerShift && (*innerShift == 32 || *innerShift == 64)) {
                                // Check if the inner Shr's LHS is a Mul
                                if (auto innerMul = innerShr.getLhs().getDefiningOp<mid::BinExprOp>()) {
                                    if (isMultiplyKind(innerMul.getKind())) {
                                        auto magicConst = extractConstant(innerMul.getRhs());
                                        if (magicConst && *magicConst > 1) {
                                            mulLhs = innerMul.getLhs();
                                            mulResult = innerMul.getResult();
                                            magic = (uint64_t)*magicConst;
                                            total_shift = (unsigned)(*innerShift + *shiftConst);
                                        }
                                    }
                                }
                            }
                        }
                        // Also handle: VarRef → Assign from Mul directly
                        // (for patterns where the Shr-by-32 is folded differently)
                        if (!mulLhs && isMultiplyKind(innerShr.getKind())) {
                            auto magicConst = extractConstant(innerShr.getRhs());
                            if (magicConst && *magicConst > 1) {
                                mulLhs = innerShr.getLhs();
                                mulResult = innerShr.getResult();
                                magic = (uint64_t)*magicConst;
                                total_shift = (unsigned)*shiftConst;
                            }
                        }
                    }
                }
            }

            if (!mulLhs || magic == 0)
                return;

            // Determine operand bit width from the multiply result type.
            unsigned operand_bits = 32;
            if (auto intTy = dyn_cast<IntegerType>(mulResult.getType()))
                operand_bits = intTy.getWidth();

            // ── Try known magic number table first ──────────────────────
            uint64_t divisor = 0;
            if (operand_bits <= 32 && total_shift >= 32) {
                auto known = lookupKnownMagic32(magic, total_shift - 32);
                if (known)
                    divisor = *known;
            }

            // ── Algorithmic reversal ────────────────────────────────────
            if (divisor == 0) {
                auto reversed = reverseMagicNumber(magic, total_shift, operand_bits);
                if (reversed)
                    divisor = *reversed;
            }

            if (divisor == 0)
                return;

            LLVM_DEBUG({
                llvm::dbgs() << "  Magic division: magic=0x"
                             << llvm::Twine::utohexstr(magic)
                             << " shift=" << total_shift
                             << " → divisor=" << divisor << "\n";
            });

            // ── Replace the Shr with a Div ──────────────────────────────
            OpBuilder builder(outerShr);
            auto loc = outerShr.getLoc();
            auto resultType = outerShr.getResult().getType();

            // Create the divisor constant.
            auto divisorConst = builder.create<mid::ConstantOp>(
                loc, resultType,
                builder.getI64IntegerAttr(divisor),
                /*address=*/mlir::IntegerAttr{}
            );

            // Create the division.
            auto divKind = is_signed
                ? mid::BinExprKind::SDiv
                : mid::BinExprKind::UDiv;
            auto divOp = builder.create<mid::BinExprOp>(
                loc, resultType,
                mid::BinExprKindAttr::get(builder.getContext(), divKind),
                mulLhs, divisorConst.getResult(),
                outerShr.getAddressAttr()
            );

            outerShr.getResult().replaceAllUsesWith(divOp.getResult());
            outerShr.erase();

            ++NumMagicDivRecovered;
        });

        // ── Phase 2: Detect modulo patterns ─────────────────────────────────
        // Pattern: x - (x / d) * d  →  x % d
        // This runs after division recovery, so the Div ops are already in place.
        module.walk([&](mid::BinExprOp subOp) {
            if (subOp.getKind() != mid::BinExprKind::Sub)
                return;

            // RHS should be Mul(Div(x, d), d)
            auto mulOp = subOp.getRhs().getDefiningOp<mid::BinExprOp>();
            if (!mulOp || !isMultiplyKind(mulOp.getKind()))
                return;

            auto divOp = mulOp.getLhs().getDefiningOp<mid::BinExprOp>();
            if (!divOp ||
                (divOp.getKind() != mid::BinExprKind::Div &&
                 divOp.getKind() != mid::BinExprKind::SDiv &&
                 divOp.getKind() != mid::BinExprKind::UDiv))
                return;

            // Check: sub.lhs == div.lhs (same dividend x)
            // Check: mul.rhs == div.rhs (same divisor d)
            if (subOp.getLhs() != divOp.getLhs())
                return;
            if (mulOp.getRhs() != divOp.getRhs())
                return;

            // Replace with Mod(x, d)
            OpBuilder builder(subOp);
            auto modOp = builder.create<mid::BinExprOp>(
                subOp.getLoc(), subOp.getResult().getType(),
                mid::BinExprKindAttr::get(builder.getContext(), mid::BinExprKind::Mod),
                subOp.getLhs(), divOp.getRhs(),
                subOp.getAddressAttr()
            );

            subOp.getResult().replaceAllUsesWith(modOp.getResult());
            subOp.erase();

            ++NumMagicModRecovered;
        });
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createRecoverMagicDivisionPass() {
    return std::make_unique<RecoverMagicDivisionPass>();
}
