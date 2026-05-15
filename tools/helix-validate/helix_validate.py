#!/usr/bin/env python3
"""helix-validate — mathematical quality assessment for Helix decompiler output.

Layer 1: degenerate-construct detection via dataflow theorems.
Layer 2: bounded confidence scoring (provably in [0, 1]).
Layer 3: cross-version delta + corpus-level rollup.

Zero external dependencies — stdlib only.

Usage:
    helix_validate.py FILE_OR_DIR [--baseline DIR] [--json OUT.json] [--quiet]

Outputs a per-function stdout report. With --json, also writes a machine-readable
report. With --baseline DIR, computes Δscore per function vs the baseline.

This is a measurement instrument — it never modifies the inputs.

Why this exists
---------------
HexCore Helix hit a quality ceiling: improvements cannot be *proved* better with
line-count vs. self-reported confidence proxies. Output rated `Confidence: 91%
(High)` can contain a `*v = v + v` null deref or a `v6 ++ v6 + 1` syntax-broken
statement — and we saw it in v0.9.1-nightly outputs. This script formalises the
check as dataflow theorems plus a bounded score, so two versions can be compared
with a single monotone number rather than eyeballing diffs.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Iterable


# ── L1 detector framework ─────────────────────────────────────────────────────


@dataclass
class Finding:
    """A single Layer-1 finding: a *theorem-backed* defect in the output.

    `kind` is the rule that fired; `line` is 1-based; `evidence` is the source
    snippet; `theorem` is the one-line justification for why this is a
    defect, not a style preference.
    """
    kind: str
    line: int
    evidence: str
    theorem: str


@dataclass
class FunctionReport:
    name: str
    file: str
    reported_confidence: float | None    # what Helix self-reports
    line_count: int
    findings: list[Finding] = field(default_factory=list)
    # Sub-scores (each provably in [0, 1] — see _bounded() helpers below).
    name_quality: float = 0.0
    struct_recovery: float = 0.0
    call_resolution: float = 0.0
    flow_regularity: float = 0.0
    # Final composite score, computed by Layer 2.
    score: float = 0.0
    # Bookkeeping (not part of the score; useful for the paper tables).
    placeholder_decls: list[str] = field(default_factory=list)


# ── Tokenisation / function extraction ────────────────────────────────────────


HEADER_RE = re.compile(r"//\s*(\S[^\n]*)")
CONFIDENCE_RE = re.compile(r"Confidence:\s*([\d.]+)\s*%")
NAME_FROM_HEADER_RE = re.compile(r"^//\s*([A-Za-z_][\w.]*)\s*(?:\([^)]*\))?\s*$")
# A function definition opens a brace at end-of-line after a parameter list.
FUNC_DEF_RE = re.compile(
    r"^(?P<ret>[\w\s\*]+?)\s+"
    r"(?P<name>[A-Za-z_][\w.]*)\s*"
    r"\((?P<params>[^)]*)\)\s*\{?\s*$"
)
DECL_RE = re.compile(
    r"^\s*(?:void\*|[\w_]+(?:\s+\*)?|int\d+_t|uint\d+_t)\s+"
    r"(?P<var>[A-Za-z_]\w*)\s*"
    r"(?:=\s*(?P<init>[^;]+?))?\s*;"
)
DEREF_FIELD_RE = re.compile(r"\b[\w_]+->(?P<field>field_0x[\dA-Fa-f]+|[A-Za-z_]\w*)")
CALL_RE = re.compile(r"\b(?P<callee>[A-Za-z_][\w.]*)\s*\(")
RETURN_RE = re.compile(r"^\s*return\b")
BRACE_OPEN_RE = re.compile(r"\{\s*$")
BRACE_CLOSE_RE = re.compile(r"^\s*\}")


def split_functions(text: str) -> list[tuple[str, str, list[str], float | None]]:
    """Split a Helix output into (name, body, header_lines, confidence) tuples.

    Helix emits a comment banner before each function:
        // ─────...
        // <name>
        // Confidence: NN.N% (...)
        // [Issues: ...]
        // ─────...

    We collect the banner, then bracket-match to find the function body.
    """
    out: list[tuple[str, str, list[str], float | None]] = []
    lines = text.splitlines()
    i = 0
    n = len(lines)
    while i < n:
        # Find the next "//" banner block.
        if not lines[i].startswith("//"):
            i += 1
            continue
        banner: list[str] = []
        while i < n and lines[i].startswith("//"):
            banner.append(lines[i])
            i += 1
        # Skip whitespace.
        while i < n and lines[i].strip() == "":
            i += 1
        # Expect a function definition line.
        if i >= n:
            break
        m = FUNC_DEF_RE.match(lines[i])
        if not m:
            continue
        name = m.group("name")
        # Find the matching close brace (depth tracking).
        depth = 0
        if "{" in lines[i]:
            depth += lines[i].count("{") - lines[i].count("}")
        body_start = i
        i += 1
        if depth == 0 and i < n:
            # The opening brace was on the next line.
            if "{" in lines[i]:
                depth += 1
                i += 1
        while i < n and depth > 0:
            depth += lines[i].count("{") - lines[i].count("}")
            i += 1
        body = "\n".join(lines[body_start:i])
        # Parse confidence from the banner.
        conf: float | None = None
        for bl in banner:
            cm = CONFIDENCE_RE.search(bl)
            if cm:
                try:
                    conf = float(cm.group(1))
                except ValueError:
                    pass
                break
        out.append((name, body, banner, conf))
    return out


# ── Layer 1 detectors ─────────────────────────────────────────────────────────
#
# Each detector implements a small *theorem*: a condition that, when it holds in
# the output, *provably* makes that output semantically degenerate or
# syntactically invalid. We avoid heuristics ("looks suspicious") in favour of
# rules a reviewer can defend in a paper.


# T1: a `*v` deref where `v` was declared with an initialiser that is
#     syntactically `0` / `(void*)0` / `NULL` and never reassigned between the
#     decl and the deref. By reaching-definitions, def-set(v) = {0} at the
#     deref → it is a null deref. (Theorem: dereferencing a value with a
#     singleton-zero reaching-def set is undefined behaviour.)
def detect_null_deref_of_placeholder(body: str, decls: dict[str, str | None]) -> list[Finding]:
    findings: list[Finding] = []
    # Build the set of vars whose ONLY definition is zero-initialised.
    zero_vars: set[str] = set()
    for v, init in decls.items():
        if init is None:
            continue
        s = init.strip()
        if s in ("0", "(void*)0", "NULL", "0L", "0LL", "0u", "0UL"):
            zero_vars.add(v)
    # Walk the body — first reassignment of a var removes it from `zero_vars`.
    # Any `*var` we see while var is still in `zero_vars` is the null deref.
    deref_re = re.compile(r"\*\s*([A-Za-z_]\w*)\b")
    assign_re = re.compile(r"^\s*([A-Za-z_]\w*)\s*=\s*[^=]")
    for idx, line in enumerate(body.splitlines(), start=1):
        # Detect (and record) the deref BEFORE the reassignment on the same
        # line, since `*v = expr` both dereferences and writes.
        for m in deref_re.finditer(line):
            v = m.group(1)
            if v in zero_vars:
                findings.append(Finding(
                    kind="null_deref_placeholder",
                    line=idx,
                    evidence=line.strip(),
                    theorem=(
                        f"`{v}` is declared = 0 and not reassigned before this "
                        "deref; def-set({v}) = {0} at this program point → "
                        "dereferencing it is UB."
                    ),
                ))
        am = assign_re.match(line)
        if am and am.group(1) in zero_vars:
            zero_vars.discard(am.group(1))
    return findings


# T2: x = x  (or compound `x op= 0` no-op).
#     Theorem: an assignment whose RHS is provably the value already in x has
#     no effect on the program state. (Lattice fact: identity on the type.)
def detect_identity_no_op(body: str) -> list[Finding]:
    findings: list[Finding] = []
    # x = x;   x += 0;   x -= 0;   x |= x;   x &= x;   x ^= 0;
    pat_self_assign = re.compile(r"^\s*([A-Za-z_]\w*)\s*=\s*\1\s*;")
    pat_op_zero = re.compile(r"^\s*([A-Za-z_]\w*)\s*([+\-|^])=\s*0\s*;")
    pat_self_or_and = re.compile(r"^\s*([A-Za-z_]\w*)\s*([|&])=\s*\1\s*;")
    for idx, line in enumerate(body.splitlines(), start=1):
        if pat_self_assign.match(line):
            findings.append(Finding(
                kind="identity_self_assign", line=idx, evidence=line.strip(),
                theorem="x = x is the identity transformation on x's type.",
            ))
            continue
        if pat_op_zero.match(line):
            findings.append(Finding(
                kind="identity_op_zero", line=idx, evidence=line.strip(),
                theorem="x ± 0 and x | 0 / x ^ 0 are identities; the "
                        "compound assignment has no effect.",
            ))
            continue
        if pat_self_or_and.match(line):
            findings.append(Finding(
                kind="identity_self_or_and", line=idx, evidence=line.strip(),
                theorem="x |= x and x &= x are identity ops (idempotent).",
            ))
    return findings


# T3: suspicious self-doubling — `x = x + x`, `x += x`, `x += x - C`, etc.
#     Theorem: `x = x + x` evaluates to `2*x` — *not* the identity, but a
#     non-canonical encoding of a doubling. In real machine code at this site
#     the emitter almost certainly intended `x = y + x` or similar. We flag it
#     as a *probable* misemit, not a hard correctness violation.
#
#     This catches the v0.9.1 AmmoUsage `param_2 += param_2 - 16` case, which
#     reduces to `param_2 = 2*param_2 - 16` rather than the intended
#     `param_2 = param_2 - 16`.
def detect_suspicious_self_doubling(body: str) -> list[Finding]:
    findings: list[Finding] = []
    # `x = x + ...x...` or `x += ...x...` where x appears on both sides.
    pat = re.compile(
        r"^\s*([A-Za-z_]\w*)\s*(?:=|[+\-|^&]=)\s*(.+?);"
    )
    for idx, line in enumerate(body.splitlines(), start=1):
        m = pat.match(line)
        if not m:
            continue
        var = m.group(1)
        rhs = m.group(2)
        # The variable name must appear in the RHS as a standalone identifier.
        word_re = re.compile(rf"\b{re.escape(var)}\b")
        if not word_re.search(rhs):
            continue
        # Filter out trivial `x = x` (already caught by T2) and `*x = ...`-style.
        if rhs.strip() == var:
            continue
        # Pure self-assignment via op-equals to RHS containing var is the case.
        findings.append(Finding(
            kind="suspicious_self_reference", line=idx, evidence=line.strip(),
            theorem=(
                f"RHS references `{var}` while assigning to `{var}`; produces "
                "a non-canonical self-reference (e.g. `x += x - C` = `2*x - C`). "
                "Likely an emitter misencoding."
            ),
        ))
    return findings


# T4: malformed C — tokens that no C parser accepts. Specifically the
#     `v6 ++ v6 + 1` shape seen in v0.9.1-nightly entry_point output: a
#     post-increment with a non-empty RHS at statement level.
#     Theorem: by the C grammar, `lvalue ++ expr` is not a valid statement.
def detect_malformed_postinc(body: str) -> list[Finding]:
    findings: list[Finding] = []
    # `identifier ++ <something other than ; or whitespace>`
    pat = re.compile(
        r"^\s*([A-Za-z_]\w*)\s*\+\+\s+[A-Za-z_0-9].*?;"
    )
    for idx, line in enumerate(body.splitlines(), start=1):
        if pat.match(line):
            findings.append(Finding(
                kind="malformed_postinc", line=idx, evidence=line.strip(),
                theorem=(
                    "`x ++ <expr>;` is not a valid C statement (the C grammar "
                    "requires `;` or a parenthesised continuation after `++`). "
                    "The emitter produced ungrammatical output."
                ),
            ))
    return findings


# T5: unreachable code after `return` at the same brace depth.
#     Theorem: the post-`return` statement is not reachable from the function
#     entry on any control path that exits via this return → it is dead.
def detect_unreachable_after_return(body: str) -> list[Finding]:
    findings: list[Finding] = []
    lines = body.splitlines()
    depth = 0
    saw_return_at_depth: dict[int, int] = {}  # depth → return line idx
    for idx, line in enumerate(lines, start=1):
        # Track brace depth at line start (approximate but stable for emitted
        # Helix output, which uses one-statement-per-line and matched braces).
        stripped = line.strip()
        opens = line.count("{")
        closes = line.count("}")
        if stripped == "":
            continue
        if RETURN_RE.match(line):
            saw_return_at_depth[depth] = idx
            continue
        if depth in saw_return_at_depth and stripped not in ("}", ""):
            # Only count this if depth hasn't dropped since the return.
            # (A `}` line would already have decremented depth before we look.)
            findings.append(Finding(
                kind="unreachable_after_return",
                line=idx, evidence=line.strip(),
                theorem=(
                    f"prior `return` at line {saw_return_at_depth[depth]} "
                    f"at the same brace depth dominates this statement → "
                    "this code is unreachable."
                ),
            ))
            # Don't keep firing for every subsequent line in the same block.
            del saw_return_at_depth[depth]
        # Update depth AFTER processing the line, so a `}` on its own line
        # clears the return state for the *outer* scope.
        depth += opens - closes
        if depth < 0:
            depth = 0
            saw_return_at_depth.clear()
    return findings


# ── Layer 2 — bounded sub-scores and final composite ──────────────────────────
#
# Each sub-score is *provably* in [0, 1] by construction (it's either an
# explicit ratio or a clamped count). The composite is a weighted mean minus
# the sum of per-finding penalties, clamped to [0, 1]. This gives a single
# real number that is monotone in "amount of provable defect."


def _bounded(numer: int, denom: int) -> float:
    return 0.0 if denom <= 0 else min(1.0, max(0.0, numer / denom))


# Identifier-quality theorem: every identifier emitted by Helix that matches
# `v\d+`, `param_\d+`, or `field_0xN` is a placeholder name carrying no
# semantic information. Their fraction is a lower bound on the placeholder
# rate. name_quality = 1 − placeholder_rate ∈ [0, 1].
PLACEHOLDER_ID_RE = re.compile(r"\b(?:v\d+|var_\w+|param_\d+|field_0x[\dA-Fa-f]+)\b")
ALL_ID_RE = re.compile(r"\b[A-Za-z_][\w]*\b")
C_KEYWORDS = {
    "if", "else", "for", "while", "do", "switch", "case", "default", "break",
    "continue", "return", "goto", "sizeof", "typeof", "static", "extern",
    "auto", "register", "const", "volatile", "void", "int", "char", "short",
    "long", "float", "double", "signed", "unsigned", "struct", "union",
    "enum", "typedef", "NULL", "true", "false",
}


def score_name_quality(body: str) -> float:
    ids = [t for t in ALL_ID_RE.findall(body) if t not in C_KEYWORDS]
    if not ids:
        return 1.0  # vacuously good
    bad = sum(1 for t in ids if PLACEHOLDER_ID_RE.fullmatch(t))
    return 1.0 - bad / len(ids)


# Struct-field recovery: a deref `x->field_0xN` is an unnamed field; a deref
# `x->name` (anything else) is a named one. struct_recovery = named / total.
def score_struct_recovery(body: str) -> float:
    fields = DEREF_FIELD_RE.findall(body)
    if not fields:
        return 1.0
    named = sum(1 for f in fields if not f.startswith("field_0x"))
    return _bounded(named, len(fields))


# Call resolution: a call to `sub_XXXX`, `__indirect_call`, or `vfunc_*` is
# unresolved; anything else (named function) is resolved.
def score_call_resolution(body: str) -> float:
    unresolved_re = re.compile(r"\b(?:sub_[0-9a-fA-F]+|__indirect_call|vfunc_0x[\dA-Fa-f]+)\s*\(")
    calls = [m for m in CALL_RE.finditer(body) if m.group("callee") not in C_KEYWORDS]
    if not calls:
        return 1.0
    unresolved = sum(1 for m in calls if unresolved_re.search(m.group(0)))
    return 1.0 - _bounded(unresolved, len(calls))


# Flow regularity: a soft signal — fraction of non-blank lines that are NOT
# `goto`s, `return`s mid-block, or stray `}`. High = more structured.
def score_flow_regularity(body: str) -> float:
    lines = [l for l in body.splitlines() if l.strip()]
    if not lines:
        return 1.0
    irregular = sum(
        1 for l in lines
        if re.match(r"^\s*(goto\b|continue\s*;|break\s*;)", l)
    )
    return 1.0 - _bounded(irregular, len(lines))


# Penalty per Layer-1 finding. These are *deductions* from the [0, 1] composite.
# The values are conservative — a single finding cannot drag a function below 0.
PENALTY = {
    "null_deref_placeholder":    0.20,
    "malformed_postinc":         0.30,  # the harshest — output doesn't compile
    "suspicious_self_reference": 0.10,
    "identity_self_assign":      0.05,
    "identity_op_zero":          0.05,
    "identity_self_or_and":      0.05,
    "unreachable_after_return":  0.05,  # mild — common in lifter output
}

# Sub-score weights for the composite. Sum to 1.0; each component already
# bounded in [0, 1] → weighted_sum ∈ [0, 1] → score ∈ [0, 1] after the
# penalty subtraction is clamped.
WEIGHTS = {
    "name_quality":     0.35,
    "struct_recovery":  0.25,
    "call_resolution":  0.25,
    "flow_regularity":  0.15,
}
assert abs(sum(WEIGHTS.values()) - 1.0) < 1e-9


def compose_score(report: FunctionReport) -> float:
    base = (
        WEIGHTS["name_quality"]    * report.name_quality +
        WEIGHTS["struct_recovery"] * report.struct_recovery +
        WEIGHTS["call_resolution"] * report.call_resolution +
        WEIGHTS["flow_regularity"] * report.flow_regularity
    )
    deduction = sum(PENALTY.get(f.kind, 0.0) for f in report.findings)
    return max(0.0, min(1.0, base - deduction))


# ── Top-level analysis ────────────────────────────────────────────────────────


def analyse_function(name: str, body: str, conf: float | None, file_path: str) -> FunctionReport:
    # Extract local declarations to feed the null-deref detector.
    decls: dict[str, str | None] = {}
    for line in body.splitlines():
        dm = DECL_RE.match(line)
        if dm:
            decls[dm.group("var")] = dm.group("init")

    findings: list[Finding] = []
    findings.extend(detect_null_deref_of_placeholder(body, decls))
    findings.extend(detect_identity_no_op(body))
    findings.extend(detect_suspicious_self_doubling(body))
    findings.extend(detect_malformed_postinc(body))
    findings.extend(detect_unreachable_after_return(body))

    placeholder_decls = sorted(
        v for v, init in decls.items()
        if init is not None and init.strip() in ("0", "(void*)0", "NULL")
    )

    rep = FunctionReport(
        name=name,
        file=file_path,
        reported_confidence=conf,
        line_count=len(body.splitlines()),
        findings=findings,
        name_quality=score_name_quality(body),
        struct_recovery=score_struct_recovery(body),
        call_resolution=score_call_resolution(body),
        flow_regularity=score_flow_regularity(body),
        placeholder_decls=placeholder_decls,
    )
    rep.score = compose_score(rep)
    return rep


def analyse_file(path: Path) -> list[FunctionReport]:
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except OSError as e:
        print(f"[err] could not read {path}: {e}", file=sys.stderr)
        return []
    out: list[FunctionReport] = []
    for name, body, _banner, conf in split_functions(text):
        out.append(analyse_function(name, body, conf, str(path)))
    return out


def iter_helix_outputs(target: Path) -> Iterable[Path]:
    if target.is_file():
        yield target
        return
    # Helix outputs are *.c, *.helix.c, *.A.c, *.B.c, *.v091.c etc.
    for p in sorted(target.rglob("*.c")):
        # Skip our own .validate.json companion files if present.
        if p.suffix == ".c" and not p.name.endswith(".validate.json"):
            yield p


# ── Layer 3 — cross-version delta ─────────────────────────────────────────────


@dataclass
class Delta:
    name: str
    baseline_score: float | None
    current_score: float
    delta: float | None
    classification: str  # improved | regressed | unchanged | new


def compute_deltas(
    current: dict[str, FunctionReport],
    baseline: dict[str, FunctionReport],
    threshold: float = 0.02,
) -> list[Delta]:
    """Compare per-function scores; classify with a small dead band.

    A `threshold` of 0.02 (2 percentage points on the [0, 1] scale) avoids
    classifying microscopic numerical jitter as movement.
    """
    out: list[Delta] = []
    for name in sorted(set(current) | set(baseline)):
        cur = current.get(name)
        base = baseline.get(name)
        if cur is None:
            # Function present in baseline only — call it "removed".
            out.append(Delta(name, base.score if base else None, 0.0,
                             None, "removed"))
            continue
        if base is None:
            out.append(Delta(name, None, cur.score, None, "new"))
            continue
        d = cur.score - base.score
        if d > threshold:
            cls = "improved"
        elif d < -threshold:
            cls = "regressed"
        else:
            cls = "unchanged"
        out.append(Delta(name, base.score, cur.score, d, cls))
    return out


def collect_corpus(target: Path) -> dict[str, FunctionReport]:
    """Build a single dict[function_name → FunctionReport] over a directory.

    Note: if two files in the directory define functions with the same name,
    the *last one encountered* wins. We keep this simple deliberately; the
    operator can pass per-file paths when finer control is needed.
    """
    out: dict[str, FunctionReport] = {}
    for path in iter_helix_outputs(target):
        for rep in analyse_file(path):
            out[rep.name] = rep
    return out


# ── CLI ───────────────────────────────────────────────────────────────────────


def fmt_score(s: float) -> str:
    return f"{s * 100:5.1f}%"


def fmt_delta(d: float | None) -> str:
    if d is None:
        return "    -  "
    sign = "+" if d >= 0 else ""
    return f"{sign}{d * 100:5.1f}pp"


def print_report(
    current: dict[str, FunctionReport],
    deltas: list[Delta] | None,
    quiet: bool,
) -> None:
    if not current:
        print("[helix-validate] no functions found")
        return

    if deltas is None:
        print(f"{'Function':<40} {'Score':>7}  {'Conf%':>6}  {'Ln':>4}  Findings")
        print("-" * 95)
        for name in sorted(current):
            r = current[name]
            conf = f"{r.reported_confidence:5.1f}" if r.reported_confidence else "  -  "
            kinds = ", ".join(sorted({f.kind for f in r.findings})) or "—"
            print(f"{name:<40} {fmt_score(r.score):>7}  {conf:>6}  {r.line_count:>4}  {kinds}")
    else:
        print(f"{'Function':<40} {'Base':>7}  {'Cur':>7}  {'delta':>8}  {'Class':<10}")
        print("-" * 80)
        for d in deltas:
            base = fmt_score(d.baseline_score) if d.baseline_score is not None else "    -  "
            cur = fmt_score(d.current_score)
            print(f"{d.name:<40} {base:>7}  {cur:>7}  {fmt_delta(d.delta):>8}  {d.classification:<10}")

    # Corpus rollup.
    if not quiet:
        print()
        if deltas is None:
            n = len(current)
            mean = sum(r.score for r in current.values()) / n if n else 0.0
            total_findings = sum(len(r.findings) for r in current.values())
            n_with_findings = sum(1 for r in current.values() if r.findings)
            print(f"corpus: n={n}  mean_score={fmt_score(mean)}  "
                  f"functions_with_findings={n_with_findings}/{n}  "
                  f"total_findings={total_findings}")
        else:
            improved = sum(1 for d in deltas if d.classification == "improved")
            regressed = sum(1 for d in deltas if d.classification == "regressed")
            unchanged = sum(1 for d in deltas if d.classification == "unchanged")
            new = sum(1 for d in deltas if d.classification == "new")
            removed = sum(1 for d in deltas if d.classification == "removed")
            # Mean Δ over matched (non-new, non-removed) functions.
            matched = [d for d in deltas if d.delta is not None]
            mean_delta = (
                sum(d.delta for d in matched) / len(matched)
                if matched else 0.0
            )
            print(f"corpus delta: improved={improved} regressed={regressed} "
                  f"unchanged={unchanged} new={new} removed={removed}  "
                  f"mean_delta={fmt_delta(mean_delta)}")


def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(
        prog="helix-validate",
        description="Math-grounded quality assessment for Helix output.",
    )
    p.add_argument("target", type=Path, help="A Helix .c output file or a directory of them.")
    p.add_argument("--baseline", type=Path, default=None,
                   help="Baseline directory for Layer 3 cross-version delta.")
    p.add_argument("--json", type=Path, default=None,
                   help="Write a machine-readable JSON report alongside the stdout report.")
    p.add_argument("--quiet", action="store_true", help="Skip the corpus rollup line.")
    args = p.parse_args(argv)

    if not args.target.exists():
        print(f"[helix-validate] target not found: {args.target}", file=sys.stderr)
        return 2

    current = collect_corpus(args.target)
    deltas: list[Delta] | None = None
    if args.baseline is not None:
        if not args.baseline.exists():
            print(f"[helix-validate] baseline not found: {args.baseline}", file=sys.stderr)
            return 2
        baseline = collect_corpus(args.baseline)
        deltas = compute_deltas(current, baseline)

    print_report(current, deltas, args.quiet)

    if args.json is not None:
        payload: dict = {
            "target": str(args.target),
            "baseline": str(args.baseline) if args.baseline else None,
            "functions": {
                name: {
                    **{k: v for k, v in asdict(rep).items() if k != "findings"},
                    "findings": [asdict(f) for f in rep.findings],
                }
                for name, rep in current.items()
            },
        }
        if deltas is not None:
            payload["deltas"] = [asdict(d) for d in deltas]
        args.json.write_text(json.dumps(payload, indent=2), encoding="utf-8")
        print(f"[helix-validate] json → {args.json}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
