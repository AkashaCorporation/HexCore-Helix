/// @file CApi.cpp
/// @brief C API wrapper for the Helix engine — consumed by Rust FFI.
///
/// This file bridges the C++ Engine class to the extern "C" functions
/// declared in Engine.h. The Rust side calls these functions via
/// helix_core::ffi.

#include "helix/Engine.h"
#include <cstring>
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

void helix_engine_free_decompile_output(
    HelixCombinedDecompileOutput* output)
{
    if (!output)
        return;
    delete[] output->pseudo_c;
    delete[] output->flatbuffer;
    *output = {};
}

int helix_engine_decompile_ir_combined(
    HelixEngineHandle* handle,
    const char* ir_text,
    size_t ir_len,
    HelixCombinedDecompileOutput* output)
{
    if (!handle)
        return HELIX_ERROR_ENGINE_NOT_READY;
    if (!output)
        return HELIX_ERROR_INVALID_INPUT;

    *output = {};
    helix::DecompileOutput result;
    auto* engine = to_engine(handle);
    HelixStatus status = engine->decompileIRCombined(ir_text, ir_len, result);
    if (status != HELIX_OK)
        return static_cast<int>(status);

    char* pseudoC = new (std::nothrow) char[result.pseudo_c.size() + 1];
    uint8_t* flatbuffer = result.flatbuffer.empty()
        ? nullptr
        : new (std::nothrow) uint8_t[result.flatbuffer.size()];
    if (!pseudoC || (!result.flatbuffer.empty() && !flatbuffer)) {
        delete[] pseudoC;
        delete[] flatbuffer;
        return HELIX_ERROR_OUT_OF_MEMORY;
    }

    std::memcpy(pseudoC, result.pseudo_c.data(), result.pseudo_c.size());
    pseudoC[result.pseudo_c.size()] = '\0';
    if (!result.flatbuffer.empty()) {
        std::memcpy(
            flatbuffer, result.flatbuffer.data(), result.flatbuffer.size());
    }

    output->pseudo_c = pseudoC;
    output->pseudo_c_len = result.pseudo_c.size();
    output->flatbuffer = flatbuffer;
    output->flatbuffer_len = result.flatbuffer.size();
    output->function_count = result.function_count;
    output->block_count = result.block_count;
    output->instruction_count = result.instruction_count;
    return HELIX_OK;
}

void helix_engine_set_skip_optimization(HelixEngineHandle* handle, int skip) {
    if (handle) {
        to_engine(handle)->setSkipOptimization(skip != 0);
    }
}

void helix_engine_set_preserve_cfg(HelixEngineHandle* handle, int v) {
    if (handle) {
        to_engine(handle)->setPreserveCfg(v != 0);
    }
}

void helix_engine_enable_pass(HelixEngineHandle* handle, const char* name) {
    if (handle && name) {
        to_engine(handle)->enablePass(name);
    }
}

const char* helix_engine_last_error(HelixEngineHandle* handle) {
    if (!handle) {
        return nullptr;
    }
    return to_engine(handle)->lastError();
}

void helix_engine_set_use_cast_layer(HelixEngineHandle* handle, int use) {
    if (handle) {
        to_engine(handle)->setUseCastLayer(use != 0);
    }
}

void helix_engine_add_variable_rename(HelixEngineHandle* handle,
                                       const char* old_name,
                                       const char* new_name) {
    if (handle && old_name && new_name) {
        to_engine(handle)->addVariableRename(old_name, new_name);
    }
}

void helix_engine_clear_variable_renames(HelixEngineHandle* handle) {
    if (handle) {
        to_engine(handle)->clearVariableRenames();
    }
}

void helix_engine_set_function_starts(HelixEngineHandle* handle,
                                       const int64_t* starts,
                                       size_t len) {
    if (handle && starts && len > 0) {
        to_engine(handle)->setFunctionStarts(starts, len);
    }
}

void helix_engine_set_debug_type_info_json(HelixEngineHandle* handle,
                                           const char* json,
                                           size_t len) {
    if (handle) {
        to_engine(handle)->setDebugTypeInfoJson(json, len);
    }
}

void helix_engine_add_data_section(HelixEngineHandle* handle,
                                    uint64_t va_start,
                                    const uint8_t* bytes,
                                    size_t len) {
    if (handle && bytes && len > 0) {
        to_engine(handle)->addDataSection(va_start, bytes, len);
    }
}

void helix_engine_clear_data_sections(HelixEngineHandle* handle) {
    if (handle) {
        to_engine(handle)->clearDataSections();
    }
}

} // extern "C"
