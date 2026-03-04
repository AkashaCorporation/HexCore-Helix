; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: wwzRetailEgs.exe
; Address: 0x1419b3460
; Size: 2250 bytes
; Architecture: amd64
; Generated: 2026-03-04T21:41:52.852Z
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
  %1 = load i64, ptr %NEXT_PC, align 8
  store i64 %1, ptr %PC, align 8
  %2 = add i64 %1, 4
  store i64 %2, ptr %NEXT_PC, align 8
  %3 = load i64, ptr %RSP, align 8
  %4 = add i64 %3, 48
  %5 = load ptr, ptr %MEMORY, align 8
  %6 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %5, ptr %state, ptr %RAX, i64 %4)
  store ptr %6, ptr %MEMORY, align 8
  %7 = load i64, ptr %NEXT_PC, align 8
  store i64 %7, ptr %PC, align 8
  %8 = add i64 %7, 3
  store i64 %8, ptr %NEXT_PC, align 8
  %9 = load i64, ptr %RCX, align 8
  %10 = add i64 %9, 20
  %11 = load i32, ptr %EAX, align 4
  %12 = zext i32 %11 to i64
  %13 = load ptr, ptr %MEMORY, align 8
  %14 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %13, ptr %state, i64 %10, i64 %12)
  store ptr %14, ptr %MEMORY, align 8
  %15 = load i64, ptr %NEXT_PC, align 8
  store i64 %15, ptr %PC, align 8
  %16 = add i64 %15, 5
  store i64 %16, ptr %NEXT_PC, align 8
  %17 = load i64, ptr %RSP, align 8
  %18 = add i64 %17, 56
  %19 = load ptr, ptr %MEMORY, align 8
  %20 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %19, ptr %state, ptr %RAX, i64 %18)
  store ptr %20, ptr %MEMORY, align 8
  %21 = load i64, ptr %NEXT_PC, align 8
  store i64 %21, ptr %PC, align 8
  %22 = add i64 %21, 4
  store i64 %22, ptr %NEXT_PC, align 8
  %23 = load i64, ptr %RCX, align 8
  %24 = add i64 %23, 24
  %25 = load i64, ptr %RAX, align 8
  %26 = load ptr, ptr %MEMORY, align 8
  %27 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %26, ptr %state, i64 %24, i64 %25)
  store ptr %27, ptr %MEMORY, align 8
  %28 = load i64, ptr %NEXT_PC, align 8
  store i64 %28, ptr %PC, align 8
  %29 = add i64 %28, 4
  store i64 %29, ptr %NEXT_PC, align 8
  %30 = load i64, ptr %RSP, align 8
  %31 = add i64 %30, 64
  %32 = load ptr, ptr %MEMORY, align 8
  %33 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %32, ptr %state, ptr %RAX, i64 %31)
  store ptr %33, ptr %MEMORY, align 8
  %34 = load i64, ptr %NEXT_PC, align 8
  store i64 %34, ptr %PC, align 8
  %35 = add i64 %34, 3
  store i64 %35, ptr %NEXT_PC, align 8
  %36 = load i64, ptr %RCX, align 8
  %37 = add i64 %36, 32
  %38 = load i32, ptr %EAX, align 4
  %39 = zext i32 %38 to i64
  %40 = load ptr, ptr %MEMORY, align 8
  %41 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %40, ptr %state, i64 %37, i64 %39)
  store ptr %41, ptr %MEMORY, align 8
  %42 = load i64, ptr %NEXT_PC, align 8
  store i64 %42, ptr %PC, align 8
  %43 = add i64 %42, 5
  store i64 %43, ptr %NEXT_PC, align 8
  %44 = load i64, ptr %RSP, align 8
  %45 = add i64 %44, 72
  %46 = load ptr, ptr %MEMORY, align 8
  %47 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %46, ptr %state, ptr %RAX, i64 %45)
  store ptr %47, ptr %MEMORY, align 8
  %48 = load i64, ptr %NEXT_PC, align 8
  store i64 %48, ptr %PC, align 8
  %49 = add i64 %48, 4
  store i64 %49, ptr %NEXT_PC, align 8
  %50 = load i64, ptr %RCX, align 8
  %51 = add i64 %50, 40
  %52 = load i64, ptr %RAX, align 8
  %53 = load ptr, ptr %MEMORY, align 8
  %54 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %53, ptr %state, i64 %51, i64 %52)
  store ptr %54, ptr %MEMORY, align 8
  %55 = load i64, ptr %NEXT_PC, align 8
  store i64 %55, ptr %PC, align 8
  %56 = add i64 %55, 4
  store i64 %56, ptr %NEXT_PC, align 8
  %57 = load i64, ptr %RSP, align 8
  %58 = add i64 %57, 80
  %59 = load ptr, ptr %MEMORY, align 8
  %60 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %59, ptr %state, ptr %RAX, i64 %58)
  store ptr %60, ptr %MEMORY, align 8
  %61 = load i64, ptr %NEXT_PC, align 8
  store i64 %61, ptr %PC, align 8
  %62 = add i64 %61, 3
  store i64 %62, ptr %NEXT_PC, align 8
  %63 = load i64, ptr %RCX, align 8
  %64 = add i64 %63, 48
  %65 = load i32, ptr %EAX, align 4
  %66 = zext i32 %65 to i64
  %67 = load ptr, ptr %MEMORY, align 8
  %68 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %67, ptr %state, i64 %64, i64 %66)
  store ptr %68, ptr %MEMORY, align 8
  %69 = load i64, ptr %NEXT_PC, align 8
  store i64 %69, ptr %PC, align 8
  %70 = add i64 %69, 5
  store i64 %70, ptr %NEXT_PC, align 8
  %71 = load i64, ptr %RSP, align 8
  %72 = add i64 %71, 88
  %73 = load ptr, ptr %MEMORY, align 8
  %74 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %73, ptr %state, ptr %RAX, i64 %72)
  store ptr %74, ptr %MEMORY, align 8
  %75 = load i64, ptr %NEXT_PC, align 8
  store i64 %75, ptr %PC, align 8
  %76 = add i64 %75, 4
  store i64 %76, ptr %NEXT_PC, align 8
  %77 = load i64, ptr %RCX, align 8
  %78 = add i64 %77, 56
  %79 = load i64, ptr %RAX, align 8
  %80 = load ptr, ptr %MEMORY, align 8
  %81 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %80, ptr %state, i64 %78, i64 %79)
  store ptr %81, ptr %MEMORY, align 8
  %82 = load i64, ptr %NEXT_PC, align 8
  store i64 %82, ptr %PC, align 8
  %83 = add i64 %82, 5
  store i64 %83, ptr %NEXT_PC, align 8
  %84 = load i64, ptr %RSP, align 8
  %85 = add i64 %84, 96
  %86 = load ptr, ptr %MEMORY, align 8
  %87 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %86, ptr %state, ptr %RAX, i64 %85)
  store ptr %87, ptr %MEMORY, align 8
  %88 = load i64, ptr %NEXT_PC, align 8
  store i64 %88, ptr %PC, align 8
  %89 = add i64 %88, 4
  store i64 %89, ptr %NEXT_PC, align 8
  %90 = load i64, ptr %RCX, align 8
  %91 = add i64 %90, 64
  %92 = load i64, ptr %RAX, align 8
  %93 = load ptr, ptr %MEMORY, align 8
  %94 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %93, ptr %state, i64 %91, i64 %92)
  store ptr %94, ptr %MEMORY, align 8
  %95 = load i64, ptr %NEXT_PC, align 8
  store i64 %95, ptr %PC, align 8
  %96 = add i64 %95, 4
  store i64 %96, ptr %NEXT_PC, align 8
  %97 = load i64, ptr %RSP, align 8
  %98 = add i64 %97, 104
  %99 = load ptr, ptr %MEMORY, align 8
  %100 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %99, ptr %state, ptr %RAX, i64 %98)
  store ptr %100, ptr %MEMORY, align 8
  %101 = load i64, ptr %NEXT_PC, align 8
  store i64 %101, ptr %PC, align 8
  %102 = add i64 %101, 3
  store i64 %102, ptr %NEXT_PC, align 8
  %103 = load i64, ptr %RCX, align 8
  %104 = load i64, ptr %RDX, align 8
  %105 = load ptr, ptr %MEMORY, align 8
  %106 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %105, ptr %state, i64 %103, i64 %104)
  store ptr %106, ptr %MEMORY, align 8
  %107 = load i64, ptr %NEXT_PC, align 8
  store i64 %107, ptr %PC, align 8
  %108 = add i64 %107, 4
  store i64 %108, ptr %NEXT_PC, align 8
  %109 = load i64, ptr %RCX, align 8
  %110 = add i64 %109, 8
  %111 = load i64, ptr %R8, align 8
  %112 = load ptr, ptr %MEMORY, align 8
  %113 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %112, ptr %state, i64 %110, i64 %111)
  store ptr %113, ptr %MEMORY, align 8
  %114 = load i64, ptr %NEXT_PC, align 8
  store i64 %114, ptr %PC, align 8
  %115 = add i64 %114, 4
  store i64 %115, ptr %NEXT_PC, align 8
  %116 = load i64, ptr %RCX, align 8
  %117 = add i64 %116, 16
  %118 = load i32, ptr %R9D, align 4
  %119 = zext i32 %118 to i64
  %120 = load ptr, ptr %MEMORY, align 8
  %121 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %120, ptr %state, i64 %117, i64 %119)
  store ptr %121, ptr %MEMORY, align 8
  %122 = load i64, ptr %NEXT_PC, align 8
  store i64 %122, ptr %PC, align 8
  %123 = add i64 %122, 3
  store i64 %123, ptr %NEXT_PC, align 8
  %124 = load i64, ptr %RCX, align 8
  %125 = add i64 %124, 72
  %126 = load i32, ptr %EAX, align 4
  %127 = zext i32 %126 to i64
  %128 = load ptr, ptr %MEMORY, align 8
  %129 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %128, ptr %state, i64 %125, i64 %127)
  store ptr %129, ptr %MEMORY, align 8
  %130 = load i64, ptr %NEXT_PC, align 8
  store i64 %130, ptr %PC, align 8
  %131 = add i64 %130, 4
  store i64 %131, ptr %NEXT_PC, align 8
  %132 = load i64, ptr %RSP, align 8
  %133 = add i64 %132, 112
  %134 = load ptr, ptr %MEMORY, align 8
  %135 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %134, ptr %state, ptr %RAX, i64 %133)
  store ptr %135, ptr %MEMORY, align 8
  %136 = load i64, ptr %NEXT_PC, align 8
  store i64 %136, ptr %PC, align 8
  %137 = add i64 %136, 3
  store i64 %137, ptr %NEXT_PC, align 8
  %138 = load i64, ptr %RCX, align 8
  %139 = add i64 %138, 76
  %140 = load i32, ptr %EAX, align 4
  %141 = zext i32 %140 to i64
  %142 = load ptr, ptr %MEMORY, align 8
  %143 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %142, ptr %state, i64 %139, i64 %141)
  store ptr %143, ptr %MEMORY, align 8
  %144 = load i64, ptr %NEXT_PC, align 8
  store i64 %144, ptr %PC, align 8
  %145 = add i64 %144, 3
  store i64 %145, ptr %NEXT_PC, align 8
  %146 = load i64, ptr %RCX, align 8
  %147 = load ptr, ptr %MEMORY, align 8
  %148 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %147, ptr %state, ptr %RAX, i64 %146)
  store ptr %148, ptr %MEMORY, align 8
  %149 = load i64, ptr %NEXT_PC, align 8
  store i64 %149, ptr %PC, align 8
  %150 = add i64 %149, 1
  store i64 %150, ptr %NEXT_PC, align 8
  %151 = load ptr, ptr %MEMORY, align 8
  %152 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %151, ptr %state, ptr %NEXT_PC)
  store ptr %152, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395657910:                                    ; No predecessors!
  %153 = load i64, ptr %NEXT_PC, align 8
  store i64 %153, ptr %PC, align 8
  %154 = add i64 %153, 1
  store i64 %154, ptr %NEXT_PC, align 8
  %155 = load ptr, ptr %MEMORY, align 8
  %156 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %155, ptr %state, ptr undef)
  store ptr %156, ptr %MEMORY, align 8
  %157 = load i64, ptr %NEXT_PC, align 8
  store i64 %157, ptr %PC, align 8
  %158 = add i64 %157, 1
  store i64 %158, ptr %NEXT_PC, align 8
  %159 = load ptr, ptr %MEMORY, align 8
  %160 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %159, ptr %state, ptr undef)
  store ptr %160, ptr %MEMORY, align 8
  %161 = load i64, ptr %NEXT_PC, align 8
  store i64 %161, ptr %PC, align 8
  %162 = add i64 %161, 1
  store i64 %162, ptr %NEXT_PC, align 8
  %163 = load ptr, ptr %MEMORY, align 8
  %164 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %163, ptr %state, ptr undef)
  store ptr %164, ptr %MEMORY, align 8
  %165 = load i64, ptr %NEXT_PC, align 8
  store i64 %165, ptr %PC, align 8
  %166 = add i64 %165, 1
  store i64 %166, ptr %NEXT_PC, align 8
  %167 = load ptr, ptr %MEMORY, align 8
  %168 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %167, ptr %state, ptr undef)
  store ptr %168, ptr %MEMORY, align 8
  %169 = load i64, ptr %NEXT_PC, align 8
  store i64 %169, ptr %PC, align 8
  %170 = add i64 %169, 1
  store i64 %170, ptr %NEXT_PC, align 8
  %171 = load ptr, ptr %MEMORY, align 8
  %172 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %171, ptr %state, ptr undef)
  store ptr %172, ptr %MEMORY, align 8
  %173 = load i64, ptr %NEXT_PC, align 8
  store i64 %173, ptr %PC, align 8
  %174 = add i64 %173, 1
  store i64 %174, ptr %NEXT_PC, align 8
  %175 = load ptr, ptr %MEMORY, align 8
  %176 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %175, ptr %state, ptr undef)
  store ptr %176, ptr %MEMORY, align 8
  %177 = load i64, ptr %NEXT_PC, align 8
  store i64 %177, ptr %PC, align 8
  %178 = add i64 %177, 1
  store i64 %178, ptr %NEXT_PC, align 8
  %179 = load ptr, ptr %MEMORY, align 8
  %180 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %179, ptr %state, ptr undef)
  store ptr %180, ptr %MEMORY, align 8
  %181 = load i64, ptr %NEXT_PC, align 8
  store i64 %181, ptr %PC, align 8
  %182 = add i64 %181, 1
  store i64 %182, ptr %NEXT_PC, align 8
  %183 = load ptr, ptr %MEMORY, align 8
  %184 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %183, ptr %state, ptr undef)
  store ptr %184, ptr %MEMORY, align 8
  %185 = load i64, ptr %NEXT_PC, align 8
  store i64 %185, ptr %PC, align 8
  %186 = add i64 %185, 1
  store i64 %186, ptr %NEXT_PC, align 8
  %187 = load ptr, ptr %MEMORY, align 8
  %188 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %187, ptr %state, ptr undef)
  store ptr %188, ptr %MEMORY, align 8
  %189 = load i64, ptr %NEXT_PC, align 8
  store i64 %189, ptr %PC, align 8
  %190 = add i64 %189, 1
  store i64 %190, ptr %NEXT_PC, align 8
  %191 = load ptr, ptr %MEMORY, align 8
  %192 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %191, ptr %state, ptr undef)
  store ptr %192, ptr %MEMORY, align 8
  %193 = load i64, ptr %NEXT_PC, align 8
  store i64 %193, ptr %PC, align 8
  %194 = add i64 %193, 3
  store i64 %194, ptr %NEXT_PC, align 8
  %195 = load i64, ptr %RCX, align 8
  %196 = load ptr, ptr %MEMORY, align 8
  %197 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %196, ptr %state, ptr %RAX, i64 %195)
  store ptr %197, ptr %MEMORY, align 8
  %198 = load i64, ptr %NEXT_PC, align 8
  store i64 %198, ptr %PC, align 8
  %199 = add i64 %198, 1
  store i64 %199, ptr %NEXT_PC, align 8
  %200 = load ptr, ptr %MEMORY, align 8
  %201 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %200, ptr %state, ptr %NEXT_PC)
  store ptr %201, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395657924:                                    ; No predecessors!
  %202 = load i64, ptr %NEXT_PC, align 8
  store i64 %202, ptr %PC, align 8
  %203 = add i64 %202, 1
  store i64 %203, ptr %NEXT_PC, align 8
  %204 = load ptr, ptr %MEMORY, align 8
  %205 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %204, ptr %state, ptr undef)
  store ptr %205, ptr %MEMORY, align 8
  %206 = load i64, ptr %NEXT_PC, align 8
  store i64 %206, ptr %PC, align 8
  %207 = add i64 %206, 1
  store i64 %207, ptr %NEXT_PC, align 8
  %208 = load ptr, ptr %MEMORY, align 8
  %209 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %208, ptr %state, ptr undef)
  store ptr %209, ptr %MEMORY, align 8
  %210 = load i64, ptr %NEXT_PC, align 8
  store i64 %210, ptr %PC, align 8
  %211 = add i64 %210, 1
  store i64 %211, ptr %NEXT_PC, align 8
  %212 = load ptr, ptr %MEMORY, align 8
  %213 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %212, ptr %state, ptr undef)
  store ptr %213, ptr %MEMORY, align 8
  %214 = load i64, ptr %NEXT_PC, align 8
  store i64 %214, ptr %PC, align 8
  %215 = add i64 %214, 1
  store i64 %215, ptr %NEXT_PC, align 8
  %216 = load ptr, ptr %MEMORY, align 8
  %217 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %216, ptr %state, ptr undef)
  store ptr %217, ptr %MEMORY, align 8
  %218 = load i64, ptr %NEXT_PC, align 8
  store i64 %218, ptr %PC, align 8
  %219 = add i64 %218, 1
  store i64 %219, ptr %NEXT_PC, align 8
  %220 = load ptr, ptr %MEMORY, align 8
  %221 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %220, ptr %state, ptr undef)
  store ptr %221, ptr %MEMORY, align 8
  %222 = load i64, ptr %NEXT_PC, align 8
  store i64 %222, ptr %PC, align 8
  %223 = add i64 %222, 1
  store i64 %223, ptr %NEXT_PC, align 8
  %224 = load ptr, ptr %MEMORY, align 8
  %225 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %224, ptr %state, ptr undef)
  store ptr %225, ptr %MEMORY, align 8
  %226 = load i64, ptr %NEXT_PC, align 8
  store i64 %226, ptr %PC, align 8
  %227 = add i64 %226, 1
  store i64 %227, ptr %NEXT_PC, align 8
  %228 = load ptr, ptr %MEMORY, align 8
  %229 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %228, ptr %state, ptr undef)
  store ptr %229, ptr %MEMORY, align 8
  %230 = load i64, ptr %NEXT_PC, align 8
  store i64 %230, ptr %PC, align 8
  %231 = add i64 %230, 1
  store i64 %231, ptr %NEXT_PC, align 8
  %232 = load ptr, ptr %MEMORY, align 8
  %233 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %232, ptr %state, ptr undef)
  store ptr %233, ptr %MEMORY, align 8
  %234 = load i64, ptr %NEXT_PC, align 8
  store i64 %234, ptr %PC, align 8
  %235 = add i64 %234, 1
  store i64 %235, ptr %NEXT_PC, align 8
  %236 = load ptr, ptr %MEMORY, align 8
  %237 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %236, ptr %state, ptr undef)
  store ptr %237, ptr %MEMORY, align 8
  %238 = load i64, ptr %NEXT_PC, align 8
  store i64 %238, ptr %PC, align 8
  %239 = add i64 %238, 1
  store i64 %239, ptr %NEXT_PC, align 8
  %240 = load ptr, ptr %MEMORY, align 8
  %241 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %240, ptr %state, ptr undef)
  store ptr %241, ptr %MEMORY, align 8
  %242 = load i64, ptr %NEXT_PC, align 8
  store i64 %242, ptr %PC, align 8
  %243 = add i64 %242, 1
  store i64 %243, ptr %NEXT_PC, align 8
  %244 = load ptr, ptr %MEMORY, align 8
  %245 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %244, ptr %state, ptr undef)
  store ptr %245, ptr %MEMORY, align 8
  %246 = load i64, ptr %NEXT_PC, align 8
  store i64 %246, ptr %PC, align 8
  %247 = add i64 %246, 1
  store i64 %247, ptr %NEXT_PC, align 8
  %248 = load ptr, ptr %MEMORY, align 8
  %249 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %248, ptr %state, ptr undef)
  store ptr %249, ptr %MEMORY, align 8
  %250 = load i64, ptr %NEXT_PC, align 8
  store i64 %250, ptr %PC, align 8
  %251 = add i64 %250, 2
  store i64 %251, ptr %NEXT_PC, align 8
  %252 = load i64, ptr %RDI, align 8
  %253 = load ptr, ptr %MEMORY, align 8
  %254 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %253, ptr %state, i64 %252)
  store ptr %254, ptr %MEMORY, align 8
  %255 = load i64, ptr %NEXT_PC, align 8
  store i64 %255, ptr %PC, align 8
  %256 = add i64 %255, 4
  store i64 %256, ptr %NEXT_PC, align 8
  %257 = load i64, ptr %RSP, align 8
  %258 = load ptr, ptr %MEMORY, align 8
  %259 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %258, ptr %state, ptr %RSP, i64 %257, i64 32)
  store ptr %259, ptr %MEMORY, align 8
  %260 = load i64, ptr %NEXT_PC, align 8
  store i64 %260, ptr %PC, align 8
  %261 = add i64 %260, 3
  store i64 %261, ptr %NEXT_PC, align 8
  %262 = load i64, ptr %RCX, align 8
  %263 = load ptr, ptr %MEMORY, align 8
  %264 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %263, ptr %state, ptr %RDI, i64 %262)
  store ptr %264, ptr %MEMORY, align 8
  %265 = load i64, ptr %NEXT_PC, align 8
  store i64 %265, ptr %PC, align 8
  %266 = add i64 %265, 3
  store i64 %266, ptr %NEXT_PC, align 8
  %267 = load i64, ptr %RDX, align 8
  %268 = load i64, ptr %RDX, align 8
  %269 = load ptr, ptr %MEMORY, align 8
  %270 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %269, ptr %state, i64 %267, i64 %268)
  store ptr %270, ptr %MEMORY, align 8
  %271 = load i64, ptr %NEXT_PC, align 8
  store i64 %271, ptr %PC, align 8
  %272 = add i64 %271, 2
  store i64 %272, ptr %NEXT_PC, align 8
  %273 = load i64, ptr %NEXT_PC, align 8
  %274 = add i64 %273, 8
  %275 = load i64, ptr %NEXT_PC, align 8
  %276 = load ptr, ptr %MEMORY, align 8
  %277 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %276, ptr %state, ptr %BRANCH_TAKEN, i64 %274, i64 %275, ptr %NEXT_PC)
  store ptr %277, ptr %MEMORY, align 8
  br i1 true, label %bb_5395657958, label %bb_5395657950

bb_5395657950:                                    ; preds = %bb_5395657924
  %278 = load i64, ptr %NEXT_PC, align 8
  store i64 %278, ptr %PC, align 8
  %279 = add i64 %278, 2
  store i64 %279, ptr %NEXT_PC, align 8
  %280 = load i8, ptr %AL, align 1
  %281 = zext i8 %280 to i64
  %282 = load i8, ptr %AL, align 1
  %283 = zext i8 %282 to i64
  %284 = load ptr, ptr %MEMORY, align 8
  %285 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWIhE2RnIhLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %284, ptr %state, ptr %AL, i64 %281, i64 %283)
  store ptr %285, ptr %MEMORY, align 8
  %286 = load i64, ptr %NEXT_PC, align 8
  store i64 %286, ptr %PC, align 8
  %287 = add i64 %286, 4
  store i64 %287, ptr %NEXT_PC, align 8
  %288 = load i64, ptr %RSP, align 8
  %289 = load ptr, ptr %MEMORY, align 8
  %290 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %289, ptr %state, ptr %RSP, i64 %288, i64 32)
  store ptr %290, ptr %MEMORY, align 8
  %291 = load i64, ptr %NEXT_PC, align 8
  store i64 %291, ptr %PC, align 8
  %292 = add i64 %291, 1
  store i64 %292, ptr %NEXT_PC, align 8
  %293 = load ptr, ptr %MEMORY, align 8
  %294 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %293, ptr %state, ptr %RDI)
  store ptr %294, ptr %MEMORY, align 8
  %295 = load i64, ptr %NEXT_PC, align 8
  store i64 %295, ptr %PC, align 8
  %296 = add i64 %295, 1
  store i64 %296, ptr %NEXT_PC, align 8
  %297 = load ptr, ptr %MEMORY, align 8
  %298 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %297, ptr %state, ptr %NEXT_PC)
  store ptr %298, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395657958:                                    ; preds = %bb_5395657924
  %299 = load i64, ptr %NEXT_PC, align 8
  store i64 %299, ptr %PC, align 8
  %300 = add i64 %299, 3
  store i64 %300, ptr %NEXT_PC, align 8
  %301 = load i64, ptr %RDI, align 8
  %302 = load i64, ptr %RDX, align 8
  %303 = load ptr, ptr %MEMORY, align 8
  %304 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %303, ptr %state, i64 %301, i64 %302)
  store ptr %304, ptr %MEMORY, align 8
  %305 = load i64, ptr %NEXT_PC, align 8
  store i64 %305, ptr %PC, align 8
  %306 = add i64 %305, 2
  store i64 %306, ptr %NEXT_PC, align 8
  %307 = load i64, ptr %NEXT_PC, align 8
  %308 = add i64 %307, 52
  %309 = load i64, ptr %NEXT_PC, align 8
  %310 = load ptr, ptr %MEMORY, align 8
  %311 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %310, ptr %state, ptr %BRANCH_TAKEN, i64 %308, i64 %309, ptr %NEXT_PC)
  store ptr %311, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658015, label %bb_5395657963

bb_5395657963:                                    ; preds = %bb_5395657958
  %312 = load i64, ptr %NEXT_PC, align 8
  store i64 %312, ptr %PC, align 8
  %313 = add i64 %312, 3
  store i64 %313, ptr %NEXT_PC, align 8
  %314 = load i64, ptr %RDX, align 8
  %315 = load ptr, ptr %MEMORY, align 8
  %316 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %315, ptr %state, ptr %RCX, i64 %314)
  store ptr %316, ptr %MEMORY, align 8
  %317 = load i64, ptr %NEXT_PC, align 8
  store i64 %317, ptr %PC, align 8
  %318 = add i64 %317, 5
  store i64 %318, ptr %NEXT_PC, align 8
  %319 = load i64, ptr %RSP, align 8
  %320 = add i64 %319, 48
  %321 = load i64, ptr %RBX, align 8
  %322 = load ptr, ptr %MEMORY, align 8
  %323 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %322, ptr %state, i64 %320, i64 %321)
  store ptr %323, ptr %MEMORY, align 8
  %324 = load i64, ptr %NEXT_PC, align 8
  store i64 %324, ptr %PC, align 8
  %325 = add i64 %324, 5
  store i64 %325, ptr %NEXT_PC, align 8
  %326 = load i64, ptr %NEXT_PC, align 8
  %327 = sub i64 %326, 56
  %328 = load i64, ptr %NEXT_PC, align 8
  %329 = load ptr, ptr %MEMORY, align 8
  %330 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %329, ptr %state, i64 %327, ptr %NEXT_PC, i64 %328, ptr %RETURN_PC)
  store ptr %330, ptr %MEMORY, align 8
  %331 = load i64, ptr %NEXT_PC, align 8
  store i64 %331, ptr %PC, align 8
  %332 = add i64 %331, 3
  store i64 %332, ptr %NEXT_PC, align 8
  %333 = load i64, ptr %RDI, align 8
  %334 = load ptr, ptr %MEMORY, align 8
  %335 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %334, ptr %state, ptr %RCX, i64 %333)
  store ptr %335, ptr %MEMORY, align 8
  %336 = load i64, ptr %NEXT_PC, align 8
  store i64 %336, ptr %PC, align 8
  %337 = add i64 %336, 3
  store i64 %337, ptr %NEXT_PC, align 8
  %338 = load i64, ptr %RAX, align 8
  %339 = load ptr, ptr %MEMORY, align 8
  %340 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %339, ptr %state, ptr %RBX, i64 %338)
  store ptr %340, ptr %MEMORY, align 8
  %341 = load i64, ptr %NEXT_PC, align 8
  store i64 %341, ptr %PC, align 8
  %342 = add i64 %341, 5
  store i64 %342, ptr %NEXT_PC, align 8
  %343 = load i64, ptr %NEXT_PC, align 8
  %344 = sub i64 %343, 67
  %345 = load i64, ptr %NEXT_PC, align 8
  %346 = load ptr, ptr %MEMORY, align 8
  %347 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %346, ptr %state, i64 %344, ptr %NEXT_PC, i64 %345, ptr %RETURN_PC)
  store ptr %347, ptr %MEMORY, align 8
  %348 = load i64, ptr %NEXT_PC, align 8
  store i64 %348, ptr %PC, align 8
  %349 = add i64 %348, 3
  store i64 %349, ptr %NEXT_PC, align 8
  %350 = load i64, ptr %RAX, align 8
  %351 = load ptr, ptr %MEMORY, align 8
  %352 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %351, ptr %state, ptr %RCX, i64 %350)
  store ptr %352, ptr %MEMORY, align 8
  %353 = load i64, ptr %NEXT_PC, align 8
  store i64 %353, ptr %PC, align 8
  %354 = add i64 %353, 3
  store i64 %354, ptr %NEXT_PC, align 8
  %355 = load i64, ptr %RBX, align 8
  %356 = load ptr, ptr %MEMORY, align 8
  %357 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %356, ptr %state, ptr %RDX, i64 %355)
  store ptr %357, ptr %MEMORY, align 8
  %358 = load i64, ptr %NEXT_PC, align 8
  store i64 %358, ptr %PC, align 8
  %359 = add i64 %358, 5
  store i64 %359, ptr %NEXT_PC, align 8
  %360 = load i64, ptr %NEXT_PC, align 8
  %361 = add i64 %360, 46322
  %362 = load i64, ptr %NEXT_PC, align 8
  %363 = load ptr, ptr %MEMORY, align 8
  %364 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %363, ptr %state, i64 %361, ptr %NEXT_PC, i64 %362, ptr %RETURN_PC)
  store ptr %364, ptr %MEMORY, align 8
  %365 = load i64, ptr %NEXT_PC, align 8
  store i64 %365, ptr %PC, align 8
  %366 = add i64 %365, 5
  store i64 %366, ptr %NEXT_PC, align 8
  %367 = load i64, ptr %RSP, align 8
  %368 = add i64 %367, 48
  %369 = load ptr, ptr %MEMORY, align 8
  %370 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %369, ptr %state, ptr %RBX, i64 %368)
  store ptr %370, ptr %MEMORY, align 8
  %371 = load i64, ptr %NEXT_PC, align 8
  store i64 %371, ptr %PC, align 8
  %372 = add i64 %371, 2
  store i64 %372, ptr %NEXT_PC, align 8
  %373 = load i32, ptr %EAX, align 4
  %374 = zext i32 %373 to i64
  %375 = load i32, ptr %EAX, align 4
  %376 = zext i32 %375 to i64
  %377 = load ptr, ptr %MEMORY, align 8
  %378 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %377, ptr %state, i64 %374, i64 %376)
  store ptr %378, ptr %MEMORY, align 8
  %379 = load i64, ptr %NEXT_PC, align 8
  store i64 %379, ptr %PC, align 8
  %380 = add i64 %379, 2
  store i64 %380, ptr %NEXT_PC, align 8
  %381 = load i64, ptr %NEXT_PC, align 8
  %382 = add i64 %381, 8
  %383 = load i64, ptr %NEXT_PC, align 8
  %384 = load ptr, ptr %MEMORY, align 8
  %385 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %384, ptr %state, ptr %BRANCH_TAKEN, i64 %382, i64 %383, ptr %NEXT_PC)
  store ptr %385, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658015, label %bb_5395658007

bb_5395658007:                                    ; preds = %bb_5395657963
  %386 = load i64, ptr %NEXT_PC, align 8
  store i64 %386, ptr %PC, align 8
  %387 = add i64 %386, 2
  store i64 %387, ptr %NEXT_PC, align 8
  %388 = load i64, ptr %RAX, align 8
  %389 = load i32, ptr %EAX, align 4
  %390 = zext i32 %389 to i64
  %391 = load ptr, ptr %MEMORY, align 8
  %392 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %391, ptr %state, ptr %RAX, i64 %388, i64 %390)
  store ptr %392, ptr %MEMORY, align 8
  %393 = load i64, ptr %NEXT_PC, align 8
  store i64 %393, ptr %PC, align 8
  %394 = add i64 %393, 4
  store i64 %394, ptr %NEXT_PC, align 8
  %395 = load i64, ptr %RSP, align 8
  %396 = load ptr, ptr %MEMORY, align 8
  %397 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %396, ptr %state, ptr %RSP, i64 %395, i64 32)
  store ptr %397, ptr %MEMORY, align 8
  %398 = load i64, ptr %NEXT_PC, align 8
  store i64 %398, ptr %PC, align 8
  %399 = add i64 %398, 1
  store i64 %399, ptr %NEXT_PC, align 8
  %400 = load ptr, ptr %MEMORY, align 8
  %401 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %400, ptr %state, ptr %RDI)
  store ptr %401, ptr %MEMORY, align 8
  %402 = load i64, ptr %NEXT_PC, align 8
  store i64 %402, ptr %PC, align 8
  %403 = add i64 %402, 1
  store i64 %403, ptr %NEXT_PC, align 8
  %404 = load ptr, ptr %MEMORY, align 8
  %405 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %404, ptr %state, ptr %NEXT_PC)
  store ptr %405, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658015:                                    ; preds = %bb_5395657963, %bb_5395657958
  %406 = load i64, ptr %NEXT_PC, align 8
  store i64 %406, ptr %PC, align 8
  %407 = add i64 %406, 5
  store i64 %407, ptr %NEXT_PC, align 8
  %408 = load ptr, ptr %MEMORY, align 8
  %409 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %408, ptr %state, ptr %RAX, i64 1)
  store ptr %409, ptr %MEMORY, align 8
  %410 = load i64, ptr %NEXT_PC, align 8
  store i64 %410, ptr %PC, align 8
  %411 = add i64 %410, 4
  store i64 %411, ptr %NEXT_PC, align 8
  %412 = load i64, ptr %RSP, align 8
  %413 = load ptr, ptr %MEMORY, align 8
  %414 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %413, ptr %state, ptr %RSP, i64 %412, i64 32)
  store ptr %414, ptr %MEMORY, align 8
  %415 = load i64, ptr %NEXT_PC, align 8
  store i64 %415, ptr %PC, align 8
  %416 = add i64 %415, 1
  store i64 %416, ptr %NEXT_PC, align 8
  %417 = load ptr, ptr %MEMORY, align 8
  %418 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %417, ptr %state, ptr %RDI)
  store ptr %418, ptr %MEMORY, align 8
  %419 = load i64, ptr %NEXT_PC, align 8
  store i64 %419, ptr %PC, align 8
  %420 = add i64 %419, 1
  store i64 %420, ptr %NEXT_PC, align 8
  %421 = load ptr, ptr %MEMORY, align 8
  %422 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %421, ptr %state, ptr %NEXT_PC)
  store ptr %422, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658026:                                    ; No predecessors!
  %423 = load i64, ptr %NEXT_PC, align 8
  store i64 %423, ptr %PC, align 8
  %424 = add i64 %423, 1
  store i64 %424, ptr %NEXT_PC, align 8
  %425 = load ptr, ptr %MEMORY, align 8
  %426 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %425, ptr %state, ptr undef)
  store ptr %426, ptr %MEMORY, align 8
  %427 = load i64, ptr %NEXT_PC, align 8
  store i64 %427, ptr %PC, align 8
  %428 = add i64 %427, 1
  store i64 %428, ptr %NEXT_PC, align 8
  %429 = load ptr, ptr %MEMORY, align 8
  %430 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %429, ptr %state, ptr undef)
  store ptr %430, ptr %MEMORY, align 8
  %431 = load i64, ptr %NEXT_PC, align 8
  store i64 %431, ptr %PC, align 8
  %432 = add i64 %431, 1
  store i64 %432, ptr %NEXT_PC, align 8
  %433 = load ptr, ptr %MEMORY, align 8
  %434 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %433, ptr %state, ptr undef)
  store ptr %434, ptr %MEMORY, align 8
  %435 = load i64, ptr %NEXT_PC, align 8
  store i64 %435, ptr %PC, align 8
  %436 = add i64 %435, 1
  store i64 %436, ptr %NEXT_PC, align 8
  %437 = load ptr, ptr %MEMORY, align 8
  %438 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %437, ptr %state, ptr undef)
  store ptr %438, ptr %MEMORY, align 8
  %439 = load i64, ptr %NEXT_PC, align 8
  store i64 %439, ptr %PC, align 8
  %440 = add i64 %439, 1
  store i64 %440, ptr %NEXT_PC, align 8
  %441 = load ptr, ptr %MEMORY, align 8
  %442 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %441, ptr %state, ptr undef)
  store ptr %442, ptr %MEMORY, align 8
  %443 = load i64, ptr %NEXT_PC, align 8
  store i64 %443, ptr %PC, align 8
  %444 = add i64 %443, 1
  store i64 %444, ptr %NEXT_PC, align 8
  %445 = load ptr, ptr %MEMORY, align 8
  %446 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %445, ptr %state, ptr undef)
  store ptr %446, ptr %MEMORY, align 8
  %447 = load i64, ptr %NEXT_PC, align 8
  store i64 %447, ptr %PC, align 8
  %448 = add i64 %447, 4
  store i64 %448, ptr %NEXT_PC, align 8
  %449 = load i64, ptr %RCX, align 8
  %450 = add i64 %449, 8
  %451 = load ptr, ptr %MEMORY, align 8
  %452 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %451, ptr %state, ptr %RAX, i64 %450)
  store ptr %452, ptr %MEMORY, align 8
  %453 = load i64, ptr %NEXT_PC, align 8
  store i64 %453, ptr %PC, align 8
  %454 = add i64 %453, 1
  store i64 %454, ptr %NEXT_PC, align 8
  %455 = load ptr, ptr %MEMORY, align 8
  %456 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %455, ptr %state, ptr %NEXT_PC)
  store ptr %456, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658037:                                    ; No predecessors!
  %457 = load i64, ptr %NEXT_PC, align 8
  store i64 %457, ptr %PC, align 8
  %458 = add i64 %457, 1
  store i64 %458, ptr %NEXT_PC, align 8
  %459 = load ptr, ptr %MEMORY, align 8
  %460 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %459, ptr %state, ptr undef)
  store ptr %460, ptr %MEMORY, align 8
  %461 = load i64, ptr %NEXT_PC, align 8
  store i64 %461, ptr %PC, align 8
  %462 = add i64 %461, 1
  store i64 %462, ptr %NEXT_PC, align 8
  %463 = load ptr, ptr %MEMORY, align 8
  %464 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %463, ptr %state, ptr undef)
  store ptr %464, ptr %MEMORY, align 8
  %465 = load i64, ptr %NEXT_PC, align 8
  store i64 %465, ptr %PC, align 8
  %466 = add i64 %465, 1
  store i64 %466, ptr %NEXT_PC, align 8
  %467 = load ptr, ptr %MEMORY, align 8
  %468 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %467, ptr %state, ptr undef)
  store ptr %468, ptr %MEMORY, align 8
  %469 = load i64, ptr %NEXT_PC, align 8
  store i64 %469, ptr %PC, align 8
  %470 = add i64 %469, 1
  store i64 %470, ptr %NEXT_PC, align 8
  %471 = load ptr, ptr %MEMORY, align 8
  %472 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %471, ptr %state, ptr undef)
  store ptr %472, ptr %MEMORY, align 8
  %473 = load i64, ptr %NEXT_PC, align 8
  store i64 %473, ptr %PC, align 8
  %474 = add i64 %473, 1
  store i64 %474, ptr %NEXT_PC, align 8
  %475 = load ptr, ptr %MEMORY, align 8
  %476 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %475, ptr %state, ptr undef)
  store ptr %476, ptr %MEMORY, align 8
  %477 = load i64, ptr %NEXT_PC, align 8
  store i64 %477, ptr %PC, align 8
  %478 = add i64 %477, 1
  store i64 %478, ptr %NEXT_PC, align 8
  %479 = load ptr, ptr %MEMORY, align 8
  %480 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %479, ptr %state, ptr undef)
  store ptr %480, ptr %MEMORY, align 8
  %481 = load i64, ptr %NEXT_PC, align 8
  store i64 %481, ptr %PC, align 8
  %482 = add i64 %481, 1
  store i64 %482, ptr %NEXT_PC, align 8
  %483 = load ptr, ptr %MEMORY, align 8
  %484 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %483, ptr %state, ptr undef)
  store ptr %484, ptr %MEMORY, align 8
  %485 = load i64, ptr %NEXT_PC, align 8
  store i64 %485, ptr %PC, align 8
  %486 = add i64 %485, 1
  store i64 %486, ptr %NEXT_PC, align 8
  %487 = load ptr, ptr %MEMORY, align 8
  %488 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %487, ptr %state, ptr undef)
  store ptr %488, ptr %MEMORY, align 8
  %489 = load i64, ptr %NEXT_PC, align 8
  store i64 %489, ptr %PC, align 8
  %490 = add i64 %489, 1
  store i64 %490, ptr %NEXT_PC, align 8
  %491 = load ptr, ptr %MEMORY, align 8
  %492 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %491, ptr %state, ptr undef)
  store ptr %492, ptr %MEMORY, align 8
  %493 = load i64, ptr %NEXT_PC, align 8
  store i64 %493, ptr %PC, align 8
  %494 = add i64 %493, 1
  store i64 %494, ptr %NEXT_PC, align 8
  %495 = load ptr, ptr %MEMORY, align 8
  %496 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %495, ptr %state, ptr undef)
  store ptr %496, ptr %MEMORY, align 8
  %497 = load i64, ptr %NEXT_PC, align 8
  store i64 %497, ptr %PC, align 8
  %498 = add i64 %497, 1
  store i64 %498, ptr %NEXT_PC, align 8
  %499 = load ptr, ptr %MEMORY, align 8
  %500 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %499, ptr %state, ptr undef)
  store ptr %500, ptr %MEMORY, align 8
  %501 = load i64, ptr %NEXT_PC, align 8
  store i64 %501, ptr %PC, align 8
  %502 = add i64 %501, 4
  store i64 %502, ptr %NEXT_PC, align 8
  %503 = load i64, ptr %RCX, align 8
  %504 = add i64 %503, 8
  %505 = load ptr, ptr %MEMORY, align 8
  %506 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %505, ptr %state, ptr %RAX, i64 %504)
  store ptr %506, ptr %MEMORY, align 8
  %507 = load i64, ptr %NEXT_PC, align 8
  store i64 %507, ptr %PC, align 8
  %508 = add i64 %507, 1
  store i64 %508, ptr %NEXT_PC, align 8
  %509 = load ptr, ptr %MEMORY, align 8
  %510 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %509, ptr %state, ptr %NEXT_PC)
  store ptr %510, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658053:                                    ; No predecessors!
  %511 = load i64, ptr %NEXT_PC, align 8
  store i64 %511, ptr %PC, align 8
  %512 = add i64 %511, 1
  store i64 %512, ptr %NEXT_PC, align 8
  %513 = load ptr, ptr %MEMORY, align 8
  %514 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %513, ptr %state, ptr undef)
  store ptr %514, ptr %MEMORY, align 8
  %515 = load i64, ptr %NEXT_PC, align 8
  store i64 %515, ptr %PC, align 8
  %516 = add i64 %515, 1
  store i64 %516, ptr %NEXT_PC, align 8
  %517 = load ptr, ptr %MEMORY, align 8
  %518 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %517, ptr %state, ptr undef)
  store ptr %518, ptr %MEMORY, align 8
  %519 = load i64, ptr %NEXT_PC, align 8
  store i64 %519, ptr %PC, align 8
  %520 = add i64 %519, 1
  store i64 %520, ptr %NEXT_PC, align 8
  %521 = load ptr, ptr %MEMORY, align 8
  %522 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %521, ptr %state, ptr undef)
  store ptr %522, ptr %MEMORY, align 8
  %523 = load i64, ptr %NEXT_PC, align 8
  store i64 %523, ptr %PC, align 8
  %524 = add i64 %523, 1
  store i64 %524, ptr %NEXT_PC, align 8
  %525 = load ptr, ptr %MEMORY, align 8
  %526 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %525, ptr %state, ptr undef)
  store ptr %526, ptr %MEMORY, align 8
  %527 = load i64, ptr %NEXT_PC, align 8
  store i64 %527, ptr %PC, align 8
  %528 = add i64 %527, 1
  store i64 %528, ptr %NEXT_PC, align 8
  %529 = load ptr, ptr %MEMORY, align 8
  %530 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %529, ptr %state, ptr undef)
  store ptr %530, ptr %MEMORY, align 8
  %531 = load i64, ptr %NEXT_PC, align 8
  store i64 %531, ptr %PC, align 8
  %532 = add i64 %531, 1
  store i64 %532, ptr %NEXT_PC, align 8
  %533 = load ptr, ptr %MEMORY, align 8
  %534 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %533, ptr %state, ptr undef)
  store ptr %534, ptr %MEMORY, align 8
  %535 = load i64, ptr %NEXT_PC, align 8
  store i64 %535, ptr %PC, align 8
  %536 = add i64 %535, 1
  store i64 %536, ptr %NEXT_PC, align 8
  %537 = load ptr, ptr %MEMORY, align 8
  %538 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %537, ptr %state, ptr undef)
  store ptr %538, ptr %MEMORY, align 8
  %539 = load i64, ptr %NEXT_PC, align 8
  store i64 %539, ptr %PC, align 8
  %540 = add i64 %539, 1
  store i64 %540, ptr %NEXT_PC, align 8
  %541 = load ptr, ptr %MEMORY, align 8
  %542 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %541, ptr %state, ptr undef)
  store ptr %542, ptr %MEMORY, align 8
  %543 = load i64, ptr %NEXT_PC, align 8
  store i64 %543, ptr %PC, align 8
  %544 = add i64 %543, 1
  store i64 %544, ptr %NEXT_PC, align 8
  %545 = load ptr, ptr %MEMORY, align 8
  %546 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %545, ptr %state, ptr undef)
  store ptr %546, ptr %MEMORY, align 8
  %547 = load i64, ptr %NEXT_PC, align 8
  store i64 %547, ptr %PC, align 8
  %548 = add i64 %547, 1
  store i64 %548, ptr %NEXT_PC, align 8
  %549 = load ptr, ptr %MEMORY, align 8
  %550 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %549, ptr %state, ptr undef)
  store ptr %550, ptr %MEMORY, align 8
  %551 = load i64, ptr %NEXT_PC, align 8
  store i64 %551, ptr %PC, align 8
  %552 = add i64 %551, 1
  store i64 %552, ptr %NEXT_PC, align 8
  %553 = load ptr, ptr %MEMORY, align 8
  %554 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %553, ptr %state, ptr undef)
  store ptr %554, ptr %MEMORY, align 8
  %555 = load i64, ptr %NEXT_PC, align 8
  store i64 %555, ptr %PC, align 8
  %556 = add i64 %555, 2
  store i64 %556, ptr %NEXT_PC, align 8
  %557 = load i64, ptr %RAX, align 8
  %558 = load i32, ptr %EAX, align 4
  %559 = zext i32 %558 to i64
  %560 = load ptr, ptr %MEMORY, align 8
  %561 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %560, ptr %state, ptr %RAX, i64 %557, i64 %559)
  store ptr %561, ptr %MEMORY, align 8
  %562 = load i64, ptr %NEXT_PC, align 8
  store i64 %562, ptr %PC, align 8
  %563 = add i64 %562, 3
  store i64 %563, ptr %NEXT_PC, align 8
  %564 = load i64, ptr %RCX, align 8
  %565 = load i64, ptr %RCX, align 8
  %566 = load ptr, ptr %MEMORY, align 8
  %567 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %566, ptr %state, i64 %564, i64 %565)
  store ptr %567, ptr %MEMORY, align 8
  %568 = load i64, ptr %NEXT_PC, align 8
  store i64 %568, ptr %PC, align 8
  %569 = add i64 %568, 2
  store i64 %569, ptr %NEXT_PC, align 8
  %570 = load i64, ptr %NEXT_PC, align 8
  %571 = add i64 %570, 20
  %572 = load i64, ptr %NEXT_PC, align 8
  %573 = load ptr, ptr %MEMORY, align 8
  %574 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %573, ptr %state, ptr %BRANCH_TAKEN, i64 %571, i64 %572, ptr %NEXT_PC)
  store ptr %574, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658091, label %bb_5395658071

bb_5395658071:                                    ; preds = %bb_5395658053
  %575 = load i64, ptr %NEXT_PC, align 8
  store i64 %575, ptr %PC, align 8
  %576 = add i64 %575, 9
  store i64 %576, ptr %NEXT_PC, align 8
  %577 = load i64, ptr %RAX, align 8
  %578 = load i64, ptr %RAX, align 8
  %579 = mul i64 %578, 1
  %580 = add i64 %577, %579
  %581 = load ptr, ptr %MEMORY, align 8
  %582 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnItEEEEP6MemoryS4_R5StateDpT_(ptr %581, ptr %state, i64 %580)
  store ptr %582, ptr %MEMORY, align 8
  br label %bb_5395658080

bb_5395658080:                                    ; preds = %bb_5395658080, %bb_5395658071
  %583 = load i64, ptr %NEXT_PC, align 8
  store i64 %583, ptr %PC, align 8
  %584 = add i64 %583, 4
  store i64 %584, ptr %NEXT_PC, align 8
  %585 = load i64, ptr %RCX, align 8
  %586 = add i64 %585, 8
  %587 = load ptr, ptr %MEMORY, align 8
  %588 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %587, ptr %state, ptr %RCX, i64 %586)
  store ptr %588, ptr %MEMORY, align 8
  %589 = load i64, ptr %NEXT_PC, align 8
  store i64 %589, ptr %PC, align 8
  %590 = add i64 %589, 2
  store i64 %590, ptr %NEXT_PC, align 8
  %591 = load i64, ptr %RAX, align 8
  %592 = load ptr, ptr %MEMORY, align 8
  %593 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %592, ptr %state, ptr %RAX, i64 %591)
  store ptr %593, ptr %MEMORY, align 8
  %594 = load i64, ptr %NEXT_PC, align 8
  store i64 %594, ptr %PC, align 8
  %595 = add i64 %594, 3
  store i64 %595, ptr %NEXT_PC, align 8
  %596 = load i64, ptr %RCX, align 8
  %597 = load i64, ptr %RCX, align 8
  %598 = load ptr, ptr %MEMORY, align 8
  %599 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %598, ptr %state, i64 %596, i64 %597)
  store ptr %599, ptr %MEMORY, align 8
  %600 = load i64, ptr %NEXT_PC, align 8
  store i64 %600, ptr %PC, align 8
  %601 = add i64 %600, 2
  store i64 %601, ptr %NEXT_PC, align 8
  %602 = load i64, ptr %NEXT_PC, align 8
  %603 = sub i64 %602, 11
  %604 = load i64, ptr %NEXT_PC, align 8
  %605 = load ptr, ptr %MEMORY, align 8
  %606 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %605, ptr %state, ptr %BRANCH_TAKEN, i64 %603, i64 %604, ptr %NEXT_PC)
  store ptr %606, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658080, label %bb_5395658091

bb_5395658091:                                    ; preds = %bb_5395658080, %bb_5395658053
  %607 = load i64, ptr %NEXT_PC, align 8
  store i64 %607, ptr %PC, align 8
  %608 = add i64 %607, 1
  store i64 %608, ptr %NEXT_PC, align 8
  %609 = load ptr, ptr %MEMORY, align 8
  %610 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %609, ptr %state, ptr %NEXT_PC)
  store ptr %610, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658092:                                    ; No predecessors!
  %611 = load i64, ptr %NEXT_PC, align 8
  store i64 %611, ptr %PC, align 8
  %612 = add i64 %611, 1
  store i64 %612, ptr %NEXT_PC, align 8
  %613 = load ptr, ptr %MEMORY, align 8
  %614 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %613, ptr %state, ptr undef)
  store ptr %614, ptr %MEMORY, align 8
  %615 = load i64, ptr %NEXT_PC, align 8
  store i64 %615, ptr %PC, align 8
  %616 = add i64 %615, 1
  store i64 %616, ptr %NEXT_PC, align 8
  %617 = load ptr, ptr %MEMORY, align 8
  %618 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %617, ptr %state, ptr undef)
  store ptr %618, ptr %MEMORY, align 8
  %619 = load i64, ptr %NEXT_PC, align 8
  store i64 %619, ptr %PC, align 8
  %620 = add i64 %619, 1
  store i64 %620, ptr %NEXT_PC, align 8
  %621 = load ptr, ptr %MEMORY, align 8
  %622 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %621, ptr %state, ptr undef)
  store ptr %622, ptr %MEMORY, align 8
  %623 = load i64, ptr %NEXT_PC, align 8
  store i64 %623, ptr %PC, align 8
  %624 = add i64 %623, 1
  store i64 %624, ptr %NEXT_PC, align 8
  %625 = load ptr, ptr %MEMORY, align 8
  %626 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %625, ptr %state, ptr undef)
  store ptr %626, ptr %MEMORY, align 8
  %627 = load i64, ptr %NEXT_PC, align 8
  store i64 %627, ptr %PC, align 8
  %628 = add i64 %627, 1
  store i64 %628, ptr %NEXT_PC, align 8
  %629 = load ptr, ptr %MEMORY, align 8
  %630 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %629, ptr %state, ptr undef)
  store ptr %630, ptr %MEMORY, align 8
  %631 = load i64, ptr %NEXT_PC, align 8
  store i64 %631, ptr %PC, align 8
  %632 = add i64 %631, 1
  store i64 %632, ptr %NEXT_PC, align 8
  %633 = load ptr, ptr %MEMORY, align 8
  %634 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %633, ptr %state, ptr undef)
  store ptr %634, ptr %MEMORY, align 8
  %635 = load i64, ptr %NEXT_PC, align 8
  store i64 %635, ptr %PC, align 8
  %636 = add i64 %635, 1
  store i64 %636, ptr %NEXT_PC, align 8
  %637 = load ptr, ptr %MEMORY, align 8
  %638 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %637, ptr %state, ptr undef)
  store ptr %638, ptr %MEMORY, align 8
  %639 = load i64, ptr %NEXT_PC, align 8
  store i64 %639, ptr %PC, align 8
  %640 = add i64 %639, 1
  store i64 %640, ptr %NEXT_PC, align 8
  %641 = load ptr, ptr %MEMORY, align 8
  %642 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %641, ptr %state, ptr undef)
  store ptr %642, ptr %MEMORY, align 8
  %643 = load i64, ptr %NEXT_PC, align 8
  store i64 %643, ptr %PC, align 8
  %644 = add i64 %643, 1
  store i64 %644, ptr %NEXT_PC, align 8
  %645 = load ptr, ptr %MEMORY, align 8
  %646 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %645, ptr %state, ptr undef)
  store ptr %646, ptr %MEMORY, align 8
  %647 = load i64, ptr %NEXT_PC, align 8
  store i64 %647, ptr %PC, align 8
  %648 = add i64 %647, 1
  store i64 %648, ptr %NEXT_PC, align 8
  %649 = load ptr, ptr %MEMORY, align 8
  %650 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %649, ptr %state, ptr undef)
  store ptr %650, ptr %MEMORY, align 8
  %651 = load i64, ptr %NEXT_PC, align 8
  store i64 %651, ptr %PC, align 8
  %652 = add i64 %651, 1
  store i64 %652, ptr %NEXT_PC, align 8
  %653 = load ptr, ptr %MEMORY, align 8
  %654 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %653, ptr %state, ptr undef)
  store ptr %654, ptr %MEMORY, align 8
  %655 = load i64, ptr %NEXT_PC, align 8
  store i64 %655, ptr %PC, align 8
  %656 = add i64 %655, 1
  store i64 %656, ptr %NEXT_PC, align 8
  %657 = load ptr, ptr %MEMORY, align 8
  %658 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %657, ptr %state, ptr undef)
  store ptr %658, ptr %MEMORY, align 8
  %659 = load i64, ptr %NEXT_PC, align 8
  store i64 %659, ptr %PC, align 8
  %660 = add i64 %659, 1
  store i64 %660, ptr %NEXT_PC, align 8
  %661 = load ptr, ptr %MEMORY, align 8
  %662 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %661, ptr %state, ptr undef)
  store ptr %662, ptr %MEMORY, align 8
  %663 = load i64, ptr %NEXT_PC, align 8
  store i64 %663, ptr %PC, align 8
  %664 = add i64 %663, 1
  store i64 %664, ptr %NEXT_PC, align 8
  %665 = load ptr, ptr %MEMORY, align 8
  %666 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %665, ptr %state, ptr undef)
  store ptr %666, ptr %MEMORY, align 8
  %667 = load i64, ptr %NEXT_PC, align 8
  store i64 %667, ptr %PC, align 8
  %668 = add i64 %667, 1
  store i64 %668, ptr %NEXT_PC, align 8
  %669 = load ptr, ptr %MEMORY, align 8
  %670 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %669, ptr %state, ptr undef)
  store ptr %670, ptr %MEMORY, align 8
  %671 = load i64, ptr %NEXT_PC, align 8
  store i64 %671, ptr %PC, align 8
  %672 = add i64 %671, 1
  store i64 %672, ptr %NEXT_PC, align 8
  %673 = load ptr, ptr %MEMORY, align 8
  %674 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %673, ptr %state, ptr undef)
  store ptr %674, ptr %MEMORY, align 8
  %675 = load i64, ptr %NEXT_PC, align 8
  store i64 %675, ptr %PC, align 8
  %676 = add i64 %675, 1
  store i64 %676, ptr %NEXT_PC, align 8
  %677 = load ptr, ptr %MEMORY, align 8
  %678 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %677, ptr %state, ptr undef)
  store ptr %678, ptr %MEMORY, align 8
  %679 = load i64, ptr %NEXT_PC, align 8
  store i64 %679, ptr %PC, align 8
  %680 = add i64 %679, 1
  store i64 %680, ptr %NEXT_PC, align 8
  %681 = load ptr, ptr %MEMORY, align 8
  %682 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %681, ptr %state, ptr undef)
  store ptr %682, ptr %MEMORY, align 8
  %683 = load i64, ptr %NEXT_PC, align 8
  store i64 %683, ptr %PC, align 8
  %684 = add i64 %683, 1
  store i64 %684, ptr %NEXT_PC, align 8
  %685 = load ptr, ptr %MEMORY, align 8
  %686 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %685, ptr %state, ptr undef)
  store ptr %686, ptr %MEMORY, align 8
  %687 = load i64, ptr %NEXT_PC, align 8
  store i64 %687, ptr %PC, align 8
  %688 = add i64 %687, 1
  store i64 %688, ptr %NEXT_PC, align 8
  %689 = load ptr, ptr %MEMORY, align 8
  %690 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %689, ptr %state, ptr undef)
  store ptr %690, ptr %MEMORY, align 8
  %691 = load i64, ptr %NEXT_PC, align 8
  store i64 %691, ptr %PC, align 8
  %692 = add i64 %691, 5
  store i64 %692, ptr %NEXT_PC, align 8
  %693 = load i64, ptr %RSP, align 8
  %694 = add i64 %693, 8
  %695 = load i64, ptr %RBX, align 8
  %696 = load ptr, ptr %MEMORY, align 8
  %697 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %696, ptr %state, i64 %694, i64 %695)
  store ptr %697, ptr %MEMORY, align 8
  %698 = load i64, ptr %NEXT_PC, align 8
  store i64 %698, ptr %PC, align 8
  %699 = add i64 %698, 5
  store i64 %699, ptr %NEXT_PC, align 8
  %700 = load i64, ptr %RSP, align 8
  %701 = add i64 %700, 16
  %702 = load i64, ptr %RBP, align 8
  %703 = load ptr, ptr %MEMORY, align 8
  %704 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %703, ptr %state, i64 %701, i64 %702)
  store ptr %704, ptr %MEMORY, align 8
  %705 = load i64, ptr %NEXT_PC, align 8
  store i64 %705, ptr %PC, align 8
  %706 = add i64 %705, 5
  store i64 %706, ptr %NEXT_PC, align 8
  %707 = load i64, ptr %RSP, align 8
  %708 = add i64 %707, 24
  %709 = load i64, ptr %RSI, align 8
  %710 = load ptr, ptr %MEMORY, align 8
  %711 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %710, ptr %state, i64 %708, i64 %709)
  store ptr %711, ptr %MEMORY, align 8
  %712 = load i64, ptr %NEXT_PC, align 8
  store i64 %712, ptr %PC, align 8
  %713 = add i64 %712, 1
  store i64 %713, ptr %NEXT_PC, align 8
  %714 = load i64, ptr %RDI, align 8
  %715 = load ptr, ptr %MEMORY, align 8
  %716 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %715, ptr %state, i64 %714)
  store ptr %716, ptr %MEMORY, align 8
  %717 = load i64, ptr %NEXT_PC, align 8
  store i64 %717, ptr %PC, align 8
  %718 = add i64 %717, 4
  store i64 %718, ptr %NEXT_PC, align 8
  %719 = load i64, ptr %RSP, align 8
  %720 = load ptr, ptr %MEMORY, align 8
  %721 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %720, ptr %state, ptr %RSP, i64 %719, i64 32)
  store ptr %721, ptr %MEMORY, align 8
  %722 = load i64, ptr %NEXT_PC, align 8
  store i64 %722, ptr %PC, align 8
  %723 = add i64 %722, 3
  store i64 %723, ptr %NEXT_PC, align 8
  %724 = load i64, ptr %R8, align 8
  %725 = load ptr, ptr %MEMORY, align 8
  %726 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %725, ptr %state, ptr %RBX, i64 %724)
  store ptr %726, ptr %MEMORY, align 8
  %727 = load i64, ptr %NEXT_PC, align 8
  store i64 %727, ptr %PC, align 8
  %728 = add i64 %727, 3
  store i64 %728, ptr %NEXT_PC, align 8
  %729 = load i64, ptr %RDX, align 8
  %730 = load ptr, ptr %MEMORY, align 8
  %731 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %730, ptr %state, ptr %RSI, i64 %729)
  store ptr %731, ptr %MEMORY, align 8
  %732 = load i64, ptr %NEXT_PC, align 8
  store i64 %732, ptr %PC, align 8
  %733 = add i64 %732, 3
  store i64 %733, ptr %NEXT_PC, align 8
  %734 = load i64, ptr %RCX, align 8
  %735 = load ptr, ptr %MEMORY, align 8
  %736 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %735, ptr %state, ptr %RBP, i64 %734)
  store ptr %736, ptr %MEMORY, align 8
  %737 = load i64, ptr %NEXT_PC, align 8
  store i64 %737, ptr %PC, align 8
  %738 = add i64 %737, 3
  store i64 %738, ptr %NEXT_PC, align 8
  %739 = load i64, ptr %R8, align 8
  %740 = load i64, ptr %R8, align 8
  %741 = load ptr, ptr %MEMORY, align 8
  %742 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %741, ptr %state, i64 %739, i64 %740)
  store ptr %742, ptr %MEMORY, align 8
  %743 = load i64, ptr %NEXT_PC, align 8
  store i64 %743, ptr %PC, align 8
  %744 = add i64 %743, 2
  store i64 %744, ptr %NEXT_PC, align 8
  %745 = load i64, ptr %NEXT_PC, align 8
  %746 = add i64 %745, 50
  %747 = load i64, ptr %NEXT_PC, align 8
  %748 = load ptr, ptr %MEMORY, align 8
  %749 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %748, ptr %state, ptr %BRANCH_TAKEN, i64 %746, i64 %747, ptr %NEXT_PC)
  store ptr %749, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658196, label %bb_5395658146

bb_5395658146:                                    ; preds = %bb_5395658180, %bb_5395658092
  %750 = load i64, ptr %NEXT_PC, align 8
  store i64 %750, ptr %PC, align 8
  %751 = add i64 %750, 3
  store i64 %751, ptr %NEXT_PC, align 8
  %752 = load i64, ptr %RBP, align 8
  %753 = load ptr, ptr %MEMORY, align 8
  %754 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %753, ptr %state, ptr %RCX, i64 %752)
  store ptr %754, ptr %MEMORY, align 8
  %755 = load i64, ptr %NEXT_PC, align 8
  store i64 %755, ptr %PC, align 8
  %756 = add i64 %755, 5
  store i64 %756, ptr %NEXT_PC, align 8
  %757 = load i64, ptr %NEXT_PC, align 8
  %758 = sub i64 %757, 234
  %759 = load i64, ptr %NEXT_PC, align 8
  %760 = load ptr, ptr %MEMORY, align 8
  %761 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %760, ptr %state, i64 %758, ptr %NEXT_PC, i64 %759, ptr %RETURN_PC)
  store ptr %761, ptr %MEMORY, align 8
  %762 = load i64, ptr %NEXT_PC, align 8
  store i64 %762, ptr %PC, align 8
  %763 = add i64 %762, 3
  store i64 %763, ptr %NEXT_PC, align 8
  %764 = load i64, ptr %RBX, align 8
  %765 = load ptr, ptr %MEMORY, align 8
  %766 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %765, ptr %state, ptr %RCX, i64 %764)
  store ptr %766, ptr %MEMORY, align 8
  %767 = load i64, ptr %NEXT_PC, align 8
  store i64 %767, ptr %PC, align 8
  %768 = add i64 %767, 3
  store i64 %768, ptr %NEXT_PC, align 8
  %769 = load i64, ptr %RAX, align 8
  %770 = load ptr, ptr %MEMORY, align 8
  %771 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %770, ptr %state, ptr %RDI, i64 %769)
  store ptr %771, ptr %MEMORY, align 8
  %772 = load i64, ptr %NEXT_PC, align 8
  store i64 %772, ptr %PC, align 8
  %773 = add i64 %772, 5
  store i64 %773, ptr %NEXT_PC, align 8
  %774 = load i64, ptr %NEXT_PC, align 8
  %775 = sub i64 %774, 245
  %776 = load i64, ptr %NEXT_PC, align 8
  %777 = load ptr, ptr %MEMORY, align 8
  %778 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %777, ptr %state, i64 %775, ptr %NEXT_PC, i64 %776, ptr %RETURN_PC)
  store ptr %778, ptr %MEMORY, align 8
  %779 = load i64, ptr %NEXT_PC, align 8
  store i64 %779, ptr %PC, align 8
  %780 = add i64 %779, 3
  store i64 %780, ptr %NEXT_PC, align 8
  %781 = load i64, ptr %RAX, align 8
  %782 = load ptr, ptr %MEMORY, align 8
  %783 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %782, ptr %state, ptr %RCX, i64 %781)
  store ptr %783, ptr %MEMORY, align 8
  %784 = load i64, ptr %NEXT_PC, align 8
  store i64 %784, ptr %PC, align 8
  %785 = add i64 %784, 3
  store i64 %785, ptr %NEXT_PC, align 8
  %786 = load i64, ptr %RDI, align 8
  %787 = load ptr, ptr %MEMORY, align 8
  %788 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %787, ptr %state, ptr %RDX, i64 %786)
  store ptr %788, ptr %MEMORY, align 8
  %789 = load i64, ptr %NEXT_PC, align 8
  store i64 %789, ptr %PC, align 8
  %790 = add i64 %789, 5
  store i64 %790, ptr %NEXT_PC, align 8
  %791 = load i64, ptr %NEXT_PC, align 8
  %792 = add i64 %791, 46144
  %793 = load i64, ptr %NEXT_PC, align 8
  %794 = load ptr, ptr %MEMORY, align 8
  %795 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %794, ptr %state, i64 %792, ptr %NEXT_PC, i64 %793, ptr %RETURN_PC)
  store ptr %795, ptr %MEMORY, align 8
  %796 = load i64, ptr %NEXT_PC, align 8
  store i64 %796, ptr %PC, align 8
  %797 = add i64 %796, 2
  store i64 %797, ptr %NEXT_PC, align 8
  %798 = load i32, ptr %EAX, align 4
  %799 = zext i32 %798 to i64
  %800 = load i32, ptr %EAX, align 4
  %801 = zext i32 %800 to i64
  %802 = load ptr, ptr %MEMORY, align 8
  %803 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %802, ptr %state, i64 %799, i64 %801)
  store ptr %803, ptr %MEMORY, align 8
  %804 = load i64, ptr %NEXT_PC, align 8
  store i64 %804, ptr %PC, align 8
  %805 = add i64 %804, 2
  store i64 %805, ptr %NEXT_PC, align 8
  %806 = load i64, ptr %NEXT_PC, align 8
  %807 = add i64 %806, 43
  %808 = load i64, ptr %NEXT_PC, align 8
  %809 = load ptr, ptr %MEMORY, align 8
  %810 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %809, ptr %state, ptr %BRANCH_TAKEN, i64 %807, i64 %808, ptr %NEXT_PC)
  store ptr %810, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658223, label %bb_5395658180

bb_5395658180:                                    ; preds = %bb_5395658146
  %811 = load i64, ptr %NEXT_PC, align 8
  store i64 %811, ptr %PC, align 8
  %812 = add i64 %811, 3
  store i64 %812, ptr %NEXT_PC, align 8
  %813 = load i64, ptr %RBX, align 8
  %814 = load ptr, ptr %MEMORY, align 8
  %815 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %814, ptr %state, ptr %RCX, i64 %813)
  store ptr %815, ptr %MEMORY, align 8
  %816 = load i64, ptr %NEXT_PC, align 8
  store i64 %816, ptr %PC, align 8
  %817 = add i64 %816, 5
  store i64 %817, ptr %NEXT_PC, align 8
  %818 = load i64, ptr %NEXT_PC, align 8
  %819 = sub i64 %818, 156
  %820 = load i64, ptr %NEXT_PC, align 8
  %821 = load ptr, ptr %MEMORY, align 8
  %822 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %821, ptr %state, i64 %819, ptr %NEXT_PC, i64 %820, ptr %RETURN_PC)
  store ptr %822, ptr %MEMORY, align 8
  %823 = load i64, ptr %NEXT_PC, align 8
  store i64 %823, ptr %PC, align 8
  %824 = add i64 %823, 3
  store i64 %824, ptr %NEXT_PC, align 8
  %825 = load i64, ptr %RAX, align 8
  %826 = load ptr, ptr %MEMORY, align 8
  %827 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %826, ptr %state, ptr %RBX, i64 %825)
  store ptr %827, ptr %MEMORY, align 8
  %828 = load i64, ptr %NEXT_PC, align 8
  store i64 %828, ptr %PC, align 8
  %829 = add i64 %828, 3
  store i64 %829, ptr %NEXT_PC, align 8
  %830 = load i64, ptr %RAX, align 8
  %831 = load i64, ptr %RAX, align 8
  %832 = load ptr, ptr %MEMORY, align 8
  %833 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %832, ptr %state, i64 %830, i64 %831)
  store ptr %833, ptr %MEMORY, align 8
  %834 = load i64, ptr %NEXT_PC, align 8
  store i64 %834, ptr %PC, align 8
  %835 = add i64 %834, 2
  store i64 %835, ptr %NEXT_PC, align 8
  %836 = load i64, ptr %NEXT_PC, align 8
  %837 = sub i64 %836, 50
  %838 = load i64, ptr %NEXT_PC, align 8
  %839 = load ptr, ptr %MEMORY, align 8
  %840 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %839, ptr %state, ptr %BRANCH_TAKEN, i64 %837, i64 %838, ptr %NEXT_PC)
  store ptr %840, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658146, label %bb_5395658196

bb_5395658196:                                    ; preds = %bb_5395658180, %bb_5395658092
  %841 = load i64, ptr %NEXT_PC, align 8
  store i64 %841, ptr %PC, align 8
  %842 = add i64 %841, 3
  store i64 %842, ptr %NEXT_PC, align 8
  %843 = load i64, ptr %RSI, align 8
  %844 = load ptr, ptr %MEMORY, align 8
  %845 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %844, ptr %state, i64 %843, i64 0)
  store ptr %845, ptr %MEMORY, align 8
  br label %bb_5395658199

bb_5395658199:                                    ; preds = %bb_5395658223, %bb_5395658196
  %846 = load i64, ptr %NEXT_PC, align 8
  store i64 %846, ptr %PC, align 8
  %847 = add i64 %846, 5
  store i64 %847, ptr %NEXT_PC, align 8
  %848 = load i64, ptr %RSP, align 8
  %849 = add i64 %848, 48
  %850 = load ptr, ptr %MEMORY, align 8
  %851 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %850, ptr %state, ptr %RBX, i64 %849)
  store ptr %851, ptr %MEMORY, align 8
  %852 = load i64, ptr %NEXT_PC, align 8
  store i64 %852, ptr %PC, align 8
  %853 = add i64 %852, 3
  store i64 %853, ptr %NEXT_PC, align 8
  %854 = load i64, ptr %RSI, align 8
  %855 = load ptr, ptr %MEMORY, align 8
  %856 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %855, ptr %state, ptr %RAX, i64 %854)
  store ptr %856, ptr %MEMORY, align 8
  %857 = load i64, ptr %NEXT_PC, align 8
  store i64 %857, ptr %PC, align 8
  %858 = add i64 %857, 5
  store i64 %858, ptr %NEXT_PC, align 8
  %859 = load i64, ptr %RSP, align 8
  %860 = add i64 %859, 64
  %861 = load ptr, ptr %MEMORY, align 8
  %862 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %861, ptr %state, ptr %RSI, i64 %860)
  store ptr %862, ptr %MEMORY, align 8
  %863 = load i64, ptr %NEXT_PC, align 8
  store i64 %863, ptr %PC, align 8
  %864 = add i64 %863, 5
  store i64 %864, ptr %NEXT_PC, align 8
  %865 = load i64, ptr %RSP, align 8
  %866 = add i64 %865, 56
  %867 = load ptr, ptr %MEMORY, align 8
  %868 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %867, ptr %state, ptr %RBP, i64 %866)
  store ptr %868, ptr %MEMORY, align 8
  %869 = load i64, ptr %NEXT_PC, align 8
  store i64 %869, ptr %PC, align 8
  %870 = add i64 %869, 4
  store i64 %870, ptr %NEXT_PC, align 8
  %871 = load i64, ptr %RSP, align 8
  %872 = load ptr, ptr %MEMORY, align 8
  %873 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %872, ptr %state, ptr %RSP, i64 %871, i64 32)
  store ptr %873, ptr %MEMORY, align 8
  %874 = load i64, ptr %NEXT_PC, align 8
  store i64 %874, ptr %PC, align 8
  %875 = add i64 %874, 1
  store i64 %875, ptr %NEXT_PC, align 8
  %876 = load ptr, ptr %MEMORY, align 8
  %877 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %876, ptr %state, ptr %RDI)
  store ptr %877, ptr %MEMORY, align 8
  %878 = load i64, ptr %NEXT_PC, align 8
  store i64 %878, ptr %PC, align 8
  %879 = add i64 %878, 1
  store i64 %879, ptr %NEXT_PC, align 8
  %880 = load ptr, ptr %MEMORY, align 8
  %881 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %880, ptr %state, ptr %NEXT_PC)
  store ptr %881, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658223:                                    ; preds = %bb_5395658146
  %882 = load i64, ptr %NEXT_PC, align 8
  store i64 %882, ptr %PC, align 8
  %883 = add i64 %882, 3
  store i64 %883, ptr %NEXT_PC, align 8
  %884 = load i64, ptr %RSI, align 8
  %885 = load ptr, ptr %MEMORY, align 8
  %886 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %885, ptr %state, i64 %884, i64 1)
  store ptr %886, ptr %MEMORY, align 8
  %887 = load i64, ptr %NEXT_PC, align 8
  store i64 %887, ptr %PC, align 8
  %888 = add i64 %887, 2
  store i64 %888, ptr %NEXT_PC, align 8
  %889 = load i64, ptr %NEXT_PC, align 8
  %890 = sub i64 %889, 29
  %891 = load ptr, ptr %MEMORY, align 8
  %892 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %891, ptr %state, i64 %890, ptr %NEXT_PC)
  store ptr %892, ptr %MEMORY, align 8
  br label %bb_5395658199
  %893 = load i64, ptr %NEXT_PC, align 8
  store i64 %893, ptr %PC, align 8
  %894 = add i64 %893, 1
  store i64 %894, ptr %NEXT_PC, align 8
  %895 = load ptr, ptr %MEMORY, align 8
  %896 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %895, ptr %state, ptr undef)
  store ptr %896, ptr %MEMORY, align 8
  %897 = load i64, ptr %NEXT_PC, align 8
  store i64 %897, ptr %PC, align 8
  %898 = add i64 %897, 1
  store i64 %898, ptr %NEXT_PC, align 8
  %899 = load ptr, ptr %MEMORY, align 8
  %900 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %899, ptr %state, ptr undef)
  store ptr %900, ptr %MEMORY, align 8
  %901 = load i64, ptr %NEXT_PC, align 8
  store i64 %901, ptr %PC, align 8
  %902 = add i64 %901, 1
  store i64 %902, ptr %NEXT_PC, align 8
  %903 = load ptr, ptr %MEMORY, align 8
  %904 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %903, ptr %state, ptr undef)
  store ptr %904, ptr %MEMORY, align 8
  %905 = load i64, ptr %NEXT_PC, align 8
  store i64 %905, ptr %PC, align 8
  %906 = add i64 %905, 1
  store i64 %906, ptr %NEXT_PC, align 8
  %907 = load ptr, ptr %MEMORY, align 8
  %908 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %907, ptr %state, ptr undef)
  store ptr %908, ptr %MEMORY, align 8
  %909 = load i64, ptr %NEXT_PC, align 8
  store i64 %909, ptr %PC, align 8
  %910 = add i64 %909, 1
  store i64 %910, ptr %NEXT_PC, align 8
  %911 = load ptr, ptr %MEMORY, align 8
  %912 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %911, ptr %state, ptr undef)
  store ptr %912, ptr %MEMORY, align 8
  %913 = load i64, ptr %NEXT_PC, align 8
  store i64 %913, ptr %PC, align 8
  %914 = add i64 %913, 1
  store i64 %914, ptr %NEXT_PC, align 8
  %915 = load ptr, ptr %MEMORY, align 8
  %916 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %915, ptr %state, ptr undef)
  store ptr %916, ptr %MEMORY, align 8
  %917 = load i64, ptr %NEXT_PC, align 8
  store i64 %917, ptr %PC, align 8
  %918 = add i64 %917, 1
  store i64 %918, ptr %NEXT_PC, align 8
  %919 = load ptr, ptr %MEMORY, align 8
  %920 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %919, ptr %state, ptr undef)
  store ptr %920, ptr %MEMORY, align 8
  %921 = load i64, ptr %NEXT_PC, align 8
  store i64 %921, ptr %PC, align 8
  %922 = add i64 %921, 1
  store i64 %922, ptr %NEXT_PC, align 8
  %923 = load ptr, ptr %MEMORY, align 8
  %924 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %923, ptr %state, ptr undef)
  store ptr %924, ptr %MEMORY, align 8
  %925 = load i64, ptr %NEXT_PC, align 8
  store i64 %925, ptr %PC, align 8
  %926 = add i64 %925, 1
  store i64 %926, ptr %NEXT_PC, align 8
  %927 = load ptr, ptr %MEMORY, align 8
  %928 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %927, ptr %state, ptr undef)
  store ptr %928, ptr %MEMORY, align 8
  %929 = load i64, ptr %NEXT_PC, align 8
  store i64 %929, ptr %PC, align 8
  %930 = add i64 %929, 1
  store i64 %930, ptr %NEXT_PC, align 8
  %931 = load ptr, ptr %MEMORY, align 8
  %932 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %931, ptr %state, ptr undef)
  store ptr %932, ptr %MEMORY, align 8
  %933 = load i64, ptr %NEXT_PC, align 8
  store i64 %933, ptr %PC, align 8
  %934 = add i64 %933, 1
  store i64 %934, ptr %NEXT_PC, align 8
  %935 = load ptr, ptr %MEMORY, align 8
  %936 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %935, ptr %state, ptr undef)
  store ptr %936, ptr %MEMORY, align 8
  %937 = load i64, ptr %NEXT_PC, align 8
  store i64 %937, ptr %PC, align 8
  %938 = add i64 %937, 1
  store i64 %938, ptr %NEXT_PC, align 8
  %939 = load ptr, ptr %MEMORY, align 8
  %940 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %939, ptr %state, ptr undef)
  store ptr %940, ptr %MEMORY, align 8
  %941 = load i64, ptr %NEXT_PC, align 8
  store i64 %941, ptr %PC, align 8
  %942 = add i64 %941, 2
  store i64 %942, ptr %NEXT_PC, align 8
  %943 = load i64, ptr %RAX, align 8
  %944 = load i32, ptr %EAX, align 4
  %945 = zext i32 %944 to i64
  %946 = load ptr, ptr %MEMORY, align 8
  %947 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %946, ptr %state, ptr %RAX, i64 %943, i64 %945)
  store ptr %947, ptr %MEMORY, align 8
  %948 = load i64, ptr %NEXT_PC, align 8
  store i64 %948, ptr %PC, align 8
  %949 = add i64 %948, 1
  store i64 %949, ptr %NEXT_PC, align 8
  %950 = load ptr, ptr %MEMORY, align 8
  %951 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %950, ptr %state, ptr %NEXT_PC)
  store ptr %951, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658243:                                    ; No predecessors!
  %952 = load i64, ptr %NEXT_PC, align 8
  store i64 %952, ptr %PC, align 8
  %953 = add i64 %952, 1
  store i64 %953, ptr %NEXT_PC, align 8
  %954 = load ptr, ptr %MEMORY, align 8
  %955 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %954, ptr %state, ptr undef)
  store ptr %955, ptr %MEMORY, align 8
  %956 = load i64, ptr %NEXT_PC, align 8
  store i64 %956, ptr %PC, align 8
  %957 = add i64 %956, 1
  store i64 %957, ptr %NEXT_PC, align 8
  %958 = load ptr, ptr %MEMORY, align 8
  %959 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %958, ptr %state, ptr undef)
  store ptr %959, ptr %MEMORY, align 8
  %960 = load i64, ptr %NEXT_PC, align 8
  store i64 %960, ptr %PC, align 8
  %961 = add i64 %960, 1
  store i64 %961, ptr %NEXT_PC, align 8
  %962 = load ptr, ptr %MEMORY, align 8
  %963 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %962, ptr %state, ptr undef)
  store ptr %963, ptr %MEMORY, align 8
  %964 = load i64, ptr %NEXT_PC, align 8
  store i64 %964, ptr %PC, align 8
  %965 = add i64 %964, 1
  store i64 %965, ptr %NEXT_PC, align 8
  %966 = load ptr, ptr %MEMORY, align 8
  %967 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %966, ptr %state, ptr undef)
  store ptr %967, ptr %MEMORY, align 8
  %968 = load i64, ptr %NEXT_PC, align 8
  store i64 %968, ptr %PC, align 8
  %969 = add i64 %968, 1
  store i64 %969, ptr %NEXT_PC, align 8
  %970 = load ptr, ptr %MEMORY, align 8
  %971 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %970, ptr %state, ptr undef)
  store ptr %971, ptr %MEMORY, align 8
  %972 = load i64, ptr %NEXT_PC, align 8
  store i64 %972, ptr %PC, align 8
  %973 = add i64 %972, 1
  store i64 %973, ptr %NEXT_PC, align 8
  %974 = load ptr, ptr %MEMORY, align 8
  %975 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %974, ptr %state, ptr undef)
  store ptr %975, ptr %MEMORY, align 8
  %976 = load i64, ptr %NEXT_PC, align 8
  store i64 %976, ptr %PC, align 8
  %977 = add i64 %976, 1
  store i64 %977, ptr %NEXT_PC, align 8
  %978 = load ptr, ptr %MEMORY, align 8
  %979 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %978, ptr %state, ptr undef)
  store ptr %979, ptr %MEMORY, align 8
  %980 = load i64, ptr %NEXT_PC, align 8
  store i64 %980, ptr %PC, align 8
  %981 = add i64 %980, 1
  store i64 %981, ptr %NEXT_PC, align 8
  %982 = load ptr, ptr %MEMORY, align 8
  %983 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %982, ptr %state, ptr undef)
  store ptr %983, ptr %MEMORY, align 8
  %984 = load i64, ptr %NEXT_PC, align 8
  store i64 %984, ptr %PC, align 8
  %985 = add i64 %984, 1
  store i64 %985, ptr %NEXT_PC, align 8
  %986 = load ptr, ptr %MEMORY, align 8
  %987 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %986, ptr %state, ptr undef)
  store ptr %987, ptr %MEMORY, align 8
  %988 = load i64, ptr %NEXT_PC, align 8
  store i64 %988, ptr %PC, align 8
  %989 = add i64 %988, 1
  store i64 %989, ptr %NEXT_PC, align 8
  %990 = load ptr, ptr %MEMORY, align 8
  %991 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %990, ptr %state, ptr undef)
  store ptr %991, ptr %MEMORY, align 8
  %992 = load i64, ptr %NEXT_PC, align 8
  store i64 %992, ptr %PC, align 8
  %993 = add i64 %992, 1
  store i64 %993, ptr %NEXT_PC, align 8
  %994 = load ptr, ptr %MEMORY, align 8
  %995 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %994, ptr %state, ptr undef)
  store ptr %995, ptr %MEMORY, align 8
  %996 = load i64, ptr %NEXT_PC, align 8
  store i64 %996, ptr %PC, align 8
  %997 = add i64 %996, 1
  store i64 %997, ptr %NEXT_PC, align 8
  %998 = load ptr, ptr %MEMORY, align 8
  %999 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %998, ptr %state, ptr undef)
  store ptr %999, ptr %MEMORY, align 8
  %1000 = load i64, ptr %NEXT_PC, align 8
  store i64 %1000, ptr %PC, align 8
  %1001 = add i64 %1000, 1
  store i64 %1001, ptr %NEXT_PC, align 8
  %1002 = load ptr, ptr %MEMORY, align 8
  %1003 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1002, ptr %state, ptr undef)
  store ptr %1003, ptr %MEMORY, align 8
  %1004 = load i64, ptr %NEXT_PC, align 8
  store i64 %1004, ptr %PC, align 8
  %1005 = add i64 %1004, 4
  store i64 %1005, ptr %NEXT_PC, align 8
  %1006 = load i64, ptr %RCX, align 8
  %1007 = add i64 %1006, 8
  %1008 = load ptr, ptr %MEMORY, align 8
  %1009 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1008, ptr %state, ptr %RDX, i64 %1007)
  store ptr %1009, ptr %MEMORY, align 8
  %1010 = load i64, ptr %NEXT_PC, align 8
  store i64 %1010, ptr %PC, align 8
  %1011 = add i64 %1010, 3
  store i64 %1011, ptr %NEXT_PC, align 8
  %1012 = load i64, ptr %RCX, align 8
  %1013 = add i64 %1012, 20
  %1014 = load ptr, ptr %MEMORY, align 8
  %1015 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1014, ptr %state, ptr %RAX, i64 %1013)
  store ptr %1015, ptr %MEMORY, align 8
  %1016 = load i64, ptr %NEXT_PC, align 8
  store i64 %1016, ptr %PC, align 8
  %1017 = add i64 %1016, 3
  store i64 %1017, ptr %NEXT_PC, align 8
  %1018 = load i64, ptr %RDX, align 8
  %1019 = load i64, ptr %RDX, align 8
  %1020 = load ptr, ptr %MEMORY, align 8
  %1021 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1020, ptr %state, i64 %1018, i64 %1019)
  store ptr %1021, ptr %MEMORY, align 8
  %1022 = load i64, ptr %NEXT_PC, align 8
  store i64 %1022, ptr %PC, align 8
  %1023 = add i64 %1022, 2
  store i64 %1023, ptr %NEXT_PC, align 8
  %1024 = load i64, ptr %NEXT_PC, align 8
  %1025 = add i64 %1024, 16
  %1026 = load i64, ptr %NEXT_PC, align 8
  %1027 = load ptr, ptr %MEMORY, align 8
  %1028 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1027, ptr %state, ptr %BRANCH_TAKEN, i64 %1025, i64 %1026, ptr %NEXT_PC)
  store ptr %1028, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658284, label %bb_5395658268

bb_5395658268:                                    ; preds = %bb_5395658243
  %1029 = load i64, ptr %NEXT_PC, align 8
  store i64 %1029, ptr %PC, align 8
  %1030 = add i64 %1029, 4
  store i64 %1030, ptr %NEXT_PC, align 8
  %1031 = load i64, ptr %RAX, align 8
  %1032 = load ptr, ptr %MEMORY, align 8
  %1033 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnIjEEEEP6MemoryS4_R5StateDpT_(ptr %1032, ptr %state, i64 %1031)
  store ptr %1033, ptr %MEMORY, align 8
  br label %bb_5395658272

bb_5395658272:                                    ; preds = %bb_5395658272, %bb_5395658268
  %1034 = load i64, ptr %NEXT_PC, align 8
  store i64 %1034, ptr %PC, align 8
  %1035 = add i64 %1034, 3
  store i64 %1035, ptr %NEXT_PC, align 8
  %1036 = load i64, ptr %RAX, align 8
  %1037 = load i64, ptr %RDX, align 8
  %1038 = add i64 %1037, 20
  %1039 = load ptr, ptr %MEMORY, align 8
  %1040 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1039, ptr %state, ptr %RAX, i64 %1036, i64 %1038)
  store ptr %1040, ptr %MEMORY, align 8
  %1041 = load i64, ptr %NEXT_PC, align 8
  store i64 %1041, ptr %PC, align 8
  %1042 = add i64 %1041, 4
  store i64 %1042, ptr %NEXT_PC, align 8
  %1043 = load i64, ptr %RDX, align 8
  %1044 = add i64 %1043, 8
  %1045 = load ptr, ptr %MEMORY, align 8
  %1046 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1045, ptr %state, ptr %RDX, i64 %1044)
  store ptr %1046, ptr %MEMORY, align 8
  %1047 = load i64, ptr %NEXT_PC, align 8
  store i64 %1047, ptr %PC, align 8
  %1048 = add i64 %1047, 3
  store i64 %1048, ptr %NEXT_PC, align 8
  %1049 = load i64, ptr %RDX, align 8
  %1050 = load i64, ptr %RDX, align 8
  %1051 = load ptr, ptr %MEMORY, align 8
  %1052 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1051, ptr %state, i64 %1049, i64 %1050)
  store ptr %1052, ptr %MEMORY, align 8
  %1053 = load i64, ptr %NEXT_PC, align 8
  store i64 %1053, ptr %PC, align 8
  %1054 = add i64 %1053, 2
  store i64 %1054, ptr %NEXT_PC, align 8
  %1055 = load i64, ptr %NEXT_PC, align 8
  %1056 = sub i64 %1055, 12
  %1057 = load i64, ptr %NEXT_PC, align 8
  %1058 = load ptr, ptr %MEMORY, align 8
  %1059 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1058, ptr %state, ptr %BRANCH_TAKEN, i64 %1056, i64 %1057, ptr %NEXT_PC)
  store ptr %1059, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658272, label %bb_5395658284

bb_5395658284:                                    ; preds = %bb_5395658272, %bb_5395658243
  %1060 = load i64, ptr %NEXT_PC, align 8
  store i64 %1060, ptr %PC, align 8
  %1061 = add i64 %1060, 1
  store i64 %1061, ptr %NEXT_PC, align 8
  %1062 = load ptr, ptr %MEMORY, align 8
  %1063 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %1062, ptr %state, ptr %NEXT_PC)
  store ptr %1063, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658285:                                    ; No predecessors!
  %1064 = load i64, ptr %NEXT_PC, align 8
  store i64 %1064, ptr %PC, align 8
  %1065 = add i64 %1064, 1
  store i64 %1065, ptr %NEXT_PC, align 8
  %1066 = load ptr, ptr %MEMORY, align 8
  %1067 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1066, ptr %state, ptr undef)
  store ptr %1067, ptr %MEMORY, align 8
  %1068 = load i64, ptr %NEXT_PC, align 8
  store i64 %1068, ptr %PC, align 8
  %1069 = add i64 %1068, 1
  store i64 %1069, ptr %NEXT_PC, align 8
  %1070 = load ptr, ptr %MEMORY, align 8
  %1071 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1070, ptr %state, ptr undef)
  store ptr %1071, ptr %MEMORY, align 8
  %1072 = load i64, ptr %NEXT_PC, align 8
  store i64 %1072, ptr %PC, align 8
  %1073 = add i64 %1072, 1
  store i64 %1073, ptr %NEXT_PC, align 8
  %1074 = load ptr, ptr %MEMORY, align 8
  %1075 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1074, ptr %state, ptr undef)
  store ptr %1075, ptr %MEMORY, align 8
  %1076 = load i64, ptr %NEXT_PC, align 8
  store i64 %1076, ptr %PC, align 8
  %1077 = add i64 %1076, 1
  store i64 %1077, ptr %NEXT_PC, align 8
  %1078 = load ptr, ptr %MEMORY, align 8
  %1079 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1078, ptr %state, ptr undef)
  store ptr %1079, ptr %MEMORY, align 8
  %1080 = load i64, ptr %NEXT_PC, align 8
  store i64 %1080, ptr %PC, align 8
  %1081 = add i64 %1080, 1
  store i64 %1081, ptr %NEXT_PC, align 8
  %1082 = load ptr, ptr %MEMORY, align 8
  %1083 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1082, ptr %state, ptr undef)
  store ptr %1083, ptr %MEMORY, align 8
  %1084 = load i64, ptr %NEXT_PC, align 8
  store i64 %1084, ptr %PC, align 8
  %1085 = add i64 %1084, 1
  store i64 %1085, ptr %NEXT_PC, align 8
  %1086 = load ptr, ptr %MEMORY, align 8
  %1087 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1086, ptr %state, ptr undef)
  store ptr %1087, ptr %MEMORY, align 8
  %1088 = load i64, ptr %NEXT_PC, align 8
  store i64 %1088, ptr %PC, align 8
  %1089 = add i64 %1088, 1
  store i64 %1089, ptr %NEXT_PC, align 8
  %1090 = load ptr, ptr %MEMORY, align 8
  %1091 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1090, ptr %state, ptr undef)
  store ptr %1091, ptr %MEMORY, align 8
  %1092 = load i64, ptr %NEXT_PC, align 8
  store i64 %1092, ptr %PC, align 8
  %1093 = add i64 %1092, 1
  store i64 %1093, ptr %NEXT_PC, align 8
  %1094 = load ptr, ptr %MEMORY, align 8
  %1095 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1094, ptr %state, ptr undef)
  store ptr %1095, ptr %MEMORY, align 8
  %1096 = load i64, ptr %NEXT_PC, align 8
  store i64 %1096, ptr %PC, align 8
  %1097 = add i64 %1096, 1
  store i64 %1097, ptr %NEXT_PC, align 8
  %1098 = load ptr, ptr %MEMORY, align 8
  %1099 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1098, ptr %state, ptr undef)
  store ptr %1099, ptr %MEMORY, align 8
  %1100 = load i64, ptr %NEXT_PC, align 8
  store i64 %1100, ptr %PC, align 8
  %1101 = add i64 %1100, 1
  store i64 %1101, ptr %NEXT_PC, align 8
  %1102 = load ptr, ptr %MEMORY, align 8
  %1103 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1102, ptr %state, ptr undef)
  store ptr %1103, ptr %MEMORY, align 8
  %1104 = load i64, ptr %NEXT_PC, align 8
  store i64 %1104, ptr %PC, align 8
  %1105 = add i64 %1104, 1
  store i64 %1105, ptr %NEXT_PC, align 8
  %1106 = load ptr, ptr %MEMORY, align 8
  %1107 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1106, ptr %state, ptr undef)
  store ptr %1107, ptr %MEMORY, align 8
  %1108 = load i64, ptr %NEXT_PC, align 8
  store i64 %1108, ptr %PC, align 8
  %1109 = add i64 %1108, 1
  store i64 %1109, ptr %NEXT_PC, align 8
  %1110 = load ptr, ptr %MEMORY, align 8
  %1111 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1110, ptr %state, ptr undef)
  store ptr %1111, ptr %MEMORY, align 8
  %1112 = load i64, ptr %NEXT_PC, align 8
  store i64 %1112, ptr %PC, align 8
  %1113 = add i64 %1112, 1
  store i64 %1113, ptr %NEXT_PC, align 8
  %1114 = load ptr, ptr %MEMORY, align 8
  %1115 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1114, ptr %state, ptr undef)
  store ptr %1115, ptr %MEMORY, align 8
  %1116 = load i64, ptr %NEXT_PC, align 8
  store i64 %1116, ptr %PC, align 8
  %1117 = add i64 %1116, 1
  store i64 %1117, ptr %NEXT_PC, align 8
  %1118 = load ptr, ptr %MEMORY, align 8
  %1119 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1118, ptr %state, ptr undef)
  store ptr %1119, ptr %MEMORY, align 8
  %1120 = load i64, ptr %NEXT_PC, align 8
  store i64 %1120, ptr %PC, align 8
  %1121 = add i64 %1120, 1
  store i64 %1121, ptr %NEXT_PC, align 8
  %1122 = load ptr, ptr %MEMORY, align 8
  %1123 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1122, ptr %state, ptr undef)
  store ptr %1123, ptr %MEMORY, align 8
  %1124 = load i64, ptr %NEXT_PC, align 8
  store i64 %1124, ptr %PC, align 8
  %1125 = add i64 %1124, 1
  store i64 %1125, ptr %NEXT_PC, align 8
  %1126 = load ptr, ptr %MEMORY, align 8
  %1127 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1126, ptr %state, ptr undef)
  store ptr %1127, ptr %MEMORY, align 8
  %1128 = load i64, ptr %NEXT_PC, align 8
  store i64 %1128, ptr %PC, align 8
  %1129 = add i64 %1128, 1
  store i64 %1129, ptr %NEXT_PC, align 8
  %1130 = load ptr, ptr %MEMORY, align 8
  %1131 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1130, ptr %state, ptr undef)
  store ptr %1131, ptr %MEMORY, align 8
  %1132 = load i64, ptr %NEXT_PC, align 8
  store i64 %1132, ptr %PC, align 8
  %1133 = add i64 %1132, 1
  store i64 %1133, ptr %NEXT_PC, align 8
  %1134 = load ptr, ptr %MEMORY, align 8
  %1135 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1134, ptr %state, ptr undef)
  store ptr %1135, ptr %MEMORY, align 8
  %1136 = load i64, ptr %NEXT_PC, align 8
  store i64 %1136, ptr %PC, align 8
  %1137 = add i64 %1136, 1
  store i64 %1137, ptr %NEXT_PC, align 8
  %1138 = load ptr, ptr %MEMORY, align 8
  %1139 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1138, ptr %state, ptr undef)
  store ptr %1139, ptr %MEMORY, align 8
  %1140 = load i64, ptr %NEXT_PC, align 8
  store i64 %1140, ptr %PC, align 8
  %1141 = add i64 %1140, 2
  store i64 %1141, ptr %NEXT_PC, align 8
  %1142 = load i64, ptr %RAX, align 8
  %1143 = load i32, ptr %EAX, align 4
  %1144 = zext i32 %1143 to i64
  %1145 = load ptr, ptr %MEMORY, align 8
  %1146 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %1145, ptr %state, ptr %RAX, i64 %1142, i64 %1144)
  store ptr %1146, ptr %MEMORY, align 8
  %1147 = load i64, ptr %NEXT_PC, align 8
  store i64 %1147, ptr %PC, align 8
  %1148 = add i64 %1147, 1
  store i64 %1148, ptr %NEXT_PC, align 8
  %1149 = load ptr, ptr %MEMORY, align 8
  %1150 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %1149, ptr %state, ptr %NEXT_PC)
  store ptr %1150, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658307:                                    ; No predecessors!
  %1151 = load i64, ptr %NEXT_PC, align 8
  store i64 %1151, ptr %PC, align 8
  %1152 = add i64 %1151, 1
  store i64 %1152, ptr %NEXT_PC, align 8
  %1153 = load ptr, ptr %MEMORY, align 8
  %1154 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1153, ptr %state, ptr undef)
  store ptr %1154, ptr %MEMORY, align 8
  %1155 = load i64, ptr %NEXT_PC, align 8
  store i64 %1155, ptr %PC, align 8
  %1156 = add i64 %1155, 1
  store i64 %1156, ptr %NEXT_PC, align 8
  %1157 = load ptr, ptr %MEMORY, align 8
  %1158 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1157, ptr %state, ptr undef)
  store ptr %1158, ptr %MEMORY, align 8
  %1159 = load i64, ptr %NEXT_PC, align 8
  store i64 %1159, ptr %PC, align 8
  %1160 = add i64 %1159, 1
  store i64 %1160, ptr %NEXT_PC, align 8
  %1161 = load ptr, ptr %MEMORY, align 8
  %1162 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1161, ptr %state, ptr undef)
  store ptr %1162, ptr %MEMORY, align 8
  %1163 = load i64, ptr %NEXT_PC, align 8
  store i64 %1163, ptr %PC, align 8
  %1164 = add i64 %1163, 1
  store i64 %1164, ptr %NEXT_PC, align 8
  %1165 = load ptr, ptr %MEMORY, align 8
  %1166 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1165, ptr %state, ptr undef)
  store ptr %1166, ptr %MEMORY, align 8
  %1167 = load i64, ptr %NEXT_PC, align 8
  store i64 %1167, ptr %PC, align 8
  %1168 = add i64 %1167, 1
  store i64 %1168, ptr %NEXT_PC, align 8
  %1169 = load ptr, ptr %MEMORY, align 8
  %1170 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1169, ptr %state, ptr undef)
  store ptr %1170, ptr %MEMORY, align 8
  %1171 = load i64, ptr %NEXT_PC, align 8
  store i64 %1171, ptr %PC, align 8
  %1172 = add i64 %1171, 1
  store i64 %1172, ptr %NEXT_PC, align 8
  %1173 = load ptr, ptr %MEMORY, align 8
  %1174 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1173, ptr %state, ptr undef)
  store ptr %1174, ptr %MEMORY, align 8
  %1175 = load i64, ptr %NEXT_PC, align 8
  store i64 %1175, ptr %PC, align 8
  %1176 = add i64 %1175, 1
  store i64 %1176, ptr %NEXT_PC, align 8
  %1177 = load ptr, ptr %MEMORY, align 8
  %1178 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1177, ptr %state, ptr undef)
  store ptr %1178, ptr %MEMORY, align 8
  %1179 = load i64, ptr %NEXT_PC, align 8
  store i64 %1179, ptr %PC, align 8
  %1180 = add i64 %1179, 1
  store i64 %1180, ptr %NEXT_PC, align 8
  %1181 = load ptr, ptr %MEMORY, align 8
  %1182 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1181, ptr %state, ptr undef)
  store ptr %1182, ptr %MEMORY, align 8
  %1183 = load i64, ptr %NEXT_PC, align 8
  store i64 %1183, ptr %PC, align 8
  %1184 = add i64 %1183, 1
  store i64 %1184, ptr %NEXT_PC, align 8
  %1185 = load ptr, ptr %MEMORY, align 8
  %1186 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1185, ptr %state, ptr undef)
  store ptr %1186, ptr %MEMORY, align 8
  %1187 = load i64, ptr %NEXT_PC, align 8
  store i64 %1187, ptr %PC, align 8
  %1188 = add i64 %1187, 1
  store i64 %1188, ptr %NEXT_PC, align 8
  %1189 = load ptr, ptr %MEMORY, align 8
  %1190 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1189, ptr %state, ptr undef)
  store ptr %1190, ptr %MEMORY, align 8
  %1191 = load i64, ptr %NEXT_PC, align 8
  store i64 %1191, ptr %PC, align 8
  %1192 = add i64 %1191, 1
  store i64 %1192, ptr %NEXT_PC, align 8
  %1193 = load ptr, ptr %MEMORY, align 8
  %1194 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1193, ptr %state, ptr undef)
  store ptr %1194, ptr %MEMORY, align 8
  %1195 = load i64, ptr %NEXT_PC, align 8
  store i64 %1195, ptr %PC, align 8
  %1196 = add i64 %1195, 1
  store i64 %1196, ptr %NEXT_PC, align 8
  %1197 = load ptr, ptr %MEMORY, align 8
  %1198 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1197, ptr %state, ptr undef)
  store ptr %1198, ptr %MEMORY, align 8
  %1199 = load i64, ptr %NEXT_PC, align 8
  store i64 %1199, ptr %PC, align 8
  %1200 = add i64 %1199, 1
  store i64 %1200, ptr %NEXT_PC, align 8
  %1201 = load ptr, ptr %MEMORY, align 8
  %1202 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1201, ptr %state, ptr undef)
  store ptr %1202, ptr %MEMORY, align 8
  %1203 = load i64, ptr %NEXT_PC, align 8
  store i64 %1203, ptr %PC, align 8
  %1204 = add i64 %1203, 3
  store i64 %1204, ptr %NEXT_PC, align 8
  %1205 = load i64, ptr %RCX, align 8
  %1206 = add i64 %1205, 20
  %1207 = load ptr, ptr %MEMORY, align 8
  %1208 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1207, ptr %state, ptr %RAX, i64 %1206)
  store ptr %1208, ptr %MEMORY, align 8
  %1209 = load i64, ptr %NEXT_PC, align 8
  store i64 %1209, ptr %PC, align 8
  %1210 = add i64 %1209, 1
  store i64 %1210, ptr %NEXT_PC, align 8
  %1211 = load ptr, ptr %MEMORY, align 8
  %1212 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %1211, ptr %state, ptr %NEXT_PC)
  store ptr %1212, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658324:                                    ; No predecessors!
  %1213 = load i64, ptr %NEXT_PC, align 8
  store i64 %1213, ptr %PC, align 8
  %1214 = add i64 %1213, 1
  store i64 %1214, ptr %NEXT_PC, align 8
  %1215 = load ptr, ptr %MEMORY, align 8
  %1216 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1215, ptr %state, ptr undef)
  store ptr %1216, ptr %MEMORY, align 8
  %1217 = load i64, ptr %NEXT_PC, align 8
  store i64 %1217, ptr %PC, align 8
  %1218 = add i64 %1217, 1
  store i64 %1218, ptr %NEXT_PC, align 8
  %1219 = load ptr, ptr %MEMORY, align 8
  %1220 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1219, ptr %state, ptr undef)
  store ptr %1220, ptr %MEMORY, align 8
  %1221 = load i64, ptr %NEXT_PC, align 8
  store i64 %1221, ptr %PC, align 8
  %1222 = add i64 %1221, 1
  store i64 %1222, ptr %NEXT_PC, align 8
  %1223 = load ptr, ptr %MEMORY, align 8
  %1224 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1223, ptr %state, ptr undef)
  store ptr %1224, ptr %MEMORY, align 8
  %1225 = load i64, ptr %NEXT_PC, align 8
  store i64 %1225, ptr %PC, align 8
  %1226 = add i64 %1225, 1
  store i64 %1226, ptr %NEXT_PC, align 8
  %1227 = load ptr, ptr %MEMORY, align 8
  %1228 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1227, ptr %state, ptr undef)
  store ptr %1228, ptr %MEMORY, align 8
  %1229 = load i64, ptr %NEXT_PC, align 8
  store i64 %1229, ptr %PC, align 8
  %1230 = add i64 %1229, 1
  store i64 %1230, ptr %NEXT_PC, align 8
  %1231 = load ptr, ptr %MEMORY, align 8
  %1232 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1231, ptr %state, ptr undef)
  store ptr %1232, ptr %MEMORY, align 8
  %1233 = load i64, ptr %NEXT_PC, align 8
  store i64 %1233, ptr %PC, align 8
  %1234 = add i64 %1233, 1
  store i64 %1234, ptr %NEXT_PC, align 8
  %1235 = load ptr, ptr %MEMORY, align 8
  %1236 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1235, ptr %state, ptr undef)
  store ptr %1236, ptr %MEMORY, align 8
  %1237 = load i64, ptr %NEXT_PC, align 8
  store i64 %1237, ptr %PC, align 8
  %1238 = add i64 %1237, 1
  store i64 %1238, ptr %NEXT_PC, align 8
  %1239 = load ptr, ptr %MEMORY, align 8
  %1240 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1239, ptr %state, ptr undef)
  store ptr %1240, ptr %MEMORY, align 8
  %1241 = load i64, ptr %NEXT_PC, align 8
  store i64 %1241, ptr %PC, align 8
  %1242 = add i64 %1241, 1
  store i64 %1242, ptr %NEXT_PC, align 8
  %1243 = load ptr, ptr %MEMORY, align 8
  %1244 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1243, ptr %state, ptr undef)
  store ptr %1244, ptr %MEMORY, align 8
  %1245 = load i64, ptr %NEXT_PC, align 8
  store i64 %1245, ptr %PC, align 8
  %1246 = add i64 %1245, 1
  store i64 %1246, ptr %NEXT_PC, align 8
  %1247 = load ptr, ptr %MEMORY, align 8
  %1248 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1247, ptr %state, ptr undef)
  store ptr %1248, ptr %MEMORY, align 8
  %1249 = load i64, ptr %NEXT_PC, align 8
  store i64 %1249, ptr %PC, align 8
  %1250 = add i64 %1249, 1
  store i64 %1250, ptr %NEXT_PC, align 8
  %1251 = load ptr, ptr %MEMORY, align 8
  %1252 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1251, ptr %state, ptr undef)
  store ptr %1252, ptr %MEMORY, align 8
  %1253 = load i64, ptr %NEXT_PC, align 8
  store i64 %1253, ptr %PC, align 8
  %1254 = add i64 %1253, 1
  store i64 %1254, ptr %NEXT_PC, align 8
  %1255 = load ptr, ptr %MEMORY, align 8
  %1256 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1255, ptr %state, ptr undef)
  store ptr %1256, ptr %MEMORY, align 8
  %1257 = load i64, ptr %NEXT_PC, align 8
  store i64 %1257, ptr %PC, align 8
  %1258 = add i64 %1257, 1
  store i64 %1258, ptr %NEXT_PC, align 8
  %1259 = load ptr, ptr %MEMORY, align 8
  %1260 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1259, ptr %state, ptr undef)
  store ptr %1260, ptr %MEMORY, align 8
  %1261 = load i64, ptr %NEXT_PC, align 8
  store i64 %1261, ptr %PC, align 8
  %1262 = add i64 %1261, 5
  store i64 %1262, ptr %NEXT_PC, align 8
  %1263 = load i64, ptr %RSP, align 8
  %1264 = add i64 %1263, 8
  %1265 = load i64, ptr %RBX, align 8
  %1266 = load ptr, ptr %MEMORY, align 8
  %1267 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1266, ptr %state, i64 %1264, i64 %1265)
  store ptr %1267, ptr %MEMORY, align 8
  %1268 = load i64, ptr %NEXT_PC, align 8
  store i64 %1268, ptr %PC, align 8
  %1269 = add i64 %1268, 5
  store i64 %1269, ptr %NEXT_PC, align 8
  %1270 = load i64, ptr %RSP, align 8
  %1271 = add i64 %1270, 16
  %1272 = load i64, ptr %RSI, align 8
  %1273 = load ptr, ptr %MEMORY, align 8
  %1274 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1273, ptr %state, i64 %1271, i64 %1272)
  store ptr %1274, ptr %MEMORY, align 8
  %1275 = load i64, ptr %NEXT_PC, align 8
  store i64 %1275, ptr %PC, align 8
  %1276 = add i64 %1275, 1
  store i64 %1276, ptr %NEXT_PC, align 8
  %1277 = load i64, ptr %RDI, align 8
  %1278 = load ptr, ptr %MEMORY, align 8
  %1279 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %1278, ptr %state, i64 %1277)
  store ptr %1279, ptr %MEMORY, align 8
  %1280 = load i64, ptr %NEXT_PC, align 8
  store i64 %1280, ptr %PC, align 8
  %1281 = add i64 %1280, 4
  store i64 %1281, ptr %NEXT_PC, align 8
  %1282 = load i64, ptr %RSP, align 8
  %1283 = load ptr, ptr %MEMORY, align 8
  %1284 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1283, ptr %state, ptr %RSP, i64 %1282, i64 32)
  store ptr %1284, ptr %MEMORY, align 8
  %1285 = load i64, ptr %NEXT_PC, align 8
  store i64 %1285, ptr %PC, align 8
  %1286 = add i64 %1285, 2
  store i64 %1286, ptr %NEXT_PC, align 8
  %1287 = load i32, ptr %EDX, align 4
  %1288 = zext i32 %1287 to i64
  %1289 = load ptr, ptr %MEMORY, align 8
  %1290 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1289, ptr %state, ptr %RDI, i64 %1288)
  store ptr %1290, ptr %MEMORY, align 8
  %1291 = load i64, ptr %NEXT_PC, align 8
  store i64 %1291, ptr %PC, align 8
  %1292 = add i64 %1291, 3
  store i64 %1292, ptr %NEXT_PC, align 8
  %1293 = load i64, ptr %RCX, align 8
  %1294 = load ptr, ptr %MEMORY, align 8
  %1295 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1294, ptr %state, ptr %RSI, i64 %1293)
  store ptr %1295, ptr %MEMORY, align 8
  %1296 = load i64, ptr %NEXT_PC, align 8
  store i64 %1296, ptr %PC, align 8
  %1297 = add i64 %1296, 3
  store i64 %1297, ptr %NEXT_PC, align 8
  %1298 = load i64, ptr %RCX, align 8
  %1299 = load ptr, ptr %MEMORY, align 8
  %1300 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1299, ptr %state, ptr %RBX, i64 %1298)
  store ptr %1300, ptr %MEMORY, align 8
  %1301 = load i64, ptr %NEXT_PC, align 8
  store i64 %1301, ptr %PC, align 8
  %1302 = add i64 %1301, 5
  store i64 %1302, ptr %NEXT_PC, align 8
  %1303 = load i64, ptr %NEXT_PC, align 8
  %1304 = add i64 %1303, 212
  %1305 = load i64, ptr %NEXT_PC, align 8
  %1306 = load ptr, ptr %MEMORY, align 8
  %1307 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1306, ptr %state, i64 %1304, ptr %NEXT_PC, i64 %1305, ptr %RETURN_PC)
  store ptr %1307, ptr %MEMORY, align 8
  %1308 = load i64, ptr %NEXT_PC, align 8
  store i64 %1308, ptr %PC, align 8
  %1309 = add i64 %1308, 2
  store i64 %1309, ptr %NEXT_PC, align 8
  %1310 = load i64, ptr %RDI, align 8
  %1311 = load i32, ptr %EAX, align 4
  %1312 = zext i32 %1311 to i64
  %1313 = load ptr, ptr %MEMORY, align 8
  %1314 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %1313, ptr %state, ptr %RDI, i64 %1310, i64 %1312)
  store ptr %1314, ptr %MEMORY, align 8
  %1315 = load i64, ptr %NEXT_PC, align 8
  store i64 %1315, ptr %PC, align 8
  %1316 = add i64 %1315, 3
  store i64 %1316, ptr %NEXT_PC, align 8
  %1317 = load i64, ptr %RBX, align 8
  %1318 = load i64, ptr %RBX, align 8
  %1319 = load ptr, ptr %MEMORY, align 8
  %1320 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1319, ptr %state, i64 %1317, i64 %1318)
  store ptr %1320, ptr %MEMORY, align 8
  %1321 = load i64, ptr %NEXT_PC, align 8
  store i64 %1321, ptr %PC, align 8
  %1322 = add i64 %1321, 2
  store i64 %1322, ptr %NEXT_PC, align 8
  %1323 = load i64, ptr %NEXT_PC, align 8
  %1324 = add i64 %1323, 14
  %1325 = load i64, ptr %NEXT_PC, align 8
  %1326 = load ptr, ptr %MEMORY, align 8
  %1327 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1326, ptr %state, ptr %BRANCH_TAKEN, i64 %1324, i64 %1325, ptr %NEXT_PC)
  store ptr %1327, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658385, label %bb_5395658371

bb_5395658371:                                    ; preds = %bb_5395658376, %bb_5395658324
  %1328 = load i64, ptr %NEXT_PC, align 8
  store i64 %1328, ptr %PC, align 8
  %1329 = add i64 %1328, 3
  store i64 %1329, ptr %NEXT_PC, align 8
  %1330 = load i64, ptr %RDI, align 8
  %1331 = load i64, ptr %RBX, align 8
  %1332 = add i64 %1331, 32
  %1333 = load ptr, ptr %MEMORY, align 8
  %1334 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1333, ptr %state, ptr %RDI, i64 %1330, i64 %1332)
  store ptr %1334, ptr %MEMORY, align 8
  %1335 = load i64, ptr %NEXT_PC, align 8
  store i64 %1335, ptr %PC, align 8
  %1336 = add i64 %1335, 2
  store i64 %1336, ptr %NEXT_PC, align 8
  %1337 = load i64, ptr %NEXT_PC, align 8
  %1338 = add i64 %1337, 29
  %1339 = load i64, ptr %NEXT_PC, align 8
  %1340 = load ptr, ptr %MEMORY, align 8
  %1341 = call ptr @_ZN12_GLOBAL__N_13JNSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1340, ptr %state, ptr %BRANCH_TAKEN, i64 %1338, i64 %1339, ptr %NEXT_PC)
  store ptr %1341, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658405, label %bb_5395658376

bb_5395658376:                                    ; preds = %bb_5395658371
  %1342 = load i64, ptr %NEXT_PC, align 8
  store i64 %1342, ptr %PC, align 8
  %1343 = add i64 %1342, 4
  store i64 %1343, ptr %NEXT_PC, align 8
  %1344 = load i64, ptr %RBX, align 8
  %1345 = add i64 %1344, 8
  %1346 = load ptr, ptr %MEMORY, align 8
  %1347 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1346, ptr %state, ptr %RBX, i64 %1345)
  store ptr %1347, ptr %MEMORY, align 8
  %1348 = load i64, ptr %NEXT_PC, align 8
  store i64 %1348, ptr %PC, align 8
  %1349 = add i64 %1348, 3
  store i64 %1349, ptr %NEXT_PC, align 8
  %1350 = load i64, ptr %RBX, align 8
  %1351 = load i64, ptr %RBX, align 8
  %1352 = load ptr, ptr %MEMORY, align 8
  %1353 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1352, ptr %state, i64 %1350, i64 %1351)
  store ptr %1353, ptr %MEMORY, align 8
  %1354 = load i64, ptr %NEXT_PC, align 8
  store i64 %1354, ptr %PC, align 8
  %1355 = add i64 %1354, 2
  store i64 %1355, ptr %NEXT_PC, align 8
  %1356 = load i64, ptr %NEXT_PC, align 8
  %1357 = sub i64 %1356, 14
  %1358 = load i64, ptr %NEXT_PC, align 8
  %1359 = load ptr, ptr %MEMORY, align 8
  %1360 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1359, ptr %state, ptr %BRANCH_TAKEN, i64 %1357, i64 %1358, ptr %NEXT_PC)
  store ptr %1360, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658371, label %bb_5395658385

bb_5395658385:                                    ; preds = %bb_5395658376, %bb_5395658324
  %1361 = load i64, ptr %NEXT_PC, align 8
  store i64 %1361, ptr %PC, align 8
  %1362 = add i64 %1361, 4
  store i64 %1362, ptr %NEXT_PC, align 8
  %1363 = load i64, ptr %RSI, align 8
  %1364 = add i64 %1363, 24
  %1365 = load ptr, ptr %MEMORY, align 8
  %1366 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1365, ptr %state, ptr %RAX, i64 %1364)
  store ptr %1366, ptr %MEMORY, align 8
  %1367 = load i64, ptr %NEXT_PC, align 8
  store i64 %1367, ptr %PC, align 8
  %1368 = add i64 %1367, 5
  store i64 %1368, ptr %NEXT_PC, align 8
  %1369 = load i64, ptr %RSP, align 8
  %1370 = add i64 %1369, 48
  %1371 = load ptr, ptr %MEMORY, align 8
  %1372 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1371, ptr %state, ptr %RBX, i64 %1370)
  store ptr %1372, ptr %MEMORY, align 8
  %1373 = load i64, ptr %NEXT_PC, align 8
  store i64 %1373, ptr %PC, align 8
  %1374 = add i64 %1373, 5
  store i64 %1374, ptr %NEXT_PC, align 8
  %1375 = load i64, ptr %RSP, align 8
  %1376 = add i64 %1375, 56
  %1377 = load ptr, ptr %MEMORY, align 8
  %1378 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1377, ptr %state, ptr %RSI, i64 %1376)
  store ptr %1378, ptr %MEMORY, align 8
  %1379 = load i64, ptr %NEXT_PC, align 8
  store i64 %1379, ptr %PC, align 8
  %1380 = add i64 %1379, 4
  store i64 %1380, ptr %NEXT_PC, align 8
  %1381 = load i64, ptr %RSP, align 8
  %1382 = load ptr, ptr %MEMORY, align 8
  %1383 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1382, ptr %state, ptr %RSP, i64 %1381, i64 32)
  store ptr %1383, ptr %MEMORY, align 8
  %1384 = load i64, ptr %NEXT_PC, align 8
  store i64 %1384, ptr %PC, align 8
  %1385 = add i64 %1384, 1
  store i64 %1385, ptr %NEXT_PC, align 8
  %1386 = load ptr, ptr %MEMORY, align 8
  %1387 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %1386, ptr %state, ptr %RDI)
  store ptr %1387, ptr %MEMORY, align 8
  %1388 = load i64, ptr %NEXT_PC, align 8
  store i64 %1388, ptr %PC, align 8
  %1389 = add i64 %1388, 1
  store i64 %1389, ptr %NEXT_PC, align 8
  %1390 = load ptr, ptr %MEMORY, align 8
  %1391 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %1390, ptr %state, ptr %NEXT_PC)
  store ptr %1391, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658405:                                    ; preds = %bb_5395658371
  %1392 = load i64, ptr %NEXT_PC, align 8
  store i64 %1392, ptr %PC, align 8
  %1393 = add i64 %1392, 5
  store i64 %1393, ptr %NEXT_PC, align 8
  %1394 = load i64, ptr %RSP, align 8
  %1395 = add i64 %1394, 56
  %1396 = load ptr, ptr %MEMORY, align 8
  %1397 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1396, ptr %state, ptr %RSI, i64 %1395)
  store ptr %1397, ptr %MEMORY, align 8
  %1398 = load i64, ptr %NEXT_PC, align 8
  store i64 %1398, ptr %PC, align 8
  %1399 = add i64 %1398, 3
  store i64 %1399, ptr %NEXT_PC, align 8
  %1400 = load i32, ptr %EDI, align 4
  %1401 = zext i32 %1400 to i64
  %1402 = load ptr, ptr %MEMORY, align 8
  %1403 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %1402, ptr %state, ptr %RAX, i64 %1401)
  store ptr %1403, ptr %MEMORY, align 8
  %1404 = load i64, ptr %NEXT_PC, align 8
  store i64 %1404, ptr %PC, align 8
  %1405 = add i64 %1404, 4
  store i64 %1405, ptr %NEXT_PC, align 8
  %1406 = load i64, ptr %RAX, align 8
  %1407 = load i64, ptr %RAX, align 8
  %1408 = mul i64 %1407, 4
  %1409 = add i64 %1406, %1408
  %1410 = load ptr, ptr %MEMORY, align 8
  %1411 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %1410, ptr %state, ptr %RCX, i64 %1409)
  store ptr %1411, ptr %MEMORY, align 8
  %1412 = load i64, ptr %NEXT_PC, align 8
  store i64 %1412, ptr %PC, align 8
  %1413 = add i64 %1412, 4
  store i64 %1413, ptr %NEXT_PC, align 8
  %1414 = load i64, ptr %RBX, align 8
  %1415 = add i64 %1414, 24
  %1416 = load ptr, ptr %MEMORY, align 8
  %1417 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1416, ptr %state, ptr %RAX, i64 %1415)
  store ptr %1417, ptr %MEMORY, align 8
  %1418 = load i64, ptr %NEXT_PC, align 8
  store i64 %1418, ptr %PC, align 8
  %1419 = add i64 %1418, 5
  store i64 %1419, ptr %NEXT_PC, align 8
  %1420 = load i64, ptr %RSP, align 8
  %1421 = add i64 %1420, 48
  %1422 = load ptr, ptr %MEMORY, align 8
  %1423 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1422, ptr %state, ptr %RBX, i64 %1421)
  store ptr %1423, ptr %MEMORY, align 8
  %1424 = load i64, ptr %NEXT_PC, align 8
  store i64 %1424, ptr %PC, align 8
  %1425 = add i64 %1424, 4
  store i64 %1425, ptr %NEXT_PC, align 8
  %1426 = load i64, ptr %RAX, align 8
  %1427 = load i64, ptr %RCX, align 8
  %1428 = mul i64 %1427, 8
  %1429 = add i64 %1426, %1428
  %1430 = load ptr, ptr %MEMORY, align 8
  %1431 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %1430, ptr %state, ptr %RAX, i64 %1429)
  store ptr %1431, ptr %MEMORY, align 8
  %1432 = load i64, ptr %NEXT_PC, align 8
  store i64 %1432, ptr %PC, align 8
  %1433 = add i64 %1432, 4
  store i64 %1433, ptr %NEXT_PC, align 8
  %1434 = load i64, ptr %RSP, align 8
  %1435 = load ptr, ptr %MEMORY, align 8
  %1436 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1435, ptr %state, ptr %RSP, i64 %1434, i64 32)
  store ptr %1436, ptr %MEMORY, align 8
  %1437 = load i64, ptr %NEXT_PC, align 8
  store i64 %1437, ptr %PC, align 8
  %1438 = add i64 %1437, 1
  store i64 %1438, ptr %NEXT_PC, align 8
  %1439 = load ptr, ptr %MEMORY, align 8
  %1440 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %1439, ptr %state, ptr %RDI)
  store ptr %1440, ptr %MEMORY, align 8
  %1441 = load i64, ptr %NEXT_PC, align 8
  store i64 %1441, ptr %PC, align 8
  %1442 = add i64 %1441, 1
  store i64 %1442, ptr %NEXT_PC, align 8
  %1443 = load ptr, ptr %MEMORY, align 8
  %1444 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %1443, ptr %state, ptr %NEXT_PC)
  store ptr %1444, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658436:                                    ; No predecessors!
  %1445 = load i64, ptr %NEXT_PC, align 8
  store i64 %1445, ptr %PC, align 8
  %1446 = add i64 %1445, 1
  store i64 %1446, ptr %NEXT_PC, align 8
  %1447 = load ptr, ptr %MEMORY, align 8
  %1448 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1447, ptr %state, ptr undef)
  store ptr %1448, ptr %MEMORY, align 8
  %1449 = load i64, ptr %NEXT_PC, align 8
  store i64 %1449, ptr %PC, align 8
  %1450 = add i64 %1449, 1
  store i64 %1450, ptr %NEXT_PC, align 8
  %1451 = load ptr, ptr %MEMORY, align 8
  %1452 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1451, ptr %state, ptr undef)
  store ptr %1452, ptr %MEMORY, align 8
  %1453 = load i64, ptr %NEXT_PC, align 8
  store i64 %1453, ptr %PC, align 8
  %1454 = add i64 %1453, 1
  store i64 %1454, ptr %NEXT_PC, align 8
  %1455 = load ptr, ptr %MEMORY, align 8
  %1456 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1455, ptr %state, ptr undef)
  store ptr %1456, ptr %MEMORY, align 8
  %1457 = load i64, ptr %NEXT_PC, align 8
  store i64 %1457, ptr %PC, align 8
  %1458 = add i64 %1457, 1
  store i64 %1458, ptr %NEXT_PC, align 8
  %1459 = load ptr, ptr %MEMORY, align 8
  %1460 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1459, ptr %state, ptr undef)
  store ptr %1460, ptr %MEMORY, align 8
  %1461 = load i64, ptr %NEXT_PC, align 8
  store i64 %1461, ptr %PC, align 8
  %1462 = add i64 %1461, 1
  store i64 %1462, ptr %NEXT_PC, align 8
  %1463 = load ptr, ptr %MEMORY, align 8
  %1464 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1463, ptr %state, ptr undef)
  store ptr %1464, ptr %MEMORY, align 8
  %1465 = load i64, ptr %NEXT_PC, align 8
  store i64 %1465, ptr %PC, align 8
  %1466 = add i64 %1465, 1
  store i64 %1466, ptr %NEXT_PC, align 8
  %1467 = load ptr, ptr %MEMORY, align 8
  %1468 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1467, ptr %state, ptr undef)
  store ptr %1468, ptr %MEMORY, align 8
  %1469 = load i64, ptr %NEXT_PC, align 8
  store i64 %1469, ptr %PC, align 8
  %1470 = add i64 %1469, 1
  store i64 %1470, ptr %NEXT_PC, align 8
  %1471 = load ptr, ptr %MEMORY, align 8
  %1472 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1471, ptr %state, ptr undef)
  store ptr %1472, ptr %MEMORY, align 8
  %1473 = load i64, ptr %NEXT_PC, align 8
  store i64 %1473, ptr %PC, align 8
  %1474 = add i64 %1473, 1
  store i64 %1474, ptr %NEXT_PC, align 8
  %1475 = load ptr, ptr %MEMORY, align 8
  %1476 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1475, ptr %state, ptr undef)
  store ptr %1476, ptr %MEMORY, align 8
  %1477 = load i64, ptr %NEXT_PC, align 8
  store i64 %1477, ptr %PC, align 8
  %1478 = add i64 %1477, 1
  store i64 %1478, ptr %NEXT_PC, align 8
  %1479 = load ptr, ptr %MEMORY, align 8
  %1480 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1479, ptr %state, ptr undef)
  store ptr %1480, ptr %MEMORY, align 8
  %1481 = load i64, ptr %NEXT_PC, align 8
  store i64 %1481, ptr %PC, align 8
  %1482 = add i64 %1481, 1
  store i64 %1482, ptr %NEXT_PC, align 8
  %1483 = load ptr, ptr %MEMORY, align 8
  %1484 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1483, ptr %state, ptr undef)
  store ptr %1484, ptr %MEMORY, align 8
  %1485 = load i64, ptr %NEXT_PC, align 8
  store i64 %1485, ptr %PC, align 8
  %1486 = add i64 %1485, 1
  store i64 %1486, ptr %NEXT_PC, align 8
  %1487 = load ptr, ptr %MEMORY, align 8
  %1488 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1487, ptr %state, ptr undef)
  store ptr %1488, ptr %MEMORY, align 8
  %1489 = load i64, ptr %NEXT_PC, align 8
  store i64 %1489, ptr %PC, align 8
  %1490 = add i64 %1489, 1
  store i64 %1490, ptr %NEXT_PC, align 8
  %1491 = load ptr, ptr %MEMORY, align 8
  %1492 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1491, ptr %state, ptr undef)
  store ptr %1492, ptr %MEMORY, align 8
  %1493 = load i64, ptr %NEXT_PC, align 8
  store i64 %1493, ptr %PC, align 8
  %1494 = add i64 %1493, 5
  store i64 %1494, ptr %NEXT_PC, align 8
  %1495 = load i64, ptr %RSP, align 8
  %1496 = add i64 %1495, 8
  %1497 = load i64, ptr %RBX, align 8
  %1498 = load ptr, ptr %MEMORY, align 8
  %1499 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1498, ptr %state, i64 %1496, i64 %1497)
  store ptr %1499, ptr %MEMORY, align 8
  %1500 = load i64, ptr %NEXT_PC, align 8
  store i64 %1500, ptr %PC, align 8
  %1501 = add i64 %1500, 5
  store i64 %1501, ptr %NEXT_PC, align 8
  %1502 = load i64, ptr %RSP, align 8
  %1503 = add i64 %1502, 16
  %1504 = load i64, ptr %RBP, align 8
  %1505 = load ptr, ptr %MEMORY, align 8
  %1506 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1505, ptr %state, i64 %1503, i64 %1504)
  store ptr %1506, ptr %MEMORY, align 8
  %1507 = load i64, ptr %NEXT_PC, align 8
  store i64 %1507, ptr %PC, align 8
  %1508 = add i64 %1507, 5
  store i64 %1508, ptr %NEXT_PC, align 8
  %1509 = load i64, ptr %RSP, align 8
  %1510 = add i64 %1509, 24
  %1511 = load i64, ptr %RSI, align 8
  %1512 = load ptr, ptr %MEMORY, align 8
  %1513 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1512, ptr %state, i64 %1510, i64 %1511)
  store ptr %1513, ptr %MEMORY, align 8
  %1514 = load i64, ptr %NEXT_PC, align 8
  store i64 %1514, ptr %PC, align 8
  %1515 = add i64 %1514, 1
  store i64 %1515, ptr %NEXT_PC, align 8
  %1516 = load i64, ptr %RDI, align 8
  %1517 = load ptr, ptr %MEMORY, align 8
  %1518 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %1517, ptr %state, i64 %1516)
  store ptr %1518, ptr %MEMORY, align 8
  %1519 = load i64, ptr %NEXT_PC, align 8
  store i64 %1519, ptr %PC, align 8
  %1520 = add i64 %1519, 4
  store i64 %1520, ptr %NEXT_PC, align 8
  %1521 = load i64, ptr %RSP, align 8
  %1522 = load ptr, ptr %MEMORY, align 8
  %1523 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1522, ptr %state, ptr %RSP, i64 %1521, i64 32)
  store ptr %1523, ptr %MEMORY, align 8
  %1524 = load i64, ptr %NEXT_PC, align 8
  store i64 %1524, ptr %PC, align 8
  %1525 = add i64 %1524, 3
  store i64 %1525, ptr %NEXT_PC, align 8
  %1526 = load i64, ptr %RDX, align 8
  %1527 = load ptr, ptr %MEMORY, align 8
  %1528 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1527, ptr %state, ptr %RBP, i64 %1526)
  store ptr %1528, ptr %MEMORY, align 8
  %1529 = load i64, ptr %NEXT_PC, align 8
  store i64 %1529, ptr %PC, align 8
  %1530 = add i64 %1529, 3
  store i64 %1530, ptr %NEXT_PC, align 8
  %1531 = load i64, ptr %RCX, align 8
  %1532 = load ptr, ptr %MEMORY, align 8
  %1533 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1532, ptr %state, ptr %RDI, i64 %1531)
  store ptr %1533, ptr %MEMORY, align 8
  %1534 = load i64, ptr %NEXT_PC, align 8
  store i64 %1534, ptr %PC, align 8
  %1535 = add i64 %1534, 2
  store i64 %1535, ptr %NEXT_PC, align 8
  %1536 = load i64, ptr %RBX, align 8
  %1537 = load i32, ptr %EBX, align 4
  %1538 = zext i32 %1537 to i64
  %1539 = load ptr, ptr %MEMORY, align 8
  %1540 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %1539, ptr %state, ptr %RBX, i64 %1536, i64 %1538)
  store ptr %1540, ptr %MEMORY, align 8
  %1541 = load i64, ptr %NEXT_PC, align 8
  store i64 %1541, ptr %PC, align 8
  %1542 = add i64 %1541, 5
  store i64 %1542, ptr %NEXT_PC, align 8
  %1543 = load i64, ptr %NEXT_PC, align 8
  %1544 = add i64 %1543, 95
  %1545 = load i64, ptr %NEXT_PC, align 8
  %1546 = load ptr, ptr %MEMORY, align 8
  %1547 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1546, ptr %state, i64 %1544, ptr %NEXT_PC, i64 %1545, ptr %RETURN_PC)
  store ptr %1547, ptr %MEMORY, align 8
  %1548 = load i64, ptr %NEXT_PC, align 8
  store i64 %1548, ptr %PC, align 8
  %1549 = add i64 %1548, 2
  store i64 %1549, ptr %NEXT_PC, align 8
  %1550 = load i32, ptr %EAX, align 4
  %1551 = zext i32 %1550 to i64
  %1552 = load i32, ptr %EAX, align 4
  %1553 = zext i32 %1552 to i64
  %1554 = load ptr, ptr %MEMORY, align 8
  %1555 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1554, ptr %state, i64 %1551, i64 %1553)
  store ptr %1555, ptr %MEMORY, align 8
  %1556 = load i64, ptr %NEXT_PC, align 8
  store i64 %1556, ptr %PC, align 8
  %1557 = add i64 %1556, 2
  store i64 %1557, ptr %NEXT_PC, align 8
  %1558 = load i64, ptr %NEXT_PC, align 8
  %1559 = add i64 %1558, 42
  %1560 = load i64, ptr %NEXT_PC, align 8
  %1561 = load ptr, ptr %MEMORY, align 8
  %1562 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1561, ptr %state, ptr %BRANCH_TAKEN, i64 %1559, i64 %1560, ptr %NEXT_PC)
  store ptr %1562, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658527, label %bb_5395658485

bb_5395658485:                                    ; preds = %bb_5395658513, %bb_5395658436
  %1563 = load i64, ptr %NEXT_PC, align 8
  store i64 %1563, ptr %PC, align 8
  %1564 = add i64 %1563, 2
  store i64 %1564, ptr %NEXT_PC, align 8
  %1565 = load i32, ptr %EBX, align 4
  %1566 = zext i32 %1565 to i64
  %1567 = load ptr, ptr %MEMORY, align 8
  %1568 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1567, ptr %state, ptr %RDX, i64 %1566)
  store ptr %1568, ptr %MEMORY, align 8
  %1569 = load i64, ptr %NEXT_PC, align 8
  store i64 %1569, ptr %PC, align 8
  %1570 = add i64 %1569, 3
  store i64 %1570, ptr %NEXT_PC, align 8
  %1571 = load i64, ptr %RDI, align 8
  %1572 = load ptr, ptr %MEMORY, align 8
  %1573 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1572, ptr %state, ptr %RCX, i64 %1571)
  store ptr %1573, ptr %MEMORY, align 8
  %1574 = load i64, ptr %NEXT_PC, align 8
  store i64 %1574, ptr %PC, align 8
  %1575 = add i64 %1574, 5
  store i64 %1575, ptr %NEXT_PC, align 8
  %1576 = load i64, ptr %NEXT_PC, align 8
  %1577 = sub i64 %1576, 159
  %1578 = load i64, ptr %NEXT_PC, align 8
  %1579 = load ptr, ptr %MEMORY, align 8
  %1580 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1579, ptr %state, i64 %1577, ptr %NEXT_PC, i64 %1578, ptr %RETURN_PC)
  store ptr %1580, ptr %MEMORY, align 8
  %1581 = load i64, ptr %NEXT_PC, align 8
  store i64 %1581, ptr %PC, align 8
  %1582 = add i64 %1581, 3
  store i64 %1582, ptr %NEXT_PC, align 8
  %1583 = load i64, ptr %RBP, align 8
  %1584 = load ptr, ptr %MEMORY, align 8
  %1585 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1584, ptr %state, ptr %RDX, i64 %1583)
  store ptr %1585, ptr %MEMORY, align 8
  %1586 = load i64, ptr %NEXT_PC, align 8
  store i64 %1586, ptr %PC, align 8
  %1587 = add i64 %1586, 3
  store i64 %1587, ptr %NEXT_PC, align 8
  %1588 = load i64, ptr %RAX, align 8
  %1589 = load ptr, ptr %MEMORY, align 8
  %1590 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1589, ptr %state, ptr %RSI, i64 %1588)
  store ptr %1590, ptr %MEMORY, align 8
  %1591 = load i64, ptr %NEXT_PC, align 8
  store i64 %1591, ptr %PC, align 8
  %1592 = add i64 %1591, 3
  store i64 %1592, ptr %NEXT_PC, align 8
  %1593 = load i64, ptr %RAX, align 8
  %1594 = load ptr, ptr %MEMORY, align 8
  %1595 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1594, ptr %state, ptr %RCX, i64 %1593)
  store ptr %1595, ptr %MEMORY, align 8
  %1596 = load i64, ptr %NEXT_PC, align 8
  store i64 %1596, ptr %PC, align 8
  %1597 = add i64 %1596, 5
  store i64 %1597, ptr %NEXT_PC, align 8
  %1598 = load i64, ptr %NEXT_PC, align 8
  %1599 = add i64 %1598, 45811
  %1600 = load i64, ptr %NEXT_PC, align 8
  %1601 = load ptr, ptr %MEMORY, align 8
  %1602 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1601, ptr %state, i64 %1599, ptr %NEXT_PC, i64 %1600, ptr %RETURN_PC)
  store ptr %1602, ptr %MEMORY, align 8
  %1603 = load i64, ptr %NEXT_PC, align 8
  store i64 %1603, ptr %PC, align 8
  %1604 = add i64 %1603, 2
  store i64 %1604, ptr %NEXT_PC, align 8
  %1605 = load i32, ptr %EAX, align 4
  %1606 = zext i32 %1605 to i64
  %1607 = load i32, ptr %EAX, align 4
  %1608 = zext i32 %1607 to i64
  %1609 = load ptr, ptr %MEMORY, align 8
  %1610 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1609, ptr %state, i64 %1606, i64 %1608)
  store ptr %1610, ptr %MEMORY, align 8
  %1611 = load i64, ptr %NEXT_PC, align 8
  store i64 %1611, ptr %PC, align 8
  %1612 = add i64 %1611, 2
  store i64 %1612, ptr %NEXT_PC, align 8
  %1613 = load i64, ptr %NEXT_PC, align 8
  %1614 = add i64 %1613, 37
  %1615 = load i64, ptr %NEXT_PC, align 8
  %1616 = load ptr, ptr %MEMORY, align 8
  %1617 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1616, ptr %state, ptr %BRANCH_TAKEN, i64 %1614, i64 %1615, ptr %NEXT_PC)
  store ptr %1617, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658550, label %bb_5395658513

bb_5395658513:                                    ; preds = %bb_5395658485
  %1618 = load i64, ptr %NEXT_PC, align 8
  store i64 %1618, ptr %PC, align 8
  %1619 = add i64 %1618, 3
  store i64 %1619, ptr %NEXT_PC, align 8
  %1620 = load i64, ptr %RDI, align 8
  %1621 = load ptr, ptr %MEMORY, align 8
  %1622 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1621, ptr %state, ptr %RCX, i64 %1620)
  store ptr %1622, ptr %MEMORY, align 8
  %1623 = load i64, ptr %NEXT_PC, align 8
  store i64 %1623, ptr %PC, align 8
  %1624 = add i64 %1623, 2
  store i64 %1624, ptr %NEXT_PC, align 8
  %1625 = load i64, ptr %RBX, align 8
  %1626 = load ptr, ptr %MEMORY, align 8
  %1627 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1626, ptr %state, ptr %RBX, i64 %1625)
  store ptr %1627, ptr %MEMORY, align 8
  %1628 = load i64, ptr %NEXT_PC, align 8
  store i64 %1628, ptr %PC, align 8
  %1629 = add i64 %1628, 5
  store i64 %1629, ptr %NEXT_PC, align 8
  %1630 = load i64, ptr %NEXT_PC, align 8
  %1631 = add i64 %1630, 53
  %1632 = load i64, ptr %NEXT_PC, align 8
  %1633 = load ptr, ptr %MEMORY, align 8
  %1634 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1633, ptr %state, i64 %1631, ptr %NEXT_PC, i64 %1632, ptr %RETURN_PC)
  store ptr %1634, ptr %MEMORY, align 8
  %1635 = load i64, ptr %NEXT_PC, align 8
  store i64 %1635, ptr %PC, align 8
  %1636 = add i64 %1635, 2
  store i64 %1636, ptr %NEXT_PC, align 8
  %1637 = load i32, ptr %EBX, align 4
  %1638 = zext i32 %1637 to i64
  %1639 = load i32, ptr %EAX, align 4
  %1640 = zext i32 %1639 to i64
  %1641 = load ptr, ptr %MEMORY, align 8
  %1642 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1641, ptr %state, i64 %1638, i64 %1640)
  store ptr %1642, ptr %MEMORY, align 8
  %1643 = load i64, ptr %NEXT_PC, align 8
  store i64 %1643, ptr %PC, align 8
  %1644 = add i64 %1643, 2
  store i64 %1644, ptr %NEXT_PC, align 8
  %1645 = load i64, ptr %NEXT_PC, align 8
  %1646 = sub i64 %1645, 42
  %1647 = load i64, ptr %NEXT_PC, align 8
  %1648 = load ptr, ptr %MEMORY, align 8
  %1649 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1648, ptr %state, ptr %BRANCH_TAKEN, i64 %1646, i64 %1647, ptr %NEXT_PC)
  store ptr %1649, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658485, label %bb_5395658527

bb_5395658527:                                    ; preds = %bb_5395658513, %bb_5395658436
  %1650 = load i64, ptr %NEXT_PC, align 8
  store i64 %1650, ptr %PC, align 8
  %1651 = add i64 %1650, 2
  store i64 %1651, ptr %NEXT_PC, align 8
  %1652 = load i64, ptr %RAX, align 8
  %1653 = load i32, ptr %EAX, align 4
  %1654 = zext i32 %1653 to i64
  %1655 = load ptr, ptr %MEMORY, align 8
  %1656 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %1655, ptr %state, ptr %RAX, i64 %1652, i64 %1654)
  store ptr %1656, ptr %MEMORY, align 8
  br label %bb_5395658529

bb_5395658529:                                    ; preds = %bb_5395658550, %bb_5395658527
  %1657 = load i64, ptr %NEXT_PC, align 8
  store i64 %1657, ptr %PC, align 8
  %1658 = add i64 %1657, 5
  store i64 %1658, ptr %NEXT_PC, align 8
  %1659 = load i64, ptr %RSP, align 8
  %1660 = add i64 %1659, 48
  %1661 = load ptr, ptr %MEMORY, align 8
  %1662 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1661, ptr %state, ptr %RBX, i64 %1660)
  store ptr %1662, ptr %MEMORY, align 8
  %1663 = load i64, ptr %NEXT_PC, align 8
  store i64 %1663, ptr %PC, align 8
  %1664 = add i64 %1663, 5
  store i64 %1664, ptr %NEXT_PC, align 8
  %1665 = load i64, ptr %RSP, align 8
  %1666 = add i64 %1665, 56
  %1667 = load ptr, ptr %MEMORY, align 8
  %1668 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1667, ptr %state, ptr %RBP, i64 %1666)
  store ptr %1668, ptr %MEMORY, align 8
  %1669 = load i64, ptr %NEXT_PC, align 8
  store i64 %1669, ptr %PC, align 8
  %1670 = add i64 %1669, 5
  store i64 %1670, ptr %NEXT_PC, align 8
  %1671 = load i64, ptr %RSP, align 8
  %1672 = add i64 %1671, 64
  %1673 = load ptr, ptr %MEMORY, align 8
  %1674 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1673, ptr %state, ptr %RSI, i64 %1672)
  store ptr %1674, ptr %MEMORY, align 8
  %1675 = load i64, ptr %NEXT_PC, align 8
  store i64 %1675, ptr %PC, align 8
  %1676 = add i64 %1675, 4
  store i64 %1676, ptr %NEXT_PC, align 8
  %1677 = load i64, ptr %RSP, align 8
  %1678 = load ptr, ptr %MEMORY, align 8
  %1679 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1678, ptr %state, ptr %RSP, i64 %1677, i64 32)
  store ptr %1679, ptr %MEMORY, align 8
  %1680 = load i64, ptr %NEXT_PC, align 8
  store i64 %1680, ptr %PC, align 8
  %1681 = add i64 %1680, 1
  store i64 %1681, ptr %NEXT_PC, align 8
  %1682 = load ptr, ptr %MEMORY, align 8
  %1683 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %1682, ptr %state, ptr %RDI)
  store ptr %1683, ptr %MEMORY, align 8
  %1684 = load i64, ptr %NEXT_PC, align 8
  store i64 %1684, ptr %PC, align 8
  %1685 = add i64 %1684, 1
  store i64 %1685, ptr %NEXT_PC, align 8
  %1686 = load ptr, ptr %MEMORY, align 8
  %1687 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %1686, ptr %state, ptr %NEXT_PC)
  store ptr %1687, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658550:                                    ; preds = %bb_5395658485
  %1688 = load i64, ptr %NEXT_PC, align 8
  store i64 %1688, ptr %PC, align 8
  %1689 = add i64 %1688, 3
  store i64 %1689, ptr %NEXT_PC, align 8
  %1690 = load i64, ptr %RSI, align 8
  %1691 = load ptr, ptr %MEMORY, align 8
  %1692 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1691, ptr %state, ptr %RAX, i64 %1690)
  store ptr %1692, ptr %MEMORY, align 8
  %1693 = load i64, ptr %NEXT_PC, align 8
  store i64 %1693, ptr %PC, align 8
  %1694 = add i64 %1693, 2
  store i64 %1694, ptr %NEXT_PC, align 8
  %1695 = load i64, ptr %NEXT_PC, align 8
  %1696 = sub i64 %1695, 26
  %1697 = load ptr, ptr %MEMORY, align 8
  %1698 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %1697, ptr %state, i64 %1696, ptr %NEXT_PC)
  store ptr %1698, ptr %MEMORY, align 8
  br label %bb_5395658529
  %1699 = load i64, ptr %NEXT_PC, align 8
  store i64 %1699, ptr %PC, align 8
  %1700 = add i64 %1699, 1
  store i64 %1700, ptr %NEXT_PC, align 8
  %1701 = load ptr, ptr %MEMORY, align 8
  %1702 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1701, ptr %state, ptr undef)
  store ptr %1702, ptr %MEMORY, align 8
  %1703 = load i64, ptr %NEXT_PC, align 8
  store i64 %1703, ptr %PC, align 8
  %1704 = add i64 %1703, 1
  store i64 %1704, ptr %NEXT_PC, align 8
  %1705 = load ptr, ptr %MEMORY, align 8
  %1706 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1705, ptr %state, ptr undef)
  store ptr %1706, ptr %MEMORY, align 8
  %1707 = load i64, ptr %NEXT_PC, align 8
  store i64 %1707, ptr %PC, align 8
  %1708 = add i64 %1707, 1
  store i64 %1708, ptr %NEXT_PC, align 8
  %1709 = load ptr, ptr %MEMORY, align 8
  %1710 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1709, ptr %state, ptr undef)
  store ptr %1710, ptr %MEMORY, align 8
  %1711 = load i64, ptr %NEXT_PC, align 8
  store i64 %1711, ptr %PC, align 8
  %1712 = add i64 %1711, 1
  store i64 %1712, ptr %NEXT_PC, align 8
  %1713 = load ptr, ptr %MEMORY, align 8
  %1714 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1713, ptr %state, ptr undef)
  store ptr %1714, ptr %MEMORY, align 8
  %1715 = load i64, ptr %NEXT_PC, align 8
  store i64 %1715, ptr %PC, align 8
  %1716 = add i64 %1715, 1
  store i64 %1716, ptr %NEXT_PC, align 8
  %1717 = load ptr, ptr %MEMORY, align 8
  %1718 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1717, ptr %state, ptr undef)
  store ptr %1718, ptr %MEMORY, align 8
  %1719 = load i64, ptr %NEXT_PC, align 8
  store i64 %1719, ptr %PC, align 8
  %1720 = add i64 %1719, 1
  store i64 %1720, ptr %NEXT_PC, align 8
  %1721 = load ptr, ptr %MEMORY, align 8
  %1722 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1721, ptr %state, ptr undef)
  store ptr %1722, ptr %MEMORY, align 8
  %1723 = load i64, ptr %NEXT_PC, align 8
  store i64 %1723, ptr %PC, align 8
  %1724 = add i64 %1723, 1
  store i64 %1724, ptr %NEXT_PC, align 8
  %1725 = load ptr, ptr %MEMORY, align 8
  %1726 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1725, ptr %state, ptr undef)
  store ptr %1726, ptr %MEMORY, align 8
  %1727 = load i64, ptr %NEXT_PC, align 8
  store i64 %1727, ptr %PC, align 8
  %1728 = add i64 %1727, 1
  store i64 %1728, ptr %NEXT_PC, align 8
  %1729 = load ptr, ptr %MEMORY, align 8
  %1730 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1729, ptr %state, ptr undef)
  store ptr %1730, ptr %MEMORY, align 8
  %1731 = load i64, ptr %NEXT_PC, align 8
  store i64 %1731, ptr %PC, align 8
  %1732 = add i64 %1731, 1
  store i64 %1732, ptr %NEXT_PC, align 8
  %1733 = load ptr, ptr %MEMORY, align 8
  %1734 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1733, ptr %state, ptr undef)
  store ptr %1734, ptr %MEMORY, align 8
  %1735 = load i64, ptr %NEXT_PC, align 8
  store i64 %1735, ptr %PC, align 8
  %1736 = add i64 %1735, 1
  store i64 %1736, ptr %NEXT_PC, align 8
  %1737 = load ptr, ptr %MEMORY, align 8
  %1738 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1737, ptr %state, ptr undef)
  store ptr %1738, ptr %MEMORY, align 8
  %1739 = load i64, ptr %NEXT_PC, align 8
  store i64 %1739, ptr %PC, align 8
  %1740 = add i64 %1739, 1
  store i64 %1740, ptr %NEXT_PC, align 8
  %1741 = load ptr, ptr %MEMORY, align 8
  %1742 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1741, ptr %state, ptr undef)
  store ptr %1742, ptr %MEMORY, align 8
  %1743 = load i64, ptr %NEXT_PC, align 8
  store i64 %1743, ptr %PC, align 8
  %1744 = add i64 %1743, 1
  store i64 %1744, ptr %NEXT_PC, align 8
  %1745 = load ptr, ptr %MEMORY, align 8
  %1746 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1745, ptr %state, ptr undef)
  store ptr %1746, ptr %MEMORY, align 8
  %1747 = load i64, ptr %NEXT_PC, align 8
  store i64 %1747, ptr %PC, align 8
  %1748 = add i64 %1747, 1
  store i64 %1748, ptr %NEXT_PC, align 8
  %1749 = load ptr, ptr %MEMORY, align 8
  %1750 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1749, ptr %state, ptr undef)
  store ptr %1750, ptr %MEMORY, align 8
  %1751 = load i64, ptr %NEXT_PC, align 8
  store i64 %1751, ptr %PC, align 8
  %1752 = add i64 %1751, 1
  store i64 %1752, ptr %NEXT_PC, align 8
  %1753 = load ptr, ptr %MEMORY, align 8
  %1754 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1753, ptr %state, ptr undef)
  store ptr %1754, ptr %MEMORY, align 8
  %1755 = load i64, ptr %NEXT_PC, align 8
  store i64 %1755, ptr %PC, align 8
  %1756 = add i64 %1755, 1
  store i64 %1756, ptr %NEXT_PC, align 8
  %1757 = load ptr, ptr %MEMORY, align 8
  %1758 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1757, ptr %state, ptr undef)
  store ptr %1758, ptr %MEMORY, align 8
  %1759 = load i64, ptr %NEXT_PC, align 8
  store i64 %1759, ptr %PC, align 8
  %1760 = add i64 %1759, 1
  store i64 %1760, ptr %NEXT_PC, align 8
  %1761 = load ptr, ptr %MEMORY, align 8
  %1762 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1761, ptr %state, ptr undef)
  store ptr %1762, ptr %MEMORY, align 8
  %1763 = load i64, ptr %NEXT_PC, align 8
  store i64 %1763, ptr %PC, align 8
  %1764 = add i64 %1763, 1
  store i64 %1764, ptr %NEXT_PC, align 8
  %1765 = load ptr, ptr %MEMORY, align 8
  %1766 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1765, ptr %state, ptr undef)
  store ptr %1766, ptr %MEMORY, align 8
  %1767 = load i64, ptr %NEXT_PC, align 8
  store i64 %1767, ptr %PC, align 8
  %1768 = add i64 %1767, 1
  store i64 %1768, ptr %NEXT_PC, align 8
  %1769 = load ptr, ptr %MEMORY, align 8
  %1770 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1769, ptr %state, ptr undef)
  store ptr %1770, ptr %MEMORY, align 8
  %1771 = load i64, ptr %NEXT_PC, align 8
  store i64 %1771, ptr %PC, align 8
  %1772 = add i64 %1771, 1
  store i64 %1772, ptr %NEXT_PC, align 8
  %1773 = load ptr, ptr %MEMORY, align 8
  %1774 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1773, ptr %state, ptr undef)
  store ptr %1774, ptr %MEMORY, align 8
  %1775 = load i64, ptr %NEXT_PC, align 8
  store i64 %1775, ptr %PC, align 8
  %1776 = add i64 %1775, 1
  store i64 %1776, ptr %NEXT_PC, align 8
  %1777 = load ptr, ptr %MEMORY, align 8
  %1778 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1777, ptr %state, ptr undef)
  store ptr %1778, ptr %MEMORY, align 8
  %1779 = load i64, ptr %NEXT_PC, align 8
  store i64 %1779, ptr %PC, align 8
  %1780 = add i64 %1779, 1
  store i64 %1780, ptr %NEXT_PC, align 8
  %1781 = load ptr, ptr %MEMORY, align 8
  %1782 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1781, ptr %state, ptr undef)
  store ptr %1782, ptr %MEMORY, align 8
  %1783 = load i64, ptr %NEXT_PC, align 8
  store i64 %1783, ptr %PC, align 8
  %1784 = add i64 %1783, 4
  store i64 %1784, ptr %NEXT_PC, align 8
  %1785 = load i64, ptr %RCX, align 8
  %1786 = add i64 %1785, 8
  %1787 = load ptr, ptr %MEMORY, align 8
  %1788 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1787, ptr %state, ptr %RDX, i64 %1786)
  store ptr %1788, ptr %MEMORY, align 8
  %1789 = load i64, ptr %NEXT_PC, align 8
  store i64 %1789, ptr %PC, align 8
  %1790 = add i64 %1789, 3
  store i64 %1790, ptr %NEXT_PC, align 8
  %1791 = load i64, ptr %RCX, align 8
  %1792 = add i64 %1791, 32
  %1793 = load ptr, ptr %MEMORY, align 8
  %1794 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1793, ptr %state, ptr %RAX, i64 %1792)
  store ptr %1794, ptr %MEMORY, align 8
  %1795 = load i64, ptr %NEXT_PC, align 8
  store i64 %1795, ptr %PC, align 8
  %1796 = add i64 %1795, 3
  store i64 %1796, ptr %NEXT_PC, align 8
  %1797 = load i64, ptr %RDX, align 8
  %1798 = load i64, ptr %RDX, align 8
  %1799 = load ptr, ptr %MEMORY, align 8
  %1800 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1799, ptr %state, i64 %1797, i64 %1798)
  store ptr %1800, ptr %MEMORY, align 8
  %1801 = load i64, ptr %NEXT_PC, align 8
  store i64 %1801, ptr %PC, align 8
  %1802 = add i64 %1801, 2
  store i64 %1802, ptr %NEXT_PC, align 8
  %1803 = load i64, ptr %NEXT_PC, align 8
  %1804 = add i64 %1803, 16
  %1805 = load i64, ptr %NEXT_PC, align 8
  %1806 = load ptr, ptr %MEMORY, align 8
  %1807 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1806, ptr %state, ptr %BRANCH_TAKEN, i64 %1804, i64 %1805, ptr %NEXT_PC)
  store ptr %1807, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658604, label %bb_5395658588

bb_5395658588:                                    ; preds = %bb_5395658550
  %1808 = load i64, ptr %NEXT_PC, align 8
  store i64 %1808, ptr %PC, align 8
  %1809 = add i64 %1808, 4
  store i64 %1809, ptr %NEXT_PC, align 8
  %1810 = load i64, ptr %RAX, align 8
  %1811 = load ptr, ptr %MEMORY, align 8
  %1812 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnIjEEEEP6MemoryS4_R5StateDpT_(ptr %1811, ptr %state, i64 %1810)
  store ptr %1812, ptr %MEMORY, align 8
  br label %bb_5395658592

bb_5395658592:                                    ; preds = %bb_5395658592, %bb_5395658588
  %1813 = load i64, ptr %NEXT_PC, align 8
  store i64 %1813, ptr %PC, align 8
  %1814 = add i64 %1813, 3
  store i64 %1814, ptr %NEXT_PC, align 8
  %1815 = load i64, ptr %RAX, align 8
  %1816 = load i64, ptr %RDX, align 8
  %1817 = add i64 %1816, 32
  %1818 = load ptr, ptr %MEMORY, align 8
  %1819 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1818, ptr %state, ptr %RAX, i64 %1815, i64 %1817)
  store ptr %1819, ptr %MEMORY, align 8
  %1820 = load i64, ptr %NEXT_PC, align 8
  store i64 %1820, ptr %PC, align 8
  %1821 = add i64 %1820, 4
  store i64 %1821, ptr %NEXT_PC, align 8
  %1822 = load i64, ptr %RDX, align 8
  %1823 = add i64 %1822, 8
  %1824 = load ptr, ptr %MEMORY, align 8
  %1825 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1824, ptr %state, ptr %RDX, i64 %1823)
  store ptr %1825, ptr %MEMORY, align 8
  %1826 = load i64, ptr %NEXT_PC, align 8
  store i64 %1826, ptr %PC, align 8
  %1827 = add i64 %1826, 3
  store i64 %1827, ptr %NEXT_PC, align 8
  %1828 = load i64, ptr %RDX, align 8
  %1829 = load i64, ptr %RDX, align 8
  %1830 = load ptr, ptr %MEMORY, align 8
  %1831 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1830, ptr %state, i64 %1828, i64 %1829)
  store ptr %1831, ptr %MEMORY, align 8
  %1832 = load i64, ptr %NEXT_PC, align 8
  store i64 %1832, ptr %PC, align 8
  %1833 = add i64 %1832, 2
  store i64 %1833, ptr %NEXT_PC, align 8
  %1834 = load i64, ptr %NEXT_PC, align 8
  %1835 = sub i64 %1834, 12
  %1836 = load i64, ptr %NEXT_PC, align 8
  %1837 = load ptr, ptr %MEMORY, align 8
  %1838 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1837, ptr %state, ptr %BRANCH_TAKEN, i64 %1835, i64 %1836, ptr %NEXT_PC)
  store ptr %1838, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658592, label %bb_5395658604

bb_5395658604:                                    ; preds = %bb_5395658592, %bb_5395658550
  %1839 = load i64, ptr %NEXT_PC, align 8
  store i64 %1839, ptr %PC, align 8
  %1840 = add i64 %1839, 1
  store i64 %1840, ptr %NEXT_PC, align 8
  %1841 = load ptr, ptr %MEMORY, align 8
  %1842 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %1841, ptr %state, ptr %NEXT_PC)
  store ptr %1842, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658605:                                    ; No predecessors!
  %1843 = load i64, ptr %NEXT_PC, align 8
  store i64 %1843, ptr %PC, align 8
  %1844 = add i64 %1843, 1
  store i64 %1844, ptr %NEXT_PC, align 8
  %1845 = load ptr, ptr %MEMORY, align 8
  %1846 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1845, ptr %state, ptr undef)
  store ptr %1846, ptr %MEMORY, align 8
  %1847 = load i64, ptr %NEXT_PC, align 8
  store i64 %1847, ptr %PC, align 8
  %1848 = add i64 %1847, 1
  store i64 %1848, ptr %NEXT_PC, align 8
  %1849 = load ptr, ptr %MEMORY, align 8
  %1850 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1849, ptr %state, ptr undef)
  store ptr %1850, ptr %MEMORY, align 8
  %1851 = load i64, ptr %NEXT_PC, align 8
  store i64 %1851, ptr %PC, align 8
  %1852 = add i64 %1851, 1
  store i64 %1852, ptr %NEXT_PC, align 8
  %1853 = load ptr, ptr %MEMORY, align 8
  %1854 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1853, ptr %state, ptr undef)
  store ptr %1854, ptr %MEMORY, align 8
  %1855 = load i64, ptr %NEXT_PC, align 8
  store i64 %1855, ptr %PC, align 8
  %1856 = add i64 %1855, 1
  store i64 %1856, ptr %NEXT_PC, align 8
  %1857 = load ptr, ptr %MEMORY, align 8
  %1858 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1857, ptr %state, ptr undef)
  store ptr %1858, ptr %MEMORY, align 8
  %1859 = load i64, ptr %NEXT_PC, align 8
  store i64 %1859, ptr %PC, align 8
  %1860 = add i64 %1859, 1
  store i64 %1860, ptr %NEXT_PC, align 8
  %1861 = load ptr, ptr %MEMORY, align 8
  %1862 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1861, ptr %state, ptr undef)
  store ptr %1862, ptr %MEMORY, align 8
  %1863 = load i64, ptr %NEXT_PC, align 8
  store i64 %1863, ptr %PC, align 8
  %1864 = add i64 %1863, 1
  store i64 %1864, ptr %NEXT_PC, align 8
  %1865 = load ptr, ptr %MEMORY, align 8
  %1866 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1865, ptr %state, ptr undef)
  store ptr %1866, ptr %MEMORY, align 8
  %1867 = load i64, ptr %NEXT_PC, align 8
  store i64 %1867, ptr %PC, align 8
  %1868 = add i64 %1867, 1
  store i64 %1868, ptr %NEXT_PC, align 8
  %1869 = load ptr, ptr %MEMORY, align 8
  %1870 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1869, ptr %state, ptr undef)
  store ptr %1870, ptr %MEMORY, align 8
  %1871 = load i64, ptr %NEXT_PC, align 8
  store i64 %1871, ptr %PC, align 8
  %1872 = add i64 %1871, 1
  store i64 %1872, ptr %NEXT_PC, align 8
  %1873 = load ptr, ptr %MEMORY, align 8
  %1874 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1873, ptr %state, ptr undef)
  store ptr %1874, ptr %MEMORY, align 8
  %1875 = load i64, ptr %NEXT_PC, align 8
  store i64 %1875, ptr %PC, align 8
  %1876 = add i64 %1875, 1
  store i64 %1876, ptr %NEXT_PC, align 8
  %1877 = load ptr, ptr %MEMORY, align 8
  %1878 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1877, ptr %state, ptr undef)
  store ptr %1878, ptr %MEMORY, align 8
  %1879 = load i64, ptr %NEXT_PC, align 8
  store i64 %1879, ptr %PC, align 8
  %1880 = add i64 %1879, 1
  store i64 %1880, ptr %NEXT_PC, align 8
  %1881 = load ptr, ptr %MEMORY, align 8
  %1882 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1881, ptr %state, ptr undef)
  store ptr %1882, ptr %MEMORY, align 8
  %1883 = load i64, ptr %NEXT_PC, align 8
  store i64 %1883, ptr %PC, align 8
  %1884 = add i64 %1883, 1
  store i64 %1884, ptr %NEXT_PC, align 8
  %1885 = load ptr, ptr %MEMORY, align 8
  %1886 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1885, ptr %state, ptr undef)
  store ptr %1886, ptr %MEMORY, align 8
  %1887 = load i64, ptr %NEXT_PC, align 8
  store i64 %1887, ptr %PC, align 8
  %1888 = add i64 %1887, 1
  store i64 %1888, ptr %NEXT_PC, align 8
  %1889 = load ptr, ptr %MEMORY, align 8
  %1890 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1889, ptr %state, ptr undef)
  store ptr %1890, ptr %MEMORY, align 8
  %1891 = load i64, ptr %NEXT_PC, align 8
  store i64 %1891, ptr %PC, align 8
  %1892 = add i64 %1891, 1
  store i64 %1892, ptr %NEXT_PC, align 8
  %1893 = load ptr, ptr %MEMORY, align 8
  %1894 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1893, ptr %state, ptr undef)
  store ptr %1894, ptr %MEMORY, align 8
  %1895 = load i64, ptr %NEXT_PC, align 8
  store i64 %1895, ptr %PC, align 8
  %1896 = add i64 %1895, 1
  store i64 %1896, ptr %NEXT_PC, align 8
  %1897 = load ptr, ptr %MEMORY, align 8
  %1898 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1897, ptr %state, ptr undef)
  store ptr %1898, ptr %MEMORY, align 8
  %1899 = load i64, ptr %NEXT_PC, align 8
  store i64 %1899, ptr %PC, align 8
  %1900 = add i64 %1899, 1
  store i64 %1900, ptr %NEXT_PC, align 8
  %1901 = load ptr, ptr %MEMORY, align 8
  %1902 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1901, ptr %state, ptr undef)
  store ptr %1902, ptr %MEMORY, align 8
  %1903 = load i64, ptr %NEXT_PC, align 8
  store i64 %1903, ptr %PC, align 8
  %1904 = add i64 %1903, 1
  store i64 %1904, ptr %NEXT_PC, align 8
  %1905 = load ptr, ptr %MEMORY, align 8
  %1906 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1905, ptr %state, ptr undef)
  store ptr %1906, ptr %MEMORY, align 8
  %1907 = load i64, ptr %NEXT_PC, align 8
  store i64 %1907, ptr %PC, align 8
  %1908 = add i64 %1907, 1
  store i64 %1908, ptr %NEXT_PC, align 8
  %1909 = load ptr, ptr %MEMORY, align 8
  %1910 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1909, ptr %state, ptr undef)
  store ptr %1910, ptr %MEMORY, align 8
  %1911 = load i64, ptr %NEXT_PC, align 8
  store i64 %1911, ptr %PC, align 8
  %1912 = add i64 %1911, 1
  store i64 %1912, ptr %NEXT_PC, align 8
  %1913 = load ptr, ptr %MEMORY, align 8
  %1914 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1913, ptr %state, ptr undef)
  store ptr %1914, ptr %MEMORY, align 8
  %1915 = load i64, ptr %NEXT_PC, align 8
  store i64 %1915, ptr %PC, align 8
  %1916 = add i64 %1915, 1
  store i64 %1916, ptr %NEXT_PC, align 8
  %1917 = load ptr, ptr %MEMORY, align 8
  %1918 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1917, ptr %state, ptr undef)
  store ptr %1918, ptr %MEMORY, align 8
  %1919 = load i64, ptr %NEXT_PC, align 8
  store i64 %1919, ptr %PC, align 8
  %1920 = add i64 %1919, 3
  store i64 %1920, ptr %NEXT_PC, align 8
  %1921 = load i32, ptr %EDX, align 4
  %1922 = zext i32 %1921 to i64
  %1923 = load ptr, ptr %MEMORY, align 8
  %1924 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %1923, ptr %state, ptr %RAX, i64 %1922)
  store ptr %1924, ptr %MEMORY, align 8
  %1925 = load i64, ptr %NEXT_PC, align 8
  store i64 %1925, ptr %PC, align 8
  %1926 = add i64 %1925, 4
  store i64 %1926, ptr %NEXT_PC, align 8
  %1927 = load i64, ptr %RAX, align 8
  %1928 = load i64, ptr %RAX, align 8
  %1929 = mul i64 %1928, 4
  %1930 = add i64 %1927, %1929
  %1931 = load ptr, ptr %MEMORY, align 8
  %1932 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %1931, ptr %state, ptr %RDX, i64 %1930)
  store ptr %1932, ptr %MEMORY, align 8
  %1933 = load i64, ptr %NEXT_PC, align 8
  store i64 %1933, ptr %PC, align 8
  %1934 = add i64 %1933, 4
  store i64 %1934, ptr %NEXT_PC, align 8
  %1935 = load i64, ptr %RCX, align 8
  %1936 = add i64 %1935, 24
  %1937 = load ptr, ptr %MEMORY, align 8
  %1938 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1937, ptr %state, ptr %RAX, i64 %1936)
  store ptr %1938, ptr %MEMORY, align 8
  %1939 = load i64, ptr %NEXT_PC, align 8
  store i64 %1939, ptr %PC, align 8
  %1940 = add i64 %1939, 4
  store i64 %1940, ptr %NEXT_PC, align 8
  %1941 = load i64, ptr %RAX, align 8
  %1942 = load i64, ptr %RDX, align 8
  %1943 = mul i64 %1942, 8
  %1944 = add i64 %1941, %1943
  %1945 = load ptr, ptr %MEMORY, align 8
  %1946 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %1945, ptr %state, ptr %RAX, i64 %1944)
  store ptr %1946, ptr %MEMORY, align 8
  %1947 = load i64, ptr %NEXT_PC, align 8
  store i64 %1947, ptr %PC, align 8
  %1948 = add i64 %1947, 1
  store i64 %1948, ptr %NEXT_PC, align 8
  %1949 = load ptr, ptr %MEMORY, align 8
  %1950 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %1949, ptr %state, ptr %NEXT_PC)
  store ptr %1950, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658640:                                    ; No predecessors!
  %1951 = load i64, ptr %NEXT_PC, align 8
  store i64 %1951, ptr %PC, align 8
  %1952 = add i64 %1951, 1
  store i64 %1952, ptr %NEXT_PC, align 8
  %1953 = load ptr, ptr %MEMORY, align 8
  %1954 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1953, ptr %state, ptr undef)
  store ptr %1954, ptr %MEMORY, align 8
  %1955 = load i64, ptr %NEXT_PC, align 8
  store i64 %1955, ptr %PC, align 8
  %1956 = add i64 %1955, 1
  store i64 %1956, ptr %NEXT_PC, align 8
  %1957 = load ptr, ptr %MEMORY, align 8
  %1958 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1957, ptr %state, ptr undef)
  store ptr %1958, ptr %MEMORY, align 8
  %1959 = load i64, ptr %NEXT_PC, align 8
  store i64 %1959, ptr %PC, align 8
  %1960 = add i64 %1959, 1
  store i64 %1960, ptr %NEXT_PC, align 8
  %1961 = load ptr, ptr %MEMORY, align 8
  %1962 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1961, ptr %state, ptr undef)
  store ptr %1962, ptr %MEMORY, align 8
  %1963 = load i64, ptr %NEXT_PC, align 8
  store i64 %1963, ptr %PC, align 8
  %1964 = add i64 %1963, 1
  store i64 %1964, ptr %NEXT_PC, align 8
  %1965 = load ptr, ptr %MEMORY, align 8
  %1966 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1965, ptr %state, ptr undef)
  store ptr %1966, ptr %MEMORY, align 8
  %1967 = load i64, ptr %NEXT_PC, align 8
  store i64 %1967, ptr %PC, align 8
  %1968 = add i64 %1967, 1
  store i64 %1968, ptr %NEXT_PC, align 8
  %1969 = load ptr, ptr %MEMORY, align 8
  %1970 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1969, ptr %state, ptr undef)
  store ptr %1970, ptr %MEMORY, align 8
  %1971 = load i64, ptr %NEXT_PC, align 8
  store i64 %1971, ptr %PC, align 8
  %1972 = add i64 %1971, 1
  store i64 %1972, ptr %NEXT_PC, align 8
  %1973 = load ptr, ptr %MEMORY, align 8
  %1974 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1973, ptr %state, ptr undef)
  store ptr %1974, ptr %MEMORY, align 8
  %1975 = load i64, ptr %NEXT_PC, align 8
  store i64 %1975, ptr %PC, align 8
  %1976 = add i64 %1975, 1
  store i64 %1976, ptr %NEXT_PC, align 8
  %1977 = load ptr, ptr %MEMORY, align 8
  %1978 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1977, ptr %state, ptr undef)
  store ptr %1978, ptr %MEMORY, align 8
  %1979 = load i64, ptr %NEXT_PC, align 8
  store i64 %1979, ptr %PC, align 8
  %1980 = add i64 %1979, 1
  store i64 %1980, ptr %NEXT_PC, align 8
  %1981 = load ptr, ptr %MEMORY, align 8
  %1982 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1981, ptr %state, ptr undef)
  store ptr %1982, ptr %MEMORY, align 8
  %1983 = load i64, ptr %NEXT_PC, align 8
  store i64 %1983, ptr %PC, align 8
  %1984 = add i64 %1983, 1
  store i64 %1984, ptr %NEXT_PC, align 8
  %1985 = load ptr, ptr %MEMORY, align 8
  %1986 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1985, ptr %state, ptr undef)
  store ptr %1986, ptr %MEMORY, align 8
  %1987 = load i64, ptr %NEXT_PC, align 8
  store i64 %1987, ptr %PC, align 8
  %1988 = add i64 %1987, 1
  store i64 %1988, ptr %NEXT_PC, align 8
  %1989 = load ptr, ptr %MEMORY, align 8
  %1990 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1989, ptr %state, ptr undef)
  store ptr %1990, ptr %MEMORY, align 8
  %1991 = load i64, ptr %NEXT_PC, align 8
  store i64 %1991, ptr %PC, align 8
  %1992 = add i64 %1991, 1
  store i64 %1992, ptr %NEXT_PC, align 8
  %1993 = load ptr, ptr %MEMORY, align 8
  %1994 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1993, ptr %state, ptr undef)
  store ptr %1994, ptr %MEMORY, align 8
  %1995 = load i64, ptr %NEXT_PC, align 8
  store i64 %1995, ptr %PC, align 8
  %1996 = add i64 %1995, 1
  store i64 %1996, ptr %NEXT_PC, align 8
  %1997 = load ptr, ptr %MEMORY, align 8
  %1998 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1997, ptr %state, ptr undef)
  store ptr %1998, ptr %MEMORY, align 8
  %1999 = load i64, ptr %NEXT_PC, align 8
  store i64 %1999, ptr %PC, align 8
  %2000 = add i64 %1999, 1
  store i64 %2000, ptr %NEXT_PC, align 8
  %2001 = load ptr, ptr %MEMORY, align 8
  %2002 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2001, ptr %state, ptr undef)
  store ptr %2002, ptr %MEMORY, align 8
  %2003 = load i64, ptr %NEXT_PC, align 8
  store i64 %2003, ptr %PC, align 8
  %2004 = add i64 %2003, 1
  store i64 %2004, ptr %NEXT_PC, align 8
  %2005 = load ptr, ptr %MEMORY, align 8
  %2006 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2005, ptr %state, ptr undef)
  store ptr %2006, ptr %MEMORY, align 8
  %2007 = load i64, ptr %NEXT_PC, align 8
  store i64 %2007, ptr %PC, align 8
  %2008 = add i64 %2007, 1
  store i64 %2008, ptr %NEXT_PC, align 8
  %2009 = load ptr, ptr %MEMORY, align 8
  %2010 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2009, ptr %state, ptr undef)
  store ptr %2010, ptr %MEMORY, align 8
  %2011 = load i64, ptr %NEXT_PC, align 8
  store i64 %2011, ptr %PC, align 8
  %2012 = add i64 %2011, 1
  store i64 %2012, ptr %NEXT_PC, align 8
  %2013 = load ptr, ptr %MEMORY, align 8
  %2014 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2013, ptr %state, ptr undef)
  store ptr %2014, ptr %MEMORY, align 8
  %2015 = load i64, ptr %NEXT_PC, align 8
  store i64 %2015, ptr %PC, align 8
  %2016 = add i64 %2015, 5
  store i64 %2016, ptr %NEXT_PC, align 8
  %2017 = load i64, ptr %RSP, align 8
  %2018 = add i64 %2017, 8
  %2019 = load i64, ptr %RBX, align 8
  %2020 = load ptr, ptr %MEMORY, align 8
  %2021 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2020, ptr %state, i64 %2018, i64 %2019)
  store ptr %2021, ptr %MEMORY, align 8
  %2022 = load i64, ptr %NEXT_PC, align 8
  store i64 %2022, ptr %PC, align 8
  %2023 = add i64 %2022, 5
  store i64 %2023, ptr %NEXT_PC, align 8
  %2024 = load i64, ptr %RSP, align 8
  %2025 = add i64 %2024, 16
  %2026 = load i64, ptr %RBP, align 8
  %2027 = load ptr, ptr %MEMORY, align 8
  %2028 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2027, ptr %state, i64 %2025, i64 %2026)
  store ptr %2028, ptr %MEMORY, align 8
  %2029 = load i64, ptr %NEXT_PC, align 8
  store i64 %2029, ptr %PC, align 8
  %2030 = add i64 %2029, 5
  store i64 %2030, ptr %NEXT_PC, align 8
  %2031 = load i64, ptr %RSP, align 8
  %2032 = add i64 %2031, 24
  %2033 = load i64, ptr %RSI, align 8
  %2034 = load ptr, ptr %MEMORY, align 8
  %2035 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2034, ptr %state, i64 %2032, i64 %2033)
  store ptr %2035, ptr %MEMORY, align 8
  %2036 = load i64, ptr %NEXT_PC, align 8
  store i64 %2036, ptr %PC, align 8
  %2037 = add i64 %2036, 1
  store i64 %2037, ptr %NEXT_PC, align 8
  %2038 = load i64, ptr %RDI, align 8
  %2039 = load ptr, ptr %MEMORY, align 8
  %2040 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %2039, ptr %state, i64 %2038)
  store ptr %2040, ptr %MEMORY, align 8
  %2041 = load i64, ptr %NEXT_PC, align 8
  store i64 %2041, ptr %PC, align 8
  %2042 = add i64 %2041, 4
  store i64 %2042, ptr %NEXT_PC, align 8
  %2043 = load i64, ptr %RSP, align 8
  %2044 = load ptr, ptr %MEMORY, align 8
  %2045 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2044, ptr %state, ptr %RSP, i64 %2043, i64 32)
  store ptr %2045, ptr %MEMORY, align 8
  %2046 = load i64, ptr %NEXT_PC, align 8
  store i64 %2046, ptr %PC, align 8
  %2047 = add i64 %2046, 3
  store i64 %2047, ptr %NEXT_PC, align 8
  %2048 = load i64, ptr %RDX, align 8
  %2049 = load ptr, ptr %MEMORY, align 8
  %2050 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2049, ptr %state, ptr %RBP, i64 %2048)
  store ptr %2050, ptr %MEMORY, align 8
  %2051 = load i64, ptr %NEXT_PC, align 8
  store i64 %2051, ptr %PC, align 8
  %2052 = add i64 %2051, 3
  store i64 %2052, ptr %NEXT_PC, align 8
  %2053 = load i64, ptr %RCX, align 8
  %2054 = load ptr, ptr %MEMORY, align 8
  %2055 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2054, ptr %state, ptr %RDI, i64 %2053)
  store ptr %2055, ptr %MEMORY, align 8
  %2056 = load i64, ptr %NEXT_PC, align 8
  store i64 %2056, ptr %PC, align 8
  %2057 = add i64 %2056, 2
  store i64 %2057, ptr %NEXT_PC, align 8
  %2058 = load i64, ptr %RBX, align 8
  %2059 = load i32, ptr %EBX, align 4
  %2060 = zext i32 %2059 to i64
  %2061 = load ptr, ptr %MEMORY, align 8
  %2062 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2061, ptr %state, ptr %RBX, i64 %2058, i64 %2060)
  store ptr %2062, ptr %MEMORY, align 8
  %2063 = load i64, ptr %NEXT_PC, align 8
  store i64 %2063, ptr %PC, align 8
  %2064 = add i64 %2063, 5
  store i64 %2064, ptr %NEXT_PC, align 8
  %2065 = load i64, ptr %NEXT_PC, align 8
  %2066 = add i64 %2065, 95
  %2067 = load i64, ptr %NEXT_PC, align 8
  %2068 = load ptr, ptr %MEMORY, align 8
  %2069 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2068, ptr %state, i64 %2066, ptr %NEXT_PC, i64 %2067, ptr %RETURN_PC)
  store ptr %2069, ptr %MEMORY, align 8
  %2070 = load i64, ptr %NEXT_PC, align 8
  store i64 %2070, ptr %PC, align 8
  %2071 = add i64 %2070, 2
  store i64 %2071, ptr %NEXT_PC, align 8
  %2072 = load i32, ptr %EAX, align 4
  %2073 = zext i32 %2072 to i64
  %2074 = load i32, ptr %EAX, align 4
  %2075 = zext i32 %2074 to i64
  %2076 = load ptr, ptr %MEMORY, align 8
  %2077 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2076, ptr %state, i64 %2073, i64 %2075)
  store ptr %2077, ptr %MEMORY, align 8
  %2078 = load i64, ptr %NEXT_PC, align 8
  store i64 %2078, ptr %PC, align 8
  %2079 = add i64 %2078, 2
  store i64 %2079, ptr %NEXT_PC, align 8
  %2080 = load i64, ptr %NEXT_PC, align 8
  %2081 = add i64 %2080, 42
  %2082 = load i64, ptr %NEXT_PC, align 8
  %2083 = load ptr, ptr %MEMORY, align 8
  %2084 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2083, ptr %state, ptr %BRANCH_TAKEN, i64 %2081, i64 %2082, ptr %NEXT_PC)
  store ptr %2084, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658735, label %bb_5395658693

bb_5395658693:                                    ; preds = %bb_5395658721, %bb_5395658640
  %2085 = load i64, ptr %NEXT_PC, align 8
  store i64 %2085, ptr %PC, align 8
  %2086 = add i64 %2085, 2
  store i64 %2086, ptr %NEXT_PC, align 8
  %2087 = load i32, ptr %EBX, align 4
  %2088 = zext i32 %2087 to i64
  %2089 = load ptr, ptr %MEMORY, align 8
  %2090 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2089, ptr %state, ptr %RDX, i64 %2088)
  store ptr %2090, ptr %MEMORY, align 8
  %2091 = load i64, ptr %NEXT_PC, align 8
  store i64 %2091, ptr %PC, align 8
  %2092 = add i64 %2091, 3
  store i64 %2092, ptr %NEXT_PC, align 8
  %2093 = load i64, ptr %RDI, align 8
  %2094 = load ptr, ptr %MEMORY, align 8
  %2095 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2094, ptr %state, ptr %RCX, i64 %2093)
  store ptr %2095, ptr %MEMORY, align 8
  %2096 = load i64, ptr %NEXT_PC, align 8
  store i64 %2096, ptr %PC, align 8
  %2097 = add i64 %2096, 5
  store i64 %2097, ptr %NEXT_PC, align 8
  %2098 = load i64, ptr %NEXT_PC, align 8
  %2099 = sub i64 %2098, 79
  %2100 = load i64, ptr %NEXT_PC, align 8
  %2101 = load ptr, ptr %MEMORY, align 8
  %2102 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2101, ptr %state, i64 %2099, ptr %NEXT_PC, i64 %2100, ptr %RETURN_PC)
  store ptr %2102, ptr %MEMORY, align 8
  %2103 = load i64, ptr %NEXT_PC, align 8
  store i64 %2103, ptr %PC, align 8
  %2104 = add i64 %2103, 3
  store i64 %2104, ptr %NEXT_PC, align 8
  %2105 = load i64, ptr %RBP, align 8
  %2106 = load ptr, ptr %MEMORY, align 8
  %2107 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2106, ptr %state, ptr %RDX, i64 %2105)
  store ptr %2107, ptr %MEMORY, align 8
  %2108 = load i64, ptr %NEXT_PC, align 8
  store i64 %2108, ptr %PC, align 8
  %2109 = add i64 %2108, 3
  store i64 %2109, ptr %NEXT_PC, align 8
  %2110 = load i64, ptr %RAX, align 8
  %2111 = load ptr, ptr %MEMORY, align 8
  %2112 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2111, ptr %state, ptr %RSI, i64 %2110)
  store ptr %2112, ptr %MEMORY, align 8
  %2113 = load i64, ptr %NEXT_PC, align 8
  store i64 %2113, ptr %PC, align 8
  %2114 = add i64 %2113, 3
  store i64 %2114, ptr %NEXT_PC, align 8
  %2115 = load i64, ptr %RAX, align 8
  %2116 = load ptr, ptr %MEMORY, align 8
  %2117 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2116, ptr %state, ptr %RCX, i64 %2115)
  store ptr %2117, ptr %MEMORY, align 8
  %2118 = load i64, ptr %NEXT_PC, align 8
  store i64 %2118, ptr %PC, align 8
  %2119 = add i64 %2118, 5
  store i64 %2119, ptr %NEXT_PC, align 8
  %2120 = load i64, ptr %NEXT_PC, align 8
  %2121 = add i64 %2120, 45603
  %2122 = load i64, ptr %NEXT_PC, align 8
  %2123 = load ptr, ptr %MEMORY, align 8
  %2124 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2123, ptr %state, i64 %2121, ptr %NEXT_PC, i64 %2122, ptr %RETURN_PC)
  store ptr %2124, ptr %MEMORY, align 8
  %2125 = load i64, ptr %NEXT_PC, align 8
  store i64 %2125, ptr %PC, align 8
  %2126 = add i64 %2125, 2
  store i64 %2126, ptr %NEXT_PC, align 8
  %2127 = load i32, ptr %EAX, align 4
  %2128 = zext i32 %2127 to i64
  %2129 = load i32, ptr %EAX, align 4
  %2130 = zext i32 %2129 to i64
  %2131 = load ptr, ptr %MEMORY, align 8
  %2132 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2131, ptr %state, i64 %2128, i64 %2130)
  store ptr %2132, ptr %MEMORY, align 8
  %2133 = load i64, ptr %NEXT_PC, align 8
  store i64 %2133, ptr %PC, align 8
  %2134 = add i64 %2133, 2
  store i64 %2134, ptr %NEXT_PC, align 8
  %2135 = load i64, ptr %NEXT_PC, align 8
  %2136 = add i64 %2135, 37
  %2137 = load i64, ptr %NEXT_PC, align 8
  %2138 = load ptr, ptr %MEMORY, align 8
  %2139 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2138, ptr %state, ptr %BRANCH_TAKEN, i64 %2136, i64 %2137, ptr %NEXT_PC)
  store ptr %2139, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658758, label %bb_5395658721

bb_5395658721:                                    ; preds = %bb_5395658693
  %2140 = load i64, ptr %NEXT_PC, align 8
  store i64 %2140, ptr %PC, align 8
  %2141 = add i64 %2140, 3
  store i64 %2141, ptr %NEXT_PC, align 8
  %2142 = load i64, ptr %RDI, align 8
  %2143 = load ptr, ptr %MEMORY, align 8
  %2144 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2143, ptr %state, ptr %RCX, i64 %2142)
  store ptr %2144, ptr %MEMORY, align 8
  %2145 = load i64, ptr %NEXT_PC, align 8
  store i64 %2145, ptr %PC, align 8
  %2146 = add i64 %2145, 2
  store i64 %2146, ptr %NEXT_PC, align 8
  %2147 = load i64, ptr %RBX, align 8
  %2148 = load ptr, ptr %MEMORY, align 8
  %2149 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2148, ptr %state, ptr %RBX, i64 %2147)
  store ptr %2149, ptr %MEMORY, align 8
  %2150 = load i64, ptr %NEXT_PC, align 8
  store i64 %2150, ptr %PC, align 8
  %2151 = add i64 %2150, 5
  store i64 %2151, ptr %NEXT_PC, align 8
  %2152 = load i64, ptr %NEXT_PC, align 8
  %2153 = add i64 %2152, 53
  %2154 = load i64, ptr %NEXT_PC, align 8
  %2155 = load ptr, ptr %MEMORY, align 8
  %2156 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2155, ptr %state, i64 %2153, ptr %NEXT_PC, i64 %2154, ptr %RETURN_PC)
  store ptr %2156, ptr %MEMORY, align 8
  %2157 = load i64, ptr %NEXT_PC, align 8
  store i64 %2157, ptr %PC, align 8
  %2158 = add i64 %2157, 2
  store i64 %2158, ptr %NEXT_PC, align 8
  %2159 = load i32, ptr %EBX, align 4
  %2160 = zext i32 %2159 to i64
  %2161 = load i32, ptr %EAX, align 4
  %2162 = zext i32 %2161 to i64
  %2163 = load ptr, ptr %MEMORY, align 8
  %2164 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2163, ptr %state, i64 %2160, i64 %2162)
  store ptr %2164, ptr %MEMORY, align 8
  %2165 = load i64, ptr %NEXT_PC, align 8
  store i64 %2165, ptr %PC, align 8
  %2166 = add i64 %2165, 2
  store i64 %2166, ptr %NEXT_PC, align 8
  %2167 = load i64, ptr %NEXT_PC, align 8
  %2168 = sub i64 %2167, 42
  %2169 = load i64, ptr %NEXT_PC, align 8
  %2170 = load ptr, ptr %MEMORY, align 8
  %2171 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2170, ptr %state, ptr %BRANCH_TAKEN, i64 %2168, i64 %2169, ptr %NEXT_PC)
  store ptr %2171, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658693, label %bb_5395658735

bb_5395658735:                                    ; preds = %bb_5395658721, %bb_5395658640
  %2172 = load i64, ptr %NEXT_PC, align 8
  store i64 %2172, ptr %PC, align 8
  %2173 = add i64 %2172, 2
  store i64 %2173, ptr %NEXT_PC, align 8
  %2174 = load i64, ptr %RAX, align 8
  %2175 = load i32, ptr %EAX, align 4
  %2176 = zext i32 %2175 to i64
  %2177 = load ptr, ptr %MEMORY, align 8
  %2178 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2177, ptr %state, ptr %RAX, i64 %2174, i64 %2176)
  store ptr %2178, ptr %MEMORY, align 8
  br label %bb_5395658737

bb_5395658737:                                    ; preds = %bb_5395658758, %bb_5395658735
  %2179 = load i64, ptr %NEXT_PC, align 8
  store i64 %2179, ptr %PC, align 8
  %2180 = add i64 %2179, 5
  store i64 %2180, ptr %NEXT_PC, align 8
  %2181 = load i64, ptr %RSP, align 8
  %2182 = add i64 %2181, 48
  %2183 = load ptr, ptr %MEMORY, align 8
  %2184 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2183, ptr %state, ptr %RBX, i64 %2182)
  store ptr %2184, ptr %MEMORY, align 8
  %2185 = load i64, ptr %NEXT_PC, align 8
  store i64 %2185, ptr %PC, align 8
  %2186 = add i64 %2185, 5
  store i64 %2186, ptr %NEXT_PC, align 8
  %2187 = load i64, ptr %RSP, align 8
  %2188 = add i64 %2187, 56
  %2189 = load ptr, ptr %MEMORY, align 8
  %2190 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2189, ptr %state, ptr %RBP, i64 %2188)
  store ptr %2190, ptr %MEMORY, align 8
  %2191 = load i64, ptr %NEXT_PC, align 8
  store i64 %2191, ptr %PC, align 8
  %2192 = add i64 %2191, 5
  store i64 %2192, ptr %NEXT_PC, align 8
  %2193 = load i64, ptr %RSP, align 8
  %2194 = add i64 %2193, 64
  %2195 = load ptr, ptr %MEMORY, align 8
  %2196 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2195, ptr %state, ptr %RSI, i64 %2194)
  store ptr %2196, ptr %MEMORY, align 8
  %2197 = load i64, ptr %NEXT_PC, align 8
  store i64 %2197, ptr %PC, align 8
  %2198 = add i64 %2197, 4
  store i64 %2198, ptr %NEXT_PC, align 8
  %2199 = load i64, ptr %RSP, align 8
  %2200 = load ptr, ptr %MEMORY, align 8
  %2201 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2200, ptr %state, ptr %RSP, i64 %2199, i64 32)
  store ptr %2201, ptr %MEMORY, align 8
  %2202 = load i64, ptr %NEXT_PC, align 8
  store i64 %2202, ptr %PC, align 8
  %2203 = add i64 %2202, 1
  store i64 %2203, ptr %NEXT_PC, align 8
  %2204 = load ptr, ptr %MEMORY, align 8
  %2205 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %2204, ptr %state, ptr %RDI)
  store ptr %2205, ptr %MEMORY, align 8
  %2206 = load i64, ptr %NEXT_PC, align 8
  store i64 %2206, ptr %PC, align 8
  %2207 = add i64 %2206, 1
  store i64 %2207, ptr %NEXT_PC, align 8
  %2208 = load ptr, ptr %MEMORY, align 8
  %2209 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %2208, ptr %state, ptr %NEXT_PC)
  store ptr %2209, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658758:                                    ; preds = %bb_5395658693
  %2210 = load i64, ptr %NEXT_PC, align 8
  store i64 %2210, ptr %PC, align 8
  %2211 = add i64 %2210, 3
  store i64 %2211, ptr %NEXT_PC, align 8
  %2212 = load i64, ptr %RSI, align 8
  %2213 = load ptr, ptr %MEMORY, align 8
  %2214 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2213, ptr %state, ptr %RAX, i64 %2212)
  store ptr %2214, ptr %MEMORY, align 8
  %2215 = load i64, ptr %NEXT_PC, align 8
  store i64 %2215, ptr %PC, align 8
  %2216 = add i64 %2215, 2
  store i64 %2216, ptr %NEXT_PC, align 8
  %2217 = load i64, ptr %NEXT_PC, align 8
  %2218 = sub i64 %2217, 26
  %2219 = load ptr, ptr %MEMORY, align 8
  %2220 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %2219, ptr %state, i64 %2218, ptr %NEXT_PC)
  store ptr %2220, ptr %MEMORY, align 8
  br label %bb_5395658737
  %2221 = load i64, ptr %NEXT_PC, align 8
  store i64 %2221, ptr %PC, align 8
  %2222 = add i64 %2221, 1
  store i64 %2222, ptr %NEXT_PC, align 8
  %2223 = load ptr, ptr %MEMORY, align 8
  %2224 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2223, ptr %state, ptr undef)
  store ptr %2224, ptr %MEMORY, align 8
  %2225 = load i64, ptr %NEXT_PC, align 8
  store i64 %2225, ptr %PC, align 8
  %2226 = add i64 %2225, 1
  store i64 %2226, ptr %NEXT_PC, align 8
  %2227 = load ptr, ptr %MEMORY, align 8
  %2228 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2227, ptr %state, ptr undef)
  store ptr %2228, ptr %MEMORY, align 8
  %2229 = load i64, ptr %NEXT_PC, align 8
  store i64 %2229, ptr %PC, align 8
  %2230 = add i64 %2229, 1
  store i64 %2230, ptr %NEXT_PC, align 8
  %2231 = load ptr, ptr %MEMORY, align 8
  %2232 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2231, ptr %state, ptr undef)
  store ptr %2232, ptr %MEMORY, align 8
  %2233 = load i64, ptr %NEXT_PC, align 8
  store i64 %2233, ptr %PC, align 8
  %2234 = add i64 %2233, 1
  store i64 %2234, ptr %NEXT_PC, align 8
  %2235 = load ptr, ptr %MEMORY, align 8
  %2236 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2235, ptr %state, ptr undef)
  store ptr %2236, ptr %MEMORY, align 8
  %2237 = load i64, ptr %NEXT_PC, align 8
  store i64 %2237, ptr %PC, align 8
  %2238 = add i64 %2237, 1
  store i64 %2238, ptr %NEXT_PC, align 8
  %2239 = load ptr, ptr %MEMORY, align 8
  %2240 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2239, ptr %state, ptr undef)
  store ptr %2240, ptr %MEMORY, align 8
  %2241 = load i64, ptr %NEXT_PC, align 8
  store i64 %2241, ptr %PC, align 8
  %2242 = add i64 %2241, 1
  store i64 %2242, ptr %NEXT_PC, align 8
  %2243 = load ptr, ptr %MEMORY, align 8
  %2244 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2243, ptr %state, ptr undef)
  store ptr %2244, ptr %MEMORY, align 8
  %2245 = load i64, ptr %NEXT_PC, align 8
  store i64 %2245, ptr %PC, align 8
  %2246 = add i64 %2245, 1
  store i64 %2246, ptr %NEXT_PC, align 8
  %2247 = load ptr, ptr %MEMORY, align 8
  %2248 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2247, ptr %state, ptr undef)
  store ptr %2248, ptr %MEMORY, align 8
  %2249 = load i64, ptr %NEXT_PC, align 8
  store i64 %2249, ptr %PC, align 8
  %2250 = add i64 %2249, 1
  store i64 %2250, ptr %NEXT_PC, align 8
  %2251 = load ptr, ptr %MEMORY, align 8
  %2252 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2251, ptr %state, ptr undef)
  store ptr %2252, ptr %MEMORY, align 8
  %2253 = load i64, ptr %NEXT_PC, align 8
  store i64 %2253, ptr %PC, align 8
  %2254 = add i64 %2253, 1
  store i64 %2254, ptr %NEXT_PC, align 8
  %2255 = load ptr, ptr %MEMORY, align 8
  %2256 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2255, ptr %state, ptr undef)
  store ptr %2256, ptr %MEMORY, align 8
  %2257 = load i64, ptr %NEXT_PC, align 8
  store i64 %2257, ptr %PC, align 8
  %2258 = add i64 %2257, 1
  store i64 %2258, ptr %NEXT_PC, align 8
  %2259 = load ptr, ptr %MEMORY, align 8
  %2260 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2259, ptr %state, ptr undef)
  store ptr %2260, ptr %MEMORY, align 8
  %2261 = load i64, ptr %NEXT_PC, align 8
  store i64 %2261, ptr %PC, align 8
  %2262 = add i64 %2261, 1
  store i64 %2262, ptr %NEXT_PC, align 8
  %2263 = load ptr, ptr %MEMORY, align 8
  %2264 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2263, ptr %state, ptr undef)
  store ptr %2264, ptr %MEMORY, align 8
  %2265 = load i64, ptr %NEXT_PC, align 8
  store i64 %2265, ptr %PC, align 8
  %2266 = add i64 %2265, 1
  store i64 %2266, ptr %NEXT_PC, align 8
  %2267 = load ptr, ptr %MEMORY, align 8
  %2268 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2267, ptr %state, ptr undef)
  store ptr %2268, ptr %MEMORY, align 8
  %2269 = load i64, ptr %NEXT_PC, align 8
  store i64 %2269, ptr %PC, align 8
  %2270 = add i64 %2269, 1
  store i64 %2270, ptr %NEXT_PC, align 8
  %2271 = load ptr, ptr %MEMORY, align 8
  %2272 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2271, ptr %state, ptr undef)
  store ptr %2272, ptr %MEMORY, align 8
  %2273 = load i64, ptr %NEXT_PC, align 8
  store i64 %2273, ptr %PC, align 8
  %2274 = add i64 %2273, 1
  store i64 %2274, ptr %NEXT_PC, align 8
  %2275 = load ptr, ptr %MEMORY, align 8
  %2276 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2275, ptr %state, ptr undef)
  store ptr %2276, ptr %MEMORY, align 8
  %2277 = load i64, ptr %NEXT_PC, align 8
  store i64 %2277, ptr %PC, align 8
  %2278 = add i64 %2277, 1
  store i64 %2278, ptr %NEXT_PC, align 8
  %2279 = load ptr, ptr %MEMORY, align 8
  %2280 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2279, ptr %state, ptr undef)
  store ptr %2280, ptr %MEMORY, align 8
  %2281 = load i64, ptr %NEXT_PC, align 8
  store i64 %2281, ptr %PC, align 8
  %2282 = add i64 %2281, 1
  store i64 %2282, ptr %NEXT_PC, align 8
  %2283 = load ptr, ptr %MEMORY, align 8
  %2284 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2283, ptr %state, ptr undef)
  store ptr %2284, ptr %MEMORY, align 8
  %2285 = load i64, ptr %NEXT_PC, align 8
  store i64 %2285, ptr %PC, align 8
  %2286 = add i64 %2285, 1
  store i64 %2286, ptr %NEXT_PC, align 8
  %2287 = load ptr, ptr %MEMORY, align 8
  %2288 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2287, ptr %state, ptr undef)
  store ptr %2288, ptr %MEMORY, align 8
  %2289 = load i64, ptr %NEXT_PC, align 8
  store i64 %2289, ptr %PC, align 8
  %2290 = add i64 %2289, 1
  store i64 %2290, ptr %NEXT_PC, align 8
  %2291 = load ptr, ptr %MEMORY, align 8
  %2292 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2291, ptr %state, ptr undef)
  store ptr %2292, ptr %MEMORY, align 8
  %2293 = load i64, ptr %NEXT_PC, align 8
  store i64 %2293, ptr %PC, align 8
  %2294 = add i64 %2293, 1
  store i64 %2294, ptr %NEXT_PC, align 8
  %2295 = load ptr, ptr %MEMORY, align 8
  %2296 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2295, ptr %state, ptr undef)
  store ptr %2296, ptr %MEMORY, align 8
  %2297 = load i64, ptr %NEXT_PC, align 8
  store i64 %2297, ptr %PC, align 8
  %2298 = add i64 %2297, 1
  store i64 %2298, ptr %NEXT_PC, align 8
  %2299 = load ptr, ptr %MEMORY, align 8
  %2300 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2299, ptr %state, ptr undef)
  store ptr %2300, ptr %MEMORY, align 8
  %2301 = load i64, ptr %NEXT_PC, align 8
  store i64 %2301, ptr %PC, align 8
  %2302 = add i64 %2301, 1
  store i64 %2302, ptr %NEXT_PC, align 8
  %2303 = load ptr, ptr %MEMORY, align 8
  %2304 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2303, ptr %state, ptr undef)
  store ptr %2304, ptr %MEMORY, align 8
  %2305 = load i64, ptr %NEXT_PC, align 8
  store i64 %2305, ptr %PC, align 8
  %2306 = add i64 %2305, 3
  store i64 %2306, ptr %NEXT_PC, align 8
  %2307 = load i64, ptr %RCX, align 8
  %2308 = add i64 %2307, 32
  %2309 = load ptr, ptr %MEMORY, align 8
  %2310 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %2309, ptr %state, ptr %RAX, i64 %2308)
  store ptr %2310, ptr %MEMORY, align 8
  %2311 = load i64, ptr %NEXT_PC, align 8
  store i64 %2311, ptr %PC, align 8
  %2312 = add i64 %2311, 1
  store i64 %2312, ptr %NEXT_PC, align 8
  %2313 = load ptr, ptr %MEMORY, align 8
  %2314 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %2313, ptr %state, ptr %NEXT_PC)
  store ptr %2314, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658788:                                    ; No predecessors!
  %2315 = load i64, ptr %NEXT_PC, align 8
  store i64 %2315, ptr %PC, align 8
  %2316 = add i64 %2315, 1
  store i64 %2316, ptr %NEXT_PC, align 8
  %2317 = load ptr, ptr %MEMORY, align 8
  %2318 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2317, ptr %state, ptr undef)
  store ptr %2318, ptr %MEMORY, align 8
  %2319 = load i64, ptr %NEXT_PC, align 8
  store i64 %2319, ptr %PC, align 8
  %2320 = add i64 %2319, 1
  store i64 %2320, ptr %NEXT_PC, align 8
  %2321 = load ptr, ptr %MEMORY, align 8
  %2322 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2321, ptr %state, ptr undef)
  store ptr %2322, ptr %MEMORY, align 8
  %2323 = load i64, ptr %NEXT_PC, align 8
  store i64 %2323, ptr %PC, align 8
  %2324 = add i64 %2323, 1
  store i64 %2324, ptr %NEXT_PC, align 8
  %2325 = load ptr, ptr %MEMORY, align 8
  %2326 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2325, ptr %state, ptr undef)
  store ptr %2326, ptr %MEMORY, align 8
  %2327 = load i64, ptr %NEXT_PC, align 8
  store i64 %2327, ptr %PC, align 8
  %2328 = add i64 %2327, 1
  store i64 %2328, ptr %NEXT_PC, align 8
  %2329 = load ptr, ptr %MEMORY, align 8
  %2330 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2329, ptr %state, ptr undef)
  store ptr %2330, ptr %MEMORY, align 8
  %2331 = load i64, ptr %NEXT_PC, align 8
  store i64 %2331, ptr %PC, align 8
  %2332 = add i64 %2331, 1
  store i64 %2332, ptr %NEXT_PC, align 8
  %2333 = load ptr, ptr %MEMORY, align 8
  %2334 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2333, ptr %state, ptr undef)
  store ptr %2334, ptr %MEMORY, align 8
  %2335 = load i64, ptr %NEXT_PC, align 8
  store i64 %2335, ptr %PC, align 8
  %2336 = add i64 %2335, 1
  store i64 %2336, ptr %NEXT_PC, align 8
  %2337 = load ptr, ptr %MEMORY, align 8
  %2338 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2337, ptr %state, ptr undef)
  store ptr %2338, ptr %MEMORY, align 8
  %2339 = load i64, ptr %NEXT_PC, align 8
  store i64 %2339, ptr %PC, align 8
  %2340 = add i64 %2339, 1
  store i64 %2340, ptr %NEXT_PC, align 8
  %2341 = load ptr, ptr %MEMORY, align 8
  %2342 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2341, ptr %state, ptr undef)
  store ptr %2342, ptr %MEMORY, align 8
  %2343 = load i64, ptr %NEXT_PC, align 8
  store i64 %2343, ptr %PC, align 8
  %2344 = add i64 %2343, 1
  store i64 %2344, ptr %NEXT_PC, align 8
  %2345 = load ptr, ptr %MEMORY, align 8
  %2346 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2345, ptr %state, ptr undef)
  store ptr %2346, ptr %MEMORY, align 8
  %2347 = load i64, ptr %NEXT_PC, align 8
  store i64 %2347, ptr %PC, align 8
  %2348 = add i64 %2347, 1
  store i64 %2348, ptr %NEXT_PC, align 8
  %2349 = load ptr, ptr %MEMORY, align 8
  %2350 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2349, ptr %state, ptr undef)
  store ptr %2350, ptr %MEMORY, align 8
  %2351 = load i64, ptr %NEXT_PC, align 8
  store i64 %2351, ptr %PC, align 8
  %2352 = add i64 %2351, 1
  store i64 %2352, ptr %NEXT_PC, align 8
  %2353 = load ptr, ptr %MEMORY, align 8
  %2354 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2353, ptr %state, ptr undef)
  store ptr %2354, ptr %MEMORY, align 8
  %2355 = load i64, ptr %NEXT_PC, align 8
  store i64 %2355, ptr %PC, align 8
  %2356 = add i64 %2355, 1
  store i64 %2356, ptr %NEXT_PC, align 8
  %2357 = load ptr, ptr %MEMORY, align 8
  %2358 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2357, ptr %state, ptr undef)
  store ptr %2358, ptr %MEMORY, align 8
  %2359 = load i64, ptr %NEXT_PC, align 8
  store i64 %2359, ptr %PC, align 8
  %2360 = add i64 %2359, 1
  store i64 %2360, ptr %NEXT_PC, align 8
  %2361 = load ptr, ptr %MEMORY, align 8
  %2362 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2361, ptr %state, ptr undef)
  store ptr %2362, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658800:                                    ; preds = %bb_5395658900
  %2363 = load i64, ptr %NEXT_PC, align 8
  store i64 %2363, ptr %PC, align 8
  %2364 = add i64 %2363, 5
  store i64 %2364, ptr %NEXT_PC, align 8
  %2365 = load i64, ptr %RSP, align 8
  %2366 = add i64 %2365, 8
  %2367 = load i64, ptr %RBX, align 8
  %2368 = load ptr, ptr %MEMORY, align 8
  %2369 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2368, ptr %state, i64 %2366, i64 %2367)
  store ptr %2369, ptr %MEMORY, align 8
  %2370 = load i64, ptr %NEXT_PC, align 8
  store i64 %2370, ptr %PC, align 8
  %2371 = add i64 %2370, 5
  store i64 %2371, ptr %NEXT_PC, align 8
  %2372 = load i64, ptr %RSP, align 8
  %2373 = add i64 %2372, 16
  %2374 = load i64, ptr %RSI, align 8
  %2375 = load ptr, ptr %MEMORY, align 8
  %2376 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2375, ptr %state, i64 %2373, i64 %2374)
  store ptr %2376, ptr %MEMORY, align 8
  %2377 = load i64, ptr %NEXT_PC, align 8
  store i64 %2377, ptr %PC, align 8
  %2378 = add i64 %2377, 1
  store i64 %2378, ptr %NEXT_PC, align 8
  %2379 = load i64, ptr %RDI, align 8
  %2380 = load ptr, ptr %MEMORY, align 8
  %2381 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %2380, ptr %state, i64 %2379)
  store ptr %2381, ptr %MEMORY, align 8
  %2382 = load i64, ptr %NEXT_PC, align 8
  store i64 %2382, ptr %PC, align 8
  %2383 = add i64 %2382, 4
  store i64 %2383, ptr %NEXT_PC, align 8
  %2384 = load i64, ptr %RSP, align 8
  %2385 = load ptr, ptr %MEMORY, align 8
  %2386 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2385, ptr %state, ptr %RSP, i64 %2384, i64 32)
  store ptr %2386, ptr %MEMORY, align 8
  %2387 = load i64, ptr %NEXT_PC, align 8
  store i64 %2387, ptr %PC, align 8
  %2388 = add i64 %2387, 2
  store i64 %2388, ptr %NEXT_PC, align 8
  %2389 = load i32, ptr %EDX, align 4
  %2390 = zext i32 %2389 to i64
  %2391 = load ptr, ptr %MEMORY, align 8
  %2392 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2391, ptr %state, ptr %RDI, i64 %2390)
  store ptr %2392, ptr %MEMORY, align 8
  %2393 = load i64, ptr %NEXT_PC, align 8
  store i64 %2393, ptr %PC, align 8
  %2394 = add i64 %2393, 3
  store i64 %2394, ptr %NEXT_PC, align 8
  %2395 = load i64, ptr %RCX, align 8
  %2396 = load ptr, ptr %MEMORY, align 8
  %2397 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2396, ptr %state, ptr %RSI, i64 %2395)
  store ptr %2397, ptr %MEMORY, align 8
  %2398 = load i64, ptr %NEXT_PC, align 8
  store i64 %2398, ptr %PC, align 8
  %2399 = add i64 %2398, 3
  store i64 %2399, ptr %NEXT_PC, align 8
  %2400 = load i64, ptr %RCX, align 8
  %2401 = load ptr, ptr %MEMORY, align 8
  %2402 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2401, ptr %state, ptr %RBX, i64 %2400)
  store ptr %2402, ptr %MEMORY, align 8
  %2403 = load i64, ptr %NEXT_PC, align 8
  store i64 %2403, ptr %PC, align 8
  %2404 = add i64 %2403, 5
  store i64 %2404, ptr %NEXT_PC, align 8
  %2405 = load i64, ptr %NEXT_PC, align 8
  %2406 = add i64 %2405, 484
  %2407 = load i64, ptr %NEXT_PC, align 8
  %2408 = load ptr, ptr %MEMORY, align 8
  %2409 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2408, ptr %state, i64 %2406, ptr %NEXT_PC, i64 %2407, ptr %RETURN_PC)
  store ptr %2409, ptr %MEMORY, align 8
  %2410 = load i64, ptr %NEXT_PC, align 8
  store i64 %2410, ptr %PC, align 8
  %2411 = add i64 %2410, 2
  store i64 %2411, ptr %NEXT_PC, align 8
  %2412 = load i64, ptr %RDI, align 8
  %2413 = load i32, ptr %EAX, align 4
  %2414 = zext i32 %2413 to i64
  %2415 = load ptr, ptr %MEMORY, align 8
  %2416 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2415, ptr %state, ptr %RDI, i64 %2412, i64 %2414)
  store ptr %2416, ptr %MEMORY, align 8
  %2417 = load i64, ptr %NEXT_PC, align 8
  store i64 %2417, ptr %PC, align 8
  %2418 = add i64 %2417, 3
  store i64 %2418, ptr %NEXT_PC, align 8
  %2419 = load i64, ptr %RBX, align 8
  %2420 = load i64, ptr %RBX, align 8
  %2421 = load ptr, ptr %MEMORY, align 8
  %2422 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2421, ptr %state, i64 %2419, i64 %2420)
  store ptr %2422, ptr %MEMORY, align 8
  %2423 = load i64, ptr %NEXT_PC, align 8
  store i64 %2423, ptr %PC, align 8
  %2424 = add i64 %2423, 2
  store i64 %2424, ptr %NEXT_PC, align 8
  %2425 = load i64, ptr %NEXT_PC, align 8
  %2426 = add i64 %2425, 14
  %2427 = load i64, ptr %NEXT_PC, align 8
  %2428 = load ptr, ptr %MEMORY, align 8
  %2429 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2428, ptr %state, ptr %BRANCH_TAKEN, i64 %2426, i64 %2427, ptr %NEXT_PC)
  store ptr %2429, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658849, label %bb_5395658835

bb_5395658835:                                    ; preds = %bb_5395658840, %bb_5395658800
  %2430 = load i64, ptr %NEXT_PC, align 8
  store i64 %2430, ptr %PC, align 8
  %2431 = add i64 %2430, 3
  store i64 %2431, ptr %NEXT_PC, align 8
  %2432 = load i64, ptr %RDI, align 8
  %2433 = load i64, ptr %RBX, align 8
  %2434 = add i64 %2433, 48
  %2435 = load ptr, ptr %MEMORY, align 8
  %2436 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2435, ptr %state, ptr %RDI, i64 %2432, i64 %2434)
  store ptr %2436, ptr %MEMORY, align 8
  %2437 = load i64, ptr %NEXT_PC, align 8
  store i64 %2437, ptr %PC, align 8
  %2438 = add i64 %2437, 2
  store i64 %2438, ptr %NEXT_PC, align 8
  %2439 = load i64, ptr %NEXT_PC, align 8
  %2440 = add i64 %2439, 29
  %2441 = load i64, ptr %NEXT_PC, align 8
  %2442 = load ptr, ptr %MEMORY, align 8
  %2443 = call ptr @_ZN12_GLOBAL__N_13JNSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2442, ptr %state, ptr %BRANCH_TAKEN, i64 %2440, i64 %2441, ptr %NEXT_PC)
  store ptr %2443, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658869, label %bb_5395658840

bb_5395658840:                                    ; preds = %bb_5395658835
  %2444 = load i64, ptr %NEXT_PC, align 8
  store i64 %2444, ptr %PC, align 8
  %2445 = add i64 %2444, 4
  store i64 %2445, ptr %NEXT_PC, align 8
  %2446 = load i64, ptr %RBX, align 8
  %2447 = add i64 %2446, 8
  %2448 = load ptr, ptr %MEMORY, align 8
  %2449 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2448, ptr %state, ptr %RBX, i64 %2447)
  store ptr %2449, ptr %MEMORY, align 8
  %2450 = load i64, ptr %NEXT_PC, align 8
  store i64 %2450, ptr %PC, align 8
  %2451 = add i64 %2450, 3
  store i64 %2451, ptr %NEXT_PC, align 8
  %2452 = load i64, ptr %RBX, align 8
  %2453 = load i64, ptr %RBX, align 8
  %2454 = load ptr, ptr %MEMORY, align 8
  %2455 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2454, ptr %state, i64 %2452, i64 %2453)
  store ptr %2455, ptr %MEMORY, align 8
  %2456 = load i64, ptr %NEXT_PC, align 8
  store i64 %2456, ptr %PC, align 8
  %2457 = add i64 %2456, 2
  store i64 %2457, ptr %NEXT_PC, align 8
  %2458 = load i64, ptr %NEXT_PC, align 8
  %2459 = sub i64 %2458, 14
  %2460 = load i64, ptr %NEXT_PC, align 8
  %2461 = load ptr, ptr %MEMORY, align 8
  %2462 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2461, ptr %state, ptr %BRANCH_TAKEN, i64 %2459, i64 %2460, ptr %NEXT_PC)
  store ptr %2462, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658835, label %bb_5395658849

bb_5395658849:                                    ; preds = %bb_5395658840, %bb_5395658800
  %2463 = load i64, ptr %NEXT_PC, align 8
  store i64 %2463, ptr %PC, align 8
  %2464 = add i64 %2463, 4
  store i64 %2464, ptr %NEXT_PC, align 8
  %2465 = load i64, ptr %RSI, align 8
  %2466 = add i64 %2465, 40
  %2467 = load ptr, ptr %MEMORY, align 8
  %2468 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2467, ptr %state, ptr %RAX, i64 %2466)
  store ptr %2468, ptr %MEMORY, align 8
  %2469 = load i64, ptr %NEXT_PC, align 8
  store i64 %2469, ptr %PC, align 8
  %2470 = add i64 %2469, 5
  store i64 %2470, ptr %NEXT_PC, align 8
  %2471 = load i64, ptr %RSP, align 8
  %2472 = add i64 %2471, 48
  %2473 = load ptr, ptr %MEMORY, align 8
  %2474 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2473, ptr %state, ptr %RBX, i64 %2472)
  store ptr %2474, ptr %MEMORY, align 8
  %2475 = load i64, ptr %NEXT_PC, align 8
  store i64 %2475, ptr %PC, align 8
  %2476 = add i64 %2475, 5
  store i64 %2476, ptr %NEXT_PC, align 8
  %2477 = load i64, ptr %RSP, align 8
  %2478 = add i64 %2477, 56
  %2479 = load ptr, ptr %MEMORY, align 8
  %2480 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2479, ptr %state, ptr %RSI, i64 %2478)
  store ptr %2480, ptr %MEMORY, align 8
  %2481 = load i64, ptr %NEXT_PC, align 8
  store i64 %2481, ptr %PC, align 8
  %2482 = add i64 %2481, 4
  store i64 %2482, ptr %NEXT_PC, align 8
  %2483 = load i64, ptr %RSP, align 8
  %2484 = load ptr, ptr %MEMORY, align 8
  %2485 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2484, ptr %state, ptr %RSP, i64 %2483, i64 32)
  store ptr %2485, ptr %MEMORY, align 8
  %2486 = load i64, ptr %NEXT_PC, align 8
  store i64 %2486, ptr %PC, align 8
  %2487 = add i64 %2486, 1
  store i64 %2487, ptr %NEXT_PC, align 8
  %2488 = load ptr, ptr %MEMORY, align 8
  %2489 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %2488, ptr %state, ptr %RDI)
  store ptr %2489, ptr %MEMORY, align 8
  %2490 = load i64, ptr %NEXT_PC, align 8
  store i64 %2490, ptr %PC, align 8
  %2491 = add i64 %2490, 1
  store i64 %2491, ptr %NEXT_PC, align 8
  %2492 = load ptr, ptr %MEMORY, align 8
  %2493 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %2492, ptr %state, ptr %NEXT_PC)
  store ptr %2493, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658869:                                    ; preds = %bb_5395658835
  %2494 = load i64, ptr %NEXT_PC, align 8
  store i64 %2494, ptr %PC, align 8
  %2495 = add i64 %2494, 5
  store i64 %2495, ptr %NEXT_PC, align 8
  %2496 = load i64, ptr %RSP, align 8
  %2497 = add i64 %2496, 56
  %2498 = load ptr, ptr %MEMORY, align 8
  %2499 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2498, ptr %state, ptr %RSI, i64 %2497)
  store ptr %2499, ptr %MEMORY, align 8
  %2500 = load i64, ptr %NEXT_PC, align 8
  store i64 %2500, ptr %PC, align 8
  %2501 = add i64 %2500, 3
  store i64 %2501, ptr %NEXT_PC, align 8
  %2502 = load i32, ptr %EDI, align 4
  %2503 = zext i32 %2502 to i64
  %2504 = load ptr, ptr %MEMORY, align 8
  %2505 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %2504, ptr %state, ptr %RAX, i64 %2503)
  store ptr %2505, ptr %MEMORY, align 8
  %2506 = load i64, ptr %NEXT_PC, align 8
  store i64 %2506, ptr %PC, align 8
  %2507 = add i64 %2506, 4
  store i64 %2507, ptr %NEXT_PC, align 8
  %2508 = load i64, ptr %RAX, align 8
  %2509 = load i64, ptr %RAX, align 8
  %2510 = mul i64 %2509, 4
  %2511 = add i64 %2508, %2510
  %2512 = load ptr, ptr %MEMORY, align 8
  %2513 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %2512, ptr %state, ptr %RCX, i64 %2511)
  store ptr %2513, ptr %MEMORY, align 8
  %2514 = load i64, ptr %NEXT_PC, align 8
  store i64 %2514, ptr %PC, align 8
  %2515 = add i64 %2514, 4
  store i64 %2515, ptr %NEXT_PC, align 8
  %2516 = load i64, ptr %RBX, align 8
  %2517 = add i64 %2516, 40
  %2518 = load ptr, ptr %MEMORY, align 8
  %2519 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2518, ptr %state, ptr %RAX, i64 %2517)
  store ptr %2519, ptr %MEMORY, align 8
  %2520 = load i64, ptr %NEXT_PC, align 8
  store i64 %2520, ptr %PC, align 8
  %2521 = add i64 %2520, 5
  store i64 %2521, ptr %NEXT_PC, align 8
  %2522 = load i64, ptr %RSP, align 8
  %2523 = add i64 %2522, 48
  %2524 = load ptr, ptr %MEMORY, align 8
  %2525 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2524, ptr %state, ptr %RBX, i64 %2523)
  store ptr %2525, ptr %MEMORY, align 8
  %2526 = load i64, ptr %NEXT_PC, align 8
  store i64 %2526, ptr %PC, align 8
  %2527 = add i64 %2526, 4
  store i64 %2527, ptr %NEXT_PC, align 8
  %2528 = load i64, ptr %RAX, align 8
  %2529 = load i64, ptr %RCX, align 8
  %2530 = mul i64 %2529, 8
  %2531 = add i64 %2528, %2530
  %2532 = load ptr, ptr %MEMORY, align 8
  %2533 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %2532, ptr %state, ptr %RAX, i64 %2531)
  store ptr %2533, ptr %MEMORY, align 8
  %2534 = load i64, ptr %NEXT_PC, align 8
  store i64 %2534, ptr %PC, align 8
  %2535 = add i64 %2534, 4
  store i64 %2535, ptr %NEXT_PC, align 8
  %2536 = load i64, ptr %RSP, align 8
  %2537 = load ptr, ptr %MEMORY, align 8
  %2538 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2537, ptr %state, ptr %RSP, i64 %2536, i64 32)
  store ptr %2538, ptr %MEMORY, align 8
  %2539 = load i64, ptr %NEXT_PC, align 8
  store i64 %2539, ptr %PC, align 8
  %2540 = add i64 %2539, 1
  store i64 %2540, ptr %NEXT_PC, align 8
  %2541 = load ptr, ptr %MEMORY, align 8
  %2542 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %2541, ptr %state, ptr %RDI)
  store ptr %2542, ptr %MEMORY, align 8
  %2543 = load i64, ptr %NEXT_PC, align 8
  store i64 %2543, ptr %PC, align 8
  %2544 = add i64 %2543, 1
  store i64 %2544, ptr %NEXT_PC, align 8
  %2545 = load ptr, ptr %MEMORY, align 8
  %2546 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %2545, ptr %state, ptr %NEXT_PC)
  store ptr %2546, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395658900:                                    ; No predecessors!
  %2547 = load i64, ptr %NEXT_PC, align 8
  store i64 %2547, ptr %PC, align 8
  %2548 = add i64 %2547, 1
  store i64 %2548, ptr %NEXT_PC, align 8
  %2549 = load ptr, ptr %MEMORY, align 8
  %2550 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2549, ptr %state, ptr undef)
  store ptr %2550, ptr %MEMORY, align 8
  %2551 = load i64, ptr %NEXT_PC, align 8
  store i64 %2551, ptr %PC, align 8
  %2552 = add i64 %2551, 1
  store i64 %2552, ptr %NEXT_PC, align 8
  %2553 = load ptr, ptr %MEMORY, align 8
  %2554 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2553, ptr %state, ptr undef)
  store ptr %2554, ptr %MEMORY, align 8
  %2555 = load i64, ptr %NEXT_PC, align 8
  store i64 %2555, ptr %PC, align 8
  %2556 = add i64 %2555, 1
  store i64 %2556, ptr %NEXT_PC, align 8
  %2557 = load ptr, ptr %MEMORY, align 8
  %2558 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2557, ptr %state, ptr undef)
  store ptr %2558, ptr %MEMORY, align 8
  %2559 = load i64, ptr %NEXT_PC, align 8
  store i64 %2559, ptr %PC, align 8
  %2560 = add i64 %2559, 1
  store i64 %2560, ptr %NEXT_PC, align 8
  %2561 = load ptr, ptr %MEMORY, align 8
  %2562 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2561, ptr %state, ptr undef)
  store ptr %2562, ptr %MEMORY, align 8
  %2563 = load i64, ptr %NEXT_PC, align 8
  store i64 %2563, ptr %PC, align 8
  %2564 = add i64 %2563, 1
  store i64 %2564, ptr %NEXT_PC, align 8
  %2565 = load ptr, ptr %MEMORY, align 8
  %2566 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2565, ptr %state, ptr undef)
  store ptr %2566, ptr %MEMORY, align 8
  %2567 = load i64, ptr %NEXT_PC, align 8
  store i64 %2567, ptr %PC, align 8
  %2568 = add i64 %2567, 1
  store i64 %2568, ptr %NEXT_PC, align 8
  %2569 = load ptr, ptr %MEMORY, align 8
  %2570 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2569, ptr %state, ptr undef)
  store ptr %2570, ptr %MEMORY, align 8
  %2571 = load i64, ptr %NEXT_PC, align 8
  store i64 %2571, ptr %PC, align 8
  %2572 = add i64 %2571, 1
  store i64 %2572, ptr %NEXT_PC, align 8
  %2573 = load ptr, ptr %MEMORY, align 8
  %2574 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2573, ptr %state, ptr undef)
  store ptr %2574, ptr %MEMORY, align 8
  %2575 = load i64, ptr %NEXT_PC, align 8
  store i64 %2575, ptr %PC, align 8
  %2576 = add i64 %2575, 1
  store i64 %2576, ptr %NEXT_PC, align 8
  %2577 = load ptr, ptr %MEMORY, align 8
  %2578 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2577, ptr %state, ptr undef)
  store ptr %2578, ptr %MEMORY, align 8
  %2579 = load i64, ptr %NEXT_PC, align 8
  store i64 %2579, ptr %PC, align 8
  %2580 = add i64 %2579, 1
  store i64 %2580, ptr %NEXT_PC, align 8
  %2581 = load ptr, ptr %MEMORY, align 8
  %2582 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2581, ptr %state, ptr undef)
  store ptr %2582, ptr %MEMORY, align 8
  %2583 = load i64, ptr %NEXT_PC, align 8
  store i64 %2583, ptr %PC, align 8
  %2584 = add i64 %2583, 1
  store i64 %2584, ptr %NEXT_PC, align 8
  %2585 = load ptr, ptr %MEMORY, align 8
  %2586 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2585, ptr %state, ptr undef)
  store ptr %2586, ptr %MEMORY, align 8
  %2587 = load i64, ptr %NEXT_PC, align 8
  store i64 %2587, ptr %PC, align 8
  %2588 = add i64 %2587, 1
  store i64 %2588, ptr %NEXT_PC, align 8
  %2589 = load ptr, ptr %MEMORY, align 8
  %2590 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2589, ptr %state, ptr undef)
  store ptr %2590, ptr %MEMORY, align 8
  %2591 = load i64, ptr %NEXT_PC, align 8
  store i64 %2591, ptr %PC, align 8
  %2592 = add i64 %2591, 1
  store i64 %2592, ptr %NEXT_PC, align 8
  %2593 = load ptr, ptr %MEMORY, align 8
  %2594 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2593, ptr %state, ptr undef)
  store ptr %2594, ptr %MEMORY, align 8
  %2595 = load i64, ptr %NEXT_PC, align 8
  store i64 %2595, ptr %PC, align 8
  %2596 = add i64 %2595, 5
  store i64 %2596, ptr %NEXT_PC, align 8
  %2597 = load i64, ptr %NEXT_PC, align 8
  %2598 = sub i64 %2597, 117
  %2599 = load ptr, ptr %MEMORY, align 8
  %2600 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %2599, ptr %state, i64 %2598, ptr %NEXT_PC)
  store ptr %2600, ptr %MEMORY, align 8
  br label %bb_5395658800
  %2601 = load i64, ptr %NEXT_PC, align 8
  store i64 %2601, ptr %PC, align 8
  %2602 = add i64 %2601, 1
  store i64 %2602, ptr %NEXT_PC, align 8
  %2603 = load ptr, ptr %MEMORY, align 8
  %2604 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2603, ptr %state, ptr undef)
  store ptr %2604, ptr %MEMORY, align 8
  %2605 = load i64, ptr %NEXT_PC, align 8
  store i64 %2605, ptr %PC, align 8
  %2606 = add i64 %2605, 1
  store i64 %2606, ptr %NEXT_PC, align 8
  %2607 = load ptr, ptr %MEMORY, align 8
  %2608 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2607, ptr %state, ptr undef)
  store ptr %2608, ptr %MEMORY, align 8
  %2609 = load i64, ptr %NEXT_PC, align 8
  store i64 %2609, ptr %PC, align 8
  %2610 = add i64 %2609, 1
  store i64 %2610, ptr %NEXT_PC, align 8
  %2611 = load ptr, ptr %MEMORY, align 8
  %2612 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2611, ptr %state, ptr undef)
  store ptr %2612, ptr %MEMORY, align 8
  %2613 = load i64, ptr %NEXT_PC, align 8
  store i64 %2613, ptr %PC, align 8
  %2614 = add i64 %2613, 1
  store i64 %2614, ptr %NEXT_PC, align 8
  %2615 = load ptr, ptr %MEMORY, align 8
  %2616 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2615, ptr %state, ptr undef)
  store ptr %2616, ptr %MEMORY, align 8
  %2617 = load i64, ptr %NEXT_PC, align 8
  store i64 %2617, ptr %PC, align 8
  %2618 = add i64 %2617, 1
  store i64 %2618, ptr %NEXT_PC, align 8
  %2619 = load ptr, ptr %MEMORY, align 8
  %2620 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2619, ptr %state, ptr undef)
  store ptr %2620, ptr %MEMORY, align 8
  %2621 = load i64, ptr %NEXT_PC, align 8
  store i64 %2621, ptr %PC, align 8
  %2622 = add i64 %2621, 1
  store i64 %2622, ptr %NEXT_PC, align 8
  %2623 = load ptr, ptr %MEMORY, align 8
  %2624 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2623, ptr %state, ptr undef)
  store ptr %2624, ptr %MEMORY, align 8
  %2625 = load i64, ptr %NEXT_PC, align 8
  store i64 %2625, ptr %PC, align 8
  %2626 = add i64 %2625, 1
  store i64 %2626, ptr %NEXT_PC, align 8
  %2627 = load ptr, ptr %MEMORY, align 8
  %2628 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2627, ptr %state, ptr undef)
  store ptr %2628, ptr %MEMORY, align 8
  %2629 = load i64, ptr %NEXT_PC, align 8
  store i64 %2629, ptr %PC, align 8
  %2630 = add i64 %2629, 1
  store i64 %2630, ptr %NEXT_PC, align 8
  %2631 = load ptr, ptr %MEMORY, align 8
  %2632 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2631, ptr %state, ptr undef)
  store ptr %2632, ptr %MEMORY, align 8
  %2633 = load i64, ptr %NEXT_PC, align 8
  store i64 %2633, ptr %PC, align 8
  %2634 = add i64 %2633, 1
  store i64 %2634, ptr %NEXT_PC, align 8
  %2635 = load ptr, ptr %MEMORY, align 8
  %2636 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2635, ptr %state, ptr undef)
  store ptr %2636, ptr %MEMORY, align 8
  %2637 = load i64, ptr %NEXT_PC, align 8
  store i64 %2637, ptr %PC, align 8
  %2638 = add i64 %2637, 1
  store i64 %2638, ptr %NEXT_PC, align 8
  %2639 = load ptr, ptr %MEMORY, align 8
  %2640 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2639, ptr %state, ptr undef)
  store ptr %2640, ptr %MEMORY, align 8
  %2641 = load i64, ptr %NEXT_PC, align 8
  store i64 %2641, ptr %PC, align 8
  %2642 = add i64 %2641, 1
  store i64 %2642, ptr %NEXT_PC, align 8
  %2643 = load ptr, ptr %MEMORY, align 8
  %2644 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2643, ptr %state, ptr undef)
  store ptr %2644, ptr %MEMORY, align 8
  %2645 = load i64, ptr %NEXT_PC, align 8
  store i64 %2645, ptr %PC, align 8
  %2646 = add i64 %2645, 5
  store i64 %2646, ptr %NEXT_PC, align 8
  %2647 = load i64, ptr %RSP, align 8
  %2648 = add i64 %2647, 8
  %2649 = load i64, ptr %RBX, align 8
  %2650 = load ptr, ptr %MEMORY, align 8
  %2651 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2650, ptr %state, i64 %2648, i64 %2649)
  store ptr %2651, ptr %MEMORY, align 8
  %2652 = load i64, ptr %NEXT_PC, align 8
  store i64 %2652, ptr %PC, align 8
  %2653 = add i64 %2652, 5
  store i64 %2653, ptr %NEXT_PC, align 8
  %2654 = load i64, ptr %RSP, align 8
  %2655 = add i64 %2654, 16
  %2656 = load i64, ptr %RBP, align 8
  %2657 = load ptr, ptr %MEMORY, align 8
  %2658 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2657, ptr %state, i64 %2655, i64 %2656)
  store ptr %2658, ptr %MEMORY, align 8
  %2659 = load i64, ptr %NEXT_PC, align 8
  store i64 %2659, ptr %PC, align 8
  %2660 = add i64 %2659, 5
  store i64 %2660, ptr %NEXT_PC, align 8
  %2661 = load i64, ptr %RSP, align 8
  %2662 = add i64 %2661, 24
  %2663 = load i64, ptr %RSI, align 8
  %2664 = load ptr, ptr %MEMORY, align 8
  %2665 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2664, ptr %state, i64 %2662, i64 %2663)
  store ptr %2665, ptr %MEMORY, align 8
  %2666 = load i64, ptr %NEXT_PC, align 8
  store i64 %2666, ptr %PC, align 8
  %2667 = add i64 %2666, 1
  store i64 %2667, ptr %NEXT_PC, align 8
  %2668 = load i64, ptr %RDI, align 8
  %2669 = load ptr, ptr %MEMORY, align 8
  %2670 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %2669, ptr %state, i64 %2668)
  store ptr %2670, ptr %MEMORY, align 8
  %2671 = load i64, ptr %NEXT_PC, align 8
  store i64 %2671, ptr %PC, align 8
  %2672 = add i64 %2671, 4
  store i64 %2672, ptr %NEXT_PC, align 8
  %2673 = load i64, ptr %RSP, align 8
  %2674 = load ptr, ptr %MEMORY, align 8
  %2675 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2674, ptr %state, ptr %RSP, i64 %2673, i64 32)
  store ptr %2675, ptr %MEMORY, align 8
  %2676 = load i64, ptr %NEXT_PC, align 8
  store i64 %2676, ptr %PC, align 8
  %2677 = add i64 %2676, 3
  store i64 %2677, ptr %NEXT_PC, align 8
  %2678 = load i64, ptr %RDX, align 8
  %2679 = load ptr, ptr %MEMORY, align 8
  %2680 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2679, ptr %state, ptr %RBP, i64 %2678)
  store ptr %2680, ptr %MEMORY, align 8
  %2681 = load i64, ptr %NEXT_PC, align 8
  store i64 %2681, ptr %PC, align 8
  %2682 = add i64 %2681, 3
  store i64 %2682, ptr %NEXT_PC, align 8
  %2683 = load i64, ptr %RCX, align 8
  %2684 = load ptr, ptr %MEMORY, align 8
  %2685 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2684, ptr %state, ptr %RDI, i64 %2683)
  store ptr %2685, ptr %MEMORY, align 8
  %2686 = load i64, ptr %NEXT_PC, align 8
  store i64 %2686, ptr %PC, align 8
  %2687 = add i64 %2686, 2
  store i64 %2687, ptr %NEXT_PC, align 8
  %2688 = load i64, ptr %RBX, align 8
  %2689 = load i32, ptr %EBX, align 4
  %2690 = zext i32 %2689 to i64
  %2691 = load ptr, ptr %MEMORY, align 8
  %2692 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2691, ptr %state, ptr %RBX, i64 %2688, i64 %2690)
  store ptr %2692, ptr %MEMORY, align 8
  %2693 = load i64, ptr %NEXT_PC, align 8
  store i64 %2693, ptr %PC, align 8
  %2694 = add i64 %2693, 5
  store i64 %2694, ptr %NEXT_PC, align 8
  %2695 = load i64, ptr %NEXT_PC, align 8
  %2696 = add i64 %2695, 351
  %2697 = load i64, ptr %NEXT_PC, align 8
  %2698 = load ptr, ptr %MEMORY, align 8
  %2699 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2698, ptr %state, i64 %2696, ptr %NEXT_PC, i64 %2697, ptr %RETURN_PC)
  store ptr %2699, ptr %MEMORY, align 8
  %2700 = load i64, ptr %NEXT_PC, align 8
  store i64 %2700, ptr %PC, align 8
  %2701 = add i64 %2700, 2
  store i64 %2701, ptr %NEXT_PC, align 8
  %2702 = load i32, ptr %EAX, align 4
  %2703 = zext i32 %2702 to i64
  %2704 = load i32, ptr %EAX, align 4
  %2705 = zext i32 %2704 to i64
  %2706 = load ptr, ptr %MEMORY, align 8
  %2707 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2706, ptr %state, i64 %2703, i64 %2705)
  store ptr %2707, ptr %MEMORY, align 8
  %2708 = load i64, ptr %NEXT_PC, align 8
  store i64 %2708, ptr %PC, align 8
  %2709 = add i64 %2708, 2
  store i64 %2709, ptr %NEXT_PC, align 8
  %2710 = load i64, ptr %NEXT_PC, align 8
  %2711 = add i64 %2710, 42
  %2712 = load i64, ptr %NEXT_PC, align 8
  %2713 = load ptr, ptr %MEMORY, align 8
  %2714 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2713, ptr %state, ptr %BRANCH_TAKEN, i64 %2711, i64 %2712, ptr %NEXT_PC)
  store ptr %2714, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659007, label %bb_5395658965

bb_5395658965:                                    ; preds = %bb_5395658993, %bb_5395658900
  %2715 = load i64, ptr %NEXT_PC, align 8
  store i64 %2715, ptr %PC, align 8
  %2716 = add i64 %2715, 2
  store i64 %2716, ptr %NEXT_PC, align 8
  %2717 = load i32, ptr %EBX, align 4
  %2718 = zext i32 %2717 to i64
  %2719 = load ptr, ptr %MEMORY, align 8
  %2720 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2719, ptr %state, ptr %RDX, i64 %2718)
  store ptr %2720, ptr %MEMORY, align 8
  %2721 = load i64, ptr %NEXT_PC, align 8
  store i64 %2721, ptr %PC, align 8
  %2722 = add i64 %2721, 3
  store i64 %2722, ptr %NEXT_PC, align 8
  %2723 = load i64, ptr %RDI, align 8
  %2724 = load ptr, ptr %MEMORY, align 8
  %2725 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2724, ptr %state, ptr %RCX, i64 %2723)
  store ptr %2725, ptr %MEMORY, align 8
  %2726 = load i64, ptr %NEXT_PC, align 8
  store i64 %2726, ptr %PC, align 8
  %2727 = add i64 %2726, 5
  store i64 %2727, ptr %NEXT_PC, align 8
  %2728 = load i64, ptr %NEXT_PC, align 8
  %2729 = sub i64 %2728, 175
  %2730 = load i64, ptr %NEXT_PC, align 8
  %2731 = load ptr, ptr %MEMORY, align 8
  %2732 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2731, ptr %state, i64 %2729, ptr %NEXT_PC, i64 %2730, ptr %RETURN_PC)
  store ptr %2732, ptr %MEMORY, align 8
  %2733 = load i64, ptr %NEXT_PC, align 8
  store i64 %2733, ptr %PC, align 8
  %2734 = add i64 %2733, 3
  store i64 %2734, ptr %NEXT_PC, align 8
  %2735 = load i64, ptr %RBP, align 8
  %2736 = load ptr, ptr %MEMORY, align 8
  %2737 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2736, ptr %state, ptr %RDX, i64 %2735)
  store ptr %2737, ptr %MEMORY, align 8
  %2738 = load i64, ptr %NEXT_PC, align 8
  store i64 %2738, ptr %PC, align 8
  %2739 = add i64 %2738, 3
  store i64 %2739, ptr %NEXT_PC, align 8
  %2740 = load i64, ptr %RAX, align 8
  %2741 = load ptr, ptr %MEMORY, align 8
  %2742 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2741, ptr %state, ptr %RSI, i64 %2740)
  store ptr %2742, ptr %MEMORY, align 8
  %2743 = load i64, ptr %NEXT_PC, align 8
  store i64 %2743, ptr %PC, align 8
  %2744 = add i64 %2743, 3
  store i64 %2744, ptr %NEXT_PC, align 8
  %2745 = load i64, ptr %RAX, align 8
  %2746 = load ptr, ptr %MEMORY, align 8
  %2747 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2746, ptr %state, ptr %RCX, i64 %2745)
  store ptr %2747, ptr %MEMORY, align 8
  %2748 = load i64, ptr %NEXT_PC, align 8
  store i64 %2748, ptr %PC, align 8
  %2749 = add i64 %2748, 5
  store i64 %2749, ptr %NEXT_PC, align 8
  %2750 = load i64, ptr %NEXT_PC, align 8
  %2751 = add i64 %2750, 45331
  %2752 = load i64, ptr %NEXT_PC, align 8
  %2753 = load ptr, ptr %MEMORY, align 8
  %2754 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2753, ptr %state, i64 %2751, ptr %NEXT_PC, i64 %2752, ptr %RETURN_PC)
  store ptr %2754, ptr %MEMORY, align 8
  %2755 = load i64, ptr %NEXT_PC, align 8
  store i64 %2755, ptr %PC, align 8
  %2756 = add i64 %2755, 2
  store i64 %2756, ptr %NEXT_PC, align 8
  %2757 = load i32, ptr %EAX, align 4
  %2758 = zext i32 %2757 to i64
  %2759 = load i32, ptr %EAX, align 4
  %2760 = zext i32 %2759 to i64
  %2761 = load ptr, ptr %MEMORY, align 8
  %2762 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2761, ptr %state, i64 %2758, i64 %2760)
  store ptr %2762, ptr %MEMORY, align 8
  %2763 = load i64, ptr %NEXT_PC, align 8
  store i64 %2763, ptr %PC, align 8
  %2764 = add i64 %2763, 2
  store i64 %2764, ptr %NEXT_PC, align 8
  %2765 = load i64, ptr %NEXT_PC, align 8
  %2766 = add i64 %2765, 37
  %2767 = load i64, ptr %NEXT_PC, align 8
  %2768 = load ptr, ptr %MEMORY, align 8
  %2769 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2768, ptr %state, ptr %BRANCH_TAKEN, i64 %2766, i64 %2767, ptr %NEXT_PC)
  store ptr %2769, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659030, label %bb_5395658993

bb_5395658993:                                    ; preds = %bb_5395658965
  %2770 = load i64, ptr %NEXT_PC, align 8
  store i64 %2770, ptr %PC, align 8
  %2771 = add i64 %2770, 3
  store i64 %2771, ptr %NEXT_PC, align 8
  %2772 = load i64, ptr %RDI, align 8
  %2773 = load ptr, ptr %MEMORY, align 8
  %2774 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2773, ptr %state, ptr %RCX, i64 %2772)
  store ptr %2774, ptr %MEMORY, align 8
  %2775 = load i64, ptr %NEXT_PC, align 8
  store i64 %2775, ptr %PC, align 8
  %2776 = add i64 %2775, 2
  store i64 %2776, ptr %NEXT_PC, align 8
  %2777 = load i64, ptr %RBX, align 8
  %2778 = load ptr, ptr %MEMORY, align 8
  %2779 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2778, ptr %state, ptr %RBX, i64 %2777)
  store ptr %2779, ptr %MEMORY, align 8
  %2780 = load i64, ptr %NEXT_PC, align 8
  store i64 %2780, ptr %PC, align 8
  %2781 = add i64 %2780, 5
  store i64 %2781, ptr %NEXT_PC, align 8
  %2782 = load i64, ptr %NEXT_PC, align 8
  %2783 = add i64 %2782, 309
  %2784 = load i64, ptr %NEXT_PC, align 8
  %2785 = load ptr, ptr %MEMORY, align 8
  %2786 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2785, ptr %state, i64 %2783, ptr %NEXT_PC, i64 %2784, ptr %RETURN_PC)
  store ptr %2786, ptr %MEMORY, align 8
  %2787 = load i64, ptr %NEXT_PC, align 8
  store i64 %2787, ptr %PC, align 8
  %2788 = add i64 %2787, 2
  store i64 %2788, ptr %NEXT_PC, align 8
  %2789 = load i32, ptr %EBX, align 4
  %2790 = zext i32 %2789 to i64
  %2791 = load i32, ptr %EAX, align 4
  %2792 = zext i32 %2791 to i64
  %2793 = load ptr, ptr %MEMORY, align 8
  %2794 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2793, ptr %state, i64 %2790, i64 %2792)
  store ptr %2794, ptr %MEMORY, align 8
  %2795 = load i64, ptr %NEXT_PC, align 8
  store i64 %2795, ptr %PC, align 8
  %2796 = add i64 %2795, 2
  store i64 %2796, ptr %NEXT_PC, align 8
  %2797 = load i64, ptr %NEXT_PC, align 8
  %2798 = sub i64 %2797, 42
  %2799 = load i64, ptr %NEXT_PC, align 8
  %2800 = load ptr, ptr %MEMORY, align 8
  %2801 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2800, ptr %state, ptr %BRANCH_TAKEN, i64 %2798, i64 %2799, ptr %NEXT_PC)
  store ptr %2801, ptr %MEMORY, align 8
  br i1 true, label %bb_5395658965, label %bb_5395659007

bb_5395659007:                                    ; preds = %bb_5395658993, %bb_5395658900
  %2802 = load i64, ptr %NEXT_PC, align 8
  store i64 %2802, ptr %PC, align 8
  %2803 = add i64 %2802, 2
  store i64 %2803, ptr %NEXT_PC, align 8
  %2804 = load i64, ptr %RAX, align 8
  %2805 = load i32, ptr %EAX, align 4
  %2806 = zext i32 %2805 to i64
  %2807 = load ptr, ptr %MEMORY, align 8
  %2808 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2807, ptr %state, ptr %RAX, i64 %2804, i64 %2806)
  store ptr %2808, ptr %MEMORY, align 8
  br label %bb_5395659009

bb_5395659009:                                    ; preds = %bb_5395659030, %bb_5395659007
  %2809 = load i64, ptr %NEXT_PC, align 8
  store i64 %2809, ptr %PC, align 8
  %2810 = add i64 %2809, 5
  store i64 %2810, ptr %NEXT_PC, align 8
  %2811 = load i64, ptr %RSP, align 8
  %2812 = add i64 %2811, 48
  %2813 = load ptr, ptr %MEMORY, align 8
  %2814 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2813, ptr %state, ptr %RBX, i64 %2812)
  store ptr %2814, ptr %MEMORY, align 8
  %2815 = load i64, ptr %NEXT_PC, align 8
  store i64 %2815, ptr %PC, align 8
  %2816 = add i64 %2815, 5
  store i64 %2816, ptr %NEXT_PC, align 8
  %2817 = load i64, ptr %RSP, align 8
  %2818 = add i64 %2817, 56
  %2819 = load ptr, ptr %MEMORY, align 8
  %2820 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2819, ptr %state, ptr %RBP, i64 %2818)
  store ptr %2820, ptr %MEMORY, align 8
  %2821 = load i64, ptr %NEXT_PC, align 8
  store i64 %2821, ptr %PC, align 8
  %2822 = add i64 %2821, 5
  store i64 %2822, ptr %NEXT_PC, align 8
  %2823 = load i64, ptr %RSP, align 8
  %2824 = add i64 %2823, 64
  %2825 = load ptr, ptr %MEMORY, align 8
  %2826 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2825, ptr %state, ptr %RSI, i64 %2824)
  store ptr %2826, ptr %MEMORY, align 8
  %2827 = load i64, ptr %NEXT_PC, align 8
  store i64 %2827, ptr %PC, align 8
  %2828 = add i64 %2827, 4
  store i64 %2828, ptr %NEXT_PC, align 8
  %2829 = load i64, ptr %RSP, align 8
  %2830 = load ptr, ptr %MEMORY, align 8
  %2831 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2830, ptr %state, ptr %RSP, i64 %2829, i64 32)
  store ptr %2831, ptr %MEMORY, align 8
  %2832 = load i64, ptr %NEXT_PC, align 8
  store i64 %2832, ptr %PC, align 8
  %2833 = add i64 %2832, 1
  store i64 %2833, ptr %NEXT_PC, align 8
  %2834 = load ptr, ptr %MEMORY, align 8
  %2835 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %2834, ptr %state, ptr %RDI)
  store ptr %2835, ptr %MEMORY, align 8
  %2836 = load i64, ptr %NEXT_PC, align 8
  store i64 %2836, ptr %PC, align 8
  %2837 = add i64 %2836, 1
  store i64 %2837, ptr %NEXT_PC, align 8
  %2838 = load ptr, ptr %MEMORY, align 8
  %2839 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %2838, ptr %state, ptr %NEXT_PC)
  store ptr %2839, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659030:                                    ; preds = %bb_5395658965
  %2840 = load i64, ptr %NEXT_PC, align 8
  store i64 %2840, ptr %PC, align 8
  %2841 = add i64 %2840, 3
  store i64 %2841, ptr %NEXT_PC, align 8
  %2842 = load i64, ptr %RSI, align 8
  %2843 = load ptr, ptr %MEMORY, align 8
  %2844 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2843, ptr %state, ptr %RAX, i64 %2842)
  store ptr %2844, ptr %MEMORY, align 8
  %2845 = load i64, ptr %NEXT_PC, align 8
  store i64 %2845, ptr %PC, align 8
  %2846 = add i64 %2845, 2
  store i64 %2846, ptr %NEXT_PC, align 8
  %2847 = load i64, ptr %NEXT_PC, align 8
  %2848 = sub i64 %2847, 26
  %2849 = load ptr, ptr %MEMORY, align 8
  %2850 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %2849, ptr %state, i64 %2848, ptr %NEXT_PC)
  store ptr %2850, ptr %MEMORY, align 8
  br label %bb_5395659009
  %2851 = load i64, ptr %NEXT_PC, align 8
  store i64 %2851, ptr %PC, align 8
  %2852 = add i64 %2851, 1
  store i64 %2852, ptr %NEXT_PC, align 8
  %2853 = load ptr, ptr %MEMORY, align 8
  %2854 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2853, ptr %state, ptr undef)
  store ptr %2854, ptr %MEMORY, align 8
  %2855 = load i64, ptr %NEXT_PC, align 8
  store i64 %2855, ptr %PC, align 8
  %2856 = add i64 %2855, 1
  store i64 %2856, ptr %NEXT_PC, align 8
  %2857 = load ptr, ptr %MEMORY, align 8
  %2858 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2857, ptr %state, ptr undef)
  store ptr %2858, ptr %MEMORY, align 8
  %2859 = load i64, ptr %NEXT_PC, align 8
  store i64 %2859, ptr %PC, align 8
  %2860 = add i64 %2859, 1
  store i64 %2860, ptr %NEXT_PC, align 8
  %2861 = load ptr, ptr %MEMORY, align 8
  %2862 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2861, ptr %state, ptr undef)
  store ptr %2862, ptr %MEMORY, align 8
  %2863 = load i64, ptr %NEXT_PC, align 8
  store i64 %2863, ptr %PC, align 8
  %2864 = add i64 %2863, 1
  store i64 %2864, ptr %NEXT_PC, align 8
  %2865 = load ptr, ptr %MEMORY, align 8
  %2866 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2865, ptr %state, ptr undef)
  store ptr %2866, ptr %MEMORY, align 8
  %2867 = load i64, ptr %NEXT_PC, align 8
  store i64 %2867, ptr %PC, align 8
  %2868 = add i64 %2867, 1
  store i64 %2868, ptr %NEXT_PC, align 8
  %2869 = load ptr, ptr %MEMORY, align 8
  %2870 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2869, ptr %state, ptr undef)
  store ptr %2870, ptr %MEMORY, align 8
  %2871 = load i64, ptr %NEXT_PC, align 8
  store i64 %2871, ptr %PC, align 8
  %2872 = add i64 %2871, 1
  store i64 %2872, ptr %NEXT_PC, align 8
  %2873 = load ptr, ptr %MEMORY, align 8
  %2874 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2873, ptr %state, ptr undef)
  store ptr %2874, ptr %MEMORY, align 8
  %2875 = load i64, ptr %NEXT_PC, align 8
  store i64 %2875, ptr %PC, align 8
  %2876 = add i64 %2875, 1
  store i64 %2876, ptr %NEXT_PC, align 8
  %2877 = load ptr, ptr %MEMORY, align 8
  %2878 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2877, ptr %state, ptr undef)
  store ptr %2878, ptr %MEMORY, align 8
  %2879 = load i64, ptr %NEXT_PC, align 8
  store i64 %2879, ptr %PC, align 8
  %2880 = add i64 %2879, 1
  store i64 %2880, ptr %NEXT_PC, align 8
  %2881 = load ptr, ptr %MEMORY, align 8
  %2882 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2881, ptr %state, ptr undef)
  store ptr %2882, ptr %MEMORY, align 8
  %2883 = load i64, ptr %NEXT_PC, align 8
  store i64 %2883, ptr %PC, align 8
  %2884 = add i64 %2883, 1
  store i64 %2884, ptr %NEXT_PC, align 8
  %2885 = load ptr, ptr %MEMORY, align 8
  %2886 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2885, ptr %state, ptr undef)
  store ptr %2886, ptr %MEMORY, align 8
  %2887 = load i64, ptr %NEXT_PC, align 8
  store i64 %2887, ptr %PC, align 8
  %2888 = add i64 %2887, 1
  store i64 %2888, ptr %NEXT_PC, align 8
  %2889 = load ptr, ptr %MEMORY, align 8
  %2890 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2889, ptr %state, ptr undef)
  store ptr %2890, ptr %MEMORY, align 8
  %2891 = load i64, ptr %NEXT_PC, align 8
  store i64 %2891, ptr %PC, align 8
  %2892 = add i64 %2891, 1
  store i64 %2892, ptr %NEXT_PC, align 8
  %2893 = load ptr, ptr %MEMORY, align 8
  %2894 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2893, ptr %state, ptr undef)
  store ptr %2894, ptr %MEMORY, align 8
  %2895 = load i64, ptr %NEXT_PC, align 8
  store i64 %2895, ptr %PC, align 8
  %2896 = add i64 %2895, 1
  store i64 %2896, ptr %NEXT_PC, align 8
  %2897 = load ptr, ptr %MEMORY, align 8
  %2898 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2897, ptr %state, ptr undef)
  store ptr %2898, ptr %MEMORY, align 8
  %2899 = load i64, ptr %NEXT_PC, align 8
  store i64 %2899, ptr %PC, align 8
  %2900 = add i64 %2899, 1
  store i64 %2900, ptr %NEXT_PC, align 8
  %2901 = load ptr, ptr %MEMORY, align 8
  %2902 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2901, ptr %state, ptr undef)
  store ptr %2902, ptr %MEMORY, align 8
  %2903 = load i64, ptr %NEXT_PC, align 8
  store i64 %2903, ptr %PC, align 8
  %2904 = add i64 %2903, 1
  store i64 %2904, ptr %NEXT_PC, align 8
  %2905 = load ptr, ptr %MEMORY, align 8
  %2906 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2905, ptr %state, ptr undef)
  store ptr %2906, ptr %MEMORY, align 8
  %2907 = load i64, ptr %NEXT_PC, align 8
  store i64 %2907, ptr %PC, align 8
  %2908 = add i64 %2907, 1
  store i64 %2908, ptr %NEXT_PC, align 8
  %2909 = load ptr, ptr %MEMORY, align 8
  %2910 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2909, ptr %state, ptr undef)
  store ptr %2910, ptr %MEMORY, align 8
  %2911 = load i64, ptr %NEXT_PC, align 8
  store i64 %2911, ptr %PC, align 8
  %2912 = add i64 %2911, 1
  store i64 %2912, ptr %NEXT_PC, align 8
  %2913 = load ptr, ptr %MEMORY, align 8
  %2914 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2913, ptr %state, ptr undef)
  store ptr %2914, ptr %MEMORY, align 8
  %2915 = load i64, ptr %NEXT_PC, align 8
  store i64 %2915, ptr %PC, align 8
  %2916 = add i64 %2915, 1
  store i64 %2916, ptr %NEXT_PC, align 8
  %2917 = load ptr, ptr %MEMORY, align 8
  %2918 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2917, ptr %state, ptr undef)
  store ptr %2918, ptr %MEMORY, align 8
  %2919 = load i64, ptr %NEXT_PC, align 8
  store i64 %2919, ptr %PC, align 8
  %2920 = add i64 %2919, 1
  store i64 %2920, ptr %NEXT_PC, align 8
  %2921 = load ptr, ptr %MEMORY, align 8
  %2922 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2921, ptr %state, ptr undef)
  store ptr %2922, ptr %MEMORY, align 8
  %2923 = load i64, ptr %NEXT_PC, align 8
  store i64 %2923, ptr %PC, align 8
  %2924 = add i64 %2923, 1
  store i64 %2924, ptr %NEXT_PC, align 8
  %2925 = load ptr, ptr %MEMORY, align 8
  %2926 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2925, ptr %state, ptr undef)
  store ptr %2926, ptr %MEMORY, align 8
  %2927 = load i64, ptr %NEXT_PC, align 8
  store i64 %2927, ptr %PC, align 8
  %2928 = add i64 %2927, 1
  store i64 %2928, ptr %NEXT_PC, align 8
  %2929 = load ptr, ptr %MEMORY, align 8
  %2930 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2929, ptr %state, ptr undef)
  store ptr %2930, ptr %MEMORY, align 8
  %2931 = load i64, ptr %NEXT_PC, align 8
  store i64 %2931, ptr %PC, align 8
  %2932 = add i64 %2931, 1
  store i64 %2932, ptr %NEXT_PC, align 8
  %2933 = load ptr, ptr %MEMORY, align 8
  %2934 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2933, ptr %state, ptr undef)
  store ptr %2934, ptr %MEMORY, align 8
  %2935 = load i64, ptr %NEXT_PC, align 8
  store i64 %2935, ptr %PC, align 8
  %2936 = add i64 %2935, 5
  store i64 %2936, ptr %NEXT_PC, align 8
  %2937 = load i64, ptr %RSP, align 8
  %2938 = add i64 %2937, 8
  %2939 = load i64, ptr %RBX, align 8
  %2940 = load ptr, ptr %MEMORY, align 8
  %2941 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2940, ptr %state, i64 %2938, i64 %2939)
  store ptr %2941, ptr %MEMORY, align 8
  %2942 = load i64, ptr %NEXT_PC, align 8
  store i64 %2942, ptr %PC, align 8
  %2943 = add i64 %2942, 5
  store i64 %2943, ptr %NEXT_PC, align 8
  %2944 = load i64, ptr %RSP, align 8
  %2945 = add i64 %2944, 16
  %2946 = load i64, ptr %RSI, align 8
  %2947 = load ptr, ptr %MEMORY, align 8
  %2948 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2947, ptr %state, i64 %2945, i64 %2946)
  store ptr %2948, ptr %MEMORY, align 8
  %2949 = load i64, ptr %NEXT_PC, align 8
  store i64 %2949, ptr %PC, align 8
  %2950 = add i64 %2949, 1
  store i64 %2950, ptr %NEXT_PC, align 8
  %2951 = load i64, ptr %RDI, align 8
  %2952 = load ptr, ptr %MEMORY, align 8
  %2953 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %2952, ptr %state, i64 %2951)
  store ptr %2953, ptr %MEMORY, align 8
  %2954 = load i64, ptr %NEXT_PC, align 8
  store i64 %2954, ptr %PC, align 8
  %2955 = add i64 %2954, 4
  store i64 %2955, ptr %NEXT_PC, align 8
  %2956 = load i64, ptr %RSP, align 8
  %2957 = load ptr, ptr %MEMORY, align 8
  %2958 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2957, ptr %state, ptr %RSP, i64 %2956, i64 32)
  store ptr %2958, ptr %MEMORY, align 8
  %2959 = load i64, ptr %NEXT_PC, align 8
  store i64 %2959, ptr %PC, align 8
  %2960 = add i64 %2959, 3
  store i64 %2960, ptr %NEXT_PC, align 8
  %2961 = load i64, ptr %RDX, align 8
  %2962 = load ptr, ptr %MEMORY, align 8
  %2963 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2962, ptr %state, ptr %RSI, i64 %2961)
  store ptr %2963, ptr %MEMORY, align 8
  %2964 = load i64, ptr %NEXT_PC, align 8
  store i64 %2964, ptr %PC, align 8
  %2965 = add i64 %2964, 3
  store i64 %2965, ptr %NEXT_PC, align 8
  %2966 = load i64, ptr %RCX, align 8
  %2967 = load ptr, ptr %MEMORY, align 8
  %2968 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2967, ptr %state, ptr %RDI, i64 %2966)
  store ptr %2968, ptr %MEMORY, align 8
  %2969 = load i64, ptr %NEXT_PC, align 8
  store i64 %2969, ptr %PC, align 8
  %2970 = add i64 %2969, 2
  store i64 %2970, ptr %NEXT_PC, align 8
  %2971 = load i64, ptr %RBX, align 8
  %2972 = load i32, ptr %EBX, align 4
  %2973 = zext i32 %2972 to i64
  %2974 = load ptr, ptr %MEMORY, align 8
  %2975 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2974, ptr %state, ptr %RBX, i64 %2971, i64 %2973)
  store ptr %2975, ptr %MEMORY, align 8
  %2976 = load i64, ptr %NEXT_PC, align 8
  store i64 %2976, ptr %PC, align 8
  %2977 = add i64 %2976, 5
  store i64 %2977, ptr %NEXT_PC, align 8
  %2978 = load i64, ptr %NEXT_PC, align 8
  %2979 = add i64 %2978, 228
  %2980 = load i64, ptr %NEXT_PC, align 8
  %2981 = load ptr, ptr %MEMORY, align 8
  %2982 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2981, ptr %state, i64 %2979, ptr %NEXT_PC, i64 %2980, ptr %RETURN_PC)
  store ptr %2982, ptr %MEMORY, align 8
  %2983 = load i64, ptr %NEXT_PC, align 8
  store i64 %2983, ptr %PC, align 8
  %2984 = add i64 %2983, 2
  store i64 %2984, ptr %NEXT_PC, align 8
  %2985 = load i32, ptr %EAX, align 4
  %2986 = zext i32 %2985 to i64
  %2987 = load i32, ptr %EAX, align 4
  %2988 = zext i32 %2987 to i64
  %2989 = load ptr, ptr %MEMORY, align 8
  %2990 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2989, ptr %state, i64 %2986, i64 %2988)
  store ptr %2990, ptr %MEMORY, align 8
  %2991 = load i64, ptr %NEXT_PC, align 8
  store i64 %2991, ptr %PC, align 8
  %2992 = add i64 %2991, 2
  store i64 %2992, ptr %NEXT_PC, align 8
  %2993 = load i64, ptr %NEXT_PC, align 8
  %2994 = add i64 %2993, 39
  %2995 = load i64, ptr %NEXT_PC, align 8
  %2996 = load ptr, ptr %MEMORY, align 8
  %2997 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2996, ptr %state, ptr %BRANCH_TAKEN, i64 %2994, i64 %2995, ptr %NEXT_PC)
  store ptr %2997, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659127, label %bb_5395659088

bb_5395659088:                                    ; preds = %bb_5395659113, %bb_5395659030
  %2998 = load i64, ptr %NEXT_PC, align 8
  store i64 %2998, ptr %PC, align 8
  %2999 = add i64 %2998, 2
  store i64 %2999, ptr %NEXT_PC, align 8
  %3000 = load i32, ptr %EBX, align 4
  %3001 = zext i32 %3000 to i64
  %3002 = load ptr, ptr %MEMORY, align 8
  %3003 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3002, ptr %state, ptr %RDX, i64 %3001)
  store ptr %3003, ptr %MEMORY, align 8
  %3004 = load i64, ptr %NEXT_PC, align 8
  store i64 %3004, ptr %PC, align 8
  %3005 = add i64 %3004, 3
  store i64 %3005, ptr %NEXT_PC, align 8
  %3006 = load i64, ptr %RDI, align 8
  %3007 = load ptr, ptr %MEMORY, align 8
  %3008 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3007, ptr %state, ptr %RCX, i64 %3006)
  store ptr %3008, ptr %MEMORY, align 8
  %3009 = load i64, ptr %NEXT_PC, align 8
  store i64 %3009, ptr %PC, align 8
  %3010 = add i64 %3009, 5
  store i64 %3010, ptr %NEXT_PC, align 8
  %3011 = load i64, ptr %NEXT_PC, align 8
  %3012 = sub i64 %3011, 298
  %3013 = load i64, ptr %NEXT_PC, align 8
  %3014 = load ptr, ptr %MEMORY, align 8
  %3015 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3014, ptr %state, i64 %3012, ptr %NEXT_PC, i64 %3013, ptr %RETURN_PC)
  store ptr %3015, ptr %MEMORY, align 8
  %3016 = load i64, ptr %NEXT_PC, align 8
  store i64 %3016, ptr %PC, align 8
  %3017 = add i64 %3016, 3
  store i64 %3017, ptr %NEXT_PC, align 8
  %3018 = load i64, ptr %RSI, align 8
  %3019 = load ptr, ptr %MEMORY, align 8
  %3020 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3019, ptr %state, ptr %RDX, i64 %3018)
  store ptr %3020, ptr %MEMORY, align 8
  %3021 = load i64, ptr %NEXT_PC, align 8
  store i64 %3021, ptr %PC, align 8
  %3022 = add i64 %3021, 3
  store i64 %3022, ptr %NEXT_PC, align 8
  %3023 = load i64, ptr %RAX, align 8
  %3024 = load ptr, ptr %MEMORY, align 8
  %3025 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3024, ptr %state, ptr %RCX, i64 %3023)
  store ptr %3025, ptr %MEMORY, align 8
  %3026 = load i64, ptr %NEXT_PC, align 8
  store i64 %3026, ptr %PC, align 8
  %3027 = add i64 %3026, 5
  store i64 %3027, ptr %NEXT_PC, align 8
  %3028 = load i64, ptr %NEXT_PC, align 8
  %3029 = add i64 %3028, 45211
  %3030 = load i64, ptr %NEXT_PC, align 8
  %3031 = load ptr, ptr %MEMORY, align 8
  %3032 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3031, ptr %state, i64 %3029, ptr %NEXT_PC, i64 %3030, ptr %RETURN_PC)
  store ptr %3032, ptr %MEMORY, align 8
  %3033 = load i64, ptr %NEXT_PC, align 8
  store i64 %3033, ptr %PC, align 8
  %3034 = add i64 %3033, 2
  store i64 %3034, ptr %NEXT_PC, align 8
  %3035 = load i32, ptr %EAX, align 4
  %3036 = zext i32 %3035 to i64
  %3037 = load i32, ptr %EAX, align 4
  %3038 = zext i32 %3037 to i64
  %3039 = load ptr, ptr %MEMORY, align 8
  %3040 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3039, ptr %state, i64 %3036, i64 %3038)
  store ptr %3040, ptr %MEMORY, align 8
  %3041 = load i64, ptr %NEXT_PC, align 8
  store i64 %3041, ptr %PC, align 8
  %3042 = add i64 %3041, 2
  store i64 %3042, ptr %NEXT_PC, align 8
  %3043 = load i64, ptr %NEXT_PC, align 8
  %3044 = add i64 %3043, 33
  %3045 = load i64, ptr %NEXT_PC, align 8
  %3046 = load ptr, ptr %MEMORY, align 8
  %3047 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3046, ptr %state, ptr %BRANCH_TAKEN, i64 %3044, i64 %3045, ptr %NEXT_PC)
  store ptr %3047, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659146, label %bb_5395659113

bb_5395659113:                                    ; preds = %bb_5395659088
  %3048 = load i64, ptr %NEXT_PC, align 8
  store i64 %3048, ptr %PC, align 8
  %3049 = add i64 %3048, 3
  store i64 %3049, ptr %NEXT_PC, align 8
  %3050 = load i64, ptr %RDI, align 8
  %3051 = load ptr, ptr %MEMORY, align 8
  %3052 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3051, ptr %state, ptr %RCX, i64 %3050)
  store ptr %3052, ptr %MEMORY, align 8
  %3053 = load i64, ptr %NEXT_PC, align 8
  store i64 %3053, ptr %PC, align 8
  %3054 = add i64 %3053, 2
  store i64 %3054, ptr %NEXT_PC, align 8
  %3055 = load i64, ptr %RBX, align 8
  %3056 = load ptr, ptr %MEMORY, align 8
  %3057 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3056, ptr %state, ptr %RBX, i64 %3055)
  store ptr %3057, ptr %MEMORY, align 8
  %3058 = load i64, ptr %NEXT_PC, align 8
  store i64 %3058, ptr %PC, align 8
  %3059 = add i64 %3058, 5
  store i64 %3059, ptr %NEXT_PC, align 8
  %3060 = load i64, ptr %NEXT_PC, align 8
  %3061 = add i64 %3060, 189
  %3062 = load i64, ptr %NEXT_PC, align 8
  %3063 = load ptr, ptr %MEMORY, align 8
  %3064 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3063, ptr %state, i64 %3061, ptr %NEXT_PC, i64 %3062, ptr %RETURN_PC)
  store ptr %3064, ptr %MEMORY, align 8
  %3065 = load i64, ptr %NEXT_PC, align 8
  store i64 %3065, ptr %PC, align 8
  %3066 = add i64 %3065, 2
  store i64 %3066, ptr %NEXT_PC, align 8
  %3067 = load i32, ptr %EBX, align 4
  %3068 = zext i32 %3067 to i64
  %3069 = load i32, ptr %EAX, align 4
  %3070 = zext i32 %3069 to i64
  %3071 = load ptr, ptr %MEMORY, align 8
  %3072 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3071, ptr %state, i64 %3068, i64 %3070)
  store ptr %3072, ptr %MEMORY, align 8
  %3073 = load i64, ptr %NEXT_PC, align 8
  store i64 %3073, ptr %PC, align 8
  %3074 = add i64 %3073, 2
  store i64 %3074, ptr %NEXT_PC, align 8
  %3075 = load i64, ptr %NEXT_PC, align 8
  %3076 = sub i64 %3075, 39
  %3077 = load i64, ptr %NEXT_PC, align 8
  %3078 = load ptr, ptr %MEMORY, align 8
  %3079 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3078, ptr %state, ptr %BRANCH_TAKEN, i64 %3076, i64 %3077, ptr %NEXT_PC)
  store ptr %3079, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659088, label %bb_5395659127

bb_5395659127:                                    ; preds = %bb_5395659113, %bb_5395659030
  %3080 = load i64, ptr %NEXT_PC, align 8
  store i64 %3080, ptr %PC, align 8
  %3081 = add i64 %3080, 3
  store i64 %3081, ptr %NEXT_PC, align 8
  %3082 = load i64, ptr %RAX, align 8
  %3083 = load ptr, ptr %MEMORY, align 8
  %3084 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3083, ptr %state, ptr %RAX, i64 %3082, i64 -1)
  store ptr %3084, ptr %MEMORY, align 8
  %3085 = load i64, ptr %NEXT_PC, align 8
  store i64 %3085, ptr %PC, align 8
  %3086 = add i64 %3085, 5
  store i64 %3086, ptr %NEXT_PC, align 8
  %3087 = load i64, ptr %RSP, align 8
  %3088 = add i64 %3087, 48
  %3089 = load ptr, ptr %MEMORY, align 8
  %3090 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3089, ptr %state, ptr %RBX, i64 %3088)
  store ptr %3090, ptr %MEMORY, align 8
  %3091 = load i64, ptr %NEXT_PC, align 8
  store i64 %3091, ptr %PC, align 8
  %3092 = add i64 %3091, 5
  store i64 %3092, ptr %NEXT_PC, align 8
  %3093 = load i64, ptr %RSP, align 8
  %3094 = add i64 %3093, 56
  %3095 = load ptr, ptr %MEMORY, align 8
  %3096 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3095, ptr %state, ptr %RSI, i64 %3094)
  store ptr %3096, ptr %MEMORY, align 8
  %3097 = load i64, ptr %NEXT_PC, align 8
  store i64 %3097, ptr %PC, align 8
  %3098 = add i64 %3097, 4
  store i64 %3098, ptr %NEXT_PC, align 8
  %3099 = load i64, ptr %RSP, align 8
  %3100 = load ptr, ptr %MEMORY, align 8
  %3101 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3100, ptr %state, ptr %RSP, i64 %3099, i64 32)
  store ptr %3101, ptr %MEMORY, align 8
  %3102 = load i64, ptr %NEXT_PC, align 8
  store i64 %3102, ptr %PC, align 8
  %3103 = add i64 %3102, 1
  store i64 %3103, ptr %NEXT_PC, align 8
  %3104 = load ptr, ptr %MEMORY, align 8
  %3105 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %3104, ptr %state, ptr %RDI)
  store ptr %3105, ptr %MEMORY, align 8
  %3106 = load i64, ptr %NEXT_PC, align 8
  store i64 %3106, ptr %PC, align 8
  %3107 = add i64 %3106, 1
  store i64 %3107, ptr %NEXT_PC, align 8
  %3108 = load ptr, ptr %MEMORY, align 8
  %3109 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %3108, ptr %state, ptr %NEXT_PC)
  store ptr %3109, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659146:                                    ; preds = %bb_5395659088
  %3110 = load i64, ptr %NEXT_PC, align 8
  store i64 %3110, ptr %PC, align 8
  %3111 = add i64 %3110, 5
  store i64 %3111, ptr %NEXT_PC, align 8
  %3112 = load i64, ptr %RSP, align 8
  %3113 = add i64 %3112, 56
  %3114 = load ptr, ptr %MEMORY, align 8
  %3115 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3114, ptr %state, ptr %RSI, i64 %3113)
  store ptr %3115, ptr %MEMORY, align 8
  %3116 = load i64, ptr %NEXT_PC, align 8
  store i64 %3116, ptr %PC, align 8
  %3117 = add i64 %3116, 2
  store i64 %3117, ptr %NEXT_PC, align 8
  %3118 = load i32, ptr %EBX, align 4
  %3119 = zext i32 %3118 to i64
  %3120 = load ptr, ptr %MEMORY, align 8
  %3121 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3120, ptr %state, ptr %RAX, i64 %3119)
  store ptr %3121, ptr %MEMORY, align 8
  %3122 = load i64, ptr %NEXT_PC, align 8
  store i64 %3122, ptr %PC, align 8
  %3123 = add i64 %3122, 5
  store i64 %3123, ptr %NEXT_PC, align 8
  %3124 = load i64, ptr %RSP, align 8
  %3125 = add i64 %3124, 48
  %3126 = load ptr, ptr %MEMORY, align 8
  %3127 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3126, ptr %state, ptr %RBX, i64 %3125)
  store ptr %3127, ptr %MEMORY, align 8
  %3128 = load i64, ptr %NEXT_PC, align 8
  store i64 %3128, ptr %PC, align 8
  %3129 = add i64 %3128, 4
  store i64 %3129, ptr %NEXT_PC, align 8
  %3130 = load i64, ptr %RSP, align 8
  %3131 = load ptr, ptr %MEMORY, align 8
  %3132 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3131, ptr %state, ptr %RSP, i64 %3130, i64 32)
  store ptr %3132, ptr %MEMORY, align 8
  %3133 = load i64, ptr %NEXT_PC, align 8
  store i64 %3133, ptr %PC, align 8
  %3134 = add i64 %3133, 1
  store i64 %3134, ptr %NEXT_PC, align 8
  %3135 = load ptr, ptr %MEMORY, align 8
  %3136 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %3135, ptr %state, ptr %RDI)
  store ptr %3136, ptr %MEMORY, align 8
  %3137 = load i64, ptr %NEXT_PC, align 8
  store i64 %3137, ptr %PC, align 8
  %3138 = add i64 %3137, 1
  store i64 %3138, ptr %NEXT_PC, align 8
  %3139 = load ptr, ptr %MEMORY, align 8
  %3140 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %3139, ptr %state, ptr %NEXT_PC)
  store ptr %3140, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659164:                                    ; No predecessors!
  %3141 = load i64, ptr %NEXT_PC, align 8
  store i64 %3141, ptr %PC, align 8
  %3142 = add i64 %3141, 1
  store i64 %3142, ptr %NEXT_PC, align 8
  %3143 = load ptr, ptr %MEMORY, align 8
  %3144 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3143, ptr %state, ptr undef)
  store ptr %3144, ptr %MEMORY, align 8
  %3145 = load i64, ptr %NEXT_PC, align 8
  store i64 %3145, ptr %PC, align 8
  %3146 = add i64 %3145, 1
  store i64 %3146, ptr %NEXT_PC, align 8
  %3147 = load ptr, ptr %MEMORY, align 8
  %3148 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3147, ptr %state, ptr undef)
  store ptr %3148, ptr %MEMORY, align 8
  %3149 = load i64, ptr %NEXT_PC, align 8
  store i64 %3149, ptr %PC, align 8
  %3150 = add i64 %3149, 1
  store i64 %3150, ptr %NEXT_PC, align 8
  %3151 = load ptr, ptr %MEMORY, align 8
  %3152 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3151, ptr %state, ptr undef)
  store ptr %3152, ptr %MEMORY, align 8
  %3153 = load i64, ptr %NEXT_PC, align 8
  store i64 %3153, ptr %PC, align 8
  %3154 = add i64 %3153, 1
  store i64 %3154, ptr %NEXT_PC, align 8
  %3155 = load ptr, ptr %MEMORY, align 8
  %3156 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3155, ptr %state, ptr undef)
  store ptr %3156, ptr %MEMORY, align 8
  %3157 = load i64, ptr %NEXT_PC, align 8
  store i64 %3157, ptr %PC, align 8
  %3158 = add i64 %3157, 1
  store i64 %3158, ptr %NEXT_PC, align 8
  %3159 = load ptr, ptr %MEMORY, align 8
  %3160 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3159, ptr %state, ptr undef)
  store ptr %3160, ptr %MEMORY, align 8
  %3161 = load i64, ptr %NEXT_PC, align 8
  store i64 %3161, ptr %PC, align 8
  %3162 = add i64 %3161, 1
  store i64 %3162, ptr %NEXT_PC, align 8
  %3163 = load ptr, ptr %MEMORY, align 8
  %3164 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3163, ptr %state, ptr undef)
  store ptr %3164, ptr %MEMORY, align 8
  %3165 = load i64, ptr %NEXT_PC, align 8
  store i64 %3165, ptr %PC, align 8
  %3166 = add i64 %3165, 1
  store i64 %3166, ptr %NEXT_PC, align 8
  %3167 = load ptr, ptr %MEMORY, align 8
  %3168 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3167, ptr %state, ptr undef)
  store ptr %3168, ptr %MEMORY, align 8
  %3169 = load i64, ptr %NEXT_PC, align 8
  store i64 %3169, ptr %PC, align 8
  %3170 = add i64 %3169, 1
  store i64 %3170, ptr %NEXT_PC, align 8
  %3171 = load ptr, ptr %MEMORY, align 8
  %3172 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3171, ptr %state, ptr undef)
  store ptr %3172, ptr %MEMORY, align 8
  %3173 = load i64, ptr %NEXT_PC, align 8
  store i64 %3173, ptr %PC, align 8
  %3174 = add i64 %3173, 1
  store i64 %3174, ptr %NEXT_PC, align 8
  %3175 = load ptr, ptr %MEMORY, align 8
  %3176 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3175, ptr %state, ptr undef)
  store ptr %3176, ptr %MEMORY, align 8
  %3177 = load i64, ptr %NEXT_PC, align 8
  store i64 %3177, ptr %PC, align 8
  %3178 = add i64 %3177, 1
  store i64 %3178, ptr %NEXT_PC, align 8
  %3179 = load ptr, ptr %MEMORY, align 8
  %3180 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3179, ptr %state, ptr undef)
  store ptr %3180, ptr %MEMORY, align 8
  %3181 = load i64, ptr %NEXT_PC, align 8
  store i64 %3181, ptr %PC, align 8
  %3182 = add i64 %3181, 1
  store i64 %3182, ptr %NEXT_PC, align 8
  %3183 = load ptr, ptr %MEMORY, align 8
  %3184 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3183, ptr %state, ptr undef)
  store ptr %3184, ptr %MEMORY, align 8
  %3185 = load i64, ptr %NEXT_PC, align 8
  store i64 %3185, ptr %PC, align 8
  %3186 = add i64 %3185, 1
  store i64 %3186, ptr %NEXT_PC, align 8
  %3187 = load ptr, ptr %MEMORY, align 8
  %3188 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3187, ptr %state, ptr undef)
  store ptr %3188, ptr %MEMORY, align 8
  %3189 = load i64, ptr %NEXT_PC, align 8
  store i64 %3189, ptr %PC, align 8
  %3190 = add i64 %3189, 1
  store i64 %3190, ptr %NEXT_PC, align 8
  %3191 = load ptr, ptr %MEMORY, align 8
  %3192 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3191, ptr %state, ptr undef)
  store ptr %3192, ptr %MEMORY, align 8
  %3193 = load i64, ptr %NEXT_PC, align 8
  store i64 %3193, ptr %PC, align 8
  %3194 = add i64 %3193, 1
  store i64 %3194, ptr %NEXT_PC, align 8
  %3195 = load ptr, ptr %MEMORY, align 8
  %3196 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3195, ptr %state, ptr undef)
  store ptr %3196, ptr %MEMORY, align 8
  %3197 = load i64, ptr %NEXT_PC, align 8
  store i64 %3197, ptr %PC, align 8
  %3198 = add i64 %3197, 1
  store i64 %3198, ptr %NEXT_PC, align 8
  %3199 = load ptr, ptr %MEMORY, align 8
  %3200 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3199, ptr %state, ptr undef)
  store ptr %3200, ptr %MEMORY, align 8
  %3201 = load i64, ptr %NEXT_PC, align 8
  store i64 %3201, ptr %PC, align 8
  %3202 = add i64 %3201, 1
  store i64 %3202, ptr %NEXT_PC, align 8
  %3203 = load ptr, ptr %MEMORY, align 8
  %3204 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3203, ptr %state, ptr undef)
  store ptr %3204, ptr %MEMORY, align 8
  %3205 = load i64, ptr %NEXT_PC, align 8
  store i64 %3205, ptr %PC, align 8
  %3206 = add i64 %3205, 1
  store i64 %3206, ptr %NEXT_PC, align 8
  %3207 = load ptr, ptr %MEMORY, align 8
  %3208 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3207, ptr %state, ptr undef)
  store ptr %3208, ptr %MEMORY, align 8
  %3209 = load i64, ptr %NEXT_PC, align 8
  store i64 %3209, ptr %PC, align 8
  %3210 = add i64 %3209, 1
  store i64 %3210, ptr %NEXT_PC, align 8
  %3211 = load ptr, ptr %MEMORY, align 8
  %3212 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3211, ptr %state, ptr undef)
  store ptr %3212, ptr %MEMORY, align 8
  %3213 = load i64, ptr %NEXT_PC, align 8
  store i64 %3213, ptr %PC, align 8
  %3214 = add i64 %3213, 1
  store i64 %3214, ptr %NEXT_PC, align 8
  %3215 = load ptr, ptr %MEMORY, align 8
  %3216 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3215, ptr %state, ptr undef)
  store ptr %3216, ptr %MEMORY, align 8
  %3217 = load i64, ptr %NEXT_PC, align 8
  store i64 %3217, ptr %PC, align 8
  %3218 = add i64 %3217, 1
  store i64 %3218, ptr %NEXT_PC, align 8
  %3219 = load ptr, ptr %MEMORY, align 8
  %3220 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3219, ptr %state, ptr undef)
  store ptr %3220, ptr %MEMORY, align 8
  %3221 = load i64, ptr %NEXT_PC, align 8
  store i64 %3221, ptr %PC, align 8
  %3222 = add i64 %3221, 5
  store i64 %3222, ptr %NEXT_PC, align 8
  %3223 = load i64, ptr %RSP, align 8
  %3224 = add i64 %3223, 8
  %3225 = load i64, ptr %RBX, align 8
  %3226 = load ptr, ptr %MEMORY, align 8
  %3227 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3226, ptr %state, i64 %3224, i64 %3225)
  store ptr %3227, ptr %MEMORY, align 8
  %3228 = load i64, ptr %NEXT_PC, align 8
  store i64 %3228, ptr %PC, align 8
  %3229 = add i64 %3228, 5
  store i64 %3229, ptr %NEXT_PC, align 8
  %3230 = load i64, ptr %RSP, align 8
  %3231 = add i64 %3230, 16
  %3232 = load i64, ptr %RSI, align 8
  %3233 = load ptr, ptr %MEMORY, align 8
  %3234 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3233, ptr %state, i64 %3231, i64 %3232)
  store ptr %3234, ptr %MEMORY, align 8
  %3235 = load i64, ptr %NEXT_PC, align 8
  store i64 %3235, ptr %PC, align 8
  %3236 = add i64 %3235, 1
  store i64 %3236, ptr %NEXT_PC, align 8
  %3237 = load i64, ptr %RDI, align 8
  %3238 = load ptr, ptr %MEMORY, align 8
  %3239 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %3238, ptr %state, i64 %3237)
  store ptr %3239, ptr %MEMORY, align 8
  %3240 = load i64, ptr %NEXT_PC, align 8
  store i64 %3240, ptr %PC, align 8
  %3241 = add i64 %3240, 4
  store i64 %3241, ptr %NEXT_PC, align 8
  %3242 = load i64, ptr %RSP, align 8
  %3243 = load ptr, ptr %MEMORY, align 8
  %3244 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3243, ptr %state, ptr %RSP, i64 %3242, i64 32)
  store ptr %3244, ptr %MEMORY, align 8
  %3245 = load i64, ptr %NEXT_PC, align 8
  store i64 %3245, ptr %PC, align 8
  %3246 = add i64 %3245, 3
  store i64 %3246, ptr %NEXT_PC, align 8
  %3247 = load i64, ptr %RDX, align 8
  %3248 = load ptr, ptr %MEMORY, align 8
  %3249 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3248, ptr %state, ptr %RSI, i64 %3247)
  store ptr %3249, ptr %MEMORY, align 8
  %3250 = load i64, ptr %NEXT_PC, align 8
  store i64 %3250, ptr %PC, align 8
  %3251 = add i64 %3250, 3
  store i64 %3251, ptr %NEXT_PC, align 8
  %3252 = load i64, ptr %RCX, align 8
  %3253 = load ptr, ptr %MEMORY, align 8
  %3254 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3253, ptr %state, ptr %RDI, i64 %3252)
  store ptr %3254, ptr %MEMORY, align 8
  %3255 = load i64, ptr %NEXT_PC, align 8
  store i64 %3255, ptr %PC, align 8
  %3256 = add i64 %3255, 2
  store i64 %3256, ptr %NEXT_PC, align 8
  %3257 = load i64, ptr %RBX, align 8
  %3258 = load i32, ptr %EBX, align 4
  %3259 = zext i32 %3258 to i64
  %3260 = load ptr, ptr %MEMORY, align 8
  %3261 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %3260, ptr %state, ptr %RBX, i64 %3257, i64 %3259)
  store ptr %3261, ptr %MEMORY, align 8
  %3262 = load i64, ptr %NEXT_PC, align 8
  store i64 %3262, ptr %PC, align 8
  %3263 = add i64 %3262, 5
  store i64 %3263, ptr %NEXT_PC, align 8
  %3264 = load i64, ptr %NEXT_PC, align 8
  %3265 = add i64 %3264, 100
  %3266 = load i64, ptr %NEXT_PC, align 8
  %3267 = load ptr, ptr %MEMORY, align 8
  %3268 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3267, ptr %state, i64 %3265, ptr %NEXT_PC, i64 %3266, ptr %RETURN_PC)
  store ptr %3268, ptr %MEMORY, align 8
  %3269 = load i64, ptr %NEXT_PC, align 8
  store i64 %3269, ptr %PC, align 8
  %3270 = add i64 %3269, 2
  store i64 %3270, ptr %NEXT_PC, align 8
  %3271 = load i32, ptr %EAX, align 4
  %3272 = zext i32 %3271 to i64
  %3273 = load i32, ptr %EAX, align 4
  %3274 = zext i32 %3273 to i64
  %3275 = load ptr, ptr %MEMORY, align 8
  %3276 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3275, ptr %state, i64 %3272, i64 %3274)
  store ptr %3276, ptr %MEMORY, align 8
  %3277 = load i64, ptr %NEXT_PC, align 8
  store i64 %3277, ptr %PC, align 8
  %3278 = add i64 %3277, 2
  store i64 %3278, ptr %NEXT_PC, align 8
  %3279 = load i64, ptr %NEXT_PC, align 8
  %3280 = add i64 %3279, 39
  %3281 = load i64, ptr %NEXT_PC, align 8
  %3282 = load ptr, ptr %MEMORY, align 8
  %3283 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3282, ptr %state, ptr %BRANCH_TAKEN, i64 %3280, i64 %3281, ptr %NEXT_PC)
  store ptr %3283, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659255, label %bb_5395659216

bb_5395659216:                                    ; preds = %bb_5395659241, %bb_5395659164
  %3284 = load i64, ptr %NEXT_PC, align 8
  store i64 %3284, ptr %PC, align 8
  %3285 = add i64 %3284, 2
  store i64 %3285, ptr %NEXT_PC, align 8
  %3286 = load i32, ptr %EBX, align 4
  %3287 = zext i32 %3286 to i64
  %3288 = load ptr, ptr %MEMORY, align 8
  %3289 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3288, ptr %state, ptr %RDX, i64 %3287)
  store ptr %3289, ptr %MEMORY, align 8
  %3290 = load i64, ptr %NEXT_PC, align 8
  store i64 %3290, ptr %PC, align 8
  %3291 = add i64 %3290, 3
  store i64 %3291, ptr %NEXT_PC, align 8
  %3292 = load i64, ptr %RDI, align 8
  %3293 = load ptr, ptr %MEMORY, align 8
  %3294 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3293, ptr %state, ptr %RCX, i64 %3292)
  store ptr %3294, ptr %MEMORY, align 8
  %3295 = load i64, ptr %NEXT_PC, align 8
  store i64 %3295, ptr %PC, align 8
  %3296 = add i64 %3295, 5
  store i64 %3296, ptr %NEXT_PC, align 8
  %3297 = load i64, ptr %NEXT_PC, align 8
  %3298 = sub i64 %3297, 426
  %3299 = load i64, ptr %NEXT_PC, align 8
  %3300 = load ptr, ptr %MEMORY, align 8
  %3301 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3300, ptr %state, i64 %3298, ptr %NEXT_PC, i64 %3299, ptr %RETURN_PC)
  store ptr %3301, ptr %MEMORY, align 8
  %3302 = load i64, ptr %NEXT_PC, align 8
  store i64 %3302, ptr %PC, align 8
  %3303 = add i64 %3302, 3
  store i64 %3303, ptr %NEXT_PC, align 8
  %3304 = load i64, ptr %RSI, align 8
  %3305 = load ptr, ptr %MEMORY, align 8
  %3306 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3305, ptr %state, ptr %RDX, i64 %3304)
  store ptr %3306, ptr %MEMORY, align 8
  %3307 = load i64, ptr %NEXT_PC, align 8
  store i64 %3307, ptr %PC, align 8
  %3308 = add i64 %3307, 3
  store i64 %3308, ptr %NEXT_PC, align 8
  %3309 = load i64, ptr %RAX, align 8
  %3310 = load ptr, ptr %MEMORY, align 8
  %3311 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3310, ptr %state, ptr %RCX, i64 %3309)
  store ptr %3311, ptr %MEMORY, align 8
  %3312 = load i64, ptr %NEXT_PC, align 8
  store i64 %3312, ptr %PC, align 8
  %3313 = add i64 %3312, 5
  store i64 %3313, ptr %NEXT_PC, align 8
  %3314 = load i64, ptr %NEXT_PC, align 8
  %3315 = add i64 %3314, 45147
  %3316 = load i64, ptr %NEXT_PC, align 8
  %3317 = load ptr, ptr %MEMORY, align 8
  %3318 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3317, ptr %state, i64 %3315, ptr %NEXT_PC, i64 %3316, ptr %RETURN_PC)
  store ptr %3318, ptr %MEMORY, align 8
  %3319 = load i64, ptr %NEXT_PC, align 8
  store i64 %3319, ptr %PC, align 8
  %3320 = add i64 %3319, 2
  store i64 %3320, ptr %NEXT_PC, align 8
  %3321 = load i32, ptr %EAX, align 4
  %3322 = zext i32 %3321 to i64
  %3323 = load i32, ptr %EAX, align 4
  %3324 = zext i32 %3323 to i64
  %3325 = load ptr, ptr %MEMORY, align 8
  %3326 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3325, ptr %state, i64 %3322, i64 %3324)
  store ptr %3326, ptr %MEMORY, align 8
  %3327 = load i64, ptr %NEXT_PC, align 8
  store i64 %3327, ptr %PC, align 8
  %3328 = add i64 %3327, 2
  store i64 %3328, ptr %NEXT_PC, align 8
  %3329 = load i64, ptr %NEXT_PC, align 8
  %3330 = add i64 %3329, 33
  %3331 = load i64, ptr %NEXT_PC, align 8
  %3332 = load ptr, ptr %MEMORY, align 8
  %3333 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3332, ptr %state, ptr %BRANCH_TAKEN, i64 %3330, i64 %3331, ptr %NEXT_PC)
  store ptr %3333, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659274, label %bb_5395659241

bb_5395659241:                                    ; preds = %bb_5395659216
  %3334 = load i64, ptr %NEXT_PC, align 8
  store i64 %3334, ptr %PC, align 8
  %3335 = add i64 %3334, 3
  store i64 %3335, ptr %NEXT_PC, align 8
  %3336 = load i64, ptr %RDI, align 8
  %3337 = load ptr, ptr %MEMORY, align 8
  %3338 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3337, ptr %state, ptr %RCX, i64 %3336)
  store ptr %3338, ptr %MEMORY, align 8
  %3339 = load i64, ptr %NEXT_PC, align 8
  store i64 %3339, ptr %PC, align 8
  %3340 = add i64 %3339, 2
  store i64 %3340, ptr %NEXT_PC, align 8
  %3341 = load i64, ptr %RBX, align 8
  %3342 = load ptr, ptr %MEMORY, align 8
  %3343 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3342, ptr %state, ptr %RBX, i64 %3341)
  store ptr %3343, ptr %MEMORY, align 8
  %3344 = load i64, ptr %NEXT_PC, align 8
  store i64 %3344, ptr %PC, align 8
  %3345 = add i64 %3344, 5
  store i64 %3345, ptr %NEXT_PC, align 8
  %3346 = load i64, ptr %NEXT_PC, align 8
  %3347 = add i64 %3346, 61
  %3348 = load i64, ptr %NEXT_PC, align 8
  %3349 = load ptr, ptr %MEMORY, align 8
  %3350 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3349, ptr %state, i64 %3347, ptr %NEXT_PC, i64 %3348, ptr %RETURN_PC)
  store ptr %3350, ptr %MEMORY, align 8
  %3351 = load i64, ptr %NEXT_PC, align 8
  store i64 %3351, ptr %PC, align 8
  %3352 = add i64 %3351, 2
  store i64 %3352, ptr %NEXT_PC, align 8
  %3353 = load i32, ptr %EBX, align 4
  %3354 = zext i32 %3353 to i64
  %3355 = load i32, ptr %EAX, align 4
  %3356 = zext i32 %3355 to i64
  %3357 = load ptr, ptr %MEMORY, align 8
  %3358 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3357, ptr %state, i64 %3354, i64 %3356)
  store ptr %3358, ptr %MEMORY, align 8
  %3359 = load i64, ptr %NEXT_PC, align 8
  store i64 %3359, ptr %PC, align 8
  %3360 = add i64 %3359, 2
  store i64 %3360, ptr %NEXT_PC, align 8
  %3361 = load i64, ptr %NEXT_PC, align 8
  %3362 = sub i64 %3361, 39
  %3363 = load i64, ptr %NEXT_PC, align 8
  %3364 = load ptr, ptr %MEMORY, align 8
  %3365 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3364, ptr %state, ptr %BRANCH_TAKEN, i64 %3362, i64 %3363, ptr %NEXT_PC)
  store ptr %3365, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659216, label %bb_5395659255

bb_5395659255:                                    ; preds = %bb_5395659241, %bb_5395659164
  %3366 = load i64, ptr %NEXT_PC, align 8
  store i64 %3366, ptr %PC, align 8
  %3367 = add i64 %3366, 3
  store i64 %3367, ptr %NEXT_PC, align 8
  %3368 = load i64, ptr %RAX, align 8
  %3369 = load ptr, ptr %MEMORY, align 8
  %3370 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3369, ptr %state, ptr %RAX, i64 %3368, i64 -1)
  store ptr %3370, ptr %MEMORY, align 8
  %3371 = load i64, ptr %NEXT_PC, align 8
  store i64 %3371, ptr %PC, align 8
  %3372 = add i64 %3371, 5
  store i64 %3372, ptr %NEXT_PC, align 8
  %3373 = load i64, ptr %RSP, align 8
  %3374 = add i64 %3373, 48
  %3375 = load ptr, ptr %MEMORY, align 8
  %3376 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3375, ptr %state, ptr %RBX, i64 %3374)
  store ptr %3376, ptr %MEMORY, align 8
  %3377 = load i64, ptr %NEXT_PC, align 8
  store i64 %3377, ptr %PC, align 8
  %3378 = add i64 %3377, 5
  store i64 %3378, ptr %NEXT_PC, align 8
  %3379 = load i64, ptr %RSP, align 8
  %3380 = add i64 %3379, 56
  %3381 = load ptr, ptr %MEMORY, align 8
  %3382 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3381, ptr %state, ptr %RSI, i64 %3380)
  store ptr %3382, ptr %MEMORY, align 8
  %3383 = load i64, ptr %NEXT_PC, align 8
  store i64 %3383, ptr %PC, align 8
  %3384 = add i64 %3383, 4
  store i64 %3384, ptr %NEXT_PC, align 8
  %3385 = load i64, ptr %RSP, align 8
  %3386 = load ptr, ptr %MEMORY, align 8
  %3387 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3386, ptr %state, ptr %RSP, i64 %3385, i64 32)
  store ptr %3387, ptr %MEMORY, align 8
  %3388 = load i64, ptr %NEXT_PC, align 8
  store i64 %3388, ptr %PC, align 8
  %3389 = add i64 %3388, 1
  store i64 %3389, ptr %NEXT_PC, align 8
  %3390 = load ptr, ptr %MEMORY, align 8
  %3391 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %3390, ptr %state, ptr %RDI)
  store ptr %3391, ptr %MEMORY, align 8
  %3392 = load i64, ptr %NEXT_PC, align 8
  store i64 %3392, ptr %PC, align 8
  %3393 = add i64 %3392, 1
  store i64 %3393, ptr %NEXT_PC, align 8
  %3394 = load ptr, ptr %MEMORY, align 8
  %3395 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %3394, ptr %state, ptr %NEXT_PC)
  store ptr %3395, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659274:                                    ; preds = %bb_5395659216
  %3396 = load i64, ptr %NEXT_PC, align 8
  store i64 %3396, ptr %PC, align 8
  %3397 = add i64 %3396, 5
  store i64 %3397, ptr %NEXT_PC, align 8
  %3398 = load i64, ptr %RSP, align 8
  %3399 = add i64 %3398, 56
  %3400 = load ptr, ptr %MEMORY, align 8
  %3401 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3400, ptr %state, ptr %RSI, i64 %3399)
  store ptr %3401, ptr %MEMORY, align 8
  %3402 = load i64, ptr %NEXT_PC, align 8
  store i64 %3402, ptr %PC, align 8
  %3403 = add i64 %3402, 2
  store i64 %3403, ptr %NEXT_PC, align 8
  %3404 = load i32, ptr %EBX, align 4
  %3405 = zext i32 %3404 to i64
  %3406 = load ptr, ptr %MEMORY, align 8
  %3407 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3406, ptr %state, ptr %RAX, i64 %3405)
  store ptr %3407, ptr %MEMORY, align 8
  %3408 = load i64, ptr %NEXT_PC, align 8
  store i64 %3408, ptr %PC, align 8
  %3409 = add i64 %3408, 5
  store i64 %3409, ptr %NEXT_PC, align 8
  %3410 = load i64, ptr %RSP, align 8
  %3411 = add i64 %3410, 48
  %3412 = load ptr, ptr %MEMORY, align 8
  %3413 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3412, ptr %state, ptr %RBX, i64 %3411)
  store ptr %3413, ptr %MEMORY, align 8
  %3414 = load i64, ptr %NEXT_PC, align 8
  store i64 %3414, ptr %PC, align 8
  %3415 = add i64 %3414, 4
  store i64 %3415, ptr %NEXT_PC, align 8
  %3416 = load i64, ptr %RSP, align 8
  %3417 = load ptr, ptr %MEMORY, align 8
  %3418 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3417, ptr %state, ptr %RSP, i64 %3416, i64 32)
  store ptr %3418, ptr %MEMORY, align 8
  %3419 = load i64, ptr %NEXT_PC, align 8
  store i64 %3419, ptr %PC, align 8
  %3420 = add i64 %3419, 1
  store i64 %3420, ptr %NEXT_PC, align 8
  %3421 = load ptr, ptr %MEMORY, align 8
  %3422 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %3421, ptr %state, ptr %RDI)
  store ptr %3422, ptr %MEMORY, align 8
  %3423 = load i64, ptr %NEXT_PC, align 8
  store i64 %3423, ptr %PC, align 8
  %3424 = add i64 %3423, 1
  store i64 %3424, ptr %NEXT_PC, align 8
  %3425 = load ptr, ptr %MEMORY, align 8
  %3426 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %3425, ptr %state, ptr %NEXT_PC)
  store ptr %3426, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659292:                                    ; No predecessors!
  %3427 = load i64, ptr %NEXT_PC, align 8
  store i64 %3427, ptr %PC, align 8
  %3428 = add i64 %3427, 1
  store i64 %3428, ptr %NEXT_PC, align 8
  %3429 = load ptr, ptr %MEMORY, align 8
  %3430 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3429, ptr %state, ptr undef)
  store ptr %3430, ptr %MEMORY, align 8
  %3431 = load i64, ptr %NEXT_PC, align 8
  store i64 %3431, ptr %PC, align 8
  %3432 = add i64 %3431, 1
  store i64 %3432, ptr %NEXT_PC, align 8
  %3433 = load ptr, ptr %MEMORY, align 8
  %3434 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3433, ptr %state, ptr undef)
  store ptr %3434, ptr %MEMORY, align 8
  %3435 = load i64, ptr %NEXT_PC, align 8
  store i64 %3435, ptr %PC, align 8
  %3436 = add i64 %3435, 1
  store i64 %3436, ptr %NEXT_PC, align 8
  %3437 = load ptr, ptr %MEMORY, align 8
  %3438 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3437, ptr %state, ptr undef)
  store ptr %3438, ptr %MEMORY, align 8
  %3439 = load i64, ptr %NEXT_PC, align 8
  store i64 %3439, ptr %PC, align 8
  %3440 = add i64 %3439, 1
  store i64 %3440, ptr %NEXT_PC, align 8
  %3441 = load ptr, ptr %MEMORY, align 8
  %3442 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3441, ptr %state, ptr undef)
  store ptr %3442, ptr %MEMORY, align 8
  %3443 = load i64, ptr %NEXT_PC, align 8
  store i64 %3443, ptr %PC, align 8
  %3444 = add i64 %3443, 1
  store i64 %3444, ptr %NEXT_PC, align 8
  %3445 = load ptr, ptr %MEMORY, align 8
  %3446 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3445, ptr %state, ptr undef)
  store ptr %3446, ptr %MEMORY, align 8
  %3447 = load i64, ptr %NEXT_PC, align 8
  store i64 %3447, ptr %PC, align 8
  %3448 = add i64 %3447, 1
  store i64 %3448, ptr %NEXT_PC, align 8
  %3449 = load ptr, ptr %MEMORY, align 8
  %3450 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3449, ptr %state, ptr undef)
  store ptr %3450, ptr %MEMORY, align 8
  %3451 = load i64, ptr %NEXT_PC, align 8
  store i64 %3451, ptr %PC, align 8
  %3452 = add i64 %3451, 1
  store i64 %3452, ptr %NEXT_PC, align 8
  %3453 = load ptr, ptr %MEMORY, align 8
  %3454 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3453, ptr %state, ptr undef)
  store ptr %3454, ptr %MEMORY, align 8
  %3455 = load i64, ptr %NEXT_PC, align 8
  store i64 %3455, ptr %PC, align 8
  %3456 = add i64 %3455, 1
  store i64 %3456, ptr %NEXT_PC, align 8
  %3457 = load ptr, ptr %MEMORY, align 8
  %3458 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3457, ptr %state, ptr undef)
  store ptr %3458, ptr %MEMORY, align 8
  %3459 = load i64, ptr %NEXT_PC, align 8
  store i64 %3459, ptr %PC, align 8
  %3460 = add i64 %3459, 1
  store i64 %3460, ptr %NEXT_PC, align 8
  %3461 = load ptr, ptr %MEMORY, align 8
  %3462 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3461, ptr %state, ptr undef)
  store ptr %3462, ptr %MEMORY, align 8
  %3463 = load i64, ptr %NEXT_PC, align 8
  store i64 %3463, ptr %PC, align 8
  %3464 = add i64 %3463, 1
  store i64 %3464, ptr %NEXT_PC, align 8
  %3465 = load ptr, ptr %MEMORY, align 8
  %3466 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3465, ptr %state, ptr undef)
  store ptr %3466, ptr %MEMORY, align 8
  %3467 = load i64, ptr %NEXT_PC, align 8
  store i64 %3467, ptr %PC, align 8
  %3468 = add i64 %3467, 1
  store i64 %3468, ptr %NEXT_PC, align 8
  %3469 = load ptr, ptr %MEMORY, align 8
  %3470 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3469, ptr %state, ptr undef)
  store ptr %3470, ptr %MEMORY, align 8
  %3471 = load i64, ptr %NEXT_PC, align 8
  store i64 %3471, ptr %PC, align 8
  %3472 = add i64 %3471, 1
  store i64 %3472, ptr %NEXT_PC, align 8
  %3473 = load ptr, ptr %MEMORY, align 8
  %3474 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3473, ptr %state, ptr undef)
  store ptr %3474, ptr %MEMORY, align 8
  %3475 = load i64, ptr %NEXT_PC, align 8
  store i64 %3475, ptr %PC, align 8
  %3476 = add i64 %3475, 1
  store i64 %3476, ptr %NEXT_PC, align 8
  %3477 = load ptr, ptr %MEMORY, align 8
  %3478 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3477, ptr %state, ptr undef)
  store ptr %3478, ptr %MEMORY, align 8
  %3479 = load i64, ptr %NEXT_PC, align 8
  store i64 %3479, ptr %PC, align 8
  %3480 = add i64 %3479, 1
  store i64 %3480, ptr %NEXT_PC, align 8
  %3481 = load ptr, ptr %MEMORY, align 8
  %3482 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3481, ptr %state, ptr undef)
  store ptr %3482, ptr %MEMORY, align 8
  %3483 = load i64, ptr %NEXT_PC, align 8
  store i64 %3483, ptr %PC, align 8
  %3484 = add i64 %3483, 1
  store i64 %3484, ptr %NEXT_PC, align 8
  %3485 = load ptr, ptr %MEMORY, align 8
  %3486 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3485, ptr %state, ptr undef)
  store ptr %3486, ptr %MEMORY, align 8
  %3487 = load i64, ptr %NEXT_PC, align 8
  store i64 %3487, ptr %PC, align 8
  %3488 = add i64 %3487, 1
  store i64 %3488, ptr %NEXT_PC, align 8
  %3489 = load ptr, ptr %MEMORY, align 8
  %3490 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3489, ptr %state, ptr undef)
  store ptr %3490, ptr %MEMORY, align 8
  %3491 = load i64, ptr %NEXT_PC, align 8
  store i64 %3491, ptr %PC, align 8
  %3492 = add i64 %3491, 1
  store i64 %3492, ptr %NEXT_PC, align 8
  %3493 = load ptr, ptr %MEMORY, align 8
  %3494 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3493, ptr %state, ptr undef)
  store ptr %3494, ptr %MEMORY, align 8
  %3495 = load i64, ptr %NEXT_PC, align 8
  store i64 %3495, ptr %PC, align 8
  %3496 = add i64 %3495, 1
  store i64 %3496, ptr %NEXT_PC, align 8
  %3497 = load ptr, ptr %MEMORY, align 8
  %3498 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3497, ptr %state, ptr undef)
  store ptr %3498, ptr %MEMORY, align 8
  %3499 = load i64, ptr %NEXT_PC, align 8
  store i64 %3499, ptr %PC, align 8
  %3500 = add i64 %3499, 1
  store i64 %3500, ptr %NEXT_PC, align 8
  %3501 = load ptr, ptr %MEMORY, align 8
  %3502 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3501, ptr %state, ptr undef)
  store ptr %3502, ptr %MEMORY, align 8
  %3503 = load i64, ptr %NEXT_PC, align 8
  store i64 %3503, ptr %PC, align 8
  %3504 = add i64 %3503, 1
  store i64 %3504, ptr %NEXT_PC, align 8
  %3505 = load ptr, ptr %MEMORY, align 8
  %3506 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3505, ptr %state, ptr undef)
  store ptr %3506, ptr %MEMORY, align 8
  %3507 = load i64, ptr %NEXT_PC, align 8
  store i64 %3507, ptr %PC, align 8
  %3508 = add i64 %3507, 4
  store i64 %3508, ptr %NEXT_PC, align 8
  %3509 = load i64, ptr %RCX, align 8
  %3510 = add i64 %3509, 8
  %3511 = load ptr, ptr %MEMORY, align 8
  %3512 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3511, ptr %state, ptr %RDX, i64 %3510)
  store ptr %3512, ptr %MEMORY, align 8
  %3513 = load i64, ptr %NEXT_PC, align 8
  store i64 %3513, ptr %PC, align 8
  %3514 = add i64 %3513, 3
  store i64 %3514, ptr %NEXT_PC, align 8
  %3515 = load i64, ptr %RCX, align 8
  %3516 = add i64 %3515, 48
  %3517 = load ptr, ptr %MEMORY, align 8
  %3518 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3517, ptr %state, ptr %RAX, i64 %3516)
  store ptr %3518, ptr %MEMORY, align 8
  %3519 = load i64, ptr %NEXT_PC, align 8
  store i64 %3519, ptr %PC, align 8
  %3520 = add i64 %3519, 3
  store i64 %3520, ptr %NEXT_PC, align 8
  %3521 = load i64, ptr %RDX, align 8
  %3522 = load i64, ptr %RDX, align 8
  %3523 = load ptr, ptr %MEMORY, align 8
  %3524 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3523, ptr %state, i64 %3521, i64 %3522)
  store ptr %3524, ptr %MEMORY, align 8
  %3525 = load i64, ptr %NEXT_PC, align 8
  store i64 %3525, ptr %PC, align 8
  %3526 = add i64 %3525, 2
  store i64 %3526, ptr %NEXT_PC, align 8
  %3527 = load i64, ptr %NEXT_PC, align 8
  %3528 = add i64 %3527, 16
  %3529 = load i64, ptr %NEXT_PC, align 8
  %3530 = load ptr, ptr %MEMORY, align 8
  %3531 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3530, ptr %state, ptr %BRANCH_TAKEN, i64 %3528, i64 %3529, ptr %NEXT_PC)
  store ptr %3531, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659340, label %bb_5395659324

bb_5395659324:                                    ; preds = %bb_5395659292
  %3532 = load i64, ptr %NEXT_PC, align 8
  store i64 %3532, ptr %PC, align 8
  %3533 = add i64 %3532, 4
  store i64 %3533, ptr %NEXT_PC, align 8
  %3534 = load i64, ptr %RAX, align 8
  %3535 = load ptr, ptr %MEMORY, align 8
  %3536 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnIjEEEEP6MemoryS4_R5StateDpT_(ptr %3535, ptr %state, i64 %3534)
  store ptr %3536, ptr %MEMORY, align 8
  br label %bb_5395659328

bb_5395659328:                                    ; preds = %bb_5395659328, %bb_5395659324
  %3537 = load i64, ptr %NEXT_PC, align 8
  store i64 %3537, ptr %PC, align 8
  %3538 = add i64 %3537, 3
  store i64 %3538, ptr %NEXT_PC, align 8
  %3539 = load i64, ptr %RAX, align 8
  %3540 = load i64, ptr %RDX, align 8
  %3541 = add i64 %3540, 48
  %3542 = load ptr, ptr %MEMORY, align 8
  %3543 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3542, ptr %state, ptr %RAX, i64 %3539, i64 %3541)
  store ptr %3543, ptr %MEMORY, align 8
  %3544 = load i64, ptr %NEXT_PC, align 8
  store i64 %3544, ptr %PC, align 8
  %3545 = add i64 %3544, 4
  store i64 %3545, ptr %NEXT_PC, align 8
  %3546 = load i64, ptr %RDX, align 8
  %3547 = add i64 %3546, 8
  %3548 = load ptr, ptr %MEMORY, align 8
  %3549 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3548, ptr %state, ptr %RDX, i64 %3547)
  store ptr %3549, ptr %MEMORY, align 8
  %3550 = load i64, ptr %NEXT_PC, align 8
  store i64 %3550, ptr %PC, align 8
  %3551 = add i64 %3550, 3
  store i64 %3551, ptr %NEXT_PC, align 8
  %3552 = load i64, ptr %RDX, align 8
  %3553 = load i64, ptr %RDX, align 8
  %3554 = load ptr, ptr %MEMORY, align 8
  %3555 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3554, ptr %state, i64 %3552, i64 %3553)
  store ptr %3555, ptr %MEMORY, align 8
  %3556 = load i64, ptr %NEXT_PC, align 8
  store i64 %3556, ptr %PC, align 8
  %3557 = add i64 %3556, 2
  store i64 %3557, ptr %NEXT_PC, align 8
  %3558 = load i64, ptr %NEXT_PC, align 8
  %3559 = sub i64 %3558, 12
  %3560 = load i64, ptr %NEXT_PC, align 8
  %3561 = load ptr, ptr %MEMORY, align 8
  %3562 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3561, ptr %state, ptr %BRANCH_TAKEN, i64 %3559, i64 %3560, ptr %NEXT_PC)
  store ptr %3562, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659328, label %bb_5395659340

bb_5395659340:                                    ; preds = %bb_5395659328, %bb_5395659292
  %3563 = load i64, ptr %NEXT_PC, align 8
  store i64 %3563, ptr %PC, align 8
  %3564 = add i64 %3563, 1
  store i64 %3564, ptr %NEXT_PC, align 8
  %3565 = load ptr, ptr %MEMORY, align 8
  %3566 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %3565, ptr %state, ptr %NEXT_PC)
  store ptr %3566, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659341:                                    ; No predecessors!
  %3567 = load i64, ptr %NEXT_PC, align 8
  store i64 %3567, ptr %PC, align 8
  %3568 = add i64 %3567, 1
  store i64 %3568, ptr %NEXT_PC, align 8
  %3569 = load ptr, ptr %MEMORY, align 8
  %3570 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3569, ptr %state, ptr undef)
  store ptr %3570, ptr %MEMORY, align 8
  %3571 = load i64, ptr %NEXT_PC, align 8
  store i64 %3571, ptr %PC, align 8
  %3572 = add i64 %3571, 1
  store i64 %3572, ptr %NEXT_PC, align 8
  %3573 = load ptr, ptr %MEMORY, align 8
  %3574 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3573, ptr %state, ptr undef)
  store ptr %3574, ptr %MEMORY, align 8
  %3575 = load i64, ptr %NEXT_PC, align 8
  store i64 %3575, ptr %PC, align 8
  %3576 = add i64 %3575, 1
  store i64 %3576, ptr %NEXT_PC, align 8
  %3577 = load ptr, ptr %MEMORY, align 8
  %3578 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3577, ptr %state, ptr undef)
  store ptr %3578, ptr %MEMORY, align 8
  %3579 = load i64, ptr %NEXT_PC, align 8
  store i64 %3579, ptr %PC, align 8
  %3580 = add i64 %3579, 1
  store i64 %3580, ptr %NEXT_PC, align 8
  %3581 = load ptr, ptr %MEMORY, align 8
  %3582 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3581, ptr %state, ptr undef)
  store ptr %3582, ptr %MEMORY, align 8
  %3583 = load i64, ptr %NEXT_PC, align 8
  store i64 %3583, ptr %PC, align 8
  %3584 = add i64 %3583, 1
  store i64 %3584, ptr %NEXT_PC, align 8
  %3585 = load ptr, ptr %MEMORY, align 8
  %3586 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3585, ptr %state, ptr undef)
  store ptr %3586, ptr %MEMORY, align 8
  %3587 = load i64, ptr %NEXT_PC, align 8
  store i64 %3587, ptr %PC, align 8
  %3588 = add i64 %3587, 1
  store i64 %3588, ptr %NEXT_PC, align 8
  %3589 = load ptr, ptr %MEMORY, align 8
  %3590 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3589, ptr %state, ptr undef)
  store ptr %3590, ptr %MEMORY, align 8
  %3591 = load i64, ptr %NEXT_PC, align 8
  store i64 %3591, ptr %PC, align 8
  %3592 = add i64 %3591, 1
  store i64 %3592, ptr %NEXT_PC, align 8
  %3593 = load ptr, ptr %MEMORY, align 8
  %3594 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3593, ptr %state, ptr undef)
  store ptr %3594, ptr %MEMORY, align 8
  %3595 = load i64, ptr %NEXT_PC, align 8
  store i64 %3595, ptr %PC, align 8
  %3596 = add i64 %3595, 1
  store i64 %3596, ptr %NEXT_PC, align 8
  %3597 = load ptr, ptr %MEMORY, align 8
  %3598 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3597, ptr %state, ptr undef)
  store ptr %3598, ptr %MEMORY, align 8
  %3599 = load i64, ptr %NEXT_PC, align 8
  store i64 %3599, ptr %PC, align 8
  %3600 = add i64 %3599, 1
  store i64 %3600, ptr %NEXT_PC, align 8
  %3601 = load ptr, ptr %MEMORY, align 8
  %3602 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3601, ptr %state, ptr undef)
  store ptr %3602, ptr %MEMORY, align 8
  %3603 = load i64, ptr %NEXT_PC, align 8
  store i64 %3603, ptr %PC, align 8
  %3604 = add i64 %3603, 1
  store i64 %3604, ptr %NEXT_PC, align 8
  %3605 = load ptr, ptr %MEMORY, align 8
  %3606 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3605, ptr %state, ptr undef)
  store ptr %3606, ptr %MEMORY, align 8
  %3607 = load i64, ptr %NEXT_PC, align 8
  store i64 %3607, ptr %PC, align 8
  %3608 = add i64 %3607, 1
  store i64 %3608, ptr %NEXT_PC, align 8
  %3609 = load ptr, ptr %MEMORY, align 8
  %3610 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3609, ptr %state, ptr undef)
  store ptr %3610, ptr %MEMORY, align 8
  %3611 = load i64, ptr %NEXT_PC, align 8
  store i64 %3611, ptr %PC, align 8
  %3612 = add i64 %3611, 1
  store i64 %3612, ptr %NEXT_PC, align 8
  %3613 = load ptr, ptr %MEMORY, align 8
  %3614 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3613, ptr %state, ptr undef)
  store ptr %3614, ptr %MEMORY, align 8
  %3615 = load i64, ptr %NEXT_PC, align 8
  store i64 %3615, ptr %PC, align 8
  %3616 = add i64 %3615, 1
  store i64 %3616, ptr %NEXT_PC, align 8
  %3617 = load ptr, ptr %MEMORY, align 8
  %3618 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3617, ptr %state, ptr undef)
  store ptr %3618, ptr %MEMORY, align 8
  %3619 = load i64, ptr %NEXT_PC, align 8
  store i64 %3619, ptr %PC, align 8
  %3620 = add i64 %3619, 1
  store i64 %3620, ptr %NEXT_PC, align 8
  %3621 = load ptr, ptr %MEMORY, align 8
  %3622 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3621, ptr %state, ptr undef)
  store ptr %3622, ptr %MEMORY, align 8
  %3623 = load i64, ptr %NEXT_PC, align 8
  store i64 %3623, ptr %PC, align 8
  %3624 = add i64 %3623, 1
  store i64 %3624, ptr %NEXT_PC, align 8
  %3625 = load ptr, ptr %MEMORY, align 8
  %3626 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3625, ptr %state, ptr undef)
  store ptr %3626, ptr %MEMORY, align 8
  %3627 = load i64, ptr %NEXT_PC, align 8
  store i64 %3627, ptr %PC, align 8
  %3628 = add i64 %3627, 1
  store i64 %3628, ptr %NEXT_PC, align 8
  %3629 = load ptr, ptr %MEMORY, align 8
  %3630 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3629, ptr %state, ptr undef)
  store ptr %3630, ptr %MEMORY, align 8
  %3631 = load i64, ptr %NEXT_PC, align 8
  store i64 %3631, ptr %PC, align 8
  %3632 = add i64 %3631, 1
  store i64 %3632, ptr %NEXT_PC, align 8
  %3633 = load ptr, ptr %MEMORY, align 8
  %3634 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3633, ptr %state, ptr undef)
  store ptr %3634, ptr %MEMORY, align 8
  %3635 = load i64, ptr %NEXT_PC, align 8
  store i64 %3635, ptr %PC, align 8
  %3636 = add i64 %3635, 1
  store i64 %3636, ptr %NEXT_PC, align 8
  %3637 = load ptr, ptr %MEMORY, align 8
  %3638 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3637, ptr %state, ptr undef)
  store ptr %3638, ptr %MEMORY, align 8
  %3639 = load i64, ptr %NEXT_PC, align 8
  store i64 %3639, ptr %PC, align 8
  %3640 = add i64 %3639, 1
  store i64 %3640, ptr %NEXT_PC, align 8
  %3641 = load ptr, ptr %MEMORY, align 8
  %3642 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3641, ptr %state, ptr undef)
  store ptr %3642, ptr %MEMORY, align 8
  %3643 = load i64, ptr %NEXT_PC, align 8
  store i64 %3643, ptr %PC, align 8
  %3644 = add i64 %3643, 3
  store i64 %3644, ptr %NEXT_PC, align 8
  %3645 = load i32, ptr %EDX, align 4
  %3646 = zext i32 %3645 to i64
  %3647 = load ptr, ptr %MEMORY, align 8
  %3648 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %3647, ptr %state, ptr %RAX, i64 %3646)
  store ptr %3648, ptr %MEMORY, align 8
  %3649 = load i64, ptr %NEXT_PC, align 8
  store i64 %3649, ptr %PC, align 8
  %3650 = add i64 %3649, 4
  store i64 %3650, ptr %NEXT_PC, align 8
  %3651 = load i64, ptr %RAX, align 8
  %3652 = load i64, ptr %RAX, align 8
  %3653 = mul i64 %3652, 4
  %3654 = add i64 %3651, %3653
  %3655 = load ptr, ptr %MEMORY, align 8
  %3656 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %3655, ptr %state, ptr %RDX, i64 %3654)
  store ptr %3656, ptr %MEMORY, align 8
  %3657 = load i64, ptr %NEXT_PC, align 8
  store i64 %3657, ptr %PC, align 8
  %3658 = add i64 %3657, 4
  store i64 %3658, ptr %NEXT_PC, align 8
  %3659 = load i64, ptr %RCX, align 8
  %3660 = add i64 %3659, 40
  %3661 = load ptr, ptr %MEMORY, align 8
  %3662 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3661, ptr %state, ptr %RAX, i64 %3660)
  store ptr %3662, ptr %MEMORY, align 8
  %3663 = load i64, ptr %NEXT_PC, align 8
  store i64 %3663, ptr %PC, align 8
  %3664 = add i64 %3663, 4
  store i64 %3664, ptr %NEXT_PC, align 8
  %3665 = load i64, ptr %RAX, align 8
  %3666 = load i64, ptr %RDX, align 8
  %3667 = mul i64 %3666, 8
  %3668 = add i64 %3665, %3667
  %3669 = load ptr, ptr %MEMORY, align 8
  %3670 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %3669, ptr %state, ptr %RAX, i64 %3668)
  store ptr %3670, ptr %MEMORY, align 8
  %3671 = load i64, ptr %NEXT_PC, align 8
  store i64 %3671, ptr %PC, align 8
  %3672 = add i64 %3671, 1
  store i64 %3672, ptr %NEXT_PC, align 8
  %3673 = load ptr, ptr %MEMORY, align 8
  %3674 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %3673, ptr %state, ptr %NEXT_PC)
  store ptr %3674, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659376:                                    ; No predecessors!
  %3675 = load i64, ptr %NEXT_PC, align 8
  store i64 %3675, ptr %PC, align 8
  %3676 = add i64 %3675, 1
  store i64 %3676, ptr %NEXT_PC, align 8
  %3677 = load ptr, ptr %MEMORY, align 8
  %3678 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3677, ptr %state, ptr undef)
  store ptr %3678, ptr %MEMORY, align 8
  %3679 = load i64, ptr %NEXT_PC, align 8
  store i64 %3679, ptr %PC, align 8
  %3680 = add i64 %3679, 1
  store i64 %3680, ptr %NEXT_PC, align 8
  %3681 = load ptr, ptr %MEMORY, align 8
  %3682 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3681, ptr %state, ptr undef)
  store ptr %3682, ptr %MEMORY, align 8
  %3683 = load i64, ptr %NEXT_PC, align 8
  store i64 %3683, ptr %PC, align 8
  %3684 = add i64 %3683, 1
  store i64 %3684, ptr %NEXT_PC, align 8
  %3685 = load ptr, ptr %MEMORY, align 8
  %3686 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3685, ptr %state, ptr undef)
  store ptr %3686, ptr %MEMORY, align 8
  %3687 = load i64, ptr %NEXT_PC, align 8
  store i64 %3687, ptr %PC, align 8
  %3688 = add i64 %3687, 1
  store i64 %3688, ptr %NEXT_PC, align 8
  %3689 = load ptr, ptr %MEMORY, align 8
  %3690 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3689, ptr %state, ptr undef)
  store ptr %3690, ptr %MEMORY, align 8
  %3691 = load i64, ptr %NEXT_PC, align 8
  store i64 %3691, ptr %PC, align 8
  %3692 = add i64 %3691, 1
  store i64 %3692, ptr %NEXT_PC, align 8
  %3693 = load ptr, ptr %MEMORY, align 8
  %3694 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3693, ptr %state, ptr undef)
  store ptr %3694, ptr %MEMORY, align 8
  %3695 = load i64, ptr %NEXT_PC, align 8
  store i64 %3695, ptr %PC, align 8
  %3696 = add i64 %3695, 1
  store i64 %3696, ptr %NEXT_PC, align 8
  %3697 = load ptr, ptr %MEMORY, align 8
  %3698 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3697, ptr %state, ptr undef)
  store ptr %3698, ptr %MEMORY, align 8
  %3699 = load i64, ptr %NEXT_PC, align 8
  store i64 %3699, ptr %PC, align 8
  %3700 = add i64 %3699, 1
  store i64 %3700, ptr %NEXT_PC, align 8
  %3701 = load ptr, ptr %MEMORY, align 8
  %3702 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3701, ptr %state, ptr undef)
  store ptr %3702, ptr %MEMORY, align 8
  %3703 = load i64, ptr %NEXT_PC, align 8
  store i64 %3703, ptr %PC, align 8
  %3704 = add i64 %3703, 1
  store i64 %3704, ptr %NEXT_PC, align 8
  %3705 = load ptr, ptr %MEMORY, align 8
  %3706 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3705, ptr %state, ptr undef)
  store ptr %3706, ptr %MEMORY, align 8
  %3707 = load i64, ptr %NEXT_PC, align 8
  store i64 %3707, ptr %PC, align 8
  %3708 = add i64 %3707, 1
  store i64 %3708, ptr %NEXT_PC, align 8
  %3709 = load ptr, ptr %MEMORY, align 8
  %3710 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3709, ptr %state, ptr undef)
  store ptr %3710, ptr %MEMORY, align 8
  %3711 = load i64, ptr %NEXT_PC, align 8
  store i64 %3711, ptr %PC, align 8
  %3712 = add i64 %3711, 1
  store i64 %3712, ptr %NEXT_PC, align 8
  %3713 = load ptr, ptr %MEMORY, align 8
  %3714 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3713, ptr %state, ptr undef)
  store ptr %3714, ptr %MEMORY, align 8
  %3715 = load i64, ptr %NEXT_PC, align 8
  store i64 %3715, ptr %PC, align 8
  %3716 = add i64 %3715, 1
  store i64 %3716, ptr %NEXT_PC, align 8
  %3717 = load ptr, ptr %MEMORY, align 8
  %3718 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3717, ptr %state, ptr undef)
  store ptr %3718, ptr %MEMORY, align 8
  %3719 = load i64, ptr %NEXT_PC, align 8
  store i64 %3719, ptr %PC, align 8
  %3720 = add i64 %3719, 1
  store i64 %3720, ptr %NEXT_PC, align 8
  %3721 = load ptr, ptr %MEMORY, align 8
  %3722 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3721, ptr %state, ptr undef)
  store ptr %3722, ptr %MEMORY, align 8
  %3723 = load i64, ptr %NEXT_PC, align 8
  store i64 %3723, ptr %PC, align 8
  %3724 = add i64 %3723, 1
  store i64 %3724, ptr %NEXT_PC, align 8
  %3725 = load ptr, ptr %MEMORY, align 8
  %3726 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3725, ptr %state, ptr undef)
  store ptr %3726, ptr %MEMORY, align 8
  %3727 = load i64, ptr %NEXT_PC, align 8
  store i64 %3727, ptr %PC, align 8
  %3728 = add i64 %3727, 1
  store i64 %3728, ptr %NEXT_PC, align 8
  %3729 = load ptr, ptr %MEMORY, align 8
  %3730 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3729, ptr %state, ptr undef)
  store ptr %3730, ptr %MEMORY, align 8
  %3731 = load i64, ptr %NEXT_PC, align 8
  store i64 %3731, ptr %PC, align 8
  %3732 = add i64 %3731, 1
  store i64 %3732, ptr %NEXT_PC, align 8
  %3733 = load ptr, ptr %MEMORY, align 8
  %3734 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3733, ptr %state, ptr undef)
  store ptr %3734, ptr %MEMORY, align 8
  %3735 = load i64, ptr %NEXT_PC, align 8
  store i64 %3735, ptr %PC, align 8
  %3736 = add i64 %3735, 1
  store i64 %3736, ptr %NEXT_PC, align 8
  %3737 = load ptr, ptr %MEMORY, align 8
  %3738 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3737, ptr %state, ptr undef)
  store ptr %3738, ptr %MEMORY, align 8
  %3739 = load i64, ptr %NEXT_PC, align 8
  store i64 %3739, ptr %PC, align 8
  %3740 = add i64 %3739, 5
  store i64 %3740, ptr %NEXT_PC, align 8
  %3741 = load i64, ptr %RSP, align 8
  %3742 = add i64 %3741, 8
  %3743 = load i64, ptr %RBX, align 8
  %3744 = load ptr, ptr %MEMORY, align 8
  %3745 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3744, ptr %state, i64 %3742, i64 %3743)
  store ptr %3745, ptr %MEMORY, align 8
  %3746 = load i64, ptr %NEXT_PC, align 8
  store i64 %3746, ptr %PC, align 8
  %3747 = add i64 %3746, 5
  store i64 %3747, ptr %NEXT_PC, align 8
  %3748 = load i64, ptr %RSP, align 8
  %3749 = add i64 %3748, 16
  %3750 = load i64, ptr %RBP, align 8
  %3751 = load ptr, ptr %MEMORY, align 8
  %3752 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3751, ptr %state, i64 %3749, i64 %3750)
  store ptr %3752, ptr %MEMORY, align 8
  %3753 = load i64, ptr %NEXT_PC, align 8
  store i64 %3753, ptr %PC, align 8
  %3754 = add i64 %3753, 5
  store i64 %3754, ptr %NEXT_PC, align 8
  %3755 = load i64, ptr %RSP, align 8
  %3756 = add i64 %3755, 24
  %3757 = load i64, ptr %RSI, align 8
  %3758 = load ptr, ptr %MEMORY, align 8
  %3759 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3758, ptr %state, i64 %3756, i64 %3757)
  store ptr %3759, ptr %MEMORY, align 8
  %3760 = load i64, ptr %NEXT_PC, align 8
  store i64 %3760, ptr %PC, align 8
  %3761 = add i64 %3760, 1
  store i64 %3761, ptr %NEXT_PC, align 8
  %3762 = load i64, ptr %RDI, align 8
  %3763 = load ptr, ptr %MEMORY, align 8
  %3764 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %3763, ptr %state, i64 %3762)
  store ptr %3764, ptr %MEMORY, align 8
  %3765 = load i64, ptr %NEXT_PC, align 8
  store i64 %3765, ptr %PC, align 8
  %3766 = add i64 %3765, 4
  store i64 %3766, ptr %NEXT_PC, align 8
  %3767 = load i64, ptr %RSP, align 8
  %3768 = load ptr, ptr %MEMORY, align 8
  %3769 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3768, ptr %state, ptr %RSP, i64 %3767, i64 32)
  store ptr %3769, ptr %MEMORY, align 8
  %3770 = load i64, ptr %NEXT_PC, align 8
  store i64 %3770, ptr %PC, align 8
  %3771 = add i64 %3770, 3
  store i64 %3771, ptr %NEXT_PC, align 8
  %3772 = load i64, ptr %RDX, align 8
  %3773 = load ptr, ptr %MEMORY, align 8
  %3774 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3773, ptr %state, ptr %RBP, i64 %3772)
  store ptr %3774, ptr %MEMORY, align 8
  %3775 = load i64, ptr %NEXT_PC, align 8
  store i64 %3775, ptr %PC, align 8
  %3776 = add i64 %3775, 3
  store i64 %3776, ptr %NEXT_PC, align 8
  %3777 = load i64, ptr %RCX, align 8
  %3778 = load ptr, ptr %MEMORY, align 8
  %3779 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3778, ptr %state, ptr %RDI, i64 %3777)
  store ptr %3779, ptr %MEMORY, align 8
  %3780 = load i64, ptr %NEXT_PC, align 8
  store i64 %3780, ptr %PC, align 8
  %3781 = add i64 %3780, 2
  store i64 %3781, ptr %NEXT_PC, align 8
  %3782 = load i64, ptr %RBX, align 8
  %3783 = load i32, ptr %EBX, align 4
  %3784 = zext i32 %3783 to i64
  %3785 = load ptr, ptr %MEMORY, align 8
  %3786 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %3785, ptr %state, ptr %RBX, i64 %3782, i64 %3784)
  store ptr %3786, ptr %MEMORY, align 8
  %3787 = load i64, ptr %NEXT_PC, align 8
  store i64 %3787, ptr %PC, align 8
  %3788 = add i64 %3787, 5
  store i64 %3788, ptr %NEXT_PC, align 8
  %3789 = load i64, ptr %NEXT_PC, align 8
  %3790 = add i64 %3789, 223
  %3791 = load i64, ptr %NEXT_PC, align 8
  %3792 = load ptr, ptr %MEMORY, align 8
  %3793 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3792, ptr %state, i64 %3790, ptr %NEXT_PC, i64 %3791, ptr %RETURN_PC)
  store ptr %3793, ptr %MEMORY, align 8
  %3794 = load i64, ptr %NEXT_PC, align 8
  store i64 %3794, ptr %PC, align 8
  %3795 = add i64 %3794, 2
  store i64 %3795, ptr %NEXT_PC, align 8
  %3796 = load i32, ptr %EAX, align 4
  %3797 = zext i32 %3796 to i64
  %3798 = load i32, ptr %EAX, align 4
  %3799 = zext i32 %3798 to i64
  %3800 = load ptr, ptr %MEMORY, align 8
  %3801 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3800, ptr %state, i64 %3797, i64 %3799)
  store ptr %3801, ptr %MEMORY, align 8
  %3802 = load i64, ptr %NEXT_PC, align 8
  store i64 %3802, ptr %PC, align 8
  %3803 = add i64 %3802, 2
  store i64 %3803, ptr %NEXT_PC, align 8
  %3804 = load i64, ptr %NEXT_PC, align 8
  %3805 = add i64 %3804, 42
  %3806 = load i64, ptr %NEXT_PC, align 8
  %3807 = load ptr, ptr %MEMORY, align 8
  %3808 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3807, ptr %state, ptr %BRANCH_TAKEN, i64 %3805, i64 %3806, ptr %NEXT_PC)
  store ptr %3808, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659471, label %bb_5395659429

bb_5395659429:                                    ; preds = %bb_5395659457, %bb_5395659376
  %3809 = load i64, ptr %NEXT_PC, align 8
  store i64 %3809, ptr %PC, align 8
  %3810 = add i64 %3809, 2
  store i64 %3810, ptr %NEXT_PC, align 8
  %3811 = load i32, ptr %EBX, align 4
  %3812 = zext i32 %3811 to i64
  %3813 = load ptr, ptr %MEMORY, align 8
  %3814 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3813, ptr %state, ptr %RDX, i64 %3812)
  store ptr %3814, ptr %MEMORY, align 8
  %3815 = load i64, ptr %NEXT_PC, align 8
  store i64 %3815, ptr %PC, align 8
  %3816 = add i64 %3815, 3
  store i64 %3816, ptr %NEXT_PC, align 8
  %3817 = load i64, ptr %RDI, align 8
  %3818 = load ptr, ptr %MEMORY, align 8
  %3819 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3818, ptr %state, ptr %RCX, i64 %3817)
  store ptr %3819, ptr %MEMORY, align 8
  %3820 = load i64, ptr %NEXT_PC, align 8
  store i64 %3820, ptr %PC, align 8
  %3821 = add i64 %3820, 5
  store i64 %3821, ptr %NEXT_PC, align 8
  %3822 = load i64, ptr %NEXT_PC, align 8
  %3823 = sub i64 %3822, 79
  %3824 = load i64, ptr %NEXT_PC, align 8
  %3825 = load ptr, ptr %MEMORY, align 8
  %3826 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3825, ptr %state, i64 %3823, ptr %NEXT_PC, i64 %3824, ptr %RETURN_PC)
  store ptr %3826, ptr %MEMORY, align 8
  %3827 = load i64, ptr %NEXT_PC, align 8
  store i64 %3827, ptr %PC, align 8
  %3828 = add i64 %3827, 3
  store i64 %3828, ptr %NEXT_PC, align 8
  %3829 = load i64, ptr %RBP, align 8
  %3830 = load ptr, ptr %MEMORY, align 8
  %3831 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3830, ptr %state, ptr %RDX, i64 %3829)
  store ptr %3831, ptr %MEMORY, align 8
  %3832 = load i64, ptr %NEXT_PC, align 8
  store i64 %3832, ptr %PC, align 8
  %3833 = add i64 %3832, 3
  store i64 %3833, ptr %NEXT_PC, align 8
  %3834 = load i64, ptr %RAX, align 8
  %3835 = load ptr, ptr %MEMORY, align 8
  %3836 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3835, ptr %state, ptr %RSI, i64 %3834)
  store ptr %3836, ptr %MEMORY, align 8
  %3837 = load i64, ptr %NEXT_PC, align 8
  store i64 %3837, ptr %PC, align 8
  %3838 = add i64 %3837, 3
  store i64 %3838, ptr %NEXT_PC, align 8
  %3839 = load i64, ptr %RAX, align 8
  %3840 = load ptr, ptr %MEMORY, align 8
  %3841 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3840, ptr %state, ptr %RCX, i64 %3839)
  store ptr %3841, ptr %MEMORY, align 8
  %3842 = load i64, ptr %NEXT_PC, align 8
  store i64 %3842, ptr %PC, align 8
  %3843 = add i64 %3842, 5
  store i64 %3843, ptr %NEXT_PC, align 8
  %3844 = load i64, ptr %NEXT_PC, align 8
  %3845 = add i64 %3844, 44867
  %3846 = load i64, ptr %NEXT_PC, align 8
  %3847 = load ptr, ptr %MEMORY, align 8
  %3848 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3847, ptr %state, i64 %3845, ptr %NEXT_PC, i64 %3846, ptr %RETURN_PC)
  store ptr %3848, ptr %MEMORY, align 8
  %3849 = load i64, ptr %NEXT_PC, align 8
  store i64 %3849, ptr %PC, align 8
  %3850 = add i64 %3849, 2
  store i64 %3850, ptr %NEXT_PC, align 8
  %3851 = load i32, ptr %EAX, align 4
  %3852 = zext i32 %3851 to i64
  %3853 = load i32, ptr %EAX, align 4
  %3854 = zext i32 %3853 to i64
  %3855 = load ptr, ptr %MEMORY, align 8
  %3856 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3855, ptr %state, i64 %3852, i64 %3854)
  store ptr %3856, ptr %MEMORY, align 8
  %3857 = load i64, ptr %NEXT_PC, align 8
  store i64 %3857, ptr %PC, align 8
  %3858 = add i64 %3857, 2
  store i64 %3858, ptr %NEXT_PC, align 8
  %3859 = load i64, ptr %NEXT_PC, align 8
  %3860 = add i64 %3859, 37
  %3861 = load i64, ptr %NEXT_PC, align 8
  %3862 = load ptr, ptr %MEMORY, align 8
  %3863 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3862, ptr %state, ptr %BRANCH_TAKEN, i64 %3860, i64 %3861, ptr %NEXT_PC)
  store ptr %3863, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659494, label %bb_5395659457

bb_5395659457:                                    ; preds = %bb_5395659429
  %3864 = load i64, ptr %NEXT_PC, align 8
  store i64 %3864, ptr %PC, align 8
  %3865 = add i64 %3864, 3
  store i64 %3865, ptr %NEXT_PC, align 8
  %3866 = load i64, ptr %RDI, align 8
  %3867 = load ptr, ptr %MEMORY, align 8
  %3868 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3867, ptr %state, ptr %RCX, i64 %3866)
  store ptr %3868, ptr %MEMORY, align 8
  %3869 = load i64, ptr %NEXT_PC, align 8
  store i64 %3869, ptr %PC, align 8
  %3870 = add i64 %3869, 2
  store i64 %3870, ptr %NEXT_PC, align 8
  %3871 = load i64, ptr %RBX, align 8
  %3872 = load ptr, ptr %MEMORY, align 8
  %3873 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3872, ptr %state, ptr %RBX, i64 %3871)
  store ptr %3873, ptr %MEMORY, align 8
  %3874 = load i64, ptr %NEXT_PC, align 8
  store i64 %3874, ptr %PC, align 8
  %3875 = add i64 %3874, 5
  store i64 %3875, ptr %NEXT_PC, align 8
  %3876 = load i64, ptr %NEXT_PC, align 8
  %3877 = add i64 %3876, 181
  %3878 = load i64, ptr %NEXT_PC, align 8
  %3879 = load ptr, ptr %MEMORY, align 8
  %3880 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3879, ptr %state, i64 %3877, ptr %NEXT_PC, i64 %3878, ptr %RETURN_PC)
  store ptr %3880, ptr %MEMORY, align 8
  %3881 = load i64, ptr %NEXT_PC, align 8
  store i64 %3881, ptr %PC, align 8
  %3882 = add i64 %3881, 2
  store i64 %3882, ptr %NEXT_PC, align 8
  %3883 = load i32, ptr %EBX, align 4
  %3884 = zext i32 %3883 to i64
  %3885 = load i32, ptr %EAX, align 4
  %3886 = zext i32 %3885 to i64
  %3887 = load ptr, ptr %MEMORY, align 8
  %3888 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3887, ptr %state, i64 %3884, i64 %3886)
  store ptr %3888, ptr %MEMORY, align 8
  %3889 = load i64, ptr %NEXT_PC, align 8
  store i64 %3889, ptr %PC, align 8
  %3890 = add i64 %3889, 2
  store i64 %3890, ptr %NEXT_PC, align 8
  %3891 = load i64, ptr %NEXT_PC, align 8
  %3892 = sub i64 %3891, 42
  %3893 = load i64, ptr %NEXT_PC, align 8
  %3894 = load ptr, ptr %MEMORY, align 8
  %3895 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3894, ptr %state, ptr %BRANCH_TAKEN, i64 %3892, i64 %3893, ptr %NEXT_PC)
  store ptr %3895, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659429, label %bb_5395659471

bb_5395659471:                                    ; preds = %bb_5395659457, %bb_5395659376
  %3896 = load i64, ptr %NEXT_PC, align 8
  store i64 %3896, ptr %PC, align 8
  %3897 = add i64 %3896, 2
  store i64 %3897, ptr %NEXT_PC, align 8
  %3898 = load i64, ptr %RAX, align 8
  %3899 = load i32, ptr %EAX, align 4
  %3900 = zext i32 %3899 to i64
  %3901 = load ptr, ptr %MEMORY, align 8
  %3902 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %3901, ptr %state, ptr %RAX, i64 %3898, i64 %3900)
  store ptr %3902, ptr %MEMORY, align 8
  br label %bb_5395659473

bb_5395659473:                                    ; preds = %bb_5395659494, %bb_5395659471
  %3903 = load i64, ptr %NEXT_PC, align 8
  store i64 %3903, ptr %PC, align 8
  %3904 = add i64 %3903, 5
  store i64 %3904, ptr %NEXT_PC, align 8
  %3905 = load i64, ptr %RSP, align 8
  %3906 = add i64 %3905, 48
  %3907 = load ptr, ptr %MEMORY, align 8
  %3908 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3907, ptr %state, ptr %RBX, i64 %3906)
  store ptr %3908, ptr %MEMORY, align 8
  %3909 = load i64, ptr %NEXT_PC, align 8
  store i64 %3909, ptr %PC, align 8
  %3910 = add i64 %3909, 5
  store i64 %3910, ptr %NEXT_PC, align 8
  %3911 = load i64, ptr %RSP, align 8
  %3912 = add i64 %3911, 56
  %3913 = load ptr, ptr %MEMORY, align 8
  %3914 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3913, ptr %state, ptr %RBP, i64 %3912)
  store ptr %3914, ptr %MEMORY, align 8
  %3915 = load i64, ptr %NEXT_PC, align 8
  store i64 %3915, ptr %PC, align 8
  %3916 = add i64 %3915, 5
  store i64 %3916, ptr %NEXT_PC, align 8
  %3917 = load i64, ptr %RSP, align 8
  %3918 = add i64 %3917, 64
  %3919 = load ptr, ptr %MEMORY, align 8
  %3920 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3919, ptr %state, ptr %RSI, i64 %3918)
  store ptr %3920, ptr %MEMORY, align 8
  %3921 = load i64, ptr %NEXT_PC, align 8
  store i64 %3921, ptr %PC, align 8
  %3922 = add i64 %3921, 4
  store i64 %3922, ptr %NEXT_PC, align 8
  %3923 = load i64, ptr %RSP, align 8
  %3924 = load ptr, ptr %MEMORY, align 8
  %3925 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3924, ptr %state, ptr %RSP, i64 %3923, i64 32)
  store ptr %3925, ptr %MEMORY, align 8
  %3926 = load i64, ptr %NEXT_PC, align 8
  store i64 %3926, ptr %PC, align 8
  %3927 = add i64 %3926, 1
  store i64 %3927, ptr %NEXT_PC, align 8
  %3928 = load ptr, ptr %MEMORY, align 8
  %3929 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %3928, ptr %state, ptr %RDI)
  store ptr %3929, ptr %MEMORY, align 8
  %3930 = load i64, ptr %NEXT_PC, align 8
  store i64 %3930, ptr %PC, align 8
  %3931 = add i64 %3930, 1
  store i64 %3931, ptr %NEXT_PC, align 8
  %3932 = load ptr, ptr %MEMORY, align 8
  %3933 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %3932, ptr %state, ptr %NEXT_PC)
  store ptr %3933, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659494:                                    ; preds = %bb_5395659429
  %3934 = load i64, ptr %NEXT_PC, align 8
  store i64 %3934, ptr %PC, align 8
  %3935 = add i64 %3934, 3
  store i64 %3935, ptr %NEXT_PC, align 8
  %3936 = load i64, ptr %RSI, align 8
  %3937 = load ptr, ptr %MEMORY, align 8
  %3938 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3937, ptr %state, ptr %RAX, i64 %3936)
  store ptr %3938, ptr %MEMORY, align 8
  %3939 = load i64, ptr %NEXT_PC, align 8
  store i64 %3939, ptr %PC, align 8
  %3940 = add i64 %3939, 2
  store i64 %3940, ptr %NEXT_PC, align 8
  %3941 = load i64, ptr %NEXT_PC, align 8
  %3942 = sub i64 %3941, 26
  %3943 = load ptr, ptr %MEMORY, align 8
  %3944 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %3943, ptr %state, i64 %3942, ptr %NEXT_PC)
  store ptr %3944, ptr %MEMORY, align 8
  br label %bb_5395659473
  %3945 = load i64, ptr %NEXT_PC, align 8
  store i64 %3945, ptr %PC, align 8
  %3946 = add i64 %3945, 1
  store i64 %3946, ptr %NEXT_PC, align 8
  %3947 = load ptr, ptr %MEMORY, align 8
  %3948 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3947, ptr %state, ptr undef)
  store ptr %3948, ptr %MEMORY, align 8
  %3949 = load i64, ptr %NEXT_PC, align 8
  store i64 %3949, ptr %PC, align 8
  %3950 = add i64 %3949, 1
  store i64 %3950, ptr %NEXT_PC, align 8
  %3951 = load ptr, ptr %MEMORY, align 8
  %3952 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3951, ptr %state, ptr undef)
  store ptr %3952, ptr %MEMORY, align 8
  %3953 = load i64, ptr %NEXT_PC, align 8
  store i64 %3953, ptr %PC, align 8
  %3954 = add i64 %3953, 1
  store i64 %3954, ptr %NEXT_PC, align 8
  %3955 = load ptr, ptr %MEMORY, align 8
  %3956 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3955, ptr %state, ptr undef)
  store ptr %3956, ptr %MEMORY, align 8
  %3957 = load i64, ptr %NEXT_PC, align 8
  store i64 %3957, ptr %PC, align 8
  %3958 = add i64 %3957, 1
  store i64 %3958, ptr %NEXT_PC, align 8
  %3959 = load ptr, ptr %MEMORY, align 8
  %3960 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3959, ptr %state, ptr undef)
  store ptr %3960, ptr %MEMORY, align 8
  %3961 = load i64, ptr %NEXT_PC, align 8
  store i64 %3961, ptr %PC, align 8
  %3962 = add i64 %3961, 1
  store i64 %3962, ptr %NEXT_PC, align 8
  %3963 = load ptr, ptr %MEMORY, align 8
  %3964 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3963, ptr %state, ptr undef)
  store ptr %3964, ptr %MEMORY, align 8
  %3965 = load i64, ptr %NEXT_PC, align 8
  store i64 %3965, ptr %PC, align 8
  %3966 = add i64 %3965, 1
  store i64 %3966, ptr %NEXT_PC, align 8
  %3967 = load ptr, ptr %MEMORY, align 8
  %3968 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3967, ptr %state, ptr undef)
  store ptr %3968, ptr %MEMORY, align 8
  %3969 = load i64, ptr %NEXT_PC, align 8
  store i64 %3969, ptr %PC, align 8
  %3970 = add i64 %3969, 1
  store i64 %3970, ptr %NEXT_PC, align 8
  %3971 = load ptr, ptr %MEMORY, align 8
  %3972 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3971, ptr %state, ptr undef)
  store ptr %3972, ptr %MEMORY, align 8
  %3973 = load i64, ptr %NEXT_PC, align 8
  store i64 %3973, ptr %PC, align 8
  %3974 = add i64 %3973, 1
  store i64 %3974, ptr %NEXT_PC, align 8
  %3975 = load ptr, ptr %MEMORY, align 8
  %3976 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3975, ptr %state, ptr undef)
  store ptr %3976, ptr %MEMORY, align 8
  %3977 = load i64, ptr %NEXT_PC, align 8
  store i64 %3977, ptr %PC, align 8
  %3978 = add i64 %3977, 1
  store i64 %3978, ptr %NEXT_PC, align 8
  %3979 = load ptr, ptr %MEMORY, align 8
  %3980 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3979, ptr %state, ptr undef)
  store ptr %3980, ptr %MEMORY, align 8
  %3981 = load i64, ptr %NEXT_PC, align 8
  store i64 %3981, ptr %PC, align 8
  %3982 = add i64 %3981, 1
  store i64 %3982, ptr %NEXT_PC, align 8
  %3983 = load ptr, ptr %MEMORY, align 8
  %3984 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3983, ptr %state, ptr undef)
  store ptr %3984, ptr %MEMORY, align 8
  %3985 = load i64, ptr %NEXT_PC, align 8
  store i64 %3985, ptr %PC, align 8
  %3986 = add i64 %3985, 1
  store i64 %3986, ptr %NEXT_PC, align 8
  %3987 = load ptr, ptr %MEMORY, align 8
  %3988 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3987, ptr %state, ptr undef)
  store ptr %3988, ptr %MEMORY, align 8
  %3989 = load i64, ptr %NEXT_PC, align 8
  store i64 %3989, ptr %PC, align 8
  %3990 = add i64 %3989, 1
  store i64 %3990, ptr %NEXT_PC, align 8
  %3991 = load ptr, ptr %MEMORY, align 8
  %3992 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3991, ptr %state, ptr undef)
  store ptr %3992, ptr %MEMORY, align 8
  %3993 = load i64, ptr %NEXT_PC, align 8
  store i64 %3993, ptr %PC, align 8
  %3994 = add i64 %3993, 1
  store i64 %3994, ptr %NEXT_PC, align 8
  %3995 = load ptr, ptr %MEMORY, align 8
  %3996 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3995, ptr %state, ptr undef)
  store ptr %3996, ptr %MEMORY, align 8
  %3997 = load i64, ptr %NEXT_PC, align 8
  store i64 %3997, ptr %PC, align 8
  %3998 = add i64 %3997, 1
  store i64 %3998, ptr %NEXT_PC, align 8
  %3999 = load ptr, ptr %MEMORY, align 8
  %4000 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3999, ptr %state, ptr undef)
  store ptr %4000, ptr %MEMORY, align 8
  %4001 = load i64, ptr %NEXT_PC, align 8
  store i64 %4001, ptr %PC, align 8
  %4002 = add i64 %4001, 1
  store i64 %4002, ptr %NEXT_PC, align 8
  %4003 = load ptr, ptr %MEMORY, align 8
  %4004 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4003, ptr %state, ptr undef)
  store ptr %4004, ptr %MEMORY, align 8
  %4005 = load i64, ptr %NEXT_PC, align 8
  store i64 %4005, ptr %PC, align 8
  %4006 = add i64 %4005, 1
  store i64 %4006, ptr %NEXT_PC, align 8
  %4007 = load ptr, ptr %MEMORY, align 8
  %4008 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4007, ptr %state, ptr undef)
  store ptr %4008, ptr %MEMORY, align 8
  %4009 = load i64, ptr %NEXT_PC, align 8
  store i64 %4009, ptr %PC, align 8
  %4010 = add i64 %4009, 1
  store i64 %4010, ptr %NEXT_PC, align 8
  %4011 = load ptr, ptr %MEMORY, align 8
  %4012 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4011, ptr %state, ptr undef)
  store ptr %4012, ptr %MEMORY, align 8
  %4013 = load i64, ptr %NEXT_PC, align 8
  store i64 %4013, ptr %PC, align 8
  %4014 = add i64 %4013, 1
  store i64 %4014, ptr %NEXT_PC, align 8
  %4015 = load ptr, ptr %MEMORY, align 8
  %4016 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4015, ptr %state, ptr undef)
  store ptr %4016, ptr %MEMORY, align 8
  %4017 = load i64, ptr %NEXT_PC, align 8
  store i64 %4017, ptr %PC, align 8
  %4018 = add i64 %4017, 1
  store i64 %4018, ptr %NEXT_PC, align 8
  %4019 = load ptr, ptr %MEMORY, align 8
  %4020 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4019, ptr %state, ptr undef)
  store ptr %4020, ptr %MEMORY, align 8
  %4021 = load i64, ptr %NEXT_PC, align 8
  store i64 %4021, ptr %PC, align 8
  %4022 = add i64 %4021, 1
  store i64 %4022, ptr %NEXT_PC, align 8
  %4023 = load ptr, ptr %MEMORY, align 8
  %4024 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4023, ptr %state, ptr undef)
  store ptr %4024, ptr %MEMORY, align 8
  %4025 = load i64, ptr %NEXT_PC, align 8
  store i64 %4025, ptr %PC, align 8
  %4026 = add i64 %4025, 1
  store i64 %4026, ptr %NEXT_PC, align 8
  %4027 = load ptr, ptr %MEMORY, align 8
  %4028 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4027, ptr %state, ptr undef)
  store ptr %4028, ptr %MEMORY, align 8
  %4029 = load i64, ptr %NEXT_PC, align 8
  store i64 %4029, ptr %PC, align 8
  %4030 = add i64 %4029, 5
  store i64 %4030, ptr %NEXT_PC, align 8
  %4031 = load i64, ptr %RSP, align 8
  %4032 = add i64 %4031, 8
  %4033 = load i64, ptr %RBX, align 8
  %4034 = load ptr, ptr %MEMORY, align 8
  %4035 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4034, ptr %state, i64 %4032, i64 %4033)
  store ptr %4035, ptr %MEMORY, align 8
  %4036 = load i64, ptr %NEXT_PC, align 8
  store i64 %4036, ptr %PC, align 8
  %4037 = add i64 %4036, 5
  store i64 %4037, ptr %NEXT_PC, align 8
  %4038 = load i64, ptr %RSP, align 8
  %4039 = add i64 %4038, 16
  %4040 = load i64, ptr %RSI, align 8
  %4041 = load ptr, ptr %MEMORY, align 8
  %4042 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4041, ptr %state, i64 %4039, i64 %4040)
  store ptr %4042, ptr %MEMORY, align 8
  %4043 = load i64, ptr %NEXT_PC, align 8
  store i64 %4043, ptr %PC, align 8
  %4044 = add i64 %4043, 1
  store i64 %4044, ptr %NEXT_PC, align 8
  %4045 = load i64, ptr %RDI, align 8
  %4046 = load ptr, ptr %MEMORY, align 8
  %4047 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %4046, ptr %state, i64 %4045)
  store ptr %4047, ptr %MEMORY, align 8
  %4048 = load i64, ptr %NEXT_PC, align 8
  store i64 %4048, ptr %PC, align 8
  %4049 = add i64 %4048, 4
  store i64 %4049, ptr %NEXT_PC, align 8
  %4050 = load i64, ptr %RSP, align 8
  %4051 = load ptr, ptr %MEMORY, align 8
  %4052 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4051, ptr %state, ptr %RSP, i64 %4050, i64 32)
  store ptr %4052, ptr %MEMORY, align 8
  %4053 = load i64, ptr %NEXT_PC, align 8
  store i64 %4053, ptr %PC, align 8
  %4054 = add i64 %4053, 3
  store i64 %4054, ptr %NEXT_PC, align 8
  %4055 = load i64, ptr %RDX, align 8
  %4056 = load ptr, ptr %MEMORY, align 8
  %4057 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4056, ptr %state, ptr %RSI, i64 %4055)
  store ptr %4057, ptr %MEMORY, align 8
  %4058 = load i64, ptr %NEXT_PC, align 8
  store i64 %4058, ptr %PC, align 8
  %4059 = add i64 %4058, 3
  store i64 %4059, ptr %NEXT_PC, align 8
  %4060 = load i64, ptr %RCX, align 8
  %4061 = load ptr, ptr %MEMORY, align 8
  %4062 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4061, ptr %state, ptr %RDI, i64 %4060)
  store ptr %4062, ptr %MEMORY, align 8
  %4063 = load i64, ptr %NEXT_PC, align 8
  store i64 %4063, ptr %PC, align 8
  %4064 = add i64 %4063, 2
  store i64 %4064, ptr %NEXT_PC, align 8
  %4065 = load i64, ptr %RBX, align 8
  %4066 = load i32, ptr %EBX, align 4
  %4067 = zext i32 %4066 to i64
  %4068 = load ptr, ptr %MEMORY, align 8
  %4069 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4068, ptr %state, ptr %RBX, i64 %4065, i64 %4067)
  store ptr %4069, ptr %MEMORY, align 8
  %4070 = load i64, ptr %NEXT_PC, align 8
  store i64 %4070, ptr %PC, align 8
  %4071 = add i64 %4070, 5
  store i64 %4071, ptr %NEXT_PC, align 8
  %4072 = load i64, ptr %NEXT_PC, align 8
  %4073 = add i64 %4072, 100
  %4074 = load i64, ptr %NEXT_PC, align 8
  %4075 = load ptr, ptr %MEMORY, align 8
  %4076 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4075, ptr %state, i64 %4073, ptr %NEXT_PC, i64 %4074, ptr %RETURN_PC)
  store ptr %4076, ptr %MEMORY, align 8
  %4077 = load i64, ptr %NEXT_PC, align 8
  store i64 %4077, ptr %PC, align 8
  %4078 = add i64 %4077, 2
  store i64 %4078, ptr %NEXT_PC, align 8
  %4079 = load i32, ptr %EAX, align 4
  %4080 = zext i32 %4079 to i64
  %4081 = load i32, ptr %EAX, align 4
  %4082 = zext i32 %4081 to i64
  %4083 = load ptr, ptr %MEMORY, align 8
  %4084 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4083, ptr %state, i64 %4080, i64 %4082)
  store ptr %4084, ptr %MEMORY, align 8
  %4085 = load i64, ptr %NEXT_PC, align 8
  store i64 %4085, ptr %PC, align 8
  %4086 = add i64 %4085, 2
  store i64 %4086, ptr %NEXT_PC, align 8
  %4087 = load i64, ptr %NEXT_PC, align 8
  %4088 = add i64 %4087, 39
  %4089 = load i64, ptr %NEXT_PC, align 8
  %4090 = load ptr, ptr %MEMORY, align 8
  %4091 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4090, ptr %state, ptr %BRANCH_TAKEN, i64 %4088, i64 %4089, ptr %NEXT_PC)
  store ptr %4091, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659591, label %bb_5395659552

bb_5395659552:                                    ; preds = %bb_5395659577, %bb_5395659494
  %4092 = load i64, ptr %NEXT_PC, align 8
  store i64 %4092, ptr %PC, align 8
  %4093 = add i64 %4092, 2
  store i64 %4093, ptr %NEXT_PC, align 8
  %4094 = load i32, ptr %EBX, align 4
  %4095 = zext i32 %4094 to i64
  %4096 = load ptr, ptr %MEMORY, align 8
  %4097 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4096, ptr %state, ptr %RDX, i64 %4095)
  store ptr %4097, ptr %MEMORY, align 8
  %4098 = load i64, ptr %NEXT_PC, align 8
  store i64 %4098, ptr %PC, align 8
  %4099 = add i64 %4098, 3
  store i64 %4099, ptr %NEXT_PC, align 8
  %4100 = load i64, ptr %RDI, align 8
  %4101 = load ptr, ptr %MEMORY, align 8
  %4102 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4101, ptr %state, ptr %RCX, i64 %4100)
  store ptr %4102, ptr %MEMORY, align 8
  %4103 = load i64, ptr %NEXT_PC, align 8
  store i64 %4103, ptr %PC, align 8
  %4104 = add i64 %4103, 5
  store i64 %4104, ptr %NEXT_PC, align 8
  %4105 = load i64, ptr %NEXT_PC, align 8
  %4106 = sub i64 %4105, 202
  %4107 = load i64, ptr %NEXT_PC, align 8
  %4108 = load ptr, ptr %MEMORY, align 8
  %4109 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4108, ptr %state, i64 %4106, ptr %NEXT_PC, i64 %4107, ptr %RETURN_PC)
  store ptr %4109, ptr %MEMORY, align 8
  %4110 = load i64, ptr %NEXT_PC, align 8
  store i64 %4110, ptr %PC, align 8
  %4111 = add i64 %4110, 3
  store i64 %4111, ptr %NEXT_PC, align 8
  %4112 = load i64, ptr %RSI, align 8
  %4113 = load ptr, ptr %MEMORY, align 8
  %4114 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4113, ptr %state, ptr %RDX, i64 %4112)
  store ptr %4114, ptr %MEMORY, align 8
  %4115 = load i64, ptr %NEXT_PC, align 8
  store i64 %4115, ptr %PC, align 8
  %4116 = add i64 %4115, 3
  store i64 %4116, ptr %NEXT_PC, align 8
  %4117 = load i64, ptr %RAX, align 8
  %4118 = load ptr, ptr %MEMORY, align 8
  %4119 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4118, ptr %state, ptr %RCX, i64 %4117)
  store ptr %4119, ptr %MEMORY, align 8
  %4120 = load i64, ptr %NEXT_PC, align 8
  store i64 %4120, ptr %PC, align 8
  %4121 = add i64 %4120, 5
  store i64 %4121, ptr %NEXT_PC, align 8
  %4122 = load i64, ptr %NEXT_PC, align 8
  %4123 = add i64 %4122, 44747
  %4124 = load i64, ptr %NEXT_PC, align 8
  %4125 = load ptr, ptr %MEMORY, align 8
  %4126 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4125, ptr %state, i64 %4123, ptr %NEXT_PC, i64 %4124, ptr %RETURN_PC)
  store ptr %4126, ptr %MEMORY, align 8
  %4127 = load i64, ptr %NEXT_PC, align 8
  store i64 %4127, ptr %PC, align 8
  %4128 = add i64 %4127, 2
  store i64 %4128, ptr %NEXT_PC, align 8
  %4129 = load i32, ptr %EAX, align 4
  %4130 = zext i32 %4129 to i64
  %4131 = load i32, ptr %EAX, align 4
  %4132 = zext i32 %4131 to i64
  %4133 = load ptr, ptr %MEMORY, align 8
  %4134 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4133, ptr %state, i64 %4130, i64 %4132)
  store ptr %4134, ptr %MEMORY, align 8
  %4135 = load i64, ptr %NEXT_PC, align 8
  store i64 %4135, ptr %PC, align 8
  %4136 = add i64 %4135, 2
  store i64 %4136, ptr %NEXT_PC, align 8
  %4137 = load i64, ptr %NEXT_PC, align 8
  %4138 = add i64 %4137, 33
  %4139 = load i64, ptr %NEXT_PC, align 8
  %4140 = load ptr, ptr %MEMORY, align 8
  %4141 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4140, ptr %state, ptr %BRANCH_TAKEN, i64 %4138, i64 %4139, ptr %NEXT_PC)
  store ptr %4141, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659610, label %bb_5395659577

bb_5395659577:                                    ; preds = %bb_5395659552
  %4142 = load i64, ptr %NEXT_PC, align 8
  store i64 %4142, ptr %PC, align 8
  %4143 = add i64 %4142, 3
  store i64 %4143, ptr %NEXT_PC, align 8
  %4144 = load i64, ptr %RDI, align 8
  %4145 = load ptr, ptr %MEMORY, align 8
  %4146 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4145, ptr %state, ptr %RCX, i64 %4144)
  store ptr %4146, ptr %MEMORY, align 8
  %4147 = load i64, ptr %NEXT_PC, align 8
  store i64 %4147, ptr %PC, align 8
  %4148 = add i64 %4147, 2
  store i64 %4148, ptr %NEXT_PC, align 8
  %4149 = load i64, ptr %RBX, align 8
  %4150 = load ptr, ptr %MEMORY, align 8
  %4151 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4150, ptr %state, ptr %RBX, i64 %4149)
  store ptr %4151, ptr %MEMORY, align 8
  %4152 = load i64, ptr %NEXT_PC, align 8
  store i64 %4152, ptr %PC, align 8
  %4153 = add i64 %4152, 5
  store i64 %4153, ptr %NEXT_PC, align 8
  %4154 = load i64, ptr %NEXT_PC, align 8
  %4155 = add i64 %4154, 61
  %4156 = load i64, ptr %NEXT_PC, align 8
  %4157 = load ptr, ptr %MEMORY, align 8
  %4158 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4157, ptr %state, i64 %4155, ptr %NEXT_PC, i64 %4156, ptr %RETURN_PC)
  store ptr %4158, ptr %MEMORY, align 8
  %4159 = load i64, ptr %NEXT_PC, align 8
  store i64 %4159, ptr %PC, align 8
  %4160 = add i64 %4159, 2
  store i64 %4160, ptr %NEXT_PC, align 8
  %4161 = load i32, ptr %EBX, align 4
  %4162 = zext i32 %4161 to i64
  %4163 = load i32, ptr %EAX, align 4
  %4164 = zext i32 %4163 to i64
  %4165 = load ptr, ptr %MEMORY, align 8
  %4166 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4165, ptr %state, i64 %4162, i64 %4164)
  store ptr %4166, ptr %MEMORY, align 8
  %4167 = load i64, ptr %NEXT_PC, align 8
  store i64 %4167, ptr %PC, align 8
  %4168 = add i64 %4167, 2
  store i64 %4168, ptr %NEXT_PC, align 8
  %4169 = load i64, ptr %NEXT_PC, align 8
  %4170 = sub i64 %4169, 39
  %4171 = load i64, ptr %NEXT_PC, align 8
  %4172 = load ptr, ptr %MEMORY, align 8
  %4173 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4172, ptr %state, ptr %BRANCH_TAKEN, i64 %4170, i64 %4171, ptr %NEXT_PC)
  store ptr %4173, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659552, label %bb_5395659591

bb_5395659591:                                    ; preds = %bb_5395659577, %bb_5395659494
  %4174 = load i64, ptr %NEXT_PC, align 8
  store i64 %4174, ptr %PC, align 8
  %4175 = add i64 %4174, 3
  store i64 %4175, ptr %NEXT_PC, align 8
  %4176 = load i64, ptr %RAX, align 8
  %4177 = load ptr, ptr %MEMORY, align 8
  %4178 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4177, ptr %state, ptr %RAX, i64 %4176, i64 -1)
  store ptr %4178, ptr %MEMORY, align 8
  %4179 = load i64, ptr %NEXT_PC, align 8
  store i64 %4179, ptr %PC, align 8
  %4180 = add i64 %4179, 5
  store i64 %4180, ptr %NEXT_PC, align 8
  %4181 = load i64, ptr %RSP, align 8
  %4182 = add i64 %4181, 48
  %4183 = load ptr, ptr %MEMORY, align 8
  %4184 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4183, ptr %state, ptr %RBX, i64 %4182)
  store ptr %4184, ptr %MEMORY, align 8
  %4185 = load i64, ptr %NEXT_PC, align 8
  store i64 %4185, ptr %PC, align 8
  %4186 = add i64 %4185, 5
  store i64 %4186, ptr %NEXT_PC, align 8
  %4187 = load i64, ptr %RSP, align 8
  %4188 = add i64 %4187, 56
  %4189 = load ptr, ptr %MEMORY, align 8
  %4190 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4189, ptr %state, ptr %RSI, i64 %4188)
  store ptr %4190, ptr %MEMORY, align 8
  %4191 = load i64, ptr %NEXT_PC, align 8
  store i64 %4191, ptr %PC, align 8
  %4192 = add i64 %4191, 4
  store i64 %4192, ptr %NEXT_PC, align 8
  %4193 = load i64, ptr %RSP, align 8
  %4194 = load ptr, ptr %MEMORY, align 8
  %4195 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4194, ptr %state, ptr %RSP, i64 %4193, i64 32)
  store ptr %4195, ptr %MEMORY, align 8
  %4196 = load i64, ptr %NEXT_PC, align 8
  store i64 %4196, ptr %PC, align 8
  %4197 = add i64 %4196, 1
  store i64 %4197, ptr %NEXT_PC, align 8
  %4198 = load ptr, ptr %MEMORY, align 8
  %4199 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %4198, ptr %state, ptr %RDI)
  store ptr %4199, ptr %MEMORY, align 8
  %4200 = load i64, ptr %NEXT_PC, align 8
  store i64 %4200, ptr %PC, align 8
  %4201 = add i64 %4200, 1
  store i64 %4201, ptr %NEXT_PC, align 8
  %4202 = load ptr, ptr %MEMORY, align 8
  %4203 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4202, ptr %state, ptr %NEXT_PC)
  store ptr %4203, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659610:                                    ; preds = %bb_5395659552
  %4204 = load i64, ptr %NEXT_PC, align 8
  store i64 %4204, ptr %PC, align 8
  %4205 = add i64 %4204, 5
  store i64 %4205, ptr %NEXT_PC, align 8
  %4206 = load i64, ptr %RSP, align 8
  %4207 = add i64 %4206, 56
  %4208 = load ptr, ptr %MEMORY, align 8
  %4209 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4208, ptr %state, ptr %RSI, i64 %4207)
  store ptr %4209, ptr %MEMORY, align 8
  %4210 = load i64, ptr %NEXT_PC, align 8
  store i64 %4210, ptr %PC, align 8
  %4211 = add i64 %4210, 2
  store i64 %4211, ptr %NEXT_PC, align 8
  %4212 = load i32, ptr %EBX, align 4
  %4213 = zext i32 %4212 to i64
  %4214 = load ptr, ptr %MEMORY, align 8
  %4215 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4214, ptr %state, ptr %RAX, i64 %4213)
  store ptr %4215, ptr %MEMORY, align 8
  %4216 = load i64, ptr %NEXT_PC, align 8
  store i64 %4216, ptr %PC, align 8
  %4217 = add i64 %4216, 5
  store i64 %4217, ptr %NEXT_PC, align 8
  %4218 = load i64, ptr %RSP, align 8
  %4219 = add i64 %4218, 48
  %4220 = load ptr, ptr %MEMORY, align 8
  %4221 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4220, ptr %state, ptr %RBX, i64 %4219)
  store ptr %4221, ptr %MEMORY, align 8
  %4222 = load i64, ptr %NEXT_PC, align 8
  store i64 %4222, ptr %PC, align 8
  %4223 = add i64 %4222, 4
  store i64 %4223, ptr %NEXT_PC, align 8
  %4224 = load i64, ptr %RSP, align 8
  %4225 = load ptr, ptr %MEMORY, align 8
  %4226 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4225, ptr %state, ptr %RSP, i64 %4224, i64 32)
  store ptr %4226, ptr %MEMORY, align 8
  %4227 = load i64, ptr %NEXT_PC, align 8
  store i64 %4227, ptr %PC, align 8
  %4228 = add i64 %4227, 1
  store i64 %4228, ptr %NEXT_PC, align 8
  %4229 = load ptr, ptr %MEMORY, align 8
  %4230 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %4229, ptr %state, ptr %RDI)
  store ptr %4230, ptr %MEMORY, align 8
  %4231 = load i64, ptr %NEXT_PC, align 8
  store i64 %4231, ptr %PC, align 8
  %4232 = add i64 %4231, 1
  store i64 %4232, ptr %NEXT_PC, align 8
  %4233 = load ptr, ptr %MEMORY, align 8
  %4234 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4233, ptr %state, ptr %NEXT_PC)
  store ptr %4234, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659628:                                    ; No predecessors!
  %4235 = load i64, ptr %NEXT_PC, align 8
  store i64 %4235, ptr %PC, align 8
  %4236 = add i64 %4235, 1
  store i64 %4236, ptr %NEXT_PC, align 8
  %4237 = load ptr, ptr %MEMORY, align 8
  %4238 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4237, ptr %state, ptr undef)
  store ptr %4238, ptr %MEMORY, align 8
  %4239 = load i64, ptr %NEXT_PC, align 8
  store i64 %4239, ptr %PC, align 8
  %4240 = add i64 %4239, 1
  store i64 %4240, ptr %NEXT_PC, align 8
  %4241 = load ptr, ptr %MEMORY, align 8
  %4242 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4241, ptr %state, ptr undef)
  store ptr %4242, ptr %MEMORY, align 8
  %4243 = load i64, ptr %NEXT_PC, align 8
  store i64 %4243, ptr %PC, align 8
  %4244 = add i64 %4243, 1
  store i64 %4244, ptr %NEXT_PC, align 8
  %4245 = load ptr, ptr %MEMORY, align 8
  %4246 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4245, ptr %state, ptr undef)
  store ptr %4246, ptr %MEMORY, align 8
  %4247 = load i64, ptr %NEXT_PC, align 8
  store i64 %4247, ptr %PC, align 8
  %4248 = add i64 %4247, 1
  store i64 %4248, ptr %NEXT_PC, align 8
  %4249 = load ptr, ptr %MEMORY, align 8
  %4250 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4249, ptr %state, ptr undef)
  store ptr %4250, ptr %MEMORY, align 8
  %4251 = load i64, ptr %NEXT_PC, align 8
  store i64 %4251, ptr %PC, align 8
  %4252 = add i64 %4251, 1
  store i64 %4252, ptr %NEXT_PC, align 8
  %4253 = load ptr, ptr %MEMORY, align 8
  %4254 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4253, ptr %state, ptr undef)
  store ptr %4254, ptr %MEMORY, align 8
  %4255 = load i64, ptr %NEXT_PC, align 8
  store i64 %4255, ptr %PC, align 8
  %4256 = add i64 %4255, 1
  store i64 %4256, ptr %NEXT_PC, align 8
  %4257 = load ptr, ptr %MEMORY, align 8
  %4258 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4257, ptr %state, ptr undef)
  store ptr %4258, ptr %MEMORY, align 8
  %4259 = load i64, ptr %NEXT_PC, align 8
  store i64 %4259, ptr %PC, align 8
  %4260 = add i64 %4259, 1
  store i64 %4260, ptr %NEXT_PC, align 8
  %4261 = load ptr, ptr %MEMORY, align 8
  %4262 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4261, ptr %state, ptr undef)
  store ptr %4262, ptr %MEMORY, align 8
  %4263 = load i64, ptr %NEXT_PC, align 8
  store i64 %4263, ptr %PC, align 8
  %4264 = add i64 %4263, 1
  store i64 %4264, ptr %NEXT_PC, align 8
  %4265 = load ptr, ptr %MEMORY, align 8
  %4266 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4265, ptr %state, ptr undef)
  store ptr %4266, ptr %MEMORY, align 8
  %4267 = load i64, ptr %NEXT_PC, align 8
  store i64 %4267, ptr %PC, align 8
  %4268 = add i64 %4267, 1
  store i64 %4268, ptr %NEXT_PC, align 8
  %4269 = load ptr, ptr %MEMORY, align 8
  %4270 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4269, ptr %state, ptr undef)
  store ptr %4270, ptr %MEMORY, align 8
  %4271 = load i64, ptr %NEXT_PC, align 8
  store i64 %4271, ptr %PC, align 8
  %4272 = add i64 %4271, 1
  store i64 %4272, ptr %NEXT_PC, align 8
  %4273 = load ptr, ptr %MEMORY, align 8
  %4274 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4273, ptr %state, ptr undef)
  store ptr %4274, ptr %MEMORY, align 8
  %4275 = load i64, ptr %NEXT_PC, align 8
  store i64 %4275, ptr %PC, align 8
  %4276 = add i64 %4275, 1
  store i64 %4276, ptr %NEXT_PC, align 8
  %4277 = load ptr, ptr %MEMORY, align 8
  %4278 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4277, ptr %state, ptr undef)
  store ptr %4278, ptr %MEMORY, align 8
  %4279 = load i64, ptr %NEXT_PC, align 8
  store i64 %4279, ptr %PC, align 8
  %4280 = add i64 %4279, 1
  store i64 %4280, ptr %NEXT_PC, align 8
  %4281 = load ptr, ptr %MEMORY, align 8
  %4282 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4281, ptr %state, ptr undef)
  store ptr %4282, ptr %MEMORY, align 8
  %4283 = load i64, ptr %NEXT_PC, align 8
  store i64 %4283, ptr %PC, align 8
  %4284 = add i64 %4283, 1
  store i64 %4284, ptr %NEXT_PC, align 8
  %4285 = load ptr, ptr %MEMORY, align 8
  %4286 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4285, ptr %state, ptr undef)
  store ptr %4286, ptr %MEMORY, align 8
  %4287 = load i64, ptr %NEXT_PC, align 8
  store i64 %4287, ptr %PC, align 8
  %4288 = add i64 %4287, 1
  store i64 %4288, ptr %NEXT_PC, align 8
  %4289 = load ptr, ptr %MEMORY, align 8
  %4290 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4289, ptr %state, ptr undef)
  store ptr %4290, ptr %MEMORY, align 8
  %4291 = load i64, ptr %NEXT_PC, align 8
  store i64 %4291, ptr %PC, align 8
  %4292 = add i64 %4291, 1
  store i64 %4292, ptr %NEXT_PC, align 8
  %4293 = load ptr, ptr %MEMORY, align 8
  %4294 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4293, ptr %state, ptr undef)
  store ptr %4294, ptr %MEMORY, align 8
  %4295 = load i64, ptr %NEXT_PC, align 8
  store i64 %4295, ptr %PC, align 8
  %4296 = add i64 %4295, 1
  store i64 %4296, ptr %NEXT_PC, align 8
  %4297 = load ptr, ptr %MEMORY, align 8
  %4298 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4297, ptr %state, ptr undef)
  store ptr %4298, ptr %MEMORY, align 8
  %4299 = load i64, ptr %NEXT_PC, align 8
  store i64 %4299, ptr %PC, align 8
  %4300 = add i64 %4299, 1
  store i64 %4300, ptr %NEXT_PC, align 8
  %4301 = load ptr, ptr %MEMORY, align 8
  %4302 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4301, ptr %state, ptr undef)
  store ptr %4302, ptr %MEMORY, align 8
  %4303 = load i64, ptr %NEXT_PC, align 8
  store i64 %4303, ptr %PC, align 8
  %4304 = add i64 %4303, 1
  store i64 %4304, ptr %NEXT_PC, align 8
  %4305 = load ptr, ptr %MEMORY, align 8
  %4306 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4305, ptr %state, ptr undef)
  store ptr %4306, ptr %MEMORY, align 8
  %4307 = load i64, ptr %NEXT_PC, align 8
  store i64 %4307, ptr %PC, align 8
  %4308 = add i64 %4307, 1
  store i64 %4308, ptr %NEXT_PC, align 8
  %4309 = load ptr, ptr %MEMORY, align 8
  %4310 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4309, ptr %state, ptr undef)
  store ptr %4310, ptr %MEMORY, align 8
  %4311 = load i64, ptr %NEXT_PC, align 8
  store i64 %4311, ptr %PC, align 8
  %4312 = add i64 %4311, 1
  store i64 %4312, ptr %NEXT_PC, align 8
  %4313 = load ptr, ptr %MEMORY, align 8
  %4314 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4313, ptr %state, ptr undef)
  store ptr %4314, ptr %MEMORY, align 8
  %4315 = load i64, ptr %NEXT_PC, align 8
  store i64 %4315, ptr %PC, align 8
  %4316 = add i64 %4315, 3
  store i64 %4316, ptr %NEXT_PC, align 8
  %4317 = load i64, ptr %RCX, align 8
  %4318 = add i64 %4317, 48
  %4319 = load ptr, ptr %MEMORY, align 8
  %4320 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4319, ptr %state, ptr %RAX, i64 %4318)
  store ptr %4320, ptr %MEMORY, align 8
  %4321 = load i64, ptr %NEXT_PC, align 8
  store i64 %4321, ptr %PC, align 8
  %4322 = add i64 %4321, 1
  store i64 %4322, ptr %NEXT_PC, align 8
  %4323 = load ptr, ptr %MEMORY, align 8
  %4324 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4323, ptr %state, ptr %NEXT_PC)
  store ptr %4324, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659652:                                    ; No predecessors!
  %4325 = load i64, ptr %NEXT_PC, align 8
  store i64 %4325, ptr %PC, align 8
  %4326 = add i64 %4325, 1
  store i64 %4326, ptr %NEXT_PC, align 8
  %4327 = load ptr, ptr %MEMORY, align 8
  %4328 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4327, ptr %state, ptr undef)
  store ptr %4328, ptr %MEMORY, align 8
  %4329 = load i64, ptr %NEXT_PC, align 8
  store i64 %4329, ptr %PC, align 8
  %4330 = add i64 %4329, 1
  store i64 %4330, ptr %NEXT_PC, align 8
  %4331 = load ptr, ptr %MEMORY, align 8
  %4332 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4331, ptr %state, ptr undef)
  store ptr %4332, ptr %MEMORY, align 8
  %4333 = load i64, ptr %NEXT_PC, align 8
  store i64 %4333, ptr %PC, align 8
  %4334 = add i64 %4333, 1
  store i64 %4334, ptr %NEXT_PC, align 8
  %4335 = load ptr, ptr %MEMORY, align 8
  %4336 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4335, ptr %state, ptr undef)
  store ptr %4336, ptr %MEMORY, align 8
  %4337 = load i64, ptr %NEXT_PC, align 8
  store i64 %4337, ptr %PC, align 8
  %4338 = add i64 %4337, 1
  store i64 %4338, ptr %NEXT_PC, align 8
  %4339 = load ptr, ptr %MEMORY, align 8
  %4340 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4339, ptr %state, ptr undef)
  store ptr %4340, ptr %MEMORY, align 8
  %4341 = load i64, ptr %NEXT_PC, align 8
  store i64 %4341, ptr %PC, align 8
  %4342 = add i64 %4341, 1
  store i64 %4342, ptr %NEXT_PC, align 8
  %4343 = load ptr, ptr %MEMORY, align 8
  %4344 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4343, ptr %state, ptr undef)
  store ptr %4344, ptr %MEMORY, align 8
  %4345 = load i64, ptr %NEXT_PC, align 8
  store i64 %4345, ptr %PC, align 8
  %4346 = add i64 %4345, 1
  store i64 %4346, ptr %NEXT_PC, align 8
  %4347 = load ptr, ptr %MEMORY, align 8
  %4348 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4347, ptr %state, ptr undef)
  store ptr %4348, ptr %MEMORY, align 8
  %4349 = load i64, ptr %NEXT_PC, align 8
  store i64 %4349, ptr %PC, align 8
  %4350 = add i64 %4349, 1
  store i64 %4350, ptr %NEXT_PC, align 8
  %4351 = load ptr, ptr %MEMORY, align 8
  %4352 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4351, ptr %state, ptr undef)
  store ptr %4352, ptr %MEMORY, align 8
  %4353 = load i64, ptr %NEXT_PC, align 8
  store i64 %4353, ptr %PC, align 8
  %4354 = add i64 %4353, 1
  store i64 %4354, ptr %NEXT_PC, align 8
  %4355 = load ptr, ptr %MEMORY, align 8
  %4356 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4355, ptr %state, ptr undef)
  store ptr %4356, ptr %MEMORY, align 8
  %4357 = load i64, ptr %NEXT_PC, align 8
  store i64 %4357, ptr %PC, align 8
  %4358 = add i64 %4357, 1
  store i64 %4358, ptr %NEXT_PC, align 8
  %4359 = load ptr, ptr %MEMORY, align 8
  %4360 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4359, ptr %state, ptr undef)
  store ptr %4360, ptr %MEMORY, align 8
  %4361 = load i64, ptr %NEXT_PC, align 8
  store i64 %4361, ptr %PC, align 8
  %4362 = add i64 %4361, 1
  store i64 %4362, ptr %NEXT_PC, align 8
  %4363 = load ptr, ptr %MEMORY, align 8
  %4364 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4363, ptr %state, ptr undef)
  store ptr %4364, ptr %MEMORY, align 8
  %4365 = load i64, ptr %NEXT_PC, align 8
  store i64 %4365, ptr %PC, align 8
  %4366 = add i64 %4365, 1
  store i64 %4366, ptr %NEXT_PC, align 8
  %4367 = load ptr, ptr %MEMORY, align 8
  %4368 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4367, ptr %state, ptr undef)
  store ptr %4368, ptr %MEMORY, align 8
  %4369 = load i64, ptr %NEXT_PC, align 8
  store i64 %4369, ptr %PC, align 8
  %4370 = add i64 %4369, 1
  store i64 %4370, ptr %NEXT_PC, align 8
  %4371 = load ptr, ptr %MEMORY, align 8
  %4372 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4371, ptr %state, ptr undef)
  store ptr %4372, ptr %MEMORY, align 8
  %4373 = load i64, ptr %NEXT_PC, align 8
  store i64 %4373, ptr %PC, align 8
  %4374 = add i64 %4373, 3
  store i64 %4374, ptr %NEXT_PC, align 8
  %4375 = load i64, ptr %RCX, align 8
  %4376 = add i64 %4375, 16
  %4377 = load ptr, ptr %MEMORY, align 8
  %4378 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4377, ptr %state, ptr %RAX, i64 %4376)
  store ptr %4378, ptr %MEMORY, align 8
  %4379 = load i64, ptr %NEXT_PC, align 8
  store i64 %4379, ptr %PC, align 8
  %4380 = add i64 %4379, 1
  store i64 %4380, ptr %NEXT_PC, align 8
  %4381 = load ptr, ptr %MEMORY, align 8
  %4382 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4381, ptr %state, ptr %NEXT_PC)
  store ptr %4382, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659668:                                    ; No predecessors!
  %4383 = load i64, ptr %NEXT_PC, align 8
  store i64 %4383, ptr %PC, align 8
  %4384 = add i64 %4383, 1
  store i64 %4384, ptr %NEXT_PC, align 8
  %4385 = load ptr, ptr %MEMORY, align 8
  %4386 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4385, ptr %state, ptr undef)
  store ptr %4386, ptr %MEMORY, align 8
  %4387 = load i64, ptr %NEXT_PC, align 8
  store i64 %4387, ptr %PC, align 8
  %4388 = add i64 %4387, 1
  store i64 %4388, ptr %NEXT_PC, align 8
  %4389 = load ptr, ptr %MEMORY, align 8
  %4390 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4389, ptr %state, ptr undef)
  store ptr %4390, ptr %MEMORY, align 8
  %4391 = load i64, ptr %NEXT_PC, align 8
  store i64 %4391, ptr %PC, align 8
  %4392 = add i64 %4391, 1
  store i64 %4392, ptr %NEXT_PC, align 8
  %4393 = load ptr, ptr %MEMORY, align 8
  %4394 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4393, ptr %state, ptr undef)
  store ptr %4394, ptr %MEMORY, align 8
  %4395 = load i64, ptr %NEXT_PC, align 8
  store i64 %4395, ptr %PC, align 8
  %4396 = add i64 %4395, 1
  store i64 %4396, ptr %NEXT_PC, align 8
  %4397 = load ptr, ptr %MEMORY, align 8
  %4398 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4397, ptr %state, ptr undef)
  store ptr %4398, ptr %MEMORY, align 8
  %4399 = load i64, ptr %NEXT_PC, align 8
  store i64 %4399, ptr %PC, align 8
  %4400 = add i64 %4399, 1
  store i64 %4400, ptr %NEXT_PC, align 8
  %4401 = load ptr, ptr %MEMORY, align 8
  %4402 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4401, ptr %state, ptr undef)
  store ptr %4402, ptr %MEMORY, align 8
  %4403 = load i64, ptr %NEXT_PC, align 8
  store i64 %4403, ptr %PC, align 8
  %4404 = add i64 %4403, 1
  store i64 %4404, ptr %NEXT_PC, align 8
  %4405 = load ptr, ptr %MEMORY, align 8
  %4406 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4405, ptr %state, ptr undef)
  store ptr %4406, ptr %MEMORY, align 8
  %4407 = load i64, ptr %NEXT_PC, align 8
  store i64 %4407, ptr %PC, align 8
  %4408 = add i64 %4407, 1
  store i64 %4408, ptr %NEXT_PC, align 8
  %4409 = load ptr, ptr %MEMORY, align 8
  %4410 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4409, ptr %state, ptr undef)
  store ptr %4410, ptr %MEMORY, align 8
  %4411 = load i64, ptr %NEXT_PC, align 8
  store i64 %4411, ptr %PC, align 8
  %4412 = add i64 %4411, 1
  store i64 %4412, ptr %NEXT_PC, align 8
  %4413 = load ptr, ptr %MEMORY, align 8
  %4414 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4413, ptr %state, ptr undef)
  store ptr %4414, ptr %MEMORY, align 8
  %4415 = load i64, ptr %NEXT_PC, align 8
  store i64 %4415, ptr %PC, align 8
  %4416 = add i64 %4415, 1
  store i64 %4416, ptr %NEXT_PC, align 8
  %4417 = load ptr, ptr %MEMORY, align 8
  %4418 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4417, ptr %state, ptr undef)
  store ptr %4418, ptr %MEMORY, align 8
  %4419 = load i64, ptr %NEXT_PC, align 8
  store i64 %4419, ptr %PC, align 8
  %4420 = add i64 %4419, 1
  store i64 %4420, ptr %NEXT_PC, align 8
  %4421 = load ptr, ptr %MEMORY, align 8
  %4422 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4421, ptr %state, ptr undef)
  store ptr %4422, ptr %MEMORY, align 8
  %4423 = load i64, ptr %NEXT_PC, align 8
  store i64 %4423, ptr %PC, align 8
  %4424 = add i64 %4423, 1
  store i64 %4424, ptr %NEXT_PC, align 8
  %4425 = load ptr, ptr %MEMORY, align 8
  %4426 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4425, ptr %state, ptr undef)
  store ptr %4426, ptr %MEMORY, align 8
  %4427 = load i64, ptr %NEXT_PC, align 8
  store i64 %4427, ptr %PC, align 8
  %4428 = add i64 %4427, 1
  store i64 %4428, ptr %NEXT_PC, align 8
  %4429 = load ptr, ptr %MEMORY, align 8
  %4430 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4429, ptr %state, ptr undef)
  store ptr %4430, ptr %MEMORY, align 8
  %4431 = load i64, ptr %NEXT_PC, align 8
  store i64 %4431, ptr %PC, align 8
  %4432 = add i64 %4431, 3
  store i64 %4432, ptr %NEXT_PC, align 8
  %4433 = load i64, ptr %RCX, align 8
  %4434 = add i64 %4433, 16
  %4435 = load i32, ptr %EDX, align 4
  %4436 = zext i32 %4435 to i64
  %4437 = load ptr, ptr %MEMORY, align 8
  %4438 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4437, ptr %state, i64 %4434, i64 %4436)
  store ptr %4438, ptr %MEMORY, align 8
  %4439 = load i64, ptr %NEXT_PC, align 8
  store i64 %4439, ptr %PC, align 8
  %4440 = add i64 %4439, 1
  store i64 %4440, ptr %NEXT_PC, align 8
  %4441 = load ptr, ptr %MEMORY, align 8
  %4442 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4441, ptr %state, ptr %NEXT_PC)
  store ptr %4442, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659684:                                    ; No predecessors!
  %4443 = load i64, ptr %NEXT_PC, align 8
  store i64 %4443, ptr %PC, align 8
  %4444 = add i64 %4443, 1
  store i64 %4444, ptr %NEXT_PC, align 8
  %4445 = load ptr, ptr %MEMORY, align 8
  %4446 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4445, ptr %state, ptr undef)
  store ptr %4446, ptr %MEMORY, align 8
  %4447 = load i64, ptr %NEXT_PC, align 8
  store i64 %4447, ptr %PC, align 8
  %4448 = add i64 %4447, 1
  store i64 %4448, ptr %NEXT_PC, align 8
  %4449 = load ptr, ptr %MEMORY, align 8
  %4450 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4449, ptr %state, ptr undef)
  store ptr %4450, ptr %MEMORY, align 8
  %4451 = load i64, ptr %NEXT_PC, align 8
  store i64 %4451, ptr %PC, align 8
  %4452 = add i64 %4451, 1
  store i64 %4452, ptr %NEXT_PC, align 8
  %4453 = load ptr, ptr %MEMORY, align 8
  %4454 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4453, ptr %state, ptr undef)
  store ptr %4454, ptr %MEMORY, align 8
  %4455 = load i64, ptr %NEXT_PC, align 8
  store i64 %4455, ptr %PC, align 8
  %4456 = add i64 %4455, 1
  store i64 %4456, ptr %NEXT_PC, align 8
  %4457 = load ptr, ptr %MEMORY, align 8
  %4458 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4457, ptr %state, ptr undef)
  store ptr %4458, ptr %MEMORY, align 8
  %4459 = load i64, ptr %NEXT_PC, align 8
  store i64 %4459, ptr %PC, align 8
  %4460 = add i64 %4459, 1
  store i64 %4460, ptr %NEXT_PC, align 8
  %4461 = load ptr, ptr %MEMORY, align 8
  %4462 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4461, ptr %state, ptr undef)
  store ptr %4462, ptr %MEMORY, align 8
  %4463 = load i64, ptr %NEXT_PC, align 8
  store i64 %4463, ptr %PC, align 8
  %4464 = add i64 %4463, 1
  store i64 %4464, ptr %NEXT_PC, align 8
  %4465 = load ptr, ptr %MEMORY, align 8
  %4466 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4465, ptr %state, ptr undef)
  store ptr %4466, ptr %MEMORY, align 8
  %4467 = load i64, ptr %NEXT_PC, align 8
  store i64 %4467, ptr %PC, align 8
  %4468 = add i64 %4467, 1
  store i64 %4468, ptr %NEXT_PC, align 8
  %4469 = load ptr, ptr %MEMORY, align 8
  %4470 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4469, ptr %state, ptr undef)
  store ptr %4470, ptr %MEMORY, align 8
  %4471 = load i64, ptr %NEXT_PC, align 8
  store i64 %4471, ptr %PC, align 8
  %4472 = add i64 %4471, 1
  store i64 %4472, ptr %NEXT_PC, align 8
  %4473 = load ptr, ptr %MEMORY, align 8
  %4474 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4473, ptr %state, ptr undef)
  store ptr %4474, ptr %MEMORY, align 8
  %4475 = load i64, ptr %NEXT_PC, align 8
  store i64 %4475, ptr %PC, align 8
  %4476 = add i64 %4475, 1
  store i64 %4476, ptr %NEXT_PC, align 8
  %4477 = load ptr, ptr %MEMORY, align 8
  %4478 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4477, ptr %state, ptr undef)
  store ptr %4478, ptr %MEMORY, align 8
  %4479 = load i64, ptr %NEXT_PC, align 8
  store i64 %4479, ptr %PC, align 8
  %4480 = add i64 %4479, 1
  store i64 %4480, ptr %NEXT_PC, align 8
  %4481 = load ptr, ptr %MEMORY, align 8
  %4482 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4481, ptr %state, ptr undef)
  store ptr %4482, ptr %MEMORY, align 8
  %4483 = load i64, ptr %NEXT_PC, align 8
  store i64 %4483, ptr %PC, align 8
  %4484 = add i64 %4483, 1
  store i64 %4484, ptr %NEXT_PC, align 8
  %4485 = load ptr, ptr %MEMORY, align 8
  %4486 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4485, ptr %state, ptr undef)
  store ptr %4486, ptr %MEMORY, align 8
  %4487 = load i64, ptr %NEXT_PC, align 8
  store i64 %4487, ptr %PC, align 8
  %4488 = add i64 %4487, 1
  store i64 %4488, ptr %NEXT_PC, align 8
  %4489 = load ptr, ptr %MEMORY, align 8
  %4490 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4489, ptr %state, ptr undef)
  store ptr %4490, ptr %MEMORY, align 8
  %4491 = load i64, ptr %NEXT_PC, align 8
  store i64 %4491, ptr %PC, align 8
  %4492 = add i64 %4491, 5
  store i64 %4492, ptr %NEXT_PC, align 8
  %4493 = load i64, ptr %RSP, align 8
  %4494 = add i64 %4493, 8
  %4495 = load i64, ptr %RBX, align 8
  %4496 = load ptr, ptr %MEMORY, align 8
  %4497 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4496, ptr %state, i64 %4494, i64 %4495)
  store ptr %4497, ptr %MEMORY, align 8
  %4498 = load i64, ptr %NEXT_PC, align 8
  store i64 %4498, ptr %PC, align 8
  %4499 = add i64 %4498, 1
  store i64 %4499, ptr %NEXT_PC, align 8
  %4500 = load i64, ptr %RDI, align 8
  %4501 = load ptr, ptr %MEMORY, align 8
  %4502 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %4501, ptr %state, i64 %4500)
  store ptr %4502, ptr %MEMORY, align 8
  %4503 = load i64, ptr %NEXT_PC, align 8
  store i64 %4503, ptr %PC, align 8
  %4504 = add i64 %4503, 4
  store i64 %4504, ptr %NEXT_PC, align 8
  %4505 = load i64, ptr %RSP, align 8
  %4506 = load ptr, ptr %MEMORY, align 8
  %4507 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4506, ptr %state, ptr %RSP, i64 %4505, i64 32)
  store ptr %4507, ptr %MEMORY, align 8
  %4508 = load i64, ptr %NEXT_PC, align 8
  store i64 %4508, ptr %PC, align 8
  %4509 = add i64 %4508, 3
  store i64 %4509, ptr %NEXT_PC, align 8
  %4510 = load i64, ptr %RDX, align 8
  %4511 = load ptr, ptr %MEMORY, align 8
  %4512 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4511, ptr %state, ptr %RDI, i64 %4510)
  store ptr %4512, ptr %MEMORY, align 8
  %4513 = load i64, ptr %NEXT_PC, align 8
  store i64 %4513, ptr %PC, align 8
  %4514 = add i64 %4513, 3
  store i64 %4514, ptr %NEXT_PC, align 8
  %4515 = load i64, ptr %RCX, align 8
  %4516 = load ptr, ptr %MEMORY, align 8
  %4517 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4516, ptr %state, ptr %RBX, i64 %4515)
  store ptr %4517, ptr %MEMORY, align 8
  %4518 = load i64, ptr %NEXT_PC, align 8
  store i64 %4518, ptr %PC, align 8
  %4519 = add i64 %4518, 5
  store i64 %4519, ptr %NEXT_PC, align 8
  %4520 = load i64, ptr %NEXT_PC, align 8
  %4521 = sub i64 %4520, 1685
  %4522 = load i64, ptr %NEXT_PC, align 8
  %4523 = load ptr, ptr %MEMORY, align 8
  %4524 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4523, ptr %state, i64 %4521, ptr %NEXT_PC, i64 %4522, ptr %RETURN_PC)
  store ptr %4524, ptr %MEMORY, align 8
  %4525 = load i64, ptr %NEXT_PC, align 8
  store i64 %4525, ptr %PC, align 8
  %4526 = add i64 %4525, 3
  store i64 %4526, ptr %NEXT_PC, align 8
  %4527 = load i64, ptr %RAX, align 8
  %4528 = load i64, ptr %RAX, align 8
  %4529 = load ptr, ptr %MEMORY, align 8
  %4530 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4529, ptr %state, i64 %4527, i64 %4528)
  store ptr %4530, ptr %MEMORY, align 8
  %4531 = load i64, ptr %NEXT_PC, align 8
  store i64 %4531, ptr %PC, align 8
  %4532 = add i64 %4531, 2
  store i64 %4532, ptr %NEXT_PC, align 8
  %4533 = load i64, ptr %NEXT_PC, align 8
  %4534 = add i64 %4533, 22
  %4535 = load i64, ptr %NEXT_PC, align 8
  %4536 = load ptr, ptr %MEMORY, align 8
  %4537 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4536, ptr %state, ptr %BRANCH_TAKEN, i64 %4534, i64 %4535, ptr %NEXT_PC)
  store ptr %4537, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659744, label %bb_5395659722

bb_5395659722:                                    ; preds = %bb_5395659684
  %4538 = load i64, ptr %NEXT_PC, align 8
  store i64 %4538, ptr %PC, align 8
  %4539 = add i64 %4538, 6
  store i64 %4539, ptr %NEXT_PC, align 8
  %4540 = load i64, ptr %RAX, align 8
  %4541 = load i64, ptr %RAX, align 8
  %4542 = mul i64 %4541, 1
  %4543 = add i64 %4540, %4542
  %4544 = load ptr, ptr %MEMORY, align 8
  %4545 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJ2MnItEEEEP6MemoryS4_R5StateDpT_(ptr %4544, ptr %state, i64 %4543)
  store ptr %4545, ptr %MEMORY, align 8
  br label %bb_5395659728

bb_5395659728:                                    ; preds = %bb_5395659728, %bb_5395659722
  %4546 = load i64, ptr %NEXT_PC, align 8
  store i64 %4546, ptr %PC, align 8
  %4547 = add i64 %4546, 3
  store i64 %4547, ptr %NEXT_PC, align 8
  %4548 = load i64, ptr %RAX, align 8
  %4549 = load ptr, ptr %MEMORY, align 8
  %4550 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4549, ptr %state, ptr %RCX, i64 %4548)
  store ptr %4550, ptr %MEMORY, align 8
  %4551 = load i64, ptr %NEXT_PC, align 8
  store i64 %4551, ptr %PC, align 8
  %4552 = add i64 %4551, 3
  store i64 %4552, ptr %NEXT_PC, align 8
  %4553 = load i64, ptr %RAX, align 8
  %4554 = load ptr, ptr %MEMORY, align 8
  %4555 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4554, ptr %state, ptr %RBX, i64 %4553)
  store ptr %4555, ptr %MEMORY, align 8
  %4556 = load i64, ptr %NEXT_PC, align 8
  store i64 %4556, ptr %PC, align 8
  %4557 = add i64 %4556, 5
  store i64 %4557, ptr %NEXT_PC, align 8
  %4558 = load i64, ptr %NEXT_PC, align 8
  %4559 = sub i64 %4558, 1707
  %4560 = load i64, ptr %NEXT_PC, align 8
  %4561 = load ptr, ptr %MEMORY, align 8
  %4562 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4561, ptr %state, i64 %4559, ptr %NEXT_PC, i64 %4560, ptr %RETURN_PC)
  store ptr %4562, ptr %MEMORY, align 8
  %4563 = load i64, ptr %NEXT_PC, align 8
  store i64 %4563, ptr %PC, align 8
  %4564 = add i64 %4563, 3
  store i64 %4564, ptr %NEXT_PC, align 8
  %4565 = load i64, ptr %RAX, align 8
  %4566 = load i64, ptr %RAX, align 8
  %4567 = load ptr, ptr %MEMORY, align 8
  %4568 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4567, ptr %state, i64 %4565, i64 %4566)
  store ptr %4568, ptr %MEMORY, align 8
  %4569 = load i64, ptr %NEXT_PC, align 8
  store i64 %4569, ptr %PC, align 8
  %4570 = add i64 %4569, 2
  store i64 %4570, ptr %NEXT_PC, align 8
  %4571 = load i64, ptr %NEXT_PC, align 8
  %4572 = sub i64 %4571, 16
  %4573 = load i64, ptr %NEXT_PC, align 8
  %4574 = load ptr, ptr %MEMORY, align 8
  %4575 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4574, ptr %state, ptr %BRANCH_TAKEN, i64 %4572, i64 %4573, ptr %NEXT_PC)
  store ptr %4575, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659728, label %bb_5395659744

bb_5395659744:                                    ; preds = %bb_5395659728, %bb_5395659684
  %4576 = load i64, ptr %NEXT_PC, align 8
  store i64 %4576, ptr %PC, align 8
  %4577 = add i64 %4576, 4
  store i64 %4577, ptr %NEXT_PC, align 8
  %4578 = load i64, ptr %RBX, align 8
  %4579 = add i64 %4578, 20
  %4580 = load ptr, ptr %MEMORY, align 8
  %4581 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %4580, ptr %state, i64 %4579, i64 0)
  store ptr %4581, ptr %MEMORY, align 8
  %4582 = load i64, ptr %NEXT_PC, align 8
  store i64 %4582, ptr %PC, align 8
  %4583 = add i64 %4582, 5
  store i64 %4583, ptr %NEXT_PC, align 8
  %4584 = load i64, ptr %RSP, align 8
  %4585 = add i64 %4584, 48
  %4586 = load ptr, ptr %MEMORY, align 8
  %4587 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4586, ptr %state, ptr %RBX, i64 %4585)
  store ptr %4587, ptr %MEMORY, align 8
  %4588 = load i64, ptr %NEXT_PC, align 8
  store i64 %4588, ptr %PC, align 8
  %4589 = add i64 %4588, 3
  store i64 %4589, ptr %NEXT_PC, align 8
  %4590 = load ptr, ptr %MEMORY, align 8
  %4591 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %4590, ptr %state, ptr %AL)
  store ptr %4591, ptr %MEMORY, align 8
  %4592 = load i64, ptr %NEXT_PC, align 8
  store i64 %4592, ptr %PC, align 8
  %4593 = add i64 %4592, 2
  store i64 %4593, ptr %NEXT_PC, align 8
  %4594 = load i64, ptr %RDI, align 8
  %4595 = load i8, ptr %AL, align 1
  %4596 = zext i8 %4595 to i64
  %4597 = load ptr, ptr %MEMORY, align 8
  %4598 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4597, ptr %state, i64 %4594, i64 %4596)
  store ptr %4598, ptr %MEMORY, align 8
  %4599 = load i64, ptr %NEXT_PC, align 8
  store i64 %4599, ptr %PC, align 8
  %4600 = add i64 %4599, 3
  store i64 %4600, ptr %NEXT_PC, align 8
  %4601 = load i64, ptr %RDI, align 8
  %4602 = load ptr, ptr %MEMORY, align 8
  %4603 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4602, ptr %state, ptr %RAX, i64 %4601)
  store ptr %4603, ptr %MEMORY, align 8
  %4604 = load i64, ptr %NEXT_PC, align 8
  store i64 %4604, ptr %PC, align 8
  %4605 = add i64 %4604, 4
  store i64 %4605, ptr %NEXT_PC, align 8
  %4606 = load i64, ptr %RSP, align 8
  %4607 = load ptr, ptr %MEMORY, align 8
  %4608 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4607, ptr %state, ptr %RSP, i64 %4606, i64 32)
  store ptr %4608, ptr %MEMORY, align 8
  %4609 = load i64, ptr %NEXT_PC, align 8
  store i64 %4609, ptr %PC, align 8
  %4610 = add i64 %4609, 1
  store i64 %4610, ptr %NEXT_PC, align 8
  %4611 = load ptr, ptr %MEMORY, align 8
  %4612 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %4611, ptr %state, ptr %RDI)
  store ptr %4612, ptr %MEMORY, align 8
  %4613 = load i64, ptr %NEXT_PC, align 8
  store i64 %4613, ptr %PC, align 8
  %4614 = add i64 %4613, 1
  store i64 %4614, ptr %NEXT_PC, align 8
  %4615 = load ptr, ptr %MEMORY, align 8
  %4616 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4615, ptr %state, ptr %NEXT_PC)
  store ptr %4616, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659767:                                    ; No predecessors!
  %4617 = load i64, ptr %NEXT_PC, align 8
  store i64 %4617, ptr %PC, align 8
  %4618 = add i64 %4617, 1
  store i64 %4618, ptr %NEXT_PC, align 8
  %4619 = load ptr, ptr %MEMORY, align 8
  %4620 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4619, ptr %state, ptr undef)
  store ptr %4620, ptr %MEMORY, align 8
  %4621 = load i64, ptr %NEXT_PC, align 8
  store i64 %4621, ptr %PC, align 8
  %4622 = add i64 %4621, 1
  store i64 %4622, ptr %NEXT_PC, align 8
  %4623 = load ptr, ptr %MEMORY, align 8
  %4624 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4623, ptr %state, ptr undef)
  store ptr %4624, ptr %MEMORY, align 8
  %4625 = load i64, ptr %NEXT_PC, align 8
  store i64 %4625, ptr %PC, align 8
  %4626 = add i64 %4625, 1
  store i64 %4626, ptr %NEXT_PC, align 8
  %4627 = load ptr, ptr %MEMORY, align 8
  %4628 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4627, ptr %state, ptr undef)
  store ptr %4628, ptr %MEMORY, align 8
  %4629 = load i64, ptr %NEXT_PC, align 8
  store i64 %4629, ptr %PC, align 8
  %4630 = add i64 %4629, 1
  store i64 %4630, ptr %NEXT_PC, align 8
  %4631 = load ptr, ptr %MEMORY, align 8
  %4632 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4631, ptr %state, ptr undef)
  store ptr %4632, ptr %MEMORY, align 8
  %4633 = load i64, ptr %NEXT_PC, align 8
  store i64 %4633, ptr %PC, align 8
  %4634 = add i64 %4633, 1
  store i64 %4634, ptr %NEXT_PC, align 8
  %4635 = load ptr, ptr %MEMORY, align 8
  %4636 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4635, ptr %state, ptr undef)
  store ptr %4636, ptr %MEMORY, align 8
  %4637 = load i64, ptr %NEXT_PC, align 8
  store i64 %4637, ptr %PC, align 8
  %4638 = add i64 %4637, 1
  store i64 %4638, ptr %NEXT_PC, align 8
  %4639 = load ptr, ptr %MEMORY, align 8
  %4640 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4639, ptr %state, ptr undef)
  store ptr %4640, ptr %MEMORY, align 8
  %4641 = load i64, ptr %NEXT_PC, align 8
  store i64 %4641, ptr %PC, align 8
  %4642 = add i64 %4641, 1
  store i64 %4642, ptr %NEXT_PC, align 8
  %4643 = load ptr, ptr %MEMORY, align 8
  %4644 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4643, ptr %state, ptr undef)
  store ptr %4644, ptr %MEMORY, align 8
  %4645 = load i64, ptr %NEXT_PC, align 8
  store i64 %4645, ptr %PC, align 8
  %4646 = add i64 %4645, 1
  store i64 %4646, ptr %NEXT_PC, align 8
  %4647 = load ptr, ptr %MEMORY, align 8
  %4648 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4647, ptr %state, ptr undef)
  store ptr %4648, ptr %MEMORY, align 8
  %4649 = load i64, ptr %NEXT_PC, align 8
  store i64 %4649, ptr %PC, align 8
  %4650 = add i64 %4649, 1
  store i64 %4650, ptr %NEXT_PC, align 8
  %4651 = load ptr, ptr %MEMORY, align 8
  %4652 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4651, ptr %state, ptr undef)
  store ptr %4652, ptr %MEMORY, align 8
  %4653 = load i64, ptr %NEXT_PC, align 8
  store i64 %4653, ptr %PC, align 8
  %4654 = add i64 %4653, 4
  store i64 %4654, ptr %NEXT_PC, align 8
  %4655 = load i64, ptr %RSP, align 8
  %4656 = load ptr, ptr %MEMORY, align 8
  %4657 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4656, ptr %state, ptr %RSP, i64 %4655, i64 72)
  store ptr %4657, ptr %MEMORY, align 8
  %4658 = load i64, ptr %NEXT_PC, align 8
  store i64 %4658, ptr %PC, align 8
  %4659 = add i64 %4658, 5
  store i64 %4659, ptr %NEXT_PC, align 8
  %4660 = load i64, ptr %RSP, align 8
  %4661 = add i64 %4660, 104
  %4662 = load ptr, ptr %MEMORY, align 8
  %4663 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4662, ptr %state, ptr %RAX, i64 %4661)
  store ptr %4663, ptr %MEMORY, align 8
  %4664 = load i64, ptr %NEXT_PC, align 8
  store i64 %4664, ptr %PC, align 8
  %4665 = add i64 %4664, 3
  store i64 %4665, ptr %NEXT_PC, align 8
  %4666 = load i32, ptr %EDX, align 4
  %4667 = zext i32 %4666 to i64
  %4668 = load ptr, ptr %MEMORY, align 8
  %4669 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4668, ptr %state, ptr %R8, i64 %4667)
  store ptr %4669, ptr %MEMORY, align 8
  %4670 = load i64, ptr %NEXT_PC, align 8
  store i64 %4670, ptr %PC, align 8
  %4671 = add i64 %4670, 5
  store i64 %4671, ptr %NEXT_PC, align 8
  %4672 = load i64, ptr %RSP, align 8
  %4673 = add i64 %4672, 96
  %4674 = load ptr, ptr %MEMORY, align 8
  %4675 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4674, ptr %state, ptr %RDX, i64 %4673)
  store ptr %4675, ptr %MEMORY, align 8
  %4676 = load i64, ptr %NEXT_PC, align 8
  store i64 %4676, ptr %PC, align 8
  %4677 = add i64 %4676, 5
  store i64 %4677, ptr %NEXT_PC, align 8
  %4678 = load i64, ptr %RSP, align 8
  %4679 = add i64 %4678, 32
  %4680 = load i64, ptr %RAX, align 8
  %4681 = load ptr, ptr %MEMORY, align 8
  %4682 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4681, ptr %state, i64 %4679, i64 %4680)
  store ptr %4682, ptr %MEMORY, align 8
  %4683 = load i64, ptr %NEXT_PC, align 8
  store i64 %4683, ptr %PC, align 8
  %4684 = add i64 %4683, 5
  store i64 %4684, ptr %NEXT_PC, align 8
  %4685 = load i64, ptr %RSP, align 8
  %4686 = add i64 %4685, 48
  %4687 = load ptr, ptr %MEMORY, align 8
  %4688 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4687, ptr %state, ptr %R9, i64 %4686)
  store ptr %4688, ptr %MEMORY, align 8
  %4689 = load i64, ptr %NEXT_PC, align 8
  store i64 %4689, ptr %PC, align 8
  %4690 = add i64 %4689, 5
  store i64 %4690, ptr %NEXT_PC, align 8
  %4691 = load i64, ptr %NEXT_PC, align 8
  %4692 = add i64 %4691, 1872
  %4693 = load i64, ptr %NEXT_PC, align 8
  %4694 = load ptr, ptr %MEMORY, align 8
  %4695 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4694, ptr %state, i64 %4692, ptr %NEXT_PC, i64 %4693, ptr %RETURN_PC)
  store ptr %4695, ptr %MEMORY, align 8
  %4696 = load i64, ptr %NEXT_PC, align 8
  store i64 %4696, ptr %PC, align 8
  %4697 = add i64 %4696, 2
  store i64 %4697, ptr %NEXT_PC, align 8
  %4698 = load i64, ptr %RCX, align 8
  %4699 = load i32, ptr %ECX, align 4
  %4700 = zext i32 %4699 to i64
  %4701 = load ptr, ptr %MEMORY, align 8
  %4702 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4701, ptr %state, ptr %RCX, i64 %4698, i64 %4700)
  store ptr %4702, ptr %MEMORY, align 8
  %4703 = load i64, ptr %NEXT_PC, align 8
  store i64 %4703, ptr %PC, align 8
  %4704 = add i64 %4703, 2
  store i64 %4704, ptr %NEXT_PC, align 8
  %4705 = load i64, ptr %RAX, align 8
  %4706 = load i32, ptr %ECX, align 4
  %4707 = zext i32 %4706 to i64
  %4708 = load ptr, ptr %MEMORY, align 8
  %4709 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %4708, ptr %state, i64 %4705, i64 %4707)
  store ptr %4709, ptr %MEMORY, align 8
  %4710 = load i64, ptr %NEXT_PC, align 8
  store i64 %4710, ptr %PC, align 8
  %4711 = add i64 %4710, 3
  store i64 %4711, ptr %NEXT_PC, align 8
  %4712 = load ptr, ptr %MEMORY, align 8
  %4713 = call ptr @_ZN12_GLOBAL__N_14SETZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %4712, ptr %state, ptr %CL)
  store ptr %4713, ptr %MEMORY, align 8
  %4714 = load i64, ptr %NEXT_PC, align 8
  store i64 %4714, ptr %PC, align 8
  %4715 = add i64 %4714, 2
  store i64 %4715, ptr %NEXT_PC, align 8
  %4716 = load i32, ptr %ECX, align 4
  %4717 = zext i32 %4716 to i64
  %4718 = load ptr, ptr %MEMORY, align 8
  %4719 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4718, ptr %state, ptr %RAX, i64 %4717)
  store ptr %4719, ptr %MEMORY, align 8
  %4720 = load i64, ptr %NEXT_PC, align 8
  store i64 %4720, ptr %PC, align 8
  %4721 = add i64 %4720, 4
  store i64 %4721, ptr %NEXT_PC, align 8
  %4722 = load i64, ptr %RSP, align 8
  %4723 = load ptr, ptr %MEMORY, align 8
  %4724 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4723, ptr %state, ptr %RSP, i64 %4722, i64 72)
  store ptr %4724, ptr %MEMORY, align 8
  %4725 = load i64, ptr %NEXT_PC, align 8
  store i64 %4725, ptr %PC, align 8
  %4726 = add i64 %4725, 1
  store i64 %4726, ptr %NEXT_PC, align 8
  %4727 = load ptr, ptr %MEMORY, align 8
  %4728 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4727, ptr %state, ptr %NEXT_PC)
  store ptr %4728, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659822:                                    ; No predecessors!
  %4729 = load i64, ptr %NEXT_PC, align 8
  store i64 %4729, ptr %PC, align 8
  %4730 = add i64 %4729, 1
  store i64 %4730, ptr %NEXT_PC, align 8
  %4731 = load ptr, ptr %MEMORY, align 8
  %4732 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4731, ptr %state, ptr undef)
  store ptr %4732, ptr %MEMORY, align 8
  %4733 = load i64, ptr %NEXT_PC, align 8
  store i64 %4733, ptr %PC, align 8
  %4734 = add i64 %4733, 1
  store i64 %4734, ptr %NEXT_PC, align 8
  %4735 = load ptr, ptr %MEMORY, align 8
  %4736 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4735, ptr %state, ptr undef)
  store ptr %4736, ptr %MEMORY, align 8
  %4737 = load i64, ptr %NEXT_PC, align 8
  store i64 %4737, ptr %PC, align 8
  %4738 = add i64 %4737, 1
  store i64 %4738, ptr %NEXT_PC, align 8
  %4739 = load ptr, ptr %MEMORY, align 8
  %4740 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4739, ptr %state, ptr undef)
  store ptr %4740, ptr %MEMORY, align 8
  %4741 = load i64, ptr %NEXT_PC, align 8
  store i64 %4741, ptr %PC, align 8
  %4742 = add i64 %4741, 1
  store i64 %4742, ptr %NEXT_PC, align 8
  %4743 = load ptr, ptr %MEMORY, align 8
  %4744 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4743, ptr %state, ptr undef)
  store ptr %4744, ptr %MEMORY, align 8
  %4745 = load i64, ptr %NEXT_PC, align 8
  store i64 %4745, ptr %PC, align 8
  %4746 = add i64 %4745, 1
  store i64 %4746, ptr %NEXT_PC, align 8
  %4747 = load ptr, ptr %MEMORY, align 8
  %4748 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4747, ptr %state, ptr undef)
  store ptr %4748, ptr %MEMORY, align 8
  %4749 = load i64, ptr %NEXT_PC, align 8
  store i64 %4749, ptr %PC, align 8
  %4750 = add i64 %4749, 1
  store i64 %4750, ptr %NEXT_PC, align 8
  %4751 = load ptr, ptr %MEMORY, align 8
  %4752 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4751, ptr %state, ptr undef)
  store ptr %4752, ptr %MEMORY, align 8
  %4753 = load i64, ptr %NEXT_PC, align 8
  store i64 %4753, ptr %PC, align 8
  %4754 = add i64 %4753, 1
  store i64 %4754, ptr %NEXT_PC, align 8
  %4755 = load ptr, ptr %MEMORY, align 8
  %4756 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4755, ptr %state, ptr undef)
  store ptr %4756, ptr %MEMORY, align 8
  %4757 = load i64, ptr %NEXT_PC, align 8
  store i64 %4757, ptr %PC, align 8
  %4758 = add i64 %4757, 1
  store i64 %4758, ptr %NEXT_PC, align 8
  %4759 = load ptr, ptr %MEMORY, align 8
  %4760 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4759, ptr %state, ptr undef)
  store ptr %4760, ptr %MEMORY, align 8
  %4761 = load i64, ptr %NEXT_PC, align 8
  store i64 %4761, ptr %PC, align 8
  %4762 = add i64 %4761, 1
  store i64 %4762, ptr %NEXT_PC, align 8
  %4763 = load ptr, ptr %MEMORY, align 8
  %4764 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4763, ptr %state, ptr undef)
  store ptr %4764, ptr %MEMORY, align 8
  %4765 = load i64, ptr %NEXT_PC, align 8
  store i64 %4765, ptr %PC, align 8
  %4766 = add i64 %4765, 1
  store i64 %4766, ptr %NEXT_PC, align 8
  %4767 = load ptr, ptr %MEMORY, align 8
  %4768 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4767, ptr %state, ptr undef)
  store ptr %4768, ptr %MEMORY, align 8
  %4769 = load i64, ptr %NEXT_PC, align 8
  store i64 %4769, ptr %PC, align 8
  %4770 = add i64 %4769, 1
  store i64 %4770, ptr %NEXT_PC, align 8
  %4771 = load ptr, ptr %MEMORY, align 8
  %4772 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4771, ptr %state, ptr undef)
  store ptr %4772, ptr %MEMORY, align 8
  %4773 = load i64, ptr %NEXT_PC, align 8
  store i64 %4773, ptr %PC, align 8
  %4774 = add i64 %4773, 1
  store i64 %4774, ptr %NEXT_PC, align 8
  %4775 = load ptr, ptr %MEMORY, align 8
  %4776 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4775, ptr %state, ptr undef)
  store ptr %4776, ptr %MEMORY, align 8
  %4777 = load i64, ptr %NEXT_PC, align 8
  store i64 %4777, ptr %PC, align 8
  %4778 = add i64 %4777, 1
  store i64 %4778, ptr %NEXT_PC, align 8
  %4779 = load ptr, ptr %MEMORY, align 8
  %4780 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4779, ptr %state, ptr undef)
  store ptr %4780, ptr %MEMORY, align 8
  %4781 = load i64, ptr %NEXT_PC, align 8
  store i64 %4781, ptr %PC, align 8
  %4782 = add i64 %4781, 1
  store i64 %4782, ptr %NEXT_PC, align 8
  %4783 = load ptr, ptr %MEMORY, align 8
  %4784 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4783, ptr %state, ptr undef)
  store ptr %4784, ptr %MEMORY, align 8
  %4785 = load i64, ptr %NEXT_PC, align 8
  store i64 %4785, ptr %PC, align 8
  %4786 = add i64 %4785, 1
  store i64 %4786, ptr %NEXT_PC, align 8
  %4787 = load ptr, ptr %MEMORY, align 8
  %4788 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4787, ptr %state, ptr undef)
  store ptr %4788, ptr %MEMORY, align 8
  %4789 = load i64, ptr %NEXT_PC, align 8
  store i64 %4789, ptr %PC, align 8
  %4790 = add i64 %4789, 1
  store i64 %4790, ptr %NEXT_PC, align 8
  %4791 = load ptr, ptr %MEMORY, align 8
  %4792 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4791, ptr %state, ptr undef)
  store ptr %4792, ptr %MEMORY, align 8
  %4793 = load i64, ptr %NEXT_PC, align 8
  store i64 %4793, ptr %PC, align 8
  %4794 = add i64 %4793, 1
  store i64 %4794, ptr %NEXT_PC, align 8
  %4795 = load ptr, ptr %MEMORY, align 8
  %4796 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4795, ptr %state, ptr undef)
  store ptr %4796, ptr %MEMORY, align 8
  %4797 = load i64, ptr %NEXT_PC, align 8
  store i64 %4797, ptr %PC, align 8
  %4798 = add i64 %4797, 1
  store i64 %4798, ptr %NEXT_PC, align 8
  %4799 = load ptr, ptr %MEMORY, align 8
  %4800 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4799, ptr %state, ptr undef)
  store ptr %4800, ptr %MEMORY, align 8
  %4801 = load i64, ptr %NEXT_PC, align 8
  store i64 %4801, ptr %PC, align 8
  %4802 = add i64 %4801, 4
  store i64 %4802, ptr %NEXT_PC, align 8
  %4803 = load i64, ptr %RCX, align 8
  %4804 = add i64 %4803, 56
  %4805 = load ptr, ptr %MEMORY, align 8
  %4806 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4805, ptr %state, ptr %R8, i64 %4804)
  store ptr %4806, ptr %MEMORY, align 8
  %4807 = load i64, ptr %NEXT_PC, align 8
  store i64 %4807, ptr %PC, align 8
  %4808 = add i64 %4807, 3
  store i64 %4808, ptr %NEXT_PC, align 8
  %4809 = load i64, ptr %R8, align 8
  %4810 = load i64, ptr %R8, align 8
  %4811 = load ptr, ptr %MEMORY, align 8
  %4812 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4811, ptr %state, i64 %4809, i64 %4810)
  store ptr %4812, ptr %MEMORY, align 8
  %4813 = load i64, ptr %NEXT_PC, align 8
  store i64 %4813, ptr %PC, align 8
  %4814 = add i64 %4813, 2
  store i64 %4814, ptr %NEXT_PC, align 8
  %4815 = load i64, ptr %NEXT_PC, align 8
  %4816 = add i64 %4815, 30
  %4817 = load i64, ptr %NEXT_PC, align 8
  %4818 = load ptr, ptr %MEMORY, align 8
  %4819 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4818, ptr %state, ptr %BRANCH_TAKEN, i64 %4816, i64 %4817, ptr %NEXT_PC)
  store ptr %4819, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659879, label %bb_5395659849

bb_5395659849:                                    ; preds = %bb_5395659822
  %4820 = load i64, ptr %NEXT_PC, align 8
  store i64 %4820, ptr %PC, align 8
  %4821 = add i64 %4820, 3
  store i64 %4821, ptr %NEXT_PC, align 8
  %4822 = load i32, ptr %EDX, align 4
  %4823 = zext i32 %4822 to i64
  %4824 = load ptr, ptr %MEMORY, align 8
  %4825 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %4824, ptr %state, ptr %RAX, i64 %4823)
  store ptr %4825, ptr %MEMORY, align 8
  %4826 = load i64, ptr %NEXT_PC, align 8
  store i64 %4826, ptr %PC, align 8
  %4827 = add i64 %4826, 5
  store i64 %4827, ptr %NEXT_PC, align 8
  %4828 = load ptr, ptr %MEMORY, align 8
  %4829 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %4828, ptr %state, ptr %RDX, i64 2147483648)
  store ptr %4829, ptr %MEMORY, align 8
  %4830 = load i64, ptr %NEXT_PC, align 8
  store i64 %4830, ptr %PC, align 8
  %4831 = add i64 %4830, 4
  store i64 %4831, ptr %NEXT_PC, align 8
  %4832 = load i64, ptr %R8, align 8
  %4833 = load i64, ptr %RAX, align 8
  %4834 = mul i64 %4833, 4
  %4835 = add i64 %4832, %4834
  %4836 = load ptr, ptr %MEMORY, align 8
  %4837 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4836, ptr %state, ptr %RCX, i64 %4835)
  store ptr %4837, ptr %MEMORY, align 8
  %4838 = load i64, ptr %NEXT_PC, align 8
  store i64 %4838, ptr %PC, align 8
  %4839 = add i64 %4838, 3
  store i64 %4839, ptr %NEXT_PC, align 8
  %4840 = load i64, ptr %RCX, align 8
  %4841 = load i64, ptr %RDX, align 8
  %4842 = mul i64 %4841, 1
  %4843 = add i64 %4840, %4842
  %4844 = load ptr, ptr %MEMORY, align 8
  %4845 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %4844, ptr %state, ptr %RAX, i64 %4843)
  store ptr %4845, ptr %MEMORY, align 8
  %4846 = load i64, ptr %NEXT_PC, align 8
  store i64 %4846, ptr %PC, align 8
  %4847 = add i64 %4846, 2
  store i64 %4847, ptr %NEXT_PC, align 8
  %4848 = load i32, ptr %EDX, align 4
  %4849 = zext i32 %4848 to i64
  %4850 = load i32, ptr %EAX, align 4
  %4851 = zext i32 %4850 to i64
  %4852 = load ptr, ptr %MEMORY, align 8
  %4853 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4852, ptr %state, i64 %4849, i64 %4851)
  store ptr %4853, ptr %MEMORY, align 8
  %4854 = load i64, ptr %NEXT_PC, align 8
  store i64 %4854, ptr %PC, align 8
  %4855 = add i64 %4854, 2
  store i64 %4855, ptr %NEXT_PC, align 8
  %4856 = load i64, ptr %NEXT_PC, align 8
  %4857 = add i64 %4856, 5
  %4858 = load i64, ptr %NEXT_PC, align 8
  %4859 = load ptr, ptr %MEMORY, align 8
  %4860 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4859, ptr %state, ptr %BRANCH_TAKEN, i64 %4857, i64 %4858, ptr %NEXT_PC)
  store ptr %4860, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659873, label %bb_5395659868

bb_5395659868:                                    ; preds = %bb_5395659849
  %4861 = load i64, ptr %NEXT_PC, align 8
  store i64 %4861, ptr %PC, align 8
  %4862 = add i64 %4861, 3
  store i64 %4862, ptr %NEXT_PC, align 8
  %4863 = load i32, ptr %ECX, align 4
  %4864 = zext i32 %4863 to i64
  %4865 = load ptr, ptr %MEMORY, align 8
  %4866 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %4865, ptr %state, i64 %4864, i64 -2)
  store ptr %4866, ptr %MEMORY, align 8
  %4867 = load i64, ptr %NEXT_PC, align 8
  store i64 %4867, ptr %PC, align 8
  %4868 = add i64 %4867, 2
  store i64 %4868, ptr %NEXT_PC, align 8
  %4869 = load i64, ptr %NEXT_PC, align 8
  %4870 = add i64 %4869, 6
  %4871 = load i64, ptr %NEXT_PC, align 8
  %4872 = load ptr, ptr %MEMORY, align 8
  %4873 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4872, ptr %state, ptr %BRANCH_TAKEN, i64 %4870, i64 %4871, ptr %NEXT_PC)
  store ptr %4873, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659879, label %bb_5395659873

bb_5395659873:                                    ; preds = %bb_5395659868, %bb_5395659849
  %4874 = load i64, ptr %NEXT_PC, align 8
  store i64 %4874, ptr %PC, align 8
  %4875 = add i64 %4874, 5
  store i64 %4875, ptr %NEXT_PC, align 8
  %4876 = load ptr, ptr %MEMORY, align 8
  %4877 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %4876, ptr %state, ptr %RAX, i64 1)
  store ptr %4877, ptr %MEMORY, align 8
  %4878 = load i64, ptr %NEXT_PC, align 8
  store i64 %4878, ptr %PC, align 8
  %4879 = add i64 %4878, 1
  store i64 %4879, ptr %NEXT_PC, align 8
  %4880 = load ptr, ptr %MEMORY, align 8
  %4881 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4880, ptr %state, ptr %NEXT_PC)
  store ptr %4881, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659879:                                    ; preds = %bb_5395659868, %bb_5395659822
  %4882 = load i64, ptr %NEXT_PC, align 8
  store i64 %4882, ptr %PC, align 8
  %4883 = add i64 %4882, 2
  store i64 %4883, ptr %NEXT_PC, align 8
  %4884 = load i64, ptr %RAX, align 8
  %4885 = load i32, ptr %EAX, align 4
  %4886 = zext i32 %4885 to i64
  %4887 = load ptr, ptr %MEMORY, align 8
  %4888 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4887, ptr %state, ptr %RAX, i64 %4884, i64 %4886)
  store ptr %4888, ptr %MEMORY, align 8
  %4889 = load i64, ptr %NEXT_PC, align 8
  store i64 %4889, ptr %PC, align 8
  %4890 = add i64 %4889, 1
  store i64 %4890, ptr %NEXT_PC, align 8
  %4891 = load ptr, ptr %MEMORY, align 8
  %4892 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4891, ptr %state, ptr %NEXT_PC)
  store ptr %4892, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659882:                                    ; No predecessors!
  %4893 = load i64, ptr %NEXT_PC, align 8
  store i64 %4893, ptr %PC, align 8
  %4894 = add i64 %4893, 1
  store i64 %4894, ptr %NEXT_PC, align 8
  %4895 = load ptr, ptr %MEMORY, align 8
  %4896 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4895, ptr %state, ptr undef)
  store ptr %4896, ptr %MEMORY, align 8
  %4897 = load i64, ptr %NEXT_PC, align 8
  store i64 %4897, ptr %PC, align 8
  %4898 = add i64 %4897, 1
  store i64 %4898, ptr %NEXT_PC, align 8
  %4899 = load ptr, ptr %MEMORY, align 8
  %4900 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4899, ptr %state, ptr undef)
  store ptr %4900, ptr %MEMORY, align 8
  %4901 = load i64, ptr %NEXT_PC, align 8
  store i64 %4901, ptr %PC, align 8
  %4902 = add i64 %4901, 1
  store i64 %4902, ptr %NEXT_PC, align 8
  %4903 = load ptr, ptr %MEMORY, align 8
  %4904 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4903, ptr %state, ptr undef)
  store ptr %4904, ptr %MEMORY, align 8
  %4905 = load i64, ptr %NEXT_PC, align 8
  store i64 %4905, ptr %PC, align 8
  %4906 = add i64 %4905, 1
  store i64 %4906, ptr %NEXT_PC, align 8
  %4907 = load ptr, ptr %MEMORY, align 8
  %4908 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4907, ptr %state, ptr undef)
  store ptr %4908, ptr %MEMORY, align 8
  %4909 = load i64, ptr %NEXT_PC, align 8
  store i64 %4909, ptr %PC, align 8
  %4910 = add i64 %4909, 1
  store i64 %4910, ptr %NEXT_PC, align 8
  %4911 = load ptr, ptr %MEMORY, align 8
  %4912 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4911, ptr %state, ptr undef)
  store ptr %4912, ptr %MEMORY, align 8
  %4913 = load i64, ptr %NEXT_PC, align 8
  store i64 %4913, ptr %PC, align 8
  %4914 = add i64 %4913, 1
  store i64 %4914, ptr %NEXT_PC, align 8
  %4915 = load ptr, ptr %MEMORY, align 8
  %4916 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4915, ptr %state, ptr undef)
  store ptr %4916, ptr %MEMORY, align 8
  %4917 = load i64, ptr %NEXT_PC, align 8
  store i64 %4917, ptr %PC, align 8
  %4918 = add i64 %4917, 5
  store i64 %4918, ptr %NEXT_PC, align 8
  %4919 = load i64, ptr %RSP, align 8
  %4920 = add i64 %4919, 24
  %4921 = load i64, ptr %RSI, align 8
  %4922 = load ptr, ptr %MEMORY, align 8
  %4923 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4922, ptr %state, i64 %4920, i64 %4921)
  store ptr %4923, ptr %MEMORY, align 8
  %4924 = load i64, ptr %NEXT_PC, align 8
  store i64 %4924, ptr %PC, align 8
  %4925 = add i64 %4924, 1
  store i64 %4925, ptr %NEXT_PC, align 8
  %4926 = load i64, ptr %RDI, align 8
  %4927 = load ptr, ptr %MEMORY, align 8
  %4928 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %4927, ptr %state, i64 %4926)
  store ptr %4928, ptr %MEMORY, align 8
  %4929 = load i64, ptr %NEXT_PC, align 8
  store i64 %4929, ptr %PC, align 8
  %4930 = add i64 %4929, 4
  store i64 %4930, ptr %NEXT_PC, align 8
  %4931 = load i64, ptr %RSP, align 8
  %4932 = load ptr, ptr %MEMORY, align 8
  %4933 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4932, ptr %state, ptr %RSP, i64 %4931, i64 64)
  store ptr %4933, ptr %MEMORY, align 8
  %4934 = load i64, ptr %NEXT_PC, align 8
  store i64 %4934, ptr %PC, align 8
  %4935 = add i64 %4934, 2
  store i64 %4935, ptr %NEXT_PC, align 8
  %4936 = load i64, ptr %RAX, align 8
  %4937 = load i32, ptr %EAX, align 4
  %4938 = zext i32 %4937 to i64
  %4939 = load ptr, ptr %MEMORY, align 8
  %4940 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4939, ptr %state, ptr %RAX, i64 %4936, i64 %4938)
  store ptr %4940, ptr %MEMORY, align 8
  %4941 = load i64, ptr %NEXT_PC, align 8
  store i64 %4941, ptr %PC, align 8
  %4942 = add i64 %4941, 3
  store i64 %4942, ptr %NEXT_PC, align 8
  %4943 = load i64, ptr %R9, align 8
  %4944 = load ptr, ptr %MEMORY, align 8
  %4945 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4944, ptr %state, ptr %RSI, i64 %4943)
  store ptr %4945, ptr %MEMORY, align 8
  %4946 = load i64, ptr %NEXT_PC, align 8
  store i64 %4946, ptr %PC, align 8
  %4947 = add i64 %4946, 5
  store i64 %4947, ptr %NEXT_PC, align 8
  %4948 = load i64, ptr %RSP, align 8
  %4949 = add i64 %4948, 48
  %4950 = load i64, ptr %RAX, align 8
  %4951 = load ptr, ptr %MEMORY, align 8
  %4952 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4951, ptr %state, i64 %4949, i64 %4950)
  store ptr %4952, ptr %MEMORY, align 8
  %4953 = load i64, ptr %NEXT_PC, align 8
  store i64 %4953, ptr %PC, align 8
  %4954 = add i64 %4953, 5
  store i64 %4954, ptr %NEXT_PC, align 8
  %4955 = load i64, ptr %RSP, align 8
  %4956 = add i64 %4955, 48
  %4957 = load ptr, ptr %MEMORY, align 8
  %4958 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4957, ptr %state, ptr %R9, i64 %4956)
  store ptr %4958, ptr %MEMORY, align 8
  %4959 = load i64, ptr %NEXT_PC, align 8
  store i64 %4959, ptr %PC, align 8
  %4960 = add i64 %4959, 5
  store i64 %4960, ptr %NEXT_PC, align 8
  %4961 = load i64, ptr %RSP, align 8
  %4962 = add i64 %4961, 88
  %4963 = load i64, ptr %RAX, align 8
  %4964 = load ptr, ptr %MEMORY, align 8
  %4965 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4964, ptr %state, i64 %4962, i64 %4963)
  store ptr %4965, ptr %MEMORY, align 8
  %4966 = load i64, ptr %NEXT_PC, align 8
  store i64 %4966, ptr %PC, align 8
  %4967 = add i64 %4966, 3
  store i64 %4967, ptr %NEXT_PC, align 8
  %4968 = load i64, ptr %RDX, align 8
  %4969 = load ptr, ptr %MEMORY, align 8
  %4970 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4969, ptr %state, ptr %RDI, i64 %4968)
  store ptr %4970, ptr %MEMORY, align 8
  %4971 = load i64, ptr %NEXT_PC, align 8
  store i64 %4971, ptr %PC, align 8
  %4972 = add i64 %4971, 5
  store i64 %4972, ptr %NEXT_PC, align 8
  %4973 = load i64, ptr %RSP, align 8
  %4974 = add i64 %4973, 88
  %4975 = load ptr, ptr %MEMORY, align 8
  %4976 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4975, ptr %state, ptr %RAX, i64 %4974)
  store ptr %4976, ptr %MEMORY, align 8
  %4977 = load i64, ptr %NEXT_PC, align 8
  store i64 %4977, ptr %PC, align 8
  %4978 = add i64 %4977, 5
  store i64 %4978, ptr %NEXT_PC, align 8
  %4979 = load i64, ptr %RSP, align 8
  %4980 = add i64 %4979, 32
  %4981 = load i64, ptr %RAX, align 8
  %4982 = load ptr, ptr %MEMORY, align 8
  %4983 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4982, ptr %state, i64 %4980, i64 %4981)
  store ptr %4983, ptr %MEMORY, align 8
  %4984 = load i64, ptr %NEXT_PC, align 8
  store i64 %4984, ptr %PC, align 8
  %4985 = add i64 %4984, 5
  store i64 %4985, ptr %NEXT_PC, align 8
  %4986 = load i64, ptr %NEXT_PC, align 8
  %4987 = add i64 %4986, 1744
  %4988 = load i64, ptr %NEXT_PC, align 8
  %4989 = load ptr, ptr %MEMORY, align 8
  %4990 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4989, ptr %state, i64 %4987, ptr %NEXT_PC, i64 %4988, ptr %RETURN_PC)
  store ptr %4990, ptr %MEMORY, align 8
  %4991 = load i64, ptr %NEXT_PC, align 8
  store i64 %4991, ptr %PC, align 8
  %4992 = add i64 %4991, 3
  store i64 %4992, ptr %NEXT_PC, align 8
  %4993 = load i64, ptr %RDI, align 8
  %4994 = load ptr, ptr %MEMORY, align 8
  %4995 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %4994, ptr %state, i64 %4993, i64 0)
  store ptr %4995, ptr %MEMORY, align 8
  %4996 = load i64, ptr %NEXT_PC, align 8
  store i64 %4996, ptr %PC, align 8
  %4997 = add i64 %4996, 2
  store i64 %4997, ptr %NEXT_PC, align 8
  %4998 = load i64, ptr %NEXT_PC, align 8
  %4999 = add i64 %4998, 37
  %5000 = load i64, ptr %NEXT_PC, align 8
  %5001 = load ptr, ptr %MEMORY, align 8
  %5002 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5001, ptr %state, ptr %BRANCH_TAKEN, i64 %4999, i64 %5000, ptr %NEXT_PC)
  store ptr %5002, ptr %MEMORY, align 8
  br i1 true, label %bb_5395659978, label %bb_5395659941

bb_5395659941:                                    ; preds = %bb_5395659882
  %5003 = load i64, ptr %NEXT_PC, align 8
  store i64 %5003, ptr %PC, align 8
  %5004 = add i64 %5003, 5
  store i64 %5004, ptr %NEXT_PC, align 8
  %5005 = load i64, ptr %RSP, align 8
  %5006 = add i64 %5005, 88
  %5007 = load ptr, ptr %MEMORY, align 8
  %5008 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5007, ptr %state, ptr %RCX, i64 %5006)
  store ptr %5008, ptr %MEMORY, align 8
  %5009 = load i64, ptr %NEXT_PC, align 8
  store i64 %5009, ptr %PC, align 8
  %5010 = add i64 %5009, 5
  store i64 %5010, ptr %NEXT_PC, align 8
  %5011 = load i64, ptr %RSP, align 8
  %5012 = add i64 %5011, 80
  %5013 = load i64, ptr %RBX, align 8
  %5014 = load ptr, ptr %MEMORY, align 8
  %5015 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5014, ptr %state, i64 %5012, i64 %5013)
  store ptr %5015, ptr %MEMORY, align 8
  %5016 = load i64, ptr %NEXT_PC, align 8
  store i64 %5016, ptr %PC, align 8
  %5017 = add i64 %5016, 3
  store i64 %5017, ptr %NEXT_PC, align 8
  %5018 = load i64, ptr %RSI, align 8
  %5019 = load ptr, ptr %MEMORY, align 8
  %5020 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5019, ptr %state, ptr %RBX, i64 %5018)
  store ptr %5020, ptr %MEMORY, align 8
  %5021 = load i64, ptr %NEXT_PC, align 8
  store i64 %5021, ptr %PC, align 8
  %5022 = add i64 %5021, 5
  store i64 %5022, ptr %NEXT_PC, align 8
  %5023 = load i64, ptr %NEXT_PC, align 8
  %5024 = add i64 %5023, 126681
  %5025 = load i64, ptr %NEXT_PC, align 8
  %5026 = load ptr, ptr %MEMORY, align 8
  %5027 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %5026, ptr %state, i64 %5024, ptr %NEXT_PC, i64 %5025, ptr %RETURN_PC)
  store ptr %5027, ptr %MEMORY, align 8
  %5028 = load i64, ptr %NEXT_PC, align 8
  store i64 %5028, ptr %PC, align 8
  %5029 = add i64 %5028, 5
  store i64 %5029, ptr %NEXT_PC, align 8
  %5030 = load i64, ptr %RSP, align 8
  %5031 = add i64 %5030, 48
  %5032 = load ptr, ptr %MEMORY, align 8
  %5033 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5032, ptr %state, ptr %RDX, i64 %5031)
  store ptr %5033, ptr %MEMORY, align 8
  %5034 = load i64, ptr %NEXT_PC, align 8
  store i64 %5034, ptr %PC, align 8
  %5035 = add i64 %5034, 3
  store i64 %5035, ptr %NEXT_PC, align 8
  %5036 = load i32, ptr %EAX, align 4
  %5037 = zext i32 %5036 to i64
  %5038 = load ptr, ptr %MEMORY, align 8
  %5039 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5038, ptr %state, ptr %R8, i64 %5037)
  store ptr %5039, ptr %MEMORY, align 8
  %5040 = load i64, ptr %NEXT_PC, align 8
  store i64 %5040, ptr %PC, align 8
  %5041 = add i64 %5040, 3
  store i64 %5041, ptr %NEXT_PC, align 8
  %5042 = load i64, ptr %RSI, align 8
  %5043 = load ptr, ptr %MEMORY, align 8
  %5044 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5043, ptr %state, ptr %RCX, i64 %5042)
  store ptr %5044, ptr %MEMORY, align 8
  %5045 = load i64, ptr %NEXT_PC, align 8
  store i64 %5045, ptr %PC, align 8
  %5046 = add i64 %5045, 3
  store i64 %5046, ptr %NEXT_PC, align 8
  %5047 = load i64, ptr %RBX, align 8
  %5048 = add i64 %5047, 40
  %5049 = load i64, ptr %NEXT_PC, align 8
  %5050 = load ptr, ptr %MEMORY, align 8
  %5051 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %5050, ptr %state, i64 %5048, ptr %NEXT_PC, i64 %5049, ptr %RETURN_PC)
  store ptr %5051, ptr %MEMORY, align 8
  %5052 = load i64, ptr %NEXT_PC, align 8
  store i64 %5052, ptr %PC, align 8
  %5053 = add i64 %5052, 5
  store i64 %5053, ptr %NEXT_PC, align 8
  %5054 = load i64, ptr %RSP, align 8
  %5055 = add i64 %5054, 80
  %5056 = load ptr, ptr %MEMORY, align 8
  %5057 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5056, ptr %state, ptr %RBX, i64 %5055)
  store ptr %5057, ptr %MEMORY, align 8
  br label %bb_5395659978

bb_5395659978:                                    ; preds = %bb_5395659941, %bb_5395659882
  %5058 = load i64, ptr %NEXT_PC, align 8
  store i64 %5058, ptr %PC, align 8
  %5059 = add i64 %5058, 3
  store i64 %5059, ptr %NEXT_PC, align 8
  %5060 = load i64, ptr %RDI, align 8
  %5061 = load ptr, ptr %MEMORY, align 8
  %5062 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5061, ptr %state, ptr %RAX, i64 %5060)
  store ptr %5062, ptr %MEMORY, align 8
  %5063 = load i64, ptr %NEXT_PC, align 8
  store i64 %5063, ptr %PC, align 8
  %5064 = add i64 %5063, 5
  store i64 %5064, ptr %NEXT_PC, align 8
  %5065 = load i64, ptr %RSP, align 8
  %5066 = add i64 %5065, 96
  %5067 = load ptr, ptr %MEMORY, align 8
  %5068 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5067, ptr %state, ptr %RSI, i64 %5066)
  store ptr %5068, ptr %MEMORY, align 8
  %5069 = load i64, ptr %NEXT_PC, align 8
  store i64 %5069, ptr %PC, align 8
  %5070 = add i64 %5069, 4
  store i64 %5070, ptr %NEXT_PC, align 8
  %5071 = load i64, ptr %RSP, align 8
  %5072 = load ptr, ptr %MEMORY, align 8
  %5073 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %5072, ptr %state, ptr %RSP, i64 %5071, i64 64)
  store ptr %5073, ptr %MEMORY, align 8
  %5074 = load i64, ptr %NEXT_PC, align 8
  store i64 %5074, ptr %PC, align 8
  %5075 = add i64 %5074, 1
  store i64 %5075, ptr %NEXT_PC, align 8
  %5076 = load ptr, ptr %MEMORY, align 8
  %5077 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %5076, ptr %state, ptr %RDI)
  store ptr %5077, ptr %MEMORY, align 8
  %5078 = load i64, ptr %NEXT_PC, align 8
  store i64 %5078, ptr %PC, align 8
  %5079 = add i64 %5078, 1
  store i64 %5079, ptr %NEXT_PC, align 8
  %5080 = load ptr, ptr %MEMORY, align 8
  %5081 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %5080, ptr %state, ptr %NEXT_PC)
  store ptr %5081, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395659992:                                    ; No predecessors!
  %5082 = load i64, ptr %NEXT_PC, align 8
  store i64 %5082, ptr %PC, align 8
  %5083 = add i64 %5082, 1
  store i64 %5083, ptr %NEXT_PC, align 8
  %5084 = load ptr, ptr %MEMORY, align 8
  %5085 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5084, ptr %state, ptr undef)
  store ptr %5085, ptr %MEMORY, align 8
  %5086 = load i64, ptr %NEXT_PC, align 8
  store i64 %5086, ptr %PC, align 8
  %5087 = add i64 %5086, 1
  store i64 %5087, ptr %NEXT_PC, align 8
  %5088 = load ptr, ptr %MEMORY, align 8
  %5089 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5088, ptr %state, ptr undef)
  store ptr %5089, ptr %MEMORY, align 8
  %5090 = load i64, ptr %NEXT_PC, align 8
  store i64 %5090, ptr %PC, align 8
  %5091 = add i64 %5090, 1
  store i64 %5091, ptr %NEXT_PC, align 8
  %5092 = load ptr, ptr %MEMORY, align 8
  %5093 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5092, ptr %state, ptr undef)
  store ptr %5093, ptr %MEMORY, align 8
  %5094 = load i64, ptr %NEXT_PC, align 8
  store i64 %5094, ptr %PC, align 8
  %5095 = add i64 %5094, 1
  store i64 %5095, ptr %NEXT_PC, align 8
  %5096 = load ptr, ptr %MEMORY, align 8
  %5097 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5096, ptr %state, ptr undef)
  store ptr %5097, ptr %MEMORY, align 8
  %5098 = load i64, ptr %NEXT_PC, align 8
  store i64 %5098, ptr %PC, align 8
  %5099 = add i64 %5098, 1
  store i64 %5099, ptr %NEXT_PC, align 8
  %5100 = load ptr, ptr %MEMORY, align 8
  %5101 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5100, ptr %state, ptr undef)
  store ptr %5101, ptr %MEMORY, align 8
  %5102 = load i64, ptr %NEXT_PC, align 8
  store i64 %5102, ptr %PC, align 8
  %5103 = add i64 %5102, 1
  store i64 %5103, ptr %NEXT_PC, align 8
  %5104 = load ptr, ptr %MEMORY, align 8
  %5105 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5104, ptr %state, ptr undef)
  store ptr %5105, ptr %MEMORY, align 8
  %5106 = load i64, ptr %NEXT_PC, align 8
  store i64 %5106, ptr %PC, align 8
  %5107 = add i64 %5106, 1
  store i64 %5107, ptr %NEXT_PC, align 8
  %5108 = load ptr, ptr %MEMORY, align 8
  %5109 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5108, ptr %state, ptr undef)
  store ptr %5109, ptr %MEMORY, align 8
  %5110 = load i64, ptr %NEXT_PC, align 8
  store i64 %5110, ptr %PC, align 8
  %5111 = add i64 %5110, 1
  store i64 %5111, ptr %NEXT_PC, align 8
  %5112 = load ptr, ptr %MEMORY, align 8
  %5113 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5112, ptr %state, ptr undef)
  store ptr %5113, ptr %MEMORY, align 8
  %5114 = load i64, ptr %NEXT_PC, align 8
  store i64 %5114, ptr %PC, align 8
  %5115 = add i64 %5114, 2
  store i64 %5115, ptr %NEXT_PC, align 8
  %5116 = load i64, ptr %RBX, align 8
  %5117 = load ptr, ptr %MEMORY, align 8
  %5118 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %5117, ptr %state, i64 %5116)
  store ptr %5118, ptr %MEMORY, align 8
  %5119 = load i64, ptr %NEXT_PC, align 8
  store i64 %5119, ptr %PC, align 8
  %5120 = add i64 %5119, 4
  store i64 %5120, ptr %NEXT_PC, align 8
  %5121 = load i64, ptr %RSP, align 8
  %5122 = load ptr, ptr %MEMORY, align 8
  %5123 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %5122, ptr %state, ptr %RSP, i64 %5121, i64 64)
  store ptr %5123, ptr %MEMORY, align 8
  %5124 = load i64, ptr %NEXT_PC, align 8
  store i64 %5124, ptr %PC, align 8
  %5125 = add i64 %5124, 5
  store i64 %5125, ptr %NEXT_PC, align 8
  %5126 = load i64, ptr %RSP, align 8
  %5127 = add i64 %5126, 48
  %5128 = load ptr, ptr %MEMORY, align 8
  %5129 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5128, ptr %state, ptr %RAX, i64 %5127)
  store ptr %5129, ptr %MEMORY, align 8
  %5130 = load i64, ptr %NEXT_PC, align 8
  store i64 %5130, ptr %PC, align 8
  %5131 = add i64 %5130, 3
  store i64 %5131, ptr %NEXT_PC, align 8
  %5132 = load i32, ptr %EDX, align 4
  %5133 = zext i32 %5132 to i64
  %5134 = load ptr, ptr %MEMORY, align 8
  %5135 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5134, ptr %state, ptr %R8, i64 %5133)
  store ptr %5135, ptr %MEMORY, align 8
  %5136 = load i64, ptr %NEXT_PC, align 8
  store i64 %5136, ptr %PC, align 8
  %5137 = add i64 %5136, 2
  store i64 %5137, ptr %NEXT_PC, align 8
  %5138 = load i64, ptr %RBX, align 8
  %5139 = load i32, ptr %EBX, align 4
  %5140 = zext i32 %5139 to i64
  %5141 = load ptr, ptr %MEMORY, align 8
  %5142 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %5141, ptr %state, ptr %RBX, i64 %5138, i64 %5140)
  store ptr %5142, ptr %MEMORY, align 8
  %5143 = load i64, ptr %NEXT_PC, align 8
  store i64 %5143, ptr %PC, align 8
  %5144 = add i64 %5143, 5
  store i64 %5144, ptr %NEXT_PC, align 8
  %5145 = load i64, ptr %RSP, align 8
  %5146 = add i64 %5145, 32
  %5147 = load i64, ptr %RAX, align 8
  %5148 = load ptr, ptr %MEMORY, align 8
  %5149 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5148, ptr %state, i64 %5146, i64 %5147)
  store ptr %5149, ptr %MEMORY, align 8
  %5150 = load i64, ptr %NEXT_PC, align 8
  store i64 %5150, ptr %PC, align 8
  %5151 = add i64 %5150, 5
  store i64 %5151, ptr %NEXT_PC, align 8
  %5152 = load i64, ptr %RSP, align 8
  %5153 = add i64 %5152, 96
  %5154 = load ptr, ptr %MEMORY, align 8
  %5155 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5154, ptr %state, ptr %RDX, i64 %5153)
  store ptr %5155, ptr %MEMORY, align 8
  %5156 = load i64, ptr %NEXT_PC, align 8
  store i64 %5156, ptr %PC, align 8
  %5157 = add i64 %5156, 5
  store i64 %5157, ptr %NEXT_PC, align 8
  %5158 = load i64, ptr %RSP, align 8
  %5159 = add i64 %5158, 104
  %5160 = load i64, ptr %RBX, align 8
  %5161 = load ptr, ptr %MEMORY, align 8
  %5162 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5161, ptr %state, i64 %5159, i64 %5160)
  store ptr %5162, ptr %MEMORY, align 8
  %5163 = load i64, ptr %NEXT_PC, align 8
  store i64 %5163, ptr %PC, align 8
  %5164 = add i64 %5163, 5
  store i64 %5164, ptr %NEXT_PC, align 8
  %5165 = load i64, ptr %RSP, align 8
  %5166 = add i64 %5165, 104
  %5167 = load ptr, ptr %MEMORY, align 8
  %5168 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5167, ptr %state, ptr %R9, i64 %5166)
  store ptr %5168, ptr %MEMORY, align 8
  %5169 = load i64, ptr %NEXT_PC, align 8
  store i64 %5169, ptr %PC, align 8
  %5170 = add i64 %5169, 5
  store i64 %5170, ptr %NEXT_PC, align 8
  %5171 = load i64, ptr %NEXT_PC, align 8
  %5172 = add i64 %5171, 1639
  %5173 = load i64, ptr %NEXT_PC, align 8
  %5174 = load ptr, ptr %MEMORY, align 8
  %5175 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %5174, ptr %state, i64 %5172, ptr %NEXT_PC, i64 %5173, ptr %RETURN_PC)
  store ptr %5175, ptr %MEMORY, align 8
  %5176 = load i64, ptr %NEXT_PC, align 8
  store i64 %5176, ptr %PC, align 8
  %5177 = add i64 %5176, 4
  store i64 %5177, ptr %NEXT_PC, align 8
  %5178 = load i64, ptr %RSP, align 8
  %5179 = add i64 %5178, 96
  %5180 = load i32, ptr %EBX, align 4
  %5181 = zext i32 %5180 to i64
  %5182 = load ptr, ptr %MEMORY, align 8
  %5183 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %5182, ptr %state, i64 %5179, i64 %5181)
  store ptr %5183, ptr %MEMORY, align 8
  %5184 = load i64, ptr %NEXT_PC, align 8
  store i64 %5184, ptr %PC, align 8
  %5185 = add i64 %5184, 6
  store i64 %5185, ptr %NEXT_PC, align 8
  %5186 = load i64, ptr %RSP, align 8
  %5187 = add i64 %5186, 104
  %5188 = load ptr, ptr %MEMORY, align 8
  %5189 = call ptr @_ZN12_GLOBAL__N_15CMOVZI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5188, ptr %state, ptr %RBX, i64 %5187)
  store ptr %5189, ptr %MEMORY, align 8
  %5190 = load i64, ptr %NEXT_PC, align 8
  store i64 %5190, ptr %PC, align 8
  %5191 = add i64 %5190, 3
  store i64 %5191, ptr %NEXT_PC, align 8
  %5192 = load i64, ptr %RBX, align 8
  %5193 = load ptr, ptr %MEMORY, align 8
  %5194 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5193, ptr %state, ptr %RAX, i64 %5192)
  store ptr %5194, ptr %MEMORY, align 8
  %5195 = load i64, ptr %NEXT_PC, align 8
  store i64 %5195, ptr %PC, align 8
  %5196 = add i64 %5195, 4
  store i64 %5196, ptr %NEXT_PC, align 8
  %5197 = load i64, ptr %RSP, align 8
  %5198 = load ptr, ptr %MEMORY, align 8
  %5199 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %5198, ptr %state, ptr %RSP, i64 %5197, i64 64)
  store ptr %5199, ptr %MEMORY, align 8
  %5200 = load i64, ptr %NEXT_PC, align 8
  store i64 %5200, ptr %PC, align 8
  %5201 = add i64 %5200, 1
  store i64 %5201, ptr %NEXT_PC, align 8
  %5202 = load ptr, ptr %MEMORY, align 8
  %5203 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %5202, ptr %state, ptr %RBX)
  store ptr %5203, ptr %MEMORY, align 8
  %5204 = load i64, ptr %NEXT_PC, align 8
  store i64 %5204, ptr %PC, align 8
  %5205 = add i64 %5204, 1
  store i64 %5205, ptr %NEXT_PC, align 8
  %5206 = load ptr, ptr %MEMORY, align 8
  %5207 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %5206, ptr %state, ptr %NEXT_PC)
  store ptr %5207, ptr %MEMORY, align 8
  ret ptr %memory

bb_5395660060:                                    ; No predecessors!
  %5208 = load i64, ptr %NEXT_PC, align 8
  store i64 %5208, ptr %PC, align 8
  %5209 = add i64 %5208, 1
  store i64 %5209, ptr %NEXT_PC, align 8
  %5210 = load ptr, ptr %MEMORY, align 8
  %5211 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5210, ptr %state, ptr undef)
  store ptr %5211, ptr %MEMORY, align 8
  %5212 = load i64, ptr %NEXT_PC, align 8
  store i64 %5212, ptr %PC, align 8
  %5213 = add i64 %5212, 1
  store i64 %5213, ptr %NEXT_PC, align 8
  %5214 = load ptr, ptr %MEMORY, align 8
  %5215 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5214, ptr %state, ptr undef)
  store ptr %5215, ptr %MEMORY, align 8
  %5216 = load i64, ptr %NEXT_PC, align 8
  store i64 %5216, ptr %PC, align 8
  %5217 = add i64 %5216, 1
  store i64 %5217, ptr %NEXT_PC, align 8
  %5218 = load ptr, ptr %MEMORY, align 8
  %5219 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5218, ptr %state, ptr undef)
  store ptr %5219, ptr %MEMORY, align 8
  %5220 = load i64, ptr %NEXT_PC, align 8
  store i64 %5220, ptr %PC, align 8
  %5221 = add i64 %5220, 1
  store i64 %5221, ptr %NEXT_PC, align 8
  %5222 = load ptr, ptr %MEMORY, align 8
  %5223 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5222, ptr %state, ptr undef)
  store ptr %5223, ptr %MEMORY, align 8
  %5224 = load i64, ptr %NEXT_PC, align 8
  store i64 %5224, ptr %PC, align 8
  %5225 = add i64 %5224, 1
  store i64 %5225, ptr %NEXT_PC, align 8
  %5226 = load ptr, ptr %MEMORY, align 8
  %5227 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5226, ptr %state, ptr undef)
  store ptr %5227, ptr %MEMORY, align 8
  %5228 = load i64, ptr %NEXT_PC, align 8
  store i64 %5228, ptr %PC, align 8
  %5229 = add i64 %5228, 1
  store i64 %5229, ptr %NEXT_PC, align 8
  %5230 = load ptr, ptr %MEMORY, align 8
  %5231 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5230, ptr %state, ptr undef)
  store ptr %5231, ptr %MEMORY, align 8
  %5232 = load i64, ptr %NEXT_PC, align 8
  store i64 %5232, ptr %PC, align 8
  %5233 = add i64 %5232, 1
  store i64 %5233, ptr %NEXT_PC, align 8
  %5234 = load ptr, ptr %MEMORY, align 8
  %5235 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5234, ptr %state, ptr undef)
  store ptr %5235, ptr %MEMORY, align 8
  %5236 = load i64, ptr %NEXT_PC, align 8
  store i64 %5236, ptr %PC, align 8
  %5237 = add i64 %5236, 1
  store i64 %5237, ptr %NEXT_PC, align 8
  %5238 = load ptr, ptr %MEMORY, align 8
  %5239 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5238, ptr %state, ptr undef)
  store ptr %5239, ptr %MEMORY, align 8
  %5240 = load i64, ptr %NEXT_PC, align 8
  store i64 %5240, ptr %PC, align 8
  %5241 = add i64 %5240, 1
  store i64 %5241, ptr %NEXT_PC, align 8
  %5242 = load ptr, ptr %MEMORY, align 8
  %5243 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5242, ptr %state, ptr undef)
  store ptr %5243, ptr %MEMORY, align 8
  %5244 = load i64, ptr %NEXT_PC, align 8
  store i64 %5244, ptr %PC, align 8
  %5245 = add i64 %5244, 1
  store i64 %5245, ptr %NEXT_PC, align 8
  %5246 = load ptr, ptr %MEMORY, align 8
  %5247 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5246, ptr %state, ptr undef)
  store ptr %5247, ptr %MEMORY, align 8
  %5248 = load i64, ptr %NEXT_PC, align 8
  store i64 %5248, ptr %PC, align 8
  %5249 = add i64 %5248, 1
  store i64 %5249, ptr %NEXT_PC, align 8
  %5250 = load ptr, ptr %MEMORY, align 8
  %5251 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5250, ptr %state, ptr undef)
  store ptr %5251, ptr %MEMORY, align 8
  %5252 = load i64, ptr %NEXT_PC, align 8
  store i64 %5252, ptr %PC, align 8
  %5253 = add i64 %5252, 1
  store i64 %5253, ptr %NEXT_PC, align 8
  %5254 = load ptr, ptr %MEMORY, align 8
  %5255 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5254, ptr %state, ptr undef)
  store ptr %5255, ptr %MEMORY, align 8
  %5256 = load i64, ptr %NEXT_PC, align 8
  store i64 %5256, ptr %PC, align 8
  %5257 = add i64 %5256, 1
  store i64 %5257, ptr %NEXT_PC, align 8
  %5258 = load ptr, ptr %MEMORY, align 8
  %5259 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5258, ptr %state, ptr undef)
  store ptr %5259, ptr %MEMORY, align 8
  %5260 = load i64, ptr %NEXT_PC, align 8
  store i64 %5260, ptr %PC, align 8
  %5261 = add i64 %5260, 1
  store i64 %5261, ptr %NEXT_PC, align 8
  %5262 = load ptr, ptr %MEMORY, align 8
  %5263 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5262, ptr %state, ptr undef)
  store ptr %5263, ptr %MEMORY, align 8
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
