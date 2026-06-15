// ─────────────────────────────────────────────────────────────
// sub_14003edcd (0x14003edcd)
// Confidence: 82.0% (High)  |  win64
// Issues: 6 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA
// ─────────────────────────────────────────────────────────────
int64_t sub_14003edcd(int64_t param_1)
{
    int32_t var_2c = 0; /* stack[-44] */
    int64_t result;
    int64_t v0 = 0;
    int64_t v1 = 0;
    int64_t v2;
    int64_t v3;
    int64_t v4;

    if (param_1 != 1) {
        if (var_2c) {
            return result;
        }
        if (*v0 >= v1 - 44) {
            v2 = 0x400DAB87;
            v3 = 8;
            v4 = v1 - 16;
            sub_14004b2d0(v1 - 16, 0x400DAB87);
            return result;
        }
        v3 = 0x400D9A69;
        if (*(v3 + (v2 << 2)) != -1) {
            return result;
        }
        sub_14004b2d0(v1 - 32);
        return result;
    } else {
        sub_14004b2d0(v1 - 64, 0x400DABE0);
        return result;
    }
}

