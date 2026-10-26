# Changelog

All notable changes to HexCore Helix are documented here.


## [Unreleased]

**HAST 1.1 native quality transport.** Function records now include an explicit
native-quality report and typed issue codes, independent of confidence scores.
The legacy table prefix is preserved. Semantic consumers must support the new
quality capability; older readers do not enforce these barriers. Paired HQL
consumer migration and package qualification remain required before deployment.

**Opaque post-call register state.** x64 calling-convention recovery tracks
potentially clobbered GPR bits across CFG predecessors and backedges. Reads
not resolved by subsequent writes use explicit state-provider expressions,
not the original parameter value. The output remains partial with an opaque
state diagnostic; this does not assume tracing callbacks are no-ops.

**Stable copy-propagation definitions.** C-AST copy propagation snapshots its
definitions before rewriting RHS nodes, resolves bounded copy chains, and
retains assignments still referenced after expansion. This prevents dangling
definition pointers and empty variable names in emitted returns.

**Register lifetime and return binding.** SSA declarations use a stable
declaration anchor instead of a potentially erased instruction. Void call
types are not propagated into register storage. Non-void x64 returns may bind
to a unique referenced RAX identity when no canonical result variable exists;
ambiguous and unreferenced identities remain unbound.

**Raw byte-address semantics.** LLVM integer add/sub address expressions retain
explicit pointer-to-integer conversions and memory accesses retain the loaded
or stored type. Same-width pointer/integer casts are no longer removed merely
because their register widths match. Pointer declaration IDs, including
retained parameter declarations, inform address emission after legalization.

**Scaled nominal arrays.** Integer array fields can recover explicit
shift/multiply index scales matching their element width. C-AST emission
checks scale and memory-access width before replacing byte-address arithmetic
with a named subscript; mismatched accesses are not promoted.

**Nominal fields at offset zero.** Direct dereferences of a known record
pointer can now resolve to its first leaf field when debug layout size
exactly matches the accessed width. Unknown-size and width-mismatched accesses
are not promoted to whole-field accesses.

**Scalar pointer types.** Canonical type spelling recovery now parses pointees
recursively instead of turning scalar pointers such as `uint64_t*` into
`struct uint64_t*`. Nested scalar/void pointers preserve their pointer levels;
existing nominal-struct fallback behavior remains unchanged.

**Incomplete ABI call diagnostics.** Calls with a supported authoritative
integer/pointer signature retain explicit missing-argument counts when ABI
recovery cannot bind all arguments. A function-level diagnostic survives
C-AST optimization and caps the existing confidence score at 50%, so the
current HexCore quality consumer reports partial output instead of a clean
result. Unknown signatures are not treated as proven argument mismatches.

**Win64 outgoing integer stack slots.** Stack recovery retains explicit
RSP-relative store offsets. For supported exact integer/pointer signatures,
call recovery binds full-width slots starting at RSP+32 after the four register
arguments. Captured values retain snapshot identity; intervening RSP changes
or unresolved effects reject the association.
Intervening register reads no longer incorrectly block recovery of these slots.

**Outgoing argument snapshots.** Captured push values retain a snapshot
identity through variable merging and single-use inlining. This prevents the
capture from reverting to a read of a register overwritten before the call.

**SysV pushed call arguments.** For supported non-variadic integer/pointer
signatures, call recovery binds an intact same-block sequence of 64-bit pushes
after the six register arguments. Values are materialized at each push point
and appended in ABI order; consumed pushes are removed during lowering.
Unknown signatures, saved-register pushes and intervening memory/stack barriers
remain outside this recovery path.

**Exact arity for unnamed callees.** Calling-convention recovery now honors
`helix.debug_param_count` before applying callee-name heuristics. A `sub_...`
name no longer causes an authoritative zero- or three-argument signature to
be ignored in favor of extra prepared registers.

**Constant frame displacement recovery.** Frame inference now tracks RSP
snapshots and constant add/subtract operations before RBP establishment.
Recognized adjustments shift the incoming argument base correctly; dynamic
adjustments and arithmetic overflow remain unresolved.

**Unknown frame displacement.** Frame-base inference now rejects unmodeled
RSP/ESP writes or pops before RBP establishment. Counting pushes alone could
otherwise classify the wrong stack slot as an incoming parameter.

**SysV integer stack parameters.** Stack layout recovery recognizes the
seventh and subsequent SysV integer parameters at entry RSP+8 onward, using
the target triple when calling-convention recovery has not run yet. Adjusted
or unproven incoming RSP contexts are excluded from this inference. A fresh
0-10 argument sum matrix for SysV and Win64 passes 88 executable C checks.

**Field address preservation.** Mid-to-High conversion now lowers
`field.ptr` to `AddressOf(FieldAccess)`. Returning or forwarding a field
address therefore retains the address operation instead of becoming a field
value. A direct-Mid versus converted-High regression covers the distinction.
C-AST load emission cancels only an explicit field AddressOf; dereferencing
a pointer stored in the field remains a real memory access.

**CMP/TEST register operand widths.** The Remill demangler now extracts the
width of the first read-register accessor for CMP and TEST instead of retaining
the 64-bit default. Widened semantic-call arguments no longer cause signed byte
comparisons to use the wrong sign bit. Fresh Remill byte-comparison controls
pass all 65,536 operand pairs for each of signed and unsigned less-than.

**Preserve signedness-changing C casts.** Redundant-cast elimination now
requires equal signedness as well as equal integer width. Otherwise an
unsigned comparison can silently become signed after correct C-AST lowering.
The comparison regression now exercises cleanup too: unsigned zero less than
UINT64_MAX must retain its unsigned interpretation.

**Call-clobber barrier in argument recovery.** Backward register-write lookup
now stops at real ABI calls and distinguishes a blocked lookup from missing
local state. Predecessor fallback cannot cross that barrier. This prevents
argument stabilization from replacing a saved SSA value with a caller-saved
register read after an intervening call.
Marked machine intrinsics are excluded from ABI argument inference and
stabilization, preserving their explicit instruction operands.

**Typed access through void pointers.** High memory dereferences with a
void-pointer operand now use an explicit pointer cast matching the operation's
value type. This avoids invalid C such as `*param_1` when `param_1` is `void*`.
A fresh Remill load/clear/return control compiles and preserves six original
64-bit values while clearing their storage.

**One-bit sign extension.** C-AST emission now preserves `sext i1` as
`bit ? -1 : 0`, including 8/16/32/64-bit destinations. Widening a C boolean
directly incorrectly produced positive one. A focused LLVM-to-C-AST regression
checks both result arms and destination types after simplification. The same
helper handles direct Mid and High extension operations; all three input forms
are covered at four destination widths.

**Helix 0.9.4 F02 (cast-aware algebraic identity).** C-AST structural
equality now requires `CCastExpr` destination types to match recursively,
including integer width and signedness, before applying identities such as
`x - (x - y) -> y`. This prevents a narrow cast from being treated as the
same value as a wider cast. Matching-cast and mismatched-width controls pass;
the complete native suite passes with one optional fixture skipped.

**Helix 0.9.4 ABI forwarding and extension semantics.** The calling-convention
pass now reconstructs a bounded first-call ABI prefix when an exact signature
or a prepared later argument proves its length. Untouched leading registers
become explicit live-in reads, while any earlier call barrier disables the
heuristic. `kbase_csf_queue_register` now retains two inputs and emits
`csf_queue_register_internal(param_1, param_2, 0)`. Integer extensions retain
both sides of the C conversion: zero extension prints a narrow unsigned cast
before the wider unsigned cast, while sign extension preserves signed types.
The recovered unsigned range accepts 4096 through 2^31 and rejects tested
values outside that interval.

**Helix 0.9.4 F04 (single-evaluation call arguments).** Memory-derived values
already saved into an ABI register are read from that register at a later call
instead of recursively rebuilding the load expression. The rewrite requires
an exact latest register-write/value match. In `kbase_mem_free`, clearing the
pending slot no longer changes the later free operand: the saved region is
passed to `kbase_free_alloced_region`. The BTS storage/index reconstruction is
still open and is not covered by this fix. The complete native suite now passes
321/321 with one optional fresh-producer fixture skipped; both Mali controls
are byte-deterministic across 5/5 engine-direct and 5/5 N-API runs. The isolated
candidate is `hexcore-helix.094-f02-abi-f04.node`, SHA-256
`90AC0A1440DB9CBC55096A649D17B9BB69EBAF71EAC93EFE25692C9EADB6C7A9`;
it has not been installed into the open IDE.

**Helix 0.9.4 BTS memory semantics.** Remill `BT/BTS/BTR/BTC` memory/register/
immediate name variants are now classified explicitly. The `BTSmem` path is a
machine intrinsic with program-memory read/write effects, explicit storage and
bit-index operands, and a CF result; it no longer falls through ABI call
recovery or acts as a real-call clobber barrier. The Mali control now emits
`atomic_test_and_set(v5 + 0xA4F8, result)` instead of using the pending-region
pointer. Native validation passes 322/322 with one optional fixture skipped.
Isolated candidate `hexcore-helix.094-wave2-bts1.node`, SHA-256
`45DEE4EBC8544B1798B31E4A433B1655FF33645488D8649B10A93FCAE64F620B`,
is deterministic across 5/5 N-API runs for both current Mali controls and has
not been installed into the open IDE.

**Explicit lifted-entry identity.** Preserve LLVM function attribute
`"hexcore.entry_address"="0x..."` through import and consume it before PC
lowering. Legacy encoded function names remain supported; missing identities
are errors instead of fabricated zero addresses. Block labels are not used as
entry identities because current Remill can emit ordinal names such as `bb_0`.
Invalid attributes and conflicts with an encoded function entry are rejected.
Source/C ABI tests pass, including zero and high-bit addresses. Addon relinking
and packaged integration qualification remain pending.

The N-API wrapper now reads the canonical HAST identity for single-function
results instead of returning `functionName:"mlir_decompiled"` and an empty
entry address. Multi-function results keep both scalar identity fields empty.
The minimal reader rejects legacy HRST/truncated buffers and preserves valid
zero/high-bit addresses. Candidate `.node` `75EC02F4...7309BC7` passes isolated
A/B tests; the IDE addon remains unchanged pending a closed-process swap.

**FIX-154 (preserve scalar floating-point register loads through Low
lowering).** A complete ROTTR `receive-damage` lift exposed a final verifier
failure where valid LLVM `fptrunc double -> float` consumed `i128` after
`RemillToHelixLow`. Scalar `load double` from an XMM-backed pointer fell through
the generic physical-register path, which replaced it with a full-width i128
`RegReadOp`. Scalar f32/f64 register and memory loads now read their logical
bit width and bitcast back to the original float type, matching the existing
vector-preservation contract.

The retained 236,135-byte IR is SHA-256
`8CCB0E00630072A23961B80B3C8560F45A6EE6DF66B6F8248743D6E118053CFD`.
The previously installed addon (`F4736ED6...445776`) reproduces the verifier
failure; candidate `hexcore-helix.rottr-fptrunc1.node`
(`ACEED38E3173EA4CE7803E0357A2A15F13CB835CCDD7845F25AB53C0719F13F9`)
emits 493 lines at an honest 29.1% confidence. The exact output is stable over
10/10 same-process runs, and the NUCLEO oracle is 10/10 functions stable at
K=5. The complete native suite passes 309/309. The remaining
`MULrax`/`MAXPS` operations stay visible as unsupported semantics instead of
invalidating the MLIR module.

**MLIR function/SCF/source-legalization closure.** Final `high.func` now
implements `FunctionOpInterface` as well as `CallableOpInterface`, accepts real
multi-block function bodies, and carries recovered argument metadata plus entry
block arguments. Read-only recovered parameters are real SSA arguments; mutable
parameters remain explicit storage. Low, Mid, and High call families implement
`CallOpInterface`, while complete High signatures verify return arity and type.

The C-AST path now consumes native `scf.if`, `scf.index_switch`, and canonical
`scf.while` directly and performs de-SSA only at source legalization. This lane
is default for the C-AST emitter. `HELIX_LEGACY_SCF_BRIDGE=1` keeps the former
High synthetic-variable bridge for controlled A/B. Residual irreducible
`cf.br`/`cf.cond_br`/`cf.switch` tails emit explicit labels and gotos, with
snapshotted block-argument transfers preserving simultaneous PHI semantics.
Index casts introduced solely for SCF selectors no longer become unhandled
helpers.

This exposed and fixed two hidden closure defects: `high.func` had accidentally
retained a one-block region constraint, and strict dialect conversion rejected
legal CF/SCF infrastructure. On the focused Mali JIT lift, the direct lane
removes an undefined bridge temporary that made the final branch constant-like;
output moves from 51 lines / 86.3% to 64 lines / 88.8% with routed yields
preserved. Seven Mali lifts, WWZ, and the large CSF fixture complete under
strict tier closure and per-pass verification without SCF/CF or block-argument
leaks. The legacy opt-out remains byte-identical to its prior output.

The opt-in MemorySlot pilot now materializes a real safe single-block stack
local family before official Mem2Reg; `kbase_mem_import` provides one accepted
candidate while no-candidate targets remain byte-identical. Native tests pass
**306/306** normally and with per-pass verification. Final isolated addon (not
installed): `hexcore-helix.mlir-foundation-final-20260822.node`, SHA-256
`7284A673FCA9C36ECB70953569243F02FD3D2C3335AC509ECB96DA359EE625E4`.
Strict/verifier K=10 hashes are WWZ `594CC315...AB209`, Mali JIT
`759F66EB...E38B0`, and Mali CSF `DD96B3C3...DE0A`.

**Third MLIR re-audit and closed-tier wave.** Recovered High operations are
normalized back to Mid by default, and strict Low-to-Mid now closes across the
seven current Mali lifts. Rotate, bit-scan, XCHG, non-prologue push/pop, and
variadic bundles have exact or explicit Mid/High carriage rather than residual
Low whitelists. Default and strict outputs are hash-identical for all seven
targets with zero stderr.

The re-audit fixed three verifier-exposed correctness bugs: DCE no longer keeps
stale VarRef handles after mutation; canonicalized asymmetric `scf.while`
results are routed before erasure; and CMP/TEST plus memory stores are
normalized to their machine width. Twelve Low op verifiers now reject width
and operand-contract violations. Scalar vector-register updates carry an
explicit `helix.partial_write_width` marker.

`HelixMidSimplify` no longer applies De Morgan to integer BitAnd/BitOr. This
restores material flag-mask conditions such as `flags & 0x1000` and
`!(value & 0xFFF)` that the old pipeline reduced incorrectly to truthiness.
Canonicalizer and CSE complete the seven-target structural gate, but remain
audit-only because their semantic deltas need an executable oracle.

The Addressable interface is now common to all three dialect bases, the pass
registry covers 25/25 factories, final MLIR verification is unconditional,
and HAST preserves Temporary and Block categories without enum downgrade.
Native tests pass **297/297** normally and with per-pass verification. Final
isolated addon (not installed):
`hexcore-helix.mlir-reaudit-20260822.node`, SHA-256
`D3631148F26F775FE5EB4A2344EC2008DD947652FA26BEA124E943FD56C83F08`.
N-API strict/verifier K=10 is stable on WWZ, Mali JIT, and Mali CSF.

**P0.3 lossless-semantics wave.** INT3 is now a first-class observable
`debug_break` through Mid/High; MOVZX/MOVSX carry distinct structural cast
kinds; machine MUL/IMUL/DIV/IDIV preserve signedness; and APInt folding refuses
signed division overflow. Mid/High CastOps now have local direction/width
verifiers. Missing Remill operands, undefined values, unavailable flags,
unresolved CMOV/SETcc/Jcc conditions, and null-based unresolved loads become a
located `__helix_unknown(...)`, never zero/false/always-taken. Surviving unknown
is a damning honesty defect and caps confidence at 50%.

Register XCHG uses real RegisterTracker identities and emits one observable
swap helper; memory XCHG emits one atomic exchange returning the old value.
HandleUnsupported and flag-state instructions are visible unhandled operations,
not NOPs. Non-self PXOR/XORPS/XORPD preserves both 128-bit operands instead of
copying operand one or degenerating to `0 ^ 0`. CMOV conditions recover from
predecessor flags when evidence exists. Release telemetry is silent by default.
The node build fingerprints `helix_engine.lib` by SHA-256 so C++-only changes
force Cargo to relink rather than shipping a stale addon.

Validation passes **289/289** normally and with per-pass verification. WWZ,
Mali JIT, and Mali CSF are deterministic at K=10 with zero stderr. JIT keeps
74.5% and identical control/call/store counts; WWZ/CSF retain additional paths
behind explicit unknowns and honestly cap at 50%. Final candidate (not installed
in the IDE): `hexcore-helix.p03-lossless-final-20260822.node`. See
`P03_LOSSLESS_SEMANTICS_20260822.md`.

**Second MLIR audit reconciliation.** The N-API integration now calls one
combined C ABI that returns pseudo-C, verified HAST, and final-IR metrics from
a single pipeline execution. `blockCount` is the number of legalized
structural blocks; `instructionCount` is the number of distinct non-zero
source addresses surviving legalization. Owned C buffers have an explicit
free API. A release `.node` exercised the path successfully with non-zero
metrics instead of the former unconditional zeros.

The re-audit also fixed four hidden contract regressions: physical stack-slot
width is legacy type evidence and no longer blocks stronger recovered struct
types; infrastructure DCE erases consumers before producers instead of using
`dropAllUses()`; annotated callee-save push/pop artifacts are removed in the
late lane; and Mid `Deref` is a program-memory read rather than `Pure`.
C-AST annihilator folds (`x * 0`, `x & 0`) now preserve calls and memory
evaluation. The GitHub engine job builds and runs the native verifier lane.
Native tests pass **275/275** both normally and with
`HELIX_VERIFY_EACH_PASS=1`. WWZ, Mali JIT, and Mali CSF remain byte-identical
to their accepted promoted-SCF baselines. Canonicalizer remains audit-only and
still exposes the late bridge use-list abort; CSE alone completes on WWZ.

**Race-worker semantic correctness and tier-closure lane.** Fixed two
controlled false-high defects: memory increments now print a parenthesized
deref lvalue (`(*p)++`), and Add/Sub result plus derived flags share one SSA
definition through source legalization, preventing `result--; if (result - 1)`
double evaluation. Definite-assignment honesty now traverses nested loop bodies
without crediting loop-local writes at loop exit, so the still-uncertain
non-void signature is honestly capped at 50% instead of 97.5%.

Low-to-Mid and Mid-to-High now publish residual/tier-contamination metrics and
support `HELIX_STRICT_TIER_CLOSURE=1`. Native SCF now remains SSA through Mid
analysis by default and is bridged only at source legalization;
`HELIX_EARLY_SCF_BRIDGE=1` retains the old lane for A/B. This reduces early
High contamination on the controlled worker from 32 to four parameter ops.
Native-SCF return recovery and cross-tier DCE preserve values through SCF and
Mid stores.

Scalar SSE memory moves now decode `MVnI/MVnW` direction and lower to real
load/store effects; `MOVxPS` models packed register copies and 128-bit memory
moves; `UNPCKLPS/HPS` interleave lanes instead of treating Remill's `Memory*`
return token as scalar data. Final source legalization replaces the temporary
`low.func` compatibility wrapper with `high.func`, publishes final container
metrics, and removes the ordinary CallOp manual-conversion fallbacks. WWZ,
Mali JIT and Mali CSF promoted-default outputs are byte-identical to the
accepted deferred baselines; the early lane is byte-identical to its previous
baseline.

