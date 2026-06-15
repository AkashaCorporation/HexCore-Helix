// ─────────────────────────────────────────────────────────────
// sub_1409b9b9e (0x1409b9b9e)
// Confidence: 35.0% (Low)  |  win64
// Issues: 4 native opcode(s) not decomposed, 5 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 43 unreachable statement(s) after `return` (lift-quality concern)
// ─────────────────────────────────────────────────────────────
int64_t sub_1409b9b9e(void* param_1, void* param_2, int64_t param_4, int64_t param_5)
{
    int64_t v1;
    int64_t v2;
    int64_t v3 = 0;
    bool v5;
    int64_t v6 = 0;
    void* v7 = (void*)0;
    void* v8 = (void*)0;
    void* v9 = (void*)0;
    void* v10 = (void*)0;
    float v13 = 0.0f;
    int64_t v14;
    float v15 = 0.0f;
    float v16 = 0.0f;
    float v18;
    float v20;
    float v21 = 0.0f;
    float v22;
    float v24;
    int32_t var_67 = 0; /* stack[103] */
    int64_t v28 = 0;
    int64_t v33 = 0;
    int64_t v35 = 0;
    int64_t v41;
    int64_t v42;
    int64_t v43;
    int64_t v44;
    int64_t v45;

    v43 = (int64_t)*param_2->field_0x54;
    return v9;
    if (v3) {
        return v9;
    }
    v1 = v7->field_0x80;
    v41 = v1;
    v2 = v41 * 9;
    v5 = v2 << 5;
    v42 = 0x42E63080;
    v9 = v7->field_0x68;
    if (!v9) {
        v9 = sub_1409817c0(v8);
    }
    v9 = sub_14025ff50((v5 + v42)->field_0x80);
    v2 = sub_1409817c0(v8);
    if (!v2) {
        sub_1404ea9f0(*v8, v28, v2, v7 + 48);
        v28 = *v8;
        v9 = sub_14024aae0(v28->field_0x68, v28, v2, v7 + 48);
        return simd_move_dquad(v9->field_0x2b0, v28, v2, v7 + 48);
    }
    v14 = sub_14021c1b0(v1 - 73, v43 + 48);
    if (v10->field_0x2f18 != v6) {
        v9 = sub_140981150(v10 + 0x35C0, v1 - 89, 0, 1);
    }
    v44 = 1;
    sub_1409b14b0(v10 + 0x35C0, 1, v44, v1 - 105);
    sub_1404eb760(*v8);
    v45 = *v8;
    v22 = v21 * (v45 + 16 - *(v45 + 44));
    if ((v15[0] + v13[0])[0] == 0.0f) {
        v9 = sqrtf(*v8);
    }
    v20 = 0;
    __native_UNPCKLPS();
    v24 = 0;
    __native_UNPCKLPS();
    __native_MAXPS();
    __native_CMPPS();
    v2 = simd_move_mask_packed_single();
    v5 = v2 & 7;
    if (v5 == 7) {
        sub_14099a250(param_1->field_0x2a8, v1 - 89, 3);
        v28 = *v8;
        v9 = sub_14024aae0(v28->field_0x68, v1 - 89, 3);
        return simd_move_dquad(v9->field_0x2b0, v1 - 89, 3);
    }
    param_4 = v45->field_0x68;
    sub_14027fda0(v1 - 105, 2, &var_67, v45->field_0x68);
    v2 = sub_14040d910(v1 - 105, 2, &var_67, v45->field_0x68);
    if (!(v33 != 0.0f && v35 < 0)) {
        v9 = sqrtf();
    }
    v21 = 0.0f;
    v15 = 2;
    v13 = 1;
    v18 = v16[0.0f] + (v13[0.0f] + v15[0.0f])[0.0f];
    *v14 = v16[1];
    if (v18[0] == 0.0f) {
        v9 = sqrtf();
    }
    v16 = 0.0f;
    *v14 = v18[1];
    sub_1404eb760(*v8);
    return v9;
    return v9;
}

