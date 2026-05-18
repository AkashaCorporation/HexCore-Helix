# Task: Fix Operand Binding Loss in HelixMidToHigh

> Priority: HIGHEST. This is the #1 quality defect in Helix output.
> Read `helix-engine-guide.md` FIRST for project context.

## Problem

Two different SSA values from different source registers get the same variable
name after HelixMidToHigh lowering. This causes:

1. **Self-doubling**: `v5 += v5 + 208` (means `2*v5 + 208`, should be `v5 + 208`)
2. **Pointer self-store**: `*v3 = v3 + v3` repeated 8 times (should be stores to different offsets)
3. **Repeated identical calls**: `printk(0, v3)` x3 (should have different args)

## Root Cause

In `engine/src/passes/HelixMidToHigh.cpp`, when the pass converts HelixMid SSA
values to HelixHigh VarRef operations, it assigns names based on the original
register (e.g., `v3` for anything that came from a particular register). But in
SSA, the same register at different program points holds different values.

Example from `fh_install_hooks`:
```llvm
; In the .ll, these are DIFFERENT SSA values:
%42 = call i64 @__remill_read_memory_64(ptr %mem, i64 %rbx_plus_0)   ; load struct field 0
%51 = call i64 @__remill_read_memory_64(ptr %mem, i64 %rbx_plus_8)   ; load struct field 1
%60 = call i64 @__remill_read_memory_64(ptr %mem, i64 %rbx_plus_16)  ; load struct field 2
```

But after HelixMidToHigh, all three become `v3` because they all came from
operations involving the same base register. The stores then become:
```c
*v3 = v3 + v3;  // should be: hook->field_0 = value_0;
*v3 = v3 + v3;  // should be: hook->field_1 = value_1;
```

## Where to Look

### Primary file: `engine/src/passes/HelixMidToHigh.cpp`

Look for:
- How VarRef names are assigned from SSA values
- The naming heuristic that maps registers → variable names
- Any dedup or collision handling when two SSA values get the same name

### Secondary files:
- `engine/src/passes/HelixLowToMid.cpp` — where register→variable promotion happens
- `engine/src/cast/CAstBuilder.cpp` — `exprToBestName_` map that also collapses names

## What a Fix Looks Like

The fix should ensure that **distinct SSA values at distinct program points get
distinct names**, even if they originate from the same physical register.

Approaches (in order of preference):

### A. SSA-aware naming in HelixMidToHigh
Instead of naming by register alone, include the SSA version:
- `v3_0`, `v3_1`, `v3_2` for three different values from the same register
- Or use the block+index: `v3_bb2`, `v3_bb5`

### B. Conflict detection in CAstBuilder
When `exprToBestName_` would assign the same name to two different MLIR Values,
append a suffix to disambiguate.

### C. Use-def chain aware naming
Track which definition each use refers to. If a VarRef is used in a store
target and the same name appears in the store value, and they refer to different
definitions, rename one.

## Validation

After the fix, run:
```bash
python tools/helix-validate/helix_validate.py "C:/Users/Mazum/Desktop/a1b6d665-96d4-4884-bf11-87dff33713d2-1778066531/rev_kernel_monarch/hexcore-reports/02-disasm/"
```

Expected improvements:
- `fh_install_hook`: score should go from 0.0% to 40%+
- `fh_install_hooks`: score should go from 0.0% to 40%+
- `suspicious_self_reference` findings should decrease significantly
- `repeated_identical_side_effect` findings should decrease

## Test Cases

The corpus at `C:\Users\Mazum\Desktop\a1b6d665-96d4-4884-bf11-87dff33713d2-1778066531\rev_kernel_monarch\hexcore-reports\` has:
- `02-disasm/*.helix.c` — current Helix output (7 functions)
- `02b-lift-only/*.ll` — the lifted LLVM IR input

Focus on `fh_install_hooks` (worst case, score 0.0%) and `hook_read` (medium case, score 57.2%).

## Corpus Analysis (2026-05-17)

Full analysis of 7 functions from Linux ftrace rootkit (malware.ko):

| Function | Score | Conf | Main defects |
|----------|-------|------|-------------|
| fh_ftrace_thunk | 79% | 82% | OK (stub) |
| hook_syslog | 72% | 82% | OK (stub) |
| hook_read | 57% | 67% | self-ref, native opcodes, unreachable |
| hook_write | 56% | 75% | self-ref, native opcodes, unreachable |
| fh_install_hook.cold | 24% | 75% | self-ref, unreachable |
| fh_install_hook | 0% | 75% | self-doubling, pointer self-store x8, repeated calls |
| fh_install_hooks | 0% | 62% | same as fh_install_hook |

### Specific operand binding examples to fix:

1. `v5 += v5 + 208` — iterator advancement in fh_install_hook loop
   - Should be: `v5 += 208` (advancing by sizeof(ftrace_hook))
   - The second `v5` in RHS is a DIFFERENT SSA value

2. `*v3 = v3 + v3` x8 — struct field initialization in fh_install_hook
   - Should be: `hook->field_N = value_N` for 8 different fields
   - All collapsed to same variable name

3. `v0 = v0->r12` — struct member load in hook_write/hook_read
   - Should be: `v0 = regs->r12` (different base objects)

4. `printk(0, v3)` x4 — logging calls with different format args
   - Should be: `printk(fmt1, arg1)`, `printk(fmt2, arg2)`, etc.
   - All args collapsed to `v3`

### Patterns that are NOT operand binding (separate fixes needed):
- `rep_while_equal_string_compare_byte` → needs decomposeNativeOpcodes pattern for `repe cmpsb`
- `return result; kfree(ptr);` → needs unreachable-after-return elimination in optimizer

## What NOT to Do

- Do NOT delete any existing passes or detection logic
- Do NOT change the compound assignment detection
- Do NOT modify PseudoCEmitter.cpp (legacy)
- Do NOT skip the 3-step NAPI build process
- Do NOT evaluate changes by eyeballing — use helix-validate scores
