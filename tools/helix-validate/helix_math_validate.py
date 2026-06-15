#!/usr/bin/env python3
"""helix-math-validate: proof-oriented checks for Helix CAst output.

This is an evidence generator, not a cleanup pass. It reads Helix's emitted C
and, optionally, the before/after MLIR dumps produced by helix_tool. Findings
are phrased as small theorems or counterexamples so regressions can be cited in
engineering notes and papers without relying on visual inspection.

The default algebraic checks use a tiny affine integer model that is enough to
prove the common "x += x + c" and "x = x + x" families are self-referential.
When a Z3 DLL is available, the same checks also ask Z3 for a concrete
bit-vector counterexample over the emitted C expression. This intentionally
does not call Souper or re-optimize the Remill .ll; the target is Helix's C.
"""

from __future__ import annotations

import argparse
import ctypes
import importlib.util
import json
import os
import re
import shutil
import sys
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Iterable


# ---------------------------------------------------------------------------
# Data model


@dataclass
class Finding:
    kind: str
    line: int
    severity: str
    evidence: str
    proof: str


@dataclass
class MlirEvidence:
    before_path: str | None = None
    after_path: str | None = None
    before_counts: dict[str, int] = field(default_factory=dict)
    after_counts: dict[str, int] = field(default_factory=dict)
    relocations: dict[str, str] = field(default_factory=dict)
    raw_address_symbols: dict[str, str] = field(default_factory=dict)


@dataclass
class Report:
    target: str
    findings: list[Finding]
    mlir: MlirEvidence
    tools: dict[str, bool]


# ---------------------------------------------------------------------------
# Affine expression parser


@dataclass
class Affine:
    coeffs: dict[str, int] = field(default_factory=dict)
    const: int = 0
    unknown: bool = False

    @staticmethod
    def var(name: str) -> "Affine":
        return Affine({name: 1}, 0, False)

    @staticmethod
    def num(value: int) -> "Affine":
        return Affine({}, value, False)

    @staticmethod
    def top() -> "Affine":
        return Affine({}, 0, True)

    def add(self, other: "Affine", sign: int = 1) -> "Affine":
        if self.unknown or other.unknown:
            return Affine.top()
        out = dict(self.coeffs)
        for name, coeff in other.coeffs.items():
            out[name] = out.get(name, 0) + sign * coeff
            if out[name] == 0:
                del out[name]
        return Affine(out, self.const + sign * other.const, False)

    def mul(self, other: "Affine") -> "Affine":
        if self.unknown or other.unknown:
            return Affine.top()
        if self.coeffs and other.coeffs:
            return Affine.top()
        if not self.coeffs:
            return other.scale(self.const)
        if not other.coeffs:
            return self.scale(other.const)
        return Affine.top()

    def scale(self, k: int) -> "Affine":
        if self.unknown:
            return Affine.top()
        return Affine({name: coeff * k for name, coeff in self.coeffs.items()}, self.const * k, False)

    def describe(self) -> str:
        if self.unknown:
            return "unknown"
        parts: list[str] = []
        for name in sorted(self.coeffs):
            coeff = self.coeffs[name]
            if coeff == 1:
                parts.append(name)
            elif coeff == -1:
                parts.append(f"-{name}")
            else:
                parts.append(f"{coeff}*{name}")
        if self.const or not parts:
            parts.append(str(self.const))
        return " + ".join(parts).replace("+ -", "- ")


TOKEN_RE = re.compile(r"\s*(0x[0-9a-fA-F]+|\d+|[A-Za-z_]\w*|[()+\-*])")


