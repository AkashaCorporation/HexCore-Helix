# Helix Decompiler — Philosophy & Quality Criteria

## What Helix IS

Helix is a **formally-structured decompiler** built on LLVM/MLIR.
It prioritizes **semantic correctness** over cosmetic polish.

### Core principles

1. **Fidelity first** — the output must faithfully represent what the binary does.
   A verbose-but-correct `x = x + 1` beats a pretty-but-wrong `x++` that hides
   carry-flag semantics.

2. **Provable transforms only** — every simplification (compound assignment,
   dead-code elimination, copy propagation) is an MLIR pass that can be tested
   and verified in isolation. No ad-hoc pattern matching.

3. **Confidence transparency** — Helix emits confidence headers that tell the
   user what is proven vs. what is a heuristic guess. IDA/Ghidra don't do this.

4. **Progressive improvement** — each version adds one or two new passes.
   Quality improves monotonically because passes compose.

## What Helix is NOT

- **Not an IDA clone.** IDA has 20+ years of heuristics, FLIRT signatures, and
  massive type libraries. Helix doesn't try to replicate that polish.
- **Not a beautifier.** The goal is not "pretty C" but "correct C that a
  reverse engineer can reason about."
- **Not finished.** Helix is a research-grade tool under active development.

## Pipeline (how output is generated)

```
Binary → Remill IR (LLVM) → Helix Low dialect → Helix Mid dialect
    → Helix High dialect → C-AST → Pseudo-C output
```

Each arrow is a set of MLIR passes. Bugs or regressions are traceable to a
specific pass.

## Quality criteria for evaluating changes

### Improvements (KEEP)
- A pass that **reduces** emitted lines without losing information
- Compound operators (`+=`, `-=`) when the transform is **provably correct**
- Better variable names from dataflow analysis
- Correct return value propagation
- Removing false zero-initializations (`result = 0` when value is unknown)
- Adding address annotations for traceability

### Regressions (REVERT)
- Removing a working pass (e.g., deleting compound assignment detection)
- Making output more verbose without adding information
- Losing address/confidence metadata
- Introducing false constants (e.g., `return 0` when return value is unknown)
- Breaking the MLIR pass pipeline ordering

### Neutral (evaluate case-by-case)
- Cosmetic reformatting (line breaks, spacing)
- Moving code between files without semantic change
- Adding test cases (generally good, but check they test real behavior)

## How to test a change

1. Pick 2-3 reference binaries (small functions with known behavior)
2. Decompile BEFORE the change, save output
3. Apply the change, rebuild engine + .node
4. Decompile AFTER, diff the outputs
5. For each diff: is the NEW output more correct? More readable? Or worse?

## Known reference binaries

| Binary | Why it's useful |
|--------|----------------|
| bone_pos_calc | Arithmetic, struct access, loops — tests compound assignment |
| projectile_constructor | Constructor pattern, pointer math |
| mali_kbase (Pathfinder) | Large real-world binary, 3864 functions |

## Version history of major passes

| Version | Pass added | Impact |
|---------|-----------|--------|
| v0.8.0  | SCC irreducible CFG, type recovery, cast layer | Foundation |
| v0.9.0  | Call dataflow refactor, CC recovery, waves 1-12 | Major quality jump |
| v0.9.1  | PE lift-path, ELF cleanup, confidence honesty | Correctness |
