; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: wwzRetailEgs.exe
; Address: 0x140000000
; Size: 47027200 bytes
; Architecture: amd64
; Generated: 2026-02-23T05:54:03.765Z
; ============================================================
; ModuleID = '\\?\c:\Users\Mazum\Desktop\vscode-main\extensions\hexcore-remill\deps\remill\share\semantics\amd64.bc'
source_filename = "llvm-link"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-windows-msvc-coff"

%struct.State = type { %struct.X86State }
%struct.X86State = type { %struct.ArchState, [32 x %union.VectorReg], %struct.ArithFlags, %union.anon, %struct.Segments, %struct.AddressSpace, %struct.GPR, %struct.X87Stack, %struct.MMX, %struct.FPUStatusFlags, %union.anon, %union.FPU, %struct.SegmentCaches, %struct.K_REG }
%struct.ArchState = type { i32, i32, %union.anon }
%union.VectorReg = type { %union.vec512_t }
%union.vec512_t = type { %struct.uint128v4_t }
%struct.uint128v4_t = type { [4 x i128] }
%struct.ArithFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8 }
%struct.Segments = type { i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector }
%union.SegmentSelector = type { i16 }
%struct.AddressSpace = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.Reg = type { %union.anon }
%struct.GPR = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.X87Stack = type { [8 x %struct.anon.3] }
%struct.anon.3 = type { [6 x i8], %struct.float80_t }
%struct.float80_t = type { [10 x i8] }
%struct.MMX = type { [8 x %struct.anon.4] }
%struct.anon.4 = type { i64, %union.vec64_t }
%union.vec64_t = type { %struct.uint64v1_t }
%struct.uint64v1_t = type { [1 x i64] }
%struct.FPUStatusFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, [2 x i8] }
%union.anon = type { i64 }
%union.FPU = type { %struct.anon.13 }
%struct.anon.13 = type { %struct.FpuFXSAVE, [96 x i8] }
%struct.FpuFXSAVE = type { %union.SegmentSelector, %union.SegmentSelector, %union.FPUAbridgedTagWord, i8, i16, i32, %union.SegmentSelector, i16, i32, %union.SegmentSelector, i16, %union.FPUControlStatus, %union.FPUControlStatus, [8 x %struct.FPUStackElem], [16 x %union.vec128_t] }
%union.FPUAbridgedTagWord = type { i8 }
%union.FPUControlStatus = type { i32 }
%struct.FPUStackElem = type { %union.anon.11, [6 x i8] }
%union.anon.11 = type { %struct.float80_t }
%union.vec128_t = type { %struct.uint128v1_t }
%struct.uint128v1_t = type { [1 x i128] }
%struct.SegmentCaches = type { %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow }
%struct.SegmentShadow = type { %union.anon, i32, i32 }
%struct.K_REG = type { [8 x %struct.anon.18] }
%struct.anon.18 = type { i64, i64 }

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i8 @__remill_read_memory_8(ptr noundef, i64 noundef) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local ptr @__remill_write_memory_8(ptr noundef, i64 noundef, i8 noundef zeroext) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_flag_computation_carry(i1 noundef zeroext, ...) #0

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare !remill.function.type !5 i8 @llvm.ctpop.i8(i8) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_flag_computation_zero(i1 noundef zeroext, ...) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_flag_computation_sign(i1 noundef zeroext, ...) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_flag_computation_overflow(i1 noundef zeroext, ...) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local i64 @__remill_read_memory_64(ptr noundef, i64 noundef) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3MnWIhE2MnIhE2RnIhLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

