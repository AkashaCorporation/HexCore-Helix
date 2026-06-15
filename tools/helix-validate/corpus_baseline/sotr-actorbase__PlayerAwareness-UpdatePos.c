// ─────────────────────────────────────────────────────────────
// sub_1409b9dbf (0x1409b9dbf)
// Confidence: 37.5% (Low)  |  win64
// Issues: 4 native opcode(s) not decomposed, 3 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 22 unreachable statement(s) after `return` (lift-quality concern)
// ─────────────────────────────────────────────────────────────
int64_t sub_1409b9dbf(int64_t param_2, int64_t param_3, int64_t param_33)
{
    int64_t v1 = 0;
    int64_t v2;
    int64_t v3 = 0;
    float v4;
    float v5 = 0.0f;
    float v6 = 0.0f;
    float v7 = 0.0f;
    float v8;
    float v10;
    int16_t var_67 = 0; /* stack[103] */
    int64_t v22 = 0;
    int64_t v23 = 0;
    int64_t v24 = 0;
    int64_t v25 = 0;
    int64_t v27;
    int64_t param_1 = 0;
    int64_t param_4_1;
    int64_t v0 = 0;

    DoCMPSD();
    v2 = sub_140981150(v3 + 0x35C0);
    sub_1404eb760(*v0);
    v5 >>= 11;
    return v2;
    param_4_1 = v1 - 105;
    v2 = sub_1409b14b0(v3 + 0x35C0, 1, param_2, v1 - 105);
    if (!(v23 != 0.0f && v22 < 0)) {
        v2 = sqrtf(v24);
    }
    if (v6[0] != v5[0]) {
        v6 = 0.0f;
    }
    __native_UNPCKLPS();
    v8 = 0;
    __native_UNPCKLPS();
    __native_MAXPS();
    __native_CMPPS();
    v2 = simd_move_mask_packed_single();
    if ((v2 & 7) == 7) {
        sub_14099a250(param_1->field_0x2a8, v1 - 89, 3);
        v27 = *v25;
        v2 = sub_14024aae0(v27->field_0x68, v1 - 89, 3);
        return simd_move_dquad(v2->field_0x2b0, v1 - 89, 3);
    }
    param_2 = 2;
    sub_14027fda0(v1 - 105, 2, &var_67, param_4_1->field_0x68);
    v2 = sub_14040d910(v1 - 105, 2, &var_67, param_4_1->field_0x68);
    if (!(v23 != 0.0f && v22 < 0)) {
        v2 = sqrtf();
    }
    v4 = 0.0f;
    v6 = 2;
    v5 = 1;
    v10 = v7[0.0f] + (v5[0.0f] + v6[0.0f])[0.0f];
    if (v10[0] == 0.0f) {
        v2 = sqrtf();
    }
    v7 = 0.0f;
    return v2;
}

