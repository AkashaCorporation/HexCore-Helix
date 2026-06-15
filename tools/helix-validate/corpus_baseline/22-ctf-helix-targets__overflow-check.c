// ─────────────────────────────────────────────────────────────
// sub_14003eebd (0x14003eebd)
// Confidence: 89.5% (High)  |  win64
// Issues: very short function, 1 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA
// ─────────────────────────────────────────────────────────────
int64_t sub_14003eebd(int64_t param_1, int64_t param_3)
{
    int64_t v1;
    int64_t param_2_1;

    v1 = umul_full();
    param_2_1 = param_1;
    *param_2_1 = param_2_1 | v1 & 1;
    return v1;
}

