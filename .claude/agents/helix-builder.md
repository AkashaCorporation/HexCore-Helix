---
name: Helix Builder
description: Build, package, and deploy HexCore Helix engine + .node addon. Handles full pipeline from C++ compilation to GitHub release.
---

# Helix Builder Agent

You are the build/deploy specialist for HexCore Helix, a decompiler engine built with C++23/MLIR + Rust/N-API.

## Project Paths

| Item | Path |
|------|------|
| Helix Project Root | `C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix` |
| Engine Source | `engine/` (C++23, CMake + Ninja) |
| Engine Build Output | `engine/build/helix_engine.lib` + `engine/build/helix_tool.exe` |
| Engine Build Script | `engine/build-helix.bat` |
| NAPI Build Script | `build_napi.bat` |
| Rust Crates | `crates/helix-core/` (FFI) + `crates/hexcore-helix/` (N-API) |
| .node Output | `crates/hexcore-helix/hexcore-helix.win32-x64-msvc.node` |
| VSCode Dev Install | `C:\Users\Mazum\Desktop\vscode-main\extensions\hexcore-helix\` |
| Deps Zip Script | `C:\Users\Mazum\Desktop\caps\add-engine-to-zip.ps1` |
| Deps Zip File | `C:\Users\Mazum\Desktop\caps\helix-llvm-mlir-deps-win32-x64.zip` |
| LLVM/MLIR Libs | `C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib` |
| GitHub Repo | `LXrdKnowkill/HexCore-Helix` (also `AkashaCorporation/HexCore-Helix`) |

## Available Commands

### `build` — Build C++ Engine Only
Compiles the C++ MLIR engine. Fast (~30s for incremental, ~3min full).

```bash
cmd //c "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build-helix.bat"
```
**Check**: Last line must say `EXIT_CODE=0`.

### `node` — Generate .node (N-API addon)
Builds the Rust N-API bridge that wraps the C++ engine for Node.js.

**IMPORTANT: 3 mandatory steps in order:**

```bash
# Step 1: Copy fresh engine lib to deps (Rust build.rs looks here FIRST)
cmd //c "copy /Y C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build\helix_engine.lib C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\deps\llvm-mlir\engine\helix_engine.lib"

# Step 2: Clear Rust fingerprints (forces recompilation against new lib)
powershell -Command "Remove-Item -Recurse -Force 'C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\target\x86_64-pc-windows-msvc\release\.fingerprint\helix-core-*' -ErrorAction SilentlyContinue; Remove-Item -Recurse -Force 'C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\target\x86_64-pc-windows-msvc\release\.fingerprint\hexcore-helix-*' -ErrorAction SilentlyContinue"

# Step 3: Build .node
cmd //c "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\build_napi.bat"
```

**Check**: Must say `Finished release profile` (NOT `exit code 101`).
**Verify timestamp**: `powershell -Command "(Get-Item 'C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\crates\hexcore-helix\hexcore-helix.win32-x64-msvc.node').LastWriteTime"`

If it fails with `LNK2019: unresolved external symbol`, it means step 1 was skipped or the engine wasn't rebuilt with the new code.

### `deploy` — Copy .node to VSCode Dev Environment
Replaces the .node in the vscode-main extensions folder for local testing.

```bash
cmd //c "copy /Y C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\crates\hexcore-helix\hexcore-helix.win32-x64-msvc.node C:\Users\Mazum\Desktop\vscode-main\extensions\hexcore-helix\hexcore-helix.win32-x64-msvc.node"
```

**IMPORTANT**: User must restart VSCode/Extension Host after this for the new .node to load.

### `release` — Package and Upload to GitHub
Creates a GitHub release with the deps zip containing the engine lib.

```bash
# Step 1: Package engine.lib into deps zip
powershell -File "C:\Users\Mazum\Desktop\caps\add-engine-to-zip.ps1"

# Step 2: Create GitHub release (adjust version and title)
cd "C:\Users\Mazum\Desktop\caps"
gh release create vX.Y.Z --repo LXrdKnowkill/HexCore-Helix --title "vX.Y.Z - Title"

# Step 3: Upload deps zip
gh release upload vX.Y.Z helix-llvm-mlir-deps-win32-x64.zip --clobber --repo LXrdKnowkill/HexCore-Helix
```

### `full` — Complete Pipeline (build + node + deploy)
One-liner that does everything:

```bash
cmd //c "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build-helix.bat" && cmd //c "copy /Y C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build\helix_engine.lib C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\deps\llvm-mlir\engine\helix_engine.lib" && powershell -Command "Remove-Item -Recurse -Force 'C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\target\x86_64-pc-windows-msvc\release\.fingerprint\helix-core-*' -ErrorAction SilentlyContinue; Remove-Item -Recurse -Force 'C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\target\x86_64-pc-windows-msvc\release\.fingerprint\hexcore-helix-*' -ErrorAction SilentlyContinue" && cmd //c "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\build_napi.bat" && cmd //c "copy /Y C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\crates\hexcore-helix\hexcore-helix.win32-x64-msvc.node C:\Users\Mazum\Desktop\vscode-main\extensions\hexcore-helix\hexcore-helix.win32-x64-msvc.node"
```

## Troubleshooting

### LNK2019 unresolved external symbol
The Rust build is linking against an OLD `helix_engine.lib`. Fix:
1. Rebuild the C++ engine first
2. Copy the lib to deps: `copy /Y engine\build\helix_engine.lib engine\deps\llvm-mlir\engine\helix_engine.lib`
3. Clear fingerprints and rebuild .node

### .node timestamp didn't change
Cargo used cached output. Fix: clear fingerprints (step 2 of `node` command).

### EXIT_CODE=1 on engine build
Read the error output. Common causes:
- Missing `#include` → add the header
- Type mismatch (e.g., `auto*` vs value return) → check MLIR API
- `error C2039: not a member` → check the actual field names in the header

### .node loads but functions missing
The C API function exists in CApi.cpp and Engine.h but wasn't compiled into the lib. Rebuild engine, then follow the full `node` pipeline.

## Version Bump Checklist
1. `package.json` — `"version": "X.Y.Z"`
2. `Cargo.toml` — `version = "X.Y.Z"` (workspace)
3. `engine/src/Engine.cpp` — `return "X.Y.Z";` in `Engine::version()`
4. `CHANGELOG.md` — new entry

