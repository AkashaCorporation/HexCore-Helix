; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: wwzRetailEgs.exe
; Address: 0x14142fe90
; Size: 2250 bytes
; Architecture: amd64
; Generated: 2026-03-08T16:16:35.334Z
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
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

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

declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_uge(i1 noundef zeroext) #4

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_eq(i1 noundef zeroext) #0

declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_slt(i1 noundef zeroext) #4

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

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i64, i64) #2

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
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHLI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, ptr nocapture writeonly) #5

define ptr @lifted_5389876880(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
  %ECX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !6
  %AL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !7
  %R10 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 21, i32 0, i32 0, !remill_register !8
  %CL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !9
  %R14D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 29, i32 0, i32 0, !remill_register !10
  %ESI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 9, i32 0, i32 0, !remill_register !11
  %EBP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 15, i32 0, i32 0, !remill_register !12
  %EDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !13
  %R11 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 23, i32 0, i32 0, !remill_register !14
  %R12B = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 25, i32 0, i32 0, !remill_register !15
  %EBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !16
  %RBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !17
  %DIL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 11, i32 0, i32 0, !remill_register !18
  %R13D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 27, i32 0, i32 0, !remill_register !19
  %R12D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 25, i32 0, i32 0, !remill_register !20
  %R9 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 19, i32 0, i32 0, !remill_register !21
  %R8 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 17, i32 0, i32 0, !remill_register !22
  %EAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !23
  %RAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !24
  %RCX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !25
  %RDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !26
  %R9D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 19, i32 0, i32 0, !remill_register !27
  %EDI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 11, i32 0, i32 0, !remill_register !28
  %R15 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 31, i32 0, i32 0, !remill_register !29
  %R14 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 29, i32 0, i32 0, !remill_register !30
  %R13 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 27, i32 0, i32 0, !remill_register !31
  %R12 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 25, i32 0, i32 0, !remill_register !32
  %RBP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 15, i32 0, i32 0, !remill_register !33
  %R8D = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 17, i32 0, i32 0, !remill_register !34
  %RDI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 11, i32 0, i32 0, !remill_register !35
  %RSI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 9, i32 0, i32 0, !remill_register !36
  %RSP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 13, i32 0, i32 0, !remill_register !37
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
  %PC = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 33, i32 0, i32 0, !remill_register !38
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
  %542 = load i64, ptr %NEXT_PC, align 8
  store i64 %542, ptr %PC, align 8
  %543 = add i64 %542, 4
  store i64 %543, ptr %NEXT_PC, align 8
  %544 = load i64, ptr %RBP, align 8
  %545 = add i64 %544, 64
  %546 = load ptr, ptr %MEMORY, align 8
  %547 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %546, ptr %state, ptr %R12, i64 %545)
  store ptr %547, ptr %MEMORY, align 8
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
  %1037 = load i64, ptr %NEXT_PC, align 8
  store i64 %1037, ptr %PC, align 8
  %1038 = add i64 %1037, 4
  store i64 %1038, ptr %NEXT_PC, align 8
  %1039 = load i64, ptr %RBP, align 8
  %1040 = sub i64 %1039, 8
  %1041 = load ptr, ptr %MEMORY, align 8
  %1042 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %1041, ptr %state, ptr %R9, i64 %1040)
  store ptr %1042, ptr %MEMORY, align 8
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
  %2721 = load i64, ptr %NEXT_PC, align 8
  store i64 %2721, ptr %PC, align 8
  %2722 = add i64 %2721, 3
  store i64 %2722, ptr %NEXT_PC, align 8
  %2723 = load i64, ptr %R14, align 8
  %2724 = load ptr, ptr %MEMORY, align 8
  %2725 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %2724, ptr %state, ptr %RAX, i64 %2723)
  store ptr %2725, ptr %MEMORY, align 8
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
  %2922 = load i64, ptr %NEXT_PC, align 8
  store i64 %2922, ptr %PC, align 8
  %2923 = add i64 %2922, 5
  store i64 %2923, ptr %NEXT_PC, align 8
  %2924 = load i64, ptr %RSP, align 8
  %2925 = add i64 %2924, 56
  %2926 = load ptr, ptr %MEMORY, align 8
  %2927 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %2926, ptr %state, ptr %RSI, i64 %2925)
  store ptr %2927, ptr %MEMORY, align 8
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
  %3038 = load i64, ptr %NEXT_PC, align 8
  store i64 %3038, ptr %PC, align 8
  %3039 = add i64 %3038, 5
  store i64 %3039, ptr %NEXT_PC, align 8
  %3040 = load i64, ptr %RSP, align 8
  %3041 = add i64 %3040, 48
  %3042 = load ptr, ptr %MEMORY, align 8
  %3043 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %3042, ptr %state, ptr %RBP, i64 %3041)
  store ptr %3043, ptr %MEMORY, align 8
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
  %3709 = load i64, ptr %NEXT_PC, align 8
  store i64 %3709, ptr %PC, align 8
  %3710 = add i64 %3709, 5
  store i64 %3710, ptr %NEXT_PC, align 8
  %3711 = load i64, ptr %NEXT_PC, align 8
  %3712 = add i64 %3711, 235
  %3713 = load ptr, ptr %MEMORY, align 8
  %3714 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %3713, ptr %state, i64 %3712, ptr %NEXT_PC)
  store ptr %3714, ptr %MEMORY, align 8
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
  %3763 = load i64, ptr %NEXT_PC, align 8
  store i64 %3763, ptr %PC, align 8
  %3764 = add i64 %3763, 2
  store i64 %3764, ptr %NEXT_PC, align 8
  %3765 = load i64, ptr %RAX, align 8
  %3766 = load i64, ptr %RAX, align 8
  %3767 = load ptr, ptr %MEMORY, align 8
  %3768 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %3767, ptr %state, i64 %3765, i64 %3766)
  store ptr %3768, ptr %MEMORY, align 8
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
!6 = !{[4 x i8] c"ECX\00"}
!7 = !{[3 x i8] c"AL\00"}
!8 = !{[4 x i8] c"R10\00"}
!9 = !{[3 x i8] c"CL\00"}
!10 = !{[5 x i8] c"R14D\00"}
!11 = !{[4 x i8] c"ESI\00"}
!12 = !{[4 x i8] c"EBP\00"}
!13 = !{[4 x i8] c"EDX\00"}
!14 = !{[4 x i8] c"R11\00"}
!15 = !{[5 x i8] c"R12B\00"}
!16 = !{[4 x i8] c"EBX\00"}
!17 = !{[4 x i8] c"RBX\00"}
!18 = !{[4 x i8] c"DIL\00"}
!19 = !{[5 x i8] c"R13D\00"}
!20 = !{[5 x i8] c"R12D\00"}
!21 = !{[3 x i8] c"R9\00"}
!22 = !{[3 x i8] c"R8\00"}
!23 = !{[4 x i8] c"EAX\00"}
!24 = !{[4 x i8] c"RAX\00"}
!25 = !{[4 x i8] c"RCX\00"}
!26 = !{[4 x i8] c"RDX\00"}
!27 = !{[4 x i8] c"R9D\00"}
!28 = !{[4 x i8] c"EDI\00"}
!29 = !{[4 x i8] c"R15\00"}
!30 = !{[4 x i8] c"R14\00"}
!31 = !{[4 x i8] c"R13\00"}
!32 = !{[4 x i8] c"R12\00"}
!33 = !{[4 x i8] c"RBP\00"}
!34 = !{[4 x i8] c"R8D\00"}
!35 = !{[4 x i8] c"RDI\00"}
!36 = !{[4 x i8] c"RSI\00"}
!37 = !{[4 x i8] c"RSP\00"}
!38 = !{[3 x i8] c"PC\00"}
