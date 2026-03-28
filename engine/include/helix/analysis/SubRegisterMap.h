#pragma once
/// @file SubRegisterMap.h
/// @brief Static database of x86-64 sub-register relationships.
///
/// Provides lookup functions to determine the parent 64-bit register,
/// bit width, bit offset, and zero-extension behavior for any x86-64
/// general-purpose register name.
///
/// @version Helix-Nightly

#ifndef HELIX_ANALYSIS_SUB_REGISTER_MAP_H
#define HELIX_ANALYSIS_SUB_REGISTER_MAP_H

#include <cstdint>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

namespace helix {

/// Describes the relationship between a sub-register and its parent.
struct SubRegInfo {
    std::string name;          ///< Sub-register name (e.g., "eax")
    std::string parent;        ///< Parent 64-bit register (e.g., "rax")
    unsigned offset_bits;      ///< Bit offset within parent (0 for low, 8 for AH)
    unsigned width_bits;       ///< Width in bits (8, 16, 32, 64)
    bool zero_extends;         ///< True for 32-bit writes (x86-64 zero-extends to 64)
};

/// Static database of x86-64 sub-register relationships.
///
/// Covers all general-purpose registers (RAX-R15, RIP), including the
/// legacy high-byte registers (AH, BH, CH, DH).  Lookups are
/// case-insensitive.
class SubRegisterMap {
public:
    /// Get sub-register info for a register name. Returns nullopt if not found.
    static std::optional<SubRegInfo> lookup(std::string_view reg);

    /// Get the canonical 64-bit parent for any register name.
    /// Returns an empty string_view if the register is not recognized.
    static std::string_view getParent64(std::string_view reg);

    /// Get the bit width for a register name. Returns 0 if not recognized.
    static unsigned getWidth(std::string_view reg);

    /// Check if 'child' is a sub-register of 'parent'.
    /// Both names are resolved to their canonical 64-bit parent for comparison.
    static bool isSubOf(std::string_view child, std::string_view parent);

    /// Get all sub-registers of a given 64-bit register.
    /// The input should be the canonical 64-bit name (e.g., "rax").
    static std::vector<SubRegInfo> getSubRegs(std::string_view parent64);
};

} // namespace helix

#endif // HELIX_ANALYSIS_SUB_REGISTER_MAP_H
