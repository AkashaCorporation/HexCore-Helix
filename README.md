# HexCore Helix

<p align="center">
  <img alt="HexCore Helix Decompiler" src="Angel%20Helix.png" width="840">
</p>

<p align="center">
  <strong>The MLIR-first decompiler engine behind HexCore &mdash; LLVM IR to readable pseudo-C, honest about what it cannot recover.</strong>
</p>

<p align="center">
  <a href="#overview">Overview</a> &middot;
  <a href="#what-helix-does">What It Does</a> &middot;
  <a href="#architecture">Architecture</a> &middot;
  <a href="#the-honesty-layer">Honesty Layer</a> &middot;
  <a href="#build">Build</a> &middot;
  <a href="#engine-direct-cli">CLI</a> &middot;
  <a href="#repository-layout">Layout</a> &middot;
  <a href="#license">License</a>
</p>

<p align="center">
  <img alt="version" src="https://img.shields.io/badge/version-v0.9.2--nightly-b8860b">
  <img alt="engine" src="https://img.shields.io/badge/engine-C%2B%2B23%20%2F%20MLIR%2018-8a6d3b">
  <img alt="lifter" src="https://img.shields.io/badge/lifter-Remill%20(LLVM%20IR)-8a6d3b">
  <img alt="bridge" src="https://img.shields.io/badge/bridge-Rust%20%2F%20N--API-8a6d3b">
  <img alt="license" src="https://img.shields.io/badge/license-Apache--2.0-2e7d32">
</p>

<p align="center">
  <code>decompiler</code> &middot; <code>MLIR</code> &middot; <code>LLVM IR</code> &middot; <code>pseudo-C</code> &middot; <code>Remill</code> &middot; <code>reverse engineering</code> &middot; <code>Win64</code> &middot; <code>type recovery</code> &middot; <code>control-flow structuring</code> &middot; <code>SSA</code>
</p>

---

## Overview

