# Changelog

All notable changes to HexCore Helix are documented here.


## [v0.9.2-nightly] — 2026-05-31

> **Nightly build (rolling).** This is the single active nightly line; it now spans Wave 19 → Wave 27, newest work first. The earlier Wave 21 (FIX-087) groundwork is included below under this same version.
>
> **Since the FIX-087 SSA-versioning groundwork (Wave 21):** byte/word memory-source `MOVZX` lift, register-as-address variable binding (in-region + in-loop RAX→`result`), the first-class variadic-call mini-ISA carriage (Wave 22 Step 3-lite), two C-AST dataflow-fidelity fixes that recover the FNV accumulator chain, an `exprEqual` completeness fix, and the opt-in `--preserve-cfg` callfuscation-deflatten path (Wave 23, Stages 1+2). All `--preserve-cfg` work is gated **default OFF** — normal lifts are byte-for-byte unchanged, confirmed by a quad-corpus tripwire (rootkit / ROTTR / Intigrity-Mali / Akasha).

### Wave 27 — Honesty layer (leave-nightly P0), increment 2: function_starts NAPI channel + D4 confidence cap + #30 registry-miss (2026-06-05)

> Second increment of the leave-nightly honesty layer (`rag/08_leave_nightly_plan.md`): the consumers of the Wave 26 address registry. Three additive fixes, each gated to stay **inert on the current non-authoritative single-function corpus** (`functionTableIsAuthoritative_` stays false → byte-identical output, confirmed on the akasha / SOTTR-`UpdatePosition` / x64 corpus) and validated engine-direct on freshly-lifted `.ll` plus a bundled GoogleTest. The first wires the channel that lets an isolated/IDE single-function lift become authoritative; the other two are the D4 and #30 honesty gates that fire once it is. The cross-repo IDE caller (`analyzeAll` → `setFunctionStarts`) and the residual folded cross-function leak (A-D1) are deliberately deferred to a follow-up so they land where they can be validated end-to-end against a real multi-window authoritative table.

#### FIX-092 — NAPI `set_function_starts` channel: the keystone that lets D2/#30 fire on a single-function lift (`crates/hexcore-helix`, `crates/helix-core`, `engine/{include,src}`)

- **Problem**: D2 (out-of-table callee → honest indirect, FIX-090) and the #30 registry-miss path can fire only when `functionTableIsAuthoritative_` is true, which Wave 26 sets only when the `helix.function_starts` side-table is non-empty OR more than one FuncOp is present. An isolated / IDE single-function lift (`decompileIr(irText)`) carries neither, and the NAPI `HelixEngine` had **no way to supply the table** — so it always degraded to the regression-safe non-gating fallback.
- **Fix** (additive, plumbing-only — no caller in this patch): a new `set_function_starts(Vec<i64>)` NAPI setter mirroring `add_variable_rename`, threaded `engine.rs` → `ffi.rs` → `Engine.h` / `CApi.cpp` → `Engine.cpp` → `Pipeline.{h,cpp}`. `Pipeline::translateToMLIR` seeds the externally-supplied table into the local `functionStarts` vector **before** the existing `helix.function_starts` named-metadata sweep, so a whole-binary `.ll` (in-IR entries) and an IDE single-function lift (NAPI-supplied entries) converge on the same authoritative attribute. Empty by default → behaviour identical to today.
- **Impact**: 0 output movement from the plumbing alone (no caller); enables D2 / #30 / the folded-leak residual to fire once the deferred IDE caller supplies the full `analyzeAll` table. Validated: full corpus byte-identical with no setter; `cargo check -p helix-core -p hexcore-helix` green.

| File | Symbol(s) |
|---|---|
| `crates/hexcore-helix/src/engine.rs` | `#[napi] set_function_starts` |
| `crates/helix-core/src/ffi.rs` | `helix_engine_set_function_starts` extern + safe wrapper |
| `engine/include/helix/Engine.h`, `engine/src/CApi.cpp`, `engine/src/Engine.cpp` | `setFunctionStarts` decl + C-API + forward |
| `engine/include/helix/Pipeline.h`, `engine/src/Pipeline.cpp` | `function_starts_` member + setter/accessor + `translateToMLIR` seed |

#### FIX-093 — D4 damning-defect confidence cap: a function that leaked a code address or called out-of-table cannot self-report above 50% (`cast/CAstBuilder.cpp`, `cast/CAstOptimizer.cpp`, `cast/CDecl.h`)

- **Problem**: `analyzeConfidence` (and the post-optimization rescorer `reanalyzeConfidence`, which OVERWRITES the score) computed confidence as `100 − syntactic penalties` — plausibility, not honesty. A function carrying a damning defect (`hasDamningHonestyDefect_`: a D1 code-address leak, or a D2 out-of-table / own-block tail-jump call) could still report Medium/High — exactly the "sometimes high on a clean-looking but wrong function" defect.
- **Root cause**: the damning signal lived only on a builder member; `reanalyzeConfidence` (the value the user actually sees) could not read it, and `analyzeConfidence` has early-return paths a function may take before its tail.
- **Fix**: the builder member `hasDamningHonestyDefect_` is stamped onto the decl (`CFuncDecl::hasDamningHonestyDefect`) at decl-creation in `buildFunction` (a guaranteed-run point, before any `analyzeConfidence` early-return), and BOTH `analyzeConfidence` and the authoritative `reanalyzeConfidence` hard-cap a flagged function's score at 50% with an honest issue string. The post-opt rescorer's cap is the one that survives to the user.
- **Impact**: SOTTR `UpdatePosition` (a real D1 leak) **60.5% Medium → 50.0% Low** + `damning honesty defect ... capped at 50%`; clean `simple_add` stays **85% High** (the `>50` guard + default-false flag keep clean functions byte-identical). Akasha out-of-table functions capped only under an authoritative table.

| File | Symbol(s) |
|---|---|
| `engine/include/helix/cast/CDecl.h` | `CFuncDecl::hasDamningHonestyDefect` |
| `engine/src/cast/CAstBuilder.cpp` | decl-flag stamp in `buildFunction`; cap in `analyzeConfidence` |
| `engine/src/cast/CAstOptimizer.cpp` | authoritative cap in `reanalyzeConfidence` |

#### FIX-094 — #30 registry-miss honest failure: a stub-shaped function absent from an authoritative table is scored 0, never a silent stub (`cast/CAstBuilder.{h,cpp}`, `cast/CAstOptimizer.cpp`, `cast/CDecl.h`, `test/RegistryMissTest.cpp`)

- **Problem**: a stub-shaped function whose address did not really lift was emitted as a silent 50–90% stub. Wave 26's `knownFunctionStarts_` always contains the lone self-entry of a single-function lift, so it cannot tell a "real self-entry" from "an address the authoritative Pathfinder table never listed".
- **Fix**: a new narrower set `authoritativeFunctionStarts_` (and query `isAuthoritativeFunctionStart`) populated ALWAYS from the `helix.function_starts` side-table, plus FuncOp entries ONLY when more than one function is present — it deliberately EXCLUDES the lone self-entry. In `analyzeConfidence`'s stub branch, an authoritative table + a non-zero entry NOT in that set raises a sticky `CFuncDecl::registryMissHonestFailure`; `reanalyzeConfidence` forces the surviving score to 0 with a `registry miss` issue. The mandatory `entryAddr != 0` guard keeps a whole-module FuncOp whose entry is structurally 0 from being false-flagged.
- **Impact**: inert (byte-identical) on the non-authoritative corpus; on real authoritative-table fixtures (akasha-with-table) every in-table entry is correctly NOT flagged (0 false registry-misses, scores unchanged). The #30 contract is proven by the bundled `RegistryMissTest` (GoogleTest, **3/3**): omitted-self-under-authoritative → score 0; in-table self → normal stub score; entry==0 → never forced to 0.

| File | Symbol(s) |
|---|---|
| `engine/include/helix/cast/CAstBuilder.h` | `isAuthoritativeFunctionStart` decl; `authoritativeFunctionStarts_` member |
| `engine/src/cast/CAstBuilder.cpp` | populate the set in `buildFunctionRegistry`; define the query; #30 flag in `analyzeConfidence` |
| `engine/src/cast/CAstOptimizer.cpp` | sticky registry-miss early-return in `reanalyzeConfidence` |
| `engine/include/helix/cast/CDecl.h` | `CFuncDecl::registryMissHonestFailure` |
| `engine/test/RegistryMissTest.cpp` | GoogleTest #30 contract (3 cases) |

### Wave 26 — Honesty layer (leave-nightly P0), increment 1: address registry + D1/D2 (2026-06-04)

> First increment of the "leave v0.9.2-nightly" honesty layer (`rag/08_leave_nightly_plan.md`). Builds the ONE authoritative function/block-address registry the whole P0 quad needs, then wires the two C-AST honesty fixes that consume it: **D1** (block/function addresses must not leak as bare integer data) and **D2** (no hallucinated named callees — out-of-table targets emit an honest indirect call). D3 (unreachable removal), D4 (confidence score-gate), and #30 (on-demand lift) are deferred to the next increment but their registry hook-points are marked in-code (`hasDamningHonestyDefect_` for D4; `isKnownFunctionStart`/`isKnownBlockStart` for #30/D3). The registry is module-scoped for the function half (FuncOp entries + an optional `helix.function_starts` side-table the lifter/NAPI stamps from `analyzeAll`) and function-scoped for the block half (harvested from surviving `loc_<hex>` labels). **x86 regression-safe by construction:** the D2 cross-function rewrite fires ONLY when an authoritative function table is present; on the isolated single-function corpus (no table) it stays inert, so legitimate cross-function `sub_xxxx` calls are preserved byte-for-byte. Validated on freshly re-lifted `.ll` (current Remill 0.4.0 / FIX-053+): 29/31 strictly-deterministic corpus files byte-identical, the 2 changed are intended D1 fixes; gta-sa 15/15 crash-clean, 0 `/* unhandled */`; Akasha source-oracle proximity unchanged on the 4 scalar functions.

#### FIX-091 — C1: folded in-function code address must not leak as bare i32 data (issue #15, follow-up to FIX-089) (`cast/CAstBuilder.{h,cpp}`)

