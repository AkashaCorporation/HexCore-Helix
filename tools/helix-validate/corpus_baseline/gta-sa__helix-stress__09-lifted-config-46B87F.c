// ─────────────────────────────────────────────────────────────
// sub_46b87f (0x46b87f)
// Confidence: 79.5% (Medium)  |  cdecl
// Issues: 1 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 3 suspicious self-referencing assignment(s)
// ─────────────────────────────────────────────────────────────
int64_t sub_46b87f(void)
{
    int64_t v2 = 0;
    void* v3;
    int64_t v4 = 0;
    void* v5 = (void*)0;
    int64_t v6;
    void* v7 = (void*)0;
    int64_t v0 = 0;
    int64_t v1 = 0;
    int64_t result;

    __vtable_0xb();
    __vtable_0x12();
    __vtable_0x1b();
    v3 = v2 * 0x190;
    vfunc_0x39(v2 * 0x190);
    vfunc_0x3f(v2 * 0x190);
    fp_load((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
    fp_store_pop((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
    fp_load((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
    fp_store_pop((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
    fp_load((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
    fp_store_pop((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
    fp_load((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
    fp_compare_pop((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
    v6 = fp_store_status_word((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
    if (!(((int8_t)((int32_t)0 & 65) ^ (int8_t)((int32_t)0 & 65) >> 4 ^ ((int8_t)((int32_t)0 & 65) ^ (int8_t)((int32_t)0 & 65) >> 4) >> 2 ^ ((int8_t)((int32_t)0 & 65) ^ (int8_t)((int32_t)0 & 65) >> 4 ^ ((int8_t)((int32_t)0 & 65) ^ (int8_t)((int32_t)0 & 65) >> 4) >> 2) >> 1) & 1)) {
        vfunc_0x7(v2 * 0x190);
        fp_add((int64_t)*v0, v2 * 0x190);
        fp_store_pop((int64_t)*v0, v2 * 0x190);
        fp_load((int64_t)*v0, v2 * 0x190);
        fp_store_pop((int64_t)*v0, v2 * 0x190);
        fp_load((int64_t)*v0, v2 * 0x190);
        fp_store_pop((int64_t)*v0, v2 * 0x190);
        fp_load((int64_t)*v0, v2 * 0x190);
        fp_store_pop((int64_t)*v0, v2 * 0x190);
        vfunc_0x2b(v2 * 0x190);
        fp_load((int64_t)*v0, v2 * 0x190);
        v2 = fp_store_pop((int64_t)*v0, v2 * 0x190);
        fp_load((int64_t)*v0, v2 * 0x190);
        fp_store_pop(v3 - 32, v2 * 0x190);
        fp_load(v3 - 32, v2 * 0x190);
        fp_store_pop(v3 - 32, v2 * 0x190);
        vfunc_0x49(v2 * 0x190);
        vfunc_0x4f(v2 * 0x190);
        *0->field_0xabb610 = (int32_t)v4;
        vfunc_0x61(v2 * 0x190);
        v2 = vfunc_0x68(v5, v2 * 0x190);
        *(v3 + 8 + v6) = (int32_t)v2;
        *(v3 - 4 + v6) = 0;
    } else {
        fp_load((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
        fp_store_pop((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
        fp_load((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
        fp_store_pop((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
        vfunc_0x15(v2 * 0x190);
        v2 = fp_store_pop((int64_t)*(v3 + 0xC100D0), v2 * 0x190);
    }
    vfunc_0x7();
    *(v7 - 4 + v0) = -1;
    vfunc_0x1c((int64_t)*v5);
    v4 = (int64_t)*(v7 - 12 + v1);
    *0 = (int32_t)v4;
    return result;
}

