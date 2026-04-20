#pragma once
/// @file StructRecovery.h
/// @brief Struct type recovery from memory access patterns.
///
/// Analyzes how a base pointer is accessed at various offsets to infer
/// composite (struct/union) layouts.  When multiple accesses through the
/// same base pointer use different constant offsets, the analyzer groups
/// them and builds a RecoveredStruct with named fields, padding, and
/// optional array/union detection.
///
/// @version Helix-Nightly

#ifndef HELIX_ANALYSIS_STRUCT_RECOVERY_H
#define HELIX_ANALYSIS_STRUCT_RECOVERY_H

#include "helix/analysis/TypeLattice.h"

#include <cstdint>
#include <map>
#include <string>
#include <vector>

namespace helix {

/// Represents a single memory access through a base pointer.
struct AccessPattern {
    uint32_t base_var_id;     ///< Variable ID of the base pointer
    int64_t offset;           ///< Byte offset from base
    unsigned access_width;    ///< Access size in bytes (1, 2, 4, 8)
    bool is_write;            ///< true if store, false if load
    HelixTypeInfo type_hint;  ///< Type hint from context (if available)

    // ── Dynamic array detection (v0.8.1) ───────────────────────────
    bool is_dynamic_array = false;  ///< True if *(base + index*stride)
    int64_t stride = 0;            ///< Element size in bytes (from Mul/Shl)
    uint32_t index_var_id = 0;     ///< Variable used as array index
};

/// A recovered struct field.
struct RecoveredField {
    std::string name;         ///< Field name (field_0, field_4, etc.)
    unsigned offset;          ///< Byte offset within struct
    unsigned size;            ///< Field size in bytes
    HelixTypeInfo type;       ///< Inferred field type
    unsigned access_count;    ///< Number of accesses (for confidence)
};

/// A recovered struct layout.
struct RecoveredStruct {
    std::string name;                       ///< Struct name (auto_struct_N)
    std::vector<RecoveredField> fields;     ///< Sorted by offset
    unsigned total_size;                    ///< Total struct size in bytes
    unsigned alignment;                     ///< Inferred alignment
    bool has_overlaps;                      ///< If true, some fields overlap -> union candidate
};

/// Analyzes memory access patterns to recover struct layouts.
///
/// Usage:
///   1. Feed observed access patterns via addAccess()
///   2. Call analyze() to group by base pointer and build struct layouts
///   3. Each group with 2+ accesses at distinct offsets yields a RecoveredStruct
///
/// The analyzer also detects:
///   - Array patterns: regular stride with identical types (e.g., int[4])
///   - Union candidates: overlapping field ranges
///   - Padding gaps between fields
class StructRecoveryAnalyzer {
public:
    /// Add an observed access pattern.
    void addAccess(const AccessPattern& access);

    /// Analyze all collected accesses and produce struct layouts.
    /// Groups accesses by base_var_id, then builds struct for each group
    /// that has 2+ accesses at different offsets.
    std::vector<RecoveredStruct> analyze();

    /// Clear all collected patterns.
    void reset();

private:
    std::vector<AccessPattern> accesses_;

    /// Build a struct layout from a group of accesses sharing the same base.
    RecoveredStruct buildStruct(uint32_t base_var,
                                const std::vector<AccessPattern>& group);

    /// Detect regular-stride array patterns within a recovered struct.
    void detectArrays(RecoveredStruct& s);

    /// Insert padding fields to fill gaps between recovered fields.
    void insertPadding(RecoveredStruct& s);
};

} // namespace helix

#endif // HELIX_ANALYSIS_STRUCT_RECOVERY_H
