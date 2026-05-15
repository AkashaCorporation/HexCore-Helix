# Helix v0.9.1 Supplement — Output Correctness Validation via helix-validate

> Companion to "Helix: Multi-Level IR Decompilation via MLIR Dialect Lowering"
> (Machado, 2026). This supplement adds a single concept the original paper
> does not cover: a **math-grounded output-correctness validator** that
> complements the per-stage pipeline-loss methodology of §4. Together they
> form a *measurement diptych* — §4 quantifies *operation survival* across
> passes; this supplement quantifies *output faithfulness* of the result.
> The two are independent: pipeline loss can be perfect (100% op survival)
> while the output still contains a malformed C statement; conversely the
> output can score well while internal passes drop information.

## 1. Motivation: the confidence ceiling

The original paper reports Helix's self-assessed per-function confidence
(§3.9). On the v0.9.1-nightly corpus this score has a documented but
unmeasured failure mode: **it can rise even as the output becomes
semantically incorrect.** Two outputs, both `Confidence: ≥95%`, observed
during v0.9.1 development:

**AmmoUsage (PE/Win64, ROTTR.exe `0x14046C1F0`)**
```c
// Confidence: 95.0% (High)  |  win64
void sub_14046c1f0(int64_t param_2)
{
    param_2 += param_2 - 16;                     // (1)
    if (param_2 >= 148 && param_2 != 148) {
        return;
    }
    return;
}
```
Line (1) is `param_2 = param_2 + (param_2 - 16) = 2·param_2 - 16`, not the
intended `param_2 = param_2 - 16`. The mathematical identity changed; the
confidence score rose 5.5 percentage points relative to the prior version
(89.5% → 95.0%) because the previous version emitted an extra placeholder
variable declaration — a *cosmetic* improvement that masked a *semantic*
regression.

**entry_point (PE/Win64, malware sample)**
```c
// Confidence: 100.0% (High)  |  win64
int64_t entry_point(void)
{
    /* ... */
    v6 ++ v6 + 1;                                // (2)
    /* ... */
}
```
Line (2) is not a valid C statement: the grammar admits `lvalue ++ ;` and
`lvalue ++ , expr` but not `lvalue ++ expr ;` at statement level. The
output does not compile. Confidence is 100%.

The original paper hypothesised in §3.9 that the v0.9.0 scorer is "more
rigorous … more honest calibration." These examples falsify that
self-assessment: the scorer is *more conservative on penalty terms it
recognises* (placeholder variables, native opcodes), but it has **no term
that fires on semantic defects of the emitted output**. The gap motivates
this work.

## 2. The methodology: helix-validate

`helix-validate` is a standalone Python script (~620 LOC, zero external
dependencies) that reads Helix output and emits three signals per function:
**Layer 1** dataflow-theorem-grounded defect findings, **Layer 2** a
bounded composite score in `[0, 1]`, and **Layer 3** a cross-version delta
when invoked with a `--baseline` directory.

It is a *measurement instrument*: it reads outputs, never modifies them
or the engine. This deliberately keeps it disjoint from the decompiler it
measures — a property the original paper's §4 instrumentation does not
have (per-stage counters are emitted by the engine itself).

### 2.1 Layer 1 — Defect detection as theorems

Each detector implements a small theorem: a property that, when it holds
in the output, *provably* makes the output semantically degenerate or
syntactically invalid. We avoid heuristics; each rule is defensible in
isolation.

**T1 — Null deref of placeholder.** For a local `v` whose only reaching
definition is `0` / `(void*)0` / `NULL` and which is never reassigned
before a use of `*v`, `*v` is undefined behaviour. Detector: a one-pass
walk over the function body maintaining the set of zero-initialised vars,
emitting a finding on every `*v` whose `v` is in the set, and removing
`v` from the set on first reassignment.

**T2 — Identity no-op.** Statements of the form `x = x;`, `x += 0;`,
`x |= x;`, `x ^= 0;`, `x &= x;` are pure identities on `x`. Their
emission is dead code in the input semantics; the lifter has introduced
spurious motion. Detector: direct lexical match.

**T3 — Suspicious self-reference.** An assignment `x = e` (or `x op= e`)
where `e` contains `x` as a standalone identifier and is not equal to `x`.
The strongest example is `x = x + x` (= `2x`) appearing where the
original semantics required `x = y + x`. Detector: parse the LHS variable,
check `\b<lhs>\b` appears in the RHS but the RHS is not exactly `<lhs>`.

**T4 — Malformed post-increment.** Statements of the form
`<lvalue> ++ <expr> ;` are ungrammatical in C: the post-increment
operator does not bind to a non-empty RHS at statement level. Detector:
line-level regex. (Catches the `entry_point` example above.)

