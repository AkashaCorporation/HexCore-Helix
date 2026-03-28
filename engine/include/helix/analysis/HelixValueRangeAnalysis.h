/// @file HelixValueRangeAnalysis.h
/// @brief Integer value range analysis for Helix-Nightly (P3.12).
///
/// Tracks [min, max] ranges for SSA values to enable:
///   - Dead branch elimination (range proves condition always true/false)
///   - Type narrowing (range [0, 255] → uint8_t)
///   - Array bounds verification
///
/// Uses MLIR's DataFlowAnalysis framework (IntegerRangeAnalysis).
///
/// @version Helix-Nightly

#pragma once

#include "llvm/ADT/APInt.h"
#include <cstdint>
#include <optional>

namespace helix {

/// Represents an integer value range [min, max] for an SSA value.
/// Uses signed 64-bit bounds. Top = unbounded, Bottom = empty.
struct ValueRange {
    int64_t min = INT64_MIN;
    int64_t max = INT64_MAX;

    /// Check if this is the top (unbounded) range.
    bool isTop() const { return min == INT64_MIN && max == INT64_MAX; }

    /// Check if this is a single constant value.
    bool isConstant() const { return min == max; }

    /// Check if the range is empty (bottom).
    bool isEmpty() const { return min > max; }

    /// Check if the range fits in N bits (unsigned).
    bool fitsInBits(unsigned bits) const {
        if (min < 0) return false;
        return static_cast<uint64_t>(max) < (1ULL << bits);
    }

    /// Check if a specific value is in the range.
    bool contains(int64_t value) const { return value >= min && value <= max; }

    /// Width of the range (max - min + 1). Returns 0 for empty ranges.
    uint64_t width() const {
        if (isEmpty()) return 0;
        return static_cast<uint64_t>(max) - static_cast<uint64_t>(min) + 1;
    }

    // ─── Lattice Operations ───────────────────────────────────────────

    /// Meet (intersection): tightest range that contains only values in both.
    static ValueRange meet(const ValueRange& a, const ValueRange& b);

    /// Join (union): widest range that contains all values in either.
    static ValueRange join(const ValueRange& a, const ValueRange& b);

    // ─── Transfer Functions ───────────────────────────────────────────

    static ValueRange forConstant(int64_t value);
    static ValueRange forAdd(const ValueRange& a, const ValueRange& b);
    static ValueRange forSub(const ValueRange& a, const ValueRange& b);
    static ValueRange forMul(const ValueRange& a, const ValueRange& b);
    static ValueRange forAnd(const ValueRange& a, const ValueRange& b);
    static ValueRange forOr(const ValueRange& a, const ValueRange& b);
    static ValueRange forShl(const ValueRange& a, const ValueRange& shift);
    static ValueRange forShr(const ValueRange& a, const ValueRange& shift);
    static ValueRange forZext(const ValueRange& a, unsigned srcBits, unsigned dstBits);
    static ValueRange forSext(const ValueRange& a, unsigned srcBits, unsigned dstBits);
    static ValueRange forTrunc(const ValueRange& a, unsigned dstBits);

    /// Create unbounded range (top).
    static ValueRange top() { return ValueRange{}; }

    /// Create empty range (bottom).
    static ValueRange bottom() { return ValueRange{1, 0}; }

    /// Create range for an unsigned N-bit value: [0, 2^N - 1].
    static ValueRange forUnsignedBits(unsigned bits);

    /// Create range for a signed N-bit value: [-2^(N-1), 2^(N-1) - 1].
    static ValueRange forSignedBits(unsigned bits);

    bool operator==(const ValueRange& other) const {
        return min == other.min && max == other.max;
    }
    bool operator!=(const ValueRange& other) const { return !(*this == other); }
};

/// Suggests the narrowest C integer type for a value range.
/// Returns the bit width and signedness.
struct NarrowTypeHint {
    unsigned bits;
    bool is_signed;
};

/// Given a value range, suggest the narrowest integer type.
std::optional<NarrowTypeHint> suggestNarrowType(const ValueRange& range);

} // namespace helix
