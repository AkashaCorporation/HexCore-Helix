// ─────────────────────────────────────────────────────────────
// sub_140001350 (0x140001350)
// Confidence: 95.0% (High)  |  win64
// Issues: 1 suspicious self-referencing assignment(s)
// ─────────────────────────────────────────────────────────────
int64_t sub_140001350(int64_t param_1)
{
    void* v1 = (void*)0;
    int64_t v2;
    int64_t v3;
    int64_t v4;
    int64_t v5;
    int64_t v6 = 0;
    int64_t v7;
    int64_t v8 = 0;
    int64_t v9 = 0;

    if (*(v1 + param_1) == 0x4550) {
        if (param_1) {
            v4 = v6 + param_1;
            v3 = (int64_t)v4->field_0x24;
            v2 = (int64_t)v4->field_0x1c;
            v3 += v6;
            v2 += v6;
            v7 = 0;
            if (!(v4->field_0x18 < v7 || v4->field_0x18 == v7)) {
                do {
                    v5 = (int64_t)*(v8 + (v7 << 2));
                    v5 = param_1 + v6;
                    v1 = sub_140001000(param_1 + v6);
                    if (v1 == v9) {
                        break;
                    }
                    v7++;
                    if (*v7 >= v4 + 24) {
                        break;
                    }
                } while (true);
                if (v1 == v9) {
                    v1 = (int64_t)*(v3 + (v7 << 1));
                    v1 = (int64_t)*(v2 + (v1 << 2));
                    v1 += v6;
                    return v1;
                }
            }
        }
        return v1;
    }
    return v1;
}