class AffineParser:
    def __init__(self, text: str) -> None:
        self.tokens = [m.group(1) for m in TOKEN_RE.finditer(text)]
        self.pos = 0

    def parse(self) -> Affine:
        expr = self.parse_add()
        if self.pos != len(self.tokens):
            return Affine.top()
        return expr

    def peek(self) -> str | None:
        return self.tokens[self.pos] if self.pos < len(self.tokens) else None

    def take(self) -> str | None:
        tok = self.peek()
        if tok is not None:
            self.pos += 1
        return tok

    def parse_add(self) -> Affine:
        out = self.parse_mul()
        while self.peek() in ("+", "-"):
            op = self.take()
            rhs = self.parse_mul()
            out = out.add(rhs, -1 if op == "-" else 1)
        return out

    def parse_mul(self) -> Affine:
        out = self.parse_atom()
        while self.peek() == "*":
            self.take()
            out = out.mul(self.parse_atom())
        return out

    def parse_atom(self) -> Affine:
        tok = self.take()
        if tok is None:
            return Affine.top()
        if tok == "(":
            expr = self.parse_add()
            if self.take() != ")":
                return Affine.top()
            return expr
        if tok == "-":
            return self.parse_atom().scale(-1)
        if re.fullmatch(r"0x[0-9a-fA-F]+|\d+", tok):
            return Affine.num(int(tok, 0))
        if re.fullmatch(r"[A-Za-z_]\w*", tok):
            return Affine.var(tok)
        return Affine.top()


def parse_affine(expr: str) -> Affine:
    return AffineParser(expr).parse()


# ---------------------------------------------------------------------------
# Optional Z3 bit-vector backend


KNOWN_Z3_DLLS = [
    Path(os.environ.get("HELIX_Z3_DLL", "")) if os.environ.get("HELIX_Z3_DLL") else None,
    Path(r"C:\Users\Mazum\Desktop\souper-deps-staging\deps\z3\libz3.dll"),
    Path(r"C:\Users\Mazum\Desktop\vscode-main\extensions\hexcore-souper\deps\z3\libz3.dll"),
]


def find_z3_dll() -> Path | None:
    for candidate in KNOWN_Z3_DLLS:
        if candidate is not None and candidate.exists():
            return candidate
    path_hit = shutil.which("libz3.dll") or shutil.which("z3.dll")
    return Path(path_hit) if path_hit else None


