; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: wwzRetailEgs.exe
; Address: 0x14142fe90
; Size: 3750 bytes
; Architecture: amd64
; Generated: 2026-03-03T23:52:44.828Z
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
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i8 @__remill_undefined_8() #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64) #2

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

declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_sge(i1 noundef zeroext) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_16CMOVNLI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture, i64) #2

declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_uge(i1 noundef zeroext) #4

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_eq(i1 noundef zeroext) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15CMOVZI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture, i64) #2

declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_slt(i1 noundef zeroext) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15CMOVLI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_18CDQE_EAXEP6MemoryR5State(ptr noundef readnone returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504)) #3

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_17CDQ_EAXEP6MemoryR5State(ptr noundef readnone returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504)) #3

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i64, i64) #2

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

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2MnIjElEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture readnone) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ANDI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ANDI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12ORI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2MnIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SARI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHLI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, ptr nocapture writeonly) #5

define ptr @lifted_5389876880(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
  %R8B = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 17, i32 0, i32 0, !remill_register !6
  %R15D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 31, i32 0, i32 0, !remill_register !7
  %ECX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !8
  %AL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !9
  %R10 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 21, i32 0, i32 0, !remill_register !10
  %CL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !11
  %R14D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 29, i32 0, i32 0, !remill_register !12
  %ESI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 9, i32 0, i32 0, !remill_register !13
  %EBP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 15, i32 0, i32 0, !remill_register !14
  %EDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !15
  %R11 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 23, i32 0, i32 0, !remill_register !16
  %R12B = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 25, i32 0, i32 0, !remill_register !17
  %EBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !18
  %RBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !19
  %DIL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 11, i32 0, i32 0, !remill_register !20
  %R13D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 27, i32 0, i32 0, !remill_register !21
  %R12D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 25, i32 0, i32 0, !remill_register !22
  %R9 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 19, i32 0, i32 0, !remill_register !23
  %R8 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 17, i32 0, i32 0, !remill_register !24
  %EAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !25
  %RAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !26
  %RCX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !27
  %RDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !28
  %R9D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 19, i32 0, i32 0, !remill_register !29
  %EDI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 11, i32 0, i32 0, !remill_register !30
  %R15 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 31, i32 0, i32 0, !remill_register !31
  %R14 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 29, i32 0, i32 0, !remill_register !32
  %R13 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 27, i32 0, i32 0, !remill_register !33
  %R12 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 25, i32 0, i32 0, !remill_register !34
  %RBP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 15, i32 0, i32 0, !remill_register !35
  %R8D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 17, i32 0, i32 0, !remill_register !36
  %RDI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 11, i32 0, i32 0, !remill_register !37
  %RSI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 9, i32 0, i32 0, !remill_register !38
  %RSP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 13, i32 0, i32 0, !remill_register !39
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
  %PC = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 33, i32 0, i32 0, !remill_register !40
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
  %2 = add i64 %1, 5
  store i64 %2, ptr %NEXT_PC, align 8
  %3 = load i64, ptr %RSP, align 8
  %4 = add i64 %3, 16
  %5 = load i64, ptr %RSI, align 8
  %6 = load ptr, ptr %MEMORY, align 8
  %7 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6, ptr %state, i64 %4, i64 %5)
  store ptr %7, ptr %MEMORY, align 8
  %8 = load i64, ptr %NEXT_PC, align 8
  store i64 %8, ptr %PC, align 8
  %9 = add i64 %8, 5
  store i64 %9, ptr %NEXT_PC, align 8
  %10 = load i64, ptr %RSP, align 8
  %11 = add i64 %10, 32
  %12 = load i64, ptr %RDI, align 8
  %13 = load ptr, ptr %MEMORY, align 8
  %14 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %13, ptr %state, i64 %11, i64 %12)
  store ptr %14, ptr %MEMORY, align 8
  %15 = load i64, ptr %NEXT_PC, align 8
  store i64 %15, ptr %PC, align 8
  %16 = add i64 %15, 5
  store i64 %16, ptr %NEXT_PC, align 8
  %17 = load i64, ptr %RSP, align 8
  %18 = add i64 %17, 24
  %19 = load i32, ptr %R8D, align 4
  %20 = zext i32 %19 to i64
  %21 = load ptr, ptr %MEMORY, align 8
  %22 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %21, ptr %state, i64 %18, i64 %20)
  store ptr %22, ptr %MEMORY, align 8
  %23 = load i64, ptr %NEXT_PC, align 8
  store i64 %23, ptr %PC, align 8
  %24 = add i64 %23, 1
  store i64 %24, ptr %NEXT_PC, align 8
  %25 = load i64, ptr %RBP, align 8
  %26 = load ptr, ptr %MEMORY, align 8
  %27 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %26, ptr %state, i64 %25)
  store ptr %27, ptr %MEMORY, align 8
  %28 = load i64, ptr %NEXT_PC, align 8
  store i64 %28, ptr %PC, align 8
  %29 = add i64 %28, 2
  store i64 %29, ptr %NEXT_PC, align 8
  %30 = load i64, ptr %R12, align 8
  %31 = load ptr, ptr %MEMORY, align 8
  %32 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %31, ptr %state, i64 %30)
  store ptr %32, ptr %MEMORY, align 8
  %33 = load i64, ptr %NEXT_PC, align 8
  store i64 %33, ptr %PC, align 8
  %34 = add i64 %33, 2
  store i64 %34, ptr %NEXT_PC, align 8
  %35 = load i64, ptr %R13, align 8
  %36 = load ptr, ptr %MEMORY, align 8
  %37 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %36, ptr %state, i64 %35)
  store ptr %37, ptr %MEMORY, align 8
  %38 = load i64, ptr %NEXT_PC, align 8
  store i64 %38, ptr %PC, align 8
  %39 = add i64 %38, 2
  store i64 %39, ptr %NEXT_PC, align 8
  %40 = load i64, ptr %R14, align 8
  %41 = load ptr, ptr %MEMORY, align 8
  %42 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %41, ptr %state, i64 %40)
  store ptr %42, ptr %MEMORY, align 8
  %43 = load i64, ptr %NEXT_PC, align 8
  store i64 %43, ptr %PC, align 8
  %44 = add i64 %43, 2
  store i64 %44, ptr %NEXT_PC, align 8
  %45 = load i64, ptr %R15, align 8
  %46 = load ptr, ptr %MEMORY, align 8
  %47 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %46, ptr %state, i64 %45)
  store ptr %47, ptr %MEMORY, align 8
  %48 = load i64, ptr %NEXT_PC, align 8
  store i64 %48, ptr %PC, align 8
  %49 = add i64 %48, 3
  store i64 %49, ptr %NEXT_PC, align 8
  %50 = load i64, ptr %RSP, align 8
  %51 = load ptr, ptr %MEMORY, align 8
  %52 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %51, ptr %state, ptr %RBP, i64 %50)
  store ptr %52, ptr %MEMORY, align 8
  %53 = load i64, ptr %NEXT_PC, align 8
  store i64 %53, ptr %PC, align 8
  %54 = add i64 %53, 4
  store i64 %54, ptr %NEXT_PC, align 8
  %55 = load i64, ptr %RSP, align 8
  %56 = load ptr, ptr %MEMORY, align 8
  %57 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %56, ptr %state, ptr %RSP, i64 %55, i64 96)
  store ptr %57, ptr %MEMORY, align 8
  %58 = load i64, ptr %NEXT_PC, align 8
  store i64 %58, ptr %PC, align 8
  %59 = add i64 %58, 4
  store i64 %59, ptr %NEXT_PC, align 8
  %60 = load i64, ptr %RBP, align 8
  %61 = add i64 %60, 80
  %62 = load ptr, ptr %MEMORY, align 8
  %63 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %62, ptr %state, ptr %RSI, i64 %61)
  store ptr %63, ptr %MEMORY, align 8
  %64 = load i64, ptr %NEXT_PC, align 8
  store i64 %64, ptr %PC, align 8
  %65 = add i64 %64, 2
  store i64 %65, ptr %NEXT_PC, align 8
  %66 = load i64, ptr %RDI, align 8
  %67 = load i32, ptr %EDI, align 4
  %68 = zext i32 %67 to i64
  %69 = load ptr, ptr %MEMORY, align 8
  %70 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %69, ptr %state, ptr %RDI, i64 %66, i64 %68)
  store ptr %70, ptr %MEMORY, align 8
  %71 = load i64, ptr %NEXT_PC, align 8
  store i64 %71, ptr %PC, align 8
  %72 = add i64 %71, 3
  store i64 %72, ptr %NEXT_PC, align 8
  %73 = load i32, ptr %R9D, align 4
  %74 = zext i32 %73 to i64
  %75 = load ptr, ptr %MEMORY, align 8
  %76 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %75, ptr %state, ptr %R13, i64 %74)
  store ptr %76, ptr %MEMORY, align 8
  %77 = load i64, ptr %NEXT_PC, align 8
  store i64 %77, ptr %PC, align 8
  %78 = add i64 %77, 3
  store i64 %78, ptr %NEXT_PC, align 8
  %79 = load i32, ptr %R8D, align 4
  %80 = zext i32 %79 to i64
  %81 = load ptr, ptr %MEMORY, align 8
  %82 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %81, ptr %state, ptr %R12, i64 %80)
  store ptr %82, ptr %MEMORY, align 8
  %83 = load i64, ptr %NEXT_PC, align 8
  store i64 %83, ptr %PC, align 8
  %84 = add i64 %83, 3
  store i64 %84, ptr %NEXT_PC, align 8
  %85 = load i64, ptr %RDX, align 8
  %86 = load ptr, ptr %MEMORY, align 8
  %87 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %86, ptr %state, ptr %R15, i64 %85)
  store ptr %87, ptr %MEMORY, align 8
  %88 = load i64, ptr %NEXT_PC, align 8
  store i64 %88, ptr %PC, align 8
  %89 = add i64 %88, 3
  store i64 %89, ptr %NEXT_PC, align 8
  %90 = load i64, ptr %RCX, align 8
  %91 = load ptr, ptr %MEMORY, align 8
  %92 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %91, ptr %state, ptr %R14, i64 %90)
  store ptr %92, ptr %MEMORY, align 8
  %93 = load i64, ptr %NEXT_PC, align 8
  store i64 %93, ptr %PC, align 8
  %94 = add i64 %93, 6
  store i64 %94, ptr %NEXT_PC, align 8
  %95 = load i64, ptr %RSI, align 8
  %96 = add i64 %95, 256
  %97 = load ptr, ptr %MEMORY, align 8
  %98 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %97, ptr %state, ptr %RAX, i64 %96)
  store ptr %98, ptr %MEMORY, align 8
  %99 = load i64, ptr %NEXT_PC, align 8
  store i64 %99, ptr %PC, align 8
  %100 = add i64 %99, 2
  store i64 %100, ptr %NEXT_PC, align 8
  %101 = load i32, ptr %EAX, align 4
  %102 = zext i32 %101 to i64
  %103 = load i32, ptr %EAX, align 4
  %104 = zext i32 %103 to i64
  %105 = load ptr, ptr %MEMORY, align 8
  %106 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %105, ptr %state, i64 %102, i64 %104)
  store ptr %106, ptr %MEMORY, align 8
  %107 = load i64, ptr %NEXT_PC, align 8
  store i64 %107, ptr %PC, align 8
  %108 = add i64 %107, 2
  store i64 %108, ptr %NEXT_PC, align 8
  %109 = load i64, ptr %NEXT_PC, align 8
  %110 = add i64 %109, 14
  %111 = load i64, ptr %NEXT_PC, align 8
  %112 = load ptr, ptr %MEMORY, align 8
  %113 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %112, ptr %state, ptr %BRANCH_TAKEN, i64 %110, i64 %111, ptr %NEXT_PC)
  store ptr %113, ptr %MEMORY, align 8
  br i1 true, label %bb_5389876953, label %bb_5389876939

bb_5389876939:                                    ; preds = %0
  %114 = load i64, ptr %NEXT_PC, align 8
  store i64 %114, ptr %PC, align 8
  %115 = add i64 %114, 2
  store i64 %115, ptr %NEXT_PC, align 8
  %116 = load i64, ptr %RSI, align 8
  %117 = load i32, ptr %EDI, align 4
  %118 = zext i32 %117 to i64
  %119 = load ptr, ptr %MEMORY, align 8
  %120 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %119, ptr %state, i64 %116, i64 %118)
  store ptr %120, ptr %MEMORY, align 8
  %121 = load i64, ptr %NEXT_PC, align 8
  store i64 %121, ptr %PC, align 8
  %122 = add i64 %121, 6
  store i64 %122, ptr %NEXT_PC, align 8
  %123 = load i64, ptr %RSI, align 8
  %124 = add i64 %123, 256
  %125 = load i64, ptr %RSI, align 8
  %126 = add i64 %125, 256
  %127 = load ptr, ptr %MEMORY, align 8
  %128 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %127, ptr %state, i64 %124, i64 %126)
  store ptr %128, ptr %MEMORY, align 8
  %129 = load i64, ptr %NEXT_PC, align 8
  store i64 %129, ptr %PC, align 8
  %130 = add i64 %129, 6
  store i64 %130, ptr %NEXT_PC, align 8
  %131 = load i64, ptr %RSI, align 8
  %132 = add i64 %131, 256
  %133 = load ptr, ptr %MEMORY, align 8
  %134 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %133, ptr %state, ptr %RAX, i64 %132)
  store ptr %134, ptr %MEMORY, align 8
  br label %bb_5389876953

bb_5389876953:                                    ; preds = %bb_5389876939, %0
  %135 = load i64, ptr %NEXT_PC, align 8
  store i64 %135, ptr %PC, align 8
  %136 = add i64 %135, 3
  store i64 %136, ptr %NEXT_PC, align 8
  %137 = load i32, ptr %EAX, align 4
  %138 = zext i32 %137 to i64
  %139 = load ptr, ptr %MEMORY, align 8
  %140 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %139, ptr %state, i64 %138, i64 1)
  store ptr %140, ptr %MEMORY, align 8
  %141 = load i64, ptr %NEXT_PC, align 8
  store i64 %141, ptr %PC, align 8
  %142 = add i64 %141, 2
  store i64 %142, ptr %NEXT_PC, align 8
  %143 = load i64, ptr %NEXT_PC, align 8
  %144 = add i64 %143, 76
  %145 = load i64, ptr %NEXT_PC, align 8
  %146 = load ptr, ptr %MEMORY, align 8
  %147 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %146, ptr %state, ptr %BRANCH_TAKEN, i64 %144, i64 %145, ptr %NEXT_PC)
  store ptr %147, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877034, label %bb_5389876958

bb_5389876958:                                    ; preds = %bb_5389876953
  %148 = load i64, ptr %NEXT_PC, align 8
  store i64 %148, ptr %PC, align 8
  %149 = add i64 %148, 4
  store i64 %149, ptr %NEXT_PC, align 8
  %150 = load i64, ptr %RBP, align 8
  %151 = sub i64 %150, 40
  %152 = load ptr, ptr %MEMORY, align 8
  %153 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %152, ptr %state, ptr %RCX, i64 %151)
  store ptr %153, ptr %MEMORY, align 8
  %154 = load i64, ptr %NEXT_PC, align 8
  store i64 %154, ptr %PC, align 8
  %155 = add i64 %154, 4
  store i64 %155, ptr %NEXT_PC, align 8
  %156 = load i64, ptr %RBP, align 8
  %157 = sub i64 %156, 8
  %158 = load i64, ptr %RDI, align 8
  %159 = load ptr, ptr %MEMORY, align 8
  %160 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %159, ptr %state, i64 %157, i64 %158)
  store ptr %160, ptr %MEMORY, align 8
  %161 = load i64, ptr %NEXT_PC, align 8
  store i64 %161, ptr %PC, align 8
  %162 = add i64 %161, 5
  store i64 %162, ptr %NEXT_PC, align 8
  %163 = load i64, ptr %NEXT_PC, align 8
  %164 = sub i64 %163, 18801275
  %165 = load i64, ptr %NEXT_PC, align 8
  %166 = load ptr, ptr %MEMORY, align 8
  %167 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %166, ptr %state, i64 %164, ptr %NEXT_PC, i64 %165, ptr %RETURN_PC)
  store ptr %167, ptr %MEMORY, align 8
  %168 = load i64, ptr %NEXT_PC, align 8
  store i64 %168, ptr %PC, align 8
  %169 = add i64 %168, 2
  store i64 %169, ptr %NEXT_PC, align 8
  %170 = load i64, ptr %RSI, align 8
  %171 = load ptr, ptr %MEMORY, align 8
  %172 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %171, ptr %state, ptr %RDX, i64 %170)
  store ptr %172, ptr %MEMORY, align 8
  %173 = load i64, ptr %NEXT_PC, align 8
  store i64 %173, ptr %PC, align 8
  %174 = add i64 %173, 4
  store i64 %174, ptr %NEXT_PC, align 8
  %175 = load i64, ptr %RBP, align 8
  %176 = sub i64 %175, 40
  %177 = load ptr, ptr %MEMORY, align 8
  %178 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %177, ptr %state, ptr %R8, i64 %176)
  store ptr %178, ptr %MEMORY, align 8
  %179 = load i64, ptr %NEXT_PC, align 8
  store i64 %179, ptr %PC, align 8
  %180 = add i64 %179, 3
  store i64 %180, ptr %NEXT_PC, align 8
  %181 = load i32, ptr %R12D, align 4
  %182 = zext i32 %181 to i64
  %183 = load ptr, ptr %MEMORY, align 8
  %184 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %183, ptr %state, ptr %R9, i64 %182)
  store ptr %184, ptr %MEMORY, align 8
  %185 = load i64, ptr %NEXT_PC, align 8
  store i64 %185, ptr %PC, align 8
  %186 = add i64 %185, 8
  store i64 %186, ptr %NEXT_PC, align 8
  %187 = load i64, ptr %RSP, align 8
  %188 = add i64 %187, 40
  %189 = load ptr, ptr %MEMORY, align 8
  %190 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %189, ptr %state, i64 %188, i64 -1)
  store ptr %190, ptr %MEMORY, align 8
  %191 = load i64, ptr %NEXT_PC, align 8
  store i64 %191, ptr %PC, align 8
  %192 = add i64 %191, 3
  store i64 %192, ptr %NEXT_PC, align 8
  %193 = load i64, ptr %R14, align 8
  %194 = load ptr, ptr %MEMORY, align 8
  %195 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %194, ptr %state, ptr %RCX, i64 %193)
  store ptr %195, ptr %MEMORY, align 8
  %196 = load i64, ptr %NEXT_PC, align 8
  store i64 %196, ptr %PC, align 8
  %197 = add i64 %196, 5
  store i64 %197, ptr %NEXT_PC, align 8
  %198 = load i64, ptr %RSP, align 8
  %199 = add i64 %198, 32
  %200 = load i32, ptr %R13D, align 4
  %201 = zext i32 %200 to i64
  %202 = load ptr, ptr %MEMORY, align 8
  %203 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %202, ptr %state, i64 %199, i64 %201)
  store ptr %203, ptr %MEMORY, align 8
  %204 = load i64, ptr %NEXT_PC, align 8
  store i64 %204, ptr %PC, align 8
  %205 = add i64 %204, 5
  store i64 %205, ptr %NEXT_PC, align 8
  %206 = load i64, ptr %NEXT_PC, align 8
  %207 = add i64 %206, 4935
  %208 = load i64, ptr %NEXT_PC, align 8
  %209 = load ptr, ptr %MEMORY, align 8
  %210 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %209, ptr %state, i64 %207, ptr %NEXT_PC, i64 %208, ptr %RETURN_PC)
  store ptr %210, ptr %MEMORY, align 8
  %211 = load i64, ptr %NEXT_PC, align 8
  store i64 %211, ptr %PC, align 8
  %212 = add i64 %211, 4
  store i64 %212, ptr %NEXT_PC, align 8
  %213 = load i64, ptr %R15, align 8
  %214 = add i64 %213, 32
  %215 = load ptr, ptr %MEMORY, align 8
  %216 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %215, ptr %state, ptr %RCX, i64 %214)
  store ptr %216, ptr %MEMORY, align 8
  %217 = load i64, ptr %NEXT_PC, align 8
  store i64 %217, ptr %PC, align 8
  %218 = add i64 %217, 3
  store i64 %218, ptr %NEXT_PC, align 8
  %219 = load i32, ptr %EAX, align 4
  %220 = zext i32 %219 to i64
  %221 = load ptr, ptr %MEMORY, align 8
  %222 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %221, ptr %state, i64 %220, i64 -1)
  store ptr %222, ptr %MEMORY, align 8
  %223 = load i64, ptr %NEXT_PC, align 8
  store i64 %223, ptr %PC, align 8
  %224 = add i64 %223, 4
  store i64 %224, ptr %NEXT_PC, align 8
  %225 = load ptr, ptr %MEMORY, align 8
  %226 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %225, ptr %state, ptr %DIL)
  store ptr %226, ptr %MEMORY, align 8
  %227 = load i64, ptr %NEXT_PC, align 8
  store i64 %227, ptr %PC, align 8
  %228 = add i64 %227, 3
  store i64 %228, ptr %NEXT_PC, align 8
  %229 = load i64, ptr %RCX, align 8
  %230 = load i64, ptr %RCX, align 8
  %231 = load ptr, ptr %MEMORY, align 8
  %232 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %231, ptr %state, i64 %229, i64 %230)
  store ptr %232, ptr %MEMORY, align 8
  %233 = load i64, ptr %NEXT_PC, align 8
  store i64 %233, ptr %PC, align 8
  %234 = add i64 %233, 2
  store i64 %234, ptr %NEXT_PC, align 8
  %235 = load i64, ptr %NEXT_PC, align 8
  %236 = add i64 %235, 10
  %237 = load i64, ptr %NEXT_PC, align 8
  %238 = load ptr, ptr %MEMORY, align 8
  %239 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %238, ptr %state, ptr %BRANCH_TAKEN, i64 %236, i64 %237, ptr %NEXT_PC)
  store ptr %239, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877027, label %bb_5389877017

bb_5389877017:                                    ; preds = %bb_5389876958
  %240 = load i64, ptr %NEXT_PC, align 8
  store i64 %240, ptr %PC, align 8
  %241 = add i64 %240, 3
  store i64 %241, ptr %NEXT_PC, align 8
  %242 = load i64, ptr %RCX, align 8
  %243 = load ptr, ptr %MEMORY, align 8
  %244 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %243, ptr %state, ptr %R8, i64 %242)
  store ptr %244, ptr %MEMORY, align 8
  %245 = load i64, ptr %NEXT_PC, align 8
  store i64 %245, ptr %PC, align 8
  %246 = add i64 %245, 3
  store i64 %246, ptr %NEXT_PC, align 8
  %247 = load i64, ptr %R15, align 8
  %248 = load ptr, ptr %MEMORY, align 8
  %249 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %248, ptr %state, ptr %RDX, i64 %247)
  store ptr %249, ptr %MEMORY, align 8
  %250 = load i64, ptr %NEXT_PC, align 8
  store i64 %250, ptr %PC, align 8
  %251 = add i64 %250, 4
  store i64 %251, ptr %NEXT_PC, align 8
  %252 = load i64, ptr %R8, align 8
  %253 = add i64 %252, 24
  %254 = load i64, ptr %NEXT_PC, align 8
  %255 = load ptr, ptr %MEMORY, align 8
  %256 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %255, ptr %state, i64 %253, ptr %NEXT_PC, i64 %254, ptr %RETURN_PC)
  store ptr %256, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877027:                                    ; preds = %bb_5389876958
  %257 = load i64, ptr %NEXT_PC, align 8
  store i64 %257, ptr %PC, align 8
  %258 = add i64 %257, 2
  store i64 %258, ptr %NEXT_PC, align 8
  %259 = load i32, ptr %EDI, align 4
  %260 = zext i32 %259 to i64
  %261 = load ptr, ptr %MEMORY, align 8
  %262 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %261, ptr %state, ptr %RAX, i64 %260)
  store ptr %262, ptr %MEMORY, align 8
  %263 = load i64, ptr %NEXT_PC, align 8
  store i64 %263, ptr %PC, align 8
  %264 = add i64 %263, 5
  store i64 %264, ptr %NEXT_PC, align 8
  %265 = load i64, ptr %NEXT_PC, align 8
  %266 = add i64 %265, 576
  %267 = load ptr, ptr %MEMORY, align 8
  %268 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %267, ptr %state, i64 %266, ptr %NEXT_PC)
  store ptr %268, ptr %MEMORY, align 8
  br label %bb_5389877610

bb_5389877034:                                    ; preds = %bb_5389876953
  %269 = load i64, ptr %NEXT_PC, align 8
  store i64 %269, ptr %PC, align 8
  %270 = add i64 %269, 2
  store i64 %270, ptr %NEXT_PC, align 8
  %271 = load i64, ptr %RAX, align 8
  %272 = load ptr, ptr %MEMORY, align 8
  %273 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %272, ptr %state, ptr %RAX, i64 %271)
  store ptr %273, ptr %MEMORY, align 8
  %274 = load i64, ptr %NEXT_PC, align 8
  store i64 %274, ptr %PC, align 8
  %275 = add i64 %274, 8
  store i64 %275, ptr %NEXT_PC, align 8
  %276 = load i64, ptr %RSP, align 8
  %277 = add i64 %276, 144
  %278 = load i64, ptr %RBX, align 8
  %279 = load ptr, ptr %MEMORY, align 8
  %280 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %279, ptr %state, i64 %277, i64 %278)
  store ptr %280, ptr %MEMORY, align 8
  %281 = load i64, ptr %NEXT_PC, align 8
  store i64 %281, ptr %PC, align 8
  %282 = add i64 %281, 3
  store i64 %282, ptr %NEXT_PC, align 8
  %283 = load i32, ptr %EAX, align 4
  %284 = zext i32 %283 to i64
  %285 = load ptr, ptr %MEMORY, align 8
  %286 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %285, ptr %state, ptr %RCX, i64 %284)
  store ptr %286, ptr %MEMORY, align 8
  %287 = load i64, ptr %NEXT_PC, align 8
  store i64 %287, ptr %PC, align 8
  %288 = add i64 %287, 3
  store i64 %288, ptr %NEXT_PC, align 8
  %289 = load i64, ptr %RSI, align 8
  %290 = load i64, ptr %RCX, align 8
  %291 = mul i64 %290, 4
  %292 = add i64 %289, %291
  %293 = load ptr, ptr %MEMORY, align 8
  %294 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %293, ptr %state, ptr %RDX, i64 %292)
  store ptr %294, ptr %MEMORY, align 8
  %295 = load i64, ptr %NEXT_PC, align 8
  store i64 %295, ptr %PC, align 8
  %296 = add i64 %295, 3
  store i64 %296, ptr %NEXT_PC, align 8
  %297 = load i64, ptr %R14, align 8
  %298 = load ptr, ptr %MEMORY, align 8
  %299 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %298, ptr %state, ptr %RCX, i64 %297)
  store ptr %299, ptr %MEMORY, align 8
  %300 = load i64, ptr %NEXT_PC, align 8
  store i64 %300, ptr %PC, align 8
  %301 = add i64 %300, 5
  store i64 %301, ptr %NEXT_PC, align 8
  %302 = load i64, ptr %NEXT_PC, align 8
  %303 = add i64 %302, 6478
  %304 = load i64, ptr %NEXT_PC, align 8
  %305 = load ptr, ptr %MEMORY, align 8
  %306 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %305, ptr %state, i64 %303, ptr %NEXT_PC, i64 %304, ptr %RETURN_PC)
  store ptr %306, ptr %MEMORY, align 8
  %307 = load i64, ptr %NEXT_PC, align 8
  store i64 %307, ptr %PC, align 8
  %308 = add i64 %307, 3
  store i64 %308, ptr %NEXT_PC, align 8
  %309 = load i32, ptr %EAX, align 4
  %310 = zext i32 %309 to i64
  %311 = load ptr, ptr %MEMORY, align 8
  %312 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %311, ptr %state, ptr %RBX, i64 %310)
  store ptr %312, ptr %MEMORY, align 8
  %313 = load i64, ptr %NEXT_PC, align 8
  store i64 %313, ptr %PC, align 8
  %314 = add i64 %313, 3
  store i64 %314, ptr %NEXT_PC, align 8
  %315 = load i32, ptr %EBX, align 4
  %316 = zext i32 %315 to i64
  %317 = load ptr, ptr %MEMORY, align 8
  %318 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %317, ptr %state, i64 %316, i64 -1)
  store ptr %318, ptr %MEMORY, align 8
  %319 = load i64, ptr %NEXT_PC, align 8
  store i64 %319, ptr %PC, align 8
  %320 = add i64 %319, 2
  store i64 %320, ptr %NEXT_PC, align 8
  %321 = load i64, ptr %NEXT_PC, align 8
  %322 = add i64 %321, 121
  %323 = load i64, ptr %NEXT_PC, align 8
  %324 = load ptr, ptr %MEMORY, align 8
  %325 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %324, ptr %state, ptr %BRANCH_TAKEN, i64 %322, i64 %323, ptr %NEXT_PC)
  store ptr %325, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877187, label %bb_5389877066

bb_5389877066:                                    ; preds = %bb_5389877034
  %326 = load i64, ptr %NEXT_PC, align 8
  store i64 %326, ptr %PC, align 8
  %327 = add i64 %326, 2
  store i64 %327, ptr %NEXT_PC, align 8
  %328 = load i32, ptr %EAX, align 4
  %329 = zext i32 %328 to i64
  %330 = load i32, ptr %EAX, align 4
  %331 = zext i32 %330 to i64
  %332 = load ptr, ptr %MEMORY, align 8
  %333 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %332, ptr %state, i64 %329, i64 %331)
  store ptr %333, ptr %MEMORY, align 8
  %334 = load i64, ptr %NEXT_PC, align 8
  store i64 %334, ptr %PC, align 8
  %335 = add i64 %334, 2
  store i64 %335, ptr %NEXT_PC, align 8
  %336 = load i64, ptr %NEXT_PC, align 8
  %337 = add i64 %336, 60
  %338 = load i64, ptr %NEXT_PC, align 8
  %339 = load ptr, ptr %MEMORY, align 8
  %340 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %339, ptr %state, ptr %BRANCH_TAKEN, i64 %337, i64 %338, ptr %NEXT_PC)
  store ptr %340, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877130, label %bb_5389877070

bb_5389877070:                                    ; preds = %bb_5389877066
  %341 = load i64, ptr %NEXT_PC, align 8
  store i64 %341, ptr %PC, align 8
  %342 = add i64 %341, 4
  store i64 %342, ptr %NEXT_PC, align 8
  %343 = load i32, ptr %EBX, align 4
  %344 = zext i32 %343 to i64
  %345 = load i64, ptr %R14, align 8
  %346 = add i64 %345, 40
  %347 = load ptr, ptr %MEMORY, align 8
  %348 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %347, ptr %state, i64 %344, i64 %346)
  store ptr %348, ptr %MEMORY, align 8
  %349 = load i64, ptr %NEXT_PC, align 8
  store i64 %349, ptr %PC, align 8
  %350 = add i64 %349, 2
  store i64 %350, ptr %NEXT_PC, align 8
  %351 = load i64, ptr %NEXT_PC, align 8
  %352 = add i64 %351, 54
  %353 = load i64, ptr %NEXT_PC, align 8
  %354 = load ptr, ptr %MEMORY, align 8
  %355 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %354, ptr %state, ptr %BRANCH_TAKEN, i64 %352, i64 %353, ptr %NEXT_PC)
  store ptr %355, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877130, label %bb_5389877076

bb_5389877076:                                    ; preds = %bb_5389877070
  %356 = load i64, ptr %NEXT_PC, align 8
  store i64 %356, ptr %PC, align 8
  %357 = add i64 %356, 4
  store i64 %357, ptr %NEXT_PC, align 8
  %358 = load i64, ptr %R14, align 8
  %359 = add i64 %358, 32
  %360 = load ptr, ptr %MEMORY, align 8
  %361 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %360, ptr %state, ptr %R8, i64 %359)
  store ptr %361, ptr %MEMORY, align 8
  %362 = load i64, ptr %NEXT_PC, align 8
  store i64 %362, ptr %PC, align 8
  %363 = add i64 %362, 3
  store i64 %363, ptr %NEXT_PC, align 8
  %364 = load i64, ptr %RDI, align 8
  %365 = load ptr, ptr %MEMORY, align 8
  %366 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %365, ptr %state, ptr %RCX, i64 %364)
  store ptr %366, ptr %MEMORY, align 8
  %367 = load i64, ptr %NEXT_PC, align 8
  store i64 %367, ptr %PC, align 8
  %368 = add i64 %367, 4
  store i64 %368, ptr %NEXT_PC, align 8
  %369 = load i64, ptr %RBX, align 8
  %370 = load ptr, ptr %MEMORY, align 8
  %371 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %370, ptr %state, ptr %RDX, i64 %369, i64 56)
  store ptr %371, ptr %MEMORY, align 8
  %372 = load i64, ptr %NEXT_PC, align 8
  store i64 %372, ptr %PC, align 8
  %373 = add i64 %372, 4
  store i64 %373, ptr %NEXT_PC, align 8
  %374 = load i64, ptr %R8, align 8
  %375 = load ptr, ptr %MEMORY, align 8
  %376 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %375, ptr %state, ptr %R8, i64 %374, i64 8)
  store ptr %376, ptr %MEMORY, align 8
  %377 = load i64, ptr %NEXT_PC, align 8
  store i64 %377, ptr %PC, align 8
  %378 = add i64 %377, 4
  store i64 %378, ptr %NEXT_PC, align 8
  %379 = load i64, ptr %RBP, align 8
  %380 = sub i64 %379, 8
  %381 = load i64, ptr %RCX, align 8
  %382 = load ptr, ptr %MEMORY, align 8
  %383 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %382, ptr %state, i64 %380, i64 %381)
  store ptr %383, ptr %MEMORY, align 8
  %384 = load i64, ptr %NEXT_PC, align 8
  store i64 %384, ptr %PC, align 8
  %385 = add i64 %384, 3
  store i64 %385, ptr %NEXT_PC, align 8
  %386 = load i64, ptr %R8, align 8
  %387 = load i64, ptr %RDX, align 8
  %388 = load ptr, ptr %MEMORY, align 8
  %389 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %388, ptr %state, ptr %R8, i64 %386, i64 %387)
  store ptr %389, ptr %MEMORY, align 8
  %390 = load i64, ptr %NEXT_PC, align 8
  store i64 %390, ptr %PC, align 8
  %391 = add i64 %390, 4
  store i64 %391, ptr %NEXT_PC, align 8
  %392 = load i64, ptr %R8, align 8
  %393 = add i64 %392, 32
  %394 = load ptr, ptr %MEMORY, align 8
  %395 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %394, ptr %state, ptr %R9, i64 %393)
  store ptr %395, ptr %MEMORY, align 8
  %396 = load i64, ptr %NEXT_PC, align 8
  store i64 %396, ptr %PC, align 8
  %397 = add i64 %396, 3
  store i64 %397, ptr %NEXT_PC, align 8
  %398 = load i64, ptr %R9, align 8
  %399 = load i64, ptr %R9, align 8
  %400 = load ptr, ptr %MEMORY, align 8
  %401 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %400, ptr %state, i64 %398, i64 %399)
  store ptr %401, ptr %MEMORY, align 8
  %402 = load i64, ptr %NEXT_PC, align 8
  store i64 %402, ptr %PC, align 8
  %403 = add i64 %402, 2
  store i64 %403, ptr %NEXT_PC, align 8
  %404 = load i64, ptr %NEXT_PC, align 8
  %405 = add i64 %404, 30
  %406 = load i64, ptr %NEXT_PC, align 8
  %407 = load ptr, ptr %MEMORY, align 8
  %408 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %407, ptr %state, ptr %BRANCH_TAKEN, i64 %405, i64 %406, ptr %NEXT_PC)
  store ptr %408, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877137, label %bb_5389877107

bb_5389877107:                                    ; preds = %bb_5389877076
  %409 = load i64, ptr %NEXT_PC, align 8
  store i64 %409, ptr %PC, align 8
  %410 = add i64 %409, 4
  store i64 %410, ptr %NEXT_PC, align 8
  %411 = load i64, ptr %RBP, align 8
  %412 = sub i64 %411, 8
  %413 = load i64, ptr %R9, align 8
  %414 = load ptr, ptr %MEMORY, align 8
  %415 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %414, ptr %state, i64 %412, i64 %413)
  store ptr %415, ptr %MEMORY, align 8
  %416 = load i64, ptr %NEXT_PC, align 8
  store i64 %416, ptr %PC, align 8
  %417 = add i64 %416, 4
  store i64 %417, ptr %NEXT_PC, align 8
  %418 = load i64, ptr %RBP, align 8
  %419 = sub i64 %418, 40
  %420 = load ptr, ptr %MEMORY, align 8
  %421 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %420, ptr %state, ptr %RDX, i64 %419)
  store ptr %421, ptr %MEMORY, align 8
  %422 = load i64, ptr %NEXT_PC, align 8
  store i64 %422, ptr %PC, align 8
  %423 = add i64 %422, 3
  store i64 %423, ptr %NEXT_PC, align 8
  %424 = load i64, ptr %R9, align 8
  %425 = load ptr, ptr %MEMORY, align 8
  %426 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %425, ptr %state, ptr %RAX, i64 %424)
  store ptr %426, ptr %MEMORY, align 8
  %427 = load i64, ptr %NEXT_PC, align 8
  store i64 %427, ptr %PC, align 8
  %428 = add i64 %427, 3
  store i64 %428, ptr %NEXT_PC, align 8
  %429 = load i64, ptr %R9, align 8
  %430 = load ptr, ptr %MEMORY, align 8
  %431 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %430, ptr %state, ptr %RCX, i64 %429)
  store ptr %431, ptr %MEMORY, align 8
  %432 = load i64, ptr %NEXT_PC, align 8
  store i64 %432, ptr %PC, align 8
  %433 = add i64 %432, 3
  store i64 %433, ptr %NEXT_PC, align 8
  %434 = load i64, ptr %RAX, align 8
  %435 = add i64 %434, 8
  %436 = load i64, ptr %NEXT_PC, align 8
  %437 = load ptr, ptr %MEMORY, align 8
  %438 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %437, ptr %state, i64 %435, ptr %NEXT_PC, i64 %436, ptr %RETURN_PC)
  store ptr %438, ptr %MEMORY, align 8
  %439 = load i64, ptr %NEXT_PC, align 8
  store i64 %439, ptr %PC, align 8
  %440 = add i64 %439, 4
  store i64 %440, ptr %NEXT_PC, align 8
  %441 = load i64, ptr %RBP, align 8
  %442 = sub i64 %441, 8
  %443 = load ptr, ptr %MEMORY, align 8
  %444 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %443, ptr %state, ptr %RCX, i64 %442)
  store ptr %444, ptr %MEMORY, align 8
  %445 = load i64, ptr %NEXT_PC, align 8
  store i64 %445, ptr %PC, align 8
  %446 = add i64 %445, 2
  store i64 %446, ptr %NEXT_PC, align 8
  %447 = load i64, ptr %NEXT_PC, align 8
  %448 = add i64 %447, 7
  %449 = load ptr, ptr %MEMORY, align 8
  %450 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %449, ptr %state, i64 %448, ptr %NEXT_PC)
  store ptr %450, ptr %MEMORY, align 8
  br label %bb_5389877137

bb_5389877130:                                    ; preds = %bb_5389877070, %bb_5389877066
  %451 = load i64, ptr %NEXT_PC, align 8
  store i64 %451, ptr %PC, align 8
  %452 = add i64 %451, 3
  store i64 %452, ptr %NEXT_PC, align 8
  %453 = load i64, ptr %RDI, align 8
  %454 = load ptr, ptr %MEMORY, align 8
  %455 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %454, ptr %state, ptr %RCX, i64 %453)
  store ptr %455, ptr %MEMORY, align 8
  %456 = load i64, ptr %NEXT_PC, align 8
  store i64 %456, ptr %PC, align 8
  %457 = add i64 %456, 4
  store i64 %457, ptr %NEXT_PC, align 8
  %458 = load i64, ptr %RBP, align 8
  %459 = sub i64 %458, 8
  %460 = load i64, ptr %RCX, align 8
  %461 = load ptr, ptr %MEMORY, align 8
  %462 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %461, ptr %state, i64 %459, i64 %460)
  store ptr %462, ptr %MEMORY, align 8
  br label %bb_5389877137

bb_5389877137:                                    ; preds = %bb_5389877130, %bb_5389877107, %bb_5389877076
  %463 = load i64, ptr %NEXT_PC, align 8
  store i64 %463, ptr %PC, align 8
  %464 = add i64 %463, 7
  store i64 %464, ptr %NEXT_PC, align 8
  %465 = load i64, ptr %RCX, align 8
  %466 = load i64, ptr %NEXT_PC, align 8
  %467 = add i64 %466, 27074328
  %468 = load ptr, ptr %MEMORY, align 8
  %469 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %468, ptr %state, i64 %465, i64 %467)
  store ptr %469, ptr %MEMORY, align 8
  %470 = load i64, ptr %NEXT_PC, align 8
  store i64 %470, ptr %PC, align 8
  %471 = add i64 %470, 4
  store i64 %471, ptr %NEXT_PC, align 8
  %472 = load ptr, ptr %MEMORY, align 8
  %473 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %472, ptr %state, ptr %R12B)
  store ptr %473, ptr %MEMORY, align 8
  %474 = load i64, ptr %NEXT_PC, align 8
  store i64 %474, ptr %PC, align 8
  %475 = add i64 %474, 3
  store i64 %475, ptr %NEXT_PC, align 8
  %476 = load i64, ptr %RCX, align 8
  %477 = load i64, ptr %RCX, align 8
  %478 = load ptr, ptr %MEMORY, align 8
  %479 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %478, ptr %state, i64 %476, i64 %477)
  store ptr %479, ptr %MEMORY, align 8
  %480 = load i64, ptr %NEXT_PC, align 8
  store i64 %480, ptr %PC, align 8
  %481 = add i64 %480, 2
  store i64 %481, ptr %NEXT_PC, align 8
  %482 = load i64, ptr %NEXT_PC, align 8
  %483 = add i64 %482, 10
  %484 = load i64, ptr %NEXT_PC, align 8
  %485 = load ptr, ptr %MEMORY, align 8
  %486 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %485, ptr %state, ptr %BRANCH_TAKEN, i64 %483, i64 %484, ptr %NEXT_PC)
  store ptr %486, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877163, label %bb_5389877153

bb_5389877153:                                    ; preds = %bb_5389877137
  %487 = load i64, ptr %NEXT_PC, align 8
  store i64 %487, ptr %PC, align 8
  %488 = add i64 %487, 3
  store i64 %488, ptr %NEXT_PC, align 8
  %489 = load i64, ptr %RCX, align 8
  %490 = load ptr, ptr %MEMORY, align 8
  %491 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %490, ptr %state, ptr %RAX, i64 %489)
  store ptr %491, ptr %MEMORY, align 8
  %492 = load i64, ptr %NEXT_PC, align 8
  store i64 %492, ptr %PC, align 8
  %493 = add i64 %492, 4
  store i64 %493, ptr %NEXT_PC, align 8
  %494 = load i64, ptr %RBP, align 8
  %495 = sub i64 %494, 40
  %496 = load ptr, ptr %MEMORY, align 8
  %497 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %496, ptr %state, ptr %RDX, i64 %495)
  store ptr %497, ptr %MEMORY, align 8
  %498 = load i64, ptr %NEXT_PC, align 8
  store i64 %498, ptr %PC, align 8
  %499 = add i64 %498, 3
  store i64 %499, ptr %NEXT_PC, align 8
  %500 = load i64, ptr %RAX, align 8
  %501 = add i64 %500, 24
  %502 = load i64, ptr %NEXT_PC, align 8
  %503 = load ptr, ptr %MEMORY, align 8
  %504 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %503, ptr %state, i64 %501, ptr %NEXT_PC, i64 %502, ptr %RETURN_PC)
  store ptr %504, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877163:                                    ; preds = %bb_5389877137
  %505 = load i64, ptr %NEXT_PC, align 8
  store i64 %505, ptr %PC, align 8
  %506 = add i64 %505, 3
  store i64 %506, ptr %NEXT_PC, align 8
  %507 = load i8, ptr %R12B, align 1
  %508 = zext i8 %507 to i64
  %509 = load i8, ptr %R12B, align 1
  %510 = zext i8 %509 to i64
  %511 = load ptr, ptr %MEMORY, align 8
  %512 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %511, ptr %state, i64 %508, i64 %510)
  store ptr %512, ptr %MEMORY, align 8
  %513 = load i64, ptr %NEXT_PC, align 8
  store i64 %513, ptr %PC, align 8
  %514 = add i64 %513, 2
  store i64 %514, ptr %NEXT_PC, align 8
  %515 = load i64, ptr %NEXT_PC, align 8
  %516 = add i64 %515, 15
  %517 = load i64, ptr %NEXT_PC, align 8
  %518 = load ptr, ptr %MEMORY, align 8
  %519 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %518, ptr %state, ptr %BRANCH_TAKEN, i64 %516, i64 %517, ptr %NEXT_PC)
  store ptr %519, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877183, label %bb_5389877168

bb_5389877168:                                    ; preds = %bb_5389877163
  %520 = load i64, ptr %NEXT_PC, align 8
  store i64 %520, ptr %PC, align 8
  %521 = add i64 %520, 2
  store i64 %521, ptr %NEXT_PC, align 8
  %522 = load i32, ptr %EBX, align 4
  %523 = zext i32 %522 to i64
  %524 = load ptr, ptr %MEMORY, align 8
  %525 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %524, ptr %state, ptr %RDX, i64 %523)
  store ptr %525, ptr %MEMORY, align 8
  %526 = load i64, ptr %NEXT_PC, align 8
  store i64 %526, ptr %PC, align 8
  %527 = add i64 %526, 3
  store i64 %527, ptr %NEXT_PC, align 8
  %528 = load i64, ptr %R14, align 8
  %529 = load ptr, ptr %MEMORY, align 8
  %530 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %529, ptr %state, ptr %RCX, i64 %528)
  store ptr %530, ptr %MEMORY, align 8
  %531 = load i64, ptr %NEXT_PC, align 8
  store i64 %531, ptr %PC, align 8
  %532 = add i64 %531, 5
  store i64 %532, ptr %NEXT_PC, align 8
  %533 = load i64, ptr %NEXT_PC, align 8
  %534 = add i64 %533, 5398
  %535 = load i64, ptr %NEXT_PC, align 8
  %536 = load ptr, ptr %MEMORY, align 8
  %537 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %536, ptr %state, i64 %534, ptr %NEXT_PC, i64 %535, ptr %RETURN_PC)
  store ptr %537, ptr %MEMORY, align 8
  %538 = load i64, ptr %NEXT_PC, align 8
  store i64 %538, ptr %PC, align 8
  %539 = add i64 %538, 5
  store i64 %539, ptr %NEXT_PC, align 8
  %540 = load ptr, ptr %MEMORY, align 8
  %541 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %540, ptr %state, ptr %RBX, i64 4294967295)
  store ptr %541, ptr %MEMORY, align 8
  br label %bb_5389877183

bb_5389877183:                                    ; preds = %bb_5389877168, %bb_5389877163
  %542 = load i64, ptr %NEXT_PC, align 8
  store i64 %542, ptr %PC, align 8
  %543 = add i64 %542, 4
  store i64 %543, ptr %NEXT_PC, align 8
  %544 = load i64, ptr %RBP, align 8
  %545 = add i64 %544, 64
  %546 = load ptr, ptr %MEMORY, align 8
  %547 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %546, ptr %state, ptr %R12, i64 %545)
  store ptr %547, ptr %MEMORY, align 8
  br label %bb_5389877187

bb_5389877187:                                    ; preds = %bb_5389877183, %bb_5389877034
  %548 = load i64, ptr %NEXT_PC, align 8
  store i64 %548, ptr %PC, align 8
  %549 = add i64 %548, 4
  store i64 %549, ptr %NEXT_PC, align 8
  %550 = load i64, ptr %RBP, align 8
  %551 = add i64 %550, 80
  %552 = load i64, ptr %RDI, align 8
  %553 = load ptr, ptr %MEMORY, align 8
  %554 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %553, ptr %state, i64 %551, i64 %552)
  store ptr %554, ptr %MEMORY, align 8
  %555 = load i64, ptr %NEXT_PC, align 8
  store i64 %555, ptr %PC, align 8
  %556 = add i64 %555, 3
  store i64 %556, ptr %NEXT_PC, align 8
  %557 = load i32, ptr %EBX, align 4
  %558 = zext i32 %557 to i64
  %559 = load ptr, ptr %MEMORY, align 8
  %560 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %559, ptr %state, i64 %558, i64 -1)
  store ptr %560, ptr %MEMORY, align 8
  %561 = load i64, ptr %NEXT_PC, align 8
  store i64 %561, ptr %PC, align 8
  %562 = add i64 %561, 2
  store i64 %562, ptr %NEXT_PC, align 8
  %563 = load i64, ptr %NEXT_PC, align 8
  %564 = add i64 %563, 96
  %565 = load i64, ptr %NEXT_PC, align 8
  %566 = load ptr, ptr %MEMORY, align 8
  %567 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %566, ptr %state, ptr %BRANCH_TAKEN, i64 %564, i64 %565, ptr %NEXT_PC)
  store ptr %567, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877292, label %bb_5389877196

bb_5389877196:                                    ; preds = %bb_5389877187
  %568 = load i64, ptr %NEXT_PC, align 8
  store i64 %568, ptr %PC, align 8
  %569 = add i64 %568, 4
  store i64 %569, ptr %NEXT_PC, align 8
  %570 = load i64, ptr %RBP, align 8
  %571 = add i64 %570, 80
  %572 = load ptr, ptr %MEMORY, align 8
  %573 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %572, ptr %state, ptr %RCX, i64 %571)
  store ptr %573, ptr %MEMORY, align 8
  %574 = load i64, ptr %NEXT_PC, align 8
  store i64 %574, ptr %PC, align 8
  %575 = add i64 %574, 5
  store i64 %575, ptr %NEXT_PC, align 8
  %576 = load i64, ptr %NEXT_PC, align 8
  %577 = sub i64 %576, 584725
  %578 = load i64, ptr %NEXT_PC, align 8
  %579 = load ptr, ptr %MEMORY, align 8
  %580 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %579, ptr %state, i64 %577, ptr %NEXT_PC, i64 %578, ptr %RETURN_PC)
  store ptr %580, ptr %MEMORY, align 8
  %581 = load i64, ptr %NEXT_PC, align 8
  store i64 %581, ptr %PC, align 8
  %582 = add i64 %581, 4
  store i64 %582, ptr %NEXT_PC, align 8
  %583 = load i64, ptr %RBP, align 8
  %584 = sub i64 %583, 8
  %585 = load i64, ptr %RDI, align 8
  %586 = load ptr, ptr %MEMORY, align 8
  %587 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %586, ptr %state, i64 %584, i64 %585)
  store ptr %587, ptr %MEMORY, align 8
  %588 = load i64, ptr %NEXT_PC, align 8
  store i64 %588, ptr %PC, align 8
  %589 = add i64 %588, 4
  store i64 %589, ptr %NEXT_PC, align 8
  %590 = load i64, ptr %RBP, align 8
  %591 = add i64 %590, 80
  %592 = load i64, ptr %RDI, align 8
  %593 = load ptr, ptr %MEMORY, align 8
  %594 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %593, ptr %state, i64 %591, i64 %592)
  store ptr %594, ptr %MEMORY, align 8
  %595 = load i64, ptr %NEXT_PC, align 8
  store i64 %595, ptr %PC, align 8
  %596 = add i64 %595, 2
  store i64 %596, ptr %NEXT_PC, align 8
  %597 = load i64, ptr %NEXT_PC, align 8
  %598 = add i64 %597, 30
  %599 = load i64, ptr %NEXT_PC, align 8
  %600 = load ptr, ptr %MEMORY, align 8
  %601 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %600, ptr %state, ptr %BRANCH_TAKEN, i64 %598, i64 %599, ptr %NEXT_PC)
  store ptr %601, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877245, label %bb_5389877215

bb_5389877215:                                    ; preds = %bb_5389877196
  %602 = load i64, ptr %NEXT_PC, align 8
  store i64 %602, ptr %PC, align 8
  %603 = add i64 %602, 7
  store i64 %603, ptr %NEXT_PC, align 8
  %604 = load i64, ptr %NEXT_PC, align 8
  %605 = add i64 %604, 27074250
  %606 = load ptr, ptr %MEMORY, align 8
  %607 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %606, ptr %state, ptr %RCX, i64 %605)
  store ptr %607, ptr %MEMORY, align 8
  %608 = load i64, ptr %NEXT_PC, align 8
  store i64 %608, ptr %PC, align 8
  %609 = add i64 %608, 4
  store i64 %609, ptr %NEXT_PC, align 8
  %610 = load i64, ptr %RBP, align 8
  %611 = sub i64 %610, 8
  %612 = load i64, ptr %RCX, align 8
  %613 = load ptr, ptr %MEMORY, align 8
  %614 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %613, ptr %state, i64 %611, i64 %612)
  store ptr %614, ptr %MEMORY, align 8
  %615 = load i64, ptr %NEXT_PC, align 8
  store i64 %615, ptr %PC, align 8
  %616 = add i64 %615, 3
  store i64 %616, ptr %NEXT_PC, align 8
  %617 = load i64, ptr %RCX, align 8
  %618 = load i64, ptr %RCX, align 8
  %619 = load ptr, ptr %MEMORY, align 8
  %620 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %619, ptr %state, i64 %617, i64 %618)
  store ptr %620, ptr %MEMORY, align 8
  %621 = load i64, ptr %NEXT_PC, align 8
  store i64 %621, ptr %PC, align 8
  %622 = add i64 %621, 2
  store i64 %622, ptr %NEXT_PC, align 8
  %623 = load i64, ptr %NEXT_PC, align 8
  %624 = add i64 %623, 14
  %625 = load i64, ptr %NEXT_PC, align 8
  %626 = load ptr, ptr %MEMORY, align 8
  %627 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %626, ptr %state, ptr %BRANCH_TAKEN, i64 %624, i64 %625, ptr %NEXT_PC)
  store ptr %627, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877245, label %bb_5389877231

bb_5389877231:                                    ; preds = %bb_5389877215
  %628 = load i64, ptr %NEXT_PC, align 8
  store i64 %628, ptr %PC, align 8
  %629 = add i64 %628, 3
  store i64 %629, ptr %NEXT_PC, align 8
  %630 = load i64, ptr %RCX, align 8
  %631 = load ptr, ptr %MEMORY, align 8
  %632 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %631, ptr %state, ptr %RAX, i64 %630)
  store ptr %632, ptr %MEMORY, align 8
  %633 = load i64, ptr %NEXT_PC, align 8
  store i64 %633, ptr %PC, align 8
  %634 = add i64 %633, 4
  store i64 %634, ptr %NEXT_PC, align 8
  %635 = load i64, ptr %RBP, align 8
  %636 = add i64 %635, 80
  %637 = load ptr, ptr %MEMORY, align 8
  %638 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %637, ptr %state, ptr %R8, i64 %636)
  store ptr %638, ptr %MEMORY, align 8
  %639 = load i64, ptr %NEXT_PC, align 8
  store i64 %639, ptr %PC, align 8
  %640 = add i64 %639, 4
  store i64 %640, ptr %NEXT_PC, align 8
  %641 = load i64, ptr %RBP, align 8
  %642 = sub i64 %641, 40
  %643 = load ptr, ptr %MEMORY, align 8
  %644 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %643, ptr %state, ptr %RDX, i64 %642)
  store ptr %644, ptr %MEMORY, align 8
  %645 = load i64, ptr %NEXT_PC, align 8
  store i64 %645, ptr %PC, align 8
  %646 = add i64 %645, 3
  store i64 %646, ptr %NEXT_PC, align 8
  %647 = load i64, ptr %RAX, align 8
  %648 = add i64 %647, 16
  %649 = load i64, ptr %NEXT_PC, align 8
  %650 = load ptr, ptr %MEMORY, align 8
  %651 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %650, ptr %state, i64 %648, ptr %NEXT_PC, i64 %649, ptr %RETURN_PC)
  store ptr %651, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877245:                                    ; preds = %bb_5389877215, %bb_5389877196
  %652 = load i64, ptr %NEXT_PC, align 8
  store i64 %652, ptr %PC, align 8
  %653 = add i64 %652, 6
  store i64 %653, ptr %NEXT_PC, align 8
  %654 = load i64, ptr %RSI, align 8
  %655 = add i64 %654, 256
  %656 = load ptr, ptr %MEMORY, align 8
  %657 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %656, ptr %state, ptr %RAX, i64 %655)
  store ptr %657, ptr %MEMORY, align 8
  %658 = load i64, ptr %NEXT_PC, align 8
  store i64 %658, ptr %PC, align 8
  %659 = add i64 %658, 4
  store i64 %659, ptr %NEXT_PC, align 8
  %660 = load i64, ptr %RBP, align 8
  %661 = sub i64 %660, 40
  %662 = load ptr, ptr %MEMORY, align 8
  %663 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %662, ptr %state, ptr %R8, i64 %661)
  store ptr %663, ptr %MEMORY, align 8
  %664 = load i64, ptr %NEXT_PC, align 8
  store i64 %664, ptr %PC, align 8
  %665 = add i64 %664, 2
  store i64 %665, ptr %NEXT_PC, align 8
  %666 = load i64, ptr %RAX, align 8
  %667 = load ptr, ptr %MEMORY, align 8
  %668 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %667, ptr %state, ptr %RAX, i64 %666)
  store ptr %668, ptr %MEMORY, align 8
  %669 = load i64, ptr %NEXT_PC, align 8
  store i64 %669, ptr %PC, align 8
  %670 = add i64 %669, 8
  store i64 %670, ptr %NEXT_PC, align 8
  %671 = load i64, ptr %RSP, align 8
  %672 = add i64 %671, 40
  %673 = load ptr, ptr %MEMORY, align 8
  %674 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %673, ptr %state, i64 %672, i64 -1)
  store ptr %674, ptr %MEMORY, align 8
  %675 = load i64, ptr %NEXT_PC, align 8
  store i64 %675, ptr %PC, align 8
  %676 = add i64 %675, 3
  store i64 %676, ptr %NEXT_PC, align 8
  %677 = load i32, ptr %EAX, align 4
  %678 = zext i32 %677 to i64
  %679 = load ptr, ptr %MEMORY, align 8
  %680 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %679, ptr %state, ptr %RCX, i64 %678)
  store ptr %680, ptr %MEMORY, align 8
  %681 = load i64, ptr %NEXT_PC, align 8
  store i64 %681, ptr %PC, align 8
  %682 = add i64 %681, 3
  store i64 %682, ptr %NEXT_PC, align 8
  %683 = load i32, ptr %R12D, align 4
  %684 = zext i32 %683 to i64
  %685 = load ptr, ptr %MEMORY, align 8
  %686 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %685, ptr %state, ptr %R9, i64 %684)
  store ptr %686, ptr %MEMORY, align 8
  %687 = load i64, ptr %NEXT_PC, align 8
  store i64 %687, ptr %PC, align 8
  %688 = add i64 %687, 5
  store i64 %688, ptr %NEXT_PC, align 8
  %689 = load i64, ptr %RSP, align 8
  %690 = add i64 %689, 32
  %691 = load i32, ptr %R13D, align 4
  %692 = zext i32 %691 to i64
  %693 = load ptr, ptr %MEMORY, align 8
  %694 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %693, ptr %state, i64 %690, i64 %692)
  store ptr %694, ptr %MEMORY, align 8
  %695 = load i64, ptr %NEXT_PC, align 8
  store i64 %695, ptr %PC, align 8
  %696 = add i64 %695, 3
  store i64 %696, ptr %NEXT_PC, align 8
  %697 = load i64, ptr %RSI, align 8
  %698 = load i64, ptr %RCX, align 8
  %699 = mul i64 %698, 4
  %700 = add i64 %697, %699
  %701 = load ptr, ptr %MEMORY, align 8
  %702 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %701, ptr %state, ptr %RDX, i64 %700)
  store ptr %702, ptr %MEMORY, align 8
  %703 = load i64, ptr %NEXT_PC, align 8
  store i64 %703, ptr %PC, align 8
  %704 = add i64 %703, 3
  store i64 %704, ptr %NEXT_PC, align 8
  %705 = load i64, ptr %R14, align 8
  %706 = load ptr, ptr %MEMORY, align 8
  %707 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %706, ptr %state, ptr %RCX, i64 %705)
  store ptr %707, ptr %MEMORY, align 8
  %708 = load i64, ptr %NEXT_PC, align 8
  store i64 %708, ptr %PC, align 8
  %709 = add i64 %708, 5
  store i64 %709, ptr %NEXT_PC, align 8
  %710 = load i64, ptr %NEXT_PC, align 8
  %711 = add i64 %710, 4649
  %712 = load i64, ptr %NEXT_PC, align 8
  %713 = load ptr, ptr %MEMORY, align 8
  %714 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %713, ptr %state, i64 %711, ptr %NEXT_PC, i64 %712, ptr %RETURN_PC)
  store ptr %714, ptr %MEMORY, align 8
  %715 = load i64, ptr %NEXT_PC, align 8
  store i64 %715, ptr %PC, align 8
  %716 = add i64 %715, 5
  store i64 %716, ptr %NEXT_PC, align 8
  %717 = load i64, ptr %NEXT_PC, align 8
  %718 = add i64 %717, 227
  %719 = load ptr, ptr %MEMORY, align 8
  %720 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %719, ptr %state, i64 %718, ptr %NEXT_PC)
  store ptr %720, ptr %MEMORY, align 8
  br label %bb_5389877519

bb_5389877292:                                    ; preds = %bb_5389877187
  %721 = load i64, ptr %NEXT_PC, align 8
  store i64 %721, ptr %PC, align 8
  %722 = add i64 %721, 2
  store i64 %722, ptr %NEXT_PC, align 8
  %723 = load i32, ptr %EBX, align 4
  %724 = zext i32 %723 to i64
  %725 = load i32, ptr %EBX, align 4
  %726 = zext i32 %725 to i64
  %727 = load ptr, ptr %MEMORY, align 8
  %728 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %727, ptr %state, i64 %724, i64 %726)
  store ptr %728, ptr %MEMORY, align 8
  %729 = load i64, ptr %NEXT_PC, align 8
  store i64 %729, ptr %PC, align 8
  %730 = add i64 %729, 2
  store i64 %730, ptr %NEXT_PC, align 8
  %731 = load i64, ptr %NEXT_PC, align 8
  %732 = add i64 %731, 60
  %733 = load i64, ptr %NEXT_PC, align 8
  %734 = load ptr, ptr %MEMORY, align 8
  %735 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %734, ptr %state, ptr %BRANCH_TAKEN, i64 %732, i64 %733, ptr %NEXT_PC)
  store ptr %735, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877356, label %bb_5389877296

bb_5389877296:                                    ; preds = %bb_5389877292
  %736 = load i64, ptr %NEXT_PC, align 8
  store i64 %736, ptr %PC, align 8
  %737 = add i64 %736, 4
  store i64 %737, ptr %NEXT_PC, align 8
  %738 = load i32, ptr %EBX, align 4
  %739 = zext i32 %738 to i64
  %740 = load i64, ptr %R14, align 8
  %741 = add i64 %740, 40
  %742 = load ptr, ptr %MEMORY, align 8
  %743 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %742, ptr %state, i64 %739, i64 %741)
  store ptr %743, ptr %MEMORY, align 8
  %744 = load i64, ptr %NEXT_PC, align 8
  store i64 %744, ptr %PC, align 8
  %745 = add i64 %744, 2
  store i64 %745, ptr %NEXT_PC, align 8
  %746 = load i64, ptr %NEXT_PC, align 8
  %747 = add i64 %746, 54
  %748 = load i64, ptr %NEXT_PC, align 8
  %749 = load ptr, ptr %MEMORY, align 8
  %750 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %749, ptr %state, ptr %BRANCH_TAKEN, i64 %747, i64 %748, ptr %NEXT_PC)
  store ptr %750, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877356, label %bb_5389877302

bb_5389877302:                                    ; preds = %bb_5389877296
  %751 = load i64, ptr %NEXT_PC, align 8
  store i64 %751, ptr %PC, align 8
  %752 = add i64 %751, 4
  store i64 %752, ptr %NEXT_PC, align 8
  %753 = load i64, ptr %R14, align 8
  %754 = add i64 %753, 32
  %755 = load ptr, ptr %MEMORY, align 8
  %756 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %755, ptr %state, ptr %R8, i64 %754)
  store ptr %756, ptr %MEMORY, align 8
  %757 = load i64, ptr %NEXT_PC, align 8
  store i64 %757, ptr %PC, align 8
  %758 = add i64 %757, 3
  store i64 %758, ptr %NEXT_PC, align 8
  %759 = load i64, ptr %RDI, align 8
  %760 = load ptr, ptr %MEMORY, align 8
  %761 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %760, ptr %state, ptr %R9, i64 %759)
  store ptr %761, ptr %MEMORY, align 8
  %762 = load i64, ptr %NEXT_PC, align 8
  store i64 %762, ptr %PC, align 8
  %763 = add i64 %762, 4
  store i64 %763, ptr %NEXT_PC, align 8
  %764 = load i64, ptr %R8, align 8
  %765 = load ptr, ptr %MEMORY, align 8
  %766 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %765, ptr %state, ptr %R8, i64 %764, i64 8)
  store ptr %766, ptr %MEMORY, align 8
  %767 = load i64, ptr %NEXT_PC, align 8
  store i64 %767, ptr %PC, align 8
  %768 = add i64 %767, 3
  store i64 %768, ptr %NEXT_PC, align 8
  %769 = load i32, ptr %EBX, align 4
  %770 = zext i32 %769 to i64
  %771 = load ptr, ptr %MEMORY, align 8
  %772 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %771, ptr %state, ptr %RAX, i64 %770)
  store ptr %772, ptr %MEMORY, align 8
  %773 = load i64, ptr %NEXT_PC, align 8
  store i64 %773, ptr %PC, align 8
  %774 = add i64 %773, 4
  store i64 %774, ptr %NEXT_PC, align 8
  %775 = load i64, ptr %RAX, align 8
  %776 = load ptr, ptr %MEMORY, align 8
  %777 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %776, ptr %state, ptr %RCX, i64 %775, i64 56)
  store ptr %777, ptr %MEMORY, align 8
  %778 = load i64, ptr %NEXT_PC, align 8
  store i64 %778, ptr %PC, align 8
  %779 = add i64 %778, 4
  store i64 %779, ptr %NEXT_PC, align 8
  %780 = load i64, ptr %RBP, align 8
  %781 = sub i64 %780, 8
  %782 = load i64, ptr %RDI, align 8
  %783 = load ptr, ptr %MEMORY, align 8
  %784 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %783, ptr %state, i64 %781, i64 %782)
  store ptr %784, ptr %MEMORY, align 8
  %785 = load i64, ptr %NEXT_PC, align 8
  store i64 %785, ptr %PC, align 8
  %786 = add i64 %785, 3
  store i64 %786, ptr %NEXT_PC, align 8
  %787 = load i64, ptr %R8, align 8
  %788 = load i64, ptr %RCX, align 8
  %789 = load ptr, ptr %MEMORY, align 8
  %790 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %789, ptr %state, ptr %R8, i64 %787, i64 %788)
  store ptr %790, ptr %MEMORY, align 8
  %791 = load i64, ptr %NEXT_PC, align 8
  store i64 %791, ptr %PC, align 8
  %792 = add i64 %791, 4
  store i64 %792, ptr %NEXT_PC, align 8
  %793 = load i64, ptr %R8, align 8
  %794 = add i64 %793, 32
  %795 = load ptr, ptr %MEMORY, align 8
  %796 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %795, ptr %state, ptr %RCX, i64 %794)
  store ptr %796, ptr %MEMORY, align 8
  %797 = load i64, ptr %NEXT_PC, align 8
  store i64 %797, ptr %PC, align 8
  %798 = add i64 %797, 3
  store i64 %798, ptr %NEXT_PC, align 8
  %799 = load i64, ptr %RCX, align 8
  %800 = load i64, ptr %RCX, align 8
  %801 = load ptr, ptr %MEMORY, align 8
  %802 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %801, ptr %state, i64 %799, i64 %800)
  store ptr %802, ptr %MEMORY, align 8
  %803 = load i64, ptr %NEXT_PC, align 8
  store i64 %803, ptr %PC, align 8
  %804 = add i64 %803, 2
  store i64 %804, ptr %NEXT_PC, align 8
  %805 = load i64, ptr %NEXT_PC, align 8
  %806 = add i64 %805, 27
  %807 = load i64, ptr %NEXT_PC, align 8
  %808 = load ptr, ptr %MEMORY, align 8
  %809 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %808, ptr %state, ptr %BRANCH_TAKEN, i64 %806, i64 %807, ptr %NEXT_PC)
  store ptr %809, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877363, label %bb_5389877336

bb_5389877336:                                    ; preds = %bb_5389877302
  %810 = load i64, ptr %NEXT_PC, align 8
  store i64 %810, ptr %PC, align 8
  %811 = add i64 %810, 4
  store i64 %811, ptr %NEXT_PC, align 8
  %812 = load i64, ptr %RBP, align 8
  %813 = sub i64 %812, 8
  %814 = load i64, ptr %RCX, align 8
  %815 = load ptr, ptr %MEMORY, align 8
  %816 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %815, ptr %state, i64 %813, i64 %814)
  store ptr %816, ptr %MEMORY, align 8
  %817 = load i64, ptr %NEXT_PC, align 8
  store i64 %817, ptr %PC, align 8
  %818 = add i64 %817, 4
  store i64 %818, ptr %NEXT_PC, align 8
  %819 = load i64, ptr %RBP, align 8
  %820 = sub i64 %819, 40
  %821 = load ptr, ptr %MEMORY, align 8
  %822 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %821, ptr %state, ptr %RDX, i64 %820)
  store ptr %822, ptr %MEMORY, align 8
  %823 = load i64, ptr %NEXT_PC, align 8
  store i64 %823, ptr %PC, align 8
  %824 = add i64 %823, 3
  store i64 %824, ptr %NEXT_PC, align 8
  %825 = load i64, ptr %RCX, align 8
  %826 = load ptr, ptr %MEMORY, align 8
  %827 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %826, ptr %state, ptr %RAX, i64 %825)
  store ptr %827, ptr %MEMORY, align 8
  %828 = load i64, ptr %NEXT_PC, align 8
  store i64 %828, ptr %PC, align 8
  %829 = add i64 %828, 3
  store i64 %829, ptr %NEXT_PC, align 8
  %830 = load i64, ptr %RAX, align 8
  %831 = add i64 %830, 8
  %832 = load i64, ptr %NEXT_PC, align 8
  %833 = load ptr, ptr %MEMORY, align 8
  %834 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %833, ptr %state, i64 %831, ptr %NEXT_PC, i64 %832, ptr %RETURN_PC)
  store ptr %834, ptr %MEMORY, align 8
  %835 = load i64, ptr %NEXT_PC, align 8
  store i64 %835, ptr %PC, align 8
  %836 = add i64 %835, 4
  store i64 %836, ptr %NEXT_PC, align 8
  %837 = load i64, ptr %RBP, align 8
  %838 = sub i64 %837, 8
  %839 = load ptr, ptr %MEMORY, align 8
  %840 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %839, ptr %state, ptr %R9, i64 %838)
  store ptr %840, ptr %MEMORY, align 8
  %841 = load i64, ptr %NEXT_PC, align 8
  store i64 %841, ptr %PC, align 8
  %842 = add i64 %841, 2
  store i64 %842, ptr %NEXT_PC, align 8
  %843 = load i64, ptr %NEXT_PC, align 8
  %844 = add i64 %843, 7
  %845 = load ptr, ptr %MEMORY, align 8
  %846 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %845, ptr %state, i64 %844, ptr %NEXT_PC)
  store ptr %846, ptr %MEMORY, align 8
  br label %bb_5389877363

bb_5389877356:                                    ; preds = %bb_5389877296, %bb_5389877292
  %847 = load i64, ptr %NEXT_PC, align 8
  store i64 %847, ptr %PC, align 8
  %848 = add i64 %847, 3
  store i64 %848, ptr %NEXT_PC, align 8
  %849 = load i64, ptr %RDI, align 8
  %850 = load ptr, ptr %MEMORY, align 8
  %851 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %850, ptr %state, ptr %R9, i64 %849)
  store ptr %851, ptr %MEMORY, align 8
  %852 = load i64, ptr %NEXT_PC, align 8
  store i64 %852, ptr %PC, align 8
  %853 = add i64 %852, 4
  store i64 %853, ptr %NEXT_PC, align 8
  %854 = load i64, ptr %RBP, align 8
  %855 = sub i64 %854, 8
  %856 = load i64, ptr %RDI, align 8
  %857 = load ptr, ptr %MEMORY, align 8
  %858 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %857, ptr %state, i64 %855, i64 %856)
  store ptr %858, ptr %MEMORY, align 8
  br label %bb_5389877363

bb_5389877363:                                    ; preds = %bb_5389877356, %bb_5389877336, %bb_5389877302
  %859 = load i64, ptr %NEXT_PC, align 8
  store i64 %859, ptr %PC, align 8
  %860 = add i64 %859, 7
  store i64 %860, ptr %NEXT_PC, align 8
  %861 = load i64, ptr %R9, align 8
  %862 = load i64, ptr %NEXT_PC, align 8
  %863 = add i64 %862, 27074102
  %864 = load ptr, ptr %MEMORY, align 8
  %865 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %864, ptr %state, i64 %861, i64 %863)
  store ptr %865, ptr %MEMORY, align 8
  %866 = load i64, ptr %NEXT_PC, align 8
  store i64 %866, ptr %PC, align 8
  %867 = add i64 %866, 3
  store i64 %867, ptr %NEXT_PC, align 8
  %868 = load i64, ptr %RDI, align 8
  %869 = load ptr, ptr %MEMORY, align 8
  %870 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %869, ptr %state, ptr %RCX, i64 %868)
  store ptr %870, ptr %MEMORY, align 8
  %871 = load i64, ptr %NEXT_PC, align 8
  store i64 %871, ptr %PC, align 8
  %872 = add i64 %871, 4
  store i64 %872, ptr %NEXT_PC, align 8
  %873 = load i64, ptr %RBP, align 8
  %874 = sub i64 %873, 48
  %875 = load i64, ptr %RCX, align 8
  %876 = load ptr, ptr %MEMORY, align 8
  %877 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %876, ptr %state, i64 %874, i64 %875)
  store ptr %877, ptr %MEMORY, align 8
  %878 = load i64, ptr %NEXT_PC, align 8
  store i64 %878, ptr %PC, align 8
  %879 = add i64 %878, 2
  store i64 %879, ptr %NEXT_PC, align 8
  %880 = load i64, ptr %NEXT_PC, align 8
  %881 = add i64 %880, 79
  %882 = load i64, ptr %NEXT_PC, align 8
  %883 = load ptr, ptr %MEMORY, align 8
  %884 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %883, ptr %state, ptr %BRANCH_TAKEN, i64 %881, i64 %882, ptr %NEXT_PC)
  store ptr %884, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877458, label %bb_5389877379

bb_5389877379:                                    ; preds = %bb_5389877363
  %885 = load i64, ptr %NEXT_PC, align 8
  store i64 %885, ptr %PC, align 8
  %886 = add i64 %885, 3
  store i64 %886, ptr %NEXT_PC, align 8
  %887 = load i64, ptr %R9, align 8
  %888 = load i64, ptr %R9, align 8
  %889 = load ptr, ptr %MEMORY, align 8
  %890 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %889, ptr %state, i64 %887, i64 %888)
  store ptr %890, ptr %MEMORY, align 8
  %891 = load i64, ptr %NEXT_PC, align 8
  store i64 %891, ptr %PC, align 8
  %892 = add i64 %891, 2
  store i64 %892, ptr %NEXT_PC, align 8
  %893 = load i64, ptr %NEXT_PC, align 8
  %894 = add i64 %893, 74
  %895 = load i64, ptr %NEXT_PC, align 8
  %896 = load ptr, ptr %MEMORY, align 8
  %897 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %896, ptr %state, ptr %BRANCH_TAKEN, i64 %894, i64 %895, ptr %NEXT_PC)
  store ptr %897, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877458, label %bb_5389877384

bb_5389877384:                                    ; preds = %bb_5389877379
  %898 = load i64, ptr %NEXT_PC, align 8
  store i64 %898, ptr %PC, align 8
  %899 = add i64 %898, 3
  store i64 %899, ptr %NEXT_PC, align 8
  %900 = load i64, ptr %R9, align 8
  %901 = load ptr, ptr %MEMORY, align 8
  %902 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %901, ptr %state, ptr %RAX, i64 %900)
  store ptr %902, ptr %MEMORY, align 8
  %903 = load i64, ptr %NEXT_PC, align 8
  store i64 %903, ptr %PC, align 8
  %904 = add i64 %903, 4
  store i64 %904, ptr %NEXT_PC, align 8
  %905 = load i64, ptr %RBP, align 8
  %906 = sub i64 %905, 40
  %907 = load ptr, ptr %MEMORY, align 8
  %908 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %907, ptr %state, ptr %RDX, i64 %906)
  store ptr %908, ptr %MEMORY, align 8
  %909 = load i64, ptr %NEXT_PC, align 8
  store i64 %909, ptr %PC, align 8
  %910 = add i64 %909, 3
  store i64 %910, ptr %NEXT_PC, align 8
  %911 = load i64, ptr %R9, align 8
  %912 = load ptr, ptr %MEMORY, align 8
  %913 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %912, ptr %state, ptr %RCX, i64 %911)
  store ptr %913, ptr %MEMORY, align 8
  %914 = load i64, ptr %NEXT_PC, align 8
  store i64 %914, ptr %PC, align 8
  %915 = add i64 %914, 3
  store i64 %915, ptr %NEXT_PC, align 8
  %916 = load i64, ptr %RAX, align 8
  %917 = add i64 %916, 56
  %918 = load i64, ptr %NEXT_PC, align 8
  %919 = load ptr, ptr %MEMORY, align 8
  %920 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %919, ptr %state, i64 %917, ptr %NEXT_PC, i64 %918, ptr %RETURN_PC)
  store ptr %920, ptr %MEMORY, align 8
  %921 = load i64, ptr %NEXT_PC, align 8
  store i64 %921, ptr %PC, align 8
  %922 = add i64 %921, 3
  store i64 %922, ptr %NEXT_PC, align 8
  %923 = load i64, ptr %RAX, align 8
  %924 = load ptr, ptr %MEMORY, align 8
  %925 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %924, ptr %state, ptr %RBX, i64 %923)
  store ptr %925, ptr %MEMORY, align 8
  %926 = load i64, ptr %NEXT_PC, align 8
  store i64 %926, ptr %PC, align 8
  %927 = add i64 %926, 3
  store i64 %927, ptr %NEXT_PC, align 8
  %928 = load i64, ptr %RAX, align 8
  %929 = load ptr, ptr %MEMORY, align 8
  %930 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %929, ptr %state, ptr %RCX, i64 %928)
  store ptr %930, ptr %MEMORY, align 8
  %931 = load i64, ptr %NEXT_PC, align 8
  store i64 %931, ptr %PC, align 8
  %932 = add i64 %931, 3
  store i64 %932, ptr %NEXT_PC, align 8
  %933 = load i64, ptr %RCX, align 8
  %934 = load i64, ptr %RCX, align 8
  %935 = load ptr, ptr %MEMORY, align 8
  %936 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %935, ptr %state, i64 %933, i64 %934)
  store ptr %936, ptr %MEMORY, align 8
  %937 = load i64, ptr %NEXT_PC, align 8
  store i64 %937, ptr %PC, align 8
  %938 = add i64 %937, 2
  store i64 %938, ptr %NEXT_PC, align 8
  %939 = load i64, ptr %NEXT_PC, align 8
  %940 = add i64 %939, 8
  %941 = load i64, ptr %NEXT_PC, align 8
  %942 = load ptr, ptr %MEMORY, align 8
  %943 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %942, ptr %state, ptr %BRANCH_TAKEN, i64 %940, i64 %941, ptr %NEXT_PC)
  store ptr %943, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877416, label %bb_5389877408

bb_5389877408:                                    ; preds = %bb_5389877384
  %944 = load i64, ptr %NEXT_PC, align 8
  store i64 %944, ptr %PC, align 8
  %945 = add i64 %944, 2
  store i64 %945, ptr %NEXT_PC, align 8
  %946 = load i64, ptr %RCX, align 8
  %947 = load i64, ptr %RCX, align 8
  %948 = load ptr, ptr %MEMORY, align 8
  %949 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %948, ptr %state, i64 %946, i64 %947)
  store ptr %949, ptr %MEMORY, align 8
  %950 = load i64, ptr %NEXT_PC, align 8
  store i64 %950, ptr %PC, align 8
  %951 = add i64 %950, 4
  store i64 %951, ptr %NEXT_PC, align 8
  %952 = load i64, ptr %RCX, align 8
  %953 = add i64 %952, 48
  %954 = load ptr, ptr %MEMORY, align 8
  %955 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %954, ptr %state, ptr %RCX, i64 %953)
  store ptr %955, ptr %MEMORY, align 8
  %956 = load i64, ptr %NEXT_PC, align 8
  store i64 %956, ptr %PC, align 8
  %957 = add i64 %956, 2
  store i64 %957, ptr %NEXT_PC, align 8
  %958 = load i64, ptr %RCX, align 8
  %959 = load i64, ptr %RCX, align 8
  %960 = load ptr, ptr %MEMORY, align 8
  %961 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %960, ptr %state, i64 %958, i64 %959)
  store ptr %961, ptr %MEMORY, align 8
  br label %bb_5389877416

bb_5389877416:                                    ; preds = %bb_5389877408, %bb_5389877384
  %962 = load i64, ptr %NEXT_PC, align 8
  store i64 %962, ptr %PC, align 8
  %963 = add i64 %962, 4
  store i64 %963, ptr %NEXT_PC, align 8
  %964 = load i64, ptr %RBP, align 8
  %965 = sub i64 %964, 48
  %966 = load ptr, ptr %MEMORY, align 8
  %967 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %966, ptr %state, ptr %RCX, i64 %965)
  store ptr %967, ptr %MEMORY, align 8
  %968 = load i64, ptr %NEXT_PC, align 8
  store i64 %968, ptr %PC, align 8
  %969 = add i64 %968, 3
  store i64 %969, ptr %NEXT_PC, align 8
  %970 = load i64, ptr %RCX, align 8
  %971 = load i64, ptr %RCX, align 8
  %972 = load ptr, ptr %MEMORY, align 8
  %973 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %972, ptr %state, i64 %970, i64 %971)
  store ptr %973, ptr %MEMORY, align 8
  %974 = load i64, ptr %NEXT_PC, align 8
  store i64 %974, ptr %PC, align 8
  %975 = add i64 %974, 2
  store i64 %975, ptr %NEXT_PC, align 8
  %976 = load i64, ptr %NEXT_PC, align 8
  %977 = add i64 %976, 5
  %978 = load i64, ptr %NEXT_PC, align 8
  %979 = load ptr, ptr %MEMORY, align 8
  %980 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %979, ptr %state, ptr %BRANCH_TAKEN, i64 %977, i64 %978, ptr %NEXT_PC)
  store ptr %980, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877430, label %bb_5389877425

bb_5389877425:                                    ; preds = %bb_5389877416
  %981 = load i64, ptr %NEXT_PC, align 8
  store i64 %981, ptr %PC, align 8
  %982 = add i64 %981, 5
  store i64 %982, ptr %NEXT_PC, align 8
  %983 = load i64, ptr %NEXT_PC, align 8
  %984 = sub i64 %983, 726
  %985 = load i64, ptr %NEXT_PC, align 8
  %986 = load ptr, ptr %MEMORY, align 8
  %987 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %986, ptr %state, i64 %984, ptr %NEXT_PC, i64 %985, ptr %RETURN_PC)
  store ptr %987, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877430:                                    ; preds = %bb_5389877416
  %988 = load i64, ptr %NEXT_PC, align 8
  store i64 %988, ptr %PC, align 8
  %989 = add i64 %988, 3
  store i64 %989, ptr %NEXT_PC, align 8
  %990 = load i64, ptr %RBX, align 8
  %991 = load ptr, ptr %MEMORY, align 8
  %992 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %991, ptr %state, ptr %RCX, i64 %990)
  store ptr %992, ptr %MEMORY, align 8
  %993 = load i64, ptr %NEXT_PC, align 8
  store i64 %993, ptr %PC, align 8
  %994 = add i64 %993, 4
  store i64 %994, ptr %NEXT_PC, align 8
  %995 = load i64, ptr %RBP, align 8
  %996 = sub i64 %995, 48
  %997 = load i64, ptr %RCX, align 8
  %998 = load ptr, ptr %MEMORY, align 8
  %999 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %998, ptr %state, i64 %996, i64 %997)
  store ptr %999, ptr %MEMORY, align 8
  %1000 = load i64, ptr %NEXT_PC, align 8
  store i64 %1000, ptr %PC, align 8
  %1001 = add i64 %1000, 3
  store i64 %1001, ptr %NEXT_PC, align 8
  %1002 = load i64, ptr %RCX, align 8
  %1003 = load i64, ptr %RCX, align 8
  %1004 = load ptr, ptr %MEMORY, align 8
  %1005 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1004, ptr %state, i64 %1002, i64 %1003)
  store ptr %1005, ptr %MEMORY, align 8
  %1006 = load i64, ptr %NEXT_PC, align 8
  store i64 %1006, ptr %PC, align 8
  %1007 = add i64 %1006, 2
  store i64 %1007, ptr %NEXT_PC, align 8
  %1008 = load i64, ptr %NEXT_PC, align 8
  %1009 = add i64 %1008, 12
  %1010 = load i64, ptr %NEXT_PC, align 8
  %1011 = load ptr, ptr %MEMORY, align 8
  %1012 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1011, ptr %state, ptr %BRANCH_TAKEN, i64 %1009, i64 %1010, ptr %NEXT_PC)
  store ptr %1012, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877454, label %bb_5389877442

bb_5389877442:                                    ; preds = %bb_5389877430
  %1013 = load i64, ptr %NEXT_PC, align 8
  store i64 %1013, ptr %PC, align 8
  %1014 = add i64 %1013, 4
  store i64 %1014, ptr %NEXT_PC, align 8
  %1015 = load i64, ptr %RCX, align 8
  %1016 = add i64 %1015, 48
  %1017 = load ptr, ptr %MEMORY, align 8
  %1018 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1017, ptr %state, ptr %RAX, i64 %1016)
  store ptr %1018, ptr %MEMORY, align 8
  %1019 = load i64, ptr %NEXT_PC, align 8
  store i64 %1019, ptr %PC, align 8
  %1020 = add i64 %1019, 2
  store i64 %1020, ptr %NEXT_PC, align 8
  %1021 = load i64, ptr %RCX, align 8
  %1022 = load i64, ptr %RCX, align 8
  %1023 = load ptr, ptr %MEMORY, align 8
  %1024 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1023, ptr %state, i64 %1021, i64 %1022)
  store ptr %1024, ptr %MEMORY, align 8
  %1025 = load i64, ptr %NEXT_PC, align 8
  store i64 %1025, ptr %PC, align 8
  %1026 = add i64 %1025, 2
  store i64 %1026, ptr %NEXT_PC, align 8
  %1027 = load i64, ptr %RAX, align 8
  %1028 = load i64, ptr %RAX, align 8
  %1029 = load ptr, ptr %MEMORY, align 8
  %1030 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1029, ptr %state, i64 %1027, i64 %1028)
  store ptr %1030, ptr %MEMORY, align 8
  %1031 = load i64, ptr %NEXT_PC, align 8
  store i64 %1031, ptr %PC, align 8
  %1032 = add i64 %1031, 4
  store i64 %1032, ptr %NEXT_PC, align 8
  %1033 = load i64, ptr %RBP, align 8
  %1034 = sub i64 %1033, 48
  %1035 = load ptr, ptr %MEMORY, align 8
  %1036 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1035, ptr %state, ptr %RCX, i64 %1034)
  store ptr %1036, ptr %MEMORY, align 8
  br label %bb_5389877454

bb_5389877454:                                    ; preds = %bb_5389877442, %bb_5389877430
  %1037 = load i64, ptr %NEXT_PC, align 8
  store i64 %1037, ptr %PC, align 8
  %1038 = add i64 %1037, 4
  store i64 %1038, ptr %NEXT_PC, align 8
  %1039 = load i64, ptr %RBP, align 8
  %1040 = sub i64 %1039, 8
  %1041 = load ptr, ptr %MEMORY, align 8
  %1042 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1041, ptr %state, ptr %R9, i64 %1040)
  store ptr %1042, ptr %MEMORY, align 8
  br label %bb_5389877458

bb_5389877458:                                    ; preds = %bb_5389877454, %bb_5389877379, %bb_5389877363
  %1043 = load i64, ptr %NEXT_PC, align 8
  store i64 %1043, ptr %PC, align 8
  %1044 = add i64 %1043, 4
  store i64 %1044, ptr %NEXT_PC, align 8
  %1045 = load i64, ptr %RBP, align 8
  %1046 = add i64 %1045, 80
  %1047 = load ptr, ptr %MEMORY, align 8
  %1048 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1047, ptr %state, ptr %RAX, i64 %1046)
  store ptr %1048, ptr %MEMORY, align 8
  %1049 = load i64, ptr %NEXT_PC, align 8
  store i64 %1049, ptr %PC, align 8
  %1050 = add i64 %1049, 3
  store i64 %1050, ptr %NEXT_PC, align 8
  %1051 = load i64, ptr %RAX, align 8
  %1052 = load i64, ptr %RAX, align 8
  %1053 = load ptr, ptr %MEMORY, align 8
  %1054 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1053, ptr %state, i64 %1051, i64 %1052)
  store ptr %1054, ptr %MEMORY, align 8
  %1055 = load i64, ptr %NEXT_PC, align 8
  store i64 %1055, ptr %PC, align 8
  %1056 = add i64 %1055, 2
  store i64 %1056, ptr %NEXT_PC, align 8
  %1057 = load i64, ptr %NEXT_PC, align 8
  %1058 = add i64 %1057, 16
  %1059 = load i64, ptr %NEXT_PC, align 8
  %1060 = load ptr, ptr %MEMORY, align 8
  %1061 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1060, ptr %state, ptr %BRANCH_TAKEN, i64 %1058, i64 %1059, ptr %NEXT_PC)
  store ptr %1061, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877483, label %bb_5389877467

bb_5389877467:                                    ; preds = %bb_5389877458
  %1062 = load i64, ptr %NEXT_PC, align 8
  store i64 %1062, ptr %PC, align 8
  %1063 = add i64 %1062, 3
  store i64 %1063, ptr %NEXT_PC, align 8
  %1064 = load i64, ptr %RAX, align 8
  %1065 = load ptr, ptr %MEMORY, align 8
  %1066 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1065, ptr %state, ptr %RCX, i64 %1064)
  store ptr %1066, ptr %MEMORY, align 8
  %1067 = load i64, ptr %NEXT_PC, align 8
  store i64 %1067, ptr %PC, align 8
  %1068 = add i64 %1067, 5
  store i64 %1068, ptr %NEXT_PC, align 8
  %1069 = load i64, ptr %NEXT_PC, align 8
  %1070 = sub i64 %1069, 771
  %1071 = load i64, ptr %NEXT_PC, align 8
  %1072 = load ptr, ptr %MEMORY, align 8
  %1073 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1072, ptr %state, i64 %1070, ptr %NEXT_PC, i64 %1071, ptr %RETURN_PC)
  store ptr %1073, ptr %MEMORY, align 8
  %1074 = load i64, ptr %NEXT_PC, align 8
  store i64 %1074, ptr %PC, align 8
  %1075 = add i64 %1074, 4
  store i64 %1075, ptr %NEXT_PC, align 8
  %1076 = load i64, ptr %RBP, align 8
  %1077 = sub i64 %1076, 48
  %1078 = load ptr, ptr %MEMORY, align 8
  %1079 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1078, ptr %state, ptr %RCX, i64 %1077)
  store ptr %1079, ptr %MEMORY, align 8
  %1080 = load i64, ptr %NEXT_PC, align 8
  store i64 %1080, ptr %PC, align 8
  %1081 = add i64 %1080, 4
  store i64 %1081, ptr %NEXT_PC, align 8
  %1082 = load i64, ptr %RBP, align 8
  %1083 = sub i64 %1082, 8
  %1084 = load ptr, ptr %MEMORY, align 8
  %1085 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1084, ptr %state, ptr %R9, i64 %1083)
  store ptr %1085, ptr %MEMORY, align 8
  br label %bb_5389877483

bb_5389877483:                                    ; preds = %bb_5389877467, %bb_5389877458
  %1086 = load i64, ptr %NEXT_PC, align 8
  store i64 %1086, ptr %PC, align 8
  %1087 = add i64 %1086, 4
  store i64 %1087, ptr %NEXT_PC, align 8
  %1088 = load i64, ptr %RBP, align 8
  %1089 = add i64 %1088, 80
  %1090 = load i64, ptr %RCX, align 8
  %1091 = load ptr, ptr %MEMORY, align 8
  %1092 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1091, ptr %state, i64 %1089, i64 %1090)
  store ptr %1092, ptr %MEMORY, align 8
  %1093 = load i64, ptr %NEXT_PC, align 8
  store i64 %1093, ptr %PC, align 8
  %1094 = add i64 %1093, 3
  store i64 %1094, ptr %NEXT_PC, align 8
  %1095 = load i64, ptr %RCX, align 8
  %1096 = load i64, ptr %RCX, align 8
  %1097 = load ptr, ptr %MEMORY, align 8
  %1098 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1097, ptr %state, i64 %1095, i64 %1096)
  store ptr %1098, ptr %MEMORY, align 8
  %1099 = load i64, ptr %NEXT_PC, align 8
  store i64 %1099, ptr %PC, align 8
  %1100 = add i64 %1099, 2
  store i64 %1100, ptr %NEXT_PC, align 8
  %1101 = load i64, ptr %NEXT_PC, align 8
  %1102 = add i64 %1101, 9
  %1103 = load i64, ptr %NEXT_PC, align 8
  %1104 = load ptr, ptr %MEMORY, align 8
  %1105 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1104, ptr %state, ptr %BRANCH_TAKEN, i64 %1102, i64 %1103, ptr %NEXT_PC)
  store ptr %1105, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877501, label %bb_5389877492

bb_5389877492:                                    ; preds = %bb_5389877483
  %1106 = load i64, ptr %NEXT_PC, align 8
  store i64 %1106, ptr %PC, align 8
  %1107 = add i64 %1106, 5
  store i64 %1107, ptr %NEXT_PC, align 8
  %1108 = load i64, ptr %NEXT_PC, align 8
  %1109 = sub i64 %1108, 793
  %1110 = load i64, ptr %NEXT_PC, align 8
  %1111 = load ptr, ptr %MEMORY, align 8
  %1112 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1111, ptr %state, i64 %1109, ptr %NEXT_PC, i64 %1110, ptr %RETURN_PC)
  store ptr %1112, ptr %MEMORY, align 8
  %1113 = load i64, ptr %NEXT_PC, align 8
  store i64 %1113, ptr %PC, align 8
  %1114 = add i64 %1113, 4
  store i64 %1114, ptr %NEXT_PC, align 8
  %1115 = load i64, ptr %RBP, align 8
  %1116 = sub i64 %1115, 8
  %1117 = load ptr, ptr %MEMORY, align 8
  %1118 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1117, ptr %state, ptr %R9, i64 %1116)
  store ptr %1118, ptr %MEMORY, align 8
  br label %bb_5389877501

bb_5389877501:                                    ; preds = %bb_5389877492, %bb_5389877483
  %1119 = load i64, ptr %NEXT_PC, align 8
  store i64 %1119, ptr %PC, align 8
  %1120 = add i64 %1119, 3
  store i64 %1120, ptr %NEXT_PC, align 8
  %1121 = load i64, ptr %R9, align 8
  %1122 = load i64, ptr %R9, align 8
  %1123 = load ptr, ptr %MEMORY, align 8
  %1124 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1123, ptr %state, i64 %1121, i64 %1122)
  store ptr %1124, ptr %MEMORY, align 8
  %1125 = load i64, ptr %NEXT_PC, align 8
  store i64 %1125, ptr %PC, align 8
  %1126 = add i64 %1125, 2
  store i64 %1126, ptr %NEXT_PC, align 8
  %1127 = load i64, ptr %NEXT_PC, align 8
  %1128 = add i64 %1127, 13
  %1129 = load i64, ptr %NEXT_PC, align 8
  %1130 = load ptr, ptr %MEMORY, align 8
  %1131 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1130, ptr %state, ptr %BRANCH_TAKEN, i64 %1128, i64 %1129, ptr %NEXT_PC)
  store ptr %1131, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877519, label %bb_5389877506

bb_5389877506:                                    ; preds = %bb_5389877501
  %1132 = load i64, ptr %NEXT_PC, align 8
  store i64 %1132, ptr %PC, align 8
  %1133 = add i64 %1132, 3
  store i64 %1133, ptr %NEXT_PC, align 8
  %1134 = load i64, ptr %R9, align 8
  %1135 = load ptr, ptr %MEMORY, align 8
  %1136 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1135, ptr %state, ptr %RAX, i64 %1134)
  store ptr %1136, ptr %MEMORY, align 8
  %1137 = load i64, ptr %NEXT_PC, align 8
  store i64 %1137, ptr %PC, align 8
  %1138 = add i64 %1137, 4
  store i64 %1138, ptr %NEXT_PC, align 8
  %1139 = load i64, ptr %RBP, align 8
  %1140 = sub i64 %1139, 40
  %1141 = load ptr, ptr %MEMORY, align 8
  %1142 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %1141, ptr %state, ptr %RDX, i64 %1140)
  store ptr %1142, ptr %MEMORY, align 8
  %1143 = load i64, ptr %NEXT_PC, align 8
  store i64 %1143, ptr %PC, align 8
  %1144 = add i64 %1143, 3
  store i64 %1144, ptr %NEXT_PC, align 8
  %1145 = load i64, ptr %R9, align 8
  %1146 = load ptr, ptr %MEMORY, align 8
  %1147 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1146, ptr %state, ptr %RCX, i64 %1145)
  store ptr %1147, ptr %MEMORY, align 8
  %1148 = load i64, ptr %NEXT_PC, align 8
  store i64 %1148, ptr %PC, align 8
  %1149 = add i64 %1148, 3
  store i64 %1149, ptr %NEXT_PC, align 8
  %1150 = load i64, ptr %RAX, align 8
  %1151 = add i64 %1150, 24
  %1152 = load i64, ptr %NEXT_PC, align 8
  %1153 = load ptr, ptr %MEMORY, align 8
  %1154 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %1153, ptr %state, i64 %1151, ptr %NEXT_PC, i64 %1152, ptr %RETURN_PC)
  store ptr %1154, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877519:                                    ; preds = %bb_5389877501, %bb_5389877245
  %1155 = load i64, ptr %NEXT_PC, align 8
  store i64 %1155, ptr %PC, align 8
  %1156 = add i64 %1155, 6
  store i64 %1156, ptr %NEXT_PC, align 8
  %1157 = load i64, ptr %RSI, align 8
  %1158 = add i64 %1157, 256
  %1159 = load i64, ptr %RSI, align 8
  %1160 = add i64 %1159, 256
  %1161 = load ptr, ptr %MEMORY, align 8
  %1162 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1161, ptr %state, i64 %1158, i64 %1160)
  store ptr %1162, ptr %MEMORY, align 8
  %1163 = load i64, ptr %NEXT_PC, align 8
  store i64 %1163, ptr %PC, align 8
  %1164 = add i64 %1163, 4
  store i64 %1164, ptr %NEXT_PC, align 8
  %1165 = load i64, ptr %RBP, align 8
  %1166 = sub i64 %1165, 40
  %1167 = load ptr, ptr %MEMORY, align 8
  %1168 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %1167, ptr %state, ptr %RCX, i64 %1166)
  store ptr %1168, ptr %MEMORY, align 8
  %1169 = load i64, ptr %NEXT_PC, align 8
  store i64 %1169, ptr %PC, align 8
  %1170 = add i64 %1169, 3
  store i64 %1170, ptr %NEXT_PC, align 8
  %1171 = load i64, ptr %R15, align 8
  %1172 = load ptr, ptr %MEMORY, align 8
  %1173 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1172, ptr %state, ptr %RDX, i64 %1171)
  store ptr %1173, ptr %MEMORY, align 8
  %1174 = load i64, ptr %NEXT_PC, align 8
  store i64 %1174, ptr %PC, align 8
  %1175 = add i64 %1174, 4
  store i64 %1175, ptr %NEXT_PC, align 8
  %1176 = load i64, ptr %RBP, align 8
  %1177 = sub i64 %1176, 8
  %1178 = load i64, ptr %RDI, align 8
  %1179 = load ptr, ptr %MEMORY, align 8
  %1180 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1179, ptr %state, i64 %1177, i64 %1178)
  store ptr %1180, ptr %MEMORY, align 8
  %1181 = load i64, ptr %NEXT_PC, align 8
  store i64 %1181, ptr %PC, align 8
  %1182 = add i64 %1181, 5
  store i64 %1182, ptr %NEXT_PC, align 8
  %1183 = load i64, ptr %NEXT_PC, align 8
  %1184 = sub i64 %1183, 18801845
  %1185 = load i64, ptr %NEXT_PC, align 8
  %1186 = load ptr, ptr %MEMORY, align 8
  %1187 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1186, ptr %state, i64 %1184, ptr %NEXT_PC, i64 %1185, ptr %RETURN_PC)
  store ptr %1187, ptr %MEMORY, align 8
  %1188 = load i64, ptr %NEXT_PC, align 8
  store i64 %1188, ptr %PC, align 8
  %1189 = add i64 %1188, 4
  store i64 %1189, ptr %NEXT_PC, align 8
  %1190 = load i64, ptr %RBP, align 8
  %1191 = add i64 %1190, 80
  %1192 = load ptr, ptr %MEMORY, align 8
  %1193 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1192, ptr %state, ptr %RCX, i64 %1191)
  store ptr %1193, ptr %MEMORY, align 8
  %1194 = load i64, ptr %NEXT_PC, align 8
  store i64 %1194, ptr %PC, align 8
  %1195 = add i64 %1194, 4
  store i64 %1195, ptr %NEXT_PC, align 8
  %1196 = load i64, ptr %RBP, align 8
  %1197 = sub i64 %1196, 40
  %1198 = load ptr, ptr %MEMORY, align 8
  %1199 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %1198, ptr %state, ptr %RDX, i64 %1197)
  store ptr %1199, ptr %MEMORY, align 8
  %1200 = load i64, ptr %NEXT_PC, align 8
  store i64 %1200, ptr %PC, align 8
  %1201 = add i64 %1200, 3
  store i64 %1201, ptr %NEXT_PC, align 8
  %1202 = load i32, ptr %R13D, align 4
  %1203 = zext i32 %1202 to i64
  %1204 = load ptr, ptr %MEMORY, align 8
  %1205 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1204, ptr %state, ptr %R9, i64 %1203)
  store ptr %1205, ptr %MEMORY, align 8
  %1206 = load i64, ptr %NEXT_PC, align 8
  store i64 %1206, ptr %PC, align 8
  %1207 = add i64 %1206, 5
  store i64 %1207, ptr %NEXT_PC, align 8
  %1208 = load i64, ptr %RSP, align 8
  %1209 = add i64 %1208, 32
  %1210 = load i64, ptr %RSI, align 8
  %1211 = load ptr, ptr %MEMORY, align 8
  %1212 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1211, ptr %state, i64 %1209, i64 %1210)
  store ptr %1212, ptr %MEMORY, align 8
  %1213 = load i64, ptr %NEXT_PC, align 8
  store i64 %1213, ptr %PC, align 8
  %1214 = add i64 %1213, 3
  store i64 %1214, ptr %NEXT_PC, align 8
  %1215 = load i32, ptr %R12D, align 4
  %1216 = zext i32 %1215 to i64
  %1217 = load ptr, ptr %MEMORY, align 8
  %1218 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1217, ptr %state, ptr %R8, i64 %1216)
  store ptr %1218, ptr %MEMORY, align 8
  %1219 = load i64, ptr %NEXT_PC, align 8
  store i64 %1219, ptr %PC, align 8
  %1220 = add i64 %1219, 5
  store i64 %1220, ptr %NEXT_PC, align 8
  %1221 = load i64, ptr %NEXT_PC, align 8
  %1222 = sub i64 %1221, 685
  %1223 = load i64, ptr %NEXT_PC, align 8
  %1224 = load ptr, ptr %MEMORY, align 8
  %1225 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1224, ptr %state, i64 %1222, ptr %NEXT_PC, i64 %1223, ptr %RETURN_PC)
  store ptr %1225, ptr %MEMORY, align 8
  %1226 = load i64, ptr %NEXT_PC, align 8
  store i64 %1226, ptr %PC, align 8
  %1227 = add i64 %1226, 4
  store i64 %1227, ptr %NEXT_PC, align 8
  %1228 = load i64, ptr %RBP, align 8
  %1229 = add i64 %1228, 80
  %1230 = load ptr, ptr %MEMORY, align 8
  %1231 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1230, ptr %state, ptr %RCX, i64 %1229)
  store ptr %1231, ptr %MEMORY, align 8
  %1232 = load i64, ptr %NEXT_PC, align 8
  store i64 %1232, ptr %PC, align 8
  %1233 = add i64 %1232, 2
  store i64 %1233, ptr %NEXT_PC, align 8
  %1234 = load i32, ptr %EAX, align 4
  %1235 = zext i32 %1234 to i64
  %1236 = load ptr, ptr %MEMORY, align 8
  %1237 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1236, ptr %state, ptr %RBX, i64 %1235)
  store ptr %1237, ptr %MEMORY, align 8
  %1238 = load i64, ptr %NEXT_PC, align 8
  store i64 %1238, ptr %PC, align 8
  %1239 = add i64 %1238, 3
  store i64 %1239, ptr %NEXT_PC, align 8
  %1240 = load i64, ptr %RCX, align 8
  %1241 = load i64, ptr %RCX, align 8
  %1242 = load ptr, ptr %MEMORY, align 8
  %1243 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1242, ptr %state, i64 %1240, i64 %1241)
  store ptr %1243, ptr %MEMORY, align 8
  %1244 = load i64, ptr %NEXT_PC, align 8
  store i64 %1244, ptr %PC, align 8
  %1245 = add i64 %1244, 2
  store i64 %1245, ptr %NEXT_PC, align 8
  %1246 = load i64, ptr %NEXT_PC, align 8
  %1247 = add i64 %1246, 5
  %1248 = load i64, ptr %NEXT_PC, align 8
  %1249 = load ptr, ptr %MEMORY, align 8
  %1250 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1249, ptr %state, ptr %BRANCH_TAKEN, i64 %1247, i64 %1248, ptr %NEXT_PC)
  store ptr %1250, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877581, label %bb_5389877576

bb_5389877576:                                    ; preds = %bb_5389877519
  %1251 = load i64, ptr %NEXT_PC, align 8
  store i64 %1251, ptr %PC, align 8
  %1252 = add i64 %1251, 5
  store i64 %1252, ptr %NEXT_PC, align 8
  %1253 = load i64, ptr %NEXT_PC, align 8
  %1254 = sub i64 %1253, 877
  %1255 = load i64, ptr %NEXT_PC, align 8
  %1256 = load ptr, ptr %MEMORY, align 8
  %1257 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1256, ptr %state, i64 %1254, ptr %NEXT_PC, i64 %1255, ptr %RETURN_PC)
  store ptr %1257, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877581:                                    ; preds = %bb_5389877519
  %1258 = load i64, ptr %NEXT_PC, align 8
  store i64 %1258, ptr %PC, align 8
  %1259 = add i64 %1258, 4
  store i64 %1259, ptr %NEXT_PC, align 8
  %1260 = load i64, ptr %R15, align 8
  %1261 = add i64 %1260, 32
  %1262 = load ptr, ptr %MEMORY, align 8
  %1263 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1262, ptr %state, ptr %RCX, i64 %1261)
  store ptr %1263, ptr %MEMORY, align 8
  %1264 = load i64, ptr %NEXT_PC, align 8
  store i64 %1264, ptr %PC, align 8
  %1265 = add i64 %1264, 3
  store i64 %1265, ptr %NEXT_PC, align 8
  %1266 = load i64, ptr %RCX, align 8
  %1267 = load i64, ptr %RCX, align 8
  %1268 = load ptr, ptr %MEMORY, align 8
  %1269 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1268, ptr %state, i64 %1266, i64 %1267)
  store ptr %1269, ptr %MEMORY, align 8
  %1270 = load i64, ptr %NEXT_PC, align 8
  store i64 %1270, ptr %PC, align 8
  %1271 = add i64 %1270, 2
  store i64 %1271, ptr %NEXT_PC, align 8
  %1272 = load i64, ptr %NEXT_PC, align 8
  %1273 = add i64 %1272, 10
  %1274 = load i64, ptr %NEXT_PC, align 8
  %1275 = load ptr, ptr %MEMORY, align 8
  %1276 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1275, ptr %state, ptr %BRANCH_TAKEN, i64 %1273, i64 %1274, ptr %NEXT_PC)
  store ptr %1276, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877600, label %bb_5389877590

bb_5389877590:                                    ; preds = %bb_5389877581
  %1277 = load i64, ptr %NEXT_PC, align 8
  store i64 %1277, ptr %PC, align 8
  %1278 = add i64 %1277, 3
  store i64 %1278, ptr %NEXT_PC, align 8
  %1279 = load i64, ptr %RCX, align 8
  %1280 = load ptr, ptr %MEMORY, align 8
  %1281 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1280, ptr %state, ptr %R8, i64 %1279)
  store ptr %1281, ptr %MEMORY, align 8
  %1282 = load i64, ptr %NEXT_PC, align 8
  store i64 %1282, ptr %PC, align 8
  %1283 = add i64 %1282, 3
  store i64 %1283, ptr %NEXT_PC, align 8
  %1284 = load i64, ptr %R15, align 8
  %1285 = load ptr, ptr %MEMORY, align 8
  %1286 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1285, ptr %state, ptr %RDX, i64 %1284)
  store ptr %1286, ptr %MEMORY, align 8
  %1287 = load i64, ptr %NEXT_PC, align 8
  store i64 %1287, ptr %PC, align 8
  %1288 = add i64 %1287, 4
  store i64 %1288, ptr %NEXT_PC, align 8
  %1289 = load i64, ptr %R8, align 8
  %1290 = add i64 %1289, 24
  %1291 = load i64, ptr %NEXT_PC, align 8
  %1292 = load ptr, ptr %MEMORY, align 8
  %1293 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %1292, ptr %state, i64 %1290, ptr %NEXT_PC, i64 %1291, ptr %RETURN_PC)
  store ptr %1293, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877600:                                    ; preds = %bb_5389877581
  %1294 = load i64, ptr %NEXT_PC, align 8
  store i64 %1294, ptr %PC, align 8
  %1295 = add i64 %1294, 2
  store i64 %1295, ptr %NEXT_PC, align 8
  %1296 = load i32, ptr %EBX, align 4
  %1297 = zext i32 %1296 to i64
  %1298 = load ptr, ptr %MEMORY, align 8
  %1299 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1298, ptr %state, ptr %RAX, i64 %1297)
  store ptr %1299, ptr %MEMORY, align 8
  %1300 = load i64, ptr %NEXT_PC, align 8
  store i64 %1300, ptr %PC, align 8
  %1301 = add i64 %1300, 8
  store i64 %1301, ptr %NEXT_PC, align 8
  %1302 = load i64, ptr %RSP, align 8
  %1303 = add i64 %1302, 144
  %1304 = load ptr, ptr %MEMORY, align 8
  %1305 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1304, ptr %state, ptr %RBX, i64 %1303)
  store ptr %1305, ptr %MEMORY, align 8
  br label %bb_5389877610

bb_5389877610:                                    ; preds = %bb_5389877600, %bb_5389877027
  %1306 = load i64, ptr %NEXT_PC, align 8
  store i64 %1306, ptr %PC, align 8
  %1307 = add i64 %1306, 5
  store i64 %1307, ptr %NEXT_PC, align 8
  %1308 = load i64, ptr %RSP, align 8
  %1309 = add i64 %1308, 96
  %1310 = load ptr, ptr %MEMORY, align 8
  %1311 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %1310, ptr %state, ptr %R11, i64 %1309)
  store ptr %1311, ptr %MEMORY, align 8
  %1312 = load i64, ptr %NEXT_PC, align 8
  store i64 %1312, ptr %PC, align 8
  %1313 = add i64 %1312, 4
  store i64 %1313, ptr %NEXT_PC, align 8
  %1314 = load i64, ptr %R11, align 8
  %1315 = add i64 %1314, 56
  %1316 = load ptr, ptr %MEMORY, align 8
  %1317 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1316, ptr %state, ptr %RSI, i64 %1315)
  store ptr %1317, ptr %MEMORY, align 8
  %1318 = load i64, ptr %NEXT_PC, align 8
  store i64 %1318, ptr %PC, align 8
  %1319 = add i64 %1318, 4
  store i64 %1319, ptr %NEXT_PC, align 8
  %1320 = load i64, ptr %R11, align 8
  %1321 = add i64 %1320, 72
  %1322 = load ptr, ptr %MEMORY, align 8
  %1323 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1322, ptr %state, ptr %RDI, i64 %1321)
  store ptr %1323, ptr %MEMORY, align 8
  %1324 = load i64, ptr %NEXT_PC, align 8
  store i64 %1324, ptr %PC, align 8
  %1325 = add i64 %1324, 3
  store i64 %1325, ptr %NEXT_PC, align 8
  %1326 = load i64, ptr %R11, align 8
  %1327 = load ptr, ptr %MEMORY, align 8
  %1328 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1327, ptr %state, ptr %RSP, i64 %1326)
  store ptr %1328, ptr %MEMORY, align 8
  %1329 = load i64, ptr %NEXT_PC, align 8
  store i64 %1329, ptr %PC, align 8
  %1330 = add i64 %1329, 2
  store i64 %1330, ptr %NEXT_PC, align 8
  %1331 = load ptr, ptr %MEMORY, align 8
  %1332 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %1331, ptr %state, ptr %R15)
  store ptr %1332, ptr %MEMORY, align 8
  %1333 = load i64, ptr %NEXT_PC, align 8
  store i64 %1333, ptr %PC, align 8
  %1334 = add i64 %1333, 2
  store i64 %1334, ptr %NEXT_PC, align 8
  %1335 = load ptr, ptr %MEMORY, align 8
  %1336 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %1335, ptr %state, ptr %R14)
  store ptr %1336, ptr %MEMORY, align 8
  %1337 = load i64, ptr %NEXT_PC, align 8
  store i64 %1337, ptr %PC, align 8
  %1338 = add i64 %1337, 2
  store i64 %1338, ptr %NEXT_PC, align 8
  %1339 = load ptr, ptr %MEMORY, align 8
  %1340 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %1339, ptr %state, ptr %R13)
  store ptr %1340, ptr %MEMORY, align 8
  %1341 = load i64, ptr %NEXT_PC, align 8
  store i64 %1341, ptr %PC, align 8
  %1342 = add i64 %1341, 2
  store i64 %1342, ptr %NEXT_PC, align 8
  %1343 = load ptr, ptr %MEMORY, align 8
  %1344 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %1343, ptr %state, ptr %R12)
  store ptr %1344, ptr %MEMORY, align 8
  %1345 = load i64, ptr %NEXT_PC, align 8
  store i64 %1345, ptr %PC, align 8
  %1346 = add i64 %1345, 1
  store i64 %1346, ptr %NEXT_PC, align 8
  %1347 = load ptr, ptr %MEMORY, align 8
  %1348 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %1347, ptr %state, ptr %RBP)
  store ptr %1348, ptr %MEMORY, align 8
  %1349 = load i64, ptr %NEXT_PC, align 8
  store i64 %1349, ptr %PC, align 8
  %1350 = add i64 %1349, 1
  store i64 %1350, ptr %NEXT_PC, align 8
  %1351 = load ptr, ptr %MEMORY, align 8
  %1352 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %1351, ptr %state, ptr %NEXT_PC)
  store ptr %1352, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877636:                                    ; No predecessors!
  %1353 = load i64, ptr %NEXT_PC, align 8
  store i64 %1353, ptr %PC, align 8
  %1354 = add i64 %1353, 1
  store i64 %1354, ptr %NEXT_PC, align 8
  %1355 = load ptr, ptr %MEMORY, align 8
  %1356 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1355, ptr %state, ptr undef)
  store ptr %1356, ptr %MEMORY, align 8
  %1357 = load i64, ptr %NEXT_PC, align 8
  store i64 %1357, ptr %PC, align 8
  %1358 = add i64 %1357, 1
  store i64 %1358, ptr %NEXT_PC, align 8
  %1359 = load ptr, ptr %MEMORY, align 8
  %1360 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1359, ptr %state, ptr undef)
  store ptr %1360, ptr %MEMORY, align 8
  %1361 = load i64, ptr %NEXT_PC, align 8
  store i64 %1361, ptr %PC, align 8
  %1362 = add i64 %1361, 1
  store i64 %1362, ptr %NEXT_PC, align 8
  %1363 = load ptr, ptr %MEMORY, align 8
  %1364 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1363, ptr %state, ptr undef)
  store ptr %1364, ptr %MEMORY, align 8
  %1365 = load i64, ptr %NEXT_PC, align 8
  store i64 %1365, ptr %PC, align 8
  %1366 = add i64 %1365, 1
  store i64 %1366, ptr %NEXT_PC, align 8
  %1367 = load ptr, ptr %MEMORY, align 8
  %1368 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1367, ptr %state, ptr undef)
  store ptr %1368, ptr %MEMORY, align 8
  %1369 = load i64, ptr %NEXT_PC, align 8
  store i64 %1369, ptr %PC, align 8
  %1370 = add i64 %1369, 1
  store i64 %1370, ptr %NEXT_PC, align 8
  %1371 = load ptr, ptr %MEMORY, align 8
  %1372 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1371, ptr %state, ptr undef)
  store ptr %1372, ptr %MEMORY, align 8
  %1373 = load i64, ptr %NEXT_PC, align 8
  store i64 %1373, ptr %PC, align 8
  %1374 = add i64 %1373, 1
  store i64 %1374, ptr %NEXT_PC, align 8
  %1375 = load ptr, ptr %MEMORY, align 8
  %1376 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1375, ptr %state, ptr undef)
  store ptr %1376, ptr %MEMORY, align 8
  %1377 = load i64, ptr %NEXT_PC, align 8
  store i64 %1377, ptr %PC, align 8
  %1378 = add i64 %1377, 1
  store i64 %1378, ptr %NEXT_PC, align 8
  %1379 = load ptr, ptr %MEMORY, align 8
  %1380 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1379, ptr %state, ptr undef)
  store ptr %1380, ptr %MEMORY, align 8
  %1381 = load i64, ptr %NEXT_PC, align 8
  store i64 %1381, ptr %PC, align 8
  %1382 = add i64 %1381, 1
  store i64 %1382, ptr %NEXT_PC, align 8
  %1383 = load ptr, ptr %MEMORY, align 8
  %1384 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1383, ptr %state, ptr undef)
  store ptr %1384, ptr %MEMORY, align 8
  %1385 = load i64, ptr %NEXT_PC, align 8
  store i64 %1385, ptr %PC, align 8
  %1386 = add i64 %1385, 1
  store i64 %1386, ptr %NEXT_PC, align 8
  %1387 = load ptr, ptr %MEMORY, align 8
  %1388 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1387, ptr %state, ptr undef)
  store ptr %1388, ptr %MEMORY, align 8
  %1389 = load i64, ptr %NEXT_PC, align 8
  store i64 %1389, ptr %PC, align 8
  %1390 = add i64 %1389, 1
  store i64 %1390, ptr %NEXT_PC, align 8
  %1391 = load ptr, ptr %MEMORY, align 8
  %1392 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1391, ptr %state, ptr undef)
  store ptr %1392, ptr %MEMORY, align 8
  %1393 = load i64, ptr %NEXT_PC, align 8
  store i64 %1393, ptr %PC, align 8
  %1394 = add i64 %1393, 1
  store i64 %1394, ptr %NEXT_PC, align 8
  %1395 = load ptr, ptr %MEMORY, align 8
  %1396 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1395, ptr %state, ptr undef)
  store ptr %1396, ptr %MEMORY, align 8
  %1397 = load i64, ptr %NEXT_PC, align 8
  store i64 %1397, ptr %PC, align 8
  %1398 = add i64 %1397, 1
  store i64 %1398, ptr %NEXT_PC, align 8
  %1399 = load ptr, ptr %MEMORY, align 8
  %1400 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %1399, ptr %state, ptr undef)
  store ptr %1400, ptr %MEMORY, align 8
  %1401 = load i64, ptr %NEXT_PC, align 8
  store i64 %1401, ptr %PC, align 8
  %1402 = add i64 %1401, 5
  store i64 %1402, ptr %NEXT_PC, align 8
  %1403 = load i64, ptr %RSP, align 8
  %1404 = add i64 %1403, 16
  %1405 = load i64, ptr %RBX, align 8
  %1406 = load ptr, ptr %MEMORY, align 8
  %1407 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1406, ptr %state, i64 %1404, i64 %1405)
  store ptr %1407, ptr %MEMORY, align 8
  %1408 = load i64, ptr %NEXT_PC, align 8
  store i64 %1408, ptr %PC, align 8
  %1409 = add i64 %1408, 5
  store i64 %1409, ptr %NEXT_PC, align 8
  %1410 = load i64, ptr %RSP, align 8
  %1411 = add i64 %1410, 32
  %1412 = load i64, ptr %RBP, align 8
  %1413 = load ptr, ptr %MEMORY, align 8
  %1414 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1413, ptr %state, i64 %1411, i64 %1412)
  store ptr %1414, ptr %MEMORY, align 8
  %1415 = load i64, ptr %NEXT_PC, align 8
  store i64 %1415, ptr %PC, align 8
  %1416 = add i64 %1415, 1
  store i64 %1416, ptr %NEXT_PC, align 8
  %1417 = load i64, ptr %RDI, align 8
  %1418 = load ptr, ptr %MEMORY, align 8
  %1419 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %1418, ptr %state, i64 %1417)
  store ptr %1419, ptr %MEMORY, align 8
  %1420 = load i64, ptr %NEXT_PC, align 8
  store i64 %1420, ptr %PC, align 8
  %1421 = add i64 %1420, 4
  store i64 %1421, ptr %NEXT_PC, align 8
  %1422 = load i64, ptr %RSP, align 8
  %1423 = load ptr, ptr %MEMORY, align 8
  %1424 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1423, ptr %state, ptr %RSP, i64 %1422, i64 80)
  store ptr %1424, ptr %MEMORY, align 8
  %1425 = load i64, ptr %NEXT_PC, align 8
  store i64 %1425, ptr %PC, align 8
  %1426 = add i64 %1425, 7
  store i64 %1426, ptr %NEXT_PC, align 8
  %1427 = load i64, ptr %R8, align 8
  %1428 = add i64 %1427, 256
  %1429 = load ptr, ptr %MEMORY, align 8
  %1430 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1429, ptr %state, ptr %RAX, i64 %1428)
  store ptr %1430, ptr %MEMORY, align 8
  %1431 = load i64, ptr %NEXT_PC, align 8
  store i64 %1431, ptr %PC, align 8
  %1432 = add i64 %1431, 3
  store i64 %1432, ptr %NEXT_PC, align 8
  %1433 = load i64, ptr %R8, align 8
  %1434 = load ptr, ptr %MEMORY, align 8
  %1435 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1434, ptr %state, ptr %RDI, i64 %1433)
  store ptr %1435, ptr %MEMORY, align 8
  %1436 = load i64, ptr %NEXT_PC, align 8
  store i64 %1436, ptr %PC, align 8
  %1437 = add i64 %1436, 2
  store i64 %1437, ptr %NEXT_PC, align 8
  %1438 = load i32, ptr %EDX, align 4
  %1439 = zext i32 %1438 to i64
  %1440 = load ptr, ptr %MEMORY, align 8
  %1441 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1440, ptr %state, ptr %RBP, i64 %1439)
  store ptr %1441, ptr %MEMORY, align 8
  %1442 = load i64, ptr %NEXT_PC, align 8
  store i64 %1442, ptr %PC, align 8
  %1443 = add i64 %1442, 3
  store i64 %1443, ptr %NEXT_PC, align 8
  %1444 = load i64, ptr %RCX, align 8
  %1445 = load ptr, ptr %MEMORY, align 8
  %1446 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1445, ptr %state, ptr %RBX, i64 %1444)
  store ptr %1446, ptr %MEMORY, align 8
  %1447 = load i64, ptr %NEXT_PC, align 8
  store i64 %1447, ptr %PC, align 8
  %1448 = add i64 %1447, 2
  store i64 %1448, ptr %NEXT_PC, align 8
  %1449 = load i32, ptr %EAX, align 4
  %1450 = zext i32 %1449 to i64
  %1451 = load i32, ptr %EAX, align 4
  %1452 = zext i32 %1451 to i64
  %1453 = load ptr, ptr %MEMORY, align 8
  %1454 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1453, ptr %state, i64 %1450, i64 %1452)
  store ptr %1454, ptr %MEMORY, align 8
  %1455 = load i64, ptr %NEXT_PC, align 8
  store i64 %1455, ptr %PC, align 8
  %1456 = add i64 %1455, 6
  store i64 %1456, ptr %NEXT_PC, align 8
  %1457 = load i64, ptr %NEXT_PC, align 8
  %1458 = add i64 %1457, 318
  %1459 = load i64, ptr %NEXT_PC, align 8
  %1460 = load ptr, ptr %MEMORY, align 8
  %1461 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1460, ptr %state, ptr %BRANCH_TAKEN, i64 %1458, i64 %1459, ptr %NEXT_PC)
  store ptr %1461, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878004, label %bb_5389877686

bb_5389877686:                                    ; preds = %bb_5389877636
  %1462 = load i64, ptr %NEXT_PC, align 8
  store i64 %1462, ptr %PC, align 8
  %1463 = add i64 %1462, 2
  store i64 %1463, ptr %NEXT_PC, align 8
  %1464 = load i64, ptr %RAX, align 8
  %1465 = load ptr, ptr %MEMORY, align 8
  %1466 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1465, ptr %state, ptr %RAX, i64 %1464)
  store ptr %1466, ptr %MEMORY, align 8
  %1467 = load i64, ptr %NEXT_PC, align 8
  store i64 %1467, ptr %PC, align 8
  %1468 = add i64 %1467, 3
  store i64 %1468, ptr %NEXT_PC, align 8
  %1469 = load i32, ptr %EAX, align 4
  %1470 = zext i32 %1469 to i64
  %1471 = load ptr, ptr %MEMORY, align 8
  %1472 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %1471, ptr %state, ptr %RDX, i64 %1470)
  store ptr %1472, ptr %MEMORY, align 8
  %1473 = load i64, ptr %NEXT_PC, align 8
  store i64 %1473, ptr %PC, align 8
  %1474 = add i64 %1473, 4
  store i64 %1474, ptr %NEXT_PC, align 8
  %1475 = load i64, ptr %R8, align 8
  %1476 = load i64, ptr %RDX, align 8
  %1477 = mul i64 %1476, 4
  %1478 = add i64 %1475, %1477
  %1479 = load ptr, ptr %MEMORY, align 8
  %1480 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1479, ptr %state, ptr %RDX, i64 %1478)
  store ptr %1480, ptr %MEMORY, align 8
  %1481 = load i64, ptr %NEXT_PC, align 8
  store i64 %1481, ptr %PC, align 8
  %1482 = add i64 %1481, 5
  store i64 %1482, ptr %NEXT_PC, align 8
  %1483 = load i64, ptr %NEXT_PC, align 8
  %1484 = add i64 %1483, 5836
  %1485 = load i64, ptr %NEXT_PC, align 8
  %1486 = load ptr, ptr %MEMORY, align 8
  %1487 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1486, ptr %state, i64 %1484, ptr %NEXT_PC, i64 %1485, ptr %RETURN_PC)
  store ptr %1487, ptr %MEMORY, align 8
  %1488 = load i64, ptr %NEXT_PC, align 8
  store i64 %1488, ptr %PC, align 8
  %1489 = add i64 %1488, 3
  store i64 %1489, ptr %NEXT_PC, align 8
  %1490 = load i32, ptr %EAX, align 4
  %1491 = zext i32 %1490 to i64
  %1492 = load ptr, ptr %MEMORY, align 8
  %1493 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %1492, ptr %state, i64 %1491, i64 -1)
  store ptr %1493, ptr %MEMORY, align 8
  %1494 = load i64, ptr %NEXT_PC, align 8
  store i64 %1494, ptr %PC, align 8
  %1495 = add i64 %1494, 6
  store i64 %1495, ptr %NEXT_PC, align 8
  %1496 = load i64, ptr %NEXT_PC, align 8
  %1497 = add i64 %1496, 295
  %1498 = load i64, ptr %NEXT_PC, align 8
  %1499 = load ptr, ptr %MEMORY, align 8
  %1500 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1499, ptr %state, ptr %BRANCH_TAKEN, i64 %1497, i64 %1498, ptr %NEXT_PC)
  store ptr %1500, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878004, label %bb_5389877709

bb_5389877709:                                    ; preds = %bb_5389877686
  %1501 = load i64, ptr %NEXT_PC, align 8
  store i64 %1501, ptr %PC, align 8
  %1502 = add i64 %1501, 7
  store i64 %1502, ptr %NEXT_PC, align 8
  %1503 = load i64, ptr %RDI, align 8
  %1504 = add i64 %1503, 256
  %1505 = load ptr, ptr %MEMORY, align 8
  %1506 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %1505, ptr %state, i64 %1504, i64 1)
  store ptr %1506, ptr %MEMORY, align 8
  %1507 = load i64, ptr %NEXT_PC, align 8
  store i64 %1507, ptr %PC, align 8
  %1508 = add i64 %1507, 2
  store i64 %1508, ptr %NEXT_PC, align 8
  %1509 = load i64, ptr %NEXT_PC, align 8
  %1510 = add i64 %1509, 31
  %1511 = load i64, ptr %NEXT_PC, align 8
  %1512 = load ptr, ptr %MEMORY, align 8
  %1513 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1512, ptr %state, ptr %BRANCH_TAKEN, i64 %1510, i64 %1511, ptr %NEXT_PC)
  store ptr %1513, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877749, label %bb_5389877718

bb_5389877718:                                    ; preds = %bb_5389877709
  %1514 = load i64, ptr %NEXT_PC, align 8
  store i64 %1514, ptr %PC, align 8
  %1515 = add i64 %1514, 2
  store i64 %1515, ptr %NEXT_PC, align 8
  %1516 = load i32, ptr %EAX, align 4
  %1517 = zext i32 %1516 to i64
  %1518 = load ptr, ptr %MEMORY, align 8
  %1519 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1518, ptr %state, ptr %RDX, i64 %1517)
  store ptr %1519, ptr %MEMORY, align 8
  %1520 = load i64, ptr %NEXT_PC, align 8
  store i64 %1520, ptr %PC, align 8
  %1521 = add i64 %1520, 3
  store i64 %1521, ptr %NEXT_PC, align 8
  %1522 = load i64, ptr %RBX, align 8
  %1523 = load ptr, ptr %MEMORY, align 8
  %1524 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1523, ptr %state, ptr %RCX, i64 %1522)
  store ptr %1524, ptr %MEMORY, align 8
  %1525 = load i64, ptr %NEXT_PC, align 8
  store i64 %1525, ptr %PC, align 8
  %1526 = add i64 %1525, 5
  store i64 %1526, ptr %NEXT_PC, align 8
  %1527 = load i64, ptr %NEXT_PC, align 8
  %1528 = add i64 %1527, 4848
  %1529 = load i64, ptr %NEXT_PC, align 8
  %1530 = load ptr, ptr %MEMORY, align 8
  %1531 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1530, ptr %state, i64 %1528, ptr %NEXT_PC, i64 %1529, ptr %RETURN_PC)
  store ptr %1531, ptr %MEMORY, align 8
  %1532 = load i64, ptr %NEXT_PC, align 8
  store i64 %1532, ptr %PC, align 8
  %1533 = add i64 %1532, 5
  store i64 %1533, ptr %NEXT_PC, align 8
  %1534 = load ptr, ptr %MEMORY, align 8
  %1535 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %1534, ptr %state, ptr %RAX, i64 1)
  store ptr %1535, ptr %MEMORY, align 8
  %1536 = load i64, ptr %NEXT_PC, align 8
  store i64 %1536, ptr %PC, align 8
  %1537 = add i64 %1536, 5
  store i64 %1537, ptr %NEXT_PC, align 8
  %1538 = load i64, ptr %RSP, align 8
  %1539 = add i64 %1538, 104
  %1540 = load ptr, ptr %MEMORY, align 8
  %1541 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1540, ptr %state, ptr %RBX, i64 %1539)
  store ptr %1541, ptr %MEMORY, align 8
  %1542 = load i64, ptr %NEXT_PC, align 8
  store i64 %1542, ptr %PC, align 8
  %1543 = add i64 %1542, 5
  store i64 %1543, ptr %NEXT_PC, align 8
  %1544 = load i64, ptr %RSP, align 8
  %1545 = add i64 %1544, 120
  %1546 = load ptr, ptr %MEMORY, align 8
  %1547 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1546, ptr %state, ptr %RBP, i64 %1545)
  store ptr %1547, ptr %MEMORY, align 8
  %1548 = load i64, ptr %NEXT_PC, align 8
  store i64 %1548, ptr %PC, align 8
  %1549 = add i64 %1548, 4
  store i64 %1549, ptr %NEXT_PC, align 8
  %1550 = load i64, ptr %RSP, align 8
  %1551 = load ptr, ptr %MEMORY, align 8
  %1552 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1551, ptr %state, ptr %RSP, i64 %1550, i64 80)
  store ptr %1552, ptr %MEMORY, align 8
  %1553 = load i64, ptr %NEXT_PC, align 8
  store i64 %1553, ptr %PC, align 8
  %1554 = add i64 %1553, 1
  store i64 %1554, ptr %NEXT_PC, align 8
  %1555 = load ptr, ptr %MEMORY, align 8
  %1556 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %1555, ptr %state, ptr %RDI)
  store ptr %1556, ptr %MEMORY, align 8
  %1557 = load i64, ptr %NEXT_PC, align 8
  store i64 %1557, ptr %PC, align 8
  %1558 = add i64 %1557, 1
  store i64 %1558, ptr %NEXT_PC, align 8
  %1559 = load ptr, ptr %MEMORY, align 8
  %1560 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %1559, ptr %state, ptr %NEXT_PC)
  store ptr %1560, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877749:                                    ; preds = %bb_5389877709
  %1561 = load i64, ptr %NEXT_PC, align 8
  store i64 %1561, ptr %PC, align 8
  %1562 = add i64 %1561, 2
  store i64 %1562, ptr %NEXT_PC, align 8
  %1563 = load i32, ptr %EAX, align 4
  %1564 = zext i32 %1563 to i64
  %1565 = load i32, ptr %EAX, align 4
  %1566 = zext i32 %1565 to i64
  %1567 = load ptr, ptr %MEMORY, align 8
  %1568 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1567, ptr %state, i64 %1564, i64 %1566)
  store ptr %1568, ptr %MEMORY, align 8
  %1569 = load i64, ptr %NEXT_PC, align 8
  store i64 %1569, ptr %PC, align 8
  %1570 = add i64 %1569, 2
  store i64 %1570, ptr %NEXT_PC, align 8
  %1571 = load i64, ptr %NEXT_PC, align 8
  %1572 = add i64 %1571, 64
  %1573 = load i64, ptr %NEXT_PC, align 8
  %1574 = load ptr, ptr %MEMORY, align 8
  %1575 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1574, ptr %state, ptr %BRANCH_TAKEN, i64 %1572, i64 %1573, ptr %NEXT_PC)
  store ptr %1575, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877817, label %bb_5389877753

bb_5389877753:                                    ; preds = %bb_5389877749
  %1576 = load i64, ptr %NEXT_PC, align 8
  store i64 %1576, ptr %PC, align 8
  %1577 = add i64 %1576, 3
  store i64 %1577, ptr %NEXT_PC, align 8
  %1578 = load i32, ptr %EAX, align 4
  %1579 = zext i32 %1578 to i64
  %1580 = load i64, ptr %RBX, align 8
  %1581 = add i64 %1580, 40
  %1582 = load ptr, ptr %MEMORY, align 8
  %1583 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1582, ptr %state, i64 %1579, i64 %1581)
  store ptr %1583, ptr %MEMORY, align 8
  %1584 = load i64, ptr %NEXT_PC, align 8
  store i64 %1584, ptr %PC, align 8
  %1585 = add i64 %1584, 2
  store i64 %1585, ptr %NEXT_PC, align 8
  %1586 = load i64, ptr %NEXT_PC, align 8
  %1587 = add i64 %1586, 59
  %1588 = load i64, ptr %NEXT_PC, align 8
  %1589 = load ptr, ptr %MEMORY, align 8
  %1590 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1589, ptr %state, ptr %BRANCH_TAKEN, i64 %1587, i64 %1588, ptr %NEXT_PC)
  store ptr %1590, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877817, label %bb_5389877758

bb_5389877758:                                    ; preds = %bb_5389877753
  %1591 = load i64, ptr %NEXT_PC, align 8
  store i64 %1591, ptr %PC, align 8
  %1592 = add i64 %1591, 4
  store i64 %1592, ptr %NEXT_PC, align 8
  %1593 = load i64, ptr %RBX, align 8
  %1594 = add i64 %1593, 32
  %1595 = load ptr, ptr %MEMORY, align 8
  %1596 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1595, ptr %state, ptr %R8, i64 %1594)
  store ptr %1596, ptr %MEMORY, align 8
  %1597 = load i64, ptr %NEXT_PC, align 8
  store i64 %1597, ptr %PC, align 8
  %1598 = add i64 %1597, 2
  store i64 %1598, ptr %NEXT_PC, align 8
  %1599 = load i64, ptr %RBX, align 8
  %1600 = load i32, ptr %EBX, align 4
  %1601 = zext i32 %1600 to i64
  %1602 = load ptr, ptr %MEMORY, align 8
  %1603 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %1602, ptr %state, ptr %RBX, i64 %1599, i64 %1601)
  store ptr %1603, ptr %MEMORY, align 8
  %1604 = load i64, ptr %NEXT_PC, align 8
  store i64 %1604, ptr %PC, align 8
  %1605 = add i64 %1604, 4
  store i64 %1605, ptr %NEXT_PC, align 8
  %1606 = load i64, ptr %R8, align 8
  %1607 = load ptr, ptr %MEMORY, align 8
  %1608 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1607, ptr %state, ptr %R8, i64 %1606, i64 8)
  store ptr %1608, ptr %MEMORY, align 8
  %1609 = load i64, ptr %NEXT_PC, align 8
  store i64 %1609, ptr %PC, align 8
  %1610 = add i64 %1609, 2
  store i64 %1610, ptr %NEXT_PC, align 8
  %1611 = load ptr, ptr %MEMORY, align 8
  %1612 = call ptr @_ZN12_GLOBAL__N_18CDQE_EAXEP6MemoryR5State(ptr %1611, ptr %state)
  store ptr %1612, ptr %MEMORY, align 8
  %1613 = load i64, ptr %NEXT_PC, align 8
  store i64 %1613, ptr %PC, align 8
  %1614 = add i64 %1613, 4
  store i64 %1614, ptr %NEXT_PC, align 8
  %1615 = load i64, ptr %RAX, align 8
  %1616 = load ptr, ptr %MEMORY, align 8
  %1617 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %1616, ptr %state, ptr %RCX, i64 %1615, i64 56)
  store ptr %1617, ptr %MEMORY, align 8
  %1618 = load i64, ptr %NEXT_PC, align 8
  store i64 %1618, ptr %PC, align 8
  %1619 = add i64 %1618, 5
  store i64 %1619, ptr %NEXT_PC, align 8
  %1620 = load i64, ptr %RSP, align 8
  %1621 = add i64 %1620, 64
  %1622 = load i64, ptr %RBX, align 8
  %1623 = load ptr, ptr %MEMORY, align 8
  %1624 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1623, ptr %state, i64 %1621, i64 %1622)
  store ptr %1624, ptr %MEMORY, align 8
  %1625 = load i64, ptr %NEXT_PC, align 8
  store i64 %1625, ptr %PC, align 8
  %1626 = add i64 %1625, 3
  store i64 %1626, ptr %NEXT_PC, align 8
  %1627 = load i32, ptr %EBX, align 4
  %1628 = zext i32 %1627 to i64
  %1629 = load ptr, ptr %MEMORY, align 8
  %1630 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1629, ptr %state, ptr %R9, i64 %1628)
  store ptr %1630, ptr %MEMORY, align 8
  %1631 = load i64, ptr %NEXT_PC, align 8
  store i64 %1631, ptr %PC, align 8
  %1632 = add i64 %1631, 3
  store i64 %1632, ptr %NEXT_PC, align 8
  %1633 = load i64, ptr %R8, align 8
  %1634 = load i64, ptr %RCX, align 8
  %1635 = load ptr, ptr %MEMORY, align 8
  %1636 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %1635, ptr %state, ptr %R8, i64 %1633, i64 %1634)
  store ptr %1636, ptr %MEMORY, align 8
  %1637 = load i64, ptr %NEXT_PC, align 8
  store i64 %1637, ptr %PC, align 8
  %1638 = add i64 %1637, 4
  store i64 %1638, ptr %NEXT_PC, align 8
  %1639 = load i64, ptr %R8, align 8
  %1640 = add i64 %1639, 32
  %1641 = load ptr, ptr %MEMORY, align 8
  %1642 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1641, ptr %state, ptr %RCX, i64 %1640)
  store ptr %1642, ptr %MEMORY, align 8
  %1643 = load i64, ptr %NEXT_PC, align 8
  store i64 %1643, ptr %PC, align 8
  %1644 = add i64 %1643, 3
  store i64 %1644, ptr %NEXT_PC, align 8
  %1645 = load i64, ptr %RCX, align 8
  %1646 = load i64, ptr %RCX, align 8
  %1647 = load ptr, ptr %MEMORY, align 8
  %1648 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1647, ptr %state, i64 %1645, i64 %1646)
  store ptr %1648, ptr %MEMORY, align 8
  %1649 = load i64, ptr %NEXT_PC, align 8
  store i64 %1649, ptr %PC, align 8
  %1650 = add i64 %1649, 2
  store i64 %1650, ptr %NEXT_PC, align 8
  %1651 = load i64, ptr %NEXT_PC, align 8
  %1652 = add i64 %1651, 33
  %1653 = load i64, ptr %NEXT_PC, align 8
  %1654 = load ptr, ptr %MEMORY, align 8
  %1655 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1654, ptr %state, ptr %BRANCH_TAKEN, i64 %1652, i64 %1653, ptr %NEXT_PC)
  store ptr %1655, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877827, label %bb_5389877794

bb_5389877794:                                    ; preds = %bb_5389877758
  %1656 = load i64, ptr %NEXT_PC, align 8
  store i64 %1656, ptr %PC, align 8
  %1657 = add i64 %1656, 5
  store i64 %1657, ptr %NEXT_PC, align 8
  %1658 = load i64, ptr %RSP, align 8
  %1659 = add i64 %1658, 64
  %1660 = load i64, ptr %RCX, align 8
  %1661 = load ptr, ptr %MEMORY, align 8
  %1662 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1661, ptr %state, i64 %1659, i64 %1660)
  store ptr %1662, ptr %MEMORY, align 8
  %1663 = load i64, ptr %NEXT_PC, align 8
  store i64 %1663, ptr %PC, align 8
  %1664 = add i64 %1663, 5
  store i64 %1664, ptr %NEXT_PC, align 8
  %1665 = load i64, ptr %RSP, align 8
  %1666 = add i64 %1665, 32
  %1667 = load ptr, ptr %MEMORY, align 8
  %1668 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %1667, ptr %state, ptr %RDX, i64 %1666)
  store ptr %1668, ptr %MEMORY, align 8
  %1669 = load i64, ptr %NEXT_PC, align 8
  store i64 %1669, ptr %PC, align 8
  %1670 = add i64 %1669, 3
  store i64 %1670, ptr %NEXT_PC, align 8
  %1671 = load i64, ptr %RCX, align 8
  %1672 = load ptr, ptr %MEMORY, align 8
  %1673 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1672, ptr %state, ptr %RAX, i64 %1671)
  store ptr %1673, ptr %MEMORY, align 8
  %1674 = load i64, ptr %NEXT_PC, align 8
  store i64 %1674, ptr %PC, align 8
  %1675 = add i64 %1674, 3
  store i64 %1675, ptr %NEXT_PC, align 8
  %1676 = load i64, ptr %RAX, align 8
  %1677 = add i64 %1676, 8
  %1678 = load i64, ptr %NEXT_PC, align 8
  %1679 = load ptr, ptr %MEMORY, align 8
  %1680 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %1679, ptr %state, i64 %1677, ptr %NEXT_PC, i64 %1678, ptr %RETURN_PC)
  store ptr %1680, ptr %MEMORY, align 8
  %1681 = load i64, ptr %NEXT_PC, align 8
  store i64 %1681, ptr %PC, align 8
  %1682 = add i64 %1681, 5
  store i64 %1682, ptr %NEXT_PC, align 8
  %1683 = load i64, ptr %RSP, align 8
  %1684 = add i64 %1683, 64
  %1685 = load ptr, ptr %MEMORY, align 8
  %1686 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1685, ptr %state, ptr %R9, i64 %1684)
  store ptr %1686, ptr %MEMORY, align 8
  %1687 = load i64, ptr %NEXT_PC, align 8
  store i64 %1687, ptr %PC, align 8
  %1688 = add i64 %1687, 2
  store i64 %1688, ptr %NEXT_PC, align 8
  %1689 = load i64, ptr %NEXT_PC, align 8
  %1690 = add i64 %1689, 10
  %1691 = load ptr, ptr %MEMORY, align 8
  %1692 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %1691, ptr %state, i64 %1690, ptr %NEXT_PC)
  store ptr %1692, ptr %MEMORY, align 8
  br label %bb_5389877827

bb_5389877817:                                    ; preds = %bb_5389877753, %bb_5389877749
  %1693 = load i64, ptr %NEXT_PC, align 8
  store i64 %1693, ptr %PC, align 8
  %1694 = add i64 %1693, 2
  store i64 %1694, ptr %NEXT_PC, align 8
  %1695 = load i64, ptr %RBX, align 8
  %1696 = load i32, ptr %EBX, align 4
  %1697 = zext i32 %1696 to i64
  %1698 = load ptr, ptr %MEMORY, align 8
  %1699 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %1698, ptr %state, ptr %RBX, i64 %1695, i64 %1697)
  store ptr %1699, ptr %MEMORY, align 8
  %1700 = load i64, ptr %NEXT_PC, align 8
  store i64 %1700, ptr %PC, align 8
  %1701 = add i64 %1700, 3
  store i64 %1701, ptr %NEXT_PC, align 8
  %1702 = load i32, ptr %EBX, align 4
  %1703 = zext i32 %1702 to i64
  %1704 = load ptr, ptr %MEMORY, align 8
  %1705 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1704, ptr %state, ptr %R9, i64 %1703)
  store ptr %1705, ptr %MEMORY, align 8
  %1706 = load i64, ptr %NEXT_PC, align 8
  store i64 %1706, ptr %PC, align 8
  %1707 = add i64 %1706, 5
  store i64 %1707, ptr %NEXT_PC, align 8
  %1708 = load i64, ptr %RSP, align 8
  %1709 = add i64 %1708, 64
  %1710 = load i64, ptr %RBX, align 8
  %1711 = load ptr, ptr %MEMORY, align 8
  %1712 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1711, ptr %state, i64 %1709, i64 %1710)
  store ptr %1712, ptr %MEMORY, align 8
  br label %bb_5389877827

bb_5389877827:                                    ; preds = %bb_5389877817, %bb_5389877794, %bb_5389877758
  %1713 = load i64, ptr %NEXT_PC, align 8
  store i64 %1713, ptr %PC, align 8
  %1714 = add i64 %1713, 7
  store i64 %1714, ptr %NEXT_PC, align 8
  %1715 = load i64, ptr %R9, align 8
  %1716 = load i64, ptr %NEXT_PC, align 8
  %1717 = add i64 %1716, 27073638
  %1718 = load ptr, ptr %MEMORY, align 8
  %1719 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1718, ptr %state, i64 %1715, i64 %1717)
  store ptr %1719, ptr %MEMORY, align 8
  %1720 = load i64, ptr %NEXT_PC, align 8
  store i64 %1720, ptr %PC, align 8
  %1721 = add i64 %1720, 3
  store i64 %1721, ptr %NEXT_PC, align 8
  %1722 = load i64, ptr %RBX, align 8
  %1723 = load ptr, ptr %MEMORY, align 8
  %1724 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1723, ptr %state, ptr %RCX, i64 %1722)
  store ptr %1724, ptr %MEMORY, align 8
  %1725 = load i64, ptr %NEXT_PC, align 8
  store i64 %1725, ptr %PC, align 8
  %1726 = add i64 %1725, 5
  store i64 %1726, ptr %NEXT_PC, align 8
  %1727 = load i64, ptr %RSP, align 8
  %1728 = add i64 %1727, 112
  %1729 = load i64, ptr %RBX, align 8
  %1730 = load ptr, ptr %MEMORY, align 8
  %1731 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1730, ptr %state, i64 %1728, i64 %1729)
  store ptr %1731, ptr %MEMORY, align 8
  %1732 = load i64, ptr %NEXT_PC, align 8
  store i64 %1732, ptr %PC, align 8
  %1733 = add i64 %1732, 2
  store i64 %1733, ptr %NEXT_PC, align 8
  %1734 = load i64, ptr %NEXT_PC, align 8
  %1735 = add i64 %1734, 80
  %1736 = load i64, ptr %NEXT_PC, align 8
  %1737 = load ptr, ptr %MEMORY, align 8
  %1738 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1737, ptr %state, ptr %BRANCH_TAKEN, i64 %1735, i64 %1736, ptr %NEXT_PC)
  store ptr %1738, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877924, label %bb_5389877844

bb_5389877844:                                    ; preds = %bb_5389877827
  %1739 = load i64, ptr %NEXT_PC, align 8
  store i64 %1739, ptr %PC, align 8
  %1740 = add i64 %1739, 3
  store i64 %1740, ptr %NEXT_PC, align 8
  %1741 = load i64, ptr %R9, align 8
  %1742 = load i64, ptr %R9, align 8
  %1743 = load ptr, ptr %MEMORY, align 8
  %1744 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1743, ptr %state, i64 %1741, i64 %1742)
  store ptr %1744, ptr %MEMORY, align 8
  %1745 = load i64, ptr %NEXT_PC, align 8
  store i64 %1745, ptr %PC, align 8
  %1746 = add i64 %1745, 6
  store i64 %1746, ptr %NEXT_PC, align 8
  %1747 = load i64, ptr %NEXT_PC, align 8
  %1748 = add i64 %1747, 133
  %1749 = load i64, ptr %NEXT_PC, align 8
  %1750 = load ptr, ptr %MEMORY, align 8
  %1751 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1750, ptr %state, ptr %BRANCH_TAKEN, i64 %1748, i64 %1749, ptr %NEXT_PC)
  store ptr %1751, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877986, label %bb_5389877853

bb_5389877853:                                    ; preds = %bb_5389877844
  %1752 = load i64, ptr %NEXT_PC, align 8
  store i64 %1752, ptr %PC, align 8
  %1753 = add i64 %1752, 3
  store i64 %1753, ptr %NEXT_PC, align 8
  %1754 = load i64, ptr %R9, align 8
  %1755 = load ptr, ptr %MEMORY, align 8
  %1756 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1755, ptr %state, ptr %RAX, i64 %1754)
  store ptr %1756, ptr %MEMORY, align 8
  %1757 = load i64, ptr %NEXT_PC, align 8
  store i64 %1757, ptr %PC, align 8
  %1758 = add i64 %1757, 5
  store i64 %1758, ptr %NEXT_PC, align 8
  %1759 = load i64, ptr %RSP, align 8
  %1760 = add i64 %1759, 32
  %1761 = load ptr, ptr %MEMORY, align 8
  %1762 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %1761, ptr %state, ptr %RDX, i64 %1760)
  store ptr %1762, ptr %MEMORY, align 8
  %1763 = load i64, ptr %NEXT_PC, align 8
  store i64 %1763, ptr %PC, align 8
  %1764 = add i64 %1763, 3
  store i64 %1764, ptr %NEXT_PC, align 8
  %1765 = load i64, ptr %R9, align 8
  %1766 = load ptr, ptr %MEMORY, align 8
  %1767 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1766, ptr %state, ptr %RCX, i64 %1765)
  store ptr %1767, ptr %MEMORY, align 8
  %1768 = load i64, ptr %NEXT_PC, align 8
  store i64 %1768, ptr %PC, align 8
  %1769 = add i64 %1768, 5
  store i64 %1769, ptr %NEXT_PC, align 8
  %1770 = load i64, ptr %RSP, align 8
  %1771 = add i64 %1770, 96
  %1772 = load i64, ptr %RSI, align 8
  %1773 = load ptr, ptr %MEMORY, align 8
  %1774 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1773, ptr %state, i64 %1771, i64 %1772)
  store ptr %1774, ptr %MEMORY, align 8
  %1775 = load i64, ptr %NEXT_PC, align 8
  store i64 %1775, ptr %PC, align 8
  %1776 = add i64 %1775, 3
  store i64 %1776, ptr %NEXT_PC, align 8
  %1777 = load i64, ptr %RAX, align 8
  %1778 = add i64 %1777, 56
  %1779 = load i64, ptr %NEXT_PC, align 8
  %1780 = load ptr, ptr %MEMORY, align 8
  %1781 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %1780, ptr %state, i64 %1778, ptr %NEXT_PC, i64 %1779, ptr %RETURN_PC)
  store ptr %1781, ptr %MEMORY, align 8
  %1782 = load i64, ptr %NEXT_PC, align 8
  store i64 %1782, ptr %PC, align 8
  %1783 = add i64 %1782, 3
  store i64 %1783, ptr %NEXT_PC, align 8
  %1784 = load i64, ptr %RAX, align 8
  %1785 = load ptr, ptr %MEMORY, align 8
  %1786 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1785, ptr %state, ptr %RSI, i64 %1784)
  store ptr %1786, ptr %MEMORY, align 8
  %1787 = load i64, ptr %NEXT_PC, align 8
  store i64 %1787, ptr %PC, align 8
  %1788 = add i64 %1787, 3
  store i64 %1788, ptr %NEXT_PC, align 8
  %1789 = load i64, ptr %RAX, align 8
  %1790 = load ptr, ptr %MEMORY, align 8
  %1791 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1790, ptr %state, ptr %RCX, i64 %1789)
  store ptr %1791, ptr %MEMORY, align 8
  %1792 = load i64, ptr %NEXT_PC, align 8
  store i64 %1792, ptr %PC, align 8
  %1793 = add i64 %1792, 3
  store i64 %1793, ptr %NEXT_PC, align 8
  %1794 = load i64, ptr %RCX, align 8
  %1795 = load i64, ptr %RCX, align 8
  %1796 = load ptr, ptr %MEMORY, align 8
  %1797 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1796, ptr %state, i64 %1794, i64 %1795)
  store ptr %1797, ptr %MEMORY, align 8
  %1798 = load i64, ptr %NEXT_PC, align 8
  store i64 %1798, ptr %PC, align 8
  %1799 = add i64 %1798, 2
  store i64 %1799, ptr %NEXT_PC, align 8
  %1800 = load i64, ptr %NEXT_PC, align 8
  %1801 = add i64 %1800, 8
  %1802 = load i64, ptr %NEXT_PC, align 8
  %1803 = load ptr, ptr %MEMORY, align 8
  %1804 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1803, ptr %state, ptr %BRANCH_TAKEN, i64 %1801, i64 %1802, ptr %NEXT_PC)
  store ptr %1804, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877891, label %bb_5389877883

bb_5389877883:                                    ; preds = %bb_5389877853
  %1805 = load i64, ptr %NEXT_PC, align 8
  store i64 %1805, ptr %PC, align 8
  %1806 = add i64 %1805, 2
  store i64 %1806, ptr %NEXT_PC, align 8
  %1807 = load i64, ptr %RCX, align 8
  %1808 = load i64, ptr %RCX, align 8
  %1809 = load ptr, ptr %MEMORY, align 8
  %1810 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1809, ptr %state, i64 %1807, i64 %1808)
  store ptr %1810, ptr %MEMORY, align 8
  %1811 = load i64, ptr %NEXT_PC, align 8
  store i64 %1811, ptr %PC, align 8
  %1812 = add i64 %1811, 4
  store i64 %1812, ptr %NEXT_PC, align 8
  %1813 = load i64, ptr %RCX, align 8
  %1814 = add i64 %1813, 48
  %1815 = load ptr, ptr %MEMORY, align 8
  %1816 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1815, ptr %state, ptr %RCX, i64 %1814)
  store ptr %1816, ptr %MEMORY, align 8
  %1817 = load i64, ptr %NEXT_PC, align 8
  store i64 %1817, ptr %PC, align 8
  %1818 = add i64 %1817, 2
  store i64 %1818, ptr %NEXT_PC, align 8
  %1819 = load i64, ptr %RCX, align 8
  %1820 = load i64, ptr %RCX, align 8
  %1821 = load ptr, ptr %MEMORY, align 8
  %1822 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1821, ptr %state, i64 %1819, i64 %1820)
  store ptr %1822, ptr %MEMORY, align 8
  br label %bb_5389877891

bb_5389877891:                                    ; preds = %bb_5389877883, %bb_5389877853
  %1823 = load i64, ptr %NEXT_PC, align 8
  store i64 %1823, ptr %PC, align 8
  %1824 = add i64 %1823, 5
  store i64 %1824, ptr %NEXT_PC, align 8
  %1825 = load i64, ptr %RSP, align 8
  %1826 = add i64 %1825, 112
  %1827 = load ptr, ptr %MEMORY, align 8
  %1828 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1827, ptr %state, ptr %RCX, i64 %1826)
  store ptr %1828, ptr %MEMORY, align 8
  %1829 = load i64, ptr %NEXT_PC, align 8
  store i64 %1829, ptr %PC, align 8
  %1830 = add i64 %1829, 3
  store i64 %1830, ptr %NEXT_PC, align 8
  %1831 = load i64, ptr %RCX, align 8
  %1832 = load i64, ptr %RCX, align 8
  %1833 = load ptr, ptr %MEMORY, align 8
  %1834 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1833, ptr %state, i64 %1831, i64 %1832)
  store ptr %1834, ptr %MEMORY, align 8
  %1835 = load i64, ptr %NEXT_PC, align 8
  store i64 %1835, ptr %PC, align 8
  %1836 = add i64 %1835, 2
  store i64 %1836, ptr %NEXT_PC, align 8
  %1837 = load i64, ptr %NEXT_PC, align 8
  %1838 = add i64 %1837, 5
  %1839 = load i64, ptr %NEXT_PC, align 8
  %1840 = load ptr, ptr %MEMORY, align 8
  %1841 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1840, ptr %state, ptr %BRANCH_TAKEN, i64 %1838, i64 %1839, ptr %NEXT_PC)
  store ptr %1841, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877906, label %bb_5389877901

bb_5389877901:                                    ; preds = %bb_5389877891
  %1842 = load i64, ptr %NEXT_PC, align 8
  store i64 %1842, ptr %PC, align 8
  %1843 = add i64 %1842, 5
  store i64 %1843, ptr %NEXT_PC, align 8
  %1844 = load i64, ptr %NEXT_PC, align 8
  %1845 = sub i64 %1844, 1202
  %1846 = load i64, ptr %NEXT_PC, align 8
  %1847 = load ptr, ptr %MEMORY, align 8
  %1848 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1847, ptr %state, i64 %1845, ptr %NEXT_PC, i64 %1846, ptr %RETURN_PC)
  store ptr %1848, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877906:                                    ; preds = %bb_5389877891
  %1849 = load i64, ptr %NEXT_PC, align 8
  store i64 %1849, ptr %PC, align 8
  %1850 = add i64 %1849, 3
  store i64 %1850, ptr %NEXT_PC, align 8
  %1851 = load i64, ptr %RSI, align 8
  %1852 = load ptr, ptr %MEMORY, align 8
  %1853 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1852, ptr %state, ptr %RCX, i64 %1851)
  store ptr %1853, ptr %MEMORY, align 8
  %1854 = load i64, ptr %NEXT_PC, align 8
  store i64 %1854, ptr %PC, align 8
  %1855 = add i64 %1854, 5
  store i64 %1855, ptr %NEXT_PC, align 8
  %1856 = load i64, ptr %RSP, align 8
  %1857 = add i64 %1856, 64
  %1858 = load ptr, ptr %MEMORY, align 8
  %1859 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1858, ptr %state, ptr %R9, i64 %1857)
  store ptr %1859, ptr %MEMORY, align 8
  %1860 = load i64, ptr %NEXT_PC, align 8
  store i64 %1860, ptr %PC, align 8
  %1861 = add i64 %1860, 5
  store i64 %1861, ptr %NEXT_PC, align 8
  %1862 = load i64, ptr %RSP, align 8
  %1863 = add i64 %1862, 96
  %1864 = load ptr, ptr %MEMORY, align 8
  %1865 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1864, ptr %state, ptr %RSI, i64 %1863)
  store ptr %1865, ptr %MEMORY, align 8
  %1866 = load i64, ptr %NEXT_PC, align 8
  store i64 %1866, ptr %PC, align 8
  %1867 = add i64 %1866, 5
  store i64 %1867, ptr %NEXT_PC, align 8
  %1868 = load i64, ptr %RSP, align 8
  %1869 = add i64 %1868, 112
  %1870 = load i64, ptr %RCX, align 8
  %1871 = load ptr, ptr %MEMORY, align 8
  %1872 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1871, ptr %state, i64 %1869, i64 %1870)
  store ptr %1872, ptr %MEMORY, align 8
  br label %bb_5389877924

bb_5389877924:                                    ; preds = %bb_5389877906, %bb_5389877827
  %1873 = load i64, ptr %NEXT_PC, align 8
  store i64 %1873, ptr %PC, align 8
  %1874 = add i64 %1873, 3
  store i64 %1874, ptr %NEXT_PC, align 8
  %1875 = load i64, ptr %R9, align 8
  %1876 = load i64, ptr %R9, align 8
  %1877 = load ptr, ptr %MEMORY, align 8
  %1878 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1877, ptr %state, i64 %1875, i64 %1876)
  store ptr %1878, ptr %MEMORY, align 8
  %1879 = load i64, ptr %NEXT_PC, align 8
  store i64 %1879, ptr %PC, align 8
  %1880 = add i64 %1879, 2
  store i64 %1880, ptr %NEXT_PC, align 8
  %1881 = load i64, ptr %NEXT_PC, align 8
  %1882 = add i64 %1881, 19
  %1883 = load i64, ptr %NEXT_PC, align 8
  %1884 = load ptr, ptr %MEMORY, align 8
  %1885 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1884, ptr %state, ptr %BRANCH_TAKEN, i64 %1882, i64 %1883, ptr %NEXT_PC)
  store ptr %1885, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877948, label %bb_5389877929

bb_5389877929:                                    ; preds = %bb_5389877924
  %1886 = load i64, ptr %NEXT_PC, align 8
  store i64 %1886, ptr %PC, align 8
  %1887 = add i64 %1886, 3
  store i64 %1887, ptr %NEXT_PC, align 8
  %1888 = load i64, ptr %R9, align 8
  %1889 = load ptr, ptr %MEMORY, align 8
  %1890 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1889, ptr %state, ptr %RAX, i64 %1888)
  store ptr %1890, ptr %MEMORY, align 8
  %1891 = load i64, ptr %NEXT_PC, align 8
  store i64 %1891, ptr %PC, align 8
  %1892 = add i64 %1891, 5
  store i64 %1892, ptr %NEXT_PC, align 8
  %1893 = load i64, ptr %RSP, align 8
  %1894 = add i64 %1893, 32
  %1895 = load ptr, ptr %MEMORY, align 8
  %1896 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %1895, ptr %state, ptr %RDX, i64 %1894)
  store ptr %1896, ptr %MEMORY, align 8
  %1897 = load i64, ptr %NEXT_PC, align 8
  store i64 %1897, ptr %PC, align 8
  %1898 = add i64 %1897, 3
  store i64 %1898, ptr %NEXT_PC, align 8
  %1899 = load i64, ptr %R9, align 8
  %1900 = load ptr, ptr %MEMORY, align 8
  %1901 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1900, ptr %state, ptr %RCX, i64 %1899)
  store ptr %1901, ptr %MEMORY, align 8
  %1902 = load i64, ptr %NEXT_PC, align 8
  store i64 %1902, ptr %PC, align 8
  %1903 = add i64 %1902, 3
  store i64 %1903, ptr %NEXT_PC, align 8
  %1904 = load i64, ptr %RAX, align 8
  %1905 = add i64 %1904, 24
  %1906 = load i64, ptr %NEXT_PC, align 8
  %1907 = load ptr, ptr %MEMORY, align 8
  %1908 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %1907, ptr %state, i64 %1905, ptr %NEXT_PC, i64 %1906, ptr %RETURN_PC)
  store ptr %1908, ptr %MEMORY, align 8
  %1909 = load i64, ptr %NEXT_PC, align 8
  store i64 %1909, ptr %PC, align 8
  %1910 = add i64 %1909, 5
  store i64 %1910, ptr %NEXT_PC, align 8
  %1911 = load i64, ptr %RSP, align 8
  %1912 = add i64 %1911, 112
  %1913 = load ptr, ptr %MEMORY, align 8
  %1914 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1913, ptr %state, ptr %RCX, i64 %1912)
  store ptr %1914, ptr %MEMORY, align 8
  br label %bb_5389877948

bb_5389877948:                                    ; preds = %bb_5389877929, %bb_5389877924
  %1915 = load i64, ptr %NEXT_PC, align 8
  store i64 %1915, ptr %PC, align 8
  %1916 = add i64 %1915, 3
  store i64 %1916, ptr %NEXT_PC, align 8
  %1917 = load i64, ptr %RCX, align 8
  %1918 = load i64, ptr %RCX, align 8
  %1919 = load ptr, ptr %MEMORY, align 8
  %1920 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1919, ptr %state, i64 %1917, i64 %1918)
  store ptr %1920, ptr %MEMORY, align 8
  %1921 = load i64, ptr %NEXT_PC, align 8
  store i64 %1921, ptr %PC, align 8
  %1922 = add i64 %1921, 2
  store i64 %1922, ptr %NEXT_PC, align 8
  %1923 = load i64, ptr %NEXT_PC, align 8
  %1924 = add i64 %1923, 33
  %1925 = load i64, ptr %NEXT_PC, align 8
  %1926 = load ptr, ptr %MEMORY, align 8
  %1927 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1926, ptr %state, ptr %BRANCH_TAKEN, i64 %1924, i64 %1925, ptr %NEXT_PC)
  store ptr %1927, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877986, label %bb_5389877953

bb_5389877953:                                    ; preds = %bb_5389877948
  %1928 = load i64, ptr %NEXT_PC, align 8
  store i64 %1928, ptr %PC, align 8
  %1929 = add i64 %1928, 6
  store i64 %1929, ptr %NEXT_PC, align 8
  %1930 = load i64, ptr %RDI, align 8
  %1931 = add i64 %1930, 256
  %1932 = load i64, ptr %RDI, align 8
  %1933 = add i64 %1932, 256
  %1934 = load ptr, ptr %MEMORY, align 8
  %1935 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %1934, ptr %state, i64 %1931, i64 %1933)
  store ptr %1935, ptr %MEMORY, align 8
  %1936 = load i64, ptr %NEXT_PC, align 8
  store i64 %1936, ptr %PC, align 8
  %1937 = add i64 %1936, 3
  store i64 %1937, ptr %NEXT_PC, align 8
  %1938 = load i64, ptr %RDI, align 8
  %1939 = load ptr, ptr %MEMORY, align 8
  %1940 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1939, ptr %state, ptr %R8, i64 %1938)
  store ptr %1940, ptr %MEMORY, align 8
  %1941 = load i64, ptr %NEXT_PC, align 8
  store i64 %1941, ptr %PC, align 8
  %1942 = add i64 %1941, 2
  store i64 %1942, ptr %NEXT_PC, align 8
  %1943 = load i32, ptr %EBP, align 4
  %1944 = zext i32 %1943 to i64
  %1945 = load ptr, ptr %MEMORY, align 8
  %1946 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1945, ptr %state, ptr %RDX, i64 %1944)
  store ptr %1946, ptr %MEMORY, align 8
  %1947 = load i64, ptr %NEXT_PC, align 8
  store i64 %1947, ptr %PC, align 8
  %1948 = add i64 %1947, 5
  store i64 %1948, ptr %NEXT_PC, align 8
  %1949 = load i64, ptr %NEXT_PC, align 8
  %1950 = sub i64 %1949, 321
  %1951 = load i64, ptr %NEXT_PC, align 8
  %1952 = load ptr, ptr %MEMORY, align 8
  %1953 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1952, ptr %state, i64 %1950, ptr %NEXT_PC, i64 %1951, ptr %RETURN_PC)
  store ptr %1953, ptr %MEMORY, align 8
  %1954 = load i64, ptr %NEXT_PC, align 8
  store i64 %1954, ptr %PC, align 8
  %1955 = add i64 %1954, 5
  store i64 %1955, ptr %NEXT_PC, align 8
  %1956 = load i64, ptr %RSP, align 8
  %1957 = add i64 %1956, 112
  %1958 = load ptr, ptr %MEMORY, align 8
  %1959 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1958, ptr %state, ptr %RCX, i64 %1957)
  store ptr %1959, ptr %MEMORY, align 8
  %1960 = load i64, ptr %NEXT_PC, align 8
  store i64 %1960, ptr %PC, align 8
  %1961 = add i64 %1960, 2
  store i64 %1961, ptr %NEXT_PC, align 8
  %1962 = load i32, ptr %EAX, align 4
  %1963 = zext i32 %1962 to i64
  %1964 = load ptr, ptr %MEMORY, align 8
  %1965 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1964, ptr %state, ptr %RBX, i64 %1963)
  store ptr %1965, ptr %MEMORY, align 8
  %1966 = load i64, ptr %NEXT_PC, align 8
  store i64 %1966, ptr %PC, align 8
  %1967 = add i64 %1966, 3
  store i64 %1967, ptr %NEXT_PC, align 8
  %1968 = load i64, ptr %RCX, align 8
  %1969 = load i64, ptr %RCX, align 8
  %1970 = load ptr, ptr %MEMORY, align 8
  %1971 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %1970, ptr %state, i64 %1968, i64 %1969)
  store ptr %1971, ptr %MEMORY, align 8
  %1972 = load i64, ptr %NEXT_PC, align 8
  store i64 %1972, ptr %PC, align 8
  %1973 = add i64 %1972, 2
  store i64 %1973, ptr %NEXT_PC, align 8
  %1974 = load i64, ptr %NEXT_PC, align 8
  %1975 = add i64 %1974, 5
  %1976 = load i64, ptr %NEXT_PC, align 8
  %1977 = load ptr, ptr %MEMORY, align 8
  %1978 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %1977, ptr %state, ptr %BRANCH_TAKEN, i64 %1975, i64 %1976, ptr %NEXT_PC)
  store ptr %1978, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877986, label %bb_5389877981

bb_5389877981:                                    ; preds = %bb_5389877953
  %1979 = load i64, ptr %NEXT_PC, align 8
  store i64 %1979, ptr %PC, align 8
  %1980 = add i64 %1979, 5
  store i64 %1980, ptr %NEXT_PC, align 8
  %1981 = load i64, ptr %NEXT_PC, align 8
  %1982 = sub i64 %1981, 1282
  %1983 = load i64, ptr %NEXT_PC, align 8
  %1984 = load ptr, ptr %MEMORY, align 8
  %1985 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %1984, ptr %state, i64 %1982, ptr %NEXT_PC, i64 %1983, ptr %RETURN_PC)
  store ptr %1985, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877986:                                    ; preds = %bb_5389877953, %bb_5389877948, %bb_5389877844
  %1986 = load i64, ptr %NEXT_PC, align 8
  store i64 %1986, ptr %PC, align 8
  %1987 = add i64 %1986, 2
  store i64 %1987, ptr %NEXT_PC, align 8
  %1988 = load i32, ptr %EBX, align 4
  %1989 = zext i32 %1988 to i64
  %1990 = load ptr, ptr %MEMORY, align 8
  %1991 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %1990, ptr %state, ptr %RAX, i64 %1989)
  store ptr %1991, ptr %MEMORY, align 8
  %1992 = load i64, ptr %NEXT_PC, align 8
  store i64 %1992, ptr %PC, align 8
  %1993 = add i64 %1992, 5
  store i64 %1993, ptr %NEXT_PC, align 8
  %1994 = load i64, ptr %RSP, align 8
  %1995 = add i64 %1994, 104
  %1996 = load ptr, ptr %MEMORY, align 8
  %1997 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1996, ptr %state, ptr %RBX, i64 %1995)
  store ptr %1997, ptr %MEMORY, align 8
  %1998 = load i64, ptr %NEXT_PC, align 8
  store i64 %1998, ptr %PC, align 8
  %1999 = add i64 %1998, 5
  store i64 %1999, ptr %NEXT_PC, align 8
  %2000 = load i64, ptr %RSP, align 8
  %2001 = add i64 %2000, 120
  %2002 = load ptr, ptr %MEMORY, align 8
  %2003 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2002, ptr %state, ptr %RBP, i64 %2001)
  store ptr %2003, ptr %MEMORY, align 8
  %2004 = load i64, ptr %NEXT_PC, align 8
  store i64 %2004, ptr %PC, align 8
  %2005 = add i64 %2004, 4
  store i64 %2005, ptr %NEXT_PC, align 8
  %2006 = load i64, ptr %RSP, align 8
  %2007 = load ptr, ptr %MEMORY, align 8
  %2008 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2007, ptr %state, ptr %RSP, i64 %2006, i64 80)
  store ptr %2008, ptr %MEMORY, align 8
  %2009 = load i64, ptr %NEXT_PC, align 8
  store i64 %2009, ptr %PC, align 8
  %2010 = add i64 %2009, 1
  store i64 %2010, ptr %NEXT_PC, align 8
  %2011 = load ptr, ptr %MEMORY, align 8
  %2012 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %2011, ptr %state, ptr %RDI)
  store ptr %2012, ptr %MEMORY, align 8
  %2013 = load i64, ptr %NEXT_PC, align 8
  store i64 %2013, ptr %PC, align 8
  %2014 = add i64 %2013, 1
  store i64 %2014, ptr %NEXT_PC, align 8
  %2015 = load ptr, ptr %MEMORY, align 8
  %2016 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %2015, ptr %state, ptr %NEXT_PC)
  store ptr %2016, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878004:                                    ; preds = %bb_5389877686, %bb_5389877636
  %2017 = load i64, ptr %NEXT_PC, align 8
  store i64 %2017, ptr %PC, align 8
  %2018 = add i64 %2017, 5
  store i64 %2018, ptr %NEXT_PC, align 8
  %2019 = load i64, ptr %RSP, align 8
  %2020 = add i64 %2019, 104
  %2021 = load ptr, ptr %MEMORY, align 8
  %2022 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2021, ptr %state, ptr %RBX, i64 %2020)
  store ptr %2022, ptr %MEMORY, align 8
  %2023 = load i64, ptr %NEXT_PC, align 8
  store i64 %2023, ptr %PC, align 8
  %2024 = add i64 %2023, 2
  store i64 %2024, ptr %NEXT_PC, align 8
  %2025 = load i64, ptr %RAX, align 8
  %2026 = load i32, ptr %EAX, align 4
  %2027 = zext i32 %2026 to i64
  %2028 = load ptr, ptr %MEMORY, align 8
  %2029 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2028, ptr %state, ptr %RAX, i64 %2025, i64 %2027)
  store ptr %2029, ptr %MEMORY, align 8
  %2030 = load i64, ptr %NEXT_PC, align 8
  store i64 %2030, ptr %PC, align 8
  %2031 = add i64 %2030, 5
  store i64 %2031, ptr %NEXT_PC, align 8
  %2032 = load i64, ptr %RSP, align 8
  %2033 = add i64 %2032, 120
  %2034 = load ptr, ptr %MEMORY, align 8
  %2035 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2034, ptr %state, ptr %RBP, i64 %2033)
  store ptr %2035, ptr %MEMORY, align 8
  %2036 = load i64, ptr %NEXT_PC, align 8
  store i64 %2036, ptr %PC, align 8
  %2037 = add i64 %2036, 4
  store i64 %2037, ptr %NEXT_PC, align 8
  %2038 = load i64, ptr %RSP, align 8
  %2039 = load ptr, ptr %MEMORY, align 8
  %2040 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2039, ptr %state, ptr %RSP, i64 %2038, i64 80)
  store ptr %2040, ptr %MEMORY, align 8
  %2041 = load i64, ptr %NEXT_PC, align 8
  store i64 %2041, ptr %PC, align 8
  %2042 = add i64 %2041, 1
  store i64 %2042, ptr %NEXT_PC, align 8
  %2043 = load ptr, ptr %MEMORY, align 8
  %2044 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %2043, ptr %state, ptr %RDI)
  store ptr %2044, ptr %MEMORY, align 8
  %2045 = load i64, ptr %NEXT_PC, align 8
  store i64 %2045, ptr %PC, align 8
  %2046 = add i64 %2045, 1
  store i64 %2046, ptr %NEXT_PC, align 8
  %2047 = load ptr, ptr %MEMORY, align 8
  %2048 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %2047, ptr %state, ptr %NEXT_PC)
  store ptr %2048, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878022:                                    ; No predecessors!
  %2049 = load i64, ptr %NEXT_PC, align 8
  store i64 %2049, ptr %PC, align 8
  %2050 = add i64 %2049, 1
  store i64 %2050, ptr %NEXT_PC, align 8
  %2051 = load ptr, ptr %MEMORY, align 8
  %2052 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2051, ptr %state, ptr undef)
  store ptr %2052, ptr %MEMORY, align 8
  %2053 = load i64, ptr %NEXT_PC, align 8
  store i64 %2053, ptr %PC, align 8
  %2054 = add i64 %2053, 1
  store i64 %2054, ptr %NEXT_PC, align 8
  %2055 = load ptr, ptr %MEMORY, align 8
  %2056 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2055, ptr %state, ptr undef)
  store ptr %2056, ptr %MEMORY, align 8
  %2057 = load i64, ptr %NEXT_PC, align 8
  store i64 %2057, ptr %PC, align 8
  %2058 = add i64 %2057, 1
  store i64 %2058, ptr %NEXT_PC, align 8
  %2059 = load ptr, ptr %MEMORY, align 8
  %2060 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2059, ptr %state, ptr undef)
  store ptr %2060, ptr %MEMORY, align 8
  %2061 = load i64, ptr %NEXT_PC, align 8
  store i64 %2061, ptr %PC, align 8
  %2062 = add i64 %2061, 1
  store i64 %2062, ptr %NEXT_PC, align 8
  %2063 = load ptr, ptr %MEMORY, align 8
  %2064 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2063, ptr %state, ptr undef)
  store ptr %2064, ptr %MEMORY, align 8
  %2065 = load i64, ptr %NEXT_PC, align 8
  store i64 %2065, ptr %PC, align 8
  %2066 = add i64 %2065, 1
  store i64 %2066, ptr %NEXT_PC, align 8
  %2067 = load ptr, ptr %MEMORY, align 8
  %2068 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2067, ptr %state, ptr undef)
  store ptr %2068, ptr %MEMORY, align 8
  %2069 = load i64, ptr %NEXT_PC, align 8
  store i64 %2069, ptr %PC, align 8
  %2070 = add i64 %2069, 1
  store i64 %2070, ptr %NEXT_PC, align 8
  %2071 = load ptr, ptr %MEMORY, align 8
  %2072 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2071, ptr %state, ptr undef)
  store ptr %2072, ptr %MEMORY, align 8
  %2073 = load i64, ptr %NEXT_PC, align 8
  store i64 %2073, ptr %PC, align 8
  %2074 = add i64 %2073, 1
  store i64 %2074, ptr %NEXT_PC, align 8
  %2075 = load ptr, ptr %MEMORY, align 8
  %2076 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2075, ptr %state, ptr undef)
  store ptr %2076, ptr %MEMORY, align 8
  %2077 = load i64, ptr %NEXT_PC, align 8
  store i64 %2077, ptr %PC, align 8
  %2078 = add i64 %2077, 1
  store i64 %2078, ptr %NEXT_PC, align 8
  %2079 = load ptr, ptr %MEMORY, align 8
  %2080 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2079, ptr %state, ptr undef)
  store ptr %2080, ptr %MEMORY, align 8
  %2081 = load i64, ptr %NEXT_PC, align 8
  store i64 %2081, ptr %PC, align 8
  %2082 = add i64 %2081, 1
  store i64 %2082, ptr %NEXT_PC, align 8
  %2083 = load ptr, ptr %MEMORY, align 8
  %2084 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2083, ptr %state, ptr undef)
  store ptr %2084, ptr %MEMORY, align 8
  %2085 = load i64, ptr %NEXT_PC, align 8
  store i64 %2085, ptr %PC, align 8
  %2086 = add i64 %2085, 1
  store i64 %2086, ptr %NEXT_PC, align 8
  %2087 = load ptr, ptr %MEMORY, align 8
  %2088 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2087, ptr %state, ptr undef)
  store ptr %2088, ptr %MEMORY, align 8
  %2089 = load i64, ptr %NEXT_PC, align 8
  store i64 %2089, ptr %PC, align 8
  %2090 = add i64 %2089, 5
  store i64 %2090, ptr %NEXT_PC, align 8
  %2091 = load i64, ptr %RSP, align 8
  %2092 = add i64 %2091, 8
  %2093 = load i64, ptr %RBX, align 8
  %2094 = load ptr, ptr %MEMORY, align 8
  %2095 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2094, ptr %state, i64 %2092, i64 %2093)
  store ptr %2095, ptr %MEMORY, align 8
  %2096 = load i64, ptr %NEXT_PC, align 8
  store i64 %2096, ptr %PC, align 8
  %2097 = add i64 %2096, 5
  store i64 %2097, ptr %NEXT_PC, align 8
  %2098 = load i64, ptr %RSP, align 8
  %2099 = add i64 %2098, 16
  %2100 = load i64, ptr %RSI, align 8
  %2101 = load ptr, ptr %MEMORY, align 8
  %2102 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2101, ptr %state, i64 %2099, i64 %2100)
  store ptr %2102, ptr %MEMORY, align 8
  %2103 = load i64, ptr %NEXT_PC, align 8
  store i64 %2103, ptr %PC, align 8
  %2104 = add i64 %2103, 1
  store i64 %2104, ptr %NEXT_PC, align 8
  %2105 = load i64, ptr %RDI, align 8
  %2106 = load ptr, ptr %MEMORY, align 8
  %2107 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %2106, ptr %state, i64 %2105)
  store ptr %2107, ptr %MEMORY, align 8
  %2108 = load i64, ptr %NEXT_PC, align 8
  store i64 %2108, ptr %PC, align 8
  %2109 = add i64 %2108, 4
  store i64 %2109, ptr %NEXT_PC, align 8
  %2110 = load i64, ptr %RSP, align 8
  %2111 = load ptr, ptr %MEMORY, align 8
  %2112 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2111, ptr %state, ptr %RSP, i64 %2110, i64 32)
  store ptr %2112, ptr %MEMORY, align 8
  %2113 = load i64, ptr %NEXT_PC, align 8
  store i64 %2113, ptr %PC, align 8
  %2114 = add i64 %2113, 3
  store i64 %2114, ptr %NEXT_PC, align 8
  %2115 = load i64, ptr %RCX, align 8
  %2116 = add i64 %2115, 24
  %2117 = load ptr, ptr %MEMORY, align 8
  %2118 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %2117, ptr %state, ptr %RDX, i64 %2116)
  store ptr %2118, ptr %MEMORY, align 8
  %2119 = load i64, ptr %NEXT_PC, align 8
  store i64 %2119, ptr %PC, align 8
  %2120 = add i64 %2119, 2
  store i64 %2120, ptr %NEXT_PC, align 8
  %2121 = load i64, ptr %RSI, align 8
  %2122 = load i32, ptr %ESI, align 4
  %2123 = zext i32 %2122 to i64
  %2124 = load ptr, ptr %MEMORY, align 8
  %2125 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2124, ptr %state, ptr %RSI, i64 %2121, i64 %2123)
  store ptr %2125, ptr %MEMORY, align 8
  %2126 = load i64, ptr %NEXT_PC, align 8
  store i64 %2126, ptr %PC, align 8
  %2127 = add i64 %2126, 3
  store i64 %2127, ptr %NEXT_PC, align 8
  %2128 = load i64, ptr %RCX, align 8
  %2129 = load ptr, ptr %MEMORY, align 8
  %2130 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2129, ptr %state, ptr %RDI, i64 %2128)
  store ptr %2130, ptr %MEMORY, align 8
  %2131 = load i64, ptr %NEXT_PC, align 8
  store i64 %2131, ptr %PC, align 8
  %2132 = add i64 %2131, 2
  store i64 %2132, ptr %NEXT_PC, align 8
  %2133 = load i32, ptr %EDX, align 4
  %2134 = zext i32 %2133 to i64
  %2135 = load i32, ptr %EDX, align 4
  %2136 = zext i32 %2135 to i64
  %2137 = load ptr, ptr %MEMORY, align 8
  %2138 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2137, ptr %state, i64 %2134, i64 %2136)
  store ptr %2138, ptr %MEMORY, align 8
  %2139 = load i64, ptr %NEXT_PC, align 8
  store i64 %2139, ptr %PC, align 8
  %2140 = add i64 %2139, 2
  store i64 %2140, ptr %NEXT_PC, align 8
  %2141 = load i64, ptr %NEXT_PC, align 8
  %2142 = add i64 %2141, 23
  %2143 = load i64, ptr %NEXT_PC, align 8
  %2144 = load ptr, ptr %MEMORY, align 8
  %2145 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2144, ptr %state, ptr %BRANCH_TAKEN, i64 %2142, i64 %2143, ptr %NEXT_PC)
  store ptr %2145, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878082, label %bb_5389878059

bb_5389878059:                                    ; preds = %bb_5389878022
  %2146 = load i64, ptr %NEXT_PC, align 8
  store i64 %2146, ptr %PC, align 8
  %2147 = add i64 %2146, 4
  store i64 %2147, ptr %NEXT_PC, align 8
  %2148 = load i64, ptr %RCX, align 8
  %2149 = add i64 %2148, 16
  %2150 = load ptr, ptr %MEMORY, align 8
  %2151 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2150, ptr %state, ptr %RCX, i64 %2149)
  store ptr %2151, ptr %MEMORY, align 8
  %2152 = load i64, ptr %NEXT_PC, align 8
  store i64 %2152, ptr %PC, align 8
  %2153 = add i64 %2152, 3
  store i64 %2153, ptr %NEXT_PC, align 8
  %2154 = load i64, ptr %RCX, align 8
  %2155 = load i64, ptr %RCX, align 8
  %2156 = load ptr, ptr %MEMORY, align 8
  %2157 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2156, ptr %state, i64 %2154, i64 %2155)
  store ptr %2157, ptr %MEMORY, align 8
  %2158 = load i64, ptr %NEXT_PC, align 8
  store i64 %2158, ptr %PC, align 8
  %2159 = add i64 %2158, 2
  store i64 %2159, ptr %NEXT_PC, align 8
  %2160 = load i64, ptr %NEXT_PC, align 8
  %2161 = add i64 %2160, 9
  %2162 = load i64, ptr %NEXT_PC, align 8
  %2163 = load ptr, ptr %MEMORY, align 8
  %2164 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2163, ptr %state, ptr %BRANCH_TAKEN, i64 %2161, i64 %2162, ptr %NEXT_PC)
  store ptr %2164, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878077, label %bb_5389878068

bb_5389878068:                                    ; preds = %bb_5389878059
  %2165 = load i64, ptr %NEXT_PC, align 8
  store i64 %2165, ptr %PC, align 8
  %2166 = add i64 %2165, 5
  store i64 %2166, ptr %NEXT_PC, align 8
  %2167 = load i64, ptr %NEXT_PC, align 8
  %2168 = sub i64 %2167, 1157081
  %2169 = load i64, ptr %NEXT_PC, align 8
  %2170 = load ptr, ptr %MEMORY, align 8
  %2171 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2170, ptr %state, i64 %2168, ptr %NEXT_PC, i64 %2169, ptr %RETURN_PC)
  store ptr %2171, ptr %MEMORY, align 8
  %2172 = load i64, ptr %NEXT_PC, align 8
  store i64 %2172, ptr %PC, align 8
  %2173 = add i64 %2172, 4
  store i64 %2173, ptr %NEXT_PC, align 8
  %2174 = load i64, ptr %RDI, align 8
  %2175 = add i64 %2174, 16
  %2176 = load i64, ptr %RSI, align 8
  %2177 = load ptr, ptr %MEMORY, align 8
  %2178 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2177, ptr %state, i64 %2175, i64 %2176)
  store ptr %2178, ptr %MEMORY, align 8
  br label %bb_5389878077

bb_5389878077:                                    ; preds = %bb_5389878068, %bb_5389878059
  %2179 = load i64, ptr %NEXT_PC, align 8
  store i64 %2179, ptr %PC, align 8
  %2180 = add i64 %2179, 3
  store i64 %2180, ptr %NEXT_PC, align 8
  %2181 = load i64, ptr %RDI, align 8
  %2182 = add i64 %2181, 28
  %2183 = load i32, ptr %ESI, align 4
  %2184 = zext i32 %2183 to i64
  %2185 = load ptr, ptr %MEMORY, align 8
  %2186 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2185, ptr %state, i64 %2182, i64 %2184)
  store ptr %2186, ptr %MEMORY, align 8
  %2187 = load i64, ptr %NEXT_PC, align 8
  store i64 %2187, ptr %PC, align 8
  %2188 = add i64 %2187, 2
  store i64 %2188, ptr %NEXT_PC, align 8
  %2189 = load i64, ptr %NEXT_PC, align 8
  %2190 = add i64 %2189, 20
  %2191 = load ptr, ptr %MEMORY, align 8
  %2192 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %2191, ptr %state, i64 %2190, ptr %NEXT_PC)
  store ptr %2192, ptr %MEMORY, align 8
  br label %bb_5389878102

bb_5389878082:                                    ; preds = %bb_5389878022
  %2193 = load i64, ptr %NEXT_PC, align 8
  store i64 %2193, ptr %PC, align 8
  %2194 = add i64 %2193, 3
  store i64 %2194, ptr %NEXT_PC, align 8
  %2195 = load i64, ptr %RCX, align 8
  %2196 = add i64 %2195, 28
  %2197 = load i32, ptr %EDX, align 4
  %2198 = zext i32 %2197 to i64
  %2199 = load ptr, ptr %MEMORY, align 8
  %2200 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %2199, ptr %state, i64 %2196, i64 %2198)
  store ptr %2200, ptr %MEMORY, align 8
  %2201 = load i64, ptr %NEXT_PC, align 8
  store i64 %2201, ptr %PC, align 8
  %2202 = add i64 %2201, 2
  store i64 %2202, ptr %NEXT_PC, align 8
  %2203 = load i64, ptr %NEXT_PC, align 8
  %2204 = add i64 %2203, 15
  %2205 = load i64, ptr %NEXT_PC, align 8
  %2206 = load ptr, ptr %MEMORY, align 8
  %2207 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2206, ptr %state, ptr %BRANCH_TAKEN, i64 %2204, i64 %2205, ptr %NEXT_PC)
  store ptr %2207, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878102, label %bb_5389878087

bb_5389878087:                                    ; preds = %bb_5389878082
  %2208 = load i64, ptr %NEXT_PC, align 8
  store i64 %2208, ptr %PC, align 8
  %2209 = add i64 %2208, 6
  store i64 %2209, ptr %NEXT_PC, align 8
  %2210 = load ptr, ptr %MEMORY, align 8
  %2211 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %2210, ptr %state, ptr %R8, i64 134217736)
  store ptr %2211, ptr %MEMORY, align 8
  %2212 = load i64, ptr %NEXT_PC, align 8
  store i64 %2212, ptr %PC, align 8
  %2213 = add i64 %2212, 4
  store i64 %2213, ptr %NEXT_PC, align 8
  %2214 = load i64, ptr %RCX, align 8
  %2215 = load ptr, ptr %MEMORY, align 8
  %2216 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2215, ptr %state, ptr %RCX, i64 %2214, i64 16)
  store ptr %2216, ptr %MEMORY, align 8
  %2217 = load i64, ptr %NEXT_PC, align 8
  store i64 %2217, ptr %PC, align 8
  %2218 = add i64 %2217, 5
  store i64 %2218, ptr %NEXT_PC, align 8
  %2219 = load i64, ptr %NEXT_PC, align 8
  %2220 = sub i64 %2219, 644470
  %2221 = load i64, ptr %NEXT_PC, align 8
  %2222 = load ptr, ptr %MEMORY, align 8
  %2223 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2222, ptr %state, i64 %2220, ptr %NEXT_PC, i64 %2221, ptr %RETURN_PC)
  store ptr %2223, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878102:                                    ; preds = %bb_5389878082, %bb_5389878077
  %2224 = load i64, ptr %NEXT_PC, align 8
  store i64 %2224, ptr %PC, align 8
  %2225 = add i64 %2224, 3
  store i64 %2225, ptr %NEXT_PC, align 8
  %2226 = load i64, ptr %RDI, align 8
  %2227 = add i64 %2226, 40
  %2228 = load ptr, ptr %MEMORY, align 8
  %2229 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %2228, ptr %state, ptr %RDX, i64 %2227)
  store ptr %2229, ptr %MEMORY, align 8
  %2230 = load i64, ptr %NEXT_PC, align 8
  store i64 %2230, ptr %PC, align 8
  %2231 = add i64 %2230, 2
  store i64 %2231, ptr %NEXT_PC, align 8
  %2232 = load i32, ptr %EDX, align 4
  %2233 = zext i32 %2232 to i64
  %2234 = load i32, ptr %EDX, align 4
  %2235 = zext i32 %2234 to i64
  %2236 = load ptr, ptr %MEMORY, align 8
  %2237 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2236, ptr %state, i64 %2233, i64 %2235)
  store ptr %2237, ptr %MEMORY, align 8
  %2238 = load i64, ptr %NEXT_PC, align 8
  store i64 %2238, ptr %PC, align 8
  %2239 = add i64 %2238, 2
  store i64 %2239, ptr %NEXT_PC, align 8
  %2240 = load i64, ptr %NEXT_PC, align 8
  %2241 = add i64 %2240, 37
  %2242 = load i64, ptr %NEXT_PC, align 8
  %2243 = load ptr, ptr %MEMORY, align 8
  %2244 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2243, ptr %state, ptr %BRANCH_TAKEN, i64 %2241, i64 %2242, ptr %NEXT_PC)
  store ptr %2244, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878146, label %bb_5389878109

bb_5389878109:                                    ; preds = %bb_5389878102
  %2245 = load i64, ptr %NEXT_PC, align 8
  store i64 %2245, ptr %PC, align 8
  %2246 = add i64 %2245, 4
  store i64 %2246, ptr %NEXT_PC, align 8
  %2247 = load i64, ptr %RDI, align 8
  %2248 = add i64 %2247, 32
  %2249 = load ptr, ptr %MEMORY, align 8
  %2250 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2249, ptr %state, ptr %RCX, i64 %2248)
  store ptr %2250, ptr %MEMORY, align 8
  %2251 = load i64, ptr %NEXT_PC, align 8
  store i64 %2251, ptr %PC, align 8
  %2252 = add i64 %2251, 3
  store i64 %2252, ptr %NEXT_PC, align 8
  %2253 = load i64, ptr %RCX, align 8
  %2254 = load i64, ptr %RCX, align 8
  %2255 = load ptr, ptr %MEMORY, align 8
  %2256 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2255, ptr %state, i64 %2253, i64 %2254)
  store ptr %2256, ptr %MEMORY, align 8
  %2257 = load i64, ptr %NEXT_PC, align 8
  store i64 %2257, ptr %PC, align 8
  %2258 = add i64 %2257, 2
  store i64 %2258, ptr %NEXT_PC, align 8
  %2259 = load i64, ptr %NEXT_PC, align 8
  %2260 = add i64 %2259, 9
  %2261 = load i64, ptr %NEXT_PC, align 8
  %2262 = load ptr, ptr %MEMORY, align 8
  %2263 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2262, ptr %state, ptr %BRANCH_TAKEN, i64 %2260, i64 %2261, ptr %NEXT_PC)
  store ptr %2263, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878127, label %bb_5389878118

bb_5389878118:                                    ; preds = %bb_5389878109
  %2264 = load i64, ptr %NEXT_PC, align 8
  store i64 %2264, ptr %PC, align 8
  %2265 = add i64 %2264, 5
  store i64 %2265, ptr %NEXT_PC, align 8
  %2266 = load i64, ptr %NEXT_PC, align 8
  %2267 = sub i64 %2266, 1157131
  %2268 = load i64, ptr %NEXT_PC, align 8
  %2269 = load ptr, ptr %MEMORY, align 8
  %2270 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2269, ptr %state, i64 %2267, ptr %NEXT_PC, i64 %2268, ptr %RETURN_PC)
  store ptr %2270, ptr %MEMORY, align 8
  %2271 = load i64, ptr %NEXT_PC, align 8
  store i64 %2271, ptr %PC, align 8
  %2272 = add i64 %2271, 4
  store i64 %2272, ptr %NEXT_PC, align 8
  %2273 = load i64, ptr %RDI, align 8
  %2274 = add i64 %2273, 32
  %2275 = load i64, ptr %RSI, align 8
  %2276 = load ptr, ptr %MEMORY, align 8
  %2277 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2276, ptr %state, i64 %2274, i64 %2275)
  store ptr %2277, ptr %MEMORY, align 8
  br label %bb_5389878127

bb_5389878127:                                    ; preds = %bb_5389878118, %bb_5389878109
  %2278 = load i64, ptr %NEXT_PC, align 8
  store i64 %2278, ptr %PC, align 8
  %2279 = add i64 %2278, 3
  store i64 %2279, ptr %NEXT_PC, align 8
  %2280 = load i64, ptr %RDI, align 8
  %2281 = add i64 %2280, 44
  %2282 = load i32, ptr %ESI, align 4
  %2283 = zext i32 %2282 to i64
  %2284 = load ptr, ptr %MEMORY, align 8
  %2285 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2284, ptr %state, i64 %2281, i64 %2283)
  store ptr %2285, ptr %MEMORY, align 8
  %2286 = load i64, ptr %NEXT_PC, align 8
  store i64 %2286, ptr %PC, align 8
  %2287 = add i64 %2286, 5
  store i64 %2287, ptr %NEXT_PC, align 8
  %2288 = load i64, ptr %RSP, align 8
  %2289 = add i64 %2288, 48
  %2290 = load ptr, ptr %MEMORY, align 8
  %2291 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2290, ptr %state, ptr %RBX, i64 %2289)
  store ptr %2291, ptr %MEMORY, align 8
  %2292 = load i64, ptr %NEXT_PC, align 8
  store i64 %2292, ptr %PC, align 8
  %2293 = add i64 %2292, 5
  store i64 %2293, ptr %NEXT_PC, align 8
  %2294 = load i64, ptr %RSP, align 8
  %2295 = add i64 %2294, 56
  %2296 = load ptr, ptr %MEMORY, align 8
  %2297 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2296, ptr %state, ptr %RSI, i64 %2295)
  store ptr %2297, ptr %MEMORY, align 8
  %2298 = load i64, ptr %NEXT_PC, align 8
  store i64 %2298, ptr %PC, align 8
  %2299 = add i64 %2298, 4
  store i64 %2299, ptr %NEXT_PC, align 8
  %2300 = load i64, ptr %RSP, align 8
  %2301 = load ptr, ptr %MEMORY, align 8
  %2302 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2301, ptr %state, ptr %RSP, i64 %2300, i64 32)
  store ptr %2302, ptr %MEMORY, align 8
  %2303 = load i64, ptr %NEXT_PC, align 8
  store i64 %2303, ptr %PC, align 8
  %2304 = add i64 %2303, 1
  store i64 %2304, ptr %NEXT_PC, align 8
  %2305 = load ptr, ptr %MEMORY, align 8
  %2306 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %2305, ptr %state, ptr %RDI)
  store ptr %2306, ptr %MEMORY, align 8
  %2307 = load i64, ptr %NEXT_PC, align 8
  store i64 %2307, ptr %PC, align 8
  %2308 = add i64 %2307, 1
  store i64 %2308, ptr %NEXT_PC, align 8
  %2309 = load ptr, ptr %MEMORY, align 8
  %2310 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %2309, ptr %state, ptr %NEXT_PC)
  store ptr %2310, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878146:                                    ; preds = %bb_5389878102
  %2311 = load i64, ptr %NEXT_PC, align 8
  store i64 %2311, ptr %PC, align 8
  %2312 = add i64 %2311, 3
  store i64 %2312, ptr %NEXT_PC, align 8
  %2313 = load i64, ptr %RDI, align 8
  %2314 = add i64 %2313, 44
  %2315 = load i32, ptr %EDX, align 4
  %2316 = zext i32 %2315 to i64
  %2317 = load ptr, ptr %MEMORY, align 8
  %2318 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %2317, ptr %state, i64 %2314, i64 %2316)
  store ptr %2318, ptr %MEMORY, align 8
  %2319 = load i64, ptr %NEXT_PC, align 8
  store i64 %2319, ptr %PC, align 8
  %2320 = add i64 %2319, 2
  store i64 %2320, ptr %NEXT_PC, align 8
  %2321 = load i64, ptr %NEXT_PC, align 8
  %2322 = add i64 %2321, 15
  %2323 = load i64, ptr %NEXT_PC, align 8
  %2324 = load ptr, ptr %MEMORY, align 8
  %2325 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2324, ptr %state, ptr %BRANCH_TAKEN, i64 %2322, i64 %2323, ptr %NEXT_PC)
  store ptr %2325, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878166, label %bb_5389878151

bb_5389878151:                                    ; preds = %bb_5389878146
  %2326 = load i64, ptr %NEXT_PC, align 8
  store i64 %2326, ptr %PC, align 8
  %2327 = add i64 %2326, 6
  store i64 %2327, ptr %NEXT_PC, align 8
  %2328 = load ptr, ptr %MEMORY, align 8
  %2329 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %2328, ptr %state, ptr %R8, i64 134217784)
  store ptr %2329, ptr %MEMORY, align 8
  %2330 = load i64, ptr %NEXT_PC, align 8
  store i64 %2330, ptr %PC, align 8
  %2331 = add i64 %2330, 4
  store i64 %2331, ptr %NEXT_PC, align 8
  %2332 = load i64, ptr %RDI, align 8
  %2333 = add i64 %2332, 32
  %2334 = load ptr, ptr %MEMORY, align 8
  %2335 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %2334, ptr %state, ptr %RCX, i64 %2333)
  store ptr %2335, ptr %MEMORY, align 8
  %2336 = load i64, ptr %NEXT_PC, align 8
  store i64 %2336, ptr %PC, align 8
  %2337 = add i64 %2336, 5
  store i64 %2337, ptr %NEXT_PC, align 8
  %2338 = load i64, ptr %NEXT_PC, align 8
  %2339 = sub i64 %2338, 644534
  %2340 = load i64, ptr %NEXT_PC, align 8
  %2341 = load ptr, ptr %MEMORY, align 8
  %2342 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2341, ptr %state, i64 %2339, ptr %NEXT_PC, i64 %2340, ptr %RETURN_PC)
  store ptr %2342, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878166:                                    ; preds = %bb_5389878146
  %2343 = load i64, ptr %NEXT_PC, align 8
  store i64 %2343, ptr %PC, align 8
  %2344 = add i64 %2343, 5
  store i64 %2344, ptr %NEXT_PC, align 8
  %2345 = load i64, ptr %RSP, align 8
  %2346 = add i64 %2345, 48
  %2347 = load ptr, ptr %MEMORY, align 8
  %2348 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2347, ptr %state, ptr %RBX, i64 %2346)
  store ptr %2348, ptr %MEMORY, align 8
  %2349 = load i64, ptr %NEXT_PC, align 8
  store i64 %2349, ptr %PC, align 8
  %2350 = add i64 %2349, 5
  store i64 %2350, ptr %NEXT_PC, align 8
  %2351 = load i64, ptr %RSP, align 8
  %2352 = add i64 %2351, 56
  %2353 = load ptr, ptr %MEMORY, align 8
  %2354 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2353, ptr %state, ptr %RSI, i64 %2352)
  store ptr %2354, ptr %MEMORY, align 8
  %2355 = load i64, ptr %NEXT_PC, align 8
  store i64 %2355, ptr %PC, align 8
  %2356 = add i64 %2355, 4
  store i64 %2356, ptr %NEXT_PC, align 8
  %2357 = load i64, ptr %RSP, align 8
  %2358 = load ptr, ptr %MEMORY, align 8
  %2359 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2358, ptr %state, ptr %RSP, i64 %2357, i64 32)
  store ptr %2359, ptr %MEMORY, align 8
  %2360 = load i64, ptr %NEXT_PC, align 8
  store i64 %2360, ptr %PC, align 8
  %2361 = add i64 %2360, 1
  store i64 %2361, ptr %NEXT_PC, align 8
  %2362 = load ptr, ptr %MEMORY, align 8
  %2363 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %2362, ptr %state, ptr %RDI)
  store ptr %2363, ptr %MEMORY, align 8
  %2364 = load i64, ptr %NEXT_PC, align 8
  store i64 %2364, ptr %PC, align 8
  %2365 = add i64 %2364, 1
  store i64 %2365, ptr %NEXT_PC, align 8
  %2366 = load ptr, ptr %MEMORY, align 8
  %2367 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %2366, ptr %state, ptr %NEXT_PC)
  store ptr %2367, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878182:                                    ; No predecessors!
  %2368 = load i64, ptr %NEXT_PC, align 8
  store i64 %2368, ptr %PC, align 8
  %2369 = add i64 %2368, 1
  store i64 %2369, ptr %NEXT_PC, align 8
  %2370 = load ptr, ptr %MEMORY, align 8
  %2371 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2370, ptr %state, ptr undef)
  store ptr %2371, ptr %MEMORY, align 8
  %2372 = load i64, ptr %NEXT_PC, align 8
  store i64 %2372, ptr %PC, align 8
  %2373 = add i64 %2372, 1
  store i64 %2373, ptr %NEXT_PC, align 8
  %2374 = load ptr, ptr %MEMORY, align 8
  %2375 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2374, ptr %state, ptr undef)
  store ptr %2375, ptr %MEMORY, align 8
  %2376 = load i64, ptr %NEXT_PC, align 8
  store i64 %2376, ptr %PC, align 8
  %2377 = add i64 %2376, 1
  store i64 %2377, ptr %NEXT_PC, align 8
  %2378 = load ptr, ptr %MEMORY, align 8
  %2379 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2378, ptr %state, ptr undef)
  store ptr %2379, ptr %MEMORY, align 8
  %2380 = load i64, ptr %NEXT_PC, align 8
  store i64 %2380, ptr %PC, align 8
  %2381 = add i64 %2380, 1
  store i64 %2381, ptr %NEXT_PC, align 8
  %2382 = load ptr, ptr %MEMORY, align 8
  %2383 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2382, ptr %state, ptr undef)
  store ptr %2383, ptr %MEMORY, align 8
  %2384 = load i64, ptr %NEXT_PC, align 8
  store i64 %2384, ptr %PC, align 8
  %2385 = add i64 %2384, 1
  store i64 %2385, ptr %NEXT_PC, align 8
  %2386 = load ptr, ptr %MEMORY, align 8
  %2387 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2386, ptr %state, ptr undef)
  store ptr %2387, ptr %MEMORY, align 8
  %2388 = load i64, ptr %NEXT_PC, align 8
  store i64 %2388, ptr %PC, align 8
  %2389 = add i64 %2388, 1
  store i64 %2389, ptr %NEXT_PC, align 8
  %2390 = load ptr, ptr %MEMORY, align 8
  %2391 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2390, ptr %state, ptr undef)
  store ptr %2391, ptr %MEMORY, align 8
  %2392 = load i64, ptr %NEXT_PC, align 8
  store i64 %2392, ptr %PC, align 8
  %2393 = add i64 %2392, 1
  store i64 %2393, ptr %NEXT_PC, align 8
  %2394 = load ptr, ptr %MEMORY, align 8
  %2395 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2394, ptr %state, ptr undef)
  store ptr %2395, ptr %MEMORY, align 8
  %2396 = load i64, ptr %NEXT_PC, align 8
  store i64 %2396, ptr %PC, align 8
  %2397 = add i64 %2396, 1
  store i64 %2397, ptr %NEXT_PC, align 8
  %2398 = load ptr, ptr %MEMORY, align 8
  %2399 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2398, ptr %state, ptr undef)
  store ptr %2399, ptr %MEMORY, align 8
  %2400 = load i64, ptr %NEXT_PC, align 8
  store i64 %2400, ptr %PC, align 8
  %2401 = add i64 %2400, 1
  store i64 %2401, ptr %NEXT_PC, align 8
  %2402 = load ptr, ptr %MEMORY, align 8
  %2403 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2402, ptr %state, ptr undef)
  store ptr %2403, ptr %MEMORY, align 8
  %2404 = load i64, ptr %NEXT_PC, align 8
  store i64 %2404, ptr %PC, align 8
  %2405 = add i64 %2404, 1
  store i64 %2405, ptr %NEXT_PC, align 8
  %2406 = load ptr, ptr %MEMORY, align 8
  %2407 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2406, ptr %state, ptr undef)
  store ptr %2407, ptr %MEMORY, align 8
  %2408 = load i64, ptr %NEXT_PC, align 8
  store i64 %2408, ptr %PC, align 8
  %2409 = add i64 %2408, 4
  store i64 %2409, ptr %NEXT_PC, align 8
  %2410 = load i64, ptr %RCX, align 8
  %2411 = add i64 %2410, 8
  %2412 = load ptr, ptr %MEMORY, align 8
  %2413 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2412, ptr %state, ptr %RAX, i64 %2411)
  store ptr %2413, ptr %MEMORY, align 8
  %2414 = load i64, ptr %NEXT_PC, align 8
  store i64 %2414, ptr %PC, align 8
  %2415 = add i64 %2414, 3
  store i64 %2415, ptr %NEXT_PC, align 8
  %2416 = load i64, ptr %RDX, align 8
  %2417 = load i64, ptr %RAX, align 8
  %2418 = load ptr, ptr %MEMORY, align 8
  %2419 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2418, ptr %state, i64 %2416, i64 %2417)
  store ptr %2419, ptr %MEMORY, align 8
  %2420 = load i64, ptr %NEXT_PC, align 8
  store i64 %2420, ptr %PC, align 8
  %2421 = add i64 %2420, 3
  store i64 %2421, ptr %NEXT_PC, align 8
  %2422 = load i64, ptr %RAX, align 8
  %2423 = load i64, ptr %RAX, align 8
  %2424 = load ptr, ptr %MEMORY, align 8
  %2425 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2424, ptr %state, i64 %2422, i64 %2423)
  store ptr %2425, ptr %MEMORY, align 8
  %2426 = load i64, ptr %NEXT_PC, align 8
  store i64 %2426, ptr %PC, align 8
  %2427 = add i64 %2426, 2
  store i64 %2427, ptr %NEXT_PC, align 8
  %2428 = load i64, ptr %NEXT_PC, align 8
  %2429 = add i64 %2428, 8
  %2430 = load i64, ptr %NEXT_PC, align 8
  %2431 = load ptr, ptr %MEMORY, align 8
  %2432 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2431, ptr %state, ptr %BRANCH_TAKEN, i64 %2429, i64 %2430, ptr %NEXT_PC)
  store ptr %2432, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878212, label %bb_5389878204

bb_5389878204:                                    ; preds = %bb_5389878182
  %2433 = load i64, ptr %NEXT_PC, align 8
  store i64 %2433, ptr %PC, align 8
  %2434 = add i64 %2433, 2
  store i64 %2434, ptr %NEXT_PC, align 8
  %2435 = load i64, ptr %RAX, align 8
  %2436 = load i64, ptr %RAX, align 8
  %2437 = load ptr, ptr %MEMORY, align 8
  %2438 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %2437, ptr %state, i64 %2435, i64 %2436)
  store ptr %2438, ptr %MEMORY, align 8
  %2439 = load i64, ptr %NEXT_PC, align 8
  store i64 %2439, ptr %PC, align 8
  %2440 = add i64 %2439, 4
  store i64 %2440, ptr %NEXT_PC, align 8
  %2441 = load i64, ptr %RAX, align 8
  %2442 = add i64 %2441, 48
  %2443 = load ptr, ptr %MEMORY, align 8
  %2444 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2443, ptr %state, ptr %RAX, i64 %2442)
  store ptr %2444, ptr %MEMORY, align 8
  %2445 = load i64, ptr %NEXT_PC, align 8
  store i64 %2445, ptr %PC, align 8
  %2446 = add i64 %2445, 2
  store i64 %2446, ptr %NEXT_PC, align 8
  %2447 = load i64, ptr %RAX, align 8
  %2448 = load i64, ptr %RAX, align 8
  %2449 = load ptr, ptr %MEMORY, align 8
  %2450 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %2449, ptr %state, i64 %2447, i64 %2448)
  store ptr %2450, ptr %MEMORY, align 8
  br label %bb_5389878212

bb_5389878212:                                    ; preds = %bb_5389878204, %bb_5389878182
  %2451 = load i64, ptr %NEXT_PC, align 8
  store i64 %2451, ptr %PC, align 8
  %2452 = add i64 %2451, 3
  store i64 %2452, ptr %NEXT_PC, align 8
  %2453 = load i64, ptr %RDX, align 8
  %2454 = load ptr, ptr %MEMORY, align 8
  %2455 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2454, ptr %state, ptr %RAX, i64 %2453)
  store ptr %2455, ptr %MEMORY, align 8
  %2456 = load i64, ptr %NEXT_PC, align 8
  store i64 %2456, ptr %PC, align 8
  %2457 = add i64 %2456, 1
  store i64 %2457, ptr %NEXT_PC, align 8
  %2458 = load ptr, ptr %MEMORY, align 8
  %2459 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %2458, ptr %state, ptr %NEXT_PC)
  store ptr %2459, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878216:                                    ; No predecessors!
  %2460 = load i64, ptr %NEXT_PC, align 8
  store i64 %2460, ptr %PC, align 8
  %2461 = add i64 %2460, 1
  store i64 %2461, ptr %NEXT_PC, align 8
  %2462 = load ptr, ptr %MEMORY, align 8
  %2463 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2462, ptr %state, ptr undef)
  store ptr %2463, ptr %MEMORY, align 8
  %2464 = load i64, ptr %NEXT_PC, align 8
  store i64 %2464, ptr %PC, align 8
  %2465 = add i64 %2464, 1
  store i64 %2465, ptr %NEXT_PC, align 8
  %2466 = load ptr, ptr %MEMORY, align 8
  %2467 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2466, ptr %state, ptr undef)
  store ptr %2467, ptr %MEMORY, align 8
  %2468 = load i64, ptr %NEXT_PC, align 8
  store i64 %2468, ptr %PC, align 8
  %2469 = add i64 %2468, 1
  store i64 %2469, ptr %NEXT_PC, align 8
  %2470 = load ptr, ptr %MEMORY, align 8
  %2471 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2470, ptr %state, ptr undef)
  store ptr %2471, ptr %MEMORY, align 8
  %2472 = load i64, ptr %NEXT_PC, align 8
  store i64 %2472, ptr %PC, align 8
  %2473 = add i64 %2472, 1
  store i64 %2473, ptr %NEXT_PC, align 8
  %2474 = load ptr, ptr %MEMORY, align 8
  %2475 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2474, ptr %state, ptr undef)
  store ptr %2475, ptr %MEMORY, align 8
  %2476 = load i64, ptr %NEXT_PC, align 8
  store i64 %2476, ptr %PC, align 8
  %2477 = add i64 %2476, 1
  store i64 %2477, ptr %NEXT_PC, align 8
  %2478 = load ptr, ptr %MEMORY, align 8
  %2479 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2478, ptr %state, ptr undef)
  store ptr %2479, ptr %MEMORY, align 8
  %2480 = load i64, ptr %NEXT_PC, align 8
  store i64 %2480, ptr %PC, align 8
  %2481 = add i64 %2480, 1
  store i64 %2481, ptr %NEXT_PC, align 8
  %2482 = load ptr, ptr %MEMORY, align 8
  %2483 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2482, ptr %state, ptr undef)
  store ptr %2483, ptr %MEMORY, align 8
  %2484 = load i64, ptr %NEXT_PC, align 8
  store i64 %2484, ptr %PC, align 8
  %2485 = add i64 %2484, 1
  store i64 %2485, ptr %NEXT_PC, align 8
  %2486 = load ptr, ptr %MEMORY, align 8
  %2487 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2486, ptr %state, ptr undef)
  store ptr %2487, ptr %MEMORY, align 8
  %2488 = load i64, ptr %NEXT_PC, align 8
  store i64 %2488, ptr %PC, align 8
  %2489 = add i64 %2488, 1
  store i64 %2489, ptr %NEXT_PC, align 8
  %2490 = load ptr, ptr %MEMORY, align 8
  %2491 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %2490, ptr %state, ptr undef)
  store ptr %2491, ptr %MEMORY, align 8
  %2492 = load i64, ptr %NEXT_PC, align 8
  store i64 %2492, ptr %PC, align 8
  %2493 = add i64 %2492, 2
  store i64 %2493, ptr %NEXT_PC, align 8
  %2494 = load i64, ptr %RBX, align 8
  %2495 = load ptr, ptr %MEMORY, align 8
  %2496 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %2495, ptr %state, i64 %2494)
  store ptr %2496, ptr %MEMORY, align 8
  %2497 = load i64, ptr %NEXT_PC, align 8
  store i64 %2497, ptr %PC, align 8
  %2498 = add i64 %2497, 4
  store i64 %2498, ptr %NEXT_PC, align 8
  %2499 = load i64, ptr %RSP, align 8
  %2500 = load ptr, ptr %MEMORY, align 8
  %2501 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2500, ptr %state, ptr %RSP, i64 %2499, i64 32)
  store ptr %2501, ptr %MEMORY, align 8
  %2502 = load i64, ptr %NEXT_PC, align 8
  store i64 %2502, ptr %PC, align 8
  %2503 = add i64 %2502, 3
  store i64 %2503, ptr %NEXT_PC, align 8
  %2504 = load i64, ptr %RCX, align 8
  %2505 = load ptr, ptr %MEMORY, align 8
  %2506 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2505, ptr %state, ptr %RBX, i64 %2504)
  store ptr %2506, ptr %MEMORY, align 8
  %2507 = load i64, ptr %NEXT_PC, align 8
  store i64 %2507, ptr %PC, align 8
  %2508 = add i64 %2507, 4
  store i64 %2508, ptr %NEXT_PC, align 8
  %2509 = load i64, ptr %RCX, align 8
  %2510 = add i64 %2509, 8
  %2511 = load i64, ptr %RDX, align 8
  %2512 = load ptr, ptr %MEMORY, align 8
  %2513 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %2512, ptr %state, i64 %2510, i64 %2511)
  store ptr %2513, ptr %MEMORY, align 8
  %2514 = load i64, ptr %NEXT_PC, align 8
  store i64 %2514, ptr %PC, align 8
  %2515 = add i64 %2514, 6
  store i64 %2515, ptr %NEXT_PC, align 8
  %2516 = load i64, ptr %NEXT_PC, align 8
  %2517 = add i64 %2516, 281
  %2518 = load i64, ptr %NEXT_PC, align 8
  %2519 = load ptr, ptr %MEMORY, align 8
  %2520 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2519, ptr %state, ptr %BRANCH_TAKEN, i64 %2517, i64 %2518, ptr %NEXT_PC)
  store ptr %2520, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878524, label %bb_5389878243

bb_5389878243:                                    ; preds = %bb_5389878216
  %2521 = load i64, ptr %NEXT_PC, align 8
  store i64 %2521, ptr %PC, align 8
  %2522 = add i64 %2521, 5
  store i64 %2522, ptr %NEXT_PC, align 8
  %2523 = load i64, ptr %RSP, align 8
  %2524 = add i64 %2523, 48
  %2525 = load i64, ptr %RBP, align 8
  %2526 = load ptr, ptr %MEMORY, align 8
  %2527 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2526, ptr %state, i64 %2524, i64 %2525)
  store ptr %2527, ptr %MEMORY, align 8
  %2528 = load i64, ptr %NEXT_PC, align 8
  store i64 %2528, ptr %PC, align 8
  %2529 = add i64 %2528, 4
  store i64 %2529, ptr %NEXT_PC, align 8
  %2530 = load i64, ptr %RCX, align 8
  %2531 = add i64 %2530, 48
  %2532 = load ptr, ptr %MEMORY, align 8
  %2533 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2532, ptr %state, ptr %RBP, i64 %2531)
  store ptr %2533, ptr %MEMORY, align 8
  %2534 = load i64, ptr %NEXT_PC, align 8
  store i64 %2534, ptr %PC, align 8
  %2535 = add i64 %2534, 3
  store i64 %2535, ptr %NEXT_PC, align 8
  %2536 = load i64, ptr %RDX, align 8
  %2537 = load i64, ptr %RDX, align 8
  %2538 = load ptr, ptr %MEMORY, align 8
  %2539 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2538, ptr %state, i64 %2536, i64 %2537)
  store ptr %2539, ptr %MEMORY, align 8
  %2540 = load i64, ptr %NEXT_PC, align 8
  store i64 %2540, ptr %PC, align 8
  %2541 = add i64 %2540, 2
  store i64 %2541, ptr %NEXT_PC, align 8
  %2542 = load i64, ptr %NEXT_PC, align 8
  %2543 = add i64 %2542, 16
  %2544 = load i64, ptr %NEXT_PC, align 8
  %2545 = load ptr, ptr %MEMORY, align 8
  %2546 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2545, ptr %state, ptr %BRANCH_TAKEN, i64 %2543, i64 %2544, ptr %NEXT_PC)
  store ptr %2546, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878273, label %bb_5389878257

bb_5389878257:                                    ; preds = %bb_5389878243
  %2547 = load i64, ptr %NEXT_PC, align 8
  store i64 %2547, ptr %PC, align 8
  %2548 = add i64 %2547, 4
  store i64 %2548, ptr %NEXT_PC, align 8
  %2549 = load i64, ptr %RDX, align 8
  %2550 = add i64 %2549, 48
  %2551 = load i64, ptr %RBP, align 8
  %2552 = load ptr, ptr %MEMORY, align 8
  %2553 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %2552, ptr %state, i64 %2550, i64 %2551)
  store ptr %2553, ptr %MEMORY, align 8
  %2554 = load i64, ptr %NEXT_PC, align 8
  store i64 %2554, ptr %PC, align 8
  %2555 = add i64 %2554, 2
  store i64 %2555, ptr %NEXT_PC, align 8
  %2556 = load i64, ptr %NEXT_PC, align 8
  %2557 = add i64 %2556, 10
  %2558 = load i64, ptr %NEXT_PC, align 8
  %2559 = load ptr, ptr %MEMORY, align 8
  %2560 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2559, ptr %state, ptr %BRANCH_TAKEN, i64 %2557, i64 %2558, ptr %NEXT_PC)
  store ptr %2560, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878273, label %bb_5389878263

bb_5389878263:                                    ; preds = %bb_5389878257
  %2561 = load i64, ptr %NEXT_PC, align 8
  store i64 %2561, ptr %PC, align 8
  %2562 = add i64 %2561, 4
  store i64 %2562, ptr %NEXT_PC, align 8
  %2563 = load i64, ptr %RCX, align 8
  %2564 = load i64, ptr %RBP, align 8
  %2565 = add i64 %2564, 8
  %2566 = load ptr, ptr %MEMORY, align 8
  %2567 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2566, ptr %state, i64 %2563, i64 %2565)
  store ptr %2567, ptr %MEMORY, align 8
  %2568 = load i64, ptr %NEXT_PC, align 8
  store i64 %2568, ptr %PC, align 8
  %2569 = add i64 %2568, 6
  store i64 %2569, ptr %NEXT_PC, align 8
  %2570 = load i64, ptr %NEXT_PC, align 8
  %2571 = add i64 %2570, 246
  %2572 = load i64, ptr %NEXT_PC, align 8
  %2573 = load ptr, ptr %MEMORY, align 8
  %2574 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2573, ptr %state, ptr %BRANCH_TAKEN, i64 %2571, i64 %2572, ptr %NEXT_PC)
  store ptr %2574, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878519, label %bb_5389878273

bb_5389878273:                                    ; preds = %bb_5389878263, %bb_5389878257, %bb_5389878243
  %2575 = load i64, ptr %NEXT_PC, align 8
  store i64 %2575, ptr %PC, align 8
  %2576 = add i64 %2575, 5
  store i64 %2576, ptr %NEXT_PC, align 8
  %2577 = load i64, ptr %RSP, align 8
  %2578 = add i64 %2577, 64
  %2579 = load i64, ptr %RDI, align 8
  %2580 = load ptr, ptr %MEMORY, align 8
  %2581 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2580, ptr %state, i64 %2578, i64 %2579)
  store ptr %2581, ptr %MEMORY, align 8
  %2582 = load i64, ptr %NEXT_PC, align 8
  store i64 %2582, ptr %PC, align 8
  %2583 = add i64 %2582, 5
  store i64 %2583, ptr %NEXT_PC, align 8
  %2584 = load i64, ptr %RSP, align 8
  %2585 = add i64 %2584, 72
  %2586 = load i64, ptr %R14, align 8
  %2587 = load ptr, ptr %MEMORY, align 8
  %2588 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2587, ptr %state, i64 %2585, i64 %2586)
  store ptr %2588, ptr %MEMORY, align 8
  %2589 = load i64, ptr %NEXT_PC, align 8
  store i64 %2589, ptr %PC, align 8
  %2590 = add i64 %2589, 3
  store i64 %2590, ptr %NEXT_PC, align 8
  %2591 = load i64, ptr %R14, align 8
  %2592 = load i32, ptr %R14D, align 4
  %2593 = zext i32 %2592 to i64
  %2594 = load ptr, ptr %MEMORY, align 8
  %2595 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2594, ptr %state, ptr %R14, i64 %2591, i64 %2593)
  store ptr %2595, ptr %MEMORY, align 8
  %2596 = load i64, ptr %NEXT_PC, align 8
  store i64 %2596, ptr %PC, align 8
  %2597 = add i64 %2596, 4
  store i64 %2597, ptr %NEXT_PC, align 8
  %2598 = load i64, ptr %RCX, align 8
  %2599 = add i64 %2598, 8
  %2600 = load i64, ptr %RDX, align 8
  %2601 = load ptr, ptr %MEMORY, align 8
  %2602 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2601, ptr %state, i64 %2599, i64 %2600)
  store ptr %2602, ptr %MEMORY, align 8
  %2603 = load i64, ptr %NEXT_PC, align 8
  store i64 %2603, ptr %PC, align 8
  %2604 = add i64 %2603, 3
  store i64 %2604, ptr %NEXT_PC, align 8
  %2605 = load i64, ptr %RDX, align 8
  %2606 = load i64, ptr %RDX, align 8
  %2607 = load ptr, ptr %MEMORY, align 8
  %2608 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2607, ptr %state, i64 %2605, i64 %2606)
  store ptr %2608, ptr %MEMORY, align 8
  %2609 = load i64, ptr %NEXT_PC, align 8
  store i64 %2609, ptr %PC, align 8
  %2610 = add i64 %2609, 2
  store i64 %2610, ptr %NEXT_PC, align 8
  %2611 = load i64, ptr %NEXT_PC, align 8
  %2612 = add i64 %2611, 6
  %2613 = load i64, ptr %NEXT_PC, align 8
  %2614 = load ptr, ptr %MEMORY, align 8
  %2615 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2614, ptr %state, ptr %BRANCH_TAKEN, i64 %2612, i64 %2613, ptr %NEXT_PC)
  store ptr %2615, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878301, label %bb_5389878295

bb_5389878295:                                    ; preds = %bb_5389878273
  %2616 = load i64, ptr %NEXT_PC, align 8
  store i64 %2616, ptr %PC, align 8
  %2617 = add i64 %2616, 4
  store i64 %2617, ptr %NEXT_PC, align 8
  %2618 = load i64, ptr %RDX, align 8
  %2619 = add i64 %2618, 48
  %2620 = load ptr, ptr %MEMORY, align 8
  %2621 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2620, ptr %state, ptr %RAX, i64 %2619)
  store ptr %2621, ptr %MEMORY, align 8
  %2622 = load i64, ptr %NEXT_PC, align 8
  store i64 %2622, ptr %PC, align 8
  %2623 = add i64 %2622, 2
  store i64 %2623, ptr %NEXT_PC, align 8
  %2624 = load i64, ptr %NEXT_PC, align 8
  %2625 = add i64 %2624, 46
  %2626 = load ptr, ptr %MEMORY, align 8
  %2627 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %2626, ptr %state, i64 %2625, ptr %NEXT_PC)
  store ptr %2627, ptr %MEMORY, align 8
  br label %bb_5389878347

bb_5389878301:                                    ; preds = %bb_5389878273
  %2628 = load i64, ptr %NEXT_PC, align 8
  store i64 %2628, ptr %PC, align 8
  %2629 = add i64 %2628, 2
  store i64 %2629, ptr %NEXT_PC, align 8
  %2630 = load i64, ptr %RDX, align 8
  %2631 = load i32, ptr %EDX, align 4
  %2632 = zext i32 %2631 to i64
  %2633 = load ptr, ptr %MEMORY, align 8
  %2634 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2633, ptr %state, ptr %RDX, i64 %2630, i64 %2632)
  store ptr %2634, ptr %MEMORY, align 8
  %2635 = load i64, ptr %NEXT_PC, align 8
  store i64 %2635, ptr %PC, align 8
  %2636 = add i64 %2635, 3
  store i64 %2636, ptr %NEXT_PC, align 8
  %2637 = load i64, ptr %R9, align 8
  %2638 = load i32, ptr %R9D, align 4
  %2639 = zext i32 %2638 to i64
  %2640 = load ptr, ptr %MEMORY, align 8
  %2641 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2640, ptr %state, ptr %R9, i64 %2637, i64 %2639)
  store ptr %2641, ptr %MEMORY, align 8
  %2642 = load i64, ptr %NEXT_PC, align 8
  store i64 %2642, ptr %PC, align 8
  %2643 = add i64 %2642, 3
  store i64 %2643, ptr %NEXT_PC, align 8
  %2644 = load i64, ptr %R8, align 8
  %2645 = load i32, ptr %R8D, align 4
  %2646 = zext i32 %2645 to i64
  %2647 = load ptr, ptr %MEMORY, align 8
  %2648 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2647, ptr %state, ptr %R8, i64 %2644, i64 %2646)
  store ptr %2648, ptr %MEMORY, align 8
  %2649 = load i64, ptr %NEXT_PC, align 8
  store i64 %2649, ptr %PC, align 8
  %2650 = add i64 %2649, 3
  store i64 %2650, ptr %NEXT_PC, align 8
  %2651 = load i64, ptr %RDX, align 8
  %2652 = add i64 %2651, 24
  %2653 = load ptr, ptr %MEMORY, align 8
  %2654 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %2653, ptr %state, ptr %RCX, i64 %2652)
  store ptr %2654, ptr %MEMORY, align 8
  %2655 = load i64, ptr %NEXT_PC, align 8
  store i64 %2655, ptr %PC, align 8
  %2656 = add i64 %2655, 5
  store i64 %2656, ptr %NEXT_PC, align 8
  %2657 = load i64, ptr %NEXT_PC, align 8
  %2658 = sub i64 %2657, 1159245
  %2659 = load i64, ptr %NEXT_PC, align 8
  %2660 = load ptr, ptr %MEMORY, align 8
  %2661 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2660, ptr %state, i64 %2658, ptr %NEXT_PC, i64 %2659, ptr %RETURN_PC)
  store ptr %2661, ptr %MEMORY, align 8
  %2662 = load i64, ptr %NEXT_PC, align 8
  store i64 %2662, ptr %PC, align 8
  %2663 = add i64 %2662, 3
  store i64 %2663, ptr %NEXT_PC, align 8
  %2664 = load i64, ptr %RAX, align 8
  %2665 = load i64, ptr %RAX, align 8
  %2666 = load ptr, ptr %MEMORY, align 8
  %2667 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2666, ptr %state, i64 %2664, i64 %2665)
  store ptr %2667, ptr %MEMORY, align 8
  %2668 = load i64, ptr %NEXT_PC, align 8
  store i64 %2668, ptr %PC, align 8
  %2669 = add i64 %2668, 2
  store i64 %2669, ptr %NEXT_PC, align 8
  %2670 = load i64, ptr %NEXT_PC, align 8
  %2671 = add i64 %2670, 22
  %2672 = load i64, ptr %NEXT_PC, align 8
  %2673 = load ptr, ptr %MEMORY, align 8
  %2674 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2673, ptr %state, ptr %BRANCH_TAKEN, i64 %2671, i64 %2672, ptr %NEXT_PC)
  store ptr %2674, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878344, label %bb_5389878322

bb_5389878322:                                    ; preds = %bb_5389878301
  %2675 = load i64, ptr %NEXT_PC, align 8
  store i64 %2675, ptr %PC, align 8
  %2676 = add i64 %2675, 4
  store i64 %2676, ptr %NEXT_PC, align 8
  %2677 = load i64, ptr %RAX, align 8
  %2678 = add i64 %2677, 16
  %2679 = load ptr, ptr %MEMORY, align 8
  %2680 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %2679, ptr %state, ptr %RCX, i64 %2678)
  store ptr %2680, ptr %MEMORY, align 8
  %2681 = load i64, ptr %NEXT_PC, align 8
  store i64 %2681, ptr %PC, align 8
  %2682 = add i64 %2681, 3
  store i64 %2682, ptr %NEXT_PC, align 8
  %2683 = load i8, ptr %CL, align 1
  %2684 = zext i8 %2683 to i64
  %2685 = load ptr, ptr %MEMORY, align 8
  %2686 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2685, ptr %state, ptr %CL, i64 %2684, i64 253)
  store ptr %2686, ptr %MEMORY, align 8
  %2687 = load i64, ptr %NEXT_PC, align 8
  store i64 %2687, ptr %PC, align 8
  %2688 = add i64 %2687, 4
  store i64 %2688, ptr %NEXT_PC, align 8
  %2689 = load i64, ptr %RAX, align 8
  %2690 = add i64 %2689, 8
  %2691 = load i64, ptr %RBX, align 8
  %2692 = load ptr, ptr %MEMORY, align 8
  %2693 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2692, ptr %state, i64 %2690, i64 %2691)
  store ptr %2693, ptr %MEMORY, align 8
  %2694 = load i64, ptr %NEXT_PC, align 8
  store i64 %2694, ptr %PC, align 8
  %2695 = add i64 %2694, 3
  store i64 %2695, ptr %NEXT_PC, align 8
  %2696 = load i8, ptr %CL, align 1
  %2697 = zext i8 %2696 to i64
  %2698 = load ptr, ptr %MEMORY, align 8
  %2699 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2698, ptr %state, ptr %CL, i64 %2697, i64 1)
  store ptr %2699, ptr %MEMORY, align 8
  %2700 = load i64, ptr %NEXT_PC, align 8
  store i64 %2700, ptr %PC, align 8
  %2701 = add i64 %2700, 3
  store i64 %2701, ptr %NEXT_PC, align 8
  %2702 = load i64, ptr %RAX, align 8
  %2703 = load i32, ptr %R14D, align 4
  %2704 = zext i32 %2703 to i64
  %2705 = load ptr, ptr %MEMORY, align 8
  %2706 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2705, ptr %state, i64 %2702, i64 %2704)
  store ptr %2706, ptr %MEMORY, align 8
  %2707 = load i64, ptr %NEXT_PC, align 8
  store i64 %2707, ptr %PC, align 8
  %2708 = add i64 %2707, 3
  store i64 %2708, ptr %NEXT_PC, align 8
  %2709 = load i64, ptr %RAX, align 8
  %2710 = add i64 %2709, 16
  %2711 = load i8, ptr %CL, align 1
  %2712 = zext i8 %2711 to i64
  %2713 = load ptr, ptr %MEMORY, align 8
  %2714 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2713, ptr %state, i64 %2710, i64 %2712)
  store ptr %2714, ptr %MEMORY, align 8
  %2715 = load i64, ptr %NEXT_PC, align 8
  store i64 %2715, ptr %PC, align 8
  %2716 = add i64 %2715, 2
  store i64 %2716, ptr %NEXT_PC, align 8
  %2717 = load i64, ptr %NEXT_PC, align 8
  %2718 = add i64 %2717, 3
  %2719 = load ptr, ptr %MEMORY, align 8
  %2720 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %2719, ptr %state, i64 %2718, ptr %NEXT_PC)
  store ptr %2720, ptr %MEMORY, align 8
  br label %bb_5389878347

bb_5389878344:                                    ; preds = %bb_5389878301
  %2721 = load i64, ptr %NEXT_PC, align 8
  store i64 %2721, ptr %PC, align 8
  %2722 = add i64 %2721, 3
  store i64 %2722, ptr %NEXT_PC, align 8
  %2723 = load i64, ptr %R14, align 8
  %2724 = load ptr, ptr %MEMORY, align 8
  %2725 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2724, ptr %state, ptr %RAX, i64 %2723)
  store ptr %2725, ptr %MEMORY, align 8
  br label %bb_5389878347

bb_5389878347:                                    ; preds = %bb_5389878344, %bb_5389878322, %bb_5389878295
  %2726 = load i64, ptr %NEXT_PC, align 8
  store i64 %2726, ptr %PC, align 8
  %2727 = add i64 %2726, 4
  store i64 %2727, ptr %NEXT_PC, align 8
  %2728 = load i64, ptr %RBX, align 8
  %2729 = add i64 %2728, 48
  %2730 = load i64, ptr %RAX, align 8
  %2731 = load ptr, ptr %MEMORY, align 8
  %2732 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2731, ptr %state, i64 %2729, i64 %2730)
  store ptr %2732, ptr %MEMORY, align 8
  %2733 = load i64, ptr %NEXT_PC, align 8
  store i64 %2733, ptr %PC, align 8
  %2734 = add i64 %2733, 3
  store i64 %2734, ptr %NEXT_PC, align 8
  %2735 = load i32, ptr %R14D, align 4
  %2736 = zext i32 %2735 to i64
  %2737 = load ptr, ptr %MEMORY, align 8
  %2738 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2737, ptr %state, ptr %RDI, i64 %2736)
  store ptr %2738, ptr %MEMORY, align 8
  %2739 = load i64, ptr %NEXT_PC, align 8
  store i64 %2739, ptr %PC, align 8
  %2740 = add i64 %2739, 4
  store i64 %2740, ptr %NEXT_PC, align 8
  %2741 = load i64, ptr %RBX, align 8
  %2742 = add i64 %2741, 40
  %2743 = load i32, ptr %R14D, align 4
  %2744 = zext i32 %2743 to i64
  %2745 = load ptr, ptr %MEMORY, align 8
  %2746 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %2745, ptr %state, i64 %2742, i64 %2744)
  store ptr %2746, ptr %MEMORY, align 8
  %2747 = load i64, ptr %NEXT_PC, align 8
  store i64 %2747, ptr %PC, align 8
  %2748 = add i64 %2747, 2
  store i64 %2748, ptr %NEXT_PC, align 8
  %2749 = load i64, ptr %NEXT_PC, align 8
  %2750 = add i64 %2749, 94
  %2751 = load i64, ptr %NEXT_PC, align 8
  %2752 = load ptr, ptr %MEMORY, align 8
  %2753 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2752, ptr %state, ptr %BRANCH_TAKEN, i64 %2750, i64 %2751, ptr %NEXT_PC)
  store ptr %2753, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878454, label %bb_5389878360

bb_5389878360:                                    ; preds = %bb_5389878347
  %2754 = load i64, ptr %NEXT_PC, align 8
  store i64 %2754, ptr %PC, align 8
  %2755 = add i64 %2754, 5
  store i64 %2755, ptr %NEXT_PC, align 8
  %2756 = load i64, ptr %RSP, align 8
  %2757 = add i64 %2756, 56
  %2758 = load i64, ptr %RSI, align 8
  %2759 = load ptr, ptr %MEMORY, align 8
  %2760 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2759, ptr %state, i64 %2757, i64 %2758)
  store ptr %2760, ptr %MEMORY, align 8
  %2761 = load i64, ptr %NEXT_PC, align 8
  store i64 %2761, ptr %PC, align 8
  %2762 = add i64 %2761, 3
  store i64 %2762, ptr %NEXT_PC, align 8
  %2763 = load i64, ptr %R14, align 8
  %2764 = load ptr, ptr %MEMORY, align 8
  %2765 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2764, ptr %state, ptr %RSI, i64 %2763)
  store ptr %2765, ptr %MEMORY, align 8
  br label %bb_5389878368

bb_5389878368:                                    ; preds = %bb_5389878438, %bb_5389878360
  %2766 = load i64, ptr %NEXT_PC, align 8
  store i64 %2766, ptr %PC, align 8
  %2767 = add i64 %2766, 4
  store i64 %2767, ptr %NEXT_PC, align 8
  %2768 = load i64, ptr %RBX, align 8
  %2769 = add i64 %2768, 32
  %2770 = load ptr, ptr %MEMORY, align 8
  %2771 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2770, ptr %state, ptr %RDX, i64 %2769)
  store ptr %2771, ptr %MEMORY, align 8
  %2772 = load i64, ptr %NEXT_PC, align 8
  store i64 %2772, ptr %PC, align 8
  %2773 = add i64 %2772, 4
  store i64 %2773, ptr %NEXT_PC, align 8
  %2774 = load i64, ptr %RDX, align 8
  %2775 = load ptr, ptr %MEMORY, align 8
  %2776 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2775, ptr %state, ptr %RDX, i64 %2774, i64 8)
  store ptr %2776, ptr %MEMORY, align 8
  %2777 = load i64, ptr %NEXT_PC, align 8
  store i64 %2777, ptr %PC, align 8
  %2778 = add i64 %2777, 3
  store i64 %2778, ptr %NEXT_PC, align 8
  %2779 = load i64, ptr %RDX, align 8
  %2780 = load i64, ptr %RSI, align 8
  %2781 = load ptr, ptr %MEMORY, align 8
  %2782 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %2781, ptr %state, ptr %RDX, i64 %2779, i64 %2780)
  store ptr %2782, ptr %MEMORY, align 8
  %2783 = load i64, ptr %NEXT_PC, align 8
  store i64 %2783, ptr %PC, align 8
  %2784 = add i64 %2783, 4
  store i64 %2784, ptr %NEXT_PC, align 8
  %2785 = load i64, ptr %RDX, align 8
  %2786 = add i64 %2785, 32
  %2787 = load ptr, ptr %MEMORY, align 8
  %2788 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2787, ptr %state, ptr %RCX, i64 %2786)
  store ptr %2788, ptr %MEMORY, align 8
  %2789 = load i64, ptr %NEXT_PC, align 8
  store i64 %2789, ptr %PC, align 8
  %2790 = add i64 %2789, 7
  store i64 %2790, ptr %NEXT_PC, align 8
  %2791 = load i64, ptr %RCX, align 8
  %2792 = load i64, ptr %NEXT_PC, align 8
  %2793 = add i64 %2792, 27073082
  %2794 = load ptr, ptr %MEMORY, align 8
  %2795 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2794, ptr %state, i64 %2791, i64 %2793)
  store ptr %2795, ptr %MEMORY, align 8
  %2796 = load i64, ptr %NEXT_PC, align 8
  store i64 %2796, ptr %PC, align 8
  %2797 = add i64 %2796, 2
  store i64 %2797, ptr %NEXT_PC, align 8
  %2798 = load i64, ptr %NEXT_PC, align 8
  %2799 = add i64 %2798, 46
  %2800 = load i64, ptr %NEXT_PC, align 8
  %2801 = load ptr, ptr %MEMORY, align 8
  %2802 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2801, ptr %state, ptr %BRANCH_TAKEN, i64 %2799, i64 %2800, ptr %NEXT_PC)
  store ptr %2802, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878438, label %bb_5389878392

bb_5389878392:                                    ; preds = %bb_5389878368
  %2803 = load i64, ptr %NEXT_PC, align 8
  store i64 %2803, ptr %PC, align 8
  %2804 = add i64 %2803, 3
  store i64 %2804, ptr %NEXT_PC, align 8
  %2805 = load i64, ptr %RCX, align 8
  %2806 = load i64, ptr %RCX, align 8
  %2807 = load ptr, ptr %MEMORY, align 8
  %2808 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2807, ptr %state, i64 %2805, i64 %2806)
  store ptr %2808, ptr %MEMORY, align 8
  %2809 = load i64, ptr %NEXT_PC, align 8
  store i64 %2809, ptr %PC, align 8
  %2810 = add i64 %2809, 2
  store i64 %2810, ptr %NEXT_PC, align 8
  %2811 = load i64, ptr %NEXT_PC, align 8
  %2812 = add i64 %2811, 5
  %2813 = load i64, ptr %NEXT_PC, align 8
  %2814 = load ptr, ptr %MEMORY, align 8
  %2815 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2814, ptr %state, ptr %BRANCH_TAKEN, i64 %2812, i64 %2813, ptr %NEXT_PC)
  store ptr %2815, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878402, label %bb_5389878397

bb_5389878397:                                    ; preds = %bb_5389878392
  %2816 = load i64, ptr %NEXT_PC, align 8
  store i64 %2816, ptr %PC, align 8
  %2817 = add i64 %2816, 3
  store i64 %2817, ptr %NEXT_PC, align 8
  %2818 = load i64, ptr %R14, align 8
  %2819 = load ptr, ptr %MEMORY, align 8
  %2820 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2819, ptr %state, ptr %RAX, i64 %2818)
  store ptr %2820, ptr %MEMORY, align 8
  %2821 = load i64, ptr %NEXT_PC, align 8
  store i64 %2821, ptr %PC, align 8
  %2822 = add i64 %2821, 2
  store i64 %2822, ptr %NEXT_PC, align 8
  %2823 = load i64, ptr %NEXT_PC, align 8
  %2824 = add i64 %2823, 6
  %2825 = load ptr, ptr %MEMORY, align 8
  %2826 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %2825, ptr %state, i64 %2824, ptr %NEXT_PC)
  store ptr %2826, ptr %MEMORY, align 8
  br label %bb_5389878408

bb_5389878402:                                    ; preds = %bb_5389878392
  %2827 = load i64, ptr %NEXT_PC, align 8
  store i64 %2827, ptr %PC, align 8
  %2828 = add i64 %2827, 3
  store i64 %2828, ptr %NEXT_PC, align 8
  %2829 = load i64, ptr %RCX, align 8
  %2830 = load ptr, ptr %MEMORY, align 8
  %2831 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2830, ptr %state, ptr %RAX, i64 %2829)
  store ptr %2831, ptr %MEMORY, align 8
  %2832 = load i64, ptr %NEXT_PC, align 8
  store i64 %2832, ptr %PC, align 8
  %2833 = add i64 %2832, 3
  store i64 %2833, ptr %NEXT_PC, align 8
  %2834 = load i64, ptr %RAX, align 8
  %2835 = add i64 %2834, 48
  %2836 = load i64, ptr %NEXT_PC, align 8
  %2837 = load ptr, ptr %MEMORY, align 8
  %2838 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %2837, ptr %state, i64 %2835, ptr %NEXT_PC, i64 %2836, ptr %RETURN_PC)
  store ptr %2838, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878408:                                    ; preds = %bb_5389878397
  %2839 = load i64, ptr %NEXT_PC, align 8
  store i64 %2839, ptr %PC, align 8
  %2840 = add i64 %2839, 3
  store i64 %2840, ptr %NEXT_PC, align 8
  %2841 = load i64, ptr %RAX, align 8
  %2842 = load ptr, ptr %MEMORY, align 8
  %2843 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2842, ptr %state, ptr %RCX, i64 %2841)
  store ptr %2843, ptr %MEMORY, align 8
  %2844 = load i64, ptr %NEXT_PC, align 8
  store i64 %2844, ptr %PC, align 8
  %2845 = add i64 %2844, 3
  store i64 %2845, ptr %NEXT_PC, align 8
  %2846 = load i64, ptr %RCX, align 8
  %2847 = load i64, ptr %RCX, align 8
  %2848 = load ptr, ptr %MEMORY, align 8
  %2849 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2848, ptr %state, i64 %2846, i64 %2847)
  store ptr %2849, ptr %MEMORY, align 8
  %2850 = load i64, ptr %NEXT_PC, align 8
  store i64 %2850, ptr %PC, align 8
  %2851 = add i64 %2850, 2
  store i64 %2851, ptr %NEXT_PC, align 8
  %2852 = load i64, ptr %NEXT_PC, align 8
  %2853 = add i64 %2852, 22
  %2854 = load i64, ptr %NEXT_PC, align 8
  %2855 = load ptr, ptr %MEMORY, align 8
  %2856 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2855, ptr %state, ptr %BRANCH_TAKEN, i64 %2853, i64 %2854, ptr %NEXT_PC)
  store ptr %2856, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878438, label %bb_5389878416

bb_5389878416:                                    ; preds = %bb_5389878408
  %2857 = load i64, ptr %NEXT_PC, align 8
  store i64 %2857, ptr %PC, align 8
  %2858 = add i64 %2857, 4
  store i64 %2858, ptr %NEXT_PC, align 8
  %2859 = load i64, ptr %RCX, align 8
  %2860 = add i64 %2859, 8
  %2861 = load i64, ptr %RBX, align 8
  %2862 = load ptr, ptr %MEMORY, align 8
  %2863 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %2862, ptr %state, i64 %2860, i64 %2861)
  store ptr %2863, ptr %MEMORY, align 8
  %2864 = load i64, ptr %NEXT_PC, align 8
  store i64 %2864, ptr %PC, align 8
  %2865 = add i64 %2864, 2
  store i64 %2865, ptr %NEXT_PC, align 8
  %2866 = load i64, ptr %NEXT_PC, align 8
  %2867 = add i64 %2866, 16
  %2868 = load i64, ptr %NEXT_PC, align 8
  %2869 = load ptr, ptr %MEMORY, align 8
  %2870 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2869, ptr %state, ptr %BRANCH_TAKEN, i64 %2867, i64 %2868, ptr %NEXT_PC)
  store ptr %2870, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878438, label %bb_5389878422

bb_5389878422:                                    ; preds = %bb_5389878416
  %2871 = load i64, ptr %NEXT_PC, align 8
  store i64 %2871, ptr %PC, align 8
  %2872 = add i64 %2871, 3
  store i64 %2872, ptr %NEXT_PC, align 8
  %2873 = load i64, ptr %RBX, align 8
  %2874 = load ptr, ptr %MEMORY, align 8
  %2875 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2874, ptr %state, ptr %RDX, i64 %2873)
  store ptr %2875, ptr %MEMORY, align 8
  %2876 = load i64, ptr %NEXT_PC, align 8
  store i64 %2876, ptr %PC, align 8
  %2877 = add i64 %2876, 4
  store i64 %2877, ptr %NEXT_PC, align 8
  %2878 = load i64, ptr %RCX, align 8
  %2879 = add i64 %2878, 48
  %2880 = load i64, ptr %R14, align 8
  %2881 = load ptr, ptr %MEMORY, align 8
  %2882 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2881, ptr %state, i64 %2879, i64 %2880)
  store ptr %2882, ptr %MEMORY, align 8
  %2883 = load i64, ptr %NEXT_PC, align 8
  store i64 %2883, ptr %PC, align 8
  %2884 = add i64 %2883, 4
  store i64 %2884, ptr %NEXT_PC, align 8
  %2885 = load i64, ptr %RCX, align 8
  %2886 = add i64 %2885, 8
  %2887 = load i64, ptr %R14, align 8
  %2888 = load ptr, ptr %MEMORY, align 8
  %2889 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2888, ptr %state, i64 %2886, i64 %2887)
  store ptr %2889, ptr %MEMORY, align 8
  %2890 = load i64, ptr %NEXT_PC, align 8
  store i64 %2890, ptr %PC, align 8
  %2891 = add i64 %2890, 5
  store i64 %2891, ptr %NEXT_PC, align 8
  %2892 = load i64, ptr %NEXT_PC, align 8
  %2893 = sub i64 %2892, 214
  %2894 = load i64, ptr %NEXT_PC, align 8
  %2895 = load ptr, ptr %MEMORY, align 8
  %2896 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2895, ptr %state, i64 %2893, ptr %NEXT_PC, i64 %2894, ptr %RETURN_PC)
  store ptr %2896, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878438:                                    ; preds = %bb_5389878416, %bb_5389878408, %bb_5389878368
  %2897 = load i64, ptr %NEXT_PC, align 8
  store i64 %2897, ptr %PC, align 8
  %2898 = add i64 %2897, 2
  store i64 %2898, ptr %NEXT_PC, align 8
  %2899 = load i64, ptr %RDI, align 8
  %2900 = load ptr, ptr %MEMORY, align 8
  %2901 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2900, ptr %state, ptr %RDI, i64 %2899)
  store ptr %2901, ptr %MEMORY, align 8
  %2902 = load i64, ptr %NEXT_PC, align 8
  store i64 %2902, ptr %PC, align 8
  %2903 = add i64 %2902, 4
  store i64 %2903, ptr %NEXT_PC, align 8
  %2904 = load i64, ptr %RSI, align 8
  %2905 = load ptr, ptr %MEMORY, align 8
  %2906 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %2905, ptr %state, ptr %RSI, i64 %2904, i64 56)
  store ptr %2906, ptr %MEMORY, align 8
  %2907 = load i64, ptr %NEXT_PC, align 8
  store i64 %2907, ptr %PC, align 8
  %2908 = add i64 %2907, 3
  store i64 %2908, ptr %NEXT_PC, align 8
  %2909 = load i32, ptr %EDI, align 4
  %2910 = zext i32 %2909 to i64
  %2911 = load i64, ptr %RBX, align 8
  %2912 = add i64 %2911, 40
  %2913 = load ptr, ptr %MEMORY, align 8
  %2914 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %2913, ptr %state, i64 %2910, i64 %2912)
  store ptr %2914, ptr %MEMORY, align 8
  %2915 = load i64, ptr %NEXT_PC, align 8
  store i64 %2915, ptr %PC, align 8
  %2916 = add i64 %2915, 2
  store i64 %2916, ptr %NEXT_PC, align 8
  %2917 = load i64, ptr %NEXT_PC, align 8
  %2918 = sub i64 %2917, 81
  %2919 = load i64, ptr %NEXT_PC, align 8
  %2920 = load ptr, ptr %MEMORY, align 8
  %2921 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2920, ptr %state, ptr %BRANCH_TAKEN, i64 %2918, i64 %2919, ptr %NEXT_PC)
  store ptr %2921, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878368, label %bb_5389878449

bb_5389878449:                                    ; preds = %bb_5389878438
  %2922 = load i64, ptr %NEXT_PC, align 8
  store i64 %2922, ptr %PC, align 8
  %2923 = add i64 %2922, 5
  store i64 %2923, ptr %NEXT_PC, align 8
  %2924 = load i64, ptr %RSP, align 8
  %2925 = add i64 %2924, 56
  %2926 = load ptr, ptr %MEMORY, align 8
  %2927 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2926, ptr %state, ptr %RSI, i64 %2925)
  store ptr %2927, ptr %MEMORY, align 8
  br label %bb_5389878454

bb_5389878454:                                    ; preds = %bb_5389878449, %bb_5389878347
  %2928 = load i64, ptr %NEXT_PC, align 8
  store i64 %2928, ptr %PC, align 8
  %2929 = add i64 %2928, 5
  store i64 %2929, ptr %NEXT_PC, align 8
  %2930 = load i64, ptr %RSP, align 8
  %2931 = add i64 %2930, 72
  %2932 = load ptr, ptr %MEMORY, align 8
  %2933 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2932, ptr %state, ptr %R14, i64 %2931)
  store ptr %2933, ptr %MEMORY, align 8
  %2934 = load i64, ptr %NEXT_PC, align 8
  store i64 %2934, ptr %PC, align 8
  %2935 = add i64 %2934, 5
  store i64 %2935, ptr %NEXT_PC, align 8
  %2936 = load i64, ptr %RSP, align 8
  %2937 = add i64 %2936, 64
  %2938 = load ptr, ptr %MEMORY, align 8
  %2939 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2938, ptr %state, ptr %RDI, i64 %2937)
  store ptr %2939, ptr %MEMORY, align 8
  %2940 = load i64, ptr %NEXT_PC, align 8
  store i64 %2940, ptr %PC, align 8
  %2941 = add i64 %2940, 3
  store i64 %2941, ptr %NEXT_PC, align 8
  %2942 = load i64, ptr %RBP, align 8
  %2943 = load i64, ptr %RBP, align 8
  %2944 = load ptr, ptr %MEMORY, align 8
  %2945 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %2944, ptr %state, i64 %2942, i64 %2943)
  store ptr %2945, ptr %MEMORY, align 8
  %2946 = load i64, ptr %NEXT_PC, align 8
  store i64 %2946, ptr %PC, align 8
  %2947 = add i64 %2946, 2
  store i64 %2947, ptr %NEXT_PC, align 8
  %2948 = load i64, ptr %NEXT_PC, align 8
  %2949 = add i64 %2948, 42
  %2950 = load i64, ptr %NEXT_PC, align 8
  %2951 = load ptr, ptr %MEMORY, align 8
  %2952 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2951, ptr %state, ptr %BRANCH_TAKEN, i64 %2949, i64 %2950, ptr %NEXT_PC)
  store ptr %2952, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878511, label %bb_5389878469

bb_5389878469:                                    ; preds = %bb_5389878454
  %2953 = load i64, ptr %NEXT_PC, align 8
  store i64 %2953, ptr %PC, align 8
  %2954 = add i64 %2953, 4
  store i64 %2954, ptr %NEXT_PC, align 8
  %2955 = load i64, ptr %RBX, align 8
  %2956 = load i64, ptr %RBP, align 8
  %2957 = add i64 %2956, 8
  %2958 = load ptr, ptr %MEMORY, align 8
  %2959 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2958, ptr %state, i64 %2955, i64 %2957)
  store ptr %2959, ptr %MEMORY, align 8
  %2960 = load i64, ptr %NEXT_PC, align 8
  store i64 %2960, ptr %PC, align 8
  %2961 = add i64 %2960, 2
  store i64 %2961, ptr %NEXT_PC, align 8
  %2962 = load i64, ptr %NEXT_PC, align 8
  %2963 = add i64 %2962, 32
  %2964 = load i64, ptr %NEXT_PC, align 8
  %2965 = load ptr, ptr %MEMORY, align 8
  %2966 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %2965, ptr %state, ptr %BRANCH_TAKEN, i64 %2963, i64 %2964, ptr %NEXT_PC)
  store ptr %2966, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878507, label %bb_5389878475

bb_5389878475:                                    ; preds = %bb_5389878469
  %2967 = load i64, ptr %NEXT_PC, align 8
  store i64 %2967, ptr %PC, align 8
  %2968 = add i64 %2967, 5
  store i64 %2968, ptr %NEXT_PC, align 8
  %2969 = load ptr, ptr %MEMORY, align 8
  %2970 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %2969, ptr %state, ptr %RDX, i64 24)
  store ptr %2970, ptr %MEMORY, align 8
  %2971 = load i64, ptr %NEXT_PC, align 8
  store i64 %2971, ptr %PC, align 8
  %2972 = add i64 %2971, 3
  store i64 %2972, ptr %NEXT_PC, align 8
  %2973 = load i64, ptr %RBP, align 8
  %2974 = load ptr, ptr %MEMORY, align 8
  %2975 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2974, ptr %state, ptr %RCX, i64 %2973)
  store ptr %2975, ptr %MEMORY, align 8
  %2976 = load i64, ptr %NEXT_PC, align 8
  store i64 %2976, ptr %PC, align 8
  %2977 = add i64 %2976, 5
  store i64 %2977, ptr %NEXT_PC, align 8
  %2978 = load i64, ptr %NEXT_PC, align 8
  %2979 = sub i64 %2978, 1165176
  %2980 = load i64, ptr %NEXT_PC, align 8
  %2981 = load ptr, ptr %MEMORY, align 8
  %2982 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %2981, ptr %state, i64 %2979, ptr %NEXT_PC, i64 %2980, ptr %RETURN_PC)
  store ptr %2982, ptr %MEMORY, align 8
  %2983 = load i64, ptr %NEXT_PC, align 8
  store i64 %2983, ptr %PC, align 8
  %2984 = add i64 %2983, 4
  store i64 %2984, ptr %NEXT_PC, align 8
  %2985 = load i64, ptr %RBX, align 8
  %2986 = add i64 %2985, 48
  %2987 = load ptr, ptr %MEMORY, align 8
  %2988 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2987, ptr %state, ptr %RAX, i64 %2986)
  store ptr %2988, ptr %MEMORY, align 8
  %2989 = load i64, ptr %NEXT_PC, align 8
  store i64 %2989, ptr %PC, align 8
  %2990 = add i64 %2989, 5
  store i64 %2990, ptr %NEXT_PC, align 8
  %2991 = load i64, ptr %RSP, align 8
  %2992 = add i64 %2991, 48
  %2993 = load ptr, ptr %MEMORY, align 8
  %2994 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2993, ptr %state, ptr %RBP, i64 %2992)
  store ptr %2994, ptr %MEMORY, align 8
  %2995 = load i64, ptr %NEXT_PC, align 8
  store i64 %2995, ptr %PC, align 8
  %2996 = add i64 %2995, 4
  store i64 %2996, ptr %NEXT_PC, align 8
  %2997 = load i64, ptr %RAX, align 8
  %2998 = add i64 %2997, 16
  %2999 = load i64, ptr %RAX, align 8
  %3000 = add i64 %2999, 16
  %3001 = load ptr, ptr %MEMORY, align 8
  %3002 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3001, ptr %state, i64 %2998, i64 %3000, i64 1)
  store ptr %3002, ptr %MEMORY, align 8
  %3003 = load i64, ptr %NEXT_PC, align 8
  store i64 %3003, ptr %PC, align 8
  %3004 = add i64 %3003, 4
  store i64 %3004, ptr %NEXT_PC, align 8
  %3005 = load i64, ptr %RSP, align 8
  %3006 = load ptr, ptr %MEMORY, align 8
  %3007 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3006, ptr %state, ptr %RSP, i64 %3005, i64 32)
  store ptr %3007, ptr %MEMORY, align 8
  %3008 = load i64, ptr %NEXT_PC, align 8
  store i64 %3008, ptr %PC, align 8
  %3009 = add i64 %3008, 1
  store i64 %3009, ptr %NEXT_PC, align 8
  %3010 = load ptr, ptr %MEMORY, align 8
  %3011 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %3010, ptr %state, ptr %RBX)
  store ptr %3011, ptr %MEMORY, align 8
  %3012 = load i64, ptr %NEXT_PC, align 8
  store i64 %3012, ptr %PC, align 8
  %3013 = add i64 %3012, 1
  store i64 %3013, ptr %NEXT_PC, align 8
  %3014 = load ptr, ptr %MEMORY, align 8
  %3015 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %3014, ptr %state, ptr %NEXT_PC)
  store ptr %3015, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878507:                                    ; preds = %bb_5389878469
  %3016 = load i64, ptr %NEXT_PC, align 8
  store i64 %3016, ptr %PC, align 8
  %3017 = add i64 %3016, 4
  store i64 %3017, ptr %NEXT_PC, align 8
  %3018 = load i64, ptr %RBP, align 8
  %3019 = add i64 %3018, 16
  %3020 = load i64, ptr %RBP, align 8
  %3021 = add i64 %3020, 16
  %3022 = load ptr, ptr %MEMORY, align 8
  %3023 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3022, ptr %state, i64 %3019, i64 %3021, i64 1)
  store ptr %3023, ptr %MEMORY, align 8
  br label %bb_5389878511

bb_5389878511:                                    ; preds = %bb_5389878507, %bb_5389878454
  %3024 = load i64, ptr %NEXT_PC, align 8
  store i64 %3024, ptr %PC, align 8
  %3025 = add i64 %3024, 4
  store i64 %3025, ptr %NEXT_PC, align 8
  %3026 = load i64, ptr %RBX, align 8
  %3027 = add i64 %3026, 48
  %3028 = load ptr, ptr %MEMORY, align 8
  %3029 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3028, ptr %state, ptr %RAX, i64 %3027)
  store ptr %3029, ptr %MEMORY, align 8
  %3030 = load i64, ptr %NEXT_PC, align 8
  store i64 %3030, ptr %PC, align 8
  %3031 = add i64 %3030, 4
  store i64 %3031, ptr %NEXT_PC, align 8
  %3032 = load i64, ptr %RAX, align 8
  %3033 = add i64 %3032, 16
  %3034 = load i64, ptr %RAX, align 8
  %3035 = add i64 %3034, 16
  %3036 = load ptr, ptr %MEMORY, align 8
  %3037 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3036, ptr %state, i64 %3033, i64 %3035, i64 1)
  store ptr %3037, ptr %MEMORY, align 8
  br label %bb_5389878519

bb_5389878519:                                    ; preds = %bb_5389878511, %bb_5389878263
  %3038 = load i64, ptr %NEXT_PC, align 8
  store i64 %3038, ptr %PC, align 8
  %3039 = add i64 %3038, 5
  store i64 %3039, ptr %NEXT_PC, align 8
  %3040 = load i64, ptr %RSP, align 8
  %3041 = add i64 %3040, 48
  %3042 = load ptr, ptr %MEMORY, align 8
  %3043 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3042, ptr %state, ptr %RBP, i64 %3041)
  store ptr %3043, ptr %MEMORY, align 8
  br label %bb_5389878524

bb_5389878524:                                    ; preds = %bb_5389878519, %bb_5389878216
  %3044 = load i64, ptr %NEXT_PC, align 8
  store i64 %3044, ptr %PC, align 8
  %3045 = add i64 %3044, 4
  store i64 %3045, ptr %NEXT_PC, align 8
  %3046 = load i64, ptr %RSP, align 8
  %3047 = load ptr, ptr %MEMORY, align 8
  %3048 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3047, ptr %state, ptr %RSP, i64 %3046, i64 32)
  store ptr %3048, ptr %MEMORY, align 8
  %3049 = load i64, ptr %NEXT_PC, align 8
  store i64 %3049, ptr %PC, align 8
  %3050 = add i64 %3049, 1
  store i64 %3050, ptr %NEXT_PC, align 8
  %3051 = load ptr, ptr %MEMORY, align 8
  %3052 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %3051, ptr %state, ptr %RBX)
  store ptr %3052, ptr %MEMORY, align 8
  %3053 = load i64, ptr %NEXT_PC, align 8
  store i64 %3053, ptr %PC, align 8
  %3054 = add i64 %3053, 1
  store i64 %3054, ptr %NEXT_PC, align 8
  %3055 = load ptr, ptr %MEMORY, align 8
  %3056 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %3055, ptr %state, ptr %NEXT_PC)
  store ptr %3056, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878530:                                    ; No predecessors!
  %3057 = load i64, ptr %NEXT_PC, align 8
  store i64 %3057, ptr %PC, align 8
  %3058 = add i64 %3057, 1
  store i64 %3058, ptr %NEXT_PC, align 8
  %3059 = load ptr, ptr %MEMORY, align 8
  %3060 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3059, ptr %state, ptr undef)
  store ptr %3060, ptr %MEMORY, align 8
  %3061 = load i64, ptr %NEXT_PC, align 8
  store i64 %3061, ptr %PC, align 8
  %3062 = add i64 %3061, 1
  store i64 %3062, ptr %NEXT_PC, align 8
  %3063 = load ptr, ptr %MEMORY, align 8
  %3064 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3063, ptr %state, ptr undef)
  store ptr %3064, ptr %MEMORY, align 8
  %3065 = load i64, ptr %NEXT_PC, align 8
  store i64 %3065, ptr %PC, align 8
  %3066 = add i64 %3065, 1
  store i64 %3066, ptr %NEXT_PC, align 8
  %3067 = load ptr, ptr %MEMORY, align 8
  %3068 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3067, ptr %state, ptr undef)
  store ptr %3068, ptr %MEMORY, align 8
  %3069 = load i64, ptr %NEXT_PC, align 8
  store i64 %3069, ptr %PC, align 8
  %3070 = add i64 %3069, 1
  store i64 %3070, ptr %NEXT_PC, align 8
  %3071 = load ptr, ptr %MEMORY, align 8
  %3072 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3071, ptr %state, ptr undef)
  store ptr %3072, ptr %MEMORY, align 8
  %3073 = load i64, ptr %NEXT_PC, align 8
  store i64 %3073, ptr %PC, align 8
  %3074 = add i64 %3073, 1
  store i64 %3074, ptr %NEXT_PC, align 8
  %3075 = load ptr, ptr %MEMORY, align 8
  %3076 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3075, ptr %state, ptr undef)
  store ptr %3076, ptr %MEMORY, align 8
  %3077 = load i64, ptr %NEXT_PC, align 8
  store i64 %3077, ptr %PC, align 8
  %3078 = add i64 %3077, 1
  store i64 %3078, ptr %NEXT_PC, align 8
  %3079 = load ptr, ptr %MEMORY, align 8
  %3080 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3079, ptr %state, ptr undef)
  store ptr %3080, ptr %MEMORY, align 8
  %3081 = load i64, ptr %NEXT_PC, align 8
  store i64 %3081, ptr %PC, align 8
  %3082 = add i64 %3081, 1
  store i64 %3082, ptr %NEXT_PC, align 8
  %3083 = load ptr, ptr %MEMORY, align 8
  %3084 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3083, ptr %state, ptr undef)
  store ptr %3084, ptr %MEMORY, align 8
  %3085 = load i64, ptr %NEXT_PC, align 8
  store i64 %3085, ptr %PC, align 8
  %3086 = add i64 %3085, 1
  store i64 %3086, ptr %NEXT_PC, align 8
  %3087 = load ptr, ptr %MEMORY, align 8
  %3088 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3087, ptr %state, ptr undef)
  store ptr %3088, ptr %MEMORY, align 8
  %3089 = load i64, ptr %NEXT_PC, align 8
  store i64 %3089, ptr %PC, align 8
  %3090 = add i64 %3089, 1
  store i64 %3090, ptr %NEXT_PC, align 8
  %3091 = load ptr, ptr %MEMORY, align 8
  %3092 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3091, ptr %state, ptr undef)
  store ptr %3092, ptr %MEMORY, align 8
  %3093 = load i64, ptr %NEXT_PC, align 8
  store i64 %3093, ptr %PC, align 8
  %3094 = add i64 %3093, 1
  store i64 %3094, ptr %NEXT_PC, align 8
  %3095 = load ptr, ptr %MEMORY, align 8
  %3096 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3095, ptr %state, ptr undef)
  store ptr %3096, ptr %MEMORY, align 8
  %3097 = load i64, ptr %NEXT_PC, align 8
  store i64 %3097, ptr %PC, align 8
  %3098 = add i64 %3097, 1
  store i64 %3098, ptr %NEXT_PC, align 8
  %3099 = load ptr, ptr %MEMORY, align 8
  %3100 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3099, ptr %state, ptr undef)
  store ptr %3100, ptr %MEMORY, align 8
  %3101 = load i64, ptr %NEXT_PC, align 8
  store i64 %3101, ptr %PC, align 8
  %3102 = add i64 %3101, 1
  store i64 %3102, ptr %NEXT_PC, align 8
  %3103 = load ptr, ptr %MEMORY, align 8
  %3104 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3103, ptr %state, ptr undef)
  store ptr %3104, ptr %MEMORY, align 8
  %3105 = load i64, ptr %NEXT_PC, align 8
  store i64 %3105, ptr %PC, align 8
  %3106 = add i64 %3105, 1
  store i64 %3106, ptr %NEXT_PC, align 8
  %3107 = load ptr, ptr %MEMORY, align 8
  %3108 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3107, ptr %state, ptr undef)
  store ptr %3108, ptr %MEMORY, align 8
  %3109 = load i64, ptr %NEXT_PC, align 8
  store i64 %3109, ptr %PC, align 8
  %3110 = add i64 %3109, 1
  store i64 %3110, ptr %NEXT_PC, align 8
  %3111 = load ptr, ptr %MEMORY, align 8
  %3112 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3111, ptr %state, ptr undef)
  store ptr %3112, ptr %MEMORY, align 8
  %3113 = load i64, ptr %NEXT_PC, align 8
  store i64 %3113, ptr %PC, align 8
  %3114 = add i64 %3113, 5
  store i64 %3114, ptr %NEXT_PC, align 8
  %3115 = load i64, ptr %RSP, align 8
  %3116 = add i64 %3115, 24
  %3117 = load i64, ptr %RBX, align 8
  %3118 = load ptr, ptr %MEMORY, align 8
  %3119 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3118, ptr %state, i64 %3116, i64 %3117)
  store ptr %3119, ptr %MEMORY, align 8
  %3120 = load i64, ptr %NEXT_PC, align 8
  store i64 %3120, ptr %PC, align 8
  %3121 = add i64 %3120, 1
  store i64 %3121, ptr %NEXT_PC, align 8
  %3122 = load i64, ptr %RDI, align 8
  %3123 = load ptr, ptr %MEMORY, align 8
  %3124 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %3123, ptr %state, i64 %3122)
  store ptr %3124, ptr %MEMORY, align 8
  %3125 = load i64, ptr %NEXT_PC, align 8
  store i64 %3125, ptr %PC, align 8
  %3126 = add i64 %3125, 4
  store i64 %3126, ptr %NEXT_PC, align 8
  %3127 = load i64, ptr %RSP, align 8
  %3128 = load ptr, ptr %MEMORY, align 8
  %3129 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3128, ptr %state, ptr %RSP, i64 %3127, i64 32)
  store ptr %3129, ptr %MEMORY, align 8
  %3130 = load i64, ptr %NEXT_PC, align 8
  store i64 %3130, ptr %PC, align 8
  %3131 = add i64 %3130, 3
  store i64 %3131, ptr %NEXT_PC, align 8
  %3132 = load i64, ptr %RDX, align 8
  %3133 = load ptr, ptr %MEMORY, align 8
  %3134 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3133, ptr %state, ptr %RAX, i64 %3132)
  store ptr %3134, ptr %MEMORY, align 8
  %3135 = load i64, ptr %NEXT_PC, align 8
  store i64 %3135, ptr %PC, align 8
  %3136 = add i64 %3135, 3
  store i64 %3136, ptr %NEXT_PC, align 8
  %3137 = load i64, ptr %RDX, align 8
  %3138 = load ptr, ptr %MEMORY, align 8
  %3139 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3138, ptr %state, ptr %RDI, i64 %3137)
  store ptr %3139, ptr %MEMORY, align 8
  %3140 = load i64, ptr %NEXT_PC, align 8
  store i64 %3140, ptr %PC, align 8
  %3141 = add i64 %3140, 3
  store i64 %3141, ptr %NEXT_PC, align 8
  %3142 = load i64, ptr %RCX, align 8
  %3143 = load ptr, ptr %MEMORY, align 8
  %3144 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3143, ptr %state, ptr %RBX, i64 %3142)
  store ptr %3144, ptr %MEMORY, align 8
  %3145 = load i64, ptr %NEXT_PC, align 8
  store i64 %3145, ptr %PC, align 8
  %3146 = add i64 %3145, 3
  store i64 %3146, ptr %NEXT_PC, align 8
  %3147 = load i64, ptr %RAX, align 8
  %3148 = load i64, ptr %RAX, align 8
  %3149 = load ptr, ptr %MEMORY, align 8
  %3150 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3149, ptr %state, i64 %3147, i64 %3148)
  store ptr %3150, ptr %MEMORY, align 8
  %3151 = load i64, ptr %NEXT_PC, align 8
  store i64 %3151, ptr %PC, align 8
  %3152 = add i64 %3151, 6
  store i64 %3152, ptr %NEXT_PC, align 8
  %3153 = load i64, ptr %NEXT_PC, align 8
  %3154 = add i64 %3153, 189
  %3155 = load i64, ptr %NEXT_PC, align 8
  %3156 = load ptr, ptr %MEMORY, align 8
  %3157 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3156, ptr %state, ptr %BRANCH_TAKEN, i64 %3154, i64 %3155, ptr %NEXT_PC)
  store ptr %3157, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878761, label %bb_5389878572

bb_5389878572:                                    ; preds = %bb_5389878530
  %3158 = load i64, ptr %NEXT_PC, align 8
  store i64 %3158, ptr %PC, align 8
  %3159 = add i64 %3158, 2
  store i64 %3159, ptr %NEXT_PC, align 8
  %3160 = load i64, ptr %RAX, align 8
  %3161 = load i64, ptr %RAX, align 8
  %3162 = load ptr, ptr %MEMORY, align 8
  %3163 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3162, ptr %state, i64 %3160, i64 %3161)
  store ptr %3163, ptr %MEMORY, align 8
  %3164 = load i64, ptr %NEXT_PC, align 8
  store i64 %3164, ptr %PC, align 8
  %3165 = add i64 %3164, 4
  store i64 %3165, ptr %NEXT_PC, align 8
  %3166 = load i64, ptr %RAX, align 8
  %3167 = add i64 %3166, 48
  %3168 = load ptr, ptr %MEMORY, align 8
  %3169 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3168, ptr %state, ptr %RAX, i64 %3167)
  store ptr %3169, ptr %MEMORY, align 8
  %3170 = load i64, ptr %NEXT_PC, align 8
  store i64 %3170, ptr %PC, align 8
  %3171 = add i64 %3170, 5
  store i64 %3171, ptr %NEXT_PC, align 8
  %3172 = load i64, ptr %RSP, align 8
  %3173 = add i64 %3172, 48
  %3174 = load i64, ptr %RSI, align 8
  %3175 = load ptr, ptr %MEMORY, align 8
  %3176 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3175, ptr %state, i64 %3173, i64 %3174)
  store ptr %3176, ptr %MEMORY, align 8
  %3177 = load i64, ptr %NEXT_PC, align 8
  store i64 %3177, ptr %PC, align 8
  %3178 = add i64 %3177, 2
  store i64 %3178, ptr %NEXT_PC, align 8
  %3179 = load i64, ptr %RAX, align 8
  %3180 = load i64, ptr %RAX, align 8
  %3181 = load ptr, ptr %MEMORY, align 8
  %3182 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3181, ptr %state, i64 %3179, i64 %3180)
  store ptr %3182, ptr %MEMORY, align 8
  %3183 = load i64, ptr %NEXT_PC, align 8
  store i64 %3183, ptr %PC, align 8
  %3184 = add i64 %3183, 3
  store i64 %3184, ptr %NEXT_PC, align 8
  %3185 = load i64, ptr %RDX, align 8
  %3186 = load ptr, ptr %MEMORY, align 8
  %3187 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3186, ptr %state, ptr %RAX, i64 %3185)
  store ptr %3187, ptr %MEMORY, align 8
  %3188 = load i64, ptr %NEXT_PC, align 8
  store i64 %3188, ptr %PC, align 8
  %3189 = add i64 %3188, 5
  store i64 %3189, ptr %NEXT_PC, align 8
  %3190 = load i64, ptr %RSP, align 8
  %3191 = add i64 %3190, 56
  %3192 = load ptr, ptr %MEMORY, align 8
  %3193 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %3192, ptr %state, ptr %RDX, i64 %3191)
  store ptr %3193, ptr %MEMORY, align 8
  %3194 = load i64, ptr %NEXT_PC, align 8
  store i64 %3194, ptr %PC, align 8
  %3195 = add i64 %3194, 5
  store i64 %3195, ptr %NEXT_PC, align 8
  %3196 = load i64, ptr %RSP, align 8
  %3197 = add i64 %3196, 56
  %3198 = load i64, ptr %RAX, align 8
  %3199 = load ptr, ptr %MEMORY, align 8
  %3200 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3199, ptr %state, i64 %3197, i64 %3198)
  store ptr %3200, ptr %MEMORY, align 8
  %3201 = load i64, ptr %NEXT_PC, align 8
  store i64 %3201, ptr %PC, align 8
  %3202 = add i64 %3201, 5
  store i64 %3202, ptr %NEXT_PC, align 8
  %3203 = load i64, ptr %NEXT_PC, align 8
  %3204 = add i64 %3203, 181
  %3205 = load i64, ptr %NEXT_PC, align 8
  %3206 = load ptr, ptr %MEMORY, align 8
  %3207 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3206, ptr %state, i64 %3204, ptr %NEXT_PC, i64 %3205, ptr %RETURN_PC)
  store ptr %3207, ptr %MEMORY, align 8
  %3208 = load i64, ptr %NEXT_PC, align 8
  store i64 %3208, ptr %PC, align 8
  %3209 = add i64 %3208, 3
  store i64 %3209, ptr %NEXT_PC, align 8
  %3210 = load i64, ptr %RBX, align 8
  %3211 = add i64 %3210, 24
  %3212 = load ptr, ptr %MEMORY, align 8
  %3213 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3212, ptr %state, ptr %RAX, i64 %3211)
  store ptr %3213, ptr %MEMORY, align 8
  %3214 = load i64, ptr %NEXT_PC, align 8
  store i64 %3214, ptr %PC, align 8
  %3215 = add i64 %3214, 3
  store i64 %3215, ptr %NEXT_PC, align 8
  %3216 = load i64, ptr %RAX, align 8
  %3217 = add i64 %3216, 1
  %3218 = load ptr, ptr %MEMORY, align 8
  %3219 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %3218, ptr %state, ptr %RDX, i64 %3217)
  store ptr %3219, ptr %MEMORY, align 8
  %3220 = load i64, ptr %NEXT_PC, align 8
  store i64 %3220, ptr %PC, align 8
  %3221 = add i64 %3220, 3
  store i64 %3221, ptr %NEXT_PC, align 8
  %3222 = load i32, ptr %EDX, align 4
  %3223 = zext i32 %3222 to i64
  %3224 = load i64, ptr %RBX, align 8
  %3225 = add i64 %3224, 28
  %3226 = load ptr, ptr %MEMORY, align 8
  %3227 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3226, ptr %state, i64 %3223, i64 %3225)
  store ptr %3227, ptr %MEMORY, align 8
  %3228 = load i64, ptr %NEXT_PC, align 8
  store i64 %3228, ptr %PC, align 8
  %3229 = add i64 %3228, 2
  store i64 %3229, ptr %NEXT_PC, align 8
  %3230 = load i64, ptr %NEXT_PC, align 8
  %3231 = add i64 %3230, 18
  %3232 = load i64, ptr %NEXT_PC, align 8
  %3233 = load ptr, ptr %MEMORY, align 8
  %3234 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3233, ptr %state, ptr %BRANCH_TAKEN, i64 %3231, i64 %3232, ptr %NEXT_PC)
  store ptr %3234, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878632, label %bb_5389878614

bb_5389878614:                                    ; preds = %bb_5389878572
  %3235 = load i64, ptr %NEXT_PC, align 8
  store i64 %3235, ptr %PC, align 8
  %3236 = add i64 %3235, 6
  store i64 %3236, ptr %NEXT_PC, align 8
  %3237 = load ptr, ptr %MEMORY, align 8
  %3238 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %3237, ptr %state, ptr %R8, i64 134217736)
  store ptr %3238, ptr %MEMORY, align 8
  %3239 = load i64, ptr %NEXT_PC, align 8
  store i64 %3239, ptr %PC, align 8
  %3240 = add i64 %3239, 4
  store i64 %3240, ptr %NEXT_PC, align 8
  %3241 = load i64, ptr %RBX, align 8
  %3242 = add i64 %3241, 16
  %3243 = load ptr, ptr %MEMORY, align 8
  %3244 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %3243, ptr %state, ptr %RCX, i64 %3242)
  store ptr %3244, ptr %MEMORY, align 8
  %3245 = load i64, ptr %NEXT_PC, align 8
  store i64 %3245, ptr %PC, align 8
  %3246 = add i64 %3245, 5
  store i64 %3246, ptr %NEXT_PC, align 8
  %3247 = load i64, ptr %NEXT_PC, align 8
  %3248 = sub i64 %3247, 644997
  %3249 = load i64, ptr %NEXT_PC, align 8
  %3250 = load ptr, ptr %MEMORY, align 8
  %3251 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3250, ptr %state, i64 %3248, ptr %NEXT_PC, i64 %3249, ptr %RETURN_PC)
  store ptr %3251, ptr %MEMORY, align 8
  %3252 = load i64, ptr %NEXT_PC, align 8
  store i64 %3252, ptr %PC, align 8
  %3253 = add i64 %3252, 3
  store i64 %3253, ptr %NEXT_PC, align 8
  %3254 = load i64, ptr %RBX, align 8
  %3255 = add i64 %3254, 24
  %3256 = load ptr, ptr %MEMORY, align 8
  %3257 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3256, ptr %state, ptr %RAX, i64 %3255)
  store ptr %3257, ptr %MEMORY, align 8
  br label %bb_5389878632

bb_5389878632:                                    ; preds = %bb_5389878614, %bb_5389878572
  %3258 = load i64, ptr %NEXT_PC, align 8
  store i64 %3258, ptr %PC, align 8
  %3259 = add i64 %3258, 3
  store i64 %3259, ptr %NEXT_PC, align 8
  %3260 = load i32, ptr %EAX, align 4
  %3261 = zext i32 %3260 to i64
  %3262 = load i64, ptr %RBX, align 8
  %3263 = add i64 %3262, 28
  %3264 = load ptr, ptr %MEMORY, align 8
  %3265 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3264, ptr %state, i64 %3261, i64 %3263)
  store ptr %3265, ptr %MEMORY, align 8
  %3266 = load i64, ptr %NEXT_PC, align 8
  store i64 %3266, ptr %PC, align 8
  %3267 = add i64 %3266, 2
  store i64 %3267, ptr %NEXT_PC, align 8
  %3268 = load i64, ptr %NEXT_PC, align 8
  %3269 = add i64 %3268, 38
  %3270 = load i64, ptr %NEXT_PC, align 8
  %3271 = load ptr, ptr %MEMORY, align 8
  %3272 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3271, ptr %state, ptr %BRANCH_TAKEN, i64 %3269, i64 %3270, ptr %NEXT_PC)
  store ptr %3272, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878675, label %bb_5389878637

bb_5389878637:                                    ; preds = %bb_5389878632
  %3273 = load i64, ptr %NEXT_PC, align 8
  store i64 %3273, ptr %PC, align 8
  %3274 = add i64 %3273, 3
  store i64 %3274, ptr %NEXT_PC, align 8
  %3275 = load i32, ptr %EAX, align 4
  %3276 = zext i32 %3275 to i64
  %3277 = load ptr, ptr %MEMORY, align 8
  %3278 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %3277, ptr %state, ptr %RCX, i64 %3276)
  store ptr %3278, ptr %MEMORY, align 8
  %3279 = load i64, ptr %NEXT_PC, align 8
  store i64 %3279, ptr %PC, align 8
  %3280 = add i64 %3279, 4
  store i64 %3280, ptr %NEXT_PC, align 8
  %3281 = load i64, ptr %RBX, align 8
  %3282 = add i64 %3281, 16
  %3283 = load ptr, ptr %MEMORY, align 8
  %3284 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3283, ptr %state, ptr %RAX, i64 %3282)
  store ptr %3284, ptr %MEMORY, align 8
  %3285 = load i64, ptr %NEXT_PC, align 8
  store i64 %3285, ptr %PC, align 8
  %3286 = add i64 %3285, 4
  store i64 %3286, ptr %NEXT_PC, align 8
  %3287 = load i64, ptr %RAX, align 8
  %3288 = load i64, ptr %RCX, align 8
  %3289 = mul i64 %3288, 8
  %3290 = add i64 %3287, %3289
  %3291 = load ptr, ptr %MEMORY, align 8
  %3292 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %3291, ptr %state, ptr %RDX, i64 %3290)
  store ptr %3292, ptr %MEMORY, align 8
  %3293 = load i64, ptr %NEXT_PC, align 8
  store i64 %3293, ptr %PC, align 8
  %3294 = add i64 %3293, 3
  store i64 %3294, ptr %NEXT_PC, align 8
  %3295 = load i64, ptr %RDI, align 8
  %3296 = load ptr, ptr %MEMORY, align 8
  %3297 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3296, ptr %state, ptr %RAX, i64 %3295)
  store ptr %3297, ptr %MEMORY, align 8
  %3298 = load i64, ptr %NEXT_PC, align 8
  store i64 %3298, ptr %PC, align 8
  %3299 = add i64 %3298, 3
  store i64 %3299, ptr %NEXT_PC, align 8
  %3300 = load i64, ptr %RAX, align 8
  %3301 = load i64, ptr %RAX, align 8
  %3302 = load ptr, ptr %MEMORY, align 8
  %3303 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3302, ptr %state, i64 %3300, i64 %3301)
  store ptr %3303, ptr %MEMORY, align 8
  %3304 = load i64, ptr %NEXT_PC, align 8
  store i64 %3304, ptr %PC, align 8
  %3305 = add i64 %3304, 2
  store i64 %3305, ptr %NEXT_PC, align 8
  %3306 = load i64, ptr %NEXT_PC, align 8
  %3307 = add i64 %3306, 11
  %3308 = load i64, ptr %NEXT_PC, align 8
  %3309 = load ptr, ptr %MEMORY, align 8
  %3310 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3309, ptr %state, ptr %BRANCH_TAKEN, i64 %3307, i64 %3308, ptr %NEXT_PC)
  store ptr %3310, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878667, label %bb_5389878656

bb_5389878656:                                    ; preds = %bb_5389878637
  %3311 = load i64, ptr %NEXT_PC, align 8
  store i64 %3311, ptr %PC, align 8
  %3312 = add i64 %3311, 2
  store i64 %3312, ptr %NEXT_PC, align 8
  %3313 = load i64, ptr %RAX, align 8
  %3314 = load i64, ptr %RAX, align 8
  %3315 = load ptr, ptr %MEMORY, align 8
  %3316 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3315, ptr %state, i64 %3313, i64 %3314)
  store ptr %3316, ptr %MEMORY, align 8
  %3317 = load i64, ptr %NEXT_PC, align 8
  store i64 %3317, ptr %PC, align 8
  %3318 = add i64 %3317, 4
  store i64 %3318, ptr %NEXT_PC, align 8
  %3319 = load i64, ptr %RAX, align 8
  %3320 = add i64 %3319, 48
  %3321 = load ptr, ptr %MEMORY, align 8
  %3322 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3321, ptr %state, ptr %RAX, i64 %3320)
  store ptr %3322, ptr %MEMORY, align 8
  %3323 = load i64, ptr %NEXT_PC, align 8
  store i64 %3323, ptr %PC, align 8
  %3324 = add i64 %3323, 2
  store i64 %3324, ptr %NEXT_PC, align 8
  %3325 = load i64, ptr %RAX, align 8
  %3326 = load i64, ptr %RAX, align 8
  %3327 = load ptr, ptr %MEMORY, align 8
  %3328 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3327, ptr %state, i64 %3325, i64 %3326)
  store ptr %3328, ptr %MEMORY, align 8
  %3329 = load i64, ptr %NEXT_PC, align 8
  store i64 %3329, ptr %PC, align 8
  %3330 = add i64 %3329, 3
  store i64 %3330, ptr %NEXT_PC, align 8
  %3331 = load i64, ptr %RDI, align 8
  %3332 = load ptr, ptr %MEMORY, align 8
  %3333 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3332, ptr %state, ptr %RAX, i64 %3331)
  store ptr %3333, ptr %MEMORY, align 8
  br label %bb_5389878667

bb_5389878667:                                    ; preds = %bb_5389878656, %bb_5389878637
  %3334 = load i64, ptr %NEXT_PC, align 8
  store i64 %3334, ptr %PC, align 8
  %3335 = add i64 %3334, 3
  store i64 %3335, ptr %NEXT_PC, align 8
  %3336 = load i64, ptr %RDX, align 8
  %3337 = load i64, ptr %RAX, align 8
  %3338 = load ptr, ptr %MEMORY, align 8
  %3339 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3338, ptr %state, i64 %3336, i64 %3337)
  store ptr %3339, ptr %MEMORY, align 8
  %3340 = load i64, ptr %NEXT_PC, align 8
  store i64 %3340, ptr %PC, align 8
  %3341 = add i64 %3340, 3
  store i64 %3341, ptr %NEXT_PC, align 8
  %3342 = load i64, ptr %RBX, align 8
  %3343 = add i64 %3342, 24
  %3344 = load i64, ptr %RBX, align 8
  %3345 = add i64 %3344, 24
  %3346 = load ptr, ptr %MEMORY, align 8
  %3347 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3346, ptr %state, i64 %3343, i64 %3345)
  store ptr %3347, ptr %MEMORY, align 8
  %3348 = load i64, ptr %NEXT_PC, align 8
  store i64 %3348, ptr %PC, align 8
  %3349 = add i64 %3348, 2
  store i64 %3349, ptr %NEXT_PC, align 8
  %3350 = load i64, ptr %NEXT_PC, align 8
  %3351 = add i64 %3350, 53
  %3352 = load ptr, ptr %MEMORY, align 8
  %3353 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %3352, ptr %state, i64 %3351, ptr %NEXT_PC)
  store ptr %3353, ptr %MEMORY, align 8
  br label %bb_5389878728

bb_5389878675:                                    ; preds = %bb_5389878632
  %3354 = load i64, ptr %NEXT_PC, align 8
  store i64 %3354, ptr %PC, align 8
  %3355 = add i64 %3354, 6
  store i64 %3355, ptr %NEXT_PC, align 8
  %3356 = load ptr, ptr %MEMORY, align 8
  %3357 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %3356, ptr %state, ptr %R8, i64 134217736)
  store ptr %3357, ptr %MEMORY, align 8
  %3358 = load i64, ptr %NEXT_PC, align 8
  store i64 %3358, ptr %PC, align 8
  %3359 = add i64 %3358, 4
  store i64 %3359, ptr %NEXT_PC, align 8
  %3360 = load i64, ptr %RBX, align 8
  %3361 = add i64 %3360, 16
  %3362 = load ptr, ptr %MEMORY, align 8
  %3363 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %3362, ptr %state, ptr %RCX, i64 %3361)
  store ptr %3363, ptr %MEMORY, align 8
  %3364 = load i64, ptr %NEXT_PC, align 8
  store i64 %3364, ptr %PC, align 8
  %3365 = add i64 %3364, 3
  store i64 %3365, ptr %NEXT_PC, align 8
  %3366 = load i64, ptr %RDI, align 8
  %3367 = load ptr, ptr %MEMORY, align 8
  %3368 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3367, ptr %state, ptr %RDX, i64 %3366)
  store ptr %3368, ptr %MEMORY, align 8
  %3369 = load i64, ptr %NEXT_PC, align 8
  store i64 %3369, ptr %PC, align 8
  %3370 = add i64 %3369, 5
  store i64 %3370, ptr %NEXT_PC, align 8
  %3371 = load i64, ptr %NEXT_PC, align 8
  %3372 = sub i64 %3371, 644773
  %3373 = load i64, ptr %NEXT_PC, align 8
  %3374 = load ptr, ptr %MEMORY, align 8
  %3375 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3374, ptr %state, i64 %3372, ptr %NEXT_PC, i64 %3373, ptr %RETURN_PC)
  store ptr %3375, ptr %MEMORY, align 8
  %3376 = load i64, ptr %NEXT_PC, align 8
  store i64 %3376, ptr %PC, align 8
  %3377 = add i64 %3376, 4
  store i64 %3377, ptr %NEXT_PC, align 8
  %3378 = load i64, ptr %RBX, align 8
  %3379 = add i64 %3378, 16
  %3380 = load ptr, ptr %MEMORY, align 8
  %3381 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3380, ptr %state, ptr %RCX, i64 %3379)
  store ptr %3381, ptr %MEMORY, align 8
  %3382 = load i64, ptr %NEXT_PC, align 8
  store i64 %3382, ptr %PC, align 8
  %3383 = add i64 %3382, 4
  store i64 %3383, ptr %NEXT_PC, align 8
  %3384 = load i64, ptr %RBX, align 8
  %3385 = add i64 %3384, 24
  %3386 = load ptr, ptr %MEMORY, align 8
  %3387 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2MnIjElEEP6MemoryS6_R5StateT_T0_(ptr %3386, ptr %state, ptr %RDX, i64 %3385)
  store ptr %3387, ptr %MEMORY, align 8
  %3388 = load i64, ptr %NEXT_PC, align 8
  store i64 %3388, ptr %PC, align 8
  %3389 = add i64 %3388, 4
  store i64 %3389, ptr %NEXT_PC, align 8
  %3390 = load i64, ptr %RCX, align 8
  %3391 = load i64, ptr %RDX, align 8
  %3392 = mul i64 %3391, 8
  %3393 = add i64 %3390, %3392
  %3394 = load ptr, ptr %MEMORY, align 8
  %3395 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %3394, ptr %state, ptr %R8, i64 %3393)
  store ptr %3395, ptr %MEMORY, align 8
  %3396 = load i64, ptr %NEXT_PC, align 8
  store i64 %3396, ptr %PC, align 8
  %3397 = add i64 %3396, 3
  store i64 %3397, ptr %NEXT_PC, align 8
  %3398 = load i64, ptr %RAX, align 8
  %3399 = load ptr, ptr %MEMORY, align 8
  %3400 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3399, ptr %state, ptr %RCX, i64 %3398)
  store ptr %3400, ptr %MEMORY, align 8
  %3401 = load i64, ptr %NEXT_PC, align 8
  store i64 %3401, ptr %PC, align 8
  %3402 = add i64 %3401, 3
  store i64 %3402, ptr %NEXT_PC, align 8
  %3403 = load i64, ptr %RCX, align 8
  %3404 = load i64, ptr %RCX, align 8
  %3405 = load ptr, ptr %MEMORY, align 8
  %3406 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3405, ptr %state, i64 %3403, i64 %3404)
  store ptr %3406, ptr %MEMORY, align 8
  %3407 = load i64, ptr %NEXT_PC, align 8
  store i64 %3407, ptr %PC, align 8
  %3408 = add i64 %3407, 2
  store i64 %3408, ptr %NEXT_PC, align 8
  %3409 = load i64, ptr %NEXT_PC, align 8
  %3410 = add i64 %3409, 11
  %3411 = load i64, ptr %NEXT_PC, align 8
  %3412 = load ptr, ptr %MEMORY, align 8
  %3413 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3412, ptr %state, ptr %BRANCH_TAKEN, i64 %3410, i64 %3411, ptr %NEXT_PC)
  store ptr %3413, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878724, label %bb_5389878713

bb_5389878713:                                    ; preds = %bb_5389878675
  %3414 = load i64, ptr %NEXT_PC, align 8
  store i64 %3414, ptr %PC, align 8
  %3415 = add i64 %3414, 2
  store i64 %3415, ptr %NEXT_PC, align 8
  %3416 = load i64, ptr %RCX, align 8
  %3417 = load i64, ptr %RCX, align 8
  %3418 = load ptr, ptr %MEMORY, align 8
  %3419 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3418, ptr %state, i64 %3416, i64 %3417)
  store ptr %3419, ptr %MEMORY, align 8
  %3420 = load i64, ptr %NEXT_PC, align 8
  store i64 %3420, ptr %PC, align 8
  %3421 = add i64 %3420, 4
  store i64 %3421, ptr %NEXT_PC, align 8
  %3422 = load i64, ptr %RCX, align 8
  %3423 = add i64 %3422, 48
  %3424 = load ptr, ptr %MEMORY, align 8
  %3425 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3424, ptr %state, ptr %RCX, i64 %3423)
  store ptr %3425, ptr %MEMORY, align 8
  %3426 = load i64, ptr %NEXT_PC, align 8
  store i64 %3426, ptr %PC, align 8
  %3427 = add i64 %3426, 2
  store i64 %3427, ptr %NEXT_PC, align 8
  %3428 = load i64, ptr %RCX, align 8
  %3429 = load i64, ptr %RCX, align 8
  %3430 = load ptr, ptr %MEMORY, align 8
  %3431 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3430, ptr %state, i64 %3428, i64 %3429)
  store ptr %3431, ptr %MEMORY, align 8
  %3432 = load i64, ptr %NEXT_PC, align 8
  store i64 %3432, ptr %PC, align 8
  %3433 = add i64 %3432, 3
  store i64 %3433, ptr %NEXT_PC, align 8
  %3434 = load i64, ptr %RAX, align 8
  %3435 = load ptr, ptr %MEMORY, align 8
  %3436 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3435, ptr %state, ptr %RCX, i64 %3434)
  store ptr %3436, ptr %MEMORY, align 8
  br label %bb_5389878724

bb_5389878724:                                    ; preds = %bb_5389878713, %bb_5389878675
  %3437 = load i64, ptr %NEXT_PC, align 8
  store i64 %3437, ptr %PC, align 8
  %3438 = add i64 %3437, 4
  store i64 %3438, ptr %NEXT_PC, align 8
  %3439 = load i64, ptr %R8, align 8
  %3440 = sub i64 %3439, 8
  %3441 = load i64, ptr %RCX, align 8
  %3442 = load ptr, ptr %MEMORY, align 8
  %3443 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3442, ptr %state, i64 %3440, i64 %3441)
  store ptr %3443, ptr %MEMORY, align 8
  br label %bb_5389878728

bb_5389878728:                                    ; preds = %bb_5389878724, %bb_5389878667
  %3444 = load i64, ptr %NEXT_PC, align 8
  store i64 %3444, ptr %PC, align 8
  %3445 = add i64 %3444, 3
  store i64 %3445, ptr %NEXT_PC, align 8
  %3446 = load i64, ptr %RDI, align 8
  %3447 = load ptr, ptr %MEMORY, align 8
  %3448 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3447, ptr %state, ptr %RCX, i64 %3446)
  store ptr %3448, ptr %MEMORY, align 8
  %3449 = load i64, ptr %NEXT_PC, align 8
  store i64 %3449, ptr %PC, align 8
  %3450 = add i64 %3449, 4
  store i64 %3450, ptr %NEXT_PC, align 8
  %3451 = load i64, ptr %RBX, align 8
  %3452 = add i64 %3451, 48
  %3453 = load ptr, ptr %MEMORY, align 8
  %3454 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3453, ptr %state, ptr %RAX, i64 %3452)
  store ptr %3454, ptr %MEMORY, align 8
  %3455 = load i64, ptr %NEXT_PC, align 8
  store i64 %3455, ptr %PC, align 8
  %3456 = add i64 %3455, 5
  store i64 %3456, ptr %NEXT_PC, align 8
  %3457 = load i64, ptr %RSP, align 8
  %3458 = add i64 %3457, 48
  %3459 = load ptr, ptr %MEMORY, align 8
  %3460 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3459, ptr %state, ptr %RSI, i64 %3458)
  store ptr %3460, ptr %MEMORY, align 8
  %3461 = load i64, ptr %NEXT_PC, align 8
  store i64 %3461, ptr %PC, align 8
  %3462 = add i64 %3461, 4
  store i64 %3462, ptr %NEXT_PC, align 8
  %3463 = load i64, ptr %RCX, align 8
  %3464 = add i64 %3463, 48
  %3465 = load i64, ptr %RAX, align 8
  %3466 = load ptr, ptr %MEMORY, align 8
  %3467 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %3466, ptr %state, i64 %3464, i64 %3465)
  store ptr %3467, ptr %MEMORY, align 8
  %3468 = load i64, ptr %NEXT_PC, align 8
  store i64 %3468, ptr %PC, align 8
  %3469 = add i64 %3468, 2
  store i64 %3469, ptr %NEXT_PC, align 8
  %3470 = load i64, ptr %NEXT_PC, align 8
  %3471 = add i64 %3470, 5
  %3472 = load i64, ptr %NEXT_PC, align 8
  %3473 = load ptr, ptr %MEMORY, align 8
  %3474 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3473, ptr %state, ptr %BRANCH_TAKEN, i64 %3471, i64 %3472, ptr %NEXT_PC)
  store ptr %3474, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878751, label %bb_5389878746

bb_5389878746:                                    ; preds = %bb_5389878728
  %3475 = load i64, ptr %NEXT_PC, align 8
  store i64 %3475, ptr %PC, align 8
  %3476 = add i64 %3475, 2
  store i64 %3476, ptr %NEXT_PC, align 8
  %3477 = load i64, ptr %RAX, align 8
  %3478 = load i64, ptr %RAX, align 8
  %3479 = load ptr, ptr %MEMORY, align 8
  %3480 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3479, ptr %state, i64 %3477, i64 %3478)
  store ptr %3480, ptr %MEMORY, align 8
  %3481 = load i64, ptr %NEXT_PC, align 8
  store i64 %3481, ptr %PC, align 8
  %3482 = add i64 %3481, 3
  store i64 %3482, ptr %NEXT_PC, align 8
  %3483 = load i64, ptr %RDI, align 8
  %3484 = load ptr, ptr %MEMORY, align 8
  %3485 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3484, ptr %state, ptr %RCX, i64 %3483)
  store ptr %3485, ptr %MEMORY, align 8
  br label %bb_5389878751

bb_5389878751:                                    ; preds = %bb_5389878746, %bb_5389878728
  %3486 = load i64, ptr %NEXT_PC, align 8
  store i64 %3486, ptr %PC, align 8
  %3487 = add i64 %3486, 3
  store i64 %3487, ptr %NEXT_PC, align 8
  %3488 = load i64, ptr %RCX, align 8
  %3489 = load i64, ptr %RCX, align 8
  %3490 = load ptr, ptr %MEMORY, align 8
  %3491 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3490, ptr %state, i64 %3488, i64 %3489)
  store ptr %3491, ptr %MEMORY, align 8
  %3492 = load i64, ptr %NEXT_PC, align 8
  store i64 %3492, ptr %PC, align 8
  %3493 = add i64 %3492, 2
  store i64 %3493, ptr %NEXT_PC, align 8
  %3494 = load i64, ptr %NEXT_PC, align 8
  %3495 = add i64 %3494, 5
  %3496 = load i64, ptr %NEXT_PC, align 8
  %3497 = load ptr, ptr %MEMORY, align 8
  %3498 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3497, ptr %state, ptr %BRANCH_TAKEN, i64 %3495, i64 %3496, ptr %NEXT_PC)
  store ptr %3498, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878761, label %bb_5389878756

bb_5389878756:                                    ; preds = %bb_5389878751
  %3499 = load i64, ptr %NEXT_PC, align 8
  store i64 %3499, ptr %PC, align 8
  %3500 = add i64 %3499, 5
  store i64 %3500, ptr %NEXT_PC, align 8
  %3501 = load i64, ptr %NEXT_PC, align 8
  %3502 = sub i64 %3501, 2057
  %3503 = load i64, ptr %NEXT_PC, align 8
  %3504 = load ptr, ptr %MEMORY, align 8
  %3505 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3504, ptr %state, i64 %3502, ptr %NEXT_PC, i64 %3503, ptr %RETURN_PC)
  store ptr %3505, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878761:                                    ; preds = %bb_5389878751, %bb_5389878530
  %3506 = load i64, ptr %NEXT_PC, align 8
  store i64 %3506, ptr %PC, align 8
  %3507 = add i64 %3506, 5
  store i64 %3507, ptr %NEXT_PC, align 8
  %3508 = load i64, ptr %RSP, align 8
  %3509 = add i64 %3508, 64
  %3510 = load ptr, ptr %MEMORY, align 8
  %3511 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3510, ptr %state, ptr %RBX, i64 %3509)
  store ptr %3511, ptr %MEMORY, align 8
  %3512 = load i64, ptr %NEXT_PC, align 8
  store i64 %3512, ptr %PC, align 8
  %3513 = add i64 %3512, 4
  store i64 %3513, ptr %NEXT_PC, align 8
  %3514 = load i64, ptr %RSP, align 8
  %3515 = load ptr, ptr %MEMORY, align 8
  %3516 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3515, ptr %state, ptr %RSP, i64 %3514, i64 32)
  store ptr %3516, ptr %MEMORY, align 8
  %3517 = load i64, ptr %NEXT_PC, align 8
  store i64 %3517, ptr %PC, align 8
  %3518 = add i64 %3517, 1
  store i64 %3518, ptr %NEXT_PC, align 8
  %3519 = load ptr, ptr %MEMORY, align 8
  %3520 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %3519, ptr %state, ptr %RDI)
  store ptr %3520, ptr %MEMORY, align 8
  %3521 = load i64, ptr %NEXT_PC, align 8
  store i64 %3521, ptr %PC, align 8
  %3522 = add i64 %3521, 1
  store i64 %3522, ptr %NEXT_PC, align 8
  %3523 = load ptr, ptr %MEMORY, align 8
  %3524 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %3523, ptr %state, ptr %NEXT_PC)
  store ptr %3524, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878772:                                    ; No predecessors!
  %3525 = load i64, ptr %NEXT_PC, align 8
  store i64 %3525, ptr %PC, align 8
  %3526 = add i64 %3525, 1
  store i64 %3526, ptr %NEXT_PC, align 8
  %3527 = load ptr, ptr %MEMORY, align 8
  %3528 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3527, ptr %state, ptr undef)
  store ptr %3528, ptr %MEMORY, align 8
  %3529 = load i64, ptr %NEXT_PC, align 8
  store i64 %3529, ptr %PC, align 8
  %3530 = add i64 %3529, 1
  store i64 %3530, ptr %NEXT_PC, align 8
  %3531 = load ptr, ptr %MEMORY, align 8
  %3532 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3531, ptr %state, ptr undef)
  store ptr %3532, ptr %MEMORY, align 8
  %3533 = load i64, ptr %NEXT_PC, align 8
  store i64 %3533, ptr %PC, align 8
  %3534 = add i64 %3533, 1
  store i64 %3534, ptr %NEXT_PC, align 8
  %3535 = load ptr, ptr %MEMORY, align 8
  %3536 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3535, ptr %state, ptr undef)
  store ptr %3536, ptr %MEMORY, align 8
  %3537 = load i64, ptr %NEXT_PC, align 8
  store i64 %3537, ptr %PC, align 8
  %3538 = add i64 %3537, 1
  store i64 %3538, ptr %NEXT_PC, align 8
  %3539 = load ptr, ptr %MEMORY, align 8
  %3540 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3539, ptr %state, ptr undef)
  store ptr %3540, ptr %MEMORY, align 8
  %3541 = load i64, ptr %NEXT_PC, align 8
  store i64 %3541, ptr %PC, align 8
  %3542 = add i64 %3541, 1
  store i64 %3542, ptr %NEXT_PC, align 8
  %3543 = load ptr, ptr %MEMORY, align 8
  %3544 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3543, ptr %state, ptr undef)
  store ptr %3544, ptr %MEMORY, align 8
  %3545 = load i64, ptr %NEXT_PC, align 8
  store i64 %3545, ptr %PC, align 8
  %3546 = add i64 %3545, 1
  store i64 %3546, ptr %NEXT_PC, align 8
  %3547 = load ptr, ptr %MEMORY, align 8
  %3548 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3547, ptr %state, ptr undef)
  store ptr %3548, ptr %MEMORY, align 8
  %3549 = load i64, ptr %NEXT_PC, align 8
  store i64 %3549, ptr %PC, align 8
  %3550 = add i64 %3549, 1
  store i64 %3550, ptr %NEXT_PC, align 8
  %3551 = load ptr, ptr %MEMORY, align 8
  %3552 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3551, ptr %state, ptr undef)
  store ptr %3552, ptr %MEMORY, align 8
  %3553 = load i64, ptr %NEXT_PC, align 8
  store i64 %3553, ptr %PC, align 8
  %3554 = add i64 %3553, 1
  store i64 %3554, ptr %NEXT_PC, align 8
  %3555 = load ptr, ptr %MEMORY, align 8
  %3556 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3555, ptr %state, ptr undef)
  store ptr %3556, ptr %MEMORY, align 8
  %3557 = load i64, ptr %NEXT_PC, align 8
  store i64 %3557, ptr %PC, align 8
  %3558 = add i64 %3557, 1
  store i64 %3558, ptr %NEXT_PC, align 8
  %3559 = load ptr, ptr %MEMORY, align 8
  %3560 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3559, ptr %state, ptr undef)
  store ptr %3560, ptr %MEMORY, align 8
  %3561 = load i64, ptr %NEXT_PC, align 8
  store i64 %3561, ptr %PC, align 8
  %3562 = add i64 %3561, 1
  store i64 %3562, ptr %NEXT_PC, align 8
  %3563 = load ptr, ptr %MEMORY, align 8
  %3564 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3563, ptr %state, ptr undef)
  store ptr %3564, ptr %MEMORY, align 8
  %3565 = load i64, ptr %NEXT_PC, align 8
  store i64 %3565, ptr %PC, align 8
  %3566 = add i64 %3565, 1
  store i64 %3566, ptr %NEXT_PC, align 8
  %3567 = load ptr, ptr %MEMORY, align 8
  %3568 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3567, ptr %state, ptr undef)
  store ptr %3568, ptr %MEMORY, align 8
  %3569 = load i64, ptr %NEXT_PC, align 8
  store i64 %3569, ptr %PC, align 8
  %3570 = add i64 %3569, 1
  store i64 %3570, ptr %NEXT_PC, align 8
  %3571 = load ptr, ptr %MEMORY, align 8
  %3572 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %3571, ptr %state, ptr undef)
  store ptr %3572, ptr %MEMORY, align 8
  %3573 = load i64, ptr %NEXT_PC, align 8
  store i64 %3573, ptr %PC, align 8
  %3574 = add i64 %3573, 2
  store i64 %3574, ptr %NEXT_PC, align 8
  %3575 = load i64, ptr %RBX, align 8
  %3576 = load ptr, ptr %MEMORY, align 8
  %3577 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %3576, ptr %state, i64 %3575)
  store ptr %3577, ptr %MEMORY, align 8
  %3578 = load i64, ptr %NEXT_PC, align 8
  store i64 %3578, ptr %PC, align 8
  %3579 = add i64 %3578, 2
  store i64 %3579, ptr %NEXT_PC, align 8
  %3580 = load i64, ptr %R13, align 8
  %3581 = load ptr, ptr %MEMORY, align 8
  %3582 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %3581, ptr %state, i64 %3580)
  store ptr %3582, ptr %MEMORY, align 8
  %3583 = load i64, ptr %NEXT_PC, align 8
  store i64 %3583, ptr %PC, align 8
  %3584 = add i64 %3583, 4
  store i64 %3584, ptr %NEXT_PC, align 8
  %3585 = load i64, ptr %RSP, align 8
  %3586 = load ptr, ptr %MEMORY, align 8
  %3587 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3586, ptr %state, ptr %RSP, i64 %3585, i64 56)
  store ptr %3587, ptr %MEMORY, align 8
  %3588 = load i64, ptr %NEXT_PC, align 8
  store i64 %3588, ptr %PC, align 8
  %3589 = add i64 %3588, 4
  store i64 %3589, ptr %NEXT_PC, align 8
  %3590 = load i64, ptr %RCX, align 8
  %3591 = add i64 %3590, 24
  %3592 = load ptr, ptr %MEMORY, align 8
  %3593 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2MnIjElEEP6MemoryS6_R5StateT_T0_(ptr %3592, ptr %state, ptr %RAX, i64 %3591)
  store ptr %3593, ptr %MEMORY, align 8
  %3594 = load i64, ptr %NEXT_PC, align 8
  store i64 %3594, ptr %PC, align 8
  %3595 = add i64 %3594, 3
  store i64 %3595, ptr %NEXT_PC, align 8
  %3596 = load i64, ptr %R13, align 8
  %3597 = load i32, ptr %R13D, align 4
  %3598 = zext i32 %3597 to i64
  %3599 = load ptr, ptr %MEMORY, align 8
  %3600 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %3599, ptr %state, ptr %R13, i64 %3596, i64 %3598)
  store ptr %3600, ptr %MEMORY, align 8
  %3601 = load i64, ptr %NEXT_PC, align 8
  store i64 %3601, ptr %PC, align 8
  %3602 = add i64 %3601, 5
  store i64 %3602, ptr %NEXT_PC, align 8
  %3603 = load i64, ptr %RSP, align 8
  %3604 = add i64 %3603, 88
  %3605 = load i64, ptr %RSI, align 8
  %3606 = load ptr, ptr %MEMORY, align 8
  %3607 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3606, ptr %state, i64 %3604, i64 %3605)
  store ptr %3607, ptr %MEMORY, align 8
  %3608 = load i64, ptr %NEXT_PC, align 8
  store i64 %3608, ptr %PC, align 8
  %3609 = add i64 %3608, 3
  store i64 %3609, ptr %NEXT_PC, align 8
  %3610 = load i64, ptr %RCX, align 8
  %3611 = load ptr, ptr %MEMORY, align 8
  %3612 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3611, ptr %state, ptr %RSI, i64 %3610)
  store ptr %3612, ptr %MEMORY, align 8
  %3613 = load i64, ptr %NEXT_PC, align 8
  store i64 %3613, ptr %PC, align 8
  %3614 = add i64 %3613, 5
  store i64 %3614, ptr %NEXT_PC, align 8
  %3615 = load i64, ptr %RSP, align 8
  %3616 = add i64 %3615, 32
  %3617 = load i64, ptr %R15, align 8
  %3618 = load ptr, ptr %MEMORY, align 8
  %3619 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3618, ptr %state, i64 %3616, i64 %3617)
  store ptr %3619, ptr %MEMORY, align 8
  %3620 = load i64, ptr %NEXT_PC, align 8
  store i64 %3620, ptr %PC, align 8
  %3621 = add i64 %3620, 3
  store i64 %3621, ptr %NEXT_PC, align 8
  %3622 = load i64, ptr %RDX, align 8
  %3623 = load ptr, ptr %MEMORY, align 8
  %3624 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3623, ptr %state, ptr %R15, i64 %3622)
  store ptr %3624, ptr %MEMORY, align 8
  %3625 = load i64, ptr %NEXT_PC, align 8
  store i64 %3625, ptr %PC, align 8
  %3626 = add i64 %3625, 3
  store i64 %3626, ptr %NEXT_PC, align 8
  %3627 = load i32, ptr %R13D, align 4
  %3628 = zext i32 %3627 to i64
  %3629 = load ptr, ptr %MEMORY, align 8
  %3630 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3629, ptr %state, ptr %R9, i64 %3628)
  store ptr %3630, ptr %MEMORY, align 8
  %3631 = load i64, ptr %NEXT_PC, align 8
  store i64 %3631, ptr %PC, align 8
  %3632 = add i64 %3631, 2
  store i64 %3632, ptr %NEXT_PC, align 8
  %3633 = load i32, ptr %EAX, align 4
  %3634 = zext i32 %3633 to i64
  %3635 = load i32, ptr %EAX, align 4
  %3636 = zext i32 %3635 to i64
  %3637 = load ptr, ptr %MEMORY, align 8
  %3638 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3637, ptr %state, i64 %3634, i64 %3636)
  store ptr %3638, ptr %MEMORY, align 8
  %3639 = load i64, ptr %NEXT_PC, align 8
  store i64 %3639, ptr %PC, align 8
  %3640 = add i64 %3639, 6
  store i64 %3640, ptr %NEXT_PC, align 8
  %3641 = load i64, ptr %NEXT_PC, align 8
  %3642 = add i64 %3641, 273
  %3643 = load i64, ptr %NEXT_PC, align 8
  %3644 = load ptr, ptr %MEMORY, align 8
  %3645 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3644, ptr %state, ptr %BRANCH_TAKEN, i64 %3642, i64 %3643, ptr %NEXT_PC)
  store ptr %3645, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879099, label %bb_5389878826

bb_5389878826:                                    ; preds = %bb_5389878772
  %3646 = load i64, ptr %NEXT_PC, align 8
  store i64 %3646, ptr %PC, align 8
  %3647 = add i64 %3646, 3
  store i64 %3647, ptr %NEXT_PC, align 8
  %3648 = load i64, ptr %RDX, align 8
  %3649 = load ptr, ptr %MEMORY, align 8
  %3650 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3649, ptr %state, ptr %RCX, i64 %3648)
  store ptr %3650, ptr %MEMORY, align 8
  %3651 = load i64, ptr %NEXT_PC, align 8
  store i64 %3651, ptr %PC, align 8
  %3652 = add i64 %3651, 3
  store i64 %3652, ptr %NEXT_PC, align 8
  %3653 = load i64, ptr %RAX, align 8
  %3654 = load ptr, ptr %MEMORY, align 8
  %3655 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3654, ptr %state, ptr %R10, i64 %3653)
  store ptr %3655, ptr %MEMORY, align 8
  %3656 = load i64, ptr %NEXT_PC, align 8
  store i64 %3656, ptr %PC, align 8
  %3657 = add i64 %3656, 4
  store i64 %3657, ptr %NEXT_PC, align 8
  %3658 = load i64, ptr %RSI, align 8
  %3659 = add i64 %3658, 16
  %3660 = load ptr, ptr %MEMORY, align 8
  %3661 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3660, ptr %state, ptr %RAX, i64 %3659)
  store ptr %3661, ptr %MEMORY, align 8
  %3662 = load i64, ptr %NEXT_PC, align 8
  store i64 %3662, ptr %PC, align 8
  %3663 = add i64 %3662, 3
  store i64 %3663, ptr %NEXT_PC, align 8
  %3664 = load i32, ptr %R13D, align 4
  %3665 = zext i32 %3664 to i64
  %3666 = load ptr, ptr %MEMORY, align 8
  %3667 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3666, ptr %state, ptr %R8, i64 %3665)
  store ptr %3667, ptr %MEMORY, align 8
  br label %bb_5389878839

bb_5389878839:                                    ; preds = %bb_5389878844, %bb_5389878826
  %3668 = load i64, ptr %NEXT_PC, align 8
  store i64 %3668, ptr %PC, align 8
  %3669 = add i64 %3668, 3
  store i64 %3669, ptr %NEXT_PC, align 8
  %3670 = load i64, ptr %RAX, align 8
  %3671 = load i64, ptr %RCX, align 8
  %3672 = load ptr, ptr %MEMORY, align 8
  %3673 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %3672, ptr %state, i64 %3670, i64 %3671)
  store ptr %3673, ptr %MEMORY, align 8
  %3674 = load i64, ptr %NEXT_PC, align 8
  store i64 %3674, ptr %PC, align 8
  %3675 = add i64 %3674, 2
  store i64 %3675, ptr %NEXT_PC, align 8
  %3676 = load i64, ptr %NEXT_PC, align 8
  %3677 = add i64 %3676, 20
  %3678 = load i64, ptr %NEXT_PC, align 8
  %3679 = load ptr, ptr %MEMORY, align 8
  %3680 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3679, ptr %state, ptr %BRANCH_TAKEN, i64 %3677, i64 %3678, ptr %NEXT_PC)
  store ptr %3680, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878864, label %bb_5389878844

bb_5389878844:                                    ; preds = %bb_5389878839
  %3681 = load i64, ptr %NEXT_PC, align 8
  store i64 %3681, ptr %PC, align 8
  %3682 = add i64 %3681, 3
  store i64 %3682, ptr %NEXT_PC, align 8
  %3683 = load i64, ptr %R9, align 8
  %3684 = load ptr, ptr %MEMORY, align 8
  %3685 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3684, ptr %state, ptr %R9, i64 %3683)
  store ptr %3685, ptr %MEMORY, align 8
  %3686 = load i64, ptr %NEXT_PC, align 8
  store i64 %3686, ptr %PC, align 8
  %3687 = add i64 %3686, 3
  store i64 %3687, ptr %NEXT_PC, align 8
  %3688 = load i64, ptr %R8, align 8
  %3689 = load ptr, ptr %MEMORY, align 8
  %3690 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3689, ptr %state, ptr %R8, i64 %3688)
  store ptr %3690, ptr %MEMORY, align 8
  %3691 = load i64, ptr %NEXT_PC, align 8
  store i64 %3691, ptr %PC, align 8
  %3692 = add i64 %3691, 4
  store i64 %3692, ptr %NEXT_PC, align 8
  %3693 = load i64, ptr %RAX, align 8
  %3694 = load ptr, ptr %MEMORY, align 8
  %3695 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3694, ptr %state, ptr %RAX, i64 %3693, i64 8)
  store ptr %3695, ptr %MEMORY, align 8
  %3696 = load i64, ptr %NEXT_PC, align 8
  store i64 %3696, ptr %PC, align 8
  %3697 = add i64 %3696, 3
  store i64 %3697, ptr %NEXT_PC, align 8
  %3698 = load i64, ptr %R8, align 8
  %3699 = load i64, ptr %R10, align 8
  %3700 = load ptr, ptr %MEMORY, align 8
  %3701 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3700, ptr %state, i64 %3698, i64 %3699)
  store ptr %3701, ptr %MEMORY, align 8
  %3702 = load i64, ptr %NEXT_PC, align 8
  store i64 %3702, ptr %PC, align 8
  %3703 = add i64 %3702, 2
  store i64 %3703, ptr %NEXT_PC, align 8
  %3704 = load i64, ptr %NEXT_PC, align 8
  %3705 = sub i64 %3704, 20
  %3706 = load i64, ptr %NEXT_PC, align 8
  %3707 = load ptr, ptr %MEMORY, align 8
  %3708 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3707, ptr %state, ptr %BRANCH_TAKEN, i64 %3705, i64 %3706, ptr %NEXT_PC)
  store ptr %3708, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878839, label %bb_5389878859

bb_5389878859:                                    ; preds = %bb_5389878844
  %3709 = load i64, ptr %NEXT_PC, align 8
  store i64 %3709, ptr %PC, align 8
  %3710 = add i64 %3709, 5
  store i64 %3710, ptr %NEXT_PC, align 8
  %3711 = load i64, ptr %NEXT_PC, align 8
  %3712 = add i64 %3711, 235
  %3713 = load ptr, ptr %MEMORY, align 8
  %3714 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %3713, ptr %state, i64 %3712, ptr %NEXT_PC)
  store ptr %3714, ptr %MEMORY, align 8
  br label %bb_5389879099

bb_5389878864:                                    ; preds = %bb_5389878839
  %3715 = load i64, ptr %NEXT_PC, align 8
  store i64 %3715, ptr %PC, align 8
  %3716 = add i64 %3715, 4
  store i64 %3716, ptr %NEXT_PC, align 8
  %3717 = load i64, ptr %RSI, align 8
  %3718 = add i64 %3717, 48
  %3719 = load ptr, ptr %MEMORY, align 8
  %3720 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3719, ptr %state, ptr %RAX, i64 %3718)
  store ptr %3720, ptr %MEMORY, align 8
  %3721 = load i64, ptr %NEXT_PC, align 8
  store i64 %3721, ptr %PC, align 8
  %3722 = add i64 %3721, 5
  store i64 %3722, ptr %NEXT_PC, align 8
  %3723 = load i64, ptr %RSP, align 8
  %3724 = add i64 %3723, 80
  %3725 = load i64, ptr %RBP, align 8
  %3726 = load ptr, ptr %MEMORY, align 8
  %3727 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3726, ptr %state, i64 %3724, i64 %3725)
  store ptr %3727, ptr %MEMORY, align 8
  %3728 = load i64, ptr %NEXT_PC, align 8
  store i64 %3728, ptr %PC, align 8
  %3729 = add i64 %3728, 5
  store i64 %3729, ptr %NEXT_PC, align 8
  %3730 = load i64, ptr %RSP, align 8
  %3731 = add i64 %3730, 96
  %3732 = load i64, ptr %RDI, align 8
  %3733 = load ptr, ptr %MEMORY, align 8
  %3734 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3733, ptr %state, i64 %3731, i64 %3732)
  store ptr %3734, ptr %MEMORY, align 8
  %3735 = load i64, ptr %NEXT_PC, align 8
  store i64 %3735, ptr %PC, align 8
  %3736 = add i64 %3735, 5
  store i64 %3736, ptr %NEXT_PC, align 8
  %3737 = load i64, ptr %RSP, align 8
  %3738 = add i64 %3737, 48
  %3739 = load i64, ptr %R12, align 8
  %3740 = load ptr, ptr %MEMORY, align 8
  %3741 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3740, ptr %state, i64 %3738, i64 %3739)
  store ptr %3741, ptr %MEMORY, align 8
  %3742 = load i64, ptr %NEXT_PC, align 8
  store i64 %3742, ptr %PC, align 8
  %3743 = add i64 %3742, 5
  store i64 %3743, ptr %NEXT_PC, align 8
  %3744 = load i64, ptr %RSP, align 8
  %3745 = add i64 %3744, 40
  %3746 = load i64, ptr %R14, align 8
  %3747 = load ptr, ptr %MEMORY, align 8
  %3748 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3747, ptr %state, i64 %3745, i64 %3746)
  store ptr %3748, ptr %MEMORY, align 8
  %3749 = load i64, ptr %NEXT_PC, align 8
  store i64 %3749, ptr %PC, align 8
  %3750 = add i64 %3749, 4
  store i64 %3750, ptr %NEXT_PC, align 8
  %3751 = load i64, ptr %RCX, align 8
  %3752 = add i64 %3751, 48
  %3753 = load i64, ptr %RAX, align 8
  %3754 = load ptr, ptr %MEMORY, align 8
  %3755 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %3754, ptr %state, i64 %3752, i64 %3753)
  store ptr %3755, ptr %MEMORY, align 8
  %3756 = load i64, ptr %NEXT_PC, align 8
  store i64 %3756, ptr %PC, align 8
  %3757 = add i64 %3756, 2
  store i64 %3757, ptr %NEXT_PC, align 8
  %3758 = load i64, ptr %NEXT_PC, align 8
  %3759 = add i64 %3758, 2
  %3760 = load i64, ptr %NEXT_PC, align 8
  %3761 = load ptr, ptr %MEMORY, align 8
  %3762 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3761, ptr %state, ptr %BRANCH_TAKEN, i64 %3759, i64 %3760, ptr %NEXT_PC)
  store ptr %3762, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878896, label %bb_5389878894

bb_5389878894:                                    ; preds = %bb_5389878864
  %3763 = load i64, ptr %NEXT_PC, align 8
  store i64 %3763, ptr %PC, align 8
  %3764 = add i64 %3763, 2
  store i64 %3764, ptr %NEXT_PC, align 8
  %3765 = load i64, ptr %RAX, align 8
  %3766 = load i64, ptr %RAX, align 8
  %3767 = load ptr, ptr %MEMORY, align 8
  %3768 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3767, ptr %state, i64 %3765, i64 %3766)
  store ptr %3768, ptr %MEMORY, align 8
  br label %bb_5389878896

bb_5389878896:                                    ; preds = %bb_5389878894, %bb_5389878864
  %3769 = load i64, ptr %NEXT_PC, align 8
  store i64 %3769, ptr %PC, align 8
  %3770 = add i64 %3769, 3
  store i64 %3770, ptr %NEXT_PC, align 8
  %3771 = load i32, ptr %R9D, align 4
  %3772 = zext i32 %3771 to i64
  %3773 = load ptr, ptr %MEMORY, align 8
  %3774 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %3773, ptr %state, ptr %RDI, i64 %3772)
  store ptr %3774, ptr %MEMORY, align 8
  %3775 = load i64, ptr %NEXT_PC, align 8
  store i64 %3775, ptr %PC, align 8
  %3776 = add i64 %3775, 4
  store i64 %3776, ptr %NEXT_PC, align 8
  %3777 = load i64, ptr %R9, align 8
  %3778 = add i64 %3777, 1
  %3779 = load ptr, ptr %MEMORY, align 8
  %3780 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %3779, ptr %state, ptr %R14, i64 %3778)
  store ptr %3780, ptr %MEMORY, align 8
  %3781 = load i64, ptr %NEXT_PC, align 8
  store i64 %3781, ptr %PC, align 8
  %3782 = add i64 %3781, 3
  store i64 %3782, ptr %NEXT_PC, align 8
  %3783 = load i32, ptr %R14D, align 4
  %3784 = zext i32 %3783 to i64
  %3785 = load ptr, ptr %MEMORY, align 8
  %3786 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %3785, ptr %state, ptr %RBP, i64 %3784)
  store ptr %3786, ptr %MEMORY, align 8
  %3787 = load i64, ptr %NEXT_PC, align 8
  store i64 %3787, ptr %PC, align 8
  %3788 = add i64 %3787, 3
  store i64 %3788, ptr %NEXT_PC, align 8
  %3789 = load i64, ptr %RDI, align 8
  %3790 = load ptr, ptr %MEMORY, align 8
  %3791 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3790, ptr %state, ptr %R12, i64 %3789)
  store ptr %3791, ptr %MEMORY, align 8
  %3792 = load i64, ptr %NEXT_PC, align 8
  store i64 %3792, ptr %PC, align 8
  %3793 = add i64 %3792, 3
  store i64 %3793, ptr %NEXT_PC, align 8
  %3794 = load i64, ptr %RDI, align 8
  %3795 = load i64, ptr %RBP, align 8
  %3796 = load ptr, ptr %MEMORY, align 8
  %3797 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3796, ptr %state, i64 %3794, i64 %3795)
  store ptr %3797, ptr %MEMORY, align 8
  %3798 = load i64, ptr %NEXT_PC, align 8
  store i64 %3798, ptr %PC, align 8
  %3799 = add i64 %3798, 2
  store i64 %3799, ptr %NEXT_PC, align 8
  %3800 = load i64, ptr %NEXT_PC, align 8
  %3801 = add i64 %3800, 121
  %3802 = load i64, ptr %NEXT_PC, align 8
  %3803 = load ptr, ptr %MEMORY, align 8
  %3804 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3803, ptr %state, ptr %BRANCH_TAKEN, i64 %3801, i64 %3802, ptr %NEXT_PC)
  store ptr %3804, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879035, label %bb_5389878914

bb_5389878914:                                    ; preds = %bb_5389879027, %bb_5389878896
  %3805 = load i64, ptr %NEXT_PC, align 8
  store i64 %3805, ptr %PC, align 8
  %3806 = add i64 %3805, 4
  store i64 %3806, ptr %NEXT_PC, align 8
  %3807 = load i64, ptr %RSI, align 8
  %3808 = add i64 %3807, 16
  %3809 = load ptr, ptr %MEMORY, align 8
  %3810 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3809, ptr %state, ptr %RAX, i64 %3808)
  store ptr %3810, ptr %MEMORY, align 8
  %3811 = load i64, ptr %NEXT_PC, align 8
  store i64 %3811, ptr %PC, align 8
  %3812 = add i64 %3811, 4
  store i64 %3812, ptr %NEXT_PC, align 8
  %3813 = load i64, ptr %RAX, align 8
  %3814 = load i64, ptr %RDI, align 8
  %3815 = mul i64 %3814, 8
  %3816 = add i64 %3813, %3815
  %3817 = load ptr, ptr %MEMORY, align 8
  %3818 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3817, ptr %state, ptr %RBX, i64 %3816)
  store ptr %3818, ptr %MEMORY, align 8
  %3819 = load i64, ptr %NEXT_PC, align 8
  store i64 %3819, ptr %PC, align 8
  %3820 = add i64 %3819, 3
  store i64 %3820, ptr %NEXT_PC, align 8
  %3821 = load i64, ptr %RBX, align 8
  %3822 = load i64, ptr %RBX, align 8
  %3823 = load ptr, ptr %MEMORY, align 8
  %3824 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %3823, ptr %state, i64 %3821, i64 %3822)
  store ptr %3824, ptr %MEMORY, align 8
  %3825 = load i64, ptr %NEXT_PC, align 8
  store i64 %3825, ptr %PC, align 8
  %3826 = add i64 %3825, 2
  store i64 %3826, ptr %NEXT_PC, align 8
  %3827 = load i64, ptr %NEXT_PC, align 8
  %3828 = add i64 %3827, 100
  %3829 = load i64, ptr %NEXT_PC, align 8
  %3830 = load ptr, ptr %MEMORY, align 8
  %3831 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3830, ptr %state, ptr %BRANCH_TAKEN, i64 %3828, i64 %3829, ptr %NEXT_PC)
  store ptr %3831, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879027, label %bb_5389878927

bb_5389878927:                                    ; preds = %bb_5389878914
  %3832 = load i64, ptr %NEXT_PC, align 8
  store i64 %3832, ptr %PC, align 8
  %3833 = add i64 %3832, 4
  store i64 %3833, ptr %NEXT_PC, align 8
  %3834 = load i64, ptr %RBX, align 8
  %3835 = add i64 %3834, 48
  %3836 = load ptr, ptr %MEMORY, align 8
  %3837 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3836, ptr %state, ptr %RCX, i64 %3835)
  store ptr %3837, ptr %MEMORY, align 8
  %3838 = load i64, ptr %NEXT_PC, align 8
  store i64 %3838, ptr %PC, align 8
  %3839 = add i64 %3838, 4
  store i64 %3839, ptr %NEXT_PC, align 8
  %3840 = load i64, ptr %RCX, align 8
  %3841 = add i64 %3840, 16
  %3842 = load ptr, ptr %MEMORY, align 8
  %3843 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %3842, ptr %state, ptr %RAX, i64 %3841)
  store ptr %3843, ptr %MEMORY, align 8
  %3844 = load i64, ptr %NEXT_PC, align 8
  store i64 %3844, ptr %PC, align 8
  %3845 = add i64 %3844, 2
  store i64 %3845, ptr %NEXT_PC, align 8
  %3846 = load i8, ptr %AL, align 1
  %3847 = zext i8 %3846 to i64
  %3848 = load ptr, ptr %MEMORY, align 8
  %3849 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %3848, ptr %state, i64 %3847, i64 2)
  store ptr %3849, ptr %MEMORY, align 8
  %3850 = load i64, ptr %NEXT_PC, align 8
  store i64 %3850, ptr %PC, align 8
  %3851 = add i64 %3850, 2
  store i64 %3851, ptr %NEXT_PC, align 8
  %3852 = load i64, ptr %NEXT_PC, align 8
  %3853 = add i64 %3852, 88
  %3854 = load i64, ptr %NEXT_PC, align 8
  %3855 = load ptr, ptr %MEMORY, align 8
  %3856 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3855, ptr %state, ptr %BRANCH_TAKEN, i64 %3853, i64 %3854, ptr %NEXT_PC)
  store ptr %3856, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879027, label %bb_5389878939

bb_5389878939:                                    ; preds = %bb_5389878927
  %3857 = load i64, ptr %NEXT_PC, align 8
  store i64 %3857, ptr %PC, align 8
  %3858 = add i64 %3857, 2
  store i64 %3858, ptr %NEXT_PC, align 8
  %3859 = load i8, ptr %AL, align 1
  %3860 = zext i8 %3859 to i64
  %3861 = load ptr, ptr %MEMORY, align 8
  %3862 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %3861, ptr %state, i64 %3860, i64 1)
  store ptr %3862, ptr %MEMORY, align 8
  %3863 = load i64, ptr %NEXT_PC, align 8
  store i64 %3863, ptr %PC, align 8
  %3864 = add i64 %3863, 2
  store i64 %3864, ptr %NEXT_PC, align 8
  %3865 = load i64, ptr %NEXT_PC, align 8
  %3866 = add i64 %3865, 22
  %3867 = load i64, ptr %NEXT_PC, align 8
  %3868 = load ptr, ptr %MEMORY, align 8
  %3869 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3868, ptr %state, ptr %BRANCH_TAKEN, i64 %3866, i64 %3867, ptr %NEXT_PC)
  store ptr %3869, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878965, label %bb_5389878943

bb_5389878943:                                    ; preds = %bb_5389878939
  %3870 = load i64, ptr %NEXT_PC, align 8
  store i64 %3870, ptr %PC, align 8
  %3871 = add i64 %3870, 4
  store i64 %3871, ptr %NEXT_PC, align 8
  %3872 = load i64, ptr %RCX, align 8
  %3873 = add i64 %3872, 16
  %3874 = load i64, ptr %RCX, align 8
  %3875 = add i64 %3874, 16
  %3876 = load ptr, ptr %MEMORY, align 8
  %3877 = call ptr @_ZN12_GLOBAL__N_13ANDI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3876, ptr %state, i64 %3873, i64 %3875, i64 254)
  store ptr %3877, ptr %MEMORY, align 8
  %3878 = load i64, ptr %NEXT_PC, align 8
  store i64 %3878, ptr %PC, align 8
  %3879 = add i64 %3878, 4
  store i64 %3879, ptr %NEXT_PC, align 8
  %3880 = load i64, ptr %RCX, align 8
  %3881 = add i64 %3880, 16
  %3882 = load ptr, ptr %MEMORY, align 8
  %3883 = call ptr @_ZN12_GLOBAL__N_14TESTI2MnIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %3882, ptr %state, i64 %3881, i64 2)
  store ptr %3883, ptr %MEMORY, align 8
  %3884 = load i64, ptr %NEXT_PC, align 8
  store i64 %3884, ptr %PC, align 8
  %3885 = add i64 %3884, 3
  store i64 %3885, ptr %NEXT_PC, align 8
  %3886 = load i64, ptr %RCX, align 8
  %3887 = load i32, ptr %R13D, align 4
  %3888 = zext i32 %3887 to i64
  %3889 = load ptr, ptr %MEMORY, align 8
  %3890 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3889, ptr %state, i64 %3886, i64 %3888)
  store ptr %3890, ptr %MEMORY, align 8
  %3891 = load i64, ptr %NEXT_PC, align 8
  store i64 %3891, ptr %PC, align 8
  %3892 = add i64 %3891, 2
  store i64 %3892, ptr %NEXT_PC, align 8
  %3893 = load i64, ptr %NEXT_PC, align 8
  %3894 = add i64 %3893, 9
  %3895 = load i64, ptr %NEXT_PC, align 8
  %3896 = load ptr, ptr %MEMORY, align 8
  %3897 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3896, ptr %state, ptr %BRANCH_TAKEN, i64 %3894, i64 %3895, ptr %NEXT_PC)
  store ptr %3897, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878965, label %bb_5389878956

bb_5389878956:                                    ; preds = %bb_5389878943
  %3898 = load i64, ptr %NEXT_PC, align 8
  store i64 %3898, ptr %PC, align 8
  %3899 = add i64 %3898, 4
  store i64 %3899, ptr %NEXT_PC, align 8
  %3900 = load i64, ptr %RCX, align 8
  %3901 = add i64 %3900, 8
  %3902 = load ptr, ptr %MEMORY, align 8
  %3903 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3902, ptr %state, ptr %RDX, i64 %3901)
  store ptr %3903, ptr %MEMORY, align 8
  %3904 = load i64, ptr %NEXT_PC, align 8
  store i64 %3904, ptr %PC, align 8
  %3905 = add i64 %3904, 5
  store i64 %3905, ptr %NEXT_PC, align 8
  %3906 = load i64, ptr %NEXT_PC, align 8
  %3907 = sub i64 %3906, 3621
  %3908 = load i64, ptr %NEXT_PC, align 8
  %3909 = load ptr, ptr %MEMORY, align 8
  %3910 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3909, ptr %state, i64 %3907, ptr %NEXT_PC, i64 %3908, ptr %RETURN_PC)
  store ptr %3910, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878965:                                    ; preds = %bb_5389878943, %bb_5389878939
  %3911 = load i64, ptr %NEXT_PC, align 8
  store i64 %3911, ptr %PC, align 8
  %3912 = add i64 %3911, 2
  store i64 %3912, ptr %NEXT_PC, align 8
  %3913 = load i64, ptr %RBX, align 8
  %3914 = load i64, ptr %RBX, align 8
  %3915 = load ptr, ptr %MEMORY, align 8
  %3916 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3915, ptr %state, i64 %3913, i64 %3914)
  store ptr %3916, ptr %MEMORY, align 8
  %3917 = load i64, ptr %NEXT_PC, align 8
  store i64 %3917, ptr %PC, align 8
  %3918 = add i64 %3917, 4
  store i64 %3918, ptr %NEXT_PC, align 8
  %3919 = load i64, ptr %RBX, align 8
  %3920 = add i64 %3919, 48
  %3921 = load ptr, ptr %MEMORY, align 8
  %3922 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3921, ptr %state, ptr %RAX, i64 %3920)
  store ptr %3922, ptr %MEMORY, align 8
  %3923 = load i64, ptr %NEXT_PC, align 8
  store i64 %3923, ptr %PC, align 8
  %3924 = add i64 %3923, 2
  store i64 %3924, ptr %NEXT_PC, align 8
  %3925 = load i64, ptr %RAX, align 8
  %3926 = load i64, ptr %RAX, align 8
  %3927 = load ptr, ptr %MEMORY, align 8
  %3928 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3927, ptr %state, i64 %3925, i64 %3926)
  store ptr %3928, ptr %MEMORY, align 8
  %3929 = load i64, ptr %NEXT_PC, align 8
  store i64 %3929, ptr %PC, align 8
  %3930 = add i64 %3929, 4
  store i64 %3930, ptr %NEXT_PC, align 8
  %3931 = load i64, ptr %RBX, align 8
  %3932 = add i64 %3931, 48
  %3933 = load ptr, ptr %MEMORY, align 8
  %3934 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3933, ptr %state, ptr %RBX, i64 %3932)
  store ptr %3934, ptr %MEMORY, align 8
  %3935 = load i64, ptr %NEXT_PC, align 8
  store i64 %3935, ptr %PC, align 8
  %3936 = add i64 %3935, 3
  store i64 %3936, ptr %NEXT_PC, align 8
  %3937 = load i64, ptr %RBX, align 8
  %3938 = load i32, ptr %R13D, align 4
  %3939 = zext i32 %3938 to i64
  %3940 = load ptr, ptr %MEMORY, align 8
  %3941 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %3940, ptr %state, i64 %3937, i64 %3939)
  store ptr %3941, ptr %MEMORY, align 8
  %3942 = load i64, ptr %NEXT_PC, align 8
  store i64 %3942, ptr %PC, align 8
  %3943 = add i64 %3942, 2
  store i64 %3943, ptr %NEXT_PC, align 8
  %3944 = load i64, ptr %NEXT_PC, align 8
  %3945 = add i64 %3944, 45
  %3946 = load i64, ptr %NEXT_PC, align 8
  %3947 = load ptr, ptr %MEMORY, align 8
  %3948 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %3947, ptr %state, ptr %BRANCH_TAKEN, i64 %3945, i64 %3946, ptr %NEXT_PC)
  store ptr %3948, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879027, label %bb_5389878982

bb_5389878982:                                    ; preds = %bb_5389878965
  %3949 = load i64, ptr %NEXT_PC, align 8
  store i64 %3949, ptr %PC, align 8
  %3950 = add i64 %3949, 4
  store i64 %3950, ptr %NEXT_PC, align 8
  %3951 = load i64, ptr %RBX, align 8
  %3952 = add i64 %3951, 8
  %3953 = load ptr, ptr %MEMORY, align 8
  %3954 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3953, ptr %state, ptr %RDX, i64 %3952)
  store ptr %3954, ptr %MEMORY, align 8
  %3955 = load i64, ptr %NEXT_PC, align 8
  store i64 %3955, ptr %PC, align 8
  %3956 = add i64 %3955, 3
  store i64 %3956, ptr %NEXT_PC, align 8
  %3957 = load i64, ptr %RBX, align 8
  %3958 = load ptr, ptr %MEMORY, align 8
  %3959 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %3958, ptr %state, ptr %RCX, i64 %3957)
  store ptr %3959, ptr %MEMORY, align 8
  %3960 = load i64, ptr %NEXT_PC, align 8
  store i64 %3960, ptr %PC, align 8
  %3961 = add i64 %3960, 4
  store i64 %3961, ptr %NEXT_PC, align 8
  %3962 = load i64, ptr %RBX, align 8
  %3963 = add i64 %3962, 16
  %3964 = load i64, ptr %RBX, align 8
  %3965 = add i64 %3964, 16
  %3966 = load ptr, ptr %MEMORY, align 8
  %3967 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %3966, ptr %state, i64 %3963, i64 %3965, i64 2)
  store ptr %3967, ptr %MEMORY, align 8
  %3968 = load i64, ptr %NEXT_PC, align 8
  store i64 %3968, ptr %PC, align 8
  %3969 = add i64 %3968, 5
  store i64 %3969, ptr %NEXT_PC, align 8
  %3970 = load i64, ptr %NEXT_PC, align 8
  %3971 = sub i64 %3970, 3446
  %3972 = load i64, ptr %NEXT_PC, align 8
  %3973 = load ptr, ptr %MEMORY, align 8
  %3974 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3973, ptr %state, i64 %3971, ptr %NEXT_PC, i64 %3972, ptr %RETURN_PC)
  store ptr %3974, ptr %MEMORY, align 8
  %3975 = load i64, ptr %NEXT_PC, align 8
  store i64 %3975, ptr %PC, align 8
  %3976 = add i64 %3975, 4
  store i64 %3976, ptr %NEXT_PC, align 8
  %3977 = load i64, ptr %RBX, align 8
  %3978 = add i64 %3977, 8
  %3979 = load ptr, ptr %MEMORY, align 8
  %3980 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3979, ptr %state, ptr %RDX, i64 %3978)
  store ptr %3980, ptr %MEMORY, align 8
  %3981 = load i64, ptr %NEXT_PC, align 8
  store i64 %3981, ptr %PC, align 8
  %3982 = add i64 %3981, 7
  store i64 %3982, ptr %NEXT_PC, align 8
  %3983 = load i64, ptr %NEXT_PC, align 8
  %3984 = add i64 %3983, 26998767
  %3985 = load ptr, ptr %MEMORY, align 8
  %3986 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3985, ptr %state, ptr %RCX, i64 %3984)
  store ptr %3986, ptr %MEMORY, align 8
  %3987 = load i64, ptr %NEXT_PC, align 8
  store i64 %3987, ptr %PC, align 8
  %3988 = add i64 %3987, 5
  store i64 %3988, ptr %NEXT_PC, align 8
  %3989 = load i64, ptr %NEXT_PC, align 8
  %3990 = add i64 %3989, 49594
  %3991 = load i64, ptr %NEXT_PC, align 8
  %3992 = load ptr, ptr %MEMORY, align 8
  %3993 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %3992, ptr %state, i64 %3990, ptr %NEXT_PC, i64 %3991, ptr %RETURN_PC)
  store ptr %3993, ptr %MEMORY, align 8
  %3994 = load i64, ptr %NEXT_PC, align 8
  store i64 %3994, ptr %PC, align 8
  %3995 = add i64 %3994, 5
  store i64 %3995, ptr %NEXT_PC, align 8
  %3996 = load ptr, ptr %MEMORY, align 8
  %3997 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %3996, ptr %state, ptr %RDX, i64 24)
  store ptr %3997, ptr %MEMORY, align 8
  %3998 = load i64, ptr %NEXT_PC, align 8
  store i64 %3998, ptr %PC, align 8
  %3999 = add i64 %3998, 3
  store i64 %3999, ptr %NEXT_PC, align 8
  %4000 = load i64, ptr %RBX, align 8
  %4001 = load ptr, ptr %MEMORY, align 8
  %4002 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4001, ptr %state, ptr %RCX, i64 %4000)
  store ptr %4002, ptr %MEMORY, align 8
  %4003 = load i64, ptr %NEXT_PC, align 8
  store i64 %4003, ptr %PC, align 8
  %4004 = add i64 %4003, 5
  store i64 %4004, ptr %NEXT_PC, align 8
  %4005 = load i64, ptr %NEXT_PC, align 8
  %4006 = sub i64 %4005, 1165715
  %4007 = load i64, ptr %NEXT_PC, align 8
  %4008 = load ptr, ptr %MEMORY, align 8
  %4009 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4008, ptr %state, i64 %4006, ptr %NEXT_PC, i64 %4007, ptr %RETURN_PC)
  store ptr %4009, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879027:                                    ; preds = %bb_5389878965, %bb_5389878927, %bb_5389878914
  %4010 = load i64, ptr %NEXT_PC, align 8
  store i64 %4010, ptr %PC, align 8
  %4011 = add i64 %4010, 3
  store i64 %4011, ptr %NEXT_PC, align 8
  %4012 = load i64, ptr %RDI, align 8
  %4013 = load ptr, ptr %MEMORY, align 8
  %4014 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4013, ptr %state, ptr %RDI, i64 %4012)
  store ptr %4014, ptr %MEMORY, align 8
  %4015 = load i64, ptr %NEXT_PC, align 8
  store i64 %4015, ptr %PC, align 8
  %4016 = add i64 %4015, 3
  store i64 %4016, ptr %NEXT_PC, align 8
  %4017 = load i64, ptr %RDI, align 8
  %4018 = load i64, ptr %RBP, align 8
  %4019 = load ptr, ptr %MEMORY, align 8
  %4020 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4019, ptr %state, i64 %4017, i64 %4018)
  store ptr %4020, ptr %MEMORY, align 8
  %4021 = load i64, ptr %NEXT_PC, align 8
  store i64 %4021, ptr %PC, align 8
  %4022 = add i64 %4021, 2
  store i64 %4022, ptr %NEXT_PC, align 8
  %4023 = load i64, ptr %NEXT_PC, align 8
  %4024 = sub i64 %4023, 121
  %4025 = load i64, ptr %NEXT_PC, align 8
  %4026 = load ptr, ptr %MEMORY, align 8
  %4027 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4026, ptr %state, ptr %BRANCH_TAKEN, i64 %4024, i64 %4025, ptr %NEXT_PC)
  store ptr %4027, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878914, label %bb_5389879035

bb_5389879035:                                    ; preds = %bb_5389879027, %bb_5389878896
  %4028 = load i64, ptr %NEXT_PC, align 8
  store i64 %4028, ptr %PC, align 8
  %4029 = add i64 %4028, 3
  store i64 %4029, ptr %NEXT_PC, align 8
  %4030 = load i64, ptr %RSI, align 8
  %4031 = add i64 %4030, 24
  %4032 = load ptr, ptr %MEMORY, align 8
  %4033 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4032, ptr %state, ptr %RAX, i64 %4031)
  store ptr %4033, ptr %MEMORY, align 8
  %4034 = load i64, ptr %NEXT_PC, align 8
  store i64 %4034, ptr %PC, align 8
  %4035 = add i64 %4034, 2
  store i64 %4035, ptr %NEXT_PC, align 8
  %4036 = load i32, ptr %EAX, align 4
  %4037 = zext i32 %4036 to i64
  %4038 = load ptr, ptr %MEMORY, align 8
  %4039 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4038, ptr %state, ptr %RCX, i64 %4037)
  store ptr %4039, ptr %MEMORY, align 8
  %4040 = load i64, ptr %NEXT_PC, align 8
  store i64 %4040, ptr %PC, align 8
  %4041 = add i64 %4040, 5
  store i64 %4041, ptr %NEXT_PC, align 8
  %4042 = load i64, ptr %RSP, align 8
  %4043 = add i64 %4042, 96
  %4044 = load ptr, ptr %MEMORY, align 8
  %4045 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4044, ptr %state, ptr %RDI, i64 %4043)
  store ptr %4045, ptr %MEMORY, align 8
  %4046 = load i64, ptr %NEXT_PC, align 8
  store i64 %4046, ptr %PC, align 8
  %4047 = add i64 %4046, 3
  store i64 %4047, ptr %NEXT_PC, align 8
  %4048 = load i64, ptr %RCX, align 8
  %4049 = load i32, ptr %R14D, align 4
  %4050 = zext i32 %4049 to i64
  %4051 = load ptr, ptr %MEMORY, align 8
  %4052 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4051, ptr %state, ptr %RCX, i64 %4048, i64 %4050)
  store ptr %4052, ptr %MEMORY, align 8
  %4053 = load i64, ptr %NEXT_PC, align 8
  store i64 %4053, ptr %PC, align 8
  %4054 = add i64 %4053, 5
  store i64 %4054, ptr %NEXT_PC, align 8
  %4055 = load i64, ptr %RSP, align 8
  %4056 = add i64 %4055, 40
  %4057 = load ptr, ptr %MEMORY, align 8
  %4058 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4057, ptr %state, ptr %R14, i64 %4056)
  store ptr %4058, ptr %MEMORY, align 8
  %4059 = load i64, ptr %NEXT_PC, align 8
  store i64 %4059, ptr %PC, align 8
  %4060 = add i64 %4059, 2
  store i64 %4060, ptr %NEXT_PC, align 8
  %4061 = load i32, ptr %ECX, align 4
  %4062 = zext i32 %4061 to i64
  %4063 = load i32, ptr %ECX, align 4
  %4064 = zext i32 %4063 to i64
  %4065 = load ptr, ptr %MEMORY, align 8
  %4066 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4065, ptr %state, i64 %4062, i64 %4064)
  store ptr %4066, ptr %MEMORY, align 8
  %4067 = load i64, ptr %NEXT_PC, align 8
  store i64 %4067, ptr %PC, align 8
  %4068 = add i64 %4067, 2
  store i64 %4068, ptr %NEXT_PC, align 8
  %4069 = load i64, ptr %NEXT_PC, align 8
  %4070 = add i64 %4069, 27
  %4071 = load i64, ptr %NEXT_PC, align 8
  %4072 = load ptr, ptr %MEMORY, align 8
  %4073 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4072, ptr %state, ptr %BRANCH_TAKEN, i64 %4070, i64 %4071, ptr %NEXT_PC)
  store ptr %4073, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879084, label %bb_5389879057

bb_5389879057:                                    ; preds = %bb_5389879035
  %4074 = load i64, ptr %NEXT_PC, align 8
  store i64 %4074, ptr %PC, align 8
  %4075 = add i64 %4074, 4
  store i64 %4075, ptr %NEXT_PC, align 8
  %4076 = load i64, ptr %RSI, align 8
  %4077 = add i64 %4076, 16
  %4078 = load ptr, ptr %MEMORY, align 8
  %4079 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4078, ptr %state, ptr %RAX, i64 %4077)
  store ptr %4079, ptr %MEMORY, align 8
  %4080 = load i64, ptr %NEXT_PC, align 8
  store i64 %4080, ptr %PC, align 8
  %4081 = add i64 %4080, 3
  store i64 %4081, ptr %NEXT_PC, align 8
  %4082 = load i32, ptr %ECX, align 4
  %4083 = zext i32 %4082 to i64
  %4084 = load ptr, ptr %MEMORY, align 8
  %4085 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %4084, ptr %state, ptr %R8, i64 %4083)
  store ptr %4085, ptr %MEMORY, align 8
  %4086 = load i64, ptr %NEXT_PC, align 8
  store i64 %4086, ptr %PC, align 8
  %4087 = add i64 %4086, 4
  store i64 %4087, ptr %NEXT_PC, align 8
  %4088 = load i64, ptr %R8, align 8
  %4089 = load ptr, ptr %MEMORY, align 8
  %4090 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4089, ptr %state, ptr %R8, i64 %4088, i64 3)
  store ptr %4090, ptr %MEMORY, align 8
  %4091 = load i64, ptr %NEXT_PC, align 8
  store i64 %4091, ptr %PC, align 8
  %4092 = add i64 %4091, 4
  store i64 %4092, ptr %NEXT_PC, align 8
  %4093 = load i64, ptr %RAX, align 8
  %4094 = load i64, ptr %RBP, align 8
  %4095 = mul i64 %4094, 8
  %4096 = add i64 %4093, %4095
  %4097 = load ptr, ptr %MEMORY, align 8
  %4098 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4097, ptr %state, ptr %RDX, i64 %4096)
  store ptr %4098, ptr %MEMORY, align 8
  %4099 = load i64, ptr %NEXT_PC, align 8
  store i64 %4099, ptr %PC, align 8
  %4100 = add i64 %4099, 4
  store i64 %4100, ptr %NEXT_PC, align 8
  %4101 = load i64, ptr %RAX, align 8
  %4102 = load i64, ptr %R12, align 8
  %4103 = mul i64 %4102, 8
  %4104 = add i64 %4101, %4103
  %4105 = load ptr, ptr %MEMORY, align 8
  %4106 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4105, ptr %state, ptr %RCX, i64 %4104)
  store ptr %4106, ptr %MEMORY, align 8
  %4107 = load i64, ptr %NEXT_PC, align 8
  store i64 %4107, ptr %PC, align 8
  %4108 = add i64 %4107, 5
  store i64 %4108, ptr %NEXT_PC, align 8
  %4109 = load i64, ptr %NEXT_PC, align 8
  %4110 = add i64 %4109, 11852992
  %4111 = load i64, ptr %NEXT_PC, align 8
  %4112 = load ptr, ptr %MEMORY, align 8
  %4113 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4112, ptr %state, i64 %4110, ptr %NEXT_PC, i64 %4111, ptr %RETURN_PC)
  store ptr %4113, ptr %MEMORY, align 8
  %4114 = load i64, ptr %NEXT_PC, align 8
  store i64 %4114, ptr %PC, align 8
  %4115 = add i64 %4114, 3
  store i64 %4115, ptr %NEXT_PC, align 8
  %4116 = load i64, ptr %RSI, align 8
  %4117 = add i64 %4116, 24
  %4118 = load ptr, ptr %MEMORY, align 8
  %4119 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4118, ptr %state, ptr %RAX, i64 %4117)
  store ptr %4119, ptr %MEMORY, align 8
  br label %bb_5389879084

bb_5389879084:                                    ; preds = %bb_5389879057, %bb_5389879035
  %4120 = load i64, ptr %NEXT_PC, align 8
  store i64 %4120, ptr %PC, align 8
  %4121 = add i64 %4120, 5
  store i64 %4121, ptr %NEXT_PC, align 8
  %4122 = load i64, ptr %RSP, align 8
  %4123 = add i64 %4122, 48
  %4124 = load ptr, ptr %MEMORY, align 8
  %4125 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4124, ptr %state, ptr %R12, i64 %4123)
  store ptr %4125, ptr %MEMORY, align 8
  %4126 = load i64, ptr %NEXT_PC, align 8
  store i64 %4126, ptr %PC, align 8
  %4127 = add i64 %4126, 2
  store i64 %4127, ptr %NEXT_PC, align 8
  %4128 = load i64, ptr %RAX, align 8
  %4129 = load ptr, ptr %MEMORY, align 8
  %4130 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4129, ptr %state, ptr %RAX, i64 %4128)
  store ptr %4130, ptr %MEMORY, align 8
  %4131 = load i64, ptr %NEXT_PC, align 8
  store i64 %4131, ptr %PC, align 8
  %4132 = add i64 %4131, 5
  store i64 %4132, ptr %NEXT_PC, align 8
  %4133 = load i64, ptr %RSP, align 8
  %4134 = add i64 %4133, 80
  %4135 = load ptr, ptr %MEMORY, align 8
  %4136 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4135, ptr %state, ptr %RBP, i64 %4134)
  store ptr %4136, ptr %MEMORY, align 8
  %4137 = load i64, ptr %NEXT_PC, align 8
  store i64 %4137, ptr %PC, align 8
  %4138 = add i64 %4137, 3
  store i64 %4138, ptr %NEXT_PC, align 8
  %4139 = load i64, ptr %RSI, align 8
  %4140 = add i64 %4139, 24
  %4141 = load i32, ptr %EAX, align 4
  %4142 = zext i32 %4141 to i64
  %4143 = load ptr, ptr %MEMORY, align 8
  %4144 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4143, ptr %state, i64 %4140, i64 %4142)
  store ptr %4144, ptr %MEMORY, align 8
  br label %bb_5389879099

bb_5389879099:                                    ; preds = %bb_5389879084, %bb_5389878859, %bb_5389878772
  %4145 = load i64, ptr %NEXT_PC, align 8
  store i64 %4145, ptr %PC, align 8
  %4146 = add i64 %4145, 3
  store i64 %4146, ptr %NEXT_PC, align 8
  %4147 = load i64, ptr %R15, align 8
  %4148 = load ptr, ptr %MEMORY, align 8
  %4149 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4148, ptr %state, ptr %RBX, i64 %4147)
  store ptr %4149, ptr %MEMORY, align 8
  %4150 = load i64, ptr %NEXT_PC, align 8
  store i64 %4150, ptr %PC, align 8
  %4151 = add i64 %4150, 5
  store i64 %4151, ptr %NEXT_PC, align 8
  %4152 = load i64, ptr %RSP, align 8
  %4153 = add i64 %4152, 32
  %4154 = load ptr, ptr %MEMORY, align 8
  %4155 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4154, ptr %state, ptr %R15, i64 %4153)
  store ptr %4155, ptr %MEMORY, align 8
  %4156 = load i64, ptr %NEXT_PC, align 8
  store i64 %4156, ptr %PC, align 8
  %4157 = add i64 %4156, 5
  store i64 %4157, ptr %NEXT_PC, align 8
  %4158 = load i64, ptr %RSP, align 8
  %4159 = add i64 %4158, 88
  %4160 = load ptr, ptr %MEMORY, align 8
  %4161 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4160, ptr %state, ptr %RSI, i64 %4159)
  store ptr %4161, ptr %MEMORY, align 8
  %4162 = load i64, ptr %NEXT_PC, align 8
  store i64 %4162, ptr %PC, align 8
  %4163 = add i64 %4162, 3
  store i64 %4163, ptr %NEXT_PC, align 8
  %4164 = load i64, ptr %RBX, align 8
  %4165 = load i64, ptr %RBX, align 8
  %4166 = load ptr, ptr %MEMORY, align 8
  %4167 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4166, ptr %state, i64 %4164, i64 %4165)
  store ptr %4167, ptr %MEMORY, align 8
  %4168 = load i64, ptr %NEXT_PC, align 8
  store i64 %4168, ptr %PC, align 8
  %4169 = add i64 %4168, 2
  store i64 %4169, ptr %NEXT_PC, align 8
  %4170 = load i64, ptr %NEXT_PC, align 8
  %4171 = add i64 %4170, 100
  %4172 = load i64, ptr %NEXT_PC, align 8
  %4173 = load ptr, ptr %MEMORY, align 8
  %4174 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4173, ptr %state, ptr %BRANCH_TAKEN, i64 %4171, i64 %4172, ptr %NEXT_PC)
  store ptr %4174, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879217, label %bb_5389879117

bb_5389879117:                                    ; preds = %bb_5389879099
  %4175 = load i64, ptr %NEXT_PC, align 8
  store i64 %4175, ptr %PC, align 8
  %4176 = add i64 %4175, 4
  store i64 %4176, ptr %NEXT_PC, align 8
  %4177 = load i64, ptr %RBX, align 8
  %4178 = add i64 %4177, 48
  %4179 = load ptr, ptr %MEMORY, align 8
  %4180 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4179, ptr %state, ptr %RCX, i64 %4178)
  store ptr %4180, ptr %MEMORY, align 8
  %4181 = load i64, ptr %NEXT_PC, align 8
  store i64 %4181, ptr %PC, align 8
  %4182 = add i64 %4181, 4
  store i64 %4182, ptr %NEXT_PC, align 8
  %4183 = load i64, ptr %RCX, align 8
  %4184 = add i64 %4183, 16
  %4185 = load ptr, ptr %MEMORY, align 8
  %4186 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %4185, ptr %state, ptr %RAX, i64 %4184)
  store ptr %4186, ptr %MEMORY, align 8
  %4187 = load i64, ptr %NEXT_PC, align 8
  store i64 %4187, ptr %PC, align 8
  %4188 = add i64 %4187, 2
  store i64 %4188, ptr %NEXT_PC, align 8
  %4189 = load i8, ptr %AL, align 1
  %4190 = zext i8 %4189 to i64
  %4191 = load ptr, ptr %MEMORY, align 8
  %4192 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %4191, ptr %state, i64 %4190, i64 2)
  store ptr %4192, ptr %MEMORY, align 8
  %4193 = load i64, ptr %NEXT_PC, align 8
  store i64 %4193, ptr %PC, align 8
  %4194 = add i64 %4193, 2
  store i64 %4194, ptr %NEXT_PC, align 8
  %4195 = load i64, ptr %NEXT_PC, align 8
  %4196 = add i64 %4195, 88
  %4197 = load i64, ptr %NEXT_PC, align 8
  %4198 = load ptr, ptr %MEMORY, align 8
  %4199 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4198, ptr %state, ptr %BRANCH_TAKEN, i64 %4196, i64 %4197, ptr %NEXT_PC)
  store ptr %4199, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879217, label %bb_5389879129

bb_5389879129:                                    ; preds = %bb_5389879117
  %4200 = load i64, ptr %NEXT_PC, align 8
  store i64 %4200, ptr %PC, align 8
  %4201 = add i64 %4200, 2
  store i64 %4201, ptr %NEXT_PC, align 8
  %4202 = load i8, ptr %AL, align 1
  %4203 = zext i8 %4202 to i64
  %4204 = load ptr, ptr %MEMORY, align 8
  %4205 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %4204, ptr %state, i64 %4203, i64 1)
  store ptr %4205, ptr %MEMORY, align 8
  %4206 = load i64, ptr %NEXT_PC, align 8
  store i64 %4206, ptr %PC, align 8
  %4207 = add i64 %4206, 2
  store i64 %4207, ptr %NEXT_PC, align 8
  %4208 = load i64, ptr %NEXT_PC, align 8
  %4209 = add i64 %4208, 22
  %4210 = load i64, ptr %NEXT_PC, align 8
  %4211 = load ptr, ptr %MEMORY, align 8
  %4212 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4211, ptr %state, ptr %BRANCH_TAKEN, i64 %4209, i64 %4210, ptr %NEXT_PC)
  store ptr %4212, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879155, label %bb_5389879133

bb_5389879133:                                    ; preds = %bb_5389879129
  %4213 = load i64, ptr %NEXT_PC, align 8
  store i64 %4213, ptr %PC, align 8
  %4214 = add i64 %4213, 4
  store i64 %4214, ptr %NEXT_PC, align 8
  %4215 = load i64, ptr %RCX, align 8
  %4216 = add i64 %4215, 16
  %4217 = load i64, ptr %RCX, align 8
  %4218 = add i64 %4217, 16
  %4219 = load ptr, ptr %MEMORY, align 8
  %4220 = call ptr @_ZN12_GLOBAL__N_13ANDI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4219, ptr %state, i64 %4216, i64 %4218, i64 254)
  store ptr %4220, ptr %MEMORY, align 8
  %4221 = load i64, ptr %NEXT_PC, align 8
  store i64 %4221, ptr %PC, align 8
  %4222 = add i64 %4221, 4
  store i64 %4222, ptr %NEXT_PC, align 8
  %4223 = load i64, ptr %RCX, align 8
  %4224 = add i64 %4223, 16
  %4225 = load ptr, ptr %MEMORY, align 8
  %4226 = call ptr @_ZN12_GLOBAL__N_14TESTI2MnIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %4225, ptr %state, i64 %4224, i64 2)
  store ptr %4226, ptr %MEMORY, align 8
  %4227 = load i64, ptr %NEXT_PC, align 8
  store i64 %4227, ptr %PC, align 8
  %4228 = add i64 %4227, 3
  store i64 %4228, ptr %NEXT_PC, align 8
  %4229 = load i64, ptr %RCX, align 8
  %4230 = load i32, ptr %R13D, align 4
  %4231 = zext i32 %4230 to i64
  %4232 = load ptr, ptr %MEMORY, align 8
  %4233 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4232, ptr %state, i64 %4229, i64 %4231)
  store ptr %4233, ptr %MEMORY, align 8
  %4234 = load i64, ptr %NEXT_PC, align 8
  store i64 %4234, ptr %PC, align 8
  %4235 = add i64 %4234, 2
  store i64 %4235, ptr %NEXT_PC, align 8
  %4236 = load i64, ptr %NEXT_PC, align 8
  %4237 = add i64 %4236, 9
  %4238 = load i64, ptr %NEXT_PC, align 8
  %4239 = load ptr, ptr %MEMORY, align 8
  %4240 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4239, ptr %state, ptr %BRANCH_TAKEN, i64 %4237, i64 %4238, ptr %NEXT_PC)
  store ptr %4240, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879155, label %bb_5389879146

bb_5389879146:                                    ; preds = %bb_5389879133
  %4241 = load i64, ptr %NEXT_PC, align 8
  store i64 %4241, ptr %PC, align 8
  %4242 = add i64 %4241, 4
  store i64 %4242, ptr %NEXT_PC, align 8
  %4243 = load i64, ptr %RCX, align 8
  %4244 = add i64 %4243, 8
  %4245 = load ptr, ptr %MEMORY, align 8
  %4246 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4245, ptr %state, ptr %RDX, i64 %4244)
  store ptr %4246, ptr %MEMORY, align 8
  %4247 = load i64, ptr %NEXT_PC, align 8
  store i64 %4247, ptr %PC, align 8
  %4248 = add i64 %4247, 5
  store i64 %4248, ptr %NEXT_PC, align 8
  %4249 = load i64, ptr %NEXT_PC, align 8
  %4250 = sub i64 %4249, 3811
  %4251 = load i64, ptr %NEXT_PC, align 8
  %4252 = load ptr, ptr %MEMORY, align 8
  %4253 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4252, ptr %state, i64 %4250, ptr %NEXT_PC, i64 %4251, ptr %RETURN_PC)
  store ptr %4253, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879155:                                    ; preds = %bb_5389879133, %bb_5389879129
  %4254 = load i64, ptr %NEXT_PC, align 8
  store i64 %4254, ptr %PC, align 8
  %4255 = add i64 %4254, 2
  store i64 %4255, ptr %NEXT_PC, align 8
  %4256 = load i64, ptr %RBX, align 8
  %4257 = load i64, ptr %RBX, align 8
  %4258 = load ptr, ptr %MEMORY, align 8
  %4259 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4258, ptr %state, i64 %4256, i64 %4257)
  store ptr %4259, ptr %MEMORY, align 8
  %4260 = load i64, ptr %NEXT_PC, align 8
  store i64 %4260, ptr %PC, align 8
  %4261 = add i64 %4260, 4
  store i64 %4261, ptr %NEXT_PC, align 8
  %4262 = load i64, ptr %RBX, align 8
  %4263 = add i64 %4262, 48
  %4264 = load ptr, ptr %MEMORY, align 8
  %4265 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4264, ptr %state, ptr %RAX, i64 %4263)
  store ptr %4265, ptr %MEMORY, align 8
  %4266 = load i64, ptr %NEXT_PC, align 8
  store i64 %4266, ptr %PC, align 8
  %4267 = add i64 %4266, 2
  store i64 %4267, ptr %NEXT_PC, align 8
  %4268 = load i64, ptr %RAX, align 8
  %4269 = load i64, ptr %RAX, align 8
  %4270 = load ptr, ptr %MEMORY, align 8
  %4271 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4270, ptr %state, i64 %4268, i64 %4269)
  store ptr %4271, ptr %MEMORY, align 8
  %4272 = load i64, ptr %NEXT_PC, align 8
  store i64 %4272, ptr %PC, align 8
  %4273 = add i64 %4272, 4
  store i64 %4273, ptr %NEXT_PC, align 8
  %4274 = load i64, ptr %RBX, align 8
  %4275 = add i64 %4274, 48
  %4276 = load ptr, ptr %MEMORY, align 8
  %4277 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4276, ptr %state, ptr %RBX, i64 %4275)
  store ptr %4277, ptr %MEMORY, align 8
  %4278 = load i64, ptr %NEXT_PC, align 8
  store i64 %4278, ptr %PC, align 8
  %4279 = add i64 %4278, 3
  store i64 %4279, ptr %NEXT_PC, align 8
  %4280 = load i64, ptr %RBX, align 8
  %4281 = load i32, ptr %R13D, align 4
  %4282 = zext i32 %4281 to i64
  %4283 = load ptr, ptr %MEMORY, align 8
  %4284 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %4283, ptr %state, i64 %4280, i64 %4282)
  store ptr %4284, ptr %MEMORY, align 8
  %4285 = load i64, ptr %NEXT_PC, align 8
  store i64 %4285, ptr %PC, align 8
  %4286 = add i64 %4285, 2
  store i64 %4286, ptr %NEXT_PC, align 8
  %4287 = load i64, ptr %NEXT_PC, align 8
  %4288 = add i64 %4287, 45
  %4289 = load i64, ptr %NEXT_PC, align 8
  %4290 = load ptr, ptr %MEMORY, align 8
  %4291 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4290, ptr %state, ptr %BRANCH_TAKEN, i64 %4288, i64 %4289, ptr %NEXT_PC)
  store ptr %4291, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879217, label %bb_5389879172

bb_5389879172:                                    ; preds = %bb_5389879155
  %4292 = load i64, ptr %NEXT_PC, align 8
  store i64 %4292, ptr %PC, align 8
  %4293 = add i64 %4292, 4
  store i64 %4293, ptr %NEXT_PC, align 8
  %4294 = load i64, ptr %RBX, align 8
  %4295 = add i64 %4294, 8
  %4296 = load ptr, ptr %MEMORY, align 8
  %4297 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4296, ptr %state, ptr %RDX, i64 %4295)
  store ptr %4297, ptr %MEMORY, align 8
  %4298 = load i64, ptr %NEXT_PC, align 8
  store i64 %4298, ptr %PC, align 8
  %4299 = add i64 %4298, 3
  store i64 %4299, ptr %NEXT_PC, align 8
  %4300 = load i64, ptr %RBX, align 8
  %4301 = load ptr, ptr %MEMORY, align 8
  %4302 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4301, ptr %state, ptr %RCX, i64 %4300)
  store ptr %4302, ptr %MEMORY, align 8
  %4303 = load i64, ptr %NEXT_PC, align 8
  store i64 %4303, ptr %PC, align 8
  %4304 = add i64 %4303, 4
  store i64 %4304, ptr %NEXT_PC, align 8
  %4305 = load i64, ptr %RBX, align 8
  %4306 = add i64 %4305, 16
  %4307 = load i64, ptr %RBX, align 8
  %4308 = add i64 %4307, 16
  %4309 = load ptr, ptr %MEMORY, align 8
  %4310 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4309, ptr %state, i64 %4306, i64 %4308, i64 2)
  store ptr %4310, ptr %MEMORY, align 8
  %4311 = load i64, ptr %NEXT_PC, align 8
  store i64 %4311, ptr %PC, align 8
  %4312 = add i64 %4311, 5
  store i64 %4312, ptr %NEXT_PC, align 8
  %4313 = load i64, ptr %NEXT_PC, align 8
  %4314 = sub i64 %4313, 3636
  %4315 = load i64, ptr %NEXT_PC, align 8
  %4316 = load ptr, ptr %MEMORY, align 8
  %4317 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4316, ptr %state, i64 %4314, ptr %NEXT_PC, i64 %4315, ptr %RETURN_PC)
  store ptr %4317, ptr %MEMORY, align 8
  %4318 = load i64, ptr %NEXT_PC, align 8
  store i64 %4318, ptr %PC, align 8
  %4319 = add i64 %4318, 4
  store i64 %4319, ptr %NEXT_PC, align 8
  %4320 = load i64, ptr %RBX, align 8
  %4321 = add i64 %4320, 8
  %4322 = load ptr, ptr %MEMORY, align 8
  %4323 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4322, ptr %state, ptr %RDX, i64 %4321)
  store ptr %4323, ptr %MEMORY, align 8
  %4324 = load i64, ptr %NEXT_PC, align 8
  store i64 %4324, ptr %PC, align 8
  %4325 = add i64 %4324, 7
  store i64 %4325, ptr %NEXT_PC, align 8
  %4326 = load i64, ptr %NEXT_PC, align 8
  %4327 = add i64 %4326, 26998577
  %4328 = load ptr, ptr %MEMORY, align 8
  %4329 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4328, ptr %state, ptr %RCX, i64 %4327)
  store ptr %4329, ptr %MEMORY, align 8
  %4330 = load i64, ptr %NEXT_PC, align 8
  store i64 %4330, ptr %PC, align 8
  %4331 = add i64 %4330, 5
  store i64 %4331, ptr %NEXT_PC, align 8
  %4332 = load i64, ptr %NEXT_PC, align 8
  %4333 = add i64 %4332, 49404
  %4334 = load i64, ptr %NEXT_PC, align 8
  %4335 = load ptr, ptr %MEMORY, align 8
  %4336 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4335, ptr %state, i64 %4333, ptr %NEXT_PC, i64 %4334, ptr %RETURN_PC)
  store ptr %4336, ptr %MEMORY, align 8
  %4337 = load i64, ptr %NEXT_PC, align 8
  store i64 %4337, ptr %PC, align 8
  %4338 = add i64 %4337, 5
  store i64 %4338, ptr %NEXT_PC, align 8
  %4339 = load ptr, ptr %MEMORY, align 8
  %4340 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %4339, ptr %state, ptr %RDX, i64 24)
  store ptr %4340, ptr %MEMORY, align 8
  %4341 = load i64, ptr %NEXT_PC, align 8
  store i64 %4341, ptr %PC, align 8
  %4342 = add i64 %4341, 3
  store i64 %4342, ptr %NEXT_PC, align 8
  %4343 = load i64, ptr %RBX, align 8
  %4344 = load ptr, ptr %MEMORY, align 8
  %4345 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4344, ptr %state, ptr %RCX, i64 %4343)
  store ptr %4345, ptr %MEMORY, align 8
  %4346 = load i64, ptr %NEXT_PC, align 8
  store i64 %4346, ptr %PC, align 8
  %4347 = add i64 %4346, 5
  store i64 %4347, ptr %NEXT_PC, align 8
  %4348 = load i64, ptr %NEXT_PC, align 8
  %4349 = sub i64 %4348, 1165905
  %4350 = load i64, ptr %NEXT_PC, align 8
  %4351 = load ptr, ptr %MEMORY, align 8
  %4352 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4351, ptr %state, i64 %4349, ptr %NEXT_PC, i64 %4350, ptr %RETURN_PC)
  store ptr %4352, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879217:                                    ; preds = %bb_5389879155, %bb_5389879117, %bb_5389879099
  %4353 = load i64, ptr %NEXT_PC, align 8
  store i64 %4353, ptr %PC, align 8
  %4354 = add i64 %4353, 4
  store i64 %4354, ptr %NEXT_PC, align 8
  %4355 = load i64, ptr %RSP, align 8
  %4356 = load ptr, ptr %MEMORY, align 8
  %4357 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4356, ptr %state, ptr %RSP, i64 %4355, i64 56)
  store ptr %4357, ptr %MEMORY, align 8
  %4358 = load i64, ptr %NEXT_PC, align 8
  store i64 %4358, ptr %PC, align 8
  %4359 = add i64 %4358, 2
  store i64 %4359, ptr %NEXT_PC, align 8
  %4360 = load ptr, ptr %MEMORY, align 8
  %4361 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %4360, ptr %state, ptr %R13)
  store ptr %4361, ptr %MEMORY, align 8
  %4362 = load i64, ptr %NEXT_PC, align 8
  store i64 %4362, ptr %PC, align 8
  %4363 = add i64 %4362, 1
  store i64 %4363, ptr %NEXT_PC, align 8
  %4364 = load ptr, ptr %MEMORY, align 8
  %4365 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %4364, ptr %state, ptr %RBX)
  store ptr %4365, ptr %MEMORY, align 8
  %4366 = load i64, ptr %NEXT_PC, align 8
  store i64 %4366, ptr %PC, align 8
  %4367 = add i64 %4366, 1
  store i64 %4367, ptr %NEXT_PC, align 8
  %4368 = load ptr, ptr %MEMORY, align 8
  %4369 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4368, ptr %state, ptr %NEXT_PC)
  store ptr %4369, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879225:                                    ; No predecessors!
  %4370 = load i64, ptr %NEXT_PC, align 8
  store i64 %4370, ptr %PC, align 8
  %4371 = add i64 %4370, 1
  store i64 %4371, ptr %NEXT_PC, align 8
  %4372 = load ptr, ptr %MEMORY, align 8
  %4373 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4372, ptr %state, ptr undef)
  store ptr %4373, ptr %MEMORY, align 8
  %4374 = load i64, ptr %NEXT_PC, align 8
  store i64 %4374, ptr %PC, align 8
  %4375 = add i64 %4374, 1
  store i64 %4375, ptr %NEXT_PC, align 8
  %4376 = load ptr, ptr %MEMORY, align 8
  %4377 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4376, ptr %state, ptr undef)
  store ptr %4377, ptr %MEMORY, align 8
  %4378 = load i64, ptr %NEXT_PC, align 8
  store i64 %4378, ptr %PC, align 8
  %4379 = add i64 %4378, 1
  store i64 %4379, ptr %NEXT_PC, align 8
  %4380 = load ptr, ptr %MEMORY, align 8
  %4381 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4380, ptr %state, ptr undef)
  store ptr %4381, ptr %MEMORY, align 8
  %4382 = load i64, ptr %NEXT_PC, align 8
  store i64 %4382, ptr %PC, align 8
  %4383 = add i64 %4382, 1
  store i64 %4383, ptr %NEXT_PC, align 8
  %4384 = load ptr, ptr %MEMORY, align 8
  %4385 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4384, ptr %state, ptr undef)
  store ptr %4385, ptr %MEMORY, align 8
  %4386 = load i64, ptr %NEXT_PC, align 8
  store i64 %4386, ptr %PC, align 8
  %4387 = add i64 %4386, 1
  store i64 %4387, ptr %NEXT_PC, align 8
  %4388 = load ptr, ptr %MEMORY, align 8
  %4389 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4388, ptr %state, ptr undef)
  store ptr %4389, ptr %MEMORY, align 8
  %4390 = load i64, ptr %NEXT_PC, align 8
  store i64 %4390, ptr %PC, align 8
  %4391 = add i64 %4390, 1
  store i64 %4391, ptr %NEXT_PC, align 8
  %4392 = load ptr, ptr %MEMORY, align 8
  %4393 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4392, ptr %state, ptr undef)
  store ptr %4393, ptr %MEMORY, align 8
  %4394 = load i64, ptr %NEXT_PC, align 8
  store i64 %4394, ptr %PC, align 8
  %4395 = add i64 %4394, 1
  store i64 %4395, ptr %NEXT_PC, align 8
  %4396 = load ptr, ptr %MEMORY, align 8
  %4397 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4396, ptr %state, ptr undef)
  store ptr %4397, ptr %MEMORY, align 8
  %4398 = load i64, ptr %NEXT_PC, align 8
  store i64 %4398, ptr %PC, align 8
  %4399 = add i64 %4398, 3
  store i64 %4399, ptr %NEXT_PC, align 8
  %4400 = load i32, ptr %R8D, align 4
  %4401 = zext i32 %4400 to i64
  %4402 = load i32, ptr %R8D, align 4
  %4403 = zext i32 %4402 to i64
  %4404 = load ptr, ptr %MEMORY, align 8
  %4405 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4404, ptr %state, i64 %4401, i64 %4403)
  store ptr %4405, ptr %MEMORY, align 8
  %4406 = load i64, ptr %NEXT_PC, align 8
  store i64 %4406, ptr %PC, align 8
  %4407 = add i64 %4406, 2
  store i64 %4407, ptr %NEXT_PC, align 8
  %4408 = load i64, ptr %NEXT_PC, align 8
  %4409 = add i64 %4408, 44
  %4410 = load i64, ptr %NEXT_PC, align 8
  %4411 = load ptr, ptr %MEMORY, align 8
  %4412 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4411, ptr %state, ptr %BRANCH_TAKEN, i64 %4409, i64 %4410, ptr %NEXT_PC)
  store ptr %4412, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879281, label %bb_5389879237

bb_5389879237:                                    ; preds = %bb_5389879225
  %4413 = load i64, ptr %NEXT_PC, align 8
  store i64 %4413, ptr %PC, align 8
  %4414 = add i64 %4413, 4
  store i64 %4414, ptr %NEXT_PC, align 8
  %4415 = load i32, ptr %R8D, align 4
  %4416 = zext i32 %4415 to i64
  %4417 = load i64, ptr %RCX, align 8
  %4418 = add i64 %4417, 24
  %4419 = load ptr, ptr %MEMORY, align 8
  %4420 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4419, ptr %state, i64 %4416, i64 %4418)
  store ptr %4420, ptr %MEMORY, align 8
  %4421 = load i64, ptr %NEXT_PC, align 8
  store i64 %4421, ptr %PC, align 8
  %4422 = add i64 %4421, 2
  store i64 %4422, ptr %NEXT_PC, align 8
  %4423 = load i64, ptr %NEXT_PC, align 8
  %4424 = add i64 %4423, 38
  %4425 = load i64, ptr %NEXT_PC, align 8
  %4426 = load ptr, ptr %MEMORY, align 8
  %4427 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4426, ptr %state, ptr %BRANCH_TAKEN, i64 %4424, i64 %4425, ptr %NEXT_PC)
  store ptr %4427, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879281, label %bb_5389879243

bb_5389879243:                                    ; preds = %bb_5389879237
  %4428 = load i64, ptr %NEXT_PC, align 8
  store i64 %4428, ptr %PC, align 8
  %4429 = add i64 %4428, 4
  store i64 %4429, ptr %NEXT_PC, align 8
  %4430 = load i64, ptr %RCX, align 8
  %4431 = add i64 %4430, 16
  %4432 = load ptr, ptr %MEMORY, align 8
  %4433 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4432, ptr %state, ptr %RAX, i64 %4431)
  store ptr %4433, ptr %MEMORY, align 8
  %4434 = load i64, ptr %NEXT_PC, align 8
  store i64 %4434, ptr %PC, align 8
  %4435 = add i64 %4434, 3
  store i64 %4435, ptr %NEXT_PC, align 8
  %4436 = load i32, ptr %R8D, align 4
  %4437 = zext i32 %4436 to i64
  %4438 = load ptr, ptr %MEMORY, align 8
  %4439 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %4438, ptr %state, ptr %R8, i64 %4437)
  store ptr %4439, ptr %MEMORY, align 8
  %4440 = load i64, ptr %NEXT_PC, align 8
  store i64 %4440, ptr %PC, align 8
  %4441 = add i64 %4440, 4
  store i64 %4441, ptr %NEXT_PC, align 8
  %4442 = load i64, ptr %RAX, align 8
  %4443 = load i64, ptr %R8, align 8
  %4444 = mul i64 %4443, 8
  %4445 = add i64 %4442, %4444
  %4446 = load ptr, ptr %MEMORY, align 8
  %4447 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4446, ptr %state, ptr %RCX, i64 %4445)
  store ptr %4447, ptr %MEMORY, align 8
  %4448 = load i64, ptr %NEXT_PC, align 8
  store i64 %4448, ptr %PC, align 8
  %4449 = add i64 %4448, 4
  store i64 %4449, ptr %NEXT_PC, align 8
  %4450 = load i64, ptr %RAX, align 8
  %4451 = load i64, ptr %R8, align 8
  %4452 = mul i64 %4451, 8
  %4453 = add i64 %4450, %4452
  %4454 = load ptr, ptr %MEMORY, align 8
  %4455 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4454, ptr %state, ptr %RAX, i64 %4453)
  store ptr %4455, ptr %MEMORY, align 8
  %4456 = load i64, ptr %NEXT_PC, align 8
  store i64 %4456, ptr %PC, align 8
  %4457 = add i64 %4456, 3
  store i64 %4457, ptr %NEXT_PC, align 8
  %4458 = load i64, ptr %RAX, align 8
  %4459 = load i64, ptr %RAX, align 8
  %4460 = load ptr, ptr %MEMORY, align 8
  %4461 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4460, ptr %state, i64 %4458, i64 %4459)
  store ptr %4461, ptr %MEMORY, align 8
  %4462 = load i64, ptr %NEXT_PC, align 8
  store i64 %4462, ptr %PC, align 8
  %4463 = add i64 %4462, 2
  store i64 %4463, ptr %NEXT_PC, align 8
  %4464 = load i64, ptr %NEXT_PC, align 8
  %4465 = add i64 %4464, 11
  %4466 = load i64, ptr %NEXT_PC, align 8
  %4467 = load ptr, ptr %MEMORY, align 8
  %4468 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4467, ptr %state, ptr %BRANCH_TAKEN, i64 %4465, i64 %4466, ptr %NEXT_PC)
  store ptr %4468, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879274, label %bb_5389879263

bb_5389879263:                                    ; preds = %bb_5389879243
  %4469 = load i64, ptr %NEXT_PC, align 8
  store i64 %4469, ptr %PC, align 8
  %4470 = add i64 %4469, 2
  store i64 %4470, ptr %NEXT_PC, align 8
  %4471 = load i64, ptr %RAX, align 8
  %4472 = load i64, ptr %RAX, align 8
  %4473 = load ptr, ptr %MEMORY, align 8
  %4474 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4473, ptr %state, i64 %4471, i64 %4472)
  store ptr %4474, ptr %MEMORY, align 8
  %4475 = load i64, ptr %NEXT_PC, align 8
  store i64 %4475, ptr %PC, align 8
  %4476 = add i64 %4475, 4
  store i64 %4476, ptr %NEXT_PC, align 8
  %4477 = load i64, ptr %RAX, align 8
  %4478 = add i64 %4477, 48
  %4479 = load ptr, ptr %MEMORY, align 8
  %4480 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4479, ptr %state, ptr %RAX, i64 %4478)
  store ptr %4480, ptr %MEMORY, align 8
  %4481 = load i64, ptr %NEXT_PC, align 8
  store i64 %4481, ptr %PC, align 8
  %4482 = add i64 %4481, 2
  store i64 %4482, ptr %NEXT_PC, align 8
  %4483 = load i64, ptr %RAX, align 8
  %4484 = load i64, ptr %RAX, align 8
  %4485 = load ptr, ptr %MEMORY, align 8
  %4486 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4485, ptr %state, i64 %4483, i64 %4484)
  store ptr %4486, ptr %MEMORY, align 8
  %4487 = load i64, ptr %NEXT_PC, align 8
  store i64 %4487, ptr %PC, align 8
  %4488 = add i64 %4487, 3
  store i64 %4488, ptr %NEXT_PC, align 8
  %4489 = load i64, ptr %RCX, align 8
  %4490 = load ptr, ptr %MEMORY, align 8
  %4491 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4490, ptr %state, ptr %RAX, i64 %4489)
  store ptr %4491, ptr %MEMORY, align 8
  br label %bb_5389879274

bb_5389879274:                                    ; preds = %bb_5389879263, %bb_5389879243
  %4492 = load i64, ptr %NEXT_PC, align 8
  store i64 %4492, ptr %PC, align 8
  %4493 = add i64 %4492, 3
  store i64 %4493, ptr %NEXT_PC, align 8
  %4494 = load i64, ptr %RDX, align 8
  %4495 = load i64, ptr %RAX, align 8
  %4496 = load ptr, ptr %MEMORY, align 8
  %4497 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4496, ptr %state, i64 %4494, i64 %4495)
  store ptr %4497, ptr %MEMORY, align 8
  %4498 = load i64, ptr %NEXT_PC, align 8
  store i64 %4498, ptr %PC, align 8
  %4499 = add i64 %4498, 3
  store i64 %4499, ptr %NEXT_PC, align 8
  %4500 = load i64, ptr %RDX, align 8
  %4501 = load ptr, ptr %MEMORY, align 8
  %4502 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4501, ptr %state, ptr %RAX, i64 %4500)
  store ptr %4502, ptr %MEMORY, align 8
  %4503 = load i64, ptr %NEXT_PC, align 8
  store i64 %4503, ptr %PC, align 8
  %4504 = add i64 %4503, 1
  store i64 %4504, ptr %NEXT_PC, align 8
  %4505 = load ptr, ptr %MEMORY, align 8
  %4506 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4505, ptr %state, ptr %NEXT_PC)
  store ptr %4506, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879281:                                    ; preds = %bb_5389879237, %bb_5389879225
  %4507 = load i64, ptr %NEXT_PC, align 8
  store i64 %4507, ptr %PC, align 8
  %4508 = add i64 %4507, 7
  store i64 %4508, ptr %NEXT_PC, align 8
  %4509 = load i64, ptr %RDX, align 8
  %4510 = load ptr, ptr %MEMORY, align 8
  %4511 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %4510, ptr %state, i64 %4509, i64 0)
  store ptr %4511, ptr %MEMORY, align 8
  %4512 = load i64, ptr %NEXT_PC, align 8
  store i64 %4512, ptr %PC, align 8
  %4513 = add i64 %4512, 3
  store i64 %4513, ptr %NEXT_PC, align 8
  %4514 = load i64, ptr %RDX, align 8
  %4515 = load ptr, ptr %MEMORY, align 8
  %4516 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4515, ptr %state, ptr %RAX, i64 %4514)
  store ptr %4516, ptr %MEMORY, align 8
  %4517 = load i64, ptr %NEXT_PC, align 8
  store i64 %4517, ptr %PC, align 8
  %4518 = add i64 %4517, 1
  store i64 %4518, ptr %NEXT_PC, align 8
  %4519 = load ptr, ptr %MEMORY, align 8
  %4520 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %4519, ptr %state, ptr %NEXT_PC)
  store ptr %4520, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879292:                                    ; No predecessors!
  %4521 = load i64, ptr %NEXT_PC, align 8
  store i64 %4521, ptr %PC, align 8
  %4522 = add i64 %4521, 1
  store i64 %4522, ptr %NEXT_PC, align 8
  %4523 = load ptr, ptr %MEMORY, align 8
  %4524 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4523, ptr %state, ptr undef)
  store ptr %4524, ptr %MEMORY, align 8
  %4525 = load i64, ptr %NEXT_PC, align 8
  store i64 %4525, ptr %PC, align 8
  %4526 = add i64 %4525, 1
  store i64 %4526, ptr %NEXT_PC, align 8
  %4527 = load ptr, ptr %MEMORY, align 8
  %4528 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4527, ptr %state, ptr undef)
  store ptr %4528, ptr %MEMORY, align 8
  %4529 = load i64, ptr %NEXT_PC, align 8
  store i64 %4529, ptr %PC, align 8
  %4530 = add i64 %4529, 1
  store i64 %4530, ptr %NEXT_PC, align 8
  %4531 = load ptr, ptr %MEMORY, align 8
  %4532 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4531, ptr %state, ptr undef)
  store ptr %4532, ptr %MEMORY, align 8
  %4533 = load i64, ptr %NEXT_PC, align 8
  store i64 %4533, ptr %PC, align 8
  %4534 = add i64 %4533, 1
  store i64 %4534, ptr %NEXT_PC, align 8
  %4535 = load ptr, ptr %MEMORY, align 8
  %4536 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4535, ptr %state, ptr undef)
  store ptr %4536, ptr %MEMORY, align 8
  %4537 = load i64, ptr %NEXT_PC, align 8
  store i64 %4537, ptr %PC, align 8
  %4538 = add i64 %4537, 1
  store i64 %4538, ptr %NEXT_PC, align 8
  %4539 = load ptr, ptr %MEMORY, align 8
  %4540 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4539, ptr %state, ptr undef)
  store ptr %4540, ptr %MEMORY, align 8
  %4541 = load i64, ptr %NEXT_PC, align 8
  store i64 %4541, ptr %PC, align 8
  %4542 = add i64 %4541, 1
  store i64 %4542, ptr %NEXT_PC, align 8
  %4543 = load ptr, ptr %MEMORY, align 8
  %4544 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4543, ptr %state, ptr undef)
  store ptr %4544, ptr %MEMORY, align 8
  %4545 = load i64, ptr %NEXT_PC, align 8
  store i64 %4545, ptr %PC, align 8
  %4546 = add i64 %4545, 1
  store i64 %4546, ptr %NEXT_PC, align 8
  %4547 = load ptr, ptr %MEMORY, align 8
  %4548 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4547, ptr %state, ptr undef)
  store ptr %4548, ptr %MEMORY, align 8
  %4549 = load i64, ptr %NEXT_PC, align 8
  store i64 %4549, ptr %PC, align 8
  %4550 = add i64 %4549, 1
  store i64 %4550, ptr %NEXT_PC, align 8
  %4551 = load ptr, ptr %MEMORY, align 8
  %4552 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4551, ptr %state, ptr undef)
  store ptr %4552, ptr %MEMORY, align 8
  %4553 = load i64, ptr %NEXT_PC, align 8
  store i64 %4553, ptr %PC, align 8
  %4554 = add i64 %4553, 1
  store i64 %4554, ptr %NEXT_PC, align 8
  %4555 = load ptr, ptr %MEMORY, align 8
  %4556 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4555, ptr %state, ptr undef)
  store ptr %4556, ptr %MEMORY, align 8
  %4557 = load i64, ptr %NEXT_PC, align 8
  store i64 %4557, ptr %PC, align 8
  %4558 = add i64 %4557, 1
  store i64 %4558, ptr %NEXT_PC, align 8
  %4559 = load ptr, ptr %MEMORY, align 8
  %4560 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4559, ptr %state, ptr undef)
  store ptr %4560, ptr %MEMORY, align 8
  %4561 = load i64, ptr %NEXT_PC, align 8
  store i64 %4561, ptr %PC, align 8
  %4562 = add i64 %4561, 1
  store i64 %4562, ptr %NEXT_PC, align 8
  %4563 = load ptr, ptr %MEMORY, align 8
  %4564 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4563, ptr %state, ptr undef)
  store ptr %4564, ptr %MEMORY, align 8
  %4565 = load i64, ptr %NEXT_PC, align 8
  store i64 %4565, ptr %PC, align 8
  %4566 = add i64 %4565, 1
  store i64 %4566, ptr %NEXT_PC, align 8
  %4567 = load ptr, ptr %MEMORY, align 8
  %4568 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4567, ptr %state, ptr undef)
  store ptr %4568, ptr %MEMORY, align 8
  %4569 = load i64, ptr %NEXT_PC, align 8
  store i64 %4569, ptr %PC, align 8
  %4570 = add i64 %4569, 1
  store i64 %4570, ptr %NEXT_PC, align 8
  %4571 = load ptr, ptr %MEMORY, align 8
  %4572 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4571, ptr %state, ptr undef)
  store ptr %4572, ptr %MEMORY, align 8
  %4573 = load i64, ptr %NEXT_PC, align 8
  store i64 %4573, ptr %PC, align 8
  %4574 = add i64 %4573, 1
  store i64 %4574, ptr %NEXT_PC, align 8
  %4575 = load ptr, ptr %MEMORY, align 8
  %4576 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4575, ptr %state, ptr undef)
  store ptr %4576, ptr %MEMORY, align 8
  %4577 = load i64, ptr %NEXT_PC, align 8
  store i64 %4577, ptr %PC, align 8
  %4578 = add i64 %4577, 1
  store i64 %4578, ptr %NEXT_PC, align 8
  %4579 = load ptr, ptr %MEMORY, align 8
  %4580 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4579, ptr %state, ptr undef)
  store ptr %4580, ptr %MEMORY, align 8
  %4581 = load i64, ptr %NEXT_PC, align 8
  store i64 %4581, ptr %PC, align 8
  %4582 = add i64 %4581, 1
  store i64 %4582, ptr %NEXT_PC, align 8
  %4583 = load ptr, ptr %MEMORY, align 8
  %4584 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4583, ptr %state, ptr undef)
  store ptr %4584, ptr %MEMORY, align 8
  %4585 = load i64, ptr %NEXT_PC, align 8
  store i64 %4585, ptr %PC, align 8
  %4586 = add i64 %4585, 1
  store i64 %4586, ptr %NEXT_PC, align 8
  %4587 = load ptr, ptr %MEMORY, align 8
  %4588 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4587, ptr %state, ptr undef)
  store ptr %4588, ptr %MEMORY, align 8
  %4589 = load i64, ptr %NEXT_PC, align 8
  store i64 %4589, ptr %PC, align 8
  %4590 = add i64 %4589, 1
  store i64 %4590, ptr %NEXT_PC, align 8
  %4591 = load ptr, ptr %MEMORY, align 8
  %4592 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4591, ptr %state, ptr undef)
  store ptr %4592, ptr %MEMORY, align 8
  %4593 = load i64, ptr %NEXT_PC, align 8
  store i64 %4593, ptr %PC, align 8
  %4594 = add i64 %4593, 1
  store i64 %4594, ptr %NEXT_PC, align 8
  %4595 = load ptr, ptr %MEMORY, align 8
  %4596 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4595, ptr %state, ptr undef)
  store ptr %4596, ptr %MEMORY, align 8
  %4597 = load i64, ptr %NEXT_PC, align 8
  store i64 %4597, ptr %PC, align 8
  %4598 = add i64 %4597, 1
  store i64 %4598, ptr %NEXT_PC, align 8
  %4599 = load ptr, ptr %MEMORY, align 8
  %4600 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %4599, ptr %state, ptr undef)
  store ptr %4600, ptr %MEMORY, align 8
  %4601 = load i64, ptr %NEXT_PC, align 8
  store i64 %4601, ptr %PC, align 8
  %4602 = add i64 %4601, 3
  store i64 %4602, ptr %NEXT_PC, align 8
  %4603 = load i64, ptr %RSP, align 8
  %4604 = load ptr, ptr %MEMORY, align 8
  %4605 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4604, ptr %state, ptr %R11, i64 %4603)
  store ptr %4605, ptr %MEMORY, align 8
  %4606 = load i64, ptr %NEXT_PC, align 8
  store i64 %4606, ptr %PC, align 8
  %4607 = add i64 %4606, 4
  store i64 %4607, ptr %NEXT_PC, align 8
  %4608 = load i64, ptr %R11, align 8
  %4609 = add i64 %4608, 16
  %4610 = load i64, ptr %RDX, align 8
  %4611 = load ptr, ptr %MEMORY, align 8
  %4612 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4611, ptr %state, i64 %4609, i64 %4610)
  store ptr %4612, ptr %MEMORY, align 8
  %4613 = load i64, ptr %NEXT_PC, align 8
  store i64 %4613, ptr %PC, align 8
  %4614 = add i64 %4613, 1
  store i64 %4614, ptr %NEXT_PC, align 8
  %4615 = load i64, ptr %RBP, align 8
  %4616 = load ptr, ptr %MEMORY, align 8
  %4617 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %4616, ptr %state, i64 %4615)
  store ptr %4617, ptr %MEMORY, align 8
  %4618 = load i64, ptr %NEXT_PC, align 8
  store i64 %4618, ptr %PC, align 8
  %4619 = add i64 %4618, 1
  store i64 %4619, ptr %NEXT_PC, align 8
  %4620 = load i64, ptr %RSI, align 8
  %4621 = load ptr, ptr %MEMORY, align 8
  %4622 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %4621, ptr %state, i64 %4620)
  store ptr %4622, ptr %MEMORY, align 8
  %4623 = load i64, ptr %NEXT_PC, align 8
  store i64 %4623, ptr %PC, align 8
  %4624 = add i64 %4623, 2
  store i64 %4624, ptr %NEXT_PC, align 8
  %4625 = load i64, ptr %R12, align 8
  %4626 = load ptr, ptr %MEMORY, align 8
  %4627 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %4626, ptr %state, i64 %4625)
  store ptr %4627, ptr %MEMORY, align 8
  %4628 = load i64, ptr %NEXT_PC, align 8
  store i64 %4628, ptr %PC, align 8
  %4629 = add i64 %4628, 2
  store i64 %4629, ptr %NEXT_PC, align 8
  %4630 = load i64, ptr %R13, align 8
  %4631 = load ptr, ptr %MEMORY, align 8
  %4632 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %4631, ptr %state, i64 %4630)
  store ptr %4632, ptr %MEMORY, align 8
  %4633 = load i64, ptr %NEXT_PC, align 8
  store i64 %4633, ptr %PC, align 8
  %4634 = add i64 %4633, 2
  store i64 %4634, ptr %NEXT_PC, align 8
  %4635 = load i64, ptr %R14, align 8
  %4636 = load ptr, ptr %MEMORY, align 8
  %4637 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %4636, ptr %state, i64 %4635)
  store ptr %4637, ptr %MEMORY, align 8
  %4638 = load i64, ptr %NEXT_PC, align 8
  store i64 %4638, ptr %PC, align 8
  %4639 = add i64 %4638, 2
  store i64 %4639, ptr %NEXT_PC, align 8
  %4640 = load i64, ptr %R15, align 8
  %4641 = load ptr, ptr %MEMORY, align 8
  %4642 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %4641, ptr %state, i64 %4640)
  store ptr %4642, ptr %MEMORY, align 8
  %4643 = load i64, ptr %NEXT_PC, align 8
  store i64 %4643, ptr %PC, align 8
  %4644 = add i64 %4643, 4
  store i64 %4644, ptr %NEXT_PC, align 8
  %4645 = load i64, ptr %R11, align 8
  %4646 = sub i64 %4645, 95
  %4647 = load ptr, ptr %MEMORY, align 8
  %4648 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4647, ptr %state, ptr %RBP, i64 %4646)
  store ptr %4648, ptr %MEMORY, align 8
  %4649 = load i64, ptr %NEXT_PC, align 8
  store i64 %4649, ptr %PC, align 8
  %4650 = add i64 %4649, 7
  store i64 %4650, ptr %NEXT_PC, align 8
  %4651 = load i64, ptr %RSP, align 8
  %4652 = load ptr, ptr %MEMORY, align 8
  %4653 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %4652, ptr %state, ptr %RSP, i64 %4651, i64 152)
  store ptr %4653, ptr %MEMORY, align 8
  %4654 = load i64, ptr %NEXT_PC, align 8
  store i64 %4654, ptr %PC, align 8
  %4655 = add i64 %4654, 2
  store i64 %4655, ptr %NEXT_PC, align 8
  %4656 = load i64, ptr %RSI, align 8
  %4657 = load i32, ptr %ESI, align 4
  %4658 = zext i32 %4657 to i64
  %4659 = load ptr, ptr %MEMORY, align 8
  %4660 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4659, ptr %state, ptr %RSI, i64 %4656, i64 %4658)
  store ptr %4660, ptr %MEMORY, align 8
  %4661 = load i64, ptr %NEXT_PC, align 8
  store i64 %4661, ptr %PC, align 8
  %4662 = add i64 %4661, 4
  store i64 %4662, ptr %NEXT_PC, align 8
  %4663 = load i64, ptr %R11, align 8
  %4664 = add i64 %4663, 8
  %4665 = load i64, ptr %RBX, align 8
  %4666 = load ptr, ptr %MEMORY, align 8
  %4667 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4666, ptr %state, i64 %4664, i64 %4665)
  store ptr %4667, ptr %MEMORY, align 8
  %4668 = load i64, ptr %NEXT_PC, align 8
  store i64 %4668, ptr %PC, align 8
  %4669 = add i64 %4668, 3
  store i64 %4669, ptr %NEXT_PC, align 8
  %4670 = load i64, ptr %R15, align 8
  %4671 = load i32, ptr %R15D, align 4
  %4672 = zext i32 %4671 to i64
  %4673 = load ptr, ptr %MEMORY, align 8
  %4674 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4673, ptr %state, ptr %R15, i64 %4670, i64 %4672)
  store ptr %4674, ptr %MEMORY, align 8
  %4675 = load i64, ptr %NEXT_PC, align 8
  store i64 %4675, ptr %PC, align 8
  %4676 = add i64 %4675, 4
  store i64 %4676, ptr %NEXT_PC, align 8
  %4677 = load i64, ptr %R11, align 8
  %4678 = sub i64 %4677, 56
  %4679 = load i64, ptr %RDI, align 8
  %4680 = load ptr, ptr %MEMORY, align 8
  %4681 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4680, ptr %state, i64 %4678, i64 %4679)
  store ptr %4681, ptr %MEMORY, align 8
  %4682 = load i64, ptr %NEXT_PC, align 8
  store i64 %4682, ptr %PC, align 8
  %4683 = add i64 %4682, 3
  store i64 %4683, ptr %NEXT_PC, align 8
  %4684 = load i64, ptr %R12, align 8
  %4685 = load i32, ptr %R12D, align 4
  %4686 = zext i32 %4685 to i64
  %4687 = load ptr, ptr %MEMORY, align 8
  %4688 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4687, ptr %state, ptr %R12, i64 %4684, i64 %4686)
  store ptr %4688, ptr %MEMORY, align 8
  %4689 = load i64, ptr %NEXT_PC, align 8
  store i64 %4689, ptr %PC, align 8
  %4690 = add i64 %4689, 3
  store i64 %4690, ptr %NEXT_PC, align 8
  %4691 = load i32, ptr %R8D, align 4
  %4692 = zext i32 %4691 to i64
  %4693 = load ptr, ptr %MEMORY, align 8
  %4694 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4693, ptr %state, ptr %R13, i64 %4692)
  store ptr %4694, ptr %MEMORY, align 8
  %4695 = load i64, ptr %NEXT_PC, align 8
  store i64 %4695, ptr %PC, align 8
  %4696 = add i64 %4695, 3
  store i64 %4696, ptr %NEXT_PC, align 8
  %4697 = load i64, ptr %RDX, align 8
  %4698 = load ptr, ptr %MEMORY, align 8
  %4699 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4698, ptr %state, ptr %RAX, i64 %4697)
  store ptr %4699, ptr %MEMORY, align 8
  %4700 = load i64, ptr %NEXT_PC, align 8
  store i64 %4700, ptr %PC, align 8
  %4701 = add i64 %4700, 3
  store i64 %4701, ptr %NEXT_PC, align 8
  %4702 = load i64, ptr %RCX, align 8
  %4703 = load ptr, ptr %MEMORY, align 8
  %4704 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4703, ptr %state, ptr %R14, i64 %4702)
  store ptr %4704, ptr %MEMORY, align 8
  br label %bb_5389879365

bb_5389879365:                                    ; preds = %bb_5389880055, %bb_5389879292
  %4705 = load i64, ptr %NEXT_PC, align 8
  store i64 %4705, ptr %PC, align 8
  %4706 = add i64 %4705, 3
  store i64 %4706, ptr %NEXT_PC, align 8
  %4707 = load i64, ptr %RAX, align 8
  %4708 = load ptr, ptr %MEMORY, align 8
  %4709 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4708, ptr %state, ptr %R8, i64 %4707)
  store ptr %4709, ptr %MEMORY, align 8
  %4710 = load i64, ptr %NEXT_PC, align 8
  store i64 %4710, ptr %PC, align 8
  %4711 = add i64 %4710, 3
  store i64 %4711, ptr %NEXT_PC, align 8
  %4712 = load i64, ptr %R8, align 8
  %4713 = load i64, ptr %R8, align 8
  %4714 = load ptr, ptr %MEMORY, align 8
  %4715 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4714, ptr %state, i64 %4712, i64 %4713)
  store ptr %4715, ptr %MEMORY, align 8
  %4716 = load i64, ptr %NEXT_PC, align 8
  store i64 %4716, ptr %PC, align 8
  %4717 = add i64 %4716, 2
  store i64 %4717, ptr %NEXT_PC, align 8
  %4718 = load i64, ptr %NEXT_PC, align 8
  %4719 = add i64 %4718, 4
  %4720 = load i64, ptr %NEXT_PC, align 8
  %4721 = load ptr, ptr %MEMORY, align 8
  %4722 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4721, ptr %state, ptr %BRANCH_TAKEN, i64 %4719, i64 %4720, ptr %NEXT_PC)
  store ptr %4722, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879377, label %bb_5389879373

bb_5389879373:                                    ; preds = %bb_5389879365
  %4723 = load i64, ptr %NEXT_PC, align 8
  store i64 %4723, ptr %PC, align 8
  %4724 = add i64 %4723, 2
  store i64 %4724, ptr %NEXT_PC, align 8
  %4725 = load i64, ptr %RAX, align 8
  %4726 = load i32, ptr %EAX, align 4
  %4727 = zext i32 %4726 to i64
  %4728 = load ptr, ptr %MEMORY, align 8
  %4729 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4728, ptr %state, ptr %RAX, i64 %4725, i64 %4727)
  store ptr %4729, ptr %MEMORY, align 8
  %4730 = load i64, ptr %NEXT_PC, align 8
  store i64 %4730, ptr %PC, align 8
  %4731 = add i64 %4730, 2
  store i64 %4731, ptr %NEXT_PC, align 8
  %4732 = load i64, ptr %NEXT_PC, align 8
  %4733 = add i64 %4732, 4
  %4734 = load ptr, ptr %MEMORY, align 8
  %4735 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %4734, ptr %state, i64 %4733, ptr %NEXT_PC)
  store ptr %4735, ptr %MEMORY, align 8
  br label %bb_5389879381

bb_5389879377:                                    ; preds = %bb_5389879365
  %4736 = load i64, ptr %NEXT_PC, align 8
  store i64 %4736, ptr %PC, align 8
  %4737 = add i64 %4736, 4
  store i64 %4737, ptr %NEXT_PC, align 8
  %4738 = load i64, ptr %R8, align 8
  %4739 = add i64 %4738, 40
  %4740 = load ptr, ptr %MEMORY, align 8
  %4741 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4740, ptr %state, ptr %RAX, i64 %4739)
  store ptr %4741, ptr %MEMORY, align 8
  br label %bb_5389879381

bb_5389879381:                                    ; preds = %bb_5389879377, %bb_5389879373
  %4742 = load i64, ptr %NEXT_PC, align 8
  store i64 %4742, ptr %PC, align 8
  %4743 = add i64 %4742, 2
  store i64 %4743, ptr %NEXT_PC, align 8
  %4744 = load i32, ptr %ESI, align 4
  %4745 = zext i32 %4744 to i64
  %4746 = load i32, ptr %EAX, align 4
  %4747 = zext i32 %4746 to i64
  %4748 = load ptr, ptr %MEMORY, align 8
  %4749 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4748, ptr %state, i64 %4745, i64 %4747)
  store ptr %4749, ptr %MEMORY, align 8
  %4750 = load i64, ptr %NEXT_PC, align 8
  store i64 %4750, ptr %PC, align 8
  %4751 = add i64 %4750, 6
  store i64 %4751, ptr %NEXT_PC, align 8
  %4752 = load i64, ptr %NEXT_PC, align 8
  %4753 = add i64 %4752, 684
  %4754 = load i64, ptr %NEXT_PC, align 8
  %4755 = load ptr, ptr %MEMORY, align 8
  %4756 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4755, ptr %state, ptr %BRANCH_TAKEN, i64 %4753, i64 %4754, ptr %NEXT_PC)
  store ptr %4756, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880073, label %bb_5389879389

bb_5389879389:                                    ; preds = %bb_5389879381
  %4757 = load i64, ptr %NEXT_PC, align 8
  store i64 %4757, ptr %PC, align 8
  %4758 = add i64 %4757, 3
  store i64 %4758, ptr %NEXT_PC, align 8
  %4759 = load i64, ptr %R8, align 8
  %4760 = load i64, ptr %R8, align 8
  %4761 = load ptr, ptr %MEMORY, align 8
  %4762 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4761, ptr %state, i64 %4759, i64 %4760)
  store ptr %4762, ptr %MEMORY, align 8
  %4763 = load i64, ptr %NEXT_PC, align 8
  store i64 %4763, ptr %PC, align 8
  %4764 = add i64 %4763, 6
  store i64 %4764, ptr %NEXT_PC, align 8
  %4765 = load i64, ptr %NEXT_PC, align 8
  %4766 = add i64 %4765, 160
  %4767 = load i64, ptr %NEXT_PC, align 8
  %4768 = load ptr, ptr %MEMORY, align 8
  %4769 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4768, ptr %state, ptr %BRANCH_TAKEN, i64 %4766, i64 %4767, ptr %NEXT_PC)
  store ptr %4769, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879558, label %bb_5389879398

bb_5389879398:                                    ; preds = %bb_5389879389
  %4770 = load i64, ptr %NEXT_PC, align 8
  store i64 %4770, ptr %PC, align 8
  %4771 = add i64 %4770, 2
  store i64 %4771, ptr %NEXT_PC, align 8
  %4772 = load i64, ptr %RBX, align 8
  %4773 = load i32, ptr %EBX, align 4
  %4774 = zext i32 %4773 to i64
  %4775 = load ptr, ptr %MEMORY, align 8
  %4776 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4775, ptr %state, ptr %RBX, i64 %4772, i64 %4774)
  store ptr %4776, ptr %MEMORY, align 8
  br label %bb_5389879400

bb_5389879400:                                    ; preds = %bb_5389879590, %bb_5389879581, %bb_5389879398
  %4777 = load i64, ptr %NEXT_PC, align 8
  store i64 %4777, ptr %PC, align 8
  %4778 = add i64 %4777, 2
  store i64 %4778, ptr %NEXT_PC, align 8
  %4779 = load i64, ptr %RCX, align 8
  %4780 = load i32, ptr %ECX, align 4
  %4781 = zext i32 %4780 to i64
  %4782 = load ptr, ptr %MEMORY, align 8
  %4783 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4782, ptr %state, ptr %RCX, i64 %4779, i64 %4781)
  store ptr %4783, ptr %MEMORY, align 8
  %4784 = load i64, ptr %NEXT_PC, align 8
  store i64 %4784, ptr %PC, align 8
  %4785 = add i64 %4784, 4
  store i64 %4785, ptr %NEXT_PC, align 8
  %4786 = load i64, ptr %RBP, align 8
  %4787 = sub i64 %4786, 9
  %4788 = load i64, ptr %RCX, align 8
  %4789 = load ptr, ptr %MEMORY, align 8
  %4790 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4789, ptr %state, i64 %4787, i64 %4788)
  store ptr %4790, ptr %MEMORY, align 8
  br label %bb_5389879406

bb_5389879406:                                    ; preds = %bb_5389879631, %bb_5389879600, %bb_5389879400
  %4791 = load i64, ptr %NEXT_PC, align 8
  store i64 %4791, ptr %PC, align 8
  %4792 = add i64 %4791, 2
  store i64 %4792, ptr %NEXT_PC, align 8
  %4793 = load i64, ptr %RDI, align 8
  %4794 = load i32, ptr %EDI, align 4
  %4795 = zext i32 %4794 to i64
  %4796 = load ptr, ptr %MEMORY, align 8
  %4797 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %4796, ptr %state, ptr %RDI, i64 %4793, i64 %4795)
  store ptr %4797, ptr %MEMORY, align 8
  %4798 = load i64, ptr %NEXT_PC, align 8
  store i64 %4798, ptr %PC, align 8
  %4799 = add i64 %4798, 8
  store i64 %4799, ptr %NEXT_PC, align 8
  %4800 = load i64, ptr %RBP, align 8
  %4801 = add i64 %4800, 127
  %4802 = load ptr, ptr %MEMORY, align 8
  %4803 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %4802, ptr %state, i64 %4801, i64 0)
  store ptr %4803, ptr %MEMORY, align 8
  %4804 = load i64, ptr %NEXT_PC, align 8
  store i64 %4804, ptr %PC, align 8
  %4805 = add i64 %4804, 7
  store i64 %4805, ptr %NEXT_PC, align 8
  %4806 = load i64, ptr %RCX, align 8
  %4807 = load i64, ptr %NEXT_PC, align 8
  %4808 = add i64 %4807, 27072049
  %4809 = load ptr, ptr %MEMORY, align 8
  %4810 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4809, ptr %state, i64 %4806, i64 %4808)
  store ptr %4810, ptr %MEMORY, align 8
  %4811 = load i64, ptr %NEXT_PC, align 8
  store i64 %4811, ptr %PC, align 8
  %4812 = add i64 %4811, 2
  store i64 %4812, ptr %NEXT_PC, align 8
  %4813 = load i64, ptr %NEXT_PC, align 8
  %4814 = add i64 %4813, 59
  %4815 = load i64, ptr %NEXT_PC, align 8
  %4816 = load ptr, ptr %MEMORY, align 8
  %4817 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4816, ptr %state, ptr %BRANCH_TAKEN, i64 %4814, i64 %4815, ptr %NEXT_PC)
  store ptr %4817, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879484, label %bb_5389879425

bb_5389879425:                                    ; preds = %bb_5389879406
  %4818 = load i64, ptr %NEXT_PC, align 8
  store i64 %4818, ptr %PC, align 8
  %4819 = add i64 %4818, 3
  store i64 %4819, ptr %NEXT_PC, align 8
  %4820 = load i64, ptr %RCX, align 8
  %4821 = load i64, ptr %RCX, align 8
  %4822 = load ptr, ptr %MEMORY, align 8
  %4823 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4822, ptr %state, i64 %4820, i64 %4821)
  store ptr %4823, ptr %MEMORY, align 8
  %4824 = load i64, ptr %NEXT_PC, align 8
  store i64 %4824, ptr %PC, align 8
  %4825 = add i64 %4824, 2
  store i64 %4825, ptr %NEXT_PC, align 8
  %4826 = load i64, ptr %NEXT_PC, align 8
  %4827 = add i64 %4826, 54
  %4828 = load i64, ptr %NEXT_PC, align 8
  %4829 = load ptr, ptr %MEMORY, align 8
  %4830 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4829, ptr %state, ptr %BRANCH_TAKEN, i64 %4827, i64 %4828, ptr %NEXT_PC)
  store ptr %4830, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879484, label %bb_5389879430

bb_5389879430:                                    ; preds = %bb_5389879425
  %4831 = load i64, ptr %NEXT_PC, align 8
  store i64 %4831, ptr %PC, align 8
  %4832 = add i64 %4831, 3
  store i64 %4832, ptr %NEXT_PC, align 8
  %4833 = load i64, ptr %RCX, align 8
  %4834 = load ptr, ptr %MEMORY, align 8
  %4835 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4834, ptr %state, ptr %RAX, i64 %4833)
  store ptr %4835, ptr %MEMORY, align 8
  %4836 = load i64, ptr %NEXT_PC, align 8
  store i64 %4836, ptr %PC, align 8
  %4837 = add i64 %4836, 4
  store i64 %4837, ptr %NEXT_PC, align 8
  %4838 = load i64, ptr %RBP, align 8
  %4839 = sub i64 %4838, 41
  %4840 = load ptr, ptr %MEMORY, align 8
  %4841 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4840, ptr %state, ptr %RDX, i64 %4839)
  store ptr %4841, ptr %MEMORY, align 8
  %4842 = load i64, ptr %NEXT_PC, align 8
  store i64 %4842, ptr %PC, align 8
  %4843 = add i64 %4842, 3
  store i64 %4843, ptr %NEXT_PC, align 8
  %4844 = load i64, ptr %RAX, align 8
  %4845 = add i64 %4844, 56
  %4846 = load i64, ptr %NEXT_PC, align 8
  %4847 = load ptr, ptr %MEMORY, align 8
  %4848 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %4847, ptr %state, i64 %4845, ptr %NEXT_PC, i64 %4846, ptr %RETURN_PC)
  store ptr %4848, ptr %MEMORY, align 8
  %4849 = load i64, ptr %NEXT_PC, align 8
  store i64 %4849, ptr %PC, align 8
  %4850 = add i64 %4849, 3
  store i64 %4850, ptr %NEXT_PC, align 8
  %4851 = load i64, ptr %RAX, align 8
  %4852 = load ptr, ptr %MEMORY, align 8
  %4853 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4852, ptr %state, ptr %RDI, i64 %4851)
  store ptr %4853, ptr %MEMORY, align 8
  %4854 = load i64, ptr %NEXT_PC, align 8
  store i64 %4854, ptr %PC, align 8
  %4855 = add i64 %4854, 3
  store i64 %4855, ptr %NEXT_PC, align 8
  %4856 = load i64, ptr %RAX, align 8
  %4857 = load ptr, ptr %MEMORY, align 8
  %4858 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4857, ptr %state, ptr %RCX, i64 %4856)
  store ptr %4858, ptr %MEMORY, align 8
  %4859 = load i64, ptr %NEXT_PC, align 8
  store i64 %4859, ptr %PC, align 8
  %4860 = add i64 %4859, 3
  store i64 %4860, ptr %NEXT_PC, align 8
  %4861 = load i64, ptr %RCX, align 8
  %4862 = load i64, ptr %RCX, align 8
  %4863 = load ptr, ptr %MEMORY, align 8
  %4864 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4863, ptr %state, i64 %4861, i64 %4862)
  store ptr %4864, ptr %MEMORY, align 8
  %4865 = load i64, ptr %NEXT_PC, align 8
  store i64 %4865, ptr %PC, align 8
  %4866 = add i64 %4865, 2
  store i64 %4866, ptr %NEXT_PC, align 8
  %4867 = load i64, ptr %NEXT_PC, align 8
  %4868 = add i64 %4867, 8
  %4869 = load i64, ptr %NEXT_PC, align 8
  %4870 = load ptr, ptr %MEMORY, align 8
  %4871 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4870, ptr %state, ptr %BRANCH_TAKEN, i64 %4868, i64 %4869, ptr %NEXT_PC)
  store ptr %4871, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879459, label %bb_5389879451

bb_5389879451:                                    ; preds = %bb_5389879430
  %4872 = load i64, ptr %NEXT_PC, align 8
  store i64 %4872, ptr %PC, align 8
  %4873 = add i64 %4872, 2
  store i64 %4873, ptr %NEXT_PC, align 8
  %4874 = load i64, ptr %RCX, align 8
  %4875 = load i64, ptr %RCX, align 8
  %4876 = load ptr, ptr %MEMORY, align 8
  %4877 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4876, ptr %state, i64 %4874, i64 %4875)
  store ptr %4877, ptr %MEMORY, align 8
  %4878 = load i64, ptr %NEXT_PC, align 8
  store i64 %4878, ptr %PC, align 8
  %4879 = add i64 %4878, 4
  store i64 %4879, ptr %NEXT_PC, align 8
  %4880 = load i64, ptr %RCX, align 8
  %4881 = add i64 %4880, 48
  %4882 = load ptr, ptr %MEMORY, align 8
  %4883 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4882, ptr %state, ptr %RCX, i64 %4881)
  store ptr %4883, ptr %MEMORY, align 8
  %4884 = load i64, ptr %NEXT_PC, align 8
  store i64 %4884, ptr %PC, align 8
  %4885 = add i64 %4884, 2
  store i64 %4885, ptr %NEXT_PC, align 8
  %4886 = load i64, ptr %RCX, align 8
  %4887 = load i64, ptr %RCX, align 8
  %4888 = load ptr, ptr %MEMORY, align 8
  %4889 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %4888, ptr %state, i64 %4886, i64 %4887)
  store ptr %4889, ptr %MEMORY, align 8
  br label %bb_5389879459

bb_5389879459:                                    ; preds = %bb_5389879451, %bb_5389879430
  %4890 = load i64, ptr %NEXT_PC, align 8
  store i64 %4890, ptr %PC, align 8
  %4891 = add i64 %4890, 4
  store i64 %4891, ptr %NEXT_PC, align 8
  %4892 = load i64, ptr %RBP, align 8
  %4893 = add i64 %4892, 127
  %4894 = load ptr, ptr %MEMORY, align 8
  %4895 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4894, ptr %state, ptr %RCX, i64 %4893)
  store ptr %4895, ptr %MEMORY, align 8
  %4896 = load i64, ptr %NEXT_PC, align 8
  store i64 %4896, ptr %PC, align 8
  %4897 = add i64 %4896, 3
  store i64 %4897, ptr %NEXT_PC, align 8
  %4898 = load i64, ptr %RCX, align 8
  %4899 = load i64, ptr %RCX, align 8
  %4900 = load ptr, ptr %MEMORY, align 8
  %4901 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4900, ptr %state, i64 %4898, i64 %4899)
  store ptr %4901, ptr %MEMORY, align 8
  %4902 = load i64, ptr %NEXT_PC, align 8
  store i64 %4902, ptr %PC, align 8
  %4903 = add i64 %4902, 2
  store i64 %4903, ptr %NEXT_PC, align 8
  %4904 = load i64, ptr %NEXT_PC, align 8
  %4905 = add i64 %4904, 5
  %4906 = load i64, ptr %NEXT_PC, align 8
  %4907 = load ptr, ptr %MEMORY, align 8
  %4908 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4907, ptr %state, ptr %BRANCH_TAKEN, i64 %4905, i64 %4906, ptr %NEXT_PC)
  store ptr %4908, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879473, label %bb_5389879468

bb_5389879468:                                    ; preds = %bb_5389879459
  %4909 = load i64, ptr %NEXT_PC, align 8
  store i64 %4909, ptr %PC, align 8
  %4910 = add i64 %4909, 5
  store i64 %4910, ptr %NEXT_PC, align 8
  %4911 = load i64, ptr %NEXT_PC, align 8
  %4912 = sub i64 %4911, 2769
  %4913 = load i64, ptr %NEXT_PC, align 8
  %4914 = load ptr, ptr %MEMORY, align 8
  %4915 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %4914, ptr %state, i64 %4912, ptr %NEXT_PC, i64 %4913, ptr %RETURN_PC)
  store ptr %4915, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879473:                                    ; preds = %bb_5389879459
  %4916 = load i64, ptr %NEXT_PC, align 8
  store i64 %4916, ptr %PC, align 8
  %4917 = add i64 %4916, 3
  store i64 %4917, ptr %NEXT_PC, align 8
  %4918 = load i64, ptr %RDI, align 8
  %4919 = load ptr, ptr %MEMORY, align 8
  %4920 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4919, ptr %state, ptr %RDI, i64 %4918)
  store ptr %4920, ptr %MEMORY, align 8
  %4921 = load i64, ptr %NEXT_PC, align 8
  store i64 %4921, ptr %PC, align 8
  %4922 = add i64 %4921, 4
  store i64 %4922, ptr %NEXT_PC, align 8
  %4923 = load i64, ptr %RBP, align 8
  %4924 = sub i64 %4923, 9
  %4925 = load ptr, ptr %MEMORY, align 8
  %4926 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4925, ptr %state, ptr %RCX, i64 %4924)
  store ptr %4926, ptr %MEMORY, align 8
  %4927 = load i64, ptr %NEXT_PC, align 8
  store i64 %4927, ptr %PC, align 8
  %4928 = add i64 %4927, 4
  store i64 %4928, ptr %NEXT_PC, align 8
  %4929 = load i64, ptr %RBP, align 8
  %4930 = add i64 %4929, 127
  %4931 = load i64, ptr %RDI, align 8
  %4932 = load ptr, ptr %MEMORY, align 8
  %4933 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4932, ptr %state, i64 %4930, i64 %4931)
  store ptr %4933, ptr %MEMORY, align 8
  br label %bb_5389879484

bb_5389879484:                                    ; preds = %bb_5389879473, %bb_5389879425, %bb_5389879406
  %4934 = load i64, ptr %NEXT_PC, align 8
  store i64 %4934, ptr %PC, align 8
  %4935 = add i64 %4934, 3
  store i64 %4935, ptr %NEXT_PC, align 8
  %4936 = load i64, ptr %RDI, align 8
  %4937 = load i64, ptr %RDI, align 8
  %4938 = load ptr, ptr %MEMORY, align 8
  %4939 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4938, ptr %state, i64 %4936, i64 %4937)
  store ptr %4939, ptr %MEMORY, align 8
  %4940 = load i64, ptr %NEXT_PC, align 8
  store i64 %4940, ptr %PC, align 8
  %4941 = add i64 %4940, 6
  store i64 %4941, ptr %NEXT_PC, align 8
  %4942 = load i64, ptr %NEXT_PC, align 8
  %4943 = add i64 %4942, 164
  %4944 = load i64, ptr %NEXT_PC, align 8
  %4945 = load ptr, ptr %MEMORY, align 8
  %4946 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4945, ptr %state, ptr %BRANCH_TAKEN, i64 %4943, i64 %4944, ptr %NEXT_PC)
  store ptr %4946, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879657, label %bb_5389879493

bb_5389879493:                                    ; preds = %bb_5389879484
  %4947 = load i64, ptr %NEXT_PC, align 8
  store i64 %4947, ptr %PC, align 8
  %4948 = add i64 %4947, 4
  store i64 %4948, ptr %NEXT_PC, align 8
  %4949 = load i64, ptr %RBP, align 8
  %4950 = add i64 %4949, 31
  %4951 = load i64, ptr %RDI, align 8
  %4952 = load ptr, ptr %MEMORY, align 8
  %4953 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4952, ptr %state, i64 %4950, i64 %4951)
  store ptr %4953, ptr %MEMORY, align 8
  %4954 = load i64, ptr %NEXT_PC, align 8
  store i64 %4954, ptr %PC, align 8
  %4955 = add i64 %4954, 3
  store i64 %4955, ptr %NEXT_PC, align 8
  %4956 = load i64, ptr %RCX, align 8
  %4957 = load i64, ptr %RCX, align 8
  %4958 = load ptr, ptr %MEMORY, align 8
  %4959 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %4958, ptr %state, i64 %4956, i64 %4957)
  store ptr %4959, ptr %MEMORY, align 8
  %4960 = load i64, ptr %NEXT_PC, align 8
  store i64 %4960, ptr %PC, align 8
  %4961 = add i64 %4960, 2
  store i64 %4961, ptr %NEXT_PC, align 8
  %4962 = load i64, ptr %NEXT_PC, align 8
  %4963 = add i64 %4962, 18
  %4964 = load i64, ptr %NEXT_PC, align 8
  %4965 = load ptr, ptr %MEMORY, align 8
  %4966 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %4965, ptr %state, ptr %BRANCH_TAKEN, i64 %4963, i64 %4964, ptr %NEXT_PC)
  store ptr %4966, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879520, label %bb_5389879502

bb_5389879502:                                    ; preds = %bb_5389879493
  %4967 = load i64, ptr %NEXT_PC, align 8
  store i64 %4967, ptr %PC, align 8
  %4968 = add i64 %4967, 4
  store i64 %4968, ptr %NEXT_PC, align 8
  %4969 = load i64, ptr %RBP, align 8
  %4970 = add i64 %4969, 31
  %4971 = load i64, ptr %RCX, align 8
  %4972 = load ptr, ptr %MEMORY, align 8
  %4973 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %4972, ptr %state, i64 %4970, i64 %4971)
  store ptr %4973, ptr %MEMORY, align 8
  %4974 = load i64, ptr %NEXT_PC, align 8
  store i64 %4974, ptr %PC, align 8
  %4975 = add i64 %4974, 4
  store i64 %4975, ptr %NEXT_PC, align 8
  %4976 = load i64, ptr %RBP, align 8
  %4977 = sub i64 %4976, 41
  %4978 = load ptr, ptr %MEMORY, align 8
  %4979 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4978, ptr %state, ptr %R8, i64 %4977)
  store ptr %4979, ptr %MEMORY, align 8
  %4980 = load i64, ptr %NEXT_PC, align 8
  store i64 %4980, ptr %PC, align 8
  %4981 = add i64 %4980, 3
  store i64 %4981, ptr %NEXT_PC, align 8
  %4982 = load i64, ptr %RCX, align 8
  %4983 = load ptr, ptr %MEMORY, align 8
  %4984 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %4983, ptr %state, ptr %RAX, i64 %4982)
  store ptr %4984, ptr %MEMORY, align 8
  %4985 = load i64, ptr %NEXT_PC, align 8
  store i64 %4985, ptr %PC, align 8
  %4986 = add i64 %4985, 4
  store i64 %4986, ptr %NEXT_PC, align 8
  %4987 = load i64, ptr %RBP, align 8
  %4988 = sub i64 %4987, 1
  %4989 = load ptr, ptr %MEMORY, align 8
  %4990 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %4989, ptr %state, ptr %RDX, i64 %4988)
  store ptr %4990, ptr %MEMORY, align 8
  %4991 = load i64, ptr %NEXT_PC, align 8
  store i64 %4991, ptr %PC, align 8
  %4992 = add i64 %4991, 3
  store i64 %4992, ptr %NEXT_PC, align 8
  %4993 = load i64, ptr %RAX, align 8
  %4994 = add i64 %4993, 8
  %4995 = load i64, ptr %NEXT_PC, align 8
  %4996 = load ptr, ptr %MEMORY, align 8
  %4997 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %4996, ptr %state, i64 %4994, ptr %NEXT_PC, i64 %4995, ptr %RETURN_PC)
  store ptr %4997, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879520:                                    ; preds = %bb_5389879493
  %4998 = load i64, ptr %NEXT_PC, align 8
  store i64 %4998, ptr %PC, align 8
  %4999 = add i64 %4998, 8
  store i64 %4999, ptr %NEXT_PC, align 8
  %5000 = load i64, ptr %RSP, align 8
  %5001 = add i64 %5000, 40
  %5002 = load ptr, ptr %MEMORY, align 8
  %5003 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %5002, ptr %state, i64 %5001, i64 -1)
  store ptr %5003, ptr %MEMORY, align 8
  %5004 = load i64, ptr %NEXT_PC, align 8
  store i64 %5004, ptr %PC, align 8
  %5005 = add i64 %5004, 4
  store i64 %5005, ptr %NEXT_PC, align 8
  %5006 = load i64, ptr %RBP, align 8
  %5007 = sub i64 %5006, 1
  %5008 = load ptr, ptr %MEMORY, align 8
  %5009 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5008, ptr %state, ptr %R8, i64 %5007)
  store ptr %5009, ptr %MEMORY, align 8
  %5010 = load i64, ptr %NEXT_PC, align 8
  store i64 %5010, ptr %PC, align 8
  %5011 = add i64 %5010, 3
  store i64 %5011, ptr %NEXT_PC, align 8
  %5012 = load i32, ptr %R13D, align 4
  %5013 = zext i32 %5012 to i64
  %5014 = load ptr, ptr %MEMORY, align 8
  %5015 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5014, ptr %state, ptr %R9, i64 %5013)
  store ptr %5015, ptr %MEMORY, align 8
  %5016 = load i64, ptr %NEXT_PC, align 8
  store i64 %5016, ptr %PC, align 8
  %5017 = add i64 %5016, 8
  store i64 %5017, ptr %NEXT_PC, align 8
  %5018 = load i64, ptr %RSP, align 8
  %5019 = add i64 %5018, 32
  %5020 = load ptr, ptr %MEMORY, align 8
  %5021 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %5020, ptr %state, i64 %5019, i64 -1)
  store ptr %5021, ptr %MEMORY, align 8
  %5022 = load i64, ptr %NEXT_PC, align 8
  store i64 %5022, ptr %PC, align 8
  %5023 = add i64 %5022, 2
  store i64 %5023, ptr %NEXT_PC, align 8
  %5024 = load i32, ptr %EBX, align 4
  %5025 = zext i32 %5024 to i64
  %5026 = load ptr, ptr %MEMORY, align 8
  %5027 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5026, ptr %state, ptr %RDX, i64 %5025)
  store ptr %5027, ptr %MEMORY, align 8
  %5028 = load i64, ptr %NEXT_PC, align 8
  store i64 %5028, ptr %PC, align 8
  %5029 = add i64 %5028, 3
  store i64 %5029, ptr %NEXT_PC, align 8
  %5030 = load i64, ptr %R14, align 8
  %5031 = load ptr, ptr %MEMORY, align 8
  %5032 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5031, ptr %state, ptr %RCX, i64 %5030)
  store ptr %5032, ptr %MEMORY, align 8
  %5033 = load i64, ptr %NEXT_PC, align 8
  store i64 %5033, ptr %PC, align 8
  %5034 = add i64 %5033, 5
  store i64 %5034, ptr %NEXT_PC, align 8
  %5035 = load i64, ptr %NEXT_PC, align 8
  %5036 = add i64 %5035, 2383
  %5037 = load i64, ptr %NEXT_PC, align 8
  %5038 = load ptr, ptr %MEMORY, align 8
  %5039 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %5038, ptr %state, i64 %5036, ptr %NEXT_PC, i64 %5037, ptr %RETURN_PC)
  store ptr %5039, ptr %MEMORY, align 8
  %5040 = load i64, ptr %NEXT_PC, align 8
  store i64 %5040, ptr %PC, align 8
  %5041 = add i64 %5040, 5
  store i64 %5041, ptr %NEXT_PC, align 8
  %5042 = load i64, ptr %NEXT_PC, align 8
  %5043 = add i64 %5042, 464
  %5044 = load ptr, ptr %MEMORY, align 8
  %5045 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %5044, ptr %state, i64 %5043, ptr %NEXT_PC)
  store ptr %5045, ptr %MEMORY, align 8
  br label %bb_5389880022

bb_5389879558:                                    ; preds = %bb_5389879389
  %5046 = load i64, ptr %NEXT_PC, align 8
  store i64 %5046, ptr %PC, align 8
  %5047 = add i64 %5046, 3
  store i64 %5047, ptr %NEXT_PC, align 8
  %5048 = load i64, ptr %R15, align 8
  %5049 = load i64, ptr %R15, align 8
  %5050 = load ptr, ptr %MEMORY, align 8
  %5051 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5050, ptr %state, i64 %5048, i64 %5049)
  store ptr %5051, ptr %MEMORY, align 8
  %5052 = load i64, ptr %NEXT_PC, align 8
  store i64 %5052, ptr %PC, align 8
  %5053 = add i64 %5052, 2
  store i64 %5053, ptr %NEXT_PC, align 8
  %5054 = load i64, ptr %NEXT_PC, align 8
  %5055 = add i64 %5054, 16
  %5056 = load i64, ptr %NEXT_PC, align 8
  %5057 = load ptr, ptr %MEMORY, align 8
  %5058 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5057, ptr %state, ptr %BRANCH_TAKEN, i64 %5055, i64 %5056, ptr %NEXT_PC)
  store ptr %5058, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879579, label %bb_5389879563

bb_5389879563:                                    ; preds = %bb_5389879558
  %5059 = load i64, ptr %NEXT_PC, align 8
  store i64 %5059, ptr %PC, align 8
  %5060 = add i64 %5059, 4
  store i64 %5060, ptr %NEXT_PC, align 8
  %5061 = load i32, ptr %ESI, align 4
  %5062 = zext i32 %5061 to i64
  %5063 = load i64, ptr %R8, align 8
  %5064 = add i64 %5063, 40
  %5065 = load ptr, ptr %MEMORY, align 8
  %5066 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %5065, ptr %state, i64 %5062, i64 %5064)
  store ptr %5066, ptr %MEMORY, align 8
  %5067 = load i64, ptr %NEXT_PC, align 8
  store i64 %5067, ptr %PC, align 8
  %5068 = add i64 %5067, 2
  store i64 %5068, ptr %NEXT_PC, align 8
  %5069 = load i64, ptr %NEXT_PC, align 8
  %5070 = add i64 %5069, 10
  %5071 = load i64, ptr %NEXT_PC, align 8
  %5072 = load ptr, ptr %MEMORY, align 8
  %5073 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5072, ptr %state, ptr %BRANCH_TAKEN, i64 %5070, i64 %5071, ptr %NEXT_PC)
  store ptr %5073, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879579, label %bb_5389879569

bb_5389879569:                                    ; preds = %bb_5389879563
  %5074 = load i64, ptr %NEXT_PC, align 8
  store i64 %5074, ptr %PC, align 8
  %5075 = add i64 %5074, 4
  store i64 %5075, ptr %NEXT_PC, align 8
  %5076 = load i64, ptr %R8, align 8
  %5077 = add i64 %5076, 32
  %5078 = load ptr, ptr %MEMORY, align 8
  %5079 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5078, ptr %state, ptr %RAX, i64 %5077)
  store ptr %5079, ptr %MEMORY, align 8
  %5080 = load i64, ptr %NEXT_PC, align 8
  store i64 %5080, ptr %PC, align 8
  %5081 = add i64 %5080, 4
  store i64 %5081, ptr %NEXT_PC, align 8
  %5082 = load i64, ptr %R12, align 8
  %5083 = load i64, ptr %RAX, align 8
  %5084 = mul i64 %5083, 1
  %5085 = add i64 %5082, %5084
  %5086 = load ptr, ptr %MEMORY, align 8
  %5087 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %5086, ptr %state, ptr %RBX, i64 %5085)
  store ptr %5087, ptr %MEMORY, align 8
  %5088 = load i64, ptr %NEXT_PC, align 8
  store i64 %5088, ptr %PC, align 8
  %5089 = add i64 %5088, 2
  store i64 %5089, ptr %NEXT_PC, align 8
  %5090 = load i64, ptr %NEXT_PC, align 8
  %5091 = add i64 %5090, 2
  %5092 = load ptr, ptr %MEMORY, align 8
  %5093 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %5092, ptr %state, i64 %5091, ptr %NEXT_PC)
  store ptr %5093, ptr %MEMORY, align 8
  br label %bb_5389879581

bb_5389879579:                                    ; preds = %bb_5389879563, %bb_5389879558
  %5094 = load i64, ptr %NEXT_PC, align 8
  store i64 %5094, ptr %PC, align 8
  %5095 = add i64 %5094, 2
  store i64 %5095, ptr %NEXT_PC, align 8
  %5096 = load i64, ptr %RBX, align 8
  %5097 = load i32, ptr %EBX, align 4
  %5098 = zext i32 %5097 to i64
  %5099 = load ptr, ptr %MEMORY, align 8
  %5100 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %5099, ptr %state, ptr %RBX, i64 %5096, i64 %5098)
  store ptr %5100, ptr %MEMORY, align 8
  br label %bb_5389879581

bb_5389879581:                                    ; preds = %bb_5389879579, %bb_5389879569
  %5101 = load i64, ptr %NEXT_PC, align 8
  store i64 %5101, ptr %PC, align 8
  %5102 = add i64 %5101, 3
  store i64 %5102, ptr %NEXT_PC, align 8
  %5103 = load i64, ptr %R15, align 8
  %5104 = load i64, ptr %R15, align 8
  %5105 = load ptr, ptr %MEMORY, align 8
  %5106 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5105, ptr %state, i64 %5103, i64 %5104)
  store ptr %5106, ptr %MEMORY, align 8
  %5107 = load i64, ptr %NEXT_PC, align 8
  store i64 %5107, ptr %PC, align 8
  %5108 = add i64 %5107, 6
  store i64 %5108, ptr %NEXT_PC, align 8
  %5109 = load i64, ptr %NEXT_PC, align 8
  %5110 = sub i64 %5109, 190
  %5111 = load i64, ptr %NEXT_PC, align 8
  %5112 = load ptr, ptr %MEMORY, align 8
  %5113 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5112, ptr %state, ptr %BRANCH_TAKEN, i64 %5110, i64 %5111, ptr %NEXT_PC)
  store ptr %5113, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879400, label %bb_5389879590

bb_5389879590:                                    ; preds = %bb_5389879581
  %5114 = load i64, ptr %NEXT_PC, align 8
  store i64 %5114, ptr %PC, align 8
  %5115 = add i64 %5114, 4
  store i64 %5115, ptr %NEXT_PC, align 8
  %5116 = load i32, ptr %ESI, align 4
  %5117 = zext i32 %5116 to i64
  %5118 = load i64, ptr %R8, align 8
  %5119 = add i64 %5118, 40
  %5120 = load ptr, ptr %MEMORY, align 8
  %5121 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %5120, ptr %state, i64 %5117, i64 %5119)
  store ptr %5121, ptr %MEMORY, align 8
  %5122 = load i64, ptr %NEXT_PC, align 8
  store i64 %5122, ptr %PC, align 8
  %5123 = add i64 %5122, 6
  store i64 %5123, ptr %NEXT_PC, align 8
  %5124 = load i64, ptr %NEXT_PC, align 8
  %5125 = sub i64 %5124, 200
  %5126 = load i64, ptr %NEXT_PC, align 8
  %5127 = load ptr, ptr %MEMORY, align 8
  %5128 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5127, ptr %state, ptr %BRANCH_TAKEN, i64 %5125, i64 %5126, ptr %NEXT_PC)
  store ptr %5128, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879400, label %bb_5389879600

bb_5389879600:                                    ; preds = %bb_5389879590
  %5129 = load i64, ptr %NEXT_PC, align 8
  store i64 %5129, ptr %PC, align 8
  %5130 = add i64 %5129, 4
  store i64 %5130, ptr %NEXT_PC, align 8
  %5131 = load i64, ptr %R8, align 8
  %5132 = add i64 %5131, 32
  %5133 = load ptr, ptr %MEMORY, align 8
  %5134 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5133, ptr %state, ptr %RAX, i64 %5132)
  store ptr %5134, ptr %MEMORY, align 8
  %5135 = load i64, ptr %NEXT_PC, align 8
  store i64 %5135, ptr %PC, align 8
  %5136 = add i64 %5135, 2
  store i64 %5136, ptr %NEXT_PC, align 8
  %5137 = load i64, ptr %RCX, align 8
  %5138 = load i32, ptr %ECX, align 4
  %5139 = zext i32 %5138 to i64
  %5140 = load ptr, ptr %MEMORY, align 8
  %5141 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %5140, ptr %state, ptr %RCX, i64 %5137, i64 %5139)
  store ptr %5141, ptr %MEMORY, align 8
  %5142 = load i64, ptr %NEXT_PC, align 8
  store i64 %5142, ptr %PC, align 8
  %5143 = add i64 %5142, 5
  store i64 %5143, ptr %NEXT_PC, align 8
  %5144 = load i64, ptr %R12, align 8
  %5145 = add i64 %5144, 8
  %5146 = load ptr, ptr %MEMORY, align 8
  %5147 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5146, ptr %state, ptr %R8, i64 %5145)
  store ptr %5147, ptr %MEMORY, align 8
  %5148 = load i64, ptr %NEXT_PC, align 8
  store i64 %5148, ptr %PC, align 8
  %5149 = add i64 %5148, 4
  store i64 %5149, ptr %NEXT_PC, align 8
  %5150 = load i64, ptr %RBP, align 8
  %5151 = sub i64 %5150, 9
  %5152 = load i64, ptr %RCX, align 8
  %5153 = load ptr, ptr %MEMORY, align 8
  %5154 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5153, ptr %state, i64 %5151, i64 %5152)
  store ptr %5154, ptr %MEMORY, align 8
  %5155 = load i64, ptr %NEXT_PC, align 8
  store i64 %5155, ptr %PC, align 8
  %5156 = add i64 %5155, 3
  store i64 %5156, ptr %NEXT_PC, align 8
  %5157 = load i64, ptr %R8, align 8
  %5158 = load i64, ptr %RAX, align 8
  %5159 = load ptr, ptr %MEMORY, align 8
  %5160 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %5159, ptr %state, ptr %R8, i64 %5157, i64 %5158)
  store ptr %5160, ptr %MEMORY, align 8
  %5161 = load i64, ptr %NEXT_PC, align 8
  store i64 %5161, ptr %PC, align 8
  %5162 = add i64 %5161, 4
  store i64 %5162, ptr %NEXT_PC, align 8
  %5163 = load i64, ptr %R8, align 8
  %5164 = add i64 %5163, 32
  %5165 = load ptr, ptr %MEMORY, align 8
  %5166 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5165, ptr %state, ptr %R9, i64 %5164)
  store ptr %5166, ptr %MEMORY, align 8
  %5167 = load i64, ptr %NEXT_PC, align 8
  store i64 %5167, ptr %PC, align 8
  %5168 = add i64 %5167, 3
  store i64 %5168, ptr %NEXT_PC, align 8
  %5169 = load i64, ptr %R9, align 8
  %5170 = load i64, ptr %R9, align 8
  %5171 = load ptr, ptr %MEMORY, align 8
  %5172 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5171, ptr %state, i64 %5169, i64 %5170)
  store ptr %5172, ptr %MEMORY, align 8
  %5173 = load i64, ptr %NEXT_PC, align 8
  store i64 %5173, ptr %PC, align 8
  %5174 = add i64 %5173, 6
  store i64 %5174, ptr %NEXT_PC, align 8
  %5175 = load i64, ptr %NEXT_PC, align 8
  %5176 = sub i64 %5175, 225
  %5177 = load i64, ptr %NEXT_PC, align 8
  %5178 = load ptr, ptr %MEMORY, align 8
  %5179 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5178, ptr %state, ptr %BRANCH_TAKEN, i64 %5176, i64 %5177, ptr %NEXT_PC)
  store ptr %5179, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879406, label %bb_5389879631

bb_5389879631:                                    ; preds = %bb_5389879600
  %5180 = load i64, ptr %NEXT_PC, align 8
  store i64 %5180, ptr %PC, align 8
  %5181 = add i64 %5180, 4
  store i64 %5181, ptr %NEXT_PC, align 8
  %5182 = load i64, ptr %RBP, align 8
  %5183 = sub i64 %5182, 9
  %5184 = load i64, ptr %R9, align 8
  %5185 = load ptr, ptr %MEMORY, align 8
  %5186 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5185, ptr %state, i64 %5183, i64 %5184)
  store ptr %5186, ptr %MEMORY, align 8
  %5187 = load i64, ptr %NEXT_PC, align 8
  store i64 %5187, ptr %PC, align 8
  %5188 = add i64 %5187, 4
  store i64 %5188, ptr %NEXT_PC, align 8
  %5189 = load i64, ptr %RBP, align 8
  %5190 = sub i64 %5189, 41
  %5191 = load ptr, ptr %MEMORY, align 8
  %5192 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5191, ptr %state, ptr %RDX, i64 %5190)
  store ptr %5192, ptr %MEMORY, align 8
  %5193 = load i64, ptr %NEXT_PC, align 8
  store i64 %5193, ptr %PC, align 8
  %5194 = add i64 %5193, 3
  store i64 %5194, ptr %NEXT_PC, align 8
  %5195 = load i64, ptr %R9, align 8
  %5196 = load ptr, ptr %MEMORY, align 8
  %5197 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5196, ptr %state, ptr %RAX, i64 %5195)
  store ptr %5197, ptr %MEMORY, align 8
  %5198 = load i64, ptr %NEXT_PC, align 8
  store i64 %5198, ptr %PC, align 8
  %5199 = add i64 %5198, 3
  store i64 %5199, ptr %NEXT_PC, align 8
  %5200 = load i64, ptr %R9, align 8
  %5201 = load ptr, ptr %MEMORY, align 8
  %5202 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5201, ptr %state, ptr %RCX, i64 %5200)
  store ptr %5202, ptr %MEMORY, align 8
  %5203 = load i64, ptr %NEXT_PC, align 8
  store i64 %5203, ptr %PC, align 8
  %5204 = add i64 %5203, 3
  store i64 %5204, ptr %NEXT_PC, align 8
  %5205 = load i64, ptr %RAX, align 8
  %5206 = add i64 %5205, 8
  %5207 = load i64, ptr %NEXT_PC, align 8
  %5208 = load ptr, ptr %MEMORY, align 8
  %5209 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %5208, ptr %state, i64 %5206, ptr %NEXT_PC, i64 %5207, ptr %RETURN_PC)
  store ptr %5209, ptr %MEMORY, align 8
  %5210 = load i64, ptr %NEXT_PC, align 8
  store i64 %5210, ptr %PC, align 8
  %5211 = add i64 %5210, 4
  store i64 %5211, ptr %NEXT_PC, align 8
  %5212 = load i64, ptr %RBP, align 8
  %5213 = sub i64 %5212, 9
  %5214 = load ptr, ptr %MEMORY, align 8
  %5215 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5214, ptr %state, ptr %RCX, i64 %5213)
  store ptr %5215, ptr %MEMORY, align 8
  %5216 = load i64, ptr %NEXT_PC, align 8
  store i64 %5216, ptr %PC, align 8
  %5217 = add i64 %5216, 5
  store i64 %5217, ptr %NEXT_PC, align 8
  %5218 = load i64, ptr %NEXT_PC, align 8
  %5219 = sub i64 %5218, 251
  %5220 = load ptr, ptr %MEMORY, align 8
  %5221 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %5220, ptr %state, i64 %5219, ptr %NEXT_PC)
  store ptr %5221, ptr %MEMORY, align 8
  br label %bb_5389879406

bb_5389879657:                                    ; preds = %bb_5389879484
  %5222 = load i64, ptr %NEXT_PC, align 8
  store i64 %5222, ptr %PC, align 8
  %5223 = add i64 %5222, 2
  store i64 %5223, ptr %NEXT_PC, align 8
  %5224 = load i32, ptr %EBX, align 4
  %5225 = zext i32 %5224 to i64
  %5226 = load i32, ptr %EBX, align 4
  %5227 = zext i32 %5226 to i64
  %5228 = load ptr, ptr %MEMORY, align 8
  %5229 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5228, ptr %state, i64 %5225, i64 %5227)
  store ptr %5229, ptr %MEMORY, align 8
  %5230 = load i64, ptr %NEXT_PC, align 8
  store i64 %5230, ptr %PC, align 8
  %5231 = add i64 %5230, 6
  store i64 %5231, ptr %NEXT_PC, align 8
  %5232 = load i64, ptr %NEXT_PC, align 8
  %5233 = add i64 %5232, 130
  %5234 = load i64, ptr %NEXT_PC, align 8
  %5235 = load ptr, ptr %MEMORY, align 8
  %5236 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5235, ptr %state, ptr %BRANCH_TAKEN, i64 %5233, i64 %5234, ptr %NEXT_PC)
  store ptr %5236, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879795, label %bb_5389879665

bb_5389879665:                                    ; preds = %bb_5389879657
  %5237 = load i64, ptr %NEXT_PC, align 8
  store i64 %5237, ptr %PC, align 8
  %5238 = add i64 %5237, 8
  store i64 %5238, ptr %NEXT_PC, align 8
  %5239 = load i64, ptr %RBP, align 8
  %5240 = sub i64 %5239, 49
  %5241 = load ptr, ptr %MEMORY, align 8
  %5242 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %5241, ptr %state, i64 %5240, i64 0)
  store ptr %5242, ptr %MEMORY, align 8
  br label %bb_5389879673

bb_5389879673:                                    ; preds = %bb_5389879825, %bb_5389879665
  %5243 = load i64, ptr %NEXT_PC, align 8
  store i64 %5243, ptr %PC, align 8
  %5244 = add i64 %5243, 7
  store i64 %5244, ptr %NEXT_PC, align 8
  %5245 = load i64, ptr %NEXT_PC, align 8
  %5246 = add i64 %5245, 26998096
  %5247 = load ptr, ptr %MEMORY, align 8
  %5248 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5247, ptr %state, ptr %RCX, i64 %5246)
  store ptr %5248, ptr %MEMORY, align 8
  %5249 = load i64, ptr %NEXT_PC, align 8
  store i64 %5249, ptr %PC, align 8
  %5250 = add i64 %5249, 6
  store i64 %5250, ptr %NEXT_PC, align 8
  %5251 = load ptr, ptr %MEMORY, align 8
  %5252 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %5251, ptr %state, ptr %R8, i64 8)
  store ptr %5252, ptr %MEMORY, align 8
  %5253 = load i64, ptr %NEXT_PC, align 8
  store i64 %5253, ptr %PC, align 8
  %5254 = add i64 %5253, 4
  store i64 %5254, ptr %NEXT_PC, align 8
  %5255 = load i64, ptr %R8, align 8
  %5256 = add i64 %5255, 56
  %5257 = load ptr, ptr %MEMORY, align 8
  %5258 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %5257, ptr %state, ptr %RDX, i64 %5256)
  store ptr %5258, ptr %MEMORY, align 8
  %5259 = load i64, ptr %NEXT_PC, align 8
  store i64 %5259, ptr %PC, align 8
  %5260 = add i64 %5259, 5
  store i64 %5260, ptr %NEXT_PC, align 8
  %5261 = load i64, ptr %NEXT_PC, align 8
  %5262 = sub i64 %5261, 635215
  %5263 = load i64, ptr %NEXT_PC, align 8
  %5264 = load ptr, ptr %MEMORY, align 8
  %5265 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %5264, ptr %state, i64 %5262, ptr %NEXT_PC, i64 %5263, ptr %RETURN_PC)
  store ptr %5265, ptr %MEMORY, align 8
  %5266 = load i64, ptr %NEXT_PC, align 8
  store i64 %5266, ptr %PC, align 8
  %5267 = add i64 %5266, 3
  store i64 %5267, ptr %NEXT_PC, align 8
  %5268 = load i64, ptr %RDI, align 8
  %5269 = load ptr, ptr %MEMORY, align 8
  %5270 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5269, ptr %state, ptr %RDX, i64 %5268)
  store ptr %5270, ptr %MEMORY, align 8
  %5271 = load i64, ptr %NEXT_PC, align 8
  store i64 %5271, ptr %PC, align 8
  %5272 = add i64 %5271, 3
  store i64 %5272, ptr %NEXT_PC, align 8
  %5273 = load i64, ptr %RAX, align 8
  %5274 = load ptr, ptr %MEMORY, align 8
  %5275 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5274, ptr %state, ptr %RCX, i64 %5273)
  store ptr %5275, ptr %MEMORY, align 8
  %5276 = load i64, ptr %NEXT_PC, align 8
  store i64 %5276, ptr %PC, align 8
  %5277 = add i64 %5276, 5
  store i64 %5277, ptr %NEXT_PC, align 8
  %5278 = load i64, ptr %NEXT_PC, align 8
  %5279 = sub i64 %5278, 3866
  %5280 = load i64, ptr %NEXT_PC, align 8
  %5281 = load ptr, ptr %MEMORY, align 8
  %5282 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %5281, ptr %state, i64 %5279, ptr %NEXT_PC, i64 %5280, ptr %RETURN_PC)
  store ptr %5282, ptr %MEMORY, align 8
  %5283 = load i64, ptr %NEXT_PC, align 8
  store i64 %5283, ptr %PC, align 8
  %5284 = add i64 %5283, 4
  store i64 %5284, ptr %NEXT_PC, align 8
  %5285 = load i64, ptr %RBP, align 8
  %5286 = sub i64 %5285, 49
  %5287 = load i64, ptr %RAX, align 8
  %5288 = load ptr, ptr %MEMORY, align 8
  %5289 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5288, ptr %state, i64 %5286, i64 %5287)
  store ptr %5289, ptr %MEMORY, align 8
  br label %bb_5389879710

bb_5389879710:                                    ; preds = %bb_5389879810, %bb_5389879673
  %5290 = load i64, ptr %NEXT_PC, align 8
  store i64 %5290, ptr %PC, align 8
  %5291 = add i64 %5290, 8
  store i64 %5291, ptr %NEXT_PC, align 8
  %5292 = load i64, ptr %RBP, align 8
  %5293 = add i64 %5292, 31
  %5294 = load ptr, ptr %MEMORY, align 8
  %5295 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %5294, ptr %state, i64 %5293, i64 0)
  store ptr %5295, ptr %MEMORY, align 8
  %5296 = load i64, ptr %NEXT_PC, align 8
  store i64 %5296, ptr %PC, align 8
  %5297 = add i64 %5296, 3
  store i64 %5297, ptr %NEXT_PC, align 8
  %5298 = load i64, ptr %RAX, align 8
  %5299 = load i64, ptr %RAX, align 8
  %5300 = load ptr, ptr %MEMORY, align 8
  %5301 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5300, ptr %state, i64 %5298, i64 %5299)
  store ptr %5301, ptr %MEMORY, align 8
  %5302 = load i64, ptr %NEXT_PC, align 8
  store i64 %5302, ptr %PC, align 8
  %5303 = add i64 %5302, 2
  store i64 %5303, ptr %NEXT_PC, align 8
  %5304 = load i64, ptr %NEXT_PC, align 8
  %5305 = add i64 %5304, 30
  %5306 = load i64, ptr %NEXT_PC, align 8
  %5307 = load ptr, ptr %MEMORY, align 8
  %5308 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5307, ptr %state, ptr %BRANCH_TAKEN, i64 %5305, i64 %5306, ptr %NEXT_PC)
  store ptr %5308, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879753, label %bb_5389879723

bb_5389879723:                                    ; preds = %bb_5389879710
  %5309 = load i64, ptr %NEXT_PC, align 8
  store i64 %5309, ptr %PC, align 8
  %5310 = add i64 %5309, 7
  store i64 %5310, ptr %NEXT_PC, align 8
  %5311 = load i64, ptr %NEXT_PC, align 8
  %5312 = add i64 %5311, 27071742
  %5313 = load ptr, ptr %MEMORY, align 8
  %5314 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5313, ptr %state, ptr %RCX, i64 %5312)
  store ptr %5314, ptr %MEMORY, align 8
  %5315 = load i64, ptr %NEXT_PC, align 8
  store i64 %5315, ptr %PC, align 8
  %5316 = add i64 %5315, 4
  store i64 %5316, ptr %NEXT_PC, align 8
  %5317 = load i64, ptr %RBP, align 8
  %5318 = add i64 %5317, 31
  %5319 = load i64, ptr %RCX, align 8
  %5320 = load ptr, ptr %MEMORY, align 8
  %5321 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5320, ptr %state, i64 %5318, i64 %5319)
  store ptr %5321, ptr %MEMORY, align 8
  %5322 = load i64, ptr %NEXT_PC, align 8
  store i64 %5322, ptr %PC, align 8
  %5323 = add i64 %5322, 3
  store i64 %5323, ptr %NEXT_PC, align 8
  %5324 = load i64, ptr %RCX, align 8
  %5325 = load i64, ptr %RCX, align 8
  %5326 = load ptr, ptr %MEMORY, align 8
  %5327 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5326, ptr %state, i64 %5324, i64 %5325)
  store ptr %5327, ptr %MEMORY, align 8
  %5328 = load i64, ptr %NEXT_PC, align 8
  store i64 %5328, ptr %PC, align 8
  %5329 = add i64 %5328, 2
  store i64 %5329, ptr %NEXT_PC, align 8
  %5330 = load i64, ptr %NEXT_PC, align 8
  %5331 = add i64 %5330, 14
  %5332 = load i64, ptr %NEXT_PC, align 8
  %5333 = load ptr, ptr %MEMORY, align 8
  %5334 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5333, ptr %state, ptr %BRANCH_TAKEN, i64 %5331, i64 %5332, ptr %NEXT_PC)
  store ptr %5334, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879753, label %bb_5389879739

bb_5389879739:                                    ; preds = %bb_5389879723
  %5335 = load i64, ptr %NEXT_PC, align 8
  store i64 %5335, ptr %PC, align 8
  %5336 = add i64 %5335, 3
  store i64 %5336, ptr %NEXT_PC, align 8
  %5337 = load i64, ptr %RCX, align 8
  %5338 = load ptr, ptr %MEMORY, align 8
  %5339 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5338, ptr %state, ptr %RAX, i64 %5337)
  store ptr %5339, ptr %MEMORY, align 8
  %5340 = load i64, ptr %NEXT_PC, align 8
  store i64 %5340, ptr %PC, align 8
  %5341 = add i64 %5340, 4
  store i64 %5341, ptr %NEXT_PC, align 8
  %5342 = load i64, ptr %RBP, align 8
  %5343 = sub i64 %5342, 49
  %5344 = load ptr, ptr %MEMORY, align 8
  %5345 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5344, ptr %state, ptr %R8, i64 %5343)
  store ptr %5345, ptr %MEMORY, align 8
  %5346 = load i64, ptr %NEXT_PC, align 8
  store i64 %5346, ptr %PC, align 8
  %5347 = add i64 %5346, 4
  store i64 %5347, ptr %NEXT_PC, align 8
  %5348 = load i64, ptr %RBP, align 8
  %5349 = sub i64 %5348, 1
  %5350 = load ptr, ptr %MEMORY, align 8
  %5351 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5350, ptr %state, ptr %RDX, i64 %5349)
  store ptr %5351, ptr %MEMORY, align 8
  %5352 = load i64, ptr %NEXT_PC, align 8
  store i64 %5352, ptr %PC, align 8
  %5353 = add i64 %5352, 3
  store i64 %5353, ptr %NEXT_PC, align 8
  %5354 = load i64, ptr %RAX, align 8
  %5355 = add i64 %5354, 16
  %5356 = load i64, ptr %NEXT_PC, align 8
  %5357 = load ptr, ptr %MEMORY, align 8
  %5358 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %5357, ptr %state, i64 %5355, ptr %NEXT_PC, i64 %5356, ptr %RETURN_PC)
  store ptr %5358, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879753:                                    ; preds = %bb_5389879723, %bb_5389879710
  %5359 = load i64, ptr %NEXT_PC, align 8
  store i64 %5359, ptr %PC, align 8
  %5360 = add i64 %5359, 8
  store i64 %5360, ptr %NEXT_PC, align 8
  %5361 = load i64, ptr %RSP, align 8
  %5362 = add i64 %5361, 40
  %5363 = load ptr, ptr %MEMORY, align 8
  %5364 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %5363, ptr %state, i64 %5362, i64 -1)
  store ptr %5364, ptr %MEMORY, align 8
  %5365 = load i64, ptr %NEXT_PC, align 8
  store i64 %5365, ptr %PC, align 8
  %5366 = add i64 %5365, 4
  store i64 %5366, ptr %NEXT_PC, align 8
  %5367 = load i64, ptr %RBP, align 8
  %5368 = sub i64 %5367, 1
  %5369 = load ptr, ptr %MEMORY, align 8
  %5370 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5369, ptr %state, ptr %R8, i64 %5368)
  store ptr %5370, ptr %MEMORY, align 8
  %5371 = load i64, ptr %NEXT_PC, align 8
  store i64 %5371, ptr %PC, align 8
  %5372 = add i64 %5371, 3
  store i64 %5372, ptr %NEXT_PC, align 8
  %5373 = load i32, ptr %R13D, align 4
  %5374 = zext i32 %5373 to i64
  %5375 = load ptr, ptr %MEMORY, align 8
  %5376 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5375, ptr %state, ptr %R9, i64 %5374)
  store ptr %5376, ptr %MEMORY, align 8
  %5377 = load i64, ptr %NEXT_PC, align 8
  store i64 %5377, ptr %PC, align 8
  %5378 = add i64 %5377, 8
  store i64 %5378, ptr %NEXT_PC, align 8
  %5379 = load i64, ptr %RSP, align 8
  %5380 = add i64 %5379, 32
  %5381 = load ptr, ptr %MEMORY, align 8
  %5382 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %5381, ptr %state, i64 %5380, i64 -1)
  store ptr %5382, ptr %MEMORY, align 8
  %5383 = load i64, ptr %NEXT_PC, align 8
  store i64 %5383, ptr %PC, align 8
  %5384 = add i64 %5383, 2
  store i64 %5384, ptr %NEXT_PC, align 8
  %5385 = load i32, ptr %EBX, align 4
  %5386 = zext i32 %5385 to i64
  %5387 = load ptr, ptr %MEMORY, align 8
  %5388 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5387, ptr %state, ptr %RDX, i64 %5386)
  store ptr %5388, ptr %MEMORY, align 8
  %5389 = load i64, ptr %NEXT_PC, align 8
  store i64 %5389, ptr %PC, align 8
  %5390 = add i64 %5389, 3
  store i64 %5390, ptr %NEXT_PC, align 8
  %5391 = load i64, ptr %R14, align 8
  %5392 = load ptr, ptr %MEMORY, align 8
  %5393 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5392, ptr %state, ptr %RCX, i64 %5391)
  store ptr %5393, ptr %MEMORY, align 8
  %5394 = load i64, ptr %NEXT_PC, align 8
  store i64 %5394, ptr %PC, align 8
  %5395 = add i64 %5394, 5
  store i64 %5395, ptr %NEXT_PC, align 8
  %5396 = load i64, ptr %NEXT_PC, align 8
  %5397 = add i64 %5396, 2150
  %5398 = load i64, ptr %NEXT_PC, align 8
  %5399 = load ptr, ptr %MEMORY, align 8
  %5400 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %5399, ptr %state, i64 %5397, ptr %NEXT_PC, i64 %5398, ptr %RETURN_PC)
  store ptr %5400, ptr %MEMORY, align 8
  %5401 = load i64, ptr %NEXT_PC, align 8
  store i64 %5401, ptr %PC, align 8
  %5402 = add i64 %5401, 4
  store i64 %5402, ptr %NEXT_PC, align 8
  %5403 = load i64, ptr %RBP, align 8
  %5404 = sub i64 %5403, 49
  %5405 = load ptr, ptr %MEMORY, align 8
  %5406 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5405, ptr %state, ptr %RCX, i64 %5404)
  store ptr %5406, ptr %MEMORY, align 8
  %5407 = load i64, ptr %NEXT_PC, align 8
  store i64 %5407, ptr %PC, align 8
  %5408 = add i64 %5407, 5
  store i64 %5408, ptr %NEXT_PC, align 8
  %5409 = load i64, ptr %NEXT_PC, align 8
  %5410 = add i64 %5409, 217
  %5411 = load ptr, ptr %MEMORY, align 8
  %5412 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %5411, ptr %state, i64 %5410, ptr %NEXT_PC)
  store ptr %5412, ptr %MEMORY, align 8
  br label %bb_5389880012

bb_5389879795:                                    ; preds = %bb_5389879657
  %5413 = load i64, ptr %NEXT_PC, align 8
  store i64 %5413, ptr %PC, align 8
  %5414 = add i64 %5413, 2
  store i64 %5414, ptr %NEXT_PC, align 8
  %5415 = load i32, ptr %EBX, align 4
  %5416 = zext i32 %5415 to i64
  %5417 = load ptr, ptr %MEMORY, align 8
  %5418 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5417, ptr %state, ptr %RDX, i64 %5416)
  store ptr %5418, ptr %MEMORY, align 8
  %5419 = load i64, ptr %NEXT_PC, align 8
  store i64 %5419, ptr %PC, align 8
  %5420 = add i64 %5419, 3
  store i64 %5420, ptr %NEXT_PC, align 8
  %5421 = load i64, ptr %R14, align 8
  %5422 = load ptr, ptr %MEMORY, align 8
  %5423 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5422, ptr %state, ptr %RCX, i64 %5421)
  store ptr %5423, ptr %MEMORY, align 8
  %5424 = load i64, ptr %NEXT_PC, align 8
  store i64 %5424, ptr %PC, align 8
  %5425 = add i64 %5424, 5
  store i64 %5425, ptr %NEXT_PC, align 8
  %5426 = load i64, ptr %NEXT_PC, align 8
  %5427 = add i64 %5426, 3731
  %5428 = load i64, ptr %NEXT_PC, align 8
  %5429 = load ptr, ptr %MEMORY, align 8
  %5430 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %5429, ptr %state, i64 %5427, ptr %NEXT_PC, i64 %5428, ptr %RETURN_PC)
  store ptr %5430, ptr %MEMORY, align 8
  %5431 = load i64, ptr %NEXT_PC, align 8
  store i64 %5431, ptr %PC, align 8
  %5432 = add i64 %5431, 3
  store i64 %5432, ptr %NEXT_PC, align 8
  %5433 = load i32, ptr %EAX, align 4
  %5434 = zext i32 %5433 to i64
  %5435 = load ptr, ptr %MEMORY, align 8
  %5436 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %5435, ptr %state, i64 %5434, i64 -1)
  store ptr %5436, ptr %MEMORY, align 8
  %5437 = load i64, ptr %NEXT_PC, align 8
  store i64 %5437, ptr %PC, align 8
  %5438 = add i64 %5437, 2
  store i64 %5438, ptr %NEXT_PC, align 8
  %5439 = load i64, ptr %NEXT_PC, align 8
  %5440 = add i64 %5439, 20
  %5441 = load i64, ptr %NEXT_PC, align 8
  %5442 = load ptr, ptr %MEMORY, align 8
  %5443 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5442, ptr %state, ptr %BRANCH_TAKEN, i64 %5440, i64 %5441, ptr %NEXT_PC)
  store ptr %5443, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879830, label %bb_5389879810

bb_5389879810:                                    ; preds = %bb_5389879795
  %5444 = load i64, ptr %NEXT_PC, align 8
  store i64 %5444, ptr %PC, align 8
  %5445 = add i64 %5444, 4
  store i64 %5445, ptr %NEXT_PC, align 8
  %5446 = load i64, ptr %RBP, align 8
  %5447 = add i64 %5446, 127
  %5448 = load ptr, ptr %MEMORY, align 8
  %5449 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5448, ptr %state, ptr %RDI, i64 %5447)
  store ptr %5449, ptr %MEMORY, align 8
  %5450 = load i64, ptr %NEXT_PC, align 8
  store i64 %5450, ptr %PC, align 8
  %5451 = add i64 %5450, 2
  store i64 %5451, ptr %NEXT_PC, align 8
  %5452 = load i64, ptr %RAX, align 8
  %5453 = load i32, ptr %EAX, align 4
  %5454 = zext i32 %5453 to i64
  %5455 = load ptr, ptr %MEMORY, align 8
  %5456 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %5455, ptr %state, ptr %RAX, i64 %5452, i64 %5454)
  store ptr %5456, ptr %MEMORY, align 8
  %5457 = load i64, ptr %NEXT_PC, align 8
  store i64 %5457, ptr %PC, align 8
  %5458 = add i64 %5457, 4
  store i64 %5458, ptr %NEXT_PC, align 8
  %5459 = load i64, ptr %RBP, align 8
  %5460 = sub i64 %5459, 49
  %5461 = load i64, ptr %RAX, align 8
  %5462 = load ptr, ptr %MEMORY, align 8
  %5463 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5462, ptr %state, i64 %5460, i64 %5461)
  store ptr %5463, ptr %MEMORY, align 8
  %5464 = load i64, ptr %NEXT_PC, align 8
  store i64 %5464, ptr %PC, align 8
  %5465 = add i64 %5464, 3
  store i64 %5465, ptr %NEXT_PC, align 8
  %5466 = load i64, ptr %RDI, align 8
  %5467 = load i64, ptr %RDI, align 8
  %5468 = load ptr, ptr %MEMORY, align 8
  %5469 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5468, ptr %state, i64 %5466, i64 %5467)
  store ptr %5469, ptr %MEMORY, align 8
  %5470 = load i64, ptr %NEXT_PC, align 8
  store i64 %5470, ptr %PC, align 8
  %5471 = add i64 %5470, 2
  store i64 %5471, ptr %NEXT_PC, align 8
  %5472 = load i64, ptr %NEXT_PC, align 8
  %5473 = sub i64 %5472, 115
  %5474 = load i64, ptr %NEXT_PC, align 8
  %5475 = load ptr, ptr %MEMORY, align 8
  %5476 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5475, ptr %state, ptr %BRANCH_TAKEN, i64 %5473, i64 %5474, ptr %NEXT_PC)
  store ptr %5476, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879710, label %bb_5389879825

bb_5389879825:                                    ; preds = %bb_5389879810
  %5477 = load i64, ptr %NEXT_PC, align 8
  store i64 %5477, ptr %PC, align 8
  %5478 = add i64 %5477, 5
  store i64 %5478, ptr %NEXT_PC, align 8
  %5479 = load i64, ptr %NEXT_PC, align 8
  %5480 = sub i64 %5479, 157
  %5481 = load ptr, ptr %MEMORY, align 8
  %5482 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %5481, ptr %state, i64 %5480, ptr %NEXT_PC)
  store ptr %5482, ptr %MEMORY, align 8
  br label %bb_5389879673

bb_5389879830:                                    ; preds = %bb_5389879795
  %5483 = load i64, ptr %NEXT_PC, align 8
  store i64 %5483, ptr %PC, align 8
  %5484 = add i64 %5483, 2
  store i64 %5484, ptr %NEXT_PC, align 8
  %5485 = load i32, ptr %EAX, align 4
  %5486 = zext i32 %5485 to i64
  %5487 = load i32, ptr %EAX, align 4
  %5488 = zext i32 %5487 to i64
  %5489 = load ptr, ptr %MEMORY, align 8
  %5490 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5489, ptr %state, i64 %5486, i64 %5488)
  store ptr %5490, ptr %MEMORY, align 8
  %5491 = load i64, ptr %NEXT_PC, align 8
  store i64 %5491, ptr %PC, align 8
  %5492 = add i64 %5491, 2
  store i64 %5492, ptr %NEXT_PC, align 8
  %5493 = load i64, ptr %NEXT_PC, align 8
  %5494 = add i64 %5493, 61
  %5495 = load i64, ptr %NEXT_PC, align 8
  %5496 = load ptr, ptr %MEMORY, align 8
  %5497 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5496, ptr %state, ptr %BRANCH_TAKEN, i64 %5494, i64 %5495, ptr %NEXT_PC)
  store ptr %5497, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879895, label %bb_5389879834

bb_5389879834:                                    ; preds = %bb_5389879830
  %5498 = load i64, ptr %NEXT_PC, align 8
  store i64 %5498, ptr %PC, align 8
  %5499 = add i64 %5498, 4
  store i64 %5499, ptr %NEXT_PC, align 8
  %5500 = load i32, ptr %EAX, align 4
  %5501 = zext i32 %5500 to i64
  %5502 = load i64, ptr %R14, align 8
  %5503 = add i64 %5502, 40
  %5504 = load ptr, ptr %MEMORY, align 8
  %5505 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %5504, ptr %state, i64 %5501, i64 %5503)
  store ptr %5505, ptr %MEMORY, align 8
  %5506 = load i64, ptr %NEXT_PC, align 8
  store i64 %5506, ptr %PC, align 8
  %5507 = add i64 %5506, 2
  store i64 %5507, ptr %NEXT_PC, align 8
  %5508 = load i64, ptr %NEXT_PC, align 8
  %5509 = add i64 %5508, 55
  %5510 = load i64, ptr %NEXT_PC, align 8
  %5511 = load ptr, ptr %MEMORY, align 8
  %5512 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5511, ptr %state, ptr %BRANCH_TAKEN, i64 %5509, i64 %5510, ptr %NEXT_PC)
  store ptr %5512, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879895, label %bb_5389879840

bb_5389879840:                                    ; preds = %bb_5389879834
  %5513 = load i64, ptr %NEXT_PC, align 8
  store i64 %5513, ptr %PC, align 8
  %5514 = add i64 %5513, 4
  store i64 %5514, ptr %NEXT_PC, align 8
  %5515 = load i64, ptr %R14, align 8
  %5516 = add i64 %5515, 32
  %5517 = load ptr, ptr %MEMORY, align 8
  %5518 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5517, ptr %state, ptr %R8, i64 %5516)
  store ptr %5518, ptr %MEMORY, align 8
  %5519 = load i64, ptr %NEXT_PC, align 8
  store i64 %5519, ptr %PC, align 8
  %5520 = add i64 %5519, 4
  store i64 %5520, ptr %NEXT_PC, align 8
  %5521 = load i64, ptr %R8, align 8
  %5522 = load ptr, ptr %MEMORY, align 8
  %5523 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %5522, ptr %state, ptr %R8, i64 %5521, i64 8)
  store ptr %5523, ptr %MEMORY, align 8
  %5524 = load i64, ptr %NEXT_PC, align 8
  store i64 %5524, ptr %PC, align 8
  %5525 = add i64 %5524, 2
  store i64 %5525, ptr %NEXT_PC, align 8
  %5526 = load ptr, ptr %MEMORY, align 8
  %5527 = call ptr @_ZN12_GLOBAL__N_18CDQE_EAXEP6MemoryR5State(ptr %5526, ptr %state)
  store ptr %5527, ptr %MEMORY, align 8
  %5528 = load i64, ptr %NEXT_PC, align 8
  store i64 %5528, ptr %PC, align 8
  %5529 = add i64 %5528, 4
  store i64 %5529, ptr %NEXT_PC, align 8
  %5530 = load i64, ptr %RAX, align 8
  %5531 = load ptr, ptr %MEMORY, align 8
  %5532 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %5531, ptr %state, ptr %RCX, i64 %5530, i64 56)
  store ptr %5532, ptr %MEMORY, align 8
  %5533 = load i64, ptr %NEXT_PC, align 8
  store i64 %5533, ptr %PC, align 8
  %5534 = add i64 %5533, 3
  store i64 %5534, ptr %NEXT_PC, align 8
  %5535 = load i64, ptr %R8, align 8
  %5536 = load i64, ptr %RCX, align 8
  %5537 = load ptr, ptr %MEMORY, align 8
  %5538 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %5537, ptr %state, ptr %R8, i64 %5535, i64 %5536)
  store ptr %5538, ptr %MEMORY, align 8
  %5539 = load i64, ptr %NEXT_PC, align 8
  store i64 %5539, ptr %PC, align 8
  %5540 = add i64 %5539, 2
  store i64 %5540, ptr %NEXT_PC, align 8
  %5541 = load i64, ptr %RCX, align 8
  %5542 = load i32, ptr %ECX, align 4
  %5543 = zext i32 %5542 to i64
  %5544 = load ptr, ptr %MEMORY, align 8
  %5545 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %5544, ptr %state, ptr %RCX, i64 %5541, i64 %5543)
  store ptr %5545, ptr %MEMORY, align 8
  %5546 = load i64, ptr %NEXT_PC, align 8
  store i64 %5546, ptr %PC, align 8
  %5547 = add i64 %5546, 4
  store i64 %5547, ptr %NEXT_PC, align 8
  %5548 = load i64, ptr %RBP, align 8
  %5549 = add i64 %5548, 31
  %5550 = load i64, ptr %RCX, align 8
  %5551 = load ptr, ptr %MEMORY, align 8
  %5552 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5551, ptr %state, i64 %5549, i64 %5550)
  store ptr %5552, ptr %MEMORY, align 8
  %5553 = load i64, ptr %NEXT_PC, align 8
  store i64 %5553, ptr %PC, align 8
  %5554 = add i64 %5553, 4
  store i64 %5554, ptr %NEXT_PC, align 8
  %5555 = load i64, ptr %R8, align 8
  %5556 = add i64 %5555, 32
  %5557 = load ptr, ptr %MEMORY, align 8
  %5558 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5557, ptr %state, ptr %R9, i64 %5556)
  store ptr %5558, ptr %MEMORY, align 8
  %5559 = load i64, ptr %NEXT_PC, align 8
  store i64 %5559, ptr %PC, align 8
  %5560 = add i64 %5559, 3
  store i64 %5560, ptr %NEXT_PC, align 8
  %5561 = load i64, ptr %R9, align 8
  %5562 = load i64, ptr %R9, align 8
  %5563 = load ptr, ptr %MEMORY, align 8
  %5564 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5563, ptr %state, i64 %5561, i64 %5562)
  store ptr %5564, ptr %MEMORY, align 8
  %5565 = load i64, ptr %NEXT_PC, align 8
  store i64 %5565, ptr %PC, align 8
  %5566 = add i64 %5565, 2
  store i64 %5566, ptr %NEXT_PC, align 8
  %5567 = load i64, ptr %NEXT_PC, align 8
  %5568 = add i64 %5567, 29
  %5569 = load i64, ptr %NEXT_PC, align 8
  %5570 = load ptr, ptr %MEMORY, align 8
  %5571 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5570, ptr %state, ptr %BRANCH_TAKEN, i64 %5568, i64 %5569, ptr %NEXT_PC)
  store ptr %5571, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879901, label %bb_5389879872

bb_5389879872:                                    ; preds = %bb_5389879840
  %5572 = load i64, ptr %NEXT_PC, align 8
  store i64 %5572, ptr %PC, align 8
  %5573 = add i64 %5572, 4
  store i64 %5573, ptr %NEXT_PC, align 8
  %5574 = load i64, ptr %RBP, align 8
  %5575 = add i64 %5574, 31
  %5576 = load i64, ptr %R9, align 8
  %5577 = load ptr, ptr %MEMORY, align 8
  %5578 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5577, ptr %state, i64 %5575, i64 %5576)
  store ptr %5578, ptr %MEMORY, align 8
  %5579 = load i64, ptr %NEXT_PC, align 8
  store i64 %5579, ptr %PC, align 8
  %5580 = add i64 %5579, 4
  store i64 %5580, ptr %NEXT_PC, align 8
  %5581 = load i64, ptr %RBP, align 8
  %5582 = sub i64 %5581, 1
  %5583 = load ptr, ptr %MEMORY, align 8
  %5584 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5583, ptr %state, ptr %RDX, i64 %5582)
  store ptr %5584, ptr %MEMORY, align 8
  %5585 = load i64, ptr %NEXT_PC, align 8
  store i64 %5585, ptr %PC, align 8
  %5586 = add i64 %5585, 3
  store i64 %5586, ptr %NEXT_PC, align 8
  %5587 = load i64, ptr %R9, align 8
  %5588 = load ptr, ptr %MEMORY, align 8
  %5589 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5588, ptr %state, ptr %RAX, i64 %5587)
  store ptr %5589, ptr %MEMORY, align 8
  %5590 = load i64, ptr %NEXT_PC, align 8
  store i64 %5590, ptr %PC, align 8
  %5591 = add i64 %5590, 3
  store i64 %5591, ptr %NEXT_PC, align 8
  %5592 = load i64, ptr %R9, align 8
  %5593 = load ptr, ptr %MEMORY, align 8
  %5594 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5593, ptr %state, ptr %RCX, i64 %5592)
  store ptr %5594, ptr %MEMORY, align 8
  %5595 = load i64, ptr %NEXT_PC, align 8
  store i64 %5595, ptr %PC, align 8
  %5596 = add i64 %5595, 3
  store i64 %5596, ptr %NEXT_PC, align 8
  %5597 = load i64, ptr %RAX, align 8
  %5598 = add i64 %5597, 8
  %5599 = load i64, ptr %NEXT_PC, align 8
  %5600 = load ptr, ptr %MEMORY, align 8
  %5601 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %5600, ptr %state, i64 %5598, ptr %NEXT_PC, i64 %5599, ptr %RETURN_PC)
  store ptr %5601, ptr %MEMORY, align 8
  %5602 = load i64, ptr %NEXT_PC, align 8
  store i64 %5602, ptr %PC, align 8
  %5603 = add i64 %5602, 4
  store i64 %5603, ptr %NEXT_PC, align 8
  %5604 = load i64, ptr %RBP, align 8
  %5605 = add i64 %5604, 31
  %5606 = load ptr, ptr %MEMORY, align 8
  %5607 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5606, ptr %state, ptr %RCX, i64 %5605)
  store ptr %5607, ptr %MEMORY, align 8
  %5608 = load i64, ptr %NEXT_PC, align 8
  store i64 %5608, ptr %PC, align 8
  %5609 = add i64 %5608, 2
  store i64 %5609, ptr %NEXT_PC, align 8
  %5610 = load i64, ptr %NEXT_PC, align 8
  %5611 = add i64 %5610, 6
  %5612 = load ptr, ptr %MEMORY, align 8
  %5613 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %5612, ptr %state, i64 %5611, ptr %NEXT_PC)
  store ptr %5613, ptr %MEMORY, align 8
  br label %bb_5389879901

bb_5389879895:                                    ; preds = %bb_5389879834, %bb_5389879830
  %5614 = load i64, ptr %NEXT_PC, align 8
  store i64 %5614, ptr %PC, align 8
  %5615 = add i64 %5614, 2
  store i64 %5615, ptr %NEXT_PC, align 8
  %5616 = load i64, ptr %RCX, align 8
  %5617 = load i32, ptr %ECX, align 4
  %5618 = zext i32 %5617 to i64
  %5619 = load ptr, ptr %MEMORY, align 8
  %5620 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %5619, ptr %state, ptr %RCX, i64 %5616, i64 %5618)
  store ptr %5620, ptr %MEMORY, align 8
  %5621 = load i64, ptr %NEXT_PC, align 8
  store i64 %5621, ptr %PC, align 8
  %5622 = add i64 %5621, 4
  store i64 %5622, ptr %NEXT_PC, align 8
  %5623 = load i64, ptr %RBP, align 8
  %5624 = add i64 %5623, 31
  %5625 = load i64, ptr %RCX, align 8
  %5626 = load ptr, ptr %MEMORY, align 8
  %5627 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5626, ptr %state, i64 %5624, i64 %5625)
  store ptr %5627, ptr %MEMORY, align 8
  br label %bb_5389879901

bb_5389879901:                                    ; preds = %bb_5389879895, %bb_5389879872, %bb_5389879840
  %5628 = load i64, ptr %NEXT_PC, align 8
  store i64 %5628, ptr %PC, align 8
  %5629 = add i64 %5628, 7
  store i64 %5629, ptr %NEXT_PC, align 8
  %5630 = load i64, ptr %RCX, align 8
  %5631 = load i64, ptr %NEXT_PC, align 8
  %5632 = add i64 %5631, 27071564
  %5633 = load ptr, ptr %MEMORY, align 8
  %5634 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5633, ptr %state, i64 %5630, i64 %5632)
  store ptr %5634, ptr %MEMORY, align 8
  %5635 = load i64, ptr %NEXT_PC, align 8
  store i64 %5635, ptr %PC, align 8
  %5636 = add i64 %5635, 8
  store i64 %5636, ptr %NEXT_PC, align 8
  %5637 = load i64, ptr %RBP, align 8
  %5638 = sub i64 %5637, 57
  %5639 = load ptr, ptr %MEMORY, align 8
  %5640 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %5639, ptr %state, i64 %5638, i64 0)
  store ptr %5640, ptr %MEMORY, align 8
  %5641 = load i64, ptr %NEXT_PC, align 8
  store i64 %5641, ptr %PC, align 8
  %5642 = add i64 %5641, 2
  store i64 %5642, ptr %NEXT_PC, align 8
  %5643 = load i64, ptr %NEXT_PC, align 8
  %5644 = add i64 %5643, 59
  %5645 = load i64, ptr %NEXT_PC, align 8
  %5646 = load ptr, ptr %MEMORY, align 8
  %5647 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5646, ptr %state, ptr %BRANCH_TAKEN, i64 %5644, i64 %5645, ptr %NEXT_PC)
  store ptr %5647, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879977, label %bb_5389879918

bb_5389879918:                                    ; preds = %bb_5389879901
  %5648 = load i64, ptr %NEXT_PC, align 8
  store i64 %5648, ptr %PC, align 8
  %5649 = add i64 %5648, 3
  store i64 %5649, ptr %NEXT_PC, align 8
  %5650 = load i64, ptr %RCX, align 8
  %5651 = load i64, ptr %RCX, align 8
  %5652 = load ptr, ptr %MEMORY, align 8
  %5653 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5652, ptr %state, i64 %5650, i64 %5651)
  store ptr %5653, ptr %MEMORY, align 8
  %5654 = load i64, ptr %NEXT_PC, align 8
  store i64 %5654, ptr %PC, align 8
  %5655 = add i64 %5654, 2
  store i64 %5655, ptr %NEXT_PC, align 8
  %5656 = load i64, ptr %NEXT_PC, align 8
  %5657 = add i64 %5656, 69
  %5658 = load i64, ptr %NEXT_PC, align 8
  %5659 = load ptr, ptr %MEMORY, align 8
  %5660 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5659, ptr %state, ptr %BRANCH_TAKEN, i64 %5657, i64 %5658, ptr %NEXT_PC)
  store ptr %5660, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879992, label %bb_5389879923

bb_5389879923:                                    ; preds = %bb_5389879918
  %5661 = load i64, ptr %NEXT_PC, align 8
  store i64 %5661, ptr %PC, align 8
  %5662 = add i64 %5661, 3
  store i64 %5662, ptr %NEXT_PC, align 8
  %5663 = load i64, ptr %RCX, align 8
  %5664 = load ptr, ptr %MEMORY, align 8
  %5665 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5664, ptr %state, ptr %RAX, i64 %5663)
  store ptr %5665, ptr %MEMORY, align 8
  %5666 = load i64, ptr %NEXT_PC, align 8
  store i64 %5666, ptr %PC, align 8
  %5667 = add i64 %5666, 4
  store i64 %5667, ptr %NEXT_PC, align 8
  %5668 = load i64, ptr %RBP, align 8
  %5669 = sub i64 %5668, 1
  %5670 = load ptr, ptr %MEMORY, align 8
  %5671 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5670, ptr %state, ptr %RDX, i64 %5669)
  store ptr %5671, ptr %MEMORY, align 8
  %5672 = load i64, ptr %NEXT_PC, align 8
  store i64 %5672, ptr %PC, align 8
  %5673 = add i64 %5672, 3
  store i64 %5673, ptr %NEXT_PC, align 8
  %5674 = load i64, ptr %RAX, align 8
  %5675 = add i64 %5674, 56
  %5676 = load i64, ptr %NEXT_PC, align 8
  %5677 = load ptr, ptr %MEMORY, align 8
  %5678 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %5677, ptr %state, i64 %5675, ptr %NEXT_PC, i64 %5676, ptr %RETURN_PC)
  store ptr %5678, ptr %MEMORY, align 8
  %5679 = load i64, ptr %NEXT_PC, align 8
  store i64 %5679, ptr %PC, align 8
  %5680 = add i64 %5679, 3
  store i64 %5680, ptr %NEXT_PC, align 8
  %5681 = load i64, ptr %RAX, align 8
  %5682 = load ptr, ptr %MEMORY, align 8
  %5683 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5682, ptr %state, ptr %RBX, i64 %5681)
  store ptr %5683, ptr %MEMORY, align 8
  %5684 = load i64, ptr %NEXT_PC, align 8
  store i64 %5684, ptr %PC, align 8
  %5685 = add i64 %5684, 3
  store i64 %5685, ptr %NEXT_PC, align 8
  %5686 = load i64, ptr %RAX, align 8
  %5687 = load ptr, ptr %MEMORY, align 8
  %5688 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5687, ptr %state, ptr %RCX, i64 %5686)
  store ptr %5688, ptr %MEMORY, align 8
  %5689 = load i64, ptr %NEXT_PC, align 8
  store i64 %5689, ptr %PC, align 8
  %5690 = add i64 %5689, 3
  store i64 %5690, ptr %NEXT_PC, align 8
  %5691 = load i64, ptr %RCX, align 8
  %5692 = load i64, ptr %RCX, align 8
  %5693 = load ptr, ptr %MEMORY, align 8
  %5694 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5693, ptr %state, i64 %5691, i64 %5692)
  store ptr %5694, ptr %MEMORY, align 8
  %5695 = load i64, ptr %NEXT_PC, align 8
  store i64 %5695, ptr %PC, align 8
  %5696 = add i64 %5695, 2
  store i64 %5696, ptr %NEXT_PC, align 8
  %5697 = load i64, ptr %NEXT_PC, align 8
  %5698 = add i64 %5697, 8
  %5699 = load i64, ptr %NEXT_PC, align 8
  %5700 = load ptr, ptr %MEMORY, align 8
  %5701 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5700, ptr %state, ptr %BRANCH_TAKEN, i64 %5698, i64 %5699, ptr %NEXT_PC)
  store ptr %5701, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879952, label %bb_5389879944

bb_5389879944:                                    ; preds = %bb_5389879923
  %5702 = load i64, ptr %NEXT_PC, align 8
  store i64 %5702, ptr %PC, align 8
  %5703 = add i64 %5702, 2
  store i64 %5703, ptr %NEXT_PC, align 8
  %5704 = load i64, ptr %RCX, align 8
  %5705 = load i64, ptr %RCX, align 8
  %5706 = load ptr, ptr %MEMORY, align 8
  %5707 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %5706, ptr %state, i64 %5704, i64 %5705)
  store ptr %5707, ptr %MEMORY, align 8
  %5708 = load i64, ptr %NEXT_PC, align 8
  store i64 %5708, ptr %PC, align 8
  %5709 = add i64 %5708, 4
  store i64 %5709, ptr %NEXT_PC, align 8
  %5710 = load i64, ptr %RCX, align 8
  %5711 = add i64 %5710, 48
  %5712 = load ptr, ptr %MEMORY, align 8
  %5713 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5712, ptr %state, ptr %RCX, i64 %5711)
  store ptr %5713, ptr %MEMORY, align 8
  %5714 = load i64, ptr %NEXT_PC, align 8
  store i64 %5714, ptr %PC, align 8
  %5715 = add i64 %5714, 2
  store i64 %5715, ptr %NEXT_PC, align 8
  %5716 = load i64, ptr %RCX, align 8
  %5717 = load i64, ptr %RCX, align 8
  %5718 = load ptr, ptr %MEMORY, align 8
  %5719 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %5718, ptr %state, i64 %5716, i64 %5717)
  store ptr %5719, ptr %MEMORY, align 8
  br label %bb_5389879952

bb_5389879952:                                    ; preds = %bb_5389879944, %bb_5389879923
  %5720 = load i64, ptr %NEXT_PC, align 8
  store i64 %5720, ptr %PC, align 8
  %5721 = add i64 %5720, 4
  store i64 %5721, ptr %NEXT_PC, align 8
  %5722 = load i64, ptr %RBP, align 8
  %5723 = sub i64 %5722, 57
  %5724 = load ptr, ptr %MEMORY, align 8
  %5725 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5724, ptr %state, ptr %RCX, i64 %5723)
  store ptr %5725, ptr %MEMORY, align 8
  %5726 = load i64, ptr %NEXT_PC, align 8
  store i64 %5726, ptr %PC, align 8
  %5727 = add i64 %5726, 3
  store i64 %5727, ptr %NEXT_PC, align 8
  %5728 = load i64, ptr %RCX, align 8
  %5729 = load i64, ptr %RCX, align 8
  %5730 = load ptr, ptr %MEMORY, align 8
  %5731 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5730, ptr %state, i64 %5728, i64 %5729)
  store ptr %5731, ptr %MEMORY, align 8
  %5732 = load i64, ptr %NEXT_PC, align 8
  store i64 %5732, ptr %PC, align 8
  %5733 = add i64 %5732, 2
  store i64 %5733, ptr %NEXT_PC, align 8
  %5734 = load i64, ptr %NEXT_PC, align 8
  %5735 = add i64 %5734, 5
  %5736 = load i64, ptr %NEXT_PC, align 8
  %5737 = load ptr, ptr %MEMORY, align 8
  %5738 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5737, ptr %state, ptr %BRANCH_TAKEN, i64 %5735, i64 %5736, ptr %NEXT_PC)
  store ptr %5738, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879966, label %bb_5389879961

bb_5389879961:                                    ; preds = %bb_5389879952
  %5739 = load i64, ptr %NEXT_PC, align 8
  store i64 %5739, ptr %PC, align 8
  %5740 = add i64 %5739, 5
  store i64 %5740, ptr %NEXT_PC, align 8
  %5741 = load i64, ptr %NEXT_PC, align 8
  %5742 = sub i64 %5741, 3262
  %5743 = load i64, ptr %NEXT_PC, align 8
  %5744 = load ptr, ptr %MEMORY, align 8
  %5745 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %5744, ptr %state, i64 %5742, ptr %NEXT_PC, i64 %5743, ptr %RETURN_PC)
  store ptr %5745, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879966:                                    ; preds = %bb_5389879952
  %5746 = load i64, ptr %NEXT_PC, align 8
  store i64 %5746, ptr %PC, align 8
  %5747 = add i64 %5746, 3
  store i64 %5747, ptr %NEXT_PC, align 8
  %5748 = load i64, ptr %RBX, align 8
  %5749 = load ptr, ptr %MEMORY, align 8
  %5750 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5749, ptr %state, ptr %RAX, i64 %5748)
  store ptr %5750, ptr %MEMORY, align 8
  %5751 = load i64, ptr %NEXT_PC, align 8
  store i64 %5751, ptr %PC, align 8
  %5752 = add i64 %5751, 4
  store i64 %5752, ptr %NEXT_PC, align 8
  %5753 = load i64, ptr %RBP, align 8
  %5754 = add i64 %5753, 31
  %5755 = load ptr, ptr %MEMORY, align 8
  %5756 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5755, ptr %state, ptr %RCX, i64 %5754)
  store ptr %5756, ptr %MEMORY, align 8
  %5757 = load i64, ptr %NEXT_PC, align 8
  store i64 %5757, ptr %PC, align 8
  %5758 = add i64 %5757, 4
  store i64 %5758, ptr %NEXT_PC, align 8
  %5759 = load i64, ptr %RBP, align 8
  %5760 = sub i64 %5759, 57
  %5761 = load i64, ptr %RAX, align 8
  %5762 = load ptr, ptr %MEMORY, align 8
  %5763 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5762, ptr %state, i64 %5760, i64 %5761)
  store ptr %5763, ptr %MEMORY, align 8
  br label %bb_5389879977

bb_5389879977:                                    ; preds = %bb_5389879966, %bb_5389879901
  %5764 = load i64, ptr %NEXT_PC, align 8
  store i64 %5764, ptr %PC, align 8
  %5765 = add i64 %5764, 3
  store i64 %5765, ptr %NEXT_PC, align 8
  %5766 = load i64, ptr %RCX, align 8
  %5767 = load i64, ptr %RCX, align 8
  %5768 = load ptr, ptr %MEMORY, align 8
  %5769 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5768, ptr %state, i64 %5766, i64 %5767)
  store ptr %5769, ptr %MEMORY, align 8
  %5770 = load i64, ptr %NEXT_PC, align 8
  store i64 %5770, ptr %PC, align 8
  %5771 = add i64 %5770, 2
  store i64 %5771, ptr %NEXT_PC, align 8
  %5772 = load i64, ptr %NEXT_PC, align 8
  %5773 = add i64 %5772, 10
  %5774 = load i64, ptr %NEXT_PC, align 8
  %5775 = load ptr, ptr %MEMORY, align 8
  %5776 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5775, ptr %state, ptr %BRANCH_TAKEN, i64 %5773, i64 %5774, ptr %NEXT_PC)
  store ptr %5776, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879992, label %bb_5389879982

bb_5389879982:                                    ; preds = %bb_5389879977
  %5777 = load i64, ptr %NEXT_PC, align 8
  store i64 %5777, ptr %PC, align 8
  %5778 = add i64 %5777, 3
  store i64 %5778, ptr %NEXT_PC, align 8
  %5779 = load i64, ptr %RCX, align 8
  %5780 = load ptr, ptr %MEMORY, align 8
  %5781 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5780, ptr %state, ptr %RAX, i64 %5779)
  store ptr %5781, ptr %MEMORY, align 8
  %5782 = load i64, ptr %NEXT_PC, align 8
  store i64 %5782, ptr %PC, align 8
  %5783 = add i64 %5782, 4
  store i64 %5783, ptr %NEXT_PC, align 8
  %5784 = load i64, ptr %RBP, align 8
  %5785 = sub i64 %5784, 1
  %5786 = load ptr, ptr %MEMORY, align 8
  %5787 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5786, ptr %state, ptr %RDX, i64 %5785)
  store ptr %5787, ptr %MEMORY, align 8
  %5788 = load i64, ptr %NEXT_PC, align 8
  store i64 %5788, ptr %PC, align 8
  %5789 = add i64 %5788, 3
  store i64 %5789, ptr %NEXT_PC, align 8
  %5790 = load i64, ptr %RAX, align 8
  %5791 = add i64 %5790, 24
  %5792 = load i64, ptr %NEXT_PC, align 8
  %5793 = load ptr, ptr %MEMORY, align 8
  %5794 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %5793, ptr %state, i64 %5791, ptr %NEXT_PC, i64 %5792, ptr %RETURN_PC)
  store ptr %5794, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879992:                                    ; preds = %bb_5389879977, %bb_5389879918
  %5795 = load i64, ptr %NEXT_PC, align 8
  store i64 %5795, ptr %PC, align 8
  %5796 = add i64 %5795, 3
  store i64 %5796, ptr %NEXT_PC, align 8
  %5797 = load i32, ptr %R13D, align 4
  %5798 = zext i32 %5797 to i64
  %5799 = load ptr, ptr %MEMORY, align 8
  %5800 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5799, ptr %state, ptr %R8, i64 %5798)
  store ptr %5800, ptr %MEMORY, align 8
  %5801 = load i64, ptr %NEXT_PC, align 8
  store i64 %5801, ptr %PC, align 8
  %5802 = add i64 %5801, 4
  store i64 %5802, ptr %NEXT_PC, align 8
  %5803 = load i64, ptr %RBP, align 8
  %5804 = add i64 %5803, 127
  %5805 = load ptr, ptr %MEMORY, align 8
  %5806 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5805, ptr %state, ptr %RDX, i64 %5804)
  store ptr %5806, ptr %MEMORY, align 8
  %5807 = load i64, ptr %NEXT_PC, align 8
  store i64 %5807, ptr %PC, align 8
  %5808 = add i64 %5807, 4
  store i64 %5808, ptr %NEXT_PC, align 8
  %5809 = load i64, ptr %RBP, align 8
  %5810 = sub i64 %5809, 57
  %5811 = load ptr, ptr %MEMORY, align 8
  %5812 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5811, ptr %state, ptr %RCX, i64 %5810)
  store ptr %5812, ptr %MEMORY, align 8
  %5813 = load i64, ptr %NEXT_PC, align 8
  store i64 %5813, ptr %PC, align 8
  %5814 = add i64 %5813, 5
  store i64 %5814, ptr %NEXT_PC, align 8
  %5815 = load i64, ptr %NEXT_PC, align 8
  %5816 = sub i64 %5815, 583256
  %5817 = load i64, ptr %NEXT_PC, align 8
  %5818 = load ptr, ptr %MEMORY, align 8
  %5819 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %5818, ptr %state, i64 %5816, ptr %NEXT_PC, i64 %5817, ptr %RETURN_PC)
  store ptr %5819, ptr %MEMORY, align 8
  %5820 = load i64, ptr %NEXT_PC, align 8
  store i64 %5820, ptr %PC, align 8
  %5821 = add i64 %5820, 4
  store i64 %5821, ptr %NEXT_PC, align 8
  %5822 = load i64, ptr %RBP, align 8
  %5823 = sub i64 %5822, 57
  %5824 = load ptr, ptr %MEMORY, align 8
  %5825 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5824, ptr %state, ptr %RCX, i64 %5823)
  store ptr %5825, ptr %MEMORY, align 8
  br label %bb_5389880012

bb_5389880012:                                    ; preds = %bb_5389879992, %bb_5389879753
  %5826 = load i64, ptr %NEXT_PC, align 8
  store i64 %5826, ptr %PC, align 8
  %5827 = add i64 %5826, 3
  store i64 %5827, ptr %NEXT_PC, align 8
  %5828 = load i64, ptr %RCX, align 8
  %5829 = load i64, ptr %RCX, align 8
  %5830 = load ptr, ptr %MEMORY, align 8
  %5831 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5830, ptr %state, i64 %5828, i64 %5829)
  store ptr %5831, ptr %MEMORY, align 8
  %5832 = load i64, ptr %NEXT_PC, align 8
  store i64 %5832, ptr %PC, align 8
  %5833 = add i64 %5832, 2
  store i64 %5833, ptr %NEXT_PC, align 8
  %5834 = load i64, ptr %NEXT_PC, align 8
  %5835 = add i64 %5834, 5
  %5836 = load i64, ptr %NEXT_PC, align 8
  %5837 = load ptr, ptr %MEMORY, align 8
  %5838 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5837, ptr %state, ptr %BRANCH_TAKEN, i64 %5835, i64 %5836, ptr %NEXT_PC)
  store ptr %5838, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880022, label %bb_5389880017

bb_5389880017:                                    ; preds = %bb_5389880012
  %5839 = load i64, ptr %NEXT_PC, align 8
  store i64 %5839, ptr %PC, align 8
  %5840 = add i64 %5839, 5
  store i64 %5840, ptr %NEXT_PC, align 8
  %5841 = load i64, ptr %NEXT_PC, align 8
  %5842 = sub i64 %5841, 3318
  %5843 = load i64, ptr %NEXT_PC, align 8
  %5844 = load ptr, ptr %MEMORY, align 8
  %5845 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %5844, ptr %state, i64 %5842, ptr %NEXT_PC, i64 %5843, ptr %RETURN_PC)
  store ptr %5845, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880022:                                    ; preds = %bb_5389880012, %bb_5389879520
  %5846 = load i64, ptr %NEXT_PC, align 8
  store i64 %5846, ptr %PC, align 8
  %5847 = add i64 %5846, 4
  store i64 %5847, ptr %NEXT_PC, align 8
  %5848 = load i64, ptr %RBP, align 8
  %5849 = add i64 %5848, 127
  %5850 = load ptr, ptr %MEMORY, align 8
  %5851 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5850, ptr %state, ptr %RCX, i64 %5849)
  store ptr %5851, ptr %MEMORY, align 8
  %5852 = load i64, ptr %NEXT_PC, align 8
  store i64 %5852, ptr %PC, align 8
  %5853 = add i64 %5852, 3
  store i64 %5853, ptr %NEXT_PC, align 8
  %5854 = load i64, ptr %RCX, align 8
  %5855 = load i64, ptr %RCX, align 8
  %5856 = load ptr, ptr %MEMORY, align 8
  %5857 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5856, ptr %state, i64 %5854, i64 %5855)
  store ptr %5857, ptr %MEMORY, align 8
  %5858 = load i64, ptr %NEXT_PC, align 8
  store i64 %5858, ptr %PC, align 8
  %5859 = add i64 %5858, 2
  store i64 %5859, ptr %NEXT_PC, align 8
  %5860 = load i64, ptr %NEXT_PC, align 8
  %5861 = add i64 %5860, 5
  %5862 = load i64, ptr %NEXT_PC, align 8
  %5863 = load ptr, ptr %MEMORY, align 8
  %5864 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5863, ptr %state, ptr %BRANCH_TAKEN, i64 %5861, i64 %5862, ptr %NEXT_PC)
  store ptr %5864, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880036, label %bb_5389880031

bb_5389880031:                                    ; preds = %bb_5389880022
  %5865 = load i64, ptr %NEXT_PC, align 8
  store i64 %5865, ptr %PC, align 8
  %5866 = add i64 %5865, 5
  store i64 %5866, ptr %NEXT_PC, align 8
  %5867 = load i64, ptr %NEXT_PC, align 8
  %5868 = sub i64 %5867, 3332
  %5869 = load i64, ptr %NEXT_PC, align 8
  %5870 = load ptr, ptr %MEMORY, align 8
  %5871 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %5870, ptr %state, i64 %5868, ptr %NEXT_PC, i64 %5869, ptr %RETURN_PC)
  store ptr %5871, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880036:                                    ; preds = %bb_5389880022
  %5872 = load i64, ptr %NEXT_PC, align 8
  store i64 %5872, ptr %PC, align 8
  %5873 = add i64 %5872, 4
  store i64 %5873, ptr %NEXT_PC, align 8
  %5874 = load i64, ptr %RBP, align 8
  %5875 = sub i64 %5874, 9
  %5876 = load ptr, ptr %MEMORY, align 8
  %5877 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5876, ptr %state, ptr %RCX, i64 %5875)
  store ptr %5877, ptr %MEMORY, align 8
  %5878 = load i64, ptr %NEXT_PC, align 8
  store i64 %5878, ptr %PC, align 8
  %5879 = add i64 %5878, 3
  store i64 %5879, ptr %NEXT_PC, align 8
  %5880 = load i64, ptr %RCX, align 8
  %5881 = load i64, ptr %RCX, align 8
  %5882 = load ptr, ptr %MEMORY, align 8
  %5883 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %5882, ptr %state, i64 %5880, i64 %5881)
  store ptr %5883, ptr %MEMORY, align 8
  %5884 = load i64, ptr %NEXT_PC, align 8
  store i64 %5884, ptr %PC, align 8
  %5885 = add i64 %5884, 2
  store i64 %5885, ptr %NEXT_PC, align 8
  %5886 = load i64, ptr %NEXT_PC, align 8
  %5887 = add i64 %5886, 10
  %5888 = load i64, ptr %NEXT_PC, align 8
  %5889 = load ptr, ptr %MEMORY, align 8
  %5890 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %5889, ptr %state, ptr %BRANCH_TAKEN, i64 %5887, i64 %5888, ptr %NEXT_PC)
  store ptr %5890, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880055, label %bb_5389880045

bb_5389880045:                                    ; preds = %bb_5389880036
  %5891 = load i64, ptr %NEXT_PC, align 8
  store i64 %5891, ptr %PC, align 8
  %5892 = add i64 %5891, 3
  store i64 %5892, ptr %NEXT_PC, align 8
  %5893 = load i64, ptr %RCX, align 8
  %5894 = load ptr, ptr %MEMORY, align 8
  %5895 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5894, ptr %state, ptr %RAX, i64 %5893)
  store ptr %5895, ptr %MEMORY, align 8
  %5896 = load i64, ptr %NEXT_PC, align 8
  store i64 %5896, ptr %PC, align 8
  %5897 = add i64 %5896, 4
  store i64 %5897, ptr %NEXT_PC, align 8
  %5898 = load i64, ptr %RBP, align 8
  %5899 = sub i64 %5898, 41
  %5900 = load ptr, ptr %MEMORY, align 8
  %5901 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %5900, ptr %state, ptr %RDX, i64 %5899)
  store ptr %5901, ptr %MEMORY, align 8
  %5902 = load i64, ptr %NEXT_PC, align 8
  store i64 %5902, ptr %PC, align 8
  %5903 = add i64 %5902, 3
  store i64 %5903, ptr %NEXT_PC, align 8
  %5904 = load i64, ptr %RAX, align 8
  %5905 = add i64 %5904, 24
  %5906 = load i64, ptr %NEXT_PC, align 8
  %5907 = load ptr, ptr %MEMORY, align 8
  %5908 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %5907, ptr %state, i64 %5905, ptr %NEXT_PC, i64 %5906, ptr %RETURN_PC)
  store ptr %5908, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880055:                                    ; preds = %bb_5389880036
  %5909 = load i64, ptr %NEXT_PC, align 8
  store i64 %5909, ptr %PC, align 8
  %5910 = add i64 %5909, 4
  store i64 %5910, ptr %NEXT_PC, align 8
  %5911 = load i64, ptr %RBP, align 8
  %5912 = add i64 %5911, 111
  %5913 = load ptr, ptr %MEMORY, align 8
  %5914 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5913, ptr %state, ptr %RAX, i64 %5912)
  store ptr %5914, ptr %MEMORY, align 8
  %5915 = load i64, ptr %NEXT_PC, align 8
  store i64 %5915, ptr %PC, align 8
  %5916 = add i64 %5915, 2
  store i64 %5916, ptr %NEXT_PC, align 8
  %5917 = load i64, ptr %RSI, align 8
  %5918 = load ptr, ptr %MEMORY, align 8
  %5919 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5918, ptr %state, ptr %RSI, i64 %5917)
  store ptr %5919, ptr %MEMORY, align 8
  %5920 = load i64, ptr %NEXT_PC, align 8
  store i64 %5920, ptr %PC, align 8
  %5921 = add i64 %5920, 3
  store i64 %5921, ptr %NEXT_PC, align 8
  %5922 = load i64, ptr %R15, align 8
  %5923 = load ptr, ptr %MEMORY, align 8
  %5924 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %5923, ptr %state, ptr %R15, i64 %5922)
  store ptr %5924, ptr %MEMORY, align 8
  %5925 = load i64, ptr %NEXT_PC, align 8
  store i64 %5925, ptr %PC, align 8
  %5926 = add i64 %5925, 4
  store i64 %5926, ptr %NEXT_PC, align 8
  %5927 = load i64, ptr %R12, align 8
  %5928 = load ptr, ptr %MEMORY, align 8
  %5929 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %5928, ptr %state, ptr %R12, i64 %5927, i64 56)
  store ptr %5929, ptr %MEMORY, align 8
  %5930 = load i64, ptr %NEXT_PC, align 8
  store i64 %5930, ptr %PC, align 8
  %5931 = add i64 %5930, 5
  store i64 %5931, ptr %NEXT_PC, align 8
  %5932 = load i64, ptr %NEXT_PC, align 8
  %5933 = sub i64 %5932, 708
  %5934 = load ptr, ptr %MEMORY, align 8
  %5935 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %5934, ptr %state, i64 %5933, ptr %NEXT_PC)
  store ptr %5935, ptr %MEMORY, align 8
  br label %bb_5389879365

bb_5389880073:                                    ; preds = %bb_5389879381
  %5936 = load i64, ptr %NEXT_PC, align 8
  store i64 %5936, ptr %PC, align 8
  %5937 = add i64 %5936, 8
  store i64 %5937, ptr %NEXT_PC, align 8
  %5938 = load i64, ptr %RSP, align 8
  %5939 = add i64 %5938, 144
  %5940 = load ptr, ptr %MEMORY, align 8
  %5941 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5940, ptr %state, ptr %RDI, i64 %5939)
  store ptr %5941, ptr %MEMORY, align 8
  %5942 = load i64, ptr %NEXT_PC, align 8
  store i64 %5942, ptr %PC, align 8
  %5943 = add i64 %5942, 8
  store i64 %5943, ptr %NEXT_PC, align 8
  %5944 = load i64, ptr %RSP, align 8
  %5945 = add i64 %5944, 208
  %5946 = load ptr, ptr %MEMORY, align 8
  %5947 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %5946, ptr %state, ptr %RBX, i64 %5945)
  store ptr %5947, ptr %MEMORY, align 8
  %5948 = load i64, ptr %NEXT_PC, align 8
  store i64 %5948, ptr %PC, align 8
  %5949 = add i64 %5948, 7
  store i64 %5949, ptr %NEXT_PC, align 8
  %5950 = load i64, ptr %RSP, align 8
  %5951 = load ptr, ptr %MEMORY, align 8
  %5952 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %5951, ptr %state, ptr %RSP, i64 %5950, i64 152)
  store ptr %5952, ptr %MEMORY, align 8
  %5953 = load i64, ptr %NEXT_PC, align 8
  store i64 %5953, ptr %PC, align 8
  %5954 = add i64 %5953, 2
  store i64 %5954, ptr %NEXT_PC, align 8
  %5955 = load ptr, ptr %MEMORY, align 8
  %5956 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %5955, ptr %state, ptr %R15)
  store ptr %5956, ptr %MEMORY, align 8
  %5957 = load i64, ptr %NEXT_PC, align 8
  store i64 %5957, ptr %PC, align 8
  %5958 = add i64 %5957, 2
  store i64 %5958, ptr %NEXT_PC, align 8
  %5959 = load ptr, ptr %MEMORY, align 8
  %5960 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %5959, ptr %state, ptr %R14)
  store ptr %5960, ptr %MEMORY, align 8
  %5961 = load i64, ptr %NEXT_PC, align 8
  store i64 %5961, ptr %PC, align 8
  %5962 = add i64 %5961, 2
  store i64 %5962, ptr %NEXT_PC, align 8
  %5963 = load ptr, ptr %MEMORY, align 8
  %5964 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %5963, ptr %state, ptr %R13)
  store ptr %5964, ptr %MEMORY, align 8
  %5965 = load i64, ptr %NEXT_PC, align 8
  store i64 %5965, ptr %PC, align 8
  %5966 = add i64 %5965, 2
  store i64 %5966, ptr %NEXT_PC, align 8
  %5967 = load ptr, ptr %MEMORY, align 8
  %5968 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %5967, ptr %state, ptr %R12)
  store ptr %5968, ptr %MEMORY, align 8
  %5969 = load i64, ptr %NEXT_PC, align 8
  store i64 %5969, ptr %PC, align 8
  %5970 = add i64 %5969, 1
  store i64 %5970, ptr %NEXT_PC, align 8
  %5971 = load ptr, ptr %MEMORY, align 8
  %5972 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %5971, ptr %state, ptr %RSI)
  store ptr %5972, ptr %MEMORY, align 8
  %5973 = load i64, ptr %NEXT_PC, align 8
  store i64 %5973, ptr %PC, align 8
  %5974 = add i64 %5973, 1
  store i64 %5974, ptr %NEXT_PC, align 8
  %5975 = load ptr, ptr %MEMORY, align 8
  %5976 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %5975, ptr %state, ptr %RBP)
  store ptr %5976, ptr %MEMORY, align 8
  %5977 = load i64, ptr %NEXT_PC, align 8
  store i64 %5977, ptr %PC, align 8
  %5978 = add i64 %5977, 1
  store i64 %5978, ptr %NEXT_PC, align 8
  %5979 = load ptr, ptr %MEMORY, align 8
  %5980 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %5979, ptr %state, ptr %NEXT_PC)
  store ptr %5980, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880107:                                    ; No predecessors!
  %5981 = load i64, ptr %NEXT_PC, align 8
  store i64 %5981, ptr %PC, align 8
  %5982 = add i64 %5981, 1
  store i64 %5982, ptr %NEXT_PC, align 8
  %5983 = load ptr, ptr %MEMORY, align 8
  %5984 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5983, ptr %state, ptr undef)
  store ptr %5984, ptr %MEMORY, align 8
  %5985 = load i64, ptr %NEXT_PC, align 8
  store i64 %5985, ptr %PC, align 8
  %5986 = add i64 %5985, 1
  store i64 %5986, ptr %NEXT_PC, align 8
  %5987 = load ptr, ptr %MEMORY, align 8
  %5988 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5987, ptr %state, ptr undef)
  store ptr %5988, ptr %MEMORY, align 8
  %5989 = load i64, ptr %NEXT_PC, align 8
  store i64 %5989, ptr %PC, align 8
  %5990 = add i64 %5989, 1
  store i64 %5990, ptr %NEXT_PC, align 8
  %5991 = load ptr, ptr %MEMORY, align 8
  %5992 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5991, ptr %state, ptr undef)
  store ptr %5992, ptr %MEMORY, align 8
  %5993 = load i64, ptr %NEXT_PC, align 8
  store i64 %5993, ptr %PC, align 8
  %5994 = add i64 %5993, 1
  store i64 %5994, ptr %NEXT_PC, align 8
  %5995 = load ptr, ptr %MEMORY, align 8
  %5996 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5995, ptr %state, ptr undef)
  store ptr %5996, ptr %MEMORY, align 8
  %5997 = load i64, ptr %NEXT_PC, align 8
  store i64 %5997, ptr %PC, align 8
  %5998 = add i64 %5997, 1
  store i64 %5998, ptr %NEXT_PC, align 8
  %5999 = load ptr, ptr %MEMORY, align 8
  %6000 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %5999, ptr %state, ptr undef)
  store ptr %6000, ptr %MEMORY, align 8
  %6001 = load i64, ptr %NEXT_PC, align 8
  store i64 %6001, ptr %PC, align 8
  %6002 = add i64 %6001, 1
  store i64 %6002, ptr %NEXT_PC, align 8
  %6003 = load ptr, ptr %MEMORY, align 8
  %6004 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6003, ptr %state, ptr undef)
  store ptr %6004, ptr %MEMORY, align 8
  %6005 = load i64, ptr %NEXT_PC, align 8
  store i64 %6005, ptr %PC, align 8
  %6006 = add i64 %6005, 1
  store i64 %6006, ptr %NEXT_PC, align 8
  %6007 = load ptr, ptr %MEMORY, align 8
  %6008 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6007, ptr %state, ptr undef)
  store ptr %6008, ptr %MEMORY, align 8
  %6009 = load i64, ptr %NEXT_PC, align 8
  store i64 %6009, ptr %PC, align 8
  %6010 = add i64 %6009, 1
  store i64 %6010, ptr %NEXT_PC, align 8
  %6011 = load ptr, ptr %MEMORY, align 8
  %6012 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6011, ptr %state, ptr undef)
  store ptr %6012, ptr %MEMORY, align 8
  %6013 = load i64, ptr %NEXT_PC, align 8
  store i64 %6013, ptr %PC, align 8
  %6014 = add i64 %6013, 1
  store i64 %6014, ptr %NEXT_PC, align 8
  %6015 = load ptr, ptr %MEMORY, align 8
  %6016 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6015, ptr %state, ptr undef)
  store ptr %6016, ptr %MEMORY, align 8
  %6017 = load i64, ptr %NEXT_PC, align 8
  store i64 %6017, ptr %PC, align 8
  %6018 = add i64 %6017, 1
  store i64 %6018, ptr %NEXT_PC, align 8
  %6019 = load ptr, ptr %MEMORY, align 8
  %6020 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6019, ptr %state, ptr undef)
  store ptr %6020, ptr %MEMORY, align 8
  %6021 = load i64, ptr %NEXT_PC, align 8
  store i64 %6021, ptr %PC, align 8
  %6022 = add i64 %6021, 1
  store i64 %6022, ptr %NEXT_PC, align 8
  %6023 = load ptr, ptr %MEMORY, align 8
  %6024 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6023, ptr %state, ptr undef)
  store ptr %6024, ptr %MEMORY, align 8
  %6025 = load i64, ptr %NEXT_PC, align 8
  store i64 %6025, ptr %PC, align 8
  %6026 = add i64 %6025, 1
  store i64 %6026, ptr %NEXT_PC, align 8
  %6027 = load ptr, ptr %MEMORY, align 8
  %6028 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6027, ptr %state, ptr undef)
  store ptr %6028, ptr %MEMORY, align 8
  %6029 = load i64, ptr %NEXT_PC, align 8
  store i64 %6029, ptr %PC, align 8
  %6030 = add i64 %6029, 1
  store i64 %6030, ptr %NEXT_PC, align 8
  %6031 = load ptr, ptr %MEMORY, align 8
  %6032 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6031, ptr %state, ptr undef)
  store ptr %6032, ptr %MEMORY, align 8
  %6033 = load i64, ptr %NEXT_PC, align 8
  store i64 %6033, ptr %PC, align 8
  %6034 = add i64 %6033, 1
  store i64 %6034, ptr %NEXT_PC, align 8
  %6035 = load ptr, ptr %MEMORY, align 8
  %6036 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6035, ptr %state, ptr undef)
  store ptr %6036, ptr %MEMORY, align 8
  %6037 = load i64, ptr %NEXT_PC, align 8
  store i64 %6037, ptr %PC, align 8
  %6038 = add i64 %6037, 1
  store i64 %6038, ptr %NEXT_PC, align 8
  %6039 = load ptr, ptr %MEMORY, align 8
  %6040 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6039, ptr %state, ptr undef)
  store ptr %6040, ptr %MEMORY, align 8
  %6041 = load i64, ptr %NEXT_PC, align 8
  store i64 %6041, ptr %PC, align 8
  %6042 = add i64 %6041, 1
  store i64 %6042, ptr %NEXT_PC, align 8
  %6043 = load ptr, ptr %MEMORY, align 8
  %6044 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6043, ptr %state, ptr undef)
  store ptr %6044, ptr %MEMORY, align 8
  %6045 = load i64, ptr %NEXT_PC, align 8
  store i64 %6045, ptr %PC, align 8
  %6046 = add i64 %6045, 1
  store i64 %6046, ptr %NEXT_PC, align 8
  %6047 = load ptr, ptr %MEMORY, align 8
  %6048 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6047, ptr %state, ptr undef)
  store ptr %6048, ptr %MEMORY, align 8
  %6049 = load i64, ptr %NEXT_PC, align 8
  store i64 %6049, ptr %PC, align 8
  %6050 = add i64 %6049, 1
  store i64 %6050, ptr %NEXT_PC, align 8
  %6051 = load ptr, ptr %MEMORY, align 8
  %6052 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6051, ptr %state, ptr undef)
  store ptr %6052, ptr %MEMORY, align 8
  %6053 = load i64, ptr %NEXT_PC, align 8
  store i64 %6053, ptr %PC, align 8
  %6054 = add i64 %6053, 1
  store i64 %6054, ptr %NEXT_PC, align 8
  %6055 = load ptr, ptr %MEMORY, align 8
  %6056 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6055, ptr %state, ptr undef)
  store ptr %6056, ptr %MEMORY, align 8
  %6057 = load i64, ptr %NEXT_PC, align 8
  store i64 %6057, ptr %PC, align 8
  %6058 = add i64 %6057, 1
  store i64 %6058, ptr %NEXT_PC, align 8
  %6059 = load ptr, ptr %MEMORY, align 8
  %6060 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6059, ptr %state, ptr undef)
  store ptr %6060, ptr %MEMORY, align 8
  %6061 = load i64, ptr %NEXT_PC, align 8
  store i64 %6061, ptr %PC, align 8
  %6062 = add i64 %6061, 1
  store i64 %6062, ptr %NEXT_PC, align 8
  %6063 = load ptr, ptr %MEMORY, align 8
  %6064 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6063, ptr %state, ptr undef)
  store ptr %6064, ptr %MEMORY, align 8
  %6065 = load i64, ptr %NEXT_PC, align 8
  store i64 %6065, ptr %PC, align 8
  %6066 = add i64 %6065, 5
  store i64 %6066, ptr %NEXT_PC, align 8
  %6067 = load i64, ptr %RCX, align 8
  %6068 = add i64 %6067, 56
  %6069 = load ptr, ptr %MEMORY, align 8
  %6070 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %6069, ptr %state, ptr %R8, i64 %6068)
  store ptr %6070, ptr %MEMORY, align 8
  %6071 = load i64, ptr %NEXT_PC, align 8
  store i64 %6071, ptr %PC, align 8
  %6072 = add i64 %6071, 4
  store i64 %6072, ptr %NEXT_PC, align 8
  %6073 = load i8, ptr %R8B, align 1
  %6074 = zext i8 %6073 to i64
  %6075 = load ptr, ptr %MEMORY, align 8
  %6076 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6075, ptr %state, ptr %RAX, i64 %6074)
  store ptr %6076, ptr %MEMORY, align 8
  %6077 = load i64, ptr %NEXT_PC, align 8
  store i64 %6077, ptr %PC, align 8
  %6078 = add i64 %6077, 4
  store i64 %6078, ptr %NEXT_PC, align 8
  %6079 = load i8, ptr %R8B, align 1
  %6080 = zext i8 %6079 to i64
  %6081 = load ptr, ptr %MEMORY, align 8
  %6082 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %6081, ptr %state, ptr %R8B, i64 %6080, i64 1)
  store ptr %6082, ptr %MEMORY, align 8
  %6083 = load i64, ptr %NEXT_PC, align 8
  store i64 %6083, ptr %PC, align 8
  %6084 = add i64 %6083, 2
  store i64 %6084, ptr %NEXT_PC, align 8
  %6085 = load i8, ptr %AL, align 1
  %6086 = zext i8 %6085 to i64
  %6087 = load ptr, ptr %MEMORY, align 8
  %6088 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %6087, ptr %state, ptr %AL, i64 %6086, i64 -2)
  store ptr %6088, ptr %MEMORY, align 8
  %6089 = load i64, ptr %NEXT_PC, align 8
  store i64 %6089, ptr %PC, align 8
  %6090 = add i64 %6089, 4
  store i64 %6090, ptr %NEXT_PC, align 8
  %6091 = load i8, ptr %R8B, align 1
  %6092 = zext i8 %6091 to i64
  %6093 = load ptr, ptr %MEMORY, align 8
  %6094 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6093, ptr %state, ptr %R8, i64 %6092)
  store ptr %6094, ptr %MEMORY, align 8
  %6095 = load i64, ptr %NEXT_PC, align 8
  store i64 %6095, ptr %PC, align 8
  %6096 = add i64 %6095, 2
  store i64 %6096, ptr %NEXT_PC, align 8
  %6097 = load i32, ptr %EDX, align 4
  %6098 = zext i32 %6097 to i64
  %6099 = load i32, ptr %EDX, align 4
  %6100 = zext i32 %6099 to i64
  %6101 = load ptr, ptr %MEMORY, align 8
  %6102 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6101, ptr %state, i64 %6098, i64 %6100)
  store ptr %6102, ptr %MEMORY, align 8
  %6103 = load i64, ptr %NEXT_PC, align 8
  store i64 %6103, ptr %PC, align 8
  %6104 = add i64 %6103, 3
  store i64 %6104, ptr %NEXT_PC, align 8
  %6105 = load i8, ptr %AL, align 1
  %6106 = zext i8 %6105 to i64
  %6107 = load ptr, ptr %MEMORY, align 8
  %6108 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6107, ptr %state, ptr %RAX, i64 %6106)
  store ptr %6108, ptr %MEMORY, align 8
  %6109 = load i64, ptr %NEXT_PC, align 8
  store i64 %6109, ptr %PC, align 8
  %6110 = add i64 %6109, 4
  store i64 %6110, ptr %NEXT_PC, align 8
  %6111 = load i32, ptr %EAX, align 4
  %6112 = zext i32 %6111 to i64
  %6113 = load ptr, ptr %MEMORY, align 8
  %6114 = call ptr @_ZN12_GLOBAL__N_15CMOVZI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6113, ptr %state, ptr %R8, i64 %6112)
  store ptr %6114, ptr %MEMORY, align 8
  %6115 = load i64, ptr %NEXT_PC, align 8
  store i64 %6115, ptr %PC, align 8
  %6116 = add i64 %6115, 4
  store i64 %6116, ptr %NEXT_PC, align 8
  %6117 = load i64, ptr %RCX, align 8
  %6118 = add i64 %6117, 56
  %6119 = load i8, ptr %R8B, align 1
  %6120 = zext i8 %6119 to i64
  %6121 = load ptr, ptr %MEMORY, align 8
  %6122 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6121, ptr %state, i64 %6118, i64 %6120)
  store ptr %6122, ptr %MEMORY, align 8
  %6123 = load i64, ptr %NEXT_PC, align 8
  store i64 %6123, ptr %PC, align 8
  %6124 = add i64 %6123, 1
  store i64 %6124, ptr %NEXT_PC, align 8
  %6125 = load ptr, ptr %MEMORY, align 8
  %6126 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %6125, ptr %state, ptr %NEXT_PC)
  store ptr %6126, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880161:                                    ; No predecessors!
  %6127 = load i64, ptr %NEXT_PC, align 8
  store i64 %6127, ptr %PC, align 8
  %6128 = add i64 %6127, 1
  store i64 %6128, ptr %NEXT_PC, align 8
  %6129 = load ptr, ptr %MEMORY, align 8
  %6130 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6129, ptr %state, ptr undef)
  store ptr %6130, ptr %MEMORY, align 8
  %6131 = load i64, ptr %NEXT_PC, align 8
  store i64 %6131, ptr %PC, align 8
  %6132 = add i64 %6131, 1
  store i64 %6132, ptr %NEXT_PC, align 8
  %6133 = load ptr, ptr %MEMORY, align 8
  %6134 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6133, ptr %state, ptr undef)
  store ptr %6134, ptr %MEMORY, align 8
  %6135 = load i64, ptr %NEXT_PC, align 8
  store i64 %6135, ptr %PC, align 8
  %6136 = add i64 %6135, 1
  store i64 %6136, ptr %NEXT_PC, align 8
  %6137 = load ptr, ptr %MEMORY, align 8
  %6138 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6137, ptr %state, ptr undef)
  store ptr %6138, ptr %MEMORY, align 8
  %6139 = load i64, ptr %NEXT_PC, align 8
  store i64 %6139, ptr %PC, align 8
  %6140 = add i64 %6139, 1
  store i64 %6140, ptr %NEXT_PC, align 8
  %6141 = load ptr, ptr %MEMORY, align 8
  %6142 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6141, ptr %state, ptr undef)
  store ptr %6142, ptr %MEMORY, align 8
  %6143 = load i64, ptr %NEXT_PC, align 8
  store i64 %6143, ptr %PC, align 8
  %6144 = add i64 %6143, 1
  store i64 %6144, ptr %NEXT_PC, align 8
  %6145 = load ptr, ptr %MEMORY, align 8
  %6146 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6145, ptr %state, ptr undef)
  store ptr %6146, ptr %MEMORY, align 8
  %6147 = load i64, ptr %NEXT_PC, align 8
  store i64 %6147, ptr %PC, align 8
  %6148 = add i64 %6147, 1
  store i64 %6148, ptr %NEXT_PC, align 8
  %6149 = load ptr, ptr %MEMORY, align 8
  %6150 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6149, ptr %state, ptr undef)
  store ptr %6150, ptr %MEMORY, align 8
  %6151 = load i64, ptr %NEXT_PC, align 8
  store i64 %6151, ptr %PC, align 8
  %6152 = add i64 %6151, 1
  store i64 %6152, ptr %NEXT_PC, align 8
  %6153 = load ptr, ptr %MEMORY, align 8
  %6154 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6153, ptr %state, ptr undef)
  store ptr %6154, ptr %MEMORY, align 8
  %6155 = load i64, ptr %NEXT_PC, align 8
  store i64 %6155, ptr %PC, align 8
  %6156 = add i64 %6155, 1
  store i64 %6156, ptr %NEXT_PC, align 8
  %6157 = load ptr, ptr %MEMORY, align 8
  %6158 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6157, ptr %state, ptr undef)
  store ptr %6158, ptr %MEMORY, align 8
  %6159 = load i64, ptr %NEXT_PC, align 8
  store i64 %6159, ptr %PC, align 8
  %6160 = add i64 %6159, 1
  store i64 %6160, ptr %NEXT_PC, align 8
  %6161 = load ptr, ptr %MEMORY, align 8
  %6162 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6161, ptr %state, ptr undef)
  store ptr %6162, ptr %MEMORY, align 8
  %6163 = load i64, ptr %NEXT_PC, align 8
  store i64 %6163, ptr %PC, align 8
  %6164 = add i64 %6163, 1
  store i64 %6164, ptr %NEXT_PC, align 8
  %6165 = load ptr, ptr %MEMORY, align 8
  %6166 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6165, ptr %state, ptr undef)
  store ptr %6166, ptr %MEMORY, align 8
  %6167 = load i64, ptr %NEXT_PC, align 8
  store i64 %6167, ptr %PC, align 8
  %6168 = add i64 %6167, 1
  store i64 %6168, ptr %NEXT_PC, align 8
  %6169 = load ptr, ptr %MEMORY, align 8
  %6170 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6169, ptr %state, ptr undef)
  store ptr %6170, ptr %MEMORY, align 8
  %6171 = load i64, ptr %NEXT_PC, align 8
  store i64 %6171, ptr %PC, align 8
  %6172 = add i64 %6171, 1
  store i64 %6172, ptr %NEXT_PC, align 8
  %6173 = load ptr, ptr %MEMORY, align 8
  %6174 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6173, ptr %state, ptr undef)
  store ptr %6174, ptr %MEMORY, align 8
  %6175 = load i64, ptr %NEXT_PC, align 8
  store i64 %6175, ptr %PC, align 8
  %6176 = add i64 %6175, 1
  store i64 %6176, ptr %NEXT_PC, align 8
  %6177 = load ptr, ptr %MEMORY, align 8
  %6178 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6177, ptr %state, ptr undef)
  store ptr %6178, ptr %MEMORY, align 8
  %6179 = load i64, ptr %NEXT_PC, align 8
  store i64 %6179, ptr %PC, align 8
  %6180 = add i64 %6179, 1
  store i64 %6180, ptr %NEXT_PC, align 8
  %6181 = load ptr, ptr %MEMORY, align 8
  %6182 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6181, ptr %state, ptr undef)
  store ptr %6182, ptr %MEMORY, align 8
  %6183 = load i64, ptr %NEXT_PC, align 8
  store i64 %6183, ptr %PC, align 8
  %6184 = add i64 %6183, 1
  store i64 %6184, ptr %NEXT_PC, align 8
  %6185 = load ptr, ptr %MEMORY, align 8
  %6186 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6185, ptr %state, ptr undef)
  store ptr %6186, ptr %MEMORY, align 8
  %6187 = load i64, ptr %NEXT_PC, align 8
  store i64 %6187, ptr %PC, align 8
  %6188 = add i64 %6187, 5
  store i64 %6188, ptr %NEXT_PC, align 8
  %6189 = load i64, ptr %RCX, align 8
  %6190 = add i64 %6189, 56
  %6191 = load ptr, ptr %MEMORY, align 8
  %6192 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %6191, ptr %state, ptr %R8, i64 %6190)
  store ptr %6192, ptr %MEMORY, align 8
  %6193 = load i64, ptr %NEXT_PC, align 8
  store i64 %6193, ptr %PC, align 8
  %6194 = add i64 %6193, 4
  store i64 %6194, ptr %NEXT_PC, align 8
  %6195 = load i8, ptr %R8B, align 1
  %6196 = zext i8 %6195 to i64
  %6197 = load ptr, ptr %MEMORY, align 8
  %6198 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6197, ptr %state, ptr %RAX, i64 %6196)
  store ptr %6198, ptr %MEMORY, align 8
  %6199 = load i64, ptr %NEXT_PC, align 8
  store i64 %6199, ptr %PC, align 8
  %6200 = add i64 %6199, 4
  store i64 %6200, ptr %NEXT_PC, align 8
  %6201 = load i8, ptr %R8B, align 1
  %6202 = zext i8 %6201 to i64
  %6203 = load ptr, ptr %MEMORY, align 8
  %6204 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %6203, ptr %state, ptr %R8B, i64 %6202, i64 2)
  store ptr %6204, ptr %MEMORY, align 8
  %6205 = load i64, ptr %NEXT_PC, align 8
  store i64 %6205, ptr %PC, align 8
  %6206 = add i64 %6205, 2
  store i64 %6206, ptr %NEXT_PC, align 8
  %6207 = load i8, ptr %AL, align 1
  %6208 = zext i8 %6207 to i64
  %6209 = load ptr, ptr %MEMORY, align 8
  %6210 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %6209, ptr %state, ptr %AL, i64 %6208, i64 -3)
  store ptr %6210, ptr %MEMORY, align 8
  %6211 = load i64, ptr %NEXT_PC, align 8
  store i64 %6211, ptr %PC, align 8
  %6212 = add i64 %6211, 4
  store i64 %6212, ptr %NEXT_PC, align 8
  %6213 = load i8, ptr %R8B, align 1
  %6214 = zext i8 %6213 to i64
  %6215 = load ptr, ptr %MEMORY, align 8
  %6216 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6215, ptr %state, ptr %R8, i64 %6214)
  store ptr %6216, ptr %MEMORY, align 8
  %6217 = load i64, ptr %NEXT_PC, align 8
  store i64 %6217, ptr %PC, align 8
  %6218 = add i64 %6217, 2
  store i64 %6218, ptr %NEXT_PC, align 8
  %6219 = load i32, ptr %EDX, align 4
  %6220 = zext i32 %6219 to i64
  %6221 = load i32, ptr %EDX, align 4
  %6222 = zext i32 %6221 to i64
  %6223 = load ptr, ptr %MEMORY, align 8
  %6224 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6223, ptr %state, i64 %6220, i64 %6222)
  store ptr %6224, ptr %MEMORY, align 8
  %6225 = load i64, ptr %NEXT_PC, align 8
  store i64 %6225, ptr %PC, align 8
  %6226 = add i64 %6225, 3
  store i64 %6226, ptr %NEXT_PC, align 8
  %6227 = load i8, ptr %AL, align 1
  %6228 = zext i8 %6227 to i64
  %6229 = load ptr, ptr %MEMORY, align 8
  %6230 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6229, ptr %state, ptr %RAX, i64 %6228)
  store ptr %6230, ptr %MEMORY, align 8
  %6231 = load i64, ptr %NEXT_PC, align 8
  store i64 %6231, ptr %PC, align 8
  %6232 = add i64 %6231, 4
  store i64 %6232, ptr %NEXT_PC, align 8
  %6233 = load i32, ptr %EAX, align 4
  %6234 = zext i32 %6233 to i64
  %6235 = load ptr, ptr %MEMORY, align 8
  %6236 = call ptr @_ZN12_GLOBAL__N_15CMOVZI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6235, ptr %state, ptr %R8, i64 %6234)
  store ptr %6236, ptr %MEMORY, align 8
  %6237 = load i64, ptr %NEXT_PC, align 8
  store i64 %6237, ptr %PC, align 8
  %6238 = add i64 %6237, 4
  store i64 %6238, ptr %NEXT_PC, align 8
  %6239 = load i64, ptr %RCX, align 8
  %6240 = add i64 %6239, 56
  %6241 = load i8, ptr %R8B, align 1
  %6242 = zext i8 %6241 to i64
  %6243 = load ptr, ptr %MEMORY, align 8
  %6244 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6243, ptr %state, i64 %6240, i64 %6242)
  store ptr %6244, ptr %MEMORY, align 8
  %6245 = load i64, ptr %NEXT_PC, align 8
  store i64 %6245, ptr %PC, align 8
  %6246 = add i64 %6245, 1
  store i64 %6246, ptr %NEXT_PC, align 8
  %6247 = load ptr, ptr %MEMORY, align 8
  %6248 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %6247, ptr %state, ptr %NEXT_PC)
  store ptr %6248, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880209:                                    ; No predecessors!
  %6249 = load i64, ptr %NEXT_PC, align 8
  store i64 %6249, ptr %PC, align 8
  %6250 = add i64 %6249, 1
  store i64 %6250, ptr %NEXT_PC, align 8
  %6251 = load ptr, ptr %MEMORY, align 8
  %6252 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6251, ptr %state, ptr undef)
  store ptr %6252, ptr %MEMORY, align 8
  %6253 = load i64, ptr %NEXT_PC, align 8
  store i64 %6253, ptr %PC, align 8
  %6254 = add i64 %6253, 1
  store i64 %6254, ptr %NEXT_PC, align 8
  %6255 = load ptr, ptr %MEMORY, align 8
  %6256 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6255, ptr %state, ptr undef)
  store ptr %6256, ptr %MEMORY, align 8
  %6257 = load i64, ptr %NEXT_PC, align 8
  store i64 %6257, ptr %PC, align 8
  %6258 = add i64 %6257, 1
  store i64 %6258, ptr %NEXT_PC, align 8
  %6259 = load ptr, ptr %MEMORY, align 8
  %6260 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6259, ptr %state, ptr undef)
  store ptr %6260, ptr %MEMORY, align 8
  %6261 = load i64, ptr %NEXT_PC, align 8
  store i64 %6261, ptr %PC, align 8
  %6262 = add i64 %6261, 1
  store i64 %6262, ptr %NEXT_PC, align 8
  %6263 = load ptr, ptr %MEMORY, align 8
  %6264 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6263, ptr %state, ptr undef)
  store ptr %6264, ptr %MEMORY, align 8
  %6265 = load i64, ptr %NEXT_PC, align 8
  store i64 %6265, ptr %PC, align 8
  %6266 = add i64 %6265, 1
  store i64 %6266, ptr %NEXT_PC, align 8
  %6267 = load ptr, ptr %MEMORY, align 8
  %6268 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6267, ptr %state, ptr undef)
  store ptr %6268, ptr %MEMORY, align 8
  %6269 = load i64, ptr %NEXT_PC, align 8
  store i64 %6269, ptr %PC, align 8
  %6270 = add i64 %6269, 1
  store i64 %6270, ptr %NEXT_PC, align 8
  %6271 = load ptr, ptr %MEMORY, align 8
  %6272 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6271, ptr %state, ptr undef)
  store ptr %6272, ptr %MEMORY, align 8
  %6273 = load i64, ptr %NEXT_PC, align 8
  store i64 %6273, ptr %PC, align 8
  %6274 = add i64 %6273, 1
  store i64 %6274, ptr %NEXT_PC, align 8
  %6275 = load ptr, ptr %MEMORY, align 8
  %6276 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6275, ptr %state, ptr undef)
  store ptr %6276, ptr %MEMORY, align 8
  %6277 = load i64, ptr %NEXT_PC, align 8
  store i64 %6277, ptr %PC, align 8
  %6278 = add i64 %6277, 1
  store i64 %6278, ptr %NEXT_PC, align 8
  %6279 = load ptr, ptr %MEMORY, align 8
  %6280 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6279, ptr %state, ptr undef)
  store ptr %6280, ptr %MEMORY, align 8
  %6281 = load i64, ptr %NEXT_PC, align 8
  store i64 %6281, ptr %PC, align 8
  %6282 = add i64 %6281, 1
  store i64 %6282, ptr %NEXT_PC, align 8
  %6283 = load ptr, ptr %MEMORY, align 8
  %6284 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6283, ptr %state, ptr undef)
  store ptr %6284, ptr %MEMORY, align 8
  %6285 = load i64, ptr %NEXT_PC, align 8
  store i64 %6285, ptr %PC, align 8
  %6286 = add i64 %6285, 1
  store i64 %6286, ptr %NEXT_PC, align 8
  %6287 = load ptr, ptr %MEMORY, align 8
  %6288 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6287, ptr %state, ptr undef)
  store ptr %6288, ptr %MEMORY, align 8
  %6289 = load i64, ptr %NEXT_PC, align 8
  store i64 %6289, ptr %PC, align 8
  %6290 = add i64 %6289, 1
  store i64 %6290, ptr %NEXT_PC, align 8
  %6291 = load ptr, ptr %MEMORY, align 8
  %6292 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6291, ptr %state, ptr undef)
  store ptr %6292, ptr %MEMORY, align 8
  %6293 = load i64, ptr %NEXT_PC, align 8
  store i64 %6293, ptr %PC, align 8
  %6294 = add i64 %6293, 1
  store i64 %6294, ptr %NEXT_PC, align 8
  %6295 = load ptr, ptr %MEMORY, align 8
  %6296 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6295, ptr %state, ptr undef)
  store ptr %6296, ptr %MEMORY, align 8
  %6297 = load i64, ptr %NEXT_PC, align 8
  store i64 %6297, ptr %PC, align 8
  %6298 = add i64 %6297, 1
  store i64 %6298, ptr %NEXT_PC, align 8
  %6299 = load ptr, ptr %MEMORY, align 8
  %6300 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6299, ptr %state, ptr undef)
  store ptr %6300, ptr %MEMORY, align 8
  %6301 = load i64, ptr %NEXT_PC, align 8
  store i64 %6301, ptr %PC, align 8
  %6302 = add i64 %6301, 1
  store i64 %6302, ptr %NEXT_PC, align 8
  %6303 = load ptr, ptr %MEMORY, align 8
  %6304 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6303, ptr %state, ptr undef)
  store ptr %6304, ptr %MEMORY, align 8
  %6305 = load i64, ptr %NEXT_PC, align 8
  store i64 %6305, ptr %PC, align 8
  %6306 = add i64 %6305, 1
  store i64 %6306, ptr %NEXT_PC, align 8
  %6307 = load ptr, ptr %MEMORY, align 8
  %6308 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %6307, ptr %state, ptr undef)
  store ptr %6308, ptr %MEMORY, align 8
  %6309 = load i64, ptr %NEXT_PC, align 8
  store i64 %6309, ptr %PC, align 8
  %6310 = add i64 %6309, 5
  store i64 %6310, ptr %NEXT_PC, align 8
  %6311 = load i64, ptr %RSP, align 8
  %6312 = add i64 %6311, 8
  %6313 = load i64, ptr %RBX, align 8
  %6314 = load ptr, ptr %MEMORY, align 8
  %6315 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6314, ptr %state, i64 %6312, i64 %6313)
  store ptr %6315, ptr %MEMORY, align 8
  %6316 = load i64, ptr %NEXT_PC, align 8
  store i64 %6316, ptr %PC, align 8
  %6317 = add i64 %6316, 5
  store i64 %6317, ptr %NEXT_PC, align 8
  %6318 = load i64, ptr %RSP, align 8
  %6319 = add i64 %6318, 32
  %6320 = load i64, ptr %R9, align 8
  %6321 = load ptr, ptr %MEMORY, align 8
  %6322 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6321, ptr %state, i64 %6319, i64 %6320)
  store ptr %6322, ptr %MEMORY, align 8
  %6323 = load i64, ptr %NEXT_PC, align 8
  store i64 %6323, ptr %PC, align 8
  %6324 = add i64 %6323, 4
  store i64 %6324, ptr %NEXT_PC, align 8
  %6325 = load i64, ptr %RSP, align 8
  %6326 = add i64 %6325, 16
  %6327 = load i32, ptr %EDX, align 4
  %6328 = zext i32 %6327 to i64
  %6329 = load ptr, ptr %MEMORY, align 8
  %6330 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6329, ptr %state, i64 %6326, i64 %6328)
  store ptr %6330, ptr %MEMORY, align 8
  %6331 = load i64, ptr %NEXT_PC, align 8
  store i64 %6331, ptr %PC, align 8
  %6332 = add i64 %6331, 1
  store i64 %6332, ptr %NEXT_PC, align 8
  %6333 = load i64, ptr %RBP, align 8
  %6334 = load ptr, ptr %MEMORY, align 8
  %6335 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %6334, ptr %state, i64 %6333)
  store ptr %6335, ptr %MEMORY, align 8
  %6336 = load i64, ptr %NEXT_PC, align 8
  store i64 %6336, ptr %PC, align 8
  %6337 = add i64 %6336, 1
  store i64 %6337, ptr %NEXT_PC, align 8
  %6338 = load i64, ptr %RSI, align 8
  %6339 = load ptr, ptr %MEMORY, align 8
  %6340 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %6339, ptr %state, i64 %6338)
  store ptr %6340, ptr %MEMORY, align 8
  %6341 = load i64, ptr %NEXT_PC, align 8
  store i64 %6341, ptr %PC, align 8
  %6342 = add i64 %6341, 1
  store i64 %6342, ptr %NEXT_PC, align 8
  %6343 = load i64, ptr %RDI, align 8
  %6344 = load ptr, ptr %MEMORY, align 8
  %6345 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %6344, ptr %state, i64 %6343)
  store ptr %6345, ptr %MEMORY, align 8
  %6346 = load i64, ptr %NEXT_PC, align 8
  store i64 %6346, ptr %PC, align 8
  %6347 = add i64 %6346, 2
  store i64 %6347, ptr %NEXT_PC, align 8
  %6348 = load i64, ptr %R12, align 8
  %6349 = load ptr, ptr %MEMORY, align 8
  %6350 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %6349, ptr %state, i64 %6348)
  store ptr %6350, ptr %MEMORY, align 8
  %6351 = load i64, ptr %NEXT_PC, align 8
  store i64 %6351, ptr %PC, align 8
  %6352 = add i64 %6351, 2
  store i64 %6352, ptr %NEXT_PC, align 8
  %6353 = load i64, ptr %R13, align 8
  %6354 = load ptr, ptr %MEMORY, align 8
  %6355 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %6354, ptr %state, i64 %6353)
  store ptr %6355, ptr %MEMORY, align 8
  %6356 = load i64, ptr %NEXT_PC, align 8
  store i64 %6356, ptr %PC, align 8
  %6357 = add i64 %6356, 2
  store i64 %6357, ptr %NEXT_PC, align 8
  %6358 = load i64, ptr %R14, align 8
  %6359 = load ptr, ptr %MEMORY, align 8
  %6360 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %6359, ptr %state, i64 %6358)
  store ptr %6360, ptr %MEMORY, align 8
  %6361 = load i64, ptr %NEXT_PC, align 8
  store i64 %6361, ptr %PC, align 8
  %6362 = add i64 %6361, 2
  store i64 %6362, ptr %NEXT_PC, align 8
  %6363 = load i64, ptr %R15, align 8
  %6364 = load ptr, ptr %MEMORY, align 8
  %6365 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %6364, ptr %state, i64 %6363)
  store ptr %6365, ptr %MEMORY, align 8
  %6366 = load i64, ptr %NEXT_PC, align 8
  store i64 %6366, ptr %PC, align 8
  %6367 = add i64 %6366, 4
  store i64 %6367, ptr %NEXT_PC, align 8
  %6368 = load i64, ptr %RSP, align 8
  %6369 = load ptr, ptr %MEMORY, align 8
  %6370 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %6369, ptr %state, ptr %RSP, i64 %6368, i64 96)
  store ptr %6370, ptr %MEMORY, align 8
  %6371 = load i64, ptr %NEXT_PC, align 8
  store i64 %6371, ptr %PC, align 8
  %6372 = add i64 %6371, 8
  store i64 %6372, ptr %NEXT_PC, align 8
  %6373 = load i64, ptr %RSP, align 8
  %6374 = add i64 %6373, 192
  %6375 = load ptr, ptr %MEMORY, align 8
  %6376 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %6375, ptr %state, ptr %R14, i64 %6374)
  store ptr %6376, ptr %MEMORY, align 8
  %6377 = load i64, ptr %NEXT_PC, align 8
  store i64 %6377, ptr %PC, align 8
  %6378 = add i64 %6377, 3
  store i64 %6378, ptr %NEXT_PC, align 8
  %6379 = load i64, ptr %R9, align 8
  %6380 = load ptr, ptr %MEMORY, align 8
  %6381 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6380, ptr %state, ptr %R15, i64 %6379)
  store ptr %6381, ptr %MEMORY, align 8
  %6382 = load i64, ptr %NEXT_PC, align 8
  store i64 %6382, ptr %PC, align 8
  %6383 = add i64 %6382, 3
  store i64 %6383, ptr %NEXT_PC, align 8
  %6384 = load i64, ptr %R8, align 8
  %6385 = load ptr, ptr %MEMORY, align 8
  %6386 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6385, ptr %state, ptr %R12, i64 %6384)
  store ptr %6386, ptr %MEMORY, align 8
  %6387 = load i64, ptr %NEXT_PC, align 8
  store i64 %6387, ptr %PC, align 8
  %6388 = add i64 %6387, 3
  store i64 %6388, ptr %NEXT_PC, align 8
  %6389 = load i32, ptr %EDX, align 4
  %6390 = zext i32 %6389 to i64
  %6391 = load ptr, ptr %MEMORY, align 8
  %6392 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6391, ptr %state, ptr %R13, i64 %6390)
  store ptr %6392, ptr %MEMORY, align 8
  %6393 = load i64, ptr %NEXT_PC, align 8
  store i64 %6393, ptr %PC, align 8
  %6394 = add i64 %6393, 3
  store i64 %6394, ptr %NEXT_PC, align 8
  %6395 = load i64, ptr %RCX, align 8
  %6396 = load ptr, ptr %MEMORY, align 8
  %6397 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6396, ptr %state, ptr %RSI, i64 %6395)
  store ptr %6397, ptr %MEMORY, align 8
  %6398 = load i64, ptr %NEXT_PC, align 8
  store i64 %6398, ptr %PC, align 8
  %6399 = add i64 %6398, 6
  store i64 %6399, ptr %NEXT_PC, align 8
  %6400 = load i32, ptr %EDX, align 4
  %6401 = zext i32 %6400 to i64
  %6402 = load ptr, ptr %MEMORY, align 8
  %6403 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %6402, ptr %state, i64 %6401, i64 1073741825)
  store ptr %6403, ptr %MEMORY, align 8
  %6404 = load i64, ptr %NEXT_PC, align 8
  store i64 %6404, ptr %PC, align 8
  %6405 = add i64 %6404, 6
  store i64 %6405, ptr %NEXT_PC, align 8
  %6406 = load i64, ptr %NEXT_PC, align 8
  %6407 = add i64 %6406, 861
  %6408 = load i64, ptr %NEXT_PC, align 8
  %6409 = load ptr, ptr %MEMORY, align 8
  %6410 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6409, ptr %state, ptr %BRANCH_TAKEN, i64 %6407, i64 %6408, ptr %NEXT_PC)
  store ptr %6410, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880285:                                    ; No predecessors!
  %6411 = load i64, ptr %NEXT_PC, align 8
  store i64 %6411, ptr %PC, align 8
  %6412 = add i64 %6411, 7
  store i64 %6412, ptr %NEXT_PC, align 8
  %6413 = load i64, ptr %R14, align 8
  %6414 = add i64 %6413, 256
  %6415 = load ptr, ptr %MEMORY, align 8
  %6416 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6415, ptr %state, ptr %R8, i64 %6414)
  store ptr %6416, ptr %MEMORY, align 8
  %6417 = load i64, ptr %NEXT_PC, align 8
  store i64 %6417, ptr %PC, align 8
  %6418 = add i64 %6417, 3
  store i64 %6418, ptr %NEXT_PC, align 8
  %6419 = load i32, ptr %R8D, align 4
  %6420 = zext i32 %6419 to i64
  %6421 = load i32, ptr %R8D, align 4
  %6422 = zext i32 %6421 to i64
  %6423 = load ptr, ptr %MEMORY, align 8
  %6424 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6423, ptr %state, i64 %6420, i64 %6422)
  store ptr %6424, ptr %MEMORY, align 8
  %6425 = load i64, ptr %NEXT_PC, align 8
  store i64 %6425, ptr %PC, align 8
  %6426 = add i64 %6425, 6
  store i64 %6426, ptr %NEXT_PC, align 8
  %6427 = load i64, ptr %NEXT_PC, align 8
  %6428 = add i64 %6427, 185
  %6429 = load i64, ptr %NEXT_PC, align 8
  %6430 = load ptr, ptr %MEMORY, align 8
  %6431 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6430, ptr %state, ptr %BRANCH_TAKEN, i64 %6428, i64 %6429, ptr %NEXT_PC)
  store ptr %6431, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880486, label %bb_5389880301

bb_5389880301:                                    ; preds = %bb_5389880285
  %6432 = load i64, ptr %NEXT_PC, align 8
  store i64 %6432, ptr %PC, align 8
  %6433 = add i64 %6432, 3
  store i64 %6433, ptr %NEXT_PC, align 8
  %6434 = load i64, ptr %R12, align 8
  %6435 = load i64, ptr %R12, align 8
  %6436 = load ptr, ptr %MEMORY, align 8
  %6437 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6436, ptr %state, i64 %6434, i64 %6435)
  store ptr %6437, ptr %MEMORY, align 8
  %6438 = load i64, ptr %NEXT_PC, align 8
  store i64 %6438, ptr %PC, align 8
  %6439 = add i64 %6438, 6
  store i64 %6439, ptr %NEXT_PC, align 8
  %6440 = load i64, ptr %NEXT_PC, align 8
  %6441 = add i64 %6440, 836
  %6442 = load i64, ptr %NEXT_PC, align 8
  %6443 = load ptr, ptr %MEMORY, align 8
  %6444 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6443, ptr %state, ptr %BRANCH_TAKEN, i64 %6441, i64 %6442, ptr %NEXT_PC)
  store ptr %6444, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880310:                                    ; No predecessors!
  %6445 = load i64, ptr %NEXT_PC, align 8
  store i64 %6445, ptr %PC, align 8
  %6446 = add i64 %6445, 3
  store i64 %6446, ptr %NEXT_PC, align 8
  %6447 = load i64, ptr %RCX, align 8
  %6448 = load i64, ptr %RCX, align 8
  %6449 = load ptr, ptr %MEMORY, align 8
  %6450 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6449, ptr %state, i64 %6447, i64 %6448)
  store ptr %6450, ptr %MEMORY, align 8
  %6451 = load i64, ptr %NEXT_PC, align 8
  store i64 %6451, ptr %PC, align 8
  %6452 = add i64 %6451, 2
  store i64 %6452, ptr %NEXT_PC, align 8
  %6453 = load i64, ptr %NEXT_PC, align 8
  %6454 = add i64 %6453, 8
  %6455 = load i64, ptr %NEXT_PC, align 8
  %6456 = load ptr, ptr %MEMORY, align 8
  %6457 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6456, ptr %state, ptr %BRANCH_TAKEN, i64 %6454, i64 %6455, ptr %NEXT_PC)
  store ptr %6457, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880323, label %bb_5389880315

bb_5389880315:                                    ; preds = %bb_5389880310
  %6458 = load i64, ptr %NEXT_PC, align 8
  store i64 %6458, ptr %PC, align 8
  %6459 = add i64 %6458, 4
  store i64 %6459, ptr %NEXT_PC, align 8
  %6460 = load i64, ptr %RCX, align 8
  %6461 = add i64 %6460, 48
  %6462 = load ptr, ptr %MEMORY, align 8
  %6463 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %6462, ptr %state, ptr %RAX, i64 %6461)
  store ptr %6463, ptr %MEMORY, align 8
  %6464 = load i64, ptr %NEXT_PC, align 8
  store i64 %6464, ptr %PC, align 8
  %6465 = add i64 %6464, 2
  store i64 %6465, ptr %NEXT_PC, align 8
  %6466 = load i64, ptr %RCX, align 8
  %6467 = load i64, ptr %RCX, align 8
  %6468 = load ptr, ptr %MEMORY, align 8
  %6469 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6468, ptr %state, i64 %6466, i64 %6467)
  store ptr %6469, ptr %MEMORY, align 8
  %6470 = load i64, ptr %NEXT_PC, align 8
  store i64 %6470, ptr %PC, align 8
  %6471 = add i64 %6470, 2
  store i64 %6471, ptr %NEXT_PC, align 8
  %6472 = load i64, ptr %RAX, align 8
  %6473 = load i64, ptr %RAX, align 8
  %6474 = load ptr, ptr %MEMORY, align 8
  %6475 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6474, ptr %state, i64 %6472, i64 %6473)
  store ptr %6475, ptr %MEMORY, align 8
  br label %bb_5389880323

bb_5389880323:                                    ; preds = %bb_5389880315, %bb_5389880310
  %6476 = load i64, ptr %NEXT_PC, align 8
  store i64 %6476, ptr %PC, align 8
  %6477 = add i64 %6476, 5
  store i64 %6477, ptr %NEXT_PC, align 8
  %6478 = load i64, ptr %R12, align 8
  %6479 = add i64 %6478, 8
  %6480 = load ptr, ptr %MEMORY, align 8
  %6481 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2MnIjElEEP6MemoryS6_R5StateT_T0_(ptr %6480, ptr %state, ptr %RCX, i64 %6479)
  store ptr %6481, ptr %MEMORY, align 8
  %6482 = load i64, ptr %NEXT_PC, align 8
  store i64 %6482, ptr %PC, align 8
  %6483 = add i64 %6482, 5
  store i64 %6483, ptr %NEXT_PC, align 8
  %6484 = load i64, ptr %R12, align 8
  %6485 = add i64 %6484, 12
  %6486 = load ptr, ptr %MEMORY, align 8
  %6487 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6486, ptr %state, ptr %R8, i64 %6485)
  store ptr %6487, ptr %MEMORY, align 8
  %6488 = load i64, ptr %NEXT_PC, align 8
  store i64 %6488, ptr %PC, align 8
  %6489 = add i64 %6488, 3
  store i64 %6489, ptr %NEXT_PC, align 8
  %6490 = load i32, ptr %ECX, align 4
  %6491 = zext i32 %6490 to i64
  %6492 = load i32, ptr %R8D, align 4
  %6493 = zext i32 %6492 to i64
  %6494 = load ptr, ptr %MEMORY, align 8
  %6495 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6494, ptr %state, i64 %6491, i64 %6493)
  store ptr %6495, ptr %MEMORY, align 8
  %6496 = load i64, ptr %NEXT_PC, align 8
  store i64 %6496, ptr %PC, align 8
  %6497 = add i64 %6496, 2
  store i64 %6497, ptr %NEXT_PC, align 8
  %6498 = load i64, ptr %NEXT_PC, align 8
  %6499 = add i64 %6498, 31
  %6500 = load i64, ptr %NEXT_PC, align 8
  %6501 = load ptr, ptr %MEMORY, align 8
  %6502 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6501, ptr %state, ptr %BRANCH_TAKEN, i64 %6499, i64 %6500, ptr %NEXT_PC)
  store ptr %6502, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880369, label %bb_5389880338

bb_5389880338:                                    ; preds = %bb_5389880323
  %6503 = load i64, ptr %NEXT_PC, align 8
  store i64 %6503, ptr %PC, align 8
  %6504 = add i64 %6503, 4
  store i64 %6504, ptr %NEXT_PC, align 8
  %6505 = load i64, ptr %R12, align 8
  %6506 = load ptr, ptr %MEMORY, align 8
  %6507 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %6506, ptr %state, ptr %RAX, i64 %6505)
  store ptr %6507, ptr %MEMORY, align 8
  %6508 = load i64, ptr %NEXT_PC, align 8
  store i64 %6508, ptr %PC, align 8
  %6509 = add i64 %6508, 4
  store i64 %6509, ptr %NEXT_PC, align 8
  %6510 = load i64, ptr %RAX, align 8
  %6511 = load i64, ptr %RCX, align 8
  %6512 = mul i64 %6511, 8
  %6513 = add i64 %6510, %6512
  %6514 = load ptr, ptr %MEMORY, align 8
  %6515 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %6514, ptr %state, ptr %RDX, i64 %6513)
  store ptr %6515, ptr %MEMORY, align 8
  %6516 = load i64, ptr %NEXT_PC, align 8
  store i64 %6516, ptr %PC, align 8
  %6517 = add i64 %6516, 3
  store i64 %6517, ptr %NEXT_PC, align 8
  %6518 = load i64, ptr %RSI, align 8
  %6519 = load i64, ptr %RSI, align 8
  %6520 = load ptr, ptr %MEMORY, align 8
  %6521 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6520, ptr %state, i64 %6518, i64 %6519)
  store ptr %6521, ptr %MEMORY, align 8
  %6522 = load i64, ptr %NEXT_PC, align 8
  store i64 %6522, ptr %PC, align 8
  %6523 = add i64 %6522, 2
  store i64 %6523, ptr %NEXT_PC, align 8
  %6524 = load i64, ptr %NEXT_PC, align 8
  %6525 = add i64 %6524, 8
  %6526 = load i64, ptr %NEXT_PC, align 8
  %6527 = load ptr, ptr %MEMORY, align 8
  %6528 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6527, ptr %state, ptr %BRANCH_TAKEN, i64 %6525, i64 %6526, ptr %NEXT_PC)
  store ptr %6528, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880359, label %bb_5389880351

bb_5389880351:                                    ; preds = %bb_5389880338
  %6529 = load i64, ptr %NEXT_PC, align 8
  store i64 %6529, ptr %PC, align 8
  %6530 = add i64 %6529, 4
  store i64 %6530, ptr %NEXT_PC, align 8
  %6531 = load i64, ptr %RSI, align 8
  %6532 = add i64 %6531, 48
  %6533 = load ptr, ptr %MEMORY, align 8
  %6534 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %6533, ptr %state, ptr %RAX, i64 %6532)
  store ptr %6534, ptr %MEMORY, align 8
  %6535 = load i64, ptr %NEXT_PC, align 8
  store i64 %6535, ptr %PC, align 8
  %6536 = add i64 %6535, 2
  store i64 %6536, ptr %NEXT_PC, align 8
  %6537 = load i64, ptr %RSI, align 8
  %6538 = load i64, ptr %RSI, align 8
  %6539 = load ptr, ptr %MEMORY, align 8
  %6540 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6539, ptr %state, i64 %6537, i64 %6538)
  store ptr %6540, ptr %MEMORY, align 8
  %6541 = load i64, ptr %NEXT_PC, align 8
  store i64 %6541, ptr %PC, align 8
  %6542 = add i64 %6541, 2
  store i64 %6542, ptr %NEXT_PC, align 8
  %6543 = load i64, ptr %RAX, align 8
  %6544 = load i64, ptr %RAX, align 8
  %6545 = load ptr, ptr %MEMORY, align 8
  %6546 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6545, ptr %state, i64 %6543, i64 %6544)
  store ptr %6546, ptr %MEMORY, align 8
  br label %bb_5389880359

bb_5389880359:                                    ; preds = %bb_5389880351, %bb_5389880338
  %6547 = load i64, ptr %NEXT_PC, align 8
  store i64 %6547, ptr %PC, align 8
  %6548 = add i64 %6547, 3
  store i64 %6548, ptr %NEXT_PC, align 8
  %6549 = load i64, ptr %RDX, align 8
  %6550 = load i64, ptr %RSI, align 8
  %6551 = load ptr, ptr %MEMORY, align 8
  %6552 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6551, ptr %state, i64 %6549, i64 %6550)
  store ptr %6552, ptr %MEMORY, align 8
  %6553 = load i64, ptr %NEXT_PC, align 8
  store i64 %6553, ptr %PC, align 8
  %6554 = add i64 %6553, 5
  store i64 %6554, ptr %NEXT_PC, align 8
  %6555 = load i64, ptr %R12, align 8
  %6556 = add i64 %6555, 8
  %6557 = load i64, ptr %R12, align 8
  %6558 = add i64 %6557, 8
  %6559 = load ptr, ptr %MEMORY, align 8
  %6560 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6559, ptr %state, i64 %6556, i64 %6558)
  store ptr %6560, ptr %MEMORY, align 8
  %6561 = load i64, ptr %NEXT_PC, align 8
  store i64 %6561, ptr %PC, align 8
  %6562 = add i64 %6561, 2
  store i64 %6562, ptr %NEXT_PC, align 8
  %6563 = load i64, ptr %NEXT_PC, align 8
  %6564 = add i64 %6563, 100
  %6565 = load ptr, ptr %MEMORY, align 8
  %6566 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %6565, ptr %state, i64 %6564, ptr %NEXT_PC)
  store ptr %6566, ptr %MEMORY, align 8
  br label %bb_5389880469

bb_5389880369:                                    ; preds = %bb_5389880323
  %6567 = load i64, ptr %NEXT_PC, align 8
  store i64 %6567, ptr %PC, align 8
  %6568 = add i64 %6567, 4
  store i64 %6568, ptr %NEXT_PC, align 8
  %6569 = load i64, ptr %RCX, align 8
  %6570 = add i64 %6569, 1
  %6571 = load ptr, ptr %MEMORY, align 8
  %6572 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %6571, ptr %state, ptr %R9, i64 %6570)
  store ptr %6572, ptr %MEMORY, align 8
  %6573 = load i64, ptr %NEXT_PC, align 8
  store i64 %6573, ptr %PC, align 8
  %6574 = add i64 %6573, 3
  store i64 %6574, ptr %NEXT_PC, align 8
  %6575 = load i32, ptr %R9D, align 4
  %6576 = zext i32 %6575 to i64
  %6577 = load i32, ptr %R8D, align 4
  %6578 = zext i32 %6577 to i64
  %6579 = load ptr, ptr %MEMORY, align 8
  %6580 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6579, ptr %state, i64 %6576, i64 %6578)
  store ptr %6580, ptr %MEMORY, align 8
  %6581 = load i64, ptr %NEXT_PC, align 8
  store i64 %6581, ptr %PC, align 8
  %6582 = add i64 %6581, 2
  store i64 %6582, ptr %NEXT_PC, align 8
  %6583 = load i64, ptr %NEXT_PC, align 8
  %6584 = add i64 %6583, 56
  %6585 = load i64, ptr %NEXT_PC, align 8
  %6586 = load ptr, ptr %MEMORY, align 8
  %6587 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6586, ptr %state, ptr %BRANCH_TAKEN, i64 %6584, i64 %6585, ptr %NEXT_PC)
  store ptr %6587, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880434, label %bb_5389880378

bb_5389880378:                                    ; preds = %bb_5389880369
  %6588 = load i64, ptr %NEXT_PC, align 8
  store i64 %6588, ptr %PC, align 8
  %6589 = add i64 %6588, 2
  store i64 %6589, ptr %NEXT_PC, align 8
  %6590 = load i32, ptr %ECX, align 4
  %6591 = zext i32 %6590 to i64
  %6592 = load i32, ptr %ECX, align 4
  %6593 = zext i32 %6592 to i64
  %6594 = load ptr, ptr %MEMORY, align 8
  %6595 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6594, ptr %state, i64 %6591, i64 %6593)
  store ptr %6595, ptr %MEMORY, align 8
  %6596 = load i64, ptr %NEXT_PC, align 8
  store i64 %6596, ptr %PC, align 8
  %6597 = add i64 %6596, 2
  store i64 %6597, ptr %NEXT_PC, align 8
  %6598 = load i64, ptr %NEXT_PC, align 8
  %6599 = add i64 %6598, 30
  %6600 = load i64, ptr %NEXT_PC, align 8
  %6601 = load ptr, ptr %MEMORY, align 8
  %6602 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6601, ptr %state, ptr %BRANCH_TAKEN, i64 %6599, i64 %6600, ptr %NEXT_PC)
  store ptr %6602, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880412, label %bb_5389880382

bb_5389880382:                                    ; preds = %bb_5389880378
  %6603 = load i64, ptr %NEXT_PC, align 8
  store i64 %6603, ptr %PC, align 8
  %6604 = add i64 %6603, 3
  store i64 %6604, ptr %NEXT_PC, align 8
  %6605 = load i32, ptr %R8D, align 4
  %6606 = zext i32 %6605 to i64
  %6607 = load ptr, ptr %MEMORY, align 8
  %6608 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6607, ptr %state, ptr %RAX, i64 %6606)
  store ptr %6608, ptr %MEMORY, align 8
  %6609 = load i64, ptr %NEXT_PC, align 8
  store i64 %6609, ptr %PC, align 8
  %6610 = add i64 %6609, 1
  store i64 %6610, ptr %NEXT_PC, align 8
  %6611 = load ptr, ptr %MEMORY, align 8
  %6612 = call ptr @_ZN12_GLOBAL__N_17CDQ_EAXEP6MemoryR5State(ptr %6611, ptr %state)
  store ptr %6612, ptr %MEMORY, align 8
  %6613 = load i64, ptr %NEXT_PC, align 8
  store i64 %6613, ptr %PC, align 8
  %6614 = add i64 %6613, 2
  store i64 %6614, ptr %NEXT_PC, align 8
  %6615 = load i64, ptr %RAX, align 8
  %6616 = load i32, ptr %EDX, align 4
  %6617 = zext i32 %6616 to i64
  %6618 = load ptr, ptr %MEMORY, align 8
  %6619 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %6618, ptr %state, ptr %RAX, i64 %6615, i64 %6617)
  store ptr %6619, ptr %MEMORY, align 8
  %6620 = load i64, ptr %NEXT_PC, align 8
  store i64 %6620, ptr %PC, align 8
  %6621 = add i64 %6620, 2
  store i64 %6621, ptr %NEXT_PC, align 8
  %6622 = load i64, ptr %RAX, align 8
  %6623 = load ptr, ptr %MEMORY, align 8
  %6624 = call ptr @_ZN12_GLOBAL__N_13SARI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %6623, ptr %state, ptr %RAX, i64 %6622, i64 1)
  store ptr %6624, ptr %MEMORY, align 8
  %6625 = load i64, ptr %NEXT_PC, align 8
  store i64 %6625, ptr %PC, align 8
  %6626 = add i64 %6625, 4
  store i64 %6626, ptr %NEXT_PC, align 8
  %6627 = load i64, ptr %RAX, align 8
  %6628 = load i64, ptr %R8, align 8
  %6629 = mul i64 %6628, 1
  %6630 = add i64 %6627, %6629
  %6631 = load ptr, ptr %MEMORY, align 8
  %6632 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %6631, ptr %state, ptr %RDX, i64 %6630)
  store ptr %6632, ptr %MEMORY, align 8
  %6633 = load i64, ptr %NEXT_PC, align 8
  store i64 %6633, ptr %PC, align 8
  %6634 = add i64 %6633, 5
  store i64 %6634, ptr %NEXT_PC, align 8
  %6635 = load ptr, ptr %MEMORY, align 8
  %6636 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %6635, ptr %state, ptr %RAX, i64 8)
  store ptr %6636, ptr %MEMORY, align 8
  %6637 = load i64, ptr %NEXT_PC, align 8
  store i64 %6637, ptr %PC, align 8
  %6638 = add i64 %6637, 2
  store i64 %6638, ptr %NEXT_PC, align 8
  %6639 = load i32, ptr %ECX, align 4
  %6640 = zext i32 %6639 to i64
  %6641 = load i32, ptr %EDX, align 4
  %6642 = zext i32 %6641 to i64
  %6643 = load ptr, ptr %MEMORY, align 8
  %6644 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6643, ptr %state, i64 %6640, i64 %6642)
  store ptr %6644, ptr %MEMORY, align 8
  %6645 = load i64, ptr %NEXT_PC, align 8
  store i64 %6645, ptr %PC, align 8
  %6646 = add i64 %6645, 4
  store i64 %6646, ptr %NEXT_PC, align 8
  %6647 = load i32, ptr %R9D, align 4
  %6648 = zext i32 %6647 to i64
  %6649 = load ptr, ptr %MEMORY, align 8
  %6650 = call ptr @_ZN12_GLOBAL__N_16CMOVNLI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6649, ptr %state, ptr %RDX, i64 %6648)
  store ptr %6650, ptr %MEMORY, align 8
  %6651 = load i64, ptr %NEXT_PC, align 8
  store i64 %6651, ptr %PC, align 8
  %6652 = add i64 %6651, 2
  store i64 %6652, ptr %NEXT_PC, align 8
  %6653 = load i32, ptr %EDX, align 4
  %6654 = zext i32 %6653 to i64
  %6655 = load i32, ptr %EAX, align 4
  %6656 = zext i32 %6655 to i64
  %6657 = load ptr, ptr %MEMORY, align 8
  %6658 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6657, ptr %state, i64 %6654, i64 %6656)
  store ptr %6658, ptr %MEMORY, align 8
  %6659 = load i64, ptr %NEXT_PC, align 8
  store i64 %6659, ptr %PC, align 8
  %6660 = add i64 %6659, 3
  store i64 %6660, ptr %NEXT_PC, align 8
  %6661 = load i32, ptr %EAX, align 4
  %6662 = zext i32 %6661 to i64
  %6663 = load ptr, ptr %MEMORY, align 8
  %6664 = call ptr @_ZN12_GLOBAL__N_15CMOVLI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6663, ptr %state, ptr %RDX, i64 %6662)
  store ptr %6664, ptr %MEMORY, align 8
  %6665 = load i64, ptr %NEXT_PC, align 8
  store i64 %6665, ptr %PC, align 8
  %6666 = add i64 %6665, 2
  store i64 %6666, ptr %NEXT_PC, align 8
  %6667 = load i64, ptr %NEXT_PC, align 8
  %6668 = add i64 %6667, 3
  %6669 = load ptr, ptr %MEMORY, align 8
  %6670 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %6669, ptr %state, i64 %6668, ptr %NEXT_PC)
  store ptr %6670, ptr %MEMORY, align 8
  br label %bb_5389880415

bb_5389880412:                                    ; preds = %bb_5389880378
  %6671 = load i64, ptr %NEXT_PC, align 8
  store i64 %6671, ptr %PC, align 8
  %6672 = add i64 %6671, 3
  store i64 %6672, ptr %NEXT_PC, align 8
  %6673 = load i32, ptr %R9D, align 4
  %6674 = zext i32 %6673 to i64
  %6675 = load ptr, ptr %MEMORY, align 8
  %6676 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6675, ptr %state, ptr %RDX, i64 %6674)
  store ptr %6676, ptr %MEMORY, align 8
  br label %bb_5389880415

bb_5389880415:                                    ; preds = %bb_5389880412, %bb_5389880382
  %6677 = load i64, ptr %NEXT_PC, align 8
  store i64 %6677, ptr %PC, align 8
  %6678 = add i64 %6677, 6
  store i64 %6678, ptr %NEXT_PC, align 8
  %6679 = load ptr, ptr %MEMORY, align 8
  %6680 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %6679, ptr %state, ptr %R8, i64 134217736)
  store ptr %6680, ptr %MEMORY, align 8
  %6681 = load i64, ptr %NEXT_PC, align 8
  store i64 %6681, ptr %PC, align 8
  %6682 = add i64 %6681, 3
  store i64 %6682, ptr %NEXT_PC, align 8
  %6683 = load i64, ptr %R12, align 8
  %6684 = load ptr, ptr %MEMORY, align 8
  %6685 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6684, ptr %state, ptr %RCX, i64 %6683)
  store ptr %6685, ptr %MEMORY, align 8
  %6686 = load i64, ptr %NEXT_PC, align 8
  store i64 %6686, ptr %PC, align 8
  %6687 = add i64 %6686, 5
  store i64 %6687, ptr %NEXT_PC, align 8
  %6688 = load i64, ptr %NEXT_PC, align 8
  %6689 = sub i64 %6688, 646797
  %6690 = load i64, ptr %NEXT_PC, align 8
  %6691 = load ptr, ptr %MEMORY, align 8
  %6692 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %6691, ptr %state, i64 %6689, ptr %NEXT_PC, i64 %6690, ptr %RETURN_PC)
  store ptr %6692, ptr %MEMORY, align 8
  %6693 = load i64, ptr %NEXT_PC, align 8
  store i64 %6693, ptr %PC, align 8
  %6694 = add i64 %6693, 5
  store i64 %6694, ptr %NEXT_PC, align 8
  %6695 = load i64, ptr %R12, align 8
  %6696 = add i64 %6695, 8
  %6697 = load ptr, ptr %MEMORY, align 8
  %6698 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6697, ptr %state, ptr %RCX, i64 %6696)
  store ptr %6698, ptr %MEMORY, align 8
  br label %bb_5389880434

bb_5389880434:                                    ; preds = %bb_5389880415, %bb_5389880369
  %6699 = load i64, ptr %NEXT_PC, align 8
  store i64 %6699, ptr %PC, align 8
  %6700 = add i64 %6699, 3
  store i64 %6700, ptr %NEXT_PC, align 8
  %6701 = load i64, ptr %RCX, align 8
  %6702 = add i64 %6701, 1
  %6703 = load ptr, ptr %MEMORY, align 8
  %6704 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %6703, ptr %state, ptr %RAX, i64 %6702)
  store ptr %6704, ptr %MEMORY, align 8
  %6705 = load i64, ptr %NEXT_PC, align 8
  store i64 %6705, ptr %PC, align 8
  %6706 = add i64 %6705, 3
  store i64 %6706, ptr %NEXT_PC, align 8
  %6707 = load i32, ptr %ECX, align 4
  %6708 = zext i32 %6707 to i64
  %6709 = load ptr, ptr %MEMORY, align 8
  %6710 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %6709, ptr %state, ptr %RCX, i64 %6708)
  store ptr %6710, ptr %MEMORY, align 8
  %6711 = load i64, ptr %NEXT_PC, align 8
  store i64 %6711, ptr %PC, align 8
  %6712 = add i64 %6711, 5
  store i64 %6712, ptr %NEXT_PC, align 8
  %6713 = load i64, ptr %R12, align 8
  %6714 = add i64 %6713, 8
  %6715 = load i32, ptr %EAX, align 4
  %6716 = zext i32 %6715 to i64
  %6717 = load ptr, ptr %MEMORY, align 8
  %6718 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6717, ptr %state, i64 %6714, i64 %6716)
  store ptr %6718, ptr %MEMORY, align 8
  %6719 = load i64, ptr %NEXT_PC, align 8
  store i64 %6719, ptr %PC, align 8
  %6720 = add i64 %6719, 4
  store i64 %6720, ptr %NEXT_PC, align 8
  %6721 = load i64, ptr %R12, align 8
  %6722 = load ptr, ptr %MEMORY, align 8
  %6723 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %6722, ptr %state, ptr %RAX, i64 %6721)
  store ptr %6723, ptr %MEMORY, align 8
  %6724 = load i64, ptr %NEXT_PC, align 8
  store i64 %6724, ptr %PC, align 8
  %6725 = add i64 %6724, 4
  store i64 %6725, ptr %NEXT_PC, align 8
  %6726 = load i64, ptr %RAX, align 8
  %6727 = load i64, ptr %RCX, align 8
  %6728 = mul i64 %6727, 8
  %6729 = add i64 %6726, %6728
  %6730 = load ptr, ptr %MEMORY, align 8
  %6731 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %6730, ptr %state, ptr %RDX, i64 %6729)
  store ptr %6731, ptr %MEMORY, align 8
  %6732 = load i64, ptr %NEXT_PC, align 8
  store i64 %6732, ptr %PC, align 8
  %6733 = add i64 %6732, 3
  store i64 %6733, ptr %NEXT_PC, align 8
  %6734 = load i64, ptr %RSI, align 8
  %6735 = load i64, ptr %RSI, align 8
  %6736 = load ptr, ptr %MEMORY, align 8
  %6737 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6736, ptr %state, i64 %6734, i64 %6735)
  store ptr %6737, ptr %MEMORY, align 8
  %6738 = load i64, ptr %NEXT_PC, align 8
  store i64 %6738, ptr %PC, align 8
  %6739 = add i64 %6738, 2
  store i64 %6739, ptr %NEXT_PC, align 8
  %6740 = load i64, ptr %NEXT_PC, align 8
  %6741 = add i64 %6740, 8
  %6742 = load i64, ptr %NEXT_PC, align 8
  %6743 = load ptr, ptr %MEMORY, align 8
  %6744 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6743, ptr %state, ptr %BRANCH_TAKEN, i64 %6741, i64 %6742, ptr %NEXT_PC)
  store ptr %6744, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880466, label %bb_5389880458

bb_5389880458:                                    ; preds = %bb_5389880434
  %6745 = load i64, ptr %NEXT_PC, align 8
  store i64 %6745, ptr %PC, align 8
  %6746 = add i64 %6745, 4
  store i64 %6746, ptr %NEXT_PC, align 8
  %6747 = load i64, ptr %RSI, align 8
  %6748 = add i64 %6747, 48
  %6749 = load ptr, ptr %MEMORY, align 8
  %6750 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %6749, ptr %state, ptr %RAX, i64 %6748)
  store ptr %6750, ptr %MEMORY, align 8
  %6751 = load i64, ptr %NEXT_PC, align 8
  store i64 %6751, ptr %PC, align 8
  %6752 = add i64 %6751, 2
  store i64 %6752, ptr %NEXT_PC, align 8
  %6753 = load i64, ptr %RSI, align 8
  %6754 = load i64, ptr %RSI, align 8
  %6755 = load ptr, ptr %MEMORY, align 8
  %6756 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6755, ptr %state, i64 %6753, i64 %6754)
  store ptr %6756, ptr %MEMORY, align 8
  %6757 = load i64, ptr %NEXT_PC, align 8
  store i64 %6757, ptr %PC, align 8
  %6758 = add i64 %6757, 2
  store i64 %6758, ptr %NEXT_PC, align 8
  %6759 = load i64, ptr %RAX, align 8
  %6760 = load i64, ptr %RAX, align 8
  %6761 = load ptr, ptr %MEMORY, align 8
  %6762 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6761, ptr %state, i64 %6759, i64 %6760)
  store ptr %6762, ptr %MEMORY, align 8
  br label %bb_5389880466

bb_5389880466:                                    ; preds = %bb_5389880458, %bb_5389880434
  %6763 = load i64, ptr %NEXT_PC, align 8
  store i64 %6763, ptr %PC, align 8
  %6764 = add i64 %6763, 3
  store i64 %6764, ptr %NEXT_PC, align 8
  %6765 = load i64, ptr %RDX, align 8
  %6766 = load i64, ptr %RSI, align 8
  %6767 = load ptr, ptr %MEMORY, align 8
  %6768 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6767, ptr %state, i64 %6765, i64 %6766)
  store ptr %6768, ptr %MEMORY, align 8
  br label %bb_5389880469

bb_5389880469:                                    ; preds = %bb_5389880466, %bb_5389880359
  %6769 = load i64, ptr %NEXT_PC, align 8
  store i64 %6769, ptr %PC, align 8
  %6770 = add i64 %6769, 3
  store i64 %6770, ptr %NEXT_PC, align 8
  %6771 = load i64, ptr %RSI, align 8
  %6772 = load i64, ptr %RSI, align 8
  %6773 = load ptr, ptr %MEMORY, align 8
  %6774 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6773, ptr %state, i64 %6771, i64 %6772)
  store ptr %6774, ptr %MEMORY, align 8
  %6775 = load i64, ptr %NEXT_PC, align 8
  store i64 %6775, ptr %PC, align 8
  %6776 = add i64 %6775, 6
  store i64 %6776, ptr %NEXT_PC, align 8
  %6777 = load i64, ptr %NEXT_PC, align 8
  %6778 = add i64 %6777, 668
  %6779 = load i64, ptr %NEXT_PC, align 8
  %6780 = load ptr, ptr %MEMORY, align 8
  %6781 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6780, ptr %state, ptr %BRANCH_TAKEN, i64 %6778, i64 %6779, ptr %NEXT_PC)
  store ptr %6781, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880478:                                    ; No predecessors!
  %6782 = load i64, ptr %NEXT_PC, align 8
  store i64 %6782, ptr %PC, align 8
  %6783 = add i64 %6782, 3
  store i64 %6783, ptr %NEXT_PC, align 8
  %6784 = load i64, ptr %RSI, align 8
  %6785 = load ptr, ptr %MEMORY, align 8
  %6786 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6785, ptr %state, ptr %RCX, i64 %6784)
  store ptr %6786, ptr %MEMORY, align 8
  %6787 = load i64, ptr %NEXT_PC, align 8
  store i64 %6787, ptr %PC, align 8
  %6788 = add i64 %6787, 5
  store i64 %6788, ptr %NEXT_PC, align 8
  %6789 = load i64, ptr %NEXT_PC, align 8
  %6790 = add i64 %6789, 655
  %6791 = load ptr, ptr %MEMORY, align 8
  %6792 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %6791, ptr %state, i64 %6790, ptr %NEXT_PC)
  store ptr %6792, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880486:                                    ; preds = %bb_5389880285
  %6793 = load i64, ptr %NEXT_PC, align 8
  store i64 %6793, ptr %PC, align 8
  %6794 = add i64 %6793, 2
  store i64 %6794, ptr %NEXT_PC, align 8
  %6795 = load i64, ptr %RBX, align 8
  %6796 = load i32, ptr %EBX, align 4
  %6797 = zext i32 %6796 to i64
  %6798 = load ptr, ptr %MEMORY, align 8
  %6799 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %6798, ptr %state, ptr %RBX, i64 %6795, i64 %6797)
  store ptr %6799, ptr %MEMORY, align 8
  %6800 = load i64, ptr %NEXT_PC, align 8
  store i64 %6800, ptr %PC, align 8
  %6801 = add i64 %6800, 4
  store i64 %6801, ptr %NEXT_PC, align 8
  %6802 = load i32, ptr %R8D, align 4
  %6803 = zext i32 %6802 to i64
  %6804 = load ptr, ptr %MEMORY, align 8
  %6805 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %6804, ptr %state, i64 %6803, i64 1)
  store ptr %6805, ptr %MEMORY, align 8
  %6806 = load i64, ptr %NEXT_PC, align 8
  store i64 %6806, ptr %PC, align 8
  %6807 = add i64 %6806, 2
  store i64 %6807, ptr %NEXT_PC, align 8
  %6808 = load i64, ptr %NEXT_PC, align 8
  %6809 = add i64 %6808, 118
  %6810 = load i64, ptr %NEXT_PC, align 8
  %6811 = load ptr, ptr %MEMORY, align 8
  %6812 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6811, ptr %state, ptr %BRANCH_TAKEN, i64 %6809, i64 %6810, ptr %NEXT_PC)
  store ptr %6812, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880612, label %bb_5389880494

bb_5389880494:                                    ; preds = %bb_5389880486
  %6813 = load i64, ptr %NEXT_PC, align 8
  store i64 %6813, ptr %PC, align 8
  %6814 = add i64 %6813, 3
  store i64 %6814, ptr %NEXT_PC, align 8
  %6815 = load i64, ptr %R14, align 8
  %6816 = load ptr, ptr %MEMORY, align 8
  %6817 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6816, ptr %state, ptr %RAX, i64 %6815)
  store ptr %6817, ptr %MEMORY, align 8
  %6818 = load i64, ptr %NEXT_PC, align 8
  store i64 %6818, ptr %PC, align 8
  %6819 = add i64 %6818, 7
  store i64 %6819, ptr %NEXT_PC, align 8
  %6820 = load i64, ptr %NEXT_PC, align 8
  %6821 = add i64 %6820, 26995904
  %6822 = load ptr, ptr %MEMORY, align 8
  %6823 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %6822, ptr %state, ptr %RCX, i64 %6821)
  store ptr %6823, ptr %MEMORY, align 8
  %6824 = load i64, ptr %NEXT_PC, align 8
  store i64 %6824, ptr %PC, align 8
  %6825 = add i64 %6824, 4
  store i64 %6825, ptr %NEXT_PC, align 8
  %6826 = load i64, ptr %RAX, align 8
  %6827 = load i64, ptr %RCX, align 8
  %6828 = mul i64 %6827, 1
  %6829 = add i64 %6826, %6828
  %6830 = load ptr, ptr %MEMORY, align 8
  %6831 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %6830, ptr %state, ptr %RAX, i64 %6829)
  store ptr %6831, ptr %MEMORY, align 8
  %6832 = load i64, ptr %NEXT_PC, align 8
  store i64 %6832, ptr %PC, align 8
  %6833 = add i64 %6832, 6
  store i64 %6833, ptr %NEXT_PC, align 8
  %6834 = load i8, ptr %AL, align 1
  %6835 = zext i8 %6834 to i64
  %6836 = load i64, ptr %NEXT_PC, align 8
  %6837 = add i64 %6836, 12812215
  %6838 = load ptr, ptr %MEMORY, align 8
  %6839 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %6838, ptr %state, i64 %6835, i64 %6837)
  store ptr %6839, ptr %MEMORY, align 8
  %6840 = load i64, ptr %NEXT_PC, align 8
  store i64 %6840, ptr %PC, align 8
  %6841 = add i64 %6840, 2
  store i64 %6841, ptr %NEXT_PC, align 8
  %6842 = load i64, ptr %NEXT_PC, align 8
  %6843 = add i64 %6842, 96
  %6844 = load i64, ptr %NEXT_PC, align 8
  %6845 = load ptr, ptr %MEMORY, align 8
  %6846 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6845, ptr %state, ptr %BRANCH_TAKEN, i64 %6843, i64 %6844, ptr %NEXT_PC)
  store ptr %6846, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880612, label %bb_5389880516

bb_5389880516:                                    ; preds = %bb_5389880494
  %6847 = load i64, ptr %NEXT_PC, align 8
  store i64 %6847, ptr %PC, align 8
  %6848 = add i64 %6847, 3
  store i64 %6848, ptr %NEXT_PC, align 8
  %6849 = load i64, ptr %RSI, align 8
  %6850 = add i64 %6849, 40
  %6851 = load ptr, ptr %MEMORY, align 8
  %6852 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6851, ptr %state, ptr %RDI, i64 %6850)
  store ptr %6852, ptr %MEMORY, align 8
  %6853 = load i64, ptr %NEXT_PC, align 8
  store i64 %6853, ptr %PC, align 8
  %6854 = add i64 %6853, 3
  store i64 %6854, ptr %NEXT_PC, align 8
  %6855 = load i64, ptr %RDI, align 8
  %6856 = load i32, ptr %R8D, align 4
  %6857 = zext i32 %6856 to i64
  %6858 = load ptr, ptr %MEMORY, align 8
  %6859 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %6858, ptr %state, ptr %RDI, i64 %6855, i64 %6857)
  store ptr %6859, ptr %MEMORY, align 8
  %6860 = load i64, ptr %NEXT_PC, align 8
  store i64 %6860, ptr %PC, align 8
  %6861 = add i64 %6860, 3
  store i64 %6861, ptr %NEXT_PC, align 8
  %6862 = load i32, ptr %EDI, align 4
  %6863 = zext i32 %6862 to i64
  %6864 = load ptr, ptr %MEMORY, align 8
  %6865 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %6864, ptr %state, ptr %RBP, i64 %6863)
  store ptr %6865, ptr %MEMORY, align 8
  %6866 = load i64, ptr %NEXT_PC, align 8
  store i64 %6866, ptr %PC, align 8
  %6867 = add i64 %6866, 2
  store i64 %6867, ptr %NEXT_PC, align 8
  %6868 = load i64, ptr %NEXT_PC, align 8
  %6869 = add i64 %6868, 124
  %6870 = load i64, ptr %NEXT_PC, align 8
  %6871 = load ptr, ptr %MEMORY, align 8
  %6872 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6871, ptr %state, ptr %BRANCH_TAKEN, i64 %6869, i64 %6870, ptr %NEXT_PC)
  store ptr %6872, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880527:                                    ; No predecessors!
  %6873 = load i64, ptr %NEXT_PC, align 8
  store i64 %6873, ptr %PC, align 8
  %6874 = add i64 %6873, 4
  store i64 %6874, ptr %NEXT_PC, align 8
  %6875 = load i64, ptr %RBP, align 8
  %6876 = load ptr, ptr %MEMORY, align 8
  %6877 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %6876, ptr %state, ptr %R13, i64 %6875, i64 56)
  store ptr %6877, ptr %MEMORY, align 8
  br label %bb_5389880531

bb_5389880531:                                    ; preds = %bb_5389880603, %bb_5389880527
  %6878 = load i64, ptr %NEXT_PC, align 8
  store i64 %6878, ptr %PC, align 8
  %6879 = add i64 %6878, 7
  store i64 %6879, ptr %NEXT_PC, align 8
  %6880 = load i64, ptr %R14, align 8
  %6881 = add i64 %6880, 272
  %6882 = load ptr, ptr %MEMORY, align 8
  %6883 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %6882, ptr %state, ptr %RDX, i64 %6881)
  store ptr %6883, ptr %MEMORY, align 8
  %6884 = load i64, ptr %NEXT_PC, align 8
  store i64 %6884, ptr %PC, align 8
  %6885 = add i64 %6884, 3
  store i64 %6885, ptr %NEXT_PC, align 8
  %6886 = load i64, ptr %RBP, align 8
  %6887 = load i64, ptr %RBP, align 8
  %6888 = load ptr, ptr %MEMORY, align 8
  %6889 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6888, ptr %state, i64 %6886, i64 %6887)
  store ptr %6889, ptr %MEMORY, align 8
  %6890 = load i64, ptr %NEXT_PC, align 8
  store i64 %6890, ptr %PC, align 8
  %6891 = add i64 %6890, 2
  store i64 %6891, ptr %NEXT_PC, align 8
  %6892 = load i64, ptr %NEXT_PC, align 8
  %6893 = add i64 %6892, 15
  %6894 = load i64, ptr %NEXT_PC, align 8
  %6895 = load ptr, ptr %MEMORY, align 8
  %6896 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6895, ptr %state, ptr %BRANCH_TAKEN, i64 %6893, i64 %6894, ptr %NEXT_PC)
  store ptr %6896, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880558, label %bb_5389880543

bb_5389880543:                                    ; preds = %bb_5389880531
  %6897 = load i64, ptr %NEXT_PC, align 8
  store i64 %6897, ptr %PC, align 8
  %6898 = add i64 %6897, 3
  store i64 %6898, ptr %NEXT_PC, align 8
  %6899 = load i32, ptr %EDI, align 4
  %6900 = zext i32 %6899 to i64
  %6901 = load i64, ptr %RSI, align 8
  %6902 = add i64 %6901, 40
  %6903 = load ptr, ptr %MEMORY, align 8
  %6904 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6903, ptr %state, i64 %6900, i64 %6902)
  store ptr %6904, ptr %MEMORY, align 8
  %6905 = load i64, ptr %NEXT_PC, align 8
  store i64 %6905, ptr %PC, align 8
  %6906 = add i64 %6905, 2
  store i64 %6906, ptr %NEXT_PC, align 8
  %6907 = load i64, ptr %NEXT_PC, align 8
  %6908 = add i64 %6907, 10
  %6909 = load i64, ptr %NEXT_PC, align 8
  %6910 = load ptr, ptr %MEMORY, align 8
  %6911 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6910, ptr %state, ptr %BRANCH_TAKEN, i64 %6908, i64 %6909, ptr %NEXT_PC)
  store ptr %6911, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880558, label %bb_5389880548

bb_5389880548:                                    ; preds = %bb_5389880543
  %6912 = load i64, ptr %NEXT_PC, align 8
  store i64 %6912, ptr %PC, align 8
  %6913 = add i64 %6912, 4
  store i64 %6913, ptr %NEXT_PC, align 8
  %6914 = load i64, ptr %RSI, align 8
  %6915 = add i64 %6914, 32
  %6916 = load ptr, ptr %MEMORY, align 8
  %6917 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %6916, ptr %state, ptr %RAX, i64 %6915)
  store ptr %6917, ptr %MEMORY, align 8
  %6918 = load i64, ptr %NEXT_PC, align 8
  store i64 %6918, ptr %PC, align 8
  %6919 = add i64 %6918, 4
  store i64 %6919, ptr %NEXT_PC, align 8
  %6920 = load i64, ptr %RAX, align 8
  %6921 = load i64, ptr %R13, align 8
  %6922 = mul i64 %6921, 1
  %6923 = add i64 %6920, %6922
  %6924 = load ptr, ptr %MEMORY, align 8
  %6925 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %6924, ptr %state, ptr %RAX, i64 %6923)
  store ptr %6925, ptr %MEMORY, align 8
  %6926 = load i64, ptr %NEXT_PC, align 8
  store i64 %6926, ptr %PC, align 8
  %6927 = add i64 %6926, 2
  store i64 %6927, ptr %NEXT_PC, align 8
  %6928 = load i64, ptr %NEXT_PC, align 8
  %6929 = add i64 %6928, 2
  %6930 = load ptr, ptr %MEMORY, align 8
  %6931 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %6930, ptr %state, i64 %6929, ptr %NEXT_PC)
  store ptr %6931, ptr %MEMORY, align 8
  br label %bb_5389880560

bb_5389880558:                                    ; preds = %bb_5389880543, %bb_5389880531
  %6932 = load i64, ptr %NEXT_PC, align 8
  store i64 %6932, ptr %PC, align 8
  %6933 = add i64 %6932, 2
  store i64 %6933, ptr %NEXT_PC, align 8
  %6934 = load i32, ptr %EBX, align 4
  %6935 = zext i32 %6934 to i64
  %6936 = load ptr, ptr %MEMORY, align 8
  %6937 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6936, ptr %state, ptr %RAX, i64 %6935)
  store ptr %6937, ptr %MEMORY, align 8
  br label %bb_5389880560

bb_5389880560:                                    ; preds = %bb_5389880558, %bb_5389880548
  %6938 = load i64, ptr %NEXT_PC, align 8
  store i64 %6938, ptr %PC, align 8
  %6939 = add i64 %6938, 3
  store i64 %6939, ptr %NEXT_PC, align 8
  %6940 = load i32, ptr %EAX, align 4
  %6941 = zext i32 %6940 to i64
  %6942 = load ptr, ptr %MEMORY, align 8
  %6943 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6942, ptr %state, ptr %R15, i64 %6941)
  store ptr %6943, ptr %MEMORY, align 8
  %6944 = load i64, ptr %NEXT_PC, align 8
  store i64 %6944, ptr %PC, align 8
  %6945 = add i64 %6944, 3
  store i64 %6945, ptr %NEXT_PC, align 8
  %6946 = load i64, ptr %R15, align 8
  %6947 = load i64, ptr %RCX, align 8
  %6948 = load ptr, ptr %MEMORY, align 8
  %6949 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %6948, ptr %state, ptr %R15, i64 %6946, i64 %6947)
  store ptr %6949, ptr %MEMORY, align 8
  %6950 = load i64, ptr %NEXT_PC, align 8
  store i64 %6950, ptr %PC, align 8
  %6951 = add i64 %6950, 7
  store i64 %6951, ptr %NEXT_PC, align 8
  %6952 = load i64, ptr %R14, align 8
  %6953 = add i64 %6952, 268
  %6954 = load i32, ptr %EBX, align 4
  %6955 = zext i32 %6954 to i64
  %6956 = load ptr, ptr %MEMORY, align 8
  %6957 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %6956, ptr %state, i64 %6953, i64 %6955)
  store ptr %6957, ptr %MEMORY, align 8
  %6958 = load i64, ptr %NEXT_PC, align 8
  store i64 %6958, ptr %PC, align 8
  %6959 = add i64 %6958, 2
  store i64 %6959, ptr %NEXT_PC, align 8
  %6960 = load i64, ptr %NEXT_PC, align 8
  %6961 = add i64 %6960, 3
  %6962 = load i64, ptr %NEXT_PC, align 8
  %6963 = load ptr, ptr %MEMORY, align 8
  %6964 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6963, ptr %state, ptr %BRANCH_TAKEN, i64 %6961, i64 %6962, ptr %NEXT_PC)
  store ptr %6964, ptr %MEMORY, align 8
  br i1 true, label %bb_5389880578, label %bb_5389880575

bb_5389880575:                                    ; preds = %bb_5389880560
  %6965 = load i64, ptr %NEXT_PC, align 8
  store i64 %6965, ptr %PC, align 8
  %6966 = add i64 %6965, 3
  store i64 %6966, ptr %NEXT_PC, align 8
  %6967 = load i64, ptr %RDX, align 8
  %6968 = load ptr, ptr %MEMORY, align 8
  %6969 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %6968, ptr %state, ptr %RDX, i64 %6967)
  store ptr %6969, ptr %MEMORY, align 8
  br label %bb_5389880578

bb_5389880578:                                    ; preds = %bb_5389880575, %bb_5389880560
  %6970 = load i64, ptr %NEXT_PC, align 8
  store i64 %6970, ptr %PC, align 8
  %6971 = add i64 %6970, 3
  store i64 %6971, ptr %NEXT_PC, align 8
  %6972 = load i64, ptr %R15, align 8
  %6973 = load ptr, ptr %MEMORY, align 8
  %6974 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6973, ptr %state, ptr %RCX, i64 %6972)
  store ptr %6974, ptr %MEMORY, align 8
  %6975 = load i64, ptr %NEXT_PC, align 8
  store i64 %6975, ptr %PC, align 8
  %6976 = add i64 %6975, 5
  store i64 %6976, ptr %NEXT_PC, align 8
  %6977 = load i64, ptr %NEXT_PC, align 8
  %6978 = add i64 %6977, 11851517
  %6979 = load i64, ptr %NEXT_PC, align 8
  %6980 = load ptr, ptr %MEMORY, align 8
  %6981 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %6980, ptr %state, i64 %6978, ptr %NEXT_PC, i64 %6979, ptr %RETURN_PC)
  store ptr %6981, ptr %MEMORY, align 8
  %6982 = load i64, ptr %NEXT_PC, align 8
  store i64 %6982, ptr %PC, align 8
  %6983 = add i64 %6982, 3
  store i64 %6983, ptr %NEXT_PC, align 8
  %6984 = load i64, ptr %RAX, align 8
  %6985 = load i64, ptr %R15, align 8
  %6986 = load ptr, ptr %MEMORY, align 8
  %6987 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %6986, ptr %state, i64 %6984, i64 %6985)
  store ptr %6987, ptr %MEMORY, align 8
  %6988 = load i64, ptr %NEXT_PC, align 8
  store i64 %6988, ptr %PC, align 8
  %6989 = add i64 %6988, 2
  store i64 %6989, ptr %NEXT_PC, align 8
  %6990 = load i64, ptr %NEXT_PC, align 8
  %6991 = add i64 %6990, 44
  %6992 = load i64, ptr %NEXT_PC, align 8
  %6993 = load ptr, ptr %MEMORY, align 8
  %6994 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %6993, ptr %state, ptr %BRANCH_TAKEN, i64 %6991, i64 %6992, ptr %NEXT_PC)
  store ptr %6994, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880591:                                    ; No predecessors!
  %6995 = load i64, ptr %NEXT_PC, align 8
  store i64 %6995, ptr %PC, align 8
  %6996 = add i64 %6995, 2
  store i64 %6996, ptr %NEXT_PC, align 8
  %6997 = load i64, ptr %RDI, align 8
  %6998 = load ptr, ptr %MEMORY, align 8
  %6999 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %6998, ptr %state, ptr %RDI, i64 %6997)
  store ptr %6999, ptr %MEMORY, align 8
  %7000 = load i64, ptr %NEXT_PC, align 8
  store i64 %7000, ptr %PC, align 8
  %7001 = add i64 %7000, 4
  store i64 %7001, ptr %NEXT_PC, align 8
  %7002 = load i64, ptr %R13, align 8
  %7003 = load ptr, ptr %MEMORY, align 8
  %7004 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %7003, ptr %state, ptr %R13, i64 %7002, i64 56)
  store ptr %7004, ptr %MEMORY, align 8
  %7005 = load i64, ptr %NEXT_PC, align 8
  store i64 %7005, ptr %PC, align 8
  %7006 = add i64 %7005, 4
  store i64 %7006, ptr %NEXT_PC, align 8
  %7007 = load i64, ptr %RBP, align 8
  %7008 = load ptr, ptr %MEMORY, align 8
  %7009 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %7008, ptr %state, ptr %RBP, i64 %7007, i64 1)
  store ptr %7009, ptr %MEMORY, align 8
  %7010 = load i64, ptr %NEXT_PC, align 8
  store i64 %7010, ptr %PC, align 8
  %7011 = add i64 %7010, 2
  store i64 %7011, ptr %NEXT_PC, align 8
  %7012 = load i64, ptr %NEXT_PC, align 8
  %7013 = add i64 %7012, 32
  %7014 = load i64, ptr %NEXT_PC, align 8
  %7015 = load ptr, ptr %MEMORY, align 8
  %7016 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %7015, ptr %state, ptr %BRANCH_TAKEN, i64 %7013, i64 %7014, ptr %NEXT_PC)
  store ptr %7016, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389880603:                                    ; No predecessors!
  %7017 = load i64, ptr %NEXT_PC, align 8
  store i64 %7017, ptr %PC, align 8
  %7018 = add i64 %7017, 7
  store i64 %7018, ptr %NEXT_PC, align 8
  %7019 = load i64, ptr %NEXT_PC, align 8
  %7020 = add i64 %7019, 26995798
  %7021 = load ptr, ptr %MEMORY, align 8
  %7022 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %7021, ptr %state, ptr %RCX, i64 %7020)
  store ptr %7022, ptr %MEMORY, align 8
  %7023 = load i64, ptr %NEXT_PC, align 8
  store i64 %7023, ptr %PC, align 8
  %7024 = add i64 %7023, 2
  store i64 %7024, ptr %NEXT_PC, align 8
  %7025 = load i64, ptr %NEXT_PC, align 8
  %7026 = sub i64 %7025, 81
  %7027 = load ptr, ptr %MEMORY, align 8
  %7028 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %7027, ptr %state, i64 %7026, ptr %NEXT_PC)
  store ptr %7028, ptr %MEMORY, align 8
  br label %bb_5389880531

bb_5389880612:                                    ; preds = %bb_5389880494, %bb_5389880486
  %7029 = load i64, ptr %NEXT_PC, align 8
  store i64 %7029, ptr %PC, align 8
  %7030 = add i64 %7029, 4
  store i64 %7030, ptr %NEXT_PC, align 8
  %7031 = load i64, ptr %R8, align 8
  %7032 = sub i64 %7031, 1
  %7033 = load ptr, ptr %MEMORY, align 8
  %7034 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %7033, ptr %state, ptr %RAX, i64 %7032)
  store ptr %7034, ptr %MEMORY, align 8
  %7035 = load i64, ptr %NEXT_PC, align 8
  store i64 %7035, ptr %PC, align 8
  %7036 = add i64 %7035, 3
  store i64 %7036, ptr %NEXT_PC, align 8
  %7037 = load i32, ptr %EAX, align 4
  %7038 = zext i32 %7037 to i64
  %7039 = load ptr, ptr %MEMORY, align 8
  %7040 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %7039, ptr %state, ptr %RCX, i64 %7038)
  store ptr %7040, ptr %MEMORY, align 8
  %7041 = load i64, ptr %NEXT_PC, align 8
  store i64 %7041, ptr %PC, align 8
  %7042 = add i64 %7041, 4
  store i64 %7042, ptr %NEXT_PC, align 8
  %7043 = load i64, ptr %R14, align 8
  %7044 = load i64, ptr %RCX, align 8
  %7045 = mul i64 %7044, 4
  %7046 = add i64 %7043, %7045
  %7047 = load ptr, ptr %MEMORY, align 8
  %7048 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %7047, ptr %state, ptr %RDX, i64 %7046)
  store ptr %7048, ptr %MEMORY, align 8
  %7049 = load i64, ptr %NEXT_PC, align 8
  store i64 %7049, ptr %PC, align 8
  %7050 = add i64 %7049, 3
  store i64 %7050, ptr %NEXT_PC, align 8
  %7051 = load i64, ptr %RSI, align 8
  %7052 = load ptr, ptr %MEMORY, align 8
  %7053 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %7052, ptr %state, ptr %RCX, i64 %7051)
  store ptr %7053, ptr %MEMORY, align 8
  ret ptr %memory
}

attributes #0 = { noduplicate noinline nounwind optnone "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { alwaysinline mustprogress nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #3 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #5 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }

!llvm.ident = !{!0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3, !4}

!0 = !{!"clang version 18.1.8"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"base.helper.semantics"}
!6 = !{[4 x i8] c"R8B\00"}
!7 = !{[5 x i8] c"R15D\00"}
!8 = !{[4 x i8] c"ECX\00"}
!9 = !{[3 x i8] c"AL\00"}
!10 = !{[4 x i8] c"R10\00"}
!11 = !{[3 x i8] c"CL\00"}
!12 = !{[5 x i8] c"R14D\00"}
!13 = !{[4 x i8] c"ESI\00"}
!14 = !{[4 x i8] c"EBP\00"}
!15 = !{[4 x i8] c"EDX\00"}
!16 = !{[4 x i8] c"R11\00"}
!17 = !{[5 x i8] c"R12B\00"}
!18 = !{[4 x i8] c"EBX\00"}
!19 = !{[4 x i8] c"RBX\00"}
!20 = !{[4 x i8] c"DIL\00"}
!21 = !{[5 x i8] c"R13D\00"}
!22 = !{[5 x i8] c"R12D\00"}
!23 = !{[3 x i8] c"R9\00"}
!24 = !{[3 x i8] c"R8\00"}
!25 = !{[4 x i8] c"EAX\00"}
!26 = !{[4 x i8] c"RAX\00"}
!27 = !{[4 x i8] c"RCX\00"}
!28 = !{[4 x i8] c"RDX\00"}
!29 = !{[4 x i8] c"R9D\00"}
!30 = !{[4 x i8] c"EDI\00"}
!31 = !{[4 x i8] c"R15\00"}
!32 = !{[4 x i8] c"R14\00"}
!33 = !{[4 x i8] c"R13\00"}
!34 = !{[4 x i8] c"R12\00"}
!35 = !{[4 x i8] c"RBP\00"}
!36 = !{[4 x i8] c"R8D\00"}
!37 = !{[4 x i8] c"RDI\00"}
!38 = !{[4 x i8] c"RSI\00"}
!39 = !{[4 x i8] c"RSP\00"}
!40 = !{[3 x i8] c"PC\00"}
