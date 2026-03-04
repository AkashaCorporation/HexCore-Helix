// Decompiled by HexCore Helix
// Engine version: 0.2.0-mlir

// -----------------------------------------------------------------------------
// sub_14142fe90 (0x14142fe90)
// Confidence: 0.0% (Low)
// Issues:
//  - Unresolved call target
// -----------------------------------------------------------------------------
void sub_14142fe90(int64_t param_3, int64_t param_1) {
    int64_t  rbp;
    int64_t  rax;
    int64_t  rbx;
    rax = &rsi->field_0x100;
    sub_0x13ee11d85(); // [WARNING] Indirect call
    param_1 = r14;
    sub_0x140001347(r14); // [WARNING] Indirect call
    param_1 = &r15->field_0x20;
    param_3 = param_1;
    sub_&param_3->field_0x18(&r15->field_0x20, /* ? */, param_1); // [WARNING] Indirect call
    rax = (rax - 1);
    param_1 = r14;
    sub_0x14000194e(r14); // [WARNING] Indirect call
    param_3 = (param_3 + param_2);
    rax = param_4;
    param_1 = param_4;
    sub_&rax->field_0x8(param_4, /* ? */, (param_3 + param_2)); // [WARNING] Indirect call
    param_1 = rdi;
    rax = param_1;
    sub_&rax->field_0x18(rdi); // [WARNING] Indirect call
    param_1 = r14;
    sub_0x140001516(r14); // [WARNING] Indirect call
    rbx = 0xffffffff;
    sub_0x13ff713eb(); // [WARNING] Indirect call
    param_1 = (*(int64_t)(__readgsqword(0x58)) + 0x19d1eca);
    rax = param_1;
    sub_&rax->field_0x10((*(int64_t)(__readgsqword(0x58)) + 0x19d1eca)); // [WARNING] Indirect call
    rax = (rax - 1);
    param_1 = r14;
    sub_0x140001229(r14); // [WARNING] Indirect call
    param_1 = (rax * 0x38);
    param_3 = (param_3 + param_1);
    param_1 = &param_3->field_0x20;
    rax = param_1;
    sub_&rax->field_0x8(&param_3->field_0x20); // [WARNING] Indirect call
    rax = param_4;
    param_1 = param_4;
    sub_&rax->field_0x38(param_4); // [WARNING] Indirect call
    rbx = rax;
    param_1 = (rbp - 0x30);
    sub_0x13ffffd2a((rbp - 0x30)); // [WARNING] Indirect call
    param_1 = rbx;
    rax = (rbp + 0x50);
    param_1 = rax;
    sub_0x13ffffcfd(rax); // [WARNING] Indirect call
    param_1 = (rbp - 0x30);
    sub_0x13ffffce7((rbp - 0x30)); // [WARNING] Indirect call
    rax = param_4;
    param_1 = param_4;
    sub_&rax->field_0x18(param_4); // [WARNING] Indirect call
    sub_0x13ee11b4b(); // [WARNING] Indirect call
    param_1 = (rbp + 0x50);
    param_3 = (int64_t)(r12);
    sub_0x13ffffd53((rbp + 0x50), /* ? */, (int64_t)(r12)); // [WARNING] Indirect call
    param_1 = (rbp + 0x50);
    rbx = (int64_t)(rax);
    sub_0x13ffffc93((rbp + 0x50)); // [WARNING] Indirect call
    param_1 = &r15->field_0x20;
    param_3 = param_1;
    sub_&param_3->field_0x18(&r15->field_0x20, /* ? */, param_1); // [WARNING] Indirect call
    rbp = (int64_t)(param_2);
    rbx = param_1;
    rax = (rax - 1);
    sub_0x1400016cc(); // [WARNING] Indirect call
    param_1 = rbx;
    sub_0x1400012f0(rbx); // [WARNING] Indirect call
    rax = 1;
    rbx = (rsp + 0x68);
    rbp = (rsp + 0x78);
    rbx = 0;
    param_1 = (rax * 0x38);
    param_3 = (param_3 + param_1);
    param_1 = &param_3->field_0x20;
    rax = param_1;
    sub_&rax->field_0x8(&param_3->field_0x20); // [WARNING] Indirect call
    rbx = 0;
    rax = param_4;
    param_1 = param_4;
    sub_&rax->field_0x38(param_4); // [WARNING] Indirect call
    param_1 = (rsp + 0x70);
    sub_0x13ffffb4e((rsp + 0x70)); // [WARNING] Indirect call
    rax = param_4;
    param_1 = param_4;
    sub_&rax->field_0x18(param_4); // [WARNING] Indirect call
    param_1 = (rsp + 0x70);
    param_3 = rdi;
    sub_0x13ffffebf((rsp + 0x70), /* ? */, rdi); // [WARNING] Indirect call
    param_1 = (rsp + 0x70);
    rbx = (int64_t)(rax);
    sub_0x13ffffafe((rsp + 0x70)); // [WARNING] Indirect call
    rbx = (rsp + 0x68);
    rax = 0;
    rbp = (rsp + 0x78);
    param_1 = &param_1->field_0x10;
    sub_0x13fee5827(&param_1->field_0x10); // [WARNING] Indirect call
    param_3 = 0x8000008;
    param_1 = &param_1->field_0x10;
    sub_0x13ff62a8a(&param_1->field_0x10, /* ? */, 0x8000008); // [WARNING] Indirect call
    param_1 = &rdi->field_0x20;
    sub_0x13fee57f5(&rdi->field_0x20); // [WARNING] Indirect call
    rbx = (rsp + 0x30);
    param_3 = 0x8000038;
    sub_0x13ff62a4a(/* ? */, /* ? */, 0x8000038); // [WARNING] Indirect call
    rbx = param_1;
    rbp = &param_1->field_0x30;
    rax = &param_2->field_0x30;
    param_3 = 0;
    sub_0x13fee4fb3(/* ? */, /* ? */, 0); // [WARNING] Indirect call
    param_1 = &param_2->field_0x20;
    rax = param_1;
    sub_&rax->field_0x30(&param_2->field_0x20); // [WARNING] Indirect call
    param_1 = rax;
    sub_0x13fffff2a(rax); // [WARNING] Indirect call
    param_1 = rbp;
    sub_0x13fee3888(rbp); // [WARNING] Indirect call
    rax = &rbx->field_0x30;
    rbp = (rsp + 0x30);
    rax->field_0x10 = (&rax->field_0x10 | 1);
    *((rbp + 0x10)) = ((rbp + 0x10) | 1);
    rax->field_0x10 = (&rax->field_0x10 | 1);
    rbx = param_1;
    rax = param_2;
    sub_0x1400000b5(); // [WARNING] Indirect call
    rax = &rbx->field_0x18;
    param_3 = 0x8000008;
    sub_0x13ff6287b(/* ? */, /* ? */, 0x8000008); // [WARNING] Indirect call
    rax = rdi;
    param_3 = 0x8000008;
    sub_0x13ff6295b(/* ? */, /* ? */, 0x8000008); // [WARNING] Indirect call
    rax = &rbx->field_0x30;
    param_1 = rdi;
    sub_0x13ffff7f7(rdi); // [WARNING] Indirect call
    rax = &rsi->field_0x10;
    rbx = (rax + (rdi * 8));
    param_1 = &rbx->field_0x30;
    param_1->field_0x10 = (&param_1->field_0x10 & 0xfe);
    sub_0x13ffff1db(&rbx->field_0x30); // [WARNING] Indirect call
    rax = &rbx->field_0x30;
    rbx = &rbx->field_0x30;
    param_1 = rbx;
    rbx->field_0x10 = (&rbx->field_0x10 | 2);
    sub_0x13ffff28a(rbx); // [WARNING] Indirect call
    param_1 = (*(int64_t)(__readgsqword(0x58)) + 0x19bf7ef);
    sub_0x14000c1ba((*(int64_t)(__readgsqword(0x58)) + 0x19bf7ef)); // [WARNING] Indirect call
    param_1 = rbx;
    sub_0x13fee366d(rbx); // [WARNING] Indirect call
    rax = &rsi->field_0x18;
    param_1 = (param_1 - (int64_t)(r14));
    rax = &rsi->field_0x10;
    param_3 = (param_3 << 3);
    sub_0x140b4dcc0((param_1 - (int64_t)(r14)), /* ? */, (param_3 << 3)); // [WARNING] Indirect call
    rax = (rax - 1);
    rbp = (rsp + 0x50);
    rbx = r15;
    param_1 = &rbx->field_0x30;
    param_1->field_0x10 = (&param_1->field_0x10 & 0xfe);
    sub_0x13ffff11d(&rbx->field_0x30); // [WARNING] Indirect call
    rax = &rbx->field_0x30;
    rbx = &rbx->field_0x30;
    param_1 = rbx;
    rbx->field_0x10 = (&rbx->field_0x10 | 2);
    sub_0x13ffff1cc(rbx); // [WARNING] Indirect call
    param_1 = (*(int64_t)(__readgsqword(0x58)) + 0x19bf731);
    sub_0x14000c0fc((*(int64_t)(__readgsqword(0x58)) + 0x19bf731)); // [WARNING] Indirect call
    param_1 = rbx;
    sub_0x13fee35af(rbx); // [WARNING] Indirect call
    rax = param_2;
    param_3 = rax;
    rbx = 0;
    param_1 = 0;
    rax = param_1;
    sub_&rax->field_0x38(0); // [WARNING] Indirect call
    param_1 = (rbp + 0x7f);
    sub_0x13ffff52f((rbp + 0x7f)); // [WARNING] Indirect call
    param_1 = (rbp - 9);
    rax = param_1;
    sub_&rax->field_0x8((rbp - 9)); // [WARNING] Indirect call
    param_1 = r14;
    sub_0x14000094f(r14); // [WARNING] Indirect call
    rax = &param_3->field_0x20;
    rbx = 0;
    param_3 = (param_3 + rax);
    rax = param_4;
    param_1 = param_4;
    sub_&rax->field_0x8(param_4); // [WARNING] Indirect call
    param_1 = (*(int64_t)(__readgsqword(0x58)) + 0x19bf550);
    param_3 = 8;
    sub_0x13ff64eb1((*(int64_t)(__readgsqword(0x58)) + 0x19bf550), /* ? */, 8); // [WARNING] Indirect call
    param_1 = rax;
    sub_0x13ffff0e6(rax); // [WARNING] Indirect call
    param_1 = (*(int64_t)(__readgsqword(0x58)) + 0x19d14fe);
    rax = param_1;
    sub_&rax->field_0x10((*(int64_t)(__readgsqword(0x58)) + 0x19d14fe)); // [WARNING] Indirect call
    param_1 = r14;
    sub_0x140000866(r14); // [WARNING] Indirect call
    param_1 = r14;
    sub_0x140000e93(r14); // [WARNING] Indirect call
    rax = 0;
    param_1 = (rax * 0x38);
    param_3 = (param_3 + param_1);
    rax = param_4;
    param_1 = param_4;
    sub_&rax->field_0x8(param_4); // [WARNING] Indirect call
    param_1 = 0;
    rax = param_1;
    sub_&rax->field_0x38(0); // [WARNING] Indirect call
    rbx = rax;
    param_1 = (rbp - 0x39);
    sub_0x13ffff342((rbp - 0x39)); // [WARNING] Indirect call
    param_1 = (rbp + 0x1f);
    rax = param_1;
    sub_&rax->field_0x18((rbp + 0x1f)); // [WARNING] Indirect call
    param_3 = (int64_t)(r13);
    sub_0x13ff719a8(/* ? */, /* ? */, (int64_t)(r13)); // [WARNING] Indirect call
    param_1 = (rbp - 0x39);
    sub_0x13ffff30a((rbp - 0x39)); // [WARNING] Indirect call
    param_1 = (rbp + 0x7f);
    sub_0x13ffff2fc((rbp + 0x7f)); // [WARNING] Indirect call
    param_1 = (rbp - 9);
    rax = param_1;
    sub_&rax->field_0x18((rbp - 9)); // [WARNING] Indirect call
    rbx = (rsp + 0xd0);
    param_3 = &r12->field_0xc;
    rax = 8;
    param_3 = 0x8000008;
    param_1 = r12;
    sub_0x13ff62173(r12, /* ? */, 0x8000008); // [WARNING] Indirect call
    rbx = 0;
    rax = (int64_t)(rbx);
    param_1 = r15;
    sub_0x140b4d6fd(r15); // [WARNING] Indirect call
    rbp = (rbp - 1);
    param_1 = rsi;
    return;
}