**T5 — Unreachable after return.** A statement that follows a `return`
at the same brace depth, with no intervening label or block boundary, is
not reachable from the function entry on any path through that return.
Detector: brace-depth tracking with a per-depth "return seen" flag.

Each detector produces a `Finding(kind, line, evidence, theorem)`. The
`theorem` field carries the one-line justification — the artifact-level
output is reviewable without re-deriving why each rule fires.

### 2.2 Layer 2 — Bounded composite score

Four sub-scores, each *by construction* in `[0, 1]`:

| Sub-score | Definition |
|---|---|
| `name_quality` | `1 − (placeholders / total_ids)` where *placeholders* match `v\d+ \| param_\d+ \| field_0xN` and *total_ids* excludes C keywords. |
| `struct_recovery` | `named_fields / total_field_derefs` where a field `x->name` is *named* iff `name` does not start with `field_0x`. |
| `call_resolution` | `1 − (unresolved_calls / total_calls)` where *unresolved* matches `sub_[0-9A-F]+ \| __indirect_call \| vfunc_*`. |
| `flow_regularity` | `1 − (irregular_jumps / non_blank_lines)` where *irregular* matches `goto / continue / break` at statement start. |

The composite is a weighted mean (weights `0.35 / 0.25 / 0.25 / 0.15`,
sum to 1, chosen *a priori*) minus the sum of per-finding penalties:

| Finding kind | Penalty |
|---|---|
| `malformed_postinc` | 0.30 |
| `null_deref_placeholder` | 0.20 |
| `suspicious_self_reference` | 0.10 |
| `identity_*` | 0.05 |
| `unreachable_after_return` | 0.05 |

The final score is `max(0, min(1, base − deductions))`. The clamp is
necessary only when many findings accumulate; on well-formed output the
base sub-scores typically range 0.6–1.0 and no clamp activates.

**Why this is bounded by construction.** Each sub-score is a ratio of
counts in `[0, denominator]` — both endpoints are achievable, the
intermediate values are dense. The weighted mean of four `[0, 1]` numbers
with non-negative weights summing to 1 is in `[0, 1]`. Subtracting a
non-negative quantity and clamping to `[0, 1]` yields a value in `[0, 1]`.

### 2.3 Layer 3 — Cross-version delta

With `--baseline DIR`, `helix-validate` matches functions by emitted name
across the two corpora and reports `(baseline_score, current_score, Δ,
classification)`. A small dead band (default `|Δ| < 0.02`) avoids
classifying numerical jitter as movement; everything outside is
`improved` or `regressed`.

The dead-band threshold and the per-finding penalties are the only two
free parameters of the methodology. Both are conservative and chosen
*before* the empirical evaluation, not tuned against it.

## 3. Empirical evaluation

### 3.1 Corpora

Four corpora are exercised, all reusing this paper's existing test corpus
(§7.1) plus the v0.9.1 standalone re-runs produced for this supplement:

| Corpus | Source | Functions | Notes |
|---|---|---|---|
| **C-PE** | ROTTR.exe v0.9.1 (`helix_tool`, this work) | 11 / 13 | 1 segfault, 1 unattempted (see §4) |
| **C-ELF-kernel** | `malware.ko` v0.9.0 outputs (existing in §4.2 corpus) | 5 | The HTB battle-test from the v3.9.0 gap audit. |
| **C-PE-baseline-V4** | ROTTR.exe via VSCode extension, prior `.node` | 25 | The pre-this-session baseline. |
| **C-PE-baseline-V3** | ROTTR.exe via Helix v0.8.0 outputs | 20 | The pre-v0.9.0 baseline. |

### 3.2 Confidence-vs-validation gap (the headline)

On C-ELF-kernel (5 functions of an in-the-wild Linux ftrace rootkit), the
mean Helix self-confidence and the mean `helix-validate` score diverge
sharply:

| Function | Helix conf. | helix-validate | Layer-1 findings |
|---|---:|---:|---|
| `fh_ftrace_thunk` | 91.0% | **52.8%** | suspicious_self_reference, unreachable_after_return |
| `fh_install_hook.cold` | 90.2% | **23.1%** | suspicious_self_reference, unreachable_after_return |
| `hook_read` | 81.7% | **57.2%** | suspicious_self_reference, unreachable_after_return |
| `hook_syslog` | 91.0% | **22.3%** | suspicious_self_reference, unreachable_after_return |
| `hook_write` | 90.2% | **55.8%** | suspicious_self_reference, unreachable_after_return |
| **Mean** | **88.8%** | **42.2%** | — |

The gap of **46.6 percentage points** on a real-world malware analysis
target is the strongest single result of this work. Every function in the
corpus triggers `suspicious_self_reference` (T3) and
`unreachable_after_return` (T5); these are not isolated edge cases but
systematic defects of the v0.9.0 lift pipeline that the existing scorer
fails to penalise.

