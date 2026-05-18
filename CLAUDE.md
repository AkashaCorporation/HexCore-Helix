# HexCore Helix — Agent Instructions

## Quick Start

Read `.claude/agents/helix-engine-guide.md` before touching any code.
It covers: project layout, build process, pass order, current defects, and validation.

## Build Rules

- **ALWAYS use .bat scripts** — never invoke cmake/ninja manually
- **3-step NAPI build** — copy lib → clear fingerprints → build_napi.bat (skipping step 2 = stale .node)
- **Close VSCode** before copying .node to extensions
- Full reference: `.claude/agents/helix-builder.md`

## Code Rules

- **NEVER delete working passes** — a pass that exists was earned through testing
- **NEVER edit PseudoCEmitter.cpp** — it's legacy since v0.8.0
- **Measure with helix-validate** before AND after changes — no eyeball-only evaluation
- Run: `python tools/helix-validate/helix_validate.py <dir_or_file>`

## Current Tasks (priority order)

1. **Operand binding fix** — `.claude/agents/task-operand-binding-fix.md`
2. **Relocation symbols** — `.claude/agents/task-relocation-symbols.md`

## Git

- Co-author: `Co-authored-by: MayaRomanova <maya@anthropic.com>`
- vscode-main commits: use `--no-verify`
- DO NOT commit: `*.bat`, `*.cmd`, `build_out.txt`, `*.helix.c`, `node_modules/`, `target/`, `engine/build/`

## Philosophy

See `HELIX_PHILOSOPHY.md`. TL;DR: fidelity > polish, provable transforms, NOT an IDA clone.

## Test Corpus

```
C:\Users\Mazum\Desktop\a1b6d665-96d4-4884-bf11-87dff33713d2-1778066531\
  rev_kernel_monarch\hexcore-reports\
    02-disasm\    — 7 decompiled .helix.c files (Linux ftrace rootkit)
    02b-lift-only\ — corresponding .ll files (Remill IR)
```
