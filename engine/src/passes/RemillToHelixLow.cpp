/// @file RemillToHelixLow.cpp
/// @brief MLIR conversion pass: LLVM Dialect → HelixLow Dialect.
///
/// Recognizes Remill IR patterns (State struct GEPs with !remill_register
/// metadata, mangled C++ semantic function calls, __remill_* intrinsics)
/// and converts them to explicit HelixLow dialect operations.
///
/// This pass is the bridge between LLVM's generic IR representation and
/// Helix's decompiler-specific IR.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/analysis/RemillDemangler.h"
#include "helix/analysis/SignatureDb.h"
#include "helix/analysis/X86RegisterInfo.h"

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"

#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/ScopeExit.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/SmallVector.h"

#include <array>
#include <format>
#include <string>
#include <string_view>

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// Helper: Register Tracking
// ═══════════════════════════════════════════════════════════════════════════════

namespace {

// ─── Wave 22 Step 2 — variadic call detection (printk-family with zeroed fmt) ──
//
// callee name → format-string operand index in the post-`collectCallArgs` ABI
// arg list. A literal 0 at that index means the format string was zeroed
// upstream (Pathfinder/Remill before Helix); the call lifts as
// `helix_low.variadic_call` + `bundle.create<Zeroed>`.
struct VariadicCalleeEntry {
    llvm::StringRef name;
    unsigned fmtSlot;
};

static constexpr VariadicCalleeEntry kVariadicCallees[] = {
    {"printk", 0}, {"pr_err", 0}, {"pr_warn", 0}, {"pr_info", 0},
    {"pr_debug", 0}, {"pr_notice", 0}, {"pr_cont", 0},
    {"_dev_err", 1}, {"_dev_warn", 1}, {"_dev_info", 1},
    {"_dev_dbg", 1}, {"_dev_notice", 1},
    {"__dynamic_dev_err", 2}, {"__dynamic_dev_warn", 2},
    {"__dynamic_dev_info", 2}, {"__dynamic_dev_dbg", 2},
    {"__dynamic_dev_notice", 2},
    {"sprintf", 1}, {"vsprintf", 1}, {"seq_printf", 1}, {"kasprintf", 1},
    {"fprintf", 1}, {"dprintf", 1}, {"sysfs_emit", 1},
    {"snprintf", 2}, {"vsnprintf", 2},
    {"panic", 0}, {"kprintf", 0},
};

static std::optional<unsigned> getVariadicFmtSlot(llvm::StringRef name) {
    for (auto& e : kVariadicCallees)
        if (name == e.name) return e.fmtSlot;
    return std::nullopt;
}

static bool isLiteralZero(Value v) {
    if (!v) return false;
    if (auto c = v.getDefiningOp<LLVM::ConstantOp>())
        if (auto ia = dyn_cast<IntegerAttr>(c.getValue()))
            return ia.getValue().isZero();
    if (auto c = v.getDefiningOp<arith::ConstantOp>())
        if (auto ia = dyn_cast<IntegerAttr>(c.getValue()))
            return ia.getValue().isZero();
    return false;
}

/// Tracks which MLIR Values correspond to register GEP pointers.
/// Built during the initial scan of the LLVM Dialect module by recognizing
/// getelementptr operations that carry !remill_register metadata.
struct RegisterTracker {
    /// Maps SSA values (GEP results) to their register name.
    llvm::DenseMap<Value, std::string> gep_to_reg;

    /// Maps register names to their bit width (derived from access patterns).
    llvm::StringMap<unsigned> reg_widths;

    /// x86-64 GPR struct index-to-register mapping.
    /// Remill State → X86State → GPR field at struct index 6.
    /// The GPR struct alternates: padding (i64) + Reg.
    /// Field indices: 1=RAX, 3=RBX, 5=RCX, 7=RDX, 9=RSI, 11=RDI,
    ///   13=RSP, 15=RBP, 17=R8, 19=R9, 21=R10, 23=R11,
    ///   25=R12, 27=R13, 29=R14, 31=R15, 33=RIP
    static constexpr std::pair<int, const char*> kGprIndexMap[] = {
        {1, "RAX"}, {3, "RBX"}, {5, "RCX"}, {7, "RDX"},
        {9, "RSI"}, {11, "RDI"}, {13, "RSP"}, {15, "RBP"},
        {17, "R8"}, {19, "R9"}, {21, "R10"}, {23, "R11"},
        {25, "R12"}, {27, "R13"}, {29, "R14"}, {31, "R15"},
        {33, "RIP"},
    };

    /// x86-64 XMM/Vector register index mapping.
    /// Remill State → X86State → VectorReg array at struct index 1.
    /// [32 x %union.VectorReg] — index 0-15 = XMM0-XMM15
    static constexpr std::pair<int, const char*> kXmmIndexMap[] = {
        {0, "XMM0"}, {1, "XMM1"}, {2, "XMM2"}, {3, "XMM3"},
        {4, "XMM4"}, {5, "XMM5"}, {6, "XMM6"}, {7, "XMM7"},
        {8, "XMM8"}, {9, "XMM9"}, {10, "XMM10"}, {11, "XMM11"},
        {12, "XMM12"}, {13, "XMM13"}, {14, "XMM14"}, {15, "XMM15"},
    };

    /// x86-64 ArithFlags field mapping.
    /// Remill State → X86State → ArithFlags at struct index 2.
    /// %struct.ArithFlags = type { i8 x 16 }
    /// Fields: CF, PF, AF, ZF, SF, DF, OF, ... (flag order per Remill)
    static constexpr std::pair<int, const char*> kFlagIndexMap[] = {
        {0, "CF"}, {1, "PF"}, {2, "AF"}, {3, "ZF"},
        {4, "SF"}, {5, "DF"}, {6, "OF"},
    };

    /// Strip pointer-preserving wrappers so bookkeeping allocas are still
    /// recognized after import adds bitcasts or no-op GEPs.
    static Value stripPointerAliases(Value val) {
        while (val) {
            if (auto bitcast = val.getDefiningOp<LLVM::BitcastOp>()) {
                val = bitcast.getArg();
                continue;
            }
            if (auto cast = val.getDefiningOp<LLVM::AddrSpaceCastOp>()) {
                val = cast.getArg();
                continue;
            }
            if (auto gep = val.getDefiningOp<LLVM::GEPOp>()) {
                if (auto constIndices = extractConstantGEPIndices(gep)) {
                    bool allZero = llvm::all_of(*constIndices, [](int idx) {
                        return idx == 0;
                    });
                    if (allZero) {
                        val = gep.getBase();
                        continue;
                    }
                }
            }
            break;
        }
        return val;
    }

    /// Scan a function body and build the register map.
    void scan(LLVM::LLVMFuncOp func) {
        func.walk([&](LLVM::GEPOp gep) {
            // Strategy 1: Check for !remill_register metadata as an MLIR attribute.
            if (auto regAttr = gep->getAttrOfType<StringAttr>("remill_register")) {
                std::string name = regAttr.getValue().str();
                gep_to_reg[gep.getResult()] = name;
                reg_widths[name] = inferRegWidth(name);
                return;
            }

            // Strategy 2: Check llvm.metadata dictionary for the register name.
            if (auto metaDict = gep->getAttrOfType<DictionaryAttr>("llvm.metadata")) {
                if (auto regAttr = metaDict.getAs<StringAttr>("remill_register")) {
                    std::string name = regAttr.getValue().str();
                    gep_to_reg[gep.getResult()] = name;
                    reg_widths[name] = inferRegWidth(name);
                    return;
                }
            }

            // Strategy 3: Structural analysis of GEP indices into the State struct.
            // Remill State layout (X86State):
            //   [0] ArchState (16 bytes)
            //   [1] VectorReg[32] — XMM/YMM/ZMM registers
            //   [2] ArithFlags — CF, PF, AF, ZF, SF, DF, OF
            //   [6] GPR — RAX, RBX, RCX, RDX, RSI, RDI, RSP, RBP, R8-R15, RIP
            auto indices = gep.getIndices();
            if (indices.size() >= 4) {
                if (auto constIndices = extractConstantGEPIndices(gep)) {
                    if (constIndices->size() >= 4 &&
                        (*constIndices)[0] == 0 &&
                        (*constIndices)[1] == 0) {

                        int structField = (*constIndices)[2];
                        int subIdx = (*constIndices)[3];

                        // GPR: gep %state, 0, 0, 6, <gpr_field_index>, ...
                        if (structField == 6) {
                            for (auto [idx, name] : kGprIndexMap) {
                                if (idx == subIdx) {
                                    gep_to_reg[gep.getResult()] = name;
                                    reg_widths[name] = inferRegWidth(name);
                                    return;
                                }
                            }
                        }

                        // XMM: gep %state, 0, 0, 1, <xmm_index>, ...
                        // VectorReg array at index 1, element index = XMM number
                        if (structField == 1) {
                            for (auto [idx, name] : kXmmIndexMap) {
                                if (idx == subIdx) {
                                    gep_to_reg[gep.getResult()] = name;
                                    reg_widths[name] = 128; // XMM = 128-bit
                                    return;
                                }
                            }
                        }

                        // ArithFlags: gep %state, 0, 0, 2, <flag_index>
                        if (structField == 2) {
                            for (auto [idx, name] : kFlagIndexMap) {
                                if (idx == subIdx) {
                                    gep_to_reg[gep.getResult()] = name;
                                    reg_widths[name] = 8; // flags are i8
                                    return;
                                }
                            }
                        }

                        // AddressSpace: gep %state, 0, 0, 5, <seg_idx>, ...
                        // Remill X86 AddressSpace layout (in order):
                        //   [0] SS_BASE  [1] ES_BASE  [2] CS_BASE
                        //   [3] DS_BASE  [4] FS_BASE  [5] GS_BASE
                        // MLIR's LLVM importer drops the !remill_register
                        // metadata, so we have to identify these GEPs
                        // structurally.  Without this, GS:[0x60]/FS:[0x30]
                        // accesses collapse to `0->field_0xN` in the C output.
                        if (structField == 5) {
                            const char* segName = nullptr;
                            switch (subIdx) {
                                case 0: segName = "SSBASE"; break;
                                case 1: segName = "ESBASE"; break;
                                case 2: segName = "CSBASE"; break;
                                case 3: segName = "DSBASE"; break;
                                case 4: segName = "FSBASE"; break;
                                case 5: segName = "GSBASE"; break;
                                default: break;
                            }
                            if (segName) {
                                gep_to_reg[gep.getResult()] = segName;
                                reg_widths[segName] = 64;
                                return;
                            }
                        }
                    }
                }
            }

            // Strategy 3b: Handle shorter GEP chains (3 indices).
            // Some GEPs only index into the top-level struct field:
            //   gep %state, 0, 0, 1  — pointer to entire VectorReg array
            //   gep %state, 0, 0, 2  — pointer to ArithFlags struct
            //   gep %state, 0, 0, 6  — pointer to GPR struct
            if (indices.size() >= 3) {
                if (auto constIndices = extractConstantGEPIndices(gep)) {
                    if (constIndices->size() == 3 &&
                        (*constIndices)[0] == 0 &&
                        (*constIndices)[1] == 0) {
                        int structField = (*constIndices)[2];
                        // Mark the base array/struct pointer so downstream
                        // GEPs that index further can be resolved.
                        if (structField == 1) {
                            gep_to_reg[gep.getResult()] = "__VEC_BASE";
                            return;
                        }
                        if (structField == 2) {
                            gep_to_reg[gep.getResult()] = "__FLAGS_BASE";
                            return;
                        }
                        if (structField == 6) {
                            gep_to_reg[gep.getResult()] = "__GPR_BASE";
                            return;
                        }
                    }
                }
            }
        });

        // Second pass: resolve chained GEPs where the base is a known
        // __VEC_BASE, __FLAGS_BASE, or __GPR_BASE.
        // Pattern: gep <base_ptr>, <element_index>, ...
        //   where base_ptr was tagged as __VEC_BASE → XMM<element_index>
        func.walk([&](LLVM::GEPOp gep) {
            // Skip if already resolved
            if (gep_to_reg.count(gep.getResult()))
                return;

            // Check if base is a known base pointer
            Value base = stripPointerAliases(gep.getBase());
            auto baseIt = gep_to_reg.find(base);
            if (baseIt == gep_to_reg.end())
                return;

            auto constIndices = extractConstantGEPIndices(gep);
            if (!constIndices || constIndices->empty())
                return;

            const std::string& baseName = baseIt->second;

            if (baseName == "__VEC_BASE") {
                // gep __VEC_BASE, <xmm_index>, ... → XMM<N>
                int xmmIdx = (*constIndices)[0];
                for (auto [idx, name] : kXmmIndexMap) {
                    if (idx == xmmIdx) {
                        gep_to_reg[gep.getResult()] = name;
                        reg_widths[name] = 128;
                        return;
                    }
                }
                // Out of range but still vector — name generically
                if (xmmIdx >= 0 && xmmIdx < 32) {
                    std::string regName = "YMM" + std::to_string(xmmIdx);
                    gep_to_reg[gep.getResult()] = regName;
                    reg_widths[regName] = 256;
                }
            } else if (baseName == "__FLAGS_BASE") {
                // gep __FLAGS_BASE, <flag_index> → CF/PF/AF/ZF/SF/DF/OF
                int flagIdx = (*constIndices)[0];
                for (auto [idx, name] : kFlagIndexMap) {
                    if (idx == flagIdx) {
                        gep_to_reg[gep.getResult()] = name;
                        reg_widths[name] = 8;
                        return;
                    }
                }
            } else if (baseName == "__GPR_BASE") {
                // gep __GPR_BASE, <gpr_field_index>, ... → RAX/RBX/...
                int gprIdx = (*constIndices)[0];
                for (auto [idx, name] : kGprIndexMap) {
                    if (idx == gprIdx) {
                        gep_to_reg[gep.getResult()] = name;
                        reg_widths[name] = inferRegWidth(name);
                        return;
                    }
                }
            }

            // Also handle sub-GEPs within a known XMM register.
            // gep <XMM0_ptr>, 0, 0, 0, 0  → still XMM0
            // gep <XMM0_ptr>, 0, 0, 0, <lane> → XMM0 (lane access)
            if (baseName.starts_with("XMM") || baseName.starts_with("YMM")) {
                gep_to_reg[gep.getResult()] = baseName;
                reg_widths[baseName] = reg_widths.count(baseName)
                    ? reg_widths[baseName] : 128;
            }
        });

        // Also track alloca-based bookkeeping values (NEXT_PC, RETURN_PC,
        // BRANCH_TAKEN) by their fixed operand position in Remill semantics.
        func.walk([&](LLVM::CallOp call) {
            auto callee = call.getCallee();
            if (!callee)
                return;

            auto semInfo = helix::demangleRemillSemantic(*callee);
            if (!semInfo)
                return;

            auto bindBookkeepingPtr = [&](Value ptr, llvm::StringRef name) {
                ptr = stripPointerAliases(ptr);
                if (!ptr.getDefiningOp<LLVM::AllocaOp>())
                    return;
                gep_to_reg.try_emplace(ptr, name.str());
                reg_widths[name] = inferRegWidth(name);
            };

            switch (semInfo->semantic) {
            case RemillSemantic::CALL:
                if (call.getNumOperands() > 3)
                    bindBookkeepingPtr(call.getOperand(3), "NEXT_PC");
                if (call.getNumOperands() > 5)
                    bindBookkeepingPtr(call.getOperand(5), "RETURN_PC");
                break;
            case RemillSemantic::JMP:
                if (call.getNumOperands() > 3)
                    bindBookkeepingPtr(call.getOperand(3), "NEXT_PC");
                break;
            case RemillSemantic::RET:
                if (call.getNumOperands() > 2)
                    bindBookkeepingPtr(call.getOperand(2), "RETURN_PC");
                break;
            default:
                if (!helix::isConditionalJump(semInfo->semantic))
                    return;
                if (call.getNumOperands() > 2)
                    bindBookkeepingPtr(call.getOperand(2), "BRANCH_TAKEN");
                if (call.getNumOperands() > 5)
                    bindBookkeepingPtr(call.getOperand(5), "NEXT_PC");
                break;
            }
        });

        // Recover the plain PC alloca structurally. Unlike NEXT_PC and
        // RETURN_PC, Remill does not pass %PC directly to semantic helpers,
        // so we infer it from the classic pattern:
        //   %pc = load i64, ptr %PC
        //   %next = add i64 %pc, <instr_size>
        //   store i64 %next, ptr %NEXT_PC
        func.walk([&](LLVM::AllocaOp alloca) {
            if (gep_to_reg.count(alloca.getResult()))
                return;

            bool looksLikePc = false;
            for (Operation* user : alloca->getUsers()) {
                auto load = dyn_cast<LLVM::LoadOp>(user);
                if (!load)
                    continue;

                for (Operation* loadUser : load.getResult().getUsers()) {
                    auto add = dyn_cast<LLVM::AddOp>(loadUser);
                    auto sub = dyn_cast<LLVM::SubOp>(loadUser);
                    Value candidate;
                    if (add)
                        candidate = add.getResult();
                    else if (sub)
                        candidate = sub.getResult();
                    else
                        continue;

                    for (Operation* arithUser : candidate.getUsers()) {
                        auto store = dyn_cast<LLVM::StoreOp>(arithUser);
                        if (!store)
                            continue;
                        auto dst = getRegName(store.getAddr());
                        if (dst && *dst == "NEXT_PC") {
                            looksLikePc = true;
                            break;
                        }
                    }

                    if (looksLikePc)
                        break;
                }

                if (looksLikePc)
                    break;
            }

            if (!looksLikePc) {
                // ── Fallback heuristic for constant-store Remill IR ─────
                // When Remill uses direct constant stores instead of the
                // load→add→store pattern, the alloca that receives constant
                // stores paired with NEXT_PC constant stores is the PC.
                //
                // Pattern: for some instruction at address A with size S,
                //   store i64 A,   ptr %PC
                //   store i64 A+S, ptr %NEXT_PC
                //
                // We check: does this alloca receive constant stores whose
                // values are each (NEXT_PC_const - small_delta) for a
                // corresponding NEXT_PC store in the same block?
                llvm::SmallVector<int64_t, 8> pcCandidates;
                llvm::SmallVector<int64_t, 8> nextPcValues;

                // Collect constant stores to this alloca.
                for (Operation* user : alloca->getUsers()) {
                    auto store = dyn_cast<LLVM::StoreOp>(user);
                    if (!store || store.getAddr() != alloca.getResult())
                        continue;
                    if (auto constOp = store.getValue().getDefiningOp<LLVM::ConstantOp>()) {
                        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                            pcCandidates.push_back(intAttr.getValue().getSExtValue());
                    }
                }

                if (pcCandidates.size() >= 2) {
                    // Collect constant stores to the NEXT_PC alloca.
                    Value nextPcPtr;
                    for (auto& [ptr, name] : gep_to_reg) {
                        if (name == "NEXT_PC") {
                            nextPcPtr = ptr;
                            break;
                        }
                    }
                    if (nextPcPtr) {
                        for (Operation* user : nextPcPtr.getDefiningOp()->getUsers()) {
                            auto store = dyn_cast<LLVM::StoreOp>(user);
                            if (!store || store.getAddr() != nextPcPtr)
                                continue;
                            if (auto constOp = store.getValue().getDefiningOp<LLVM::ConstantOp>()) {
                                if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                                    nextPcValues.push_back(intAttr.getValue().getSExtValue());
                            }
                        }
                    }

                    // Check correlation: for each PC candidate, is there
                    // a NEXT_PC value that's PC + [1..15]?
                    unsigned matches = 0;
                    for (auto pc : pcCandidates) {
                        for (auto npc : nextPcValues) {
                            auto delta = npc - pc;
                            if (delta >= 1 && delta <= 15) {
                                matches++;
                                break;
                            }
                        }
                    }

                    // If at least 2 PC values correlate with NEXT_PC, this is PC.
                    if (matches >= 2)
                        looksLikePc = true;
                }
            }

            if (!looksLikePc)
                return;

            gep_to_reg.try_emplace(alloca.getResult(), "PC");
            reg_widths["PC"] = inferRegWidth("PC");
        });
    }