class Z3BitVecEngine:
    """Tiny ctypes wrapper over the Z3 C API for BV equivalence checks."""

    def __init__(self, dll_path: Path | None) -> None:
        self.dll_path = dll_path
        self.error = ""
        self.version = ""
        self.lib = None
        if dll_path is None:
            self.error = "Z3 DLL not found"
            return
        try:
            self.lib = ctypes.CDLL(str(dll_path))
            self._setup_api()
            major = ctypes.c_uint()
            minor = ctypes.c_uint()
            build = ctypes.c_uint()
            rev = ctypes.c_uint()
            self.lib.Z3_get_version(
                ctypes.byref(major), ctypes.byref(minor),
                ctypes.byref(build), ctypes.byref(rev))
            self.version = f"{major.value}.{minor.value}.{build.value}.{rev.value}"
        except Exception as exc:  # pragma: no cover - depends on local DLL.
            self.lib = None
            self.error = str(exc)

    @property
    def available(self) -> bool:
        return self.lib is not None

    def _setup_api(self) -> None:
        assert self.lib is not None
        c_void = ctypes.c_void_p
        c_uint = ctypes.c_uint
        c_char_p = ctypes.c_char_p
        c_int = ctypes.c_int

        self.lib.Z3_get_version.argtypes = [
            ctypes.POINTER(c_uint), ctypes.POINTER(c_uint),
            ctypes.POINTER(c_uint), ctypes.POINTER(c_uint)]
        self.lib.Z3_mk_config.restype = c_void
        self.lib.Z3_del_config.argtypes = [c_void]
        self.lib.Z3_mk_context_rc.argtypes = [c_void]
        self.lib.Z3_mk_context_rc.restype = c_void
        self.lib.Z3_del_context.argtypes = [c_void]
        self.lib.Z3_mk_bv_sort.argtypes = [c_void, c_uint]
        self.lib.Z3_mk_bv_sort.restype = c_void
        self.lib.Z3_mk_string_symbol.argtypes = [c_void, c_char_p]
        self.lib.Z3_mk_string_symbol.restype = c_void
        self.lib.Z3_mk_const.argtypes = [c_void, c_void, c_void]
        self.lib.Z3_mk_const.restype = c_void
        self.lib.Z3_mk_numeral.argtypes = [c_void, c_char_p, c_void]
        self.lib.Z3_mk_numeral.restype = c_void
        self.lib.Z3_mk_unsigned_int64.argtypes = [c_void, ctypes.c_uint64, c_void]
        self.lib.Z3_mk_unsigned_int64.restype = c_void
        self.lib.Z3_mk_bvadd.argtypes = [c_void, c_void, c_void]
        self.lib.Z3_mk_bvadd.restype = c_void
        self.lib.Z3_mk_bvsub.argtypes = [c_void, c_void, c_void]
        self.lib.Z3_mk_bvsub.restype = c_void
        self.lib.Z3_mk_bvmul.argtypes = [c_void, c_void, c_void]
        self.lib.Z3_mk_bvmul.restype = c_void
        self.lib.Z3_mk_eq.argtypes = [c_void, c_void, c_void]
        self.lib.Z3_mk_eq.restype = c_void
        self.lib.Z3_mk_not.argtypes = [c_void, c_void]
        self.lib.Z3_mk_not.restype = c_void
        self.lib.Z3_mk_solver.argtypes = [c_void]
        self.lib.Z3_mk_solver.restype = c_void
        self.lib.Z3_solver_inc_ref.argtypes = [c_void, c_void]
        self.lib.Z3_solver_dec_ref.argtypes = [c_void, c_void]
        self.lib.Z3_solver_assert.argtypes = [c_void, c_void, c_void]
        self.lib.Z3_solver_check.argtypes = [c_void, c_void]
        self.lib.Z3_solver_check.restype = c_int
        self.lib.Z3_solver_get_model.argtypes = [c_void, c_void]
        self.lib.Z3_solver_get_model.restype = c_void
        self.lib.Z3_model_to_string.argtypes = [c_void, c_void]
        self.lib.Z3_model_to_string.restype = c_char_p

    def _num(self, ctx: int, sort: int, value: int, width: int) -> int:
        mask = (1 << width) - 1
        return self.lib.Z3_mk_unsigned_int64(ctx, ctypes.c_uint64(value & mask), sort)

    def _scale_ast(self, ctx: int, sort: int, term: int, coeff: int, width: int) -> int | None:
        """Multiply a BV term by a small integer using bvadd.

        This avoids Z3_mk_bvmul because the local Windows DLL used by HexCore
        currently crashes when called through ctypes. The Helix self-reference
        defects we care about are small-coefficient forms such as 2*x.
        """
        if coeff == 1:
            return term
        if coeff > 32:
            return None
        out = term
        for _ in range(coeff - 1):
            out = self.lib.Z3_mk_bvadd(ctx, out, term)
        return out

    def _expr(self, ctx: int, sort: int, aff: Affine, width: int, vars_: dict[str, int]) -> int | None:
        assert self.lib is not None
        # Avoid constants in the ctypes formula. The local HexCore Z3 DLL works
        # for variable BV ops but crashes on bvadd(const, var) through ctypes.
        # z3_note normalizes equal constants away before calling this method.
        if aff.const != 0:
            return None
        out = None
        for name, coeff in sorted(aff.coeffs.items()):
            if coeff <= 0:
                return None
            if name not in vars_:
                sym = self.lib.Z3_mk_string_symbol(ctx, name.encode("utf-8"))
                vars_[name] = self.lib.Z3_mk_const(ctx, sym, sort)
            term = vars_[name]
            abs_coeff = abs(coeff)
            term = self._scale_ast(ctx, sort, term, abs_coeff, width)
            if term is None:
                return None
            out = term if out is None else self.lib.Z3_mk_bvadd(ctx, out, term)
        if out is None:
            return None
        return out

    def counterexample_not_equal(
        self,
        lhs: Affine,
        rhs: Affine,
        width: int = 64,
    ) -> str | None:
        """Return a Z3 model proving lhs != rhs, or None if unavailable/unsat."""
        if not self.available or lhs.unknown or rhs.unknown:
            return None
        assert self.lib is not None
        try:
            cfg = self.lib.Z3_mk_config()
            ctx = self.lib.Z3_mk_context_rc(cfg)
            self.lib.Z3_del_config(cfg)
        except OSError:
            return None
        solver = None
        try:
            sort = self.lib.Z3_mk_bv_sort(ctx, width)
            vars_: dict[str, int] = {}
            lhs_ast = self._expr(ctx, sort, lhs, width, vars_)
            rhs_ast = self._expr(ctx, sort, rhs, width, vars_)
            if lhs_ast is None or rhs_ast is None:
                return None
            neq = self.lib.Z3_mk_not(ctx, self.lib.Z3_mk_eq(ctx, lhs_ast, rhs_ast))
            solver = self.lib.Z3_mk_solver(ctx)
            self.lib.Z3_solver_inc_ref(ctx, solver)
            self.lib.Z3_solver_assert(ctx, solver, neq)
            check = self.lib.Z3_solver_check(ctx, solver)
            if check != 1:  # Z3_L_TRUE
                return None
            model = self.lib.Z3_solver_get_model(ctx, solver)
            if not model:
                return "sat"
            raw = self.lib.Z3_model_to_string(ctx, model)
            text = raw.decode("utf-8", errors="replace") if raw else "sat"
            return " ".join(text.split())
        except OSError:
            return None
        finally:
            try:
                if solver is not None:
                    self.lib.Z3_solver_dec_ref(ctx, solver)
                self.lib.Z3_del_context(ctx)
            except OSError:
                pass


