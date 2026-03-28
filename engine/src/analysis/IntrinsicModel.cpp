/// @file IntrinsicModel.cpp
/// @brief Implementation of the intrinsic model database.
///
/// Provides built-in models for common C runtime, POSIX, and Win32 API
/// functions, describing their parameter effects, return semantics,
/// side effects, and type hints.

#include "helix/analysis/IntrinsicModel.h"

#include <algorithm>

namespace helix {

// ═══════════════════════════════════════════════════════════════════════════════
// Public API
// ═══════════════════════════════════════════════════════════════════════════════

IntrinsicModelDb::IntrinsicModelDb() {
    initBuiltins();
}

const IntrinsicModel* IntrinsicModelDb::lookup(std::string_view name) const {
    auto it = models_.find(std::string(name));
    if (it == models_.end())
        return nullptr;
    return &it->second;
}

void IntrinsicModelDb::addModel(IntrinsicModel model) {
    auto name = model.name;
    models_[std::move(name)] = std::move(model);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Built-in Model Initialization
// ═══════════════════════════════════════════════════════════════════════════════

void IntrinsicModelDb::initBuiltins() {
    // ─── Memory operations ───────────────────────────────────────────

    {
        IntrinsicModel m;
        m.name = "memcpy";
        m.param_effects = {ParamEffect::Write, ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::InputPassthrough;
        m.return_type_hint = "void*";
        m.param_type_hints = {"void*", "const void*", "size_t"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "memmove";
        m.param_effects = {ParamEffect::Write, ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::InputPassthrough;
        m.return_type_hint = "void*";
        m.param_type_hints = {"void*", "const void*", "size_t"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "memset";
        m.param_effects = {ParamEffect::Write, ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::InputPassthrough;
        m.return_type_hint = "void*";
        m.param_type_hints = {"void*", "int", "size_t"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "memcmp";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.is_pure = true;
        m.return_type_hint = "int";
        m.param_type_hints = {"const void*", "const void*", "size_t"};
        models_[m.name] = std::move(m);
    }

    // ─── Allocation / deallocation ───────────────────────────────────

    {
        IntrinsicModel m;
        m.name = "malloc";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "void*";
        m.param_type_hints = {"size_t"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "calloc";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "void*";
        m.param_type_hints = {"size_t", "size_t"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "realloc";
        m.param_effects = {ParamEffect::Free, ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "void*";
        m.param_type_hints = {"void*", "size_t"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "free";
        m.param_effects = {ParamEffect::Free};
        m.return_effect = ReturnEffect::None;
        m.return_type_hint = "void";
        m.param_type_hints = {"void*"};
        models_[m.name] = std::move(m);
    }

    // ─── String operations ───────────────────────────────────────────

    {
        IntrinsicModel m;
        m.name = "strlen";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.is_pure = true;
        m.return_type_hint = "size_t";
        m.param_type_hints = {"const char*"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "strcmp";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.is_pure = true;
        m.return_type_hint = "int";
        m.param_type_hints = {"const char*", "const char*"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "strncmp";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.is_pure = true;
        m.return_type_hint = "int";
        m.param_type_hints = {"const char*", "const char*", "size_t"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "strcpy";
        m.param_effects = {ParamEffect::Write, ParamEffect::Read};
        m.return_effect = ReturnEffect::InputPassthrough;
        m.return_type_hint = "char*";
        m.param_type_hints = {"char*", "const char*"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "strncpy";
        m.param_effects = {ParamEffect::Write, ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::InputPassthrough;
        m.return_type_hint = "char*";
        m.param_type_hints = {"char*", "const char*", "size_t"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "strcat";
        m.param_effects = {ParamEffect::ReadWrite, ParamEffect::Read};
        m.return_effect = ReturnEffect::InputPassthrough;
        m.return_type_hint = "char*";
        m.param_type_hints = {"char*", "const char*"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "strstr";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.is_pure = true;
        m.return_type_hint = "char*";
        m.param_type_hints = {"const char*", "const char*"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "strchr";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.is_pure = true;
        m.return_type_hint = "char*";
        m.param_type_hints = {"const char*", "int"};
        models_[m.name] = std::move(m);
    }

    // ─── I/O functions ───────────────────────────────────────────────

    {
        IntrinsicModel m;
        m.name = "printf";
        m.param_effects = {ParamEffect::Read};  // variadic, at least fmt
        m.return_effect = ReturnEffect::Value;
        m.reads_global_state = false;
        m.writes_global_state = true;  // writes to stdout
        m.return_type_hint = "int";
        m.param_type_hints = {"const char*"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "fprintf";
        m.param_effects = {ParamEffect::Write, ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.writes_global_state = true;
        m.return_type_hint = "int";
        m.param_type_hints = {"FILE*", "const char*"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "sprintf";
        m.param_effects = {ParamEffect::Write, ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.return_type_hint = "int";
        m.param_type_hints = {"char*", "const char*"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "snprintf";
        m.param_effects = {ParamEffect::Write, ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.return_type_hint = "int";
        m.param_type_hints = {"char*", "size_t", "const char*"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "puts";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.writes_global_state = true;
        m.return_type_hint = "int";
        m.param_type_hints = {"const char*"};
        models_[m.name] = std::move(m);
    }

    // ─── Process control ─────────────────────────────────────────────

    {
        IntrinsicModel m;
        m.name = "exit";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::None;
        m.no_return = true;
        m.param_type_hints = {"int"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "_exit";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::None;
        m.no_return = true;
        m.param_type_hints = {"int"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "abort";
        m.return_effect = ReturnEffect::None;
        m.no_return = true;
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "atexit";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.return_type_hint = "int";
        m.param_type_hints = {"void (*)(void)"};
        models_[m.name] = std::move(m);
    }

    // ─── MSVC Security ──────────────────────────────────────────────

    {
        IntrinsicModel m;
        m.name = "__security_check_cookie";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::None;
        // Does not return on failure (calls __fastfail), but we model
        // it as potentially returning for the success path.
        m.param_type_hints = {"uintptr_t"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "__security_init_cookie";
        m.return_effect = ReturnEffect::None;
        m.writes_global_state = true;
        models_[m.name] = std::move(m);
    }

    // ─── Win32 API ───────────────────────────────────────────────────

    {
        IntrinsicModel m;
        m.name = "GetProcAddress";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;  // Returns function pointer
        m.return_type_hint = "FARPROC";
        m.param_type_hints = {"HMODULE", "LPCSTR"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "LoadLibraryA";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "HMODULE";
        m.param_type_hints = {"LPCSTR"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "LoadLibraryW";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "HMODULE";
        m.param_type_hints = {"LPCWSTR"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "FreeLibrary";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.return_type_hint = "BOOL";
        m.param_type_hints = {"HMODULE"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "VirtualAlloc";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Read, ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "LPVOID";
        m.param_type_hints = {"LPVOID", "SIZE_T", "DWORD", "DWORD"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "VirtualFree";
        m.param_effects = {ParamEffect::Free, ParamEffect::Read,
                           ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.return_type_hint = "BOOL";
        m.param_type_hints = {"LPVOID", "SIZE_T", "DWORD"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "VirtualProtect";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Read, ParamEffect::Write};
        m.return_effect = ReturnEffect::Value;
        m.return_type_hint = "BOOL";
        m.param_type_hints = {"LPVOID", "SIZE_T", "DWORD", "PDWORD"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "CloseHandle";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::Value;
        m.return_type_hint = "BOOL";
        m.param_type_hints = {"HANDLE"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "CreateFileA";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "HANDLE";
        m.param_type_hints = {"LPCSTR", "DWORD", "DWORD",
                              "LPSECURITY_ATTRIBUTES", "DWORD", "DWORD",
                              "HANDLE"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "CreateFileW";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "HANDLE";
        m.param_type_hints = {"LPCWSTR", "DWORD", "DWORD",
                              "LPSECURITY_ATTRIBUTES", "DWORD", "DWORD",
                              "HANDLE"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "ReadFile";
        m.param_effects = {ParamEffect::Read, ParamEffect::Write,
                           ParamEffect::Read, ParamEffect::Write,
                           ParamEffect::ReadWrite};
        m.return_effect = ReturnEffect::Value;
        m.return_type_hint = "BOOL";
        m.param_type_hints = {"HANDLE", "LPVOID", "DWORD",
                              "LPDWORD", "LPOVERLAPPED"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "WriteFile";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Read, ParamEffect::Write,
                           ParamEffect::ReadWrite};
        m.return_effect = ReturnEffect::Value;
        m.return_type_hint = "BOOL";
        m.param_type_hints = {"HANDLE", "LPCVOID", "DWORD",
                              "LPDWORD", "LPOVERLAPPED"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "GetLastError";
        m.return_effect = ReturnEffect::ErrorCode;
        m.reads_global_state = true;
        m.return_type_hint = "DWORD";
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "SetLastError";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::None;
        m.writes_global_state = true;
        m.return_type_hint = "void";
        m.param_type_hints = {"DWORD"};
        models_[m.name] = std::move(m);
    }

    // ─── Heap API ────────────────────────────────────────────────────

    {
        IntrinsicModel m;
        m.name = "HeapAlloc";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "LPVOID";
        m.param_type_hints = {"HANDLE", "DWORD", "SIZE_T"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "HeapFree";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Free};
        m.return_effect = ReturnEffect::Value;
        m.return_type_hint = "BOOL";
        m.param_type_hints = {"HANDLE", "DWORD", "LPVOID"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "HeapReAlloc";
        m.param_effects = {ParamEffect::Read, ParamEffect::Read,
                           ParamEffect::Free, ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "LPVOID";
        m.param_type_hints = {"HANDLE", "DWORD", "LPVOID", "SIZE_T"};
        models_[m.name] = std::move(m);
    }

    // ─── C++ new/delete ──────────────────────────────────────────────

    {
        IntrinsicModel m;
        m.name = "operator new";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "void*";
        m.param_type_hints = {"size_t"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "operator delete";
        m.param_effects = {ParamEffect::Free};
        m.return_effect = ReturnEffect::None;
        m.return_type_hint = "void";
        m.param_type_hints = {"void*"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "operator new[]";
        m.param_effects = {ParamEffect::Read};
        m.return_effect = ReturnEffect::NewAlloc;
        m.return_type_hint = "void*";
        m.param_type_hints = {"size_t"};
        models_[m.name] = std::move(m);
    }

    {
        IntrinsicModel m;
        m.name = "operator delete[]";
        m.param_effects = {ParamEffect::Free};
        m.return_effect = ReturnEffect::None;
        m.return_type_hint = "void";
        m.param_type_hints = {"void*"};
        models_[m.name] = std::move(m);
    }
}

} // namespace helix
