// ─────────────────────────────────────────────────────────────
// sub_140001090 (0x140001090)
// Confidence: 72.5% (Medium)  |  win64
// Issues: 15 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 1 suspicious self-referencing assignment(s)
// ─────────────────────────────────────────────────────────────
int64_t sub_140001090(int64_t param_1, bool param_2, bool param_3, int64_t param_4)
{
    uint64_t v1 = 0;
    int64_t v2;
    int64_t v3;
    int64_t v4;
    int64_t v5;
    int64_t v6;
    int64_t v7;
    int64_t v8;
    int64_t v9;
    int64_t v10;
    int64_t v11;
    int64_t v12;
    int64_t v13;
    int64_t v14;
    int64_t v15;
    int64_t v16;

    param_2 = (v1 ^ param_2) * 0x1000193;
    v6 = param_2 ^ v1;
    param_3 = v6 * 0x1000193;
    v13 = param_3 ^ v1;
    param_2 = v13 * 0x1000193;
    v7 = param_2 ^ v1;
    param_3 = v7 * 0x1000193;
    v14 = param_3 ^ v1;
    param_2 = v14 * 0x1000193;
    v8 = param_2 ^ v1;
    param_3 = v8 * 0x1000193;
    v15 = param_3 ^ v1;
    param_2 = v15 * 0x1000193;
    v9 = param_2 ^ v1;
    param_3 = v9 * 0x1000193;
    v16 = param_3 ^ v1;
    param_2 = v16 * 0x1000193;
    v2 = param_2 ^ v1;
    param_3 = v2 * 0x1000193;
    v10 = param_3 ^ v1;
    param_2 = v10 * 0x1000193;
    v3 = param_2 ^ v1;
    param_3 = v3 * 0x1000193;
    v11 = param_3 ^ v1;
    param_2 = v11 * 0x1000193;
    v4 = param_2 ^ v1;
    param_3 = v4 * 0x1000193;
    v12 = param_3 ^ v1;
    param_2 = v12 * 0x1000193;
    v5 = param_2 ^ v1;
    param_2 = v5 * 0x1000193;
    return param_2;
}

