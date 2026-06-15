# HexCore Helix — Architecture

## Design Philosophy

The Helix engine is built around three principles:

1. **Isolation by Contract** — Every layer boundary is defined by a strict contract (C API, Rust traits, FlatBuffers schemas). No layer leaks implementation details.
2. **Progressive Enhancement** — Each phase adds capability without breaking existing interfaces. The engine returns valid (if incomplete) results from day one.
3. **Sovereignty** — No external runtime dependencies at execution time. Everything is statically linked. The engine is a single `.node` file.

## Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                      HexCore IDE (VS Code)                       │
│                                                                   │
│  ┌─────────────┐    ┌──────────────┐    ┌────────────────────┐   │
│  │ Graph View  │    │ Source View  │    │ Automation Runner  │   │
│  │ (CFG)       │    │ (Pseudo-C)   │    │ (Headless)         │   │
│  └──────┬──────┘    └──────┬───────┘    └─────────┬──────────┘   │
│         │                  │                      │               │
│         └──────────┬───────┴──────────────────────┘               │
│                    │                                              │
│              ┌─────▼─────┐                                       │
│              │  index.js  │  Platform auto-loader                 │
│              └─────┬──────┘                                      │
└────────────────────┼─────────────────────────────────────────────┘
                     │ require()
┌────────────────────┼─────────────────────────────────────────────┐
│  hexcore-helix     │  (NAPI-RS cdylib)                           │
│              ┌─────▼──────┐                                      │
│              │ engine.rs   │  HelixEngine class                   │
│              │ #[napi]     │  Marshals JS ↔ Rust types            │
│              └─────┬───────┘                                     │
│                    │                                              │
│              ┌─────▼──────┐                                      │
│              │transport.rs│  FlatBuffer ↔ Buffer conversion       │
│              └─────┬──────┘                                      │
└────────────────────┼─────────────────────────────────────────────┘
                     │ helix-core types
┌────────────────────┼─────────────────────────────────────────────┐
│  helix-core        │  (Pure Rust library)                        │
│              ┌─────▼──────┐                                      │
│              │ pipeline.rs │  Lifter → Passes → Emitter           │
│              └─────┬───────┘                                     │
│                    │                                              │
│              ┌─────▼──────┐                                      │
│              │  ffi.rs     │  EngineHandle (safe wrapper)         │
│              │  extern "C" │  Opaque pointers                     │
│              └─────┬───────┘                                     │
└────────────────────┼─────────────────────────────────────────────┘
                     │ C ABI
┌────────────────────┼─────────────────────────────────────────────┐
│  C++23 Engine      │                                              │
│              ┌─────▼──────┐                                      │
│              │  CApi.cpp   │  extern "C" implementation            │
│              └─────┬───────┘                                     │
│                    │                                              │
│              ┌─────▼──────┐                                      │
│              │ Engine.cpp  │  helix::Engine class                  │
│              │             │  → Remill (lift to LLVM IR)           │
│              │             │  → MLIR (progressive lowering)        │
│              │             │  → FlatBuffer (serialize output)      │
│              └─────────────┘                                     │
└──────────────────────────────────────────────────────────────────┘
```

## Boundary Contracts

### 1. C++ ↔ Rust (C API)

The contract is defined in `engine/include/helix/Types.h` and `engine/include/helix/Engine.h`:

- **Opaque Handle Pattern**: The C++ engine is accessed through `HelixEngineHandle*`, a pointer to an opaque type. Rust never sees the C++ class internals.
- **Status Codes**: All functions return `HelixStatus` (i32), matching `helix_core::error::HelixStatus`.
- **Memory Ownership**: The C++ side owns all engine memory. Rust calls `helix_engine_destroy()` in `Drop`.
- **Output via Pre-allocated Buffer**: `helix_engine_decompile()` writes FlatBuffer data into a caller-provided buffer, avoiding cross-language allocation.

### 2. Rust ↔ Node.js (NAPI-RS)

- **`#[napi]` Classes**: Rust structs become JS classes. `HelixEngine` is the main entry point.
- **`Buffer` for Binary Data**: FlatBuffer payloads are passed as Node.js `Buffer` objects (shared memory, no copy).
- **BigInt for Addresses**: 64-bit addresses use JS `BigInt` to avoid precision loss.
- **Error Mapping**: `HelixError` → JS `Error` with descriptive messages.

### 3. Engine ↔ UI (FlatBuffers)

- **Schemas**: `schemas/cfg.fbs` and `schemas/ast.fbs` define the wire format.
- **File Identifiers**: `HCFG` (CFG) and `HAST` (AST) for runtime type checking.
- **Zero-Copy Access**: The UI can read fields directly from the buffer without parsing the entire structure.

## Design Decisions

### Why C API instead of C++ FFI?

C++ ABI is unstable across compilers and even versions. Using `extern "C"` ensures:
- Compatible with any C++ compiler (MSVC, GCC, Clang)
- No name mangling issues
- Same pattern used by LLVM, SQLite, and every major native library
- The Rust `cc`/`cmake` crate integrates seamlessly

### Why separate helix-core from hexcore-helix?

`helix-core` is a pure Rust library with **zero Node.js dependencies**. This enables:
- Standalone CLI tools for batch decompilation
- Unit testing without V8 overhead
- Potential future frontends (web server, GUI, etc.)
- Clear dependency graph (no circular deps)

### Why FlatBuffers over Protocol Buffers?

- **Zero-copy read**: FlatBuffers can be read directly from the buffer (711ns vs 7045ns for JSON)
- **No parsing step**: Critical for rendering large CFGs in real-time
- **Memory-mapped access**: Future support for `mmap`-based file caching
- **Smaller footprint**: No runtime library needed on the read side

### Why Rust for the bridge instead of pure C++ Node addon?

- **Memory safety**: V8 GC + raw C++ pointers = crashes. Rust's ownership model prevents use-after-free.
- **NAPI-RS ergonomics**: Type-safe marshalling, automatic TypeScript declarations
- **Cross-compilation**: NAPI-RS handles multi-platform binary distribution
- **Existing HexCore pattern**: The project already uses native addons (Capstone, Unicorn, better-sqlite3)