def z3_note(engine: Z3BitVecEngine | None, got: Affine, expected: Affine) -> str:
    if engine is None or not engine.available:
        return ""
    if got.const != expected.const:
        return ""
    got_norm = Affine(dict(got.coeffs), 0, got.unknown)
    expected_norm = Affine(dict(expected.coeffs), 0, expected.unknown)
    model = engine.counterexample_not_equal(got_norm, expected_norm)
    if not model:
        return ""
    return f" Z3 bit-vector counterexample against `{expected.describe()}`: {model}."


# ---------------------------------------------------------------------------
# C checks


DECL_RE = re.compile(
    r"^\s*(?:[A-Za-z_]\w*(?:\s+\*)?|int\d+_t|uint\d+_t|void\s*\*)\s+"
    r"(?P<name>[A-Za-z_]\w*)\s*(?:=\s*(?P<init>[^;]+))?\s*;"
)
ASSIGN_RE = re.compile(r"^\s*(?P<lhs>[A-Za-z_]\w*)\s*(?P<op>[+\-*/&|^]?=)\s*(?P<rhs>[^;]+);")
STORE_RE = re.compile(r"^\s*\*(?P<ptr>[A-Za-z_]\w*)\s*=\s*(?P<rhs>[^;]+);")
RAW_DEREF_RE = re.compile(r"\*\s*0x(?P<addr>[0-9a-fA-F]+)")
CALL_RE = re.compile(r"\b(?P<callee>[A-Za-z_]\w*)\s*\(")
DECL_SKIP_PREFIXES = ("return ", "if ", "while ", "for ", "switch ", "case ", "goto ")


def strip_comments(line: str) -> str:
    return line.split("//", 1)[0]


def collect_declared_locals(lines: list[str]) -> dict[str, str | None]:
    out: dict[str, str | None] = {}
    for line in lines:
        code = strip_comments(line)
        if code.lstrip().startswith(DECL_SKIP_PREFIXES):
            continue
        m = DECL_RE.match(code)
        if m:
            out.setdefault(m.group("name"), m.group("init"))
    return out


def local_read_counts(lines: list[str], locals_: Iterable[str]) -> dict[str, int]:
    names = set(locals_)
    counts = {name: 0 for name in names}
    for line in lines:
        code = strip_comments(line)
        if DECL_RE.match(code) and not code.lstrip().startswith(DECL_SKIP_PREFIXES):
            continue
        lhs_match = ASSIGN_RE.match(code)
        lhs = lhs_match.group("lhs") if lhs_match else None
        for name in names:
            for _ in re.finditer(rf"\b{re.escape(name)}\b", code):
                counts[name] += 1
        if lhs in counts:
            counts[lhs] -= 1
    return counts


def detect_dead_pc_tracking(lines: list[str], locals_: dict[str, str | None]) -> list[Finding]:
    findings: list[Finding] = []
    reads = local_read_counts(lines, locals_.keys())
    address_taken = {
        name for name in locals_
        if any(re.search(rf"&\s*{re.escape(name)}\b", line) for line in lines)
    }
    for idx, line in enumerate(lines, start=1):
        m = re.match(r"^\s*(var_\w+)\s*=\s*(0x[0-9a-fA-F]+)\s*;", strip_comments(line))
        if not m:
            continue
        name, value = m.group(1), m.group(2)
        if name in locals_ and reads.get(name, 0) == 0 and name not in address_taken:
            findings.append(Finding(
                kind="dead_pc_tracking_store",
                line=idx,
                severity="medium",
                evidence=line.strip(),
                proof=(
                    f"{name} is a local scalar, its address is not taken, and "
                    f"its read-count is 0. The store of {value} is therefore "
                    "not observable by C evaluation; it is consistent with a "
                    "PC/RIP bookkeeping leak, not malware behavior."
                ),
            ))
    return findings