    /// Try to extract constant integer indices from a GEP operation.
    static std::optional<SmallVector<int, 6>>
    extractConstantGEPIndices(LLVM::GEPOp gep) {
        SmallVector<int, 6> result;
        for (auto idx : gep.getIndices()) {
            // In MLIR LLVM dialect, GEP indices can be either constant attributes
            // or SSA values. We only handle constant attributes here.
            if (auto intAttr = dyn_cast<IntegerAttr>(idx)) {
                result.push_back(static_cast<int>(intAttr.getInt()));
            } else if (auto val = dyn_cast<Value>(idx)) {
                // Try to resolve through a constant op
                if (auto constOp = val.getDefiningOp<LLVM::ConstantOp>()) {
                    if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                        result.push_back(static_cast<int>(intAttr.getInt()));
                        continue;
                    }
                }
                return std::nullopt;  // Non-constant index
            }
        }
        return result;
    }

    /// Infer register bit width from its name.
    static unsigned inferRegWidth(llvm::StringRef name) {
        // XMM: 128-bit
        if (name.starts_with("XMM"))
            return 128;
        // YMM: 256-bit
        if (name.starts_with("YMM"))
            return 256;
        // ZMM: 512-bit
        if (name.starts_with("ZMM"))
            return 512;
        // 64-bit: RAX, RBX, RCX, RDX, RSI, RDI, RSP, RBP, R8-R15, RIP
        if (name.starts_with("R") || name == "RIP")
            return 64;
        // 32-bit: EAX, EBX, etc.
        if (name.starts_with("E"))
            return 32;
        // 16-bit: AX, BX, CX, DX, SI, DI, SP, BP
        if (name.size() == 2 && (name.ends_with("X") || name.ends_with("I") ||
                                  name.ends_with("P")))
            return 16;
        // 8-bit: AL, AH, BL, BH, CL, CH, DL, DH, flags
        if (name.size() == 2 && (name.ends_with("L") || name.ends_with("H")))
            return 8;
        // Flags: 8-bit each
        if (name == "CF" || name == "PF" || name == "AF" ||
            name == "ZF" || name == "SF" || name == "DF" || name == "OF")
            return 8;
        // Special: flags, segments, PC
        if (name == "PC" || name == "NEXT_PC")
            return 64;
        // Default to 64-bit for unknown registers
        return 64;
    }

    /// Check if a value is a known register GEP pointer.
    bool isRegisterPtr(Value val) const {
        return gep_to_reg.count(val) > 0;
    }

    /// Check if a named register has been identified.
    bool isRegisterPtr(llvm::StringRef regName) const {
        for (auto& [val, name] : gep_to_reg)
            if (name == regName)
                return true;
        return false;
    }

    /// Explicitly register an alloca as the PC register.
    /// Used when the heuristic scan fails but we can identify
    /// the PC alloca by other means (e.g., it stores the entry address).
    void registerPcAlloca(Value allocaResult) {
        gep_to_reg.try_emplace(allocaResult, "PC");
        reg_widths["PC"] = 64;
    }

    static std::optional<std::string> extractRegisterNameFromValue(Value val) {
        val = stripPointerAliases(val);
        auto gep = val.getDefiningOp<LLVM::GEPOp>();
        if (!gep)
            return std::nullopt;

        if (auto regAttr = gep->getAttrOfType<StringAttr>("remill_register"))
            return regAttr.getValue().str();

        if (auto metaDict = gep->getAttrOfType<DictionaryAttr>("llvm.metadata")) {
            if (auto regAttr = metaDict.getAs<StringAttr>("remill_register"))
                return regAttr.getValue().str();
        }

        if (auto constIndices = extractConstantGEPIndices(gep)) {
            if (constIndices->size() >= 4 &&
                (*constIndices)[0] == 0 &&
                (*constIndices)[1] == 0 &&
                (*constIndices)[2] == 6) {
                int gprIdx = (*constIndices)[3];
                for (auto [idx, name] : kGprIndexMap) {
                    if (idx == gprIdx)
                        return std::string(name);
                }
            }
        }

        return std::nullopt;
    }

    static std::optional<std::string> extractBookkeepingNameFromAlloca(Value val) {
        val = stripPointerAliases(val);
        auto alloca = val.getDefiningOp<LLVM::AllocaOp>();
        if (!alloca)
            return std::nullopt;

        std::optional<std::string> candidate;
        auto observe = [&](llvm::StringRef name) {
            if (!candidate) {
                candidate = name.str();
                return;
            }
            if (*candidate != name)
                candidate = std::nullopt;
        };

        for (Operation* user : alloca->getUsers()) {
            auto call = dyn_cast<LLVM::CallOp>(user);
            if (!call)
                continue;

            auto callee = call.getCallee();
            if (!callee)
                continue;

            auto semInfo = helix::demangleRemillSemantic(*callee);
            if (!semInfo)
                continue;

            auto markIfOperand = [&](unsigned idx, llvm::StringRef name) {
                if (call.getNumOperands() > idx && call.getOperand(idx) == val)
                    observe(name);
            };

            switch (semInfo->semantic) {
            case RemillSemantic::CALL:
                markIfOperand(3, "NEXT_PC");
                markIfOperand(5, "RETURN_PC");
                break;
            case RemillSemantic::JMP:
                markIfOperand(3, "NEXT_PC");
                break;
            case RemillSemantic::RET:
                markIfOperand(2, "RETURN_PC");
                break;
            default:
                if (!helix::isConditionalJump(semInfo->semantic))
                    break;
                markIfOperand(2, "BRANCH_TAKEN");
                markIfOperand(5, "NEXT_PC");
                break;
            }
        }

        return candidate;
    }

    /// Get the register name for a GEP result, if known.
    std::optional<std::string> getRegName(Value val) const {
        val = stripPointerAliases(val);
        auto it = gep_to_reg.find(val);
        if (it != gep_to_reg.end())
            return it->second;
        if (auto direct = extractRegisterNameFromValue(val))
            return direct;
        return extractBookkeepingNameFromAlloca(val);
    }
};

/// Tracks PC values during conversion to set address attributes on ops.
struct PCTracker {
    /// Current PC value (if known).
    uint64_t current_pc = 0;
    /// Whether we have a valid PC.
    bool has_pc = false;
    /// Last known concrete values for bookkeeping slots such as PC/NEXT_PC.
    llvm::StringMap<int64_t> trackedValues;

    /// Cache of evaluated SSA Values within the current block.
    /// Prevents re-evaluation from seeing mutated trackedValues,
    /// which violates SSA semantics (a Value's meaning is fixed at its def).
    mutable llvm::DenseMap<Value, int64_t> evalCache;

    /// Clear the eval cache at block boundaries.
    void clearEvalCache() { evalCache.clear(); }

    std::optional<int64_t> tryEvaluate(Value value,
                                       const RegisterTracker& regs) const {
        llvm::SmallPtrSet<Operation*, 16> visiting;
        return tryEvaluate(value, regs, visiting);
    }

    /// Try to extract a PC value from a store to NEXT_PC.
    void trackStore(LLVM::StoreOp store, const RegisterTracker& regs) {
        // Pattern: store i64 %val, ptr %NEXT_PC
        // The stored value is often: add i64 %prev_pc, <instr_size>
        auto destReg = regs.getRegName(store.getAddr());
        if (!destReg)
            return;

        auto evaluated = tryEvaluate(store.getValue(), regs);
        if (evaluated) {
            trackedValues[*destReg] = *evaluated;
        } else {
            trackedValues.erase(*destReg);
        }

        if (!evaluated)
            return;

        if (*destReg == "PC") {
            current_pc = static_cast<uint64_t>(*evaluated);
            has_pc = true;
            return;
        }

        // NEXT_PC is tracked in trackedValues for RIP-relative resolution
        // but must NOT overwrite current_pc — otherwise operations following
        // a `store NEXT_PC` get the wrong instruction address (the return
        // address of a CALL, not the CALL's own address).  The RIP-relative
        // helpers use trackedValues["NEXT_PC"] directly.
        // (no current_pc update for NEXT_PC)
    }

    /// Get an optional address attribute for the current PC.
    std::optional<uint64_t> getAddress() const {
        return has_pc ? std::optional(current_pc) : std::nullopt;
    }

private:
    std::optional<int64_t> tryEvaluate(
        Value value, const RegisterTracker& regs,
        llvm::SmallPtrSetImpl<Operation*>& visiting) const {
        if (!value)
            return std::nullopt;

        // Check the per-block evaluation cache first.
        // This ensures SSA Values are evaluated consistently — once a
        // Value is evaluated, the result is reused even if trackedValues
        // has changed (e.g., NEXT_PC was updated between two uses of
        // the same SSA value).
        if (auto cached = evalCache.find(value); cached != evalCache.end())
            return cached->second;

        auto result = tryEvaluateUncached(value, regs, visiting);
        if (result)
            evalCache[value] = *result;
        return result;
    }

    /// Core evaluation logic (without cache check).
    std::optional<int64_t> tryEvaluateUncached(
        Value value, const RegisterTracker& regs,
        llvm::SmallPtrSetImpl<Operation*>& visiting) const {

        auto* defOp = value.getDefiningOp();
        if (!defOp)
            return std::nullopt;

        if (!visiting.insert(defOp).second)
            return std::nullopt;

        auto eraseOnReturn = llvm::make_scope_exit([&] { visiting.erase(defOp); });

        if (auto constOp = dyn_cast<LLVM::ConstantOp>(defOp)) {
            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                return intAttr.getValue().getSExtValue();
        }

        if (auto constOp = dyn_cast<arith::ConstantOp>(defOp)) {
            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                return intAttr.getValue().getSExtValue();
        }

        if (auto intAttr = defOp->getAttrOfType<IntegerAttr>("value"))
            return intAttr.getValue().getSExtValue();

        if (auto load = dyn_cast<LLVM::LoadOp>(defOp)) {
            auto srcReg = regs.getRegName(load.getAddr());
            if (srcReg) {
                if (auto it = trackedValues.find(*srcReg);
                    it != trackedValues.end()) {
                    return it->second;
                }
                if (*srcReg == "PC" && has_pc)
                    return static_cast<int64_t>(current_pc);
            }
            return std::nullopt;
        }

        if (auto add = dyn_cast<LLVM::AddOp>(defOp)) {
            auto lhs = tryEvaluate(add.getLhs(), regs, visiting);
            auto rhs = tryEvaluate(add.getRhs(), regs, visiting);
            if (lhs && rhs)
                return *lhs + *rhs;
            return std::nullopt;
        }

        if (auto sub = dyn_cast<LLVM::SubOp>(defOp)) {
            auto lhs = tryEvaluate(sub.getLhs(), regs, visiting);
            auto rhs = tryEvaluate(sub.getRhs(), regs, visiting);
            if (lhs && rhs)
                return *lhs - *rhs;
            return std::nullopt;
        }

        if (auto zext = dyn_cast<LLVM::ZExtOp>(defOp))
            return tryEvaluate(zext.getArg(), regs, visiting);

        if (auto sext = dyn_cast<LLVM::SExtOp>(defOp))
            return tryEvaluate(sext.getArg(), regs, visiting);

        if (auto trunc = dyn_cast<LLVM::TruncOp>(defOp))
            return tryEvaluate(trunc.getArg(), regs, visiting);

        if (auto ptrToInt = dyn_cast<LLVM::PtrToIntOp>(defOp))
            return tryEvaluate(ptrToInt.getArg(), regs, visiting);

        if (auto intToPtr = dyn_cast<LLVM::IntToPtrOp>(defOp))
            return tryEvaluate(intToPtr.getArg(), regs, visiting);

        return std::nullopt;
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// Conversion Pass
// ═══════════════════════════════════════════════════════════════════════════════

/// The Remill-to-HelixLow conversion pass.
///
/// Processes each LLVM function in the module:
/// 1. Scans for register GEPs to build the register map
/// 2. Walks operations in order, converting recognized patterns to HelixLow ops
/// 3. Wraps the converted ops in a helix_low.func operation
/// 4. Removes the original LLVM function
struct RemillToHelixLowPass
    : public PassWrapper<RemillToHelixLowPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RemillToHelixLowPass)

    StringRef getArgument() const final { return "remill-to-helix-low"; }
    StringRef getDescription() const final {
        return "Convert LLVM Dialect (Remill IR) to HelixLow Dialect";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<LLVM::LLVMDialect>();
        registry.insert<helix::low::HelixLowDialect>();
        registry.insert<helix::high::HelixHighDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();

        // Process each LLVM function that looks like a Remill lifted function.
        // Remill functions have the signature:
        //   define ptr @lifted_<addr>(ptr %state, i64 %program_counter, ptr %memory)
        SmallVector<LLVM::LLVMFuncOp> funcsToConvert;

        module.walk([&](LLVM::LLVMFuncOp func) {
            auto name = func.getName();
            // Skip declarations (no body).
            if (func.isExternal())
                return;
            // Skip Remill internal helpers (e.g., __remill_*).
            if (name.starts_with("__remill_") ||
                name.starts_with("__hxreloc__") ||
                name.starts_with("llvm."))
                return;
            // Remill lifted functions are recognized by either:
            //   1. Name prefix "lifted_<decimal>" or "sub_<hex>"
            //   2. Symbolic name (e.g., "kbase_jit_allocate") with the
            //      Remill calling convention: 3 args (state, pc, memory).
            //      HexCore now emits the original symtab name when known.
            if (name.starts_with("lifted_") || name.starts_with("sub_")) {
                funcsToConvert.push_back(func);
                return;
            }
            // Symbolic name path: check the Remill argument shape.
            auto funcType = func.getFunctionType();
            if (funcType.getNumParams() == 3) {
                funcsToConvert.push_back(func);
            }
        });

        for (auto func : funcsToConvert) {
            if (failed(convertFunction(func))) {
                signalPassFailure();
                return;
            }
        }

        // After all functions are converted, resolve CALL target addresses
        // to function names using the module's own function table and the
        // signature database.
        helix::resolveCallTargets(module);

        // [P0-DEBUG] Count surviving CallOps after full conversion + resolution
        {
            unsigned lowCallCount = 0;
            module.walk([&](helix::low::CallOp) { ++lowCallCount; });
            llvm::errs() << "[P0-DEBUG] After RemillToHelixLow + resolveCallTargets: "
                         << lowCallCount << " helix_low.call ops survive\n";
        }
    }

private:
    /// Conversion coverage metrics — logged at the end of each function.
    struct LiftStats {
        unsigned totalCalls = 0;
        unsigned converted = 0;     // successfully dispatched to convertSemantic
        unsigned memoryOps = 0;     // __remill_read/write_memory → MemRead/MemWrite
        unsigned helpers = 0;       // __remill_* / llvm.* / is_helper → erased
        unsigned externalCalls = 0; // unrecognized mangled → generic CallOp
        unsigned indirectCalls = 0; // function pointer calls
    };
    LiftStats liftStats;

    /// Machine-word width for the current function being converted: 32 for
    /// x86 (i386 PE / i686 ELF), 64 for x86-64.  Set in `convertFunction`
    /// from the `program_counter` argument width *before* the block args are
    /// erased, then consulted at every `helix_low.call` creation site so the
    /// synthetic result / RAX RegWrite matches the native pointer/return
    /// register width.  Without this, x86 calls ended up with i64 result
    /// types and downstream emitters sign-extended 32-bit call targets into
    /// bogus `sub_ffffffffc75c4ad9` names (bug H of the gta-sa stress set).
    unsigned machineIntWidth_ = 64;

    /// Convenience accessor for the current-function machine integer type.
    mlir::IntegerType machineIntTy(mlir::OpBuilder& b) const {
        return b.getIntegerType(machineIntWidth_);
    }

    /// Convert a single Remill lifted function to HelixLow.
    LogicalResult convertFunction(LLVM::LLVMFuncOp llvmFunc) {
        liftStats = LiftStats{}; // reset per-function
        OpBuilder builder(llvmFunc->getContext());
        builder.setInsertionPointAfter(llvmFunc);

        // Extract entry address from function name.
        uint64_t entryAddr = 0;
        auto name = llvmFunc.getName();
        if (name.starts_with("lifted_")) {
            auto addrStr = name.drop_front(7);
            llvm::StringRef(addrStr).getAsInteger(10, entryAddr);
        } else if (name.starts_with("sub_")) {
            auto addrStr = name.drop_front(4);
            llvm::StringRef(addrStr).getAsInteger(16, entryAddr);
        }

        // Build register tracker.
        RegisterTracker regs;
        regs.scan(llvmFunc);

        // ── Post-scan: Ensure the PC alloca was identified ──────────────
        // Some Remill IR uses direct constant stores (store i64 ADDR, ptr %PC)
        // instead of the load→add→store pattern that the primary heuristic
        // expects.  If PC was NOT found, brute-force search all allocas by
        // correlating their constant stores with the known entry address.
        if (!regs.isRegisterPtr("PC") && entryAddr != 0) {
            llvmFunc.walk([&](LLVM::AllocaOp alloca) {
                if (regs.isRegisterPtr(alloca.getResult()))
                    return;

                // Check if this alloca receives a store of the entry address.
                bool storesEntryAddr = false;
                for (auto* user : alloca.getResult().getUsers()) {
                    auto store = dyn_cast<LLVM::StoreOp>(user);
                    if (!store || store.getAddr() != alloca.getResult())
                        continue;
                    if (auto constOp =
                            store.getValue().getDefiningOp<LLVM::ConstantOp>()) {
                        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                            if (static_cast<uint64_t>(intAttr.getValue().getZExtValue()) == entryAddr) {
                                storesEntryAddr = true;
                                break;
                            }
                        }
                    }
                }

                if (storesEntryAddr) {
                    regs.registerPcAlloca(alloca.getResult());
                }
            });
        }

        // Create the HelixLow function.
        //
        // Name selection:
        //   - "lifted_<decimal>" → "sub_<hex>" (legacy Remill behavior)
        //   - "sub_<hex>"        → keep as-is (already in canonical form)
        //   - symbolic name      → preserve verbatim (HexCore symtab name,
        //                          e.g. "kbase_jit_allocate", "main")
        std::string funcName;
        auto origName = llvmFunc.getName();
        if (origName.starts_with("lifted_")) {
            funcName = std::format("sub_{:x}", entryAddr);
        } else if (origName.starts_with("sub_")) {
            funcName = origName.str();
        } else {
            // Symbolic name from HexCore symtab — preserve it.
            funcName = origName.str();
        }

        auto helixFunc = builder.create<helix::low::FuncOp>(
            llvmFunc.getLoc(),
            builder.getStringAttr(funcName),
            IntegerAttr::get(
                IntegerType::get(builder.getContext(), 64,
                                 IntegerType::Unsigned),
                entryAddr),
            /*original_name=*/StringAttr{});

        // Steal the body from the LLVM function.
        // This preserves the CFG, blocks, and operations exactly as they were.
        helixFunc.getBody().takeBody(llvmFunc.getBody());

        // ─── Handle Entry Block Arguments ───────────────────────────────
        // Remill functions have the signature:
        //   (ptr %state, i64 %pc, ptr %memory)
        // We need to replace usages of these arguments with:
        //   %state  -> Undef (GEPs are tracked by RegisterTracker)
        //   %pc     -> Constant(entryAddr) (CRITICAL for PC-relative addressing)
        //   %memory -> Undef (Memory intrinsics handle this)
        
