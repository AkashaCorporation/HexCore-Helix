; ModuleID = 'simple_call'
source_filename = "simple_call"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.0.0"

%struct.State = type { %struct.X86State }
%struct.X86State = type { %struct.GPR, %struct.FLAGS }
%struct.GPR = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct.FLAGS = type { i8, i8, i8, i8, i8, i8 }

; Function that calls another function
; Equivalent to: void sub_140002000(void) { sub_140003000(); }
define ptr @lifted_5368717312(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
entry:
  ; PUSH RBP (prologue)
  %0 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 5, !remill_register !0
  %rbp = load i64, ptr %0, align 8
  %result_push = call ptr @_ZN12_GLOBAL__N_14PUSHI2RnImEEEP6MemoryS4_R5StateT_(ptr %memory, ptr %state, i64 %rbp)

  ; MOV RBP, RSP
  %1 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 4, !remill_register !1
  %rsp = load i64, ptr %1, align 8
  store i64 %rsp, ptr %0, align 8

  ; CALL target
  %call_result = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_(ptr %memory, ptr %state, i64 5368721408)

  ; POP RBP (epilogue)
  %result_pop = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %memory, ptr %state, i64 0)

  ; RET
  ret ptr %memory
}

declare ptr @_ZN12_GLOBAL__N_14PUSHI2RnImEEEP6MemoryS4_R5StateT_(ptr, ptr, i64)
declare ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_(ptr, ptr, i64)
declare ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr, ptr, i64)

!0 = !{[4 x i8] c"RBP\00"}
!1 = !{[4 x i8] c"RSP\00"}