def detect_algebraic_self_reference(
    lines: list[str],
    z3: Z3BitVecEngine | None,
) -> list[Finding]:
    findings: list[Finding] = []
    for idx, line in enumerate(lines, start=1):
        code = strip_comments(line)
        m = ASSIGN_RE.match(code)
        if m:
            lhs, op, rhs = m.group("lhs"), m.group("op"), m.group("rhs").strip()
            rhs_aff = parse_affine(rhs)
            if rhs_aff.unknown:
                continue
            rhs_coeff = rhs_aff.coeffs.get(lhs, 0)
            if rhs_coeff == 0:
                continue
            if op == "=":
                final = rhs_aff
            else:
                final = Affine.var(lhs).add(rhs_aff)
            lhs_coeff = final.coeffs.get(lhs, 0)
            if lhs_coeff != 1:
                expected_simple_update = Affine.var(lhs).add(Affine.num(final.const))
                findings.append(Finding(
                    kind="algebraic_self_reference",
                    line=idx,
                    severity="high",
                    evidence=line.strip(),
                    proof=(
                        f"Affine model gives post-state {lhs}' = "
                        f"{final.describe()}. Coefficient of {lhs} is "
                        f"{lhs_coeff}, so this is not a simple update of "
                        f"{lhs}; for {lhs}=1 it differs from {lhs}+const."
                        + z3_note(z3, final, expected_simple_update)
                    ),
                ))
            continue

        sm = STORE_RE.match(code)
        if sm:
            ptr, rhs = sm.group("ptr"), sm.group("rhs").strip()
            rhs_aff = parse_affine(rhs)
            coeff = rhs_aff.coeffs.get(ptr, 0) if not rhs_aff.unknown else 0
            if coeff >= 2:
                expected_pointer_value = Affine.var(ptr)
                findings.append(Finding(
                    kind="pointer_value_self_store",
                    line=idx,
                    severity="high",
                    evidence=line.strip(),
                    proof=(
                        f"Store value is affine in the destination pointer: "
                        f"value = {rhs_aff.describe()}. This writes a derived "
                        "pointer value, not an independent payload; repeated "
                        "copies are strong evidence of operand binding loss."
                        + z3_note(z3, rhs_aff, expected_pointer_value)
                    ),
                ))
    return findings


def detect_repeated_identical_side_effects(lines: list[str]) -> list[Finding]:
    findings: list[Finding] = []
    prev = ""
    start = 0
    count = 0
    for idx, raw in enumerate(lines + [""], start=1):
        line = strip_comments(raw).strip()
        side_effect = bool(line.endswith(";") and ("(" in line or line.startswith("*")))
        if side_effect and line == prev:
            count += 1
        else:
            if prev and count >= 3:
                findings.append(Finding(
                    kind="repeated_identical_side_effect",
                    line=start,
                    severity="medium",
                    evidence=f"{prev}  // repeated {count} times",
                    proof=(
                        "The same side-effect statement appears consecutively "
                        f"{count} times with no intervening state change in the "
                        "printed C. If the source had distinct call sites or "
                        "stores, their distinguishing operands were lost."
                    ),
                ))
            prev = line if side_effect else ""
            start = idx if side_effect else 0
            count = 1 if side_effect else 0
    return findings


