// Decompiled by HexCore Helix
// Engine version: 1.0.0-mlir-3tier

// -----------------------------------------------------------------------------
// sub_401122 (0x401122)
// Confidence: 89.8% (High)
// Issues:
//  - Unresolved call target
// -----------------------------------------------------------------------------
int64_t sub_401122(int64_t param_1, int64_t param_2) {
    int64_t  rbp;
    int64_t  rsp;
    int64_t  rbx;
    int64_t  rax;
    int64_t  result;
    int64_t  var_0;
    (*(rbp - 12)) = 0;  // 0x401133
    (*(rbp - 0x10)) = 0;  // 0x40113a
    (*(rsp + 8)) = 0x44;  // 0x401142
    (*(rsp + 4)) = 0;  // 0x40114a
    (*(rbp - 0x6c)) = 0x10;  // 0x401167
    DIVedxeax();  // 0x40116f
    rax = (rax * 0x10);
    rax = (rax << 4);
    (*(rbp - 12)) = (int32_t)(rax);  // 0x401189
    (*(rsp + 8)) = 0x20;  // 0x401191
    (*(rsp + 4)) = 0xcc;  // 0x401199
    rax = (*(rbp - 12));
    rsp = (rsp & -0x10);
    result = (*0x40b020);
    if (result == 0) {
    } else {
        (*rsp) = (int32_t)(rax);  // 0x4011b6
        rax = (*0x40c16c);
        sub_4011BD();  // 0x4011bd
        rsp = (rsp - 4);
        (*(rbp - 0x18)) = 0;  // 0x4011c7
        result = rax->field_0x4;
        (*(rbp - 0x1c)) = (int32_t)(result);  // 0x4011d2
        (*(rbp - 0x14)) = 0;  // 0x4011d9
        return result;
    }
    return result;
loc_irr_104:
    rax = *(rbp - 0x18);
    if (rax != (rbp - 0x1c)) goto loc_irr_101;
    (*((rbp - 0x14))) = 1;  // 0x401297
    return result;
loc_irr_101:
    (*(rsp)) = 0x3e8;  // 0x401305
    rax = *0x40c198;
    sub_rax();  // 0x40137d | [WARNING] Indirect call
    rsp = (rsp - 4);
    rax = *(rbp - 0x1c);
    (*((rsp + 8))) = 0;  // 0x4013c8
    (*((rsp + 4))) = (int32_t)(rax);  // 0x4013cc
    (*(rsp)) = 0x40bdb4;  // 0x4013d3
    rsp = (rsp - 12);
    (*((rbp - 0x18))) = (int32_t)(rax);  // 0x4013de
    if ((rbp - 0x18) != 0) goto loc_irr_104;
    rax = *0x40bdb8;
    if (rax != 1) goto loc_irr_106;
    (*(rsp)) = 0x1f;  // 0x4013f5
    return result;
loc_irr_106:
    rax = *0x40bdb8;
    if (rax != 0) goto loc_irr_108;
    (*(0x40bdb8)) = 1;  // 0x401401
    (*((rsp + 4))) = 0x40d018;  // 0x401409
    (*(rsp)) = 0x40d00c;  // 0x401410
    return result;
loc_irr_108:
    (*(0x40b018)) = 1;  // 0x401401
    rax = *0x40bdb8;
    if (rax != 1) goto loc_irr_111;
    (*((rsp + 4))) = 0x40d008;  // 0x401413
    (*(rsp)) = 0x40d000;  // 0x40141a
    (*(0x40bdb8)) = 2;  // 0x401429
loc_irr_111:
    if ((rbp - 0x14) != 0) goto loc_irr_113;
    (*((rbp - 0x20))) = 0x40bdb4;  // 0x401436
    (*((rbp - 0x24))) = 0;  // 0x40143d
    rax = *(rbp - 0x20);
    param_2 = *(rbp - 0x24);
    rbx = param_2;
    xchg(reg_a, reg_b);  // 0x401448
    (*((rbp - 0x24))) = (int32_t)(rbx);  // 0x40144b
loc_irr_113:
    rax = *0x40a05c;
    if (rax == 0) goto loc_irr_115;
    rax = *0x40a05c;
    (*((rsp + 8))) = 0;  // 0x401461
    (*((rsp + 4))) = 2;  // 0x401469
    (*(rsp)) = 0;  // 0x401470
    sub_rax();  // 0x401472 | [WARNING] Indirect call
    rsp = (rsp - 12);
loc_irr_115:
    (*(rsp)) = 0x401a34;  // 0x401481
    rax = *0x40c194;
    sub_rax();  // 0x401488 | [WARNING] Indirect call
    rsp = (rsp - 4);
    (*(0x40b044)) = (int32_t)(rax);  // 0x401490
    rax = *0x40b020;
    if (rax == 0) goto loc_irr_117;
    rax = *rax;
    (*((rbp - 12))) = (int32_t)(rax);  // 0x4014b1
    return result;
loc_irr_122:
    rax = *(rbp - 12);
    if ((int32_t)(rax) != 0x22) goto loc_irr_119;
    rax = 0;
    (*((rbp - 0x10))) = (int32_t)(rax);  // 0x4014ca
loc_irr_119:
    (*((rbp - 12))) = ((rbp - 12) + 1);  // 0x4014ce
    rax = *(rbp - 12);
    if ((int32_t)(rax) > 0x20) goto loc_irr_122;
    rax = *(rbp - 12);
    if ((int32_t)(rax) == 0) goto loc_irr_124;
    if ((rbp - 0x10) != 0) goto loc_irr_122;
    return result;
loc_irr_130:
    (*((rbp - 12))) = ((rbp - 12) + 1);  // 0x401502
    return result;
loc_irr_124:
    rax = *(rbp - 12);
    if ((int32_t)(rax) == 0) goto loc_irr_128;
    rax = *(rbp - 12);
    if ((int32_t)(rax) <= 0x20) goto loc_irr_130;
loc_irr_128:
    (*(0x40bda8)) = 0x400000;  // 0x40153b
    rax = *(rbp - 12);
    (*(0x40bda0)) = (int32_t)(rax);  // 0x401543
    rax = (rax & 1);
    if (rax == 0) goto loc_irr_131;
    return result;
loc_irr_131:
    rax = 10;
    (*(0x40bda4)) = (int32_t)(rax);  // 0x401557
loc_irr_117:
    rax = *0x40b000;
    (*((rsp + 4))) = 0x40b004;  // 0x401564
    (*(rsp)) = (int32_t)(rax);  // 0x401567
    rax = *0x40c1c0;
    param_2 = *0x40b008;
    (*(rax)) = (int32_t)(param_2);  // 0x40157e
    param_1 = *0x40b008;
    param_2 = *0x40b004;
    rax = *0x40b000;
    (*((rsp + 8))) = (int32_t)(param_1);  // 0x401593
    (*((rsp + 4))) = (int32_t)(param_2);  // 0x401597
    (*(rsp)) = (int32_t)(rax);  // 0x40159a
    (*(0x40b010)) = (int32_t)(rax);  // 0x4015a4
    rax = *0x40b014;
    if (rax != 0) goto loc_irr_134;
    result = *0x40b010;
    (*(rsp)) = (int32_t)(result);  // 0x4015b5
    return result;  // 0x4015ba
loc_irr_134:
    rax = *0x40b018;
    if (rax != 0) goto loc_irr_136;
    return result;  // 0x4015bb
loc_irr_136:
    rax = *0x40b010;
    LEAVE_FULL(*0x40b008, *0x40b004);  // 0x4015bf
    return result;  // 0x4015c0
}

