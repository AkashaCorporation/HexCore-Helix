#!/usr/bin/env python3
"""oracle_builder — ground-truth oracle for the mali_kbase corpus.

helix-validate (`helix_validate.py`) scores Helix output against *internal*
dataflow theorems: it can tell you the output has no `goto`, no null deref, and
a low placeholder rate. What it *cannot* tell you is whether the output is close
to what a mature decompiler (IDA Pro / Hex-Rays) recovers from the same bytes.
A function can score high on helix-validate (clean structure, no degenerate
constructs) while being far from ground truth — lost strings, dropped call args,
duplicated blocks. See `feedback_validator_paralelo_a_isa` and
`decompiler-responsibility-boundary`.

This module builds an *external* oracle. For each of the 7 mali_kbase functions
it parses both the IDA `.c` (treated as ground truth) and the current Helix
`.helix.c`, captures a comparable structural fingerprint of each, derives a
per-category Dramko defect matrix (C0–C14: does Helix carry a defect IDA does
not?), and measures the structural divergence between the two.

The output, `oracle_mali.json`, is consumed by `oracle_compare.py`, which turns
the fingerprints into a proximity-to-IDA score in [0, 1] — a number grounded in
ground truth rather than self-report.

This is pure instrumentation. It never touches engine code and never modifies an
input. Parsing is deliberately regex / brace-matching ("AST-lite"), not a full C
front-end: the inputs are single-function decompiler outputs with one statement
per line and matched braces, where lightweight parsing is both sufficient and
auditable.

Schema (one entry per function, keyed by function name)
-------------------------------------------------------
{
  "function": str,
  "ground_truth_ida":  <Fingerprint>,   # parsed from the IDA .c
  "helix_current":     <Fingerprint>,   # parsed from the Helix .helix.c
  "defect_matrix": {                    # Dramko C0..C14
     "C1_struct_shape": {"helix_defect": bool, "ida_clean": bool,
                         "fires": bool, "evidence": int, "note": str},
     ...
  },
  "divergence_metric": {
     "loc_helix": int, "loc_ida": int, "loc_ratio": float,
     "call_jaccard_distance": float,    # 1 - |∩|/|∪| over normalised callees
     "if_delta": int, "return_delta": int, "call_delta": int,
     "ida_calls_recovered": float       # frac of IDA callees Helix also emits
  }
}

A <Fingerprint> is the dict produced by `Fingerprint.as_dict()`.

Usage
-----
    oracle_builder.py [--helix-dir DIR] [--ida-dir DIR] [--out FILE]
                      [--print]

Defaults point at the Intigrity report tree on this machine; override for CI.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass, field, asdict
from pathlib import Path


# ── corpus definition ─────────────────────────────────────────────────────────

# The 7 mali_kbase functions audited in `mali_helix_vs_ida_diff.md`. Order is the
# diff-doc order so generated tables line up with the prose analysis.
MALI_FUNCTIONS = [
    "kbase_jit_allocate",
    "kbase_mem_alloc",
    "kbase_mem_free",
    "kbase_mem_import",
    "kbase_mem_commit",
    "kbase_csf_queue_register",
    "kbase_context_mmap",
]

# Default report locations on the dev box. CI / other machines pass --helix-dir
# and --ida-dir explicitly.
DEFAULT_HELIX_DIR = Path(
    r"C:\Users\Mazum\Desktop\Intigrity\hexcore-reports\fresh-helix-souper-2"
)
DEFAULT_IDA_DIR = Path(
    r"C:\Users\Mazum\Desktop\Intigrity\hexcore-reports\ida-jit-deep"
)


# ── lexical helpers ───────────────────────────────────────────────────────────

# C keywords + the type-name vocabulary seen across IDA and Helix output. Used
# to decide what counts as a *semantic* identifier (a recovered name) vs noise.
C_KEYWORDS = {
    "if", "else", "for", "while", "do", "switch", "case", "default", "break",
    "continue", "return", "goto", "sizeof", "typeof", "static", "extern",
    "auto", "register", "const", "volatile", "void", "int", "char", "short",
    "long", "float", "double", "signed", "unsigned", "struct", "union",
    "enum", "typedef", "NULL", "true", "false",
}
TYPE_NAMES = {
    "int8_t", "int16_t", "int32_t", "int64_t",
    "uint8_t", "uint16_t", "uint32_t", "uint64_t",
    "u8", "u16", "u32", "u64", "s8", "s16", "s32", "s64",
    "__int8", "__int16", "__int32", "__int64",
    "_BYTE", "_WORD", "_DWORD", "_QWORD", "_OWORD",
    "size_t", "ssize_t", "bool", "__fastcall", "__cdecl", "__usercall",
}
NON_NAME_TOKENS = C_KEYWORDS | TYPE_NAMES

# A placeholder identifier carries no recovered semantics. This is the union of
# Helix placeholders (`v3`, `param_2`, `var_30`, `field_0x8`, `field_8`,
# `sub_310`) and IDA placeholders (`v3`, `a1`). Keeping `field_*` here means a
# raw-offset field access counts against name recovery, exactly as in
# helix_validate.PLACEHOLDER_ID_RE.
PLACEHOLDER_ID_RE = re.compile(
    r"^(?:v\d+|var_\w+|param_\d+|a\d+|field_0x[0-9A-Fa-f]+|field_\d+"
    r"|sub_[0-9A-Fa-f]+|loc_[0-9A-Fa-f]+|unk_[0-9A-Fa-f]+"
    r"|__helix_opaque_va|__helix_zerod_va|__helix_arg)$"
)
ALL_ID_RE = re.compile(r"\b[A-Za-z_][\w]*\b")

# Named field deref `x->name`; raw field deref `x->field_0xN` / `x->field_N`.
RAW_FIELD_RE = re.compile(r"->\s*(field_0x[0-9A-Fa-f]+|field_\d+)\b")
NAMED_FIELD_RE = re.compile(r"->\s*([A-Za-z_]\w*)\b")

STRING_LIT_RE = re.compile(r'"(?:[^"\\]|\\.)*"')

# Deref of a literal address — the Helix C8 signal (`*0x42C18B38`). Hex-Rays
# emits named globals instead, so this fires only on the Helix side.
RAW_ADDR_DEREF_RE = re.compile(r"\*\s*0x[0-9A-Fa-f]{4,}")

# Hex-Rays / MSVC-ism macros — these appear on the IDA side and are the
# canonical IDA-only defects (C9). Helix's RemillToHelixLow passes strip them.
HEXRAYS_MACRO_RE = re.compile(
    r"\b(?:_fentry__|__readgsqword|__readfsqword"
    r"|_Interlocked\w*|_bittest\w*|_InterlockedExchange\w*)\b"
)
# Decompiler sub-register macros (C10) — IDA-only by construction.
DECOMP_MACRO_RE = re.compile(
    r"\b(?:LOBYTE|HIBYTE|LOWORD|HIWORD|LODWORD|HIDWORD|BYTE[1-9]|WORD[1-9]"
    r"|BYTEn|__PAIR\d*__)\b"
)

# dev_warn / dev_err / printk family. Hex-Rays passes a string (or a resolved
# .rodata ref); Helix that lost the literal passes `0`. This is the C6.d signal.
LOG_CALL_NAMES = re.compile(
    r"^_*(?:dev_(?:warn|err|info|dbg|notice)|printk|pr_(?:info|err|warn|debug|notice|cont)"
    r"|seq_printf|_*printf|WARN(?:_ONCE)?|panic)$"
)


# Primitive / scalar type tokens. A declared type built only from these (plus
# qualifiers and `*`) carries no struct recovery; anything else names a struct,
# union, enum or typedef and counts as a recovered type for C3.
PRIMITIVE_TYPE_TOKENS = {
    "void", "char", "short", "int", "long", "float", "double",
    "signed", "unsigned", "const", "volatile", "struct", "union", "enum",
    "bool", "size_t", "ssize_t",
    "int8_t", "int16_t", "int32_t", "int64_t",
    "uint8_t", "uint16_t", "uint32_t", "uint64_t",
    "u8", "u16", "u32", "u64", "s8", "s16", "s32", "s64",
    "__int8", "__int16", "__int32", "__int64",
    "_BYTE", "_WORD", "_DWORD", "_QWORD", "_OWORD",
}


def _is_struct_type(type_str: str) -> bool:
    """True if the declared type names a struct/union/enum/typedef (not a scalar).

    `kbase_va_region *` → True; `int64_t` / `void *` / `u64` → False. A bare
    `struct`/`union`/`enum` keyword followed by a tag also counts.
    """
    toks = [t for t in re.split(r"[\s\*]+", type_str) if t]
    if not toks:
        return False
    if any(t in ("struct", "union", "enum") for t in toks):
        return True
    return any(t not in PRIMITIVE_TYPE_TOKENS for t in toks)


def normalise_callee(name: str) -> str:
    """Strip leading underscores so `_dev_warn`≡`dev_warn`, `__kbase_x`≡`kbase_x`.

    IDA and Helix disagree only on the leading-underscore convention for the
    same kernel symbol; normalising lets call-recovery compare like with like
    without rewarding the cosmetic difference.
    """
    return name.lstrip("_")


def strip_line_comment(line: str) -> str:
    """Remove a trailing `// ...` comment, respecting string literals.

    IDA decls carry register annotations (`u64 v3; // rdx`); we must drop the
    comment for structural parsing but never split inside a `"..."`.
    """
    in_str = False
    esc = False
    i = 0
    while i < len(line) - 1:
        ch = line[i]
        if esc:
            esc = False
        elif ch == "\\":
            esc = True
        elif ch == '"':
            in_str = not in_str
        elif ch == "/" and line[i + 1] == "/" and not in_str:
            return line[:i]
        i += 1
    return line


# ── call extraction (brace/paren matching) ────────────────────────────────────

CALL_HEAD_RE = re.compile(r"([A-Za-z_][\w]*)\s*\(")


def extract_calls(code: str) -> list[tuple[str, list[str]]]:
    """Return [(callee, [arg, ...]), ...] via balanced-paren scanning.

    Skips control-flow keywords (`if (`, `while (`, `sizeof (`) and casts. Args
    are split at the top-level comma so nested calls don't fragment the list.
    """
    calls: list[tuple[str, list[str]]] = []
    for m in CALL_HEAD_RE.finditer(code):
        callee = m.group(1)
        if callee in C_KEYWORDS or callee in TYPE_NAMES:
            continue
        # Scan the balanced parenthesis group following the '('.
        start = m.end()  # char after '('
        depth = 1
        i = start
        in_str = False
        esc = False
        while i < len(code) and depth > 0:
            ch = code[i]
            if esc:
                esc = False
            elif ch == "\\":
                esc = True
            elif ch == '"':
                in_str = not in_str
            elif not in_str:
                if ch == "(":
                    depth += 1
                elif ch == ")":
                    depth -= 1
            i += 1
        if depth != 0:
            continue  # unbalanced — skip rather than guess
        inner = code[start : i - 1]
        args = _split_top_level_args(inner)
        calls.append((callee, args))
    return calls


def _split_top_level_args(inner: str) -> list[str]:
    if inner.strip() == "":
        return []
    args: list[str] = []
    depth = 0
    in_str = False
    esc = False
    cur = []
    for ch in inner:
        if esc:
            esc = False
            cur.append(ch)
            continue
        if ch == "\\":
            esc = True
            cur.append(ch)
            continue
        if ch == '"':
            in_str = not in_str
            cur.append(ch)
            continue
        if not in_str and ch in "([{":
            depth += 1
        elif not in_str and ch in ")]}":
            depth -= 1
        if ch == "," and depth == 0 and not in_str:
            args.append("".join(cur).strip())
            cur = []
        else:
            cur.append(ch)
    if cur:
        args.append("".join(cur).strip())
    return args


ZERO_ARG_RE = re.compile(r"^(?:\(\s*const\s+char\s*\*\s*\)\s*)?0(?:[uUlL]*)?$")


def arg_is_lost_string(arg: str) -> bool:
    """True if `arg` is a bare zero where a format string belongs (C6.d)."""
    return bool(ZERO_ARG_RE.match(arg.strip()))


def arg_is_string_like(arg: str) -> bool:
    """True if `arg` carries a string literal or a resolved .rodata reference.

    IDA emits `"..."`, `(const char *)&::kctx...pgds[N]`, or `&off_DC0`. Any of
    these means a format string survived to this call site.
    """
    a = arg.strip()
    if STRING_LIT_RE.search(a):
        return True
    # IDA's resolved-but-misnamed rodata pointer, or any &symbol passed as fmt.
    if re.search(r"&::|&off_|&unk_|&a[A-Z]", a):
        return True
    return False


# ── declaration extraction ────────────────────────────────────────────────────

# A local declaration: <type tokens> <*?> <name> (= init)? ;
# The type must start with a recognised type token OR a struct-like identifier
# followed by another identifier (so `kbase_va_region *v8;` matches but the
# statement `region = mutex_lock(lock);` does not — there is no second name
# token before the '=' / ';').
DECL_RE = re.compile(
    r"^\s*"
    r"(?P<type>(?:unsigned\s+|signed\s+|const\s+|volatile\s+|struct\s+|union\s+|enum\s+)*"
    r"[A-Za-z_]\w*(?:\s*::\s*[A-Za-z_]\w*)?)"
    r"\s+(?P<ptr>\**)\s*"
    r"(?P<name>[A-Za-z_]\w*)\s*"
    r"(?:=\s*(?P<init>[^;]+?))?\s*;\s*$"
)


def extract_decls(body_lines: list[str]) -> list[tuple[str, str, str | None]]:
    """Return [(type, name, init_or_None), ...] for local declarations.

    Heuristic guard: reject a match whose `name` is a C keyword (e.g. the line
    `return result;` would otherwise read as type=`return`, name=`result`).
    """
    decls: list[tuple[str, str, str | None]] = []
    for raw in body_lines:
        line = strip_line_comment(raw)
        m = DECL_RE.match(line)
        if not m:
            continue
        typ = m.group("type").strip()
        name = m.group("name")
        if typ in C_KEYWORDS or name in C_KEYWORDS:
            continue
        # `x = y;` slips through as type=x name=y only if there's no init group
        # and no second token — but the regex requires `<type> <name>`, i.e. two
        # identifiers, so a plain assignment (one ident before '=') cannot match.
        ptr = m.group("ptr") or ""
        decls.append((f"{typ} {ptr}".strip(), name, m.group("init")))
    return decls


# ── fingerprint ───────────────────────────────────────────────────────────────


@dataclass
class Fingerprint:
    """A comparable structural summary of one decompiled function."""
    source: str                          # "ida" | "helix"
    file: str
    loc: int
    reported_confidence: float | None    # Helix self-report; None for IDA
    return_type: str
    params: list[tuple[str, str]] = field(default_factory=list)   # (type, name)
    decls: list[tuple[str, str]] = field(default_factory=list)    # (type, name)
    callees: list[str] = field(default_factory=list)              # normalised
    callees_raw: list[str] = field(default_factory=list)          # as-emitted
    named_field_count: int = 0
    raw_field_count: int = 0
    string_literals: list[str] = field(default_factory=list)
    raw_addr_derefs: int = 0
    hexrays_macros: int = 0
    decomp_macros: int = 0
    double_derefs: int = 0
    empty_if_blocks: int = 0
    unreachable_after_return: int = 0
    suspicious_self_ref: int = 0
    log_calls_with_string: int = 0
    log_calls_lost_string: int = 0
    if_count: int = 0
    else_count: int = 0
    goto_count: int = 0
    return_count: int = 0
    loop_count: int = 0
    is_stub: bool = False
    placeholder_id_rate: float = 0.0

    def as_dict(self) -> dict:
        return asdict(self)


def _placeholder_rate(code: str) -> float:
    ids = [t for t in ALL_ID_RE.findall(code) if t not in NON_NAME_TOKENS]
    if not ids:
        return 0.0
    bad = sum(1 for t in ids if PLACEHOLDER_ID_RE.match(t))
    return bad / len(ids)


def _count_empty_if_blocks(body_lines: list[str]) -> int:
    """Count `if (...) { }` blocks whose body is empty (C7 — DSE/DCE artifact).

    Matches both `if (c) { }` on one line and an `if (c) {` followed only by
    blank lines then `}`.
    """
    n = 0
    text = "\n".join(strip_line_comment(l) for l in body_lines)
    # One-line empty body.
    n += len(re.findall(r"\bif\s*\([^;{}]*\)\s*\{\s*\}", text))
    # Multi-line: `if (...) {` then whitespace-only lines then `}`.
    lines = text.splitlines()
    for i, line in enumerate(lines):
        if re.search(r"\bif\s*\([^;{}]*\)\s*\{\s*$", line):
            j = i + 1
            while j < len(lines) and lines[j].strip() == "":
                j += 1
            if j < len(lines) and lines[j].strip() == "}":
                n += 1
    return n


LABEL_RE = re.compile(r"^\s*(?:[A-Za-z_]\w*|case\b[^:]*|default)\s*:\s*$")


def _count_unreachable_after_return(body_lines: list[str]) -> int:
    """Statements dominated by a same-depth `return` (mirrors helix_validate T5).

    Theorem: a statement at the same brace depth as, and lexically after, a
    `return` is unreachable — *provided* it has no incoming control edge. A
    label (`LABEL_27:`, `no_reg:`, `case x:`) is a goto/switch target, i.e. it
    *does* have an incoming edge, so it (and code after it) is reachable. We
    clear the pending-return state on any label. This matters because IDA emits
    goto-heavy code with labels after returns, whereas Helix output is
    goto-free — so a non-zero count is a genuine dead-tail only on the Helix
    side. C2 in the defect matrix additionally gates IDA on goto presence.
    """
    n = 0
    depth = 0
    return_depth: int | None = None  # brace depth at which a live `return` sits
    for raw in body_lines:
        line = strip_line_comment(raw)
        stripped = line.strip()
        if stripped == "":
            continue
        if LABEL_RE.match(line):
            # A jump target re-establishes reachability for following code.
            return_depth = None
            depth += line.count("{") - line.count("}")
            continue
        if return_depth is not None and stripped == "}":
            # Closing a brace: if we drop below the return's depth we have left
            # the block the return dominated → following code is reachable again.
            depth += line.count("{") - line.count("}")
            if depth < return_depth:
                return_depth = None
            continue
        if re.match(r"^\s*return\b", line):
            return_depth = depth
            depth += line.count("{") - line.count("}")
            if depth < 0:
                depth = 0
                return_depth = None
            continue
        if return_depth is not None and depth >= return_depth:
            # A real statement after the dominating return, still inside its
            # block and not behind a label → dead.
            n += 1
        depth += line.count("{") - line.count("}")
        if depth < 0:
            depth = 0
            return_depth = None
    return n


def _count_suspicious_self_ref(body_lines: list[str]) -> int:
    """`x = <expr containing x>` / `x op= <expr containing x>` (helix_validate T3)."""
    n = 0
    pat = re.compile(r"^\s*([A-Za-z_]\w*)\s*(?:=|[+\-|^&]=)\s*(.+?);")
    for raw in body_lines:
        line = strip_line_comment(raw)
        m = pat.match(line)
        if not m:
            continue
        var, rhs = m.group(1), m.group(2)
        if rhs.strip() == var:
            continue
        if re.search(rf"\b{re.escape(var)}\b", rhs):
            n += 1
    return n


SIG_RE = re.compile(
    r"^(?P<ret>[A-Za-z_][\w\s\*]*?)\s+"
    r"(?:__fastcall\s+|__cdecl\s+|__usercall\s+)?"
    r"(?P<name>[A-Za-z_]\w*)\s*"
    r"\((?P<params>[^;{]*)\)\s*\{?\s*$"
)


def _parse_params(param_str: str) -> list[tuple[str, str]]:
    out: list[tuple[str, str]] = []
    s = param_str.strip()
    if s in ("", "void"):
        return out
    for part in _split_top_level_args(s):
        part = part.strip()
        if not part:
            continue
        # Last identifier is the name; the rest is the type (pointers stick to
        # whichever side — we keep the type string verbatim).
        m = re.match(r"^(?P<type>.*?)(?P<ptr>[\*\s]*)(?P<name>[A-Za-z_]\w*)$", part)
        if not m:
            out.append((part, ""))
            continue
        typ = (m.group("type") + m.group("ptr")).strip()
        out.append((typ, m.group("name")))
    return out


def _find_signature(lines: list[str]) -> tuple[int, str, str, list[tuple[str, str]]]:
    """Return (def_line_index, name, return_type, params). Raises if not found.

    The first non-comment, non-blank line begins the function definition. IDA
    wraps long parameter lists across several lines, so we accumulate forward
    until the parentheses balance, flatten to a single string, and match. The
    returned index is the *first* signature line, which `_extract_body` then
    brace-matches from.
    """
    n = len(lines)
    i = 0
    while i < n:
        if lines[i].lstrip().startswith("//"):
            i += 1
            continue
        if strip_line_comment(lines[i]).strip() == "":
            i += 1
            continue
        break
    if i >= n:
        raise ValueError("no function signature found")

    start = i
    buf: list[str] = []
    depth = 0
    seen_paren = False
    while i < n:
        s = strip_line_comment(lines[i])
        buf.append(s)
        for ch in s:
            if ch == "(":
                depth += 1
                seen_paren = True
            elif ch == ")":
                depth -= 1
        if seen_paren and depth <= 0:
            break
        i += 1

    flat = re.sub(r"\s+", " ", " ".join(x.strip() for x in buf)).strip()
    m = SIG_RE.match(flat)
    if not m:
        raise ValueError("no function signature found")
    ret = re.sub(r"\b(__fastcall|__cdecl|__usercall)\b", "", m.group("ret")).strip()
    return start, m.group("name"), ret, _parse_params(m.group("params"))


def _extract_body(lines: list[str], def_idx: int) -> list[str]:
    """Brace-match from the function definition to its closing brace."""
    depth = 0
    i = def_idx
    started = False
    body: list[str] = []
    while i < len(lines):
        line = lines[i]
        opens = line.count("{")
        closes = line.count("}")
        if opens:
            started = True
        if started:
            body.append(line)
            depth += opens - closes
            if depth <= 0 and (opens or closes):
                break
        i += 1
    return body


CONFIDENCE_RE = re.compile(r"Confidence:\s*([\d.]+)\s*%")


def parse_function_file(path: Path, source: str) -> Fingerprint:
    """Parse a single-function .c file into a Fingerprint.

    `source` is "ida" or "helix" — it only affects which self-report fields are
    populated; the structural extraction is identical for both.
    """
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = text.splitlines()

    conf: float | None = None
    for line in lines:
        cm = CONFIDENCE_RE.search(line)
        if cm:
            conf = float(cm.group(1))
            break

    def_idx, _name, ret_type, params = _find_signature(lines)
    body_lines = _extract_body(lines, def_idx)
    # Body code with comments stripped, for token-level metrics.
    body_code = "\n".join(strip_line_comment(l) for l in body_lines)

    # Inner statements only (exclude the signature line and the outermost braces)
    # for declaration scanning — decls live at the top of the body.
    inner_lines = body_lines[1:] if body_lines else []

    decls = extract_decls(inner_lines)
    calls = extract_calls(body_code)
    callees_raw = [c for c, _ in calls]
    callees = [normalise_callee(c) for c in callees_raw]

    # Log-call string accounting (C6.d).
    log_with_string = 0
    log_lost = 0
    for callee, args in calls:
        if LOG_CALL_NAMES.match(callee):
            if any(arg_is_string_like(a) for a in args):
                log_with_string += 1
            elif any(arg_is_lost_string(a) for a in args):
                log_lost += 1

    raw_fields = len(RAW_FIELD_RE.findall(body_code))
    # NAMED_FIELD_RE matches `->name` for any name; subtract the raw ones.
    all_fields = len(NAMED_FIELD_RE.findall(body_code))
    named_fields = max(0, all_fields - raw_fields)

    strings = STRING_LIT_RE.findall(body_code)

    fp = Fingerprint(
        source=source,
        file=str(path),
        loc=len(body_lines),
        reported_confidence=conf,
        return_type=ret_type,
        params=params,
        decls=[(t, n) for (t, n, _i) in decls],
        callees=sorted(set(callees)),
        callees_raw=callees_raw,
        named_field_count=named_fields,
        raw_field_count=raw_fields,
        string_literals=strings,
        raw_addr_derefs=len(RAW_ADDR_DEREF_RE.findall(body_code)),
        hexrays_macros=len(HEXRAYS_MACRO_RE.findall(body_code)),
        decomp_macros=len(DECOMP_MACRO_RE.findall(body_code)),
        double_derefs=len(re.findall(r"\*\*\s*[A-Za-z_]", body_code)),
        empty_if_blocks=_count_empty_if_blocks(inner_lines),
        unreachable_after_return=_count_unreachable_after_return(inner_lines),
        suspicious_self_ref=_count_suspicious_self_ref(inner_lines),
        log_calls_with_string=log_with_string,
        log_calls_lost_string=log_lost,
        if_count=len(re.findall(r"\bif\s*\(", body_code)),
        else_count=len(re.findall(r"\belse\b", body_code)),
        goto_count=len(re.findall(r"\bgoto\b", body_code)),
        return_count=len(re.findall(r"\breturn\b", body_code)),
        loop_count=len(re.findall(r"\b(?:for|while)\s*\(", body_code)),
        placeholder_id_rate=_placeholder_rate(body_code),
    )
    # Stub heuristic: a function whose body returns an uninitialised `result`
    # immediately, or whose only real statement is `return <var>;`.
    non_blank = [l.strip() for l in inner_lines if l.strip() not in ("", "{", "}")]
    fp.is_stub = (
        len(non_blank) <= 3
        and any(re.match(r"return\s+\w+\s*;", s) for s in non_blank)
        and not calls
    )
    return fp


# ── Dramko defect matrix ──────────────────────────────────────────────────────
#
# Each entry answers: does Helix carry a defect in this category that IDA does
# not? `fires` is the headline bool. We also record whether Helix has the defect
# and whether IDA is clean, plus an integer evidence count and a short note, so a
# reviewer can audit the verdict instead of trusting it. Categories that are
# IDA-only by construction (C9, C10) will essentially never fire here — that is
# the point: they document Helix *wins*.

DRAMKO_LABELS = {
    "C0_names": "identifier names",
    "C1_struct_shape": "struct/deref shape",
    "C2_extra_missing_code": "extra/missing code",
    "C3_typecast": "missing/wrong typecast",
    "C4_nonequiv_args": "non-equivalent call args",
    "C5_extra_missing_var": "extra/missing variables",
    "C6_literals": "literals (string lost / neg)",
    "C7_control_flow": "control-flow shape",
    "C8_global_var": "global variable reference",
    "C9_hexrays_macros": "hex-rays/MSVC macros",
    "C10_decompiler_macros": "sub-register macros",
    "C11_mem_layout": "memory-layout abuse",
    "C12_void_return": "lost return value/type",
    "C13_composite_decomp": "composite var decomposition",
    "C14_typedep_expr": "type-dependent wrong expr",
}


def _matched_callees(helix: Fingerprint, ida: Fingerprint) -> set[str]:
    return set(helix.callees) & set(ida.callees)


def build_defect_matrix(helix: Fingerprint, ida: Fingerprint) -> dict:
    """Compute the C0–C14 Helix-only defect matrix from the two fingerprints."""
    m: dict[str, dict] = {}

    def entry(key, helix_defect, ida_clean, evidence, note):
        m[key] = {
            "label": DRAMKO_LABELS[key],
            "helix_defect": bool(helix_defect),
            "ida_clean": bool(ida_clean),
            "fires": bool(helix_defect and ida_clean),
            "evidence": int(evidence),
            "note": note,
        }

    # C0 — names. Helix placeholder rate materially exceeds IDA's.
    excess = helix.placeholder_id_rate - ida.placeholder_id_rate
    entry(
        "C0_names",
        helix_defect=excess > 0.15,
        ida_clean=ida.placeholder_id_rate < helix.placeholder_id_rate,
        evidence=round(excess * 100),
        note=f"helix placeholder {helix.placeholder_id_rate:.0%} vs ida {ida.placeholder_id_rate:.0%}",
    )

    # C1 — struct shape. Helix emits raw field offsets where IDA named fields.
    entry(
        "C1_struct_shape",
        helix_defect=helix.raw_field_count > 0,
        ida_clean=ida.raw_field_count == 0 and ida.named_field_count > 0,
        evidence=helix.raw_field_count,
        note=f"helix {helix.raw_field_count} raw fields; ida {ida.named_field_count} named",
    )

    # C2 — extra/missing code. Helix dead tail after `return`, or a stub that
    # dropped the whole body while IDA recovered it.
    helix_extra = helix.unreachable_after_return > 0 or helix.is_stub
    # IDA's apparent post-return code is reachable via goto when the function is
    # goto-heavy; only trust IDA's count as genuine dead code when it is
    # goto-free. Helix is always goto-free, so its dead tails are real.
    ida_c2_clean = not ida.is_stub and (
        ida.unreachable_after_return == 0 or ida.goto_count > 0
    )
    entry(
        "C2_extra_missing_code",
        helix_defect=helix_extra,
        ida_clean=ida_c2_clean,
        evidence=helix.unreachable_after_return + (1 if helix.is_stub else 0),
        note=("stub: body dropped" if helix.is_stub
              else f"{helix.unreachable_after_return} unreachable stmts after return"),
    )

    # C3 — typecast / type recovery. IDA recovers struct-pointer types
    # (`kbase_va_region *v8`); Helix collapses everything to scalar
    # `int64_t`/`void*`. The defect fires when IDA recovered struct types and
    # Helix recovered none — i.e. the pointer/struct typing was lost.
    helix_struct_typed = sum(1 for (t, _n) in helix.decls if _is_struct_type(t))
    ida_struct_typed = sum(1 for (t, _n) in ida.decls if _is_struct_type(t))
    entry(
        "C3_typecast",
        helix_defect=helix_struct_typed == 0 and ida_struct_typed >= 3,
        ida_clean=ida_struct_typed > 0,
        evidence=ida_struct_typed,
        note=f"ida recovered {ida_struct_typed} struct-typed locals; helix {helix_struct_typed}",
    )

    # C4 — non-equivalent call args. For callees present in both, does Helix emit
    # a different arg count? (Captures the over-/under-supplied args the diff doc
    # flags, e.g. kbase_gpu_vm_unlock_with_pmode_sync(v6) vs (kctx, ...).)
    helix_arity: dict[str, int] = {}
    for c, a in extract_calls_from_fp(helix):
        helix_arity.setdefault(normalise_callee(c), len(a))
    ida_arity: dict[str, int] = {}
    for c, a in extract_calls_from_fp(ida):
        ida_arity.setdefault(normalise_callee(c), len(a))
    arity_mismatches = [
        k for k in (set(helix_arity) & set(ida_arity))
        if helix_arity[k] != ida_arity[k]
    ]
    entry(
        "C4_nonequiv_args",
        helix_defect=len(arity_mismatches) > 0,
        ida_clean=True,  # IDA arity is the reference
        evidence=len(arity_mismatches),
        note=("arity mismatch on: " + ", ".join(sorted(arity_mismatches)[:4]))
             if arity_mismatches else "no arity mismatch on shared callees",
    )

    # C5 — extra/missing variables. Compare declared-var counts.
    var_delta = abs(len(helix.decls) - len(ida.decls))
    entry(
        "C5_extra_missing_var",
        helix_defect=var_delta >= 3,
        ida_clean=True,
        evidence=var_delta,
        note=f"helix {len(helix.decls)} decls vs ida {len(ida.decls)}",
    )

    # C6 — literals. Helix lost a format string a log call needed.
    entry(
        "C6_literals",
        helix_defect=helix.log_calls_lost_string > 0,
        ida_clean=ida.log_calls_with_string > 0 or ida.log_calls_lost_string == 0,
        evidence=helix.log_calls_lost_string,
        note=f"helix lost {helix.log_calls_lost_string} fmt strings; "
             f"ida kept {ida.log_calls_with_string}",
    )

    # C7 — control flow. Empty if-bodies (DSE artifact) that IDA does not have.
    entry(
        "C7_control_flow",
        helix_defect=helix.empty_if_blocks > 0,
        ida_clean=ida.empty_if_blocks == 0,
        evidence=helix.empty_if_blocks,
        note=f"{helix.empty_if_blocks} empty if-bodies",
    )

    # C8 — global vars. Helix derefs a raw literal address; IDA names the global.
    entry(
        "C8_global_var",
        helix_defect=helix.raw_addr_derefs > 0,
        ida_clean=ida.raw_addr_derefs == 0,
        evidence=helix.raw_addr_derefs,
        note=f"{helix.raw_addr_derefs} raw *0xADDR derefs",
    )

    # C9 — hex-rays/MSVC macros. IDA-only by construction → Helix essentially
    # never has the defect. Documents a Helix win.
    entry(
        "C9_hexrays_macros",
        helix_defect=helix.hexrays_macros > 0,
        ida_clean=ida.hexrays_macros == 0,
        evidence=helix.hexrays_macros,
        note=f"helix {helix.hexrays_macros} vs ida {ida.hexrays_macros} (IDA-only expected)",
    )

    # C10 — sub-register macros. IDA-only by construction → Helix win.
    entry(
        "C10_decompiler_macros",
        helix_defect=helix.decomp_macros > 0,
        ida_clean=ida.decomp_macros == 0,
        evidence=helix.decomp_macros,
        note=f"helix {helix.decomp_macros} vs ida {ida.decomp_macros} (IDA-only expected)",
    )

    # C11 — memory-layout abuse. Helix surfaces an opaque `gsbase` per-cpu read.
    helix_gsbase = bool(re.search(r"\bgsbase\b", " ".join(n for _, n in helix.decls)))
    entry(
        "C11_mem_layout",
        helix_defect=helix_gsbase,
        ida_clean=ida.hexrays_macros >= 0,  # IDA uses __readgsqword (its own C9/C11)
        evidence=1 if helix_gsbase else 0,
        note="opaque gsbase per-cpu access" if helix_gsbase else "no gsbase abuse",
    )

    # C12 — lost return value/type. Helix stub returns uninitialised, or its
    # return type collapsed to a bare int while IDA kept a typed pointer return.
    c12 = helix.is_stub
    entry(
        "C12_void_return",
        helix_defect=c12,
        ida_clean=not ida.is_stub,
        evidence=1 if c12 else 0,
        note="returns uninitialised value (stub)" if c12 else "return value present",
    )

    # C13 — composite var decomposition. Helix `**p` double-deref where it lost
    # an intermediate field (the diff-doc `**v5->field_8->field_28` case).
    entry(
        "C13_composite_decomp",
        helix_defect=helix.double_derefs > 0,
        ida_clean=ida.double_derefs == 0,
        evidence=helix.double_derefs,
        note=f"{helix.double_derefs} double-deref (**) sites",
    )

    # C14 — type-dependent wrong expr. Helix suspicious self-reference (e.g.
    # `x = x + x`, equality-as-subtraction) absent in IDA.
    entry(
        "C14_typedep_expr",
        helix_defect=helix.suspicious_self_ref > 0,
        ida_clean=ida.suspicious_self_ref == 0,
        evidence=helix.suspicious_self_ref,
        note=f"{helix.suspicious_self_ref} suspicious self-referencing assigns",
    )

    return m


# Calls are not stored on the Fingerprint with arity (only the callee name set
# is), so we re-extract from the source file when the matrix needs arities. This
# keeps the JSON small while still allowing C4 to be computed.
_CALL_CACHE: dict[str, list[tuple[str, list[str]]]] = {}


def extract_calls_from_fp(fp: Fingerprint) -> list[tuple[str, list[str]]]:
    if fp.file in _CALL_CACHE:
        return _CALL_CACHE[fp.file]
    try:
        text = Path(fp.file).read_text(encoding="utf-8", errors="replace")
        lines = text.splitlines()
        def_idx, _n, _r, _p = _find_signature(lines)
        body = _extract_body(lines, def_idx)
        code = "\n".join(strip_line_comment(l) for l in body)
        calls = extract_calls(code)
    except (OSError, ValueError):
        calls = []
    _CALL_CACHE[fp.file] = calls
    return calls


# ── divergence metric ─────────────────────────────────────────────────────────


def build_divergence(helix: Fingerprint, ida: Fingerprint) -> dict:
    h, i = set(helix.callees), set(ida.callees)
    union = h | i
    jaccard = (len(h & i) / len(union)) if union else 1.0
    ida_recovered = (len(h & i) / len(i)) if i else 1.0
    return {
        "loc_helix": helix.loc,
        "loc_ida": ida.loc,
        "loc_ratio": round(helix.loc / ida.loc, 3) if ida.loc else 0.0,
        "call_jaccard_distance": round(1.0 - jaccard, 3),
        "ida_calls_recovered": round(ida_recovered, 3),
        "if_delta": helix.if_count - ida.if_count,
        "return_delta": helix.return_count - ida.return_count,
        "call_delta": len(helix.callees_raw) - len(ida.callees_raw),
        "var_delta": len(helix.decls) - len(ida.decls),
    }


# ── top-level build ───────────────────────────────────────────────────────────


def find_helix_file(helix_dir: Path, fn: str) -> Path | None:
    """Prefer the canonical `<fn>.helix.c` (matches the diff-doc LOCs); the
    `.souper.helix.c` variant is a Souper-optimised build and is not the
    baseline output."""
    cand = helix_dir / f"{fn}.helix.c"
    return cand if cand.exists() else None


def find_ida_file(ida_dir: Path, fn: str) -> Path | None:
    cand = ida_dir / f"{fn}.c"
    return cand if cand.exists() else None


def build_oracle(helix_dir: Path, ida_dir: Path) -> dict:
    entries: dict[str, dict] = {}
    problems: list[str] = []
    for fn in MALI_FUNCTIONS:
        hpath = find_helix_file(helix_dir, fn)
        ipath = find_ida_file(ida_dir, fn)
        if hpath is None:
            problems.append(f"{fn}: missing Helix output")
            continue
        if ipath is None:
            problems.append(f"{fn}: missing IDA ground truth")
            continue
        try:
            helix_fp = parse_function_file(hpath, "helix")
            ida_fp = parse_function_file(ipath, "ida")
        except ValueError as e:
            problems.append(f"{fn}: parse error — {e}")
            continue
        entries[fn] = {
            "function": fn,
            "ground_truth_ida": ida_fp.as_dict(),
            "helix_current": helix_fp.as_dict(),
            "defect_matrix": build_defect_matrix(helix_fp, ida_fp),
            "divergence_metric": build_divergence(helix_fp, ida_fp),
        }
    return {
        "schema_version": 1,
        "corpus": "mali_kbase (r54p3-00eac0)",
        "helix_dir": str(helix_dir),
        "ida_dir": str(ida_dir),
        "dramko_labels": DRAMKO_LABELS,
        "functions": entries,
        "problems": problems,
    }


def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(
        prog="oracle_builder",
        description="Build the mali_kbase ground-truth oracle (oracle_mali.json).",
    )
    p.add_argument("--helix-dir", type=Path, default=DEFAULT_HELIX_DIR)
    p.add_argument("--ida-dir", type=Path, default=DEFAULT_IDA_DIR)
    p.add_argument("--out", type=Path,
                   default=Path(__file__).resolve().parent / "oracle_mali.json")
    p.add_argument("--print", dest="do_print", action="store_true",
                   help="Print a one-line-per-function summary to stdout.")
    args = p.parse_args(argv)

    if not args.helix_dir.exists():
        print(f"[oracle_builder] helix-dir not found: {args.helix_dir}", file=sys.stderr)
        return 2
    if not args.ida_dir.exists():
        print(f"[oracle_builder] ida-dir not found: {args.ida_dir}", file=sys.stderr)
        return 2

    oracle = build_oracle(args.helix_dir, args.ida_dir)
    args.out.write_text(json.dumps(oracle, indent=2), encoding="utf-8")
    print(f"[oracle_builder] wrote {len(oracle['functions'])} entries -> {args.out}")
    for prob in oracle["problems"]:
        print(f"[oracle_builder] WARN {prob}", file=sys.stderr)

    if args.do_print:
        print()
        for fn, e in oracle["functions"].items():
            fires = [k for k, v in e["defect_matrix"].items() if v["fires"]]
            dm = e["divergence_metric"]
            print(f"{fn:<28} loc {dm['loc_helix']:>3}/{dm['loc_ida']:<3} "
                  f"calls_recovered={dm['ida_calls_recovered']:.0%}  "
                  f"defects={len(fires)} ({','.join(c.split('_')[0] for c in fires)})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
