// ─────────────────────────────────────────────────────────────
// sub_5e69 (0x5e69)
// Confidence: 49.5% (Low)  |  sysv
// Issues: very short function, 3 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 6 unreachable statement(s) after `return` (lift-quality concern), 1 suspicious self-referencing assignment(s)
// ─────────────────────────────────────────────────────────────
int64_t sub_5e69(int64_t param_1, int64_t param_2)
{
    int64_t v3;
    int64_t v4;
    int64_t result;

    param_1 = *param_1->field_0x8;
    return result;
    return result;
    v3 = param_1 + 0xBF90;
    down_read(param_1 + 0xBF90);
    v4 = v3 + 0xBF90;
    down_read(v3 + 0xBF90);
    _dev_warn(v4->field_0x28, 0, 0);
}

