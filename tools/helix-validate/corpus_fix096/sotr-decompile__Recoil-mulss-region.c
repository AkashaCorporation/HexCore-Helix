// ─────────────────────────────────────────────────────────────
// sub_140ba9eff (0x140ba9eff)
// Confidence: 92.7% (High)  |  win64
// Issues: 2 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA
// ─────────────────────────────────────────────────────────────
int64_t sub_140ba9eff(int64_t param_1, int64_t param_9, int64_t param_11, int64_t param_12, int32_t param_13, int64_t param_14, int64_t param_15)
{
    int64_t v1 = 0;
    int64_t v2 = 0;
    float v3 = 0.0f;
    float v4 = 0.0f;
    float v5;
    float v6;
    int64_t v7 = 0;
    void* v8;
    bool v9 = 0;
    void* v10 = (void*)0;
    int64_t v11 = 0;
    int64_t v16 = 0;
    int64_t v17;
    int64_t v0;

    v5 = v3[0.0f] * v4[0.0f];
    v6 = (double)v5;
    if (!v7) {
        v0 = simd_load_scalar_double();
    } else {
        v0 = sub_140e43bd0(param_9, v3 + 72, param_11);
    }
    v8 = sub_140a022c0(*0x4145B688, 0x41155B18);
    v7 = sub_140a022c0(v6, (v8 + (v2 << 3))->field_0x14e6440);
    if (v9 & 1) {
        v7 = sub_140e43bd0(param_12, v11 + 96, param_14);
    }
    v7 = sub_141024cb6(v10 + 128);
    if (!v7) {
        v7 = sub_14004d7b0(v1, 0x41158860, 0x41155C90);
    }
    sub_14004d7b0(v1, 0x4112FC58, v10 + 128, 0x41155C90);
    v3 = v1 + (v2 << 2) - 32;
    v7 = (int64_t)param_13;
    v5 = v3[0.0f] * v4[0.0f];
    v6 = (double)v5;
    if (!(v9 & 1)) {
        v7 = simd_load_scalar_double();
    } else {
        v7 = sub_140e43bd0(param_12, v11 + 96, param_14);
    }
    if (v1 == 2) {
        return sub_140a022c0(*0x4145B688, 0x41155B18);
    }
    v7 = sub_140a022c0(*0x4145B688, v16);
    v2 = v7;
    v7 = (int64_t)(int32_t)3;
    if (v7 >> 6 & 1) {
        v7 = sub_140e43bd0(param_15, v11 + 120, v6);
    }
    v7 = sub_141024cb6(v10 + 128);
    if (!v7) {
        v7 = sub_14004d7b0(v1, 0x41158860, 0x41155CA8);
    }
    sub_14004d7b0(v1, 0x4112FC58, v10 + 128, 0x41155CA8);
    v17 = v10->field_0x70;
    v7 = *v17;
    vfunc_0x60(v10->field_0x70, v1, 0, v11 + 48);
    return v7;
}

