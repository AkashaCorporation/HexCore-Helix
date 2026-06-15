// ─────────────────────────────────────────────────────────────
// sub_4a0b70 (0x4a0b70)
// Confidence: 36.5% (Low)  |  cdecl
// Issues: 6 native opcode(s) not decomposed, 3 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 7 unreachable statement(s) after `return` (lift-quality concern)
// ─────────────────────────────────────────────────────────────
int64_t sub_4a0b70(void)
{
    int64_t result;
    int64_t v1 = 0;
    int64_t v2;
    int64_t v4;
    int64_t param_1 = 0;
    int64_t param_2 = 0;
    int64_t v0;

    sub_with_borrow();
    v0 = sub_with_borrow();
    do {
        v1 += 2;
        if (!(int32_t)param_2) {
            break;
        }
    } while (true);
    return result;
    return result;
    do {
        if (*(int32_t)param_2 != param_1) {
            break;
        }
        if (!(int32_t)param_2) {
            break;
        }
        if (*(int32_t)param_2 != param_1 + 1) {
            break;
        }
        v1 += 2;
        if (!(int32_t)param_2) {
            break;
        }
    } while (true);
    sub_with_borrow();
    result = sub_with_borrow();
    if (result) {
        v1 = 0x8A3DA8;
        do {
            v4 = (int64_t)*v1;
            if (*(int32_t)param_2 != param_1) {
                break;
            }
            if (!(int32_t)param_2) {
                break;
            }
            v4 = (int64_t)*(v1 + 1);
            if (*(int32_t)param_2 != param_1 + 1) {
                break;
            }
            v1 += 2;
            v2 = param_1 + 2;
            if (!(int32_t)param_2) {
                break;
            }
        } while (true);
        if (*(int32_t)param_2 != param_1) {
            sub_with_borrow();
            v1 &= -6;
            v1 += 5;
            return result;
        }
        if (!(int32_t)param_2) {
            sub_with_borrow();
            v1 &= -6;
            v1 += 5;
            return result;
        }
    }
    return 4;
    return result;
}

