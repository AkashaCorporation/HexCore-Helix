// ─────────────────────────────────────────────────────────────
// sub_1409b9b90 (0x1409b9b90)
// Confidence: 35.0% (Low)  |  win64
// Issues: 4 native opcode(s) not decomposed, 5 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 46 unreachable statement(s) after `return` (lift-quality concern)
// ─────────────────────────────────────────────────────────────
int64_t sub_1409b9b90(void* param_1, void* param_2, int64_t param_4, int64_t param_5)
{
    int64_t v1;
    int64_t v2 = 0;
    int64_t v3 = 0;
    int64_t v4 = 0;
    int64_t v5;
    void* v8 = (void*)0;
    void* v9;
    void* v10 = (void*)0;
    void* v11;
    bool v12;
    float v15 = 0.0f;
    int64_t v16;
    float v17 = 0.0f;
    float v18 = 0.0f;
    float v20;
    float v22;
    int64_t v23;
    int64_t v24;
    float v25 = 0.0f;
    float v26;
    float v28;
    int64_t v30 = 0;
    int64_t v33 = 0;
    int64_t v39 = 0;
    int64_t v41 = 0;
    int64_t v45;
    int64_t v46;
    int64_t v47;
    int64_t v48;
    int64_t v49;

    v9 = param_1;
    v47 = (int64_t)*param_2->field_0x54;
    v11 = *v10->field_0x2a8;
    return v10;
    v5 = v10->field_0x78;
    if (v5) {
        return v10;
    }
    v1 = v8->field_0x80;
    v23 = v3;
    v45 = v1;
    v3 = v45 * 9;
    v12 = v3 << 5;
    v46 = 0x42E63080;
    v10 = v8->field_0x68;
    if (!v10) {
        v10 = sub_1409817c0(v2);
    }
    v10 = sub_14025ff50((v12 + v46)->field_0x80);
    v1 = sub_1409817c0(v9);
    if (!v1) {
        sub_1404ea9f0(*v2, v33, v30, v1 + 48);
        v33 = *v2;
        v10 = sub_14024aae0(v33->field_0x68, v33, v30, v1 + 48);
        return simd_move_dquad(v10->field_0x2b0, v33, v30, v1 + 48);
    }
    v16 = sub_14021c1b0(v3 - 73, v47 + 48);
    if (v11->field_0x2f18 != v4) {
        v10 = sub_140981150(v39 + 0x35C0, v3 - 89, 0, 1);
    }
    v48 = 1;
    v23 = sub_1409b14b0(v11 + 0x35C0, 1, v48, v3 - 105);
    v24 = sub_1404eb760(*v9);
    v49 = *v9;
    v26 = v25 * (v49 + 16 - *(v49 + 44));
    if ((v17[0] + v15[0])[0] == 0.0f) {
        v10 = sqrtf(*v9);
    }
    v22 = 0;
    __native_UNPCKLPS();
    v28 = 0;
    __native_UNPCKLPS();
    __native_MAXPS();
    __native_CMPPS();
    v1 = simd_move_mask_packed_single();
    v12 = v1 & 7;
    if (v12 == 7) {
        sub_14099a250(param_1->field_0x2a8, v3 - 89, 3);
        v33 = *v2;
        v10 = sub_14024aae0(v33->field_0x68, v3 - 89, 3);
        return simd_move_dquad(v10->field_0x2b0, v3 - 89, 3);
    }
    param_4 = v49->field_0x68;
    sub_14027fda0(v3 - 105, 2, v3 + 103, v49->field_0x68);
    v1 = sub_14040d910(v3 - 105, 2, v3 + 103, v49->field_0x68);
    if (!(v41 != 0.0f && v24 < 0)) {
        v10 = sqrtf();
    }
    v25 = 0.0f;
    v17 = 2;
    v15 = 1;
    *v23 = v15[1];
    v20 = v18[0.0f] + (v15[0.0f] + v17[0.0f])[0.0f];
    *v16 = v18[1];
    if (v20[0] == 0.0f) {
        v10 = sqrtf();
    }
    v18 = 0.0f;
    *v16 = v20[1];
    sub_1404eb760(*v9);
    return v10;
    return v10;
}