**Helix** is the decompiler engine inside [HexCore](https://github.com/AkashaCorporation/HikariSystem-HexCore). It takes lifted LLVM IR (from a patched Remill fork), lowers it through three custom **MLIR dialects**, and emits readable pseudo-C with calling-convention recovery, stack reconstruction, variable naming, type propagation, and control-flow structuring.

Helix is **MLIR-first** &mdash; it does not fork Remill, it *wraps* it:

```
LLVM IR  ->  RemillToHelixLow  ->  HelixLow  ->  HelixMid  ->  HelixHigh  ->  C-AST  ->  pseudo-C
```

The whole pipeline runs natively in C++23. It ships into the HexCore IDE as a pre-built N-API `.node` (via a Rust/napi-rs bridge), and also runs standalone through the `helix_tool` CLI for engine-direct work.

The guiding principle is **fidelity over polish**: correct C, or an *honestly flagged* approximation when the lift cannot be trusted &mdash; never a clean-looking lie. See [The Honesty Layer](#the-honesty-layer).

> **Status:** `v0.9.2-nightly`. The engine is in active development toward a stable `v0.9.2` cut (the *honesty layer*); the architectural `v1.0` track (MemEffects-based DCE, universal op semantics, full structured-CFG recovery) runs alongside and does not gate the stable cut. See [CHANGELOG](CHANGELOG.md).

---

## What Helix Does

- Lowers Remill-generated **LLVM IR** through a **3-tier MLIR dialect pipeline** (HelixLow &rarr; HelixMid &rarr; HelixHigh)
- Recovers **stack layout**, parameters, locals, and variable intent (Win64 / SysV / cdecl auto-detection)
- Reconstructs **direct, vtable, and recursive calls**; gates fabricated call names against the function table
- Propagates **types** across function boundaries to a fixed point
- Simplifies flags and comparisons into readable conditions
- Reverses compiler optimizations (magic division, strength reduction)
- **Structures control flow** &mdash; if / else / while / switch &mdash; before emission, with irreducible-loop handling
- Resolves recovered **code addresses to symbols** instead of leaking them as bare data
- Scores each function with an **honest confidence** that tracks correctness, not just surface plausibility
- Emits pseudo-C through a C-AST layer and the standalone **`helix_tool`**

---

## Architecture

Helix lowers through three MLIR dialects, then builds a C abstract syntax tree and prints it.

| Tier | Dialect | Responsibility |
|------|---------|----------------|
| **1** | **HelixLow** | Machine-level semantics &mdash; `reg.read`/`reg.write`, `mem.read`/`mem.write`, flags, raw control flow. Direct lowering of Remill IR. |
| **2** | **HelixMid** | ISA-agnostic **typed SSA** &mdash; registers become typed variable slots, flags become comparisons, `REP MOVS`/`STOS` become `memcpy`/`memset`. |
| **3** | **HelixHigh** | C-level &mdash; `var.decl` with storage class, structured control flow, typed expressions. |
| **&mdash;** | **C-AST** | `HelixHigh` &rarr; C abstract syntax tree &rarr; printed pseudo-C. Owns the honesty gates and the optimizer passes. |

### Pass pipeline (selected)

1. `RemillToHelixLow` &mdash; Remill IR lowering and per-instruction address tracking
2. `RecoverStackLayout` &mdash; Win64 stack parameter and local reconstruction
3. `RecoverCallingConvention` &mdash; ABI argument materialization
4. `PropagateTypes` / `InterProceduralTypePropagation` &mdash; intra- and cross-function type inference to fixed point
5. `StructureControlFlow` &mdash; CFG structuring with irreducible-loop handling
6. `RecoverVariables` / `EliminateDeadCode` &mdash; register-noise reduction and dead-code elimination
7. `HelixLowToMid` &mdash; machine-level &rarr; ISA-agnostic typed SSA
8. `RecoverMagicDivision` &mdash; reverses `(x * magic) >> shift` back to `x / divisor`
9. `DevirtualizeIndirectCalls` &mdash; vtable dataflow analysis
10. `HelixMidToHigh` &mdash; typed SSA &rarr; C source-level representation
11. **C-AST optimizer** &mdash; dead-store elimination, copy propagation, compound-assignment folding, struct-field recovery, semantic naming, confidence scoring

The Rust workspace provides shared types, the FlatBuffers transport, and the napi-rs bridge that exposes the engine to the HexCore IDE.

See [ARCHITECTURE.md](ARCHITECTURE.md) for the full design.

---

## The Honesty Layer

Most decompilers optimize for *clean-looking* output. Helix optimizes for *trustworthy* output: when a lift is ambiguous, Helix says so in-band instead of fabricating something plausible. The blocker to a stable cut is a small set of honesty guarantees:

| Class | Guarantee |
|-------|-----------|
| **D1** | A recovered **code address never leaks as a bare data constant** (`var = 0x401050;`). It resolves to a label or an honest code-pointer cast. |
| **D2** | A call target **not in the function table** is emitted as an honest indirect call `(*(code *)0xADDR)(...)`, never a fabricated `sub_XXX` symbol. |
| **D3** | **Unreachable code** is removed and located-marked, never silently shown as live. |
| **D4** | **Confidence tracks honesty.** A function carrying a damning defect (a leaked code address, an out-of-table call) is hard-capped &mdash; it is not allowed to self-report as plausible. |
| **#30** | No **silent high-confidence stub** for an address that did not actually lift. |

These live in the C-AST layer as one authoritative function/block-address registry plus located honest markers &mdash; a focused honesty pass, not a rewrite.

A concrete example &mdash; the same function before and after the D4 gate:

```diff
- // Confidence: 60.5% (Medium)
+ // Confidence: 50.0% (Low)
+ // Issues: ... damning honesty defect (code-address leak or out-of-table call) - confidence capped at 50%
```

The decompiler refuses to claim *Medium* confidence on a function that leaked a code address, and tells you exactly why.

---

## Build

### Prerequisites

- A **C++23** toolchain (MSVC 2022 / clang-cl on Windows)
- **LLVM + MLIR 18** (an MLIR-enabled LLVM build)
- **CMake 3.20+** and **Ninja**
- **Rust** stable (for the napi-rs bridge)
- **Node.js 18+** (only for the N-API `.node` build)

### Build the engine + CLI

```bash
cmake -S engine -B engine/build -G Ninja \
  -DLLVM_DIR=/path/to/llvm/lib/cmake/llvm \
  -DMLIR_DIR=/path/to/llvm/lib/cmake/mlir
cmake --build engine/build --config Release
```

This produces `engine/build/helix_tool.exe` (the engine-direct CLI) and the `helix_engine` static library.

### Build and run the tests

```bash
cmake -S engine -B engine/build-tests -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build engine/build-tests --config Release
./engine/build-tests/test/helix_tests.exe
```

### Check the Rust bridge

```bash
LLVM_DIR=/path/to/llvm/lib/cmake/llvm cargo check -p helix-core -p hexcore-helix
```

---

## Engine-direct CLI

`helix_tool` runs the full pipeline on a single `.ll` and prints pseudo-C &mdash; the fastest way to validate a change without the IDE.

```bash
./engine/build/helix_tool.exe --use-cast-layer path/to/function.ll
```

- `--use-cast-layer` routes through the C-AST layer (the default emission path; honesty gates and the optimizer run here).
- Always feed a **fresh** `.ll` lifted by the current Remill &mdash; a stale dump invalidates the result.

---

## Repository Layout

```text
HexCore-Helix/
|- engine/                 C++23 decompiler engine, MLIR dialects, C-AST layer, helix_tool CLI, tests
|- crates/                 Rust workspace (helix-core) and the hexcore-helix napi-rs bridge
|- schemas/                FlatBuffers schemas (engine <-> IDE transport)
|- signatures/             Optional address / name databases
|- tests/                  Real decompilation fixtures and reports
|- ARCHITECTURE.md         Architectural overview
|- CHANGELOG.md            Release notes
`- roadmap.md              Near-term roadmap
```

---

## Relationship to HexCore

Helix is one of HexCore's native engines. Inside the IDE the decompilation pipeline runs:

```
machine code  ->  Pathfinder CFG hints  ->  Remill lift  ->  LLVM IR  ->  Helix (this repo)  ->  pseudo-C
```

End users receive Helix as a pre-built `.node` &mdash; no compilation needed. This repository is where the engine itself is developed, gated, and benchmarked against a real-world corpus (Linux kernel modules, large Win64 game binaries, obfuscated malware, and CTF VMs).

---

## Documentation

- [Architecture](ARCHITECTURE.md)
- [Changelog](CHANGELOG.md)
- [Roadmap](roadmap.md)

---

## License

Apache License 2.0. See [LICENSE](LICENSE) for details.

---

<p align="center">
  <strong>HexCore Helix</strong> &mdash; a decompiler that tells you the truth.
</p>
