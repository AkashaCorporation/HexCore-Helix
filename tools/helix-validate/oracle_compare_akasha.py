#!/usr/bin/env python3
"""Akasha source oracle for the four scalar functions.

This is intentionally separate from oracle_compare.py: the Mali oracle scores
against IDA, while Akasha has real C/C++ source available.  The frozen oracle
therefore stores source snippets plus source-derived semantic checks, then this
script scores a Helix output against those checks.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import tempfile
from pathlib import Path

# oracle_builder and helix_validate live alongside this script.
sys.path.insert(0, str(Path(__file__).resolve().parent))
import oracle_builder as ob  # noqa: E402

try:
    import helix_validate as hv  # noqa: E402
    _HAVE_HV = True
except ImportError:  # pragma: no cover - helix_validate should be present
    _HAVE_HV = False


DEFAULT_AKASHA_ROOT = Path(r"C:\Users\Mazum\Desktop\AkashaVsHexRays")
DEFAULT_SOURCE_FILE = DEFAULT_AKASHA_ROOT / "Malware HexCore Defeat v7.cpp"
DEFAULT_HELIX_DIR = DEFAULT_AKASHA_ROOT / "hexcore_output"


COMPONENT_WEIGHTS = {
    "semantic_recovery": 0.60,
    "signature_recovery": 0.15,
    "flow_fidelity": 0.15,
    "quality": 0.10,
}
assert abs(sum(COMPONENT_WEIGHTS.values()) - 1.0) < 1e-9

DIVERGENCE_LABEL = {
    "semantic_recovery": "source semantic features absent",
    "signature_recovery": "source signature/arity not recovered",
    "flow_fidelity": "source control flow not recovered",
    "quality": "Helix-internal output damage",
}


def _check(check_id: str, label: str, weight: float, patterns: list[str],
           mode: str = "any") -> dict:
    return {
        "id": check_id,
        "label": label,
        "weight": weight,
        "mode": mode,
        "patterns": patterns,
    }


FUNCTION_SPECS = [
    {
        "function": "0x140001000_sub_140001000",
        "address": "0x140001000",
        "source_function": "rt_fnv",
        "helix_function": "sub_140001000",
        "helix_file": "0x140001000_sub_140001000.helix.c",
        "semantic_checks": [
            _check(
                "fnv64_offset_basis",
                "recovers the 64-bit FNV offset basis or its XOR-split halves",
                1.0,
                [r"0xCBF29CE484222325", r"14695981039346656037",
                 r"0xCBF29CE4", r"0x84222325"],
            ),
            _check(
                "fnv64_prime",
                "recovers the 64-bit FNV prime or its XOR-split halves",
                1.0,
                [r"0x100000001B3", r"1099511628211", r"0x00000100",
                 r"0x000001B3"],
            ),
            _check(
                "nul_terminated_loop",
                "keeps the loop over the input bytes until NUL",
                1.0,
                [r"\bwhile\s*\([^)]*\*[^)]*\)", r"\bfor\s*\([^;]*;[^;]*\*"],
            ),
            _check(
                "byte_xor_update",
                "keeps the byte-wise xor into the FNV accumulator",
                1.0,
                [r"\^\s*(?:static_cast\s*<\s*uint8_t\s*>|\(?uint8_t\)?|\*|[A-Za-z_]\w*\[)",
                 r"\^=.*(?:\*|[A-Za-z_]\w*\[)"],
            ),
            _check(
                "hash_accumulator_return",
                "returns the computed hash accumulator, not an uninitialized result",
                1.0,
                [r"\breturn\s+(?!result\b)[A-Za-z_]\w*\s*;"],
            ),
        ],
    },
    {
        "function": "0x140001090_sub_140001090",
        "address": "0x140001090",
        "source_function": "sv_fnv32",
        "helix_function": "sub_140001090",
        "helix_file": "0x140001090_sub_140001090.helix.c",
        "semantic_checks": [
            _check(
                "fnv32_offset_basis",
                "recovers the 32-bit FNV offset basis",
                1.0,
                [r"0x811C9DC5", r"2166136261"],
            ),
            _check(
                "fnv32_prime",
                "recovers the 32-bit FNV prime",
                1.0,
                [r"0x01000193", r"0x1000193", r"16777619"],
            ),
            _check(
                "bounded_byte_loop",
                "keeps the loop bounded by n",
                1.0,
                [r"\bfor\s*\([^;]*;[^;]*<[^;]*(?:\bn\b|param_2)\b",
                 r"\bwhile\s*\([^)]*<[^)]*(?:\bn\b|param_2)\b"],
            ),
            _check(
                "indexed_byte_read",
                "reads p[i] / input byte from memory",
                1.0,
                [r"\[[^\]]+\]", r"\*\s*\([^)]*\+", r"\*\s*[A-Za-z_]\w+"],
            ),
            _check(
                "xor_then_multiply",
                "keeps the xor/multiply FNV update pair",
                1.0,
                [r"\^", r"\*"],
                mode="all",
            ),
            _check(
                "fnv32_accumulator_return",
                "returns the FNV accumulator, not the length/boolean parameter",
                1.0,
                [r"\breturn\s+(?!param_2\b)(?!result\b)[A-Za-z_]\w*\s*;"],
            ),
        ],
    },
    {
        "function": "0x140001190_sub_140001190",
        "address": "0x140001190",
        "source_function": "sv1",
        "helix_function": "sub_140001190",
        "helix_file": "0x140001190_sub_140001190.helix.c",
        "semantic_checks": [
            _check(
                "peb_ldr_guard",
                "keeps the PEB/Ldr null guard",
                1.0,
                [r"!\s*peb", r"!\s*param_1", r"\bLdr\b", r"return\s+(?:nullptr|0)"],
            ),
            _check(
                "module_list_walk",
                "walks the InMemoryOrder module list",
                1.0,
                [r"InMemoryOrderModuleList", r"\bFlink\b", r"\bfor\s*\(", r"\bwhile\s*\("],
            ),
            _check(
                "full_dll_name_read",
                "reads FullDllName.Buffer/Length from each module entry",
                1.0,
                [r"FullDllName", r"\bBuffer\b", r"\bLength\b", r"field_0x[0-9A-Fa-f]+"],
            ),
            _check(
                "basename_slash_scan",
                "keeps the basename scan over slash/backslash",
                1.0,
                [r"\\\\", r"0x5C", r"\b92\b", r"'/", r"\b47\b"],
            ),
            _check(
                "ascii_lowercase_fold",
                "keeps the A-Z to lowercase fold",
                1.0,
                [r"'A'", r"'Z'", r"\+\s*32", r"0x20"],
            ),
            _check(
                "module_hash_compare",
                "hashes the normalized module name and compares to target",
                1.0,
                [r"\brt_fnv\s*\(", r"\bsub_140001000\s*\("],
            ),
            _check(
                "dllbase_return",
                "returns the matching module base",
                1.0,
                [r"\bDllBase\b", r"field_0x30", r"\breturn\s+(?!result\b)[^;]+;"],
            ),
        ],
    },
    {
        "function": "0x140001350_sub_140001350",
        "address": "0x140001350",
        "source_function": "sv2",
        "helix_function": "sub_140001350",
        "helix_file": "0x140001350_sub_140001350.helix.c",
        "semantic_checks": [
            _check(
                "module_null_guard",
                "keeps the module null guard",
                1.0,
                [r"!\s*mod", r"!\s*param_1", r"return\s+(?:nullptr|0)"],
            ),
            _check(
                "mz_signature_check",
                "checks IMAGE_DOS_SIGNATURE",
                1.0,
                [r"IMAGE_DOS_SIGNATURE", r"0x5A4D", r"\b23117\b"],
            ),
            _check(
                "pe_signature_check",
                "checks IMAGE_NT_SIGNATURE",
                1.0,
                [r"IMAGE_NT_SIGNATURE", r"0x4550", r"\b17744\b"],
            ),
            _check(
                "export_directory_rva",
                "reads the export directory RVA",
                1.0,
                [r"IMAGE_DIRECTORY_ENTRY_EXPORT", r"DataDirectory", r"field_0x88",
                 r"0x88", r"\b136\b"],
            ),
            _check(
                "export_name_tables",
                "recovers AddressOfNames/Ordinals/Functions tables",
                1.0,
                [r"AddressOfNames", r"AddressOfNameOrdinals", r"AddressOfFunctions",
                 r"field_0x20", r"field_0x24", r"field_0x1C"],
            ),
            _check(
                "export_name_loop",
                "iterates across exported names",
                1.0,
                [r"NumberOfNames", r"field_0x18", r"\bfor\s*\(", r"\bwhile\s*\("],
            ),
            _check(
                "export_hash_compare",
                "hashes each export name and compares to target",
                1.0,
                [r"\brt_fnv\s*\(", r"\bsub_140001000\s*\("],
            ),
            _check(
                "function_pointer_return",
                "returns the resolved function pointer, not a boolean/result",
                1.0,
                [r"funcs\s*\[.*ords\s*\[", r"AddressOfFunctions",
                 r"\breturn\s+(?!result\b)(?!0\b)[^;]+\[[^;]+;"],
            ),
        ],
    },
]


def _clamp(x: float) -> float:
    return max(0.0, min(1.0, x))


def _extract_source_function(source_text: str, name: str) -> tuple[str, int, int]:
    lines = source_text.splitlines()
    start = None
    sig_re = re.compile(rf"\b{re.escape(name)}\s*\([^;]*\)")
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.endswith(";"):
            continue
        if "{" in stripped and sig_re.search(stripped):
            start = i
            break
    if start is None:
        raise ValueError(f"source function not found: {name}")

    depth = 0
    end = start
    seen_open = False
    for j in range(start, len(lines)):
        depth += lines[j].count("{")
        if "{" in lines[j]:
            seen_open = True
        depth -= lines[j].count("}")
        if seen_open and depth <= 0:
            end = j
            break
    else:
        raise ValueError(f"unterminated source function: {name}")

    return "\n".join(lines[start:end + 1]), start + 1, end + 1


def _fingerprint_snippet(snippet: str, source_file: Path, source_name: str) -> dict:
    with tempfile.TemporaryDirectory(prefix="akasha_oracle_") as td:
        path = Path(td) / f"{source_name}.cpp"
        path.write_text(snippet, encoding="utf-8")
        fp = ob.parse_function_file(path, "source")
    data = fp.as_dict()
    data["file"] = str(source_file)
    return data


def _read_code(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def _parse_helix(helix_output, oracle_entry: dict) -> tuple[ob.Fingerprint, str]:
    if isinstance(helix_output, (str, Path)):
        path = Path(helix_output)
        return ob.parse_function_file(path, "helix"), _read_code(path)

    fp = ob.Fingerprint(**helix_output)
    path = Path(fp.file)
    if path.exists():
        code = _read_code(path)
    else:
        code = oracle_entry.get("helix_current_text", "")
    return fp, code


def _match_check(code: str, check: dict) -> dict:
    flags = re.IGNORECASE | re.MULTILINE
    hits = [bool(re.search(pat, code, flags)) for pat in check["patterns"]]
    if check.get("mode") == "all":
        passed = all(hits)
    else:
        passed = any(hits)
    return {
        "id": check["id"],
        "label": check["label"],
        "weight": check["weight"],
        "passed": passed,
        "matched_patterns": [
            pat for pat, hit in zip(check["patterns"], hits, strict=True) if hit
        ],
    }


def _ret_family(ret_type: str) -> str:
    rt = ret_type.replace("const", "").strip().lower()
    if rt == "void":
        return "void"
    if "*" in rt or any(t in rt for t in ("hmodule", "farproc", "pimage", "ppeb", "handle")):
        return "pointer"
    if "bool" in rt or "boolean" in rt:
        return "bool"
    if any(t in rt for t in ("int", "long", "dword", "word", "size_t", "uint")):
        return "integer"
    return "other"


def _signature_recovery(helix: ob.Fingerprint, source: dict) -> float:
    src_params = len(source["params"])
    h_params = len(helix.params)
    if src_params == 0:
        param_score = 1.0 if h_params == 0 else 0.0
    else:
        param_score = _clamp(1.0 - abs(h_params - src_params) / max(src_params, h_params))

    src_ret = _ret_family(source["return_type"])
    h_ret = _ret_family(helix.return_type)
    if src_ret == h_ret:
        ret_score = 1.0
    elif {src_ret, h_ret} == {"pointer", "integer"}:
        ret_score = 0.5
    else:
        ret_score = 0.0
    return _clamp(0.65 * param_score + 0.35 * ret_score)


def _flow_fidelity(helix: ob.Fingerprint, source: dict) -> float:
    src_loops = source["loop_count"]
    if src_loops:
        loop_score = _clamp(helix.loop_count / src_loops)
    else:
        loop_score = 1.0 if helix.loop_count == 0 else 0.5

    src_ifs = source["if_count"]
    if src_ifs:
        if_score = _clamp(1.0 - abs(helix.if_count - src_ifs) / max(src_ifs, helix.if_count, 1))
    else:
        if_score = 1.0 if helix.if_count == 0 else 0.5

    src_returns = source["return_count"]
    if src_returns:
        ret_score = _clamp(1.0 - abs(helix.return_count - src_returns) /
                           max(src_returns, helix.return_count, 1))
    else:
        ret_score = 1.0 if helix.return_count == 0 else 0.5

    score = 0.50 * loop_score + 0.30 * if_score + 0.20 * ret_score
    if helix.is_stub:
        score = min(score, 0.25)
    score -= min(0.20, 0.04 * helix.unreachable_after_return)
    score -= min(0.20, 0.03 * helix.suspicious_self_ref)
    return _clamp(score)


ZERO_DECL_RE = re.compile(
    r"\b(?:void\s*\*|[A-Za-z_]\w*(?:_t)?|int\d+_t|uint\d+_t)\s+"
    r"(?P<var>[A-Za-z_]\w*)\s*=\s*(?:\(void\s*\*\)\s*)?0\s*;"
)


def _null_like_deref_count(code: str) -> int:
    zero_vars = {m.group("var") for m in ZERO_DECL_RE.finditer(code)}
    if not zero_vars:
        return 0
    count = 0
    for line in code.splitlines():
        for var in zero_vars:
            if re.search(rf"\*\s*{re.escape(var)}\b", line):
                count += 1
                break
            if re.search(rf"\*\s*\([^)]*\b{re.escape(var)}\b[^)]*\)", line):
                count += 1
                break
    return count


def _quality(helix: ob.Fingerprint, code: str) -> tuple[float, dict]:
    null_like_derefs = _null_like_deref_count(code)
    penalty = 0.0
    penalty += 0.50 if helix.is_stub else 0.0
    penalty += min(0.30, 0.05 * helix.suspicious_self_ref)
    penalty += min(0.20, 0.04 * helix.unreachable_after_return)
    penalty += min(0.20, helix.placeholder_id_rate * 0.50)
    penalty += min(0.45, 0.15 * null_like_derefs)
    details = {
        "is_stub": helix.is_stub,
        "suspicious_self_ref": helix.suspicious_self_ref,
        "unreachable_after_return": helix.unreachable_after_return,
        "placeholder_id_rate": round(helix.placeholder_id_rate, 4),
        "null_like_deref_count": null_like_derefs,
    }
    return _clamp(1.0 - penalty), details


def _correctness_penalty(helix: ob.Fingerprint, quality_details: dict) -> float:
    penalty = 0.0
    if helix.is_stub:
        penalty += 0.08
    penalty += min(0.18, 0.06 * quality_details["null_like_deref_count"])
    penalty += min(0.12, 0.02 * helix.suspicious_self_ref)
    return round(penalty, 4)


def score_against_source(helix_output, oracle_entry: dict) -> dict:
    """Score one Helix output against Akasha's real source snippet."""
    helix_fp, code = _parse_helix(helix_output, oracle_entry)
    source_fp = oracle_entry["ground_truth_source"]
    quality, quality_details = _quality(helix_fp, code)

    check_results = [_match_check(code, check) for check in oracle_entry["semantic_checks"]]
    total_weight = sum(c["weight"] for c in check_results) or 1.0
    semantic = sum(c["weight"] for c in check_results if c["passed"]) / total_weight

    components = {
        "semantic_recovery": round(semantic, 4),
        "signature_recovery": round(_signature_recovery(helix_fp, source_fp), 4),
        "flow_fidelity": round(_flow_fidelity(helix_fp, source_fp), 4),
        "quality": round(quality, 4),
    }
    base = sum(COMPONENT_WEIGHTS[k] * components[k] for k in COMPONENT_WEIGHTS)
    correctness_penalty = _correctness_penalty(helix_fp, quality_details)
    score = _clamp(base - correctness_penalty)
    main = min(components, key=lambda k: components[k])
    return {
        "score": round(score, 4),
        "components": components,
        "quality_details": quality_details,
        "correctness_penalty": correctness_penalty,
        "checks": check_results,
        "main_divergence": main,
        "main_divergence_label": DIVERGENCE_LABEL[main],
    }


