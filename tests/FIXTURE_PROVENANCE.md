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

## current-remill / NUCLEO CRC32 (2026-11-14)

`current-remill/g03-nucleo-crc32.ll` is an authoritative G03 regression
fixture, not a legacy compatibility sample. It was freshly lifted from the
exact source-known NUCLEO build used by HexCore 3.8.6 acceptance:

```text
binary:       NUCLEO.exe
binary SHA:   fe8fa1c4553db5435f2d2e21b5d54769d657b57acf59393ac6b385cdf9277e87
source ASM:   asm/obf.asm
ASM SHA:      883b09ddd0bd3eea7104f29793cfa2f36e5c730bc123a9c32b413bae9045a41b
entry:        0x140022197
endExclusive: 0x1400221DC
IR SHA:       a0ad485e37833b995698b80e35f6f5d10f3a954a9e0c81ee52a120994efb8822
```

The source oracle contains `xor al, dl`, `dec ecx`/`jnz`,
`dec rsi`/`jnz`, and `not eax`. The fixture gates parent-register
preservation, single evaluation of flag-producing decrements, and x86-64
zero-extension after a 32-bit destination write.
