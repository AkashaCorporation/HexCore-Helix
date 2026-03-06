/// @file RemillDemangler.cpp
/// @brief Utilities for demangling Remill semantic function names.
///
/// Port of the Rust decode_mangled_name logic from
/// crates/helix-core/src/ir/remill.rs to C++23.

#include "helix/analysis/RemillDemangler.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSwitch.h"
#include <charconv>
#include <optional>
#include <string>
#include <string_view>

namespace helix {

// ---- Internal helpers -------------------------------------------------------

namespace {

/// The constant Itanium ABI prefix for anonymous-namespace symbols emitted
/// by Remill:  `_ZN12_GLOBAL__N_1`
constexpr std::string_view kRemillMangledPrefix = "_ZN12_GLOBAL__N_1";

/// Split leading ASCII digits from a string.
/// Returns {digit_part, rest}.  If the string does not start with a digit,
/// digit_part is empty.
std::pair<std::string_view, std::string_view>
splitNumericPrefix(std::string_view s) {
    size_t pos = 0;
    while (pos < s.size() && s[pos] >= '0' && s[pos] <= '9')
        ++pos;
    return {s.substr(0, pos), s.substr(pos)};
}

/// Map a Jcc mnemonic (e.g. "JZ", "JNE", "JA") to the canonical
/// RemillSemantic enum value.  Remill may emit either the primary or
/// alternate name for a condition code; we normalise here.
///
/// Canonical mapping (x86 conventions):
///   JZ / JE         -> JZ
///   JNZ / JNE       -> JNZ
///   JB / JC / JNAE  -> JB
///   JNB / JNC / JAE -> JNB
///   JBE / JNA       -> JBE
///   JNBE / JA       -> JNBE
///   JL / JNGE       -> JL
///   JNL / JGE       -> JNL
///   JLE / JNG       -> JLE
///   JNLE / JG       -> JNLE
///   JS              -> JS
///   JNS             -> JNS
///   JO              -> JO
///   JNO             -> JNO
///   JP / JPE        -> JP
///   JNP / JPO       -> JNP
RemillSemantic classifyJcc(std::string_view name) {
    // Primary names first, then aliases.
    if (name == "JZ"   || name == "JE")                 return RemillSemantic::JZ;
    if (name == "JNZ"  || name == "JNE")                return RemillSemantic::JNZ;
    if (name == "JB"   || name == "JC"   || name == "JNAE")  return RemillSemantic::JB;
    if (name == "JNB"  || name == "JNC"  || name == "JAE")   return RemillSemantic::JNB;
    if (name == "JBE"  || name == "JNA")                return RemillSemantic::JBE;
    if (name == "JNBE" || name == "JA")                 return RemillSemantic::JNBE;
    if (name == "JL"   || name == "JNGE")               return RemillSemantic::JL;
    if (name == "JNL"  || name == "JGE")                return RemillSemantic::JNL;
    if (name == "JLE"  || name == "JNG")                return RemillSemantic::JLE;
    if (name == "JNLE" || name == "JG")                 return RemillSemantic::JNLE;
    if (name == "JS")                                   return RemillSemantic::JS;
    if (name == "JNS")                                  return RemillSemantic::JNS;
    if (name == "JO")                                   return RemillSemantic::JO;
    if (name == "JNO")                                  return RemillSemantic::JNO;
    if (name == "JP"   || name == "JPE")                return RemillSemantic::JP;
    if (name == "JNP"  || name == "JPO")                return RemillSemantic::JNP;

    // Unknown jump condition -- still treat as Unknown rather than silently
    // bucketing into an incorrect Jcc.
    return RemillSemantic::Unknown;
}

/// Classify a raw semantic name string extracted from the mangled symbol into
/// a RemillSemantic enum value.  Mirrors the Rust `match semantic_name { ... }`
/// block in decode_mangled_name().
RemillSemantic classifySemantic(std::string_view name) {
    // ---- Data movement ------------------------------------------------------
    if (name == "MOV"   || name == "MOVI")   return RemillSemantic::MOV;
    if (name == "MOVZX" || name == "MOVZXI") return RemillSemantic::MOVZX;
    if (name == "MOVSX" || name == "MOVSXI" || name == "MOVSXD")
                                              return RemillSemantic::MOVSX;
    if (name == "XCHG"  || name == "XCHGI")  return RemillSemantic::XCHG;
    if (name == "LEA"   || name == "LEAI")   return RemillSemantic::LEA;
    if (name == "CDQE"  || name == "CQO"  || name == "CBW")
                                              return RemillSemantic::CDQE;
    if (name == "CDQ"   || name == "CWD")    return RemillSemantic::CDQ;

    // ---- Arithmetic ---------------------------------------------------------
    if (name == "ADD"   || name == "ADDI")   return RemillSemantic::ADD;
    if (name == "SUB"   || name == "SUBI")   return RemillSemantic::SUB;
    if (name == "MUL"   || name == "MULI")   return RemillSemantic::MUL;
    if (name == "IMUL"  || name == "IMULI")  return RemillSemantic::IMUL;
    if (name == "DIV"   || name == "DIVI")   return RemillSemantic::DIV;
    if (name == "IDIV"  || name == "IDIVI")  return RemillSemantic::IDIV;
    if (name == "INC"   || name == "INCI")   return RemillSemantic::INC;
    if (name == "DEC"   || name == "DECI")   return RemillSemantic::DEC;
    if (name == "NEG"   || name == "NEGI")   return RemillSemantic::NEG;

    // ---- Logic / Bitwise ----------------------------------------------------
    if (name == "AND"   || name == "ANDI")   return RemillSemantic::AND;
    if (name == "OR"    || name == "ORI")    return RemillSemantic::OR;
    if (name == "XOR"   || name == "XORI")   return RemillSemantic::XOR;
    if (name == "NOT"   || name == "NOTI")   return RemillSemantic::NOT;
    if (name == "SHL"   || name == "SHLI")   return RemillSemantic::SHL;
    if (name == "SHR"   || name == "SHRI")   return RemillSemantic::SHR;
    if (name == "SAR"   || name == "SARI")   return RemillSemantic::SAR;
    if (name == "ROL"   || name == "ROLI")   return RemillSemantic::ROL;
    if (name == "ROR"   || name == "RORI")   return RemillSemantic::ROR;

    // ---- Comparison ---------------------------------------------------------
    if (name == "CMP"   || name == "CMPI")   return RemillSemantic::CMP;
    if (name == "TEST"  || name == "TESTI")  return RemillSemantic::TEST;

    // ---- Stack --------------------------------------------------------------
    if (name == "PUSH"  || name == "PUSHI")  return RemillSemantic::PUSH;
    if (name == "POP"   || name == "POPI")   return RemillSemantic::POP;

    // ---- Control flow (non-conditional) -------------------------------------
    if (name == "CALL"  || name == "CALLI")  return RemillSemantic::CALL;
    if (name == "RET"   || name == "RETE" || name == "RETN")
                                              return RemillSemantic::RET;
    if (name == "JMP"   || name == "JMPI")   return RemillSemantic::JMP;

    // ---- Bit manipulation ---------------------------------------------------
    if (name == "BSF"   || name == "BSFI")   return RemillSemantic::BSF;
    if (name == "BSR"   || name == "BSRI")   return RemillSemantic::BSR;
    if (name == "BSWAP" || name == "BSWAPI") return RemillSemantic::BSWAP;
    if (name == "BT"    || name == "BTI")    return RemillSemantic::BT;
    if (name == "BTS"   || name == "BTSI")   return RemillSemantic::BTS;
    if (name == "BTR"   || name == "BTRI")   return RemillSemantic::BTR;
    if (name == "BTC"   || name == "BTCI")   return RemillSemantic::BTC;

    // ---- String operations --------------------------------------------------
    // Handled below in the fallback section (REP* prefix logic).

    // ---- Special ------------------------------------------------------------
    if (name == "NOP"   || name == "NOPI" || name == "NOP_IMPL")
                                              return RemillSemantic::NOP;
    if (name == "DoINT3")                    return RemillSemantic::INT3;
    if (name == "SYSCALL")                   return RemillSemantic::SYSCALL;
    if (name == "CPUID")                     return RemillSemantic::CPUID;

    // ---- x87 FPU ------------------------------------------------------------
    if (name == "FLD"   || name == "FLDI")   return RemillSemantic::FLD;
    if (name == "FST"   || name == "FSTI")   return RemillSemantic::FST;
    if (name == "FSTP"  || name == "FSTPI")  return RemillSemantic::FSTP;
    if (name == "FADD"  || name == "FADDI")  return RemillSemantic::FADD;
    if (name == "FSUB"  || name == "FSUBI")  return RemillSemantic::FSUB;
    if (name == "FMUL"  || name == "FMULI")  return RemillSemantic::FMUL;
    if (name == "FDIV"  || name == "FDIVI")  return RemillSemantic::FDIV;

    // ---- SSE/AVX scalar -----------------------------------------------------
    if (name == "MOVSS"  || name == "MOVSSI")  return RemillSemantic::MOVSS;
    if (name == "MOVSD"  || name == "MOVSDI")  return RemillSemantic::MOVSD;
    if (name == "MOVAPS" || name == "MOVAPSI") return RemillSemantic::MOVAPS;
    if (name == "MOVUPS" || name == "MOVUPSI") return RemillSemantic::MOVUPS;
    if (name == "ADDSS"  || name == "ADDSSI")  return RemillSemantic::ADDSS;
    if (name == "ADDSD"  || name == "ADDSDI")  return RemillSemantic::ADDSD;
    if (name == "MULSS"  || name == "MULSSI")  return RemillSemantic::MULSS;
    if (name == "MULSD"  || name == "MULSDI")  return RemillSemantic::MULSD;
    if (name == "SUBSS"  || name == "SUBSSI")  return RemillSemantic::SUBSS;
    if (name == "SUBSD"  || name == "SUBSDI")  return RemillSemantic::SUBSD;
    if (name == "DIVSS"  || name == "DIVSSI")  return RemillSemantic::DIVSS;
    if (name == "DIVSD"  || name == "DIVSDI")  return RemillSemantic::DIVSD;
    if (name == "XORPS"  || name == "XORPSI")  return RemillSemantic::XORPS;
    if (name == "XORPD"  || name == "XORPDI")  return RemillSemantic::XORPD;
    if (name == "PXOR"   || name == "PXORI")   return RemillSemantic::PXOR;

    // ---- SSE/AVX packed & misc ------------------------------------------
    if (name == "MOVxPS")                       return RemillSemantic::MOVxPS;
    if (name == "MOVSS_MEM")                    return RemillSemantic::MOVSS_MEM;
    if (name == "SHUFPS" || name == "SHUFPSI")  return RemillSemantic::SHUFPS;
    if (name == "SUBPS"  || name == "SUBPSI")   return RemillSemantic::SUBPS;
    if (name == "ADDPS"  || name == "ADDPSI")   return RemillSemantic::ADDPS;
    if (name == "MULPS"  || name == "MULPSI")   return RemillSemantic::MULPS;
    if (name == "COMISS" || name == "COMISSI")  return RemillSemantic::COMISS;
    if (name == "UNPCKHPS")                     return RemillSemantic::UNPCKHPS;

    // ---- PREFETCH (hint, no semantic effect) ----------------------------
    if (name == "PREFETCH" || name == "PREFETCHI") return RemillSemantic::PREFETCH;

    // ---- CMPXCHG variants ----------------------------------------------
    if (name.starts_with("CMPXCHG"))            return RemillSemantic::CMPXCHG;

    // ---- SETcc (conditional byte set) ----------------------------------
    if (name.starts_with("SET"))                return RemillSemantic::SETcc;

    // ---- CDQ/CDQE with register suffix ---------------------------------
    if (name == "CDQ_EAX")                      return RemillSemantic::CDQ_EAX;
    if (name == "CDQE_EAX")                     return RemillSemantic::CDQE_EAX;

    // ---- HandleUnsupported (Remill catch-all) ---------------------------
    if (name == "HandleUnsupported")            return RemillSemantic::HANDLE_UNSUPPORTED;

    // ---- Fallback: conditional jumps (J<cc>), conditional moves (CMOV<cc>),
    //       and REP-prefixed string instructions ----------------------------

    // Conditional jumps: any name starting with 'J' and at least 2 chars.
    if (name.size() >= 2 && name[0] == 'J') {
        return classifyJcc(name);
    }

    // Conditional moves: CMOV<cc> (the suffix after "CMOV" is the condition).
    if (name.size() > 4 && name.starts_with("CMOV")) {
        return RemillSemantic::CMOV;
    }

    // REP-prefixed string instructions: REPMOVS*, REPSTOS*, REPCMPS*, REPSCAS*.
    if (name.starts_with("REP")) {
        std::string_view suffix = name.substr(3);
        if (suffix.starts_with("MOVS"))  return RemillSemantic::REP_MOVS;
        if (suffix.starts_with("STOS"))  return RemillSemantic::REP_STOS;
        if (suffix.starts_with("CMPS"))  return RemillSemantic::REP_CMPS;
        if (suffix.starts_with("SCAS"))  return RemillSemantic::REP_SCAS;
    }

    // Exchange and add (XADD) -- present in the Rust reference but not as a
    // dedicated enum value in the C++ header, so map to Unknown.  If the header
    // is later extended, this can be updated.
    // (XADD is recognised here so we don't accidentally mis-classify it.)

    return RemillSemantic::Unknown;
}

} // anonymous namespace

// ---- Public API -------------------------------------------------------------

std::optional<RemillSemanticInfo>
demangleRemillSemantic(llvm::StringRef mangled_name) {
    // Strip any trailing parenthesized function-pointer suffix that Remill
    // sometimes leaves in debug names.
    std::string_view name{mangled_name.data(), mangled_name.size()};
    if (auto paren = name.find('('); paren != std::string_view::npos)
        name = name.substr(0, paren);

    // ---- Pattern 1: Remill semantic function --------------------------------
    // _ZN12_GLOBAL__N_1<len><NAME>I...  or  _ZN12_GLOBAL__N_1<len><NAME>E...
    if (name.starts_with(kRemillMangledPrefix)) {
        std::string_view rest = name.substr(kRemillMangledPrefix.size());

        // Parse the length-prefixed name: e.g. "4CALL..." -> len=4, raw="CALL".
        auto [digits, after_digits] = splitNumericPrefix(rest);
        if (digits.empty())
            return std::nullopt;

        unsigned name_len = 0;
        auto [ptr, ec] = std::from_chars(digits.data(),
                                         digits.data() + digits.size(),
                                         name_len);
        if (ec != std::errc{} || name_len == 0)
            return std::nullopt;

        if (after_digits.size() < name_len)
            return std::nullopt;

        std::string_view semantic_name = after_digits.substr(0, name_len);
        std::string raw{semantic_name};

        RemillSemantic sem = classifySemantic(semantic_name);

        // Analyze the operand suffix for memory operand types.
        // Pattern: After the semantic name, the mangled suffix contains
        // template arguments like:
        //   I3MnWIjE...  → first operand is MnW (memory write dest), j=uint32
        //   I3RnWImE2MnIjE...  → first is RnW (register dest), second is MnI (memory source), j=uint32
        //   I3MnWImE2RnImLb1EE... → MnW dest (memory write), Rn src (register)
        std::string_view suffix = after_digits.substr(name_len);
        bool has_mem_src = false;
        bool has_mem_dst = false;
        unsigned src_w = 64;

        // Find the first operand type (destination):
        // "3MnW" = memory write destination
        // "3RnW" = register write destination
        if (suffix.find("MnW") != std::string_view::npos) {
            has_mem_dst = true;
        }

        // Find if there's a memory source operand (Mn without W following it).
        // We look for "Mn" that is NOT part of "MnW".
        // Pattern: "2MnI" = memory read source.
        {
            auto pos = suffix.find("MnI");
            // MnW also has Mn, so check it's not MnW
            if (pos != std::string_view::npos) {
                // Check that this Mn is NOT preceded by a context that makes it MnW.
                // If "MnW" exists, the "MnI" we found might be a second one (the source).
                // Just check: if the "MnI" is at a different position than where "MnW" starts.
                auto mnw_pos = suffix.find("MnW");
                if (mnw_pos == std::string_view::npos || pos != mnw_pos) {
                    has_mem_src = true;
                    // Infer width from the type char after "MnI":
                    // IjE = uint32 (32-bit), ImE = uint64 (64-bit),
                    // IhE = uint8 (8-bit), ItE = uint16 (16-bit)
                    if (pos + 3 < suffix.size()) {
                        char typeChar = suffix[pos + 3];
                        if (typeChar == 'j') src_w = 32;
                        else if (typeChar == 'm') src_w = 64;
                        else if (typeChar == 'h') src_w = 8;
                        else if (typeChar == 't') src_w = 16;
                    }
                }
            }
        }

        return RemillSemanticInfo{sem, std::move(raw), /*is_helper=*/false,
                                  has_mem_src, has_mem_dst, src_w};
    }

    // ---- Pattern 2: __remill_{read,write}_memory_<N> intrinsics -------------
    if (name.starts_with("__remill_read_memory_") ||
        name.starts_with("__remill_write_memory_")) {
        return RemillSemanticInfo{
            RemillSemantic::Unknown,
            std::string(name),
            /*is_helper=*/true
        };
    }

    // ---- Pattern 3: __remill_flag_computation_<name> ------------------------
    if (name.starts_with("__remill_flag_computation_")) {
        return RemillSemanticInfo{
            RemillSemantic::Unknown,
            std::string(name),
            /*is_helper=*/true
        };
    }

    // ---- Pattern 4: other __remill_* helpers --------------------------------
    if (name.starts_with("__remill_")) {
        return RemillSemanticInfo{
            RemillSemantic::Unknown,
            std::string(name),
            /*is_helper=*/true
        };
    }

    // ---- Pattern 5: LLVM intrinsics (llvm.ctpop.*, etc.) --------------------
    if (name.starts_with("llvm.")) {
        return RemillSemanticInfo{
            RemillSemantic::Unknown,
            std::string(name),
            /*is_helper=*/true
        };
    }

    // Not a recognised Remill / intrinsic name.
    return std::nullopt;
}

// ---- extractRemillMemoryWidth -----------------------------------------------

unsigned extractRemillMemoryWidth(llvm::StringRef intrinsic_name) {
    // Accept both read and write:
    //   __remill_read_memory_8   -> 8
    //   __remill_write_memory_64 -> 64
    std::string_view name{intrinsic_name.data(), intrinsic_name.size()};

    constexpr std::string_view kReadPrefix  = "__remill_read_memory_";
    constexpr std::string_view kWritePrefix = "__remill_write_memory_";

    std::string_view suffix;
    if (name.starts_with(kReadPrefix))
        suffix = name.substr(kReadPrefix.size());
    else if (name.starts_with(kWritePrefix))
        suffix = name.substr(kWritePrefix.size());
    else
        return 0;

    unsigned width = 0;
    auto [ptr, ec] = std::from_chars(suffix.data(),
                                     suffix.data() + suffix.size(),
                                     width);
    if (ec != std::errc{})
        return 0;

    // Sanity: only accept known memory widths.
    if (width == 8 || width == 16 || width == 32 || width == 64 || width == 128)
        return width;

    return 0;
}

// ---- semanticToString -------------------------------------------------------

llvm::StringRef semanticToString(RemillSemantic semantic) {
    switch (semantic) {
    // Data movement
    case RemillSemantic::MOV:    return "MOV";
    case RemillSemantic::MOVZX:  return "MOVZX";
    case RemillSemantic::MOVSX:  return "MOVSX";
    case RemillSemantic::CMOV:   return "CMOV";
    case RemillSemantic::XCHG:   return "XCHG";
    case RemillSemantic::LEA:    return "LEA";
    case RemillSemantic::CDQ:    return "CDQ";
    case RemillSemantic::CDQE:   return "CDQE";

    // Arithmetic
    case RemillSemantic::ADD:    return "ADD";
    case RemillSemantic::SUB:    return "SUB";
    case RemillSemantic::MUL:    return "MUL";
    case RemillSemantic::IMUL:   return "IMUL";
    case RemillSemantic::DIV:    return "DIV";
    case RemillSemantic::IDIV:   return "IDIV";
    case RemillSemantic::INC:    return "INC";
    case RemillSemantic::DEC:    return "DEC";
    case RemillSemantic::NEG:    return "NEG";

    // Logic
    case RemillSemantic::AND:    return "AND";
    case RemillSemantic::OR:     return "OR";
    case RemillSemantic::XOR:    return "XOR";
    case RemillSemantic::NOT:    return "NOT";
    case RemillSemantic::SHL:    return "SHL";
    case RemillSemantic::SHR:    return "SHR";
    case RemillSemantic::SAR:    return "SAR";
    case RemillSemantic::ROL:    return "ROL";
    case RemillSemantic::ROR:    return "ROR";

    // Comparison
    case RemillSemantic::CMP:    return "CMP";
    case RemillSemantic::TEST:   return "TEST";

    // Stack
    case RemillSemantic::PUSH:   return "PUSH";
    case RemillSemantic::POP:    return "POP";

    // Control flow
    case RemillSemantic::CALL:   return "CALL";
    case RemillSemantic::RET:    return "RET";
    case RemillSemantic::JMP:    return "JMP";
    case RemillSemantic::JZ:     return "JZ";
    case RemillSemantic::JNZ:    return "JNZ";
    case RemillSemantic::JB:     return "JB";
    case RemillSemantic::JNB:    return "JNB";
    case RemillSemantic::JBE:    return "JBE";
    case RemillSemantic::JNBE:   return "JNBE";
    case RemillSemantic::JL:     return "JL";
    case RemillSemantic::JNL:    return "JNL";
    case RemillSemantic::JLE:    return "JLE";
    case RemillSemantic::JNLE:   return "JNLE";
    case RemillSemantic::JS:     return "JS";
    case RemillSemantic::JNS:    return "JNS";
    case RemillSemantic::JO:     return "JO";
    case RemillSemantic::JNO:    return "JNO";
    case RemillSemantic::JP:     return "JP";
    case RemillSemantic::JNP:    return "JNP";

    // Bit manipulation
    case RemillSemantic::BSF:    return "BSF";
    case RemillSemantic::BSR:    return "BSR";
    case RemillSemantic::BSWAP:  return "BSWAP";
    case RemillSemantic::BT:     return "BT";
    case RemillSemantic::BTS:    return "BTS";
    case RemillSemantic::BTR:    return "BTR";
    case RemillSemantic::BTC:    return "BTC";

    // String operations
    case RemillSemantic::REP_MOVS: return "REP_MOVS";
    case RemillSemantic::REP_STOS: return "REP_STOS";
    case RemillSemantic::REP_CMPS: return "REP_CMPS";
    case RemillSemantic::REP_SCAS: return "REP_SCAS";

    // Special
    case RemillSemantic::NOP:      return "NOP";
    case RemillSemantic::INT3:     return "INT3";
    case RemillSemantic::SYSCALL:  return "SYSCALL";
    case RemillSemantic::CPUID:    return "CPUID";

    // x87 FPU
    case RemillSemantic::FLD:    return "FLD";
    case RemillSemantic::FST:    return "FST";
    case RemillSemantic::FSTP:   return "FSTP";
    case RemillSemantic::FADD:   return "FADD";
    case RemillSemantic::FSUB:   return "FSUB";
    case RemillSemantic::FMUL:   return "FMUL";
    case RemillSemantic::FDIV:   return "FDIV";

    // SSE/AVX
    case RemillSemantic::MOVSS:  return "MOVSS";
    case RemillSemantic::MOVSD:  return "MOVSD";
    case RemillSemantic::MOVAPS: return "MOVAPS";
    case RemillSemantic::MOVUPS: return "MOVUPS";
    case RemillSemantic::ADDSS:  return "ADDSS";
    case RemillSemantic::ADDSD:  return "ADDSD";
    case RemillSemantic::MULSS:  return "MULSS";
    case RemillSemantic::MULSD:  return "MULSD";
    case RemillSemantic::SUBSS:  return "SUBSS";
    case RemillSemantic::SUBSD:  return "SUBSD";
    case RemillSemantic::DIVSS:  return "DIVSS";
    case RemillSemantic::DIVSD:  return "DIVSD";
    case RemillSemantic::XORPS:  return "XORPS";
    case RemillSemantic::XORPD:  return "XORPD";
    case RemillSemantic::PXOR:   return "PXOR";

    // SSE/AVX packed & misc
    case RemillSemantic::MOVxPS:      return "MOVxPS";
    case RemillSemantic::MOVSS_MEM:   return "MOVSS_MEM";
    case RemillSemantic::SHUFPS:      return "SHUFPS";
    case RemillSemantic::SUBPS:       return "SUBPS";
    case RemillSemantic::ADDPS:       return "ADDPS";
    case RemillSemantic::MULPS:       return "MULPS";
    case RemillSemantic::COMISS:      return "COMISS";
    case RemillSemantic::UNPCKHPS:    return "UNPCKHPS";

    // SETcc
    case RemillSemantic::SETcc:       return "SETcc";

    // CMPXCHG
    case RemillSemantic::CMPXCHG:     return "CMPXCHG";

    // PREFETCH
    case RemillSemantic::PREFETCH:    return "PREFETCH";

    // CDQ/CDQE variants
    case RemillSemantic::CDQ_EAX:     return "CDQ_EAX";
    case RemillSemantic::CDQE_EAX:    return "CDQE_EAX";

    // HandleUnsupported
    case RemillSemantic::HANDLE_UNSUPPORTED: return "HandleUnsupported";

    // Unrecognized
    case RemillSemantic::Unknown: return "Unknown";
    }

    // Unreachable if all enum values are covered, but silence compiler warnings.
    return "Unknown";
}

// ---- isConditionalJump ------------------------------------------------------

bool isConditionalJump(RemillSemantic semantic) {
    switch (semantic) {
    case RemillSemantic::JZ:
    case RemillSemantic::JNZ:
    case RemillSemantic::JB:
    case RemillSemantic::JNB:
    case RemillSemantic::JBE:
    case RemillSemantic::JNBE:
    case RemillSemantic::JL:
    case RemillSemantic::JNL:
    case RemillSemantic::JLE:
    case RemillSemantic::JNLE:
    case RemillSemantic::JS:
    case RemillSemantic::JNS:
    case RemillSemantic::JO:
    case RemillSemantic::JNO:
    case RemillSemantic::JP:
    case RemillSemantic::JNP:
        return true;
    default:
        return false;
    }
}

// ---- getJccCondition --------------------------------------------------------

std::optional<std::string> getJccCondition(RemillSemantic semantic) {
    switch (semantic) {
    case RemillSemantic::JZ:   return "z";
    case RemillSemantic::JNZ:  return "nz";
    case RemillSemantic::JB:   return "b";
    case RemillSemantic::JNB:  return "nb";
    case RemillSemantic::JBE:  return "be";
    case RemillSemantic::JNBE: return "nbe";
    case RemillSemantic::JL:   return "l";
    case RemillSemantic::JNL:  return "nl";
    case RemillSemantic::JLE:  return "le";
    case RemillSemantic::JNLE: return "nle";
    case RemillSemantic::JS:   return "s";
    case RemillSemantic::JNS:  return "ns";
    case RemillSemantic::JO:   return "o";
    case RemillSemantic::JNO:  return "no";
    case RemillSemantic::JP:   return "p";
    case RemillSemantic::JNP:  return "np";
    default:
        return std::nullopt;
    }
}

} // namespace helix
