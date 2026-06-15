/// @file HelixValueRangeAnalysis.cpp
/// @brief Integer value range analysis implementation.
/// @version Helix-Nightly

#include "helix/analysis/HelixValueRangeAnalysis.h"

#include <algorithm>
#include <limits>

// MSVC doesn't support __builtin_{add,sub,mul}_overflow.
// Provide portable replacements using <limits>.
#ifdef _MSC_VER
static inline bool safe_add_overflow(int64_t a, int64_t b, int64_t* res) {
    if (b > 0 && a > std::numeric_limits<int64_t>::max() - b) return true;
    if (b < 0 && a < std::numeric_limits<int64_t>::min() - b) return true;
    *res = a + b; return false;
}
static inline bool safe_sub_overflow(int64_t a, int64_t b, int64_t* res) {
    if (b < 0 && a > std::numeric_limits<int64_t>::max() + b) return true;
    if (b > 0 && a < std::numeric_limits<int64_t>::min() + b) return true;
    *res = a - b; return false;
}
static inline bool safe_mul_overflow(int64_t a, int64_t b, int64_t* res) {
    if (a == 0 || b == 0) { *res = 0; return false; }
    if (a > 0 && b > 0 && a > std::numeric_limits<int64_t>::max() / b) return true;
    if (a < 0 && b < 0 && a < std::numeric_limits<int64_t>::max() / b) return true;
    if (a > 0 && b < 0 && b < std::numeric_limits<int64_t>::min() / a) return true;
    if (a < 0 && b > 0 && a < std::numeric_limits<int64_t>::min() / b) return true;
    *res = a * b; return false;
}
#define __builtin_add_overflow(a, b, r) safe_add_overflow(a, b, r)
#define __builtin_sub_overflow(a, b, r) safe_sub_overflow(a, b, r)
#define __builtin_mul_overflow(a, b, r) safe_mul_overflow(a, b, r)
#endif

using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════
// ValueRange — Lattice Operations
// ═══════════════════════════════════════════════════════════════════════════

ValueRange ValueRange::meet(const ValueRange& a, const ValueRange& b) {
    // Intersection: tightest range containing only values in both
    return ValueRange{std::max(a.min, b.min), std::min(a.max, b.max)};
}

ValueRange ValueRange::join(const ValueRange& a, const ValueRange& b) {
    // Union: widest range containing all values in either
    if (a.isEmpty()) return b;
    if (b.isEmpty()) return a;
    return ValueRange{std::min(a.min, b.min), std::max(a.max, b.max)};
}

// ═══════════════════════════════════════════════════════════════════════════
// ValueRange — Transfer Functions
// ═══════════════════════════════════════════════════════════════════════════

ValueRange ValueRange::forConstant(int64_t value) {
    return ValueRange{value, value};
}

ValueRange ValueRange::forAdd(const ValueRange& a, const ValueRange& b) {
    // Check for overflow — if either is unbounded, result is unbounded
    if (a.isTop() || b.isTop()) return top();

    // Safe add with overflow detection
    int64_t lo, hi;
    if (__builtin_add_overflow(a.min, b.min, &lo) ||
        __builtin_add_overflow(a.max, b.max, &hi))
        return top(); // Overflow → give up

    return ValueRange{lo, hi};
}

ValueRange ValueRange::forSub(const ValueRange& a, const ValueRange& b) {
    if (a.isTop() || b.isTop()) return top();

    int64_t lo, hi;
    if (__builtin_sub_overflow(a.min, b.max, &lo) ||
        __builtin_sub_overflow(a.max, b.min, &hi))
        return top();

    return ValueRange{lo, hi};
}

ValueRange ValueRange::forMul(const ValueRange& a, const ValueRange& b) {
    if (a.isTop() || b.isTop()) return top();
    if (a.isConstant() && a.min == 0) return forConstant(0);
    if (b.isConstant() && b.min == 0) return forConstant(0);
    if (a.isConstant() && a.min == 1) return b;
    if (b.isConstant() && b.min == 1) return a;

    // For general multiplication, compute all four corner products
    // and take [min, max]. This handles negative ranges correctly.
    int64_t products[4];
    bool overflow = false;
    overflow |= __builtin_mul_overflow(a.min, b.min, &products[0]);
    overflow |= __builtin_mul_overflow(a.min, b.max, &products[1]);
    overflow |= __builtin_mul_overflow(a.max, b.min, &products[2]);
    overflow |= __builtin_mul_overflow(a.max, b.max, &products[3]);

    if (overflow) return top();

    int64_t lo = *std::min_element(products, products + 4);
    int64_t hi = *std::max_element(products, products + 4);
    return ValueRange{lo, hi};
}

