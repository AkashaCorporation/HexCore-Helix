// Decompiled by HexCore Helix
// Engine version: 0.2.0-mlir

// -----------------------------------------------------------------------------
// sub_14142fe90 (0x14142fe90)
// Confidence: 45.6% (Low)
// Issues:
//  - Unresolved call target
// -----------------------------------------------------------------------------
void sub_14142fe90(int64_t param_3, int64_t param_4, int64_t param_1) {
    int64_t  saved_rbp;
    int64_t  rsp;
    int64_t  rsi;
    int64_t  rdi;
    int64_t  rbp;
    int64_t  r12;
    int64_t  r13;
    int64_t  r14;
    int64_t  r15;
    int64_t  rax;
    int64_t  rbx;
    *((rsp + 0x10)) = rsi;
    *((rsp + 0x20)) = rdi;
    *((rsp + 0x18)) = (int64_t)(param_3);
    r13 = (int64_t)(param_4);
    r15 = param_2;
    r14 = param_1;
    cmp((int64_t)(rax), 0);
    saved_rbp = NULL;
    if ((int64_t)(rax) != 0) {
    loc_irr_102:
        cmp((int64_t)(rax), 1);
        saved_rbp = NULL;
        if ((int64_t)(rax) != 1) goto loc_irr_100;
    } else {
        *(rsi) = (int64_t)(rdi);
    }
    goto loc_irr_101;
block_5:
loc_irr_101:
    *((rbp - 8)) = rdi;
    sub_0x13ee11d85(); // [WARNING] Indirect call
    param_4 = (int64_t)(r12);
    *((rsp + 0x28)) = -1;
    param_1 = r14;
    *((rsp + 0x20)) = (int64_t)(r13);
    sub_0x140001347(r14, (int64_t)(*rsi), (int64_t)(r12)); // [WARNING] Indirect call
    param_1 = r15->field_0x20;
    cmp(param_1, 0);
    saved_rbp = NULL;
    if (param_1 == 0) {
        saved_rbp = NULL;
        goto loc_irr_103;
    }
    goto loc_irr_104;
block_6:
loc_irr_104:
    param_3 = *param_1;
    param_3->vfunc_0x18(r15, *param_1); // [WARNING] Indirect call
    saved_rbp = NULL;
    return;
block_8:
loc_irr_100:
    *((rsp + 0x90)) = rbx;
    param_1 = r14;
    sub_0x14000194e(r14, (int64_t)(*(rsi + (param_1 * 4)))); // [WARNING] Indirect call
    cmp((int64_t)(rbx), -1);
    saved_rbp = NULL;
    if ((int64_t)(rbx) == -1) {
    loc_irr_1:
        *((rbp + 0x50)) = rdi;
        cmp((int64_t)(rbx), -1);
        saved_rbp = NULL;
        if ((int64_t)(rbx) != -1) goto loc_irr_105;
    }
    goto loc_irr_107;
block_11:
loc_irr_107:
    cmp((int64_t)(rax), 0);
    if ((int64_t)(rax) < 0) {
    loc_irr_109:
        param_1 = rdi;
        *((rbp - 8)) = param_1;
        saved_rbp = NULL;
    } else {
        cmp((int64_t)(rbx), &r14->field_0x28);
        if ((int64_t)(rbx) >= &r14->field_0x28) goto loc_irr_109;
    }
    goto loc_irr_108;
block_13:
loc_irr_110:
    param_3 = &param_3->field_0x8;
    *((rbp - 8)) = param_1;
    param_3 = (param_3 + param_2);
    param_4 = param_3->field_0x20;
    cmp(param_4, 0);
    if (param_4 == 0) {
        *((rbp - 8)) = param_4;
        param_1 = param_4;
        rax->vfunc_0x8(param_4); // [WARNING] Indirect call
        param_1 = *(rbp - 8);
        saved_rbp = NULL;
        goto loc_irr_103;
    }
    goto loc_irr_108;
block_15:
loc_irr_108:
    cmp(param_1, 0);
    if (param_1 == 0) {
        cmp((int64_t)(r12), 0);
        saved_rbp = NULL;
        if ((int64_t)(r12) == 0) goto loc_irr_0;
    }
    goto loc_irr_112;
block_16:
loc_irr_112:
    rax->vfunc_0x18(); // [WARNING] Indirect call
    saved_rbp = NULL;
    return;
block_17:
loc_irr_111:
    param_1 = r14;
    sub_0x140001516(r14, (int64_t)(rbx)); // [WARNING] Indirect call
    saved_rbp = NULL;
    goto loc_irr_0;
block_18:
loc_irr_0:
    goto loc_irr_1;
block_20:
loc_irr_106:
    sub_0x13ff713eb(); // [WARNING] Indirect call
    *((rbp - 8)) = rdi;
    cmp((rbp + 0x50), rdi);
    saved_rbp = NULL;
    if ((rbp + 0x50) == rdi) {
    loc_irr_114:
        *((rsp + 0x28)) = -1;
        param_4 = (int64_t)(r12);
        *((rsp + 0x20)) = (int64_t)(r13);
        param_1 = r14;
        sub_0x140001229(r14, (int64_t)(*(rsi + (param_1 * 4))), (int64_t)(r12)); // [WARNING] Indirect call
        saved_rbp = NULL;
        goto loc_irr_103;
    }
    goto loc_irr_113;
block_22:
loc_irr_113:
    param_1 = *(*(int64_t)(__readgsqword(0x58)) + 0x19d1eca);
    *((rbp - 8)) = param_1;
    cmp(param_1, 0);
    if (param_1 == 0) {
        rax->vfunc_0x10(); // [WARNING] Indirect call
        saved_rbp = NULL;
        return;
    }
    goto loc_irr_114;
block_25:
loc_irr_105:
    cmp((int64_t)(rbx), 0);
    if ((int64_t)(rbx) < 0) {
    loc_irr_116:
        param_4 = rdi;
        *((rbp - 8)) = rdi;
        saved_rbp = NULL;
    } else {
        cmp((int64_t)(rbx), &r14->field_0x28);
        if ((int64_t)(rbx) >= &r14->field_0x28) goto loc_irr_116;
    }
    goto loc_irr_115;
block_27:
loc_irr_117:
    param_3 = &param_3->field_0x8;
    param_1 = (rax * 0x38);
    *((rbp - 8)) = rdi;
    param_3 = (param_3 + param_1);
    param_1 = param_3->field_0x20;
    cmp(param_1, 0);
    if (param_1 == 0) {
        *((rbp - 8)) = param_1;
        rax->vfunc_0x8(); // [WARNING] Indirect call
        param_4 = *(rbp - 8);
        saved_rbp = NULL;
        goto loc_irr_103;
    }
    goto loc_irr_115;
block_29:
loc_irr_115:
    cmp(param_4, (*(int64_t)(__readgsqword(0x58)) + 0x19d1e36));
    param_1 = rdi;
    *((rbp - 0x30)) = param_1;
    if (param_4 != (*(int64_t)(__readgsqword(0x58)) + 0x19d1e36)) {
    loc_irr_4:
        cmp(rax, 0);
        saved_rbp = NULL;
        if (rax == 0) goto loc_irr_5;
    }
    goto loc_irr_119;
block_31:
loc_irr_119:
    cmp(param_4, 0);
    if (param_4 == 0) {
        param_1 = param_4;
        rax->vfunc_0x38(param_4); // [WARNING] Indirect call
        param_1 = *rax;
        cmp(param_1, 0);
        saved_rbp = NULL;
        if (param_1 == 0) goto loc_irr_2;
    }
    goto loc_irr_4;
block_32:
loc_irr_120:
    param_1 = param_1->field_0x30;
    goto loc_irr_2;
block_34:
loc_irr_2:
    param_1 = *(rbp - 0x30);
    cmp(param_1, 0);
    if (param_1 == 0) {
        param_1 = *rbx;
        *((rbp - 0x30)) = param_1;
        cmp(param_1, 0);
        saved_rbp = NULL;
        if (param_1 == 0) goto loc_irr_3;
    }
    goto loc_irr_122;
block_35:
loc_irr_122:
    sub_0x13ffffd2a(); // [WARNING] Indirect call
    saved_rbp = NULL;
    return;
block_36:
loc_irr_121:
    param_1 = *(rbp - 0x30);
    goto loc_irr_3;
block_37:
loc_irr_3:
    param_4 = *(rbp - 8);
    goto loc_irr_4;
block_38:
loc_irr_118:
    param_1 = rax;
    sub_0x13ffffcfd(rax); // [WARNING] Indirect call
    param_1 = *(rbp - 0x30);
    param_4 = *(rbp - 8);
    saved_rbp = NULL;
    goto loc_irr_5;
block_41:
loc_irr_5:
    *((rbp + 0x50)) = param_1;
    cmp(param_1, 0);
    if (param_1 == 0) {
    loc_irr_125:
        cmp(param_4, 0);
        saved_rbp = NULL;
        if (param_4 == 0) goto loc_irr_123;
    } else {
        sub_0x13ffffce7(); // [WARNING] Indirect call
        param_4 = *(rbp - 8);
        saved_rbp = NULL;
    }
    goto loc_irr_124;
block_42:
loc_irr_124:
    param_1 = param_4;
    rax->vfunc_0x18(param_4); // [WARNING] Indirect call
    saved_rbp = NULL;
    return;
block_44:
loc_irr_123:
    *((rbp - 8)) = rdi;
    sub_0x13ee11b4b(r15); // [WARNING] Indirect call
    param_1 = *(rbp + 0x50);
    param_4 = (int64_t)(r13);
    *((rsp + 0x20)) = rsi;
    param_3 = (int64_t)(r12);
    sub_0x13ffffd53(*(rbp + 0x50), r15, (int64_t)(r12), (int64_t)(r13)); // [WARNING] Indirect call
    param_1 = *(rbp + 0x50);
    cmp(param_1, 0);
    saved_rbp = NULL;
    if (param_1 == 0) {
        param_1 = r15->field_0x20;
        cmp(param_1, 0);
        saved_rbp = NULL;
        if (param_1 == 0) goto loc_irr_126;
    }
    goto loc_irr_128;
block_45:
loc_irr_128:
    sub_0x13ffffc93(); // [WARNING] Indirect call
    saved_rbp = NULL;
    return;
block_46:
loc_irr_127:
    param_3 = *param_1;
    param_3->vfunc_0x18(r15, *param_1); // [WARNING] Indirect call
    saved_rbp = NULL;
    return;
block_47:
loc_irr_126:
block_48:
loc_irr_129:
    return;
block_49:
loc_irr_103:
    return;
}

