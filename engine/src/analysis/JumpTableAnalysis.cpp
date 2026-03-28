/// @file JumpTableAnalysis.cpp
/// @brief Implementation of jump table detection and resolution.
///
/// This file implements the backward-slice algorithm that walks the def-use
/// chain from an indirect jump's computed target, recognises common jump
/// table patterns, locates the guard comparison that bounds the switch
/// selector, and reads the table entries from the binary image.
///
/// See JumpTableAnalysis.h for full documentation of the three recognised
/// patterns (Direct, PIC-relative, Two-level).

#include "helix/analysis/JumpTableAnalysis.h"
#include "helix/dialects/HelixLowOps.h"

#include "mlir/IR/Block.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Matchers.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/Value.h"

#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#include <cstdint>
#include <optional>

#define DEBUG_TYPE "jump-table-analysis"

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════════════════════════

/// Try to extract a constant integer value from an SSA Value.
///
/// Recognises: arith.constant, LLVM::ConstantOp, and HelixLow ops that carry
/// an explicit constant attribute (e.g., lea with zero index and non-zero disp).
static std::optional<uint64_t> tryExtractConstant(Value val) {
    if (!val)
        return std::nullopt;

    Operation* def = val.getDefiningOp();
    if (!def)
        return std::nullopt;

    // Try mlir::IntegerAttr on arith.constant or LLVM constant.
    IntegerAttr intAttr;
    if (matchPattern(val, m_Constant(&intAttr)))
        return (uint64_t)intAttr.getInt();

    return std::nullopt;
}

/// Check if a Value is a block argument (i.e., a function parameter or phi,
/// not produced by an operation).
static bool isBlockArgument(Value val) {
    return val && isa<BlockArgument>(val);
}

// ═══════════════════════════════════════════════════════════════════════════════
// JumpTableAnalyzer — Construction
// ═══════════════════════════════════════════════════════════════════════════════

JumpTableAnalyzer::JumpTableAnalyzer(const DataSectionProvider& provider)
    : data_provider_(provider) {}

// ═══════════════════════════════════════════════════════════════════════════════
// Backward Slice
// ═══════════════════════════════════════════════════════════════════════════════