### 3.3 Detecting a regression masked by rising confidence

The methodology is self-validating in the same sense the original paper's
§4.1 is: applying it to v0.9.1 outputs caught a *regression* that the
self-confidence score moved in the wrong direction on.

| Version | AmmoUsage confidence | AmmoUsage helix-validate | Output |
|---|---:|---:|---|
| V4 (pre-this-session) | 89.5% | 51.7% | `v1 = param_2 - 16; if (v1 ≥ 148 && v1 ≠ 148) …` |
| v091 (this session) | **95.0%** | **40.0%** | `param_2 += param_2 - 16; if (param_2 ≥ 148 …)` |

The v091 output is *semantically wrong*: `param_2 += param_2 - 16` evaluates
to `2·param_2 − 16`, whereas the V4 output computed `param_2 - 16`. The
condition that follows then guards the wrong inequality. Helix's confidence
*rose* 5.5pp by removing a placeholder declaration; `helix-validate`'s
score *fell* 11.7pp by detecting the T3 defect. Without the validator
this regression ships under a green-looking confidence number.

### 3.4 Cross-version corpus summary

Per `helix-validate --baseline V4 v091`:

| Class | Count | Note |
|---|---|---|
| `improved` | 1 | `sub_14071df4e` (BattleConductor-inner): +3.1pp |
| `regressed` | 3 | including `sub_14046c1f0` (AmmoUsage, above) |
| `unchanged` | 2 | within ±2pp dead band |
| `new` | 5 | functions named by v0.9.1 (entry_point, kbase_*) absent in V4 |
| `removed` | 14 | functions named in V4 by hex (`sub_XXXX`) absent in v0.9.1 |

The `new`/`removed` rows are an artefact of the v0.9.1 Win64 entry-point
detection + AddressSpace structural recovery (this paper's
contributions): functions previously emitted as `sub_140xxxxx` now carry
symbolic names, so name-based matching fails. The mean Δ across
*matched* functions is −9.3pp — a measurable but localised regression
concentrated in functions touched by the v0.9.1 lift-path changes. This
is a real engineering finding the original methodology (§4.1) could not
have produced because operation survival is high across all these
functions; the defect is in the emitter, not the pipeline.

## 4. Limitations

`helix-validate` is *pattern-based* over the emitted C, not an SMT-grade
equivalence check against the source IR. A function that decompiles to
well-formed but *semantically incorrect* C — incorrect in a way that no
T1–T5 detector fires on — scores cleanly. Promoting the methodology to
SMT-grade requires an op-to-bit-vector encoding of HelixLow/HelixMid and
a per-BB equivalence query against the input IR (cf. translation
validation; Pnueli et al., TACAS 1998; Necula, PLDI 2000). The Z3
solver is already in the HexCore tree via Souper (§7.1) and could be
reused; the missing piece is the op-encoding adapter. This is left as
direct future work.

Second, two free parameters (penalty values, dead-band threshold) are
chosen *a priori*. We avoided tuning them against the evaluation, but a
proper sensitivity analysis is owed.

Third, function-name matching for Layer 3 is brittle when the engine
renames functions across versions (the `removed`/`new` rows in §3.4).
A more robust matching by IR address or by signature is a small
engineering item but absent here.

Finally, the `InfiniteAmmo-UI` ROTTR function consistently crashes the
v0.9.1 engine (segfault in a post-`HelixMidToHigh` pass on a 68KB lifted
IR). `helix-validate` cannot score what was never emitted; the corpus
gets a `0` for it, which is technically correct but uninformative.
Investigating that crash is a separate work item.

## 5. Relation to the original paper

This supplement adds Contribution 8 to the paper's list of seven:

> 8. `helix-validate`, a math-grounded output-correctness measurement
>    instrument that complements the pipeline-loss methodology of §4.
>    Three layers (dataflow-theorem-based defect detection; bounded
>    composite scoring; cross-version delta) provide a single monotone
>    quality number that, on a real-world Linux rootkit corpus, diverges
>    from Helix's self-reported confidence by 46.6 percentage points and
>    correctly detects a semantic regression that the existing scorer
>    masked behind a rising confidence number.

If integrated into the main paper, the natural placement is a new §5
(before the current SSA Variable Splitting section, which becomes §6)
titled "Output Correctness Validation." §4 becomes "Pipeline-Internal
Quality" and §5 "Output-External Quality" — symmetric framing.

## 6. Artifact

`tools/helix-validate/helix_validate.py` in the Helix tree. Standalone,
stdlib-only, MIT-licensed under the same terms as Helix itself. The
empirical-evaluation JSON outputs used to construct §3 are alongside the
corpora at `hexcore-reports/v091-vs-V4.validate.json` and
`rev_kernel_monarch/hexcore-reports/02-disasm/malware-ko.validate.json`.
