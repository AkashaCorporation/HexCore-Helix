#pragma once
/// @file DataSectionProvider.h
/// @brief Callback-based interface for reading raw bytes from the binary image.
///
/// The DataSectionProvider allows the decompilation engine to read jump table
/// entries, vtable contents, string data, etc. from the original binary without
/// coupling the engine to any particular binary loader.
///
/// The callback signature matches the C API: reads 'len' bytes from virtual
/// address 'addr' into 'buf', returning the number of bytes actually read.

#ifndef HELIX_ANALYSIS_DATA_SECTION_PROVIDER_H
#define HELIX_ANALYSIS_DATA_SECTION_PROVIDER_H

#include <cstddef>
#include <cstdint>
#include <functional>
#include <optional>
#include <string>
#include <vector>

namespace helix {

/// Callback type for reading raw bytes from the binary image.
///
/// @param addr  Virtual address to read from.
/// @param buf   Destination buffer.
/// @param len   Number of bytes to read.
/// @return      Number of bytes actually read (0 on failure).
using DataReaderFn = std::function<size_t(uint64_t addr, uint8_t* buf, size_t len)>;

/// Provides access to raw data sections of the binary being decompiled.
///
/// This is the bridge between the decompilation engine (which needs to read
/// jump table entries, vtable slots, string literals, etc.) and the binary
/// loader (which owns the mapped image).  The engine never directly maps
/// the binary; instead it reads through this callback-based provider.
class DataSectionProvider {
public:
    DataSectionProvider() = default;
    explicit DataSectionProvider(DataReaderFn reader);

    /// Check if the provider has a reader installed.
    [[nodiscard]] bool isAvailable() const;

    /// Read a single integer value at the given virtual address.
    ///
    /// The value is read in little-endian byte order (matching x86/x64).
    ///
    /// @param addr       Virtual address to read from.
    /// @param byteWidth  Width of the value to read (1, 2, 4, or 8 bytes).
    /// @return           The value read, or std::nullopt if read failed.
    [[nodiscard]] std::optional<uint64_t> readWord(uint64_t addr,
                                                    unsigned byteWidth) const;

    /// Read raw bytes from the binary image.
    ///
    /// @param addr  Virtual address to start reading from.
    /// @param len   Number of bytes to read.
    /// @return      The bytes read, or std::nullopt if read failed.
    [[nodiscard]] std::optional<std::vector<uint8_t>> readBytes(uint64_t addr,
                                                                 size_t len) const;

    /// Read a null-terminated C string from the binary image.
    ///
    /// Reads up to 4096 bytes looking for a null terminator.
    ///
    /// @param addr  Virtual address of the string.
    /// @return      The string, or std::nullopt if read failed or no null found.
    [[nodiscard]] std::optional<std::string> readCString(uint64_t addr) const;

private:
    DataReaderFn reader_;
};

// ─── Thread-Local Provider for MLIR Passes ──────────────────────────────────

/// Set the active DataSectionProvider for the current thread.
///
/// Call this before running the MLIR pass pipeline so that passes like
/// RecoverSwitchTables can access the binary data.  Set to nullptr after
/// the pipeline completes.
void setActiveDataSectionProvider(const DataSectionProvider* provider);

/// Get the active DataSectionProvider for the current thread.
///
/// Returns nullptr if no provider has been set (i.e., binary data access
/// is not available for this decompilation run).
const DataSectionProvider* getActiveDataSectionProvider();

} // namespace helix

#endif // HELIX_ANALYSIS_DATA_SECTION_PROVIDER_H
