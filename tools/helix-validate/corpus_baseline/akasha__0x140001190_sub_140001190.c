// ─────────────────────────────────────────────────────────────
// sub_140001190 (0x140001190)
// Confidence: 50.0% (Low)  |  win64
// Issues: very short function, 3 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, damning honesty defect (code-address leak or out-of-table call) - confidence capped at 50%
// ─────────────────────────────────────────────────────────────
int64_t sub_140001190(void* param_1, int64_t param_2, int64_t param_3, uint64_t param_4, int32_t param_20, int32_t param_21, int32_t param_22, int32_t param_23)
{
    int64_t v1 = 0;
    void* v9 = (void*)0;
    void* v10 = (void*)0;
    int64_t var_10 = 0; /* stack[16] */
    int64_t v14;
    int64_t v15;
    int64_t result;

    v15 = *v10->field_0x40;
    v14 = *(v15 + (v1 << 1));
    *(v9 + var_10) = (int8_t)v14;
    *(v9 + var_10) = (int8_t)0;
    return result;
}

