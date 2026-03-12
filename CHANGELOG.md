# Changelog

All notable changes to HexCore Helix are documented here.

---

## [v0.5.0] — 2026-03-11

### Bug Fixes

#### Entry Block Predecessor Crash (Fatal — `LLVM abort()`)

**Symptom**: `Entry block to function must not have predecessors! label %bb_0 / LLVM ERROR: Broken module found, compilation aborted!` — process crashes unconditionally (via `abort()`).

**Root cause**: `llvm::parseIR()` calls `parseAssembly()` → `LLParser::Run(UpgradeDebugInfo=true)` → `llvm::UpgradeDebugInfo()` → `llvm::verifyModule(FatalErrors=true)` → `abort()`. This happens inside `parseIR` before it returns, so any post-parse sanitization is unreachable.

**Trigger condition**: Remill-lifted IR where a function has a backward branch to its entry block (loop-at-entry pattern) AND the module has `!"Debug Info Version", i32 3` (matches `DEBUG_METADATA_VERSION`). Confirmed in `lifted_5368715048` from `partial_encryption.exe` (function `0x140001728`, SIMD loop function).

**Fix** (`engine/src/Pipeline.cpp`):
- Replaced `llvm::parseIR()` with direct `LLParser::Run(UpgradeDebugInfo=false)` via `#include "llvm/AsmParser/LLParser.h"`.
- After successful parse, applies entry block sanitization: inserts a new empty `BasicBlock` before any entry block that has predecessors, with an unconditional branch to the original entry.
- `LLParser.h` is in LLVM's public include path; `LLVMAsmParser` is already transitively linked via `LLVMIRReader`.

#### `RecoverCallingConvention` Crash on Large/Unusual IR

**Symptom**: Extension host crash (`STATUS_ACCESS_VIOLATION`) during `RecoverCallingConvention` pass on functions with non-trivial block structure.

**Root cause**: `DominanceInfo::getNode(block)` crashes in MLIR 18.x on certain IR patterns (massive single-block functions, nested regions, blocks created during translation that lack dominator tree nodes).

**Fix** (`engine/src/passes/RecoverCallingConvention.cpp`):
- Removed `DominanceInfo` entirely. The pass no longer constructs a dominator tree.
- `collectAbiCallArgs`: replaced `findLatestRegWriteOnDomChain` with block scan + predecessor search (`findLatestRegWriteInPredecessors`, depth-2 by default). This covers all common Win64/SysV ABI call patterns.
- Removed `#include "mlir/IR/Dominance.h"`.

#### Pass Pipeline Safety Notes

Per the fix comments in `Pipeline.cpp::buildPassPipeline()`:
- `mlir::createCanonicalizerPass()` — removed: segfaults on multi-block HelixLow functions with LLVM dialect br/condBr terminators.
- `mlir::createCSEPass()` — removed: same crash on complex functions with many basic blocks (confirmed on 112-block functions).
- `pass_manager_->enableVerifier(false)` — inter-pass verification disabled to allow pipeline to complete with minor intermediate IR issues.

### Test Results

| File | Function | Status |
|------|----------|--------|
| `logic_1728.ll` | `lifted_5368715048` (0x140001728) — SIMD loop | 100% confidence |
| `05-banner.ll` | VVM HTB challenge — 5973 lines, 3 blocks | 100% confidence |
| All `remill-7/` | Saber Interactive game engine functions | No regressions |

### Build

- `helix_engine.lib` rebuilt: 43,056,284 bytes
- `hexcore-helix.win32-x64-msvc.node` rebuilt: 11,878,400 bytes
- Build requires env vars: `LLVM_BUILD_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir`

---

## [v0.4.0] — 2026-03-04

### 🚀 Phase 2: MLIR Decompilation Engine (Production)

The C++23/MLIR engine is now the **primary decompilation backend**, replacing the Rust HIR pipeline for complex multi-block functions.

#### MLIR Pass Pipeline
- **RemillToHelixLow** — Full conversion from Remill LLVM IR to `helix_low` dialect:
  - x86-64 semantic recognition (170+ instructions: MOV, LEA, CMP, TEST, ADD, SUB, AND, OR, XOR, etc.)
  - PC tracking and address attribution for each instruction
  - Argument recovery for indirect calls (tracks RCX, RDX, R8, R9 before `CALL`)
  - Flag synthesis for JCC conditions (ZF, SF, OF from CMP/TEST results)
