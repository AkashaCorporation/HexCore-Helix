// ─────────────────────────────────────────────────────────────
// sub_4c1ee7 (0x4c1ee7)
// Confidence: 95.0% (High)  |  cdecl
// Issues: 1 suspicious self-referencing assignment(s)
// ─────────────────────────────────────────────────────────────
int64_t sub_4c1ee7(void)
{
    int64_t v2;
    void* v3 = (void*)0;
    int64_t v0 = 0;
    int64_t v1 = 0;

    vfunc_0xe(0xCA21E0);
    v2 = vfunc_0x15(0xCA21E0);
    *(v3 + 8 + v0) = (int32_t)v2;
    *(v3 - 4 + v1) = 1;
    if (!v2) {
        *(v1 + 44) = (int32_t)0;
        return v2;
    } else {
        v2 = v0;
        v0 = vfunc_0xb(v0);
        *(v1 + 44) = (int32_t)v0;
        return v2;
    }
}

