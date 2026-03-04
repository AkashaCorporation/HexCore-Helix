// Decompiled by HexCore Helix
// Engine version: 0.2.0-mlir

// -----------------------------------------------------------------------------
// sub_14142fe90 (0x14142fe90)
// Confidence: 60.0% (Medium)
// Issues:
//  - Unresolved call target
// -----------------------------------------------------------------------------
void sub_14142fe90(int64_t param_3, int64_t param_4, int64_t param_1) {
    int64_t  rsi;
    int64_t  rbp;
    int64_t  r12;
    int64_t  r13;
    int64_t  r14;
    int64_t  r15;
    int64_t  rax;
    int64_t  rbx;
    r13 = (int64_t)(param_4);
    r15 = param_2;
    r14 = param_1;
    cmp((int64_t)(rax), 0);
    if ((int64_t)(rax) != 0) {
        cmp((int64_t)(rax), 1);
        if ((int64_t)(rax) != 1) goto block_8;
    } else {
    }
    goto block_5;
block_5:
    sub_0x13ee11d85(); // [WARNING] Indirect call
    param_4 = (int64_t)(r12);
    param_1 = r14;
    sub_0x140001347(r14, rsi, (int64_t)(r12)); // [WARNING] Indirect call
    param_1 = &r15->field_0x20;
    cmp(param_1, 0);
    if (param_1 == 0) {
        goto block_49;
    }
    goto block_6;
block_6:
    param_3 = param_1;
    param_3->vfunc_0x18(r15, param_1); // [WARNING] Indirect call
    return;
block_8:
    param_1 = r14;
    sub_0x14000194e(r14, (rsi + (param_1 * 4))); // [WARNING] Indirect call
    cmp((int64_t)(rbx), -1);
    if ((int64_t)(rbx) == -1) {
        cmp((int64_t)(rbx), -1);
        if ((int64_t)(rbx) != -1) goto block_25;
    }
    goto block_11;
block_11:
    cmp((int64_t)(rax), 0);
    if ((int64_t)(rax) < 0) {
        param_1 = rdi;
    } else {
        cmp((int64_t)(rbx), &r14->field_0x28);
        if ((int64_t)(rbx) >= &r14->field_0x28) goto block_9;
    }
    goto block_15;
block_13:
    param_3 = (param_3 + param_2);
    param_4 = &param_3->field_0x20;
    cmp(param_4, 0);
    if (param_4 == 0) {
        param_1 = param_4;
        rax->vfunc_0x8(param_4); // [WARNING] Indirect call
        param_1 = (rbp - 8);
        goto block_49;
    }
    goto block_15;
block_15:
    cmp(param_1, 0);
    if (param_1 == 0) {
        cmp((int64_t)(r12), 0);
        if ((int64_t)(r12) == 0) goto block_18;
    }
    goto block_16;
block_16:
    rax->vfunc_0x18(); // [WARNING] Indirect call
    return;
block_17:
    param_1 = r14;
    sub_0x140001516(r14, (int64_t)(rbx)); // [WARNING] Indirect call
    goto loc_irr_0;
block_18:
loc_irr_0:
block_20:
    sub_0x13ff713eb(); // [WARNING] Indirect call
    cmp((rbp + 0x50), rdi);
    if ((rbp + 0x50) == rdi) {
        param_4 = (int64_t)(r12);
        param_1 = r14;
        sub_0x140001229(r14, (rsi + (param_1 * 4)), (int64_t)(r12)); // [WARNING] Indirect call
        goto block_49;
    }
    goto block_22;
block_22:
    param_1 = (*(int64_t)(__readgsqword(0x58)) + 0x19d1eca);
    cmp(param_1, 0);
    if (param_1 == 0) {
        rax->vfunc_0x10(); // [WARNING] Indirect call
        return;
    }
    goto block_19;
block_25:
    cmp((int64_t)(rbx), 0);
    if ((int64_t)(rbx) < 0) {
        param_4 = rdi;
    } else {
        cmp((int64_t)(rbx), &r14->field_0x28);
        if ((int64_t)(rbx) >= &r14->field_0x28) goto block_23;
    }
    goto block_29;
block_27:
    param_1 = (rax * 0x38);
    param_3 = (param_3 + param_1);
    param_1 = &param_3->field_0x20;
    cmp(param_1, 0);
    if (param_1 == 0) {
        rax->vfunc_0x8(); // [WARNING] Indirect call
        param_4 = (rbp - 8);
        goto block_49;
    }
    goto block_29;
block_29:
    cmp(param_4, (*(int64_t)(__readgsqword(0x58)) + 0x19d1e36));
    param_1 = rdi;
    if (param_4 != (*(int64_t)(__readgsqword(0x58)) + 0x19d1e36)) {
        cmp(rax, 0);
        if (rax == 0) goto block_41;
    }
    goto block_31;
block_31:
    cmp(param_4, 0);
    if (param_4 == 0) {
        param_1 = param_4;
        rax->vfunc_0x38(param_4); // [WARNING] Indirect call
        param_1 = rax;
        cmp(param_1, 0);
        if (param_1 == 0) goto block_34;
    }
    goto block_28;
block_32:
    param_1 = &param_1->field_0x30;
block_34:
    param_1 = (rbp - 0x30);
    cmp(param_1, 0);
    if (param_1 == 0) {
        param_1 = rbx;
        cmp(param_1, 0);
        if (param_1 == 0) goto block_37;
    }
    goto block_35;
block_35:
    sub_0x13ffffd2a(); // [WARNING] Indirect call
    return;
block_36:
    param_1 = (rbp - 0x30);
    goto loc_irr_1;
block_37:
loc_irr_1:
    param_4 = (rbp - 8);
block_38:
    param_1 = rax;
    sub_0x13ffffcfd(rax); // [WARNING] Indirect call
    param_1 = (rbp - 0x30);
    param_4 = (rbp - 8);
block_41:
    cmp(param_1, 0);
    if (param_1 == 0) {
        cmp(param_4, 0);
        if (param_4 == 0) goto block_44;
    } else {
        sub_0x13ffffce7(); // [WARNING] Indirect call
        param_4 = (rbp - 8);
    }
    goto block_42;
block_42:
    param_1 = param_4;
    rax->vfunc_0x18(param_4); // [WARNING] Indirect call
    return;
block_44:
    sub_0x13ee11b4b(r15); // [WARNING] Indirect call
    param_1 = (rbp + 0x50);
    param_4 = (int64_t)(r13);
    param_3 = (int64_t)(r12);
    sub_0x13ffffd53((rbp + 0x50), r15, (int64_t)(r12), (int64_t)(r13)); // [WARNING] Indirect call
    param_1 = (rbp + 0x50);
    cmp(param_1, 0);
    if (param_1 == 0) {
        param_1 = &r15->field_0x20;
        cmp(param_1, 0);
        if (param_1 == 0) goto block_47;
    }
    goto block_45;
block_45:
    sub_0x13ffffc93(); // [WARNING] Indirect call
    return;
block_46:
    param_3 = param_1;
    param_3->vfunc_0x18(r15, param_1); // [WARNING] Indirect call
    return;
block_47:
block_48:
    return;
block_49:
    return;
}

