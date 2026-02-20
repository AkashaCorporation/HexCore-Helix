# HexCore Helix

> **Next-generation decompilation engine** — Rust + C++23/MLIR + FlatBuffers

[![CI](https://github.com/LXrdKnowkill/HexCore-Helix/actions/workflows/build.yml/badge.svg)](https://github.com/LXrdKnowkill/HexCore-Helix/actions/workflows/build.yml)

## Architecture

```mermaid
graph TB
    subgraph "VS Code / HexCore IDE"
        UI["HexCore UI<br>(Webview)"]
        EXT["hexcore-disassembler<br>(TypeScript)"]
    end

    subgraph "@hexcore/helix (NAPI-RS)"
        BRIDGE["hexcore-helix<br>NAPI-RS Bridge"]
        TYPES["helix-core<br>Rust Types & Traits"]
    end

    subgraph "Helix Engine (C++23)"
        CAPI["C API<br>(extern C)"]
        ENGINE["Engine Core"]
        MLIR["MLIR Dialects<br>& Passes"]
        REMILL["Remill Lifter<br>(LLVM 18)"]
    end

    subgraph "Transport"
        FB["FlatBuffers<br>(Zero-Copy)"]
    end

    UI -->|"commands"| EXT
    EXT -->|"require()"| BRIDGE
    BRIDGE -->|"Rust types"| TYPES
    TYPES -->|"FFI"| CAPI
    CAPI --> ENGINE
    ENGINE --> MLIR
    ENGINE --> REMILL
    ENGINE -->|"serialize"| FB
    FB -->|"zero-copy Buffer"| BRIDGE
    BRIDGE -->|"Buffer"| UI
```

## Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Lifting** | Remill (LLVM 18) | Machine code → LLVM IR |
| **Core Logic** | C++23 + MLIR | Custom dialects for progressive decompilation |
| **Safety Bridge** | Rust + NAPI-RS | Memory-safe bridge to Node.js/VS Code |
| **Transport** | FlatBuffers | Zero-copy IPC between engine and UI |

## Project Structure

```
HexCore-Helix/
├── Cargo.toml                 # Rust workspace root
├── package.json               # NPM package (@hexcore/helix)
├── index.js                   # Native binary auto-loader
├── index.d.ts                 # TypeScript declarations
├── crates/
│   ├── helix-core/            # Pure Rust library (types, traits, FFI)
│   │   └── src/
│   │       ├── lib.rs         # Module root
│   │       ├── types.rs       # Address, Instruction, CFG, etc.
│   │       ├── ast.rs         # Decompiled AST nodes
│   │       ├── pipeline.rs    # Lifter/TransformPass/Emitter traits
│   │       ├── ffi.rs         # C++ FFI boundary
│   │       └── error.rs       # Error types
│   └── hexcore-helix/         # NAPI-RS bridge (Node.js ↔ Rust)
│       └── src/
│           ├── lib.rs         # Module root
│           ├── engine.rs      # HelixEngine JS class
│           └── transport.rs   # FlatBuffer serialization
├── engine/                    # C++23 engine
│   ├── CMakeLists.txt         # CMake build (C++23, optional LLVM/MLIR)
│   ├── include/helix/
│   │   ├── Engine.h           # Engine class + C API
│   │   └── Types.h            # FFI-safe types
│   └── src/
│       ├── Engine.cpp         # Engine implementation
│       └── CApi.cpp           # C API bridge
├── schemas/                   # FlatBuffers schemas
│   ├── common.fbs             # Shared types
│   ├── cfg.fbs                # Control Flow Graph
│   └── ast.fbs                # Abstract Syntax Tree
└── .github/workflows/
    └── build.yml              # CI/CD pipeline
```

## Quick Start

### Prerequisites

- **Rust** (stable, via `rustup`)
- **Node.js** ≥ 22
- **CMake** ≥ 3.20
- **C++23 compiler** (MSVC 2022, GCC 13+, or Clang 16+)

### Foundation Baseline (2026)

- **Node runtime policy**: Node 22+ only (avoid EOL runtime drift).
- **NAPI-RS**: `napi` 3.x + `napi-derive` 3.x.
- **Transport**: FlatBuffers 25.x runtime.
- **ABI guardrails**: `helix-core` includes explicit contract tests for `ArchKind` and `HelixStatus`.

### Build

```bash
# Install npm dependencies
npm install

# Build C++ engine
cmake -B engine/build -S engine -DCMAKE_BUILD_TYPE=Release
cmake --build engine/build --config Release

# Build NAPI-RS native module
npm run build

# Verify Rust code
cargo check --workspace
cargo clippy --workspace
```

### Optional: Signature DB (CRT/Win32 naming)

Helix can rename recovered call targets from a CSV address database:

```csv
# signatures/windows_crt_win32.csv
0x140123456,CreateFileW,HANDLE
0x140123500,CloseHandle,BOOL
0x140123980,memcpy,void*
```

Lookup order:
- `signatures/windows_crt_win32.csv`
- `signatures/signatures.csv`
- `signatures.csv`

### Usage (TypeScript)

```typescript
import { HelixEngine, Architecture } from '@hexcore/helix';

const engine = new HelixEngine(Architecture.X86_64);
const binary = fs.readFileSync('target.exe');

const result = engine.decompile(binary, 0x400000n, 0x401000n);
console.log(result.source);
console.log(`Blocks: ${result.blockCount}, Instructions: ${result.instructionCount}`);

engine.dispose();
```

## Roadmap

- [x] **Phase 1**: Foundation & Safety Bridge (Rust + NAPI-RS + C++ scaffold)
- [ ] **Phase 2**: MLIR Engine (Custom dialects, Remill integration)
- [ ] **Phase 3**: FlatBuffers Transport (Zero-copy CFG/AST)
- [ ] **Phase 4**: HexCore IDE Integration
- [ ] **Phase 5**: Stabilization & Audit

## License

MIT — HexCore Project
