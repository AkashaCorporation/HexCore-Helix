; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: wwzRetailEgs.exe
; Address: 0x1419b3460
; Size: 2250 bytes
; Architecture: amd64
; Generated: 2026-03-05T03:17:35.658Z
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
declare !remill.function.type !5 dso_local i32 @__remill_read_memory_32(ptr noundef, i64 noundef) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local ptr @__remill_write_memory_32(ptr noundef, i64 noundef, i32 noundef) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local i64 @__remill_read_memory_64(ptr noundef, i64 noundef) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local ptr @__remill_write_memory_64(ptr noundef, i64 noundef, i64 noundef) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i8 @__remill_undefined_8() #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14SETZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly) #3

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i64, ptr nocapture writeonly, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i64, ptr nocapture writeonly, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_sle(i1 noundef zeroext) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_neq(i1 noundef zeroext) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_eq(i1 noundef zeroext) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15CMOVZI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture, i64) #2

declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_slt(i1 noundef zeroext) #4

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture readnone) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12ORI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13XORI3RnWIhE2RnIhLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnItEEEEP6MemoryS4_R5StateDpT_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, i64) #6

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnIjEEEEP6MemoryS4_R5StateDpT_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, i64) #6

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, ptr nocapture writeonly) #5

define ptr @lifted_5395657824(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
bb_0:
  %CL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !6
  %ECX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !7
  %R9 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 19, i32 0, i32 0, !remill_register !8
  %EBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !9
  %EDI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 11, i32 0, i32 0, !remill_register !10
  %EDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !11
  %RSI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 9, i32 0, i32 0, !remill_register !12
  %RBP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 15, i32 0, i32 0, !remill_register !13
  %RBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !14
  %AL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !15
  %RDI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 11, i32 0, i32 0, !remill_register !16
  %R9D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 19, i32 0, i32 0, !remill_register !17
  %R8 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 17, i32 0, i32 0, !remill_register !18
  %RDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !19
  %EAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !20
  %RCX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !21
  %RSP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 13, i32 0, i32 0, !remill_register !22
  %RAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !23
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
  %PC = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 33, i32 0, i32 0, !remill_register !24
  %CSBASE = alloca i64, align 8
  store i64 0, ptr %CSBASE, align 8
  %SSBASE = alloca i64, align 8
  store i64 0, ptr %SSBASE, align 8
  %ESBASE = alloca i64, align 8
  store i64 0, ptr %ESBASE, align 8
  %DSBASE = alloca i64, align 8
  store i64 0, ptr %DSBASE, align 8
  %v1 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1, ptr %PC, align 8
  %v2 = add i64 %v1, 4
  store i64 %v2, ptr %NEXT_PC, align 8
  %v3 = load i64, ptr %RSP, align 8
  %v4 = add i64 %v3, 48
  %v5 = load ptr, ptr %MEMORY, align 8
  %v6 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5, ptr %state, ptr %RAX, i64 %v4)
  store ptr %v6, ptr %MEMORY, align 8
  %v7 = load i64, ptr %NEXT_PC, align 8
  store i64 %v7, ptr %PC, align 8
  %v8 = add i64 %v7, 3
  store i64 %v8, ptr %NEXT_PC, align 8
  %v9 = load i64, ptr %RCX, align 8
  %v10 = add i64 %v9, 20
  %v11 = load i32, ptr %EAX, align 4
  %v12 = zext i32 %v11 to i64
  %v13 = load ptr, ptr %MEMORY, align 8
  %v14 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v13, ptr %state, i64 %v10, i64 %v12)
  store ptr %v14, ptr %MEMORY, align 8
  %v15 = load i64, ptr %NEXT_PC, align 8
  store i64 %v15, ptr %PC, align 8
  %v16 = add i64 %v15, 5
  store i64 %v16, ptr %NEXT_PC, align 8
  %v17 = load i64, ptr %RSP, align 8
  %v18 = add i64 %v17, 56
  %v19 = load ptr, ptr %MEMORY, align 8
  %v20 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v19, ptr %state, ptr %RAX, i64 %v18)
  store ptr %v20, ptr %MEMORY, align 8
  %v21 = load i64, ptr %NEXT_PC, align 8
  store i64 %v21, ptr %PC, align 8
  %v22 = add i64 %v21, 4
  store i64 %v22, ptr %NEXT_PC, align 8
  %v23 = load i64, ptr %RCX, align 8
  %v24 = add i64 %v23, 24
  %v25 = load i64, ptr %RAX, align 8
  %v26 = load ptr, ptr %MEMORY, align 8
  %v27 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v26, ptr %state, i64 %v24, i64 %v25)
  store ptr %v27, ptr %MEMORY, align 8
  %v28 = load i64, ptr %NEXT_PC, align 8
  store i64 %v28, ptr %PC, align 8
  %v29 = add i64 %v28, 4
  store i64 %v29, ptr %NEXT_PC, align 8
  %v30 = load i64, ptr %RSP, align 8
  %v31 = add i64 %v30, 64
  %v32 = load ptr, ptr %MEMORY, align 8
  %v33 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v32, ptr %state, ptr %RAX, i64 %v31)
  store ptr %v33, ptr %MEMORY, align 8
  %v34 = load i64, ptr %NEXT_PC, align 8
  store i64 %v34, ptr %PC, align 8
  %v35 = add i64 %v34, 3
  store i64 %v35, ptr %NEXT_PC, align 8
  %v36 = load i64, ptr %RCX, align 8
  %v37 = add i64 %v36, 32
  %v38 = load i32, ptr %EAX, align 4
  %v39 = zext i32 %v38 to i64
  %v40 = load ptr, ptr %MEMORY, align 8
  %v41 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v40, ptr %state, i64 %v37, i64 %v39)
  store ptr %v41, ptr %MEMORY, align 8
  %v42 = load i64, ptr %NEXT_PC, align 8
  store i64 %v42, ptr %PC, align 8
  %v43 = add i64 %v42, 5
  store i64 %v43, ptr %NEXT_PC, align 8
  %v44 = load i64, ptr %RSP, align 8
  %v45 = add i64 %v44, 72
  %v46 = load ptr, ptr %MEMORY, align 8
  %v47 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v46, ptr %state, ptr %RAX, i64 %v45)
  store ptr %v47, ptr %MEMORY, align 8
  %v48 = load i64, ptr %NEXT_PC, align 8
  store i64 %v48, ptr %PC, align 8
  %v49 = add i64 %v48, 4
  store i64 %v49, ptr %NEXT_PC, align 8
  %v50 = load i64, ptr %RCX, align 8
  %v51 = add i64 %v50, 40
  %v52 = load i64, ptr %RAX, align 8
  %v53 = load ptr, ptr %MEMORY, align 8
  %v54 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v53, ptr %state, i64 %v51, i64 %v52)
  store ptr %v54, ptr %MEMORY, align 8
  %v55 = load i64, ptr %NEXT_PC, align 8
  store i64 %v55, ptr %PC, align 8
  %v56 = add i64 %v55, 4
  store i64 %v56, ptr %NEXT_PC, align 8
  %v57 = load i64, ptr %RSP, align 8
  %v58 = add i64 %v57, 80
  %v59 = load ptr, ptr %MEMORY, align 8
  %v60 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v59, ptr %state, ptr %RAX, i64 %v58)
  store ptr %v60, ptr %MEMORY, align 8
  %v61 = load i64, ptr %NEXT_PC, align 8
  store i64 %v61, ptr %PC, align 8
  %v62 = add i64 %v61, 3
  store i64 %v62, ptr %NEXT_PC, align 8
  %v63 = load i64, ptr %RCX, align 8
  %v64 = add i64 %v63, 48
  %v65 = load i32, ptr %EAX, align 4
  %v66 = zext i32 %v65 to i64
  %v67 = load ptr, ptr %MEMORY, align 8
  %v68 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v67, ptr %state, i64 %v64, i64 %v66)
  store ptr %v68, ptr %MEMORY, align 8
  %v69 = load i64, ptr %NEXT_PC, align 8
  store i64 %v69, ptr %PC, align 8
  %v70 = add i64 %v69, 5
  store i64 %v70, ptr %NEXT_PC, align 8
  %v71 = load i64, ptr %RSP, align 8
  %v72 = add i64 %v71, 88
  %v73 = load ptr, ptr %MEMORY, align 8
  %v74 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v73, ptr %state, ptr %RAX, i64 %v72)
  store ptr %v74, ptr %MEMORY, align 8
  %v75 = load i64, ptr %NEXT_PC, align 8
  store i64 %v75, ptr %PC, align 8
  %v76 = add i64 %v75, 4
  store i64 %v76, ptr %NEXT_PC, align 8
  %v77 = load i64, ptr %RCX, align 8
  %v78 = add i64 %v77, 56
  %v79 = load i64, ptr %RAX, align 8
  %v80 = load ptr, ptr %MEMORY, align 8
  %v81 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v80, ptr %state, i64 %v78, i64 %v79)
  store ptr %v81, ptr %MEMORY, align 8
  %v82 = load i64, ptr %NEXT_PC, align 8
  store i64 %v82, ptr %PC, align 8
  %v83 = add i64 %v82, 5
  store i64 %v83, ptr %NEXT_PC, align 8
  %v84 = load i64, ptr %RSP, align 8
  %v85 = add i64 %v84, 96
  %v86 = load ptr, ptr %MEMORY, align 8
  %v87 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v86, ptr %state, ptr %RAX, i64 %v85)
  store ptr %v87, ptr %MEMORY, align 8
  %v88 = load i64, ptr %NEXT_PC, align 8
  store i64 %v88, ptr %PC, align 8
  %v89 = add i64 %v88, 4
  store i64 %v89, ptr %NEXT_PC, align 8
  %v90 = load i64, ptr %RCX, align 8
  %v91 = add i64 %v90, 64
  %v92 = load i64, ptr %RAX, align 8
  %v93 = load ptr, ptr %MEMORY, align 8
  %v94 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v93, ptr %state, i64 %v91, i64 %v92)
  store ptr %v94, ptr %MEMORY, align 8
  %v95 = load i64, ptr %NEXT_PC, align 8
  store i64 %v95, ptr %PC, align 8
  %v96 = add i64 %v95, 4
  store i64 %v96, ptr %NEXT_PC, align 8
  %v97 = load i64, ptr %RSP, align 8
  %v98 = add i64 %v97, 104
  %v99 = load ptr, ptr %MEMORY, align 8
  %v100 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v99, ptr %state, ptr %RAX, i64 %v98)
  store ptr %v100, ptr %MEMORY, align 8
  %v101 = load i64, ptr %NEXT_PC, align 8
  store i64 %v101, ptr %PC, align 8
  %v102 = add i64 %v101, 3
  store i64 %v102, ptr %NEXT_PC, align 8
  %v103 = load i64, ptr %RCX, align 8
  %v104 = load i64, ptr %RDX, align 8
  %v105 = load ptr, ptr %MEMORY, align 8
  %v106 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v105, ptr %state, i64 %v103, i64 %v104)
  store ptr %v106, ptr %MEMORY, align 8
  %v107 = load i64, ptr %NEXT_PC, align 8
  store i64 %v107, ptr %PC, align 8
  %v108 = add i64 %v107, 4
  store i64 %v108, ptr %NEXT_PC, align 8
  %v109 = load i64, ptr %RCX, align 8
  %v110 = add i64 %v109, 8
  %v111 = load i64, ptr %R8, align 8
  %v112 = load ptr, ptr %MEMORY, align 8
  %v113 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v112, ptr %state, i64 %v110, i64 %v111)
  store ptr %v113, ptr %MEMORY, align 8
  %v114 = load i64, ptr %NEXT_PC, align 8
  store i64 %v114, ptr %PC, align 8
  %v115 = add i64 %v114, 4
  store i64 %v115, ptr %NEXT_PC, align 8
  %v116 = load i64, ptr %RCX, align 8
  %v117 = add i64 %v116, 16
  %v118 = load i32, ptr %R9D, align 4
  %v119 = zext i32 %v118 to i64
  %v120 = load ptr, ptr %MEMORY, align 8
  %v121 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v120, ptr %state, i64 %v117, i64 %v119)
  store ptr %v121, ptr %MEMORY, align 8
  %v122 = load i64, ptr %NEXT_PC, align 8
  store i64 %v122, ptr %PC, align 8
  %v123 = add i64 %v122, 3
  store i64 %v123, ptr %NEXT_PC, align 8
  %v124 = load i64, ptr %RCX, align 8
  %v125 = add i64 %v124, 72
  %v126 = load i32, ptr %EAX, align 4
  %v127 = zext i32 %v126 to i64
  %v128 = load ptr, ptr %MEMORY, align 8
  %v129 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v128, ptr %state, i64 %v125, i64 %v127)
  store ptr %v129, ptr %MEMORY, align 8
  %v130 = load i64, ptr %NEXT_PC, align 8
  store i64 %v130, ptr %PC, align 8
  %v131 = add i64 %v130, 4
  store i64 %v131, ptr %NEXT_PC, align 8
  %v132 = load i64, ptr %RSP, align 8
  %v133 = add i64 %v132, 112
  %v134 = load ptr, ptr %MEMORY, align 8
  %v135 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v134, ptr %state, ptr %RAX, i64 %v133)
  store ptr %v135, ptr %MEMORY, align 8
  %v136 = load i64, ptr %NEXT_PC, align 8
  store i64 %v136, ptr %PC, align 8
  %v137 = add i64 %v136, 3
  store i64 %v137, ptr %NEXT_PC, align 8
  %v138 = load i64, ptr %RCX, align 8
  %v139 = add i64 %v138, 76
  %v140 = load i32, ptr %EAX, align 4
  %v141 = zext i32 %v140 to i64
  %v142 = load ptr, ptr %MEMORY, align 8
  %v143 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v142, ptr %state, i64 %v139, i64 %v141)
  store ptr %v143, ptr %MEMORY, align 8
  %v144 = load i64, ptr %NEXT_PC, align 8
  store i64 %v144, ptr %PC, align 8
  %v145 = add i64 %v144, 3
  store i64 %v145, ptr %NEXT_PC, align 8
  %v146 = load i64, ptr %RCX, align 8
  %v147 = load ptr, ptr %MEMORY, align 8
  %v148 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v147, ptr %state, ptr %RAX, i64 %v146)
  store ptr %v148, ptr %MEMORY, align 8
  %v149 = load i64, ptr %NEXT_PC, align 8
  store i64 %v149, ptr %PC, align 8
  %v150 = add i64 %v149, 1
  store i64 %v150, ptr %NEXT_PC, align 8
  %v151 = load ptr, ptr %MEMORY, align 8
  %v152 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v151, ptr %state, ptr %NEXT_PC)
  store ptr %v152, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395657910:                                    ; No predecessors!
  %v153 = load i64, ptr %NEXT_PC, align 8
  store i64 %v153, ptr %PC, align 8
  %v154 = add i64 %v153, 1
  store i64 %v154, ptr %NEXT_PC, align 8
  %v155 = load ptr, ptr %MEMORY, align 8
  %v156 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v155, ptr %state, ptr undef)
  store ptr %v156, ptr %MEMORY, align 8
  %v157 = load i64, ptr %NEXT_PC, align 8
  store i64 %v157, ptr %PC, align 8
  %v158 = add i64 %v157, 1
  store i64 %v158, ptr %NEXT_PC, align 8
  %v159 = load ptr, ptr %MEMORY, align 8
  %v160 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v159, ptr %state, ptr undef)
  store ptr %v160, ptr %MEMORY, align 8
  %v161 = load i64, ptr %NEXT_PC, align 8
  store i64 %v161, ptr %PC, align 8
  %v162 = add i64 %v161, 1
  store i64 %v162, ptr %NEXT_PC, align 8
  %v163 = load ptr, ptr %MEMORY, align 8
  %v164 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v163, ptr %state, ptr undef)
  store ptr %v164, ptr %MEMORY, align 8
  %v165 = load i64, ptr %NEXT_PC, align 8
  store i64 %v165, ptr %PC, align 8
  %v166 = add i64 %v165, 1
  store i64 %v166, ptr %NEXT_PC, align 8
  %v167 = load ptr, ptr %MEMORY, align 8
  %v168 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v167, ptr %state, ptr undef)
  store ptr %v168, ptr %MEMORY, align 8
  %v169 = load i64, ptr %NEXT_PC, align 8
  store i64 %v169, ptr %PC, align 8
  %v170 = add i64 %v169, 1
  store i64 %v170, ptr %NEXT_PC, align 8
  %v171 = load ptr, ptr %MEMORY, align 8
  %v172 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v171, ptr %state, ptr undef)
  store ptr %v172, ptr %MEMORY, align 8
  %v173 = load i64, ptr %NEXT_PC, align 8
  store i64 %v173, ptr %PC, align 8
  %v174 = add i64 %v173, 1
  store i64 %v174, ptr %NEXT_PC, align 8
  %v175 = load ptr, ptr %MEMORY, align 8
  %v176 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v175, ptr %state, ptr undef)
  store ptr %v176, ptr %MEMORY, align 8
  %v177 = load i64, ptr %NEXT_PC, align 8
  store i64 %v177, ptr %PC, align 8
  %v178 = add i64 %v177, 1
  store i64 %v178, ptr %NEXT_PC, align 8
  %v179 = load ptr, ptr %MEMORY, align 8
  %v180 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v179, ptr %state, ptr undef)
  store ptr %v180, ptr %MEMORY, align 8
  %v181 = load i64, ptr %NEXT_PC, align 8
  store i64 %v181, ptr %PC, align 8
  %v182 = add i64 %v181, 1
  store i64 %v182, ptr %NEXT_PC, align 8
  %v183 = load ptr, ptr %MEMORY, align 8
  %v184 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v183, ptr %state, ptr undef)
  store ptr %v184, ptr %MEMORY, align 8
  %v185 = load i64, ptr %NEXT_PC, align 8
  store i64 %v185, ptr %PC, align 8
  %v186 = add i64 %v185, 1
  store i64 %v186, ptr %NEXT_PC, align 8
  %v187 = load ptr, ptr %MEMORY, align 8
  %v188 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v187, ptr %state, ptr undef)
  store ptr %v188, ptr %MEMORY, align 8
  %v189 = load i64, ptr %NEXT_PC, align 8
  store i64 %v189, ptr %PC, align 8
  %v190 = add i64 %v189, 1
  store i64 %v190, ptr %NEXT_PC, align 8
  %v191 = load ptr, ptr %MEMORY, align 8
  %v192 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v191, ptr %state, ptr undef)
  store ptr %v192, ptr %MEMORY, align 8
  %v193 = load i64, ptr %NEXT_PC, align 8
  store i64 %v193, ptr %PC, align 8
  %v194 = add i64 %v193, 3
  store i64 %v194, ptr %NEXT_PC, align 8
  %v195 = load i64, ptr %RCX, align 8
  %v196 = load ptr, ptr %MEMORY, align 8
  %v197 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v196, ptr %state, ptr %RAX, i64 %v195)
  store ptr %v197, ptr %MEMORY, align 8
  %v198 = load i64, ptr %NEXT_PC, align 8
  store i64 %v198, ptr %PC, align 8
  %v199 = add i64 %v198, 1
  store i64 %v199, ptr %NEXT_PC, align 8
  %v200 = load ptr, ptr %MEMORY, align 8
  %v201 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v200, ptr %state, ptr %NEXT_PC)
  store ptr %v201, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395657924:                                    ; No predecessors!
  %v202 = load i64, ptr %NEXT_PC, align 8
  store i64 %v202, ptr %PC, align 8
  %v203 = add i64 %v202, 1
  store i64 %v203, ptr %NEXT_PC, align 8
  %v204 = load ptr, ptr %MEMORY, align 8
  %v205 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v204, ptr %state, ptr undef)
  store ptr %v205, ptr %MEMORY, align 8
  %v206 = load i64, ptr %NEXT_PC, align 8
  store i64 %v206, ptr %PC, align 8
  %v207 = add i64 %v206, 1
  store i64 %v207, ptr %NEXT_PC, align 8
  %v208 = load ptr, ptr %MEMORY, align 8
  %v209 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v208, ptr %state, ptr undef)
  store ptr %v209, ptr %MEMORY, align 8
  %v210 = load i64, ptr %NEXT_PC, align 8
  store i64 %v210, ptr %PC, align 8
  %v211 = add i64 %v210, 1
  store i64 %v211, ptr %NEXT_PC, align 8
  %v212 = load ptr, ptr %MEMORY, align 8
  %v213 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v212, ptr %state, ptr undef)
  store ptr %v213, ptr %MEMORY, align 8
  %v214 = load i64, ptr %NEXT_PC, align 8
  store i64 %v214, ptr %PC, align 8
  %v215 = add i64 %v214, 1
  store i64 %v215, ptr %NEXT_PC, align 8
  %v216 = load ptr, ptr %MEMORY, align 8
  %v217 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v216, ptr %state, ptr undef)
  store ptr %v217, ptr %MEMORY, align 8
  %v218 = load i64, ptr %NEXT_PC, align 8
  store i64 %v218, ptr %PC, align 8
  %v219 = add i64 %v218, 1
  store i64 %v219, ptr %NEXT_PC, align 8
  %v220 = load ptr, ptr %MEMORY, align 8
  %v221 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v220, ptr %state, ptr undef)
  store ptr %v221, ptr %MEMORY, align 8
  %v222 = load i64, ptr %NEXT_PC, align 8
  store i64 %v222, ptr %PC, align 8
  %v223 = add i64 %v222, 1
  store i64 %v223, ptr %NEXT_PC, align 8
  %v224 = load ptr, ptr %MEMORY, align 8
  %v225 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v224, ptr %state, ptr undef)
  store ptr %v225, ptr %MEMORY, align 8
  %v226 = load i64, ptr %NEXT_PC, align 8
  store i64 %v226, ptr %PC, align 8
  %v227 = add i64 %v226, 1
  store i64 %v227, ptr %NEXT_PC, align 8
  %v228 = load ptr, ptr %MEMORY, align 8
  %v229 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v228, ptr %state, ptr undef)
  store ptr %v229, ptr %MEMORY, align 8
  %v230 = load i64, ptr %NEXT_PC, align 8
  store i64 %v230, ptr %PC, align 8
  %v231 = add i64 %v230, 1
  store i64 %v231, ptr %NEXT_PC, align 8
  %v232 = load ptr, ptr %MEMORY, align 8
  %v233 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v232, ptr %state, ptr undef)
  store ptr %v233, ptr %MEMORY, align 8
  %v234 = load i64, ptr %NEXT_PC, align 8
  store i64 %v234, ptr %PC, align 8
  %v235 = add i64 %v234, 1
  store i64 %v235, ptr %NEXT_PC, align 8
  %v236 = load ptr, ptr %MEMORY, align 8
  %v237 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v236, ptr %state, ptr undef)
  store ptr %v237, ptr %MEMORY, align 8
  %v238 = load i64, ptr %NEXT_PC, align 8
  store i64 %v238, ptr %PC, align 8
  %v239 = add i64 %v238, 1
  store i64 %v239, ptr %NEXT_PC, align 8
  %v240 = load ptr, ptr %MEMORY, align 8
  %v241 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v240, ptr %state, ptr undef)
  store ptr %v241, ptr %MEMORY, align 8
  %v242 = load i64, ptr %NEXT_PC, align 8
  store i64 %v242, ptr %PC, align 8
  %v243 = add i64 %v242, 1
  store i64 %v243, ptr %NEXT_PC, align 8
  %v244 = load ptr, ptr %MEMORY, align 8
  %v245 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v244, ptr %state, ptr undef)
  store ptr %v245, ptr %MEMORY, align 8
  %v246 = load i64, ptr %NEXT_PC, align 8
  store i64 %v246, ptr %PC, align 8
  %v247 = add i64 %v246, 1
  store i64 %v247, ptr %NEXT_PC, align 8
  %v248 = load ptr, ptr %MEMORY, align 8
  %v249 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v248, ptr %state, ptr undef)
  store ptr %v249, ptr %MEMORY, align 8
  %v250 = load i64, ptr %NEXT_PC, align 8
  store i64 %v250, ptr %PC, align 8
  %v251 = add i64 %v250, 2
  store i64 %v251, ptr %NEXT_PC, align 8
  %v252 = load i64, ptr %RDI, align 8
  %v253 = load ptr, ptr %MEMORY, align 8
  %v254 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v253, ptr %state, i64 %v252)
  store ptr %v254, ptr %MEMORY, align 8
  %v255 = load i64, ptr %NEXT_PC, align 8
  store i64 %v255, ptr %PC, align 8
  %v256 = add i64 %v255, 4
  store i64 %v256, ptr %NEXT_PC, align 8
  %v257 = load i64, ptr %RSP, align 8
  %v258 = load ptr, ptr %MEMORY, align 8
  %v259 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v258, ptr %state, ptr %RSP, i64 %v257, i64 32)
  store ptr %v259, ptr %MEMORY, align 8
  %v260 = load i64, ptr %NEXT_PC, align 8
  store i64 %v260, ptr %PC, align 8
  %v261 = add i64 %v260, 3
  store i64 %v261, ptr %NEXT_PC, align 8
  %v262 = load i64, ptr %RCX, align 8
  %v263 = load ptr, ptr %MEMORY, align 8
  %v264 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v263, ptr %state, ptr %RDI, i64 %v262)
  store ptr %v264, ptr %MEMORY, align 8
  %v265 = load i64, ptr %NEXT_PC, align 8
  store i64 %v265, ptr %PC, align 8
  %v266 = add i64 %v265, 3
  store i64 %v266, ptr %NEXT_PC, align 8
  %v267 = load i64, ptr %RDX, align 8
  %v268 = load i64, ptr %RDX, align 8
  %v269 = load ptr, ptr %MEMORY, align 8
  %v270 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v269, ptr %state, i64 %v267, i64 %v268)
  store ptr %v270, ptr %MEMORY, align 8
  %v271 = load i64, ptr %NEXT_PC, align 8
  store i64 %v271, ptr %PC, align 8
  %v272 = add i64 %v271, 2
  store i64 %v272, ptr %NEXT_PC, align 8
  %v273 = load i64, ptr %NEXT_PC, align 8
  %v274 = add i64 %v273, 8
  %v275 = load i64, ptr %NEXT_PC, align 8
  %v276 = load ptr, ptr %MEMORY, align 8
  %v277 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v276, ptr %state, ptr %BRANCH_TAKEN, i64 %v274, i64 %v275, ptr %NEXT_PC)
  store ptr %v277, ptr %MEMORY, align 8
  br i1 true, label %bb_5395657958, label %bb_5395657950

bb_5395657950:                                    ; preds = %bb_5395657924
  %v278 = load i64, ptr %NEXT_PC, align 8
  store i64 %v278, ptr %PC, align 8
  %v279 = add i64 %v278, 2
  store i64 %v279, ptr %NEXT_PC, align 8
  %v280 = load i8, ptr %AL, align 1
  %v281 = zext i8 %v280 to i64
  %v282 = load i8, ptr %AL, align 1
  %v283 = zext i8 %v282 to i64
  %v284 = load ptr, ptr %MEMORY, align 8
  %v285 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWIhE2RnIhLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v284, ptr %state, ptr %AL, i64 %v281, i64 %v283)
  store ptr %v285, ptr %MEMORY, align 8
  %v286 = load i64, ptr %NEXT_PC, align 8
  store i64 %v286, ptr %PC, align 8
  %v287 = add i64 %v286, 4
  store i64 %v287, ptr %NEXT_PC, align 8
  %v288 = load i64, ptr %RSP, align 8
  %v289 = load ptr, ptr %MEMORY, align 8
  %v290 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v289, ptr %state, ptr %RSP, i64 %v288, i64 32)
  store ptr %v290, ptr %MEMORY, align 8
  %v291 = load i64, ptr %NEXT_PC, align 8
  store i64 %v291, ptr %PC, align 8
  %v292 = add i64 %v291, 1
  store i64 %v292, ptr %NEXT_PC, align 8
  %v293 = load ptr, ptr %MEMORY, align 8
  %v294 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v293, ptr %state, ptr %RDI)
  store ptr %v294, ptr %MEMORY, align 8
  %v295 = load i64, ptr %NEXT_PC, align 8
  store i64 %v295, ptr %PC, align 8
  %v296 = add i64 %v295, 1
  store i64 %v296, ptr %NEXT_PC, align 8
  %v297 = load ptr, ptr %MEMORY, align 8
  %v298 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v297, ptr %state, ptr %NEXT_PC)
  store ptr %v298, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395657958:                                    ; preds = %bb_5395657924
  %v299 = load i64, ptr %NEXT_PC, align 8
  store i64 %v299, ptr %PC, align 8
  %v300 = add i64 %v299, 3
  store i64 %v300, ptr %NEXT_PC, align 8
  %v301 = load i64, ptr %RDI, align 8
  %v302 = load i64, ptr %RDX, align 8
  %v303 = load ptr, ptr %MEMORY, align 8
  %v304 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v303, ptr %state, i64 %v301, i64 %v302)
  store ptr %v304, ptr %MEMORY, align 8
  %v305 = load i64, ptr %NEXT_PC, align 8
  store i64 %v305, ptr %PC, align 8
  %v306 = add i64 %v305, 2
  store i64 %v306, ptr %NEXT_PC, align 8
  %v307 = load i64, ptr %NEXT_PC, align 8
  %v308 = add i64 %v307, 52
  %v309 = load i64, ptr %NEXT_PC, align 8
  %v310 = load ptr, ptr %MEMORY, align 8
  %v311 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v310, ptr %state, ptr %BRANCH_TAKEN, i64 %v308, i64 %v309, ptr %NEXT_PC)
  store ptr %v311, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658015, label %bb_5395657963

bb_5395657963:                                    ; preds = %bb_5395657958
  %v312 = load i64, ptr %NEXT_PC, align 8
  store i64 %v312, ptr %PC, align 8
  %v313 = add i64 %v312, 3
  store i64 %v313, ptr %NEXT_PC, align 8
  %v314 = load i64, ptr %RDX, align 8
  %v315 = load ptr, ptr %MEMORY, align 8
  %v316 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v315, ptr %state, ptr %RCX, i64 %v314)
  store ptr %v316, ptr %MEMORY, align 8
  %v317 = load i64, ptr %NEXT_PC, align 8
  store i64 %v317, ptr %PC, align 8
  %v318 = add i64 %v317, 5
  store i64 %v318, ptr %NEXT_PC, align 8
  %v319 = load i64, ptr %RSP, align 8
  %v320 = add i64 %v319, 48
  %v321 = load i64, ptr %RBX, align 8
  %v322 = load ptr, ptr %MEMORY, align 8
  %v323 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v322, ptr %state, i64 %v320, i64 %v321)
  store ptr %v323, ptr %MEMORY, align 8
  %v324 = load i64, ptr %NEXT_PC, align 8
  store i64 %v324, ptr %PC, align 8
  %v325 = add i64 %v324, 5
  store i64 %v325, ptr %NEXT_PC, align 8
  %v326 = load i64, ptr %NEXT_PC, align 8
  %v327 = sub i64 %v326, 56
  %v328 = load i64, ptr %NEXT_PC, align 8
  %v329 = load ptr, ptr %MEMORY, align 8
  %v330 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v329, ptr %state, i64 %v327, ptr %NEXT_PC, i64 %v328, ptr %RETURN_PC)
  store ptr %v330, ptr %MEMORY, align 8
  %v331 = load i64, ptr %NEXT_PC, align 8
  store i64 %v331, ptr %PC, align 8
  %v332 = add i64 %v331, 3
  store i64 %v332, ptr %NEXT_PC, align 8
  %v333 = load i64, ptr %RDI, align 8
  %v334 = load ptr, ptr %MEMORY, align 8
  %v335 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v334, ptr %state, ptr %RCX, i64 %v333)
  store ptr %v335, ptr %MEMORY, align 8
  %v336 = load i64, ptr %NEXT_PC, align 8
  store i64 %v336, ptr %PC, align 8
  %v337 = add i64 %v336, 3
  store i64 %v337, ptr %NEXT_PC, align 8
  %v338 = load i64, ptr %RAX, align 8
  %v339 = load ptr, ptr %MEMORY, align 8
  %v340 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v339, ptr %state, ptr %RBX, i64 %v338)
  store ptr %v340, ptr %MEMORY, align 8
  %v341 = load i64, ptr %NEXT_PC, align 8
  store i64 %v341, ptr %PC, align 8
  %v342 = add i64 %v341, 5
  store i64 %v342, ptr %NEXT_PC, align 8
  %v343 = load i64, ptr %NEXT_PC, align 8
  %v344 = sub i64 %v343, 67
  %v345 = load i64, ptr %NEXT_PC, align 8
  %v346 = load ptr, ptr %MEMORY, align 8
  %v347 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v346, ptr %state, i64 %v344, ptr %NEXT_PC, i64 %v345, ptr %RETURN_PC)
  store ptr %v347, ptr %MEMORY, align 8
  %v348 = load i64, ptr %NEXT_PC, align 8
  store i64 %v348, ptr %PC, align 8
  %v349 = add i64 %v348, 3
  store i64 %v349, ptr %NEXT_PC, align 8
  %v350 = load i64, ptr %RAX, align 8
  %v351 = load ptr, ptr %MEMORY, align 8
  %v352 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v351, ptr %state, ptr %RCX, i64 %v350)
  store ptr %v352, ptr %MEMORY, align 8
  %v353 = load i64, ptr %NEXT_PC, align 8
  store i64 %v353, ptr %PC, align 8
  %v354 = add i64 %v353, 3
  store i64 %v354, ptr %NEXT_PC, align 8
  %v355 = load i64, ptr %RBX, align 8
  %v356 = load ptr, ptr %MEMORY, align 8
  %v357 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v356, ptr %state, ptr %RDX, i64 %v355)
  store ptr %v357, ptr %MEMORY, align 8
  %v358 = load i64, ptr %NEXT_PC, align 8
  store i64 %v358, ptr %PC, align 8
  %v359 = add i64 %v358, 5
  store i64 %v359, ptr %NEXT_PC, align 8
  %v360 = load i64, ptr %NEXT_PC, align 8
  %v361 = add i64 %v360, 46322
  %v362 = load i64, ptr %NEXT_PC, align 8
  %v363 = load ptr, ptr %MEMORY, align 8
  %v364 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v363, ptr %state, i64 %v361, ptr %NEXT_PC, i64 %v362, ptr %RETURN_PC)
  store ptr %v364, ptr %MEMORY, align 8
  %v365 = load i64, ptr %NEXT_PC, align 8
  store i64 %v365, ptr %PC, align 8
  %v366 = add i64 %v365, 5
  store i64 %v366, ptr %NEXT_PC, align 8
  %v367 = load i64, ptr %RSP, align 8
  %v368 = add i64 %v367, 48
  %v369 = load ptr, ptr %MEMORY, align 8
  %v370 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v369, ptr %state, ptr %RBX, i64 %v368)
  store ptr %v370, ptr %MEMORY, align 8
  %v371 = load i64, ptr %NEXT_PC, align 8
  store i64 %v371, ptr %PC, align 8
  %v372 = add i64 %v371, 2
  store i64 %v372, ptr %NEXT_PC, align 8
  %v373 = load i32, ptr %EAX, align 4
  %v374 = zext i32 %v373 to i64
  %v375 = load i32, ptr %EAX, align 4
  %v376 = zext i32 %v375 to i64
  %v377 = load ptr, ptr %MEMORY, align 8
  %v378 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v377, ptr %state, i64 %v374, i64 %v376)
  store ptr %v378, ptr %MEMORY, align 8
  %v379 = load i64, ptr %NEXT_PC, align 8
  store i64 %v379, ptr %PC, align 8
  %v380 = add i64 %v379, 2
  store i64 %v380, ptr %NEXT_PC, align 8
  %v381 = load i64, ptr %NEXT_PC, align 8
  %v382 = add i64 %v381, 8
  %v383 = load i64, ptr %NEXT_PC, align 8
  %v384 = load ptr, ptr %MEMORY, align 8
  %v385 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v384, ptr %state, ptr %BRANCH_TAKEN, i64 %v382, i64 %v383, ptr %NEXT_PC)
  store ptr %v385, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658015, label %bb_5395658007

bb_5395658007:                                    ; preds = %bb_5395657963
  %v386 = load i64, ptr %NEXT_PC, align 8
  store i64 %v386, ptr %PC, align 8
  %v387 = add i64 %v386, 2
  store i64 %v387, ptr %NEXT_PC, align 8
  %v388 = load i64, ptr %RAX, align 8
  %v389 = load i32, ptr %EAX, align 4
  %v390 = zext i32 %v389 to i64
  %v391 = load ptr, ptr %MEMORY, align 8
  %v392 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v391, ptr %state, ptr %RAX, i64 %v388, i64 %v390)
  store ptr %v392, ptr %MEMORY, align 8
  %v393 = load i64, ptr %NEXT_PC, align 8
  store i64 %v393, ptr %PC, align 8
  %v394 = add i64 %v393, 4
  store i64 %v394, ptr %NEXT_PC, align 8
  %v395 = load i64, ptr %RSP, align 8
  %v396 = load ptr, ptr %MEMORY, align 8
  %v397 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v396, ptr %state, ptr %RSP, i64 %v395, i64 32)
  store ptr %v397, ptr %MEMORY, align 8
  %v398 = load i64, ptr %NEXT_PC, align 8
  store i64 %v398, ptr %PC, align 8
  %v399 = add i64 %v398, 1
  store i64 %v399, ptr %NEXT_PC, align 8
  %v400 = load ptr, ptr %MEMORY, align 8
  %v401 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v400, ptr %state, ptr %RDI)
  store ptr %v401, ptr %MEMORY, align 8
  %v402 = load i64, ptr %NEXT_PC, align 8
  store i64 %v402, ptr %PC, align 8
  %v403 = add i64 %v402, 1
  store i64 %v403, ptr %NEXT_PC, align 8
  %v404 = load ptr, ptr %MEMORY, align 8
  %v405 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v404, ptr %state, ptr %NEXT_PC)
  store ptr %v405, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658015:                                    ; preds = %bb_5395657963, %bb_5395657958
  %v406 = load i64, ptr %NEXT_PC, align 8
  store i64 %v406, ptr %PC, align 8
  %v407 = add i64 %v406, 5
  store i64 %v407, ptr %NEXT_PC, align 8
  %v408 = load ptr, ptr %MEMORY, align 8
  %v409 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v408, ptr %state, ptr %RAX, i64 1)
  store ptr %v409, ptr %MEMORY, align 8
  %v410 = load i64, ptr %NEXT_PC, align 8
  store i64 %v410, ptr %PC, align 8
  %v411 = add i64 %v410, 4
  store i64 %v411, ptr %NEXT_PC, align 8
  %v412 = load i64, ptr %RSP, align 8
  %v413 = load ptr, ptr %MEMORY, align 8
  %v414 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v413, ptr %state, ptr %RSP, i64 %v412, i64 32)
  store ptr %v414, ptr %MEMORY, align 8
  %v415 = load i64, ptr %NEXT_PC, align 8
  store i64 %v415, ptr %PC, align 8
  %v416 = add i64 %v415, 1
  store i64 %v416, ptr %NEXT_PC, align 8
  %v417 = load ptr, ptr %MEMORY, align 8
  %v418 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v417, ptr %state, ptr %RDI)
  store ptr %v418, ptr %MEMORY, align 8
  %v419 = load i64, ptr %NEXT_PC, align 8
  store i64 %v419, ptr %PC, align 8
  %v420 = add i64 %v419, 1
  store i64 %v420, ptr %NEXT_PC, align 8
  %v421 = load ptr, ptr %MEMORY, align 8
  %v422 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v421, ptr %state, ptr %NEXT_PC)
  store ptr %v422, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658026:                                    ; No predecessors!
  %v423 = load i64, ptr %NEXT_PC, align 8
  store i64 %v423, ptr %PC, align 8
  %v424 = add i64 %v423, 1
  store i64 %v424, ptr %NEXT_PC, align 8
  %v425 = load ptr, ptr %MEMORY, align 8
  %v426 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v425, ptr %state, ptr undef)
  store ptr %v426, ptr %MEMORY, align 8
  %v427 = load i64, ptr %NEXT_PC, align 8
  store i64 %v427, ptr %PC, align 8
  %v428 = add i64 %v427, 1
  store i64 %v428, ptr %NEXT_PC, align 8
  %v429 = load ptr, ptr %MEMORY, align 8
  %v430 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v429, ptr %state, ptr undef)
  store ptr %v430, ptr %MEMORY, align 8
  %v431 = load i64, ptr %NEXT_PC, align 8
  store i64 %v431, ptr %PC, align 8
  %v432 = add i64 %v431, 1
  store i64 %v432, ptr %NEXT_PC, align 8
  %v433 = load ptr, ptr %MEMORY, align 8
  %v434 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v433, ptr %state, ptr undef)
  store ptr %v434, ptr %MEMORY, align 8
  %v435 = load i64, ptr %NEXT_PC, align 8
  store i64 %v435, ptr %PC, align 8
  %v436 = add i64 %v435, 1
  store i64 %v436, ptr %NEXT_PC, align 8
  %v437 = load ptr, ptr %MEMORY, align 8
  %v438 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v437, ptr %state, ptr undef)
  store ptr %v438, ptr %MEMORY, align 8
  %v439 = load i64, ptr %NEXT_PC, align 8
  store i64 %v439, ptr %PC, align 8
  %v440 = add i64 %v439, 1
  store i64 %v440, ptr %NEXT_PC, align 8
  %v441 = load ptr, ptr %MEMORY, align 8
  %v442 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v441, ptr %state, ptr undef)
  store ptr %v442, ptr %MEMORY, align 8
  %v443 = load i64, ptr %NEXT_PC, align 8
  store i64 %v443, ptr %PC, align 8
  %v444 = add i64 %v443, 1
  store i64 %v444, ptr %NEXT_PC, align 8
  %v445 = load ptr, ptr %MEMORY, align 8
  %v446 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v445, ptr %state, ptr undef)
  store ptr %v446, ptr %MEMORY, align 8
  %v447 = load i64, ptr %NEXT_PC, align 8
  store i64 %v447, ptr %PC, align 8
  %v448 = add i64 %v447, 4
  store i64 %v448, ptr %NEXT_PC, align 8
  %v449 = load i64, ptr %RCX, align 8
  %v450 = add i64 %v449, 8
  %v451 = load ptr, ptr %MEMORY, align 8
  %v452 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v451, ptr %state, ptr %RAX, i64 %v450)
  store ptr %v452, ptr %MEMORY, align 8
  %v453 = load i64, ptr %NEXT_PC, align 8
  store i64 %v453, ptr %PC, align 8
  %v454 = add i64 %v453, 1
  store i64 %v454, ptr %NEXT_PC, align 8
  %v455 = load ptr, ptr %MEMORY, align 8
  %v456 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v455, ptr %state, ptr %NEXT_PC)
  store ptr %v456, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658037:                                    ; No predecessors!
  %v457 = load i64, ptr %NEXT_PC, align 8
  store i64 %v457, ptr %PC, align 8
  %v458 = add i64 %v457, 1
  store i64 %v458, ptr %NEXT_PC, align 8
  %v459 = load ptr, ptr %MEMORY, align 8
  %v460 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v459, ptr %state, ptr undef)
  store ptr %v460, ptr %MEMORY, align 8
  %v461 = load i64, ptr %NEXT_PC, align 8
  store i64 %v461, ptr %PC, align 8
  %v462 = add i64 %v461, 1
  store i64 %v462, ptr %NEXT_PC, align 8
  %v463 = load ptr, ptr %MEMORY, align 8
  %v464 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v463, ptr %state, ptr undef)
  store ptr %v464, ptr %MEMORY, align 8
  %v465 = load i64, ptr %NEXT_PC, align 8
  store i64 %v465, ptr %PC, align 8
  %v466 = add i64 %v465, 1
  store i64 %v466, ptr %NEXT_PC, align 8
  %v467 = load ptr, ptr %MEMORY, align 8
  %v468 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v467, ptr %state, ptr undef)
  store ptr %v468, ptr %MEMORY, align 8
  %v469 = load i64, ptr %NEXT_PC, align 8
  store i64 %v469, ptr %PC, align 8
  %v470 = add i64 %v469, 1
  store i64 %v470, ptr %NEXT_PC, align 8
  %v471 = load ptr, ptr %MEMORY, align 8
  %v472 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v471, ptr %state, ptr undef)
  store ptr %v472, ptr %MEMORY, align 8
  %v473 = load i64, ptr %NEXT_PC, align 8
  store i64 %v473, ptr %PC, align 8
  %v474 = add i64 %v473, 1
  store i64 %v474, ptr %NEXT_PC, align 8
  %v475 = load ptr, ptr %MEMORY, align 8
  %v476 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v475, ptr %state, ptr undef)
  store ptr %v476, ptr %MEMORY, align 8
  %v477 = load i64, ptr %NEXT_PC, align 8
  store i64 %v477, ptr %PC, align 8
  %v478 = add i64 %v477, 1
  store i64 %v478, ptr %NEXT_PC, align 8
  %v479 = load ptr, ptr %MEMORY, align 8
  %v480 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v479, ptr %state, ptr undef)
  store ptr %v480, ptr %MEMORY, align 8
  %v481 = load i64, ptr %NEXT_PC, align 8
  store i64 %v481, ptr %PC, align 8
  %v482 = add i64 %v481, 1
  store i64 %v482, ptr %NEXT_PC, align 8
  %v483 = load ptr, ptr %MEMORY, align 8
  %v484 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v483, ptr %state, ptr undef)
  store ptr %v484, ptr %MEMORY, align 8
  %v485 = load i64, ptr %NEXT_PC, align 8
  store i64 %v485, ptr %PC, align 8
  %v486 = add i64 %v485, 1
  store i64 %v486, ptr %NEXT_PC, align 8
  %v487 = load ptr, ptr %MEMORY, align 8
  %v488 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v487, ptr %state, ptr undef)
  store ptr %v488, ptr %MEMORY, align 8
  %v489 = load i64, ptr %NEXT_PC, align 8
  store i64 %v489, ptr %PC, align 8
  %v490 = add i64 %v489, 1
  store i64 %v490, ptr %NEXT_PC, align 8
  %v491 = load ptr, ptr %MEMORY, align 8
  %v492 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v491, ptr %state, ptr undef)
  store ptr %v492, ptr %MEMORY, align 8
  %v493 = load i64, ptr %NEXT_PC, align 8
  store i64 %v493, ptr %PC, align 8
  %v494 = add i64 %v493, 1
  store i64 %v494, ptr %NEXT_PC, align 8
  %v495 = load ptr, ptr %MEMORY, align 8
  %v496 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v495, ptr %state, ptr undef)
  store ptr %v496, ptr %MEMORY, align 8
  %v497 = load i64, ptr %NEXT_PC, align 8
  store i64 %v497, ptr %PC, align 8
  %v498 = add i64 %v497, 1
  store i64 %v498, ptr %NEXT_PC, align 8
  %v499 = load ptr, ptr %MEMORY, align 8
  %v500 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v499, ptr %state, ptr undef)
  store ptr %v500, ptr %MEMORY, align 8
  %v501 = load i64, ptr %NEXT_PC, align 8
  store i64 %v501, ptr %PC, align 8
  %v502 = add i64 %v501, 4
  store i64 %v502, ptr %NEXT_PC, align 8
  %v503 = load i64, ptr %RCX, align 8
  %v504 = add i64 %v503, 8
  %v505 = load ptr, ptr %MEMORY, align 8
  %v506 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v505, ptr %state, ptr %RAX, i64 %v504)
  store ptr %v506, ptr %MEMORY, align 8
  %v507 = load i64, ptr %NEXT_PC, align 8
  store i64 %v507, ptr %PC, align 8
  %v508 = add i64 %v507, 1
  store i64 %v508, ptr %NEXT_PC, align 8
  %v509 = load ptr, ptr %MEMORY, align 8
  %v510 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v509, ptr %state, ptr %NEXT_PC)
  store ptr %v510, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658053:                                    ; No predecessors!
  %v511 = load i64, ptr %NEXT_PC, align 8
  store i64 %v511, ptr %PC, align 8
  %v512 = add i64 %v511, 1
  store i64 %v512, ptr %NEXT_PC, align 8
  %v513 = load ptr, ptr %MEMORY, align 8
  %v514 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v513, ptr %state, ptr undef)
  store ptr %v514, ptr %MEMORY, align 8
  %v515 = load i64, ptr %NEXT_PC, align 8
  store i64 %v515, ptr %PC, align 8
  %v516 = add i64 %v515, 1
  store i64 %v516, ptr %NEXT_PC, align 8
  %v517 = load ptr, ptr %MEMORY, align 8
  %v518 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v517, ptr %state, ptr undef)
  store ptr %v518, ptr %MEMORY, align 8
  %v519 = load i64, ptr %NEXT_PC, align 8
  store i64 %v519, ptr %PC, align 8
  %v520 = add i64 %v519, 1
  store i64 %v520, ptr %NEXT_PC, align 8
  %v521 = load ptr, ptr %MEMORY, align 8
  %v522 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v521, ptr %state, ptr undef)
  store ptr %v522, ptr %MEMORY, align 8
  %v523 = load i64, ptr %NEXT_PC, align 8
  store i64 %v523, ptr %PC, align 8
  %v524 = add i64 %v523, 1
  store i64 %v524, ptr %NEXT_PC, align 8
  %v525 = load ptr, ptr %MEMORY, align 8
  %v526 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v525, ptr %state, ptr undef)
  store ptr %v526, ptr %MEMORY, align 8
  %v527 = load i64, ptr %NEXT_PC, align 8
  store i64 %v527, ptr %PC, align 8
  %v528 = add i64 %v527, 1
  store i64 %v528, ptr %NEXT_PC, align 8
  %v529 = load ptr, ptr %MEMORY, align 8
  %v530 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v529, ptr %state, ptr undef)
  store ptr %v530, ptr %MEMORY, align 8
  %v531 = load i64, ptr %NEXT_PC, align 8
  store i64 %v531, ptr %PC, align 8
  %v532 = add i64 %v531, 1
  store i64 %v532, ptr %NEXT_PC, align 8
  %v533 = load ptr, ptr %MEMORY, align 8
  %v534 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v533, ptr %state, ptr undef)
  store ptr %v534, ptr %MEMORY, align 8
  %v535 = load i64, ptr %NEXT_PC, align 8
  store i64 %v535, ptr %PC, align 8
  %v536 = add i64 %v535, 1
  store i64 %v536, ptr %NEXT_PC, align 8
  %v537 = load ptr, ptr %MEMORY, align 8
  %v538 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v537, ptr %state, ptr undef)
  store ptr %v538, ptr %MEMORY, align 8
  %v539 = load i64, ptr %NEXT_PC, align 8
  store i64 %v539, ptr %PC, align 8
  %v540 = add i64 %v539, 1
  store i64 %v540, ptr %NEXT_PC, align 8
  %v541 = load ptr, ptr %MEMORY, align 8
  %v542 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v541, ptr %state, ptr undef)
  store ptr %v542, ptr %MEMORY, align 8
  %v543 = load i64, ptr %NEXT_PC, align 8
  store i64 %v543, ptr %PC, align 8
  %v544 = add i64 %v543, 1
  store i64 %v544, ptr %NEXT_PC, align 8
  %v545 = load ptr, ptr %MEMORY, align 8
  %v546 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v545, ptr %state, ptr undef)
  store ptr %v546, ptr %MEMORY, align 8
  %v547 = load i64, ptr %NEXT_PC, align 8
  store i64 %v547, ptr %PC, align 8
  %v548 = add i64 %v547, 1
  store i64 %v548, ptr %NEXT_PC, align 8
  %v549 = load ptr, ptr %MEMORY, align 8
  %v550 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v549, ptr %state, ptr undef)
  store ptr %v550, ptr %MEMORY, align 8
  %v551 = load i64, ptr %NEXT_PC, align 8
  store i64 %v551, ptr %PC, align 8
  %v552 = add i64 %v551, 1
  store i64 %v552, ptr %NEXT_PC, align 8
  %v553 = load ptr, ptr %MEMORY, align 8
  %v554 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v553, ptr %state, ptr undef)
  store ptr %v554, ptr %MEMORY, align 8
  %v555 = load i64, ptr %NEXT_PC, align 8
  store i64 %v555, ptr %PC, align 8
  %v556 = add i64 %v555, 2
  store i64 %v556, ptr %NEXT_PC, align 8
  %v557 = load i64, ptr %RAX, align 8
  %v558 = load i32, ptr %EAX, align 4
  %v559 = zext i32 %v558 to i64
  %v560 = load ptr, ptr %MEMORY, align 8
  %v561 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v560, ptr %state, ptr %RAX, i64 %v557, i64 %v559)
  store ptr %v561, ptr %MEMORY, align 8
  %v562 = load i64, ptr %NEXT_PC, align 8
  store i64 %v562, ptr %PC, align 8
  %v563 = add i64 %v562, 3
  store i64 %v563, ptr %NEXT_PC, align 8
  %v564 = load i64, ptr %RCX, align 8
  %v565 = load i64, ptr %RCX, align 8
  %v566 = load ptr, ptr %MEMORY, align 8
  %v567 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v566, ptr %state, i64 %v564, i64 %v565)
  store ptr %v567, ptr %MEMORY, align 8
  %v568 = load i64, ptr %NEXT_PC, align 8
  store i64 %v568, ptr %PC, align 8
  %v569 = add i64 %v568, 2
  store i64 %v569, ptr %NEXT_PC, align 8
  %v570 = load i64, ptr %NEXT_PC, align 8
  %v571 = add i64 %v570, 20
  %v572 = load i64, ptr %NEXT_PC, align 8
  %v573 = load ptr, ptr %MEMORY, align 8
  %v574 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v573, ptr %state, ptr %BRANCH_TAKEN, i64 %v571, i64 %v572, ptr %NEXT_PC)
  store ptr %v574, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658091, label %bb_5395658071

bb_5395658071:                                    ; preds = %bb_5395658053
  %v575 = load i64, ptr %NEXT_PC, align 8
  store i64 %v575, ptr %PC, align 8
  %v576 = add i64 %v575, 9
  store i64 %v576, ptr %NEXT_PC, align 8
  %v577 = load i64, ptr %RAX, align 8
  %v578 = load i64, ptr %RAX, align 8
  %v579 = mul i64 %v578, 1
  %v580 = add i64 %v577, %v579
  %v581 = load ptr, ptr %MEMORY, align 8
  %v582 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnItEEEEP6MemoryS4_R5StateDpT_(ptr %v581, ptr %state, i64 %v580)
  store ptr %v582, ptr %MEMORY, align 8
  br label %bb_5395658080

bb_5395658080:                                    ; preds = %bb_5395658080, %bb_5395658071
  %v583 = load i64, ptr %NEXT_PC, align 8
  store i64 %v583, ptr %PC, align 8
  %v584 = add i64 %v583, 4
  store i64 %v584, ptr %NEXT_PC, align 8
  %v585 = load i64, ptr %RCX, align 8
  %v586 = add i64 %v585, 8
  %v587 = load ptr, ptr %MEMORY, align 8
  %v588 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v587, ptr %state, ptr %RCX, i64 %v586)
  store ptr %v588, ptr %MEMORY, align 8
  %v589 = load i64, ptr %NEXT_PC, align 8
  store i64 %v589, ptr %PC, align 8
  %v590 = add i64 %v589, 2
  store i64 %v590, ptr %NEXT_PC, align 8
  %v591 = load i64, ptr %RAX, align 8
  %v592 = load ptr, ptr %MEMORY, align 8
  %v593 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v592, ptr %state, ptr %RAX, i64 %v591)
  store ptr %v593, ptr %MEMORY, align 8
  %v594 = load i64, ptr %NEXT_PC, align 8
  store i64 %v594, ptr %PC, align 8
  %v595 = add i64 %v594, 3
  store i64 %v595, ptr %NEXT_PC, align 8
  %v596 = load i64, ptr %RCX, align 8
  %v597 = load i64, ptr %RCX, align 8
  %v598 = load ptr, ptr %MEMORY, align 8
  %v599 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v598, ptr %state, i64 %v596, i64 %v597)
  store ptr %v599, ptr %MEMORY, align 8
  %v600 = load i64, ptr %NEXT_PC, align 8
  store i64 %v600, ptr %PC, align 8
  %v601 = add i64 %v600, 2
  store i64 %v601, ptr %NEXT_PC, align 8
  %v602 = load i64, ptr %NEXT_PC, align 8
  %v603 = sub i64 %v602, 11
  %v604 = load i64, ptr %NEXT_PC, align 8
  %v605 = load ptr, ptr %MEMORY, align 8
  %v606 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v605, ptr %state, ptr %BRANCH_TAKEN, i64 %v603, i64 %v604, ptr %NEXT_PC)
  store ptr %v606, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658080, label %bb_5395658091

bb_5395658091:                                    ; preds = %bb_5395658080, %bb_5395658053
  %v607 = load i64, ptr %NEXT_PC, align 8
  store i64 %v607, ptr %PC, align 8
  %v608 = add i64 %v607, 1
  store i64 %v608, ptr %NEXT_PC, align 8
  %v609 = load ptr, ptr %MEMORY, align 8
  %v610 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v609, ptr %state, ptr %NEXT_PC)
  store ptr %v610, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658092:                                    ; No predecessors!
  %v611 = load i64, ptr %NEXT_PC, align 8
  store i64 %v611, ptr %PC, align 8
  %v612 = add i64 %v611, 1
  store i64 %v612, ptr %NEXT_PC, align 8
  %v613 = load ptr, ptr %MEMORY, align 8
  %v614 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v613, ptr %state, ptr undef)
  store ptr %v614, ptr %MEMORY, align 8
  %v615 = load i64, ptr %NEXT_PC, align 8
  store i64 %v615, ptr %PC, align 8
  %v616 = add i64 %v615, 1
  store i64 %v616, ptr %NEXT_PC, align 8
  %v617 = load ptr, ptr %MEMORY, align 8
  %v618 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v617, ptr %state, ptr undef)
  store ptr %v618, ptr %MEMORY, align 8
  %v619 = load i64, ptr %NEXT_PC, align 8
  store i64 %v619, ptr %PC, align 8
  %v620 = add i64 %v619, 1
  store i64 %v620, ptr %NEXT_PC, align 8
  %v621 = load ptr, ptr %MEMORY, align 8
  %v622 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v621, ptr %state, ptr undef)
  store ptr %v622, ptr %MEMORY, align 8
  %v623 = load i64, ptr %NEXT_PC, align 8
  store i64 %v623, ptr %PC, align 8
  %v624 = add i64 %v623, 1
  store i64 %v624, ptr %NEXT_PC, align 8
  %v625 = load ptr, ptr %MEMORY, align 8
  %v626 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v625, ptr %state, ptr undef)
  store ptr %v626, ptr %MEMORY, align 8
  %v627 = load i64, ptr %NEXT_PC, align 8
  store i64 %v627, ptr %PC, align 8
  %v628 = add i64 %v627, 1
  store i64 %v628, ptr %NEXT_PC, align 8
  %v629 = load ptr, ptr %MEMORY, align 8
  %v630 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v629, ptr %state, ptr undef)
  store ptr %v630, ptr %MEMORY, align 8
  %v631 = load i64, ptr %NEXT_PC, align 8
  store i64 %v631, ptr %PC, align 8
  %v632 = add i64 %v631, 1
  store i64 %v632, ptr %NEXT_PC, align 8
  %v633 = load ptr, ptr %MEMORY, align 8
  %v634 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v633, ptr %state, ptr undef)
  store ptr %v634, ptr %MEMORY, align 8
  %v635 = load i64, ptr %NEXT_PC, align 8
  store i64 %v635, ptr %PC, align 8
  %v636 = add i64 %v635, 1
  store i64 %v636, ptr %NEXT_PC, align 8
  %v637 = load ptr, ptr %MEMORY, align 8
  %v638 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v637, ptr %state, ptr undef)
  store ptr %v638, ptr %MEMORY, align 8
  %v639 = load i64, ptr %NEXT_PC, align 8
  store i64 %v639, ptr %PC, align 8
  %v640 = add i64 %v639, 1
  store i64 %v640, ptr %NEXT_PC, align 8
  %v641 = load ptr, ptr %MEMORY, align 8
  %v642 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v641, ptr %state, ptr undef)
  store ptr %v642, ptr %MEMORY, align 8
  %v643 = load i64, ptr %NEXT_PC, align 8
  store i64 %v643, ptr %PC, align 8
  %v644 = add i64 %v643, 1
  store i64 %v644, ptr %NEXT_PC, align 8
  %v645 = load ptr, ptr %MEMORY, align 8
  %v646 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v645, ptr %state, ptr undef)
  store ptr %v646, ptr %MEMORY, align 8
  %v647 = load i64, ptr %NEXT_PC, align 8
  store i64 %v647, ptr %PC, align 8
  %v648 = add i64 %v647, 1
  store i64 %v648, ptr %NEXT_PC, align 8
  %v649 = load ptr, ptr %MEMORY, align 8
  %v650 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v649, ptr %state, ptr undef)
  store ptr %v650, ptr %MEMORY, align 8
  %v651 = load i64, ptr %NEXT_PC, align 8
  store i64 %v651, ptr %PC, align 8
  %v652 = add i64 %v651, 1
  store i64 %v652, ptr %NEXT_PC, align 8
  %v653 = load ptr, ptr %MEMORY, align 8
  %v654 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v653, ptr %state, ptr undef)
  store ptr %v654, ptr %MEMORY, align 8
  %v655 = load i64, ptr %NEXT_PC, align 8
  store i64 %v655, ptr %PC, align 8
  %v656 = add i64 %v655, 1
  store i64 %v656, ptr %NEXT_PC, align 8
  %v657 = load ptr, ptr %MEMORY, align 8
  %v658 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v657, ptr %state, ptr undef)
  store ptr %v658, ptr %MEMORY, align 8
  %v659 = load i64, ptr %NEXT_PC, align 8
  store i64 %v659, ptr %PC, align 8
  %v660 = add i64 %v659, 1
  store i64 %v660, ptr %NEXT_PC, align 8
  %v661 = load ptr, ptr %MEMORY, align 8
  %v662 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v661, ptr %state, ptr undef)
  store ptr %v662, ptr %MEMORY, align 8
  %v663 = load i64, ptr %NEXT_PC, align 8
  store i64 %v663, ptr %PC, align 8
  %v664 = add i64 %v663, 1
  store i64 %v664, ptr %NEXT_PC, align 8
  %v665 = load ptr, ptr %MEMORY, align 8
  %v666 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v665, ptr %state, ptr undef)
  store ptr %v666, ptr %MEMORY, align 8
  %v667 = load i64, ptr %NEXT_PC, align 8
  store i64 %v667, ptr %PC, align 8
  %v668 = add i64 %v667, 1
  store i64 %v668, ptr %NEXT_PC, align 8
  %v669 = load ptr, ptr %MEMORY, align 8
  %v670 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v669, ptr %state, ptr undef)
  store ptr %v670, ptr %MEMORY, align 8
  %v671 = load i64, ptr %NEXT_PC, align 8
  store i64 %v671, ptr %PC, align 8
  %v672 = add i64 %v671, 1
  store i64 %v672, ptr %NEXT_PC, align 8
  %v673 = load ptr, ptr %MEMORY, align 8
  %v674 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v673, ptr %state, ptr undef)
  store ptr %v674, ptr %MEMORY, align 8
  %v675 = load i64, ptr %NEXT_PC, align 8
  store i64 %v675, ptr %PC, align 8
  %v676 = add i64 %v675, 1
  store i64 %v676, ptr %NEXT_PC, align 8
  %v677 = load ptr, ptr %MEMORY, align 8
  %v678 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v677, ptr %state, ptr undef)
  store ptr %v678, ptr %MEMORY, align 8
  %v679 = load i64, ptr %NEXT_PC, align 8
  store i64 %v679, ptr %PC, align 8
  %v680 = add i64 %v679, 1
  store i64 %v680, ptr %NEXT_PC, align 8
  %v681 = load ptr, ptr %MEMORY, align 8
  %v682 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v681, ptr %state, ptr undef)
  store ptr %v682, ptr %MEMORY, align 8
  %v683 = load i64, ptr %NEXT_PC, align 8
  store i64 %v683, ptr %PC, align 8
  %v684 = add i64 %v683, 1
  store i64 %v684, ptr %NEXT_PC, align 8
  %v685 = load ptr, ptr %MEMORY, align 8
  %v686 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v685, ptr %state, ptr undef)
  store ptr %v686, ptr %MEMORY, align 8
  %v687 = load i64, ptr %NEXT_PC, align 8
  store i64 %v687, ptr %PC, align 8
  %v688 = add i64 %v687, 1
  store i64 %v688, ptr %NEXT_PC, align 8
  %v689 = load ptr, ptr %MEMORY, align 8
  %v690 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v689, ptr %state, ptr undef)
  store ptr %v690, ptr %MEMORY, align 8
  %v691 = load i64, ptr %NEXT_PC, align 8
  store i64 %v691, ptr %PC, align 8
  %v692 = add i64 %v691, 5
  store i64 %v692, ptr %NEXT_PC, align 8
  %v693 = load i64, ptr %RSP, align 8
  %v694 = add i64 %v693, 8
  %v695 = load i64, ptr %RBX, align 8
  %v696 = load ptr, ptr %MEMORY, align 8
  %v697 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v696, ptr %state, i64 %v694, i64 %v695)
  store ptr %v697, ptr %MEMORY, align 8
  %v698 = load i64, ptr %NEXT_PC, align 8
  store i64 %v698, ptr %PC, align 8
  %v699 = add i64 %v698, 5
  store i64 %v699, ptr %NEXT_PC, align 8
  %v700 = load i64, ptr %RSP, align 8
  %v701 = add i64 %v700, 16
  %v702 = load i64, ptr %RBP, align 8
  %v703 = load ptr, ptr %MEMORY, align 8
  %v704 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v703, ptr %state, i64 %v701, i64 %v702)
  store ptr %v704, ptr %MEMORY, align 8
  %v705 = load i64, ptr %NEXT_PC, align 8
  store i64 %v705, ptr %PC, align 8
  %v706 = add i64 %v705, 5
  store i64 %v706, ptr %NEXT_PC, align 8
  %v707 = load i64, ptr %RSP, align 8
  %v708 = add i64 %v707, 24
  %v709 = load i64, ptr %RSI, align 8
  %v710 = load ptr, ptr %MEMORY, align 8
  %v711 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v710, ptr %state, i64 %v708, i64 %v709)
  store ptr %v711, ptr %MEMORY, align 8
  %v712 = load i64, ptr %NEXT_PC, align 8
  store i64 %v712, ptr %PC, align 8
  %v713 = add i64 %v712, 1
  store i64 %v713, ptr %NEXT_PC, align 8
  %v714 = load i64, ptr %RDI, align 8
  %v715 = load ptr, ptr %MEMORY, align 8
  %v716 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v715, ptr %state, i64 %v714)
  store ptr %v716, ptr %MEMORY, align 8
  %v717 = load i64, ptr %NEXT_PC, align 8
  store i64 %v717, ptr %PC, align 8
  %v718 = add i64 %v717, 4
  store i64 %v718, ptr %NEXT_PC, align 8
  %v719 = load i64, ptr %RSP, align 8
  %v720 = load ptr, ptr %MEMORY, align 8
  %v721 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v720, ptr %state, ptr %RSP, i64 %v719, i64 32)
  store ptr %v721, ptr %MEMORY, align 8
  %v722 = load i64, ptr %NEXT_PC, align 8
  store i64 %v722, ptr %PC, align 8
  %v723 = add i64 %v722, 3
  store i64 %v723, ptr %NEXT_PC, align 8
  %v724 = load i64, ptr %R8, align 8
  %v725 = load ptr, ptr %MEMORY, align 8
  %v726 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v725, ptr %state, ptr %RBX, i64 %v724)
  store ptr %v726, ptr %MEMORY, align 8
  %v727 = load i64, ptr %NEXT_PC, align 8
  store i64 %v727, ptr %PC, align 8
  %v728 = add i64 %v727, 3
  store i64 %v728, ptr %NEXT_PC, align 8
  %v729 = load i64, ptr %RDX, align 8
  %v730 = load ptr, ptr %MEMORY, align 8
  %v731 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v730, ptr %state, ptr %RSI, i64 %v729)
  store ptr %v731, ptr %MEMORY, align 8
  %v732 = load i64, ptr %NEXT_PC, align 8
  store i64 %v732, ptr %PC, align 8
  %v733 = add i64 %v732, 3
  store i64 %v733, ptr %NEXT_PC, align 8
  %v734 = load i64, ptr %RCX, align 8
  %v735 = load ptr, ptr %MEMORY, align 8
  %v736 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v735, ptr %state, ptr %RBP, i64 %v734)
  store ptr %v736, ptr %MEMORY, align 8
  %v737 = load i64, ptr %NEXT_PC, align 8
  store i64 %v737, ptr %PC, align 8
  %v738 = add i64 %v737, 3
  store i64 %v738, ptr %NEXT_PC, align 8
  %v739 = load i64, ptr %R8, align 8
  %v740 = load i64, ptr %R8, align 8
  %v741 = load ptr, ptr %MEMORY, align 8
  %v742 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v741, ptr %state, i64 %v739, i64 %v740)
  store ptr %v742, ptr %MEMORY, align 8
  %v743 = load i64, ptr %NEXT_PC, align 8
  store i64 %v743, ptr %PC, align 8
  %v744 = add i64 %v743, 2
  store i64 %v744, ptr %NEXT_PC, align 8
  %v745 = load i64, ptr %NEXT_PC, align 8
  %v746 = add i64 %v745, 50
  %v747 = load i64, ptr %NEXT_PC, align 8
  %v748 = load ptr, ptr %MEMORY, align 8
  %v749 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v748, ptr %state, ptr %BRANCH_TAKEN, i64 %v746, i64 %v747, ptr %NEXT_PC)
  store ptr %v749, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658196, label %bb_5395658146

bb_5395658146:                                    ; preds = %bb_5395658180, %bb_5395658092
  %v750 = load i64, ptr %NEXT_PC, align 8
  store i64 %v750, ptr %PC, align 8
  %v751 = add i64 %v750, 3
  store i64 %v751, ptr %NEXT_PC, align 8
  %v752 = load i64, ptr %RBP, align 8
  %v753 = load ptr, ptr %MEMORY, align 8
  %v754 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v753, ptr %state, ptr %RCX, i64 %v752)
  store ptr %v754, ptr %MEMORY, align 8
  %v755 = load i64, ptr %NEXT_PC, align 8
  store i64 %v755, ptr %PC, align 8
  %v756 = add i64 %v755, 5
  store i64 %v756, ptr %NEXT_PC, align 8
  %v757 = load i64, ptr %NEXT_PC, align 8
  %v758 = sub i64 %v757, 234
  %v759 = load i64, ptr %NEXT_PC, align 8
  %v760 = load ptr, ptr %MEMORY, align 8
  %v761 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v760, ptr %state, i64 %v758, ptr %NEXT_PC, i64 %v759, ptr %RETURN_PC)
  store ptr %v761, ptr %MEMORY, align 8
  %v762 = load i64, ptr %NEXT_PC, align 8
  store i64 %v762, ptr %PC, align 8
  %v763 = add i64 %v762, 3
  store i64 %v763, ptr %NEXT_PC, align 8
  %v764 = load i64, ptr %RBX, align 8
  %v765 = load ptr, ptr %MEMORY, align 8
  %v766 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v765, ptr %state, ptr %RCX, i64 %v764)
  store ptr %v766, ptr %MEMORY, align 8
  %v767 = load i64, ptr %NEXT_PC, align 8
  store i64 %v767, ptr %PC, align 8
  %v768 = add i64 %v767, 3
  store i64 %v768, ptr %NEXT_PC, align 8
  %v769 = load i64, ptr %RAX, align 8
  %v770 = load ptr, ptr %MEMORY, align 8
  %v771 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v770, ptr %state, ptr %RDI, i64 %v769)
  store ptr %v771, ptr %MEMORY, align 8
  %v772 = load i64, ptr %NEXT_PC, align 8
  store i64 %v772, ptr %PC, align 8
  %v773 = add i64 %v772, 5
  store i64 %v773, ptr %NEXT_PC, align 8
  %v774 = load i64, ptr %NEXT_PC, align 8
  %v775 = sub i64 %v774, 245
  %v776 = load i64, ptr %NEXT_PC, align 8
  %v777 = load ptr, ptr %MEMORY, align 8
  %v778 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v777, ptr %state, i64 %v775, ptr %NEXT_PC, i64 %v776, ptr %RETURN_PC)
  store ptr %v778, ptr %MEMORY, align 8
  %v779 = load i64, ptr %NEXT_PC, align 8
  store i64 %v779, ptr %PC, align 8
  %v780 = add i64 %v779, 3
  store i64 %v780, ptr %NEXT_PC, align 8
  %v781 = load i64, ptr %RAX, align 8
  %v782 = load ptr, ptr %MEMORY, align 8
  %v783 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v782, ptr %state, ptr %RCX, i64 %v781)
  store ptr %v783, ptr %MEMORY, align 8
  %v784 = load i64, ptr %NEXT_PC, align 8
  store i64 %v784, ptr %PC, align 8
  %v785 = add i64 %v784, 3
  store i64 %v785, ptr %NEXT_PC, align 8
  %v786 = load i64, ptr %RDI, align 8
  %v787 = load ptr, ptr %MEMORY, align 8
  %v788 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v787, ptr %state, ptr %RDX, i64 %v786)
  store ptr %v788, ptr %MEMORY, align 8
  %v789 = load i64, ptr %NEXT_PC, align 8
  store i64 %v789, ptr %PC, align 8
  %v790 = add i64 %v789, 5
  store i64 %v790, ptr %NEXT_PC, align 8
  %v791 = load i64, ptr %NEXT_PC, align 8
  %v792 = add i64 %v791, 46144
  %v793 = load i64, ptr %NEXT_PC, align 8
  %v794 = load ptr, ptr %MEMORY, align 8
  %v795 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v794, ptr %state, i64 %v792, ptr %NEXT_PC, i64 %v793, ptr %RETURN_PC)
  store ptr %v795, ptr %MEMORY, align 8
  %v796 = load i64, ptr %NEXT_PC, align 8
  store i64 %v796, ptr %PC, align 8
  %v797 = add i64 %v796, 2
  store i64 %v797, ptr %NEXT_PC, align 8
  %v798 = load i32, ptr %EAX, align 4
  %v799 = zext i32 %v798 to i64
  %v800 = load i32, ptr %EAX, align 4
  %v801 = zext i32 %v800 to i64
  %v802 = load ptr, ptr %MEMORY, align 8
  %v803 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v802, ptr %state, i64 %v799, i64 %v801)
  store ptr %v803, ptr %MEMORY, align 8
  %v804 = load i64, ptr %NEXT_PC, align 8
  store i64 %v804, ptr %PC, align 8
  %v805 = add i64 %v804, 2
  store i64 %v805, ptr %NEXT_PC, align 8
  %v806 = load i64, ptr %NEXT_PC, align 8
  %v807 = add i64 %v806, 43
  %v808 = load i64, ptr %NEXT_PC, align 8
  %v809 = load ptr, ptr %MEMORY, align 8
  %v810 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v809, ptr %state, ptr %BRANCH_TAKEN, i64 %v807, i64 %v808, ptr %NEXT_PC)
  store ptr %v810, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658223, label %bb_5395658180

bb_5395658180:                                    ; preds = %bb_5395658146
  %v811 = load i64, ptr %NEXT_PC, align 8
  store i64 %v811, ptr %PC, align 8
  %v812 = add i64 %v811, 3
  store i64 %v812, ptr %NEXT_PC, align 8
  %v813 = load i64, ptr %RBX, align 8
  %v814 = load ptr, ptr %MEMORY, align 8
  %v815 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v814, ptr %state, ptr %RCX, i64 %v813)
  store ptr %v815, ptr %MEMORY, align 8
  %v816 = load i64, ptr %NEXT_PC, align 8
  store i64 %v816, ptr %PC, align 8
  %v817 = add i64 %v816, 5
  store i64 %v817, ptr %NEXT_PC, align 8
  %v818 = load i64, ptr %NEXT_PC, align 8
  %v819 = sub i64 %v818, 156
  %v820 = load i64, ptr %NEXT_PC, align 8
  %v821 = load ptr, ptr %MEMORY, align 8
  %v822 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v821, ptr %state, i64 %v819, ptr %NEXT_PC, i64 %v820, ptr %RETURN_PC)
  store ptr %v822, ptr %MEMORY, align 8
  %v823 = load i64, ptr %NEXT_PC, align 8
  store i64 %v823, ptr %PC, align 8
  %v824 = add i64 %v823, 3
  store i64 %v824, ptr %NEXT_PC, align 8
  %v825 = load i64, ptr %RAX, align 8
  %v826 = load ptr, ptr %MEMORY, align 8
  %v827 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v826, ptr %state, ptr %RBX, i64 %v825)
  store ptr %v827, ptr %MEMORY, align 8
  %v828 = load i64, ptr %NEXT_PC, align 8
  store i64 %v828, ptr %PC, align 8
  %v829 = add i64 %v828, 3
  store i64 %v829, ptr %NEXT_PC, align 8
  %v830 = load i64, ptr %RAX, align 8
  %v831 = load i64, ptr %RAX, align 8
  %v832 = load ptr, ptr %MEMORY, align 8
  %v833 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v832, ptr %state, i64 %v830, i64 %v831)
  store ptr %v833, ptr %MEMORY, align 8
  %v834 = load i64, ptr %NEXT_PC, align 8
  store i64 %v834, ptr %PC, align 8
  %v835 = add i64 %v834, 2
  store i64 %v835, ptr %NEXT_PC, align 8
  %v836 = load i64, ptr %NEXT_PC, align 8
  %v837 = sub i64 %v836, 50
  %v838 = load i64, ptr %NEXT_PC, align 8
  %v839 = load ptr, ptr %MEMORY, align 8
  %v840 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v839, ptr %state, ptr %BRANCH_TAKEN, i64 %v837, i64 %v838, ptr %NEXT_PC)
  store ptr %v840, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658146, label %bb_5395658196

bb_5395658196:                                    ; preds = %bb_5395658180, %bb_5395658092
  %v841 = load i64, ptr %NEXT_PC, align 8
  store i64 %v841, ptr %PC, align 8
  %v842 = add i64 %v841, 3
  store i64 %v842, ptr %NEXT_PC, align 8
  %v843 = load i64, ptr %RSI, align 8
  %v844 = load ptr, ptr %MEMORY, align 8
  %v845 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v844, ptr %state, i64 %v843, i64 0)
  store ptr %v845, ptr %MEMORY, align 8
  br label %bb_5395658199

bb_5395658199:                                    ; preds = %bb_5395658223, %bb_5395658196
  %v846 = load i64, ptr %NEXT_PC, align 8
  store i64 %v846, ptr %PC, align 8
  %v847 = add i64 %v846, 5
  store i64 %v847, ptr %NEXT_PC, align 8
  %v848 = load i64, ptr %RSP, align 8
  %v849 = add i64 %v848, 48
  %v850 = load ptr, ptr %MEMORY, align 8
  %v851 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v850, ptr %state, ptr %RBX, i64 %v849)
  store ptr %v851, ptr %MEMORY, align 8
  %v852 = load i64, ptr %NEXT_PC, align 8
  store i64 %v852, ptr %PC, align 8
  %v853 = add i64 %v852, 3
  store i64 %v853, ptr %NEXT_PC, align 8
  %v854 = load i64, ptr %RSI, align 8
  %v855 = load ptr, ptr %MEMORY, align 8
  %v856 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v855, ptr %state, ptr %RAX, i64 %v854)
  store ptr %v856, ptr %MEMORY, align 8
  %v857 = load i64, ptr %NEXT_PC, align 8
  store i64 %v857, ptr %PC, align 8
  %v858 = add i64 %v857, 5
  store i64 %v858, ptr %NEXT_PC, align 8
  %v859 = load i64, ptr %RSP, align 8
  %v860 = add i64 %v859, 64
  %v861 = load ptr, ptr %MEMORY, align 8
  %v862 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v861, ptr %state, ptr %RSI, i64 %v860)
  store ptr %v862, ptr %MEMORY, align 8
  %v863 = load i64, ptr %NEXT_PC, align 8
  store i64 %v863, ptr %PC, align 8
  %v864 = add i64 %v863, 5
  store i64 %v864, ptr %NEXT_PC, align 8
  %v865 = load i64, ptr %RSP, align 8
  %v866 = add i64 %v865, 56
  %v867 = load ptr, ptr %MEMORY, align 8
  %v868 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v867, ptr %state, ptr %RBP, i64 %v866)
  store ptr %v868, ptr %MEMORY, align 8
  %v869 = load i64, ptr %NEXT_PC, align 8
  store i64 %v869, ptr %PC, align 8
  %v870 = add i64 %v869, 4
  store i64 %v870, ptr %NEXT_PC, align 8
  %v871 = load i64, ptr %RSP, align 8
  %v872 = load ptr, ptr %MEMORY, align 8
  %v873 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v872, ptr %state, ptr %RSP, i64 %v871, i64 32)
  store ptr %v873, ptr %MEMORY, align 8
  %v874 = load i64, ptr %NEXT_PC, align 8
  store i64 %v874, ptr %PC, align 8
  %v875 = add i64 %v874, 1
  store i64 %v875, ptr %NEXT_PC, align 8
  %v876 = load ptr, ptr %MEMORY, align 8
  %v877 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v876, ptr %state, ptr %RDI)
  store ptr %v877, ptr %MEMORY, align 8
  %v878 = load i64, ptr %NEXT_PC, align 8
  store i64 %v878, ptr %PC, align 8
  %v879 = add i64 %v878, 1
  store i64 %v879, ptr %NEXT_PC, align 8
  %v880 = load ptr, ptr %MEMORY, align 8
  %v881 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v880, ptr %state, ptr %NEXT_PC)
  store ptr %v881, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658223:                                    ; preds = %bb_5395658146
  %v882 = load i64, ptr %NEXT_PC, align 8
  store i64 %v882, ptr %PC, align 8
  %v883 = add i64 %v882, 3
  store i64 %v883, ptr %NEXT_PC, align 8
  %v884 = load i64, ptr %RSI, align 8
  %v885 = load ptr, ptr %MEMORY, align 8
  %v886 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v885, ptr %state, i64 %v884, i64 1)
  store ptr %v886, ptr %MEMORY, align 8
  %v887 = load i64, ptr %NEXT_PC, align 8
  store i64 %v887, ptr %PC, align 8
  %v888 = add i64 %v887, 2
  store i64 %v888, ptr %NEXT_PC, align 8
  %v889 = load i64, ptr %NEXT_PC, align 8
  %v890 = sub i64 %v889, 29
  %v891 = load ptr, ptr %MEMORY, align 8
  %v892 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v891, ptr %state, i64 %v890, ptr %NEXT_PC)
  store ptr %v892, ptr %MEMORY, align 8
  br label %bb_5395658199
  %v893 = load i64, ptr %NEXT_PC, align 8
  store i64 %v893, ptr %PC, align 8
  %v894 = add i64 %v893, 1
  store i64 %v894, ptr %NEXT_PC, align 8
  %v895 = load ptr, ptr %MEMORY, align 8
  %v896 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v895, ptr %state, ptr undef)
  store ptr %v896, ptr %MEMORY, align 8
  %v897 = load i64, ptr %NEXT_PC, align 8
  store i64 %v897, ptr %PC, align 8
  %v898 = add i64 %v897, 1
  store i64 %v898, ptr %NEXT_PC, align 8
  %v899 = load ptr, ptr %MEMORY, align 8
  %v900 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v899, ptr %state, ptr undef)
  store ptr %v900, ptr %MEMORY, align 8
  %v901 = load i64, ptr %NEXT_PC, align 8
  store i64 %v901, ptr %PC, align 8
  %v902 = add i64 %v901, 1
  store i64 %v902, ptr %NEXT_PC, align 8
  %v903 = load ptr, ptr %MEMORY, align 8
  %v904 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v903, ptr %state, ptr undef)
  store ptr %v904, ptr %MEMORY, align 8
  %v905 = load i64, ptr %NEXT_PC, align 8
  store i64 %v905, ptr %PC, align 8
  %v906 = add i64 %v905, 1
  store i64 %v906, ptr %NEXT_PC, align 8
  %v907 = load ptr, ptr %MEMORY, align 8
  %v908 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v907, ptr %state, ptr undef)
  store ptr %v908, ptr %MEMORY, align 8
  %v909 = load i64, ptr %NEXT_PC, align 8
  store i64 %v909, ptr %PC, align 8
  %v910 = add i64 %v909, 1
  store i64 %v910, ptr %NEXT_PC, align 8
  %v911 = load ptr, ptr %MEMORY, align 8
  %v912 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v911, ptr %state, ptr undef)
  store ptr %v912, ptr %MEMORY, align 8
  %v913 = load i64, ptr %NEXT_PC, align 8
  store i64 %v913, ptr %PC, align 8
  %v914 = add i64 %v913, 1
  store i64 %v914, ptr %NEXT_PC, align 8
  %v915 = load ptr, ptr %MEMORY, align 8
  %v916 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v915, ptr %state, ptr undef)
  store ptr %v916, ptr %MEMORY, align 8
  %v917 = load i64, ptr %NEXT_PC, align 8
  store i64 %v917, ptr %PC, align 8
  %v918 = add i64 %v917, 1
  store i64 %v918, ptr %NEXT_PC, align 8
  %v919 = load ptr, ptr %MEMORY, align 8
  %v920 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v919, ptr %state, ptr undef)
  store ptr %v920, ptr %MEMORY, align 8
  %v921 = load i64, ptr %NEXT_PC, align 8
  store i64 %v921, ptr %PC, align 8
  %v922 = add i64 %v921, 1
  store i64 %v922, ptr %NEXT_PC, align 8
  %v923 = load ptr, ptr %MEMORY, align 8
  %v924 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v923, ptr %state, ptr undef)
  store ptr %v924, ptr %MEMORY, align 8
  %v925 = load i64, ptr %NEXT_PC, align 8
  store i64 %v925, ptr %PC, align 8
  %v926 = add i64 %v925, 1
  store i64 %v926, ptr %NEXT_PC, align 8
  %v927 = load ptr, ptr %MEMORY, align 8
  %v928 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v927, ptr %state, ptr undef)
  store ptr %v928, ptr %MEMORY, align 8
  %v929 = load i64, ptr %NEXT_PC, align 8
  store i64 %v929, ptr %PC, align 8
  %v930 = add i64 %v929, 1
  store i64 %v930, ptr %NEXT_PC, align 8
  %v931 = load ptr, ptr %MEMORY, align 8
  %v932 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v931, ptr %state, ptr undef)
  store ptr %v932, ptr %MEMORY, align 8
  %v933 = load i64, ptr %NEXT_PC, align 8
  store i64 %v933, ptr %PC, align 8
  %v934 = add i64 %v933, 1
  store i64 %v934, ptr %NEXT_PC, align 8
  %v935 = load ptr, ptr %MEMORY, align 8
  %v936 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v935, ptr %state, ptr undef)
  store ptr %v936, ptr %MEMORY, align 8
  %v937 = load i64, ptr %NEXT_PC, align 8
  store i64 %v937, ptr %PC, align 8
  %v938 = add i64 %v937, 1
  store i64 %v938, ptr %NEXT_PC, align 8
  %v939 = load ptr, ptr %MEMORY, align 8
  %v940 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v939, ptr %state, ptr undef)
  store ptr %v940, ptr %MEMORY, align 8
  %v941 = load i64, ptr %NEXT_PC, align 8
  store i64 %v941, ptr %PC, align 8
  %v942 = add i64 %v941, 2
  store i64 %v942, ptr %NEXT_PC, align 8
  %v943 = load i64, ptr %RAX, align 8
  %v944 = load i32, ptr %EAX, align 4
  %v945 = zext i32 %v944 to i64
  %v946 = load ptr, ptr %MEMORY, align 8
  %v947 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v946, ptr %state, ptr %RAX, i64 %v943, i64 %v945)
  store ptr %v947, ptr %MEMORY, align 8
  %v948 = load i64, ptr %NEXT_PC, align 8
  store i64 %v948, ptr %PC, align 8
  %v949 = add i64 %v948, 1
  store i64 %v949, ptr %NEXT_PC, align 8
  %v950 = load ptr, ptr %MEMORY, align 8
  %v951 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v950, ptr %state, ptr %NEXT_PC)
  store ptr %v951, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658243:                                    ; No predecessors!
  %v952 = load i64, ptr %NEXT_PC, align 8
  store i64 %v952, ptr %PC, align 8
  %v953 = add i64 %v952, 1
  store i64 %v953, ptr %NEXT_PC, align 8
  %v954 = load ptr, ptr %MEMORY, align 8
  %v955 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v954, ptr %state, ptr undef)
  store ptr %v955, ptr %MEMORY, align 8
  %v956 = load i64, ptr %NEXT_PC, align 8
  store i64 %v956, ptr %PC, align 8
  %v957 = add i64 %v956, 1
  store i64 %v957, ptr %NEXT_PC, align 8
  %v958 = load ptr, ptr %MEMORY, align 8
  %v959 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v958, ptr %state, ptr undef)
  store ptr %v959, ptr %MEMORY, align 8
  %v960 = load i64, ptr %NEXT_PC, align 8
  store i64 %v960, ptr %PC, align 8
  %v961 = add i64 %v960, 1
  store i64 %v961, ptr %NEXT_PC, align 8
  %v962 = load ptr, ptr %MEMORY, align 8
  %v963 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v962, ptr %state, ptr undef)
  store ptr %v963, ptr %MEMORY, align 8
  %v964 = load i64, ptr %NEXT_PC, align 8
  store i64 %v964, ptr %PC, align 8
  %v965 = add i64 %v964, 1
  store i64 %v965, ptr %NEXT_PC, align 8
  %v966 = load ptr, ptr %MEMORY, align 8
  %v967 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v966, ptr %state, ptr undef)
  store ptr %v967, ptr %MEMORY, align 8
  %v968 = load i64, ptr %NEXT_PC, align 8
  store i64 %v968, ptr %PC, align 8
  %v969 = add i64 %v968, 1
  store i64 %v969, ptr %NEXT_PC, align 8
  %v970 = load ptr, ptr %MEMORY, align 8
  %v971 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v970, ptr %state, ptr undef)
  store ptr %v971, ptr %MEMORY, align 8
  %v972 = load i64, ptr %NEXT_PC, align 8
  store i64 %v972, ptr %PC, align 8
  %v973 = add i64 %v972, 1
  store i64 %v973, ptr %NEXT_PC, align 8
  %v974 = load ptr, ptr %MEMORY, align 8
  %v975 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v974, ptr %state, ptr undef)
  store ptr %v975, ptr %MEMORY, align 8
  %v976 = load i64, ptr %NEXT_PC, align 8
  store i64 %v976, ptr %PC, align 8
  %v977 = add i64 %v976, 1
  store i64 %v977, ptr %NEXT_PC, align 8
  %v978 = load ptr, ptr %MEMORY, align 8
  %v979 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v978, ptr %state, ptr undef)
  store ptr %v979, ptr %MEMORY, align 8
  %v980 = load i64, ptr %NEXT_PC, align 8
  store i64 %v980, ptr %PC, align 8
  %v981 = add i64 %v980, 1
  store i64 %v981, ptr %NEXT_PC, align 8
  %v982 = load ptr, ptr %MEMORY, align 8
  %v983 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v982, ptr %state, ptr undef)
  store ptr %v983, ptr %MEMORY, align 8
  %v984 = load i64, ptr %NEXT_PC, align 8
  store i64 %v984, ptr %PC, align 8
  %v985 = add i64 %v984, 1
  store i64 %v985, ptr %NEXT_PC, align 8
  %v986 = load ptr, ptr %MEMORY, align 8
  %v987 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v986, ptr %state, ptr undef)
  store ptr %v987, ptr %MEMORY, align 8
  %v988 = load i64, ptr %NEXT_PC, align 8
  store i64 %v988, ptr %PC, align 8
  %v989 = add i64 %v988, 1
  store i64 %v989, ptr %NEXT_PC, align 8
  %v990 = load ptr, ptr %MEMORY, align 8
  %v991 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v990, ptr %state, ptr undef)
  store ptr %v991, ptr %MEMORY, align 8
  %v992 = load i64, ptr %NEXT_PC, align 8
  store i64 %v992, ptr %PC, align 8
  %v993 = add i64 %v992, 1
  store i64 %v993, ptr %NEXT_PC, align 8
  %v994 = load ptr, ptr %MEMORY, align 8
  %v995 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v994, ptr %state, ptr undef)
  store ptr %v995, ptr %MEMORY, align 8
  %v996 = load i64, ptr %NEXT_PC, align 8
  store i64 %v996, ptr %PC, align 8
  %v997 = add i64 %v996, 1
  store i64 %v997, ptr %NEXT_PC, align 8
  %v998 = load ptr, ptr %MEMORY, align 8
  %v999 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v998, ptr %state, ptr undef)
  store ptr %v999, ptr %MEMORY, align 8
  %v1000 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1000, ptr %PC, align 8
  %v1001 = add i64 %v1000, 1
  store i64 %v1001, ptr %NEXT_PC, align 8
  %v1002 = load ptr, ptr %MEMORY, align 8
  %v1003 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1002, ptr %state, ptr undef)
  store ptr %v1003, ptr %MEMORY, align 8
  %v1004 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1004, ptr %PC, align 8
  %v1005 = add i64 %v1004, 4
  store i64 %v1005, ptr %NEXT_PC, align 8
  %v1006 = load i64, ptr %RCX, align 8
  %v1007 = add i64 %v1006, 8
  %v1008 = load ptr, ptr %MEMORY, align 8
  %v1009 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1008, ptr %state, ptr %RDX, i64 %v1007)
  store ptr %v1009, ptr %MEMORY, align 8
  %v1010 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1010, ptr %PC, align 8
  %v1011 = add i64 %v1010, 3
  store i64 %v1011, ptr %NEXT_PC, align 8
  %v1012 = load i64, ptr %RCX, align 8
  %v1013 = add i64 %v1012, 20
  %v1014 = load ptr, ptr %MEMORY, align 8
  %v1015 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1014, ptr %state, ptr %RAX, i64 %v1013)
  store ptr %v1015, ptr %MEMORY, align 8
  %v1016 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1016, ptr %PC, align 8
  %v1017 = add i64 %v1016, 3
  store i64 %v1017, ptr %NEXT_PC, align 8
  %v1018 = load i64, ptr %RDX, align 8
  %v1019 = load i64, ptr %RDX, align 8
  %v1020 = load ptr, ptr %MEMORY, align 8
  %v1021 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1020, ptr %state, i64 %v1018, i64 %v1019)
  store ptr %v1021, ptr %MEMORY, align 8
  %v1022 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1022, ptr %PC, align 8
  %v1023 = add i64 %v1022, 2
  store i64 %v1023, ptr %NEXT_PC, align 8
  %v1024 = load i64, ptr %NEXT_PC, align 8
  %v1025 = add i64 %v1024, 16
  %v1026 = load i64, ptr %NEXT_PC, align 8
  %v1027 = load ptr, ptr %MEMORY, align 8
  %v1028 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1027, ptr %state, ptr %BRANCH_TAKEN, i64 %v1025, i64 %v1026, ptr %NEXT_PC)
  store ptr %v1028, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658284, label %bb_5395658268

bb_5395658268:                                    ; preds = %bb_5395658243
  %v1029 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1029, ptr %PC, align 8
  %v1030 = add i64 %v1029, 4
  store i64 %v1030, ptr %NEXT_PC, align 8
  %v1031 = load i64, ptr %RAX, align 8
  %v1032 = load ptr, ptr %MEMORY, align 8
  %v1033 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnIjEEEEP6MemoryS4_R5StateDpT_(ptr %v1032, ptr %state, i64 %v1031)
  store ptr %v1033, ptr %MEMORY, align 8
  br label %bb_5395658272

bb_5395658272:                                    ; preds = %bb_5395658272, %bb_5395658268
  %v1034 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1034, ptr %PC, align 8
  %v1035 = add i64 %v1034, 3
  store i64 %v1035, ptr %NEXT_PC, align 8
  %v1036 = load i64, ptr %RAX, align 8
  %v1037 = load i64, ptr %RDX, align 8
  %v1038 = add i64 %v1037, 20
  %v1039 = load ptr, ptr %MEMORY, align 8
  %v1040 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1039, ptr %state, ptr %RAX, i64 %v1036, i64 %v1038)
  store ptr %v1040, ptr %MEMORY, align 8
  %v1041 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1041, ptr %PC, align 8
  %v1042 = add i64 %v1041, 4
  store i64 %v1042, ptr %NEXT_PC, align 8
  %v1043 = load i64, ptr %RDX, align 8
  %v1044 = add i64 %v1043, 8
  %v1045 = load ptr, ptr %MEMORY, align 8
  %v1046 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1045, ptr %state, ptr %RDX, i64 %v1044)
  store ptr %v1046, ptr %MEMORY, align 8
  %v1047 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1047, ptr %PC, align 8
  %v1048 = add i64 %v1047, 3
  store i64 %v1048, ptr %NEXT_PC, align 8
  %v1049 = load i64, ptr %RDX, align 8
  %v1050 = load i64, ptr %RDX, align 8
  %v1051 = load ptr, ptr %MEMORY, align 8
  %v1052 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1051, ptr %state, i64 %v1049, i64 %v1050)
  store ptr %v1052, ptr %MEMORY, align 8
  %v1053 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1053, ptr %PC, align 8
  %v1054 = add i64 %v1053, 2
  store i64 %v1054, ptr %NEXT_PC, align 8
  %v1055 = load i64, ptr %NEXT_PC, align 8
  %v1056 = sub i64 %v1055, 12
  %v1057 = load i64, ptr %NEXT_PC, align 8
  %v1058 = load ptr, ptr %MEMORY, align 8
  %v1059 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1058, ptr %state, ptr %BRANCH_TAKEN, i64 %v1056, i64 %v1057, ptr %NEXT_PC)
  store ptr %v1059, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658272, label %bb_5395658284

bb_5395658284:                                    ; preds = %bb_5395658272, %bb_5395658243
  %v1060 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1060, ptr %PC, align 8
  %v1061 = add i64 %v1060, 1
  store i64 %v1061, ptr %NEXT_PC, align 8
  %v1062 = load ptr, ptr %MEMORY, align 8
  %v1063 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1062, ptr %state, ptr %NEXT_PC)
  store ptr %v1063, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658285:                                    ; No predecessors!
  %v1064 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1064, ptr %PC, align 8
  %v1065 = add i64 %v1064, 1
  store i64 %v1065, ptr %NEXT_PC, align 8
  %v1066 = load ptr, ptr %MEMORY, align 8
  %v1067 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1066, ptr %state, ptr undef)
  store ptr %v1067, ptr %MEMORY, align 8
  %v1068 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1068, ptr %PC, align 8
  %v1069 = add i64 %v1068, 1
  store i64 %v1069, ptr %NEXT_PC, align 8
  %v1070 = load ptr, ptr %MEMORY, align 8
  %v1071 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1070, ptr %state, ptr undef)
  store ptr %v1071, ptr %MEMORY, align 8
  %v1072 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1072, ptr %PC, align 8
  %v1073 = add i64 %v1072, 1
  store i64 %v1073, ptr %NEXT_PC, align 8
  %v1074 = load ptr, ptr %MEMORY, align 8
  %v1075 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1074, ptr %state, ptr undef)
  store ptr %v1075, ptr %MEMORY, align 8
  %v1076 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1076, ptr %PC, align 8
  %v1077 = add i64 %v1076, 1
  store i64 %v1077, ptr %NEXT_PC, align 8
  %v1078 = load ptr, ptr %MEMORY, align 8
  %v1079 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1078, ptr %state, ptr undef)
  store ptr %v1079, ptr %MEMORY, align 8
  %v1080 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1080, ptr %PC, align 8
  %v1081 = add i64 %v1080, 1
  store i64 %v1081, ptr %NEXT_PC, align 8
  %v1082 = load ptr, ptr %MEMORY, align 8
  %v1083 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1082, ptr %state, ptr undef)
  store ptr %v1083, ptr %MEMORY, align 8
  %v1084 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1084, ptr %PC, align 8
  %v1085 = add i64 %v1084, 1
  store i64 %v1085, ptr %NEXT_PC, align 8
  %v1086 = load ptr, ptr %MEMORY, align 8
  %v1087 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1086, ptr %state, ptr undef)
  store ptr %v1087, ptr %MEMORY, align 8
  %v1088 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1088, ptr %PC, align 8
  %v1089 = add i64 %v1088, 1
  store i64 %v1089, ptr %NEXT_PC, align 8
  %v1090 = load ptr, ptr %MEMORY, align 8
  %v1091 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1090, ptr %state, ptr undef)
  store ptr %v1091, ptr %MEMORY, align 8
  %v1092 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1092, ptr %PC, align 8
  %v1093 = add i64 %v1092, 1
  store i64 %v1093, ptr %NEXT_PC, align 8
  %v1094 = load ptr, ptr %MEMORY, align 8
  %v1095 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1094, ptr %state, ptr undef)
  store ptr %v1095, ptr %MEMORY, align 8
  %v1096 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1096, ptr %PC, align 8
  %v1097 = add i64 %v1096, 1
  store i64 %v1097, ptr %NEXT_PC, align 8
  %v1098 = load ptr, ptr %MEMORY, align 8
  %v1099 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1098, ptr %state, ptr undef)
  store ptr %v1099, ptr %MEMORY, align 8
  %v1100 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1100, ptr %PC, align 8
  %v1101 = add i64 %v1100, 1
  store i64 %v1101, ptr %NEXT_PC, align 8
  %v1102 = load ptr, ptr %MEMORY, align 8
  %v1103 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1102, ptr %state, ptr undef)
  store ptr %v1103, ptr %MEMORY, align 8
  %v1104 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1104, ptr %PC, align 8
  %v1105 = add i64 %v1104, 1
  store i64 %v1105, ptr %NEXT_PC, align 8
  %v1106 = load ptr, ptr %MEMORY, align 8
  %v1107 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1106, ptr %state, ptr undef)
  store ptr %v1107, ptr %MEMORY, align 8
  %v1108 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1108, ptr %PC, align 8
  %v1109 = add i64 %v1108, 1
  store i64 %v1109, ptr %NEXT_PC, align 8
  %v1110 = load ptr, ptr %MEMORY, align 8
  %v1111 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1110, ptr %state, ptr undef)
  store ptr %v1111, ptr %MEMORY, align 8
  %v1112 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1112, ptr %PC, align 8
  %v1113 = add i64 %v1112, 1
  store i64 %v1113, ptr %NEXT_PC, align 8
  %v1114 = load ptr, ptr %MEMORY, align 8
  %v1115 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1114, ptr %state, ptr undef)
  store ptr %v1115, ptr %MEMORY, align 8
  %v1116 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1116, ptr %PC, align 8
  %v1117 = add i64 %v1116, 1
  store i64 %v1117, ptr %NEXT_PC, align 8
  %v1118 = load ptr, ptr %MEMORY, align 8
  %v1119 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1118, ptr %state, ptr undef)
  store ptr %v1119, ptr %MEMORY, align 8
  %v1120 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1120, ptr %PC, align 8
  %v1121 = add i64 %v1120, 1
  store i64 %v1121, ptr %NEXT_PC, align 8
  %v1122 = load ptr, ptr %MEMORY, align 8
  %v1123 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1122, ptr %state, ptr undef)
  store ptr %v1123, ptr %MEMORY, align 8
  %v1124 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1124, ptr %PC, align 8
  %v1125 = add i64 %v1124, 1
  store i64 %v1125, ptr %NEXT_PC, align 8
  %v1126 = load ptr, ptr %MEMORY, align 8
  %v1127 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1126, ptr %state, ptr undef)
  store ptr %v1127, ptr %MEMORY, align 8
  %v1128 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1128, ptr %PC, align 8
  %v1129 = add i64 %v1128, 1
  store i64 %v1129, ptr %NEXT_PC, align 8
  %v1130 = load ptr, ptr %MEMORY, align 8
  %v1131 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1130, ptr %state, ptr undef)
  store ptr %v1131, ptr %MEMORY, align 8
  %v1132 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1132, ptr %PC, align 8
  %v1133 = add i64 %v1132, 1
  store i64 %v1133, ptr %NEXT_PC, align 8
  %v1134 = load ptr, ptr %MEMORY, align 8
  %v1135 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1134, ptr %state, ptr undef)
  store ptr %v1135, ptr %MEMORY, align 8
  %v1136 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1136, ptr %PC, align 8
  %v1137 = add i64 %v1136, 1
  store i64 %v1137, ptr %NEXT_PC, align 8
  %v1138 = load ptr, ptr %MEMORY, align 8
  %v1139 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1138, ptr %state, ptr undef)
  store ptr %v1139, ptr %MEMORY, align 8
  %v1140 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1140, ptr %PC, align 8
  %v1141 = add i64 %v1140, 2
  store i64 %v1141, ptr %NEXT_PC, align 8
  %v1142 = load i64, ptr %RAX, align 8
  %v1143 = load i32, ptr %EAX, align 4
  %v1144 = zext i32 %v1143 to i64
  %v1145 = load ptr, ptr %MEMORY, align 8
  %v1146 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1145, ptr %state, ptr %RAX, i64 %v1142, i64 %v1144)
  store ptr %v1146, ptr %MEMORY, align 8
  %v1147 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1147, ptr %PC, align 8
  %v1148 = add i64 %v1147, 1
  store i64 %v1148, ptr %NEXT_PC, align 8
  %v1149 = load ptr, ptr %MEMORY, align 8
  %v1150 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1149, ptr %state, ptr %NEXT_PC)
  store ptr %v1150, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658307:                                    ; No predecessors!
  %v1151 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1151, ptr %PC, align 8
  %v1152 = add i64 %v1151, 1
  store i64 %v1152, ptr %NEXT_PC, align 8
  %v1153 = load ptr, ptr %MEMORY, align 8
  %v1154 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1153, ptr %state, ptr undef)
  store ptr %v1154, ptr %MEMORY, align 8
  %v1155 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1155, ptr %PC, align 8
  %v1156 = add i64 %v1155, 1
  store i64 %v1156, ptr %NEXT_PC, align 8
  %v1157 = load ptr, ptr %MEMORY, align 8
  %v1158 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1157, ptr %state, ptr undef)
  store ptr %v1158, ptr %MEMORY, align 8
  %v1159 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1159, ptr %PC, align 8
  %v1160 = add i64 %v1159, 1
  store i64 %v1160, ptr %NEXT_PC, align 8
  %v1161 = load ptr, ptr %MEMORY, align 8
  %v1162 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1161, ptr %state, ptr undef)
  store ptr %v1162, ptr %MEMORY, align 8
  %v1163 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1163, ptr %PC, align 8
  %v1164 = add i64 %v1163, 1
  store i64 %v1164, ptr %NEXT_PC, align 8
  %v1165 = load ptr, ptr %MEMORY, align 8
  %v1166 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1165, ptr %state, ptr undef)
  store ptr %v1166, ptr %MEMORY, align 8
  %v1167 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1167, ptr %PC, align 8
  %v1168 = add i64 %v1167, 1
  store i64 %v1168, ptr %NEXT_PC, align 8
  %v1169 = load ptr, ptr %MEMORY, align 8
  %v1170 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1169, ptr %state, ptr undef)
  store ptr %v1170, ptr %MEMORY, align 8
  %v1171 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1171, ptr %PC, align 8
  %v1172 = add i64 %v1171, 1
  store i64 %v1172, ptr %NEXT_PC, align 8
  %v1173 = load ptr, ptr %MEMORY, align 8
  %v1174 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1173, ptr %state, ptr undef)
  store ptr %v1174, ptr %MEMORY, align 8
  %v1175 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1175, ptr %PC, align 8
  %v1176 = add i64 %v1175, 1
  store i64 %v1176, ptr %NEXT_PC, align 8
  %v1177 = load ptr, ptr %MEMORY, align 8
  %v1178 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1177, ptr %state, ptr undef)
  store ptr %v1178, ptr %MEMORY, align 8
  %v1179 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1179, ptr %PC, align 8
  %v1180 = add i64 %v1179, 1
  store i64 %v1180, ptr %NEXT_PC, align 8
  %v1181 = load ptr, ptr %MEMORY, align 8
  %v1182 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1181, ptr %state, ptr undef)
  store ptr %v1182, ptr %MEMORY, align 8
  %v1183 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1183, ptr %PC, align 8
  %v1184 = add i64 %v1183, 1
  store i64 %v1184, ptr %NEXT_PC, align 8
  %v1185 = load ptr, ptr %MEMORY, align 8
  %v1186 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1185, ptr %state, ptr undef)
  store ptr %v1186, ptr %MEMORY, align 8
  %v1187 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1187, ptr %PC, align 8
  %v1188 = add i64 %v1187, 1
  store i64 %v1188, ptr %NEXT_PC, align 8
  %v1189 = load ptr, ptr %MEMORY, align 8
  %v1190 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1189, ptr %state, ptr undef)
  store ptr %v1190, ptr %MEMORY, align 8
  %v1191 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1191, ptr %PC, align 8
  %v1192 = add i64 %v1191, 1
  store i64 %v1192, ptr %NEXT_PC, align 8
  %v1193 = load ptr, ptr %MEMORY, align 8
  %v1194 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1193, ptr %state, ptr undef)
  store ptr %v1194, ptr %MEMORY, align 8
  %v1195 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1195, ptr %PC, align 8
  %v1196 = add i64 %v1195, 1
  store i64 %v1196, ptr %NEXT_PC, align 8
  %v1197 = load ptr, ptr %MEMORY, align 8
  %v1198 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1197, ptr %state, ptr undef)
  store ptr %v1198, ptr %MEMORY, align 8
  %v1199 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1199, ptr %PC, align 8
  %v1200 = add i64 %v1199, 1
  store i64 %v1200, ptr %NEXT_PC, align 8
  %v1201 = load ptr, ptr %MEMORY, align 8
  %v1202 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1201, ptr %state, ptr undef)
  store ptr %v1202, ptr %MEMORY, align 8
  %v1203 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1203, ptr %PC, align 8
  %v1204 = add i64 %v1203, 3
  store i64 %v1204, ptr %NEXT_PC, align 8
  %v1205 = load i64, ptr %RCX, align 8
  %v1206 = add i64 %v1205, 20
  %v1207 = load ptr, ptr %MEMORY, align 8
  %v1208 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1207, ptr %state, ptr %RAX, i64 %v1206)
  store ptr %v1208, ptr %MEMORY, align 8
  %v1209 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1209, ptr %PC, align 8
  %v1210 = add i64 %v1209, 1
  store i64 %v1210, ptr %NEXT_PC, align 8
  %v1211 = load ptr, ptr %MEMORY, align 8
  %v1212 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1211, ptr %state, ptr %NEXT_PC)
  store ptr %v1212, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658324:                                    ; No predecessors!
  %v1213 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1213, ptr %PC, align 8
  %v1214 = add i64 %v1213, 1
  store i64 %v1214, ptr %NEXT_PC, align 8
  %v1215 = load ptr, ptr %MEMORY, align 8
  %v1216 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1215, ptr %state, ptr undef)
  store ptr %v1216, ptr %MEMORY, align 8
  %v1217 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1217, ptr %PC, align 8
  %v1218 = add i64 %v1217, 1
  store i64 %v1218, ptr %NEXT_PC, align 8
  %v1219 = load ptr, ptr %MEMORY, align 8
  %v1220 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1219, ptr %state, ptr undef)
  store ptr %v1220, ptr %MEMORY, align 8
  %v1221 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1221, ptr %PC, align 8
  %v1222 = add i64 %v1221, 1
  store i64 %v1222, ptr %NEXT_PC, align 8
  %v1223 = load ptr, ptr %MEMORY, align 8
  %v1224 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1223, ptr %state, ptr undef)
  store ptr %v1224, ptr %MEMORY, align 8
  %v1225 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1225, ptr %PC, align 8
  %v1226 = add i64 %v1225, 1
  store i64 %v1226, ptr %NEXT_PC, align 8
  %v1227 = load ptr, ptr %MEMORY, align 8
  %v1228 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1227, ptr %state, ptr undef)
  store ptr %v1228, ptr %MEMORY, align 8
  %v1229 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1229, ptr %PC, align 8
  %v1230 = add i64 %v1229, 1
  store i64 %v1230, ptr %NEXT_PC, align 8
  %v1231 = load ptr, ptr %MEMORY, align 8
  %v1232 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1231, ptr %state, ptr undef)
  store ptr %v1232, ptr %MEMORY, align 8
  %v1233 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1233, ptr %PC, align 8
  %v1234 = add i64 %v1233, 1
  store i64 %v1234, ptr %NEXT_PC, align 8
  %v1235 = load ptr, ptr %MEMORY, align 8
  %v1236 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1235, ptr %state, ptr undef)
  store ptr %v1236, ptr %MEMORY, align 8
  %v1237 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1237, ptr %PC, align 8
  %v1238 = add i64 %v1237, 1
  store i64 %v1238, ptr %NEXT_PC, align 8
  %v1239 = load ptr, ptr %MEMORY, align 8
  %v1240 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1239, ptr %state, ptr undef)
  store ptr %v1240, ptr %MEMORY, align 8
  %v1241 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1241, ptr %PC, align 8
  %v1242 = add i64 %v1241, 1
  store i64 %v1242, ptr %NEXT_PC, align 8
  %v1243 = load ptr, ptr %MEMORY, align 8
  %v1244 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1243, ptr %state, ptr undef)
  store ptr %v1244, ptr %MEMORY, align 8
  %v1245 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1245, ptr %PC, align 8
  %v1246 = add i64 %v1245, 1
  store i64 %v1246, ptr %NEXT_PC, align 8
  %v1247 = load ptr, ptr %MEMORY, align 8
  %v1248 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1247, ptr %state, ptr undef)
  store ptr %v1248, ptr %MEMORY, align 8
  %v1249 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1249, ptr %PC, align 8
  %v1250 = add i64 %v1249, 1
  store i64 %v1250, ptr %NEXT_PC, align 8
  %v1251 = load ptr, ptr %MEMORY, align 8
  %v1252 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1251, ptr %state, ptr undef)
  store ptr %v1252, ptr %MEMORY, align 8
  %v1253 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1253, ptr %PC, align 8
  %v1254 = add i64 %v1253, 1
  store i64 %v1254, ptr %NEXT_PC, align 8
  %v1255 = load ptr, ptr %MEMORY, align 8
  %v1256 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1255, ptr %state, ptr undef)
  store ptr %v1256, ptr %MEMORY, align 8
  %v1257 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1257, ptr %PC, align 8
  %v1258 = add i64 %v1257, 1
  store i64 %v1258, ptr %NEXT_PC, align 8
  %v1259 = load ptr, ptr %MEMORY, align 8
  %v1260 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1259, ptr %state, ptr undef)
  store ptr %v1260, ptr %MEMORY, align 8
  %v1261 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1261, ptr %PC, align 8
  %v1262 = add i64 %v1261, 5
  store i64 %v1262, ptr %NEXT_PC, align 8
  %v1263 = load i64, ptr %RSP, align 8
  %v1264 = add i64 %v1263, 8
  %v1265 = load i64, ptr %RBX, align 8
  %v1266 = load ptr, ptr %MEMORY, align 8
  %v1267 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1266, ptr %state, i64 %v1264, i64 %v1265)
  store ptr %v1267, ptr %MEMORY, align 8
  %v1268 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1268, ptr %PC, align 8
  %v1269 = add i64 %v1268, 5
  store i64 %v1269, ptr %NEXT_PC, align 8
  %v1270 = load i64, ptr %RSP, align 8
  %v1271 = add i64 %v1270, 16
  %v1272 = load i64, ptr %RSI, align 8
  %v1273 = load ptr, ptr %MEMORY, align 8
  %v1274 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1273, ptr %state, i64 %v1271, i64 %v1272)
  store ptr %v1274, ptr %MEMORY, align 8
  %v1275 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1275, ptr %PC, align 8
  %v1276 = add i64 %v1275, 1
  store i64 %v1276, ptr %NEXT_PC, align 8
  %v1277 = load i64, ptr %RDI, align 8
  %v1278 = load ptr, ptr %MEMORY, align 8
  %v1279 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v1278, ptr %state, i64 %v1277)
  store ptr %v1279, ptr %MEMORY, align 8
  %v1280 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1280, ptr %PC, align 8
  %v1281 = add i64 %v1280, 4
  store i64 %v1281, ptr %NEXT_PC, align 8
  %v1282 = load i64, ptr %RSP, align 8
  %v1283 = load ptr, ptr %MEMORY, align 8
  %v1284 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1283, ptr %state, ptr %RSP, i64 %v1282, i64 32)
  store ptr %v1284, ptr %MEMORY, align 8
  %v1285 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1285, ptr %PC, align 8
  %v1286 = add i64 %v1285, 2
  store i64 %v1286, ptr %NEXT_PC, align 8
  %v1287 = load i32, ptr %EDX, align 4
  %v1288 = zext i32 %v1287 to i64
  %v1289 = load ptr, ptr %MEMORY, align 8
  %v1290 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1289, ptr %state, ptr %RDI, i64 %v1288)
  store ptr %v1290, ptr %MEMORY, align 8
  %v1291 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1291, ptr %PC, align 8
  %v1292 = add i64 %v1291, 3
  store i64 %v1292, ptr %NEXT_PC, align 8
  %v1293 = load i64, ptr %RCX, align 8
  %v1294 = load ptr, ptr %MEMORY, align 8
  %v1295 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1294, ptr %state, ptr %RSI, i64 %v1293)
  store ptr %v1295, ptr %MEMORY, align 8
  %v1296 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1296, ptr %PC, align 8
  %v1297 = add i64 %v1296, 3
  store i64 %v1297, ptr %NEXT_PC, align 8
  %v1298 = load i64, ptr %RCX, align 8
  %v1299 = load ptr, ptr %MEMORY, align 8
  %v1300 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1299, ptr %state, ptr %RBX, i64 %v1298)
  store ptr %v1300, ptr %MEMORY, align 8
  %v1301 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1301, ptr %PC, align 8
  %v1302 = add i64 %v1301, 5
  store i64 %v1302, ptr %NEXT_PC, align 8
  %v1303 = load i64, ptr %NEXT_PC, align 8
  %v1304 = add i64 %v1303, 212
  %v1305 = load i64, ptr %NEXT_PC, align 8
  %v1306 = load ptr, ptr %MEMORY, align 8
  %v1307 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1306, ptr %state, i64 %v1304, ptr %NEXT_PC, i64 %v1305, ptr %RETURN_PC)
  store ptr %v1307, ptr %MEMORY, align 8
  %v1308 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1308, ptr %PC, align 8
  %v1309 = add i64 %v1308, 2
  store i64 %v1309, ptr %NEXT_PC, align 8
  %v1310 = load i64, ptr %RDI, align 8
  %v1311 = load i32, ptr %EAX, align 4
  %v1312 = zext i32 %v1311 to i64
  %v1313 = load ptr, ptr %MEMORY, align 8
  %v1314 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1313, ptr %state, ptr %RDI, i64 %v1310, i64 %v1312)
  store ptr %v1314, ptr %MEMORY, align 8
  %v1315 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1315, ptr %PC, align 8
  %v1316 = add i64 %v1315, 3
  store i64 %v1316, ptr %NEXT_PC, align 8
  %v1317 = load i64, ptr %RBX, align 8
  %v1318 = load i64, ptr %RBX, align 8
  %v1319 = load ptr, ptr %MEMORY, align 8
  %v1320 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1319, ptr %state, i64 %v1317, i64 %v1318)
  store ptr %v1320, ptr %MEMORY, align 8
  %v1321 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1321, ptr %PC, align 8
  %v1322 = add i64 %v1321, 2
  store i64 %v1322, ptr %NEXT_PC, align 8
  %v1323 = load i64, ptr %NEXT_PC, align 8
  %v1324 = add i64 %v1323, 14
  %v1325 = load i64, ptr %NEXT_PC, align 8
  %v1326 = load ptr, ptr %MEMORY, align 8
  %v1327 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1326, ptr %state, ptr %BRANCH_TAKEN, i64 %v1324, i64 %v1325, ptr %NEXT_PC)
  store ptr %v1327, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658385, label %bb_5395658371

bb_5395658371:                                    ; preds = %bb_5395658376, %bb_5395658324
  %v1328 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1328, ptr %PC, align 8
  %v1329 = add i64 %v1328, 3
  store i64 %v1329, ptr %NEXT_PC, align 8
  %v1330 = load i64, ptr %RDI, align 8
  %v1331 = load i64, ptr %RBX, align 8
  %v1332 = add i64 %v1331, 32
  %v1333 = load ptr, ptr %MEMORY, align 8
  %v1334 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1333, ptr %state, ptr %RDI, i64 %v1330, i64 %v1332)
  store ptr %v1334, ptr %MEMORY, align 8
  %v1335 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1335, ptr %PC, align 8
  %v1336 = add i64 %v1335, 2
  store i64 %v1336, ptr %NEXT_PC, align 8
  %v1337 = load i64, ptr %NEXT_PC, align 8
  %v1338 = add i64 %v1337, 29
  %v1339 = load i64, ptr %NEXT_PC, align 8
  %v1340 = load ptr, ptr %MEMORY, align 8
  %v1341 = call ptr @_ZN12_GLOBAL__N_13JNSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1340, ptr %state, ptr %BRANCH_TAKEN, i64 %v1338, i64 %v1339, ptr %NEXT_PC)
  store ptr %v1341, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658405, label %bb_5395658376

bb_5395658376:                                    ; preds = %bb_5395658371
  %v1342 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1342, ptr %PC, align 8
  %v1343 = add i64 %v1342, 4
  store i64 %v1343, ptr %NEXT_PC, align 8
  %v1344 = load i64, ptr %RBX, align 8
  %v1345 = add i64 %v1344, 8
  %v1346 = load ptr, ptr %MEMORY, align 8
  %v1347 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1346, ptr %state, ptr %RBX, i64 %v1345)
  store ptr %v1347, ptr %MEMORY, align 8
  %v1348 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1348, ptr %PC, align 8
  %v1349 = add i64 %v1348, 3
  store i64 %v1349, ptr %NEXT_PC, align 8
  %v1350 = load i64, ptr %RBX, align 8
  %v1351 = load i64, ptr %RBX, align 8
  %v1352 = load ptr, ptr %MEMORY, align 8
  %v1353 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1352, ptr %state, i64 %v1350, i64 %v1351)
  store ptr %v1353, ptr %MEMORY, align 8
  %v1354 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1354, ptr %PC, align 8
  %v1355 = add i64 %v1354, 2
  store i64 %v1355, ptr %NEXT_PC, align 8
  %v1356 = load i64, ptr %NEXT_PC, align 8
  %v1357 = sub i64 %v1356, 14
  %v1358 = load i64, ptr %NEXT_PC, align 8
  %v1359 = load ptr, ptr %MEMORY, align 8
  %v1360 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1359, ptr %state, ptr %BRANCH_TAKEN, i64 %v1357, i64 %v1358, ptr %NEXT_PC)
  store ptr %v1360, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658371, label %bb_5395658385

bb_5395658385:                                    ; preds = %bb_5395658376, %bb_5395658324
  %v1361 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1361, ptr %PC, align 8
  %v1362 = add i64 %v1361, 4
  store i64 %v1362, ptr %NEXT_PC, align 8
  %v1363 = load i64, ptr %RSI, align 8
  %v1364 = add i64 %v1363, 24
  %v1365 = load ptr, ptr %MEMORY, align 8
  %v1366 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1365, ptr %state, ptr %RAX, i64 %v1364)
  store ptr %v1366, ptr %MEMORY, align 8
  %v1367 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1367, ptr %PC, align 8
  %v1368 = add i64 %v1367, 5
  store i64 %v1368, ptr %NEXT_PC, align 8
  %v1369 = load i64, ptr %RSP, align 8
  %v1370 = add i64 %v1369, 48
  %v1371 = load ptr, ptr %MEMORY, align 8
  %v1372 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1371, ptr %state, ptr %RBX, i64 %v1370)
  store ptr %v1372, ptr %MEMORY, align 8
  %v1373 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1373, ptr %PC, align 8
  %v1374 = add i64 %v1373, 5
  store i64 %v1374, ptr %NEXT_PC, align 8
  %v1375 = load i64, ptr %RSP, align 8
  %v1376 = add i64 %v1375, 56
  %v1377 = load ptr, ptr %MEMORY, align 8
  %v1378 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1377, ptr %state, ptr %RSI, i64 %v1376)
  store ptr %v1378, ptr %MEMORY, align 8
  %v1379 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1379, ptr %PC, align 8
  %v1380 = add i64 %v1379, 4
  store i64 %v1380, ptr %NEXT_PC, align 8
  %v1381 = load i64, ptr %RSP, align 8
  %v1382 = load ptr, ptr %MEMORY, align 8
  %v1383 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1382, ptr %state, ptr %RSP, i64 %v1381, i64 32)
  store ptr %v1383, ptr %MEMORY, align 8
  %v1384 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1384, ptr %PC, align 8
  %v1385 = add i64 %v1384, 1
  store i64 %v1385, ptr %NEXT_PC, align 8
  %v1386 = load ptr, ptr %MEMORY, align 8
  %v1387 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1386, ptr %state, ptr %RDI)
  store ptr %v1387, ptr %MEMORY, align 8
  %v1388 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1388, ptr %PC, align 8
  %v1389 = add i64 %v1388, 1
  store i64 %v1389, ptr %NEXT_PC, align 8
  %v1390 = load ptr, ptr %MEMORY, align 8
  %v1391 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1390, ptr %state, ptr %NEXT_PC)
  store ptr %v1391, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658405:                                    ; preds = %bb_5395658371
  %v1392 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1392, ptr %PC, align 8
  %v1393 = add i64 %v1392, 5
  store i64 %v1393, ptr %NEXT_PC, align 8
  %v1394 = load i64, ptr %RSP, align 8
  %v1395 = add i64 %v1394, 56
  %v1396 = load ptr, ptr %MEMORY, align 8
  %v1397 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1396, ptr %state, ptr %RSI, i64 %v1395)
  store ptr %v1397, ptr %MEMORY, align 8
  %v1398 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1398, ptr %PC, align 8
  %v1399 = add i64 %v1398, 3
  store i64 %v1399, ptr %NEXT_PC, align 8
  %v1400 = load i32, ptr %EDI, align 4
  %v1401 = zext i32 %v1400 to i64
  %v1402 = load ptr, ptr %MEMORY, align 8
  %v1403 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v1402, ptr %state, ptr %RAX, i64 %v1401)
  store ptr %v1403, ptr %MEMORY, align 8
  %v1404 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1404, ptr %PC, align 8
  %v1405 = add i64 %v1404, 4
  store i64 %v1405, ptr %NEXT_PC, align 8
  %v1406 = load i64, ptr %RAX, align 8
  %v1407 = load i64, ptr %RAX, align 8
  %v1408 = mul i64 %v1407, 4
  %v1409 = add i64 %v1406, %v1408
  %v1410 = load ptr, ptr %MEMORY, align 8
  %v1411 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1410, ptr %state, ptr %RCX, i64 %v1409)
  store ptr %v1411, ptr %MEMORY, align 8
  %v1412 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1412, ptr %PC, align 8
  %v1413 = add i64 %v1412, 4
  store i64 %v1413, ptr %NEXT_PC, align 8
  %v1414 = load i64, ptr %RBX, align 8
  %v1415 = add i64 %v1414, 24
  %v1416 = load ptr, ptr %MEMORY, align 8
  %v1417 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1416, ptr %state, ptr %RAX, i64 %v1415)
  store ptr %v1417, ptr %MEMORY, align 8
  %v1418 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1418, ptr %PC, align 8
  %v1419 = add i64 %v1418, 5
  store i64 %v1419, ptr %NEXT_PC, align 8
  %v1420 = load i64, ptr %RSP, align 8
  %v1421 = add i64 %v1420, 48
  %v1422 = load ptr, ptr %MEMORY, align 8
  %v1423 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1422, ptr %state, ptr %RBX, i64 %v1421)
  store ptr %v1423, ptr %MEMORY, align 8
  %v1424 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1424, ptr %PC, align 8
  %v1425 = add i64 %v1424, 4
  store i64 %v1425, ptr %NEXT_PC, align 8
  %v1426 = load i64, ptr %RAX, align 8
  %v1427 = load i64, ptr %RCX, align 8
  %v1428 = mul i64 %v1427, 8
  %v1429 = add i64 %v1426, %v1428
  %v1430 = load ptr, ptr %MEMORY, align 8
  %v1431 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1430, ptr %state, ptr %RAX, i64 %v1429)
  store ptr %v1431, ptr %MEMORY, align 8
  %v1432 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1432, ptr %PC, align 8
  %v1433 = add i64 %v1432, 4
  store i64 %v1433, ptr %NEXT_PC, align 8
  %v1434 = load i64, ptr %RSP, align 8
  %v1435 = load ptr, ptr %MEMORY, align 8
  %v1436 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1435, ptr %state, ptr %RSP, i64 %v1434, i64 32)
  store ptr %v1436, ptr %MEMORY, align 8
  %v1437 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1437, ptr %PC, align 8
  %v1438 = add i64 %v1437, 1
  store i64 %v1438, ptr %NEXT_PC, align 8
  %v1439 = load ptr, ptr %MEMORY, align 8
  %v1440 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1439, ptr %state, ptr %RDI)
  store ptr %v1440, ptr %MEMORY, align 8
  %v1441 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1441, ptr %PC, align 8
  %v1442 = add i64 %v1441, 1
  store i64 %v1442, ptr %NEXT_PC, align 8
  %v1443 = load ptr, ptr %MEMORY, align 8
  %v1444 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1443, ptr %state, ptr %NEXT_PC)
  store ptr %v1444, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658436:                                    ; No predecessors!
  %v1445 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1445, ptr %PC, align 8
  %v1446 = add i64 %v1445, 1
  store i64 %v1446, ptr %NEXT_PC, align 8
  %v1447 = load ptr, ptr %MEMORY, align 8
  %v1448 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1447, ptr %state, ptr undef)
  store ptr %v1448, ptr %MEMORY, align 8
  %v1449 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1449, ptr %PC, align 8
  %v1450 = add i64 %v1449, 1
  store i64 %v1450, ptr %NEXT_PC, align 8
  %v1451 = load ptr, ptr %MEMORY, align 8
  %v1452 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1451, ptr %state, ptr undef)
  store ptr %v1452, ptr %MEMORY, align 8
  %v1453 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1453, ptr %PC, align 8
  %v1454 = add i64 %v1453, 1
  store i64 %v1454, ptr %NEXT_PC, align 8
  %v1455 = load ptr, ptr %MEMORY, align 8
  %v1456 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1455, ptr %state, ptr undef)
  store ptr %v1456, ptr %MEMORY, align 8
  %v1457 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1457, ptr %PC, align 8
  %v1458 = add i64 %v1457, 1
  store i64 %v1458, ptr %NEXT_PC, align 8
  %v1459 = load ptr, ptr %MEMORY, align 8
  %v1460 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1459, ptr %state, ptr undef)
  store ptr %v1460, ptr %MEMORY, align 8
  %v1461 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1461, ptr %PC, align 8
  %v1462 = add i64 %v1461, 1
  store i64 %v1462, ptr %NEXT_PC, align 8
  %v1463 = load ptr, ptr %MEMORY, align 8
  %v1464 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1463, ptr %state, ptr undef)
  store ptr %v1464, ptr %MEMORY, align 8
  %v1465 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1465, ptr %PC, align 8
  %v1466 = add i64 %v1465, 1
  store i64 %v1466, ptr %NEXT_PC, align 8
  %v1467 = load ptr, ptr %MEMORY, align 8
  %v1468 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1467, ptr %state, ptr undef)
  store ptr %v1468, ptr %MEMORY, align 8
  %v1469 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1469, ptr %PC, align 8
  %v1470 = add i64 %v1469, 1
  store i64 %v1470, ptr %NEXT_PC, align 8
  %v1471 = load ptr, ptr %MEMORY, align 8
  %v1472 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1471, ptr %state, ptr undef)
  store ptr %v1472, ptr %MEMORY, align 8
  %v1473 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1473, ptr %PC, align 8
  %v1474 = add i64 %v1473, 1
  store i64 %v1474, ptr %NEXT_PC, align 8
  %v1475 = load ptr, ptr %MEMORY, align 8
  %v1476 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1475, ptr %state, ptr undef)
  store ptr %v1476, ptr %MEMORY, align 8
  %v1477 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1477, ptr %PC, align 8
  %v1478 = add i64 %v1477, 1
  store i64 %v1478, ptr %NEXT_PC, align 8
  %v1479 = load ptr, ptr %MEMORY, align 8
  %v1480 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1479, ptr %state, ptr undef)
  store ptr %v1480, ptr %MEMORY, align 8
  %v1481 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1481, ptr %PC, align 8
  %v1482 = add i64 %v1481, 1
  store i64 %v1482, ptr %NEXT_PC, align 8
  %v1483 = load ptr, ptr %MEMORY, align 8
  %v1484 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1483, ptr %state, ptr undef)
  store ptr %v1484, ptr %MEMORY, align 8
  %v1485 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1485, ptr %PC, align 8
  %v1486 = add i64 %v1485, 1
  store i64 %v1486, ptr %NEXT_PC, align 8
  %v1487 = load ptr, ptr %MEMORY, align 8
  %v1488 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1487, ptr %state, ptr undef)
  store ptr %v1488, ptr %MEMORY, align 8
  %v1489 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1489, ptr %PC, align 8
  %v1490 = add i64 %v1489, 1
  store i64 %v1490, ptr %NEXT_PC, align 8
  %v1491 = load ptr, ptr %MEMORY, align 8
  %v1492 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1491, ptr %state, ptr undef)
  store ptr %v1492, ptr %MEMORY, align 8
  %v1493 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1493, ptr %PC, align 8
  %v1494 = add i64 %v1493, 5
  store i64 %v1494, ptr %NEXT_PC, align 8
  %v1495 = load i64, ptr %RSP, align 8
  %v1496 = add i64 %v1495, 8
  %v1497 = load i64, ptr %RBX, align 8
  %v1498 = load ptr, ptr %MEMORY, align 8
  %v1499 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1498, ptr %state, i64 %v1496, i64 %v1497)
  store ptr %v1499, ptr %MEMORY, align 8
  %v1500 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1500, ptr %PC, align 8
  %v1501 = add i64 %v1500, 5
  store i64 %v1501, ptr %NEXT_PC, align 8
  %v1502 = load i64, ptr %RSP, align 8
  %v1503 = add i64 %v1502, 16
  %v1504 = load i64, ptr %RBP, align 8
  %v1505 = load ptr, ptr %MEMORY, align 8
  %v1506 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1505, ptr %state, i64 %v1503, i64 %v1504)
  store ptr %v1506, ptr %MEMORY, align 8
  %v1507 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1507, ptr %PC, align 8
  %v1508 = add i64 %v1507, 5
  store i64 %v1508, ptr %NEXT_PC, align 8
  %v1509 = load i64, ptr %RSP, align 8
  %v1510 = add i64 %v1509, 24
  %v1511 = load i64, ptr %RSI, align 8
  %v1512 = load ptr, ptr %MEMORY, align 8
  %v1513 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1512, ptr %state, i64 %v1510, i64 %v1511)
  store ptr %v1513, ptr %MEMORY, align 8
  %v1514 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1514, ptr %PC, align 8
  %v1515 = add i64 %v1514, 1
  store i64 %v1515, ptr %NEXT_PC, align 8
  %v1516 = load i64, ptr %RDI, align 8
  %v1517 = load ptr, ptr %MEMORY, align 8
  %v1518 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v1517, ptr %state, i64 %v1516)
  store ptr %v1518, ptr %MEMORY, align 8
  %v1519 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1519, ptr %PC, align 8
  %v1520 = add i64 %v1519, 4
  store i64 %v1520, ptr %NEXT_PC, align 8
  %v1521 = load i64, ptr %RSP, align 8
  %v1522 = load ptr, ptr %MEMORY, align 8
  %v1523 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1522, ptr %state, ptr %RSP, i64 %v1521, i64 32)
  store ptr %v1523, ptr %MEMORY, align 8
  %v1524 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1524, ptr %PC, align 8
  %v1525 = add i64 %v1524, 3
  store i64 %v1525, ptr %NEXT_PC, align 8
  %v1526 = load i64, ptr %RDX, align 8
  %v1527 = load ptr, ptr %MEMORY, align 8
  %v1528 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1527, ptr %state, ptr %RBP, i64 %v1526)
  store ptr %v1528, ptr %MEMORY, align 8
  %v1529 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1529, ptr %PC, align 8
  %v1530 = add i64 %v1529, 3
  store i64 %v1530, ptr %NEXT_PC, align 8
  %v1531 = load i64, ptr %RCX, align 8
  %v1532 = load ptr, ptr %MEMORY, align 8
  %v1533 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1532, ptr %state, ptr %RDI, i64 %v1531)
  store ptr %v1533, ptr %MEMORY, align 8
  %v1534 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1534, ptr %PC, align 8
  %v1535 = add i64 %v1534, 2
  store i64 %v1535, ptr %NEXT_PC, align 8
  %v1536 = load i64, ptr %RBX, align 8
  %v1537 = load i32, ptr %EBX, align 4
  %v1538 = zext i32 %v1537 to i64
  %v1539 = load ptr, ptr %MEMORY, align 8
  %v1540 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1539, ptr %state, ptr %RBX, i64 %v1536, i64 %v1538)
  store ptr %v1540, ptr %MEMORY, align 8
  %v1541 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1541, ptr %PC, align 8
  %v1542 = add i64 %v1541, 5
  store i64 %v1542, ptr %NEXT_PC, align 8
  %v1543 = load i64, ptr %NEXT_PC, align 8
  %v1544 = add i64 %v1543, 95
  %v1545 = load i64, ptr %NEXT_PC, align 8
  %v1546 = load ptr, ptr %MEMORY, align 8
  %v1547 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1546, ptr %state, i64 %v1544, ptr %NEXT_PC, i64 %v1545, ptr %RETURN_PC)
  store ptr %v1547, ptr %MEMORY, align 8
  %v1548 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1548, ptr %PC, align 8
  %v1549 = add i64 %v1548, 2
  store i64 %v1549, ptr %NEXT_PC, align 8
  %v1550 = load i32, ptr %EAX, align 4
  %v1551 = zext i32 %v1550 to i64
  %v1552 = load i32, ptr %EAX, align 4
  %v1553 = zext i32 %v1552 to i64
  %v1554 = load ptr, ptr %MEMORY, align 8
  %v1555 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1554, ptr %state, i64 %v1551, i64 %v1553)
  store ptr %v1555, ptr %MEMORY, align 8
  %v1556 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1556, ptr %PC, align 8
  %v1557 = add i64 %v1556, 2
  store i64 %v1557, ptr %NEXT_PC, align 8
  %v1558 = load i64, ptr %NEXT_PC, align 8
  %v1559 = add i64 %v1558, 42
  %v1560 = load i64, ptr %NEXT_PC, align 8
  %v1561 = load ptr, ptr %MEMORY, align 8
  %v1562 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1561, ptr %state, ptr %BRANCH_TAKEN, i64 %v1559, i64 %v1560, ptr %NEXT_PC)
  store ptr %v1562, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658527, label %bb_5395658485

bb_5395658485:                                    ; preds = %bb_5395658513, %bb_5395658436
  %v1563 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1563, ptr %PC, align 8
  %v1564 = add i64 %v1563, 2
  store i64 %v1564, ptr %NEXT_PC, align 8
  %v1565 = load i32, ptr %EBX, align 4
  %v1566 = zext i32 %v1565 to i64
  %v1567 = load ptr, ptr %MEMORY, align 8
  %v1568 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1567, ptr %state, ptr %RDX, i64 %v1566)
  store ptr %v1568, ptr %MEMORY, align 8
  %v1569 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1569, ptr %PC, align 8
  %v1570 = add i64 %v1569, 3
  store i64 %v1570, ptr %NEXT_PC, align 8
  %v1571 = load i64, ptr %RDI, align 8
  %v1572 = load ptr, ptr %MEMORY, align 8
  %v1573 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1572, ptr %state, ptr %RCX, i64 %v1571)
  store ptr %v1573, ptr %MEMORY, align 8
  %v1574 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1574, ptr %PC, align 8
  %v1575 = add i64 %v1574, 5
  store i64 %v1575, ptr %NEXT_PC, align 8
  %v1576 = load i64, ptr %NEXT_PC, align 8
  %v1577 = sub i64 %v1576, 159
  %v1578 = load i64, ptr %NEXT_PC, align 8
  %v1579 = load ptr, ptr %MEMORY, align 8
  %v1580 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1579, ptr %state, i64 %v1577, ptr %NEXT_PC, i64 %v1578, ptr %RETURN_PC)
  store ptr %v1580, ptr %MEMORY, align 8
  %v1581 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1581, ptr %PC, align 8
  %v1582 = add i64 %v1581, 3
  store i64 %v1582, ptr %NEXT_PC, align 8
  %v1583 = load i64, ptr %RBP, align 8
  %v1584 = load ptr, ptr %MEMORY, align 8
  %v1585 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1584, ptr %state, ptr %RDX, i64 %v1583)
  store ptr %v1585, ptr %MEMORY, align 8
  %v1586 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1586, ptr %PC, align 8
  %v1587 = add i64 %v1586, 3
  store i64 %v1587, ptr %NEXT_PC, align 8
  %v1588 = load i64, ptr %RAX, align 8
  %v1589 = load ptr, ptr %MEMORY, align 8
  %v1590 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1589, ptr %state, ptr %RSI, i64 %v1588)
  store ptr %v1590, ptr %MEMORY, align 8
  %v1591 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1591, ptr %PC, align 8
  %v1592 = add i64 %v1591, 3
  store i64 %v1592, ptr %NEXT_PC, align 8
  %v1593 = load i64, ptr %RAX, align 8
  %v1594 = load ptr, ptr %MEMORY, align 8
  %v1595 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1594, ptr %state, ptr %RCX, i64 %v1593)
  store ptr %v1595, ptr %MEMORY, align 8
  %v1596 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1596, ptr %PC, align 8
  %v1597 = add i64 %v1596, 5
  store i64 %v1597, ptr %NEXT_PC, align 8
  %v1598 = load i64, ptr %NEXT_PC, align 8
  %v1599 = add i64 %v1598, 45811
  %v1600 = load i64, ptr %NEXT_PC, align 8
  %v1601 = load ptr, ptr %MEMORY, align 8
  %v1602 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1601, ptr %state, i64 %v1599, ptr %NEXT_PC, i64 %v1600, ptr %RETURN_PC)
  store ptr %v1602, ptr %MEMORY, align 8
  %v1603 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1603, ptr %PC, align 8
  %v1604 = add i64 %v1603, 2
  store i64 %v1604, ptr %NEXT_PC, align 8
  %v1605 = load i32, ptr %EAX, align 4
  %v1606 = zext i32 %v1605 to i64
  %v1607 = load i32, ptr %EAX, align 4
  %v1608 = zext i32 %v1607 to i64
  %v1609 = load ptr, ptr %MEMORY, align 8
  %v1610 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1609, ptr %state, i64 %v1606, i64 %v1608)
  store ptr %v1610, ptr %MEMORY, align 8
  %v1611 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1611, ptr %PC, align 8
  %v1612 = add i64 %v1611, 2
  store i64 %v1612, ptr %NEXT_PC, align 8
  %v1613 = load i64, ptr %NEXT_PC, align 8
  %v1614 = add i64 %v1613, 37
  %v1615 = load i64, ptr %NEXT_PC, align 8
  %v1616 = load ptr, ptr %MEMORY, align 8
  %v1617 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1616, ptr %state, ptr %BRANCH_TAKEN, i64 %v1614, i64 %v1615, ptr %NEXT_PC)
  store ptr %v1617, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658550, label %bb_5395658513

bb_5395658513:                                    ; preds = %bb_5395658485
  %v1618 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1618, ptr %PC, align 8
  %v1619 = add i64 %v1618, 3
  store i64 %v1619, ptr %NEXT_PC, align 8
  %v1620 = load i64, ptr %RDI, align 8
  %v1621 = load ptr, ptr %MEMORY, align 8
  %v1622 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1621, ptr %state, ptr %RCX, i64 %v1620)
  store ptr %v1622, ptr %MEMORY, align 8
  %v1623 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1623, ptr %PC, align 8
  %v1624 = add i64 %v1623, 2
  store i64 %v1624, ptr %NEXT_PC, align 8
  %v1625 = load i64, ptr %RBX, align 8
  %v1626 = load ptr, ptr %MEMORY, align 8
  %v1627 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1626, ptr %state, ptr %RBX, i64 %v1625)
  store ptr %v1627, ptr %MEMORY, align 8
  %v1628 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1628, ptr %PC, align 8
  %v1629 = add i64 %v1628, 5
  store i64 %v1629, ptr %NEXT_PC, align 8
  %v1630 = load i64, ptr %NEXT_PC, align 8
  %v1631 = add i64 %v1630, 53
  %v1632 = load i64, ptr %NEXT_PC, align 8
  %v1633 = load ptr, ptr %MEMORY, align 8
  %v1634 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1633, ptr %state, i64 %v1631, ptr %NEXT_PC, i64 %v1632, ptr %RETURN_PC)
  store ptr %v1634, ptr %MEMORY, align 8
  %v1635 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1635, ptr %PC, align 8
  %v1636 = add i64 %v1635, 2
  store i64 %v1636, ptr %NEXT_PC, align 8
  %v1637 = load i32, ptr %EBX, align 4
  %v1638 = zext i32 %v1637 to i64
  %v1639 = load i32, ptr %EAX, align 4
  %v1640 = zext i32 %v1639 to i64
  %v1641 = load ptr, ptr %MEMORY, align 8
  %v1642 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1641, ptr %state, i64 %v1638, i64 %v1640)
  store ptr %v1642, ptr %MEMORY, align 8
  %v1643 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1643, ptr %PC, align 8
  %v1644 = add i64 %v1643, 2
  store i64 %v1644, ptr %NEXT_PC, align 8
  %v1645 = load i64, ptr %NEXT_PC, align 8
  %v1646 = sub i64 %v1645, 42
  %v1647 = load i64, ptr %NEXT_PC, align 8
  %v1648 = load ptr, ptr %MEMORY, align 8
  %v1649 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1648, ptr %state, ptr %BRANCH_TAKEN, i64 %v1646, i64 %v1647, ptr %NEXT_PC)
  store ptr %v1649, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658485, label %bb_5395658527

bb_5395658527:                                    ; preds = %bb_5395658513, %bb_5395658436
  %v1650 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1650, ptr %PC, align 8
  %v1651 = add i64 %v1650, 2
  store i64 %v1651, ptr %NEXT_PC, align 8
  %v1652 = load i64, ptr %RAX, align 8
  %v1653 = load i32, ptr %EAX, align 4
  %v1654 = zext i32 %v1653 to i64
  %v1655 = load ptr, ptr %MEMORY, align 8
  %v1656 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1655, ptr %state, ptr %RAX, i64 %v1652, i64 %v1654)
  store ptr %v1656, ptr %MEMORY, align 8
  br label %bb_5395658529

bb_5395658529:                                    ; preds = %bb_5395658550, %bb_5395658527
  %v1657 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1657, ptr %PC, align 8
  %v1658 = add i64 %v1657, 5
  store i64 %v1658, ptr %NEXT_PC, align 8
  %v1659 = load i64, ptr %RSP, align 8
  %v1660 = add i64 %v1659, 48
  %v1661 = load ptr, ptr %MEMORY, align 8
  %v1662 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1661, ptr %state, ptr %RBX, i64 %v1660)
  store ptr %v1662, ptr %MEMORY, align 8
  %v1663 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1663, ptr %PC, align 8
  %v1664 = add i64 %v1663, 5
  store i64 %v1664, ptr %NEXT_PC, align 8
  %v1665 = load i64, ptr %RSP, align 8
  %v1666 = add i64 %v1665, 56
  %v1667 = load ptr, ptr %MEMORY, align 8
  %v1668 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1667, ptr %state, ptr %RBP, i64 %v1666)
  store ptr %v1668, ptr %MEMORY, align 8
  %v1669 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1669, ptr %PC, align 8
  %v1670 = add i64 %v1669, 5
  store i64 %v1670, ptr %NEXT_PC, align 8
  %v1671 = load i64, ptr %RSP, align 8
  %v1672 = add i64 %v1671, 64
  %v1673 = load ptr, ptr %MEMORY, align 8
  %v1674 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1673, ptr %state, ptr %RSI, i64 %v1672)
  store ptr %v1674, ptr %MEMORY, align 8
  %v1675 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1675, ptr %PC, align 8
  %v1676 = add i64 %v1675, 4
  store i64 %v1676, ptr %NEXT_PC, align 8
  %v1677 = load i64, ptr %RSP, align 8
  %v1678 = load ptr, ptr %MEMORY, align 8
  %v1679 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1678, ptr %state, ptr %RSP, i64 %v1677, i64 32)
  store ptr %v1679, ptr %MEMORY, align 8
  %v1680 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1680, ptr %PC, align 8
  %v1681 = add i64 %v1680, 1
  store i64 %v1681, ptr %NEXT_PC, align 8
  %v1682 = load ptr, ptr %MEMORY, align 8
  %v1683 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1682, ptr %state, ptr %RDI)
  store ptr %v1683, ptr %MEMORY, align 8
  %v1684 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1684, ptr %PC, align 8
  %v1685 = add i64 %v1684, 1
  store i64 %v1685, ptr %NEXT_PC, align 8
  %v1686 = load ptr, ptr %MEMORY, align 8
  %v1687 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1686, ptr %state, ptr %NEXT_PC)
  store ptr %v1687, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658550:                                    ; preds = %bb_5395658485
  %v1688 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1688, ptr %PC, align 8
  %v1689 = add i64 %v1688, 3
  store i64 %v1689, ptr %NEXT_PC, align 8
  %v1690 = load i64, ptr %RSI, align 8
  %v1691 = load ptr, ptr %MEMORY, align 8
  %v1692 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1691, ptr %state, ptr %RAX, i64 %v1690)
  store ptr %v1692, ptr %MEMORY, align 8
  %v1693 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1693, ptr %PC, align 8
  %v1694 = add i64 %v1693, 2
  store i64 %v1694, ptr %NEXT_PC, align 8
  %v1695 = load i64, ptr %NEXT_PC, align 8
  %v1696 = sub i64 %v1695, 26
  %v1697 = load ptr, ptr %MEMORY, align 8
  %v1698 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v1697, ptr %state, i64 %v1696, ptr %NEXT_PC)
  store ptr %v1698, ptr %MEMORY, align 8
  br label %bb_5395658529
  %v1699 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1699, ptr %PC, align 8
  %v1700 = add i64 %v1699, 1
  store i64 %v1700, ptr %NEXT_PC, align 8
  %v1701 = load ptr, ptr %MEMORY, align 8
  %v1702 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1701, ptr %state, ptr undef)
  store ptr %v1702, ptr %MEMORY, align 8
  %v1703 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1703, ptr %PC, align 8
  %v1704 = add i64 %v1703, 1
  store i64 %v1704, ptr %NEXT_PC, align 8
  %v1705 = load ptr, ptr %MEMORY, align 8
  %v1706 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1705, ptr %state, ptr undef)
  store ptr %v1706, ptr %MEMORY, align 8
  %v1707 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1707, ptr %PC, align 8
  %v1708 = add i64 %v1707, 1
  store i64 %v1708, ptr %NEXT_PC, align 8
  %v1709 = load ptr, ptr %MEMORY, align 8
  %v1710 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1709, ptr %state, ptr undef)
  store ptr %v1710, ptr %MEMORY, align 8
  %v1711 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1711, ptr %PC, align 8
  %v1712 = add i64 %v1711, 1
  store i64 %v1712, ptr %NEXT_PC, align 8
  %v1713 = load ptr, ptr %MEMORY, align 8
  %v1714 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1713, ptr %state, ptr undef)
  store ptr %v1714, ptr %MEMORY, align 8
  %v1715 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1715, ptr %PC, align 8
  %v1716 = add i64 %v1715, 1
  store i64 %v1716, ptr %NEXT_PC, align 8
  %v1717 = load ptr, ptr %MEMORY, align 8
  %v1718 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1717, ptr %state, ptr undef)
  store ptr %v1718, ptr %MEMORY, align 8
  %v1719 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1719, ptr %PC, align 8
  %v1720 = add i64 %v1719, 1
  store i64 %v1720, ptr %NEXT_PC, align 8
  %v1721 = load ptr, ptr %MEMORY, align 8
  %v1722 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1721, ptr %state, ptr undef)
  store ptr %v1722, ptr %MEMORY, align 8
  %v1723 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1723, ptr %PC, align 8
  %v1724 = add i64 %v1723, 1
  store i64 %v1724, ptr %NEXT_PC, align 8
  %v1725 = load ptr, ptr %MEMORY, align 8
  %v1726 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1725, ptr %state, ptr undef)
  store ptr %v1726, ptr %MEMORY, align 8
  %v1727 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1727, ptr %PC, align 8
  %v1728 = add i64 %v1727, 1
  store i64 %v1728, ptr %NEXT_PC, align 8
  %v1729 = load ptr, ptr %MEMORY, align 8
  %v1730 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1729, ptr %state, ptr undef)
  store ptr %v1730, ptr %MEMORY, align 8
  %v1731 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1731, ptr %PC, align 8
  %v1732 = add i64 %v1731, 1
  store i64 %v1732, ptr %NEXT_PC, align 8
  %v1733 = load ptr, ptr %MEMORY, align 8
  %v1734 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1733, ptr %state, ptr undef)
  store ptr %v1734, ptr %MEMORY, align 8
  %v1735 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1735, ptr %PC, align 8
  %v1736 = add i64 %v1735, 1
  store i64 %v1736, ptr %NEXT_PC, align 8
  %v1737 = load ptr, ptr %MEMORY, align 8
  %v1738 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1737, ptr %state, ptr undef)
  store ptr %v1738, ptr %MEMORY, align 8
  %v1739 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1739, ptr %PC, align 8
  %v1740 = add i64 %v1739, 1
  store i64 %v1740, ptr %NEXT_PC, align 8
  %v1741 = load ptr, ptr %MEMORY, align 8
  %v1742 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1741, ptr %state, ptr undef)
  store ptr %v1742, ptr %MEMORY, align 8
  %v1743 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1743, ptr %PC, align 8
  %v1744 = add i64 %v1743, 1
  store i64 %v1744, ptr %NEXT_PC, align 8
  %v1745 = load ptr, ptr %MEMORY, align 8
  %v1746 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1745, ptr %state, ptr undef)
  store ptr %v1746, ptr %MEMORY, align 8
  %v1747 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1747, ptr %PC, align 8
  %v1748 = add i64 %v1747, 1
  store i64 %v1748, ptr %NEXT_PC, align 8
  %v1749 = load ptr, ptr %MEMORY, align 8
  %v1750 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1749, ptr %state, ptr undef)
  store ptr %v1750, ptr %MEMORY, align 8
  %v1751 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1751, ptr %PC, align 8
  %v1752 = add i64 %v1751, 1
  store i64 %v1752, ptr %NEXT_PC, align 8
  %v1753 = load ptr, ptr %MEMORY, align 8
  %v1754 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1753, ptr %state, ptr undef)
  store ptr %v1754, ptr %MEMORY, align 8
  %v1755 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1755, ptr %PC, align 8
  %v1756 = add i64 %v1755, 1
  store i64 %v1756, ptr %NEXT_PC, align 8
  %v1757 = load ptr, ptr %MEMORY, align 8
  %v1758 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1757, ptr %state, ptr undef)
  store ptr %v1758, ptr %MEMORY, align 8
  %v1759 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1759, ptr %PC, align 8
  %v1760 = add i64 %v1759, 1
  store i64 %v1760, ptr %NEXT_PC, align 8
  %v1761 = load ptr, ptr %MEMORY, align 8
  %v1762 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1761, ptr %state, ptr undef)
  store ptr %v1762, ptr %MEMORY, align 8
  %v1763 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1763, ptr %PC, align 8
  %v1764 = add i64 %v1763, 1
  store i64 %v1764, ptr %NEXT_PC, align 8
  %v1765 = load ptr, ptr %MEMORY, align 8
  %v1766 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1765, ptr %state, ptr undef)
  store ptr %v1766, ptr %MEMORY, align 8
  %v1767 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1767, ptr %PC, align 8
  %v1768 = add i64 %v1767, 1
  store i64 %v1768, ptr %NEXT_PC, align 8
  %v1769 = load ptr, ptr %MEMORY, align 8
  %v1770 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1769, ptr %state, ptr undef)
  store ptr %v1770, ptr %MEMORY, align 8
  %v1771 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1771, ptr %PC, align 8
  %v1772 = add i64 %v1771, 1
  store i64 %v1772, ptr %NEXT_PC, align 8
  %v1773 = load ptr, ptr %MEMORY, align 8
  %v1774 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1773, ptr %state, ptr undef)
  store ptr %v1774, ptr %MEMORY, align 8
  %v1775 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1775, ptr %PC, align 8
  %v1776 = add i64 %v1775, 1
  store i64 %v1776, ptr %NEXT_PC, align 8
  %v1777 = load ptr, ptr %MEMORY, align 8
  %v1778 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1777, ptr %state, ptr undef)
  store ptr %v1778, ptr %MEMORY, align 8
  %v1779 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1779, ptr %PC, align 8
  %v1780 = add i64 %v1779, 1
  store i64 %v1780, ptr %NEXT_PC, align 8
  %v1781 = load ptr, ptr %MEMORY, align 8
  %v1782 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1781, ptr %state, ptr undef)
  store ptr %v1782, ptr %MEMORY, align 8
  %v1783 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1783, ptr %PC, align 8
  %v1784 = add i64 %v1783, 4
  store i64 %v1784, ptr %NEXT_PC, align 8
  %v1785 = load i64, ptr %RCX, align 8
  %v1786 = add i64 %v1785, 8
  %v1787 = load ptr, ptr %MEMORY, align 8
  %v1788 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1787, ptr %state, ptr %RDX, i64 %v1786)
  store ptr %v1788, ptr %MEMORY, align 8
  %v1789 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1789, ptr %PC, align 8
  %v1790 = add i64 %v1789, 3
  store i64 %v1790, ptr %NEXT_PC, align 8
  %v1791 = load i64, ptr %RCX, align 8
  %v1792 = add i64 %v1791, 32
  %v1793 = load ptr, ptr %MEMORY, align 8
  %v1794 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1793, ptr %state, ptr %RAX, i64 %v1792)
  store ptr %v1794, ptr %MEMORY, align 8
  %v1795 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1795, ptr %PC, align 8
  %v1796 = add i64 %v1795, 3
  store i64 %v1796, ptr %NEXT_PC, align 8
  %v1797 = load i64, ptr %RDX, align 8
  %v1798 = load i64, ptr %RDX, align 8
  %v1799 = load ptr, ptr %MEMORY, align 8
  %v1800 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1799, ptr %state, i64 %v1797, i64 %v1798)
  store ptr %v1800, ptr %MEMORY, align 8
  %v1801 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1801, ptr %PC, align 8
  %v1802 = add i64 %v1801, 2
  store i64 %v1802, ptr %NEXT_PC, align 8
  %v1803 = load i64, ptr %NEXT_PC, align 8
  %v1804 = add i64 %v1803, 16
  %v1805 = load i64, ptr %NEXT_PC, align 8
  %v1806 = load ptr, ptr %MEMORY, align 8
  %v1807 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1806, ptr %state, ptr %BRANCH_TAKEN, i64 %v1804, i64 %v1805, ptr %NEXT_PC)
  store ptr %v1807, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658604, label %bb_5395658588

bb_5395658588:                                    ; preds = %bb_5395658550
  %v1808 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1808, ptr %PC, align 8
  %v1809 = add i64 %v1808, 4
  store i64 %v1809, ptr %NEXT_PC, align 8
  %v1810 = load i64, ptr %RAX, align 8
  %v1811 = load ptr, ptr %MEMORY, align 8
  %v1812 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnIjEEEEP6MemoryS4_R5StateDpT_(ptr %v1811, ptr %state, i64 %v1810)
  store ptr %v1812, ptr %MEMORY, align 8
  br label %bb_5395658592

bb_5395658592:                                    ; preds = %bb_5395658592, %bb_5395658588
  %v1813 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1813, ptr %PC, align 8
  %v1814 = add i64 %v1813, 3
  store i64 %v1814, ptr %NEXT_PC, align 8
  %v1815 = load i64, ptr %RAX, align 8
  %v1816 = load i64, ptr %RDX, align 8
  %v1817 = add i64 %v1816, 32
  %v1818 = load ptr, ptr %MEMORY, align 8
  %v1819 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1818, ptr %state, ptr %RAX, i64 %v1815, i64 %v1817)
  store ptr %v1819, ptr %MEMORY, align 8
  %v1820 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1820, ptr %PC, align 8
  %v1821 = add i64 %v1820, 4
  store i64 %v1821, ptr %NEXT_PC, align 8
  %v1822 = load i64, ptr %RDX, align 8
  %v1823 = add i64 %v1822, 8
  %v1824 = load ptr, ptr %MEMORY, align 8
  %v1825 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1824, ptr %state, ptr %RDX, i64 %v1823)
  store ptr %v1825, ptr %MEMORY, align 8
  %v1826 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1826, ptr %PC, align 8
  %v1827 = add i64 %v1826, 3
  store i64 %v1827, ptr %NEXT_PC, align 8
  %v1828 = load i64, ptr %RDX, align 8
  %v1829 = load i64, ptr %RDX, align 8
  %v1830 = load ptr, ptr %MEMORY, align 8
  %v1831 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1830, ptr %state, i64 %v1828, i64 %v1829)
  store ptr %v1831, ptr %MEMORY, align 8
  %v1832 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1832, ptr %PC, align 8
  %v1833 = add i64 %v1832, 2
  store i64 %v1833, ptr %NEXT_PC, align 8
  %v1834 = load i64, ptr %NEXT_PC, align 8
  %v1835 = sub i64 %v1834, 12
  %v1836 = load i64, ptr %NEXT_PC, align 8
  %v1837 = load ptr, ptr %MEMORY, align 8
  %v1838 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1837, ptr %state, ptr %BRANCH_TAKEN, i64 %v1835, i64 %v1836, ptr %NEXT_PC)
  store ptr %v1838, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658592, label %bb_5395658604

bb_5395658604:                                    ; preds = %bb_5395658592, %bb_5395658550
  %v1839 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1839, ptr %PC, align 8
  %v1840 = add i64 %v1839, 1
  store i64 %v1840, ptr %NEXT_PC, align 8
  %v1841 = load ptr, ptr %MEMORY, align 8
  %v1842 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1841, ptr %state, ptr %NEXT_PC)
  store ptr %v1842, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658605:                                    ; No predecessors!
  %v1843 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1843, ptr %PC, align 8
  %v1844 = add i64 %v1843, 1
  store i64 %v1844, ptr %NEXT_PC, align 8
  %v1845 = load ptr, ptr %MEMORY, align 8
  %v1846 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1845, ptr %state, ptr undef)
  store ptr %v1846, ptr %MEMORY, align 8
  %v1847 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1847, ptr %PC, align 8
  %v1848 = add i64 %v1847, 1
  store i64 %v1848, ptr %NEXT_PC, align 8
  %v1849 = load ptr, ptr %MEMORY, align 8
  %v1850 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1849, ptr %state, ptr undef)
  store ptr %v1850, ptr %MEMORY, align 8
  %v1851 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1851, ptr %PC, align 8
  %v1852 = add i64 %v1851, 1
  store i64 %v1852, ptr %NEXT_PC, align 8
  %v1853 = load ptr, ptr %MEMORY, align 8
  %v1854 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1853, ptr %state, ptr undef)
  store ptr %v1854, ptr %MEMORY, align 8
  %v1855 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1855, ptr %PC, align 8
  %v1856 = add i64 %v1855, 1
  store i64 %v1856, ptr %NEXT_PC, align 8
  %v1857 = load ptr, ptr %MEMORY, align 8
  %v1858 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1857, ptr %state, ptr undef)
  store ptr %v1858, ptr %MEMORY, align 8
  %v1859 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1859, ptr %PC, align 8
  %v1860 = add i64 %v1859, 1
  store i64 %v1860, ptr %NEXT_PC, align 8
  %v1861 = load ptr, ptr %MEMORY, align 8
  %v1862 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1861, ptr %state, ptr undef)
  store ptr %v1862, ptr %MEMORY, align 8
  %v1863 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1863, ptr %PC, align 8
  %v1864 = add i64 %v1863, 1
  store i64 %v1864, ptr %NEXT_PC, align 8
  %v1865 = load ptr, ptr %MEMORY, align 8
  %v1866 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1865, ptr %state, ptr undef)
  store ptr %v1866, ptr %MEMORY, align 8
  %v1867 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1867, ptr %PC, align 8
  %v1868 = add i64 %v1867, 1
  store i64 %v1868, ptr %NEXT_PC, align 8
  %v1869 = load ptr, ptr %MEMORY, align 8
  %v1870 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1869, ptr %state, ptr undef)
  store ptr %v1870, ptr %MEMORY, align 8
  %v1871 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1871, ptr %PC, align 8
  %v1872 = add i64 %v1871, 1
  store i64 %v1872, ptr %NEXT_PC, align 8
  %v1873 = load ptr, ptr %MEMORY, align 8
  %v1874 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1873, ptr %state, ptr undef)
  store ptr %v1874, ptr %MEMORY, align 8
  %v1875 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1875, ptr %PC, align 8
  %v1876 = add i64 %v1875, 1
  store i64 %v1876, ptr %NEXT_PC, align 8
  %v1877 = load ptr, ptr %MEMORY, align 8
  %v1878 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1877, ptr %state, ptr undef)
  store ptr %v1878, ptr %MEMORY, align 8
  %v1879 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1879, ptr %PC, align 8
  %v1880 = add i64 %v1879, 1
  store i64 %v1880, ptr %NEXT_PC, align 8
  %v1881 = load ptr, ptr %MEMORY, align 8
  %v1882 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1881, ptr %state, ptr undef)
  store ptr %v1882, ptr %MEMORY, align 8
  %v1883 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1883, ptr %PC, align 8
  %v1884 = add i64 %v1883, 1
  store i64 %v1884, ptr %NEXT_PC, align 8
  %v1885 = load ptr, ptr %MEMORY, align 8
  %v1886 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1885, ptr %state, ptr undef)
  store ptr %v1886, ptr %MEMORY, align 8
  %v1887 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1887, ptr %PC, align 8
  %v1888 = add i64 %v1887, 1
  store i64 %v1888, ptr %NEXT_PC, align 8
  %v1889 = load ptr, ptr %MEMORY, align 8
  %v1890 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1889, ptr %state, ptr undef)
  store ptr %v1890, ptr %MEMORY, align 8
  %v1891 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1891, ptr %PC, align 8
  %v1892 = add i64 %v1891, 1
  store i64 %v1892, ptr %NEXT_PC, align 8
  %v1893 = load ptr, ptr %MEMORY, align 8
  %v1894 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1893, ptr %state, ptr undef)
  store ptr %v1894, ptr %MEMORY, align 8
  %v1895 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1895, ptr %PC, align 8
  %v1896 = add i64 %v1895, 1
  store i64 %v1896, ptr %NEXT_PC, align 8
  %v1897 = load ptr, ptr %MEMORY, align 8
  %v1898 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1897, ptr %state, ptr undef)
  store ptr %v1898, ptr %MEMORY, align 8
  %v1899 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1899, ptr %PC, align 8
  %v1900 = add i64 %v1899, 1
  store i64 %v1900, ptr %NEXT_PC, align 8
  %v1901 = load ptr, ptr %MEMORY, align 8
  %v1902 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1901, ptr %state, ptr undef)
  store ptr %v1902, ptr %MEMORY, align 8
  %v1903 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1903, ptr %PC, align 8
  %v1904 = add i64 %v1903, 1
  store i64 %v1904, ptr %NEXT_PC, align 8
  %v1905 = load ptr, ptr %MEMORY, align 8
  %v1906 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1905, ptr %state, ptr undef)
  store ptr %v1906, ptr %MEMORY, align 8
  %v1907 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1907, ptr %PC, align 8
  %v1908 = add i64 %v1907, 1
  store i64 %v1908, ptr %NEXT_PC, align 8
  %v1909 = load ptr, ptr %MEMORY, align 8
  %v1910 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1909, ptr %state, ptr undef)
  store ptr %v1910, ptr %MEMORY, align 8
  %v1911 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1911, ptr %PC, align 8
  %v1912 = add i64 %v1911, 1
  store i64 %v1912, ptr %NEXT_PC, align 8
  %v1913 = load ptr, ptr %MEMORY, align 8
  %v1914 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1913, ptr %state, ptr undef)
  store ptr %v1914, ptr %MEMORY, align 8
  %v1915 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1915, ptr %PC, align 8
  %v1916 = add i64 %v1915, 1
  store i64 %v1916, ptr %NEXT_PC, align 8
  %v1917 = load ptr, ptr %MEMORY, align 8
  %v1918 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1917, ptr %state, ptr undef)
  store ptr %v1918, ptr %MEMORY, align 8
  %v1919 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1919, ptr %PC, align 8
  %v1920 = add i64 %v1919, 3
  store i64 %v1920, ptr %NEXT_PC, align 8
  %v1921 = load i32, ptr %EDX, align 4
  %v1922 = zext i32 %v1921 to i64
  %v1923 = load ptr, ptr %MEMORY, align 8
  %v1924 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v1923, ptr %state, ptr %RAX, i64 %v1922)
  store ptr %v1924, ptr %MEMORY, align 8
  %v1925 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1925, ptr %PC, align 8
  %v1926 = add i64 %v1925, 4
  store i64 %v1926, ptr %NEXT_PC, align 8
  %v1927 = load i64, ptr %RAX, align 8
  %v1928 = load i64, ptr %RAX, align 8
  %v1929 = mul i64 %v1928, 4
  %v1930 = add i64 %v1927, %v1929
  %v1931 = load ptr, ptr %MEMORY, align 8
  %v1932 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1931, ptr %state, ptr %RDX, i64 %v1930)
  store ptr %v1932, ptr %MEMORY, align 8
  %v1933 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1933, ptr %PC, align 8
  %v1934 = add i64 %v1933, 4
  store i64 %v1934, ptr %NEXT_PC, align 8
  %v1935 = load i64, ptr %RCX, align 8
  %v1936 = add i64 %v1935, 24
  %v1937 = load ptr, ptr %MEMORY, align 8
  %v1938 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1937, ptr %state, ptr %RAX, i64 %v1936)
  store ptr %v1938, ptr %MEMORY, align 8
  %v1939 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1939, ptr %PC, align 8
  %v1940 = add i64 %v1939, 4
  store i64 %v1940, ptr %NEXT_PC, align 8
  %v1941 = load i64, ptr %RAX, align 8
  %v1942 = load i64, ptr %RDX, align 8
  %v1943 = mul i64 %v1942, 8
  %v1944 = add i64 %v1941, %v1943
  %v1945 = load ptr, ptr %MEMORY, align 8
  %v1946 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1945, ptr %state, ptr %RAX, i64 %v1944)
  store ptr %v1946, ptr %MEMORY, align 8
  %v1947 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1947, ptr %PC, align 8
  %v1948 = add i64 %v1947, 1
  store i64 %v1948, ptr %NEXT_PC, align 8
  %v1949 = load ptr, ptr %MEMORY, align 8
  %v1950 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1949, ptr %state, ptr %NEXT_PC)
  store ptr %v1950, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658640:                                    ; No predecessors!
  %v1951 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1951, ptr %PC, align 8
  %v1952 = add i64 %v1951, 1
  store i64 %v1952, ptr %NEXT_PC, align 8
  %v1953 = load ptr, ptr %MEMORY, align 8
  %v1954 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1953, ptr %state, ptr undef)
  store ptr %v1954, ptr %MEMORY, align 8
  %v1955 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1955, ptr %PC, align 8
  %v1956 = add i64 %v1955, 1
  store i64 %v1956, ptr %NEXT_PC, align 8
  %v1957 = load ptr, ptr %MEMORY, align 8
  %v1958 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1957, ptr %state, ptr undef)
  store ptr %v1958, ptr %MEMORY, align 8
  %v1959 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1959, ptr %PC, align 8
  %v1960 = add i64 %v1959, 1
  store i64 %v1960, ptr %NEXT_PC, align 8
  %v1961 = load ptr, ptr %MEMORY, align 8
  %v1962 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1961, ptr %state, ptr undef)
  store ptr %v1962, ptr %MEMORY, align 8
  %v1963 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1963, ptr %PC, align 8
  %v1964 = add i64 %v1963, 1
  store i64 %v1964, ptr %NEXT_PC, align 8
  %v1965 = load ptr, ptr %MEMORY, align 8
  %v1966 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1965, ptr %state, ptr undef)
  store ptr %v1966, ptr %MEMORY, align 8
  %v1967 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1967, ptr %PC, align 8
  %v1968 = add i64 %v1967, 1
  store i64 %v1968, ptr %NEXT_PC, align 8
  %v1969 = load ptr, ptr %MEMORY, align 8
  %v1970 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1969, ptr %state, ptr undef)
  store ptr %v1970, ptr %MEMORY, align 8
  %v1971 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1971, ptr %PC, align 8
  %v1972 = add i64 %v1971, 1
  store i64 %v1972, ptr %NEXT_PC, align 8
  %v1973 = load ptr, ptr %MEMORY, align 8
  %v1974 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1973, ptr %state, ptr undef)
  store ptr %v1974, ptr %MEMORY, align 8
  %v1975 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1975, ptr %PC, align 8
  %v1976 = add i64 %v1975, 1
  store i64 %v1976, ptr %NEXT_PC, align 8
  %v1977 = load ptr, ptr %MEMORY, align 8
  %v1978 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1977, ptr %state, ptr undef)
  store ptr %v1978, ptr %MEMORY, align 8
  %v1979 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1979, ptr %PC, align 8
  %v1980 = add i64 %v1979, 1
  store i64 %v1980, ptr %NEXT_PC, align 8
  %v1981 = load ptr, ptr %MEMORY, align 8
  %v1982 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1981, ptr %state, ptr undef)
  store ptr %v1982, ptr %MEMORY, align 8
  %v1983 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1983, ptr %PC, align 8
  %v1984 = add i64 %v1983, 1
  store i64 %v1984, ptr %NEXT_PC, align 8
  %v1985 = load ptr, ptr %MEMORY, align 8
  %v1986 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1985, ptr %state, ptr undef)
  store ptr %v1986, ptr %MEMORY, align 8
  %v1987 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1987, ptr %PC, align 8
  %v1988 = add i64 %v1987, 1
  store i64 %v1988, ptr %NEXT_PC, align 8
  %v1989 = load ptr, ptr %MEMORY, align 8
  %v1990 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1989, ptr %state, ptr undef)
  store ptr %v1990, ptr %MEMORY, align 8
  %v1991 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1991, ptr %PC, align 8
  %v1992 = add i64 %v1991, 1
  store i64 %v1992, ptr %NEXT_PC, align 8
  %v1993 = load ptr, ptr %MEMORY, align 8
  %v1994 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1993, ptr %state, ptr undef)
  store ptr %v1994, ptr %MEMORY, align 8
  %v1995 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1995, ptr %PC, align 8
  %v1996 = add i64 %v1995, 1
  store i64 %v1996, ptr %NEXT_PC, align 8
  %v1997 = load ptr, ptr %MEMORY, align 8
  %v1998 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1997, ptr %state, ptr undef)
  store ptr %v1998, ptr %MEMORY, align 8
  %v1999 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1999, ptr %PC, align 8
  %v2000 = add i64 %v1999, 1
  store i64 %v2000, ptr %NEXT_PC, align 8
  %v2001 = load ptr, ptr %MEMORY, align 8
  %v2002 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2001, ptr %state, ptr undef)
  store ptr %v2002, ptr %MEMORY, align 8
  %v2003 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2003, ptr %PC, align 8
  %v2004 = add i64 %v2003, 1
  store i64 %v2004, ptr %NEXT_PC, align 8
  %v2005 = load ptr, ptr %MEMORY, align 8
  %v2006 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2005, ptr %state, ptr undef)
  store ptr %v2006, ptr %MEMORY, align 8
  %v2007 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2007, ptr %PC, align 8
  %v2008 = add i64 %v2007, 1
  store i64 %v2008, ptr %NEXT_PC, align 8
  %v2009 = load ptr, ptr %MEMORY, align 8
  %v2010 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2009, ptr %state, ptr undef)
  store ptr %v2010, ptr %MEMORY, align 8
  %v2011 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2011, ptr %PC, align 8
  %v2012 = add i64 %v2011, 1
  store i64 %v2012, ptr %NEXT_PC, align 8
  %v2013 = load ptr, ptr %MEMORY, align 8
  %v2014 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2013, ptr %state, ptr undef)
  store ptr %v2014, ptr %MEMORY, align 8
  %v2015 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2015, ptr %PC, align 8
  %v2016 = add i64 %v2015, 5
  store i64 %v2016, ptr %NEXT_PC, align 8
  %v2017 = load i64, ptr %RSP, align 8
  %v2018 = add i64 %v2017, 8
  %v2019 = load i64, ptr %RBX, align 8
  %v2020 = load ptr, ptr %MEMORY, align 8
  %v2021 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2020, ptr %state, i64 %v2018, i64 %v2019)
  store ptr %v2021, ptr %MEMORY, align 8
  %v2022 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2022, ptr %PC, align 8
  %v2023 = add i64 %v2022, 5
  store i64 %v2023, ptr %NEXT_PC, align 8
  %v2024 = load i64, ptr %RSP, align 8
  %v2025 = add i64 %v2024, 16
  %v2026 = load i64, ptr %RBP, align 8
  %v2027 = load ptr, ptr %MEMORY, align 8
  %v2028 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2027, ptr %state, i64 %v2025, i64 %v2026)
  store ptr %v2028, ptr %MEMORY, align 8
  %v2029 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2029, ptr %PC, align 8
  %v2030 = add i64 %v2029, 5
  store i64 %v2030, ptr %NEXT_PC, align 8
  %v2031 = load i64, ptr %RSP, align 8
  %v2032 = add i64 %v2031, 24
  %v2033 = load i64, ptr %RSI, align 8
  %v2034 = load ptr, ptr %MEMORY, align 8
  %v2035 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2034, ptr %state, i64 %v2032, i64 %v2033)
  store ptr %v2035, ptr %MEMORY, align 8
  %v2036 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2036, ptr %PC, align 8
  %v2037 = add i64 %v2036, 1
  store i64 %v2037, ptr %NEXT_PC, align 8
  %v2038 = load i64, ptr %RDI, align 8
  %v2039 = load ptr, ptr %MEMORY, align 8
  %v2040 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v2039, ptr %state, i64 %v2038)
  store ptr %v2040, ptr %MEMORY, align 8
  %v2041 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2041, ptr %PC, align 8
  %v2042 = add i64 %v2041, 4
  store i64 %v2042, ptr %NEXT_PC, align 8
  %v2043 = load i64, ptr %RSP, align 8
  %v2044 = load ptr, ptr %MEMORY, align 8
  %v2045 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2044, ptr %state, ptr %RSP, i64 %v2043, i64 32)
  store ptr %v2045, ptr %MEMORY, align 8
  %v2046 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2046, ptr %PC, align 8
  %v2047 = add i64 %v2046, 3
  store i64 %v2047, ptr %NEXT_PC, align 8
  %v2048 = load i64, ptr %RDX, align 8
  %v2049 = load ptr, ptr %MEMORY, align 8
  %v2050 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2049, ptr %state, ptr %RBP, i64 %v2048)
  store ptr %v2050, ptr %MEMORY, align 8
  %v2051 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2051, ptr %PC, align 8
  %v2052 = add i64 %v2051, 3
  store i64 %v2052, ptr %NEXT_PC, align 8
  %v2053 = load i64, ptr %RCX, align 8
  %v2054 = load ptr, ptr %MEMORY, align 8
  %v2055 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2054, ptr %state, ptr %RDI, i64 %v2053)
  store ptr %v2055, ptr %MEMORY, align 8
  %v2056 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2056, ptr %PC, align 8
  %v2057 = add i64 %v2056, 2
  store i64 %v2057, ptr %NEXT_PC, align 8
  %v2058 = load i64, ptr %RBX, align 8
  %v2059 = load i32, ptr %EBX, align 4
  %v2060 = zext i32 %v2059 to i64
  %v2061 = load ptr, ptr %MEMORY, align 8
  %v2062 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2061, ptr %state, ptr %RBX, i64 %v2058, i64 %v2060)
  store ptr %v2062, ptr %MEMORY, align 8
  %v2063 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2063, ptr %PC, align 8
  %v2064 = add i64 %v2063, 5
  store i64 %v2064, ptr %NEXT_PC, align 8
  %v2065 = load i64, ptr %NEXT_PC, align 8
  %v2066 = add i64 %v2065, 95
  %v2067 = load i64, ptr %NEXT_PC, align 8
  %v2068 = load ptr, ptr %MEMORY, align 8
  %v2069 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2068, ptr %state, i64 %v2066, ptr %NEXT_PC, i64 %v2067, ptr %RETURN_PC)
  store ptr %v2069, ptr %MEMORY, align 8
  %v2070 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2070, ptr %PC, align 8
  %v2071 = add i64 %v2070, 2
  store i64 %v2071, ptr %NEXT_PC, align 8
  %v2072 = load i32, ptr %EAX, align 4
  %v2073 = zext i32 %v2072 to i64
  %v2074 = load i32, ptr %EAX, align 4
  %v2075 = zext i32 %v2074 to i64
  %v2076 = load ptr, ptr %MEMORY, align 8
  %v2077 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2076, ptr %state, i64 %v2073, i64 %v2075)
  store ptr %v2077, ptr %MEMORY, align 8
  %v2078 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2078, ptr %PC, align 8
  %v2079 = add i64 %v2078, 2
  store i64 %v2079, ptr %NEXT_PC, align 8
  %v2080 = load i64, ptr %NEXT_PC, align 8
  %v2081 = add i64 %v2080, 42
  %v2082 = load i64, ptr %NEXT_PC, align 8
  %v2083 = load ptr, ptr %MEMORY, align 8
  %v2084 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2083, ptr %state, ptr %BRANCH_TAKEN, i64 %v2081, i64 %v2082, ptr %NEXT_PC)
  store ptr %v2084, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658735, label %bb_5395658693

bb_5395658693:                                    ; preds = %bb_5395658721, %bb_5395658640
  %v2085 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2085, ptr %PC, align 8
  %v2086 = add i64 %v2085, 2
  store i64 %v2086, ptr %NEXT_PC, align 8
  %v2087 = load i32, ptr %EBX, align 4
  %v2088 = zext i32 %v2087 to i64
  %v2089 = load ptr, ptr %MEMORY, align 8
  %v2090 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2089, ptr %state, ptr %RDX, i64 %v2088)
  store ptr %v2090, ptr %MEMORY, align 8
  %v2091 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2091, ptr %PC, align 8
  %v2092 = add i64 %v2091, 3
  store i64 %v2092, ptr %NEXT_PC, align 8
  %v2093 = load i64, ptr %RDI, align 8
  %v2094 = load ptr, ptr %MEMORY, align 8
  %v2095 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2094, ptr %state, ptr %RCX, i64 %v2093)
  store ptr %v2095, ptr %MEMORY, align 8
  %v2096 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2096, ptr %PC, align 8
  %v2097 = add i64 %v2096, 5
  store i64 %v2097, ptr %NEXT_PC, align 8
  %v2098 = load i64, ptr %NEXT_PC, align 8
  %v2099 = sub i64 %v2098, 79
  %v2100 = load i64, ptr %NEXT_PC, align 8
  %v2101 = load ptr, ptr %MEMORY, align 8
  %v2102 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2101, ptr %state, i64 %v2099, ptr %NEXT_PC, i64 %v2100, ptr %RETURN_PC)
  store ptr %v2102, ptr %MEMORY, align 8
  %v2103 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2103, ptr %PC, align 8
  %v2104 = add i64 %v2103, 3
  store i64 %v2104, ptr %NEXT_PC, align 8
  %v2105 = load i64, ptr %RBP, align 8
  %v2106 = load ptr, ptr %MEMORY, align 8
  %v2107 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2106, ptr %state, ptr %RDX, i64 %v2105)
  store ptr %v2107, ptr %MEMORY, align 8
  %v2108 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2108, ptr %PC, align 8
  %v2109 = add i64 %v2108, 3
  store i64 %v2109, ptr %NEXT_PC, align 8
  %v2110 = load i64, ptr %RAX, align 8
  %v2111 = load ptr, ptr %MEMORY, align 8
  %v2112 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2111, ptr %state, ptr %RSI, i64 %v2110)
  store ptr %v2112, ptr %MEMORY, align 8
  %v2113 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2113, ptr %PC, align 8
  %v2114 = add i64 %v2113, 3
  store i64 %v2114, ptr %NEXT_PC, align 8
  %v2115 = load i64, ptr %RAX, align 8
  %v2116 = load ptr, ptr %MEMORY, align 8
  %v2117 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2116, ptr %state, ptr %RCX, i64 %v2115)
  store ptr %v2117, ptr %MEMORY, align 8
  %v2118 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2118, ptr %PC, align 8
  %v2119 = add i64 %v2118, 5
  store i64 %v2119, ptr %NEXT_PC, align 8
  %v2120 = load i64, ptr %NEXT_PC, align 8
  %v2121 = add i64 %v2120, 45603
  %v2122 = load i64, ptr %NEXT_PC, align 8
  %v2123 = load ptr, ptr %MEMORY, align 8
  %v2124 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2123, ptr %state, i64 %v2121, ptr %NEXT_PC, i64 %v2122, ptr %RETURN_PC)
  store ptr %v2124, ptr %MEMORY, align 8
  %v2125 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2125, ptr %PC, align 8
  %v2126 = add i64 %v2125, 2
  store i64 %v2126, ptr %NEXT_PC, align 8
  %v2127 = load i32, ptr %EAX, align 4
  %v2128 = zext i32 %v2127 to i64
  %v2129 = load i32, ptr %EAX, align 4
  %v2130 = zext i32 %v2129 to i64
  %v2131 = load ptr, ptr %MEMORY, align 8
  %v2132 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2131, ptr %state, i64 %v2128, i64 %v2130)
  store ptr %v2132, ptr %MEMORY, align 8
  %v2133 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2133, ptr %PC, align 8
  %v2134 = add i64 %v2133, 2
  store i64 %v2134, ptr %NEXT_PC, align 8
  %v2135 = load i64, ptr %NEXT_PC, align 8
  %v2136 = add i64 %v2135, 37
  %v2137 = load i64, ptr %NEXT_PC, align 8
  %v2138 = load ptr, ptr %MEMORY, align 8
  %v2139 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2138, ptr %state, ptr %BRANCH_TAKEN, i64 %v2136, i64 %v2137, ptr %NEXT_PC)
  store ptr %v2139, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658758, label %bb_5395658721

bb_5395658721:                                    ; preds = %bb_5395658693
  %v2140 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2140, ptr %PC, align 8
  %v2141 = add i64 %v2140, 3
  store i64 %v2141, ptr %NEXT_PC, align 8
  %v2142 = load i64, ptr %RDI, align 8
  %v2143 = load ptr, ptr %MEMORY, align 8
  %v2144 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2143, ptr %state, ptr %RCX, i64 %v2142)
  store ptr %v2144, ptr %MEMORY, align 8
  %v2145 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2145, ptr %PC, align 8
  %v2146 = add i64 %v2145, 2
  store i64 %v2146, ptr %NEXT_PC, align 8
  %v2147 = load i64, ptr %RBX, align 8
  %v2148 = load ptr, ptr %MEMORY, align 8
  %v2149 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2148, ptr %state, ptr %RBX, i64 %v2147)
  store ptr %v2149, ptr %MEMORY, align 8
  %v2150 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2150, ptr %PC, align 8
  %v2151 = add i64 %v2150, 5
  store i64 %v2151, ptr %NEXT_PC, align 8
  %v2152 = load i64, ptr %NEXT_PC, align 8
  %v2153 = add i64 %v2152, 53
  %v2154 = load i64, ptr %NEXT_PC, align 8
  %v2155 = load ptr, ptr %MEMORY, align 8
  %v2156 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2155, ptr %state, i64 %v2153, ptr %NEXT_PC, i64 %v2154, ptr %RETURN_PC)
  store ptr %v2156, ptr %MEMORY, align 8
  %v2157 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2157, ptr %PC, align 8
  %v2158 = add i64 %v2157, 2
  store i64 %v2158, ptr %NEXT_PC, align 8
  %v2159 = load i32, ptr %EBX, align 4
  %v2160 = zext i32 %v2159 to i64
  %v2161 = load i32, ptr %EAX, align 4
  %v2162 = zext i32 %v2161 to i64
  %v2163 = load ptr, ptr %MEMORY, align 8
  %v2164 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2163, ptr %state, i64 %v2160, i64 %v2162)
  store ptr %v2164, ptr %MEMORY, align 8
  %v2165 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2165, ptr %PC, align 8
  %v2166 = add i64 %v2165, 2
  store i64 %v2166, ptr %NEXT_PC, align 8
  %v2167 = load i64, ptr %NEXT_PC, align 8
  %v2168 = sub i64 %v2167, 42
  %v2169 = load i64, ptr %NEXT_PC, align 8
  %v2170 = load ptr, ptr %MEMORY, align 8
  %v2171 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2170, ptr %state, ptr %BRANCH_TAKEN, i64 %v2168, i64 %v2169, ptr %NEXT_PC)
  store ptr %v2171, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658693, label %bb_5395658735

bb_5395658735:                                    ; preds = %bb_5395658721, %bb_5395658640
  %v2172 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2172, ptr %PC, align 8
  %v2173 = add i64 %v2172, 2
  store i64 %v2173, ptr %NEXT_PC, align 8
  %v2174 = load i64, ptr %RAX, align 8
  %v2175 = load i32, ptr %EAX, align 4
  %v2176 = zext i32 %v2175 to i64
  %v2177 = load ptr, ptr %MEMORY, align 8
  %v2178 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2177, ptr %state, ptr %RAX, i64 %v2174, i64 %v2176)
  store ptr %v2178, ptr %MEMORY, align 8
  br label %bb_5395658737

bb_5395658737:                                    ; preds = %bb_5395658758, %bb_5395658735
  %v2179 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2179, ptr %PC, align 8
  %v2180 = add i64 %v2179, 5
  store i64 %v2180, ptr %NEXT_PC, align 8
  %v2181 = load i64, ptr %RSP, align 8
  %v2182 = add i64 %v2181, 48
  %v2183 = load ptr, ptr %MEMORY, align 8
  %v2184 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2183, ptr %state, ptr %RBX, i64 %v2182)
  store ptr %v2184, ptr %MEMORY, align 8
  %v2185 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2185, ptr %PC, align 8
  %v2186 = add i64 %v2185, 5
  store i64 %v2186, ptr %NEXT_PC, align 8
  %v2187 = load i64, ptr %RSP, align 8
  %v2188 = add i64 %v2187, 56
  %v2189 = load ptr, ptr %MEMORY, align 8
  %v2190 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2189, ptr %state, ptr %RBP, i64 %v2188)
  store ptr %v2190, ptr %MEMORY, align 8
  %v2191 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2191, ptr %PC, align 8
  %v2192 = add i64 %v2191, 5
  store i64 %v2192, ptr %NEXT_PC, align 8
  %v2193 = load i64, ptr %RSP, align 8
  %v2194 = add i64 %v2193, 64
  %v2195 = load ptr, ptr %MEMORY, align 8
  %v2196 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2195, ptr %state, ptr %RSI, i64 %v2194)
  store ptr %v2196, ptr %MEMORY, align 8
  %v2197 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2197, ptr %PC, align 8
  %v2198 = add i64 %v2197, 4
  store i64 %v2198, ptr %NEXT_PC, align 8
  %v2199 = load i64, ptr %RSP, align 8
  %v2200 = load ptr, ptr %MEMORY, align 8
  %v2201 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2200, ptr %state, ptr %RSP, i64 %v2199, i64 32)
  store ptr %v2201, ptr %MEMORY, align 8
  %v2202 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2202, ptr %PC, align 8
  %v2203 = add i64 %v2202, 1
  store i64 %v2203, ptr %NEXT_PC, align 8
  %v2204 = load ptr, ptr %MEMORY, align 8
  %v2205 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v2204, ptr %state, ptr %RDI)
  store ptr %v2205, ptr %MEMORY, align 8
  %v2206 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2206, ptr %PC, align 8
  %v2207 = add i64 %v2206, 1
  store i64 %v2207, ptr %NEXT_PC, align 8
  %v2208 = load ptr, ptr %MEMORY, align 8
  %v2209 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2208, ptr %state, ptr %NEXT_PC)
  store ptr %v2209, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658758:                                    ; preds = %bb_5395658693
  %v2210 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2210, ptr %PC, align 8
  %v2211 = add i64 %v2210, 3
  store i64 %v2211, ptr %NEXT_PC, align 8
  %v2212 = load i64, ptr %RSI, align 8
  %v2213 = load ptr, ptr %MEMORY, align 8
  %v2214 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2213, ptr %state, ptr %RAX, i64 %v2212)
  store ptr %v2214, ptr %MEMORY, align 8
  %v2215 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2215, ptr %PC, align 8
  %v2216 = add i64 %v2215, 2
  store i64 %v2216, ptr %NEXT_PC, align 8
  %v2217 = load i64, ptr %NEXT_PC, align 8
  %v2218 = sub i64 %v2217, 26
  %v2219 = load ptr, ptr %MEMORY, align 8
  %v2220 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2219, ptr %state, i64 %v2218, ptr %NEXT_PC)
  store ptr %v2220, ptr %MEMORY, align 8
  br label %bb_5395658737
  %v2221 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2221, ptr %PC, align 8
  %v2222 = add i64 %v2221, 1
  store i64 %v2222, ptr %NEXT_PC, align 8
  %v2223 = load ptr, ptr %MEMORY, align 8
  %v2224 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2223, ptr %state, ptr undef)
  store ptr %v2224, ptr %MEMORY, align 8
  %v2225 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2225, ptr %PC, align 8
  %v2226 = add i64 %v2225, 1
  store i64 %v2226, ptr %NEXT_PC, align 8
  %v2227 = load ptr, ptr %MEMORY, align 8
  %v2228 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2227, ptr %state, ptr undef)
  store ptr %v2228, ptr %MEMORY, align 8
  %v2229 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2229, ptr %PC, align 8
  %v2230 = add i64 %v2229, 1
  store i64 %v2230, ptr %NEXT_PC, align 8
  %v2231 = load ptr, ptr %MEMORY, align 8
  %v2232 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2231, ptr %state, ptr undef)
  store ptr %v2232, ptr %MEMORY, align 8
  %v2233 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2233, ptr %PC, align 8
  %v2234 = add i64 %v2233, 1
  store i64 %v2234, ptr %NEXT_PC, align 8
  %v2235 = load ptr, ptr %MEMORY, align 8
  %v2236 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2235, ptr %state, ptr undef)
  store ptr %v2236, ptr %MEMORY, align 8
  %v2237 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2237, ptr %PC, align 8
  %v2238 = add i64 %v2237, 1
  store i64 %v2238, ptr %NEXT_PC, align 8
  %v2239 = load ptr, ptr %MEMORY, align 8
  %v2240 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2239, ptr %state, ptr undef)
  store ptr %v2240, ptr %MEMORY, align 8
  %v2241 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2241, ptr %PC, align 8
  %v2242 = add i64 %v2241, 1
  store i64 %v2242, ptr %NEXT_PC, align 8
  %v2243 = load ptr, ptr %MEMORY, align 8
  %v2244 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2243, ptr %state, ptr undef)
  store ptr %v2244, ptr %MEMORY, align 8
  %v2245 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2245, ptr %PC, align 8
  %v2246 = add i64 %v2245, 1
  store i64 %v2246, ptr %NEXT_PC, align 8
  %v2247 = load ptr, ptr %MEMORY, align 8
  %v2248 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2247, ptr %state, ptr undef)
  store ptr %v2248, ptr %MEMORY, align 8
  %v2249 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2249, ptr %PC, align 8
  %v2250 = add i64 %v2249, 1
  store i64 %v2250, ptr %NEXT_PC, align 8
  %v2251 = load ptr, ptr %MEMORY, align 8
  %v2252 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2251, ptr %state, ptr undef)
  store ptr %v2252, ptr %MEMORY, align 8
  %v2253 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2253, ptr %PC, align 8
  %v2254 = add i64 %v2253, 1
  store i64 %v2254, ptr %NEXT_PC, align 8
  %v2255 = load ptr, ptr %MEMORY, align 8
  %v2256 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2255, ptr %state, ptr undef)
  store ptr %v2256, ptr %MEMORY, align 8
  %v2257 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2257, ptr %PC, align 8
  %v2258 = add i64 %v2257, 1
  store i64 %v2258, ptr %NEXT_PC, align 8
  %v2259 = load ptr, ptr %MEMORY, align 8
  %v2260 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2259, ptr %state, ptr undef)
  store ptr %v2260, ptr %MEMORY, align 8
  %v2261 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2261, ptr %PC, align 8
  %v2262 = add i64 %v2261, 1
  store i64 %v2262, ptr %NEXT_PC, align 8
  %v2263 = load ptr, ptr %MEMORY, align 8
  %v2264 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2263, ptr %state, ptr undef)
  store ptr %v2264, ptr %MEMORY, align 8
  %v2265 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2265, ptr %PC, align 8
  %v2266 = add i64 %v2265, 1
  store i64 %v2266, ptr %NEXT_PC, align 8
  %v2267 = load ptr, ptr %MEMORY, align 8
  %v2268 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2267, ptr %state, ptr undef)
  store ptr %v2268, ptr %MEMORY, align 8
  %v2269 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2269, ptr %PC, align 8
  %v2270 = add i64 %v2269, 1
  store i64 %v2270, ptr %NEXT_PC, align 8
  %v2271 = load ptr, ptr %MEMORY, align 8
  %v2272 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2271, ptr %state, ptr undef)
  store ptr %v2272, ptr %MEMORY, align 8
  %v2273 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2273, ptr %PC, align 8
  %v2274 = add i64 %v2273, 1
  store i64 %v2274, ptr %NEXT_PC, align 8
  %v2275 = load ptr, ptr %MEMORY, align 8
  %v2276 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2275, ptr %state, ptr undef)
  store ptr %v2276, ptr %MEMORY, align 8
  %v2277 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2277, ptr %PC, align 8
  %v2278 = add i64 %v2277, 1
  store i64 %v2278, ptr %NEXT_PC, align 8
  %v2279 = load ptr, ptr %MEMORY, align 8
  %v2280 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2279, ptr %state, ptr undef)
  store ptr %v2280, ptr %MEMORY, align 8
  %v2281 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2281, ptr %PC, align 8
  %v2282 = add i64 %v2281, 1
  store i64 %v2282, ptr %NEXT_PC, align 8
  %v2283 = load ptr, ptr %MEMORY, align 8
  %v2284 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2283, ptr %state, ptr undef)
  store ptr %v2284, ptr %MEMORY, align 8
  %v2285 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2285, ptr %PC, align 8
  %v2286 = add i64 %v2285, 1
  store i64 %v2286, ptr %NEXT_PC, align 8
  %v2287 = load ptr, ptr %MEMORY, align 8
  %v2288 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2287, ptr %state, ptr undef)
  store ptr %v2288, ptr %MEMORY, align 8
  %v2289 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2289, ptr %PC, align 8
  %v2290 = add i64 %v2289, 1
  store i64 %v2290, ptr %NEXT_PC, align 8
  %v2291 = load ptr, ptr %MEMORY, align 8
  %v2292 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2291, ptr %state, ptr undef)
  store ptr %v2292, ptr %MEMORY, align 8
  %v2293 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2293, ptr %PC, align 8
  %v2294 = add i64 %v2293, 1
  store i64 %v2294, ptr %NEXT_PC, align 8
  %v2295 = load ptr, ptr %MEMORY, align 8
  %v2296 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2295, ptr %state, ptr undef)
  store ptr %v2296, ptr %MEMORY, align 8
  %v2297 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2297, ptr %PC, align 8
  %v2298 = add i64 %v2297, 1
  store i64 %v2298, ptr %NEXT_PC, align 8
  %v2299 = load ptr, ptr %MEMORY, align 8
  %v2300 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2299, ptr %state, ptr undef)
  store ptr %v2300, ptr %MEMORY, align 8
  %v2301 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2301, ptr %PC, align 8
  %v2302 = add i64 %v2301, 1
  store i64 %v2302, ptr %NEXT_PC, align 8
  %v2303 = load ptr, ptr %MEMORY, align 8
  %v2304 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2303, ptr %state, ptr undef)
  store ptr %v2304, ptr %MEMORY, align 8
  %v2305 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2305, ptr %PC, align 8
  %v2306 = add i64 %v2305, 3
  store i64 %v2306, ptr %NEXT_PC, align 8
  %v2307 = load i64, ptr %RCX, align 8
  %v2308 = add i64 %v2307, 32
  %v2309 = load ptr, ptr %MEMORY, align 8
  %v2310 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2309, ptr %state, ptr %RAX, i64 %v2308)
  store ptr %v2310, ptr %MEMORY, align 8
  %v2311 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2311, ptr %PC, align 8
  %v2312 = add i64 %v2311, 1
  store i64 %v2312, ptr %NEXT_PC, align 8
  %v2313 = load ptr, ptr %MEMORY, align 8
  %v2314 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2313, ptr %state, ptr %NEXT_PC)
  store ptr %v2314, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658788:                                    ; No predecessors!
  %v2315 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2315, ptr %PC, align 8
  %v2316 = add i64 %v2315, 1
  store i64 %v2316, ptr %NEXT_PC, align 8
  %v2317 = load ptr, ptr %MEMORY, align 8
  %v2318 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2317, ptr %state, ptr undef)
  store ptr %v2318, ptr %MEMORY, align 8
  %v2319 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2319, ptr %PC, align 8
  %v2320 = add i64 %v2319, 1
  store i64 %v2320, ptr %NEXT_PC, align 8
  %v2321 = load ptr, ptr %MEMORY, align 8
  %v2322 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2321, ptr %state, ptr undef)
  store ptr %v2322, ptr %MEMORY, align 8
  %v2323 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2323, ptr %PC, align 8
  %v2324 = add i64 %v2323, 1
  store i64 %v2324, ptr %NEXT_PC, align 8
  %v2325 = load ptr, ptr %MEMORY, align 8
  %v2326 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2325, ptr %state, ptr undef)
  store ptr %v2326, ptr %MEMORY, align 8
  %v2327 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2327, ptr %PC, align 8
  %v2328 = add i64 %v2327, 1
  store i64 %v2328, ptr %NEXT_PC, align 8
  %v2329 = load ptr, ptr %MEMORY, align 8
  %v2330 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2329, ptr %state, ptr undef)
  store ptr %v2330, ptr %MEMORY, align 8
  %v2331 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2331, ptr %PC, align 8
  %v2332 = add i64 %v2331, 1
  store i64 %v2332, ptr %NEXT_PC, align 8
  %v2333 = load ptr, ptr %MEMORY, align 8
  %v2334 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2333, ptr %state, ptr undef)
  store ptr %v2334, ptr %MEMORY, align 8
  %v2335 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2335, ptr %PC, align 8
  %v2336 = add i64 %v2335, 1
  store i64 %v2336, ptr %NEXT_PC, align 8
  %v2337 = load ptr, ptr %MEMORY, align 8
  %v2338 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2337, ptr %state, ptr undef)
  store ptr %v2338, ptr %MEMORY, align 8
  %v2339 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2339, ptr %PC, align 8
  %v2340 = add i64 %v2339, 1
  store i64 %v2340, ptr %NEXT_PC, align 8
  %v2341 = load ptr, ptr %MEMORY, align 8
  %v2342 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2341, ptr %state, ptr undef)
  store ptr %v2342, ptr %MEMORY, align 8
  %v2343 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2343, ptr %PC, align 8
  %v2344 = add i64 %v2343, 1
  store i64 %v2344, ptr %NEXT_PC, align 8
  %v2345 = load ptr, ptr %MEMORY, align 8
  %v2346 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2345, ptr %state, ptr undef)
  store ptr %v2346, ptr %MEMORY, align 8
  %v2347 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2347, ptr %PC, align 8
  %v2348 = add i64 %v2347, 1
  store i64 %v2348, ptr %NEXT_PC, align 8
  %v2349 = load ptr, ptr %MEMORY, align 8
  %v2350 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2349, ptr %state, ptr undef)
  store ptr %v2350, ptr %MEMORY, align 8
  %v2351 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2351, ptr %PC, align 8
  %v2352 = add i64 %v2351, 1
  store i64 %v2352, ptr %NEXT_PC, align 8
  %v2353 = load ptr, ptr %MEMORY, align 8
  %v2354 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2353, ptr %state, ptr undef)
  store ptr %v2354, ptr %MEMORY, align 8
  %v2355 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2355, ptr %PC, align 8
  %v2356 = add i64 %v2355, 1
  store i64 %v2356, ptr %NEXT_PC, align 8
  %v2357 = load ptr, ptr %MEMORY, align 8
  %v2358 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2357, ptr %state, ptr undef)
  store ptr %v2358, ptr %MEMORY, align 8
  %v2359 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2359, ptr %PC, align 8
  %v2360 = add i64 %v2359, 1
  store i64 %v2360, ptr %NEXT_PC, align 8
  %v2361 = load ptr, ptr %MEMORY, align 8
  %v2362 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2361, ptr %state, ptr undef)
  store ptr %v2362, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658800:                                    ; preds = %bb_5395658900
  %v2363 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2363, ptr %PC, align 8
  %v2364 = add i64 %v2363, 5
  store i64 %v2364, ptr %NEXT_PC, align 8
  %v2365 = load i64, ptr %RSP, align 8
  %v2366 = add i64 %v2365, 8
  %v2367 = load i64, ptr %RBX, align 8
  %v2368 = load ptr, ptr %MEMORY, align 8
  %v2369 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2368, ptr %state, i64 %v2366, i64 %v2367)
  store ptr %v2369, ptr %MEMORY, align 8
  %v2370 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2370, ptr %PC, align 8
  %v2371 = add i64 %v2370, 5
  store i64 %v2371, ptr %NEXT_PC, align 8
  %v2372 = load i64, ptr %RSP, align 8
  %v2373 = add i64 %v2372, 16
  %v2374 = load i64, ptr %RSI, align 8
  %v2375 = load ptr, ptr %MEMORY, align 8
  %v2376 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2375, ptr %state, i64 %v2373, i64 %v2374)
  store ptr %v2376, ptr %MEMORY, align 8
  %v2377 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2377, ptr %PC, align 8
  %v2378 = add i64 %v2377, 1
  store i64 %v2378, ptr %NEXT_PC, align 8
  %v2379 = load i64, ptr %RDI, align 8
  %v2380 = load ptr, ptr %MEMORY, align 8
  %v2381 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v2380, ptr %state, i64 %v2379)
  store ptr %v2381, ptr %MEMORY, align 8
  %v2382 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2382, ptr %PC, align 8
  %v2383 = add i64 %v2382, 4
  store i64 %v2383, ptr %NEXT_PC, align 8
  %v2384 = load i64, ptr %RSP, align 8
  %v2385 = load ptr, ptr %MEMORY, align 8
  %v2386 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2385, ptr %state, ptr %RSP, i64 %v2384, i64 32)
  store ptr %v2386, ptr %MEMORY, align 8
  %v2387 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2387, ptr %PC, align 8
  %v2388 = add i64 %v2387, 2
  store i64 %v2388, ptr %NEXT_PC, align 8
  %v2389 = load i32, ptr %EDX, align 4
  %v2390 = zext i32 %v2389 to i64
  %v2391 = load ptr, ptr %MEMORY, align 8
  %v2392 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2391, ptr %state, ptr %RDI, i64 %v2390)
  store ptr %v2392, ptr %MEMORY, align 8
  %v2393 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2393, ptr %PC, align 8
  %v2394 = add i64 %v2393, 3
  store i64 %v2394, ptr %NEXT_PC, align 8
  %v2395 = load i64, ptr %RCX, align 8
  %v2396 = load ptr, ptr %MEMORY, align 8
  %v2397 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2396, ptr %state, ptr %RSI, i64 %v2395)
  store ptr %v2397, ptr %MEMORY, align 8
  %v2398 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2398, ptr %PC, align 8
  %v2399 = add i64 %v2398, 3
  store i64 %v2399, ptr %NEXT_PC, align 8
  %v2400 = load i64, ptr %RCX, align 8
  %v2401 = load ptr, ptr %MEMORY, align 8
  %v2402 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2401, ptr %state, ptr %RBX, i64 %v2400)
  store ptr %v2402, ptr %MEMORY, align 8
  %v2403 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2403, ptr %PC, align 8
  %v2404 = add i64 %v2403, 5
  store i64 %v2404, ptr %NEXT_PC, align 8
  %v2405 = load i64, ptr %NEXT_PC, align 8
  %v2406 = add i64 %v2405, 484
  %v2407 = load i64, ptr %NEXT_PC, align 8
  %v2408 = load ptr, ptr %MEMORY, align 8
  %v2409 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2408, ptr %state, i64 %v2406, ptr %NEXT_PC, i64 %v2407, ptr %RETURN_PC)
  store ptr %v2409, ptr %MEMORY, align 8
  %v2410 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2410, ptr %PC, align 8
  %v2411 = add i64 %v2410, 2
  store i64 %v2411, ptr %NEXT_PC, align 8
  %v2412 = load i64, ptr %RDI, align 8
  %v2413 = load i32, ptr %EAX, align 4
  %v2414 = zext i32 %v2413 to i64
  %v2415 = load ptr, ptr %MEMORY, align 8
  %v2416 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2415, ptr %state, ptr %RDI, i64 %v2412, i64 %v2414)
  store ptr %v2416, ptr %MEMORY, align 8
  %v2417 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2417, ptr %PC, align 8
  %v2418 = add i64 %v2417, 3
  store i64 %v2418, ptr %NEXT_PC, align 8
  %v2419 = load i64, ptr %RBX, align 8
  %v2420 = load i64, ptr %RBX, align 8
  %v2421 = load ptr, ptr %MEMORY, align 8
  %v2422 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2421, ptr %state, i64 %v2419, i64 %v2420)
  store ptr %v2422, ptr %MEMORY, align 8
  %v2423 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2423, ptr %PC, align 8
  %v2424 = add i64 %v2423, 2
  store i64 %v2424, ptr %NEXT_PC, align 8
  %v2425 = load i64, ptr %NEXT_PC, align 8
  %v2426 = add i64 %v2425, 14
  %v2427 = load i64, ptr %NEXT_PC, align 8
  %v2428 = load ptr, ptr %MEMORY, align 8
  %v2429 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2428, ptr %state, ptr %BRANCH_TAKEN, i64 %v2426, i64 %v2427, ptr %NEXT_PC)
  store ptr %v2429, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658849, label %bb_5395658835

bb_5395658835:                                    ; preds = %bb_5395658840, %bb_5395658800
  %v2430 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2430, ptr %PC, align 8
  %v2431 = add i64 %v2430, 3
  store i64 %v2431, ptr %NEXT_PC, align 8
  %v2432 = load i64, ptr %RDI, align 8
  %v2433 = load i64, ptr %RBX, align 8
  %v2434 = add i64 %v2433, 48
  %v2435 = load ptr, ptr %MEMORY, align 8
  %v2436 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2435, ptr %state, ptr %RDI, i64 %v2432, i64 %v2434)
  store ptr %v2436, ptr %MEMORY, align 8
  %v2437 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2437, ptr %PC, align 8
  %v2438 = add i64 %v2437, 2
  store i64 %v2438, ptr %NEXT_PC, align 8
  %v2439 = load i64, ptr %NEXT_PC, align 8
  %v2440 = add i64 %v2439, 29
  %v2441 = load i64, ptr %NEXT_PC, align 8
  %v2442 = load ptr, ptr %MEMORY, align 8
  %v2443 = call ptr @_ZN12_GLOBAL__N_13JNSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2442, ptr %state, ptr %BRANCH_TAKEN, i64 %v2440, i64 %v2441, ptr %NEXT_PC)
  store ptr %v2443, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658869, label %bb_5395658840

bb_5395658840:                                    ; preds = %bb_5395658835
  %v2444 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2444, ptr %PC, align 8
  %v2445 = add i64 %v2444, 4
  store i64 %v2445, ptr %NEXT_PC, align 8
  %v2446 = load i64, ptr %RBX, align 8
  %v2447 = add i64 %v2446, 8
  %v2448 = load ptr, ptr %MEMORY, align 8
  %v2449 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2448, ptr %state, ptr %RBX, i64 %v2447)
  store ptr %v2449, ptr %MEMORY, align 8
  %v2450 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2450, ptr %PC, align 8
  %v2451 = add i64 %v2450, 3
  store i64 %v2451, ptr %NEXT_PC, align 8
  %v2452 = load i64, ptr %RBX, align 8
  %v2453 = load i64, ptr %RBX, align 8
  %v2454 = load ptr, ptr %MEMORY, align 8
  %v2455 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2454, ptr %state, i64 %v2452, i64 %v2453)
  store ptr %v2455, ptr %MEMORY, align 8
  %v2456 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2456, ptr %PC, align 8
  %v2457 = add i64 %v2456, 2
  store i64 %v2457, ptr %NEXT_PC, align 8
  %v2458 = load i64, ptr %NEXT_PC, align 8
  %v2459 = sub i64 %v2458, 14
  %v2460 = load i64, ptr %NEXT_PC, align 8
  %v2461 = load ptr, ptr %MEMORY, align 8
  %v2462 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2461, ptr %state, ptr %BRANCH_TAKEN, i64 %v2459, i64 %v2460, ptr %NEXT_PC)
  store ptr %v2462, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658835, label %bb_5395658849

bb_5395658849:                                    ; preds = %bb_5395658840, %bb_5395658800
  %v2463 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2463, ptr %PC, align 8
  %v2464 = add i64 %v2463, 4
  store i64 %v2464, ptr %NEXT_PC, align 8
  %v2465 = load i64, ptr %RSI, align 8
  %v2466 = add i64 %v2465, 40
  %v2467 = load ptr, ptr %MEMORY, align 8
  %v2468 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2467, ptr %state, ptr %RAX, i64 %v2466)
  store ptr %v2468, ptr %MEMORY, align 8
  %v2469 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2469, ptr %PC, align 8
  %v2470 = add i64 %v2469, 5
  store i64 %v2470, ptr %NEXT_PC, align 8
  %v2471 = load i64, ptr %RSP, align 8
  %v2472 = add i64 %v2471, 48
  %v2473 = load ptr, ptr %MEMORY, align 8
  %v2474 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2473, ptr %state, ptr %RBX, i64 %v2472)
  store ptr %v2474, ptr %MEMORY, align 8
  %v2475 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2475, ptr %PC, align 8
  %v2476 = add i64 %v2475, 5
  store i64 %v2476, ptr %NEXT_PC, align 8
  %v2477 = load i64, ptr %RSP, align 8
  %v2478 = add i64 %v2477, 56
  %v2479 = load ptr, ptr %MEMORY, align 8
  %v2480 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2479, ptr %state, ptr %RSI, i64 %v2478)
  store ptr %v2480, ptr %MEMORY, align 8
  %v2481 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2481, ptr %PC, align 8
  %v2482 = add i64 %v2481, 4
  store i64 %v2482, ptr %NEXT_PC, align 8
  %v2483 = load i64, ptr %RSP, align 8
  %v2484 = load ptr, ptr %MEMORY, align 8
  %v2485 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2484, ptr %state, ptr %RSP, i64 %v2483, i64 32)
  store ptr %v2485, ptr %MEMORY, align 8
  %v2486 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2486, ptr %PC, align 8
  %v2487 = add i64 %v2486, 1
  store i64 %v2487, ptr %NEXT_PC, align 8
  %v2488 = load ptr, ptr %MEMORY, align 8
  %v2489 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v2488, ptr %state, ptr %RDI)
  store ptr %v2489, ptr %MEMORY, align 8
  %v2490 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2490, ptr %PC, align 8
  %v2491 = add i64 %v2490, 1
  store i64 %v2491, ptr %NEXT_PC, align 8
  %v2492 = load ptr, ptr %MEMORY, align 8
  %v2493 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2492, ptr %state, ptr %NEXT_PC)
  store ptr %v2493, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658869:                                    ; preds = %bb_5395658835
  %v2494 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2494, ptr %PC, align 8
  %v2495 = add i64 %v2494, 5
  store i64 %v2495, ptr %NEXT_PC, align 8
  %v2496 = load i64, ptr %RSP, align 8
  %v2497 = add i64 %v2496, 56
  %v2498 = load ptr, ptr %MEMORY, align 8
  %v2499 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2498, ptr %state, ptr %RSI, i64 %v2497)
  store ptr %v2499, ptr %MEMORY, align 8
  %v2500 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2500, ptr %PC, align 8
  %v2501 = add i64 %v2500, 3
  store i64 %v2501, ptr %NEXT_PC, align 8
  %v2502 = load i32, ptr %EDI, align 4
  %v2503 = zext i32 %v2502 to i64
  %v2504 = load ptr, ptr %MEMORY, align 8
  %v2505 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v2504, ptr %state, ptr %RAX, i64 %v2503)
  store ptr %v2505, ptr %MEMORY, align 8
  %v2506 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2506, ptr %PC, align 8
  %v2507 = add i64 %v2506, 4
  store i64 %v2507, ptr %NEXT_PC, align 8
  %v2508 = load i64, ptr %RAX, align 8
  %v2509 = load i64, ptr %RAX, align 8
  %v2510 = mul i64 %v2509, 4
  %v2511 = add i64 %v2508, %v2510
  %v2512 = load ptr, ptr %MEMORY, align 8
  %v2513 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v2512, ptr %state, ptr %RCX, i64 %v2511)
  store ptr %v2513, ptr %MEMORY, align 8
  %v2514 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2514, ptr %PC, align 8
  %v2515 = add i64 %v2514, 4
  store i64 %v2515, ptr %NEXT_PC, align 8
  %v2516 = load i64, ptr %RBX, align 8
  %v2517 = add i64 %v2516, 40
  %v2518 = load ptr, ptr %MEMORY, align 8
  %v2519 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2518, ptr %state, ptr %RAX, i64 %v2517)
  store ptr %v2519, ptr %MEMORY, align 8
  %v2520 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2520, ptr %PC, align 8
  %v2521 = add i64 %v2520, 5
  store i64 %v2521, ptr %NEXT_PC, align 8
  %v2522 = load i64, ptr %RSP, align 8
  %v2523 = add i64 %v2522, 48
  %v2524 = load ptr, ptr %MEMORY, align 8
  %v2525 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2524, ptr %state, ptr %RBX, i64 %v2523)
  store ptr %v2525, ptr %MEMORY, align 8
  %v2526 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2526, ptr %PC, align 8
  %v2527 = add i64 %v2526, 4
  store i64 %v2527, ptr %NEXT_PC, align 8
  %v2528 = load i64, ptr %RAX, align 8
  %v2529 = load i64, ptr %RCX, align 8
  %v2530 = mul i64 %v2529, 8
  %v2531 = add i64 %v2528, %v2530
  %v2532 = load ptr, ptr %MEMORY, align 8
  %v2533 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v2532, ptr %state, ptr %RAX, i64 %v2531)
  store ptr %v2533, ptr %MEMORY, align 8
  %v2534 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2534, ptr %PC, align 8
  %v2535 = add i64 %v2534, 4
  store i64 %v2535, ptr %NEXT_PC, align 8
  %v2536 = load i64, ptr %RSP, align 8
  %v2537 = load ptr, ptr %MEMORY, align 8
  %v2538 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2537, ptr %state, ptr %RSP, i64 %v2536, i64 32)
  store ptr %v2538, ptr %MEMORY, align 8
  %v2539 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2539, ptr %PC, align 8
  %v2540 = add i64 %v2539, 1
  store i64 %v2540, ptr %NEXT_PC, align 8
  %v2541 = load ptr, ptr %MEMORY, align 8
  %v2542 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v2541, ptr %state, ptr %RDI)
  store ptr %v2542, ptr %MEMORY, align 8
  %v2543 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2543, ptr %PC, align 8
  %v2544 = add i64 %v2543, 1
  store i64 %v2544, ptr %NEXT_PC, align 8
  %v2545 = load ptr, ptr %MEMORY, align 8
  %v2546 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2545, ptr %state, ptr %NEXT_PC)
  store ptr %v2546, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658900:                                    ; No predecessors!
  %v2547 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2547, ptr %PC, align 8
  %v2548 = add i64 %v2547, 1
  store i64 %v2548, ptr %NEXT_PC, align 8
  %v2549 = load ptr, ptr %MEMORY, align 8
  %v2550 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2549, ptr %state, ptr undef)
  store ptr %v2550, ptr %MEMORY, align 8
  %v2551 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2551, ptr %PC, align 8
  %v2552 = add i64 %v2551, 1
  store i64 %v2552, ptr %NEXT_PC, align 8
  %v2553 = load ptr, ptr %MEMORY, align 8
  %v2554 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2553, ptr %state, ptr undef)
  store ptr %v2554, ptr %MEMORY, align 8
  %v2555 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2555, ptr %PC, align 8
  %v2556 = add i64 %v2555, 1
  store i64 %v2556, ptr %NEXT_PC, align 8
  %v2557 = load ptr, ptr %MEMORY, align 8
  %v2558 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2557, ptr %state, ptr undef)
  store ptr %v2558, ptr %MEMORY, align 8
  %v2559 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2559, ptr %PC, align 8
  %v2560 = add i64 %v2559, 1
  store i64 %v2560, ptr %NEXT_PC, align 8
  %v2561 = load ptr, ptr %MEMORY, align 8
  %v2562 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2561, ptr %state, ptr undef)
  store ptr %v2562, ptr %MEMORY, align 8
  %v2563 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2563, ptr %PC, align 8
  %v2564 = add i64 %v2563, 1
  store i64 %v2564, ptr %NEXT_PC, align 8
  %v2565 = load ptr, ptr %MEMORY, align 8
  %v2566 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2565, ptr %state, ptr undef)
  store ptr %v2566, ptr %MEMORY, align 8
  %v2567 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2567, ptr %PC, align 8
  %v2568 = add i64 %v2567, 1
  store i64 %v2568, ptr %NEXT_PC, align 8
  %v2569 = load ptr, ptr %MEMORY, align 8
  %v2570 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2569, ptr %state, ptr undef)
  store ptr %v2570, ptr %MEMORY, align 8
  %v2571 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2571, ptr %PC, align 8
  %v2572 = add i64 %v2571, 1
  store i64 %v2572, ptr %NEXT_PC, align 8
  %v2573 = load ptr, ptr %MEMORY, align 8
  %v2574 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2573, ptr %state, ptr undef)
  store ptr %v2574, ptr %MEMORY, align 8
  %v2575 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2575, ptr %PC, align 8
  %v2576 = add i64 %v2575, 1
  store i64 %v2576, ptr %NEXT_PC, align 8
  %v2577 = load ptr, ptr %MEMORY, align 8
  %v2578 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2577, ptr %state, ptr undef)
  store ptr %v2578, ptr %MEMORY, align 8
  %v2579 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2579, ptr %PC, align 8
  %v2580 = add i64 %v2579, 1
  store i64 %v2580, ptr %NEXT_PC, align 8
  %v2581 = load ptr, ptr %MEMORY, align 8
  %v2582 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2581, ptr %state, ptr undef)
  store ptr %v2582, ptr %MEMORY, align 8
  %v2583 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2583, ptr %PC, align 8
  %v2584 = add i64 %v2583, 1
  store i64 %v2584, ptr %NEXT_PC, align 8
  %v2585 = load ptr, ptr %MEMORY, align 8
  %v2586 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2585, ptr %state, ptr undef)
  store ptr %v2586, ptr %MEMORY, align 8
  %v2587 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2587, ptr %PC, align 8
  %v2588 = add i64 %v2587, 1
  store i64 %v2588, ptr %NEXT_PC, align 8
  %v2589 = load ptr, ptr %MEMORY, align 8
  %v2590 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2589, ptr %state, ptr undef)
  store ptr %v2590, ptr %MEMORY, align 8
  %v2591 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2591, ptr %PC, align 8
  %v2592 = add i64 %v2591, 1
  store i64 %v2592, ptr %NEXT_PC, align 8
  %v2593 = load ptr, ptr %MEMORY, align 8
  %v2594 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2593, ptr %state, ptr undef)
  store ptr %v2594, ptr %MEMORY, align 8
  %v2595 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2595, ptr %PC, align 8
  %v2596 = add i64 %v2595, 5
  store i64 %v2596, ptr %NEXT_PC, align 8
  %v2597 = load i64, ptr %NEXT_PC, align 8
  %v2598 = sub i64 %v2597, 117
  %v2599 = load ptr, ptr %MEMORY, align 8
  %v2600 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2599, ptr %state, i64 %v2598, ptr %NEXT_PC)
  store ptr %v2600, ptr %MEMORY, align 8
  br label %bb_5395658800
  %v2601 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2601, ptr %PC, align 8
  %v2602 = add i64 %v2601, 1
  store i64 %v2602, ptr %NEXT_PC, align 8
  %v2603 = load ptr, ptr %MEMORY, align 8
  %v2604 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2603, ptr %state, ptr undef)
  store ptr %v2604, ptr %MEMORY, align 8
  %v2605 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2605, ptr %PC, align 8
  %v2606 = add i64 %v2605, 1
  store i64 %v2606, ptr %NEXT_PC, align 8
  %v2607 = load ptr, ptr %MEMORY, align 8
  %v2608 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2607, ptr %state, ptr undef)
  store ptr %v2608, ptr %MEMORY, align 8
  %v2609 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2609, ptr %PC, align 8
  %v2610 = add i64 %v2609, 1
  store i64 %v2610, ptr %NEXT_PC, align 8
  %v2611 = load ptr, ptr %MEMORY, align 8
  %v2612 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2611, ptr %state, ptr undef)
  store ptr %v2612, ptr %MEMORY, align 8
  %v2613 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2613, ptr %PC, align 8
  %v2614 = add i64 %v2613, 1
  store i64 %v2614, ptr %NEXT_PC, align 8
  %v2615 = load ptr, ptr %MEMORY, align 8
  %v2616 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2615, ptr %state, ptr undef)
  store ptr %v2616, ptr %MEMORY, align 8
  %v2617 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2617, ptr %PC, align 8
  %v2618 = add i64 %v2617, 1
  store i64 %v2618, ptr %NEXT_PC, align 8
  %v2619 = load ptr, ptr %MEMORY, align 8
  %v2620 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2619, ptr %state, ptr undef)
  store ptr %v2620, ptr %MEMORY, align 8
  %v2621 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2621, ptr %PC, align 8
  %v2622 = add i64 %v2621, 1
  store i64 %v2622, ptr %NEXT_PC, align 8
  %v2623 = load ptr, ptr %MEMORY, align 8
  %v2624 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2623, ptr %state, ptr undef)
  store ptr %v2624, ptr %MEMORY, align 8
  %v2625 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2625, ptr %PC, align 8
  %v2626 = add i64 %v2625, 1
  store i64 %v2626, ptr %NEXT_PC, align 8
  %v2627 = load ptr, ptr %MEMORY, align 8
  %v2628 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2627, ptr %state, ptr undef)
  store ptr %v2628, ptr %MEMORY, align 8
  %v2629 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2629, ptr %PC, align 8
  %v2630 = add i64 %v2629, 1
  store i64 %v2630, ptr %NEXT_PC, align 8
  %v2631 = load ptr, ptr %MEMORY, align 8
  %v2632 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2631, ptr %state, ptr undef)
  store ptr %v2632, ptr %MEMORY, align 8
  %v2633 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2633, ptr %PC, align 8
  %v2634 = add i64 %v2633, 1
  store i64 %v2634, ptr %NEXT_PC, align 8
  %v2635 = load ptr, ptr %MEMORY, align 8
  %v2636 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2635, ptr %state, ptr undef)
  store ptr %v2636, ptr %MEMORY, align 8
  %v2637 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2637, ptr %PC, align 8
  %v2638 = add i64 %v2637, 1
  store i64 %v2638, ptr %NEXT_PC, align 8
  %v2639 = load ptr, ptr %MEMORY, align 8
  %v2640 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2639, ptr %state, ptr undef)
  store ptr %v2640, ptr %MEMORY, align 8
  %v2641 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2641, ptr %PC, align 8
  %v2642 = add i64 %v2641, 1
  store i64 %v2642, ptr %NEXT_PC, align 8
  %v2643 = load ptr, ptr %MEMORY, align 8
  %v2644 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2643, ptr %state, ptr undef)
  store ptr %v2644, ptr %MEMORY, align 8
  %v2645 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2645, ptr %PC, align 8
  %v2646 = add i64 %v2645, 5
  store i64 %v2646, ptr %NEXT_PC, align 8
  %v2647 = load i64, ptr %RSP, align 8
  %v2648 = add i64 %v2647, 8
  %v2649 = load i64, ptr %RBX, align 8
  %v2650 = load ptr, ptr %MEMORY, align 8
  %v2651 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2650, ptr %state, i64 %v2648, i64 %v2649)
  store ptr %v2651, ptr %MEMORY, align 8
  %v2652 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2652, ptr %PC, align 8
  %v2653 = add i64 %v2652, 5
  store i64 %v2653, ptr %NEXT_PC, align 8
  %v2654 = load i64, ptr %RSP, align 8
  %v2655 = add i64 %v2654, 16
  %v2656 = load i64, ptr %RBP, align 8
  %v2657 = load ptr, ptr %MEMORY, align 8
  %v2658 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2657, ptr %state, i64 %v2655, i64 %v2656)
  store ptr %v2658, ptr %MEMORY, align 8
  %v2659 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2659, ptr %PC, align 8
  %v2660 = add i64 %v2659, 5
  store i64 %v2660, ptr %NEXT_PC, align 8
  %v2661 = load i64, ptr %RSP, align 8
  %v2662 = add i64 %v2661, 24
  %v2663 = load i64, ptr %RSI, align 8
  %v2664 = load ptr, ptr %MEMORY, align 8
  %v2665 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2664, ptr %state, i64 %v2662, i64 %v2663)
  store ptr %v2665, ptr %MEMORY, align 8
  %v2666 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2666, ptr %PC, align 8
  %v2667 = add i64 %v2666, 1
  store i64 %v2667, ptr %NEXT_PC, align 8
  %v2668 = load i64, ptr %RDI, align 8
  %v2669 = load ptr, ptr %MEMORY, align 8
  %v2670 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v2669, ptr %state, i64 %v2668)
  store ptr %v2670, ptr %MEMORY, align 8
  %v2671 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2671, ptr %PC, align 8
  %v2672 = add i64 %v2671, 4
  store i64 %v2672, ptr %NEXT_PC, align 8
  %v2673 = load i64, ptr %RSP, align 8
  %v2674 = load ptr, ptr %MEMORY, align 8
  %v2675 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2674, ptr %state, ptr %RSP, i64 %v2673, i64 32)
  store ptr %v2675, ptr %MEMORY, align 8
  %v2676 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2676, ptr %PC, align 8
  %v2677 = add i64 %v2676, 3
  store i64 %v2677, ptr %NEXT_PC, align 8
  %v2678 = load i64, ptr %RDX, align 8
  %v2679 = load ptr, ptr %MEMORY, align 8
  %v2680 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2679, ptr %state, ptr %RBP, i64 %v2678)
  store ptr %v2680, ptr %MEMORY, align 8
  %v2681 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2681, ptr %PC, align 8
  %v2682 = add i64 %v2681, 3
  store i64 %v2682, ptr %NEXT_PC, align 8
  %v2683 = load i64, ptr %RCX, align 8
  %v2684 = load ptr, ptr %MEMORY, align 8
  %v2685 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2684, ptr %state, ptr %RDI, i64 %v2683)
  store ptr %v2685, ptr %MEMORY, align 8
  %v2686 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2686, ptr %PC, align 8
  %v2687 = add i64 %v2686, 2
  store i64 %v2687, ptr %NEXT_PC, align 8
  %v2688 = load i64, ptr %RBX, align 8
  %v2689 = load i32, ptr %EBX, align 4
  %v2690 = zext i32 %v2689 to i64
  %v2691 = load ptr, ptr %MEMORY, align 8
  %v2692 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2691, ptr %state, ptr %RBX, i64 %v2688, i64 %v2690)
  store ptr %v2692, ptr %MEMORY, align 8
  %v2693 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2693, ptr %PC, align 8
  %v2694 = add i64 %v2693, 5
  store i64 %v2694, ptr %NEXT_PC, align 8
  %v2695 = load i64, ptr %NEXT_PC, align 8
  %v2696 = add i64 %v2695, 351
  %v2697 = load i64, ptr %NEXT_PC, align 8
  %v2698 = load ptr, ptr %MEMORY, align 8
  %v2699 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2698, ptr %state, i64 %v2696, ptr %NEXT_PC, i64 %v2697, ptr %RETURN_PC)
  store ptr %v2699, ptr %MEMORY, align 8
  %v2700 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2700, ptr %PC, align 8
  %v2701 = add i64 %v2700, 2
  store i64 %v2701, ptr %NEXT_PC, align 8
  %v2702 = load i32, ptr %EAX, align 4
  %v2703 = zext i32 %v2702 to i64
  %v2704 = load i32, ptr %EAX, align 4
  %v2705 = zext i32 %v2704 to i64
  %v2706 = load ptr, ptr %MEMORY, align 8
  %v2707 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2706, ptr %state, i64 %v2703, i64 %v2705)
  store ptr %v2707, ptr %MEMORY, align 8
  %v2708 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2708, ptr %PC, align 8
  %v2709 = add i64 %v2708, 2
  store i64 %v2709, ptr %NEXT_PC, align 8
  %v2710 = load i64, ptr %NEXT_PC, align 8
  %v2711 = add i64 %v2710, 42
  %v2712 = load i64, ptr %NEXT_PC, align 8
  %v2713 = load ptr, ptr %MEMORY, align 8
  %v2714 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2713, ptr %state, ptr %BRANCH_TAKEN, i64 %v2711, i64 %v2712, ptr %NEXT_PC)
  store ptr %v2714, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659007, label %bb_5395658965

bb_5395658965:                                    ; preds = %bb_5395658993, %bb_5395658900
  %v2715 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2715, ptr %PC, align 8
  %v2716 = add i64 %v2715, 2
  store i64 %v2716, ptr %NEXT_PC, align 8
  %v2717 = load i32, ptr %EBX, align 4
  %v2718 = zext i32 %v2717 to i64
  %v2719 = load ptr, ptr %MEMORY, align 8
  %v2720 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2719, ptr %state, ptr %RDX, i64 %v2718)
  store ptr %v2720, ptr %MEMORY, align 8
  %v2721 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2721, ptr %PC, align 8
  %v2722 = add i64 %v2721, 3
  store i64 %v2722, ptr %NEXT_PC, align 8
  %v2723 = load i64, ptr %RDI, align 8
  %v2724 = load ptr, ptr %MEMORY, align 8
  %v2725 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2724, ptr %state, ptr %RCX, i64 %v2723)
  store ptr %v2725, ptr %MEMORY, align 8
  %v2726 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2726, ptr %PC, align 8
  %v2727 = add i64 %v2726, 5
  store i64 %v2727, ptr %NEXT_PC, align 8
  %v2728 = load i64, ptr %NEXT_PC, align 8
  %v2729 = sub i64 %v2728, 175
  %v2730 = load i64, ptr %NEXT_PC, align 8
  %v2731 = load ptr, ptr %MEMORY, align 8
  %v2732 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2731, ptr %state, i64 %v2729, ptr %NEXT_PC, i64 %v2730, ptr %RETURN_PC)
  store ptr %v2732, ptr %MEMORY, align 8
  %v2733 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2733, ptr %PC, align 8
  %v2734 = add i64 %v2733, 3
  store i64 %v2734, ptr %NEXT_PC, align 8
  %v2735 = load i64, ptr %RBP, align 8
  %v2736 = load ptr, ptr %MEMORY, align 8
  %v2737 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2736, ptr %state, ptr %RDX, i64 %v2735)
  store ptr %v2737, ptr %MEMORY, align 8
  %v2738 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2738, ptr %PC, align 8
  %v2739 = add i64 %v2738, 3
  store i64 %v2739, ptr %NEXT_PC, align 8
  %v2740 = load i64, ptr %RAX, align 8
  %v2741 = load ptr, ptr %MEMORY, align 8
  %v2742 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2741, ptr %state, ptr %RSI, i64 %v2740)
  store ptr %v2742, ptr %MEMORY, align 8
  %v2743 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2743, ptr %PC, align 8
  %v2744 = add i64 %v2743, 3
  store i64 %v2744, ptr %NEXT_PC, align 8
  %v2745 = load i64, ptr %RAX, align 8
  %v2746 = load ptr, ptr %MEMORY, align 8
  %v2747 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2746, ptr %state, ptr %RCX, i64 %v2745)
  store ptr %v2747, ptr %MEMORY, align 8
  %v2748 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2748, ptr %PC, align 8
  %v2749 = add i64 %v2748, 5
  store i64 %v2749, ptr %NEXT_PC, align 8
  %v2750 = load i64, ptr %NEXT_PC, align 8
  %v2751 = add i64 %v2750, 45331
  %v2752 = load i64, ptr %NEXT_PC, align 8
  %v2753 = load ptr, ptr %MEMORY, align 8
  %v2754 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2753, ptr %state, i64 %v2751, ptr %NEXT_PC, i64 %v2752, ptr %RETURN_PC)
  store ptr %v2754, ptr %MEMORY, align 8
  %v2755 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2755, ptr %PC, align 8
  %v2756 = add i64 %v2755, 2
  store i64 %v2756, ptr %NEXT_PC, align 8
  %v2757 = load i32, ptr %EAX, align 4
  %v2758 = zext i32 %v2757 to i64
  %v2759 = load i32, ptr %EAX, align 4
  %v2760 = zext i32 %v2759 to i64
  %v2761 = load ptr, ptr %MEMORY, align 8
  %v2762 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2761, ptr %state, i64 %v2758, i64 %v2760)
  store ptr %v2762, ptr %MEMORY, align 8
  %v2763 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2763, ptr %PC, align 8
  %v2764 = add i64 %v2763, 2
  store i64 %v2764, ptr %NEXT_PC, align 8
  %v2765 = load i64, ptr %NEXT_PC, align 8
  %v2766 = add i64 %v2765, 37
  %v2767 = load i64, ptr %NEXT_PC, align 8
  %v2768 = load ptr, ptr %MEMORY, align 8
  %v2769 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2768, ptr %state, ptr %BRANCH_TAKEN, i64 %v2766, i64 %v2767, ptr %NEXT_PC)
  store ptr %v2769, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659030, label %bb_5395658993

bb_5395658993:                                    ; preds = %bb_5395658965
  %v2770 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2770, ptr %PC, align 8
  %v2771 = add i64 %v2770, 3
  store i64 %v2771, ptr %NEXT_PC, align 8
  %v2772 = load i64, ptr %RDI, align 8
  %v2773 = load ptr, ptr %MEMORY, align 8
  %v2774 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2773, ptr %state, ptr %RCX, i64 %v2772)
  store ptr %v2774, ptr %MEMORY, align 8
  %v2775 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2775, ptr %PC, align 8
  %v2776 = add i64 %v2775, 2
  store i64 %v2776, ptr %NEXT_PC, align 8
  %v2777 = load i64, ptr %RBX, align 8
  %v2778 = load ptr, ptr %MEMORY, align 8
  %v2779 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2778, ptr %state, ptr %RBX, i64 %v2777)
  store ptr %v2779, ptr %MEMORY, align 8
  %v2780 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2780, ptr %PC, align 8
  %v2781 = add i64 %v2780, 5
  store i64 %v2781, ptr %NEXT_PC, align 8
  %v2782 = load i64, ptr %NEXT_PC, align 8
  %v2783 = add i64 %v2782, 309
  %v2784 = load i64, ptr %NEXT_PC, align 8
  %v2785 = load ptr, ptr %MEMORY, align 8
  %v2786 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2785, ptr %state, i64 %v2783, ptr %NEXT_PC, i64 %v2784, ptr %RETURN_PC)
  store ptr %v2786, ptr %MEMORY, align 8
  %v2787 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2787, ptr %PC, align 8
  %v2788 = add i64 %v2787, 2
  store i64 %v2788, ptr %NEXT_PC, align 8
  %v2789 = load i32, ptr %EBX, align 4
  %v2790 = zext i32 %v2789 to i64
  %v2791 = load i32, ptr %EAX, align 4
  %v2792 = zext i32 %v2791 to i64
  %v2793 = load ptr, ptr %MEMORY, align 8
  %v2794 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2793, ptr %state, i64 %v2790, i64 %v2792)
  store ptr %v2794, ptr %MEMORY, align 8
  %v2795 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2795, ptr %PC, align 8
  %v2796 = add i64 %v2795, 2
  store i64 %v2796, ptr %NEXT_PC, align 8
  %v2797 = load i64, ptr %NEXT_PC, align 8
  %v2798 = sub i64 %v2797, 42
  %v2799 = load i64, ptr %NEXT_PC, align 8
  %v2800 = load ptr, ptr %MEMORY, align 8
  %v2801 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2800, ptr %state, ptr %BRANCH_TAKEN, i64 %v2798, i64 %v2799, ptr %NEXT_PC)
  store ptr %v2801, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658965, label %bb_5395659007

bb_5395659007:                                    ; preds = %bb_5395658993, %bb_5395658900
  %v2802 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2802, ptr %PC, align 8
  %v2803 = add i64 %v2802, 2
  store i64 %v2803, ptr %NEXT_PC, align 8
  %v2804 = load i64, ptr %RAX, align 8
  %v2805 = load i32, ptr %EAX, align 4
  %v2806 = zext i32 %v2805 to i64
  %v2807 = load ptr, ptr %MEMORY, align 8
  %v2808 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2807, ptr %state, ptr %RAX, i64 %v2804, i64 %v2806)
  store ptr %v2808, ptr %MEMORY, align 8
  br label %bb_5395659009

bb_5395659009:                                    ; preds = %bb_5395659030, %bb_5395659007
  %v2809 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2809, ptr %PC, align 8
  %v2810 = add i64 %v2809, 5
  store i64 %v2810, ptr %NEXT_PC, align 8
  %v2811 = load i64, ptr %RSP, align 8
  %v2812 = add i64 %v2811, 48
  %v2813 = load ptr, ptr %MEMORY, align 8
  %v2814 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2813, ptr %state, ptr %RBX, i64 %v2812)
  store ptr %v2814, ptr %MEMORY, align 8
  %v2815 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2815, ptr %PC, align 8
  %v2816 = add i64 %v2815, 5
  store i64 %v2816, ptr %NEXT_PC, align 8
  %v2817 = load i64, ptr %RSP, align 8
  %v2818 = add i64 %v2817, 56
  %v2819 = load ptr, ptr %MEMORY, align 8
  %v2820 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2819, ptr %state, ptr %RBP, i64 %v2818)
  store ptr %v2820, ptr %MEMORY, align 8
  %v2821 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2821, ptr %PC, align 8
  %v2822 = add i64 %v2821, 5
  store i64 %v2822, ptr %NEXT_PC, align 8
  %v2823 = load i64, ptr %RSP, align 8
  %v2824 = add i64 %v2823, 64
  %v2825 = load ptr, ptr %MEMORY, align 8
  %v2826 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2825, ptr %state, ptr %RSI, i64 %v2824)
  store ptr %v2826, ptr %MEMORY, align 8
  %v2827 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2827, ptr %PC, align 8
  %v2828 = add i64 %v2827, 4
  store i64 %v2828, ptr %NEXT_PC, align 8
  %v2829 = load i64, ptr %RSP, align 8
  %v2830 = load ptr, ptr %MEMORY, align 8
  %v2831 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2830, ptr %state, ptr %RSP, i64 %v2829, i64 32)
  store ptr %v2831, ptr %MEMORY, align 8
  %v2832 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2832, ptr %PC, align 8
  %v2833 = add i64 %v2832, 1
  store i64 %v2833, ptr %NEXT_PC, align 8
  %v2834 = load ptr, ptr %MEMORY, align 8
  %v2835 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v2834, ptr %state, ptr %RDI)
  store ptr %v2835, ptr %MEMORY, align 8
  %v2836 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2836, ptr %PC, align 8
  %v2837 = add i64 %v2836, 1
  store i64 %v2837, ptr %NEXT_PC, align 8
  %v2838 = load ptr, ptr %MEMORY, align 8
  %v2839 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2838, ptr %state, ptr %NEXT_PC)
  store ptr %v2839, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659030:                                    ; preds = %bb_5395658965
  %v2840 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2840, ptr %PC, align 8
  %v2841 = add i64 %v2840, 3
  store i64 %v2841, ptr %NEXT_PC, align 8
  %v2842 = load i64, ptr %RSI, align 8
  %v2843 = load ptr, ptr %MEMORY, align 8
  %v2844 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2843, ptr %state, ptr %RAX, i64 %v2842)
  store ptr %v2844, ptr %MEMORY, align 8
  %v2845 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2845, ptr %PC, align 8
  %v2846 = add i64 %v2845, 2
  store i64 %v2846, ptr %NEXT_PC, align 8
  %v2847 = load i64, ptr %NEXT_PC, align 8
  %v2848 = sub i64 %v2847, 26
  %v2849 = load ptr, ptr %MEMORY, align 8
  %v2850 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2849, ptr %state, i64 %v2848, ptr %NEXT_PC)
  store ptr %v2850, ptr %MEMORY, align 8
  br label %bb_5395659009
  %v2851 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2851, ptr %PC, align 8
  %v2852 = add i64 %v2851, 1
  store i64 %v2852, ptr %NEXT_PC, align 8
  %v2853 = load ptr, ptr %MEMORY, align 8
  %v2854 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2853, ptr %state, ptr undef)
  store ptr %v2854, ptr %MEMORY, align 8
  %v2855 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2855, ptr %PC, align 8
  %v2856 = add i64 %v2855, 1
  store i64 %v2856, ptr %NEXT_PC, align 8
  %v2857 = load ptr, ptr %MEMORY, align 8
  %v2858 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2857, ptr %state, ptr undef)
  store ptr %v2858, ptr %MEMORY, align 8
  %v2859 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2859, ptr %PC, align 8
  %v2860 = add i64 %v2859, 1
  store i64 %v2860, ptr %NEXT_PC, align 8
  %v2861 = load ptr, ptr %MEMORY, align 8
  %v2862 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2861, ptr %state, ptr undef)
  store ptr %v2862, ptr %MEMORY, align 8
  %v2863 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2863, ptr %PC, align 8
  %v2864 = add i64 %v2863, 1
  store i64 %v2864, ptr %NEXT_PC, align 8
  %v2865 = load ptr, ptr %MEMORY, align 8
  %v2866 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2865, ptr %state, ptr undef)
  store ptr %v2866, ptr %MEMORY, align 8
  %v2867 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2867, ptr %PC, align 8
  %v2868 = add i64 %v2867, 1
  store i64 %v2868, ptr %NEXT_PC, align 8
  %v2869 = load ptr, ptr %MEMORY, align 8
  %v2870 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2869, ptr %state, ptr undef)
  store ptr %v2870, ptr %MEMORY, align 8
  %v2871 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2871, ptr %PC, align 8
  %v2872 = add i64 %v2871, 1
  store i64 %v2872, ptr %NEXT_PC, align 8
  %v2873 = load ptr, ptr %MEMORY, align 8
  %v2874 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2873, ptr %state, ptr undef)
  store ptr %v2874, ptr %MEMORY, align 8
  %v2875 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2875, ptr %PC, align 8
  %v2876 = add i64 %v2875, 1
  store i64 %v2876, ptr %NEXT_PC, align 8
  %v2877 = load ptr, ptr %MEMORY, align 8
  %v2878 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2877, ptr %state, ptr undef)
  store ptr %v2878, ptr %MEMORY, align 8
  %v2879 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2879, ptr %PC, align 8
  %v2880 = add i64 %v2879, 1
  store i64 %v2880, ptr %NEXT_PC, align 8
  %v2881 = load ptr, ptr %MEMORY, align 8
  %v2882 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2881, ptr %state, ptr undef)
  store ptr %v2882, ptr %MEMORY, align 8
  %v2883 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2883, ptr %PC, align 8
  %v2884 = add i64 %v2883, 1
  store i64 %v2884, ptr %NEXT_PC, align 8
  %v2885 = load ptr, ptr %MEMORY, align 8
  %v2886 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2885, ptr %state, ptr undef)
  store ptr %v2886, ptr %MEMORY, align 8
  %v2887 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2887, ptr %PC, align 8
  %v2888 = add i64 %v2887, 1
  store i64 %v2888, ptr %NEXT_PC, align 8
  %v2889 = load ptr, ptr %MEMORY, align 8
  %v2890 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2889, ptr %state, ptr undef)
  store ptr %v2890, ptr %MEMORY, align 8
  %v2891 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2891, ptr %PC, align 8
  %v2892 = add i64 %v2891, 1
  store i64 %v2892, ptr %NEXT_PC, align 8
  %v2893 = load ptr, ptr %MEMORY, align 8
  %v2894 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2893, ptr %state, ptr undef)
  store ptr %v2894, ptr %MEMORY, align 8
  %v2895 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2895, ptr %PC, align 8
  %v2896 = add i64 %v2895, 1
  store i64 %v2896, ptr %NEXT_PC, align 8
  %v2897 = load ptr, ptr %MEMORY, align 8
  %v2898 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2897, ptr %state, ptr undef)
  store ptr %v2898, ptr %MEMORY, align 8
  %v2899 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2899, ptr %PC, align 8
  %v2900 = add i64 %v2899, 1
  store i64 %v2900, ptr %NEXT_PC, align 8
  %v2901 = load ptr, ptr %MEMORY, align 8
  %v2902 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2901, ptr %state, ptr undef)
  store ptr %v2902, ptr %MEMORY, align 8
  %v2903 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2903, ptr %PC, align 8
  %v2904 = add i64 %v2903, 1
  store i64 %v2904, ptr %NEXT_PC, align 8
  %v2905 = load ptr, ptr %MEMORY, align 8
  %v2906 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2905, ptr %state, ptr undef)
  store ptr %v2906, ptr %MEMORY, align 8
  %v2907 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2907, ptr %PC, align 8
  %v2908 = add i64 %v2907, 1
  store i64 %v2908, ptr %NEXT_PC, align 8
  %v2909 = load ptr, ptr %MEMORY, align 8
  %v2910 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2909, ptr %state, ptr undef)
  store ptr %v2910, ptr %MEMORY, align 8
  %v2911 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2911, ptr %PC, align 8
  %v2912 = add i64 %v2911, 1
  store i64 %v2912, ptr %NEXT_PC, align 8
  %v2913 = load ptr, ptr %MEMORY, align 8
  %v2914 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2913, ptr %state, ptr undef)
  store ptr %v2914, ptr %MEMORY, align 8
  %v2915 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2915, ptr %PC, align 8
  %v2916 = add i64 %v2915, 1
  store i64 %v2916, ptr %NEXT_PC, align 8
  %v2917 = load ptr, ptr %MEMORY, align 8
  %v2918 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2917, ptr %state, ptr undef)
  store ptr %v2918, ptr %MEMORY, align 8
  %v2919 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2919, ptr %PC, align 8
  %v2920 = add i64 %v2919, 1
  store i64 %v2920, ptr %NEXT_PC, align 8
  %v2921 = load ptr, ptr %MEMORY, align 8
  %v2922 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2921, ptr %state, ptr undef)
  store ptr %v2922, ptr %MEMORY, align 8
  %v2923 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2923, ptr %PC, align 8
  %v2924 = add i64 %v2923, 1
  store i64 %v2924, ptr %NEXT_PC, align 8
  %v2925 = load ptr, ptr %MEMORY, align 8
  %v2926 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2925, ptr %state, ptr undef)
  store ptr %v2926, ptr %MEMORY, align 8
  %v2927 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2927, ptr %PC, align 8
  %v2928 = add i64 %v2927, 1
  store i64 %v2928, ptr %NEXT_PC, align 8
  %v2929 = load ptr, ptr %MEMORY, align 8
  %v2930 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2929, ptr %state, ptr undef)
  store ptr %v2930, ptr %MEMORY, align 8
  %v2931 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2931, ptr %PC, align 8
  %v2932 = add i64 %v2931, 1
  store i64 %v2932, ptr %NEXT_PC, align 8
  %v2933 = load ptr, ptr %MEMORY, align 8
  %v2934 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2933, ptr %state, ptr undef)
  store ptr %v2934, ptr %MEMORY, align 8
  %v2935 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2935, ptr %PC, align 8
  %v2936 = add i64 %v2935, 5
  store i64 %v2936, ptr %NEXT_PC, align 8
  %v2937 = load i64, ptr %RSP, align 8
  %v2938 = add i64 %v2937, 8
  %v2939 = load i64, ptr %RBX, align 8
  %v2940 = load ptr, ptr %MEMORY, align 8
  %v2941 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2940, ptr %state, i64 %v2938, i64 %v2939)
  store ptr %v2941, ptr %MEMORY, align 8
  %v2942 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2942, ptr %PC, align 8
  %v2943 = add i64 %v2942, 5
  store i64 %v2943, ptr %NEXT_PC, align 8
  %v2944 = load i64, ptr %RSP, align 8
  %v2945 = add i64 %v2944, 16
  %v2946 = load i64, ptr %RSI, align 8
  %v2947 = load ptr, ptr %MEMORY, align 8
  %v2948 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2947, ptr %state, i64 %v2945, i64 %v2946)
  store ptr %v2948, ptr %MEMORY, align 8
  %v2949 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2949, ptr %PC, align 8
  %v2950 = add i64 %v2949, 1
  store i64 %v2950, ptr %NEXT_PC, align 8
  %v2951 = load i64, ptr %RDI, align 8
  %v2952 = load ptr, ptr %MEMORY, align 8
  %v2953 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v2952, ptr %state, i64 %v2951)
  store ptr %v2953, ptr %MEMORY, align 8
  %v2954 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2954, ptr %PC, align 8
  %v2955 = add i64 %v2954, 4
  store i64 %v2955, ptr %NEXT_PC, align 8
  %v2956 = load i64, ptr %RSP, align 8
  %v2957 = load ptr, ptr %MEMORY, align 8
  %v2958 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2957, ptr %state, ptr %RSP, i64 %v2956, i64 32)
  store ptr %v2958, ptr %MEMORY, align 8
  %v2959 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2959, ptr %PC, align 8
  %v2960 = add i64 %v2959, 3
  store i64 %v2960, ptr %NEXT_PC, align 8
  %v2961 = load i64, ptr %RDX, align 8
  %v2962 = load ptr, ptr %MEMORY, align 8
  %v2963 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2962, ptr %state, ptr %RSI, i64 %v2961)
  store ptr %v2963, ptr %MEMORY, align 8
  %v2964 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2964, ptr %PC, align 8
  %v2965 = add i64 %v2964, 3
  store i64 %v2965, ptr %NEXT_PC, align 8
  %v2966 = load i64, ptr %RCX, align 8
  %v2967 = load ptr, ptr %MEMORY, align 8
  %v2968 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2967, ptr %state, ptr %RDI, i64 %v2966)
  store ptr %v2968, ptr %MEMORY, align 8
  %v2969 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2969, ptr %PC, align 8
  %v2970 = add i64 %v2969, 2
  store i64 %v2970, ptr %NEXT_PC, align 8
  %v2971 = load i64, ptr %RBX, align 8
  %v2972 = load i32, ptr %EBX, align 4
  %v2973 = zext i32 %v2972 to i64
  %v2974 = load ptr, ptr %MEMORY, align 8
  %v2975 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2974, ptr %state, ptr %RBX, i64 %v2971, i64 %v2973)
  store ptr %v2975, ptr %MEMORY, align 8
  %v2976 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2976, ptr %PC, align 8
  %v2977 = add i64 %v2976, 5
  store i64 %v2977, ptr %NEXT_PC, align 8
  %v2978 = load i64, ptr %NEXT_PC, align 8
  %v2979 = add i64 %v2978, 228
  %v2980 = load i64, ptr %NEXT_PC, align 8
  %v2981 = load ptr, ptr %MEMORY, align 8
  %v2982 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2981, ptr %state, i64 %v2979, ptr %NEXT_PC, i64 %v2980, ptr %RETURN_PC)
  store ptr %v2982, ptr %MEMORY, align 8
  %v2983 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2983, ptr %PC, align 8
  %v2984 = add i64 %v2983, 2
  store i64 %v2984, ptr %NEXT_PC, align 8
  %v2985 = load i32, ptr %EAX, align 4
  %v2986 = zext i32 %v2985 to i64
  %v2987 = load i32, ptr %EAX, align 4
  %v2988 = zext i32 %v2987 to i64
  %v2989 = load ptr, ptr %MEMORY, align 8
  %v2990 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2989, ptr %state, i64 %v2986, i64 %v2988)
  store ptr %v2990, ptr %MEMORY, align 8
  %v2991 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2991, ptr %PC, align 8
  %v2992 = add i64 %v2991, 2
  store i64 %v2992, ptr %NEXT_PC, align 8
  %v2993 = load i64, ptr %NEXT_PC, align 8
  %v2994 = add i64 %v2993, 39
  %v2995 = load i64, ptr %NEXT_PC, align 8
  %v2996 = load ptr, ptr %MEMORY, align 8
  %v2997 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2996, ptr %state, ptr %BRANCH_TAKEN, i64 %v2994, i64 %v2995, ptr %NEXT_PC)
  store ptr %v2997, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659127, label %bb_5395659088

bb_5395659088:                                    ; preds = %bb_5395659113, %bb_5395659030
  %v2998 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2998, ptr %PC, align 8
  %v2999 = add i64 %v2998, 2
  store i64 %v2999, ptr %NEXT_PC, align 8
  %v3000 = load i32, ptr %EBX, align 4
  %v3001 = zext i32 %v3000 to i64
  %v3002 = load ptr, ptr %MEMORY, align 8
  %v3003 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3002, ptr %state, ptr %RDX, i64 %v3001)
  store ptr %v3003, ptr %MEMORY, align 8
  %v3004 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3004, ptr %PC, align 8
  %v3005 = add i64 %v3004, 3
  store i64 %v3005, ptr %NEXT_PC, align 8
  %v3006 = load i64, ptr %RDI, align 8
  %v3007 = load ptr, ptr %MEMORY, align 8
  %v3008 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3007, ptr %state, ptr %RCX, i64 %v3006)
  store ptr %v3008, ptr %MEMORY, align 8
  %v3009 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3009, ptr %PC, align 8
  %v3010 = add i64 %v3009, 5
  store i64 %v3010, ptr %NEXT_PC, align 8
  %v3011 = load i64, ptr %NEXT_PC, align 8
  %v3012 = sub i64 %v3011, 298
  %v3013 = load i64, ptr %NEXT_PC, align 8
  %v3014 = load ptr, ptr %MEMORY, align 8
  %v3015 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3014, ptr %state, i64 %v3012, ptr %NEXT_PC, i64 %v3013, ptr %RETURN_PC)
  store ptr %v3015, ptr %MEMORY, align 8
  %v3016 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3016, ptr %PC, align 8
  %v3017 = add i64 %v3016, 3
  store i64 %v3017, ptr %NEXT_PC, align 8
  %v3018 = load i64, ptr %RSI, align 8
  %v3019 = load ptr, ptr %MEMORY, align 8
  %v3020 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3019, ptr %state, ptr %RDX, i64 %v3018)
  store ptr %v3020, ptr %MEMORY, align 8
  %v3021 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3021, ptr %PC, align 8
  %v3022 = add i64 %v3021, 3
  store i64 %v3022, ptr %NEXT_PC, align 8
  %v3023 = load i64, ptr %RAX, align 8
  %v3024 = load ptr, ptr %MEMORY, align 8
  %v3025 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3024, ptr %state, ptr %RCX, i64 %v3023)
  store ptr %v3025, ptr %MEMORY, align 8
  %v3026 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3026, ptr %PC, align 8
  %v3027 = add i64 %v3026, 5
  store i64 %v3027, ptr %NEXT_PC, align 8
  %v3028 = load i64, ptr %NEXT_PC, align 8
  %v3029 = add i64 %v3028, 45211
  %v3030 = load i64, ptr %NEXT_PC, align 8
  %v3031 = load ptr, ptr %MEMORY, align 8
  %v3032 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3031, ptr %state, i64 %v3029, ptr %NEXT_PC, i64 %v3030, ptr %RETURN_PC)
  store ptr %v3032, ptr %MEMORY, align 8
  %v3033 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3033, ptr %PC, align 8
  %v3034 = add i64 %v3033, 2
  store i64 %v3034, ptr %NEXT_PC, align 8
  %v3035 = load i32, ptr %EAX, align 4
  %v3036 = zext i32 %v3035 to i64
  %v3037 = load i32, ptr %EAX, align 4
  %v3038 = zext i32 %v3037 to i64
  %v3039 = load ptr, ptr %MEMORY, align 8
  %v3040 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3039, ptr %state, i64 %v3036, i64 %v3038)
  store ptr %v3040, ptr %MEMORY, align 8
  %v3041 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3041, ptr %PC, align 8
  %v3042 = add i64 %v3041, 2
  store i64 %v3042, ptr %NEXT_PC, align 8
  %v3043 = load i64, ptr %NEXT_PC, align 8
  %v3044 = add i64 %v3043, 33
  %v3045 = load i64, ptr %NEXT_PC, align 8
  %v3046 = load ptr, ptr %MEMORY, align 8
  %v3047 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3046, ptr %state, ptr %BRANCH_TAKEN, i64 %v3044, i64 %v3045, ptr %NEXT_PC)
  store ptr %v3047, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659146, label %bb_5395659113

bb_5395659113:                                    ; preds = %bb_5395659088
  %v3048 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3048, ptr %PC, align 8
  %v3049 = add i64 %v3048, 3
  store i64 %v3049, ptr %NEXT_PC, align 8
  %v3050 = load i64, ptr %RDI, align 8
  %v3051 = load ptr, ptr %MEMORY, align 8
  %v3052 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3051, ptr %state, ptr %RCX, i64 %v3050)
  store ptr %v3052, ptr %MEMORY, align 8
  %v3053 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3053, ptr %PC, align 8
  %v3054 = add i64 %v3053, 2
  store i64 %v3054, ptr %NEXT_PC, align 8
  %v3055 = load i64, ptr %RBX, align 8
  %v3056 = load ptr, ptr %MEMORY, align 8
  %v3057 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3056, ptr %state, ptr %RBX, i64 %v3055)
  store ptr %v3057, ptr %MEMORY, align 8
  %v3058 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3058, ptr %PC, align 8
  %v3059 = add i64 %v3058, 5
  store i64 %v3059, ptr %NEXT_PC, align 8
  %v3060 = load i64, ptr %NEXT_PC, align 8
  %v3061 = add i64 %v3060, 189
  %v3062 = load i64, ptr %NEXT_PC, align 8
  %v3063 = load ptr, ptr %MEMORY, align 8
  %v3064 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3063, ptr %state, i64 %v3061, ptr %NEXT_PC, i64 %v3062, ptr %RETURN_PC)
  store ptr %v3064, ptr %MEMORY, align 8
  %v3065 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3065, ptr %PC, align 8
  %v3066 = add i64 %v3065, 2
  store i64 %v3066, ptr %NEXT_PC, align 8
  %v3067 = load i32, ptr %EBX, align 4
  %v3068 = zext i32 %v3067 to i64
  %v3069 = load i32, ptr %EAX, align 4
  %v3070 = zext i32 %v3069 to i64
  %v3071 = load ptr, ptr %MEMORY, align 8
  %v3072 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3071, ptr %state, i64 %v3068, i64 %v3070)
  store ptr %v3072, ptr %MEMORY, align 8
  %v3073 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3073, ptr %PC, align 8
  %v3074 = add i64 %v3073, 2
  store i64 %v3074, ptr %NEXT_PC, align 8
  %v3075 = load i64, ptr %NEXT_PC, align 8
  %v3076 = sub i64 %v3075, 39
  %v3077 = load i64, ptr %NEXT_PC, align 8
  %v3078 = load ptr, ptr %MEMORY, align 8
  %v3079 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3078, ptr %state, ptr %BRANCH_TAKEN, i64 %v3076, i64 %v3077, ptr %NEXT_PC)
  store ptr %v3079, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659088, label %bb_5395659127

bb_5395659127:                                    ; preds = %bb_5395659113, %bb_5395659030
  %v3080 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3080, ptr %PC, align 8
  %v3081 = add i64 %v3080, 3
  store i64 %v3081, ptr %NEXT_PC, align 8
  %v3082 = load i64, ptr %RAX, align 8
  %v3083 = load ptr, ptr %MEMORY, align 8
  %v3084 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3083, ptr %state, ptr %RAX, i64 %v3082, i64 -1)
  store ptr %v3084, ptr %MEMORY, align 8
  %v3085 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3085, ptr %PC, align 8
  %v3086 = add i64 %v3085, 5
  store i64 %v3086, ptr %NEXT_PC, align 8
  %v3087 = load i64, ptr %RSP, align 8
  %v3088 = add i64 %v3087, 48
  %v3089 = load ptr, ptr %MEMORY, align 8
  %v3090 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3089, ptr %state, ptr %RBX, i64 %v3088)
  store ptr %v3090, ptr %MEMORY, align 8
  %v3091 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3091, ptr %PC, align 8
  %v3092 = add i64 %v3091, 5
  store i64 %v3092, ptr %NEXT_PC, align 8
  %v3093 = load i64, ptr %RSP, align 8
  %v3094 = add i64 %v3093, 56
  %v3095 = load ptr, ptr %MEMORY, align 8
  %v3096 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3095, ptr %state, ptr %RSI, i64 %v3094)
  store ptr %v3096, ptr %MEMORY, align 8
  %v3097 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3097, ptr %PC, align 8
  %v3098 = add i64 %v3097, 4
  store i64 %v3098, ptr %NEXT_PC, align 8
  %v3099 = load i64, ptr %RSP, align 8
  %v3100 = load ptr, ptr %MEMORY, align 8
  %v3101 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3100, ptr %state, ptr %RSP, i64 %v3099, i64 32)
  store ptr %v3101, ptr %MEMORY, align 8
  %v3102 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3102, ptr %PC, align 8
  %v3103 = add i64 %v3102, 1
  store i64 %v3103, ptr %NEXT_PC, align 8
  %v3104 = load ptr, ptr %MEMORY, align 8
  %v3105 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v3104, ptr %state, ptr %RDI)
  store ptr %v3105, ptr %MEMORY, align 8
  %v3106 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3106, ptr %PC, align 8
  %v3107 = add i64 %v3106, 1
  store i64 %v3107, ptr %NEXT_PC, align 8
  %v3108 = load ptr, ptr %MEMORY, align 8
  %v3109 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v3108, ptr %state, ptr %NEXT_PC)
  store ptr %v3109, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659146:                                    ; preds = %bb_5395659088
  %v3110 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3110, ptr %PC, align 8
  %v3111 = add i64 %v3110, 5
  store i64 %v3111, ptr %NEXT_PC, align 8
  %v3112 = load i64, ptr %RSP, align 8
  %v3113 = add i64 %v3112, 56
  %v3114 = load ptr, ptr %MEMORY, align 8
  %v3115 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3114, ptr %state, ptr %RSI, i64 %v3113)
  store ptr %v3115, ptr %MEMORY, align 8
  %v3116 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3116, ptr %PC, align 8
  %v3117 = add i64 %v3116, 2
  store i64 %v3117, ptr %NEXT_PC, align 8
  %v3118 = load i32, ptr %EBX, align 4
  %v3119 = zext i32 %v3118 to i64
  %v3120 = load ptr, ptr %MEMORY, align 8
  %v3121 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3120, ptr %state, ptr %RAX, i64 %v3119)
  store ptr %v3121, ptr %MEMORY, align 8
  %v3122 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3122, ptr %PC, align 8
  %v3123 = add i64 %v3122, 5
  store i64 %v3123, ptr %NEXT_PC, align 8
  %v3124 = load i64, ptr %RSP, align 8
  %v3125 = add i64 %v3124, 48
  %v3126 = load ptr, ptr %MEMORY, align 8
  %v3127 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3126, ptr %state, ptr %RBX, i64 %v3125)
  store ptr %v3127, ptr %MEMORY, align 8
  %v3128 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3128, ptr %PC, align 8
  %v3129 = add i64 %v3128, 4
  store i64 %v3129, ptr %NEXT_PC, align 8
  %v3130 = load i64, ptr %RSP, align 8
  %v3131 = load ptr, ptr %MEMORY, align 8
  %v3132 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3131, ptr %state, ptr %RSP, i64 %v3130, i64 32)
  store ptr %v3132, ptr %MEMORY, align 8
  %v3133 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3133, ptr %PC, align 8
  %v3134 = add i64 %v3133, 1
  store i64 %v3134, ptr %NEXT_PC, align 8
  %v3135 = load ptr, ptr %MEMORY, align 8
  %v3136 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v3135, ptr %state, ptr %RDI)
  store ptr %v3136, ptr %MEMORY, align 8
  %v3137 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3137, ptr %PC, align 8
  %v3138 = add i64 %v3137, 1
  store i64 %v3138, ptr %NEXT_PC, align 8
  %v3139 = load ptr, ptr %MEMORY, align 8
  %v3140 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v3139, ptr %state, ptr %NEXT_PC)
  store ptr %v3140, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659164:                                    ; No predecessors!
  %v3141 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3141, ptr %PC, align 8
  %v3142 = add i64 %v3141, 1
  store i64 %v3142, ptr %NEXT_PC, align 8
  %v3143 = load ptr, ptr %MEMORY, align 8
  %v3144 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3143, ptr %state, ptr undef)
  store ptr %v3144, ptr %MEMORY, align 8
  %v3145 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3145, ptr %PC, align 8
  %v3146 = add i64 %v3145, 1
  store i64 %v3146, ptr %NEXT_PC, align 8
  %v3147 = load ptr, ptr %MEMORY, align 8
  %v3148 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3147, ptr %state, ptr undef)
  store ptr %v3148, ptr %MEMORY, align 8
  %v3149 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3149, ptr %PC, align 8
  %v3150 = add i64 %v3149, 1
  store i64 %v3150, ptr %NEXT_PC, align 8
  %v3151 = load ptr, ptr %MEMORY, align 8
  %v3152 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3151, ptr %state, ptr undef)
  store ptr %v3152, ptr %MEMORY, align 8
  %v3153 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3153, ptr %PC, align 8
  %v3154 = add i64 %v3153, 1
  store i64 %v3154, ptr %NEXT_PC, align 8
  %v3155 = load ptr, ptr %MEMORY, align 8
  %v3156 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3155, ptr %state, ptr undef)
  store ptr %v3156, ptr %MEMORY, align 8
  %v3157 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3157, ptr %PC, align 8
  %v3158 = add i64 %v3157, 1
  store i64 %v3158, ptr %NEXT_PC, align 8
  %v3159 = load ptr, ptr %MEMORY, align 8
  %v3160 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3159, ptr %state, ptr undef)
  store ptr %v3160, ptr %MEMORY, align 8
  %v3161 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3161, ptr %PC, align 8
  %v3162 = add i64 %v3161, 1
  store i64 %v3162, ptr %NEXT_PC, align 8
  %v3163 = load ptr, ptr %MEMORY, align 8
  %v3164 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3163, ptr %state, ptr undef)
  store ptr %v3164, ptr %MEMORY, align 8
  %v3165 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3165, ptr %PC, align 8
  %v3166 = add i64 %v3165, 1
  store i64 %v3166, ptr %NEXT_PC, align 8
  %v3167 = load ptr, ptr %MEMORY, align 8
  %v3168 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3167, ptr %state, ptr undef)
  store ptr %v3168, ptr %MEMORY, align 8
  %v3169 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3169, ptr %PC, align 8
  %v3170 = add i64 %v3169, 1
  store i64 %v3170, ptr %NEXT_PC, align 8
  %v3171 = load ptr, ptr %MEMORY, align 8
  %v3172 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3171, ptr %state, ptr undef)
  store ptr %v3172, ptr %MEMORY, align 8
  %v3173 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3173, ptr %PC, align 8
  %v3174 = add i64 %v3173, 1
  store i64 %v3174, ptr %NEXT_PC, align 8
  %v3175 = load ptr, ptr %MEMORY, align 8
  %v3176 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3175, ptr %state, ptr undef)
  store ptr %v3176, ptr %MEMORY, align 8
  %v3177 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3177, ptr %PC, align 8
  %v3178 = add i64 %v3177, 1
  store i64 %v3178, ptr %NEXT_PC, align 8
  %v3179 = load ptr, ptr %MEMORY, align 8
  %v3180 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3179, ptr %state, ptr undef)
  store ptr %v3180, ptr %MEMORY, align 8
  %v3181 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3181, ptr %PC, align 8
  %v3182 = add i64 %v3181, 1
  store i64 %v3182, ptr %NEXT_PC, align 8
  %v3183 = load ptr, ptr %MEMORY, align 8
  %v3184 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3183, ptr %state, ptr undef)
  store ptr %v3184, ptr %MEMORY, align 8
  %v3185 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3185, ptr %PC, align 8
  %v3186 = add i64 %v3185, 1
  store i64 %v3186, ptr %NEXT_PC, align 8
  %v3187 = load ptr, ptr %MEMORY, align 8
  %v3188 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3187, ptr %state, ptr undef)
  store ptr %v3188, ptr %MEMORY, align 8
  %v3189 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3189, ptr %PC, align 8
  %v3190 = add i64 %v3189, 1
  store i64 %v3190, ptr %NEXT_PC, align 8
  %v3191 = load ptr, ptr %MEMORY, align 8
  %v3192 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3191, ptr %state, ptr undef)
  store ptr %v3192, ptr %MEMORY, align 8
  %v3193 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3193, ptr %PC, align 8
  %v3194 = add i64 %v3193, 1
  store i64 %v3194, ptr %NEXT_PC, align 8
  %v3195 = load ptr, ptr %MEMORY, align 8
  %v3196 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3195, ptr %state, ptr undef)
  store ptr %v3196, ptr %MEMORY, align 8
  %v3197 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3197, ptr %PC, align 8
  %v3198 = add i64 %v3197, 1
  store i64 %v3198, ptr %NEXT_PC, align 8
  %v3199 = load ptr, ptr %MEMORY, align 8
  %v3200 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3199, ptr %state, ptr undef)
  store ptr %v3200, ptr %MEMORY, align 8
  %v3201 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3201, ptr %PC, align 8
  %v3202 = add i64 %v3201, 1
  store i64 %v3202, ptr %NEXT_PC, align 8
  %v3203 = load ptr, ptr %MEMORY, align 8
  %v3204 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3203, ptr %state, ptr undef)
  store ptr %v3204, ptr %MEMORY, align 8
  %v3205 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3205, ptr %PC, align 8
  %v3206 = add i64 %v3205, 1
  store i64 %v3206, ptr %NEXT_PC, align 8
  %v3207 = load ptr, ptr %MEMORY, align 8
  %v3208 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3207, ptr %state, ptr undef)
  store ptr %v3208, ptr %MEMORY, align 8
  %v3209 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3209, ptr %PC, align 8
  %v3210 = add i64 %v3209, 1
  store i64 %v3210, ptr %NEXT_PC, align 8
  %v3211 = load ptr, ptr %MEMORY, align 8
  %v3212 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3211, ptr %state, ptr undef)
  store ptr %v3212, ptr %MEMORY, align 8
  %v3213 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3213, ptr %PC, align 8
  %v3214 = add i64 %v3213, 1
  store i64 %v3214, ptr %NEXT_PC, align 8
  %v3215 = load ptr, ptr %MEMORY, align 8
  %v3216 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3215, ptr %state, ptr undef)
  store ptr %v3216, ptr %MEMORY, align 8
  %v3217 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3217, ptr %PC, align 8
  %v3218 = add i64 %v3217, 1
  store i64 %v3218, ptr %NEXT_PC, align 8
  %v3219 = load ptr, ptr %MEMORY, align 8
  %v3220 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3219, ptr %state, ptr undef)
  store ptr %v3220, ptr %MEMORY, align 8
  %v3221 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3221, ptr %PC, align 8
  %v3222 = add i64 %v3221, 5
  store i64 %v3222, ptr %NEXT_PC, align 8
  %v3223 = load i64, ptr %RSP, align 8
  %v3224 = add i64 %v3223, 8
  %v3225 = load i64, ptr %RBX, align 8
  %v3226 = load ptr, ptr %MEMORY, align 8
  %v3227 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3226, ptr %state, i64 %v3224, i64 %v3225)
  store ptr %v3227, ptr %MEMORY, align 8
  %v3228 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3228, ptr %PC, align 8
  %v3229 = add i64 %v3228, 5
  store i64 %v3229, ptr %NEXT_PC, align 8
  %v3230 = load i64, ptr %RSP, align 8
  %v3231 = add i64 %v3230, 16
  %v3232 = load i64, ptr %RSI, align 8
  %v3233 = load ptr, ptr %MEMORY, align 8
  %v3234 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3233, ptr %state, i64 %v3231, i64 %v3232)
  store ptr %v3234, ptr %MEMORY, align 8
  %v3235 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3235, ptr %PC, align 8
  %v3236 = add i64 %v3235, 1
  store i64 %v3236, ptr %NEXT_PC, align 8
  %v3237 = load i64, ptr %RDI, align 8
  %v3238 = load ptr, ptr %MEMORY, align 8
  %v3239 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v3238, ptr %state, i64 %v3237)
  store ptr %v3239, ptr %MEMORY, align 8
  %v3240 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3240, ptr %PC, align 8
  %v3241 = add i64 %v3240, 4
  store i64 %v3241, ptr %NEXT_PC, align 8
  %v3242 = load i64, ptr %RSP, align 8
  %v3243 = load ptr, ptr %MEMORY, align 8
  %v3244 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3243, ptr %state, ptr %RSP, i64 %v3242, i64 32)
  store ptr %v3244, ptr %MEMORY, align 8
  %v3245 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3245, ptr %PC, align 8
  %v3246 = add i64 %v3245, 3
  store i64 %v3246, ptr %NEXT_PC, align 8
  %v3247 = load i64, ptr %RDX, align 8
  %v3248 = load ptr, ptr %MEMORY, align 8
  %v3249 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3248, ptr %state, ptr %RSI, i64 %v3247)
  store ptr %v3249, ptr %MEMORY, align 8
  %v3250 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3250, ptr %PC, align 8
  %v3251 = add i64 %v3250, 3
  store i64 %v3251, ptr %NEXT_PC, align 8
  %v3252 = load i64, ptr %RCX, align 8
  %v3253 = load ptr, ptr %MEMORY, align 8
  %v3254 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3253, ptr %state, ptr %RDI, i64 %v3252)
  store ptr %v3254, ptr %MEMORY, align 8
  %v3255 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3255, ptr %PC, align 8
  %v3256 = add i64 %v3255, 2
  store i64 %v3256, ptr %NEXT_PC, align 8
  %v3257 = load i64, ptr %RBX, align 8
  %v3258 = load i32, ptr %EBX, align 4
  %v3259 = zext i32 %v3258 to i64
  %v3260 = load ptr, ptr %MEMORY, align 8
  %v3261 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3260, ptr %state, ptr %RBX, i64 %v3257, i64 %v3259)
  store ptr %v3261, ptr %MEMORY, align 8
  %v3262 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3262, ptr %PC, align 8
  %v3263 = add i64 %v3262, 5
  store i64 %v3263, ptr %NEXT_PC, align 8
  %v3264 = load i64, ptr %NEXT_PC, align 8
  %v3265 = add i64 %v3264, 100
  %v3266 = load i64, ptr %NEXT_PC, align 8
  %v3267 = load ptr, ptr %MEMORY, align 8
  %v3268 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3267, ptr %state, i64 %v3265, ptr %NEXT_PC, i64 %v3266, ptr %RETURN_PC)
  store ptr %v3268, ptr %MEMORY, align 8
  %v3269 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3269, ptr %PC, align 8
  %v3270 = add i64 %v3269, 2
  store i64 %v3270, ptr %NEXT_PC, align 8
  %v3271 = load i32, ptr %EAX, align 4
  %v3272 = zext i32 %v3271 to i64
  %v3273 = load i32, ptr %EAX, align 4
  %v3274 = zext i32 %v3273 to i64
  %v3275 = load ptr, ptr %MEMORY, align 8
  %v3276 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3275, ptr %state, i64 %v3272, i64 %v3274)
  store ptr %v3276, ptr %MEMORY, align 8
  %v3277 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3277, ptr %PC, align 8
  %v3278 = add i64 %v3277, 2
  store i64 %v3278, ptr %NEXT_PC, align 8
  %v3279 = load i64, ptr %NEXT_PC, align 8
  %v3280 = add i64 %v3279, 39
  %v3281 = load i64, ptr %NEXT_PC, align 8
  %v3282 = load ptr, ptr %MEMORY, align 8
  %v3283 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3282, ptr %state, ptr %BRANCH_TAKEN, i64 %v3280, i64 %v3281, ptr %NEXT_PC)
  store ptr %v3283, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659255, label %bb_5395659216

bb_5395659216:                                    ; preds = %bb_5395659241, %bb_5395659164
  %v3284 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3284, ptr %PC, align 8
  %v3285 = add i64 %v3284, 2
  store i64 %v3285, ptr %NEXT_PC, align 8
  %v3286 = load i32, ptr %EBX, align 4
  %v3287 = zext i32 %v3286 to i64
  %v3288 = load ptr, ptr %MEMORY, align 8
  %v3289 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3288, ptr %state, ptr %RDX, i64 %v3287)
  store ptr %v3289, ptr %MEMORY, align 8
  %v3290 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3290, ptr %PC, align 8
  %v3291 = add i64 %v3290, 3
  store i64 %v3291, ptr %NEXT_PC, align 8
  %v3292 = load i64, ptr %RDI, align 8
  %v3293 = load ptr, ptr %MEMORY, align 8
  %v3294 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3293, ptr %state, ptr %RCX, i64 %v3292)
  store ptr %v3294, ptr %MEMORY, align 8
  %v3295 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3295, ptr %PC, align 8
  %v3296 = add i64 %v3295, 5
  store i64 %v3296, ptr %NEXT_PC, align 8
  %v3297 = load i64, ptr %NEXT_PC, align 8
  %v3298 = sub i64 %v3297, 426
  %v3299 = load i64, ptr %NEXT_PC, align 8
  %v3300 = load ptr, ptr %MEMORY, align 8
  %v3301 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3300, ptr %state, i64 %v3298, ptr %NEXT_PC, i64 %v3299, ptr %RETURN_PC)
  store ptr %v3301, ptr %MEMORY, align 8
  %v3302 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3302, ptr %PC, align 8
  %v3303 = add i64 %v3302, 3
  store i64 %v3303, ptr %NEXT_PC, align 8
  %v3304 = load i64, ptr %RSI, align 8
  %v3305 = load ptr, ptr %MEMORY, align 8
  %v3306 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3305, ptr %state, ptr %RDX, i64 %v3304)
  store ptr %v3306, ptr %MEMORY, align 8
  %v3307 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3307, ptr %PC, align 8
  %v3308 = add i64 %v3307, 3
  store i64 %v3308, ptr %NEXT_PC, align 8
  %v3309 = load i64, ptr %RAX, align 8
  %v3310 = load ptr, ptr %MEMORY, align 8
  %v3311 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3310, ptr %state, ptr %RCX, i64 %v3309)
  store ptr %v3311, ptr %MEMORY, align 8
  %v3312 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3312, ptr %PC, align 8
  %v3313 = add i64 %v3312, 5
  store i64 %v3313, ptr %NEXT_PC, align 8
  %v3314 = load i64, ptr %NEXT_PC, align 8
  %v3315 = add i64 %v3314, 45147
  %v3316 = load i64, ptr %NEXT_PC, align 8
  %v3317 = load ptr, ptr %MEMORY, align 8
  %v3318 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3317, ptr %state, i64 %v3315, ptr %NEXT_PC, i64 %v3316, ptr %RETURN_PC)
  store ptr %v3318, ptr %MEMORY, align 8
  %v3319 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3319, ptr %PC, align 8
  %v3320 = add i64 %v3319, 2
  store i64 %v3320, ptr %NEXT_PC, align 8
  %v3321 = load i32, ptr %EAX, align 4
  %v3322 = zext i32 %v3321 to i64
  %v3323 = load i32, ptr %EAX, align 4
  %v3324 = zext i32 %v3323 to i64
  %v3325 = load ptr, ptr %MEMORY, align 8
  %v3326 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3325, ptr %state, i64 %v3322, i64 %v3324)
  store ptr %v3326, ptr %MEMORY, align 8
  %v3327 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3327, ptr %PC, align 8
  %v3328 = add i64 %v3327, 2
  store i64 %v3328, ptr %NEXT_PC, align 8
  %v3329 = load i64, ptr %NEXT_PC, align 8
  %v3330 = add i64 %v3329, 33
  %v3331 = load i64, ptr %NEXT_PC, align 8
  %v3332 = load ptr, ptr %MEMORY, align 8
  %v3333 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3332, ptr %state, ptr %BRANCH_TAKEN, i64 %v3330, i64 %v3331, ptr %NEXT_PC)
  store ptr %v3333, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659274, label %bb_5395659241

bb_5395659241:                                    ; preds = %bb_5395659216
  %v3334 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3334, ptr %PC, align 8
  %v3335 = add i64 %v3334, 3
  store i64 %v3335, ptr %NEXT_PC, align 8
  %v3336 = load i64, ptr %RDI, align 8
  %v3337 = load ptr, ptr %MEMORY, align 8
  %v3338 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3337, ptr %state, ptr %RCX, i64 %v3336)
  store ptr %v3338, ptr %MEMORY, align 8
  %v3339 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3339, ptr %PC, align 8
  %v3340 = add i64 %v3339, 2
  store i64 %v3340, ptr %NEXT_PC, align 8
  %v3341 = load i64, ptr %RBX, align 8
  %v3342 = load ptr, ptr %MEMORY, align 8
  %v3343 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3342, ptr %state, ptr %RBX, i64 %v3341)
  store ptr %v3343, ptr %MEMORY, align 8
  %v3344 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3344, ptr %PC, align 8
  %v3345 = add i64 %v3344, 5
  store i64 %v3345, ptr %NEXT_PC, align 8
  %v3346 = load i64, ptr %NEXT_PC, align 8
  %v3347 = add i64 %v3346, 61
  %v3348 = load i64, ptr %NEXT_PC, align 8
  %v3349 = load ptr, ptr %MEMORY, align 8
  %v3350 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3349, ptr %state, i64 %v3347, ptr %NEXT_PC, i64 %v3348, ptr %RETURN_PC)
  store ptr %v3350, ptr %MEMORY, align 8
  %v3351 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3351, ptr %PC, align 8
  %v3352 = add i64 %v3351, 2
  store i64 %v3352, ptr %NEXT_PC, align 8
  %v3353 = load i32, ptr %EBX, align 4
  %v3354 = zext i32 %v3353 to i64
  %v3355 = load i32, ptr %EAX, align 4
  %v3356 = zext i32 %v3355 to i64
  %v3357 = load ptr, ptr %MEMORY, align 8
  %v3358 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3357, ptr %state, i64 %v3354, i64 %v3356)
  store ptr %v3358, ptr %MEMORY, align 8
  %v3359 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3359, ptr %PC, align 8
  %v3360 = add i64 %v3359, 2
  store i64 %v3360, ptr %NEXT_PC, align 8
  %v3361 = load i64, ptr %NEXT_PC, align 8
  %v3362 = sub i64 %v3361, 39
  %v3363 = load i64, ptr %NEXT_PC, align 8
  %v3364 = load ptr, ptr %MEMORY, align 8
  %v3365 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3364, ptr %state, ptr %BRANCH_TAKEN, i64 %v3362, i64 %v3363, ptr %NEXT_PC)
  store ptr %v3365, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659216, label %bb_5395659255

bb_5395659255:                                    ; preds = %bb_5395659241, %bb_5395659164
  %v3366 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3366, ptr %PC, align 8
  %v3367 = add i64 %v3366, 3
  store i64 %v3367, ptr %NEXT_PC, align 8
  %v3368 = load i64, ptr %RAX, align 8
  %v3369 = load ptr, ptr %MEMORY, align 8
  %v3370 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3369, ptr %state, ptr %RAX, i64 %v3368, i64 -1)
  store ptr %v3370, ptr %MEMORY, align 8
  %v3371 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3371, ptr %PC, align 8
  %v3372 = add i64 %v3371, 5
  store i64 %v3372, ptr %NEXT_PC, align 8
  %v3373 = load i64, ptr %RSP, align 8
  %v3374 = add i64 %v3373, 48
  %v3375 = load ptr, ptr %MEMORY, align 8
  %v3376 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3375, ptr %state, ptr %RBX, i64 %v3374)
  store ptr %v3376, ptr %MEMORY, align 8
  %v3377 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3377, ptr %PC, align 8
  %v3378 = add i64 %v3377, 5
  store i64 %v3378, ptr %NEXT_PC, align 8
  %v3379 = load i64, ptr %RSP, align 8
  %v3380 = add i64 %v3379, 56
  %v3381 = load ptr, ptr %MEMORY, align 8
  %v3382 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3381, ptr %state, ptr %RSI, i64 %v3380)
  store ptr %v3382, ptr %MEMORY, align 8
  %v3383 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3383, ptr %PC, align 8
  %v3384 = add i64 %v3383, 4
  store i64 %v3384, ptr %NEXT_PC, align 8
  %v3385 = load i64, ptr %RSP, align 8
  %v3386 = load ptr, ptr %MEMORY, align 8
  %v3387 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3386, ptr %state, ptr %RSP, i64 %v3385, i64 32)
  store ptr %v3387, ptr %MEMORY, align 8
  %v3388 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3388, ptr %PC, align 8
  %v3389 = add i64 %v3388, 1
  store i64 %v3389, ptr %NEXT_PC, align 8
  %v3390 = load ptr, ptr %MEMORY, align 8
  %v3391 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v3390, ptr %state, ptr %RDI)
  store ptr %v3391, ptr %MEMORY, align 8
  %v3392 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3392, ptr %PC, align 8
  %v3393 = add i64 %v3392, 1
  store i64 %v3393, ptr %NEXT_PC, align 8
  %v3394 = load ptr, ptr %MEMORY, align 8
  %v3395 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v3394, ptr %state, ptr %NEXT_PC)
  store ptr %v3395, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659274:                                    ; preds = %bb_5395659216
  %v3396 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3396, ptr %PC, align 8
  %v3397 = add i64 %v3396, 5
  store i64 %v3397, ptr %NEXT_PC, align 8
  %v3398 = load i64, ptr %RSP, align 8
  %v3399 = add i64 %v3398, 56
  %v3400 = load ptr, ptr %MEMORY, align 8
  %v3401 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3400, ptr %state, ptr %RSI, i64 %v3399)
  store ptr %v3401, ptr %MEMORY, align 8
  %v3402 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3402, ptr %PC, align 8
  %v3403 = add i64 %v3402, 2
  store i64 %v3403, ptr %NEXT_PC, align 8
  %v3404 = load i32, ptr %EBX, align 4
  %v3405 = zext i32 %v3404 to i64
  %v3406 = load ptr, ptr %MEMORY, align 8
  %v3407 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3406, ptr %state, ptr %RAX, i64 %v3405)
  store ptr %v3407, ptr %MEMORY, align 8
  %v3408 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3408, ptr %PC, align 8
  %v3409 = add i64 %v3408, 5
  store i64 %v3409, ptr %NEXT_PC, align 8
  %v3410 = load i64, ptr %RSP, align 8
  %v3411 = add i64 %v3410, 48
  %v3412 = load ptr, ptr %MEMORY, align 8
  %v3413 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3412, ptr %state, ptr %RBX, i64 %v3411)
  store ptr %v3413, ptr %MEMORY, align 8
  %v3414 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3414, ptr %PC, align 8
  %v3415 = add i64 %v3414, 4
  store i64 %v3415, ptr %NEXT_PC, align 8
  %v3416 = load i64, ptr %RSP, align 8
  %v3417 = load ptr, ptr %MEMORY, align 8
  %v3418 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3417, ptr %state, ptr %RSP, i64 %v3416, i64 32)
  store ptr %v3418, ptr %MEMORY, align 8
  %v3419 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3419, ptr %PC, align 8
  %v3420 = add i64 %v3419, 1
  store i64 %v3420, ptr %NEXT_PC, align 8
  %v3421 = load ptr, ptr %MEMORY, align 8
  %v3422 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v3421, ptr %state, ptr %RDI)
  store ptr %v3422, ptr %MEMORY, align 8
  %v3423 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3423, ptr %PC, align 8
  %v3424 = add i64 %v3423, 1
  store i64 %v3424, ptr %NEXT_PC, align 8
  %v3425 = load ptr, ptr %MEMORY, align 8
  %v3426 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v3425, ptr %state, ptr %NEXT_PC)
  store ptr %v3426, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659292:                                    ; No predecessors!
  %v3427 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3427, ptr %PC, align 8
  %v3428 = add i64 %v3427, 1
  store i64 %v3428, ptr %NEXT_PC, align 8
  %v3429 = load ptr, ptr %MEMORY, align 8
  %v3430 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3429, ptr %state, ptr undef)
  store ptr %v3430, ptr %MEMORY, align 8
  %v3431 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3431, ptr %PC, align 8
  %v3432 = add i64 %v3431, 1
  store i64 %v3432, ptr %NEXT_PC, align 8
  %v3433 = load ptr, ptr %MEMORY, align 8
  %v3434 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3433, ptr %state, ptr undef)
  store ptr %v3434, ptr %MEMORY, align 8
  %v3435 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3435, ptr %PC, align 8
  %v3436 = add i64 %v3435, 1
  store i64 %v3436, ptr %NEXT_PC, align 8
  %v3437 = load ptr, ptr %MEMORY, align 8
  %v3438 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3437, ptr %state, ptr undef)
  store ptr %v3438, ptr %MEMORY, align 8
  %v3439 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3439, ptr %PC, align 8
  %v3440 = add i64 %v3439, 1
  store i64 %v3440, ptr %NEXT_PC, align 8
  %v3441 = load ptr, ptr %MEMORY, align 8
  %v3442 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3441, ptr %state, ptr undef)
  store ptr %v3442, ptr %MEMORY, align 8
  %v3443 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3443, ptr %PC, align 8
  %v3444 = add i64 %v3443, 1
  store i64 %v3444, ptr %NEXT_PC, align 8
  %v3445 = load ptr, ptr %MEMORY, align 8
  %v3446 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3445, ptr %state, ptr undef)
  store ptr %v3446, ptr %MEMORY, align 8
  %v3447 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3447, ptr %PC, align 8
  %v3448 = add i64 %v3447, 1
  store i64 %v3448, ptr %NEXT_PC, align 8
  %v3449 = load ptr, ptr %MEMORY, align 8
  %v3450 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3449, ptr %state, ptr undef)
  store ptr %v3450, ptr %MEMORY, align 8
  %v3451 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3451, ptr %PC, align 8
  %v3452 = add i64 %v3451, 1
  store i64 %v3452, ptr %NEXT_PC, align 8
  %v3453 = load ptr, ptr %MEMORY, align 8
  %v3454 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3453, ptr %state, ptr undef)
  store ptr %v3454, ptr %MEMORY, align 8
  %v3455 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3455, ptr %PC, align 8
  %v3456 = add i64 %v3455, 1
  store i64 %v3456, ptr %NEXT_PC, align 8
  %v3457 = load ptr, ptr %MEMORY, align 8
  %v3458 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3457, ptr %state, ptr undef)
  store ptr %v3458, ptr %MEMORY, align 8
  %v3459 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3459, ptr %PC, align 8
  %v3460 = add i64 %v3459, 1
  store i64 %v3460, ptr %NEXT_PC, align 8
  %v3461 = load ptr, ptr %MEMORY, align 8
  %v3462 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3461, ptr %state, ptr undef)
  store ptr %v3462, ptr %MEMORY, align 8
  %v3463 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3463, ptr %PC, align 8
  %v3464 = add i64 %v3463, 1
  store i64 %v3464, ptr %NEXT_PC, align 8
  %v3465 = load ptr, ptr %MEMORY, align 8
  %v3466 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3465, ptr %state, ptr undef)
  store ptr %v3466, ptr %MEMORY, align 8
  %v3467 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3467, ptr %PC, align 8
  %v3468 = add i64 %v3467, 1
  store i64 %v3468, ptr %NEXT_PC, align 8
  %v3469 = load ptr, ptr %MEMORY, align 8
  %v3470 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3469, ptr %state, ptr undef)
  store ptr %v3470, ptr %MEMORY, align 8
  %v3471 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3471, ptr %PC, align 8
  %v3472 = add i64 %v3471, 1
  store i64 %v3472, ptr %NEXT_PC, align 8
  %v3473 = load ptr, ptr %MEMORY, align 8
  %v3474 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3473, ptr %state, ptr undef)
  store ptr %v3474, ptr %MEMORY, align 8
  %v3475 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3475, ptr %PC, align 8
  %v3476 = add i64 %v3475, 1
  store i64 %v3476, ptr %NEXT_PC, align 8
  %v3477 = load ptr, ptr %MEMORY, align 8
  %v3478 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3477, ptr %state, ptr undef)
  store ptr %v3478, ptr %MEMORY, align 8
  %v3479 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3479, ptr %PC, align 8
  %v3480 = add i64 %v3479, 1
  store i64 %v3480, ptr %NEXT_PC, align 8
  %v3481 = load ptr, ptr %MEMORY, align 8
  %v3482 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3481, ptr %state, ptr undef)
  store ptr %v3482, ptr %MEMORY, align 8
  %v3483 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3483, ptr %PC, align 8
  %v3484 = add i64 %v3483, 1
  store i64 %v3484, ptr %NEXT_PC, align 8
  %v3485 = load ptr, ptr %MEMORY, align 8
  %v3486 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3485, ptr %state, ptr undef)
  store ptr %v3486, ptr %MEMORY, align 8
  %v3487 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3487, ptr %PC, align 8
  %v3488 = add i64 %v3487, 1
  store i64 %v3488, ptr %NEXT_PC, align 8
  %v3489 = load ptr, ptr %MEMORY, align 8
  %v3490 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3489, ptr %state, ptr undef)
  store ptr %v3490, ptr %MEMORY, align 8
  %v3491 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3491, ptr %PC, align 8
  %v3492 = add i64 %v3491, 1
  store i64 %v3492, ptr %NEXT_PC, align 8
  %v3493 = load ptr, ptr %MEMORY, align 8
  %v3494 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3493, ptr %state, ptr undef)
  store ptr %v3494, ptr %MEMORY, align 8
  %v3495 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3495, ptr %PC, align 8
  %v3496 = add i64 %v3495, 1
  store i64 %v3496, ptr %NEXT_PC, align 8
  %v3497 = load ptr, ptr %MEMORY, align 8
  %v3498 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3497, ptr %state, ptr undef)
  store ptr %v3498, ptr %MEMORY, align 8
  %v3499 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3499, ptr %PC, align 8
  %v3500 = add i64 %v3499, 1
  store i64 %v3500, ptr %NEXT_PC, align 8
  %v3501 = load ptr, ptr %MEMORY, align 8
  %v3502 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3501, ptr %state, ptr undef)
  store ptr %v3502, ptr %MEMORY, align 8
  %v3503 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3503, ptr %PC, align 8
  %v3504 = add i64 %v3503, 1
  store i64 %v3504, ptr %NEXT_PC, align 8
  %v3505 = load ptr, ptr %MEMORY, align 8
  %v3506 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3505, ptr %state, ptr undef)
  store ptr %v3506, ptr %MEMORY, align 8
  %v3507 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3507, ptr %PC, align 8
  %v3508 = add i64 %v3507, 4
  store i64 %v3508, ptr %NEXT_PC, align 8
  %v3509 = load i64, ptr %RCX, align 8
  %v3510 = add i64 %v3509, 8
  %v3511 = load ptr, ptr %MEMORY, align 8
  %v3512 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3511, ptr %state, ptr %RDX, i64 %v3510)
  store ptr %v3512, ptr %MEMORY, align 8
  %v3513 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3513, ptr %PC, align 8
  %v3514 = add i64 %v3513, 3
  store i64 %v3514, ptr %NEXT_PC, align 8
  %v3515 = load i64, ptr %RCX, align 8
  %v3516 = add i64 %v3515, 48
  %v3517 = load ptr, ptr %MEMORY, align 8
  %v3518 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3517, ptr %state, ptr %RAX, i64 %v3516)
  store ptr %v3518, ptr %MEMORY, align 8
  %v3519 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3519, ptr %PC, align 8
  %v3520 = add i64 %v3519, 3
  store i64 %v3520, ptr %NEXT_PC, align 8
  %v3521 = load i64, ptr %RDX, align 8
  %v3522 = load i64, ptr %RDX, align 8
  %v3523 = load ptr, ptr %MEMORY, align 8
  %v3524 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3523, ptr %state, i64 %v3521, i64 %v3522)
  store ptr %v3524, ptr %MEMORY, align 8
  %v3525 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3525, ptr %PC, align 8
  %v3526 = add i64 %v3525, 2
  store i64 %v3526, ptr %NEXT_PC, align 8
  %v3527 = load i64, ptr %NEXT_PC, align 8
  %v3528 = add i64 %v3527, 16
  %v3529 = load i64, ptr %NEXT_PC, align 8
  %v3530 = load ptr, ptr %MEMORY, align 8
  %v3531 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3530, ptr %state, ptr %BRANCH_TAKEN, i64 %v3528, i64 %v3529, ptr %NEXT_PC)
  store ptr %v3531, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659340, label %bb_5395659324

bb_5395659324:                                    ; preds = %bb_5395659292
  %v3532 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3532, ptr %PC, align 8
  %v3533 = add i64 %v3532, 4
  store i64 %v3533, ptr %NEXT_PC, align 8
  %v3534 = load i64, ptr %RAX, align 8
  %v3535 = load ptr, ptr %MEMORY, align 8
  %v3536 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnIjEEEEP6MemoryS4_R5StateDpT_(ptr %v3535, ptr %state, i64 %v3534)
  store ptr %v3536, ptr %MEMORY, align 8
  br label %bb_5395659328

bb_5395659328:                                    ; preds = %bb_5395659328, %bb_5395659324
  %v3537 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3537, ptr %PC, align 8
  %v3538 = add i64 %v3537, 3
  store i64 %v3538, ptr %NEXT_PC, align 8
  %v3539 = load i64, ptr %RAX, align 8
  %v3540 = load i64, ptr %RDX, align 8
  %v3541 = add i64 %v3540, 48
  %v3542 = load ptr, ptr %MEMORY, align 8
  %v3543 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3542, ptr %state, ptr %RAX, i64 %v3539, i64 %v3541)
  store ptr %v3543, ptr %MEMORY, align 8
  %v3544 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3544, ptr %PC, align 8
  %v3545 = add i64 %v3544, 4
  store i64 %v3545, ptr %NEXT_PC, align 8
  %v3546 = load i64, ptr %RDX, align 8
  %v3547 = add i64 %v3546, 8
  %v3548 = load ptr, ptr %MEMORY, align 8
  %v3549 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3548, ptr %state, ptr %RDX, i64 %v3547)
  store ptr %v3549, ptr %MEMORY, align 8
  %v3550 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3550, ptr %PC, align 8
  %v3551 = add i64 %v3550, 3
  store i64 %v3551, ptr %NEXT_PC, align 8
  %v3552 = load i64, ptr %RDX, align 8
  %v3553 = load i64, ptr %RDX, align 8
  %v3554 = load ptr, ptr %MEMORY, align 8
  %v3555 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3554, ptr %state, i64 %v3552, i64 %v3553)
  store ptr %v3555, ptr %MEMORY, align 8
  %v3556 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3556, ptr %PC, align 8
  %v3557 = add i64 %v3556, 2
  store i64 %v3557, ptr %NEXT_PC, align 8
  %v3558 = load i64, ptr %NEXT_PC, align 8
  %v3559 = sub i64 %v3558, 12
  %v3560 = load i64, ptr %NEXT_PC, align 8
  %v3561 = load ptr, ptr %MEMORY, align 8
  %v3562 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3561, ptr %state, ptr %BRANCH_TAKEN, i64 %v3559, i64 %v3560, ptr %NEXT_PC)
  store ptr %v3562, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659328, label %bb_5395659340

bb_5395659340:                                    ; preds = %bb_5395659328, %bb_5395659292
  %v3563 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3563, ptr %PC, align 8
  %v3564 = add i64 %v3563, 1
  store i64 %v3564, ptr %NEXT_PC, align 8
  %v3565 = load ptr, ptr %MEMORY, align 8
  %v3566 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v3565, ptr %state, ptr %NEXT_PC)
  store ptr %v3566, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659341:                                    ; No predecessors!
  %v3567 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3567, ptr %PC, align 8
  %v3568 = add i64 %v3567, 1
  store i64 %v3568, ptr %NEXT_PC, align 8
  %v3569 = load ptr, ptr %MEMORY, align 8
  %v3570 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3569, ptr %state, ptr undef)
  store ptr %v3570, ptr %MEMORY, align 8
  %v3571 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3571, ptr %PC, align 8
  %v3572 = add i64 %v3571, 1
  store i64 %v3572, ptr %NEXT_PC, align 8
  %v3573 = load ptr, ptr %MEMORY, align 8
  %v3574 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3573, ptr %state, ptr undef)
  store ptr %v3574, ptr %MEMORY, align 8
  %v3575 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3575, ptr %PC, align 8
  %v3576 = add i64 %v3575, 1
  store i64 %v3576, ptr %NEXT_PC, align 8
  %v3577 = load ptr, ptr %MEMORY, align 8
  %v3578 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3577, ptr %state, ptr undef)
  store ptr %v3578, ptr %MEMORY, align 8
  %v3579 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3579, ptr %PC, align 8
  %v3580 = add i64 %v3579, 1
  store i64 %v3580, ptr %NEXT_PC, align 8
  %v3581 = load ptr, ptr %MEMORY, align 8
  %v3582 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3581, ptr %state, ptr undef)
  store ptr %v3582, ptr %MEMORY, align 8
  %v3583 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3583, ptr %PC, align 8
  %v3584 = add i64 %v3583, 1
  store i64 %v3584, ptr %NEXT_PC, align 8
  %v3585 = load ptr, ptr %MEMORY, align 8
  %v3586 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3585, ptr %state, ptr undef)
  store ptr %v3586, ptr %MEMORY, align 8
  %v3587 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3587, ptr %PC, align 8
  %v3588 = add i64 %v3587, 1
  store i64 %v3588, ptr %NEXT_PC, align 8
  %v3589 = load ptr, ptr %MEMORY, align 8
  %v3590 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3589, ptr %state, ptr undef)
  store ptr %v3590, ptr %MEMORY, align 8
  %v3591 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3591, ptr %PC, align 8
  %v3592 = add i64 %v3591, 1
  store i64 %v3592, ptr %NEXT_PC, align 8
  %v3593 = load ptr, ptr %MEMORY, align 8
  %v3594 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3593, ptr %state, ptr undef)
  store ptr %v3594, ptr %MEMORY, align 8
  %v3595 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3595, ptr %PC, align 8
  %v3596 = add i64 %v3595, 1
  store i64 %v3596, ptr %NEXT_PC, align 8
  %v3597 = load ptr, ptr %MEMORY, align 8
  %v3598 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3597, ptr %state, ptr undef)
  store ptr %v3598, ptr %MEMORY, align 8
  %v3599 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3599, ptr %PC, align 8
  %v3600 = add i64 %v3599, 1
  store i64 %v3600, ptr %NEXT_PC, align 8
  %v3601 = load ptr, ptr %MEMORY, align 8
  %v3602 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3601, ptr %state, ptr undef)
  store ptr %v3602, ptr %MEMORY, align 8
  %v3603 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3603, ptr %PC, align 8
  %v3604 = add i64 %v3603, 1
  store i64 %v3604, ptr %NEXT_PC, align 8
  %v3605 = load ptr, ptr %MEMORY, align 8
  %v3606 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3605, ptr %state, ptr undef)
  store ptr %v3606, ptr %MEMORY, align 8
  %v3607 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3607, ptr %PC, align 8
  %v3608 = add i64 %v3607, 1
  store i64 %v3608, ptr %NEXT_PC, align 8
  %v3609 = load ptr, ptr %MEMORY, align 8
  %v3610 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3609, ptr %state, ptr undef)
  store ptr %v3610, ptr %MEMORY, align 8
  %v3611 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3611, ptr %PC, align 8
  %v3612 = add i64 %v3611, 1
  store i64 %v3612, ptr %NEXT_PC, align 8
  %v3613 = load ptr, ptr %MEMORY, align 8
  %v3614 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3613, ptr %state, ptr undef)
  store ptr %v3614, ptr %MEMORY, align 8
  %v3615 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3615, ptr %PC, align 8
  %v3616 = add i64 %v3615, 1
  store i64 %v3616, ptr %NEXT_PC, align 8
  %v3617 = load ptr, ptr %MEMORY, align 8
  %v3618 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3617, ptr %state, ptr undef)
  store ptr %v3618, ptr %MEMORY, align 8
  %v3619 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3619, ptr %PC, align 8
  %v3620 = add i64 %v3619, 1
  store i64 %v3620, ptr %NEXT_PC, align 8
  %v3621 = load ptr, ptr %MEMORY, align 8
  %v3622 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3621, ptr %state, ptr undef)
  store ptr %v3622, ptr %MEMORY, align 8
  %v3623 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3623, ptr %PC, align 8
  %v3624 = add i64 %v3623, 1
  store i64 %v3624, ptr %NEXT_PC, align 8
  %v3625 = load ptr, ptr %MEMORY, align 8
  %v3626 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3625, ptr %state, ptr undef)
  store ptr %v3626, ptr %MEMORY, align 8
  %v3627 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3627, ptr %PC, align 8
  %v3628 = add i64 %v3627, 1
  store i64 %v3628, ptr %NEXT_PC, align 8
  %v3629 = load ptr, ptr %MEMORY, align 8
  %v3630 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3629, ptr %state, ptr undef)
  store ptr %v3630, ptr %MEMORY, align 8
  %v3631 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3631, ptr %PC, align 8
  %v3632 = add i64 %v3631, 1
  store i64 %v3632, ptr %NEXT_PC, align 8
  %v3633 = load ptr, ptr %MEMORY, align 8
  %v3634 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3633, ptr %state, ptr undef)
  store ptr %v3634, ptr %MEMORY, align 8
  %v3635 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3635, ptr %PC, align 8
  %v3636 = add i64 %v3635, 1
  store i64 %v3636, ptr %NEXT_PC, align 8
  %v3637 = load ptr, ptr %MEMORY, align 8
  %v3638 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3637, ptr %state, ptr undef)
  store ptr %v3638, ptr %MEMORY, align 8
  %v3639 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3639, ptr %PC, align 8
  %v3640 = add i64 %v3639, 1
  store i64 %v3640, ptr %NEXT_PC, align 8
  %v3641 = load ptr, ptr %MEMORY, align 8
  %v3642 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3641, ptr %state, ptr undef)
  store ptr %v3642, ptr %MEMORY, align 8
  %v3643 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3643, ptr %PC, align 8
  %v3644 = add i64 %v3643, 3
  store i64 %v3644, ptr %NEXT_PC, align 8
  %v3645 = load i32, ptr %EDX, align 4
  %v3646 = zext i32 %v3645 to i64
  %v3647 = load ptr, ptr %MEMORY, align 8
  %v3648 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v3647, ptr %state, ptr %RAX, i64 %v3646)
  store ptr %v3648, ptr %MEMORY, align 8
  %v3649 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3649, ptr %PC, align 8
  %v3650 = add i64 %v3649, 4
  store i64 %v3650, ptr %NEXT_PC, align 8
  %v3651 = load i64, ptr %RAX, align 8
  %v3652 = load i64, ptr %RAX, align 8
  %v3653 = mul i64 %v3652, 4
  %v3654 = add i64 %v3651, %v3653
  %v3655 = load ptr, ptr %MEMORY, align 8
  %v3656 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v3655, ptr %state, ptr %RDX, i64 %v3654)
  store ptr %v3656, ptr %MEMORY, align 8
  %v3657 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3657, ptr %PC, align 8
  %v3658 = add i64 %v3657, 4
  store i64 %v3658, ptr %NEXT_PC, align 8
  %v3659 = load i64, ptr %RCX, align 8
  %v3660 = add i64 %v3659, 40
  %v3661 = load ptr, ptr %MEMORY, align 8
  %v3662 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3661, ptr %state, ptr %RAX, i64 %v3660)
  store ptr %v3662, ptr %MEMORY, align 8
  %v3663 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3663, ptr %PC, align 8
  %v3664 = add i64 %v3663, 4
  store i64 %v3664, ptr %NEXT_PC, align 8
  %v3665 = load i64, ptr %RAX, align 8
  %v3666 = load i64, ptr %RDX, align 8
  %v3667 = mul i64 %v3666, 8
  %v3668 = add i64 %v3665, %v3667
  %v3669 = load ptr, ptr %MEMORY, align 8
  %v3670 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v3669, ptr %state, ptr %RAX, i64 %v3668)
  store ptr %v3670, ptr %MEMORY, align 8
  %v3671 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3671, ptr %PC, align 8
  %v3672 = add i64 %v3671, 1
  store i64 %v3672, ptr %NEXT_PC, align 8
  %v3673 = load ptr, ptr %MEMORY, align 8
  %v3674 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v3673, ptr %state, ptr %NEXT_PC)
  store ptr %v3674, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659376:                                    ; No predecessors!
  %v3675 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3675, ptr %PC, align 8
  %v3676 = add i64 %v3675, 1
  store i64 %v3676, ptr %NEXT_PC, align 8
  %v3677 = load ptr, ptr %MEMORY, align 8
  %v3678 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3677, ptr %state, ptr undef)
  store ptr %v3678, ptr %MEMORY, align 8
  %v3679 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3679, ptr %PC, align 8
  %v3680 = add i64 %v3679, 1
  store i64 %v3680, ptr %NEXT_PC, align 8
  %v3681 = load ptr, ptr %MEMORY, align 8
  %v3682 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3681, ptr %state, ptr undef)
  store ptr %v3682, ptr %MEMORY, align 8
  %v3683 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3683, ptr %PC, align 8
  %v3684 = add i64 %v3683, 1
  store i64 %v3684, ptr %NEXT_PC, align 8
  %v3685 = load ptr, ptr %MEMORY, align 8
  %v3686 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3685, ptr %state, ptr undef)
  store ptr %v3686, ptr %MEMORY, align 8
  %v3687 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3687, ptr %PC, align 8
  %v3688 = add i64 %v3687, 1
  store i64 %v3688, ptr %NEXT_PC, align 8
  %v3689 = load ptr, ptr %MEMORY, align 8
  %v3690 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3689, ptr %state, ptr undef)
  store ptr %v3690, ptr %MEMORY, align 8
  %v3691 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3691, ptr %PC, align 8
  %v3692 = add i64 %v3691, 1
  store i64 %v3692, ptr %NEXT_PC, align 8
  %v3693 = load ptr, ptr %MEMORY, align 8
  %v3694 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3693, ptr %state, ptr undef)
  store ptr %v3694, ptr %MEMORY, align 8
  %v3695 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3695, ptr %PC, align 8
  %v3696 = add i64 %v3695, 1
  store i64 %v3696, ptr %NEXT_PC, align 8
  %v3697 = load ptr, ptr %MEMORY, align 8
  %v3698 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3697, ptr %state, ptr undef)
  store ptr %v3698, ptr %MEMORY, align 8
  %v3699 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3699, ptr %PC, align 8
  %v3700 = add i64 %v3699, 1
  store i64 %v3700, ptr %NEXT_PC, align 8
  %v3701 = load ptr, ptr %MEMORY, align 8
  %v3702 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3701, ptr %state, ptr undef)
  store ptr %v3702, ptr %MEMORY, align 8
  %v3703 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3703, ptr %PC, align 8
  %v3704 = add i64 %v3703, 1
  store i64 %v3704, ptr %NEXT_PC, align 8
  %v3705 = load ptr, ptr %MEMORY, align 8
  %v3706 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3705, ptr %state, ptr undef)
  store ptr %v3706, ptr %MEMORY, align 8
  %v3707 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3707, ptr %PC, align 8
  %v3708 = add i64 %v3707, 1
  store i64 %v3708, ptr %NEXT_PC, align 8
  %v3709 = load ptr, ptr %MEMORY, align 8
  %v3710 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3709, ptr %state, ptr undef)
  store ptr %v3710, ptr %MEMORY, align 8
  %v3711 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3711, ptr %PC, align 8
  %v3712 = add i64 %v3711, 1
  store i64 %v3712, ptr %NEXT_PC, align 8
  %v3713 = load ptr, ptr %MEMORY, align 8
  %v3714 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3713, ptr %state, ptr undef)
  store ptr %v3714, ptr %MEMORY, align 8
  %v3715 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3715, ptr %PC, align 8
  %v3716 = add i64 %v3715, 1
  store i64 %v3716, ptr %NEXT_PC, align 8
  %v3717 = load ptr, ptr %MEMORY, align 8
  %v3718 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3717, ptr %state, ptr undef)
  store ptr %v3718, ptr %MEMORY, align 8
  %v3719 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3719, ptr %PC, align 8
  %v3720 = add i64 %v3719, 1
  store i64 %v3720, ptr %NEXT_PC, align 8
  %v3721 = load ptr, ptr %MEMORY, align 8
  %v3722 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3721, ptr %state, ptr undef)
  store ptr %v3722, ptr %MEMORY, align 8
  %v3723 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3723, ptr %PC, align 8
  %v3724 = add i64 %v3723, 1
  store i64 %v3724, ptr %NEXT_PC, align 8
  %v3725 = load ptr, ptr %MEMORY, align 8
  %v3726 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3725, ptr %state, ptr undef)
  store ptr %v3726, ptr %MEMORY, align 8
  %v3727 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3727, ptr %PC, align 8
  %v3728 = add i64 %v3727, 1
  store i64 %v3728, ptr %NEXT_PC, align 8
  %v3729 = load ptr, ptr %MEMORY, align 8
  %v3730 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3729, ptr %state, ptr undef)
  store ptr %v3730, ptr %MEMORY, align 8
  %v3731 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3731, ptr %PC, align 8
  %v3732 = add i64 %v3731, 1
  store i64 %v3732, ptr %NEXT_PC, align 8
  %v3733 = load ptr, ptr %MEMORY, align 8
  %v3734 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3733, ptr %state, ptr undef)
  store ptr %v3734, ptr %MEMORY, align 8
  %v3735 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3735, ptr %PC, align 8
  %v3736 = add i64 %v3735, 1
  store i64 %v3736, ptr %NEXT_PC, align 8
  %v3737 = load ptr, ptr %MEMORY, align 8
  %v3738 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3737, ptr %state, ptr undef)
  store ptr %v3738, ptr %MEMORY, align 8
  %v3739 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3739, ptr %PC, align 8
  %v3740 = add i64 %v3739, 5
  store i64 %v3740, ptr %NEXT_PC, align 8
  %v3741 = load i64, ptr %RSP, align 8
  %v3742 = add i64 %v3741, 8
  %v3743 = load i64, ptr %RBX, align 8
  %v3744 = load ptr, ptr %MEMORY, align 8
  %v3745 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3744, ptr %state, i64 %v3742, i64 %v3743)
  store ptr %v3745, ptr %MEMORY, align 8
  %v3746 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3746, ptr %PC, align 8
  %v3747 = add i64 %v3746, 5
  store i64 %v3747, ptr %NEXT_PC, align 8
  %v3748 = load i64, ptr %RSP, align 8
  %v3749 = add i64 %v3748, 16
  %v3750 = load i64, ptr %RBP, align 8
  %v3751 = load ptr, ptr %MEMORY, align 8
  %v3752 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3751, ptr %state, i64 %v3749, i64 %v3750)
  store ptr %v3752, ptr %MEMORY, align 8
  %v3753 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3753, ptr %PC, align 8
  %v3754 = add i64 %v3753, 5
  store i64 %v3754, ptr %NEXT_PC, align 8
  %v3755 = load i64, ptr %RSP, align 8
  %v3756 = add i64 %v3755, 24
  %v3757 = load i64, ptr %RSI, align 8
  %v3758 = load ptr, ptr %MEMORY, align 8
  %v3759 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3758, ptr %state, i64 %v3756, i64 %v3757)
  store ptr %v3759, ptr %MEMORY, align 8
  %v3760 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3760, ptr %PC, align 8
  %v3761 = add i64 %v3760, 1
  store i64 %v3761, ptr %NEXT_PC, align 8
  %v3762 = load i64, ptr %RDI, align 8
  %v3763 = load ptr, ptr %MEMORY, align 8
  %v3764 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v3763, ptr %state, i64 %v3762)
  store ptr %v3764, ptr %MEMORY, align 8
  %v3765 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3765, ptr %PC, align 8
  %v3766 = add i64 %v3765, 4
  store i64 %v3766, ptr %NEXT_PC, align 8
  %v3767 = load i64, ptr %RSP, align 8
  %v3768 = load ptr, ptr %MEMORY, align 8
  %v3769 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3768, ptr %state, ptr %RSP, i64 %v3767, i64 32)
  store ptr %v3769, ptr %MEMORY, align 8
  %v3770 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3770, ptr %PC, align 8
  %v3771 = add i64 %v3770, 3
  store i64 %v3771, ptr %NEXT_PC, align 8
  %v3772 = load i64, ptr %RDX, align 8
  %v3773 = load ptr, ptr %MEMORY, align 8
  %v3774 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3773, ptr %state, ptr %RBP, i64 %v3772)
  store ptr %v3774, ptr %MEMORY, align 8
  %v3775 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3775, ptr %PC, align 8
  %v3776 = add i64 %v3775, 3
  store i64 %v3776, ptr %NEXT_PC, align 8
  %v3777 = load i64, ptr %RCX, align 8
  %v3778 = load ptr, ptr %MEMORY, align 8
  %v3779 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3778, ptr %state, ptr %RDI, i64 %v3777)
  store ptr %v3779, ptr %MEMORY, align 8
  %v3780 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3780, ptr %PC, align 8
  %v3781 = add i64 %v3780, 2
  store i64 %v3781, ptr %NEXT_PC, align 8
  %v3782 = load i64, ptr %RBX, align 8
  %v3783 = load i32, ptr %EBX, align 4
  %v3784 = zext i32 %v3783 to i64
  %v3785 = load ptr, ptr %MEMORY, align 8
  %v3786 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3785, ptr %state, ptr %RBX, i64 %v3782, i64 %v3784)
  store ptr %v3786, ptr %MEMORY, align 8
  %v3787 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3787, ptr %PC, align 8
  %v3788 = add i64 %v3787, 5
  store i64 %v3788, ptr %NEXT_PC, align 8
  %v3789 = load i64, ptr %NEXT_PC, align 8
  %v3790 = add i64 %v3789, 223
  %v3791 = load i64, ptr %NEXT_PC, align 8
  %v3792 = load ptr, ptr %MEMORY, align 8
  %v3793 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3792, ptr %state, i64 %v3790, ptr %NEXT_PC, i64 %v3791, ptr %RETURN_PC)
  store ptr %v3793, ptr %MEMORY, align 8
  %v3794 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3794, ptr %PC, align 8
  %v3795 = add i64 %v3794, 2
  store i64 %v3795, ptr %NEXT_PC, align 8
  %v3796 = load i32, ptr %EAX, align 4
  %v3797 = zext i32 %v3796 to i64
  %v3798 = load i32, ptr %EAX, align 4
  %v3799 = zext i32 %v3798 to i64
  %v3800 = load ptr, ptr %MEMORY, align 8
  %v3801 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3800, ptr %state, i64 %v3797, i64 %v3799)
  store ptr %v3801, ptr %MEMORY, align 8
  %v3802 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3802, ptr %PC, align 8
  %v3803 = add i64 %v3802, 2
  store i64 %v3803, ptr %NEXT_PC, align 8
  %v3804 = load i64, ptr %NEXT_PC, align 8
  %v3805 = add i64 %v3804, 42
  %v3806 = load i64, ptr %NEXT_PC, align 8
  %v3807 = load ptr, ptr %MEMORY, align 8
  %v3808 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3807, ptr %state, ptr %BRANCH_TAKEN, i64 %v3805, i64 %v3806, ptr %NEXT_PC)
  store ptr %v3808, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659471, label %bb_5395659429

bb_5395659429:                                    ; preds = %bb_5395659457, %bb_5395659376
  %v3809 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3809, ptr %PC, align 8
  %v3810 = add i64 %v3809, 2
  store i64 %v3810, ptr %NEXT_PC, align 8
  %v3811 = load i32, ptr %EBX, align 4
  %v3812 = zext i32 %v3811 to i64
  %v3813 = load ptr, ptr %MEMORY, align 8
  %v3814 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3813, ptr %state, ptr %RDX, i64 %v3812)
  store ptr %v3814, ptr %MEMORY, align 8
  %v3815 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3815, ptr %PC, align 8
  %v3816 = add i64 %v3815, 3
  store i64 %v3816, ptr %NEXT_PC, align 8
  %v3817 = load i64, ptr %RDI, align 8
  %v3818 = load ptr, ptr %MEMORY, align 8
  %v3819 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3818, ptr %state, ptr %RCX, i64 %v3817)
  store ptr %v3819, ptr %MEMORY, align 8
  %v3820 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3820, ptr %PC, align 8
  %v3821 = add i64 %v3820, 5
  store i64 %v3821, ptr %NEXT_PC, align 8
  %v3822 = load i64, ptr %NEXT_PC, align 8
  %v3823 = sub i64 %v3822, 79
  %v3824 = load i64, ptr %NEXT_PC, align 8
  %v3825 = load ptr, ptr %MEMORY, align 8
  %v3826 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3825, ptr %state, i64 %v3823, ptr %NEXT_PC, i64 %v3824, ptr %RETURN_PC)
  store ptr %v3826, ptr %MEMORY, align 8
  %v3827 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3827, ptr %PC, align 8
  %v3828 = add i64 %v3827, 3
  store i64 %v3828, ptr %NEXT_PC, align 8
  %v3829 = load i64, ptr %RBP, align 8
  %v3830 = load ptr, ptr %MEMORY, align 8
  %v3831 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3830, ptr %state, ptr %RDX, i64 %v3829)
  store ptr %v3831, ptr %MEMORY, align 8
  %v3832 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3832, ptr %PC, align 8
  %v3833 = add i64 %v3832, 3
  store i64 %v3833, ptr %NEXT_PC, align 8
  %v3834 = load i64, ptr %RAX, align 8
  %v3835 = load ptr, ptr %MEMORY, align 8
  %v3836 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3835, ptr %state, ptr %RSI, i64 %v3834)
  store ptr %v3836, ptr %MEMORY, align 8
  %v3837 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3837, ptr %PC, align 8
  %v3838 = add i64 %v3837, 3
  store i64 %v3838, ptr %NEXT_PC, align 8
  %v3839 = load i64, ptr %RAX, align 8
  %v3840 = load ptr, ptr %MEMORY, align 8
  %v3841 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3840, ptr %state, ptr %RCX, i64 %v3839)
  store ptr %v3841, ptr %MEMORY, align 8
  %v3842 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3842, ptr %PC, align 8
  %v3843 = add i64 %v3842, 5
  store i64 %v3843, ptr %NEXT_PC, align 8
  %v3844 = load i64, ptr %NEXT_PC, align 8
  %v3845 = add i64 %v3844, 44867
  %v3846 = load i64, ptr %NEXT_PC, align 8
  %v3847 = load ptr, ptr %MEMORY, align 8
  %v3848 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3847, ptr %state, i64 %v3845, ptr %NEXT_PC, i64 %v3846, ptr %RETURN_PC)
  store ptr %v3848, ptr %MEMORY, align 8
  %v3849 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3849, ptr %PC, align 8
  %v3850 = add i64 %v3849, 2
  store i64 %v3850, ptr %NEXT_PC, align 8
  %v3851 = load i32, ptr %EAX, align 4
  %v3852 = zext i32 %v3851 to i64
  %v3853 = load i32, ptr %EAX, align 4
  %v3854 = zext i32 %v3853 to i64
  %v3855 = load ptr, ptr %MEMORY, align 8
  %v3856 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3855, ptr %state, i64 %v3852, i64 %v3854)
  store ptr %v3856, ptr %MEMORY, align 8
  %v3857 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3857, ptr %PC, align 8
  %v3858 = add i64 %v3857, 2
  store i64 %v3858, ptr %NEXT_PC, align 8
  %v3859 = load i64, ptr %NEXT_PC, align 8
  %v3860 = add i64 %v3859, 37
  %v3861 = load i64, ptr %NEXT_PC, align 8
  %v3862 = load ptr, ptr %MEMORY, align 8
  %v3863 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3862, ptr %state, ptr %BRANCH_TAKEN, i64 %v3860, i64 %v3861, ptr %NEXT_PC)
  store ptr %v3863, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659494, label %bb_5395659457

bb_5395659457:                                    ; preds = %bb_5395659429
  %v3864 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3864, ptr %PC, align 8
  %v3865 = add i64 %v3864, 3
  store i64 %v3865, ptr %NEXT_PC, align 8
  %v3866 = load i64, ptr %RDI, align 8
  %v3867 = load ptr, ptr %MEMORY, align 8
  %v3868 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3867, ptr %state, ptr %RCX, i64 %v3866)
  store ptr %v3868, ptr %MEMORY, align 8
  %v3869 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3869, ptr %PC, align 8
  %v3870 = add i64 %v3869, 2
  store i64 %v3870, ptr %NEXT_PC, align 8
  %v3871 = load i64, ptr %RBX, align 8
  %v3872 = load ptr, ptr %MEMORY, align 8
  %v3873 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3872, ptr %state, ptr %RBX, i64 %v3871)
  store ptr %v3873, ptr %MEMORY, align 8
  %v3874 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3874, ptr %PC, align 8
  %v3875 = add i64 %v3874, 5
  store i64 %v3875, ptr %NEXT_PC, align 8
  %v3876 = load i64, ptr %NEXT_PC, align 8
  %v3877 = add i64 %v3876, 181
  %v3878 = load i64, ptr %NEXT_PC, align 8
  %v3879 = load ptr, ptr %MEMORY, align 8
  %v3880 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3879, ptr %state, i64 %v3877, ptr %NEXT_PC, i64 %v3878, ptr %RETURN_PC)
  store ptr %v3880, ptr %MEMORY, align 8
  %v3881 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3881, ptr %PC, align 8
  %v3882 = add i64 %v3881, 2
  store i64 %v3882, ptr %NEXT_PC, align 8
  %v3883 = load i32, ptr %EBX, align 4
  %v3884 = zext i32 %v3883 to i64
  %v3885 = load i32, ptr %EAX, align 4
  %v3886 = zext i32 %v3885 to i64
  %v3887 = load ptr, ptr %MEMORY, align 8
  %v3888 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3887, ptr %state, i64 %v3884, i64 %v3886)
  store ptr %v3888, ptr %MEMORY, align 8
  %v3889 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3889, ptr %PC, align 8
  %v3890 = add i64 %v3889, 2
  store i64 %v3890, ptr %NEXT_PC, align 8
  %v3891 = load i64, ptr %NEXT_PC, align 8
  %v3892 = sub i64 %v3891, 42
  %v3893 = load i64, ptr %NEXT_PC, align 8
  %v3894 = load ptr, ptr %MEMORY, align 8
  %v3895 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3894, ptr %state, ptr %BRANCH_TAKEN, i64 %v3892, i64 %v3893, ptr %NEXT_PC)
  store ptr %v3895, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659429, label %bb_5395659471

bb_5395659471:                                    ; preds = %bb_5395659457, %bb_5395659376
  %v3896 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3896, ptr %PC, align 8
  %v3897 = add i64 %v3896, 2
  store i64 %v3897, ptr %NEXT_PC, align 8
  %v3898 = load i64, ptr %RAX, align 8
  %v3899 = load i32, ptr %EAX, align 4
  %v3900 = zext i32 %v3899 to i64
  %v3901 = load ptr, ptr %MEMORY, align 8
  %v3902 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3901, ptr %state, ptr %RAX, i64 %v3898, i64 %v3900)
  store ptr %v3902, ptr %MEMORY, align 8
  br label %bb_5395659473

bb_5395659473:                                    ; preds = %bb_5395659494, %bb_5395659471
  %v3903 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3903, ptr %PC, align 8
  %v3904 = add i64 %v3903, 5
  store i64 %v3904, ptr %NEXT_PC, align 8
  %v3905 = load i64, ptr %RSP, align 8
  %v3906 = add i64 %v3905, 48
  %v3907 = load ptr, ptr %MEMORY, align 8
  %v3908 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3907, ptr %state, ptr %RBX, i64 %v3906)
  store ptr %v3908, ptr %MEMORY, align 8
  %v3909 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3909, ptr %PC, align 8
  %v3910 = add i64 %v3909, 5
  store i64 %v3910, ptr %NEXT_PC, align 8
  %v3911 = load i64, ptr %RSP, align 8
  %v3912 = add i64 %v3911, 56
  %v3913 = load ptr, ptr %MEMORY, align 8
  %v3914 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3913, ptr %state, ptr %RBP, i64 %v3912)
  store ptr %v3914, ptr %MEMORY, align 8
  %v3915 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3915, ptr %PC, align 8
  %v3916 = add i64 %v3915, 5
  store i64 %v3916, ptr %NEXT_PC, align 8
  %v3917 = load i64, ptr %RSP, align 8
  %v3918 = add i64 %v3917, 64
  %v3919 = load ptr, ptr %MEMORY, align 8
  %v3920 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3919, ptr %state, ptr %RSI, i64 %v3918)
  store ptr %v3920, ptr %MEMORY, align 8
  %v3921 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3921, ptr %PC, align 8
  %v3922 = add i64 %v3921, 4
  store i64 %v3922, ptr %NEXT_PC, align 8
  %v3923 = load i64, ptr %RSP, align 8
  %v3924 = load ptr, ptr %MEMORY, align 8
  %v3925 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3924, ptr %state, ptr %RSP, i64 %v3923, i64 32)
  store ptr %v3925, ptr %MEMORY, align 8
  %v3926 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3926, ptr %PC, align 8
  %v3927 = add i64 %v3926, 1
  store i64 %v3927, ptr %NEXT_PC, align 8
  %v3928 = load ptr, ptr %MEMORY, align 8
  %v3929 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v3928, ptr %state, ptr %RDI)
  store ptr %v3929, ptr %MEMORY, align 8
  %v3930 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3930, ptr %PC, align 8
  %v3931 = add i64 %v3930, 1
  store i64 %v3931, ptr %NEXT_PC, align 8
  %v3932 = load ptr, ptr %MEMORY, align 8
  %v3933 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v3932, ptr %state, ptr %NEXT_PC)
  store ptr %v3933, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659494:                                    ; preds = %bb_5395659429
  %v3934 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3934, ptr %PC, align 8
  %v3935 = add i64 %v3934, 3
  store i64 %v3935, ptr %NEXT_PC, align 8
  %v3936 = load i64, ptr %RSI, align 8
  %v3937 = load ptr, ptr %MEMORY, align 8
  %v3938 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3937, ptr %state, ptr %RAX, i64 %v3936)
  store ptr %v3938, ptr %MEMORY, align 8
  %v3939 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3939, ptr %PC, align 8
  %v3940 = add i64 %v3939, 2
  store i64 %v3940, ptr %NEXT_PC, align 8
  %v3941 = load i64, ptr %NEXT_PC, align 8
  %v3942 = sub i64 %v3941, 26
  %v3943 = load ptr, ptr %MEMORY, align 8
  %v3944 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v3943, ptr %state, i64 %v3942, ptr %NEXT_PC)
  store ptr %v3944, ptr %MEMORY, align 8
  br label %bb_5395659473
  %v3945 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3945, ptr %PC, align 8
  %v3946 = add i64 %v3945, 1
  store i64 %v3946, ptr %NEXT_PC, align 8
  %v3947 = load ptr, ptr %MEMORY, align 8
  %v3948 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3947, ptr %state, ptr undef)
  store ptr %v3948, ptr %MEMORY, align 8
  %v3949 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3949, ptr %PC, align 8
  %v3950 = add i64 %v3949, 1
  store i64 %v3950, ptr %NEXT_PC, align 8
  %v3951 = load ptr, ptr %MEMORY, align 8
  %v3952 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3951, ptr %state, ptr undef)
  store ptr %v3952, ptr %MEMORY, align 8
  %v3953 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3953, ptr %PC, align 8
  %v3954 = add i64 %v3953, 1
  store i64 %v3954, ptr %NEXT_PC, align 8
  %v3955 = load ptr, ptr %MEMORY, align 8
  %v3956 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3955, ptr %state, ptr undef)
  store ptr %v3956, ptr %MEMORY, align 8
  %v3957 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3957, ptr %PC, align 8
  %v3958 = add i64 %v3957, 1
  store i64 %v3958, ptr %NEXT_PC, align 8
  %v3959 = load ptr, ptr %MEMORY, align 8
  %v3960 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3959, ptr %state, ptr undef)
  store ptr %v3960, ptr %MEMORY, align 8
  %v3961 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3961, ptr %PC, align 8
  %v3962 = add i64 %v3961, 1
  store i64 %v3962, ptr %NEXT_PC, align 8
  %v3963 = load ptr, ptr %MEMORY, align 8
  %v3964 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3963, ptr %state, ptr undef)
  store ptr %v3964, ptr %MEMORY, align 8
  %v3965 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3965, ptr %PC, align 8
  %v3966 = add i64 %v3965, 1
  store i64 %v3966, ptr %NEXT_PC, align 8
  %v3967 = load ptr, ptr %MEMORY, align 8
  %v3968 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3967, ptr %state, ptr undef)
  store ptr %v3968, ptr %MEMORY, align 8
  %v3969 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3969, ptr %PC, align 8
  %v3970 = add i64 %v3969, 1
  store i64 %v3970, ptr %NEXT_PC, align 8
  %v3971 = load ptr, ptr %MEMORY, align 8
  %v3972 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3971, ptr %state, ptr undef)
  store ptr %v3972, ptr %MEMORY, align 8
  %v3973 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3973, ptr %PC, align 8
  %v3974 = add i64 %v3973, 1
  store i64 %v3974, ptr %NEXT_PC, align 8
  %v3975 = load ptr, ptr %MEMORY, align 8
  %v3976 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3975, ptr %state, ptr undef)
  store ptr %v3976, ptr %MEMORY, align 8
  %v3977 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3977, ptr %PC, align 8
  %v3978 = add i64 %v3977, 1
  store i64 %v3978, ptr %NEXT_PC, align 8
  %v3979 = load ptr, ptr %MEMORY, align 8
  %v3980 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3979, ptr %state, ptr undef)
  store ptr %v3980, ptr %MEMORY, align 8
  %v3981 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3981, ptr %PC, align 8
  %v3982 = add i64 %v3981, 1
  store i64 %v3982, ptr %NEXT_PC, align 8
  %v3983 = load ptr, ptr %MEMORY, align 8
  %v3984 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3983, ptr %state, ptr undef)
  store ptr %v3984, ptr %MEMORY, align 8
  %v3985 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3985, ptr %PC, align 8
  %v3986 = add i64 %v3985, 1
  store i64 %v3986, ptr %NEXT_PC, align 8
  %v3987 = load ptr, ptr %MEMORY, align 8
  %v3988 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3987, ptr %state, ptr undef)
  store ptr %v3988, ptr %MEMORY, align 8
  %v3989 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3989, ptr %PC, align 8
  %v3990 = add i64 %v3989, 1
  store i64 %v3990, ptr %NEXT_PC, align 8
  %v3991 = load ptr, ptr %MEMORY, align 8
  %v3992 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3991, ptr %state, ptr undef)
  store ptr %v3992, ptr %MEMORY, align 8
  %v3993 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3993, ptr %PC, align 8
  %v3994 = add i64 %v3993, 1
  store i64 %v3994, ptr %NEXT_PC, align 8
  %v3995 = load ptr, ptr %MEMORY, align 8
  %v3996 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3995, ptr %state, ptr undef)
  store ptr %v3996, ptr %MEMORY, align 8
  %v3997 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3997, ptr %PC, align 8
  %v3998 = add i64 %v3997, 1
  store i64 %v3998, ptr %NEXT_PC, align 8
  %v3999 = load ptr, ptr %MEMORY, align 8
  %v4000 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3999, ptr %state, ptr undef)
  store ptr %v4000, ptr %MEMORY, align 8
  %v4001 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4001, ptr %PC, align 8
  %v4002 = add i64 %v4001, 1
  store i64 %v4002, ptr %NEXT_PC, align 8
  %v4003 = load ptr, ptr %MEMORY, align 8
  %v4004 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4003, ptr %state, ptr undef)
  store ptr %v4004, ptr %MEMORY, align 8
  %v4005 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4005, ptr %PC, align 8
  %v4006 = add i64 %v4005, 1
  store i64 %v4006, ptr %NEXT_PC, align 8
  %v4007 = load ptr, ptr %MEMORY, align 8
  %v4008 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4007, ptr %state, ptr undef)
  store ptr %v4008, ptr %MEMORY, align 8
  %v4009 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4009, ptr %PC, align 8
  %v4010 = add i64 %v4009, 1
  store i64 %v4010, ptr %NEXT_PC, align 8
  %v4011 = load ptr, ptr %MEMORY, align 8
  %v4012 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4011, ptr %state, ptr undef)
  store ptr %v4012, ptr %MEMORY, align 8
  %v4013 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4013, ptr %PC, align 8
  %v4014 = add i64 %v4013, 1
  store i64 %v4014, ptr %NEXT_PC, align 8
  %v4015 = load ptr, ptr %MEMORY, align 8
  %v4016 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4015, ptr %state, ptr undef)
  store ptr %v4016, ptr %MEMORY, align 8
  %v4017 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4017, ptr %PC, align 8
  %v4018 = add i64 %v4017, 1
  store i64 %v4018, ptr %NEXT_PC, align 8
  %v4019 = load ptr, ptr %MEMORY, align 8
  %v4020 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4019, ptr %state, ptr undef)
  store ptr %v4020, ptr %MEMORY, align 8
  %v4021 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4021, ptr %PC, align 8
  %v4022 = add i64 %v4021, 1
  store i64 %v4022, ptr %NEXT_PC, align 8
  %v4023 = load ptr, ptr %MEMORY, align 8
  %v4024 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4023, ptr %state, ptr undef)
  store ptr %v4024, ptr %MEMORY, align 8
  %v4025 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4025, ptr %PC, align 8
  %v4026 = add i64 %v4025, 1
  store i64 %v4026, ptr %NEXT_PC, align 8
  %v4027 = load ptr, ptr %MEMORY, align 8
  %v4028 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4027, ptr %state, ptr undef)
  store ptr %v4028, ptr %MEMORY, align 8
  %v4029 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4029, ptr %PC, align 8
  %v4030 = add i64 %v4029, 5
  store i64 %v4030, ptr %NEXT_PC, align 8
  %v4031 = load i64, ptr %RSP, align 8
  %v4032 = add i64 %v4031, 8
  %v4033 = load i64, ptr %RBX, align 8
  %v4034 = load ptr, ptr %MEMORY, align 8
  %v4035 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4034, ptr %state, i64 %v4032, i64 %v4033)
  store ptr %v4035, ptr %MEMORY, align 8
  %v4036 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4036, ptr %PC, align 8
  %v4037 = add i64 %v4036, 5
  store i64 %v4037, ptr %NEXT_PC, align 8
  %v4038 = load i64, ptr %RSP, align 8
  %v4039 = add i64 %v4038, 16
  %v4040 = load i64, ptr %RSI, align 8
  %v4041 = load ptr, ptr %MEMORY, align 8
  %v4042 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4041, ptr %state, i64 %v4039, i64 %v4040)
  store ptr %v4042, ptr %MEMORY, align 8
  %v4043 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4043, ptr %PC, align 8
  %v4044 = add i64 %v4043, 1
  store i64 %v4044, ptr %NEXT_PC, align 8
  %v4045 = load i64, ptr %RDI, align 8
  %v4046 = load ptr, ptr %MEMORY, align 8
  %v4047 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v4046, ptr %state, i64 %v4045)
  store ptr %v4047, ptr %MEMORY, align 8
  %v4048 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4048, ptr %PC, align 8
  %v4049 = add i64 %v4048, 4
  store i64 %v4049, ptr %NEXT_PC, align 8
  %v4050 = load i64, ptr %RSP, align 8
  %v4051 = load ptr, ptr %MEMORY, align 8
  %v4052 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4051, ptr %state, ptr %RSP, i64 %v4050, i64 32)
  store ptr %v4052, ptr %MEMORY, align 8
  %v4053 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4053, ptr %PC, align 8
  %v4054 = add i64 %v4053, 3
  store i64 %v4054, ptr %NEXT_PC, align 8
  %v4055 = load i64, ptr %RDX, align 8
  %v4056 = load ptr, ptr %MEMORY, align 8
  %v4057 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4056, ptr %state, ptr %RSI, i64 %v4055)
  store ptr %v4057, ptr %MEMORY, align 8
  %v4058 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4058, ptr %PC, align 8
  %v4059 = add i64 %v4058, 3
  store i64 %v4059, ptr %NEXT_PC, align 8
  %v4060 = load i64, ptr %RCX, align 8
  %v4061 = load ptr, ptr %MEMORY, align 8
  %v4062 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4061, ptr %state, ptr %RDI, i64 %v4060)
  store ptr %v4062, ptr %MEMORY, align 8
  %v4063 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4063, ptr %PC, align 8
  %v4064 = add i64 %v4063, 2
  store i64 %v4064, ptr %NEXT_PC, align 8
  %v4065 = load i64, ptr %RBX, align 8
  %v4066 = load i32, ptr %EBX, align 4
  %v4067 = zext i32 %v4066 to i64
  %v4068 = load ptr, ptr %MEMORY, align 8
  %v4069 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4068, ptr %state, ptr %RBX, i64 %v4065, i64 %v4067)
  store ptr %v4069, ptr %MEMORY, align 8
  %v4070 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4070, ptr %PC, align 8
  %v4071 = add i64 %v4070, 5
  store i64 %v4071, ptr %NEXT_PC, align 8
  %v4072 = load i64, ptr %NEXT_PC, align 8
  %v4073 = add i64 %v4072, 100
  %v4074 = load i64, ptr %NEXT_PC, align 8
  %v4075 = load ptr, ptr %MEMORY, align 8
  %v4076 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v4075, ptr %state, i64 %v4073, ptr %NEXT_PC, i64 %v4074, ptr %RETURN_PC)
  store ptr %v4076, ptr %MEMORY, align 8
  %v4077 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4077, ptr %PC, align 8
  %v4078 = add i64 %v4077, 2
  store i64 %v4078, ptr %NEXT_PC, align 8
  %v4079 = load i32, ptr %EAX, align 4
  %v4080 = zext i32 %v4079 to i64
  %v4081 = load i32, ptr %EAX, align 4
  %v4082 = zext i32 %v4081 to i64
  %v4083 = load ptr, ptr %MEMORY, align 8
  %v4084 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4083, ptr %state, i64 %v4080, i64 %v4082)
  store ptr %v4084, ptr %MEMORY, align 8
  %v4085 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4085, ptr %PC, align 8
  %v4086 = add i64 %v4085, 2
  store i64 %v4086, ptr %NEXT_PC, align 8
  %v4087 = load i64, ptr %NEXT_PC, align 8
  %v4088 = add i64 %v4087, 39
  %v4089 = load i64, ptr %NEXT_PC, align 8
  %v4090 = load ptr, ptr %MEMORY, align 8
  %v4091 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4090, ptr %state, ptr %BRANCH_TAKEN, i64 %v4088, i64 %v4089, ptr %NEXT_PC)
  store ptr %v4091, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659591, label %bb_5395659552

bb_5395659552:                                    ; preds = %bb_5395659577, %bb_5395659494
  %v4092 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4092, ptr %PC, align 8
  %v4093 = add i64 %v4092, 2
  store i64 %v4093, ptr %NEXT_PC, align 8
  %v4094 = load i32, ptr %EBX, align 4
  %v4095 = zext i32 %v4094 to i64
  %v4096 = load ptr, ptr %MEMORY, align 8
  %v4097 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4096, ptr %state, ptr %RDX, i64 %v4095)
  store ptr %v4097, ptr %MEMORY, align 8
  %v4098 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4098, ptr %PC, align 8
  %v4099 = add i64 %v4098, 3
  store i64 %v4099, ptr %NEXT_PC, align 8
  %v4100 = load i64, ptr %RDI, align 8
  %v4101 = load ptr, ptr %MEMORY, align 8
  %v4102 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4101, ptr %state, ptr %RCX, i64 %v4100)
  store ptr %v4102, ptr %MEMORY, align 8
  %v4103 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4103, ptr %PC, align 8
  %v4104 = add i64 %v4103, 5
  store i64 %v4104, ptr %NEXT_PC, align 8
  %v4105 = load i64, ptr %NEXT_PC, align 8
  %v4106 = sub i64 %v4105, 202
  %v4107 = load i64, ptr %NEXT_PC, align 8
  %v4108 = load ptr, ptr %MEMORY, align 8
  %v4109 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v4108, ptr %state, i64 %v4106, ptr %NEXT_PC, i64 %v4107, ptr %RETURN_PC)
  store ptr %v4109, ptr %MEMORY, align 8
  %v4110 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4110, ptr %PC, align 8
  %v4111 = add i64 %v4110, 3
  store i64 %v4111, ptr %NEXT_PC, align 8
  %v4112 = load i64, ptr %RSI, align 8
  %v4113 = load ptr, ptr %MEMORY, align 8
  %v4114 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4113, ptr %state, ptr %RDX, i64 %v4112)
  store ptr %v4114, ptr %MEMORY, align 8
  %v4115 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4115, ptr %PC, align 8
  %v4116 = add i64 %v4115, 3
  store i64 %v4116, ptr %NEXT_PC, align 8
  %v4117 = load i64, ptr %RAX, align 8
  %v4118 = load ptr, ptr %MEMORY, align 8
  %v4119 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4118, ptr %state, ptr %RCX, i64 %v4117)
  store ptr %v4119, ptr %MEMORY, align 8
  %v4120 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4120, ptr %PC, align 8
  %v4121 = add i64 %v4120, 5
  store i64 %v4121, ptr %NEXT_PC, align 8
  %v4122 = load i64, ptr %NEXT_PC, align 8
  %v4123 = add i64 %v4122, 44747
  %v4124 = load i64, ptr %NEXT_PC, align 8
  %v4125 = load ptr, ptr %MEMORY, align 8
  %v4126 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v4125, ptr %state, i64 %v4123, ptr %NEXT_PC, i64 %v4124, ptr %RETURN_PC)
  store ptr %v4126, ptr %MEMORY, align 8
  %v4127 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4127, ptr %PC, align 8
  %v4128 = add i64 %v4127, 2
  store i64 %v4128, ptr %NEXT_PC, align 8
  %v4129 = load i32, ptr %EAX, align 4
  %v4130 = zext i32 %v4129 to i64
  %v4131 = load i32, ptr %EAX, align 4
  %v4132 = zext i32 %v4131 to i64
  %v4133 = load ptr, ptr %MEMORY, align 8
  %v4134 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4133, ptr %state, i64 %v4130, i64 %v4132)
  store ptr %v4134, ptr %MEMORY, align 8
  %v4135 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4135, ptr %PC, align 8
  %v4136 = add i64 %v4135, 2
  store i64 %v4136, ptr %NEXT_PC, align 8
  %v4137 = load i64, ptr %NEXT_PC, align 8
  %v4138 = add i64 %v4137, 33
  %v4139 = load i64, ptr %NEXT_PC, align 8
  %v4140 = load ptr, ptr %MEMORY, align 8
  %v4141 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4140, ptr %state, ptr %BRANCH_TAKEN, i64 %v4138, i64 %v4139, ptr %NEXT_PC)
  store ptr %v4141, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659610, label %bb_5395659577

bb_5395659577:                                    ; preds = %bb_5395659552
  %v4142 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4142, ptr %PC, align 8
  %v4143 = add i64 %v4142, 3
  store i64 %v4143, ptr %NEXT_PC, align 8
  %v4144 = load i64, ptr %RDI, align 8
  %v4145 = load ptr, ptr %MEMORY, align 8
  %v4146 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4145, ptr %state, ptr %RCX, i64 %v4144)
  store ptr %v4146, ptr %MEMORY, align 8
  %v4147 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4147, ptr %PC, align 8
  %v4148 = add i64 %v4147, 2
  store i64 %v4148, ptr %NEXT_PC, align 8
  %v4149 = load i64, ptr %RBX, align 8
  %v4150 = load ptr, ptr %MEMORY, align 8
  %v4151 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4150, ptr %state, ptr %RBX, i64 %v4149)
  store ptr %v4151, ptr %MEMORY, align 8
  %v4152 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4152, ptr %PC, align 8
  %v4153 = add i64 %v4152, 5
  store i64 %v4153, ptr %NEXT_PC, align 8
  %v4154 = load i64, ptr %NEXT_PC, align 8
  %v4155 = add i64 %v4154, 61
  %v4156 = load i64, ptr %NEXT_PC, align 8
  %v4157 = load ptr, ptr %MEMORY, align 8
  %v4158 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v4157, ptr %state, i64 %v4155, ptr %NEXT_PC, i64 %v4156, ptr %RETURN_PC)
  store ptr %v4158, ptr %MEMORY, align 8
  %v4159 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4159, ptr %PC, align 8
  %v4160 = add i64 %v4159, 2
  store i64 %v4160, ptr %NEXT_PC, align 8
  %v4161 = load i32, ptr %EBX, align 4
  %v4162 = zext i32 %v4161 to i64
  %v4163 = load i32, ptr %EAX, align 4
  %v4164 = zext i32 %v4163 to i64
  %v4165 = load ptr, ptr %MEMORY, align 8
  %v4166 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4165, ptr %state, i64 %v4162, i64 %v4164)
  store ptr %v4166, ptr %MEMORY, align 8
  %v4167 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4167, ptr %PC, align 8
  %v4168 = add i64 %v4167, 2
  store i64 %v4168, ptr %NEXT_PC, align 8
  %v4169 = load i64, ptr %NEXT_PC, align 8
  %v4170 = sub i64 %v4169, 39
  %v4171 = load i64, ptr %NEXT_PC, align 8
  %v4172 = load ptr, ptr %MEMORY, align 8
  %v4173 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4172, ptr %state, ptr %BRANCH_TAKEN, i64 %v4170, i64 %v4171, ptr %NEXT_PC)
  store ptr %v4173, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659552, label %bb_5395659591

bb_5395659591:                                    ; preds = %bb_5395659577, %bb_5395659494
  %v4174 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4174, ptr %PC, align 8
  %v4175 = add i64 %v4174, 3
  store i64 %v4175, ptr %NEXT_PC, align 8
  %v4176 = load i64, ptr %RAX, align 8
  %v4177 = load ptr, ptr %MEMORY, align 8
  %v4178 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4177, ptr %state, ptr %RAX, i64 %v4176, i64 -1)
  store ptr %v4178, ptr %MEMORY, align 8
  %v4179 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4179, ptr %PC, align 8
  %v4180 = add i64 %v4179, 5
  store i64 %v4180, ptr %NEXT_PC, align 8
  %v4181 = load i64, ptr %RSP, align 8
  %v4182 = add i64 %v4181, 48
  %v4183 = load ptr, ptr %MEMORY, align 8
  %v4184 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4183, ptr %state, ptr %RBX, i64 %v4182)
  store ptr %v4184, ptr %MEMORY, align 8
  %v4185 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4185, ptr %PC, align 8
  %v4186 = add i64 %v4185, 5
  store i64 %v4186, ptr %NEXT_PC, align 8
  %v4187 = load i64, ptr %RSP, align 8
  %v4188 = add i64 %v4187, 56
  %v4189 = load ptr, ptr %MEMORY, align 8
  %v4190 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4189, ptr %state, ptr %RSI, i64 %v4188)
  store ptr %v4190, ptr %MEMORY, align 8
  %v4191 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4191, ptr %PC, align 8
  %v4192 = add i64 %v4191, 4
  store i64 %v4192, ptr %NEXT_PC, align 8
  %v4193 = load i64, ptr %RSP, align 8
  %v4194 = load ptr, ptr %MEMORY, align 8
  %v4195 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4194, ptr %state, ptr %RSP, i64 %v4193, i64 32)
  store ptr %v4195, ptr %MEMORY, align 8
  %v4196 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4196, ptr %PC, align 8
  %v4197 = add i64 %v4196, 1
  store i64 %v4197, ptr %NEXT_PC, align 8
  %v4198 = load ptr, ptr %MEMORY, align 8
  %v4199 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v4198, ptr %state, ptr %RDI)
  store ptr %v4199, ptr %MEMORY, align 8
  %v4200 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4200, ptr %PC, align 8
  %v4201 = add i64 %v4200, 1
  store i64 %v4201, ptr %NEXT_PC, align 8
  %v4202 = load ptr, ptr %MEMORY, align 8
  %v4203 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v4202, ptr %state, ptr %NEXT_PC)
  store ptr %v4203, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659610:                                    ; preds = %bb_5395659552
  %v4204 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4204, ptr %PC, align 8
  %v4205 = add i64 %v4204, 5
  store i64 %v4205, ptr %NEXT_PC, align 8
  %v4206 = load i64, ptr %RSP, align 8
  %v4207 = add i64 %v4206, 56
  %v4208 = load ptr, ptr %MEMORY, align 8
  %v4209 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4208, ptr %state, ptr %RSI, i64 %v4207)
  store ptr %v4209, ptr %MEMORY, align 8
  %v4210 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4210, ptr %PC, align 8
  %v4211 = add i64 %v4210, 2
  store i64 %v4211, ptr %NEXT_PC, align 8
  %v4212 = load i32, ptr %EBX, align 4
  %v4213 = zext i32 %v4212 to i64
  %v4214 = load ptr, ptr %MEMORY, align 8
  %v4215 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4214, ptr %state, ptr %RAX, i64 %v4213)
  store ptr %v4215, ptr %MEMORY, align 8
  %v4216 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4216, ptr %PC, align 8
  %v4217 = add i64 %v4216, 5
  store i64 %v4217, ptr %NEXT_PC, align 8
  %v4218 = load i64, ptr %RSP, align 8
  %v4219 = add i64 %v4218, 48
  %v4220 = load ptr, ptr %MEMORY, align 8
  %v4221 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4220, ptr %state, ptr %RBX, i64 %v4219)
  store ptr %v4221, ptr %MEMORY, align 8
  %v4222 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4222, ptr %PC, align 8
  %v4223 = add i64 %v4222, 4
  store i64 %v4223, ptr %NEXT_PC, align 8
  %v4224 = load i64, ptr %RSP, align 8
  %v4225 = load ptr, ptr %MEMORY, align 8
  %v4226 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4225, ptr %state, ptr %RSP, i64 %v4224, i64 32)
  store ptr %v4226, ptr %MEMORY, align 8
  %v4227 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4227, ptr %PC, align 8
  %v4228 = add i64 %v4227, 1
  store i64 %v4228, ptr %NEXT_PC, align 8
  %v4229 = load ptr, ptr %MEMORY, align 8
  %v4230 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v4229, ptr %state, ptr %RDI)
  store ptr %v4230, ptr %MEMORY, align 8
  %v4231 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4231, ptr %PC, align 8
  %v4232 = add i64 %v4231, 1
  store i64 %v4232, ptr %NEXT_PC, align 8
  %v4233 = load ptr, ptr %MEMORY, align 8
  %v4234 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v4233, ptr %state, ptr %NEXT_PC)
  store ptr %v4234, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659628:                                    ; No predecessors!
  %v4235 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4235, ptr %PC, align 8
  %v4236 = add i64 %v4235, 1
  store i64 %v4236, ptr %NEXT_PC, align 8
  %v4237 = load ptr, ptr %MEMORY, align 8
  %v4238 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4237, ptr %state, ptr undef)
  store ptr %v4238, ptr %MEMORY, align 8
  %v4239 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4239, ptr %PC, align 8
  %v4240 = add i64 %v4239, 1
  store i64 %v4240, ptr %NEXT_PC, align 8
  %v4241 = load ptr, ptr %MEMORY, align 8
  %v4242 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4241, ptr %state, ptr undef)
  store ptr %v4242, ptr %MEMORY, align 8
  %v4243 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4243, ptr %PC, align 8
  %v4244 = add i64 %v4243, 1
  store i64 %v4244, ptr %NEXT_PC, align 8
  %v4245 = load ptr, ptr %MEMORY, align 8
  %v4246 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4245, ptr %state, ptr undef)
  store ptr %v4246, ptr %MEMORY, align 8
  %v4247 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4247, ptr %PC, align 8
  %v4248 = add i64 %v4247, 1
  store i64 %v4248, ptr %NEXT_PC, align 8
  %v4249 = load ptr, ptr %MEMORY, align 8
  %v4250 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4249, ptr %state, ptr undef)
  store ptr %v4250, ptr %MEMORY, align 8
  %v4251 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4251, ptr %PC, align 8
  %v4252 = add i64 %v4251, 1
  store i64 %v4252, ptr %NEXT_PC, align 8
  %v4253 = load ptr, ptr %MEMORY, align 8
  %v4254 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4253, ptr %state, ptr undef)
  store ptr %v4254, ptr %MEMORY, align 8
  %v4255 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4255, ptr %PC, align 8
  %v4256 = add i64 %v4255, 1
  store i64 %v4256, ptr %NEXT_PC, align 8
  %v4257 = load ptr, ptr %MEMORY, align 8
  %v4258 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4257, ptr %state, ptr undef)
  store ptr %v4258, ptr %MEMORY, align 8
  %v4259 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4259, ptr %PC, align 8
  %v4260 = add i64 %v4259, 1
  store i64 %v4260, ptr %NEXT_PC, align 8
  %v4261 = load ptr, ptr %MEMORY, align 8
  %v4262 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4261, ptr %state, ptr undef)
  store ptr %v4262, ptr %MEMORY, align 8
  %v4263 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4263, ptr %PC, align 8
  %v4264 = add i64 %v4263, 1
  store i64 %v4264, ptr %NEXT_PC, align 8
  %v4265 = load ptr, ptr %MEMORY, align 8
  %v4266 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4265, ptr %state, ptr undef)
  store ptr %v4266, ptr %MEMORY, align 8
  %v4267 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4267, ptr %PC, align 8
  %v4268 = add i64 %v4267, 1
  store i64 %v4268, ptr %NEXT_PC, align 8
  %v4269 = load ptr, ptr %MEMORY, align 8
  %v4270 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4269, ptr %state, ptr undef)
  store ptr %v4270, ptr %MEMORY, align 8
  %v4271 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4271, ptr %PC, align 8
  %v4272 = add i64 %v4271, 1
  store i64 %v4272, ptr %NEXT_PC, align 8
  %v4273 = load ptr, ptr %MEMORY, align 8
  %v4274 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4273, ptr %state, ptr undef)
  store ptr %v4274, ptr %MEMORY, align 8
  %v4275 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4275, ptr %PC, align 8
  %v4276 = add i64 %v4275, 1
  store i64 %v4276, ptr %NEXT_PC, align 8
  %v4277 = load ptr, ptr %MEMORY, align 8
  %v4278 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4277, ptr %state, ptr undef)
  store ptr %v4278, ptr %MEMORY, align 8
  %v4279 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4279, ptr %PC, align 8
  %v4280 = add i64 %v4279, 1
  store i64 %v4280, ptr %NEXT_PC, align 8
  %v4281 = load ptr, ptr %MEMORY, align 8
  %v4282 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4281, ptr %state, ptr undef)
  store ptr %v4282, ptr %MEMORY, align 8
  %v4283 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4283, ptr %PC, align 8
  %v4284 = add i64 %v4283, 1
  store i64 %v4284, ptr %NEXT_PC, align 8
  %v4285 = load ptr, ptr %MEMORY, align 8
  %v4286 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4285, ptr %state, ptr undef)
  store ptr %v4286, ptr %MEMORY, align 8
  %v4287 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4287, ptr %PC, align 8
  %v4288 = add i64 %v4287, 1
  store i64 %v4288, ptr %NEXT_PC, align 8
  %v4289 = load ptr, ptr %MEMORY, align 8
  %v4290 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4289, ptr %state, ptr undef)
  store ptr %v4290, ptr %MEMORY, align 8
  %v4291 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4291, ptr %PC, align 8
  %v4292 = add i64 %v4291, 1
  store i64 %v4292, ptr %NEXT_PC, align 8
  %v4293 = load ptr, ptr %MEMORY, align 8
  %v4294 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4293, ptr %state, ptr undef)
  store ptr %v4294, ptr %MEMORY, align 8
  %v4295 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4295, ptr %PC, align 8
  %v4296 = add i64 %v4295, 1
  store i64 %v4296, ptr %NEXT_PC, align 8
  %v4297 = load ptr, ptr %MEMORY, align 8
  %v4298 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4297, ptr %state, ptr undef)
  store ptr %v4298, ptr %MEMORY, align 8
  %v4299 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4299, ptr %PC, align 8
  %v4300 = add i64 %v4299, 1
  store i64 %v4300, ptr %NEXT_PC, align 8
  %v4301 = load ptr, ptr %MEMORY, align 8
  %v4302 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4301, ptr %state, ptr undef)
  store ptr %v4302, ptr %MEMORY, align 8
  %v4303 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4303, ptr %PC, align 8
  %v4304 = add i64 %v4303, 1
  store i64 %v4304, ptr %NEXT_PC, align 8
  %v4305 = load ptr, ptr %MEMORY, align 8
  %v4306 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4305, ptr %state, ptr undef)
  store ptr %v4306, ptr %MEMORY, align 8
  %v4307 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4307, ptr %PC, align 8
  %v4308 = add i64 %v4307, 1
  store i64 %v4308, ptr %NEXT_PC, align 8
  %v4309 = load ptr, ptr %MEMORY, align 8
  %v4310 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4309, ptr %state, ptr undef)
  store ptr %v4310, ptr %MEMORY, align 8
  %v4311 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4311, ptr %PC, align 8
  %v4312 = add i64 %v4311, 1
  store i64 %v4312, ptr %NEXT_PC, align 8
  %v4313 = load ptr, ptr %MEMORY, align 8
  %v4314 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4313, ptr %state, ptr undef)
  store ptr %v4314, ptr %MEMORY, align 8
  %v4315 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4315, ptr %PC, align 8
  %v4316 = add i64 %v4315, 3
  store i64 %v4316, ptr %NEXT_PC, align 8
  %v4317 = load i64, ptr %RCX, align 8
  %v4318 = add i64 %v4317, 48
  %v4319 = load ptr, ptr %MEMORY, align 8
  %v4320 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4319, ptr %state, ptr %RAX, i64 %v4318)
  store ptr %v4320, ptr %MEMORY, align 8
  %v4321 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4321, ptr %PC, align 8
  %v4322 = add i64 %v4321, 1
  store i64 %v4322, ptr %NEXT_PC, align 8
  %v4323 = load ptr, ptr %MEMORY, align 8
  %v4324 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v4323, ptr %state, ptr %NEXT_PC)
  store ptr %v4324, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659652:                                    ; No predecessors!
  %v4325 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4325, ptr %PC, align 8
  %v4326 = add i64 %v4325, 1
  store i64 %v4326, ptr %NEXT_PC, align 8
  %v4327 = load ptr, ptr %MEMORY, align 8
  %v4328 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4327, ptr %state, ptr undef)
  store ptr %v4328, ptr %MEMORY, align 8
  %v4329 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4329, ptr %PC, align 8
  %v4330 = add i64 %v4329, 1
  store i64 %v4330, ptr %NEXT_PC, align 8
  %v4331 = load ptr, ptr %MEMORY, align 8
  %v4332 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4331, ptr %state, ptr undef)
  store ptr %v4332, ptr %MEMORY, align 8
  %v4333 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4333, ptr %PC, align 8
  %v4334 = add i64 %v4333, 1
  store i64 %v4334, ptr %NEXT_PC, align 8
  %v4335 = load ptr, ptr %MEMORY, align 8
  %v4336 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4335, ptr %state, ptr undef)
  store ptr %v4336, ptr %MEMORY, align 8
  %v4337 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4337, ptr %PC, align 8
  %v4338 = add i64 %v4337, 1
  store i64 %v4338, ptr %NEXT_PC, align 8
  %v4339 = load ptr, ptr %MEMORY, align 8
  %v4340 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4339, ptr %state, ptr undef)
  store ptr %v4340, ptr %MEMORY, align 8
  %v4341 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4341, ptr %PC, align 8
  %v4342 = add i64 %v4341, 1
  store i64 %v4342, ptr %NEXT_PC, align 8
  %v4343 = load ptr, ptr %MEMORY, align 8
  %v4344 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4343, ptr %state, ptr undef)
  store ptr %v4344, ptr %MEMORY, align 8
  %v4345 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4345, ptr %PC, align 8
  %v4346 = add i64 %v4345, 1
  store i64 %v4346, ptr %NEXT_PC, align 8
  %v4347 = load ptr, ptr %MEMORY, align 8
  %v4348 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4347, ptr %state, ptr undef)
  store ptr %v4348, ptr %MEMORY, align 8
  %v4349 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4349, ptr %PC, align 8
  %v4350 = add i64 %v4349, 1
  store i64 %v4350, ptr %NEXT_PC, align 8
  %v4351 = load ptr, ptr %MEMORY, align 8
  %v4352 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4351, ptr %state, ptr undef)
  store ptr %v4352, ptr %MEMORY, align 8
  %v4353 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4353, ptr %PC, align 8
  %v4354 = add i64 %v4353, 1
  store i64 %v4354, ptr %NEXT_PC, align 8
  %v4355 = load ptr, ptr %MEMORY, align 8
  %v4356 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4355, ptr %state, ptr undef)
  store ptr %v4356, ptr %MEMORY, align 8
  %v4357 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4357, ptr %PC, align 8
  %v4358 = add i64 %v4357, 1
  store i64 %v4358, ptr %NEXT_PC, align 8
  %v4359 = load ptr, ptr %MEMORY, align 8
  %v4360 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4359, ptr %state, ptr undef)
  store ptr %v4360, ptr %MEMORY, align 8
  %v4361 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4361, ptr %PC, align 8
  %v4362 = add i64 %v4361, 1
  store i64 %v4362, ptr %NEXT_PC, align 8
  %v4363 = load ptr, ptr %MEMORY, align 8
  %v4364 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4363, ptr %state, ptr undef)
  store ptr %v4364, ptr %MEMORY, align 8
  %v4365 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4365, ptr %PC, align 8
  %v4366 = add i64 %v4365, 1
  store i64 %v4366, ptr %NEXT_PC, align 8
  %v4367 = load ptr, ptr %MEMORY, align 8
  %v4368 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4367, ptr %state, ptr undef)
  store ptr %v4368, ptr %MEMORY, align 8
  %v4369 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4369, ptr %PC, align 8
  %v4370 = add i64 %v4369, 1
  store i64 %v4370, ptr %NEXT_PC, align 8
  %v4371 = load ptr, ptr %MEMORY, align 8
  %v4372 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4371, ptr %state, ptr undef)
  store ptr %v4372, ptr %MEMORY, align 8
  %v4373 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4373, ptr %PC, align 8
  %v4374 = add i64 %v4373, 3
  store i64 %v4374, ptr %NEXT_PC, align 8
  %v4375 = load i64, ptr %RCX, align 8
  %v4376 = add i64 %v4375, 16
  %v4377 = load ptr, ptr %MEMORY, align 8
  %v4378 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4377, ptr %state, ptr %RAX, i64 %v4376)
  store ptr %v4378, ptr %MEMORY, align 8
  %v4379 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4379, ptr %PC, align 8
  %v4380 = add i64 %v4379, 1
  store i64 %v4380, ptr %NEXT_PC, align 8
  %v4381 = load ptr, ptr %MEMORY, align 8
  %v4382 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v4381, ptr %state, ptr %NEXT_PC)
  store ptr %v4382, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659668:                                    ; No predecessors!
  %v4383 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4383, ptr %PC, align 8
  %v4384 = add i64 %v4383, 1
  store i64 %v4384, ptr %NEXT_PC, align 8
  %v4385 = load ptr, ptr %MEMORY, align 8
  %v4386 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4385, ptr %state, ptr undef)
  store ptr %v4386, ptr %MEMORY, align 8
  %v4387 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4387, ptr %PC, align 8
  %v4388 = add i64 %v4387, 1
  store i64 %v4388, ptr %NEXT_PC, align 8
  %v4389 = load ptr, ptr %MEMORY, align 8
  %v4390 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4389, ptr %state, ptr undef)
  store ptr %v4390, ptr %MEMORY, align 8
  %v4391 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4391, ptr %PC, align 8
  %v4392 = add i64 %v4391, 1
  store i64 %v4392, ptr %NEXT_PC, align 8
  %v4393 = load ptr, ptr %MEMORY, align 8
  %v4394 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4393, ptr %state, ptr undef)
  store ptr %v4394, ptr %MEMORY, align 8
  %v4395 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4395, ptr %PC, align 8
  %v4396 = add i64 %v4395, 1
  store i64 %v4396, ptr %NEXT_PC, align 8
  %v4397 = load ptr, ptr %MEMORY, align 8
  %v4398 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4397, ptr %state, ptr undef)
  store ptr %v4398, ptr %MEMORY, align 8
  %v4399 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4399, ptr %PC, align 8
  %v4400 = add i64 %v4399, 1
  store i64 %v4400, ptr %NEXT_PC, align 8
  %v4401 = load ptr, ptr %MEMORY, align 8
  %v4402 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4401, ptr %state, ptr undef)
  store ptr %v4402, ptr %MEMORY, align 8
  %v4403 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4403, ptr %PC, align 8
  %v4404 = add i64 %v4403, 1
  store i64 %v4404, ptr %NEXT_PC, align 8
  %v4405 = load ptr, ptr %MEMORY, align 8
  %v4406 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4405, ptr %state, ptr undef)
  store ptr %v4406, ptr %MEMORY, align 8
  %v4407 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4407, ptr %PC, align 8
  %v4408 = add i64 %v4407, 1
  store i64 %v4408, ptr %NEXT_PC, align 8
  %v4409 = load ptr, ptr %MEMORY, align 8
  %v4410 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4409, ptr %state, ptr undef)
  store ptr %v4410, ptr %MEMORY, align 8
  %v4411 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4411, ptr %PC, align 8
  %v4412 = add i64 %v4411, 1
  store i64 %v4412, ptr %NEXT_PC, align 8
  %v4413 = load ptr, ptr %MEMORY, align 8
  %v4414 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4413, ptr %state, ptr undef)
  store ptr %v4414, ptr %MEMORY, align 8
  %v4415 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4415, ptr %PC, align 8
  %v4416 = add i64 %v4415, 1
  store i64 %v4416, ptr %NEXT_PC, align 8
  %v4417 = load ptr, ptr %MEMORY, align 8
  %v4418 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4417, ptr %state, ptr undef)
  store ptr %v4418, ptr %MEMORY, align 8
  %v4419 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4419, ptr %PC, align 8
  %v4420 = add i64 %v4419, 1
  store i64 %v4420, ptr %NEXT_PC, align 8
  %v4421 = load ptr, ptr %MEMORY, align 8
  %v4422 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4421, ptr %state, ptr undef)
  store ptr %v4422, ptr %MEMORY, align 8
  %v4423 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4423, ptr %PC, align 8
  %v4424 = add i64 %v4423, 1
  store i64 %v4424, ptr %NEXT_PC, align 8
  %v4425 = load ptr, ptr %MEMORY, align 8
  %v4426 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4425, ptr %state, ptr undef)
  store ptr %v4426, ptr %MEMORY, align 8
  %v4427 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4427, ptr %PC, align 8
  %v4428 = add i64 %v4427, 1
  store i64 %v4428, ptr %NEXT_PC, align 8
  %v4429 = load ptr, ptr %MEMORY, align 8
  %v4430 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4429, ptr %state, ptr undef)
  store ptr %v4430, ptr %MEMORY, align 8
  %v4431 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4431, ptr %PC, align 8
  %v4432 = add i64 %v4431, 3
  store i64 %v4432, ptr %NEXT_PC, align 8
  %v4433 = load i64, ptr %RCX, align 8
  %v4434 = add i64 %v4433, 16
  %v4435 = load i32, ptr %EDX, align 4
  %v4436 = zext i32 %v4435 to i64
  %v4437 = load ptr, ptr %MEMORY, align 8
  %v4438 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4437, ptr %state, i64 %v4434, i64 %v4436)
  store ptr %v4438, ptr %MEMORY, align 8
  %v4439 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4439, ptr %PC, align 8
  %v4440 = add i64 %v4439, 1
  store i64 %v4440, ptr %NEXT_PC, align 8
  %v4441 = load ptr, ptr %MEMORY, align 8
  %v4442 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v4441, ptr %state, ptr %NEXT_PC)
  store ptr %v4442, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659684:                                    ; No predecessors!
  %v4443 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4443, ptr %PC, align 8
  %v4444 = add i64 %v4443, 1
  store i64 %v4444, ptr %NEXT_PC, align 8
  %v4445 = load ptr, ptr %MEMORY, align 8
  %v4446 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4445, ptr %state, ptr undef)
  store ptr %v4446, ptr %MEMORY, align 8
  %v4447 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4447, ptr %PC, align 8
  %v4448 = add i64 %v4447, 1
  store i64 %v4448, ptr %NEXT_PC, align 8
  %v4449 = load ptr, ptr %MEMORY, align 8
  %v4450 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4449, ptr %state, ptr undef)
  store ptr %v4450, ptr %MEMORY, align 8
  %v4451 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4451, ptr %PC, align 8
  %v4452 = add i64 %v4451, 1
  store i64 %v4452, ptr %NEXT_PC, align 8
  %v4453 = load ptr, ptr %MEMORY, align 8
  %v4454 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4453, ptr %state, ptr undef)
  store ptr %v4454, ptr %MEMORY, align 8
  %v4455 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4455, ptr %PC, align 8
  %v4456 = add i64 %v4455, 1
  store i64 %v4456, ptr %NEXT_PC, align 8
  %v4457 = load ptr, ptr %MEMORY, align 8
  %v4458 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4457, ptr %state, ptr undef)
  store ptr %v4458, ptr %MEMORY, align 8
  %v4459 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4459, ptr %PC, align 8
  %v4460 = add i64 %v4459, 1
  store i64 %v4460, ptr %NEXT_PC, align 8
  %v4461 = load ptr, ptr %MEMORY, align 8
  %v4462 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4461, ptr %state, ptr undef)
  store ptr %v4462, ptr %MEMORY, align 8
  %v4463 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4463, ptr %PC, align 8
  %v4464 = add i64 %v4463, 1
  store i64 %v4464, ptr %NEXT_PC, align 8
  %v4465 = load ptr, ptr %MEMORY, align 8
  %v4466 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4465, ptr %state, ptr undef)
  store ptr %v4466, ptr %MEMORY, align 8
  %v4467 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4467, ptr %PC, align 8
  %v4468 = add i64 %v4467, 1
  store i64 %v4468, ptr %NEXT_PC, align 8
  %v4469 = load ptr, ptr %MEMORY, align 8
  %v4470 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4469, ptr %state, ptr undef)
  store ptr %v4470, ptr %MEMORY, align 8
  %v4471 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4471, ptr %PC, align 8
  %v4472 = add i64 %v4471, 1
  store i64 %v4472, ptr %NEXT_PC, align 8
  %v4473 = load ptr, ptr %MEMORY, align 8
  %v4474 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4473, ptr %state, ptr undef)
  store ptr %v4474, ptr %MEMORY, align 8
  %v4475 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4475, ptr %PC, align 8
  %v4476 = add i64 %v4475, 1
  store i64 %v4476, ptr %NEXT_PC, align 8
  %v4477 = load ptr, ptr %MEMORY, align 8
  %v4478 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4477, ptr %state, ptr undef)
  store ptr %v4478, ptr %MEMORY, align 8
  %v4479 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4479, ptr %PC, align 8
  %v4480 = add i64 %v4479, 1
  store i64 %v4480, ptr %NEXT_PC, align 8
  %v4481 = load ptr, ptr %MEMORY, align 8
  %v4482 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4481, ptr %state, ptr undef)
  store ptr %v4482, ptr %MEMORY, align 8
  %v4483 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4483, ptr %PC, align 8
  %v4484 = add i64 %v4483, 1
  store i64 %v4484, ptr %NEXT_PC, align 8
  %v4485 = load ptr, ptr %MEMORY, align 8
  %v4486 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4485, ptr %state, ptr undef)
  store ptr %v4486, ptr %MEMORY, align 8
  %v4487 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4487, ptr %PC, align 8
  %v4488 = add i64 %v4487, 1
  store i64 %v4488, ptr %NEXT_PC, align 8
  %v4489 = load ptr, ptr %MEMORY, align 8
  %v4490 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4489, ptr %state, ptr undef)
  store ptr %v4490, ptr %MEMORY, align 8
  %v4491 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4491, ptr %PC, align 8
  %v4492 = add i64 %v4491, 5
  store i64 %v4492, ptr %NEXT_PC, align 8
  %v4493 = load i64, ptr %RSP, align 8
  %v4494 = add i64 %v4493, 8
  %v4495 = load i64, ptr %RBX, align 8
  %v4496 = load ptr, ptr %MEMORY, align 8
  %v4497 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4496, ptr %state, i64 %v4494, i64 %v4495)
  store ptr %v4497, ptr %MEMORY, align 8
  %v4498 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4498, ptr %PC, align 8
  %v4499 = add i64 %v4498, 1
  store i64 %v4499, ptr %NEXT_PC, align 8
  %v4500 = load i64, ptr %RDI, align 8
  %v4501 = load ptr, ptr %MEMORY, align 8
  %v4502 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v4501, ptr %state, i64 %v4500)
  store ptr %v4502, ptr %MEMORY, align 8
  %v4503 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4503, ptr %PC, align 8
  %v4504 = add i64 %v4503, 4
  store i64 %v4504, ptr %NEXT_PC, align 8
  %v4505 = load i64, ptr %RSP, align 8
  %v4506 = load ptr, ptr %MEMORY, align 8
  %v4507 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4506, ptr %state, ptr %RSP, i64 %v4505, i64 32)
  store ptr %v4507, ptr %MEMORY, align 8
  %v4508 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4508, ptr %PC, align 8
  %v4509 = add i64 %v4508, 3
  store i64 %v4509, ptr %NEXT_PC, align 8
  %v4510 = load i64, ptr %RDX, align 8
  %v4511 = load ptr, ptr %MEMORY, align 8
  %v4512 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4511, ptr %state, ptr %RDI, i64 %v4510)
  store ptr %v4512, ptr %MEMORY, align 8
  %v4513 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4513, ptr %PC, align 8
  %v4514 = add i64 %v4513, 3
  store i64 %v4514, ptr %NEXT_PC, align 8
  %v4515 = load i64, ptr %RCX, align 8
  %v4516 = load ptr, ptr %MEMORY, align 8
  %v4517 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4516, ptr %state, ptr %RBX, i64 %v4515)
  store ptr %v4517, ptr %MEMORY, align 8
  %v4518 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4518, ptr %PC, align 8
  %v4519 = add i64 %v4518, 5
  store i64 %v4519, ptr %NEXT_PC, align 8
  %v4520 = load i64, ptr %NEXT_PC, align 8
  %v4521 = sub i64 %v4520, 1685
  %v4522 = load i64, ptr %NEXT_PC, align 8
  %v4523 = load ptr, ptr %MEMORY, align 8
  %v4524 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v4523, ptr %state, i64 %v4521, ptr %NEXT_PC, i64 %v4522, ptr %RETURN_PC)
  store ptr %v4524, ptr %MEMORY, align 8
  %v4525 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4525, ptr %PC, align 8
  %v4526 = add i64 %v4525, 3
  store i64 %v4526, ptr %NEXT_PC, align 8
  %v4527 = load i64, ptr %RAX, align 8
  %v4528 = load i64, ptr %RAX, align 8
  %v4529 = load ptr, ptr %MEMORY, align 8
  %v4530 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4529, ptr %state, i64 %v4527, i64 %v4528)
  store ptr %v4530, ptr %MEMORY, align 8
  %v4531 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4531, ptr %PC, align 8
  %v4532 = add i64 %v4531, 2
  store i64 %v4532, ptr %NEXT_PC, align 8
  %v4533 = load i64, ptr %NEXT_PC, align 8
  %v4534 = add i64 %v4533, 22
  %v4535 = load i64, ptr %NEXT_PC, align 8
  %v4536 = load ptr, ptr %MEMORY, align 8
  %v4537 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4536, ptr %state, ptr %BRANCH_TAKEN, i64 %v4534, i64 %v4535, ptr %NEXT_PC)
  store ptr %v4537, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659744, label %bb_5395659722

bb_5395659722:                                    ; preds = %bb_5395659684
  %v4538 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4538, ptr %PC, align 8
  %v4539 = add i64 %v4538, 6
  store i64 %v4539, ptr %NEXT_PC, align 8
  %v4540 = load i64, ptr %RAX, align 8
  %v4541 = load i64, ptr %RAX, align 8
  %v4542 = mul i64 %v4541, 1
  %v4543 = add i64 %v4540, %v4542
  %v4544 = load ptr, ptr %MEMORY, align 8
  %v4545 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnItEEEEP6MemoryS4_R5StateDpT_(ptr %v4544, ptr %state, i64 %v4543)
  store ptr %v4545, ptr %MEMORY, align 8
  br label %bb_5395659728

bb_5395659728:                                    ; preds = %bb_5395659728, %bb_5395659722
  %v4546 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4546, ptr %PC, align 8
  %v4547 = add i64 %v4546, 3
  store i64 %v4547, ptr %NEXT_PC, align 8
  %v4548 = load i64, ptr %RAX, align 8
  %v4549 = load ptr, ptr %MEMORY, align 8
  %v4550 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4549, ptr %state, ptr %RCX, i64 %v4548)
  store ptr %v4550, ptr %MEMORY, align 8
  %v4551 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4551, ptr %PC, align 8
  %v4552 = add i64 %v4551, 3
  store i64 %v4552, ptr %NEXT_PC, align 8
  %v4553 = load i64, ptr %RAX, align 8
  %v4554 = load ptr, ptr %MEMORY, align 8
  %v4555 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4554, ptr %state, ptr %RBX, i64 %v4553)
  store ptr %v4555, ptr %MEMORY, align 8
  %v4556 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4556, ptr %PC, align 8
  %v4557 = add i64 %v4556, 5
  store i64 %v4557, ptr %NEXT_PC, align 8
  %v4558 = load i64, ptr %NEXT_PC, align 8
  %v4559 = sub i64 %v4558, 1707
  %v4560 = load i64, ptr %NEXT_PC, align 8
  %v4561 = load ptr, ptr %MEMORY, align 8
  %v4562 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v4561, ptr %state, i64 %v4559, ptr %NEXT_PC, i64 %v4560, ptr %RETURN_PC)
  store ptr %v4562, ptr %MEMORY, align 8
  %v4563 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4563, ptr %PC, align 8
  %v4564 = add i64 %v4563, 3
  store i64 %v4564, ptr %NEXT_PC, align 8
  %v4565 = load i64, ptr %RAX, align 8
  %v4566 = load i64, ptr %RAX, align 8
  %v4567 = load ptr, ptr %MEMORY, align 8
  %v4568 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4567, ptr %state, i64 %v4565, i64 %v4566)
  store ptr %v4568, ptr %MEMORY, align 8
  %v4569 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4569, ptr %PC, align 8
  %v4570 = add i64 %v4569, 2
  store i64 %v4570, ptr %NEXT_PC, align 8
  %v4571 = load i64, ptr %NEXT_PC, align 8
  %v4572 = sub i64 %v4571, 16
  %v4573 = load i64, ptr %NEXT_PC, align 8
  %v4574 = load ptr, ptr %MEMORY, align 8
  %v4575 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4574, ptr %state, ptr %BRANCH_TAKEN, i64 %v4572, i64 %v4573, ptr %NEXT_PC)
  store ptr %v4575, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659728, label %bb_5395659744

bb_5395659744:                                    ; preds = %bb_5395659728, %bb_5395659684
  %v4576 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4576, ptr %PC, align 8
  %v4577 = add i64 %v4576, 4
  store i64 %v4577, ptr %NEXT_PC, align 8
  %v4578 = load i64, ptr %RBX, align 8
  %v4579 = add i64 %v4578, 20
  %v4580 = load ptr, ptr %MEMORY, align 8
  %v4581 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4580, ptr %state, i64 %v4579, i64 0)
  store ptr %v4581, ptr %MEMORY, align 8
  %v4582 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4582, ptr %PC, align 8
  %v4583 = add i64 %v4582, 5
  store i64 %v4583, ptr %NEXT_PC, align 8
  %v4584 = load i64, ptr %RSP, align 8
  %v4585 = add i64 %v4584, 48
  %v4586 = load ptr, ptr %MEMORY, align 8
  %v4587 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4586, ptr %state, ptr %RBX, i64 %v4585)
  store ptr %v4587, ptr %MEMORY, align 8
  %v4588 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4588, ptr %PC, align 8
  %v4589 = add i64 %v4588, 3
  store i64 %v4589, ptr %NEXT_PC, align 8
  %v4590 = load ptr, ptr %MEMORY, align 8
  %v4591 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v4590, ptr %state, ptr %AL)
  store ptr %v4591, ptr %MEMORY, align 8
  %v4592 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4592, ptr %PC, align 8
  %v4593 = add i64 %v4592, 2
  store i64 %v4593, ptr %NEXT_PC, align 8
  %v4594 = load i64, ptr %RDI, align 8
  %v4595 = load i8, ptr %AL, align 1
  %v4596 = zext i8 %v4595 to i64
  %v4597 = load ptr, ptr %MEMORY, align 8
  %v4598 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4597, ptr %state, i64 %v4594, i64 %v4596)
  store ptr %v4598, ptr %MEMORY, align 8
  %v4599 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4599, ptr %PC, align 8
  %v4600 = add i64 %v4599, 3
  store i64 %v4600, ptr %NEXT_PC, align 8
  %v4601 = load i64, ptr %RDI, align 8
  %v4602 = load ptr, ptr %MEMORY, align 8
  %v4603 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4602, ptr %state, ptr %RAX, i64 %v4601)
  store ptr %v4603, ptr %MEMORY, align 8
  %v4604 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4604, ptr %PC, align 8
  %v4605 = add i64 %v4604, 4
  store i64 %v4605, ptr %NEXT_PC, align 8
  %v4606 = load i64, ptr %RSP, align 8
  %v4607 = load ptr, ptr %MEMORY, align 8
  %v4608 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4607, ptr %state, ptr %RSP, i64 %v4606, i64 32)
  store ptr %v4608, ptr %MEMORY, align 8
  %v4609 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4609, ptr %PC, align 8
  %v4610 = add i64 %v4609, 1
  store i64 %v4610, ptr %NEXT_PC, align 8
  %v4611 = load ptr, ptr %MEMORY, align 8
  %v4612 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v4611, ptr %state, ptr %RDI)
  store ptr %v4612, ptr %MEMORY, align 8
  %v4613 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4613, ptr %PC, align 8
  %v4614 = add i64 %v4613, 1
  store i64 %v4614, ptr %NEXT_PC, align 8
  %v4615 = load ptr, ptr %MEMORY, align 8
  %v4616 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v4615, ptr %state, ptr %NEXT_PC)
  store ptr %v4616, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659767:                                    ; No predecessors!
  %v4617 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4617, ptr %PC, align 8
  %v4618 = add i64 %v4617, 1
  store i64 %v4618, ptr %NEXT_PC, align 8
  %v4619 = load ptr, ptr %MEMORY, align 8
  %v4620 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4619, ptr %state, ptr undef)
  store ptr %v4620, ptr %MEMORY, align 8
  %v4621 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4621, ptr %PC, align 8
  %v4622 = add i64 %v4621, 1
  store i64 %v4622, ptr %NEXT_PC, align 8
  %v4623 = load ptr, ptr %MEMORY, align 8
  %v4624 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4623, ptr %state, ptr undef)
  store ptr %v4624, ptr %MEMORY, align 8
  %v4625 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4625, ptr %PC, align 8
  %v4626 = add i64 %v4625, 1
  store i64 %v4626, ptr %NEXT_PC, align 8
  %v4627 = load ptr, ptr %MEMORY, align 8
  %v4628 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4627, ptr %state, ptr undef)
  store ptr %v4628, ptr %MEMORY, align 8
  %v4629 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4629, ptr %PC, align 8
  %v4630 = add i64 %v4629, 1
  store i64 %v4630, ptr %NEXT_PC, align 8
  %v4631 = load ptr, ptr %MEMORY, align 8
  %v4632 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4631, ptr %state, ptr undef)
  store ptr %v4632, ptr %MEMORY, align 8
  %v4633 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4633, ptr %PC, align 8
  %v4634 = add i64 %v4633, 1
  store i64 %v4634, ptr %NEXT_PC, align 8
  %v4635 = load ptr, ptr %MEMORY, align 8
  %v4636 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4635, ptr %state, ptr undef)
  store ptr %v4636, ptr %MEMORY, align 8
  %v4637 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4637, ptr %PC, align 8
  %v4638 = add i64 %v4637, 1
  store i64 %v4638, ptr %NEXT_PC, align 8
  %v4639 = load ptr, ptr %MEMORY, align 8
  %v4640 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4639, ptr %state, ptr undef)
  store ptr %v4640, ptr %MEMORY, align 8
  %v4641 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4641, ptr %PC, align 8
  %v4642 = add i64 %v4641, 1
  store i64 %v4642, ptr %NEXT_PC, align 8
  %v4643 = load ptr, ptr %MEMORY, align 8
  %v4644 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4643, ptr %state, ptr undef)
  store ptr %v4644, ptr %MEMORY, align 8
  %v4645 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4645, ptr %PC, align 8
  %v4646 = add i64 %v4645, 1
  store i64 %v4646, ptr %NEXT_PC, align 8
  %v4647 = load ptr, ptr %MEMORY, align 8
  %v4648 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4647, ptr %state, ptr undef)
  store ptr %v4648, ptr %MEMORY, align 8
  %v4649 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4649, ptr %PC, align 8
  %v4650 = add i64 %v4649, 1
  store i64 %v4650, ptr %NEXT_PC, align 8
  %v4651 = load ptr, ptr %MEMORY, align 8
  %v4652 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4651, ptr %state, ptr undef)
  store ptr %v4652, ptr %MEMORY, align 8
  %v4653 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4653, ptr %PC, align 8
  %v4654 = add i64 %v4653, 4
  store i64 %v4654, ptr %NEXT_PC, align 8
  %v4655 = load i64, ptr %RSP, align 8
  %v4656 = load ptr, ptr %MEMORY, align 8
  %v4657 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4656, ptr %state, ptr %RSP, i64 %v4655, i64 72)
  store ptr %v4657, ptr %MEMORY, align 8
  %v4658 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4658, ptr %PC, align 8
  %v4659 = add i64 %v4658, 5
  store i64 %v4659, ptr %NEXT_PC, align 8
  %v4660 = load i64, ptr %RSP, align 8
  %v4661 = add i64 %v4660, 104
  %v4662 = load ptr, ptr %MEMORY, align 8
  %v4663 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v4662, ptr %state, ptr %RAX, i64 %v4661)
  store ptr %v4663, ptr %MEMORY, align 8
  %v4664 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4664, ptr %PC, align 8
  %v4665 = add i64 %v4664, 3
  store i64 %v4665, ptr %NEXT_PC, align 8
  %v4666 = load i32, ptr %EDX, align 4
  %v4667 = zext i32 %v4666 to i64
  %v4668 = load ptr, ptr %MEMORY, align 8
  %v4669 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4668, ptr %state, ptr %R8, i64 %v4667)
  store ptr %v4669, ptr %MEMORY, align 8
  %v4670 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4670, ptr %PC, align 8
  %v4671 = add i64 %v4670, 5
  store i64 %v4671, ptr %NEXT_PC, align 8
  %v4672 = load i64, ptr %RSP, align 8
  %v4673 = add i64 %v4672, 96
  %v4674 = load ptr, ptr %MEMORY, align 8
  %v4675 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v4674, ptr %state, ptr %RDX, i64 %v4673)
  store ptr %v4675, ptr %MEMORY, align 8
  %v4676 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4676, ptr %PC, align 8
  %v4677 = add i64 %v4676, 5
  store i64 %v4677, ptr %NEXT_PC, align 8
  %v4678 = load i64, ptr %RSP, align 8
  %v4679 = add i64 %v4678, 32
  %v4680 = load i64, ptr %RAX, align 8
  %v4681 = load ptr, ptr %MEMORY, align 8
  %v4682 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4681, ptr %state, i64 %v4679, i64 %v4680)
  store ptr %v4682, ptr %MEMORY, align 8
  %v4683 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4683, ptr %PC, align 8
  %v4684 = add i64 %v4683, 5
  store i64 %v4684, ptr %NEXT_PC, align 8
  %v4685 = load i64, ptr %RSP, align 8
  %v4686 = add i64 %v4685, 48
  %v4687 = load ptr, ptr %MEMORY, align 8
  %v4688 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v4687, ptr %state, ptr %R9, i64 %v4686)
  store ptr %v4688, ptr %MEMORY, align 8
  %v4689 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4689, ptr %PC, align 8
  %v4690 = add i64 %v4689, 5
  store i64 %v4690, ptr %NEXT_PC, align 8
  %v4691 = load i64, ptr %NEXT_PC, align 8
  %v4692 = add i64 %v4691, 1872
  %v4693 = load i64, ptr %NEXT_PC, align 8
  %v4694 = load ptr, ptr %MEMORY, align 8
  %v4695 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v4694, ptr %state, i64 %v4692, ptr %NEXT_PC, i64 %v4693, ptr %RETURN_PC)
  store ptr %v4695, ptr %MEMORY, align 8
  %v4696 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4696, ptr %PC, align 8
  %v4697 = add i64 %v4696, 2
  store i64 %v4697, ptr %NEXT_PC, align 8
  %v4698 = load i64, ptr %RCX, align 8
  %v4699 = load i32, ptr %ECX, align 4
  %v4700 = zext i32 %v4699 to i64
  %v4701 = load ptr, ptr %MEMORY, align 8
  %v4702 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4701, ptr %state, ptr %RCX, i64 %v4698, i64 %v4700)
  store ptr %v4702, ptr %MEMORY, align 8
  %v4703 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4703, ptr %PC, align 8
  %v4704 = add i64 %v4703, 2
  store i64 %v4704, ptr %NEXT_PC, align 8
  %v4705 = load i64, ptr %RAX, align 8
  %v4706 = load i32, ptr %ECX, align 4
  %v4707 = zext i32 %v4706 to i64
  %v4708 = load ptr, ptr %MEMORY, align 8
  %v4709 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4708, ptr %state, i64 %v4705, i64 %v4707)
  store ptr %v4709, ptr %MEMORY, align 8
  %v4710 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4710, ptr %PC, align 8
  %v4711 = add i64 %v4710, 3
  store i64 %v4711, ptr %NEXT_PC, align 8
  %v4712 = load ptr, ptr %MEMORY, align 8
  %v4713 = call ptr @_ZN12_GLOBAL__N_14SETZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v4712, ptr %state, ptr %CL)
  store ptr %v4713, ptr %MEMORY, align 8
  %v4714 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4714, ptr %PC, align 8
  %v4715 = add i64 %v4714, 2
  store i64 %v4715, ptr %NEXT_PC, align 8
  %v4716 = load i32, ptr %ECX, align 4
  %v4717 = zext i32 %v4716 to i64
  %v4718 = load ptr, ptr %MEMORY, align 8
  %v4719 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4718, ptr %state, ptr %RAX, i64 %v4717)
  store ptr %v4719, ptr %MEMORY, align 8
  %v4720 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4720, ptr %PC, align 8
  %v4721 = add i64 %v4720, 4
  store i64 %v4721, ptr %NEXT_PC, align 8
  %v4722 = load i64, ptr %RSP, align 8
  %v4723 = load ptr, ptr %MEMORY, align 8
  %v4724 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4723, ptr %state, ptr %RSP, i64 %v4722, i64 72)
  store ptr %v4724, ptr %MEMORY, align 8
  %v4725 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4725, ptr %PC, align 8
  %v4726 = add i64 %v4725, 1
  store i64 %v4726, ptr %NEXT_PC, align 8
  %v4727 = load ptr, ptr %MEMORY, align 8
  %v4728 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v4727, ptr %state, ptr %NEXT_PC)
  store ptr %v4728, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659822:                                    ; No predecessors!
  %v4729 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4729, ptr %PC, align 8
  %v4730 = add i64 %v4729, 1
  store i64 %v4730, ptr %NEXT_PC, align 8
  %v4731 = load ptr, ptr %MEMORY, align 8
  %v4732 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4731, ptr %state, ptr undef)
  store ptr %v4732, ptr %MEMORY, align 8
  %v4733 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4733, ptr %PC, align 8
  %v4734 = add i64 %v4733, 1
  store i64 %v4734, ptr %NEXT_PC, align 8
  %v4735 = load ptr, ptr %MEMORY, align 8
  %v4736 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4735, ptr %state, ptr undef)
  store ptr %v4736, ptr %MEMORY, align 8
  %v4737 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4737, ptr %PC, align 8
  %v4738 = add i64 %v4737, 1
  store i64 %v4738, ptr %NEXT_PC, align 8
  %v4739 = load ptr, ptr %MEMORY, align 8
  %v4740 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4739, ptr %state, ptr undef)
  store ptr %v4740, ptr %MEMORY, align 8
  %v4741 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4741, ptr %PC, align 8
  %v4742 = add i64 %v4741, 1
  store i64 %v4742, ptr %NEXT_PC, align 8
  %v4743 = load ptr, ptr %MEMORY, align 8
  %v4744 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4743, ptr %state, ptr undef)
  store ptr %v4744, ptr %MEMORY, align 8
  %v4745 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4745, ptr %PC, align 8
  %v4746 = add i64 %v4745, 1
  store i64 %v4746, ptr %NEXT_PC, align 8
  %v4747 = load ptr, ptr %MEMORY, align 8
  %v4748 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4747, ptr %state, ptr undef)
  store ptr %v4748, ptr %MEMORY, align 8
  %v4749 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4749, ptr %PC, align 8
  %v4750 = add i64 %v4749, 1
  store i64 %v4750, ptr %NEXT_PC, align 8
  %v4751 = load ptr, ptr %MEMORY, align 8
  %v4752 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4751, ptr %state, ptr undef)
  store ptr %v4752, ptr %MEMORY, align 8
  %v4753 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4753, ptr %PC, align 8
  %v4754 = add i64 %v4753, 1
  store i64 %v4754, ptr %NEXT_PC, align 8
  %v4755 = load ptr, ptr %MEMORY, align 8
  %v4756 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4755, ptr %state, ptr undef)
  store ptr %v4756, ptr %MEMORY, align 8
  %v4757 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4757, ptr %PC, align 8
  %v4758 = add i64 %v4757, 1
  store i64 %v4758, ptr %NEXT_PC, align 8
  %v4759 = load ptr, ptr %MEMORY, align 8
  %v4760 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4759, ptr %state, ptr undef)
  store ptr %v4760, ptr %MEMORY, align 8
  %v4761 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4761, ptr %PC, align 8
  %v4762 = add i64 %v4761, 1
  store i64 %v4762, ptr %NEXT_PC, align 8
  %v4763 = load ptr, ptr %MEMORY, align 8
  %v4764 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4763, ptr %state, ptr undef)
  store ptr %v4764, ptr %MEMORY, align 8
  %v4765 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4765, ptr %PC, align 8
  %v4766 = add i64 %v4765, 1
  store i64 %v4766, ptr %NEXT_PC, align 8
  %v4767 = load ptr, ptr %MEMORY, align 8
  %v4768 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4767, ptr %state, ptr undef)
  store ptr %v4768, ptr %MEMORY, align 8
  %v4769 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4769, ptr %PC, align 8
  %v4770 = add i64 %v4769, 1
  store i64 %v4770, ptr %NEXT_PC, align 8
  %v4771 = load ptr, ptr %MEMORY, align 8
  %v4772 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4771, ptr %state, ptr undef)
  store ptr %v4772, ptr %MEMORY, align 8
  %v4773 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4773, ptr %PC, align 8
  %v4774 = add i64 %v4773, 1
  store i64 %v4774, ptr %NEXT_PC, align 8
  %v4775 = load ptr, ptr %MEMORY, align 8
  %v4776 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4775, ptr %state, ptr undef)
  store ptr %v4776, ptr %MEMORY, align 8
  %v4777 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4777, ptr %PC, align 8
  %v4778 = add i64 %v4777, 1
  store i64 %v4778, ptr %NEXT_PC, align 8
  %v4779 = load ptr, ptr %MEMORY, align 8
  %v4780 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4779, ptr %state, ptr undef)
  store ptr %v4780, ptr %MEMORY, align 8
  %v4781 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4781, ptr %PC, align 8
  %v4782 = add i64 %v4781, 1
  store i64 %v4782, ptr %NEXT_PC, align 8
  %v4783 = load ptr, ptr %MEMORY, align 8
  %v4784 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4783, ptr %state, ptr undef)
  store ptr %v4784, ptr %MEMORY, align 8
  %v4785 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4785, ptr %PC, align 8
  %v4786 = add i64 %v4785, 1
  store i64 %v4786, ptr %NEXT_PC, align 8
  %v4787 = load ptr, ptr %MEMORY, align 8
  %v4788 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4787, ptr %state, ptr undef)
  store ptr %v4788, ptr %MEMORY, align 8
  %v4789 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4789, ptr %PC, align 8
  %v4790 = add i64 %v4789, 1
  store i64 %v4790, ptr %NEXT_PC, align 8
  %v4791 = load ptr, ptr %MEMORY, align 8
  %v4792 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4791, ptr %state, ptr undef)
  store ptr %v4792, ptr %MEMORY, align 8
  %v4793 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4793, ptr %PC, align 8
  %v4794 = add i64 %v4793, 1
  store i64 %v4794, ptr %NEXT_PC, align 8
  %v4795 = load ptr, ptr %MEMORY, align 8
  %v4796 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4795, ptr %state, ptr undef)
  store ptr %v4796, ptr %MEMORY, align 8
  %v4797 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4797, ptr %PC, align 8
  %v4798 = add i64 %v4797, 1
  store i64 %v4798, ptr %NEXT_PC, align 8
  %v4799 = load ptr, ptr %MEMORY, align 8
  %v4800 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4799, ptr %state, ptr undef)
  store ptr %v4800, ptr %MEMORY, align 8
  %v4801 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4801, ptr %PC, align 8
  %v4802 = add i64 %v4801, 4
  store i64 %v4802, ptr %NEXT_PC, align 8
  %v4803 = load i64, ptr %RCX, align 8
  %v4804 = add i64 %v4803, 56
  %v4805 = load ptr, ptr %MEMORY, align 8
  %v4806 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4805, ptr %state, ptr %R8, i64 %v4804)
  store ptr %v4806, ptr %MEMORY, align 8
  %v4807 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4807, ptr %PC, align 8
  %v4808 = add i64 %v4807, 3
  store i64 %v4808, ptr %NEXT_PC, align 8
  %v4809 = load i64, ptr %R8, align 8
  %v4810 = load i64, ptr %R8, align 8
  %v4811 = load ptr, ptr %MEMORY, align 8
  %v4812 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4811, ptr %state, i64 %v4809, i64 %v4810)
  store ptr %v4812, ptr %MEMORY, align 8
  %v4813 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4813, ptr %PC, align 8
  %v4814 = add i64 %v4813, 2
  store i64 %v4814, ptr %NEXT_PC, align 8
  %v4815 = load i64, ptr %NEXT_PC, align 8
  %v4816 = add i64 %v4815, 30
  %v4817 = load i64, ptr %NEXT_PC, align 8
  %v4818 = load ptr, ptr %MEMORY, align 8
  %v4819 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4818, ptr %state, ptr %BRANCH_TAKEN, i64 %v4816, i64 %v4817, ptr %NEXT_PC)
  store ptr %v4819, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659879, label %bb_5395659849

bb_5395659849:                                    ; preds = %bb_5395659822
  %v4820 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4820, ptr %PC, align 8
  %v4821 = add i64 %v4820, 3
  store i64 %v4821, ptr %NEXT_PC, align 8
  %v4822 = load i32, ptr %EDX, align 4
  %v4823 = zext i32 %v4822 to i64
  %v4824 = load ptr, ptr %MEMORY, align 8
  %v4825 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v4824, ptr %state, ptr %RAX, i64 %v4823)
  store ptr %v4825, ptr %MEMORY, align 8
  %v4826 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4826, ptr %PC, align 8
  %v4827 = add i64 %v4826, 5
  store i64 %v4827, ptr %NEXT_PC, align 8
  %v4828 = load ptr, ptr %MEMORY, align 8
  %v4829 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4828, ptr %state, ptr %RDX, i64 2147483648)
  store ptr %v4829, ptr %MEMORY, align 8
  %v4830 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4830, ptr %PC, align 8
  %v4831 = add i64 %v4830, 4
  store i64 %v4831, ptr %NEXT_PC, align 8
  %v4832 = load i64, ptr %R8, align 8
  %v4833 = load i64, ptr %RAX, align 8
  %v4834 = mul i64 %v4833, 4
  %v4835 = add i64 %v4832, %v4834
  %v4836 = load ptr, ptr %MEMORY, align 8
  %v4837 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4836, ptr %state, ptr %RCX, i64 %v4835)
  store ptr %v4837, ptr %MEMORY, align 8
  %v4838 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4838, ptr %PC, align 8
  %v4839 = add i64 %v4838, 3
  store i64 %v4839, ptr %NEXT_PC, align 8
  %v4840 = load i64, ptr %RCX, align 8
  %v4841 = load i64, ptr %RDX, align 8
  %v4842 = mul i64 %v4841, 1
  %v4843 = add i64 %v4840, %v4842
  %v4844 = load ptr, ptr %MEMORY, align 8
  %v4845 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v4844, ptr %state, ptr %RAX, i64 %v4843)
  store ptr %v4845, ptr %MEMORY, align 8
  %v4846 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4846, ptr %PC, align 8
  %v4847 = add i64 %v4846, 2
  store i64 %v4847, ptr %NEXT_PC, align 8
  %v4848 = load i32, ptr %EDX, align 4
  %v4849 = zext i32 %v4848 to i64
  %v4850 = load i32, ptr %EAX, align 4
  %v4851 = zext i32 %v4850 to i64
  %v4852 = load ptr, ptr %MEMORY, align 8
  %v4853 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4852, ptr %state, i64 %v4849, i64 %v4851)
  store ptr %v4853, ptr %MEMORY, align 8
  %v4854 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4854, ptr %PC, align 8
  %v4855 = add i64 %v4854, 2
  store i64 %v4855, ptr %NEXT_PC, align 8
  %v4856 = load i64, ptr %NEXT_PC, align 8
  %v4857 = add i64 %v4856, 5
  %v4858 = load i64, ptr %NEXT_PC, align 8
  %v4859 = load ptr, ptr %MEMORY, align 8
  %v4860 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4859, ptr %state, ptr %BRANCH_TAKEN, i64 %v4857, i64 %v4858, ptr %NEXT_PC)
  store ptr %v4860, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659873, label %bb_5395659868

bb_5395659868:                                    ; preds = %bb_5395659849
  %v4861 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4861, ptr %PC, align 8
  %v4862 = add i64 %v4861, 3
  store i64 %v4862, ptr %NEXT_PC, align 8
  %v4863 = load i32, ptr %ECX, align 4
  %v4864 = zext i32 %v4863 to i64
  %v4865 = load ptr, ptr %MEMORY, align 8
  %v4866 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4865, ptr %state, i64 %v4864, i64 -2)
  store ptr %v4866, ptr %MEMORY, align 8
  %v4867 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4867, ptr %PC, align 8
  %v4868 = add i64 %v4867, 2
  store i64 %v4868, ptr %NEXT_PC, align 8
  %v4869 = load i64, ptr %NEXT_PC, align 8
  %v4870 = add i64 %v4869, 6
  %v4871 = load i64, ptr %NEXT_PC, align 8
  %v4872 = load ptr, ptr %MEMORY, align 8
  %v4873 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4872, ptr %state, ptr %BRANCH_TAKEN, i64 %v4870, i64 %v4871, ptr %NEXT_PC)
  store ptr %v4873, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659879, label %bb_5395659873

bb_5395659873:                                    ; preds = %bb_5395659868, %bb_5395659849
  %v4874 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4874, ptr %PC, align 8
  %v4875 = add i64 %v4874, 5
  store i64 %v4875, ptr %NEXT_PC, align 8
  %v4876 = load ptr, ptr %MEMORY, align 8
  %v4877 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4876, ptr %state, ptr %RAX, i64 1)
  store ptr %v4877, ptr %MEMORY, align 8
  %v4878 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4878, ptr %PC, align 8
  %v4879 = add i64 %v4878, 1
  store i64 %v4879, ptr %NEXT_PC, align 8
  %v4880 = load ptr, ptr %MEMORY, align 8
  %v4881 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v4880, ptr %state, ptr %NEXT_PC)
  store ptr %v4881, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659879:                                    ; preds = %bb_5395659868, %bb_5395659822
  %v4882 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4882, ptr %PC, align 8
  %v4883 = add i64 %v4882, 2
  store i64 %v4883, ptr %NEXT_PC, align 8
  %v4884 = load i64, ptr %RAX, align 8
  %v4885 = load i32, ptr %EAX, align 4
  %v4886 = zext i32 %v4885 to i64
  %v4887 = load ptr, ptr %MEMORY, align 8
  %v4888 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4887, ptr %state, ptr %RAX, i64 %v4884, i64 %v4886)
  store ptr %v4888, ptr %MEMORY, align 8
  %v4889 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4889, ptr %PC, align 8
  %v4890 = add i64 %v4889, 1
  store i64 %v4890, ptr %NEXT_PC, align 8
  %v4891 = load ptr, ptr %MEMORY, align 8
  %v4892 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v4891, ptr %state, ptr %NEXT_PC)
  store ptr %v4892, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659882:                                    ; No predecessors!
  %v4893 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4893, ptr %PC, align 8
  %v4894 = add i64 %v4893, 1
  store i64 %v4894, ptr %NEXT_PC, align 8
  %v4895 = load ptr, ptr %MEMORY, align 8
  %v4896 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4895, ptr %state, ptr undef)
  store ptr %v4896, ptr %MEMORY, align 8
  %v4897 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4897, ptr %PC, align 8
  %v4898 = add i64 %v4897, 1
  store i64 %v4898, ptr %NEXT_PC, align 8
  %v4899 = load ptr, ptr %MEMORY, align 8
  %v4900 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4899, ptr %state, ptr undef)
  store ptr %v4900, ptr %MEMORY, align 8
  %v4901 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4901, ptr %PC, align 8
  %v4902 = add i64 %v4901, 1
  store i64 %v4902, ptr %NEXT_PC, align 8
  %v4903 = load ptr, ptr %MEMORY, align 8
  %v4904 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4903, ptr %state, ptr undef)
  store ptr %v4904, ptr %MEMORY, align 8
  %v4905 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4905, ptr %PC, align 8
  %v4906 = add i64 %v4905, 1
  store i64 %v4906, ptr %NEXT_PC, align 8
  %v4907 = load ptr, ptr %MEMORY, align 8
  %v4908 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4907, ptr %state, ptr undef)
  store ptr %v4908, ptr %MEMORY, align 8
  %v4909 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4909, ptr %PC, align 8
  %v4910 = add i64 %v4909, 1
  store i64 %v4910, ptr %NEXT_PC, align 8
  %v4911 = load ptr, ptr %MEMORY, align 8
  %v4912 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4911, ptr %state, ptr undef)
  store ptr %v4912, ptr %MEMORY, align 8
  %v4913 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4913, ptr %PC, align 8
  %v4914 = add i64 %v4913, 1
  store i64 %v4914, ptr %NEXT_PC, align 8
  %v4915 = load ptr, ptr %MEMORY, align 8
  %v4916 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v4915, ptr %state, ptr undef)
  store ptr %v4916, ptr %MEMORY, align 8
  %v4917 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4917, ptr %PC, align 8
  %v4918 = add i64 %v4917, 5
  store i64 %v4918, ptr %NEXT_PC, align 8
  %v4919 = load i64, ptr %RSP, align 8
  %v4920 = add i64 %v4919, 24
  %v4921 = load i64, ptr %RSI, align 8
  %v4922 = load ptr, ptr %MEMORY, align 8
  %v4923 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4922, ptr %state, i64 %v4920, i64 %v4921)
  store ptr %v4923, ptr %MEMORY, align 8
  %v4924 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4924, ptr %PC, align 8
  %v4925 = add i64 %v4924, 1
  store i64 %v4925, ptr %NEXT_PC, align 8
  %v4926 = load i64, ptr %RDI, align 8
  %v4927 = load ptr, ptr %MEMORY, align 8
  %v4928 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v4927, ptr %state, i64 %v4926)
  store ptr %v4928, ptr %MEMORY, align 8
  %v4929 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4929, ptr %PC, align 8
  %v4930 = add i64 %v4929, 4
  store i64 %v4930, ptr %NEXT_PC, align 8
  %v4931 = load i64, ptr %RSP, align 8
  %v4932 = load ptr, ptr %MEMORY, align 8
  %v4933 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4932, ptr %state, ptr %RSP, i64 %v4931, i64 64)
  store ptr %v4933, ptr %MEMORY, align 8
  %v4934 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4934, ptr %PC, align 8
  %v4935 = add i64 %v4934, 2
  store i64 %v4935, ptr %NEXT_PC, align 8
  %v4936 = load i64, ptr %RAX, align 8
  %v4937 = load i32, ptr %EAX, align 4
  %v4938 = zext i32 %v4937 to i64
  %v4939 = load ptr, ptr %MEMORY, align 8
  %v4940 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4939, ptr %state, ptr %RAX, i64 %v4936, i64 %v4938)
  store ptr %v4940, ptr %MEMORY, align 8
  %v4941 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4941, ptr %PC, align 8
  %v4942 = add i64 %v4941, 3
  store i64 %v4942, ptr %NEXT_PC, align 8
  %v4943 = load i64, ptr %R9, align 8
  %v4944 = load ptr, ptr %MEMORY, align 8
  %v4945 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4944, ptr %state, ptr %RSI, i64 %v4943)
  store ptr %v4945, ptr %MEMORY, align 8
  %v4946 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4946, ptr %PC, align 8
  %v4947 = add i64 %v4946, 5
  store i64 %v4947, ptr %NEXT_PC, align 8
  %v4948 = load i64, ptr %RSP, align 8
  %v4949 = add i64 %v4948, 48
  %v4950 = load i64, ptr %RAX, align 8
  %v4951 = load ptr, ptr %MEMORY, align 8
  %v4952 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4951, ptr %state, i64 %v4949, i64 %v4950)
  store ptr %v4952, ptr %MEMORY, align 8
  %v4953 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4953, ptr %PC, align 8
  %v4954 = add i64 %v4953, 5
  store i64 %v4954, ptr %NEXT_PC, align 8
  %v4955 = load i64, ptr %RSP, align 8
  %v4956 = add i64 %v4955, 48
  %v4957 = load ptr, ptr %MEMORY, align 8
  %v4958 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v4957, ptr %state, ptr %R9, i64 %v4956)
  store ptr %v4958, ptr %MEMORY, align 8
  %v4959 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4959, ptr %PC, align 8
  %v4960 = add i64 %v4959, 5
  store i64 %v4960, ptr %NEXT_PC, align 8
  %v4961 = load i64, ptr %RSP, align 8
  %v4962 = add i64 %v4961, 88
  %v4963 = load i64, ptr %RAX, align 8
  %v4964 = load ptr, ptr %MEMORY, align 8
  %v4965 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4964, ptr %state, i64 %v4962, i64 %v4963)
  store ptr %v4965, ptr %MEMORY, align 8
  %v4966 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4966, ptr %PC, align 8
  %v4967 = add i64 %v4966, 3
  store i64 %v4967, ptr %NEXT_PC, align 8
  %v4968 = load i64, ptr %RDX, align 8
  %v4969 = load ptr, ptr %MEMORY, align 8
  %v4970 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4969, ptr %state, ptr %RDI, i64 %v4968)
  store ptr %v4970, ptr %MEMORY, align 8
  %v4971 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4971, ptr %PC, align 8
  %v4972 = add i64 %v4971, 5
  store i64 %v4972, ptr %NEXT_PC, align 8
  %v4973 = load i64, ptr %RSP, align 8
  %v4974 = add i64 %v4973, 88
  %v4975 = load ptr, ptr %MEMORY, align 8
  %v4976 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v4975, ptr %state, ptr %RAX, i64 %v4974)
  store ptr %v4976, ptr %MEMORY, align 8
  %v4977 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4977, ptr %PC, align 8
  %v4978 = add i64 %v4977, 5
  store i64 %v4978, ptr %NEXT_PC, align 8
  %v4979 = load i64, ptr %RSP, align 8
  %v4980 = add i64 %v4979, 32
  %v4981 = load i64, ptr %RAX, align 8
  %v4982 = load ptr, ptr %MEMORY, align 8
  %v4983 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4982, ptr %state, i64 %v4980, i64 %v4981)
  store ptr %v4983, ptr %MEMORY, align 8
  %v4984 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4984, ptr %PC, align 8
  %v4985 = add i64 %v4984, 5
  store i64 %v4985, ptr %NEXT_PC, align 8
  %v4986 = load i64, ptr %NEXT_PC, align 8
  %v4987 = add i64 %v4986, 1744
  %v4988 = load i64, ptr %NEXT_PC, align 8
  %v4989 = load ptr, ptr %MEMORY, align 8
  %v4990 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v4989, ptr %state, i64 %v4987, ptr %NEXT_PC, i64 %v4988, ptr %RETURN_PC)
  store ptr %v4990, ptr %MEMORY, align 8
  %v4991 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4991, ptr %PC, align 8
  %v4992 = add i64 %v4991, 3
  store i64 %v4992, ptr %NEXT_PC, align 8
  %v4993 = load i64, ptr %RDI, align 8
  %v4994 = load ptr, ptr %MEMORY, align 8
  %v4995 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4994, ptr %state, i64 %v4993, i64 0)
  store ptr %v4995, ptr %MEMORY, align 8
  %v4996 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4996, ptr %PC, align 8
  %v4997 = add i64 %v4996, 2
  store i64 %v4997, ptr %NEXT_PC, align 8
  %v4998 = load i64, ptr %NEXT_PC, align 8
  %v4999 = add i64 %v4998, 37
  %v5000 = load i64, ptr %NEXT_PC, align 8
  %v5001 = load ptr, ptr %MEMORY, align 8
  %v5002 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v5001, ptr %state, ptr %BRANCH_TAKEN, i64 %v4999, i64 %v5000, ptr %NEXT_PC)
  store ptr %v5002, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659978, label %bb_5395659941

bb_5395659941:                                    ; preds = %bb_5395659882
  %v5003 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5003, ptr %PC, align 8
  %v5004 = add i64 %v5003, 5
  store i64 %v5004, ptr %NEXT_PC, align 8
  %v5005 = load i64, ptr %RSP, align 8
  %v5006 = add i64 %v5005, 88
  %v5007 = load ptr, ptr %MEMORY, align 8
  %v5008 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v5007, ptr %state, ptr %RCX, i64 %v5006)
  store ptr %v5008, ptr %MEMORY, align 8
  %v5009 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5009, ptr %PC, align 8
  %v5010 = add i64 %v5009, 5
  store i64 %v5010, ptr %NEXT_PC, align 8
  %v5011 = load i64, ptr %RSP, align 8
  %v5012 = add i64 %v5011, 80
  %v5013 = load i64, ptr %RBX, align 8
  %v5014 = load ptr, ptr %MEMORY, align 8
  %v5015 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5014, ptr %state, i64 %v5012, i64 %v5013)
  store ptr %v5015, ptr %MEMORY, align 8
  %v5016 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5016, ptr %PC, align 8
  %v5017 = add i64 %v5016, 3
  store i64 %v5017, ptr %NEXT_PC, align 8
  %v5018 = load i64, ptr %RSI, align 8
  %v5019 = load ptr, ptr %MEMORY, align 8
  %v5020 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v5019, ptr %state, ptr %RBX, i64 %v5018)
  store ptr %v5020, ptr %MEMORY, align 8
  %v5021 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5021, ptr %PC, align 8
  %v5022 = add i64 %v5021, 5
  store i64 %v5022, ptr %NEXT_PC, align 8
  %v5023 = load i64, ptr %NEXT_PC, align 8
  %v5024 = add i64 %v5023, 126681
  %v5025 = load i64, ptr %NEXT_PC, align 8
  %v5026 = load ptr, ptr %MEMORY, align 8
  %v5027 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v5026, ptr %state, i64 %v5024, ptr %NEXT_PC, i64 %v5025, ptr %RETURN_PC)
  store ptr %v5027, ptr %MEMORY, align 8
  %v5028 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5028, ptr %PC, align 8
  %v5029 = add i64 %v5028, 5
  store i64 %v5029, ptr %NEXT_PC, align 8
  %v5030 = load i64, ptr %RSP, align 8
  %v5031 = add i64 %v5030, 48
  %v5032 = load ptr, ptr %MEMORY, align 8
  %v5033 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v5032, ptr %state, ptr %RDX, i64 %v5031)
  store ptr %v5033, ptr %MEMORY, align 8
  %v5034 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5034, ptr %PC, align 8
  %v5035 = add i64 %v5034, 3
  store i64 %v5035, ptr %NEXT_PC, align 8
  %v5036 = load i32, ptr %EAX, align 4
  %v5037 = zext i32 %v5036 to i64
  %v5038 = load ptr, ptr %MEMORY, align 8
  %v5039 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5038, ptr %state, ptr %R8, i64 %v5037)
  store ptr %v5039, ptr %MEMORY, align 8
  %v5040 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5040, ptr %PC, align 8
  %v5041 = add i64 %v5040, 3
  store i64 %v5041, ptr %NEXT_PC, align 8
  %v5042 = load i64, ptr %RSI, align 8
  %v5043 = load ptr, ptr %MEMORY, align 8
  %v5044 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5043, ptr %state, ptr %RCX, i64 %v5042)
  store ptr %v5044, ptr %MEMORY, align 8
  %v5045 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5045, ptr %PC, align 8
  %v5046 = add i64 %v5045, 3
  store i64 %v5046, ptr %NEXT_PC, align 8
  %v5047 = load i64, ptr %RBX, align 8
  %v5048 = add i64 %v5047, 40
  %v5049 = load i64, ptr %NEXT_PC, align 8
  %v5050 = load ptr, ptr %MEMORY, align 8
  %v5051 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v5050, ptr %state, i64 %v5048, ptr %NEXT_PC, i64 %v5049, ptr %RETURN_PC)
  store ptr %v5051, ptr %MEMORY, align 8
  %v5052 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5052, ptr %PC, align 8
  %v5053 = add i64 %v5052, 5
  store i64 %v5053, ptr %NEXT_PC, align 8
  %v5054 = load i64, ptr %RSP, align 8
  %v5055 = add i64 %v5054, 80
  %v5056 = load ptr, ptr %MEMORY, align 8
  %v5057 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v5056, ptr %state, ptr %RBX, i64 %v5055)
  store ptr %v5057, ptr %MEMORY, align 8
  br label %bb_5395659978

bb_5395659978:                                    ; preds = %bb_5395659941, %bb_5395659882
  %v5058 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5058, ptr %PC, align 8
  %v5059 = add i64 %v5058, 3
  store i64 %v5059, ptr %NEXT_PC, align 8
  %v5060 = load i64, ptr %RDI, align 8
  %v5061 = load ptr, ptr %MEMORY, align 8
  %v5062 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5061, ptr %state, ptr %RAX, i64 %v5060)
  store ptr %v5062, ptr %MEMORY, align 8
  %v5063 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5063, ptr %PC, align 8
  %v5064 = add i64 %v5063, 5
  store i64 %v5064, ptr %NEXT_PC, align 8
  %v5065 = load i64, ptr %RSP, align 8
  %v5066 = add i64 %v5065, 96
  %v5067 = load ptr, ptr %MEMORY, align 8
  %v5068 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v5067, ptr %state, ptr %RSI, i64 %v5066)
  store ptr %v5068, ptr %MEMORY, align 8
  %v5069 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5069, ptr %PC, align 8
  %v5070 = add i64 %v5069, 4
  store i64 %v5070, ptr %NEXT_PC, align 8
  %v5071 = load i64, ptr %RSP, align 8
  %v5072 = load ptr, ptr %MEMORY, align 8
  %v5073 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v5072, ptr %state, ptr %RSP, i64 %v5071, i64 64)
  store ptr %v5073, ptr %MEMORY, align 8
  %v5074 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5074, ptr %PC, align 8
  %v5075 = add i64 %v5074, 1
  store i64 %v5075, ptr %NEXT_PC, align 8
  %v5076 = load ptr, ptr %MEMORY, align 8
  %v5077 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v5076, ptr %state, ptr %RDI)
  store ptr %v5077, ptr %MEMORY, align 8
  %v5078 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5078, ptr %PC, align 8
  %v5079 = add i64 %v5078, 1
  store i64 %v5079, ptr %NEXT_PC, align 8
  %v5080 = load ptr, ptr %MEMORY, align 8
  %v5081 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v5080, ptr %state, ptr %NEXT_PC)
  store ptr %v5081, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659992:                                    ; No predecessors!
  %v5082 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5082, ptr %PC, align 8
  %v5083 = add i64 %v5082, 1
  store i64 %v5083, ptr %NEXT_PC, align 8
  %v5084 = load ptr, ptr %MEMORY, align 8
  %v5085 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5084, ptr %state, ptr undef)
  store ptr %v5085, ptr %MEMORY, align 8
  %v5086 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5086, ptr %PC, align 8
  %v5087 = add i64 %v5086, 1
  store i64 %v5087, ptr %NEXT_PC, align 8
  %v5088 = load ptr, ptr %MEMORY, align 8
  %v5089 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5088, ptr %state, ptr undef)
  store ptr %v5089, ptr %MEMORY, align 8
  %v5090 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5090, ptr %PC, align 8
  %v5091 = add i64 %v5090, 1
  store i64 %v5091, ptr %NEXT_PC, align 8
  %v5092 = load ptr, ptr %MEMORY, align 8
  %v5093 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5092, ptr %state, ptr undef)
  store ptr %v5093, ptr %MEMORY, align 8
  %v5094 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5094, ptr %PC, align 8
  %v5095 = add i64 %v5094, 1
  store i64 %v5095, ptr %NEXT_PC, align 8
  %v5096 = load ptr, ptr %MEMORY, align 8
  %v5097 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5096, ptr %state, ptr undef)
  store ptr %v5097, ptr %MEMORY, align 8
  %v5098 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5098, ptr %PC, align 8
  %v5099 = add i64 %v5098, 1
  store i64 %v5099, ptr %NEXT_PC, align 8
  %v5100 = load ptr, ptr %MEMORY, align 8
  %v5101 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5100, ptr %state, ptr undef)
  store ptr %v5101, ptr %MEMORY, align 8
  %v5102 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5102, ptr %PC, align 8
  %v5103 = add i64 %v5102, 1
  store i64 %v5103, ptr %NEXT_PC, align 8
  %v5104 = load ptr, ptr %MEMORY, align 8
  %v5105 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5104, ptr %state, ptr undef)
  store ptr %v5105, ptr %MEMORY, align 8
  %v5106 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5106, ptr %PC, align 8
  %v5107 = add i64 %v5106, 1
  store i64 %v5107, ptr %NEXT_PC, align 8
  %v5108 = load ptr, ptr %MEMORY, align 8
  %v5109 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5108, ptr %state, ptr undef)
  store ptr %v5109, ptr %MEMORY, align 8
  %v5110 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5110, ptr %PC, align 8
  %v5111 = add i64 %v5110, 1
  store i64 %v5111, ptr %NEXT_PC, align 8
  %v5112 = load ptr, ptr %MEMORY, align 8
  %v5113 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5112, ptr %state, ptr undef)
  store ptr %v5113, ptr %MEMORY, align 8
  %v5114 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5114, ptr %PC, align 8
  %v5115 = add i64 %v5114, 2
  store i64 %v5115, ptr %NEXT_PC, align 8
  %v5116 = load i64, ptr %RBX, align 8
  %v5117 = load ptr, ptr %MEMORY, align 8
  %v5118 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v5117, ptr %state, i64 %v5116)
  store ptr %v5118, ptr %MEMORY, align 8
  %v5119 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5119, ptr %PC, align 8
  %v5120 = add i64 %v5119, 4
  store i64 %v5120, ptr %NEXT_PC, align 8
  %v5121 = load i64, ptr %RSP, align 8
  %v5122 = load ptr, ptr %MEMORY, align 8
  %v5123 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v5122, ptr %state, ptr %RSP, i64 %v5121, i64 64)
  store ptr %v5123, ptr %MEMORY, align 8
  %v5124 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5124, ptr %PC, align 8
  %v5125 = add i64 %v5124, 5
  store i64 %v5125, ptr %NEXT_PC, align 8
  %v5126 = load i64, ptr %RSP, align 8
  %v5127 = add i64 %v5126, 48
  %v5128 = load ptr, ptr %MEMORY, align 8
  %v5129 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v5128, ptr %state, ptr %RAX, i64 %v5127)
  store ptr %v5129, ptr %MEMORY, align 8
  %v5130 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5130, ptr %PC, align 8
  %v5131 = add i64 %v5130, 3
  store i64 %v5131, ptr %NEXT_PC, align 8
  %v5132 = load i32, ptr %EDX, align 4
  %v5133 = zext i32 %v5132 to i64
  %v5134 = load ptr, ptr %MEMORY, align 8
  %v5135 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5134, ptr %state, ptr %R8, i64 %v5133)
  store ptr %v5135, ptr %MEMORY, align 8
  %v5136 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5136, ptr %PC, align 8
  %v5137 = add i64 %v5136, 2
  store i64 %v5137, ptr %NEXT_PC, align 8
  %v5138 = load i64, ptr %RBX, align 8
  %v5139 = load i32, ptr %EBX, align 4
  %v5140 = zext i32 %v5139 to i64
  %v5141 = load ptr, ptr %MEMORY, align 8
  %v5142 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v5141, ptr %state, ptr %RBX, i64 %v5138, i64 %v5140)
  store ptr %v5142, ptr %MEMORY, align 8
  %v5143 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5143, ptr %PC, align 8
  %v5144 = add i64 %v5143, 5
  store i64 %v5144, ptr %NEXT_PC, align 8
  %v5145 = load i64, ptr %RSP, align 8
  %v5146 = add i64 %v5145, 32
  %v5147 = load i64, ptr %RAX, align 8
  %v5148 = load ptr, ptr %MEMORY, align 8
  %v5149 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5148, ptr %state, i64 %v5146, i64 %v5147)
  store ptr %v5149, ptr %MEMORY, align 8
  %v5150 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5150, ptr %PC, align 8
  %v5151 = add i64 %v5150, 5
  store i64 %v5151, ptr %NEXT_PC, align 8
  %v5152 = load i64, ptr %RSP, align 8
  %v5153 = add i64 %v5152, 96
  %v5154 = load ptr, ptr %MEMORY, align 8
  %v5155 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v5154, ptr %state, ptr %RDX, i64 %v5153)
  store ptr %v5155, ptr %MEMORY, align 8
  %v5156 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5156, ptr %PC, align 8
  %v5157 = add i64 %v5156, 5
  store i64 %v5157, ptr %NEXT_PC, align 8
  %v5158 = load i64, ptr %RSP, align 8
  %v5159 = add i64 %v5158, 104
  %v5160 = load i64, ptr %RBX, align 8
  %v5161 = load ptr, ptr %MEMORY, align 8
  %v5162 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5161, ptr %state, i64 %v5159, i64 %v5160)
  store ptr %v5162, ptr %MEMORY, align 8
  %v5163 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5163, ptr %PC, align 8
  %v5164 = add i64 %v5163, 5
  store i64 %v5164, ptr %NEXT_PC, align 8
  %v5165 = load i64, ptr %RSP, align 8
  %v5166 = add i64 %v5165, 104
  %v5167 = load ptr, ptr %MEMORY, align 8
  %v5168 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v5167, ptr %state, ptr %R9, i64 %v5166)
  store ptr %v5168, ptr %MEMORY, align 8
  %v5169 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5169, ptr %PC, align 8
  %v5170 = add i64 %v5169, 5
  store i64 %v5170, ptr %NEXT_PC, align 8
  %v5171 = load i64, ptr %NEXT_PC, align 8
  %v5172 = add i64 %v5171, 1639
  %v5173 = load i64, ptr %NEXT_PC, align 8
  %v5174 = load ptr, ptr %MEMORY, align 8
  %v5175 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v5174, ptr %state, i64 %v5172, ptr %NEXT_PC, i64 %v5173, ptr %RETURN_PC)
  store ptr %v5175, ptr %MEMORY, align 8
  %v5176 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5176, ptr %PC, align 8
  %v5177 = add i64 %v5176, 4
  store i64 %v5177, ptr %NEXT_PC, align 8
  %v5178 = load i64, ptr %RSP, align 8
  %v5179 = add i64 %v5178, 96
  %v5180 = load i32, ptr %EBX, align 4
  %v5181 = zext i32 %v5180 to i64
  %v5182 = load ptr, ptr %MEMORY, align 8
  %v5183 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5182, ptr %state, i64 %v5179, i64 %v5181)
  store ptr %v5183, ptr %MEMORY, align 8
  %v5184 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5184, ptr %PC, align 8
  %v5185 = add i64 %v5184, 6
  store i64 %v5185, ptr %NEXT_PC, align 8
  %v5186 = load i64, ptr %RSP, align 8
  %v5187 = add i64 %v5186, 104
  %v5188 = load ptr, ptr %MEMORY, align 8
  %v5189 = call ptr @_ZN12_GLOBAL__N_15CMOVZI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v5188, ptr %state, ptr %RBX, i64 %v5187)
  store ptr %v5189, ptr %MEMORY, align 8
  %v5190 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5190, ptr %PC, align 8
  %v5191 = add i64 %v5190, 3
  store i64 %v5191, ptr %NEXT_PC, align 8
  %v5192 = load i64, ptr %RBX, align 8
  %v5193 = load ptr, ptr %MEMORY, align 8
  %v5194 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5193, ptr %state, ptr %RAX, i64 %v5192)
  store ptr %v5194, ptr %MEMORY, align 8
  %v5195 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5195, ptr %PC, align 8
  %v5196 = add i64 %v5195, 4
  store i64 %v5196, ptr %NEXT_PC, align 8
  %v5197 = load i64, ptr %RSP, align 8
  %v5198 = load ptr, ptr %MEMORY, align 8
  %v5199 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v5198, ptr %state, ptr %RSP, i64 %v5197, i64 64)
  store ptr %v5199, ptr %MEMORY, align 8
  %v5200 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5200, ptr %PC, align 8
  %v5201 = add i64 %v5200, 1
  store i64 %v5201, ptr %NEXT_PC, align 8
  %v5202 = load ptr, ptr %MEMORY, align 8
  %v5203 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v5202, ptr %state, ptr %RBX)
  store ptr %v5203, ptr %MEMORY, align 8
  %v5204 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5204, ptr %PC, align 8
  %v5205 = add i64 %v5204, 1
  store i64 %v5205, ptr %NEXT_PC, align 8
  %v5206 = load ptr, ptr %MEMORY, align 8
  %v5207 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v5206, ptr %state, ptr %NEXT_PC)
  store ptr %v5207, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395660060:                                    ; No predecessors!
  %v5208 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5208, ptr %PC, align 8
  %v5209 = add i64 %v5208, 1
  store i64 %v5209, ptr %NEXT_PC, align 8
  %v5210 = load ptr, ptr %MEMORY, align 8
  %v5211 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5210, ptr %state, ptr undef)
  store ptr %v5211, ptr %MEMORY, align 8
  %v5212 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5212, ptr %PC, align 8
  %v5213 = add i64 %v5212, 1
  store i64 %v5213, ptr %NEXT_PC, align 8
  %v5214 = load ptr, ptr %MEMORY, align 8
  %v5215 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5214, ptr %state, ptr undef)
  store ptr %v5215, ptr %MEMORY, align 8
  %v5216 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5216, ptr %PC, align 8
  %v5217 = add i64 %v5216, 1
  store i64 %v5217, ptr %NEXT_PC, align 8
  %v5218 = load ptr, ptr %MEMORY, align 8
  %v5219 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5218, ptr %state, ptr undef)
  store ptr %v5219, ptr %MEMORY, align 8
  %v5220 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5220, ptr %PC, align 8
  %v5221 = add i64 %v5220, 1
  store i64 %v5221, ptr %NEXT_PC, align 8
  %v5222 = load ptr, ptr %MEMORY, align 8
  %v5223 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5222, ptr %state, ptr undef)
  store ptr %v5223, ptr %MEMORY, align 8
  %v5224 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5224, ptr %PC, align 8
  %v5225 = add i64 %v5224, 1
  store i64 %v5225, ptr %NEXT_PC, align 8
  %v5226 = load ptr, ptr %MEMORY, align 8
  %v5227 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5226, ptr %state, ptr undef)
  store ptr %v5227, ptr %MEMORY, align 8
  %v5228 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5228, ptr %PC, align 8
  %v5229 = add i64 %v5228, 1
  store i64 %v5229, ptr %NEXT_PC, align 8
  %v5230 = load ptr, ptr %MEMORY, align 8
  %v5231 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5230, ptr %state, ptr undef)
  store ptr %v5231, ptr %MEMORY, align 8
  %v5232 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5232, ptr %PC, align 8
  %v5233 = add i64 %v5232, 1
  store i64 %v5233, ptr %NEXT_PC, align 8
  %v5234 = load ptr, ptr %MEMORY, align 8
  %v5235 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5234, ptr %state, ptr undef)
  store ptr %v5235, ptr %MEMORY, align 8
  %v5236 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5236, ptr %PC, align 8
  %v5237 = add i64 %v5236, 1
  store i64 %v5237, ptr %NEXT_PC, align 8
  %v5238 = load ptr, ptr %MEMORY, align 8
  %v5239 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5238, ptr %state, ptr undef)
  store ptr %v5239, ptr %MEMORY, align 8
  %v5240 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5240, ptr %PC, align 8
  %v5241 = add i64 %v5240, 1
  store i64 %v5241, ptr %NEXT_PC, align 8
  %v5242 = load ptr, ptr %MEMORY, align 8
  %v5243 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5242, ptr %state, ptr undef)
  store ptr %v5243, ptr %MEMORY, align 8
  %v5244 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5244, ptr %PC, align 8
  %v5245 = add i64 %v5244, 1
  store i64 %v5245, ptr %NEXT_PC, align 8
  %v5246 = load ptr, ptr %MEMORY, align 8
  %v5247 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5246, ptr %state, ptr undef)
  store ptr %v5247, ptr %MEMORY, align 8
  %v5248 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5248, ptr %PC, align 8
  %v5249 = add i64 %v5248, 1
  store i64 %v5249, ptr %NEXT_PC, align 8
  %v5250 = load ptr, ptr %MEMORY, align 8
  %v5251 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5250, ptr %state, ptr undef)
  store ptr %v5251, ptr %MEMORY, align 8
  %v5252 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5252, ptr %PC, align 8
  %v5253 = add i64 %v5252, 1
  store i64 %v5253, ptr %NEXT_PC, align 8
  %v5254 = load ptr, ptr %MEMORY, align 8
  %v5255 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5254, ptr %state, ptr undef)
  store ptr %v5255, ptr %MEMORY, align 8
  %v5256 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5256, ptr %PC, align 8
  %v5257 = add i64 %v5256, 1
  store i64 %v5257, ptr %NEXT_PC, align 8
  %v5258 = load ptr, ptr %MEMORY, align 8
  %v5259 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5258, ptr %state, ptr undef)
  store ptr %v5259, ptr %MEMORY, align 8
  %v5260 = load i64, ptr %NEXT_PC, align 8
  store i64 %v5260, ptr %PC, align 8
  %v5261 = add i64 %v5260, 1
  store i64 %v5261, ptr %NEXT_PC, align 8
  %v5262 = load ptr, ptr %MEMORY, align 8
  %v5263 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v5262, ptr %state, ptr undef)
  store ptr %v5263, ptr %MEMORY, align 8
  ret ptr %memory
}

attributes #0 = { noduplicate noinline nounwind optnone "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { alwaysinline mustprogress nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #3 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #5 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #6 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }

!llvm.ident = !{!0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3, !4}

!0 = !{!"clang version 18.1.8"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"base.helper.semantics"}
!6 = !{[3 x i8] c"CL\00"}
!7 = !{[4 x i8] c"ECX\00"}
!8 = !{[3 x i8] c"R9\00"}
!9 = !{[4 x i8] c"EBX\00"}
!10 = !{[4 x i8] c"EDI\00"}
!11 = !{[4 x i8] c"EDX\00"}
!12 = !{[4 x i8] c"RSI\00"}
!13 = !{[4 x i8] c"RBP\00"}
!14 = !{[4 x i8] c"RBX\00"}
!15 = !{[3 x i8] c"AL\00"}
!16 = !{[4 x i8] c"RDI\00"}
!17 = !{[4 x i8] c"R9D\00"}
!18 = !{[3 x i8] c"R8\00"}
!19 = !{[4 x i8] c"RDX\00"}
!20 = !{[4 x i8] c"EAX\00"}
!21 = !{[4 x i8] c"RCX\00"}
!22 = !{[4 x i8] c"RSP\00"}
!23 = !{[4 x i8] c"RAX\00"}
!24 = !{[3 x i8] c"PC\00"}