def helix_validate_score(helix_file: Path, fn_name: str) -> float | None:
    if not _HAVE_HV:
        return None
    try:
        reports = hv.analyse_file(helix_file)
    except Exception:  # noqa: BLE001 - measurement must not crash comparison
        return None
    for report in reports:
        if report.name == fn_name:
            return report.score
    return reports[0].score if reports else None


def _resolve_helix_file(entry: dict, helix_dir: Path | None) -> Path:
    stored = Path(entry["helix_current"]["file"])
    if helix_dir is not None:
        cand = helix_dir / stored.name
        if cand.exists():
            return cand
    return stored


def build_oracle(source_file: Path, helix_dir: Path) -> dict:
    source_text = _read_code(source_file)
    entries: dict[str, dict] = {}
    problems: list[str] = []

    for spec in FUNCTION_SPECS:
        try:
            snippet, start, end = _extract_source_function(source_text, spec["source_function"])
            source_fp = _fingerprint_snippet(snippet, source_file, spec["source_function"])
        except ValueError as exc:
            problems.append(f"{spec['function']}: source parse error: {exc}")
            continue

        hpath = helix_dir / spec["helix_file"]
        if hpath.exists():
            try:
                helix_fp = ob.parse_function_file(hpath, "helix").as_dict()
            except ValueError as exc:
                helix_fp = None
                problems.append(f"{spec['function']}: Helix parse error: {exc}")
        else:
            helix_fp = None
            problems.append(f"{spec['function']}: missing Helix output: {hpath}")

        entries[spec["function"]] = {
            "function": spec["function"],
            "address": spec["address"],
            "source_function": spec["source_function"],
            "helix_function": spec["helix_function"],
            "source_span": {"start_line": start, "end_line": end},
            "source_snippet": snippet,
            "ground_truth_source": source_fp,
            "helix_current": helix_fp,
            "semantic_checks": spec["semantic_checks"],
        }

    return {
        "schema_version": 1,
        "corpus": "AkashaVsHexRays / Malware HexCore Defeat v7",
        "ground_truth": "real_source",
        "source_file": str(source_file),
        "helix_dir": str(helix_dir),
        "score_model": {
            "components": COMPONENT_WEIGHTS,
            "note": "Semantic checks are derived from source snippets, not IDA output.",
        },
        "functions": entries,
        "problems": problems,
    }


