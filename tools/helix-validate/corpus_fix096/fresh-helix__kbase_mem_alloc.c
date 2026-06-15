// ─────────────────────────────────────────────────────────────
// sub_14579 (0x14579)
// Confidence: 50.0% (Low)  |  sysv
// Issues: very short function, 1 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, damning honesty defect (uninitialized return value 'result') - confidence capped at 50%
// ─────────────────────────────────────────────────────────────
int64_t sub_14579(void* param_1, int64_t param_2, int64_t param_5, int64_t param_6)
{
    int64_t v3 = 0;
    int64_t result;

    if (param_2) {
        return result;
    }
    kbase_check_alloc_flags(v3);
    return result;
}

