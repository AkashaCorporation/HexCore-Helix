/// @file SubRegisterMap.cpp
/// @brief Implementation of the x86-64 sub-register relationship database.
///
/// Provides case-insensitive lookup of sub-register metadata for all
/// general-purpose x86-64 registers, including legacy high-byte registers
/// (AH, BH, CH, DH) and extended registers (R8-R15).

#include "helix/analysis/SubRegisterMap.h"

#include <algorithm>
#include <array>
#include <cctype>

namespace helix {

// ═══════════════════════════════════════════════════════════════════════════════
// Static Register Database
// ═══════════════════════════════════════════════════════════════════════════════

/// Internal record matching SubRegInfo but using string_view for the static
/// table (avoids heap allocation at program startup).
struct StaticSubRegEntry {
    std::string_view name;
    std::string_view parent;
    unsigned offset_bits;
    unsigned width_bits;
    bool zero_extends;
};

// clang-format off
static constexpr StaticSubRegEntry kRegTable[] = {
    // ─── RAX family ──────────────────────────────────────────────────
    {"rax",  "rax", 0,  64, false},
    {"eax",  "rax", 0,  32, true },
    {"ax",   "rax", 0,  16, false},
    {"al",   "rax", 0,   8, false},
    {"ah",   "rax", 8,   8, false},

    // ─── RBX family ──────────────────────────────────────────────────
    {"rbx",  "rbx", 0,  64, false},
    {"ebx",  "rbx", 0,  32, true },
    {"bx",   "rbx", 0,  16, false},
    {"bl",   "rbx", 0,   8, false},
    {"bh",   "rbx", 8,   8, false},

    // ─── RCX family ──────────────────────────────────────────────────
    {"rcx",  "rcx", 0,  64, false},
    {"ecx",  "rcx", 0,  32, true },
    {"cx",   "rcx", 0,  16, false},
    {"cl",   "rcx", 0,   8, false},
    {"ch",   "rcx", 8,   8, false},

    // ─── RDX family ──────────────────────────────────────────────────
    {"rdx",  "rdx", 0,  64, false},
    {"edx",  "rdx", 0,  32, true },
    {"dx",   "rdx", 0,  16, false},
    {"dl",   "rdx", 0,   8, false},
    {"dh",   "rdx", 8,   8, false},

    // ─── RSI family ──────────────────────────────────────────────────
    {"rsi",  "rsi", 0,  64, false},
    {"esi",  "rsi", 0,  32, true },
    {"si",   "rsi", 0,  16, false},
    {"sil",  "rsi", 0,   8, false},

    // ─── RDI family ──────────────────────────────────────────────────
    {"rdi",  "rdi", 0,  64, false},
    {"edi",  "rdi", 0,  32, true },
    {"di",   "rdi", 0,  16, false},
    {"dil",  "rdi", 0,   8, false},

    // ─── RBP family ──────────────────────────────────────────────────
    {"rbp",  "rbp", 0,  64, false},
    {"ebp",  "rbp", 0,  32, true },
    {"bp",   "rbp", 0,  16, false},
    {"bpl",  "rbp", 0,   8, false},

    // ─── RSP family ──────────────────────────────────────────────────
    {"rsp",  "rsp", 0,  64, false},
    {"esp",  "rsp", 0,  32, true },
    {"sp",   "rsp", 0,  16, false},
    {"spl",  "rsp", 0,   8, false},

    // ─── R8 family ───────────────────────────────────────────────────
    {"r8",   "r8",  0,  64, false},
    {"r8d",  "r8",  0,  32, true },
    {"r8w",  "r8",  0,  16, false},
    {"r8b",  "r8",  0,   8, false},

    // ─── R9 family ───────────────────────────────────────────────────
    {"r9",   "r9",  0,  64, false},
    {"r9d",  "r9",  0,  32, true },
    {"r9w",  "r9",  0,  16, false},
    {"r9b",  "r9",  0,   8, false},

    // ─── R10 family ──────────────────────────────────────────────────
    {"r10",  "r10", 0,  64, false},
    {"r10d", "r10", 0,  32, true },
    {"r10w", "r10", 0,  16, false},
    {"r10b", "r10", 0,   8, false},

    // ─── R11 family ──────────────────────────────────────────────────
    {"r11",  "r11", 0,  64, false},
    {"r11d", "r11", 0,  32, true },
    {"r11w", "r11", 0,  16, false},
    {"r11b", "r11", 0,   8, false},

    // ─── R12 family ──────────────────────────────────────────────────
    {"r12",  "r12", 0,  64, false},
    {"r12d", "r12", 0,  32, true },
    {"r12w", "r12", 0,  16, false},
    {"r12b", "r12", 0,   8, false},

    // ─── R13 family ──────────────────────────────────────────────────
    {"r13",  "r13", 0,  64, false},
    {"r13d", "r13", 0,  32, true },
    {"r13w", "r13", 0,  16, false},
    {"r13b", "r13", 0,   8, false},

    // ─── R14 family ──────────────────────────────────────────────────
    {"r14",  "r14", 0,  64, false},
    {"r14d", "r14", 0,  32, true },
    {"r14w", "r14", 0,  16, false},
    {"r14b", "r14", 0,   8, false},

    // ─── R15 family ──────────────────────────────────────────────────
    {"r15",  "r15", 0,  64, false},
    {"r15d", "r15", 0,  32, true },
    {"r15w", "r15", 0,  16, false},
    {"r15b", "r15", 0,   8, false},

    // ─── RIP family ──────────────────────────────────────────────────
    {"rip",  "rip", 0,  64, false},
    {"eip",  "rip", 0,  32, true },
};
// clang-format on

static constexpr size_t kRegTableSize =
    sizeof(kRegTable) / sizeof(kRegTable[0]);

// ═══════════════════════════════════════════════════════════════════════════════
// Case-Insensitive Lookup Helper
// ═══════════════════════════════════════════════════════════════════════════════

/// Convert a string_view to lowercase in a stack-allocated buffer.
/// Returns a string_view into the buffer.  Buffer must outlive the returned
/// view.  Maximum register name length is 5 characters (e.g., "r15b\0").
static std::string toLower(std::string_view sv) {
    std::string result;
    result.reserve(sv.size());
    for (char c : sv)
        result.push_back(static_cast<char>(std::tolower(static_cast<unsigned char>(c))));
    return result;
}

/// Find a register entry in the static table by case-insensitive name.
static const StaticSubRegEntry* findEntry(std::string_view reg) {
    auto lower = toLower(reg);
    for (size_t i = 0; i < kRegTableSize; ++i) {
        if (kRegTable[i].name == lower)
            return &kRegTable[i];
    }
    return nullptr;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Public API
// ═══════════════════════════════════════════════════════════════════════════════

std::optional<SubRegInfo> SubRegisterMap::lookup(std::string_view reg) {
    const auto* entry = findEntry(reg);
    if (!entry)
        return std::nullopt;

    SubRegInfo info;
    info.name = std::string(entry->name);
    info.parent = std::string(entry->parent);
    info.offset_bits = entry->offset_bits;
    info.width_bits = entry->width_bits;
    info.zero_extends = entry->zero_extends;
    return info;
}

std::string_view SubRegisterMap::getParent64(std::string_view reg) {
    const auto* entry = findEntry(reg);
    if (!entry)
        return {};
    return entry->parent;
}

unsigned SubRegisterMap::getWidth(std::string_view reg) {
    const auto* entry = findEntry(reg);
    if (!entry)
        return 0;
    return entry->width_bits;
}

bool SubRegisterMap::isSubOf(std::string_view child, std::string_view parent) {
    auto childParent = getParent64(child);
    auto parentParent = getParent64(parent);

    if (childParent.empty() || parentParent.empty())
        return false;

    return childParent == parentParent;
}

std::vector<SubRegInfo> SubRegisterMap::getSubRegs(std::string_view parent64) {
    auto lowerParent = toLower(parent64);
    std::vector<SubRegInfo> results;

    for (size_t i = 0; i < kRegTableSize; ++i) {
        if (kRegTable[i].parent == lowerParent) {
            SubRegInfo info;
            info.name = std::string(kRegTable[i].name);
            info.parent = std::string(kRegTable[i].parent);
            info.offset_bits = kRegTable[i].offset_bits;
            info.width_bits = kRegTable[i].width_bits;
            info.zero_extends = kRegTable[i].zero_extends;
            results.push_back(std::move(info));
        }
    }

    return results;
}

} // namespace helix
