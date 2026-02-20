# Helix Reports

Esta pasta guarda comparativos de qualidade e performance para os logs de IR
(`log1.txt`, `log2.txt`, `log3.txt`).

## Como gerar

```bash
cargo run -p helix-core --example benchmark_logs -- \
  --label baseline-2026-02-15 \
  --iterations 25 \
  --output tests/reports/baseline-2026-02-15.md \
  log1.txt log2.txt log3.txt
```

## Como comparar melhorias

1. Gere um novo relatório após mudanças no parser/transforms.
2. Salve com novo nome (`baseline-AAAA-MM-DD.md` ou `run-<feature>.md`).
3. Compare os arquivos `.md` e observe:
   - tempo (`Mean (ms)` + `Min/Max (ms)` + `std`) e taxa (`Instr/ms`)
   - total de instruções recuperadas
   - diagnósticos
   - preview do pseudo-C

## Observação de dataset

- `log3.txt` está marcado como amostra de Tomb Raider porque o cabeçalho do IR
  contém `File: ROTTR.exe`.
