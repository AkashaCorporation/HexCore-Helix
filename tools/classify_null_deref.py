#!/usr/bin/env python3
"""Classify every null_deref_placeholder finding across the 3 corpora.

For each *.helix.c, find vars declared with `= 0` / `= (void*)0` / `= NULL`
and look for derefs of them. Bucket each finding:
  A) reassigned BEFORE first deref (validator false-positive — but the
     validator walks the body so it should already exclude these)
  B) never reassigned but dereferenced (real bug in output)
  C) reassigned only AFTER deref / on same line as deref (lift-order bug)
"""
import re
import sys
from pathlib import Path

DECL_RE = re.compile(r"^\s*(?:int64_t|void\*|int\d+_t|uint\d+_t)\s+([A-Za-z_]\w*)\s*=\s*(0|\(void\*\)0|NULL)\s*;")
ASSIGN_RE = re.compile(r"^\s*([A-Za-z_]\w*)\s*=\s*[^=]")
DEREF_RE = re.compile(r"\*\s*([A-Za-z_]\w*)\b")

TMP = Path("C:/Users/Mazum/AppData/Local/Temp")
import sys
SUFFIX = sys.argv[1] if len(sys.argv) > 1 else ""
CORPORA = [
    ("rootkit",   TMP / f"helix-rootkit{SUFFIX}"),
    ("rottr",     TMP / f"helix-rottr{SUFFIX}"),
    ("intigrity", TMP / f"helix-intigrity{SUFFIX}"),
]

def classify(text, name):
    """Yields (var, category, line_no, line_text) per null_deref event."""
    body_start = None
    lines = text.splitlines()
    for i, line in enumerate(lines):
        if "{" in line and body_start is None:
            body_start = i + 1
    if body_start is None:
        return
    zero_vars = {}
    for i, line in enumerate(lines[body_start:], start=body_start):
        m = DECL_RE.match(line)
        if m:
            zero_vars[m.group(1)] = i
    written = set()
    for i, line in enumerate(lines[body_start:], start=body_start):
        derefs = [m.group(1) for m in DEREF_RE.finditer(line)]
        for v in derefs:
            if v in zero_vars and v not in written:
                later_assign = any(
                    ASSIGN_RE.match(lines[j]) and ASSIGN_RE.match(lines[j]).group(1) == v
                    for j in range(i+1, len(lines))
                )
                cat = "C-write-later" if later_assign else "B-never-written"
                yield (v, cat, i+1, line.strip())
        am = ASSIGN_RE.match(line)
        if am and am.group(1) in zero_vars:
            written.add(am.group(1))

totals = {"B-never-written": 0, "C-write-later": 0}
per_func = []

for corpus, root in CORPORA:
    if not root.exists():
        continue
    for p in sorted(root.glob("*.helix.c")):
        text = p.read_text(encoding="utf-8", errors="replace")
        events = list(classify(text, p.stem))
        if not events:
            continue
        b = sum(1 for e in events if e[1] == "B-never-written")
        c = sum(1 for e in events if e[1] == "C-write-later")
        totals["B-never-written"] += b
        totals["C-write-later"] += c
        per_func.append((corpus, p.stem, b, c, events))

print("=== Per-function null_deref classification ===\n")
print(f"{'Corpus':<10} {'Function':<35} {'B-never':>8} {'C-later':>8}")
for corpus, fn, b, c, _ in per_func:
    print(f"{corpus:<10} {fn[:35]:<35} {b:>8} {c:>8}")

print("\n=== Totals ===")
print(f"  B (declared=0, dereferenced, NEVER written):  {totals['B-never-written']:>3}")
print(f"  C (declared=0, dereferenced, written later):  {totals['C-write-later']:>3}")

print("\n=== Sample events (first 12) ===")
shown = 0
for corpus, fn, _, _, events in per_func:
    for v, cat, ln, line in events:
        if shown >= 12:
            break
        print(f"  [{corpus}] {fn}:{ln}  {cat}  var={v}")
        print(f"      {line}")
        shown += 1
    if shown >= 12:
        break
