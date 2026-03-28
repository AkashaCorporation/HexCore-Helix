/// @file NonzeroMaskAnalysis.cpp
/// @brief Implementation of nonzero mask transfer functions.
///
/// Each transfer function computes a conservative over-approximation of
/// which bits in the result could possibly be nonzero, given the masks
/// of the input operands.

#include "helix/analysis/NonzeroMaskAnalysis.h"

#include <bit>

namespace helix {

// ═══════════════════════════════════════════════════════════════════════════════
// effectiveWidth
// ═══════════════════════════════════════════════════════════════════════════════

unsigned NonzeroMask::effectiveWidth() const {
    if (mask == 0)
        return 0;

    // Position of highest set bit + 1.
    // std::bit_width gives the number of bits needed (C++20).
    return static_cast<unsigned>(std::bit_width(mask));
}

// ═══════════════════════════════════════════════════════════════════════════════
// Transfer Functions
// ═══════════════════════════════════════════════════════════════════════════════

NonzeroMask NonzeroMask::forConstant(uint64_t value) {
    return NonzeroMask{value};
}

NonzeroMask NonzeroMask::forAnd(NonzeroMask a, NonzeroMask b) {
    // A bit in the result can only be set if it is set in BOTH operands.
    return NonzeroMask{a.mask & b.mask};
}

NonzeroMask NonzeroMask::forOr(NonzeroMask a, NonzeroMask b) {
    // A bit in the result can be set if it is set in EITHER operand.
    return NonzeroMask{a.mask | b.mask};
}

NonzeroMask NonzeroMask::forXor(NonzeroMask a, NonzeroMask b) {
    // XOR can set a bit if either operand could have it set.
    // We cannot determine cancellation from masks alone, so we use
    // the same upper bound as OR.
    return NonzeroMask{a.mask | b.mask};
}

NonzeroMask NonzeroMask::forShl(NonzeroMask a, unsigned shift) {
    if (shift >= 64)
        return NonzeroMask{0};
    return NonzeroMask{a.mask << shift};
}

NonzeroMask NonzeroMask::forShr(NonzeroMask a, unsigned shift) {
    if (shift >= 64)
        return NonzeroMask{0};
    return NonzeroMask{a.mask >> shift};
}

NonzeroMask NonzeroMask::forZext(NonzeroMask a, unsigned srcBits) {
    if (srcBits >= 64)
        return a;
    // Zero-extension: bits above srcBits are guaranteed zero.
    uint64_t srcMask = (1ULL << srcBits) - 1;
    return NonzeroMask{a.mask & srcMask};
}

NonzeroMask NonzeroMask::forTrunc(NonzeroMask a, unsigned dstBits) {
    if (dstBits >= 64)
        return a;
    // Truncation: bits above dstBits are discarded.
    uint64_t dstMask = (1ULL << dstBits) - 1;
    return NonzeroMask{a.mask & dstMask};
}

NonzeroMask NonzeroMask::forAdd(NonzeroMask a, NonzeroMask b) {
    // Addition is harder: carries can propagate upward.
    // Conservative approach: the result mask is the OR of both operand
    // masks, plus we must account for carry propagation.
    //
    // The highest possible bit that could be set in the sum is
    // one bit higher than the highest bit in either operand.
    //
    // Formal bound: if a has effective width W_a and b has effective
    // width W_b, then a+b has effective width <= max(W_a, W_b) + 1.

    uint64_t combined = a.mask | b.mask;

    // If both masks have bits set, carries could propagate one bit higher.
    if (a.mask != 0 && b.mask != 0) {
        unsigned highBit = static_cast<unsigned>(std::bit_width(combined));
        if (highBit < 64)
            combined |= (1ULL << highBit);
    }

    return NonzeroMask{combined};
}

} // namespace helix
