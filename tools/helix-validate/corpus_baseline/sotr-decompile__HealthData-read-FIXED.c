// ─────────────────────────────────────────────────────────────
// sub_140253a70 (0x140253a70)
// Confidence: 50.0% (Low)  |  win64
// Issues: 12 unreachable statement(s) after `return` (lift-quality concern), damning honesty defect (code-address leak or out-of-table call) - confidence capped at 50%
// ─────────────────────────────────────────────────────────────
int64_t sub_140253a70(int64_t param_1, uint64_t param_3, int64_t param_4, int64_t param_14, int64_t param_15, int32_t param_20)
{
    int64_t v1 = 0;
    void* v5;
    float v6;
    void* v7 = (void*)0;
    float v8 = 0.0f;
    int64_t v9 = 0;
    int64_t var_0; /* stack[0] */
    int64_t v15 = 0;
    int64_t v23 = 0;
    int64_t v24 = 0;

    v5 = param_1;
    v6 = 0;
    sub_140253ba9(*0x43452828);
    return v9;
    sub_140253d30(v5);
    param_1 = v5;
    sub_140254080(v5);
    simd_move_dword();
    v9 = int_packed_to_float_packed();
    do {
        if (v1) {
            break;
        }
        v9 = v23->field_0x2a8;
        param_15 = v15;
        v15 = (int64_t)v9->field_0x28;
        v1 = v24;
        v1 -= v15;
        sub_14027ec40(v23);
        sub_140253d0c(v23 + 24);
        sub_140253d0c(v23 + 24);
        sub_140253cb8(*0x43452828);
        sub_140253cb8(*0x43452828);
        simd_move_dword(*0x43452828);
        int_packed_to_float_packed(*0x43452828, v24);
        sub_140256840();
        v9 = (int64_t)*0x4341BC98;
        v23->field_0x2c8 = (int32_t)v9;
        sub_14027c3b0(v23, (int64_t)v23->field_0x4c0, 0);
        v9 = (int64_t)v23->field_0x4c4;
        v23->field_0x4c8 = (int32_t)v9;
        sub_1402602e0(v23, (int64_t)v23->field_0x4c4);
        sub_1402602e0(v23, (int64_t)v23->field_0x4c4);
        sub_140280400(v23);
        v9 = 0;
        v15 -= v9;
        v23->field_0x37c = v23 + 0x37C + v15;
        v9 = sub_14026f5b0(v23, v1);
        v15 = param_15;
        break;
    } while (true);
    if ((int64_t)v5->field_0x384 == -1) {
        v9 = 0x800;
        v23->field_0x38e = v23 + 0x38E | v9;
        return v9;
    }
    param_3 = (int64_t)v5->field_0x386;
    if (param_3 != -1) {
        if ((param_4 + (param_3 << 2))->field_0x1 == v1) {
            (param_4 + (param_3 << 2))->field_0x1 = (int8_t)1;
            v6 = 0.0f;
            v9 = (int64_t)*0x4341BC98;
            v6 = (float)v9;
            v6 = param_1[0.0f] + *(v23 + 0x388);
            v9 = (int64_t)trunc(param_1[0]);
            var_0 = (void*)0x140253cc8 + 38;
            (param_4 + (param_3 << 2))->field_0x4 = (int32_t)v9;
        }
    }
    v7->field_0x4 = (int32_t)v9;
    return fabs(trunc(v8[0])) > 2.14748e+09f ? 0x80000000 : (int64_t)(int32_t)trunc(v8[0]);
    return v9;
}