ValueRange ValueRange::forAnd(const ValueRange& a, const ValueRange& b) {
    // AND can only clear bits, so the result is non-negative if either input is,
    // and bounded by the smaller of the two maxes.
    if (a.min >= 0 && b.min >= 0) {
        return ValueRange{0, std::min(a.max, b.max)};
    }
    // Conservative: give up on sign analysis
    return top();
}

ValueRange ValueRange::forOr(const ValueRange& a, const ValueRange& b) {
    // OR can only set bits. Conservative approximation.
    if (a.min >= 0 && b.min >= 0) {
        // Upper bound: next power of 2 above max of either
        uint64_t bound = static_cast<uint64_t>(a.max) | static_cast<uint64_t>(b.max);
        return ValueRange{0, static_cast<int64_t>(bound)};
    }
    return top();
}

ValueRange ValueRange::forShl(const ValueRange& a, const ValueRange& shift) {
    if (!shift.isConstant() || shift.min < 0 || shift.min >= 64)
        return top();

    unsigned s = static_cast<unsigned>(shift.min);
    int64_t lo, hi;
    if (__builtin_mul_overflow(a.min, (1LL << s), &lo) ||
        __builtin_mul_overflow(a.max, (1LL << s), &hi))
        return top();

    return ValueRange{lo, hi};
}

ValueRange ValueRange::forShr(const ValueRange& a, const ValueRange& shift) {
    if (!shift.isConstant() || shift.min < 0 || shift.min >= 64)
        return top();

    unsigned s = static_cast<unsigned>(shift.min);
    return ValueRange{a.min >> s, a.max >> s};
}

ValueRange ValueRange::forZext(const ValueRange& a, unsigned srcBits,
                                unsigned /*dstBits*/) {
    // Zero extension: high bits are zero. Range stays non-negative.
    uint64_t mask = (srcBits >= 64) ? ~0ULL : ((1ULL << srcBits) - 1);
    int64_t lo = (a.min >= 0) ? a.min : 0;
    int64_t hi = static_cast<int64_t>(
        std::min(static_cast<uint64_t>(a.max), mask));
    return ValueRange{lo, hi};
}

ValueRange ValueRange::forSext(const ValueRange& a, unsigned srcBits,
                                unsigned /*dstBits*/) {
    // Sign extension preserves the value — range stays the same
    // if it fits in the source bits.
    int64_t srcMin = -(1LL << (srcBits - 1));
    int64_t srcMax = (1LL << (srcBits - 1)) - 1;
    return ValueRange{std::max(a.min, srcMin), std::min(a.max, srcMax)};
}

ValueRange ValueRange::forTrunc(const ValueRange& a, unsigned dstBits) {
    // Truncation wraps — if the range fits, keep it; otherwise go full range
    int64_t dstMin = -(1LL << (dstBits - 1));
    int64_t dstMax = (1LL << (dstBits - 1)) - 1;
    if (a.min >= dstMin && a.max <= dstMax)
        return a;
    return forSignedBits(dstBits);
}

ValueRange ValueRange::forUnsignedBits(unsigned bits) {
    if (bits >= 63) return ValueRange{0, INT64_MAX};
    return ValueRange{0, (1LL << bits) - 1};
}

ValueRange ValueRange::forSignedBits(unsigned bits) {
    if (bits >= 64) return top();
    return ValueRange{-(1LL << (bits - 1)), (1LL << (bits - 1)) - 1};
}

// ═══════════════════════════════════════════════════════════════════════════
// Type Narrowing Suggestion
// ═══════════════════════════════════════════════════════════════════════════

std::optional<NarrowTypeHint> helix::suggestNarrowType(const ValueRange& range) {
    if (range.isTop() || range.isEmpty())
        return std::nullopt;

    // Try unsigned first (if range is non-negative)
    if (range.min >= 0) {
        if (range.max <= 1)      return NarrowTypeHint{1, false};  // bool
        if (range.max <= 0xFF)   return NarrowTypeHint{8, false};  // uint8_t
        if (range.max <= 0xFFFF) return NarrowTypeHint{16, false}; // uint16_t
        if (range.max <= 0xFFFFFFFFLL) return NarrowTypeHint{32, false}; // uint32_t
        return NarrowTypeHint{64, false};
    }

    // Signed ranges
    if (range.min >= -128 && range.max <= 127)
        return NarrowTypeHint{8, true};   // int8_t
    if (range.min >= -32768 && range.max <= 32767)
        return NarrowTypeHint{16, true};  // int16_t
    if (range.min >= INT32_MIN && range.max <= INT32_MAX)
        return NarrowTypeHint{32, true};  // int32_t
    return NarrowTypeHint{64, true};      // int64_t
}
