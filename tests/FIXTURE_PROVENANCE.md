# Test Fixture Provenance

The integration fixtures in this directory were recovered on 2026-07-26
from the canonical HexCore Helix history. They were missing from the v2
sandbox, causing the native suite to report file-not-found failures instead
of exercising the engine.

These are **frozen legacy regression fixtures**. Passing them proves backward
compatibility for the specific historical IR shapes only. They must not be
used to claim current Remill lift quality, current Helix output quality, or
parity with IDA. Release-quality measurements use freshly generated IR with
its generator version and source corpus recorded separately.

## remill-6

- `01-name-writing.ll` and `04-helix.c`: canonical
  `AkashaCorporation/HexCore-Helix` history, introduced by commit `9310dcb`.
- `06-helix-rust.c`: canonical history, introduced by commit `588640f`.
- The historical `06-helix-mlir.c` is intentionally not included because its
  tracked blob is empty.

`IntegrationPipelineTest` decompiles `01-name-writing.ll` at runtime. It does
not treat a generated C file as proof that the current engine still works.

## remill-7

The four `.ll` files referenced by `Remill7IntegrationTest` come from commit
`1d49e0d` of `AkashaCorporation/HexCore-Helix`:

- `bone_pos_calc3.ll`
- `bone_pos_calc7.ll`
- `bone_pos_calc9.ll`
- `projectile_constructor2.ll`

## Fresh validation artifacts (2026-08-04)

Fresh lifts are kept outside this frozen fixture tree until binary and function
identity are proven. The current ROTTR correctness investigation regenerated
`sub_14000e620` with Remill wrapper 0.5.1 / upstream 6.0.1 and validated it
against IDA 9.3.

For WWZ, the historical `bone_pos_calc3.ll` entry is `0x14142fe90`. The current
corpus binary (`SHA-256 7D9D9CA6CD3541AA43EE6E99DAA71200412D9FF5A202AA2602898FD463535617`)
has no function at that exact address; its nearest candidate begins at
`0x14142fef0`. A fresh `amd64_avx` lift of that candidate is stored under
`Desktop/benchmark/lifted/wwz-current-20260804`, with Remill versions and addon
hash in its sidecar JSON. It must not replace the legacy fixture without an
independent identity oracle.
