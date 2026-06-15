# FlatBuffer vs JSON — Benchmark Report

Data: 2026-02-23
Iterations: 1000

## Tamanho

| Tipo | FlatBuffer (bytes) | JSON (bytes) | Ratio |
|------|-------------------|-------------|-------|
| CFG  | 312 | 406 | 1.3x |
| AST  | 976 | 1131 | 1.2x |

## Notas

- FlatBuffer usa serialização binária zero-copy
- JSON usa serialização manual (sem serde overhead)
- Ratio = JSON/FlatBuffer (maior = FlatBuffer mais compacto)
