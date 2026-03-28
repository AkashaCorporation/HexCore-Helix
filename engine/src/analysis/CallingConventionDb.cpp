/// @file CallingConventionDb.cpp
/// @brief Calling convention database implementation.
///
/// Provides parametric ABI specifications for Win64, SysV AMD64, ARM64 AAPCS,
/// x86 cdecl/fastcall, MIPS O32/N64, and RISC-V LP64. Each specification
/// captures argument registers, return registers, callee-saved sets, stack
/// layout, and struct return thresholds for use by the calling convention
/// recovery pass.

#include "helix/analysis/CallingConventionDb.h"
#include "helix/Types.h"

#include <algorithm>
#include <cassert>
#include <format>

using namespace helix;

// ─── CallingConventionSpec helper methods ────────────────────────────────────

static bool containsReg(const std::vector<std::string>& regs,
                         std::string_view reg) {
    return std::find(regs.begin(), regs.end(), reg) != regs.end();
}

bool CallingConventionSpec::isCalleeSaved(std::string_view reg) const {
    return containsReg(callee_saved_regs, reg);
}

bool CallingConventionSpec::isVolatile(std::string_view reg) const {
    return containsReg(volatile_regs, reg);
}

bool CallingConventionSpec::isIntArgReg(std::string_view reg) const {
    return containsReg(int_arg_regs, reg);
}

bool CallingConventionSpec::isFloatArgReg(std::string_view reg) const {
    return containsReg(float_arg_regs, reg);
}

std::optional<unsigned>
CallingConventionSpec::getIntArgIndex(std::string_view reg) const {
    for (unsigned i = 0; i < int_arg_regs.size(); ++i) {
        if (int_arg_regs[i] == reg)
            return i;
    }
    return std::nullopt;
}

std::optional<unsigned>
CallingConventionSpec::getFloatArgIndex(std::string_view reg) const {
    for (unsigned i = 0; i < float_arg_regs.size(); ++i) {
        if (float_arg_regs[i] == reg)
            return i;
    }
    return std::nullopt;
}

// ─── CallingConventionDb ─────────────────────────────────────────────────────

CallingConventionDb::CallingConventionDb() {
    initBuiltins();
}

const CallingConventionSpec& CallingConventionDb::getDefault(int arch) const {
    auto it = default_map_.find(arch);
    assert(it != default_map_.end() && "No default convention for architecture");
    return specs_[it->second];
}

const CallingConventionSpec*
CallingConventionDb::getByName(std::string_view name) const {
    auto it = name_map_.find(std::string(name));
    if (it == name_map_.end())
        return nullptr;
    return &specs_[it->second];
}

std::vector<const CallingConventionSpec*>
CallingConventionDb::getForArch(int arch) const {
    std::vector<const CallingConventionSpec*> result;
    for (const auto& spec : specs_) {
        if (spec.arch == arch)
            result.push_back(&spec);
    }
    return result;
}

// ─── Built-in calling convention definitions ─────────────────────────────────

