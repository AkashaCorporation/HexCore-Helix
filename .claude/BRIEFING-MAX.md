# Briefing para Conta Max — HexCore Helix Engine

> Cole isso como primeira mensagem na outra instância.
> Ela vai ter contexto completo para trabalhar autonomamente.

---

## Quem você é

Você é um engenheiro de compiladores trabalhando no HexCore Helix, um decompiler binário baseado em LLVM 18 / MLIR. Seu trabalho é melhorar a qualidade do output C gerado pelo engine.

## Projeto

```
Raiz: C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix
```

**Leia ESTES DOCS antes de qualquer coisa:**
- `CLAUDE.md` — regras gerais, build, git
- `.claude/agents/helix-engine-guide.md` — guia completo do engine (layout, passes, defects, validação)
- `.claude/agents/helix-builder.md` — referência de build detalhada
- `HELIX_PHILOSOPHY.md` — filosofia do projeto

## Situação atual (2026-05-17)

A Helix decompila binários através do pipeline:
```
Binary → Remill IR → HelixLow → HelixMid → HelixHigh → C-AST → Pseudo-C
```

Temos um corpus de teste com 7 funções de um rootkit Linux (ftrace hooks).
O score médio do `helix-validate` é **41.1%** enquanto a self-confidence reporta **74.3%**.
O gap existe porque o confidence scorer não detecta defects semânticos no output.

### Scores atuais do corpus:
```
fh_ftrace_thunk         79.0%  (OK - stub)
hook_syslog             71.9%  (OK - stub)
hook_read               57.2%  (self-ref, native opcodes)
hook_write              55.8%  (self-ref, native opcodes)
fh_install_hook.cold    24.0%  (self-ref, unreachable)
fh_install_hook          0.0%  (operand binding loss)
fh_install_hooks         0.0%  (operand binding loss)
```

## Corpus de teste

```
Outputs:  C:\Users\Mazum\Desktop\a1b6d665-96d4-4884-bf11-87dff33713d2-1778066531\rev_kernel_monarch\hexcore-reports\02-disasm\
IR input: C:\Users\Mazum\Desktop\a1b6d665-96d4-4884-bf11-87dff33713d2-1778066531\rev_kernel_monarch\hexcore-reports\02b-lift-only\
```

## Tarefa #1 (MAIS IMPORTANTE): Operand Binding Fix

**Leia:** `.claude/agents/task-operand-binding-fix.md`

**Problema:** Dois SSA values diferentes recebem o mesmo nome de variável após HelixMidToHigh. Isso causa:

| Exemplo no output | O que deveria ser | Porque está errado |
|---|---|---|
| `v5 += v5 + 208` | `v5 += 208` | 2*v5+208 ao invés de v5+208 |
| `*v3 = v3 + v3` (x8) | `hook->field_N = val_N` | 8 stores diferentes colapsados |
| `v0 = v0->r12` | `v0 = regs->r12` | bases diferentes, mesmo nome |
| `printk(0, v3)` (x4) | `printk(fmt_N, arg_N)` | args diferentes colapsados |

**Onde mexer:** `engine/src/passes/HelixMidToHigh.cpp` — naming de VarRef.
**Secundário:** `engine/src/cast/CAstBuilder.cpp` — mapa `exprToBestName_`.

**Fix:** Garantir que SSA values distintos recebam nomes distintos, mesmo que venham do mesmo registrador físico.

## Tarefa #2: Relocation Data Symbols

**Leia:** `.claude/agents/task-relocation-symbols.md`

**Problema:** `*0x7FFF0038` aparece no output ao invés de `__this_module`. O metadata de relocation existe no MLIR (`__hxreloc__`) mas só é usado para calls, não para loads/stores.

**Onde mexer:** `engine/src/analysis/SignatureDb.cpp` (já parseia o reloc map, precisa expor para CAstBuilder).

## Tarefa #3: Native Opcodes

**Problema:** `rep_while_equal_string_compare_byte` e `sub_with_borrow` aparecem no output C. São semânticas de `repe cmpsb` do x86 que o Remill liftou mas a Helix não simplificou.