        Block& entryBlock = helixFunc.getBody().front();

        // Ensure we have the expected number of arguments (Remill standard is 3).
        // If optimization passes changed signature, we might need to be careful.
        if (entryBlock.getNumArguments() >= 2) {
            auto loc = llvmFunc.getLoc();
            builder.setInsertionPointToStart(&entryBlock);

            // Arg 0: %state
            // Replace with Undef. RegisterTracker already mapped the GEP results
            // derived from this, so we don't need the base pointer anymore.
            auto stateArg = entryBlock.getArgument(0);
            auto undefState = builder.create<LLVM::UndefOp>(loc, stateArg.getType());
            stateArg.replaceAllUsesWith(undefState);

            // Arg 1: %pc — also carries the machine-word width for this
            // function (i32 on x86, i64 on x86-64).  Capture it before the
            // args are erased below so convertOperation can pick the right
            // integer type for synthesized call results / RegWrite widths.
            auto pcArg = entryBlock.getArgument(1);
            if (auto pcIntTy = dyn_cast<IntegerType>(pcArg.getType()))
                machineIntWidth_ = pcIntTy.getWidth();
            else
                machineIntWidth_ = 64;
            auto pcConst = builder.create<LLVM::ConstantOp>(
                loc, pcArg.getType(),
                builder.getI64IntegerAttr(entryAddr));
            pcArg.replaceAllUsesWith(pcConst);

            // Arg 2: %memory (if present)
            if (entryBlock.getNumArguments() >= 3) {
                auto memArg = entryBlock.getArgument(2);
                auto undefMem = builder.create<LLVM::UndefOp>(loc, memArg.getType());
                memArg.replaceAllUsesWith(undefMem);
            }
        }

        // Remove arguments from the entry block signature (HelixLow funcs are void/void).
        // Note: eraseArguments invalidates argument indices, so we erase all.
        llvm::BitVector argsToErase(entryBlock.getNumArguments());
        argsToErase.set(0, entryBlock.getNumArguments());
        entryBlock.eraseArguments(argsToErase);

        // ─── Convert Operations ─────────────────────────────────────────
        
        // Create a dummy block for unresolved branches (semantics that need a target).
        // We add it to the end.
        auto* dummyBlock = new Block();
        helixFunc.getBody().push_back(dummyBlock);
        builder.setInsertionPointToStart(dummyBlock);
        builder.create<helix::low::RetOp>(llvmFunc.getLoc(), IntegerAttr{});

        PCTracker pcTracker;
        Value inferredPcAlloca;   // Fallback: alloca identified as PC by address heuristic
        llvm::SmallVector<Operation*, 16> opsToErase;

        // Walk the function and convert operations in-place.
        // We use a pre-order walk to ensure we handle definitions before uses if needed,
        // but since we are mostly replacing ops, order matters less than validity.
        // However, we must be careful not to invalidate the iterator.
        
        // We collect blocks first to avoid iterator issues if we add blocks (unlikely here).
        SmallVector<Block*> blocks;
        for (auto& block : helixFunc.getBody())
            blocks.push_back(&block);

        for (auto* block : blocks) {
            // A structure to hold a deferred terminator creation.
            std::function<void(OpBuilder&, IntegerAttr)> deferredTerminator = nullptr;

            // Clear the SSA evaluation cache at block boundaries.
            // Within a block, the cache ensures that re-evaluating the same
            // SSA Value returns a consistent result even after trackedValues
            // has been mutated by intervening stores.
            pcTracker.clearEvalCache();

            for (auto it = block->begin(), e = block->end(); it != e; ) {
                Operation* op = &*it;
                it++;

                // Track PC updates.
                if (auto store = dyn_cast<LLVM::StoreOp>(op)) {
                    pcTracker.trackStore(store, regs);

                    // ── Robust PC fallback ───────────────────────────
                    // If the RegisterTracker didn't identify the PC alloca,
                    // detect PC stores by checking for constants near the
                    // entry address.  Once the PC alloca is found, keep
                    // tracking all stores to it.
                    if (entryAddr != 0) {
                        auto storeAddr = store.getAddr();
                        bool isPcStore = false;

                        // If we already identified the PC alloca, check this store.
                        if (inferredPcAlloca && storeAddr == inferredPcAlloca) {
                            isPcStore = true;
                        }

                        // First time: detect by entry address match.
                        if (!inferredPcAlloca) {
                            if (auto constOp =
                                    store.getValue().getDefiningOp<LLVM::ConstantOp>()) {
                                if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                                    auto val = static_cast<uint64_t>(
                                        intAttr.getValue().getZExtValue());
                                    if (val == entryAddr) {
                                        inferredPcAlloca = storeAddr;
                                        isPcStore = true;
                                    }
                                }
                            }
                        }

                        if (isPcStore) {
                            // Use tryEvaluate to handle constants, loads,
                            // add/sub chains (e.g. load NEXT_PC → store PC).
                            auto evaluated = pcTracker.tryEvaluate(
                                store.getValue(), regs);
                            if (evaluated) {
                                pcTracker.current_pc =
                                    static_cast<uint64_t>(*evaluated);
                                pcTracker.has_pc = true;
                            }
                        }
                    }
                }

                builder.setInsertionPoint(op);
                convertOperation(op, builder, regs, pcTracker, dummyBlock, deferredTerminator, opsToErase);
            }