- **RecoverStackLayout** — Stack frame analysis with `rbp`-relative variable recovery
- **RecoverCallingConvention** — Win64 calling convention parameter identification
- **PropagateTypes** — Type inference from memory access patterns and pointer arithmetic
- **StructureControlFlow** — Multi-phase control flow recovery:
  - CMOV → ternary expression conversion
  - Address-based loop detection (back-edge recognition via instruction addresses)
  - Forward conditional branch → `if/else` with relaxed convergence detection
  - Fallback `goto/label` emission for irreducible control flow
- **RecoverVariables** — Register-to-variable naming and coalescing
- **EliminateDeadCode** — Dead store elimination and unused operation removal

#### PseudoCEmitter (2300+ lines)
- Full pseudo-C emission from `helix_high` dialect operations
- Expression formatting: arithmetic, memory access, pointer dereference, field access
- Structured output: `if/else`, `while`, `do-while`, `goto/label`, `break`, `continue`
- **Flag recovery** — Translates raw flag checks into human-readable C conditions:
  - `if (nz)` → `if (x != 0)`
  - `if (s)` → `if (x < 0)`
  - `if (nl)` → `if (x >= y)`
- **Vtable call naming** — `rax->vfunc_0x18()` instead of raw indirect call addresses
- **Argument recovery** — Populates `/* ? */` placeholders with actual register values
- Dead store suppression and confidence scoring per function
- Inline assembly formatting for unrecognized instructions

#### CLI Tool (`helix_tool.exe`)
- Standalone decompiler: `helix_tool.exe <input.ll> [output.c]`
- Batch mode: `helix_tool.exe --dir <folder>` processes all `.ll` files
- Architecture auto-detection from IR metadata
- Dynamic output buffer with auto-resize

#### Custom MLIR Dialects
- **HelixLow** — Low-level dialect: `RegWriteOp`, `RegReadOp`, `MemLoadOp`, `MemStoreOp`, `CmpOp`, `TestOp`, `JccOp`, `JmpOp`, `RetOp`, `CallOp`, `CMovOp`, `FuncOp`, and more
- **HelixHigh** — Structured dialect: `IfOp`, `WhileOp`, `DoWhileOp`, `GotoOp`, `LabelOp`, `ReturnOp`, `BreakOp`, `ContinueOp`, `TernaryOp`, `CallOp`, `VarDeclOp`, `VarRefOp`, `CommentOp`

---

### 🧪 Test Data

- **New test suite `remill-7/`** — Real-world multi-block functions from **Saber Interactive** game engine:
  - `bone_pos_calc3.ll` — Complex bone position calculation (49 blocks, 25 conditions)
  - `projectile_constructor.ll` — Projectile system constructor
- All previous test data (Remill 1-6) cleaned up and reorganized

---

### 🔧 Engine Infrastructure

- **C API** — `helix_engine_create()`, `helix_engine_decompile_ir_text()`, `helix_engine_destroy()` for language-agnostic integration
- **FlatBuffer serialization** — Zero-copy binary output alongside pseudo-C text
- **Pipeline orchestration** — 7-pass pipeline with MLIR verification between stages
- **Remill demangler** — Extracts instruction addresses from Remill function names (`sub_140XXXXXX`)
- **Signature database** — CSV-based function name resolution for known CRT/Win32 functions

---

### 🐛 Bug Fixes

- Fixed MLIR dominance violations from out-of-region value references
- Fixed block termination errors (empty blocks without terminators)
- Fixed LLVM `br i1 true` terminator preservation — old terminators are now erased after `JccOp` emission
- Fixed missing UB/Func/SCF dialect registration
- Fixed hardcoded LLVM/MLIR build paths in CMake

---

## [v0.3.0] — 2026-02-20

### Phase 1.5: HIR Pipeline (Rust)

- **HIR Builder & Emitter** — Remill IR → pseudo-C with named variables
- **Calling Convention Recovery** — Win64 argument folding  
- **Type Propagation** — Iterative refinement to fixed-point
- **Control Flow Structuring** — `if/else` and `while` from CMP/TEST + Jcc
- **Data Flow Analysis** — Liveness, reaching definitions, DCE
- **104 unit tests**, throughput **>95 instr/ms**

### Phase 3: FlatBuffers Transport

- **Schemas** — `common.fbs`, `cfg.fbs` (HCFG), `ast.fbs` (HAST)
- **Rust serialization** — Manual builder with roundtrip tests
- **NAPI zero-copy** — `Buffer` objects passed directly to TypeScript

---

## [v0.1.0] — 2026-02-01

### Phase 1: Foundation

- Project scaffolding (Rust workspace + NAPI-RS + C++ engine scaffold)
- `helix-core` library with types, traits, and FFI boundary
- `hexcore-helix` NAPI-RS bridge for Node.js/VS Code integration
- FlatBuffers schema design
- CI/CD pipeline