def run(oracle_path: Path, helix_dir: Path | None) -> dict:
    oracle = json.loads(oracle_path.read_text(encoding="utf-8"))
    rows = []
    for fn, entry in oracle["functions"].items():
        if entry.get("helix_current") is None:
            rows.append({
                "function": fn,
                "helix_validate_score": None,
                "source_oracle_score": 0.0,
                "components": {},
                "checks": [],
                "main_divergence": "missing_helix",
                "main_divergence_label": "missing Helix output",
                "gap": None,
            })
            continue

        helix_file = _resolve_helix_file(entry, helix_dir)
        helix_arg = helix_file if helix_file.exists() else entry["helix_current"]
        oc = score_against_source(helix_arg, entry)
        hvs = helix_validate_score(helix_file, entry["helix_function"]) if helix_file.exists() else None
        rows.append({
            "function": fn,
            "address": entry["address"],
            "source_function": entry["source_function"],
            "helix_function": entry["helix_function"],
            "helix_file": str(helix_file),
            "helix_validate_score": hvs,
            "source_oracle_score": oc["score"],
            "components": oc["components"],
            "quality_details": oc["quality_details"],
            "correctness_penalty": oc["correctness_penalty"],
            "checks": oc["checks"],
            "main_divergence": oc["main_divergence"],
            "main_divergence_label": oc["main_divergence_label"],
            "gap": (round(hvs - oc["score"], 4) if hvs is not None else None),
        })

    hv_vals = [r["helix_validate_score"] for r in rows if r["helix_validate_score"] is not None]
    src_vals = [r["source_oracle_score"] for r in rows]
    hv_mean = sum(hv_vals) / len(hv_vals) if hv_vals else None
    src_mean = sum(src_vals) / len(src_vals) if src_vals else 0.0
    return {
        "oracle": str(oracle_path),
        "rows": rows,
        "mean": {
            "helix_validate_score": round(hv_mean, 4) if hv_mean is not None else None,
            "source_oracle_score": round(src_mean, 4),
            "gap": round(hv_mean - src_mean, 4) if hv_mean is not None else None,
        },
    }


