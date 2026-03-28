#pragma once
/// @file CallingConventionDb.h
/// @brief Calling convention database for parametric ABI specifications.
///
/// Replaces the hardcoded kWin64IntArgs/kSysVIntArgs arrays in
/// RecoverCallingConvention.cpp with a queryable database of calling
/// convention specifications indexed by architecture and name.

#ifndef HELIX_ANALYSIS_CALLING_CONVENTION_DB_H
#define HELIX_ANALYSIS_CALLING_CONVENTION_DB_H

#include <optional>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>

namespace helix {

/// Describes a calling convention specification parametrically.
/// Replaces the hardcoded kWin64IntArgs/kSysVIntArgs arrays.
struct CallingConventionSpec {
    std::string name;  // e.g., "win64", "sysv_amd64", "aapcs64"

    /// Target architecture (HelixArch value).
    int arch = 0;

    // ─── Argument passing registers (ordered by argument position) ───────

    std::vector<std::string> int_arg_regs;    // Integer/pointer args
    std::vector<std::string> float_arg_regs;  // Float/double args

    // ─── Return value registers ─────────────────────────────────────────

    std::vector<std::string> int_return_regs;   // e.g., {"rax"} or {"rax","rdx"}
    std::vector<std::string> float_return_regs; // e.g., {"xmm0"}

    // ─── Preserved / volatile registers ─────────────────────────────────

    std::vector<std::string> callee_saved_regs;
    std::vector<std::string> volatile_regs;

    // ─── Stack configuration ────────────────────────────────────────────

    unsigned stack_alignment = 16;
    unsigned shadow_space    = 0;     // Win64: 32 bytes (4 reg args * 8)
    unsigned red_zone        = 0;     // SysV: 128 bytes
    bool args_right_to_left  = true;  // Stack arg push order

    // ─── Struct return handling ─────────────────────────────────────────

    unsigned struct_return_threshold = 8; // Bytes; above -> hidden pointer param
    std::string struct_return_reg;        // Register for hidden return pointer

    // ─── Varargs ────────────────────────────────────────────────────────

    bool has_varargs_support = true;
    std::string varargs_indicator_reg;  // Win64: AL for float count in varargs

    // ─── Helper methods ─────────────────────────────────────────────────

    bool isCalleeSaved(std::string_view reg) const;
    bool isVolatile(std::string_view reg) const;
    bool isIntArgReg(std::string_view reg) const;
    bool isFloatArgReg(std::string_view reg) const;
    std::optional<unsigned> getIntArgIndex(std::string_view reg) const;
    std::optional<unsigned> getFloatArgIndex(std::string_view reg) const;
};

/// Database of calling conventions indexed by architecture and name.
class CallingConventionDb {
public:
    CallingConventionDb();

    /// Get the default calling convention for an architecture.
    const CallingConventionSpec& getDefault(int arch) const;

    /// Get a named calling convention (e.g., "fastcall", "thiscall").
    const CallingConventionSpec* getByName(std::string_view name) const;

    /// Get all conventions registered for an architecture.
    std::vector<const CallingConventionSpec*> getForArch(int arch) const;

private:
    void initBuiltins();

    std::vector<CallingConventionSpec> specs_;

    /// Map: arch -> default spec index.
    std::unordered_map<int, size_t> default_map_;

    /// Map: name -> spec index.
    std::unordered_map<std::string, size_t> name_map_;
};

} // namespace helix

#endif // HELIX_ANALYSIS_CALLING_CONVENTION_DB_H
