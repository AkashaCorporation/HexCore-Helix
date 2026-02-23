# Helix vs Rellic — Relatório de Comparação

Data: 2026-02-23

## Resumo de Métricas

| Caso | Helix Lines | Rellic Lines | Helix Temps | Rellic Temps | Helix Boilerplate | Rellic Boilerplate | Helix CF | Rellic CF | Status |
|------|------------|-------------|------------|-------------|-------------------|-------------------|----------|----------|--------|
| camera-init | 12 | 62 | 0 | 39 | 0 | 19 | ✗ | ✗ | ✅ Helix melhor |
| aim-assist-init | 12 | 62 | 0 | 39 | 0 | 19 | ✗ | ✗ | ✅ Helix melhor |
| swarm-serialization | 12 | 62 | 0 | 39 | 0 | 19 | ✗ | ✗ | ✅ Helix melhor |
| swarm-write | 12 | 62 | 0 | 39 | 0 | 19 | ✗ | ✗ | ✅ Helix melhor |
| name-writing | 12 | 62 | 0 | 39 | 0 | 19 | ✗ | ✗ | ✅ Helix melhor |

## Legenda

- Lines: linhas efetivas (não-vazias, sem comentários)
- Temps: variáveis temporárias (t0, t1, ...)
- Boilerplate: linhas com PC, NEXT_PC, MEMORY, etc.
- CF: presença de estruturas de controle (if/while/for)
- ⚠️: Helix tem mais boilerplate que Rellic
- ✅: Helix produz menos linhas que Rellic
