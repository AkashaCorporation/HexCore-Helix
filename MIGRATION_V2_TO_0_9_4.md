# Helix v2 to Canonical 0.9.4 Migration

Date: 22 September 2026

## Boundary

The validated production source from `HexCore-Helix-v2` was reconciled onto
canonical `AkashaCorporation/HexCore-Helix` commit
`f3db6455394e6317cb582d60320de50822edf4a6`.

Included:

- `crates/`
- `engine/src`, `engine/include`, `engine/dialects`, and `engine/test`
- `engine/CMakeLists.txt`
- `schemas/`
- canonical package/build files changed specifically for `0.9.4-rc.2`

Canonical-only production files were preserved. Local addons, dependency
caches, build output, logs, dumps, benchmark corpora, private reports, and
historical Remill fixture directories were excluded.

The input copy manifest is stored outside the repository at
`E:\HexCore-3.8.5-Checks\helix-094-reconciliation-20260922-migration-manifest.json`
with SHA-256
`3B053DC1B5F8A2F482F3E3A81836D08ED154AD38928109F5A313DFE64593E743`.

## Canonical Corrections

- Restored package-derived native version identity instead of the sandbox
  hardcoded `0.1.9` string.
- Retained required FlatBuffers, TableGen dependency tracking, Linux LLVM link
  policy, test registration, and one-pass pseudo-C/HAST production.
- Made both the npm build wrapper and Cargo build script honor
  `HELIX_ENGINE_LIB_DIR`, preventing an older same-path static library from
  being linked through fallback discovery.
- Kept legacy Rust-pipeline-only helpers feature-gated so canonical Clippy
  remains warning-free.
- Restored dependent-template qualification in generated MLIR interfaces; the
  Windows build and the GCC/Linux PR lane compile the same TableGen contract.

## Acceptance

- Native C++: 389 passed, one optional named-fixture test skipped, zero failed.
- Rust workspace: 192 tests passed across unit/integration/ABI suites; two doc
  examples ignored; zero failed.
- `cargo fmt --check`: passed.
- `cargo clippy --workspace -- -D warnings`: passed.
- N-API smoke: `helix-js=0.9.4-rc.2 native=0.9.4-rc.2`.
- Smoke pseudo-C and HAST were non-empty and deterministic across fresh engine
  instances.
- Windows x64 addon SHA-256:
  `6400FCC56D2A7F889EE60CDC6E24829EE05E92EE57B7CACA8DA5C1F194E3ABA8`.
- The addon was loaded and exercised from an isolated artifact directory,
  outside both source trees.

## Remaining Release Gates

The source branch is published for review in PR #18, but no tag/release asset
has been published. It must still receive its version-matched dependency
bundle, pass GitHub Actions, and be consumed by an extracted HexCore 3.8.5 candidate.
Stable `0.9.4` remains reserved until those gates pass.
