// ─────────────────────────────────────────────────────────────
// sub_4095a0 (0x4095a0)
// Confidence: 100.0% (High)  |  cdecl
// ─────────────────────────────────────────────────────────────
int64_t sub_4095a0(void)
{
    int64_t v5;
    void* v6 = (void*)0;
    int64_t v0 = 0;
    int64_t v7;
    int64_t v1 = 0;
    int64_t v2 = 0;
    int64_t v4 = 0;

    fp_load();
    fp_store_pop();
    __vtable_0xb();
    fp_store_pop();
    fp_load();
    __vtable_0x16();
    fp_load();
    v5 = fp_div();
    *(v6 - 4 + v0) = (int32_t)v5;
    fp_add();
    fp_store_pop();
    fp_load();
    fp_store_pop();
    __vtable_0x36();
    fp_store_pop();
    fp_load();
    v5 = __vtable_0x44();
    v7 = 0;
    *(v6 - 12 + v1) = (int32_t)v5;
    *(v6 + 8 + v2) = (int32_t)v7;
    v5 = fp_load();
    *(v6 - 8 + v4) = (int32_t)(v5 - v7);
    fp_load_int();
    DoFABS();
    return fp_store_pop();
}

