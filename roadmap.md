## 🚀 Roadmap: Engine Helix & Integração HexCore

### Fase 1: Fundação e Ponte de Segurança (Rust + NAPI-RS) ✅

O objetivo aqui é criar a "casca" que protegerá a IDE de falhas de memória do C++ e garantirá a performance máxima de 2026.

* ✅ **Implementar `hexcore-helix` em Rust:** Módulo nativo com **NAPI-RS** para interface Node.js/VS Code.
* ✅ **Vincular LLVM 18.1.8:** Bibliotecas do LLVM 18 estabilizadas.
* ✅ **Bridge de Tipos:** Estruturas de dados Rust expostas para TypeScript via NAPI-RS.

### Fase 1.5: HIR Pipeline & Robustez (Rust) 🔄

Pipeline de descompilação de alta qualidade com HIR como camada central.

* ✅ **HIR Builder:** Lowering completo de RemillInsn → HirModule com tipos e spans.
* ✅ **HIR Emitter:** Emissão de pseudo-C com variáveis nomeadas, tipos e indentação.
* ✅ **Calling Convention Recovery:** Win64 arg folding, result naming, register elimination.
* ✅ **Type Propagation:** Refinamento iterativo de tipos Unknown até ponto fixo.
* ✅ **Expanded Semantics:** CMOV, XCHG, MOVZX, MOVSX, BSF/BSR, BSWAP, REP MOVS/STOS, CDQE.
* ✅ **Structured Diagnostics:** Sistema tipado de diagnósticos (Error/Warning/Info/Hint) com categorias.
* ✅ **HIR Validation:** Verificação de integridade estrutural antes da emissão.
* ✅ **Data Flow Analysis:** Liveness, reaching definitions, dead code detection com semânticas expandidas.
* ✅ **Control Flow Structuring:** Recuperação de if/else e while loops a partir de CMP/TEST + Jcc patterns.
* ✅ **CMOV Condition Recovery:** Resolução de condições CMOV via pairing com CMP/TEST precedente.
* ✅ **REP MOVS/STOS Promotion:** Emissão como chamadas intrínsecas memcpy/memset com argumentos.
* ✅ **TEST Simplification:** `TEST reg, reg` simplificado para `reg != 0` / `reg == 0`.
* ✅ **104 testes unitários** (todos passando), benchmark em 3 logs reais, throughput >29 instr/ms.
* 🔄 **Próximo:** Else detection refinement, nested control flow, SSE/AVX semantics, MLIR dialect integration.

### Fase 2: O Motor MLIR (O Cérebro em C++23)

Aqui é onde matamos o Rellic. Em vez de uma tradução direta, usaremos dialetos para elevar o nível do código progressivamente.

* **Ingestão do Remill:** Configurar a Helix para consumir o LLVM IR gerado pelo `hexcore-remill` (v0.1.0).
* **Criação do Dialeto Helix (MLIR):** Definir o dialeto MLIR personalizado que permite representar operações de descompilação (recuperação de *loops*, *if-else* e *structs*) de forma mais flexível que o LLVM IR "flat".
* **Passagens de Transformação:** Escrever as "passes" em C++23 para converter o código do dialeto de baixo nível para o dialeto de alto nível (Helix High-Level).

### Fase 3: Sistema Nervoso de Alta Velocidade (FlatBuffers)

Para evitar que a interface da HexCore trave ao carregar funções gigantes, eliminaremos o JSON.

* **Schema FlatBuffers:** Definir o esquema de dados para o Grafo de Fluxo de Controle (CFG) e a Árvore de Sintaxe Abstrata (AST) descompilada.
* **Zero-Copy Access:** Implementar a leitura direta da memória da Helix pelo TypeScript, permitindo renderização instantânea no Webview do VS Code.

### Fase 4: Integração com a HexCore IDE

Colocar a Helix para trabalhar dentro das ferramentas que você já construiu.

* **Comando `hexcore.helix.decompile`:** Registrar o novo comando no `hexcore-disassembler` (v1.4.0) para substituir a dependência experimental do Rellic.
* **Visualização Progressiva:** Atualizar a UI para mostrar o código sendo "limpo" em tempo real conforme as passagens do MLIR terminam.
* **Suporte Headless:** Adicionar a Helix ao `automationPipelineRunner.ts` para permitir descompilação em lote em arquivos `.hexcore_job.json`.

### Fase 5: Estabilização e Auditoria (Soberania)

* **Testes de Estresse:** Testar contra os binários do HTB e malwares reais que a HexCore já analisa.
* **CI/CD Pipeline:** Integrar o prebuild da Helix no workflow de GitHub Actions que você já usa para o Capstone e Unicorn.

---

### Resumo da Stack Helix 2026

| Camada | Tecnologia | Por que? |
| --- | --- | --- |
| **Lifting** | Remill (LLVM 18 Custom) | Você já fez a mágica de rodar no LLVM 18. |
| **Core Logic** | **C++23 + MLIR** | Modularidade e soberania na descompilação. |
| **Safety Bridge** | **Rust + NAPI-RS** | Performance máxima sem derrubar a IDE. |
| **Transporte** | **FlatBuffers** | Fluidez total na UI, sem gargalo de JSON. |

---
