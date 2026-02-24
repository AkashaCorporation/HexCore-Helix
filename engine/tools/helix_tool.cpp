/// @file helix_tool.cpp
/// @brief CLI tool for the Helix decompilation engine.
///
/// Usage:
///   helix_tool <input.ll>              Decompile to stdout
///   helix_tool <input.ll> <output.c>   Decompile to file
///   helix_tool --dir <folder>          Process all .ll files in folder
///   helix_tool --version               Show version
///
/// Reads Remill-lifted LLVM IR (.ll files) and produces pseudo-C output
/// through the full MLIR pipeline. No scripts needed — just point it at
/// any .ll file or a folder of .ll files.

#include "helix/Engine.h"
#include "helix/Types.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

namespace fs = std::filesystem;

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// Read an entire file into a string.
static std::string readFile(const fs::path& path) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs) {
        std::cerr << "error: cannot open file: " << path << "\n";
        return {};
    }
    std::ostringstream ss;
    ss << ifs.rdbuf();
    return ss.str();
}

/// Detect architecture from IR text content.
static int detectArch(std::string_view ir_text) {
    if (ir_text.find("x86_64") != std::string_view::npos)
        return HELIX_ARCH_X86_64;
    if (ir_text.find("i686") != std::string_view::npos ||
        ir_text.find("i386") != std::string_view::npos)
        return HELIX_ARCH_X86;
    if (ir_text.find("aarch64") != std::string_view::npos)
        return HELIX_ARCH_AARCH64;
    if (ir_text.find("arm") != std::string_view::npos)
        return HELIX_ARCH_ARM;
    // Default to x86_64 (most common for Remill output)
    return HELIX_ARCH_X86_64;
}

/// Decompile a single .ll file and return pseudo-C text.
/// Uses helix_engine_decompile_ir_text() — the text API.
static std::string decompileFile(const fs::path& input_path) {
    std::string ir_text = readFile(input_path);
    if (ir_text.empty())
        return {};

    int arch = detectArch(ir_text);

    // Create engine
    HelixEngineHandle* handle = helix_engine_create(arch);
    if (!handle) {
        std::cerr << "error: failed to create engine\n";
        return {};
    }

    // Allocate output buffer (start with 256KB, grow if needed)
    size_t buf_size = 256 * 1024;
    std::vector<char> out_buf(buf_size);
    size_t out_len = buf_size;

    int status = helix_engine_decompile_ir_text(
        handle,
        ir_text.c_str(),
        ir_text.size(),
        out_buf.data(),
        &out_len
    );

    // Handle buffer too small — resize and retry
    if (status == HELIX_ERROR_OUT_OF_MEMORY && out_len > buf_size) {
        out_buf.resize(out_len);
        buf_size = out_len;
        out_len = buf_size;
        status = helix_engine_decompile_ir_text(
            handle,
            ir_text.c_str(),
            ir_text.size(),
            out_buf.data(),
            &out_len
        );
    }

    if (status != HELIX_OK) {
        const char* err = helix_engine_last_error(handle);
        std::cerr << "error: decompilation failed for " << input_path.filename();
        if (err)
            std::cerr << ": " << err;
        std::cerr << "\n";
        helix_engine_destroy(handle);
        return {};
    }

    helix_engine_destroy(handle);
    return std::string(out_buf.data());  // null-terminated
}

// ─── Main ─────────────────────────────────────────────────────────────────────

static void printUsage(const char* argv0) {
    std::cerr
        << "HexCore Helix Decompiler (MLIR Engine)\n\n"
        << "Usage:\n"
        << "  " << argv0 << " <input.ll>              Decompile to stdout\n"
        << "  " << argv0 << " <input.ll> <output.c>   Decompile to file\n"
        << "  " << argv0 << " --dir <folder>          Process all .ll files\n"
        << "  " << argv0 << " --version               Show version\n\n"
        << "Examples:\n"
        << "  " << argv0 << " tests/remill-6/01-name-writing.ll\n"
        << "  " << argv0 << " --dir tests/remill-6/\n";
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printUsage(argv[0]);
        return 1;
    }

    std::string_view arg1 = argv[1];

    // --version
    if (arg1 == "--version" || arg1 == "-v") {
        std::cout << "HexCore Helix Engine " << helix_engine_version() << "\n";
        return 0;
    }

    // --dir <folder>: process all .ll files in a directory
    if (arg1 == "--dir" && argc >= 3) {
        fs::path dir_path = argv[2];
        if (!fs::is_directory(dir_path)) {
            std::cerr << "error: not a directory: " << dir_path << "\n";
            return 1;
        }

        int processed = 0;
        int failed = 0;

        for (const auto& entry : fs::directory_iterator(dir_path)) {
            if (entry.path().extension() != ".ll")
                continue;

            fs::path out_path = entry.path();
            out_path.replace_extension(".helix.c");

            std::cerr << "  " << entry.path().filename() << " ... ";

            std::string result = decompileFile(entry.path());
            if (result.empty()) {
                std::cerr << "FAILED\n";
                failed++;
                continue;
            }

            std::ofstream ofs(out_path);
            ofs << result;
            std::cerr << out_path.filename() << "\n";
            processed++;
        }

        std::cerr << "\nDone: " << processed << " ok, "
                  << failed << " failed.\n";
        return failed > 0 ? 1 : 0;
    }

    // Single file mode
    fs::path input_path = argv[1];
    if (!fs::exists(input_path)) {
        std::cerr << "error: file not found: " << input_path << "\n";
        return 1;
    }

    std::string result = decompileFile(input_path);
    if (result.empty())
        return 1;

    // Output to file or stdout
    if (argc >= 3) {
        fs::path out_path = argv[2];
        std::ofstream ofs(out_path);
        if (!ofs) {
            std::cerr << "error: cannot write to: " << out_path << "\n";
            return 1;
        }
        ofs << result;
        std::cerr << "Output: " << out_path << "\n";
    } else {
        std::cout << result;
    }

    return 0;
}
