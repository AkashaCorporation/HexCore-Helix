; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: wwzRetailEgs.exe
; Address: 0x141f7939d
; Size: 256 bytes
; Architecture: amd64
; Generated: 2026-02-23T16:54:30.540Z
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

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local ptr @__remill_write_memory_64(ptr noundef, i64 noundef, i64 noundef) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2MnIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i8 @__remill_undefined_8() #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i64, ptr nocapture writeonly, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i64, ptr nocapture writeonly, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_neq(i1 noundef zeroext) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_eq(i1 noundef zeroext) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #3

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #3

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #3

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #3

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture readnone) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #3

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, ptr nocapture writeonly) #3

define ptr @lifted_5401711517(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
  %RDI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 11, i32 0, i32 0, !remill_register !6
  %RSP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 13, i32 0, i32 0, !remill_register !7
  %CL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !8
  %DIL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 11, i32 0, i32 0, !remill_register !9
  %EAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !10
  %EDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !11
  %RDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !12
  %EBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !13
  %R9 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 19, i32 0, i32 0, !remill_register !14
  %R8 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 17, i32 0, i32 0, !remill_register !15
  %AX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !16
  %AL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !17
  %RCX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !18
  %RAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !19
  %RBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !20
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
  %PC = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 33, i32 0, i32 0, !remill_register !21
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
  %2 = add i64 %1, 6
  store i64 %2, ptr %NEXT_PC, align 8
  %3 = load i64, ptr %NEXT_PC, align 8
  %4 = add i64 %3, 838813
  %5 = load i64, ptr %NEXT_PC, align 8
  %6 = load ptr, ptr %MEMORY, align 8
  %7 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %6, ptr %state, i64 %4, ptr %NEXT_PC, i64 %5, ptr %RETURN_PC)
  store ptr %7, ptr %MEMORY, align 8
  %8 = load i64, ptr %NEXT_PC, align 8
  store i64 %8, ptr %PC, align 8
  %9 = add i64 %8, 5
  store i64 %9, ptr %NEXT_PC, align 8
  %10 = load i64, ptr %NEXT_PC, align 8
  %11 = add i64 %10, 11120
  %12 = load i64, ptr %NEXT_PC, align 8
  %13 = load ptr, ptr %MEMORY, align 8
  %14 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %13, ptr %state, i64 %11, ptr %NEXT_PC, i64 %12, ptr %RETURN_PC)
  store ptr %14, ptr %MEMORY, align 8
  %15 = load i64, ptr %NEXT_PC, align 8
  store i64 %15, ptr %PC, align 8
  %16 = add i64 %15, 3
  store i64 %16, ptr %NEXT_PC, align 8
  %17 = load i64, ptr %RAX, align 8
  %18 = load ptr, ptr %MEMORY, align 8
  %19 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %18, ptr %state, ptr %RBX, i64 %17)
  store ptr %19, ptr %MEMORY, align 8
  %20 = load i64, ptr %NEXT_PC, align 8
  store i64 %20, ptr %PC, align 8
  %21 = add i64 %20, 4
  store i64 %21, ptr %NEXT_PC, align 8
  %22 = load i64, ptr %RAX, align 8
  %23 = load ptr, ptr %MEMORY, align 8
  %24 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %23, ptr %state, i64 %22, i64 0)
  store ptr %24, ptr %MEMORY, align 8
  %25 = load i64, ptr %NEXT_PC, align 8
  store i64 %25, ptr %PC, align 8
  %26 = add i64 %25, 2
  store i64 %26, ptr %NEXT_PC, align 8
  %27 = load i64, ptr %NEXT_PC, align 8
  %28 = add i64 %27, 20
  %29 = load i64, ptr %NEXT_PC, align 8
  %30 = load ptr, ptr %MEMORY, align 8
  %31 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %30, ptr %state, ptr %BRANCH_TAKEN, i64 %28, i64 %29, ptr %NEXT_PC)
  store ptr %31, ptr %MEMORY, align 8
  %32 = load i64, ptr %NEXT_PC, align 8
  store i64 %32, ptr %PC, align 8
  %33 = add i64 %32, 3
  store i64 %33, ptr %NEXT_PC, align 8
  %34 = load i64, ptr %RAX, align 8
  %35 = load ptr, ptr %MEMORY, align 8
  %36 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %35, ptr %state, ptr %RCX, i64 %34)
  store ptr %36, ptr %MEMORY, align 8
  %37 = load i64, ptr %NEXT_PC, align 8
  store i64 %37, ptr %PC, align 8
  %38 = add i64 %37, 5
  store i64 %38, ptr %NEXT_PC, align 8
  %39 = load i64, ptr %NEXT_PC, align 8
  %40 = sub i64 %39, 3289
  %41 = load i64, ptr %NEXT_PC, align 8
  %42 = load ptr, ptr %MEMORY, align 8
  %43 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %42, ptr %state, i64 %40, ptr %NEXT_PC, i64 %41, ptr %RETURN_PC)
  store ptr %43, ptr %MEMORY, align 8
  %44 = load i64, ptr %NEXT_PC, align 8
  store i64 %44, ptr %PC, align 8
  %45 = add i64 %44, 2
  store i64 %45, ptr %NEXT_PC, align 8
  %46 = load i8, ptr %AL, align 1
  %47 = zext i8 %46 to i64
  %48 = load i8, ptr %AL, align 1
  %49 = zext i8 %48 to i64
  %50 = load ptr, ptr %MEMORY, align 8
  %51 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %50, ptr %state, i64 %47, i64 %49)
  store ptr %51, ptr %MEMORY, align 8
  %52 = load i64, ptr %NEXT_PC, align 8
  store i64 %52, ptr %PC, align 8
  %53 = add i64 %52, 2
  store i64 %53, ptr %NEXT_PC, align 8
  %54 = load i64, ptr %NEXT_PC, align 8
  %55 = add i64 %54, 8
  %56 = load i64, ptr %NEXT_PC, align 8
  %57 = load ptr, ptr %MEMORY, align 8
  %58 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %57, ptr %state, ptr %BRANCH_TAKEN, i64 %55, i64 %56, ptr %NEXT_PC)
  store ptr %58, ptr %MEMORY, align 8
  %59 = load i64, ptr %NEXT_PC, align 8
  store i64 %59, ptr %PC, align 8
  %60 = add i64 %59, 3
  store i64 %60, ptr %NEXT_PC, align 8
  %61 = load i64, ptr %RBX, align 8
  %62 = load ptr, ptr %MEMORY, align 8
  %63 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %62, ptr %state, ptr %RCX, i64 %61)
  store ptr %63, ptr %MEMORY, align 8
  %64 = load i64, ptr %NEXT_PC, align 8
  store i64 %64, ptr %PC, align 8
  %65 = add i64 %64, 5
  store i64 %65, ptr %NEXT_PC, align 8
  %66 = load i64, ptr %NEXT_PC, align 8
  %67 = add i64 %66, 21860
  %68 = load i64, ptr %NEXT_PC, align 8
  %69 = load ptr, ptr %MEMORY, align 8
  %70 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %69, ptr %state, i64 %67, ptr %NEXT_PC, i64 %68, ptr %RETURN_PC)
  store ptr %70, ptr %MEMORY, align 8
  %71 = load i64, ptr %NEXT_PC, align 8
  store i64 %71, ptr %PC, align 8
  %72 = add i64 %71, 5
  store i64 %72, ptr %NEXT_PC, align 8
  %73 = load i64, ptr %NEXT_PC, align 8
  %74 = add i64 %73, 2470
  %75 = load i64, ptr %NEXT_PC, align 8
  %76 = load ptr, ptr %MEMORY, align 8
  %77 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %76, ptr %state, i64 %74, ptr %NEXT_PC, i64 %75, ptr %RETURN_PC)
  store ptr %77, ptr %MEMORY, align 8
  %78 = load i64, ptr %NEXT_PC, align 8
  store i64 %78, ptr %PC, align 8
  %79 = add i64 %78, 3
  store i64 %79, ptr %NEXT_PC, align 8
  %80 = load i16, ptr %AX, align 2
  %81 = zext i16 %80 to i64
  %82 = load ptr, ptr %MEMORY, align 8
  %83 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %82, ptr %state, ptr %RBX, i64 %81)
  store ptr %83, ptr %MEMORY, align 8
  %84 = load i64, ptr %NEXT_PC, align 8
  store i64 %84, ptr %PC, align 8
  %85 = add i64 %84, 5
  store i64 %85, ptr %NEXT_PC, align 8
  %86 = load i64, ptr %NEXT_PC, align 8
  %87 = add i64 %86, 21817
  %88 = load i64, ptr %NEXT_PC, align 8
  %89 = load ptr, ptr %MEMORY, align 8
  %90 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %89, ptr %state, i64 %87, ptr %NEXT_PC, i64 %88, ptr %RETURN_PC)
  store ptr %90, ptr %MEMORY, align 8
  %91 = load i64, ptr %NEXT_PC, align 8
  store i64 %91, ptr %PC, align 8
  %92 = add i64 %91, 3
  store i64 %92, ptr %NEXT_PC, align 8
  %93 = load i64, ptr %RAX, align 8
  %94 = load ptr, ptr %MEMORY, align 8
  %95 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %94, ptr %state, ptr %R8, i64 %93)
  store ptr %95, ptr %MEMORY, align 8
  %96 = load i64, ptr %NEXT_PC, align 8
  store i64 %96, ptr %PC, align 8
  %97 = add i64 %96, 3
  store i64 %97, ptr %NEXT_PC, align 8
  %98 = load i32, ptr %EBX, align 4
  %99 = zext i32 %98 to i64
  %100 = load ptr, ptr %MEMORY, align 8
  %101 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %100, ptr %state, ptr %R9, i64 %99)
  store ptr %101, ptr %MEMORY, align 8
  %102 = load i64, ptr %NEXT_PC, align 8
  store i64 %102, ptr %PC, align 8
  %103 = add i64 %102, 2
  store i64 %103, ptr %NEXT_PC, align 8
  %104 = load i64, ptr %RDX, align 8
  %105 = load i32, ptr %EDX, align 4
  %106 = zext i32 %105 to i64
  %107 = load ptr, ptr %MEMORY, align 8
  %108 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %107, ptr %state, ptr %RDX, i64 %104, i64 %106)
  store ptr %108, ptr %MEMORY, align 8
  %109 = load i64, ptr %NEXT_PC, align 8
  store i64 %109, ptr %PC, align 8
  %110 = add i64 %109, 7
  store i64 %110, ptr %NEXT_PC, align 8
  %111 = load i64, ptr %NEXT_PC, align 8
  %112 = sub i64 %111, 33002465
  %113 = load ptr, ptr %MEMORY, align 8
  %114 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %113, ptr %state, ptr %RCX, i64 %112)
  store ptr %114, ptr %MEMORY, align 8
  %115 = load i64, ptr %NEXT_PC, align 8
  store i64 %115, ptr %PC, align 8
  %116 = add i64 %115, 5
  store i64 %116, ptr %NEXT_PC, align 8
  %117 = load i64, ptr %NEXT_PC, align 8
  %118 = sub i64 %117, 30701846
  %119 = load i64, ptr %NEXT_PC, align 8
  %120 = load ptr, ptr %MEMORY, align 8
  %121 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %120, ptr %state, i64 %118, ptr %NEXT_PC, i64 %119, ptr %RETURN_PC)
  store ptr %121, ptr %MEMORY, align 8
  %122 = load i64, ptr %NEXT_PC, align 8
  store i64 %122, ptr %PC, align 8
  %123 = add i64 %122, 2
  store i64 %123, ptr %NEXT_PC, align 8
  %124 = load i32, ptr %EAX, align 4
  %125 = zext i32 %124 to i64
  %126 = load ptr, ptr %MEMORY, align 8
  %127 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %126, ptr %state, ptr %RBX, i64 %125)
  store ptr %127, ptr %MEMORY, align 8
  %128 = load i64, ptr %NEXT_PC, align 8
  store i64 %128, ptr %PC, align 8
  %129 = add i64 %128, 5
  store i64 %129, ptr %NEXT_PC, align 8
  %130 = load i64, ptr %NEXT_PC, align 8
  %131 = add i64 %130, 2507
  %132 = load i64, ptr %NEXT_PC, align 8
  %133 = load ptr, ptr %MEMORY, align 8
  %134 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %133, ptr %state, i64 %131, ptr %NEXT_PC, i64 %132, ptr %RETURN_PC)
  store ptr %134, ptr %MEMORY, align 8
  %135 = load i64, ptr %NEXT_PC, align 8
  store i64 %135, ptr %PC, align 8
  %136 = add i64 %135, 2
  store i64 %136, ptr %NEXT_PC, align 8
  %137 = load i8, ptr %AL, align 1
  %138 = zext i8 %137 to i64
  %139 = load i8, ptr %AL, align 1
  %140 = zext i8 %139 to i64
  %141 = load ptr, ptr %MEMORY, align 8
  %142 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %141, ptr %state, i64 %138, i64 %140)
  store ptr %142, ptr %MEMORY, align 8
  %143 = load i64, ptr %NEXT_PC, align 8
  store i64 %143, ptr %PC, align 8
  %144 = add i64 %143, 2
  store i64 %144, ptr %NEXT_PC, align 8
  %145 = load i64, ptr %NEXT_PC, align 8
  %146 = add i64 %145, 80
  %147 = load i64, ptr %NEXT_PC, align 8
  %148 = load ptr, ptr %MEMORY, align 8
  %149 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %148, ptr %state, ptr %BRANCH_TAKEN, i64 %146, i64 %147, ptr %NEXT_PC)
  store ptr %149, ptr %MEMORY, align 8
  %150 = load i64, ptr %NEXT_PC, align 8
  store i64 %150, ptr %PC, align 8
  %151 = add i64 %150, 3
  store i64 %151, ptr %NEXT_PC, align 8
  %152 = load i8, ptr %DIL, align 1
  %153 = zext i8 %152 to i64
  %154 = load i8, ptr %DIL, align 1
  %155 = zext i8 %154 to i64
  %156 = load ptr, ptr %MEMORY, align 8
  %157 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %156, ptr %state, i64 %153, i64 %155)
  store ptr %157, ptr %MEMORY, align 8
  %158 = load i64, ptr %NEXT_PC, align 8
  store i64 %158, ptr %PC, align 8
  %159 = add i64 %158, 2
  store i64 %159, ptr %NEXT_PC, align 8
  %160 = load i64, ptr %NEXT_PC, align 8
  %161 = add i64 %160, 5
  %162 = load i64, ptr %NEXT_PC, align 8
  %163 = load ptr, ptr %MEMORY, align 8
  %164 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %163, ptr %state, ptr %BRANCH_TAKEN, i64 %161, i64 %162, ptr %NEXT_PC)
  store ptr %164, ptr %MEMORY, align 8
  %165 = load i64, ptr %NEXT_PC, align 8
  store i64 %165, ptr %PC, align 8
  %166 = add i64 %165, 5
  store i64 %166, ptr %NEXT_PC, align 8
  %167 = load i64, ptr %NEXT_PC, align 8
  %168 = add i64 %167, 21734
  %169 = load i64, ptr %NEXT_PC, align 8
  %170 = load ptr, ptr %MEMORY, align 8
  %171 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %170, ptr %state, i64 %168, ptr %NEXT_PC, i64 %169, ptr %RETURN_PC)
  store ptr %171, ptr %MEMORY, align 8
  %172 = load i64, ptr %NEXT_PC, align 8
  store i64 %172, ptr %PC, align 8
  %173 = add i64 %172, 2
  store i64 %173, ptr %NEXT_PC, align 8
  %174 = load i64, ptr %RDX, align 8
  %175 = load i32, ptr %EDX, align 4
  %176 = zext i32 %175 to i64
  %177 = load ptr, ptr %MEMORY, align 8
  %178 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %177, ptr %state, ptr %RDX, i64 %174, i64 %176)
  store ptr %178, ptr %MEMORY, align 8
  %179 = load i64, ptr %NEXT_PC, align 8
  store i64 %179, ptr %PC, align 8
  %180 = add i64 %179, 2
  store i64 %180, ptr %NEXT_PC, align 8
  %181 = load ptr, ptr %MEMORY, align 8
  %182 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %181, ptr %state, ptr %CL, i64 1)
  store ptr %182, ptr %MEMORY, align 8
  %183 = load i64, ptr %NEXT_PC, align 8
  store i64 %183, ptr %PC, align 8
  %184 = add i64 %183, 5
  store i64 %184, ptr %NEXT_PC, align 8
  %185 = load i64, ptr %NEXT_PC, align 8
  %186 = sub i64 %185, 3172
  %187 = load i64, ptr %NEXT_PC, align 8
  %188 = load ptr, ptr %MEMORY, align 8
  %189 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %188, ptr %state, i64 %186, ptr %NEXT_PC, i64 %187, ptr %RETURN_PC)
  store ptr %189, ptr %MEMORY, align 8
  %190 = load i64, ptr %NEXT_PC, align 8
  store i64 %190, ptr %PC, align 8
  %191 = add i64 %190, 2
  store i64 %191, ptr %NEXT_PC, align 8
  %192 = load i32, ptr %EBX, align 4
  %193 = zext i32 %192 to i64
  %194 = load ptr, ptr %MEMORY, align 8
  %195 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %194, ptr %state, ptr %RAX, i64 %193)
  store ptr %195, ptr %MEMORY, align 8
  %196 = load i64, ptr %NEXT_PC, align 8
  store i64 %196, ptr %PC, align 8
  %197 = add i64 %196, 2
  store i64 %197, ptr %NEXT_PC, align 8
  %198 = load i64, ptr %NEXT_PC, align 8
  %199 = add i64 %198, 25
  %200 = load ptr, ptr %MEMORY, align 8
  %201 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %200, ptr %state, i64 %199, ptr %NEXT_PC)
  store ptr %201, ptr %MEMORY, align 8
  %202 = load i64, ptr %NEXT_PC, align 8
  store i64 %202, ptr %PC, align 8
  %203 = add i64 %202, 2
  store i64 %203, ptr %NEXT_PC, align 8
  %204 = load i32, ptr %EAX, align 4
  %205 = zext i32 %204 to i64
  %206 = load ptr, ptr %MEMORY, align 8
  %207 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %206, ptr %state, ptr %RBX, i64 %205)
  store ptr %207, ptr %MEMORY, align 8
  %208 = load i64, ptr %NEXT_PC, align 8
  store i64 %208, ptr %PC, align 8
  %209 = add i64 %208, 5
  store i64 %209, ptr %NEXT_PC, align 8
  %210 = load i64, ptr %NEXT_PC, align 8
  %211 = add i64 %210, 2473
  %212 = load i64, ptr %NEXT_PC, align 8
  %213 = load ptr, ptr %MEMORY, align 8
  %214 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %213, ptr %state, i64 %211, ptr %NEXT_PC, i64 %212, ptr %RETURN_PC)
  store ptr %214, ptr %MEMORY, align 8
  %215 = load i64, ptr %NEXT_PC, align 8
  store i64 %215, ptr %PC, align 8
  %216 = add i64 %215, 2
  store i64 %216, ptr %NEXT_PC, align 8
  %217 = load i8, ptr %AL, align 1
  %218 = zext i8 %217 to i64
  %219 = load i8, ptr %AL, align 1
  %220 = zext i8 %219 to i64
  %221 = load ptr, ptr %MEMORY, align 8
  %222 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %221, ptr %state, i64 %218, i64 %220)
  store ptr %222, ptr %MEMORY, align 8
  %223 = load i64, ptr %NEXT_PC, align 8
  store i64 %223, ptr %PC, align 8
  %224 = add i64 %223, 2
  store i64 %224, ptr %NEXT_PC, align 8
  %225 = load i64, ptr %NEXT_PC, align 8
  %226 = add i64 %225, 54
  %227 = load i64, ptr %NEXT_PC, align 8
  %228 = load ptr, ptr %MEMORY, align 8
  %229 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %228, ptr %state, ptr %BRANCH_TAKEN, i64 %226, i64 %227, ptr %NEXT_PC)
  store ptr %229, ptr %MEMORY, align 8
  %230 = load i64, ptr %NEXT_PC, align 8
  store i64 %230, ptr %PC, align 8
  %231 = add i64 %230, 5
  store i64 %231, ptr %NEXT_PC, align 8
  %232 = load i64, ptr %RSP, align 8
  %233 = add i64 %232, 32
  %234 = load ptr, ptr %MEMORY, align 8
  %235 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %234, ptr %state, i64 %233, i64 0)
  store ptr %235, ptr %MEMORY, align 8
  %236 = load i64, ptr %NEXT_PC, align 8
  store i64 %236, ptr %PC, align 8
  %237 = add i64 %236, 2
  store i64 %237, ptr %NEXT_PC, align 8
  %238 = load i64, ptr %NEXT_PC, align 8
  %239 = add i64 %238, 5
  %240 = load i64, ptr %NEXT_PC, align 8
  %241 = load ptr, ptr %MEMORY, align 8
  %242 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %241, ptr %state, ptr %BRANCH_TAKEN, i64 %239, i64 %240, ptr %NEXT_PC)
  store ptr %242, ptr %MEMORY, align 8
  %243 = load i64, ptr %NEXT_PC, align 8
  store i64 %243, ptr %PC, align 8
  %244 = add i64 %243, 5
  store i64 %244, ptr %NEXT_PC, align 8
  %245 = load i64, ptr %NEXT_PC, align 8
  %246 = add i64 %245, 21764
  %247 = load i64, ptr %NEXT_PC, align 8
  %248 = load ptr, ptr %MEMORY, align 8
  %249 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %248, ptr %state, i64 %246, ptr %NEXT_PC, i64 %247, ptr %RETURN_PC)
  store ptr %249, ptr %MEMORY, align 8
  %250 = load i64, ptr %NEXT_PC, align 8
  store i64 %250, ptr %PC, align 8
  %251 = add i64 %250, 2
  store i64 %251, ptr %NEXT_PC, align 8
  %252 = load i32, ptr %EBX, align 4
  %253 = zext i32 %252 to i64
  %254 = load ptr, ptr %MEMORY, align 8
  %255 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %254, ptr %state, ptr %RAX, i64 %253)
  store ptr %255, ptr %MEMORY, align 8
  %256 = load i64, ptr %NEXT_PC, align 8
  store i64 %256, ptr %PC, align 8
  %257 = add i64 %256, 5
  store i64 %257, ptr %NEXT_PC, align 8
  %258 = load i64, ptr %RSP, align 8
  %259 = add i64 %258, 64
  %260 = load ptr, ptr %MEMORY, align 8
  %261 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %260, ptr %state, ptr %RBX, i64 %259)
  store ptr %261, ptr %MEMORY, align 8
  %262 = load i64, ptr %NEXT_PC, align 8
  store i64 %262, ptr %PC, align 8
  %263 = add i64 %262, 4
  store i64 %263, ptr %NEXT_PC, align 8
  %264 = load i64, ptr %RSP, align 8
  %265 = load ptr, ptr %MEMORY, align 8
  %266 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %265, ptr %state, ptr %RSP, i64 %264, i64 48)
  store ptr %266, ptr %MEMORY, align 8
  %267 = load i64, ptr %NEXT_PC, align 8
  store i64 %267, ptr %PC, align 8
  %268 = add i64 %267, 1
  store i64 %268, ptr %NEXT_PC, align 8
  %269 = load ptr, ptr %MEMORY, align 8
  %270 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %269, ptr %state, ptr %RDI)
  store ptr %270, ptr %MEMORY, align 8
  %271 = load i64, ptr %NEXT_PC, align 8
  store i64 %271, ptr %PC, align 8
  %272 = add i64 %271, 1
  store i64 %272, ptr %NEXT_PC, align 8
  %273 = load ptr, ptr %MEMORY, align 8
  %274 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %273, ptr %state, ptr %NEXT_PC)
  store ptr %274, ptr %MEMORY, align 8
  %275 = load i64, ptr %NEXT_PC, align 8
  store i64 %275, ptr %PC, align 8
  %276 = add i64 %275, 5
  store i64 %276, ptr %NEXT_PC, align 8
  %277 = load ptr, ptr %MEMORY, align 8
  %278 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %277, ptr %state, ptr %RCX, i64 7)
  store ptr %278, ptr %MEMORY, align 8
  %279 = load i64, ptr %NEXT_PC, align 8
  store i64 %279, ptr %PC, align 8
  %280 = add i64 %279, 5
  store i64 %280, ptr %NEXT_PC, align 8
  %281 = load i64, ptr %NEXT_PC, align 8
  %282 = add i64 %281, 2030
  %283 = load i64, ptr %NEXT_PC, align 8
  %284 = load ptr, ptr %MEMORY, align 8
  %285 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %284, ptr %state, i64 %282, ptr %NEXT_PC, i64 %283, ptr %RETURN_PC)
  store ptr %285, ptr %MEMORY, align 8
  %286 = load i64, ptr %NEXT_PC, align 8
  store i64 %286, ptr %PC, align 8
  %287 = add i64 %286, 1
  store i64 %287, ptr %NEXT_PC, align 8
  %288 = load ptr, ptr %MEMORY, align 8
  %289 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %288, ptr %state)
  store ptr %289, ptr %MEMORY, align 8
  %290 = load i64, ptr %NEXT_PC, align 8
  store i64 %290, ptr %PC, align 8
  %291 = add i64 %290, 5
  store i64 %291, ptr %NEXT_PC, align 8
  %292 = load ptr, ptr %MEMORY, align 8
  %293 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %292, ptr %state, ptr %RCX, i64 7)
  store ptr %293, ptr %MEMORY, align 8
  %294 = load i64, ptr %NEXT_PC, align 8
  store i64 %294, ptr %PC, align 8
  %295 = add i64 %294, 5
  store i64 %295, ptr %NEXT_PC, align 8
  %296 = load i64, ptr %NEXT_PC, align 8
  %297 = add i64 %296, 2019
  %298 = load i64, ptr %NEXT_PC, align 8
  %299 = load ptr, ptr %MEMORY, align 8
  %300 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %299, ptr %state, i64 %297, ptr %NEXT_PC, i64 %298, ptr %RETURN_PC)
  store ptr %300, ptr %MEMORY, align 8
  %301 = load i64, ptr %NEXT_PC, align 8
  store i64 %301, ptr %PC, align 8
  %302 = add i64 %301, 2
  store i64 %302, ptr %NEXT_PC, align 8
  %303 = load i32, ptr %EBX, align 4
  %304 = zext i32 %303 to i64
  %305 = load ptr, ptr %MEMORY, align 8
  %306 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %305, ptr %state, ptr %RCX, i64 %304)
  store ptr %306, ptr %MEMORY, align 8
  %307 = load i64, ptr %NEXT_PC, align 8
  store i64 %307, ptr %PC, align 8
  %308 = add i64 %307, 5
  store i64 %308, ptr %NEXT_PC, align 8
  %309 = load i64, ptr %NEXT_PC, align 8
  %310 = add i64 %309, 20709
  %311 = load i64, ptr %NEXT_PC, align 8
  %312 = load ptr, ptr %MEMORY, align 8
  %313 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %312, ptr %state, i64 %310, ptr %NEXT_PC, i64 %311, ptr %RETURN_PC)
  store ptr %313, ptr %MEMORY, align 8
  %314 = load i64, ptr %NEXT_PC, align 8
  store i64 %314, ptr %PC, align 8
  %315 = add i64 %314, 1
  store i64 %315, ptr %NEXT_PC, align 8
  %316 = load ptr, ptr %MEMORY, align 8
  %317 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %316, ptr %state)
  store ptr %317, ptr %MEMORY, align 8
  %318 = load i64, ptr %NEXT_PC, align 8
  store i64 %318, ptr %PC, align 8
  %319 = add i64 %318, 2
  store i64 %319, ptr %NEXT_PC, align 8
  %320 = load i32, ptr %EBX, align 4
  %321 = zext i32 %320 to i64
  %322 = load ptr, ptr %MEMORY, align 8
  %323 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %322, ptr %state, ptr %RCX, i64 %321)
  store ptr %323, ptr %MEMORY, align 8
  %324 = load i64, ptr %NEXT_PC, align 8
  store i64 %324, ptr %PC, align 8
  %325 = add i64 %324, 5
  store i64 %325, ptr %NEXT_PC, align 8
  %326 = load i64, ptr %NEXT_PC, align 8
  %327 = add i64 %326, 21535
  %328 = load i64, ptr %NEXT_PC, align 8
  %329 = load ptr, ptr %MEMORY, align 8
  %330 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %329, ptr %state, i64 %327, ptr %NEXT_PC, i64 %328, ptr %RETURN_PC)
  store ptr %330, ptr %MEMORY, align 8
  %331 = load i64, ptr %NEXT_PC, align 8
  store i64 %331, ptr %PC, align 8
  %332 = add i64 %331, 1
  store i64 %332, ptr %NEXT_PC, align 8
  %333 = load ptr, ptr %MEMORY, align 8
  %334 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %333, ptr %state)
  store ptr %334, ptr %MEMORY, align 8
  %335 = load i64, ptr %NEXT_PC, align 8
  store i64 %335, ptr %PC, align 8
  %336 = add i64 %335, 1
  store i64 %336, ptr %NEXT_PC, align 8
  %337 = load ptr, ptr %MEMORY, align 8
  %338 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %337, ptr %state, ptr undef)
  store ptr %338, ptr %MEMORY, align 8
  %339 = load i64, ptr %NEXT_PC, align 8
  store i64 %339, ptr %PC, align 8
  %340 = add i64 %339, 1
  store i64 %340, ptr %NEXT_PC, align 8
  %341 = load ptr, ptr %MEMORY, align 8
  %342 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %341, ptr %state, ptr undef)
  store ptr %342, ptr %MEMORY, align 8
  %343 = load i64, ptr %NEXT_PC, align 8
  store i64 %343, ptr %PC, align 8
  %344 = add i64 %343, 1
  store i64 %344, ptr %NEXT_PC, align 8
  %345 = load ptr, ptr %MEMORY, align 8
  %346 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %345, ptr %state, ptr undef)
  store ptr %346, ptr %MEMORY, align 8
  %347 = load i64, ptr %NEXT_PC, align 8
  store i64 %347, ptr %PC, align 8
  %348 = add i64 %347, 4
  store i64 %348, ptr %NEXT_PC, align 8
  %349 = load i64, ptr %RSP, align 8
  %350 = load ptr, ptr %MEMORY, align 8
  %351 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %350, ptr %state, ptr %RSP, i64 %349, i64 40)
  store ptr %351, ptr %MEMORY, align 8
  %352 = load i64, ptr %NEXT_PC, align 8
  store i64 %352, ptr %PC, align 8
  %353 = add i64 %352, 5
  store i64 %353, ptr %NEXT_PC, align 8
  %354 = load i64, ptr %NEXT_PC, align 8
  %355 = add i64 %354, 1963
  %356 = load i64, ptr %NEXT_PC, align 8
  %357 = load ptr, ptr %MEMORY, align 8
  %358 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %357, ptr %state, i64 %355, ptr %NEXT_PC, i64 %356, ptr %RETURN_PC)
  store ptr %358, ptr %MEMORY, align 8
  %359 = load i64, ptr %NEXT_PC, align 8
  store i64 %359, ptr %PC, align 8
  %360 = add i64 %359, 2
  store i64 %360, ptr %NEXT_PC, align 8
  %361 = load i32, ptr %EAX, align 4
  %362 = zext i32 %361 to i64
  %363 = load ptr, ptr %MEMORY, align 8
  %364 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %363, ptr %state, ptr %RCX, i64 %362)
  store ptr %364, ptr %MEMORY, align 8
  %365 = load i64, ptr %NEXT_PC, align 8
  store i64 %365, ptr %PC, align 8
  %366 = add i64 %365, 4
  store i64 %366, ptr %NEXT_PC, align 8
  %367 = load i64, ptr %RSP, align 8
  %368 = load ptr, ptr %MEMORY, align 8
  %369 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %368, ptr %state, ptr %RSP, i64 %367, i64 40)
  store ptr %369, ptr %MEMORY, align 8
  %370 = load i64, ptr %NEXT_PC, align 8
  store i64 %370, ptr %PC, align 8
  %371 = add i64 %370, 5
  store i64 %371, ptr %NEXT_PC, align 8
  %372 = load i64, ptr %NEXT_PC, align 8
  %373 = add i64 %372, 21655
  %374 = load ptr, ptr %MEMORY, align 8
  %375 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %374, ptr %state, i64 %373, ptr %NEXT_PC)
  store ptr %375, ptr %MEMORY, align 8
  %376 = load i64, ptr %NEXT_PC, align 8
  store i64 %376, ptr %PC, align 8
  %377 = add i64 %376, 5
  store i64 %377, ptr %NEXT_PC, align 8
  %378 = load i64, ptr %NEXT_PC, align 8
  %379 = add i64 %378, 21656
  %380 = load ptr, ptr %MEMORY, align 8
  %381 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %380, ptr %state, i64 %379, ptr %NEXT_PC)
  store ptr %381, ptr %MEMORY, align 8
  %382 = load i64, ptr %NEXT_PC, align 8
  store i64 %382, ptr %PC, align 8
  %383 = add i64 %382, 1
  store i64 %383, ptr %NEXT_PC, align 8
  %384 = load ptr, ptr %MEMORY, align 8
  %385 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %384, ptr %state, ptr undef)
  store ptr %385, ptr %MEMORY, align 8
  %386 = load i64, ptr %NEXT_PC, align 8
  store i64 %386, ptr %PC, align 8
  %387 = add i64 %386, 1
  store i64 %387, ptr %NEXT_PC, align 8
  %388 = load ptr, ptr %MEMORY, align 8
  %389 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %388, ptr %state, ptr undef)
  store ptr %389, ptr %MEMORY, align 8
  %390 = load i64, ptr %NEXT_PC, align 8
  store i64 %390, ptr %PC, align 8
  %391 = add i64 %390, 1
  store i64 %391, ptr %NEXT_PC, align 8
  %392 = load ptr, ptr %MEMORY, align 8
  %393 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %392, ptr %state, ptr undef)
  store ptr %393, ptr %MEMORY, align 8
  %394 = load i64, ptr %NEXT_PC, align 8
  store i64 %394, ptr %PC, align 8
  %395 = add i64 %394, 2
  store i64 %395, ptr %NEXT_PC, align 8
  %396 = load i64, ptr %RBX, align 8
  %397 = load ptr, ptr %MEMORY, align 8
  %398 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %397, ptr %state, i64 %396)
  store ptr %398, ptr %MEMORY, align 8
  %399 = load i64, ptr %NEXT_PC, align 8
  store i64 %399, ptr %PC, align 8
  %400 = add i64 %399, 4
  store i64 %400, ptr %NEXT_PC, align 8
  %401 = load i64, ptr %RSP, align 8
  %402 = load ptr, ptr %MEMORY, align 8
  %403 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %402, ptr %state, ptr %RSP, i64 %401, i64 32)
  store ptr %403, ptr %MEMORY, align 8
  %404 = load i64, ptr %NEXT_PC, align 8
  store i64 %404, ptr %PC, align 8
  %405 = add i64 %404, 5
  store i64 %405, ptr %NEXT_PC, align 8
  %406 = load i64, ptr %NEXT_PC, align 8
  %407 = add i64 %406, 2293
  %408 = load i64, ptr %NEXT_PC, align 8
  %409 = load ptr, ptr %MEMORY, align 8
  %410 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %409, ptr %state, i64 %407, ptr %NEXT_PC, i64 %408, ptr %RETURN_PC)
  store ptr %410, ptr %MEMORY, align 8
  %411 = load i64, ptr %NEXT_PC, align 8
  store i64 %411, ptr %PC, align 8
  %412 = add i64 %411, 3
  store i64 %412, ptr %NEXT_PC, align 8
  %413 = load i16, ptr %AX, align 2
  %414 = zext i16 %413 to i64
  %415 = load ptr, ptr %MEMORY, align 8
  %416 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %415, ptr %state, ptr %RBX, i64 %414)
  store ptr %416, ptr %MEMORY, align 8
  %417 = load i64, ptr %NEXT_PC, align 8
  store i64 %417, ptr %PC, align 8
  %418 = add i64 %417, 5
  store i64 %418, ptr %NEXT_PC, align 8
  %419 = load i64, ptr %NEXT_PC, align 8
  %420 = add i64 %419, 21640
  %421 = load i64, ptr %NEXT_PC, align 8
  %422 = load ptr, ptr %MEMORY, align 8
  %423 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %422, ptr %state, i64 %420, ptr %NEXT_PC, i64 %421, ptr %RETURN_PC)
  store ptr %423, ptr %MEMORY, align 8
  %424 = load i64, ptr %NEXT_PC, align 8
  store i64 %424, ptr %PC, align 8
  %425 = add i64 %424, 3
  store i64 %425, ptr %NEXT_PC, align 8
  %426 = load i64, ptr %RAX, align 8
  %427 = load ptr, ptr %MEMORY, align 8
  %428 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %427, ptr %state, ptr %R8, i64 %426)
  store ptr %428, ptr %MEMORY, align 8
  %429 = load i64, ptr %NEXT_PC, align 8
  store i64 %429, ptr %PC, align 8
  %430 = add i64 %429, 7
  store i64 %430, ptr %NEXT_PC, align 8
  %431 = load i64, ptr %NEXT_PC, align 8
  %432 = sub i64 %431, 33002637
  %433 = load ptr, ptr %MEMORY, align 8
  %434 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %433, ptr %state, ptr %RCX, i64 %432)
  store ptr %434, ptr %MEMORY, align 8
  %435 = load i64, ptr %NEXT_PC, align 8
  store i64 %435, ptr %PC, align 8
  %436 = add i64 %435, 3
  store i64 %436, ptr %NEXT_PC, align 8
  %437 = load i32, ptr %EBX, align 4
  %438 = zext i32 %437 to i64
  %439 = load ptr, ptr %MEMORY, align 8
  %440 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %439, ptr %state, ptr %R9, i64 %438)
  store ptr %440, ptr %MEMORY, align 8
  %441 = load i64, ptr %NEXT_PC, align 8
  store i64 %441, ptr %PC, align 8
  %442 = add i64 %441, 2
  store i64 %442, ptr %NEXT_PC, align 8
  %443 = load i64, ptr %RDX, align 8
  %444 = load i32, ptr %EDX, align 4
  %445 = zext i32 %444 to i64
  %446 = load ptr, ptr %MEMORY, align 8
  %447 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %446, ptr %state, ptr %RDX, i64 %443, i64 %445)
  store ptr %447, ptr %MEMORY, align 8
  %448 = load i64, ptr %NEXT_PC, align 8
  store i64 %448, ptr %PC, align 8
  %449 = add i64 %448, 4
  store i64 %449, ptr %NEXT_PC, align 8
  %450 = load i64, ptr %RSP, align 8
  %451 = load ptr, ptr %MEMORY, align 8
  %452 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %451, ptr %state, ptr %RSP, i64 %450, i64 32)
  store ptr %452, ptr %MEMORY, align 8
  %453 = load i64, ptr %NEXT_PC, align 8
  store i64 %453, ptr %PC, align 8
  %454 = add i64 %453, 1
  store i64 %454, ptr %NEXT_PC, align 8
  %455 = load ptr, ptr %MEMORY, align 8
  %456 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %455, ptr %state, ptr %RBX)
  store ptr %456, ptr %MEMORY, align 8
  %457 = load i64, ptr %NEXT_PC, align 8
  store i64 %457, ptr %PC, align 8
  %458 = add i64 %457, 5
  store i64 %458, ptr %NEXT_PC, align 8
  %459 = load i64, ptr %NEXT_PC, align 8
  %460 = sub i64 %459, 30702028
  %461 = load ptr, ptr %MEMORY, align 8
  %462 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %461, ptr %state, i64 %460, ptr %NEXT_PC)
  store ptr %462, ptr %MEMORY, align 8
  ret ptr %memory
}

attributes #0 = { noduplicate noinline nounwind optnone "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { alwaysinline mustprogress nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #3 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #4 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }

!llvm.ident = !{!0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3, !4}

!0 = !{!"clang version 18.1.8"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"base.helper.semantics"}
!6 = !{[4 x i8] c"RDI\00"}
!7 = !{[4 x i8] c"RSP\00"}
!8 = !{[3 x i8] c"CL\00"}
!9 = !{[4 x i8] c"DIL\00"}
!10 = !{[4 x i8] c"EAX\00"}
!11 = !{[4 x i8] c"EDX\00"}
!12 = !{[4 x i8] c"RDX\00"}
!13 = !{[4 x i8] c"EBX\00"}
!14 = !{[3 x i8] c"R9\00"}
!15 = !{[3 x i8] c"R8\00"}
!16 = !{[3 x i8] c"AX\00"}
!17 = !{[3 x i8] c"AL\00"}
!18 = !{[4 x i8] c"RCX\00"}
!19 = !{[4 x i8] c"RAX\00"}
!20 = !{[4 x i8] c"RBX\00"}
!21 = !{[3 x i8] c"PC\00"}