llvm::SmallVector<SliceElement, 8>
JumpTableAnalyzer::backwardSlice(Value target) {
    llvm::SmallVector<SliceElement, 8> slice;
    llvm::SmallDenseSet<Operation*, 16> visited;

    // Worklist-based backward walk through the def-use chain.
    llvm::SmallVector<Value, 8> worklist;
    worklist.push_back(target);

    while (!worklist.empty()) {
        Value current = worklist.pop_back_val();

        // Block arguments are roots of the slice — nothing to walk past.
        if (isBlockArgument(current))
            continue;

        Operation* defOp = current.getDefiningOp();
        if (!defOp || !visited.insert(defOp).second)
            continue;

        SliceElement elem;
        elem.op = defOp;
        elem.result = current;

        // Classify the operation by its role in the jump table pattern.
        if (isa<low::MemReadOp>(defOp)) {
            elem.role = SliceElement::Role::TableLoad;
        } else if (auto binOp = dyn_cast<low::BinOp>(defOp)) {
            auto kind = binOp.getKind();
            if (kind == low::BinOpKind::Add)
                elem.role = SliceElement::Role::BaseAdd;
            else if (kind == low::BinOpKind::Mul ||
                     kind == low::BinOpKind::Shl)
                elem.role = SliceElement::Role::IndexScale;
            else
                elem.role = SliceElement::Role::Other;
        } else if (isa<low::MovZxOp, low::MovSxOp>(defOp)) {
            elem.role = SliceElement::Role::IndexExtend;
        } else if (isa<low::LeaOp>(defOp)) {
            // LEA is pure address computation: base + index * scale + disp.
            // Could serve as both BaseAdd and IndexScale.
            elem.role = SliceElement::Role::BaseAdd;
        } else if (tryExtractConstant(current).has_value()) {
            elem.role = SliceElement::Role::Constant;
        } else {
            elem.role = SliceElement::Role::Other;
        }

        slice.push_back(elem);

        // Continue walking backward through operands (except for table loads:
        // we want to capture the load address but don't walk past the loaded
        // value because that's the table content, not part of the address
        // computation).
        if (elem.role == SliceElement::Role::TableLoad) {
            // For mem.read, add the address operand to the worklist
            // but NOT the result (which is the loaded table entry).
            auto memRead = cast<low::MemReadOp>(defOp);
            worklist.push_back(memRead.getAddr());
        } else {
            // Walk all operands.
            for (Value operand : defOp->getOperands())
                worklist.push_back(operand);
        }
    }

    return slice;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pattern Detection
// ═══════════════════════════════════════════════════════════════════════════════

bool JumpTableAnalyzer::detectPattern(
        const llvm::SmallVector<SliceElement, 8>& slice,
        JumpTableInfo& info) {
    // We need at least a table load and some address computation.
    if (slice.empty())
        return false;

    // Find the table load(s) in the slice.
    const SliceElement* primaryLoad = nullptr;
    const SliceElement* secondaryLoad = nullptr;
    unsigned loadCount = 0;

    for (const auto& elem : slice) {
        if (elem.role == SliceElement::Role::TableLoad) {
            if (loadCount == 0)
                primaryLoad = &elem;
            else if (loadCount == 1)
                secondaryLoad = &elem;
            ++loadCount;
        }
    }

    if (!primaryLoad)
        return false;

    // ── Two-level pattern ────────────────────────────────────────────────
    //
    // Two loads:
    //   inner_load = mem.read(table2_base + idx)          ; byte index
    //   outer_load = mem.read(table1_base + zext(inner))  ; real target
    //
    // The inner load typically has 8-bit width, outer has 64-bit width.
    if (loadCount >= 2 && secondaryLoad) {
        auto outerRead = cast<low::MemReadOp>(primaryLoad->op);
        auto innerRead = cast<low::MemReadOp>(secondaryLoad->op);

        // The inner (byte) load feeds into the outer load's address via
        // a movzx → scale → add chain.  Check if the inner read is
        // 8-bit (byte-indexed table).
        if (innerRead.getBitWidth() == 8) {
            LLVM_DEBUG(llvm::dbgs() << "JTA: detected Two-level pattern\n");
            info.pattern = JumpTablePattern::TwoLevel;
            info.entry_width = outerRead.getBitWidth() / 8;

            // Try to extract table base addresses from the address computations.
            // For the inner load, look for a constant in its address chain.
            for (const auto& elem : slice) {
                if (elem.role == SliceElement::Role::BaseAdd &&
                    elem.op != primaryLoad->op &&
                    elem.op != secondaryLoad->op) {
                    // Check operands for constants that could be table bases.
                    for (Value operand : elem.op->getOperands()) {
                        if (auto addr = tryExtractConstant(operand)) {
                            // Heuristic: the larger address is the word table,
                            // the other is the byte table.
                            if (info.base_addr == 0)
                                info.base_addr = *addr;
                            else if (*addr != info.base_addr)
                                info.level2_table_addr = *addr;
                        }
                    }
                }
            }

            // Find the selector value: the input to the byte-table load
            // before any scaling/extension.
            info.selector_value = innerRead.getAddr();
            for (const auto& elem : slice) {
                if (elem.role == SliceElement::Role::IndexExtend ||
                    elem.role == SliceElement::Role::IndexScale) {
                    // The operand of the extension/scale is closer to the selector.
                    if (auto ext = dyn_cast<low::MovZxOp>(elem.op))
                        info.selector_value = ext.getSrc();
                    else if (auto ext = dyn_cast<low::MovSxOp>(elem.op))
                        info.selector_value = ext.getSrc();
                }
            }

            return info.base_addr != 0;
        }
    }

    // ── Single-load patterns (Direct or PIC-relative) ────────────────────
    auto tableRead = cast<low::MemReadOp>(primaryLoad->op);
    unsigned loadBitWidth = tableRead.getBitWidth();

    // Look for the BaseAdd that computes the table access address.
    // One operand should be a constant (table base), the other should
    // be the scaled index.
    uint64_t tableBase = 0;
    Value indexValue;

    for (const auto& elem : slice) {
        if (elem.role == SliceElement::Role::BaseAdd) {
            Operation* addOp = elem.op;

            if (auto lea = dyn_cast<low::LeaOp>(addOp)) {
                // LEA: base + index * scale + displacement
                if (auto baseConst = tryExtractConstant(lea.getBase())) {
                    tableBase = *baseConst + lea.getDisplacement();
                    indexValue = lea.getIndex();
                } else if (lea.getDisplacement() != 0) {
                    tableBase = (uint64_t)lea.getDisplacement();
                    indexValue = lea.getBase();
                }
                break;
            }

            if (auto binOp = dyn_cast<low::BinOp>(addOp)) {
                if (auto lhsConst = tryExtractConstant(binOp.getLhs())) {
                    tableBase = *lhsConst;
                    indexValue = binOp.getRhs();
                } else if (auto rhsConst = tryExtractConstant(binOp.getRhs())) {
                    tableBase = *rhsConst;
                    indexValue = binOp.getLhs();
                }
                break;
            }
        }
    }

    if (tableBase == 0)
        return false;

    info.base_addr = tableBase;

    // Determine entry width from the load.
    info.entry_width = loadBitWidth / 8;

    // Walk backward from indexValue to find the raw selector (before
    // any scaling/extension).
    info.selector_value = indexValue;
    for (const auto& elem : slice) {
        if (elem.role == SliceElement::Role::IndexScale) {
            // The non-constant operand of the scale is the pre-scale index.
            for (Value operand : elem.op->getOperands()) {
                if (!tryExtractConstant(operand).has_value()) {
                    info.selector_value = operand;
                    break;
                }
            }
        }
    }

    // Unwrap any extension on the selector.
    if (info.selector_value) {
        if (auto def = info.selector_value.getDefiningOp()) {
            if (auto zx = dyn_cast<low::MovZxOp>(def))
                info.selector_value = zx.getSrc();
            else if (auto sx = dyn_cast<low::MovSxOp>(def))
                info.selector_value = sx.getSrc();
        }
    }

    // ── Distinguish Direct vs PIC-relative ───────────────────────────────
    //
    // If the loaded value is 32-bit AND there's an Add that combines it
    // with a base address → PIC-relative pattern.
    // If the loaded value is 64-bit and used directly as the jump target
    // → Direct pattern.

    if (loadBitWidth == 32) {
        // Look for an Add of the loaded value with a constant (the PIC base).
        // This Add would be the topmost element feeding the jmp target.
        for (const auto& elem : slice) {
            if (elem.role == SliceElement::Role::BaseAdd) {
                auto binOp = dyn_cast<low::BinOp>(elem.op);
                if (!binOp)
                    continue;
                // Check if one operand is the table load result and the
                // other is a constant.
                for (Value operand : binOp->getOperands()) {
                    if (operand == primaryLoad->result)
                        continue;
                    if (auto picBase = tryExtractConstant(operand)) {
                        info.pattern = JumpTablePattern::PICRelative;
                        info.pic_base_addr = *picBase;
                        LLVM_DEBUG(llvm::dbgs()
                            << "JTA: detected PIC-relative pattern, base=0x"
                            << llvm::Twine::utohexstr(info.pic_base_addr) << "\n");
                        return true;
                    }
                }
            }
        }
    }

    // Default: Direct pattern.
    info.pattern = JumpTablePattern::Direct;
    LLVM_DEBUG(llvm::dbgs() << "JTA: detected Direct pattern, table=0x"
        << llvm::Twine::utohexstr(info.base_addr)
        << ", entry_width=" << info.entry_width << "\n");
    return true;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Guard Branch Detection
// ═══════════════════════════════════════════════════════════════════════════════

bool JumpTableAnalyzer::findGuardBranch(low::JmpOp jmpOp, Value selector,
                                         JumpTableInfo& info) {
    // The guard is a conditional branch that bounds the selector value.
    // Typical pattern:
    //
    //   %flags = helix_low.cmp %selector, N
    //   helix_low.jcc "a" %flags:carry, ^default, ^dispatch
    //
    // where ^dispatch contains (or leads to) the indirect jmp.
    //
    // Walk backward through predecessor blocks looking for a JccOp whose
    // condition depends on the selector.

    Block* jmpBlock = jmpOp->getBlock();
    if (!jmpBlock)
        return false;

    // Check immediate predecessors (depth-limited search, max 3 hops).
    llvm::SmallVector<Block*, 4> worklist;
    llvm::SmallDenseSet<Block*, 8> visited;

    // Start with predecessors of the jmp's block.
    for (Block* pred : jmpBlock->getPredecessors())
        worklist.push_back(pred);

    // Also check the jmp block itself — the guard may be in the same block
    // as the jmp (split by the conditional branch targeting both the dispatch
    // and the default).
    // But JmpOp is unconditional, so the guard is in a predecessor.

    unsigned depth = 0;
    constexpr unsigned kMaxDepth = 3;

    while (!worklist.empty() && depth < kMaxDepth) {
        ++depth;
        llvm::SmallVector<Block*, 4> nextWorklist;

        for (Block* block : worklist) {
            if (!visited.insert(block).second)
                continue;

            Operation* terminator = block->getTerminator();
            if (!terminator)
                continue;

            auto jccOp = dyn_cast<low::JccOp>(terminator);
            if (!jccOp)
                continue;

            // Check the condition code — we're looking for "a" (above) or
            // "b" (below), which are unsigned comparisons used to guard
            // the jump table index.
            auto condStr = jccOp.getCondition();
            bool isAbove = (condStr == "a" || condStr == "ja" ||
                            condStr == "nbe");
            bool isBelow = (condStr == "b" || condStr == "jb" ||
                            condStr == "nae" || condStr == "be" ||
                            condStr == "jbe" || condStr == "na");

            if (!isAbove && !isBelow)
                continue;

            // Find the CmpOp that feeds this JccOp's flag value.
            Value flagVal = jccOp.getFlagValue();
            Operation* flagDef = flagVal.getDefiningOp();
            if (!flagDef)
                continue;

            auto cmpOp = dyn_cast<low::CmpOp>(flagDef);
            if (!cmpOp)
                continue;

            // One operand of the CMP should be the selector (or a value
            // derived from it), and the other should be a constant N
            // giving us N+1 cases.
            Value cmpLhs = cmpOp.getLhs();
            Value cmpRhs = cmpOp.getRhs();

            std::optional<uint64_t> boundConst;
            bool selectorIsLhs = false;

            if (auto c = tryExtractConstant(cmpRhs)) {
                boundConst = c;
                selectorIsLhs = true;
            } else if (auto c = tryExtractConstant(cmpLhs)) {
                boundConst = c;
                selectorIsLhs = false;
            }

            if (!boundConst)
                continue;

            // Verify that the other operand relates to the selector.
            // For now, accept if they match directly or through extensions.
            Value cmpSelector = selectorIsLhs ? cmpLhs : cmpRhs;
            bool selectorMatch = (cmpSelector == selector);

            // Also check through extensions.
            if (!selectorMatch) {
                if (auto def = cmpSelector.getDefiningOp()) {
                    if (auto zx = dyn_cast<low::MovZxOp>(def))
                        selectorMatch = (zx.getSrc() == selector);
                    else if (auto sx = dyn_cast<low::MovSxOp>(def))
                        selectorMatch = (sx.getSrc() == selector);
                }
            }
            // Also check if selector was extended from cmpSelector.
            if (!selectorMatch && selector) {
                if (auto def = selector.getDefiningOp()) {
                    if (auto zx = dyn_cast<low::MovZxOp>(def))
                        selectorMatch = (zx.getSrc() == cmpSelector);
                    else if (auto sx = dyn_cast<low::MovSxOp>(def))
                        selectorMatch = (sx.getSrc() == cmpSelector);
                }
            }

            if (!selectorMatch)
                continue;

            // Found the guard!
            //
            // `cmp selector, N; ja default` means:
            //   if selector > N, go to default
            //   else fall through to dispatch (N+1 valid cases: 0..N)
            info.entry_count = static_cast<unsigned>(*boundConst + 1);
            info.guard_branch = jccOp.getOperation();

            // The default target depends on the condition direction.
            if (isAbove) {
                // "ja default" → trueDest is the default
                info.default_target = jccOp.getTrueDest();
            } else {
                // "jbe dispatch" → falseDest is the default
                info.default_target = jccOp.getFalseDest();
            }

            LLVM_DEBUG(llvm::dbgs()
                << "JTA: found guard: cmp selector, " << *boundConst
                << " → " << info.entry_count << " cases\n");
            return true;
        }

        // Go one more level up.
        for (Block* block : worklist) {
            for (Block* pred : block->getPredecessors())
                nextWorklist.push_back(pred);
        }
        worklist = std::move(nextWorklist);
    }

    LLVM_DEBUG(llvm::dbgs() << "JTA: no guard branch found\n");
    return false;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Target Enumeration
// ═══════════════════════════════════════════════════════════════════════════════

bool JumpTableAnalyzer::enumerateTargets(JumpTableInfo& info) {
    if (!data_provider_.isAvailable()) {
        LLVM_DEBUG(llvm::dbgs() << "JTA: data provider not available\n");
        return false;
    }

    if (info.entry_count == 0 || info.entry_count > 4096) {
        LLVM_DEBUG(llvm::dbgs()
            << "JTA: invalid entry count: " << info.entry_count << "\n");
        return false;
    }

    info.targets.clear();
    info.targets.reserve(info.entry_count);

    switch (info.pattern) {
    case JumpTablePattern::Direct: {
        // targets[i] = readWord(table_base + i * entry_width)
        for (unsigned i = 0; i < info.entry_count; ++i) {
            uint64_t addr = info.base_addr + i * info.entry_width;
            auto val = data_provider_.readWord(addr, info.entry_width);
            if (!val) {
                LLVM_DEBUG(llvm::dbgs()
                    << "JTA: failed to read Direct entry at 0x"
                    << llvm::Twine::utohexstr(addr) << "\n");
                return false;
            }
            info.targets.push_back(*val);
        }
        break;
    }

    case JumpTablePattern::PICRelative: {
        // targets[i] = pic_base + (int32_t)readWord(table_base + i * 4)
        for (unsigned i = 0; i < info.entry_count; ++i) {
            uint64_t addr = info.base_addr + i * 4;
            auto val = data_provider_.readWord(addr, 4);
            if (!val) {
                LLVM_DEBUG(llvm::dbgs()
                    << "JTA: failed to read PIC entry at 0x"
                    << llvm::Twine::utohexstr(addr) << "\n");
                return false;
            }
            // Sign-extend the 32-bit offset and add to PIC base.
            int32_t offset = static_cast<int32_t>(*val);
            uint64_t target = info.pic_base_addr + static_cast<int64_t>(offset);
            info.targets.push_back(target);
        }
        break;
    }

    case JumpTablePattern::TwoLevel: {
        // level2_idx = readByte(level2_table + i)
        // targets[i] = readWord(base_addr + level2_idx * entry_width)
        for (unsigned i = 0; i < info.entry_count; ++i) {
            auto byteIdx = data_provider_.readWord(
                info.level2_table_addr + i, /*byteWidth=*/1);
            if (!byteIdx) {
                LLVM_DEBUG(llvm::dbgs()
                    << "JTA: failed to read Two-level byte index at offset "
                    << i << "\n");
                return false;
            }

            uint64_t wordAddr = info.base_addr +
                                (*byteIdx) * info.entry_width;
            auto val = data_provider_.readWord(wordAddr, info.entry_width);
            if (!val) {
                LLVM_DEBUG(llvm::dbgs()
                    << "JTA: failed to read Two-level word entry at 0x"
                    << llvm::Twine::utohexstr(wordAddr) << "\n");
                return false;
            }
            info.targets.push_back(*val);
        }
        break;
    }
    }

    LLVM_DEBUG(llvm::dbgs()
        << "JTA: enumerated " << info.targets.size() << " targets\n");
    return true;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Top-Level Analysis
// ═══════════════════════════════════════════════════════════════════════════════

std::optional<JumpTableInfo> JumpTableAnalyzer::analyze(low::JmpOp jmpOp) {
    if (!data_provider_.isAvailable())
        return std::nullopt;

    // Only analyse indirect jumps.  A direct jump has a known target_addr
    // attribute; an indirect jump computes its target from a memory load.
    //
    // In the current IR representation, JmpOp always has a successor block.
    // An indirect jump is one that was lifted from an instruction whose
    // target was NOT a fixed address — the Remill lifter creates a
    // target_addr attribute only for direct jumps.
    //
    // Heuristic: if target_addr is present and non-zero, this is a direct
    // jump — skip it.  If absent (or zero), check if the block contains
    // a table load pattern.
    if (jmpOp.getTargetAddr().has_value()) {
        uint64_t tgt = jmpOp.getTargetAddr().value();
        if (tgt != 0)
            return std::nullopt;
    }

    // Get the destination block.  For an indirect jump, this is typically
    // a dummy/placeholder block created by the lifter.
    Block* destBlock = jmpOp.getDest();
    if (!destBlock)
        return std::nullopt;

    // Build a backward slice from operations in the jmp's block that
    // compute an address used in memory operations.  The actual "target"
    // for an indirect jmp in HelixLow is not an SSA value (it's the
    // successor block), so we look for mem.read ops in the same block
    // or preceding blocks that could be loading from a jump table.
    //
    // Walk backwards from the jmp to find the nearest mem.read with a
    // computed address.
    Block* jmpBlock = jmpOp->getBlock();
    if (!jmpBlock)
        return std::nullopt;

    // Scan backward in the jmp block for a mem.read that could be the
    // table load.
    Value tableLoadResult;
    for (auto it = Block::iterator(jmpOp); it != jmpBlock->begin(); ) {
        --it;
        if (auto memRead = dyn_cast<low::MemReadOp>(&*it)) {
            tableLoadResult = memRead.getResult();
            break;
        }
        // Stop if we hit another terminator or call.
        if (isa<low::CallOp, low::RetOp, low::JccOp>(&*it))
            break;
    }

    if (!tableLoadResult)
        return std::nullopt;

    // Build the backward slice from the table load's address.
    auto slice = backwardSlice(tableLoadResult);
    if (slice.empty())
        return std::nullopt;

    // Detect the jump table pattern.
    JumpTableInfo info;
    if (!detectPattern(slice, info))
        return std::nullopt;

    // Find the guard branch to determine the number of cases.
    if (!findGuardBranch(jmpOp, info.selector_value, info)) {
        // Without a guard, we can't determine the table size.
        // Some compilers omit the guard if the input is already bounded
        // (e.g., enum).  For safety, give up.
        LLVM_DEBUG(llvm::dbgs()
            << "JTA: no guard found, cannot determine table size\n");
        return std::nullopt;
    }

    // Read the table entries from the binary.
    if (!enumerateTargets(info))
        return std::nullopt;

    return info;
}
