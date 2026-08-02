; ModuleID = 'repro_callchain'
source_filename = "repro_callchain"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.0.0"

%struct.State = type { %struct.X86State }
%struct.X86State = type { %struct.GPR, %struct.FLAGS }
%struct.GPR = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct.FLAGS = type { i8, i8, i8, i8, i8, i8 }

; Chained call-result reuse (models the fh_install_hook 'v3 = printk(0, v3)' x4
; shape): each external CALL returns into RAX; the result is aliased through RSI
; (mov rsi, rax) and fed to the next call. GPR encoding order: RAX=0 ... RSI=6.
define ptr @lifted_5368713216(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
entry:
  ; CALL ext (1) -> RAX = result
  %c1 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_(ptr %memory, ptr %state, i64 5368717312)
  ; MOV RSI, RAX
  %raxp1 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 0, !remill_register !2
  %rax1 = load i64, ptr %raxp1, align 8
  %rsip1 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 6, !remill_register !3
  store i64 %rax1, ptr %rsip1, align 8
  ; CALL ext (2) -> RAX = result
  %c2 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_(ptr %memory, ptr %state, i64 5368717312)
  ; MOV RSI, RAX
  %rax2 = load i64, ptr %raxp1, align 8
  store i64 %rax2, ptr %rsip1, align 8
  ; CALL ext (3) -> RAX = result
  %c3 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_(ptr %memory, ptr %state, i64 5368717312)
  ; RET
  ret ptr %memory
}

declare ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_(ptr, ptr, i64)

!2 = !{[4 x i8] c"RAX\00"}
!3 = !{[4 x i8] c"RSI\00"}
