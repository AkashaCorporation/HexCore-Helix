// ─────────────────────────────────────────────────────────────
// sub_1409b9b90 (0x1409b9b90)
// Confidence: 35.0% (Low)  |  win64
// Issues: 4 native opcode(s) not decomposed, 5 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 44 unreachable statement(s) after `return` (lift-quality concern)
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
    float v14 = 0.0f;
    int64_t v15;
    float v16 = 0.0f;
    float v17 = 0.0f;
    float v19;
    float v21;
    int64_t v22;
    int64_t v23;
    float v24 = 0.0f;
    float v25;
    float v27;
    int64_t v30 = 0;
    int64_t v33 = 0;
    int64_t v38 = 0;
    int64_t v40 = 0;
    int64_t v44;
    int64_t v45;
    int64_t v46;
    int64_t v47;
    int64_t v48;

    v9 = param_1;
    v46 = (int64_t)*param_2->field_0x54;
    v11 = *v10->field_0x2a8;
    return v10;
    v5 = v10->field_0x78;
    if (v5) {
        return v10;
    }
    v1 = v8->field_0x80;
    v22 = v3;
    v44 = v1;
    v3 = v44 * 9;
    v45 = 0x42E63080;
    v10 = v8->field_0x68;
    if (!v10) {
        v10 = sub_1409817c0(v2);
    }
    v10 = sub_14025ff50(((v3 << 5) + v45)->field_0x80);
    v1 = sub_1409817c0(v9);
    if (!v1) {
        sub_1404ea9f0(*v2, v33, v30, v1 + 48);
        v33 = *v2;
        v10 = sub_14024aae0(v33->field_0x68, v33, v30, v1 + 48);
        return simd_move_dquad(v10->field_0x2b0, v33, v30, v1 + 48);
    }
    v15 = sub_14021c1b0(v3 - 73, v46 + 48);
    if (v11->field_0x2f18 != v4) {
        v10 = sub_140981150(v38 + 0x35C0, v3 - 89, 0, 1);
    }
    v47 = 1;
    v22 = sub_1409b14b0(v11 + 0x35C0, 1, v47, v3 - 105);
    v23 = sub_1404eb760(*v9);
    v48 = *v9;
    v25 = v24 * (v48 + 16 - *(v48 + 44));
    if ((v16[0] + v14[0])[0] == 0.0f) {
        v10 = sqrtf(*v9);
    }
    v21 = 0;
    __native_UNPCKLPS();
    v27 = 0;
    __native_UNPCKLPS();
    __native_MAXPS();
    __native_CMPPS();
    v1 = simd_move_mask_packed_single();
    if (v2 == 7) {
        sub_14099a250(param_1->field_0x2a8, v3 - 89, 3);
        v33 = *v2;
        v10 = sub_14024aae0(v33->field_0x68, v3 - 89, 3);
        return simd_move_dquad(v10->field_0x2b0, v3 - 89, 3);
    }
    param_4 = v48->field_0x68;
    sub_14027fda0(v3 - 105, 2, v3 + 103, v48->field_0x68);
    v1 = sub_14040d910(v3 - 105, 2, v3 + 103, v48->field_0x68);
    if (!(v40 != 0.0f && v23 < 0)) {
        v10 = sqrtf();
    }
    v24 = 0.0f;
    v16 = 2;
    v14 = 1;
    *v22 = v14[1];
    v19 = v17[0.0f] + (v14[0.0f] + v16[0.0f])[0.0f];
    *v15 = v17[1];
    if (v19[0] == 0.0f) {
        v10 = sqrtf();
    }
    v17 = 0.0f;
    *v15 = v19[1];
    sub_1404eb760(*v9);
    return v10;
    return v10;
}

