// Decompiled by HexCore Helix
// Engine version: 0.8.0-nightly

// -----------------------------------------------------------------------------
// sub_14142fe90 (0x14142fe90)
// Confidence: 71.0% (Medium)
// Issues:
//  - Unresolved call target
// -----------------------------------------------------------------------------
int64_t sub_14142fe90(int64_t param_1, int64_t param_2, int64_t param_3, int64_t param_4, int64_t param_5) {
    int64_t  var_8;
    int64_t  var_0;
    int64_t  var_10;
    int64_t  var_18;
    int64_t  rsi;
    int64_t  rdi;
    int64_t  rbp;
    int64_t  r12;
    int64_t  r13;
    int64_t  r14;
    int64_t  r15;
    int64_t  rax;
    int64_t  rbx;
    int64_t  _promoted_0;
    int64_t  _promoted_1;
    int64_t  _promoted_2;
    int64_t  _promoted_3;
    int64_t  spill_18;
    int64_t  var_40;
    int64_t  var_30;
    var_10 = rsi;
    var_18 = (int32_t)(param_3);
    rsi = param_5;
    rdi = 0;
    r13 = param_4;
    r12 = param_3;
    r15 = param_2;
    r14 = param_1;
    rax = rsi->field_0x100;
    if (rax != 0) {
        if (rax != 1) goto loc_14142ff2a;
    } else {
        *rsi = (int32_t)(rdi);  // 0x14142fecd
        rsi->field_0x100 = &rsi->field_0x100 + 1;  // 0x14142fed3
        rax = rsi->field_0x100;
    }
    var_8 = rdi;
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
loc_14142ff2a:
    rax = rax - 1;
    param_1 = r14;
    var_0 = 0x14142ff42;
    sub_141431890(r14, *rsi + param_1 * 4);  // 0x14142ff42
    if (rbx == -1) {
        param_5 = rdi;
        if (rbx != -1) goto loc_14143002c;
    } else {
        if (rax < 0) goto loc_14142ff8a;
    }
    goto loc_14142ffcc;
loc_14142ff8a:
    param_1 = rdi;
    var_8 = param_1;
loc_14142ff91:
    r12 = 0;
    if (param_1 == 0) {
        if (r12 == 0) goto loc_14142ffbf;
    }
    rax = *param_1;
    rax->vfunc_0x18();  // 0x14142ffab | [WARNING] Indirect call
    return rax;  // 0x14142ffab
loc_14142ffbf:
    r12 = (int64_t)(var_40);
loc_14142ffcc:
    param_1 = rbp + 0x50;
    var_0 = 0x14142ffd5;
    sub_1413a13c0(rbp + 0x50);  // 0x14142ffd5
    var_8 = rdi;
    if (param_5 == rdi) {
    loc_14142fffd:
        rax = rax - 1;
        sub_141431250(r14, *rsi + param_1 * 4);  // 0x141430027
        return rax;
    }
    param_1 = *0x142e01eb0;
    var_8 = param_1;
    if (param_1 != 0) {
        rax = *param_1;
        rax->vfunc_0x10(*0x142e01eb0);  // 0x14142fffd | [WARNING] Indirect call
        return rax;  // 0x14142fffd
    }
    goto loc_14142fffd;
loc_14143002c:
    if (rbx < 0) {
    loc_14143006c:
        param_4 = rdi;
        var_8 = rdi;
    } else {
        if (*rbx >= &r14->field_0x28) goto loc_14143006c;
    }
    goto loc_141430073;
loc_141430073:
    param_1 = rdi;
    if (*param_4 != 0x142e01eb0) {
    loc_1414300d2:
        rax = param_5;
        if (rax == 0) goto loc_1414300eb;
    } else {
        if (param_4 == 0) goto loc_1414300d2;
    }
    goto loc_1414300db;
loc_1414300b6:
    param_1 = *rbx;
    if (param_1 == 0) {
        param_4 = var_8;
    }
    rax = param_1->field_0x30;
    var_0 = 0x1414300c8;
    (*(param_1))++;  // 0x1414300c8
    0x1414300c8 = 0x1414300ca;
    (*(rax))++;  // 0x1414300ca
    param_1 = var_30;
loc_1414300db:
    param_1 = rax;
    var_0 = 0x1414300e3;
    sub_14142fde0(rax);  // 0x1414300e3
    param_1 = var_30;
    param_4 = var_8;
loc_1414300eb:
    param_5 = param_1;
    if (param_1 == 0) {
        if (param_4 == 0) goto loc_14143010f;
    } else {
        var_0 = 0x1414300f9;
        sub_14142fde0();  // 0x1414300f9
        param_4 = var_8;
    }
    rax = *param_4;
    rax->vfunc_0x18(param_4);  // 0x14143010f | [WARNING] Indirect call
    return rax;  // 0x14143010f
loc_14143010f:
    var_0 = 0x141430115;
    rsi->field_0x100--;  // 0x141430115
    param_1 = rbp - 0x28;
    var_8 = rdi;
    0x141430115 = 0x141430125;
    sub_140241c70(rbp - 0x28, r15);  // 0x141430125
    param_1 = param_5;
    param_4 = r13;
    param_3 = r12;
    var_0 = 0x14143013d;
    sub_14142fe90(param_5, r15, r12, r13);  // 0x14143013d | RECURSIVE
    param_1 = param_5;
    rbx = rax;
    if (param_1 == 0) {
        param_1 = r15->field_0x20;
        if (param_1 == 0) {
            rax = rbx;
            rbx = spill_18;
            return rax;  // 0x141430184
        }
        param_3->vfunc_0x18(r15->field_0x20, r15, *param_1, r13);  // 0x141430160 | [WARNING] Indirect call
        return rax;  // 0x141430160
    }
    sub_14142fde0(param_5, r15, r12, r13);  // 0x14143014d
    return rax;  // 0x14143014d
}

