# Helix Log Comparison Report

- Label: `baseline`
- Generated at: `SystemTime { intervals: 134157057863756295 }`
- Logs analyzed: `3`

## Summary Table

| Log | Scenario | Binary | Arch | Address | IR lines | Source lines | Functions | Instructions | Diagnostics | Mean (ms) | Min/Max (ms) | Instr/ms |
| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | ---: |
| `log1.txt` | ROTTR sample A (calls + register moves) | ROTTR.exe | amd64 | 0x14003062f | 516 | 50 | 3 | 52 | 3 | 0.877 | 0.672/2.286 | 59.30 |
| `log2.txt` | ROTTR sample B (LEA + memory stores) | ROTTR.exe | amd64 | 0x14000b2fb | 671 | 45 | 6 | 48 | 6 | 1.646 | 0.882/14.238 | 29.17 |
| `log3.txt` | ROTTR sample C (branch-heavy) - Tomb Raider | ROTTR.exe | amd64 | 0x1400027e7 | 639 | 50 | 2 | 65 | 2 | 16.885 | 0.979/188.399 | 3.85 |

## Per-Log Details

### log1.txt

- Scenario: ROTTR sample A (calls + register moves)
- Binary: ROTTR.exe
- Address: 0x14003062f
- Input size: 25000 bytes (`256 bytes`)
- Architecture: amd64
- Lift generated: 2026-02-13T19:15:55.894Z
- Output: 3 functions, 52 instructions, 50 source lines
- Benchmark: 25 runs, mean 0.877 ms, min 0.672 ms, max 2.286 ms, std 0.300 ms
- Throughput: 59.30 instr/ms

Diagnostics:
- `sub_14003062f: frame=0B, locals=2`
- `sub_140030680: frame=56B, locals=4`
- `sub_140030700: frame=56B, locals=2`

Source preview:

```c
// Decompiled by HexCore Helix
// Source: ROTTR.exe
// Arch:   amd64
// Entry:  0x14003062f
// ─── sub_14003062f ────────────────────────────────
void sub_14003062f(void) {
    int32_t var_40;  // [rsp+0x40]
    int32_t var_44;  // [rsp+0x44]
    sub_140724450();
    void* v0 = sub_1407220b0();
    sub_1407245c0(v0, 0x330, 0, 0x60);
    var_40 = 1;
```

### log2.txt

- Scenario: ROTTR sample B (LEA + memory stores)
- Binary: ROTTR.exe
- Address: 0x14000b2fb
- Input size: 32079 bytes (`256 bytes`)
- Architecture: amd64
- Lift generated: 2026-02-14T12:17:50.151Z
- Output: 6 functions, 48 instructions, 45 source lines
- Benchmark: 25 runs, mean 1.646 ms, min 0.882 ms, max 14.238 ms, std 2.605 ms
- Throughput: 29.17 instr/ms

Diagnostics:
- `sub_14000b2fb: frame=0B, locals=0`
- `sub_14000b320: frame=40B, locals=0`
- `sub_14000b350: frame=40B, locals=0`
- `sub_14000b380: frame=40B, locals=0`
- `sub_14000b3b0: frame=40B, locals=0`
- `sub_14000b3e0: frame=40B, locals=0`

Source preview:

```c
// Decompiled by HexCore Helix
// Source: ROTTR.exe
// Arch:   amd64
// Entry:  0x14000b2fb
// ─── sub_14000b2fb ────────────────────────────────
void sub_14000b2fb(void) {
    void* v0 = sub_140cc57dc();
    sub_1403c34a0();
    return;
}
// ─── sub_14000b320 ────────────────────────────────
void sub_14000b320(void) {
```

### log3.txt

- Scenario: ROTTR sample C (branch-heavy) - Tomb Raider
- Binary: ROTTR.exe
- Address: 0x1400027e7
- Input size: 30968 bytes (`256 bytes`)
- Architecture: amd64
- Lift generated: 2026-02-14T15:47:09.336Z
- Output: 2 functions, 65 instructions, 50 source lines
- Benchmark: 25 runs, mean 16.885 ms, min 0.979 ms, max 188.399 ms, std 47.991 ms
- Throughput: 3.85 instr/ms

Diagnostics:
- `sub_1400027e7: frame=0B, locals=2`
- `sub_140002840: frame=32B, locals=2`

Source preview:

```c
// Decompiled by HexCore Helix
// Source: ROTTR.exe
// Arch:   amd64
// Entry:  0x1400027e7
// ─── sub_1400027e7 ────────────────────────────────
void sub_1400027e7(void) {
    int32_t var_30;  // [rsp+0x30]
    int32_t var_38;  // [rsp+0x38]
    var_38 = 0;
    if (rax != 0) {
        sub_142cad500(0xdad9cff8, &var_38);
    }
```

## Notes

- `log3.txt` is tagged as Tomb Raider sample because the IR header identifies `File: ROTTR.exe`.
- Keep this report under version control to compare future improvements in transforms and decompilation quality.