def detect_symbolic_return_zero(lines: list[str], locals_: dict[str, str | None]) -> list[Finding]:
    result_init = locals_.get("result")
    if result_init is None or result_init.strip() != "0":
        return []
    writes = 0
    returns = 0
    decl_line = 0
    for idx, line in enumerate(lines, start=1):
        code = strip_comments(line)
        dm = DECL_RE.match(code)
        if dm and dm.group("name") == "result" and decl_line == 0:
            decl_line = idx
        if re.match(r"^\s*result\s*=", code):
            writes += 1
        if re.match(r"^\s*return\s+result\s*;", code):
            returns += 1
    if writes == 0 and returns:
        return [Finding(
            kind="synthetic_zero_return",
            line=decl_line or 1,
            severity="medium",
            evidence="int64_t result = 0; ... return result;",
            proof=(
                "The return variable has only its synthetic zero initializer "
                "and is returned on at least one path. Unless RAX=0 is proved "
                "in the MLIR, this encodes an unknown machine return as a "
                "concrete zero."
            ),
        )]
    return []


def detect_raw_relocation_derefs(lines: list[str], reloc_map: dict[str, str]) -> list[Finding]:
    findings: list[Finding] = []
    for idx, line in enumerate(lines, start=1):
        for m in RAW_DEREF_RE.finditer(strip_comments(line)):
            addr = m.group("addr").lower().lstrip("0") or "0"
            symbol = reloc_map.get(addr)
            if symbol:
                findings.append(Finding(
                    kind="raw_relocation_deref",
                    line=idx,
                    severity="medium",
                    evidence=line.strip(),
                    proof=(
                        f"MLIR contains relocation metadata mapping 0x{addr} "
                        f"to {symbol}. Emitting *0x{addr} loses the symbol and "
                        "turns relocation state into a raw literal address."
                    ),
                ))
    return findings


def raw_relocation_symbols_used(lines: list[str], reloc_map: dict[str, str]) -> set[str]:
    out: set[str] = set()
    for line in lines:
        for m in RAW_DEREF_RE.finditer(strip_comments(line)):
            addr = m.group("addr").lower().lstrip("0") or "0"
            symbol = reloc_map.get(addr)
            if symbol:
                out.add(symbol)
    return out


def detect_relocated_symbol_calls(
    lines: list[str],
    reloc_map: dict[str, str],
    raw_symbols: set[str],
) -> list[Finding]:
    findings: list[Finding] = []
    relocated_symbols = set(reloc_map.values()) & raw_symbols
    for idx, line in enumerate(lines, start=1):
        code = strip_comments(line)
        for m in CALL_RE.finditer(code):
            callee = m.group("callee")
            if callee in {"if", "while", "switch", "return", "sizeof"}:
                continue
            if callee in relocated_symbols:
                findings.append(Finding(
                    kind="relocated_symbol_called",
                    line=idx,
                    severity="medium",
                    evidence=line.strip(),
                    proof=(
                        f"{callee} is present in relocation metadata. A call "
                        "to a relocated data symbol may indicate that a load or "
                        "address materialization was devirtualized as a call."
                    ),
                ))
    return findings


# ---------------------------------------------------------------------------
# MLIR evidence


MLIR_OPS = [
    "helix_low.call",
    "helix_mid.call",
    "helix_high.call",
    "helix_high.assign",
    "helix_high.return",
    "llvm.call",
    "llvm.store",
    "llvm.load",
    "llvm.add",
]


RELOC_RE = re.compile(r"__hxreloc__0*([0-9a-fA-F]+)__([A-Za-z_][\w.]*)")


def read_text(path: Path | None) -> str:
    if path is None:
        return ""
    try:
        return path.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return ""


def count_mlir_ops(text: str) -> dict[str, int]:
    return {op: text.count(op) for op in MLIR_OPS}


def parse_relocations(*texts: str) -> dict[str, str]:
    out: dict[str, str] = {}
    for text in texts:
        for m in RELOC_RE.finditer(text):
            addr = m.group(1).lower().lstrip("0") or "0"
            out[addr] = m.group(2)
    return out


def build_mlir_evidence(before: Path | None, after: Path | None) -> MlirEvidence:
    before_text = read_text(before)
    after_text = read_text(after)
    relocations = parse_relocations(before_text, after_text)
    return MlirEvidence(
        before_path=str(before) if before else None,
        after_path=str(after) if after else None,
        before_counts=count_mlir_ops(before_text) if before_text else {},
        after_counts=count_mlir_ops(after_text) if after_text else {},
        relocations=relocations,
        raw_address_symbols=relocations,
    )


# ---------------------------------------------------------------------------
# Driver


