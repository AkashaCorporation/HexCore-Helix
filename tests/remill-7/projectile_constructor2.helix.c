// Decompiled by HexCore Helix
// Engine version: 0.2.0-mlir

// -----------------------------------------------------------------------------
// sub_1419b3460 (0x1419b3460)
// Confidence: 100.0% (High)
// -----------------------------------------------------------------------------
int64_t sub_1419b3460(int64_t param_1, int64_t param_2, int64_t param_3, int64_t param_4) {
    int64_t  rax;
    rax = (int64_t)(*(rsp + 0x30));
    param_1->field_0x14 = (int64_t)(rax);
    rax = *(rsp + 0x38);
    param_1->field_0x18 = rax;
    rax = (int64_t)(*(rsp + 0x40));
    param_1->field_0x20 = (int64_t)(rax);
    rax = *(rsp + 0x48);
    param_1->field_0x28 = rax;
    rax = (int64_t)(*(rsp + 0x50));
    param_1->field_0x30 = (int64_t)(rax);
    rax = *(rsp + 0x58);
    param_1->field_0x38 = rax;
    rax = *(rsp + 0x60);
    param_1->field_0x40 = rax;
    rax = (int64_t)(*(rsp + 0x68));
    *(param_1) = param_2;
    param_1->field_0x8 = param_3;
    param_1->field_0x10 = (int64_t)(param_4);
    param_1->field_0x48 = (int64_t)(rax);
    rax = (int64_t)(*(rsp + 0x70));
    param_1->field_0x4c = (int64_t)(rax);
    return;
}

