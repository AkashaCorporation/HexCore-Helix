; ModuleID = 'branch'
source_filename = "branch"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.0.0"

%struct.State = type { %struct.X86State }
%struct.X86State = type { %struct.GPR, %struct.FLAGS }
%struct.GPR = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct.FLAGS = type { i8, i8, i8, i8, i8, i8 }

; Function with a conditional branch
; Equivalent to: int64_t sub_140004000(int64_t x) { if (x == 0) return 1; return x; }
define ptr @lifted_5368725504(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
entry:
  ; Read RCX (first argument)
  %0 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 1, !remill_register !0
  %rcx = load i64, ptr %0, align 8

  ; TEST RCX, RCX
  %test_result = call ptr @_ZN12_GLOBAL__N_14TESTI2MnImE2RnImEEEP6MemoryS6_R5StateT_T0_(ptr %memory, ptr %state, i64 %rcx, i64 %rcx)

  ; CMP RCX, 0
  %cmp_result = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2RnImEEEP6MemoryS6_R5StateT_T0_(ptr %memory, ptr %state, i64 %rcx, i64 0)

  ; Store 1 to RAX (the if-true branch result)
  %1 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 0, !remill_register !1
  store i64 1, ptr %1, align 8

  ; NOP (alignment)
  %nop_result = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %memory, ptr %state)

  ret ptr %memory
}

declare ptr @_ZN12_GLOBAL__N_14TESTI2MnImE2RnImEEEP6MemoryS6_R5StateT_T0_(ptr, ptr, i64, i64)
declare ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2RnImEEEP6MemoryS6_R5StateT_T0_(ptr, ptr, i64, i64)
declare ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr, ptr)

!0 = !{[4 x i8] c"RCX\00"}
!1 = !{[4 x i8] c"RAX\00"}
