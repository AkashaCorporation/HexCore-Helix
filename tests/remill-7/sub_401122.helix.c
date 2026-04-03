// Decompiled by HexCore Helix
// Engine version: 0.8.0-nightly

// -----------------------------------------------------------------------------
// sub_401122 (0x401122)
// Confidence: 100.0% (High)
// -----------------------------------------------------------------------------
int64_t sub_401122(void) {
    int64_t  rbp;
    int64_t  rsp;
    int64_t  rax;
    int64_t  result;
    int64_t  var_0;
    DIVedxeax();  // 0x40116f
    rax = rax * 0x10;
    rax = rax << 4;
    rax = *rbp - 12;
    rsp = rsp & -0x10;
    result = *0x40b020;
    if (result == 0) {
    } else {
        *rsp = (int32_t)(rax);  // 0x4011b6
        rax = *0x40c16c;
        __indirect_call();  // 0x4011bd
        rsp = rsp - 4;
        result = rax->field_0x4;
        return result;
    }
    return result;
}

