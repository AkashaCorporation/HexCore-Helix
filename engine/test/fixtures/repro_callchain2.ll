; ModuleID = 'repro_callchain2'
source_filename = "repro_callchain2"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.0.0"

%struct.State = type { %struct.X86State }
%struct.X86State = type { %struct.GPR, %struct.FLAGS }
%struct.GPR = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct.FLAGS = type { i8, i8, i8, i8, i8, i8 }

; Surviving call chain: each external CALL returns into RAX; the result is moved
; into RCX (win64 arg-0 register) and fed to the next call, so the call results
; stay LIVE (do not get DCE'd). Models 'x = f(); x = f(x); x = f(x);'.
; GPR encoding order: RAX=0, RCX=1 ... RSI=6.
define ptr @lifted_5368713216(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
entry:
  ; CALL ext (1) -> RAX
  %c1 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_(ptr %memory, ptr %state, i64 5368717312)
  ; MOV RCX, RAX  (pass result as the next call's arg-0)
  %raxp = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 0, !remill_register !2
  %r1 = load i64, ptr %raxp, align 8
  %rcxp = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 1, !remill_register !3
  store i64 %r1, ptr %rcxp, align 8
  ; CALL ext (2) reads RCX -> RAX
  %c2 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_(ptr %memory, ptr %state, i64 5368717312)
  ; MOV RCX, RAX
  %r2 = load i64, ptr %raxp, align 8
  store i64 %r2, ptr %rcxp, align 8
  ; CALL ext (3) reads RCX -> RAX (final RAX = return value)
  %c3 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_(ptr %memory, ptr %state, i64 5368717312)
  ; store final RAX into RBX too, so it is observably live across a second reg
  %rbxp = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 0, i32 3, !remill_register !4
  %r3 = load i64, ptr %raxp, align 8
  store i64 %r3, ptr %rbxp, align 8
  ret ptr %memory
}

declare ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_(ptr, ptr, i64)

!2 = !{[4 x i8] c"RAX\00"}
!3 = !{[4 x i8] c"RCX\00"}
!4 = !{[4 x i8] c"RBX\00"}
