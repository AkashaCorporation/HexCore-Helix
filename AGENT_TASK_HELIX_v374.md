# Agent Task: hexcore-helix — v3.7.4 Fixes
## Destino: Repositorio Helix (hexcore-helix engine)
## Prioridade: Maioria bloqueia release v3.7.4

---

## Contexto

Benchmark de 20 funcoes do ROTTR.exe (AAA game, PE64 x64) + 3 funcoes do dudidudida.exe (HTB CTF, D lang). Helix v0.7.0 (shipped) e v0.8.0-nightly foram testadas. Evolucao acompanhada em tempo real com multiplos builds.

### Estado atual da Helix

| Metrica | v0.7.0 (shipped) | v0.8.0-nightly (latest) |
|---------|-----------------|------------------------|
| Usable output rate | 30% (6/20) | 35% (7/20) |
| Crashes | 0 | 0 |
| Float types | Nao | Sim (`float xmm0`) |
| SSE ops | Opacas (MINSS/MAXSS) | Parcial (fcmp com XMM operandos) |
| Stub detection | 60% confidence | 96% + issue flagging |
| Cast layer | Nao | Sim (`--use-cast-layer`) |

### Top 3 melhores outputs (referencia de qualidade)

**NpcDamage** (35 linhas) — EXCELENTE:
```c
if (*r15->field_0x40 < rdi | *r15->field_0x40 == rdi) {
    sub_140473300(*0x42BE43A8);
} else {
    var_68 = param_12;
    if (var_68 == 0) {
        if (*0x422E5C67 != 0) { sub_1403c3a80(); return rax; }
        rax = *param_1;
        vfunc_0x98(var_68);
    }
}
```

**ObjectManager-Create** (30 linhas) — EXCELENTE:
```c
r15 = *(rax + r13);          // indexed access
r15->field_0x40 = param_2;   // struct write
r15->field_0x28 = param_2;   // struct write
sub_indirect(*0x40FF372E, r15, *param_1);  // vtable
```

**UpdatePosition** (17 linhas) — BOM:
```c
float xmm0;  // FLOAT TYPE!
if (r14->field_0x2E44 == 0) {
    sub_140828710(r14 + 0x3350);  // PlayerAwareness
}
```

---

## FIX-005: SSE Semantic Lowering (MINSS→min, MAXSS→max) [P1-HIGH]

### Problema
MINSS/MAXSS aparecem como chamadas opacas ou como pares de `if` nao colapsados:

```c
// v0.7.0:
MINSS();   // completamente opaco

// v0.8.0-nightly:
if (xmm0[0] != xmm6[0]) { }   // fcmp decomposto mas NAO colapsado
if (xmm0[0] >= xmm6[0]) { }
```

### Fix necessario
Pattern match pass no MLIR que reconhece:
```
fcmp une %a, %b → NaN guard (pode eliminar)
fcmp oge %a, %b + select → min(a, b) ou max(a, b)
```
E colapsa pra:
```c
result = min(xmm0, xmm6);  // ou max()
```

Tabela de operacoes:
| Pattern | Resultado |
|---------|-----------|
| `fcmp olt + select` | `min(a, b)` |
| `fcmp ogt + select` | `max(a, b)` |
| `fmul` | `a * b` |
| `fadd` | `a + b` |
| `fsub` | `a - b` |
| `fdiv` | `a / b` |
| `MULrax(-1)` | `-value` |
| `DIVrdxrax()` | `a / b` |

### Criterio de aceite
UpdatePosition deve mostrar `min()` e `max()` em vez de pares de `if` ou chamadas opacas.

---

## FIX-006: Float Type Propagation [P0 — SHIP DA NIGHTLY]

### Status
**JA IMPLEMENTADO na v0.8.0-nightly**. Precisa ir pra release.

### O que funciona
- `float xmm0` em vez de `int64_t xmm0`
- Zero literals como `0` em vez de `(int64_t)(void*)0`
- `int32_t var_d` — diferenciacao de tipos 32/64-bit

### O que ainda falta
- `xmm0 = 0` deveria ser `xmm0 = 0.0f` (literal float explicito)
- Propagacao de float pra field access: `param_1->field_0x2C` deveria ser `float` quando sabemos que e HP

---

## FIX-007: Liveness.cpp Crash Fix [P0 — SHIP DA NIGHTLY]

### Status
**JA CORRIGIDO na v0.8.0-nightly**. NpcDamage e ObjectManager-Create que crashavam agora decompilam com 96% confidence.

### Criterio de aceite
Zero crashes em qualquer funcao x64 PE.

---

## FIX-010: Helix Session Context Overlay [P0-CRITICAL — FEATURE NOVA]

### O que e
Quando o analista renomeia `param_1` → `healthPtr` e retipa `int64_t` → `HealthComponent*`, a proxima execucao do `helix.decompile` deve emitir output JA com esses nomes/tipos.

### Porque e critico
Hoje a Helix gera `sub_14003EDD0(int64_t param_1)` toda vez. Com session overlay, gera `ValidateFlag(HealthComponent* healthPtr)`. O rename RETROALIMENTA a decompilacao. Isso e o salto de "tradutora" pra "decompiler interativa".

### Implementacao

A sessao e armazenada pelo disassembler em `.hexcore_session.db` (SQLite). A Helix precisa:

