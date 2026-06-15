// ─────────────────────────────────────────────────────────────
// sub_5bbfb5 (0x5bbfb5)
// Confidence: 95.0% (High)  |  cdecl
// Issues: very short function
// ─────────────────────────────────────────────────────────────
int64_t sub_5bbfb5(void)
{
    int64_t v1;
    void* v2;

    v1 = __vtable_0x5();
    v2 = v1 + 0xC4993C;
    *v2 = v2 + (int32_t)v2;
    *v2 = v2 + (int32_t)v2;
    v1 = __vtable_0x13();
    *0->field_0xc49938 = (int32_t)v1;
    return v1;
}

