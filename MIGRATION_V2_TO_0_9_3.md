# Helix v2 to Canonical 0.9.3 Migration

Date: 2 August 2026
Source: `C:\Users\Mazum\Desktop\HexCore-Helix-v2`
Destination: this canonical `HexCore-Helix` repository
Status: source migrated locally; publication pending release gates

## Purpose

Helix v2 was a sandbox fork of 0.9.2 used to replace fragile foundations
without destabilizing the public engine. It is not a second Helix edition.
The validated result becomes canonical Helix 0.9.3 before HexCore 3.8.3.

## Included Boundary

The migration copies the current production trees from v2:

- `engine/src`
- `engine/include`
- `engine/dialects`
- `engine/test`
- `crates`
- `schemas`
- `signatures`
- `engine/CMakeLists.txt`
- frozen Remill 6/7 fixtures with `tests/FIXTURE_PROVENANCE.md`

Hash inventory at migration time:

- 182 production files compared
- 132 already byte-identical
- 40 replaced by the validated v2 versions
- 10 new engine/test files
- 0 canonical-only engine files removed
- 0 post-copy hash mismatches

## New Production Files

- `engine/include/helix/utils/Debug.h`
- `engine/src/passes/ApplyDebugTypes.cpp`
- `engine/src/passes/BindReturnValues.cpp`
- `engine/test/ApplyDebugTypesTest.cpp`
- `engine/test/BindReturnValuesTest.cpp`
- `engine/test/RecoverVariablesTest.cpp`
- `engine/test/StructureControlFlowTest.cpp`
- `engine/test/VectorLaneTest.cpp`
- `engine/test/fixtures/repro_callchain.ll`
- `engine/test/fixtures/repro_callchain2.ll`

## Explicitly Excluded

- `.node`, DLL, LIB, PDB, OBJ, Cargo target, CMake build output
- MLIR dumps, terminal logs, scratch directories, tagged local candidates
- `_v2dbg_*`, `_scfspike`, `_scoreboard`, `_v5val`
- generated before/after C corpora under `tools/helix-validate`
- machine-local dependency caches under `engine/deps`
- sandbox package identity (`@hexcore/helix-v2`, version 0.1.x)
- private handoff/RAG material that is not required to build or use Helix

## Release Gates

1. Build the canonical source and pass the complete native suite.
2. Re-run the K=10 determinism oracle and fixed NUCLEO/cross-corpus gates.
3. Produce the Windows x64 N-API prebuild in GitHub Actions.
4. Verify the downloaded artifact hash and load it outside the source tree.
5. Install it in a fresh HexCore 3.8.3 candidate and repeat the IDE benchmark.
6. Publish only after the fresh-package evidence is recorded.

No historical sandbox build artifact is release evidence by itself.

## Canonical Build Evidence

Validated locally from the canonical tree on 2 August 2026:

- CMake identity: `Helix Engine v0.9.3`
- FlatBuffers mode: `vendored` with real HAST serialization enabled
- C++ suite: **216/216** tests from 16 suites
- N-API identity: `helix-js=0.9.3 native=0.9.3`
- package smoke fixture: MLIR pipeline, non-empty pseudo-C and 280-byte HAST
- repeatability smoke: pseudo-C and HAST SHA-256 identical across two engines

This local evidence closes the source/build migration. GitHub Actions,
downloaded-artifact loading, the fresh HexCore package benchmark, and release
publication remain separate gates.