def _fmt_pct(x: float | None) -> str:
    return "   -  " if x is None else f"{x * 100:5.1f}%"


def print_table(result: dict) -> None:
    print(f"{'Function':<28} {'helix-validate':>14} {'source':>8} {'gap':>7}  Main divergence")
    print("-" * 105)
    for row in result["rows"]:
        gap = _fmt_pct(row["gap"]) if row["gap"] is not None else "   -  "
        print(
            f"{row['function']:<28} {_fmt_pct(row['helix_validate_score']):>14} "
            f"{_fmt_pct(row['source_oracle_score']):>8} {gap:>7}  "
            f"{row['main_divergence_label']}"
        )
    mean = result["mean"]
    print("-" * 105)
    print(
        f"{'MEAN':<28} {_fmt_pct(mean['helix_validate_score']):>14} "
        f"{_fmt_pct(mean['source_oracle_score']):>8} "
        f"{_fmt_pct(mean['gap']):>7}  "
        "(positive gap = helix-validate over-rates vs source)"
    )


def main(argv: list[str]) -> int:
    here = Path(__file__).resolve().parent
    default_oracle = here / "oracle_akasha.json"

    parser = argparse.ArgumentParser(
        prog="oracle_compare_akasha",
        description="Build and score the Akasha source-ground-truth mini-oracle.",
    )
    parser.add_argument("--oracle", type=Path, default=default_oracle)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE_FILE)
    parser.add_argument("--helix-dir", type=Path, default=None)
    parser.add_argument("--build", action="store_true",
                        help="Rebuild oracle_akasha.json from source and current Helix output.")
    parser.add_argument("--out", type=Path, default=default_oracle,
                        help="Output path for --build.")
    parser.add_argument("--json", type=Path, default=None,
                        help="Also write the current score table as JSON.")
    args = parser.parse_args(argv)

    oracle_path = args.oracle
    if args.build:
        helix_dir = args.helix_dir or DEFAULT_HELIX_DIR
        oracle = build_oracle(args.source, helix_dir)
        args.out.write_text(json.dumps(oracle, indent=2), encoding="utf-8")
        oracle_path = args.out
        print(f"[oracle_compare_akasha] oracle -> {args.out}")

    if not oracle_path.exists():
        print(
            f"[oracle_compare_akasha] oracle not found: {oracle_path}\n"
            "  run with --build first.",
            file=sys.stderr,
        )
        return 2

    result = run(oracle_path, args.helix_dir)
    print_table(result)

    if args.json is not None:
        args.json.write_text(json.dumps(result, indent=2), encoding="utf-8")
        print(f"\n[oracle_compare_akasha] json -> {args.json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
