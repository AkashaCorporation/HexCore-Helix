# Helix v1.0 Structurer Rewrite - Scoping

Status: SCOPING (planning). No code yet. Decision document for whether to invest.
Author basis: 3-agent research workflow (current arch map + target-algorithm research +
validation inventory) on 2026-06-15, grounded against the actual v2 source and the
LLVM 18.1.8 build Helix links.

---

## TL;DR

The premature-`return`-that-strands-the-body bug AND the `0xC0000409` dominator-tree
crash are the SAME root problem: `StructureControlFlow.cpp` forms structured regions by
**moving raw basic blocks** into `helix_high.if`/`while` regions, which (a) cannot handle
a then/else that re-converges through a shared multi-entry block (it gives up and injects
a `return`), and (b) leaves a region-entry block that has a predecessor = malformed MLIR =
`DominanceInfo` asserts. Six guard attempts proved it is **not patchable**: every tweak to
which regions get structured cascades into a new malformed-IR crash elsewhere (the
block-moving creates malformations as *side effects* no pre-move check can predict).

**The fix is correct-by-construction structuring, and LLVM 18.1.8 already ships it.**
`mlir/Transforms/CFGToSCF.h` provides `transformCFGToSCF()` + the `CFGToSCFInterface`
(the RVSDG / "Perfect Reconstructability" algorithm; Boeck, EuroLLVM 2024). It handles
arbitrary (even irreducible) CFGs with **no code duplication and no premature returns**,
and its region entries are predecessor-free by construction so dominance NEVER asserts.
`mlir/Conversion/ControlFlowToSCF/ControlFlowToSCF.h` is a working reference
implementation (cf -> scf) to copy.

**Recommended plan:** implement `CFGToSCFInterface` mapping its callbacks to the existing
`helix_high.if` / `helix_high.while` (+ a switch-dispatcher) ops, and replace the entire
hand-rolled `structureFunction` block-moving machinery with one call to
`mlir::transformCFGToSCF`. This is an INTERFACE-IMPLEMENTATION task against proven upstream
code, not a from-scratch algorithm rewrite. Risk drops by an order of magnitude.

**Payoff:** unlocks the gains currently locked behind the structurer - on the validation
corpus alone: kbase_mem_free +19.5pp, kbase_mem_commit +22.5pp, plus the whole
"unreachable statement(s) after return" quad (context_mmap, jit_allocate, mem_alloc), the
rootkit hooks (hook_read/write/ia32_write), and WWZ bone_pos_calc (the user's ESP function,
37.8% -> structured). And it kills the 0xC0000409 crash class permanently.

---

## 1. Why rewrite (the problem, with numbers)

v2 is currently **+17.5pp ahead of the original 0.9.2** purely from localized wins
(Phase-4 guard 0.1.6, empty-if 0.1.7, self-ref 0.1.8). But those are the easy vein, and it
is converging. The BIG remaining gains are ALL behind the structurer:

| Function | Corpus | Current | Capped by |
|---|---|---|---|
| kbase_mem_free | kbase | 52% | premature return (was a stub; guard concept gave 71.5%) |
| kbase_mem_commit | kbase | 52% | premature return (guard concept gave 74.5%) |
| kbase_context_mmap | kbase | 37.5% | 22 unreachable-after-return |
| kbase_jit_allocate | kbase | 51.2% | 87 unreachable-after-return |
| kbase_mem_alloc | kbase | 39.8% | 88 unreachable-after-return (+ crashes under the guard) |
| hook_read / hook_write / hook_ia32_write | rootkit | 36-45% | 13-20 unreachable-after-return |
| bone_pos_calc | WWZ | 37.8% | 39 unreachable-after-return |

