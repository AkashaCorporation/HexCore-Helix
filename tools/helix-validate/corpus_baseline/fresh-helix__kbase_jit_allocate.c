// ─────────────────────────────────────────────────────────────
// sub_3a29 (0x3a29)
// Confidence: 96.2% (High)  |  sysv
// Issues: 1 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA
// ─────────────────────────────────────────────────────────────
int64_t sub_3a29(void* this, void* param_2, int64_t param_3, uint64_t param_4, uint64_t param_5, uint64_t param_6)
{
    void* v1;
    uint64_t v2 = 0;
    int64_t v0;

    __readgsqword(40);
    v1 = this;
    param_6 = *param_2->field_0x22;
    if (!param_6) {
        v0 = *v1->field_0x8;
        down_read(v0 + 0xBF90);
        return v2;
    }
    v2 = *param_2->field_0x21;
    param_5 = *(v1 + v2)->field_0xc5ea;
    if (param_5 >= param_6) {
        return v2;
    }
}

