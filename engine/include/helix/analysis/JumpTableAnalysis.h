#pragma once
/// @file JumpTableAnalysis.h
/// @brief Analysis classes for detecting and resolving compiler-generated
///        jump tables (switch statement dispatch).
///
/// ## Overview
///
/// When a compiler emits a switch statement, it often produces an indirect
/// jump through a table of addresses (the "jump table").  At the machine
/// level this looks like:
///
///   cmp  selector, N        ; guard: ensure index in range
///   ja   default_label
///   jmp  [table_base + selector * 8]   ; indirect dispatch
///
/// This analysis recognises three common patterns and resolves the target
/// addresses by reading the jump table from the binary image via the
/// DataSectionProvider.
///
/// ## Recognised Patterns
///
///   1. **Direct** — table entries are absolute 64-bit addresses.
///      `jmp load(table_base + idx * 8)`
///
///   2. **PIC-relative** — table entries are 32-bit signed offsets from a
///      base address (common in position-independent code on x86-64).
///      `jmp rip_base + (int32_t)load(table_base + idx * 4)`
///
///   3. **Two-level** — a byte-indexed first table selects into a smaller
///      second table of word-sized addresses.  Used by MSVC when many
///      case values map to the same handler.
///      `jmp load(table1 + movzx(load(table2 + idx)))`
///
/// ## Usage
///
///   JumpTableAnalyzer analyzer(dataSectionProvider);
///   if (auto info = analyzer.analyze(jmpOp)) {
///       // info->targets contains resolved addresses
///   }

#ifndef HELIX_ANALYSIS_JUMP_TABLE_ANALYSIS_H
#define HELIX_ANALYSIS_JUMP_TABLE_ANALYSIS_H

#include "helix/analysis/DataSectionProvider.h"
#include "helix/dialects/HelixLowOps.h"

#include "mlir/IR/Value.h"
#include "mlir/IR/Block.h"
#include "mlir/IR/Operation.h"

#include "llvm/ADT/SmallVector.h"

#include <cstdint>
#include <optional>
#include <vector>

namespace helix {

// ═══════════════════════════════════════════════════════════════════════════════
// Jump Table Pattern Classification
// ═══════════════════════════════════════════════════════════════════════════════

/// Classification of the jump table encoding.
enum class JumpTablePattern {
    /// Absolute addresses: table[i] is the target address directly.
    /// Entry width is typically 8 bytes (64-bit) or 4 bytes (32-bit).
    Direct,

    /// PIC-relative offsets: target = base_addr + (int32_t)table[i].
    /// Entries are 32-bit signed offsets from a known base address.
    PICRelative,

    /// Two-level indirection: byte table maps index to a secondary index,
    /// which is then used to look up the real target from a word table.
    /// Used when many case values share a handler (MSVC optimisation).
    TwoLevel,
};

// ═══════════════════════════════════════════════════════════════════════════════
// Jump Table Info
// ═══════════════════════════════════════════════════════════════════════════════

/// Complete description of a resolved jump table.
struct JumpTableInfo {
    /// The pattern used to encode the table.
    JumpTablePattern pattern;

    /// Virtual address of the primary jump table in the binary.
    uint64_t base_addr = 0;

    /// Number of entries in the table (derived from the guard comparison).
    unsigned entry_count = 0;

    /// Width of each table entry in bytes (1, 2, 4, or 8).
    unsigned entry_width = 0;

    /// The SSA value that serves as the switch selector (the index into
    /// the table before any scaling).
    mlir::Value selector_value;

    /// The guard branch operation (typically `cmp idx, N; ja default`).
    /// Null if no guard was found (degenerate case).
    mlir::Operation* guard_branch = nullptr;

    /// Target block for the default/out-of-range case.
    mlir::Block* default_target = nullptr;

    /// For PIC-relative tables: the base address that offsets are relative to.
    /// For Direct tables: unused (0).
    uint64_t pic_base_addr = 0;

