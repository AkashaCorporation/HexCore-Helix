// Decompiled by HexCore Helix
// Engine version: 0.8.0-nightly

// -----------------------------------------------------------------------------
// sub_401a34 (0x401a34)
// Confidence: 86.0% (High)
// Issues:
//  - 2 native opcode call(s) not decomposed
//  - Unresolved call target
// -----------------------------------------------------------------------------
int64_t sub_401a34(int64_t param_2) {
    int64_t  rbp;
    int64_t  rsp;
    int64_t  rax;
    int64_t  result;
    int64_t  var_0;
    rsp = rsp - 0x28;
    rax = *rax;
    result = *rax;
    if (!(result < -0x3fffff6f) & !(result == -0x3fffff6f)) {
        if (rax == -0x3fffff6c) goto loc_401aea;
    } else {
        if (rax >= -0x3fffff73) goto loc_401ae3;
    }
    return result;
loc_401aa5:
    if (*rbp - 0x14 == 0) {
        return result;
    }
    (*(rsp)) = 11;  // 0x401a96
    rax = *rbp - 0x14;
    sub_rax();  // 0x401a9b | [WARNING] Indirect call
    (*(rbp - 12)) = -1;  // 0x401aa2
    return result;
loc_401aa7:
    (*(rsp + 4)) = 0;  // 0x401aaf
    (*(rsp)) = 4;  // 0x401ab6
    (*(rbp - 0x14)) = (int32_t)(rax);  // 0x401abe
    if (*rbp - 0x14 != 1) {
        if (*rbp - 0x14 == 0) goto loc_401b27;
    }
    (*(rsp + 4)) = 1;  // 0x401acc
    (*(rsp)) = 4;  // 0x401ad3
    (*(rbp - 12)) = -1;  // 0x401adf
    return result;
loc_401ae3:
    (*(rbp - 0x10)) = 1;  // 0x401aea
loc_401aea:
    (*(rsp + 4)) = 0;  // 0x401af2
    (*(rsp)) = 8;  // 0x401af9
    (*(rbp - 0x14)) = (int32_t)(rax);  // 0x401b01
    if (*rbp - 0x14 != 1) {
        if (*rbp - 0x14 == 0) goto loc_401b2a;
    }
    (*(rsp + 4)) = 1;  // 0x401b0f
    (*(rsp)) = 8;  // 0x401b16
    if (*rbp - 0x10 == 0) {
        (*(rbp - 12)) = -1;  // 0x401b28
        return result;
    }
    return result;  // 0x401b26
loc_401b27:
    return result;
loc_401b2a:
    if (*rbp - 12 != 0) {
    loc_401b4e:
        rax = *rbp - 12;
        LEAVE_FULL();  // 0x401b52
        RET_IMM();  // 0x401b55
        return result;  // 0x401b55
    }
    rax = *0x40b044;
    if (rax != 0) {
        param_2 = *0x40b044;
        rax = *rbp + 8;
        (*(rsp)) = (int32_t)(rax);  // 0x401b46
        sub_param_2();  // 0x401b48 | [WARNING] Indirect call
        rsp = rsp - 4;
        (*(rbp - 12)) = (int32_t)(rax);  // 0x401b4e
    }
    goto loc_401b4e;
}

