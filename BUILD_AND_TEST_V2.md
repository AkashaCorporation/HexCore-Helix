# Build & Test — HexCore-Helix-v2

**This supersedes the root `BUILD_GUIDE.md` for this repo.** That guide
points at `HexCore-Helix-Original\HexCore-Helix` (the legacy repo — see
[ECOSYSTEM_MAP.md](ECOSYSTEM_MAP.md)) and uses an `npm run build` flow that
is NOT what this repo (`v2`) actually uses day to day. If you're working in
`HexCore-Helix-v2`, use this doc, not that one.

## Prerequisites (same as before, unchanged)

- Visual Studio 2022 (C++ Desktop Development workload)
- LLVM/MLIR prebuilt at `C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir`
- Rust (stable), Ninja, CMake 3.20+, Node.js v18+

## The standard build loop (`build_node_fix097.bat`)

From `HexCore-Helix-v2` root:

```
.\build_node_fix097.bat
```

What it actually does (read `build_node_fix097.bat` in the repo root for
the literal commands — this is the summary):

1. `ninja -C engine\build helix_engine.lib` — rebuilds the C++ MLIR engine
   static lib. **This is the step that picks up your `engine/src/passes/*.cpp`
   changes.** If this step fails, nothing downstream matters — fix the
   compile error first.
