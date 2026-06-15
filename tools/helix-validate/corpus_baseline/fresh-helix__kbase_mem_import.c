// ─────────────────────────────────────────────────────────────
// sub_14ca9 (0x14ca9)
// Confidence: 91.2% (High)  |  sysv
// Issues: very short function, 1 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA
// ─────────────────────────────────────────────────────────────
int64_t sub_14ca9(void* param_1, int64_t param_2, int64_t param_4)
{
    int64_t v3 = 0;
    int64_t var_10 = 0; /* stack[16] */
    int64_t v4;

    __readgsqword(40);
    v4 = *var_10;
    if (v3) {
        return kbase_check_import_flags();
    }
    v3 = (int64_t)*param_1->field_0x90c0;
    if ((int64_t)0) {
        v4 |= 0x2000;
        return v3;
    }
}