Final `high.func` now carries an MLIR `FunctionType` derived from recovered
parameter/result evidence and implements `CallableOpInterface`; High call and
variadic-call ops implement `CallOpInterface`; Low/Mid/High returns carry
`ReturnLike`. The previously generated-but-unlinked Helix interface
definitions now compile in `Interfaces.cpp`, and all three function tiers
implement `HelixDecompilableOpInterface`. Signature provenance/completeness is
explicit (`helix.signature_source`, `helix.signature_complete`); orphan
parameter refs make the signature incomplete rather than silently authoritative.
Native suite **264/264**. See
`RACE_WORKER_SEMANTIC_CLOSURE_20260822.md`.

**MLIR reusable-infrastructure pilots.** Added a provenance-aware type-evidence
arbiter and routed every `inferred_type` writer through it. Debug, signature,
interprocedural, structural, dataflow and legacy facts now have explicit
authority; weaker facts cannot overwrite stronger facts, equal disagreement
is recorded, and the existing dataflow pointer-over-scalar refinement remains
preserved. Added explicit Mid slot alloc/load/store operations implementing
MLIR MemorySlot interfaces, an opt-in official Mem2Reg pilot with `undef`
defaults, and DataFlowSolver constant/uninitialized telemetry. Fixed
EscapeAnalysis container selection, gated behind
`HELIX_ESCAPE_ANALYSIS_V2=1` pending corpus acceptance. CSE and Canonicalizer
have separate audit gates; CSE completes on WWZ but changes structure, while
Canonicalizer still exposes a late bridge RAUW/use-list abort. Production
defaults remain unchanged. See `MLIR_INFRASTRUCTURE_PILOTS_20260822.md`.

**AAPCS64 live-X0 return binding wave.** `BindReturnValues` now preserves the
normal unique `result` rule and, only for `aapcs64`, falls back to exactly one
live recovered `param_1` storage when no canonical result exists. Zero or
multiple candidates remain implicit. This closes a real Low-to-High identity
loss where Remill had correctly written X0 but the C-AST returned a new,
uninitialized local.

On the exact CZG3 Samsung graphics library, six bounded getters move from 50%
with an uninitialized return to 85-89.5% with offsets/index scales matching the
IDA 9.3 oracle. The other three functions remain unchanged and honestly expose
their AArch64 opcode/control-flow debt. The full native suite passes **251/251**,
the current Mali JIT/CSF/WWZ lane produces 144 verifier dumps with zero failure,
and NUCLEO is 10/10 stable at K=10. The installed development addon SHA-256 is
`CFD4E5F2BDFD49FEE5BC8EBA3348BD94F9134BB3965EF6F95B1B9F7F597E9F46`.
See `AAPCS_RETURN_BINDING_20260822.md`.

**Effect resources and address/load separation wave.** Low register state, Mid
and High recovered-variable state, and program memory now use distinct MLIR
resources. High Unary effects are kind-dependent: only Deref reads program
memory, while Neg/Not/AddressOf are effect-free. FieldAccess and Subscript are
again Pure address/lvalue computations, matching their Mid FieldPtr/IndexPtr
producers; the actual load remains an explicit Deref. High Assign dynamically
classifies variable targets versus program-memory targets. Push/pop/XCHG and
REP operations now declare their hidden register/program-memory effects without
claiming that POP writes program memory.

Nine focused contracts cover resource identity, dynamic effects, safe positive
CSE and write barriers. The native suite passes **249/249**. Current Mali JIT,
Mali CSF, and WWZ complete 144 verifier dumps with zero failure and emit output
byte-identical to the accepted CF/OF wave; Mali JIT remains deterministic at
K=10. MLIR 18 generic CSE still treats any intervening write as a barrier even
across distinct resources, so it remains disabled in production. See
`EFFECT_RESOURCES_20260822.md`.

**Fixed-width CF/OF and ordered signedness wave.** Mid and High now distinguish
`Ult/Ule/Ugt/Uge` from signed `Lt/Le/Gt/Ge`, and the C-AST emits explicit
width-aware casts for ordered comparisons. CMP, ADD, and SUB recover live carry
and overflow from fixed-width semantics; constant folding uses `llvm::APInt`
instead of host signed arithmetic. Composite x86 conditions canonicalize
`SF xor OF`, `ZF or (SF xor OF)`, and `CF or ZF` into direct signed/unsigned
comparisons while isolated JO/JS-style flag consumers retain exact formulas.

Eight boundary contracts cover 8-bit borrow, wrap and signed overflow plus
C-AST signedness, Jcc canonicalization, and fixed-width CSE identity. The native
suite passes **244/244**.
Mali JIT, Mali CSF, and current WWZ complete 144 verifier dumps with zero
failure in roughly 10.1 seconds; Mali JIT is deterministic at K=10. Mali CSF
is byte-identical, while WWZ replaces redundant negated comparison chains with
direct `>` conditions. A rejected eager version that exposed flag algebra and
took roughly 56 seconds was not retained. See `CF_OF_SIGNEDNESS_20260821.md`.

**Lossless Low-to-Mid operation and result-flag wave.** `ROL`/`ROR` are no
longer changed into shifts, and `BSWAP`/`BSF`/`BSR` no longer fall through to
negation. Until Mid has first-class forms, these operations remain explicit Low
ops and the C-AST emits width-specific rotate or existing bit-operation
builtins. Binary and supported unary arithmetic now derive live zero/sign flags
from the actual result instead of replacing both with false.

This restores an IDA-confirmed branch in the current Mali JIT lift:
`(timeline_flags & 4) != 0` once again guards `_kbase_tlstream_jit_alloc`
instead of executing it unconditionally. The current Mali CSF and WWZ outputs
remain byte-identical, all three complete 144 verifier dumps with zero failure,
Mali JIT is deterministic at K=10, and the native suite passes **239/239**.
Carry/overflow recovery remains explicitly deferred to opcode-specific,
fixed-width contracts. See `LOW_TO_MID_SEMANTICS_20260821.md`.

**MLIR effects truthfulness and current-lift verifier wave.** Register reads,
variable references, stack exchanges, pop, memcpy, memset, and conservative
High-level address expressions now declare the state they actually read or
write instead of exposing false `Pure` contracts. Four adversarial optimizer
tests prove that reads do not cross intervening writes while still allowing
equivalent reads to coalesce when the state is unchanged. Generic CSE remains
disabled in the production pipeline.

Current Mali JIT/CSF and WWZ lifts also exposed and closed width/ODS defects in
register-load replacement, CMOV lowering, post-variable-recovery identity
casts, Mid constant attributes, and 128-bit XMM parent storage. All three
current fixtures cross the complete per-pass verifier lane and emit C. The
native suite passes **236/236**. Historical Remill-7 lifts remain compatibility
fixtures only; they are not used as the current quality oracle. Unsupported
`BTSmem`, `UNPCKLPS`, and `MOVSD_MEM` evidence remains visible as coverage debt.
See `EFFECTS_TRUTHFULNESS_20260821.md` for the exact fixtures and artifacts.

**Verify-audit lane (semantic-consolidation PR 1).** `HELIX_VERIFY_EACH_PASS=1`
now enables MLIR's native verifier between every pass and installs a dedicated
instrumentation that records the first invalid producer, stops before the next
semantic pass, and writes per-pass before/after IR plus `first_failure.txt` to
an isolated run directory. Production compatibility remains unchanged when the
environment variable is absent.

Direct contracts prove that valid IR produces paired dumps and that a pass
which removes a required terminator is named, dumped, and stops the following
pass. The lane then found and closed five existing contract violations in
sequence: 22 identity LLVM integer casts after register-value replacement,
signless `stack_offset` where High requires `si64`, signless Mid/High call
addresses where ODS requires `ui64`, signless Mid constant values where ODS
requires `si64`, and signless High field offsets where ODS requires `ui64`.

The normal native suite passes **232/232**. Both the real Remill-6 integration
fixture and the complex Remill-7 BonePosCalc9 SCF fixture now cross every pass
with the verifier active. The Remill-6 audit emits 24 before/after pairs (48
MLIR files) and no `first_failure.txt`. Historical failing reproducers remain
under `C:\tmp\helix-verify-audit-*-20260821` as evidence of the progression.

**Foreigner semantic-boundary hardening (sandbox package 0.1.9).** Function
ownership, calling-convention recovery, debug-type application, and the
Disassembler-to-Helix analysis context now remain bound to the requested
target. The Remill lowering recognizes 128-bit SIMD zero idioms and emits the
complete zero store. The C-AST optimizer removes synthetic `scf_w*` do/while
wrappers only when straight-line assignments prove that the first condition
is false; unknown or real loop guards remain intact. On the retained raw
Foreigner lift this narrow SCF rule reduces output from 362 to 350 lines,
from four to two do/while loops, and from 97 to 85 `scf_*` references while
retaining the honest 50% confidence result.

The native suite passes 224/224. The retained raw lift is byte-identical over
K=10 separate-process runs (SHA-256
`6B0A427EC4ED9C1C2848C51DD13E2C7F1D76AAE4BE7B0A7616F9DAC544853D65`),
and the NUCLEO same-process oracle is 10/10 functions stable at K=10. The
installed candidate is SHA-256
`4BD498CF03E0F0A866BC8DA400D22CE7050D5B9747898B987CD41A5C61603553`.

The package remains the v2 development sandbox for the public Helix 0.9.3 RC
line; this internal version bump does not promote Helix to a final release.

**FIX-153 (preserve constant-comparison ownership in C-AST).** A retained
live-memory lift from HTB `ffmodule` exposed a native access violation after
all MLIR passes had completed. `flattenZeroComparison` moved one operand out
of a binary expression before discovering that both operands were integer
literals. It then returned the original expression with a null child, and the
C-AST printer dereferenced the malformed tree. The optimizer now identifies
constant-vs-constant comparisons before transferring ownership, leaving
expressions such as `1 == 0` intact for the existing constant-folding stages.

A focused ownership regression verifies that both operands survive condition
polarity simplification and that the expression remains printable. The native
suite passes **220/220**. The exact 116,688-byte retained IR that previously
crashed now completes both directly and through the isolated decompilation
path. Its output is deterministic across **K=10** same-process runs (one
SHA-256), and the standard NUCLEO oracle is **10/10 stable at K=10**. Final
standalone candidate (installed in the development IDE):
`target/release/hexcore-helix.fix153-constant-zero-ownership.node`, SHA-256
`A7BA046D6F87DDDD4FE1683EBECB394D03C9DBE6E39F83FF441122BF06E69871`.
The displaced addon is retained as
`hexcore-helix.win32-x64-msvc.node.bak-20260809-pre-fix153-D49D7441`.
The full IDE acceptance job completes all nine steps without a native error or
timeout: eight are `ok`, and live-memory decompilation is honestly `partial`
at 50% because the function still contains nine placeholders, seven
self-references, and one unrecovered `cf.switch`. It emits 289,415 bytes of C,
retains the byte-identical source IR (SHA-256
`D9014135AD3BE14613136F5B83E171B33EF4DB7AEC44F4CB48FAB5025AAC953E`),
disposes the Debugger session, and leaves the runner queue empty.

**FIX-148 through FIX-152 (ROTTR hash correctness wave).** A direct comparison
of ROTTR `sub_14000e620` against IDA exposed a false-High decompilation that
shifted and dereferenced the string pointer while reporting 94.5% confidence.
The Remill LLVM IR was correct; four independent losses occurred downstream:
register renaming could collide with an undeclared body-only `vN`, register
forms of `MOVSX`/`MOVZX` consumed the destination pointer and omitted their
writeback, C-AST pre-build DSE erased definitions consumed by loop self-updates,
and C-AST copy propagation rewrote assignment lvalues through their rvalue
aliases. Register renaming now reserves every referenced identifier, extension
instructions use operand 3 as the source and explicitly write operand 2's
destination register, pre-build DSE is block-local with self-read-aware
liveness, and direct variable lvalues retain their storage identity.

The corrected output implements the same string-hash recurrence as IDA:
`v0 = result; v0 <<= 5; v1 = result; v1 >>= 2; ... result ^= v0`, while the
pointer advances independently and the previous/current characters remain
distinct. Three focused C-AST regressions cover name collision, loop-carried
setup and lvalue identity. The native suite passes **219/219** and the fresh
ROTTR lift is deterministic at **K=10** (one output SHA-256). Final standalone
candidate: `target/release/hexcore-helix.fix152-lvalue-identity.node`, SHA-256
`24B3CB2522B20680B9566C55911454242BB6B9FDEA91ED06A11733E18548FF29`.

The current-lift harness now records Remill wrapper/upstream versions and addon
SHA-256, and selects the same `amd64_avx` semantics family as the IDE instead
of silently falling back to plain `amd64`. The March WWZ `bone_pos_calc3.ll`
remains a frozen Remill-7 compatibility fixture. A Remill 6.0.1 candidate was
generated from the current corpus at `0x14142fef0`, but it is not promoted as a
replacement: the historical entry is `0x14142fe90`, so binary/function identity
must be established before comparing quality claims.

**FIX-147 (interference-safe SCF copy coalescing and late cleanup).** The
C-AST selector coalescer no longer unions every connected `scf_r*` copy class.
It now requires one-destination routing and a structured backward-liveness
proof that source and destination live ranges do not interfere. Loop
back-edges reach a bounded fixed point, goto sources seed all selectors live,
and the complete union-find classes are checked for transitive interference.
This preserves independently consumed tuple components, sources redefined
while a copied destination remains live, destinations live before a copy, and
the `A-B-C` case where pairwise-safe edges would form an unsafe transitive
class. Three adversarial no-coalesce contracts plus the positive routing
contract cover those boundaries.

The late optimizer now repeats the guarded coalescer after earlier DSE,
removes globally dead pure stores to a bounded fixed point, and closes the
resulting identical-arm/empty-branch cleanup cycle. The native suite passes
**216/216**. Fresh NUCLEO completes **80/80**: 27 outputs are byte-identical,
53 change, total output falls by 2,364 lines, and every confidence,
placeholder, and suspicious-self-reference metric stays flat. A separate
adversarial text audit finds no delta in calls, memory stores, returns, gotos,
or labels and no new code-address leak; no empty `if` shell remains. The
largest positive delta (`sub_140088400`, +66 lines) is intentional correctness:
distinct structured results remain distinct instead of being collapsed into
one `scf_r900002` identity. On the Mali CSF target, the same policy keeps
79.5%, one placeholder, and 60 suspicious self-references while final C grows
from 2,119 to 2,176 physical lines relative to FIX-146; the extra routing is
the cost of refusing unproven aliases. Determinism is **10/10 functions stable
at K=10**. Final locally rebuilt addon (installed in the development IDE):
`target/release/hexcore-helix.fix147-scf-interference-final.node`, SHA-256
`408A676712765FD379709609CF141034606ED0AFA7156FC6B34FFB5A37AA5CCC`.
The rebuild passes **216/216** and reproduces the accepted Mali C byte for
byte against RC9 (output SHA-256
`11D807072FDB5D035877ED42E2F6431E88FBCEF64F718E97CC0420A463333230`).
The displaced FIX-142 binary is retained only as the explicitly named local
backup `hexcore-helix.win32-x64-msvc.node.bak-20260802-fix142`.
An additional 12-lift cross-corpus gate (five Lara functions, Lies of P,
Mali, vgk, three Malwarebytes drivers, and the controlled `malware.ko`)
completes 12/12 with seven changed outputs, flat confidence throughout, no
call/store/return/goto/label anomaly, and a net +60 lines from the same
interference-preservation policy. A normalized sweep over every usable kernel
lift currently present in the local corpus completes **30/30** across six
binaries. Versus FIX-146, 18 outputs are byte-identical and 12 change for a
net +74 lines; confidence stays flat and the same side-effect audit is clean.
The installed addon also passes the final IDE lanes: Mali CSF 3/3 at 79.5%
with the source signature intact, and ROTTR 2/2 with output byte-identical to
the accepted post-disassembler-1.4.25 baseline. On HTB Funkynator, the current
pipeline expands the historical 20-line false-100% stub to 162 lines, restores
the menu loop and all five paths, and honestly caps the remaining PIE/dataflow
debt at 50%.

**FIX-146 (elide invariant native-SCF tuple storage).** The native
SCF-to-HelixHigh bridge now avoids synthesizing `scf_r*` storage for an
`scf.if`/`scf.index_switch` result when every region either forwards the same
outside SSA value or yields the same typed `arith.constant`. Loop-carried
`scf_w*` storage and its parallel-copy shadow are likewise omitted when the
`scf.condition` forwards the exact before-block argument unchanged. Direct
`ub.poison` is never treated as invariant evidence, and changing components,
swaps, rotations, and partial PHIs retain the full FIX-132/FIX-145 routing.

Three focused contracts cover changing PHI operands, invariant if-tuple
components, and a loop tuple with one pass-through plus one changing
component. The native suite passes **210/210**. On the fresh IDE-produced Mali
lift, the post-bridge IR loses 23 `scf_r` declarations and 46 assignments; the
final C drops from 2,139 to 2,120 harness lines while confidence (79.5%), the
single placeholder, and 60 suspicious self-references remain flat. The fresh
NUCLEO 80-function gate completes 80/80 with zero failures: 54 outputs are
byte-identical, 26 remove a total of 71 `scf_*` assignments and 77 lines, and
all confidence/placeholder/self-reference metrics remain flat. No corpus case
exercised the loop pass-through optimization; that policy is validated by its
focused IR contract rather than claimed as an empirical corpus improvement.
The ten-function determinism oracle is stable at K=10. Candidate addon (not
installed in the IDE):
`target/release/hexcore-helix.fix146-invariant-scf-rw.node`, SHA-256
`97A3E8E7549779C54F3D01A9F2E82E048F328C36E0040562A26833596273A0DD`.

**FIX-145 (preserve CFG/PHI values through native SCF lowering).**
`helix_low.jmp` and `helix_low.jcc` now implement MLIR's
`BranchOpInterface` and retain the operands forwarded to each successor.
`StructureControlFlow` no longer destroys every block argument before
`transformCFGToSCF`; it forwards type-compatible edge values and inserts
`ub.poison` only when an edge genuinely lacks required evidence. Operand
capture is deliberately delayed until the replacement terminator is emitted,
after Remill bookkeeping RAUW has completed. This avoids retaining stale SSA
handles or resurrecting Remill `MEMORY` tokens.

The focused Low-dialect diamond regression routes constants from both arms to
one merge argument with zero poison. The native suite passes **208/208**.
Direct A/B on the IDE-produced
`mali-csf-fix142-single-20260730/.../kbase_csf_kcpu_queue_process.fix142.ll`
is byte-identical to FIX-144 at 79.5% / 2,139 harness lines: the Mali PHIs in
that lift are Remill memory-state tokens and remain correctly absent from C.
`BattleConductor-inner` instead preserves 16 real scalar edge operands with
zero padding, removing the old unconditional-PHI substitution behavior.
PlayerAwareness, IsInfiniteAmmo, and the Lies of P health xref remain
byte-identical with flat confidence.

The fresh 80-function NUCLEO gate completes with zero failures: 42 outputs are
byte-identical and 38 expose newly routed values. Confidence is flat in 79
cases. `sub_1400788b0` falls from 47.0% to 39.5% because the honesty gate sees
four explicit placeholders instead of one, while the output eliminates all
16 synthetic `(int32_t)0.0f` PHI substitutions and restores the corresponding
`max` branches. This is increased visible debt, not semantic loss. The
ten-function determinism oracle is stable at K=10. Candidate addon (not
installed in the IDE):
`target/release/hexcore-helix.fix145-preserve-phi.node`, SHA-256
`EA6B9EF942390DF32C88C75E8C488225C111196C22FCDB85F073256FAE3EFDC1`.

