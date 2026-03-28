#pragma once
/// @file IntrinsicModel.h
/// @brief Database of intrinsic models for known functions.
///
/// Describes the side effects, data flow, and type hints for well-known
/// C runtime, POSIX, and Win32 API functions.  Used by escape analysis,
/// dead code elimination, and type propagation to reason about the
/// behavior of external calls without requiring their source.
///
/// @version Helix-Nightly

#ifndef HELIX_ANALYSIS_INTRINSIC_MODEL_H
#define HELIX_ANALYSIS_INTRINSIC_MODEL_H

#include <cstdint>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

namespace helix {

/// Effect that a function has on a parameter.
enum class ParamEffect : uint8_t {
    Read,       ///< Parameter is read but not modified
    Write,      ///< Parameter is written (output)
    ReadWrite,  ///< Parameter is both read and written
    Free,       ///< Parameter is freed (memory deallocation)
    None,       ///< Parameter is not accessed
};

/// Describes the return value semantics.
enum class ReturnEffect : uint8_t {
    None,              ///< No return value
    Value,             ///< Returns a computed value
    NewAlloc,          ///< Returns newly allocated memory
    InputPassthrough,  ///< Returns one of the input parameters
    ErrorCode,         ///< Returns an error code (HRESULT, errno)
};

/// Describes the side effects and data flow of a known function/intrinsic.
struct IntrinsicModel {
    std::string name;                       ///< Function name
    std::vector<ParamEffect> param_effects; ///< Per-parameter effects
    ReturnEffect return_effect = ReturnEffect::Value;
    bool no_return = false;                 ///< Does the function return?
    bool reads_global_state = false;        ///< Reads global/static vars
    bool writes_global_state = false;       ///< Writes global/static vars
    bool is_pure = false;                   ///< No side effects at all
    std::string return_type_hint;           ///< C type hint for return value
    std::vector<std::string> param_type_hints; ///< C type hints for params
};

/// Database of intrinsic models for known functions.
///
/// Initialized with built-in models for C runtime, POSIX, and Win32
/// functions.  Custom models can be added at runtime via addModel().
class IntrinsicModelDb {
public:
    IntrinsicModelDb();

    /// Lookup a model by function name.
    /// Returns nullptr if the function is not known.
    const IntrinsicModel* lookup(std::string_view name) const;

    /// Add a custom model.  If a model with the same name already exists,
    /// it is replaced.
    void addModel(IntrinsicModel model);

private:
    void initBuiltins();
    std::unordered_map<std::string, IntrinsicModel> models_;
};

} // namespace helix

#endif // HELIX_ANALYSIS_INTRINSIC_MODEL_H
