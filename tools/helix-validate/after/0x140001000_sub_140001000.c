// ─────────────────────────────────────────────────────────────
// sub_140001000 (0x140001000)
// Confidence: 92.0% (High)  |  win64
// Issues: 2 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA
// ─────────────────────────────────────────────────────────────
int64_t sub_140001000(int64_t param_1, int64_t param_2, int64_t param_4)
{
    int64_t result;
    int64_t v1;
    int64_t param_3_1;

    param_3_1 = param_1;
    v1 = *param_3_1;
    if (!v1) {
        return result;
    }
    do {
        param_3_1++;
        result ^= v1;
        v1 = *param_3_1;
        result *= param_2;
        if (!v1) {
            break;
        }
    } while (true);
    return result;
}