- **Problem**: a win64 in-function block/branch target (a NEXT_PC) that the cast layer computes as `add(base_const, off_const)` and the printer then narrows to its low 32 bits leaked as a bare data assignment. Live on a FRESH lift of SOTTR.exe `UpdatePosition` (`sub_1409b9b90`, decompiled via the current Remill/Helix `.node`): `var_0 = 0x409B9F77;` and `var_0 = 0x409B9F87;` — really the in-function blocks `0x1409B9F77` / `0x1409B9F87` (leaked labels). This is exactly the "folded-truncation leak" FIX-089 explicitly deferred as a Known Gap (the value never matched the registry full-width and bypassed the `buildIntegerConstant` D1 gate).
- **Root cause**: two compounding facts. (1) The leaked label is created by the cast optimizer's `add(const,const)` fold, NOT a single MLIR constant, so the FIX-089 full-width gate in `buildIntegerConstant` never saw it; the folded value also never landed in the (empty-on-structured-functions) `loc_<hex>` block-label registry. (2) `CAstPrinter::formatIntLiteral` narrows through 32-bit `unsigned long` on MSVC, so the full 64-bit fold result `0x1409B9F77` printed as `0x409B9F77` — a bare in-function data leak.
- **Fix** (additive; full-width D1/FIX-089 behavior unchanged):
  - New shared discriminator `CAstBuilder::resolveFoldedCodeLabel(rawValue, addr)`. It reconstructs the 64-bit candidate base/ASLR-agnostically — `candidate = (currentFunctionEntryAddr_ & ~0xFFFFFFFFull) | (rawValue & 0xFFFFFFFFull)` — never a hardcoded ImageBase. It treats the value as a folded label ONLY when `candidate` is inside the current function's `[start, end)` span AND is a real in-function code address (an instruction/block leader of THIS function); on either miss it returns nullopt and the constant is left EXACTLY as today. On a hit it emits the same honest form as FIX-089 D1 — `&loc_<hex>` for a confirmed-referenced label, else the `(void *)0xCANDIDATE` code-pointer cast — never a bare `var = 0x...;`.
  - New function-scoped in-function code-address registry (`inFunctionCodeAddrs_` + `[currentFunctionMinAddr_, currentFunctionEndAddr_)`), harvested in `buildBlockRegistry` from every instruction `address` attribute (block leaders are a subset; the per-block leader walk is empty on every structured function — the #30 registry-miss — so the broader instruction-address sweep is what lets the gate fire while staying false-positive-proof). High-bit-windowed to the function entry so importer sentinel addresses (`address=64`) are ignored.
  - `buildIntegerConstant` calls the discriminator after the FIX-089 (a)/(b) full-width gates. The `llvm.add` / `llvm.sub` builders constant-fold `const ± const` and route the result through the discriminator BEFORE the cast optimizer re-folds and the printer truncates it — the minimal plumbing needed to gate the folded form (documented in-code).
- **Why the float stays data**: the same function's `v48 = 0x42E63080;` (IEEE-754 115.0947f) reconstructs to `0x142E63080`, which is ABOVE this function's end (`0x1409BA058`) and is not a recorded instruction address → both gates fail → left as the bare float-bits data constant. Confirmed unchanged.
- **Impact** (FRESH SOTTR.exe `UpdatePosition` relift, current Remill `.node`; reproduced via `helix_tool --use-cast-layer` and the rebuilt `.node`):
  - `UpdatePosition` C1 leaks **2 → 0**: `var_0 = 0x409B9F77;` → `var_0 = (void *)0x1409b9f77;`; `var_0 = 0x409B9F87;` → `var_0 = (void *)0x1409b9f87;`. `v48 = 0x42E63080;` STAYS the bare float-bits data constant. 0 `/* unhandled */` / `/* undef */`.
  - No false positives across the corpus (gta-sa x86 15/15, Akasha 3/3, ROTTR ~20). Before→after diff is intended-only: ROTTR `ObjectManager-Create` 3 bare folded leaks (`= 0x403C0400/0440/0471;`) → 0, now 4 honest `(void *)0x1403c0xxx`; gta-sa `network-625144` resolves the unfinished `(void *)0x625122 + 10` to the clean `(void *)0x62512c` (both real in-function block leaders `bb_6443298`/`bb_6443308`). Per-function `/* unhandled */` counts byte-identical before/after across the whole corpus. **0 data/float constants converted to addresses.**

| File | Function(s) |
|---|---|
| `engine/include/helix/cast/CAstBuilder.h` | `resolveFoldedCodeLabel` decl; in-function code-address registry state (`inFunctionCodeAddrs_`, `currentFunctionMinAddr_`, `currentFunctionEndAddr_`) |
| `engine/src/cast/CAstBuilder.cpp` | `resolveFoldedCodeLabel`; `buildIntegerConstant` C1 gate; `buildBlockRegistry` instruction-address harvest + span; `llvm.add`/`llvm.sub` const-fold route in `buildExpression`; `clearFunctionState` reset |

#### FIX-089 — Shared address registry + D1 code-typed constant resolution (`cast/CAstBuilder.{h,cpp}`, `Pipeline.cpp`, `cast/CAstOptimizer.cpp`)

- **Problem**: code addresses leaked into the decompiled C as bare integer data, e.g. `var_0 = 0x40005605;` where the RHS equals a basic-block leader (observed on ROTTR `BoneTransformUpdate` → `var_0 = 0x4064DAFC;`, `ObjectManager-Create` → `var_0 = 0x403C0462;`). The constant-emit path (`CAstBuilder.cpp` `mid::ConstantOp` and the three sibling constant ops) rendered any integer attribute directly, with no datatype tag distinguishing a code/block address from data. There was also no single place to ask "is this integer a known function/block start?" — the same registry-miss that causes #30.
- **Root cause**: no authoritative function/block-address registry reachable from the C-AST layer, and the constant path had no code-address gate (cf. Ghidra `PrintC::pushPtrCodeConstant`, printc.cc:1793, which resolves a code-typed constant to a symbol via `queryFunction` and never emits a raw int).
- **Fix**:
  - New shared primitive `CAstBuilder::{buildFunctionRegistry,buildBlockRegistry,isKnownFunctionStart,isKnownBlockStart,blockLabelForAddr}`. Function half = module FuncOp entry addresses ∪ `helix.function_starts` module attribute; block half = `loc_<hex>` leader addresses harvested from `LabelOp`/`GotoOp` names (the per-block `address` attribute is empty on every structured function — that miss is itself the #30 symptom, noted in-code). `functionTableIsAuthoritative_` distinguishes a real table from a lone self-entry.
  - `Pipeline::translateToMLIR` lifts an `!helix.function_starts` LLVM named-metadata node (dropped by the MLIR importer, re-stamped by hand exactly like `llvm.target_triple`) into a `helix.function_starts` i64 array attribute — the single channel D2/D3/D4/#30 reuse.
  - New `CAstBuilder::buildIntegerConstant` routes all four integer-constant emit sites (`high::IntLitOp`, `mid::ConstantOp`, `llvm.mlir.constant`, `arith.constant`). A value equal to a known block/function start emits an honest, always-compilable code-pointer cast `(void *)0xADDR` (Ghidra's typecast fallback) — or `&loc_xxxx` when the label is a confirmed-referenced goto target (guaranteed emitted). It NEVER emits `&loc_xxxx` for an unreferenced label (would dangle and break compilation). Ordinary arithmetic constants are untouched.
  - `CAstOptimizer`: `loc_<hex>` references (the D1 `&loc_xxxx` form) are code labels, not data — excluded from `declareUndeclaredVars` and the undeclared-var confidence penalty via the new `isCodeLabelName` predicate, so the fix does not inflate the placeholder count or drop confidence.
- **Impact** (fresh-relift corpus, regression-safe no-table path): D1 block-address-as-data leaks (RHS == a known block leader) **2 known → 0** on ROTTR (`BoneTransformUpdate` ×3 collapsed to honest `(void *)0x1406…` casts; `ObjectManager-Create` ×1); **0 residual** full-match leaks across Akasha + gta-sa + ROTTR + Mali. 29/31 strictly-deterministic files byte-identical (the 2 changed are exactly these D1 fixes). 0 new `/* unhandled */`/`/* undef */`. Confidence preserved (BoneTransformUpdate 92.8% unchanged).
- **Deferred (Known gaps)**: a code address that the optimizer *constant-folds* to an i32 before the C-AST (a win64 `0x14064daf3` surfacing as a bare `0x4064daf3`) bypasses `buildIntegerConstant` entirely and is NOT caught — that leak existed pre-fix (no regression) and belongs to a follow-up that intercepts the narrowing op, not the registry.

| File | Function(s) |
|---|---|
| `engine/include/helix/cast/CAstBuilder.h` | registry API + state (`knownFunctionStarts_`, `blockStartToLabel_`, `functionTableIsAuthoritative_`, `hasDamningHonestyDefect_`) |
| `engine/src/cast/CAstBuilder.cpp` | `buildFunctionRegistry`, `buildBlockRegistry`, `isKnownFunctionStart`, `isKnownBlockStart`, `blockLabelForAddr`, `buildIntegerConstant`; `buildModule`/`buildFunction`/`clearFunctionState` wiring; `tryExtractIntLiteral` extended |
| `engine/src/Pipeline.cpp` | `translateToMLIR` — `!helix.function_starts` → `helix.function_starts` attr |
| `engine/src/cast/CAstOptimizer.cpp` | `isCodeLabelName`; `declareUndeclaredVars` + confidence filter exemptions |

#### FIX-090 — D2 honest callee gating: out-of-table named calls become indirect (`cast/CAstBuilder.cpp`)

- **Problem**: every CALL synthesised a named `sub_<addr>(...)` call unconditionally, with NO membership test against the function table — so IAT/import thunks were emitted as fabricated named functions, e.g. Akasha `hc_entry` (`start`, 0x140001740) called `sub_140002008(...)` / `sub_140002010(...)` / `sub_140002018(...)` / `sub_140002000(...)` / `sub_140001fff(...)` (11 call sites) where none of those addresses is a real function start. (rag/06 §19 — the honest indirect form is more correct than the fake `sub_`.)
- **Root cause**: `CAstBuilder.cpp:1256-1277` (and the sibling high/mid call-emit sites) synthesised the callee name with no registry gate (cf. Ghidra, where call-name emission is gated by `queryFunction`; no symbol → indirect expr, never a fake named call).
- **Fix**: new `CAstBuilder::gateCalleeName` runs at all four call-emit sites (high::CallOp statement + expression, low::CallOp statement, mid::CallOp). A target that IS a function start → keep the named call. A target that resolves to a block start of the current function → tail-jump/computed-goto mis-lowered as a call → honest indirect `(*(code *)0xADDR)(...)`. A target absent from an **authoritative** table → honest indirect. With NO authoritative table (isolated lift) → keep the name (regression-safe: an isolated lift cannot enumerate siblings, so we never destroy a legitimate cross-function `sub_xxxx`). The honest indirect form is encoded via the `CCallExpr` target-name string (printer emits `(*(code *)0xADDR)(args)` verbatim, parenthesised correctly per cppreference).
- **Impact** (Akasha `hc_entry`, with the `analyzeAll` function table supplied via `helix.function_starts`): out-of-table named calls **11 → 0**; all 7 in-table cross-function calls (`sub_140001000/090/190/350/410/5c0/740`) preserved; the 11 IAT-thunk sites now emit `(*(code *)0x140002008)(...)` etc. On the table-less corpus: 0 call-emit changes (gta-sa cross-function `sub_xxxx` calls byte-identical), confirming the regression-safe default. NAPI plumbing to populate `helix.function_starts` from `analyzeAll` in normal IDE runs is the next increment's wiring (hook marked).

| File | Function(s) |
|---|---|
| `engine/src/cast/CAstBuilder.cpp` | `gateCalleeName`; call-emit gating at high::CallOp (stmt+expr), low::CallOp (stmt), mid::CallOp |

### Wave 25 — AArch64 stp/ldp prologue: pair-helper lowering + X0 call-result sink (2026-06-02)

> Follow-up to Wave 24. The AArch64 load/store-pair-with-writeback helpers (`StorePairUpdateIndex*` / `LoadPairUpdateIndex*`) were leaking into the decompiled C as side-effecting stub calls, and — worse — the LoadPair stub was being chained into the function return, so the canonical GCC prologue `stp x29,x30,[sp,#-N]! ; mov x29,sp ; ... ; ldp x29,x30,[sp],#N ; ret` decompiled to `StorePairUpdateIndex64(); return LoadPairUpdateIndex64();` instead of the real body. This wave models the pair helpers so prologues/epilogues disappear and the straight-line body survives DCE. All changes are AArch64-gated (`isAArch64_` / the `aarch64`/`arm64` triple); x86 is provably untouched (15/15 gta-sa stress functions crash-clean with 0 pair-helper leaks and 0 `/* unhandled */`).

#### FIX-088 — AArch64 stp/ldp-with-writeback lowering and AAPCS64 X0 call-result sink (`passes/RemillToHelixLow.cpp`)

- **Problem**: the canonical AArch64 prologue (synthetic `stp x29,x30,[sp,#-0x10]! ; mov x29,sp ; mov w0,#0x2a ; ldp x29,x30,[sp],#0x10 ; ret`) decompiled to `StorePairUpdateIndex64(); return LoadPairUpdateIndex64();` — the `mov w0,#42` body was lost and the stp/ldp frame helpers leaked as side-effecting stubs. Reproduced via `helix_tool --use-cast-layer rag/_arm64_prologue.ll` and on four real GCC AArch64 prologues in the HTB `poly` binary (`sub_40002f04` MD5, `sub_40003db4` hash-compare, `sub_40002fc4` MT19937-64 init, `sub_400030b8` MT19937-64 extract).
- **Root cause**: `StorePairUpdateIndex*` / `LoadPairUpdateIndex*` demangle to `RemillSemantic::Unknown` and fell through to the UNHANDLED-default emission path, which materializes a side-effecting `helix_low.call` stub (and, for the load, chains its result into the return via the call-result sink). They were never modeled as memory ops, so the prologue/epilogue never collapsed.
- **Fix**: new `tryLowerAArch64PairHelper()` (intercepts in `convertOperation`, right after the `__remill_*`/`llvm.` skip block and before `convertSemantic`). Operand layout verified against `remill/lib/Arch/AArch64/Semantics/DATAXFER.cpp`: `(...,src/dst1, src/dst2, mem_addr, writeback_reg, next_addr)`. When the writeback register is SP the pair is a callee-saved frame save/restore (x29=frame-pointer, x30=link-register) and is **elided** exactly like x86 `push rbp`/`pop rbp` (new `isAArch64StackPtr()` detects SP via `!remill_register "SP"` metadata or the field-3/sub-index-63 GEP). Non-frame pairs fall through to real `MemWriteOp`/`MemReadOp` pairs (`base` + `base+elemBytes`), with loads written to their destination registers but never chained into the return value. Separately, the six genuine call-result RegWrite sinks now use `returnRegName()` (X0 on AArch64, RAX on x86) instead of a hard-coded `"RAX"`; on x86 this evaluates to the same literal, so x86 codegen is byte-identical.
- **SP re-enable — attempted, reverted (still crashes)**: with the pair helpers now modeled, re-enabling SP in `RegisterTracker::aarch64GprName` (sub-index 63 → "SP") was tried and **still reintroduces a non-deterministic use-after-free** (~52 segfaults / 100 runs across the synthetic prologue and the poly prologues). The crash is therefore not confined to the pair helpers: turning SP into an SSA register surfaces it in `mov x29,sp` and `sp +/- N` frame arithmetic that the downstream AArch64 liveness/structuring path mishandles. SP is left on the non-register path; with the pair helpers elided those SP reads are dead and drop out anyway, so the output is already clean. SP re-enable is now a separate, deeper task (the comment in `aarch64GprName` records the empirical finding).
- **Impact** (real native engine via `helix_tool --use-cast-layer` and the deployed `.node`):
  - Synthetic `arm64_prologue`: `StorePairUpdateIndex64(); return LoadPairUpdateIndex64();` → **`return 42;`** (0 pair-helper leaks, 0 `unhandled`/`undef`).
  - `poly` MD5 `sub_40002f04`: StorePair leak 1 → **0**; epilogue body now visible (`sub_40000f30(...)`, `sub_40000fe0(...)`).
  - `poly` MT-extract `sub_400030b8`: StorePair leak 1 → **0**.
  - `poly` hash-compare `sub_40003db4` + MT-init `sub_40002fc4`: already 0, still **0**.
  - Regression guards unchanged: `arm64_leaf` → `return 1;`; x86 `x64_control` → `return 1;` (`| sysv`); `arm64_bl_cbz_ret` → `sub_1008(); return __native_CBZ();` (cbz structuring is a separate deferred task).
  - Stability: **0 crashes** across 20× the synthetic suite (140 runs) and 15/15 gta-sa x86 stress functions crash-clean.
- **Still deferred** (not regressions): bare AArch64 `Store` operand accessor, `ADRP`, and `cbz`/`cbnz`/`b.cond` structuring (`__native_SUBS` / `DirectCondBranch` / `DoDirectBranch`) — separate opcodes/CFG tasks; AArch64 SP recognition (see above).

| File | Change |
| --- | --- |
| `engine/src/passes/RemillToHelixLow.cpp` | New `isAArch64StackPtr()` + `tryLowerAArch64PairHelper()`; dispatch interception in `convertOperation`; six call-result sinks switched from `"RAX"` to `returnRegName()`; expanded the `aarch64GprName` SP note with the SP re-enable crash finding. |

### Wave 24: AArch64 (AAPCS64) register recovery and decompilation (2026-05-31)

> First working AArch64 decompilation path for the Helix MLIR pipeline, now that Remill AArch64 lifting works (FIX-053). Helix was previously x86-only: AArch64 register GEPs were unrecognized, so the pipeline leaked Remill operand-accessor helpers (e.g. `return Load();`) instead of real values. All changes are AArch64-gated; x86 output is proven byte-identical (13/13 deterministic gta-sa stress functions diff-clean vs main; the 2 remaining diffs are pre-existing pipeline non-determinism present in clean main).

- **Root cause** (`passes/RemillToHelixLow.cpp`): `RegisterTracker` decoded register GEPs using the x86-64 Remill State struct layout only (GPR at struct field 6). The AArch64 State struct places GPR at field 3 with a different sub-index scheme (X0..X30 at odd slots 1..61), so no AArch64 register was ever recognized and all downstream naming / CC / ABI logic stayed x86-tuned.
- **`RemillToHelixLow`**: recognize AArch64 GPR GEPs at struct field 3 (X0..X30) in both `RegisterTracker::scan()` and `extractRegisterNameFromValue()`; strip `ptrtoint` in `stripPointerAliases` so operand-accessor register pointers resolve; `inferRegWidth` understands `X<n>` / `W<n>`; map the bare Remill `Load` operand accessor (`Load<RnW,In>`) to MOV so `MOV Xd,#imm` lowers to a real register write. Field 3 is disjoint from x86 (field 6), so x86 recognition is byte-for-byte unchanged.
- **`RecoverCallingConvention`**: add the `Aapcs64` calling convention (X0..X7 args, X0/V0 return, X19..X30 callee-saved) and select it for `aarch64` / `arm64` triples before the linux/elf/gnu branch.
- **`RecoverVariables`**: AAPCS64 arg-register positions (X0..X7 -> param_1..8); AArch64 sub-register info (`X<n>` 64-bit, `W<n>` the 32-bit view of `X<n>`); X0 dual-role (arg + return) so a return-context X0 write names `result` over `param_1`.
- **`RecoverVariables` / `EliminateDeadCode`**: X0/V0 are implicitly read by RET, so the return-value write survives DCE.
- **`RemillDemangler`**: classify the bare AArch64 `Load` operand accessor as MOV.
- **Validated** (real native engine via `helix_tool --use-cast-layer` and the deployed `.node`): `mov x0,#1; ret` -> `return 1;` (was `return Load();`); `mov w0,#0x2a; ret` -> `return 42;`; `add x0,x0,#1; ret` -> `param_1 + 1` (AAPCS64 param + return); x86 `mov eax,1; ret` -> `return 1;` (`| sysv`, unchanged).
- **Deferred follow-ups** (reported, not regressions): SP recognition plus the load/store-pair-with-writeback helpers (`StorePairUpdateIndex64` / `LoadPairUpdateIndex64`) are still side-effecting stubs -- recognizing SP together with these unmodeled pair helpers exposed a latent use-after-free in the stp/mov/ldp prologue, so SP is intentionally left on the non-register path to stay crash-free (0/20 runs); AArch64 conditional-branch decomposition (`cbz` / `cbnz` / `b.cond` still emit `__native_*`); AArch64 call-result dataflow keeps the x86 RAX sink (cleanly DCE'd on AArch64) pending the pair-helper modeling.

### Wave 23 — Callfuscation deflatten structural recovery (`--preserve-cfg`, 2026-05-29)

> Opt-in `--preserve-cfg` mode (default **OFF** — normal lifts byte-for-byte unchanged) for the callfuscation-deflatten lift path: an anti-analysis flattened dispatcher, deflattened upstream into a single ~980-block function, that previously **collapsed to a 4-line stub** inside Helix. Validated end-to-end on `crackme.deflat2` (a stack-VM interpreter). Quad-tripwire with the flag OFF is byte-identical (rootkit 27.0% / ROTTR 20.4% / Intigrity-Mali 24.0% / Akasha 22.9%; oracle mali 35.8%, oracle akasha 32.3%). Flag plumbing mirrors `skip_optimization`: `helix_tool --preserve-cfg` → `helix_engine_set_preserve_cfg` → `Engine::setPreserveCfg` → `Pipeline::setPreserveCfg` → `createRemillToHelixLowPass(bool)` / `createStructureControlFlowPass(bool)`.

#### Stage 1 — `RemillToHelixLow`: keep intra-function jmp edges under `--preserve-cfg` (`passes/RemillToHelixLow.cpp`, commit `f394fbb`)

- **Problem**: every deflattened block carries a constant-target `JMPI` PC-bookkeeping semantic *alongside* its real `br label %bb_X` edge. The `JMP` case treated the constant target as an external tail-call (`low.call sub_<target>` + deferred `RetOp`), and the deferred-terminator logic **erased the `br` edge** — truncating the function at its first block and collapsing the whole 980-block VM to `sub_40b65f(); return`. The code's assumption ("a constant-target jmp is always an external tail-call; intra-function jumps are plain `br`") is false for the CFG-preserving lift (0 out-of-buffer jmp targets).
- **Fix (gated)**: when `--preserve-cfg` is set and the JMP block has a single intra-function `br`/`cond_br` successor, emit a `low.jmp` to that successor instead of reclassifying the jump as a tail-call. Genuine external tail-call blocks have no intra-function successor, so they are unaffected; with the flag OFF the original behaviour is byte-identical.
- **Result**: stub → full body survives (11891 ops after RemillToHelixLow, 7513 at HelixHigh, **0** tail-calls, no crash); all six MBA arithmetic helpers visible.

#### Stage 2 — `StructureControlFlow`: structure reducible multi-latch dispatch loops under `--preserve-cfg` (commit `cdd747c`)

- **Problem**: with Stage 1 the body survives but the structurer left it **entirely unstructured** (946 raw `helix_low.jmp`, 0 high-level regions). Its irreducibility guard declared the function irreducible because the VM dispatch-loop header (`0x4096ab`, **13 internal back-edge predecessors** — one latch per opcode handler) tripped the "any SCC block with ≥3 internal predecessors → irreducible" heuristic. That SCC is single-entry, hence **reducible**; the `entries > 1` check above it is the authoritative test, and LLVM's DomTree handles reducible multi-latch loops fine (verified: no assert).
- **Fix (gated)**: in `--preserve-cfg` mode the `≥3-internal-preds` sub-guard is skipped (the `entries > 1` multi-entry check still rejects truly irreducible SCCs). Default OFF → conservative guard retained, normal lifts unchanged.
- **Result**: structuring proceeds (no crash); **23 loop regions** recovered; pseudo-C 51 → 328 lines with the dispatch logic visible (opcode values, `prog[]`/value-stack accesses, MBA helpers).
- **Known follow-ups (not in this build)**: the multi-latch dispatch loop + opcode if-chain still emit as nested `while(true)` + goto rather than a clean `while { switch }` (Stage 2b — loop-coalescing + switch recovery); and the dataflow (array-index recovery `prog[idx]`/`stack[sp]`, call arg/return recovery, `var_950` desconflation) is still raw (Stage 3, in progress).

### Wave 22 — Variadic-call mini-ISA: Step 3-lite carriage (`passes/HelixLowToMid.cpp`, commit `088d624`)

- **Problem**: Wave 22 Step 2 (`RemillToHelixLow`) emits a first-class `helix_low.variadic_call` + `bundle.create<state>` for zeroed printk-family calls (`printk(0)`, `dev_err(0)`, …), but the "Step 2.5 stopgap" in `HelixLowToMid` collapsed each to a plain `mid::call` and **dropped the bundle**, so the upstream-zeroed recovery state never reached HelixHigh and a downstream opacity marker had nothing to key off.
- **Fix**: instead of dropping the bundle, carry its recovery state forward as discardable attributes on the resulting `mid::call` — `helix.variadic_state` (`zeroed`/`opaque`/`partially_recovered`/`recovered`), `helix.variadic_fixed_args_count`, `helix.variadic_provenance`. `HelixMidToHigh` already forwards `helix.*` attributes onto the `high::call` (both the conversion pattern and the manual `low::FuncOp` walk), so the state reaches CAstBuilder for free. This is the attribute-based carriage trade-off catalogued as Divergence 1 of the Step-1 design; the fully first-class `variadic_call` op carried through every tier is deferred as an architectural follow-up.
- **Result**: no C-output change (the marker emission itself, Step 4, is deferred); carriage verified on rootkit `fh_install_hook` — 6 zeroed-fmt variadic calls detected at lift == 6 `high::call` ops carrying `helix.variadic_state="zeroed"` in the post-pipeline IR. All baselines hold.

### Wave 20 — C-AST dataflow fidelity: FNV accumulator chain + compound assignment (`cast/`, commits `d67b37d`, `6d30a55`, `22fbba1`)

> Honesty corrections (criteria per the protocol: ground-truth oracle holds, the defect is silent data loss / fabricated output, the score movement is pre-existing defects becoming visible). Surfaced on the Akasha `rt_fnv` runtime FNV-1a hash (`while (*s) { h = (h ^ byte) * prime; }`).

#### Bug A — `precomputeDeadStores` traverses SSA operands, not regions (`cast/CAstBuilder.cpp`, commit `d67b37d`)

- **Problem**: CAstBuilder's per-block dead-store pre-scan detected RHS variable reads with `valueDef->walk([](VarRefOp){…})`. `Operation::walk` descends an op's *nested regions*, but a `helix_high.binary`/`cast`/`unary` reads its operands as *sibling SSA values* (no regions) — so the walk saw zero reads for any non-trivial RHS. A self-update like `result = result ^ byte` registered neither its self-read (`rhsReadsSelf`) nor kept earlier writes alive, so the FNV xor-accumulator store was wrongly judged dead and dropped — silently deleting a live computation.
- **Fix**: replace the `walk` with a recursive `getDefiningOp` traversal of the value's operand tree (handles reads buried in nested expressions like `(a ^ b) * c`), mirroring the already-correct direct-operand logic in the cross-block pre-scan. The XOR store now survives to the C output.

#### Bug B — `detectCompoundOp` strips the matched operand (`cast/CAstBuilder.cpp`, commit `6d30a55`)

- **Problem**: when the assign target also appeared as an operand of the RHS binary (`x = x OP y`), `detectCompoundOp` returned a compound operator (e.g. `*=`) but the caller never replaced `valueExpr` with the *other* operand — emitting the self-doubled `result *= result * prime` instead of `result *= prime` (and `result ^= result ^ byte`).
- **Fix**: when the compound op matches via `lhsMatch`, set `valueExpr = build(binary.rhs)` (commutative `rhsMatch` keeps `binary.lhs`). `rt_fnv` loop now emits the faithful FNV step `result ^= byte; result *= prime;`.

#### `exprEqual` completeness — `StringLitExpr` case (`cast/CAstOptimizer.cpp`, commit `22fbba1`)

- **Problem**: `exprEqual` had no `StringLitExpr` case and fell through to `default: return false`, so two structurally identical calls carrying a string-literal argument never compared equal — defeating the bare+assign double-emit dedup in `removeDuplicatesInList` for any such call.
- **Fix**: compare string literals by value. Latent correctness fix — baseline-neutral on all four corpora (no call in the current corpora is double-emitted with a string-literal argument today; surfaced while prototyping the variadic opacity marker).

### Wave 20b — Register-as-address variable binding (`passes/RecoverVariables.cpp`, commits `10491f7`, `53efe35`)

- **`10491f7` — in-region reg-op binding**: a post-loop sweep ("Strategy B") in `RecoverVariables` walks the full function region (including the `helix_high.if`/`do_while`/… regions that `StructureControlFlow` created) and binds each `reg.read`/`reg.write` that survived inside a structured region to the SSA snapshot at its containing top-level block's exit. Replaces `v0 = 0; … v2 = *v0;` placeholders with the real parameter-derived base (e.g. `*param_3_1`). Akasha `rt_fnv` source-oracle 14.2% → 29.2%; `sv2` 36.6% → 54.9%.
- **`53efe35` — in-loop RAX → `result`**: for hash-loop functions (FNV, CRC, …) the final RAX value is computed *inside* a loop region with no top-level post-loop RegWrite, so `isReturnContext` never fired and the accumulator chain was DCE'd (empty loop body + unassigned `int64_t result;`). Fix: when the function returns a value, no `RAX__result` decl exists, and a full-width in-*loop*-region RAX write survives, synthesise a `result` VarDecl at entry and route the in-loop RAX reads/writes through it; mirror this in `EliminateDeadCode::removeDeadVariables` so the `result` chain is pinned (skips dead-assign/dead-decl removal for `result` when the function has a return value). Loop-region guard avoids regressing if-region conditional-return paths. Intigrity-Mali +5.9pp mean, no >40% function regressed.

### Wave 18b — MOVZX memory-source lift (`passes/RemillToHelixLow.cpp`, commits `4bf7198`, `5c05016`)

- **Problem**: the `MOVZX reg, [mem]` variant (`MOVZXI…MnIh`) was orphaning the byte/word memory load — the value never reached the C output.
- **Fix**: `RemillToHelixLow` now emits `MemReadOp → MovZxOp → RegWriteOp` for the memory-source MOVZX (`4bf7198` adds the `MemReadOp`; `5c05016` adds the `RegWriteOp` follow-up), so byte/word loads from memory reach the output. **Honesty correction**: this exposed a pre-existing register-as-address binding gap (addressed by Wave 20b), so some corpus means moved as the now-visible derefs were scored — not new defects, pre-existing ones becoming visible.

### Wave 21 — Register SSA versioning (2026-05-20)

#### FIX-087 — Per-function SSA renaming pass for `reg.read` / `reg.write` (`passes/RegisterSSARename.cpp`, NEW)

- **Problem**: `HelixLowToMid.cpp:118` (`RegReadToVarRef`) and `:141` (`RegWriteToAssign`) both computed `slot_id = llvm::hash_value(reg_name) & 0xFFFF`.  Every read and write of RAX in a function collapsed onto the same slot id.  Downstream `HelixMidToHigh::getSlotNameMap` used `slot_id` as the key, so multiple logical defs of RAX shared a name.  Symptoms on the three corpora:
  - `v0 = *v0->field_18;` in rootkit `hook_read` / `hook_write` / `hook_ia32_write` (C-write-later null_deref pattern).
  - Phantom `int64_t v0 = 0;` decls re-aliased to legitimately-distinct register defs.
  - 70 cumulative null_deref placeholder events across the deduped corpus.
- **Fix**: New pass `RegisterSSARenamePass` (`passes/RegisterSSARename.cpp`, 220 LOC) runs immediately before `HelixLowToMid`.  Walks each `helix_low.FuncOp` and BFS-visits reachable blocks from entry.  Per block:
  - Reconciles `currentVersion` from already-visited predecessor exit maps.  Single-pred copies; multi-pred-disagree stamps `kMergeVersion = 0xFFFFFFFE` (no phi insertion — loop iterations share a name, accepted per design).  Back-edge preds contribute `kLiveInVersion = 0`.
  - Tags every `reg.write` with a fresh version (1, 2, 3, ...) via `op->setAttr("ssa_version", IntegerAttr<UI32>)`.
  - Tags every `reg.read` with the current version on its register name (or `kLiveInVersion` if none yet on this path).
  `HelixLowToMid` now packs `slot_id = (name_hash << 16) | (version & 0xFFFF)` via the shared helper `computeSlotIdFromRegOp`.  Discardable attribute: when the pass is omitted, version defaults to 0 with a `LLVM_DEBUG` trace — pipeline still works, FIX-087 disambiguation just disabled for that op.
- **Files modified**:
  | File | Change |
  |------|--------|
  | `engine/src/passes/RegisterSSARename.cpp` | NEW (220 LOC) |
  | `engine/include/helix/passes/Passes.h` | Add `createRegisterSSARenamePass()` decl |
  | `engine/src/passes/HelixLowToMid.cpp` | Replace bare-hash slot_id with `computeSlotIdFromRegOp` helper (reads `ssa_version` attr, falls back to 0) |
  | `engine/src/Pipeline.cpp` | Insert `createRegisterSSARenamePass()` between `EliminateDeadCode` and `HelixLowToMid` |
  | `engine/CMakeLists.txt` | Register new translation unit in `helix_engine` target |
- **Impact (validator means, apples-to-apples — souper duplicates excluded from Intigrity)**:

  | Corpus | n | Baseline | After FIX-087 | Δ |
  |--------|---|----------|---------------|---|
  | Rootkit | 7 | 45.7% | 45.7% | 0.0pp |
  | ROTTR   | 20 | 28.5% | 28.5% | 0.0pp |
  | Intigrity | 7 | 13.5% | **19.3%** | **+5.8pp** |

  Per-function highlights:
  - Intigrity `kbase_mem_free`: 49.2% → 90.5% (+41.3pp) — body cleaned of 41 lines of unreachable post-return junk.
  - ROTTR `sub_1408285e0`: 52.4% → 52.0% (-0.4pp, well under 2pp tripwire).
  - All other >40% functions unchanged.
- **null_deref classification** (deduped baseline vs new):
  - Baseline: B-never=36, C-later=34 (total **70**)
  - Post-FIX-087: B-never=36, C-later=32 (total **68**, -2 events; both removed from Intigrity `kbase_mem_free`)
  - Rootkit `hook_*` `v0 = *v0->field_18` pattern UNCHANGED — those collisions originate in `RecoverVariables` (operates BEFORE FIX-087) and require a separate Phase-4-aware fix.  Filed as known-gap follow-up.
- **Design decisions deferred**:
  - No phi insertion at joins.  Loop-iteration values share a name (`kMergeVersion`); the design accepted this rather than implementing iterative dataflow.
  - `ssa_version` is a discardable attribute, not an ODS schema attribute.  Avoids breaking ~30 positional builder call-sites for `RegReadOp`/`RegWriteOp` in `RemillToHelixLow.cpp`.  Tablegen change deferred.
  - `getSlotNameMap` in `HelixMidToHigh.cpp` left as-is.  The existing per-function post-pass renumbering (lines 907-955) already converts module-wide raw `v<N>` names to compact per-function `v0, v1, ...`, so distinct slot_ids automatically yield distinct names without refactoring the map ownership.

> **Wave 19 scope note (2026-05-18):** operand-binding fidelity push on the `rev_kernel_monarch` Linux ftrace-rootkit corpus (7 functions). Three coordinated fixes (FIX-078, FIX-079, FIX-080) plus one documented REVERT (FIX-081). Total: **-6 `suspicious_self_reference` findings** on the lift-only corpus, **zero regression** on any function previously above 25%.

### Wave 19 — Operand binding + spurious-self-reference cleanup (2026-05-17 / 2026-05-18)

#### FIX-078 — Trailing literal-store DSE in nested scopes (`cast/CAstOptimizer.cpp`)

- **Problem**: `removeDeadStoresBeforeReturnInList` (line ~2628) only scanned direct preceding statements of a `ReturnStmt`.  Inside the kernel-rootkit corpus, lifted `mov dword ptr [rbp-8], 0x5ED` artefacts (PC-bookkeeping leaks Remill emits in the prologue/epilogue region) survived as `var_0 = 0x5ED;` immediately before `return v4;` at nested-scope return sites — `eliminateDeadStores` was too conservative across scope boundaries to catch them.
- **Fix**: Extended the backward scan to walk through nested `IfStmt`/`WhileStmt`/`DoWhileStmt`/`ForStmt`/`SwitchStmt`/`BlockStmt` children before the per-list scan, and gated removal on a global-ref-count check (`globalRefCount[varName] == 0`) so we never drop a store whose target is read elsewhere in the function.
- **Result**: `var_0 = 0x5ED;` and similar `*_promoted_N = <const>;` artefacts gone from the corpus.  Side-effecting RHS (`CallExpr`) is still explicitly preserved (line ~2681 break clause).

#### FIX-079 — Operand binding: spurious self-reference in commutative compound assignments (`cast/CAstOptimizer.cpp`)

- **Problem**: After upstream register coalescing, the optimizer emitted statements of the shape `v5 += v5 + 208;` and `v3 += v3 + 34;` in `fh_install_hook` and `fh_install_hooks`.  These read mathematically as `2v + C` while the disassembled binary at the same address is a plain `add reg, C` — the inner `v` is a lift-side artefact, not real source.  The existing `foldDegenerateCompounds` only handled the `-=` case (FIX-041's SBB idiom).
- **Fix**: `foldDegenerateCompoundsInList` (lines ~7240-7320) extended with a commutative-operator branch.  For `x OP= (x OP_compat C)` where `OP` ∈ `{+= *= &= |= ^=}` and `OP_compat` is the matching `BinaryOp` and the *other* operand is a literal (`IntLitExpr` / `AddrLitExpr`), drop the inner `x` reference.  The literal-only gate is load-bearing — never collapse `x += (x + y)` for a value-bearing `y`, that would be unsound.  Symmetric handling for `(C + x)` via `isCommutativeBinop` canonicalisation.
- **Result on lift-only corpus**: `v5 += v5 + 208` → `v5 += 208`; `v3 += v3 + 34` → `v3 += 34`.  -4 `suspicious_self_reference` findings (fh_install_hook 9 → 7; fh_install_hooks 7 → 5).  Pre-existing DWARF-enriched corpus mean held at 41.1% (no regression).
- **Justification per HELIX_PHILOSOPHY (fidelity > polish)**: pre-fix output was already infidel to the binary's `add reg, C`; the rewrite restores fidelity.  No statement is removed, only an artefactual operand.

#### FIX-080 — SSA versioning: dependency-aware Phase 3.5 coalescing (`passes/RecoverVariables.cpp:1574-1620`)

- **Problem**: `RecoverVariables` Phase 3.5 (same-register SSA version coalescing) used a baseline interference check that only scanned for `base` uses AFTER `ver`'s assign in program order.  This missed the operand-binding case where `ver` is assigned the result of a `helix_low.call` whose argument list transitively reads `base` — the call observes the OLD register version while writing a NEW one, and coalescing them produces `v4 = ftrace_set_filter_ip(v2, v4, 0, 0);` and similar self-referential statements.
- **Fix**: Added the lambda `valueDependsOnBase(Value start, unsigned targetVarId)` — a recursive walker over `defOp->getOperands()` that returns true if any `helix::high::VarRefOp` in the SSA def chain of `start` has `getVarId() == targetVarId`.  Phase 3.5's per-shared-block scan now additionally calls `valueDependsOnBase(verDefAssign.getValue(), base.varId)`; positive result sets `interferes = true` and aborts coalescing for that version pair.  The original post-def liveness scan is retained unchanged.
- **Result on lift-only corpus**:
  - `v4 = ftrace_set_filter_ip(v2, v4, 0, 0);` → `v5 = ftrace_set_filter_ip(v2, v4, 0, 0);` (distinct SSA versions preserved).
  - `v4 = register_ftrace_function(v2, v4, 0, 0);` → `v6 = register_ftrace_function(v2, v4, 0, 0);`.
  - -2 additional `suspicious_self_reference` findings (corpus total 23 → 21).
  - Zero regression on hook_read / hook_write / hook_ia32_write / fh_ftrace_thunk / hook_syslog (within ±0.0pp).
- **Earlier-attempted stricter variant rejected**: refusing coalescing on ANY same-block value read of `base` cost 1.1-1.6pp on hook_read/hook_write/hook_ia32_write via increased `vN` placeholder count; reverted to the dependency-aware variant per the "prefer partial fix that does not regress" rule.

#### FIX-082 — HelixLowToMid emits FieldPtrOp for `llvm.add(base, const)` addresses (`passes/HelixLowToMid.cpp`, 2026-05-18)

- **Problem**: Phase 1 investigation (`task-helixmem-provenance.md`) showed that `MemReadToLoad` and `MemWriteToStore` in `HelixLowToMid.cpp` passed `adaptor.getAddr()` verbatim to `mid::LoadOp` / `mid::StoreOp`, even when the address was clearly `llvm.add(base, llvm.constant)` — a struct-field reference.  The `mid::FieldPtrOp` / `mid::IndexPtrOp` ops were already wired through `MidFieldPtrToHighField` (HelixMidToHigh) and `CAstBuilder` but nothing in the pipeline ever produced them.  Field-name recovery happened only as a text-level fallback in `CAstOptimizer::recoverStructFieldAccess` (which still ran and still works).
- **Fix**: Added the helper `tryDecomposeAddrAsField(Value addr)` (~50 lines) in `passes/HelixLowToMid.cpp` between the `RegWriteToAssign` and `MemReadToLoad` patterns.  It pattern-matches `llvm.add(base, llvm.constant)` (symmetric for `add(constant, base)`); refuses both-constant operands and zero offsets.  Then `MemReadToLoad` and `MemWriteToStore` call the helper and, on match, emit `mid::FieldPtrOp(base, offset)` whose result becomes the LoadOp / StoreOp `addr` operand.  Fallback path unchanged for any address shape that doesn't match (e.g. `Add(Add(...))`, `Add(base, Mul(idx, stride))`, casts in the middle).
- **Scope (Phase 2 only)**: ONLY the simple `add(base, const)` shape is decomposed this round.  `Add(Add(base, c1), c2)`, `Add(base, Mul/Shl(idx, stride))` for arrays, and `arith` dialect variants are deferred to Phase 3.  `recoverStructFieldAccess` in `CAstOptimizer` is intentionally kept as a fallback — covers cases the pipeline still misses.
- **Result on lift-only corpus (`02-disasm-fix082`)**: 5 of 7 functions improved, zero regressions.  Corpus mean: 35.1% → **45.7%** (+10.6pp).
  - `fh_install_hook`: 0.0% → **26.0%** (+26.0pp), struct_recovery 0.0 → 1.0
  - `fh_install_hooks`: 0.6% → **25.9%** (+25.3pp), struct_recovery 0.0 → 1.0
  - `hook_ia32_write`: 27.9% → 35.8% (+7.9pp), struct_recovery 0.0 → 1.0
  - `hook_read`: 30.0% → 37.2% (+7.2pp), struct_recovery 0.0 → 1.0
  - `hook_write`: 27.9% → 35.8% (+7.9pp), struct_recovery 0.0 → 1.0
  - `fh_ftrace_thunk` 87.3% and `hook_syslog` 71.9%: unchanged (no in-scope address arithmetic).
- **Known visual artefact (not a tripwire breach)**: the resulting C output prints `*v3->field_18 = v4` instead of `v3->field_0x18 = v4` for some stores.  Cause: `mid::FieldPtrOp` semantically returns `&base->field` (a pointer), `MidFieldPtrToHighField` lowers it to a `high::FieldAccessOp` that the CAstBuilder treats as a value, then the load/store wraps it in `Deref(...)` → `*(base->field)`.  For pointer-typed struct fields (e.g. `struct files_struct* files` in `task_struct`) this is *correct* — the extra `*` is the real pointer dereference.  For value-typed fields it is verbose but semantically equivalent (`*(&x) == x`).  The validator reads it as a named-field access in either case → struct_recovery sub-score goes 0 → 1, name_quality rises (no `vN` placeholders for struct base + offset arithmetic).  Tightening this to drop the spurious `Deref` for value-typed fields is a Phase 3 polish item.
- **Tripwire check**: every function held or improved; `hook_read`/`hook_write` rose +7.2pp / +7.9pp (no drop, even a fraction).  DWARF-enriched corpus (`02-disasm/`) unchanged at 41.1% (read-only artefact).
- **Justification per HELIX_PHILOSOPHY (fidelity > polish)**: the address arithmetic was structurally a `(base, offset)` field access; the prior pipeline lost this provenance by treating it as opaque, forcing a text-level recovery downstream.  Producing `FieldPtrOp` makes the IR structurally faithful to the binary's `MOV [base+const], val` semantics from the moment Mid is entered, and gives every downstream pass (HelixMidToHigh, DevirtualizeIndirectCalls, struct-recovery analyses) a typed handle on the access pattern.

#### FIX-081 — Attempt: narrow 1-level alias chase in Phase 3.5 walker — REVERTED (`passes/RecoverVariables.cpp`, 2026-05-18)

- **Problem**: After FIX-080, the `v3 = printk(0, v3)` × 4 pattern in `fh_install_hook` persisted because Phase 3.5's `valueDependsOnBase` walker only follows the SSA def chain of value-producing ops.  The printk chain reads RAX indirectly through an `RSI` register-alias assignment (`mov rsi, rax; call printk`), so the call's args at Phase 3.5 time reference an intermediate `VarRef(rsi)` whose varId does not match `base.varId`.
- **Attempted fix**: extended the walker to chase ONE level of intra-block `AssignOp` indirection — when seeing a `VarRefOp(X)` that doesn't match base, look up the most recent `AssignOp` targeting X in the same block and recurse into its RHS.  Strict gating: only active when `verDefAssign.getValue()` is a `low::CallOp` / `high::CallOp`; refuse to cross `MemReadOp` / `MemWriteOp` (struct field access patterns that previously regressed hook_read/hook_write); also added a `siblingVarIds` set so reads of any other already-created SSA version of the same register count as interference.  Patch was 173 lines, all in `RecoverVariables.cpp` Phase 3.5.
- **Result on lift-only corpus**: zero change to scores or output.  Per-pair trace (via temporary `[FIX-081-DBG]` stderr prints) confirmed the walker correctly refused 3 of 5 `(rax, rax_K)` coalesces in Phase 3.5 of `fh_install_hook`.  But the printk-chain C output remained `v3 = printk(0, v3)` × 4.
- **Root cause discovered post-trace**: the surviving distinct RAX SSA versions (preserved by Phase 3.5's refusal) get merged with UNRELATED registers (RBX, RDX, etc.) by Phase 4's cover-based merge, because their live ranges in the per-block sense are disjoint from those other registers.  After Phase 4 merges them, `CAstOptimizer::renameRemainingRegisterVars` (`isPlainRegisterName` matches via `starts_with("rax")` / `starts_with("rbx")` / etc., line 624) sees a single canonical name and assigns one `vN`.  The defect's true root is Phase 4 cross-register coalescing, not Phase 3.5 — strengthening Phase 3.5 cannot fix it without also touching Phase 4, which carries high regression risk on the broader corpus.
- **Tripwire check**: `hook_read` 30.0% → 30.0% (Δ 0.0pp), `hook_write` 27.9% → 27.9% (Δ 0.0pp).  The narrow gating (CallOp-only + Mem refusal) successfully prevented the previously-observed name_quality regression — but also prevented the intended win.
- **Decision**: REVERTED.  Walker restored to FIX-080-only form (no `chaseAliases` parameter, no `siblingVarIds` set, no recent-AssignOp lookup).  Wave 19 ships FIX-078 + FIX-079 + FIX-080 only.
- **Two follow-up options, both deferred** (each carries high regression risk on the broader 70-file corpus that already scores well on the existing Phase 4 / cross-register heuristics):
  1. Extend Phase 4 to refuse cross-register merges when the merged-out variable's history includes a `CallOp` as its source — preserves call-result identity through later renaming.  Risk: Phase 4 is load-bearing across many corpora; this could surface many `vN` placeholders for legitimate disjoint-liveness merges.
  2. Reorder passes so that `inferSemanticNames` runs BEFORE Phase 4, giving distinct call-result variables distinct semantic names (`result_0`, `result_1`, …) that don't match Phase 4's synthetic-name overlap-merge heuristic.  Risk: changes a pass order that has been stable since v0.9.0 Wave 1.

#### FIX-081 (prior round, kept for history) — Investigation: post-call RAX RegWrite synth audit (`passes/RemillToHelixLow.cpp`, 2026-05-18)

- **Hypothesis (carried over from Wave 19 known-gaps)**: `RemillToHelixLow` was suspected of not synthesising `low::RegWriteOp(RAX, callOp.getResult())` after `low::CallOp`s whose callee is an externally-declared symbol (`declare ptr @printk(...)`).  Without that writeback, Phase 1 of `RecoverVariables` would keep all post-call RAX reads on the pre-call SSA version → `v3 = printk(0, v3)` × 4.
- **Audit result**: hypothesis **falsified**.  All 7 `helix::low::CallOp` creation sites in `RemillToHelixLow.cpp` already emit the synth RegWrite when the result type is non-void:
  - Line 1438 (indirect-call path) — synth at 1449-1454.
  - Line 1537 (unrecognised-mangled / external-decl path — the one the hypothesis targeted) — synth at 1547-1552.
  - Line 2511 (segment-relative `__readgsqword(...)` intrinsic load) — produces value via `finalVal = segCall.getResult()` directly into a downstream `RegWriteOp(*destRegName)` at 2538, which is the same semantic.
  - Line 2580 (segment-relative store) — void result, no synth needed.
  - Line 2826 (CALL semantic — the path the printk calls take) — synth at 2840-2845.
  - Line 2919 (JMP→tail-call) — synth at 2930-2935.
  - Line 3704 (CMPXCHG) — void result, no synth needed.
  - Line 3863 (unhandled-semantic fallback) — synth at 3870-3875.
  Each printk call in `fh_install_hook.ll` confirmed (via `[P0-DEBUG] CALL semantic: created CallOp target=printk`) to take the path at 2826 and receive a synth RegWrite.
- **Real root cause of `v3 = printk(0, v3)` × 4**: the synth is in place and `RecoverVariables` Phase 1 IS creating distinct SSA versions for each post-call RAX (`rax`, `rax_1`, `rax_2`, …).  The defect originates downstream in Phase 3.5's coalescing: the call's args at Phase 3.5 time reference an intermediate register variable (`RSI` carries the prior RAX value via `mov rsi, rax`), so FIX-080's `valueDependsOnBase` walker — which only follows the SSA def chain of value-producing ops — does not detect the transitive dependency through the AssignOp that defined RSI.  Adjacent SSA-version pairs `(rax_N, rax_{N+1})` get coalesced because the immediate call-arg VarRefOp targets RSI's varId, not RAX's.
- **No engine code changed**.  The user-directed fix (extending the synth) would be redundant and would duplicate writes.  The proper fix lives in `RecoverVariables.cpp` Phase 3.5 (extend FIX-080's walker to chase one level of intra-block AssignOp → value indirection) — but the previously-tested aggressive variant of this strengthening regressed `hook_read`/`hook_write`/`hook_ia32_write` by 1.1-1.6 pp on `name_quality` (more `vN` placeholders surfaced from refusing legitimate coalescing).  Per the "prefer partial fix that does not regress" rule, this stays deferred until a more targeted condition is identified (probable shape: "ver's def is a CallOp whose args include a VarRef whose immediate prior AssignOp has a value that transitively reads base").

#### Known gaps still open after Wave 19 (deferred)

- **Pattern: `*v3 = v3 + v3` × 8 in `fh_install_hook` tail** — upstream disassembler issue.  Root cause: 8 consecutive Remill `ADDI3MnW...` helpers (`add byte ptr [rax], al`) emitted by the lifter past the function's real RET (likely junk-code lifted from `.text` padding).  All 8 reads of RAX share one SSA version because no `RegWrite(RAX)` separates them; the output is binary-faithful — the binary really does this.  Not a Helix defect.  No band-aid cosmetic in Helix (HELIX_PHILOSOPHY fidelity > polish).  Fix path: stop lifting past the function's last reachable terminator in the disassembler.
- **Pattern: `v3 = printk(0, v3)` × 4 in `fh_install_hook`** — see FIX-081 investigation above.  Real root cause is Phase 4 cross-register coalescing then `renameRemainingRegisterVars` collapsing the distinct SSA versions Phase 3.5 preserved.  Deferred pending a Phase-4-aware fix or pass-order shuffle.

---

## [v0.9.1] — PE lift-path + ELF placeholder cleanup + confidence honesty

### Engine

- **RemillToHelixLow** — LEA write-back for any destination register; SETcc lowers flags to real booleans; BT/BTS/BTR/BTC use the `1 << (off & 63)` mask; AddressSpace GEPs identified structurally so GS/FS segment access no longer collapses to address 0; segment reads/writes emit `__readgsqword` / `__readfsqword` / `__writegs*` intrinsics.
- **RecoverCallingConvention** — detect Win64 entry-point functions and suppress phantom RCX/RDX/R8/R9 parameters.
- **RecoverSwitchTables** — real case values from the analyser; refuse to fabricate a `RetOp` default block on unknown defaults.
- **Engine** — data-section API (`addDataSection` / `clearDataSections`) wired through C, Rust FFI and NAPI so `RecoverSwitchTables` can read jump tables from the host binary.

### C AST

- New passes `removeNullDerefPlaceholderStores` and `removeUnreachableAfterFirstReturn` close G-002 (lift placeholder cascades).
- `analyzeConfidence` / `reanalyzeConfidence` gain penalty terms for unreachable-after-return, null-deref placeholder, suspicious self-reference and identity ops (closes G-015 — confidence on the `malware.ko` `init_module` case falls from 91% to ~50–82%).

### Tools

- `tools/helix-validate` — standalone Python instrument for dataflow-theorem-based output validation, bounded scoring, and cross-version delta.  Stdlib only.

### Release artifact

- `helix-llvm-mlir-deps-win32-x64.zip` rebuilt with the v0.9.1 `helix_engine.lib` (85.47 MB) containing the new symbols.

---

## [v0.9.0-] — Release in 3.8.0 Verify the changelog of HexCoreIDE to more informations.

---

## [v0.9.0-nightly] — 2026-04-17 (UNRELEASED)

> **Nightly build** — Ships inside HexCore `v3.8.0-nightly`. Not for production. Five delivery waves documented below. **0 crashes across a 70-file test corpus** (Malwarebytes, kernel ARM GPU, CTF D-lang, SOTR, Souper-2, Riot Vanguard godmode). `kbase_jit_allocate` went from 14 lines in v0.8.0 to 156 lines in v0.9.0 (+11×) when paired with Pathfinder v0.2.0. `__scrt_common_main_seh` went from 30L flat-collapsed to 74L with full nested if/else trees matching IDA's structure. Godmode Riot Vanguard / Hogwarts Legacy 9–11s.

### Wave 1 — Decompiler Engine Improvements

#### Added

- **Variable Coalescing (Phase 3.5 in `passes/RecoverVariables.cpp`)** — same-register SSA version coalescing with intra-block program-order interference check. `allVersions` tracking in `SSAVersionTracker` records every version created per canonical register. Collapses `rax, rax_1, rax_2` into a single `rax` with reassignments when live ranges don't interfere. Type compatibility check rejects versions with mismatched `inferred_type`. Runs BEFORE Phase 4 (cover-based merge) — register-aware, handles cases Phase 4's block-level overlap rejects.
- **Array/String Detection (`passes/RecoverStructTypes.cpp`, `analysis/StructRecovery.h/.cpp`)** — new `decomposeArrayAccess()` recognises `Add(base, Mul(idx, stride))`, `Add(base, Shl(idx, log2))`, and nested `Add(Add(base, structOff), Mul(idx, stride))` for `s->arr[i]` patterns. Extended `AccessPattern` with `is_dynamic_array`, `stride`, `index_var_id` fields. `buildStruct()` emits `array_<offset>` (stride > 1) or `str_<offset>` (stride = 1, byte access) with `HelixTypeInfo::makeArray()` type. Fallback: constant-offset accesses still handled by existing `decomposeAddress()`.
- **Alias Analysis Expansion (Phase 3.5 in `passes/EscapeAnalysis.cpp`)** — must-alias equivalence class tracking via `(baseSlot, offset)` canonical keys. Traces `AddrOf(other)`, `Add(AddrOf(other), const)`, `var.ref` copy propagation. Groups slots with identical `AliasKey` into numbered equivalence classes. Annotates `helix.alias_class` (`IntegerAttr`) on `var.decl` ops for downstream DCE consumption.
- **RTTI Parsing Tier 1 (`passes/DevirtualizeIndirectCalls.cpp` Phase 4 + `passes/HelixMidToHigh.cpp` + `cast/CAstBuilder.cpp`)** — groups resolved vtable calls by `helix.vtable_addr`, infers class name from common prefix of resolved method names (trimmed to `_` boundary). Fallback: synthetic `Class_0x<ADDR>` when no prefix match. Sets `helix.resolved_name = "ClassName::methodName"` and `helix.class_name` on each CallOp. `HelixMidToHigh` (both pattern-based and manual converter) propagate all `helix.*` attributes. `CAstBuilder` call emission prefers `helix.resolved_name` when it contains `::`, rendering `ClassName::methodName(args)`. Tier 2 (RTTI typeinfo parsing from `.rodata`) deferred until HexCore provides binary data access.
- **Self-Assignment Elimination (`cast/CAstOptimizer.cpp` — `removeSelfAssignments`)** — drops `x = x;` statements from Remill identity operations or SSA coalescing artifacts. Compares by name only (not var_id) — handles separate `CVarRefExpr` instances referencing the same logical variable. Recursively processes nested scopes (if/while/do-while/for/switch/block). Observed: `rax = rax;` in `kbase_jit_allocate` eliminated.
- **Constant Loop Normalisation (`cast/CAstOptimizer.cpp` — extended `eliminateConstantBranches`)** — now handles while/do-while/for loops (previously only if-stmts). Non-zero constant conditions normalised to literal `1`: `while (-1)` → `while (true)`, `do {} while (-1)` → `do {} while (true)`. Zero-condition while loops not removed (rare but possible from unreachable code — kept for safety).
- **Calling Convention Arg Clamping (`passes/RecoverCallingConvention.cpp`)** — call barrier in `collectAbiCallArgs` clears `regState` at every `helix_low.call` op, preventing stale register writes from previous calls bleeding into subsequent call arg lists. `SignatureDb` clamp: known function signatures (via `lookupSignature()`) limit collected args to the correct count. Kernel sync primitive table: inline `llvm::StringMap` with 35+ common Linux kernel functions (`mutex_lock` 1 arg, `down_read` 1 arg, `kfree` 1 arg, `__list_add_valid_or_report` 3 args, etc.). Result: `mutex_unlock(var_70, _promoted_0, 0xA0D, rsp)` → `mutex_unlock(var_70)`.
- **Sequential Variable Naming (`passes/HelixMidToHigh.cpp` — `getSlotNameMap()` + `getSequentialSlotName()`)** — per-pass-invocation slot-to-name map replaces hardcoded `v{slot_id}`. Pre-populated by walking `mid::VarDeclOp`s at pass start: stack slots get `var_<offset>`, params get `param_<N>`, globals get `g_<addr>`, registers/temps get sequential `v0, v1, v2, ...`. Eliminates `v50909`, `v40137`, `v11845` garbage from output — raw slot IDs no longer leak. Map cleared between pass invocations for fresh counters.
- **Dangling Goto Removal (`cast/CAstOptimizer.cpp` — `removeDanglingGotos`)** — drops `goto L;` when label `L` doesn't exist anywhere in the function body. Collects all defined labels (recursively through nested scopes), then erases gotos to undefined targets. Gotos to DEFINED labels are preserved (kernel cleanup patterns are idiomatic — IDA's `kbase_jit_allocate` has 10 gotos).

#### Fixed

- **DominanceInfo Crash Guard (`passes/StructureControlFlow.cpp` — `hasIrreducibleSCCs()` helper extracted)** — SCC Tarjan + BFS reachability check promoted to a standalone function. Guards ALL DominanceInfo/PostDominanceInfo construction sites (4 total): Phase 1 main structuring (already guarded in v0.8.0), Phase 4 goto emission (**new**), `structureIfRegions` while loop (**new**), post node-splitting (**new**). Prevents `GenericDomTreeConstruction.h:481` assert crash when Pathfinder delivers more blocks, creating irreducible CFGs not seen with smaller lifts. Graceful degradation: irreducible functions output flat blocks with goto/label instead of crashing.

#### Benchmark

| Function | v0.8.0 | v0.9.0 Wave 1 | Change |
|----------|--------|---------------|--------|
| `kbase_jit_allocate` (with Pathfinder v0.2.0 IR) | 14L | 133L | **+9.5×** |
| `kbase_jit_allocate` vs IDA | 4.4% | 42.9% | **+38.5pp** |
| Test suite (51 files) | 0 crashes | 0 crashes | maintained |
| Godmode Riot Vanguard (1.6 MB IR) | 8.4s | 12.6s | +50% (extra walks) |

### Wave 2 — Output Quality Pass

#### Added

- **`initializeReadBeforeWriteVars` pass (`cast/CAstOptimizer.cpp` + declared in `CAstOptimizer.h`)** — SSA destruction in `RecoverVariables` produces variables read on some path before any defining assignment (`int64_t lock_2;` followed by `if (...) { return lock_2; }` — undefined-value return). New conservative pre-order pass walks the function body; for each local whose FIRST occurrence is on the right-hand side rather than the left, attaches a default initialiser matching its declared type (`= 0` for ints, `= (void*)0` for pointers, `= 0.0f` for floats). Pointers wrapped in `CCastExpr`; floats use `CFloatLitExpr` directly. Never over-detects; under-detects across if/else branches when one branch writes (documented limitation — full definitely-assigned analysis out of scope). Result: output is compilable C even with read-before-write SSA patterns. 161 vars correctly left uninitialised; 204 vars now correctly initialised.
- **`tryStripRepPrefix` helper (`cast/CAstOptimizer.cpp`)** — Remill emits REP-prefixed string ops as wrapper functions (`DoREPE_CMPSB`, `DoREPNE_SCASB`, `DoREP_MOVSB`). The `Do` lowercase second char causes `isNativeOpcodeName` to reject them, leaving raw calls in output. New helper detects the three Remill prefixes and rewrites: `DoREP_<MNEMONIC>` → `rep_<mapped>`, `DoREPE_<MNEMONIC>` → `rep_while_equal_<mapped>`, `DoREPNE_<MNEMONIC>` → `rep_while_not_equal_<mapped>`. Result: `DoREPE_CMPSB(v4)` → `rep_while_equal_string_compare_byte(v4)`.
- **`kSemanticMap` expansion (`cast/CAstOptimizer.cpp`)** — integer multiplication/division with implicit-register suffix stripping (`MUL/IMUL/DIV/IDIV` → `umul_full/imul_full/udiv_full/idiv_full`; handles `MULrax`, `DIVrdxrax`, `IMULrax` via existing suffix-walker). String operations (`CMPSB/W/D/Q` → `string_compare_*`, `MOVSB/W` → `string_move_*`, `SCASB/W/D/Q` → `string_scan_*`, `STOS/LODS` → `string_store/load`). x87 floating point (`FMUL/FADD/FSUB/FDIV/FSQRT/FABS/FCHS/FSIN/FCOS/FPREM`).

#### Fixed

- **`isNativeOpcodeName` library-symbol false positives (`cast/CAstOptimizer.cpp`)** — previous shape-based detector (`UPPER+UPPER+...+lower*`) would falsely classify library/runtime identifiers like `IO_read`, `PR_init`, `TLS_setup`, `OSPanic`, `IOError`, `JNIInit`, `HTMLParser` as native CPU opcodes and rename them to `__native_*`. Two-rule hardening:
  - **Rule A** (`_<lower>` rejection): an underscore directly followed by a lowercase letter is the unmistakable library `<PREFIX>_<word>` shape. Catches `IO_read`, `PR_init`, `GFP_kernel`, `NSS_init`, `XML_parse`.
  - **Rule B** (curated 40-entry library prefix deny-list): compares the leading uppercase prefix against a known list of namespace prefixes never valid as x86/ARM mnemonics (`IO, OS, JNI, JS, WS, HTML, XML, TLS, SSL, NSS, HTTP, HTTPS, DNS, EGL, GLES, D3D, DXGI, GTK, QT, GFP, BSD, POSIX, IPC, RPC, AI, FX, VFX, SFX, GFX, …`).
  - All-uppercase mnemonics still pass (`VMOVDQA, FNCLEX, FSQRT, RDTSC, BTS, XADD`) because Rule B is gated on `sawLower == true`. 0 spurious renames across 70-file corpus.
- **`collapseAssignBeforeReturn` skipping CallExpr (`cast/CAstOptimizer.cpp`)** — the pass previously skipped `tmp = foo(); return tmp;` patterns when the value was a `CallExpr`, citing safety. There's no actual safety concern: the call executes at the same point either way. Removed the skip. Now correctly folds `tmp = foo(); return tmp;` → `return foo();`.

### Wave 3 — Critical Output Quality Fixes

#### FIX-027 — Frame Pointer Leak Resolver Restricted to Call-Arg Position (`cast/CAstOptimizer.cpp`)

- **Problem**: `resolveFramePointerLeaks` rewrote `var ± const` → `&var_X` everywhere, including arithmetic contexts. `kbase_jit_allocate` produced `lock_2 -= &var_80` — semantically nonsense since the original was a SIZE computation `lock_2 -= rbp - 128`, not an address operation.
- **Fix**: Split traversal into `resolveFrameRefsInExpr` (with new `inArgPosition` parameter) and `resolveFrameRefsInChildren` (recursive walker that propagates the flag). Address-of substitution is now applied ONLY when the expression appears as a function-call argument (`foo(rbp - 128)` → `foo(&var_80)`). Arithmetic operands of `+=`, `-=`, `*`, etc. left as raw arithmetic.
- **Result**: `lock_2 -= &var_80` → `lock_2 -= v13 - 128`. Legitimate `&var_40`/`&var_38` references in `kbase_alloc_phy_pages_helper_locked(..., &var_40)` calls still recognised.

#### FIX-028 — `__expr` Placeholder Leakage Eliminated (`cast/CAstBuilder.cpp`)

- **Root cause**: `exprToString` returns the literal string `"__expr"` as a placeholder for any expression that can't be flattened to an identifier (BinaryExpr, CallExpr, FieldAccessExpr, etc.). This sentinel was being stored in the `lastRegValue_` and `exprToBestName_` copy-propagation caches. The downstream `resolveTransitive` lookup at variable-reference build sites would then return `"__expr"` as a "resolved name", emitting the literal string in the final output (13 occurrences across the corpus: `*v4 = (int32_t)__expr;`, `sub_1403b53a0(v3 + 96, (int64_t)__expr->field_0x240);`, `_dev_warn(__expr->field_0x28, 0);`).
- **Fix**:
  - **Belt**: detect `valueStr == "__expr"` / `targetStr == "__expr"` at the assignment-build site and skip caching the entry entirely.
  - **Suspenders**: defensive check inside `resolveTransitive` — never resolve to the `"__expr"` sentinel even if it somehow got into the cache.
- **Validated**: 13 → 0 occurrences across the full 70-file corpus.

#### FIX-029 — Float Literal Printer `0.0f` Suffix (`cast/CAstPrinter.cpp` + `cast/CAstOptimizer.cpp`)

- **Problem chain**:
  - `initializeReadBeforeWriteVars` initially built float defaults as `CCastExpr(float, IntLit(0))`, producing `(float)0` in output.
  - `cleanupFloatZeros` runs at line 176 of `optimize()`; the new pass at line 190 ran AFTER, so the cast was never cleaned.
  - Even after switching to `CFloatLitExpr` directly, the printer used `%g` which formats `0.0` as `"0"` — losing the float-ness of the literal.
- **Fix**: `makeDefaultInitFor(Float)` constructs `CFloatLitExpr(0.0)` directly. Printer (`CAstPrinter.cpp:112`) post-processes `%g` output: appends `.0` when no decimal point or exponent is present, and appends `f` suffix when the type is 32-bit float.
- **Result**: `float v3 = (float)0;` → `float v3 = 0.0f;`

### Wave 4 — Test Coverage + Documentation

- **Test corpus expanded 51 → 70 files**: added the SOTR (Shadow of the Tomb Raider) set at `C:\Users\Mazum\Desktop\HexCore-SOTR\hexcore-reports\sotr-decompile\*.ll` (5 files) and the Souper-2 kernel set at `fresh-helix-souper-2/*.ll` (7 files, including `kbase_jit_allocate.ll`). All 70 files pass with 0 crashes.
- **Quality scan across 3,377 lines of output (post-fix)**: 0 `__expr` (was 13), 0 `__unknown_`, 0 `__native_`, 0 `__cond`, 0 `__tmp_`, 0 `_promoted_`, 0 `sub_indirect`. 70/70 functions report 100% confidence (High).
- **Upstream-ceiling document** documents the 5 specific output-quality issues that cannot be solved inside the Helix engine and require Remill or HexCore upstream changes:
  1. Variable type confusion across SSA destruction (TIE-style DVSA needed pre-Helix)
  2. Missing function-call arguments (LLVM dropped arg-register stores before lifting)
  3. INC/DEC `[mem]` decomposed as LEA-store (`v3->field_0xC5E9 = v3 + 0xC5E9 + 1` — Remill semantic bug)
  4. Early-return-of-uninitialised-value (per-exit return value not preserved)
  5. Indirect call argument count (vtable calls only carry `this` pointer)

### Wave 12 — Content recovery: goto/label emission + dead-tail preservation (2026-04-18)

> Two complementary fixes that together close ~60% of the IDA-vs-Helix content gap on the ARM64 kernel corpus.  FIX-050 prevents `removeDeadCodeAfterReturn` from erasing reachable side-effecting calls in tails.  FIX-051 completes the missing fallback by emitting explicit `goto LABEL_N;` and `label:` pairs for `helix_low.jmp` / `helix_low.jcc` terminators that `StructureControlFlow` couldn't schema-match — previously those were silently dropped (returned `nullptr` in CAstBuilder), now they appear as structured gotos matching IDA's presentation of compiler-inserted error-recovery paths.

#### FIX-051 — Goto/label emission for non-structured jumps (`cast/CAstBuilder.cpp`)

- **Problem**: `helix_low.jmp` and `helix_low.jcc` ops that survived `StructureControlFlow` (because the CFG pattern didn't match any if/while/do-while schema) landed at top scope and were **silently dropped** — `buildStatement` returned `nullptr` at lines 1381/1385 (pre-fix), and `shouldSkip` (line 3165 pre-fix) marked both as always-skippable.  The `referencedBlocks_` container (declared at CAstBuilder.h:184) that was supposed to trigger label emission in `buildRegionBody` (line 771) was NEVER POPULATED.  The combined effect: every kernel `goto LABEL_N` / error-recovery diamond in the lifted IR just vanished.
- **Fix (three coordinated changes)**:
  1. **Populate `referencedBlocks_`** in `buildFunction` (line 390 new): walk every `helix_low.jmp` / `helix_low.jcc` and insert their target successor blocks.  This turns on the pre-existing label-emission path.
  2. **Emit `CGotoStmt` for `helix_low.jmp`** when the target is NOT the immediately-next sibling block in the region (fall-through case stays `nullptr`).  Lookup label via `blockLabels_.find(target)`.
  3. **Emit `CIfStmt(cond, goto T)`** or `CIfStmt(!cond, goto F)` for `helix_low.jcc`, letting whichever target IS the next block fall through.  When neither target is next, emit a `CBlockStmt` containing `if (cond) goto T; goto F;` to preserve both edges.  Condition expression comes from `buildExpression(jcc.getFlagValue())`.
  4. **Remove the unconditional skip** in `shouldSkip` for JmpOp/JccOp so the new emission path is reachable (line 3163 pre-fix).
- **Reference / adapted from**: Ghidra `blockaction.cc:1450 CollapseStructure::ruleBlockGoto` + `:1468 newBlockGoto` / `:1457 newBlockMultiGoto`.  When Ghidra's schema-match fails, it falls back to emitting explicit goto + label nodes.  Helix's equivalent fallback path was missing until FIX-051.

#### Combined FIX-050 + FIX-051 impact — 6-corpus table

| Corpus | File | Pre-Wave-12 | Post-FIX-051 | Δ |
|---|---|---:|---:|---:|
| Malwarebytes | 02-entry | 12 | 12 | 0 |
| | 04-sub_14001433c | 25 | 26 | +1 |
| | **06-sub_140013adc** (smoke ≥70) | **79** | **97** | **+18** |
| | 08-sub_140013790 | 26 | 27 | +1 |
| Intigrity OLD | csf_queue_register | 26 | 27 | +1 |
| | **context_mmap** | **156** | **566** | **+410** |
| | **kbase_jit_allocate** | **145** | **310** | **+165** |
| | **kbase_mem_alloc** | 155–160 | **429–433** | **+270+** |
| | **kbase_mem_commit** | 81 | **206** | **+125** |
| | **kbase_mem_free** | 10 | **100** | **+90** |
| | **kbase_mem_import** | 37 | **589** | **+552** |
| LARA CTF | cmpsb-compare | 29 | 33 | +4 |
| | overflow-check | 16 | 16 | 0 |
| | validation-success-fail | 42 | 45 | +3 |
| SOTR | **HealthData-read** | 52 | **132** | **+80** |
| | **RPC-Die / RPC-SetHit / RPC-SetInv** | 349 each | **380** each | **+31 each** |
| | **Recoil-mulss-region** | 68 | **128** | **+60** |
| gta-sa | 01/03/05/08/10/11/12/12a/14 (9 files) | same | same | 0 |
| | 02-fld-global | 38 | 40 | +2 |
| | 04-camera-cmd | 107 | 107 | 0 |
| | 06-anim | 18 | 23 | +5 |
| | **07-network** | 51 | **114** | **+63** |
| | 09-config | 68 | 80 | +12 |
| | **13-autobacktrack** | 18 | **113** | **+95** |
| Godmode | godmode_retry3 | 820 | 820 | 0 |

**Zero crashes. Zero regressions. Fourteen files with significant content recovery (+5 to +552 lines).**

- **Determinism**: `kbase_jit_allocate` 310±1 across 5 runs (stable).  `kbase_mem_alloc` 429-433 (same ±3 pre-existing DenseMap jitter, unchanged by FIX-051).
- **Quality note**: confidence score on `kbase_jit_allocate` dropped from 90.3% High → 70.3% Medium — this is EXPECTED, because the confidence scorer legitimately penalizes goto-heavy output (IDA ground truth has 16 gotos, our output has 43 — the scorer correctly flags this).  The goto count mismatch is a Wave 13 follow-up (SAILR ISD/ISC deoptimization will consolidate goto diamonds back into if/else).

#### FIX-050 — Preserve side-effecting tails in `removeDeadAfterReturnInList` (`cast/CAstOptimizer.cpp`)

> Targets the real IDA-vs-Helix gap (content loss, not polishing).  Diagnostic traces on `kbase_jit_allocate` showed 6 kernel API calls (`_dev_info`, `_dev_err`, `__kbase_tlstream_jit_alloc`, `kbase_set_phy_alloc_page_status`, `kbase_free_phy_pages_helper_locked`, `__stack_chk_fail`) present in the HelixHigh MLIR (54 `helix_high.call` ops survive all passes), reaching CAstBuilder (all 6 visible as AssignOp-of-call at scope level with `skip=0, dead=0`), and surviving into the CFuncDecl tree with 90 initial statements — then being erased by `removeDeadCodeAfterReturn` in one shot, dropping stmts 90→64 (-26 stmts, all 6 hunt calls lost).  Root cause: `helix_low.jmp` terminators never emit a `CGotoStmt`, so error-recovery blocks that are reachable only through low-level jumps appear in the AST as sequential statements AFTER an earlier `ReturnStmt`.  `removeDeadCodeAfterReturn`'s naive "erase everything after a return at the same scope level" collapses the entire reachable error-recovery tail.

#### FIX-050 — Preserve side-effecting tails in `removeDeadAfterReturnInList` (`cast/CAstOptimizer.cpp`)

- **Problem**: `removeDeadAfterReturnInList` erased every statement after the first `ReturnStmt`/`BreakStmt`/`ContinueStmt`/`GotoStmt`/infinite-loop at the current scope level.  For kernel functions with compiler-inserted `goto LABEL_23` / `goto LABEL_29` error-cleanup paths, these blocks exit the reach of Helix's `StructureControlFlow` (which only schema-matches if/while/do-while shapes) and land in the top-level scope as un-labeled statement sequences.  The pass then destroyed them.
- **Fix**: Added two helpers inside `removeDeadAfterReturnInList`:
  1. `containsCallExpr(expr)` — recursive tree walk that returns true if any `CCallExpr` node is reachable from the root of an expression tree.  Covers all the expression kinds currently produced by CAstBuilder (Binary/Unary/Cast/Ternary/Subscript/FieldAccess/Call).
  2. `tailHasSideEffect(stmts)` — recursive statement walk that returns true if any contained statement has a call-valued expression anywhere (AssignStmt value/target, ExprStmt expr, ReturnStmt value, If-condition + nested bodies, While/DoWhile conditions + bodies, For/Switch/Block nested bodies).
- When the pass would erase a tail, it now first moves the tail out, checks `tailHasSideEffect(tail)`, and **restores the tail** if true.  The "maybe dead" region is kept because dropping reachable calls is strictly worse than leaving genuinely dead assignments in the output.  Real dead tails (just `var = const;` assignments) still get pruned.
- **Why this is the minimum viable fix**: the alternative is to wire up `helix_low.jmp` → `CGotoStmt` emission plus `CLabelStmt` insertion for jump targets, which requires either (a) populating `referencedBlocks_` in CAstBuilder (currently declared-but-never-populated, line 184 of CAstBuilder.h) or (b) a new StructureControlFlow phase that synthesizes explicit goto/label pairs for non-schema CFG edges.  Both are multi-session projects.  FIX-050 buys back the missing content now; FIX-05x later can add proper goto structuring in Wave 13.

- **Observed impact on `kbase_jit_allocate` (primary Wave 12 target)**:

| Metric | Pre-FIX-050 | Post-FIX-050 | Δ |
|---|---:|---:|---:|
| Line count (.c) | 145 | **176** | **+31** |
| Total calls | 16 | **31** | **+15** |
| Hunt-calls recovered (7 targets) | 0 | **6** (all except `kbase_mem_pool_grow`, which dies in an earlier MLIR DCE path — separate issue) | +6 |
| Determinism (5 repeat runs) | stable at 145 | stable at 176 | — |

- **6-corpus validation (before_llL / after_llL, after_cL = same value since this pass runs on the AST)**:

| Corpus | File | before_llL | after_llL | Δ |
|---|---|---:|---:|---:|
| Malwarebytes | 02-entry / 04-14001433c / 08-140013790 | 12 / 25 / 26 | 12 / 25 / 26 | 0 |
| | **06-sub_140013adc.ll** (smoke ≥70 gate) | **77** | **79** | **+2** (smoke PASSES) |
| Intigrity OLD | csf_queue_register | 26 | 26 | 0 |
| | context_mmap | 156 | 178–183 (flaky, median 181) | **+22 to +27** |
| | **kbase_jit_allocate** | **145** | **176** (deterministic) | **+31** |
| | kbase_mem_alloc | 155–160 | 159–164 (flaky, same jitter) | +4 median |
| | kbase_mem_commit | 81 | 81–84 (flaky) | ±3 |
| | kbase_mem_free | 10 | 22–48 (flaky) | **+12 to +38** |
| | kbase_mem_import | 37 | 258–266 | **+221 to +229** (huge recovery) |
| LARA CTF | cmpsb / overflow / validation | 29 / 16 / 42 | 29 / 16 / 42 | 0 |
| SOTR | HealthData / RPC-Die / RPC-SetHit / RPC-SetInv / Recoil-mulss | 52 / 349 / 349 / 349 / 64 | same | 0 across all 5 |
| gta-sa 01-05 / 08-12 / 12a / 14 | all 10 files | same | same | 0 |
| | **06-anim** | 18 | 22 | +4 |
| | **07-network** | 51 | **90** | **+39** |
| | **13-autobacktrack** | 18 | **65** | **+47** |
| Godmode | godmode_retry3 | 816 | 820 | +4 |

**Total corpus: 13 files unchanged (Malwarebytes-3, LARA-3, SOTR-5, gta-sa non-affected 10, csf_queue), TWO files recovered slightly (sub_140013adc +2, Godmode +4), EIGHT files recovered significantly (all 6 kernel + 2 gta-sa + 1 malware smoke-1), ZERO crashes, ZERO corpora regressed.**

- **Known quality issue (tracked for Wave 13)**: recovered tails appear AFTER a `return v2;` at top scope, which is technically unreachable C.  IDA presents them as labeled goto targets (`LABEL_23:`, `LABEL_29:`, etc.).  Helix currently emits them as a sequential dump without labels — the CONTENT is correct and matches the binary's reachable set, but a reader must mentally reconstruct the `goto` edges.  Wave 13 scope: populate `referencedBlocks_` in CAstBuilder + emit `helix_low.jmp` → `CGotoStmt` conversions, so these blocks get proper `LABEL_NN:` prefixes and the preceding `return` flows naturally through gotos.
- **Reference**: Ghidra `coreaction.cc:1768 CollapseStructure::collapseInternal` and `blockaction.cc:1450 ruleBlockGoto` handle this case by explicitly emitting `BlockGoto` / `BlockMultiGoto` nodes when a schema-match fails and a low-level jump remains.  The equivalent in Helix is StructureControlFlow's fallback behavior, which currently drops through without emitting.

### Files Modified (Wave 12)

| File | Changes |
|------|---------|
| `engine/src/cast/CAstOptimizer.cpp` | `removeDeadAfterReturnInList` now checks `tailHasSideEffect(tail)` before erasing; restores the tail when true. Two new helper lambdas (~85 LoC) inside the pass function. FIX-050. |
| `engine/src/cast/CAstBuilder.cpp` | (1) `buildFunction`: populate `referencedBlocks_` by walking JmpOp/JccOp terminators (~20 LoC).  (2) `buildStatement`: emit `CGotoStmt` for non-fall-through JmpOp and `CIfStmt(cond, goto T)` / `CBlockStmt{if goto T; goto F;}` for JccOp (~80 LoC).  (3) `shouldSkip`: remove blanket JmpOp/JccOp skip. FIX-051. |

### Wave 11 — Kernel-corpus correctness pass (2026-04-18)

> After the Wave-10/11 research gap analysis (see `docs/AgentsNoGit/RESEARCH_HELIX_VS_IDA_GAP.md` §5 pivot) the plan's top item (BtfStructTypeInjector) was deferred — no BTF JSON ground-truth in the target corpus, pass would be untestable.  The three tactical items attempted this session (A param-trial culling, B loop-latch hoisting, C kernel macro names) either ran into Remill-semantics limits (A — R8/R9/RCX read as 64-bit via union-GEP aliasing) or had zero surface area on the current corpus (B, C).  Wave 11 ultimately ships ONE correctness fix (FIX-049) that lands cleanly across 32 files with zero regressions and measurably purges FIX-031 artifacts the existing `removeAdjacentDuplicateStmts` pass missed.
>
> **Session scorecard**: `kbase_jit_allocate` at 157 L pre-Wave-11, 145 L post-Wave-11 — 12 duplicate-call pairs eliminated (correctness gain, not a move toward IDA's 318 L reference).  Closing the remaining 173 L of the IDA gap is genuinely multi-wave work dominated by **content recovery from collapsed control-flow branches** (see §5 addendum in the research doc).

#### FIX-049 — Same-origin duplicate call-emission elimination (`cast/CAstOptimizer.cpp`)

- **Problem**: FIX-031 (Wave 5) added a synthetic-RAX-RegWrite companion to every `helix_low.call` so that return values get captured into a named variable.  In multi-use call chains this routinely emits the same call TWICE — once as a bare `CExprStmt` (for side effects) and once as the value side of an adjacent `CAssignStmt` that captures the return register.  The pre-existing `removeAdjacentDuplicateStmts` pass handled only the `foo(); foo();` (two ExprStmts) case and only when all args were literal constants — it missed the mixed `foo(x); v = foo(x);` pattern with variable args.  Observed impact on the Apr-12 Intigrity kernel corpus: 12 pairs in `kbase_jit_allocate`, 7 in `kbase_mem_alloc`, 4 in `kbase_mem_commit`, 1 in `kbase_mem_import`; 2 in malwarebytes `sub_140013adc`, 1 in SOTR `Recoil-mulss-region`.
- **Fix**: Added a second pass scan inside `removeDuplicatesInList` (adjacent to the existing literal-arg case, same pass slot in the optimizer pipeline).  The new scan fires on statement pairs `[CExprStmt(CCallExpr), CAssignStmt(target=VarRefExpr, value=CCallExpr)]` when both call expressions are `exprEqual` (same target name + same arg tree) AND their call-site addresses either match or are both zero.  Addresses that are non-zero AND different identify genuine back-to-back calls in the source; those are preserved.  The orphan `CExprStmt` is dropped; the capturing `CAssignStmt` remains as the single emission for the underlying MLIR `CallOp`.
- **Safety conditions (all must hold)**:
  1. Statement `i` is `CExprStmt` with a `CCallExpr` expression.
  2. Statement `i+1` is `CAssignStmt` with target of kind `VarRefExpr` and value of kind `CCallExpr`.
  3. The two `CCallExpr` nodes satisfy `exprEqual` (same `targetName` + identical arg tree, recursive).
  4. `callA.address == callB.address` OR both are zero.  When both are non-zero AND different, the stmts are distinct call sites — preserved.
- **6-corpus results (post-FIX-049 vs pre-Wave-11 baseline)**:

| Corpus | File | Before | After | Δ |
|---|---|---:|---:|---:|
| Malwarebytes | 02-entry.ll | 12 | 12 | 0 |
| | 04-sub_14001433c.ll | 25 | 25 | 0 |
| | 06-sub_140013adc.ll | **79** | **77** | **−2** |
| | 08-sub_140013790.ll | 26 | 26 | 0 |
| Intigrity OLD | kbase_context_mmap.ll | 156 | 158 | +2 (AST-structure side effect, still clean C) |
| | kbase_csf_queue_register.ll | 26 | 26 | 0 |
| | **kbase_jit_allocate.ll** | **157** | **145** | **−12** |
| | kbase_mem_alloc.ll | 166 | 156 | **−10** |
| | kbase_mem_commit.ll | 87 | 81 | **−6** |
| | kbase_mem_free.ll | 10 | 10 | 0 |
| | kbase_mem_import.ll | 38 | 36 | **−2** |
| LARA CTF | cmpsb-compare.ll | 29 | 29 | 0 |
| | overflow-check.ll | 16 | 16 | 0 |
| | validation-success-fail.ll | 42 | 42 | 0 |
| SOTR | HealthData-read.ll | 52 | 52 | 0 |
| | RPC-Die-caller.ll | 349 | 349 | 0 |
| | RPC-SetHitPoints-caller.ll | 349 | 349 | 0 |
| | RPC-SetInvincible-caller.ll | 349 | 349 | 0 |
| | Recoil-mulss-region.ll | 68 | 64 | **−4** |
| gta-sa (15 files) | all | same | same | 0 across all 15 |
| Godmode | godmode_retry3.ll | 820 | 816 | −4 |

- **Output determinism** (post-deploy 5×-repeat sanity): `kbase_jit_allocate` 145 L (deterministic), `sub_140013adc` 77 L (deterministic), `kbase_context_mmap` 158-159 L (±1), `RPC-Die` 349 L (deterministic).  **Non-deterministic**: `kbase_mem_alloc` 151/155/157/158 across 5 runs; `kbase_mem_commit` 78/81/81 across 3 runs.  Jitter is PRE-EXISTING (DenseMap/DenseSet iteration-order dependency in `propagateCopies` / `dseStmtList`) — FIX-049 itself is a deterministic `std::vector<StmtPtr>` sequential erase.  Worst-case numbers are still strictly better than pre-Wave-11 baseline (166 / 87).  Cross-check agent: flaky-numbers apply to `mem_alloc` + `mem_commit` ONLY; all other measurements in this table are deterministic.
- **Direction note vs IDA**: line-count drops are correctness improvements (removed double-emitted calls) — not progress toward IDA's 318-L reference for `kbase_jit_allocate`.  The remaining IDA gap is dominated by content Helix never emits in the first place (29 missing calls inside collapsed branches, 17 missing if-statements, 16 missing labels/gotos per qualitative diff in `RESEARCH_HELIX_VS_IDA_GAP.md` §1).  Ship as-is; content recovery is Wave 12+.

### Files Modified (Wave 11)

| File | Changes |
|------|---------|
| `engine/src/cast/CAstOptimizer.cpp` | New second scan inside `removeDuplicatesInList` (~70 LoC) eliminates same-origin `CExprStmt(call); CAssignStmt(var = call);` pairs when call-site addresses prove shared origin.  FIX-049. |

### Wave 11 — Items Investigated & Deferred

- **Item A (param-trial culling, original FIX-049)** — attempted to fix 6→3 param over-count on `kbase_jit_allocate` via sub-byte-only read filter.  Diagnostic revealed Remill IR contains `load i64, ptr %CL` patterns (reading full RCX via CL's GEP pointer via C-style union aliasing), so `RegReadOp` width is correctly 64 for all 6 args.  Real fix requires dead-forward-slice analysis (Ghidra `ActionActiveParam` style) — out of scope for single session.  **Deferred to Wave 12.**
- **Item B (loop-latch condition hoisting)** — target pattern `while(true){...break...}` has zero occurrences in `kbase_jit_allocate` baseline (pattern is SOTR XMM-fcmp specific).  **Zero ROI on kernel corpus.**
- **Item C (kernel macro pretty-print)** — `BUG()`, `dev_info`, `dev_err` are absent from current Helix output not because of emitter omissions but because the if-branches containing them are collapsed earlier in the pipeline.  Extending the symbol DB without fixing the structural collapse has no visible effect.  **Gated on Wave 12 control-flow-recovery work.**

### Wave 10 — Infrastructure attribute unification + lvalue-safe simplifier (2026-04-18)

> Two small, surgical engine fixes targeting long-standing "band-aid filter" debt called out in MEMORY.md. The changes are architecturally cleaner than the post-hoc downstream filters they replace, and they harden the assignment-target code path against a class of malformed-C outputs (`0 = rhs;`). No observable output regressions on the malwarebytes, SOTR, and gta-sa stress corpora; build is clean (`EXIT_CODE=0`); smoke test on `06-sub_140013adc.ll` stays at 79 lines (≥70 required).
>
> **Post-ship bisect (FIX-048 below)**: a regression reported on `kbase_jit_allocate.ll` (NEW Intigrity corpus, Apr 18) turned out to be an **upstream pipeline issue** — the regenerated `.ll` input is 630 lines vs the Apr 12 baseline's 2657 lines (64 vs 455 br/call/label ops, 4× truncation). Running FIX-047's engine on the *OLD* `.ll` produces byte-identical 157-line output to the Apr 12 baseline for `kbase_jit_allocate`. The three-part FIX-047 bisect (see FIX-048) independently eliminated each part and in every case the NEW `.ll` still produced 24 lines — proving FIX-047 is not the cause. The collapsed output is tracked as an upstream-disassembler/Remill issue, not a Helix regression.

#### FIX-047 — Unify x86 EFLAGS under the infrastructure-register umbrella (`passes/PropagateTypes.cpp`)

- **Problem**: `isInfrastructureRegister` in `PropagateTypes` only recognised PC / NEXT_PC / RETURN_PC / BRANCH_TAKEN / BRANCH_NOT_TAKEN / RIP / rip as infrastructure. The x86 EFLAGS bits (CF, PF, AF, ZF, SF, DF, OF, TF, IF, NT, RF, VM, AC, VIF, VIP, ID) that Remill models as single-bit RegReads — same pattern, same purpose — were missed by the Pass 1/2/3 infrastructure pre-scan. Four downstream passes (`RecoverVariables`, `CAstBuilder`, `EliminateDeadCode`, `PseudoCEmitter`) each carried partial overlapping flag-name lists to clean up the leftovers. The architectural duplication meant every new Remill-side flag introduction needed updates in five places instead of one.
- **Fix**: Add the 16 EFLAGS bits plus `EIP`/`eip` to `isInfrastructureRegister`. Pass 1's direct-seed loop now marks `RegReadOp("CF")` etc. as infrastructure; Pass 2's transitive closure covers `BinOp(RegRead("CF"), const)` and similar compositions; the `helix.infrastructure` attribute is set uniformly. Downstream filters remain in place as belt-and-braces (the corpus shows them already catching the tail), but the engine now has a single canonical list.
- **Measured impact**: zero observable change on malwarebytes `sub_140013adc.ll` (79L), SOTR `HealthData-read.ll` (52L), `RPC-*-caller.ll` (349L each), `Recoil-mulss-region.ll` (67L), and gta-sa files 03/04/10/14 (26/107/11/16L). The downstream filters were already catching these particular corpora's flag uses; the win is architectural consistency and hardening against future regressions where a new Remill-side flag name lands before a downstream filter is updated.

#### FIX-047 (cont.) — Lvalue-safe expression simplifier + malformed-target guard (`cast/CAstOptimizer.{h,cpp}` + `cast/CAstBuilder.cpp`)

- **Problem**: `simplifyExpr` was invoked on the LHS of `CAssignStmt` via `simplifyExprInStmt(a.target)` (line 4916, pre-fix). Its `*((T)NULL) → 0` rule (FIX-042) fires unconditionally, collapsing a legitimate lvalue designator into an integer literal — which, when rendered, emits `0 = rhs;` (observed in SOTR's `HealthData-read.c` line 40, pre-fix). Any legal C parser rejects assignment to a non-lvalue.
- **Fix (three layers)**:
  1. Added an `isLValue` parameter to `CAstOptimizer::simplifyExpr` (header + implementation). The bottom-up recursion sets `isLValue=false` at every transition where the child is an rvalue by C semantics (binary-op operands, cast operand, call args, ternary branches, subscript base / index, field-access base, unary operand of `*`). The top-level caller (`simplifyExprInStmt`) passes the caller-supplied flag through.
  2. `simplifyStmtList` now calls `simplifyExprInStmt(a.target, /*isLValue=*/true)` and `(a.value, false)`. The `*((T)NULL) → 0` rewrite is guarded by `if (!isLValue && ...)`, so assignment targets are preserved.
  3. `CAstBuilder::buildStatement` adds a defensive check on three assignment-producing paths (`helix::high::AssignOp`, `helix::low::MemWriteOp`, `LLVM::StoreOp`): if the built target expression resolves to a bare `CIntLitExpr` (e.g. from a `__remill_undefined_{8,16,32,64}` intrinsic collapsing to `CIntLitExpr(0)` at line ~2429), the statement is either dropped, or — if the RHS is a `CCallExpr` with potential side effects — converted to a bare `CExprStmt` preserving the call. This ensures no malformed assignment can reach the printer even if a future CAstOptimizer pass accidentally lands an integer literal in the target slot.
- **Tests**: `sub_140013adc.ll` baseline (79L) unchanged. SOTR and gta-sa line counts unchanged. No regressions. The specific `0 = sub_14026f5b0(v5, v4);` line in `HealthData-read.c` line 40 persists — diagnostic runs confirmed the three defensive guards in `CAstBuilder` are not hit for this case, meaning the malformed target is produced by a fifth code path not yet located (possibly an intra-CAstOptimizer transform that rewrites `a.target` to a literal without going through `simplifyExpr`). The `simplifyExpr` isLValue path is correct and shipping; the `0 = sub_…` in this one file is tracked as a separate known issue for Wave 11.

### Files Modified (Wave 10)

| File | Changes |
|------|---------|
| `engine/src/passes/PropagateTypes.cpp` | `isInfrastructureRegister` extended with 16 x86 EFLAGS bits + EIP/eip (FIX-047 part 1) |
| `engine/include/helix/cast/CAstOptimizer.h` | `simplifyExpr` / `simplifyExprInStmt` gain `bool isLValue = false` parameter (FIX-047 part 2) |
| `engine/src/cast/CAstOptimizer.cpp` | `simplifyExpr` propagates `isLValue=false` on rvalue sub-positions; `*((T)NULL) → 0` rule guarded by `!isLValue`; `simplifyStmtList` passes `isLValue=true` for `CAssignStmt::target` (FIX-047 part 2) |
| `engine/src/cast/CAstBuilder.cpp` | Three defensive guards drop CAssignStmts whose built target is a bare `CIntLitExpr` (`helix::high::AssignOp`, `helix::low::MemWriteOp`, `LLVM::StoreOp`); RHS calls preserved as `CExprStmt` (FIX-047 part 2) |

#### FIX-048 — FIX-047 bisect exonerates engine; `kbase_jit_allocate.ll` collapse is upstream

- **Report**: user flagged `kbase_jit_allocate.ll` in the NEW `fresh-helix-souper-2` Intigrity corpus collapsing from 157 lines (Apr 12 baseline) to 24 lines, attributing the regression to FIX-047.
- **Investigation** (six-corpus full battery + three-way bisect):
  - Ran the current FIX-047 engine against the *OLD* `.ll` input in `fresh-helix-souper-2-velho/`. Output: **158 lines, byte-identical body diff vs the saved Apr 12 baseline** after CRLF/LF normalization and header-version-tag stripping. Apples-to-apples: no regression.
  - Ran the current FIX-047 engine against the *NEW* `.ll`. Output: 24 lines.
  - Compared the two `.ll` inputs: OLD = 2,657 lines, 455 `br`/`call`/label-tagged ops; NEW = 630 lines, 64 such ops. **The NEW `.ll` is a 4× truncated lift produced by an upstream regeneration run.** This is the root cause of the 24-line output — Helix cannot reconstruct what is not in the IR.
  - Three-way bisect of FIX-047 (revert one part at a time, rebuild, re-test): reverting **Part 1** (EFLAGS infra), **Part 2a** (isLValue simplifier), or **Part 2b** (CAstBuilder literal-target guards) individually **never raised the NEW `.ll`'s output above 24 lines**. The NEW `.ll`'s output is invariant under any subset of FIX-047 — proving the regression is not caused by FIX-047.
  - 6-corpus final battery run (all 32 files): zero crashes, all outputs sane. `sub_140013adc.ll` stays at 79L; SOTR/LARA/gta-sa unchanged; Godmode 820L.
- **Verdict**: **FIX-047 is clean.** No revert needed. The reported "regression" is an upstream disassembler/Remill pipeline issue — the regenerated `.ll` input lost most of the function body before Helix saw it. The correct next step is in `hexcore-remill` or the job-pipeline configuration for the Intigrity kernel-module lift, not the Helix engine.
- **FIX-047 benefit measured on OLD `.ll`**: Part 2a adds 1 line (`kbase_jit_allocate` 157 → 158) — a legitimate statement preserved that the pre-fix simplifier was collapsing away. Confirms the lvalue-safe rewrite is working as designed.

### Files Modified (FIX-048, bisect investigation)

| File | Changes |
|------|---------|
| (none — investigation only, no code change) | Bisect confirmed FIX-047 parts 1, 2a, 2b are all innocent. Changelog documentation added. |

### Wave 9 — confidence visibility after auto-decl injection (2026-04-18)

> Stress agent noted that after Wave 8's `declareUndeclaredVars` (FIX-043) the undeclared-var penalty disappeared — file 14 (gta-sa data-as-code) jumped back to 95% High because the auto-declarations satisfied the undeclared check. The smell was real, the visibility disappeared. Wave 9 re-exposes it with a distinct Issue category so the user still sees the lift-quality concern after auto-decls.

#### FIX-045 — Track synthesised decls and keep a moderate penalty (CDecl.h + CAstOptimizer.cpp)

- **Problem**: FIX-043 injects `int64_t <name>;` for every orphan VarRef. The output compiles, but a function that NEEDED auto-injections still likely has SSA-destruction gaps or (worst case) was lifted from a non-executable section. Losing the confidence signal is a regression in diagnostic value, even though the mechanical correctness improved.
- **Fix**:
  - Added `unsigned synthesizedVarDecls = 0` field on `CFuncDecl`.
  - `declareUndeclaredVars` now increments it by `orphans.size()` after injection.
  - `reanalyzeConfidence` checks the counter and deducts `min(25, 3 + 2.5·n)` — about 60% of the raw-undeclared deduction (which stays at `min(40, 6 + 4·n)` for the compile-breaking case this wave still handles). Issue wording changes to `"N auto-declared placeholder variable(s) — lift-quality concern; verify against IDA"` so the user immediately knows the gap was closed automatically but warrants cross-checking.
- **Calibration impact on gta-sa corpus**:
  - File 03: 100% → **94.5%** (1 auto-decl flagged)
  - File 06: 95% → **87%** (2 auto-decl + short)
  - File 07: 100% → **92%** (2 auto-decl)
  - File 09: 100% → **94.5%** (1 auto-decl)
  - File 13: 95% → **87%** (2 auto-decl + short)
  - File 14 (data-as-code): 95% → **87%** — visible again with the auto-declared warning
  - Files with NO auto-decls (02, 04, 05, 08, 10, 11, 12a): unchanged

- **Design rationale — two-tier undeclared signalling**:
  1. Raw undeclared (found by `reanalyzeConfidence` when `declareUndeclaredVars` deliberately skipped a name — e.g. invalid C identifier like `"0"`) → **40 pt max deduction, "output does not compile"**. Compile-breaking severity.
  2. Auto-declared (counted by `synthesizedVarDecls`) → **25 pt max deduction, "lift-quality concern"**. Output compiles but the lift is suspicious.

### Files Modified (Wave 9)

| File | Changes |
|------|---------|
| `engine/include/helix/cast/CDecl.h` | New `CFuncDecl::synthesizedVarDecls` counter |
| `engine/src/cast/CAstOptimizer.cpp` | `declareUndeclaredVars` increments the counter; `reanalyzeConfidence` adds a separate moderate penalty with distinct Issue text |

### Wave 8 — remaining gta-sa stress bugs (2026-04-18)

> Closes the 4 remaining gta-sa stress bugs (B, C, E, I). With Wave 8 + Wave 7 + Wave 6, the gta-sa 14-function corpus goes from "mostly wrong / 92% High default" to "5 functions at 100% confidence, bailouts flagged at 45% Low, and output that actually compiles on 13 of 14". Zero regressions on x64 (Malwarebytes `sub_140013adc` 74L → 78L, Kernel `kbase_jit_allocate` 156L — matches).

#### FIX-041 — Broken SBB fold `v1 -= v1 - v3` → `v1 = v3` (cast/CAstOptimizer.cpp)

- **Problem (bug I)**: gta-sa file 02 `sub_4095a0` emitted `v1 -= v1 - v3;` — the compound form of `v1 = v1 - (v1 - v3)` from x86 `sbb eax, eax` + `sub eax, ebx`. Algebraically `x - (x - y) = y`, but `CAstBuilder::detectCompoundOp` collapses the assignment into compound `-=` form EARLY (before `simplifyExpressions` runs), so the outer `-` with the self-reference is never visible to the algebraic fold in `simplifyExpr`.
- **Fix**: two complementary changes.
  1. Added the `x - (x - y) → y` and `(x - y) - x → -y` rules inside `simplifyExpr`'s BinaryExpr handling — these catch the raw form before compound detection when it hasn't kicked in yet.
  2. Added a new late pass `foldDegenerateCompounds` that runs after the compound has been formed, inspects AssignStmt nodes whose `compoundOp == "-="` and whose `value` is `BinaryExpr(Sub, target, Y)` — rewrites them as plain `target = Y`.
- **Helper**: introduced a light-weight `isSameExpr(const CExpr*, const CExpr*)` in the anonymous namespace (distinct from the richer `exprEquals` used by compound-assign synthesis) to avoid name collisions while still supporting the node shapes recovered expressions actually take (VarRef, IntLit, unary/binary, cast).
- **Result on file 02**: `v1 -= v1 - v3;` → `v1 = v3;`, plus the downgrade pass (FIX-044) collapses the now-dead `v1 = v3;` into invisibility when `v1` isn't read again (in this case it IS used in `*(v2 - 8) = (int32_t)v1;`, so the assign stays).

#### FIX-042 — `*(int64_t)(void*)0` NULL-deref sentinel collapses to 0 (cast/CAstOptimizer.cpp)

- **Problem (bug B)**: when Helix cannot resolve an absolute address into a named global, the emitter surfaces the load as `*(int64_t)(void*)0` / `*(void*)0`. This leaks into arithmetic: `*(v2 + 8 + *(int64_t)(void*)0) = v1;` across files 03, 05, 06, 07, 08, 09, 10, 14. The result was an unreadable expression that also isn't valid C (dereferencing NULL is UB).
- **Fix**: `simplifyExpr`'s UnaryExpr(Deref) handling now walks up to 3 cast levels from the deref operand. If the innermost expression is `IntLitExpr(value == 0)`, the whole deref simplifies to `IntLitExpr(0)`. The existing `x + 0 → x` fold then strips the `+ 0` from the containing arithmetic, so `*(v2 + 8 + *(void*)0)` cascades to `*(v2 + 8)`.
- **Semantic justification**: a real execution of `*NULL` would trap; emitting `0` is the best static approximation without knowing the original global's address. Makes the output compilable and removes the visual noise.
- **Result**: 0 `*(int64_t)(void*)0` occurrences across the gta-sa corpus. All affected files got visibly cleaner output.

#### FIX-043 — `declareUndeclaredVars` pass injects missing decls (cast/CAstOptimizer.cpp + .h)

- **Problem (bug C)**: SSA destruction sometimes produces `CVarRefExpr` nodes referring to names (`v0`, `param_2`, `result`) without a matching `CVarDecl` in `func.localVars` or `func.params`. The resulting C is not compilable. FIX-040 (Wave 7) only flagged this as a confidence penalty — didn't fix it.
- **Fix**: new pass `declareUndeclaredVars` runs right after `downgradeDeadAssignedCalls` in `optimize()`. Walks the function body via `collectVarNamesInStmts`, subtracts `func.params + func.localVars`, and for each leftover orphan name that's a valid C identifier (`[A-Za-z_][A-Za-z0-9_]*`) injects a `CVarDecl` at the top with `int64_t` as the conservative default type.
- **Filter**: skips stack-bookkeeping pseudo-names (`rsp`/`rbp`/`esp`/`ebp`) the printer handles specially, and skips strings that aren't legal C identifiers (caught a stray "0" that would have produced `int64_t 0 = 0;` without the guard).
- **Sync**: `reanalyzeConfidence`'s undeclared-var count uses the SAME filter, so the Issue list accurately reflects what `declareUndeclaredVars` left behind.
- **Result on gta-sa corpus**: file 03 `86% → 100%`, file 06 `81% → 95%`, file 07 `86% → 100%`, file 09 `90% → 100%`, file 13 `85% → 95%`, file 14 `81% → 95%`.

#### FIX-044 — `downgradeDeadAssignedCalls` pass drops dead LHS (cast/CAstOptimizer.cpp + .h)

- **Problem (bug E)**: gta-sa file 04 `sub_53b501` (camera-cmd dispatcher) is a vtable-chain that looked like 90+ lines of `v2 = vfunc_0xN(v1 - 40);` where v2 was NEVER read until the function returned via a separate fresh call. The existing `eliminateDeadStores` conservatively keeps `v = call()` when RHS has side effects, producing wasteful `v2 = ` everywhere.
- **Fix**: new late-running pass `downgradeDeadAssignedCalls`. Walks each scope forward; for each AssignStmt whose target is a simple VarRef and whose value is a CallExpr (no compound operator), scans subsequent statements looking for:
  - a read of the target (bail — keep the assign),
  - another simple-target write (the current assign is dead → downgrade),
  - a control-flow construct (bail conservatively — could read the target behind the branch),
  - a return (equivalent to an overwrite — target can't be observed past the return).
  If the scan finds an overwrite-or-return with no intervening read, the AssignStmt is replaced by `CExprStmt(value)` — the call's side effect is preserved, the LHS is dropped.
- **Safety rules**: only simple `VarRefExpr` targets (no `*p`, `s->f`, `arr[i]` — those have aliasing concerns); only scans within the current scope, not across nested regions; any control-flow construct between the write and the eventual overwrite defeats the analysis (the pass bails).
- **Result on file 04**: every `v2 = vfunc_0xN(v1 - 40);` downgraded to `vfunc_0xN(v1 - 40);`. `v2` declaration itself gets cleaned up by the existing `removeUnusedDeclarations`. 108L → 107L at the surface (only the `v2` decl went), but every line is visibly cleaner.
- **Bonus on file 02**: dead `v1 = fp_load();` / `v1 = __vtable_0xb();` patterns also downgraded to bare statements. Confidence 100%.

### Benchmark (gta-sa 14-file stress corpus — post-Wave 8)

| File | Wave 7 | Wave 8 | Driver |
|------|--------|--------|--------|
| 02 | 100% (1 Issue: FPU artifact) | **100% (0 Issues)** | FIX-041 + FIX-042 + FIX-044 |
| 03 | 86% (2 undecl) | **100%** | FIX-042 + FIX-043 |
| 06 | 81% (2 undecl + short) | **95% (short)** | FIX-042 + FIX-043 |
| 07 | 86% (undecl) | **100%** | FIX-042 + FIX-043 |
| 09 | 90% (undecl) | **100%** | FIX-042 + FIX-043 |
| 13 | 85% (short + undecl) | **95%** | FIX-043 |
| 14 | 81% (short + undecl) | **95%** | FIX-043 |

### Files Modified (this wave)

| File | Changes |
|------|---------|
| `engine/include/helix/cast/CAstOptimizer.h` | New public methods `foldDegenerateCompounds`, `declareUndeclaredVars`, `downgradeDeadAssignedCalls`; private helpers `foldDegenerateCompoundsInList` and `downgradeDeadAssignedCallsInList` |
| `engine/src/cast/CAstOptimizer.cpp` | `isSameExpr` helper (avoids name collision with existing `exprEquals`); `x - (x - y) → y` + `(x - y) - x → -y` rules in `simplifyExpr` (FIX-041); `*((T)NULL) → 0` cascade in `simplifyExpr`'s Deref handling (FIX-042); new passes `foldDegenerateCompounds` (FIX-041 post-compound), `downgradeDeadAssignedCalls` (FIX-044), `declareUndeclaredVars` (FIX-043); `reanalyzeConfidence`'s undeclared-var count uses the same C-identifier filter as FIX-043 |

### Wave 7 — x86 stress fixes from gta-sa corpus (2026-04-18)

> After FIX-036 (Cdecl32 detection) went live, a second-agent stress test caught 9 additional bugs across a 14-function gta-sa.exe corpus. This wave ships FIX-037 through FIX-040 — the ones addressable inside Helix. The remaining bugs (B/C/E/I/J root cause) are tracked as pending.

#### FIX-037 — x86 pointer width in `helix_low.call` result (`passes/RemillToHelixLow.cpp`)

- **Problem**: FIX-031 hard-coded `i64Ty` as the `helix_low.call` result type (5 creation sites). On i386 lifts that's the wrong width: the CALL target and EAX return are both `i32`. Downstream emitters then sign-extended x86 call targets, producing names like `sub_ffffffffc75c4ad9()` instead of the intended `sub_c75c4ad9()` (bug H of gta-sa stress set).
- **Fix**: new class member `unsigned machineIntWidth_` captured from the `program_counter` argument of the Remill-lifted LLVM function BEFORE `entryBlock.eraseArguments()` scrubs it. Accessor `machineIntTy(builder)` returns the correct integer type. All 5 CallOp creation sites now pick result type from either `targetVal.getType()` (direct constant-address target) or `machineIntTy(builder)` (synthetic zero placeholder). Synth `reg.write RAX` bit-width matches.
- **Bonus fix**: indirect-call target detection heuristic (loop looking for the first `i64` operand) now uses `machineIntWidth_` instead of hard-coded 64, so x86 indirect calls through registers are recognised.

#### FIX-038 — x86/x87 opcode coverage in `kSemanticMap` (`cast/CAstOptimizer.cpp` + `analysis/RemillDemangler.cpp`)

- **Problem (bugs A/D/G)**: 9+ x86-specific opcodes leaked as `__native_*()` calls in gta-sa output because `kSemanticMap` was x86-64-centric. Critical gaps:
  - **x87 FPU** (math/physics/timers): `FLD`, `FLDmem`, `FSTP`, `FSTPmem`, `FCOM`, `FCOMmem`, `FCOMP`, `FCOMPmem`, `FNSTSW`, `FILD`, `FADDmem_ST0_implicit`, `FSUBmem_ST0_implicit`, `FMULmem_ST0_implicit`, `FDIVmem_ST0_implicit`.
  - **Legacy control flow**: `LOOPNE`, `LOOPE`, `LOOP`.
  - **Stack bookkeeping**: `POPAD`, `PUSHAD`, `POPFD`, `PUSHFD`, `POPF`, `PUSHF`, `LAHF`, `SAHF`.
  - **Carry arithmetic**: `ADC`, `SBB`, and their mem/implicit variants, plus the already-lowercase `add_with_carry`/`sub_with_borrow` names Remill sometimes emits directly.
  - **I/O ports** (drivers/ring-0): `IN8/16/32`, `OUT8/16/32`.
  - **Far jumps/calls** (bootloaders, segmented legacy code): `JMP_FAR`, `JMP_FAR_MEM`, `CALL_FAR`, `CALL_FAR_MEM`, `RET_FAR`.
  - **Misc**: `CPUID`, `RDTSC`, `XCHG`, `BSR`/`BSF`, `BTS`/`BTR`/`BTC`.
- **Fix (`CAstOptimizer.cpp`)**:
  - Extended `kSemanticMap` with all of the above, grouped and commented.
  - Extracted the map into `getSemanticMap()` and added a direct-lookup helper `kSemanticMapLookup(name)`.
  - `isNativeOpcodeName` now does an **early allow-list check** against `kSemanticMapLookup` — any name registered in the map passes through even when Rules A/B would reject it. This unlocks Remill's `FADDmem_ST0_implicit` shape (underscore-lowercase tail `_implicit` previously caught by Rule A).
  - `mapNativeOpcode` now tries a direct-match lookup FIRST (for full names), then falls back to the stripping logic for mnemonic-suffix cases like `BTSmem` → `BTS`.
- **Fix (`RemillDemangler.cpp`, bug D)**: recognised `RET_IMM`, `RETI`, `RET_IMM_16` as `RemillSemantic::RET`. Without this, x86 `ret imm16` instructions surfaced as `__native_RET_IMM(...)` calls in the function body instead of becoming a terminator `return;`.

#### FIX-039 — Silent-bailout warning in confidence analyser (`cast/CAstOptimizer.cpp`)

- **Problem (bug F)**: gta-sa `CPlayerInfo_Process` (0x5ec502) is an 800-instruction function, but Remill lifted only 2 IR ops (push + LOOPNE) before terminating with `ret`. Helix faithfully produced `{ loop_while_ne(); return; }` and stamped **85% High** confidence — silently losing 798 instructions of analysis.
- **Root cause**: Remill limitation, not a Helix bug — but Helix can detect the pattern and flag it.
- **Fix**: `reanalyzeConfidence` now counts `opcodeCalls` — calls to any semantic name beginning with one of: `fp_`, `loop_`, `port_in_`, `port_out_`, `far_jump`, `far_call`, `far_return`, `string_compare_`, `string_move_`, `string_scan_`, `string_store`, `string_load`, `pop_all_gprs`, `push_all_gprs`, `pop_flags`, `push_flags`, `load_flags_into_ah`, `store_ah_to_flags`, `bit_scan_`, `bit_test_`, `read_timestamp_counter`, `cpuid`, `hardware_random`, `hardware_random_seed`, `atomic_*`, `sub_with_borrow`, `add_with_carry`. When `totalStmts ≤ 3 && opcodeCalls > 0`, adds **40-point deduction** and Issue `"possibly truncated by lifter — body is a single undecomposed opcode; Remill may have bailed mid-function"`.
- **Calibration**: `CPlayerInfo_Process` now reports **45% Low** (was 85% High). A legitimate tiny wrapper like `Script_SET_CHAR_HEALTH { return; }` stays at 85% — no false positive because it has no opcode-named calls. `sub_4095a0` (full FPU function with 15+ `fp_*` calls) stays at 100% — `totalStmts > 3` so rule doesn't fire.

#### FIX-040 — Undeclared-variable penalty (`cast/CAstOptimizer.cpp`)

- **Problem (bug C + J calibration)**: gta-sa file 03 shows `v0`/`param_2`/`result` used without matching declarations — SSA-destruction artifact, output doesn't compile — yet reported **100% High** confidence. File 14 (DATA section mis-interpreted as CODE) showed **92% High** despite clearly-broken output. Users couldn't tell bad output from good.
- **Fix**: `reanalyzeConfidence` now walks the function body collecting all `CVarRefExpr` names (`collectVarNamesInStmts`), subtracts the union of `func.params + func.localVars` (allow-list excludes known stack-frame names `rsp`/`rbp`/`esp`/`ebp`), and counts the leftover undeclared references. Each one adds `min(40, 6 + 4·count)` to the deduction and appends an Issue `"N reference(s) to undeclared variable(s) — output does not compile"`.
- **Calibration impact across gta-sa corpus**: file 03 `100% → 86%`, file 06 `100% → 81%`, file 14 `92% → 81%`. Users now see a visible warning on functions whose output is not compilable. File 02 (clean FPU function) stays at 100%.

### Benchmark (gta-sa 14-file stress corpus, confidence re-scoring)

| File | Function | Before Wave 7 | After Wave 7 | Reason |
|------|----------|---------------|--------------|--------|
| 02 | `sub_4095a0` (FPU heavy) | 92% High | **100% High** | All FPU opcodes now decomposed |
| 03 | `sub_4c1ee7` (undeclared v0) | 100% High | **86% High** | FIX-040 flags undeclared refs |
| 10 | `CPlayerInfo_Process` (800-op bailout) | **85% High** | **45% Low** | FIX-039 detects bailout |
| 14 | `sub_8a36b0` (data-as-code) | 92% High | **81% High** | FIX-040 catches broken SSA |

### Benchmark (Zero regressions on x64)

| Corpus | Function | Wave 6 | Wave 7 |
|--------|----------|--------|--------|
| Malwarebytes | `sub_140013adc` | 74L | 75L |
| Kernel Pathfinder v0.2.0 | `kbase_jit_allocate` | 156L | 157L |

### Files Modified (this wave)

| File | Changes |
|------|---------|
| `engine/src/passes/RemillToHelixLow.cpp` | `machineIntWidth_` / `machineIntTy(builder)` plumbing; 5 CallOp creation sites use `targetVal.getType()` or `machineIntTy`; indirect-call heuristic uses `machineIntWidth_` (FIX-037) |
| `engine/src/analysis/RemillDemangler.cpp` | `RET_IMM` / `RETI` / `RET_IMM_16` recognised as `RemillSemantic::RET` (FIX-038 D) |
| `engine/src/cast/CAstOptimizer.cpp` | `getSemanticMap()` factored; `kSemanticMapLookup` helper; `isNativeOpcodeName` allow-lists map hits; `mapNativeOpcode` direct-match first; kSemanticMap extended with x87/loop/popad/port/far/etc. (FIX-038 A/G); `reanalyzeConfidence` gains `opcodeCalls` counter + bailout rule (FIX-039) and undeclared-var sweep (FIX-040) |

### Known Gaps Still Open (gta-sa stress report B/C/E/I/J)

- **Bug B**: `*(int64_t)(void*)0` artifact from NULL deref spreading. Downstream of SSA destruction on `_promoted_*` vars. Medium effort, next wave.
- **Bug C**: undeclared vars like `v0`/`param_2` — FIX-040 now *flags* them, but the root cause (incomplete register-to-local promotion in `RecoverVariables`) is still open.
- **Bug E**: 90+ line loop unrolling on `sub_53b51f`. Structurer doesn't recognise the unrolled pattern. Hard — needs a new pass.
- **Bug I**: `v1 -= v1 - v3;` — broken SBB arithmetic fold. Specific pattern fix needed.
- **Bug J root cause**: Helix doesn't distinguish data sections from code when the disassembler hands it a CODE lift from a DATA address. Requires upstream cooperation (disassembler must refuse to lift from `.rdata`/`.data`).

### Wave 6 — x86 (32-bit) Windows calling convention (2026-04-18)

#### FIX-036 — `Cdecl32` detection for i386 PE (`passes/RecoverCallingConvention.cpp` + `passes/RecoverVariables.cpp`)

- **Problem**: `RecoverCallingConvention` only distinguished Win64 vs SysV based on OS keywords in the target triple (`linux`/`darwin`/`elf` → SysV, anything else → Win64 default). Legacy 32-bit Windows PEs lifted by Remill emit `target triple = "i386-unknown-windows-msvc-coff"` — this fell through to the Win64 default. The caller then ran arg-register detection against RCX/RDX/R8/R9 on an IR that only has x86 32-bit registers (EAX/ECX/EDX/…), produced no matches, and emitted a confusing `| win64` header line on clearly-x86 code. Reported against GTA San Andreas (`gta-sa.exe`, `Pickup_HealthHandler` at `0x005d01a8`) where the decompiled output showed `__native_OUT32()` and `__native_JMP_FAR_MEM()` — instructions that don't exist in x86-64 user-mode.
- **Fix (`RecoverCallingConvention.cpp`)**: new `CallingConv::Cdecl32` enum value. Detection priority reworked:
  1. 32-bit x86 markers in triple (`i386`/`i486`/`i586`/`i686`) → **Cdecl32** (catches BOTH x86 Windows and x86 Linux — both default to stack-based cdecl).
  2. Otherwise 64-bit Unix-family OSes → SysV.
  3. Otherwise (64-bit Windows and fallback) → Win64.
  - `argRegs` is now a `llvm::ArrayRef<std::string_view>` filled via `switch(cc)` — **empty for Cdecl32** (no register args; all on stack). Phase 1/Phase 3 arg-register recovery runs normally but finds zero hits, which is the correct cdecl semantics.
  - `calling_convention` attribute string is now `"win64"` / `"sysv"` / `"cdecl"`.
- **Fix (`RecoverVariables.cpp`)**: reads `calling_convention`; for `"cdecl"` it calls `tracker.argRegPositions.clear()` instead of `initArgRegPositions(isWin64)`, leaving the parameter-register detection map empty. Stack-frame args will be recovered by `RecoverStackLayout` (not yet x86-aware — tracked for a future wave).
- **Ordering note**: the 32-bit check runs FIRST so `i386-unknown-linux-gnu` is caught as Cdecl32 before the SysV branch would have matched `linux`. This is correct for x86 Linux (also stack-based cdecl) and keeps the behaviour consistent across OSes for the same ISA.
- **Impact on gta-sa.exe bridge corpus (5 functions)**: header line `| win64` → `| cdecl` on every function. `Script_SET_CHAR_HEALTH`, `Pickup_ArmourHandler`, `Pickup_HealthHandler`, `CPlayerInfo_Process`, `sub_5d010c` all classify correctly. Zero regressions: Malwarebytes stays `| win64`, kernel stays `| sysv`.

### Wave 5 — Call Dataflow Refactor + Nested Structuring + Polarity (2026-04-16/17)

> Gives `helix_low.call` an Optional<i64> result so callee return values flow as distinct SSA values through Low → Mid → High → cast. Fixes the tail-call stub that was collapsing MSVC entry-point patterns. Fixes the structurer early-exit that was leaving inner `helix_low.jcc` nests untouched (`__scrt_common_main_seh` went 33L → 74L with full nested if/else recovery). Adds `simplifyConditionPolarity` for `X == 0` → `!X` / `X != 0` → `X` cosmetic match with IDA. **0 regressions on 7-function kernel corpus (Pathfinder v0.2.0 IR)**; all functions match or exceed baseline. Godmode Hogwarts Legacy: 821L in 11s (under the 15s target).

#### FIX-030 — JMP→Tail-Call Recognition (`passes/RemillToHelixLow.cpp`)

- **Problem**: Remill lifts MSVC entry-point tail calls (`jmp _scrt_common_main_seh` after stack teardown) as `_JMP(target=<constant>)` intrinsics. The old lowering dropped the target (`IntegerAttr{}` for `target_addr`) and wired the JmpOp to a dummy block, which the structurer then collapsed — leaving `mainCRTStartup` as a 1-call stub (`sub_…(); return;`) instead of `return _scrt_common_main_seh();`.
- **Fix**: `RemillSemantic::JMP` now detects when the target operand is a *direct* `LLVM::ConstantOp`/`arith::ConstantOp` and emits `low.call(target) + deferred low.ret` — the canonical tail-call pattern. New `is_tail_call` unit attribute tags the CallOp.
- **Intentionally conservative**: direct-constant recognition ONLY, NOT `pcTracker.tryEvaluate`. Kernel code has ~38 `_JMP` intrinsics per function whose operands fold through PC tracking (e.g. `add %pc, 22`) but are jump tables or intra-function branches, not tail calls. Treating them as ret-terminated tail calls truncated functions to ~40L (observed regression during development). The direct-constant check cleanly separates "Remill emitted a real tail call" from "Remill emitted an indirect/computed jump".
- **Impact**: `mainCRTStartup`, Malwarebytes `entry_point`, and akasha `Malware HexCore Defeat.exe` entry all now emit both calls correctly.

#### FIX-031 — `helix_low.call` Optional Result + Synthetic RAX RegWrite

- **Dialect change (`dialects/HelixLowOps.td`)**: `HelixLow_CallOp` gains `let results = (outs Optional<AnyInteger>:$result);`. Assembly format extended with `(`->` type($result)^)?`.
- **Creation sites (`passes/RemillToHelixLow.cpp`)**: all 6 `builder.create<low::CallOp>(...)` sites (CALL semantic, JMP tail-call, indirect call, external call, CMPXCHG marker, unhandled fallback) now pass `TypeRange{i64Ty}` as the first positional arg. CMPXCHG stays resultless (pure intrinsic marker).
- **Synthetic RAX dataflow**: after every non-CMPXCHG call creation, the pass emits a `reg.write RAX, %callResult` immediately after the `low.call`. This is the SSA edge that makes the callee's return value observable to subsequent `reg.read RAX` / `RecoverVariables` walks.
- **Cross-level propagation**:
  - `passes/HelixLowToMid.cpp` `CallToMidCall` pattern: passes `op.getResultTypes()` to `mid::CallOp` and uses `rewriter.replaceOp(op, midCall->getResults())` when the low op produced a value (was `rewriter.eraseOp`, which would leave dangling uses).
  - `passes/HelixLowToMid.cpp` manual fallback loop: same `getResultTypes()` propagation + `callOp->getResult(0).replaceAllUsesWith(midCall->getResult(0))` before `erase()`.
  - `passes/HelixMidToHigh.cpp` manual converter: forwards `midCall->getResult(0).replaceAllUsesWith(highCall->getResult(0))` before erasing.
- **Impact**: prior to this change, patterns like `if (_vcrt_initialize()) ...` collapsed into `if (v1 != 0)` where `v1` was the caller's locally-zeroed variable — a tautology. `StructureControlFlow` pruned the false branch, hiding up to half of `__scrt_common_main_seh`. Now every call that has its return value consumed reads naturally: `sub_140013790` (Malwarebytes `_scrt_initialize_crt`) emits the exact two-sequential-`if (v != 0) return v;` structure IDA produces.

#### FIX-032 — DCE Orphan-Cleanup Guard for Side-Effecting RHS (`passes/EliminateDeadCode.cpp`)

- **Problem**: `removeDeadVariables` (Phase 7) has 4 orphan-cleanup sites that, after erasing a dead `high::AssignOp`, call `rhsDef->erase()` if the RHS expression became use-empty. With FIX-031's synthetic RegWrite pattern, the chain is: call → reg.write RAX → (converted to) `high.assign rax_N, %callResult`. When Phase 5 proves `rax_N` is overwritten before being read, the assignment is deleted; without a guard, `rhsDef->erase()` then DELETES THE CALLOP itself — silently removing function calls whose return value was discarded. `entry_point` went to an empty body in a midway iteration of this session before the fix.
- **Fix**: new static helper `isSideEffectingRhs(Operation*)` checks `isa<low::CallOp, high::CallOp, mid::CallOp, low::MemWriteOp, low::RetOp, high::ReturnOp, low::PushOp, low::PopOp, low::RepMovsOp, low::RepStosOp>`. Guards all 4 orphan-erase sites (infra-assign cleanup, `__undef` assign cleanup, dead-assign cleanup, dead-var-decl init cleanup). Orphaned pure expressions (arith, field access, var.ref) still cleaned up; side-effecting ops never erased through the orphan path.
- **Not redundant with `isLiveConsumer`**: that helper governs variable liveness ("does a variable feed a live op?"). The new helper governs whether a defining op can be removed when it becomes use-empty. Both coexist in the same file now.

#### FIX-033 — Cast-Layer Double-Emit Suppression (`cast/CAstBuilder.cpp`)

- **Problem**: After FIX-031, a call whose return value flows to a named variable appears in the IR as `(%c = high.call …) + high.assign %c, %v`. The cast-layer walker visits the CallOp (emits `sub_foo();`) AND the AssignOp (emits `v = sub_foo();`) — producing `sub_foo(); v = sub_foo();` pairs for every captured call. `sub_140013adc` exploded from the intended ~34L to 74L of duplicated statements before suppression.
- **Fix**: in `buildStatement`, both `high::CallOp` and `low::CallOp` statement emitters consult the call's result users: if ANY user is a same-block `high::AssignOp` / `high::ReturnOp` / `low::RegWriteOp` / `low::RetOp`, the standalone emission returns nullptr and the consumer re-emits the call as an embedded expression.
- **Same-block restriction is load-bearing**: an AssignOp in a different block (a different region of a structured if/while) may never be reached by the walker in the current region's scope. Without the restriction, the call would be suppressed here AND not emitted there — silently dropping the call. Observed on `kbase_context_mmap` in an earlier iteration (147L → 41L) before tightening the check.

#### FIX-034 — Nested-Region Structurer Guard Scope (`passes/StructureControlFlow.cpp`)

- **Problem**: `structureIfRegions` opened with `if (hasIrreducibleSCCs(func.getBody())) return success();`. When invoked recursively on a nested region (e.g. the then-body of a previously-structured outer `high.if`), this checked the WRONG CFG. The outer function body at that point is typically just the host block with the structured IfOp plus a merge remnant — the Tarjan SCC analyser often flags that skeleton as irreducible, triggering an immediate early exit before the inner region's 9+ unstructured JccOps could be processed.
- **Diagnostic trace**: `sub_140013adc` nested region had `blocks=17 jccs=9`; after `structureIfRegions`, `jccs=9` (zero conversion). The outer pass found 10 if-regions and structured 1 of them (the outermost), then the nested re-entry bailed on the function-scope irreducibility check.
- **Fix**: changed to `if (hasIrreducibleSCCs(region)) return success();`. The guard now analyses the CFG actually being structured — nested regions are their own CFG, not func.body's.
- **Impact**: `__scrt_common_main_seh` nested region went 9 jccs → **0 jccs** (all structured), recursively into a second and third nested level. Output expanded from 33L (flat if) to 74L (full nested if/else trees, 4 nesting levels, matching IDA's `if (!_scrt_initialize_crt) {...}` / `if (_scrt_current_native_startup_state == initializing)` / `if (*dyn_tls_init_callback && _scrt_is_nonwritable_in_current_image(...))` chain).

#### FIX-035 — Condition Polarity Normalisation — `simplifyConditionPolarity` (`cast/CAstOptimizer.cpp` + `.h`) — NEW

- **Problem**: output emits `if (v != 0)` / `if (v == 0)` / `while (v != 0)` where IDA and Ghidra emit `if (v)` / `if (!v)` / `while (v)`. Cosmetic only — both forms compile identically — but the redundant zero comparison is visible noise at every branch.
- **Fix**: new pass walks IfStmt / WhileStmt / DoWhileStmt / ForStmt / SwitchStmt condition slots and rewrites the top-level operator:
  - `X == 0` → `!X` (wrapped in `CUnaryExpr(LogNot)`)
  - `X != 0` → `X` (bare — C coerces non-zero integer to true)
- **Scope discipline**: only the top-level comparison of each condition is rewritten. Nested comparisons like `a && b != 0` are left intact — the `!= 0` there preserves the boolean coercion of a wider-int operand inside a logical expression.
- **Degenerate guard**: `0 == 0` / `0 != 0` with both operands being zero literals is passed through to constant folding, not rewritten.
- **Runs right after `invertEmptyIfThen`** so the `!condition` that pass can introduce gets normalised in the same wave.
- **Validated on Godmode (Hogwarts Legacy, ~90 conditions)**: no missed rewrites, no crashes, output diff shows only the expected substitutions.

### Benchmark (Malwarebytes CRT startup — against IDA baseline)

| Function | v0.8.0 | Wave 1–4 | Wave 5 (final) | IDA |
|----------|--------|----------|----------------|-----|
| `entry_point` / `mainCRTStartup` | stub (1 call) | stub | **12L** (tail-call recovered) | 5L |
| `_security_init_cookie` | 20L | 20L | **22L** | 22L (**= IDA**) |
| `_scrt_common_main_seh` | 30L flat | 30L | **74L** (full nested) | 59L |
| `_scrt_initialize_crt` | collapsed | collapsed | **24L** (2 sequential `if (v)` returns) | 18L |

### Benchmark (kernel Pathfinder v0.2.0 IR — zero regressions across Wave 5)

| Function | A.c baseline | Wave 5 | Δ |
|----------|--------------|--------|---|
| `kbase_context_mmap` | 147L | 157L | +7% |
| `kbase_jit_allocate` | 136L | 156L | +15% |
| `kbase_mem_alloc` | 164L | 169L | +3% |
| `kbase_mem_commit` | 82L | 86L | +5% |
| `kbase_mem_import` | 33L | 37L | +12% |
| `kbase_mem_free`, `kbase_csf_queue_register` | — | no change | = |

### Benchmark (stress + scan)

- **Godmode Riot Vanguard** (1.6 MB IR): 9–11s.
- **Godmode Hogwarts Legacy** (1.6 MB IR, 42K ops, 1 giant function): **821L in 11s** — under the 15s target.
- **CTF (3 files)**: 0 crashes.
- **Test suite (70 files)**: 0 crashes, 100% confidence on every function, all output placeholders (`__expr`, `__unknown_`, `__native_`, `__cond`, `__tmp_`, `_promoted_`, `sub_indirect`) at 0 occurrences.

### Files Modified (cumulative across all 5 waves)

| File | Changes |
|------|---------|
| `engine/dialects/HelixLowOps.td` | FIX-031: `Optional<AnyInteger>:$result` + `(`->` type($result)^)?` on `HelixLow_CallOp` |
| `engine/src/passes/RemillToHelixLow.cpp` | FIX-030/-031: JMP direct-constant tail-call path, `TypeRange{i64Ty}` on 6 CallOp creations, synth `reg.write RAX` after each non-CMPXCHG call, `is_tail_call` attr |
| `engine/src/passes/HelixLowToMid.cpp` | FIX-031: `CallToMidCall` result propagation + `replaceOp`; manual fallback loop same + explicit `replaceAllUsesWith` |
| `engine/src/passes/HelixMidToHigh.cpp` | Wave 1 sequential naming + `helix.*` attr propagation; FIX-031 result forwarding before `midCall->erase()` |
| `engine/src/passes/EliminateDeadCode.cpp` | FIX-032: `isSideEffectingRhs()` helper + 4 orphan-erase guards in Phase 7 `removeDeadVariables` |
| `engine/src/passes/StructureControlFlow.cpp` | Wave 1 `hasIrreducibleSCCs()` helper + 3 new DomInfo guards; FIX-034 `structureIfRegions` irreducibility guard scope: `func.getBody()` → `region` |
| `engine/src/passes/RecoverVariables.cpp` | Wave 1 Phase 3.5 SSA version coalescing, `allVersions` tracking |
| `engine/src/passes/RecoverStructTypes.cpp` | Wave 1 `decomposeArrayAccess()`, dynamic array collection |
| `engine/include/helix/analysis/StructRecovery.h` | Wave 1 `AccessPattern` array fields |
| `engine/src/analysis/StructRecovery.cpp` | Wave 1 dynamic array field emission in `buildStruct()` |
| `engine/src/passes/EscapeAnalysis.cpp` | Wave 1 Phase 3.5 must-alias classes |
| `engine/src/passes/DevirtualizeIndirectCalls.cpp` | Wave 1 Phase 4 vtable class naming |
| `engine/src/passes/RecoverCallingConvention.cpp` | Wave 1 call barrier, SignatureDb clamp, kernel sync table |
| `engine/src/cast/CAstBuilder.cpp` | Wave 1 `helix.resolved_name` preference; FIX-028 `__expr` sentinel filtering in `lastRegValue_`/`exprToBestName_` caches and `resolveTransitive`; FIX-033 same-block double-emit suppression in `high::CallOp` + `low::CallOp` statement emitters |
| `engine/src/cast/CAstOptimizer.cpp` | Wave 1 `removeSelfAssignments`, constant loop normalisation, `removeDanglingGotos`; Wave 2 `initializeReadBeforeWriteVars`, `tryStripRepPrefix`, `kSemanticMap` expansion, hardened `isNativeOpcodeName`, `collapseAssignBeforeReturn` CallExpr support; FIX-027 frame-pointer `inArgPosition`; FIX-035 `simplifyConditionPolarity` pass wired after `invertEmptyIfThen` |
| `engine/include/helix/cast/CAstOptimizer.h` | Wave 2 `initializeReadBeforeWriteVars` declaration; FIX-035 `simplifyConditionPolarity` + `flattenZeroComparison` / `simplifyConditionPolarityInList` declarations |
| `engine/src/cast/CAstPrinter.cpp` | FIX-029 float literal printer appends `.0` and `f` suffix for floats |

### Known Gaps vs IDA (post-v0.9.0-nightly)

- **FLIRT-style signature matching**: `sub_14001433c` vs IDA's `_security_init_cookie`. Requires HQL signature infrastructure (queued as next wave).
- **`return <call>()` for tail calls**: we emit `call(); return;` where IDA emits `return call();`. Cosmetic emitter work.
- **Magic-constant recognition** (`0x2B992DDFA232` in `_security_init_cookie` cookie check): unrelated literal-recognition issue.


---

## [v0.8.0-nightly] — 2026-03-28 (UNRELEASED)

> **Nightly build** — 14 Ghidra-inspired features merged. Not for production.
> Will become v3.7.4 after stabilization and testing.

### Added
- Pattern Rewrite Engine (HelixLow + HelixMid simplify passes)
- Switch/Jump Table Recovery, Struct Recovery, Escape Analysis
- Type Lattice, Calling Convention Database, Sub-Register SSA
- 6 new arithmetic patterns (DoubleShift, De Morgan, AndDistribute, etc.)
- In-place operators (`x += 5`, `x++`, `x--`)
- Cast elimination (10 emission sites, 4 scenarios)
- Backward type propagation (12 rules: 7 Low + 5 High)
- Transitive copy propagation + single-use temp elimination
- `--no-opt` and `--enable-pass=Name` CLI flags for helix_tool

### Fixed
- HelixMidSimplify/ConstantFolding crash (replaced greedy driver with safe IRRewriter walk)
- Pointer-typed mid::BinExprOp from Remill IR (cast to i64 in HelixLowToMid)

---

## [v0.7.1] — 2026-03-26

### Critical Fix

- **Liveness Assertion Crash (Block Arguments)** — `detectEscapingValues` now also scans **block arguments** (MLIR phi values), not just operation results. Block arguments defined inside loop bodies with uses outside the region were previously missed, causing the fatal `"Use leaves the current parent region"` assertion. The v0.6.1 fix handled operation results; this completes the fix for the phi-node case that appears in functions with deep loops and backward branches to entry blocks.

### Added

- **`setSkipOptimization` API** — New method exposed through the full chain: C++ Pipeline → Engine → C API → Rust FFI → NAPI-RS. Allows skipping Tier 2.5 optimization passes (magic division recovery, devirtualization) at runtime. JS wrapper: `engine.setSkipOptimization(true)`.
- **Confidence Score Penalties** — `PseudoCEmitter::analyzeFunction` now penalizes: stub functions with < 5 statements (-40 points), short functions < 10 statements (-15), and undecomposed native opcode calls (-3 each, max -30).
- **x64 Opcode Decomposition** — 30+ native x64 opcodes mapped to C expressions in `decomposeNativeOpcode()`: SSE conversions (CVTPS2PD → `(double)`), memory moves (MOVSD_MEM → `*(double*)addr`), min/max (MINSS → `fminf()`), sign extension (CWDE → `(int32_t)(int16_t)`), SSE arithmetic (MULSS → `*`), and more.

---

## [v0.6.1] — 2026-03-21

### Bug Fixes

#### MLIR Liveness Assertion Fix (Fatal — `Use leaves the current parent region`)

**Symptom**: MSVC Runtime Library assertion failure during decompilation: `Assertion failed: "Use leaves the current parent region"` in `llvm-project\mlir\lib\Analysis\Liveness.cpp`.

**Root cause**: `StructureControlFlow.cpp` moves blocks into structured regions (`IfOp`, `WhileOp`, `DoWhileOp`) without checking if values defined inside those regions are used outside. MLIR's SSA dominance rules require that values defined in a region cannot escape that region.

**Trigger condition**: Any function where a value computed inside a loop or conditional branch is used after the structured region ends (common in variable assignments within if/else or loop bodies).

**Fix** (`engine/src/passes/StructureControlFlow.cpp`):
- Added `EscapingValue` struct and `detectEscapingValues()` helper to identify values with external uses
- Added `promoteEscapingValues()` function that creates `VarDeclOp` temporaries for escaping values
- Integrated value promotion into `structureLoop()` and `structureIf()` before moving blocks into regions
- New statistic: `NumValuesPromoted` tracks how many values were promoted to variables

**Architecture**: This is the correct solution — it simulates C variable scoping where values assigned inside blocks remain accessible outside. The promoted variables appear naturally in the decompiled output.

### Build

- `helix_engine.lib` rebuilt with value promotion fix
- `hexcore-helix.win32-x64-msvc.node` rebuilt: 13,487,616 bytes
- Version bumped to `0.6.1` across Cargo workspace, npm package

---

## [v0.6.0] — 2026-03-14

### 3-Tier Dialect Architecture (v1.0)

The engine now uses a **three-tier MLIR dialect pipeline**: HelixLow (machine-level) → HelixMid (ISA-agnostic typed SSA) → HelixHigh (C source-level).

- **HelixMid dialect** — New intermediate dialect with typed variables, comparisons, select, memcpy/memset intrinsics
- **HelixLowToMid pass** — Converts registers → abstract variable slots, flags → comparisons, CMOV → select, REP MOVS/STOS → memcpy/memset
- **HelixMidToHigh pass** — Converts abstract slots → named C variables, typed expressions → C-level ops
- **EmitC removed** — PseudoCEmitter is the sole emission backend; all EmitC dialect references cleaned out

### Optimization Passes (HexCore v3.8.0)

Four community-requested features:

- **RecoverMagicDivision** — Detects compiler-generated `(x * magic) >> shift` patterns and reverses them to clean `x / divisor` expressions
- **DevirtualizeIndirectCalls** — Intra-procedural dataflow analysis to track vtable pointer stores, resolve indirect calls through vtable slots, and annotate with function names
- **InterProceduralTypePropagation** — Propagates argument and return types across function call boundaries until convergence, eliminating the int64_t flood from ABI register-width defaults
- **Node Splitting in StructureControlFlow** — Handles irreducible control flow by duplicating merge nodes, converting irreducible loops into reducible ones before structuring

### Output Quality Improvements

- **Goto-to-return optimization** — Labels followed only by a return are inlined: `goto label_ret` → `return value`
- **Redundant cast elimination** — Suppresses `(int64_t)(...)` wrapping around dereferences, struct field access, and global names
- **Stack variable resolution** — Populates variable names from VarDeclOps and resolves `rbp ± offset` patterns in memory operations

### Build

- `helix_engine.lib` rebuilt: 61,711,128 bytes (without EmitC)
- `hexcore-helix.win32-x64-msvc.node` rebuilt: 13,481,984 bytes
- Version bumped to `0.6.0` across Cargo workspace, npm package, and VSCode extension

---

## [v0.5.0] — 2026-03-11

### Bug Fixes

#### Entry Block Predecessor Crash (Fatal — `LLVM abort()`)

**Symptom**: `Entry block to function must not have predecessors! label %bb_0 / LLVM ERROR: Broken module found, compilation aborted!` — process crashes unconditionally (via `abort()`).

**Root cause**: `llvm::parseIR()` calls `parseAssembly()` → `LLParser::Run(UpgradeDebugInfo=true)` → `llvm::UpgradeDebugInfo()` → `llvm::verifyModule(FatalErrors=true)` → `abort()`. This happens inside `parseIR` before it returns, so any post-parse sanitization is unreachable.

**Trigger condition**: Remill-lifted IR where a function has a backward branch to its entry block (loop-at-entry pattern) AND the module has `!"Debug Info Version", i32 3` (matches `DEBUG_METADATA_VERSION`). Confirmed in `lifted_5368715048` from `partial_encryption.exe` (function `0x140001728`, SIMD loop function).

**Fix** (`engine/src/Pipeline.cpp`):
- Replaced `llvm::parseIR()` with direct `LLParser::Run(UpgradeDebugInfo=false)` via `#include "llvm/AsmParser/LLParser.h"`.
- After successful parse, applies entry block sanitization: inserts a new empty `BasicBlock` before any entry block that has predecessors, with an unconditional branch to the original entry.
- `LLParser.h` is in LLVM's public include path; `LLVMAsmParser` is already transitively linked via `LLVMIRReader`.

#### `RecoverCallingConvention` Crash on Large/Unusual IR

**Symptom**: Extension host crash (`STATUS_ACCESS_VIOLATION`) during `RecoverCallingConvention` pass on functions with non-trivial block structure.

**Root cause**: `DominanceInfo::getNode(block)` crashes in MLIR 18.x on certain IR patterns (massive single-block functions, nested regions, blocks created during translation that lack dominator tree nodes).

**Fix** (`engine/src/passes/RecoverCallingConvention.cpp`):
- Removed `DominanceInfo` entirely. The pass no longer constructs a dominator tree.
- `collectAbiCallArgs`: replaced `findLatestRegWriteOnDomChain` with block scan + predecessor search (`findLatestRegWriteInPredecessors`, depth-2 by default). This covers all common Win64/SysV ABI call patterns.
- Removed `#include "mlir/IR/Dominance.h"`.

#### Pass Pipeline Safety Notes

Per the fix comments in `Pipeline.cpp::buildPassPipeline()`:
- `mlir::createCanonicalizerPass()` — removed: segfaults on multi-block HelixLow functions with LLVM dialect br/condBr terminators.
- `mlir::createCSEPass()` — removed: same crash on complex functions with many basic blocks (confirmed on 112-block functions).
- `pass_manager_->enableVerifier(false)` — inter-pass verification disabled to allow pipeline to complete with minor intermediate IR issues.

### Test Results

| File | Function | Status |
|------|----------|--------|
| `logic_1728.ll` | `lifted_5368715048` (0x140001728) — SIMD loop | 100% confidence |
| `05-banner.ll` | VVM HTB challenge — 5973 lines, 3 blocks | 100% confidence |
| All `remill-7/` | Saber Interactive game engine functions | No regressions |

### Build

- `helix_engine.lib` rebuilt: 43,056,284 bytes
- `hexcore-helix.win32-x64-msvc.node` rebuilt: 11,878,400 bytes
- Build requires env vars: `LLVM_BUILD_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir`

---

## [v0.4.0] — 2026-03-04

### 🚀 Phase 2: MLIR Decompilation Engine (Production)

The C++23/MLIR engine is now the **primary decompilation backend**, replacing the Rust HIR pipeline for complex multi-block functions.

#### MLIR Pass Pipeline
- **RemillToHelixLow** — Full conversion from Remill LLVM IR to `helix_low` dialect:
  - x86-64 semantic recognition (170+ instructions: MOV, LEA, CMP, TEST, ADD, SUB, AND, OR, XOR, etc.)
  - PC tracking and address attribution for each instruction
  - Argument recovery for indirect calls (tracks RCX, RDX, R8, R9 before `CALL`)
  - Flag synthesis for JCC conditions (ZF, SF, OF from CMP/TEST results)
- **RecoverStackLayout** — Stack frame analysis with `rbp`-relative variable recovery
- **RecoverCallingConvention** — Win64 calling convention parameter identification
- **PropagateTypes** — Type inference from memory access patterns and pointer arithmetic
- **StructureControlFlow** — Multi-phase control flow recovery:
  - CMOV → ternary expression conversion
  - Address-based loop detection (back-edge recognition via instruction addresses)
  - Forward conditional branch → `if/else` with relaxed convergence detection
  - Fallback `goto/label` emission for irreducible control flow
- **RecoverVariables** — Register-to-variable naming and coalescing
- **EliminateDeadCode** — Dead store elimination and unused operation removal

#### PseudoCEmitter (2300+ lines)
- Full pseudo-C emission from `helix_high` dialect operations
- Expression formatting: arithmetic, memory access, pointer dereference, field access
- Structured output: `if/else`, `while`, `do-while`, `goto/label`, `break`, `continue`
- **Flag recovery** — Translates raw flag checks into human-readable C conditions:
  - `if (nz)` → `if (x != 0)`
  - `if (s)` → `if (x < 0)`
  - `if (nl)` → `if (x >= y)`
- **Vtable call naming** — `rax->vfunc_0x18()` instead of raw indirect call addresses
- **Argument recovery** — Populates `/* ? */` placeholders with actual register values
- Dead store suppression and confidence scoring per function
- Inline assembly formatting for unrecognized instructions

#### CLI Tool (`helix_tool.exe`)
- Standalone decompiler: `helix_tool.exe <input.ll> [output.c]`
- Batch mode: `helix_tool.exe --dir <folder>` processes all `.ll` files
- Architecture auto-detection from IR metadata
- Dynamic output buffer with auto-resize

#### Custom MLIR Dialects
- **HelixLow** — Low-level dialect: `RegWriteOp`, `RegReadOp`, `MemLoadOp`, `MemStoreOp`, `CmpOp`, `TestOp`, `JccOp`, `JmpOp`, `RetOp`, `CallOp`, `CMovOp`, `FuncOp`, and more
- **HelixHigh** — Structured dialect: `IfOp`, `WhileOp`, `DoWhileOp`, `GotoOp`, `LabelOp`, `ReturnOp`, `BreakOp`, `ContinueOp`, `TernaryOp`, `CallOp`, `VarDeclOp`, `VarRefOp`, `CommentOp`

---

### 🧪 Test Data

- **New test suite `remill-7/`** — Real-world multi-block functions from **Saber Interactive** game engine:
  - `bone_pos_calc3.ll` — Complex bone position calculation (49 blocks, 25 conditions)
  - `projectile_constructor.ll` — Projectile system constructor
- All previous test data (Remill 1-6) cleaned up and reorganized

---

### 🔧 Engine Infrastructure

- **C API** — `helix_engine_create()`, `helix_engine_decompile_ir_text()`, `helix_engine_destroy()` for language-agnostic integration
- **FlatBuffer serialization** — Zero-copy binary output alongside pseudo-C text
- **Pipeline orchestration** — 7-pass pipeline with MLIR verification between stages
- **Remill demangler** — Extracts instruction addresses from Remill function names (`sub_140XXXXXX`)
- **Signature database** — CSV-based function name resolution for known CRT/Win32 functions

---

### 🐛 Bug Fixes

- Fixed MLIR dominance violations from out-of-region value references
- Fixed block termination errors (empty blocks without terminators)
- Fixed LLVM `br i1 true` terminator preservation — old terminators are now erased after `JccOp` emission
- Fixed missing UB/Func/SCF dialect registration
- Fixed hardcoded LLVM/MLIR build paths in CMake

---

## [v0.3.0] — 2026-02-20

### Phase 1.5: HIR Pipeline (Rust)

- **HIR Builder & Emitter** — Remill IR → pseudo-C with named variables
- **Calling Convention Recovery** — Win64 argument folding  
- **Type Propagation** — Iterative refinement to fixed-point
- **Control Flow Structuring** — `if/else` and `while` from CMP/TEST + Jcc
- **Data Flow Analysis** — Liveness, reaching definitions, DCE
- **104 unit tests**, throughput **>95 instr/ms**

### Phase 3: FlatBuffers Transport

- **Schemas** — `common.fbs`, `cfg.fbs` (HCFG), `ast.fbs` (HAST)
- **Rust serialization** — Manual builder with roundtrip tests
- **NAPI zero-copy** — `Buffer` objects passed directly to TypeScript

---

## [v0.1.0] — 2026-02-01

### Phase 1: Foundation

- Project scaffolding (Rust workspace + NAPI-RS + C++ engine scaffold)
- `helix-core` library with types, traits, and FFI boundary
- `hexcore-helix` NAPI-RS bridge for Node.js/VS Code integration
- FlatBuffers schema design
- CI/CD pipeline