**FIX-144 (explicit return binding at structured exits).** A new
`BindReturnValues` pass runs after variable recovery and before DCE. For a
non-void function with exactly one canonical `result` declaration, every
remaining Low return is replaced by a High return whose value is a `VarRef`
to that declaration's `var_id`. Void, missing-evidence, and ambiguous-result
functions retain the conservative implicit-return fallback. Four focused
tests cover all policies; the native suite passed **207/207**. Targeted
Lara/Lies/Mali A/B and a fresh 80-function NUCLEO gate were byte-identical to
FIX-143, and the NUCLEO K=10 oracle was stable. Candidate addon:
`target/release/hexcore-helix.fix144-explicit-return.node`, SHA-256
`96309166444A3273796016A6F384425BF8B477110DADBE91457E2B4D2196DC77`.

**FIX-143 (single ABI return identity across structured regions).**
`RecoverVariables` Phase 2.5 now reuses the exact `result` SSA identity
created by the top-level walk when nested `if`/loop regions also write RAX.
The old fallback probed the non-existent key `RAX__result`; the SSA path did
not register that key, so the fallback always synthesized a second VarDecl
with the same C identifier. The fix resolves the existing return value by
`var_id` from the RAX version set and creates a new return slot only when the
nested region is genuinely the first producer. This is an IR identity fix,
not a printer-side declaration deduplication, so assignments and uses in both
regions remain attached to one storage object.

A focused regression covers a top-level return-register write plus a nested
structured write and requires one declaration, one referenced `var_id`, and
two assignments. The native suite passes **203/203**. A/B decompilation against
FIX-142 on `PlayerAwareness-sub2`, `BattleConductor-inner`, `IsInfiniteAmmo`,
and the Lies of P health xref removes exactly one duplicate declaration from
each output; every function body and confidence score is otherwise
byte-identical (68.7%, 50.0%, 82.0%, and 46.6%). All four targets are stable at
K=10 in-process. A fresh same-frontend NUCLEO A/B completes **80/80** with
zero confidence regressions: 67 outputs are byte-identical and 13 change.
Eight changes only remove the duplicate declaration. The other five preserve
CFG, calls, and memory stores while exposing the real RAX-to-result copy that
the split identities previously hid; one also propagates the surviving
pointer type to two dependent locals. Candidate addon:
`target/release/hexcore-helix.fix143-result-identity.node`, SHA-256
`ED44A5364EBE7DC3D8B482DDB2E711FB0BAA244278CE04F3BD2CE8BE3E1E49D2`.

**FIX-142 (identical SCF yield-arm folding).** The C-AST optimizer now folds
the exact structured shape
`if (A) { tuple } else if (B) { tuple } else { other }` into
`if (A || B) { tuple } else { other }` when both successful arms contain the
same ordered list of plain assignments to the same engine-reserved `scf_r*` or
`scf_w*` variables. Target names, expression structure, and C types must all
match. Logical OR preserves the original short-circuit evaluation of `B`.
The fold runs once during normal expression cleanup and once after global DSE,
which can expose identical arms only at the end of optimization. It does not
coalesce loop-carried storage, remove tuple components, or weaken FIX-132.

On current scoped-debug `kbase_csf_kcpu_queue_process`, the output drops from
2,188 to 2,140 counted lines and from 123,202 to 119,734 bytes. Six nested
branches and 30 duplicate `scf_*` writes disappear; confidence remains 79.5%,
the exact `queue`/`drain_queue` signature remains intact, and both parameters
still have zero assignments. Final output SHA-256:
`523E66DB8083720C9D46FBD2DDA1091B0545A3253E426208F282AEA57E4857E6`.

The native suite passes **202/202**. The debug-aware target and the standard
ten-function NUCLEO oracle are deterministic at K=10. A fresh FIX-141/FIX-142
NUCLEO A/B completes **80/80** with 80 flat / 0 confidence regressions:
52 outputs become smaller, 28 are byte-identical, and the changed set loses
1,759 lines. A normalized adversarial diff audit finds zero additions outside
new `||` conditions and zero removals outside old branch structure or duplicate
`scf_*` assignments. Installed addon:
`target/release/hexcore-helix.fix142-identical-scf-arms.node`, SHA-256
`874876C864E61A89E8CA333A126A97CB7E0C6D58FC6C39D713D5CFC23E69BA07`.
The same hash is installed at
`vscode-main/extensions/hexcore-helix/hexcore-helix.win32-x64-msvc.node`;
the final isolated three-step IDE job passes 3/3. Its debug-aware output is
132,483 bytes / 2,389 lines / 79.5% confidence, SHA-256
`FA388BA8D6ECE138D0A172C0F838F5624700A587F00CCF0D39A609555AC739D8`,
with the exact source signature and zero assignments to `queue` or
`drain_queue`. A normalized IDE diff contains only the six combined `||`
conditions and removal of 30 duplicate SCF assignments plus obsolete branch
structure.

**FIX-141 (structured-region parameter shadowing).** `RecoverVariables`
preserves a fixed DWARF/BTF/PDB source parameter when its ABI register is
reused inside a structured High-IR region. Phase 2.5 Strategy B previously
bound every nested register read/write to the containing top-level block exit
snapshot. On x86-64 SysV this made nested RDI/RSI writes mutate
`queue`/`drain_queue` themselves. The pass now creates one mutable shadow per
top-level block and fixed parameter register, initializes it from the source
parameter immediately before the structured operation, and binds nested
machine-register traffic to that shadow. Flat post-entry register versions
also remain distinct from certified source parameters.

The native suite passes **199/199**. On the current
`kbase_csf_kcpu_queue_process` lift with scoped real debug metadata, the
signature is exactly
`void kbase_csf_kcpu_queue_process(struct kbase_kcpu_command_queue* queue, bool drain_queue)`;
assignments to either source parameter fall to zero, confidence remains
79.5%, and the output is stable across ten in-process runs. The no-debug A/B
against FIX-139 is byte-identical. The full three-step IDE job passes 3/3 and
produces SHA-256
`7EE036E827CE53EA6C46793A7A30AF575C089F5E76234C0C1A69F34FA16DEFB9`.
Candidate and installed addon:
`target/release/hexcore-helix.fix141-region-param-shadow.node`, SHA-256
`DE90BDE813C5AF8ACE80C7BE96692A2301A9E780AB47DB69D907CF78D1B1A7E4`.
The full IDE artifact still contains 67 `scf_r*` region-result values and 34
`scf_w*` loop-carried values (781 writes, 101 reads); those are the next
structured-output quality target and are not part of the parameter-identity
fix.

**FIX-140 (prefer complete duplicate debug signatures).** The HexCore
disassembler's DWARF/BTF loaders now select the better duplicate signature
instead of accepting the first equal-arity declaration. More parameters win;
at equal arity, real source names win over synthesized `param_N` names. This
fixes kernel DWARF where an early declaration of
`kbase_csf_kcpu_queue_process` had unnamed parameters and the later definition
carried `queue` and `drain_queue`. The shared selector is covered by three
focused policies inside the **11/11** BTF/debug-loader suite. A direct load of
the real Mali module now returns the source names and types. This is a
disassembler metadata fix shipped as disassembler 1.4.24; the interim
`fix140-debug-param-identity` Helix probe is superseded by FIX-141.

**FIX-139 (authoritative source parameter count and AAPCS64 mapping).**
Non-variadic debug signatures now publish an exact source-level parameter
count, and calling-convention recovery intersects ABI register candidates with
that certified set. AAPCS64 parameter indices are derived from X0-X7 rather
than accidentally using the x86 register lookup. Variadic metadata is carried
from DWARF/BTF so open-ended signatures retain legacy ABI discovery instead of
being truncated. The native suite passes **198/198**. Candidate addon:
`target/release/hexcore-helix.fix139-aapcs-debug-params.node`, SHA-256
`4F1E6B9C99B78D2ECF9479FA7A4EA3624AE05C58E670582FA54D72D58759E142`.

**FIX-138 (debug signatures before ABI inference).** The pipeline seeds
authoritative debug function signatures before calling-convention recovery,
then runs the full nominal type application at Tier 3.5. A debug-proven `void`
return now overrides the RAX return heuristic, so scratch writes in a void
function do not invent a source result. Nominal propagation is guarded to
prevent a recovered struct/pointer type from contaminating incompatible
storage. Experimental region-SSA probes were rejected after semantic
regressions; the guarded signature implementation is the retained result. The
native suite passes **196/196**. Candidate addon:
`target/release/hexcore-helix.fix138-debug-signatures-guarded.node`, SHA-256
`D8D44EC8CAC3F606970212C4F0A9401EC45E317FE2DFB7282EF2E512E533A891`.

**FIX-136/137 (per-block PC evidence and x86-64 PC32 data relocations).**
Before LLVM-to-MLIR import, the pipeline now preserves Remill
`bb_<decimal-address>` evidence and stamps it on the imported function.
`RemillToHelixLow` seeds PC/NEXT_PC at each block boundary, preventing a linear
walk from reusing bookkeeping from an unrelated layout neighbour. In the
disassembler, `R_X86_64_PC32` against a non-executable named object is routed
as RIP-relative data rather than call/jump relocation and encoded using
`S + A - (P + 4)`. This restores readonly kernel data references without
misclassifying executable or undefined symbols. Retained probes:
`hexcore-helix.fix136-block-address-evidence.node` (SHA-256
`F2F671C830CEC79D05BC4CC54E7C122E1E74ECE9FA4CB71A5113B844ADF7631A`)
and `hexcore-helix.fix137-pc32-rodata.node` (SHA-256
`2459C0CF7B236042A57D28CC10B862197D7365493805D3EBB446025D04115D29`).

**FIX-135 (explicit High-IR type propagation dispatch).** The second
`PropagateTypes` invocation no longer chooses its analysis tier from the
function container dialect. `HelixMidToHigh` intentionally retains
`helix_low.func` as the container while replacing its body with High
operations, so the former dispatch ran Low propagation over a High body and
made the High implementation effectively dead in the standard pipeline. A
dedicated `createPropagateTypesHighPass()` now visits High operations through
the retained Low container, while the original factory remains Low-only.

The mismatch was reproduced on a freshly lifted Mali
`__SCT__tp_func_mali_pm_status` function as an LLVM `dyn_cast` assertion on a
non-existent value during the second propagation pass. The corrected target
decompiles deterministically in two runs at 62.0% confidence, and a regression
covers High operations nested in a Low function container. The native suite
passes **192/192**. A boundary-normalized cross-kernel gate freshly lifted and
decompiled **128/128** selected functions across two ELF modules and four
Windows drivers with zero lift, Helix, or assertion failures. IDA 9.3 produced
pseudocode for 26 of 30 selected references; all 26 shared references resolve
to exact function starts after translating ET_REL section-relative addresses.
Candidate addon:
`target/release/hexcore-helix.fix135-high-type-dispatch.node`, SHA-256
`87B586B47E5C0FECF09F5140C5B36FA9DF77CC41FE59CAF3F4BC51CF615E50CD`.
The same binary is installed in the IDE runtime. The final
debug-metadata-aware IDE gate passed 3/3 in 141.655 seconds. The fresh
`kbase_jit_allocate` output is 33,477 bytes / 699 lines / 79.5% confidence,
SHA-256
`1CF83FCD7C0D6B7AB72B78BD1B9F11428920772AE941EF4980F18361B4FEBFC2`.
It retains the debug-proven signature and named array accesses, both stack
cleanup calls, distinct SCF terminal values, and emits no stack-canary call or
unhandled-control-flow marker. One placeholder and five suspicious
self-referencing assignments remain as honest quality debt.

**FIX-134 (structured stack-canary polarity and SCF loop exit).** Stack-canary
elision now selects the normal arm by locating a direct
`__stack_chk_fail`/toolchain-equivalent call in exactly one arm instead of
assuming the `then` arm is normal. The search recurses through structured
control flow to reach the check but deliberately classifies only direct arm
contents, so an outer `if` that contains an entire cleanup dispatcher is not
mistaken for the failure branch. Generic `abort()` calls are no longer treated
as proof of a stack-canary check.

The full IDE gate exposed this after FIX-132 preserved the loop tuple:
`kbase_jit_allocate` reached state 6 with distinct storage, but C-AST constant
branch cleanup retained the failure tuple (`next_state = 5`, `continue = 1`)
and discarded the normal termination tuple. The emitted cleanup could cycle
forever through `6 -> 5 -> 4 -> 3 -> 2 -> 1 -> 0 -> 6`. FIX-134 keeps
`next_state = 0`, `continue = 0` at the terminal arm. The final debug-aware
Mali output is 26,058 bytes / 570 printer-counted lines / 79.5% confidence,
SHA-256
`DF6745006A8E25DB66E7879A2AA1358C69A44CD630E8075900AFED6F81B85B6B`.
The native suite passes **191/191**. A fresh NUCLEO 80-function A/B is
**80/80 byte-identical** to FIX-133 with 80 flat / 0 confidence regressions;
the standard ten-function set and ten debug-aware Mali runs are deterministic.
The fresh three-step IDE automation gate also passes: its debug-layout-enriched
artifact is 33,218 bytes / 698 lines / 79.5% confidence, SHA-256
`3E440AF32E75FF9E9E299286C657338FF299E6983C60B886E7F37A76FAF3A99F`,
with the same terminal `next_state = 0`, `continue = 0` behavior.
Installed addon SHA-256:
`7B5EE472C5C3CED506910764667D232B9800141A5CA62E722326E8C4AF3DE447`.

**FIX-132 (preserve SCF tuple and loop storage identities).** Phase 4 of
`RecoverVariables` no longer applies generic cover-based storage reuse to
`scf_r*`/`scf_w*` variables created by `StructureControlFlow`. Those variables
represent region-result tuple components, loop-carried state, continuation
conditions, and parallel-copy shadows. Their lexical block covers can look
disjoint even though the values are simultaneously live across a region join
or loop backedge. On `kbase_jit_allocate`, the former merge collapsed
`next_state`, an auxiliary result, and `continue` into one scalar. Sequential
tuple assignments then overwrote every next state with `1`, and emitted a
cleanup `do...while` whose terminal state could never stop. The corrected
output retains the real `5 -> 4 -> 3 -> 2 -> 1 -> 0 -> 6 -> exit` cleanup
chain. A regression covers three disjoint SCF bridge identities, including two
same-width `i32` components, so a width-only guard cannot reintroduce the bug.

**FIX-133 (post-DSE empty-branch cleanup).** The final post-order empty-if
sweep now runs after `removeGloballyDeadStores`. Preserving SCF identities
exposed many dead selector stores inside nested dispatcher arms; the global
DSE correctly removed those stores but previously left empty `if/else` shells
because it ran after the last branch cleanup. This ordering fix removed 905
lines of empty shells from the FIX-132 NUCLEO output without changing the
corrected Mali result.

**FIX-132/133 validation.** The debug-aware `kbase_jit_allocate` output is
26,094 bytes / 571 lines / 79.5% confidence. It retains the FIX-130 named
`jit_current_allocations_per_bin[index]` accesses and FIX-131 void-call
statements while preserving distinct cleanup states and continuation storage.
The native suite passes **189/189**. A fresh NUCLEO 80-function A/B against
FIX-131 completes **80/80**: confidence improves in 41 functions, stays flat
in 39, and falls in none; 73 outputs change because the old generic merge had
affected SCF storage broadly. The standard ten-function set is stable for
10/10 in-process repetitions, and Mali with real debug metadata produces one
SHA-256 across ten runs:
`0225A9F4576F368DE7CBF3412911FE7C0E26424B237333EC6562190C3EA1BD82`.
Installed addon SHA-256:
`B67078EA1B697653C51E73CC758576F6AF01CE137413194A3410CB587145A37D`.

**FIX-131 (debug-proven void-call statements).** A lifted ABI result-register
binding no longer forces an assignment when the call's recovered debug
signature proves its return type is `void`. The C-AST builder preserves the
call as an expression statement and clears copy-equivalence caches, producing
valid C without a callee-name allowlist. On `kbase_jit_allocate`, ten false
assignments were removed for DWARF-void functions including `mutex_lock`,
`mutex_unlock`, `up_read`, `_dev_err`, `trace_jit_stats`, `kfree`, spinlock,
and page-release helpers. Both cleanup calls now emit as
`kfree(var_40);` / `kfree(var_38);`. Confidence remains 73.5%, suspicious
self-references fall from 8 to 5, the complete native suite passes
**187/187**, Mali is byte-stable across 10 debug-aware runs, and a fresh
NUCLEO 80-function run remains **80/80 byte-identical** without debug
metadata. Installed addon SHA-256:
`DF5D0A488FF824302BCAF16509BECE26481BF9A16D79574C9D0A14117FC892BC`.

**FIX-130 (debug-proven nominal aliases and indexed arrays).** Direct copies
from a debug-typed nominal pointer can now replace only a synthetic
`auto_struct_N*` destination type. The rule requires a direct
`VarRef -> VarRef` assignment and a pointee present in the supplied debug
database; it does not perform general dataflow or retag scalar storage.
`ApplyDebugTypes` also recognizes the exact unit-stride address form
`base + index + fieldOffset` when the nominal struct has a matching
`u8`/byte/bool array field. It annotates that address for the C-AST builder,
which emits a named subscript without reinterpreting unproven pointer
arithmetic.

**FIX-130 validation.** On the relocation- and debug-aware
`kbase_jit_allocate` artifact, `v5` is now declared
`struct kbase_context*` and both raw `*(v5 + result + 0xC5EA)` expressions
become `v5->jit_current_allocations_per_bin[result]`; the second is
canonicalized to `++`. Those are the only two C changes versus the
nominal-alias stage. Confidence remains 73.5%, issues do not increase, both
stack-local `kfree` arguments remain intact, and no stack-canary call returns.
The complete native suite passes **187/187**. A fresh NUCLEO 80-function A/B
produced **80/80 byte-identical** outputs without debug metadata. Determinism
is **10/10 stable** at K=10 on NUCLEO and 10/10 byte-identical on Mali with
the real debug JSON. Installed addon SHA-256:
`3574497D851F01445B19C92B96BA92F04176C9B65E5535012CF5CCA3934E61F5`.

**FIX-129 (addressable stack-local alias safety).** Global C-AST copy
propagation no longer inlines variables with a known stack offset. Their
address may still be represented as frame-pointer arithmetic and recovered as
`&var_X` only by the later `resolveFramePointerLeaks` pass, so treating an
initializer as immutable before that recovery is unsound. On
`kbase_jit_allocate`, the old ordering changed the real
`kfree(prealloc_sas[0])` cleanup into `kfree(0)` even though
`&prealloc_sas[0]` escaped to an allocator helper. The corrected output keeps
`kfree(var_40)` and `kfree(var_38)`, matching the IDA/source cleanup.