def analyse_c(
    path: Path,
    mlir: MlirEvidence,
    z3: Z3BitVecEngine | None,
) -> list[Finding]:
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = text.splitlines()
    locals_ = collect_declared_locals(lines)
    findings: list[Finding] = []
    findings.extend(detect_dead_pc_tracking(lines, locals_))
    findings.extend(detect_algebraic_self_reference(lines, z3))
    findings.extend(detect_repeated_identical_side_effects(lines))
    findings.extend(detect_symbolic_return_zero(lines, locals_))
    findings.extend(detect_raw_relocation_derefs(lines, mlir.relocations))
    raw_symbols = raw_relocation_symbols_used(lines, mlir.relocations)
    findings.extend(detect_relocated_symbol_calls(lines, mlir.relocations, raw_symbols))
    findings.sort(key=lambda f: (f.line, f.kind))
    return findings


def tool_inventory() -> dict[str, bool]:
    z3_dll = find_z3_dll()
    alive2_deps = Path(os.environ.get(
        "HELIX_ALIVE2_DEPS",
        r"C:\Users\Mazum\Desktop\souper-deps-staging\deps\alive2",
    ))
    return {
        "python_z3": importlib.util.find_spec("z3") is not None,
        "z3_dll": z3_dll is not None,
        "alive-tv": shutil.which("alive-tv") is not None,
        "mlir-opt": shutil.which("mlir-opt") is not None,
        "opt": shutil.which("opt") is not None,
        "alive2_cpp_libs": (alive2_deps / "lib" / "ir.lib").exists(),
    }


def print_report(report: Report) -> None:
    print(f"target: {report.target}")
    print("tools: " + ", ".join(f"{k}={'yes' if v else 'no'}" for k, v in report.tools.items()))
    if report.mlir.after_counts:
        print("mlir after: " + ", ".join(f"{k}={v}" for k, v in report.mlir.after_counts.items()))
    if report.mlir.relocations:
        mapped = ", ".join(f"0x{k}->{v}" for k, v in sorted(report.mlir.relocations.items()))
        print(f"relocations: {mapped}")
    print()
    if not report.findings:
        print("no proof-oriented findings")
        return
    print(f"{'Ln':>4}  {'Severity':<8} {'Kind':<32} Evidence")
    print("-" * 110)
    for f in report.findings:
        print(f"{f.line:>4}  {f.severity:<8} {f.kind:<32} {f.evidence}")
        print(f"      proof: {f.proof}")


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(
        prog="helix-math-validate",
        description="Proof-oriented mathematical validation for Helix CAst output.",
    )
    ap.add_argument("c_file", type=Path, help="Helix-emitted C file.")
    ap.add_argument("--mlir-before", type=Path, default=None, help="helix_dump_0_before_passes.mlir")
    ap.add_argument("--mlir-after", type=Path, default=None, help="helix_dump_1_after_passes.mlir")
    ap.add_argument("--z3-dll", type=Path, default=find_z3_dll(),
                    help="Optional Z3 DLL for bit-vector counterexamples over C expressions.")
    ap.add_argument("--no-z3", action="store_true",
                    help="Disable Z3 even if a local DLL is available.")
    ap.add_argument("--json", type=Path, default=None, help="Write machine-readable report.")
    args = ap.parse_args(argv)

    if not args.c_file.exists():
        print(f"[helix-math-validate] missing C file: {args.c_file}", file=sys.stderr)
        return 2
    for opt in (args.mlir_before, args.mlir_after):
        if opt is not None and not opt.exists():
            print(f"[helix-math-validate] missing MLIR file: {opt}", file=sys.stderr)
            return 2
    if args.z3_dll is not None and not args.z3_dll.exists():
        print(f"[helix-math-validate] missing Z3 DLL: {args.z3_dll}", file=sys.stderr)
        return 2

    mlir = build_mlir_evidence(args.mlir_before, args.mlir_after)
    z3 = None if args.no_z3 else Z3BitVecEngine(args.z3_dll)
    report = Report(
        target=str(args.c_file),
        findings=analyse_c(args.c_file, mlir, z3),
        mlir=mlir,
        tools=tool_inventory(),
    )
    print_report(report)

    if args.json is not None:
        args.json.write_text(json.dumps(asdict(report), indent=2), encoding="utf-8")
        print(f"\njson: {args.json}")

    return 1 if report.findings else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
