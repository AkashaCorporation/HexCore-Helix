// ─────────────────────────────────────────────────────────────
// sub_12829 (0x12829)
// Confidence: 50.0% (Low)  |  sysv
// Issues: 2 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, damning honesty defect (uninitialized return value 'result') - confidence capped at 50%
// ─────────────────────────────────────────────────────────────
int64_t sub_12829(int64_t param_2)
{
    int64_t v2;
    int64_t v3 = 0;
    int64_t v4 = 0;
    int64_t gsbase = 0;
    int64_t result;

    if (!param_2) {
        v2 = v3->field_0x8;
        _dev_warn(v2->field_0x28, 0);
        _dev_warn(v2->field_0x28, 0);
        return result;
    } else {
        if (v4 & 0xFFF) {
            v2 = v3->field_0x8;
            v4 = 0;
            v3 = v2->field_0x28;
            _dev_warn(v2->field_0x28, 0);
            _dev_warn(v2->field_0x28, 0);
            return result;
        }
        v2 = *gsbase;
        v3 = v2->field_0x8f8;
        v3 += 176;
        down_write(v3 + 176);
        down_write(v3 + 176);
        return result;
    }
}