void CallingConventionDb::initBuiltins() {
    specs_.reserve(8);

    // ─── Win64 (Microsoft x64) ──────────────────────────────────────────

    {
        CallingConventionSpec spec;
        spec.name = "win64";
        spec.arch = HELIX_ARCH_X86_64;

        spec.int_arg_regs   = {"rcx", "rdx", "r8", "r9"};
        spec.float_arg_regs = {"xmm0", "xmm1", "xmm2", "xmm3"};

        spec.int_return_regs   = {"rax"};
        spec.float_return_regs = {"xmm0"};

        spec.callee_saved_regs = {
            "rbx", "rbp", "rdi", "rsi", "rsp",
            "r12", "r13", "r14", "r15",
            "xmm6", "xmm7", "xmm8", "xmm9", "xmm10",
            "xmm11", "xmm12", "xmm13", "xmm14", "xmm15"
        };
        spec.volatile_regs = {
            "rax", "rcx", "rdx", "r8", "r9", "r10", "r11",
            "xmm0", "xmm1", "xmm2", "xmm3", "xmm4", "xmm5"
        };

        spec.stack_alignment = 16;
        spec.shadow_space    = 32;  // 4 register args * 8 bytes
        spec.red_zone        = 0;
        spec.args_right_to_left = true;

        spec.struct_return_threshold = 8;
        spec.struct_return_reg       = "rcx";  // Hidden ptr occupies first arg slot

        spec.has_varargs_support    = true;
        spec.varargs_indicator_reg  = "al";  // Float count passed in AL for varargs

        size_t idx = specs_.size();
        specs_.push_back(std::move(spec));
        name_map_["win64"] = idx;
        default_map_[HELIX_ARCH_X86_64] = idx;  // Project targets Windows primarily
    }

    // ─── SysV AMD64 (Linux/macOS x86-64) ────────────────────────────────

    {
        CallingConventionSpec spec;
        spec.name = "sysv_amd64";
        spec.arch = HELIX_ARCH_X86_64;

        spec.int_arg_regs   = {"rdi", "rsi", "rdx", "rcx", "r8", "r9"};
        spec.float_arg_regs = {
            "xmm0", "xmm1", "xmm2", "xmm3",
            "xmm4", "xmm5", "xmm6", "xmm7"
        };

        spec.int_return_regs   = {"rax", "rdx"};
        spec.float_return_regs = {"xmm0", "xmm1"};

        spec.callee_saved_regs = {
            "rbx", "rbp", "rsp", "r12", "r13", "r14", "r15"
        };
        spec.volatile_regs = {
            "rax", "rdi", "rsi", "rdx", "rcx", "r8", "r9", "r10", "r11",
            "xmm0", "xmm1", "xmm2", "xmm3", "xmm4", "xmm5",
            "xmm6", "xmm7", "xmm8", "xmm9", "xmm10",
            "xmm11", "xmm12", "xmm13", "xmm14", "xmm15"
        };

        spec.stack_alignment = 16;
        spec.shadow_space    = 0;
        spec.red_zone        = 128;
        spec.args_right_to_left = true;

        spec.struct_return_threshold = 16;
        spec.struct_return_reg       = "rdi";  // Hidden ptr in first arg slot

        spec.has_varargs_support    = true;
        spec.varargs_indicator_reg  = "al";  // Number of vector regs used

        size_t idx = specs_.size();
        specs_.push_back(std::move(spec));
        name_map_["sysv_amd64"] = idx;
        // Not the default for x86_64 (Win64 is); available by name.
    }

    // ─── ARM64 AAPCS (AArch64) ──────────────────────────────────────────

    {
        CallingConventionSpec spec;
        spec.name = "aapcs64";
        spec.arch = HELIX_ARCH_AARCH64;

        spec.int_arg_regs = {
            "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7"
        };
        spec.float_arg_regs = {
            "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7"
        };

        spec.int_return_regs   = {"x0", "x1"};
        spec.float_return_regs = {"v0", "v1", "v2", "v3"};

        spec.callee_saved_regs = {
            "x19", "x20", "x21", "x22", "x23", "x24",
            "x25", "x26", "x27", "x28",
            "x29",  // fp (frame pointer)
            "x30"   // lr (link register)
        };
        spec.volatile_regs = {
            "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7",
            "x8", "x9", "x10", "x11", "x12", "x13", "x14", "x15",
            "x16", "x17", "x18"
        };

        spec.stack_alignment = 16;
        spec.shadow_space    = 0;
        spec.red_zone        = 0;
        spec.args_right_to_left = false;

        spec.struct_return_threshold = 16;
        spec.struct_return_reg       = "x8";  // Indirect result location register

        spec.has_varargs_support   = true;
        spec.varargs_indicator_reg = "";  // No explicit indicator register

        size_t idx = specs_.size();
        specs_.push_back(std::move(spec));
        name_map_["aapcs64"] = idx;
        default_map_[HELIX_ARCH_AARCH64] = idx;
    }

    // ─── x86 cdecl ──────────────────────────────────────────────────────

    {
        CallingConventionSpec spec;
        spec.name = "cdecl";
        spec.arch = HELIX_ARCH_X86;

        spec.int_arg_regs   = {};  // All arguments passed on the stack
        spec.float_arg_regs = {};

        spec.int_return_regs   = {"eax", "edx"};  // EDX:EAX for 64-bit returns
        spec.float_return_regs = {};               // x87 ST(0) not modeled here

        spec.callee_saved_regs = {"ebx", "esi", "edi", "ebp"};
        spec.volatile_regs     = {"eax", "ecx", "edx"};

        spec.stack_alignment = 4;   // Historical 4-byte; some compilers use 16
        spec.shadow_space    = 0;
        spec.red_zone        = 0;
        spec.args_right_to_left = true;

        spec.struct_return_threshold = 8;
        spec.struct_return_reg       = "";  // Hidden pointer on stack

        spec.has_varargs_support   = true;
        spec.varargs_indicator_reg = "";

        size_t idx = specs_.size();
        specs_.push_back(std::move(spec));
        name_map_["cdecl"] = idx;
        default_map_[HELIX_ARCH_X86] = idx;
    }

    // ─── x86 fastcall ───────────────────────────────────────────────────

    {
        CallingConventionSpec spec;
        spec.name = "fastcall";
        spec.arch = HELIX_ARCH_X86;

        spec.int_arg_regs   = {"ecx", "edx"};  // First two int args in regs
        spec.float_arg_regs = {};

        spec.int_return_regs   = {"eax", "edx"};
        spec.float_return_regs = {};

        spec.callee_saved_regs = {"ebx", "esi", "edi", "ebp"};
        spec.volatile_regs     = {"eax", "ecx", "edx"};

        spec.stack_alignment = 4;
        spec.shadow_space    = 0;
        spec.red_zone        = 0;
        spec.args_right_to_left = true;

        spec.struct_return_threshold = 8;
        spec.struct_return_reg       = "";

        spec.has_varargs_support   = false;  // Fastcall does not support varargs
        spec.varargs_indicator_reg = "";

        size_t idx = specs_.size();
        specs_.push_back(std::move(spec));
        name_map_["fastcall"] = idx;
        // Not the default for x86 (cdecl is).
    }

    // ─── MIPS O32 ───────────────────────────────────────────────────────

    {
        CallingConventionSpec spec;
        spec.name = "mips_o32";
        spec.arch = HELIX_ARCH_MIPS;

        spec.int_arg_regs   = {"$a0", "$a1", "$a2", "$a3"};
        spec.float_arg_regs = {"$f12", "$f14"};

        spec.int_return_regs   = {"$v0", "$v1"};
        spec.float_return_regs = {"$f0", "$f2"};

        spec.callee_saved_regs = {
            "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
            "$fp",  // $s8 / frame pointer
            "$ra"   // return address
        };
        spec.volatile_regs = {
            "$v0", "$v1",
            "$a0", "$a1", "$a2", "$a3",
            "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
            "$t8", "$t9",
            "$at"
        };

        spec.stack_alignment = 8;
        spec.shadow_space    = 16;  // O32 reserves 16 bytes for a0-a3 home slots
        spec.red_zone        = 0;
        spec.args_right_to_left = true;

        spec.struct_return_threshold = 4;
        spec.struct_return_reg       = "$v0";

        spec.has_varargs_support   = true;
        spec.varargs_indicator_reg = "";

        size_t idx = specs_.size();
        specs_.push_back(std::move(spec));
        name_map_["mips_o32"] = idx;
        default_map_[HELIX_ARCH_MIPS] = idx;
    }

    // ─── MIPS N64 ───────────────────────────────────────────────────────

    {
        CallingConventionSpec spec;
        spec.name = "mips_n64";
        spec.arch = HELIX_ARCH_MIPS64;

        spec.int_arg_regs = {
            "$a0", "$a1", "$a2", "$a3",
            "$a4", "$a5", "$a6", "$a7"
        };
        spec.float_arg_regs = {
            "$f12", "$f13", "$f14", "$f15",
            "$f16", "$f17", "$f18", "$f19"
        };

        spec.int_return_regs   = {"$v0", "$v1"};
        spec.float_return_regs = {"$f0", "$f2"};

        spec.callee_saved_regs = {
            "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
            "$fp", "$ra"
        };
        spec.volatile_regs = {
            "$v0", "$v1",
            "$a0", "$a1", "$a2", "$a3", "$a4", "$a5", "$a6", "$a7",
            "$t0", "$t1", "$t2", "$t3",
            "$t8", "$t9",
            "$at"
        };

        spec.stack_alignment = 16;
        spec.shadow_space    = 0;
        spec.red_zone        = 0;
        spec.args_right_to_left = true;

        spec.struct_return_threshold = 16;
        spec.struct_return_reg       = "$v0";

        spec.has_varargs_support   = true;
        spec.varargs_indicator_reg = "";

        size_t idx = specs_.size();
        specs_.push_back(std::move(spec));
        name_map_["mips_n64"] = idx;
        default_map_[HELIX_ARCH_MIPS64] = idx;
    }

    // ─── RISC-V LP64 (RV64) ─────────────────────────────────────────────

    {
        CallingConventionSpec spec;
        spec.name = "riscv_lp64";
        spec.arch = HELIX_ARCH_RISCV64;

        spec.int_arg_regs = {
            "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
        };
        spec.float_arg_regs = {
            "fa0", "fa1", "fa2", "fa3", "fa4", "fa5", "fa6", "fa7"
        };

        spec.int_return_regs   = {"a0", "a1"};
        spec.float_return_regs = {"fa0", "fa1"};

        spec.callee_saved_regs = {
            "s0", "s1", "s2", "s3", "s4", "s5", "s6",
            "s7", "s8", "s9", "s10", "s11",
            "ra"  // return address
        };
        spec.volatile_regs = {
            "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7",
            "t0", "t1", "t2", "t3", "t4", "t5", "t6",
            "fa0", "fa1", "fa2", "fa3", "fa4", "fa5", "fa6", "fa7",
            "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7",
            "ft8", "ft9", "ft10", "ft11"
        };

        spec.stack_alignment = 16;
        spec.shadow_space    = 0;
        spec.red_zone        = 0;
        spec.args_right_to_left = false;

        spec.struct_return_threshold = 16;
        spec.struct_return_reg       = "a0";  // Hidden pointer in first arg reg

        spec.has_varargs_support   = true;
        spec.varargs_indicator_reg = "";

        size_t idx = specs_.size();
        specs_.push_back(std::move(spec));
        name_map_["riscv_lp64"] = idx;
        default_map_[HELIX_ARCH_RISCV64] = idx;
    }
}
