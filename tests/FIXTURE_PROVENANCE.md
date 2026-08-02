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
