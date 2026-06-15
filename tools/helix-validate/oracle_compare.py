#!/usr/bin/env python3
"""oracle_compare — proximity-to-IDA scoring against the mali_kbase oracle.

`helix_validate.py` answers "is this output internally clean?" (no goto, no null
deref, low placeholder rate). It happily rates a function high when the
*structure* is tidy — even if that structure dropped error paths, lost strings,
or duplicated blocks relative to ground truth. That is by design: it has no
ground truth to compare against.

`score_against_oracle()` answers a different question: "how close is this output
to what IDA Pro recovered from the same bytes?" The score is a real number in
[0, 1] built entirely from proximity to the IDA fingerprint stored in
`oracle_mali.json` — name recovery, struct-field recovery, call recovery,
literal (format-string) survival, and control-flow fidelity. No internal
heuristic feeds it.

The deliberate contrast between the two numbers is the point. A function like
`kbase_mem_commit` scores ~0.87 on helix-validate (clean, goto-free) yet exposes
a large gap on the oracle (lost strings, dropped call args). That gap is what an
honest paper score must report — see `decompiler-responsibility-boundary`
("split Helix-internal score vs end-to-end score").

This enables the *double tripwire* the task asked for: a change to the engine is
only an improvement if helix-validate does not regress **and** the oracle score
does not fall.

Usage
-----
    oracle_compare.py [--oracle oracle_mali.json] [--helix-dir DIR]
                      [--json OUT.json]

Prints, for the 7 functions:
    function | helix-validate score | oracle score | main divergence
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

# oracle_builder and helix_validate live alongside this script.
sys.path.insert(0, str(Path(__file__).resolve().parent))
import oracle_builder as ob  # noqa: E402

try:
    import helix_validate as hv  # noqa: E402
    _HAVE_HV = True
except ImportError:  # pragma: no cover - helix_validate should be present
    _HAVE_HV = False


# ── proximity-to-IDA score ────────────────────────────────────────────────────
#
# Five components, each provably in [0, 1], combined by a fixed weight vector
# that sums to 1. Each measures Helix's recovery *relative to IDA's*, so a
# component is 1.0 when Helix matches IDA's recovery for that dimension and 0.0
# when it recovered nothing IDA did. A small extra deduction handles the
# correctness-flavoured defects (double-deref, self-reference, stub) that the
# five components do not otherwise see. The result is clamped to [0, 1].

WEIGHTS = {
    "name_recovery":   0.20,
    "struct_recovery": 0.20,
    "call_recovery":   0.20,
    "literal_recovery": 0.15,
    "flow_fidelity":   0.25,
}
assert abs(sum(WEIGHTS.values()) - 1.0) < 1e-9

_EPS = 1e-6

# Human-readable divergence labels keyed by component name.
DIVERGENCE_LABEL = {
    "name_recovery":   "identifiers lost (param_N / vN)",
    "struct_recovery": "struct fields unresolved (field_0xN)",
    "call_recovery":   "calls unresolved / args dropped",
    "literal_recovery": "format strings lost (dev_*(0))",
    "flow_fidelity":   "control flow broken (dead tail / empty if / stub)",
}


def _clamp(x: float) -> float:
    return max(0.0, min(1.0, x))


def _named_field_rate(fp: dict) -> float:
    total = fp["named_field_count"] + fp["raw_field_count"]
    if total == 0:
        return 1.0  # no field accesses → nothing to recover
    return fp["named_field_count"] / total


def score_against_oracle(helix_output, oracle_entry: dict) -> dict:
    """Score one Helix function against its IDA ground truth.

    `helix_output` may be a path to a `.helix.c` file (re-parsed fresh — the
    intended use when scoring a new engine build) or an already-parsed
    `helix_current` fingerprint dict (for re-scoring the stored oracle).
    `oracle_entry` is one entry from `oracle_mali.json["functions"]`; its
    `ground_truth_ida` fingerprint is the reference.

    Returns {"score", "components", "main_divergence", "main_divergence_label"}.
    """
    ida_fp = ob.Fingerprint(**oracle_entry["ground_truth_ida"])
    ida = oracle_entry["ground_truth_ida"]

    if isinstance(helix_output, (str, Path)):
        helix_fp = ob.parse_function_file(Path(helix_output), "helix")
    else:
        helix_fp = ob.Fingerprint(**helix_output)
    helix = helix_fp.as_dict()

    # Recompute the defect matrix and divergence from *these* fingerprints
    # against the frozen IDA ground truth, so a fresh engine build is scored on
    # its own output rather than the values frozen into the oracle file.
    dm = ob.build_defect_matrix(helix_fp, ida_fp)
    div = ob.build_divergence(helix_fp, ida_fp)

    # 1. Name recovery: fraction of identifiers IDA named that Helix also named,
    #    approximated by the ratio of named-identifier rates.
    helix_named = 1.0 - helix["placeholder_id_rate"]
    ida_named = 1.0 - ida["placeholder_id_rate"]
    name_recovery = _clamp(helix_named / max(ida_named, _EPS))

    # 2. Struct recovery: Helix's named-field rate relative to IDA's.
    struct_recovery = _clamp(_named_field_rate(helix) / max(_named_field_rate(ida), _EPS))

    # 3. Call recovery: fraction of IDA's (normalised) callees Helix also emits.
    ida_calls = set(ida["callees"])
    helix_calls = set(helix["callees"])
    if not ida_calls:
        call_recovery = 1.0
    else:
        call_recovery = len(ida_calls & helix_calls) / len(ida_calls)
    # Penalise arg-count divergence on shared callees (C4): each mismatch costs
    # a slice of the otherwise-recovered credit.
    c4 = dm.get("C4_nonequiv_args", {})
    if c4.get("fires") and ida_calls:
        call_recovery = _clamp(call_recovery - 0.1 * c4.get("evidence", 0) / len(ida_calls))

    # 4. Literal recovery: format strings that survived to log calls, relative
    #    to how many IDA preserved. If IDA preserved none there is nothing to
    #    lose, so the component is vacuously 1.0.
    ida_log = ida["log_calls_with_string"]
    if ida_log == 0:
        literal_recovery = 1.0
    else:
        literal_recovery = _clamp(helix["log_calls_with_string"] / ida_log)

    # 5. Flow fidelity: penalise Helix-only control-flow damage. A stub (whole
    #    body dropped) is total flow loss.
    if helix["is_stub"]:
        flow_fidelity = 0.0
    else:
        empty_if_rate = helix["empty_if_blocks"] / max(helix["if_count"], 1)
        unreachable_rate = min(1.0, 5.0 * helix["unreachable_after_return"] / max(helix["loc"], 1))
        if_div = _clamp(abs(helix["if_count"] - ida["if_count"]) / max(ida["if_count"], 1))
        flow_fidelity = _clamp(
            1.0 - (0.35 * empty_if_rate + 0.30 * unreachable_rate + 0.35 * if_div)
        )

    components = {
        "name_recovery": round(name_recovery, 4),
        "struct_recovery": round(struct_recovery, 4),
        "call_recovery": round(call_recovery, 4),
        "literal_recovery": round(literal_recovery, 4),
        "flow_fidelity": round(flow_fidelity, 4),
    }

    base = sum(WEIGHTS[k] * components[k] for k in WEIGHTS)

    # Extra deduction for correctness-flavoured defects the components miss.
    extra = 0.0
    if dm.get("C13_composite_decomp", {}).get("fires"):
        extra += 0.04
    if dm.get("C14_typedep_expr", {}).get("fires"):
        extra += 0.04
    score = _clamp(base - extra)

    # Main divergence = the weakest component (largest distance from IDA).
    main = min(components, key=lambda k: components[k])

    return {
        "score": round(score, 4),
        "components": components,
        "main_divergence": main,
        "main_divergence_label": DIVERGENCE_LABEL[main],
        "loc_ratio": div.get("loc_ratio"),
    }


# ── helix-validate side ───────────────────────────────────────────────────────


def helix_validate_score(helix_file: Path, fn_name: str) -> float | None:
    """Run helix_validate on a file and return the score for `fn_name`."""
    if not _HAVE_HV:
        return None
    try:
        reports = hv.analyse_file(helix_file)
    except Exception:  # noqa: BLE001 - measurement must not crash the table
        return None
    for r in reports:
        if r.name == fn_name:
            return r.score
    return reports[0].score if reports else None


# ── driver ────────────────────────────────────────────────────────────────────


def _resolve_helix_file(oracle_entry: dict, helix_dir: Path | None) -> Path:
    stored = Path(oracle_entry["helix_current"]["file"])
    if helix_dir is not None:
        cand = helix_dir / stored.name
        if cand.exists():
            return cand
    return stored


def run(oracle_path: Path, helix_dir: Path | None) -> dict:
    oracle = json.loads(oracle_path.read_text(encoding="utf-8"))
    rows = []
    for fn, entry in oracle["functions"].items():
        helix_file = _resolve_helix_file(entry, helix_dir)
        # Score the current file against frozen ground truth when present;
        # fall back to the stored fingerprint if the file moved.
        helix_arg = helix_file if helix_file.exists() else entry["helix_current"]
        oc = score_against_oracle(helix_arg, entry)
        hvs = helix_validate_score(helix_file, fn) if helix_file.exists() else None
        rows.append({
            "function": fn,
            "helix_validate_score": hvs,
            "oracle_score": oc["score"],
            "components": oc["components"],
            "main_divergence": oc["main_divergence"],
            "main_divergence_label": oc["main_divergence_label"],
            "gap": (round(hvs - oc["score"], 4) if hvs is not None else None),
        })
    return {"oracle": str(oracle_path), "rows": rows}


def _fmt_pct(x: float | None) -> str:
    return "   -  " if x is None else f"{x * 100:5.1f}%"


def print_table(result: dict) -> None:
    rows = result["rows"]
    print(f"{'Function':<28} {'helix-validate':>14} {'oracle':>8} {'gap':>7}  Main divergence")
    print("-" * 100)
    hv_sum = oc_sum = 0.0
    hv_n = 0
    for r in rows:
        hv = r["helix_validate_score"]
        oc = r["oracle_score"]
        gap = _fmt_pct(r["gap"]) if r["gap"] is not None else "   -  "
        print(f"{r['function']:<28} {_fmt_pct(hv):>14} {_fmt_pct(oc):>8} {gap:>7}  "
              f"{r['main_divergence_label']}")
        oc_sum += oc
        if hv is not None:
            hv_sum += hv
            hv_n += 1
    n = len(rows)
    print("-" * 100)
    hv_mean = hv_sum / hv_n if hv_n else 0.0
    oc_mean = oc_sum / n if n else 0.0
    print(f"{'MEAN':<28} {_fmt_pct(hv_mean):>14} {_fmt_pct(oc_mean):>8} "
          f"{_fmt_pct(hv_mean - oc_mean):>7}  (positive gap = helix-validate over-rates vs IDA)")


def main(argv: list[str]) -> int:
    here = Path(__file__).resolve().parent
    p = argparse.ArgumentParser(
        prog="oracle_compare",
        description="Score Helix output by proximity to the IDA ground-truth oracle.",
    )
    p.add_argument("--oracle", type=Path, default=here / "oracle_mali.json")
    p.add_argument("--helix-dir", type=Path, default=None,
                   help="Re-score .helix.c files from this dir instead of the "
                        "paths frozen in the oracle (use for a new engine build).")
    p.add_argument("--json", type=Path, default=None,
                   help="Also write the table as machine-readable JSON.")
    args = p.parse_args(argv)

    if not args.oracle.exists():
        print(f"[oracle_compare] oracle not found: {args.oracle}\n"
              f"  run oracle_builder.py first.", file=sys.stderr)
        return 2

    result = run(args.oracle, args.helix_dir)
    print_table(result)

    if args.json is not None:
        args.json.write_text(json.dumps(result, indent=2), encoding="utf-8")
        print(f"\n[oracle_compare] json -> {args.json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