2. `copy /Y engine\build\helix_engine.lib engine\deps\llvm-mlir\engine\helix_engine.lib`
   — this copy is load-bearing (FIX-097): Cargo's build script picks up the
   lib from the `deps\llvm-mlir\engine\` copy, not the fresh one in
   `engine\build\` directly. Skipping this step silently links a STALE
   engine into your `.node` — you'll rebuild, see no behavior change, and
   waste an hour before realizing the lib copy never happened. Always let
   the script do this, don't skip straight to step 3.
3. `cargo build --release -p hexcore-helix` — builds the Rust NAPI cdylib.
   Output: `target\release\hexcore_helix.dll`.

The script now computes the copied library's SHA-256 into
`HELIX_ENGINE_LIB_HASH`; `crates/helix-core/build.rs` tracks that environment
value. This is required because Cargo can miss a rapid same-path `.lib`
replacement by timestamp and otherwise report success without relinking the
addon. A C++-only change must show `Compiling helix-core`/`hexcore-helix` when
the hash changes. Do not remove this fingerprint.

Expect ~20-60s incremental (only touched `.cpp` files recompile), longer on
a clean build.

## Tagging convention for `.node` builds

`target\release\hexcore_helix.dll` gets overwritten every build. Before you
lose a build you want to A/B against later, copy it to a **tagged** name:

```bash
cp target/release/hexcore_helix.dll target/release/hexcore-helix.<short-tag>.node
```

Pick a tag that says what's IN this build relative to the last one (e.g.
`phase35fix1`, `structtype1`, `det6-final` — see the many examples already
sitting in `target/release/` from past sessions). This is how A/B
comparisons and regression bisection work in this codebase — there is no
other build-history mechanism, so don't skip it when you're mid-
investigation. `target/release/*.node` is gitignored, so these accumulate
freely without polluting git history; feel free to leave old tagged builds
around, they cost disk not risk.

## Swapping into the IDE

The IDE (`vscode-main`) loads the `.node` from a fixed path:

```
C:\Users\Mazum\Desktop\vscode-main\extensions\hexcore-helix\hexcore-helix.win32-x64-msvc.node
```

To swap a new build in:

```bash
# Close VS Code first — the DLL is locked while VS Code has it loaded.
cp target/release/hexcore-helix.<your-tag>.node \
   "C:/Users/Mazum/Desktop/vscode-main/extensions/hexcore-helix/hexcore-helix.win32-x64-msvc.node"
```

**Before overwriting, back up whatever's currently there** if you're not
certain it's already captured as a tagged build elsewhere:

```bash
cp "C:/Users/Mazum/Desktop/vscode-main/extensions/hexcore-helix/hexcore-helix.win32-x64-msvc.node" \
   "C:/Users/Mazum/Desktop/vscode-main/extensions/hexcore-helix/hexcore-helix.win32-x64-msvc.node.bak-<date>-<reason>"
```

**Verify the swap actually took** (Windows file copies can silently no-op
if the destination is locked/in-use):

```bash
sha256sum target/release/hexcore-helix.<your-tag>.node \
  "C:/Users/Mazum/Desktop/vscode-main/extensions/hexcore-helix/hexcore-helix.win32-x64-msvc.node"
```

Both hashes must match. Check `CURRENT_STATE.md` for which tagged build is
currently live in the IDE right now before you assume a stale one.

## Validation harnesses (all in `c++\NUCLEO\bench\`)

These are the tools that turn "I made a change" into "I proved the change
does what I think it does."

### SCF source-legalization lanes

With the C-AST emitter active, native `scf.if`, `scf.index_switch`, and the
canonical `scf.while` family legalize directly at the C-AST boundary by
default. No environment variable is required. For a controlled comparison
against the former High synthetic-variable bridge, set:

```bat
set "HELIX_LEGACY_SCF_BRIDGE=1"
```

`HELIX_DIRECT_SCF_TO_CAST=0` is retained as a compatibility override, but
prefer the explicitly named legacy flag in new harnesses. In `cmd.exe`, quote
`set "NAME=value"`: `set NAME= && ...` can leave a single-space value that the
boolean parser correctly treats as enabled.

### `det_inproc.cjs` — determinism oracle

Loads the engine once, decompiles the same lifted IR K times in-process. A
deterministic engine returns byte-identical output every time; if it
doesn't, something in your change (or a pre-existing bug) depends on
iteration order / memory addresses / uninitialized state. Required after
any change touching pass ordering or IR-walk/coalescing logic — see
WORKFLOW_AND_DISCIPLINE.md §4.

### `batch_decompile.cjs` — corpus regression pass

Runs a batch of NUCLEO functions (the ~80-fn sample referenced across past
sessions) through a given `.node`, `HELIX_NODE`/`HELIX_OUT` env-configurable.
Use this to check a change didn't quietly drop confidence or break output
on functions unrelated to what you were targeting.

### `decompile_ll.cjs` — single-function ad-hoc testing (new, added here)

```bash
node c++/NUCLEO/bench/decompile_ll.cjs <ABSOLUTE-path-to.node> <path-to.ll> <out.c>
```

Feeds an existing `.ll` file straight into `HelixEngine.decompileIr()` —
the fastest way to re-test one specific function against multiple `.node`
builds without re-lifting from the binary each time. The `.node` path MUST
be absolute (relative paths fail Node's `require()` resolution depending on
cwd). Real `.ll` samples to test against already exist under
`HexCore-LARA\hexcore-reports\*\*.ll` and
`Intigrity\hexcore-reports*\*\*.ll` — real production/bounty binaries, not
synthetic cases, which is exactly what caught the Phase 3.5 gap (see
`CURRENT_STATE.md`).

### Engine-direct harnesses (no VS Code host)

For ARM/other-arch targets or when you want to avoid VS Code's OOM ceiling,
there's a pattern of engine-direct scripts that shim `require('vscode')`
and call `DisassemblerEngine → RemillLifter → HelixEngine.decompileIr`
directly (see `BugBounty\Samsung\native\hexcore_out\run_videoengine_one.cjs`
for the canonical template, or `decompile_ll.cjs` above for the simplest
version once you already have a `.ll`).

## Running the C++ unit test suite (gtest)

This is a **separate build directory and a separate CMake config** from the
day-to-day `engine\build` used by `build_node_fix097.bat` — don't confuse
the two, and don't expect `ninja -C engine\build helix_tests` to work (it
won't; that target doesn't exist in the normal config).

```bat
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
set LLVM_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\llvm
set MLIR_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\mlir
cmake -S engine -B engine\build-tests -G Ninja -DCMAKE_BUILD_TYPE=Release ^
  -DLLVM_DIR=%LLVM_DIR% -DMLIR_DIR=%MLIR_DIR% -DHELIX_BUILD_TESTS=ON
ninja -C engine\build-tests helix_tests
engine\build-tests\test\helix_tests.exe
```

Two gotchas that will burn you if you skip them:

- **`-DHELIX_BUILD_TESTS=ON` is required** (default `OFF` — see
  `engine/CMakeLists.txt` ~line 464). Without it, `cmake --build` "succeeds"
  but never even defines the `helix_tests` target, so `ninja ... helix_tests`
  fails with "unknown target" and it looks like something's badly broken
  when it's just this one flag.
- **The `cmake` configure AND the `ninja` build must run in the SAME shell
  process that has `vcvars64.bat` loaded.** Running them as two separate
  tool calls (e.g. two separate PowerShell invocations) loses the MSVC
  environment between them and you'll hit `fatal error C1083: Não é
  possível abrir arquivo incluir: 'stddef.h'` on literally every file —
  looks like a totally broken toolchain, but it's just a lost environment.
  Put both commands in one `.bat` file and run that, same pattern as
  `build_node_fix097.bat`.

This is a from-scratch full-engine compile (not incremental against the
`engine\build` you already have), so budget several minutes the first time.

`engine/test/CMakeLists.txt` lists every test `.cpp` — add new test files
there, they won't get picked up automatically.

## Troubleshooting

Most of the legacy `BUILD_GUIDE.md` troubleshooting entries (MSVC env not
loaded, LLVM_DIR not found, CMake cache corruption) still apply verbatim —
they're environment issues, not repo-specific. The two v2-specific gotchas:

- **Rebuilt but behavior didn't change:** you almost certainly skipped the
  `helix_engine.lib` copy step (FIX-097) — see step 2 above. Always use
  `build_node_fix097.bat`, don't hand-roll a partial build.
- **`.node` load error / old behavior persists in the IDE after a swap:**
  VS Code was still running and held the file locked, so the copy silently
  failed or partially wrote. Close VS Code fully, re-copy, re-verify the
  sha256.
