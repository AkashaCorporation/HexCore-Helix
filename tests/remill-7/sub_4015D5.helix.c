// Decompiled by HexCore Helix
// Engine version: 0.8.0-nightly

// -----------------------------------------------------------------------------
// sub_4015d5 (0x4015d5)
// Confidence: 100.0% (High)
// -----------------------------------------------------------------------------
void sub_4015d5(void) {
    int64_t  rbp;
    int64_t  rsp;
    int64_t  rax;
    int64_t  var_0;
    *rsp + 4 = 0x40a000;  // 0x4015ef
    *rsp = (int32_t)(rax);  // 0x4015f2
    rax = *0x40c168;
    __indirect_call();  // 0x4015f9
    rsp = rsp - 8;
    *rbp - 12 = (int32_t)(rax);  // 0x4015ff
    if (*rbp - 12 == 0) {
        LEAVE_FULL();  // 0x401606
        return;
    }
    rax = *rbp - 12;
    __indirect_call();  // 0x401611
    return;
}