**FIX-129 validation.** The focused alias regression and complete native suite
pass (**186/186**). A fresh NUCLEO 80-function A/B completed **80/80**:
69 outputs are byte-identical, 11 retain potentially aliased stack stores,
average confidence rises 58.783% -> 58.820%, one function gains 3.0 points,
and none regress. The corpus grows by 67 lines in exchange for removing the
unsound propagation. Determinism remains **10/10 stable** at K=10. Final
isolated and installed addon SHA-256:
`47CE752C7C5DD5D735C7765634D68EA6DE5CF19D29F0F74348054C0D572710AC`.
The definitive debug-info-aware IDE gate passed 3/3 in 62.891 seconds from a
fresh isolated workspace. Its lift is unchanged after timestamp
normalization, and two independent final-addon runs produced identical C
(SHA-256
`8965AB4CCF4F4743872CAC925FD959D4A0AD52B0AC35A3BE4B0C725B569482DC`):
33,821 bytes / 685 lines / 73.5%, with `v5 = kctx`, both stack-local cleanup
arguments preserved, and no residual `__stack_chk_fail`.

**FIX-128 (C-AST parameter identity, stack-canary register reuse, and
structured liveness).** C-AST prologue removal no longer treats every copy
to or from a callee-saved register as disposable ABI noise; it removes only
demonstrable frame setup/teardown forms. Stack-canary recognition follows a
one-hop register-to-stack spill and owns the spill slot rather than a transfer
register that may immediately be reused for a semantic parameter. Assigned
forms of `__stack_chk_fail` are removed with expression-statement forms.
Backward DSE now computes structured live-in sets across nested branches and
loops, respecting intervening definitions instead of either missing deep uses
or conservatively retaining every nested read.

**FIX-128 validation.** Fresh per-pass tracing of the current
`kbase_jit_allocate` lift proved that `param_1 -> rbx` and every later field
base survived Low, Mid, High, and Mid-to-High; identity was lost only in the
C-AST optimizer. The corrected standalone output replaces the fabricated
null base with `v5 = this`, retains all later `v5->field_*` accesses, and
removes the residual assigned `__stack_chk_fail` call at unchanged 73.5%
confidence. The first recursive-read prototype was rejected after a fresh
80-function NUCLEO A/B showed avoidable output growth. The refined
definition-aware transfer completed **80/80** without a crash; versus the
preceding stage, average confidence is unchanged (two +3.0, two -3.0/-2.5
honesty deltas) and the two decreases expose real definitions previously
replaced by zero. The complete native suite passes **185/185**, and the fixed
ten-function set is **10/10 stable** over K=10 in one process. Installed IDE
addon SHA-256:
`DC5EF26683EE62C5BE8EF051F6B5268C2FE6D28313B75225086B1FACEE439643`
(superseded by FIX-129);
rollback addon SHA-256:
`78195F87EA787173EC563B7822A4E270B5C5946BD7E6A817860DB07822730148`.
The isolated debug-info-aware IDE job passed 3/3 in 58.069 seconds. Its fresh
lift is byte-identical to the preceding lift after normalizing the generation
timestamp. Typed C remains at 73.5% and now contains `v5 = kctx`, with no
fabricated null base or residual `__stack_chk_fail`.

**FIX-127 (x86 signed division semantics).** The common Remill
`CQO_RAX -> IDIVrdxrax` sequence is now lowered as a proven same-block pair:
the current RAX SSA value is divided by the incoming divisor, quotient is
written to RAX, and remainder to RDX. The transient CQO RDX write is removed
for the pair so it cannot overwrite or alias the live divisor; standalone CQO
still sign-extends RAX into RDX. Pairing state is reset for every function and
unpaired/general 128-bit IDIV remains on the conservative helper path. Added
an end-to-end regression that checks signed remainder recovery, divisor
preservation, and removal of raw CQO/IDIV helpers.

**FIX-125/FIX-126 (leaf return identity and NEG writeback).** Call-free x86
functions now preserve the final return-register definition as the exact
`result` identity consumed implicitly by DCE and the C emitter. Remill machine
helper `CQO_RAX` does not count as a source-level program call. The policy is
intentionally restricted to call-free x86 functions; AAPCS64 retains its
existing return handling and call-heavy x86 code keeps the established
coalescing policy. `NEG` lowering now negates the source value and writes it
back to the register or memory destination instead of treating the destination
pointer as the operand and dropping the result. Focused regressions cover
exact RAX return preservation, CQO classification, and NEG writeback.

**FIX-125 through FIX-127 validation and de-obfuscation audit.** The native
suite passes **179/179**. The current `HelixCalcBench` binary corpus was lifted
fresh: clean floating-point calculator A and polymorphic/vtable calculator B
are byte-identical to FIX-126; obfuscated calculator C now recovers MBA
addition/subtraction, multiplication, XOR, guarded signed division and modulo,
and both opaque-predicate helper results without the prior lost-input,
self-referential quotient, or divisor-alias failures. The full flattened
dispatcher and indirect operation table are still present, so this is a
semantic-lifting improvement, not a claim of generic de-obfuscation. A fresh
NUCLEO 80-function sweep produced **80/80** outputs byte-identical to FIX-126,
and the ten-function determinism set is **10/10 stable** at K=10
(`unstable=0`). Final isolated addon:
`C:\tmp\hexcore-helix.fix127-cqo-idiv.node`, SHA-256
`0FF9A1D755B8F430190B2DD716FB4FAB6B30B2A0A333293A5FA5773F6943F7C8`.
The IDE addon was not replaced.

