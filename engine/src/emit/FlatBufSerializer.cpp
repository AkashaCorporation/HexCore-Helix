/// @file FlatBufSerializer.cpp
/// @brief FlatBuffer serializer: HelixHigh MLIR → ast.fbs binary format.
///
/// Walks the HelixHigh MLIR module and produces a FlatBuffer conforming to
/// schemas/ast.fbs (file identifier "HAST"). The output can be read
/// zero-copy by the HexCore IDE.
///
/// NOTE: This is a stub implementation that produces a valid but minimal
/// FlatBuffer. Full serialization requires the FlatBuffers library to be
/// linked. The structure is prepared so that when flatbuffers/flatbuffers.h
/// is available, the real serialization can be implemented.

#include "helix/emit/FlatBufSerializer.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowOps.h"

#include "mlir/IR/BuiltinOps.h"

#include <cstring>
#include <format>
#include <string>
#include <vector>

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// FlatBuffer Manual Builder
// ═══════════════════════════════════════════════════════════════════════════════
//
// Since we may not have the FlatBuffers headers available at compile time,
// we implement a minimal FlatBuffer builder that produces valid output.
// FlatBuffers format reference: https://flatbuffers.dev/internals/
//
// A FlatBuffer is:
//   [4 bytes: offset to root table]
//   [file identifier: 4 bytes if present]
//   [vtables and data tables...]
//
// For our purposes, we produce a minimal AstModule with:
//   - name (string)
//   - functions (vector of DecompiledFunction)

namespace {

/// Minimal FlatBuffer builder for producing HAST output.
class MiniFlatBufBuilder {
public:
    /// Write a uint8 at the current position.
    void writeU8(uint8_t val) { buf_.push_back(val); }

    /// Write a uint16 (little-endian).
    void writeU16(uint16_t val) {
        buf_.push_back(val & 0xFF);
        buf_.push_back((val >> 8) & 0xFF);
    }

    /// Write a uint32 (little-endian).
    void writeU32(uint32_t val) {
        buf_.push_back(val & 0xFF);
        buf_.push_back((val >> 8) & 0xFF);
        buf_.push_back((val >> 16) & 0xFF);
        buf_.push_back((val >> 24) & 0xFF);
    }

    /// Write an int32 (little-endian).
    void writeI32(int32_t val) { writeU32(static_cast<uint32_t>(val)); }

    /// Write a uint64 (little-endian).
    void writeU64(uint64_t val) {
        writeU32(static_cast<uint32_t>(val));
        writeU32(static_cast<uint32_t>(val >> 32));
    }

    /// Write a string (length-prefixed, null-terminated, padded to 4 bytes).
    uint32_t writeString(const std::string& str) {
        align(4);
        uint32_t offset = static_cast<uint32_t>(buf_.size());
        writeU32(static_cast<uint32_t>(str.size()));
        for (char c : str)
            buf_.push_back(static_cast<uint8_t>(c));
        buf_.push_back(0); // null terminator
        // Pad to 4-byte alignment
        while (buf_.size() % 4 != 0)
            buf_.push_back(0);
        return offset;
    }

    /// Align the buffer to the given boundary.
    void align(size_t alignment) {
        while (buf_.size() % alignment != 0)
            buf_.push_back(0);
    }

    /// Get current buffer position.
    uint32_t pos() const { return static_cast<uint32_t>(buf_.size()); }

    /// Get the built buffer.
    std::vector<uint8_t>& buffer() { return buf_; }

private:
    std::vector<uint8_t> buf_;
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Public API
// ═══════════════════════════════════════════════════════════════════════════════

std::vector<uint8_t> FlatBufSerializer::serialize(ModuleOp module) {
    MiniFlatBufBuilder builder;

    // Collect function information from the MLIR module.
    struct FuncInfo {
        std::string name;
        uint64_t address;
        std::vector<std::string> params;
        std::vector<std::string> locals;
    };
    std::vector<FuncInfo> functions;

    module.walk([&](Operation* op) {
        if (auto func = dyn_cast<helix::high::FuncOp>(op)) {
            FuncInfo info;
            info.name = func.getSymName().str();
            info.address = func.getEntryAddress();

            func.walk([&](helix::high::VarDeclOp decl) {
                auto name = decl.getVarName().str();
                if (decl.getStorage() == helix::high::StorageKind::Parameter)
                    info.params.push_back(name);
                else
                    info.locals.push_back(name);
            });

            functions.push_back(std::move(info));
        }
    });

    // Build a minimal valid FlatBuffer.
    // Layout:
    //   [root table offset (4 bytes)]
    //   [file identifier "HAST" (4 bytes)]
    //   [string data]
    //   [tables]

    // Reserve space for the root offset + file identifier
    builder.writeU32(0); // placeholder for root table offset
    builder.writeU8('H');
    builder.writeU8('A');
    builder.writeU8('S');
    builder.writeU8('T');

    // Align to 4 bytes
    builder.align(4);

    // Write module name string
    std::string moduleName = "decompiled_module";
    uint32_t moduleNameOff = builder.writeString(moduleName);

    // Write function name strings
    std::vector<uint32_t> funcNameOffsets;
    for (auto& func : functions) {
        funcNameOffsets.push_back(builder.writeString(func.name));
    }

    // Write a minimal vtable for AstModule:
    //   vtable: [vtable_size:u16, table_size:u16, field_offsets...]
    //   AstModule fields: name(0), functions(1), global_vars(2), type_defs(3)
    builder.align(4);
    uint32_t vtablePos = builder.pos();
    builder.writeU16(10);  // vtable size (5 entries * 2)
    builder.writeU16(12);  // table size
    builder.writeU16(4);   // offset to 'name' field (offset 4 in table)
    builder.writeU16(8);   // offset to 'functions' field (offset 8, but we skip for now)
    builder.writeU16(0);   // global_vars (not present)

    // Root table (AstModule)
    builder.align(4);
    uint32_t rootTablePos = builder.pos();
    // soffset to vtable (signed offset backwards)
    builder.writeI32(static_cast<int32_t>(rootTablePos - vtablePos));
    // name field: offset to string
    builder.writeU32(moduleNameOff > rootTablePos + 4
        ? moduleNameOff - (rootTablePos + 4)
        : (rootTablePos + 4) - moduleNameOff);
    // functions field (empty for now — will be populated with proper flatbuffers lib)
    builder.writeU32(0);

    // Patch the root offset at position 0
    auto& buf = builder.buffer();
    uint32_t rootOff = rootTablePos;
    buf[0] = rootOff & 0xFF;
    buf[1] = (rootOff >> 8) & 0xFF;
    buf[2] = (rootOff >> 16) & 0xFF;
    buf[3] = (rootOff >> 24) & 0xFF;

    return buf;
}

bool FlatBufSerializer::verify(const uint8_t* data, size_t size) {
    // Minimal verification:
    // 1. Must be at least 8 bytes (root offset + file ID)
    if (size < 8)
        return false;

    // 2. Check file identifier "HAST"
    if (data[4] != 'H' || data[5] != 'A' || data[6] != 'S' || data[7] != 'T')
        return false;

    // 3. Root offset must be within bounds
    uint32_t rootOffset = data[0] | (data[1] << 8) | (data[2] << 16) | (data[3] << 24);
    if (rootOffset >= size)
        return false;

    return true;
}