    /// For Two-level tables: address of the secondary (byte) index table.
    uint64_t level2_table_addr = 0;

    /// Resolved target addresses, one per case index (0..entry_count-1).
    std::vector<uint64_t> targets;
};

// ═══════════════════════════════════════════════════════════════════════════════
// Backward Slice Element
// ═══════════════════════════════════════════════════════════════════════════════

/// An element in the backward slice from the indirect jump target.
///
/// The backward slice captures the chain of operations that compute the
/// jump target address from the switch selector.
struct SliceElement {
    /// The MLIR operation in the slice.
    mlir::Operation* op = nullptr;

    /// Classification of this element's role in the pattern.
    enum class Role {
        TableLoad,     ///< mem.read that loads from the jump table
        BaseAdd,       ///< binop Add that combines base + offset
        IndexScale,    ///< binop Mul or Shl that scales the index
        IndexExtend,   ///< movzx/movsx that extends the index
        Constant,      ///< A constant value (table base, scale factor)
        Other,         ///< Not classified — part of the slice but unknown role
    } role = Role::Other;

    /// The SSA value produced by this operation.
    mlir::Value result;
};

// ═══════════════════════════════════════════════════════════════════════════════
// Jump Table Analyzer
// ═══════════════════════════════════════════════════════════════════════════════

/// Analyses indirect jumps to detect and resolve jump tables.
///
/// Given a `helix_low.jmp` operation whose target is computed (not a direct
/// block reference with a known address), the analyzer:
///
///   1. Walks the def-use chain backward to build a "slice" of operations
///      that compute the jump target.
///   2. Matches the slice against known jump table patterns.
///   3. Searches backward for a guard branch (cmp + ja) to determine the
///      number of cases and default target.
///   4. Reads the jump table from the binary via DataSectionProvider to
///      resolve all target addresses.
class JumpTableAnalyzer {
public:
    explicit JumpTableAnalyzer(const DataSectionProvider& provider);

    /// Analyse a jmp operation for jump table patterns.
    ///
    /// @param jmpOp  A `helix_low.jmp` operation with an indirect target.
    /// @return       JumpTableInfo if a jump table was successfully detected
    ///               and resolved, std::nullopt otherwise.
    std::optional<JumpTableInfo> analyze(low::JmpOp jmpOp);

private:
    /// Build a backward slice from the given SSA value through the def-use
    /// chain, collecting all operations that contribute to computing the
    /// jump target address.
    ///
    /// Stops at: constants, block arguments, memory reads from non-computed
    /// addresses (the table load itself).
    llvm::SmallVector<SliceElement, 8> backwardSlice(mlir::Value target);

    /// Match the backward slice against known jump table patterns.
    ///
    /// @param slice  The backward slice from the jump target.
    /// @param[out] info  Partially filled JumpTableInfo with pattern, base
    ///                    address, entry width, and selector value.
    /// @return True if a pattern was recognized.
    bool detectPattern(const llvm::SmallVector<SliceElement, 8>& slice,
                       JumpTableInfo& info);

    /// Search backward from the indirect jmp for a guard branch that bounds
    /// the switch selector value (typically `cmp idx, N; ja default`).
    ///
    /// @param jmpOp  The indirect jump operation.
    /// @param selector  The selector SSA value identified by detectPattern.
    /// @param[out] info  Filled with entry_count, guard_branch, default_target.
    /// @return True if a guard was found.
    bool findGuardBranch(low::JmpOp jmpOp, mlir::Value selector,
                         JumpTableInfo& info);

    /// Read jump table entries from the binary and compute target addresses.
    ///
    /// @param info  JumpTableInfo with pattern, base_addr, entry_count,
    ///              entry_width, and pic_base_addr already set.
    /// @return True if all entries were successfully read and resolved.
    bool enumerateTargets(JumpTableInfo& info);

    const DataSectionProvider& data_provider_;
};

} // namespace helix

#endif // HELIX_ANALYSIS_JUMP_TABLE_ANALYSIS_H
