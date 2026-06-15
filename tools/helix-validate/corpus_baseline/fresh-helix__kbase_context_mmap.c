// ─────────────────────────────────────────────────────────────
// sub_12bf9 (0x12bf9)
// Confidence: 72.0% (Medium)  |  sysv
// Issues: 2 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 5 unreachable statement(s) after `return` (lift-quality concern)
// ─────────────────────────────────────────────────────────────
int64_t sub_12bf9(void* param_1, void* param_2)
{
    int64_t v1;
    int64_t v2 = 0;
    void* v3;
    int64_t v5 = 0;
    int64_t v8 = 0;
    int64_t v9;
    int64_t param_3_1;
    int64_t result;

    __readgsqword(40);
    v3 = param_2;
    do {
        if (v5->field_0x20 & 8) {
            break;
        }
        v1 = 0xFFFFFFEA;
        _dev_err(v8, 0, v1);
        v1 = (int64_t)param_2->field_0xe8;
        v9 = down_write(v5->field_0x30);
        v9 &= -17;
        v5->field_0x20 = v9;
        if (!(v9 & 2)) {
            break;
        }
    } while (true);
    return result;
    param_3_1 = v3->field_0x10;
    v1 = (int64_t)param_3_1->field_0xe8;
    if (*v1 == v3 + 40) {
        v9 &= -33;
        v5->field_0x20 = v9;
        return result;
    }
    down_write(v3->field_0x30);
    kbase_gpu_vm_lock_with_pmode_sync(v2);
}