            // Emit deferred terminator if needed (e.g. replacing LLVM ret with HelixLow ret)
            if (deferredTerminator) {
                auto addrAttr = pcTracker.has_pc
                    ? IntegerAttr::get(
                          IntegerType::get(builder.getContext(), 64,
                                           IntegerType::Unsigned),
                          pcTracker.current_pc)
                    : IntegerAttr{};

                // Get the existing LLVM terminator (e.g., `br i1 true, ...`)
                // which we need to erase after emitting the HelixLow terminator.
                auto* oldTerminator = block->getTerminator();

                // Insert the new terminator BEFORE the old one.
                if (oldTerminator) {
                    builder.setInsertionPoint(oldTerminator);
                } else {
                    builder.setInsertionPointToEnd(block);
                }

                deferredTerminator(builder, addrAttr);

                // Erase the old LLVM terminator so the new JccOp/JmpOp/RetOp
                // becomes the real block terminator with correct successor edges.
                if (oldTerminator) {
                    oldTerminator->erase();
                }
            }
        }

        // ─── Erase collected ops ────────────────────────────────────────
        for (auto* op : opsToErase) {
            op->erase();
        }

        // Remove dummy block if unused
        if (dummyBlock->use_empty()) {
            dummyBlock->erase();
        }

        // Log conversion coverage metrics.
        llvm::errs() << "[LIFT-STATS] " << name
                     << ": total=" << liftStats.totalCalls
                     << " converted=" << liftStats.converted
                     << " memOps=" << liftStats.memoryOps
                     << " helpers=" << liftStats.helpers
                     << " external=" << liftStats.externalCalls
                     << " indirect=" << liftStats.indirectCalls
                     << "\n";

        // We can now safely erase the original LLVM function.
        llvmFunc.erase();

        return success();
    }

    /// Convert a single LLVM Dialect operation to HelixLow.
    void convertOperation(Operation* op, OpBuilder& builder,
                          const RegisterTracker& regs,
                          PCTracker& pcTracker,
                          Block* dummyBlock,
                          std::function<void(OpBuilder&, IntegerAttr)>& deferredTerminator,
                          llvm::SmallVector<Operation*, 16>& opsToErase) {
        auto loc = op->getLoc();
        // Build address attribute as UI64 (unsigned 64-bit int) to satisfy
        // OptionalAttr<UI64Attr> constraints in HelixLowOps.td.
        auto addrAttr = pcTracker.has_pc
            ? IntegerAttr::get(
                  IntegerType::get(builder.getContext(), 64,
                                   IntegerType::Unsigned),
                  pcTracker.current_pc)
            : IntegerAttr{};

        // ─── Pattern: Load from register pointer ─────────────────────────
        if (auto load = dyn_cast<LLVM::LoadOp>(op)) {
            if (auto regName = regs.getRegName(load.getAddr())) {
                // Fold tracked bookkeeping slots directly to constants so
                // they don't become orphan temporaries like v0/v1/v7.
                if (auto it = pcTracker.trackedValues.find(*regName);
                    it != pcTracker.trackedValues.end() &&
                    load.getResult().getType().isSignlessInteger()) {
                    auto intTy = cast<IntegerType>(load.getResult().getType());
                    auto constant = builder.create<LLVM::ConstantOp>(
                        loc,
                        intTy,
                        IntegerAttr::get(intTy, it->second));
                    load.getResult().replaceAllUsesWith(constant.getResult());
                    opsToErase.push_back(op);
                    return;
                }

                if ((*regName == "PC" || *regName == "NEXT_PC" ||
                     *regName == "RETURN_PC") &&
                    load.getResult().getType().isSignlessInteger()) {
                    llvm::DenseSet<Block*> visitingBlocks;
                    if (auto resolved = resolvePointerValueBefore(
                            load->getBlock(), Block::iterator(load),
                            load.getAddr(), /*depth=*/6, visitingBlocks)) {
                        auto intTy = cast<IntegerType>(load.getResult().getType());
                        auto constant = builder.create<LLVM::ConstantOp>(
                            loc,
                            intTy,
                            IntegerAttr::get(intTy, *resolved));
                        load.getResult().replaceAllUsesWith(constant.getResult());
                        opsToErase.push_back(op);
                        return;
                    }
                }

                unsigned width = RegisterTracker::inferRegWidth(*regName);
                auto intTy = builder.getIntegerType(width);

                auto regRead = builder.create<helix::low::RegReadOp>(
                    loc,
                    intTy,
                    builder.getStringAttr(*regName),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
                load.getResult().replaceAllUsesWith(regRead.getResult());
                opsToErase.push_back(op);
                return;
            }
            // Non-register load — stack/memory access.
            // Emit as helix_low.mem.read so downstream passes can resolve
            // stack variables or memory accesses.
            {
                auto addrVal = load.getAddr();
                auto resultTy = load.getResult().getType();
                unsigned width = 64;
                if (auto intTy = dyn_cast<IntegerType>(resultTy))
                    width = intTy.getWidth();

                auto memRead = builder.create<helix::low::MemReadOp>(
                    loc,
                    builder.getIntegerType(width),
                    ensureInt64(addrVal, builder, loc, &regs, &pcTracker),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
                load.getResult().replaceAllUsesWith(memRead.getResult());
                opsToErase.push_back(op);
            }
            return;
        }

        // ─── Pattern: Store to register pointer ──────────────────────────
        if (auto store = dyn_cast<LLVM::StoreOp>(op)) {
            // ─── Skip dead stores from Memory* chain breaking ────────────
            // After eraseRemillCall(), the Memory* token is replaced with
            // UndefOp. The stored value may go through ExtractValueOp,
            // IntToPtrOp, or PtrToIntOp before reaching the store.
            {
                Value val = store.getValue();
                Operation* defOp = val.getDefiningOp();
                // Trace through wrapper ops to find the root UndefOp.
                while (defOp) {
                    if (isa<LLVM::UndefOp>(defOp))
                        return;
                    if (auto ev = dyn_cast<LLVM::ExtractValueOp>(defOp)) {
                        defOp = ev.getContainer().getDefiningOp();
                    } else if (auto itop = dyn_cast<LLVM::IntToPtrOp>(defOp)) {
                        defOp = itop.getArg().getDefiningOp();
                    } else if (auto ptoi = dyn_cast<LLVM::PtrToIntOp>(defOp)) {
                        defOp = ptoi.getArg().getDefiningOp();
                    } else if (auto bitcast = dyn_cast<LLVM::BitcastOp>(defOp)) {
                        defOp = bitcast.getArg().getDefiningOp();
                    } else {
                        break;
                    }
                }
            }

            // ─── Skip stores to MEMORY alloca ────────────────────────────
            // Remill keeps a `ptr %MEMORY` alloca and stores the Memory*
            // token back after every semantic call. These produce the
            // `*((int64_t)(&__local)) = ...` noise in the C output.
            if (store.getAddr().getDefiningOp<LLVM::AllocaOp>())
                return;

            if (auto regName = regs.getRegName(store.getAddr())) {
                // Skip PC/NEXT_PC updates — these are bookkeeping
                if (*regName == "PC" || *regName == "NEXT_PC")
                    return;
                // Skip MEMORY, STATE, segment bases — Remill internals
                if (*regName == "MEMORY" || *regName == "STATE" ||
                    regName->ends_with("BASE"))
                    return;

                unsigned width = RegisterTracker::inferRegWidth(*regName);

                builder.create<helix::low::RegWriteOp>(
                    loc,
                    store.getValue(),
                    builder.getStringAttr(*regName),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
                opsToErase.push_back(op);
                return;
            }
            // Non-register store — stack/memory access.
            // Emit as helix_low.mem.write so downstream passes can resolve
            // stack variables or memory accesses.
            {
                auto addrVal = store.getAddr();
                auto valTy = store.getValue().getType();
                unsigned width = 64;
                if (auto intTy = dyn_cast<IntegerType>(valTy))
                    width = intTy.getWidth();

                builder.create<helix::low::MemWriteOp>(
                    loc,
                    ensureInt64(addrVal, builder, loc, &regs, &pcTracker),
                    ensureInt64(store.getValue(), builder, loc, &regs, &pcTracker),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
                opsToErase.push_back(op);
            }
            return;
        }

        // ─── Pattern: Call to Remill semantic or intrinsic ───────────────
        if (auto call = dyn_cast<LLVM::CallOp>(op)) {
            auto callee = call.getCallee();
            ++liftStats.totalCalls;

            // Helper: break the Memory* use-def chain for any Remill call
            // and mark it for erasure. This MUST be called on every code path
            // that handles a Remill LLVM::CallOp, otherwise the PseudoCEmitter
            // will render it as MOV(...), CMP(...), etc.
            auto eraseRemillCall = [&]() {
                if (call.getNumResults() > 0) {
                    auto result = op->getResult(0);
                    if (!result.use_empty()) {
                        auto undef = builder.create<LLVM::UndefOp>(loc, result.getType());
                        result.replaceAllUsesWith(undef);
                    }
                }
                opsToErase.push_back(op);
            };

            // ── Handle indirect calls (function pointer calls) ──────────
            if (!callee) {
                ++liftStats.indirectCalls;
                // Build the target address value from the callee operand.
                // For indirect LLVM::CallOp, operand(0) may be the function
                // pointer when the Remill memory token isn't the first arg.
                Value targetVal;
                unsigned numOps = call.getNumOperands();

                // Heuristic: In Remill-lifted IR, indirect calls through
                // computed addresses often have the target in a register.
                // Try to find an integer operand whose width matches the
                // machine word (i32 on x86, i64 on x86-64) and that isn't
                // the memory token.
                for (unsigned i = 0; i < numOps; ++i) {
                    auto opVal = call.getOperand(i);
                    auto ty = opVal.getType();
                    if (ty.isInteger(machineIntWidth_)) {
                        targetVal = opVal;
                        break;
                    }
                }

                if (!targetVal && numOps > 0) {
                    // Fallback: use PtrToInt on the first operand, width
                    // matching the current function's machine word.
                    auto machineTy = machineIntTy(builder);
                    auto firstOp = call.getOperand(0);
                    if (isa<LLVM::LLVMPointerType>(firstOp.getType())) {
                        targetVal = builder.create<LLVM::PtrToIntOp>(
                            loc, machineTy, firstOp);
                    } else {
                        // Last resort: zero constant.
                        targetVal = builder.create<LLVM::ConstantOp>(
                            loc, machineTy,
                            builder.getI64IntegerAttr(0));
                    }
                }

                if (targetVal) {
                    auto callArgs = collectCallArgs(op);
                    // Use the target operand's type as the result type — this
                    // gives i32 on x86 (i386 PE like gta-sa.exe) and i64 on
                    // x86-64.  Hard-coding i64 here sign-extended 32-bit call
                    // addresses into forms like `sub_ffffffffc75c4ad9()` on
                    // x86 output.
                    auto resultTy = targetVal.getType();
                    unsigned resultBits =
                        isa<IntegerType>(resultTy)
                            ? cast<IntegerType>(resultTy).getWidth() : 64;
                    auto callOp = builder.create<helix::low::CallOp>(
                        loc,
                        /*resultTypes=*/TypeRange{resultTy},
                        targetVal,
                        callArgs,
                        /*target_name=*/StringAttr{},
                        addrAttr);

                    // Materialize RAX def (return-value dataflow): the call's
                    // result becomes the new RAX version so subsequent
                    // reg.read RAX picks up a distinct SSA value.
                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        callOp.getResult(),
                        builder.getStringAttr("RAX"),
                        builder.getUI32IntegerAttr(resultBits),
                        addrAttr);

                    llvm::errs() << "[P0-DEBUG] Indirect call: created CallOp"
                                 << " addr=" << (addrAttr ? std::to_string(addrAttr.getValue().getZExtValue()) : "null")
                                 << " nArgs=" << callArgs.size()
                                 << "\n";
                }

                eraseRemillCall();
                return;
            }

            auto calleeName = callee->str();

            // Check for Remill memory intrinsics.
            if (calleeName.starts_with("__remill_read_memory_")) {
                ++liftStats.memoryOps;
                unsigned width = extractRemillMemoryWidth(calleeName);
                if (width == 0) return;

                auto intTy = builder.getIntegerType(width);
                // __remill_read_memory_N(ptr %memory, i64 %addr) -> iN
                // Operand 1 is the address (operand 0 is the memory token).
                if (call.getNumOperands() >= 2) {
                    builder.create<helix::low::MemReadOp>(
                        loc,
                        intTy,
                        call.getOperand(1),  // address
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                }
                eraseRemillCall();
                return;
            }

            if (calleeName.starts_with("__remill_write_memory_")) {
                ++liftStats.memoryOps;
                unsigned width = extractRemillMemoryWidth(calleeName);
                if (width == 0) return;

                // __remill_write_memory_N(ptr %memory, i64 %addr, iN %value) -> ptr
                if (call.getNumOperands() >= 3) {
                    builder.create<helix::low::MemWriteOp>(
                        loc,
                        call.getOperand(1),  // address
                        call.getOperand(2),  // value
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                }
                eraseRemillCall();
                return;
            }

            // Skip other Remill helpers (flag computations, etc.)
            if (calleeName.starts_with("__remill_") ||
                calleeName.starts_with("llvm.")) {
                ++liftStats.helpers;
                eraseRemillCall();
                return;
            }

            // Try to demangle as a Remill semantic function.
            auto semInfo = demangleRemillSemantic(calleeName);
            if (!semInfo) {
                ++liftStats.externalCalls;
                // Unrecognized mangled name — preserve the call and emit warning.
                // This ensures we don't silently drop calls that might be
                // important for the decompiled output.
                if (calleeName.starts_with("_Z")) {
                    op->emitWarning("unrecognized mangled name: ") << calleeName;
                }
                // Emit as a generic call with the original name preserved.
                // Use a zero constant as placeholder target address.  Width
                // matches the current function's machine word (i32 on x86).
                auto machineTy = machineIntTy(builder);
                auto zero = builder.create<LLVM::ConstantOp>(
                    loc, machineTy, builder.getI64IntegerAttr(0));

                // Collect arguments from the calling convention registers
                // so the external call carries its actual parameter values
                // (e.g., kmalloc(size, flags) → RDI=size, RSI=flags on SysV).
                auto callArgs = collectCallArgs(op);

                // ── Wave 22 Step 2 — zeroed-fmt variadic detection ─────────
                if (auto fmtSlot = getVariadicFmtSlot(calleeName)) {
                    if (*fmtSlot < callArgs.size() &&
                        isLiteralZero(callArgs[*fmtSlot])) {
                        auto bundleType =
                            helix::low::BundleType::get(builder.getContext());
                        auto bundleOp =
                            builder.create<helix::low::BundleCreateOp>(
                                loc, bundleType,
                                helix::low::BundleState::Zeroed,
                                builder.getStringAttr(
                                    "upstream_zeroed_before_helix"));
                        auto vCall =
                            builder.create<helix::low::VariadicCallOp>(
                                loc, /*resultTypes=*/TypeRange{machineTy},
                                zero, callArgs, bundleOp.getBundle(),
                                builder.getStringAttr(calleeName), addrAttr);
                        builder.create<helix::low::RegWriteOp>(
                            loc, vCall.getResult(),
                            builder.getStringAttr("RAX"),
                            builder.getUI32IntegerAttr(machineIntWidth_),
                            addrAttr);
                        llvm::errs()
                            << "[P0-DEBUG] Variadic call (zeroed fmt): name="
                            << calleeName << " fmtSlot=" << *fmtSlot
                            << " nArgs=" << callArgs.size() << "\n";
                        eraseRemillCall();
                        return;
                    }
                }

                auto extCall = builder.create<helix::low::CallOp>(
                    loc,
                    /*resultTypes=*/TypeRange{machineTy},
                    zero,
                    callArgs,
                    builder.getStringAttr(calleeName),
                    addrAttr);

                // Materialize RAX def with the call's result (return-value
                // dataflow — see CallOp docs for rationale).
                builder.create<helix::low::RegWriteOp>(
                    loc,
                    extCall.getResult(),
                    builder.getStringAttr("RAX"),
                    builder.getUI32IntegerAttr(machineIntWidth_),
                    addrAttr);

                llvm::errs() << "[P0-DEBUG] External call: created CallOp"
                             << " name=" << calleeName
                             << " addr=" << (addrAttr ? std::to_string(addrAttr.getValue().getZExtValue()) : "null")
                             << " nArgs=" << callArgs.size()
                             << "\n";

                // Break the use-def chain and mark for erasure to ensure
                // Memory* tokens don't leak into variable recovery.
                eraseRemillCall();
                return;
            }

            if (semInfo->is_helper) {
                ++liftStats.helpers;
                eraseRemillCall();
                return;
            }

            ++liftStats.converted;
            convertSemantic(call, builder, regs, *semInfo, addrAttr, loc, dummyBlock, deferredTerminator, pcTracker);

            // Break the use-def chain and mark for erasure.
            eraseRemillCall();

            return;
        }

        // ─── Pattern: GEP (register access setup) — skip ────────────────
        if (isa<LLVM::GEPOp>(op))
            return;

        // ─── Pattern: Alloca (Remill internals) — skip ──────────────────
        if (isa<LLVM::AllocaOp>(op))
            return;

        // ─── Pattern: Return — emit HelixLow ret ────────────────────────
        if (isa<LLVM::ReturnOp>(op)) {
            deferredTerminator = [loc](OpBuilder& b, IntegerAttr addr) {
                b.create<helix::low::RetOp>(loc, addr);
            };
            return;
        }

        // ─── Pattern: Add (PC increment) — check if bookkeeping ─────────
        // Remill emits: %next = add i64 %pc, <size> for PC tracking.
        // We skip these as they're handled by PCTracker.
        if (isa<LLVM::AddOp>(op))
            return;

        // Other LLVM ops are currently ignored (will be handled as passes mature).
    }

    /// Helper to cast pointers to i64 for arithmetic/logic operations
    Value ensureInt64(Value val, OpBuilder& builder, Location loc,
                      const RegisterTracker* regs = nullptr,
                      const PCTracker* pcTracker = nullptr) {
        if (regs && pcTracker) {
            if (auto evaluated = pcTracker->tryEvaluate(val, *regs)) {
                return builder.create<LLVM::ConstantOp>(
                    loc,
                    builder.getI64Type(),
                    builder.getI64IntegerAttr(*evaluated));
            }
        }
        if (isa<LLVM::LLVMPointerType>(val.getType())) {
            return builder.create<LLVM::PtrToIntOp>(
                loc, builder.getI64Type(), val);
        }
        return val;
    }

    unsigned inferValueWidth(Value val) {
        if (auto intTy = dyn_cast<IntegerType>(val.getType()))
            return intTy.getWidth();
        if (isa<LLVM::LLVMPointerType>(val.getType()))
            return 64;
        return 64;
    }

    unsigned inferStoreValueWidth(Value val, const RegisterTracker& regs) {
        if (auto intTy = dyn_cast<IntegerType>(val.getType())) {
            if (intTy.getWidth() < 64)
                return intTy.getWidth();
        }

        if (auto zext = val.getDefiningOp<LLVM::ZExtOp>()) {
            if (auto intTy = dyn_cast<IntegerType>(zext.getArg().getType()))
                return intTy.getWidth();
        }

        if (auto sext = val.getDefiningOp<LLVM::SExtOp>()) {
            if (auto intTy = dyn_cast<IntegerType>(sext.getArg().getType()))
                return intTy.getWidth();
        }

        if (auto trunc = val.getDefiningOp<LLVM::TruncOp>()) {
            if (auto intTy = dyn_cast<IntegerType>(trunc.getResult().getType()))
                return intTy.getWidth();
        }

        if (auto load = val.getDefiningOp<LLVM::LoadOp>()) {
            if (auto regName = regs.getRegName(load.getAddr()))
                return RegisterTracker::inferRegWidth(*regName);
        }

        return inferValueWidth(val);
    }

    void emitRegisterOrMemoryWrite(OpBuilder& builder, Location loc,
                                   Value destination, Value originalValue,
                                   Value widenedResult,
                                   const RegisterTracker& regs,
                                   IntegerAttr addrAttr) {
        auto regName = regs.getRegName(destination);
        unsigned width = regName
            ? RegisterTracker::inferRegWidth(*regName)
            : inferValueWidth(originalValue);

        Value resultVal = widenedResult;
        if (width < 64) {
            resultVal = builder.create<LLVM::TruncOp>(
                loc, builder.getIntegerType(width), resultVal);
        }

        if (regName) {
            builder.create<helix::low::RegWriteOp>(
                loc,
                resultVal,
                builder.getStringAttr(*regName),
                builder.getUI32IntegerAttr(width),
                addrAttr);
            return;
        }

        builder.create<helix::low::MemWriteOp>(
            loc,
            ensureInt64(destination, builder, loc),
            resultVal,
            builder.getUI32IntegerAttr(width),
            addrAttr);
    }

    /// Helper to strip casts for register equality checking
    Value stripCasts(Value val) {
        while (val && val.getDefiningOp()) {
            Operation* op = val.getDefiningOp();
            if (auto ptr2int = dyn_cast<LLVM::PtrToIntOp>(op)) { val = ptr2int.getArg(); continue; }
            if (auto int2ptr = dyn_cast<LLVM::IntToPtrOp>(op)) { val = int2ptr.getArg(); continue; }
            if (auto zext = dyn_cast<LLVM::ZExtOp>(op)) { val = zext.getArg(); continue; }
            if (auto sext = dyn_cast<LLVM::SExtOp>(op)) { val = sext.getArg(); continue; }
            if (auto trunc = dyn_cast<LLVM::TruncOp>(op)) { val = trunc.getArg(); continue; }
            if (auto bcast = dyn_cast<LLVM::BitcastOp>(op)) { val = bcast.getArg(); continue; }
            break;
        }
        return val;
    }

    static std::string normalizeRegName(llvm::StringRef name) {
        if (name == "EAX" || name == "AX" || name == "AL" || name == "AH") return "RAX";
        if (name == "EBX" || name == "BX" || name == "BL" || name == "BH") return "RBX";
        if (name == "ECX" || name == "CX" || name == "CL" || name == "CH") return "RCX";
        if (name == "EDX" || name == "DX" || name == "DL" || name == "DH") return "RDX";
        if (name == "ESI" || name == "SI" || name == "SIL") return "RSI";
        if (name == "EDI" || name == "DI" || name == "DIL") return "RDI";
        if (name == "EBP" || name == "BP" || name == "BPL") return "RBP";
        if (name == "ESP" || name == "SP" || name == "SPL") return "RSP";
        if (name == "R8D" || name == "R8W" || name == "R8B") return "R8";
        if (name == "R9D" || name == "R9W" || name == "R9B") return "R9";
        if (name == "R10D" || name == "R10W" || name == "R10B") return "R10";
        if (name == "R11D" || name == "R11W" || name == "R11B") return "R11";
        if (name == "R12D" || name == "R12W" || name == "R12B") return "R12";
        if (name == "R13D" || name == "R13W" || name == "R13B") return "R13";
        if (name == "R14D" || name == "R14W" || name == "R14B") return "R14";
        if (name == "R15D" || name == "R15W" || name == "R15B") return "R15";
        return name.str();
    }

    /// Check if two SSA values originate from the same register.
    /// This detects idioms like XOR reg, reg / MOV reg, reg / TEST reg, reg.
    bool isSameRegisterOperand(Value a, Value b, const RegisterTracker& regs) {
        a = stripCasts(a);
        b = stripCasts(b);
        // Same SSA value → definitely same register.
        if (a == b)
            return true;

        // Both must resolve to known registers with the same name.
        auto regA = regs.getRegName(a);
        auto regB = regs.getRegName(b);
        if (regA && regB && normalizeRegName(*regA) == normalizeRegName(*regB))
            return true;

        // Check if both values have already been converted to RegReadOp
        auto rrA = a.getDefiningOp<helix::low::RegReadOp>();
        auto rrB = b.getDefiningOp<helix::low::RegReadOp>();
        if (rrA && rrB) {
            if (normalizeRegName(rrA.getRegName()) == normalizeRegName(rrB.getRegName()))
                return true;
        }

        auto loadA = a.getDefiningOp<LLVM::LoadOp>();
        auto loadB = b.getDefiningOp<LLVM::LoadOp>();
        if (loadA && loadB) {
            auto rA = regs.getRegName(loadA.getAddr());
            auto rB = regs.getRegName(loadB.getAddr());
            if (rA && rB && normalizeRegName(*rA) == normalizeRegName(*rB))
                return true;
        }

        return false;
    }

    /// Safely extract an operand from a call, returning a zero constant if
    /// the index is out of bounds. This handles Remill semantics with variable
    /// argument layouts (e.g., 8-bit vs 64-bit variants may have different
    /// numbers of operands) without crashing on unexpected layouts.
    Value safeGetOperand(LLVM::CallOp call, unsigned idx,
                         OpBuilder& builder, Location loc) {
        if (idx < call.getNumOperands())
            return call.getOperand(idx);
        // Out of bounds — return a zero constant as fallback.
        return builder.create<LLVM::ConstantOp>(
            loc, builder.getI64Type(), builder.getI64IntegerAttr(0));
    }

    std::optional<Value> findLatestRegWriteInBlock(
        Block* block, Block::iterator endIt, llvm::StringRef canonicalReg) {
        if (!block)
            return std::nullopt;

        for (auto it = endIt; it != block->begin();) {
            --it;
            if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&*it)) {
                llvm::StringRef lookup =
                    helix::analysis::getCanonicalX86Register(regWrite.getRegName());
                if (lookup.empty())
                    lookup = regWrite.getRegName();
                if (lookup == canonicalReg)
                    return regWrite.getValue();
            }
        }

        return std::nullopt;
    }

    std::optional<Value> findLatestRegWriteInPredecessors(
        Block* block, llvm::StringRef canonicalReg, unsigned depth,
        llvm::DenseSet<Block*>& visiting) {
        if (!block || depth == 0 || !visiting.insert(block).second)
            return std::nullopt;

        std::optional<Value> candidate;
        for (Block* pred : block->getPredecessors()) {
            auto value = findLatestRegWriteInBlock(pred, pred->end(), canonicalReg);
            if (!value)
                value = findLatestRegWriteInPredecessors(
                    pred, canonicalReg, depth - 1, visiting);
            if (!value) {
                visiting.erase(block);
                return std::nullopt;
            }
            if (candidate && *candidate != *value) {
                visiting.erase(block);
                return std::nullopt;
            }
            candidate = *value;
        }

        visiting.erase(block);
        return candidate;
    }

    llvm::SmallVector<Value, 4> collectWin64CallArgs(
        Operation* beforeOp, unsigned predecessorDepth = 2) {
        static constexpr std::array<std::string_view, 4> kWin64ArgRegs = {
            "RCX", "RDX", "R8", "R9"
        };

        auto* block = beforeOp ? beforeOp->getBlock() : nullptr;
        if (!block)
            return {};

        llvm::DenseMap<llvm::StringRef, Value> regState;
        for (auto& op : block->getOperations()) {
            if (&op == beforeOp)
                break;
            if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&op)) {
                llvm::StringRef lookup =
                    helix::analysis::getCanonicalX86Register(regWrite.getRegName());
                if (lookup.empty())
                    lookup = regWrite.getRegName();
                regState[lookup] = regWrite.getValue();
            }
        }

        llvm::SmallVector<Value, 4> args;
        for (auto argReg : kWin64ArgRegs) {
            llvm::StringRef key(argReg.data(), argReg.size());
            auto it = regState.find(key);
            if (it == regState.end()) {
                llvm::DenseSet<Block*> visiting;
                auto fromPreds = findLatestRegWriteInPredecessors(
                    block, key, predecessorDepth, visiting);
                if (!fromPreds)
                    break;
                regState[key] = *fromPreds;
                it = regState.find(key);
            }
            args.push_back(it->second);
        }

        return args;
    }

    /// Collect arguments for SysV AMD64 ABI (Linux/ELF).
    /// Register order: RDI, RSI, RDX, RCX, R8, R9.
    llvm::SmallVector<Value, 6> collectSysVCallArgs(
        Operation* beforeOp, unsigned predecessorDepth = 2) {
        static constexpr std::array<std::string_view, 6> kSysVArgRegs = {
            "RDI", "RSI", "RDX", "RCX", "R8", "R9"
        };

        auto* block = beforeOp ? beforeOp->getBlock() : nullptr;
        if (!block)
            return {};

        llvm::DenseMap<llvm::StringRef, Value> regState;
        for (auto& op : block->getOperations()) {
            if (&op == beforeOp)
                break;
            if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(&op)) {
                llvm::StringRef lookup =
                    helix::analysis::getCanonicalX86Register(regWrite.getRegName());
                if (lookup.empty())
                    lookup = regWrite.getRegName();
                regState[lookup] = regWrite.getValue();
            }
        }

        llvm::SmallVector<Value, 6> args;
        for (auto argReg : kSysVArgRegs) {
            llvm::StringRef key(argReg.data(), argReg.size());
            auto it = regState.find(key);
            if (it == regState.end()) {
                llvm::DenseSet<Block*> visiting;
                auto fromPreds = findLatestRegWriteInPredecessors(
                    block, key, predecessorDepth, visiting);
                if (!fromPreds)
                    break;
                regState[key] = *fromPreds;
                it = regState.find(key);
            }
            args.push_back(it->second);
        }

        return args;
    }

    /// Collect call arguments using the appropriate ABI.
    /// Detects Win64 vs SysV based on the module's target triple.
    llvm::SmallVector<Value, 6> collectCallArgs(Operation* beforeOp) {
        // Walk up to the parent module and check the target triple.
        auto parentModule = beforeOp->getParentOfType<ModuleOp>();
        bool isSysV = false;
        if (parentModule) {
            if (auto tripleAttr = parentModule->getAttrOfType<StringAttr>(
                    "llvm.target_triple")) {
                auto triple = tripleAttr.getValue();
                isSysV = triple.contains("linux") || triple.contains("elf") ||
                         triple.contains("gnu") || triple.contains("freebsd") ||
                         triple.contains("apple") || triple.contains("darwin");
            }
        }
        if (isSysV)
            return collectSysVCallArgs(beforeOp);
        return collectWin64CallArgs(beforeOp);
    }

    std::optional<LLVM::StoreOp> findLatestStoreToPointerInBlock(
        Block* block, Block::iterator endIt, Value ptr) {
        if (!block)
            return std::nullopt;

        ptr = RegisterTracker::stripPointerAliases(ptr);
        for (auto it = endIt; it != block->begin();) {
            --it;
            auto store = dyn_cast<LLVM::StoreOp>(&*it);
            if (!store)
                continue;
            if (RegisterTracker::stripPointerAliases(store.getAddr()) == ptr)
                return store;
        }

        return std::nullopt;
    }

    std::optional<int64_t> tryEvaluateBookkeepingValue(
        Value value,
        llvm::function_ref<std::optional<int64_t>(Value)> resolvePointer,
        llvm::SmallPtrSetImpl<Operation*>& visiting) {
        if (!value)
            return std::nullopt;

        auto* defOp = value.getDefiningOp();
        if (!defOp)
            return std::nullopt;
        if (!visiting.insert(defOp).second)
            return std::nullopt;

        auto eraseOnReturn = llvm::make_scope_exit([&] {
            visiting.erase(defOp);
        });

        if (auto constOp = dyn_cast<LLVM::ConstantOp>(defOp)) {
            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                return intAttr.getValue().getSExtValue();
        }

        if (auto constOp = dyn_cast<arith::ConstantOp>(defOp)) {
            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                return intAttr.getValue().getSExtValue();
        }

        if (auto intAttr = defOp->getAttrOfType<IntegerAttr>("value"))
            return intAttr.getValue().getSExtValue();

        if (auto load = dyn_cast<LLVM::LoadOp>(defOp))
            return resolvePointer(RegisterTracker::stripPointerAliases(load.getAddr()));

        if (auto add = dyn_cast<LLVM::AddOp>(defOp)) {
            auto lhs = tryEvaluateBookkeepingValue(
                add.getLhs(), resolvePointer, visiting);
            auto rhs = tryEvaluateBookkeepingValue(
                add.getRhs(), resolvePointer, visiting);
            if (lhs && rhs)
                return *lhs + *rhs;
            return std::nullopt;
        }

        if (auto sub = dyn_cast<LLVM::SubOp>(defOp)) {
            auto lhs = tryEvaluateBookkeepingValue(
                sub.getLhs(), resolvePointer, visiting);
            auto rhs = tryEvaluateBookkeepingValue(
                sub.getRhs(), resolvePointer, visiting);
            if (lhs && rhs)
                return *lhs - *rhs;
            return std::nullopt;
        }

        if (auto zext = dyn_cast<LLVM::ZExtOp>(defOp))
            return tryEvaluateBookkeepingValue(
                zext.getArg(), resolvePointer, visiting);
        if (auto sext = dyn_cast<LLVM::SExtOp>(defOp))
            return tryEvaluateBookkeepingValue(
                sext.getArg(), resolvePointer, visiting);
        if (auto trunc = dyn_cast<LLVM::TruncOp>(defOp))
            return tryEvaluateBookkeepingValue(
                trunc.getArg(), resolvePointer, visiting);
        if (auto ptrToInt = dyn_cast<LLVM::PtrToIntOp>(defOp))
            return tryEvaluateBookkeepingValue(
                ptrToInt.getArg(), resolvePointer, visiting);
        if (auto intToPtr = dyn_cast<LLVM::IntToPtrOp>(defOp))
            return tryEvaluateBookkeepingValue(
                intToPtr.getArg(), resolvePointer, visiting);

        return std::nullopt;
    }

    std::optional<int64_t> resolvePointerValueBefore(
        Block* block, Block::iterator endIt, Value ptr, unsigned depth,
        llvm::DenseSet<Block*>& visitingBlocks) {
        if (!block || depth == 0)
            return std::nullopt;

        ptr = RegisterTracker::stripPointerAliases(ptr);

        if (auto store = findLatestStoreToPointerInBlock(block, endIt, ptr)) {
            llvm::SmallPtrSet<Operation*, 16> visitingValues;
            auto resolveNestedPointer =
                [&](Value nestedPtr) -> std::optional<int64_t> {
                return resolvePointerValueBefore(
                    block, Block::iterator(store->getOperation()),
                    nestedPtr, depth - 1, visitingBlocks);
            };
            return tryEvaluateBookkeepingValue(
                store->getValue(), resolveNestedPointer, visitingValues);
        }

        if (!visitingBlocks.insert(block).second)
            return std::nullopt;

        std::optional<int64_t> candidate;
        for (Block* pred : block->getPredecessors()) {
            auto value = resolvePointerValueBefore(
                pred, pred->end(), ptr, depth - 1, visitingBlocks);
            if (!value) {
                visitingBlocks.erase(block);
                return std::nullopt;
            }
            if (candidate && *candidate != *value) {
                visitingBlocks.erase(block);
                return std::nullopt;
            }
            candidate = *value;
        }

        visitingBlocks.erase(block);
        return candidate;
    }

    // ─── Flag Value Search (same-block + predecessor walk) ────────────
    //
    // Used by the JCC condition synthesis to find the most recent RegWriteOp
    // for a given flag name (ZF, CF, SF, OF).  The search starts in the
    // current block and, if not found, walks predecessor blocks using cycle
    // detection and consensus checking (all predecessors must agree on the
    // same SSA value).
    //
    // This fixes the critical bug where CMP/TEST in a predecessor block
    // would cause flag synthesis to fall back to `constant true`.

    /// Search backwards in a single block for a RegWriteOp to the named flag.
    static Value findFlagValueInBlock(
        Block* block, Block::iterator endIt, llvm::StringRef flagName) {
        if (!block)
            return nullptr;

        for (auto it = Block::reverse_iterator(endIt);
             it != block->rend(); ++it) {
            if (auto regWrite = dyn_cast<helix::low::RegWriteOp>(*it)) {
                if (regWrite.getRegName() == flagName) {
                    return regWrite.getValue();
                }
            }
        }
        return nullptr;
    }

    /// Recursively search predecessor blocks for a RegWriteOp to the named
    /// flag.  Returns nullptr if not found, if depth is exhausted, or if
    /// multiple predecessors disagree (provide different SSA values).
    static Value findFlagValueInPredecessors(
        Block* block, llvm::StringRef flagName,
        unsigned depth, llvm::DenseSet<Block*>& visiting) {
        if (!block || depth == 0 || !visiting.insert(block).second)
            return nullptr;

        Value candidate = nullptr;
        for (Block* pred : block->getPredecessors()) {
            Value value = findFlagValueInBlock(pred, pred->end(), flagName);
            if (!value) {
                value = findFlagValueInPredecessors(
                    pred, flagName, depth - 1, visiting);
            }
            if (!value) {
                // Predecessor has no flag write — ambiguous, bail out.
                visiting.erase(block);
                return nullptr;
            }
            if (candidate && candidate != value) {
                // Multiple predecessors provide different values — ambiguous.
                visiting.erase(block);
                return nullptr;
            }
            candidate = value;
        }

        visiting.erase(block);
        return candidate;
    }

    /// Find the most recent flag-producing operation (CmpOp, BinOp, TestOp)
    /// in the current block.  Used for JP/JNP parity flag computation.
    static Operation* findFlagProducerInBlock(
        Block* block, Block::iterator endIt) {
        if (!block)
            return nullptr;

        for (auto it = Block::reverse_iterator(endIt);
             it != block->rend(); ++it) {
            if (isa<helix::low::CmpOp>(*it) ||
                isa<helix::low::BinOp>(*it) ||
                isa<helix::low::TestOp>(*it)) {
                return &*it;
            }
        }
        return nullptr;
    }

    /// Detect a segment-register-relative memory address.
    ///
    /// Recognises Remill's lowering of `gs:[N]` / `fs:[N]` in two forms:
    ///   (a) Pre-conversion (LLVM IR straight from Remill):
    ///         %seg_base = load i64, ptr %{GS,FS}BASE_gep
    ///         %addr     = add i64 %seg_base, N
    ///   (b) Post-conversion (after the LoadOp handler in this same pass has
    ///       already replaced the load with a RegReadOp):
    ///         %seg_base = helix_low.reg.read "GSBASE"|"FSBASE"
    ///         %addr     = add i64 %seg_base, N
    ///
    /// Returns the segment name ("gs" / "fs") and the constant offset N if
    /// `addr` matches; otherwise std::nullopt.  Used so MOV reg, gs:[0x60]
    /// emits a `__readgsqword(0x60)` intrinsic call rather than a raw
    /// `MemRead(0 + 0x60)` once GSBASE itself is DCE'd to zero.
    static std::optional<std::pair<std::string, int64_t>>
    matchSegmentRelativeAddr(Value addr) {
        auto add = addr.getDefiningOp<LLVM::AddOp>();
        if (!add) return std::nullopt;

        auto extractSegName =
            [](Value baseVal) -> std::optional<std::string> {
            // Form (a): direct load of the GSBASE/FSBASE GEP slot.
            if (auto load = baseVal.getDefiningOp<LLVM::LoadOp>()) {
                if (auto rn = RegisterTracker::extractRegisterNameFromValue(
                        load.getAddr())) {
                    if (*rn == "GSBASE") return std::string("gs");
                    if (*rn == "FSBASE") return std::string("fs");
                }
            }
            // Form (b): the load was already lowered to a RegReadOp.
            if (auto rr = baseVal.getDefiningOp<helix::low::RegReadOp>()) {
                auto rn = rr.getRegName();
                if (rn == "GSBASE") return std::string("gs");
                if (rn == "FSBASE") return std::string("fs");
            }
            return std::nullopt;
        };

        auto tryMatch =
            [&](Value baseVal, Value constVal)
            -> std::optional<std::pair<std::string, int64_t>> {
            auto seg = extractSegName(baseVal);
            if (!seg) return std::nullopt;
            auto cst = constVal.getDefiningOp<LLVM::ConstantOp>();
            if (!cst) return std::nullopt;
            auto intAttr = dyn_cast<IntegerAttr>(cst.getValue());
            if (!intAttr) return std::nullopt;
            return std::make_pair(*seg, intAttr.getValue().getSExtValue());
        };

        if (auto m = tryMatch(add.getLhs(), add.getRhs())) return m;
        if (auto m = tryMatch(add.getRhs(), add.getLhs())) return m;
        return std::nullopt;
    }

    /// Build the MSVC-style segment intrinsic name for a given segment, width,
    /// and direction: __read{gs,fs}{byte,word,dword,qword} (read=true) or the
    /// "__write…" counterparts.
    static std::string segmentIntrinsicName(
        llvm::StringRef seg, unsigned widthBits, bool isRead) {
        const char* suffix =
            (widthBits == 8)  ? "byte"  :
            (widthBits == 16) ? "word"  :
            (widthBits == 32) ? "dword" :
                                "qword";
        const char* verb = isRead ? "__read" : "__write";
        return (llvm::Twine(verb) + seg + suffix).str();
    }

    /// Convert a recognized Remill semantic function call to HelixLow ops.
    void convertSemantic(LLVM::CallOp call, OpBuilder& builder,
                         const RegisterTracker& regs,
                         const RemillSemanticInfo& semInfo,
                         IntegerAttr addrAttr, Location loc,
                         Block* dummyBlock,
                         std::function<void(OpBuilder&, IntegerAttr)>& deferredTerminator,
                         const PCTracker& pcTracker) {
        auto semantic = semInfo.semantic;

        // Determine the working integer type (default 64-bit for x86_64).
        auto i64Ty = builder.getIntegerType(64);
        auto i1Ty = builder.getIntegerType(1);

        switch (semantic) {
        // ─── Arithmetic/Logic Binary Ops ─────────────────────────────────
        case RemillSemantic::ADD:
        case RemillSemantic::SUB:
        case RemillSemantic::MUL:
        case RemillSemantic::IMUL:
        case RemillSemantic::DIV:
        case RemillSemantic::IDIV:
        case RemillSemantic::AND:
        case RemillSemantic::OR:
        case RemillSemantic::XOR:
        case RemillSemantic::SHL:
        case RemillSemantic::SHR:
        case RemillSemantic::SAR:
        case RemillSemantic::ROL:
        case RemillSemantic::ROR: {
            auto kind = semanticToBinOpKind(semantic);
            if (!kind) break;

            // Remill binary op layout: (mem, state, dest_reg_ptr, lhs, rhs)
            // Use safeGetOperand for variable argument layouts.
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = safeGetOperand(call, 2, builder, loc);
                auto lhs = safeGetOperand(call, 3, builder, loc);
                auto rhs = safeGetOperand(call, 4, builder, loc);

                // ─── Idiom: XOR reg, reg → zero (emit int_lit 0) ────────
                // When both operands reference the same register, XOR reg,reg
                // is an idiom for zeroing. Emit helix_high.int_lit 0 directly
                // so downstream passes (DCE) see a constant zero instead of
                // a binop XOR that would need special-case handling.
                bool selfXor = (semantic == RemillSemantic::XOR) &&
                               isSameRegisterOperand(lhs, rhs, regs);

                auto regName = regs.getRegName(destRegPtr);
                unsigned width = 64;
                if (regName) {
                    width = RegisterTracker::inferRegWidth(*regName);
                }

                if (selfXor) {
                    auto intTy = builder.getIntegerType(width);
                    auto signedI64Ty = IntegerType::get(builder.getContext(), 64,
                                                        IntegerType::Signed);
                    auto zeroLit = builder.create<helix::high::IntLitOp>(
                        loc, intTy,
                        IntegerAttr::get(signedI64Ty, 0),
                        addrAttr);

                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        zeroLit.getResult(),
                        builder.getStringAttr(regName ? *regName : "unknown"),
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                    break;
                }

                auto binOp = builder.create<helix::low::BinOp>(
                    loc,
                    /*result=*/i64Ty,
                    /*carry_flag=*/i1Ty,
                    /*zero_flag=*/i1Ty,
                    /*sign_flag=*/i1Ty,
                    /*overflow_flag=*/i1Ty,
                    *kind,
                    ensureInt64(lhs, builder, loc, &regs, &pcTracker),   // lhs
                    ensureInt64(rhs, builder, loc, &regs, &pcTracker),   // rhs
                    addrAttr,
                    UnitAttr{});

                // ─── Mark SUB RSP,N / ADD RSP,N for DCE ─────────────────
                // When the destination is RSP and the operation is SUB or ADD,
                // this is stack frame allocation/deallocation. Mark the BinOp
                // with attributes so the DCE pass can pair and remove them.
                if (regName && *regName == "RSP") {
                    if (semantic == RemillSemantic::SUB) {
                        binOp->setAttr("is_stack_alloc",
                                       builder.getUnitAttr());
                        // Try to extract the immediate value from the rhs operand.
                        if (auto constOp = rhs.getDefiningOp<LLVM::ConstantOp>()) {
                            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                                binOp->setAttr("stack_adjust_imm", intAttr);
                            }
                        }
                    } else if (semantic == RemillSemantic::ADD) {
                        binOp->setAttr("is_stack_dealloc",
                                       builder.getUnitAttr());
                        // Try to extract the immediate value from the rhs operand.
                        if (auto constOp = rhs.getDefiningOp<LLVM::ConstantOp>()) {
                            if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                                binOp->setAttr("stack_adjust_imm", intAttr);
                            }
                        }
                    }
                }

                Value resultVal = binOp.getResult();
                if (width < 64) {
                    resultVal = builder.create<LLVM::TruncOp>(loc, builder.getIntegerType(width), resultVal);
                }

                if (regName) {
                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        resultVal,
                        builder.getStringAttr(*regName),
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                } else if (!isa<LLVM::LLVMPointerType>(destRegPtr.getType())) {
                    builder.create<helix::low::MemWriteOp>(
                        loc,
                        ensureInt64(destRegPtr, builder, loc, &regs, &pcTracker),
                        binOp.getResult(),
                        builder.getUI32IntegerAttr(64),
                        addrAttr);
                } else {
                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        binOp.getResult(),
                        builder.getStringAttr("unknown"),
                        builder.getUI32IntegerAttr(64),
                        addrAttr);
                }

                builder.create<helix::low::RegWriteOp>(loc, binOp.getCarryFlag(), builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, binOp.getZeroFlag(), builder.getStringAttr("ZF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, binOp.getSignFlag(), builder.getStringAttr("SF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, binOp.getOverflowFlag(), builder.getStringAttr("OF"), builder.getUI32IntegerAttr(1), addrAttr);
            }
            break;
        }

        // ─── Comparison ──────────────────────────────────────────────────
        case RemillSemantic::CMP: {
            // Remill CMP layout: (mem, state, lhs, rhs) — variable positions
            if (call.getNumOperands() >= 3) {
                auto lhsVal = safeGetOperand(call, 2, builder, loc);
                auto rhsVal = safeGetOperand(call, 3, builder, loc);

                // When the first operand is a memory reference (CMP [addr], imm),
                // Remill passes the ADDRESS — we must emit a MemRead to load
                // the actual value before comparing.
                if (semInfo.has_memory_src && semInfo.src_width != 0) {
                    unsigned readWidth = semInfo.src_width;
                    auto readTy = builder.getIntegerType(readWidth);
                    auto memRead = builder.create<helix::low::MemReadOp>(
                        loc, readTy,
                        ensureInt64(lhsVal, builder, loc, &regs, &pcTracker),
                        builder.getUI32IntegerAttr(readWidth),
                        addrAttr);
                    lhsVal = memRead.getResult();
                }

                auto cmpOp = builder.create<helix::low::CmpOp>(
                    loc,
                    /*carry_flag=*/i1Ty,
                    /*zero_flag=*/i1Ty,
                    /*sign_flag=*/i1Ty,
                    /*overflow_flag=*/i1Ty,
                    ensureInt64(lhsVal, builder, loc, &regs, &pcTracker),
                    ensureInt64(rhsVal, builder, loc, &regs, &pcTracker),
                    addrAttr);
                
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getCarryFlag(), builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getZeroFlag(), builder.getStringAttr("ZF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getSignFlag(), builder.getStringAttr("SF"), builder.getUI32IntegerAttr(1), addrAttr);
                builder.create<helix::low::RegWriteOp>(loc, cmpOp.getOverflowFlag(), builder.getStringAttr("OF"), builder.getUI32IntegerAttr(1), addrAttr);
            }
            break;
        }

        case RemillSemantic::TEST: {
            // Remill TEST layout: (mem, state, lhs, rhs) — variable positions
            if (call.getNumOperands() >= 3) {
                auto lhs = safeGetOperand(call, 2, builder, loc);
                auto rhs = safeGetOperand(call, 3, builder, loc);

                // Memory source: TEST [addr], imm → load value first
                if (semInfo.has_memory_src && semInfo.src_width != 0) {
                    unsigned readWidth = semInfo.src_width;
                    auto readTy = builder.getIntegerType(readWidth);
                    auto memRead = builder.create<helix::low::MemReadOp>(
                        loc, readTy,
                        ensureInt64(lhs, builder, loc, &regs, &pcTracker),
                        builder.getUI32IntegerAttr(readWidth),
                        addrAttr);
                    lhs = memRead.getResult();
                }

                // ─── Idiom: TEST reg, reg → CMP reg, 0 ─────────────────
                // When both operands are the same register, TEST reg, reg
                // is equivalent to comparing reg against zero. Convert to
                // helix_low.cmp reg, 0 so downstream passes can emit
                // `if (var == 0)` / `if (var != 0)` directly.
                if (isSameRegisterOperand(lhs, rhs, regs)) {
                    auto zero = builder.create<LLVM::ConstantOp>(
                        loc, i64Ty, builder.getI64IntegerAttr(0));
                    auto cmpOp = builder.create<helix::low::CmpOp>(
                        loc,
                        /*carry_flag=*/i1Ty,
                        /*zero_flag=*/i1Ty,
                        /*sign_flag=*/i1Ty,
                        /*overflow_flag=*/i1Ty,
                        ensureInt64(lhs, builder, loc, &regs, &pcTracker),
                        zero,
                        addrAttr);

                    builder.create<helix::low::RegWriteOp>(loc, cmpOp.getCarryFlag(), builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                    builder.create<helix::low::RegWriteOp>(loc, cmpOp.getZeroFlag(), builder.getStringAttr("ZF"), builder.getUI32IntegerAttr(1), addrAttr);
                    builder.create<helix::low::RegWriteOp>(loc, cmpOp.getSignFlag(), builder.getStringAttr("SF"), builder.getUI32IntegerAttr(1), addrAttr);
                    builder.create<helix::low::RegWriteOp>(loc, cmpOp.getOverflowFlag(), builder.getStringAttr("OF"), builder.getUI32IntegerAttr(1), addrAttr);
                } else {
                    auto testOp = builder.create<helix::low::TestOp>(
                        loc,
                        /*zero_flag=*/i1Ty,
                        /*sign_flag=*/i1Ty,
                        ensureInt64(lhs, builder, loc, &regs, &pcTracker),
                        ensureInt64(rhs, builder, loc, &regs, &pcTracker),
                        addrAttr);

                    builder.create<helix::low::RegWriteOp>(loc, testOp.getZeroFlag(), builder.getStringAttr("ZF"), builder.getUI32IntegerAttr(1), addrAttr);
                    builder.create<helix::low::RegWriteOp>(loc, testOp.getSignFlag(), builder.getStringAttr("SF"), builder.getUI32IntegerAttr(1), addrAttr);
                }
            }
            break;
        }

        // ─── Data Movement ───────────────────────────────────────────────
        case RemillSemantic::MOV: {
            // Remill MOV semantic: call @MOV(mem, state, dst_reg_ptr, src_value)
            // Operand layout: [0]=memory, [1]=state, [2]=dest_reg_ptr, [3]=value
            // Use safeGetOperand for variable argument layouts.
            if (call.getNumOperands() >= 3) {
                auto destRegPtr = safeGetOperand(call, 2, builder, loc);
                auto srcValue = safeGetOperand(call, 3, builder, loc);

                // ─── Idiom: MOV reg, reg → eliminated (no-op) ───────────
                // When source and destination are the same register, the MOV
                // has no effect. Skip emitting any operation.
                auto destRegName = regs.getRegName(destRegPtr);
                if (destRegName) {
                    // Check if srcValue comes from a load of the same register.
                    if (auto srcLoad = srcValue.getDefiningOp<LLVM::LoadOp>()) {
                        auto srcRegName = regs.getRegName(srcLoad.getAddr());
                        if (srcRegName && *srcRegName == *destRegName) {
                            // MOV reg, reg — eliminate as no-op.
                            break;
                        }
                    }
                    // Also check if srcValue is a GEP to the same register
                    // (pointer-level identity).
                    if (isSameRegisterOperand(destRegPtr, srcValue, regs)) {
                        break;
                    }
                }

                // Try to resolve the destination register name from the GEP pointer.
                if (destRegName) {
                    unsigned width = RegisterTracker::inferRegWidth(*destRegName);
                    auto intTy = builder.getIntegerType(width);
                    Value finalVal = srcValue;

                    // ─── Memory source: MOV reg, [mem] ──────────────────
                    // When the source is a memory operand (Mn), srcValue is
                    // an ADDRESS.  Emit MemReadOp to load the actual value.
                    if (semInfo.has_memory_src) {
                        unsigned readWidth = semInfo.src_width;
                        auto readTy = builder.getIntegerType(readWidth);

                        // ─── Segment-relative: MOV reg, gs:[N] / fs:[N] ─
                        // Emit `__readgsqword(N)` etc. instead of a raw
                        // MemRead — otherwise GSBASE gets DCE'd to 0 and the
                        // C output reads `*(0 + N)`, losing the segment.
                        if (auto seg = matchSegmentRelativeAddr(srcValue)) {
                            auto offsetCst = builder.create<LLVM::ConstantOp>(
                                loc, i64Ty,
                                builder.getI64IntegerAttr(seg->second));
                            auto machineTy = machineIntTy(builder);
                            auto zeroTarget = builder.create<LLVM::ConstantOp>(
                                loc, machineTy,
                                builder.getI64IntegerAttr(0));
                            auto intrinsic = segmentIntrinsicName(
                                seg->first, readWidth, /*isRead=*/true);
                            auto segCall = builder.create<helix::low::CallOp>(
                                loc,
                                /*resultTypes=*/TypeRange{readTy},
                                zeroTarget.getResult(),
                                ValueRange{offsetCst.getResult()},
                                builder.getStringAttr(intrinsic),
                                addrAttr);
                            finalVal = segCall.getResult();
                        } else {
                            auto memRead = builder.create<helix::low::MemReadOp>(
                                loc,
                                readTy,
                                ensureInt64(srcValue, builder, loc, &regs, &pcTracker),
                                builder.getUI32IntegerAttr(readWidth),
                                addrAttr);
                            finalVal = memRead.getResult();
                        }
                        // Extend to register width if needed (e.g., 32→64 for MOV EAX, [mem]).
                        if (readWidth < width) {
                            finalVal = builder.create<LLVM::ZExtOp>(loc, intTy, finalVal);
                        } else if (readWidth > width) {
                            finalVal = builder.create<LLVM::TruncOp>(loc, intTy, finalVal);
                        }
                    } else if (isa<LLVM::LLVMPointerType>(finalVal.getType())) {
                        finalVal = builder.create<LLVM::PtrToIntOp>(loc, intTy, finalVal);
                    }

                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        finalVal,
                        builder.getStringAttr(*destRegName),
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                } else {
                    // Destination is a memory address (e.g., MOV [rcx+0x14], eax).
                    // Emit as MemWriteOp — this is a side-effecting store that
                    // must be preserved (not a dead register write).
                    Value finalVal = srcValue;
                    unsigned writeWidth = inferStoreValueWidth(srcValue, regs);
                    if (semInfo.has_memory_dst && semInfo.src_width != 0)
                        writeWidth = std::min(writeWidth, semInfo.src_width);
                    auto writeTy = builder.getIntegerType(writeWidth);

                    if (isa<LLVM::LLVMPointerType>(finalVal.getType())) {
                        finalVal = builder.create<LLVM::PtrToIntOp>(
                            loc, writeTy, finalVal);
                    } else if (auto intTy = dyn_cast<IntegerType>(finalVal.getType())) {
                        if (intTy.getWidth() > writeWidth) {
                            finalVal = builder.create<LLVM::TruncOp>(
                                loc, writeTy, finalVal);
                        } else if (intTy.getWidth() < writeWidth) {
                            finalVal = builder.create<LLVM::ZExtOp>(
                                loc, writeTy, finalVal);
                        }
                    }

                    // ─── Segment-relative: MOV gs:[N], reg / fs:[N], reg ─
                    // Symmetric with the load path above — emit
                    // `__writegsqword(N, value)` instead of MemWrite(0+N).
                    if (auto seg = matchSegmentRelativeAddr(destRegPtr)) {
                        auto offsetCst = builder.create<LLVM::ConstantOp>(
                            loc, i64Ty,
                            builder.getI64IntegerAttr(seg->second));
                        auto machineTy = machineIntTy(builder);
                        auto zeroTarget = builder.create<LLVM::ConstantOp>(
                            loc, machineTy,
                            builder.getI64IntegerAttr(0));
                        auto intrinsic = segmentIntrinsicName(
                            seg->first, writeWidth, /*isRead=*/false);
                        builder.create<helix::low::CallOp>(
                            loc,
                            /*resultTypes=*/TypeRange{},
                            zeroTarget.getResult(),
                            ValueRange{offsetCst.getResult(), finalVal},
                            builder.getStringAttr(intrinsic),
                            addrAttr);
                    } else {
                        builder.create<helix::low::MemWriteOp>(
                            loc,
                            ensureInt64(destRegPtr, builder, loc, &regs, &pcTracker),
                            finalVal,
                            builder.getUI32IntegerAttr(writeWidth),
                            addrAttr);
                    }
                }
            }
            break;
        }

        case RemillSemantic::MOVZX: {
            if (call.getNumOperands() >= 3) {
                auto destRegPtr = safeGetOperand(call, 2, builder, loc);
                auto destRegName = regs.getRegName(destRegPtr);

                if (semInfo.has_memory_src && semInfo.src_width != 0 &&
                    call.getNumOperands() >= 4) {
                    // ─── Memory source: MOVZX reg, [mem] ──────────────
                    // Full lift: MemRead(address) → MovZx(narrow→64) →
                    // RegWrite(destReg). Without the RegWrite the chain
                    // is dead and DCE drops the byte/word load, which is
                    // how rt_fnv's loop body lost its `*s++` reload.
                    auto addrValue = safeGetOperand(call, 3, builder, loc);
                    unsigned readWidth = semInfo.src_width;
                    auto readTy = builder.getIntegerType(readWidth);
                    auto memRead = builder.create<helix::low::MemReadOp>(
                        loc, readTy,
                        ensureInt64(addrValue, builder, loc, &regs, &pcTracker),
                        builder.getUI32IntegerAttr(readWidth),
                        addrAttr);
                    auto movZx = builder.create<helix::low::MovZxOp>(
                        loc, i64Ty, memRead.getResult(),
                        builder.getUI32IntegerAttr(64),
                        addrAttr);
                    if (destRegName) {
                        unsigned destWidth =
                            RegisterTracker::inferRegWidth(*destRegName);
                        Value finalVal = movZx.getResult();
                        if (destWidth < 64) {
                            finalVal = builder.create<LLVM::TruncOp>(
                                loc,
                                builder.getIntegerType(destWidth),
                                finalVal);
                        }
                        builder.create<helix::low::RegWriteOp>(
                            loc, finalVal,
                            builder.getStringAttr(*destRegName),
                            builder.getUI32IntegerAttr(destWidth),
                            addrAttr);
                    }
                } else {
                    // ─── Register source: MOVZX reg, reg ─────────────
                    // Preserved historical (dead-chain) behaviour: the
                    // register-source form passes the value at
                    // operand(3) but the lifter used the dest_ptr at
                    // operand(2), so the MovZxOp's result is unused and
                    // DCE removes it. Touching this would require
                    // exposing the source width through the demangler;
                    // tracked as a follow-up so this commit's blast
                    // radius is limited to the memory-source path.
                    Value operand = call.getOperand(2);
                    if (isa<LLVM::LLVMPointerType>(operand.getType())) {
                        operand = builder.create<LLVM::PtrToIntOp>(
                            loc, builder.getI64Type(), operand);
                    }
                    builder.create<helix::low::MovZxOp>(
                        loc, i64Ty, operand,
                        builder.getUI32IntegerAttr(64),
                        addrAttr);
                }
            }
            break;
        }

        case RemillSemantic::MOVSX:
        case RemillSemantic::CDQE:
        case RemillSemantic::CDQ: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::MovSxOp>(
                    loc,
                    i64Ty,
                    ensureInt64(call.getOperand(2), builder, loc, &regs, &pcTracker),
                    builder.getUI32IntegerAttr(64),
                    addrAttr);
            }
            break;
        }

        // ─── Stack Operations ────────────────────────────────────────────
        case RemillSemantic::PUSH: {
            if (call.getNumOperands() >= 3) {
                auto pushOp = builder.create<helix::low::PushOp>(
                    loc,
                    call.getOperand(2),  // value to push
                    addrAttr);

                // ─── Mark callee-saved register pushes ──────────────────
                // Trace the pushed value back to a RegReadOp to determine
                // which register is being saved. If it's a Win64 callee-saved
                // register, mark the operation for later removal by DCE.
                Value pushed = call.getOperand(2);
                if (auto readOp = pushed.getDefiningOp<helix::low::RegReadOp>()) {
                    auto regName = readOp.getRegName();
                    if (isCalleeSavedRegister(regName)) {
                        pushOp->setAttr("is_callee_save_push",
                                        builder.getUnitAttr());
                        pushOp->setAttr("callee_save_reg",
                                        builder.getStringAttr(regName));
                    }
                } else {
                    // Also check if the operand is a GEP-tracked register
                    auto regName = regs.getRegName(pushed);
                    if (regName && isCalleeSavedRegister(*regName)) {
                        pushOp->setAttr("is_callee_save_push",
                                        builder.getUnitAttr());
                        pushOp->setAttr("callee_save_reg",
                                        builder.getStringAttr(*regName));
                    }
                }
            }
            break;
        }

        case RemillSemantic::POP: {
            auto popOp = builder.create<helix::low::PopOp>(
                loc,
                i64Ty,
                addrAttr);

            // ─── Mark callee-saved register pops ────────────────────────
            // The POP result is typically consumed by a RegWriteOp that
            // restores a callee-saved register. We check the destination
            // register from the Remill call operands (dest_reg_ptr at index 2).
            if (call.getNumOperands() >= 3) {
                auto destRegPtr = call.getOperand(2);
                auto regName = regs.getRegName(destRegPtr);
                if (regName && isCalleeSavedRegister(*regName)) {
                    popOp->setAttr("is_callee_save_pop",
                                   builder.getUnitAttr());
                    popOp->setAttr("callee_save_reg",
                                   builder.getStringAttr(*regName));
                }
            }
            break;
        }

        // ─── Control Flow ────────────────────────────────────────────────
        case RemillSemantic::CALL: {
            if (call.getNumOperands() >= 3) {
                auto targetVal = call.getOperand(2);
                StringAttr targetName;

                // Try to extract a constant target address from the operand.
                uint64_t targetAddr = 0;
                bool addrResolved = false;

                if (auto evaluated = pcTracker.tryEvaluate(targetVal, regs)) {
                    targetAddr = static_cast<uint64_t>(*evaluated);
                    addrResolved = true;
                }

                // Remill direct calls also carry NEXT_PC as operand 4:
                //   CALLI(..., target_addr, NEXT_PC_ptr, next_pc, RETURN_PC_ptr)
                // If the full target expression did not fold cleanly, recover
                // the common rel32 shape from `next_pc +/- imm32`.
                auto tryResolveRelativeTargetFromNextPc =
                    [&](Value nextPcVal) -> std::optional<uint64_t> {
                    auto nextPc = pcTracker.tryEvaluate(nextPcVal, regs);
                    if (!nextPc)
                        return std::nullopt;

                    if (auto add = targetVal.getDefiningOp<LLVM::AddOp>()) {
                        if (add.getLhs() == nextPcVal) {
                            if (auto disp =
                                    pcTracker.tryEvaluate(add.getRhs(), regs)) {
                                return static_cast<uint64_t>(*nextPc + *disp);
                            }
                        }
                        if (add.getRhs() == nextPcVal) {
                            if (auto disp =
                                    pcTracker.tryEvaluate(add.getLhs(), regs)) {
                                return static_cast<uint64_t>(*nextPc + *disp);
                            }
                        }
                    }

                    if (auto sub = targetVal.getDefiningOp<LLVM::SubOp>()) {
                        if (sub.getLhs() == nextPcVal) {
                            if (auto disp =
                                    pcTracker.tryEvaluate(sub.getRhs(), regs)) {
                                return static_cast<uint64_t>(*nextPc - *disp);
                            }
                        }
                    }

                    return std::nullopt;
                };

                if (!addrResolved && call.getNumOperands() >= 5) {
                    if (auto relTarget =
                            tryResolveRelativeTargetFromNextPc(call.getOperand(4))) {
                        targetAddr = *relTarget;
                        addrResolved = true;
                    }
                }

                // Final fallback for direct rel32 calls: use the current call
                // site address plus the 5-byte CALL length when the target is
                // still shaped as `next_pc +/- displacement`.
                if (!addrResolved && addrAttr) {
                    auto inferDisp = [&](Value value) -> std::optional<int64_t> {
                        if (auto add = value.getDefiningOp<LLVM::AddOp>()) {
                            if (auto rhs = pcTracker.tryEvaluate(add.getRhs(), regs))
                                return rhs;
                            if (auto lhs = pcTracker.tryEvaluate(add.getLhs(), regs))
                                return lhs;
                        }
                        if (auto sub = value.getDefiningOp<LLVM::SubOp>()) {
                            if (auto rhs = pcTracker.tryEvaluate(sub.getRhs(), regs))
                                return -*rhs;
                        }
                        return std::nullopt;
                    };

                    if (auto disp = inferDisp(targetVal)) {
                        auto nextPcGuess =
                            static_cast<int64_t>(addrAttr.getValue().getZExtValue()) + 5;
                        // Bias toward true rel32 displacements, not tiny
                        // arithmetic noise that belongs to indirect calls.
                        if (std::llabs(*disp) >= 0x100) {
                            targetAddr = static_cast<uint64_t>(nextPcGuess + *disp);
                            addrResolved = true;
                        }
                    }
                }

                // If we resolved an address, format as sub_<hex>.
                if (addrResolved) {
                    auto name = std::format("sub_{:x}", targetAddr);
                    targetName = builder.getStringAttr(name);
                }

                // If the address wasn't resolved, try to extract a symbol
                // name from llvm.mlir.addressof.  This covers the Remill
                // pattern for external calls in ET_REL (.ko) files where
                // the target operand is `ptrtoint(@symbol_name)`.
                // The chain is: addressof @sym → ptrtoint → CALL operand.
                if (!targetName) {
                    Value lookThrough = targetVal;
                    // Look through ptrtoint wrapper
                    if (auto ptrToInt = lookThrough.getDefiningOp<LLVM::PtrToIntOp>())
                        lookThrough = ptrToInt.getArg();

                    if (auto addressOf = lookThrough.getDefiningOp<LLVM::AddressOfOp>()) {
                        auto symName = addressOf.getGlobalName();
                        if (!symName.starts_with("__remill_") &&
                            !symName.starts_with("llvm.") &&
                            !symName.starts_with("_ZN")) {
                            targetName = builder.getStringAttr(symName);
                            llvm::errs() << "[P0-DEBUG] CALL addressof resolved: "
                                         << symName << "\n";
                        }
                    }
                }

                if (!targetName) {
                    call->emitRemark("unresolved call target address");
                }

                // Recover calling-convention register arguments across the
                // current block boundary. Uses Win64 or SysV ABI depending
                // on the module's target triple.
                auto callArgs = collectCallArgs(call.getOperation());

                // Use the call target's operand type as the result type —
                // i32 on x86 (i386), i64 on x86-64.  Hard-coding i64 here
                // sign-extended x86 call addresses into 64-bit names.
                auto resultTy = targetVal.getType();
                if (!isa<IntegerType>(resultTy))
                    resultTy = machineIntTy(builder);
                unsigned resultBits =
                    cast<IntegerType>(resultTy).getWidth();

                // ── Wave 22 Step 2 — zeroed-fmt variadic detection (semantic) ──
                if (targetName) {
                    auto calleeName = targetName.getValue();
                    if (auto fmtSlot = getVariadicFmtSlot(calleeName)) {
                        if (*fmtSlot < callArgs.size() &&
                            isLiteralZero(callArgs[*fmtSlot])) {
                            auto bundleType =
                                helix::low::BundleType::get(
                                    builder.getContext());
                            auto bundleOp =
                                builder.create<helix::low::BundleCreateOp>(
                                    loc, bundleType,
                                    helix::low::BundleState::Zeroed,
                                    builder.getStringAttr(
                                        "upstream_zeroed_before_helix"));
                            auto vCall =
                                builder.create<helix::low::VariadicCallOp>(
                                    loc, /*resultTypes=*/TypeRange{resultTy},
                                    targetVal, callArgs, bundleOp.getBundle(),
                                    targetName, addrAttr);
                            builder.create<helix::low::RegWriteOp>(
                                loc, vCall.getResult(),
                                builder.getStringAttr("RAX"),
                                builder.getUI32IntegerAttr(resultBits),
                                addrAttr);
                            llvm::errs()
                                << "[P0-DEBUG] Variadic call (zeroed fmt)"
                                << " [semantic]: name=" << calleeName
                                << " fmtSlot=" << *fmtSlot
                                << " nArgs=" << callArgs.size() << "\n";
                            break;  // exit the RemillSemantic::CALL case
                        }
                    }
                }

                auto newCallOp = builder.create<helix::low::CallOp>(
                    loc,
                    /*resultTypes=*/TypeRange{resultTy},
                    targetVal,
                    callArgs,
                    targetName,
                    addrAttr);

                // Materialize RAX def after the call so that subsequent
                // reg.read RAX in the caller picks up a distinct SSA version
                // (the callee's return value).  Without this, the caller's
                // pre-call RAX flows through unchanged, `if (result == 0)`
                // becomes a tautology, and StructureControlFlow prunes the
                // "else" branch — hiding up to half the lifted logic.
                builder.create<helix::low::RegWriteOp>(
                    loc,
                    newCallOp.getResult(),
                    builder.getStringAttr("RAX"),
                    builder.getUI32IntegerAttr(resultBits),
                    addrAttr);

                llvm::errs() << "[P0-DEBUG] CALL semantic: created CallOp"
                             << " target=" << (targetName ? targetName.getValue() : "none")
                             << " addr=" << (addrAttr ? std::to_string(addrAttr.getValue().getZExtValue()) : "null")
                             << " resolved=" << addrResolved
                             << " nArgs=" << callArgs.size()
                             << "\n";
            }
            break;
        }

        case RemillSemantic::RET: {
            deferredTerminator = [loc](OpBuilder& b, IntegerAttr addr) {
                b.create<helix::low::RetOp>(loc, addr);
            };
            break;
        }

        case RemillSemantic::JMP: {
            // Remill JMP semantic:
            //   call @JMP(mem, state, target_addr, NEXT_PC_ptr)
            // Operands: [0]=mem, [1]=state, [2]=target, [3]=next_pc_ptr
            //
            // When the target folds to a constant, the JMP is almost always
            // a tail call to another function (MSVC/GCC emit `jmp target`
            // after stack teardown to hand off control).  Intra-function
            // direct branches are lifted by Remill as plain `br label %bb_X`
            // and never reach this case with a constant operand.
            //
            // Tail-call lowering: emit low.call + deferred low.ret so the
            // structurer and emitter see a real call site instead of an
            // opaque jump into the dummy block (which collapses to a stub).
            if (call.getNumOperands() >= 3) {
                Value targetVal = call.getOperand(2);
                uint64_t targetAddr = 0;
                bool addrResolved = false;

                // Tail-call detection is INTENTIONALLY conservative here:
                // we only treat the JMP as a tail call when the operand is
                // a *direct* constant (Remill's shape for `jmp <abs_addr>`
                // / `jmp rel32`).  Computed operands like `add %pc, 22`
                // that happen to fold through PCTracker are almost always
                // intra-function branches, jump-table dispatches, or
                // indirect tail calls — lifting them as ret-terminated
                // tail calls truncates the function and kills downstream
                // code (observed as 90+ calls vanishing in kernel code).
                if (auto constOp =
                        targetVal.getDefiningOp<LLVM::ConstantOp>()) {
                    if (auto intAttr =
                            dyn_cast<IntegerAttr>(constOp.getValue())) {
                        targetAddr = intAttr.getValue().getZExtValue();
                        addrResolved = true;
                    }
                } else if (auto arithConst =
                        targetVal.getDefiningOp<arith::ConstantOp>()) {
                    if (auto intAttr =
                            dyn_cast<IntegerAttr>(arithConst.getValue())) {
                        targetAddr = intAttr.getValue().getZExtValue();
                        addrResolved = true;
                    }
                }

                if (addrResolved) {
                    StringAttr targetName =
                        builder.getStringAttr(std::format("sub_{:x}", targetAddr));

                    auto callArgs = collectCallArgs(call.getOperation());
                    auto resultTy = targetVal.getType();
                    if (!isa<IntegerType>(resultTy))
                        resultTy = machineIntTy(builder);
                    unsigned resultBits =
                        cast<IntegerType>(resultTy).getWidth();

                    auto tailCallOp = builder.create<helix::low::CallOp>(
                        loc,
                        /*resultTypes=*/TypeRange{resultTy},
                        targetVal,
                        callArgs,
                        targetName,
                        addrAttr);
                    tailCallOp->setAttr("is_tail_call", builder.getUnitAttr());

                    // Materialize RAX def with the call's result (same
                    // rationale as the CALL case).
                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        tailCallOp.getResult(),
                        builder.getStringAttr("RAX"),
                        builder.getUI32IntegerAttr(resultBits),
                        addrAttr);

                    deferredTerminator = [loc](OpBuilder& b, IntegerAttr addr) {
                        b.create<helix::low::RetOp>(loc, addr);
                    };

                    llvm::errs() << "[P0-DEBUG] JMP semantic: tail-call to "
                                 << targetName.getValue()
                                 << " nArgs=" << callArgs.size() << "\n";
                } else {
                    // Indirect jump (jump table, computed goto, indirect tail
                    // call).  Keep as JmpOp; RecoverSwitchTables / downstream
                    // passes will try to resolve the real target.
                    deferredTerminator = [loc, dummyBlock](OpBuilder& b, IntegerAttr addr) {
                        b.create<helix::low::JmpOp>(
                            loc,
                            /*target_addr=*/IntegerAttr{},
                            /*address=*/addr,
                            /*dest=*/dummyBlock);
                    };
                }
            }
            break;
        }

        // ─── Conditional Jumps ───────────────────────────────────────────
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
        case RemillSemantic::JNP: {
            auto condStr = getJccCondition(semantic);
            if (!condStr || call.getNumOperands() < 5)
                break;

            // ── Synthesize real condition from preceding CMP/TEST flags ──
            //
            // Scan backwards in the current block to find the most recent
            // RegWriteOp to the flag register(s) needed by this Jcc.
            // These writes were emitted by the CMP/TEST handler above.
            //
            // Flag requirements:
            //   JZ/JNZ    → ZF
            //   JB/JNB    → CF
            //   JS/JNS    → SF
            //   JO/JNO    → OF
            //   JL/JNL    → SF, OF (SF != OF)
            //   JLE/JNLE  → ZF, SF, OF (ZF || SF != OF)
            //   JBE/JNBE  → CF, ZF (CF || ZF)
            //   JP/JNP    → PF (not tracked, use fallback)

            auto findFlagValue = [&](llvm::StringRef flagName) -> Value {
                Block* block = builder.getInsertionBlock();
                if (!block) return nullptr;

                // Step 1: Search current block (fast path, covers 95%+ of cases)
                Value result = findFlagValueInBlock(
                    block, builder.getInsertionPoint(), flagName);
                if (result) return result;

                // Step 2: Search predecessor blocks (handles cross-block CMP→JCC)
                llvm::DenseSet<Block*> visiting;
                return findFlagValueInPredecessors(
                    block, flagName, /*depth=*/3, visiting);
            };

            Value condValue = nullptr;

            switch (semantic) {
            case RemillSemantic::JZ: {
                condValue = findFlagValue("ZF");
                break;
            }
            case RemillSemantic::JNZ: {
                Value zf = findFlagValue("ZF");
                if (zf) {
                    // JNZ = !ZF → XOR ZF, 1
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    condValue = builder.create<arith::XOrIOp>(
                        loc, zf, one).getResult();
                }
                break;
            }
            case RemillSemantic::JB: {
                condValue = findFlagValue("CF");
                break;
            }
            case RemillSemantic::JNB: {
                Value cf = findFlagValue("CF");
                if (cf) {
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    condValue = builder.create<arith::XOrIOp>(
                        loc, cf, one).getResult();
                }
                break;
            }
            case RemillSemantic::JS: {
                condValue = findFlagValue("SF");
                break;
            }
            case RemillSemantic::JNS: {
                Value sf = findFlagValue("SF");
                if (sf) {
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    condValue = builder.create<arith::XOrIOp>(
                        loc, sf, one).getResult();
                }
                break;
            }
            case RemillSemantic::JO: {
                condValue = findFlagValue("OF");
                break;
            }
            case RemillSemantic::JNO: {
                Value of = findFlagValue("OF");
                if (of) {
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    condValue = builder.create<arith::XOrIOp>(
                        loc, of, one).getResult();
                }
                break;
            }
            case RemillSemantic::JL: {
                // JL: SF != OF
                Value sf = findFlagValue("SF");
                Value of = findFlagValue("OF");
                if (sf && of) {
                    condValue = builder.create<arith::XOrIOp>(
                        loc, sf, of).getResult();
                }
                break;
            }
            case RemillSemantic::JNL: {
                // JNL (JGE): SF == OF → !(SF XOR OF)
                Value sf = findFlagValue("SF");
                Value of = findFlagValue("OF");
                if (sf && of) {
                    auto xorVal = builder.create<arith::XOrIOp>(loc, sf, of);
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    condValue = builder.create<arith::XOrIOp>(
                        loc, xorVal, one).getResult();
                }
                break;
            }
            case RemillSemantic::JLE: {
                // JLE: ZF || (SF != OF)
                Value zf = findFlagValue("ZF");
                Value sf = findFlagValue("SF");
                Value of = findFlagValue("OF");
                if (zf && sf && of) {
                    auto sfNeOf = builder.create<arith::XOrIOp>(loc, sf, of);
                    condValue = builder.create<arith::OrIOp>(
                        loc, zf, sfNeOf).getResult();
                }
                break;
            }
            case RemillSemantic::JNLE: {
                // JNLE (JG): !ZF && (SF == OF)
                Value zf = findFlagValue("ZF");
                Value sf = findFlagValue("SF");
                Value of = findFlagValue("OF");
                if (zf && sf && of) {
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    auto notZf = builder.create<arith::XOrIOp>(loc, zf, one);
                    auto sfEqOf = builder.create<arith::XOrIOp>(loc, sf, of);
                    auto notSfNeOf = builder.create<arith::XOrIOp>(loc, sfEqOf, one);
                    condValue = builder.create<arith::AndIOp>(
                        loc, notZf, notSfNeOf).getResult();
                }
                break;
            }
            case RemillSemantic::JBE: {
                // JBE: CF || ZF
                Value cf = findFlagValue("CF");
                Value zf = findFlagValue("ZF");
                if (cf && zf) {
                    condValue = builder.create<arith::OrIOp>(
                        loc, cf, zf).getResult();
                }
                break;
            }
            case RemillSemantic::JNBE: {
                // JNBE (JA): !CF && !ZF
                Value cf = findFlagValue("CF");
                Value zf = findFlagValue("ZF");
                if (cf && zf) {
                    auto one = builder.create<arith::ConstantOp>(
                        loc, i1Ty, builder.getBoolAttr(true));
                    auto notCf = builder.create<arith::XOrIOp>(loc, cf, one);
                    auto notZf = builder.create<arith::XOrIOp>(loc, zf, one);
                    condValue = builder.create<arith::AndIOp>(
                        loc, notCf, notZf).getResult();
                }
                break;
            }
            case RemillSemantic::JP: {
                // PF: even parity of low byte of last arithmetic result.
                // Find the most recent flag-producing op and compute PF.
                auto* producer = findFlagProducerInBlock(
                    builder.getInsertionBlock(), builder.getInsertionPoint());
                if (producer) {
                    Value resultVal = nullptr;
                    if (auto binOp = dyn_cast<helix::low::BinOp>(producer)) {
                        resultVal = binOp.getResult();
                    } else if (auto cmpOp = dyn_cast<helix::low::CmpOp>(producer)) {
                        // CMP computes (lhs - rhs); PF is based on that result.
                        resultVal = builder.create<arith::SubIOp>(
                            loc, cmpOp.getLhs(), cmpOp.getRhs()).getResult();
                    } else if (auto testOp = dyn_cast<helix::low::TestOp>(producer)) {
                        // TEST computes (lhs & rhs); PF is based on that result.
                        resultVal = builder.create<arith::AndIOp>(
                            loc, testOp.getLhs(), testOp.getRhs()).getResult();
                    }
                    if (resultVal) {
                        // PF = !(popcount(low_byte) & 1)
                        auto i8Ty = builder.getIntegerType(8);
                        auto lowByte = builder.create<arith::TruncIOp>(
                            loc, i8Ty, resultVal);
                        // XOR-fold to single parity bit: b ^= b>>4; b ^= b>>2; b ^= b>>1; PF = !(b&1)
                        auto four = builder.create<arith::ConstantOp>(
                            loc, i8Ty, builder.getI8IntegerAttr(4));
                        auto shr4 = builder.create<arith::ShRUIOp>(loc, lowByte, four);
                        auto x1 = builder.create<arith::XOrIOp>(loc, lowByte, shr4);
                        auto two = builder.create<arith::ConstantOp>(
                            loc, i8Ty, builder.getI8IntegerAttr(2));
                        auto shr2 = builder.create<arith::ShRUIOp>(loc, x1, two);
                        auto x2 = builder.create<arith::XOrIOp>(loc, x1, shr2);
                        auto one8 = builder.create<arith::ConstantOp>(
                            loc, i8Ty, builder.getI8IntegerAttr(1));
                        auto shr1 = builder.create<arith::ShRUIOp>(loc, x2, one8);
                        auto x3 = builder.create<arith::XOrIOp>(loc, x2, shr1);
                        auto lsb = builder.create<arith::AndIOp>(loc, x3, one8);
                        auto zero8 = builder.create<arith::ConstantOp>(
                            loc, i8Ty, builder.getI8IntegerAttr(0));
                        // PF = (lsb == 0)  →  even parity
                        condValue = builder.create<arith::CmpIOp>(
                            loc, arith::CmpIPredicate::eq, lsb, zero8).getResult();
                    }
                }
                break;
            }
            case RemillSemantic::JNP: {
                // JNP = !PF (odd parity) — same as JP but negated.
                auto* producer = findFlagProducerInBlock(
                    builder.getInsertionBlock(), builder.getInsertionPoint());
                if (producer) {
                    Value resultVal = nullptr;
                    if (auto binOp = dyn_cast<helix::low::BinOp>(producer)) {
                        resultVal = binOp.getResult();
                    } else if (auto cmpOp = dyn_cast<helix::low::CmpOp>(producer)) {
                        resultVal = builder.create<arith::SubIOp>(
                            loc, cmpOp.getLhs(), cmpOp.getRhs()).getResult();
                    } else if (auto testOp = dyn_cast<helix::low::TestOp>(producer)) {
                        resultVal = builder.create<arith::AndIOp>(
                            loc, testOp.getLhs(), testOp.getRhs()).getResult();
                    }
                    if (resultVal) {
                        auto i8Ty = builder.getIntegerType(8);
                        auto lowByte = builder.create<arith::TruncIOp>(
                            loc, i8Ty, resultVal);
                        auto four = builder.create<arith::ConstantOp>(
                            loc, i8Ty, builder.getI8IntegerAttr(4));
                        auto shr4 = builder.create<arith::ShRUIOp>(loc, lowByte, four);
                        auto x1 = builder.create<arith::XOrIOp>(loc, lowByte, shr4);
                        auto two = builder.create<arith::ConstantOp>(
                            loc, i8Ty, builder.getI8IntegerAttr(2));
                        auto shr2 = builder.create<arith::ShRUIOp>(loc, x1, two);
                        auto x2 = builder.create<arith::XOrIOp>(loc, x1, shr2);
                        auto one8 = builder.create<arith::ConstantOp>(
                            loc, i8Ty, builder.getI8IntegerAttr(1));
                        auto shr1 = builder.create<arith::ShRUIOp>(loc, x2, one8);
                        auto x3 = builder.create<arith::XOrIOp>(loc, x2, shr1);
                        auto lsb = builder.create<arith::AndIOp>(loc, x3, one8);
                        auto zero8 = builder.create<arith::ConstantOp>(
                            loc, i8Ty, builder.getI8IntegerAttr(0));
                        // JNP = (lsb != 0)  →  odd parity
                        condValue = builder.create<arith::CmpIOp>(
                            loc, arith::CmpIPredicate::ne, lsb, zero8).getResult();
                    }
                }
                break;
            }
            default:
                break;
            }

            // Fallback: use constant true if flag not found.
            // Also attach a diagnostic attribute to the JccOp so downstream
            // passes and the emitter can detect and report this.
            bool flagSynthesisFailed = false;
            if (!condValue) {
                // Floating-point comparison patterns (UCOMISS/COMISS via Remill)
                // often fail flag synthesis because the flags are set by SSE
                // instructions rather than integer CMP/TEST. These are expected
                // failures — suppress the noisy warning for known FP-related
                // condition codes (b, nb, be, nbe, p, np).
                static const llvm::StringRef kFpConditions[] = {
                    "b", "nb", "be", "nbe", "p", "np"
                };
                bool isFpCondition = false;
                for (auto fc : kFpConditions) {
                    if (*condStr == fc) {
                        isFpCondition = true;
                        break;
                    }
                }
                if (!isFpCondition) {
                    llvm::errs() << "[Helix] WARNING: Flag synthesis failed for "
                                 << *condStr << " — no flag values found in block "
                                 << "or predecessors. Block has "
                                 << std::distance(builder.getInsertionBlock()->begin(),
                                                  builder.getInsertionBlock()->end())
                                 << " ops\n";
                }
                // For FP conditions, silence is intentional — these are
                // expected failures from SSE UCOMISS/COMISS lowering.
                condValue = builder.create<LLVM::ConstantOp>(
                    loc, i1Ty, builder.getBoolAttr(true)).getResult();
                flagSynthesisFailed = true;
            }

            // Resolve branch destinations from the LLVM br terminator.
            // The block's terminator is `br i1 true, label %taken, label %fallthrough`
            // which has the correct successor blocks even though the condition is wrong.
            Block* trueBlock = dummyBlock;
            Block* falseBlock = dummyBlock;
            Block* currentBlock = call->getBlock();
            if (currentBlock) {
                auto* term = currentBlock->getTerminator();
                if (term && term->getNumSuccessors() >= 2) {
                    trueBlock = term->getSuccessor(0);
                    falseBlock = term->getSuccessor(1);
                } else if (term && term->getNumSuccessors() == 1) {
                    // If canonicalized to a single-successor branch,
                    // the false block (fallthrough) is the NEXT block in layout order.
                    trueBlock = term->getSuccessor(0);
                    auto* parent = currentBlock->getParent();
                    if (parent) {
                        auto it = currentBlock->getIterator();
                        ++it;
                        if (it != parent->end()) {
                            falseBlock = &*it;
                        }
                    }
                }
            }

            deferredTerminator = [loc, condStr, condValue, trueBlock, falseBlock,
                                  flagSynthesisFailed](
                                     OpBuilder& b, IntegerAttr addr) {
                auto jcc = b.create<helix::low::JccOp>(
                    loc,
                    *condStr,             // condition code string
                    condValue,            // real flag condition (i1)
                    addr,                 // address
                    trueBlock,            // taken destination
                    falseBlock);          // fallthrough destination
                if (flagSynthesisFailed) {
                    jcc->setAttr("helix.flag_synthesis_failed",
                                 b.getUnitAttr());
                }
            };
            break;
        }

        // ─── Conditional Move ────────────────────────────────────────────
        case RemillSemantic::CMOV: {
            if (call.getNumOperands() >= 4) {
                // CMOV reads a flag and selects between two values.
                // We need the condition from the semantic name (e.g., "E", "NE").
                auto condStr = semInfo.raw_name.substr(4); // strip "CMOV"
                auto i1Val = builder.create<LLVM::ConstantOp>(
                    loc, i1Ty, builder.getBoolAttr(true));

                builder.create<helix::low::CMovOp>(
                    loc,
                    i64Ty,
                    builder.getStringAttr(condStr),
                    i1Val,
                    call.getOperand(2),
                    call.getOperand(3),
                    addrAttr);
            }
            break;
        }

        // ─── Exchange ────────────────────────────────────────────────────
        case RemillSemantic::XCHG: {
            builder.create<helix::low::XchgOp>(
                loc,
                builder.getStringAttr("reg_a"),
                builder.getStringAttr("reg_b"),
                builder.getUI32IntegerAttr(64),
                addrAttr);
            break;
        }

        // ─── Bit Manipulation ────────────────────────────────────────────
        case RemillSemantic::BSF: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Bsf,
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::BSR: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Bsr,
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::BSWAP: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Bswap,
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::NEG: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Neg,
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::NOT: {
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = call.getOperand(2);
                auto val = call.getOperand(3);
                auto unOp = builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Not,
                    ensureInt64(val, builder, loc, &regs, &pcTracker),
                    addrAttr);

                emitRegisterOrMemoryWrite(builder, loc, destRegPtr, val,
                                          unOp.getResult(), regs, addrAttr);
            }
            break;
        }

        case RemillSemantic::INC: {
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = call.getOperand(2);
                auto val = call.getOperand(3);
                auto unOp = builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Inc,
                    ensureInt64(val, builder, loc, &regs, &pcTracker),
                    addrAttr);

                emitRegisterOrMemoryWrite(builder, loc, destRegPtr, val,
                                          unOp.getResult(), regs, addrAttr);
                builder.create<helix::low::RegWriteOp>(
                    loc, unOp.getZeroFlag(), builder.getStringAttr("ZF"),
                    builder.getUI32IntegerAttr(1), addrAttr);
            }
            break;
        }

        case RemillSemantic::DEC: {
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = call.getOperand(2);
                auto val = call.getOperand(3);
                auto unOp = builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    helix::low::UnaryOpKind::Dec,
                    ensureInt64(val, builder, loc, &regs, &pcTracker),
                    addrAttr);

                emitRegisterOrMemoryWrite(builder, loc, destRegPtr, val,
                                          unOp.getResult(), regs, addrAttr);
                builder.create<helix::low::RegWriteOp>(
                    loc, unOp.getZeroFlag(), builder.getStringAttr("ZF"),
                    builder.getUI32IntegerAttr(1), addrAttr);
            }
            break;
        }

        // ─── REP String Operations ───────────────────────────────────────
        case RemillSemantic::REP_MOVS: {
            if (call.getNumOperands() >= 5) {
                builder.create<helix::low::RepMovsOp>(
                    loc,
                    call.getOperand(2),  // dst (RDI)
                    call.getOperand(3),  // src (RSI)
                    call.getOperand(4),  // count (RCX)
                    builder.getUI32IntegerAttr(8),  // byte width
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::REP_STOS: {
            if (call.getNumOperands() >= 5) {
                builder.create<helix::low::RepStosOp>(
                    loc,
                    call.getOperand(2),  // dst (RDI)
                    call.getOperand(3),  // value (AL/AX/EAX)
                    call.getOperand(4),  // count (RCX)
                    builder.getUI32IntegerAttr(8),
                    addrAttr);
            }
            break;
        }

        // ─── LEA (pure address computation) ──────────────────────────────
        case RemillSemantic::LEA: {
            // LEA is a pure address computation, not a memory access.
            // In Remill IR it computes base + index*scale + disp.
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = safeGetOperand(call, 2, builder, loc);
                auto effectiveAddr =
                    ensureInt64(call.getOperand(3), builder, loc, &regs, &pcTracker);
                auto zero = builder.create<LLVM::ConstantOp>(
                    loc, i64Ty, builder.getI64IntegerAttr(0));
                auto signedI64Ty = IntegerType::get(builder.getContext(), 64, IntegerType::Signed);
                builder.create<helix::low::LeaOp>(
                    loc, i64Ty,
                    ensureInt64(call.getOperand(2), builder, loc, &regs, &pcTracker),   // base
                    ensureInt64(call.getOperand(3), builder, loc, &regs, &pcTracker),   // index
                    builder.getUI32IntegerAttr(1),  // scale
                    IntegerAttr::get(signedI64Ty, 0), // displacement
                    addrAttr);

                if (auto destRegName = regs.getRegName(destRegPtr)) {
                    llvm::StringRef canonical =
                        helix::analysis::getCanonicalX86Register(*destRegName);
                    if (canonical.empty())
                        canonical = *destRegName;

                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        effectiveAddr,
                        builder.getStringAttr(canonical),
                        builder.getUI32IntegerAttr(64),
                        addrAttr);
                }
            }
            break;
        }

        // ─── NOP / INT3 ─────────────────────────────────────────────────
        case RemillSemantic::NOP: {
            builder.create<helix::low::NopOp>(loc, addrAttr);
            break;
        }

        case RemillSemantic::INT3: {
            builder.create<helix::low::Int3Op>(loc, addrAttr);
            break;
        }

        // ─── Bit Test ────────────────────────────────────────────────────
        // BT/BTS/BTR/BTC: CF = (base >> (offset & 63)) & 1
        // BTS: result = base |  (1 << (offset & 63))
        // BTR: result = base & ~(1 << (offset & 63))
        // BTC: result = base ^  (1 << (offset & 63))
        case RemillSemantic::BT: {
            if (call.getNumOperands() >= 5) {
                auto base   = ensureInt64(call.getOperand(3), builder, loc, &regs, &pcTracker);
                auto offset = ensureInt64(call.getOperand(4), builder, loc, &regs, &pcTracker);
                // mask = 1 << (offset & 63)
                auto c63  = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(63));
                auto c1   = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(1));
                auto maskedOff = builder.create<arith::AndIOp>(loc, offset, c63).getResult();
                auto mask = builder.create<arith::ShLIOp>(loc, c1, maskedOff).getResult();
                // CF = (base & mask) != 0
                auto andVal = builder.create<arith::AndIOp>(loc, base, mask).getResult();
                auto zero64 = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(0));
                auto cf = builder.create<arith::CmpIOp>(
                    loc, arith::CmpIPredicate::ne, andVal, zero64).getResult();
                builder.create<helix::low::RegWriteOp>(loc, cf, builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
            }
            break;
        }

        case RemillSemantic::BTS: {
            if (call.getNumOperands() >= 5) {
                auto destRegPtr = call.getOperand(2);
                auto base   = ensureInt64(call.getOperand(3), builder, loc, &regs, &pcTracker);
                auto offset = ensureInt64(call.getOperand(4), builder, loc, &regs, &pcTracker);
                auto c63  = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(63));
                auto c1   = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(1));
                auto maskedOff = builder.create<arith::AndIOp>(loc, offset, c63).getResult();
                auto mask = builder.create<arith::ShLIOp>(loc, c1, maskedOff).getResult();
                // CF = (base & mask) != 0
                auto andVal = builder.create<arith::AndIOp>(loc, base, mask).getResult();
                auto zero64 = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(0));
                auto cf = builder.create<arith::CmpIOp>(
                    loc, arith::CmpIPredicate::ne, andVal, zero64).getResult();
                builder.create<helix::low::RegWriteOp>(loc, cf, builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                // result = base | mask
                auto result = builder.create<arith::OrIOp>(loc, base, mask).getResult();
                auto regName = regs.getRegName(destRegPtr);
                unsigned width = regName ? RegisterTracker::inferRegWidth(*regName) : 64;
                builder.create<helix::low::RegWriteOp>(
                    loc, result,
                    builder.getStringAttr(regName ? *regName : "unknown"),
                    builder.getUI32IntegerAttr(width), addrAttr);
            }
            break;
        }

        case RemillSemantic::BTR: {
            if (call.getNumOperands() >= 5) {
                auto destRegPtr = call.getOperand(2);
                auto base   = ensureInt64(call.getOperand(3), builder, loc, &regs, &pcTracker);
                auto offset = ensureInt64(call.getOperand(4), builder, loc, &regs, &pcTracker);
                auto c63  = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(63));
                auto c1   = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(1));
                auto maskedOff = builder.create<arith::AndIOp>(loc, offset, c63).getResult();
                auto mask = builder.create<arith::ShLIOp>(loc, c1, maskedOff).getResult();
                // CF = (base & mask) != 0
                auto andVal = builder.create<arith::AndIOp>(loc, base, mask).getResult();
                auto zero64 = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(0));
                auto cf = builder.create<arith::CmpIOp>(
                    loc, arith::CmpIPredicate::ne, andVal, zero64).getResult();
                builder.create<helix::low::RegWriteOp>(loc, cf, builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                // result = base & ~mask
                auto notMask = builder.create<arith::XOrIOp>(
                    loc, mask,
                    builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(-1)).getResult()
                ).getResult();
                auto result = builder.create<arith::AndIOp>(loc, base, notMask).getResult();
                auto regName = regs.getRegName(destRegPtr);
                unsigned width = regName ? RegisterTracker::inferRegWidth(*regName) : 64;
                builder.create<helix::low::RegWriteOp>(
                    loc, result,
                    builder.getStringAttr(regName ? *regName : "unknown"),
                    builder.getUI32IntegerAttr(width), addrAttr);
            }
            break;
        }

        case RemillSemantic::BTC: {
            if (call.getNumOperands() >= 5) {
                auto destRegPtr = call.getOperand(2);
                auto base   = ensureInt64(call.getOperand(3), builder, loc, &regs, &pcTracker);
                auto offset = ensureInt64(call.getOperand(4), builder, loc, &regs, &pcTracker);
                auto c63  = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(63));
                auto c1   = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(1));
                auto maskedOff = builder.create<arith::AndIOp>(loc, offset, c63).getResult();
                auto mask = builder.create<arith::ShLIOp>(loc, c1, maskedOff).getResult();
                // CF = (base & mask) != 0
                auto andVal = builder.create<arith::AndIOp>(loc, base, mask).getResult();
                auto zero64 = builder.create<LLVM::ConstantOp>(loc, i64Ty, builder.getI64IntegerAttr(0));
                auto cf = builder.create<arith::CmpIOp>(
                    loc, arith::CmpIPredicate::ne, andVal, zero64).getResult();
                builder.create<helix::low::RegWriteOp>(loc, cf, builder.getStringAttr("CF"), builder.getUI32IntegerAttr(1), addrAttr);
                // result = base ^ mask
                auto result = builder.create<arith::XOrIOp>(loc, base, mask).getResult();
                auto regName = regs.getRegName(destRegPtr);
                unsigned width = regName ? RegisterTracker::inferRegWidth(*regName) : 64;
                builder.create<helix::low::RegWriteOp>(
                    loc, result,
                    builder.getStringAttr(regName ? *regName : "unknown"),
                    builder.getUI32IntegerAttr(width), addrAttr);
            }
            break;
        }

        // ─── SSE/AVX packed operations ───────────────────────────────────
        // These operate on XMM registers (128-bit vectors). We emit them as
        // inline asm comments so the user can see what was there, then erase.
        case RemillSemantic::MOVxPS:
        case RemillSemantic::MOVSS_MEM:
        case RemillSemantic::MOVSS:
        case RemillSemantic::MOVSD:
        case RemillSemantic::MOVAPS:
        case RemillSemantic::MOVUPS:
        case RemillSemantic::SHUFPS:
        case RemillSemantic::SUBPS:
        case RemillSemantic::ADDPS:
        case RemillSemantic::MULPS:
        case RemillSemantic::ADDSS:
        case RemillSemantic::ADDSD:
        case RemillSemantic::MULSS:
        case RemillSemantic::MULSD:
        case RemillSemantic::SUBSS:
        case RemillSemantic::SUBSD:
        case RemillSemantic::DIVSS:
        case RemillSemantic::DIVSD:
        case RemillSemantic::XORPS:
        case RemillSemantic::XORPD:
        case RemillSemantic::PXOR:
        case RemillSemantic::COMISS:
        case RemillSemantic::UNPCKHPS: {
            // Emitting RegWriteOp for the operands keeps them alive for DCE
            // and allows the user to see the memory offsets in the AST.
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = call.getOperand(2);
                auto regName = regs.getRegName(destRegPtr);
                unsigned width = regName ? RegisterTracker::inferRegWidth(*regName) : 128;
                if (!regName) regName = "XMM0"; 
                
                // Prioritize finding an integer operand (usually the memory offset).
                // If not found, fall back to the first source operand.
                Value val = call.getOperand(3);
                for (unsigned idx = 3; idx < call.getNumOperands(); ++idx) {
                    if (call.getOperand(idx).getType().isInteger(64)) {
                        val = call.getOperand(idx);
                        break;
                    }
                }
                
                builder.create<helix::low::RegWriteOp>(
                    loc,
                    ensureInt64(val, builder, loc),
                    builder.getStringAttr(*regName),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
            }
            break;
        }

        // ─── PREFETCH ──────────────────────────────────────────────────────
        // Hint instruction with no semantic effect — just erase.
        case RemillSemantic::PREFETCH: {
            builder.create<helix::low::NopOp>(loc, addrAttr);
            break;
        }

        // ─── HandleUnsupported ─────────────────────────────────────────────
        // Remill catch-all for unlifted instructions — erase.
        case RemillSemantic::HANDLE_UNSUPPORTED: {
            builder.create<helix::low::NopOp>(loc, addrAttr);
            break;
        }

        // ─── CMPXCHG ──────────────────────────────────────────────────────
        case RemillSemantic::CMPXCHG: {
            if (call.getNumOperands() >= 3) {
                auto zero = builder.create<LLVM::ConstantOp>(
                    loc, i64Ty, builder.getI64IntegerAttr(0));
                builder.create<helix::low::CallOp>(
                    loc,
                    /*resultTypes=*/TypeRange{},
                    zero,
                    mlir::ValueRange{},
                    builder.getStringAttr("cmpxchg"),
                    addrAttr);
            }
            break;
        }

        // ─── SETcc ────────────────────────────────────────────────────────
        case RemillSemantic::SETcc: {
            // SETcc writes 1 or 0 to a byte register based on flags.
            // Reuse the same findFlagValue lambda built for Jcc above — it
            // searches backwards for the most recent RegWriteOp to the named
            // flag register (ZF, CF, SF, OF) emitted by a preceding CMP/TEST.
            if (call.getNumOperands() >= 3) {
                auto destRegPtr = call.getOperand(2);
                auto regName = regs.getRegName(destRegPtr);
                unsigned width = regName ? RegisterTracker::inferRegWidth(*regName) : 8;

                auto findFlagValueSET = [&](llvm::StringRef flagName) -> Value {
                    Block* block = builder.getInsertionBlock();
                    if (!block) return nullptr;
                    Value result = findFlagValueInBlock(
                        block, builder.getInsertionPoint(), flagName);
                    if (result) return result;
                    llvm::DenseSet<Block*> visiting;
                    return findFlagValueInPredecessors(
                        block, flagName, /*depth=*/3, visiting);
                };

                // Derive condition from raw_name (e.g. "SETE", "SETNE", "SETL").
                llvm::StringRef rn = semInfo.raw_name;
                // Strip leading "SET" prefix.
                llvm::StringRef cond = rn.starts_with("SET") ? rn.drop_front(3) : rn;

                Value condVal = nullptr;
                auto one = builder.create<arith::ConstantOp>(
                    loc, i1Ty, builder.getBoolAttr(true));

                if (cond == "E" || cond == "Z") {
                    condVal = findFlagValueSET("ZF");
                } else if (cond == "NE" || cond == "NZ") {
                    if (auto zf = findFlagValueSET("ZF"))
                        condVal = builder.create<arith::XOrIOp>(loc, zf, one).getResult();
                } else if (cond == "B" || cond == "C" || cond == "NAE") {
                    condVal = findFlagValueSET("CF");
                } else if (cond == "NB" || cond == "NC" || cond == "AE") {
                    if (auto cf = findFlagValueSET("CF"))
                        condVal = builder.create<arith::XOrIOp>(loc, cf, one).getResult();
                } else if (cond == "S") {
                    condVal = findFlagValueSET("SF");
                } else if (cond == "NS") {
                    if (auto sf = findFlagValueSET("SF"))
                        condVal = builder.create<arith::XOrIOp>(loc, sf, one).getResult();
                } else if (cond == "O") {
                    condVal = findFlagValueSET("OF");
                } else if (cond == "NO") {
                    if (auto of = findFlagValueSET("OF"))
                        condVal = builder.create<arith::XOrIOp>(loc, of, one).getResult();
                } else if (cond == "L" || cond == "NGE") {
                    // SF != OF
                    Value sf = findFlagValueSET("SF");
                    Value of = findFlagValueSET("OF");
                    if (sf && of)
                        condVal = builder.create<arith::XOrIOp>(loc, sf, of).getResult();
                } else if (cond == "NL" || cond == "GE") {
                    // !(SF != OF)
                    Value sf = findFlagValueSET("SF");
                    Value of = findFlagValueSET("OF");
                    if (sf && of) {
                        auto xorVal = builder.create<arith::XOrIOp>(loc, sf, of);
                        condVal = builder.create<arith::XOrIOp>(loc, xorVal, one).getResult();
                    }
                } else if (cond == "LE" || cond == "NG") {
                    // ZF || (SF != OF)
                    Value zf = findFlagValueSET("ZF");
                    Value sf = findFlagValueSET("SF");
                    Value of = findFlagValueSET("OF");
                    if (zf && sf && of) {
                        auto sfNeOf = builder.create<arith::XOrIOp>(loc, sf, of);
                        condVal = builder.create<arith::OrIOp>(loc, zf, sfNeOf).getResult();
                    }
                } else if (cond == "NLE" || cond == "G") {
                    // !ZF && (SF == OF)
                    Value zf = findFlagValueSET("ZF");
                    Value sf = findFlagValueSET("SF");
                    Value of = findFlagValueSET("OF");
                    if (zf && sf && of) {
                        auto notZf = builder.create<arith::XOrIOp>(loc, zf, one);
                        auto sfEqOf = builder.create<arith::XOrIOp>(loc, sf, of);
                        auto notSfNeOf = builder.create<arith::XOrIOp>(loc, sfEqOf, one);
                        condVal = builder.create<arith::AndIOp>(loc, notZf, notSfNeOf).getResult();
                    }
                } else if (cond == "BE" || cond == "NA") {
                    // CF || ZF
                    Value cf = findFlagValueSET("CF");
                    Value zf = findFlagValueSET("ZF");
                    if (cf && zf)
                        condVal = builder.create<arith::OrIOp>(loc, cf, zf).getResult();
                } else if (cond == "NBE" || cond == "A") {
                    // !CF && !ZF
                    Value cf = findFlagValueSET("CF");
                    Value zf = findFlagValueSET("ZF");
                    if (cf && zf) {
                        auto notCf = builder.create<arith::XOrIOp>(loc, cf, one);
                        auto notZf = builder.create<arith::XOrIOp>(loc, zf, one);
                        condVal = builder.create<arith::AndIOp>(loc, notCf, notZf).getResult();
                    }
                }

                // Extend i1 → target width; fall back to zero if flags unavailable.
                Value result;
                if (condVal) {
                    auto destTy = builder.getIntegerType(width);
                    result = builder.create<arith::ExtUIOp>(loc, destTy, condVal).getResult();
                } else {
                    result = builder.create<LLVM::ConstantOp>(
                        loc, builder.getIntegerType(width),
                        builder.getIntegerAttr(builder.getIntegerType(width), 0));
                }
                builder.create<helix::low::RegWriteOp>(
                    loc, result,
                    builder.getStringAttr(regName ? *regName : "unknown"),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
            }
            break;
        }

        // ─── CDQ_EAX / CDQE_EAX ──────────────────────────────────────────
        case RemillSemantic::CDQ_EAX:
        case RemillSemantic::CDQE_EAX: {
            // Sign-extension instructions. Treat like CDQ/CDQE.
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::MovSxOp>(
                    loc,
                    i64Ty,
                    ensureInt64(call.getOperand(2), builder, loc),
                    builder.getUI32IntegerAttr(64),
                    addrAttr);
            }
            break;
        }

        // ─── Unhandled / Future ──────────────────────────────────────────
        default:
            // Emit a warning for unhandled semantics so the user knows
            // something was skipped. Preserve the call as a generic call op
            // with ABI-correct arguments.
            call->emitWarning("unhandled Remill semantic: ")
                << semInfo.raw_name;
            {
                auto machineTy = machineIntTy(builder);
                auto zero = builder.create<LLVM::ConstantOp>(
                    loc, machineTy, builder.getI64IntegerAttr(0));
                auto callArgs = collectCallArgs(call.getOperation());
                auto unhandledCall = builder.create<helix::low::CallOp>(
                    loc,
                    /*resultTypes=*/TypeRange{machineTy},
                    zero,
                    callArgs,
                    builder.getStringAttr(semInfo.raw_name),
                    addrAttr);
                builder.create<helix::low::RegWriteOp>(
                    loc,
                    unhandledCall.getResult(),
                    builder.getStringAttr("RAX"),
                    builder.getUI32IntegerAttr(machineIntWidth_),
                    addrAttr);
            }
            break;
        }
    }

    /// Check if a register name is a Win64 callee-saved (non-volatile) register.
    /// Win64 ABI: RBX, RBP, RDI, RSI, R12, R13, R14, R15
    static bool isCalleeSavedRegister(llvm::StringRef regName) {
        static constexpr std::string_view kCalleeSaved[] = {
            "RBX", "RBP", "RDI", "RSI", "R12", "R13", "R14", "R15"
        };
        for (auto cs : kCalleeSaved) {
            if (regName == llvm::StringRef(cs.data(), cs.size()))
                return true;
        }
        return false;
    }

    /// Map a RemillSemantic to HelixLow BinOpKind.
    static std::optional<helix::low::BinOpKind>
    semanticToBinOpKind(RemillSemantic sem) {
        switch (sem) {
        case RemillSemantic::ADD:  return helix::low::BinOpKind::Add;
        case RemillSemantic::SUB:  return helix::low::BinOpKind::Sub;
        case RemillSemantic::MUL:  return helix::low::BinOpKind::Mul;
        case RemillSemantic::IMUL: return helix::low::BinOpKind::IMul;
        case RemillSemantic::DIV:  return helix::low::BinOpKind::Div;
        case RemillSemantic::IDIV: return helix::low::BinOpKind::IDiv;
        case RemillSemantic::AND:  return helix::low::BinOpKind::And;
        case RemillSemantic::OR:   return helix::low::BinOpKind::Or;
        case RemillSemantic::XOR:  return helix::low::BinOpKind::Xor;
        case RemillSemantic::SHL:  return helix::low::BinOpKind::Shl;
        case RemillSemantic::SHR:  return helix::low::BinOpKind::Shr;
        case RemillSemantic::SAR:  return helix::low::BinOpKind::Sar;
        case RemillSemantic::ROL:  return helix::low::BinOpKind::Rol;
        case RemillSemantic::ROR:  return helix::low::BinOpKind::Ror;
        default: return std::nullopt;
        }
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Factory
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createRemillToHelixLowPass() {
    return std::make_unique<RemillToHelixLowPass>();
}
