# HexCore Helix

Helix is the decompiler engine behind HexCore. It takes lifted LLVM IR, lowers it through custom MLIR dialects, and emits readable pseudo-C with calling convention recovery, stack reconstruction, variable naming, and control-flow cleanup.

This repository is public and tracks the real engine work. The focus is practical output quality: cleaner pseudo-C, better Win64 recovery, fewer synthetic temporaries, and a direct path into the HexCore IDE.

## What Helix Does

- Lifts machine code through Remill-generated LLVM IR
- Lowers IR into Helix-specific MLIR dialects
- Recovers stack layout, parameters, locals, and variable intent
- Reconstructs direct calls, vtable calls, and recursive calls
- Simplifies flags and comparisons into readable conditions
- Structures as much control flow as possible before emission
- Emits pseudo-C through the standalone `helix_tool`

## Current Focus

As of March 2026, the C++23/MLIR pipeline is the primary backend.

- `RemillToHelixLow` handles Remill IR lowering and address tracking
- `RecoverStackLayout` reconstructs Win64 stack parameters and locals
- `RecoverCallingConvention` materializes real call arguments
- `StructureControlFlow` turns CFG regions into structured flow where possible
- `RecoverVariables` and `EliminateDeadCode` reduce register noise
- `PseudoCEmitter` formats the final pseudo-C and suppresses obvious artifacts

The Rust workspace remains part of the project for shared types, transport, and IDE-facing integration.

## Repository Layout

```text
HexCore-Helix/
|- engine/                 C++23 decompiler engine, MLIR dialects, CLI, tests
|- crates/                 Rust workspace and NAPI bridge
|- schemas/                FlatBuffers schemas
|- signatures/             Optional address/name databases
|- tests/                  Real decompilation fixtures and reports
|- ARCHITECTURE.md         Architectural overview
|- CHANGELOG.md            Release notes
`- roadmap.md              Near-term roadmap
```

## Build

### Prerequisites

- Rust stable
- Node.js 22+
- CMake 3.20+
- A C++23 toolchain
- LLVM/MLIR 18 compatible with the engine build

### Build the Engine

```bash
cmake -B engine/build -S engine -DCMAKE_BUILD_TYPE=Release
cmake --build engine/build --config Release
```

### Run the CLI

```bash
./engine/build/helix_tool.exe tests/remill-7/bone_pos_calc9.ll
```

### Build and Run Tests

```bash
cmake -B engine/build-tests -S engine -DCMAKE_BUILD_TYPE=Release
cmake --build engine/build-tests --config Release
./engine/build-tests/test/Release/helix_tests.exe
```

For focused regression work, `Remill7IntegrationTest` is the main suite that pins down real-world emitter and recovery improvements.

## Test Corpus

The `tests/` directory contains lifted IR and reports used to evaluate output quality.

- `tests/remill-7/` contains the current real-world regression corpus
- `tests/reports/` contains benchmarking and comparison notes

These fixtures are intentionally small and targeted. They exist to make regressions in emitted pseudo-C obvious.

## Public Repository Notes

- Generated decompilation outputs and debug logs are not part of the repository surface
- The public repo should contain source, fixtures, documentation, and reproducible tests
- Experimental local artifacts should stay ignored unless they become stable fixtures

## Documentation

- [Architecture](ARCHITECTURE.md)
- [Changelog](CHANGELOG.md)
- [Roadmap](roadmap.md)

## License

MIT
