// ─────────────────────────────────────────────────────────────
// sub_140001740 (0x140001740)
// Confidence: 50.0% (Low)  |  win64
// Issues: 6 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 1 unreachable statement(s) after `return` (lift-quality concern), damning honesty defect (code-address leak or out-of-table call) - confidence capped at 50%
// ─────────────────────────────────────────────────────────────
int64_t sub_140001740(int64_t param_1, int64_t param_2, bool param_3, int64_t param_4, int64_t param_10)
{
    int64_t v1 = 0;
    int64_t v2 = 0;
    int64_t v3;
    void* v5 = (void*)0;
    bool v6;
    int64_t v7;
    void* v13;
    int8_t var_10 = 0; /* stack[16] */
    int64_t var_20 = 0; /* stack[32] */
    int64_t var_c0 = 0; /* stack[192] */
    int64_t var_d0 = 0; /* stack[208] */
    int64_t v16;
    int64_t v17;
    int64_t v18;
    int64_t v19;
    int64_t v20;
    int64_t v21;

    v7 = sub_140001090(&var_10);
    *0x40003000 = (int32_t)v7;
    (*(code *)0x140002008)(0x40003008);
    (*(code *)0x140002010)(0x40003008);
    param_1 = var_c0;
    v7 = var_20;
    param_2 = var_d0;
    v16 = param_1 ^ v7;
    v20 = param_2 | v16;
    param_1 = (int64_t)*v20->field_0x4;
    param_3 = (int64_t)*v20;
    v17 = param_1 << 32;
    param_1 = v17 | param_3;
    (*(code *)0x140002010)();
    v18 = param_1 - 1;
    v21 = v20 * v18;
    (*(code *)0x140002008)(&var_d0, ~v21);
    (*(code *)0x140002018)(&var_d0, ~v21);
    param_2 = v2;
    param_1 = param_2 << 1;
    (*(code *)0x140002008)(v5 + 200, param_2 + 1);
    (*(code *)0x140002018)(v5 + 200, param_2 + 1);
    (*(code *)0x140002010)();
    v13 = __readgsqword(96);
    v5 = *v13->field_0x18 + 32;
    *(v5 + v1)->field_0x10 = (int8_t)param_1;
    *(v5 + v1)->field_0x10 = (int8_t)v2;
    var_c0 = (int32_t)0x6E573941;
    v3 = 0xA5A5A5A5;
    v7 = (int64_t)var_c0;
    v6 = v7 << 32;
    __readgsqword(96);
    v7 = sub_140001190(__readgsqword(96));
    sub_140001350(v7, 0x6B1C110F);
    v7 = __indirect_call(v6 + 48, 0x6B1C110F);
    sub_140001350(v7, 0x3282FB89);
    sub_140001090(&var_10, 0x3282FB89);
    (*(code *)0x140002008)(v6 + 80, 0x3282FB89);
    param_1 = param_10;
    v19 = param_1 - 0x40003008;
    v7 = v19;
    simd_move_dword(param_1 | v7);
    simd_shuffle_dword(v6 + 88);
    sub_140001410(v6 + 88);
    sub_1400015c0(v6 + 88, v5 - 112);
    __indirect_call(0, v6 + 64, v5 - 112, 0);
    return (*(code *)0x140002000)(0, v6 + 64, v5 - 112, 0);
    return (*(code *)0x140001fff)(0);
}

