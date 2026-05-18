# Task: Propagate Relocation Symbols to Data References

> Priority: #2 after operand binding fix.
> Read `helix-engine-guide.md` FIRST for project context.

## Problem

The Helix engine emits raw literal addresses like `*0x7FFF0038` in the C
output, even though the MLIR contains relocation metadata mapping these
addresses to symbols like `__this_module`.

Current output:
```c
v6 = *0x7FFF0038;          // should be: v6 = __this_module;
*0x7FFF0038 = v3;          // should be: __this_module = v3;
v2 = __this_module(0);     // WRONG: calling a data symbol as function
```

## Root Cause

`engine/src/analysis/SignatureDb.cpp` already parses `__hxreloc__` declarations
from the LLVM IR and builds a `relocMap`:

```cpp
// Line ~177-198 in SignatureDb.cpp
// Format: @__hxreloc__<16-hex-addr>__<symbol_name>
// Example: @__hxreloc__00007FFF00000038__this_module
```

But this map is ONLY used to resolve **call targets** (Phase 2b, line ~251).
It is NOT used for:
- Load operations (`v6 = *0x7FFF0038`)
- Store operations (`*0x7FFF0038 = v3`)

## What Needs to Change

### Option A: Resolve in HelixLow/HelixMid (preferred)
In `RemillToHelixLow.cpp` or `HelixLowToMid.cpp`, when a load/store uses an
address that matches the relocation map, replace the raw address with a
symbolic reference.

### Option B: Resolve in CAstBuilder/CAstOptimizer
Add a pass that walks the C-AST and replaces `IntLitExpr` nodes whose value
matches a relocation address with `VarRefExpr` nodes using the symbol name.

### Option C: Emit as comment (minimal)
Keep the raw address but add a comment: `*0x7FFF0038 /* __this_module */`.

## Where the Relocation Map Lives

```cpp
// SignatureDb.cpp, around line 181
llvm::DenseMap<uint64_t, std::string> relocMap;

// Populated from IR declarations like:
// declare void @__hxreloc__00007FFF00000038____this_module(...)
```

The map needs to be accessible from the CAstBuilder or the MLIR passes.
Currently it's local to `resolveCallTargets()`.

## Also Fix: Data Symbol Called as Function

The output shows `v2 = __this_module(0);` — this is a data symbol being
emitted as a function call. The relocation metadata says `__this_module` is
a data reference (a global variable), not a function. The engine should:
1. Distinguish data relocations from function relocations
2. Emit data references as loads, not calls

## Validation

```bash
python tools/helix-validate/helix_math_validate.py <file.helix.c> --mlir-before <file.ll>
```

Expected: `raw_relocation_deref` and `relocated_symbol_called` findings should
disappear.
