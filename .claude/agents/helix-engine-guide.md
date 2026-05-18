# Helix Engine — Complete Agent Guide

> This document briefs a Claude Code agent on HexCore Helix so it can work
> autonomously on the engine without losing context. Read this BEFORE touching
> any code.

## 1. What Helix IS

Helix is a **formally-structured binary decompiler** built on LLVM 18 / MLIR.
It takes lifted LLVM IR (from Remill) and produces Pseudo-C through a 3-tier
MLIR dialect pipeline:

```
Binary → Remill IR (LLVM) → HelixLow → HelixMid → HelixHigh → C-AST → Pseudo-C
```

Each arrow is a set of MLIR passes. The C-AST is then optimized by
`CAstOptimizer` (algebraic simplification, DCE, copy prop, compound assignment)
before being printed by `CAstPrinter`.

### Philosophy
- **Fidelity > polish** — correct output beats pretty output
- **Provable transforms only** — every simplification is a testable pass
- **Confidence transparency** — emits headers saying what's proven vs guessed
- **NOT an IDA clone** — different goals, different approach

## 2. Project Layout

```
C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\
├── engine/                          # C++23 MLIR engine
│   ├── include/helix/               # Headers
│   │   ├── cast/                    # C-AST types (CStmt, CExpr, CAstBuilder, etc.)
│   │   ├── dialects/                # MLIR dialect definitions (Low, Mid, High)
│   │   └── passes/                  # MLIR pass declarations
│   ├── src/
│   │   ├── cast/                    # C-AST implementation
│   │   │   ├── CAstBuilder.cpp      # MLIR High → C-AST conversion (3200+ lines)
│   │   │   ├── CAstOptimizer.cpp    # C-AST optimization passes (7400+ lines)
│   │   │   └── CAstPrinter.cpp      # C-AST → text emission
│   │   ├── passes/                  # MLIR passes
│   │   │   ├── RemillToHelixLow.cpp # Remill IR → HelixLow
│   │   │   ├── HelixLowToMid.cpp    # Low → Mid (register→variable promotion)
│   │   │   ├── HelixMidToHigh.cpp   # Mid → High (expression recovery, control flow)
│   │   │   └── StructureControlFlow.cpp # CFG structuring (SCC, if/while recovery)
│   │   ├── analysis/
│   │   │   └── SignatureDb.cpp      # Function signature + relocation resolution
│   │   ├── Engine.cpp               # Top-level pipeline orchestration
│   │   └── Pipeline.cpp             # MLIR pass pipeline setup
│   ├── build/                       # Build output (helix_engine.lib, helix_tool.exe)
│   └── deps/llvm-mlir/              # LLVM/MLIR libs + engine lib for NAPI linking
├── crates/
│   ├── helix-core/                  # Rust FFI to C++ engine
│   └── hexcore-helix/               # Rust N-API module (.node generation)
├── tools/
│   └── helix-validate/              # Python validation scripts
│       ├── helix_validate.py        # L1-L3 quality scoring
│       └── helix_math_validate.py   # Algebraic + Z3 verification
├── CHANGELOG.md
├── HELIX_PHILOSOPHY.md
└── package.json
```

## 3. Build Process

**ALWAYS use the .bat scripts. Never invoke cmake/ninja manually.**

### Build engine (C++):
```bash
cmd //c "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build-helix.bat"
```
Check: last line must say `EXIT_CODE=0`.

### Build .node (NAPI/Rust) — 3 MANDATORY steps in order:
```bash
# Step 1: Copy fresh engine lib
cmd //c "copy /Y engine\build\helix_engine.lib engine\deps\llvm-mlir\engine\helix_engine.lib"

# Step 2: Clear Rust fingerprints (CRITICAL — skipping = stale .node!)
powershell -Command "Remove-Item -Recurse -Force 'target\x86_64-pc-windows-msvc\release\.fingerprint\helix-core-*' -ErrorAction SilentlyContinue; Remove-Item -Recurse -Force 'target\x86_64-pc-windows-msvc\release\.fingerprint\hexcore-helix-*' -ErrorAction SilentlyContinue"

# Step 3: Build
cmd //c "build_napi.bat"
```
Check: must say `Finished release profile`.

### Deploy to VSCode:
```bash
cmd //c "copy /Y crates\hexcore-helix\hexcore-helix.win32-x64-msvc.node C:\Users\Mazum\Desktop\vscode-main\extensions\hexcore-helix\"
```
**User must close VSCode BEFORE this copy.**

## 4. Key Source Files — What Does What

### C-AST Layer (where most quality work happens)

| File | Lines | Purpose |
|------|-------|---------|
| `CAstBuilder.cpp` | ~3200 | Converts HelixHigh MLIR ops → CStmt/CExpr nodes. Has `detectCompoundOp()` for `+=`/`++` detection. |
| `CAstOptimizer.cpp` | ~7400 | 20+ passes: DCE, copy prop, compound assignment, algebraic simplify, struct field recovery, etc. |
| `CAstPrinter.cpp` | ~800 | Emits C-AST as text. Simple but has the `++`/`--` special case. |
| `CStmt.h` / `CExpr.h` | ~300 | AST node types. |