define ptr @lifted_5368709120(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
  %RAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !6
  %AL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !7
  %RBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !8
  %R10 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 21, i32 0, i32 0, !remill_register !9
  %BRANCH_TAKEN = alloca i8, align 1
  %RETURN_PC = alloca i64, align 8
  %MONITOR = alloca i64, align 8
  store i64 0, ptr %MONITOR, align 8
  %STATE = alloca ptr, align 8
  store ptr %state, ptr %STATE, align 8
  %MEMORY = alloca ptr, align 8
  store ptr %memory, ptr %MEMORY, align 8
  %NEXT_PC = alloca i64, align 8
  store i64 %program_counter, ptr %NEXT_PC, align 8
  %PC = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 33, i32 0, i32 0, !remill_register !10
  %CSBASE = alloca i64, align 8
  store i64 0, ptr %CSBASE, align 8
  %SSBASE = alloca i64, align 8
  store i64 0, ptr %SSBASE, align 8
  %ESBASE = alloca i64, align 8
  store i64 0, ptr %ESBASE, align 8
  %DSBASE = alloca i64, align 8
  store i64 0, ptr %DSBASE, align 8
  %1 = load i64, ptr %NEXT_PC, align 8
  store i64 %1, ptr %PC, align 8
  %2 = add i64 %1, 2
  store i64 %2, ptr %NEXT_PC, align 8
  %3 = load ptr, ptr %MEMORY, align 8
  %4 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %3, ptr %state, ptr %R10)
  store ptr %4, ptr %MEMORY, align 8
  %5 = load i64, ptr %NEXT_PC, align 8
  store i64 %5, ptr %PC, align 8
  %6 = add i64 %5, 1
  store i64 %6, ptr %NEXT_PC, align 8
  %7 = load ptr, ptr %MEMORY, align 8
  %8 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %7, ptr %state)
  store ptr %8, ptr %MEMORY, align 8
  %9 = load i64, ptr %NEXT_PC, align 8
  store i64 %9, ptr %PC, align 8
  %10 = add i64 %9, 2
  store i64 %10, ptr %NEXT_PC, align 8
  %11 = load i64, ptr %RBX, align 8
  %12 = load i64, ptr %RBX, align 8
  %13 = load i8, ptr %AL, align 1
  %14 = zext i8 %13 to i64
  %15 = load ptr, ptr %MEMORY, align 8
  %16 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIhE2MnIhE2RnIhLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %15, ptr %state, i64 %11, i64 %12, i64 %14)
  store ptr %16, ptr %MEMORY, align 8
  %17 = load i64, ptr %NEXT_PC, align 8
  store i64 %17, ptr %PC, align 8
  %18 = add i64 %17, 2
  store i64 %18, ptr %NEXT_PC, align 8
  %19 = load i64, ptr %RAX, align 8
  %20 = load i64, ptr %RAX, align 8
  %21 = load i8, ptr %AL, align 1
  %22 = zext i8 %21 to i64
  %23 = load ptr, ptr %MEMORY, align 8
  %24 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIhE2MnIhE2RnIhLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %23, ptr %state, i64 %19, i64 %20, i64 %22)
  store ptr %24, ptr %MEMORY, align 8
  %25 = load i64, ptr %NEXT_PC, align 8
  store i64 %25, ptr %PC, align 8
  %26 = add i64 %25, 3
  store i64 %26, ptr %NEXT_PC, align 8
  %27 = load i64, ptr %RAX, align 8
  %28 = load i64, ptr %RAX, align 8
  %29 = mul i64 %28, 1
  %30 = add i64 %27, %29
  %31 = load i64, ptr %RAX, align 8
  %32 = load i64, ptr %RAX, align 8
  %33 = mul i64 %32, 1
  %34 = add i64 %31, %33
  %35 = load i8, ptr %AL, align 1
  %36 = zext i8 %35 to i64
  %37 = load ptr, ptr %MEMORY, align 8
  %38 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIhE2MnIhE2RnIhLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %37, ptr %state, i64 %30, i64 %34, i64 %36)
  store ptr %38, ptr %MEMORY, align 8
  %39 = load i64, ptr %NEXT_PC, align 8
  store i64 %39, ptr %PC, align 8
  %40 = add i64 %39, 2
  store i64 %40, ptr %NEXT_PC, align 8
  %41 = load i64, ptr %RAX, align 8
  %42 = load i64, ptr %RAX, align 8
  %43 = load i8, ptr %AL, align 1
  %44 = zext i8 %43 to i64
  %45 = load ptr, ptr %MEMORY, align 8
  %46 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIhE2MnIhE2RnIhLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %45, ptr %state, i64 %41, i64 %42, i64 %44)
  store ptr %46, ptr %MEMORY, align 8
  ret ptr %memory
}

attributes #0 = { noduplicate noinline nounwind optnone "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { alwaysinline mustprogress nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #3 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }

!llvm.ident = !{!0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3, !4}

!0 = !{!"clang version 18.1.8"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"base.helper.semantics"}
!6 = !{[4 x i8] c"RAX\00"}
!7 = !{[3 x i8] c"AL\00"}
!8 = !{[4 x i8] c"RBX\00"}
!9 = !{[4 x i8] c"R10\00"}
!10 = !{[3 x i8] c"PC\00"}
