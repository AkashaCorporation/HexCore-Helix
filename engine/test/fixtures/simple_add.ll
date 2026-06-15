; ModuleID = 'simple_add'
source_filename = "simple_add"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.0.0"

%struct.State = type { %struct.X86State }
%struct.X86State = type { %struct.GPR, %struct.FLAGS }
%struct.GPR = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct.FLAGS = type { i8, i8, i8, i8, i8, i8 }

; Simple function: adds two values and returns
; Equivalent to: int64_t sub_140001000(int64_t arg1, int64_t arg2) { return arg1 + arg2; }
define ptr @lifted_5368713216(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
entry:
  ; Read RCX (first argument, Win64)
  %0 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 1, !remill_register !0
  %rcx = load i64, ptr %0, align 8

  ; Read RDX (second argument, Win64)
  %1 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 2, !remill_register !1
  %rdx = load i64, ptr %1, align 8

  ; ADD RCX, RDX
  %result = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWImE2MnImE2RnImLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %memory, ptr %state, i64 %rcx, i64 %rdx, i64 %rcx)

  ; Store result to RAX
  %2 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 0, !remill_register !2
  store i64 %rcx, ptr %2, align 8

  ; Return
  ret ptr %memory
}

declare ptr @_ZN12_GLOBAL__N_13ADDI3MnWImE2MnImE2RnImLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr, ptr, i64, i64, i64)

!0 = !{[4 x i8] c"RCX\00"}
!1 = !{[4 x i8] c"RDX\00"}
!2 = !{[4 x i8] c"RAX\00"}
