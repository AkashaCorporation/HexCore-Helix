/// @file CApi.cpp
/// @brief C API wrapper for the Helix engine — consumed by Rust FFI.
///
/// This file bridges the C++ Engine class to the extern "C" functions
/// declared in Engine.h. The Rust side calls these functions via
/// helix_core::ffi.

#include "helix/Engine.h"
#include <new>

// ─── Handle Casting ─────────────────────────────────────────────────────────────

// The opaque handle is just a pointer to helix::Engine reinterpreted.
// This is safe because HelixEngineHandle is an incomplete type.

static inline helix::Engine* to_engine(HelixEngineHandle* h) {
    return reinterpret_cast<helix::Engine*>(h);
}

static inline HelixEngineHandle* to_handle(helix::Engine* e) {
    return reinterpret_cast<HelixEngineHandle*>(e);
}

// ─── C API Implementation ──────────────────────────────────────────────────────

extern "C" {

HelixEngineHandle* helix_engine_create(int arch) {
    // Validate architecture range
    if (arch < 0 || arch > 11) {
        return nullptr;
    }

    try {
        auto* engine = new helix::Engine(static_cast<HelixArch>(arch));
        return to_handle(engine);
    } catch (const std::bad_alloc&) {
        return nullptr;
    } catch (...) {
        return nullptr;
    }
}

void helix_engine_destroy(HelixEngineHandle* handle) {
    if (handle) {
        delete to_engine(handle);
    }
}

const char* helix_engine_version() {
    return helix::Engine::version();
}

int helix_engine_decompile(
    HelixEngineHandle* handle,
    const uint8_t* data,
    size_t data_len,
    uint64_t base_addr,
    uint64_t entry_addr,
    uint8_t* out_buf,
    size_t* out_len)
{
    if (!handle) {
        return HELIX_ERROR_ENGINE_NOT_READY;
    }

    auto* engine = to_engine(handle);
    return static_cast<int>(engine->decompile(
        data, data_len, base_addr, entry_addr, out_buf, out_len
    ));
}

int helix_engine_decompile_ir(
    HelixEngineHandle* handle,
    const char* ir_text,
    size_t ir_len,
    uint8_t* out_buf,
    size_t* out_len)
{
    if (!handle) {
        return HELIX_ERROR_ENGINE_NOT_READY;
    }

    auto* engine = to_engine(handle);
    return static_cast<int>(engine->decompileIR(
        ir_text, ir_len, out_buf, out_len
    ));
}

int helix_engine_decompile_ir_text(
    HelixEngineHandle* handle,
    const char* ir_text,
    size_t ir_len,
    char* out_buf,
    size_t* out_len)
{
    if (!handle) {
        return HELIX_ERROR_ENGINE_NOT_READY;
    }

    auto* engine = to_engine(handle);
    return static_cast<int>(engine->decompileIRText(
        ir_text, ir_len, out_buf, out_len
    ));
}

const char* helix_engine_last_error(HelixEngineHandle* handle) {
    if (!handle) {
        return nullptr;
    }
    return to_engine(handle)->lastError();
}

} // extern "C"