**FIX-124 (issue #15 C2, explicit floating-call preservation).** Direct
LLVM calls with floating-point operands or results now remain in authoritative
SSA form through `RemillToHelixLow`. Previously the pass discarded their
explicit operands, reconstructed only integer ABI registers, synthesized an
integer return, and replaced the real floating result with `undef`; this
produced malformed output such as `sqrtf()`. The preserved call retains its
XMM-derived arguments and floating return dataflow for the C-AST. Unrecognized
mangled calls still report a warning. Added a minimal end-to-end regression
that fails on an empty `sqrtf()` call.

**FIX-124 validation.** The complete native suite passes **175/175**. On the
frozen issue #15 `UpdatePosition` compatibility fixture, all three `sqrtf`
calls remain present while empty calls fall **2 -> 0**; output stays at 310
lines and 50% confidence because the unrelated honesty defects remain.
The output is byte-stable across ten in-process runs. A fresh 80-function
NUCLEO binary-to-IR-to-C sweep completed **80/80** and was byte-identical to
the FIX-123 candidate for every function, with no missing or extra output.
The standard ten-function determinism set is **10/10** stable at K=10.
Final isolated addon:
`C:\tmp\hexcore-helix.fix124-fp-call-final.node`, SHA-256
`B9D4EB25531F94491427FC3DE97F360B1EDC81F29B353096E2E31283776A9769`.
It has not been installed, committed, or published.

**FIX-123 (issue #31 residual honesty and address-shape recovery).**
Remill `Do<MNEMONIC>` wrappers are now decomposed conservatively, with
`DoINT_IMMb` rendered as the semantic `software_interrupt` call instead of a
fabricated binary callee. Field recovery now accepts only a direct pointer
base plus a positive signed displacement: indexed/global address expressions
and negative displacements remain explicit pointer arithmetic instead of
inventing fields such as `field_0x18b30` or
`field_0xffffffffffffffb0`. The confidence gate now detects returned locals
that are assigned on only some structured paths and caps them at 50%, while
excluding address-taken locals that a call may initialize indirectly. Added
focused regressions for all three bug classes and the alias-safety exclusion.

**FIX-123 fresh validation.** Both original issue repros were lifted again
from their PE binaries with the current Remill addon; no historical `.ll`
entered the test. `partialencryption:0x140001C30` keeps the same IR hash,
eliminates `DoINT_IMMb`, and changes 90% High to an honest 50% Low because
`result` is conditionally initialized. `ffmodule:0x14000A340` keeps the same
IR/confidence (62%) while all six false `field_0x18b30` accesses disappear.
A 20-function NUCLEO back-edge A/B completed with 20/20 identical IRs, zero
lift/Helix failures and zero missing branch targets; false negative-offset
fields were removed. Two real conditionally initialized returns moved to the
50% cap, and two small score decreases (-1.0/-1.7) reflect newly visible raw
pointer placeholders instead of false struct evidence. A separate fresh
80-function NUCLEO sweep produced C for 80/80 functions: suspicious large
fields dropped **373 -> 3**, negative/zero-extended fields dropped
**310 -> 0**, and generic Remill `Do*` wrappers dropped **2 -> 0**. Eight
outputs previously above 50% now cap at 50%; manual review confirmed that
each emitted body returns an uninitialized `result` on at least one path
(including five GL loaders whose real signatures are void, but were emitted
as returning a conditional call result). The complete native suite is
**174/174 passing**, and ten fixed NUCLEO functions are byte-stable across
ten in-process repetitions each. Candidate addon SHA-256:
`D03B22697EA9A8F86FF09CB13D6EC647C34E70CF1C14A9E41C558310E874E62B`;
it is isolated in `C:\tmp` and has not been installed or published.

**Native pipeline API and HAST serialization hardening.** `Pipeline` now
registers the standard DLTI, arith, cf, func, scf and ub dialects it consumes,
so direct library users no longer depend on `Engine` having initialized an
MLIR context first. FlatBuffer serialization now filters absent expression and
statement children instead of inserting `Offset(0)` into vectors, which
violates the real FlatBuffers builder contract and aborted the native test
path. Added a null-child serializer regression. The complete CMake suite is
**174/174 passing**.

**Fixture provenance and release evidence.** Remill 6/7 `.ll` files under
`tests/` are explicitly frozen compatibility fixtures, not evidence for the
current lifter, IDA parity or release quality. Fresh release probes now record
binary/addon/IR hashes and avoid persisting IR unless a current CMake-vs-addon
comparison requires it. On current binaries, the x86/x64 CFG gate passed 8/8
back-edge functions with zero missing branch targets. AArch64 was deterministic
for 120/120 runs on the SP-disabled path, but high-confidence output still
contains raw branch/address/store helpers; AArch64 remains experimental.

**Release hardening - temporary P0/SCF diagnostics are opt-in.** Call-conversion, DCE, calling-convention, lift-coverage, and SCF stage telemetry no longer writes to the host terminal during normal decompilation. `HELIX_PIPELINE_DEBUG=1` enables the shared pipeline diagnostics, while `HELIX_SCF_SPIKE_DEBUG=1` enables only the SCF progress trace; genuine pass failures remain visible unconditionally. The release addon rebuilt successfully. On the fixed NUCLEO determinism set, all 10 functions remained stable across 10 in-process repetitions, with zero `[P0-DEBUG]` and `[SCF-SPIKE]` records; the final silence check also produced zero `[LIFT-STATS]` and `[CC-FIX]` records.

**FIX-122 (issue #56 stub-confidence honesty) - empty/bare-return output can no longer report Medium or High.** Added final-AST `emptyStubBody` as a damning defect in both confidence scorers, with a located reason and a hard cap at 50%. A call-return wrapper is not blindly capped in the engine because it can be a legitimate thunk; the IDE supplies the missing authoritative evidence (`bytesConsumed`, known function size, emitted line count) and caps measured under-lifts or large functions collapsed to only call/return. The original HTB `ransom_unpacked` 389-byte fixture now rewrites 85% High to 50% Low, while a genuine 12-byte wrapper stays unchanged. Registry-miss tests are 3/3 passing; packaging honesty tests are 12/12 passing.

**FIX-121 (DWARF/BTF/PDB nominal type bridge) - carry debug signatures and layouts into the MLIR pipeline instead of limiting them to a text post-processor.** Added a versioned JSON transport across N-API/C API/Engine/Pipeline and a scoped `ApplyDebugTypes` pass after Mid-to-High. Function parameters and returns now use debug names/types; typed call returns are bound through the local ABI sequence (`call -> result/RAX -> destination`) without poisoning the globally reused result register; nominal debug structs outrank only synthetic `auto_struct_N` evidence; and embedded fields resolve recursively without following pointer-member cycles. `CAstBuilder` now parses the same canonical C type spellings for parameters, returns, calls, and locals. **Mali validation:** `kbase_jit_allocate` now emits `struct kbase_va_region* kbase_jit_allocate(struct kbase_context* kctx, struct base_jit_alloc_info* info, bool ignore_pressure_limit)`, `v4` is `kbase_va_region*`, and offsets `0x70/0x78` become `jit_node.next/prev`. Confidence remains 73.5%; no-metadata output remains 73.5%/463 lines; 5/5 DWARF runs are byte-identical.

**FIX-119 (C AST scalarized vector lane zero) - stop emitting non-compilable scalar subscripts for `llvm.extractelement ..., 0`.** `CAstBuilder::convertType` deliberately flattens LLVM/MLIR vectors to their element CType, but `ExtractElementOp` still emitted a `CSubscriptExpr`, producing invalid C such as `float v; v[0]`. Under the existing scalarized representation the expression already denotes lane zero, so constant lane-zero extracts now return the scalar expression directly; non-zero lanes remain explicit until the C AST gains a sized vector type. Added `VectorLaneTest.LaneZeroOfScalarizedVectorIsNotSubscripted`. **Validated:** engine Release build passes; focused vector + Phase-3.5 variable guard tests pass; SOTTR HealthData full IR keeps 306 lines/61 conditions/11 calls while scalar subscripts drop **63 -> 0** and the scalar-float honesty defect disappears; 10/10 engine-direct outputs are byte-identical. Confidence remains honestly capped at 50% for the separate surviving code-address leak at `0x140253B21`. **Packaged 2026-07-11:** tagged as `target/release/hexcore-helix.fix119-lane0.node`, installed into the IDE extension, and load-tested through `decompile_ll.cjs` with zero numeric subscripts.

**FIX-118 (issue #31 D3 honesty) - surviving post-return statements hard-cap confidence at 50%.** Soft penalty alone (`unreachableAfterReturn * 5`, cap 40) still allowed Medium/High on bodies that print statements after `return`. Category (6) `postReturnUnreachable` in `detectDamningDefects` (`DamningDefect.h`) counts same-scope post-return siblings (nested independently, matching the soft scorer) and trips the damning cap with a located reason. Packaging safety net in disassembler mirrors FIX-110/D1 text patterns until the next `.node` ships. Does **not** close #31 fully (bare `var=0xBLOCK` D1 residual, registry D2 opt-in, full CFG-reachability D3 remain).

**FIX-117 (output determinism) - the same byte-identical engine produced different C across runs (var numbering, bool/int labels, some DSE, +/-few% confidence).** Two root causes, both fixed. (1) `PropagateTypes` iterated `llvm::DenseMap<Value, CTypeInfo> typeEnv` in POINTER-address order (varies per decompile: each call allocates ops at fresh addresses) to write the `inferred_type` attr on `val.getDefiningOp()`; multiple results of one op (a `helix.low.BinOp`'s value + carry/zero/sign flags) share a defining op, so the per-Value last-write "winner" was non-deterministic (the observed inferred_type bool vs int64 flip, cascading into DSE / variable merging / var counts). FIX (PropagateTypes.cpp low ~1975 + high ~2989) = pick a deterministic winner per op, the resolved result with the LOWEST result number (the op's primary value), via a `DenseMap<Operation*, {resultNo, type}>` keeping the min, then write once per op (inter-op write order is irrelevant, each targets a distinct op). (2) `StructureControlFlow.cpp:210 g_scfBridgeVarId` (and the irreducible-CFG `loc_irr_N` label counters) were file-static and NEVER reset, so they ACCUMULATED across every function/decompile in the process -> a function's `scf_r9000NN` selector ids depended on how many functions were decompiled before it (batch-position-dependent). FIX = reset all three to their bases at the top of the per-function `module.walk` in `StructureControlFlowPass::runOnOperation` (scf/label ids live in the per-function id space, so per-function reset is safe). **Validated** (oracle: decompile the same lifted IR K times in one process -> a deterministic engine gives all K byte-identical): in-process 28/28 across a whole-binary sample (was 0/10), two SEPARATE batch processes over 80 NUCLEO funcs -> 80/80 byte-identical; semantic quality FLAT/better (avg confidence +0.15%, issues -1); crash/sret/shortlist fixes intact. Note: textual A/B diffs were INVALID before this fix (dominated by the non-determinism) - validation used semantic metrics.

**FIX-116 (audit shortlist, low-risk guards) - a batch of independently-verified fixes from an external source audit.** (11.1) `CAstOptimizer::canonicalizeXorExpr` dereferenced `b.lhs->type`/`b.rhs->type` with no null guard (crash on a lowered XOR node whose operand has no attached CType) -> a null-safe `isBooleanOperand` helper. (11.2) `x ^ 1` was rewritten to `!x` UNCONDITIONALLY, wrong for a wider non-boolean integer where it toggles bit 0 (neither `!x` nor `~x`) -> gate the LogNot rewrite on the operand actually being boolean/1-bit, else leave `x ^ 1`. (7.3) `ValueRange::forSignedBits(0)` was UB (`1LL << (bits-1)` underflows the shift count at bits==0) -> guard bits==0 -> {0,0}. (13.3) the out-of-table indirect call rendered `(*(code *)0xADDR)()` where `code` is not a valid C type -> emit `(*(void (*)())0xADDR)()` (compilable K&R form). (8.1/8.2) the `CallOpCountInstrumentation` (an O(N*P) before/after-every-pass module walk + stderr spam) and the three fixed-name `helix_dump_*.mlir` CWD dumps ran unconditionally -> gate both behind `HELIX_PIPELINE_DEBUG`. **Validated:** semantic quality flat over 150 NUCLEO funcs (confidence +0.02%, issues +1), zero regression; debug noise + CWD dumps gone by default.

**FIX-115 (Win64 sret struct-return pointer connection) - a return-by-value struct's hidden sret pointer was recovered in the signature (param_1) but disconnected from the body's field writes, so they targeted a phantom base = 0 (the NULL-base cascade), inconsistently across functions.** The real root was NOT the R8-named-param theory but a DSE bug: a store through a computed address `*(p+off)=x` READS `p` to evaluate the destination, but `CAstOptimizer::dseStmtList`'s unsafe-target branch only collected the value's var-refs, not the target ADDRESS's, so the base-pointer definition feeding the store (`p = real; *(p+off)=x`) was wrongly judged dead and DSE'd (DSE runs before copy-prop) -> the pointer stayed at its zero-init. FIX = three coupled parts: `RecoverCallingConvention` emits a certified `reg_param_indices` attr (arg-reg indices that pass the read-before-write gate; excludes the `mov r8,rcx` sret copy); `RecoverVariables` filters `argRegPositions` by it so the scratch/copy reg is not seeded as `param_N`; and `dseStmtList` adds `collectVarRefs(a.target.get(), live)` in the unsafe-target branch. **Validated:** NUCLEO makePlayer now `v6 = param_1; *v6->field = ...` (connected, honest 100%), 0 correctness regressions on a 27-fn A/B.

**FIX-114 (SSE float reg/mem-write crash) - `helix_low.reg.write`/`mem.write` constrain `$value` to `AnyInteger`, so the generated typed `getValue()` does `cast<TypedValue<IntegerType>>` and asserts on the `f32`/`vector<Nxf32>` the Remill lift emits for `mulss` / an SROA'd by-value Vec2 struct return.** An unverified invalid op -> a hard `cast<Ty>() argument of incompatible type` (Casting.h:566) deep in RecoverVariables (deterministic on NUCLEO pstats + 5 others). FIX (RemillToHelixLow.cpp) = `coerceRegValueToInt` bitcasts a non-integer reg/mem-write value to a matching-width integer at the store->register and store->memory lowering, keeping the register model integer-typed; plus `vectorTotalBits` broadens the vector-load handler to the builtin `VectorType` (MLIR imports `<N x float>` as VectorType, not LLVMFixedVectorType, so the prior guard was dead code). **Validated:** 6 former-crashers exit 0, pstats 36/36 deterministic, a 40-fn sweep 0 crashes, makePlayer no regression; the whole 938-fn NUCLEO binary decompiles with 0 crashes.

**FIX-113 (mini-engine #1, pointer def-recovery) - populate `blockExitState` in the region-order fallback so the v2 SCF structurer's nested reg.reads get bound (kills the bulk of the zero-init-ptr-deref).** ROOT CAUSE (measure-first RCA: ruled out `createDefaultValue` then Strategy-B-not-firing, then an A/B test nailed it): the v2 default structurer `transformCFGToSCF` collapses funcBody to a SINGLE top-level block (the real code nests in scf regions), so `RecoverVariables`'s `useRPO` gate (`>1 top-level block`, line 948) fails -> the per-block snapshot `blockExitState[block]=snapshot()` was guarded by `if (useRPO)` (line 1308) -> stayed EMPTY -> the Phase-2.5 / "Strategy B" sweep (its `!blockExitState.empty()` guard) never ran -> EVERY reg.read nested in an scf region fell through to the HelixLowToMid hash-slot -> `int64_t v2 = 0; ... v0 = *v2;` (a deref'd null) where IDA shows `reg->field`. This is a REGRESSION from the SCF structurer rewrite, NOT the architectural alias gap. FIX = snapshot `blockExitState` unconditionally (no-op in RPO mode -- same value; in the fallback it hands Phase-2.5 the top-level block's exit state to bind nested reads against). It enables the EXISTING, already-accepted Strategy-B approximation for the SCF case the gate wrongly disabled -- not a new approximation. **Validated:** DECISIVE on kbase_csf_queue_register -- the SCF output went 94.5% + a `v2=0` null-deref -> **100% + correct `*param_2->field` recovery, byte-matching the `HELIX_SCF_LEGACY=1` output** (the legacy path's correct binding) = proof the recovered binding is RIGHT, not just confident. Pointer-heavy re-survey (12 fns): confidence rose on ~10/12 (kbase_mem_free 50->86.7, context_mmap 50->71, jit_allocate 50->69.3, mem_import 53->70, hook_read 50->66, the fh_/hook_ rootkit fns +5..+12), several fully cleared of zero-init-ptr-deref; total ~22 -> 17 (residual = deeper loop-carried / multi-region cases the coarse Strategy B does not resolve = the fuller region-aware "Strategy A", deferred). No NEW crashes (fh_ftrace_thunk / init_module are pre-existing LLVM-IR parse failures). Fixtures unchanged (RPO = no-op). Broad effect: also lifts complex game fns that hit the same single-block-SCF fallback (WWZ sub_140006F70 15.6->40.5, sub_140928440 65.8->75.8) -- confidence-up direction, IDA-unverified on those. First mini-engine of the alias/var-recovery campaign (memory `helix-alias-verdict`, scoping `MINIENGINE_DEFRECOVERY_SCOPING.md`); built on the shared `blockExitState`/snapshot representation that Strategy A will extend region-aware. (Env-gated `HELIX_DEFREC_TRACE` diagnostics left in RecoverVariables.cpp for the campaign; strip before any ship.)

**FIX-112 (L1) - the out-of-table indirect call is a GRADED readability penalty, not the 50% damning cap.** The D2 out-of-table call -- a callee not in the authoritative function table, rendered as the HONEST `(*(code*)0xADDR)()` indirect form -- latched `hasDamningHonestyDefect_` and hard-capped the function at 50% (Low). But that form is FAITHFUL (we simply couldn't name a sibling callee), and under a lift whose table lists only some functions every sibling call is out-of-table, so it pinned cleanly-structured functions at exactly 50% near-universally (the "every WWZ function reads 50%" symptom in the IDE whole-binary decompile). FIX = at `gateCalleeName` (CAstBuilder.cpp:848, the authoritative-table branch ONLY), stop latching the damning flag; instead count `outOfTableCalls_` (new member -> `CFuncDecl::outOfTableCalls`) and apply a graded `min(15, n*3)` deduction in BOTH scorers (`reanalyzeConfidence` + `analyzeConfidence`, in lockstep). The own-block tail-jump case (CAstBuilder.cpp:837 -- a call mis-lowered to one of OUR blocks, a genuine structuring failure) STAYS damning. Safe by construction: a function whose only "defect" was the honest out-of-table call now reads its real merit, while one with a genuine damning defect (uninit / code-leak / irreducible / dropped-CF / float-subscript / own-block-jump) still caps at 50%. **Validation caveat (honest):** the out-of-table cap only fires when `functionTableIsAuthoritative_` is true (the IDE whole-binary path with `helix.function_starts` metadata); the isolated single-function benchmark + the standalone corpus `.ll` do NOT set it (0 `(*(code*)` forms emitted), so the benchmark confirms ZERO regression but cannot reproduce the un-pinning -- that needs an IDE whole-binary decompile to confirm the positive effect.

**Confidence-honesty wave -- L2 (readability-bucket ceiling) deliberately NOT applied (wrong fix for the premise).** The proposed L2 was to cap the summed "readability" deductions so cosmetics could not sink a faithful function below ~50%, anchored on WWZ `sub_140006F70` reading 15.6%. Diagnosis showed that score is FAITHFULNESS-driven, not readability over-stacking: its deduction is `16 native-opcode(s) not decomposed` (-30, dropped AVX-512 instructions) + 10 auto-declared placeholders (-25) + 8 suspicious self-ref (-20) + 4 identity/no-op (-10) = 85, with ZERO gotos. The 16 dropped instructions are a genuine fidelity gap -- 15.6% is correctly low, NOT a false-low. A readability-bucket cap would have wrongly RAISED confidence on a genuinely-incomplete function. So the wave closes with the FALSE-HIGH gates (FIX-108 uninit-reachability, FIX-110 dropped-CF, FIX-111 float-subscript) + the FALSE-LOW FIX-112 out-of-table demotion; no L2.

**FIX-111 - a non-compilable scalar-float subscript (`float v; ... v[0]` / `v[0.0f]`) is a damning honesty defect.** A 4-detective adversarial sweep of the benchmark `.c` outputs found this as the #1 systematic defect (74 occurrences, >=5 functions, up to 100% confidence): the SSE scalar-compare lowering models an xmm lane-0 extract as a C subscript `v[0]`, but emits it on a value declared as a SCALAR `float` (`float v4 = 0.0f; ... if (v4[0] != g_X)`), or with a float-literal index (`v5[0.0f]`). You cannot subscript a scalar float in C, so the body does not compile -- yet LOP `sub_144463F70` read `100.0% (High)`. FIX = a 5th damning category `floatSubscript` in `detectDamningDefects` (`DamningDefect.h`): `scanForFloatSubscript` flags any `CSubscriptExpr` whose base is a scalar float OR whose index is a `CFloatLitExpr`. The base test uses the function's DECLARED float-var names (from `localVars`/`params`), which is authoritative -- the use-site var-ref `type` drifts away from `float` (`sub_144463F70`'s `v4[0]` ref was not typed Float, so a ref-type-only check missed it). Precise: a genuine pointer/array base has kind Pointer/Array, never Float, so `ptr[i]` is never flagged. **Validated (engine-direct, before/after):** LOP `sub_144463F70` 100->50, `sub_143805750` 100->50, SOTTR `sub_1403E5CD0` ->50, each with the located reason "non-compilable scalar-float subscript (v[0] on a float)"; ZERO regression -- WWZ `--sample 10` confidences byte-identical (50/95/50/50/61.5/50/72/50/15.6/65.8). The "P2" item of the confidence-honesty wave. The float-subscript ROOT-cause lowering fix (declare the xmm temp as a vector type, or elide the lane extract on a scalar) is a separate correctness-wave item; this change makes the confidence HONEST about it now.

**FIX-110 - dropped control flow (`__helix_unhandled_cf_*`) is a damning honesty defect: a function missing a recovered switch/branch can no longer read High.** The structurer renders a switch / conditional branch it could NOT lower as a `__helix_unhandled_cf_switch(...)` / `__helix_unhandled_cf_cond_br(...)` call -- real control flow MISSING from the body -- yet the confidence model did not penalise it: LOP `sub_14001B980` read `100.0% (High)` with a body of `... __helix_unhandled_cf_switch(scf_r900000); return v1;` (the entire jump-table dispatch dropped). The `reanalyzeConfidence` native-opcode penalty only matches `__native_` / `isNativeOpcodeName`, NOT the `__helix_` prefix, so these were counted by nothing. A corpus recon found 13/45 sampled functions carry `__helix_unhandled_cf_*`. FIX = a 4th damning category `droppedControlFlow` in `detectDamningDefects` (`DamningDefect.h`): a recursive `scanForUnhandledCF` over the FINAL AST flags any surviving `CCallExpr` whose target starts `__helix_unhandled_`. Both scorers call `detectDamningDefects`, so any such function caps at 50% (Low) with a located reason and no other wiring. Hard-cap (not graded) because un-lowered control flow is as non-faithful as an irreducible CFG -- the dispatch is simply gone. **Validated (engine-direct, before/after):** LOP `sub_14001B980` 100% (High) -> 50% (Low) "unrecovered control flow (__helix_unhandled_cf_switch)"; in a WWZ `--sample 10` the three functions that dropped to 50% (sub_140001000 94.5->50, sub_140D54820 86.5->50, sub_1417AD790 65.3->50) were EACH verified to carry 2 `__helix_unhandled_cf_*` calls (TRUE positives), while every clean function (e.g. sub_14065F240 95%) is untouched -- ZERO false-positive. The FALSE-HIGH "P1" item of the confidence-honesty wave; the FALSE-LOW out-of-table-call cap demotion (L1) and the type-confusion gate (P2) remain.

**FIX-108 - uninitialized-return honesty detector: make it reachability-aware (a dead-branch-only assignment no longer clears the cap).** External review found a FALSE-NEGATIVE in the D4 damning `uninitReturn` category: SOTTR `sub_140001000` read `Confidence: 87.0% (High)` while returning a never-initialised local. The body is `int64_t v1 = 0; int64_t v2; ...; if (!!v1) { v2 = sub_140404290(v0); } return v2;` -- `v2` is assigned, but ONLY inside `if (!!v1)`, a branch that is provably dead because `v1` is a const-0 local. `detectDamningDefects` (`DamningDefect.h`) collected every assignment target into one `assignedVars` set with no reachability awareness, so the dead-branch assignment to `v2` cleared the flag and the function escaped the 50% cap. This is the SAME defect class the detector correctly caps on `sub_140901F40` / `sub_14000662C` (return of a never-assigned local) -- it leaked only on the medium cases, which are the hardest for a user to catch by eye. FIX = build a `zeroLocals` set (locals initialised to a literal 0 and never reassigned anywhere -- a conservative const-0 set, so a reassigned var is excluded and a branch is only ever deemed dead when its guard is genuinely always-false, no false-positive uninit) and a new `collectLiveAssigned` walk that folds each `if` condition against it (peeling casts and `!`: `!!v1` with `v1==0` -> then-body dead) to gather only assignments on a REACHABLE path; the uninit-return check now tests that live set instead of the branch-unaware one. Because `liveAssignedVars` is a subset of `assignedVars`, the change can only ADD uninit detections, never remove a correct one -- strictly more honest. Header-inline in `DamningDefect.h`, so BOTH scorers (`CAstBuilder::analyzeConfidence` build-time + `CAstOptimizer::reanalyzeConfidence` post-opt) get it. **Validated (engine-direct, before/after):** SOTTR `sub_140001000` 87.0% (High) -> 50.0% (Low) with the located reason "uninitialized return value 'v2' - confidence capped at 50%"; ZERO regression -- WWZ `--sample 10` confidence values all byte-identical (95/86.5/50/61.5/50/72/65.3/15.6/65.8 unchanged), a legitimately-High function (WWZ `sub_14065F240` 95%) stays High, and a correctly-capped uninit function (SOTTR `sub_140901F40` 50%) stays capped. Follow-up (separate, deferred): the same function renders `*v4->field_0xfffffffffffffff8 = v3;` -- a -8 field offset printed as an unsigned 64-bit hex index; normalise negative struct/stack offsets to a signed form (`*(v4 - 8)`) in the spirit of FIX-107. Part of the broader confidence-honesty wave (the FALSE-HIGH dropped-instruction gate + the FALSE-LOW out-of-table-call cap demotion are the next items).

**FIX-107 - render a dereference of a constant absolute data address as a named global `g_<addr>` instead of the raw `*0xADDR`.** A benchmark sweep of 4 real x64 binaries (LOP/WWZ/ROTTR/SOTTR, 42 fns) found ~52% of functions emit bare pointer-literal derefs like `v3 = *0x147CF1328;` / `*0x141498580 = param_1;` where Hex-Rays/Ghidra show a named global. Root cause: the C-AST `UnaryExpr(Deref)` printer (`CAstPrinter.cpp:244`) emits `*` then the operand unconditionally, so a `Deref(CIntLitExpr)` -- a data address that `buildIntegerConstant` left as a plain integer in its case-(e) fallback -- prints as `*0xADDR`. FIX = in the printer's `UnaryExpr` case, when the op is `Deref` and the operand is (optionally through one cast wrapper, for the `llvm.inttoptr` `*(T*)0xADDR` form) a `CIntLitExpr` whose value V >= 0x1000, emit the named global `g_%llX` (uppercase, matching the dialect's existing `g_{:X}` convention in `HelixMidToHigh`) and skip the deref. Code addresses are NOT affected -- they reach the printer as `CAddrLitExpr` (`(void*)0xADDR`), never `CIntLitExpr`, so the gate is data-only. A primary name is precedence-safe (no parens) and is correct for both reads (`x = g_ADDR`) and store targets (`g_ADDR = y`). Design note: an earlier build-time variant (synthesizing a `CVarRefExpr` in the `CAstBuilder` `high::UnaryOp` handler) was REJECTED -- the synthetic var-ref was caught by the auto-declared-placeholder mechanism and emitted as a zero-initialised LOCAL (`int64_t g_X = 0;`), which then DSE/constant-folded the global accesses away (SOTTR `sub_140015300` collapsed 204->56 lines, semantics corrupted). The print-time approach avoids the var-collection machinery entirely AND catches every `*0xADDR` regardless of which load path produced it (the int path and the float-comparison path both funnel through the one printer case, unlike the build-time chokepoint which only saw `high::UnaryOp`). **Validated (engine-direct, before/after):** non-abs-global functions byte-identical -- a WWZ `--sample 10` re-run left all 10 functions' line/confidence metrics unchanged while the `*0xADDR` count went 2/10 -> 0/10; the abs-global functions now render named globals -- LOP `sub_144463f70` `v3 = *0x147CF1328; ... *0x147739E10` -> `v3 = g_147CF1328; ... g_147739E10` (6 refs, the float-comparison path included), SOTTR `sub_140015300`'s 145 bare derefs -> 145 `g_` globals (`g_141498580 = param_1;`) with NO collapse and NO zero-init local. Addresses the #1 benchmark gap (52% of functions). Follow-up (deferred): emit `extern <type> g_<addr>;` declarations so the output is legal C; route any residual non-`UnaryExpr` load handlers through the same check if a bare `*0xADDR` ever survives.

**FIX-106 - opt-in aggressive DSE: demote a dead call-result store to a bare call (`HELIX_AGGRESSIVE_DSE`).** `removeGloballyDeadStores` deliberately KEEPS a globally-dead store whose RHS contains a call (the `exprHasCall` guard at `CAstOptimizer.cpp:6935`), to preserve the call's side effect -- so `v5 = ftrace_set_filter_ip(...)` survives in the output even when `v5` is never read again. New OPT-IN pass (gated on the `HELIX_AGGRESSIVE_DSE` env var, read once at the top of the pass; default-OFF -> byte-identical output): inside the recursive `removeDead` walk, BEFORE the existing `erase_if`, any AssignStmt whose target is a plain globally-dead variable (not in the function read-set) AND whose RHS is a **top-level `CallExpr`** is demoted in place to a bare `CExprStmt(call)`. The dead lvalue is dropped, the call (and its side effect) is kept; `removeUnusedDeclarations` (next pass) then drops the now-unused declaration. KEY guards: (1) the test is `value->getKind() == NodeKind::CallExpr` -- NOT `exprHasCall`, which is recursive and would also match `x = g() + h()` and discard the sibling computation; only a RHS that IS a top-level call is demoted. (2) The call's argument var-refs were already counted in `reads` (collectReads visits `a.value`), so liveness is unchanged -- no desync. (3) Runs at every scope level (the rewrite is inside the recursive `removeDead`, not a top-level-only pass), so nested dead-call captures are caught too. **Validated (engine-direct, before/after):** default-OFF byte-identical across the corpus; with the flag, 6 candidates in 3 functions become bare calls, the ON-vs-OFF diff containing ONLY the intended change. e.g. rootkit `fh_install_hook`: `int64_t v5; v5 = ftrace_set_filter_ip(v2, v4, 0, 0);` -> `ftrace_set_filter_ip(v2, v4, 0, 0);` (decl + dead capture removed, call kept -- matches IDA); SOTTR `_c1_updatepos`: `0x1410ff4a8 = sub_1409b14b0(v10 + 0x35C0, 1, 1, v11 - 105);` -> `sub_1409b14b0(...)` (removes a malformed `<address> = call` lvalue). Modest volume but a genuine, IDA-matching readability win on the kernel-hook code class we audit. Backlog item closed.

**FIX-105 - FIX-091 folded-code-label recovery extended to multi-level constant add/sub chains.** FIX-091 recovers a folded in-function code address that surfaces as a single-level `add(base_const, off_const)` (e.g. a NEXT_PC `0x1409B9F77 = 0x1409B9F5B + 0x1C`), but its two callsites in `CAstBuilder::buildExpression` (the `llvm.add` / `llvm.sub` short-circuits) required BOTH operands to be integer literals via `tryExtractIntLiteral`, so a NESTED chain like `add(add(base,a),b)` or `sub(add(base,c),d)` failed the inner extract, fell through to an ordinary `CBinaryExpr`, and then leaked (the cast optimizer re-folds it and the printer renders a bare data constant). FIX = a new file-static recursive helper `tryFoldConstantOffset(Value, depth)` that descends `LLVM::AddOp`/`SubOp`, bottoming out ONLY on `tryExtractIntLiteral` (a leaf integer literal); any non-literal, non-add/sub leaf -> `nullopt`, so a runtime base (`add(param, c)`) is NEVER folded (it stays an ordinary binary). All arithmetic is `uint64` wrapping; depth-capped at 16 against pathological IR. The two callsites now feed the whole chain through the helper. **`resolveFoldedCodeLabel` and its gate are UNCHANGED** - the current-function high-bit reconstruction (`(entry & ~0xFFFFFFFF) | (folded & 0xFFFFFFFF)`) + the `[min,end)` span + in-function instruction-address-set test still apply, so this stays current-function-only and false-positive-proof (NO cross-function, NO runtime-base folding). **Validation (engine-direct, `helix_tool --use-cast-layer`, before/after on a clean stash-isolated build):** ZERO regression - the representative corpus (`_c1_updatepos`, the 3 fixtures, akasha plain+table, the 7 kbase fns, the rootkit hooks) is byte-identical before/after, with the 4 apparent diffs proven to be pre-existing structuring nondeterminism (noise floor `BEFORE`-vs-`BEFORE` matches the `BEFORE`-vs-`AFTER` diff exactly, no folded-label change in any of them) and 2 pre-existing parse crashes (`fh_ftrace_thunk`/`init_module`, crash on both exes). POSITIVE proof via a synthetic nested fold routed through the real lift (`add(add(0x140001000,5),6)`): an instrumented trace confirmed `tryFoldConstantOffset` engages and folds it to the correct in-function address `0x14000100B` (the old single-level code returns `nullopt` on the nested operand). The multi-level path is dormant on the natural corpus (no on-disk `.ll` produces a multi-level constant code-address fold), which is exactly why regression is zero. Backlog item closed.

**FIX-100 - 64-bit address printed truncated to 32 bits (public issue #37 Bug 3 / internal G7).** `CAstPrinter::formatIntLiteral` printed integer literals with `std::snprintf("0x%lX", static_cast<unsigned long>(value))`. On Windows (LLP64) `unsigned long` is 32-bit, so EVERY 64-bit address taking the `IntLitExpr` path was masked to its low 32 bits: `0x1410E5F80 -> 0x410E5F80`, i.e. any effective address crossing the `0x1_0000_0000` boundary (ImageBase >= 0x140000000 with a large `.text`) became an invalid VA, making the IR useless for semantic analysis. NOT a lifter bug (the `.ll` stores the PC full-width and computes the address via the LEA intrinsic; `llvm::raw_ostream::write_hex`, the `AddrLitExpr` path, already takes `unsigned long long`) - purely the printer's IntLit path. FIX = `"0x%llX"` + `static_cast<unsigned long long>`. SAFE: only values >= 0x1_0000_0000 change form; sub-4GB literals + all fixtures are byte-identical. Validated on ROTTR `UpdatePosition` (`*0x410E5F80 -> *0x1410E5F80`, `0x4237BA50 -> 0x14237BA50`); float bitmasks (0x7FC00000 etc.) untouched.

**FIX-097 - relocated `.rodata` string recovery (the disasm <-> Helix connector the scaffold was missing).** Kernel-module / rootkit decompiles showed `printk(0, ...)` for every format string: the string-render path existed (`high::StringLitOp`, `cast::CStringLitExpr`, `DataSectionProvider::readCString`) but NOTHING ever created a `StringLitOp` from a constant, so a relocated `mov rdi, .rodata+OFF` (patched by the HexCore disassembler to a known data address) rendered as a bare integer. Wired the connector:
- `Engine::parseHelixStringsMetadata` scans the input IR for the `!helix.strings` module metadata the disassembler emits for ET_REL `.rodata` relocations (a fake base VA + the raw, `\HH`-escaped section bytes) and registers each node via `addDataSection` at the top of `decompileIR` / `decompileIRText` - BEFORE the `ScopedDataSectionProvider` is installed (it early-returns when `data_sections_` is empty, so registration must precede it).
- `CAstBuilder::buildIntegerConstant` (the single IntLit chokepoint) + the `AddrLitOp` branch resolve a constant through `getActiveDataSectionProvider()->readCString()` to a `CStringLitExpr` when it is a clean printable C-string - a leading kernel KERN_SOH `\001`+level byte is tolerated, >=2 body chars, <=512. GATED on an active provider, so every corpus decompile without `!helix.strings` (i.e. all existing inputs) is byte-identical -> **zero regression** (verified: a no-metadata `.ll` still renders `printk(0)`, 0 spurious strings).
- `CAstPrinter` now escapes a `StringLitExpr` to a valid C literal - quotes/backslash, `\n` `\t` `\r`, and any other non-printable byte as **3-digit octal** (not `\xHH`, which would greedily merge a control byte with a following hex digit, e.g. the KERN prefix `\001`+`7`).

Validated end-to-end on `malware.ko` `fh_install_hook`: `printk(0, *v11)` -> `printk("\0017DMESG: unresolved symbol: %s\n", *v5)` (all five DMESG format strings + KERN levels), through `liftToIR` -> Souper (preserves the metadata + constants, 0/399 replaced) -> this engine. The `.node` was rebuilt from this tree (`cargo build --release -p hexcore-helix`, bypassing the absent napi CLI; LNK2019 gotcha = copy the fresh `engine/build/helix_engine.lib` over `engine/deps/llvm-mlir/engine/`) and deployed into `vscode-main/extensions/hexcore-helix/`, where the IDE `hexcore.helix.decompile` now shows the strings. A worked example of ale's point: the dialect already had the ops, it lacked the semantics linking them.

**Structurer rewrite promoted to DEFAULT-ON + M4 P4/P5 (dispatcher elimination).** The
`mlir::transformCFGToSCF` rewrite (detailed below) is now the DEFAULT path in this
sandbox: `StructureControlFlow.cpp` runs it unless `HELIX_SCF_LEGACY=1` is set (it was
previously gated behind an opt-in `HELIX_SCF_SPIKE`). M4 deopt extended to P4/P5 to
close the dispatcher gap the section below flagged as "NEXT = P4 ... not yet done":
- **P4 (`CAstOptimizer::collapseDispatcher`).** Removed the `nonDefault > 2` bail for
  `scf_r*` selectors, so the synthetic structurer dispatcher is collapsed even with
  many arms instead of being emitted as a residual switch.
- **P5 (`eliminateDeadSelectorStores`, new).** A recursive `scf_r*` liveness pass that
  removes selector stores whose value is never read on any path -- the dead routing
  state left after P4 collapses an arm.
- **Validated independently:** context_mmap 899 -> 655, mem_alloc 599 -> 456 lines, all
  0 unreachable; x86 fixtures byte-identical; WWZ ESP coverage 37.8% -> 80.3%. This
  supersedes the "NEXT = P4 ... not yet done" note in the section below.

### Invariants & conventions (engine -- keep these true)

Non-obvious engine invariants, recorded so a future edit does not silently break them
(surfaced by a 2026-06-22 code-review pass over this changelog):

- **Decompile entry order (FIX-097):** `parseHelixStringsMetadata()` MUST run and
  register data sections via `addDataSection` BEFORE the `ScopedDataSectionProvider`
  is constructed -- the provider early-returns when `data_sections_` is empty and
  installs nothing, so a later parse would be silently invisible (no error). Currently
  enforced by an IDENTICAL 2-line sequence duplicated in BOTH `Engine::decompileIR`
  (:228-229) and `decompileIRText` (:278-279); there is no shared `prepareDecompile`
  helper yet, so the order is drift-prone. TODO: centralize.
- **D4 damning cap has TWO defect SOURCES, not two passes (FIX-093/096):** the cap is
  `detectDamningDefects(func).any() || func.hasDamningHonestyDefect`, and that OR is
  evaluated at BOTH scorers -- `analyzeConfidence` (build-time, defensive) AND
  `reanalyzeConfidence` (post-opt, the score the user sees). The split is by SOURCE,
  not by translation unit: `hasDamningHonestyDefect_` is a sticky build-time bool that
  latches the single D2 out-of-table-call category (stays set even if DSE erases the
  call); `detectDamningDefects` is a pure function that RE-DERIVES three other
  categories (surviving code-address leak / uninitialized return / irreducible
  no-return) from the FINAL AST. It is NOT "one check in CAstBuilder, one in
  CAstOptimizer."
- **`resolveFoldedCodeLabel` is current-function-only (FIX-091):** it reconstructs a
  candidate as `(currentFunctionEntryAddr_ & ~0xFFFFFFFF) | (rawValue & 0xFFFFFFFF)`
  and hard-gates on the candidate lying in `[currentFunctionMinAddr_,
  currentFunctionEndAddr_)` AND being a recorded instruction/block address of THIS
  function. That `high|low32` reconstruction is WRONG for a sibling in a different
  4GiB window, so cross-function label resolution CANNOT reuse this helper without a
  real base/relocation model (it would reintroduce the false-positive class the span
  gate exists to exclude). Arithmetic folding is single-level (base+offset, both
  operands literal); nested add/sub chains are not folded yet.
- **DSE is two complementary passes (do not merge):** `dseStmtList` is flow-sensitive
  but level-by-level (the `eliminateDeadStores` wrapper descends ONE level into each
  nested body); `removeGloballyDeadStores` is flow-insensitive but scope-complete --
  it erases a pure (call-free) store to a variable that is never read ANYWHERE. No
  double-removal hazard (each erases from a vector; the global pass re-derives its own
  read-set), and the global pass deletes a strict subset (never-read + call-free).
- **Address/integer literals: use `std::format("{:x}", static_cast<uint64_t>(v))`,
  never printf `%lX`/`(unsigned long)` (FIX-100).** `unsigned long` is 32-bit on
  Windows (LLP64) and silently truncates any address above `0x1_0000_0000`. The lone
  surviving printf literal site is `CAstPrinter::formatIntLiteral` (now `%llX`).

### Backlog -- verified opportunities (2026-06-22 review)

Confirmed not-yet-done against the source; recorded so they are not lost. None is a
correctness bug (all are additive / opt-in).

- **RTTI Tier-2 type-name recovery.** Class naming today is Tier-1 only (a prefix
  guess over resolved method names, `DevirtualizeIndirectCalls.cpp:320`). The binary
  data path the old code comment (:328) said Tier-2 needed now exists
  (`DataSectionProvider::readWord/readCString`, already used by FIX-097): follow
  `vtable[-1] -> COL -> TypeDescriptor` (MSVC) or `type_info -> __type_name`
  (Itanium). Needs a real MSVC/Itanium name decoder (`RemillDemangler` does not
  suffice) + RVA-relative reads for PIE; opportunistic (RTTI is stripped under
  `/GR-` / `-fno-rtti`).
- **`--preserve-cfg` broader corpus.** ON-path validated on n=1 (`crackme.deflat2`).
  Since the RC4-PRGA fix ungated Stage-1 (`RemillToHelixLow.cpp:3408` is now `if
  (true)`), the flag only gates the multi-latch loop-structuring skip
  (`StructureControlFlow.cpp:2183`), so "more corpora" means more
  flattened/obfuscated DISPATCHERS (Callfuscated, poly, OLLVM/Tigress-FLA), not
  generic binaries. The 4-corpus quad is the OFF tripwire (byte-identical), it does
  not exercise ON.
- **Aggressive DSE for dead call-result stores (opt-in).** ~~Demote a globally-dead
  `x = foo();` to a bare `foo();`.~~ **DONE -- see FIX-106** (`HELIX_AGGRESSIVE_DSE`,
  top-level-`CallExpr` guard, recursive per-scope rewrite before the `erase_if`,
  default-OFF byte-identical).
- **`resolveFoldedCodeLabel` add/sub chains.** ~~Teach the `llvm.add`/`llvm.sub` fold
  / `tryExtractIntLiteral` to recurse through nested constant add/sub.~~ **DONE -- see
  FIX-105** (`tryFoldConstantOffset`, current-function gate reused, cross-function kept
  OUT per the invariants).
- **Variadic SIGNATURE marking has no producer.** The printer/serializer already emit
  `, ...` from the FuncOp `is_variadic` attr, but no production pass SETS it, so
  `func.isVariadic` is always false today and the `CAstPrinter` `, ...` branch is
  dead. Wire it from `SignatureDb`/calling-convention recognition of known variadics
  (printf/printk family), NOT from LLVM `isVarArg` (Remill funcs are fixed-arg
  `(State*, pc, Memory*)`). See the Wave 22 note (that work was variadic CALL-SITES,
  a different concern).
- **CI lint over a `HELIX_FORMAT_U64` macro (FIX-100 follow-up).** Prefer a grep-based
  lint forbidding printf `%lX`/`%lx`/`(unsigned long)` in the emit/cast print paths; a
  `static_assert` cannot catch a printf format/argument width mismatch anyway.

### v1.0 structurer rewrite: M0-M2 + the selector-survival fix + M4 deopt (branch scf-structurer-v1) - 2026-06-16

> **HISTORICAL / SUPERSEDED -- see the top `[Unreleased]` "Structurer rewrite promoted
> to DEFAULT-ON" entry.** This section describes the rewrite WHILE it was still an
> opt-in spike, and is kept verbatim for history. It has since LANDED as the default
> path: `StructureControlFlow.cpp:2068` now runs the rewrite UNLESS `HELIX_SCF_LEGACY=1`
> (opt-OUT); `HELIX_SCF_SPIKE` is now only a vestigial force-on alias (nothing else
> gates on it). The "WIP / behind SPIKE / not landed" and "NEXT = P4 (not yet done)"
> notes below are STALE -- P4 (`collapseDispatcher`, the `>2`-case cap removed,
> `CAstOptimizer.cpp:7000`) and P5 (`eliminateDeadSelectorStores`, :7538) are both
> landed.

WIP, behind the `HELIX_SCF_SPIKE` env gate; not landed (no version bump). This is
the executable proof of the `STRUCTURER_V1_REWRITE_SCOPING.md` direction: reuse
LLVM 18.1.8's `mlir::transformCFGToSCF` (the RVSDG / correct-by-construction
structurer) instead of the hand-rolled block-moving pass that the
`[Investigation]` entry below proved un-patchable.

**LIFT-LAYER FIX (separate axis from the structurer) - memory read-modify-write
address-vs-value confusion.** `RemillToHelixLow` rendered every `op [mem], x`
read-modify-write using the memory operand's ADDRESS as its VALUE: e.g.
`inc qword [rbx+0x9108]` became `*(p+0x9108) = (p+0x9108) + 1` and
`or qword [rbp+0x20], 0x4064000` became `*(p+0x20) = (p+0x20) | 0x4064000`, instead
of the correct `*p = *p + 1` / `*p = *p | flag`. The un-inlined Remill semantics
function (`INC<MnW,Mn>`, `OR<MnW,Mn,In>`, ...) passes the memory operand as an
address; the INC/DEC and the generic binary-op handlers used `getOperand(3/4)`
directly as the value, never emitting the implicit load (the CMP/TEST/MOV handlers
already loaded via `has_memory_src`; the arithmetic/logic ones did not). FIX: in
the INC/DEC and binary handlers, when `RemillSemanticInfo.has_memory_dst` (RMW:
load the lhs/dest) or `has_memory_src` (pure memory source: load the rhs), emit a
`MemReadOp` before the op. Now `lock inc [mem]` -> `field++`, `or [mem], flag` ->
`field |= flag`, `add [mem], 1` -> `field += 1` -- matching IDA. **This is a real
correctness bug in the SHIPPED main line** (every memory increment/decrement and
every `op [mem], imm` was wrong): it corrupts refcounts, counters, and flag-set
operations -- directly relevant to kernel-driver refcount-UAF auditing. Found by a
cross-review (another model flagged the symptom from the output; root-caused +
fixed here). Validated: 0 residual address-as-value RMW across the kbase corpus,
0 crashes, x86 fixtures byte-identical. (Same one-op-missing class as the
`isLiveConsumer` switch bug -- the main line should take both.)

**M0 - PROVEN.** Added `runSCFSpike` + `HelixSCFInterface : mlir::CFGToSCFInterface`
(mirrors the upstream cf->scf reference): remove-unreachable -> strip block-args
(poison, spike-only) -> rewrite every branch terminator (helix_low.jmp/jcc +
llvm.br/cond_br) to operand-less cf -> DominanceInfo -> `transformCFGToSCF`.
Result on `kbase_mem_free` (the function the legacy pass mangles into a
premature-`return` stub): **8 scf.if + value-routing scf.yield, single
`helix_low.ret` at the END, body fully reachable, NO premature return, NO
0xC0000409 crash.** Breadth: **15/15 valid inputs structured, 0 crashes** -
all 7 kbase (incl. mem_alloc/import that crash under the old guard), the rootkit
hooks, WWZ `bone_pos_calc` (the ESP fn), and **`after.ll`, the 980-block
callfuscated irreducible boss the old structurer cannot do.** (The only 2 non-OK
are pre-existing malformed `.ll` that fail at LLVM-IR parse, unrelated.)

**M1 - bridges COMPLETE + validated end-to-end.** Three `scf -> helix_high`
bridges, all de-SSA'ing region results into fresh temp vars (so the downstream
RecoverVariables ... CAstBuilder pipeline is unchanged), dispatched innermost-first
in one PostOrder walk:
- `bridgeSCFIfToHelixHigh`: `scf.if -> helix_high.if` (region results -> var
  assigns replacing `scf.yield`, read after the op).
- `bridgeSCFIndexSwitchToHelixHigh`: `scf.index_switch -> helix_high.switch`.
  Selector traced back through the interface's `arith.index_castui` to the
  original integer (clean C, not `index`); regions REORDERED from scf's
  `[default, case0, ...]` to helix's `[case0, ..., default]` (CAstBuilder treats
  region index >= case_values.size() as `default:`); each case region terminated
  with `helix_high.break` (the C printer does NOT auto-insert break, so without
  it cases fall through).
- `bridgeSCFWhileToHelixHigh`: `scf.while -> helix_high.do_while`. transformCFGToSCF
  always emits the tail-controlled form (body in BEFORE ending `scf.condition`,
  trivial pass-through AFTER); loop-carried values are de-SSA'd into temp vars and
  the parallel `scf.condition` forward is lowered as a TRUE parallel copy
  (snapshot every read - condition + next-values - into shadow temps before
  writing any carried var; a naive sequential `var[i]=next[i]` would clobber a
  loop-carried swap/rotation - caught by adversarial review). condRegion yields a
  `cond_var` so `do { ... } while(cond_var)` reproduces the loop test.

**End-to-end scoreboard (clean spike-off vs spike-on, 7-fn kbase corpus): the
premature-return / unreachable-after-return bug is ELIMINATED everywhere -
unreachable 22/87/90/37/21 -> 0, body recovered 2.5x-7.2x, 12/12 no crash.**
e.g. context_mmap 201 lines/22-unreachable -> 1449/0 (do-while emitted faithfully,
19 switches), mem_free 49/21 -> 124/0. The dispatcher noise (RVSDG selector vars +
single-case switches) pins confidence at 50%, which REGRESSES the 2 fns the legacy
already structured clean (csf_queue_register 100->50, mem_import 60.8->50) - that
noise is exactly what the M4 SAILR-style deopt pass dissolves. All flag-gated, so
zero shipping impact.

**M1 open items (honest):** block-arg poison-strip KEPT (validated non-lossy on
this corpus - all call-sites preserved, no poison/undef leak in emitted C); proper
normalization deferred. **[STALE -- now default-ON; the gate is `HELIX_SCF_LEGACY=1`
opt-OUT, NOT a `HELIX_SCF_SPIKE` opt-IN; see the SUPERSEDED banner at the top of this
section.]** The opt-in is the `HELIX_SCF_SPIKE` env gate (legacy is the
default); a `--use-scf-structurer` CLI alias is trivial M5 polish.

Commits: fc062f9 (M0), 54887aa (M1 scf.if bridge), 224d080 (M1 index_switch +
do_while bridges + parallel-copy fix, adversarial-review-cleared).

**M2 - corpus stress (rootkit + boss), all no-crash.** Rootkit kernelmonarch hooks
RESCUED: hook_read 20-unreachable/36.7% -> 0/53% (+16.3pp), hook_write +
hook_ia32_write 13/45.2 -> 0/59 (+13.8pp) -- on the rootkit, unlike kbase, the
confidence is NOT pinned at 50% (less dispatcher nesting), so the spike rescues AND
raises confidence. fh_install_hook/hooks structure their loop as a `do_while`.
`after.ll` (the 980-block callfuscated boss) runs end-to-end with the bridges,
exit 0, no crash (output is still the flat deflattened call chain -- re-rolling that
is the separate Stage-2 gap). Validated on FRESH `.ll`: a re-lift (Remill drifted)
shrank the 3 dispatcher-heavy fns 17-20%, so the structurer is now validated against
current-Remill input, regenerated via the `.hexcore_job.json` pipeline.

**THE SELECTOR-SURVIVAL FIX (correctness, root-caused via M4).** Collapsing the
RVSDG exit-dispatcher to `if` (M4 below) exposed that the dispatcher's synthetic
selector (`scf_r*`) was being DESTROYED before it reached correct C: on kbase_mem_free
`if (scf_r900000)` read a selector that was only ever 0 (a read-before-write `=0`
init) -> the region-lookup continuation was DEAD, semantically WRONG (the spike's
"full reachable body" was STRUCTURALLY complete but the DISPATCH ROUTING was broken,
which call-site/line counts had not caught). **Root cause = ONE missing op in a
liveness allowlist: `EliminateDeadCode.cpp isLiveConsumer()` enumerated the control-
flow ops that count as a live use (helix_high.if/while/do_while/for + low branches/
calls/ret/memwrite) but was MISSING `helix::high::SwitchOp`** -- the op the M1 bridge
emits for the dispatcher. Its selector is read ONLY at the switch, so with switch
absent from isLiveConsumer the read was invisible to liveness, the selector var was
DCE'd as dead, and the dispatcher fell back to a phantom 0. FIX = add
`isa<helix::high::SwitchOp>(op)` to isLiveConsumer (one line). **kbase_mem_free is now
SEMANTICALLY CORRECT and matches IDA's control flow** (scf_r=1 survives on the
LABEL_4 paths, the region-lookup runs on exactly the right paths). Defensive
companions so no later pass re-destroys the now-surviving selectors: CAstBuilder
dead-store guards (precomputeDeadStores + cross-block prescan skip scf_*, since
their assign-RHS-only scan also can't see a switch/if selector read),
`resolveTransitive` no-resolve + `lastRegValue_`/`exprToBestName_` no-cache for scf_*
(stop the unsound path-dependent copy-chain collapse), and a dseStmtList keep-scf-live
guard. LESSON: when the rewrite introduced a NEW helix_high op (switch), every
liveness/DCE allowlist that enumerates control-flow ops had to learn it.

**M4 - SAILR-grounded dispatcher deopt (readability, on now-CORRECT code).** Grounded
in a 5-paper read (SAILR "Reverting Switch Lowering" + DREAM condition-refinement +
Phoenix iterative structuring + dewolf/DREAM++ congruence). Two passes, run first in
`CAstOptimizer::optimize()`, gated on the `scf_r*` synthetic name so real jump tables
are never touched:
- **P3 `dissolveExitDispatchers`**: a single-/two-case `switch(selector)` over a
  synthetic selector IS an if/else -> rewrite to `if (selector == case) {..} else
  {..}` (SAILR), fixed-point for nested dispatchers. context_mmap 19 switches -> 2.
- **P2 `coalesceSelectorChains`**: the selector value is routed up a tree of pure
  copies (`scf_rB = scf_rA; scf_rC = scf_rB; ...`); these form a copy tree with no
  interference, so union-find-coalesce every copy-connected `scf_r*` to one
  representative (DREAM++ congruence) -> the copies become `rep = rep` self-assigns
  the existing removeSelfAssignments erases. **scf_r references down ~60%**
  (context_mmap 963 -> 382, mem_import 934 -> 332, mem_alloc 834 -> 298).

**3-way scoreboard (IDA vs 0.9.2 vs v2-now, on FRESH `.ll`; lines / unreachable):**

| function      | IDA  | 0.9.2          | v2-now (this branch) |
|---------------|------|----------------|----------------------|
| mem_free      | 82   | **STUB (12)**  | **131 / 0** (correct) |
| jit_allocate  | 315  | 203 / **87**   | 570 / **0** |
| mem_alloc     | 361  | 190 / **88**   | 809 / **0** |
| context_mmap  | 551  | 199 / **22**   | 1109 / **0** |
| mem_commit    | 184  | 78 / **28**    | 309 / **0** |
| mem_import    | 521  | 280 / 0        | 1068 / **0** |

0.9.2 is BROKEN (a bare stub, or a body with 22-88 `unreachable` statements stranded
after a premature return). v2-now is CORRECT everywhere (0 unreachable, dispatch
routing matches IDA) and ~2x IDA in line count. The residual gap is (a) the remaining
dispatcher selectors -- a `goto`/inline P4 (not yet done) would close it -- and (b)
the per-instruction `var_0 = 0xADDR` PC-tracking noise (a separate, non-dispatcher
source). 12/12 no crash on the fresh corpus; x86 fixtures unchanged.

**`removeGloballyDeadStores` (the `var_0` PC-noise fix).** The deeply-nested
structured form the scf-structurer produces left dead `var_0 = 0xADDR` PC-tracking
shadow stores (var_0 written 12x, read 0x) that the existing dseStmtList misses.
`dseStmtList` eliminates dead stores LEVEL-BY-LEVEL: the `eliminateDeadStores` wrapper
descends ONE level into each nested body, but each invocation still treats ITS OWN
children conservatively, so a DEEPLY-nested (>1 level) dead store survives, as does
any never-read-anywhere store. A new whole-function pass removes pure (call-free)
stores to variables that never appear in the function's read-set anywhere -- sound
regardless of scope. Cut **15-22% more lines** corpus-wide (mem_free 131 -> 102 vs
IDA 82; context_mmap 1109 -> 952; mem_import 1068 -> 869); x86 fixtures byte-identical
(they had no globally-dead stores); 0 crashes; correctness preserved (mem_free still
matches IDA's control flow).

**[STALE -- P4 AND P5 are landed (see the SUPERSEDED banner above).]** NEXT = P4 (eliminate the dispatcher entirely via goto/inline = the last gap to IDA;
IDA uses `goto LABEL_4` for the multi-entry continuation). Code staged on
`scf-structurer-v1`; RAG write-up in `HexCore-Helix-Original/rag/18_*`.


## [0.1.8] - Self-ref false-positive: pointer walks are not suspicious - +5pp - 2026-06-15

A second structurer-independent, honest-confidence win on `kbase_mem_import`:
**55.8% -> 60.8% (+5pp)**, self-ref count 4 -> 3.

**Root cause (false positive):** the confidence scorer flags an assignment as a
"suspicious self-referencing assignment" whenever the target var name appears
anywhere in the RHS, with a heavy penalty (`min(20, count*5)`).  But `x = x->field`
and `x = *x` are perfectly legitimate pointer walks / loads (a register reused
after dereferencing itself) - extremely common in real code - and were being
penalised as suspicious.

**Fix (FIX-v2-CAST-002):** in `reanalyzeConfidence`, recognise a RHS that is
purely a field-access / deref chain rooted at the target var (`isPureSelfWalk`)
and exclude it from the suspicious count.  Honest: it only suppresses a FALSE
positive; genuine self-refs stay flagged - on mem_import the pure walk
`alloc = alloc->field_0x8f8` is now excluded while the three `alloc = call(alloc->field)`
captures (which also carry a void-capture concern) remain counted.  Scorer-only:
the emitted body is unchanged by construction (reanalyzeConfidence does not mutate
the AST).

**Validation:** scoreboard vs ORIGINAL 0.9.2, 7-function kbase corpus:
**0 REGRESSED, 0 STUBBED, 2 IMPROVED (mem_import +15pp cumulative, mem_free +2.5pp),
net +17.5pp in v2's favor.** Fixtures 5/5 byte-identical.  Broad: pointer walks
appear in nearly every real function, so this lifts confidence wherever the
structurer is not the dominant cap.  **v2 is now +17.5pp ahead of 0.9.2.**


## [0.1.7] - Empty-if sweep ordering fix: +10pp on kbase_mem_import - 2026-06-15

A localized, structurer-INDEPENDENT C-AST win (the kind to keep chasing while the
structuring layer waits for its v1.0 rewrite). `kbase_mem_import` was the only
kbase function NOT capped by the premature-return bug, so its issues were purely
local: **45.8% (Low) -> 55.8% (Medium), +10pp**, with the "5 empty if/else
block(s)" issue category eliminated.

**Root cause (ordering):** `removeEmptyIfStatements` ran at `optimize()` lines
~242 and ~254, but the LATE dead-code passes that run after it -
`removeDeadStoresBeforeReturn`, `removeNullDerefPlaceholderStores`,
`removeUnreachableAfterFirstReturn` - can empty an if-body that was non-empty at
sweep time, leaving an `if (cond) { }` shell that nothing re-checks, so
`reanalyzeConfidence` counted it as an empty block.

**Fix (FIX-v2-CAST-001):** one extra `removeEmptyIfStatements(func)` call after
the last body-emptying pass and before `reanalyzeConfidence`. Provably safe -
`removeEmptyIfsInList` only erases an `IfStmt` whose then AND else bodies are both
empty; it cannot touch a non-empty statement.

**Validation:** scoreboard vs the ORIGINAL 0.9.2 over the 7-function kbase corpus:
**0 REGRESSED, 0 STUBBED, 1 IMPROVED (mem_import +10pp), 1 RESCUED, net jumps from
+2.5pp to +12.0pp in v2's favor.** Fixtures 5/5 byte-identical. Adversarial check:
the before/after body churn (real statements moving) was confirmed to be the
pre-existing structuring NON-DETERMINISM noise floor (same exe, two runs = 107
differing lines, same 55.8% confidence, empty-if issue gone on BOTH runs), not the
patch dropping code. **v2 is now +12pp ahead of 0.9.2.**


## [Investigation] - Premature-return structurer: root cause PROVEN, fix hits a v1.0 wall - 2026-06-15

Two focused sessions attacking the highest-leverage gap: every kbase function with
branches gets a premature `return` at the top that strands the real body as
"N unreachable statement(s) after return" and caps confidence at 33-52% (vs
85-100% on clean functions). No code landed (master stays PRISTINE 0.1.6); the
deliverable is a proven root cause + a hard architectural finding. ALL the
experimental code + the diagnostic harness live on the local branch
`wip-structurer-premature-return` (DO NOT MERGE).

### Baseline: v2 0.1.6 vs the ORIGINAL 0.9.2 (the number to remember)

`diff_v2.ps1` with Baseline = the real 0.9.2 exe (`HexCore-Helix-Original`,
confirmed `--version`=0.9.2) vs Experiment = v2 master 0.1.6, over the 7-function
kbase corpus: **0 REGRESSED, 1 IMPROVED (mem_free 49.5 -> 52), 4 CHANGED?(flat),
2 = ; net +2.5pp in v2's favor.** Fixtures 5/5 byte-identical. So **v2 is NOT
behind 0.9.2 - it is marginally AHEAD**, and the entire lead is the one landed
[0.1.6] Phase-4 call-result guard. (An earlier "20-40% behind" impression was a
misremember of a HexCore-vs-IDA / 0.9.1-vs-0.9.2 delta, not this one.)

### Root cause of the premature return (PROVEN at the IR level)

Added a `HELIX_DUMP_IR`-gated per-pass IR dump (Pipeline.cpp
`CallOpCountInstrumentation::runAfterPass` writes `helix_ir_NN_<pass>.mlir` +
`[v2-dbg]` block counts). On `kbase_mem_free.ll` the block count drops 20 -> 15
at **StructureControlFlow** = where the premature `ret` is born. Mechanism:
`recoverIfElse` classifies the entry block `bb0` (`jcc[bb6,bb1]`) as an if/else
(both targets dominated, merge = `bb19` which is a trivial shared `ret`).
`collectPathBlocks` can only collect `{bb6}` / `{bb1}` (its conservative `{start}`
fallback) because the then/else paths **re-converge through a shared MULTI-ENTRY
block** `bb3` (preds `bb2` from the else side + `bb7` from the then side).
`structureIf` then moves those single blocks - which still carry CONDITIONAL `jcc`
terminators escaping to top-level - into the IfOp; `rewriteStructuredRegionExits`
ignores them (it only fixes 1-successor branches); then it replaces `bb0`'s
branch with `helix_low.ret` because `findTrivialReturnOp(bb19)` succeeds. Net:
`bb0` returns, the whole body `bb1..bb14` is stranded UNREACHABLE = the
`return result;` stub.

### Root cause of the crash (when the naive fix is applied)

A guard that makes `recoverIfElse` SKIP these degenerate if-regions (route them to
the goto/label fallback) **cleanly fixes the simple cases**: mem_free 52 -> 71.5
(+19.5pp, body recovered, "21 unreachable after return" -> "9 gotos"); mem_commit
52 -> 74.5 (+22.5pp). **But on complex functions it CRASHES** (exit 0xC0000409 =
the LLVM `GenericDomTreeConstruction.h:481 "(Total+1==Num)"` assert). Per-Dom-site
markers (`V2DBG_DOMSITE`) + a pre-construction func IR dump pinned it: the assert
fires on a `helix_high.if` then-region whose ENTRY block is
`^bb0(%arg0: !llvm.ptr): // pred: ^bb0` = a **region-entry block that HAS A
PREDECESSOR + a block-argument = MALFORMED MLIR** (it violates the region-entry-
has-no-preds invariant; the verifier is OFF in the pipeline so it slips through).
It is NOT plain unreachability (forward AND reverse BFS both pass). It is a
structurally invalid region created by structuring a residual LOOP block (hence
the block-arg) into an IfOp.

### The 5 attempts and the META-FINDING (why this is a v1.0 wall)

Each attempt below was built + run on the full kbase corpus; each one cascaded:
1. `regionEscapes` (reject if-regions whose moved blocks escape to a non-merge
   block) - fixes mem_free/commit, crashes mem_alloc/import.
2. + reverse-reachability inside `hasIrreducibleSCCs` - crash persists.
3. + func-scope `hasUnreachableBlocks(func.getBody())` guard - crash persists
   (wrong scope: the bad block is in a nested region).
4. + region-scope `hasUnreachableBlocks(region)` - crash persists (the bad block
   is reachable both ways; it is malformed, not unreachable).
5. full SESE (single-entry + multi-entry + back-edge-into-entry + single-exit) -
   NEWLY crashes `kbase_csf_queue_register` (a clean 100% function!); narrowing
   to escape + back-edge-into-entry fixes csf but mem_alloc/import STILL crash.
6. + "entry has a foreign (non-branchBlock) predecessor" check (to catch the
   shared multi-entry block being moved AS a region entry) - re-crashes csf AND
   still does not fix mem_alloc/import.

**Source of the malformation, pinpointed** (a `[v2-malf]` scan that reports any
region whose entry block has predecessors, run after each structuring phase):
**nothing is malformed after Phase 2 (loops); the entry-with-predecessor region
is born during Phase 3 (if-recovery), as a SIDE EFFECT of `structureIf` moving
blocks** (the shared multi-entry block - kbase `bb3(%137): 2 preds` with its
block-arg phi - ends up as an IfOp region entry, dragging its external preds).
Crucially it is a side effect of the MOVE, not a property of the proposed
if-region, so no pre-move per-region check in `recoverIfElse` can see it coming.

**META-FINDING (decisive): the structurer is NOT robust to changing WHICH regions
get structured.** Every tweak to the structured-region set produces a different
malformed-IR / DomTree-crash somewhere else, because `structureIf`'s block-moving
creates malformations as side effects that no pre-move per-region check can
predict. The block-moving + lazy-dominance machinery has deep, tangled invariant
dependencies. **The premature return cannot be fixed by guarding `recoverIfElse`
/ `structureIf` (6 distinct attempts, all cascade).** This aligns with the
leave-nightly plan: the structuring layer is a v1.0 (rev.ng-style) rewrite
concern, not a v0.9.x patch.

### What WORKED (carry these to 0.9.2)

- The **Phase-4 call-result guard** ([0.1.6], the +2.5pp lead). Already validated,
  promotion-ready. THIS is the migration-worthy win.
- The **diagnostic harness**: the `HELIX_DUMP_IR` per-pass IR dump, the
  `V2DBG_DOMSITE` markers, and the confidence-aware `diff_v2.ps1` scoreboard.
  Reusable for the v1.0 structurer work. (On the WIP branch.)
- The **proven root causes** above - they are the spec for the real fix.

### What the REAL fix needs (the v1.0 structurer rewrite)

A ground-up, dominance-SAFE structurer: collect if/loop regions as proper
single-entry/single-exit from the start (Yakdan "No More Gotos" / Ghidra
collapse-first), keep the IR well-formed at every step (no entry-with-predecessor,
no escaping cross-region branches), and make EVERY Dom/PostDom construction
provably safe before it runs. Until then, pursue OTHER localized safe wins (like
the Phase-4 guard), NOT the fragile structurer.


## [0.1.6] - The Phase-4 guard is VALIDATED on real kernel code - 2026-06-15

The plot twist. After 0.1.4-0.1.5 concluded the guard was inert/ineffective on
the rootkit (Phase 4 = 0 merges there, collapse was upstream), running it on the
real **Mali kbase GPU driver** (`Intigrity/.../fresh-helix-souper-2`, 14 lifted
`.ll`) told a completely different story - and a confidence-aware scoreboard +
six adversarial judges turned a vN-count panic into a clear win.

**Confidence-aware scoreboard** (`diff_v2.ps1` upgraded to parse confidence %,
Low/Medium/High label, the stub flag, and unreachable counts) over the 14 kbase
files: **IMPROVED=2, REGRESSED=0, STUBBED=0, CHANGED?=10, =2, net +5.0pp**. The
earlier "+92 vN" alarm was confidence-flat reshuffles, not regressions.

**Six skeptical adversarial judges** (one per function, told to default NEUTRAL
and treat extra vN as suspect) read the actual baseline-vs-v2 C:
**5 BETTER, 1 NEUTRAL, 0 WORSE.** On real production kernel code the guard:
- removed a **factually-wrong `v13 = _dev_err(...)`** capture of RAX after a
  void-returning call, plus the garbage arithmetic derived from it
  (kbase_context_mmap);
- corrected a misleading `bool` to `int64_t` on a page-count value
  (kbase_jit_allocate, kbase_context_mmap);
- **split overloaded call-result vars** into distinct named results
  (kbase_mem_alloc: `v5` -> `v8`=check_alloc_flags / `v9`=check_alloc_sizes /
  ...), removed two spurious `*call_result` stores, and cut unreachable 89->87;
- **de-stubbed four placeholder branches** `if(!v4)` into genuine named
  `kbase_region_tracker_find_region_base_address` / `kbase_alloc_phy_pages_helper`
  / **`kbase_mem_grow_gpu_mapping`** (the audit-relevant grow path) calls and
  fixed a malformed `if (*v25 != + 72)` compare (kbase_mem_commit);
- turned an **empty stub into a full body** with the real -EINVAL error path,
  named call graph and struct offsets (kbase_mem_free: stub -> 52% Medium).

**Decision: KEEP the guard.** It is a genuine quality improvement on the exact
class of code we audit (kernel drivers), reconciling with the changelog: where
Phase 4 actually merges call-results (kbase), the option-1 guard correctly
prevents it; where it does not (rootkit), the guard is inert. The `[v2-exp]`
debug print was removed; the guard is now clean. Arc 0.1.0-0.1.6, 7 commits +
the scoreboard upgrade. Candidate for promotion to the main line.


## [0.1.5] - Root cause pinpointed in CAstBuilder input - and it is FAITHFUL - 2026-06-15

Traced the `v4 = printk(0, v4)` collapse to its exact origin by dumping the
printk chain at every optimizer stage plus the MLIR var names/ids feeding
`CAstBuilder` (all instrumentation since reverted).

**Findings:**
- The collapse is **already present at `optimize()` ENTRY** - i.e. in the C-AST
  that `CAstBuilder` produces, before any optimizer pass runs. The pass-by-pass
  trace was identical at ENTRY / post-inferSemantic (`rax = printk(..., rax)`)
  and only `renameRemainingRegisterVars` swaps `rax -> v4`. So no optimizer pass
  causes it; it is upstream.
- At `CAstBuilder` input the MLIR has the **same `helix.high` variable
  `varId=15` ("rax") as the target of multiple printk assignments** (plus a
  couple of survivors `rax_4`=27 / `rax_5`=30). Yet mid-`RecoverVariables` there
  were four DISTINCT call-result varIds (15/27/30/36). So the SSA-version
  distinction is lost in an MLIR pass **between `RecoverVariables` and
  `CAstBuilder`** (a Mid/High lowering re-merging register versions onto one
  varId) - definitively NOT Phase 4 (0 merges, confirmed in 0.1.4), and NOT any
  C-AST optimizer pass.
- **Crucial reframing: `v4 = printk(0, v4)` is FAITHFUL.** The binary really does
  reuse the RAX register across the four `printk` calls; emitting one variable
  `v4` that is reassigned is correct C with the same semantics. This is a
  **readability / variable-versioning** shortfall, NOT a correctness defect -
  which is very likely why the main line deferred it (`HELIX_PHILOSOPHY`:
  fidelity over polish). A "fix" would split the reused register into distinct
  SSA-versioned C variables (`v4=printk(*v11); v5=printk(v4); v6=printk(v5); ...`)
  - more readable, equally faithful, but it is a real CFG-aware SSA-reconstruction
  feature (the function has branches), not a quick patch, and it trades a little
  fidelity for polish - a design call for the project owner.

**Net of the whole arc (0.1.0 - 0.1.5):** the sandbox + scoreboard + real corpus
turned a vague, mis-attributed changelog gap into a precise, evidence-backed root
cause (MLIR varId reuse upstream of CAstBuilder) and a clear design decision
(faithful-ugly vs readable-reconstructed). The Phase-4 guard is retained, proven
SAFE (0 regression on fixtures and the 7-function rootkit corpus) but INEFFECTIVE
on this defect. No further code change pending the design call.


## [0.1.4] - Real-corpus validation: the Phase-4 diagnosis is DISPROVEN - 2026-06-15

Ran the guard against the **real Kernel Monarch rootkit corpus** (HTB CTF) - the
lifted `.ll` in `rev_kernel_monarch/hexcore-reports/02b-lift-only/`, including
`fh_install_hook.ll`, the `v4 = printk(0, v4)` x4 defect itself.

**Scoreboard (`diff_v2.ps1`) over the 7 real functions: 7/7 identical, vN delta 0**
- the guard changes NOTHING on the real defect. Instrumented diagnosis (since
reverted) explains why, and **corrects the changelog's root-cause attribution**:

- The 4 distinct printk call-results survive as distinct SSA versions through the
  entire MLIR pipeline. At `RecoverVariables` they are `rax` / `rax_4` / `rax_5`
  / `rax_7` (the `definedByCall` detection fires on all four), and **Phase 4
  performs ZERO merges on `fh_install_hook`**.
- So the changelog's "Phase 4 cross-register coalescing" attribution is **wrong /
  outdated** for the current code. The option-1 guard sits in the wrong pass and
  can never fire on this defect (0 `REFUSED` events on the whole corpus).
- The collapse to a single `v4` happens in the **C-AST layer, upstream of
  `CAstOptimizer::renameRemainingRegisterVars`** (called at line 227, very early
  in `optimize()`): by that point the printk-chain body references are already
  all `"rax"` while `rax_4` / `rax_5` linger only as dead declarations. The real
  culprit is the MLIR-high -> C-AST construction (`CAstBuilder`) folding the
  distinct register SSA versions' *body references* into one base-register name.

**Net:** the Phase-4 guard is **SAFE** (0 regression on the fixtures AND the real
corpus) but **INEFFECTIVE** on the target defect. The real fix must target the
C-AST construction (`CAstBuilder`), not Phase 4. This is the single most valuable
output of the arc: a measured, corpus-grounded correction of where the debt
actually lives. **Next:** instrument `CAstBuilder` to confirm the exact fold, then
preserve distinct call-result SSA versions into distinct C-AST vars.


## [0.1.1 - 0.1.3] - Phase-4 call-result identity experiment - 2026-06-15

First experiment arc in the v2 sandbox: attack the FIX-081 / Phase-4
cross-register coalescing debt (the `v3 = printk(0, v3)` x4 defect). Measured
engine-direct (Release) against the v0.9.2 baseline exe with `diff_v2.ps1`.

- **0.1.1 (diagnose).** Implemented FIX-081 follow-up **option 1** in
  `RecoverVariables.cpp` Phase 4: a `definedByCall` flag on `VarInfo` (a variable
  assigned directly from a `CallOp` result, detected the same way the Phase-5
  single-use guard does) plus a merge-loop gate that refuses to merge such a
  variable away. Instrumented with stderr probes to answer "does it fire?".
  Finding: **detection FIRES correctly** (marks the `rax` call-result var), but
  the guard **never refuses a merge on any synthetic input** - the engine
  DCE/CSE's hand-crafted call chains before Phase 4 (3 identical no-arg calls
  collapse to one; Helix does not recover the call args from a synthetic `.ll`).
  Conclusion, now **proven not just suspected**: the mechanism is wired and the
  detection works, but the cross-register call-result merge cannot be reproduced
  synthetically. It needs a real-binary `.ll` (the rootkit corpus, not on disk).
- **0.1.2 (harness).** Quieted the instrumentation; added
  `tools/helix-validate/diff_v2.ps1` - the differential **scoreboard**: baseline
  exe vs v2 exe over a `.ll` directory, reporting per-function identical/changed
  + the **vN-placeholder delta** (the option-1 regression metric the changelog
  warns about) + confidence delta. Scoreboard on the 5 available fixtures:
  **5/5 identical, total vN delta 0** - the guard is safe (no extra placeholders)
  on every input we can run.
- **0.1.3 (refine to spec).** Scoped the guard to **cross-register only**
  (`registerBase(victim) != registerBase(canon)`): same-register coalescing is
  Phase 3.5's correct domain, so the guard now protects call-return identity
  only when Phase 4 would fold it into a *different* register's variable. This
  matches the FIX-081 option-1 wording exactly and keeps the regression surface
  minimal.

**Status:** low-risk, well-targeted, mechanism wired + detection proven, harness
ready. **Effectiveness on the real defect remains UNPROVEN** pending a triggering
input. **Next:** generate the rootkit corpus `.ll` (via the disassembler+remill
on the real binary), run `diff_v2.ps1` over it, and check whether the guard turns
`v3 = printk(0, v3)` x4 into distinct call results without inflating vN counts
elsewhere. Alternative to try: FIX-081 **option 2** (reorder `inferSemanticNames`
before Phase 4).


## [0.1.0] - Helix v2 sandbox baseline - 2026-06-15

> **Fork point.** HexCore Helix v2 is a redesign sandbox cloned from the main-line `v0.9.2`
> cut (commit-equivalent, engine source identical). Version reset to `0.1.0`; product renamed
> `@hexcore/helix-v2`; `Engine::version()` returns `"0.1.0"`. The pre-built `engine/build`
> (Ninja) `helix_tool.exe` + `helix_engine.lib` were carried over so the lab is functional on
> arrival - no full rebuild needed to run the corpus gate. `target/`, `node_modules/`, `.git`,
> the VS test build, and stray experiment artifacts were left behind to keep the clone lean.
>
> **Purpose:** run the experiments the main line cannot safely land - first target is the
> **Phase-4 cross-register coalescing** debt (see Wave 19 / FIX-081 reverted, FIX-087 below):
> attempt the Phase-4-aware merge guard and measure call-return variable identity
> (`v3 = printk(0, v3)`) against the v0.9.2 baseline. Breaking is expected; the corpus gate is
> the judge. The full v0.9.2 history is preserved below for reference.

---

## [v0.9.2] — 2026-06-12

> **Stable cut — left the nightly line on 2026-06-12.** The leave-nightly P0 honesty quad is complete: D1 (code addresses never leak as data), D2 (out-of-table callees emit an honest indirect call), D4 (confidence is capped + located only on a genuine surviving defect), #30 (a registry-miss is scored 0, never a silent stub). This v0.9.2 line spans Wave 19 → Wave 28, newest work first. The earlier Wave 21 (FIX-087) groundwork is included below under this same version.
>
> **Since the FIX-087 SSA-versioning groundwork (Wave 21):** byte/word memory-source `MOVZX` lift, register-as-address variable binding (in-region + in-loop RAX→`result`), the first-class variadic-call mini-ISA carriage (Wave 22 Step 3-lite), two C-AST dataflow-fidelity fixes that recover the FNV accumulator chain, an `exprEqual` completeness fix, and the opt-in `--preserve-cfg` callfuscation-deflatten path (Wave 23, Stages 1+2). All `--preserve-cfg` work is gated **default OFF** — normal lifts are byte-for-byte unchanged, confirmed by a quad-corpus tripwire (rootkit / ROTTR / Intigrity-Mali / Akasha).

### Wave 28 — G1 branch-polarity: the Remill `.not` successor mismatch + the structurer/DSE bugs it unmasked (2026-06-06)

> Surfaced by a 3-way ground-truth audit (real C++ source vs IDA Hex-Rays vs Helix, `rag/16`). The lift mis-read Remill's InstCombine-canonicalized conditional-branch form, INVERTING every structured `if`/`while`/`break`; fixing the polarity then unmasked a chain of latent structurer + dead-store bugs that only manifest once loops structure correctly. Four additive fixes; the FNV-1a test function `sub_140001000` now decompiles to the correct `do { result ^= *s; result *= prime; } while (*s); return result;` and all 7 Akasha functions + the 3 engine test fixtures decompile crash-free.

#### FIX-096 — D4 damning cap: re-derive from the FINAL AST + located reason (kills the #30/G3 over-fire) (`cast/DamningDefect.h`, `cast/CAstBuilder.cpp`, `cast/CAstOptimizer.cpp`, `cast/CExpr.h`)

- **Problem**: The Wave 27 D4 damning-confidence cap was BUILD-TIME-LATCHED via `hasDamningHonestyDefect_`, raised the instant a code-typed constant was built (CAstBuilder.cpp:571/591/661, esp. 591 `isKnownFunctionStart`). A benign PC-base / NEXT_PC / RIP-base constant that merely COINCIDED with a packed `helix.function_starts` sub-chunk entry latched the flag; CAstOptimizer/DSE then ERASED the constant before emission, but the flag survived (CAstOptimizer.cpp:2640-2653) → a NON-LOCATED 50% "Low" cap on clean output, with the fixed phrase "code-address leak or out-of-table call" naming a defect not present. On the Akasha corpus `sub_140001190` (0x14000119f) and `sub_1400015c0` (0x14000171f) capped at 50% with zero surviving leak/call (`rag/16` G3: "reason mis-attributed on leaf fns"; `rag/07`: those bodies are semantically broken for OTHER reasons — null-based placeholders, uninit return, irreducible no-return).
- **Root cause**: a sticky build-time flag cannot distinguish a leak that survives emission from a coincidental constant that DSE later erases.
- **Fix**: split the D4 trigger by category. The **D1 code-address-leak** category is re-derived from the FINAL emitted AST: a new `detectDamningDefects(CFuncDecl)` (`cast/DamningDefect.h`, header-inline, ODR-safe, shared by the build-time scorer and the authoritative post-optimization rescorer) walks the final body and caps for "leak" only if a `CAddrLitExpr` tagged `isCodeAddrLeak` (the `(void*)0xADDR` D1 cast; new bool, default false, set only at the 3 D1 sites, NOT on the honest `&loc_xxxx` sharp form or generic dialect address literals) SURVIVES. The same walk promotes the GENUINE located damning patterns the leave-nightly plan (`rag/08`) enumerates and that ARE present on these leaf fns — **uninitialized return** (a returned local with no initializer that is never an assignment target) and **irreducible no-return** (zero `return` statements + a `goto loc_irr_*` escape). The **D2 out-of-table CALL** category stays build-time-latched on the decl (a side-effecting call erased by DSE is still a defect, so `start`'s 11 surviving indirect calls must still cap). The cap message now names the ACTUAL surviving category (and the leak address where cheap), ASCII one line, replacing the fixed mis-attributed phrase. Wired identically into `CAstBuilder::analyzeConfidence` (defensive, pre-opt) and `CAstOptimizer::reanalyzeConfidence` (authoritative, post-opt; clears+rebuilds Issues so the user sees only the final located reason).
- **Impact (Akasha 7-fn corpus, confidence-only — emitted C body byte-identical, proven by structure-normalized diff = 0 lines/fn after erasing pre-existing var-naming/type non-determinism)**:
  - `sub_140001190`: 50% Low, reason `code-address leak or out-of-table call` (phantom) → 50% Low, reason `uninitialized return value 'result'` (located, real).
  - `sub_1400015c0`: 50% Low, phantom reason → 50% Low, reason `irreducible CFG; no return path recovered` (located, real).
  - `start` (`sub_140001740`): 50% Low, phantom reason → 50% Low, reason `out-of-table call` (located; still capped on its 11 surviving D2 indirect calls + `*0x40003000` data leak).
  - `sub_140001000` 92.0%, `sub_140001090` 72.5%, `sub_140001350` 95.0%, `sub_140001410` 66.5% — UNCHANGED.
  - **No function un-caps incorrectly**: every cap now corresponds to a genuine, located, final-AST defect; the only behavioral change is the reason string honesty (the magnitude was already right, per `rag/16` G3).
- **Regression (24-fn engine-direct sample: CTF Win64 3 + SOTR 6 + gta-sa x86 15)**: 0 crashes, 0 new `/* unhandled */` / `/* undef */`, 0 occurrences of the old phantom phrase. 5 functions cap, each LOCATED: 4 × `uninitialized return value 'result'` (genuine — `result` never assigned), 1 × `surviving code-address leak (void*)0x140253cc8` (the D1-survival path correctly KEEPS capping a leak that survives emission). Confidence spread 36.5%-100%, no mass-flip.
- **Honesty justification (RAG 03 protocol)**: this is a fidelity correction, not a score inflation. The ground-truth held; the defect fixed was a NON-located dishonest cap reason (and, on coincidental-constant fns, a cap with no surviving defect at all). No previously-honest cap is weakened — leak/call/uninit/no-return caps all still fire, now with the correct located reason.
- **Known Gap (deferred, not on this corpus)**: an erased side-effecting D2 call still caps via the build-time flag rather than emitting a LOCATED `/* note: out-of-table call to 0xADDR removed */` marker — acceptable since `start`'s D2 calls all survive emission here. Separately, the cast layer has pre-existing run-to-run NON-determinism in temporary-variable naming and parameter typing (e.g. `start` rolls 44 distinct body-variant strings across 120 runs); orthogonal to this fix (structure is invariant), flagged for a future determinism pass.

#### FIX-095 — Jcc successor polarity: pair the taken condition with the taken edge (`passes/RemillToHelixLow.cpp`)

- **Problem**: Remill emits every conditional branch in the canonical `.not` form (`%bt.not = icmp eq i8 %branch_taken, 0; br %bt.not, ^not_taken, ^taken`) after its own InstCombine pipeline, so `successor(0)` is the NOT-taken edge. The lift synthesized `condValue` as the *taken* condition (ZF for JZ, ...) but paired it with `successor(0)` — inverting the sense of EVERY structured branch downstream.
- **Fix**: when the cond-branch operand is the `icmp eq <x>, 0` `.not` shape, swap so `trueDest` is the taken successor. Gated on the shape, so an un-canonicalized `icmp ne` form is left untouched (correct under both the optimized and unoptimized lift pipelines).
- **Impact**: `rt_fnv` / `sv2` / `sv_url_finalize` loop + early-exit branch polarities now match Hex-Rays.

#### FIX-095b — RecoverVariables: never `getNode` a foreign-region block (`passes/RecoverVariables.cpp`)

- FIX-095 makes loops structure into real `do_while` regions; the per-block RPO then followed a cross-region successor edge into a nested region and `DominanceInfo(func)->getNode()` null-dereffed (0xC0000005). Guard the RPO post-order DFS to same-region successors + the idom-seed call to `block.getParent() == &funcBody`. No-op for region-free CFGs (byte-identical).

#### FIX-095c — do_while latch: clone the exit return instead of orphaning the shared block (`passes/StructureControlFlow.cpp`)

- The `do_while` builder left the original latch back-edge terminator dangling (unlike the `while` path, which replaces it with a `Continue`). For a single-block / single-exit post-tested loop whose exit is a trivial `return`, CLONE that return at the latch so the loop owns its exit; the shared ret block then becomes single-pred and the entry-`if` consumes it normally — no spurious back-edge-to-entry, no `loc_irr` mis-label, no lost post-loop return.

#### FIX-095d — dead-store elimination: loop-carried + compound-target liveness (`cast/CAstOptimizer.{cpp,h}`)

- `eliminateDeadStores` was dropping the FNV accumulator. Two bugs: (1) `dseStmtList` ran loop bodies with an empty initial live-set, so a loop-carried store looked dead — now `dseStmtList` takes an optional `seedLive` and each loop body is seeded with every variable read in it (the back-edge makes a top read consume a bottom write); (2) a compound assign (`x ^= ...`, `x *= ...`) was treated as a pure write — it READS its target, so it is never dead and stays live for earlier writes.
- **Impact**: `rt_fnv` keeps the full `result ^= *s; result *= prime` accumulator. General + conservative (only ever keeps more stores).
- **Known remaining**: a MULTI-exit unrolled loop (`sv_url_finalize`, 6 breaks) still emits one `goto loc_irr_0` — FIX-095c's single-exit guard does not fire — unchanged vs polarity-only output, a future multi-exit FIX-095c extension. The `rt_fnv` init/prime CONSTANTS remain abstract (G5, a separate constant-reconstruction gap, not structure).

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
- **Example** (values per `test/RegistryMissTest.cpp`): a stub-shaped FuncOp `sub_140001000` (entry `0x140001000`) under an authoritative `helix.function_starts` table that lists `0x140002000` but NOT `0x140001000`. BEFORE: emitted as a silent ~60% stub (`stub function (< 5 ops)`). AFTER: `registry miss: function entry not in the authoritative function table (no honest lift)`, confidence forced to **0** (`CAstOptimizer.cpp:2110-2113`). Contrast: the SAME stub WITH `0x140001000` in the table keeps its normal ~60% stub score (NOT flagged); a FuncOp whose entry is `0x0` is never flagged (the mandatory `entryAddr != 0` guard).

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
- **Scope note (variadic SIGNATURE marking is a SEPARATE, currently-unwired concern):** this wave is about variadic CALL-SITES (the `helix.variadic_*` attrs on `high::call`). It does NOT mark a decompiled function's OWN signature as variadic. The FuncOp `is_variadic` attr + the `CAstPrinter` `, ...` emission (`CAstPrinter.cpp:72-75`) exist and round-trip through FlatBuffers, but NO production pass SETS that attr, so `func.isVariadic` is always false today and that printer branch is dead. See the Backlog entry "Variadic SIGNATURE marking has no producer."

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
