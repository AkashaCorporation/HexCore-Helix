// ─────────────────────────────────────────────────────────────
// sub_4838c2 (0x4838c2)
// Confidence: 74.5% (Medium)  |  cdecl
// Issues: 1 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 4 unreachable statement(s) after `return` (lift-quality concern)
// ─────────────────────────────────────────────────────────────
int64_t sub_4838c2(void)
{
    void* v1 = (void*)0;
    void* v2 = (void*)0;
    int64_t v0 = 0;
    int64_t v3;

    *(v0 + 30) = v0 + 30 | 1;
    __vtable_0xb();
    v3 = (int64_t)*(v1 - 12 + v2);
    *0 = (int32_t)v3;
    return v1;
    *((int64_t)*v1 + 30) = (int64_t)*v1 + 30 | 1;
    __vtable_0xb();
    *0 = (int32_t)(int64_t)*(v2 - 12 + v0);
    return v1;
}