1. **Receber session data como input**: novo arg no `helix.decompile`:
```json
{
  "cmd": "hexcore.helix.decompile",
  "args": {
    "address": "0x14003EDD0",
    "sessionOverlay": {
      "functions": { "0x14003EDD0": { "name": "ValidateFlag" } },
      "variables": {
        "0x14003EDD0.param_1": { "name": "result", "type": "int32_t" },
        "0x14003EDD0.param_2": { "name": "lookupTable", "type": "int32_t*" }
      },
      "fields": {
        "HealthComponent": { "0x2C": { "name": "currentHP", "type": "float" } }
      }
    }
  }
}
```

2. **Pos-processamento do output**: apos gerar pseudo-C normal, aplicar overlay:
   - `sub_14003EDD0` → `ValidateFlag`
   - `param_1` → `result`
   - `int64_t param_2` → `int32_t* lookupTable`
   - `param_1->field_0x2C` → `result->currentHP` (se tipo e struct com fields)

3. **Propagacao de tipos**: se `param_2` e `int32_t*`, entao `*(rax + (param_2 << 2))` vira `lookupTable[index]` (pointer arithmetic → array access).

### Alternativa: integrar com HQL

O HexCore HQL (Helix Query Language) opera no AST da Helix via Flatbuffers. O session overlay poderia ser aplicado no nivel do AST:
1. Helix gera AST normal
2. Session overlay modifica nodes do AST (rename, retype)
3. HQL queries rodam no AST anotado
4. PseudoC emit usa nomes/tipos do AST anotado

Isso e mais robusto que string replace pos-output.

### NAO precisa de SharedArrayBuffer
Isso e um JSON input + pos-processamento (ou AST modification). Nao tem IPC de alta performance envolvido. O SharedArrayBuffer (#31 do backlog) e pra Unicorn hook callbacks, problema completamente diferente.

### Criterio de aceite
Analista renomeia `param_1` → `healthPtr` com tipo `HealthComponent*`, roda `helix.decompile` de novo, output mostra `HealthComponent* healthPtr` e `healthPtr->currentHP` em vez de `int64_t param_1` e `param_1->field_0x2C`.

---

## FIX-013: Liveness.cpp Guard pra ELF Relocatable [P1-HIGH]

### Fonte
Bug bounty em `mali_kbase.ko` (45MB, ELF x86_64 ET_REL, Arm Mali GPU kernel driver).
Report completo: `C:\Users\Mazum\Desktop\Intigrity\hexcore-reports\HELIX_RELOC_ELF_ISSUES.md`

### Problema
Em ELF relocatable (.ko), relocacoes nao resolvidas criam edges de controle de fluxo invalidos no IR liftado. Uses de SSA escapam do parent region → `Liveness.cpp:45` assertion crash.

**Helix v0.7.1**: 7/7 funcoes CRASH neste assert.
**Helix v0.8.0-nightly**: ja nao crasha (fix anterior aplicado), mas produz stubs silenciosos.

### Fix necessario
O crash foi resolvido. Mas o guard deve ser mais informativo:
```cpp
// Liveness.cpp:45
if (!ownerBlock) {
    markAsExternalUse(use);
    diagnostics.emit("Unresolved SSA use — likely unpatched ELF relocation");
    continue;
}
```

E emitir issues no output:
```c
// Confidence: 40.0% (Low)
// Issues:
//  - Unresolved relocations detected (ELF ET_REL)
//  - 23 external calls resolved as stubs (mutex_lock, copy_from_user, ...)
//  - Decompilation may be incomplete
```

### Dados de teste
- `mali_kbase.ko`, SHA256: `05c1d42b702e275af96e992ee384b33bd67511dbf500e00b088a6cca03ac416d`
- 7313 funcoes, 7 testadas, todas crash (v0.7.1) ou stub (v0.8.0)
- Funcoes de 260-976 instrucoes reduzidas a 3 linhas

### Criterio de aceite
Zero crashes em qualquer ELF ET_REL. Output deve ter confidence score reduzido e issues listando relocacoes nao resolvidas.

---

## IMP-003: Inline de Callees [P2 — v3.8.0]

### Problema
20% das funcoes sao wrappers (`sub_xxx(); return;`). A logica real esta na callee.

### Melhoria
Opcao `inlineCallees: N` que decompila ate N niveis de call depth.

---

## IMP-004: Dead Store Elimination [P2]

### Problema
```c
r12 = param_2;   // dead — r12 e imediatamente sobrescrito
r12 = 0;
```

### Status
Parcialmente implementado na nightly (melhorou mas nao completo). LLVM DCE pass padrao deveria resolver.

---

## Benchmark de Referencia pra validacao

Rodar estas 5 funcoes e comparar com baseline:

| Funcao | .ll source | Baseline (v0.7.0) | Target (v3.7.4) |
|--------|-----------|-------------------|-----------------|
| UpdatePosition | 12-ll-stress-test/UpdatePosition-full.ll | MINSS/MAXSS opacas, int64_t xmm | min()/max(), float xmm |
| NpcDamage | 12-ll-stress-test-newcodex2/NpcDamage.ll | 35 linhas, struct access | Manter qualidade + session overlay |
| ObjectManager-Create | 12-ll-stress-test-newcodex2/ObjectManager-Create.ll | 30 linhas, DIVrdxrax | DIV → a/b, session overlay |
| ReceiveDamage-Notify | 12-ll-stress-test-newcodex2/ReceiveDamage-Notify.ll | 8 linhas, struct init | Manter + float 0x12C |
| BoneTransformUpdate | 12-ll-stress-test-newcodex2/BoneTransformUpdate.ll | 14 linhas, branching | Manter + type casts |

Todos os .ll estao em `C:\Users\Mazum\Desktop\HexCore-LARA\hexcore-reports\`.