### MLIR Passes (dialect lowering)

| File | Purpose |
|------|---------|
| `RemillToHelixLow.cpp` | Lifts Remill's memory/register intrinsics to HelixLow ops |
| `HelixLowToMid.cpp` | Promotes registers to variables, builds SSA |
| `HelixMidToHigh.cpp` | Expression recovery, type inference, control flow |
| `StructureControlFlow.cpp` | SCC detection, if/while/switch recovery |

### Analysis
| File | Purpose |
|------|---------|
| `SignatureDb.cpp` | Resolves call targets via signatures + `__hxreloc__` metadata |

## 5. CAstOptimizer Pass Order

The optimizer runs these passes in sequence on each function:

```
1.  removePrologueEpilogue    — strip frame setup/teardown
2.  eliminateInfrastructure   — remove decompiler bookkeeping
3.  eliminateDeadStores       — backward liveness DSE
4.  propagateCopies           — inline single-use temporaries
5.  canonicalizeXorPatterns   — x ^ x → 0, etc.
6.  recoverStructFieldAccess  — ptr+offset → ptr->field
7.  simplifyExpressions       — algebraic identities
8.  synthesizeCompoundAssign  — x = x + y → x += y
9.  resolveFramePointerLeaks  — remove residual RSP/RBP refs
10. removeAdjacentDuplicateStmts
11. removeDeadStoresBeforeReturn
12. collapseAssignBeforeReturn
13. initializeReadBeforeWriteVars
14. declareLocals
15. removeUnusedLocals
```

## 6. Current Defects (from helix-validate, 2026-05-17)

Measured on Linux ftrace rootkit corpus (7 functions):

| Defect | Example | Root Cause | Status |
|--------|---------|-----------|--------|
| **Operand binding loss** | `v5 += v5 + 208` (= 2*v5+208), `*v3 = v3 + v3` x8 | HelixMidToHigh: two SSA values → same VarRef name | **#1 PRIORITY — NOT FIXED** |
| **Relocation data symbols** | `*0x7FFF0038` instead of `__this_module` | SignatureDb resolves calls but not data refs | **NOT FIXED** |
| **Repeated side-effects** | `printk(0, v3)` x3 | Loop with lost operands (consequence of #1) | Blocked by #1 |
| **PC-store leaks** | `var_0 = 0x5ED` | DSE didn't eliminate stores in nested scopes | **FIXED** (DSE gatherFromStmts) |
| **Malformed postinc** | `v1 ++ v1 + 1` | Compound assignment was deleted by GPT | **FIXED** (restored) |

### Validation scores (BEFORE fixes):
```
Function                    Score   Conf%
fh_ftrace_thunk             79.0%   82.0
fh_install_hook              0.0%   74.5
fh_install_hook.cold        24.0%   75.2
fh_install_hooks             0.0%   64.5
hook_read                   57.2%   66.7
hook_syslog                 71.9%   82.0
hook_write                  55.8%   75.2
MEAN                        41.1%
```

## 7. How to Validate Changes

```bash
# Run helix-validate on corpus
python tools/helix-validate/helix_validate.py "C:/Users/Mazum/Desktop/a1b6d665-96d4-4884-bf11-87dff33713d2-1778066531/rev_kernel_monarch/hexcore-reports/02-disasm/"

# Run math-validate on specific function (with Z3 counterexamples)
python tools/helix-validate/helix_math_validate.py <file.helix.c> --mlir-before <file.ll>
```

Compare scores before/after. A change is an **improvement** if:
- helix-validate score goes UP
- Finding count goes DOWN
- No new finding kinds appear

A change is a **regression** if:
- Score goes down OR
- A working pass was removed OR
- Output becomes more verbose without adding information

## 8. CRITICAL Rules

1. **NEVER delete working passes.** If a pass exists and produces output, it was earned through testing. Removing it is a regression.
2. **NEVER edit PseudoCEmitter.cpp** — it's legacy. The Cast layer is the default since v0.8.0.
3. **Always use .bat scripts** for builds. Manual cmake/ninja breaks things.
4. **Clear Rust fingerprints** before building .node. Skipping = stale output.
5. **Measure before AND after** with helix-validate. No eyeball-only evaluation.
6. **Close VSCode** before copying .node.

## 9. Version Bump Checklist

When releasing a new version:
1. `package.json` — version
2. `Cargo.toml` — workspace.package.version
3. `engine/src/Engine.cpp` — version string
4. `CHANGELOG.md` — new entry

## 10. Git Conventions

- Co-author: `Co-authored-by: MayaRomanova <maya@anthropic.com>`
- vscode-main commits use `--no-verify` (pre-commit hook mismatch)
- **DO NOT commit:** `*.bat`, `*.cmd`, `build_out.txt`, `*.helix.c`, `node_modules/`, `target/`, `engine/build/`
