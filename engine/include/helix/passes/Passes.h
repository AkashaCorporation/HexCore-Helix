#pragma once
/// @file Passes.h
/// @brief Pass registration and creation functions for Helix decompilation passes.
///
/// Declares the factory functions for all MLIR passes in the Helix pipeline.
/// These are registered with the PassManager in Pipeline::buildPassPipeline().

#ifndef HELIX_PASSES_H
#define HELIX_PASSES_H

#include "mlir/Pass/Pass.h"
#include <memory>

namespace helix {

// ─── Conversion Pass (LLVM Dialect → HelixLow) ──────────────────────────────

/// Create the Remill-to-HelixLow conversion pass.
///
/// Recognizes Remill IR patterns (State struct GEPs, mangled semantic calls,
/// __remill_* intrinsics) and converts them to HelixLow dialect operations.
std::unique_ptr<mlir::Pass> createRemillToHelixLowPass();

// ─── Analysis / Transform Passes (HelixLow → HelixHigh) ─────────────────────

/// Create the stack layout recovery pass.
///
/// Scans for RSP/RBP+offset memory accesses and creates helix_high.var.decl
/// operations for each unique stack slot. Determines variable types from
/// access widths.
std::unique_ptr<mlir::Pass> createRecoverStackLayoutPass();

/// Create the calling convention recovery pass.
///
/// Implements Win64/SysV ABI recovery: identifies argument registers
/// (RCX, RDX, R8, R9 for Win64), folds them into helix_high.call arguments,
/// and names return values (RAX).
std::unique_ptr<mlir::Pass> createRecoverCallingConventionPass();

/// Create the type propagation pass.
///
/// Iteratively refines Unknown types to concrete types until fixed point
/// (max 16 iterations). Uses rules based on API signatures, access widths,
/// binary operation semantics, and pointer arithmetic patterns.
std::unique_ptr<mlir::Pass> createPropagateTypesPass();

/// Create the control flow structuring pass.
///
/// Transforms flat basic blocks with branches into structured control flow
/// (helix_high.if, helix_high.while, helix_high.for) using dominance
/// analysis and back-edge detection. Falls back to goto/label for
/// irreducible control flow.
std::unique_ptr<mlir::Pass> createStructureControlFlowPass();

/// Create the variable recovery pass.
///
/// Replaces remaining register references with named variables. Handles
/// register aliases (EAX/AX/AL → truncation of RAX). Applies naming
/// conventions: register vars → lowercase, stack vars → var_<offset>,
/// temporaries → v<N>.
std::unique_ptr<mlir::Pass> createRecoverVariablesPass();

/// Create the dead code elimination pass.
///
/// Removes: NOPs, INT3 markers, prologue/epilogue push/pop pairs, dead
/// register writes, stack pointer bookkeeping (rsp = rsp ± N).
std::unique_ptr<mlir::Pass> createEliminateDeadCodePass();

// ─── Optimization Passes (v3.8.0) ────────────────────────────────────────────

/// Create the magic number division recovery pass.
///
/// Detects compiler-generated magic number multiply+shift patterns that
/// implement division by a constant, and reverses them to clean division
/// expressions:  `(x * magic) >> shift`  →  `x / divisor`
std::unique_ptr<mlir::Pass> createRecoverMagicDivisionPass();

/// Create the devirtualization pass for indirect calls.
///
/// Performs intra-procedural dataflow analysis to track vtable pointer stores
/// and resolve indirect calls through vtable slots.  Annotates calls with
/// vtable address and offset information; resolves to function names when
/// the target address matches a known function.
std::unique_ptr<mlir::Pass> createDevirtualizeIndirectCallsPass();

/// Create the inter-procedural type propagation pass.
///
/// Propagates type information across function call boundaries:
/// argument types from caller to callee parameters, and return types
/// from callee back to caller.  Iterates until convergence to eliminate
/// the int64_t flood from ABI register-width defaults.
std::unique_ptr<mlir::Pass> createInterProceduralTypePropagationPass();

// ─── Dialect Conversion Passes (v1.0 3-tier architecture) ────────────────────

/// Create the HelixLow → HelixMid conversion pass.
///
/// Converts machine-level ops to ISA-agnostic typed SSA:
///   - reg.read/reg.write → var.ref/assign (abstract slots)
///   - mem.read/mem.write → typed load/store
///   - flag-producing binop → pure value binexpr
///   - CMOV → select, CMP/TEST → comparison expressions
///   - REP MOVS/STOS → memcpy/memset intrinsics
std::unique_ptr<mlir::Pass> createHelixLowToMidPass();

/// Create the HelixMid → HelixHigh conversion pass.
///
/// Converts ISA-agnostic typed SSA to C source-level representation:
///   - Abstract variable slots → named variables
///   - Typed expressions → C-level binary/unary ops
///   - select → ternary, memcpy/memset → call
std::unique_ptr<mlir::Pass> createHelixMidToHighPass();

// ─── Pass Registration ───────────────────────────────────────────────────────

/// Register all Helix passes with the MLIR pass registry.
/// Call this once at startup for pass pipeline textual specification support.
void registerHelixPasses();

} // namespace helix

#endif // HELIX_PASSES_H
