// Decompiled by HexCore Helix
// Engine version: 0.8.0-nightly

// -----------------------------------------------------------------------------
// sub_14142fe90 (0x14142fe90)
// Confidence: 86.0% (High)
// Issues:
//  - Unresolved call target
// -----------------------------------------------------------------------------
int64_t sub_14142fe90(int64_t param_1, int64_t param_2, int64_t param_3, int64_t param_4, int64_t param_5) {
    int64_t  rsi;
    int64_t  rdi;
    int64_t  rbp;
    int64_t  r12;
    int64_t  r13;
    int64_t  r14;
    int64_t  r15;
    int64_t  rax;
    int64_t  rbx;
    int64_t  _promoted_25;
    int64_t  _promoted_26;
    int64_t  _promoted_27;
    int64_t  _promoted_33;
    int64_t  spill_18;
    int64_t  var_8;
    int64_t  var_40;
    int64_t  var_30;
    rsi = param_5;
    rdi = 0;
    r13 = param_4;
    r12 = param_3;
    r15 = param_2;
    r14 = param_1;
    rax = rsi->field_0x100;
    if (rax != 0) {
        if (rax != 1) goto loc_14142ff20;
    } else {
        *rsi = (int32_t)(rdi);  // 0x14142fecd
        rsi->field_0x100 = &rsi->field_0x100 + 1;  // 0x14142fed3
        rax = rsi->field_0x100;
    }
    sub_140241c70(rbp - 0x28);  // 0x14142feeb
    param_4 = r12;
    sub_141431250(r14, *rsi);  // 0x14142ff09
    param_1 = r15->field_0x20;
    rdi = 0;
    if (param_1 == 0) {
        return rax;
    }
    r15->field_0x20->vfunc_0x18(r15, *param_1, r12);  // 0x14142ff23
    return rax;
loc_14142ff20:
    rax = rax - 1;
    param_1 = r14;
    sub_141431890(r14, *rsi + param_1 * 4);  // 0x14142fef6
    if (rbx == -1) {
        param_5 = rdi;
        if (rbx != -1) goto loc_14142ffd6;
    } else {
        if (rax < 0) goto loc_14142ff3e;
    }
    goto loc_14142ff76;
loc_14142ff3e:
    param_1 = rdi;
loc_14142ff45:
    r12 = 0;
    if (param_1 == 0) {
        if (r12 == 0) goto loc_14142ff69;
    }
    rax = *param_1;
    rax->vfunc_0x18();  // 0x14142ff5f | [WARNING] Indirect call
    return rax;  // 0x14142ff5f
loc_14142ff69:
    r12 = (int64_t)(var_40);
loc_14142ff76:
    param_1 = rbp + 0x50;
    sub_1413a13c0(rbp + 0x50);  // 0x14142ff7f
    if (param_5 == rdi) {
    loc_14142ffa7:
        rax = rax - 1;
        sub_141431250(r14, *rsi + param_1 * 4);  // 0x14142ffd1
        return rax;
    }
    param_1 = *0x142e01e5a;
    if (param_1 != 0) {
        rax = *param_1;
        rax->vfunc_0x10(*0x142e01e5a);  // 0x14142ffa7 | [WARNING] Indirect call
        return rax;  // 0x14142ffa7
    }
    goto loc_14142ffa7;
loc_14142ffd6:
    if (rbx < 0) {
    loc_14142ffb6:
        param_4 = rdi;
    } else {
        if (*rbx >= &r14->field_0x28) goto loc_14142ffb6;
    }
    goto loc_14142ffbd;
loc_14142ffbd:
    param_1 = rdi;
    if (*param_4 != 0x142e01dfa) {
    loc_141430017:
        rax = param_5;
        if (rax == 0) goto loc_141430030;
    } else {
        if (param_4 == 0) goto loc_141430017;
    }
    goto loc_141430020;
loc_141430000:
    param_1 = *rbx;
    if (param_1 == 0) {
        param_4 = var_8;
    }
    rax = param_1->field_0x30;
    (*(param_1))++;  // 0x14143000d
    (*(rax))++;  // 0x14143000f
    param_1 = var_30;
loc_141430020:
    param_1 = rax;
    sub_14142fde0(rax);  // 0x141430028
    param_1 = var_30;
    param_4 = var_8;
loc_141430030:
    param_5 = param_1;
    if (param_1 == 0) {
        if (param_4 == 0) goto loc_141430054;
    } else {
        sub_14142fde0();  // 0x14143003e
        param_4 = var_8;
    }
    rax = *param_4;
    rax->vfunc_0x18(param_4);  // 0x141430054 | [WARNING] Indirect call
    return rax;  // 0x141430054
loc_141430054:
    rsi->field_0x100--;  // 0x14143005a
    param_1 = rbp - 0x28;
    sub_140241c70(rbp - 0x28, r15);  // 0x14143006a
    param_1 = param_5;
    param_4 = r13;
    param_3 = r12;
    sub_14142fe90(param_5, r15, r12, r13);  // 0x141430082 | RECURSIVE
    param_1 = param_5;
    rbx = rax;
    if (param_1 == 0) {
        param_1 = r15->field_0x20;
        if (param_1 == 0) {
            rax = rbx;
            rbx = spill_18;
            return rax;  // 0x1414300ba
        }
        param_3->vfunc_0x18(r15->field_0x20, r15, *param_1, r13);  // 0x1414300a0 | [WARNING] Indirect call
        return rax;  // 0x1414300a0
    }
    sub_14142fde0(param_5, r15, r12, r13);  // 0x141430092
    return rax;  // 0x141430092
}

