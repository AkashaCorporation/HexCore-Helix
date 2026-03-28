/// @file DataSectionProvider.cpp
/// @brief Implementation of the binary data section reader interface.

#include "helix/analysis/DataSectionProvider.h"

#include <algorithm>
#include <cstring>

namespace helix {

// ═══════════════════════════════════════════════════════════════════════════════
// Construction
// ═══════════════════════════════════════════════════════════════════════════════

DataSectionProvider::DataSectionProvider(DataReaderFn reader)
    : reader_(std::move(reader)) {}

// ═══════════════════════════════════════════════════════════════════════════════
// Availability
// ═══════════════════════════════════════════════════════════════════════════════

bool DataSectionProvider::isAvailable() const {
    return reader_ != nullptr;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Read Operations
// ═══════════════════════════════════════════════════════════════════════════════

std::optional<uint64_t> DataSectionProvider::readWord(uint64_t addr,
                                                       unsigned byteWidth) const {
    if (!reader_)
        return std::nullopt;

    // Only support standard widths.
    if (byteWidth != 1 && byteWidth != 2 && byteWidth != 4 && byteWidth != 8)
        return std::nullopt;

    uint8_t buf[8] = {};
    size_t bytesRead = reader_(addr, buf, byteWidth);
    if (bytesRead != byteWidth)
        return std::nullopt;

    // Reconstruct the value in little-endian order (x86/x64 native).
    uint64_t value = 0;
    for (unsigned i = 0; i < byteWidth; ++i)
        value |= static_cast<uint64_t>(buf[i]) << (i * 8);

    return value;
}

std::optional<std::vector<uint8_t>>
DataSectionProvider::readBytes(uint64_t addr, size_t len) const {
    if (!reader_ || len == 0)
        return std::nullopt;

    std::vector<uint8_t> result(len);
    size_t bytesRead = reader_(addr, result.data(), len);
    if (bytesRead != len)
        return std::nullopt;

    return result;
}

std::optional<std::string> DataSectionProvider::readCString(uint64_t addr) const {
    if (!reader_)
        return std::nullopt;

    // Read in chunks to find the null terminator without over-reading.
    static constexpr size_t kMaxStringLen = 4096;
    static constexpr size_t kChunkSize = 256;

    std::string result;
    result.reserve(64);

    for (size_t offset = 0; offset < kMaxStringLen; offset += kChunkSize) {
        uint8_t chunk[kChunkSize];
        size_t toRead = std::min(kChunkSize, kMaxStringLen - offset);
        size_t bytesRead = reader_(addr + offset, chunk, toRead);

        if (bytesRead == 0)
            return std::nullopt;

        // Scan for null terminator in this chunk.
        for (size_t i = 0; i < bytesRead; ++i) {
            if (chunk[i] == '\0')
                return result;
            result.push_back(static_cast<char>(chunk[i]));
        }

        // Short read means we hit the end of the section.
        if (bytesRead < toRead)
            return std::nullopt;
    }

    // No null terminator found within limit.
    return std::nullopt;
}

} // namespace helix
