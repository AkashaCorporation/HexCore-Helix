// ─────────────────────────────────────────────────────────────
// sub_6250f0 (0x6250f0)
// Confidence: 37.0% (Low)  |  cdecl
// Issues: 5 native opcode(s) not decomposed, 4 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 6 unreachable statement(s) after `return` (lift-quality concern), 1 suspicious self-referencing assignment(s)
// ─────────────────────────────────────────────────────────────
int64_t sub_6250f0(void)
{
    int64_t v1 = 0;
    int64_t v2 = 0;
    int64_t v3;
    int64_t v4;
    int32_t var_0; /* stack[0] */
    int64_t v6 = 0;
    int64_t param_1 = 0;
    int64_t param_2 = 0;
    int64_t result;
    int64_t v0 = 0;

    do {
        do {
            if (*(int32_t)v1 != v2) {
                break;
            }
            if (!(int32_t)v1) {
                break;
            }
            v1 = (int64_t)*(v0 + 1);
            if (*(int32_t)v1 != v2 + 1) {
                break;
            }
            v0 += 2;
            v2 += 2;
            var_0 = (void*)0x62512c;
            if (!(int32_t)v1) {
                break;
            }
        } while (true);
        break;
        sub_with_borrow();
        v3 = sub_with_borrow();
        if (!v0) {
            break;
        }
        v3++;
        if (v3 >= 32) {
            break;
        }
    } while (true);
    v4 = 0x8B7D64;
    do {
        if (*(int32_t)v1 != v2) {
            break;
        }
        if (!(int32_t)v1) {
            break;
        }
        v1 = (int64_t)*(v0 + 1);
        if (*(int32_t)v1 != v2 + 1) {
            break;
        }
        v0 += 2;
        v2 += 2;
        if (!(int32_t)v1) {
            break;
        }
    } while (true);
    sub_with_borrow();
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
        v6 += 2;
        if (!(int32_t)param_2) {
            break;
        }
    } while (true);
    sub_with_borrow();
    return result;
    sub_with_borrow();
    return result;
    return result;
}

