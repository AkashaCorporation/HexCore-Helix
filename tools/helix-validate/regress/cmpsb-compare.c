// ─────────────────────────────────────────────────────────────
// sub_14003ebdb (0x14003ebdb)
// Confidence: 82.0% (High)  |  win64
// Issues: 3 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 2 unreachable statement(s) after `return` (lift-quality concern)
// ─────────────────────────────────────────────────────────────
int64_t sub_14003ebdb(int64_t param_1, void* param_3)
{
    void* v1 = (void*)0;
    int64_t v2 = 0;
    int64_t v3 = 0;
    int64_t v4 = 0;
    int64_t v7 = 0;

    *v1->field_0xffffffffffffff8b = v1 - 117 | param_1;
    *v1->field_0xffffffffffffff89 = v1 - 119 + param_1;
    *param_3->field_0xffffffffffffff89 = param_3 - 119 >> 1;
    v1 = fp_mul();
    *v1->field_0x3b = v1 + 59 | 93;
    if (!v2) {
        v4 += 2;
        return sub_14004afa0(v4 + 2, v3 - 32, 0x40012FE0);
    } else {
        v1 = rep_while_equal_string_compare_byte(v7);
    }
    return v1;
    return v1;
    sub_14004aee0(3, *0x400F2965);
}

