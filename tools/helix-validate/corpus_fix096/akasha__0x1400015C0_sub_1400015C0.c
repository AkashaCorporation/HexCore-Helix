// ─────────────────────────────────────────────────────────────
// sub_1400015c0 (0x1400015c0)
// Confidence: 50.0% (Low)  |  win64
// Issues: 1 goto(s), 6 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, damning honesty defect (irreducible CFG; no return path recovered) - confidence capped at 50%
// ─────────────────────────────────────────────────────────────
int64_t sub_1400015c0(int64_t param_1, int64_t param_2, int64_t param_3, int64_t param_4, int64_t param_7, int64_t param_8, int64_t param_10)
{
    int64_t v2 = 0;
    int64_t v3;
    int64_t v4 = 0;
    int64_t v0 = 0;
    int64_t v10 = 0;
    int64_t v14 = 0;
    int64_t v6 = 0;
    int64_t v9 = 0;

    v3 = param_1 + 2;
    do {
        if (v2 >= 64) {
            break;
        }
        *v0->field_0xfffffffffffffffe = v0 - 2 ^ v2;
        *v6->field_0xfffffffffffffffc = (int16_t)v2;
        if (v4 >= 64) {
            break;
        }
        *v0->field_0xffffffffffffffff = v0 - 1 ^ v2;
        *v6->field_0xfffffffffffffffe = (int16_t)v2;
        if (v9 >= 64) {
            break;
        }
        v4 = v0 + v10;
        if (v4 >= 64) {
            break;
        }
        *v0->field_0x1 = v0 + 1 ^ v2;
        v9 += v0;
        *v6->field_0x2 = (int16_t)v2;
        if (v9 >= 64) {
            break;
        }
        *v0->field_0x2 = v0 + 2 ^ v2;
        *v6->field_0x4 = (int16_t)v2;
        if (v2 >= 64) {
            break;
        }
        v14 += 6;
        *v0->field_0x3 = v0 + 3 ^ v2;
        v2 = *v0->field_0x3;
        v0 += 6;
        *v6->field_0x6 = (int16_t)v2;
        v6 += 12;
        if (v14 >= 36) {
            break;
        }
    } while (true);
    goto loc_irr_0;
}

