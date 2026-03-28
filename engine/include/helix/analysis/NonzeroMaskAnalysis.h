#pragma once
/// @file NonzeroMaskAnalysis.h
/// @brief Nonzero mask tracking for bit-level value analysis.
///
/// Tracks which bits of a value are guaranteed to be non-zero.
/// Inspired by Ghidra's Varnode::nzm (nonzero mask).  The mask is a
/// conservative over-approximation: if bit N is 0 in the mask, bit N
/// is GUARANTEED to be 0 in the value.  If bit N is 1, it MAY be 0 or 1.
///
/// @version Helix-Nightly

#ifndef HELIX_ANALYSIS_NONZERO_MASK_ANALYSIS_H
#define HELIX_ANALYSIS_NONZERO_MASK_ANALYSIS_H

#include <cstdint>

namespace helix {

/// Tracks which bits of a value are guaranteed to be non-zero.
///
/// The nonzero mask is a conservative over-approximation:
/// if bit N is 0 in the mask, bit N is GUARANTEED to be 0 in the value.
/// If bit N is 1 in the mask, bit N MAY be 0 or 1.
struct NonzeroMask {
    uint64_t mask = ~0ULL; // Start with all bits potentially nonzero

    /// Check if a specific bit is guaranteed zero.
    bool isGuaranteedZero(unsigned bit) const {
        return !(mask & (1ULL << bit));
    }

    /// Get the minimum number of bits needed to represent any possible value.
    /// Equivalent to finding the position of the highest potentially-set bit + 1.
    unsigned effectiveWidth() const;

    // ─── Transfer Functions ──────────────────────────────────────────

    /// Nonzero mask for a known constant value.
    static NonzeroMask forConstant(uint64_t value);

    /// Bitwise AND: result bit can only be set if set in BOTH operands.
    static NonzeroMask forAnd(NonzeroMask a, NonzeroMask b);

    /// Bitwise OR: result bit can be set if set in EITHER operand.
    static NonzeroMask forOr(NonzeroMask a, NonzeroMask b);

    /// Bitwise XOR: result bit can be set if set in EITHER operand.
    /// (Same upper bound as OR — we cannot determine cancellation.)
    static NonzeroMask forXor(NonzeroMask a, NonzeroMask b);

    /// Logical left shift by a known constant.
    static NonzeroMask forShl(NonzeroMask a, unsigned shift);

    /// Logical right shift by a known constant.
    static NonzeroMask forShr(NonzeroMask a, unsigned shift);

    /// Zero-extension from srcBits to 64: high bits are guaranteed zero.
    static NonzeroMask forZext(NonzeroMask a, unsigned srcBits);

    /// Truncation to dstBits: high bits are guaranteed zero.
    static NonzeroMask forTrunc(NonzeroMask a, unsigned dstBits);

    /// Addition: conservative — set bits can propagate through carries.
    /// The result mask is the OR of both masks widened by one bit.
    static NonzeroMask forAdd(NonzeroMask a, NonzeroMask b);
};

} // namespace helix

#endif // HELIX_ANALYSIS_NONZERO_MASK_ANALYSIS_H
