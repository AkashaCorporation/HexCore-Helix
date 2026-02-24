// Decompiled by HexCore Helix (Phase 2 — MLIR Engine)
// Source: wwzRetailEgs.exe
// Arch:   amd64
// Entry:  0x141f7939d

// ─── sub_141f7939d ────────────────────────────────────────
int64_t sub_141f7939d(int64_t rcx, int64_t rdx, int64_t r8, int64_t r9) {
    // Register variables
    int64_t  rax;
    int64_t  rbx;
    int16_t  ax;
    int32_t  ebx;
    int32_t  eax;
    int8_t   cl;
    int64_t  rsp;
    int64_t  rdi;
    int64_t  var_20;  // [rsp+0x20]
    int64_t  var_40;  // [rsp+0x40]

    // frame size: 32 bytes
    sub_142046040();  // 0x141f7939d
    void* result_bf18 = sub_141f7bf18();  // 0x141f793a3
    if ((rax != 0)) {
        sub_141f786e0(result_bf18);  // 0x141f793b4
        sub_141f7e929(result_bf18);  // 0x141f793c0
    }
    sub_141f79d70();  // 0x141f793c5
    void* result_e90b = sub_141f7e90b();  // 0x141f793cd
    sub_140231ad0((void*)0x140000000, 0, result_e90b, ebx);  // 0x141f793e1
    sub_141f79db8();  // 0x141f793e8
    sub_141f7e8e1();  // 0x141f793f6
    sub_141f787a0();  // 0x141f793ff
    sub_141f79db8();  // 0x141f7940a
    sub_141f7e923();  // 0x141f7941a
    rdi = *rsp;  // 0x141f7942a
    return;
}

