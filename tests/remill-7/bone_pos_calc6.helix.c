// Decompiled by HexCore Helix
// Engine version: 0.8.0-nightly

// -----------------------------------------------------------------------------
// sub_14142fe90 (0x14142fe90)
// Confidence: 85.1% (High)
// -----------------------------------------------------------------------------
int64_t sub_14142fe90(int64_t param_1, int64_t param_2, int64_t param_3, int64_t param_4, int64_t param_5) {
    int64_t  var_30;
    int64_t  var_8;
    int64_t  var_40;
    int64_t  var_70;
    int64_t  rsi;
    int64_t  rdi;
    int64_t  rbp;
    int64_t  r12;
    int64_t  r13;
    int64_t  r14;
    int64_t  r15;
    int64_t  rax;
    int64_t  rbx;
    int64_t  result;
    int64_t  var_90;
    int64_t  var_68;
    int64_t  var_78;
    int64_t  var_60;
    int64_t  var_38;
    int64_t  var_48;
    int64_t  var_28;
    int64_t  var_50;
    int64_t  var_20;
    int64_t  var_58;
    rsi->field_0x100 = &rsi->field_0x100 + 1;  // 0x14142fed3
    sub_140241c70(rbp - 0x28);  // 0x14142feeb
    sub_141431250(r14, *rsi);  // 0x14142ff09
    param_1 = r15->field_0x20;
    rdi = 0;
    r15->field_0x20->vfunc_0x18(r15, *param_1, r12);  // 0x14142ff23
    sub_141431890(r14, *(rsi + param_1 * 4), *param_1, r12);  // 0x14142ff42
    param_1 = rdi;
    param_2 = rbx * 0x38;
    param_3 = param_3 + param_2;
    param_4 = param_3->field_0x20;
    param_4->vfunc_0x8(rbx * 0x38, param_3 + param_2, param_3->field_0x20);  // 0x14142ff84
    rdi->vfunc_0x18(rbx * 0x38, param_3 + param_2, param_3->field_0x20);  // 0x14142ffab
    sub_1414314d0(r14, rbx, param_3 + param_2, param_3->field_0x20);  // 0x14142ffba
    r12 = (int64_t)(var_40);
    param_5 = rdi;
    sub_1413a13c0(rbp + 0x50, rbx, param_3 + param_2, param_3->field_0x20);  // 0x14142ffd5
    param_1 = *0x142e01eb0;
    *0x142e01eb0->vfunc_0x10(rbx, param_3 + param_2, param_3->field_0x20);  // 0x14142fffd
    rax--;
    sub_141431250(r14, *(rsi + param_1 * 4), param_3 + param_2, r12);  // 0x141430027
    param_1 = rax * 0x38;
    param_3 = param_3 + param_1;
    param_1 = param_3->field_0x20;
    var_8 = param_1;
    param_3->field_0x20->vfunc_0x8(*(rsi + param_1 * 4), param_3 + param_1, rdi);  // 0x141430066
    param_4 = rdi;
    param_1 = rdi;
    rax = *param_4;
    param_4->vfunc_0x38(*(rsi + param_1 * 4), param_3 + param_1, rdi);  // 0x141430095
    rbx = rax;
    param_1 = *rax;
    param_1 = param_1->field_0x30;
    sub_14142fde0(var_30, *(rsi + param_1 * 4), param_3 + param_1, rdi);  // 0x1414300b6
    param_1 = *rbx;
    var_30 = param_1;
    rax = param_1->field_0x30;
    *param_1 = &param_1->field_0x1;  // 0x1414300c8
    *rax = &rax->field_0x1;  // 0x1414300ca
    rax = param_5;
    sub_14142fde0(rax, *(rsi + param_1 * 4), param_3 + param_1, var_8);  // 0x1414300e3
    param_1 = param_1;
    param_5 = param_1;
    sub_14142fde0(var_30, *(rsi + param_1 * 4), param_3 + param_1, var_8);  // 0x1414300f9
    param_4 = var_8;
    rax = *param_4;
    param_4->vfunc_0x18(*(rsi + param_1 * 4), param_3 + param_1, var_8);  // 0x14143010f
    rsi->field_0x100 = &rsi->field_0x100 - 1;  // 0x141430115
    var_8 = rdi;
    sub_140241c70(rbp - 0x28, r15, param_3 + param_1, rdi);  // 0x141430125
    sub_14142fe90(param_5, r15, r12, r13);  // 0x14143013d
    rbx = rax;
    sub_14142fde0(param_5, r15, r12, r13);  // 0x14143014d
    param_1 = r15->field_0x20;
    param_3 = *param_1;
    param_2 = r15;
    r15->field_0x20->vfunc_0x18(r15, *param_1, r13);  // 0x141430160
    rdi = param_3;
    rbx = param_1;
    rax--;
    sub_141431890(r15->field_0x20, *(param_3 + param_2 * 4), *param_1, r13);  // 0x1414301c4
    sub_1414314d0(rbx, rax, *param_1, r13);  // 0x1414301e0
    rax = 1;
    rbx = var_68;
    rbp = var_78;
    rbx = 0;
    param_1 = rax * 0x38;
    param_3 = param_3 + param_1;
    param_1 = param_3->field_0x20;
    var_40 = param_1;
    param_3->field_0x20->vfunc_0x8(rax, param_3 + param_1, rbx);  // 0x141430232
    param_4 = rbx;
    param_1 = rbx;
    rax = *param_4;
    param_4->vfunc_0x38(rax, param_3 + param_1, rbx);  // 0x141430270
    rsi = rax;
    param_1 = *rax;
    param_1 = param_1->field_0x30;
    *param_1 = &param_1->field_0x1;  // 0x141430283
    sub_14142fde0(var_70, rax, param_3 + param_1, rbx);  // 0x141430292
    param_1 = *rsi;
    param_4 = var_40;
    var_70 = param_1;
    rax = *param_4;
    param_4->vfunc_0x18(rax, param_3 + param_1, var_40);  // 0x1414302b7
    rdi->field_0x100 = &rdi->field_0x100 - 1;  // 0x1414302c7
    sub_141430190(param_1, rbp, rdi, var_40);  // 0x1414302d1
    param_1 = param_1;
    rbx = rax;
    sub_14142fde0(var_70, rbp, rdi, var_40);  // 0x1414302e2
    rsi = 0;
    rdi = param_1;
    sub_141315b60(param_1->field_0x10, param_1->field_0x18, rdi, var_40);  // 0x141430339
    rdi->field_0x10 = rsi;  // 0x14143033d
    rdi->field_0x1c = (int32_t)(rsi);  // 0x141430340
    sub_141392de0(&param_1->field_0x10, param_1->field_0x18, 0x8000008, var_40);  // 0x141430356
    param_2 = rdi->field_0x28;
    sub_141315b60(rdi->field_0x20, rdi->field_0x28, 0x8000008, var_40);  // 0x14143036b
    rdi->field_0x20 = rsi;  // 0x14143036f
    rdi->field_0x2c = (int32_t)(rsi);  // 0x141430372
    param_1 = &rdi->field_0x20;
    sub_141392de0(&rdi->field_0x20, rdi->field_0x28, 0x8000038, var_40);  // 0x141430396
    rax = param_1->field_0x8;
    rax = rax->field_0x30;
    rbx = param_1;
    rbp = param_1->field_0x30;
    var_40 = rdi;
    r14 = 0;
    param_1->field_0x8 = param_2;  // 0x141430412
    param_2 = 0;
    sub_1413153e0(&param_2->field_0x18, 0, 0, 0);  // 0x14143042d
    rax->field_0x8 = rbx;  // 0x14143043d
    param_1 = param_1 | 1;
    *rax = (int32_t)(r14);  // 0x141430443
    rax->field_0x10 = (int8_t)(param_1);  // 0x141430446
    rax = r14;
    rbx->field_0x30 = rax;  // 0x14143044f
    rsi = r14;
    param_2 = param_2 + rsi;
    param_1 = param_2->field_0x20;
    rax = *param_1;
    param_2->field_0x20->vfunc_0x30(param_2 + rsi, 0, 0);  // 0x141430488
    param_1->field_0x30 = r14;  // 0x14143049d
    param_1->field_0x8 = r14;  // 0x1414304a1
    sub_1414303d0(*rax, rbx, 0, 0);  // 0x1414304a6
    r14 = var_48;
    param_2 = 0x18;
    param_1 = rbp;
    sub_141313d60(rbp, 0x18, 0, 0);  // 0x1414304d8
    rax = rbx->field_0x30;
    rax->field_0x10 = &rax->field_0x10 | 1;  // 0x1414304e5
    rax = *param_2;
    rdi = param_2;
    rbx = param_1;
    rax = rax->field_0x30;
    sub_141430600(rbp, 0x18, 0, 0);  // 0x14143054b
    sub_141392de0(&rbx->field_0x10, 0x18, 0x8000008, 0);  // 0x141430565
    rax = *rdi;
    rax = rax->field_0x30;
    *rax = &rax->field_0x1;  // 0x141430588
    rax = *rdi;
    *param_2 = rax;  // 0x14143058e
    rbx->field_0x18 = &rbx->field_0x18 + 1;  // 0x141430591
    param_2 = rdi;
    sub_141392f00(&rbx->field_0x10, rdi, 0x8000008, 0);  // 0x1414305a5
    param_1 = *rax;
    param_1 = param_1->field_0x30;
    param_1 = *rax;
    *(param_3 - 8) = param_1;  // 0x1414305c8
    rax = rbx->field_0x30;
    param_1 = *rdi;
    sub_14142fde0(*rdi, rdi, 0x8000008, 0);  // 0x1414305e9
    r13 = 0;
    rsi = param_1;
    r15 = param_2;
    param_4++;
    rax = rsi->field_0x30;
    r12 = rdi;
    rax = rsi->field_0x10;
    rbx = *(rax + rdi * 8);
    param_1 = rbx->field_0x30;
    param_1->field_0x10 = &param_1->field_0x10 & 0xfe;  // 0x1414306a3
    *param_1 = (int32_t)(r13);  // 0x1414306aa
    sub_14142f890(rbx->field_0x30, param_1->field_0x8, &param_3->field_0x1, &param_4->field_0x1);  // 0x1414306b5
    *rbx = rbx - 1;  // 0x1414306b7
    rax = rbx->field_0x30;
    *rax = rax - 1;  // 0x1414306bd
    rbx = rbx->field_0x30;
    rbx->field_0x10 = &rbx->field_0x10 | 2;  // 0x1414306d1
    sub_14142f960(rbx, rbx->field_0x8, &param_3->field_0x1, &param_4->field_0x1);  // 0x1414306d6
    sub_14143c8a0(*0x142defed0, rbx->field_0x8, &param_3->field_0x1, &param_4->field_0x1);  // 0x1414306e6
    param_2 = 0x18;
    sub_141313d60(rbx, 0x18, &param_3->field_0x1, &param_4->field_0x1);  // 0x1414306f3
    rax = rsi->field_0x18;
    rdi = var_60;
    r14 = var_28;
    rax = rsi->field_0x10;
    param_3 = param_3 << 3;
    sub_141f7e3e9(rax + r12 * 8, 0x18, param_3 << 3, &param_4->field_0x1);  // 0x141430729
    rax = rsi->field_0x18;
    r12 = var_30;
    result = rax - 1;
    rbp = var_50;
    rsi->field_0x18 = (int32_t)(result);  // 0x14143073b
    rbx = *r15;
    r15 = var_20;
    rsi = var_58;
    param_1 = rbx->field_0x30;
    return result;
}