The premature-return bug is NOT kernel-specific: it hits real game code (WWZ
`bone_pos_calc`, the bone-position function central to the user's ESP work). That widens the
case for the rewrite considerably.

The 6 failed guard attempts (FIX-v2-STRUCT-001/002, the SESE variants) are preserved on
branch `wip-structurer-premature-return` and documented in `CHANGELOG.md [Investigation]`.

---

## 2. The two failure modes (named in the literature's terms)

- **(a) Premature `return` stranding the body.** The then/else paths re-converge through a
  block with more than one predecessor, so the region collector (`collectPathBlocks`) cannot
  see a single-entry/single-exit (SESE) region and bails to `{start}`; `structureIf` then
  replaces the branch with a `helix_low.ret` (line ~2547, because `findTrivialReturnOp(merge)`
  succeeds on the shared trivial-return tail), leaving the body unreachable. In the literature
  this is "region with no valid SESE decomposition because the join is shared."

- **(b) Malformed IR -> dominator-tree assert (`0xC0000409`).** Moving a shared multi-entry
  block (e.g. kbase `bb3(%137): 2 preds` with its block-arg phi) into a `helix_high.if`
  region makes that region's ENTRY block have a predecessor, which violates MLIR's
  region-entry invariant; lazy `DominanceInfo` then asserts
  `GenericDomTreeConstruction.h:481 "(Total+1==Num)"`. Confirmed source: born in Phase 3
  (if-recovery) as a side effect of `structureIf` block-moving; the `[v2-malf]` scan showed
  nothing malformed after Phase 2.

Both are consequences of ONE design choice: **forming regions by moving raw blocks instead
of synthesizing single-entry headers.**

---

## 3. The solution: correct-by-construction structuring

Every production decompiler converges on the same principles (DREAM/NDSS'15,
SAILR/USENIX'24, rev.ng Comb/AsiaCCS'20, Phoenix/USENIX'13, MLIR lift-cf-to-scf):

1. **Never demand that a raw block be single-entry.** Synthesize the join/header explicitly.
   A shared multi-entry tail is handled by **state-variable dispatch** (a `switch` on a
   selector), **bounded tail duplication**, or **predication** - never by "give up -> emit
   return."
2. **Irreducibility is solved by edge-multiplexing on a state variable**, which is
   duplication-free and blowup-free - NOT by naive node splitting (which the current Phase
   3.5 `attemptNodeSplitting` does, and which can explode).
3. **Continuation = the immediate post-dominator; re-converge by SSA values.** The shared
   tail is emitted ONCE after the `if`, reached by `yield` from both arms, not by sharing a
   multi-predecessor block.
4. **Monotone invariant chain (rev.ng):** `single-exit (sink) -> no-cycles (do-while) ->
   single-entry-per-region (dominates_all_successors) -> diamond-shape (if)`. Each becomes a
   permanent invariant, so dominance is always well-defined and never asserts.

### Why this makes BOTH failure modes structurally impossible

- **(a)** `transform_branches` always has a well-defined continuation in a DAG (the
  post-dominator; the synthetic sink guarantees one exists), so there is no "no SESE region
  found -> inject return" path. The body after the `if` IS the continuation, reached by
  yield from both arms.
- **(b)** The algorithm asserts `dominates_all_successors(start)` BEFORE forming any region,
  and its (de)multiplexer header redirects every external in-edge through a synthesized
  header, so a region entry structurally cannot have a predecessor. Cycles are removed
  before branch structuring. `DominanceInfo` is handed only well-formed regions and never
  asserts.

---

## 4. THE PLAN: implement `CFGToSCFInterface` (reuse upstream, do NOT reimplement)

VERIFIED on disk in the LLVM build Helix links
(`C:\Users\Mazum\Desktop\caps\llvm-build\llvm-project-18.1.8.src`):

- `mlir/include/mlir/Transforms/CFGToSCF.h` - `mlir::transformCFGToSCF(Operation&,
  CFGToSCFInterface&, DominanceInfo&)` + the abstract `CFGToSCFInterface` with callbacks:
  `createStructuredBranchRegionOp`, `createStructuredDoWhileLoopOp`, `createCFGSwitchOp`,
  `createUnreachableTerminator`, `createSingleDestinationBranch`, `createConditionalBranch`.
- `mlir/include/mlir/Conversion/ControlFlowToSCF/ControlFlowToSCF.h` + its `.cpp` - a
  COMPLETE reference implementation (`ControlFlowToSCFTransformation`) that lowers the `cf`
  dialect to `scf`. This is the template to copy.

The rewrite is therefore: **write a `HelixCFGToSCFInterface` that maps the callbacks to
Helix's existing structured ops, then call `transformCFGToSCF` once.** The upstream
algorithm does all the dominance-safe region formation, the irreducible-loop multiplexing,
and the continuation routing.

Callback -> Helix op mapping (Helix already has these ops, used by the old structurer):

| `CFGToSCFInterface` callback | Maps to | Notes |
|---|---|---|
| `createStructuredBranchRegionOp` | `helix_high.if` (n-way -> nested ifs, or a new `helix_high.switch`) | the region op with one region per successor; re-converge via region results |
| `createStructuredDoWhileLoopOp` | `helix_high.do_while` / `helix_high.while` | Helix has both; map to do_while (the algorithm produces do-while form) |
| `createCFGSwitchOp` | a `helix_low`/`cf.switch` style dispatcher on the selector | the state-variable multiplexer for entries/exits; may need a small `helix_high.switch` op if not present |
| `createUnreachableTerminator` | `helix_high.unreachable` or `llvm.unreachable` | trivial |
| `createSingleDestinationBranch` / `createConditionalBranch` | `helix_low.jmp` / `helix_low.jcc` | already exist |

Open question for M0: does `transformCFGToSCF` require the input terminators to be
`cf`-dialect branch ops, or does it work on any op implementing
`BranchOpInterface`/`RegionBranchOpInterface`? The reference impl uses `cf.br`/`cf.cond_br`.
HelixLow uses `helix_low.jmp`/`jcc` - check whether they implement `BranchOpInterface`
(likely yes, they carry successors). If not, a thin normalization (HelixLow branches ->
`cf` branches) before, and (`cf`/`scf` -> HelixHigh) after, is the adapter. The cleanest
path may be: lower HelixLow -> `cf`, run the stock `lift-cf-to-scf`, then `scf` -> HelixHigh.

---

## 5. Components: keep / replace / new

### KEEP (orthogonal to region formation - no change)
- `convertCmovsToTernary` (CMOV -> ternary, pure op replacement).
- `detectEscapingValues` / `promoteEscapingValues` (SSA escape -> variable; the new path may
  not even need them since `transformCFGToSCF` routes values via region args/results, but
  keep as a safety net).
- `extractLoopCondition` / `extractConditionCode` (symbolic condition recovery for readable
  `if (a < b)` text) - feed these into the structured ops AFTER structuring.
- The `helix_high.if/while/do_while` dialect ops, the pipeline slot, the whole Low/Mid/High
  lowering around it.
- The Phase-4 guard (0.1.6) and the two localized C-AST wins (0.1.7/0.1.8) - all downstream
  of structuring, unaffected.

### REPLACE (the entire hand-rolled block-moving machinery)
- `structureFunction` Phases 2/3/3.5/4/5 driver.
- `structureLoop` (while/do-while block splicing + FIX-095c latch rewrite).
- `structureIfRegions` / `recoverIfElse` / `structureIf` (the line ~2547 ret-injection).
- `collectPathBlocks` / `findMergeBlock` (the SESE collector + its `{start}` fallback).
- `attemptNodeSplitting` (Phase 3.5 - superseded by multiplexing; node splitting is the
  thing to avoid).
- `emitGotoLabel` + the goto/label fallback (gotos become a SAILR-style bounded last resort
  inside the deopt post-pass, not the primary path).
- All the `hasIrreducibleSCCs` / `hasUnreachableBlocks` precondition guards - the upstream
  algorithm makes them unnecessary.

### NEW
- `HelixCFGToSCFInterface` (the callback impl) + the `transformCFGToSCF` invocation.
- A HelixLow<->cf adapter if HelixLow branches do not implement `BranchOpInterface`.
- Optionally a `helix_high.switch` op for the dispatcher (if nested ifs are too noisy).
- (Later, M4) a SAILR-style deoptimization readability post-pass (revert dispatcher noise,
  recover idiomatic `switch`/`&&`) - a semantics-preserving rewrite on already-well-formed
  IR, never the structuring mechanism.

---

## 6. Phasing (milestones)

- **M0 - Spike (smallest, highest-info-per-hour).** Confirm `transformCFGToSCF` links in the
  Helix build; answer the BranchOpInterface question; structure the 5 fixtures + kbase_mem_free
  through it (the simplest premature-return case). Success = mem_free has NO premature return,
  body reachable, dominance never asserts. This validates the whole approach before committing.
- **M1 - Core interface.** Full `CFGToSCFInterface` impl mapping all callbacks to HelixHigh
  ops; wire it into the pipeline behind a flag (`--use-scf-structurer`) so the old path stays
  as a fallback. Pass the fixtures byte-identical-or-better + the simple kbase functions.
- **M2 - kbase + rootkit corpus.** 0 REGRESSED / 0 STUBBED on all 14 functions; the
  "unreachable statement(s) after return" quad GONE; 0 crashes (mem_alloc/import that crash
  under the guard now structure cleanly).
- **M3 - Stress.** WWZ (bone_pos_calc + projectile_constructor, the heaviest CFGs) + the
  callfuscated boss `after.ll` (980 blocks, the definitive irreducible test). The upstream
  algorithm's irreducible-multiplexing should handle after.ll without crashing - the thing
  the old structurer cannot do.
- **M4 - Readability (optional).** SAILR-style deopt post-pass to reduce dispatcher/selector
  noise + idiomatic switch/&&. Pure polish on correct IR.
- **M5 - Promote.** Flip the flag to default-on; mirror to main-line Helix; cut v1.0.

The real work is M0-M2 (the core). M0 is a 1-2 day spike that de-risks everything.

---

## 7. Validation (the gate, unchanged from the localized-win discipline)

- **Corpus:** 32 .ll across 6 sets - kbase (7), rootkit (7), WWZ wwz-remill-lift (8) +
  wwz-remill-export (4), fixtures (5), callfuscated `after.ll` (1, the 980-block boss).
  Inventory + paths in the validation-assets research output.
- **Harness:** `tools/helix-validate/diff_v2.ps1` (confidence-aware scoreboard:
  RESCUED/IMPROVED/REGRESSED/STUBBED/CHANGED?/=) + the `HELIX_DUMP_IR` per-pass IR dump +
  the `V2DBG_DOMSITE` markers (on the `wip-structurer-premature-return` branch).
- **Gate:** 0 REGRESSED, 0 STUBBED, fixtures byte-identical, NO crashes on any of the 32
  files, and the "unreachable-after-return" penalties drop on the capped functions. Baseline
  = the ORIGINAL 0.9.2 exe.
- **Headline beneficiary to show the user:** WWZ `bone_pos_calc` (37.8%, 39 unreachable) ->
  structured. It is their ESP function, on the outdated binary that matches
  `Antigo-hexcore-reports`.

---

## 8. Risks + effort

| Risk | Likelihood | Mitigation |
|---|---|---|
| HelixLow branches don't implement `BranchOpInterface` | Medium | the cf<->HelixLow adapter (lower to `cf`, lift to `scf`, raise to HelixHigh); the stock `lift-cf-to-scf` then works unmodified |
| Dispatcher (state-variable switch) output is noisy/unreadable | Medium | M4 SAILR-style deopt; and most real functions are reducible (no dispatcher needed) |
| Region-result / yield routing doesn't fit HelixHigh's value model | Medium | study the `ControlFlowToSCF.cpp` reference; HelixHigh.if already yields, so the model exists |
| Confidence scorer needs retuning for the new (cleaner) shape | Low | the scorer is downstream + already tuned this session; re-measure |
| Effort larger than expected | Medium | M0 spike gates the commitment; the reuse-upstream path is far smaller than a from-scratch rewrite |

**Effort estimate:** M0 spike ~1-2 days; M1-M2 core ~1-2 weeks; M3 stress + M4 polish + M5
promote ~1 week. Dominated by the interface mapping + the value-routing details, NOT by
algorithm design (that is upstream and proven).

---

## 9. What carries over (nothing is lost)

- The 3 landed wins (Phase-4 guard, empty-if, self-ref) stay - orthogonal to structuring.
- The diagnostic harness (scoreboard, IR dump, malformation scan) is reused as the M0-M3 gate.
- The HelixHigh dialect ops are the structured targets.
- The 6 failed guard attempts + this scoping live on `wip-structurer-premature-return` and in
  `CHANGELOG.md [Investigation]` for the record.

---

## 10. Decision asks for the owner

1. Approve the **reuse-upstream `transformCFGToSCF`** direction (vs a from-scratch
   reimplementation)? (Strongly recommended - it is proven, dominance-safe, irreducible-capable.)
2. Greenlight the **M0 spike** (1-2 days, gates the rest)?
3. Confirm the **gate** (0 REGRESSED/STUBBED, fixtures byte-identical, no crashes, the
   unreachable-after-return penalties drop) and the **corpus** (incl. WWZ bone_pos_calc and
   the callfuscated boss)?
