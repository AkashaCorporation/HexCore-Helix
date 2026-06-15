// ─────────────────────────────────────────────────────────────
// sub_140001410 (0x140001410)
// Confidence: 66.5% (Medium)  |  win64
// Issues: 8 native opcode(s) not decomposed, 1 auto-declared placeholder variable(s) — lift-quality concern; verify against IDA, 1 suspicious self-referencing assignment(s)
// ─────────────────────────────────────────────────────────────
int64_t sub_140001410(int64_t param_1, bool param_2, int64_t param_3, int64_t param_4, int64_t param_6)
{
    int64_t v1 = 0;
    int64_t v2;
    int64_t result;
    int64_t v3 = 0;

    simd_move_dquad();
    v2 = 0;
    do {
        simd_move_dword(v1 - 4);
        simd_shuffle_dword(v1 - 4);
        simd_add_dword(v1 - 4);
        simd_move_dword(v1 - 4);
        simd_shuffle_dword(v1 - 4);
        simd_add_dword(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_and(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_and(v1 + 4);
        __native_PACKUSWB(v1 + 4);
        __native_PACKUSWB(v1 + 4);
        result += 16;
        __native_PACKUSWB(v1 + 4);
        simd_and(v1 + 4);
        __native_PACKUSWB(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_add_byte(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_and(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_add_byte(v1 + 4);
        simd_shuffle_dword(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_add_dword(v1 + 4);
        simd_and(v1 + 4);
        simd_move_dword(v1 + 4);
        __native_PACKUSWB(v1 + 4);
        v1 += 16;
        __native_PACKUSWB(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_and(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_add_byte(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_shuffle_dword(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_add_dword(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_and(v1 + 4);
        __native_PACKUSWB(v1 + 4);
        __native_PACKUSWB(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_and(v1 + 4);
        simd_move_dword(v1 + 4);
        simd_add_byte(v1 + 4);
        v1 = 0;
        result = simd_move_dword(v1 + 4);
        if (v1 >= 40) {
            break;
        }
    } while (true);
    if (v2 >= 36) {
        *param_3->field_0x24 = (int8_t)0;
        return result;
    }
    do {
        param_2++;
        result++;
        param_1 ^= v3 + param_2 - 1;
        *param_2->field_0xffffffffffffffff = (int8_t)param_1;
        if (result >= 36) {
            break;
        }
    } while (true);
    return result;
}