**Onde mexer:** `engine/src/cast/CAstOptimizer.cpp` → função `decomposeNativeOpcodes`. Precisa de patterns para:
- `rep_while_equal_string_compare_byte(ptr1, ptr2, len)` → `memcmp(ptr1, ptr2, len)` ou `strncmp`
- `sub_with_borrow` → resultado da comparação (== 0 / != 0)

## Tarefa #4: Unreachable After Return

**Problema:** `return result; kfree(ptr);` — código morto após return.

**Onde mexer:** `engine/src/cast/CAstOptimizer.cpp` → já existe `removeDeadStoresBeforeReturn` mas ele só pega stores, não calls/expressions. Precisa expandir para eliminar qualquer statement após um `return` no mesmo scope.

## Build (CRÍTICO — siga exatamente)

```bash
# 1. Engine C++
cmd //c "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build-helix.bat"
# Checar: EXIT_CODE=0

# 2. Copiar lib
cmd //c "copy /Y C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build\helix_engine.lib C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\deps\llvm-mlir\engine\helix_engine.lib"

# 3. Limpar fingerprints (NÃO PULE ISSO)
powershell -Command "Remove-Item -Recurse -Force 'C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\target\x86_64-pc-windows-msvc\release\.fingerprint\helix-core-*' -ErrorAction SilentlyContinue; Remove-Item -Recurse -Force 'C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\target\x86_64-pc-windows-msvc\release\.fingerprint\hexcore-helix-*' -ErrorAction SilentlyContinue"

# 4. Build .node
cmd //c "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\build_napi.bat"
# Checar: "Finished release profile"

# 5. Deploy (FECHAR VSCODE ANTES)
cmd //c "copy /Y C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\crates\hexcore-helix\hexcore-helix.win32-x64-msvc.node C:\Users\Mazum\Desktop\vscode-main\extensions\hexcore-helix\hexcore-helix.win32-x64-msvc.node"
```

## Validação (OBRIGATÓRIO após cada mudança)

```bash
# Score geral do corpus
python tools/helix-validate/helix_validate.py "C:\Users\Mazum\Desktop\a1b6d665-96d4-4884-bf11-87dff33713d2-1778066531\rev_kernel_monarch\hexcore-reports\02-disasm\"

# Validação matemática com Z3 (para função específica)
python tools/helix-validate/helix_math_validate.py <arquivo.helix.c> --mlir-before <arquivo.ll>
```

**Regra:** score deve SUBIR e findings devem DIMINUIR. Se não, é regressão.

## REGRAS ABSOLUTAS

1. **NUNCA delete passes existentes** — se funciona, não remova
2. **NUNCA edite PseudoCEmitter.cpp** — é legacy
3. **SEMPRE use os .bat scripts** — nunca cmake/ninja manual
4. **SEMPRE limpe fingerprints** antes do build .node
5. **SEMPRE meça com helix-validate** antes E depois
6. **FECHE VSCode** antes de copiar .node
7. **NÃO commite** `*.bat`, `*.cmd`, `build_out.txt`, `*.helix.c`, `node_modules/`, `target/`, `engine/build/`

## Arquivos-chave por tamanho de impacto

| Arquivo | Linhas | O que faz |
|---------|--------|-----------|
| `engine/src/cast/CAstOptimizer.cpp` | ~7400 | 20+ passes de otimização do C-AST |
| `engine/src/cast/CAstBuilder.cpp` | ~3200 | MLIR High → C-AST conversion |
| `engine/src/passes/HelixMidToHigh.cpp` | ? | Mid → High (onde o naming acontece) |
| `engine/src/passes/HelixLowToMid.cpp` | ? | Register → variable promotion |
| `engine/src/analysis/SignatureDb.cpp` | ? | Resolução de call targets + relocations |
| `engine/src/cast/CAstPrinter.cpp` | ~800 | C-AST → texto |

## Git

```bash
# Co-author em commits:
Co-authored-by: MayaRomanova <maya@anthropic.com>

# vscode-main usa --no-verify
```
