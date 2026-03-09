#pragma once

#ifndef HELIX_ANALYSIS_X86_REGISTER_INFO_H
#define HELIX_ANALYSIS_X86_REGISTER_INFO_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSwitch.h"

#include <array>
#include <optional>
#include <string_view>

namespace helix::analysis {

struct X86SubRegInfo {
    llvm::StringRef parent;
    unsigned width;
    unsigned bitOffset;
};

inline std::optional<X86SubRegInfo> getX86SubRegInfo(llvm::StringRef reg) {
    auto upper = reg.upper();

    auto result = llvm::StringSwitch<std::optional<X86SubRegInfo>>(upper)
        .Case("RAX", X86SubRegInfo{"RAX", 64, 0})
        .Case("EAX", X86SubRegInfo{"RAX", 32, 0})
        .Case("AX",  X86SubRegInfo{"RAX", 16, 0})
        .Case("AL",  X86SubRegInfo{"RAX", 8,  0})
        .Case("AH",  X86SubRegInfo{"RAX", 8,  8})
        .Case("RBX", X86SubRegInfo{"RBX", 64, 0})
        .Case("EBX", X86SubRegInfo{"RBX", 32, 0})
        .Case("BX",  X86SubRegInfo{"RBX", 16, 0})
        .Case("BL",  X86SubRegInfo{"RBX", 8,  0})
        .Case("BH",  X86SubRegInfo{"RBX", 8,  8})
        .Case("RCX", X86SubRegInfo{"RCX", 64, 0})
        .Case("ECX", X86SubRegInfo{"RCX", 32, 0})
        .Case("CX",  X86SubRegInfo{"RCX", 16, 0})
        .Case("CL",  X86SubRegInfo{"RCX", 8,  0})
        .Case("CH",  X86SubRegInfo{"RCX", 8,  8})
        .Case("RDX", X86SubRegInfo{"RDX", 64, 0})
        .Case("EDX", X86SubRegInfo{"RDX", 32, 0})
        .Case("DX",  X86SubRegInfo{"RDX", 16, 0})
        .Case("DL",  X86SubRegInfo{"RDX", 8,  0})
        .Case("DH",  X86SubRegInfo{"RDX", 8,  8})
        .Case("RSI", X86SubRegInfo{"RSI", 64, 0})
        .Case("ESI", X86SubRegInfo{"RSI", 32, 0})
        .Case("SI",  X86SubRegInfo{"RSI", 16, 0})
        .Case("SIL", X86SubRegInfo{"RSI", 8,  0})
        .Case("RDI", X86SubRegInfo{"RDI", 64, 0})
        .Case("EDI", X86SubRegInfo{"RDI", 32, 0})
        .Case("DI",  X86SubRegInfo{"RDI", 16, 0})
        .Case("DIL", X86SubRegInfo{"RDI", 8,  0})
        .Case("RSP", X86SubRegInfo{"RSP", 64, 0})
        .Case("ESP", X86SubRegInfo{"RSP", 32, 0})
        .Case("SP",  X86SubRegInfo{"RSP", 16, 0})
        .Case("SPL", X86SubRegInfo{"RSP", 8,  0})
        .Case("RBP", X86SubRegInfo{"RBP", 64, 0})
        .Case("EBP", X86SubRegInfo{"RBP", 32, 0})
        .Case("BP",  X86SubRegInfo{"RBP", 16, 0})
        .Case("BPL", X86SubRegInfo{"RBP", 8,  0})
        .Case("R8",   X86SubRegInfo{"R8",  64, 0})
        .Case("R8D",  X86SubRegInfo{"R8",  32, 0})
        .Case("R8W",  X86SubRegInfo{"R8",  16, 0})
        .Case("R8B",  X86SubRegInfo{"R8",  8,  0})
        .Case("R9",   X86SubRegInfo{"R9",  64, 0})
        .Case("R9D",  X86SubRegInfo{"R9",  32, 0})
        .Case("R9W",  X86SubRegInfo{"R9",  16, 0})
        .Case("R9B",  X86SubRegInfo{"R9",  8,  0})
        .Case("R10",  X86SubRegInfo{"R10", 64, 0})
        .Case("R10D", X86SubRegInfo{"R10", 32, 0})
        .Case("R10W", X86SubRegInfo{"R10", 16, 0})
        .Case("R10B", X86SubRegInfo{"R10", 8,  0})
        .Case("R11",  X86SubRegInfo{"R11", 64, 0})
        .Case("R11D", X86SubRegInfo{"R11", 32, 0})
        .Case("R11W", X86SubRegInfo{"R11", 16, 0})
        .Case("R11B", X86SubRegInfo{"R11", 8,  0})
        .Case("R12",  X86SubRegInfo{"R12", 64, 0})
        .Case("R12D", X86SubRegInfo{"R12", 32, 0})
        .Case("R12W", X86SubRegInfo{"R12", 16, 0})
        .Case("R12B", X86SubRegInfo{"R12", 8,  0})
        .Case("R13",  X86SubRegInfo{"R13", 64, 0})
        .Case("R13D", X86SubRegInfo{"R13", 32, 0})
        .Case("R13W", X86SubRegInfo{"R13", 16, 0})
        .Case("R13B", X86SubRegInfo{"R13", 8,  0})
        .Case("R14",  X86SubRegInfo{"R14", 64, 0})
        .Case("R14D", X86SubRegInfo{"R14", 32, 0})
        .Case("R14W", X86SubRegInfo{"R14", 16, 0})
        .Case("R14B", X86SubRegInfo{"R14", 8,  0})
        .Case("R15",  X86SubRegInfo{"R15", 64, 0})
        .Case("R15D", X86SubRegInfo{"R15", 32, 0})
        .Case("R15W", X86SubRegInfo{"R15", 16, 0})
        .Case("R15B", X86SubRegInfo{"R15", 8,  0})
        .Case("XMM0",  X86SubRegInfo{"XMM0",  64, 0})
        .Case("XMM1",  X86SubRegInfo{"XMM1",  64, 0})
        .Case("XMM2",  X86SubRegInfo{"XMM2",  64, 0})
        .Case("XMM3",  X86SubRegInfo{"XMM3",  64, 0})
        .Case("XMM4",  X86SubRegInfo{"XMM4",  64, 0})
        .Case("XMM5",  X86SubRegInfo{"XMM5",  64, 0})
        .Case("XMM6",  X86SubRegInfo{"XMM6",  64, 0})
        .Case("XMM7",  X86SubRegInfo{"XMM7",  64, 0})
        .Case("XMM8",  X86SubRegInfo{"XMM8",  64, 0})
        .Case("XMM9",  X86SubRegInfo{"XMM9",  64, 0})
        .Case("XMM10", X86SubRegInfo{"XMM10", 64, 0})
        .Case("XMM11", X86SubRegInfo{"XMM11", 64, 0})
        .Case("XMM12", X86SubRegInfo{"XMM12", 64, 0})
        .Case("XMM13", X86SubRegInfo{"XMM13", 64, 0})
        .Case("XMM14", X86SubRegInfo{"XMM14", 64, 0})
        .Case("XMM15", X86SubRegInfo{"XMM15", 64, 0})
        .Default(std::nullopt);

    return result;
}

inline llvm::StringRef getCanonicalX86Register(llvm::StringRef reg) {
    if (auto info = getX86SubRegInfo(reg))
        return info->parent;
    return {};
}

inline bool areX86RegistersAliased(llvm::StringRef lhs, llvm::StringRef rhs) {
    auto lhsCanonical = getCanonicalX86Register(lhs);
    auto rhsCanonical = getCanonicalX86Register(rhs);
    return !lhsCanonical.empty() && lhsCanonical == rhsCanonical;
}

inline bool isX86VectorRegister(llvm::StringRef reg) {
    auto upper = reg.upper();
    return upper.starts_with("XMM") || upper.starts_with("YMM") ||
           upper.starts_with("ZMM");
}

inline bool isX86GeneralPurposeReturnRegister(llvm::StringRef reg) {
    return getCanonicalX86Register(reg) == "RAX";
}

inline bool isWin64VolatileX86Register(llvm::StringRef reg) {
    auto canonical = getCanonicalX86Register(reg);
    return canonical == "RAX" || canonical == "RCX" || canonical == "RDX" ||
           canonical == "R8" || canonical == "R9" || canonical == "R10" ||
           canonical == "R11";
}

inline std::optional<unsigned>
getX86ArgumentRegisterIndex(llvm::StringRef reg,
                            llvm::ArrayRef<std::string_view> abiArgs) {
    auto canonical = getCanonicalX86Register(reg);
    if (canonical.empty())
        return std::nullopt;

    for (size_t i = 0; i < abiArgs.size(); ++i) {
        if (canonical == llvm::StringRef(abiArgs[i].data(), abiArgs[i].size()))
            return static_cast<unsigned>(i + 1);
    }

    return std::nullopt;
}

} // namespace helix::analysis

#endif // HELIX_ANALYSIS_X86_REGISTER_INFO_H
